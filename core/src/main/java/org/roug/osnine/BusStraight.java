package org.roug.osnine;

import java.util.concurrent.locks.ReentrantLock;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Straight-through bus with no memory management unit.
 */
public class BusStraight implements Bus8Motorola {

    private static final Logger LOGGER = LoggerFactory.getLogger(BusStraight.class);

    /** Memory space. */
    private MemorySegment memory;

    /** Active NMI signals. */
    private int activeNMIs;

    /** Active IRQ requests. */
    private int activeIRQs;

    /** Active FIRQ requests. */
    private int activeFIRQs;

    private long cycleCounter;

    /** The memory cycle that will trigger a call to the registered method. */
    private long methodTrigger = Long.MAX_VALUE;

    private BitReceiver registeredMethod;

    private ReentrantLock lockObject = new ReentrantLock();

    /**
     * Constructor.
     */
    public BusStraight() {
    }

    /**
     * Constructor: Create bus and allocate memory from address 0 and up.
     *
     * @param memorySize - The size of the memory.
     */
    public BusStraight(int memorySize) {
        this();
        allocate_memory(0, memorySize);
    }

    private void updateCycle() {
        cycleCounter++;
        if (cycleCounter >= methodTrigger) {
            methodTrigger = Long.MAX_VALUE;
            registeredMethod.send(true);
        }
    }

    /**
     * Single byte read from memory.
     */
    @Override
    public int read(int offset) {
        int val;
        lockObject.lock();
        try {
            val = memory.read(offset);
        } finally {
            lockObject.unlock();
        }
        updateCycle();
        return val;
    }

    /**
     * Single byte write to memory.
     */
    @Override
    public void write(int offset, int val) {
        lockObject.lock();
        try {
            memory.write(offset, val & 0xFF);
        } finally {
            lockObject.unlock();
        }
        updateCycle();
    }

    @Override
    public void lock() {
        lockObject.lock();
    }

    @Override
    public void unlock() {
        lockObject.unlock();
    }

    /**
     * Single byte force write to memory.
     */
    @Override
    public void forceWrite(int offset, int val) {
        memory.forceWrite(offset, val & 0xFF);
    }

    /**
     * Accept an NMI signal.
     */
    @Override
    public synchronized void signalNMI(boolean state) {
        if (state) {
            activeNMIs++;
            notifyAll();
        } else {
            if (activeNMIs > 0) activeNMIs--;
        }
    }

    @Override
    public synchronized void clearNMI() {
        activeNMIs = 0;
    }

    /**
     * Do we have active NMIs?
     */
    @Override
    public boolean isNMIActive() {
        return activeNMIs > 0;
    }

    /**
     * Accept an FIRQ signal.
     */
    @Override
    public void signalFIRQ(boolean state) {
        synchronized(this) {
            if (state) {
                activeFIRQs++;
                notifyAll();
            } else {
                activeFIRQs--;
            }
        }
    }

    /**
     * Do we have active FIRQs?
     */
    @Override
    public boolean isFIRQActive() {
        return activeFIRQs > 0;
    }

    /**
     * Accept a signal on the IRQ pin. A device can raise the voltage on the IRQ
     * pin, which means the device sends an interrupt request. The CPU must then
     * check the devices and get the device to lower the signal again.
     * In this implementation, the signals from several devices are ORed
     * together to the same pin on the CPU. Since this can't easily be emulated,
     * it is the responsibility of the device that it doesn't raise IRQ twice
     * in a row.
     * If IRQs are ignored when a device signals, then it must be received 
     * when IRQs are accepted again (if the device hasn't lowered it).
     *
     * NOTE: The ORing logic should be move to a memory-bus class, so it can
     * be replaced for different hardware emulations.
     *
     * @param state - true if IRQ is raised from the device, false if IRQ is
     * lowered.
     */
    @Override
    public void signalIRQ(boolean state) {
        synchronized(this) {
            if (state) {
                activeIRQs++;
                notifyAll();
            } else {
               activeIRQs--;
            }
        }
    }

    /**
     * Do we have active IRQs?
     */
    @Override
    public boolean isIRQActive() {
        return activeIRQs > 0;
    }

    /**
     * Reset the bus.
     */
    public void reset() {
    }


    private void allocate_memory(int start, int memorySize) {
        MemorySegment newMemory = new RandomAccessMemory(start, this, Integer.toString(memorySize));
        addMemorySegment(newMemory);
    }

    /**
     * Install a memory segment as the last item of the list of segments.
     */
    @Override
    public void addMemorySegment(MemorySegment newMemory) {
        if (memory == null) {
            memory = newMemory;
        } else {
            memory.addMemorySegment(newMemory);
        }
    }

    /**
     * Install a memory segment as the first item of the list of segments.
     */
    @Override
    public void insertMemorySegment(MemorySegment newMemory) {
        newMemory.insertMemorySegment(memory);
        memory = newMemory;
    }

    @Override
    public long getCycleCounter() {
        return cycleCounter;
    }

    @Override
    public void callbackIn(int cycles, BitReceiver method) {
        LOGGER.debug("callbackIn: {}: {}", cycles, method);
        registeredMethod = method;
        methodTrigger = cycleCounter + cycles;
    }

}

