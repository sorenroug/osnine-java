package org.roug.osnine.format;


/**
 * Bitmap in an RBF disk.
 * FIXME: Only works if cluster size is 1.
 */
public class RBFBitmap {

    private final static int SECTOR_SIZE = 256;

    /** Disk allocation map. */
    private byte[] allocationMap;

    private int bytesInAllocMap;

    private int totalSectors;

    private int clusterSize;

    public RBFBitmap(int totalSectors, int clusterSize) {

        this.totalSectors = totalSectors;
        this.clusterSize = clusterSize;
        bytesInAllocMap = totalSectors / 8 / clusterSize;

        // Allocation map
        allocationMap = new byte[getSectorsInAllocMap() * SECTOR_SIZE];
        for (int i = 0; i < bytesInAllocMap; i++) {
            allocationMap[i] = 0;
        }
        for (int i = bytesInAllocMap; i < allocationMap.length; i++) {
            allocationMap[i] = -1;
        }

        // TODO: Mark the size of the allocation map as reserved + sector 1
    }

    int getSectorsInAllocMap() {
        if (bytesInAllocMap % SECTOR_SIZE == 0) {
            return bytesInAllocMap / SECTOR_SIZE;
        } else {
            return bytesInAllocMap / SECTOR_SIZE + 1;
        }
    }

    /**
     * Allocate bit in bitmap.
     * Only used if there is a bit to allocate.
     */
    void allocateBit(int firstBit, int numBits) {
        int startByte, startBit;

        startByte = firstBit / 8;
        startBit = firstBit % 8;

        for (int i = 0; i < numBits; i++) {
            if (startBit > 7) {
                startBit = 0;
                startByte++;
            }
            allocationMap[startByte] |= (1 << 7 - startBit++);
        }

    }

    private void deleteBit(int firstBit, int numBits) {
        int startByte, startBit;

        startByte = firstBit / 8;
        startBit = firstBit % 8;

        for (int i = 0; i < numBits; i++) {
            if (startBit > 7) {
                startBit = 0;
                startByte++;
            }
            allocationMap[startByte] &= ~(1 << 7 - startBit++);
        }
    }

    private boolean checkBit(int lsn) {
        int startByte, startBit;

        startByte = lsn / 8;
        startBit = lsn % 8;

        return (allocationMap[startByte] & (1 << 7 - startBit)) != 0;
    }

    /**
     * Find one free bit.
     */
    int getFreeBit() {
        for(int i = 2; i < totalSectors; i++) {
            if(!checkBit(i)) {
                // bit is clear, sector is free
                allocateBit(i, 1);    // Allocate sector
                return(i);            // Return sector
            }
        }
        return( -1 );
    }

    /**
     * Allocate a segment of specified sectors.
     * @param pd_sas - Sector Allocation Size - sectors to allocate
     * @return The location of the first sector
     */
    Segment getSegment(int pd_sas) {
        int i, count;

        // Sanity check pd_sas
        // FIXME: Throw exception

        if( pd_sas < 1 || pd_sas > (totalSectors / 2) ) {
            pd_sas = 1;
        }

        // Now go and find SAS number of contiguous clusters

        i = count = 0;
        while(count < pd_sas) {
            if (i > totalSectors)
                return null;

            if (!checkBit(i++)) {
                // Bit is clear
                count++;
            } else {
                count = 0;
            }
        }
        if(i > totalSectors) {
            throw new RuntimeException("Bitmap full");
        }
        Segment newSegment = new Segment();
        newSegment.lsn = i - count;
        newSegment.num = count;
        allocateBit(newSegment.lsn, newSegment.num);
        return newSegment;
    }

    public byte[] getSectors() {
        return allocationMap;
    }

}

