package org.roug.osnine;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Peripheral interface adapter.
 * There are so many ways this adapter can be wired to devices
 * that it should probably be an abstract class.
 */
public abstract class PIA6821 extends MemorySegment {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(PIA6821.class);

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
    protected static final int SELECT_OR = 0x04;

    /** The four registers can have different positions in memory. */
    private int registerLayout = 0;

    protected int[] outputRegister = new int[2];
    protected int[] dataDirectionRegister = new int[2];
    protected int[] controlRegister = new int[2];

    /** Current state of control line 1. */
    private boolean[] currStateC1 = new boolean[2];

    /** Current state of control line 2. */
    private boolean[] currStateC2 = new boolean[2];

    private BitReceiver[] irqOut = new BitReceiver[2];

    /** CA2 and CB2 control lines callbacks. */
    private BitReceiver[] controlOut = new BitReceiver[2];

    private PIAOutputPins[] pinOuts = new PIAOutputPins[2];

    /** Reference to CPU for the purpose of sending IRQ. */
    protected Bus8Motorola bus;

    /**
     * Constructor.
     *
     * @param start - First address location of the PIA.
     * @param bus - The bus the PIA is attached to.
     * @param args - additional arguments
     */
    public PIA6821(int start, Bus8Motorola bus, String... args) {
        super(start, start + 4);
        this.bus = bus;
        reset();

        irqOut[A] = (boolean state) -> {};
        irqOut[B] = (boolean state) -> {};

        controlOut[A] = (boolean state) -> {};
        controlOut[B] = (boolean state) -> {};

        pinOuts[A] = (int mask, int value, int oldValue) -> {};
        pinOuts[B] = (int mask, int value, int oldValue) -> {};

    }

    /**
     * Define the order the registers are ordered on the bus.
     *
     * @param layout - number (0,1) indicating the layout
     */
    protected void setLayout(int layout) {
        if (layout > 1 && layout < 0)
            throw new IllegalArgumentException("Unsupported layout");
        registerLayout = layout;
    }

    /**
     * Reset the PIA.
     */
    private void reset() {
        for (int side = A; side <= B; side++) {
            outputRegister[side] = 0;
            dataDirectionRegister[side] = 0;
            controlRegister[side] = 0;
            currStateC1[side] = false;
            currStateC2[side] = false;
        }
    }

    @Override
    protected int load(int addr) {
        if (registerLayout == 0) {
            switch (addr - getStartAddress()) {
                case 0: return readPeripheralRegister(A);
                case 1: return readControlRegister(A);
                case 2: return readPeripheralRegister(B);
                case 3: return readControlRegister(B);
            }
        } else {
            switch (addr - getStartAddress()) {
                case 0: return readPeripheralRegister(A);
                case 1: return readPeripheralRegister(B);
                case 2: return readControlRegister(A);
                case 3: return readControlRegister(B);
            }
        }
        throw new IndexOutOfBoundsException("Address out of bounds");
    }

    @Override
    protected void store(int addr, int operation) {
        if (registerLayout == 0) {
            switch (addr - getStartAddress()) {
                case 0: setOutputOctet(A, operation); return;
                case 1: writeControlRegister(A, operation); return;
                case 2: setOutputOctet(B, operation); return;
                case 3: writeControlRegister(B, operation); return;
            }
        } else {
            switch (addr - getStartAddress()) {
                case 0: setOutputOctet(A, operation); return;
                case 1: setOutputOctet(B, operation); return;
                case 2: writeControlRegister(A, operation); return;
                case 3: writeControlRegister(B, operation); return;
            }
        }
        throw new IndexOutOfBoundsException("Address out of bounds");
    }

    /**
     * Read output register.
     * The interrupt flags are cleared as a result of a read
     * Peripheral Data Operation.
     *
     * @param side - A or B side of the PIA.
     * @return value of the register
     */
    private int readPeripheralRegister(int side) {
        if (isBitOn(controlRegister[side], SELECT_OR)) {
            disableIRQ(side);
            controlRegister[side] &= ~(BIT7 | BIT6); // Turn off IRQ bits.
            if (side == A && isBitOff(controlRegister[side], BIT4)) {
                currStateC2[side] = false;
                controlOut[side].send(false);
                if (isBitOn(controlRegister[side], BIT3)) {
                    currStateC2[side] = true;
                    controlOut[side].send(true);
                }
            }
            return outputRegister[side] & 0xFF;
        } else {
            return dataDirectionRegister[side];
        }
    }

    /**
     * Read control register.
     *
     * @param side - A or B side of the PIA.
     * @return value of the register
     */
    private int readControlRegister(int side) {
        return controlRegister[side] & 0xFF;
    }

    /**
     * Write to a control register.
     * Bit 6 and 7 are read only.
     * If bit 5 is high then C2 is an output register.
     * If bit 4 is low and bit 3 high, then send a pulse to the callback when
     * output register is read (side A) or written (side B).
     * If bit 4 is high then the callback is sent the value of bit 3.
     *
     * @param side - A or B side of the PIA.
     * @param val - new value to set.
     */
    private void writeControlRegister(int side, int val) {
        if ((val & (BIT3 | BIT0)) == 0) {
            disableIRQ(side);
        } else {
            enableIRQ(side);
        }
        if (isBitOn(val, BIT5)) {
            if (isBitOn(val, BIT4)) {
                currStateC2[side] = isBitOn(val, BIT3);
                controlOut[side].send(currStateC2[side]);
            }
        }

        controlRegister[side] = (controlRegister[side] & 0xC0) | (val & 0x3F);
        LOGGER.debug("CR Side: {} new value: {}", side, controlRegister[side]);
    }

