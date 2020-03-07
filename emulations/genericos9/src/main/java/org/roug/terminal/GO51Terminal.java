package org.roug.terminal;

import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Parse the control sequences from the host and the keys of the keyboard.
 */
public class GO51Terminal extends KeyAdapter implements TerminalEmulation {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(GO51Terminal.class);

    private boolean shiftPressed;
    private boolean altPressed;

    private JTerminal term;

    private Go51State termState = Go51State.NORMAL;

    /** For Cursor escape sequence */
    private int go51X;

    public GO51Terminal(JTerminal term) {
        super();
        this.term = term;
    }

    public void parseChar(int c) {
        termState = termState.sendToUI(c, this);
    }

    /**
     * Write a character to the terminal.
     */
    public void writeChar(int c) {
        LOGGER.debug("Char: {}", c);
        term.writeChar((char)c);
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

    private void bell() {
        term.bell();
    }

    private void carriageReturn() {
        term.carriageReturn();
    }

    private void clearScreen() {
        term.clearScreen();
    }

    private void clearToEOL() {
        term.clearToEOL();
    }

    private void clearToEOS() {
        term.clearToEOS();
    }

    private void cursorXY(int x, int y) {
        term.cursorXY(x, y);
    }

    private void cursorLeft() {
        term.cursorLeft();
    }

    private void cursorRight() {
        term.cursorRight();
    }

    private void cursorUp() {
        term.cursorUp();
    }

    private void cursorDown() {
        term.cursorDown();
    }

    private void setAttribute(int attrCode, boolean flag) {
        term.setAttribute(attrCode, flag);
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

    /**
     * State engine to handle GO51 screen command codes.
     */ 
    private enum Go51State {

        NORMAL {
            @Override
            Go51State sendToUI(int val, GO51Terminal h) {

                if (val < 0x07 || (val > 0x0D && val < 0x1B)) {
                    return NORMAL;
                } else {
                    switch (val) {
                    case 0x07:
                        h.bell();
                        return NORMAL;
                    case 0x08:     // Backspace
                        h.cursorLeft();
                        return NORMAL;
                    case 0x0A:    // Line feed
                        h.cursorDown();
                        return NORMAL;
                    case 0x0B:    // Cursor home
                        h.cursorXY(0,0);
                        return NORMAL;
                    case 0x0C:    // Form feed - clear screen
                        h.clearScreen();
                        return NORMAL;
                    case 0x0D:
                        h.carriageReturn();
                        return NORMAL;
                    case 0x1B:  // Escape code
                        return ESCAPE;
                    case 0x1C:
                    case 0x1D:
                    case 0x1E:
                    case 0x1F:
                    case 127:
                        return NORMAL;
                    default:
                        h.writeChar((char)val);
                        return NORMAL;
                    }
                }
            }
        },

        ESCAPE {
            @Override
            Go51State sendToUI(int val, GO51Terminal h) {

                switch (val) {
                case 0x41:
                    return EXPECTX;
                case 0x42:  // Clear to end of line
                    h.clearToEOL();
                    return NORMAL;
                case 0x43:
                    h.cursorRight();
                    return NORMAL;
                case 0x44:
                    h.cursorUp();
                    return NORMAL;
                case 0x45:
                    h.cursorUp();
                    return NORMAL;
                case 0x46:  // Reverse on
                    h.setAttribute(JTerminal.REVERSE, true);
                    return NORMAL;
                case 0x47:  // Reverse off
                    h.setAttribute(JTerminal.REVERSE, false);
                    return NORMAL;
                case 0x48:  // Underline on
                    h.setAttribute(JTerminal.UNDERLINE, true);
                    return NORMAL;
                case 0x49:  // Underline off
                    h.setAttribute(JTerminal.UNDERLINE, false);
                    return NORMAL;
                case 0x4A:   // Clear to end of screen
                    h.clearToEOS();
                    return NORMAL;
                default:
                    return NORMAL;
                }
            }
        },

        EXPECTX {
            @Override
            Go51State sendToUI(int val, GO51Terminal h) {
                h.go51X = val;
                return EXPECTY;
            }
        },

        EXPECTY {
            @Override
            Go51State sendToUI(int val, GO51Terminal h) {
                h.cursorXY(h.go51X, val);
                return NORMAL;
            }
        };

        abstract Go51State sendToUI(int val, GO51Terminal h);

    }

}
