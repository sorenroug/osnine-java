package org.roug.osnine.os9;

import java.io.IOException;
import static org.junit.Assert.assertEquals;
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
        cpu.loadmodule("dummymodule.mod", "\r");
    }
}
