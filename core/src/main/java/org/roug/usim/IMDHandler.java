package org.roug.usim;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.io.File;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Load Read/write a disk image in ImageDisk format.
 * Since sectors can be compressed, there is no random access.
 * You must read the image into memory and then parse it into the structure.
 *
 * TODO: Incomplete.
 */
public class IMDHandler {

    public static final int MAX_SIDES = 2;
    public static final int MAX_CYLINDERS = 80;
    public static final int MAX_SECTORS = 30;

    private byte[] data;

    private String label;

    private int numTracks;

    private int dirty; // Boolean?

    private boolean writeProtect;

    private boolean readOnly;

    private File imageFile;

    private Track[][] tracks;

    private static final Logger LOGGER = LoggerFactory.getLogger(IMDHandler.class);

    /**
     * Constructor.
     */
    public IMDHandler(int sides, int cyls, int sectors, int sectorSize) {
        numTracks = cyls * sides;
        tracks = new Track[cyls][sides];
        readOnly = false;
        writeProtect = false;

        for (int s = 0; s < sides; s++) {
            for (int t = 0; t < cyls; t++) {
                tracks[s][t] = new Track(sectors);
            }
        }
    }

    /**
     * Constructor. Loads the ImageDisk file.
     */
    public IMDHandler(String fileName) throws IOException {
        this(new File(fileName));
    }

    /**
     * Constructor. Loads the ImageDisk file.
     */
    public IMDHandler(File imdFile) throws IOException {
        byte[] disk;
        long l = imdFile.length();
        disk = new byte[(int) l];
        FileInputStream is = new FileInputStream(imdFile);
        is.read(disk);
        this.imageFile = imdFile;
        is.close();
        if (disk[0] != 'I' || disk[1] != 'M' || disk[2] != 'D')
            throw new IOException("Bad file format");
        // Read label
        int inx = labelLen(disk);
        try {
            label = new String(disk, 0, inx, "US-ASCII");
        } catch (UnsupportedEncodingException e) {
            throw new IOException("Bad label in file");
        }
        // Read tracks
        inx++;
        while (inx < disk.length) {
LOGGER.debug("Inx: {}, disk length {}", inx, disk.length);
            int mode = disk[inx++];
            int transferRate = 500;
            boolean mfm = true;
            switch (mode) {
                case 0: transferRate = 500;
                    mfm = false; break;
                case 1: transferRate = 300;
                    mfm = false; break;
                case 2: transferRate = 250;
                    mfm = false; break;
                case 3: transferRate = 500;
                    mfm = true; break;
                case 4: transferRate = 300;
                    mfm = true; break;
                case 5: transferRate = 250;
                    mfm = true; break;
                default:
                    throw new IOException("Unsupported mode");
            }
            int cyl = disk[inx++];
            int head = disk[inx++];
            int numSectors = disk[inx++];
            Track track = new Track(numSectors);
            track.transferRate = transferRate;
            track.mfm = mfm;
            int sectorType = disk[inx++];
            if (sectorType > 6)
                throw new IOException("Unsupported sector size");
            track.sectorSize = (1 << sectorType) * 128;
            boolean hasCylMap = (head & 0x80) == 0x80;
            boolean hasHeadMap = (head & 0x40) == 0x40;
            head &= 0x01;
            // Sector numbering map
            System.arraycopy(disk, inx, track.sectorMap, 0, numSectors);
            inx += track.numSectors;
            // Read sector cylinder map
            if (hasCylMap) {
                inx += track.numSectors;
            }
            // Read sector head map
            if (hasHeadMap) {
                inx += track.numSectors;
            }
LOGGER.debug("Inx: {}", inx);
            // Read sectors
            for (int i = 0; i < track.numSectors; i++) {
                Sector sector = new Sector();
                int sectorCode = disk[inx++];
                switch (sectorCode) {
                    // 00      Sector data unavailable - could not be read
                    case 0:
                        sector.bad = true;
                        break;
                    // 01 .... Normal data: (Sector Size) bytes follow
                    // 03 .... Normal data with "Deleted-Data address mark"
                    // 05 .... Normal data read with data error
                    case 1:
                    case 3:
                    case 5:
                        sector.data = new byte[track.sectorSize];
                        System.arraycopy(disk, inx, sector.data, 0, track.sectorSize);
                        inx += track.sectorSize;
                        if (sectorCode == 3 || sectorCode == 7)
                            sector.deleted = true;
                        if (sectorCode == 5 || sectorCode == 7)
                            sector.bad = true;
                        break;
                    // 02 xx   Compressed: All bytes in sector have same value (xx)
                    // 04 xx   Compressed  with "Deleted-Data address mark"
                    // 06 xx   Compressed  read with data error
                    case 2:
                    case 4:
                    case 6:
                        sector.fill = disk[inx++];
                        if (sectorCode == 4 || sectorCode == 8)
                            sector.deleted = true;
                        if (sectorCode == 6 || sectorCode == 8)
                            sector.bad = true;
                        break;
                }
            }
        }

    }

    /**
     * Return the length of the label.
     * Size of header is one larger.
     */
    private int labelLen(byte[] disk) {
        int i;

        for (i = 0; i < disk.length; i++) {
            if (disk[i] == 0x1A) break;
        }
        return i;
    }

    String getLabel() {
        return label;
    }

    /**
     * Read sector from memory structure.
     */
/*
    public byte[] readSector(int side, int cyl, int track, int sector) {

    }
*/
    private class TrackHeader {
        byte mode;
        byte cylinder;
        byte head;
        byte sectors;
        byte sectorSize;
    }

    private class Sector {
        byte[] data;
        byte fill;
        boolean deleted;
        boolean bad;
        boolean dirty;
    }

    private class Track {
        int numSectors;
        int sectorSize;
        int transferRate;
        boolean mfm;
        byte[] sectorMap;
        Sector[] sectors;
        
        Track(int numSectors) {
            this.numSectors = numSectors;
            sectorMap = new byte[numSectors];
            sectors = new Sector[numSectors];
        }
    }

}
