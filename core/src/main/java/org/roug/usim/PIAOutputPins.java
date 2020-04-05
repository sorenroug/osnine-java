package org.roug.usim;

/**
 * Interface for letting a PIA 6821 connect output pins to
 * other circuitry.
 */
public interface PIAOutputPins {
    void send(int mask, int value, int oldValue);
}

