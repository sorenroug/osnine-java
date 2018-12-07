package org.roug.osnine;

import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Timer;
import java.util.TimerTask;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * A service to handle telnet connections.
 * It listens on port 2323. When a client connects, then it
 * launches two threads. One for reading and one for writing.
 * These threads then call the ACIA.
 */
public class AciaTelnetUI implements Runnable {

    private static final Logger LOGGER = 
            LoggerFactory.getLogger(AciaTelnetUI.class);

    private Acia acia;

    private OutputStream clientOut;

    private InputStream clientIn;

    private int listeners;

    private boolean[] modes = {
        false,   // Transmit binary
        false,   // Echo
        false,   // Reconnection
        false,   // Suppress GA
        false,   // Approx message size
        false,   // Status
        false,   // Timing mark
    };

    private Thread reader, writer;

    private Socket activeSocket;

    private GO51Terminal term = GO51Terminal.NORMAL;

    /**
     * Constructor.
     *
     * @param acia - The ACIA the user interface talks to
     */
    public AciaTelnetUI(Acia acia) {
        this.acia = acia;
    }

    public void run() {
        final int portNumber = 2323;
        ServerSocket serverSocket;

        LOGGER.debug("AciaTelnetUI thread started");
        try {
            serverSocket = new ServerSocket(portNumber);
        } catch (Exception e) {
            LOGGER.error("Unable to create listening socket");
            return;
        }
        synchronized(this) {
            activeSocket = null;
        }

        try {
            while (true) {
                LOGGER.info("Waiting for connection");
                Socket socket = serverSocket.accept();
                synchronized(this) {
                    if (activeSocket != null) {
                        OutputStreamWriter w = new OutputStreamWriter(socket.getOutputStream());
                        w.write("\r\nAnother session is active\r\n\r\n");
                        w.flush();
                        socket.close();
                        continue;
                    }
                    socket.setKeepAlive(true);
                    clientOut = socket.getOutputStream();
                    clientIn = socket.getInputStream();
                    activeSocket = socket;
                }
                acia.setDCD(true);
                resetModes();

                reader = new Thread(new LineReader(this), "acia-in");
                reader.start();

                term = GO51Terminal.NORMAL;
                writer = new Thread(new LineWriter(), "acia-out");
                writer.start();
                synchronized(this) {
                    listeners = 2;
                }
            }
        } catch (IOException e) {
            LOGGER.error("IOException", e);
            return;
        }
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

    int read() throws IOException {
        return clientIn.read();
    }

    void sendTelnetClient(int val) throws IOException {
        term = term.handleCharacter(val, clientOut);
        clientOut.flush();
    }

    /**
     * Send from ACIA out.
     */
    int waitForValueToTransmit() throws InterruptedException {
        return acia.waitForValueToTransmit();
    }

    void interruptReader() {
        reader.interrupt();
        endSession();
    }

    void interruptWriter() {
        writer.interrupt();
        endSession();
    }

    /**
     * If this is the last listener then close socket and end the active session.
     */
    synchronized void endSession() {
        listeners--;
        if (listeners == 0) {
            try {
                if (activeSocket != null) {
                    activeSocket.close();
                }
            } catch (IOException e) {
                LOGGER.error("IOException", e);
            }
            activeSocket = null;
            acia.setDCD(false);
        }
    }

    /**
     * Tell telnet client I won't do this option.
     */
    void pleaseDo(int val) throws IOException {
       byte[] sequence = { (byte)TelnetState.IAC_CHAR,
               (byte) TelnetState.DO_CHAR, (byte) 0 };

       sequence[2] = (byte)val;
       clientOut.write(sequence, 0, 3);
    }

    /**
     * Tell telnet client I won't do this option.
     */
    void pleaseDont(int val) throws IOException {
       byte[] sequence = { (byte)TelnetState.IAC_CHAR,
               (byte) TelnetState.DONT_CHAR, (byte) 0 };

       sequence[2] = (byte)val;
       clientOut.write(sequence, 0, 3);
    }

    /**
     * Tell telnet client I won't do this option.
     */
    void wontDo(int val) throws IOException {
       byte[] sequence = { (byte)TelnetState.IAC_CHAR,
               (byte) TelnetState.WONT_CHAR, (byte) 0 };

        if (!modeIsSet(val)) {
            sequence[2] = (byte)val;
            clientOut.write(sequence, 0, 3);
            setMode(val, true);
        }
    }

    /**
     * Tell telnet client I will do this option.
     */
    void willDo(int val) throws IOException {
       byte[] sequence = { (byte)TelnetState.IAC_CHAR,
               (byte) TelnetState.WILL_CHAR, (byte) 0 };

        if (!modeIsSet(val)) {
            sequence[2] = (byte)val;
            clientOut.write(sequence, 0, 3);
            setMode(val, true);
        }
    }

    void setMode(int option, boolean value) {
        if (option < modes.length) {
            modes[option] = value;
        }
    }

    boolean modeIsSet(int option) {
        if (option < modes.length) {
            return modes[option];
        } else {
            return false;
        }
    }

    /**
     * Reset the Telnet options to initial values.
     */
    private void resetModes() {
        for (int i = 0; i < modes.length; i++) {
            setMode(i, false);
        }
    }

    /**
     * Thread to write to socket.
     * If it gets a write exception, then it shall tell the reader
     * to stop and it shall end the thread.
     * If it gets an InterruptedException then it shall just stop.
     */
    class LineWriter implements Runnable {

        /**
         * Wait for a value from the Acia to transmit to the client terminal.
         * Send it, if exception, assume the connection is broken and exit.
         */
        public void run() {
            LOGGER.debug("Writer thread started");
            try {
                willDo(TelnetState.SUPPRESS_GA);
                willDo(TelnetState.ECHO);
                while (true) {
                    int val = waitForValueToTransmit();
                    sendTelnetClient(val);
                    if (Thread.interrupted())
                        throw new InterruptedException();
                }
            } catch (InterruptedException e) {
                LOGGER.error("InterruptException");
                endSession();
            } catch (Exception e) {
                LOGGER.error("Broken connection", e);
                interruptReader();
            }
        }
    }

}

/**
 * Thread to listen to incoming data from a telnet client.
 * If it gets a read exception, then it shall tell the writer
 * to stop and it shall end the thread.
 * If it gets an InterruptedException then it shall just stop.
 */
class LineReader implements Runnable {

