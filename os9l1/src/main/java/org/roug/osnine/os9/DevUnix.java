package org.roug.osnine.os9;

import java.io.File;
import java.nio.file.attribute.FileAttribute;
import java.nio.file.attribute.PosixFilePermission;
import java.nio.file.attribute.PosixFilePermissions;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Set;
import java.util.TreeSet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Dev driver methods for UNIX file system.
 * The methods expect pathnames that are relative to the mount pount
 * and without leading slash.
 */
public class DevUnix extends DevDrvr {

    /** Location in UNIX directory tree where the files are. */
    private String unixDir;

    /** Whether to convert OS9 line endings to UNIX. */
    private static boolean unixEOLs = true;

    private static final Logger LOGGER = LoggerFactory.getLogger(DevUnix.class);


    /**
     * Constructor.
     *
     * @param mntpnt - Name of device in OS9
     * @param args - Location in UNIX directory
     */
    public DevUnix(final String mntpnt, final String args) {
        super(mntpnt);
        unixDir = args;
    }

    /**
     * Open a file.
     * TODO: Go through the path to see if the path actually exists
     */
    @Override
    public PathDesc open(final String path, int mode, boolean create) {
        Path unixPath;
        PDUnix fd = null;
        String relPath;

        if (path.startsWith("/")) {
            relPath = path.substring(getMntPoint().length());
        } else {
            relPath = path;
        }
        unixPath = Paths.get(unixDir, relPath);
        LOGGER.debug("UNIX path: {}", unixPath);
        Path realPath = findpath(unixPath, !create);
        if (realPath == null) {
            errorcode = ErrCodes.E_PNNF;
            return null;
        }
        try {
            fd = new PDUnix(realPath, mode, create);
            fd.setDriver(this);
        } catch (Exception e) {
            errorcode = ErrCodes.E_BPNam;
        }
        return fd;
    }

    @Override
    public int makdir(String path, int mode) {
        Path unixPath;
        String relPath;

        if (path.startsWith("/")) {
            relPath = path.substring(getMntPoint().length());
        } else {
            relPath = path;
        }
        unixPath = Paths.get(unixDir, relPath);
        LOGGER.debug("UNIX path: {}", unixPath);
        Path realPath = findpath(unixPath, false);
        LOGGER.debug("Real path: {}", realPath);
        if (realPath == null) {
            errorcode = ErrCodes.E_PNNF;
            return errorcode;
        }
        try {
            Files.createDirectory(unixPath, o2u_attr(mode));
        } catch (Exception e) {
            errorcode = ErrCodes.E_CEF;
            return errorcode;
        }
        return 0;
    }

    /**
     * Delete a file.
     * TODO: return more meaningful error code
     */
    @Override
    public int delfile(String path) {
        Path unixPath;
        String relPath;

        if (path.startsWith("/")) {
            relPath = path.substring(getMntPoint().length());
        } else {
            relPath = path;
        }
        unixPath = Paths.get(unixDir, relPath);
        LOGGER.debug("UNIX path: {}", unixPath);
        Path realPath = findpath(unixPath, true);
        LOGGER.debug("Real path: {}", realPath);
        if (realPath == null) {
            errorcode = ErrCodes.E_PNNF;
            return errorcode;
        }
        try {
            Files.delete(unixPath);
        } catch (Exception e) {
            errorcode = ErrCodes.E_CEF;
            return errorcode;
        }
        return 0;
    }

    /**
     * Change directory.
     * TODO: Go through the path to see if the path actually exists
     */
    @Override
    public int chdir(String path) {
        return 0;
    }

    static FileAttribute<Set<PosixFilePermission>> o2u_attr(int omode) {
        TreeSet<PosixFilePermission> umode = new TreeSet<PosixFilePermission>();
        if ((omode & 1) == 1)  umode.add(PosixFilePermission.OWNER_READ);
        if ((omode & 2) == 2)  umode.add(PosixFilePermission.OWNER_WRITE);
        if ((omode & 4) == 4)  umode.add(PosixFilePermission.OWNER_EXECUTE);
        if ((omode & 8) == 8) {
            umode.add(PosixFilePermission.GROUP_READ);
            umode.add(PosixFilePermission.OTHERS_READ);
        }
        if ((omode & 16) == 16) {
            umode.add(PosixFilePermission.GROUP_WRITE);
            umode.add(PosixFilePermission.OTHERS_WRITE);
        }
        if ((omode & 32) == 32) {
            umode.add(PosixFilePermission.GROUP_EXECUTE);
            umode.add(PosixFilePermission.OTHERS_EXECUTE);
        }
        return PosixFilePermissions.asFileAttribute(umode);
    }

    /**
     * Find the UNIX file from the OS9 path. The OS9 path
     * is case-insensive, so we have to check every directory.
     *
     * @param path - OS9 path.
     * @param mustexist - ?
     */
    static Path findpath(Path path, boolean mustexist) {
        String startFrom;
        int alreadyMatched = 0;

        path = path.normalize();
        if (path.startsWith("/")) {
            startFrom = "/";
        } else {
            startFrom = ".";
        }
        File newUnixFile = new File(startFrom);
        int segmentCnt = path.getNameCount();

        boolean found = false;
        while (alreadyMatched < segmentCnt) {
            found = false;
            for (File dirEntry : newUnixFile.listFiles()) {
                String nextOS9Seg = path.getName(alreadyMatched).toString();
                String nextUNXSeg = dirEntry.getName();
                if (nextUNXSeg.equalsIgnoreCase(nextOS9Seg)) {
                    alreadyMatched++;
                    newUnixFile = new File(newUnixFile, nextUNXSeg);
                    found = true;
                    break;
                }
            }
            if (!found) {
                break;
            }
        }
        LOGGER.debug("Found path: {}", newUnixFile);
        // Some intermediate segment is missing.
        if (alreadyMatched < segmentCnt - 1) {
            return null;
        }
        if (mustexist && !found) {
            return null;
        }
        if (!mustexist && !found) {
            newUnixFile = new File(newUnixFile, path.toFile().getName());
        }
        return newUnixFile.toPath();
    }

    /**
     * Tell path descriptors to convert to UNIX line endings.
     *
     * @param useUNIX - If true then use UNIX.
     */
    public static void setUNIXSemantics(boolean useUNIX) {
        unixEOLs = useUNIX;
    }

    public static boolean convertToUNIX() {
        return unixEOLs;
    }

}
