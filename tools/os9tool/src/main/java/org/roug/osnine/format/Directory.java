package org.roug.osnine.format;

import java.util.List;
import java.util.ArrayList;

class DirEntry {
    String name;
    int lsn;
}

public class Directory {
    private final static int ENTRIES_IN_SECTOR = 256 / 32;

    private ArrayList<DirEntry> entries;

    /** Constructor. */
    public Directory() {
        entries = new ArrayList<DirEntry>();
    }

    /**
     * Add a directory entry.
     * TODO: Don't allow the same name (case-insensitive) on the list twice.
     */
    public void addDirEntry(String name, int lsn) throws Exception {
        DirEntry de = new DirEntry();
        if (name.length() > 29) {
            throw new RuntimeException("File name too long");
        }
        de.name = name;
        de.lsn = lsn;
        entries.add(de);
    }

    /**
     * Remove a directory entry.
     * TODO:
     */

    /**
     * Get a sector to write to disk.
     *
     * @param sectorInx - The sector to write.
     */
    public byte[] getSector(int sectorInx) {
        SectorSupport sector = new SectorSupport();
        int startOffset = sectorInx * ENTRIES_IN_SECTOR;

        if (startOffset > entries.size()) {
            return sector.getSector();
        }
        int endOffset = startOffset + ENTRIES_IN_SECTOR;
        if (endOffset > entries.size()) {
            endOffset = entries.size();
        }
        int inx = 0;
        for (int i = startOffset; i < endOffset; i++) {
            sector.writeString(inx, entries.get(i).name);
            inx += 29;
            sector.writeTriple(inx, entries.get(i).lsn);
            inx += 3;
        }
        return sector.getSector();
    }

}
