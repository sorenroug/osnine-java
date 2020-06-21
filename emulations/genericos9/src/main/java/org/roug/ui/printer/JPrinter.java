package org.roug.ui.printer;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.print.PageFormat;
import java.awt.print.Paper;
import java.awt.print.PrinterJob;
import java.io.IOException;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextPane;
import javax.swing.text.BadLocationException;
import javax.swing.text.Style;
import javax.swing.text.StyleContext;
import javax.swing.text.StyledDocument;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.roug.ui.UIDevice;

public class JPrinter extends JTextPane implements UIDevice {

    private static final Logger LOGGER =
                    LoggerFactory.getLogger(JPrinter.class);

    private String newline = "\n";

    private StringBuilder textBuffer = new StringBuilder(80);

    public JPrinter() {

        super();
        setEditable(false);
        Font currFont = getFont();
        setFont(new Font("monospaced", currFont.getStyle(), currFont.getSize()));

        StyledDocument doc = getStyledDocument();
        addStylesToDocument(doc);
    }

    private void addStylesToDocument(StyledDocument doc) {
        //Initialize some styles.
        Style def = StyleContext.getDefaultStyleContext().
                        getStyle(StyleContext.DEFAULT_STYLE);

        //Style monospace = doc.addStyle("monospace", def);
        //StyleConstants.setFontFamily(monospace, "monospaced");

    }

    private void printSegment(String segment) throws IOException {
        StyledDocument doc = getStyledDocument();
        try {
            doc.insertString(doc.getLength(), segment, null);
        } catch (BadLocationException ble) {
            LOGGER.error("Couldn't insert text into text pane.", ble);
            throw new IOException();
        }
        repaint();
    }


    /**
     * Print a byte to the text pane. Also executes printer control sequences.
     *
     * @param value the character received from the PIA.
     */
    @Override
    public void sendToUI(int value) throws IOException {
        if (value == 0x0A) {
            textBuffer.append('\n');
            printSegment(textBuffer.toString());
            textBuffer = new StringBuilder(80);
        } else {
            textBuffer.append((char) (value & 0x7F)); // Convert to char
        }
    }



}
