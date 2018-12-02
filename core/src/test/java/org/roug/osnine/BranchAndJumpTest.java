package org.roug.osnine;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;

public class BranchAndJumpTest extends Framework {

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
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(BRANCHED);

        myTestCPU.cc.setC(1);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(UNBRANCHED);
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
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(BRANCHED);

        myTestCPU.cc.setV(1);
        myTestCPU.cc.setN(0);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(UNBRANCHED);

        myTestCPU.cc.setV(0);
        myTestCPU.cc.setN(1);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(UNBRANCHED);

        myTestCPU.cc.setV(1);
        myTestCPU.cc.setN(1);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(BRANCHED);
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
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(BRANCHED);

        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setV(1);
        myTestCPU.cc.setN(0);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(UNBRANCHED);

        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setV(0);
        myTestCPU.cc.setN(1);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(UNBRANCHED);

        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setV(1);
        myTestCPU.cc.setN(1);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(BRANCHED);
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
        setCC(CC.Zmask);
        myTestCPU.execute();
        // The size of the instruction is 2 bytes.
        assertPC(LOCATION + 2);
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
        setCC(CC.Nmask + CC.Vmask);
        myTestCPU.execute();
        // The size of the instruction is 2 bytes.
        assertPC(LOCATION + 2 + 0x17);
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
        setCC(CC.Cmask);
        myTestCPU.execute();
        // The size of the instruction is 2 bytes.
        assertPC(LOCATION + 2 + 0x17);
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
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(BRANCHED);

        myTestCPU.cc.setC(1);
        myTestCPU.cc.setZ(0);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(UNBRANCHED);

        myTestCPU.cc.setC(0);
        myTestCPU.cc.setZ(1);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(UNBRANCHED);

        myTestCPU.cc.setC(1);
        myTestCPU.cc.setZ(1);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(UNBRANCHED);
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
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(UNBRANCHED);

        myTestCPU.cc.setV(1);
        myTestCPU.cc.setN(0);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(BRANCHED);

        myTestCPU.cc.setV(0);
        myTestCPU.cc.setN(1);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(BRANCHED);

        myTestCPU.cc.setV(1);
        myTestCPU.cc.setN(1);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(UNBRANCHED);

        myTestCPU.cc.setZ(1);
        myTestCPU.cc.setV(0);
        myTestCPU.cc.setN(0);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(BRANCHED);
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
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(UNBRANCHED);

        myTestCPU.cc.setZ(1);
        myTestCPU.cc.setC(0);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(BRANCHED);

        myTestCPU.cc.setZ(0);
        myTestCPU.cc.setC(1);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(BRANCHED);

        myTestCPU.cc.setZ(1);
        myTestCPU.cc.setC(1);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(BRANCHED);
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
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(UNBRANCHED);

        myTestCPU.cc.setV(1);
        myTestCPU.cc.setN(0);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(BRANCHED);

        myTestCPU.cc.setV(0);
        myTestCPU.cc.setN(1);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(BRANCHED);

        myTestCPU.cc.setV(1);
        myTestCPU.cc.setN(1);
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(UNBRANCHED);
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
        assertPC(LOCATION + 2 + 17);
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
        assertPC(LOCATION + 2 - 86);
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
        assertPC(LOCATION + 2 - 86);
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
        assertPC(LOCATION + 2 + 17);
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
        assertPC(LOCATION + 3 - 0x072B);
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
        assertPC(LOCATION + 3 + 0x0372);
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
        writeword(0x205, 0x03ff);
        // Set register D
        myTestCPU.d.set(0x105);
        // Set register Y to point to that location minus 5
        setY(0x200);
        // Set register S to point to 0x915
        myTestCPU.s.set(0x915);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0xAD);
        myTestCPU.write(0xB01, 0xAB);
        myTestCPU.write(0xB02, 0x11); // Junk
        myTestCPU.write(0xB03, 0x22); // Junk
        setPC(0xB00);
        myTestCPU.cc.clear();
        myTestCPU.execute();
        chkCC_A_B_DP_X_Y_S_U(0, 0x01, 0x05, 0, 0, 0x200, 0x913, 0);
        assertEquals(0x200, myTestCPU.y.intValue());
        assertEquals(0x105, myTestCPU.d.intValue());
        assertEquals(0x913, myTestCPU.s.intValue());
        assertPC(0x305);
    }

    @Test
    public void testLBRAForwards() {
        myTestCPU.write(0xB00, 0x16);
        writeword(0xB01, 0x03FF);
        setPC(0xB00);
	myTestCPU.execute();
        assertPC(0xB00 + 3 + 0x03FF);
    }

    @Test
    public void testLBRABackwards() {
        myTestCPU.write(0x1B00, 0x16);
        writeword(0x1B01, 0xF333);
        setPC(0x1B00);
	myTestCPU.execute();
        assertPC(0x1B00 + 3 - 0xCCD);
    }

    @Test
    public void testLBRNForwards() {
        writeword(0xB00, 0x1021);
        writeword(0xB02, 0x03FF);
        setPC(0xB00);
	myTestCPU.execute();
        assertPC(0xB00 + 4);
    }

    @Test
    public void testLBCCForwards() {
        myTestCPU.cc.setC(0);
        writeword(0xB00, 0x1024);
        writeword(0xB02, 0x03FF);
        setPC(0xB00);
	myTestCPU.execute();
        assertPC(0xB00 + 4 + 0x03FF);
    }

    @Test
    public void testLBEQForwards() {
        myTestCPU.cc.setZ(1);
        writeword(0xB00, 0x1027);
        writeword(0xB02, 0x03FF);
        setPC(0xB00);
	myTestCPU.execute();
        assertPC(0xB00 + 4 + 0x03FF);
    }

    @Test
    public void testLBGEForwards() {
        myTestCPU.cc.setN(1);
        myTestCPU.cc.setV(1);
        writeword(0xB00, 0x102C);
        writeword(0xB02, 0x03FF);
        setPC(0xB00);
	myTestCPU.execute();
        assertPC(0xB00 + 4 + 0x03FF);
    }

    @Test
    public void testJMPExtended() {
        myTestCPU.write(0xB00, 0x7E); // JMP
        writeword(0xB01, 0x102C);
        setPC(0xB00);
	myTestCPU.execute();
        assertPC(0x102C);
    }

    @Test
    public void testRTS() {
        myTestCPU.s.set(0x300);
        writeword(0x300, 0x102C); // Write return address
        myTestCPU.write(0xB00, 0x39); // RTS
        setPC(0xB00);
        myTestCPU.execute();
        assertPC(0x102C);
        assertEquals(0x302, myTestCPU.s.intValue());
    }
}
