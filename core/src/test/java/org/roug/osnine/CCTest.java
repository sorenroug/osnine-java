package org.roug.osnine;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
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
        assertTrue(cc.isSetC());
        assertEquals(0x01, cc.get());
    }

    /**
     * Set F bit and get full CC
     */
    @Test
    public void setFBit() {
        RegisterCC cc = new RegisterCC();
        cc.clear();
        cc.setF(1);

        assertEquals(1, cc.getF());
        assertTrue(cc.isSetF());
        assertEquals(0x40, cc.get());
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
        assertTrue(cc.isSetH());
        assertEquals(0x20, cc.get());
    }

    @Test
    public void maskValues() {
        assertEquals(1, CC.Cmask);
        assertEquals(8, CC.Nmask);
        assertEquals(128, CC.Emask);
    }
}
