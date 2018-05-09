package org.roug.osnine;

/**
 * RAM segment.
 */
public class RAMMemory extends MemorySegment {

    private int memorySize;

    /** Memory space. */
    private int[] memory;

    /**
     * Constructor.
     */
    public RAMMemory(int size) {
        this(0, size);
    }

    /**
     * Constructor.
     */
    public RAMMemory(int start, int size) {
        super(start, start + size);
        this.memorySize = size;
        memory = new int[size];
    }

    @Override
    protected int load(int addr) {
        return memory[addr - getStartAddress()];
    }

    @Override
    protected void store(int addr, int val) {
        memory[addr - getStartAddress()] = val & 0xff;
    }
}
