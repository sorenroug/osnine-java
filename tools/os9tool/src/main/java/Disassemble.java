import java.io.FileInputStream;
import java.util.Arrays;
import org.roug.usim.mc6809.MC6809;
import org.roug.usim.mc6809.DisAssembler;
import org.roug.usim.OptionParser;

public class Disassemble {

    private byte[] module = new byte[0x10000];

    private static void usage(String msg) {
        System.err.println("Error: " + msg);
        System.err.println("Usage: Disassemble file");
        System.exit(2);
    }

    private static int loadModule(MC6809 cpu, String fileToLoad, int loadAddress) throws Exception {
        byte[] buf = new byte[0x10000];

        FileInputStream moduleStream = new FileInputStream(fileToLoad);
        int len = moduleStream.read(buf);
        for (int i = 0; i < len; i++) {
            cpu.write(loadAddress + i, buf[i]);
        }
        moduleStream.close();
        loadAddress += len;
        return loadAddress;
    }

    public static void main(String[] args) throws Exception {
        OptionParser op = new OptionParser(args, "s:");
        int loadAddress = 0x100;
        int startAddress = loadAddress;

        String sArg = op.getOptionArgument("s");
        if (sArg != null) {
            startAddress = Integer.decode(sArg);
        }

        String[] extraArguments = op.getUnusedArguments();
        if (extraArguments.length == 0) {
            usage("No file argument");
        }
        String fileName = extraArguments[0];

        MC6809 cpu = new MC6809(0xff00);
        int endAddress = loadModule(cpu, fileName, loadAddress);
        DisAssembler disasm = new DisAssembler(cpu);
        disasm.disasm(startAddress, endAddress);
    }
}
