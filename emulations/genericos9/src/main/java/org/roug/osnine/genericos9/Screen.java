package org.roug.osnine.genericos9;

import java.awt.Color;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.Font;
import java.io.IOException;
import javax.swing.text.BadLocationException;
import javax.swing.text.Document;
import javax.swing.text.SimpleAttributeSet;
import javax.swing.text.StyleConstants;

import com.googlecode.lanterna.SGR;
import com.googlecode.lanterna.TerminalPosition;
import com.googlecode.lanterna.TerminalSize;
import com.googlecode.lanterna.terminal.swing.ScrollingSwingTerminal;

import org.roug.osnine.Acia;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Graphical user interface for Acia chip using JTextPane.
 *
 */
public class Screen extends ScrollingSwingTerminal implements UIDevice {

    private int currentFontSize = 16;
    private int rows = 24;
    private int columns = 80;

    /** For Cursor escape sequence */
    private int go51X;

    private boolean shiftDown;

    private static final Logger LOGGER =
            LoggerFactory.getLogger(Screen.class);

    private Acia acia;

    /** Whether the cursor is shown on the screen. */
    private boolean cursorShown;

    /** Does backspace delete the last character? */
    private boolean backspaceDeletes = true;

    private Go51State term = Go51State.NORMAL;

    private Font font = new Font(Font.MONOSPACED, Font.BOLD, currentFontSize);

    /**
     * Constructor.
     *
     * @param acia - The ACIA the user interface talks to
     */
    public Screen(Acia acia) {
        super();
        this.acia = acia;

        addKeyListener(new KeyListener());
        //setFont(font);
        //setBackground(Color.WHITE);


/*
        addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent e) {
                requestFocusInWindow();
            }
        });
*/
    }

    private void logCharacter(int val, String newchar) {
        if (val >= 32 && val <=127) {
            LOGGER.info("{} [{}]", val, newchar);
        } else {
            LOGGER.info("{}", val);
        }
    }

    /**
     * Called from the keyboard event handler.
     * @param i - index into key matrix
     * @param pressed - flag to say if key is on or off.
     */
    public void setKey(int i, boolean pressed) {
    }

    /**
     * Put the character on the canvas.
     * GO51 escape codes.
     *
     * @param val character to display.
     */
    @Override
    public void sendToUI(int val) throws BadLocationException, IOException {
        term = term.sendToUI(val, this);
    }

    /**
     * Event handler for keyboard.
     */
    private class KeyListener extends KeyAdapter {
        @Override
        public void keyReleased(KeyEvent evt) {
            int keyCode = evt.getKeyCode();
            if (keyCode == KeyEvent.VK_SHIFT) shiftDown = false;
        }

        @Override
        public void keyPressed(KeyEvent evt) {
            char keyChar = evt.getKeyChar();
            int keyCode = evt.getKeyCode();
            if (keyChar == KeyEvent.CHAR_UNDEFINED) {
                switch (keyCode) {
                case KeyEvent.VK_SHIFT:
                    shiftDown = true;
                    break;
                case KeyEvent.VK_LEFT:
                    if (shiftDown)
                        acia.dataReceived((char) 0x18);
                    else
                        acia.dataReceived((char) 0x08);
                    break;
                case KeyEvent.VK_RIGHT:
                    if (shiftDown)
                        acia.dataReceived((char) 0x19);
                    else
                        acia.dataReceived((char) 0x09);
                    break;
                case KeyEvent.VK_DOWN:
                    if (shiftDown)
                        acia.dataReceived((char) 0x1A);
                    else
                        acia.dataReceived((char) 0x0A);
                    break;
                case KeyEvent.VK_UP:
                    if (shiftDown)
                        acia.dataReceived((char) 0x1C);
                    else
                        acia.dataReceived((char) 0x0C);
                    break;
                default:
                    LOGGER.debug("Undefined char received: {}", keyCode);
                }
            } else {
                if (keyChar == '\n') {
                    acia.eolReceived();
                } else {
                    LOGGER.debug("Typed: {}", keyCode);
                    acia.dataReceived(keyChar & 0x7F);
                }
            }
        }

    }

    /**
     * State engine to handle GO51 screen command codes.
     */ 
    private enum Go51State {

