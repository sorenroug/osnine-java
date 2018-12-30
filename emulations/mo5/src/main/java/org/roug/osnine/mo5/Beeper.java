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
import org.roug.osnine.Signal;


/**
 * One-bit sound generator, which is sent high/low in sequences to emulate
 * a sound wave. Since the emulated CPU most likely will be faster than
 * the sound, the class buffers 1/10 of a second, and will stop the CPU
 * if the sequences come faster than there is buffer for.
 * The BEEP command generates 16 cycles and there are 788 CPU cycles from
 * true-false to the next true-false transition.
 */
public class Beeper implements Signal {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(Beeper.class);

    private static final int BUFFER_SIZE = 4096;

    private static final float FRAME_RATE = 44100f; // We have 5 octaves to generate.
    private static final int MONO = 1;
    /** Peak and through of the wave. */
    private static final int PEAK = 32;

    //static double duration = 0.020; // 20ms
    //static int sampleBytes = Short.SIZE / 8; // 8 bits
    //static int frameBytes = sampleBytes * MONO;

    private static AudioFormat format = new AudioFormat(FRAME_RATE, 8, MONO, true, false);
    //static int nFrames = (int) Math.ceil(frameRate * duration);
    //static int nSamples = nFrames * MONO;

    private byte[] soundBuffer;

    private static SourceDataLine line;

    private Bus8Motorola bus;

    /** If false then the sound is turned off. */
    private boolean active = true;

    private long oldCounter;
    private boolean oldState;

    public Beeper(Bus8Motorola bus) {
        this.bus = bus;
        soundBuffer = new byte[BUFFER_SIZE];

        DataLine.Info info = new DataLine.Info(SourceDataLine.class, format);

        try {
            line = (SourceDataLine) AudioSystem.getLine(info);
            line.open(format, 1000);
            LOGGER.info("Buffer size {}", line.getBufferSize());
        } catch (LineUnavailableException e) {
            LOGGER.error("Sound unavailable", e);
        }
        line.start();
    }

    @Override
    public void send(boolean state) {
        if (active) {
            long nowCounter = bus.getCycleCounter();
            if (oldState != state) {
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
     */
    public void setActiveState(boolean state) {
        active = state;
    }

    public boolean getActiveState() {
        return active;
    }
}
