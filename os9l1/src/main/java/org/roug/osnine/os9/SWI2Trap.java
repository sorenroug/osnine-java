package org.roug.osnine.os9;

import org.roug.osnine.MemorySegment;
import java.io.IOException;

/**
 * Catch calls to SWI2.
 * This is then used to perform an OS9 system call.
 */
public class SWI2Trap extends MemorySegment {

    /** Location of console in memory. */
    private int offset;

    private OS9 cpu;

    public SWI2Trap(OS9 cpu) {
        this.cpu = cpu;
        this.offset = 0xfff4;
    }

    @Override
    public void reset() {
    }

    @Override
    public int read(int addr) {
        if (addr != offset) {
            if (nextSegment == null) {
                throw new IllegalArgumentException("Out of bounds: " + Integer.valueOf(addr).toString());
            } else {
                return nextSegment.read(addr);
            }
        }
        return 0;
    }

    @Override
    public void write(int addr, int val) {
        if (addr != offset) {
            if (nextSegment == null) {
                throw new IllegalArgumentException("Out of bounds: " + Integer.valueOf(addr).toString());
            } else {
                nextSegment.write(addr, val);
            }
        }
    }

}
