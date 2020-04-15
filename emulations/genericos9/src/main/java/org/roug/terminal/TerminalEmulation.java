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

    public Dimension getScreenSize();

    public int getColumns();

    public int getRows();

    public void setUIDevice(JTerminal term);

}
