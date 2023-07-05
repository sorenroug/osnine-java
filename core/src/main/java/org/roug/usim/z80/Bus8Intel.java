package org.roug.usim.z80;
import org.roug.usim.BitReceiver;
import org.roug.usim.MemoryBus;

/**
 * Bus in a computer - Intel-style. Links CPU, memory and devices together.
 */
public interface Bus8Intel extends MemoryBus {

    /**
     * Accept a signal on the INT pin. A device can raise the voltage on the INT
     * pin, which means the device sends an interrupt request. The CPU must then
     * check the devices and get the device to lower the signal again.
     * In this implementation, the signals from several devices are ORed
     * together to the same pin on the CPU. Since this can't easily be emulated,
     * it is the responsibility of the device that it doesn't raise INT twice
     * in a row.
     * If INTs are ignored when a device signals, then it must be received
     * when INTs are accepted again (if the device hasn't lowered it).
     *
     * @param state - true if INT is raised from the device, false if INT is
     * lowered.
     */
    void signalINT(boolean state);

    /**
     * Accept an NMI signal.
     *
     * @param state - true if INT is raised from the device, false if INT is
     * lowered.
     */
    void signalNMI(boolean state);

    /**
     * Do we have active INTs?
     *
     * @return true if there are active INTs on the bus.
     */
    boolean isINTActive();

    /**
     * Do we have active NMIs?
     *
     * @return true if there are active NMIs on the bus.
     */
    boolean isNMIActive();

    /**
     * Clear active NMIs as they are latched when the device INT changes
     * from low to high. If the NMI is not cleared then there would be
     * recursive interrupt handling.
     */
    void clearNMI();

    /**
     * Get the number of read/writes to bus since the start.
     *
     * @return the number of cycles.
     */
    long getCycleCounter();

    /**
     * Ask the bus to call a given method when the number of
     * read/write operations has reached given number.
     *
     * @param cycles - the number of cycles to trigger at
     * @param method - the operation to call.
     */
    void callbackIn(int cycles, BitReceiver method);

    void lock();
    void unlock();

    /**
     * Single byte read from I/O port map.
     *
     * @param offset - port number 0-255
     * @return value of read operation
     */
    int readIO(int offset);

    /**
     * Single byte write to I/O port map.
     *
     * @param offset - port number 0-255
     * @param val - one-byte value to write
     */
    void writeIO(int offset, int val);

    /**
     * Single byte read from interrupting device.
     *
     * @return value of read operation
     */
    int getDeviceValue();

    /**
     * Signal to first device in interrupt that the CPU did a RETI instruction.
     */
    void cpuRETI();

    /**
     * Add device to ports table as the last priority.
     */
    void addPortSegment(DeviceZ80 newMemory);

    /**
     * Add device to ports table as the first priority.
     */
    void insertPortSegment(DeviceZ80 newMemory);

}

