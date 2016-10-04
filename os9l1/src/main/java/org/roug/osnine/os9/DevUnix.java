package org.roug.osnine.os9;

import java.io.RandomAccessFile;
import java.io.FileNotFoundException;
import java.util.Set;
import java.util.TreeSet;
import java.io.File;
import java.nio.file.attribute.PosixFilePermission;
import java.nio.file.attribute.PosixFilePermissions;
import java.nio.file.attribute.FileAttribute;
import java.nio.file.Path;
import java.nio.file.Files;
import java.nio.file.Paths;

class DevUnix extends DevDrvr {

    private String unixDir;

    /*********************************************************************
     * DevUnix methods
     *********************************************************************/
    // The DevDrvr class is a base class for virtual devices
    // The methods expect pathnames that are relative to the mount pount
    // and without leading slash.

    public DevUnix(final String mntpnt, final String args) {
        super(mntpnt);
        unixDir = args;
    }

    /**
     * Open a file.
     * @todo: Go through the path to see if the path actually exists
     * @todo: Open in other modes than read
     */
    @Override
    public PathDesc open(final String path, int mode, boolean create) {
        Path unixPath;
        String umode = "r";
        PDUnix fd = null;
        String relPath;

        if (path.startsWith("/")) {
            relPath = path.substring(getMntPoint().length());
        } else {
            relPath = path;
        }
        unixPath = Paths.get(unixDir, relPath);
        System.err.println("COMBINED: " + unixPath);
        if (findpath(unixPath, !create) == null) {
            errorcode = 216;
            return null;
        }
        switch(mode & 3) {
        case 0:
        case 1: umode="r";
            break;
        case 2: umode="rw";
            break;
        case 3: umode = (create) ? "rw" : "rw";
            break;
        }
        try {
            fd = new PDUnix(unixPath, umode);
            fd.setDriver(this);
        } catch (FileNotFoundException e) {
            errorcode = ErrCodes.E_BPNam;
        }
        return fd;
    }

/*
    public PathDesc open(RandomAccessFile unixfp) {
        PDUnix fd = new PDUnix();
        
        fd.fp = unixfp;
        fd.usecount = 1;
        fd.driver = this;
        return fd;
    }
*/

    @Override
    public int makdir(String path, int mode) {
        Path unixPath;

        unixPath = Paths.get(unixDir, path);

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
     * @todo: return more meaningful error code
     */
    public int delfile(String path) {
        Path unixPath;

        unixPath = Paths.get(unixDir, path);

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
     * @todo: Go through the path to see if the path actually exists
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
     * Return the real file name of the segment or NULL.
     * You can then append the segment to dir and try again
     * Case insensitive.
     */
    static String findpathseg(String dir, String segment) {
    //FIXME
    /*
        DIR *dirp;
        struct dirent *dp;
     
        dirp = opendir(dir);
        while ((dp = readdir(dirp))) {
            if (strcasecmp(dp->d_name, segment) == 0)
                break;
        }
        closedir(dirp);
        if (dp)
            return dp->d_name;
        else
            return null;
    */
    return null;
    }

    /**
     * Find the UNIX file from the OS9 path. The OS9 path
     * is case-insensive, so we have to check every directory.
     *
     * @param path - OS9 path.
     * @param mustexist - ?
     */
    //FIXME
    static String findpath(Path path, boolean mustexist) {
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
        while (alreadyMatched < segmentCnt) {
            boolean found = false;
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
                return null;
            }
        }
        return newUnixFile.toString();
    /*
        char *endp, *endseg, *begseg;
        char *dirp, *nseg;
     
        endp = path + strlen(path);
     
        if (*path == '/') {
            dirp = "/";
            begseg = path + 1;
        } else {
            dirp = ".";
            begseg = path;
        }
     
        do {
            endseg = strchr(begseg, '/');
            if (endseg == null)
                endseg = endp;
            *endseg = 0;
            nseg = findpathseg(dirp, begseg);
            if (endseg != endp && !nseg)
                return null;
            if (nseg)
                strcpy(begseg, nseg);
            if (dirp == path)
               begseg[-1] = '/';
            dirp = path;
            begseg = endseg +1;
        } while (endseg != endp);
        if (mustexist && !nseg)
            return null;
        return path;
    */

    }

} 
