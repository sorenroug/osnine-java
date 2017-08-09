package org.roug.osnine;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import org.junit.Before;
import org.junit.Test;

public class LoadStoreTest {

    private MC6809 myTestCPU;

    @Before
    public void setUp() {
        myTestCPU = new MC6809(0x2000);
    }


    /**
     * Load 0 into A.
     */
    @Test
    public void testLDAZero() {
        myTestCPU.a.set(0x02);
        myTestCPU.cc.setN(1);
        myTestCPU.cc.setZ(0);
        myTestCPU.write(0xB00, 0x86);
        myTestCPU.write(0xB01, 0x00);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x00, myTestCPU.a.intValue());
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(1, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    @Test
    public void testLDA_X_pos() {
        // Test INDEXED INDIRECT mode:   LDA [$10,X]
        //
        // Set register X to point to a location
        myTestCPU.x.set(0x1000);
        // Set up a word to at address 0x1010 to point to 0x1150
        myTestCPU.write_word(0x1010, 0x1150);
        // The value to load into A
        myTestCPU.write(0x1150, 0xAA);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0xA6);
        myTestCPU.write(0xB01, 0x99);
        myTestCPU.write(0xB02, 0x00);
        myTestCPU.write(0xB03, 0x10);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x1000, myTestCPU.x.intValue());
        assertEquals(0xAA, myTestCPU.a.intValue());
        assertEquals(0xB04, myTestCPU.pc.intValue());
        assertEquals(1, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    @Test
    public void testLDA_U_neg() {
        // Test INDEXED INDIRECT mode:   LDA [$10,U]
        //
        // Set register X to point to a location
        myTestCPU.u.set(0x1000);
        // Set up a word to at address 0x1000 - 0x10 to point to 0x1150
        myTestCPU.write_word(0x0FF0, 0x1150);
        // The value to load into A
        myTestCPU.write(0x1150, 0x7A);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0xA6);
        myTestCPU.write(0xB01, 0xD9);
        myTestCPU.write(0xB02, 0xFF);
        myTestCPU.write(0xB03, 0xF0);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x1000, myTestCPU.u.intValue());
        assertEquals(0x7A, myTestCPU.a.intValue());
        assertEquals(0xB04, myTestCPU.pc.intValue());
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    /**
     * Test the LDB - Load into B - instruction.
     */
    @Test
    public void testLDB_A_pos_S() {
        // Test INDEXED mode:   LDB   A,S
        //
        // Set up a word to test at address 0x205
        myTestCPU.write_word(0x202, 0xb3ff);
        // Set register A to the offset
        myTestCPU.a.set(0x02);
        // Set register S to point to that location minus 2
        myTestCPU.s.set(0x200);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0xE6);
        myTestCPU.write(0xB01, 0xE6);
        myTestCPU.cc.clear();
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x200, myTestCPU.s.intValue());
        assertEquals(0xb3, myTestCPU.b.intValue());
        assertEquals(0xB02, myTestCPU.pc.intValue());
        assertEquals(1, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    @Test
    public void testLDB_A_neg_S() {
        // Test INDEXED mode:   LDB   A,S where A is negative
        //
        // Set up a word to test at address 0x205
        myTestCPU.write_word(0x202, 0x73ff);
        // Set register A to the offset
        myTestCPU.a.set(0xF2);
        // Set register S to point to that location minus 2
        myTestCPU.s.set(0x210);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0xE6);
        myTestCPU.write(0xB01, 0xE6);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x210, myTestCPU.s.intValue());
        assertEquals(0x73, myTestCPU.b.intValue());
        assertEquals(0xB02, myTestCPU.pc.intValue());
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    /**
     * Test the LDD - Load into D - instruction.
     */
    @Test
    public void testLDD() {
        // Test INDEXED mode:   LDD   2,Y
        //
        // Set up a word to test at address 0x205
        myTestCPU.write_word(0x202, 0xb3ff);
        // Set register D to something
        myTestCPU.d.set(0x105);
        // Set register Y to point to that location minus 5
        myTestCPU.y.set(0x200);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0xEC);
        myTestCPU.write(0xB01, 0x22);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x200, myTestCPU.y.intValue());
        assertEquals(0xb3ff, myTestCPU.d.intValue());
        assertEquals(0xB02, myTestCPU.pc.intValue());
        assertEquals(1, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());

        // Test INDEXED mode:   LDD   -2,Y
        //
        myTestCPU.cc.clear();
        // Set up a word to test at address 0x1FE
        myTestCPU.write_word(0x1FE, 0x33ff);
        // Set register Y to point to that location plus 2
        myTestCPU.y.set(0x200);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0xEC);
        myTestCPU.write(0xB01, 0x3E);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x200, myTestCPU.y.intValue());
        assertEquals(0x33ff, myTestCPU.d.intValue());
        assertEquals(0x33, myTestCPU.a.intValue());
        assertEquals(0xB02, myTestCPU.pc.intValue());
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());

        // Test INDEXED mode:   LDD   ,--Y (decrement Y by 2 before loading D)
        //
        myTestCPU.cc.clear();
        // Set up a word to test at address 0x200
        myTestCPU.write_word(0x200, 0x31ff);
        // Set register Y to point to that location minus 5
        myTestCPU.y.set(0x202);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0xEC); // LDD
        myTestCPU.write(0xB01, 0xA3);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x200, myTestCPU.y.intValue());
        assertEquals(0x31ff, myTestCPU.d.intValue());
        assertEquals(0xB02, myTestCPU.pc.intValue());
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    /**
     * Test the LDS - Load into S - instruction.
     */
    @Test
    public void testLDS() {
        myTestCPU.s.set(0xA11);
        myTestCPU.write(0xB00, 0x10); // LDS
        myTestCPU.write(0xB01, 0xCE);
        myTestCPU.write_word(0xB02, 0x1234);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x1234, myTestCPU.s.intValue());
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    /**
     * Test the LDY - Load into Y - instruction.
     */
    @Test
    public void testLDYextended() {
        myTestCPU.write_word(0x0E81, 0x0202); // Set up a value of 0x0202 at 0x0E81
        // Set register D to something
        myTestCPU.d.set(0x105);
        // Set register Y to point to that location minus 5
        myTestCPU.y.set(0x200);
        // Two bytes of instruction
        myTestCPU.write(0xB00, 0x10); // LDY
        myTestCPU.write(0xB01, 0xBE); // LDY
        myTestCPU.write(0xB02, 0x0E); // Fetch value in 0x0E81
        myTestCPU.write(0xB03, 0x81);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0xB04, myTestCPU.pc.intValue());
        assertEquals(0x0202, myTestCPU.y.intValue());
    }

    /**
     * Test the LDY - Load into Y - instruction.
     */
    @Test
    public void testLDYextendedIndirect() {
        myTestCPU.write_word(0x0202, 0xB3FF); // Set up a word to test at address 0x202
        myTestCPU.write_word(0x0E81, 0x0202); // Set up a pointer to 0x0202 at 0x0E81
        // Set register D to something
        myTestCPU.d.set(0x105);
        // Set register Y to point to that location minus 5
        myTestCPU.y.set(0x200);
        // Five bytes of instruction
        myTestCPU.write(0xB00, 0x10); // LDY
        myTestCPU.write(0xB01, 0xAE); // LDY
        myTestCPU.write(0xB02, 0x9F);
        myTestCPU.write(0xB03, 0x0E);
        myTestCPU.write(0xB04, 0x81);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0xB05, myTestCPU.pc.intValue());
        assertEquals(0xB3FF, myTestCPU.y.intValue());
    }

    /**
     * Store S direct to 0x129F
     */
    @Test
    public void testSTSdirect() {
        // Set register DP to the offset
        myTestCPU.dp.set(0x12);
        myTestCPU.s.set(0x0AAA);
        myTestCPU.write(0xB00, 0x10); // STS
        myTestCPU.write(0xB01, 0xDF); // STS
        myTestCPU.write(0xB02, 0x9F);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0x0AAA, myTestCPU.read_word(0x129F));
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    /**
     * Store B indexed to 0x03BB.
     * STB [$F,X]
     */
    @Test
    public void testSTBindexed() {
        myTestCPU.b.set(0xE5);
        myTestCPU.x.set(0x056A);
        myTestCPU.write(0x0579, 0x03);
        myTestCPU.write(0x057A, 0xBB);
        myTestCPU.write(0x03BB, 0x02);
        myTestCPU.write(0xB00, 0xE7); // STB
        myTestCPU.write(0xB01, 0x98); // 10011000
        myTestCPU.write(0xB02, 0x0F);
        myTestCPU.pc.set(0xB00);
        myTestCPU.execute();
        assertEquals(0xE5, myTestCPU.read(0x03BB));
        assertEquals(1, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

}
