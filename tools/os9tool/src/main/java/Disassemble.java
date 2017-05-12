import java.io.FileInputStream;
import java.util.Arrays;
import org.roug.osnine.MC6809;
import org.roug.osnine.OptionParser;
import org.roug.osnine.DisAssembler;

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

    public Disassemble(String fileName) throws Exception {
        MC6809 cpu = new MC6809(0xff00);
        int startAddress = 0x100;
        int endAddress = loadModule(cpu, fileName, 0x100);
        DisAssembler disasm = new DisAssembler(cpu);
        disasm.disasm(startAddress,endAddress);
    }

    public static void main(String[] args) throws Exception {
        if (args.length == 0) {
            usage("No file argument");
        }
        Disassemble ident = new Disassemble(args[0]);
    }
}
