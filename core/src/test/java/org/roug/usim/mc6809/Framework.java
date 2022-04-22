package org.roug.usim.mc6809;

import static org.junit.Assert.assertEquals;
import org.junit.Before;
import org.junit.Test;

public class Framework {

    protected MC6809 myTestCPU;

    @Before
    public void setUp() {
        myTestCPU = new MC6809(0x2000);
    }

    void setA(int value) {
        myTestCPU.a.set(value);
    }

    void assertA(int exp) {
        assertEquals(exp, myTestCPU.a.intValue());
    }

    void setB(int value) {
        myTestCPU.b.set(value);
    }

    void assertB(int exp) {
        assertEquals(exp, myTestCPU.b.intValue());
    }

    void setCC(int value) {
        myTestCPU.cc.set(value);
    }

    void assertCC(int exp) {
        assertEquals(exp, myTestCPU.cc.intValue());
    }

    void assertCCFlags(int exp, int mask) {
        String names[] = {"C", "V", "Z", "N", "I", "H", "F", "E" };

        int ccVal = myTestCPU.cc.intValue();
        for (int i = 0; i < 8; i++) {
            if ((mask & 1) == 1)
                assertEquals(names[i], (exp & 1),(ccVal & 1));
            mask >>= 1;
            ccVal >>= 1;
            exp >>= 1;
        }
    }

    void setD(int value) {
        myTestCPU.d.set(value);
    }

    void assertD(int exp) {
        assertEquals(exp, myTestCPU.d.intValue());
    }

    void setPC(int value) {
        myTestCPU.pc.set(value);
    }

    void assertPC(int exp) {
        assertEquals(exp, myTestCPU.pc.intValue());
    }

    void setX(int value) {
        myTestCPU.x.set(value);
    }

    void assertX(int exp) {
        assertEquals(exp, myTestCPU.x.intValue());
    }

    void setY(int value) {
        myTestCPU.y.set(value);
    }

    void assertY(int exp) {
        assertEquals(exp, myTestCPU.y.intValue());
    }

    void setU(int value) {
        myTestCPU.u.set(value);
    }

    void assertU(int exp) {
        assertEquals(exp, myTestCPU.u.intValue());
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

}
