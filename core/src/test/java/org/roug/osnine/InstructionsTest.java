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

    @Before
    public void setUp() {
        myTestCPU = new MC6809(8192);
    }

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

    @Test
    public void testABX() throws IOException {
        int instructions[] = {
            0x3a // ABX
        };
        loadProg(instructions);
        setCC_A_B_DP_X_Y_S_U(0, 0, 0xCE, 0, 0x8006, 0, 0, 0);
        myTestCPU.execute();
        assertEquals(0x3a, myTestCPU.ir);
        assertEquals(LOCATION + 1, myTestCPU.pc.intValue());
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
        assertEquals(LOCATION + 2, myTestCPU.pc.intValue());
//      assertEquals(7, myTestCPU.a.intValue());
//      assertEquals(0, myTestCPU.cc.getC());
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
        assertEquals(LOCATION + 2, myTestCPU.pc.intValue());
        chkCC_A_B_DP_X_Y_S_U(0, 0x37, 0, 0, 0, 0, 0, 0);
        //assertEquals(0x37, myTestCPU.a.intValue());
        //assertEquals(0, myTestCPU.cc.getC());
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
        assertEquals(LOCATION + 3, myTestCPU.pc.intValue());
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
        assertEquals(LOCATION + 2, myTestCPU.pc.intValue());
        chkCC_A_B_DP_X_Y_S_U(0x09, 0, 0, 4, 0, 0, 0, 0);
        int result = myTestCPU.read(0x0402);
        assertEquals(0xf8, result);
    }

    /**
     * Don't branch because Z is on.
     */
    @Test
    public void testBGTWithZ() {
        int instructions[] = {
            0x2E, // BGT
            17 // Jump forward 17 bytes
        };
        loadProg(instructions);
        myTestCPU.cc.set(CC.Zmask);
        myTestCPU.execute();
        // The size of the instruction is 2 bytes.
        assertEquals(LOCATION + 2, myTestCPU.pc.intValue());
    }

    /**
     * Branch because N and V are on.
     */
    @Test
    public void testBGTWithNandV() {
        int instructions[] = {
            0x2E, // BGT
            0x17 // Jump forward 0x17 bytes
        };
        loadProg(instructions);
        myTestCPU.cc.set(CC.Nmask + CC.Vmask);
        myTestCPU.execute();
        // The size of the instruction is 2 bytes.
        assertEquals(LOCATION + 2 + 0x17, myTestCPU.pc.intValue());
    }

    /**
     * Branch because Z, N and V are off.
     */
    @Test
    public void testBGTWithNandVoff() {
        int instructions[] = {
            0x2E, // BGT
            0x17 // Jump forward 0x17 bytes
        };
        loadProg(instructions);
        myTestCPU.cc.set(CC.Cmask);
        myTestCPU.execute();
        // The size of the instruction is 2 bytes.
        assertEquals(LOCATION + 2 + 0x17, myTestCPU.pc.intValue());
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
        assertEquals(LOCATION + 2 + 17, myTestCPU.pc.intValue());
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
        assertEquals(LOCATION + 2 - 86, myTestCPU.pc.intValue());
    }

    @Test
    public void testBSRBackward() {
        int instructions[] = {
            0x8d, // BSR
            170 // Jump backward 170 - 256 = 86 bytes
        };
        loadProg(instructions);
        myTestCPU.s.set(0x300);
        myTestCPU.execute();
        // The size of the instruction is 2 bytes.
        assertEquals(LOCATION + 2 - 86, myTestCPU.pc.intValue());
        assertEquals(0x2fe, myTestCPU.s.intValue());
        assertEquals(0x22, myTestCPU.read(0x2ff));
        assertEquals(0x1e, myTestCPU.read(0x2fe));
    }

    @Test
    public void testLBSR() {
        int instructions[] = {
            0x17, // LBSR
            0x03,
            0x72
        };
        loadProg(instructions);
        myTestCPU.s.set(0x300);
        myTestCPU.execute();
        // The size of the instruction is 2 bytes.
        assertEquals(LOCATION + 3 + 0x0372, myTestCPU.pc.intValue());
        assertEquals(0x2fe, myTestCPU.s.intValue());
        assertEquals(0x23, myTestCPU.read(0x2ff));
        assertEquals(0x1e, myTestCPU.read(0x2fe));
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
        assertEquals(LOCATION + 3, myTestCPU.pc.intValue());
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
        assertEquals(LOCATION + 2, myTestCPU.pc.intValue());
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
        assertEquals(LOCATION + 2, myTestCPU.pc.intValue());
        chkCC_A_B_DP_X_Y_S_U(CC.Zmask, 0, 0, 0, 0, 0x89A, 0, 0);
        int result = myTestCPU.read(0x0899);
        assertEquals(0, result);
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
        myTestCPU.y.set(0x205);
        myTestCPU.a.set(0xff);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0xA1);
        myTestCPU.write(0xB01, 0xA0);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0xB00 + 2, myTestCPU.pc.intValue());
        chkCC_A_B_DP_X_Y_S_U(CC.Hmask + CC.Zmask, 0xff, 0, 0, 0, 0x206, 0, 0);
    }

    @Test
    public void testDAA() {
        myTestCPU.write(0xB00, 0x19);
        myTestCPU.cc.clear();
        myTestCPU.a.set(0x7f);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x85, myTestCPU.a.intValue());
        assertEquals(0x08, myTestCPU.cc.intValue());
    }

    @Test
    public void testEXG() {
        myTestCPU.write(0xB00, 0x1E);
        myTestCPU.write(0xB01, 0x01);
        myTestCPU.cc.clear();
        myTestCPU.d.set(0x117f);
        myTestCPU.x.set(0xff16);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0xff16, myTestCPU.d.intValue());
        assertEquals(0x117f, myTestCPU.x.intValue());
    }

    /**
     * Test the JSR - Jump to Subroutine - instruction.
     * INDEXED mode:   JSR   D,Y
     */
    @Test
    public void testJSR() {
        // Set up a word to test at address 0x205
        myTestCPU.write_word(0x205, 0x03ff);
        // Set register D
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
        myTestCPU.pc.set(0xB00);
        myTestCPU.cc.clear();
        myTestCPU.execute();
        chkCC_A_B_DP_X_Y_S_U(0, 0x05, 0x01, 0, 0, 0x200, 0x913, 0);
        assertEquals(0x200, myTestCPU.y.intValue());
        assertEquals(0x105, myTestCPU.d.intValue());
        assertEquals(0x913, myTestCPU.s.intValue());
        assertEquals(0x305, myTestCPU.pc.intValue());
    }

    /**
     * Test the LDB - Load into B - instruction.
     */
    @Test
    public void testLDB() {
	// Test INDEXED mode:   LDB   A,S
	//
	// Set up a word to test at address 0x205
	myTestCPU.write_word(0x202, 0xb3ff);
	// Set register A to the offset
	myTestCPU.a.set(0x02);
	// Set register S to point to that location minus 2
	myTestCPU.s.set(0x200);
	// Two bytes of instruction
	myTestCPU.write(0xB00, 0xE6);
	myTestCPU.write(0xB01, 0xE6);
        myTestCPU.cc.clear();
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0x200, myTestCPU.s.intValue());
	assertEquals(0xb3, myTestCPU.b.intValue());
	assertEquals(0xB02, myTestCPU.pc.intValue());
	assertEquals(1, myTestCPU.cc.getN());
	assertEquals(0, myTestCPU.cc.getZ());
	assertEquals(0, myTestCPU.cc.getV());

	// Test INDEXED mode:   LDB   A,S where A is negative
	//
	// Set up a word to test at address 0x205
	myTestCPU.write_word(0x202, 0x73ff);
	// Set register A to the offset
	myTestCPU.a.set(0xF2);
	// Set register S to point to that location minus 2
	myTestCPU.s.set(0x210);
	// Two bytes of instruction
	myTestCPU.write(0xB00, 0xE6);
	myTestCPU.write(0xB01, 0xE6);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0x210, myTestCPU.s.intValue());
	assertEquals(0x73, myTestCPU.b.intValue());
	assertEquals(0xB02, myTestCPU.pc.intValue());
	assertEquals(0, myTestCPU.cc.getN());
	assertEquals(0, myTestCPU.cc.getZ());
	assertEquals(0, myTestCPU.cc.getV());
    }

    /**
     * Test the LDD - Load into D - instruction.
     */
    @Test
    public void testLDD() {
	// Test INDEXED mode:   LDD   2,Y
	//
	// Set up a word to test at address 0x205
	myTestCPU.write_word(0x202, 0xb3ff);
	// Set register D to something
	myTestCPU.d.set(0x105);
	// Set register Y to point to that location minus 5
	myTestCPU.y.set(0x200);
	// Two bytes of instruction
	myTestCPU.write(0xB00, 0xEC);
	myTestCPU.write(0xB01, 0x22);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0x200, myTestCPU.y.intValue());
	assertEquals(0xb3ff, myTestCPU.d.intValue());
	assertEquals(0xB02, myTestCPU.pc.intValue());
	assertEquals(1, myTestCPU.cc.getN());
	assertEquals(0, myTestCPU.cc.getZ());
	assertEquals(0, myTestCPU.cc.getV());

	// Test INDEXED mode:   LDD   -2,Y
	//
	myTestCPU.cc.clear();
	// Set up a word to test at address 0x1FE
	myTestCPU.write_word(0x1FE, 0x33ff);
	// Set register Y to point to that location plus 2
	myTestCPU.y.set(0x200);
	// Two bytes of instruction
	myTestCPU.write(0xB00, 0xEC);
	myTestCPU.write(0xB01, 0x3E);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0x200, myTestCPU.y.intValue());
	assertEquals(0x33ff, myTestCPU.d.intValue());
	assertEquals(0x33, myTestCPU.b.intValue());
	assertEquals(0xB02, myTestCPU.pc.intValue());
	assertEquals(0, myTestCPU.cc.getN());
	assertEquals(0, myTestCPU.cc.getZ());
	assertEquals(0, myTestCPU.cc.getV());

	// Test INDEXED mode:   LDD   ,--Y (decrement Y by 2 before loading D)
	//
	myTestCPU.cc.clear();
	// Set up a word to test at address 0x200
	myTestCPU.write_word(0x200, 0x31ff);
	// Set register Y to point to that location minus 5
	myTestCPU.y.set(0x202);
	// Two bytes of instruction
	myTestCPU.write(0xB00, 0xEC);
	myTestCPU.write(0xB01, 0xA3);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0x200, myTestCPU.y.intValue());
	assertEquals(0x31ff, myTestCPU.d.intValue());
	assertEquals(0xB02, myTestCPU.pc.intValue());
	assertEquals(0, myTestCPU.cc.getN());
	assertEquals(0, myTestCPU.cc.getZ());
	assertEquals(0, myTestCPU.cc.getV());
    }

    @Test
    public void testLEAX_PCR() {
	int instructions[] = {
	    0x30, // LEAX        >$0013,PCR
	    0x8D,
	    0xFE,
	    0x49
	};

	int offset = 0x10000 - 0xfe49;
	// Negate 0
	loadProg(instructions);
	myTestCPU.execute();
	assertEquals(LOCATION + 4 - offset, myTestCPU.x.intValue());
	assertEquals(LOCATION + 4, myTestCPU.pc.intValue());

	// LEAX        <$93A,PCR
	myTestCPU.write(0x0846, 0x30);
	myTestCPU.write(0x0847, 0x8C);
	myTestCPU.write(0x0848, 0xF1);
        myTestCPU.pc.set(0x0846);
	myTestCPU.execute();
	assertEquals(0x0849, myTestCPU.pc.intValue());
	assertEquals(0x083a, myTestCPU.x.intValue());
    }

    /**
     * Test the LSL - Logical Shift Left instruction.
     */
    @Test
    public void testLSL() {
        // Write instruction into memory
        myTestCPU.write(0xB00, 0x48);
        // Logical Shift Left of 0xff
        myTestCPU.cc.clear();
        myTestCPU.a.set(0xff);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0xfe, myTestCPU.a.intValue());
        assertEquals(0x09, myTestCPU.cc.intValue());
    //  assertEquals(0, myTestCPU.cc.getV());
    //  assertEquals(0, myTestCPU.cc.bit.n);

        // Logical Shift Left of 1
        myTestCPU.cc.setC(0);
        myTestCPU.cc.setV(1);
        myTestCPU.a.set(1);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x02, myTestCPU.a.intValue());
        assertEquals(0, myTestCPU.cc.intValue());
    //  assertEquals(0, myTestCPU.cc.getC());
    //  assertEquals(0, myTestCPU.cc.getV());

        // Logical Shift Left of 0xB8
        myTestCPU.cc.setC(0);
        myTestCPU.cc.setV(0);
        myTestCPU.a.set(0xB8);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x70, myTestCPU.a.intValue());
        assertEquals(0x03, myTestCPU.cc.intValue());
    //  assertEquals(1, myTestCPU.cc.getC());
    //  assertEquals(1, myTestCPU.cc.getV());
    }

    /**
     * Test the NEG - Negate instruction.
     */
    @Test
    public void testNEG() {
	// Write instruction into memory
	myTestCPU.write(0xB00, 0x40);
	// Negate 0
	myTestCPU.a.set(0);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0, myTestCPU.a.intValue());
	assertEquals(0, myTestCPU.cc.getC());

	// Negate 1
	myTestCPU.a.set(1);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0xFF, myTestCPU.a.intValue());
	assertEquals(1, myTestCPU.cc.getC());

	// Negate 2
	myTestCPU.a.set(2);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0xFE, myTestCPU.a.intValue());
	assertEquals(1, myTestCPU.cc.getC());
    }

    /**
     * Test the PULS - Pull registers from Hardware Stack - instruction.
     * The stack grows downwards, and this means that when you PULL, the
     * stack pointer is increased.
     */
    @Test
    public void testPULS() {
	// Test: PULS PC,Y
	//
	// Set up stored Y value at 0x205
	myTestCPU.write_word(0x205, 0xb140);
	// Set up stored PC value at 0x207
	myTestCPU.write_word(0x207, 0x04ff);
	// Set Y to something benign
	myTestCPU.y.set(0x1115);
	// Set register S to point to 0x205
	myTestCPU.s.set(0x205);
	myTestCPU.cc.set(0x0f);
	// Two bytes of instruction
	myTestCPU.write(0xB00, 0x35); // PUL
	myTestCPU.write(0xB01, 0xA0); // PC,Y
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0xb140, myTestCPU.y.intValue());
	assertEquals(0x04ff, myTestCPU.pc.intValue());
	assertEquals(0x0f, myTestCPU.cc.intValue());
    }

    /**
     * Test the LDB - Load into B - instruction.
     */
    @Test
    public void testSUBB() {
	// Test IMMEDIATE mode:   SUBB $202
	//
	// Set register A to the offset
	myTestCPU.b.set(2);
	// Two bytes of instruction
	myTestCPU.write(0xB00, 0xc0);
	myTestCPU.write(0xB01, 179);
        myTestCPU.cc.clear();
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(79, myTestCPU.b.intValue());
	assertEquals(0xB02, myTestCPU.pc.intValue());
	assertEquals(0, myTestCPU.cc.getN());
	assertEquals(0, myTestCPU.cc.getZ());
	assertEquals(0, myTestCPU.cc.getV());
	assertEquals(1, myTestCPU.cc.getC());
    }

    //@Test
    public void testSUBBindexed() {
	// Test INDEXED mode:   LDB   A,S where A is negative
	//
	// Set up a word to test at address 0x202
	myTestCPU.write_word(0x202, 0x73ff);
	// Set register A to the offset
	myTestCPU.b.set(0xF2);
	// Set register S to point to that location minus 2
	myTestCPU.s.set(0x210);
	// Two bytes of instruction
	myTestCPU.write(0xB00, 0xE0);
	myTestCPU.write(0xB01, 0xE6);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0x210, myTestCPU.s.intValue());
	assertEquals(0x73, myTestCPU.b.intValue());
	assertEquals(0xB02, myTestCPU.pc.intValue());
	assertEquals(0, myTestCPU.cc.getN());
	assertEquals(0, myTestCPU.cc.getZ());
	assertEquals(0, myTestCPU.cc.getV());
    }

    /**
     * Test the instruction TST.
     * TST: The Z and N bits are affected according to the value
     * of the specified operand. The V bit is cleared.
     */
    @Test
    public void testTST() {
	// Write instruction into memory
	myTestCPU.write(0xB00, 0x4D);
	// Test a = 0xff
	myTestCPU.cc.clear();
	myTestCPU.a.set(0xff);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0xff, myTestCPU.a.intValue());
	assertEquals(1, myTestCPU.cc.getN());
	assertEquals(0, myTestCPU.cc.getZ());
	assertEquals(0, myTestCPU.cc.getV());

	//  Test a = 0x01 and V set
	myTestCPU.cc.clear();
	myTestCPU.cc.setV(1);
	myTestCPU.a.set(0x01);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0x01, myTestCPU.a.intValue());
	assertEquals(0, myTestCPU.cc.intValue());
    //  assertEquals(0, myTestCPU.cc.getC());
    //  assertEquals(0, myTestCPU.cc.getV());

	// Test a = 0x00
	myTestCPU.cc.clear();
	myTestCPU.a.set(0x00);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0, myTestCPU.cc.getN());
	assertEquals(1, myTestCPU.cc.getZ());
	assertEquals(0, myTestCPU.cc.getV());

	// Test indirect mode: TST ,Y
	// Set up a byte to test at address 0x205
	myTestCPU.write(0x205, 0xff);
	// Set register Y to point to that location
	myTestCPU.y.set(0x205);
	// Two bytes of instruction
	myTestCPU.write(0xB00, 0x6d);
	myTestCPU.write(0xB01, 0xa4);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(1, myTestCPU.cc.getN());
	assertEquals(0, myTestCPU.cc.getZ());
	assertEquals(0, myTestCPU.cc.getV());
    }

}
