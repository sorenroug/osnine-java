package org.roug.osnine.mo5;

import java.awt.event.KeyListener;
import java.awt.event.KeyEvent;
import java.util.HashMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Keyboard listener.
 * This class interfaces to the GUI and tells the PIA what keys are pressed.
 */
public class Keyboard implements KeyListener {

    private static final Logger LOGGER = LoggerFactory.getLogger(Keyboard.class);

    /** Interface to the 6821 PIA. */
    private PIA6821MO5 pia;

    // translation table from scancode to java keycodes VK_
    private HashMap<Integer, Integer> ftable;

    final public int EVENT = 0x8000;

    /**
     * Constructor.
     */
    public Keyboard(PIA6821MO5 pia) {
        this.pia = pia;
        int i;

        ftable = new HashMap(100);

        /* STOP */
        //ftable[0x6E]=0x29;
        /* 1 .. ACC */
        ftable.put(Integer.valueOf('1'), 0x5E);
        ftable.put(Integer.valueOf('2'), 0x4E);
        ftable.put(Integer.valueOf('3'), 0x3E);
        ftable.put(Integer.valueOf('4'), 0x2E);
        ftable.put(Integer.valueOf('5'), 0x1E);
        ftable.put(Integer.valueOf('6'), 0x0E);
        ftable.put(Integer.valueOf('7'), 0x0C);
        ftable.put(Integer.valueOf('8'), 0x1C);
        ftable.put(Integer.valueOf('9'), 0x2C);
        ftable.put(Integer.valueOf('0'), 0x3C);
        ftable.put(Integer.valueOf('-'), 0x4C);
        ftable.put(Integer.valueOf('+'), 0x5C);
        //ftable.put(KeyEvent.VK_BACK_SPACE + EVENT, 0x6C);
        ftable.put(KeyEvent.VK_BACK_SPACE + EVENT, 0x52); // Plain backspace
        /* A .. --> */
        ftable.put(Integer.valueOf('a'), 0x5A);
        ftable.put(Integer.valueOf('z'), 0x4A);
        ftable.put(Integer.valueOf('e'), 0x3A);
        ftable.put(Integer.valueOf('r'), 0x2A);
        ftable.put(Integer.valueOf('t'), 0x1A);
        ftable.put(Integer.valueOf('y'), 0x0A);
        ftable.put(Integer.valueOf('u'), 0x08);
        ftable.put(Integer.valueOf('i'), 0x18);
        ftable.put(Integer.valueOf('o'), 0x28);
        ftable.put(Integer.valueOf('p'), 0x38);
        ftable.put(Integer.valueOf('/'), 0x48);
        ftable.put(Integer.valueOf(')'), 0x58);
        /* Q .. enter */
        ftable.put(Integer.valueOf('q'), 0x56);
        ftable.put(Integer.valueOf('s'), 0x46);
        ftable.put(Integer.valueOf('d'), 0x36);
        ftable.put(Integer.valueOf('f'), 0x26);
        ftable.put(Integer.valueOf('g'), 0x16);
        ftable.put(Integer.valueOf('h'), 0x06);
        ftable.put(Integer.valueOf('j'), 0x04);
        ftable.put(Integer.valueOf('k'), 0x14);
        ftable.put(Integer.valueOf('l'), 0x24);
        ftable.put(Integer.valueOf('m'), 0x34);
        ftable.put(KeyEvent.VK_ENTER + EVENT, 0x68);
        /* W .. , */
        ftable.put(Integer.valueOf('w'), 0x60);
        ftable.put(Integer.valueOf('x'), 0x50);
        ftable.put(Integer.valueOf('c'), 0x64);
        ftable.put(Integer.valueOf('v'), 0x54);
        ftable.put(Integer.valueOf('b'), 0x44);
        ftable.put(Integer.valueOf('n'), 0x00);
        ftable.put(Integer.valueOf(','), 0x10);

        ftable.put(Integer.valueOf('.'), 0x20);
        ftable.put(Integer.valueOf('@'), 0x30);
        ftable.put(145 + EVENT, 0x6E); //STOP
        ftable.put(Integer.valueOf('*'), 0x58);

        /* Specials keys */
        ftable.put(KeyEvent.VK_INSERT + EVENT, 0x12);
        ftable.put(KeyEvent.VK_DELETE + EVENT, 0x02);
        ftable.put(36 + EVENT, 0x22);// Back to top
        ftable.put(KeyEvent.VK_UP + EVENT, 0x62);
        ftable.put(KeyEvent.VK_LEFT + EVENT, 0x52);
        ftable.put(KeyEvent.VK_RIGHT + EVENT, 0x32);
        ftable.put(KeyEvent.VK_DOWN + EVENT, 0x42);
        /* space */
        ftable.put(Integer.valueOf(' '), 0x40);
        /* SHIFT + BASIC */
        ftable.put(KeyEvent.VK_F12 + EVENT, 0x70);//Shift
        ftable.put(KeyEvent.VK_F11 + EVENT, 0x72);//Basic

        /* CNT RAZ */
        ftable.put(17 + EVENT, 0x6A);//CTRL
        ftable.put(27 + EVENT, 0x66);//ESCAPE = raz
    }

