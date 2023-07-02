package org.roug.usim.z80;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;

public class JumpTest extends Framework {

    /* JP nn -- Opcode C3
    */
    @Test
    public void JPnn() {
        myTestCPU.registerSP.set(0x1002);
        writeSeq(0x0B00, 0xC3, 0x45, 0x12);
        execSeq(0xB00, 0x1245);
        assertEquals(0x1002, myTestCPU.registerSP.get());
    }

    /* JP C,nn -- Opcode DA
    */
    @Test
    public void JP_C_nn() {
        myTestCPU.registerF.setC(false);
        writeSeq(0x0B00, 0xDA, 0x20, 0x15);
        execSeq(0xB00, 0xB03);

        myTestCPU.registerF.setC(true);
        writeSeq(0x0B00, 0xDA, 0x20, 0x15);
        execSeq(0xB00, 0x1520);
    }

    /* JR e -- Opcode 18
    */
    @Test
    public void JR_e() {
        writeSeq(0x0480, 0x18, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00);
        execSeq(0x480, 0x485);
    }

}
