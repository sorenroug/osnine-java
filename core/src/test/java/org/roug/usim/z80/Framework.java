package org.roug.usim.z80;

import static org.junit.Assert.assertEquals;
import org.junit.Before;
import org.junit.Test;

public class Framework {

    protected Z80 myTestCPU;

    @Before
    public void setUp() {
        myTestCPU = new Z80(0x2000);
    }

    void setA(int value) {
        myTestCPU.registerA.set(value);
    }

    void assertA(int exp) {
        assertEquals(exp, myTestCPU.registerA.intValue());
    }

    void setB(int value) {
        myTestCPU.registerB.set(value);
    }

    void assertB(int exp) {
        assertEquals(exp, myTestCPU.registerB.intValue());
    }

    void setPC(int value) {
        myTestCPU.pc.set(value);
    }

    void assertPC(int exp) {
        assertEquals(exp, myTestCPU.pc.intValue());
    }

    void writebyte(int loc, int value) {
        myTestCPU.write(loc, value);
    }

    void writeword(int loc, int value) {
        myTestCPU.write_word(loc, value);
    }

    void writeSeq(int loc, int ... values) {
        for (int value : values) {
            myTestCPU.write(loc++, value);
        }
    }

    void execSeq(int locStart, int locEnd) {
        myTestCPU.pc.set(locStart);
        myTestCPU.execute();
        assertEquals(locEnd, myTestCPU.pc.intValue());
    }

}
