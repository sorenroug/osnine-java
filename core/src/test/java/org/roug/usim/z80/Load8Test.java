package org.roug.usim.z80;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;

public class Load8Test extends Framework {


    /* LD (BC), A -- Opcode 02
     */
    @Test
    public void loadNNfromBCIndexed() {
        myTestCPU.registerA.set(0x7A);
        myTestCPU.registerBC.set(0x1212);
        writeSeq(0x0B00, 0x02);
        execSeq(0xB00, 0xB01);
        assertEquals(0x7A, myTestCPU.read(0x1212));
    }

    /* LD A, (BC) -- Opcode 0A
     */
    @Test
    public void loadAfromBCindexed() {
        myTestCPU.registerA.set(0xFF);
        myTestCPU.registerBC.set(0x1747);
        myTestCPU.write(0x1747, 0x12); // Set test data
        writeSeq(0x0B00, 0x0A);
        execSeq(0xB00, 0xB01);
        assertEquals(0x1747, myTestCPU.registerBC.get());
        assertEquals(0x12, myTestCPU.registerA.get());
    }

    /* LD A, (DE) -- Opcode 1A
     */
    @Test
    public void loadAfromDEindexed() {
        myTestCPU.registerA.set(0xFF);
        myTestCPU.registerDE.set(0x10A2);
        myTestCPU.write(0x10A2, 0x22); // Set test data
        writeSeq(0x0B00, 0x1A);
        execSeq(0xB00, 0xB01);
        assertEquals(0x10A2, myTestCPU.registerDE.get());
        assertEquals(0x22, myTestCPU.registerA.get());
    }

    /* LD (nn), A -- Opcode 0x32
     */
    @Test
    public void loadNNfromA() {
        myTestCPU.registerA.set(0xD7);
        myTestCPU.write(0x1141, 0x04); // Set test data
        writeSeq(0x0B00, 0x32, 0x41, 0x11);
        execSeq(0xB00, 0xB03);
        assertEquals(0xD7, myTestCPU.registerA.get());
        assertEquals(0xD7, myTestCPU.read(0x1141));
    }

    /* LD R, n.
     */
    @Test
    public void loadNToR() {
    // LD B, n -- Opcode 0x06.
        myTestCPU.registerB.set(0x14);
        writeSeq(0x0B00, 0x06, 0x28);
        execSeq(0xB00, 0xB02);
        assertEquals(0x28, myTestCPU.registerB.get());
    // LD (HL), n -- Opcode 0x36.
        myTestCPU.write(0x1444, 0x02); // Set test data
        myTestCPU.registerHL.set(0x1444);
        writeSeq(0x0B00, 0x36, 0x28);
        execSeq(0xB00, 0xB02);
        assertEquals(0x28, myTestCPU.read(0x1444));
    // LD A, n -- Opcode 0x3E.
        myTestCPU.registerA.set(0x00);
        writeSeq(0x0B00, 0x3E, 0xA8);
        execSeq(0xB00, 0xB02);
        assertEquals(0xA8, myTestCPU.registerA.get());
    }

    /* LD A, (nn) -- Opcode 3A
     */
    @Test
    public void loadAfromNNindexed() {
        myTestCPU.registerA.set(0xFF);
        myTestCPU.write(0x1832, 0x04); // Set test data
        writeSeq(0x0B00, 0x3A, 0x32, 0x18);
        execSeq(0xB00, 0xB03);
        assertEquals(0x04, myTestCPU.registerA.get());
    }

    /* LD (IX+d), n -- Opcode 0xDD, 0x36
     */
    @Test
    public void loadMemToIXdisplaced() {
        myTestCPU.write(0x119F, 0xFF); // Set test data
        myTestCPU.registerIX.set(0x119A);
        writeSeq(0x0B00, 0xDD, 0x36, 0x05, 0x5A);
        execSeq(0xB00, 0xB04);
        assertEquals(0x5A, myTestCPU.read(0x119F));
    }

    /* LD B, C -- Opcode 0xDD, 0x41
     */
    @Test
    public void loadRegBFromRegC() {
        setB(0x80);
        myTestCPU.registerC.set(0x1F);
        writeSeq(0x0B00, 0xDD, 0x41);
        execSeq(0xB00, 0xB02);
        assertEquals(0x1F, myTestCPU.registerC.get());
        assertEquals(0x1F, myTestCPU.registerB.get());
    }

    /* LD B, (HL) -- Opcode 0x46
     */
    @Test
    public void loadRebBFromHLindexed() {
        myTestCPU.registerB.set(0xFF); // dummy data
        myTestCPU.registerHL.set(0x15A1);
        myTestCPU.write(0x15A1, 0x58); // Set test data
        writeSeq(0x0B00, 0x46); // LD B,(HL)
        execSeq(0xB00, 0xB01);
        assertEquals(0x58, myTestCPU.read(0x15A1)); // Is it still there?
        assertEquals(0x58, myTestCPU.registerB.get());
    }

