package org.roug.osnine;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import org.junit.Before;
import org.junit.Test;

public class InstructionsTest {

    private static final int LOCATION = 0x1e20;

    private MC6809 myTestCPU;

    private void loadProg(int[] instructions) {
        myTestCPU.write_word(0xfffe, LOCATION);
        int respc = myTestCPU.read_word(0xfffe);
        assertEquals(LOCATION, respc);

        for (int i = 0; i < instructions.length; i++) {
            myTestCPU.write(i + LOCATION, instructions[i]);
        }
        myTestCPU.reset();
        myTestCPU.cc.clearCC();
    }

    @Before
    public void setUp() {
        myTestCPU = new MC6809();
    }

    @Test
    public void testABX() throws IOException {
        int instructions[] = {
            0x3a // ABX
        };
        loadProg(instructions);
        myTestCPU.x.set(505);
        myTestCPU.b.set(5);
        myTestCPU.execute();
        assertEquals(0x3a, myTestCPU.ir);
        assertEquals(LOCATION + 1, myTestCPU.pc);
        assertEquals(510, myTestCPU.x.intValue());
    }


    @Test
    public void testADCA() {
        int instructions[] = {
            0x89, // ADCA
            0x02  // value 2
        };
        loadProg(instructions);
        myTestCPU.a.set(5);
        myTestCPU.execute();
        assertEquals(0x89, myTestCPU.ir);
        assertEquals(LOCATION + 2, myTestCPU.pc);
        assertEquals(7, myTestCPU.a.intValue());
    }


}
