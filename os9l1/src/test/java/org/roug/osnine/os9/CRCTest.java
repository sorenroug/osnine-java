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
     * 46 bytes from a device descriptor.
     */
    private static final byte[] D0_OCTETS = {
            (byte)0x87, (byte)0xcd, 0x00, 0x2e, 0x00, 0x21, (byte)0xf1, (byte)0x81,
            (byte)0xca, 0x00, 0x23, 0x00, 0x26, (byte)0xff, (byte)0xff, (byte)0xff,
            0x40, 0x0f, 0x01, 0x00, 0x00, 0x20, 0x01, 0x00, 
            0x28, 0x01, 0x00, 0x00, 0x12, 0x00, 0x12, 0x02,
            0x08, 0x44, (byte)0xb0, 0x52, 0x42, (byte)0xc6, 0x44, 0x44,
            0x69, 0x73, (byte)0xeb, (byte)0xdc, 0x36, 0x1c };

    /**
     * Test empty array.
     */
    @Test
    public void nullSize() {
        long crc = OS9.CRC24_SEED;
        byte[] octets = { 0 };
        OS9 cpu = new OS9();
        long result = cpu.compute_crc(crc, octets, 0);
        assertEquals(OS9.CRC24_SEED, result);
    }

    /**
     * Test empty array.
     */
    @Test
    public void nullByte() {
        long crc = OS9.CRC24_SEED;
        byte[] octets = { 0 };
        OS9 cpu = new OS9();
        long result = cpu.compute_crc(crc, octets, 1);
        assertEquals(0xFFC13EL, result);
    }

    /**
     * Test D0.
     */
    @Test
    public void testD0() {
        long crc = OS9.CRC24_SEED;
        OS9 cpu = new OS9();
        long result = cpu.compute_crc(crc, D0_OCTETS, D0_OCTETS.length);
        assertEquals(OS9.CRC24_CHCK, result);
    }

    /**
     * Test D0.
     */
    @Test
    public void testD0WithSysCall() {
        OS9 cpu = new OS9();
        int LOCATION = 0x600;
	int CRCACCUM = 0xB00;
        for (int i = 0; i < D0_OCTETS.length; i++) {
            cpu.write(i + LOCATION, D0_OCTETS[i]);
        }
        cpu.write(CRCACCUM, 0xFF);
        cpu.write(CRCACCUM + 1, 0xFF);
        cpu.write(CRCACCUM + 2, 0xFF);
        cpu.x.set(LOCATION);
        cpu.u.set(CRCACCUM);
        cpu.y.set(D0_OCTETS.length);
        cpu.f_crc();
        assertEquals(0x80, cpu.read(CRCACCUM));
        assertEquals(0x0F, cpu.read(CRCACCUM + 1));
        assertEquals(0xE3, cpu.read(CRCACCUM + 2));
    }

    /**
     * Test D0.
     */
    @Test
    public void calcD0WithSysCall() {
        OS9 cpu = new OS9();
        int LOCATION = 0x600;
	int CRCACCUM = 0xB00;
        for (int i = 0; i < D0_OCTETS.length - 3; i++) {
            cpu.write(i + LOCATION, D0_OCTETS[i]);
        }
        cpu.write(CRCACCUM, 0xFF);
        cpu.write(CRCACCUM + 1, 0xFF);
        cpu.write(CRCACCUM + 2, 0xFF);
        cpu.x.set(LOCATION);
        cpu.u.set(CRCACCUM);
        cpu.y.set(D0_OCTETS.length - 3);
        cpu.f_crc();
        assertEquals(0xDC ^ 0xFF, cpu.read(CRCACCUM));
        assertEquals(0x36 ^ 0xFF, cpu.read(CRCACCUM + 1));
        assertEquals(0x1C ^ 0xFF, cpu.read(CRCACCUM + 2));
    }

}
