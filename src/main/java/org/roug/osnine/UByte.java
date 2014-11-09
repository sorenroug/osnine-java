package org.roug.osnine;

/**
 * Byte size register (unsigned).
 */
public class UByte extends Register {

    @Override
    public int get() {
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
}