    /* LD B, IXlsb -- Opcode 0xDD, 0x44
     */
    @Test
    public void loadRegBFromIXlsb() {
        setB(0x80);
        myTestCPU.registerIX.set(0x15AF);
        writeSeq(0x0B00, 0xDD, 0x44);
        execSeq(0xB00, 0xB02);
        assertEquals(0x15AF, myTestCPU.registerIX.get());
        assertEquals(0x15, myTestCPU.registerB.get());
    }

    /* LD B, IXmsb -- Opcode 0xDD, 0x45
     */
    @Test
    public void loadRegBFromIXmsb() {
        setB(0x80);
        myTestCPU.registerIX.set(0x15AF);
        writeSeq(0x0B00, 0xDD, 0x45);
        execSeq(0xB00, 0xB02);
        assertEquals(0x15AF, myTestCPU.registerIX.get());
        assertEquals(0xAF, myTestCPU.registerB.get());
    }

    /* LD r, (IX+d) -- Opcode 0xDD, 0x46
     * If Index Register IX contains the number 15AFh, the instruction LD B, (IX+19h) allows
     * the calculation of the sum 15AFh + 19h, which points to memory location 15C8h. If this
     * address contains byte 39h, the instruction results in Register B also containing 39h.
     */
    @Test
    public void loadRegBFromIXdisplaced() {
        myTestCPU.write(0x15C8, 0x39); // Set test data
        setB(0x80);
        myTestCPU.registerIX.set(0x15AF);
        writeSeq(0x0B00, 0xDD, 0x46, 0x19);
        execSeq(0xB00, 0xB03);
        assertEquals(0x39, myTestCPU.registerB.get());
    }

    /* LD H, (IX+d) -- Opcode 0xDD, 0x66
     * Correct
     */
    @Test
    public void loadRegHFromIXdisplaced() {
        myTestCPU.write(0x15C8, 0x39); // Set test data
        myTestCPU.registerH.set(0x80);
        myTestCPU.registerIX.set(0x15AF);
        writeSeq(0x0B00, 0xDD, 0x66, 0x19);
        execSeq(0xB00, 0xB03);
        assertEquals(0x39, myTestCPU.registerH.get());
    }


    /* LD L, (IX+d) -- Opcode 0xDD, 0x6E */
    @Test
    public void loadRegLFromIXdisplaced() {
        myTestCPU.write(0x15C8, 0x99); // Set test data
        myTestCPU.registerL.set(0x80);
        myTestCPU.registerIX.set(0x15AF);
        writeSeq(0x0B00, 0xDD, 0x6E, 0x19);
        execSeq(0xB00, 0xB03);
        assertEquals(0x99, myTestCPU.registerL.get());
    }

    /* LD (IY+d), D -- Opcode 0xFD, 0x72
     */
    @Test
    public void loadIYdisplacedFromRegD() {
        myTestCPU.write(0x119F, 0xFF); // Set test data
        myTestCPU.registerD.set(0x48);
        myTestCPU.registerIY.set(0x119A);
        writeSeq(0x0B00, 0xFD, 0x72, 0x05);
        execSeq(0xB00, 0xB03);
        assertEquals(0x48, myTestCPU.read(0x119F));
    }

    /* LD (IY+d), L -- Opcode 0xFD, 0x75
     * Value of IYlsb is 0x9A = 154
     */
    @Test
    public void loadIYdisplacedFromRegL() {
        myTestCPU.write(0x119F, 0xFF); // Set test data
        myTestCPU.registerL.set(0x48);
        myTestCPU.registerIY.set(0x119A);
        writeSeq(0x0B00, 0xFD, 0x75, 0x05);
        execSeq(0xB00, 0xB03);
        assertEquals(0x48, myTestCPU.read(0x119F));
    }

    /* LD A, (IX+d) -- Opcode 0xDD, 0x7E */
    @Test
    public void loadRegAFromIXdisplaced() {
        myTestCPU.write(0x15C8, 0x99); // Set test data
        myTestCPU.registerA.set(0x80);
        myTestCPU.registerIX.set(0x15AF);
        writeSeq(0x0B00, 0xDD, 0x7E, 0x19);
        execSeq(0xB00, 0xB03);
        assertEquals(0x99, myTestCPU.registerA.get());
    }

    /* LD A, I -- Opcode 0xED, 0x57
     */
    @Test
    public void loadRegAFromRegI() {
        myTestCPU.registerI.set(0xCF);
        writeSeq(0x0B00, 0xED, 0x57);
        execSeq(0xB00, 0xB02);
        assertEquals(0xCF, myTestCPU.registerI.get());
        assertEquals(0xCF, myTestCPU.registerA.get());
        assertTrue(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetPV());

        // Try with interrupts enabled.
        writeSeq(0x0B00, 0xFB, 0xED, 0x57); // Enable interrupts
        execSeq(0xB00, 0xB01);
        myTestCPU.registerI.set(0x1A);
        execSeq(0xB01, 0xB03);
        assertEquals(0x1A, myTestCPU.registerI.get());
        assertEquals(0x1A, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetPV());
    }

}
