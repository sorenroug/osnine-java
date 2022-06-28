package org.roug.usim;

import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class USimMotorolaTest {

    class USimMotorolaDerived extends USimMotorola {

        public USimMotorolaDerived(Bus8Motorola bus) {
            super(bus);
        }

        @Override
        public void reset() {
            // Not needed today
        }

        @Override
        public void status() {
            // Not needed today
        }

        @Override
        public void execute() {
            // Not needed today
        }
    }

    /**
     * Write 0xAA to address 0x100 and read it back.
     */
    @Test
    public void writeReadOneByte() {
        Bus8Motorola bus = new BusStraight();
        USimMotorola tInstance = new USimMotorolaDerived(bus);
        MemorySegment newMemory = new RandomAccessMemory(0, bus, "0x400");
        bus.addMemorySegment(newMemory);
        //UByte val = UByte.valueOf(0xAA);
        tInstance.write(0x100, 0xAA);
        int result = tInstance.read(0x100);
        assertEquals(0xAA, result);
    }

    /**
     * Write 0xAACC to address 0x100 and read it back.
     */
    @Test
    public void writeReadOneWord() {
        Bus8Motorola bus = new BusStraight();
        USimMotorola tInstance = new USimMotorolaDerived(bus);
        MemorySegment newMemory = new RandomAccessMemory(0, bus, "0x400");
        bus.addMemorySegment(newMemory);

        tInstance.write_word(0x100, 0xAACC);
        int result = tInstance.read_word(0x100);
        assertEquals(0xAACC, result);

        result = tInstance.read(0x100);
        assertEquals(0xAA, result);
        result = tInstance.read(0x101);
        assertEquals(0xCC, result);
    }
}
