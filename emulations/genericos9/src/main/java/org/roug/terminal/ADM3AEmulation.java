package org.roug.terminal;

import java.awt.Color;
import java.awt.event.KeyEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Emulation of a Lear-Siegler ADM-3A terminal with upper/lower case
 * display feature. The terminal wraps to the next line when
 * a character is displayed beyond column 80.
 */
public class ADM3AEmulation extends EmulationCore {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(ADM3AEmulation.class);

    private static final Color DEFAULT_BACKGROUND = new Color(0x2d2820);
    private static final Color DEFAULT_FOREGROUND = new Color(0x7ca7f8);
    // Alternative: #8bccd2 #98cff0

    private int COLUMNS = 80;
    private int ROWS = 24;

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
            dataReceived((char) 0x0B);
            break;
        case KeyEvent.VK_DOWN:
            dataReceived((char) 0x0A);
            break;
        case KeyEvent.VK_RIGHT:
            dataReceived((char) 0x0C);
            break;
        case KeyEvent.VK_LEFT:
            dataReceived((char) 0x08);
            break;
        case KeyEvent.VK_HOME:
            dataReceived((char) 0x1E);
            break;
        case KeyEvent.VK_INSERT:
            dataReceived((char) 0x1A);
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
     * State engine to handle ADM-3A screen command codes.
     */ 
    private enum State {

        NORMAL {
            @Override
            State sendToUI(int val, ADM3AEmulation h) {

                if (val < 0x07 || (val > 0x0D && val < 0x1A)) {
                    return NORMAL;
                } else {
                    switch (val) {
                    case 0x07:
                        h.bell();
                        return NORMAL;
                    case 0x08:     // Backspace
                        h.cursorLeft(false);
                        return NORMAL;
                    case 0x0A:
                        h.cursorDown(true);
                        return NORMAL;
                    case 0x0B:
                        h.cursorUp(false);
                        return NORMAL;
                    case 0x0C:
                        h.cursorRight(true);
                        return NORMAL;
                    case 0x0D:
                        h.carriageReturn();
                        return NORMAL;
                    case 0x1A:    // Form feed - clear screen
                        h.clearScreen();
                        return NORMAL;
                    case 0x1B:  // Escape code
                        return ESCAPE;
                    case 0x1E:    // Cursor home
                        h.cursorXY(0,0);
                        return NORMAL;
                    case 0x1D:
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
            State sendToUI(int val, ADM3AEmulation h) {
                switch (val) {
                case '=':
                    return EXPECTY;
                case ')':  // Reverse on  (extension)
                    h.setAttribute(JTerminal.REVERSE, true);
                    return NORMAL;
                case '(':  // Reverse off  (extension)
                    h.setAttribute(JTerminal.REVERSE, false);
                    return NORMAL;
                case 'G':  // (extension)
                    return EXPECTATTR;
                case 'o':
                    return EXPECTOPT;
                default:
                    return NORMAL;
                }
            }
        },

        EXPECTY {
            @Override
            State sendToUI(int val, ADM3AEmulation h) {
                h.coordY = val;
                return EXPECTX;
            }
        },

        EXPECTX {
            @Override
            State sendToUI(int val, ADM3AEmulation h) {
                h.cursorXY(val - 32, h.coordY - 32);
                return NORMAL;
            }
        },

        EXPECTATTR {
            @Override
            State sendToUI(int val, ADM3AEmulation h) {
                switch (val) {
                case '0':  // Normal video
                    h.setAttribute(JTerminal.REVERSE, false);
                    h.setAttribute(JTerminal.UNDERLINE, false);
                    return NORMAL;
                case '4':  // Reverse
                    h.setAttribute(JTerminal.REVERSE, true);
                    return NORMAL;
                case '8':  // Underline
                    h.setAttribute(JTerminal.UNDERLINE, true);
                    return NORMAL;
                case 'G':  // Reverse, underline
                    h.setAttribute(JTerminal.UNDERLINE, true);
                    h.setAttribute(JTerminal.REVERSE, true);
                    return NORMAL;
                default:
                    return NORMAL;
                }
            }
        },

        EXPECTOPT {
            @Override
            State sendToUI(int val, ADM3AEmulation h) {
                switch (val) {
                case '!':  // Reset to power-up configuration
                    h.setAttribute(JTerminal.REVERSE, false);
                    h.setAttribute(JTerminal.UNDERLINE, false);
                    return NORMAL;
                default:
                    return NORMAL;
                }
            }
        };

        abstract State sendToUI(int val, ADM3AEmulation h);

    }

}
