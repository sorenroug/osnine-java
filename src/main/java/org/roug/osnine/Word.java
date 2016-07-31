package org.roug.osnine;

/**
 * Word size register (i.e. 16 bit).
 */
public class Word {

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
        value = i;
    }


    public int intValue() {
        return value & 0xffff;
    }

    public int get() {
        return value & 0xffff;
    }

    public void set(int newValue) throws IllegalArgumentException {
        if (newValue > 0xffff || newValue < -0x8000) {
            throw new IllegalArgumentException("Value must fit in 16 bits.");
        }
        value = newValue;
    }

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

    public void add(int increment) {
        value += increment;
    }

    public static Word valueOf(int i) {
        return new Word(i);
    }

    boolean btst(int n) {
        return (value & (1 << n)) != 0;
    }

    void bset(int n) {
	value |= (1 << n);
    }

    void bclr(int n) {
	value &= ~(1 << n);
    }

}

