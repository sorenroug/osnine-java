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

import org.roug.osnine.Acia;
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

    private int COLUMNS = 80;
    private int ROWS = 25;

    private static final int NOATTRS = 0;
    public static final int REVERSE = 1;
    public static final int UNDERLINE = 2;
    public static final int BOLD = 4;
        
    private int cursorX = 0;
    private int cursorY = 0;

    private int currentFontSize = 16;
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
     *
     */
    public JTerminal(Acia acia, int columns, int rows) {
        super();
        this.acia = acia;
        COLUMNS = columns;
        ROWS = rows;
        lines = new Line[ROWS];
        for (int i = 0; i < ROWS; i++)
            lines[i] = new Line(COLUMNS);
        setFontSize(16);
        emulator = new GO51Terminal(this);
        addKeyListener(emulator);

        TimerTask cursortask = new CursorTask();
        Timer timer = new Timer("cursorblink", true);
        timer.schedule(cursortask, 1000, BLINKPERIOD);
    }

    public void setFontSize(int fs) {
        currentFontSize = fs;
        font = new Font(Font.MONOSPACED, Font.PLAIN, currentFontSize);
        FontMetrics fm = getFontMetrics(font);
        colWidth = fm.getMaxAdvance();
        rowHeight = fm.getHeight();
        lineLeading = fm.getLeading();
        lineOffset = fm.getAscent();
        invalidateCache();
        repaint();
    }

    public double getFontSize() {
        return currentFontSize;
    }

    private void invalidateCache() {
        for (int i = 0; i < ROWS; i++)
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
     * Only applies to printable characters. This is not a state engine.
     * FIXME:
     */
    public void writeChar(char c) {
        lines[cursorY].writeChar(c);
        repaintXY(cursorX, cursorY);
        cursorX++;
        if (cursorX == COLUMNS) {
            cursorX = 0;
            cursorDown();
        }
        //repaint();
    }

    /**
     * Put the character on the canvas.
     *
     * @param val character to display.
     */
    @Override
    public void sendToUI(int val) {
        emulator.parseChar(val);
    }


    /*
    void writeString(String s) {
        for (char c : s.toCharArray()) {
            writeChar(c);
        }
    }
    */

    /**
     * Move the cursor up. If it is already
     * on the top line, then scroll the screen downwards.
     */
    void cursorUp() {
        if (cursorY <= 0) {
            scrollDown();
            repaint();
        } else {
            drawCursor = false;
            repaintXY(cursorX, cursorY);
            cursorY--;
            drawCursor = true;
            repaintXY(cursorX, cursorY);
        }
    }

    void cursorDown() {
        if (cursorY >= ROWS - 1)
            scrollUp();
        else
            cursorY++;
    }

    /**
     * Move the cursor left. If it is already in leftmost column
     * then move one up and to the rightmost column.
     */
    void cursorLeft() {
        if (cursorX <= 0) {
           cursorX = COLUMNS - 1;
           cursorUp();
        } else
            cursorX--;
    }

    void cursorRight() {
        if (cursorX >= COLUMNS - 1) {
           cursorX = 0;
           cursorDown();
        } else
            cursorX++;
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
        if (x >= COLUMNS) x = COLUMNS - 1;
        if (y >= ROWS) y = ROWS - 1;
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
        for (int i = 1; i < ROWS; i++)
            lines[i - 1] = lines[i];
        tmpLine.truncate(0);
        lines[ROWS - 1] = tmpLine;
        repaint();
    }

    /**
     * Move the text down and insert one empty line at the top.
     */
    void scrollDown() {
        Line tmpLine = lines[ROWS - 1];
        for (int i = ROWS - 1; i > 0; i--)
            lines[i] = lines[i - 1];
        tmpLine.truncate(0);
        lines[0] = tmpLine;
        repaint();
    }

    void clearScreen() {
        for (int i = 0; i < ROWS; i++)
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
        for (int i = cursorY + 1; i < ROWS; i++)
            lines[i].truncate(0);
        repaint();
    }

    void bell() {
        Toolkit.getDefaultToolkit().beep();
    }

    @Override
    public Dimension getPreferredSize() {
        return new Dimension(COLUMNS * colWidth, ROWS * rowHeight);
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
            if (topY > ROWS) topY = ROWS;
            int leftX = clipBounds.x / colWidth;
            int numChars = clipBounds.width / colWidth;
            if (clipBounds.width % colWidth != 0) numChars++; // Round up
            LOGGER.debug("Redraw chars: {},{} -> {},{}", leftX,bottomY,numChars+leftX, topY);
            for (int i = bottomY; i < topY; i++) {
                AttributedString text = lines[i].getAttrLine();
                AttributedCharacterIterator aci = text.getIterator();
                gc.drawString(aci, 0, i * rowHeight + lineOffset + lineLeading);
            }

        } else {
            // Redraw everything
            LOGGER.debug("Redraw all");
            for (int i = 0; i < ROWS; i++) {
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
        void applyAttribute(int attributeBit, TextAttribute textAttribute,
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
     * Make the cursor blink. (Stub)
     */
    private class CursorTask extends TimerTask {
        @Override
        public void run() {
            drawCursor = !drawCursor;
            repaintXY(cursorX, cursorY);
        }
    }

}
