package org.roug.osnine;

public class MemoryBank extends MemorySegment {

    private int memorySize;

    /** Location of first address. */
    private int offset;

    /** Memory space. */
    private int[] memory;

    public MemoryBank(int size) {
        this(0, size);
    }

    public MemoryBank(int start, int size) {
        super(start, start + size);
        this.offset = start;
        this.memorySize = size;
        memory = new int[size];
    }

    @Override
    public void reset() {
    }

    @Override
    protected int load(int addr) {
        return memory[addr - offset];
    }

    @Override
    protected void store(int addr, int val) {
        memory[addr - offset] = val & 0xff;
    }
}
