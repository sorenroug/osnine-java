package org.roug.ui.terminal;

import java.awt.Color;
import java.awt.event.KeyEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Emulation of a Heath H-19 / Zenith Z-19 terminal.
 */
public class H19Emulation extends EmulationCore {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(H19Emulation.class);

    private int COLUMNS = 80;
    private int ROWS = 24;

    private static final Color DEFAULT_BACKGROUND = new Color(0x4b534f);
    private static final Color DEFAULT_FOREGROUND = new Color(0x6fa273);

    private State termState = State.NORMAL;

    /** For Cursor escape sequence */
    private int coordY;

    @Override
    public void initialize() {
        term.setBackground(DEFAULT_BACKGROUND);
        term.setForeground(DEFAULT_FOREGROUND);
        term.setBlockCursor();
    }

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

    @Override
    public void parseChar(int c) {
        termState = termState.sendToUI(c, this);
    }


    @Override
    void receiveKeyCode(KeyEvent evt) {
        int keyCode = evt.getKeyCode();
        switch (keyCode) {
        case KeyEvent.VK_DELETE:
            dataReceived((char) 0x7F);
            break;
        case KeyEvent.VK_UP:
            dataReceived((char) 0x1B);
            dataReceived('A');
            break;
        case KeyEvent.VK_DOWN:
            dataReceived((char) 0x1B);
            dataReceived('B');
            break;
        case KeyEvent.VK_RIGHT:
            dataReceived((char) 0x1B);
            dataReceived('C');
            break;
        case KeyEvent.VK_LEFT:
            dataReceived((char) 0x1B);
            dataReceived('D');
            break;
        case KeyEvent.VK_HOME:
            dataReceived((char) 0x1B);
            dataReceived('H');
            break;
        case KeyEvent.VK_INSERT:
            dataReceived((char) 0x1B);
            dataReceived('@');
            break;
        case KeyEvent.VK_F1:
            dataReceived((char) 0x1B);
            dataReceived('S');
            break;
        case KeyEvent.VK_F2:
            dataReceived((char) 0x1B);
            dataReceived('T');
            break;
        case KeyEvent.VK_F3:
            dataReceived((char) 0x1B);
            dataReceived('U');
            break;
        case KeyEvent.VK_F4:
            dataReceived((char) 0x1B);
            dataReceived('V');
            break;
        case KeyEvent.VK_F5:
            dataReceived((char) 0x1B);
            dataReceived('W');
            break;
        default:
            LOGGER.debug("Undefined char received: {}", keyCode);
        }
    }

    @Override
    void receiveChar(char keyChar, KeyEvent evt) {
        switch (keyChar) {
        case '\n':
            eolReceived();
            break;
        default:
            dataReceived(keyChar);
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
                        h.cursorLeft(false);
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
                        if (val < 128)
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
                    h.cursorRight(false);
                    return NORMAL;
                case 'D':
                    h.cursorLeft(false);
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
                h.cursorXY(val - 32, h.coordY - 32);
                return NORMAL;
            }
        };

        abstract State sendToUI(int val, H19Emulation h);

    }

}
