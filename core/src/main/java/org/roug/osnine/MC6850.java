package org.roug.osnine;

import java.io.IOException;

/**
 * Motorola 6850 Asynchronous Communications Interface Adapter (ACIA).
 * It includes a universal asynchronous receiver-transmitter (UART).
 * The essential function of the ACIA is serial-to-parallel and
 * parallel-to-serial conversion.
 */
public class MC6850 extends MemorySegment {

    /** Location of ACIA in memory. */
    private int offset;

    /**
     * Constructor.
     */
    public MC6850(int start) {
        super(start, start);
        this.offset = start;
    }

    @Override
    public void reset() {
    }

    @Override
    protected int load(int addr) {
        try {
            return System.in.read();
        } catch (IOException e) {
            System.exit(1);
            return -1;
        }
    }

    @Override
    protected void store(int addr, int val) {
        System.out.write(val);
    }

}
