package org.roug.osnine.os9;

/**
 * Null file descriptor. All reads return nothing.
 */
public class PDNull extends PathDesc  {

    @Override
    public int read(byte[] buf, int len) {
	return 0;
    }

    @Override
    public int readln(byte[] buf, int len)  {
        return 0;
    }

    @Override
    public int write(byte[] buf, int len) {
        return len;
    }

    @Override
    public int writeln(byte[] buf, int len) {
        return len;
    }
}
