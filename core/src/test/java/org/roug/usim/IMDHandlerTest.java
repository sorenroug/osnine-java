package org.roug.usim;

import java.io.File;
import java.io.IOException;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import org.junit.Test;

// OS9_V1.2.imd
public class IMDHandlerTest {

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
        assertEquals("IMD 1.18: 14/07/2014 11:05:31\r\nos-9 gmx I v 1.2\r\n", img.getLabel());
    }

}
