package org.roug.osnine;

import java.io.File;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import org.junit.Test;

public class VirtualDiskTest {

    private File virtdisk;

    private File diskPath(String fileName) {
        String dir = System.getProperty("storage.dir");
        assertNotNull(dir);
        return new File(dir, fileName);
    }

    @Test
    public void oversizeMemoryBank() throws Exception {
        VirtualDisk mb = new VirtualDisk(70000, null);
        mb.setDisk(diskPath("paravirtdisk"));
    }

    @Test
    public void addToBuffer() throws Exception {
        int base = 10000;

        VirtualDisk mb = new VirtualDisk(base, null);
        mb.setDisk(diskPath("paravirtdisk"));
        mb.store(base + VirtualDisk.BYTE_VALUE, 65);
        mb.store(base + VirtualDisk.BYTE_ADDR, 0);
        mb.store(base + VirtualDisk.BYTE_OPCODE, VirtualDisk.COPY_BYTE);

        mb.store(base + VirtualDisk.BYTE_VALUE, 67);
        mb.store(base + VirtualDisk.BYTE_ADDR, 1);
        mb.store(base + VirtualDisk.BYTE_OPCODE, VirtualDisk.COPY_BYTE);

        //mb.store(base + VirtualDisk.BYTE_VALUE, 65);
        mb.store(base + VirtualDisk.BYTE_ADDR, 0);
        mb.store(base + VirtualDisk.BYTE_OPCODE, VirtualDisk.READ_BYTE);
        int result = mb.load(base + VirtualDisk.BYTE_VALUE);
        assertEquals(65, result);
    }

    @Test
    public void writeBuffer() throws Exception {
        int base = 10000;

        VirtualDisk mb = new VirtualDisk(base, null);
        mb.setDisk(diskPath("virtdisk1"));
        for (int i = 0 ; i < 256; i++) {
            mb.store(base + VirtualDisk.BYTE_ADDR, i);
            mb.store(base + VirtualDisk.BYTE_VALUE, 64 + (i % 32));
            mb.store(base + VirtualDisk.BYTE_OPCODE, VirtualDisk.COPY_BYTE);
        }

        // Store in LSN 1 (0-based)
        mb.store(base + VirtualDisk.BYTE_ADDR, 0);
        mb.store(base + VirtualDisk.BYTE_VALUE, 1);
        mb.store(base + VirtualDisk.BYTE_OPCODE, VirtualDisk.WRITE_BUFFER);
    }

}

