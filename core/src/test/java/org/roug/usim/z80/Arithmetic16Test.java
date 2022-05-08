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

public class Arithmetic16Test extends Framework {


    /* INC BC
     */
    @Test
    public void incBC() {
        myTestCPU.registerBC.set(0x555);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0x03);
        execSeq(0xB00, 0xB01);
        assertEquals(0x556, myTestCPU.registerBC.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetN());
    }

    /* Add IY, BC
     */
    @Test
    public void addRegBCToIY() {
        myTestCPU.registerIY.set(0x333);
        myTestCPU.registerBC.set(0x555);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0xFD, 0x09);
        execSeq(0xB00, 0xB02);
        assertEquals(0x888, myTestCPU.registerIY.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetN());
    }

    /* Add IY, IY
     */
    @Test
    public void addRegIYToIY() {
        myTestCPU.registerIY.set(0x333);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0xFD, 0x29);
        execSeq(0xB00, 0xB02);
        assertEquals(0x666, myTestCPU.registerIY.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetN());
    }

    /* Add IX, IX
     */
    @Test
    public void addRegIXToIX() {
        myTestCPU.registerIX.set(0x333);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0xDD, 0x29);
        execSeq(0xB00, 0xB02);
        assertEquals(0x666, myTestCPU.registerIX.get());
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetN());
    }


    /* Add HL, HL
     */
    @Test
    public void addRegHLToHL() {
        myTestCPU.registerHL.set(0xABCD);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0x29);
        execSeq(0xB00, 0xB01);
        assertEquals(0x579A, myTestCPU.registerHL.get());
// Check for carry
        assertFalse(myTestCPU.registerF.isSetS());
        assertFalse(myTestCPU.registerF.isSetZ());
        assertFalse(myTestCPU.registerF.isSetN());
    }


}
