package org.roug.usim;

/**
 * Register interface.
 */
public interface Register {

    /**
     * Get the number of bits the register occupies.
     */
    int getWidth();

    /**
     * Get integer value.
     */
    int intValue();

    /**
     * Get integer value. Content will be truncated to match the width.
     */
    int get();

    /**
     * Set new integer value.
     * @param newValue is new value to set, which must not exceed the register's width.
     */
    void set(int newValue);

    /**
     * Get signed integer value.
     */
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

