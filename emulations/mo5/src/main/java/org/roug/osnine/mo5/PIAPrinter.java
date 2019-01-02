package org.roug.osnine.mo5;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import static java.nio.charset.StandardCharsets.US_ASCII;

import org.roug.osnine.Bus8Motorola;
import org.roug.osnine.PIA6821;
import org.roug.osnine.BitReceiver;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Printer PIA in a Thomson MO5.
 * This chip is located at addresses 0xA7E0-0xA7E3.
 * It appears that A7E0/A7E2 is used for seriel (RS-232) communication and
 * A7E1/A7E3 is used for printer output.
 * Virtually no documentation available.
 *
 * <pre>Data port A $A7E0 (42976)
* PA0 (output) Receive data 
* PA1 (output) Clear to send 
* PA5 (input) Request to send 
* PA6 (input) Data terminal ready 
* PA7 (input) Transmit data 
 *
 * Data port B $A7E1 (42977)
* PB0-7 (output) Parallel data
 *
 * Control port A $A7E2 (42978)
 *  CA1: (input) Request to send
 *  CA2:
 * Control port B $A7E3 (42979)
 *  CB1: (input) Acknowledge
 *  CB2: (output) Strobe</pre>
 * The computer expects the printer to understand certain command bytes.
 * I have been unable to get a manual for Seikosha GP-80 and made some guesses:
 * $FF - Reset to text mode
 * $07 - Used by SCREENPRINT. Coming next are 8000 bytes of screen dump and can
 * contain $FF and $07 etc. We make a PBM image out of it.
 * $F5 - Continuation of text mode
 */
public class PIAPrinter extends PIA6821 {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(PIAPrinter.class);

    private static final int SCREEN_BYTES = 8000;

    private static final int PRINTER_SPEED = 1000; // Cycles before it reacts
    private Screen screen;

    private BitReceiver callback;

    private OutputStream printerFile;

    private boolean screenDump = false;
    private int bytesDumped;
    private boolean appendMode = false;

    /**
     * Create PIA and configure the connections to the printer.
     *
     * @param bus the memory bus to send IRQ and FIRQ signals to.
     * @param screen the interface to the keyboard
     */
    public PIAPrinter(Bus8Motorola bus, Screen screen) {
        super(0xA7E0, bus);
        this.screen = screen;
        setLayout(PRA_PRB_CRA_CRB);

        setOutputCallback(B, (int mask, int value, int oldValue)
                   -> sendToPrinter(mask, value, oldValue));
        setControlCallback(B, (boolean state) -> readyToPrint(state));

        callback = (boolean state) -> signalC1(B);
    }

    /**
     * Tell printer if it can take the value from the PIA. When the printer
     * has read the value it will send a signal to CB1.
     *
     * @param state If true, then the data is ready
     */
    private void readyToPrint(boolean state) {
        LOGGER.debug("Strobe: {}", state);
        if (state) bus.callbackIn(PRINTER_SPEED, callback);
    }

    private void openPrinter(String filename) throws IOException {
        if (printerFile != null) {
            printerFile.close();
        }
        printerFile = new FileOutputStream(filename, appendMode);
        appendMode = true;
    }

    private void sendToPrinter(int mask, int value, int oldValue) {
        LOGGER.debug("Sent to printer: {}", value);
        try {
            if (printerFile == null) {
                openPrinter("printer.txt");
            }

            if (screenDump) {
                printerFile.write(value);
                bytesDumped++;
                if (bytesDumped == 8000) screenDump = false;
            } else {
                if (value == 0xFF) {
                    openPrinter("printer.txt");
                    LOGGER.debug("Open printer");
                } else if (value == 0x07) {
                    bytesDumped = 0;
                    screenDump = true;
                    openPrinter("printer.pbm");
                    printerFile.write("P4 320 200\n".getBytes(US_ASCII));
                } else if (value == 0xF5) {
                   // Continuation of text mode. No action currently.
                } else {
                    printerFile.write(value);
                }
            }
        } catch (IOException e) {
            LOGGER.error("Unable to open printer file", e);
        }
    }
}