        NORMAL {
            @Override
            Go51State sendToUI(int val, Screen h)
                    throws BadLocationException,IOException {
                String newchar = Character.toString((char) val);
                TerminalPosition tp;
                switch (val) {
                case 7:
                    h.bell();
                    h.flush();
                    return NORMAL;
                case 8:     // Backspace
                    tp = h.getCursorPosition();
                    if (tp.getColumn() > 0) {
                        h.setCursorPosition(tp.withRelativeColumn(-1));
                        h.putCharacter(' ');
                        h.setCursorPosition(tp.withRelativeColumn(-1));
                        h.flush();
                    }
                    return NORMAL;
                /*
                case 0x0A:    // Line feed
                    tp = h.getCursorPosition();
                    h.setCursorPosition(tp.withRelativeRow(1));
                    h.flush();
                    return NORMAL;
                */
                case 0x0B:    // Cursor home
                    h.setCursorPosition(0,0);
                    h.flush();
                    return NORMAL;
                case 12:    // Form feed - clear screen
                    h.clearScreen();
                    h.flush();
                    return NORMAL;
                case 0:  // Ignore NULLs
                case 3:  // Ignore ETX - End of Text
                case 13: // Ignore carriage returns
                case 14: // Ignore command to go to alpha mode.
                case 127:
                    return NORMAL;
                case 27:
                    return ESCAPE;
                default:
                    h.putCharacter((char)val);
                    h.flush();
                    return NORMAL;
                }
            }
        },

        ESCAPE {
            @Override
            Go51State sendToUI(int val, Screen h)
                    throws BadLocationException,IOException {
                TerminalPosition tp;
                TerminalSize ts;
                int col,cols,row,rows;

                switch (val) {
                case 0x41:
                    return EXPECTX;
                case 0x42:  // Clear to end of line
                    tp = h.getCursorPosition();
                    col = tp.getColumn();
                    ts = h.getTerminalSize();
                    cols = ts.getColumns();
                    for (int x = col; x < cols; x++) {
                        h.putCharacter(' ');
                    }
                    h.setCursorPosition(tp);
                    h.flush();
                    return NORMAL;
                case 0x43:
                    tp = h.getCursorPosition();
                    h.setCursorPosition(tp.withRelativeColumn(1));
                    return NORMAL;
                case 0x44:
                    tp = h.getCursorPosition();
                    h.setCursorPosition(tp.withRelativeRow(-1));
                    return NORMAL;
                case 0x45:
                    tp = h.getCursorPosition();
                    h.setCursorPosition(tp.withRelativeRow(1));
                    return NORMAL;
                case 0x46:  // Reverse on
                    h.enableSGR(SGR.REVERSE);
                    return NORMAL;
                case 0x47:  // Reverse off
                    h.disableSGR(SGR.REVERSE);
                    return NORMAL;
                case 0x48:  // Underline on
                    h.enableSGR(SGR.UNDERLINE);
                    return NORMAL;
                case 0x49:  // Underline off
                    h.disableSGR(SGR.UNDERLINE);
                    return NORMAL;
                case 0x4A:   // Clear to end of screen
                    tp = h.getCursorPosition();
                    col = tp.getColumn();
                    row = tp.getRow();
                    ts = h.getTerminalSize();
                    cols = ts.getColumns();
                    rows = ts.getRows();
                    for (int x = col; x < cols; x++) {
                        h.putCharacter(' ');
                    }
                    for (int y = row + 1; y < rows; y++) {
                        for (int x = 0; x < cols; x++) {
                            h.putCharacter(' ');
                        }
                    }
                    h.setCursorPosition(tp);
                    h.flush();
                    return NORMAL;
                default:
                    return NORMAL;
                }
            }
        },

        EXPECTX {
            @Override
            Go51State sendToUI(int val, Screen h)
                    throws BadLocationException,IOException {
                h.go51X = val;
                return EXPECTY;
            }
        },

        EXPECTY {
            @Override
            Go51State sendToUI(int val, Screen h)
                    throws BadLocationException,IOException {
                h.setCursorPosition(h.go51X, val);
                return NORMAL;
            }
        };

        abstract Go51State sendToUI(int val, Screen h)
                throws BadLocationException,IOException;

    }

}

