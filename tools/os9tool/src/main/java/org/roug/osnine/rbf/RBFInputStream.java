package org.roug.osnine.rbf;

import java.io.InputStream;

/**
 * Represents an open input file.
 */
public class RBFInputStream extends InputStream {

    /** Reference to the harddisk the file resides on.  */
    private Disk disk;

    /** Current position in the file. */
    private int position;

    private FileDescriptor fd;

    /** Position in sector. */
    private int sectorInx;

    /** Buffer for 256 bytes. */
    private SectorSupport sectorBuf;

    /**
     * Opens a file.
     *
     * @param attrs Access attributes, r/w, directory access
     */
    public RBFInputStream(Disk disk, FileDescriptor fd, int attrs) {
        this.disk = disk;
        this.fd = fd;
        if ((fd.getAttributes() & 0x80) != 0) {
            throw new RuntimeException("Attempting to open directory as file");
        }
        position = 0;
        sectorInx = 0;
    }

    @Override
    public int read() {
        int ch;
        if (position >= fd.getSize()) return -1;
        if (sectorInx == 0) {
            int lsn = fd.getLSNFromPosition(position);
            if (lsn == -1) return -1;
            sectorBuf = disk.readSector(lsn);
        }
        ch = sectorBuf.readByte(sectorInx);
        position++;
        sectorInx++;
        if (sectorInx == 256) sectorInx = 0;
        return ch;
    }
}
