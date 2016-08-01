package org.roug.osnine;

/**
 * Condiction codes register.
 */
public class CC implements Register {
   
    enum ConditionBit { C, V, Z, N, I, H, F, E };

    private int all;    // Condition code register


    /** Entire. */
    public int bit_e;

    /** FIRQ disable. */
    public int bit_f;

    /** Half carry. */
    public int bit_h;

    /** IRQ disable. */
    public int bit_i;

    /** Negative. */
    public int bit_n;
    
    /** Zero. */
    public int bit_z;

    /** Overflow. */
    public int bit_v;

    /** Carry. */
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
    @Override
    public int get() {
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

    /**
     * Get all condition codes as one byte.
     */
    @Override
    public int getSigned() {
        throw new UnsupportedOperationException("Signed value not supported");
    }

    @Override
    public int intValue() {
        return get();
    }

    @Override
    public void set(int newValue) {
        bit_e = newValue & 0x80;
        bit_f = newValue & 0x40;
        bit_h = newValue & 0x20;
        bit_i = newValue & 0x10;
        bit_n = newValue & 0x08;
        bit_z = newValue & 0x04;
        bit_v = newValue & 0x02;
        bit_c = newValue & 0x01;
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

    /**
     * Bit test.
     */
    //FIXME
    @Override
    public int btst(int n) {
//      switch (n) {
//      case ConditionBit.C.ordinal(): return bit_c;
//      }        
        return ((all & (1 << n)) != 0) ? 1 : 0;
    }

    //FIXME
    @Override
    public void bset(int n) {
        all |= (1 << n);
    }

    //FIXME
    @Override
    public void bclr(int n) {
        all &= ~(1 << n);
    }

}

