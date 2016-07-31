package org.roug.osnine;

/**
 * Word size register (i.e. 16 bit).
 */
public class Word extends Register {

    /**
     * Constructor.
     */
    public Word() {
        value = 0;
    }

    /**
     * Constructor.
     */
    public Word(int i) {
        value = i;
    }


    public int intValue() {
        return value & 0xffff;
    }

    @Override
    public int get() {
        return value & 0xffff;
    }

    @Override
    public void set(int newValue) throws IllegalArgumentException {
        if (newValue > 0xffff || newValue < -0x8000) {
            throw new IllegalArgumentException("Value must fit in 16 bits.");
        }
        value = newValue;
    }

    @Override
    public int getSigned() {
        if (value < 0x8000) {
            return value;
        } else {
            return -((~value & 0x7fff) + 1);
        }
    }

    public UByte ubyteValue() {
        return UByte.valueOf(value);
    }

    public void inc() {
        inc(1);
    }

    public void inc(int increment) {
        value += increment;
    }

    public static Word valueOf(int i) {
        return new Word(i);
    }

}

