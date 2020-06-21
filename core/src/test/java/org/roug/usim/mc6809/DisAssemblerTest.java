package org.roug.usim.mc6809;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

import org.roug.usim.Bus8Motorola;
import org.roug.usim.BusStraight;
import org.roug.usim.MemorySegment;
import org.roug.usim.RandomAccessMemory;

public class DisAssemblerTest {

    private class DisAssemblerMock extends DisAssembler {

        private StringBuilder resultBuf = new StringBuilder();
        
        public DisAssemblerMock(MC6809 cpu) {
            super(cpu);
        }

        void output(String format, Object... arguments) {
            resultBuf.append(String.format(format, arguments));
        }

        String result() {
            return resultBuf.toString();
        }

    }

//  @Test(expected = IllegalArgumentException.class)
//  public void oversizeMemoryBank() {
//      RandomAccessMemory mb = new RandomAccessMemory(70000);
//  }

    /**
     * Create bus manually and connect it to the CPU.
     */
    @Test
    public void manualBus() {
        Bus8Motorola bus = new BusStraight();
        MemorySegment newMemory = new RandomAccessMemory(0, bus, "0x1000");
        bus.addMemorySegment(newMemory);

        MC6809 cpu = new MC6809(bus);
        cpu.write(0x0300, 0x39);
        cpu.pc.set(0x300);

        DisAssemblerMock disAsm = new DisAssemblerMock(cpu);
        disAsm.disasmPC();
        assertEquals("|CC=50|A=00|B=00|X=0000|Y=0000|U=0000|S=0000|  0300: 39             RTS             \n", disAsm.result());
    }




}

