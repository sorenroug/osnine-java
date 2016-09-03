package org.roug.osnine.os9;

import java.io.IOException;

/**
 * The file descriptor class contains the resources necessary for
 * the open file. It also has a pointer to the driver.
 *
 * The actual data are in the derived classes.
 */
public abstract class PathDesc {

    static final byte CARRIAGE_RETURN = 0x0D;
    static final byte NEW_LINE = 0x0A;

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

    public void getstatus(OS9 cpu) {
	cpu.sys_error(ErrCodes.E_UnkSvc);
	return;
    }

    /**
     * Returns the number of bytes read or -1 on error
     */
    public abstract int read(byte[] buf, int size);
    /*
    public int read(byte[] buf, int size) {
        int c;
        try {
            c = fp.read(buf, 0, size);
        } catch (IOException e) {
            errorcode = ErrCodes.E_EOF;
            return -1;
        }
        return c;
    }
    */


    /**
     * Read a line from a open path. The carriage return is the last character.
     *
     * @param buf - pointer to memory buffer to store the line in.
     * @param size - size of buffer.
     * @return - the number of bytes read or -1 on error.
     */
    public abstract int readln(byte[] buf, int size);
    /*
    public int readln(byte[] buf, int size) {
        byte c;
        int i;
        try {
            for (i = 0; i < size; i++) {
                c = fp.readByte();
                if (c == NEW_LINE) // Do conversion
                    c = CARRIAGE_RETURN;
                buf[i] = c;
                if (c == CARRIAGE_RETURN)
                    break;
            }
        } catch (IOException e) {
            errorcode = ErrCodes.E_EOF;
            return -1;
        }
        return i;
    }
    */

    public abstract int write(byte[] buf, int size);

    public abstract int writeln(byte[] buf, int size);

    public void setstatus(OS9 cpu) {
	cpu.sys_error(ErrCodes.E_UnkSvc);
	return;
    }

    public int seek(int offset) {
	return -1;
    }

}
