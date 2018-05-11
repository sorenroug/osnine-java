package org.roug.osnine;

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
import javax.swing.text.Caret;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Graphical user interface for Acia chip.
 *
 */
public class AciaGraphicalUI implements Runnable {

    private int currentFontSize = 16;
    private int rows = 24;
    private int columns = 80;

    private static final Logger LOGGER =
            LoggerFactory.getLogger(AciaGraphicalUI.class);

    private Acia acia;

    /** Whether the cursor is shown on the screen. */
    private boolean cursorShown;

    private JFrame mainFrame = new JFrame("Terminal");

    private JTextArea textArea = new JTextArea();

    private Font font = new Font(Font.MONOSPACED, Font.BOLD, currentFontSize);

    /**
     * Constructor.
     */
    public AciaGraphicalUI(Acia acia) {
        this.acia = acia;

        mainFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        textArea.addKeyListener(new KeyListener());
        textArea.setFont(font);
        //textArea.setBorder(BorderFactory.createLineBorder(Color.black));
        textArea.setEditable(false);
        Caret c = textArea.getCaret();
        c.setVisible(true);
        //textArea.setLineWrap(true);

        JMenuBar mb = new JMenuBar();
        JMenu menu = new JMenu("File");

        JMenuItem incrItem = new JMenuItem("Size +");
        incrItem.addActionListener(new FontUpAction());
        menu.add(incrItem);

        JMenuItem decrItem = new JMenuItem("Size -");
        decrItem.addActionListener(new FontDownAction());
        menu.add(decrItem);

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
        LOGGER.debug("AciaGraphicalUI thread started");
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
            LOGGER.debug("{} [{}]", val, newchar);
        } else {
            LOGGER.debug("{}", val);
        }
    }

    /**
     * Put the character on the canvas.
     *
     * @param val character to display.
     */
    void sendToGUI(int val) throws IOException {
        int caretPos = textArea.getCaretPosition();
        String newchar = Character.toString ((char) val);
        if (LOGGER.isDebugEnabled()) {
            logCharacter(val, newchar);
        }

        switch (val) {
        case 7:
            Toolkit.getDefaultToolkit().beep();
            break;
        case 8:
            textArea.setCaretPosition(caretPos - 1);
            break;
        case 12:    // Form feed - clear screen
            textArea.setText("");
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
                textArea.append(newchar);
            } else {
                textArea.replaceRange(newchar, caretPos, caretPos + 1);
            }
            textArea.setCaretPosition(caretPos + 1);
        }

        // Scroll
        if (textArea.getLineCount() > rows) {
            String t = textArea.getText();
            textArea.setText(t.substring(t.indexOf('\n') + 1));
            textArea.setCaretPosition(textArea.getText().length());
        }
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

    /**
     * Decrease the font size.
     */
    private class FontDownAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            currentFontSize--;
            font = new Font(Font.MONOSPACED, Font.BOLD, currentFontSize);
            textArea.setFont(font);
        }
    }

    /**
     * Increase the font size.
     */
    private class FontUpAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            currentFontSize++;
            font = new Font(Font.MONOSPACED, Font.BOLD, currentFontSize);
            textArea.setFont(font);
        }
    }

    private class QuitAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            System.exit(0);
        }
    }

}
