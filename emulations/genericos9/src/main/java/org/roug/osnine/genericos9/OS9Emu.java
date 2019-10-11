package org.roug.osnine.genericos9;

import org.roug.osnine.OptionParser;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Generic emulator for OS-9. Parse arguments and launch GUI.
 */
public class OS9Emu {

    /** List of unrecognized command line arguments. */
    private static String[] unusedArguments = new String[0];

    private static boolean singleUser = false;

    public static void main(String[] args) throws Exception {
        parseArguments(args);
        GUI app = new GUI(singleUser);
    }

    /**
     * Parses the given command line arguments, and sets the corresponding
     * fields of this object.
     *
     * @param args
     *         - the arguments
     */
    private static void parseArguments(String[] args) {

        OptionParser op = new OptionParser(args, "sm");
        singleUser = op.getOptionFlag("s");
        if (op.getOptionFlag("m")) {
            singleUser = false;
        }
        unusedArguments = op.getUnusedArguments();
    }

}
