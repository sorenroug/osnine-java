import java.io.FileInputStream;
import java.util.Arrays;
import org.roug.osnine.format.Format;
import org.roug.osnine.rbf.RBFDirectory;
import org.roug.osnine.rbf.DirEntry;
import org.roug.osnine.rbf.Disk;

public class OS9Tool {

    private static void usage(String msg) {
        System.err.println("Error: " + msg);
        System.err.println("Usage: OS9Tool subcommand ...");
        System.err.println("ident: Show information about OS9 module");
        System.err.println("diskinfo: Show information about disk image");
        System.err.println("createmodule: ");
        System.exit(2);
    }

    public static void main(String[] args) throws Exception {
        if (args.length == 0) {
            usage("No subcommand argument");
        }
        String subCommand = args[0];
        String[] extraArgs = Arrays.copyOfRange(args, 1, args.length);

        if ("ident".equals(subCommand)) {
            Ident.main(extraArgs);
        } else if ("disasm".equals(subCommand)) {
            Disassemble.main(extraArgs);
        } else if ("diskinfo".equals(subCommand)) {
            DiskInfo.main(extraArgs);
        } else if ("createmodule".equals(subCommand)) {
            CreateModule cm = new CreateModule(extraArgs);
        } else if ("format".equals(subCommand)) {
            Format cm = new Format(extraArgs);
        } else if ("dir".equals(subCommand) || "ls".equals(subCommand)) {
            Dir d = new Dir(extraArgs[0], extraArgs[1]);
        } else {
            usage("Unknown subcommand: " + subCommand);
        }

    }
}

class Dir {

    Dir(String diskName, String dirName) throws Exception {
        Disk disk = new Disk(diskName);
        RBFDirectory d = disk.openDirectory(dirName);
        DirEntry de = null;
        while ((de = d.readNextDirEntry()) != null) {
            System.out.println(de.getName());
        };
    }
}
