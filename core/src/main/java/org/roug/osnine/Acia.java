package org.roug.osnine;

/**
 * Interface from Reader to Acia chip.
 * To be expanded with writes.
 */
interface Acia {
    /**
     * Is Receive register full?
     */
    boolean isReceiveRegisterFull();

    /**
     * Get interrupted by reader thread and get the byte.
     */
    void dataReceived(int receiveData);
}

