package org.roug.usim;

import java.io.IOException;
import java.lang.reflect.Constructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Motorola 6850 Asynchronous Communications Interface Adapter (ACIA).
 * It includes a universal asynchronous receiver-transmitter (UART).
 * The essential function of the ACIA is serial-to-parallel and
 * parallel-to-serial conversion.
 *
 * At the bus interface, the ACIA appears as two addressable memory locations.
 */
public class Acia6850 extends MemorySegment implements Acia {

    private static final Logger LOGGER =
            LoggerFactory.getLogger(Acia6850.class);

    static final int STAT_REG = 0;
    static final int CTRL_REG = 0;
    static final int RX_REG = 1;
    static final int TX_REG = 1;

    /** Receive Data Register Full. */
    private static final int RDRF = 1;

    /** Transmit Data Register Empty. */
    private static final int TDRE = 2;

    /** Data Carrier Detect. */
    private static final int DCD = 4;   // %00000100

    /** Interupt Request. */
    private static final int IRQ = 128;

    private static final int CR0 = 1;
    private static final int CR1 = 2;
    private static final int CR2 = 4;
    private static final int CR3 = 8;
    private static final int CR4 = 16;
    private static final int CR5 = 32;
    private static final int CR6 = 64;
    /** Receive Interupt Enable. */
    private static final int CR7 = 128;

    private boolean receiveIrqEnabled = false;
    boolean transmitIrqEnabled = false;

    private int transmitData, receiveData;
    private int statusRegister;

    private String eolSequence = "\015";

    /** Reference to CPU for the purpose of sending IRQ. */
    private Bus8Motorola bus;

    /**
     * Constructor.
     * The ACIA appears as two addressable memory locations.
     * The data register is addressed when register select is high.
     * Status/Control register is addressed when the register select is low.
     *
     * @param start - First address location of the ACIA.
     * @param bus - The bus the ACIA is attached to.
     * @param args - additional arguments
     */
    public Acia6850(int start, Bus8Motorola bus, String... args) {
        super(start, start + 2);
        this.bus = bus;
        reset();
        setDCD(false);  // There is no carrier
        if (args.length > 0) {
            loadUI(args[0]);
        }
    }

    /**
     * Load the class that implements the user interface.
     *
     * @param guiClassStr the name of the Java class as a string.
     */
    private void loadUI(String guiClassStr) {
        LOGGER.debug("Loading class {}", guiClassStr);
        try {
            Class newClass = Class.forName(guiClassStr);
            Constructor<Runnable> constructor = newClass.getConstructor(Acia.class);
            Runnable threadInstance = constructor.newInstance(this);

            Thread reader = new Thread(threadInstance, "acia6850");
            reader.setDaemon(true);
            reader.start();
        } catch (Exception e) {
            LOGGER.error("Load failure", e);
            System.exit(1);
        }
    }

    private void reset() {
        lowerIRQ();
        statusRegister = TDRE;         // Clear all status bits
    }

    /**
     * Set Data Carrier Detect. In telnet-based emulation this
     * is set to high when a client has connected to the socket.
     * When the client closes the connection, then the DCD goes to false.
     * In the 6850, the bit is inverted. I.e. bit 2 in the status register
     * is 1 when there is no carrier.
     *
     * @param detected - if there is a carrier
     */
    @Override
    public synchronized void setDCD(boolean detected) {
        LOGGER.trace("setDCD");
        int oldStatus = statusRegister & DCD;
        if (detected) {
            clearStatusBit(DCD);
        } else {
            setStatusBit(DCD);
            if (receiveIrqEnabled && oldStatus == 0) {
                raiseIRQ();
            }
        }
    }

    /**
     * Let the LineWriter wait for the next character.
     */
    @Override
    public synchronized int waitForValueToTransmit() throws InterruptedException {
        LOGGER.trace("Wait for value");
        while (isBitOn(statusRegister, TDRE)) {
            wait();
        }
        LOGGER.trace("wait done");
        int t = transmitData;
        setStatusBit(TDRE);
        if (transmitIrqEnabled) {
            raiseIRQ();
        }
        notifyAll();
        return t;
    }

    /**
     * Set the End-of-line sequence. In OS-9 this is 0x0D.
     *
     * @param token - symbolic name for nl, crnl or cr.
     */
    public void setEol(String token) {
        if ("nl".equalsIgnoreCase(token)) {
            eolSequence = "\012";
        } else {
            if ("crnl".equalsIgnoreCase(token)) {
                eolSequence = "\015\012";
            } else {
                eolSequence = "\015";
            }
        }
    }

