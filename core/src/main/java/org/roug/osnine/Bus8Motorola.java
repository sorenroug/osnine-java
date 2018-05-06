package org.roug.osnine;

/**
 * Bus in a computer - Motorola-style. Links CPU, memory and devices together.
 */
public interface Bus8Motorola {

    /**
     * Single byte read from memory.
     */
    int read(int offset);

    /**
     * Single byte write to memory.
     */
    void write(int offset, int val);

    /**
     * Install a memory segment as the last item of the list of segments.
     */
    void addMemorySegment(MemorySegment newMemory);

    /**
     * Install a memory segment as the first item of the list of segments.
     */
    void insertMemorySegment(MemorySegment newMemory);

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
     * @param state - true if IRQ is raised from the device, false if IRQ is
     * lowered.
     */
    void signalIRQ(boolean state);

    /**
     * Accept an FIRQ signal.
     */
    void signalFIRQ(boolean state);

    /**
     * Accept an NMI signal.
     */
    void signalNMI(boolean state);

    /**
     * Do we have active IRQs?
     */
    boolean isIRQActive();

    /**
     * Do we have active NMIs?
     */
    boolean isNMIActive();

    /**
     * Do we have active FIRQs?
     */
    boolean isFIRQActive();
}

