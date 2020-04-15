package org.roug.terminal;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.font.TextAttribute;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.Toolkit;
import java.text.AttributedString;
import java.text.AttributedCharacterIterator;
import java.util.Timer;
import java.util.TimerTask;
import javax.swing.JPanel;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.roug.usim.Acia;
import org.roug.osnine.genericos9.UIDevice;

/**
 * Graphical screen for Terminal.
 * The terminal is instantiated with the number of columns and rows that is
 * needed.
 */
public class JTerminal extends JPanel implements UIDevice {

    private static final int BLINKPERIOD = 500;  // milliseconds
    private static final Logger LOGGER
                = LoggerFactory.getLogger(JTerminal.class);

    private int columns = 80;
    private int rows = 25;

    private static final int NOATTRS = 0;
    public static final int REVERSE = 1;
    public static final int UNDERLINE = 2;
    public static final int BOLD = 4;
        
    private int cursorX = 0;
    private int cursorY = 0;

    private int currentFontSize = 24;
    private Font font;

    private boolean drawCursor = false;

    /** Width of character in points. */
    private int colWidth;
    /** Height of character in points. */
    private int rowHeight;
    private int lineOffset, lineLeading;

    /** Holds the attributes of the characters to write. */
    private int charAttrs = 0;

    private Line[] lines;

    private Acia acia;

    private TerminalEmulation emulator;

    /**
     * Create the canvas for text.
     */
    public JTerminal(Acia acia, TerminalEmulation emulation) {
        super();
        this.acia = acia;

        this.columns = emulation.getColumns();
        this.rows = emulation.getRows();
        lines = new Line[rows];
        for (int i = 0; i < rows; i++)
            lines[i] = new Line(columns);
        setFontSize(16);
        emulator = emulation;
        emulator.setUIDevice(this);
        addKeyListener(emulator);

        TimerTask cursortask = new CursorTask();
        Timer timer = new Timer("cursorblink", true);
        timer.schedule(cursortask, 1000, BLINKPERIOD);
    }

    public void resetState() {
        emulator.resetState();
    }

    /**
     * Set the size of the font to use in points.
     *
     * @param fs - font size.
     */
    public void setFontSize(int fs) {
        currentFontSize = fs;
        font = new Font(Font.MONOSPACED, Font.PLAIN, currentFontSize);
        FontMetrics fm = getFontMetrics(font);
        colWidth = fm.charWidth('M');
        rowHeight = fm.getHeight();
        lineLeading = fm.getLeading();
        lineOffset = fm.getAscent();
        invalidateCache();
        repaint();
    }

    /**
     * Get the font size in points.
     */
    public int getFontSize() {
        return currentFontSize;
    }

    private void invalidateCache() {
        for (int i = 0; i < rows; i++)
            lines[i].invalidateCache();
    }

    /**
     * Sends characters to the host.
     */
    void dataReceived(char c) {
        acia.dataReceived(c);
    }

    void eolReceived() {
        acia.eolReceived();
    }

    /**
     * Write a character to the terminal.
     * Only applies to printable characters.
     *
     * @param c character to display.
     */
    public void writeChar(char c) {
        lines[cursorY].writeChar(c);
        repaintXY(cursorX, cursorY);
        cursorX++;
        if (cursorX == columns) {
            cursorX = 0;
            cursorDown(true);
        }
    }

    /**
     * Put the character on the canvas. Called from the host,
     * and it is first parsed for control sequences.
     *
     * @param val character to display.
     */
    @Override
    public void sendToUI(int val) {
        emulator.parseChar(val);
    }


    /**
     * Move the cursor up. If "scroll" argument is true and on the top line
     * then scroll the screen downwards, ohterwise stay.
     *
     * @param scroll - flag to tell if the screen can scroll down.
     */
    void cursorUp(boolean scroll) {
        if (cursorY <= 0) {
            if (scroll) {
                scrollDown();
            }
        } else {
            drawCursor = false;
            repaintXY(cursorX, cursorY);
            cursorY--;
            drawCursor = true;
            repaintXY(cursorX, cursorY);
        }
    }

