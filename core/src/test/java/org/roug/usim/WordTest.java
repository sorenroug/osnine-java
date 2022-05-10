package org.roug.usim;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class WordTest {

    /**
     * Insert 255 and expect -1.
     */
    @Test
    public void get255() {
        Word reg = new Word();
        reg.set(255);
        
        assertEquals(255, reg.get());
        assertEquals(255, reg.getSigned());
    }


    /**
     * Insert 254 and expect -2.
     */
    @Test
    public void getMinus2() {
        Word reg = new Word();
        reg.set(65534);
        
        assertEquals(65534, reg.get());
        assertEquals(-2, reg.getSigned());
    }

    /**
     * Insert 32768 and expect -32768.
     */
    @Test
    public void getMinus32768() {
        Word reg = new Word();
        reg.set(32768);
        
        assertEquals(32768, reg.get());
        assertEquals(-32768, reg.getSigned());
    }

    /**
     * Insert 32767 and expect 32767.
     */
    @Test
    public void getPlus32767() {
        Word reg = new Word();
        reg.set(32767);
        
        assertEquals(32767, reg.get());
        assertEquals(32767, reg.getSigned());
    }

    @Test
    public void addOne() {
        Word reg = new Word(500);
        
        assertEquals(500, reg.get());
        int x = reg.add(1);
        assertEquals(501, reg.get());
    }

    //@Test(expected = IllegalArgumentException.class)
    @Test
    public void setTooMuch() {
        Word reg = new Word();
        reg.set(66000);
        assertEquals(464, reg.get());
    }
        
}

