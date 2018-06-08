package org.roug.osnine;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class MemorySegmentTest {

    /**
     * Write 1 to top memory.
     */
    @Test
    public void writeTop2() {
        MC6809 cpu = new MC6809();
        cpu.write(0xffff, 1);
        assertEquals(1, cpu.read(0xffff));
    }

    @Test
    public void oneExtraMemoryBank() {
        MC6809 cpu = new MC6809(8192);
        cpu.write(0xffff, 1);
        assertEquals(1, cpu.read(0xffff));

        // Try values under 128
        cpu.write(0x0400, 0x34);
        assertEquals(0x34, cpu.read(0x0400));

        // Try values over 128
        cpu.write(0x03F0, 0x91);
        assertEquals(0x91, cpu.read(0x03F0));
    }

    @Test
    public void withConsole() {
        MC6809 cpu = new MC6809(8192);
        cpu.write(0xffff, 1);
        assertEquals(1, cpu.read(0xffff));

        cpu.write(0x0400, 0x34);
        assertEquals(0x34, cpu.read(0x0400));

        Console uart = new Console(0xb000);
        cpu.addMemorySegment(uart);
        for (int i = 0; i < 20; i++) {
            cpu.write(0xb000, 0x40);
        }
        cpu.write(0xb000, 0x0a);
    }

//  @Test(expected = IllegalArgumentException.class)
//  public void oversizeMemoryBank() {
//      RandomAccessMemory mb = new RandomAccessMemory(70000);
//  }

    //@Test(expected = IllegalArgumentException.class)
    @Test
    public void illegalRead() {
        Bus8Motorola bus = new BusStraight();
        RandomAccessMemory mb = new RandomAccessMemory(10000, bus, "1024");
        mb.write(900, 65);
    }

    /**
     * Create bus manually and connect it to the CPU.
     */
    @Test
    public void manualBus() {
        Bus8Motorola bus = new BusStraight();
        MemorySegment newMemory = new RandomAccessMemory(0, bus, "0x10000");
        bus.addMemorySegment(newMemory);

        MC6809 cpu = new MC6809(bus);
        cpu.write(0xffff, 1);
        assertEquals(1, cpu.read(0xffff));
    }


    /**
     * Create bus manually and add no memory.
     */
    @Test(expected = NullPointerException.class)
    public void noMemory() {
        Bus8Motorola bus = new BusStraight();

        MC6809 cpu = new MC6809(bus);
        cpu.write(0xffff, 1);
        assertEquals(1, cpu.read(0xffff));
    }

    @Test
    public void readWrite() {
        MemorySegment newMemory = new RandomAccessMemory(0, null, "0x300");
        newMemory.burn(0x100, 0xAA);
        assertEquals(0xAA, newMemory.load(0x100));

        newMemory.burn(0x100, 0x1B);
        assertEquals(0x1B, newMemory.load(0x100));
        // Test that it is read/write
        newMemory.store(0x100, 0x34);
        assertEquals(0x34, newMemory.load(0x100));
    }

    @Test
    public void readOnly1() {
        MemorySegment newMemory = new ReadOnlyMemory(0, null, "0x300");
        newMemory.burn(0x100, 0xAA);
        assertEquals(0xAA, newMemory.load(0x100));

        newMemory.burn(0x100, 0x1B);
        assertEquals(0x1B, newMemory.load(0x100));
        // Test that it is Read-only
        newMemory.store(0x100, 0x34);
        assertEquals(0x1B, newMemory.load(0x100));
    }

}

