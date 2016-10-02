package org.roug.osnine.os9;

import java.io.IOException;
import java.io.File;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import org.junit.Test;

/**
 * The Device driver that interfaces to a UNIX filesystem.
 */
public class DevUnixTest {

    @Test
    public void testRead() {
        String driveLocation = System.getProperty("outputDirectory");
        System.out.println(driveLocation);
        DevUnix dev = new DevUnix("/dd", driveLocation); // Default drive
        PathDesc pd = dev.open("/dd/dummymodule.mod", 1, false);
        //System.out.println(Util.getErrorMessage(dev.getErrorCode()));
        assertNotNull(pd);
        byte[] buf = new byte[100];
        int len = pd.read(buf, 10);
        assertEquals(10, len);
    }

    @Test
    public void testGetPath() {
        File f = new File("/ETC/passwd");
        String path = DevUnix.findpath(f.toPath(), true);
        assertNotNull(path);
    }
}
