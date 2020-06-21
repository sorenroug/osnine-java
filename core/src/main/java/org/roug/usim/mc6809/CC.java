package org.roug.usim.mc6809;

/**
 * Condition code names.
 */

public enum CC {

    /** Carry. */
    C,
    /** Overflow. */
    V,
    /** Zero. */
    Z,
    /** Negative. */
    N,
    /** IRQ ignore. */
    I,
    /** Half-carry. */
    H,
    /** FIRQ ignore. */
    F,
    /** Entire state pushed. */
    E;

    public static final int Cmask = 1 << C.ordinal();
    public static final int Vmask = 1 << V.ordinal();
    public static final int Zmask = 1 << Z.ordinal();
    public static final int Nmask = 1 << N.ordinal();
    public static final int Imask = 1 << I.ordinal();
    public static final int Hmask = 1 << H.ordinal();
    public static final int Fmask = 1 << F.ordinal();
    public static final int Emask = 1 << E.ordinal();
}
