package org.roug.osnine;

import java.io.InputStream;
import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Thread to listen to incoming data.
 */
class ConsoleHandler implements Runnable {

    private static final Logger LOGGER =
            LoggerFactory.getLogger(ConsoleHandler.class);

    private Acia acia;

    /**
     * Constructor.
     */
    ConsoleHandler(Acia acia) {
        this.acia = acia;
    }

    public void run() {
        LOGGER.debug("ConsoleHandler thread started");
        try {
            acia.setDCD(true);
            Thread reader = new Thread(new ConsoleReader(this), "con-in");
            reader.start();
            Thread writer = new Thread(new ConsoleWriter(this), "con-out");
            writer.start();
            reader.join();
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


}

/**
 * Thread to listen to incoming data from stdin.
 * If it gets a read exception, then it shall tell the writer
 * to stop and it shall end the thread.
 */
class ConsoleReader implements Runnable {

    private static final Logger LOGGER =
            LoggerFactory.getLogger(ConsoleReader.class);

    private ConsoleHandler handler;

    /**
     * Constructor.
     */
    ConsoleReader(ConsoleHandler handler) {
        this.handler = handler;
    }

    /**
     * Since this waits in read() we can busy loop on the rest.
     */
    public void run() {
        LOGGER.debug("Reader thread started");
        try {
            while (true) {
                int receiveData = handler.read();
                if (Thread.interrupted())
                    throw new InterruptedException();
                LOGGER.debug("Received {}", receiveData);
                if (receiveData == -1) {  // EOF typed on console
                    System.exit(0);
                }
                if (receiveData == 10) {
                    handler.eolReceived();
                } else {
                    handler.dataReceived(receiveData);
                }
            }
        } catch (InterruptedException e) {
            LOGGER.error("InterruptException", e);
        } catch (Exception e) {
            LOGGER.error("Exception", e);
        }
    }
}

/**
 * Thread to write to socket.
 * If it gets a write exception, then it shall tell the reader
 * to stop and it shall end the thread.
 * If it gets an InterruptedException then it shall just stop.
 */
class ConsoleWriter implements Runnable {

    private static final Logger LOGGER =
            LoggerFactory.getLogger(ConsoleWriter.class);

    private ConsoleHandler handler;

    /**
     * Constructor.
     */
    ConsoleWriter(ConsoleHandler handler) {
        this.handler = handler;
    }

    /**
     * Wait for a value from the Acia to transmit to the console.
     */
    public void run() {
        LOGGER.debug("Writer thread started");
        try {
            while (true) {
                int val = handler.waitForValueToTransmit();
                handler.sendToConsole(val);
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

