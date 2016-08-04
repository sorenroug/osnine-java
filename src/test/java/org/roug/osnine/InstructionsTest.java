package org.roug.osnine;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import org.junit.Before;
import org.junit.Test;

public class InstructionsTest {

    private static final int LOCATION = 0x1e20;

    private MC6809 myTestCPU;

    /**
     * Load a short program into memory.
     */
    private void loadProg(int[] instructions) {
        myTestCPU.write_word(0xfffe, LOCATION);
        int respc = myTestCPU.read_word(0xfffe);
        assertEquals(LOCATION, respc);

        for (int i = 0; i < instructions.length; i++) {
            myTestCPU.write(i + LOCATION, instructions[i]);
        }
        myTestCPU.reset();
    }

    private void setCC_A_B_DP_X_Y_S_U(int cc, int a, int b, int dp, int x, int y, int s, int u) {
        myTestCPU.cc.set(cc);
        myTestCPU.a.set(a);
        myTestCPU.b.set(b);
        myTestCPU.dp.set(dp);
        myTestCPU.x.set(x);
        myTestCPU.y.set(y);
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

    @Before
    public void setUp() {
        myTestCPU = new MC6809();
    }

    @Test
    public void testABX() throws IOException {
        int instructions[] = {
            0x3a // ABX
        };
        loadProg(instructions);
        setCC_A_B_DP_X_Y_S_U(0, 0, 0xCE, 0, 0x8006, 0, 0, 0);
        myTestCPU.execute();
        assertEquals(0x3a, myTestCPU.ir);
        assertEquals(LOCATION + 1, myTestCPU.pc);
        chkCC_A_B_DP_X_Y_S_U(0, 0, 0xCE, 0, 0x80D4, 0, 0, 0);
    }


    @Test
    public void testADCANoCarry() {
        int instructions[] = {
            0x89, // ADCA
            0x02  // value
        };
        loadProg(instructions);
        setCC_A_B_DP_X_Y_S_U(0, 5, 0, 0, 0, 0, 0, 0);
//      myTestCPU.cc.bit_c = 0;
//      myTestCPU.a.set(5);
        myTestCPU.execute();
        assertEquals(instructions[0], myTestCPU.ir);
        assertEquals(LOCATION + 2, myTestCPU.pc);
//      assertEquals(7, myTestCPU.a.intValue());
//      assertEquals(0, myTestCPU.cc.bit_c);
        chkCC_A_B_DP_X_Y_S_U(0, 7, 0, 0, 0, 0, 0, 0);
    }


    @Test
    public void testADCAWithCarry() {
        int instructions[] = {
            0x89, // ADCA
            0x22  // value
        };
        loadProg(instructions);
        //myTestCPU.cc.bit_c = 1;
        //myTestCPU.a.set(0x14);
        setCC_A_B_DP_X_Y_S_U(CC.Cmask, 0x14, 0, 0, 0, 0, 0, 0);
        myTestCPU.execute();
        assertEquals(instructions[0], myTestCPU.ir);
        assertEquals(LOCATION + 2, myTestCPU.pc);
        chkCC_A_B_DP_X_Y_S_U(0, 0x37, 0, 0, 0, 0, 0, 0);
        //assertEquals(0x37, myTestCPU.a.intValue());
        //assertEquals(0, myTestCPU.cc.bit_c);
    }

    /*
     * Test that half-carry is set.
     */
    @Test
    public void testADCAWithHalfCarry() {
        int instructions[] = {
            0x89, // ADCA
            0x2B  // value
        };
        loadProg(instructions);
        setCC_A_B_DP_X_Y_S_U(CC.Cmask, 0x14, 0, 0, 0, 0, 0, 0);
        myTestCPU.execute();
        chkCC_A_B_DP_X_Y_S_U(CC.Hmask, 0x40, 0, 0, 0, 0, 0, 0);
    }

    @Test
    public void testADDDNoCarry() {
        int instructions[] = {
            0xC3, // ADCD
            0x02, // value
            0xB0  // value
        };
        loadProg(instructions);
        myTestCPU.cc.bit_c = 0;
        myTestCPU.b.set(0x04);
        myTestCPU.a.set(0x05);
        myTestCPU.execute();
        assertEquals(0xC3, myTestCPU.ir);
        assertEquals(LOCATION + 3, myTestCPU.pc);
        assertEquals(0x06, myTestCPU.b.intValue());
        assertEquals(0xB5, myTestCPU.a.intValue());
        assertEquals(0x06B5, myTestCPU.d.intValue());
        assertEquals(0, myTestCPU.cc.bit_c);
    }

    /**
     * Shift a byte a 0x0402, because DP = 0x04.
     */
    @Test
    public void testASRMemoryByte() {
        int instructions[] = {
            0x07, // ASR
            0x02  // value
        };
        loadProg(instructions);
        setCC_A_B_DP_X_Y_S_U(0, 0, 0, 4, 0, 0, 0, 0);
        myTestCPU.write(0x0402, 0xf1);
        myTestCPU.execute();
        assertEquals(instructions[0], myTestCPU.ir);
        assertEquals(LOCATION + 2, myTestCPU.pc);
        chkCC_A_B_DP_X_Y_S_U(0x09, 0, 0, 4, 0, 0, 0, 0);
        int result = myTestCPU.read(0x0402);
        assertEquals(0xf8, result);
    }

    /**
     * Clear byte in extended mode.
     */
    @Test
    public void CLRMemoryByteExtended() {
        int instructions[] = {
            0x7F, // CLR
            0x0F,  // value
            0x23  // value
        };
        loadProg(instructions);
        setCC_A_B_DP_X_Y_S_U(0, 0, 0, 4, 0, 0, 0, 0);
        myTestCPU.write(0x0F23, 0xE2);
        myTestCPU.execute();
        assertEquals(instructions[0], myTestCPU.ir);
        assertEquals(LOCATION + 3, myTestCPU.pc);
        chkCC_A_B_DP_X_Y_S_U(CC.Zmask, 0, 0, 4, 0, 0, 0, 0);
        int result = myTestCPU.read(0x0F23);
        assertEquals(0, result);
    }

    /**
     * Clear byte in direct mode with DP = 0x0B.
     */
    @Test
    public void CLRMemoryByteDirect() {
        int instructions[] = {
            0x0F, // CLR
            0x23  // value
        };
        loadProg(instructions);
        setCC_A_B_DP_X_Y_S_U(0, 0, 0, 0x0B, 0, 0, 0, 0);
        myTestCPU.write(0x0B23, 0xE2);
        myTestCPU.execute();
        assertEquals(instructions[0], myTestCPU.ir);
        assertEquals(LOCATION + 2, myTestCPU.pc);
        chkCC_A_B_DP_X_Y_S_U(CC.Zmask, 0, 0, 0x0B, 0, 0, 0, 0);
        int result = myTestCPU.read(0x0B23);
        assertEquals(0, result);
    }

    /**
     * Clear byte in indirect mode relative to Y and increment Y.
     */
    @Test
    public void CLRMemoryByteIndexedYinc() {
        int instructions[] = {
            0x6F, // CLR
            0xA0  // value
        };
        loadProg(instructions);
        setCC_A_B_DP_X_Y_S_U(CC.Nmask, 0, 0, 0, 0, 0x899, 0, 0);
        myTestCPU.write(0x0899, 0xE2);
        myTestCPU.write(0x089A, 0x22);
        myTestCPU.execute();
        assertEquals(instructions[0], myTestCPU.ir);
        assertEquals(LOCATION + 2, myTestCPU.pc);
        chkCC_A_B_DP_X_Y_S_U(CC.Zmask, 0, 0, 0, 0, 0x89A, 0, 0);
        int result = myTestCPU.read(0x0899);
        assertEquals(0, result);
    }

    @Test
    public void testBRAForward() {
        int instructions[] = {
            0x20, // BRA
            17 // Jump forward 17 bytes
        };
        loadProg(instructions);
        myTestCPU.execute();
        // The size of the instruction is 2 bytes.
        assertEquals(LOCATION + 2 + 17, myTestCPU.pc);
    }

    @Test
    public void testBRABackward() {
        int instructions[] = {
            0x20, // BRA
            170 // Jump backward 170 - 256 = 86 bytes
        };
        loadProg(instructions);
        myTestCPU.execute();
        // The size of the instruction is 2 bytes.
        assertEquals(LOCATION + 2 - 86, myTestCPU.pc);
    }

    /**
     * Test indirect mode: CMPA ,Y+
     * We're subtracting 0xff from 0xff and incrementing Y
     */
    @Test
    public void testCMP() {
        // Set up a byte to test at address 0x205
        myTestCPU.write(0x205, 0xff);
        // Set register Y to point to that location
        myTestCPU.cc.clear();
        myTestCPU.y.set(0x205);
        myTestCPU.a.set(0xff);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0xA1);
        myTestCPU.write(0xB01, 0xA0);
        myTestCPU.pc = 0xB00;
        myTestCPU.execute();
        assertEquals(0xB00 + 2, myTestCPU.pc);
        chkCC_A_B_DP_X_Y_S_U(CC.Hmask + CC.Zmask, 0xff, 0, 0, 0, 0x206, 0, 0);
        //assertEquals(0x206, myTestCPU.y);
        //assertEquals(0, myTestCPU.cc.bit.n);
        //assertEquals(1, myTestCPU.cc.bit.z);
        //assertEquals(0, myTestCPU.cc.bit.v);
        //assertEquals(0, myTestCPU.cc.bit.c);
    }

    /**
     * Test the JSR - Jump to Subroutine - instruction.
     * INDEXED mode:   JSR   D,Y
     */
/*
    @Test
    public void testJSR() {
        // Set up a word to test at address 0x205
        myTestCPU.write_word(0x205, 0x03ff);
        // Set register D to five
        myTestCPU.d.set(0x105);
        // Set register Y to point to that location minus 5
        myTestCPU.y.set(0x200);
        // Set register S to point to 0x915
        myTestCPU.s.set(0x915);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0xAD);
        myTestCPU.write(0xB01, 0xAB);
        myTestCPU.write(0xB02, 0x11); // Junk
        myTestCPU.write(0xB03, 0x22); // Junk
        myTestCPU.pc = 0xB00;
        myTestCPU.execute();
        chkCC_A_B_DP_X_Y_S_U(0, 0x01, 0x05, 0, 0, 0x200, 0x913, 0);
        assertEquals(0x200, myTestCPU.y);
        assertEquals(0x105, myTestCPU.d);
        assertEquals(0x913, myTestCPU.s);
        assertEquals(0x305, myTestCPU.pc);
    }
*/
}