package org.roug.osnine.os9;

import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.ByteArrayInputStream;
import java.io.InputStream;

import static org.junit.Assert.assertEquals;
import org.junit.Before;
import org.junit.Test;

/**
 */
public class PDStdInTest {

    private static final String seed = "Hello world\nAre you there?\nNo!\n";

    private PDStdIn pd;

    @Before
    public void setUp() {
        InputStream inputfd = new ByteArrayInputStream(seed.getBytes());
        pd = new PDStdIn(inputfd);
    }

    @Test
    public void testRead() {
        byte[] buf = new byte[100];
        int len = pd.read(buf, 10);
        assertEquals(10, len);
    }

    @Test
    public void testReadLines() {
        byte[] buf = new byte[100];
        int len;

        len = pd.readln(buf, 100);
        assertEquals(12, len);
        assertEquals("Hello world\r", new String(buf, 0, len));

        len = pd.readln(buf, 100);
        assertEquals(15, len);
        assertEquals("Are you there?\r", new String(buf, 0, len));

        len = pd.readln(buf, 100);
        assertEquals(4, len);
        assertEquals("No!\r", new String(buf, 0, len));
    }
}
