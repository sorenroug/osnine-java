package org.roug.terminal;

import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Emulation of a dumb terminal without cursor keys.
 */
public class DumbTerminal extends KeyAdapter implements TerminalEmulation {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(DumbTerminal.class);

    private boolean shiftPressed;
    private boolean altPressed;

    private JTerminal term;

    public DumbTerminal(JTerminal term) {
        super();
        this.term = term;
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
            term.bell();
            break;
        case '\n':
            term.cursorDown();
            break;
        case '\b':
            term.cursorLeft();
            break;
        case '\f':
            term.clearScreen();
            break;
        case '\r':
            term.carriageReturn();
            break;
        default:
            LOGGER.debug("Char: {}", c);
            term.writeChar((char)c);
        }
    }
 

    /**
     * Sends characters to the host.
     */
    private void dataReceived(char c) {
        term.dataReceived(c);
    }

    private void eolReceived() {
        term.eolReceived();
    }

    @Override
    public void keyReleased(KeyEvent evt) {
        int keyCode = evt.getKeyCode();
        LOGGER.debug("Released: {}", keyCode);
        switch (keyCode) {
        case KeyEvent.VK_SHIFT:
            shiftPressed = false;
            break;
        case KeyEvent.VK_ALT:
            altPressed = false;
            break;
        case KeyEvent.VK_DEAD_CIRCUMFLEX:
            dataReceived('^');
            break;
        case KeyEvent.VK_DEAD_TILDE:
            dataReceived('~');
            break;
        case KeyEvent.VK_DEAD_GRAVE:
            dataReceived('`');
            break;
        }
    }

    @Override
    public void keyPressed(KeyEvent evt) {
        char keyChar = evt.getKeyChar();
        int keyCode = evt.getKeyCode();
        if (keyChar == KeyEvent.CHAR_UNDEFINED) {
            switch (keyCode) {
            case KeyEvent.VK_ALT:
                altPressed = true;
                break;
            case KeyEvent.VK_SHIFT:
                shiftPressed = true;
                break;
            case KeyEvent.VK_LEFT:
                if (shiftPressed)
                    dataReceived((char) 0x18);
                else
                    dataReceived((char) 0x08);
                break;
            case KeyEvent.VK_RIGHT:
                if (shiftPressed)
                    dataReceived((char) 0x19);
                else
                    dataReceived((char) 0x09);
                break;
            case KeyEvent.VK_DOWN:
                if (shiftPressed)
                    dataReceived((char) 0x1A);
                else
                    dataReceived((char) 0x0A);
                break;
            case KeyEvent.VK_UP:
                if (shiftPressed)
                    dataReceived((char) 0x1C);
                else
                    dataReceived((char) 0x0C);
                break;
            default:
                LOGGER.debug("Undefined char received: {}", keyCode);
            }
        } else {
            switch (keyChar) {
            case '\n':
                eolReceived();
                break;
            default:
                LOGGER.debug("Typed: {}", keyCode);
                if (!altPressed) 
                    dataReceived(keyChar);
            }
        }
    }
}
