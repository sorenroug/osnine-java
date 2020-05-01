package org.roug.osnine.genericos9;

import java.io.IOException;

/**
 * Any type of user interface that can receive a character from
 * the CPU and display it.
 * The device can be a printer, text screen, card punch etc.
 */
public interface UIDevice {

    /**
     * Send a byte to the user interface.
     *
     * @param val - the byte to send to the device.
     * @throws IOException is the device is unable to accept the byte.
     */
    void sendToUI(int val) throws IOException;

}
