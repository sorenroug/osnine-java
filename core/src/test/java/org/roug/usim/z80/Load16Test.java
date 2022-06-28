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

public class Load16Test extends Framework {

    private static final int LOCATION = 0x1e20;

    /* LD dd, nn -- Opcode 01
     */
    @Test
    public void loadBCImmediate() {
        myTestCPU.registerBC.set(0x445A);
        writeSeq(0x0B00, 0x01, 0x00, 0x50);
        execSeq(0xB00, 0xB03);
        assertEquals(0x5000, myTestCPU.registerBC.get());
    }


    /* LD (nn), HL -- Opcode 22
     */
    @Test
    public void loadNNfromHL() {
        myTestCPU.registerHL.set(0x483A);
        myTestCPU.write_word(0x1229, 0x0402); // Set dummy data
        writeSeq(0x0B00, 0x22, 0x29, 0x12);
        execSeq(0xB00, 0xB03);
        assertEquals(0x483A, myTestCPU.registerHL.get());
        assertEquals(0x483A, myTestCPU.read_word(0x1229));
    }


    /* LD HL, (nn) -- Opcode 2A
     */
    @Test
    public void loadHLfromNNindexed() {
        myTestCPU.write(0x1445, 0x37); // Set test data
        myTestCPU.write(0x1446, 0xA1); // Set test data
        myTestCPU.registerHL.set(0x7777);
        writeSeq(0x0B00, 0x2A, 0x45, 0x14);
        execSeq(0xB00, 0xB03);
        assertEquals(0xA137, myTestCPU.registerHL.get());
    }

    /* LD dd, nn -- Opcode 31
     * Test load of stack pointer
     */
    @Test
    public void loadSPImmediate() {
        myTestCPU.registerSP.set(0x445A);
        writeSeq(0x0B00, 0x31, 0x00, 0x50);
        execSeq(0xB00, 0xB03);
        assertEquals(0x5000, myTestCPU.registerSP.get());
    }

    /* LD SP, HL -- Opcode F9
     */
    @Test
    public void loadSPfromHL() {
        myTestCPU.registerSP.set(0x245A);
        myTestCPU.registerHL.set(0x442E);
        writeSeq(0x0B00, 0xF9);
        execSeq(0xB00, 0xB01);
        assertEquals(0x442E, myTestCPU.registerSP.get());
    }

    /* LD (nn), BC -- Opcode 0xED, 0x43
     */
    @Test
    public void loadBCToMem() {
        myTestCPU.write_word(0x1000, 0xFFFF); // Set dummy test data
        myTestCPU.registerBC.set(0x4644);
        writeSeq(0x0B00, 0xED, 0x43, 0x00, 0x10);
        execSeq(0xB00, 0xB04);
        assertEquals(0x4644, myTestCPU.read_word(0x1000));
    }

    /* LD IY, (nn) -- Opcode 0xFD, 0x2A
     */
    @Test
    public void loadNNindexedToIY() {
        myTestCPU.write(0x1666, 0x92);
        myTestCPU.write(0x1667, 0xDA);
        writeSeq(0x0B00, 0xFD, 0x2A, 0x66, 0x16);
        execSeq(0xB00, 0xB04);
        assertEquals(0xDA92, myTestCPU.registerIY.get());
    }

    /* PUSH qq -- Opcode {0xF5, 0xE5, 0xD5, 0xC5}
     */
    @Test
    public void pushRegisterPairBC() {
        myTestCPU.registerSP.set(0x400);
        myTestCPU.registerBC.set(0x445A);
        writeSeq(0x0B00, 0xC5);
        execSeq(0xB00, 0xB01);
        assertEquals(0x3FE, myTestCPU.registerSP.get());
        assertEquals(0x445A, myTestCPU.registerBC.get());
        assertEquals(0x445A, myTestCPU.read_word(0x3FE));
    }

    /* PUSH qq -- Opcode {0xF5, 0xE5, 0xD5, 0xC5}
     */
    @Test
    public void pushRegisterPairAF() {
        myTestCPU.registerSP.set(0x1007);
        myTestCPU.registerAF.set(0x2233);
        writeSeq(0x0B00, 0xF5);
        execSeq(0xB00, 0xB01);
        assertEquals(0x1005, myTestCPU.registerSP.get());
        assertEquals(0x2233, myTestCPU.registerAF.get());
        assertEquals(0x33, myTestCPU.read(0x1005));
        assertEquals(0x22, myTestCPU.read(0x1006));
    }

    /* POP DE -- Opcode {0xF1, 0xE1, 0xD1, 0xC1}
     */
    @Test
    public void popRegisterPairDE() {
        myTestCPU.registerSP.set(0x1000);
        myTestCPU.write_word(0x1000, 0x3355); // Set test data
        myTestCPU.registerDE.set(0x2233); // Set dummy test data
        writeSeq(0x0B00, 0xD1);
        execSeq(0xB00, 0xB01);
        assertEquals(0x1002, myTestCPU.registerSP.get());
        assertEquals(0x3355, myTestCPU.registerDE.get());
    }

    /* POP IX -- Opcode 0xDD 0xE1
     */
    @Test
    public void popRegisterIX() {
        myTestCPU.registerSP.set(0x1000);
        myTestCPU.write_word(0x1000, 0x3355); // Set test data
        myTestCPU.registerIX.set(0x2233); // Set dummy test data
        writeSeq(0x0B00, 0xDD, 0xE1);
        execSeq(0xB00, 0xB02);
        assertEquals(0x1002, myTestCPU.registerSP.get());
        assertEquals(0x3355, myTestCPU.registerIX.get());
    }

}
