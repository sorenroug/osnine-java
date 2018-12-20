package org.roug.osnine;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Slows down the CPU to the original speed by locking/unlocking the bus.
 * It lets the CPU run for one milli-second, then calculates how many
 * milli-seconds to sleep to emulate a 1 MHz clock.
 */
public class Pacer implements Runnable {

    private static final Logger LOGGER = LoggerFactory.getLogger(Pacer.class);

    private static final int UNLOCK_DURATION = 1;

    private static final int LOCK_GRANULARITY = 10;

    private Bus8Motorola bus;

    private volatile long cyclesBefore, cyclesAfter;
    private volatile long timeBefore, timeAfter;

    /** True if throttling the speed. */
    private boolean throttling = false;

    private int sleepTime = 0;
    private int unlockTime = 1000;

    public Pacer(Bus8Motorola bus) {
        this.bus = bus;
    }

    @Override
    public void run() {
        try {
            while(true) {
                timeBefore = timeAfter;
                cyclesBefore = cyclesAfter;

                cyclesAfter = bus.getCycleCounter();
                timeAfter = System.nanoTime();

                if (throttling) {
                    Thread.sleep(unlockTime); // Let the CPU run
                    bus.lock();
                    try {
                        Thread.sleep(sleepTime);  // The CPU is halted
                    } finally {
                        bus.unlock();
                    }
                } else {
                    Thread.sleep(unlockTime); // Let the CPU run
                }
            }
        } catch (InterruptedException e) {
            LOGGER.error("pacer", e);
        }
    }

    public float cpuSpeed() {
        float timeDelta = timeAfter - timeBefore;
        float cyclesDelta = cyclesAfter - cyclesBefore;
        float milliTimePeriod = timeDelta * unlockTime / (unlockTime + sleepTime) / 1000000;
        LOGGER.info("Time delta: {}, Cycles delta {}", timeDelta, cyclesDelta);
        return cyclesDelta / milliTimePeriod;
    }

    public float throttleSpeed() {
        float timeDelta = timeAfter - timeBefore;
        float cyclesDelta = cyclesAfter - cyclesBefore;
        float milliTimePeriod = timeDelta / 1000000;
        return cyclesDelta / milliTimePeriod;
    }

    /**
     * Set throttling of the bus.
     */
    public void throttle(boolean throttling) {
        this.throttling = throttling;
        if (throttling) {
            unlockTime = 2;
            sleepTime = 10;
        } else {
            unlockTime = 1000;
            sleepTime = 0;
        }
    }

}
