package org.roug.osnine;

/**
 * Byte size register (unsigned).
 */
public class UByte implements Register {

    public static final int MAX = 0xff;

    private int value;

    private String registerName = "";

    /**
     * Constructor.
     */
    public UByte() {
        value = 0;
    }

    /**
     * Constructor.
     */
    public UByte(String name) {
        value = 0;
        registerName = name;
    }

    /**
     * Constructor.
     */
    public UByte(int i) {
        set(i);
    }

    @Override
    public int get() {
        return intValue();
    }

    @Override
    public int intValue() {
        return value & 0xff;
    }

    @Override
    public void set(int newValue) {
//      if (newValue > 0xff || newValue < -0x80) {
//          throw new IllegalArgumentException("Value must fit in 8 bits.");
//      }
        value = newValue & MAX;
    }

    @Override
    public int getSigned() {
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

    public static UByte valueOf(int i) {
        return new UByte(i);
    }

    public void add(int x) {
        value += x;
        value = value & MAX;
    }

    @Override
    public String toString() {
        return "[" + registerName + "]:" + Integer.valueOf(value).toString();
    }

    /**
     * Bit test.
     */
    @Override
    public int btst(int n) {
        return ((value & (1 << n)) != 0) ? 1 : 0;
    }

    @Override
    public void bset(int n) {
        value |= (1 << n);
    }

    @Override
    public void bclr(int n) {
        value &= ~(1 << n);
    }

}

