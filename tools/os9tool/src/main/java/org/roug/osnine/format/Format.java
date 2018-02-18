package org.roug.osnine.format;

import java.io.FileOutputStream;
import java.io.OutputStream;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.concurrent.ThreadLocalRandom;
import org.roug.osnine.OptionParser;
import org.roug.osnine.os9.OS9;

/**
 * Format a disk.
 * 
 * Arguments:
 * -c Cluster size (default 1)
 * -h Heads (default 1)
 * -n Disk Name
 * -t Tracks (default 40)
 * -s Sectors (default 18)
 */
public class Format {

    private final static int MAX_SECTORS = 0xFFFFFF;
    private final static int SAS_SIZE = 8;
    private final static int DD_TOT = 0x00;
    private final static int DD_TKS = 0x03;
    private final static int DD_MAP = 0x04;
    private final static int DD_BIT = 0x06;
    private final static int DD_DIR = 0x08;
    private final static int DD_OWN = 0x0B;
    private final static int DD_ATT = 0x0D;
    private final static int DD_DSK = 0x0E;
    private final static int DD_FMT = 0x10;
    private final static int DD_SPT = 0x11;
    private final static int DD_RES = 0x13;
    private final static int DD_BT  = 0x15;
    private final static int DD_BSZ = 0x18;
    private final static int DD_DAT = 0x1A;
    private final static int DD_NAM = 0x1F;
    private final static int DD_OPT = 0x3F;

    /** List of unrecognized command line arguments. */
    private String[] extraArguments = new String[0];

    /** Path to the file where the result shall be generated into. */
    private String outputFilePath = null;

    private String diskName = "NoName";

    /** Number of reading heads. Two for floppy disks */
    private int numHeads = 2;

    /** Number of tracks on disk. */
    private int diskTracks = 40;

    /** Sectors per track. */
    private int sectorsPerTrack = 18;

    /** Number of sectors in a cluster bit. */
    private int clusterSize = 1;

    /** Total number of sectors on media. */
    private int totalSectors;

    /** Buffer to build disk. ID Sector + allocation map + root directory */
    private IdentificationSector idSector;

    /** Disk allocation map. */
    private RBFBitmap allocationMap;

    private OutputStream outputStream;

    private static void usage(String msg) {
        System.err.println("Error: " + msg);
        System.err.println("Usage: format {[<opts>]} <disk>");
        System.err.println("     -c<cluster size>");
        System.err.println("     -h<heads>");
        System.err.println("     -n<disk name>");
        System.err.println("     -t<tracks>");
        System.err.println("     -s<sectors/track>");
        System.exit(2);
    }


    /*
     * Constructor.
     */
    public Format(String[] args) throws Exception {
        long fileSize = 0L;

        OptionParser op = new OptionParser(args, "c:h:n:s:t:");

        // Output name - unused
        outputFilePath = op.getOptionArgument("o");
        if ("-".equals(outputFilePath)) {
            outputFilePath = null; // Linux convention
        }

        String tArg = op.getOptionArgument("t");
        if (tArg != null) {
            diskTracks = Integer.decode(tArg);
        }

        String cArg = op.getOptionArgument("c");
        if (cArg != null) {
            clusterSize = Integer.decode(cArg);
        }

        String hArg = op.getOptionArgument("h");
        if (hArg != null) {
            numHeads = Integer.decode(hArg);
        }

        //FIXME: Allow only 32 bytes.
        String nArg = op.getOptionArgument("n");
        if (nArg != null) {
            diskName = nArg;
            if (diskName.length() > 32) {
                throw new RuntimeException("Disk name can be max 32 characters");
            }
            char[] arr = diskName.toCharArray();
            for (int i = 0; i < arr.length; i++) {
                if (arr[i] < ' ' || arr[i] > 127) {
                    throw new RuntimeException("Only ASCII is allowed");
                }
            }
        }

        String sArg = op.getOptionArgument("s");
        if (sArg != null) {
            sectorsPerTrack = Integer.decode(sArg);
        }


        extraArguments = op.getUnusedArguments();
        if (extraArguments.length == 0) {
            usage("No file argument");
        }
        outputFilePath = extraArguments[0];

        outputStream = System.out;
        if (outputFilePath != null && !outputFilePath.isEmpty()) {
            outputStream = new FileOutputStream(outputFilePath);
        }

        totalSectors = diskTracks * sectorsPerTrack * numHeads;
        if (totalSectors > MAX_SECTORS) {
            throw new RuntimeException("Too many sectors to allocate");
        }
        if (totalSectors < 4) {
            throw new RuntimeException("Too few sectors to allocate");
        }

        int writtenSectors = 0;
        idSector = new IdentificationSector();
        idSector.setTotalSectors(totalSectors);
        idSector.setClusterSize(clusterSize);
        idSector.setSectorsPerTrack(sectorsPerTrack);
        idSector.setDiskName(diskName);

        int bytesInAllocMap = totalSectors / 8 / clusterSize;

        allocationMap = new RBFBitmap(totalSectors, clusterSize);
        allocationMap.allocateBit(0, allocationMap.getSectorsInAllocMap() + 1);

        FileDescriptor rootFD = new FileDescriptor();
        rootFD.setAttributes(0xBF);
        rootFD.setOwner(0);
        rootFD.setLinkCount(2);
        rootFD.setSize(64);

        Directory rootDir = new Directory();
        Segment rootFDLsn = allocationMap.getSegment(1);
        rootDir.addDirEntry("..", rootFDLsn.lsn);
        rootDir.addDirEntry(".", rootFDLsn.lsn);
        idSector.setRootDir(rootFDLsn.lsn);
        Segment rootDirLSN = allocationMap.getSegment(SAS_SIZE - 1);
        rootFD.addSegment(rootDirLSN);

        byte[] idBytes = idSector.getSector();

        outputStream.write(idBytes, 0 , idBytes.length);
        writtenSectors++;

        idBytes = allocationMap.getSectors();
        outputStream.write(idBytes, 0 , idBytes.length);
        writtenSectors += allocationMap.getSectorsInAllocMap();

        idBytes = rootFD.getSector();
        outputStream.write(idBytes, 0 , idBytes.length);
        writtenSectors++;

        for (int i = 0; i < SAS_SIZE - 1; i++) {
            idBytes = rootDir.getSector(i);
            outputStream.write(idBytes, 0 , idBytes.length);
        }
        writtenSectors += SAS_SIZE - 1;

        idBytes = new byte[256];
        for (int i = 0; i < 256; i++) {
            idBytes[i] = (byte)0xE5;
        }
        // Fill the disk
        for (int i = writtenSectors; i < totalSectors; i++) {
            outputStream.write(idBytes, 0 , idBytes.length);
        }

        outputStream.close();
    }

}
