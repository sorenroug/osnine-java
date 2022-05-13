package org.roug.usim;

import java.io.File;
import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.io.FileNotFoundException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Load Read/write a disk image in ImageDisk format.
 * Since sectors can be compressed, there is no random access.
 * You must read the image into memory and then parse it into the structure.
 *
 */
public class IMDHandler {

    public static final int MAX_SIDES = 2;
    public static final int MAX_TRACKS = 80;
    public static final int MAX_SECTORS = 30;

    private byte[] data;

    private String label;

    private String header;

    /** Number of heads on media: 1 or 2. */
    private int numHeads;

    /** Number of tracks on one side. */
    private int numTracks;

    private boolean readOnly;

    private File imageFile;

    /** Tracks on disk. First index is side, second track number. */
    private Track[][] tracks;

    /** Mapping from logical head,track,sect to physical. */
    private HashMap<SectorMap,SectorMap> logSectMap;

    /** Mapping from logical head,track to physical. */
    private HashMap<TrackMap,TrackMap> logTrackMap;

    private static final Logger LOGGER =
                LoggerFactory.getLogger(IMDHandler.class);

    /**
     * Constructor.
     * TODO
     */
    /*
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
    */

    /**
     * Constructor. Loads the ImageDisk file.
     *
     * @param fileName - path of file to load.
     * @throws java.io.IOException if file doesn't match format
     */
    public IMDHandler(String fileName) throws IOException {
        this(new File(fileName));
    }

    /**
     * Constructor. Loads the ImageDisk file.
     *
     * @param imdFile - file to load.
     * @throws java.io.IOException if file doesn't match format
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
        ByteArrayInputStream bdisk = new ByteArrayInputStream(disk);

        // Verify format
        if (disk[0] != 'I' || disk[1] != 'M' || disk[2] != 'D')
            throw new IOException("Bad file format");

        int hEnd = headerLen(disk, 0);
        try {
            header = new String(disk, 0, hEnd - 2, "US-ASCII");
        } catch (UnsupportedEncodingException e) {
            throw new IOException("Bad header in file");
        }

        // Read label
        int inx = labelLen(disk, hEnd);
        try {
            label = new String(disk, hEnd, inx - hEnd, "US-ASCII");
        } catch (UnsupportedEncodingException e) {
            throw new IOException("Bad label in file");
        }

        // Read tracks
        inx++;
        bdisk.reset();
        bdisk.skip(inx);
        numTracks = 0;
        while (bdisk.available() > 0) {
            int mode = bdisk.read();
            if (mode < 0 || mode > 5)
                throw new IOException("Unsupported mode");

            int trackNum = bdisk.read();
            int head = bdisk.read();
            int numSectors = bdisk.read();
            Track track = new Track(head, trackNum, numSectors);
            track.mode = mode;
            track.sectorType = bdisk.read();
            if (track.sectorType > 6)
                throw new IOException("Unsupported sector size");
            track.sectorSize = (1 << track.sectorType) * 128;
            boolean hasCylMap = (head & 0x80) == 0x80;
            boolean hasHeadMap = (head & 0x40) == 0x40;
            head &= 0x01;
            if (head > numHeads - 1) numHeads = head + 1;

            track.setSectorMap(bdisk);
//LOGGER.info("Side {} track {} sector map {}", head, trackNum, track.sectorMap);
            // Read sector cylinder map
            if (hasCylMap) {
                track.setSectCylMap(bdisk);
//LOGGER.info("Side {} track {} cylinder map {}", head, trackNum, track.sectCylMap);
            }
            // Read sector head map
            if (hasHeadMap) {
                track.setHeadMap(bdisk);
//LOGGER.info("Side {} track {} head map {}", head, trackNum, track.headMap);
            }
//LOGGER.info("Inx: {}", inx);
            readSectorsFromArray(bdisk, track);
            tracks[head][trackNum] = track;
            if (trackNum > numTracks) numTracks = trackNum;
        }
        bdisk.close();
        numTracks++;  // Count track 0
        buildReverseMap();
    }

    /*
     * Build map from logical sectors to physical by going through
     * each track on each side.
     */
    private void buildReverseMap() {
        int totSects = 0;
        for (int head = 0; head < numHeads; head++) {
            for (int trackNum = 0; trackNum < numTracks; trackNum++) {
                totSects += tracks[head][trackNum].numSectors;
            }
        }
        logSectMap = new HashMap<SectorMap,SectorMap>(totSects);
        logTrackMap = new HashMap<TrackMap,TrackMap>(numHeads * numTracks);

        for (int head = 0; head < numHeads; head++) {

            for (int trackNum = 0; trackNum < numTracks; trackNum++) {
                Track track = tracks[head][trackNum];
                TrackMap tkey = new TrackMap(track.getLogHead(0),
                        track.getLogTrack(0));
                TrackMap tval = new TrackMap(head, trackNum);
                logTrackMap.put(tkey, tval);
                for (int sect = 0; sect < track.numSectors; sect++) {
                    SectorMap key = new SectorMap(track.getLogHead(sect),
                        track.getLogTrack(sect), track.getLogSect(sect));
                    SectorMap val = new SectorMap(head, trackNum, sect);
//LOGGER.info("Key {} Value {}", key, val);
                    logSectMap.put(key, val);
                }
            }
        }
//        for (SectorMap s : logSectMap.keySet()) {
//            LOGGER.info("Key {}", s);
//        }
    }

