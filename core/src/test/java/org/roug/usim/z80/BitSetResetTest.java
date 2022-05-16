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
    public void Bit2RegisterB() {
        myTestCPU.registerB.set(0xFB);
        writeSeq(0x0B00, 0xCB, 0x50);
        execSeq(0xB00, 0xB02);
        assertEquals(0xFB, myTestCPU.registerB.get());
        assertTrue(myTestCPU.registerF.isSetZ());
        assertTrue(myTestCPU.registerF.isSetH());
        assertFalse(myTestCPU.registerF.isSetN());
    }

}
