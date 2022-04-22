package org.roug.usim.z80;

import org.roug.usim.UByte;
import org.roug.usim.Register;

/**
 * Flag register.
 */
public class FlagRegister extends UByte implements Register {
   
    private int all;    // Condition code register


    /** Unused. */
    public int bit_y;

    /** Unused. */
    public int bit_x;

    /** Sign. */
    public int bit_s;

    /** Zero. */
    public int bit_z;

    /** Half carry. */
    public int bit_h;

    /**  Parity/Overflow. */
    public int bit_pv;

    /** Add/Subtract. */
    public int bit_n;
    
    /** Carry. */
    public int bit_c;

    /**
     * Get all condition codes as one byte.
     */
    @Override
    public int get() {
        int combined = (bit_s << 7)
            | (bit_z << 6)
            | (bit_y << 5)
            | (bit_h << 4)
            | (bit_x << 3)
            | (bit_pv << 2)
            | (bit_n << 1)
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
        bit_s = (newValue & 0x80) >> 7;
        bit_z = (newValue & 0x40) >> 6;
        bit_y = (newValue & 0x20) >> 5;
        bit_h = (newValue & 0x10) >> 4;
        bit_x = (newValue & 0x08) >> 3;
        bit_pv = (newValue & 0x04) >> 2;
        bit_n = (newValue & 0x02) >> 1;
        bit_c = newValue & 0x01;
    }

    public void clear() {
        bit_s = 0;
        bit_z = 0;
        bit_y = 0;
        bit_h = 0;
        bit_x = 0;
        bit_pv = 0;
        bit_n = 0;
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
        return ((all & (1 << n)) != 0) ? 1 : 0;
    }

    //FIXME
    @Override
    public void bset(int n) {
        all |= 1 << n;
    }

    //FIXME
    @Override
    public void bclr(int n) {
        all &= ~(1 << n);
    }

    public boolean isSetE() {
        return bit_y != 0;
    }

    public boolean isSetF() {
        return bit_x != 0;
    }

    public boolean isSetH() {
        return bit_h != 0;
    }

    public boolean isSetI() {
        return bit_s != 0;
    }

    public boolean isSetN() {
        return bit_n != 0;
    }

    public boolean isSetS() {
        return bit_s != 0;
    }

    public boolean isSetZ() {
        return bit_z != 0;
    }

    public boolean isSetPV() {
        return bit_pv != 0;
    }

    public boolean isSetC() {
        return bit_c != 0;
    }

    public int getE() {
        return bit_y;
    }

    public int getF() {
        return bit_x;
    }

    public int getH() {
        return bit_h;
    }

    public int getI() {
        return bit_s;
    }

    public int getN() {
        return bit_n;
    }

    public int getS() {
        return bit_s;
    }

    public int getZ() {
        return bit_z;
    }

    public int getPV() {
        return bit_pv;
    }

    public int getC() {
        return bit_c;
    }


    public void setE(int val) {
        bit_y = val;
    }

    public void setF(int val) {
        bit_x = val;
    }

    public void setH(int val) {
        bit_h = val;
    }

    public void setI(int val) {
        bit_s = val;
    }

    public void setN(int val) {
        bit_n = val;
    }

    public void setS(int val) {
        bit_s = val;
    }

    public void setZ(int val) {
        bit_z = val;
    }

    public void setPV(int val) {
        bit_pv = val;
    }

    public void setC(int val) {
        bit_c = val;
    }

    public void setE(boolean val) {
        bit_y = val ? 1 : 0;
    }

    public void setF(boolean val) {
        bit_x = val ? 1 : 0;
    }

    public void setH(boolean val) {
        bit_h = val ? 1 : 0;
    }

    public void setI(boolean val) {
        bit_s = val ? 1 : 0;
    }

    public void setN(boolean val) {
        bit_n = val ? 1 : 0;
    }

    public void setS(boolean val) {
        bit_s = val ? 1 : 0;
    }

    public void setZ(boolean val) {
        bit_z = val ? 1 : 0;
    }

    public void setPV(boolean val) {
        bit_pv = val ? 1 : 0;
    }

    public void setC(boolean val) {
        bit_c = val ? 1 : 0;
    }
}

