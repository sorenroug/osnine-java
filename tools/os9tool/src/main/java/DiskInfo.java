import java.io.FileInputStream;
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

    private void printHex(String label, int value) {
        System.out.format("%-20s: %X\n", label, value);
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

    public DiskInfo(String fileName) throws Exception {
        FileInputStream inputStream = new FileInputStream(fileName);

        int size = inputStream.read(module);
        int pointer = 0;
        printHex("Number of sectors", read_triple(pointer));
        printHex("Number of tracks", read_byte(pointer + 0x03));
        printHex("Bytes in alloc map", read_word(pointer + 0x04));
        printHex("Sectors per cluster", read_word(pointer + 0x06));
        printHex("Starting sector", read_triple(pointer + 0x08));
        printHex("Owner id", read_word(pointer + 0x0b));
        printHex("Disk attributes", read_byte(pointer + 0x0c));
        printHex("Disk identification", read_word(pointer + 0x0e));
        printHex("Disk format", read_byte(pointer + 0x10));
        printHex("Sectors per track", read_word(pointer + 0x11));
        printHex("Bootstrap file", read_triple(pointer + 0x15));
        printHex("Size of bootstrap file", read_word(pointer + 0x18));
        printHex("Created year", read_byte(pointer + 0x1a));
        printString("Name", pointer + 0x1f);
        System.out.println();
    }

    public static void main(String[] args) throws Exception {
        if (args.length == 0) {
            usage("No file argument");
        }
        DiskInfo ident = new DiskInfo(args[0]);
    }
}
