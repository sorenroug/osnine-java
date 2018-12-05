package org.roug.osnine;

/**
 * Interface for sending a one bit signal to another component.
 * Used for lambdas.
 */
public interface Signal {
    void send(boolean state);
}

