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

    public MC6850(int start) {
        this.offset = start;
    }

    @Override
    public void reset() {
    }

    @Override
    public int read(int addr) {
        if (addr != offset) {
            if (nextSegment == null) {
                throw new IllegalArgumentException("Out of bounds");
            } else {
                return nextSegment.read(addr);
            }
        }
        try {
            return System.in.read();
        } catch (IOException e) {
            System.exit(1);
            return -1;
        }
    }

    @Override
    public void write(int addr, int val) {
        if (addr != offset) {
            if (nextSegment == null) {
                throw new IllegalArgumentException("Out of bounds");
            } else {
                nextSegment.write(addr, val);
            }
        }
        System.out.write(val);
    }

}
