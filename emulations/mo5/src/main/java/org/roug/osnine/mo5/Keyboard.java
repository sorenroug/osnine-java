package org.roug.osnine.mo5;

import java.awt.event.KeyListener;
import java.awt.event.KeyEvent;
import java.util.HashMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Keyboard listener for MO5.
 * This class interfaces to the GUI and tells the PIA what keys are pressed.
 * The keyboard is arranged in a grid layout of 8 rows and columns. These are
 * connected to the PIA with 3+3 bits for rows and columns respectively.
 * <pre>
 *         0       1       2       3       4       5       6       7
 * 0       N       EFF     J       H       U       Y       7       6
 * 1       ,       INS     K       G       I       T       8       5
 * 2       .       BACK    L       F       O       R       9       4
 * 3       @       RIGHT   M       D       P       E       0       3
 * 4               DOWN    B       S       Z       /       -       2
 * 5       X       LEFT    V       Q       *       A       +       1
 * 6       W       UP      C       RAZ     ENT     CNT     ACC     STOP
 * 7       SHIFT   BASIC
 * </pre>
 * The MO5 does not have lower-case letters.
 */
public class Keyboard implements KeyListener {

    private static final Logger LOGGER = LoggerFactory.getLogger(Keyboard.class);

    /** Key matrix flattend to one dimension. */
    private static final int KEYS = 128;

    private static final int COL0 = 0x00;
    private static final int COL1 = 0x02;
    private static final int COL2 = 0x04;
    private static final int COL3 = 0x06;
    private static final int COL4 = 0x08;
    private static final int COL5 = 0x0A;
    private static final int COL6 = 0x0C;
    private static final int COL7 = 0x0E;

    private static final int ROW0 = 0x00;
    private static final int ROW1 = 0x10;
    private static final int ROW2 = 0x20;
    private static final int ROW3 = 0x30;
    private static final int ROW4 = 0x40;
    private static final int ROW5 = 0x50;
    private static final int ROW6 = 0x60;
    private static final int ROW7 = 0x70;

    /** Table of keys that are pressed on the keyboard. */
    private boolean[] keyMatrix;

    /** Translation table from charcode to MO5 row/column. */
    private static HashMap<Integer, Integer> charTable = new HashMap<Integer,Integer>(50);

    /** Translation table from scancode to MO5 row/column. */
    private static HashMap<Integer, Integer> codeTable = new HashMap<Integer,Integer>(50);

    private static final int SHIFT   = 0x10000;
    private static final int CONTROL = 0x20000;

    private boolean basicPressed;

