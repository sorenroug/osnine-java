package org.roug.usim;

import java.util.Timer;
import java.util.TimerTask;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

class ClockTick extends TimerTask {

    private static final Logger LOGGER = LoggerFactory.getLogger(TimerTask.class);

    private boolean activeIRQ;

    private Bus8Motorola bus;

    ClockTick(Bus8Motorola bus) {
        activeIRQ = false;
        this.bus = bus;
    }

    public synchronized void run() {
        if (!activeIRQ) {
            activeIRQ = true;
            bus.signalIRQ(true); // Execute a hardware interrupt
        }
    }

    synchronized boolean isActiveIRQ() {
        return activeIRQ;
    }

    synchronized void setActiveIRQ(boolean val) {
        activeIRQ = val;
    }
}

/**
 * Cause a periodic interrupt to the CPU. The IRQ is turned off when
 * the CPU reads a specific memory address. (Typically $FF00)
 */
public class IRQBeat extends MemorySegment {


    private static final int CLOCKDELAY = 500;  // milliseconds
    /** On Dragon 32 the interrupt is 50 times a second. */
    private static final int CLOCKPERIOD = 20;  // milliseconds

    private static final Logger LOGGER = LoggerFactory.getLogger(IRQBeat.class);

    /** Reference to CPU for the purpose of sending IRQ. */
    private Bus8Motorola bus;

    private ClockTick clocktask;

    private int clockPeriod = CLOCKPERIOD;

    /**
     * Constructor.
     *
     * @param start - First address location of the ACIA.
     * @param bus - The bus the ACIA is attached to.
     * @param period - Frequency for how often to interrupt the CPU in milliseconds.
     */
    public IRQBeat(int start, Bus8Motorola bus, int period) {
        super(start, start + 1);
        LOGGER.debug("Initialise heartbeat");
        this.bus = bus;
        clockPeriod = period;
    }

    /**
     * Constructor.
     *
     * @param start - First address location of the ACIA.
     * @param bus - The bus the ACIA is attached to.
     * @param args - additional arguments
     */
    public IRQBeat(int start, Bus8Motorola bus, String... args) {
        this(start, bus, CLOCKPERIOD);
    }

    // Return 1 if IRQ is enabled and turn it off.
    @Override
    protected int load(int addr) {
        LOGGER.debug("Check");
        if (clocktask != null && clocktask.isActiveIRQ()) {
            clocktask.setActiveIRQ(false);
            bus.signalIRQ(false);
            return 1; // There was an IRQ
        } else {
            return 0;
        }
    }

    @Override
    protected void store(int addr, int val) {
        LOGGER.debug("Starting heartbeat every {} milliseconds", val);
        if (clocktask == null) {
            clocktask = new ClockTick(bus);
            Timer timer = new Timer("clock", true);
            timer.scheduleAtFixedRate(clocktask, CLOCKDELAY, clockPeriod);
        }
    }

}
