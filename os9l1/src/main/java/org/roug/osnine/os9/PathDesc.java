package org.roug.osnine.os9;

/**
 * The file descriptor class contains the resources necessary for
 * the open file. It also has a pointer to the driver.
 *
 * The actual data are in the derived classes.
 */
public abstract class PathDesc {

    static final byte CARRIAGE_RETURN = 0x0D;
    static final byte NEW_LINE = 0x0A;

    /** Link to device driver. */
    protected DevDrvr driver;

    protected int usecount;

    protected int errorcode;

    public PathDesc() {
	usecount = 1;
    }

    public int close() {
        usecount--;
        return 0;
    }

    void setDriver(DevDrvr driver) {
        this.driver = driver;
    }

    public int getErrorCode() {
        return errorcode;
    }

    public void setErrorCode(int code) {
        errorcode = code;
    }

    /**
     * Returns the number of bytes read or -1 on error.
     */
    public abstract int read(byte[] buf, int size);

    /**
     * Read a line from a open path. The carriage return is the last character.
     *
     * @param buf - pointer to memory buffer to store the line in.
     * @param size - size of buffer.
     * @return - the number of bytes read or -1 on error.
     */
    public abstract int readln(byte[] buf, int size);

    /**
     * Write buffer to the file descriptor.
     *
     * @return The number of bytes written.
     */
    public abstract int write(byte[] buf, int size);

    /**
     * Write buffer until CR is seen.
     *
     * @return The number of bytes written.
     */
    public abstract int writeln(byte[] buf, int size);

    public void getstatus(OS9 cpu) {
	cpu.sys_error(ErrCodes.E_UnkSvc);
    }

    public void setstatus(OS9 cpu) {
	cpu.sys_error(ErrCodes.E_UnkSvc);
    }

    /**
     * Seek in file. If not overridden, then device is unable to.
     */
    public int seek(int offset) {
	return -1;
    }

}
