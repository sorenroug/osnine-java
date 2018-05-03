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
        this.startAddress = startAddress;
        this.endAddress = endAddress;
    }

    public boolean inSegment(int addr) {
        return (addr >= startAddress && addr < endAddress);
    }

    public int getStartAddress() {
        return startAddress;
    }

    public int getEndAddress() {
        return endAddress;
    }

    //public abstract void reset();

    /**
     * Single byte read from memory.
     */
    protected abstract int load(int addr);

    /**
     * Read from memory. If there is no memory at that location then return 0.
     * OS9 scans the entire memory space.
     */
    public int read(int addr) {
        if (!inSegment(addr)) {
            if (nextSegment == null) {
                return 0;
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

    /**
     * Write a byte to memory. If there is no memory, ignore.
     */
    public void write(int addr, int val) {
        if (!inSegment(addr)) {
            if (nextSegment == null) {
                return;
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
