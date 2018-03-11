package org.roug.osnine;

/**
 * Interface from Reader to Acia chip.
 * To be expanded with writes.
 */
interface Acia {

    /**
     * Get interrupted by reader thread and get the byte.
     */
    void dataReceived(int receiveData);

    /**
     * The other end sent EOL.
     */
    void eolReceived();
}

