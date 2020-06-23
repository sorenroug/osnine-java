package org.roug.usim.mc6809;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;

public class SubtractionTest extends Framework {

    private static final int LOCATION = 0x1e20;

    /**
     * Load a short program into memory.
     */
    private void loadProg(int[] instructions) {
        writeword(0xfffe, LOCATION);
        int respc = myTestCPU.read_word(0xfffe);
        assertEquals(LOCATION, respc);

        for (int i = 0; i < instructions.length; i++) {
            myTestCPU.write(i + LOCATION, instructions[i]);
        }
        myTestCPU.reset();
    }

    private void setCC_A_B_DP_X_Y_S_U(int cc, int a, int b, int dp, int x, int y, int s, int u) {
        setCC(cc);
        setA(a);
        setB(b);
        myTestCPU.dp.set(dp);
        setX(x);
        setY(y);
        myTestCPU.s.set(s);
        myTestCPU.u.set(u);
    }

    private void chkCC_A_B_DP_X_Y_S_U(int cc, int a, int b, int dp, int x, int y, int s, int u) {
        assertEquals(cc, myTestCPU.cc.intValue());
        assertEquals(a, myTestCPU.a.intValue());
        assertEquals(b, myTestCPU.b.intValue());
        assertEquals(dp, myTestCPU.dp.intValue());
        assertEquals(x, myTestCPU.x.intValue());
        assertEquals(y, myTestCPU.y.intValue());
        assertEquals(s, myTestCPU.s.intValue());
        assertEquals(u, myTestCPU.u.intValue());
    }

    /**
     * Test indirect mode: CMPA ,Y+
     * We're subtracting 0xff from 0xff and incrementing Y
     */
    @Test
    public void testCMP() {
        // Set up a byte to test at address 0x205
        myTestCPU.write(0x205, 0xff);
        myTestCPU.cc.clear();
        // Set register Y to point to that location
        setY(0x205);
        setA(0xff);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0xA1);  // CMPA indexed
        myTestCPU.write(0xB01, 0xA0);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(0xB00 + 2);
        assertEquals(0x206, myTestCPU.y.intValue());
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(1, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(0, myTestCPU.cc.getC());

        // B = 0xA0, CMPB with 0xA0
        myTestCPU.cc.setN(1);
        myTestCPU.cc.setZ(0);
        setB(0xA0);
        myTestCPU.write(0xB00, 0xC1);  // CMPB immediate
        myTestCPU.write(0xB01, 0xA0);
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(1, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(0, myTestCPU.cc.getC());

        // B = 0x70, CMPB with 0xA0
        // positive - negative = negative + overflow
        myTestCPU.cc.clear();
        setB(0x70);
        myTestCPU.write(0xB00, 0xC1);  // CMPB immediate
        myTestCPU.write(0xB01, 0xA0);
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(1, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(1, myTestCPU.cc.getV());
        assertEquals(1, myTestCPU.cc.getC());
    }

    @Test
    public void testCMP16ext() {
        setX(0x5410);
        setCC(0x23);
        myTestCPU.write(0x0B33, 0x54);
        myTestCPU.write(0x0B34, 0x10);

        myTestCPU.write(0x0B00, 0xBC);
        myTestCPU.write(0x0B01, 0x0B);
        myTestCPU.write(0x0B02, 0x33);
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0x5410, myTestCPU.x.intValue());
        assertEquals(0x24, myTestCPU.cc.intValue());
    }

    /**
     * Decrement register A.
     */
    @Test
    public void testDECA() {
        myTestCPU.cc.clear();
        setA(0x32);
        myTestCPU.write(0xB00, 0x4A);
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0x31, myTestCPU.a.intValue());
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(0, myTestCPU.cc.getC());

        // Test 0x80 - special case
        setA(0x80);
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0x7F, myTestCPU.a.intValue());
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(1, myTestCPU.cc.getV());
        assertEquals(0, myTestCPU.cc.getC());

