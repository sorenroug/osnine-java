package org.roug.usim.z80;
import org.roug.usim.Register;
import org.roug.usim.USim;
import org.roug.usim.Word;

/**
 * Treat a memory location as a register.
 * Memory location is pointed to by a Word register set up in Constructor
 * and displacement fetched from instruction register.
 */
public class RegisterDisplaced implements Register {

    private static final int MAX = 0xff;

    private Word regForAddress;

    private USim cpu;

    /**
     * Constructor.
     */
    public RegisterDisplaced() {
        regForAddress = null;
    }

    /**
     * Constructor.
     * @param name Name of register for debugging
     */
    public RegisterDisplaced(String name) {
        regForAddress = null;
    }

    /**
     * Constructor.
     * @param name Name of register for debugging
     */
    public RegisterDisplaced(String name, USim cpu, Word reg) {
        this.cpu = cpu;
        regForAddress = reg;
    }

    @Override
    public int get() {
        return intValue();
    }

    @Override
    public int intValue() {
        int displacement = cpu.fetch();
        if (displacement > 0x7F) displacement -= 256;
        return cpu.read(regForAddress.get() + displacement);
    }

    /**
     * Write the value through to the memory location.
     */
    @Override
    public void set(int newValue) {
        int displacement = cpu.fetch();
        if (displacement > 0x7F) displacement -= 256;
        cpu.write(regForAddress.get() + displacement, newValue & MAX);
    }

    @Override
    public int getSigned() {
        int value = get();
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

    public void add(int x) {
        int value = get() + x;
        set(value);
    }


    /**
     * Bit test.
     */
    @Override
    public int btst(int n) {
        return ((get() & (1 << n)) != 0) ? 1 : 0;
    }

    @Override
    public void bset(int n) {
        int value = get();
        set(value |= (1 << n));
    }

    @Override
    public void bclr(int n) {
        int value = get();
        set(value & ~(1 << n));
    }

}
