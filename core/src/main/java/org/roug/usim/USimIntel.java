package org.roug.usim;

/**
 * Word memory access routines for little-endian (Intel type).
 */
public abstract class USimIntel extends USim {

    /**
     * Constructor.
     *
     * @param bus the bus that the CPU is attached to.
     */
    public USimIntel(MemoryBus bus) {
        super(bus);
    }

    /**
     * Read 16-bit word for little-endian (Intel type).
     */
    @Override
    public int read_word(int offset) {
        int tmp1 = read(offset & 0xffff);
        offset += 1;
        int tmp2 = read(offset & 0xffff);

        return tmp1 | (tmp2 << 8);
    }

    /**
     * Read 16-bit word for little-endian (Intel type).
     */
    @Override
    public int read_word(Word offset) {
        return read_word(offset.intValue());
    }

    /**
     * Write 16-bit word for little-endian (Intel type).
     */
    @Override
    public void write_word(int offset, int val) {
        write(offset & 0xffff, val);
        offset++;
        write(offset & 0xffff, (val >> 8));
    }

    /**
     * Write 16-bit word for little-endian (Intel type).
     */
    @Override
    public void write_word(Word offset, Word val) {
        write_word(offset.intValue(), val.intValue());
    }

}
