package org.roug.osnine.os9;

/*
 * File access codes.
 *
 */
public interface AccessCodes {
    public static final int READ = 0x01;
    public static final int WRITE = 0x02;
    public static final int UPDATE = 0x03;
    public static final int EXEC = 0x04;
    public static final int PREAD = 0x08;
    public static final int PWRIT = 0x10;
    public static final int PEXEC = 0x20;
    public static final int SHARE = 0x40; 
    public static final int DIR = 0x80;
}
