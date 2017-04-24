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

    /**
     * Constructor.
     */
    public SWI2Trap(OS9 cpu) {
        super(0xfff4, 0xfff4);
        this.cpu = cpu;
        this.offset = 0xfff4;
    }

    @Override
    public void reset() {
    }

    @Override
    public int load(int addr) {
        return 0;
    }

    @Override
    public void store(int addr, int val) {
    }

}
