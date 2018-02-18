package org.roug.osnine.format;


/**
 * The meta data sector of a file or directory on an RBF-formatted disk.
 */
public class FileDescriptor {

    private final static int NUM_SEGS = 48;

    private int attributes;
    private int owner;
    private byte[] date = new byte[5];
    private int link;
    private int size;
    private byte[] created = new byte[3];  // Year-month-day of creation
    private Segment[] segments = new Segment[NUM_SEGS];

    public FileDescriptor() {
        for (int i = 0; i < NUM_SEGS; i++) {
            Segment s = new Segment();
            segments[i] = s;
        }
    }

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
        attributes = attrs;
    }

    public void setOwner(int o) {
        if (o > 0xFFFF) {
            throw new RuntimeException("Illegal owner");
        }
        owner = o;
    }

    public void setSize(int newSize) {
        size = newSize;
    }

    public void setLinkCount(int newCount) {
        link = newCount;
    }
}
