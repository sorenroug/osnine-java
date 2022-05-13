package org.roug.usim;

/**
 * Most Significant Byte of a Word register.
 * Can be used as a UByte register.
 */
public class WordLSB extends RegisterOps implements Register {

    private static final int MAX = 0xff;

    private Word realReg;

    /**
     * Constructor.
     */
    public WordLSB() {
        realReg = null;
    }

    /**
     * Constructor.
     * @param name Name of register for debugging
     */
    public WordLSB(String name) {
        realReg = null;
    }

    /**
     * Constructor.
     * @param name Name of register for debugging
     * @param reg Register containing the 16 bit value.
     */
    public WordLSB(String name, Word reg) {
        realReg = reg;
    }

    @Override
    public int get() {
        return intValue();
    }

    @Override
    public int intValue() {
        return realReg.get();
    }

    /**
     * Write the value through to the memory location.
     */
    @Override
    public void set(int newValue) {
        int currVal = realReg.get();
        currVal = (currVal & 0xFF00) | (newValue & 0xFF);
        realReg.set(currVal);
    }

    @Override
    public int getSigned() {
        int value = intValue();
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
        return "LSB of " + realReg.toString();
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
        return ((get() & (1 << n)) != 0) ? 1 : 0;
    }

    @Override
    public void bset(int n) {
        int value = realReg.get();
        realReg.set(value |= (1 << n));
    }

    @Override
    public void bclr(int n) {
        int value = realReg.get();
        realReg.set(value & ~(1 << n));
    }

}
