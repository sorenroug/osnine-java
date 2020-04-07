package org.roug.terminal;

import java.awt.event.KeyListener;

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
}
