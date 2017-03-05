import java.io.FileInputStream;
import java.util.Arrays;

public class Ident {

    private byte[] module = new byte[0x10000];

    private static void usage(String msg) {
        System.err.println("Error: " + msg);
        System.err.println("Usage: Ident file");
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

    public Ident(String fileName) throws Exception {
        FileInputStream inputStream = new FileInputStream(fileName);

        int size = inputStream.read(module);
        int pointer = 0;
        while (pointer < size) {
            printString("Name", pointer + read_word(pointer + 0x04));
            printHex("Sync bytes", read_word(pointer + 0));
            int moduleSize = read_word(pointer + 0x02);
            printHex("Module size", moduleSize);
            printHex("Type/lang", read_byte(pointer + 0x06));
            printHex("Attr/rev", read_byte(pointer + 0x07));
            printHex("Hdr parity", read_byte(pointer + 0x08));
            printHex("CRC", read_triple(pointer + moduleSize - 3));
            int moduleType = read_byte(pointer + 0x06) & 0xf0;
            switch (moduleType) {
            case 0x10: // Executable module
                printHex("Execution offset", read_word(pointer + 0x09));
                printHex("Storage size", read_word(pointer + 0x0B));
                break;
            case 0xC0: // Configuration module
                printHex("Top of free RAM", read_triple(pointer + 0x09));
                printHex("# IRQ entries", read_byte(pointer + 0x0C));
                printHex("# Device entries", read_byte(pointer + 0x0D));
                printString("Startup module", pointer + read_word(pointer + 0x0E));
                printString("Default storage", pointer + read_word(pointer + 0x10));
                printString("Initial path", pointer + read_word(pointer + 0x12));
                printString("Bootstrap module", pointer + read_word(pointer + 0x14));
                break;
            case 0xF0: // Device descriptor module
                printString("File manager", pointer + read_word(pointer + 0x09));
                printString("Device driver", pointer + read_word(pointer + 0x0B));
                printHex("Mode byte", read_byte(pointer + 0x0D));
                printHex("Device controller addr", read_triple(pointer + 0x0E));
                printHex("Init table size", read_byte(pointer + 0x11));
                break;
            }
            System.out.println();
            pointer += moduleSize;
        }
    }

    public static void main(String[] args) throws Exception {
        if (args.length == 0) {
            usage("No file argument");
        }
        Ident ident = new Ident(args[0]);
    }
}
