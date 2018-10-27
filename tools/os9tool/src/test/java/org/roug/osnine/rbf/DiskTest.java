package org.roug.osnine.rbf;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertNotNull;
import org.junit.Before;
import org.junit.Test;
import org.junit.Rule;
import org.junit.rules.ExpectedException;
import java.io.IOException;

public class DiskTest {

    private Disk disk;

    @Before
    public void mapDisk() throws Exception {
        String resourcefile = DiskTest.class.getClassLoader().getResource("OS9-SYSTEM.dsk").getFile();
        disk = new Disk(resourcefile);
        assertNotNull(disk);
    }

    @Rule
    public ExpectedException exception = ExpectedException.none();

    /**
     * Get the root LSN of the disk.
     */
    @Test
    public void rootLSN() throws Exception {
        assertEquals(0x12, disk.getRootLSN());
    }

    /**
     * Get the FileDescriptor of the root directory.
     */
    @Test
    public void getFDForRoot() throws Exception {
        FileDescriptor fd = new FileDescriptor();
        fd = disk.readFileDescriptor(0x12);
        assertEquals(0xBF, fd.getAttributes());
        assertEquals(0x140, fd.getSize());
    }

    /**
     * Get the LSN of the CMDS directory.
     */
    @Test
    public void getLSNforCMDS() throws Exception {
        assertEquals(0x4E, disk.getLSNForPath("CMDS"));
    }

    /**
     * Get the LSN of the CMDS directory.
     */
    @Test
    public void getLSNforSlashCMDS() throws Exception {
        assertEquals(0x4E, disk.getLSNForPath("/CMDS"));
    }

    /**
     * Get the LSN of the CMDS directory.
     */
    @Test
    public void getLSNforDir() throws Exception {
        assertEquals(0xD4, disk.getLSNForPath("/CMDS/dir"));
    }

    /**
     * Get the LSN of the top directory.
     */
    @Test
    public void getLSNforEmpty() throws Exception {
        assertEquals(0x12, disk.getLSNForPath(""));
    }

    /**
     * Get the LSN of the top directory.
     */
    @Test
    public void getLSNforSlash() throws Exception {
        assertEquals(0x12, disk.getLSNForPath("/"));
    }

    /**
     * Get the LSN for some positions in the CMDS directory.
     * The directory is 0x06A0 bytes long.
     */
    @Test
    public void getLSNforPosition() {
        FileDescriptor fd = disk.readFileDescriptor(0x4E);
        //RBFDirectory pathDesc = new RBFDirectory(disk, fd, 0x80);
        int p = fd.getLSNFromPosition(0);
        assertEquals(0x4F, p);

        p = fd.getLSNFromPosition(0x200);
        assertEquals(0x51, p);

        p = fd.getLSNFromPosition(0x700);
        assertEquals(-1, p);
    }

    /**
     * Load the startup file.
     * Content:
     * printerr /d0/sys/errmsg
     * setime &lt;/term
     */
    @Test
    public void getStartupFile() throws IOException {
        RBFInputStream is = disk.openFile("startup");
        int c = is.read();
        assertEquals('p', c);
        c = is.read();
        assertEquals('r', c);
        byte[] buffer = new byte[200];
        int size = is.read(buffer);
        assertEquals(36, size);
        String b = new String(buffer, 0, size);
        assertEquals("interr /d0/sys/errmsg\rsetime </term\r", b);
        is.close();
    }

    /**
     * Open the CMDS directory.
     */
    @Test
    public void getCmdsDirectory() throws IOException {
        RBFDirectory d = disk.openDirectory("CMDS");
        DirEntry de = null;
        for (int i = 0; i < 15; i++) {
            de = d.readNextDirEntry();
        }
        assertEquals("dir", de.getName());
    }

    /**
     * Open the startup file as a directory.
     * Must cause an exception.
     */
    @Test
    public void openStartupAsDirectory() throws IOException {
        exception.expect(RuntimeException.class);
        RBFDirectory d = disk.openDirectory("startup");
    }

    /**
     * Open the CMDS directory as a file.
     * Must cause an exception.
     */
    @Test
    public void openCMDSAsFile() throws IOException {
        exception.expect(RuntimeException.class);
        RBFInputStream is = disk.openFile("CMDS");
    }
}
