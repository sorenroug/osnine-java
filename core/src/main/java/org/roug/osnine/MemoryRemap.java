package org.roug.osnine;

/**
 * Remap memory locations. For instance on the Dragon 64, the interrupt
 * vectors at $FFF2 and up are mapped to ROM at $BFF2.
 */
public class MemoryRemap extends MemorySegment {

    /** How many locations to remap. */
    private int memorySize;

    /** Relative address for mapping. */
    private int mapOffset;

    /** Reference to bus to fetch byte. */
    private Bus8Motorola bus;

    /**
     * Constructor.
     * The size of the RAM segment is the first argument.
     * Second argument is the location to remap to. (Don't remap with 0 offset.)
     *
     * @param start - First address location of the segment.
     * @param bus - The bus the segment is attached to.
     * @param args - additional arguments
     */
    public MemoryRemap(int start, Bus8Motorola bus, String... args) {
        super(start);
        int size = Integer.decode(args[0]).intValue();
        this.bus = bus;
        setEndAddress(start + size);
        this.memorySize = size;
        int mapLocation = Integer.decode(args[1]).intValue();
        mapOffset = mapLocation - start;
    }

    @Override
    protected int load(int addr) {
        return bus.read(addr + mapOffset);
    }

    @Override
    protected void store(int addr, int val) {
        bus.write(addr + mapOffset, val);
    }

}
