package org.roug.osnine.rbf;

/**
 * Represents an open file.
 */
public class RBFDirectory {

    /** Reference to the harddisk the file resides on.  */
    private Disk disk;

    /** Current position in the file. */
    private int position;

    private FileDescriptor fd;

    /**
     * Opens a file.
     *
     * @param attrs Access attributes, r/w, directory access
     */
    public RBFDirectory(Disk disk, FileDescriptor fd, int attrs) {
        this.disk = disk;
        this.fd = fd;
        if ((fd.getAttributes() & 0x80) == 0) {
            throw new RuntimeException("Attempting to open file as directory");
        }
        position = 0;
    }

    /**
     * Reads the next directory entry from the open file at the
     * current position.
     * Steps:
     * Find the correct sector from the current file position
     * Add the relative position into the sector
     * Return null if there are no entries.
     * Call Disk's readDirEntry
     * Skip entries that have 0 in the first character
     * Advance position pointer
     */
    public DirEntry readNextDirEntry() {
        DirEntry de = new DirEntry();
        do { 
            int lsn = fd.getLSNFromPosition(position);
            if (lsn == -1) return null;
            int diskLocation = lsn * 256 + (position & 0xFF);
            disk.readDirEntry(de, diskLocation);
            position += 32;
        } while (de.isDeleted());
        return de;
    }
}