    /**
     * Move the cursor down. If "scroll" argument is true and on the bottom line
     * then scroll the screen upwards, ohterwise stay.
     *
     * @param scroll - flag to tell if the screen can scroll down.
     */
    void cursorDown(boolean scroll) {
        if (cursorY >= rows - 1) {
            if (scroll) {
                scrollUp();
            }
        } else
            cursorY++;
    }

    /**
     * Move the cursor left. If it is already in leftmost column
     * then move one up and to the rightmost column.
     */
    void cursorLeft() {
        if (cursorX <= 0) {
           cursorX = columns - 1;
           cursorUp(true);
        } else {
            cursorX--;
            repaintXY(cursorX, cursorY);
            drawCursor = false;
            repaintXY(cursorX+1, cursorY);
        }
    }

    void cursorRight() {
        if (cursorX >= columns - 1) {
           cursorX = 0;
           cursorDown(true);
        } else
            cursorX++;
        repaintXY(cursorX, cursorY);
    }

    void carriageReturn() {
        int prevX = cursorX;
        cursorX = 0;
        repaintXY(prevX, cursorY);
        drawCursor = true;
        repaintXY(cursorX, cursorY);
    }

    void cursorXY(int x, int y) {
        if (x < 0) x = 0;
        if (y < 0) y = 0;
        if (x >= columns) x = columns - 1;
        if (y >= rows) y = rows - 1;
        int prevX = cursorX;
        int prevY = cursorY;
        cursorX = x;
        cursorY = y;
        repaintXY(prevX, prevY);
        drawCursor = true;
        repaintXY(cursorX, cursorY);
    }

    void setAttribute(int attrCode, boolean flag) {
        if (flag)
            charAttrs |= attrCode;
        else
            charAttrs &= ~attrCode;
    }

    /**
     * Move the text up and insert one empty line at the bottom.
     */
    void scrollUp() {
        Line tmpLine = lines[0];
        for (int i = 1; i < rows; i++)
            lines[i - 1] = lines[i];
        tmpLine.truncate(0);
        lines[rows - 1] = tmpLine;
        repaint();
    }

    /**
     * Move the text down and insert one empty line at the top.
     */
    void scrollDown() {
        Line tmpLine = lines[rows - 1];
        for (int i = rows - 1; i > 0; i--)
            lines[i] = lines[i - 1];
        tmpLine.truncate(0);
        lines[0] = tmpLine;
        repaint();
    }

    void clearScreen() {
        for (int i = 0; i < rows; i++)
            lines[i].truncate(0);
        cursorX = 0;
        cursorY = 0;
        repaint();
    }

    /**
     * Clear to end of line.
     */
    void clearToEOL() {
        lines[cursorY].truncate(cursorX);
        repaint();
    }

    /**
     * Clear to end of screen.
     */
    void clearToEOS() {
        lines[cursorY].truncate(cursorX);
        for (int i = cursorY + 1; i < rows; i++)
            lines[i].truncate(0);
        repaint();
    }

    void bell() {
        Toolkit.getDefaultToolkit().beep();
    }

    @Override
    public Dimension getPreferredSize() {
        return new Dimension(columns * colWidth, rows * rowHeight);
    }

    private void repaintXY(int x, int y) {
        repaint(x * colWidth,
                y * rowHeight + lineLeading,
                colWidth, rowHeight - lineLeading);
    }

