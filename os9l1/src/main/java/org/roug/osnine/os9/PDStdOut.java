package org.roug.osnine.os9;

import java.io.InputStream;
import java.io.PrintStream;
import java.io.RandomAccessFile;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.nio.file.Path;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * A path descriptor that wraps the Java stdout and stderr.
 */
public class PDStdOut extends PathDesc {

    /** Whether to convert OS9 line endings to UNIX. */
    private static boolean unixEOLs = true;

    PrintStream fp;

    private InputStream infp;

    private static final Logger LOGGER = LoggerFactory.getLogger(PDStdOut.class);

    public PDStdOut(PrintStream fp) {
        super();
        usecount++;
        this.fp = fp;
        infp = System.in;
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
            c = infp.read(buf, 0, size);
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
                r = infp.read(c);
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
     
        for (inx = 0; inx < size; inx++) {
            if (buf[inx] == CARRIAGE_RETURN) {
                fp.write(convertToUNIX() ? NEW_LINE : CARRIAGE_RETURN);
                inx++;
                break;
            } else {
                fp.write(buf[inx]);
            }
        }
        fp.flush();
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

    /**
     * Tell path descriptors to convert to UNIX line endings.
     *
     * @param useUNIX - If true then use UNIX.
     */
    public static void setUNIXSemantics(boolean useUNIX) {
        unixEOLs = useUNIX;
    }

    private boolean convertToUNIX() {
        return unixEOLs;
    }

}
