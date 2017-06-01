package org.roug.osnine;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Paravirtualized block device. UNFINISHED.
 * It requires a special OS9 device driver to work
 */
public class ParaVirtDisk extends MemorySegment {

    private static final Logger LOGGER = LoggerFactory.getLogger(ParaVirtDisk.class);

    private static final int LSN_SIZE = 256;

    /* It must be possible to do a word write to set the LSN in the device. */

    public static final int BYTE_OPCODE = 0;

    /** Location of address relative to offset. */
    public static final int BYTE_ADDR = 1;

    /** Value to write to/read from buffer. */
    public static final int BYTE_VALUE = 2;

    public static final int COPY_BYTE = 1;
    public static final int WRITE_BUFFER = 2;
    public static final int READ_BUFFER = 3;
    public static final int READ_BYTE = 4;
    public static final int RESET_REGS = 5;

    /** Location of chip in memory. */
    private int offset;

    /** Filename of disk image. */
    private File diskFile;

    /** Open file pointer to disk image. */
    private RandomAccessFile diskFP;

    /** current value in buffer and also LSB of sector address. */
    private int valBuffer;

    /** Offset in buffer. 0-256 */
    private int bufferAddress;

    private int errorCode;

    private byte[] buffer = new byte[LSN_SIZE];

    /**
     * Constructor.
     */
    public ParaVirtDisk(int start, String fileName) throws FileNotFoundException {
        this(start, new File(fileName));
    }

    /**
     * Constructor.
     */
    public ParaVirtDisk(int start, File diskFile) throws FileNotFoundException {
        super(start, start + 3);
        this.offset = start;
        this.diskFile = diskFile;
        diskFP = new RandomAccessFile(diskFile, "rw");
    }

    @Override
    public void reset() {
    }

    @Override
    protected int load(int addr) {
        LOGGER.debug("Load address {}", addr);
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
        LOGGER.debug("Store address {} -> {}", addr, val);
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
                // Copy byte to buffer and increment the index.
                buffer[bufferAddress] = (byte) valBuffer;
                bufferAddress++;
                bufferAddress &= 0xFF;
                break;
            case WRITE_BUFFER:
                try {
                    writeLSN(bufferAddress * LSN_SIZE + valBuffer);
                    bufferAddress = 0;
                } catch (IOException e) {
                    errorCode = 1;
                }
                break;
            case READ_BUFFER:
                try {
                    readLSN(bufferAddress * LSN_SIZE + valBuffer);
                    bufferAddress = 0;
                } catch (IOException e) {
                    errorCode = 1;
                }
                break;
            case READ_BYTE:
                valBuffer = buffer[bufferAddress];
                bufferAddress++;
                bufferAddress &= 0xFF;
                break;
            case RESET_REGS:
                bufferAddress = 0;
                valBuffer = 0;
                errorCode = 0;
                break;
            default:
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
