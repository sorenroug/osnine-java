package org.roug.osnine;

/**
 * Bus in a computer - Motorola-style. Links CPU, memory and devices together.
 */
public interface MemoryBus {

    /**
     * Single byte read from memory.
     *
     * @param offset - the address in memory to read from
     * @return the byte value of the address.
     */
    int read(int offset);

    /**
     * Single byte write to memory.
     *
     * @param offset - the address in memory to read from
     * @param val - the byte value to store
     */
    void write(int offset, int val);

    /**
     * Single byte write to memory.
     *
     * @param offset - the address in memory to read from
     * @param val - the byte value to store
     */
    void forceWrite(int offset, int val);

    /**
     * Install a memory segment as the last item of the list of segments.
     *
     * @param newMemory - the memory segment to append.
     */
    void addMemorySegment(MemorySegment newMemory);

    /**
     * Install a memory segment as the first item of the list of segments.
     *
     * @param newMemory - the memory segment to insert.
     */
    void insertMemorySegment(MemorySegment newMemory);

}

