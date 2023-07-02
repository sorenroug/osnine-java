package org.roug.usim;

import java.time.LocalDateTime;
import java.util.Timer;
import java.util.TimerTask;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Support class to create a heartbeat.
 */
class MMClockTick extends TimerTask {

    private static final Logger LOGGER = LoggerFactory.getLogger(TimerTask.class);

    private boolean activeIRQ;

    private Bus8Motorola bus;

    MMClockTick(Bus8Motorola bus) {
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
 * Implementation of MM58167 Real Time Clock.
 * The chip is addressed at 32 memory locations.
 */
public class MM58167 extends MemorySegment {


    private static final int CLOCKDELAY = 500;  // milliseconds
    /** The interrupt is 10 times a second. */
    private static final int CLOCKPERIOD = 100;  // milliseconds

    private static final int SECMILLI_REG = 0;
    private static final int SECTENTH_REG = 1;
    private static final int SECOND_REG = 2;
    private static final int MINUTE_REG = 3;
    private static final int HOUR_REG = 4;
    private static final int DAYWEEK_REG = 5;
    private static final int DAYMONTH_REG = 6;
    private static final int MONTH_REG = 7;
    private static final int STATUS_REG = 16;
    private static final int CONTROL_REG = 17;
    private static final int COUNTRST_REG = 18;
    private static final int LATCHRST_REG = 19;
    private static final int ROLLOVER_REG = 20;
    private static final int GO_REG = 21;


    private static final Logger LOGGER = LoggerFactory.getLogger(MM58167.class);

    /** Reference to CPU for the purpose of sending IRQ. */
    private Bus8Motorola bus;

    private MMClockTick clocktask;

    private int clockPeriod = CLOCKPERIOD;

    private Timer timer = null;

    /**
     * Constructor.
     *
     * @param start - First address location of the ACIA.
     * @param bus - The bus the ACIA is attached to.
     * @param period - Frequency for how often to interrupt the CPU in milliseconds.
     */
    public MM58167(int start, Bus8Motorola bus, int period) {
        super(start, start + 32);
        LOGGER.debug("Initialise heartbeat");
        this.bus = bus;
        clockPeriod = period;
        clocktask = new MMClockTick(bus);
    }

    /**
     * Constructor.
     *
     * @param start - First address location of the ACIA.
     * @param bus - The bus the ACIA is attached to.
     * @param args - additional arguments
     */
    public MM58167(int start, Bus8Motorola bus, String... args) {
        this(start, bus, CLOCKPERIOD);
    }

    int bcdToDec(int val) {
        return( (val/16*10) + (val%16) );
    }

    private int decToBcd(int val) {
        return( (val/10*16) + (val%10) );
    }

    @Override
    protected int load(int addr) {
        LOGGER.debug("Check {}", addr);
        if ((addr - getStartAddress()) == STATUS_REG) {
            // Reading this register clears interrupt
            if (clocktask.isActiveIRQ()) {
                clocktask.setActiveIRQ(false);
                bus.signalIRQ(false);
                return 1; // There was an IRQ
            } else {
                return 0;
            }
        }
        LocalDateTime ldt = LocalDateTime.now();
        switch (addr - getStartAddress()) {
        case SECOND_REG:
            return decToBcd(ldt.getSecond());
        case MINUTE_REG:
            return decToBcd(ldt.getMinute());
        case HOUR_REG:
            return decToBcd(ldt.getHour());
        case DAYMONTH_REG:
            return decToBcd(ldt.getDayOfMonth());
        case MONTH_REG:
            return decToBcd(ldt.getMonthValue());
        case ROLLOVER_REG:
            // We never show rollover
            return 0;
        }
        return 0;
    }

    @Override
    protected void store(int addr, int val) {
        switch (addr - getStartAddress()) {
        case CONTROL_REG:
            // If value is 0 then disable interrupts
            // If value is 2 then enable 100 millisec interrupts
            // If value is 4 then enable 1000 millisec interrupts (not impl.)
            if (val == 0) {
                if (timer != null) {
                    timer.cancel();
                    timer = null;
                }
            } else if (val == 2) {
                timer = new Timer("clock", true);
                timer.schedule(clocktask, CLOCKDELAY, 100);
            }
            break;
        case SECOND_REG:
        case MINUTE_REG:
        case HOUR_REG:
        case DAYMONTH_REG:
        case MONTH_REG:
// Ignore setting the date
            break;
        case LATCHRST_REG:
// value FF resets latches. Ignored
            break;
        }
    }

}
