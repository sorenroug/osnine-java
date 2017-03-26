package org.roug.osnine.os9;

import java.io.IOException;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import org.junit.Test;

/**
 * Test loading of files into memory.
 */
public class LoadTest {

    /**
     * Load module.
     */
    @Test
    public void loadDummyMod() {
        OS9 cpu = new OS9();
        String driveLocation = System.getProperty("outputDirectory");
        cpu.setDebugCalls(1);
        cpu.addDevice(new DevUnix("/dd", driveLocation)); // Default drive
        cpu.setInitialCXD("/dd");
        assertFalse(cpu.cc.isSetC());
        cpu.loadmodule("progmodule");
        if (cpu.cc.isSetC()) {
            System.out.println(Util.getErrorMessage(cpu.b.intValue()));
        }
        assertFalse(cpu.cc.isSetC());
    }

    /**
     * Load module.
     */
    @Test
    public void loadMFree() {
        OS9 cpu = new OS9();
        String driveLocation = System.getProperty("outputDirectory");
        cpu.setDebugCalls(1);
        cpu.addDevice(new DevUnix("/dd", driveLocation)); // Default drive
        cpu.setInitialCXD("/dd/cmds");
        assertFalse(cpu.cc.isSetC());
        cpu.loadmodule("mfree");
        if (cpu.cc.isSetC()) {
            System.out.println(Util.getErrorMessage(cpu.b.intValue()));
        }
        assertFalse(cpu.cc.isSetC());
        //cpu.run();
    }

    /**
     * Load module and check argument.
     */
    @Test
    public void loadDummyModWithArgs() {
        OS9 cpu = new OS9();
        String driveLocation = System.getProperty("outputDirectory");
        cpu.setDebugCalls(1);
        cpu.addDevice(new DevUnix("/dd", driveLocation)); // Default drive
        cpu.setInitialCXD("/dd");
        assertFalse(cpu.cc.isSetC());
        cpu.loadmodule("progmodule", "THIS IS THE ARGUMENT");
        if (cpu.cc.isSetC()) {
            System.out.println(Util.getErrorMessage(cpu.b.intValue()));
        }
        assertFalse(cpu.cc.isSetC());
        int firstLetter = cpu.read(cpu.x.intValue());
        assertEquals((int)'T', firstLetter);
    }

}
