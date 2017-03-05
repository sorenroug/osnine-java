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
        myTestCPU = new MC6809(0x2000);
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

    /**
     * Add 0x02B0 to D=0x0405.
     */
    @Test
    public void testADDDNoCarry() {
        int instructions[] = {
            0xC3, // ADCD
            0x02, // value
            0xB0  // value
        };
        loadProg(instructions);
        myTestCPU.cc.bit_c = 0;
        myTestCPU.a.set(0x04);
        myTestCPU.b.set(0x05);
        myTestCPU.execute();
        assertEquals(0xC3, myTestCPU.ir);
        assertEquals(LOCATION + 3, myTestCPU.pc.intValue());
        assertEquals(0x06, myTestCPU.a.intValue());
        assertEquals(0xB5, myTestCPU.b.intValue());
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
    public void testLBSRbackward() {
        int instructions[] = {
            0x17, // LBSR
            0xF8,
            0xD5
        };
        loadProg(instructions);
        myTestCPU.s.set(0x300);
        myTestCPU.execute();
        // The size of the instruction is 2 bytes.
        assertEquals(LOCATION + 3 - 0x072B, myTestCPU.pc.intValue());
        assertEquals(0x2fe, myTestCPU.s.intValue());
        assertEquals(0x23, myTestCPU.read(0x2ff));
        assertEquals(0x1e, myTestCPU.read(0x2fe));
    }

    @Test
    public void testLBSRforward() {
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

    /**
     * Complement register A
     */
    @Test
    public void testCOMA() {
        myTestCPU.cc.clear();
        myTestCPU.a.set(0x74);
        myTestCPU.write(0xB00, 0x43);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x8B, myTestCPU.a.intValue());
        assertEquals(0x09, myTestCPU.cc.intValue());
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
        chkCC_A_B_DP_X_Y_S_U(0, 0x01, 0x05, 0, 0, 0x200, 0x913, 0);
        assertEquals(0x200, myTestCPU.y.intValue());
        assertEquals(0x105, myTestCPU.d.intValue());
        assertEquals(0x913, myTestCPU.s.intValue());
        assertEquals(0x305, myTestCPU.pc.intValue());
    }

//
// L
//
    @Test
    public void testLBRAForwards() {
        myTestCPU.write(0xB00, 0x16);
        myTestCPU.write_word(0xB01, 0x03FF);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
        assertEquals(0xB00 + 3 + 0x03FF, myTestCPU.pc.intValue());
    }

    @Test
    public void testLBRABackwards() {
        myTestCPU.write(0x1B00, 0x16);
        myTestCPU.write_word(0x1B01, 0xF333);
        myTestCPU.pc.set(0x1B00);
	myTestCPU.execute();
        assertEquals(0x1B00 + 3 - 0xCCD, myTestCPU.pc.intValue());
    }

    @Test
    public void testLBRNForwards() {
        myTestCPU.write_word(0xB00, 0x1021);
        myTestCPU.write_word(0xB02, 0x03FF);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
        assertEquals(0xB00 + 4, myTestCPU.pc.intValue());
    }


    /**
     * Increase the stack register by two. (LEAS +$ 2,S.)
     * LEA only allows indexed mode.
     *
     */
    @Test
    public void testLEASinc2() {
        myTestCPU.s.set(0x900);
	myTestCPU.write(0xB00, 0x32);  // LEAS
	myTestCPU.write(0xB01, 0x62);  // SP + 2 (last 5 bits)
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0xB02, myTestCPU.pc.intValue());
	assertEquals(0x902, myTestCPU.s.intValue());
    }

    /**
     * Decrease the stack register by two. (LEAS -$ 2,S.)
     * LEA only allows indexed mode.
     *
     */
    @Test
    public void testLEASdec2() {
        myTestCPU.s.set(0x900);
	myTestCPU.write(0xB00, 0x32);  // LEAS
	myTestCPU.write(0xB01, 0x7E);  // SP + 2's complement of last 5 bits.
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0xB02, myTestCPU.pc.intValue());
	assertEquals(0x8FE, myTestCPU.s.intValue());
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

    @Test
    public void testMUL() {
	myTestCPU.write(0xB00, 0x3D); // Write instruction into memory
	myTestCPU.a.set(0x0C);
	myTestCPU.b.set(0x64);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0x04B0, myTestCPU.d.intValue());
	assertEquals(0x04, myTestCPU.a.intValue());
	assertEquals(0xB0, myTestCPU.b.intValue());
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
	assertEquals(0, myTestCPU.cc.getV());

	// Negate 0x80
	myTestCPU.a.set(0x80);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0x80, myTestCPU.a.intValue());
	assertEquals(1, myTestCPU.cc.getC());
	assertEquals(1, myTestCPU.cc.getV());
	assertEquals(1, myTestCPU.cc.getN());
	assertEquals(0, myTestCPU.cc.getZ());
    }

    /**
     * Test the subtraction instruction.
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
     * Test the subtraction instruction for D.
     * We subtract the content of the DP + 0
     */
    @Test
    public void testSUBD() {
	myTestCPU.a.set(0x77);
	myTestCPU.b.set(0x02);
	myTestCPU.dp.set(0x02);
        myTestCPU.write(0x0200, 0x01);
        myTestCPU.write(0x0201, 0x23);
	// Two bytes of instruction
	myTestCPU.write(0xB00, 0x93); //SUBD
	myTestCPU.write(0xB01, 0x00); // Direct page addr + 0
        myTestCPU.cc.clear();
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0x75, myTestCPU.a.intValue());
	assertEquals(0xDF, myTestCPU.b.intValue());
	assertEquals(0x75DF, myTestCPU.d.intValue());
	assertEquals(0xB02, myTestCPU.pc.intValue());
    }

    @Test
    public void testTFR_d_y() {
	// Write instruction into memory
	myTestCPU.write(0xB00, 0x1F);
	myTestCPU.write(0xB01, 0x02);
	myTestCPU.cc.clear();
	myTestCPU.d.set(0xABBA);
	myTestCPU.y.set(0x0101);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0xB02, myTestCPU.pc.intValue());
	assertEquals(0xABBA, myTestCPU.d.intValue());
	assertEquals(0xABBA, myTestCPU.y.intValue());
	assertEquals(0, myTestCPU.cc.getN());
	assertEquals(0, myTestCPU.cc.getZ());
	assertEquals(0, myTestCPU.cc.getV());
    }

    @Test
    public void testTFR_s_pc() {
	// Write instruction into memory
	myTestCPU.write(0xB00, 0x1F);
	myTestCPU.write(0xB01, 0x45);
	myTestCPU.cc.clear();
	myTestCPU.s.set(0x1BB1);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0x1BB1, myTestCPU.pc.intValue());
	assertEquals(0x1BB1, myTestCPU.s.intValue());
	assertEquals(0, myTestCPU.cc.getN());
	assertEquals(0, myTestCPU.cc.getZ());
	assertEquals(0, myTestCPU.cc.getV());
    }

    @Test
    public void testTFR_dp_cc() {
	// Write instruction into memory
	myTestCPU.write(0xB00, 0x1F);
	myTestCPU.write(0xB01, 0xBA);
	myTestCPU.cc.clear();
	myTestCPU.dp.set(0x1B);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0x1B, myTestCPU.dp.intValue());
	assertEquals(0x1B, myTestCPU.cc.intValue());
	assertEquals(0, myTestCPU.cc.getH());
	assertEquals(1, myTestCPU.cc.getI());
	assertEquals(1, myTestCPU.cc.getN());
	assertEquals(0, myTestCPU.cc.getZ());
	assertEquals(1, myTestCPU.cc.getV());
	assertEquals(1, myTestCPU.cc.getC());
    }

    /**
     * Test the instruction TST.
    /**
     * Test the instruction TST.
     * TST: The Z and N bits are affected according to the value
     * of the specified operand. The V bit is cleared.
     */
    @Test
    public void testTSTmemory() {
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
    }

    @Test
    public void testTSTacc01() {
	// Write instruction into memory
	myTestCPU.write(0xB00, 0x4D);
	//  Test a = 0x01 and V set
	myTestCPU.cc.clear();
	myTestCPU.cc.setV(1);
	myTestCPU.a.set(0x01);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0x01, myTestCPU.a.intValue());
	assertEquals(0, myTestCPU.cc.intValue());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    @Test
    public void testTSTacc00() {
	// Write instruction into memory
	myTestCPU.write(0xB00, 0x4D);
	// Test a = 0x00
	myTestCPU.cc.clear();
	myTestCPU.a.set(0x00);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0, myTestCPU.cc.getN());
	assertEquals(1, myTestCPU.cc.getZ());
	assertEquals(0, myTestCPU.cc.getV());
    }

    @Test
    public void testTSTindirect() {
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
