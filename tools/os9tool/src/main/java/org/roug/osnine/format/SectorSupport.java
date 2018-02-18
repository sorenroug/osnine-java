package org.roug.osnine.format;

import java.time.LocalDateTime;
import java.util.Arrays;

/**
 * Support methods for writing sector content.
 * 
 */
public class SectorSupport {


    /** Buffer to build disk. ID Sector + allocation map + root directory */
    private byte[] sector = new byte[256];

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

}
