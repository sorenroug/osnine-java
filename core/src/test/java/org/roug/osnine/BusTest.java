package org.roug.osnine;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Test;

public class BusTest {

    boolean signalReceived = false;

//  @Test(expected = IllegalArgumentException.class)
//  public void oversizeMemoryBank() {
//      RandomAccessMemory mb = new RandomAccessMemory(70000);
//  }

    /**
     * Check that the cycle counter increments.
     */
    @Test
    public void checkCounterIncrements() {
        Bus8Motorola bus = new BusStraight();
        MemorySegment newMemory = new RandomAccessMemory(0, bus, "0x1000");
        bus.addMemorySegment(newMemory);

        long startCounter = bus.getCycleCounter();
        bus.read(0x0100);
        long nextCounter = bus.getCycleCounter();
        assertTrue(nextCounter > startCounter);
    }

    private void getASignal(boolean state) {
        signalReceived = true;
    }

    /**
     * Check that the callback works.
     */
    @Test
    public void checkCallMeBackLater() {
        Bus8Motorola bus = new BusStraight();
        MemorySegment newMemory = new RandomAccessMemory(0, bus, "0x1000");
        bus.addMemorySegment(newMemory);

        long startCounter = bus.getCycleCounter();
        PIASignal signalOut = (boolean state) -> getASignal(state);
        bus.callbackIn(2, signalOut);
        bus.read(0x0100);
        assertFalse(signalReceived);
        bus.write(0x0100, 0);
        assertTrue(signalReceived);
        bus.read(0x0100);
        assertTrue(signalReceived);
    }
}

