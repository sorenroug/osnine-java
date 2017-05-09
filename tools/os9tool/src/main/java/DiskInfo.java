import java.io.FileInputStream;
import java.io.RandomAccessFile;
import java.util.Arrays;

public class DiskInfo {

    private byte[] module = new byte[0x10000];

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

    private void printString(String label, int location) {
        // Get length
        int length = 0;
        for (int i = location; i < 0x10000; i++) {
            if (module[i] <= 0) {
                length = i - location + 1;
                break;
            }
        }
        module[location + length - 1] &= 0x7f;
        String buf = new String(module, location, length);
        module[location + length - 1] |= 0x80;
        System.out.format("%-20s: %s\n", label, buf);
    }

    private void fileDescriptor(int sector) {
        int offset = sector * 256;
        printHex("File attributes", read_byte(offset));
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
                printString("Name", offset + i);
            }
        }
    }

    public DiskInfo(String fileName) throws Exception {
        FileInputStream inputStream = new FileInputStream(fileName);

        int size = inputStream.read(module);
        inputStream.close();
        int pointer = 0;
        printNumber("Number of sectors", read_triple(pointer));
        printNumber("Number of tracks", read_byte(pointer + 0x03));
        printNumber("Bytes in alloc map", read_word(pointer + 0x04));
        printNumber("Sectors per cluster", read_word(pointer + 0x06));
        printNumber("Starting sector", read_triple(pointer + 0x08));
        printNumber("Owner id", read_word(pointer + 0x0b));
        printHex("Disk attributes", read_byte(pointer + 0x0c));
        printHex("Disk identification", read_word(pointer + 0x0e));
        printHex("Disk format", read_byte(pointer + 0x10));
        printNumber("Sectors per track", read_word(pointer + 0x11));
        printHex("Bootstrap file", read_triple(pointer + 0x15));
        printNumber("Size of bootstrap file", read_word(pointer + 0x18));
        printDate("Created", read_byte(pointer + 0x1a), read_byte(pointer + 0x1b),
                read_byte(pointer + 0x1c), read_byte(pointer + 0x1d),
                read_byte(pointer + 0x1e));
        printString("Name", pointer + 0x1f);

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
