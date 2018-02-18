package org.roug.osnine.format;

import java.util.concurrent.ThreadLocalRandom;

/**
 * The identification sector of an RBF-formatted disk. Always LSN 0.
 */
public class IdentificationSector {

    private final static int MAX_SECTORS = 0xFFFFFF;
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

    /** Number of reading heads. Two for floppy disks */
    private int numHeads = 2;

    /** Total number of sectors on media. */
    private int totalSectors;

    /** Sectors per track. */
    private int sectorsPerTrack = 0;

    /** Number of sectors in a cluster bit. */
    private int clusterSize = 1;

    private String diskName = "NoName";

    private int rootDirLSN;

    void setTotalSectors(int s) {
        if (s > MAX_SECTORS) {
            throw new RuntimeException("Too many sectors to allocate");
        }
        if (s < 4) {
            throw new RuntimeException("Too few sectors to allocate");
        }
        totalSectors = s;
    }

    void setClusterSize(int c) {
        clusterSize = c;
    }

    void setSectorsPerTrack(int s) {
        sectorsPerTrack = s;
    }

    void setRootDir(int s) {
        rootDirLSN = s;
    }

    void setDiskName(String name) {
        if (name.length() > 32) {
            throw new RuntimeException("Disk name can be max 32 characters");
        }
        char[] arr = name.toCharArray();
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] < ' ' || arr[i] > 127) {
                throw new RuntimeException("Only ASCII is allowed");
            }
        }
        diskName = name;
    }

    public byte[] getSector() {
        SectorSupport sector = new SectorSupport();
        int bytesInAllocMap = totalSectors / 8 / clusterSize;

        sector.writeTriple(DD_TOT, totalSectors);
        sector.writeByte(DD_TKS, sectorsPerTrack);
        sector.writeWord(DD_MAP, bytesInAllocMap );

        sector.writeWord(DD_BIT, 1 << (clusterSize - 1));
        // Write FD sector of root directory.
        sector.writeTriple(DD_DIR, rootDirLSN);
        sector.writeWord(DD_OWN, 0); // Owners user number.
        sector.writeByte(DD_ATT, 0xFF);  // Disk attributes
        int randomNum = ThreadLocalRandom.current().nextInt(0, 0x10000);
        sector.writeWord(DD_DSK, randomNum);
        sector.writeByte(DD_FMT, 2 + (numHeads - 1));
        sector.writeWord(DD_SPT, sectorsPerTrack);
        sector.writeWord(DD_RES, 0); // Reserved
        sector.writeTriple(DD_BT, 0);  // Boot sector
        sector.writeWord(DD_BSZ, 0); // Size of boot sector
        sector.writeDate(DD_DAT);
        sector.writeString(DD_NAM, diskName);

        return sector.getSector();
    }
}
