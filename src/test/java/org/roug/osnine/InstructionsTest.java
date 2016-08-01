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
        myTestCPU.cc.clearCC();
    }

    private void setCCABDPXYSU(int cc, int a, int b, int dp, int x, int y, int s, int u) {
        myTestCPU.cc.set(cc);
        myTestCPU.a.set(a);
        myTestCPU.b.set(b);
        myTestCPU.dp.set(dp);
        myTestCPU.x.set(x);
        myTestCPU.y.set(y);
        myTestCPU.s.set(s);
        myTestCPU.u.set(u);
    }

    private void verifyCCABDPXYSU(int cc, int a, int b, int dp, int x, int y, int s, int u) {
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
        setCCABDPXYSU(0, 0, 0xCE, 0, 0x8006, 0, 0, 0);
//      myTestCPU.cc.bit_c = 0;
//      myTestCPU.x.set(0x8006);
//      myTestCPU.b.set(0xCE);
        myTestCPU.execute();
        assertEquals(0x3a, myTestCPU.ir);
        assertEquals(LOCATION + 1, myTestCPU.pc);
        verifyCCABDPXYSU(0, 0, 0xCE, 0, 0x80D4, 0, 0, 0);
//      assertEquals(0x80D4, myTestCPU.x.intValue());
//      assertEquals(0, myTestCPU.cc.bit_c);
    }


    @Test
    public void testADCANoCarry() {
        int instructions[] = {
            0x89, // ADCA
            0x02  // value
        };
        loadProg(instructions);
        myTestCPU.cc.bit_c = 0;
        myTestCPU.a.set(5);
        myTestCPU.execute();
        assertEquals(0x89, myTestCPU.ir);
        assertEquals(LOCATION + 2, myTestCPU.pc);
        assertEquals(7, myTestCPU.a.intValue());
        assertEquals(0, myTestCPU.cc.bit_c);
    }


    @Test
    public void testADCAWithCarry() {
        int instructions[] = {
            0x89, // ADCA
            0x22  // value
        };
        loadProg(instructions);
        myTestCPU.cc.bit_c = 1;
        myTestCPU.a.set(0x14);
        myTestCPU.execute();
        assertEquals(0x89, myTestCPU.ir);
        assertEquals(LOCATION + 2, myTestCPU.pc);
        assertEquals(0x37, myTestCPU.a.intValue());
        assertEquals(0, myTestCPU.cc.bit_c);
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
}
