package org.roug.osnine;

public class MemoryBank extends MemorySegment {

    private int memorySize;

    /** Memory space. */
    private int[] memory;

    /**
     * Constructor.
     */
    public MemoryBank(int size) {
        this(0, size);
    }

    /**
     * Constructor.
     */
    public MemoryBank(int start, int size) {
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
