package org.roug.osnine;

/**
 * Condition code names.
 */

public enum CC {

    C, V, Z, N, I, H, F, E;

    public static final int Cmask = 1 << C.ordinal();
    public static final int Vmask = 1 << V.ordinal();
    public static final int Zmask = 1 << Z.ordinal();
    public static final int Nmask = 1 << N.ordinal();
    public static final int Imask = 1 << I.ordinal();
    public static final int Hmask = 1 << H.ordinal();
    public static final int Fmask = 1 << F.ordinal();
    public static final int Emask = 1 << E.ordinal();
}
