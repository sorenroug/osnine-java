package org.roug.osnine;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Test;

class PIADummy extends PIA6821 {

    int outputValue = 0;

    boolean signalReceived = false;

    private PIAOutputPins keyboardMatrix = (int mask, int value, int oldValue) -> {
                outputValue = value & mask;
            };

    private PIASignal signalOut = (boolean state) -> { signalReceived = state; };

    PIADummy(int start, Bus8Motorola bus) {
        super(start, bus);
        setOutputCallback(PIA6821.B, keyboardMatrix);
        setIRQCallback(PIA6821.B, signalOut);
    }
}

public class PIA6821Test {

    private static final int PIAADDR = 0xF000;
    private static final int DDRA = PIAADDR + PIA6821.DDRA;
    private static final int ORA = PIAADDR + PIA6821.ORA;
    private static final int CRA = PIAADDR + PIA6821.CRA;
    private static final int DDRB = PIAADDR + PIA6821.DDRB;
    private static final int ORB = PIAADDR + PIA6821.ORB;
    private static final int CRB = PIAADDR + PIA6821.CRB;

    /**
     * Send 1 to an output line - ignored.
     * Send 1 to an input line - accepted
     */
    @Test
    public void sendToInputLines() {
        Bus8Motorola bus = new BusStraight();
        PIADummy pia = new PIADummy(PIAADDR, bus);

        pia.store(CRA, 0);     // Select DDRA
        pia.store(DDRA, 0xF0); // Make top 4 bits output, the others input
        pia.store(CRA, 0x04);  // Select output register
        pia.store(ORA, 0xD0);
        pia.setInputLine(PIA6821.A, 5, false); // This should be ignored
        assertEquals(0xD0, pia.load(ORA));

        pia.setInputLine(PIA6821.A, 2, true);
        assertEquals(0xD4, pia.load(ORA));
    }


    @Test
    public void sendToOutputLines() {
        Bus8Motorola bus = new BusStraight();
        PIADummy pia = new PIADummy(PIAADDR, bus);

        pia.store(CRB, 0);     // Select DDRB
        pia.store(DDRB, 0xF0); // Make top 4 bits output, the others input
        pia.store(CRB, 0x04);  // Select output register
        pia.store(ORB, 0xA3);
        assertEquals(0xA0, pia.load(ORB));
        assertEquals(0xA0, pia.outputValue);
    }

    /**
     * CB1 is an input line that can then send an IRQ to the CPU.
     */
    @Test
    public void signalCB1() {
        Bus8Motorola bus = new BusStraight();
        PIADummy pia = new PIADummy(PIAADDR, bus);
        assertFalse(pia.signalReceived);
        pia.store(CRB, 0x05);  // Select output register and IRQ
        pia.signalC1(PIA6821.B);
        assertTrue(pia.signalReceived);
    }

}
