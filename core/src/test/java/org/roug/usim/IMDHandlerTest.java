package org.roug.usim;

import java.util.Date;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.GregorianCalendar;
import org.junit.Ignore;
import org.junit.Rule;
import org.junit.rules.ExpectedException;
import org.junit.Test;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

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

    private boolean sameFileContent(String name1, String name2) throws Exception {
        File file1 = diskPath(name1);
        File file2 = diskPath(name2);
        long len1 = file1.length();
        long len2 = file2.length();
        if (len1 != len2) return false;
        byte[] content1 = new byte[(int) len1];
        byte[] content2 = new byte[(int) len2];
        FileInputStream is1 = new FileInputStream(file1);
        is1.read(content1);
        is1.close();
        FileInputStream is2 = new FileInputStream(file2);
        is2.read(content2);
        is2.close();
        for (int i = 0; i < len1; i++)
            if (content1[i] != content2[i]) return false;
        return true;
    }

    @Rule
    public final ExpectedException exception = ExpectedException.none();

    /**
     * Read OS-9 disk with 80 tracks and 10 sectors/track.
     * FM formatted.
     */
    @Test
    public void readOS9Imd() throws IOException {
        IMDHandler disk = new IMDHandler(diskPath("OS9_V1.2.imd"));
        assertEquals("IMD 1.18: 14/07/2014 11:05:31", disk.getHeader());
        assertEquals("os-9 gmx I v 1.2\r\n", disk.getLabel());
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

    @Test
    public void copyOS9Imd() throws Exception {
        IMDHandler disk = new IMDHandler(diskPath("OS9_V1.2.imd"));
        disk.saveDisk(diskPath("savedos9.imd"));
        assertTrue(sameFileContent("OS9_V1.2.imd", "savedos9.imd"));

        GregorianCalendar my1999 = new GregorianCalendar(1999, 1, 22, 12, 23, 45);
        Date myDate = my1999.getTime();
        disk.setHeader(myDate);
        assertEquals("IMD 1.18: 22/02/1999 12:23:45", disk.getHeader());

    }

    /*
     * This disk pretends that side 1 is side 0, and continues the sector
     * numbers on side 1.
     */
    @Test
    public void readK4FImd() throws IOException {
        IMDHandler disk = new IMDHandler(diskPath("SBASIC.imd"));
        assertEquals("IMD 1.18: 10/06/2019 15:28:47", disk.getHeader());
        assertEquals("CP/M 2.2 og S-BASIC for Kaypro\r\n", disk.getLabel());
        assertEquals(2, disk.getNumSides());
        assertEquals(40, disk.getNumTracks());
        assertEquals(10, disk.getNumSectors(0, 10)); // This is the physical number of sectors on each side.
        assertEquals(512, disk.getSectorSize(0, 10));

        assertTrue(disk.isMFM(0, 1)); // Side 0, Track 1
        assertTrue(disk.isMFM(0, 18)); // Side 0, Track 18

        assertTrue(disk.isBadSector(0, 0, 1));
        assertTrue(disk.isBadSector(0, 0, 11));
        assertFalse(disk.isBadSector(0, 0, 2));

        byte[] sector = disk.readSector(0, 0, 12);
        assertEquals(0x00, sector[0]);
        assertEquals(0x55, sector[1]);
        assertEquals(0x4E, sector[2]);

        assertEquals(300, disk.getTransferRate(0, 10));

        exception.expect(IOException.class);
        exception.expectMessage("No such sector on disk");

        // There is no logical track 1
        sector = disk.readSector(1, 0, 0);
    }

    @Test
    public void readUnavailSector() throws IOException {
        IMDHandler disk = new IMDHandler(diskPath("SBASIC.imd"));

        exception.expect(IOException.class);
        exception.expectMessage("Sector unavailable");

        // Read an unavailable sector
        byte[] sector = disk.readSector(0, 0, 11);
    }

    @Test
    public void openBadDisk() throws IOException {
        exception.expect(IOException.class);
        exception.expectMessage("Bad file format");

        IMDHandler disk = new IMDHandler(diskPath("virtdisk1"));
    }

    /**
    /**
     * Read XDOS disk with 40 tracks and 16 sectors/track.
     * FM formatted. The sectors are numbered 1-16.
     */
    @Test
    public void readXDOSImd() throws IOException {
        IMDHandler disk = new IMDHandler(diskPath("xdos-games.imd"));
        assertEquals("IMD 1.17: 11/07/2018  8:37:52", disk.getHeader());
        assertEquals("EXORSET 30\r\n"
                    + "\r\n"
                    + "DISQUE DE JEUX\r\n"
                    + "\r\n"
                    + "OTHELLO.CM VIE.CM\r\n"
                    + "COMPTE.CM ALPHA.CM\r\n"
                    + "\r\n"
                    + "JB Emond 2018\r\n", disk.getLabel());
        assertEquals(1, disk.getNumSides());
        assertEquals(40, disk.getNumTracks());
        assertEquals(16, disk.getNumSectors(0, 10));
        assertEquals(128, disk.getSectorSize(0, 10));
        assertEquals(250, disk.getTransferRate(0, 10));

        assertFalse(disk.isMFM(0, 0)); // Side 0, Track 0
        assertFalse(disk.isMFM(0, 1)); // Side 0, Track 1

        byte[] sector;

        sector = disk.readSector(0, 0, 1);
        assertEquals('D', sector[0]);
        assertEquals('O', sector[1]);
        assertEquals('S', sector[2]);

        exception.expect(IOException.class);
        exception.expectMessage("No such sector on disk");

        // This one throws IOException
        sector = disk.readSector(0, 0, 0);
        assertEquals(0x00, sector[0]);
        assertEquals(0x03, sector[1]);
        assertEquals(0x20, sector[2]);

    }

    @Test
    public void updateXDOSImd() throws IOException {
        IMDHandler disk = new IMDHandler(diskPath("xdos-games.imd"));
        byte[] sector;
        sector = disk.readSector(0, 8, 1);
        assertEquals(128, sector.length);
        assertEquals(0x04, sector[0]);
        assertEquals(0x20, sector[1]);

        byte[] data = new byte[128];
        for (int i = 0; i < 128; i++) {
            data[i] = (byte)i;
        }

        // Writing to uncompressed sector
        disk.writeSector(0, 8, 1, data);
        sector = disk.readSector(0, 8, 1);
        assertEquals(0x00, sector[0]);
        assertEquals(0x01, sector[1]);

        // Writing to compressed sector
        disk.writeSector(0, 0, 16, data);
        sector = disk.readSector(0, 0, 16);
        assertEquals(0x00, sector[0]);
        assertEquals(0x01, sector[1]);

        for (int i = 0; i < 128; i++) {
            data[i] = 'X';
        }

        // Writing to uncompressed sector
        disk.writeSector(0, 8, 1, data);
        sector = disk.readSector(0, 8, 1);
        assertEquals('X', sector[0]);
        assertEquals('X', sector[1]);

        // Writing to compressed sector
        disk.writeSector(0, 15, 1, data);
        sector = disk.readSector(0, 8, 1);
        assertEquals('X', sector[0]);
        assertEquals('X', sector[1]);

        disk.saveDisk(diskPath("savexdos.imd"));
    }

    @Test
    public void readSimUtilsImd() throws IOException {
        IMDHandler disk = new IMDHandler(diskPath("simutils.imd"));
        assertEquals("IMD 1.18: 15/ 9/2018 11:00:17", disk.getHeader());
        assertEquals(2, disk.getNumSides());
        assertEquals(35, disk.getNumTracks());

        assertEquals(9, disk.getNumSectors(1, 1));

        // Side 0, Track 0
        assertEquals(16, disk.getNumSectors(0, 0));
        assertEquals(128, disk.getSectorSize(0, 0));
        assertEquals(250, disk.getTransferRate(0, 0));
        assertFalse(disk.isMFM(0, 0));

        // Side 1, Track 0
        assertEquals(16, disk.getNumSectors(1, 0));
        assertEquals(256, disk.getSectorSize(1, 0));
        assertTrue(disk.isMFM(1, 0));
        assertEquals(500, disk.getTransferRate(1, 0));

        // Side 0, Track 1
        assertEquals(9, disk.getNumSectors(0, 1));
        assertEquals(512, disk.getSectorSize(0, 1));
        assertEquals(500, disk.getTransferRate(0, 1));
        assertTrue(disk.isMFM(0, 1));

        // Side 0 track 10
        assertEquals(512, disk.getSectorSize(0, 10));
        assertEquals(500, disk.getTransferRate(0, 10));

        exception.expect(IOException.class);
        exception.expectMessage("Bad size of buffer");

        // Write a sector that is mismatched in size
        byte[] data = new byte[128];
        for (int i = 0; i < 128; i++) {
            data[i] = (byte)i;
        }
        disk.writeSector(0, 10, 6, data);

    }

}
