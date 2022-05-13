package org.roug.usim;

/**
 * Treat a memory location as a register.
 * Memory location is pointed to by a Word register set up in Constructor
 */
public class RegisterIndirect extends RegisterOps implements Register {

    private static final int MAX = 0xff;

    private Word regForAddress;

    private USim cpu;

    /**
     * Constructor.
     */
    public RegisterIndirect() {
        regForAddress = null;
    }

    /**
     * Constructor.
     * @param name Name of register for debugging
     */
    public RegisterIndirect(String name) {
        regForAddress = null;
    }

    /**
     * Constructor.
     * @param name Name of register for debugging
     * @param cpu CPU where memory can be read.
     * @param reg Register that contains the base address.
     */
    public RegisterIndirect(String name, USim cpu, Word reg) {
        this.cpu = cpu;
        regForAddress = reg;
    }

    @Override
    public int get() {
        return intValue();
    }

    @Override
    public int intValue() {
        return cpu.read(regForAddress.get());
    }

    /**
     * Write the value through to the memory location.
     */
    @Override
    public void set(int newValue) {
        cpu.write(regForAddress.get(), newValue & MAX);
    }

    @Override
    public int getSigned() {
        int value = cpu.read(regForAddress.get());
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
        return "Location=" + Integer.toHexString(regForAddress.get());
    }

//     public void add(int x) {
//         int value = get() + x;
//         set(value);
//     }


    /**
     * Bit test.
     */
    @Override
    public int btst(int n) {
        return ((intValue() & (1 << n)) != 0) ? 1 : 0;
    }

    @Override
    public void bset(int n) {
        int value = cpu.read(regForAddress);
        cpu.write(regForAddress, value |= (1 << n));
    }

    @Override
    public void bclr(int n) {
        int value = cpu.read(regForAddress);
        cpu.write(regForAddress, value & ~(1 << n));
    }

}
