package org.roug.usim;

import java.util.concurrent.locks.ReentrantLock;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Straight-through bus with no memory management unit.
 */
public class BusMemoryOnly implements MemoryBus {

    private static final Logger LOGGER = LoggerFactory.getLogger(BusMemoryOnly.class);

    /** Memory space. */
    private MemorySegment memory;

    private long cycleCounter;

    /** The memory cycle that will trigger a call to the registered method. */
    private long methodTrigger = Long.MAX_VALUE;

    private BitReceiver registeredMethod;

    private ReentrantLock lockObject = new ReentrantLock();

    /**
     * Constructor.
     */
    public BusMemoryOnly() {
    }

    /**
     * Constructor: Create bus and allocate memory from address 0 and up.
     *
     * @param memorySize - The size of the memory.
     */
    public BusMemoryOnly(int memorySize) {
        this();
        allocate_memory(0, memorySize);
    }

    protected void updateCycle() {
        cycleCounter++;
        if (cycleCounter >= methodTrigger) {
            methodTrigger = Long.MAX_VALUE;
            registeredMethod.send(true);
        }
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

    @Override
    public void lock() {
        lockObject.lock();
    }

    @Override
    public void unlock() {
        lockObject.unlock();
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

    /**
     * Single byte force write to memory.
     */
    @Override
    public void forceWrite(int offset, int val) {
        memory.forceWrite(offset, val & 0xFF);
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

}
