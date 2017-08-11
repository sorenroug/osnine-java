package org.roug.osnine.os9;

/*
 * File access codes.
 *
 */
public interface AccessCodes {
    int READ = 0x01;
    int WRITE = 0x02;
    int UPDATE = 0x03;
    int EXEC = 0x04;
    int PREAD = 0x08;
    int PWRIT = 0x10;
    int PEXEC = 0x20;
    int SHARE = 0x40; 
    int DIR = 0x80;
}
