package org.roug.osnine;

import java.io.IOException;
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
public class Acia6850Console extends MemorySegment implements Acia {

    private static final Logger LOGGER =
            LoggerFactory.getLogger(Acia6850Console.class);

    static final int STAT_REG = 0;
    static final int CTRL_REG = 0;
    static final int RX_REG = 1;
    static final int TX_REG = 1;

    /** Receive Data Register Full. */
    private static final int RDRF = 1;
    /** Transmit Data Register Empty. */
    private static final int TDRE = 2;
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

    private int transmitData, receiveData, controlRegister, statusRegister;

    private String eolSequence = "\015";

    /** Reference to CPU for the purpose of sending IRQ. */
    private Bus6809 cpu;

    /**
     * Constructor.
     */
    public Acia6850Console(int start, Bus6809 cpu) {
        super(start, start + 2);
        this.cpu = cpu;
        reset();
        Thread reader = new Thread(new ConsoleReader(this), "acia6850");
        reader.setDaemon(true);
        reader.start();
    }

    private void reset() {
        controlRegister = 0;         // Clear all control flags
        statusRegister = TDRE;         // Clear all status bits
    }

    /**
     * Set the End-of-line sequence. In OS-9 this is 0x0D.
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

    /**
     * Is Receive register full?
     */
    private boolean isReceiveRegisterFull() {
        return (statusRegister & RDRF) == RDRF;
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
    @Override
    public void dataReceived(int receiveData) {
        while (isReceiveRegisterFull()) {
            Thread.yield();
        }
        this.receiveData = receiveData;
        statusRegister |= RDRF;   // We have set interrupt, Read register is full.
        if (receiveIrqEnabled) {
            raiseIRQ();
        }
        Thread.yield();
    }

    private void raiseIRQ() {
        if ((statusRegister & IRQ) == 0) {
            statusRegister |= IRQ;
            cpu.signalIRQ(true);
        }
    }

    private void lowerIRQ() {
        if ((statusRegister & IRQ) == IRQ) {
            statusRegister &= ~IRQ;    // Turn off interrupt flag
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
            sendVal(val);
            break;
        default:
            controlRegister = val;
            // Check for master reset
            if (btst(controlRegister, CR0) && btst(controlRegister, CR1)) {
                reset();
            }
        }
    }

    /**
     * @return The contents of the status register.
     */
    private int getStatusReg() throws IOException {
        LOGGER.debug("StatusRegister: {}", statusRegister);
        return statusRegister;
    }

    private void sendVal(int val) {
        LOGGER.debug("Send value: {}", val);
        statusRegister &= ~IRQ;   // Clear IRQ
        statusRegister |= TDRE;   // Set TDRE to true
        System.out.write(val);
        System.out.flush();
        signalReadyForTransmit();
    }

    /**
     * Read the receiver data register.
     * RDRE goes to 0 when the processor reads the register.
     */
    private int getReceivedValue() throws IOException {
        LOGGER.debug("Received val: {}", receiveData);
        statusRegister &= ~RDRF;
        return receiveData;
    }

    private boolean btst(int x, int n) {
        return (x & n) != 0;
    }
}
