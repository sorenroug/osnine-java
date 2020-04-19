package org.roug.terminal;

import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Emulation of a Heath H-19 / Zenith Z-19 terminal.
 */
public class TVI912Emulation extends EmulationCore {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(TVI912Emulation.class);


    private State termState = State.NORMAL;

    /** For Cursor escape sequence */
    private int coordY;

    @Override
    public void initialize() {}

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
        case KeyEvent.VK_TAB:
            if (evt.isShiftDown()) {
                dataReceived((char) 0x1B);
                dataReceived('I');
            } else {
                dataReceived((char) 0x09);
            }
            break;
        case KeyEvent.VK_DOWN:
            dataReceived((char) 0x0A);
            dataReceived('B');
            break;
        case KeyEvent.VK_UP:
            dataReceived((char) 0x0B);
            dataReceived('A');
            break;
        case KeyEvent.VK_RIGHT:
            dataReceived((char) 0x0C);
            dataReceived('C');
            break;
        case KeyEvent.VK_HOME:
            dataReceived((char) 0x1E);
            break;
        case KeyEvent.VK_F1:
            dataReceived((char) 0x01);
            dataReceived('@');
            dataReceived((char)0x0D);
            break;
        case KeyEvent.VK_F2:
            dataReceived((char) 0x01);
            dataReceived('A');
            dataReceived((char)0x0D);
            break;
        case KeyEvent.VK_F3:
            dataReceived((char) 0x01);
            dataReceived('B');
            dataReceived((char)0x0D);
            break;
        case KeyEvent.VK_F4:
            dataReceived((char) 0x01);
            dataReceived('C');
            dataReceived((char)0x0D);
            break;
        case KeyEvent.VK_F5:
            dataReceived((char) 0x01);
            dataReceived('D');
            dataReceived((char)0x0D);
            break;
        default:
            LOGGER.debug("Undefined char received: {}", keyCode);
        }
    }

    @Override
    void receiveChar(char keyChar) {
        switch (keyChar) {
        case '\b':
            dataReceived((char) 0x7F);
            break;
        case '\n':
            eolReceived();
            break;
        default:
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
