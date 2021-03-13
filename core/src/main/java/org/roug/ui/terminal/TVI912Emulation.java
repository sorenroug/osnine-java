package org.roug.ui.terminal;

import java.awt.Color;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Emulation of a TeleVideo 912 terminal.
 */
public class TVI912Emulation extends EmulationCore {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(TVI912Emulation.class);

    private static final Color DEFAULT_BACKGROUND = new Color(0x1b3231);
    private static final Color DEFAULT_FOREGROUND = new Color(0x88FFFF);
    private static final Color DEFAULT_DIMMED = new Color(0x00D0D0);
    private static final Color DEFAULT_BOLDED = new Color(0xCCFFFF);


    private State termState = State.NORMAL;

    /** For Cursor escape sequence */
    private int coordY;

    @Override
    public void initialize() {
        term.setBackground(DEFAULT_BACKGROUND);
        term.setForeground(DEFAULT_FOREGROUND);
        term.setBoldColor(DEFAULT_BOLDED);
        term.setDimColor(DEFAULT_DIMMED);
        term.setBlockCursor();
    }

    @Override
    public void resetState() {
    }

    @Override
    public int getColumns() {
        return 80;
    }

    @Override
    public int getRows() {
        return 24;
    }

    @Override
    public void parseChar(int c) {
        termState = termState.sendToUI(c, this);
    }

    @Override
    void receiveKeyCode(KeyEvent evt) {
        int keyCode = evt.getKeyCode();
        switch (keyCode) {
//          case KeyEvent.VK_BACK_SPACE:  // is defined char
        case KeyEvent.VK_DELETE:
            dataReceived((char) 0x7F);
            break;
        case KeyEvent.VK_LEFT:
            dataReceived((char) 0x08);
            break;
        case KeyEvent.VK_DOWN:
            dataReceived((char) 0x0A);
            break;
        case KeyEvent.VK_UP:
            dataReceived((char) 0x0B);
            break;
        case KeyEvent.VK_RIGHT:
            dataReceived((char) 0x0C); // Ctrl-L
            break;
        case KeyEvent.VK_HOME:
            dataReceived((char) 0x1E);
            break;
        case KeyEvent.VK_F1:
        case KeyEvent.VK_F2:
        case KeyEvent.VK_F3:
        case KeyEvent.VK_F4:
        case KeyEvent.VK_F5:
        case KeyEvent.VK_F6:
        case KeyEvent.VK_F7:
        case KeyEvent.VK_F8:
        case KeyEvent.VK_F9:
        case KeyEvent.VK_F10:
        case KeyEvent.VK_F11:
            dataReceived((char) 0x01);
            dataReceived((char) ('@' + keyCode - KeyEvent.VK_F1));
            dataReceived((char)0x0D);
            break;
        default:
            LOGGER.debug("Undefined code received: {}", keyCode);
        }
    }

    /*
     * TODO: Handle FUNCT key. Unable to use ALT or AltGr.
     */
    @Override
    void receiveChar(char keyChar, KeyEvent evt) {
        switch (keyChar) {
        /*
        case 9:  // Tab and back-tab.
            if (evt.isShiftDown()) {
            // Back-tab is not transmitted in conversation mode
                dataReceived((char) 0x1B);
                dataReceived('I');
            } else {
                dataReceived((char) 0x09);
            }
            break;
        */
        case '\b':
            dataReceived((char) 0x08);
            break;
        case '\n':
            eolReceived();
            break;
        default:
            LOGGER.debug("Char received: {}", keyChar);
            dataReceived(keyChar);
        }
    }

    /**
     * State engine to handle TVI912 screen command codes.
     */ 
    private enum State {

        NORMAL {
            @Override
            State sendToUI(int val, TVI912Emulation h) {

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
                    case 0x0A:
                        h.cursorDown(true);
                        return NORMAL;
                    case 0x0B:
                        h.cursorUp(true);
                        return NORMAL;
                    case 0x0C:
                        h.cursorRight(true);
                        return NORMAL;
                    case 0x0D:
                        h.carriageReturn();
                        return NORMAL;
                    case 0x1B:  // Escape code
                        return ESCAPE;
                    case 0x1E:    // Cursor home
                        h.cursorXY(0,0);
                        return NORMAL;
                    case 0x1C:
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
            State sendToUI(int val, TVI912Emulation h) {

                switch (val) {
                case '*':    // Clear all to nulls
                    h.clearScreen();
                    return NORMAL;
                case 0x27:  // (Quote) Make protection ineffective (no action)
                    return NORMAL;
                case 'E':
                    h.insertLine();
                    return NORMAL;
                case '=':
                    return EXPECTY;
                case 'T':  // Clear to end of line
                    h.clearToEOL();
                    return NORMAL;
                case ')': // Protected on
                    h.setAttribute(JTerminal.DIMMED, true);
                    return NORMAL;
                case '(':  // Protected off
                    h.setAttribute(JTerminal.DIMMED, false);
                    return NORMAL;
                case 'j':
                    h.setAttribute(JTerminal.REVERSE, true);
                    return NORMAL;
                case 'k':
                    h.setAttribute(JTerminal.REVERSE, false);
                    return NORMAL;
                case 'l':
                    h.setAttribute(JTerminal.UNDERLINE, true);
                    return NORMAL;
                case 'm':
                    h.setAttribute(JTerminal.UNDERLINE, false);
                    return NORMAL;
                case 'Y':  // Clear to end of screen
                    h.clearToEOS();
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
            State sendToUI(int val, TVI912Emulation h) {
                h.coordY = val;
                return EXPECTX;
            }
        },

        EXPECTX {
            @Override
            State sendToUI(int val, TVI912Emulation h) {
                h.cursorXY(val - 32, h.coordY - 32);
                return NORMAL;
            }
        };

        abstract State sendToUI(int val, TVI912Emulation h);

    }

}
