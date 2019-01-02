package org.roug.osnine.mo5;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.ShortBuffer;
import java.util.Timer;
import java.util.TimerTask;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioFormat.Encoding;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.SourceDataLine;
import javax.sound.sampled.UnsupportedAudioFileException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.roug.osnine.Bus8Motorola;
import org.roug.osnine.BitReceiver;


/**
 * One-bit sound generator, which is sent high/low in sequences to emulate
 * a sound wave. The class generates one wave cycle, which is then delivered
 * to the audio output. The Audio system doesn't start until its buffer is
 * full. Therefore we set a small buffer.
 *
 * The BEEP command generates 16 cycles and there are 788 CPU cycles from
 * true-false to the next true-false transition.
 * Cycles to generate specific notes: O1LA = 10912, O2LA = 5480, O3LA = 2760
 * O4LA = 1380, O5LA = 690.
 */
public class Beeper implements BitReceiver {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(Beeper.class);

    /** Must be big enough the hold one wave of lowest note in lowest octave.*/
    private static final int BUFFER_SIZE = 4096;

    /** Uses a CD quality frame rates as we have 5 octaves to generate. */
    private static final float FRAME_RATE = 44100f;

    private static final int MONO = 1;

    /** Peak and through of the wave. */
    private static final int PEAK = 32;

    private static AudioFormat format = new AudioFormat(FRAME_RATE, 8, MONO, true, false);

    private byte[] soundBuffer;

    private static SourceDataLine line;

    /** Reference to the bus to get the cycle counter and throttling. */
    private Bus8Motorola bus;

    /** If false then the sound is turned off. */
    private boolean active = true;

    private long oldCounter;
    private boolean oldState;

    /**
     * Create a one-bit sound channel.
     *
     * @param bus interface to the bus to get the cycles.
     */
    public Beeper(Bus8Motorola bus) {
        this.bus = bus;
        soundBuffer = new byte[BUFFER_SIZE];

        DataLine.Info info = new DataLine.Info(SourceDataLine.class, format);

        try {
            line = (SourceDataLine) AudioSystem.getLine(info);
            line.open(format, 1000);
            LOGGER.debug("Buffer size {}", line.getBufferSize());
        } catch (LineUnavailableException e) {
            LOGGER.error("Sound unavailable", e);
        }
        line.start();
    }

    /**
     * Called when the PIA sets the periphical register.
     * Uses the bus cycle counter to calculate what note to play.
     * Resets the counter from transition from low to high.
     * From transition high to low, which is half a wave, then
     * writes the sound.
     */
    @Override
    public void send(boolean state) {
        if (active) {
            if (oldState != state) {
                long nowCounter = bus.getCycleCounter();
                if (state) {
                    // transition from false to true
                    if (nowCounter - oldCounter > 9000) line.flush();
                    oldCounter = nowCounter;
                } else {
                    int delta = (int) (nowCounter - oldCounter) / 6;
                    LOGGER.debug("Beep: {}", delta << 1);
                    for (int i = 0; i < delta; i++)
                        soundBuffer[i] = PEAK;
                    for (int i = 0; i < delta; i++)
                        soundBuffer[i + delta] = -PEAK;
                    line.write(soundBuffer, 0, delta * 2);
                }
                oldState = state;
            }
        }
    }

    /**
     * Can turn off/on the sound.
     *
     * @param state sound is active if true.
     */
    public void setActiveState(boolean state) {
        active = state;
    }

    /**
     * Get the state of the sound device.
     *
     * @return true if the sound is going to be generated.
     */
    public boolean getActiveState() {
        return active;
    }
}
