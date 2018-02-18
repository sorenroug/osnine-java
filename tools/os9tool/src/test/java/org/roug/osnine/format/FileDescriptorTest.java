package org.roug.osnine.format;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertNotNull;
import org.junit.Before;
import org.junit.Test;

public class FileDescriptorTest {


    @Test
    public void simple() throws Exception {
        FileDescriptor fd = new FileDescriptor();
        assertNotNull(fd);
        fd.setAttributes(0x1F);

        Segment segment = new Segment();
        segment.lsn = 200;
        segment.num = 8;
        fd.addSegment(segment);

        byte[] sector = fd.getSector();
        assertEquals(256, sector.length);

        assertEquals(0, sector[0x10]);  // Test the lsn
        assertEquals(0, sector[0x11]);  // Test the lsn
        assertEquals(200, sector[0x12] & 0xFF);  // Test the lsn
        assertEquals(0, sector[0x13]);  // Test the size
        assertEquals(8, sector[0x14]);  // Test the size
    }

}
