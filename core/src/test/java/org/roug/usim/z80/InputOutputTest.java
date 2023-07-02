package org.roug.usim.z80;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;
import org.roug.usim.MemorySegment;
import org.roug.usim.RandomAccessMemory;

class DummyDev extends DeviceZ80 {

    private int byteInBuffer;

    /**
     * Constructor.
     *
     * @param start - First address location of the ACIA.
     * @param bus - The bus the ACIA is attached to.
     * @param args - additional arguments
     */
    public DummyDev(int start, Bus8Intel bus, String... args) {
        super(start, bus, args);
    }

    @Override
    protected int load(int addr) {
        return byteInBuffer;
    }

    @Override
    protected void store(int addr, int val) {
        this.byteInBuffer = val;
    }

    public int getInterruptValue() {
        return byteInBuffer;
    }

    void byteReceived(int c) {
    }
}

public class InputOutputTest extends Framework {

    /* IN A,(8)
     * Using a memory segment as a simple device.
     */
    @Test
    public void inAport8() {
        Bus8Intel bus = myTestCPU.getBus();
        DummyDev newMemory = new DummyDev(8, bus, "1");
        newMemory.write(8, 0x10);
        bus.addPortSegment(newMemory);

        myTestCPU.registerA.set(0xFF);
        writeSeq(0x0B00, 0xDB, 0x08);
        execSeq(0xB00, 0xB02);
        assertEquals(0x10, myTestCPU.registerA.get());
    }

    /* OUT (1),A
     * Using a memory segment as a simple device.
     */
    @Test
    public void outAport1() {
        Bus8Intel bus = myTestCPU.getBus();
        DummyDev newMemory = new DummyDev(1, bus, "1");
        myTestCPU.registerA.set(0x23);
        newMemory.write(1, 0x10); // Write dummy
        bus.addPortSegment(newMemory);

        writeSeq(0x0B00, 0xD3, 0x01);
        execSeq(0xB00, 0xB02);
        assertEquals(0x23, myTestCPU.registerA.get());
        assertEquals(0x23, newMemory.read(1));
    }

    /* INI
     * Using a memory segment as a simple device.
     */
    @Test
    public void testINI() {
        int portLoc = 0x07;
        Bus8Intel bus = myTestCPU.getBus();
        DummyDev newMemory = new DummyDev(portLoc, bus, "1");
        newMemory.write(portLoc, 0x7B);
        bus.addPortSegment(newMemory);

        myTestCPU.registerC.set(portLoc);
        myTestCPU.registerB.set(0x10);
        myTestCPU.registerHL.set(0x1000);
        writeSeq(0x0B00, 0xED, 0xA2);
        execSeq(0xB00, 0xB02);
        assertEquals(portLoc, myTestCPU.registerC.get());
        assertEquals(0x7B, myTestCPU.read(0x1000));
        assertEquals(0x1001, myTestCPU.registerHL.get());
        assertEquals(0x0F, myTestCPU.registerB.get());
        assertTrue(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetZ());
    }

    /* INIR - opcode 0xED, 0xB2
     */
    @Test
    public void testINIR() {
        int portLoc = 0x07;
        Bus8Intel bus = myTestCPU.getBus();
        DummyDev newMemory = new DummyDev(portLoc, bus, "1");
        newMemory.write(portLoc, 0x7B);
        bus.addPortSegment(newMemory);

        myTestCPU.registerC.set(portLoc);
        myTestCPU.registerB.set(0x02);
        myTestCPU.registerHL.set(0x1000);
        writeSeq(0x0B00, 0xED, 0xB2); // INIR
        execSeq(0xB00, 0xB00);
        assertEquals(portLoc, myTestCPU.registerC.get());
        assertEquals(0x7B, myTestCPU.read(0x1000));
        assertEquals(0x1001, myTestCPU.registerHL.get());
        assertEquals(0x01, myTestCPU.registerB.get());
        assertTrue(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetZ());

        // Test with register B = 1
        execSeq(0xB00, 0xB02);
        assertEquals(0x7B, myTestCPU.read(0x1001));
        assertEquals(0x1002, myTestCPU.registerHL.get());
        assertEquals(0x00, myTestCPU.registerB.get());
        assertTrue(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetZ());
    }

