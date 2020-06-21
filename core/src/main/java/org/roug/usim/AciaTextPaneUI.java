package org.roug.usim;

import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.Font;
import java.awt.Toolkit;
import java.io.InputStream;
import java.io.IOException;
import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JTextArea;
import javax.swing.JTextPane;
import javax.swing.text.BadLocationException;
import javax.swing.text.Caret;
import javax.swing.text.Document;
import javax.swing.text.SimpleAttributeSet;
import javax.swing.text.StyleConstants;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Graphical user interface for Acia chip using JTextPane.
 *
 */
public class AciaTextPaneUI implements Runnable {

    private int currentFontSize = 16;
    private int rows = 24;
    private int columns = 80;

    private static final Logger LOGGER =
            LoggerFactory.getLogger(AciaTextPaneUI.class);

    private Acia acia;

    /** Whether the cursor is shown on the screen. */
    private boolean cursorShown;

    /** Does backspace delete the last character? */
    private boolean backspaceDeletes = true;

    private JFrame mainFrame = new JFrame("Terminal");

    private JTextPane textArea = new JTextPane();

    private Document doc = textArea.getStyledDocument();
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
    public AciaTextPaneUI(Acia acia) {
        this.acia = acia;

        mainFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        textArea.addKeyListener(new KeyListener());
        textArea.setFont(font);
        textArea.setBackground(Color.green);

        // Normal, no underline
        normalSet = new SimpleAttributeSet();
        StyleConstants.setBackground(normalSet, Color.green);

        // Normal with underline
        normalUnderSet = new SimpleAttributeSet();
        StyleConstants.setBackground(normalUnderSet, Color.green);
        StyleConstants.setUnderline(normalUnderSet, true);

        // Inverted no underline
        invertedSet = new SimpleAttributeSet();
        StyleConstants.setForeground(invertedSet, Color.green);
        StyleConstants.setBackground(invertedSet, Color.black);

        // Inverted with underline
        invertedUnderSet = new SimpleAttributeSet();
        StyleConstants.setForeground(invertedUnderSet, Color.green);
        StyleConstants.setBackground(invertedUnderSet, Color.black);
        StyleConstants.setUnderline(invertedUnderSet, true);

        currSet = normalSet;
        textArea.setEditable(false);
        Caret c = textArea.getCaret();
        c.setVisible(true);
        //textArea.setLineWrap(true);

        JMenuBar mb = new JMenuBar();
        JMenu menu = new JMenu("File");

        JMenuItem quitItem = new JMenuItem("Quit");
        quitItem.addActionListener(new QuitAction());
        menu.add(quitItem);

        mb.add(menu);
        mainFrame.setJMenuBar(mb);

        mainFrame.setSize(1000,600);
        mainFrame.add(textArea);
        mainFrame.setVisible(true);
    }

    public void run() {
        LOGGER.debug("Thread started");
        try {
            acia.setDCD(true);
            try {
                while (true) {
                    int val = acia.waitForValueToTransmit();
                    sendToGUI(val);
                    if (Thread.interrupted())
                        throw new InterruptedException();
                }
            } catch (InterruptedException e) {
                LOGGER.error("InterruptException");
            } catch (Exception e) {
                LOGGER.error("Broken connection", e);
            }
            acia.setDCD(false);
        } catch (Exception e) {
            LOGGER.error("GUI exception");
        }
        System.exit(2);
    }

    private void logCharacter(int val, String newchar) {
        if (val >= 32 && val <=127) {
            LOGGER.info("{} [{}]", val, newchar);
        } else {
            LOGGER.info("{}", val);
        }
    }

    /**
     * Put the character on the canvas.
     * GO51 escape codes.
     *
     * @param val character to display.
     */
    void sendToGUI(int val) throws BadLocationException,IOException {
        int caretPos = textArea.getCaretPosition();
        String newchar = Character.toString((char) val);
        //logCharacter(val, newchar);

        switch (val) {
        case 7:
            Toolkit.getDefaultToolkit().beep();
            break;
        case 8:     // Backspace
            if (backspaceDeletes) {
                if (caretPos > 0)
                    doc.remove(caretPos - 1, 1);
            } else {
                textArea.setCaretPosition(caretPos - 1);
            }
            break;
        case 11:    // Cursor home
            textArea.setCaretPosition(0);
            break;
        case 12:    // Form feed - clear screen
            doc.remove(0, doc.getLength());
            currSet = normalSet;
            break;
        case 0:  // Ignore NULLs
        case 3:  // Ignore ETX - End of Text
        case 13: // Ignore carriage returns
        case 14: // Ignore command to go to alpha mode.
        case 127:
            break;
        default:
            int l = textArea.getDocument().getLength();
            if (caretPos == l) {
                doc.insertString(doc.getLength(), newchar, currSet);
            } else {
                doc.insertString(caretPos, newchar, currSet);
                //textArea.replaceRange(newchar, caretPos, caretPos + 1);
            }
            textArea.setCaretPosition(caretPos + 1);
        }

        // Scroll
        if (getLineCount() > rows) {
            String t = textArea.getText();
            textArea.setText(t.substring(t.indexOf('\n') + 1));
            textArea.setCaretPosition(textArea.getText().length());
        }
    }

    private int getLineCount() throws BadLocationException {
        int numNL = 0;
        String t = textArea.getText(0, doc.getLength());
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
                acia.dataReceived(keyChar & 0x7F);
            }
        }

    }

    private static class QuitAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            System.exit(0);
        }
    }

    /**
     * State engine to handle telnet protocol.
     */
    private enum Go51State {

        NORMAL {
            @Override
            Go51State sendToGUI(int val, AciaTextPaneUI h)
                    throws BadLocationException,IOException {
                int caretPos = h.textArea.getCaretPosition();
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
                        h.textArea.setCaretPosition(caretPos - 1);
                    }
                    return NORMAL;
                case 11:    // Cursor home
                    h.textArea.setCaretPosition(0);
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
                    int l = h.textArea.getDocument().getLength();
                    if (caretPos == l) {
                        h.doc.insertString(h.doc.getLength(), newchar, h.currSet);
                    } else {
                        h.doc.insertString(caretPos, newchar, h.currSet);
                        //textArea.replaceRange(newchar, caretPos, caretPos + 1);
                    }
                    h.textArea.setCaretPosition(caretPos + 1);
                    return NORMAL;
                }
            }
        },

        ESCAPE {
            @Override
            Go51State sendToGUI(int val, AciaTextPaneUI h)
                    throws BadLocationException,IOException {
                int caretPos = h.textArea.getCaretPosition();
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

        abstract Go51State sendToGUI(int val, AciaTextPaneUI h)
                throws BadLocationException,IOException;

    }

}

