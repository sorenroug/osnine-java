package org.roug.usim;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.io.File;
import java.util.HashMap;

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
    public static final int MAX_TRACKS = 80;
    public static final int MAX_SECTORS = 30;

    private byte[] data;

    private String label;

    /** Number of heads on media: 1 or 2. */
    private int numHeads;

    /** Number of tracks on one side. */
    private int numTracks;

    private int dirty; // Boolean?

    private boolean writeProtect;

    private boolean readOnly;

    private File imageFile;

    private Track[][] tracks;

    private static final Logger LOGGER =
                LoggerFactory.getLogger(IMDHandler.class);

    /** Mapping from logical head,track,sect to physical. */
    private HashMap<SectorMap,SectorMap> logicalMap;

    /**
     * Constructor.
     * TODO
     */
    public IMDHandler(int sides, int numTracks, int sectors, int sectorSize) {
        this.numTracks = numTracks;
        numHeads = sides;
        tracks = new Track[sides][numTracks];
        readOnly = false;
        writeProtect = false;

        for (int s = 0; s < sides; s++) {
            for (int t = 0; t < numTracks; t++) {
                tracks[s][t] = new Track(s, t, sectors);
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
        numHeads = 1;
        tracks = new Track[2][256];

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
        numTracks = 0;
        while (inx < disk.length) {
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
            int trackNum = disk[inx++];
            int head = disk[inx++];
            int numSectors = disk[inx++];
            Track track = new Track(head, trackNum, numSectors);
            track.transferRate = transferRate;
            track.mfm = mfm;
            int sectorType = disk[inx++];
            if (sectorType > 6)
                throw new IOException("Unsupported sector size");
            track.sectorSize = (1 << sectorType) * 128;
            boolean hasCylMap = (head & 0x80) == 0x80;
            boolean hasHeadMap = (head & 0x40) == 0x40;
            head &= 0x01;
            if (head > numHeads - 1) numHeads = head + 1;

            track.setSectorMap(disk, inx);
//LOGGER.info("Side {} track {} sector map {}", head, trackNum, track.sectorMap);
            inx += track.numSectors;
            // Read sector cylinder map
            if (hasCylMap) {
                track.setTrackMap(disk, inx);
                inx += track.numSectors;
//LOGGER.info("Side {} track {} cylinder map {}", head, trackNum, track.cylinderMap);
            }
            // Read sector head map
            if (hasHeadMap) {
                track.setHeadMap(disk, inx);
                inx += track.numSectors;
LOGGER.info("Side {} track {} head map {}", head, trackNum, track.headMap);
            }
//LOGGER.info("Inx: {}", inx);
            inx = readSectorsFromArray(disk, inx, track);
            tracks[head][trackNum] = track;
            if (trackNum > numTracks) numTracks = trackNum;
        }
        numTracks++;
        buildReverseMap();
    }

    /*
     * Build map from logical sectors to physical by going through
     * each track on each side.
     */
    private void buildReverseMap() {
        int totSects = 0;
        for (int head = 0; head < numHeads; head++) {
//LOGGER.info("Head: {} of {}", head, numHeads);
            for (int trackNum = 0; trackNum < numTracks; trackNum++) {
                totSects += tracks[head][trackNum].numSectors;
            }
        }
        logicalMap = new HashMap<SectorMap,SectorMap>(totSects);

        for (int head = 0; head < numHeads; head++) {

            for (int trackNum = 0; trackNum < numTracks; trackNum++) {
                Track t = tracks[head][trackNum];
                for (int sect = 0; sect < t.numSectors; sect++) {
                    SectorMap key = new SectorMap(t.getLogHead(sect),
                        t.getLogTrack(sect), t.getLogSect(sect));
                    SectorMap val = new SectorMap(head, trackNum, sect);
//LOGGER.info("Key {} Value {}", key, val);
                    logicalMap.put(key, val);
                }
            }
        }
//        for (SectorMap s : logicalMap.keySet()) {
//            LOGGER.info("Key {}", s);
//        }
    }

    /*
     * Read each sector on one track and create it as an object.
     *
     * @return index into file after completion.
     */
    private int readSectorsFromArray(byte[] disk, int inx, Track track) {
        for (int i = 0; i < track.numSectors; i++) {
            Sector sector = new Sector();
            track.sectors[i] = sector;
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
                    sector.compressed = false;
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
                    sector.compressed = true;
                    sector.fill = disk[inx++];
                    if (sectorCode == 4 || sectorCode == 8)
                        sector.deleted = true;
                    if (sectorCode == 6 || sectorCode == 8)
                        sector.bad = true;
                    break;
            }
        }
        return inx;
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

    /**
     * Return the label of the IMD file.
     */
    public String getLabel() {
        return label;
    }

    /**
     * Read sector from memory structure.
     * @param side - value 0 or 1.
     * @param track - 0 to numTracks - 1
     * @param sector - sector on track
     */
    public byte[] readSector(int side, int track, int sector) {
        SectorMap key = new SectorMap(side, track, sector);
        SectorMap physLoc = logicalMap.get(key);
        Track t = tracks[physLoc.head][physLoc.track];
        byte[] buf = new byte[t.sectorSize];
        int physSector = physLoc.sector;
        Sector s = t.sectors[physSector];
        if (s.bad)
            throw new RuntimeException("Bad sector");
        if (s.compressed) {
            for (int i = 0; i < t.sectorSize; i++) buf[i] = s.fill;
        } else {
            System.arraycopy(s.data, 0, buf, 0, t.sectorSize);
        }
        return buf;
    }

    /**
     * Get number of sides.
     */
    public int getNumSides() {
        return numHeads;
    }

    /**
     * Get number of tracks on one side.
     */
    public int getNumTracks() {
        return numTracks;
    }

    /**
     * Get number of sectors on a specific physical track.
     *
     * @param side - value 0 or 1.
     * @param track - 0 to numTracks - 1
     * @return number of sectors
     */
    public int getNumSectors(int side, int track) {
        if (track >= numTracks) return -1;
        Track t = tracks[side][track];
        return t.numSectors;
    }


    /**
     * Get size of sectors on a specific physical track.
     */
    public int getSectorSize(int side, int track) {
        Track t = tracks[side][track];
        return t.sectorSize;
    }
/*
    private class TrackHeader {
        byte mode;
        byte cylinder;
        byte head;
        byte sectors;
        byte sectorSize;
    }
*/

    private class SectorMap {
        int head, track, sector;

        SectorMap(int head, int track, int sector) {
            this.head = head;
            this.track = track;
            this.sector = sector;
        }

        @Override
        public String toString() {
            return "{" + Integer.toString(head) + ";" + Integer.toString(track)
                    + ";" + Integer.toString(sector) + "}";
        }

        @Override
        public boolean equals(Object obj) {
            SectorMap mapObj = (SectorMap) obj;
            if (head == mapObj.head && track == mapObj.track && sector == mapObj.sector)
                return true;
            else
                return false;
        }

        @Override
        public int hashCode() {
            int h = (head << 24) + (track << 8) + sector;
            return h;
        }

    }

    private class Sector {
        byte[] data;
        byte fill;
        boolean compressed;
        boolean deleted;
        boolean bad;
        boolean dirty;
    }

    private class Track {
        int side, trackNum, numSectors;
        int sectorSize;
        int transferRate;
        boolean mfm;
        byte[] sectorMap;
        byte[] cylinderMap;
        byte[] headMap;
        Sector[] sectors;
        
        Track(int side, int trackNum, int numSectors) {
            this.side = side;
            this.trackNum = trackNum;
            this.numSectors = numSectors;
            sectorMap = new byte[numSectors];
            cylinderMap = null;
            headMap = null;
            sectors = new Sector[numSectors];
        }
        
        void setSectorMap(byte[] disk, int inx) {
            System.arraycopy(disk, inx, sectorMap, 0, numSectors);
        }

        void setTrackMap(byte[] disk, int inx) {
            cylinderMap = new byte[numSectors];
            System.arraycopy(disk, inx, cylinderMap, 0, numSectors);
        }

        void setHeadMap(byte[] disk, int inx) {
            headMap = new byte[numSectors];
            System.arraycopy(disk, inx, headMap, 0, numSectors);
        }

        /*
         * Find a sector.
         * TODO: invert the table.
         */
        int findSector(int secNum) throws RuntimeException {
            for (int i = 0; i < numSectors; i++) {
                if (sectorMap[i] == secNum) return i;
            }
            throw new RuntimeException("Bad sector number");
        }

        /**
         * Get logical side of physical sector given.
         */
        int getLogHead(int sect) {
            if (headMap == null) return side;
            else return headMap[sect];
        }

        /**
         * Get logical track of physical sector given.
         */
        int getLogTrack(int sect) {
            if (cylinderMap == null) return trackNum;
            else return cylinderMap[sect];
        }

        /**
         * Get logical sector of physical sector given.
         */
        int getLogSect(int sect) {
            if (sectorMap == null) return sect;
            else return sectorMap[sect];
        }

    }

}
