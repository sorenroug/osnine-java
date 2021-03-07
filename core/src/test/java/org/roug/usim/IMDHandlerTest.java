package org.roug.usim;

import java.io.File;
import java.io.IOException;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
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
        IMDHandler img = new IMDHandler(diskPath("OS9_V1.2.imd"));
        assertEquals("IMD 1.18: 14/07/2014 11:05:31\r\n"
                   + "os-9 gmx I v 1.2\r\n", img.getLabel());
        assertEquals(1, img.getNumSides());
        assertEquals(80, img.getNumTracks());
        assertEquals(10, img.getNumSectors(0, 10));

        byte[] sector0 = img.readSector(0, 0, 0);
        assertEquals(0x00, sector0[0]);
        assertEquals(0x03, sector0[1]);
        assertEquals(0x20, sector0[2]);

        byte[] sector1 = img.readSector(0, 0, 1);
        assertEquals(-1, sector1[0]);
        assertEquals(-1, sector1[1]);
        assertEquals(-1, sector1[2]);
    }

    /*
     * This disk pretends that side 1 is side 0, and continues the sector
     * numbers on side 1.
     */
    @Test
    public void readK4FImd() throws IOException {
        IMDHandler img = new IMDHandler(diskPath("SBASIC.imd"));
        assertEquals("IMD 1.18: 10/06/2019 15:28:47\r\n"
                   + "CP/M 2.2 og S-BASIC for Kaypro\r\n", img.getLabel());
        assertEquals(2, img.getNumSides());
        assertEquals(40, img.getNumTracks());
        assertEquals(10, img.getNumSectors(0, 10)); // This is the physical number of sectors on each side.
        assertEquals(512, img.getSectorSize(0, 10));

        byte[] sector0 = img.readSector(0, 0, 12);
        assertEquals(0x00, sector0[0]);
        assertEquals(0x55, sector0[1]);
        assertEquals(0x4E, sector0[2]);
    }

}
