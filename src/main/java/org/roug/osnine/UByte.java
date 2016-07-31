package org.roug.osnine;

/**
 * Byte size register (unsigned).
 */
public class UByte extends Register {

    /**
     * Constructor.
     */
    public UByte() {
        value = 0;
    }

    /**
     * Constructor.
     */
    public UByte(int i) {
        value = i & 0xff;
    }

    @Override
    public int get() {
        return value & 0xff;
    }

    @Override
    public int intValue() {
        return value & 0xff;
    }

    @Override
    public void set(int newValue) throws IllegalArgumentException {
        if (newValue > 0xff || newValue < -0x80) {
            throw new IllegalArgumentException("Value must fit in 8 bits.");
        }
        value = newValue;
    }

    @Override
    public int getSigned() {
        if (value < 0x80) {
            return value;
        } else {
            return -((~value & 0x7f) + 1);
        }
    }

    public static UByte valueOf(int i) {
        return new UByte(i);
    }

}