    static {
        charTable.put(Integer.valueOf('\n'), ROW6 + COL4);
        charTable.put(Integer.valueOf('1'), ROW5 + COL7);
        charTable.put(Integer.valueOf('!'), ROW5 + COL7 + SHIFT);
        charTable.put(Integer.valueOf('2'), ROW4 + COL7);
        charTable.put(Integer.valueOf('"'), ROW4 + COL7 + SHIFT);
        charTable.put(Integer.valueOf('3'), ROW3 + COL7);
        charTable.put(Integer.valueOf('#'), ROW3 + COL7 + SHIFT);
        charTable.put(Integer.valueOf('4'), ROW2 + COL7);
        charTable.put(Integer.valueOf('$'), ROW2 + COL7 + SHIFT);
        charTable.put(Integer.valueOf('¤'), ROW2 + COL7 + SHIFT); // Scandinavian key
        charTable.put(Integer.valueOf('5'), ROW1 + COL7);
        charTable.put(Integer.valueOf('%'), ROW1 + COL7 + SHIFT);
        charTable.put(Integer.valueOf('6'), ROW0 + COL7);
        charTable.put(Integer.valueOf('&'), ROW0 + COL7 + SHIFT);
        charTable.put(Integer.valueOf('7'), ROW0 + COL6);
        charTable.put(Integer.valueOf('\''), ROW0 + COL6 + SHIFT);
        charTable.put(Integer.valueOf('8'), ROW1 + COL6);
        charTable.put(Integer.valueOf('('), ROW1 + COL6 + SHIFT);
        charTable.put(Integer.valueOf('9'), ROW2 + COL6);
        charTable.put(Integer.valueOf(')'), ROW2 + COL6 + SHIFT);
        charTable.put(Integer.valueOf('0'), ROW3 + COL6);
        charTable.put(Integer.valueOf('-'), ROW4 + COL6);
        charTable.put(Integer.valueOf('='), ROW4 + COL6 + SHIFT);
        charTable.put(Integer.valueOf('+'), ROW5 + COL6);
        charTable.put(Integer.valueOf(';'), ROW5 + COL6 + SHIFT);
        charTable.put(Integer.valueOf('/'), ROW4 + COL4);
        charTable.put(Integer.valueOf('?'), ROW4 + COL4 + SHIFT);
        charTable.put(Integer.valueOf(','), ROW1 + COL0);
        charTable.put(Integer.valueOf('<'), ROW1 + COL0 + SHIFT);
        charTable.put(Integer.valueOf('.'), ROW2 + COL0);
        charTable.put(Integer.valueOf('>'), ROW2 + COL0 + SHIFT);
        charTable.put(Integer.valueOf('@'), ROW3 + COL0);
        charTable.put(Integer.valueOf('^'), ROW3 + COL0 + SHIFT);
        charTable.put(Integer.valueOf('å'), ROW3 + COL0 + SHIFT); // Scandinavian key
        charTable.put(Integer.valueOf('*'), ROW5 + COL4);
        charTable.put(Integer.valueOf(':'), ROW5 + COL4 + SHIFT);
        charTable.put(Integer.valueOf(' '), ROW4 + COL0);
        charTable.put(Integer.valueOf('©'), ROW6 + COL2 + CONTROL);

        charTable.put(Integer.valueOf('A'), ROW5 + COL5);
        charTable.put(Integer.valueOf('B'), ROW4 + COL2);
        charTable.put(Integer.valueOf('C'), ROW6 + COL2);
        charTable.put(Integer.valueOf('D'), ROW3 + COL3);
        charTable.put(Integer.valueOf('E'), ROW3 + COL5);
        charTable.put(Integer.valueOf('F'), ROW2 + COL3);
        charTable.put(Integer.valueOf('G'), ROW1 + COL3);
        charTable.put(Integer.valueOf('H'), ROW0 + COL3);
        charTable.put(Integer.valueOf('I'), ROW1 + COL4);
        charTable.put(Integer.valueOf('J'), ROW0 + COL2);
        charTable.put(Integer.valueOf('K'), ROW1 + COL2);
        charTable.put(Integer.valueOf('L'), ROW2 + COL2);
        charTable.put(Integer.valueOf('M'), ROW3 + COL2);
        charTable.put(Integer.valueOf('N'), ROW0 + COL0);
        charTable.put(Integer.valueOf('O'), ROW2 + COL4);
        charTable.put(Integer.valueOf('P'), ROW3 + COL4);
        charTable.put(Integer.valueOf('Q'), ROW5 + COL3);
        charTable.put(Integer.valueOf('R'), ROW2 + COL5);
        charTable.put(Integer.valueOf('S'), ROW4 + COL3);
        charTable.put(Integer.valueOf('T'), ROW1 + COL5);
        charTable.put(Integer.valueOf('U'), ROW0 + COL4);
        charTable.put(Integer.valueOf('V'), ROW5 + COL2);
        charTable.put(Integer.valueOf('W'), ROW6 + COL0);
        charTable.put(Integer.valueOf('X'), ROW5 + COL0);
        charTable.put(Integer.valueOf('Y'), ROW0 + COL5);
        charTable.put(Integer.valueOf('Z'), ROW4 + COL5);

        charTable.put(Integer.valueOf('a'), ROW5 + COL5);
        charTable.put(Integer.valueOf('b'), ROW4 + COL2);
        charTable.put(Integer.valueOf('c'), ROW6 + COL2);
        charTable.put(Integer.valueOf('d'), ROW3 + COL3);
        charTable.put(Integer.valueOf('e'), ROW3 + COL5);
        charTable.put(Integer.valueOf('f'), ROW2 + COL3);
        charTable.put(Integer.valueOf('g'), ROW1 + COL3);
        charTable.put(Integer.valueOf('h'), ROW0 + COL3);
        charTable.put(Integer.valueOf('i'), ROW1 + COL4);
        charTable.put(Integer.valueOf('j'), ROW0 + COL2);
        charTable.put(Integer.valueOf('k'), ROW1 + COL2);
        charTable.put(Integer.valueOf('l'), ROW2 + COL2);
        charTable.put(Integer.valueOf('m'), ROW3 + COL2);
        charTable.put(Integer.valueOf('n'), ROW0 + COL0);
        charTable.put(Integer.valueOf('o'), ROW2 + COL4);
        charTable.put(Integer.valueOf('p'), ROW3 + COL4);
        charTable.put(Integer.valueOf('q'), ROW5 + COL3);
        charTable.put(Integer.valueOf('r'), ROW2 + COL5);
        charTable.put(Integer.valueOf('s'), ROW4 + COL3);
        charTable.put(Integer.valueOf('t'), ROW1 + COL5);
        charTable.put(Integer.valueOf('u'), ROW0 + COL4);
        charTable.put(Integer.valueOf('v'), ROW5 + COL2);
        charTable.put(Integer.valueOf('w'), ROW6 + COL0);
        charTable.put(Integer.valueOf('x'), ROW5 + COL0);
        charTable.put(Integer.valueOf('y'), ROW0 + COL5);
        charTable.put(Integer.valueOf('z'), ROW4 + COL5);

        /* Specials keys */
        codeTable.put(KeyEvent.VK_DEAD_CIRCUMFLEX, ROW3 + COL0 + SHIFT);
        codeTable.put(KeyEvent.VK_DEAD_DIAERESIS, ROW3 + COL0 + SHIFT);
        codeTable.put(KeyEvent.VK_BACK_SPACE, ROW5 + COL1); // Plain backspace
        codeTable.put(KeyEvent.VK_DELETE, ROW0 + COL1);
        codeTable.put(KeyEvent.VK_DOWN, ROW4 + COL1);
        codeTable.put(KeyEvent.VK_HOME, ROW2 + COL1); // Back to top
        codeTable.put(KeyEvent.VK_INSERT, ROW1 + COL1);
        codeTable.put(KeyEvent.VK_LEFT, ROW5 + COL1);
        codeTable.put(KeyEvent.VK_RIGHT, ROW3 + COL1);
        codeTable.put(KeyEvent.VK_SCROLL_LOCK, ROW6 + COL7); //STOP
        codeTable.put(KeyEvent.VK_PAUSE, ROW6 + COL7); //STOP
        codeTable.put(KeyEvent.VK_UP, ROW6 + COL1);

        //codeTable.put(KeyEvent.VK_F12, ROW7 + COL0); //Shift
        codeTable.put(KeyEvent.VK_F11, ROW6 + COL6); // ACC

        codeTable.put(KeyEvent.VK_CONTROL, ROW6 + COL5); //CTRL
        codeTable.put(KeyEvent.VK_ESCAPE, ROW6 + COL3); //ESCAPE = raz

    }

