package org.roug.usim;

/**
 * Treat a memory location as a register.
 */
public class RegisterMemory extends RegisterOps {

    private static final int MAX = 0xff;

    private int memLoc;

    private USim cpu;

    /**
     * Constructor.
     */
    public RegisterMemory() {
        memLoc = 0;
    }

    /**
     * Constructor.
     *
     * @param name Name of register for debugging
     */
    public RegisterMemory(String name) {
        memLoc = 0;
    }

    /**
     * Constructor.
     *
     * @param cpu Host CPU for reading/writing memory.
     * @param addr Initial addr
     */
    public RegisterMemory(USim cpu, int addr) {
        this.cpu = cpu;
        memLoc = addr;
    }

    @Override
    public int get() {
        return intValue();
    }

    @Override
    public int intValue() {
        return cpu.read(memLoc) & 0xff;
    }

    /**
     * Write the value through to the memory location.
     */
    @Override
    public void set(int newValue) {
        cpu.write(memLoc, newValue & MAX);
    }

    @Override
    public int getSigned() {
        int value = cpu.read(memLoc);
        if (value < 0x80) {
            return value;
        } else {
            return -((~value & 0x7f) + 1);
        }
    }

    @Override
    public int getWidth() {
        return 8;
    }

    @Override
    public String toString() {
        return "Location=" + Integer.toHexString(memLoc);
    }

    /**
     * Bit test.
     */
    @Override
    public int btst(int n) {
        return ((cpu.read(memLoc) & (1 << n)) != 0) ? 1 : 0;
    }

    @Override
    public void bset(int n) {
        int value = cpu.read(memLoc);
        cpu.write(memLoc, value |= (1 << n));
    }

    @Override
    public void bclr(int n) {
        int value = cpu.read(memLoc);
        cpu.write(memLoc, value & ~(1 << n));
    }

}


