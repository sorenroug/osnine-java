package org.roug.osnine.os9;

/*
 * File access codes.
 *
 */
public interface AccessCodes {
    static final int READ = 0x01;
    static final int WRITE = 0x02;
    static final int UPDATE = 0x03;
    static final int EXEC = 0x04;
    static final int PREAD = 0x08;
    static final int PWRIT = 0x10;
    static final int PEXEC = 0x20;
    static final int SHARE = 0x40; 
    static final int DIR = 0x80;
}
