package org.roug.osnine;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;

public class AciaTelnetUITest {

    private static final int WILL = 251;
    private static final int WONT = 252;
    private static final int DO = 253;
    private static final int DONT = 254;
    private static final int IAC = 255;

    private class AciaTelnetUIMock extends AciaTelnetUI {

        private int[] stateBuf = new int[50];  // Enough to handle all tests.
        private int bufInx;

        AciaTelnetUIMock() {
            super(null);
            reset();
        }

        /**
         * Reset the buffer to empty.
         */
        void reset() {
            for (int i = 0; i < 50; i++) {
                stateBuf[i] = 0;
            }
            bufInx = 0;
        }

        private void addCode(int val) {
            stateBuf[bufInx++] = val;
        }

        /**
         * Compare actual with expected.
         */
        boolean match(int[] expected) {
            if (bufInx != expected.length) {
                return false;
            }
            for (int i = 0; i < expected.length; i++) {

                if (stateBuf[i] != expected[i]) {
                    return false;
                }
            }
            return true;
        }

        void dataReceived(int val) {
            addCode(val);
        }

        void eolReceived() {
            addCode(13);
        }

        void pleaseDo(int val) {
            addCode(IAC);
            addCode(DO);
            addCode(val);
        }

        void pleaseDont(int val) {
            addCode(IAC);
            addCode(TelnetState.DONT_CHAR);
            addCode(val);
        }

        void wontDo(int val) {
            addCode(IAC);
            addCode(TelnetState.WONT_CHAR);
            addCode(val);
        }

        void willDo(int val) {
            addCode(IAC);
            addCode(WILL);
            addCode(val);
        }
    }


    private void checkSequence(int[] sequence, int[] expected) throws IOException {
        AciaTelnetUIMock handler = new AciaTelnetUIMock();
        TelnetState state = TelnetState.NORMAL;
        for (int i = 0; i < sequence.length; i++) {
            state = state.handleCharacter(sequence[i], handler);
        }
        assertTrue(handler.match(expected));
    }

    /**
     * Client requests suppress go-ahead.
     * Server complies.
     */
    @Test
    public void doGoAhead() throws IOException {
        int[] sequence = {IAC, DO, TelnetState.SUPPRESS_GA};
        int[] expected = {IAC, WILL, TelnetState.SUPPRESS_GA};
        checkSequence(sequence, expected);
    }


    /**
     * Client wants to talk about terminal speed.
     * Server doesn't.
     */
    @Test
    public void willTerminalSpeed() throws IOException {
        int[] sequence = {IAC, WILL, 32};
        int[] expected = {IAC, TelnetState.DONT_CHAR, 32};
        checkSequence(sequence, expected);
    }

    /**
     * Client wants to talk about environment options followed by text.
     * Server doesn't.
     */
    @Test
    public void willEnvironmentAndMore() throws IOException {
        int[] sequence = {IAC, WILL, 39, '#', '#'};
        int[] expected = {IAC, TelnetState.DONT_CHAR, 39, '#', '#'};
        checkSequence(sequence, expected);
    }

    /**
     * Client wants to echo.
     * Server does to.
     */
    @Test
    public void willEcho() throws IOException {
        int[] sequence = {IAC, WILL, 1};
        int[] expected = {IAC, DO, 1};
        checkSequence(sequence, expected);
    }

    /**
     * Client sends normal text.
     * Server passes it through.
     */
    @Test
    public void plainText() throws IOException {
        int[] sequence = {'H', 'e', 'l', 'l','o'};
        checkSequence(sequence, sequence);
    }

    /**
     * Client sends CR + 0.
     * Server passes it through.
     */
    @Test
    public void crNull() throws IOException {
        int[] sequence = {13, 0 };
        int[] expected = {13};
        checkSequence(sequence, expected);
    }

}

