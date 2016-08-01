package org.roug.osnine;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class CCTest {

    /**
     * Set Carry bit and get full CC
     */
    @Test
    public void setCarryBit() {
        CC cc = new CC();
        cc.clearCC();
        cc.bit_c = 1;
        
        assertEquals(1, cc.bit_c);
        assertEquals(0x01, cc.get());
    }


    /**
     * Set Half Carry bit and get full CC
     */
    @Test
    public void setHalfBit() {
        CC cc = new CC();
        cc.clearCC();
        cc.bit_h = 1;
        
        assertEquals(1, cc.bit_h);
        assertEquals(0x20, cc.get());
    }

}
