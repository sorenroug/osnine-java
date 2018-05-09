package org.roug.osnine;

import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Motorola 6850 Asynchronous Communications Interface Adapter (ACIA).
 * It includes a universal asynchronous receiver-transmitter (UART).
 * The essential function of the ACIA is serial-to-parallel and
 * parallel-to-serial conversion.
 *
 * At the bus interface, the ACIA appears as two addressable memory locations.
 */
public class Acia6850Console extends Acia6850 {

    /**
     * Constructor.
     * The ACIA appears as two addressable memory locations.
     * The data register is addressed when register select is high.
     * Status/Control register is addressed when the register select is low.
     */
    public Acia6850Console(int start, Bus8Motorola bus) {
        super(start, bus);
        Thread reader = new Thread(new AciaConsoleUI(this), "acia6850");
        reader.setDaemon(true);
        reader.start();
    }

}
