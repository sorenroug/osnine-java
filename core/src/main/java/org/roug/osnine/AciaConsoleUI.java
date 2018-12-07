package org.roug.osnine;

import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Console User Interface for Acia chips.
 */
public class AciaConsoleUI implements Runnable {

    private static final Logger LOGGER =
            LoggerFactory.getLogger(AciaConsoleUI.class);

    private Acia acia;

    /**
     * Constructor.
     *
     * @param acia - The ACIA the user interface talks to
     */
    public AciaConsoleUI(Acia acia) {
        this.acia = acia;
    }

    public void run() {
        LOGGER.debug("AciaConsoleUI thread started");
        try {
            acia.setDCD(true);
            Thread writer = new Thread(new ConsoleWriter(), "con-out");
            writer.start();
            try {
                while (true) {
                    int receiveData = read();
                    if (Thread.interrupted())
                        throw new InterruptedException();
                    LOGGER.debug("Received {}", receiveData);
                    if (receiveData == -1) {  // EOF typed on console
                        System.exit(0);
                    }
                    if (receiveData == 10) {
                        eolReceived();
                    } else {
                        dataReceived(receiveData);
                    }
                }
            } catch (InterruptedException e) {
                LOGGER.error("InterruptException", e);
            } catch (Exception e) {
                LOGGER.error("Exception", e);
            }
            writer.interrupt();
            acia.setDCD(false);
        } catch (Exception e) {
            LOGGER.error("Console exception");
            System.exit(2);
        }
    }

    int read() throws IOException {
        return System.in.read();
    }

    void sendToConsole(int val) throws IOException {
        System.out.write(val);
        System.out.flush();
    }

    /**
     * Send the received data to the ACIA.
     */
    void dataReceived(int val) {
        acia.dataReceived(val);
    }

    void eolReceived() {
        acia.eolReceived();
    }

    /**
     * Send from ACIA out.
     */
    int waitForValueToTransmit() throws InterruptedException {
        return acia.waitForValueToTransmit();
    }



    /**
     * Thread to write to socket.
     * If it gets a write exception, then it shall tell the reader
     * to stop and it shall end the thread.
     * If it gets an InterruptedException then it shall just stop.
     */
    private class ConsoleWriter implements Runnable {

        /**
         * Wait for a value from the Acia to transmit to the console.
         */
        public void run() {
            LOGGER.debug("Writer thread started");
            try {
                while (true) {
                    int val = waitForValueToTransmit();
                    sendToConsole(val);
                    if (Thread.interrupted())
                        throw new InterruptedException();
                }
            } catch (InterruptedException e) {
                LOGGER.error("InterruptException");
            } catch (Exception e) {
                LOGGER.error("Broken connection", e);
            }
        }
    }

}
