package org.roug.usim;

import java.io.File;
import java.io.IOException;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import org.junit.Test;
import org.junit.Ignore;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class IMDHandlerTest {

    private static final Logger LOGGER =
                LoggerFactory.getLogger(IMDHandlerTest.class);

    private File diskPath(String fileName) {
        String dir = System.getProperty("storage.dir");
        assertNotNull(dir);
        return new File(dir, fileName);
    }

    /**
     * 
     */
    @Test
    public void readOS9Imd() throws IOException {
        IMDHandler disk = new IMDHandler(diskPath("OS9_V1.2.imd"));
        assertEquals("IMD 1.18: 14/07/2014 11:05:31\r\n"
                   + "os-9 gmx I v 1.2\r\n", disk.getLabel());
        assertEquals(1, disk.getNumSides());
        assertEquals(80, disk.getNumTracks());
        assertEquals(10, disk.getNumSectors(0, 10));

        assertFalse(disk.isMFM(0, 0)); // Side 0, Track 0
        assertFalse(disk.isMFM(0, 1)); // Side 0, Track 1

        byte[] sector = disk.readSector(0, 0, 0);
        assertEquals(0x00, sector[0]);
        assertEquals(0x03, sector[1]);
        assertEquals(0x20, sector[2]);

        sector = disk.readSector(0, 0, 1);
        assertEquals(-1, sector[0]);
        assertEquals(-1, sector[1]);
        assertEquals(-1, sector[2]);

        sector = disk.readSector(0, 79, 5);
        assertEquals(-27, sector[0]);
        assertEquals(-27, sector[1]);
        assertEquals(-27, sector[2]);
    }

    /*
     * This disk pretends that side 1 is side 0, and continues the sector
     * numbers on side 1.
     */
    @Test
    public void readK4FImd() throws IOException {
        IMDHandler disk = new IMDHandler(diskPath("SBASIC.imd"));
        assertEquals("IMD 1.18: 10/06/2019 15:28:47\r\n"
                   + "CP/M 2.2 og S-BASIC for Kaypro\r\n", disk.getLabel());
        assertEquals(2, disk.getNumSides());
        assertEquals(40, disk.getNumTracks());
        assertEquals(10, disk.getNumSectors(0, 10)); // This is the physical number of sectors on each side.
        assertEquals(512, disk.getSectorSize(0, 10));

        assertTrue(disk.isMFM(0, 1)); // Side 0, Track 1
        assertTrue(disk.isMFM(0, 18)); // Side 0, Track 18

        assertTrue(disk.isBadSector(0, 0, 1));
        assertTrue(disk.isBadSector(0, 0, 11));
        assertFalse(disk.isBadSector(0, 0, 2));

        byte[] sector0 = disk.readSector(0, 0, 12);
        assertEquals(0x00, sector0[0]);
        assertEquals(0x55, sector0[1]);
        assertEquals(0x4E, sector0[2]);
    }

}
