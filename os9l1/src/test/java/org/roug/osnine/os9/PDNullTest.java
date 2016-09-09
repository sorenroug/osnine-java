package org.roug.osnine.os9;

import java.io.IOException;
import static org.junit.Assert.assertEquals;
import org.junit.Test;

/**
 * Test memory allocations for programs and data.
 */
public class PDNullTest {

    @Test
    public void testRead() {
        PDNull pd = new PDNull();
        byte[] buf = new byte[100];
        int len = pd.read(buf, 10);
        assertEquals(0, len);
    }
}
