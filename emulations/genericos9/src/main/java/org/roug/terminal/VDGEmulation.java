package org.roug.terminal;

import java.awt.Color;
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

    private static final Color DEFAULT_BACKGROUND = new Color(0x08ff08);
    private static final Color DEFAULT_FOREGROUND = new Color(0x004200);

    private int COLUMNS = 32;
    private int ROWS = 16;

    private State termState = State.NORMAL;

    /** For Cursor escape sequence */
    private int coordX;

    @Override
    public void initialize() {
        term.setBackground(DEFAULT_BACKGROUND);
        term.setForeground(DEFAULT_FOREGROUND);
        term.setBlockCursor();
        term.setCursorBlink(false);
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
            LOGGER.debug("Undefined char received: {}", keyCode);
        }
    }

    void receiveChar(char keyChar) {
        switch (keyChar) {
        case '\n':
            eolReceived();
            break;
        default:
            dataReceived(keyChar);
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
			h.cursorRight(true);
			return NORMAL;
                    case 0x07:
                        h.bell();
                        return NORMAL;
                    case 0x08:     // Backspace
                        h.cursorLeft(true);
                        return NORMAL;
		    case 0x09:
			h.cursorUp(true);
			return NORMAL;
                    case 0x0A:    // Line feed
                        h.cursorDown(true);
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
                        h.writeChar(val);
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
