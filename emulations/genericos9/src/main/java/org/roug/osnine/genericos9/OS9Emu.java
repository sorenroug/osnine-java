package org.roug.osnine.genericos9;

import java.io.File;
import org.roug.osnine.OptionParser;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Generic emulator for OS-9. Parse arguments and launch GUI.
 */
public class OS9Emu {

    private static final Logger LOGGER = LoggerFactory.getLogger(OS9Emu.class);

    /** List of unrecognized command line arguments. */
    private static String[] unusedArguments = new String[0];
    private static String[] diskArgs = new String[4];
    private static String[] defaultDisks = { "OS9.dsk" };

    private static boolean singleUser = false;

    public static void main(String[] args) {

        try {
            parseArguments(args);
            GUI app = new GUI(singleUser);
            if (unusedArguments.length == 0) unusedArguments = defaultDisks;
            for (int i = 0; i < 4; i++) {
                if (i < unusedArguments.length) {
                    app.setDisk(i, new File(unusedArguments[i]));
                }
            }

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

    /**
     * Parses the given command line arguments, and sets the corresponding
     * fields of this object.
     *
     * @param args
     *         - the arguments
     */
    private static void parseArguments(String[] args) {

        OptionParser op = new OptionParser(args, "sm0:1:2:3:");
        singleUser = op.getOptionFlag("s");
        if (op.getOptionFlag("m")) {
            singleUser = false;
        }
        for (int i = 0; i < 4; i++) {
            String a = op.getOptionArgument(Integer.toString(i));
            if (a != null) {
                diskArgs[i] = a;
            }
        }
        unusedArguments = op.getUnusedArguments();
    }

}
