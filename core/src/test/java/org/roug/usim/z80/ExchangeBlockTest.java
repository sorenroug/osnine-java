package org.roug.usim.z80;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;

public class ExchangeBlockTest extends Framework {

    /* EX DE, HL - Opcode 0xEB
     */
    @Test
    public void exchangeDEHL() {
        myTestCPU.registerDE.set(0x2822);
        myTestCPU.registerHL.set(0x499A);
        writeSeq(0x0B00, 0xEB); // EX DE,HL
        execSeq(0xB00, 0xB01);
        assertEquals(0x2822, myTestCPU.registerHL.get());
        assertEquals(0x499A, myTestCPU.registerDE.get());
    }

    /* EX AF, AF' - Opcode 0x08
     */
    @Test
    public void exchangeAFAF_() {
        myTestCPU.registerAF.set(0x9900);
        myTestCPU.registerAF_.set(0x5944);
        writeSeq(0x0B00, 0x08); // EX AF,F'
        execSeq(0xB00, 0xB01);
        assertEquals(0x5944, myTestCPU.registerAF.get());
        assertEquals(0x9900, myTestCPU.registerAF_.get());
    }

    /* EXX - Opcode 0xD9
     */
    @Test
    public void testEXX() {
        myTestCPU.registerBC.set(0x445A);
        myTestCPU.registerDE.set(0x3DA2);
        myTestCPU.registerHL.set(0x8859);
        myTestCPU.registerBC_.set(0x0988);
        myTestCPU.registerDE_.set(0x9300);
        myTestCPU.registerHL_.set(0x00E7);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0xD9); // EXX instruction
        execSeq(0xB00, 0xB01);
        assertEquals(0x0988, myTestCPU.registerBC.get());
        assertEquals(0x9300, myTestCPU.registerDE.get());
        assertEquals(0x00E7, myTestCPU.registerHL.get());
        assertEquals(0x445A, myTestCPU.registerBC_.get());
        assertEquals(0x3DA2, myTestCPU.registerDE_.get());
        assertEquals(0x8859, myTestCPU.registerHL_.get());

