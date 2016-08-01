package org.roug.osnine;

/**
 * Word size register (i.e. 16 bit).
 */
public class Word implements Register {

    private int value;

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
        set(i);
    }


    @Override
    public int intValue() {
        return value & 0xffff;
    }

    @Override
    public int get() {
        return intValue();
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
        add(1);
    }

    /**
     * Add value. Should it wrap?
     */
    public void add(int increment) {
        value += increment;
        if (value > 0xffff || value < -0x8000) {
            throw new IllegalArgumentException("Value must fit in 16 bits.");
        }
    }

    public static Word valueOf(int i) {
        return new Word(i);
    }

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

