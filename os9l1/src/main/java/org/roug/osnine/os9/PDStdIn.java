package org.roug.osnine.os9;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.file.Path;

class PDStdIn extends PathDesc {

    InputStream fp;

    public PDStdIn(InputStream ifp) {
        super();
        usecount++;
        fp = ifp;
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
        int c;
        try {
            c = fp.read(buf, 0, size);
        } catch (IOException e) {
            errorcode = ErrCodes.E_EOF;
            return -1;
        }
        return c;
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
        byte c[] = new byte[1];
        int i, r;

        try {
            for (i = 0; i < size; i++) {
                r = fp.read(c);
                if (r == -1) {
                    return i;
                }
                if (c[0] == NEW_LINE) // Do conversion
                    c[0] = CARRIAGE_RETURN;
                buf[i] = c[0];
                if (c[0] == CARRIAGE_RETURN) {
                    i++;
                    break;
                }
            }
        } catch (IOException e) {
            errorcode = ErrCodes.E_EOF;
            return -1;
        }
        return i;
    }

    /**
     * Write buffer to terminal.
     * FIXME: convert to \n here?
     */
    @Override
    public int write(byte[] buf, int size) {
        errorcode = ErrCodes.E_Write;
        return -1;
    }

    /**
     * Write buffer until CR is seen. Append '\n'.
     * Only ttys files here.
     */
    @Override
    public int writeln(byte[] buf, int size) {
        //errorcode = ErrCodes.E_Write;
        //return -1;
        return size;
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
