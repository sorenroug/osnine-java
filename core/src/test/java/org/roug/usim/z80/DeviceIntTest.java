package org.roug.usim.z80;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;
import org.roug.usim.z80.DeviceZ80;
import org.roug.usim.Bus8Intel;
import org.roug.usim.MemorySegment;
import org.roug.usim.RandomAccessMemory;

class SerialDev extends DeviceZ80 {

    private int byteInBuffer;

    /**
     * Constructor.
     *
     * @param start - First address location of the ACIA.
     * @param bus - The bus the ACIA is attached to.
     * @param args - additional arguments
     */
    public SerialDev(int start, Bus8Intel bus, String... args) {
        super(start, bus, args);
    }

    @Override
    protected int load(int addr) {
        return 0;
    }

    @Override
    protected void store(int addr, int val) {
    }

    public int getInterruptValue() {
        signalINT(false); // Only has one byte to send.
        return byteInBuffer;
    }

    void byteReceived(int c) {
        this.byteInBuffer = c;
        signalINT(true);
    }
}

public class DeviceIntTest extends Framework {

    /**
     * Imitate a serial port that sends an interrupt to deliver a byte.
     * Set Interrupt Mode 0
     * Enable interrupts
     * Jump to address 32.
     */
    @Test
    public void serialDevice() {
        Bus8Intel bus = myTestCPU.getBus();
        SerialDev device1 = new SerialDev(8, bus, "1");
        bus.addPortSegment(device1);

        myTestCPU.registerA.set(0xFF);

        // Set IM0, EI, NOP
        writeSeq(0x0B00, 0xED, 0x46, 0xFB, 0x00);
        execSeq(0xB00, 0xB02);
        execSeq(0xB02, 0xB03);
        //assertEquals(0x10, myTestCPU.registerA.get());
        // Make device send RST 32 instruction
        device1.byteReceived(0xE7);
        execSeq(0xB03, 0x20);
        // assertEquals(0xB03, myTestCPU.registerSP.get());

    }

}
