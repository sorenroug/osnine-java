package org.roug.ui.terminal;

import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Parse the control sequences from the host and the keys of the keyboard.
 */
public abstract class EmulationCore extends KeyAdapter {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(EmulationCore.class);

    JTerminal term;

    public EmulationCore() {
        super();
    }

    public void setUIDevice(JTerminal term) {
        this.term = term;
    }

    public void resetState() {
    }

    public void parseChar(int c) {
	writeChar(c);
    }

    public void initialize() {}

    public abstract int getColumns();

    public abstract int getRows();

    /**
     * Write a character to the terminal.
     *
     * @param c the 7-bit character to write.
     */
    protected void writeChar(int c) {
        LOGGER.debug("Char: {}", c);
        term.writeChar((char)c);
    }

    /**
     * Sends characters to the host.
     *
     * @param c the 7-bit character to write.
     */
    protected void dataReceived(char c) {
        term.dataReceived(c);
    }

    protected void eolReceived() {
        term.eolReceived();
    }

    protected void bell() {
        term.bell();
    }

    protected void carriageReturn() {
        term.carriageReturn();
    }

    protected void clearScreen() {
        term.clearScreen();
    }

    protected void clearToEOL() {
        term.clearToEOL();
    }

    protected void clearToEOS() {
        term.clearToEOS();
    }

    protected void cursorXY(int x, int y) {
        term.cursorXY(x, y);
    }

    protected void cursorLeft(boolean wrap) {
        term.cursorLeft(wrap);
    }

    protected void cursorRight(boolean wrap) {
        term.cursorRight(wrap);
    }

    protected void cursorUp(boolean scroll) {
        term.cursorUp(scroll);
    }

    protected void cursorDown(boolean scroll) {
        term.cursorDown(scroll);
    }

    protected void setCursorVisible(boolean visible) {
        term.setCursorVisible(visible);
    }

    protected void setAttribute(int attrCode, boolean flag) {
        term.setAttribute(attrCode, flag);
    }

    protected void insertLine() {
        term.insertLine();
    }

    @Override
    public void keyPressed(KeyEvent evt) {
        if (evt.getKeyChar() == KeyEvent.CHAR_UNDEFINED) {
            receiveKeyCode(evt);
        }
    }

    abstract void receiveKeyCode(KeyEvent evt);

    @Override
    public void keyTyped(KeyEvent evt) {
        char keyChar = evt.getKeyChar();
        if (keyChar != KeyEvent.CHAR_UNDEFINED && !evt.isAltDown()) {
            if (keyChar < 128)
                receiveChar(keyChar, evt);
            else
                receiveChar('?', evt);
        }
    }

    abstract void receiveChar(char keyChar, KeyEvent evt);
}
