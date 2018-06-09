package org.roug.osnine;

/**
 * Periphreal interface adapter.
 * There are so many ways this adapter can be wired to devices
 * that it should probably be an abstract class.
 */
public class PIA6821 extends MemorySegment {

    private static final int DDRA = 0;
    private static final int CRA = 1;
    private static final int DDRB = 2;
    private static final int CRB = 3;

    private int outputRegisterA; 
    private int dataDirectionRegisterA;
    private int controlRegisterA;

    private int outputRegisterB; 
    private int dataDirectionRegisterB;
    private int controlRegisterB;

    /** Reference to CPU for the purpose of sending IRQ. */
    private Bus8Motorola bus;

    /**
     * Constructor.
     */
    public PIA6821(int start, Bus8Motorola bus, String... args) {
        super(start, start + 4);
        this.bus = bus;
        reset();
    }

    private void reset() {
        outputRegisterA = 0;
        dataDirectionRegisterA = 0;
        controlRegisterA = 0;
        outputRegisterB = 0;
        dataDirectionRegisterB = 0;
        controlRegisterB = 0;
    }

    @Override
    protected int load(int addr) {
        switch (addr - getStartAddress()) {
            case DDRA: return dataDirectionRegisterA;
            case CRA: return controlRegisterA;
            case DDRB: return dataDirectionRegisterB;
            case CRB: return controlRegisterB;
        }
        return 0;
    }

    @Override
    protected void store(int addr, int val) {
    }

}
