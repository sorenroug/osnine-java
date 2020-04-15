package org.roug.terminal;

import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Emulation of a Heath H-19 / Zenith Z-19 terminal.
 */
public class H19Emulation extends EmulationCore {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(H19Emulation.class);

    public static int COLUMNS = 80;
    public static int ROWS = 24;

    private boolean shiftPressed;
    private boolean altPressed;

    private State termState = State.NORMAL;

    /** For Cursor escape sequence */
    private int coordY;

    @Override
    public void resetState() {
        shiftPressed = false;
        altPressed = false;
    }

    @Override
    public void parseChar(int c) {
        termState = termState.sendToUI(c, this);
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
     * State engine to handle H19 screen command codes.
     */ 
    private enum State {

        NORMAL {
            @Override
            State sendToUI(int val, H19Emulation h) {

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
                        h.cursorDown(true);
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
                        h.writeChar(val);
                        return NORMAL;
                    }
                }
            }
        },

        ESCAPE {
            @Override
            State sendToUI(int val, H19Emulation h) {

                switch (val) {
                case 0x18:   // Cancel escape sequence
                    return NORMAL;
                case 'A':  // Stop if a top line
                    h.cursorUp(false);
                    return NORMAL;
                case 'B':
                    h.cursorDown(true);
                    return NORMAL;
                case 'C':
                    h.cursorRight();
                    return NORMAL;
                case 'D':
                    h.cursorLeft();
                    return NORMAL;
                case 'E':    // Form feed - clear screen
                    h.clearScreen();
                    return NORMAL;
                case 'H':    // Cursor home
                    h.cursorXY(0,0);
                    return NORMAL;
                case 'I':  // Cursor up, scroll if on top line
                    h.cursorUp(true);
                    return NORMAL;
                case 'J':   // Clear to end of screen
                    h.clearToEOS();
                    return NORMAL;
                case 'K':  // Clear to end of line
                    h.clearToEOL();
                    return NORMAL;
                case 'Y':
                    return EXPECTY;
                case 'p':  // Reverse on
                    h.setAttribute(JTerminal.REVERSE, true);
                    return NORMAL;
                case 'q':  // Reverse off
                    h.setAttribute(JTerminal.REVERSE, false);
                    return NORMAL;
                case 'z':  // Reset to power-up configuration
                    h.setAttribute(JTerminal.REVERSE, false);
                    return NORMAL;

                default:
                    return NORMAL;
                }
            }
        },

        EXPECTY {
            @Override
            State sendToUI(int val, H19Emulation h) {
                h.coordY = val;
                return EXPECTX;
            }
        },

        EXPECTX {
            @Override
            State sendToUI(int val, H19Emulation h) {
                h.cursorXY(val + 32, h.coordY + 32);
                return NORMAL;
            }
        };

        abstract State sendToUI(int val, H19Emulation h);

    }

}
