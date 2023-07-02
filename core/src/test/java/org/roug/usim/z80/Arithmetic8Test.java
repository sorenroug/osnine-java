package org.roug.usim.z80;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;

public class Arithmetic8Test extends Framework {


    /* Inc B -- Opcode 0x04
     */
    @Test
    public void incrementB() {
        myTestCPU.registerB.set(0x44);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0x04);
        execSeq(0xB00, 0xB01);
        assertEquals(0x45, myTestCPU.registerB.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());

        myTestCPU.registerB.set(0x7F);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0x04);
        execSeq(0xB00, 0xB01);
        assertEquals(0x80, myTestCPU.registerB.get());
        assertTrue(myTestCPU.registerF.isSetS());
        assertTrue(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());

        myTestCPU.registerE.set(0xFF);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0x1C);
        execSeq(0xB00, 0xB01);
        assertEquals(0x00, myTestCPU.registerE.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetPV());
        assertTrue(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetC());

    }

    /* DEC B -- Opcode 0x05
     */
    @Test
    public void decrementReg() {
        myTestCPU.registerB.set(0x44);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0x05);
        execSeq(0xB00, 0xB01);
        assertEquals(0x43, myTestCPU.registerB.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetN());

        myTestCPU.registerB.set(0x80);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0x05);
        execSeq(0xB00, 0xB01);
        assertEquals(0x7F, myTestCPU.registerB.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertTrue(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetN());

        // Decrement E from 00
        myTestCPU.registerE.set(0x00);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0x1D);
        execSeq(0xB00, 0xB01);
        assertEquals(0xFF, myTestCPU.registerE.get());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetC());

    }

    /* DEC (IX+d) -- Opcode 0xDD 0x35
     */
    @Test
    public void decrementRegIndir() {
        myTestCPU.registerIX.set(0x1020);
        myTestCPU.write(0x1030, 0x34);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0xDD, 0x35, 0x10);
        execSeq(0xB00, 0xB03);
        assertEquals(0x33, myTestCPU.read(0x1030));
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetN());

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

    /* ADC A,#
     */
    @Test
    public void adcImmToA() {
        myTestCPU.registerA.set(0xA0);
        myTestCPU.registerF.setC(true);
        writeSeq(0x0B00, 0xCE, 0x07); // ADC A,#$07
        execSeq(0xB00, 0xB02);
        assertEquals(0xA8, myTestCPU.registerA.get());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetC());
    }

    /* ADC A,#
     * 0x06 + 0xF = 0x15
     */
    @Test
    public void adc0FToA() {
        myTestCPU.registerA.set(0x06);
        myTestCPU.registerF.setC(false);
        writeSeq(0x0B00, 0xCE, 0x0F); // ADC A,#$0F
        execSeq(0xB00, 0xB02);
        assertEquals(0x15, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetC());
    }

    /* ADC A,#
     * 0xA3 is negative
     * 0x5D is positive
     */
    @Test
    public void adcToAToMakeZero() {
        myTestCPU.registerA.set(0xA3);
        myTestCPU.registerF.setC(false);
        writeSeq(0x0B00, 0xCE, 0x5D); // ADC A,#$5D
        execSeq(0xB00, 0xB02);
        assertEquals(0x00, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertTrue(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetPV());
        assertTrue(myTestCPU.registerF.isSetC());
    }

    /* ADC A,#
     * 0xFF is negative
     * 0xFF is negative
     * 0xFF + 0xFF becomes 0xFE or -2
     */
    @Test
    public void adcNegativeToNegativeA() {
        myTestCPU.registerA.set(0xFF);
        myTestCPU.registerF.setC(false);
        writeSeq(0x0B00, 0xCE, 0xFF); // ADC A,#$FF
        execSeq(0xB00, 0xB02);
        assertEquals(0xFE, myTestCPU.registerA.get());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetPV());
        assertTrue(myTestCPU.registerF.isSetC());
    }

    /* ADC A,#
     * 0x78 is positive
     * 0x69 is positive
     * 0x78 + 0x69 becomes 0xE1 or -95
     */
    @Test
    public void adcPositiveToPositiveA() {
        myTestCPU.registerA.set(0x78);
        myTestCPU.registerF.setC(false);
        writeSeq(0x0B00, 0xCE, 0x69); // ADC A,#$69
        execSeq(0xB00, 0xB02);
        assertEquals(0xE1, myTestCPU.registerA.get());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetPV());
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
     */
    @Test
    public void subRegFromA() {
        // Subtract 0x11 from 0x44.
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
        assertFalse(myTestCPU.registerF.isSetPV());

        // Subtract 0x44 from 0x11.
        myTestCPU.registerA.set(0x11);
        myTestCPU.registerL.set(0x44);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0x95); // SUB A,L
        execSeq(0xB00, 0xB01);
        assertEquals(0xCD, myTestCPU.registerA.get());
        assertTrue(myTestCPU.registerF.isSetC());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetPV());

        // Subtract 0xC0 from 0x7F causing overflow an carry
        myTestCPU.registerA.set(0x7F);
        myTestCPU.registerH.set(0xC0);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0x94); // SUB A,H
        execSeq(0xB00, 0xB01);
        assertEquals(0xBF, myTestCPU.registerA.get());
        assertTrue(myTestCPU.registerF.isSetC());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetPV());

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
        assertFalse(myTestCPU.registerF.isSetPV());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());

        myTestCPU.registerA.set(0x0);
        myTestCPU.registerL.set(0x5A);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(true);
        myTestCPU.write(0x0B00, 0xAD); // XOR A,L
        execSeq(0xB00, 0xB01);
        assertEquals(0x5A, myTestCPU.registerA.get());
        assertTrue(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetS());
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
        myTestCPU.write(0x0B00, 0xA0); // AND A,B
        execSeq(0xB00, 0xB01);
        assertEquals(0x43, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());

        myTestCPU.registerA.set(0xC3);
        myTestCPU.registerB.set(0x00);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(true);
        myTestCPU.write(0x0B00, 0xA0); // AND A,B
        execSeq(0xB00, 0xB01);
        assertEquals(0x00, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertTrue(myTestCPU.registerF.isSetZ());
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

        myTestCPU.registerA.set(0x00);
        myTestCPU.registerH.set(0x48);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(true);
        myTestCPU.registerF.setPV(true);
        myTestCPU.write(0x0B00, 0xB4); // OR A,H
        execSeq(0xB00, 0xB01);
        assertEquals(0x48, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetC());


    }


}
