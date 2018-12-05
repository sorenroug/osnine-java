package org.roug.osnine.mo5;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;
import org.roug.osnine.Bus8Motorola;
import org.roug.osnine.BusStraight;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;



class TapeMock implements TapeListener {

    public boolean readyState;

    public void tapestationSignal(boolean state) {
        readyState = state;
    }
}

public class CassetteRecorderTest {

    private File getResourceFile(String filename) throws URISyntaxException {
        return new File(CassetteRecorderTest.class.getClassLoader().getResource(filename).toURI());
    }

    /**
     * Load a tape for play.
     */
    @Test
    public void loadForPlay() throws Exception {
        Bus8Motorola bus = new BusStraight();
        TapeMock tape = new TapeMock();
        CassetteRecorder cassette = new CassetteRecorder(bus, tape);
        assertFalse(tape.readyState);
        cassette.loadForPlay(getResourceFile("cassettetest.out"));
        assertTrue(tape.readyState);
        cassette.unloadCassetteFile();
        assertFalse(tape.readyState);

    }
}
