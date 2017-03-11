import java.io.FileInputStream;
import java.util.Arrays;

/**
 * This class takes a file and makes it into a memory module.
 * The default module type is Data.
 */
public class CreateModule {

    /** List of unrecognized command line arguments. They will be interpreted as names of tables to export. */
    private String[] extraArguments = new String[0];

    /** Path to the file where the result shall be generated into. */
    private String outputFilePath = null;

    private String moduleName = null;

    private String moduleType = null;

    private byte[] module = new byte[0x10000];

    private static void usage(String msg) {
        System.err.println("Error: " + msg);
        System.err.println("Usage: CreateModule file");
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

    public CreateModule(String[] args) throws Exception {
        OptionParser op = new OptionParser(args, "o:t:n:");

        outputFilePath = op.getOptionArgument("o");
        if ("-".equals(outputFilePath)) {
            outputFilePath = null; // Linux convention
        }

        moduleType = op.getOptionArgument("t");
	moduleName = op.getOptionArgument("n");

	extraArguments = op.getUnusedArguments();
        if (extraArguments.length == 0) {
            usage("No file argument");
        }
        FileInputStream inputStream = new FileInputStream(extraArguments[0]);

    }

}
