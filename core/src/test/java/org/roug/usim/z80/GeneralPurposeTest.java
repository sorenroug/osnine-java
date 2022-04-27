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

public class GeneralPurposeTest extends Framework {

    private static final int LOCATION = 0x1e20;

    /* Complement Accumulator */
    @Test
    public void testCPL() {
        setA(0x8B);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0x2F); // CPL instruction
        execSeq(0xB00, 0xB01);
        assertEquals(0x74, myTestCPU.registerA.intValue());
        assertEquals(0x12, myTestCPU.registerF.get());
    }

    /* Negate Accumulator
     * TODO:Complete
     */
    @Test
    public void testNEG() {
        setA(0xED);
        myTestCPU.registerF.clear();
        myTestCPU.write(0x0B00, 0xED); // NEG instruction
        myTestCPU.write(0x0B01, 0x44); // NEG instruction
        execSeq(0xB00, 0xB02);
        assertEquals(0x13, myTestCPU.registerA.intValue());
        assertEquals(0x12, myTestCPU.registerF.get()); // Not verified
    }

    @Test
    public void testNOP() {
        setA(0x8B);
        myTestCPU.write(0x0B00, 0x00); // NOP instruction
        myTestCPU.write(0x0B01, 0x00); // NOP instruction
        execSeq(0xB00, 0xB01);
        assertEquals(0x8B, myTestCPU.registerA.intValue());
    }

    /**
     * Disable interrupts, then check that CPU doesn't branch to
     * interrupt handling.
     * TODO
     */
    @Test
    public void disableInterrupts() {
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0xF3, 0x00, 0x00); // DI instruction + NOPs
        execSeq(0xB00, 0xB01);

        Bus8Intel bus = myTestCPU.getBus();
        bus.signalIRQ(true);
        myTestCPU.execute();
        //assertEquals(0x0000, myTestCPU.pc.intValue());
        bus.signalIRQ(false);
    }

    /* Test CPU reset
     * TODO:Complete
     */
    @Test
    public void testRESET() {
        setPC(0xB00);
        myTestCPU.reset();
        assertEquals(0x0000, myTestCPU.pc.intValue());
    }

    @Test
    public void generateIRQ() {
        writeSeq(0x0B00, 0x00, 0x00); // NOP instructions
        setPC(0xB00);
        Bus8Intel bus = myTestCPU.getBus();
        bus.signalIRQ(true);
        myTestCPU.execute();
        //assertEquals(0x0000, myTestCPU.pc.intValue());
        bus.signalIRQ(false);
    }

}
