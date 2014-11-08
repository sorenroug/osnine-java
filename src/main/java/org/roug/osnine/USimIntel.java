package org.roug.osnine;
    //----------------------------------------------------------------------------
    // Word memory access routines for little-endian (Intel type)
    //----------------------------------------------------------------------------

public abstract class USimIntel extends USim {

    /**
     * Read 16-bit word for little-endian (Intel type).
     */
    public int read_word(int offset) {
        int tmp;

        tmp = read(offset++);
        tmp |= (read(offset) << 8);

        return tmp;
    }

    /**
     * Write 16-bit word for little-endian (Intel type).
     */
    public void write_word(int offset, int val)
    {
        write(offset++, val);
        write(offset, (val >> 8));
    }

}
