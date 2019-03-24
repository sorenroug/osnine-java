package org.roug.osnine;

import org.roug.osnine.Bus8Motorola;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Slows down the CPU to the desired speed by locking/unlocking the bus.
 * It lets the CPU run for one milli-second, then calculates how many
 * milli-seconds to sleep to emulate e.g. a 1 MHz clock.
 */
public class Throttler implements Runnable {

    private static final Logger LOGGER
                    = LoggerFactory.getLogger(Throttler.class);

    private float throttleTarget = 1000f;

    private static final long NANO_TO_MILLI = 1000000L;

    private static final int UNLOCK_DURATION = 1;

    private static final int LOCK_GRANULARITY = 10;

    private Bus8Motorola bus;

    private volatile long cyclesBefore, cyclesAfter;
    private volatile long timeBefore, timeAfter;
    private volatile long timeUnlocked;

    private float rawCPUspeed, throttledCPUspeed;

    /** True if throttling the speed. */
    private boolean throttling = false;

    private int sleepTime = 0;
    private int unlockTime = 1000;
    private int lockLength = LOCK_GRANULARITY;

    /**
     * Create a CPU speed throttler.
     *
     * @param bus the bus to lock/unlock.
     * @param speedHz target speed in Hz. On a Dragon 32/64 this would be
     * 890000 for 0.89 MHz.
     */
    public Throttler(Bus8Motorola bus, int speedHz) {
        this.bus = bus;
        throttleTarget = (float) speedHz / 1000f;
    }

    /**
     * Create a CPU speed throttler at 1 MHz.
     *
     * @param bus the bus to lock/unlock
     */
    public Throttler(Bus8Motorola bus) {
        this(bus, 1000000);
    }

    @Override
    public void run() {
        try {
            cyclesBefore = bus.getCycleCounter();
            timeBefore = System.nanoTime() / NANO_TO_MILLI;
            timeUnlocked = timeBefore;
            while(true) {
                Thread.sleep(unlockTime); // Let the CPU run
                timeUnlocked = System.nanoTime() / NANO_TO_MILLI;
                if (throttling) {
                    bus.lock();
                    try {
                        Thread.sleep(sleepTime);  // The CPU is halted
                    } finally {
                        bus.unlock();
                    }
                }

                cyclesAfter = bus.getCycleCounter();
                timeAfter = System.nanoTime() / NANO_TO_MILLI;

                float cyclesDelta = cyclesAfter - cyclesBefore;
                rawCPUspeed = cyclesDelta / (timeUnlocked - timeBefore);
                throttledCPUspeed = cyclesDelta / (timeAfter - timeBefore);

                timeBefore = timeAfter;
                cyclesBefore = cyclesAfter;
                // Calculate next sleep time
                if (throttling) {
                    float delta = throttledCPUspeed - throttleTarget;
                    if (delta > 200 && sleepTime < 18) {
                        LOGGER.debug("Increase sleep");
                        sleepTime++;
                    } else if (delta > -200 && sleepTime > 1) {
                        LOGGER.debug("Decrease sleep");
                        sleepTime--;
                    }
                }
            }
        } catch (InterruptedException e) {
            LOGGER.error("throttler", e);
        }
    }

    /**
     * Return the speed the CPU runs when not throttled.
     *
     * @return the CPU speed
     */
    public float cpuSpeed() {
        //LOGGER.info("Time delta: {}, Cycles delta {}", timeDelta, cyclesDelta);
        return rawCPUspeed;
    }

    /**
     * Return actual speed when throttled.
     *
     * @return the throttled CPU speed
     */
    public float throttleSpeed() {
        return throttledCPUspeed;
    }

    /**
     * Set throttling of the bus.
     *
     * @param throttling if true then the CPU will be throttled.
     */
    public void throttle(boolean throttling) {
        this.throttling = throttling;
        if (throttling) {
            unlockTime = UNLOCK_DURATION;
            sleepTime = lockLength;
        } else {
            unlockTime = 1000;
            sleepTime = 0;
        }
    }

    /*
     * Get throttling state.
     *
     * @return throttling state.
     */
    public boolean isThrottling() {
        return throttling;
    }

}
