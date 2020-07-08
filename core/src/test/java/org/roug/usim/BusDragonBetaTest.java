package org.roug.usim;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;


public class BusDragonBetaTest {

   private BusDragonBeta bus;

    @Before
    public void setup() {
        bus = new BusDragonBeta();
//        MemorySegment newMemory = new RandomAccessMemory(0, 0x1000);
//        bus.addMemorySegment(newMemory);
    }

    /**
     * Test that ROM is mapped to $C000 at startup.
     */
    @Test
    public void initialROMMap() {
        MemorySegment newMemory = new ReadOnlyMemory(0xFC000, 0x300);
        newMemory.burn(0xFC100, 0xAA);
        bus.addMemorySegment(newMemory);
        assertEquals(0xAA, newMemory.load(0xFC100));
        assertEquals(0xAA, bus.read(0xC100));

        newMemory.burn(0xFC100, 0x1B);
        assertEquals(0x1B, newMemory.load(0xFC100));
        // Test that it is Read-only
        newMemory.store(0xFC100, 0x34);
        assertEquals(0x1B, newMemory.load(0xFC100));
    }

    /**
     * Test that RAM at $0000 is mapped to $0000 at startup.
     */
    @Test
    public void initialMappedRAM() {
        MemorySegment newMemory = new ReadOnlyMemory(0xFC000, 0x300);
        newMemory.burn(0xFC100, 0xAA);
        bus.addMemorySegment(newMemory);
        assertEquals(0xAA, newMemory.load(0xFC100));
        assertEquals(0xAA, bus.read(0xC100));

        newMemory = new RandomAccessMemory(0x0000, 0x1000);
        bus.addMemorySegment(newMemory);
        newMemory.burn(0x0200, 0x1B);
        assertEquals(0x1B, newMemory.load(0x0200));
        assertEquals(0x1B, bus.read(0x0200));

        bus.write(0x0200, 0x99);
        assertEquals(0x99, newMemory.load(0x0200));
        assertEquals(0x99, bus.read(0x0200));
    }

    /**
     * Test that ROM at 0xFC000 can be mapped to another place.
     */
    @Test
    public void mmuMap1() {
        MemorySegment newMemory = new ReadOnlyMemory(0xFC000, 0x1000);
        newMemory.burn(0xFC100, 0xAA);
        bus.addMemorySegment(newMemory);
        bus.write(0xFCC0, 0xF9); // Set task to 0x09 and turn off mmu
        bus.write(0xFE03, 0xFC); // Set block 3 in task 9 to 0xFC000
        assertEquals(0xAA, bus.read(0x3100));
    }
}