    /**
     * Is track MFM?
     *
     * @param head - logical side of disk.
     * @param trackNum - logical track number.
     * @return true if the track is MFM mode, false if FM.
     */
    public boolean isMFM(int head, int trackNum) {
        Track t = getPhysTrack(head, trackNum);

        switch (t.mode) {
            case 0: 
            case 1:
            case 2:
                return false;
            case 3:
            case 4:
            case 5:
                return true;
            default:
                throw new RuntimeException("Unsupported mode");
        }
    }

    /**
     * Get transfer rate for track.
     * These should be identical for all tracks.
     *
     * @param head - logical side of disk.
     * @param trackNum - logical track number.
     * @return transfer rate in bytes per second.
     */
    public int getTransferRate(int head, int trackNum) {
        Track t = getPhysTrack(head, trackNum);

        switch (t.mode) {
            case 0:
            case 3:
                return 500;
            case 1:
            case 4:
                return 300;
            case 2:
            case 5:
                return 250;
            default:
                throw new RuntimeException("Unsupported mode");
        }
    }

    private Track getPhysTrack(int head, int trackNum) {
        TrackMap key = new TrackMap(head, trackNum);
        TrackMap physLoc = logTrackMap.get(key);
        return tracks[physLoc.head][physLoc.track];
    }

    /**
     * Read each sector on one track and create it as an object.
     *
     * @return index into file after completion.
     */
    private void readSectorsFromArray(ByteArrayInputStream bdisk, Track track) {
        for (int i = 0; i < track.numSectors; i++) {
            Sector sector = new Sector();
            sector.sectorSize = track.sectorSize;
            track.sectors[i] = sector;
            int sectorCode = bdisk.read();
            switch (sectorCode) {
                // 00      Sector data unavailable - could not be read
                case 0:
                    sector.unavailable = true;
                    sector.readError = true;
                    break;
                // 01 .... Normal data: (Sector Size) bytes follow
                // 03 .... Normal data with "Deleted-Data address mark"
                // 05 .... Normal data read with data error
                case 1:
                case 3:
                case 5:
                    sector.compressed = false;
                    sector.data = new byte[track.sectorSize];
                    bdisk.read(sector.data, 0, track.sectorSize);
                    if (sectorCode == 3 || sectorCode == 7)
                        sector.deleted = true;
                    if (sectorCode == 5 || sectorCode == 7)
                        sector.readError = true;
                    break;
                // 02 xx   Compressed: All bytes in sector have same value (xx)
                // 04 xx   Compressed  with "Deleted-Data address mark"
                // 06 xx   Compressed  read with data error
                case 2:
                case 4:
                case 6:
                    sector.compressed = true;
                    sector.fill = (byte) bdisk.read();
                    if (sectorCode == 4 || sectorCode == 8)
                        sector.deleted = true;
                    if (sectorCode == 6 || sectorCode == 8)
                        sector.readError = true;
                    break;
            }
        }
    }

    private int headerLen(byte[] disk, int inx) {
        for (; inx < disk.length; inx++) {
            if (disk[inx] == 0x0A) break;
        }
        return inx + 1;
    }

    /**
     * Return the label of the IMD file.
     *
     * @return the comment.
     */
    public String getHeader() {
        return header;
    }

