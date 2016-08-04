package org.roug.osnine;

public interface MemorySegment {

    void reset();

    /**
     * Single byte read from memory.
     */
    int read(int addr);

    /**
     * Single byte write to memory.
     */
    void write(int addr, int val);

}
