package org.roug.osnine.mo5;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import org.roug.osnine.Bus8Motorola;
import org.roug.osnine.PIA6821;
import org.roug.osnine.BitReceiver;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Printer PIA in a Thomson MO5.
 * This chip is located at addresses 0xA7E0-0xA7E3.
 * It appears that A7E0/A7E2 is used for seriel (rs-232) communication
 * A7E1/A7E3 is used fo prnter output.
 * Virtually no documentation available.
 *
 * data port A (A7E0)
* PA0 (output) Receive data 
* PA1 (output) Clear to send 
* PA5 (input) Request to send 
* PA6 (input) Data terminal ready 
* PA7 (input) Transmit data 
 *
 * data port B A7E1 (42977)
* PB0-7 (output) Parallel data
 *
 * Control port A A7E2 (42978)
 *  CA1: (input) Request to send
 *  CA2:
 * Control port B  A7E3 (42979)
 *  CB1: (input) Acknowledge
 *  CB2: (output) Strobe
 */
public class PIAPrinter extends PIA6821 {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(PIAPrinter.class);

    private Screen screen;

    private BitReceiver callback;

    private OutputStream printerFile;

    /**
     * Create PIA and configure the connections to the printer.
     *
     * @param bus the memory bus to send IRQ and FIRQ signals to.
     * @param screen the interface to the keyboard
     */
    public PIAPrinter(Bus8Motorola bus, Screen screen) {
        super(0xA7E0, bus);
        this.screen = screen;
        setLayout(1);

        setOutputCallback(B, (int mask, int value, int oldValue)
                   -> logCBB(mask, value, oldValue));
        setControlCallback(B, (boolean state) -> logControlB(state));

        callback = (boolean state) -> signalC1(B);
    }

    private void logControlB(boolean state) {
        LOGGER.debug("Control B called: {}", state);
        if (state) bus.callbackIn(500, callback);
    }

    private void logCBB(int mask, int value, int oldValue) {
        LOGGER.debug("Callback: Side B mask:{} value:{} old:{}", mask, value, oldValue);
        try {
            if (printerFile == null) {
                printerFile = new FileOutputStream("printer.out");
            }
            if (value < 128)
                printerFile.write(value);
        } catch (IOException e) {
            LOGGER.error("Unable to open printer file", e);
        }
        bus.callbackIn(500, callback);
    }
}
