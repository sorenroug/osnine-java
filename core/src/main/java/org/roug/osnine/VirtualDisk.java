package org.roug.osnine;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.Arrays;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Virtualized block device. Takes 3 bytes of memory.
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
 * The class can handle 4 individual disk. The disk selection is the upper
 * two bits of the opcode value.
 *
 */
public class VirtualDisk extends MemorySegment {

    private static final Logger LOGGER = LoggerFactory.getLogger(VirtualDisk.class);

    private static final int LSN_SIZE = 256;
    private static final int BYTE_SIZE = 256;

    /* It must be possible to do a word write to set the LSN in the device. */

    public static final int BYTE_OPCODE = 0;

    /** Location of address relative to offset. */
    public static final int BYTE_ADDR = 1;

    /** Value to write to/read from buffer. */
    public static final int BYTE_VALUE = 2;

    /** Opcodes. */
    public static final int COPY_BYTE = 1;
    public static final int WRITE_BUFFER = 2;
    public static final int READ_BUFFER = 3;
    public static final int READ_BYTE = 4;
    public static final int RESET_REGS = 5;

    /** No Error. */
    public static final int NO_ERROR = 0;

    /** Write protected. */
    private static final int E_WP = 242;
    private static final int E_READ = 244;
    private static final int E_WRITE = 245;
    private static final int E_NOTRDY = 246;

    /** Open file pointer to disk image. */
    private RandomAccessFile[] diskFP = new RandomAccessFile[4];
    private File[] diskFiles = new File[4];
    private boolean writeProtected[] = new boolean[4];

    /** current value in buffer and also LSB of sector address. */
    private int valueRegister;

    /** Offset in buffer. 0-256 */
    private int bufferAddress;

    private int errorCode;

    /** Buffer for sector to read/write */
    private byte[] buffer = new byte[LSN_SIZE];

    /** Reference to CPU for the purpose of sending IRQ. */
    private Bus8Motorola bus;

    /**
     * Open a virtual disk.
     *
     * @param start - First address location of the device.
     * @param bus - The bus the device is attached to.
     * @param args - additional arguments
     * @throws FileNotFoundException if the disk file does not exist
     * @throws IOException if the disk can't be opened.
     */
    public VirtualDisk(int start, Bus8Motorola bus, String... args)
                    throws FileNotFoundException, IOException {
        super(start, start + 3);
        this.bus = bus;
        for (int a = 0; a < args.length && a < 4; a++) {
            setDisk(a, args[a]);
        }
    }

    /**
     * Provide file name of disk.
     *
     * @param fileName the name of the file.
     * @throws FileNotFoundException if the disk file does not exist
     * @throws IOException if the disk can't be opened.
     */
    private void setDisk(int diskId, String fileName)
                    throws FileNotFoundException, IOException {
        File diskFile = new File(fileName);
        setDisk(diskId, diskFile);
    }

    public void removeDisk(int diskId)
                    throws FileNotFoundException, IOException {
        if (diskFP[diskId] != null) {
            diskFiles[diskId] = null;
            diskFP[diskId].close();
            diskFP[diskId] = null;
        }
    }

    public void setDisk(File diskFile)
                    throws FileNotFoundException, IOException {
        setDisk(0, diskFile);
    }

    /**
     * Provide file name of disk.
     *
     * @param diskId the disk to change.
     * @param diskFile the name of the file.
     * @throws FileNotFoundException if the disk file does not exist
     * @throws IOException if the disk can't be opened.
     */
    public void setDisk(int diskId, File diskFile)
                    throws FileNotFoundException, IOException {
        removeDisk(diskId);
        if (diskFile.isFile() && diskFile.canRead()) {
            diskFiles[diskId] = diskFile;
            if (diskFile.canWrite()) {
                diskFP[diskId] = new RandomAccessFile(diskFile, "rw");
                writeProtected[diskId] = false;
            } else {
                diskFP[diskId] = new RandomAccessFile(diskFile, "r");
                writeProtected[diskId] = true;
            }
        } else {
            throw new FileNotFoundException("Unable to open disk: " + diskFile.toString());
        }
    }

    public File getDisk(int diskId) {
        return diskFiles[diskId];
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
        errorCode = NO_ERROR;
        switch (addr - getStartAddress()) {
        case BYTE_VALUE:
            valueRegister = val & 0xFF;
            break;
        case BYTE_ADDR:
            bufferAddress = val & 0xFF;
            LOGGER.debug("Set buffer address {}", bufferAddress);
            break;
        case BYTE_OPCODE:
            int diskId = (val & 0xC0) >> 6;
            val &= 0x3F;
            switch (val) {
            case COPY_BYTE:
                // Copy byte to buffer and increment the index.
                buffer[bufferAddress] = (byte) valueRegister;
                bufferAddress++;
                if (bufferAddress >= LSN_SIZE) bufferAddress = 0;
                break;
            case WRITE_BUFFER:
                writeLSN(diskId);
                break;
            case READ_BUFFER:
                readLSN(diskId);
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
        errorCode = NO_ERROR;
    }

    /**
     * Write the 256 byte buffer to logical sector address.
     */
    private void writeLSN(int diskId) {
        if (diskFP[diskId] == null) {
              errorCode = E_NOTRDY;
              return;
        }
        if (writeProtected[diskId]) {
              errorCode = E_WP;
              return;
        }
        int lsn = bufferAddress * BYTE_SIZE + valueRegister;
        bufferAddress = 0;
        LOGGER.debug("Write sector {}", lsn);
        try {
            diskFP[diskId].seek(lsn * LSN_SIZE);
            diskFP[diskId].write(buffer);
        } catch (IOException e) {
            errorCode = E_WRITE;
        }
    }

    private void readLSN(int diskId) {
        if (diskFP[diskId] == null) {
              errorCode = E_NOTRDY;
              return;
        }
        int lsn = bufferAddress * BYTE_SIZE + valueRegister;
        LOGGER.debug("Read sector {}", lsn);
        bufferAddress = 0;
        try {
            diskFP[diskId].seek(lsn * LSN_SIZE);
            int readResult = diskFP[diskId].read(buffer);
            if (readResult != LSN_SIZE) {
                Arrays.fill(buffer, readResult + 1, LSN_SIZE, (byte) 0);
            }
        } catch (IOException e) {
            LOGGER.error("IO error reading sector {}", lsn);
            errorCode = E_READ;
        }
    }
}
