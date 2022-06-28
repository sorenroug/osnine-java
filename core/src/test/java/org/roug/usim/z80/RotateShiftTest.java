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
    public void RRRegA_E1() {
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

    /* SLA - shift left arithmic register A */
    @Test
    public void SLARegA_E1() {
        setA(0xE1);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(true);
        writeSeq(0x0B00, 0xCB, 0x27);
        execSeq(0xB00, 0xB02);
        assertEquals(0xC2, myTestCPU.registerA.get());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetC());
    }

    /* SRA - shift right arithmic register D */
    @Test
    public void SRARegD_E1() {
        myTestCPU.registerD.set(0xE1);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(false);
        writeSeq(0x0B00, 0xCB, 0x2A);
        execSeq(0xB00, 0xB02);
        assertEquals(0xF0, myTestCPU.registerD.get());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetC());
    }


    /* SLL - shift left logical register A */
    @Test
    public void SLLRegA_E1() {
        setA(0xE1);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(true);
        writeSeq(0x0B00, 0xCB, 0x37);
        execSeq(0xB00, 0xB02);
        assertEquals(0xC3, myTestCPU.registerA.get());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetC());
    }

    /* SRL - shift right logic register D */
    @Test
    public void SRLRegD_E1() {
        myTestCPU.registerD.set(0xE1);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(false);
        writeSeq(0x0B00, 0xCB, 0x3A);
        execSeq(0xB00, 0xB02);
        assertEquals(0x70, myTestCPU.registerD.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetC());
    }

    /* SRL - shift right logic register D */
    @Test
    public void SRLRegB_8F() {
        myTestCPU.registerB.set(0x8F);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(false);
        writeSeq(0x0B00, 0xCB, 0x38);
        execSeq(0xB00, 0xB02);
        assertEquals(0x47, myTestCPU.registerB.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetC());
    }

    /* RLC (IY+d) -- 0xFD, 0xCB, d, 0x06
    */
    @Test
    public void rlcRegisterIYd() {
        myTestCPU.registerIY.set(0x1000);
        myTestCPU.write(0x1002, 0x88);
        writeSeq(0x0B00, 0xFD, 0xCB, 0x02, 0x06);
        execSeq(0xB00, 0xB04);
        assertEquals(0x11, myTestCPU.read(0x1002));
        assertTrue(myTestCPU.registerF.isSetC());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetPV());
    }


    /* RLC (HL) -- 0xCB, 0x06
    */
    @Test
    public void rlcRegisterHL() {
        myTestCPU.registerHL.set(0x1828);
        myTestCPU.write(0x1828, 0x88);
        writeSeq(0x0B00, 0xCB, 0x06);
        execSeq(0xB00, 0xB02);
        assertEquals(0x11, myTestCPU.read(0x1828));
        assertTrue(myTestCPU.registerF.isSetC());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetPV());
    }

    /* RRD -- 0xED, 0x67
    */
    @Test
    public void rrdRegisterHL() {
        myTestCPU.registerHL.set(0x1000);
        myTestCPU.write(0x1000, 0x20);
        myTestCPU.registerA.set(0x84);
        writeSeq(0x0B00, 0xED, 0x67);
        execSeq(0xB00, 0xB02);
        assertEquals(0x42, myTestCPU.read(0x1000));
        assertEquals(0x80, myTestCPU.registerA.get());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetC());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetN());
    }

    /* RLD -- 0xED, 0x6F
    */
    @Test
    public void rldRegisterHL() {
        myTestCPU.registerHL.set(0x1000);
        myTestCPU.write(0x1000, 0x31);
        myTestCPU.registerA.set(0x7A);
        writeSeq(0x0B00, 0xED, 0x6F);
        execSeq(0xB00, 0xB02);
        assertEquals(0x1A, myTestCPU.read(0x1000));
        assertEquals(0x73, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetC());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetN());
    }

}
