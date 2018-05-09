package org.roug.osnine;

import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Emulate the 6551 with output going to the console.
 */
public class Acia6551Console extends Acia6551 {

    /**
     * Constructor.
     */
    public Acia6551Console(int start, Bus8Motorola bus) {
        super(start, bus);
        setDCD(false);  // There is no carrier
        Thread reader = new Thread(new AciaConsoleUI(this), "acia6551");
        reader.setDaemon(true);
        reader.start();
    }

}
