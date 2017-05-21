package org.roug.osnine;

import java.io.InputStream;
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
public class MC6850 extends MemorySegment {

    private static final Logger LOGGER = LoggerFactory.getLogger(MC6850.class);

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

    /** Location of ACIA in memory. */
    private int offset;

    private int transmitData, receiveData, controlRegister, statusRegister;

    /**
     * Constructor.
     */
    public MC6850(int start) {
        super(start, start + 1);
        this.offset = start;
    }

    @Override
    public void reset() {
        controlRegister = 0;         // Clear all control flags
        statusRegister = 0;         // Clear all status bits

        statusRegister |= TDRE;

    }

    @Override
    protected int load(int addr) {
        LOGGER.debug("Load: {}", addr);
        try {
            // Check for a received character if one isn't available
            if (!btst(statusRegister, RDRF)) {
                int ch;

                // If input is ready read a character
                if (System.in.available() > 0) {
                    ch = System.in.read();
                    receiveData = ch;

                    // Check for IRQ
                    if (btst(controlRegister, CR7)) {
                        statusRegister |= IRQ;
                    }

                    statusRegister |= RDRF;            // Set RDRF
                }
            }

            // Now return the relevant value
            switch(addr - offset) {
            case RX_REG:
                statusRegister &= ~RDRF;               // Clear RDRF
                statusRegister &= ~IRQ;                // Clear IRQ
                return receiveData;
            default:
                return statusRegister;
            }
        } catch (IOException e) {
            System.exit(1);
            return -1;
        }
    }

    @Override
    protected void store(int addr, int val) {
        LOGGER.debug("Store: {} <- {}", addr, val);
        switch(addr - offset) {
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

    private void sendVal(int val) {
        statusRegister &= ~IRQ;   // Clear IRQ
        statusRegister |= TDRE;   // Set TDRE to true
        System.out.write(val);
        System.out.flush();
    }

    private boolean btst(int x, int n) {
        return (x & n) != 0;
    }
}
