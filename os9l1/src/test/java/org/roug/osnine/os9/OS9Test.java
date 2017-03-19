package org.roug.osnine.os9;

import java.io.IOException;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import org.junit.Test;

/**
 * Test memory allocations for programs and data.
 */
public class OS9Test {

    /**
     * Show the bitmap as hex numbers.
     */
    private void showbm(OS9 tInstance) {
	for(int i = tInstance.BITMAP_START; i < tInstance.BITMAP_START + 32; i++) {
	    System.out.printf("%02x", tInstance.read(i));
	}
	System.out.printf("\n");
    }

    /**
     * Parse Hello world, the way the echo program sees it.
     */
    @Test
    public void testF_CMPNAM() {
        OS9 myTestOs = new OS9();

	byte helloWorldX[] = { 0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x20, 0x77, 0x6f, 0x72, 0x6c, 0x64 };
	for (int i = 0; i < helloWorldX.length; i++) {
	    myTestOs.write(i + 0x100, helloWorldX[i]);
	}

	// Hello world with bit 7 set on 'd'
	byte hellowWorldY[] = { 0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x20, 0x77, 0x6f, 0x72, 0x6c, -28 };  // -28 = 0xe4
	for (int i = 0; i < hellowWorldY.length; i++) {
	    myTestOs.write(i + 0x200, hellowWorldY[i]);
	}

	myTestOs.cc.setC(1);
	myTestOs.x.set(0x100);
	myTestOs.b.set(helloWorldX.length);
	myTestOs.y.set(0x200);
	myTestOs.f_cmpnam();
	// Expected: X -> 'H', Y -> ' ' and B = Y-X
	assertEquals(0x100, myTestOs.x.intValue());
	assertEquals(0x200, myTestOs.y.intValue());
	assertEquals(helloWorldX.length, myTestOs.b.intValue());
	assertEquals(0, myTestOs.cc.getC());

	// Test that "Hallo" is different from "Hellow World"
	byte halloX[] = { 0x48, 0x61, 0x6c, 0x6c, 0x6f }; // Hallo
	assertEquals(5, halloX.length);
	for (int i = 0; i < halloX.length; i++) {
	    myTestOs.write(i + 0x100, halloX[i]);
	}
	myTestOs.cc.setC(0);
	myTestOs.b.set(halloX.length);
	myTestOs.f_cmpnam();
	assertEquals(1, myTestOs.cc.getC());
    }

    /**
     * The example shown in the OS-9 System Programmer's Manual
     */
    @Test
    public void testF_PRSNAM1() {
        OS9 myTestOs = new OS9();
	String pathname = "/D0/FILE";

	loadProg(pathname, myTestOs);
	myTestOs.x.set(0x100);
	myTestOs.f_prsnam();
	assertEquals(0x101, myTestOs.x.intValue() );
	assertEquals(0x103, myTestOs.y.intValue() );
	assertEquals(2, myTestOs.b.intValue() );
    }

    /**
     * Parse Hello world, the way the echo program sees it.
     */
    @Test
    public void testF_PRSNAM2() {
        OS9 myTestOs = new OS9();
	String pathname = "Hello world\r";

	loadProg(pathname, myTestOs);
	myTestOs.x.set(0x100);
	myTestOs.f_prsnam();
	// Expected: X -> 'H', Y -> ' ' and B = Y-X
	assertEquals( 0x100, myTestOs.x.intValue() );
	assertEquals( 0x105, myTestOs.y.intValue() );
	assertEquals( 5, myTestOs.b.intValue() );

	// Deal with the space. Must increment x with one
	myTestOs.x.set(0x105);
	myTestOs.f_prsnam();
	assertEquals( 0x106, myTestOs.x.intValue() );
	assertEquals( 0x105, myTestOs.y.intValue() );
	assertEquals( ErrCodes.E_BNam, myTestOs.b.intValue() );
	// Parse the 'world'
	myTestOs.f_prsnam();
	assertEquals( 0x106, myTestOs.x.intValue() );
	assertEquals( 0x10B, myTestOs.y.intValue() );
	assertEquals( 5, myTestOs.b.intValue() );
    }

