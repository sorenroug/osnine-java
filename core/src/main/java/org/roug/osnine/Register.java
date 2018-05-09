package org.roug.osnine;

/**
 * Register interface.
 */
public interface Register {

    int getWidth();

    int intValue();

    public int get();

    public void set(int newValue);

    public int getSigned();

    /**
     * Bit test.
     * @param n bit (0-7) to test.
     */
    int btst(int n);

    /**
     * Bit set.
     * @param n bit (0-7) to set.
     */
    void bset(int n);

    /**
     * Bit clear.
     * @param n bit (0-7) to clear.
     */
    void bclr(int n);

}