    /**
     * Set value on a number of output lines simultaneously.
     * The values on input lines may not be modified.
     *
     * @param side - A or B side of the PIA.
     * @param value - new value to set.
     */
    private void setOutputOctet(int side, int value) {
        if (isBitOn(controlRegister[side], SELECT_OR)) {
            int outputMask = dataDirectionRegister[side];
            int oldValue = outputRegister[side] & outputMask;

            outputRegister[side] = (outputRegister[side] & ~outputMask)
                                 | (outputMask & value);
            pinOuts[side].send(outputMask, value, oldValue);
            if (side == B && isBitOff(controlRegister[side], BIT4)) {
                currStateC2[side] = false;
                controlOut[side].send(false);
                if (isBitOn(controlRegister[side], BIT3)) {
                    currStateC2[side] = true;
                    controlOut[side].send(true);
                }
            }
        } else {
            dataDirectionRegister[side] = value;
        }
    }

    /**
     * Send IRQ signal if the IRQ bit is on.
     *
     * @param side - A or B side of the PIA.
     */
    private void enableIRQ(int side) {
        if (isBitOn(controlRegister[side], BIT7)
          ||isBitOn(controlRegister[side], BIT6)) {
            irqOut[side].send(true);
        }
    }

    /**
     * Deactivate IRQ.
     *
     * @param side - A or B side of the PIA.
     */
    private void disableIRQ(int side) {
        irqOut[side].send(false);
    }

    /**
     * Set a new state on a line. The line must be configured as input in the
     * DDR, or it will be ignored.
     *
     * @param side A or B side of the PIA.
     * @param line Line number from 0 to 7.
     * @param state new state
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

    /**
     * Set interrupt input and cancel signal immediately.
     *
     * @param side - A or B side
     */
    public void signalC1(int side) {
        signalC1(side, true);
        signalC1(side, false);
    }

    /**
     * Set interrupt input CA1 or CB1 to state.
     * If bit 0 in CR is 0, then IRQs are disabled, but the status is kept.
     *
     * @param side - A or B side
     * @param state - true for high, false for low.
     */
    public void signalC1(int side, boolean state) {
        if (state == currStateC1[side]) return;

        if (isBitOff(controlRegister[side], BIT4)
                && isBitOff(controlRegister[side], BIT3)) {
            currStateC2[side] = true;
            controlOut[side].send(true);
        }

        if (state) {
            if (isBitOn(controlRegister[side], BIT1)) {
                controlRegister[side] |= BIT7;
                if (isBitOn(controlRegister[side], BIT0)) {
                    irqOut[side].send(true);
                }
            }
        } else {
            if (isBitOff(controlRegister[side], BIT1)) {
                controlRegister[side] |= BIT7;
                if (isBitOn(controlRegister[side], BIT0)) {
                    irqOut[side].send(true);
                }
            }
        }
        currStateC1[side] = state;
    }

    /**
     * Check if CA1 or CB1 is on.
     *
     * @param side - A or B side of the PIA.
     * @return true if register is on
     */
    public boolean isC1On(int side) {
        return currStateC1[side];
    }

    /**
     * Set interrupt input and cancel signal immediately.
     *
     * @param side - A or B side
     */
    public void signalC2(int side) {
        signalC2(side, true);
        signalC2(side, false);
    }

    /**
     * Set interrupt input CA2 or CB2 to state.
     * If bit 3 in CR is 0, then IRQs are disabled, but the status is kept.
     * If bit 5 in CR is 1 then the interrupt line is an output and
     * inputs are ignored.
     *
     * @param side - A or B side
     * @param state - true for high, false for low.
     */
    public void signalC2(int side, boolean state) {
        if (isBitOn(controlRegister[side], BIT5)) return;
        if (state == currStateC2[side]) return;

        if (state) {
            if (isBitOn(controlRegister[side], BIT4)) {
                controlRegister[side] |= BIT6;
                if (isBitOn(controlRegister[side], BIT3)) {
                    irqOut[side].send(true);
                }
            }
        } else {
            if (isBitOff(controlRegister[side], BIT4)) {
                controlRegister[side] |= BIT6;
                if (isBitOn(controlRegister[side], BIT3)) {
                    irqOut[side].send(true);
                }
            }
        }
        currStateC2[side] = state;
    }

    /**
     * Check if CA2 or CB2 is on.
     *
     * @param side - A or B side of the PIA.
     * @return true if register is on
     */
    public boolean isC2On(int side) {
        return currStateC2[side];
    }

    /**
     * Set up a method to be called when something is written to an output
     * register.
     *
     * @param side - A or B side of the PIA.
     * @param callback - method to call.
     */
    protected void setOutputCallback(int side, PIAOutputPins callback) {
        pinOuts[side] = callback;
    }

    /**
     * Set up a method to be called when a control pin is signalled.
     *
     * @param side - A or B side of the PIA.
     * @param callback - method to call.
     */
    protected void setControlCallback(int side, BitReceiver callback) {
        controlOut[side] = callback;
    }

    /**
     * Set up a method to be called when an interrupt pin is signalled.
     *
     * @param side - A or B side of the PIA.
     * @param callback - method to call.
     */
    protected void setIRQCallback(int side, BitReceiver callback) {
        irqOut[side] = callback;
    }

    private static boolean isBitOn(int x, int n) {
        return (x & n) != 0;
    }

    private static boolean isBitOff(int x, int n) {
        return (x & n) == 0;
    }


}
