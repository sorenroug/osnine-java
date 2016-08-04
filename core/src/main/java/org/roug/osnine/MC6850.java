package org.roug.osnine;

import java.io.IOException;

public class MC6850 extends MemorySegment {

    /** Location of UART. */
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
