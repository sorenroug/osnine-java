package org.roug.osnine.os9;

import java.io.File;
import java.io.RandomAccessFile;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.attribute.PosixFileAttributeView;
import java.nio.file.attribute.PosixFileAttributes;
import java.nio.file.attribute.PosixFilePermission;
import java.nio.file.attribute.PosixFilePermissions;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Set;

class PDUnix extends PathDesc {

    private File fileName;
    RandomAccessFile fp;

    /**
     * Constructor.
     */
    public PDUnix(Path path, String mode) throws FileNotFoundException {
        fileName = new File(path.toString());
        fp = new RandomAccessFile(fileName, mode);
        usecount = 1;
    }

    @Override
    protected void finalize() {
        try {
            fp.close();
        } catch (Exception e) {
        }
        usecount--;
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
     * Read a line from a UNIX file descriptor (File - not TTY).
     *
     * @param buf - pointer to memory buffer to store the line in.
     * @param size - size of buffer.
     * @return - the number of bytes read or -1 if error.
     */
    @Override
    public int readln(byte[] buf, int size) {
        byte c;
        int i;
        try {
            for (i = 0; i < size; i++) {
                c = fp.readByte();
                if (c == NEW_LINE) // Do conversion
                    c = CARRIAGE_RETURN;
                buf[i] = c;
                if (c == CARRIAGE_RETURN)
                    break;
            }
        } catch (IOException e) {
            errorcode = ErrCodes.E_EOF;
            return -1;
        }
        return i;
    }

    /**
     * Write buffer to the file descriptor.
     * @return The number of bytes written.
     */
    @Override
    public int write(byte[] buf, int size) {
        try {
            fp.write(buf, 0, size);
        } catch (IOException e) {
            errorcode = ErrCodes.E_Write;
            return -1;
        }
        return size;
        /*
        int inx;
     
        for (inx = 0; inx < size; inx++) {
            if (fputc(buf[inx], fp) == -1) {
                errorcode = ErrCodes.E_EOF;
                break;
            }
        }
        return inx;
        */
    /*
     * Can I do this instead?
        return fwrite((char*)buf,1, size, fp);
     */
    }

    /*
     * Write buffer until CR is seen
     * Only regular files here
     */
    @Override
    public int writeln(byte[] buf, int size) {
        int inx = 0;
     
	try {
	    for (inx = 0; inx < size;) {
		fp.writeByte(buf[inx]);
		if (buf[inx++] == CARRIAGE_RETURN)
		    break;
	    }
        } catch (IOException e) {
            errorcode = ErrCodes.E_Write;
        }
	return inx;
    }

    /**
     * Seek.
     */
    @Override
    public int seek(int offset) {
        try {
            fp.getFD().sync();
            fp.seek(offset);
        } catch (Exception e) {
            errorcode = ErrCodes.E_Seek;
        }
        return 0;
    }

    @Override
    public void getstatus(OS9 cpu) {
        //struct stat statbuf;
     
        try {
            switch (cpu.b.intValue()) {
            case 0:  // Read/Write PD Options
                for (int inx = 0; inx < 32; inx++) {
                    cpu.write(inx + cpu.x.intValue(), 0);
                }
                cpu.write(cpu.x.intValue(), 0x1); // RBF
                cpu.write(cpu.x.intValue() + 0x03, 0x80); // Winchester disk

                cpu.write(cpu.x.intValue() + 0x10, u2o_attr()); // Attributes
                /*FIXME
                if (fstat(fileno(fp), &statbuf) != -1) {
                    cpu.write(cpu.x.intValue() + 0x11, statbuf.st_ino >> 16 & 0xff);
                    cpu.write(cpu.x.intValue() + 0x12, statbuf.st_ino >> 8 & 0xff);
                    cpu.write(cpu.x.intValue() + 0x13, statbuf.st_ino & 0xff);
                }
                */
                break;
            case 2: // Read/Write File Size
                long size = fp.length();
                cpu.u.set((int)(size & 0xffff));
                cpu.x.set((int)((size >> 16) & 0xffff));
                break;
            case 5: // Get File Current Position
                long pos = fp.getChannel().position();
                cpu.u.set((int)(pos & 0xffff));
                cpu.x.set((int)((pos >> 16) & 0xffff));
                break;
            case 6: /* Test for End of File */
                if (fp.length() == fp.getChannel().position())
                    cpu.sys_error(ErrCodes.E_EOF);
                else
                    cpu.b.set(0);
                break;
            case 14: // Return Device name (32-bytes at [X])
                byte[] mntPoint = driver.getMntPoint().getBytes();
                for (int inx = 0; inx < 32; inx++)
                    cpu.write(inx + cpu.x.intValue(), mntPoint[inx]);
                break;
            default:
                cpu.sys_error(ErrCodes.E_UnkSvc);
                break;
            }
        } catch (Exception e) {
            cpu.sys_error(ErrCodes.E_UnkSvc);
        }
    }

    @Override
    public void setstatus(OS9 cpu) {
        try {
            switch (cpu.b.intValue()) {
            case 2:
                long fs = cpu.x.intValue() << 16 + cpu.u.intValue();
                fp.getChannel().truncate(fs);
                break;
            case 15:
            case 28:
                // Codes 15 and 28 are used by the ar-program.
                // Probably to set file access mode.
                break;
            default:
                cpu.sys_error(ErrCodes.E_UnkSvc);
                break;
            }
        } catch (Exception e) {
            cpu.sys_error(ErrCodes.E_UnkSvc);
        }
    }

    private int u2o_attr() throws IOException {
        Path path = fileName.toPath();
        PosixFileAttributes attrs = Files.getFileAttributeView(path, PosixFileAttributeView.class).readAttributes();
        Set<PosixFilePermission> permissions = attrs.permissions();
	int omode = 0;

	if (permissions.contains(PosixFilePermission.OWNER_READ)) omode |= 1;
	if (permissions.contains(PosixFilePermission.OWNER_WRITE)) omode |= 2;
	if (permissions.contains(PosixFilePermission.OWNER_EXECUTE)) omode |= 4;
	if (permissions.contains(PosixFilePermission.GROUP_READ)) omode |= 8;
	if (permissions.contains(PosixFilePermission.GROUP_WRITE)) omode |= 16;
	if (permissions.contains(PosixFilePermission.GROUP_EXECUTE)) omode |= 32;
	if (permissions.contains(PosixFilePermission.OTHERS_READ)) omode |= 8;
	if (permissions.contains(PosixFilePermission.OTHERS_WRITE)) omode |= 16;
	if (permissions.contains(PosixFilePermission.OTHERS_EXECUTE)) omode |= 32;
        if (fileName.isDirectory()) omode |=128;
	return omode;
    }

}
