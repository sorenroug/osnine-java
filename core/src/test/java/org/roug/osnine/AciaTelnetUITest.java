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

    private class AciaTelnetUIMock extends AciaTelnetUI {

        AciaTelnetUIMock() {
            super(null);
        }

        void dataReceived(int val) {
            System.err.format("Received: %d", val);
        }

        void eolReceived() {
            System.err.println("Eol received");
        }
    }


    /**
     * Add Accumulator B into index register X.
     * The ABX instruction was included in the 6809 instruction set for
     * compatibility with the 6801 microprocessor.
     */
    @Test
    public void testStat() throws IOException {
        AciaTelnetUI handler = new AciaTelnetUIMock();
        TelnetState state = TelnetState.NORMAL;
    }


}
