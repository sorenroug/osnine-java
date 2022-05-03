package org.roug.usim.z80;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;
import org.roug.usim.Bus8Intel;

public class RotateShiftTest extends Framework {

    /* RLC r - shift left 0x44 in A */
    @Test
    public void RLCReg() {
        setA(0x88);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0xCB, 0x07); // CPL instruction
        execSeq(0xB00, 0xB02);
        assertEquals(0x11, myTestCPU.registerA.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetH());
        assertTrue(myTestCPU.registerF.isSetPV());
        assertFalse(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetC());
    }


}
