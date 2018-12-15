package org.roug.osnine;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class GO51TerminalTest {

    /**
     * Send plain text.
     *
     * @throws IOException if there is a failure in the output stream
     */
    @Test
    public void plainText() throws IOException {
        GO51Terminal term = GO51Terminal.NORMAL;
        ByteArrayOutputStream res = new ByteArrayOutputStream();
        
        term = term.handleCharacter('A', res);
        term = term.handleCharacter('B', res);
        assertEquals("AB", res.toString());
    }


    /**
     * Underline on.
     *
     * @throws IOException if there is a failure in the output stream
     */
    @Test
    public void underlineOn() throws IOException {
        GO51Terminal term = GO51Terminal.NORMAL;
        ByteArrayOutputStream res = new ByteArrayOutputStream();
        
        term = term.handleCharacter(0x1B, res);
        term = term.handleCharacter(0x48, res);
        assertEquals("\033[4m", res.toString());
    }


    /**
     * Reverse on.
     *
     * @throws IOException if there is a failure in the output stream
     */
    @Test
    public void reverseOn() throws IOException {
        GO51Terminal term = GO51Terminal.NORMAL;
        ByteArrayOutputStream res = new ByteArrayOutputStream();
        
        term = term.handleCharacter(0x1B, res);
        term = term.handleCharacter(0x46, res);
        assertEquals("\033[7m", res.toString());
    }


    /**
     * Go to location 0,0.
     *
     * @throws IOException if there is a failure in the output stream
     */
    @Test
    public void goHome() throws IOException {
        GO51Terminal term = GO51Terminal.NORMAL;
        ByteArrayOutputStream res = new ByteArrayOutputStream();
        
        term = term.handleCharacter(0x1B, res);
        term = term.handleCharacter(0x41, res);
        term = term.handleCharacter(0x00, res);
        term = term.handleCharacter(0x00, res);
        assertEquals("\033[1;1H", res.toString());
    }

    /**
     * Go to location 40,20.
     *
     * @throws IOException if there is a failure in the output stream
     */
    @Test
    public void goX40Y20() throws IOException {
        GO51Terminal term = GO51Terminal.NORMAL;
        ByteArrayOutputStream res = new ByteArrayOutputStream();
        
        term = term.handleCharacter(0x1B, res);
        term = term.handleCharacter(0x41, res);
        term = term.handleCharacter(40, res);
        term = term.handleCharacter(20, res);
        assertEquals("\033[21;41H", res.toString());
    }

    /**
     * Go to location 33,22.
     *
     * @throws IOException if there is a failure in the output stream
     */
    @Test
    public void goX33Y22() throws IOException {
        GO51Terminal term = GO51Terminal.NORMAL;
        ByteArrayOutputStream res = new ByteArrayOutputStream();
        
        term = term.handleCharacter(0x1B, res);
        term = term.handleCharacter(0x41, res);
        term = term.handleCharacter(33, res);
        term = term.handleCharacter(22, res);
        assertEquals("\033[23;34H", res.toString());
    }


    /**
     * Go to location 9,9.
     *
     * @throws IOException if there is a failure in the output stream
     */
    @Test
    public void goX9Y9() throws IOException {
        GO51Terminal term = GO51Terminal.NORMAL;
        ByteArrayOutputStream res = new ByteArrayOutputStream();
        
        term = term.handleCharacter(0x1B, res);
        term = term.handleCharacter(0x41, res);
        term = term.handleCharacter(9, res);
        term = term.handleCharacter(9, res);
        assertEquals("\033[10;10H", res.toString());
    }

}
