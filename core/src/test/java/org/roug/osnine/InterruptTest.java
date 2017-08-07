package org.roug.osnine;

import static org.junit.Assert.assertEquals;
import org.junit.Before;
import org.junit.Test;

public class InterruptTest {

    private MC6809 myTestCPU;

    @Before
    public void setUp() {
        myTestCPU = new MC6809(0x2000);
    }


    /**
     * Test pushing all registers to the S stack.
     */
    @Test
    public void raiseSimpleIRQ() {
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

	myTestCPU.write_word(MC6809.IRQ_ADDR, 0x1234); // Set IRQ vector
	myTestCPU.write(0x1234, 0x3B); // RTI
        myTestCPU.pc.set(0xB00);
	myTestCPU.write(0xB00, 0x12); // NOP
	myTestCPU.write(0xB01, 0x12); // NOP
        myTestCPU.signalIRQ(true);
	myTestCPU.execute();
	assertEquals(0x1234, myTestCPU.pc.intValue());

	myTestCPU.execute();
	assertEquals(0xB01, myTestCPU.pc.intValue());
	assertEquals(0x8F, myTestCPU.cc.intValue()); // Flag E is set by IRQ
        assertEquals(0x01, myTestCPU.a.intValue());
        assertEquals(0x02, myTestCPU.b.intValue());
        assertEquals(517, myTestCPU.s.intValue());
        assertEquals(0x01, myTestCPU.read(517 - 1)); // Check that PC-low was pushed.
        assertEquals(0x0B, myTestCPU.read(517 - 2)); // Check that PC-high was pushed.
        assertEquals(0x09, myTestCPU.read(517 - 3)); // Check that U-low was pushed.
        assertEquals(0x08, myTestCPU.read(517 - 4)); // Check that U-high was pushed.
        assertEquals(0x07, myTestCPU.read(517 - 5)); // Check that Y-low was pushed.
        assertEquals(0x06, myTestCPU.read(517 - 6)); // Check that Y-high was pushed.
        assertEquals(0x05, myTestCPU.read(517 - 7)); // Check that X-low was pushed.
        assertEquals(0x04, myTestCPU.read(517 - 8)); // Check that X-high was pushed.
        assertEquals(0x03, myTestCPU.read(517 - 9)); // Check that DP was pushed.
        assertEquals(0x02, myTestCPU.read(517 - 10)); // Check that B was pushed.
        assertEquals(0x01, myTestCPU.read(517 - 11)); // Check that A was pushed.
        assertEquals(0x8F, myTestCPU.read(517 - 12)); // Check that CC was pushed.
    }

    /**
     * Test pushing all registers to the S stack.
     */
    @Test
    public void callCWAI() {
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

	myTestCPU.write_word(MC6809.IRQ_ADDR, 0x1234); // Set IRQ vector
	myTestCPU.write(0x1234, 0x3B); // RTI
        myTestCPU.pc.set(0xB00);
	myTestCPU.write(0xB00, 0x3C); // CWAI
	myTestCPU.write(0xB01, 0x12); // value for CC AND
	myTestCPU.write(0xB02, 0x12); // NOP
        myTestCPU.signalIRQ(true);
	myTestCPU.execute();
	assertEquals(0x1234, myTestCPU.pc.intValue());
	myTestCPU.execute();
	assertEquals(0xB02, myTestCPU.pc.intValue());
	assertEquals(0x82, myTestCPU.cc.intValue()); // Flag E is set by CWAI
        assertEquals(0x02, myTestCPU.read(517 - 1)); // Check that PC-low was pushed.
        assertEquals(0x0B, myTestCPU.read(517 - 2)); // Check that PC-high was pushed.
        assertEquals(0x09, myTestCPU.read(517 - 3)); // Check that U-low was pushed.
        assertEquals(0x08, myTestCPU.read(517 - 4)); // Check that U-high was pushed.
        assertEquals(0x07, myTestCPU.read(517 - 5)); // Check that Y-low was pushed.
        assertEquals(0x06, myTestCPU.read(517 - 6)); // Check that Y-high was pushed.
        assertEquals(0x05, myTestCPU.read(517 - 7)); // Check that X-low was pushed.
        assertEquals(0x04, myTestCPU.read(517 - 8)); // Check that X-high was pushed.
        assertEquals(0x03, myTestCPU.read(517 - 9)); // Check that DP was pushed.
        assertEquals(0x02, myTestCPU.read(517 - 10)); // Check that B was pushed.
        assertEquals(0x01, myTestCPU.read(517 - 11)); // Check that A was pushed.
        assertEquals(0x82, myTestCPU.read(517 - 12)); // Check that CC was pushed.


	myTestCPU.execute();
    }
}
