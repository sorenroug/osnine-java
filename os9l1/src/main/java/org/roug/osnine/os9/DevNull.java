package org.roug.osnine.os9;

/**
 * Corresponds to /dev/null in UNIX.
 */
public class DevNull extends DevDrvr {

    public DevNull(final String mntpnt) {
        super(mntpnt);
    }

    @Override
    public PathDesc open(final String path, int mode, boolean create) {
        return new PDNull();
    }
}

