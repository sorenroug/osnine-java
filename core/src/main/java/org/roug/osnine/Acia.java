package org.roug.osnine;

/**
 * Interface from I/O system to Acia chip.
 * The I/O can be the Java console or a GUI emulating a terminal.
 */
public interface Acia {

    /**
     * Get interrupted by I/O Reader thread and get the byte.
     */
    void dataReceived(int receiveData);

    /**
     * Let the I/O Writer thread wait for the next character.
     */
    int waitForValueToTransmit() throws InterruptedException;

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
     * The other end sent EOL. The emulated software might expect CR,
     * NL or CR+NL.
     */
    void eolReceived();
}

