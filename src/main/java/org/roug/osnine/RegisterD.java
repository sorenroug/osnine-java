package org.roug.osnine;

/**
 * Word size register (i.e. 16 bit).
 */
public class RegisterD implements Register {

    private UByte regA;
    private UByte regB;

    /**
     * Constructor.
     */
    public RegisterD(UByte regA, UByte regB) {
        this.regA = regA;
        this.regB = regB;

    }

    @Override
    public int intValue() {
        return regA.intValue() + (regB.intValue() << 8);
    }

    @Override
    public int get() {
        return intValue();
    }

    @Override
    public void set(int newValue) {
//      if (newValue > 0xffff || newValue < 0x0) {
//          throw new IllegalArgumentException("Value must fit in 16 bits.");
//      }
        regA.set(newValue);
        regB.set(newValue >> 8);
    }

    @Override
    public int getSigned() {
        int value = intValue();
        if (value < 0x8000) {
            return value;
        } else {
            return -((~value & 0x7fff) + 1);
        }
    }

    @Override
    public int btst(int n) {
        int value = intValue();
        return ((value & (1 << n)) != 0) ? 1 : 0;
    }

    @Override
    public void bset(int n) {
        int value = intValue();
        value |= (1 << n);
        set(value);
    }

    @Override
    public void bclr(int n) {
        int value = intValue();
        value &= ~(1 << n);
        set(value);
    }

}

