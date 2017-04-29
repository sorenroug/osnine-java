package org.roug.osnine;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;

public class AddTest {

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
     * Add 0x02 to A=0x04.
     */
    @Test
    public void testADDANoCarry() {
        int instructions[] = {
            0x8B, // ADDA
            0x02, // value
        };
        loadProg(instructions);
        myTestCPU.cc.bit_c = 0;
        myTestCPU.a.set(0x04);
        myTestCPU.b.set(0x05);
        myTestCPU.execute();
        assertEquals(0x8B, myTestCPU.ir);
        assertEquals(LOCATION + 2, myTestCPU.pc.intValue());
        assertEquals(0x06, myTestCPU.a.intValue());
        assertEquals(0x05, myTestCPU.b.intValue());
        assertFalse(myTestCPU.cc.isSetH());
        assertFalse(myTestCPU.cc.isSetN());
        assertFalse(myTestCPU.cc.isSetZ());
        assertFalse(myTestCPU.cc.isSetV());
        assertFalse(myTestCPU.cc.isSetC());
    }

    /**
     * Add 0xFF to A=0x03.
     * The overflow (V) bit indicates signed two’s complement overflow, which occurs when the
     * sign bit differs from the carry bit after an arithmetic operation.
     */
    @Test
    public void testADDAWithCarry() {
        int instructions[] = {
            0x8B, // ADDA
            0xFF, // value
        };
        loadProg(instructions);
        myTestCPU.cc.bit_c = 0;
        myTestCPU.a.set(0x03);
        myTestCPU.execute();
        assertEquals(0x02, myTestCPU.a.intValue());
        assertFalse(myTestCPU.cc.isSetN());
        assertTrue(myTestCPU.cc.isSetV());
        assertTrue(myTestCPU.cc.isSetC());
    }

    /**
     * Add 0x02B0 to D=0x0405.
     */
    @Test
    public void testADDDNoCarry() {
        int instructions[] = {
            0xC3, // ADDD
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
     * Add value of SP=0x92FC to D=00C5.
     */
    @Test
    public void testADDDstackpointer() {
        int instructions[] = {
            0xE3, // ADDD
            0xE4  // ,SP
        };
        loadProg(instructions);
        myTestCPU.cc.bit_c = 0;
        myTestCPU.s.set(0x1202);
        myTestCPU.a.set(0x00);
        myTestCPU.b.set(0xC5);
	myTestCPU.write_word(0x1202, 0x92FC);
        myTestCPU.execute();
        assertEquals(LOCATION + 2, myTestCPU.pc.intValue());
        assertEquals(0x93c1, myTestCPU.d.intValue());
        assertEquals(0, myTestCPU.cc.bit_c);
    }

    /**
     * Increment register A.
     */
    @Test
    public void testINCA() {
        myTestCPU.cc.clear();
        myTestCPU.a.set(0x32);
        myTestCPU.write(0xB00, 0x4C);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x33, myTestCPU.a.intValue());
	assertEquals(0, myTestCPU.cc.getN());
	assertEquals(0, myTestCPU.cc.getZ());
	assertEquals(0, myTestCPU.cc.getV());
	assertEquals(0, myTestCPU.cc.getC());

        // Test 0x7F - special case
        myTestCPU.a.set(0x7F);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x80, myTestCPU.a.intValue());
	assertEquals(1, myTestCPU.cc.getN());
	assertEquals(0, myTestCPU.cc.getZ());
	assertEquals(1, myTestCPU.cc.getV());
	assertEquals(0, myTestCPU.cc.getC());

        // Test 0xFF - special case
        myTestCPU.a.set(0xFF);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x00, myTestCPU.a.intValue());
	assertEquals(0, myTestCPU.cc.getN());
	assertEquals(1, myTestCPU.cc.getZ());
	assertEquals(0, myTestCPU.cc.getV());
	assertEquals(0, myTestCPU.cc.getC());
    }


}
