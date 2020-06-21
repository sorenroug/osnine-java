package org.roug.usim;

/**
 * Register interface.
 */
public interface Register {

    int getWidth();

    int intValue();

    int get();

    void set(int newValue);

    int getSigned();

    /**
     * Bit test.
     * @param n bit (0-7) to test.
     * @return more than 0 if the bit is on.
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