        // Test 0x00 - special case
        setA(0x00);
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0xFF, myTestCPU.a.intValue());
        assertEquals(1, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(0, myTestCPU.cc.getC());
    }

    /**
     * Decrement memory location.
     */
    @Test
    public void testDEC() {
        myTestCPU.cc.clear();
        myTestCPU.write(0xB10, 0x7F);
        myTestCPU.write(0xB00, 0x7A);
        writeword(0xB01, 0xB10);
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0x7E, myTestCPU.read(0x0B10));
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(0, myTestCPU.cc.getC());
    }


    /**
     * Test the subtraction with carry instruction.
     * B=0x35 - addr(0x503)=0x3 - C=1 becomes 0x31
     */
    @Test
    public void testSBCB() {
        myTestCPU.dp.set(0x05);
        setB(0x35);
        myTestCPU.cc.clear();
        myTestCPU.cc.setC(1);
        myTestCPU.write(0x0503, 0x03);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0xD2);
        myTestCPU.write(0xB01, 0x03);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(0xB02);
        assertEquals(0x31, myTestCPU.b.intValue());
        assertEquals(0, myTestCPU.cc.getC());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getN());
        //assertEquals(1, myTestCPU.cc.getH());
        //assertEquals(0x20, myTestCPU.cc.intValue());
    }

    /**
     * Test the SBCA instruction.
     * A=0xFF - 0xFE - C=1 becomes 0x00
     */
    @Test
    public void testSBCA1() {
        myTestCPU.cc.setN(1);
        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setC(1);
        setA(0xFF);
        myTestCPU.write(0xB00, 0x82);  // SBCA immediate
        myTestCPU.write(0xB01, 0xFE);
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0, myTestCPU.a.intValue());
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(1, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(0, myTestCPU.cc.getC());
    }

    /**
     * Test the SBCA instruction.
     * A=0x00 - 0xFF - C=0 becomes 0x01
     */
    @Test
    public void testSBCA2() {
        myTestCPU.cc.setN(1);
        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setV(1);
        myTestCPU.cc.setC(0);
        setA(0x00);
        myTestCPU.write(0xB00, 0x82);  // SBCA immediate
        myTestCPU.write(0xB01, 0xFF);
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0x01, myTestCPU.a.intValue());
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(1, myTestCPU.cc.getC());
    }

    /**
     * Test the SBCA instruction.
     * A=0x00 - 0x01 - C=0 becomes 0xFF
     */
    @Test
    public void testSBCA3() {
        myTestCPU.cc.setN(1);
        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setV(1);
        myTestCPU.cc.setC(0);
        setA(0x00);
        myTestCPU.write(0xB00, 0x82);  // SBCA immediate
        myTestCPU.write(0xB01, 0x01);
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0xFF, myTestCPU.a.intValue());
        assertEquals(1, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    /**
     * Test the SBCA instruction.
     * A=0x00 - 0xFF - C=1 becomes 0x00
     */
    @Test
    public void testSBCA4() {
        myTestCPU.cc.setN(1);
        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setV(1);
        myTestCPU.cc.setC(1);
        setA(0x00);
        myTestCPU.write(0xB00, 0x82);  // SBCA immediate
        myTestCPU.write(0xB01, 0xFF);
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0x00, myTestCPU.a.intValue());
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(1, myTestCPU.cc.getC());
    }

    /**
     * Test the SUBA instruction.
     * The overflow (V) bit indicates signed two’s complement overflow, which
     * occurs when the sign bit differs from the carry bit after an arithmetic
     * operation.
     */
    @Test
    public void testSUBA1() {
        // A=0x00 - 0xFF becomes 0x01
        // positive - negative = positive
        myTestCPU.cc.setN(1);
        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setV(1);
        myTestCPU.cc.setC(1);
        setA(0x00);
        myTestCPU.write(0xB00, 0x80);  // SUBA immediate
        myTestCPU.write(0xB01, 0xFF);
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0x01, myTestCPU.a.intValue());
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(1, myTestCPU.cc.getC());
    }

    /**
     * A=0x00 - 0x01 becomes 0xFF
     * positive - positive = negative
     */
    @Test
    public void testSUBA2() {
        myTestCPU.cc.setN(1);
        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setV(1);
        myTestCPU.cc.setC(1);
        setA(0x00);
        myTestCPU.write(0xB00, 0x80);  // SUBA immediate
        myTestCPU.write(0xB01, 0x01);
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0xFF, myTestCPU.a.intValue());
        assertEquals(1, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(1, myTestCPU.cc.getC());
    }

    /**
     * Test the subtraction instruction.
     * IMMEDIATE mode:   B=0x02 - 0xB3  becomes 0x4F
     * positive - negative = positive
     */
    @Test
    public void testSUBB1() {
        setB(0x02);
        myTestCPU.write(0xB00, 0xC0); // SUBB
        myTestCPU.write(0xB01, 0xB3);
        myTestCPU.cc.clear();
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0x4F, myTestCPU.b.intValue());
        assertPC(0xB02);
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(1, myTestCPU.cc.getC());
    }

    /**
     * Test the subtraction instruction.
     * IMMEDIATE mode:   B=0x02 - 0x81  becomes 0x81
     * positive - negative = negative + overflow
     */
    @Test
    public void testSUBB2() {
        setB(0x02);
        myTestCPU.write(0xB00, 0xC0); // SUBB
        myTestCPU.write(0xB01, 0x81);
        myTestCPU.cc.clear();
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0x81, myTestCPU.b.intValue());
        assertPC(0xB02);
        assertEquals(1, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(1, myTestCPU.cc.getV());
        assertEquals(1, myTestCPU.cc.getC());
    }


    /**
     * Test INDEXED mode:   SUBA   B,S where B is negative.
     * A = 0x99
     * B = 0xF2 = -14
     * S = 0x210
     * Read location at stack pointer (0x210) - 14 = 0x202. Value is 0x73.
     * 0x99 - 0x73 = 0x26
     * negative - positive = positive + overflow
     * The overflow (V) bit indicates signed two’s complement overflow, which occurs when the
     * sign bit differs from the carry bit after an arithmetic operation.
     */
    @Test
    public void testSUBAindexed() {
        // Set up a byte to test at address 0x202
        myTestCPU.write(0x202, 0x73);
        setA(0x99);
        // Set register B to the offset = -14
        setB(0xF2);
        // Set register S to point to that location minus 2
        myTestCPU.s.set(0x210);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0xA0); // SUBA
        myTestCPU.write(0xB01, 0xE5); // 11100101  B,S
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0x210, myTestCPU.s.intValue());
        assertEquals(0x26, myTestCPU.a.intValue());
        assertEquals(0xF2, myTestCPU.b.intValue());
        assertPC(0xB02);
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(1, myTestCPU.cc.getV());
        assertEquals(0, myTestCPU.cc.getC());
    }

    /**
     * Test INDEXED mode:   SUBB   A,S where A is negative.
     * B = 0x40
     * A = 0xF2 = -14
     * S = 0x210
     * Read location at stack pointer (0x210) - 14 = 0x202. Value is 0x73.
     * 0x40 - 0x73 = 0xCD
     * positive - positive = negative
     */
    @Test
    public void testSUBBindexed() {
        // Test INDEXED mode:   SUBB   A,S where A is negative
        //
        // Set up a word to test at address 0x202
        writeword(0x202, 0x73ff);
        setB(0x40);
        // Set register A to the offset = -14
        setA(0xF2);
        // Set register S to point to that location minus 2
        myTestCPU.s.set(0x210);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0xE0); // SUBB
        myTestCPU.write(0xB01, 0xE6); // 11100110  A,S
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0x210, myTestCPU.s.intValue());
        assertEquals(0xF2, myTestCPU.a.intValue());
        assertEquals(0xCD, myTestCPU.b.intValue());
        assertPC(0xB02);
        assertEquals(1, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(1, myTestCPU.cc.getC());
    }

    /**
     * Example from Programming the 6809.
     * 0x03 - 0x21 = 0xE2
     * positive - positive = negative
     */
    @Test
    public void testSUBBcommaY() {
        setB(0x03);
        setY(0x0021);
        setCC(0x44);
        myTestCPU.write(0x21, 0x21);
        myTestCPU.write(0xB00, 0xE0); // SUBB
        myTestCPU.write(0xB01, 0xA4); // 10100100  ,Y
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0xE2, myTestCPU.b.intValue());
        assertEquals(1, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(1, myTestCPU.cc.getC());
    }

    /**
     * Test the subtraction instruction for D.
     * We subtract the content of the DP + 0
     * D=0x7702 - addr(0200)=0x0123 becomes 0x75DF
     * positive - positive = positive
     */
    @Test
    public void testSUBD1() {
        setA(0x77);
        setB(0x02);
        myTestCPU.dp.set(0x02);
        myTestCPU.write(0x0200, 0x01);
        myTestCPU.write(0x0201, 0x23);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0x93); //SUBD
        myTestCPU.write(0xB01, 0x00); // Direct page addr + 0
        myTestCPU.cc.clear();
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0x75, myTestCPU.a.intValue());
        assertEquals(0xDF, myTestCPU.b.intValue());
        assertEquals(0x75DF, myTestCPU.d.intValue());
        assertPC(0xB02);
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(0, myTestCPU.cc.getC());
    }


    /**
     * Test the subtraction instruction for D.
     * We subtract the content of the DP + 0
     * D=0x0705 - 0x0123 becomes 0x05E2
     * positive - positive = positive
     */
    @Test
    public void testSUBD2() {
        myTestCPU.d.set(0x0705);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0x83); //SUBD
        writeword(0xB01, 0x0123);
        myTestCPU.cc.clear();
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0x05E2, myTestCPU.d.intValue());
        assertPC(0xB03);
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(0, myTestCPU.cc.getC());
    }


    /**
     * Test the subtraction instruction for D.
     * We subtract the content of the DP + 0
     * D=0x0702 - 0xF123 becomes 0x15DF
     * positive - negative = positive
     */
    @Test
    public void testSUBD3() {
        myTestCPU.d.set(0x0702);
        myTestCPU.write(0xB00, 0x83); //SUBD
        writeword(0xB01, 0xF123);
        myTestCPU.cc.clear();
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0x15DF, myTestCPU.d.intValue());
        assertPC(0xB03);
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
        assertEquals(1, myTestCPU.cc.getC());
    }

    /**
     * D=0x0800 - 0x8000 = 8800
     * positive - negative = negative + overflow
     */
    @Test
    public void testSUBD4() {
        myTestCPU.d.set(0x0800);
        myTestCPU.write(0xB00, 0x83); //SUBD
        writeword(0xB01, 0x8000);
        myTestCPU.cc.clear();
        setPC(0xB00);
        myTestCPU.execute();
        assertEquals(0x8800, myTestCPU.d.intValue());
        assertPC(0xB03);
        assertEquals(1, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(1, myTestCPU.cc.getV());
        assertEquals(1, myTestCPU.cc.getC());
    }

}
