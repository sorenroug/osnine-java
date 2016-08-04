package org.roug.osnine;

public abstract class MemorySegment {

    protected MemorySegment nextSegment = null;

    public abstract void reset();

    /**
     * Single byte read from memory.
     */
    public abstract int read(int addr);

    /**
     * Single byte write to memory.
     */
    public abstract void write(int addr, int val);

    public void addMemorySegment(MemorySegment segment) {
        if (nextSegment == null) {
            nextSegment = segment;
        } else {
            nextSegment.addMemorySegment(segment);
        }
    }

}
