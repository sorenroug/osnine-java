package org.roug.osnine;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class RegisterDTest {

    /**
     * Insert 0x6789 and expect 0x67 in the high byte = Reg A.
     */
    @Test
    public void getAccumulators() {
        UByte regA = new UByte("A");
        UByte regB = new UByte("B");
        RegisterD regD = new RegisterD(regA, regB);
        regD.set(0x6789);
        
        assertEquals(0x6789, regD.intValue());
        assertEquals(0x67, regA.intValue());
        assertEquals(0x89, regB.intValue());
    }

    /**
     * Modify the 8-bit accumulators and expect register D to change value.
     */
    @Test
    public void changeAccumulators() {
        UByte regA = new UByte("A");
        UByte regB = new UByte("B");
        RegisterD regD = new RegisterD(regA, regB);
        regD.set(0x6789);
        
        assertEquals(0x6789, regD.intValue());
        regB.set(0x10);
        assertEquals(0x6710, regD.intValue());
        regA.set(0x44);
        assertEquals(0x4410, regD.intValue());
    }

    /**
     * Insert 255 and expect 255.
     */
    @Test
    public void get255() {
        RegisterD reg = new RegisterD();
        reg.set(255);
        
        assertEquals(255, reg.get());
        assertEquals(255, reg.getSigned());
    }


    /**
     * Insert 254 and expect -2.
     */
    @Test
    public void getMinus2() {
        RegisterD reg = new RegisterD();
        reg.set(65534);
        
        assertEquals(65534, reg.get());
        assertEquals(-2, reg.getSigned());
    }

    /**
     * Insert 32768 and expect -32768.
     */
    @Test
    public void getMinus32768() {
        RegisterD reg = new RegisterD();
        reg.set(32768);
        
        assertEquals(32768, reg.get());
        assertEquals(-32768, reg.getSigned());
    }

    /**
     * Insert 32767 and expect 32767.
     */
    @Test
    public void getPlus32767() {
        RegisterD reg = new RegisterD();
        reg.set(32767);
        
        assertEquals(32767, reg.get());
        assertEquals(32767, reg.getSigned());
    }

    //@Test(expected = IllegalArgumentException.class)
    @Test
    public void setTooMuch() {
        RegisterD reg = new RegisterD();
        reg.set(66000);
        assertEquals(464, reg.get());
    }
        
}

