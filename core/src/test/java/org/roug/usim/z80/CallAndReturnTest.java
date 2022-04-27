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

}
