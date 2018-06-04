package org.roug.osnine;

/**
 * Word memory access routines for little-endian (Intel type).
 */
public class USimIntel extends USim {

    /**
     * Constructor.
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

    @Override
    public void reset() {
    }

    @Override
    public void status() {
    }

    @Override
    public void execute() {
    }

}
