package org.roug.terminal;

import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Emulation of a dumb terminal without cursor keys.
 */
public class GO80Emulation extends GO51Emulation {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(GO80Emulation.class);

    public static int COLUMNS = 80;
    public static int ROWS = 24;

    public GO80Emulation(JTerminal term) {
        super(term);
    }

}
