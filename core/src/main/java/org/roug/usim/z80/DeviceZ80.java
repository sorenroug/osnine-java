package org.roug.usim.z80;

import org.roug.usim.MemorySegment;

public abstract class DeviceZ80 extends MemorySegment {

    /** Reference to CPU for the purpose of sending IRQ. */
    private Bus8Intel bus;

    private boolean inInterrupt;

    /**
     * Constructor.
     *
     * @param start - First address location of the ACIA.
     * @param bus - The bus the ACIA is attached to.
     * @param args - additional arguments
     */
    public DeviceZ80(int start, Bus8Intel bus, String... args) {
        super(start, start + 1);
        this.bus = bus;
    }

    /**
     * Ask the device if it has made an interrupt.
     *
     * @return true if the device has made the interrupt.
     */
    public boolean isInInterrupt() {
        return inInterrupt;
    }

    /**
      * Raise or lower interrupt signal to the bus.
      *
      * @param state - true for raising interrupt.
      */
    public void signalINT(boolean state) {
        inInterrupt = state;
        bus.signalINT(state);
    }

    /**
     * Be notified if the CPU has done a RETI instruction.
     */
    public void cpuRETI() {
        signalINT(false); // Default action
    }

    /**
     * Get a value from the device that has interrupted the CPU.
     * This is typically an opcode.
     *
     * @return the byte from the device.
     */
    public abstract int getInterruptValue();

} 
