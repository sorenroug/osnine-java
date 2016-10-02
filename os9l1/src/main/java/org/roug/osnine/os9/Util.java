package org.roug.osnine.os9;

/**
 * Null file descriptor. All reads return nothing.
 */
public class Util {

    static public String getErrorMessage(int errCode) {
	return String.format("ERROR #%d %s", errCode, ErrMsg.errmsg[errCode]);
    }

}
