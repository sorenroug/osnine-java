package org.roug.osnine.os9;

/**
 * The DevDrvr class is a base class for virtual devices
 * The methods expect pathnames that are relative to the mount pount
 * and without leading slash.
 */
public class DevDrvr {

    static String type;
    private String mntpoint;
    int errorcode;

    /**
     * Constructor.
     *
     * @param mntpnt - the location in OS9 where the device is located. Usually /term.
     */
    public DevDrvr(final String mntpnt) {
	mntpoint = mntpnt;
    }

    public int getErrorCode() {
        return errorcode;
    }

    public String getMntPoint() {
        return mntpoint;
    }

    /*
     * Not possible
     */
    public PathDesc open(final String path, int mode, boolean create) {
	return null;
    }

    /*
     * Not possible
     */
    public int close(PathDesc pd) {
	return 0;
    }

    /*
     * Not possible
     * 0 = OK, Not 0 means error code
     */
    public int makdir(String path, int mode) {
	return ErrCodes.E_BMode;
    }

    /*
     * Not possible
     * 0 = OK, Not 0 means error code
     */
    int chdir(String path) {
	return ErrCodes.E_BMode;
    }

    /*
     * Not possible
     * 0 = OK, Not 0 means error code
     */
    int delfile(String path) {
	return ErrCodes.E_BMode;
    }

}
