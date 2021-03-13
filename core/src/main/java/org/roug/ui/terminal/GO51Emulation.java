package org.roug.ui.terminal;

import java.awt.Color;
import java.awt.event.KeyEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Emulation of 51x24 screen for Dragon/Coco
 */
public class GO51Emulation extends EmulationCore {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(GO51Emulation.class);

    private static final Color DEFAULT_BACKGROUND = new Color(0x08ff08);
    private static final Color DEFAULT_FOREGROUND = new Color(0x004200);

    private State termState = State.NORMAL;

    /** For Cursor escape sequence */
    private int coordX;


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
        return 51;
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
        case KeyEvent.VK_CIRCUMFLEX:
            dataReceived('^');
            break;
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
            LOGGER.debug("Unhandled key code received: {}", keyCode);
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
     * State engine to handle GO51 screen command codes.
     */ 
    private enum State {

        NORMAL {
            @Override
            State sendToUI(int val, GO51Emulation h) {

                if (val < 0x07 || (val > 0x0D && val < 0x1B)) {
                    return NORMAL;
                } else {
                    switch (val) {
                    case 0x07:
                        h.bell();
                        return NORMAL;
                    case 0x08:     // Backspace
                        h.cursorLeft(true);
                        return NORMAL;
                    case 0x0A:    // Line feed
                        h.cursorDown(true);
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
                        if (val < 128)
                            h.writeChar(val);
                        return NORMAL;
                    }
                }
            }
        },

        ESCAPE {
            @Override
            State sendToUI(int val, GO51Emulation h) {

                switch (val) {
                case 'A':
                    return EXPECTX;
                case 'B':  // Clear to end of line
                    h.clearToEOL();
                    return NORMAL;
                case 'C':
                    h.cursorRight(true);
                    return NORMAL;
                case 'D':
                    h.cursorUp(true);
                    return NORMAL;
                case 'E':
                    h.cursorDown(true);
                    return NORMAL;
                case 'F':  // Reverse on
                    h.setAttribute(JTerminal.REVERSE, true);
                    return NORMAL;
                case 'G':  // Reverse off
                    h.setAttribute(JTerminal.REVERSE, false);
                    return NORMAL;
                case 'H':  // Underline on
                    h.setAttribute(JTerminal.UNDERLINE, true);
                    return NORMAL;
                case 'I':  // Underline off
                    h.setAttribute(JTerminal.UNDERLINE, false);
                    return NORMAL;
                case 'J':   // Clear to end of screen
                    h.clearToEOS();
                    return NORMAL;
                default:
                    return NORMAL;
                }
            }
        },

        EXPECTX {
            @Override
            State sendToUI(int val, GO51Emulation h) {
                h.coordX = val;
                return EXPECTY;
            }
        },

        EXPECTY {
            @Override
            State sendToUI(int val, GO51Emulation h) {
                h.cursorXY(h.coordX, val);
                return NORMAL;
            }
        };

        abstract State sendToUI(int val, GO51Emulation h);

    }

}
