package org.roug.osnine.mo5;

import javax.swing.*;
import javax.swing.text.*;

import java.awt.*;
import java.awt.event.*;
import java.awt.image.BufferedImage;
import java.awt.image.DataBuffer;
import java.awt.image.DataBufferByte;
import java.awt.image.IndexColorModel;
import java.awt.image.Raster;
import java.awt.image.WritableRaster;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PrinterDialog {

    private static final Logger LOGGER =
                    LoggerFactory.getLogger(PrinterDialog.class);

    private static final int COLUMNS = 320;
    private static final int ROWS = 200;

    private String newline = "\n";
    private JDialog printerDialog;
    private JTextPane textPane;

    private boolean screenDump = false;
    private int bytesDumped;

    private byte[] pixels = new byte[COLUMNS * ROWS / 8];
    private StringBuilder textBuffer = new StringBuilder(80);

    public PrinterDialog(JFrame parent) {
        printerDialog = new JDialog(parent, "Printer", false);
        printerDialog.setLayout(new BorderLayout());

        JPanel buttonRow = new JPanel();
        buttonRow.setLayout(new FlowLayout());

        printerDialog.add(buttonRow, BorderLayout.PAGE_START);

        JButton printButton = new JButton("Print");
        printButton.addActionListener(new PrintAction());
        buttonRow.add(printButton);

        JButton clearButton = new JButton("Clear");
        clearButton.addActionListener(new ClearAction());
        buttonRow.add(clearButton);

        //Create a text pane.
        textPane = createTextPane();
        JScrollPane paneScrollPane = new JScrollPane(textPane);
        paneScrollPane.setVerticalScrollBarPolicy(
                        JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        paneScrollPane.setPreferredSize(new Dimension(600, 700));
        paneScrollPane.setMinimumSize(new Dimension(100, 100));

        printerDialog.add(paneScrollPane, BorderLayout.CENTER);

        printerDialog.pack();
        //printerDialog.setSize(300,300);

    }

    private JTextPane createTextPane() {

        JTextPane textPane = new JTextPane();
        textPane.setEditable(false);
        Font currFont = textPane.getFont();
        textPane.setFont(new Font("monospaced", currFont.getStyle(), currFont.getSize()));

        StyledDocument doc = textPane.getStyledDocument();
        addStylesToDocument(doc);

        return textPane;
    }

    private void addStylesToDocument(StyledDocument doc) {
        //Initialize some styles.
        Style def = StyleContext.getDefaultStyleContext().
                        getStyle(StyleContext.DEFAULT_STYLE);

        Style monospace = doc.addStyle("monospace", def);
        //StyleConstants.setFontFamily(monospace, "monospaced");

    }

    private ImageIcon createImage() {

        byte[] bw = {(byte) 0xff, (byte) 0};

        IndexColorModel blackAndWhite = new IndexColorModel(
                                        1, // One bit per pixel
                                        2, // Two values in the component arrays
                                        bw, // Red Components
                                        bw, // Green Components
                                        bw);// Blue Components

        DataBuffer db = new DataBufferByte(pixels, pixels.length);
        WritableRaster wr = Raster.createPackedRaster(db, COLUMNS, ROWS, 1, null);
        BufferedImage im = new BufferedImage(blackAndWhite, wr, true, null);
        return new ImageIcon(im);
    }

    private void printSegment(String segment) {
        StyledDocument doc = textPane.getStyledDocument();
        try {
            doc.insertString(doc.getLength(), segment, null);
        } catch (BadLocationException ble) {
            LOGGER.error("Couldn't insert text into text pane.", ble);
        }
        textPane.repaint();
    }

    private void createIconStyle() {
        Style def = StyleContext.getDefaultStyleContext().
                        getStyle(StyleContext.DEFAULT_STYLE);
        StyledDocument doc = textPane.getStyledDocument();
        Style s = doc.addStyle(null, def);
        StyleConstants.setAlignment(s, StyleConstants.ALIGN_CENTER);
        ImageIcon screenPrint = createImage();
        StyleConstants.setIcon(s, screenPrint);
        try {
            doc.insertString(doc.getLength(), " ", s);
        } catch (BadLocationException ble) {
            LOGGER.error("Couldn't insert image into text pane.", ble);
        }
        printSegment("\n");
    }

    /**
     * Print a byte to the text pane. Also executes printer control sequences.
     *
     * @param value the character received from the PIA.
     */
    public void printOneByte(int value) {
            if (screenDump) {
                pixels[bytesDumped] = (byte) value;
                bytesDumped++;
                if (bytesDumped == 8000) {
                    screenDump = false;
                    createIconStyle();
                }
            } else {
                if (value == 0xFF) {
                } else if (value == 0x07) { // Screen print mode
                    bytesDumped = 0;
                    screenDump = true;
                } else if (value == 0xF5) {
                   // Continuation of text mode. No action currently.
                } else if (value == 0x0A) {
                    textBuffer.append('\n');
                    printSegment(textBuffer.toString());
                    textBuffer = new StringBuilder(80);
                } else {
                    textBuffer.append((char) (value & 0x7F)); // Convert to char
                }
            }

    }

    public void setVisible(boolean visible) {
        printerDialog.setVisible(visible);
    }

    private class PrintAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            try {
                textPane.print();
            } catch (Exception pex) {
                JOptionPane.showMessageDialog(null, "Error while printing");
                LOGGER.error("Couldn't print text pane", pex);
            }
        }
    }

    private class ClearAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            try {
                StyledDocument doc = textPane.getStyledDocument();
                doc.remove(0, doc.getLength());
            } catch (BadLocationException ble) {
                LOGGER.error("Couldn't clear text pane", ble);
            }
        }
    }

}
