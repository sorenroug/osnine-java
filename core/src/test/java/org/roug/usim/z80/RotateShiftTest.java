package org.roug.usim.z80;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;

public class RotateShiftTest extends Framework {

    /* RLC r - shift left 0x88 in A */
    @Test
    public void RLCReg() {
        setA(0x88);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0xCB, 0x07);
        execSeq(0xB00, 0xB02);
        assertEquals(0x11, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetC());
    }

    /* RL r - shift left 0x48 in A with Carry */
    @Test
    public void RLA48() {
        setA(0x48);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(true);
        writeSeq(0x0B00, 0x17);
        execSeq(0xB00, 0xB01);
        assertEquals(0x91, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetC());
    }

    /* RRA - shift left 0xE1 in A with Carry */
    @Test
    public void RRAE1() {
        setA(0xE1);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(true);
        writeSeq(0x0B00, 0x1F);
        execSeq(0xB00, 0xB01);
        assertEquals(0xF0, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetC());
    }

    /* RRA - shift left 0xE1 in A with Carry */
    @Test
    public void RRRegAE1() {
        setA(0xE1);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(true);
        writeSeq(0x0B00, 0xCB, 0x0F);
        execSeq(0xB00, 0xB02);
        assertEquals(0xF0, myTestCPU.registerA.get());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetC());
    }

}
