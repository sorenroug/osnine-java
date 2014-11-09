package org.roug.osnine;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class UByteTest {

    /**
     * Insert 255 and expect -1.
     */
    @Test
    public void getMinus1() {
        UByte reg = new UByte();
        reg.set(255);
        
        assertEquals(255, reg.get());
        assertEquals(-1, reg.getSigned());
    }


    /**
     * Insert 254 and expect -2.
     */
    @Test
    public void getMinus2() {
        UByte reg = new UByte();
        reg.set(254);
        
        assertEquals(254, reg.get());
        assertEquals(-2, reg.getSigned());
    }

    /**
     * Insert 128 and expect -128.
     */
    @Test
    public void getMinus128() {
        UByte reg = new UByte();
        reg.set(128);
        
        assertEquals(128, reg.get());
        assertEquals(-128, reg.getSigned());
    }

    /**
     * Insert 127 and expect 127.
     */
    @Test
    public void getPlus127() {
        UByte reg = new UByte();
        reg.set(127);
        
        assertEquals(127, reg.get());
        assertEquals(127, reg.getSigned());
    }
}
