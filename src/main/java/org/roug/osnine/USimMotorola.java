package org.roug.osnine;
    //----------------------------------------------------------------------------
    // Word memory access routines for big-endian (Motorola type)
    //----------------------------------------------------------------------------

public abstract class USimMotorola extends USim {

    /**
     * Read 16-bit word for big-endian (Motorola type).
     */
    public int read_word(int offset) {
        int tmp;

        tmp = read(offset++);
        tmp <<= 8;
        tmp |= read(offset);

        return tmp;
    }

    /**
     * Write 16-bit word for big-endian (Motorola type).
     */
    public void write_word(int offset, int val) {
        write(offset++, (val >> 8));
        write(offset, val);
    }
}
