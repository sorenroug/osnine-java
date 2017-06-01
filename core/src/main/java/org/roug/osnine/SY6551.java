package org.roug.osnine;

import java.io.InputStream;
import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Thread to listen to incoming data.
 */
class LineReader implements Runnable {

    private static final Logger LOGGER = LoggerFactory.getLogger(LineReader.class);

    private SY6551 acia;

    LineReader(SY6551 acia) {
        this.acia = acia;
    }

    public void run() {
        LOGGER.info("Reader thread started");
        while (true) {
            try {
                int receiveData = System.in.read();
                if (receiveData == 10) receiveData = 13;
                LOGGER.debug("Received {}", receiveData);
                while (acia.isReceiveRegisterFull()) { // Wait until the CPU has taken the current byte
                    Thread.yield();
                }
                acia.dataReceived(receiveData);
            } catch (Exception e) {
                System.exit(2);
            }
        }
    }
}

/**
 * The Dragon 64 and Dragon Alpha have a hardware serial port driven
 * by a Rockwell 6551, mapped from $FF04-$FF07.
 * FIXME: Incomplete.
 */
public class SY6551 extends MemorySegment {

    private static final Logger LOGGER = LoggerFactory.getLogger(SY6551.class);

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
    private int statusReg = 0x10;

    /** Reference to CPU for the purpose of sending IRQ. */
    private MC6809 cpu;

    /**
     * Constructor.
     */
    public SY6551(int start, MC6809 cpu) {
        super(start, start + 3);
        this.cpu = cpu;
        Thread reader = new Thread(new LineReader(this), "acia6551");
        reader.setDaemon(true);
        reader.start();
    }

    /**
     * Is Receive register full?
     */
    boolean isReceiveRegisterFull() {
        return (statusReg & RDRF) == RDRF;
    }

    /**
     * Get interrupted by reader thread and get the byte.
     */
    void dataReceived(int receiveData) {
        this.receiveData = receiveData;
        statusReg |= (IRQ+RDRF);   // We have set interrupt, Read register is full.
        cpu.signalIRQ();
        Thread.yield();
    }

    void signalReadyForTransmit() {
        if (transmitIrqEnabled) {
            statusReg |= IRQ;   // We have set interrupt
            cpu.signalIRQ();  // Probably ignored because OS9 is still in interrupt handler 
            //Thread.yield();
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
    @Override
    public void reset() {
        LOGGER.debug("Reset");
        transmitData = 0;
        receiveData = 0;
        receiveIrqEnabled = false;
        transmitIrqEnabled = false;
    }

    /**
     * @return The contents of the status register.
     * In this implementation the transmit register can not be full.
     * Therefore the IRQ is always on.
     */
    private int getStatusReg() throws IOException {
        int stat = statusReg;
//      if (!transmitIrqEnabled) {
//          statusReg &= ~IRQ;    // Turn off interrupt flag
//      }
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
        statusReg &= ~RDRF;    // Turn of interrupt flag
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
            int baudSelector = data & 0x0f;
        }
    }

}