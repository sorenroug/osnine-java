package org.roug.osnine.mo5;

import org.roug.osnine.MemorySegment;
import org.roug.osnine.Bus8Motorola;

import java.util.Timer;
import java.util.TimerTask;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

interface Signal {
    void send(boolean state);
}

interface OutputPins {
    void send(int side, int mask, int value);
}

/**
 * 6821 PIA in a Thomsom MO5.
 * This chip is located at addresses 0xA7C0-0xA7C3.
 * The MO5 buzzer is controlled by bit 0 on $A7C1. By changing this bit
 * a quadratic signal is emitted. This is used by the PLAY instruction in BASIC.
 * An IRQ signal is sent 50 times a second and cancelled when the CPU reads $A7C3
 *
 * data port A (A7C0)
 *  bit 0: /FORME - Switch the screen RAM mapping between pixel and attribute RAMs
 *  bits 1-4: border color (R,G,B,P)
 *  bit 5: light pen button
 *  bit 6: tape drive data output
 *  bit 7: tape drive data input
 *  Bit 7 is low when no tape drive is plugged, and high when there is one.
 *  The monitor loading and saving code checks for this to detect the tape drive.
 *
 * data port B (A7C1)
 *  bit 0: sound output
 *  bits 1-3: keyboard column to scan
 *  bits 4-6: keyboard line to scan
 *  bit 7: state of key selected by the column and line
 *
 * Control ports (A7C2, A7C3)
 *  CA1: lightpen interrupt (IRQA is wired to 6809 FIRQ)
 *  CA2: tape drive motor control (output)
 *  CB1: 50Hz interrupt (IRQB is wired to 6809 IRQ)
 *  CB2: video incrustation enable (output)

 */
public class PIA6821MO5 extends MemorySegment {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(PIA6821MO5.class);

    public static final int A = 0;
    public static final int B = 1;

    public static final int BIT0 = 0x01;
    public static final int BIT1 = 0x02;
    public static final int BIT2 = 0x04;
    public static final int BIT3 = 0x08;
    public static final int BIT4 = 0x10;
    public static final int BIT5 = 0x20;
    public static final int BIT6 = 0x40;
    public static final int BIT7 = 0x80;

    /** Control bit for IRQ. */
    private static final int CIRQ = 0x01;

    /** Bit to select between the OR and DDR. */
    private static final int SELECT_OR = 0x04;

    // NOTE: the MO5 has swapped Register Select 0 and 1.
    protected static final int DDRA = 0;
    protected static final int ORA = 0;
    protected static final int DDRB = 1;
    protected static final int ORB = 1;
    protected static final int CRA = 2;
    protected static final int CRB = 3;

    private static final int CLOCKDELAY = 500;  // milliseconds
    /** On MO5 the interrupt is 50 times a second. */
    private static final int CLOCKPERIOD = 20;  // milliseconds

    private int[] outputRegister = new int[2];
    private int[] dataDirectionRegister = new int[2];
    private int[] controlRegister = new int[2];

    /** If PIA has raised IRQ on the bus. */
    private boolean[] activeIRQ = new boolean[2];

    private Signal[] irqOut = new Signal[2];

    private OutputPins[] pinOuts = new OutputPins[2];

    /** Reference to CPU for the purpose of sending IRQ. */
    private Bus8Motorola bus;
    private Screen screen;

    private ClockTick clocktask;

    public PIA6821MO5(Bus8Motorola bus, Screen screen) {
        this(bus, screen, true);
    }

    public PIA6821MO5(Bus8Motorola bus, Screen screen, boolean startClock) {
        super(0xA7C0, 0xA7C0 + 4);
        this.bus = bus;
        this.screen = screen;

        if (startClock) {
            LOGGER.debug("Starting heartbeat every 20 milliseconds");
            if (clocktask == null) {
                clocktask = new ClockTick(this);
                Timer timer = new Timer("clock", true);
                timer.schedule(clocktask, CLOCKDELAY, CLOCKPERIOD);
            }
        }
        irqOut[A] = (boolean state) -> bus.signalFIRQ(state);
        irqOut[B] = (boolean state) -> bus.signalIRQ(state);
        //irqOut[A] = (boolean state) -> {};

        pinOuts[A] = (int side, int mask, int value) -> {};
        pinOuts[B] = (int side, int mask, int value) -> keyboardMatrix(side, mask, value);
    }

    @Override
    protected int load(int addr) {
        switch (addr - getStartAddress()) {
            case DDRA:
                return readPeripheralRegister(A);
            case CRA:
                return readControlRegister(A);
            case DDRB:
                return readPeripheralRegister(B);
            case CRB:
                return readControlRegister(B);
        }
        return 0;
    }

    /**
     * Deactivate IRQ.
     */
    private void deactivateIRQ(int side) {
        if (activeIRQ[side]) {
            activeIRQ[side] = false;
            irqOut[side].send(false);
        }
        controlRegister[side] &= ~(BIT7 | BIT6); // Turn off IRQ bits.
    }

    /**
     * Read output register.
     * The interrupt flags are cleared as a result of a read
     * Peripheral Data Operation.
     */
    private int readPeripheralRegister(int side) {
        if (isBitOn(controlRegister[side], SELECT_OR)) {
            deactivateIRQ(side);
            return outputRegister[side] & 0xFF;
        } else {
            return dataDirectionRegister[side];
        }
    }

