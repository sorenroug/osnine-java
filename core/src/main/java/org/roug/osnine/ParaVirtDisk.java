package org.roug.osnine;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;

/**
 * Paravirtualized block device. UNFINISHED.
 * It requires a special OS9 device driver to work
 */
public class ParaVirtDisk extends MemorySegment {

    private static final int LSN_SIZE = 256;

    public static final int BYTE_VALUE = 0;
    public static final int BYTE_ADDR = 1;
    public static final int BYTE_OPCODE = 2;

    public static final int COPY_BYTE = 1;
    public static final int WRITE_BUFFER = 2;
    public static final int READ_BUFFER = 3;
    public static final int READ_BYTE = 4;

    /** Location of chip in memory. */
    private int offset;

    /** Filename of disk image. */
    private File diskFile;

    /** Open file pointer to disk image. */
    private RandomAccessFile diskFP;

    private int valBuffer;

    private int bufferAddress;

    private int errorCode;

    private byte[] buffer = new byte[LSN_SIZE];

    /**
     * Constructor.
     */
    public ParaVirtDisk(int start, File diskFile) throws FileNotFoundException {
        super(start, start + 2);
        this.offset = start;
        this.diskFile = diskFile;
        diskFP = new RandomAccessFile(diskFile, "rw");
    }

    @Override
    public void reset() {
    }

    @Override
    protected int load(int addr) {
        switch (addr - offset) {
        case BYTE_VALUE:
            return valBuffer;
        case BYTE_ADDR: // buffer address
            return bufferAddress;
        case BYTE_OPCODE: // operation 
            return errorCode;
        default:
            return -1;
        }
    }

    @Override
    protected void store(int addr, int val) {
        errorCode = 0;
        switch (addr - offset) {
        case BYTE_VALUE:
            valBuffer = val;
            break;
        case BYTE_ADDR:
            bufferAddress = val;
            break;
        case BYTE_OPCODE:
            switch (val) {
            case COPY_BYTE:
                // Copy byte to buffer
                buffer[bufferAddress] = (byte) valBuffer;
                break;
            case WRITE_BUFFER:
                try {
                    writeLSN(bufferAddress * LSN_SIZE + valBuffer);
                } catch (IOException e) {
                    errorCode = 1;
                }
                break;
            case READ_BUFFER:
                try {
                    readLSN(bufferAddress * LSN_SIZE + valBuffer);
                } catch (IOException e) {
                    errorCode = 1;
                }
                break;
            case READ_BYTE:
                valBuffer = buffer[bufferAddress];
                break;
            }
            break;
        }
    }

    /**
     * Write the 256 byte buffer to logical sector address.
     */
    private void writeLSN(int lsn) throws IOException {
        diskFP.seek(lsn * LSN_SIZE);
        diskFP.write(buffer);
    }

    private void readLSN(int lsn) throws IOException {
        diskFP.seek(lsn * LSN_SIZE);
        diskFP.read(buffer);
    }
}
