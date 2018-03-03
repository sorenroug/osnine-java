package org.roug.osnine;

import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

class Acceptor implements Runnable {

    private static final Logger LOGGER = 
            LoggerFactory.getLogger(Acceptor.class);

    private Acia6551Telnet acia;

    private OutputStream clientOut;

    private InputStream clientIn;

    private boolean[] modes = {
        false,   // Transmit binary
        false,   // Echo
        false,   // Reconnection
        false,   // Suppress GA
        false,   // Approx message size
        false,   // Status
        false,   // Timing mark
    };

    /**
     * Constructor.
     */
    Acceptor(Acia6551Telnet acia) {
        this.acia = acia;
    }

    public void run() {
        final int portNumber = 2323;
        ServerSocket serverSocket;

        LOGGER.debug("Acceptor thread started");
        try {
            serverSocket = new ServerSocket(portNumber);
        } catch (Exception e) {
            LOGGER.error("Unable to create listening socket");
            return;
        }

        try {
            while (true) {
                Socket socket = serverSocket.accept();
                clientOut = socket.getOutputStream();
                clientIn = socket.getInputStream();
                acia.setDCD(true);

                Thread reader = new Thread(new LineReader(this), "acia-in");
                reader.start();

                Thread writer = new Thread(new LineWriter(this), "acia-out");
                writer.start();

                writer.join();
                socket.close();
                clientIn.close();
                clientOut.close();
                acia.setDCD(false);
            }
        } catch (InterruptedException e) {
            LOGGER.error("InterruptException", e);
        } catch (IOException e) {
            LOGGER.error("IOException", e);
            return;
        }
    }

    void dataReceived(int val) {
        acia.dataReceived(val);
    }

    int read() throws IOException {
        return clientIn.read();
    }

    void sendTelnetClient(int val) throws IOException {
        clientOut.write(val);
    }

    /**
     * Send from ACIA out.
     */
    int valueToTransmit() {
        return acia.valueToTransmit();
    }

    void flush() throws IOException {
        clientOut.flush();
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
}

/**
 * State engine to handle telnet protocol.
 */
enum TelnetState {

    NORMAL {
        @Override
        TelnetState handleCharacter(int receiveData, Acceptor handler)
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
                default:
                    handler.dataReceived(receiveData);
                    return NORMAL;
            }
        }
    },

    IAC {
        @Override
        TelnetState handleCharacter(int receiveData, Acceptor handler)
                throws IOException {
            switch (receiveData) {
                case IP_CHAR:
                    handler.dataReceived(INTR_CHAR);
                    return NORMAL;
                case DO_CHAR:
                    return DO;
                case DONT_CHAR:
                    return DONT;
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
        TelnetState handleCharacter(int receiveData, Acceptor handler)
                throws IOException {
            switch (receiveData) {
                case ECHO:
                    handler.pleaseDo(receiveData);
                    return NORMAL;
                default:        // Must respond to unsupported option
                    handler.pleaseDont(receiveData);
                    return NORMAL;
            }
        }
    },

    WONT {
        @Override
        TelnetState handleCharacter(int receiveData, Acceptor handler)
                throws IOException {
            switch (receiveData) {
                default:        // Must respond to unsupported option
                    return NORMAL;
            }
        }
    },

    DO {
        @Override
        TelnetState handleCharacter(int receiveData, Acceptor handler)
                throws IOException {
            switch (receiveData) {
                case SUPPRESS_GA:
                case ECHO:
                    handler.willDo(receiveData);
                    return NORMAL;
                default:        // Must respond to unsupported option
                    handler.wontDo(receiveData);
                    return NORMAL;
            }
        }
    },

    DONT {
        @Override
        TelnetState handleCharacter(int receiveData, Acceptor handler)
                throws IOException {
            switch (receiveData) {
                default:
                    return NORMAL;
            }
        }
    };

    private static final int NULL_CHAR = 0;
    private static final int INTR_CHAR = 3;
    private static final int QUIT_CHAR = 5;
    private static final int NEWLINE_CHAR = 10;
    private static final int DEL_CHAR = 127;   // VT100 send DEL and not BS

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

    abstract TelnetState handleCharacter(int receiveData, Acceptor handler)
            throws IOException;
}

/**
 * Thread to listen to incoming data.
 */
class LineReader implements Runnable {

    private static final Logger LOGGER = 
            LoggerFactory.getLogger(LineReader.class);

    private TelnetState state = TelnetState.NORMAL;

    private Acceptor handler;

    /**
     * Constructor.
     */
    LineReader(Acceptor handler) throws IOException {
        this.handler = handler;
    }

    /**
     * Since this waits in read() we can busy loop on the rest.
     */
    public void run() {
        LOGGER.debug("Reader thread started");
        while (true) {
            try {
                int receiveData = handler.read();
                LOGGER.debug("Received {}", receiveData);
                state = state.handleCharacter(receiveData, handler);
            } catch (Exception e) {
                LOGGER.error("Exception", e);
                return;
            }
        }
    }
}

/**
 * Thread to write to socket.
 */
class LineWriter implements Runnable {

    private static final Logger LOGGER =
            LoggerFactory.getLogger(LineWriter.class);

    private Acceptor handler;

    /**
     * Constructor.
     */
    LineWriter(Acceptor handler) throws IOException {
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
                int val = handler.valueToTransmit();
                handler.sendTelnetClient(val);
                handler.flush();
            }
        } catch (Exception e) {
            LOGGER.error("Broken connection", e);
            return;
        }
    }
}

