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
     * Let the Writer thread wait for the next character.
     */
    int valueToTransmit() throws InterruptedException;

    /**
     * Set Data Carrier Detect. In telnet-based emulation this
     * is set to high when a client has connected to the socket.
     * When the client closes the connection, then the DCD goes to false.
     * In the 6551, the bit is inverted. I.e. bit 5 in the status register
     * is 1 when there is no carrier.
     *
     * @param detected - if there is a carrier
     */
    void setDCD(boolean detected);

    /**
     * The other end sent EOL.
     */
    void eolReceived();
}

