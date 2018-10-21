package org.roug.osnine.rbf;

import java.time.LocalDateTime;
import java.util.Arrays;

/**
 * Support methods for writing sector content.
 * 
 */
public class SectorSupport {

    private final static int SECTORSIZE = 256;

    private byte[] sector = new byte[SECTORSIZE];

    /**
     * Constructor.
     */
    public SectorSupport() {
        for(int i = 0; i < SECTORSIZE; i++) {
            sector[i] = 0;
        }
    }

    /**
     * Constructor.
     */
    public SectorSupport(byte[] source) {
        for(int i = 0; i < SECTORSIZE; i++) {
            sector[i] = source[i];
        }
    }

    protected byte[] getSector() {
        return sector;
    }

    protected void writeByte(int location, int value) {
        sector[location] = (byte) (value & 0xff);
    }

    protected void writeWord(int location, int value) {
        byte highByte = (byte) ((value >> 8) & 0xff);
        sector[location] = highByte;
        byte lowByte = (byte) (value & 0xff);
        sector[location + 1] = lowByte;
    }

    /**
     * Write a value in 3 bytes into sector.
     */
    protected void writeTriple(int location, int value) {
        byte byteValue = (byte) ((value >> 16) & 0xff);
        sector[location++] = byteValue;
        byteValue = (byte) ((value >> 8) & 0xff);
        sector[location++] = byteValue;
        byteValue = (byte) (value & 0xff);
        sector[location++] = byteValue;
    }

    protected void writeDWord(int location, int value) {
        byte byteValue = (byte) ((value >> 24) & 0xff);
        sector[location++] = byteValue;
        byteValue = (byte) ((value >> 16) & 0xff);
        sector[location++] = byteValue;
        byteValue = (byte) ((value >> 8) & 0xff);
        sector[location++] = byteValue;
        byteValue = (byte) (value & 0xff);
        sector[location++] = byteValue;
    }

    protected void writeString(int location, String name) {
        byte[] nameBytes = name.getBytes();

        for (int i = 0; i < nameBytes.length; i++) {
            sector[location + i] = nameBytes[i];
        }
        sector[location + nameBytes.length - 1] |= 0x80;
    }

    protected void writeDate(int location) {
        LocalDateTime ldt = LocalDateTime.now();
        writeByte(location, ldt.getYear() - 1900);
        writeByte(location + 1, ldt.getMonthValue());
        writeByte(location + 2, ldt.getDayOfMonth());
    }

    protected void writeDateTime(int location) {
        LocalDateTime ldt = LocalDateTime.now();
        writeByte(location, ldt.getYear() - 1900);
        writeByte(location + 1, ldt.getMonthValue());
        writeByte(location + 2, ldt.getDayOfMonth());
        writeByte(location + 3, ldt.getHour());
        writeByte(location + 4, ldt.getMinute());
    }

    byte readByte(int location) {
        return (byte)(sector[location] & 0xff);
    }

    int readWord(int location) {
        return (sector[location] & 0xff) << 8
                | (sector[location + 1] & 0xff);
    }

    int readTriple(int location) {
        return (sector[location] & 0xff) << 16
                | (sector[location + 1] & 0xff) << 8
                | (sector[location + 2] & 0xff);
    }

    int readQuad(int location) {
        return    (sector[location] & 0xff) << 24
                | (sector[location + 1] & 0xff) << 16
                | (sector[location + 2] & 0xff) << 8
                | (sector[location + 3] & 0xff);
    }

}
