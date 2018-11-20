package org.roug.osnine;

/**
 * Interface for letting the PIA6801 send a signal to the CPU.
 */
public interface PIASignal {
    void send(boolean state);
}

