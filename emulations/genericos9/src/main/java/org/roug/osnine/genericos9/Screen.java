package org.roug.osnine.genericos9;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.Font;
import java.awt.Toolkit;
import java.io.IOException;
import javax.swing.JTextPane;
import javax.swing.text.BadLocationException;
import javax.swing.text.Caret;
import javax.swing.text.Document;
import javax.swing.text.SimpleAttributeSet;
import javax.swing.text.StyleConstants;

import org.roug.osnine.Acia;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Graphical user interface for Acia chip using JTextPane.
 *
 */
public class Screen extends JTextPane implements UIDevice {

    private int currentFontSize = 16;
    private int rows = 24;
    private int columns = 80;

    private static final Logger LOGGER =
            LoggerFactory.getLogger(Screen.class);

    private Acia acia;

    /** Whether the cursor is shown on the screen. */
    private boolean cursorShown;

    /** Does backspace delete the last character? */
    private boolean backspaceDeletes = true;

    private Go51State term = Go51State.NORMAL;

    private Document doc = getStyledDocument();
    /** Current style. */
    private SimpleAttributeSet currSet;
    private SimpleAttributeSet normalSet, normalUnderSet;
    private SimpleAttributeSet invertedSet, invertedUnderSet;
    private boolean showUnderline = false;
    private boolean showInverted = false;

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
        setFont(font);
        setBackground(Color.WHITE);

        // Normal, no underline
        normalSet = new SimpleAttributeSet();
        StyleConstants.setBackground(normalSet, Color.WHITE);

        // Normal with underline
        normalUnderSet = new SimpleAttributeSet();
        StyleConstants.setBackground(normalUnderSet, Color.WHITE);
        StyleConstants.setUnderline(normalUnderSet, true);

        // Inverted no underline
        invertedSet = new SimpleAttributeSet();
        StyleConstants.setForeground(invertedSet, Color.WHITE);
        StyleConstants.setBackground(invertedSet, Color.black);

        // Inverted with underline
        invertedUnderSet = new SimpleAttributeSet();
        StyleConstants.setForeground(invertedUnderSet, Color.WHITE);
        StyleConstants.setBackground(invertedUnderSet, Color.black);
        StyleConstants.setUnderline(invertedUnderSet, true);

        currSet = normalSet;
        setEditable(false);

        setPreferredSize(new Dimension(840, 500));
        setMinimumSize(new Dimension(300, 100));

        Caret c = getCaret();
        c.setVisible(true);
        //setLineWrap(true);
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
        // Scroll
        if (getLineCount() > rows) {
           String t = getText();
           setText(t.substring(t.indexOf('\n') + 1));
           setCaretPosition(getText().length());
        }
    }

    private int getLineCount() throws BadLocationException {
        int numNL = 0;
        String t = getText(0, doc.getLength());
        int l = t.length();
        for (int i = 0; i < l; i++) {
            if (t.charAt(i) == '\n') numNL++;
        }
        return numNL;
    }

    /**
     * Event handler for keyboard.
     */
    private class KeyListener extends KeyAdapter {
        public void keyTyped(KeyEvent evt) {
            char keyChar = evt.getKeyChar();
            if (keyChar == '\n') {
                acia.eolReceived();
            } else {
                LOGGER.debug("Typed: {}", keyChar);
                acia.dataReceived(keyChar & 0x7F);
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
                int caretPos = h.getCaretPosition();
                String newchar = Character.toString((char) val);
                switch (val) {
                case 7:
                    Toolkit.getDefaultToolkit().beep();
                    return NORMAL;
                case 8:     // Backspace
                    if (h.backspaceDeletes) {
                        if (caretPos > 0)
                            h.doc.remove(caretPos - 1, 1);
                    } else {
                        h.setCaretPosition(caretPos - 1);
                    }
                    return NORMAL;
                case 11:    // Cursor home
                    h.setCaretPosition(0);
                    return NORMAL;
                case 12:    // Form feed - clear screen
                    h.doc.remove(0, h.doc.getLength());
                    h.currSet = h.normalSet;
                    h.showInverted = false;
                    h.showUnderline = false;
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
                    int l = h.getDocument().getLength();
                    if (caretPos == l) {
                        h.doc.insertString(h.doc.getLength(), newchar, h.currSet);
                    } else {
                        h.doc.insertString(caretPos, newchar, h.currSet);
                        //replaceRange(newchar, caretPos, caretPos + 1);
                    }
                    h.setCaretPosition(caretPos + 1);
                    return NORMAL;
                }
            }
        },

        ESCAPE {
            @Override
            Go51State sendToUI(int val, Screen h)
                    throws BadLocationException,IOException {
                int caretPos = h.getCaretPosition();
                switch (val) {
                case 0x42:  // Clear to end of line
                    h.doc.remove(caretPos, h.doc.getLength() - caretPos);
                    return NORMAL;
                case 0x46:  // Reverse on
                    if (h.showUnderline)
                        h.currSet = h.invertedUnderSet;
                    else
                        h.currSet = h.invertedSet;
                    h.showInverted = true;
                    return NORMAL;
                case 0x47:  // Reverse off
                    if (h.showUnderline)
                        h.currSet = h.normalUnderSet;
                    else
                        h.currSet = h.normalSet;
                    h.showInverted = false;
                    return NORMAL;
                case 0x48:  // Underline on
                    if (h.showInverted)
                        h.currSet = h.invertedUnderSet;
                    else
                        h.currSet = h.normalUnderSet;
                    h.showUnderline = true;
                    return NORMAL;
                case 0x49:  // Underline off
                    if (h.showInverted)
                        h.currSet = h.invertedSet;
                    else
                        h.currSet = h.normalSet;
                    h.showUnderline = false;
                    return NORMAL;
                default:
                    return NORMAL;
                }
            }
        };

        abstract Go51State sendToUI(int val, Screen h)
                throws BadLocationException,IOException;

    }

}

