package org.roug.osnine;

import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
