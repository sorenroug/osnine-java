package org.roug.osnine;

/**
 * RAM segment.
 */
public class RandomAccessMemory extends MemorySegment {

    private int memorySize;

    /** Memory space. */
    private byte[] memory;

    /**
     * Constructor.
     * The size of the RAM segment is the first argument.
     *
     * @param start - First address location of the segment.
     * @param bus - The bus the segment is attached to.
     * @param args - additional arguments
     */
    public RandomAccessMemory(int start, Bus8Motorola bus, String... args) {
        super(start);
        int size = Integer.decode(args[0]).intValue();
        setEndAddress(start + size);
        this.memorySize = size;
        memory = new byte[size];
    }

    @Override
    protected int load(int addr) {
        return memory[addr - getStartAddress()] & 0xFF;
    }

    @Override
    protected void store(int addr, int val) {
        memory[addr - getStartAddress()] = (byte)(val & 0xFF);
    }

}
