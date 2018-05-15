package org.roug.osnine;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class LoaderTest {

    @Test(expected = IllegalArgumentException.class)
    public void readJunkSRecord() throws IOException {
        byte input[] = { 'a','b' };
        BusStraight tInstance = new BusStraight(0x400);
        //tInstance.allocate_memory(0, 0x400);
        MemorySegment newMemory = new RandomAccessMemory(0, tInstance, "0x400");
        tInstance.addMemorySegment(newMemory);

        ByteArrayInputStream is = new ByteArrayInputStream(input);
        Loader.loadSRecord(is, tInstance);
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
        BusStraight tInstance = new BusStraight();
        MemorySegment newMemory = new RandomAccessMemory(0, tInstance, "0x400");
        tInstance.addMemorySegment(newMemory);

        ByteArrayInputStream is = new ByteArrayInputStream(byteInput);
        Loader.loadSRecord(is, tInstance);

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
        BusStraight tInstance = new BusStraight();
        MemorySegment newMemory = new RandomAccessMemory(0, tInstance, "0x400");
        tInstance.addMemorySegment(newMemory);

        ByteArrayInputStream is = new ByteArrayInputStream(byteInput);
        Loader.loadIntelHex(is, tInstance);

        int result = tInstance.read(0x01);
        assertEquals(0x32, result);
        result = tInstance.read(0x33);
        assertEquals(0xB2, result);
    }

}
