package org.roug.usim.z80;

import java.util.Timer;
import java.util.TimerTask;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;

public class HaltTest extends Framework {

    private static final int HALT = 0x76;

    /* 
    */
    @Test
    public void doHalt() throws InterruptedException {

        myTestCPU.registerSP.set(0x1002); // not used
        writeSeq(0x0B00, 0x00, HALT);
        runAndStop(0x0B00);
        assertEquals(0x0B02, myTestCPU.pc.get());
//         assertEquals(0x1000, myTestCPU.registerSP.get());
//         assertEquals(0x03, myTestCPU.read(0x1000));
//         assertEquals(0x0B, myTestCPU.read(0x1001));
    }

    /* LDIR - opcode 0xED, 0xB0
     * TODO: Test condition flags.
     */
    @Test
    public void testLDIR() throws InterruptedException {
        myTestCPU.registerHL.set(0x1111);
        writeSeq(0x1111, 0x88, 0x36, 0xA5, 0x55);
        writeSeq(0x0222, 0x66, 0x59, 0xC5, 0x33);
        myTestCPU.registerDE.set(0x0222);
        myTestCPU.registerBC.set(0x03);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0xED, 0xB0, HALT); // LDIR
        runAndStop(0x0B00);
        assertEquals(0x0B03, myTestCPU.pc.get());

        assertEquals(0x1114, myTestCPU.registerHL.get());
        assertEquals(0x0225, myTestCPU.registerDE.get());
        assertEquals(0x0000, myTestCPU.registerBC.get());
        assertEquals(0x88, myTestCPU.read(0x1111));
        assertEquals(0x88, myTestCPU.read(0x0222));
        assertEquals(0x36, myTestCPU.read(0x1112));
        assertEquals(0x36, myTestCPU.read(0x0223));
        assertEquals(0xA5, myTestCPU.read(0x1113));
        assertEquals(0xA5, myTestCPU.read(0x0224));

        assertEquals(0x55, myTestCPU.read(0x1114)); // Check that it halted correctly
        assertEquals(0x33, myTestCPU.read(0x0225)); // Check that it halted correctly
    }

    /* LDIR - opcode 0xED, 0xB8
     * TODO: Test condition flags.
     */
    @Test
    public void testLDDR() throws InterruptedException {
        myTestCPU.registerHL.set(0x1114);
        writeSeq(0x1111, 0x55, 0x88, 0x36, 0xA5, 0x55);
        writeSeq(0x0222, 0x33, 0x66, 0x59, 0xC5, 0x33);
        myTestCPU.registerDE.set(0x0225);
        myTestCPU.registerBC.set(0x03);
        myTestCPU.registerF.clear();
        writeSeq(0x0B00, 0xED, 0xB8, HALT); // LDDR
        runAndStop(0x0B00);
        assertEquals(0x0B03, myTestCPU.pc.get());

        assertEquals(0x1111, myTestCPU.registerHL.get());
        assertEquals(0x0222, myTestCPU.registerDE.get());
        assertEquals(0x0000, myTestCPU.registerBC.get());
        assertEquals(0x88, myTestCPU.read(0x1112));
        assertEquals(0x88, myTestCPU.read(0x0223));
        assertEquals(0x36, myTestCPU.read(0x1113));
        assertEquals(0x36, myTestCPU.read(0x0224));
        assertEquals(0xA5, myTestCPU.read(0x1114));
        assertEquals(0xA5, myTestCPU.read(0x0225));

        assertEquals(0x55, myTestCPU.read(0x1111)); // Check that it halted correctly
        assertEquals(0x33, myTestCPU.read(0x0222)); // Check that it halted correctly
    }

    /*
     * Create a new thread and run the CPU in it.
     * The sequence must end with HALT.
     */
    private void runAndStop(int startAddr) throws InterruptedException {
        myTestCPU.pc.set(startAddr);
        Thread cpuThread = new Thread(myTestCPU, "cpu");
        cpuThread.start();

        Timer timer = new Timer();
        SendStopRun irqTask = new SendStopRun();
        timer.schedule(irqTask, 100); // miliseconds

        cpuThread.join();
    }

    private class SendStopRun extends TimerTask {
        public void run() {
            myTestCPU.stopRun();
            myTestCPU.getBus().signalINT(true); // Execute a hardware interrupt
        }
    }

}
