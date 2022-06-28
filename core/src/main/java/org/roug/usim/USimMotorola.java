package org.roug.usim;

/**
 * Word memory access routines for big-endian (Motorola type).
 */ 
public abstract class USimMotorola extends USim {

    /**
     * Constructor.
     *
     * @param bus the bus that the CPU is attached to.
     */
    public USimMotorola(Bus8Motorola bus) {
        super(bus);
    }

    /**
     * Read 16-bit word for big-endian (Motorola type).
     */
    @Override
    public int read_word(int offset) {
        int tmp1 = read(offset & 0xffff);
        offset++;
        int tmp2 = read(offset & 0xffff);

        return (tmp1 << 8) | tmp2;
    }

    /**
     * Read 16-bit word for big-endian (Motorola type).
     */
    @Override
    public int read_word(Word offset) {
        return read_word(offset.intValue());
    }

    /**
     * Write 16-bit word for big-endian (Motorola type).
     */
    @Override
    public void write_word(int offset, int val) {
        write(offset & 0xffff, (val >> 8) & 0xFF);
        offset++;
        write(offset & 0xffff, val & 0xFF);
    }

    /**
     * Write 16-bit word for big-endian (Motorola type).
     */
    @Override
    public void write_word(Word offset, Word val) {
        write_word(offset.intValue(), val.intValue());
    }

}
