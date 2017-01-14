package org.roug.osnine.os9;

import java.io.IOException;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import org.junit.Test;

/**
 * Test loading of files into memory.
 */
public class CRCTest {

    /**
     * Test empty array.
     */
    @Test
    public void nullSize() {
        long crc = 0xFFFFFFL;
        byte[] octets = { 0 };
        OS9 cpu = new OS9();
        long result = cpu.compute_crc(crc, octets, 0);
        assertEquals(0xFFFFFFL, crc);
    }

    /**
     * Test empty array.
     */
    @Test
    public void nullByte() {
        long crc = 0xFFFFFFL;
        byte[] octets = { 0 };
        OS9 cpu = new OS9();
        long result = cpu.compute_crc(crc, octets, 1);
        assertEquals(0xFFFFFFL, crc);
    }

}
