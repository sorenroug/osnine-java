package org.roug.osnine;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;

public class BusTest {

    int signalReceived = 0;

    Bus8Motorola bus;

//  @Test(expected = IllegalArgumentException.class)
//  public void oversizeMemoryBank() {
//      RandomAccessMemory mb = new RandomAccessMemory(70000);
//  }

    @Before
    public void setup() {
        bus = new BusStraight();
        MemorySegment newMemory = new RandomAccessMemory(0, bus, "0x1000");
        bus.addMemorySegment(newMemory);
    }

    /**
     * Check that the cycle counter increments.
     */
    @Test
    public void checkCounterIncrements() {
        long startCounter = bus.getCycleCounter();
        bus.read(0x0100);
        long nextCounter = bus.getCycleCounter();
        assertTrue(nextCounter > startCounter);
    }

    private void getASignal(boolean state) {
        signalReceived++;
    }

    /**
     * Check that the callback works.
     */
    @Test
    public void checkCallMeBackLater() {
        Signal signalOut = (boolean state) -> getASignal(state);
        bus.callbackIn(2, signalOut);
        bus.read(0x0100);
        assertEquals(0, signalReceived);
        bus.write(0x0100, 0);
        assertEquals(1, signalReceived);
        bus.read(0x0100);
        assertEquals(1, signalReceived);
    }


    /**
     * Check that the callback can set another callback while in the call.
     */
    @Test
    public void recursiveCallback() {
        long startCounter = bus.getCycleCounter();
        Signal signalOut = (boolean state) -> getAndSetCallback(state);
        bus.callbackIn(2, signalOut);
        bus.read(0x0100);
        assertEquals(0, signalReceived);
        bus.write(0x0100, 0);
        assertEquals(1, signalReceived);
        bus.read(0x0100);
        assertEquals(1, signalReceived);
        bus.read(0x0100);
        assertEquals(2, signalReceived);
    }

    private void getAndSetCallback(boolean dummystate) {
        signalReceived++;
        Signal signalOut = (boolean state) -> getASignal(state);
        bus.callbackIn(2, signalOut);
    }

}

