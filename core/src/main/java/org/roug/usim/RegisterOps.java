package org.roug.usim;

/**
 * Byte size register (unsigned).
 */
public abstract class RegisterOps implements Register {

    @Override
    public int getWidth() {
        return 8;
    }

    @Override
    public String toString() {
        return Integer.toHexString(get());
    }

    @Override
    public int btst(int n) {
        int value = get();
        return ((value & (1 << n)) != 0) ? 1 : 0;
    }

    @Override
    public void bset(int n) {
        int value = get();
        value |= 1 << n;
        set(value);
    }

    @Override
    public void bclr(int n) {
        int value = get();
        value &= ~(1 << n);
        set(value);
    }

    @Override
    public int add(int x) {
        int value = get();
        set(value + x);
        return value;
    }

    @Override
    public Register getRealRegister() {
        return this;
    }
}
