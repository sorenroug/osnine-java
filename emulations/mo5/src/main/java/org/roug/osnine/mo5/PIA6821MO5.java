package org.roug.osnine.mo5;

import org.roug.osnine.MemorySegment;
import org.roug.osnine.Bus8Motorola;
import org.roug.osnine.PIAOutputPins;
import org.roug.osnine.PIASignal;

import java.util.Timer;
import java.util.TimerTask;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * 6821 PIA in a Thomsom MO5.
 * This chip is located at addresses 0xA7C0-0xA7C3.
 * The MO5 buzzer is controlled by bit 0 on $A7C1. By changing this bit
 * a quadratic signal is emitted. This is used by the PLAY instruction in BASIC.
 *
 * data port A (A7C0)
 *  bit 0: Switch the screen RAM mapping between pixel and attribute RAMs
 *  bits 1-4: border color (R,G,B,P)
 *  bit 5: light pen button
 *  bit 6: tape drive data output
 *  bit 7: tape drive data input
 *  bit 7 is low when no tape drive is plugged, and high when there is one.
 *  The monitor loading and saving code checks for this to detect the tape drive
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

    /** Bit to select between the OR and DDR. */
    private static final int SELECT_OR = 0x04;

    // NOTE: the MO5 has swapped Register Select 0 and 1.
    protected static final int DDRA = 0;
    protected static final int ORA = 0;
    protected static final int DDRB = 1;
    protected static final int ORB = 1;
    protected static final int CRA = 2;
    protected static final int CRB = 3;

    private int[] outputRegister = new int[2];
    private int[] dataDirectionRegister = new int[2];
    private int[] controlRegister = new int[2];

    /** If PIA has raised IRQ on the bus. */
    private boolean[] activeIRQ = new boolean[2];

    private PIASignal[] irqOut = new PIASignal[2];

    private PIAOutputPins[] pinOuts = new PIAOutputPins[2];

    /** Reference to CPU for the purpose of sending IRQ. */
    private Bus8Motorola bus;
    private Screen screen;

    public PIA6821MO5(Bus8Motorola bus, Screen screen) {
        super(0xA7C0, 0xA7C0 + 4);
        this.bus = bus;
        this.screen = screen;

        irqOut[A] = (boolean state) -> bus.signalFIRQ(state);
        irqOut[B] = (boolean state) -> bus.signalIRQ(state);

        pinOuts[A] = (int mask, int value, int oldValue)
                   -> screenMemoryBank(mask, value, oldValue);
        pinOuts[B] = (int mask, int value, int oldValue)
                   -> keyboardMatrix(mask, value, oldValue);
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
     * IRQB is connected to the CPU's IRQ pin.
     */
    private void signalIRQ(boolean state) {
        if (state) {
            if (!activeIRQ[B]) {
                activeIRQ[B] = true;
                bus.signalIRQ(state);
            }
        } else {
            if (activeIRQ[B]) {
                activeIRQ[B] = false;
                bus.signalIRQ(state);
            }
        }
    }

    /**
     * IRQA is connected to the CPU's FIRQ pin.
     */
    private void signalFIRQ(boolean state) {
        if (state) {
            if (!activeIRQ[A]) {
                activeIRQ[A] = true;
                bus.signalFIRQ(state);
            }
        } else {
            if (activeIRQ[A]) {
                activeIRQ[A] = false;
                bus.signalFIRQ(state);
            }
        }
    }

    /**
     * Read output register.
     * The interrupt flags are cleared as a result of a read
     * Peripheral Data Operation.
     */
    private int readPeripheralRegister(int side) {
        if (isBitOn(controlRegister[side], SELECT_OR)) {
            disableIRQ(side);
            controlRegister[side] &= ~(BIT7 | BIT6); // Turn off IRQ bits.
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
        if ((val & BIT0) == 0) {
            disableIRQ(side);
        } else {
            enableIRQ(side);
        }
        controlRegister[side] = (controlRegister[side] & 0xC0) | (val & 0x3F);
        LOGGER.debug("CR Side: {} new value: {}", side, controlRegister[side]);
    }

    @Override
    protected void store(int addr, int operation) {
        switch (addr - getStartAddress()) {
            case DDRA:
                if (isBitOn(controlRegister[A], SELECT_OR)) {
                    setOutputOctet(A, operation);
                } else {
                    dataDirectionRegister[A] = operation;
                }
                break;
            case CRA:
                LOGGER.debug("CRA Store: {} op: {}", addr, operation);
                writeControlRegister(A, operation);
                break;
            case DDRB:
                if (isBitOn(controlRegister[B], SELECT_OR)) {
                    setOutputOctet(B, operation);
                } else {
                    dataDirectionRegister[B] = operation;
                }
                break;
            case CRB:
                LOGGER.debug("CRB Store: {} op: {}", addr, operation);
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
                if (isBitOn(controlRegister[A], BIT0)) {
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
    void signalC1(int side) {
        controlRegister[side] |= BIT7;
        if (activeIRQ[side] == false) {
            if (isBitOn(controlRegister[side], BIT0)) {
                activeIRQ[side] = true;
                irqOut[side].send(true);
            }
        }
    }


    /**
     * Set value on a number of output lines simultaneously.
     * The values on input lines may not be modified.
     *
     * @param side - A or B side of the PIA.
     * @param value - new value to set.
     */
    private void setOutputOctet(int side, int value) {

        int outputMask = dataDirectionRegister[side];
        int oldValue = outputRegister[side] & outputMask;

        outputRegister[side] = (outputRegister[side] & ~outputMask)
                             | (outputMask & value);
        pinOuts[side].send(outputMask, value, oldValue);
    }

    /**
     * Set pixel bank.
     * @param mask - the data direction mask - 1 = output.
     * @param value - the new value set in the output registers
     * @param oldValue - the previous value - for detecting changes.
     */
    private void screenMemoryBank(int mask, int value, int oldValue) {
        if (isBitOn(value, BIT0)) {
            screen.setPixelBankActive(true);
        } else {
            screen.setPixelBankActive(false);
        }
    }

    /**
     * Scan keyboard matrix for pressed keys. Set input line B7 if so.
     * @param mask - the data direction mask - 1 = output.
     * @param value - the new value set in the output registers
     * @param oldValue - the previous value - for detecting changes.
     */
    private void keyboardMatrix(int mask, int value, int oldValue) {
        setInputLine(B, 7, !screen.hasKeyPress(value & 0x7E));
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
