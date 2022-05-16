package org.roug.usim;

/**
 * Byte size register (unsigned).
 */
public class UByte extends RegisterOps implements Register {

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
     * @param name Name of register for debugging
     */
    public UByte(String name) {
        value = 0;
        registerName = name;
    }

    /**
     * Constructor.
     * @param i Initial value
     */
    public UByte(int i) {
        set(i);
    }

    @Override
    public int get() {
        return value & MAX;
    }

    @Override
    public int intValue() {
        return value & MAX;
    }

    @Override
    public void set(int newValue) {
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

    @Override
    public String toString() {
        return registerName + "=" + Integer.toHexString(value);
    }

}

