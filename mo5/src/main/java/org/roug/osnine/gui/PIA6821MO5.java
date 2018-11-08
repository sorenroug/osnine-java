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

    private static final int BIT0 = 0x01;
    private static final int BIT1 = 0x02;
    private static final int BIT2 = 0x04;
    private static final int BIT3 = 0x08;
    private static final int BIT4 = 0x10;
    private static final int BIT5 = 0x20;
    private static final int BIT6 = 0x40;
    private static final int BIT7 = 0x80;

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

    private int outputRegisterA; 
    private int dataDirectionRegisterA;
    private int controlRegisterA;

    private int outputRegisterB; 
    private int dataDirectionRegisterB;
    private int controlRegisterB;

    private boolean activeIRQA;
    private boolean activeIRQB;

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
                if (isBitOn(controlRegisterA, BIT2))
                    return outputRegisterA;
                else
                    return dataDirectionRegisterA;
            case CRA: return controlRegisterA;
            case DDRB:
                if (isBitOn(controlRegisterB, BIT2))
                    return outputRegisterB;
                else
                    return dataDirectionRegisterB;
            case CRB:
                int tmpCRB = controlRegisterB;
                if (isBitOn(controlRegisterB, BIT0) && activeIRQB) {
                    bus.signalIRQ(false);
                }
                controlRegisterB &= ~(BIT7 | BIT6); // Turn off IRQ bits.
                return tmpCRB;
        }
        return 0;
    }

    @Override
    protected void store(int addr, int operation) {
        switch (addr - getStartAddress()) {
            case DDRA: 
                if (isBitOn(controlRegisterA, BIT2)) {
                    if (isBitOn(operation, BIT0)) {
                        outputRegisterA |= BIT0;
                    } else {
                        outputRegisterA &= ~BIT0;
                    }
                    operation |= BIT7 + BIT5; // gestion de ,l'inter optique
                    outputRegisterA = (outputRegisterA
                            & (dataDirectionRegisterA ^ 0xFF))
                            | (operation & dataDirectionRegisterA);
//                  if (LightPenClic)
//                       dataDirectionRegisterA= outputRegisterA|BIT5;
//                  else
                        dataDirectionRegisterA = outputRegisterA & (0xFF - BIT5);
                } else {
                    dataDirectionRegisterA = operation;
                }
                break;
            case CRA: 
                controlRegisterA = (controlRegisterA & 0xD0) | (operation & 0x3F);
                break;
            case DDRB:
                if (isBitOn(controlRegisterB, BIT2)) {
                    outputRegisterB = (outputRegisterB
                            & (dataDirectionRegisterB ^ 0xFF))
                            | (operation & dataDirectionRegisterB);
                    // Keyboard handler
                    if (key[outputRegisterB & 0x7E]) {
                        outputRegisterB = outputRegisterB & 0x7F;
                    } else {
                        outputRegisterB = outputRegisterB | BIT7;
                    }
                } else {
                    dataDirectionRegisterB = operation;
                }
                break;
            case CRB:
                if ((operation & BIT0) == BIT0) {
                    controlRegisterB |= BIT0;
                    activeIRQB = false;
                    signalCB1();
                } else if ((operation & BIT0) == 0) {
                    controlRegisterB &= ~BIT0;
                    disableIRQB();
                }
                controlRegisterB = (controlRegisterB & 0xD0)|(operation & 0x3F);
                break;
            }

    }

    public void setKey(int i, boolean pressed) {
        key[i] = pressed;
    }

    private void disableIRQB() {
        if (activeIRQB) {
            activeIRQB = false;
            bus.signalIRQ(false);
        }
    }

    /**
     * Activate CB1 IRQ and signal CPU.
     * If bit 0 in CRB is 0, then IRQs are disabled,
     * but the status is kept.
     */
    void signalCB1() {
        if (activeIRQB == false) {
            activeIRQB = true;
            if (isBitOn(controlRegisterB, BIT0)) {
                controlRegisterB |= BIT7;
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
