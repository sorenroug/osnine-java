package org.roug.usim.z80;

import java.util.concurrent.locks.ReentrantLock;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.roug.usim.BusMemoryOnly;
import org.roug.usim.Bus8Intel;
import org.roug.usim.MemorySegment;

/**
 * Straight-through bus with no memory management unit.
 */
public class BusZ80
        extends BusMemoryOnly
        implements Bus8Intel {

    private static final Logger LOGGER = LoggerFactory.getLogger(BusZ80.class);

    /** Active NMI signals. */
    private int activeNMIs;

    /** Active IRQ requests. */
    private int activeIRQs;

    private ReentrantLock lockObject = new ReentrantLock();

    /** Port memory space. */
    private MemorySegment ports;

    /** Set by the CPU when doing I/O operations. */
    private boolean activeIORQ;

    /** Set by the CPU when handling interrupt in mode 0 and 2. */
    private boolean interruptAck;

    /**
     * Constructor.
     */
    public BusZ80() {
    }

    /**
     * Constructor: Create bus and allocate memory from address 0 and up.
     *
     * @param memorySize - The size of the memory.
     */
    public BusZ80(int memorySize) {
        super(memorySize);
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



    /* Currently unused. */
    public void ackInterrupt(boolean state) {
        interruptAck = state;
    }

    /* Currently unused. */
    public void setIORQ(boolean state) {
        activeIORQ = state;
    }

    @Override
    public int readIO(int offset) {
        int val;
        lockObject.lock();
        try {
            val = ports.read(offset & 0xFF);
        } finally {
            lockObject.unlock();
        }
        updateCycle();
        return val;
    }

    @Override
    public void writeIO(int offset, int val) {
        lockObject.lock();
        try {
            ports.write(offset & 0xFF, val & 0xFF);
        } finally {
            lockObject.unlock();
        }
        updateCycle();
    }

    /**
     * Install a ports segment as the last item of the list of segments.
     */
    @Override
    public void addPortSegment(MemorySegment newMemory) {
        if (ports == null) {
            ports = newMemory;
        } else {
            ports.addMemorySegment(newMemory);
        }
    }

    /**
     * Install a ports segment as the first item of the list of segments.
     */
    @Override
    public void insertPortSegment(MemorySegment newMemory) {
        newMemory.insertMemorySegment(ports);
        ports = newMemory;
    }

}