    private static final String DATE_TIME_FORMAT = "'IMD' 1.18: dd/MM/yyyy hh:mm:ss";

    /** Date-time format. */
    private static SimpleDateFormat dateTimeFormat = new SimpleDateFormat(DATE_TIME_FORMAT);

    public void newHeader() {
        setHeader(new Date());
    }

    public void setHeader(Date newDate) {
        header = dateTimeFormat.format(newDate);
    }

    /**
     * Return the length of the label.
     * Size of header is one larger.
     */
    private int labelLen(byte[] disk, int inx) {
        for (; inx < disk.length; inx++) {
            if (disk[inx] == 0x1A) break;
        }
        return inx;
    }

    /**
     * Return the label of the IMD file.
     *
     * @return label
     */
    public String getLabel() {
        return label;
    }

    /**
     * Set a new label - must be ASCII.
     *
     * @param newLabel - New label.
     */
    public void setLabel(String newLabel) {
        label = newLabel;
    }

    private Sector getPhysSector(int head, int trackNum, int sector) throws IOException {
        SectorMap key = new SectorMap(head, trackNum, sector);
        SectorMap physLoc = logSectMap.get(key);
        if (physLoc == null)
            throw new IOException("No such sector on disk");
        Track t = tracks[physLoc.head][physLoc.track];
        int physSector = physLoc.sector;
        return t.sectors[physSector];
    }


    /**
     * Save disk to file.
     *
     * @param imdFile - The name of the file to save to.
     * @throws java.io.FileNotFoundException - if unable to write to file's directory
     * @throws java.io.UnsupportedEncodingException if comment is not ASCII
     * @throws java.io.IOException if unable to write file
     */
    public void saveDisk(File imdFile) throws FileNotFoundException,
            UnsupportedEncodingException, IOException {
        FileOutputStream outFp = new FileOutputStream(imdFile);
        try {
            outFp.write(header.getBytes("US-ASCII"));
            outFp.write(0x0D);
            outFp.write(0x0A);
            outFp.write(label.getBytes("US-ASCII"));
            outFp.write(0x1A);
            Track track;
            for (int h = 0; h < numHeads; h++) {
                for (int t = 0; t < numTracks; t++) {
                    track =  tracks[h][t];
                    outFp.write(track.mode);
                    outFp.write(track.trackNum);
                    outFp.write(track.side);
                    outFp.write(track.numSectors);
                    outFp.write(track.sectorType);
                    outFp.write(track.sectorMap);
                    if (track.sectCylMap != null)
                        outFp.write(track.sectCylMap);
                    if (track.headMap != null)
                        outFp.write(track.headMap);
                    for (int s = 0; s < track.numSectors; s++) {
                        Sector sector = track.sectors[s];
                        outFp.write(makeSectorCode(sector));
                        if (sector.unavailable) continue;
                        if (sector.compressed) outFp.write(sector.fill);
                        else outFp.write(sector.data);
                    }
                }
            }
        } finally {
            outFp.close();
        }
    }

    /**
     * Create sector code from flags.
     * This can not be done with bit masks.
     *
     * @param sector - the sector object.
     */
    private int makeSectorCode(Sector sector) {
        if (sector.unavailable) return 0;

        if (sector.compressed) {
            if (sector.readError) {
                if (sector.deleted) return 8;
                else return 6;
            } else {
                if (sector.deleted) return 4;
                else return 2;
            }
        } else {
            if (sector.readError) {
                if (sector.deleted) return 7;
                else return 5;
            } else {
                if (sector.deleted) return 3;
                else return 1;
            }
        }
    }

    /**
     * Read sector from memory structure.
     * Logical numbering
     *
     * @param side - value 0 or 1.
     * @param track - 0 to numTracks - 1
     * @param sector - sector on track
     * @return array of bytes
     * @throws java.io.IOException if unable to read sector
     */
    public byte[] readSector(int side, int track, int sector) throws IOException {
        Sector s  = getPhysSector(side, track, sector);
        if (s.unavailable)
            throw new IOException("Sector unavailable");
        byte[] buf = new byte[s.sectorSize];
        if (s.compressed) {
            // for (int i = 0; i < s.sectorSize; i++) buf[i] = s.fill;
            Arrays.fill(buf, s.fill);
        } else {
            System.arraycopy(s.data, 0, buf, 0, s.sectorSize);
        }
        return buf;
    }

