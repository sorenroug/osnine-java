package org.roug.terminal;

import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Parse the control sequences from the host and the keys of the keyboard.
 */
public abstract class EmulationCore extends KeyAdapter implements TerminalEmulation {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(EmulationCore.class);

    public static int COLUMNS = 80;
    public static int ROWS = 24;

    private boolean shiftPressed;
    private boolean altPressed;

    private JTerminal term;

    public EmulationCore(JTerminal term) {
        super();
        this.term = term;
    }

    @Override
    public void resetState() {
        shiftPressed = false;
        altPressed = false;
    }

    @Override
    public void parseChar(int c) {
	writeChar(c);
    }

    /**
     * Write a character to the terminal.
     */
    protected void writeChar(int c) {
        LOGGER.debug("Char: {}", c);
        term.writeChar((char)c);
    }

    /**
     * Sends characters to the host.
     */
    protected void dataReceived(char c) {
        term.dataReceived(c);
    }

    protected void eolReceived() {
        term.eolReceived();
    }

    protected void bell() {
        term.bell();
    }

    protected void carriageReturn() {
        term.carriageReturn();
    }

    protected void clearScreen() {
        term.clearScreen();
    }

    protected void clearToEOL() {
        term.clearToEOL();
    }

    protected void clearToEOS() {
        term.clearToEOS();
    }

    protected void cursorXY(int x, int y) {
        term.cursorXY(x, y);
    }

    protected void cursorLeft() {
        term.cursorLeft();
    }

    protected void cursorRight() {
        term.cursorRight();
    }

    protected void cursorUp() {
        term.cursorUp();
    }

    protected void cursorDown() {
        term.cursorDown();
    }

    protected void setAttribute(int attrCode, boolean flag) {
        term.setAttribute(attrCode, flag);
    }

/*
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
*/

}
