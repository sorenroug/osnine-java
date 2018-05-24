package org.roug.osnine;

/**
 * RAM segment.
 */
public class ReadOnlyMemory extends MemorySegment {

    private int memorySize;

    /** Memory space. */
    private int[] memory;

    /**
     * Constructor.
     * The size of the RAM segment is the first argument.
     */
    public ReadOnlyMemory(int start, Bus8Motorola bus, String... args) {
        super(start);
        int size = Integer.decode(args[0]).intValue();
        setEndAddress(start + size);
        this.memorySize = size;
        memory = new int[size];
    }

    @Override
    protected int load(int addr) {
        return memory[addr - getStartAddress()];
    }

    @Override
    protected void store(int addr, int val) {
    }

    @Override
    protected void burn(int addr, int val) {
        memory[addr - getStartAddress()] = val & 0xff;
    }
}