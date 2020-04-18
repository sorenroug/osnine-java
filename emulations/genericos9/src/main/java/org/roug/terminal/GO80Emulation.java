package org.roug.terminal;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Emulation of DragonPlus Board.
 */
public class GO80Emulation extends GO51Emulation {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(GO80Emulation.class);

    public int COLUMNS = 80;
    public int ROWS = 24;

    @Override
    public void initialize() {}

    @Override
    public int getColumns() {
        return 80;
    }

    @Override
    public int getRows() {
        return 24;
    }

}
