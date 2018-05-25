package org.roug.osnine;

/**
 * Bus in a computer - Motorola-style. Links CPU, memory and devices together.
 */
public interface MemoryBus {

    /**
     * Single byte read from memory.
     */
    int read(int offset);

    /**
     * Single byte write to memory.
     */
    void write(int offset, int val);

    /**
     * Single byte write to memory.
     */
    void forceWrite(int offset, int val);

    /**
     * Install a memory segment as the last item of the list of segments.
     */
    void addMemorySegment(MemorySegment newMemory);

    /**
     * Install a memory segment as the first item of the list of segments.
     */
    void insertMemorySegment(MemorySegment newMemory);

}

