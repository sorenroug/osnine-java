package org.roug.osnine;

/**
 * Abstract class for any type of memory - ROM, RAM or device.
 */
public abstract class MemorySegment {

    /** First address where the segment reacts. */
    private int startAddress;

    /** Last address where the segment reacts. */
    private int endAddress;

    protected MemorySegment nextSegment = null;

    /**
     * Constructor.
     * Sets the end address to the start address.
     */
    public MemorySegment(int startAddress) {
        this.startAddress = startAddress;
        this.endAddress = startAddress;
    }

    /**
     * Constructor.
     */
    public MemorySegment(int startAddress, int endAddress) {
        this.startAddress = startAddress;
        this.endAddress = endAddress;
    }

    public boolean inSegment(int addr) {
        return addr >= startAddress && addr < endAddress;
    }

    public int getStartAddress() {
        return startAddress;
    }

    /**
     * Set the start address of the segment.
     */
    public void setStartAddress(int address) {
        startAddress = address;
    }

    public int getEndAddress() {
        return endAddress;
    }

    /**
     * Set the end address of the segment.
     */
    public void setEndAddress(int address) {
        endAddress = address;
    }

    /**
     * Single byte read from memory.
     */
    protected abstract int load(int addr);

    /**
     * Read from memory. If there is no memory at that location then return 0.
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

    /**
     * Single byte write to memory.
     */
    protected void burn(int addr, int val) {
        store(addr, val);
    }


    /**
     * Forcefully write a byte to memory. If there is no memory, ignore.
     */
    public void forceWrite(int addr, int val) {
        if (!inSegment(addr)) {
            if (nextSegment == null) {
                return;
            } else {
                nextSegment.forceWrite(addr, val);
            }
        } else {
            burn(addr, val);
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
