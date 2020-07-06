import java.io.FileInputStream;
import java.io.RandomAccessFile;
import java.util.Arrays;
import org.roug.osnine.format.IdentificationSector;

public class DiskInfo {

    private final static int MAX_SIZE = 0x10000;



    private byte[] module = new byte[MAX_SIZE];

    private static void usage(String msg) {
        System.err.println("Error: " + msg);
        System.err.println("Usage: DiskInfo file");
        System.exit(2);
    }

    private int read_byte(int location) {
        return (module[location] & 0xff);
    }

    private int read_word(int location) {
        return (module[location] & 0xff) << 8 | (module[location + 1] & 0xff);
    }

    private int read_triple(int location) {
        return (module[location] & 0xff) << 16 | (module[location + 1] & 0xff) << 8 | (module[location + 2] & 0xff);
    }

    private int read_dword(int location) {
        return (module[location] & 0xff) << 24 | (module[location + 1] & 0xff) << 16
                | (module[location + 2] & 0xff) << 8 | (module[location + 3] & 0xff);
    }

    private void printDate(String label, int year, int month, int day, int hour, int minute) {
        System.out.format("%-20s: %d-%02d-%02d %02d:%02d\n", label, year+1900, month, day, hour, minute);
    }

    private void printHex(String label, int value) {
        System.out.format("%-20s: $%X\n", label, value);
    }

    private void printNumber(String label, int value) {
        System.out.format("%-20s: %d ($%X)\n", label, value, value);
    }

    private String attrToString(int attribute) {
        char[] attrBuf = "DSEWREWR".toCharArray();

        int mask = 128;
        for (int b = 0; b < 8; b++) {
            if ((attribute & mask) == 0) {
                attrBuf[b] = '-';
            }
            mask >>= 1;
        }
        return String.valueOf(attrBuf); //+ " ($" + Integer.toHexString(attribute) + ")";
    }

    /**
     * Show the descriptions of the bits in the DD_FMT.
     */
    private String fmtToString(int fmt) {
        String[] labels0 = { "Single sided", "Single density", "48 TPI" };
        String[] labels1 = { "Double sided", "Double density", "96 TPI" };
        String[] result = new String[3];

        int mask = 1;
        for (int b = 0; b < 3; b++) {
            if ((fmt & mask) == 0) {
                result[b] = labels0[b];
            } else {
                result[b] = labels1[b];
            }
            mask <<= 1;
        }
        return String.format("%02X: ", fmt) + String.join(", ", result);
    }

    private void printString(String label, String value) {
        System.out.format("%-20s: %s\n", label, value);
    }

    private String os9String(int location) {
        int length = 0;
        for (int i = location; i < MAX_SIZE; i++) {
            if (module[i] <= 0) {
                length = i - location + 1;
                break;
            }
        }
        module[location + length - 1] &= 0x7f;
        String buf = new String(module, location, length);
        module[location + length - 1] |= 0x80;
        return buf;
    }

    private void fileDescriptor(int sector) {
        int offset = sector * 256;
        printString("File attributes", attrToString(read_byte(offset)));
        printHex("Owner", read_word(offset + 1));
        printDate("Last modified", read_byte(offset + 0x03), read_byte(offset + 0x04),
                read_byte(offset + 0x05), read_byte(offset + 0x06),
                read_byte(offset + 0x07));
        int dirSize = read_dword(offset + 0x09);
        printNumber("Size", dirSize);
        printDate("Date created", read_byte(offset + 0x0D), read_byte(offset + 0x0E),
                read_byte(offset + 0x0F), 0,0);
        directoryList(sector + 1, dirSize);
    }

    private void directoryList(int startSector, int dirSize) {
        int offset = startSector * 256;
        for (int i = 0; i < dirSize; i+= 32) {
            int usage = read_byte(offset + i);
            if (usage != 0) {
                printString("Name", os9String(offset + i));
            }
        }
    }

    public DiskInfo(String fileName) throws Exception {
        FileInputStream inputStream = new FileInputStream(fileName);

        int size = inputStream.read(module);
        inputStream.close();
        int pointer = 0;
        printNumber("Number of sectors", read_triple(pointer));
        printNumber("Sectors per track", read_byte(pointer + IdentificationSector.DD_TKS));
        // Round up number of tracks.
        int trackRounded = read_triple(pointer) + read_byte(pointer + IdentificationSector.DD_TKS) - 1;
        printNumber("Number of tracks", trackRounded / read_byte(pointer + IdentificationSector.DD_TKS));
        printNumber("Bytes in alloc map", read_word(pointer + IdentificationSector.DD_MAP));
        printNumber("Sectors per cluster", read_word(pointer + IdentificationSector.DD_BIT));
        printNumber("Starting sector", read_triple(pointer + IdentificationSector.DD_DIR));
        printNumber("Owner id", read_word(pointer + IdentificationSector.DD_OWN));
        printString("Disk attributes", attrToString(read_byte(pointer + IdentificationSector.DD_ATT)));
        printHex("Disk identification", read_word(pointer + IdentificationSector.DD_DSK));
        printString("Disk format", fmtToString(read_byte(pointer + IdentificationSector.DD_FMT)));
        printNumber("Sectors per track", read_word(pointer + IdentificationSector.DD_SPT));
        printHex("Bootstrap file", read_triple(pointer + IdentificationSector.DD_BT));
        printNumber("Size of bootstrap file", read_word(pointer + IdentificationSector.DD_BSZ));
        printDate("Created", read_byte(pointer + 0x1a), read_byte(pointer + 0x1b),
                read_byte(pointer + 0x1c), read_byte(pointer + 0x1d),
                read_byte(pointer + 0x1e));
        printString("Name", os9String(pointer + IdentificationSector.DD_NAM));

        System.out.println("Root directory");
        fileDescriptor(read_triple(pointer + 0x08));
        System.out.println();
    }

    public static void main(String[] args) throws Exception {
        if (args.length == 0) {
            usage("No file argument");
        }
        DiskInfo ident = new DiskInfo(args[0]);
    }
}