    private int readControlRegister(int side) {
        return controlRegister[side] & 0xFF;
    }

    /**
     * Write to a control register.
     * Bit 6 and 7 are read only.
     */
    private void writeControlRegister(int side, int val) {
        controlRegister[side] = (controlRegister[side] & 0xC0) | (val & 0x3F);
        LOGGER.info("CR Side: {} new value: {}", side, controlRegister[side]);
    }

    @Override
    protected void store(int addr, int operation) {
        switch (addr - getStartAddress()) {
            case DDRA:
                if (isBitOn(controlRegister[A], SELECT_OR)) {
                    if (isBitOn(operation, BIT0)) {
                        outputRegister[A] |= BIT0;
                        screen.setPixelBankActive(true);
                    } else {
                        outputRegister[A] &= ~BIT0;
                        screen.setPixelBankActive(false);
                    }
                    // Only write bits that are outputs in the data direction register.
                    outputRegister[A] = (outputRegister[A]
                            & (dataDirectionRegister[A] ^ 0xFF))
                            | (operation & dataDirectionRegister[A]);
                } else {
                    // Access data direction register
                    dataDirectionRegister[A] = operation;
                }
                break;
            case CRA:
                LOGGER.info("CRA Store: {} op: {}", addr, operation);
                if ((operation & CIRQ) == 0) {
                    disableIRQ(A);
                } else {
                    enableIRQ(A);
                }
                writeControlRegister(A, operation);
                break;
            case DDRB:
                if (isBitOn(controlRegister[B], SELECT_OR)) {
                    outputRegister[B] = (outputRegister[B]
                            & (dataDirectionRegister[B] ^ 0xFF))
                            | (operation & dataDirectionRegister[B]);
                    // Keyboard handler
                    if (screen.hasKeyPress(outputRegister[B] & 0x7E)) {
                        outputRegister[B] &= ~BIT7;
                    } else {
                        outputRegister[B] |= BIT7;
                    }
                } else {
                    dataDirectionRegister[B] = operation;
                }
                break;
            case CRB:
                LOGGER.info("CRB Store: {} op: {}", addr, operation);
                if ((operation & CIRQ) == 0) {
                    disableIRQ(B);
                } else {
                    enableIRQ(B);
                }
                writeControlRegister(B, operation);
                break;
        }
    }

    /**
     * Send IRQ signal if the IRQ bit is on.
     */
    private void enableIRQ(int side) {
        if (isBitOn(controlRegister[side], BIT7)) {
            if (activeIRQ[side] == false) {
                if (side == A) LOGGER.info("enableIRQ FIRQ");
                activeIRQ[side] = true;
                irqOut[side].send(true);
            }
        }
    }

    private void disableIRQ(int side) {
        if (activeIRQ[side]) {
            activeIRQ[side] = false;
            irqOut[side].send(false);
        }
    }

    /**
     * Activate CA1 IRQ and signal CPU.
     * If bit 0 in CRB is 0, then IRQs are disabled,
     * but the status is kept.
     */
    void signalCA1(boolean state) {
        if (state) {
            controlRegister[A] |= BIT7;
            if (activeIRQ[A] == false) {
                if (isBitOn(controlRegister[A], CIRQ)) {
                    LOGGER.info("SignalCA1 FIRQ");
                    activeIRQ[A] = true;
                    irqOut[A].send(true);
                }
            }
        } else {
            controlRegister[A] &= ~BIT7;
            if (activeIRQ[A] == true) {
                activeIRQ[A] = false;
                irqOut[A].send(false);
            }
        }
    }

    /**
     * Activate CB1 IRQ and signal CPU.
     * If bit 0 in CRB is 0, then IRQs are disabled,
     * but the status is kept.
     */
    void signalCB1() {
        controlRegister[B] |= BIT7;
        if (activeIRQ[B] == false) {
            if (isBitOn(controlRegister[B], CIRQ)) {
                activeIRQ[B] = true;
                irqOut[B].send(true);
            }
        }
    }


    /**
     * Set value on a number of output lines simultaneously.
     */
    private void setOutputOctet(int side, int mask, int value) {

        int outputMask = dataDirectionRegister[side] & mask;
        outputRegister[side] = (outputRegister[side] & ~outputMask)
                             | (outputMask & value);
        pinOuts[side].send(side, mask, value);
    }

    /**
     * Scan keyboard matrix for pressed keys. Set input line B7 if so.
     */
    private void keyboardMatrix(int side, int mask, int value) {
        setInputLine(B, 7, screen.hasKeyPress(value & mask));
    }

    /**
     * Set a new state on a line. The line must be configured as input in the
     * DDR, or it will be ignored.
     */
    public void setInputLine(int side, int line, boolean state) {
        int bitMask = 1 << line;
        if ((dataDirectionRegister[side] & bitMask) == bitMask)
            return; // Line is output
        if (state)
            outputRegister[side] |= bitMask;
        else
            outputRegister[side] &= ~bitMask;
    }

    private static boolean isBitOn(int x, int n) {
        return (x & n) != 0;
    }

    private static boolean isBitOff(int x, int n) {
        return (x & n) == 0;
    }

}

class ClockTick extends TimerTask {

    private PIA6821MO5 pia;

    ClockTick(PIA6821MO5 pia) {
        this.pia = pia;
    }

    public void run() {
        pia.signalCB1(); // Execute a hardware interrupt
    }
}