        assertEquals(0x00, myTestCPU.registerF.get());
    }

    /* EX (SP), HL - Opcode 0xE3
     */
    @Test
    public void exchangeSPindHL() {
        myTestCPU.registerHL.set(0x7012);
        myTestCPU.registerSP.set(0x1856);
        myTestCPU.write(0x1856, 0x11);
        myTestCPU.write(0x1857, 0x22);
        writeSeq(0x0B00, 0xE3); // EX (SP), HL
        execSeq(0xB00, 0xB01);
        assertEquals(0x2211, myTestCPU.registerHL.get());
        assertEquals(0x12, myTestCPU.read(0x1856));
        assertEquals(0x70, myTestCPU.read(0x1857));
        assertEquals(0x1856, myTestCPU.registerSP.get());
    }

    /* EX (SP), IX - Opcode 0xDD, 0xE3
     */
    @Test
    public void exchangeSPindIX() {
        myTestCPU.registerIX.set(0x3988);
        myTestCPU.registerSP.set(0x0100);
        myTestCPU.write(0x0100, 0x90);
        myTestCPU.write(0x0101, 0x48);
        writeSeq(0x0B00, 0xDD, 0xE3); // EX (SP), IX
        execSeq(0xB00, 0xB02);
        assertEquals(0x4890, myTestCPU.registerIX.get());
        assertEquals(0x88, myTestCPU.read(0x0100));
        assertEquals(0x39, myTestCPU.read(0x0101));
        assertEquals(0x0100, myTestCPU.registerSP.get());
    }

    /* EX (SP), IY - Opcode 0xFD, 0xE3
     */
    @Test
    public void exchangeSPindIY() {
        myTestCPU.registerIY.set(0x3988);
        myTestCPU.registerSP.set(0x0100);
        myTestCPU.write(0x0100, 0x90);
        myTestCPU.write(0x0101, 0x48);
        writeSeq(0x0B00, 0xFD, 0xE3); // EX (SP), IY
        execSeq(0xB00, 0xB02);
        assertEquals(0x4890, myTestCPU.registerIY.get());
        assertEquals(0x88, myTestCPU.read(0x0100));
        assertEquals(0x39, myTestCPU.read(0x0101));
        assertEquals(0x0100, myTestCPU.registerSP.get());
    }

    /* LDI - opcode 0xED, 0xA0
     * TODO: Test condition flags.
     */
    @Test
    public void testLDI() {
        myTestCPU.registerHL.set(0x1111);
        myTestCPU.write(0x1111, 0x88);
        myTestCPU.registerDE.set(0x0222);
        myTestCPU.write(0x0222, 0x66);
        myTestCPU.registerBC.set(0x07);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setPV(true);
        writeSeq(0x0B00, 0xED, 0xA0); // LDI
        execSeq(0xB00, 0xB02);
        assertEquals(0x1112, myTestCPU.registerHL.get());
        assertEquals(0x88, myTestCPU.read(0x1111));
        assertEquals(0x0223, myTestCPU.registerDE.get());
        assertEquals(0x88, myTestCPU.read(0x0222));
        assertEquals(0x06, myTestCPU.registerBC.get());
        assertFalse(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
    }

    /* CPI - opcode 0xED, 0xA1
     * TODO: Test condition flags.
     */
    @Test
    public void testCPI() {
        myTestCPU.registerHL.set(0x1111);
        myTestCPU.write(0x1111, 0x3B);
        myTestCPU.registerA.set(0x3B);
        myTestCPU.write(0x0222, 0x66);
        myTestCPU.registerBC.set(0x01);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setPV(true);
        writeSeq(0x0B00, 0xED, 0xA1);
        execSeq(0xB00, 0xB02);
        assertEquals(0x00, myTestCPU.registerBC.get());
        assertEquals(0x1112, myTestCPU.registerHL.get());
        assertEquals(0x3B, myTestCPU.read(0x1111));
        assertTrue(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetN());
    }

    /* CPD - opcode 0xED, 0xA9
     * TODO: Test condition flags.
     */
    @Test
    public void testCPD() {
        myTestCPU.registerHL.set(0x1111);
        myTestCPU.write(0x1111, 0x3B);
        myTestCPU.registerA.set(0x3B);
        myTestCPU.write(0x0222, 0x66);
        myTestCPU.registerBC.set(0x01);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setPV(true);
        writeSeq(0x0B00, 0xED, 0xA9);
        execSeq(0xB00, 0xB02);
        assertEquals(0x00, myTestCPU.registerBC.get());
        assertEquals(0x1110, myTestCPU.registerHL.get());
        assertEquals(0x3B, myTestCPU.read(0x1111));
        assertTrue(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetN());
    }

    /* LDIR - opcode 0xED, 0xB0
     * TODO: Test condition flags.
     */
    @Test
    public void testLDIR() {
        myTestCPU.registerHL.set(0x1111);
        writeSeq(0x1111, 0x88, 0x36, 0xA5, 0x55);
        writeSeq(0x0222, 0x66, 0x59, 0xC5, 0x33);
        myTestCPU.registerDE.set(0x0222);
        myTestCPU.registerBC.set(0x03);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0xED, 0xB0); // LDIR
        execSeq(0xB00, 0xB00);
        assertEquals(0x1112, myTestCPU.registerHL.get());
        assertEquals(0x0223, myTestCPU.registerDE.get());
        assertEquals(0x02, myTestCPU.registerBC.get());
        assertEquals(0x88, myTestCPU.read(0x1111));
        assertEquals(0x88, myTestCPU.read(0x0222));
        assertEquals(0x36, myTestCPU.read(0x1112));
        assertEquals(0x59, myTestCPU.read(0x0223));
        assertEquals(0xA5, myTestCPU.read(0x1113));
        assertEquals(0xC5, myTestCPU.read(0x0224));

        assertEquals(0x55, myTestCPU.read(0x1114)); // Check that it halted correctly
        assertEquals(0x33, myTestCPU.read(0x0225)); // Check that it halted correctly
    }

    /* LDDR - opcode 0xED, 0xB8
     * TODO: Test condition flags.
     */
    @Test
    public void testLDDR() {
        myTestCPU.registerHL.set(0x1114);
        writeSeq(0x1111, 0x55, 0x88, 0x36, 0xA5, 0x55);
        writeSeq(0x0222, 0x33, 0x66, 0x59, 0xC5, 0x33);
        myTestCPU.registerDE.set(0x0225);
        myTestCPU.registerBC.set(0x03);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0xED, 0xB8); // LDDR
        execSeq(0xB00, 0xB00);
        assertEquals(0x1113, myTestCPU.registerHL.get());
        assertEquals(0x0224, myTestCPU.registerDE.get());
        assertEquals(0x02, myTestCPU.registerBC.get());
        assertEquals(0x88, myTestCPU.read(0x1112));
        assertEquals(0x66, myTestCPU.read(0x0223));
        assertEquals(0x36, myTestCPU.read(0x1113));
        assertEquals(0x59, myTestCPU.read(0x0224));
        assertEquals(0xA5, myTestCPU.read(0x1114));
        assertEquals(0xA5, myTestCPU.read(0x0225));

        assertEquals(0x55, myTestCPU.read(0x1111)); // Check that it halted correctly
        assertEquals(0x33, myTestCPU.read(0x0222)); // Check that it halted correctly
    }
}
