package org.roug.osnine;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class GO51TerminalTest {

    /**
     * Send plain text.
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
     */
    @Test
    public void reverseOn() throws IOException {
        GO51Terminal term = GO51Terminal.NORMAL;
        ByteArrayOutputStream res = new ByteArrayOutputStream();
        
        term = term.handleCharacter(0x1B, res);
        term = term.handleCharacter(0x46, res);
        assertEquals("\033[7m", res.toString());
    }


}

