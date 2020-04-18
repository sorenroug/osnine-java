package org.roug.terminal;

import java.awt.event.KeyListener;
import java.awt.Dimension;

/**
 * Interface for terminal emulation classes.
 * The classes parse the codes sent from the host then
 * tells the user interface what to do.
 */
public interface TerminalEmulation extends KeyListener {

    /**
     * Interpret character sent to the emulation.
     */
    public void parseChar(int c);

    public void resetState();

    /**
     * Get number of columns the terminal has. Usually 80.
     */
    public int getColumns();

    /**
     * Get number of line the terminal has. Usually 24.
     */
    public int getRows();

    public void setUIDevice(JTerminal term);

}