/**
 * Emulate the 6551 with output going to TCP port 2323.
 * The Dragon 64 and Dragon Alpha have a hardware serial port driven
 * by a Rockwell 6551, mapped from $FF04-$FF07.
 */
public class Acia6551Telnet extends MemorySegment {

    private static final Logger LOGGER =
            LoggerFactory.getLogger(Acia6551Telnet.class);

    /** Register selection flags. One per mapped address. */
    private static final int DATA_REG = 0;
    private static final int STAT_REG = 1;
    private static final int CMND_REG = 2;
    private static final int CTRL_REG = 3;

    /** Receiver Interrupt Request Disabled. */
    private static final int IRD = 2;
    /** Transmitter Interrupt Control. */
    private static final int TIC0 = 4;
    private static final int TIC1 = 8;

    /** Parity Error. */
    private static final int CR0 = 1;    // %00000001   PE
    /** Framing Error. */
    private static final int CR1 = 2;
    /** Overrun. */
    private static final int CR2 = 4;    // %00000100

    /** Receive Data Register Full. */
    private static final int RDRF = 8;    // %00001000

    /** Transmit Data Register Empty. */
    private static final int TDRE = 16;   // %00010000

    /** Data Carrier Detect. */
    private static final int DCD = 32;   // %00100000
    /** Data Set Ready. */
    private static final int CR6 = 64;   // %01000000
    /** Receive Interupt Enable. */
    private static final int CR7 = 128;  // %10000000

    /** Interupt Request. */
    private static final int IRQ = 128;

    private int transmitData;
    private int receiveData;
    private int controlRegister;
    private int commandRegister;

    boolean receiveIrqEnabled = false;
    boolean transmitIrqEnabled = false;

    private int statusReg = TDRE;

    /** Reference to CPU for the purpose of sending IRQ. */
    private Bus6809 cpu;

    /**
     * Constructor.
     */
    public Acia6551Telnet(int start, Bus6809 cpu) {
        super(start, start + 3);
        this.cpu = cpu;
        setDCD(false);
        Thread reader = new Thread(new Acceptor(this), "telnet");
        reader.setDaemon(true);
        reader.start();
    }

    void setDCD(boolean detected) {
        int oldStatus = statusReg;
        if (detected) {
            statusReg &= ~DCD;
        } else {
            statusReg |= DCD;
        }
        if (oldStatus != statusReg) {
            signalCPU();
        }
    }

    private void signalCPU() {
        if (receiveIrqEnabled) {
            statusReg |= IRQ;
            cpu.signalIRQ(true);
        }
    }

    /**
     * Get DCD status. Inverted in register.
     */
    boolean getDCD() {
        return (statusReg & DCD) == 0;
    }

    /**
     * Is Receive register full?
     */
    boolean isReceiveRegisterFull() {
        return (statusReg & RDRF) == RDRF;
    }

    /**
     * Is Transmit register empty?
     */
    boolean isTransmitRegisterEmpty() {
        return (statusReg & TDRE) == TDRE;
    }

    /**
     * Get interrupted by reader thread and get the byte.
     */
    synchronized void dataReceived(int val) {
        // Wait until the CPU has taken the current byte
        while (isReceiveRegisterFull()) {
            try {
                wait();
            } catch (InterruptedException e) {}
        }
        receiveData = val;
        statusReg |= RDRF;   // We have set interrupt, Read register is full.
        if (receiveIrqEnabled) {
            raiseIRQ();
        }
        notifyAll();
    }