    private static final Logger LOGGER = 
            LoggerFactory.getLogger(LineReader.class);

    private TelnetState state = TelnetState.NORMAL;

    private AciaTelnetUI handler;

    /** Characters read from the telnet client. */
    private volatile int charsRead;

    /**
     * Constructor.
     */
    LineReader(AciaTelnetUI handler) {
        this.handler = handler;
    }

    /**
     * Since this waits in read() we can busy loop on the rest.
     */
    public void run() {
        LOGGER.debug("Reader thread started");
        Timer timer = new Timer("escape", true);
        try {
            while (true) {
                int receiveData = handler.read();
                if (Thread.interrupted())
                    throw new InterruptedException();
                LOGGER.debug("Received {}", receiveData);
                if (receiveData == -1) {
                    LOGGER.info("Reader lost connection");
                    handler.interruptWriter();
                    break;
                }
                charsRead++;
                if (receiveData == 27) {
                    TimeoutEscape timeout = new TimeoutEscape(this, charsRead);
                    timer.schedule(timeout, 100);
                }
                state = state.handleCharacter(receiveData, handler);
            }
        } catch (InterruptedException e) {
            LOGGER.error("InterruptException", e);
            handler.endSession();
        } catch (Exception e) {
            LOGGER.error("Exception", e);
            handler.interruptWriter();
        }
    }

    void resetState(int charsReadAtStart) {
        try {
            if (charsRead == charsReadAtStart) {
                state = state.handleCharacter(0, handler);
            }
        } catch (IOException e) {
          // Do nothing
        }
    }
}

/**
 * A class to reset the escape sequences if nothing has been
 * received.
 */
class TimeoutEscape extends TimerTask {

    private int beginChars;
    private LineReader reader;


    TimeoutEscape(LineReader reader, int beginChars) {
        this.reader = reader;
        this.beginChars = beginChars;
    }

    public void run() {
        reader.resetState(beginChars);
    }
}
