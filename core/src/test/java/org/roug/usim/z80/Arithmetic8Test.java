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

public class Arithmetic8Test extends Framework {

    /* Add A,r
     * Add 0x44 and 0x11. No overflow.
     */
    @Test
    public void addRegToA() {
        myTestCPU.registerA.set(0x44);
        myTestCPU.registerC.set(0x11);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0x81); // ADD A,C
        execSeq(0xB00, 0xB01);
        assertEquals(0x55, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
    }

    /* Add A,r
     */
    @Test
    public void addRegToAOverflow() {
        // positive + positive with overflow
        // B=0x40 + 0x41 becomes 0x81 or -127
        myTestCPU.registerA.set(0x40);
        myTestCPU.registerB.set(0x41);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0x80); // ADD A,B
        execSeq(0xB00, 0xB01);
        assertEquals(0x81, myTestCPU.registerA.get());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetC());

        // negative + negative
        // B=0xFF + 0xFF becomes 0xFE or -2
        myTestCPU.registerA.set(0xFF);
        myTestCPU.registerB.set(0xFF);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0x87); // ADD A,A
        execSeq(0xB00, 0xB01);
        assertEquals(0xFE, myTestCPU.registerA.get());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetC());

        // negative + negative with overflow
        // B=0xC0 + 0xBF becomes 0x7F or 127
        myTestCPU.registerA.set(0xC0);
        myTestCPU.registerB.set(0xBF);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0x80); // ADD A,B
        execSeq(0xB00, 0xB01);
        assertEquals(0x7F, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetPV());
        assertTrue(myTestCPU.registerF.isSetC());

        // positive + negative with negative result
        // B=0x02 + 0xFC becomes 0xFE or -2
        myTestCPU.registerA.set(0x02);
        myTestCPU.registerB.set(0xFC);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0x80); // ADD A,B
        execSeq(0xB00, 0xB01);
        assertEquals(0xFE, myTestCPU.registerA.get());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetC());
    }

    /* Add A,r
     */
    @Test
    public void addMemToA() {
        myTestCPU.registerA.set(0xA0);
        myTestCPU.registerHL.set(0x1323);
        myTestCPU.write(0x1323, 0x08);
        myTestCPU.write(0x0B00, 0x86); // ADD A,(HL)
        execSeq(0xB00, 0xB01);
        assertEquals(0xA8, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetC());
    }

    /* Add A,r
     */
    @Test
    public void addImmToA() {
        myTestCPU.registerA.set(0xA0);
        writeSeq(0x0B00, 0xC6, 0x07); // ADD A,#$07
        execSeq(0xB00, 0xB02);
        assertEquals(0xA7, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetC());
    }

    /* CP A,r
     * Compare 0x44 and 0x11.
     */
    @Test
    public void cmpRegToA() {
        myTestCPU.registerA.set(0x44);
        myTestCPU.registerC.set(0x11);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0xB9); // CP A,C
        execSeq(0xB00, 0xB01);
        assertEquals(0x44, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetN());
    }

    /* SUB A,r
     * Subtract 0x11 from 0x44.
     */
    @Test
    public void subRegFromA() {
        myTestCPU.registerA.set(0x44);
        myTestCPU.registerL.set(0x11);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0x95); // SUB A,L
        execSeq(0xB00, 0xB01);
        assertEquals(0x33, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetN());
    }

    /* SBC A,r
     * Subtract 0x11 and carry from 0x44.
     */
    @Test
    public void subWithCRegFromA() {
        myTestCPU.registerA.set(0x44);
        myTestCPU.registerL.set(0x11);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(true);
        myTestCPU.write(0x0B00, 0x9D); // SBC A,L
        execSeq(0xB00, 0xB01);
        assertEquals(0x32, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetN());
    }

    /* XOR A,r
     * Xor 0x96 and 0x5D.
     */
    @Test
    public void xorRegFromA() {
        myTestCPU.registerA.set(0x96);
        myTestCPU.registerL.set(0x5D);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(true);
        myTestCPU.write(0x0B00, 0xAD); // XOR A,L
        execSeq(0xB00, 0xB01);
        assertEquals(0xCB, myTestCPU.registerA.get());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
    }


    /* AND A,r
     * AND 0x96 and 0x5D.
     */
    @Test
    public void andRegFromA() {
        myTestCPU.registerA.set(0xC3);
        myTestCPU.registerB.set(0x7B);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(true);
        myTestCPU.write(0x0B00, 0xA0); // XOR A,B
        execSeq(0xB00, 0xB01);
        assertEquals(0x43, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
    }

    /* OR A,r
     * AND 0x96 and 0x5D.
     */
    @Test
    public void orRegFromA() {
        myTestCPU.registerA.set(0x12);
        myTestCPU.registerH.set(0x48);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(true);
        myTestCPU.write(0x0B00, 0xB4); // OR A,H
        execSeq(0xB00, 0xB01);
        assertEquals(0x5A, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetC());
    }


}
