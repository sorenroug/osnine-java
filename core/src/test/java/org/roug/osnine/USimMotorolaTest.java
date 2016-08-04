package org.roug.osnine;

import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class USimMotorolaTest {

    /**
     * Write 0xAA to address 0x100 and read it back.
     */
    @Test
    public void writeReadOneByte() {
        USimMotorola tInstance = new USimMotorola();
        tInstance.allocate_memory(0, 0x400);
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
        USimMotorola tInstance = new USimMotorola();
        tInstance.allocate_memory(0, 0x400);
        tInstance.write_word(0x100, 0xAACC);
        int result = tInstance.read_word(0x100);
        assertEquals(0xAACC, result);

        result = tInstance.read(0x100);
        assertEquals(0xAA, result);
        result = tInstance.read(0x101);
        assertEquals(0xCC, result);
    }
}
