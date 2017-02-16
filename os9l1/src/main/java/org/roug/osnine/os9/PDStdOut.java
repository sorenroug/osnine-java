package org.roug.osnine.os9;

import java.io.PrintStream;
import java.io.RandomAccessFile;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.nio.file.Path;

/**
 * A path descriptor that wraps the Java stdout and stderr.
 */
class PDStdOut extends PathDesc {

    PrintStream fp;

    public PDStdOut(PrintStream fp) {
        super();
        usecount++;
        this.fp = fp;
    }


    @Override
    public int close() {
        if (usecount == 1) {
            try {
                fp.close();
            } catch (Exception e) {
            }
        }
        usecount--;
        return 0;
    }

    @Override
    public int read(byte[] buf, int size) {
        return -1;
    }

    /**
     * Read a line from a UNIX TTY. The carriage return is the last character.
     *
     * @param buf - pointer to memory buffer to store the line in.
     * @param size - size of buffer.
     * @return - the number of bytes read or -1 on error.
     */
    @Override
    public int readln(byte[] buf, int size) {
        return -1;
    }

    /**
     * Write buffer to terminal.
     * FIXME: convert to \n here?
     */
    @Override
    public int write(byte[] buf, int size) {
        fp.write(buf, 0, size);
        return size;
    }

    /**
     * Write buffer until CR is seen. Append '\n'.
     * Only ttys files here.
     */
    @Override
    public int writeln(byte[] buf, int size) {
        int inx = 0;
     
        for (inx = 0; inx < size;) {
            fp.write(buf[inx]);
            if (buf[inx++] == CARRIAGE_RETURN) {
                fp.write(NEW_LINE);
                break;
            }
        }
        return inx;
    }

    /**
     * Seek.
     */
    @Override
    public int seek(int offset) {
        errorcode = ErrCodes.E_Seek;
        return 0;
    }

    @Override
    public void getstatus(OS9 cpu) {
        int inx;

        switch (cpu.b.intValue()) {
        case 0:
            for (inx = 0; inx < 32; inx++)
                cpu.write(inx + cpu.x.intValue(), 0);
            cpu.write(cpu.x.intValue(), 0x0); /* RBF */
            cpu.write(cpu.x.intValue() + 0x08, 24); /* Lines per page */
            cpu.write(cpu.x.intValue() + 0x09, 8);  /* BS char */
            cpu.write(cpu.x.intValue() + 0x0a, 0x7f); /* DEL char */
            cpu.write(cpu.x.intValue() + 0x0b, 13); /* EOR char */
            cpu.write(cpu.x.intValue() + 0x0c, 4); /* EOF char ctrl-d */
            break;
        case 38: // SS.ScSiz
            cpu.x.set(80);
            break;
        default:
            cpu.sys_error(ErrCodes.E_UnkSvc);
        }
    }

    public void setstatus(OS9 cpu) {
        switch (cpu.b.intValue()) {
        case 0: // Write the 32 byte option section
            break;
        case 2:
            break;
        default:
            cpu.sys_error(ErrCodes.E_UnkSvc);
            break;
        }
    }
}
