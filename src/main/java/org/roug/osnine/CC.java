package org.roug.osnine;

/**
 * Condiction codes register.
 */
public class CC {
   
    private int all;    // Condition code register

    /** Entire. */
    public int bit_e;
    /** FIRQ disable. */
    public int bit_f;
    /** Half carry. */
    public int bit_h;
    public int bit_i;
    public int bit_n;
    public int bit_z;
    public int bit_v;
    public int bit_c;
    /*
    union {
        struct {
            Byte        e : 1;  //!< Entire
            Byte        f : 1;  //!< FIRQ disable
            Byte        h : 1;  //!< Half carry
            Byte        i : 1;  //!< IRQ disable
            Byte        n : 1;  //!< Negative
            Byte        z : 1;  //!< Zero
            Byte        v : 1;  //!< Overflow
            Byte        c : 1;  //!< Carry

        } bit;
    } cc;
    */

    /**
     * Get all condition codes as one byte.
     */
    public int getCC() {
        int combined = (bit_e << 7)
            | (bit_f << 6)
            | (bit_h << 5)
            | (bit_i << 4)
            | (bit_n << 3)
            | (bit_z << 2)
            | (bit_v << 1)
            | bit_c;
        return combined;

    }

    public void setCC(int newValue) {
//      all = newValue;
    }

    public void clearCC() {
        bit_e = 0;
        bit_f = 0;
        bit_h = 0;
        bit_i = 0;
        bit_n = 0;
        bit_z = 0;
        bit_v = 0;
        bit_c = 0;
    }

    //!< Entire
/*
    int get_bit_e() {
        return all & 1;
    }

    void set_bit_e(int newValue) {
        all |= newValue;
    }

    int get_bit_f() {
        return all & (1 << 1);
    }

    void set_bit_f(int newValue) {
        all |= (newValue << 1);
    }
*/
}

