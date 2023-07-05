package org.roug.usim.z80;

import java.util.concurrent.locks.ReentrantLock;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.roug.usim.BusMemoryOnly;
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

    /** Active INT requests. */
    private int activeINTs;

    private ReentrantLock lockObject = new ReentrantLock();

    /** Port memory space. */
    private DeviceZ80 ports;

    /** Register hierarchy of devices. */
    private DeviceZ80[] deviceHier = new DeviceZ80[256];
    private int numDevs;

    /** Set by the CPU when doing I/O operations. */
    private boolean activeIORQ;

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
     * Accept a signal on the INT pin. A device can raise the voltage on the INT
     * pin, which means the device sends an interrupt request. The CPU must then
     * set IORQ, and read a byte from the data bus. The device shall then lower the
     * interrupt.
     * If INTs are ignored when a device signals, then it must be received 
     * when INTs are accepted again (if the device hasn't lowered it).
     *
     * @param state - true if INT is raised from the device, false if INT is
     * lowered.
     */
    @Override
    public void signalINT(boolean state) {
        synchronized(this) {
            if (state) {
                activeINTs++;
                notifyAll();
            } else {
               activeINTs--;
            }
        }
    }

    /**
     * Do we have active INTs?
     */
    @Override
    public boolean isINTActive() {
        return activeINTs > 0;
    }

    /**
     * Reset the bus.
     */
    public void reset() {
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
    public int getDeviceValue() {
        int val = 0;

        for (int i = 0; i < numDevs; i++) {
            if (deviceHier[i].isInInterrupt()) {
                val = deviceHier[i].getInterruptValue();
                break;
            }
        }
        return val;
    }

    @Override
    public void cpuRETI() {
        for (int i = 0; i < numDevs; i++) {
            if (deviceHier[i].isInInterrupt()) {
                deviceHier[i].cpuRETI();
                break;
            }
        }
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
    public void addPortSegment(DeviceZ80 newMemory) {
        if (ports == null) {
            ports = newMemory;
        } else {
            ports.addMemorySegment(newMemory);
        }
        deviceHier[numDevs++] = newMemory;
    }

    /**
     * Install a ports segment as the first item of the list of segments.
     */
    @Override
    public void insertPortSegment(DeviceZ80 newMemory) {
        newMemory.insertMemorySegment(ports);
        ports = newMemory;
// FIXME
// Move the devices one slot down, then add device at top.
    }

}
