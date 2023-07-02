package org.roug.usim.z80;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;

public class CallAndReturnTest extends Framework {

    /* CALL nn -- Opcode CD
    */
    @Test
    public void CALLnn() {
        myTestCPU.registerSP.set(0x1002);
        writeSeq(0x0B00, 0xCD, 0x45, 0x12);
        execSeq(0xB00, 0x1245);
        assertEquals(0x1000, myTestCPU.registerSP.get());
        assertEquals(0x03, myTestCPU.read(0x1000));
        assertEquals(0x0B, myTestCPU.read(0x1001));
    }

    /* CALL cc,nn
    */
    @Test
    public void CALLccnn() {
        myTestCPU.registerSP.set(0x1002);
        myTestCPU.registerF.setC(true);
        writeSeq(0x0B00, 0xDC, 0x45, 0x12); // CALL C,0x1245
        execSeq(0xB00, 0x1245);
        assertEquals(0x1000, myTestCPU.registerSP.get());
        assertEquals(0x03, myTestCPU.read(0x1000));
        assertEquals(0x0B, myTestCPU.read(0x1001));

         //CALL NC,0x1245 - must not branch
        myTestCPU.registerSP.set(0x1102);
        myTestCPU.registerF.setC(true);
        writeSeq(0x0B00, 0xD4, 0x45, 0x12);
        execSeq(0xB00, 0xB03);
        assertEquals(0x1102, myTestCPU.registerSP.get());
        assertEquals(0x00, myTestCPU.read(0x1100));
        assertEquals(0x00, myTestCPU.read(0x1101));

    }

    /* RET - unconditional return
    */
    @Test
    public void RET() {
        myTestCPU.write_word(0xA00, 0x0345); // Return address
        myTestCPU.registerSP.set(0xA00);
        writeSeq(0x0B00, 0xC9); // RET
        execSeq(0xB00, 0x0345);
        assertEquals(0xA02, myTestCPU.registerSP.get());
    }

    /* RET cc
    */
    @Test
    public void RETcc() {
        myTestCPU.write_word(0xA00, 0x0345); // Return address
        myTestCPU.registerSP.set(0xA00);
        myTestCPU.registerF.setS(true);
        writeSeq(0x0B00, 0xF8); // RET C
        execSeq(0xB00, 0x0345);
        assertEquals(0xA02, myTestCPU.registerSP.get());

        // Set S false
        myTestCPU.write_word(0xA00, 0x0345); // Return address
        myTestCPU.registerSP.set(0xA00);
        myTestCPU.registerF.setS(false);
        writeSeq(0x0B00, 0xF8); // RET C
        execSeq(0xB00, 0xB01);
        assertEquals(0xA00, myTestCPU.registerSP.get());
    }

    /* RETI - return from interrupt.
    */
    @Test
    public void RETI() {
        myTestCPU.write_word(0xA00, 0x0345); // Return address
        myTestCPU.registerSP.set(0xA00);
        writeSeq(0x0B00, 0xED, 0x4D); // RETI
        execSeq(0xB00, 0x0345);
        assertEquals(0xA02, myTestCPU.registerSP.get());
    }

    /* RETN - return from non-maskable interrupt.
    */
    @Test
    public void RETN() {
        myTestCPU.write_word(0xA00, 0x0345); // Return address
        myTestCPU.registerSP.set(0xA00);
        writeSeq(0x0B00, 0xED, 0x45); // RETN
        execSeq(0xB00, 0x0345);
        assertEquals(0xA02, myTestCPU.registerSP.get());
    }

    /* RST p
    */
    @Test
    public void RSTp() {
        myTestCPU.registerSP.set(0x1002);
        writeSeq(0x0B00, 0xFF); // RST to 0x0038
        execSeq(0xB00, 0x0038);
        assertEquals(0x1000, myTestCPU.registerSP.get());

        myTestCPU.registerSP.set(0x1102);
        writeSeq(0x0B00, 0xC7);
        execSeq(0xB00, 0x0000); // RST to 0x0000
        assertEquals(0x1100, myTestCPU.registerSP.get());
    }

}