    /**
     * FIXME: Should also just paint that one character that usually
     * is written.
     */
    @Override
    protected void paintComponent(Graphics gc) {
        super.paintComponent(gc);
        Rectangle clipBounds = gc.getClipBounds();
        if (clipBounds != null) {
            int bottomY = clipBounds.y / rowHeight; // Round down
            int topY = clipBounds.height / rowHeight + bottomY + 1;
            if (topY > rows) topY = rows;
            int leftX = clipBounds.x / colWidth;
            int numChars = clipBounds.width / colWidth;
            if (clipBounds.width % colWidth != 0) numChars++; // Round up
            LOGGER.debug("Redraw chars: {},{} -> {},{}", leftX,bottomY,
                            numChars+leftX, topY);
            for (int i = bottomY; i < topY; i++) {
                AttributedString text = lines[i].getAttrLine();
                AttributedCharacterIterator aci = text.getIterator();
                gc.drawString(aci, 0, i * rowHeight + lineOffset + lineLeading);
            }

        } else {
            // Redraw everything
            LOGGER.debug("Redraw all");
            for (int i = 0; i < rows; i++) {
                AttributedString text = lines[i].getAttrLine();
                gc.drawString(text.getIterator(), 0, i * rowHeight + lineOffset + lineLeading);
            }
        }
        if (drawCursor) {
            //FIXME: use getComposite/setComposite in Graphics2D
            //gc.setXORMode(Color.WHITE);
            //gc.setXORMode((Graphics2D) gc.getBackground());
            gc.fillRect(cursorX * colWidth, cursorY * rowHeight + lineLeading,
                colWidth, rowHeight - lineLeading);
            //gc.setPaintMode();
        }
    }


    /**
     * Represent a line on the terminal.
     * Track character attributes and length of string.
     */
    private class Line {
        private int maxLength;

        /** Number of characters in line. 0 if there are no characters. */
        private int countChar;
        private char[] line;
        private AttributedString attrCache;
        private int[] attributes;

        Line(int len) {
            maxLength = len;
            line = new char[len];
            attributes = new int[len];
            countChar = 0;
        }

        void invalidateCache() {
            attrCache = null;
        }

        /**
         * Truncate line to new character count.
         */
        void truncate(int newCount) {
            attrCache = null;
            countChar = newCount; 
            for (int i = 0; i < maxLength; i++)
                attributes[i] = NOATTRS;
        }

        /**
         * Write a character anywhere on the line. The line is filled with
         * spaces up to the character written.
         * TODO: Complain if the column goes beyond the limit.
         *       Ignore newlines.
         */
        void writeChar(char c) {
            attrCache = null;
            for (int i = countChar; i < cursorX; i++) {
                attributes[i] = NOATTRS;
                line[i] = ' ';
            }
            line[cursorX] = c;
            attributes[cursorX] = charAttrs;
            if (countChar <= cursorX) countChar = cursorX + 1;
        }

        AttributedString getAttrLine() {
            if (attrCache != null)
                return attrCache;
            attrCache = new AttributedString(String.valueOf(line, 0, countChar));
            if (countChar > 0) {
                attrCache.addAttribute(TextAttribute.FONT, font, 0, countChar);
                applyAttribute(REVERSE, TextAttribute.SWAP_COLORS,
                            TextAttribute.SWAP_COLORS_ON);
                applyAttribute(UNDERLINE, TextAttribute.UNDERLINE,
                            TextAttribute.UNDERLINE_ON);
                applyAttribute(BOLD, TextAttribute.WEIGHT,
                            TextAttribute.WEIGHT_ULTRABOLD);
                //attrCache.addAttribute(TextAttribute.FOREGROUND,
                            //Color.BLUE, 0, countChar);
            }
            return attrCache;
        }

        /**
         * Apply attributes in as long stretches as possible.
         */
        private void applyAttribute(int attributeBit, TextAttribute textAttribute,
                            Object value) {
            boolean attrFlag = false;
            int runStart = -1;
            for (int i = 0; i < countChar; i++) {
                if ((attributes[i] & attributeBit) == attributeBit) {
                    attrFlag = true;
                    if (runStart == -1) runStart = i;
                } else {
                    if (attrFlag) {
                        attrCache.addAttribute(textAttribute, value, runStart, i);
                        attrFlag = false;
                        runStart = -1;
                    }
                }
            }
            if (attrFlag) {
                attrCache.addAttribute(textAttribute, value, runStart, countChar);
            }
        }
    }

    /**
     * Make the cursor blink.
     */
    private class CursorTask extends TimerTask {
        @Override
        public void run() {
            drawCursor = !drawCursor;
            repaintXY(cursorX, cursorY);
        }
    }

}
