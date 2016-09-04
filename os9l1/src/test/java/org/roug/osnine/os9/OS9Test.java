package org.roug.osnine.os9;

import java.io.IOException;
import static org.junit.Assert.assertEquals;
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
	for(int i = 1; i < 8; i++) {
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
     * Test allocation.
     */
    @Test
    public void bitAllocation() {   
        int result;
        OS9 tInstance = new OS9();
	tInstance.x.set(tInstance.BITMAP_START);
	
        tInstance.d.set(0);
	tInstance.y.set(1);
	tInstance.f_allbit();
        result = tInstance.read(tInstance.BITMAP_START);
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
	for(int i = 0; i < 8; i++) {
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

}
