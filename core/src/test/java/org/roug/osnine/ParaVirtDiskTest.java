package org.roug.osnine;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class ParaVirtDiskTest {

    @Test(expected = IllegalArgumentException.class)
    public void oversizeMemoryBank() throws Exception {
        ParaVirtDisk mb = new ParaVirtDisk(70000, "paravirtdisk");
    }

    @Test
    public void addToBuffer() throws Exception {
        int base = 10000;

        ParaVirtDisk mb = new ParaVirtDisk(base, "paravirtdisk");
        mb.store(base + ParaVirtDisk.BYTE_VALUE, 65);
        mb.store(base + ParaVirtDisk.BYTE_ADDR, 0);
        mb.store(base + ParaVirtDisk.BYTE_OPCODE, ParaVirtDisk.COPY_BYTE);

        mb.store(base + ParaVirtDisk.BYTE_VALUE, 67);
        mb.store(base + ParaVirtDisk.BYTE_ADDR, 1);
        mb.store(base + ParaVirtDisk.BYTE_OPCODE, ParaVirtDisk.COPY_BYTE);

        mb.store(base + ParaVirtDisk.BYTE_VALUE, 65);
        mb.store(base + ParaVirtDisk.BYTE_ADDR, 0);
        mb.store(base + ParaVirtDisk.BYTE_OPCODE, ParaVirtDisk.READ_BYTE);
        int result = mb.load(base + ParaVirtDisk.BYTE_VALUE);
    }

}

