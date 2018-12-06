package org.roug.osnine.mo5;

import java.io.FileNotFoundException;
import java.io.IOException;
import org.roug.osnine.Bus8Motorola;
import org.roug.osnine.PIA6821;
import org.roug.osnine.Signal;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 6821 PIA in a Thomsom MO5.
 * This chip is located at addresses 0xA7C0-0xA7C3.
 * The MO5 buzzer is controlled by bit 0 on $A7C1. By changing this bit
 * a quadratic signal is emitted. This is used by the PLAY instruction in BASIC.
 *
 * data port A (A7C0)
 *  bit 0: Switch the screen RAM mapping between pixel and attribute RAMs
 *  bits 1-4: border color (R,G,B,P)
 *  bit 5: light pen button
 *  bit 6: tape drive data output
 *  bit 7: tape drive data input
 *  bit 7 is low when no tape drive is plugged, and high when there is one.
 *  The monitor loading and saving code checks for this to detect the tape drive
 *
 * data port B (A7C1)
 *  bit 0: sound output
 *  bits 1-3: keyboard column to scan
 *  bits 4-6: keyboard line to scan
 *  bit 7: state of key selected by the column and line
 *
 * Control ports (A7C2, A7C3)
 *  CA1: lightpen interrupt (IRQA is wired to 6809 FIRQ)
 *  CA2: tape drive motor control (output)
 *  CB1: 50Hz interrupt (IRQB is wired to 6809 IRQ)
 *  CB2: video incrustation enable (output)
 */
public class PIA6821MO5 extends PIA6821 {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(PIA6821MO5.class);

    /** If PIA has raised IRQ on the bus. */
    private boolean[] activeIRQ = new boolean[2];

    /** The event-driven GUI. */
    private Screen screen;

    private TapeRecorder tape;

    /** Number of cycles since last callback. */
    private long lastCounter;

    boolean cassetteBit;

    private Signal callback;

    /**
     * Constructor.
     */
    public PIA6821MO5(Bus8Motorola bus, Screen screen, TapeRecorder tape) {
        super(0xA7C0, bus);
        this.screen = screen;
        this.tape = tape;
        setLayout(1);

        setIRQCallback(A, (boolean state) -> signalFIRQ(state));
        setIRQCallback(B, (boolean state) -> signalIRQ(state));

        setOutputCallback(A, (int mask, int value, int oldValue)
                   -> screenMemoryBank(mask, value, oldValue));
        setOutputCallback(B, (int mask, int value, int oldValue)
                   -> keyboardMatrix(mask, value, oldValue));
        setControlCallback(A, (boolean state) -> cassetteMotor(state));
    }


    private static boolean isBitOn(int x, int n) {
        return (x & n) != 0;
    }

    /**
     * IRQB is connected to the CPU's IRQ pin.
     *
     * @param state - new state of the interrupt.
     */
    private void signalIRQ(boolean state) {
        if (state != activeIRQ[B]) {
            activeIRQ[B] = state;
            bus.signalIRQ(state);
        }
    }

    /**
     * IRQA is connected to the CPU's FIRQ pin.
     *
     * @param state - new state of the interrupt.
     */
    private void signalFIRQ(boolean state) {
        if (state != activeIRQ[A]) {
            activeIRQ[A] = state;
            bus.signalFIRQ(state);
        }
    }

    /**
     * Start/stop cassette motor.
     * If state is false, then turn motor on, otherwise turn off motor.
     */
    private void cassetteMotor(boolean state) {
        tape.cassetteMotor(state);
    }

    /**
     * Set pixel bank and output to casette.
     * If C2 is off then the tape motor is running.
     * The program then sends 0 and 1 at timed intervals to
     * send values to the tape at 1200 baud.
     *
     * @param mask - the data direction mask - 1 = output.
     * @param value - the new value set in the output registers
     * @param oldValue - the previous value - for detecting changes.
     */
    private void screenMemoryBank(int mask, int value, int oldValue) {
        screen.setPixelBankActive(isBitOn(value, BIT0));

        // Write cassette output
        if (!isC2On(A) && isBitOn(mask, BIT6)) {
            tape.writeToCassette(isBitOn(value, BIT6));
        }
    }

    /**
     * Scan keyboard matrix for pressed keys. Set input line B7 if so.
     * @param mask - the data direction mask - 1 = output.
     * @param value - the new value set in the output registers
     * @param oldValue - the previous value - for detecting changes.
     */
    private void keyboardMatrix(int mask, int value, int oldValue) {
        setInputLine(B, 7, !screen.hasKeyPress(value & 0x7E));
    }
}
