package org.roug.osnine.genericos9;

import java.io.InputStream;
import java.io.IOException;
import java.util.List;
import javax.swing.SwingWorker;

import org.roug.osnine.Acia;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Listen to ACIA and send the character to the screen.
 *
 */
public class AciaToScreen extends SwingWorker<Integer, Integer> {

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

    @Override
    public Integer doInBackground() {
        LOGGER.debug("Thread started");
        acia.setDCD(true);
        try {
            while (!isCancelled()) {
                int val = acia.waitForValueToTransmit();
                publish(val);
            }
        } catch (InterruptedException e) {
            LOGGER.error("InterruptException");
//      } catch (Exception e) {
//          LOGGER.error("Broken connection", e);
        }
        acia.setDCD(false);
        return 0; // Unused
    }

    @Override
    protected void process(List<Integer> chunks) {
        try {
            for(int val : chunks) {
                screen.sendToGUI(val);
            }
        } catch (Exception e) {
            LOGGER.error("GUI exception");
        }
    }
}

