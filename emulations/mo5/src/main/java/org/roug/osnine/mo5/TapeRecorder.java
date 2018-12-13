package org.roug.osnine.mo5;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import org.roug.osnine.Bus8Motorola;
import org.roug.osnine.Signal;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Emulation of tape recorder, which receives timed one-bit
 * pulses from the computer and sends timed one-bit on play-back.
 */
public class TapeRecorder {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(TapeRecorder.class);

    /** Bit in integer that says if the signal is high or low. */
    private static final int VALUEBIT = 0x40000000;

    private static final int LENGTH_MASK = VALUEBIT - 1;

    private static final int START_DELAY = 200000;
    private static final int STOP_DELAY = 100000;

    /** Callback to computer interface for play back. */
    private Signal listener;

    private Bus8Motorola bus;

    /** Number of cycles since last callback. */
    private long lastCounter;

    /** File for cassette storage. */
    private RandomAccessFile cassetteStream;

    /** Next value to feed to the PIA. */
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
     *
     * @param filename the name of the file to load
     * @throws Exception if the is a problem with the file.
     */
    public void loadForRecord(File filename) throws Exception {
        loadCassetteFile(filename);
        recording = true;
    }

    /**
     * Load a tape and press the Play button. Tape will not move
     * until the computer starts the motor.
     *
     * @param filename the name of the file to load
     * @throws Exception if the is a problem with the file.
     */
    public void loadForPlay(File filename) throws Exception {
        loadCassetteFile(filename);
        recording = false;
    }

    /**
     * Open a file to emulate that the cassette recorder is loaded with a tape.
     *
     * @param filename the name of the file to load
     * @throws Exception if the is a problem with the file.
     */
    private void loadCassetteFile(File filename) throws Exception {
        if (cassetteStream != null) unloadCassetteFile();
        cassetteFilename = filename;
        cassetteStream = new RandomAccessFile(filename, "rw");
        tapestationReady(true);
    }

    /**
     * Unload the tape. The tape station is not ready afterwards.
     */
    public void unloadCassetteFile() {
        motorOn = false;
        //cassetteMotor(false);
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
     *
     * @param receiver method to call
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
     * @param state - if true, then turn motor on, otherwise turn off motor.
     */
    public void cassetteMotor(boolean state) {
        if (state) {
            if (!motorOn) { // Only if motor is stopped
                LOGGER.debug("Turning motor on for {}", recording?"record":"playback");
                lastCounter = 0;

                if (!recording) {
                    tapestationReady(true);
                    callback = (boolean dummystate) -> feedLine(dummystate);
                    bus.callbackIn(0, callback);
                }
            }
            motorOn = true;
        } else {
            LOGGER.debug("Turning motor off");
            if (motorOn && recording)
                writeCode(true, STOP_DELAY);
            motorOn = false;
            tapestationReady(true);
        }
    }

    /**
     * Feed bit from tape into an input line on the PIA.
     * Called on a delay from the bus.
     *
     * @param newstate bit received from tape
     */
    private void feedLine(boolean newstate) {
        tapestationReady(cassetteBit);
        if (!motorOn) {
            tapestationReady(true);
            return;
        }
        try {
            int code = readCode();
            cassetteBit = isBitOn(code, VALUEBIT);
            int delay = code & LENGTH_MASK;
            LOGGER.debug("Read {}, delay {}", cassetteBit, delay);
            callback = (boolean state) -> feedLine(state);
            bus.callbackIn(delay, callback);
        } catch (IOException e) {
            LOGGER.debug("End of tape");
            tapestationReady(true);
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
     *
     * @param value the bit to write
     */
    public void writeToCassette(boolean value) {
        if (!motorOn || !recording) return;
        long nowCounter = bus.getCycleCounter();
        if (lastCounter == 0)
            lastCounter = nowCounter - START_DELAY;
        long cycleDiff = nowCounter - lastCounter;
        writeCode(value, (int)cycleDiff);
        lastCounter = nowCounter;
    }

    /**
     * Write bit and delay values to tape.
     *
     * @param value the bit to write
     */
    private void writeCode(boolean value, int delay) {
        LOGGER.debug("Write {}, delay {}", value, delay);
        int code = (int)(delay & LENGTH_MASK);
        if (value) {
            code |= VALUEBIT;
        }
        try {
            cassetteStream.writeInt(code);
        } catch (IOException e) {
            cassetteStream = null;
        }
    }

    /**
     * Read bit and delay values from tape.
     *
     * @return the combined bit and value.
     */
    private int readCode() throws IOException {
        if (cassetteStream == null) throw new IOException();

        int code = -1;
        code = cassetteStream.readInt();
        return code;
    }

    private static boolean isBitOn(int x, int n) {
        return (x & n) != 0;
    }


}

