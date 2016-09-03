package org.roug.osnine.os9;

import java.nio.channels.Pipe;

/**
 * Implementation of OS9 pipes.
 */
class DevPipe extends DevDrvr {

    public DevPipe(final String mntpnt, final String args) {
	super(mntpnt);
    }

    @Override
    public PathDesc open(final String path, int mode, boolean create) {
	PDPipe fd = new PDPipe();

	fd.setDriver(this);
	return fd;
    }
}
