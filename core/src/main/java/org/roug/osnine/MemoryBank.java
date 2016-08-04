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
        if (addr < offset || addr >= offset + memorySize) {
            if (nextSegment == null) {
                throw new IllegalArgumentException("Out of bounds");
            } else {
                return nextSegment.read(addr);
            }
        }
        return memory[addr - offset];
    }

    @Override
    public void write(int addr, int val) {
        if (addr < offset || addr >= offset + memorySize) {
            if (nextSegment == null) {
                throw new IllegalArgumentException("Out of bounds");
            } else {
                nextSegment.write(addr, val);
            }
        } else {
            memory[addr - offset] = val & 0xff;
        }
    }
}
