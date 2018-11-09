package org.roug.osnine.gui;

import org.roug.osnine.MemorySegment;
import org.roug.osnine.Bus8Motorola;

import java.util.Timer;
import java.util.TimerTask;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 6821 PIA in a Thomsom MO5.
 * This chip is located at addresses 0xA7C0-0xA7C3.
 * The MO5 buzzer is controlled by bit 0 on $A7C1. By changing this bit
 * a quadratic signal is emitted. This is used by the PLAY instruction in BASIC.
 * An IRQ signal is sent 50 times a second and cancelled when the CPU reads $A7C3
 *
 * data port A (A7C0)
 *  bit 0: /FORME - Switch the screen RAM mapping between pixel and attribute RAMs
 *  bits 1-4: border color (R,G,B,P)
 *  bit 5: light pen button
 *  bit 6: tape drive data output
 *  bit 7: tape drive data input
 *  Bit 7 is low when no tape drive is plugged, and high when there is one.
 *  The monitor loading and saving code checks for this to detect the tape drive.
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

 * */
public class PIA6821MO5 extends MemorySegment {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(PIA6821MO5.class);

    public static final int KEYS = 128;

    private static final int A = 0;
    private static final int B = 1;

    private static final int BIT0 = 0x01;
    private static final int BIT1 = 0x02;
    private static final int BIT2 = 0x04;
    private static final int BIT3 = 0x08;
    private static final int BIT4 = 0x10;
    private static final int BIT5 = 0x20;
    private static final int BIT6 = 0x40;
    private static final int BIT7 = 0x80;

    /** Control bit for IRQ. */
    private static final int CIRQ = 0x01;

    // NOTE: the MO5 has swapped Register Select 0 and 1.
    private static final int DDRA = 0;
    private static final int ORA = 0;
    private static final int DDRB = 1;
    private static final int ORB = 1;
    private static final int CRA = 2;
    private static final int CRB = 3;

    private static final int CLOCKDELAY = 500;  // milliseconds
    /** On MO5 the interrupt is 50 times a second. */
    private static final int CLOCKPERIOD = 20;  // milliseconds

    private int[] outputRegister = new int[2]; 
    private int[] dataDirectionRegister = new int[2];
    private int[] controlRegister = new int[2];

    /** If PIA has raised IRQ on the bus. */
    private boolean[] activeIRQ = new boolean[2];

    /** Reference to CPU for the purpose of sending IRQ. */
    private Bus8Motorola bus;

    /** Table of keys that are pressed on the keyboard. */
    private boolean[] key;

    private ClockTick clocktask;

    public PIA6821MO5(Bus8Motorola bus) {
        super(0xA7C0, 0xA7C0 + 4);
        this.bus = bus;
        key = new boolean[KEYS];
        for (int i = 0; i < KEYS; i++) key[i] = false;

        LOGGER.debug("Starting heartbeat every 20 milliseconds");
        if (clocktask == null) {
            clocktask = new ClockTick(this);
            Timer timer = new Timer("clock", true);
            timer.schedule(clocktask, CLOCKDELAY, CLOCKPERIOD);
        }
    }

    @Override
    protected int load(int addr) {
        switch (addr - getStartAddress()) {
            case DDRA:
                if (isBitOn(controlRegister[A], BIT2))
                    return outputRegister[A];
                else
                    return dataDirectionRegister[A];
            case CRA:
                return readControlRegister(A);
            case DDRB:
                if (isBitOn(controlRegister[B], BIT2))
                    return outputRegister[B];
                else
                    return dataDirectionRegister[B];
            case CRB:
                return readControlRegister(B);
        }
        return 0;
    }

    private int readControlRegister(int side) {
        int tmpCR = controlRegister[side];
        if (isBitOn(controlRegister[side], CIRQ) && activeIRQ[side]) {
            activeIRQ[side] = false;
            bus.signalIRQ(false);
        }
        controlRegister[side] &= ~(BIT7 | BIT6); // Turn off IRQ bits.
        return tmpCR;
    }

    @Override
    protected void store(int addr, int operation) {
        switch (addr - getStartAddress()) {
            case DDRA: 
                if (isBitOn(controlRegister[A], BIT2)) {
                    if (isBitOn(operation, BIT0)) {
                        outputRegister[A] |= BIT0;
                    } else {
                        outputRegister[A] &= ~BIT0;
                    }
                    operation |= BIT7 + BIT5; // gestion de ,l'inter optique
                    outputRegister[A] = (outputRegister[A]
                            & (dataDirectionRegister[A] ^ 0xFF))
                            | (operation & dataDirectionRegister[A]);
//                  if (LightPenClic)
//                       dataDirectionRegister[A]= outputRegister[A]|BIT5;
//                  else
                        dataDirectionRegister[A] = outputRegister[A] & (0xFF - BIT5);
                } else {
                    dataDirectionRegister[A] = operation;
                }
                break;
            case CRA: 
                if ((operation & CIRQ) == 0) {
                    disableIRQ(A);
                }
                controlRegister[A] = (controlRegister[A] & 0xD0) | (operation & 0x3F);
                break;
            case DDRB:
                if (isBitOn(controlRegister[B], BIT2)) {
                    outputRegister[B] = (outputRegister[B]
                            & (dataDirectionRegister[B] ^ 0xFF))
                            | (operation & dataDirectionRegister[B]);
                    // Keyboard handler
                    if (key[outputRegister[B] & 0x7E]) {
                        outputRegister[B] = outputRegister[B] & 0x7F;
                    } else {
                        outputRegister[B] = outputRegister[B] | BIT7;
                    }
                } else {
                    dataDirectionRegister[B] = operation;
                }
                break;
            case CRB:
                if ((operation & CIRQ) == 0) {
                    disableIRQ(B);
                }
                controlRegister[B] = (controlRegister[B] & 0xD0)|(operation & 0x3F);
                break;
            }

    }

    /**
     * Called from the keyboard event handler.
     */
    public void setKey(int i, boolean pressed) {
        key[i] = pressed;
    }

    private void disableIRQ(int side) {
        if (activeIRQ[side]) {
            activeIRQ[side] = false;
            bus.signalIRQ(false);
        }
    }

    /**
     * Activate CB1 IRQ and signal CPU.
     * If bit 0 in CRB is 0, then IRQs are disabled,
     * but the status is kept.
     */
    void signalCB1() {
        if (activeIRQ[B] == false) {
            activeIRQ[B] = true;
            if (isBitOn(controlRegister[B], CIRQ)) {
                controlRegister[B] |= BIT7;
                bus.signalIRQ(true);
            }
        }
    }

    private static boolean isBitOn(int x, int n) {
        return (x & n) != 0;
    }

    private static boolean isBitOff(int x, int n) {
        return (x & n) == 0;
    }

}

class ClockTick extends TimerTask {

    private PIA6821MO5 pia;

    ClockTick(PIA6821MO5 pia) {
        this.pia = pia;
    }

    public void run() {
        pia.signalCB1(); // Execute a hardware interrupt
    }
}
