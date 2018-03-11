package org.roug.osnine;

import java.io.InputStream;
import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Emulate the 6551 with output to Stdout and input from Stdin.
 * The Dragon 64 and Dragon Alpha have a hardware serial port driven
 * by a Rockwell 6551, mapped from $FF04-$FF07.
 * In this implementation the transmit register can not be full.
 */
public class Acia6551Console extends MemorySegment implements Acia {

    private static final Logger LOGGER =
            LoggerFactory.getLogger(Acia6551Console.class);

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

    /** Rx data register Full. */
    private static final int CR3 = 8;    // %00001000   RDRE
    /** Receive Data Register Full. */
    private static final int RDRF = 8;

    /** Transmitter Data Register Ready. */
    private static final int CR4 = 16;   // %00010000
    /** Transmit Data Register Empty. */
    private static final int TDRE = 16;

    /** Data Carrier Detect. */
    private static final int CR5 = 32;   // %00100000
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

    /** In this implementation the transmit register can not be full. */
    private int statusReg = TDRE;

    /** Reference to CPU for the purpose of sending IRQ. */
    private Bus6809 cpu;

    /**
     * Constructor.
     */
    public Acia6551Console(int start, Bus6809 cpu) {
        super(start, start + 3);
        this.cpu = cpu;
        Thread reader = new Thread(new ConsoleReader(this), "acia6551");
        reader.setDaemon(true);
        reader.start();
    }

    /**
     * Is Receive register full?
     */
    @Override
    public boolean isReceiveRegisterFull() {
        return (statusReg & RDRF) == RDRF;
    }

    /**
     * Get interrupted by reader thread and get the byte.
     */
    @Override
    public void dataReceived(int receiveData) {
        this.receiveData = receiveData;
        statusReg |= RDRF;   // We have set interrupt, Read register is full.
        if (receiveIrqEnabled) {
            raiseIRQ();
        }
        Thread.yield();
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

    void signalReadyForTransmit() {
        if (transmitIrqEnabled) {
            raiseIRQ();
        } else {
            lowerIRQ();
        }
    }

    @Override
    protected int load(int addr) {
        //LOGGER.debug("Load: {}", Integer.toHexString(addr));
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
        //LOGGER.debug("Store: {} <- {}", Integer.toHexString(addr), Integer.toHexString(val));
        switch (addr - getStartAddress()) {
        case DATA_REG:
            sendVal(val);
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
        transmitData = 0;
        receiveData = 0;
        receiveIrqEnabled = false;
        transmitIrqEnabled = false;
        lowerIRQ();
    }

    /**
     * @return The contents of the status register.
     */
    private int getStatusReg() throws IOException {
        int stat = statusReg;
        lowerIRQ();
        LOGGER.debug("StatusReg: {}", stat);
        return stat & 0xFF;
    }

    /**
     * Transmit byte to the terminal.
     *
     * @param value - Character to send.
     */
    private void sendVal(int val) {
        LOGGER.debug("Send value: {}", val);
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
        statusReg &= ~RDRF;
        return receiveData;
    }

    private void setCommandRegister(int data) {
        LOGGER.debug("Set command (Reg #{}): {}", CMND_REG, data);
        commandRegister = data;

        // Bit 1 controls receiver IRQ behavior
        receiveIrqEnabled = (commandRegister & IRD) == 0;
        // Bits 2 & 3 controls transmit IRQ behavior
        transmitIrqEnabled = (commandRegister & TIC1) == 0 && (commandRegister & TIC0) != 0;
        // Send a IRQ immediately as the transmit register is empty.
        signalReadyForTransmit();
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
            // Unused.
            int baudSelector = data & 0x0f;
        }
    }

}
