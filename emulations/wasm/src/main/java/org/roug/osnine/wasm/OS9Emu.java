package org.roug.osnine.wasm;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Properties;

import org.roug.usim.OptionParser;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.roug.ui.terminal.AvailableEmulations;
import org.roug.ui.terminal.EmulationRec;

import java.awt.GraphicsEnvironment;
import java.awt.Font;

/**
 * Generic emulator for OS-9. Parse arguments and launch GUI.
 */
public class OS9Emu {

    private static final Logger LOGGER = LoggerFactory.getLogger(OS9Emu.class);

    /** List of unrecognized command line arguments. */
    private static String[] unusedArguments = new String[0];
    private static String[] diskArgs = new String[4];
    private static String[] defaultDisks = { "OS9.dsk" };

    private static Properties configMap = new Properties();

    private static String terminalType = "go80";
    private static String copyDiskFrom;
    private static String catalogRoot;

    public static void main(String[] args) {

        try {
            parseArguments(args);

            if (copyDiskFrom != null && diskArgs[0] != null) {
                File bootFile = new File(diskArgs[0]);
                if (!bootFile.exists()) {
                    copyDisk(new File(catalogRoot, copyDiskFrom), bootFile);
                }
            }

            GUI app = new GUI(configMap);
            for (int i = 0; i < 4; i++) {
                if (diskArgs[i] != null) {
                    app.setDisk(i, new File(diskArgs[i]));
                }
            }

        } catch (Exception e) {
            LOGGER.error("Failed to start", e);
            System.exit(1);
        }
    }

    static void copyDisk(File src, File dst)
                    throws FileNotFoundException, IOException {
        InputStream inStream = new FileInputStream(src);
        OutputStream outputStream = new FileOutputStream(dst);
        if (inStream == null) LOGGER.error("instream is null");
        if (outputStream == null) LOGGER.error("outputStream is null");

        byte[] b = new byte[65536];
        int sz;
        while((sz = inStream.read(b)) > 0) {
            outputStream.write(b, 0, sz);
        }
        b = null;
        inStream.close();
        outputStream.close();
        LOGGER.info("{} copied to {}", src, dst);
    }

    /**
     * Parses the given command line arguments, and sets the corresponding
     * fields of this object.
     * Flags:
     *  -s = single user boot
     *  -t = terminal type
     *  0,1,2,3 = disk image for /d0, /d1, /d2, /d3
     *
     * @param args
     *         - the arguments
     */
    private static void parseArguments(String[] args) {

        OptionParser op = new OptionParser(args, "r:c:t:w:0:1:2:3:");
        String tt = op.getOptionArgument("t");
        if (tt != null) terminalType = tt;
        validateTermType();
        configMap.setProperty("term.type", terminalType);

        copyDiskFrom = op.getOptionArgument("c");
        catalogRoot = op.getOptionArgument("r");
        if (catalogRoot == null)
            catalogRoot = ".";
        configMap.setProperty("catalog", catalogRoot);

        String workDir = op.getOptionArgument("w");
        if (workDir != null) configMap.setProperty("workdir", workDir);

        for (int i = 0; i < 4; i++) {
            String a = op.getOptionArgument(Integer.toString(i));
            if (a != null) {
                diskArgs[i] = a;
            }
        }
        unusedArguments = op.getUnusedArguments();
    }

    private static void validateTermType() {
        EmulationRec[] emulations = AvailableEmulations.getAvailable();

        for (EmulationRec em : emulations) {
            if (terminalType.equals(em.getName())) {
                return;
            }
        }
        System.err.println("Unrecognized terminal type. Available:");
        for (EmulationRec em : emulations) {
            System.err.printf("%10s - %s\n", em.getName(), em.getDescription());
        }
        System.exit(0);
    }
}
