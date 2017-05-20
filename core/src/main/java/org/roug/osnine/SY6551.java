package org.roug.osnine;

import java.io.InputStream;
import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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

    private int transmitData;
    private int receiveData;
    private int controlRegister;
    private int commandRegister;
    private boolean rxFull  = false;
    private boolean txEmpty = true;
    boolean receiveIrqEnabled = false;
    boolean transmitIrqEnabled = false;

    /**
     * Constructor.
     */
    public SY6551(int start) {
        super(start, start + 3);
    }

    @Override
    protected int load(int addr) {
        LOGGER.debug("Load: {}", Integer.toHexString(addr));
        try {
            switch (addr - getStartAddress()) {
            case DATA_REG:
                return receiveVal();
            case STAT_REG:
                return statusReg();
            case CMND_REG:
                return commandRegister;
            case CTRL_REG:
                return controlRegister;
            }
        } catch (IOException e) {
            System.exit(1);
        }
        return 0;
    }

    @Override
    protected void store(int addr, int val) {
        LOGGER.debug("Store: {} <- {}", Integer.toHexString(addr), Integer.toHexString(val));
        switch (addr - getStartAddress()) {
        case DATA_REG:
            sendVal(val);
            break;
        case STAT_REG:
            reset();
            break;
        case CMND_REG:
            setCommandRegister(val);
        case CTRL_REG:
            setControlRegister(val);
        }
    }

    @Override
    public void reset() {
        transmitData = 0;
        txEmpty = true;
        receiveData = 0;
        rxFull = false;
        receiveIrqEnabled = false;
        transmitIrqEnabled = false;
    }

    /**
     * @return The contents of the status register.
     * In this implementation the transmit register can not be full.
     */
    private int statusReg() throws IOException {
        int stat = 0x00;
        if (System.in.available() > 0) {
            stat |= 0x08;
        }
        if (txEmpty) {
            stat |= 0x10;
        }
        return stat;
    }

    private void sendVal(int val) {
        //rxFull = true;
        System.out.write(val);
        System.out.flush();
    }

    private int receiveVal() throws IOException {
        // If input is ready read a character
        if (System.in.available() > 0) {
            int ch = System.in.read();
            rxFull = false;
            return ch;
        }
        return 0;
    }

    private void setCommandRegister(int data) {
        commandRegister = data;

        // Bit 1 controls receiver IRQ behavior
        receiveIrqEnabled = (commandRegister & 0x02) == 0;
        // Bits 2 & 3 controls transmit IRQ behavior
        transmitIrqEnabled = (commandRegister & 0x08) == 0 && (commandRegister & 0x04) != 0;
    }

    /**
     * Set the control register and associated state.
     *
     * @param data Data to write into the control register
     */
    private void setControlRegister(int data) {
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

    private boolean btst(int x, int n) {
        return (x & n) != 0;
    }
}
