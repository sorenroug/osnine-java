package org.roug.osnine;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;

public class BranchAndJumpTest {

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
    public void testBCC() {
        final int PROGLOC = 0xB00;
        final int UNBRANCHED = 0xB00 + 2;
        final int BRANCHED = 0xB00 + 2 + 0x11;

        // Write instruction into memory
        myTestCPU.write(0xB00, 0x24); // BCC
        myTestCPU.write(0xB01, 0x11);
        myTestCPU.cc.clear();

        myTestCPU.cc.setC(0);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(BRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setC(1);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(UNBRANCHED, myTestCPU.pc.intValue());
    }

    @Test
    public void testBGEForward() {
        final int PROGLOC = 0xB00;
        final int UNBRANCHED = 0xB00 + 2;
        final int BRANCHED = 0xB00 + 2 + 0x11;

        // Write instruction into memory
        myTestCPU.write(0xB00, 0x2C);  // BGE
        myTestCPU.write(0xB01, 0x11);
        myTestCPU.cc.clear();

        myTestCPU.cc.setV(0);
        myTestCPU.cc.setN(0);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(BRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setV(1);
        myTestCPU.cc.setN(0);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(UNBRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setV(0);
        myTestCPU.cc.setN(1);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(UNBRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setV(1);
        myTestCPU.cc.setN(1);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(BRANCHED, myTestCPU.pc.intValue());
    }

    @Test
    public void testBGTForward() {
        final int PROGLOC = 0xB00;
        final int UNBRANCHED = 0xB00 + 2;
        final int BRANCHED = 0xB00 + 2 + 0x11;

        // Write instruction into memory
        myTestCPU.write(0xB00, 0x2E);  // BGT
        myTestCPU.write(0xB01, 0x11);
        myTestCPU.cc.clear();

        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setV(0);
        myTestCPU.cc.setN(0);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(BRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setV(1);
        myTestCPU.cc.setN(0);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(UNBRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setV(0);
        myTestCPU.cc.setN(1);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(UNBRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setV(1);
        myTestCPU.cc.setN(1);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(BRANCHED, myTestCPU.pc.intValue());
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
    public void testBHI() {
        final int PROGLOC = 0xB00;
        final int UNBRANCHED = 0xB00 + 2;
        final int BRANCHED = 0xB00 + 2 + 0x11;

        // Write instruction into memory
        myTestCPU.write(0xB00, 0x22);  // BHI
        myTestCPU.write(0xB01, 0x11);
        myTestCPU.cc.clear();

        myTestCPU.cc.setC(0);
        myTestCPU.cc.setZ(0);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(BRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setC(1);
        myTestCPU.cc.setZ(0);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(UNBRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setC(0);
        myTestCPU.cc.setZ(1);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(UNBRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setC(1);
        myTestCPU.cc.setZ(1);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(UNBRANCHED, myTestCPU.pc.intValue());
    }

    @Test
    public void testBLE() {
        final int PROGLOC = 0xB00;
        final int UNBRANCHED = 0xB00 + 2;
        final int BRANCHED = 0xB00 + 2 + 0x11;

        // Write instruction into memory
        myTestCPU.write(0xB00, 0x2F); // BLE
        myTestCPU.write(0xB01, 0x11);
        myTestCPU.cc.clear();

        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setV(0);
        myTestCPU.cc.setN(0);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(UNBRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setV(1);
        myTestCPU.cc.setN(0);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(BRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setV(0);
        myTestCPU.cc.setN(1);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(BRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setV(1);
        myTestCPU.cc.setN(1);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(UNBRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setZ(1);
        myTestCPU.cc.setV(0);
        myTestCPU.cc.setN(0);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(BRANCHED, myTestCPU.pc.intValue());
    }

    @Test
    public void testBLS() {
        final int PROGLOC = 0xB00;
        final int UNBRANCHED = 0xB00 + 2;
        final int BRANCHED = 0xB00 + 2 + 0x11;

        // Write instruction into memory
        myTestCPU.write(0xB00, 0x23); // BLS
        myTestCPU.write(0xB01, 0x11);
        myTestCPU.cc.clear();

        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setC(0);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(UNBRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setZ(1);
        myTestCPU.cc.setC(0);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(BRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setC(1);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(BRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setZ(1);
        myTestCPU.cc.setC(1);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(BRANCHED, myTestCPU.pc.intValue());
    }

    @Test
    public void testBLT() {
        final int PROGLOC = 0xB00;
        final int UNBRANCHED = 0xB00 + 2;
        final int BRANCHED = 0xB00 + 2 + 0x11;

        // Write instruction into memory
        myTestCPU.write(0xB00, 0x2D); // BLT
        myTestCPU.write(0xB01, 0x11);
        myTestCPU.cc.clear();

        myTestCPU.cc.setV(0);
        myTestCPU.cc.setN(0);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(UNBRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setV(1);
        myTestCPU.cc.setN(0);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(BRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setV(0);
        myTestCPU.cc.setN(1);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(BRANCHED, myTestCPU.pc.intValue());

        myTestCPU.cc.setV(1);
        myTestCPU.cc.setN(1);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(UNBRANCHED, myTestCPU.pc.intValue());
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
    public void testBSRForward() {
        int instructions[] = {
            0x8d, // BSR
            17 // Jump forward 17 bytes
        };
        loadProg(instructions);
        myTestCPU.s.set(0x300);
        myTestCPU.execute();
        // The size of the instruction is 2 bytes.
        assertEquals(LOCATION + 2 + 17, myTestCPU.pc.intValue());
        assertEquals(0x2fe, myTestCPU.s.intValue());
        assertEquals(0x22, myTestCPU.read(0x2ff));
        assertEquals(0x1e, myTestCPU.read(0x2fe));
    }

    @Test
    public void testLBSRbackward() {
        final int STACKADDR = 0x300;
        int instructions[] = {
            0x17, // LBSR
            0xF8,
            0xD5
        };
        loadProg(instructions);
        myTestCPU.s.set(STACKADDR);
        myTestCPU.execute();
        // The size of the instruction is 2 bytes.
        assertEquals(LOCATION + 3 - 0x072B, myTestCPU.pc.intValue());
        assertEquals(STACKADDR - 2, myTestCPU.s.intValue());
        assertEquals(LOCATION + 3, myTestCPU.read_word(STACKADDR - 2));
    }

    @Test
    public void testLBSRforward() {
        final int STACKADDR = 0x300;
        int instructions[] = {
            0x17, // LBSR
            0x03,
            0x72
        };
        loadProg(instructions);
        myTestCPU.s.set(STACKADDR);
        myTestCPU.execute();
        // The size of the instruction is 2 bytes.
        assertEquals(LOCATION + 3 + 0x0372, myTestCPU.pc.intValue());
        assertEquals(STACKADDR - 2, myTestCPU.s.intValue());
        assertEquals(LOCATION + 3, myTestCPU.read_word(STACKADDR - 2));
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

    @Test
    public void testLBCCForwards() {
        myTestCPU.cc.setC(0);
        myTestCPU.write_word(0xB00, 0x1024);
        myTestCPU.write_word(0xB02, 0x03FF);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
        assertEquals(0xB00 + 4 + 0x03FF, myTestCPU.pc.intValue());
    }

    @Test
    public void testLBEQForwards() {
        myTestCPU.cc.setZ(1);
        myTestCPU.write_word(0xB00, 0x1027);
        myTestCPU.write_word(0xB02, 0x03FF);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
        assertEquals(0xB00 + 4 + 0x03FF, myTestCPU.pc.intValue());
    }

    @Test
    public void testLBGEForwards() {
        myTestCPU.cc.setN(1);
        myTestCPU.cc.setV(1);
        myTestCPU.write_word(0xB00, 0x102C);
        myTestCPU.write_word(0xB02, 0x03FF);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
        assertEquals(0xB00 + 4 + 0x03FF, myTestCPU.pc.intValue());
    }

    @Test
    public void testJMPExtended() {
        myTestCPU.write(0xB00, 0x7E); // JMP
        myTestCPU.write_word(0xB01, 0x102C);
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
        assertEquals(0x102C, myTestCPU.pc.intValue());
    }
}
