package org.roug.osnine.rbf;

import java.io.RandomAccessFile;
import java.nio.channels.FileChannel;
import java.nio.charset.Charset;
import java.nio.MappedByteBuffer;
import java.nio.charset.StandardCharsets;

//import org.roug.osnine.format.IdentificationSector;

public class Disk {

    private final static int SECTORSIZE = 256;

    private MappedByteBuffer diskBuffer;

    private IdentificationSector idSector;

    /**
     * Constructor.
     */
    public Disk(String diskName) throws Exception {
        FileChannel fileChannel = new RandomAccessFile(diskName, "rw")
                .getChannel();

        diskBuffer = fileChannel.map(FileChannel.MapMode.READ_WRITE, 0,
                fileChannel.size());
        idSector = new IdentificationSector();
    }

    public void close() {
        diskBuffer.force();
        diskBuffer = null;
    }

    /**
     * Get the number of tracks from the identification sector.
     */
    public int numberOfTracks() {
        return (int)diskBuffer.get(IdentificationSector.DD_TKS);
    }

    /**
     * Address of root directory.
     */
    public int getRootLSN() {
        return readTriple(IdentificationSector.DD_DIR);
    }

    /**
     * Get the LSN for a path like /cmds.
     * Device part has been removed already.
     */
    public int getLSNForPath(String path) {
        int rootLSN;

        if ("".equals(path) || "/".equals(path)) {
            return getRootLSN();
        }
        rootLSN = getRootLSN();
        FileDescriptor rootDesc = readFileDescriptor(rootLSN);
        PathDescriptor p = new PathDescriptor(this, rootDesc, 0x81);

        DirEntry de;
        while ((de = p.readNextDirEntry()) != null) {
            if (de.isDeleted()) continue;
            if (path.equalsIgnoreCase(de.getName())) return de.getLSN();
        }
        return getRootLSN();
    }

    /**
     * Read a file descriptor from the disk.
     */
    public FileDescriptor readFileDescriptor(int lsn) {
        SectorSupport sectorBlock = readSector(lsn);
        FileDescriptor desc = new FileDescriptor(sectorBlock);
        return desc;
    }

    /**
     * Write a new disk name to the disk image.
     */
    public void setDiskName(String diskName) {
        if (diskName.length() > 32) {
            throw new RuntimeException("Disk name can be max 32 characters");
        }
        byte[] nameAsBytes = diskName.getBytes(StandardCharsets.US_ASCII);
        diskBuffer.position(0x1F);
        for (int i = 0; i < nameAsBytes.length; i++) {
            if (i == diskName.length() - 1) {
                diskBuffer.put((byte)(nameAsBytes[i] | 0x80));
            } else {
                diskBuffer.put(nameAsBytes[i]);
            }
        }
    }

    /**
     * FIXME: Do an encoding-aware conversion from byte to char.
     *
     * @param location Byte location in disk where the entry is.
     */
    DirEntry readDirEntry(DirEntry de, int location) {
        char[] namebuf = new char[DirEntry.NAMELEN];
        int l;
        for (l = 0; l < DirEntry.NAMELEN; l++) {
            byte c = diskBuffer.get(location + l);
            if (c < 0) {
                namebuf[l] = (char) (c & 0x7F);
                break;
            } else
                namebuf[l] = (char)c;
        }
        de.setName(new String(namebuf, 0, l+1));
        de.setLSN(readTriple(location + 29));
        return de;
    }

    private byte readByte(int location) {
        return (byte)(diskBuffer.get(location) & 0xff);
    }

    private int readWord(int location) {
        return (diskBuffer.get(location) & 0xff) << 8
                | (diskBuffer.get(location + 1) & 0xff);
    }

    private int readTriple(int location) {
        return (diskBuffer.get(location) & 0xff) << 16
                | (diskBuffer.get(location + 1) & 0xff) << 8
                | (diskBuffer.get(location + 2) & 0xff);
    }

    /**
     * Read 4 bytes from the disk.
     */
    private int readQuad(int location) {
        return    (diskBuffer.get(location) & 0xff) << 24
                | (diskBuffer.get(location + 1) & 0xff) << 16
                | (diskBuffer.get(location + 2) & 0xff) << 8
                | (diskBuffer.get(location + 3) & 0xff);
    }

    /**
     * Read a sector from the disk.
     * @param lsn Logical Sector Number
     */
    SectorSupport readSector(int lsn) {
        byte[] sectorBuf = new byte[SECTORSIZE];

        diskBuffer.position(lsn * SECTORSIZE);
        diskBuffer.get(sectorBuf);
        SectorSupport sectorBlock = new SectorSupport(sectorBuf);
        return sectorBlock;
    }

}
