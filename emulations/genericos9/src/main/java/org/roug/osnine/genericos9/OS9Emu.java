package org.roug.osnine.genericos9;

import java.io.File;
import java.util.Properties;

import org.roug.usim.OptionParser;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.roug.terminal.AvailableEmulations;
import org.roug.terminal.EmulationList;

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

    private static boolean singleUser = false;
    private static String terminalType = "go80";

    public static void main(String[] args) {

        try {
            parseArguments(args);
            GUI app = new GUI(configMap);
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
     * Flags:
     *  -s = single user boot
     *  -t = terminal type
     *  0,1,2,3 = disk image for /d0, /d1, /d2, /d3
     *
     * @param args
     *         - the arguments
     */
    private static void parseArguments(String[] args) {

        OptionParser op = new OptionParser(args, "f:mst:0:1:2:3:");
        singleUser = op.getOptionFlag("s");
        if (op.getOptionFlag("m")) {
            singleUser = false;
        }
        if (singleUser)
            configMap.setProperty("bootmode", "singleuser");
        else
            configMap.setProperty("bootmode", "multiuser");
        String tt = op.getOptionArgument("t");
        if (tt != null) terminalType = tt;
        validateTermType();
        configMap.setProperty("term.type", terminalType);
        configMap.setProperty("t1.type", terminalType);

        String fontSize = op.getOptionArgument("f");
        if (fontSize == null) fontSize = "12";
        configMap.setProperty("term.fontsize", fontSize);
        configMap.setProperty("t1.fontsize", fontSize);

        for (int i = 0; i < 4; i++) {
            String a = op.getOptionArgument(Integer.toString(i));
            if (a != null) {
                diskArgs[i] = a;
            }
        }
        unusedArguments = op.getUnusedArguments();
    }

    private static void validateTermType() {
        EmulationList[] emulations = AvailableEmulations.getAvailable();

        for (EmulationList em : emulations) {
            if (terminalType.equals(em.getName())) {
                return;
            }
        }
        System.err.println("Unrecognized terminal type. Available:");
        for (EmulationList em : emulations) {
            System.err.printf("%10s - %s\n", em.getName(), em.getDescription());
        }
        System.exit(0);
    }
}
