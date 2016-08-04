package org.roug.osnine;

/**
 * Condition codes register.
 */
public class RegisterCC extends UByte implements Register {
   
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
        bit_e = (newValue & 0x80) >> 7;
        bit_f = (newValue & 0x40) >> 6;
        bit_h = (newValue & 0x20) >> 5;
        bit_i = (newValue & 0x10) >> 4;
        bit_n = (newValue & 0x08) >> 3;
        bit_z = (newValue & 0x04) >> 2;
        bit_v = (newValue & 0x02) >> 1;
        bit_c = newValue & 0x01;
    }

    public void clear() {
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

    @Override
    public int getWidth() {
        return 8;
    }

    /**
     * Bit test.
     */
    //FIXME
    @Override
    public int btst(int n) {
//      switch (n) {
//      case CC.C.ordinal(): return bit_c;
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

    public boolean isSetE() {
        return bit_e != 0;
    }

    public boolean isSetF() {
        return bit_f != 0;
    }

    public boolean isSetH() {
        return bit_h != 0;
    }

    public boolean isSetI() {
        return bit_i != 0;
    }

    public boolean isSetN() {
        return bit_n != 0;
    }

    public boolean isSetZ() {
        return bit_z != 0;
    }

    public boolean isSetV() {
        return bit_v != 0;
    }

    public boolean isSetC() {
        return bit_c != 0;
    }

    public int getE() {
        return bit_e;
    }

    public int getF() {
        return bit_f;
    }

    public int getH() {
        return bit_h;
    }

    public int getI() {
        return bit_i;
    }

    public int getN() {
        return bit_n;
    }

    public int getZ() {
        return bit_z;
    }

    public int getV() {
        return bit_v;
    }

    public int getC() {
        return bit_c;
    }


    public void setE(int val) {
        bit_e = val;
    }

    public void setF(int val) {
        bit_f = val;
    }

    public void setH(int val) {
        bit_h = val;
    }

    public void setI(int val) {
        bit_i = val;
    }

    public void setN(int val) {
        bit_n = val;
    }

    public void setZ(int val) {
        bit_z = val;
    }

    public void setV(int val) {
        bit_v = val;
    }

    public void setC(int val) {
        bit_c = val;
    }

    public void setE(boolean val) {
        bit_e = val ? 1 : 0;
    }

    public void setF(boolean val) {
        bit_f = val ? 1 : 0;
    }

    public void setH(boolean val) {
        bit_h = val ? 1 : 0;
    }

    public void setI(boolean val) {
        bit_i = val ? 1 : 0;
    }

    public void setN(boolean val) {
        bit_n = val ? 1 : 0;
    }

    public void setZ(boolean val) {
        bit_z = val ? 1 : 0;
    }

    public void setV(boolean val) {
        bit_v = val ? 1 : 0;
    }

    public void setC(boolean val) {
        bit_c = val ? 1 : 0;
    }
}

