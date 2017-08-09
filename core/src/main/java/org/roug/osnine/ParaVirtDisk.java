package org.roug.osnine;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Paravirtualized block device.
 * It requires a special OS9 device driver to work.
 * Operations:
 * To read a buffer do:
 *  Write the LSN value into the bufferAddress and valueRegister. This can be
 *  done with a write_word(). Write READ_BUFFER into the OPCODE register.
 *  This will load a sector and reset the bufferAddress to 0.
 *  Read the OPCODE register to check for errors.
 *  Write READ_BYTE in to OPCODE register. This will place a byte from the
 *  buffer into the valueRegister and increment the bufferRegister.
 *
 */
public class ParaVirtDisk extends MemorySegment {

    private static final Logger LOGGER = LoggerFactory.getLogger(ParaVirtDisk.class);

    private static final int LSN_SIZE = 256;
    private static final int BYTE_SIZE = 256;

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

    /** Filename of disk image. */
    private File diskFile;

    /** Open file pointer to disk image. */
    private RandomAccessFile diskFP;

    /** current value in buffer and also LSB of sector address. */
    private int valueRegister;

    /** Offset in buffer. 0-256 */
    private int bufferAddress;

    private int errorCode;

    /** Buffer for sector to read/write */
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
        this.diskFile = diskFile;
        diskFP = new RandomAccessFile(diskFile, "rw");
    }

    @Override
    protected int load(int addr) {
        switch (addr - getStartAddress()) {
        case BYTE_OPCODE: // operation 
            return errorCode;
        case BYTE_ADDR: // buffer address
            return bufferAddress;
        case BYTE_VALUE:
            //LOGGER.debug("Load address {} <- {}", addr, valueRegister);
            return valueRegister;
        default:
            return -1;
        }
    }

    @Override
    protected void store(int addr, int val) {
        errorCode = 0;
        switch (addr - getStartAddress()) {
        case BYTE_VALUE:
            valueRegister = val & 0xFF;
            break;
        case BYTE_ADDR:
            bufferAddress = val & 0xFF;
            LOGGER.debug("Set buffer address {}", bufferAddress);
            break;
        case BYTE_OPCODE:
            switch (val) {
            case COPY_BYTE:
                // Copy byte to buffer and increment the index.
                buffer[bufferAddress] = (byte) valueRegister;
                bufferAddress++;
                if (bufferAddress >= LSN_SIZE) bufferAddress = 0;
                break;
            case WRITE_BUFFER:
                writeLSN();
                break;
            case READ_BUFFER:
                readLSN();
                break;
            case READ_BYTE:
                valueRegister = buffer[bufferAddress];
                bufferAddress++;
                if (bufferAddress >= LSN_SIZE) bufferAddress = 0;
                break;
            case RESET_REGS:
                reset();
                break;
            default:
                break;
            }
            break;
        }
    }

    /*
     * Why is there a public method in the abstract class?
     */
    private void reset() {
        bufferAddress = 0;
        valueRegister = 0;
        errorCode = 0;
    }

    /**
     * Write the 256 byte buffer to logical sector address.
     */
    private void writeLSN() {
        int lsn = bufferAddress * BYTE_SIZE + valueRegister;
        bufferAddress = 0;
        LOGGER.debug("Write sector {}", lsn);
        try {
            diskFP.seek(lsn * LSN_SIZE);
            diskFP.write(buffer);
        } catch (IOException e) {
            errorCode = 1;
        }
    }

    private void readLSN() {
        int lsn = bufferAddress * BYTE_SIZE + valueRegister;
        LOGGER.debug("Read sector {}", lsn);
        bufferAddress = 0;
        try {
            diskFP.seek(lsn * LSN_SIZE);
            int readResult = diskFP.read(buffer);
            if (readResult != LSN_SIZE) {
                errorCode = 2;
            }
        } catch (IOException e) {
            LOGGER.error("IO error reading sector {}", lsn);
            errorCode = 1;
        }
    }
}
