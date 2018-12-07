package org.roug.osnine;

import java.io.IOException;

/**
 * Simple debugging console.
 * When the CPU writes a byte to the location of the console the byte is
 * printed to STDOUT.
 */
public class Console extends MemorySegment {

    /**
     * Constructor.
     *
     * @param start - the one-byte address the console will be at.
     */
    public Console(int start) {
        super(start, start);
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
        System.out.flush();
    }

}
