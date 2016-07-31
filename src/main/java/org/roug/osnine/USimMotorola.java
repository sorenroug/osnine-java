package org.roug.osnine;

/**
 * Word memory access routines for big-endian (Motorola type).
 */ 
public class USimMotorola extends USim {

    /**
     * Constructor.
     */
    public USimMotorola() {
        super();
    }

    /**
     * Constructor.
     */
    public USimMotorola(int memorySize) {
        super(memorySize);
    }

    /**
     * Read 16-bit word for big-endian (Motorola type).
     */
    @Override
    public int read_word(int offset) {
        int tmp1 = read(offset);
        offset++;
        int tmp2 = read(offset);

        return (tmp1 << 8) | tmp2;
    }

    /**
     * Read 16-bit word for big-endian (Motorola type).
     */
    @Override
    public int read_word(Word offset) {
        int tmp1 = read(offset);
        offset.inc();
        int tmp2 = read(offset);

        return (tmp1 << 8) | tmp2;
    }

    /**
     * Write 16-bit word for big-endian (Motorola type).
     */
    @Override
    public void write_word(int offset, int val) {
        write(offset, (val >> 8));
        offset++;
        write(offset, val);
    }

    /**
     * Write 16-bit word for big-endian (Motorola type).
     */
    @Override
    public void write_word(Word offset, Word val) {
        write(offset, UByte.valueOf((val.get() >> 8)));
        offset.inc();
        write(offset, val.ubyteValue());
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
