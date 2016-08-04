package org.roug.osnine;

public class MemoryBank implements MemorySegment {

    private int memorySize;

    private int offset;

    /** Memory space. */
    private int[] memory;

    public MemoryBank(int start, int size) {
        if (size < 0 || size > 65536) {
            throw new IllegalArgumentException("Max allocation is 65536");
        }
        this.offset = start;
        this.memorySize = size;
        memory = new int[size];
    }

    @Override
    public void reset() {
    }

    @Override
    public int read(int addr) {
        addr -= offset;
        if (addr < 0 || addr >= memorySize) {
            throw new IllegalArgumentException("Out of bounds");
        }
        return memory[addr];
    }

    @Override
    public void write(int addr, int val) {
        addr -= offset;
        if (addr < 0 || addr >= memorySize) {
            throw new IllegalArgumentException("Out of bounds");
        }
        memory[addr] = val & 0xff;
    }


}
