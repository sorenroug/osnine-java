package org.roug.usim;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;


public class BusGimixEnhancedTest {

    private static final int TASK_REG = 0xFF7F;
    private static final int DAT_REGS = 0xFFF0;

    private BusGimixEnhanced bus;

    @Before
    public void setup() {
        bus = new BusGimixEnhanced();

        // Set all blocks in all tasks to 0
        for (int t = 0; t < 16; t++) {
            for (int b = 0; b < 16; b++) {
                bus.write(TASK_REG, 0x20 + t);
                bus.write(DAT_REGS + b, 0x00);
            }
        }
    }

    /**
     * Test that ROM is mapped to $FF00 at startup.
     */
    @Test
    public void initialROMMap() {
        MemorySegment newMemory = new ReadOnlyMemory(0xFFF00, 0x100);
        newMemory.burn(0xFFF10, 0xAA);
        bus.addMemorySegment(newMemory);
        assertEquals(0xAA, newMemory.load(0xFFF10));
        assertEquals(0xAA, bus.read(0xFF10));

        newMemory.burn(0xFFF10, 0x1B);
        assertEquals(0x1B, newMemory.load(0xFFF10));
        // Test that it is Read-only
        newMemory.store(0xFFF10, 0x34);
        assertEquals(0x1B, newMemory.load(0xFFF10));
    }

    /**
     * Test that ROM at 0xFC000 can be mapped to another place.
     */
    @Test
    public void mmuMap1() {
        MemorySegment newMemory = new ReadOnlyMemory(0xFC000, 0x2000);
        newMemory.burn(0xFC100, 0xAA);
        bus.addMemorySegment(newMemory);

        bus.write(TASK_REG, 0x29); // Set task to 0x09
        bus.write(DAT_REGS + 3, 0xFC); // Set block 3 in task 9 to 0xFC000

        bus.write(TASK_REG, 0x22); // Set task to 0x02
        bus.write(DAT_REGS + 3, 0xFE); // Set block 3 in task 2 to 0xFE000

        bus.write(TASK_REG, 0x29); // Set task to 0x09 and read 0x3100
        assertEquals(0xAA, bus.read(0x3100));

        bus.write(TASK_REG, 0x22); // Set task to 0x02 and read 0x3100
        assertEquals(0x00, bus.read(0x3100));

        bus.write(TASK_REG, 0x29); // Set task to 0x09 and read 0x3100
        assertEquals(0xAA, bus.read(0x3100));
    }


    /**
     * Test that it is possible to write via the MMU
     */
    @Test
    public void mmuWrite() {
        MemorySegment newMemory = new RandomAccessMemory(0xFE000, 0x1000);
        newMemory.burn(0xFE100, 0xAA);
        bus.addMemorySegment(newMemory);

        bus.write(TASK_REG, 0x29); // Set task to 0x09
        bus.write(DAT_REGS + 3, 0xFE); // Set block 3 in task 9 to 0xFE000
        bus.write(0x3100, 0x01);
        assertEquals(0x01, bus.read(0x3100));
        assertEquals(0x00, bus.read(0xE100));

        // Map the same block to two logical addresses
        bus.write(DAT_REGS + 14, 0xFE); // Set block 14 in task 9 to 0xFE000
        bus.write(0xE100, 0x11);
        assertEquals(0x11, bus.read(0x3100));
        assertEquals(0x11, bus.read(0xE100));
    }

}

