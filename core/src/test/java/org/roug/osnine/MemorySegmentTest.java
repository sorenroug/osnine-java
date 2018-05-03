package org.roug.osnine;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class MemorySegmentTest {

    /**
     * 
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

        cpu.write(0x0400, 0x34);
        assertEquals(0x34, cpu.read(0x0400));
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
//      MemoryBank mb = new MemoryBank(70000);
//  }

    //@Test(expected = IllegalArgumentException.class)
    @Test
    public void illegalRead() {
        MemoryBank mb = new MemoryBank(10000, 1024);
        mb.write(900, 65);
    }

    /**
     * Create bus manually and connect it to the CPU.
     */
    @Test
    public void manualBus() {
        Bus6809 bus = new BusStraight();
        MemorySegment newMemory = new MemoryBank(0, 0x10000);
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
        Bus6809 bus = new BusStraight();

        MC6809 cpu = new MC6809(bus);
        cpu.write(0xffff, 1);
        assertEquals(1, cpu.read(0xffff));
    }

}

