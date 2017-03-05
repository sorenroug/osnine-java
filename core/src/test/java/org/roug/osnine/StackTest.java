package org.roug.osnine;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import org.junit.Before;
import org.junit.Test;

public class StackTest {

    private MC6809 myTestCPU;

    @Before
    public void setUp() {
        myTestCPU = new MC6809(0x2000);
    }


    /**
     * Test pushing all registers to the S stack.
     */
    @Test
    public void testPSHSall() {
	// Set register S to point to 517
	myTestCPU.s.set(517);
        // Set the registers we want to push
	myTestCPU.cc.set(0x0F);
        myTestCPU.a.set(1);
        myTestCPU.b.set(2);
        myTestCPU.dp.set(3);
        myTestCPU.x.set(0x0405);
        myTestCPU.y.set(0x0607);
        myTestCPU.u.set(0x0809);

        myTestCPU.pc.set(0xB00);
	myTestCPU.write(0xB00, 0x34); // PSHS
	myTestCPU.write(0xB01, 0xFF); // PC,U,Y,X,DP,B,A,CC
	myTestCPU.execute();

	assertEquals(0xB02, myTestCPU.pc.intValue());
	assertEquals(0x0F, myTestCPU.cc.intValue());
        assertEquals(0x01, myTestCPU.a.intValue());
        assertEquals(0x02, myTestCPU.b.intValue());
        assertEquals(517 - 12, myTestCPU.s.intValue());
        assertEquals(0x02, myTestCPU.read(517 - 1)); // Check that PC-low is pushed.
        assertEquals(0x0B, myTestCPU.read(517 - 2)); // Check that PC-high is pushed.
        assertEquals(0x09, myTestCPU.read(517 - 3)); // Check that U-low is pushed.
        assertEquals(0x08, myTestCPU.read(517 - 4)); // Check that U-high is pushed.
        assertEquals(0x07, myTestCPU.read(517 - 5)); // Check that Y-low is pushed.
        assertEquals(0x06, myTestCPU.read(517 - 6)); // Check that Y-high is pushed.
        assertEquals(0x05, myTestCPU.read(517 - 7)); // Check that X-low is pushed.
        assertEquals(0x04, myTestCPU.read(517 - 8)); // Check that X-high is pushed.
        assertEquals(0x03, myTestCPU.read(517 - 9)); // Check that DP is pushed.
        assertEquals(0x02, myTestCPU.read(517 - 10)); // Check that B is pushed.
        assertEquals(0x01, myTestCPU.read(517 - 11)); // Check that A is pushed.
        assertEquals(0x0F, myTestCPU.read(517 - 12)); // Check that CC is pushed.
    }

    /**
     * Test pushing all registers to the U stack.
     */
    @Test
    public void testPSHUall() {
	// Set register S to point to 517
	myTestCPU.u.set(517);
        // Set the registers we want to push
	myTestCPU.cc.set(0x0F);
        myTestCPU.a.set(0x01);
        myTestCPU.b.set(0x02);
        myTestCPU.dp.set(0x03);
        myTestCPU.x.set(0x0405);
        myTestCPU.y.set(0x0607);
        myTestCPU.s.set(0x0809);

        myTestCPU.pc.set(0xB00);
	myTestCPU.write(0xB00, 0x36); // PSHU
	myTestCPU.write(0xB01, 0xFF); // PC,U,Y,X,DP,B,A,CC
	myTestCPU.execute();

	assertEquals(0xB02, myTestCPU.pc.intValue());
	assertEquals(0x0F, myTestCPU.cc.intValue());
        assertEquals(1, myTestCPU.a.intValue());
        assertEquals(2, myTestCPU.b.intValue());
        assertEquals(517 - 12, myTestCPU.u.intValue());
        assertEquals(0x02, myTestCPU.read(517 - 1)); // Check that PC-low is pushed.
        assertEquals(0x0B, myTestCPU.read(517 - 2)); // Check that PC-high is pushed.
        assertEquals(0x09, myTestCPU.read(517 - 3)); // Check that S-low is pushed.
        assertEquals(0x08, myTestCPU.read(517 - 4)); // Check that S-high is pushed.
        assertEquals(0x07, myTestCPU.read(517 - 5)); // Check that Y-low is pushed.
        assertEquals(0x06, myTestCPU.read(517 - 6)); // Check that Y-high is pushed.
        assertEquals(0x05, myTestCPU.read(517 - 7)); // Check that X-low is pushed.
        assertEquals(0x04, myTestCPU.read(517 - 8)); // Check that X-high is pushed.
        assertEquals(0x03, myTestCPU.read(517 - 9)); // Check that DP is pushed.
        assertEquals(0x02, myTestCPU.read(517 - 10)); // Check that B is pushed.
        assertEquals(0x01, myTestCPU.read(517 - 11)); // Check that A is pushed.
        assertEquals(0x0F, myTestCPU.read(517 - 12)); // Check that CC is pushed.
    }

