package org.roug.usim.z80;

import org.roug.usim.Bus8Intel;
import org.roug.usim.MemorySegment;
import org.roug.usim.RandomAccessMemory;

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

    public void signalINT(boolean state) {
        inInterrupt = state;
        bus.signalINT(state);
    }

    /**
     * Get a value from the device that has interrupted the CPU.
     * This is typically an opcode.
     * @return the byte from the device.
     */
    public abstract int getInterruptValue();

} 
