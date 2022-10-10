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

public class GeneralPurposeTest extends Framework {

    /**
     * Decimal Addition Adjust.
     * The Half-Carry flag is not affected by this instruction.
     * The Negative flag is set equal to the new value of bit 7 in Accumulator A.
     * The Zero flag is set if the new value of Accumulator A is zero; cleared otherwise.
     * The affect this instruction has on the Overflow flag is undefined.
     * The Carry flag is set if a carry is generated or if the carry bit was set before the
     * operation; cleared otherwise.
     */
    @Test
    public void testDAA1() {
        myTestCPU.write(0xB00, 0x27);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(false);
        myTestCPU.registerF.setH(false);
        myTestCPU.registerF.setN(false);
        setA(0x7f);
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0x85, myTestCPU.registerA.intValue());
        assertEquals(0, myTestCPU.registerF.getN());
        assertEquals(0, myTestCPU.registerF.getZ());
        assertEquals(0, myTestCPU.registerF.getPV());
        assertEquals(0, myTestCPU.registerF.getC());
    }

    /*
     * If the least significant four bits of A contain a non-BCD digit (i. e.
     * it is greater than 9) or the H flag is set, then $06 is added to the
     * register. Then the four most significant bits are checked. If this more
     * significant digit also happens to be greater than 9 or the C flag is
     * set, then $60 is added.
     */
    @Test
    public void testDAA5() {
        myTestCPU.write(0xB00, 0x27);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(1);
        setA(0x40);
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0xA0, myTestCPU.registerA.intValue());
        assertEquals(0, myTestCPU.registerF.getH());
        assertEquals(0, myTestCPU.registerF.getN());
        assertEquals(0, myTestCPU.registerF.getZ());
        assertEquals(1, myTestCPU.registerF.getPV());
        assertEquals(1, myTestCPU.registerF.getC());
    }

    /* Complement Accumulator */
    @Test
    public void testCPL() {
        setA(0x8B);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0x2F); // CPL instruction
        execSeq(0xB00, 0xB01);
        assertEquals(0x74, myTestCPU.registerA.intValue());
        assertEquals(0x12, myTestCPU.registerF.get());
    }

    /* Set Carry Flag -- opcode 3F */
    @Test
    public void testSCF() {
        setA(0x8B);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(false);
        myTestCPU.write(0x0B00, 0x37);
        execSeq(0xB00, 0xB01);
        assertTrue(myTestCPU.registerF.isSetC());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
    }

    /* Complement Carry Flag -- opcode 3F */
    @Test
    public void testCCF() {
        setA(0x8B);
        myTestCPU.registerF.clear();
        myTestCPU.registerF.setC(true);
        myTestCPU.write(0x0B00, 0x3F);
        execSeq(0xB00, 0xB01);
        assertFalse(myTestCPU.registerF.isSetC());
        assertTrue(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
    }

    /* Negate Accumulator
     * TODO:Complete
     */
    @Test
    public void testNEG() {
        setA(0xED);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0xED); // NEG instruction
        myTestCPU.write(0x0B01, 0x44); // NEG instruction
        execSeq(0xB00, 0xB02);
        assertEquals(0x13, myTestCPU.registerA.intValue());
        assertEquals(0x12, myTestCPU.registerF.get()); // Not verified
    }

    @Test
    public void testNOP() {
        setA(0x8B);
        myTestCPU.write(0x0B00, 0x00); // NOP instruction
        myTestCPU.write(0x0B01, 0x00); // NOP instruction
        execSeq(0xB00, 0xB01);
        assertEquals(0x8B, myTestCPU.registerA.intValue());
    }

    /**
     * Disable interrupts, then check that CPU doesn't branch to
     * interrupt handling.
     * TODO
     */
    @Test
    public void disableInterrupts() {
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0xF3, 0x00, 0x00); // DI instruction + NOPs
        execSeq(0xB00, 0xB01);

        Bus8Intel bus = myTestCPU.getBus();
        bus.signalIRQ(true);
        myTestCPU.execute();
        //assertEquals(0x0000, myTestCPU.pc.intValue());
        bus.signalIRQ(false);
    }

    /* Test CPU reset
     * TODO:Complete
     */
    @Test
    public void testRESET() {
        setPC(0xB00);
        myTestCPU.reset();
        assertEquals(0x0000, myTestCPU.pc.intValue());
    }

    @Test
    public void generateIRQ() {
        writeSeq(0x0B00, 0x00, 0x00); // NOP instructions
        setPC(0xB00);
        Bus8Intel bus = myTestCPU.getBus();
        bus.signalIRQ(true);
        myTestCPU.execute();
        //assertEquals(0x0000, myTestCPU.pc.intValue());
        bus.signalIRQ(false);
    }

}
