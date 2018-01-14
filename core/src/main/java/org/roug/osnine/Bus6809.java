package org.roug.osnine;

/**
 * Bus in a computer. Links CPU, memory and devices together.
 * How is the CPU attached to this?
 */
public interface Bus6809 {

    /**
     * Single byte read from memory.
     */
    int read(int offset);

    /**
     * Single byte write to memory.
     */
    void write(int offset, int val);

    /**
     * Install a memory segment as the last item of the list of segments.
     */
    void addMemorySegment(MemorySegment newMemory);

    /**
     * Install a memory segment as the first item of the list of segments.
     */
    void insertMemorySegment(MemorySegment newMemory);

    void signalIRQ(boolean state);

}