    @Override
    public void eolReceived() {
        for (int i = 0; i < eolSequence.length(); i++) {
            dataReceived(eolSequence.charAt(i));
        }
    }

    /**
     * Get interrupted by reader thread and get the byte.
     */
    public synchronized void dataReceived(int val) {
        LOGGER.trace("get data received: {}", val);
        // Wait until the CPU has taken the current byte
        while (isBitOn(statusRegister, RDRF)) {
            try {
                wait();
            } catch (InterruptedException e) {
                LOGGER.info("InterruptedException", e);
            }
        }
        // RDRF is now 0
        receiveData = val;
        setStatusBit(RDRF);   // Read register is full.
        if (receiveIrqEnabled) {
            raiseIRQ();
        }
        notifyAll();
    }

    private void raiseIRQ() {
        if (isBitOff(statusRegister, IRQ)) {
            setStatusBit(IRQ);
            bus.signalIRQ(true);
        }
    }

    private void lowerIRQ() {
        if (isBitOn(statusRegister, IRQ)) {
            if (!bus.isIRQActive()) {
                LOGGER.error("Lowering IRQ on bus that has no IRQ active");
            }
            clearStatusBit(IRQ);
            bus.signalIRQ(false);
        }
    }

    @Override
    protected int load(int addr) {
        LOGGER.debug("Load: {}", addr);
        try {
            switch(addr - getStartAddress()) {
            case RX_REG:
                return getReceivedValue();
            default:
                return getStatusReg();
            }
        } catch (IOException e) {
            System.exit(1);
        }
        return 0;
    }

    @Override
    protected void store(int addr, int val) {
        LOGGER.debug("Store: {} <- {}", addr, val);
        switch(addr - getStartAddress()) {
        case TX_REG:
            sendValue(val);
            break;
        default:
            setControlRegister(val);
        }
    }

    /**
     * @return The contents of the status register.
     */
    private synchronized int getStatusReg() throws IOException {
        LOGGER.debug("StatusRegister: {}", statusRegister);
        return statusRegister;
    }

    /**
     * Transmit byte to the terminal. Producer.
     * Should only be called when the register is empty.
     *
     * @param value - Character to send.
     */
    private synchronized void sendValue(int val) {
        LOGGER.debug("Send value: {}", val);
        lowerIRQ();
        while (isBitOff(statusRegister, TDRE)) {
            try {
                wait();
            } catch (InterruptedException e) {
                LOGGER.info("InterruptedException in sendValue", e);
            }
        }
        // TDRE is now on
        LOGGER.trace("Send wait done");
        transmitData = val;
        clearStatusBit(TDRE);
        notifyAll();
    }

    /**
     * Read the receiver data register.
     * RDRF goes to 0 when the processor reads the register.
     * If IRQ is enabled then IRQ goes low.
     */
    private synchronized int getReceivedValue() throws IOException {
        LOGGER.debug("Received val: {}", receiveData);
        if (isBitOff(statusRegister, TDRE)) lowerIRQ();
        int r = receiveData;  // Read before we turn RDRF off.
        clearStatusBit(RDRF);
        notifyAll();
        return r;
    }

    /**
     * Set the control register and associated state.
     *
     * @param data Data to write into the control register
     */
    private synchronized void setControlRegister(int data) {
        LOGGER.debug("Set control (Reg #{}): {}", CTRL_REG, data);
        boolean activateIRQ = false;
        // Check for IRQ disable/enable
        receiveIrqEnabled = isBitOn(data, CR7);
        if (receiveIrqEnabled && isBitOn(statusRegister, RDRF)) {
            activateIRQ = true;
        }

        // Transmit IRQ is enabled if CR6 is 0 and CR5 is 1.
        transmitIrqEnabled = isBitOff(data, CR6) && isBitOn(data, CR5);
        // Check for master reset
        if (isBitOn(data, CR0) && isBitOn(data, CR1)) {
            reset();
        }
        if (transmitIrqEnabled && isBitOn(statusRegister, TDRE)) {
            activateIRQ = true;
        }
        if (activateIRQ) {
            raiseIRQ();
        } else {
            lowerIRQ();
        }
    }

    private static boolean isBitOn(int x, int n) {
        return (x & n) != 0;
    }

    private static boolean isBitOff(int x, int n) {
        return (x & n) == 0;
    }

    private void setStatusBit(int n) {
        statusRegister |= n;
    }

    private void clearStatusBit(int n) {
        statusRegister &= ~n;
    }
}
