package org.roug.usim;

/**
 * Word size register (i.e. 16 bit).
 * The A and B accumulators are 8-bit registers, but for some instructions they
 * can be used together to form the 16-bit D accumulator. Thus, the
 * D accumulator is formed by using the B accumulator as the low byte, bits 0-7,
 * and the A accumulator as the high byte, bits 8-15.
 */
public class RegisterBytePair extends Word implements Register {

    /** High byte of register pair. */
    private UByte regHigh;
    /** Low byte of register pair. */
    private UByte regLow;

    private String registerName = "";


    /**
     * Constructor.
     */
    public RegisterBytePair() {
        this(0);
    }

    /**
     * Constructor.
     * @param value initial value
     */
    public RegisterBytePair(int value) {
        super("");
        this.regHigh = new UByte("High");
        this.regLow = new UByte("Low");
        set(value);
    }

    /**
     * Constructor.
     * @param regHigh The high byte
     * @param regLow The low byte
     */
    public RegisterBytePair(UByte regHigh, UByte regLow) {
        super("");
        this.regHigh = regHigh;
        this.regLow = regLow;
    }

    /**
     * Constructor.
     * @param registerName - Calling name for the register.
     * @param regHigh The high byte
     * @param regLow The low byte
     */
    public RegisterBytePair(String registerName, UByte regHigh, UByte regLow) {
        super(registerName);
        this.regHigh = regHigh;
        this.regLow = regLow;
    }

    @Override
    public int intValue() {
        return regLow.intValue() + (regHigh.intValue() << 8);
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
        regLow.set(newValue);
        regHigh.set(newValue >> 8);
    }

//     @Override
//     public void add(int increment) {
//         int currVal = get();
//         currVal += increment;
//         set(currVal);
//     }

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
    public int getWidth() {
        return 16;
    }

    @Override
    public int btst(int n) {
        int value = intValue();
        return ((value & (1 << n)) != 0) ? 1 : 0;
    }

    @Override
    public void bset(int n) {
        int value = intValue();
        value |= 1 << n;
        set(value);
    }

    @Override
    public void bclr(int n) {
        int value = intValue();
        value &= ~(1 << n);
        set(value);
    }

/*
    @Override
    public String toString() {
        return registerName + "=" + Integer.toHexString(intValue());
    }
*/
}

