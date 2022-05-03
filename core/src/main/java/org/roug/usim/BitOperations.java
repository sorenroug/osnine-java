package org.roug.usim;

/**
 * Static bit operations.
 */
public class BitOperations {

    public static boolean bittst(int value, int n) {
        return (value & (1 << n)) != 0;
    }

    public static int bitset(int value, int n) {
        value |= 1 << n;
        return value;
    }

    public static int bitclr(int value, int n) {
        value &= ~(1 << n);
        return value;
    }

}