    /**
     * Load some data in to 0x100 and up.
     */
    private void loadProg(String instructions, OS9 myTestOs) {
	for (int i = 0; i < instructions.length(); i++) {
	    myTestOs.write(i + 0x100, instructions.codePointAt(i));
	}
    }

    /**
     * Request memory 8 times in increasing amounts.
     */
    @Test
    public void testF_SRQMEM() {
        // Location
        int expectedU[] = {0x0200, 0x0600, 0x0C00, 0x1400, 0x1E00, 0x2A00, 0x3800};
        // Amount reserved
        int expectedD[] = {0x0200, 0x0400, 0x0600, 0x0800, 0x0A00, 0x0C00, 0x0E00};
        OS9 tInstance = new OS9();
        int topMem = tInstance.read_word(DPConst.D_MLIM);
        tInstance.x.set(0);
        tInstance.y.set(0);
        tInstance.a.set(0);
        //showbm(tInstance);
	for (int i = 1; i < 8; i++) {
	    tInstance.d.set(i * 512);
	    tInstance.f_srqmem();
            assertEquals(expectedU[i - 1], topMem - tInstance.u.intValue());
            assertEquals(expectedD[i - 1], tInstance.d.intValue());
            assertEquals(0x0000, tInstance.x.intValue());
	    //System.out.printf("X=%04x, U=%04x, D=%04x\n",tInstance.x.intValue(), tInstance.u.intValue(), tInstance.d.intValue());
	    //showbm(tInstance);
	}
	tInstance.d.set(0x0800);
	tInstance.u.set(0xec00);
	tInstance.f_srtmem();
	//System.out.printf("X=%04x, U=%04x, D=%04x\n",tInstance.x.intValue(), tInstance.u.intValue(), tInstance.d.intValue());
        assertEquals(0xEC00, tInstance.u.intValue());
        assertEquals(0x0800, tInstance.d.intValue());
        assertEquals(0x0000, tInstance.x.intValue());
	//showbm(tInstance);

//      int result = tInstance.read(0x100);
//      assertEquals(0xAA, result);
    }

    /**
     * Load module and increase memory.
     */
    @Test
    public void extendDummyMod() {
        OS9 cpu = new OS9();
        String driveLocation = System.getProperty("outputDirectory");
        cpu.setDebugCalls(1);
        cpu.addDevice(new DevUnix("/dd", driveLocation)); // Default drive
        cpu.setInitialCXD("/dd");
        assertFalse(cpu.cc.isSetC());
        cpu.loadmodule("dummymodule.mod");
        cpu.d.set(0x0600);
        cpu.f_mem();
        assertEquals(0x0600, cpu.d.intValue());
        assertFalse(cpu.cc.isSetC());
        // Try to ask with D=0
        cpu.d.set(0x0);
        cpu.f_mem();
        assertEquals(0x0600, cpu.d.intValue());
    }

    /**
     * Test allocation.
     */
    @Test
    public void bitAllocation() {   
        int result;
        OS9 tInstance = new OS9();
	tInstance.x.set(tInstance.BITMAP_START);
	
        // OS9 marks the first 8 pages as used - i.e. one byte
        assertEquals(0xff, tInstance.read(tInstance.BITMAP_START));
        assertEquals(0x00, tInstance.read(tInstance.BITMAP_START + 1));

        tInstance.d.set(16);
	tInstance.y.set(1);
	tInstance.f_allbit();
        result = tInstance.read(tInstance.BITMAP_START + 16 / 8);
        //System.out.printf("Memory: %02x\n", result);
        assertEquals(0x80, result);

	tInstance.d.set(27);
	tInstance.y.set(12);
	tInstance.f_allbit();
        result = tInstance.read(tInstance.BITMAP_START + 27 / 8);
        assertEquals(0x1f, result);
        //System.out.printf("Memory: %02x\n", result);
        result = tInstance.read(tInstance.BITMAP_START + (27 / 8) + 1);
        assertEquals(0xfe, result);
	//showbm(tInstance);

	tInstance.d.set(0);
	tInstance.y.set(8);
	tInstance.f_allbit();
        result = tInstance.read(tInstance.BITMAP_START);
        assertEquals(0xff, result);
	//showbm(tInstance);
    }

