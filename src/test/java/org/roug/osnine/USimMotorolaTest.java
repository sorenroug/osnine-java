package org.roug.osnine;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class USimMotorolaTest extends USimMotorola {

    public void execute() {
    }

    public void status() {
    }

    public void reset() {
    }

    /**
     * Write 0xAA to address 0x100 and read it back.
     */
    @Test
    public void writeReadOneByte() {
        USimMotorolaTest tInstance = new USimMotorolaTest();
        tInstance.allocate_memory(0x400);
        tInstance.write(0x100, 0xAA);
        int result = tInstance.read(0x100);
        assertEquals(0xAA, result);
    }

    /**
     * Write 0xAACC to address 0x100 and read it back.
     */
    @Test
    public void writeReadOneWord() {
        USimMotorolaTest tInstance = new USimMotorolaTest();
        tInstance.allocate_memory(0x400);
        tInstance.write_word(0x100, 0xAACC);
        int result = tInstance.read_word(0x100);
        assertEquals(0xAACC, result);

        result = tInstance.read(0x100);
        assertEquals(0xAA, result);
        result = tInstance.read(0x101);
        assertEquals(0xCC, result);
    }

    @Test
    public void readJunkSRecord() throws IOException {
        byte input[] = { 'a','b' };
        USimMotorolaTest tInstance = new USimMotorolaTest();
        tInstance.allocate_memory(0x400);

        ByteArrayInputStream is = new ByteArrayInputStream(input);
        tInstance.load_srecord(is);
    }

    /**
     * Load data from address 0x0000 to 0x0037.
     * See http://www.amelek.gda.pl/avr/uisp/srecord.htm
     */
    @Test
    public void readSRecord() throws IOException {
        String input = "S00600004844521B\n"
            + "S1130000285F245F2212226A000424290008237C2A\n"
            + "S11300100002000800082629001853812341001813\r\n"
            + "S113002041E900084E42234300182342000824A952\n"
            + "S107003000144ED492\n"
            + "S5030004F8\n"
            + "S9030000FC\n";
        byte byteInput[] = input.getBytes(Charset.forName("US-ASCII"));
        USimMotorolaTest tInstance = new USimMotorolaTest();
        tInstance.allocate_memory(0x400);

        ByteArrayInputStream is = new ByteArrayInputStream(byteInput);
        tInstance.load_srecord(is);

        int result = tInstance.read(0x11);
        assertEquals(0x02, result);
        result = tInstance.read(0x33);
        assertEquals(0xD4, result);
    }

    /**
     * Load data from address 0x0000 to 0x0037.
     * 
     */
    @Test
    public void readIntelHex() throws IOException {
        String input = ":020000000132CB\n"
            + ":0600320000B29002003252\r\n"
            + ":00000001FF\n";
        byte byteInput[] = input.getBytes(Charset.forName("US-ASCII"));
        USimMotorolaTest tInstance = new USimMotorolaTest();
        tInstance.allocate_memory(0x400);

        ByteArrayInputStream is = new ByteArrayInputStream(byteInput);
        tInstance.load_intelhex(is);

        int result = tInstance.read(0x01);
        assertEquals(0x32, result);
        result = tInstance.read(0x33);
        assertEquals(0xB2, result);
    }

}
