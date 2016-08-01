package org.roug.osnine;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class CCTest {

    /**
     * Set Carry bit and get full CC
     */
    @Test
    public void setCarryBit() {
        RegisterCC cc = new RegisterCC();
        cc.clear();
        cc.setC(1);
        
        assertEquals(1, cc.getC());
        assertEquals(0x01, cc.get());
    }


    /**
     * Set Half Carry bit and get full CC
     */
    @Test
    public void setHalfBit() {
        RegisterCC cc = new RegisterCC();
        cc.clear();
        cc.setH(1);
        
        assertEquals(1, cc.getH());
        assertEquals(0x20, cc.get());
    }

}
