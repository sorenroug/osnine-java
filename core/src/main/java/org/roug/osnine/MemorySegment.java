package org.roug.osnine;

public abstract class MemorySegment {

    /** First address where the segment reacts. */
    private int startAddress;

    /** Last address where the segment reacts. */
    private int endAddress;

    protected MemorySegment nextSegment = null;

    /**
     * Constructor.
     */
    public MemorySegment(int startAddress, int endAddress) {
        if (startAddress < 0 || endAddress > 65536) {
            throw new IllegalArgumentException("Max address is 65536");
        }
        this.startAddress = startAddress;
        this.endAddress = endAddress;
    }

    public boolean inSegment(int addr) {
        return (addr >= startAddress && addr <= endAddress);
    }

    public abstract void reset();

    /**
     * Single byte read from memory.
     */
    protected abstract int load(int addr);

    public int read(int addr) {
        if (!inSegment(addr)) {
            if (nextSegment == null) {
                throw new IllegalArgumentException("Out of bounds: " + Integer.toString(addr));
            } else {
                return nextSegment.read(addr);
            }
        }
        return load(addr);
    }


    /**
     * Single byte write to memory.
     */
    protected abstract void store(int addr, int val);

    public void write(int addr, int val) {
        if (!inSegment(addr)) {
            if (nextSegment == null) {
                throw new IllegalArgumentException("Out of bounds: " + Integer.toString(addr));
            } else {
                nextSegment.write(addr, val);
            }
        } else {
            store(addr, val);
        }
    }

    public void addMemorySegment(MemorySegment segment) {
        if (nextSegment == null) {
            nextSegment = segment;
        } else {
            nextSegment.addMemorySegment(segment);
        }
    }

}
