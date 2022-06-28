package org.roug.usim.z80;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;

public class BitSetResetTest extends Framework {

    /* BIT b, r
    */
    @Test
    public void bit2RegisterB() {
        myTestCPU.registerB.set(0xFB);
        writeSeq(0x0B00, 0xCB, 0x50);
        execSeq(0xB00, 0xB02);
        assertEquals(0xFB, myTestCPU.registerB.get());
        assertTrue(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
    }

    /* BIT b, (IX+d)
    */
    @Test
    public void bitRegisterIXd() {
        // Test bit 5
        myTestCPU.registerIX.set(0x1000);
        writeSeq(0x0B00, 0xDD, 0xCB, 0x50, 0x6E);
        myTestCPU.write(0x1050, 0x25);
        execSeq(0xB00, 0xB04);
        assertFalse(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());

        // Test bit 6
        myTestCPU.registerIX.set(0x1000);
        writeSeq(0x0B00, 0xDD, 0xCB, 0x50, 0x76);
        myTestCPU.write(0x1050, 0x25);
        execSeq(0xB00, 0xB04);
        assertTrue(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());

    }

    /* SET b, r
    */
    @Test
    public void set7RegisterB() {
        myTestCPU.registerB.set(0x0B);
        writeSeq(0x0B00, 0xCB, 0xF8);
        execSeq(0xB00, 0xB02);
        assertEquals(0x8B, myTestCPU.registerB.get());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
    }

    /* SET b, (IX+d)
    */
    @Test
    public void set7RegisterIXd() {
        myTestCPU.registerIX.set(0x1000);
        myTestCPU.write(0xFB0, 0x25);
        writeSeq(0x0B00, 0xDD, 0xCB, 0xB0, 0xFE);
        execSeq(0xB00, 0xB04);
        assertEquals(0xA5, myTestCPU.read(0xFB0));
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
    }

    /* RES b, r
    */
    @Test
    public void res1RegisterH() {
        myTestCPU.registerH.set(0x0F);
        writeSeq(0x0B00, 0xCB, 0x8C);
        execSeq(0xB00, 0xB02);
        assertEquals(0x0D, myTestCPU.registerH.get());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
    }

    /* RES 0, (IY+d)
    */
    @Test
    public void res0RegisterIYd() {
        myTestCPU.registerIY.set(0x1000);
        myTestCPU.write(0xFB0, 0x25);
        writeSeq(0x0B00, 0xFD, 0xCB, 0xB0, 0x86);
        execSeq(0xB00, 0xB04);
        assertEquals(0x24, myTestCPU.read(0xFB0));
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
    }

}
