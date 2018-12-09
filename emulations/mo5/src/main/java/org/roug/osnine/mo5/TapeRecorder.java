package org.roug.osnine.mo5;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import org.roug.osnine.Bus8Motorola;
import org.roug.osnine.Signal;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class TapeRecorder {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(TapeRecorder.class);

    //private static final int VALUEBIT = 0x4000;
    private static final int VALUEBIT = 0x40000000;
    private static final int LENGTH_MASK = VALUEBIT - 1;

    private Signal listener;

    private Bus8Motorola bus;

    /** Number of cycles since last callback. */
    private long lastCounter;

    /** File for cassette storage. */
    private RandomAccessFile cassetteStream;

    private boolean cassetteBit;

    private Signal callback;

    /** File name of cassette file. */
    private File cassetteFilename;

    /** Determines if the recording or play button is pressed. */
    private boolean recording;

    private boolean motorOn;

    /**
     * Constructor.
     */
    TapeRecorder(Bus8Motorola bus) {
        this.bus = bus;
    }

    /**
     * Load a tape and press the Record button. Tape will not move
     * until the computer starts the motor.
     */
    public void loadForRecord(File filename) throws Exception {
        loadCassetteFile(filename);
        recording = true;
    }

    public void loadForPlay(File filename) throws Exception {
        loadCassetteFile(filename);
        recording = false;
    }

    /**
     * Open a file to emulate that the cassette recorder is loaded with a tape.
     */
    private void loadCassetteFile(File filename) throws Exception {
        if (cassetteStream != null) unloadCassetteFile();
        cassetteFilename = filename;
        cassetteStream = new RandomAccessFile(filename, "rw");
        tapestationReady(true);
    }

    public void unloadCassetteFile() {
        try {
            tapestationReady(false);
            cassetteStream.close();
            cassetteStream = null;
        } catch (IOException e) {
            cassetteStream = null;
        }
    }

    /**
     * Set the callback to receive the bit from tape.
     */
    public void setReceiver(Signal receiver) {
        listener = receiver;
    }

    /**
     * Tell the computer that 'Play' or 'Record' is activated or deactivated.
     * @param newstate - true if button is pressed.
     */
    private void tapestationReady(boolean newstate) {
        listener.send(newstate);
    }

    /**
     * Start/stop cassette motor. This is a signal from the computer.
     * If the tape device is set to "play" then start sending bits to line 7.
     *
     * @param state - if true, then turn motor off, otherwise turn on motor.
     */
    public void cassetteMotor(boolean state) {
        if (state) {
            LOGGER.debug("Turning motor off");
            if (recording)
                writeCode(true, 20000);
            motorOn = false;
        } else {
            motorOn = true;
            lastCounter = bus.getCycleCounter();
            LOGGER.debug("Turning motor on for {}", recording?"record":"playback");

            if (!recording) {
                tapestationReady(true);
                callback = (boolean dummystate) -> feedLine7(dummystate);
                bus.callbackIn(0x2000, callback);
            }
        }
    }

    /**
     * Load bit 7 in peripheral register A to load data into cassette port.
     * Called on a delay from the bus.
     */
    private void feedLine7(boolean newstate) {
        tapestationReady(cassetteBit);
        if (!motorOn) return;
        try {
            int code = readCode();
            cassetteBit = isBitOn(code, VALUEBIT);
            int delay = code & LENGTH_MASK;
            LOGGER.debug("Read {}, delay {}", cassetteBit, delay);
            callback = (boolean state) -> feedLine7(state);
            bus.callbackIn(delay, callback);
        } catch (IOException e) {
            LOGGER.debug("End of tape");
            tapestationReady(false);
        }
    }

    /**
     * Rewind the tape.
     */
    public void rewind() {
        try {
            if (cassetteStream != null) {
                cassetteStream.seek(0);
                tapestationReady(true);
            }
        } catch (IOException e) {
            cassetteStream = null;
        }
    }

    /**
     * Go past the last recording.
     */
    public void seekToEnd() {
        try {
            if (cassetteStream != null) {
                cassetteStream.seek(cassetteStream.length());
                tapestationReady(true);
            }
        } catch (IOException e) {
            cassetteStream = null;
        }
    }

    /**
     * Write a bit to the tape, but only if 'record' has been pressed.
     */
    public void writeToCassette(boolean value) {
        if (!recording) return;
        long nowCounter = bus.getCycleCounter();
        long cycleDiff = nowCounter - lastCounter;
        writeCode(value, (int)cycleDiff);
        lastCounter = nowCounter;
    }

    private void writeCode(boolean value, int delay) {
        LOGGER.debug("Write {}, delay {}", value, delay);
        int code = (int)(delay & LENGTH_MASK);
        if (value) {
            code |= VALUEBIT;
        }
        try {
            cassetteStream.writeInt(code);
        /*
            cassetteStream.write(code >> 8);
            cassetteStream.write(code);
            */
        } catch (IOException e) {
            cassetteStream = null;
        }
    }

    /**
     * Read bit and delay values from tape.
     */
    private int readCode() throws IOException {
        if (cassetteStream == null) throw new IOException();

        int code = -1;
        code = cassetteStream.readInt();
/*
        int readVal = cassetteStream.read();
        if (readVal != -1) {
            code = readVal << 8;
            readVal = cassetteStream.read();
            if (readVal != -1) {
                code += readVal;
            } else code = -1;
        }
*/
        return code;
    }

    private static boolean isBitOn(int x, int n) {
        return (x & n) != 0;
    }


}

