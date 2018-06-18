package org.roug.osnine;

import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.ServerSocket;
import java.net.Socket;
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

    /**
     * Constructor.
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

                writer = new Thread(new LineWriter(this), "acia-out");
                writer.start();
                listeners = 2;
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
        clientOut.write(val);
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
}

/**
 * State engine to handle telnet protocol.
 */
enum TelnetState {

    NORMAL {
        @Override
        TelnetState handleCharacter(int receiveData, AciaTelnetUI handler)
                throws IOException {
            switch (receiveData) {
                case NULL_CHAR:
                case NEWLINE_CHAR:
                    return NORMAL; // Swallow newlines
                case IAC_CHAR:
                    return IAC;
                case DEL_CHAR:
                    handler.dataReceived(8);
                    return NORMAL;
                case CR_CHAR:
                    handler.eolReceived();
                    return NORMAL;
                default:
                    handler.dataReceived(receiveData);
                    return NORMAL;
            }
        }
    },

    IAC {
        @Override
        TelnetState handleCharacter(int receiveData, AciaTelnetUI handler)
                throws IOException {
            switch (receiveData) {
                case IP_CHAR:  // Interrupt process
                    handler.dataReceived(INTR_CHAR);
                    return NORMAL;
                case DO_CHAR:
                    return DO;
                case DONT_CHAR:
                    return DONT;
                case WILL_CHAR:
                    return WILL;
                case WONT_CHAR:
                    return WONT;
                default:
                    return NORMAL;
            }
        }
    },

    /**
     * Client sends will.
     */
    WILL {
        @Override
        TelnetState handleCharacter(int receiveData, AciaTelnetUI handler)
                throws IOException {
            switch (receiveData) {
                case ECHO:
                    handler.pleaseDo(receiveData);
                    return NORMAL;
                default:        // Must respond to unsupported option
                    LOGGER.debug("Don't do: {}", receiveData);
                    handler.pleaseDont(receiveData);
                    return NORMAL;
            }
        }
    },

    /**
     * Client sends won't.
     */
    WONT {
        @Override
        TelnetState handleCharacter(int receiveData, AciaTelnetUI handler)
                throws IOException {
            switch (receiveData) {
                default:        // Must respond to unsupported option
                    return NORMAL;
            }
        }
    },

    DO {
        @Override
        TelnetState handleCharacter(int receiveData, AciaTelnetUI handler)
                throws IOException {
            switch (receiveData) {
                case SUPPRESS_GA:
                case ECHO:
                    handler.willDo(receiveData);
                    return NORMAL;
                default:        // Must respond to unsupported option
                    LOGGER.info("Wont do: {}", receiveData);
                    handler.wontDo(receiveData);
                    return NORMAL;
            }
        }
    },

    DONT {
        @Override
        TelnetState handleCharacter(int receiveData, AciaTelnetUI handler)
                throws IOException {
            switch (receiveData) {
                default:
                    return NORMAL;
            }
        }
    };

    private static final Logger LOGGER = 
            LoggerFactory.getLogger(TelnetState.class);

    private static final int NULL_CHAR = 0;
    private static final int INTR_CHAR = 3;
    private static final int QUIT_CHAR = 5;
    private static final int NEWLINE_CHAR = 10;
    private static final int CR_CHAR = 13;
    private static final int DEL_CHAR = 127;   // VT100 sends DEL and not BS

    static final int TRANSMIT_BINARY = 0;
    static final int ECHO = 1;
    static final int SUPPRESS_GA = 3;  // Suppress Go ahead
    static final int TIMING = 6;  // Telnet option Timing mark

    static final int NOP_CHAR = 241;  // No operation
    static final int IP_CHAR = 244;   // Interrupt Process
    static final int WILL_CHAR = 251;
    static final int WONT_CHAR = 252;
    static final int DO_CHAR = 253;
    static final int DONT_CHAR = 254;
    static final int IAC_CHAR = 255;  // Interpret as Command

    abstract TelnetState handleCharacter(int receiveData, AciaTelnetUI handler)
            throws IOException;
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
}

/**
 * Thread to write to socket.
 * If it gets a write exception, then it shall tell the reader
 * to stop and it shall end the thread.
 * If it gets an InterruptedException then it shall just stop.
 */
class LineWriter implements Runnable {

    private static final Logger LOGGER =
            LoggerFactory.getLogger(LineWriter.class);

    private AciaTelnetUI handler;

    /**
     * Constructor.
     */
    LineWriter(AciaTelnetUI handler) {
        this.handler = handler;
    }

    /**
     * Wait for a value from the Acia to transmit to the client terminal.
     * Send it, if exception, assume the connection is broken and exit.
     */
    public void run() {
        LOGGER.debug("Writer thread started");
        try {
            handler.willDo(TelnetState.SUPPRESS_GA);
            handler.willDo(TelnetState.ECHO);
            while (true) {
                int val = handler.waitForValueToTransmit();
                handler.sendTelnetClient(val);
                if (Thread.interrupted())
                    throw new InterruptedException();
            }
        } catch (InterruptedException e) {
            LOGGER.error("InterruptException");
            handler.endSession();
        } catch (Exception e) {
            LOGGER.error("Broken connection", e);
            handler.interruptReader();
        }
    }
}