    /* IND - opcode 0xED, 0xAA.
     * Using a memory segment as a simple device.
     */
    @Test
    public void testIND() {
        int portLoc = 0x07;
        Bus8Intel bus = myTestCPU.getBus();
        DummyDev newMemory = new DummyDev(portLoc, bus, "1");
        newMemory.write(portLoc, 0x7B);
        bus.addPortSegment(newMemory);

        myTestCPU.registerC.set(portLoc);
        myTestCPU.registerB.set(0x10);
        myTestCPU.registerHL.set(0x1000);
        writeSeq(0x0B00, 0xED, 0xAA);
        execSeq(0xB00, 0xB02);
        assertEquals(portLoc, myTestCPU.registerC.get());
        assertEquals(0x7B, myTestCPU.read(0x1000));
        assertEquals(0x0FFF, myTestCPU.registerHL.get());
        assertEquals(0x0F, myTestCPU.registerB.get());
        assertTrue(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetZ());
    }

    /* INDR - opcode 0xED, 0xBA
     */
    @Test
    public void testINDR() {
        int portLoc = 0x07;
        Bus8Intel bus = myTestCPU.getBus();
        DummyDev newMemory = new DummyDev(portLoc, bus, "1");
        newMemory.write(portLoc, 0x7B);
        bus.addPortSegment(newMemory);

        myTestCPU.registerC.set(portLoc);
        myTestCPU.registerB.set(0x02);
        myTestCPU.registerHL.set(0x1000);
        writeSeq(0x0B00, 0xED, 0xBA); // INDR
        execSeq(0xB00, 0xB00);
        assertEquals(portLoc, myTestCPU.registerC.get());
        assertEquals(0x7B, myTestCPU.read(0x1000));
        assertEquals(0x0FFF, myTestCPU.registerHL.get());
        assertEquals(0x01, myTestCPU.registerB.get());
        assertTrue(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetZ());

        // Test with register B = 1
        execSeq(0xB00, 0xB02);
        assertEquals(0x7B, myTestCPU.read(0x0FFF));
        assertEquals(0x0FFE, myTestCPU.registerHL.get());
        assertEquals(0x00, myTestCPU.registerB.get());
        assertTrue(myTestCPU.registerF.isSetN());
        assertTrue(myTestCPU.registerF.isSetZ());
    }

    /* OUTI - opcode 0xED, 0xA3
     * Using a memory segment as a simple device.
     */
    @Test
    public void testOUTI() {
        int portLoc = 0x07;
        Bus8Intel bus = myTestCPU.getBus();
        DummyDev newMemory = new DummyDev(portLoc, bus, "1");
        newMemory.write(portLoc, 0x99); // Dummy data
        bus.addPortSegment(newMemory);

        myTestCPU.registerC.set(portLoc);
        myTestCPU.registerB.set(0x10);
        myTestCPU.registerHL.set(0x1000);
        myTestCPU.write(0x1000, 0x59);

        writeSeq(0x0B00, 0xED, 0xA3);
        execSeq(0xB00, 0xB02);
        assertEquals(portLoc, myTestCPU.registerC.get());
        assertEquals(0x59, newMemory.read(portLoc));
        assertEquals(0x1001, myTestCPU.registerHL.get());
        assertEquals(0x0F, myTestCPU.registerB.get());
        assertTrue(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetZ());
    }

    /* OUTD - opcode 0xED, 0xAB
     * Using a memory segment as a simple device.
     */
    @Test
    public void testOUTD() {
        int portLoc = 0x07;
        Bus8Intel bus = myTestCPU.getBus();
        DummyDev newMemory = new DummyDev(portLoc, bus, "1");
        newMemory.write(portLoc, 0x99); // Dummy data
        bus.addPortSegment(newMemory);

        myTestCPU.registerC.set(portLoc);
        myTestCPU.registerB.set(0x10);
        myTestCPU.registerHL.set(0x1000);
        myTestCPU.write(0x1000, 0x59);

        writeSeq(0x0B00, 0xED, 0xAB);
        execSeq(0xB00, 0xB02);
        assertEquals(portLoc, myTestCPU.registerC.get());
        assertEquals(0x59, newMemory.read(portLoc));
        assertEquals(0x0FFF, myTestCPU.registerHL.get());
        assertEquals(0x0F, myTestCPU.registerB.get());
        assertTrue(myTestCPU.registerF.isSetN());
        assertFalse(myTestCPU.registerF.isSetZ());
    }

}
