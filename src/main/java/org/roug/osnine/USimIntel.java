package org.roug.osnine;

/**
 * Word memory access routines for little-endian (Intel type).
 */
public class USimIntel extends USim {

    /**
     * Constructor.
     */
    public USimIntel() {
        super();
    }

    /**
     * Constructor.
     */
    public USimIntel(int memorySize) {
        super(memorySize);
    }


    /**
     * Read 16-bit word for little-endian (Intel type).
     */
    @Override
    public int read_word(int offset) {
        int tmp1 = read(offset);
        offset += 1;
        int tmp2 = read(offset);

        return tmp1 | (tmp2 << 8);
    }

    /**
     * Read 16-bit word for little-endian (Intel type).
     */
    @Override
    public int read_word(Word offset) {
        int tmp1 = read(offset);
        offset.inc();
        int tmp2 = read(offset);

        return tmp1 | (tmp2 << 8);
    }

    /**
     * Write 16-bit word for little-endian (Intel type).
     */
    @Override
    public void write_word(int offset, Word val)
    {
        write(offset, val.ubyteValue());
        offset++;
        write(offset, UByte.valueOf((val.get() >> 8)));
    }

    /**
     * Write 16-bit word for little-endian (Intel type).
     */
    @Override
    public void write_word(Word offset, Word val)
    {
        write(offset, val.ubyteValue());
        offset.inc();
        write(offset, UByte.valueOf((val.get() >> 8)));
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
