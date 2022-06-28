package org.roug.usim.z80;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;
import org.roug.usim.Bus8Intel;

public class Arithmetic16Test extends Framework {


    /* INC BC
     */
    @Test
    public void incBC() {
        myTestCPU.registerBC.set(0x555);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0x03);
        execSeq(0xB00, 0xB01);
        assertEquals(0x556, myTestCPU.registerBC.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetN());
    }

    /* Add IY, BC
     */
    @Test
    public void addRegBCToIY() {
        myTestCPU.registerIY.set(0x333);
        myTestCPU.registerBC.set(0x555);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0xFD, 0x09);
        execSeq(0xB00, 0xB02);
        assertEquals(0x888, myTestCPU.registerIY.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetN());
    }

    /* SBC HL, BC
     */
    @Test
    public void sbcRegBCFromHL() {
        myTestCPU.registerHL.set(0x333);
        myTestCPU.registerBC.set(0x555);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(true);
        writeSeq(0x0B00, 0xED, 0x42);
        execSeq(0xB00, 0xB02);
        assertEquals(0xFDDD, myTestCPU.registerHL.get());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetPV());
        assertTrue(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetC());
    }

    /* ADC HL, BC
     */
    @Test
    public void adcRegBCToHL() {
        myTestCPU.registerHL.set(0x333);
        myTestCPU.registerBC.set(0x555);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(true);
        writeSeq(0x0B00, 0xED, 0x4A);
        execSeq(0xB00, 0xB02);
        assertEquals(0x889, myTestCPU.registerHL.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH()); // TODO Verify
        assertFalse(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetC());
    }

    /* Add IY, IY
     */
    @Test
    public void addRegIYToIY() {
        myTestCPU.registerIY.set(0x333);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0xFD, 0x29);
        execSeq(0xB00, 0xB02);
        assertEquals(0x666, myTestCPU.registerIY.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetN());
    }

    /* Add IX, IX
     */
    @Test
    public void addRegIXToIX() {
        myTestCPU.registerIX.set(0x333);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0xDD, 0x29);
        execSeq(0xB00, 0xB02);
        assertEquals(0x666, myTestCPU.registerIX.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetN());
    }


    /* Add HL, HL
     */
    @Test
    public void addRegHLToHL() {
        myTestCPU.registerHL.set(0xABCD);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0x29);
        execSeq(0xB00, 0xB01);
        assertEquals(0x579A, myTestCPU.registerHL.get());
// Check for carry
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetN());
    }

    /* DEC SP
     */
    @Test
    public void decSP() {
        myTestCPU.registerSP.set(0x1001);
        writeSeq(0x0B00, 0x3B);
        execSeq(0xB00, 0xB01);
        assertEquals(0x1000, myTestCPU.registerSP.get());

        // Decrement 0000 -> FFFF
        myTestCPU.registerSP.set(0x0000);
        writeSeq(0x0B00, 0x3B);
        execSeq(0xB00, 0xB01);
        assertEquals(0xFFFF, myTestCPU.registerSP.get());
    }

    /* INC IY
     */
    @Test
    public void incIY() {
        myTestCPU.registerIY.set(0x2977);
        writeSeq(0x0B00, 0xFD, 0x23);
        execSeq(0xB00, 0xB02);
        assertEquals(0x2978, myTestCPU.registerIY.get());

        // Increment FFFF
        myTestCPU.registerIY.set(0xFFFF);
        writeSeq(0x0B00, 0xFD, 0x23);
        execSeq(0xB00, 0xB02);
        assertEquals(0x0000, myTestCPU.registerIY.get());
    }

    /* DEC IY
     */
    @Test
    public void decIY() {
        myTestCPU.registerIY.set(0x7649);
        writeSeq(0x0B00, 0xFD, 0x2B);
        execSeq(0xB00, 0xB02);
        assertEquals(0x7648, myTestCPU.registerIY.get());

        // Decrement 0000 -> FFFF
        myTestCPU.registerIY.set(0x0000);
        writeSeq(0x0B00, 0xFD, 0x2B);
        execSeq(0xB00, 0xB02);
        assertEquals(0xFFFF, myTestCPU.registerIY.get());
    }

}
