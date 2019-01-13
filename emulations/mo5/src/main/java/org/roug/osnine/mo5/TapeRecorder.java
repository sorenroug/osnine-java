package org.roug.osnine.mo5;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.Arrays;
import javax.sound.sampled.AudioFileFormat;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioFormat.Encoding;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.SourceDataLine;
import javax.sound.sampled.UnsupportedAudioFileException;

import org.roug.osnine.Bus8Motorola;
import org.roug.osnine.BitReceiver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Emulation of tape recorder, which receives timed one-bit
 * pulses from the computer and sends timed one-bit signals on play-back.
 * Duration of pulses in CPU cycles:
 * 220
 * 430
 */
public class TapeRecorder {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(TapeRecorder.class);

    private static final byte[] M5P1 = {0x4d, 0x35, 0x50, 0x31}; // M5P1: Header MO5 Pulse v.1
    private static final byte[] RIFF = {0x52, 0x49, 0x46, 0x46};

    private static final int PULSE_FORMAT = 1;
    private static final int WAVE_FORMAT = 2;

    private int fileFormat = 0;

    /** Write a stretch of empty while motor starts. */
    private static final int START_DELAY = 200000;

    /** Write a stretch of empty while motor stops. */
    private static final int STOP_DELAY = 100000;

    /** Callback to computer interface for play back. */
    private BitReceiver listener;

    private Bus8Motorola bus;

    /** Number of cycles since last callback. */
    private long lastCounter;

    /** File for cassette storage. */
    private FileOutputStream outStream;

    private BufferedInputStream inStream;

    /** Next value to feed to the PIA. */
    private boolean cassetteBit;

    /** Tell bus to call me to read next pulse on tape. */
    private BitReceiver callback;

    /** File name of cassette file. */
    private File cassetteFilename;

    /** Determines if the recording or play button is pressed. */
    private boolean recording;

    /** Determins if the motor is on. */
    private boolean motorOn;

    /**
     * Create a tape recorder.
     *
     * @param bus the bus to get interrupts from.
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
        unloadCassetteFile();
        cassetteFilename = filename;
        outStream = new FileOutputStream(filename);
        outStream.write(M5P1);
        tapestationReady(true);
        recording = true;
        fileFormat = PULSE_FORMAT;
    }

    /**
     * Load a tape and press the Play button. Tape will not move
     * until the computer starts the motor.
     *
     * @param filename the name of the file to load
     * @throws Exception if the is a problem with the file.
     */
    public void loadForPlay(File filename) throws Exception {
        byte[] magicBuffer = new byte[4];

        unloadCassetteFile();
        cassetteFilename = filename;
        inStream = new BufferedInputStream(new FileInputStream(filename));
        inStream.mark(4);
        inStream.read(magicBuffer, 0, 4);
        if (Arrays.equals(M5P1, magicBuffer)) {
            fileFormat = PULSE_FORMAT;
        } else if (Arrays.equals(RIFF, magicBuffer)) {
            inStream.reset();
            fileFormat = WAVE_FORMAT;
        } else {
            LOGGER.info("Unsupported file");
            inStream = null;
        }
        tapestationReady(true);
        recording = false;
    }

    /**
     * Unload the tape. The tape station is not ready afterwards.
     */
    public void unloadCassetteFile() {
        motorOn = false;
        try {
            tapestationReady(false);
            if (inStream != null) {
                inStream.close();
                inStream = null;
            }
            if (outStream != null) {
                outStream.close();
                outStream = null;
            }
        } catch (IOException e) {
            inStream = null;
            outStream = null;
        }
    }

    /**
     * Set the callback to receive the bit from tape.
     *
     * @param receiver method to call
     */
    public void setReceiver(BitReceiver receiver) {
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
                    callback = (boolean dummystate) -> feedPulseLine(dummystate);
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
    private void feedPulseLine(boolean newstate) {
        tapestationReady(cassetteBit);
        if (!motorOn) {
            tapestationReady(true);
            return;
        }
        try {
            int code = readPulseCode();
            cassetteBit = (code < 0);
            int delay = (code < 0)?-code:code;
            LOGGER.debug("Read {}, delay {}", cassetteBit, delay);
            callback = (boolean state) -> feedPulseLine(state);
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
            loadForPlay(cassetteFilename);
        } catch (Exception e) {
            inStream = null;
        }
    }

    /**
     * Go past the last recording.
     */
    public void seekToEnd() {
    /*
        try {
            if (outStream != null) {
                outStream.seek(outStream.length());
                tapestationReady(true);
            }
        } catch (IOException e) {
            outStream = null;
        }
    */
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
        byte[] buffer = new byte[2];
        LOGGER.debug("Write {}, delay {}", value, delay);

        try {
            while (delay > 0) {
                int code = ((delay > 0x7FFF)?0x7FFF:delay) * ((value)?-1:1);
                buffer[0] = (byte) ((code >> 8) & 0xFF);
                buffer[1] = (byte) (code & 0xFF);
                outStream.write(buffer);
                delay -= 0x7FFF;
            }
        } catch (IOException e) {
            LOGGER.error("Unable to write to cassette");
            outStream = null;
        }
    }

    /**
     * Read bit and delay values from tape.
     *
     * @return the combined bit and value.
     */
    private int readPulseCode() throws IOException {
        byte[] buffer = new byte[2];

        if (inStream == null) throw new IOException();

        int code = -1;
        int siz = inStream.read(buffer);
        if (siz == -1) throw new IOException();
        code = ((buffer[0] & 0xFF) << 8) | (buffer[1] & 0xFF);
        if ((code & 0x8000) != 0) code |= 0xFFFF0000;
        return code;
    }

    private static boolean isBitOn(int x, int n) {
        return (x & n) != 0;
    }


}