    @Test
    public void testF_DELBIT() {   
        int result;
        OS9 tInstance = new OS9();
	tInstance.x.set(tInstance.BITMAP_START);
        
        // Paint a lot
	tInstance.d.set(0xb0);
	tInstance.y.set(0xff);
	tInstance.f_allbit();

        // Unpaint 8 bits.
	tInstance.d.set(0xba);
	tInstance.y.set(8);
	tInstance.f_delbit();
        result = tInstance.read(tInstance.BITMAP_START + 0xba / 8);
        assertEquals(0xc0, result);
        result = tInstance.read(tInstance.BITMAP_START + (0xba / 8) + 1);
        assertEquals(0x3f, result);
	//showbm(tInstance);
    }

    /**
     * Test the allocation of 64-byte process/path descriptors.
     */
    @Test
    public void testF_ALL64() {
	OS9 myTestOs = new OS9();

	int expected_y[] = { 0xf940,  0xf980, 0xf9c0, 0xf800, 0xf840, 0xf880, 0xf8c0, 0xf700 };

	myTestOs.x.set(0);
	for (int i = 0; i < 8; i++) {
	    myTestOs.f_all64();
            assertEquals(0xf900, myTestOs.x.intValue());
            assertEquals(expected_y[i], myTestOs.y.intValue());
            assertEquals(i + 1, myTestOs.a.intValue());
	    myTestOs.write(myTestOs.y.intValue(), 1);  // Make the page dirty
	}
    }

    /**
     * Add processes to the active process queue.
     */
    @Test
    public void testF_APROC() {
	OS9 myTestOs = new OS9();
	myTestOs.x.set(0);
	myTestOs.f_all64();
	assertEquals(0xf900, myTestOs.x.intValue());
	assertEquals(0xf940, myTestOs.y.intValue());
	myTestOs.x.set(myTestOs.y.intValue());
	myTestOs.f_aproc();
    }

    /**
     * Test the search in a bitmap.
     *
     *  - INPUT:
     *   - (X) = Beginning address of a bit map.
     *   - (D) = Beginning bit number.
     *   - (Y) = Bit count (free bit block size).
     *   - (U) = End of bit map address.
     *  - OUTPUT:
     *   - (D) = Beginning bit number.
     *   - (Y) = Bit count.
     */
    @Test
    public void testF_SCHBIT() {
	OS9 myTestOs = new OS9();
	final int bmStart = 0x200;
	final int bmEnd = 0x300;

	// Initialise the bitmap to zeros
	for (int i = bmStart; i < bmEnd; i++) {
	    myTestOs.write(i, 0);
	}
	myTestOs.write(bmStart, 0xff); // mark some bytes as taken
	myTestOs.x.set(bmStart);
	myTestOs.u.set(bmEnd);
	myTestOs.d.set(11); // Start a bit 11 
	myTestOs.y.set(10); // We need 10 bits
	myTestOs.f_schbit();
	assertEquals(10,  myTestOs.y.intValue());
	assertEquals(11,  myTestOs.d.intValue());
	assertEquals(0, myTestOs.cc.getC());

	myTestOs.d.set(5); // Start a bit 5 (already allocated)
	myTestOs.y.set(10); // We need 10 bits
	myTestOs.f_schbit();
	assertEquals(10,  myTestOs.y.intValue());
	assertEquals(8,  myTestOs.d.intValue());
	assertEquals(0, myTestOs.cc.getC());

	// Test error condition
	// Allocate everything
	for (int i = bmStart; i < bmEnd; i++) {
	    myTestOs.write(i, 0xff);
	}
	myTestOs.write_word(bmStart+0x32, 0x0); // mark 16 bits free
	myTestOs.write(bmStart+0x39, 0x0); // mark 8 bits free later
	myTestOs.d.set(0); // Start a bit 0 (already allocated)
	myTestOs.y.set(20); // We need 20 bits
	myTestOs.f_schbit();
	assertEquals(1, myTestOs.cc.getC());
	assertEquals(400,  myTestOs.d.intValue());
	assertEquals(16,  myTestOs.y.intValue()); // Largest available block is 16
    }

}
