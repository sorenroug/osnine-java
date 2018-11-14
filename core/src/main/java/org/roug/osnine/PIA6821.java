package org.roug.osnine;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Periphreal interface adapter.
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

    /** Control bit for IRQ. */
    protected static final int CIRQ = 0x01;

    /** Bit to select between the OR and DDR. */
    protected static final int SELECT_OR = 0x04;

    protected static final int DDRA = 0;
    protected static final int CRA = 1;
    protected static final int DDRB = 2;
    protected static final int CRB = 3;

    protected int[] outputRegister = new int[2];
    protected int[] dataDirectionRegister = new int[2];
    protected int[] controlRegister = new int[2];

    /** If PIA has raised IRQ on the bus. */
    protected boolean[] activeIRQ = new boolean[2];


    /** Reference to CPU for the purpose of sending IRQ. */
    protected Bus8Motorola bus;

    /**
     * Constructor.
     */
    public PIA6821(int start, Bus8Motorola bus, String... args) {
        super(start, start + 4);
        this.bus = bus;
        reset();
    }

    private void reset() {
        outputRegister[A] = 0;
        dataDirectionRegister[A] = 0;
        controlRegister[A] = 0;
        outputRegister[B] = 0;
        dataDirectionRegister[B] = 0;
        controlRegister[B] = 0;
    }

    @Override
    protected int load(int addr) {
        switch (addr - getStartAddress()) {
            case DDRA: return readPeripheralRegister(A);
            case CRA: return readControlRegister(A);
            case DDRB: return readPeripheralRegister(B);
            case CRB: return readControlRegister(B);
        }
        return 0;
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

    /**
     * Deactivate IRQ.
     */
    private void deactivateIRQ(int side) {
        if (activeIRQ[side]) {
            activeIRQ[side] = false;
            if (side == B) {
                bus.signalIRQ(false);
            }
            else {
                LOGGER.info("Lower FIRQ");
                bus.signalFIRQ(false);
            }
        }
        controlRegister[side] &= ~(BIT7 | BIT6); // Turn off IRQ bits.
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
            activeIRQ[side] = true;
        }       
    }       
                
    private void disableIRQ(int side) {
        if (activeIRQ[side]) {
            activeIRQ[side] = false;
        }
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
