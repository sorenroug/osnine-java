package org.roug.usim;

/**
 * Register interface.
 */
public interface Register {

    /**
     * Get the number of bits the register occupies.
     *
     * @return number of bits of register.
     */
    int getWidth();

    /**
     * Get integer value.
     *
     * @return content of register.
     */
    int intValue();

    /**
     * Get integer value. Content will be truncated to match the width.
     *
     * @return content of register.
     */
    int get();

    /**
     * Set new integer value.
     * @param newValue is new value to set, which must not exceed the register's width.
     */
    void set(int newValue);

    /**
     * Get signed integer value.
     *
     * @return Signed value (-128 to 127 or -32768 to 32767).
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

    /**
     * Add number to register value.
     * @param addend value to add.
     * @return old value.
     */
    int add(int addend);

    /**
     * Get register.
     * Used to creating af register out of a memory location.
     * Registers that don't do this just return themselves.
     *
     * @return the memory location that will act a the real register.
     */
    Register getRealRegister();

}

