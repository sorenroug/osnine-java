package org.roug.osnine.genericos9;

import java.util.List;
import javax.swing.SwingWorker;

import org.roug.usim.Acia;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Listen to ACIA and send the character to the User Interface.
 *
 */
public class AciaToScreen extends SwingWorker<Integer, Integer> {

    private static final Logger LOGGER =
            LoggerFactory.getLogger(AciaToScreen.class);

    private Acia acia;
    private UIDevice uiDevice;

    /**
     * Constructor.
     *
     * @param acia - The ACIA the user interface talks to
     */
    public AciaToScreen(Acia acia, UIDevice uiDevice) {
        this.acia = acia;
        this.uiDevice = uiDevice;
    }

    @Override
    public Integer doInBackground() {
        acia.setDCD(true);
        try {
            while (!isCancelled()) {
                int val = acia.waitForValueToTransmit();
                publish(val);
            }
        } catch (InterruptedException e) {
            LOGGER.error("InterruptException");
        }
        acia.setDCD(false);
        return 0; // Unused
    }

    @Override
    protected void process(List<Integer> chunks) {
        try {
            for (int val : chunks) {
                uiDevice.sendToUI(val);
            }
        } catch (Exception e) {
            LOGGER.error("GUI exception", e);
        }
    }
}

