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
     */
    int btst(int n);

    void bset(int n);

    void bclr(int n);

}

