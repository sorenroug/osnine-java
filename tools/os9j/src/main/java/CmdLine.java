import java.io.File;
import java.io.InputStream;
import java.util.Properties;
import org.roug.osnine.MC6809;
import org.roug.osnine.MC6850;
import org.roug.osnine.MemoryBank;
import org.roug.osnine.os9.OS9;
import org.roug.osnine.os9.PDStdIn;
import org.roug.osnine.os9.PDStdOut;
import org.roug.osnine.os9.DevPipe;
import org.roug.osnine.os9.DevUnix;
import org.roug.osnine.os9.DevDrvTerm;
import org.roug.osnine.RegisterCC;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class CmdLine {

    private static final Logger LOGGER = LoggerFactory.getLogger(CmdLine.class);

    /**
     * 
     */
    public static void main(String[] args) throws Exception {
        OS9 cpu = new OS9();

        MC6850 uart = new MC6850(0xb000);
        cpu.addMemorySegment(uart);

        cpu.setDebugCalls(1);
	// Load the configuration file
	loadrcfile(cpu);

        String parm = createParm(args);
        String command = (args.length == 0) ? "shell" : args[0];
        cpu.setInitialCWD("/h0");
        cpu.setInitialCXD("/dd/CMDS");
        cpu.loadmodule(command, parm);
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
        String homedir;
        Properties props = new Properties();

        if (System.getenv("OSNINEDIR") != null) {
            homedir = System.getenv("OSNINEDIR");
        } else {
            homedir = System.getenv("HOME") + "/OS9";
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
        cpu.setInitialCXD("/dd/CMDS");
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
