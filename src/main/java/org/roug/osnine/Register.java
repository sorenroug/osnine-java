package org.roug.osnine;

/**
 * Condiction codes register.
 */
public abstract class Register {

    protected int value;

    public int get() {
        return value;
    }

    public void set(int newValue) {
        value = newValue;
    }

    public int getSigned() {
        return value;
    }
}

