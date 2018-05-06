package org.roug.osnine;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Straight-through bus with no memory management unit.
 */
public class BusStraight implements Bus6809 {

    private static final Logger LOGGER = LoggerFactory.getLogger(BusStraight.class);

    /** Memory space. */
    private MemorySegment memory;

    /** Active NMI signals. */
    private int activeNMIs;

    /** Active IRQ requests. */
    private int activeIRQs;

    /** Active FIRQ requests. */
    private int activeFIRQs;

    /**
     * Constructor.
     */
    public BusStraight() {
    }

    /**
     * Constructor: Allocate memory.
     */
    public BusStraight(int memorySize) {
        this();
        allocate_memory(0, memorySize);
    }

    /**
     * Single byte read from memory.
     */
    public int read(int offset) {
        return memory.read(offset);
    }

    /**
     * Single byte write to memory.
     */
    public void write(int offset, int val) {
        memory.write(offset, val & 0xFF);
    }

    /**
     * Accept an NMI signal.
     */
    public synchronized void signalNMI(boolean state) {
        if (state) {
            activeNMIs++;
            notifyAll();
        } else {
            activeNMIs--;
        }
    }

    /**
     * Do we have active NMIs?
     */
    public boolean isNMIActive() {
        return activeNMIs > 0;
    }

    /**
     * Accept an FIRQ signal.
     */
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
        MemorySegment newMemory = new RAMMemory(start, memorySize);
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
        newMemory.nextSegment = memory;
        memory = newMemory;
    }

}