    /**
     * Constructor.
     */
    public Keyboard() {
        keyMatrix = new boolean[KEYS];
        resetAllKeys();
    }

    @Override
    public void keyTyped(KeyEvent e) {
    }

    @Override
    public void keyPressed(KeyEvent e) {
        resetAllKeys();
        keyTranslator(e, true);
    }

    @Override
    public void keyReleased(KeyEvent e) {
        keyTranslator(e, false);
    }

    /**
     * Returns the matrix address for an ASCII code. Used for paste operation.
     *
     * @param charCode the ASCII character to look up.
     * @return matrix code or -1 if the character doesn't appear on the MO5 keyboard.
     */
    public static int getKeyForAscii(int charCode) {
        Integer k = charTable.get(charCode);
        if (k == null) return -1;
        return k;
    }

    /**
     * Called from the keyboard event handler.
     *
     * @param k - index into key matrix
     * @param pressed - flag to say if key is on or off.
     */
    public void setKey(int k, boolean pressed) {
        if ((k & SHIFT) == SHIFT) keyMatrix[ROW7 + COL0] = pressed; //Shift
        if ((k & CONTROL) == CONTROL) keyMatrix[ROW6 + COL5] = pressed; //Ctrl
        if (basicPressed) keyMatrix[ROW7 + COL1] = pressed; // BASIC
        k = k & ~(SHIFT | CONTROL);
        keyMatrix[k] = pressed;
    }

    /**
     * Check key matrix for key press.
     *
     * @param i - index into key matrix
     * @return true is key at that index is pressed.
     */
    public boolean hasKeyPress(int i) {
        return keyMatrix[i];
    }

    private void resetAllKeys() {
        for (int i = 0; i < KEYS; i++) keyMatrix[i] = false;
    }

    private void keyTranslator(KeyEvent e, boolean press) {
        int tmpChar = e.getKeyChar();
        int tmpCode = e.getKeyCode();

        LOGGER.debug("Key event {}", e);
        if (tmpCode == KeyEvent.VK_SHIFT
                && e.getKeyLocation() == KeyEvent.KEY_LOCATION_RIGHT)
                    basicPressed = press;

        if (charTable.get(tmpChar) != null) {
            int k = charTable.get(tmpChar);
            setKey(k, press);
            return;
        }

        if (codeTable.get(tmpCode) != null) { // Specials keys test
            setKey(codeTable.get(tmpCode), press);
            return;
        }

        if (tmpCode != KeyEvent.VK_SHIFT
                && tmpCode != KeyEvent.VK_CONTROL
                && tmpCode != KeyEvent.VK_ALT)
            LOGGER.debug("Unrecognized Key code: {}", tmpCode);
    }

}
