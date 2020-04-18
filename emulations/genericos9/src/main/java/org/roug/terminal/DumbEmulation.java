package org.roug.terminal;

import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Emulation of a dumb terminal without cursor keys.
 */
public class DumbEmulation extends EmulationCore {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(DumbEmulation.class);

    private int COLUMNS = 80;
    private int ROWS = 66;

    @Override
    public void initialize() {}

    @Override
    public void resetState() {
    }

    @Override
    public int getColumns() {
        return COLUMNS;
    }

    @Override
    public int getRows() {
        return ROWS;
    }

    /**
     * Parse character received from host and then write it to the terminal.
     * Will only understand the control codes in the lower 32 codes of ASCII.
     */
    @Override
    public void parseChar(int c) {
        switch (c) {
        case 0:
            break;
        case 7:
            bell();
            break;
        case '\n':
            cursorDown(true);
            break;
        case '\b':
            cursorLeft(false);
            break;
        case '\f':
            clearScreen();
            break;
        case '\r':
            carriageReturn();
            break;
        default:
            LOGGER.debug("Char: {}", c);
            writeChar(c);
        }
    }
 

    @Override
    void receiveKeyCode(KeyEvent evt) {
        int keyCode = evt.getKeyCode();
        switch (keyCode) {
        case KeyEvent.VK_LEFT:
            if (evt.isShiftDown())
                dataReceived((char) 0x18);
            else
                dataReceived((char) 0x08);
            break;
        case KeyEvent.VK_RIGHT:
            if (evt.isShiftDown())
                dataReceived((char) 0x19);
            else
                dataReceived((char) 0x09);
            break;
        case KeyEvent.VK_DOWN:
            if (evt.isShiftDown())
                dataReceived((char) 0x1A);
            else
                dataReceived((char) 0x0A);
            break;
        case KeyEvent.VK_UP:
            if (evt.isShiftDown())
                dataReceived((char) 0x1C);
            else
                dataReceived((char) 0x0C);
            break;
        default:
            LOGGER.debug("Undefined char received: {}", keyCode);
        }
    }

    @Override
    void receiveChar(char keyChar) {
        switch (keyChar) {
        case '\n':
            eolReceived();
            break;
        default:
            dataReceived(keyChar);
        }
    }
}
