package org.roug.osnine;

import java.io.File;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import org.junit.Test;

public class ParaVirtDiskTest {

    private File virtdisk;

    private File diskPath(String fileName) {
        String dir = System.getProperty("storage.dir");
        assertNotNull(dir);
        return new File(dir, fileName);
    }

    @Test(expected = IllegalArgumentException.class)
    public void oversizeMemoryBank() throws Exception {
        ParaVirtDisk mb = new ParaVirtDisk(70000, diskPath("paravirtdisk"));
    }

    @Test
    public void addToBuffer() throws Exception {
        int base = 10000;

        ParaVirtDisk mb = new ParaVirtDisk(base, diskPath("paravirtdisk"));
        mb.store(base + ParaVirtDisk.BYTE_VALUE, 65);
        mb.store(base + ParaVirtDisk.BYTE_ADDR, 0);
        mb.store(base + ParaVirtDisk.BYTE_OPCODE, ParaVirtDisk.COPY_BYTE);

        mb.store(base + ParaVirtDisk.BYTE_VALUE, 67);
        mb.store(base + ParaVirtDisk.BYTE_ADDR, 1);
        mb.store(base + ParaVirtDisk.BYTE_OPCODE, ParaVirtDisk.COPY_BYTE);

        //mb.store(base + ParaVirtDisk.BYTE_VALUE, 65);
        mb.store(base + ParaVirtDisk.BYTE_ADDR, 0);
        mb.store(base + ParaVirtDisk.BYTE_OPCODE, ParaVirtDisk.READ_BYTE);
        int result = mb.load(base + ParaVirtDisk.BYTE_VALUE);
        assertEquals(65, result);
    }

    @Test
    public void writeBuffer() throws Exception {
        int base = 10000;

        ParaVirtDisk mb = new ParaVirtDisk(base, diskPath("virtdisk1"));
        for (int i = 0 ; i < 256; i++) {
            mb.store(base + ParaVirtDisk.BYTE_ADDR, i);
            mb.store(base + ParaVirtDisk.BYTE_VALUE, 64 + (i % 32));
            mb.store(base + ParaVirtDisk.BYTE_OPCODE, ParaVirtDisk.COPY_BYTE);
        }

        mb.store(base + ParaVirtDisk.BYTE_ADDR, 0);
        mb.store(base + ParaVirtDisk.BYTE_VALUE, 1);
        mb.store(base + ParaVirtDisk.BYTE_OPCODE, ParaVirtDisk.WRITE_BUFFER);
    }

}