    public void keyTyped(KeyEvent e) {
    }

    private void keyMemory(int key, boolean press) {
        pia.setKey(key, press);
    }

    private void keyTranslator(KeyEvent e, boolean press) {
        int tmpChar = e.getKeyChar();
        int tmpCode = e.getKeyCode() + EVENT;

        LOGGER.debug("Key event {}", tmpCode);

        switch(tmpChar) {
            case '!':
                keyMemory(0x70, press);//Shift
                keyMemory(0x5E, press);//1
                return;
            case '"':
                keyMemory(0x70, press);//Shift
                keyMemory(0x4E, press);//2
                return;
            case '#':
                keyMemory(0x70, press);//Shift
                keyMemory(0x3E, press);//3
                return;
            case '$':
                keyMemory(0x70, press);//Shift
                keyMemory(0x2E, press);//4
                return;
            case '%':
                keyMemory(0x70, press);//Shift
                keyMemory(0x1E, press);//5
                return;
            case '&':
                keyMemory(0x70, press);//Shift
                keyMemory(0x0E, press);//6
                return;
            case 39://'
                keyMemory(0x70, press);//Shift
                keyMemory(0x0C, press);//7
                return;
            case '(':
                keyMemory(0x70, press);//Shift
                keyMemory(0x1C, press);//8
                return;
            case ')':
                keyMemory(0x70, press);//Shift
                keyMemory(0x2C, press);//9
                return;
            case '=':
                keyMemory(0x70, press);//Shift
                keyMemory(0x4C, press);//-
                return;
            case ';':
                keyMemory(0x70, press);//Shift
                keyMemory(0x5C, press);//+
                return;
            case '?':
                keyMemory(0x70, press);//Shift
                keyMemory(0x48, press);// /
                return;
            case ':':
                keyMemory(0x70, press);//Shift
                keyMemory(0x58, press);//*
                return;
            case '<':
                keyMemory(0x70, press);//Shift
                keyMemory(0x10, press);//,
                return;
            case '>':
                keyMemory(0x70, press);//Shift
                keyMemory(0x20, press);//.
                return;
            case '^':
                keyMemory(0x70, press);//Shift
                keyMemory(0x30, press);//@
                return;
            case '©':
                keyMemory(0x6A, press);//Ctrl
                keyMemory(0x64, press);//C
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
        if (tmpCode != KeyEvent.VK_SHIFT + EVENT && tmpCode != KeyEvent.VK_CONTROL + EVENT)
            LOGGER.info("Unrecognized Key code: {}", tmpCode);
    }

    public void keyPressed(KeyEvent e) {
        for (int i = 0; i < PIA6821MO5.KEYS; i++)
            pia.setKey(i, false);
        keyTranslator(e, true);
    }

    public void keyReleased(KeyEvent e) {
        keyTranslator(e, false);
    }

}
