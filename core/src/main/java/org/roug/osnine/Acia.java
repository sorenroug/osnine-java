package org.roug.osnine;

/**
 * Interface from I/O system to Acia chip.
 * The I/O can be the Java console or a GUI emulating a terminal.
 */
public interface Acia {

    /**
     * Called when remote end sends a character.
     */
    void dataReceived(int receiveData);

    /**
     * The Acia waits for the OS to send a character.
     */
    int waitForValueToTransmit() throws InterruptedException;

    /**
     * Set Data Carrier Detect. In telnet-based emulation this
     * is set to high when a client has connected to the socket.
     * When the client closes the connection, then the DCD goes to false.
     *
     * @param detected - if there is a carrier
     */
    void setDCD(boolean detected);

    /**
     * The remote end sent EOL. The emulated software might expect CR,
     * NL or CR+NL.
     */
    void eolReceived();
}

