package org.roug.osnine;

import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Emulate the 6551 with output going to TCP port 2323.
 * The Dragon 64 and Dragon Alpha have a hardware serial port driven
 * by a Rockwell 6551, mapped from $FF04-$FF07.
 */
public class Acia6551Telnet extends Acia6551 {

    /**
     * Constructor.
     */
    public Acia6551Telnet(int start, Bus8Motorola bus) {
        super(start, bus);
        Thread reader = new Thread(new AciaTelnetUI(this), "telnet");
        reader.setDaemon(true);
        reader.start();
    }

}
