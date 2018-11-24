package org.roug.osnine;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Test;
import org.junit.Before;

class PIADummy extends PIA6821 {

    int outputValue = 0;

    boolean signalReceived = false;

    boolean outputCA2 = false;

    private PIAOutputPins keyboardMatrix = (int mask, int value, int oldValue) -> {
                outputValue = value & mask;
            };

    private PIASignal signalOut = (boolean state) -> { signalReceived = state; };
    private PIASignal signalCA2 = (boolean state) -> { outputCA2 = state; };

    PIADummy(int start, Bus8Motorola bus) {
        super(start, bus);
        setOutputCallback(PIA6821.B, keyboardMatrix);
        setIRQCallback(PIA6821.B, signalOut);
        setControlCallback(PIA6821.A, signalCA2);
    }
}

public class PIA6821Test {

    private static final int PIAADDR = 0xF000;
    private static final int DDRA = PIAADDR + 0;
    private static final int ORA = DDRA;
    private static final int CRA = PIAADDR + 1;
    private static final int DDRB = PIAADDR + 2;
    private static final int ORB = DDRB;
    private static final int CRB = PIAADDR + 3;

    private Bus8Motorola bus;
    private PIADummy pia;

    @Before
    public void createPIA() {
        bus = new BusStraight();
        pia = new PIADummy(PIAADDR, bus);
    }

    /**
     * Send 1 to an output line - ignored.
     * Send 1 to an input line - accepted
     */
    @Test
    public void sendToInputLines() {
        pia.store(CRA, 0);     // Select DDRA
        pia.store(DDRA, 0xF0); // Make top 4 bits output, the others input
        pia.store(CRA, 0x04);  // Select output register
        pia.store(ORA, 0xD0);
        pia.setInputLine(PIA6821.A, 5, false); // This should be ignored
        assertEquals(0xD0, pia.load(ORA));

        pia.setInputLine(PIA6821.A, 2, true);
        assertEquals(0xD4, pia.load(ORA));
        pia.setInputLine(PIA6821.A, 2, false);
        assertEquals(0xD0, pia.load(ORA));
    }


    @Test
    public void sendToOutputLines() {
        pia.store(CRB, 0);     // Select DDRB
        pia.store(DDRB, 0xF0); // Make top 4 bits output, the others input
        pia.store(CRB, 0x04);  // Select output register
        pia.store(ORB, 0xA3);
        assertEquals(0xA0, pia.load(ORB));
        assertEquals(0xA0, pia.outputValue);
    }

    @Test
    public void readDataDirectionRegisterA() {
        pia.store(CRA, 0);     // Select DDRA
        pia.store(DDRA, 0xF1);
        assertEquals(0xF1, pia.load(DDRA));
    }


    @Test
    public void readControlRegisterA() {
        pia.store(CRA, 0x33);
        assertEquals(0x33, pia.load(CRA));
    }
    /**
     * CB1 is an input interrupt line that can then send an IRQ to the CPU.
     * Plain test.
     */
    @Test
    public void signalCB1() {
        assertFalse(pia.signalReceived);
        pia.store(CRB, 0x05);  // Select output register and IRQ
        pia.signalC1(PIA6821.B);
        assertTrue(pia.signalReceived);
        pia.load(ORB);
        assertFalse(pia.signalReceived);
    }

    /**
     * Test that the interrupt happens on high-to-low transition.
     */
    @Test
    public void signalCB1onHighToLow() {
        assertFalse(pia.signalReceived);
        pia.store(CRB, PIA6821.BIT2 + PIA6821.BIT0);  // Select output register, IRQ and high-to-low.
        pia.signalC1(PIA6821.B, true);
        assertFalse(pia.signalReceived);
        pia.signalC1(PIA6821.B, false);
        assertTrue(pia.signalReceived);
    }


    /**
     * Test that the interrupt happens on low-to-high transition.
     * Low-to-high if bit 1 is true.
     */
    @Test
    public void signalCB1onLowToHigh() {
        assertFalse(pia.signalReceived);
        pia.store(CRB, PIA6821.BIT1 + PIA6821.BIT0);
        pia.signalC1(PIA6821.B, true);
        assertTrue(pia.signalReceived);
        pia.signalC1(PIA6821.B, false);
        assertTrue(pia.signalReceived);
    }


    /**
     * Block interrupts, and send signal to interrupt line.
     * Then turn on interrupts.
     */
    @Test
    public void signalCB1withBlockedIRQ() {
        assertFalse(pia.signalReceived);
        pia.store(CRB, PIA6821.BIT1);
        pia.signalC1(PIA6821.B, true);
        pia.signalC1(PIA6821.B, true); // Redundant repeat
        assertFalse(pia.signalReceived);
        pia.store(CRB, PIA6821.BIT1 + PIA6821.BIT0);
        assertTrue(pia.signalReceived);
        pia.signalC1(PIA6821.B, false);
        assertTrue(pia.signalReceived);
    }


    /**
     * Block interrupts, and send signal to interrupt line.
     * Then turn on interrupts.
     */
    @Test
    public void signalCB2withBlockedIRQ() {
        assertFalse(pia.signalReceived);
        pia.store(CRB, PIA6821.BIT4); // IRQ on low-to-high
        pia.signalC2(PIA6821.B, true);
        assertFalse(pia.signalReceived);
        pia.store(CRB, PIA6821.BIT4 + PIA6821.BIT3);
        assertTrue(pia.signalReceived);
        pia.signalC2(PIA6821.B, false);
        assertTrue(pia.signalReceived);
    }

    /**
     * Use CA2 as output when CA1 goes high.
     * CA2 goes low when reading output register A.
     */
    @Test
    public void useCA2asOutput() {
        // Set CA2 as output and OR
        pia.store(CRA, PIA6821.BIT5 + PIA6821.BIT2 + PIA6821.BIT1);
        pia.load(ORA);
        assertFalse(pia.outputCA2);
        pia.signalC1(PIA6821.A, true);
        assertTrue(pia.outputCA2);
        pia.load(ORA);
        assertFalse(pia.outputCA2);
    }

    /**
     * Use CA2 as plain output line.
     * This happens when bit 4 is high.
     */
    @Test
    public void useCA2asPlainPin() {
        pia.store(CRA, PIA6821.BIT5 + PIA6821.BIT4 + PIA6821.BIT2 + PIA6821.BIT1);
        pia.load(ORA);
        assertFalse(pia.outputCA2);
        pia.store(CRA, PIA6821.BIT5 + PIA6821.BIT4 + PIA6821.BIT3
                    + PIA6821.BIT2 + PIA6821.BIT1);
        
        assertTrue(pia.outputCA2);
        pia.store(CRA, PIA6821.BIT5 + PIA6821.BIT4 + PIA6821.BIT2 + PIA6821.BIT1);
        assertFalse(pia.outputCA2);
    }
}
