package org.roug.terminal;

import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Emulation of the control sequences for the Dragon 64/Coco 1 VDG.
 * Only the alpha mode display is emulated.
 * Lower case is rendered as lower case.
 */
public class VDGEmulation extends EmulationCore {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(VDGEmulation.class);

    public static int COLUMNS = 32;
    public static int ROWS = 24;

    private boolean shiftPressed;
    private boolean altPressed;

    private State termState = State.NORMAL;

    /** For Cursor escape sequence */
    private int coordX;

    public VDGEmulation(JTerminal term) {
        super(term);
    }

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
     * State engine to handle Coco screen command codes.
     */ 
    private enum State {

        NORMAL {
            @Override
            State sendToUI(int val, VDGEmulation h) {

                if (val > 0x0D && val < 0x20) {
                    return NORMAL;
                } else {
                    switch (val) {
                    case 0x01:    // Cursor home
                        h.cursorXY(0,0);
                        return NORMAL;
                    case 0x02:  // Escape code
                        return EXPECTX;
		    case 0x03:  // Erases the current line.
                        h.carriageReturn();
			h.clearToEOL();
                        return NORMAL;
		    case 0x04:  // Erases from the current character to the end of the line.
			h.clearToEOL();
			return NORMAL;
		    case 0x05:
                        return CURSOR_CMD;
		    case 0x06:
			h.cursorRight();
			return NORMAL;
                    case 0x07:
                        h.bell();
                        return NORMAL;
                    case 0x08:     // Backspace
                        h.cursorLeft();
                        return NORMAL;
		    case 0x09:
			h.cursorUp();
			return NORMAL;
                    case 0x0A:    // Line feed
                        h.cursorDown();
                        return NORMAL;
                    case 0x0B:    // Clear to end of screen
                        h.clearToEOS();
                        return NORMAL;
                    case 0x0C:    // Form feed - clear screen
                        h.clearScreen();
                        return NORMAL;
                    case 0x0D:
                        h.carriageReturn();
                        return NORMAL;
                    case 127:
                        return NORMAL;
                    default:
                        h.writeChar((char)val);
                        return NORMAL;
                    }
                }
            }
        },

	/*
	 * 05 20 Turns off the cursor.
         * 05 21 Turns on the cursor.
         * FIXME: Don't ignore
         */
        CURSOR_CMD {
            @Override
            State sendToUI(int val, VDGEmulation h) {
                return NORMAL;
            }
        },
        EXPECTX {
            @Override
            State sendToUI(int val, VDGEmulation h) {
                h.coordX = val;
                return EXPECTY;
            }
        },

        EXPECTY {
            @Override
            State sendToUI(int val, VDGEmulation h) {
                if (val < 32) val = 32;
                if (h.coordX < 32) h.coordX = 32;
                h.cursorXY(h.coordX - 32, val - 32);
                return NORMAL;
            }
        };

        abstract State sendToUI(int val, VDGEmulation h);

    }

}
