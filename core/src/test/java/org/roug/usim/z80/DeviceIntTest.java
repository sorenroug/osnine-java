package org.roug.usim.z80;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;
import org.roug.usim.z80.DeviceZ80;
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

    /**
     * Imitate a serial port that sends an interrupt to deliver a byte.
     * Any value set by the device is ignored here.
     * Set Interrupt Mode 1 (ED, 56)
     * Enable interrupts (FB)
     * Jump to address 56.
     */
    @Test
    public void modeOne1Device() {
        Bus8Intel bus = myTestCPU.getBus();
        SerialDev device1 = new SerialDev(8, bus, "1");
        bus.addPortSegment(device1);

        myTestCPU.registerSP.set(0xA00);
        writeSeq(0x0B00, 0xED, 0x56, 0xFB, 0x00); // Set IM1, EI, NOP
        execSeq(0xB00, 0xB02);
        execSeq(0xB02, 0xB03);
        // Make device send RST 56 instruction
        device1.byteReceived(0xE7);
        execSeq(0xB03, 0x38);
    }

    /**
     * Imitate a second serial port that sends an interrupt to deliver a byte.
     * This device is second in chain.
     * Set Interrupt Mode 1 (0xED, 0x56)
     * Enable interrupts (0xFB)
     * Jump to address 56.
     * Enable interrupts, RETI (ED 4D)
     */
    @Test
    public void modeOne2Devices() {
        Bus8Intel bus = myTestCPU.getBus();
        SerialDev device1 = new SerialDev(8, bus, "1");
        bus.addPortSegment(device1);
        SerialDev device2 = new SerialDev(18, bus, "1");
        bus.addPortSegment(device2);

        myTestCPU.registerSP.set(0xA00);
        writeSeq(0x0B00, 0xED, 0x56, 0xFB, 0x00, 0x00); // IM1, EI, NOP, NOP
        writeSeq(0x0038, 0xFB, 0xED, 0x4D);  // EI, RETI
        execSeq(0xB00, 0xB02); // Exec IM1
        execSeq(0xB02, 0xB03); // Exec EI

        device2.byteReceived(0xE7); // Make device send RST 56 instruction
        execSeq(0xB03, 0x0038); // Exec NOP
        assertEquals(0x9FE, myTestCPU.registerSP.get());
        execSeq(0x0038, 0x0039); // Execute EI
        execSeq(0x0039, 0xB04); // Exec RETI
        assertFalse(device2.isInInterrupt());
        assertEquals(0xA00, myTestCPU.registerSP.get());
    }

    /**
     * Test that Enable Interrupt is delayed so an RETI.
     * can run.
     */
    @Test
    public void delayedEI() {
        Bus8Intel bus = myTestCPU.getBus();
        SerialDev device1 = new SerialDev(8, bus, "1");
        bus.addPortSegment(device1);
        device1.byteReceived(0xE7);  // Assert Interrupt

        myTestCPU.write_word(0xA00, 0x0345); // Return address
        myTestCPU.write_word(0x0345, 0x0000); // Two nops
        myTestCPU.registerSP.set(0xA00);
        writeSeq(0x0B00, 0xED, 0x56, 0xED, 0x4D); // EI, RETI
        execSeq(0xB00, 0x0B02);
        execSeq(0xB02, 0x0345);  // Pop address of stack.
        execSeq(0x0345, 0x0346); // Execute a NOP without interrupt.
        assertEquals(0xA02, myTestCPU.registerSP.get());

    }
}
