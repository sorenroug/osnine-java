package org.roug.osnine.os9;

import java.io.RandomAccessFile;
import java.io.IOException;
import java.nio.channels.Pipe;
import java.nio.channels.Pipe.SourceChannel;
import java.nio.channels.Pipe.SinkChannel;
import java.nio.ByteBuffer;

/**
 * Pipe as file descriptor.
 */
class PDPipe extends PathDesc {

    public Pipe filedes;

    public PDPipe() {
        try {
            Pipe filedes = Pipe.open();
        } catch (IOException e) {
	    errorcode = ErrCodes.E_FNA;  // Correct?
        }
        usecount = 1;
    }

    @Override
    protected void finalize() {
        try {
            filedes.source().close();
            filedes.sink().close();
        } catch (IOException e) {
        }
	usecount--;
    }

    @Override
    public int close() {
        try {
            if (usecount == 1) {
                filedes.source().close();
                filedes.sink().close();
            }
        } catch (IOException e) {
        }
	usecount--;
	return 0;
    }

    @Override
    public int read(byte[] buf, int size) {
	int c;
        SourceChannel ifp = filedes.source();
        ByteBuffer wbuf = ByteBuffer.wrap(buf, 0, size);
        try {
            c = ifp.read(wbuf);
        } catch (IOException e) {
            c = 0;
        }
	if (c == 0) {
	    errorcode = ErrCodes.E_EOF;
	    return -1;
	}
	return c;
    }


    /* FIXME: Read from pipe - not the fp
     */
    @Override
    public int readln(byte[] buf, int size) {
        byte c;
        int i;
        SourceChannel ifp = filedes.source();
        ByteBuffer wbuf = ByteBuffer.wrap(buf, 0, size);
        ByteBuffer[] bufs = new ByteBuffer[1];
        bufs[0] = wbuf;
        try {
            for (i = 0; i < size; i++) {
                ifp.read(bufs, i, 1);
                c = wbuf.get(i);
                if (c == NEW_LINE) { // Do conversion
                    wbuf.put(i, CARRIAGE_RETURN);
                    c = CARRIAGE_RETURN;
                }
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
     * Write buffer.
     */
    @Override
    public int write(byte[] buf, int size) {
        SinkChannel ofp = filedes.sink();
        ByteBuffer wbuf = ByteBuffer.wrap(buf, 0, size);
        try {
	    return ofp.write(wbuf);
        } catch (IOException e) {
            errorcode = ErrCodes.E_Write;
            return -1;
        }

    }

    /**
     * Write buffer until CR is seen.
     */
    @Override
    public int writeln(byte[] buf, int size) {
	int nl;

	for (nl = 0; nl < size;) {
	    if (buf[nl++] == CARRIAGE_RETURN)
	       break;
	}
        SinkChannel ofp = filedes.sink();
        ByteBuffer wbuf = ByteBuffer.wrap(buf, 0, nl);
        try {
	    return ofp.write(wbuf);
        } catch (IOException e) {
            errorcode = ErrCodes.E_Write;
            return -1;
        }
    }

    /**
     * Get status from pipe.
     */
    @Override
    public void getstatus(OS9 cpu) {
	int inx;

	switch (cpu.b.intValue()) {
	case 0:
	    for (inx = 0; inx < 32; inx++)
		cpu.write(inx + cpu.x.intValue(), 0);
	    cpu.write(cpu.x, 0x2); // RBF
	    break;
	default:
	    cpu.sys_error(ErrCodes.E_UnkSvc);
	    break;
	}
    }

    /**
     * Set status.
     */
    @Override
    public void setstatus(OS9 cpu) {
	switch (cpu.b.intValue()) {
	case 2:
	    break;
	default:
	    cpu.sys_error(ErrCodes.E_UnkSvc);
	    break;
	}
    }
}
