package org.roug.osnine;

/**
 * Word size register (i.e. 16 bit).
 */
public class RegisterD {

    private UByte regA;
    private UByte regB;

    /**
     * Constructor.
     */
    public RegisterD(UByte regA, UByte regB) {
        this.regA = regA;
        this.regB = regB;

    }

    public int intValue() {
        return regA.intValue() + (regB.intValue() << 8);
    }

    public int get() {
        return intValue();
    }

    public void set(int newValue) throws IllegalArgumentException {
        if (newValue > 0xffff || newValue < 0x0) {
            throw new IllegalArgumentException("Value must fit in 16 bits.");
        }
        regA.set(newValue);
        regB.set(newValue >> 8);
    }

    public int getSigned() {
        int value = intValue();
        if (value < 0x8000) {
            return value;
        } else {
            return -((~value & 0x7fff) + 1);
        }
    }

}

