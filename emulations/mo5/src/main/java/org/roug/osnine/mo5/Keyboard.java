package org.roug.osnine.mo5;

import java.awt.event.KeyListener;
import java.awt.event.KeyEvent;
import java.util.HashMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Keyboard listener for MO5.
 * This class interfaces to the GUI and tells the screen what keys are pressed.
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

    /** Interface to the Screen. */
    private Screen screen;

    /** Translation table from charcode to MO5 row/column. */
    private static HashMap<Integer, Integer> charTable = new HashMap(50);

    /** Translation table from scancode to MO5 row/column. */
    private static HashMap<Integer, Integer> codeTable = new HashMap(50);

    private static final int SHIFT   = 0x10000;
    private static final int CONTROL = 0x20000;

    static {
        charTable.put(Integer.valueOf('1'), ROW5 + COL7);
        charTable.put(Integer.valueOf('!'), ROW5 + COL7 + SHIFT);
        charTable.put(Integer.valueOf('2'), ROW4 + COL7);
        charTable.put(Integer.valueOf('"'), ROW4 + COL7 + SHIFT);
        charTable.put(Integer.valueOf('3'), ROW3 + COL7);
        charTable.put(Integer.valueOf('#'), ROW3 + COL7 + SHIFT);
        charTable.put(Integer.valueOf('4'), ROW2 + COL7);
        charTable.put(Integer.valueOf('$'), ROW2 + COL7 + SHIFT);
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
        charTable.put(Integer.valueOf('*'), ROW5 + COL4);
        charTable.put(Integer.valueOf(':'), ROW5 + COL4 + SHIFT);
        charTable.put(Integer.valueOf(' '), ROW4 + COL0);
        charTable.put(Integer.valueOf('©'), ROW6 + COL2 + CONTROL);

        codeTable.put(KeyEvent.VK_A, ROW5 + COL5);
        codeTable.put(KeyEvent.VK_B, ROW4 + COL2);
        codeTable.put(KeyEvent.VK_C, ROW6 + COL2);
        codeTable.put(KeyEvent.VK_D, ROW3 + COL3);
        codeTable.put(KeyEvent.VK_E, ROW3 + COL5);
        codeTable.put(KeyEvent.VK_F, ROW2 + COL3);
        codeTable.put(KeyEvent.VK_G, ROW1 + COL3);
        codeTable.put(KeyEvent.VK_H, ROW0 + COL3);
        codeTable.put(KeyEvent.VK_I, ROW1 + COL4);
        codeTable.put(KeyEvent.VK_J, ROW0 + COL2);
        codeTable.put(KeyEvent.VK_K, ROW1 + COL2);
        codeTable.put(KeyEvent.VK_L, ROW2 + COL2);
        codeTable.put(KeyEvent.VK_M, ROW3 + COL2);
        codeTable.put(KeyEvent.VK_N, ROW0 + COL0);
        codeTable.put(KeyEvent.VK_O, ROW2 + COL4);
        codeTable.put(KeyEvent.VK_P, ROW3 + COL4);
        codeTable.put(KeyEvent.VK_Q, ROW5 + COL3);
        codeTable.put(KeyEvent.VK_R, ROW2 + COL5);
        codeTable.put(KeyEvent.VK_S, ROW4 + COL3);
        codeTable.put(KeyEvent.VK_T, ROW1 + COL5);
        codeTable.put(KeyEvent.VK_U, ROW0 + COL4);
        codeTable.put(KeyEvent.VK_V, ROW5 + COL2);
        codeTable.put(KeyEvent.VK_W, ROW6 + COL0);
        codeTable.put(KeyEvent.VK_X, ROW5 + COL0);
        codeTable.put(KeyEvent.VK_Y, ROW0 + COL5);
        codeTable.put(KeyEvent.VK_Z, ROW4 + COL5);

        /* Specials keys */
        codeTable.put(KeyEvent.VK_BACK_SPACE, ROW5 + COL1); // Plain backspace
        codeTable.put(KeyEvent.VK_DELETE, ROW0 + COL1);
        codeTable.put(KeyEvent.VK_DOWN, ROW4 + COL1);
        codeTable.put(KeyEvent.VK_ENTER, ROW6 + COL4);
        codeTable.put(KeyEvent.VK_HOME, ROW2 + COL1);// Back to top
        codeTable.put(KeyEvent.VK_INSERT, ROW1 + COL1);
        codeTable.put(KeyEvent.VK_LEFT, ROW5 + COL1);
        codeTable.put(KeyEvent.VK_RIGHT, ROW3 + COL1);
        codeTable.put(KeyEvent.VK_SCROLL_LOCK, ROW6 + COL7); //STOP
        codeTable.put(KeyEvent.VK_UP, ROW6 + COL1);

        /* SHIFT + BASIC */
        codeTable.put(KeyEvent.VK_F12, ROW7 + COL0);//Shift
        codeTable.put(KeyEvent.VK_F11, ROW7 + COL1);//Basic

        /* CNT RAZ */
        codeTable.put(KeyEvent.VK_CONTROL, ROW6 + COL5);//CTRL
        codeTable.put(KeyEvent.VK_ESCAPE, ROW6 + COL3); //ESCAPE = raz

    }

    /**
     * Constructor.
     * @param screen - the graphical user interface.
     */
    public Keyboard(Screen screen) {
        this.screen = screen;
    }

    public void keyTyped(KeyEvent e) {
    }

    private void keyMemory(int key, boolean press) {
        screen.setKey(key, press);
    }

    private void keyTranslator(KeyEvent e, boolean press) {
        int tmpChar = e.getKeyChar();
        int tmpCode = e.getKeyCode();

        LOGGER.debug("Key event {}", tmpCode);

        if (charTable.get(tmpChar) != null) {
            int k = charTable.get(tmpChar);
            if ((k & SHIFT) == SHIFT) keyMemory(ROW7 + COL0, press); //Shift
            if ((k & CONTROL) == CONTROL) keyMemory(ROW6 + COL5, press); //Ctrl
            keyMemory(k & ~(SHIFT | CONTROL), press);
            return;
        }

        if (codeTable.get(tmpCode) != null) { // Specials keys test
            keyMemory(codeTable.get(tmpCode), press);
            return;
        }

        if (tmpCode != KeyEvent.VK_SHIFT
                && tmpCode != KeyEvent.VK_CONTROL
                && tmpCode != KeyEvent.VK_ALT)
            LOGGER.debug("Unrecognized Key code: {}", tmpCode);
    }

    public void keyPressed(KeyEvent e) {
        screen.resetAllKeys();
        keyTranslator(e, true);
    }

    public void keyReleased(KeyEvent e) {
        keyTranslator(e, false);
    }

}
