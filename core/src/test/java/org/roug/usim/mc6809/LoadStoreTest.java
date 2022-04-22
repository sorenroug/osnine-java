package org.roug.usim.mc6809;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import org.junit.Before;
import org.junit.Test;

public class LoadStoreTest extends Framework {

    private static final int PROGLOC = 0xB00;

    /**
     * Load value 0 into A (Immediate mode).
     */
    @Test
    public void LDAZero() {
        setA(0x02);
        myTestCPU.cc.setN(1);
        myTestCPU.cc.setZ(0);
        writeSeq(PROGLOC, 0xB6, 0x00);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertA(0x00);
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(1, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    /**
     * Load value 0 into A (Extended mode).
     */
    @Test
    public void LDAExtend() {
        setA(0xF2);
        myTestCPU.write(0x0579, 0x03); // Value to fetch
        myTestCPU.cc.setN(1);
        myTestCPU.cc.setZ(1);
        writeSeq(PROGLOC, 0xB6, 0x05, 0x79);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertA(0x03);
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    @Test
    public void LDApredec() {
        // Test INDEXED mode:   LDA   ,-Y (decrement Y before loading A)
        //
        myTestCPU.cc.clear();
        // Set up a byte to test at address 0x200
        writebyte(0x200, 0x31);
        // Set register Y to point to that location plus 1
        setY(0x201);
        writeSeq(PROGLOC, 0xA6, 0xA2);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertY(0x200);
        assertEquals(0x31, myTestCPU.a.intValue());
        assertPC(PROGLOC + 2);
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    @Test
    public void LDA_X_pos() {
        // Test INDEXED INDIRECT mode:   LDA [$10,X]
        //
        // Set register X to point to a location
        setX(0x1000);
        // Set up a word to at address 0x1010 to point to 0x1150
        writeword(0x1010, 0x1150);
        // The value to load into A
        myTestCPU.write(0x1150, 0xAA);
        writeSeq(PROGLOC, 0xA6, 0x99, 0x00, 0x10);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertX(0x1000);
        assertA(0xAA);
        assertPC(PROGLOC + 4);
        assertEquals(1, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    /**
     * Test INDEXED INDIRECT mode:   LDA [$10,U].
     */
    @Test
    public void LDA_U_neg() {
        myTestCPU.u.set(0x1000);
        // Set up a word to at address 0x1000 - 0x10 to point to 0x1150
        writeword(0x0FF0, 0x1150);
        // The value to load into A
        myTestCPU.write(0x1150, 0x7A);
        writeSeq(PROGLOC, 0xA6, 0xD9, 0xFF, 0xF0);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertEquals(0x1000, myTestCPU.u.intValue());
        assertA(0x7A);
        assertPC(PROGLOC + 4);
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    /**
     * Test the LDB - Load into B - instruction.
     */
    @Test
    public void LDB_A_pos_S() {
        // Test INDEXED mode:   LDB   A,S
        //
        // Set up a word to test at address 0x205
        writeword(0x202, 0xb3ff);
        // Set register A to the offset
        setA(0x02);
        // Set register S to point to that location minus 2
        myTestCPU.s.set(0x200);
        // Two bytes of instruction
        myTestCPU.write(PROGLOC + 0, 0xE6);
        myTestCPU.write(PROGLOC + 1, 0xE6);
        myTestCPU.cc.clear();
        setPC(PROGLOC);
        myTestCPU.execute();
        assertEquals(0x200, myTestCPU.s.intValue());
        assertB(0xb3);
        assertPC(PROGLOC + 2);
        assertEquals(1, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    @Test
    public void LDB_A_neg_S() {
        // Test INDEXED mode:   LDB   A,S where A is negative
        //
        // Set up a word to test at address 0x205
        writeword(0x202, 0x73ff);
        // Set register A to the offset
        setA(0xF2);
        // Set register S to point to that location minus 2
        myTestCPU.s.set(0x210);
        // Two bytes of instruction
        myTestCPU.write(PROGLOC + 0, 0xE6);
        myTestCPU.write(PROGLOC + 1, 0xE6);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertEquals(0x210, myTestCPU.s.intValue());
        assertB(0x73);
        assertPC(PROGLOC + 2);
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    /**
     * Test the LDD - Load into D - instruction.
     */
    @Test
    public void LDD() {
        // Test INDEXED mode:   LDD   2,Y
        //
        // Set up a word to test at address 0x205
        writeword(0x202, 0xb3ff);
        // Set register D to something
        myTestCPU.d.set(0x105);
        // Set register Y to point to that location minus 5
        setY(0x200);
        // Two bytes of instruction
        myTestCPU.write(PROGLOC + 0, 0xEC);
        myTestCPU.write(PROGLOC + 1, 0x22);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertY(0x200);
        assertEquals(0xb3ff, myTestCPU.d.intValue());
        assertPC(PROGLOC + 2);
        assertEquals(1, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    @Test
    public void LDDindexed() {
        // Test INDEXED mode:   LDD   -2,Y
        //
        myTestCPU.cc.clear();
        // Set up a word to test at address 0x1FE
        writeword(0x1FE, 0x33ff);
        // Set register Y to point to that location plus 2
        setY(0x200);
        // Two bytes of instruction
        myTestCPU.write(PROGLOC + 0, 0xEC);
        myTestCPU.write(PROGLOC + 1, 0x3E);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertY(0x200);
        assertEquals(0x33ff, myTestCPU.d.intValue());
        assertA(0x33);
        assertPC(PROGLOC + 2);
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    @Test
    public void LDDpredec() {
        // Test INDEXED mode:   LDD   ,--Y (decrement Y by 2 before loading D)
        //
        myTestCPU.cc.clear();
        // Set up a word to test at address 0x200
        writeword(0x200, 0x31ff);
        // Set register Y to point to that location minus 5
        setY(0x202);
        // Two bytes of instruction
        myTestCPU.write(PROGLOC + 0, 0xEC); // LDD
        myTestCPU.write(PROGLOC + 1, 0xA3);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertY(0x200);
        assertEquals(0x31ff, myTestCPU.d.intValue());
        assertPC(PROGLOC + 2);
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    @Test
    public void LDDpostinc() {
        // Test INDEXED mode:   LDD   ,Y++ (increment Y by 2 after loading D)
        //
        myTestCPU.cc.clear();
        // Set up a word to test at address 0x200
        writeword(0x200, 0x31ff);
        // Set register Y to point to that location
        setY(0x200);
        // Two bytes of instruction
        myTestCPU.write(PROGLOC + 0, 0xEC); // LDD
        myTestCPU.write(PROGLOC + 1, 0xA1);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertY(0x202);
        assertEquals(0x31ff, myTestCPU.d.intValue());
        assertPC(PROGLOC + 2);
        assertEquals(0, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    /**
     * Test the LDS - Load into S - instruction.
     */
    @Test
    public void LDS() {
        myTestCPU.s.set(0xA11);
        myTestCPU.write(PROGLOC + 0, 0x10); // LDS
        myTestCPU.write(PROGLOC + 1, 0xCE);
        writeword(PROGLOC + 2, 0x1234);
        setPC(PROGLOC);
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
    public void LDYextended() {
        writeword(0x0E81, 0x0202); // Set up a value of 0x0202 at 0x0E81
        // Set register D to something
        myTestCPU.d.set(0x105);
        // Set register Y to point to that location minus 5
        setY(0x200);
        // Two bytes of instruction
        myTestCPU.write(PROGLOC + 0, 0x10); // LDY
        myTestCPU.write(PROGLOC + 1, 0xBE); // LDY
        myTestCPU.write(PROGLOC + 2, 0x0E); // Fetch value in 0x0E81
        myTestCPU.write(PROGLOC + 3, 0x81);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertPC(PROGLOC + 4);
        assertY(0x0202);
    }

    /**
     * Test the LDY - Load into Y - instruction.
     */
    @Test
    public void LDYextendedIndirect() {
        writeword(0x0202, 0xB3FF); // Set up a word to test at address 0x202
        writeword(0x0E81, 0x0202); // Set up a pointer to 0x0202 at 0x0E81
        // Set register D to something
        myTestCPU.d.set(0x105);
        // Set register Y to point to that location minus 5
        setY(0x200);
        writeSeq(PROGLOC, 0x10, 0xAE, 0x9F, 0x0E, 0x81);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertPC(0xB05);
        assertY(0xB3FF);
    }

    /**
     * Store S direct to 0x129F.
     */
    @Test
    public void STSdirect() {
        // Set register DP to the offset
        myTestCPU.dp.set(0x12);
        myTestCPU.s.set(0x0AAA);
        myTestCPU.write(PROGLOC + 0, 0x10); // STS
        myTestCPU.write(PROGLOC + 1, 0xDF); // STS
        myTestCPU.write(PROGLOC + 2, 0x9F);
        setPC(PROGLOC);
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
    public void STBindexed() {
        setB(0xE5);
        setX(0x056A);
        myTestCPU.write(0x0579, 0x03);
        myTestCPU.write(0x057A, 0xBB);
        myTestCPU.write(0x03BB, 0x02);
        myTestCPU.write(PROGLOC + 0, 0xE7); // STB
        myTestCPU.write(PROGLOC + 1, 0x98); // 10011000
        myTestCPU.write(PROGLOC + 2, 0x0F);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertEquals(0xE5, myTestCPU.read(0x03BB));
        assertEquals(1, myTestCPU.cc.getN());
        assertEquals(0, myTestCPU.cc.getZ());
        assertEquals(0, myTestCPU.cc.getV());
    }

    /**
     * Store A relative/immediate (illegal instruction)
     * STA 0x20
     */
    @Test(expected = RuntimeException.class)
    public void STAillegal() {
        setA(0xE5);
        myTestCPU.write(PROGLOC + 0, 0x87); // illegal
        myTestCPU.write(PROGLOC + 1, 0x20);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertEquals(0, myTestCPU.cc.getZ());
    }

    /**
     * Store B relative/immediate (illegal instruction)
     * STB 0x20
     */
    @Test(expected = RuntimeException.class)
    public void STBillegal() {
        setB(0xE5);
        myTestCPU.write(PROGLOC + 0, 0xC7); // illegal
        myTestCPU.write(PROGLOC + 1, 0x20);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertEquals(0, myTestCPU.cc.getZ());
    }

    /**
     * Store D relative/immediate (illegal instruction)
     * STD 0x20
     */
    @Test(expected = RuntimeException.class)
    public void STDillegal() {
        setB(0xE5);
        myTestCPU.write(PROGLOC + 0, 0xCD); // illegal
        myTestCPU.write(PROGLOC + 1, 0x20);
        myTestCPU.write(PROGLOC + 2, 0x20);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertEquals(0, myTestCPU.cc.getZ());
    }

    /**
     * Store S relative/immediate (illegal instruction)
     * STS 0x2020
     */
    @Test(expected = RuntimeException.class)
    public void STSillegal() {
        myTestCPU.s.set(0x01E5);
        myTestCPU.write(PROGLOC + 0, 0x10); // illegal
        myTestCPU.write(PROGLOC + 1, 0xCF);
        myTestCPU.write(PROGLOC + 2, 0x20);
        myTestCPU.write(PROGLOC + 3, 0x20);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertEquals(0, myTestCPU.cc.getZ());
    }

    /**
     * Store X relative/immediate (illegal instruction)
     * STX 0x20
     */
    @Test(expected = RuntimeException.class)
    public void STXillegal() {
        setB(0xE5);
        myTestCPU.write(PROGLOC + 0, 0x8F); // illegal
        myTestCPU.write(PROGLOC + 1, 0x20);
        myTestCPU.write(PROGLOC + 2, 0x20);
        setPC(PROGLOC);
        myTestCPU.execute();
        assertEquals(0, myTestCPU.cc.getZ());
    }
}
