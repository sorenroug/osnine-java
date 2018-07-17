package org.roug.osnine;

/**
 * ROM segment.
 */
public class ReadOnlyMemory extends MemorySegment {

    private int memorySize;

    /** Memory space. */
    private byte[] memory;

    /**
     * Constructor.
     * The size of the RAM segment is the first argument.
     */
    public ReadOnlyMemory(int start, Bus8Motorola bus, String... args) {
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
    }

    @Override
    protected void burn(int addr, int val) {
        memory[addr - getStartAddress()] = (byte)(val & 0xFF);
    }
}
