package org.roug.osnine.rbf;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertNotNull;
import org.junit.Before;
import org.junit.Test;

public class DirectoryTest {


    @Test
    public void simple() throws Exception {
        Directory dir = new Directory();
        assertNotNull(dir);
        dir.addDirEntry("..", 12);
        dir.addDirEntry(".", 12);

        byte[] sector = dir.getSector(0);
        assertEquals(256, sector.length);
        assertEquals(0, sector[29]);  // Test the lsn
        assertEquals(0, sector[30]);  // Test the lsn
        assertEquals(12, sector[31]);  // Test the lsn
        assertEquals('.', sector[0]);
        assertEquals(-82, sector[1]); // Test that high bit is on.
        assertEquals(0, sector[2]);
        // Next entry
        assertEquals(-82, sector[32]);
    }

    @Test
    public void extraSectors() throws Exception {
        Directory dir = new Directory();
        dir.addDirEntry("..", 12);
        dir.addDirEntry(".", 12);

        byte[] sector = dir.getSector(2);
        assertEquals(256, sector.length);
        for (int i = 0; i < 256; i++) {
            assertEquals(0, sector[i]);
        }
    }
}
