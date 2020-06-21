package org.roug.usim;

/**
 * Word size register. (i.e. 16 bit).
 */
public class Word implements Register {

    public static final int MAX = 0xffff;

    private int value;

    private String registerName = "";

    /**
     * Constructor. Sets initial value to 0.
     */
    public Word() {
        value = 0;
    }

    /**
     * Constructor. Sets initial value to 0.
     *
     * @param name - name given to the word.
     */
    public Word(String name) {
        value = 0;
        registerName = name;
    }

    /**
     * Constructor.
     *
     * @param i initial value
     */
    public Word(int i) {
        set(i);
    }

    @Override
    public int intValue() {
        return value & MAX;
    }

    @Override
    public int get() {
        return intValue();
    }

    @Override
    public void set(int newValue) throws IllegalArgumentException {
//      if (newValue > MAX || newValue < -0x8000) {
//          throw new IllegalArgumentException("Value must fit in 16 bits.");
//      }
        value = newValue & MAX;
    }

    @Override
    public int getSigned() {
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

    public UByte ubyteValue() {
        return UByte.valueOf(value);
    }

    public void inc() {
        add(1);
    }

    /**
     * Add value. Should it wrap?
     * @param increment The value to add
     */
    public void add(int increment) {
        value += increment;
        value = value & MAX;
//      if (value > MAX || value < -0x8000) {
//          throw new IllegalArgumentException("Value must fit in 16 bits.");
//      }
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
	value |= 1 << n;
    }

    @Override
    public void bclr(int n) {
	value &= ~(1 << n);
    }

    @Override
    public String toString() {
        return registerName + "=" + Integer.toHexString(intValue());
    }

}
