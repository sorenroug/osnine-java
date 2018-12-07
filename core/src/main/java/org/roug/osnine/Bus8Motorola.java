package org.roug.osnine;

/**
 * Bus in a computer - Motorola-style. Links CPU, memory and devices together.
 */
public interface Bus8Motorola extends MemoryBus {

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
     *
     * @param state - true if IRQ is raised from the device, false if IRQ is
     * lowered.
     */
    void signalFIRQ(boolean state);

    /**
     * Accept an NMI signal.
     *
     * @param state - true if IRQ is raised from the device, false if IRQ is
     * lowered.
     */
    void signalNMI(boolean state);

    /**
     * Do we have active IRQs?
     *
     * @return true if there are active IRQs on the bus.
     */
    boolean isIRQActive();

    /**
     * Do we have active NMIs?
     *
     * @return true if there are active NMIs on the bus.
     */
    boolean isNMIActive();

    /**
     * Clear active NMIs as they are latched when the device IRQ changes
     * from low to high. If the NMI is not cleared then there would be
     * recursive interrupt handling.
     */
    void clearNMI();

    /**
     * Do we have active FIRQs?
     *
     * @return true if there are active FIRQs on the bus.
     */
    boolean isFIRQActive();

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
    void callbackIn(int cycles, Signal method);
}

