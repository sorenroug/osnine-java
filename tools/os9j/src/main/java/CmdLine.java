import java.io.File;
import java.io.InputStream;
import java.util.Properties;
import org.roug.usim.OptionParser;
import org.roug.osnine.os9.OS9;
import org.roug.osnine.os9.PDStdIn;
import org.roug.osnine.os9.PDStdOut;
import org.roug.osnine.os9.DevPipe;
import org.roug.osnine.os9.DevUnix;
import org.roug.osnine.os9.DevDrvTerm;
//import org.roug.usim.RegisterCC;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Run OS9 from the command line.
 * Option flags:
 *  -m {int} -- Memory allocation. Up to 60000.
 *  -o       -- Set OS-9 line ending semantics for ReadLn
 *  -O       -- Set OS-9 line ending semantics for WriteLn
 *  -u       -- Set UNIX semantics
 *  -h       -- Set UNIX directory for /dd
 *  -x       -- Set execution directory. Must be under or same as /dd
 *  --       -- Assume further options are for the OS-9 application.
 */
public class CmdLine {

    private static final Logger LOGGER = LoggerFactory.getLogger(CmdLine.class);

    private static String homedir;

    private static String execDir;

    /**
     * 
     */
    public static void main(String[] args) throws Exception {
        int memoryAlloc = 0;
        OptionParser op = new OptionParser(args, "h:m:x:ouO");

        homedir = op.getOptionArgument("h");
        execDir = op.getOptionArgument("x");
        String memoryArg = op.getOptionArgument("m");
        if (memoryArg != null) {
            memoryAlloc = Integer.decode(memoryArg);
        }
        if (op.getOptionFlag('o') || op.getOptionFlag('O')) {
            DevUnix.setUNIXSemantics(false);
        }
        if (op.getOptionFlag('O')) {
            PDStdOut.setUNIXSemantics(false);
        }
        if (op.getOptionFlag('u')) {
            DevUnix.setUNIXSemantics(true);
        }
        String[] extraArguments = op.getUnusedArguments();

        OS9 cpu = new OS9();

        cpu.setDebugCalls(1);
	// Load the configuration file
	loadrcfile(cpu);

        String parm = createParm(extraArguments);
        String command = (extraArguments.length == 0) ? "shell" : extraArguments[0];
        cpu.setInitialCWD("/h0");
        cpu.setInitialCXD("/dd/CMDS");
        cpu.loadmodule(command, parm, memoryAlloc);
        // Set up stdin, stdout and stderr.
        cpu.setPathDesc(0, new PDStdIn(System.in));
        cpu.setPathDesc(1, new PDStdOut(System.out));
        cpu.setPathDesc(2, new PDStdOut(System.err));
        cpu.run();
        System.out.flush();
    }

    /**
     * Load RC file.
     * This function should read a configuration file in the user's home
     * directory. It could be called directly from the constructor.
     * The idea is to specify where /d0, /h0 is in the UNIX hierarchy.
     */
    private static void loadrcfile(OS9 cpu) {
    // Build a list of devices that map to a point in the UNIX filesystem
        Properties props = new Properties();

        if (homedir == null) {
            if (System.getenv("OSNINEDIR") != null) {
                homedir = System.getenv("OSNINEDIR");
            } else {
                homedir = System.getenv("HOME") + "/OS9";
            }
        }

        // Create a device called /term to match the UNIX controlling tty
        cpu.addDevice(new DevDrvTerm("/term", "/dev/tty"));
        // Create pseudo disks offset at $HOME/OS9
        // We create for all commonly used disks.
        cpu.addDevice(new DevUnix("/dd", homedir)); // Default drive
        LOGGER.debug("Current dir: {}", System.getProperty("user.dir"));
        cpu.addDevice(new DevUnix("/h0", System.getProperty("user.dir")));
        cpu.addDevice(new DevUnix("/d0", homedir));
        cpu.addDevice(new DevUnix("/d1", homedir));
        // Create the pipe device
        cpu.addDevice(new DevPipe("/pipe", ""));
        // Create devices for all UNIX directories we might be interested in
        // This is so a UNIX path name is directly equivalent to an OS9 pathname.
        // Used when we set the current working directory
        mount_allunix(cpu);
        /*
        cpu.addDevice(new DevUnix("/home", "/home"));
        cpu.addDevice(new DevUnix("/usr", "/usr"));
        cpu.addDevice(new DevUnix("/etc", "/etc"));
        */

        // Set the current execution directory.
        if (execDir == null) {
            execDir = "/dd/CMDS";
        }
        cpu.setInitialCXD(execDir);
    }


    /**
     * Open the root directory in UNIX and mount all directories as
     * OS9 devices.
     */
    private static void mount_allunix(OS9 cpu) {
        File dirp = new File("/");
        for (File dentp : dirp.listFiles()) {
            if (dentp.isHidden())
                continue;
            if (dentp.isDirectory()) {
                cpu.addDevice(new DevUnix(dentp.toString(), dentp.toString()));
            }
        }
        return ;
    }

    /**
     * Construct the parameters from the arguments given to the application.
     * Java has split the command line for us. We now have to put it back to one string.
     */
    private static String createParm(String[] args) {
        String result = "";
        for (int i = 1; i < args.length; i++) {
            result = result + args[i];
            if (i + 1 < args.length) result = result + " ";
        }
        return result;
    }

}