    /**
     * Write sector into memory structure.
     * Logical numbering
     *
     * @param side - value 0 or 1.
     * @param track - 0 to numTracks - 1
     * @param sector - sector on track
     * @param data - Date to write to the sector.
     *
     * @throws java.io.IOException if unable to read sector
     */
    public void writeSector(int side, int track, int sector, byte[] data)
                throws IOException {
        Sector s  = getPhysSector(side, track, sector);
        if (data.length != s.sectorSize)
            throw new IOException("Bad size of buffer");
        s.unavailable = false;
        s.readError = false;

        boolean compressable = true;
        for (int i = 0; i < s.sectorSize; i++) {
            if (data[i] != data[0]) {
                compressable = false;
                break;
            }
        }
        if (compressable) {
            s.fill = data[0];
            s.compressed = true;
            s.data = null;
        } else {
            if (s.compressed) {
                s.compressed = false;
                s.data = Arrays.copyOf(data, data.length);
            } else { // Reuse array
                System.arraycopy(data, 0, s.data, 0, s.sectorSize);
            }
        }
    }

    /**
     * Determine if a sector had read errors when read.
     * There might still be data, but the CRC was wrong.
     * Logical sector addressing.
     *
     * @param side - value 0 or 1.
     * @param track - 0 to numTracks - 1
     * @param sector - sector on track
     * @return true is track is bad
     * @throws java.io.IOException if unable to read sector
     */
    public boolean isBadSector(int side, int track, int sector)
                throws IOException {
        Sector s  = getPhysSector(side, track, sector);
        return s.readError;
    }

    /**
     * Get number of physical sides.
     * It is possible for a disk format to continue the numbering of sectors
     * on the next side, pretending the disk has only one side.
     *
     * @return number of sides.
     */
    public int getNumSides() {
        return numHeads;
    }

    /**
     * Get number of physical tracks on one side.
     *
     * @return number of tracks.
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
     *
     * @param side - value 0 or 1.
     * @param track - 0 to numTracks - 1
     * @return number of sectors.
     */
    public int getSectorSize(int side, int track) {
        Track t = tracks[side][track];
        return t.sectorSize;
    }

    /**
     * Map logical head and track to physical head and track.
     */
    private class TrackMap {
        int head, track;

        TrackMap(int head, int track) {
            this.head = head;
            this.track = track;
        }

        @Override
        public String toString() {
            return "{" + Integer.toString(head) + ";" + Integer.toString(track) + "}";
        }

        @Override
        public boolean equals(Object obj) {
            if (obj == null) return false;
            TrackMap mapObj = (TrackMap) obj;
            if (head == mapObj.head && track == mapObj.track)
                return true;
            else
                return false;
        }

        @Override
        public int hashCode() {
            int h = (head << 24) + (track << 8);
            return h;
        }

    }

    /**
     * Map logical head, track and to physical head, track and sector.
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
            if (obj == null) return false;
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

    private static class Sector {
        int sectorSize;
        byte[] data;
        byte fill;
        boolean compressed;
        boolean deleted;
        boolean readError;
        boolean unavailable;
    }

    /**
     * CLASS: Track.
     */
    private class Track {
        int side, trackNum, numSectors;
        int sectorType;
        int sectorSize;
        int mode;
        byte[] sectorMap;
        byte[] sectCylMap;
        byte[] headMap;
        Sector[] sectors;
        
        Track(int side, int trackNum, int numSectors) {
            this.side = side;
            this.trackNum = trackNum;
            this.numSectors = numSectors;
            sectorMap = new byte[numSectors];
            sectCylMap = null;
            headMap = null;
            sectors = new Sector[numSectors];
        }
        
        void setSectorMap(ByteArrayInputStream bdisk) {
            bdisk.read(sectorMap, 0, numSectors);
        }

        void setSectCylMap(ByteArrayInputStream bdisk) {
            sectCylMap = new byte[numSectors];
            bdisk.read(sectCylMap, 0, numSectors);
        }

        void setHeadMap(ByteArrayInputStream bdisk) {
            headMap = new byte[numSectors];
            bdisk.read(headMap, 0, numSectors);
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
            if (sectCylMap == null) return trackNum;
            else return sectCylMap[sect];
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