    /**
     * Test the PULS - Pull all registers from Hardware Stack.
     * The stack grows downwards, and this means that when you PULL, the
     * stack pointer is increased.
     */
    @Test
    public void testPULSall() {
        myTestCPU.write(512 - 12, 0x00);  // Store CC
        myTestCPU.write(512 - 11, 0x11);  // Store A
        myTestCPU.write(512 - 10, 0x12);  // Store B
        myTestCPU.write(512 - 9, 0x13);  // Store DP
	myTestCPU.write_word(512 - 8, 0x9141); // Set up stored X value
	myTestCPU.write_word(512 - 6, 0xa142); // Set up stored Y value
	myTestCPU.write_word(512 - 4, 0xb140); // Set up stored U value
	myTestCPU.write_word(512 - 2, 0x04ff); // Set up stored PC value
	myTestCPU.y.set(0x1115); // Set Y to something benign
	myTestCPU.s.set(500); // Set register S to point to 500
	myTestCPU.cc.set(0x0f);
	// Two bytes of instruction
	myTestCPU.write(0xB00, 0x35); // PULS
	myTestCPU.write(0xB01, 0xFF); // PC,U,Y,X,DP,B,A,CC
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0x00, myTestCPU.cc.intValue());
	assertEquals(0x11, myTestCPU.a.intValue());
	assertEquals(0x12, myTestCPU.b.intValue());
	assertEquals(0x13, myTestCPU.dp.intValue());
	assertEquals(0x9141, myTestCPU.x.intValue());
	assertEquals(0xa142, myTestCPU.y.intValue());
	assertEquals(0xb140, myTestCPU.u.intValue());
	assertEquals(0x04ff, myTestCPU.pc.intValue());
    }

    /**
     * Test the PULU - Pull all registers from Hardware Stack.
     * The stack grows downwards, and this means that when you PULL, the
     * stack pointer is increased.
     */
    @Test
    public void testPULUall() {
        myTestCPU.write(512 - 12, 0x00);  // Store CC
        myTestCPU.write(512 - 11, 0x11);  // Store A
        myTestCPU.write(512 - 10, 0x12);  // Store B
        myTestCPU.write(512 - 9, 0x13);  // Store DP
	myTestCPU.write_word(512 - 8, 0x9141); // Set up stored X value
	myTestCPU.write_word(512 - 6, 0xa142); // Set up stored Y value
	myTestCPU.write_word(512 - 4, 0xb140); // Set up stored S value
	myTestCPU.write_word(512 - 2, 0x04ff); // Set up stored PC value
	myTestCPU.y.set(0x1115); // Set Y to something benign
	myTestCPU.u.set(500); // Set register U to point to 500
	myTestCPU.cc.set(0x0f);
	// Two bytes of instruction
	myTestCPU.write(0xB00, 0x37); // PULU
	myTestCPU.write(0xB01, 0xFF); // PC,U,Y,X,DP,B,A,CC
        myTestCPU.pc.set(0xB00);
	myTestCPU.execute();
	assertEquals(0x00, myTestCPU.cc.intValue());
	assertEquals(0x11, myTestCPU.a.intValue());
	assertEquals(0x12, myTestCPU.b.intValue());
	assertEquals(0x13, myTestCPU.dp.intValue());
	assertEquals(0x9141, myTestCPU.x.intValue());
	assertEquals(0xa142, myTestCPU.y.intValue());
	assertEquals(0xb140, myTestCPU.s.intValue());
	assertEquals(0x04ff, myTestCPU.pc.intValue());
    }

    /**
     * Test the PULS - Pull registers from Hardware Stack - instruction.
     * The stack grows downwards, and this means that when you PULL, the
     * stack pointer is increased.
     */
    @Test
    public void testPULSregY() {
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

}
