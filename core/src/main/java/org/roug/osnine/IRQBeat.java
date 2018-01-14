package org.roug.osnine;

import java.util.Timer;
import java.util.TimerTask;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

class ClockTick extends TimerTask {

    private static final Logger LOGGER = LoggerFactory.getLogger(TimerTask.class);

    private boolean activeIRQ;

    private Bus6809 cpu;

    ClockTick(Bus6809 cpu) {
        activeIRQ = false;
        this.cpu = cpu;
    }

    public void run() {
        LOGGER.debug("IRQ sent");
        activeIRQ = true;
        cpu.signalIRQ(true); // Execute a hardware interrupt
    }

    boolean isActiveIRQ() {
        return activeIRQ;
    }

    void setActiveIRQ(boolean val) {
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
    private Bus6809 cpu;

    private ClockTick clocktask;

    /**
     * Constructor.
     */
    public IRQBeat(int start, Bus6809 cpu) {
        super(start, start + 1);
        LOGGER.debug("Initialise heartbeat");
        this.cpu = cpu;
    }

    // Return 1 if IRQ is enabled and turn it off.
    @Override
    protected int load(int addr) {
        LOGGER.debug("Check");
        if (clocktask != null && clocktask.isActiveIRQ()) {
            clocktask.setActiveIRQ(false);
            cpu.signalIRQ(false);
            return 1; // There was an IRQ
        } else {
            return 0;
        }
    }

    @Override
    protected void store(int addr, int val) {
        LOGGER.debug("Starting heartbeat every {} milliseconds", val);
        if (clocktask == null) {
            clocktask = new ClockTick(cpu);
            Timer timer = new Timer("clock", true);
            timer.schedule(clocktask, CLOCKDELAY, CLOCKPERIOD);
        }
    }

}
