package org.roug.osnine;

import java.io.IOException;

/**
 * Simple debugging console.
 * When the CPU writes a byte to the location of the console the byte is
 * printed to STDOUT.
 */
public class Console extends MemorySegment {

    /** Location of console in memory. */
    private int offset;

    public Console(int start) {
        this.offset = start;
    }

    @Override
    public void reset() {
    }

    @Override
    public int read(int addr) {
        if (addr != offset) {
            if (nextSegment == null) {
                throw new IllegalArgumentException("Out of bounds: " + Integer.toString(addr));
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
                throw new IllegalArgumentException("Out of bounds: " + Integer.toString(addr));
            } else {
                nextSegment.write(addr, val);
            }
        }
        System.out.write(val);
        System.out.flush();
    }

}