    /**
     * Let the LineWriter wait for the next character.
     */
    synchronized int valueToTransmit() {
        while (isTransmitRegisterEmpty()) {
            try {
                wait();
            } catch (InterruptedException e) {
                LOGGER.info("InterruptedException", e);
            }
        }
        statusReg |= TDRE;     // Transmit register is empty now
        if (transmitIrqEnabled && getDCD()) {
            raiseIRQ();
        }
        notifyAll();
        return transmitData;
    }

    private void raiseIRQ() {
        if ((statusReg & IRQ) == 0) {
            statusReg |= IRQ;
            cpu.signalIRQ(true);
        }
    }

    private void lowerIRQ() {
        if ((statusReg & IRQ) == IRQ) {
            statusReg &= ~IRQ;    // Turn off interrupt flag
            cpu.signalIRQ(false);
        }
    }

    private void signalReadyForTransmit() {
        if (transmitIrqEnabled) {
            raiseIRQ();
        } else {
            lowerIRQ();
        }
    }

    @Override
    protected int load(int addr) {
        try {
            switch (addr - getStartAddress()) {
            case DATA_REG:
                return getReceivedValue();
            case STAT_REG:
                return getStatusReg();
            case CMND_REG:
                LOGGER.debug("Read command register");
                return commandRegister;
            case CTRL_REG:
                LOGGER.debug("Read control register");
                return controlRegister;
            }
        } catch (IOException e) {
            System.exit(1);
        }
        return 0;
    }

    @Override
    protected void store(int addr, int val) {
        switch (addr - getStartAddress()) {
        case DATA_REG:
            sendValue(val);
            break;
        case STAT_REG:
            reset();
            break;
        case CMND_REG:
            setCommandRegister(val);
            break;
        case CTRL_REG:
            setControlRegister(val);
            break;
        }
    }

    /**
     * Writing a byte to the status register resets the chip.
     */
    private void reset() {
        LOGGER.debug("Reset");
        statusReg = TDRE;
        transmitData = 0;
        receiveData = 0;
        receiveIrqEnabled = false;
        transmitIrqEnabled = false;
        lowerIRQ();
    }

    /**
     * Get the status register. This must not wait.
     * @return The contents of the status register.
     */
    private int getStatusReg() throws IOException {
        int stat = statusReg;
        lowerIRQ();
        LOGGER.debug("StatusReg: {}", stat);
        return stat & 0xFF;
    }

    /**
     * Transmit byte to the terminal. Producer.
     * Should only be called when the register is empty.
     *
     * @param value - Character to send.
     */
    private synchronized void sendValue(int val) {
        LOGGER.debug("Send value: {}", val);
        while (!isTransmitRegisterEmpty()) {
            try {
                wait();
            } catch (InterruptedException e) {}
        }
        transmitData = val;
        statusReg &= ~TDRE;    // Transmit register is not empty now
        notifyAll();
    }

    /**
     * Read the receiver data register.
     * RDRF goes to 0 when the processor reads the register.
     */
    private synchronized int getReceivedValue() throws IOException {
        LOGGER.debug("Received val: {}", receiveData);
        statusReg &= ~RDRF;    // Receive register is empty now
        notifyAll();
        return receiveData;
    }

    /**
     * Set control flags.
     * Value 5 = IRQ for receive on, IRQ for transmit on.
     */
    private void setCommandRegister(int data) {
        LOGGER.debug("Set command (Reg #{}): {}", CMND_REG, data);
        commandRegister = data;

        // Bit 1 controls receiver IRQ behavior
        receiveIrqEnabled = (commandRegister & IRD) == 0;
        if (receiveIrqEnabled && isReceiveRegisterFull()) {
            statusReg |= IRQ;
        }
        // Bits 2 & 3 controls transmit IRQ behavior
        transmitIrqEnabled = (commandRegister & TIC1) == 0
                        && (commandRegister & TIC0) != 0;
        if (transmitIrqEnabled && isTransmitRegisterEmpty()) {
            signalReadyForTransmit();
        }

    }

    /**
     * Set the control register and associated state.
     *
     * @param data Data to write into the control register
     */
    private void setControlRegister(int data) {
        LOGGER.debug("Set control (Reg #{}): {}", CTRL_REG, data);
        controlRegister = data;
        int rate = 0;

        // If the value of the data is 0, this is a request to reset,
        // otherwise it's a control update.

        if (data == 0) {
            reset();
        } else {
            // Mask the lower three bits to get the baud rate.
            int baudSelector = data & 0x0f;
        }
    }

}
