package org.roug.osnine.mo5;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;
import org.roug.usim.Bus8Motorola;
import org.roug.usim.BusStraight;
import org.roug.usim.BitReceiver;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;


public class TapeRecorderTest {

    class TapeMock implements BitReceiver {

        public boolean readyState;

        public void send(boolean state) {
            readyState = state;
        }
    }


    private File getResourceFile(String filename) throws URISyntaxException {
        return new File(TapeRecorderTest.class.getClassLoader().getResource(filename).toURI());
    }

    /**
     * Load a tape for play.
     *
     * @throws Exception if there is an I/O error
     */
    @Test
    public void loadForPlay() throws Exception {
        Bus8Motorola bus = new BusStraight();
        TapeMock tape = new TapeMock();
        TapeRecorder cassette = new TapeRecorder(bus);
        cassette.setReceiver(tape);
        assertFalse(tape.readyState);
        cassette.loadForPlay(getResourceFile("cassettetest.out"));
        assertTrue(tape.readyState);
        cassette.unloadCassetteFile();
        assertFalse(tape.readyState);
    }

    /**
     * Load a tape for record and record something.
     *
     * @throws Exception if there is an I/O error
     */
    @Test
    public void loadForRecord() throws Exception {
        File tmpFile;
        Bus8Motorola bus = new BusStraight(0x200);
        TapeMock tape = new TapeMock();
        TapeRecorder cassette = new TapeRecorder(bus);
        cassette.setReceiver(tape);
        assertFalse(tape.readyState);
        tmpFile = new File("tmp.out");
        cassette.loadForRecord(tmpFile, false);
        assertTrue(tape.readyState);
        cassette.cassetteMotor(true); // Turn on motor
        for (int i = 0; i < 100; i++) bus.read(0x0100); // Wait 100 cycles
        cassette.writeToCassette(false);
        cassette.cassetteMotor(false); // Turn off motor
        cassette.unloadCassetteFile();
        assertFalse(tape.readyState);
        tmpFile.delete();
    }

    @Test
    public void startWithoutTape() {
        Bus8Motorola bus = new BusStraight(0x200);
        TapeMock tape = new TapeMock();
        TapeRecorder cassette = new TapeRecorder(bus);
        cassette.setReceiver(tape);
        assertFalse(tape.readyState);
        cassette.cassetteMotor(true); // Turn on motor
        assertFalse(tape.readyState);
    }
}
