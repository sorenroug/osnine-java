package org.roug.osnine.genericos9;

import java.io.InputStream;
import java.io.IOException;

import org.roug.osnine.Acia;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Listen to ACIA and send the character to the screen.
 *
 */
public class AciaToScreen implements Runnable {

    private static final Logger LOGGER =
            LoggerFactory.getLogger(AciaToScreen.class);

    private Acia acia;
    private Screen screen;

    /**
     * Constructor.
     *
     * @param acia - The ACIA the user interface talks to
     */
    public AciaToScreen(Acia acia, Screen screen) {
        this.acia = acia;
        this.screen = screen;
    }

    public void run() {
        LOGGER.debug("Thread started");
        try {
            acia.setDCD(true);
            try {
                while (true) {
                    int val = acia.waitForValueToTransmit();
                    screen.sendToGUI(val);
                    if (Thread.interrupted())
                        throw new InterruptedException();
                }
            } catch (InterruptedException e) {
                LOGGER.error("InterruptException");
            } catch (Exception e) {
                LOGGER.error("Broken connection", e);
            }
            acia.setDCD(false);
        } catch (Exception e) {
            LOGGER.error("GUI exception");
        }
        System.exit(2);
    }

}

