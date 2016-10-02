package org.roug.osnine.os9;

import java.io.IOException;
import static org.junit.Assert.assertEquals;
import org.junit.Test;

/**
 * The Device driver that interfaces to a UNIX filesystem.
 */
public class DevUnixTest {

    @Test
    public void testRead() {
        String driveLocation = System.getProperty("outputDirectory");
        DevUnix dev = new DevUnix("/dd", driveLocation)); // Default drive
        PathDev pd = dev.open("/dd/dummymod.mod");
        byte[] buf = new byte[100];
        int len = pd.read(buf, 10);
        assertEquals(10, len);
    }
}
