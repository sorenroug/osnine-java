import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.Arrays;
import org.roug.osnine.os9.OS9;

/**
 * This class takes a file and makes it into a memory module.
 * The default module type is Data.
 * Arguments:
 * -o output file
 * -t module type
 * -n module name
 * -x Execution offset
 * -m memory requirement
 */
public class CreateModule {

    /** List of unrecognized command line arguments. */
    private String[] extraArguments = new String[0];

    /** Path to the file where the result shall be generated into. */
    private String outputFilePath = null;

    private String moduleName = "NoName";

    private int moduleType = 4;

    /** Buffer to build module. Can max be 65536 bytes. */
    private byte[] module = new byte[0x10000];

    private int executionOffset = 0;

    private int memoryRequirement = 0;

    private OutputStream outputStream;

    private static void usage(String msg) {
        System.err.println("Error: " + msg);
        System.err.println("Usage: CreateModule file");
        System.exit(2);
    }


    /*
     * Constructor.
     */
    public CreateModule(String[] args) throws Exception {
        long fileSize = 0L;
        FileInputStream inputStream = null;

        OptionParser op = new OptionParser(args, "f:o:t:n:s:");

        outputFilePath = op.getOptionArgument("o");
        if ("-".equals(outputFilePath)) {
            outputFilePath = null; // Linux convention
        }

        String tArg = op.getOptionArgument("t");
        if (tArg != null) {
            moduleType = Integer.valueOf(tArg);
        }
        String nArg = op.getOptionArgument("n");
        if (nArg != null) {
            moduleName = nArg;
        }

//      extraArguments = op.getUnusedArguments();
//      if (extraArguments.length == 0) {
//          usage("No file argument");
//      }
        String inputFilePath = op.getOptionArgument("f");
        if (inputFilePath != null) {
            inputStream = new FileInputStream(extraArguments[0]);
            fileSize = inputStream.getChannel().size();
        }

        String sizeArg = op.getOptionArgument("s");
        if (sizeArg != null) {
            fileSize = Long.valueOf(sizeArg);
        }

        outputStream = System.out;
        if (outputFilePath != null && !outputFilePath.isEmpty()) {
            outputStream = new FileOutputStream(outputFilePath);
        }

        write_word(0, 0x87CD);
        write_word(2, calculateModuleSize((int) fileSize));
        write_byte(6, moduleType << 4); // Type / language
        write_byte(7, 0); // Attributes / revision
        writeParity();
        int moduleSize = 9;
        if (moduleType == 1) {
            write_word(0x09, executionOffset);
            write_word(0x0B, memoryRequirement);
            moduleSize += 4;
        }
        write_word(4, moduleSize); // Module name offset
        writeString(moduleSize, moduleName);
        moduleSize += moduleName.length();
        if (inputStream != null) {
            inputStream.read(module, moduleSize, (int)fileSize);
            inputStream.close();
        }
        moduleSize += fileSize;
        write_word(2, moduleSize + 3);
        writeCRC(moduleSize);
        moduleSize += 3;
        outputStream.write(module, 0 , moduleSize);
        outputStream.close();
    }

    private void write_byte(int location, int value) {
        module[location] = (byte) (value & 0xff);
    }

    private void write_word(int location, int value) {
        byte highByte = (byte) ((value >> 8) & 0xff);
        module[location] = highByte;
        byte lowByte = (byte) (value & 0xff);
        module[location + 1] = lowByte;
    }

    private void writeString(int location, String name) {
        byte[] nameBytes = name.getBytes();

        for (int i = 0; i < nameBytes.length; i++) {
            module[location + i] = nameBytes[i];
        }
        module[location + nameBytes.length - 1] |= 0x80;
    }

    private int calculateModuleSize(int fileSize) {
        int headerSize = 12;
        if (moduleType == 1) {
            headerSize += 4;
        }
        headerSize += moduleName.length();

        return fileSize + headerSize;
    }

    private void writeParity() {
        byte parity = 0;
        for (int i = 0; i < 8; i++) {
            parity = (byte) (parity ^ module[i]);
        }
        module[8] = parity;
    }

    private void writeCRC(int location) {
        long crc = OS9.CRC24_SEED;
        long result = OS9.compute_crc(crc, module, location) ^ OS9.CRC24_SEED;
        module[location + 0] = (byte) ((result >> 16) & 0xFF);
        module[location + 1] = (byte) ((result >> 8) & 0xFF);
        module[location + 2] = (byte) (result & 0xFF);
    }

}
