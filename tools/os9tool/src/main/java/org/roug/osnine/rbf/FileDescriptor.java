package org.roug.osnine.rbf;


/**
 * The meta data sector of a file or directory on an RBF-formatted disk.
 *
 * This class knows nothing about how the sector is loaded from the disk.
 */
public class FileDescriptor {

    private final static int NUM_SEGS = 48;

    /** Permissions. */
    private int attributes;

    /** Owner of file. */
    private int owner;

    /** Modification date. */
    private byte[] date = new byte[5];
    
    /** Link count. */
    private int link;

    /** File size. */
    private int size;

    /** Year-month-day of creation. */
    private byte[] created = new byte[3];

    private Segment[] segments = new Segment[NUM_SEGS];

    /**
     * Constructor.
     */
    public FileDescriptor() {
        for (int i = 0; i < NUM_SEGS; i++) {
            Segment s = new Segment();
            segments[i] = s;
        }
    }

    /**
     * Constructor. Loads the values from a sector.
     */
    public FileDescriptor(SectorSupport sector) {
        this();
        byte[] mdate = new byte[5];
        byte[] cdate = new byte[3];
        int filesize;

        int location = 0;
        setAttributes(sector.readByte(location));
        location++;
        setOwner(sector.readWord(location));
        location += 2;
        for (int i = 0; i < 5; i++) {  // Modification date
            mdate[i] = sector.readByte(location++);
        }
        setDate(mdate);
        setLinkCount(sector.readByte(location++));
        setSize(sector.readQuad(location));
        location += 4;
        // Read the segments.
        for (int i = 0; i < NUM_SEGS; i++) {
            segments[i].lsn = sector.readTriple(0x10 + i * 5);
            segments[i].num = sector.readWord(0x13 + i * 5);
        }
    }

    /**
     * Put the object into a 256 byte array ready to be written to disk.
     */
    public byte[] getSector() {
        SectorSupport sector = new SectorSupport();
        sector.writeByte(0, attributes);
        sector.writeWord(1, owner);
        sector.writeDateTime(3);
        sector.writeByte(8, link);
        sector.writeDWord(9, size);
        sector.writeDate(0x0D);
        for (int i = 0; i < NUM_SEGS; i++) {
            sector.writeTriple(0x10 + i * 5, segments[i].lsn);
            sector.writeWord(0x13 + i * 5, segments[i].num);
        }

        return sector.getSector();
    }

    /**
     * Get the LSN from a relative position in the file.
     * Return -1 if the position is larger than the file size.
     */
    public int getLSNFromPosition(int position) {
        if (position < 0 || position > size) return -1;

        int segmentStart = 0;
        int segmentEnd = 0;
        for (int i = 0; i < NUM_SEGS; i++) {
            segmentStart = segmentEnd;
            segmentEnd += (segments[i].num * 256);
            if (position > segmentEnd) continue;

            // It is somewhere in this segment
            int relLoc = position - segmentStart;
            return segments[i].lsn + (relLoc / 256);
        }
        return -1;
    }

    public void addSegment(Segment segment) {
        for (int i = 0; i < NUM_SEGS; i++) {
            if (segments[i].lsn == 0) {
                segments[i].lsn = segment.lsn;
                segments[i].num = segment.num;
                return;
            }
        }
        throw new RuntimeException("Sector list full");
    }

    public void setAttributes(int attrs) {
        if (attrs > 0xFF) {
            throw new RuntimeException("Illegal attributes");
        }
        attributes = attrs & 0xFF;
    }

    public int getAttributes() {
        return attributes;
    }

    public void setOwner(int o) {
        if (o > 0xFFFF) {
            throw new RuntimeException("Illegal owner");
        }
        owner = o;
    }

    public int getOwner() {
        return owner;
    }

    public void setDate(byte[] date) {
        for (int i = 0; i < 5; i++) {
            this.date[i] = date[i];
        }
    }

    public void setSize(int newSize) {
        size = newSize;
    }

    public int getSize() {
        return size;
    }

    public void setLinkCount(int newCount) {
        link = newCount;
    }
}
