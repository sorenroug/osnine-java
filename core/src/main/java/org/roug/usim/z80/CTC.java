package org.roug.usim.z80;

import java.util.Timer;
import java.util.TimerTask;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

class ClockTick extends TimerTask {

    private static final Logger LOGGER = LoggerFactory.getLogger(TimerTask.class);

    private boolean activeIRQ;

    private Bus8Intel bus;

    ClockTick(Bus8Intel bus) {
        activeIRQ = false;
        this.bus = bus;
    }

    public synchronized void run() {
        if (!activeIRQ) {
            activeIRQ = true;
            bus.signalINT(true); // Execute a hardware interrupt
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
 * Counter/Timer Channels.
 * The Z80 CTC is a four-channel counter/timer that can be programmed by
 * system software for a broad range of counting and timing applications.
 * These four independently programmable channels satisfy common
 * microcomputer system requirements for event counting, interrupt and
 * interval timing, and general clock rate generation.
 */
public class CTC extends DeviceZ80 {


    private static final int CLOCKDELAY = 500;  // milliseconds
    /** On Dragon 32 the interrupt is 50 times a second. */
    private static final int CLOCKPERIOD = 20;  // milliseconds

    private static final Logger LOGGER = LoggerFactory.getLogger(CTC.class);

    /** Reference to CPU for the purpose of sending IRQ. */
    private Bus8Intel bus;

    private ClockTick clocktask;

    private int clockPeriod = CLOCKPERIOD;

    private int[] channels = new int[4];

    private int channelControl;

    /**
     * Constructor.
     *
     * @param start - First address location of the ACIA.
     * @param bus - The bus the ACIA is attached to.
     * @param period - Frequency for how often to interrupt the CPU in milliseconds.
     */
    public CTC(int start, Bus8Intel bus) {
        super(start, bus, "4");
        LOGGER.debug("Initialise heartbeat");
        this.bus = bus;
        clockPeriod = CLOCKPERIOD;
    }

    /**
     * Constructor.
     *
     * @param start - First address location of the ACIA.
     * @param bus - The bus the ACIA is attached to.
     * @param args - additional arguments
     */
    public CTC(int start, Bus8Intel bus, String... args) {
        this(start, bus);
    }

    // Return 1 if IRQ is enabled and turn it off.
    @Override
    protected int load(int addr) {
        LOGGER.debug("Check");
        if (clocktask != null && clocktask.isActiveIRQ()) {
            clocktask.setActiveIRQ(false);
            bus.signalINT(false);
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

    @Override
    public int getInterruptValue() {
        return 0;
    }

}
