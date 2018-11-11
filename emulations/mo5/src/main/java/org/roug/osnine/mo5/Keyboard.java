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
 * 
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

    // translation table from scancode to java keycodes VK_
    private static HashMap<Integer, Integer> ftable = new HashMap(100);

    private static final int EVENT = 0x8000;

    static {
        /* 1 .. ACC */
        ftable.put(Integer.valueOf('1'), ROW5 + COL7);
        ftable.put(Integer.valueOf('2'), ROW4 + COL7);
        ftable.put(Integer.valueOf('3'), ROW3 + COL7);
        ftable.put(Integer.valueOf('4'), ROW2 + COL7);
        ftable.put(Integer.valueOf('5'), ROW1 + COL7);
        ftable.put(Integer.valueOf('6'), ROW0 + COL7);
        ftable.put(Integer.valueOf('7'), ROW0 + COL6);
        ftable.put(Integer.valueOf('8'), ROW1 + COL6);
        ftable.put(Integer.valueOf('9'), ROW2 + COL6);
        ftable.put(Integer.valueOf('0'), ROW3 + COL6);
        ftable.put(Integer.valueOf('-'), ROW4 + COL6);
        ftable.put(Integer.valueOf('+'), ROW5 + COL6);
        //ftable.put(KeyEvent.VK_BACK_SPACE + EVENT, ROW6 + COL6);
        ftable.put(KeyEvent.VK_BACK_SPACE + EVENT, ROW5 + COL1); // Plain backspace
        /* A .. --> */
        ftable.put(Integer.valueOf('a'), ROW5 + COL5);
        ftable.put(Integer.valueOf('z'), ROW4 + COL5);
        ftable.put(Integer.valueOf('e'), ROW3 + COL5);
        ftable.put(Integer.valueOf('r'), ROW2 + COL5);
        ftable.put(Integer.valueOf('t'), ROW1 + COL5);
        ftable.put(Integer.valueOf('y'), ROW0 + COL5);
        ftable.put(Integer.valueOf('u'), ROW0 + COL4);
        ftable.put(Integer.valueOf('i'), ROW1 + COL4);
        ftable.put(Integer.valueOf('o'), ROW2 + COL4);
        ftable.put(Integer.valueOf('p'), ROW3 + COL4);
        ftable.put(Integer.valueOf('/'), ROW4 + COL4);
        //ftable.put(Integer.valueOf(')'), ROW5 + COL4);
        /* Q .. enter */
        ftable.put(Integer.valueOf('q'), ROW5 + COL3);
        ftable.put(Integer.valueOf('s'), ROW4 + COL3);
        ftable.put(Integer.valueOf('d'), ROW3 + COL3);
        ftable.put(Integer.valueOf('f'), ROW2 + COL3);
        ftable.put(Integer.valueOf('g'), ROW1 + COL3);
        ftable.put(Integer.valueOf('h'), ROW0 + COL3);
        ftable.put(Integer.valueOf('j'), ROW0 + COL2);
        ftable.put(Integer.valueOf('k'), ROW1 + COL2);
        ftable.put(Integer.valueOf('l'), ROW2 + COL2);
        ftable.put(Integer.valueOf('m'), ROW3 + COL2);
        ftable.put(KeyEvent.VK_ENTER + EVENT, ROW6 + COL4);
        /* W .. , */
        ftable.put(Integer.valueOf('w'), ROW6 + COL0);
        ftable.put(Integer.valueOf('x'), ROW5 + COL0);
        ftable.put(Integer.valueOf('c'), ROW6 + COL2);
        ftable.put(Integer.valueOf('v'), ROW5 + COL2);
        ftable.put(Integer.valueOf('b'), ROW4 + COL2);
        ftable.put(Integer.valueOf('n'), ROW0 + COL0);
        ftable.put(Integer.valueOf(','), ROW1 + COL0);
        ftable.put(Integer.valueOf('.'), ROW2 + COL0);
        ftable.put(Integer.valueOf('@'), ROW3 + COL0);
        ftable.put(KeyEvent.VK_SCROLL_LOCK + EVENT, ROW6 + COL7); //STOP
        ftable.put(Integer.valueOf('*'), ROW5 + COL4);

        /* Specials keys */
        ftable.put(KeyEvent.VK_INSERT + EVENT, ROW1 + COL1);
        ftable.put(KeyEvent.VK_DELETE + EVENT, ROW0 + COL1);
        ftable.put(KeyEvent.VK_HOME + EVENT, ROW2 + COL1);// Back to top
        ftable.put(KeyEvent.VK_UP + EVENT, ROW6 + COL1);
        ftable.put(KeyEvent.VK_LEFT + EVENT, ROW5 + COL1);
        ftable.put(KeyEvent.VK_RIGHT + EVENT, ROW3 + COL1);
        ftable.put(KeyEvent.VK_DOWN + EVENT, ROW4 + COL1);
        /* space */
        ftable.put(Integer.valueOf(' '), ROW4 + COL0);
        /* SHIFT + BASIC */
        ftable.put(KeyEvent.VK_F12 + EVENT, ROW7 + COL0);//Shift
        ftable.put(KeyEvent.VK_F11 + EVENT, ROW7 + COL1);//Basic

        /* CNT RAZ */
        ftable.put(KeyEvent.VK_CONTROL + EVENT, ROW6 + COL5);//CTRL
        ftable.put(KeyEvent.VK_ESCAPE + EVENT, ROW6 + COL3);//ESCAPE = raz
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
        int tmpCode = e.getKeyCode() + EVENT;

        LOGGER.debug("Key event {}", tmpCode);

        switch(tmpChar) {
            case '!':
                keyMemory(ROW7 + COL0, press);//Shift
                keyMemory(ROW5 + COL7, press);//1
                return;
            case '"':
                keyMemory(ROW7 + COL0, press);//Shift
                keyMemory(ROW4 + COL7, press);//2
                return;
            case '#':
                keyMemory(ROW7 + COL0, press);//Shift
                keyMemory(ROW3 + COL7, press);//3
                return;
            case '$':
                keyMemory(ROW7 + COL0, press);//Shift
                keyMemory(ROW2 + COL7, press);//4
                return;
            case '%':
                keyMemory(ROW7 + COL0, press);//Shift
                keyMemory(ROW1 + COL7, press);//5
                return;
            case '&':
                keyMemory(ROW7 + COL0, press);//Shift
                keyMemory(ROW0 + COL7, press);//6
                return;
            case 39://'
                keyMemory(ROW7 + COL0, press);//Shift
                keyMemory(ROW0 + COL6, press);//7
                return;
            case '(':
                keyMemory(ROW7 + COL0, press);//Shift
                keyMemory(ROW1 + COL6, press);//8
                return;
            case ')':
                keyMemory(ROW7 + COL0, press);//Shift
                keyMemory(ROW2 + COL6, press);//9
                return;
            case '=':
                keyMemory(ROW7 + COL0, press);//Shift
                keyMemory(ROW4 + COL6, press);//-
                return;
            case ';':
                keyMemory(ROW7 + COL0, press);//Shift
                keyMemory(ROW5 + COL6, press);//+
                return;
            case '?':
                keyMemory(ROW7 + COL0, press);//Shift
                keyMemory(ROW4 + COL4, press);// /
                return;
            case ':':
                keyMemory(ROW7 + COL0, press);//Shift
                keyMemory(ROW5 + COL4, press);//*
                return;
            case '<':
                keyMemory(ROW7 + COL0, press);//Shift
                keyMemory(ROW1 + COL0, press);//,
                return;
            case '>':
                keyMemory(ROW7 + COL0, press);//Shift
                keyMemory(ROW2 + COL0, press);//.
                return;
            case '^':
                keyMemory(ROW7 + COL0, press);//Shift
                keyMemory(ROW3 + COL0, press);//@
                return;
            case '©':
                keyMemory(ROW6 + COL5, press);//Ctrl
                keyMemory(ROW6 + COL2, press);//C
                return;
            default:
                break;
        }

        if (ftable.get(tmpCode) != null) { // Specials keys test
            keyMemory(ftable.get(tmpCode), press);
            return;
        } else {
            if((tmpChar >= 'A') && (tmpChar <= 'Z')) // Uppercase test
                tmpChar = tmpChar + 'a' - 'A'; // Convert to lowercase
            if (ftable.get(tmpChar) != null) {
                keyMemory(ftable.get(tmpChar), press);
                return;
            }
        }
        tmpCode -= EVENT;
        if (tmpCode != KeyEvent.VK_SHIFT && tmpCode != KeyEvent.VK_CONTROL)
            LOGGER.info("Unrecognized Key code: {}", tmpCode);
    }

    public void keyPressed(KeyEvent e) {
        screen.resetAllKeys();
        keyTranslator(e, true);
    }

    public void keyReleased(KeyEvent e) {
        keyTranslator(e, false);
    }

}
