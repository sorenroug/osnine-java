package org.roug.osnine;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Slows down the CPU to the original speed by locking/unlocking the bus.
 */
public class Pacer implements Runnable {

    private static final Logger LOGGER = LoggerFactory.getLogger(Pacer.class);

    private static final int LOCK_GRANULARITY = 10;

    private Bus8Motorola bus;

    private long cyclesBefore, cyclesAfter;
    private long timeBefore, timeAfter;

    /** True if throttling the speed. */
    private boolean throttling = false;

    private int sleepTime = 1000;

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
                    Thread.sleep(sleepTime); // Let the CPU run
                    bus.lock();
                    try {
                        Thread.sleep(LOCK_GRANULARITY);  // The CPU is halted
                    } finally {
                        bus.unlock();
                    }
                } else {
                    Thread.sleep(sleepTime);
                }
            }
        } catch (InterruptedException e) {
            LOGGER.error("pacer", e);
        }
    }

    public long cpuSpeed() {
        long timeDelta = timeAfter - timeBefore;
        long cyclesDelta = cyclesAfter - cyclesBefore;
        long milliTimeDelta = timeDelta / sleepTime / 1000;
        return cyclesDelta / milliTimeDelta;
    }

    /**
     * Set throttling of the bus.
     */
    public void throttle(boolean throttling) {
        this.throttling = throttling;
        if (throttling) sleepTime = 10;
        else sleepTime = 1000;
    }

}
