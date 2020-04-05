package org.roug.osnine.mo5;

import org.roug.usim.OptionParser;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Thomson MO5 emulator. Parse arguments and launch GUI.
 */
public class MO5Emu {

    /** List of unrecognized command line arguments. */
    private static String[] unusedArguments = new String[0];

    private static int scale = 0;

    public static void main(String[] args) throws Exception {
        parseArguments(args);
        GUI app = new GUI();
        if (scale != 0) app.setPixelSize(scale);
    }

    /**
     * Parses the given command line arguments, and sets the corresponding
     * fields of this object.
     *
     * @param args
     *         - the arguments
     */
    private static void parseArguments(String[] args) {

        OptionParser op = new OptionParser(args, "s:");
        String sOpt = op.getOptionArgument("s");
        if (sOpt != null && !"".equals(sOpt))
            scale = Integer.decode(sOpt).intValue();

        unusedArguments = op.getUnusedArguments();
    }

}
