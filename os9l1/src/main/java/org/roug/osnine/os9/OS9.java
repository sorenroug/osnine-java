package org.roug.osnine.os9;

import java.util.Calendar;
import org.roug.osnine.MC6809;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Emulate the OS9 operating system.
 */
public class OS9 extends MC6809 {

    private static final int NUM_PATHS = 16; // Whatever _NFILE is set to in os9's stdio.h
    private static final int DefIOSiz = 12;
    public static final int MAX_DEVS = 64;
    public static final int MAX_PIDS = 32;
    public static final int BITMAP_START = 0x200; // Start of memory bitmap

    public static final int TOPMEM = 0xfa00;

    public static final int MDIR_START = 0x300;

    public static final int MDIR_END   = 0x400;

    private PathDesc[] paths = new PathDesc[NUM_PATHS];
    private String cxd; //!< Execution directory, typically /d0/CMDS
    private String cwd; //!< Working directory
    private String sys_dev;  //!< System device - as known from init module
    /** Top of RAM. */
    private int topOfRealRAM; //!< Absolute values
    private int bottomOfRAM = 0;
    private DevDrvr[] devices = new DevDrvr[MAX_DEVS]; //!< devices, typically /d0,/h0 etc.
    private int dev_end = 0;
    private int[] pids = new int[MAX_PIDS]; //!< Mapping of Process identifiers
    private int pid_end;
    private boolean debug_syscall;

    private static final Logger LOGGER = LoggerFactory.getLogger(OS9.class);

    /**
     * Constructor.
     */
    public OS9() {
        super(0xFF00);
        topOfRealRAM = 0xFF00;
        //SWI2Trap trap = new SWI2Trap(this);
        //this.insertMemorySegment(trap);

        debug_syscall = false;
        for (int inx = 0; inx < NUM_PATHS; inx++) {
            paths[inx] = null;
        }
        // Set up stdin, stdout and stderr.
        paths[0] = new PDStdIn(System.in);
        paths[1] = new PDStdOut(System.out);
        paths[2] = new PDStdOut(System.err);

        // Set the CWD to what we have in UNIX
        //getcwd(cwd, 1024);
        cwd = "/dd";
        cxd = "/dd/CMDS";

        init_mm();

        // Setting the memory allocation bitmap SYSMAN 3.3
        x.set(BITMAP_START);
        d.set(0);
        y.set(0x100);
        f_delbit();  // Clear all bits in allocation bitmap


        // Sets the first 8 pages to allocated
        d.set(0);
        y.set(8);
        f_allbit();

        // Block unavailable RAM in bitmap
        d.set(TOPMEM >> 8);
        y.set((0x10000 - TOPMEM) / 8);
        f_allbit();

        // Set the top memory for the application
        write_word(DPConst.D_MLIM, TOPMEM);

        // Set location of module directory
        write_word(DPConst.D_MDir, MDIR_START);
        write_word(DPConst.D_MDirE, MDIR_END);

        // Clear the registers
        x.set(0);
        d.set(0);
        y.set(0);
    }

    /**
     * Stub.
     * 1 = print syscalls, 2 = print reads/writes
     */
    public void setDebugCalls(int flag) {
        switch (flag) {
        case 1:
            debug_syscall = true;
            break;
        case 2:
            debug_syscall = false;
            break;
        default:
            debug_syscall = false;
        }
    }

    @Override
    public void status() {
        LOGGER.debug(String.format("PC: $%04X: $%02X",  pc.intValue(), ir));
    }

    private void debug(String format, Object... arguments) {
        LOGGER.debug(String.format(format,  arguments));
//      if (debug_syscall) {
//            System.err.print("DEBUG:");
//            System.err.printf(format,  arguments);
//      }
    }

    /**
     * Helper method to send a buffer to debug log.
     *
     * @param buf - the buffer
     * @param length - the amount of bytes to output.
     */
    private void debugBuffer(byte[] buf, int length) {
        StringBuffer resultBuf = new StringBuffer();
        for (int i = 0; i < length; i++) {
            resultBuf.append(String.format("%02X", buf[i]));
            if (i % 16 == 15 || i == length - 1) {
                resultBuf.append("\n");
            } else {
                resultBuf.append(":");
            }
        }
        LOGGER.debug(resultBuf.toString());
    }

    private void debugMemory(int start, int length) {
        StringBuffer resultBuf = new StringBuffer();
        for (int i = 0; i < length; i++) {
            if (i % 16 == 0) {
                resultBuf.append(String.format("%04X ", start + i));
            }
            System.err.printf("%02X", read(start + i));
            if (i % 16 == 15 || i == length - 1) {
                resultBuf.append("\n");
            } else {
                resultBuf.append(":");
            }
        }
        LOGGER.debug(resultBuf.toString());
    }

    private void error(String format, Object... arguments) {
        System.err.printf(format,  arguments);
    }

    public void setCWD(String directory) {
        cwd = directory;
    }

    public void setCXD(String directory) {
        cxd = directory;
    }

    /**
     * Load a file into memory as a module including allocating a data area and
     * creating a process descriptor.
     *
     * @param prg - name of program
     */
    public void loadmodule(String prg) {
        loadmodule(prg, "\r");
    }

    /**
     * Load a file into memory as a module including allocating a data area and
     * creating a process descriptor.
     *
     * @param prg - name of program
     * @param parm - parameters terminated by carriage return.
     */
    public void loadmodule(String prg, String parm) {
        int moduleAddr;
        byte[] parmBytes;

        copyStringToMemory(0xfe00, prg);
        x.set(0xfe00);

        f_load(); // Returns entry point address in Y
        moduleAddr = u.intValue();

        pc.set(moduleAddr + read_word(moduleAddr + 0x09)); // Set program counter
        // Get memory for the data area
        // Sect. 8.2: When the program is first entered, the Y register will have the
        // address of the top of the process' data memory area.
        // 0x0b is first byte of permanent storage size
        // 0x02 is first byte of module size
        int uppermem = moduleAddr + ((read(moduleAddr + 0x0b) + 1) << 8)
                                  + ((read(moduleAddr + 0x02) + 1) << 8);
        y.set(uppermem);
        // Load the argument vector and set registers
        // parm is already terminated with \r
        // Sect. 8.2: If the creating process passed a parameter area, it will be located from
        // the value of the SP to the top of memory (Y), and the D register
        // will contain the parameter area size in bytes.
        //debug("Allocating parm space: %d", parm.length());
        d.set(parm.length());
        //f_srqmem(); // Request memory for parm area. Returned in U
        s.set(y.intValue() - d.intValue());
        // Copy the parm value into memory
        parmBytes = parm.getBytes();
        int spBase = s.intValue();
        for (int parmInx = 0; parmInx < parmBytes.length; parmInx++) {
            write(parmInx + spBase, (int) parmBytes[parmInx]);
        }
        // Sect. 8.2: The U register will have the lower bound of the data memory
        // area, and the DP register will contain its page number.
        d.set(read_word(moduleAddr + 0x0b));
        debug("Allocating data space: $%04X", d.intValue());
        f_srqmem(); // Request memory for data area. Returned in U
        debug("module size: $%04X",  read_word((moduleAddr + 0x02)));
        debug("execution offset: $%04X",  read_word((moduleAddr + 0x09)));
        debug("permanent storage size: $%04X",  read_word((moduleAddr + 0x0b)));
        x.set(s.intValue());
        dp.set(u.intValue() >> 8);
        createInitialProcess(moduleAddr, d.intValue());
        cc.setF(0);
        cc.setI(0);
        debug("loadmodule: PC:%04X U:%04X DP:%02X X:%04X Y:%04X S:%04X",
            pc.intValue(), u.intValue(), dp.intValue(), x.intValue(), y.intValue(), s.intValue());
    }

    /**
     * Copy a UNIX string to memory at byte position
     * String is NULL-terminated, but becomes CR-terminated when
     * copied to OS9 memory.
     */
    private void copyStringToMemory(int addr, String from) {
        byte[] fromB = from.getBytes();
        for (int i = 0; i < from.length(); i++) {
            write(addr + i, fromB[i]);
        }
        write(addr + from.length(), '\r');
    }

    /**
     * F$LINK - This system call causes OS-9 to search the module directory for a
     * module having a name, language and type as given in the parameters.
     * If found, the address of the module's header is returned in U, and
     * the absolute address of the module's execution entry point is
     * returned in Y (as a convenience: this and other information can be
     * obtained from the module header). The module's link count' is
     * incremented whenever a LINK references its name, thus keeping track
     * of how many processes are using the module. If the module requested
     * has an attribute byte indicating it is not sharable (meaning it is
     * not reentrant) only one process may link to it at a time.
     *  - INPUT:
     *    - (X) = Address of module name string
     *    - (A) = Language / type (0 = any language / type)
     *  - OUTPUT:
     *    - (X) = Advanced past module name
     *    - (Y) = Module entry point address
     *    - (U) = Address of module header
     *    - (A) - Language / type
     *    - (B) = Attributes / revision level
     */
    /*
     * @todo: NOT FINISHED
     */
    void f_link() {
        int mdirp, mname, maddr;

        debug("OS9::f_link: x=%04X a=%02X", x.intValue(), a.intValue());
    //    f_prsnam();
        for (mdirp = MDIR_START; mdirp < MDIR_END; mdirp += 4) {
            maddr = read_word(mdirp);
            if (maddr == 0) {
                continue;
            }
            mname = maddr + read(maddr + 4) * 256 + read(maddr + 5);
            if (os9strcmp(mname, x.intValue()) == 0) {
                int newcnt = read(mdirp + 2) + 1;
                write(mdirp + 2, newcnt);
                u.set(maddr);
                x.set(y.intValue());
                y.set(u.intValue() + read(u.intValue() + 0x09) * 256 + read(u.intValue() + 0x0a));
                a.set(read(u.intValue() + 6));
                b.set(read(u.intValue() + 7));
                return;
            }
        }
        sys_error(ErrCodes.E_MNF);
    }


    /**
     * F$LOAD - Load module(s) from a file.
     *
     * Opens a file specified by the pathlist, reads one or more memory
     * modules from the file into memory, then closes the file. All modules
     * loaded are added to the system module directory with a use count of 0,
     * and the first module read is LINKed. The parameters returned are the same
     * as the F$LINK call and apply only to the first module loaded.
     *
     * In order to be loaded, the file must have the "execute"
     * permission and contain a module or modules that have a proper module
     * header. The file will be loaded from the working execution directory
     * unless a complete pathlist is given.
     *
     * If you load a file with two modules, both modules will be added to the
     * module directory with a use count of 0. Then the first module will be
     * LINKed giving it a use count of 1. Second time you load the same file,
     * the first module will get a link count of 2, while the second will still
     * have link count 0.
     *  - INPUT:
     *    - (X) = Address of pathlist (file name)
     *    - (A) = Language / type (0 = any language / type)
     *  - OUTPUT:
     *    - (X) = Advanced past pathlist
     *    - (Y) = Primary module entry point address
     *    - (U) = Address of module header
     *    - (A) - Language / type
     *    - (B) = Attributes / revision level
     */
    public void f_load() {
        StringBuffer upath = new StringBuffer();
        byte[] modhead = new byte[14];
        DevDrvr dev;
        PathDesc fd;
        int modname = 0;
        int moduleSize = 0;
        int langType = 0;

        getpath(x.intValue(), upath, true); // upath now contains the UNIX path to the file.
        f_prsnam();

        LOGGER.debug("OS9::f_load: {}", upath.toString());

        dev = find_device(upath.toString());
        if (dev == null) {
            sys_error(ErrCodes.E_MNF);
            LOGGER.debug("OS9::f_load: unable to find device");
            return;
        }
        //fd = dev.open(upath.substring(dev.getMntPoint().length()), 5, false);
        fd = dev.open(upath.toString(), 5, false);
        if (fd == null) {
            LOGGER.debug("OS9::f_load: unable to open path");
            sys_error(ErrCodes.E_PNNF);
            return;
        }

        boolean first = true;
        // Read 1 or more modules into memory
        while (true) {
            if (fd.read(modhead, 14) == -1)
                break;
            //debugBuffer(modhead, 14);
            moduleSize = (modhead[2] & 0xFF) * 256 + (modhead[3] & 0xFF);
            d.set(moduleSize);
            debug("Allocating module size: $%X #%d", d.intValue(), d.intValue());
            f_srqmem();                      // Request memory of D size - returned in U
            copyBufferToMemory(modhead, u.intValue(), 14);   // copy the header
            readIntoMemory(fd, u.intValue() + 14, moduleSize - 14); // Read the rest
            //debugMemory(u.intValue(), moduleSize);
            add_to_mdir(u.intValue());
            if (first) {
                first = false;
                modname = u.intValue() + (modhead[4] & 0xFF) * 256 + (modhead[5] & 0xFF);
                langType = modhead[6] & 0xFF;
            }
        }
        fd.close();
        //if (fd.usecount == 0) delete fd;

        x.set(modname);
        a.set(langType);  // (A) - Language / type
        f_link();
    }

    /**
     * F$UNLINK - Tells OS-9 that the module is no longer needed by the calling
     * process. The module's link count is decremented, and the module is
     * destroyed and its memory deallocated when the link count equals zero.
     * The module will not be destroyed if in use by any other process(es)
     * because its link count will be non-zero.
     * INPUT:
     * (U) = Address of module header
     */
    public void f_unlink() {
        int mdirp, newcnt;

        debug("OS9::f_unlink: u=%04X", u.intValue());

        for (mdirp = MDIR_START; mdirp < MDIR_END; mdirp += 4) {
            if (read_word(mdirp) == u.intValue()) {
                newcnt = read(mdirp + 2);
                write(mdirp + 2, newcnt - 1);
                if (newcnt <= 1) {
                    write_word(mdirp, 0); // removes entry
                    d.set(read_word(u.intValue() + 2)); // Module size
                    f_srtmem();
                }
                return;
            }
        }
        sys_error(ErrCodes.E_MNF);
    }

    /**
     * Copy a byte buffer to memory.
     */
    private void copyBufferToMemory(byte[] buf, int startAddr, int len) {
        for (int i = 0; i < len; i++) {
            write(startAddr + i, buf[i]);
        }
    }

    /**
     * Copy memory to byte buffer.
     *
     * @param startAddr starting address in memory
     * @param len -- number of bytes to copy
     * @return a new buffer containing the copied bytes.
     */
    private byte[] copyMemoryToBuffer(int startAddr, int len) {
        byte[] buf = new byte[len];
        for (int i = 0; i < len; i++) {
            buf[i] = (byte) read(startAddr + i);
        }
        return buf;
    }
    /**
     * Read a specied number of bytes into memory from open file.
     */
    private void readIntoMemory(PathDesc fd, int startAddr, int len) {
        byte[] buf = new byte[len];
        fd.read(buf, len);
        copyBufferToMemory(buf, startAddr, len);
    }

    /**
     * Add module to directory.
     */
    private void add_to_mdir(int modptr) {
        int found = 0;

        for (int mdirp = MDIR_START; mdirp < MDIR_END; mdirp += 4) {
            if (read_word(mdirp) == modptr) {
                write(mdirp + 2, read(mdirp + 2) + 1);
                found = 1;
                break;
            }
        }
        // Module didn't exist already, so create it.
        if (found == 0) {
            for (int mdirp = MDIR_START; mdirp < MDIR_END; mdirp += 4) {
                if (read_word(mdirp) == 0) {
                    write_word(mdirp, modptr);
                    write(mdirp + 2, 0);
                    break;
                }
            }
        }
    }

    /**
     * getpath: get the path into a UNIX form, take into account the
     * execution directory.
     *
     * @param mem - location in memory where the path is. Terminated by high-order bit.
     * @param unixPath - buffer to store the result in. (side-effect)
     * @param xdir - If set, then prefix execution directory on relative paths.
     * @return value is the end of the path. You usually set register x to that.
     */
    private int getpath(int mem, StringBuffer unixPath, boolean xdir) {
        int mp;

        /*
         * When you do a "load filename" in basic09, getpath gets
         * called with leading spaces in filename
         */
        for (mp = mem; read(mp) == ' '; mp++)
           ;

        // If the path is absolute, prepend the offset into the UNIX fs
        if (read(mp) == '/') {
            unixPath.append("");
        } else {
            if (xdir)
                unixPath.append(cxd);
            else
                unixPath.append(cwd);
            unixPath.append("/");
        }

        for (; read(mp) != 0; mp++) {
            if (read(mp) <= '-' || read(mp) == '<' || read(mp) == '>')
                break;
            unixPath.appendCodePoint(read(mp) & 0x7f);
            if ((read(mp) & 0x80) == 0x80)
                break;
        }

        // Skip past spaces
        for (; read(mp) == ' '; mp++)
           ;
        return mp - mem;
    }

    /**
     * Compare two OS9 case-insensitive strings. A string is terminated with
     * highorder bit set, CR or NULL
     */
    int os9strcmp(int str1, int str2) {
        for (; (read(str1) & 0x5f) == (read(str2) & 0x5f); str1++, str2++)
            if (read(str1) > 0x7f || read(str1) < 32)
                return 0;
        return (read(str1) & 0x5f) - (read(str2) & 0x5f);
    }

    public void addDevice(DevDrvr device) {
        if (dev_end < MAX_DEVS) {
            devices[dev_end++] = device;
        } else {
            LOGGER.error("Overflow: {} device not added as OS9 device\n", device.toString());
        }
    }

    /**
     * Find the device driver that handles a file with that pathname.
     */
    private DevDrvr find_device(String path) {
        String lcPath = path.toLowerCase();
        for (int i = 0; i < MAX_DEVS; i++) {
            if (devices[i] != null) {
                String mntPoint = devices[i].getMntPoint().toLowerCase();
                if (lcPath.startsWith(mntPoint)) {
                    return devices[i];
                }
            }
        }
        debug("No driver for %s", new String(path));
        return null;
    }


    /**
     * Memory housekeeping.
     * Maintain a bitmap of free memory at 0x200-0x21f incl.
     * This is mainly so extra modules/subroutes can be loaded.
     */
    void init_mm() {
        // Set location of memory bitmap (0x200 - 0x220)
        write_word(DPConst.D_FMBM, BITMAP_START);
        write_word(DPConst.D_FMBME, BITMAP_START + 0x20);
    }

    /**
     * F$MEM: Used to expand or contract the process' data memory area. The new
     * size requested is rounded up to the next 256-byte page boundary.
     * Additional memory is allocated contiguously upward (towards higher
     * addresses), or deallocated downward from the old highest address. If
     * D = 0, then the current upper bound and size will be returned.
     *
     * This request can never return all of a process' memory, or the
     * page in which its SP register points to.
     *
     * In Level One systems, the request may return an error upon an
     * expansion request even though adequate free memory exists. This is
     * because the data area is always made contiguous, and memory requests
     * by other processes may fragment free memory into smaller, scattered
     * blocks that are not adjacent to the caller's present data area.
     *
     * Level Two systems do not have this restriction because of the availability
     * of hardware for memory relocation, and because each process has its
     * own "address space".
     *  - INPUT:
     *   - (D) = Desired new memory area size in bytes.
     *  - OUTPUT:
     *   - (Y) = Address of new memory area upper bound.
     *   - (D) = Actual new memory area size in bytes.
     */
    void f_mem() {
       if (d.intValue() == 0) {
           y.set(topOfRealRAM);
           d.set(topOfRealRAM - bottomOfRAM);
       } else {
       // FIXME: check that the program requests less than what we have
           y.set(topOfRealRAM);
           d.set(topOfRealRAM - bottomOfRAM);
       }
    }


    /**
     * Mark pages of memory in bitmap. From and to are full addresses.
     *
     * @param from - from memory address.
     * @param to - to memory address.
     */
    private void markMemoryUsed(int from, int to) {
        from >>= 8;
        to >>= 8;

        int m;
        int addr;
        for (; from <= to; from++) {
            addr = BITMAP_START + (from / 8);
            m = read(addr);
            write(addr, m | (0x80 >> (from % 8)));
        }
    }

    /**
     * F$AllBit: This system mode service request sets bits in the allocation bit map
     * specified by the X register.  Bit numbers range from 0..N-1, where N is
     * the number of bits in the allocation bit map.
     *  - INPUT:
     *   - (X) = Base address of an allocation bit map.
     *   - (D) = Bit number of first bit to set.
     *   - (Y) = Bit count (number of bits to set).
     *  - OUTPUT:
     *   - None
     */
    void f_allbit() {
        int from = d.intValue();
        int to = d.intValue() + y.intValue();
        int base = x.intValue();
        while (from < to) {
            int addr = base + (from / 8);
            int oldVal = read(addr);
            write(addr, oldVal | (0x80 >> (from % 8)));
            from++;
        }
    }

    /**
     * F$DelBit: This system mode service request is used to clear bits in the allocation
     * bit map pointed to by X.  Bit numbers range from 0..N-1, where N is the
     * number of bits in the allocation bit map.
     *  - INPUT:
     *   - (X) = Base address of an allocation bit map.
     *   - (D) = Bit number of first bit to clear.
     *   - (Y) = Bit count (number of bits to clear).
     *  - OUTPUT:
     *   - None
     */
    void f_delbit() {
        int from = d.intValue();
        int to = d.intValue() + y.intValue();
        while (from < to) {
            int addr = x.intValue() + (from / 8);
            int oldVal = read(addr);
            write(addr, oldVal & ~(0x80 >> (from % 8)));
            from++;
        }
    }

    /**
     * F$TIME - Get date and time.
     */
    public void f_time() {
        LOGGER.debug("OS9::f_time");
        Calendar now = Calendar.getInstance();
        write(x.intValue() + 0, now.get(Calendar.YEAR) % 100); // Two char year.
        write(x.intValue() + 1, now.get(Calendar.MONTH));
        write(x.intValue() + 2, now.get(Calendar.DAY_OF_MONTH));
        write(x.intValue() + 3, now.get(Calendar.HOUR));
        write(x.intValue() + 4, now.get(Calendar.MINUTE));
        write(x.intValue() + 5, now.get(Calendar.SECOND));
    }

    private static final long CRC24_POLY = 0x800063L;


    /**
     * Compute CRC24 sum.
     */
    public static long compute_crc(long crc, byte[] octets, int len) {
        for (int j = 0; j < len; j++) {
            crc ^= (octets[j]) << 16;
            for (int i = 0; i < 8; i++) {
                crc <<= 1;
                if ((crc & 0x1000000) != 0)
                    crc ^= CRC24_POLY;
            }
        }
        return crc & 0xffffffL;
    }

    /**
     * F$CRC - This service request calculates the CRC (cyclic redundancy count)
     * for use by compilers, assemblers, or other module generators. The CRC
     * is calculated starting at the source address over "byte count" bytes,
     * it is not necessary to cover an entire module in one call, since the
     * CRC may be "accumulated" over several calls. The CRC accumulator can
     * be any three byte memory location and must be initialized to $FFFFFF
     * before the first F$CRC call.
     */
    public void f_crc() {
        byte[] buf;
        long tmpcrc;

        tmpcrc = (read(u.intValue()) << 16) + (read(u.intValue() + 1) << 8) + read(u.intValue() + 2);

        debug("OS9::f_crc: X=%04x Y=%04x DP=%02x\nU=%04x start=%lx",
                 x.intValue(), y.intValue(), dp.intValue(), u.intValue(), tmpcrc);
        buf = copyMemoryToBuffer(x.intValue(), y.intValue());
        tmpcrc = compute_crc(tmpcrc, buf, y.intValue());
        write(u.intValue() + 0, (int) ((tmpcrc >> 16) & 0xff));
        write(u.intValue() + 1, (int) ((tmpcrc >> 8) & 0xff));
        write(u.intValue() + 2, (int) (tmpcrc & 0xff));
    }

    /**
     * F$SchBit: Search bit map for a free area.
     * This system mode service request searches the specified allocation
     * bit map starting at the "beginning bit number" for a free
     * block (cleared bits) of the required length.
     *
     * If no block of the specified size exists, it returns with the
     * carry set, beginning bit number and size of the largest block.
     *
     *  - INPUT:
     *   - (X) = Beginning address of a bit map.
     *   - (D) = Beginning bit number.
     *   - (Y) = Bit count (free bit block size).
     *   - (U) = End of bit map address.
     *  - OUTPUT:
     *   - (D) = Beginning bit number.
     *   - (Y) = Bit count.
     */
    void f_schbit() {
        int from, to, bit;
        int candidateFrom, candidateLen = 0;
        int maxFoundFrom = 0;
        int maxFoundLen = 0;

        from = d.intValue();
        to = u.intValue();
        candidateFrom = from;
        while (from < to) {
            bit = read(x.intValue() + (from / 8)) & (0x80 >> (from % 8));
            if (bit != 0) {
                // bit is taken, we can extend no further
                if (candidateLen < y.intValue()) {
                    candidateLen = 0; // Reset candidateLen to 0
                    candidateFrom = from + 1; // The next start can be earliest from next bit.
                }
            } else {
                // bit is free
                candidateLen++;
                if (candidateLen > maxFoundLen) {
                    maxFoundFrom = from - candidateLen + 1;
                    maxFoundLen = candidateLen;
                }
            }
            if (candidateLen == y.intValue()) {
                break;
            }
            from++;
        }

        if (candidateLen < y.intValue()) {
            sys_error(ErrCodes.E_NoRam);
            d.set(maxFoundFrom);
            y.set(maxFoundLen);
        } else {
            d.set(candidateFrom);
            y.set(candidateLen);
        }
    }



    /**
     * F$SRqMem: This system mode service request allocates a block of memory from
     * the top of available RAM of the specified size. The size requested is
     * rounded to the next 256 byte page boundary.
     *
     * Find space in memory going from top to bottom
     *
     * Algoritm is first-fit
     *  - INPUT:
     *   - (D) = Byte count.
     *  - OUTPUT:
     *   - (U) = Beginning address of memory area.
     *   - (D) = Byte count rounded up to full page
     */
    void f_srqmem() {
        int i, foundpages = 0;
        int pages = (d.intValue() + 255) / 256;
        int org_x, org_d, org_y;

        org_x = x.intValue();
        org_y = y.intValue();
        org_d = (d.intValue() + 0xff) & 0xff00; // Round it up
        debug("OS9::f_srqmem: X:%4X", org_d);
        x.set(BITMAP_START);
        for (i = 255; i >= 0; i--) {
            if ((read(x.intValue() + (i / 8)) & (0x80 >> (i % 8))) != 0)
                foundpages = 0;
            else
                foundpages++;
            if (foundpages == pages) {
                u.set(i * 256);
                d.set(i);
                y.set(pages);
                f_allbit();
                d.set(org_d);
                x.set(org_x);
                y.set(org_y);
                debug("Found memory at %X", u.intValue());
                return;
            }
        }
        sys_error(ErrCodes.E_NoRam);
    }

    /**
     * F$SRtMem: This system mode service request is used to deallocate a block of contigous
     * 256 byte pages. The U register must point to an even page boundary.
     *  - INPUT:
     *   - (U) = Beginning address of memory to return.
     *   - (D) = Number of bytes to return.
     *  - OUTPUT:
     *   - None.
     */
    void f_srtmem() {
        int org_x, org_d, org_y;

        org_x = x.intValue();
        org_y = y.intValue();
        org_d = d.intValue();
        x.set(BITMAP_START);
        y.set((d.intValue() + 255) / 256);
        d.set(u.intValue() >> 8);
        f_delbit();
        x.set(org_x);
        y.set(org_y);
        d.set(org_d);
    }

    /**
     * F$All64: Allocate 64 bytes for process/path descriptor.
     * This system mode service request is used to dynamically allocate
     * 64 byte blocks of memory by splitting whole pages (256 byte) into
     * four sections. The first 64 bytes of the base page are used as a
     * "page table", which contains the MSB of all pages in the memory
     * structure. Passing a value of zero in the X register will cause the
     * service request to allocate a new base page and the first 64 byte
     * memory block. Whenever a new page is needed, an service request will
     * automatically be executed. The first byte of each block contains the
     * block number; routines using this service request should not alter it.
     * - INPUT:
     *  - (X) = Base address of page table (zero if the page table has not yet been allocated).
     * - OUTPUT:
     *  - (A) = Block number
     *  - (X) = Base address of page table
     *  - (Y) = Address of block.
     */
    void f_all64() {
        int org_u;
        int org_a;

        if (x.intValue() != 0) {
            // Find an unused block
            for (org_a = 1; true; org_a++) {
                y.set(read(x.intValue() + org_a / 4) << 8);
                if (y.intValue() == 0)  // No more blocks. Allocate one
                    break;
                y.set(y.intValue() + (org_a % 4) * 64);
                if (read(y.intValue()) == 0) { // Found an unused block
                    a.set(org_a);
                    return;
                }
            }
            a.set(org_a);
        } else {
            a.set(1);          // Block number 1
        }
        org_u = u.intValue();
        org_a = a.intValue();
        d.set(1);          // Ask for one page
        f_srqmem();
        a.set(org_a);
        if (x.intValue() == 0)
            x.set(u.intValue());
        write(x.intValue() + a.intValue() / 4, u.intValue() >> 8); // Write MSB of x to page table;
        y.set((read(x.intValue() + a.intValue() / 4) << 8) + (a.intValue() % 4) * 64);
        u.set(org_u);
    }

    /**
     * F$Ret64: Deallocate a 64 byte memory block. This system mode service request
     * deallocates a 64 byte block of memory as described in F$All64 service request.
     *  - INPUT:
     *   - (X) = Address of the base page.
     *   - (A) = Block number.
     *  - OUTPUT:
     *   - None.
     * @todo: unfinished
     * I don't really know what to do here.
     */
    void f_ret64() {
        y.set((read(x.intValue() + a.intValue() / 4) << 8) + (a.intValue() % 4) * 64);
        if (y.intValue() == 0)  // No more blocks. Error.
            return;
        write(y, 0);   // Clear the dirty flag.
    }

    /**
     * Create a system error. Sets the carry bit and the code in the B register.
     */
    public int sys_error(int errcode) {
        if (errcode == 0)
            return 0;
        cc.setC(1);
        b.set(errcode);
        return errcode;
    }


    /*
    ************************************************************
    *
    *     Process Descriptor Definitions
    *
    DefIOSiz equ 12
    NumPaths equ 16 Number of Local Paths

     ORG 0

    P$ID rmb 1 Process ID
    P$PID rmb 1 Parent's ID
    P$SID rmb 1 Sibling's ID
    P$CID rmb 1 Child's ID
    P$SP rmb 2 Stack ptr
    P$CHAP rmb 1 process chapter number
    P$ADDR rmb 1 user address beginning page number
    P$PagCnt rmb 1 Memory Page Count
    P$User rmb 2 User Index
    P$Prior rmb 1 Priority
    P$Age rmb 1 Age
    P$State rmb 1 Status
    P$Queue rmb 2 Queue Link (Process ptr)
    P$IOQP rmb 1 Previous I/O Queue Link (Process ID)
    P$IOQN rmb 1 Next     I/O Queue Link (Process ID)
    P$PModul rmb 2 Primary Module
    P$SWI rmb 2 SWI Entry Point
    P$SWI2 rmb 2 SWI2 Entry Point
    P$SWI3 rmb 2 SWI3 Entry Point
    P$DIO rmb DefIOSiz default I/O ptrs
    P$PATH rmb NumPaths I/O path table
    P$Signal rmb 1 Signal Code
    P$SigVec rmb 2 Signal Intercept Vector
    P$SigDat rmb 2 Signal Intercept Data Address
    */


    /* ************************************
     * Process management
     ************************************** */

    /**
     * Initialise process table.
     */
    private void createInitialProcess(int moduleStart, int allocatedMemory) {
        int tmpx = x.intValue();
        x.set(read_word(DPConst.D_PrcDBT));  // 73- Process descriptor block address
        f_all64();                // Allocate the process descriptor
        write_word(DPConst.D_PrcDBT, x.intValue());

        int procAddr = y.intValue();
        write_word(DPConst.D_AProcQ, procAddr);  // D_AProcQ -- Write proces to Active process queue
        write_word(DPConst.D_WProcQ, 0);  // Write null to the Wait process queue
        write_word(DPConst.D_SProcQ, 0);  // Write null to the Sleep process queue
        write_word(DPConst.D_Proc, procAddr);    // 0x4B - 75 - Current Process descriptor address

        write(procAddr + PDConst.p_ID,  1);      // Write process ID
        write(procAddr + PDConst.p_PID,  0);     // Write process parent ID - What is the parent of #1?
        write_word(procAddr + PDConst.p_SP, s.intValue());  // Write stack pointer
    //    write(procAddr + PDConst.p_ADDR, dp.intValue());  // user address beginning page number
        write(procAddr + PDConst.p_PagCnt, allocatedMemory >> 8);  // Memory allocation in pages (Upper half of acc D).
        write(procAddr + PDConst.p_Prior,  100); // Write process priority
        write_word(procAddr + PDConst.p_User, getuid());  // Write user id
        write_word(procAddr + PDConst.p_PModul, moduleStart);  // Module start
        x.set(tmpx);
    }

    /**
     * Provide a fake UID as Java has to be able to run on many OS architectures.
     */
    private int getuid() {
        return 500;
    }

    /**
     * Change to next process.
     * Look in the source for the PROCS command to see what pointers to change
     */
    void next_proc() {
    }

    /**
     * F$AProc -  Enter Active Process Queue.
     * This system mode service request inserts a process into the active
     * process queue so that it may be scheduled for execution.
     * All processes already in the active process queue are aged, and the
     * age of the specified process is set to its priority. If the process
     * is in system state, it is inserted after any other process's also in
     * system state, but before any process in user state. If the process is
     * in user state, it is inserted according to its age.
     *
     * This is a privileged system mode service request.
     *
     *  - INPUT:
     *   - (X) = Address process descriptor.
     *  - OUTPUT:
     *   - None.
     * @todo: unfinished.
     */
    public void f_aproc() {
        addToActiveProcQ(x.intValue());
    }

    /**
     * Add process descriptor to active process queue.
     *
     * @param processPtr - pointer to process structure.
     * @todo: unfinished.
     */
    private void addToActiveProcQ(int processPtr) {
        int currProcess, prevProcess;
        int candAge, currAge;

        candAge = read(processPtr + PDConst.p_Prior);
        write(processPtr + PDConst.p_Age, candAge);
        currProcess = read_word(DPConst.D_AProcQ);
        while (currProcess != 0) { // Increase the age on all
            currAge = read(currProcess + PDConst.p_Age);
            if (currAge < 255) {
                write(currProcess + PDConst.p_Age, currAge + 1);
            }
            currProcess = read_word(currProcess + PDConst.p_Queue);
        }

        currProcess = read_word(DPConst.D_AProcQ);
        if (currProcess == 0) {
            write_word(DPConst.D_AProcQ, processPtr); // There were no other processes.
        } else {
            if (candAge >= read(currProcess + PDConst.p_Age)) { // Put it first in the queue
                write_word(DPConst.D_AProcQ, processPtr);
                write_word(processPtr + PDConst.p_Queue, currProcess);
            } else {                                      // All other cases
                prevProcess = currProcess;
                currProcess = read_word(currProcess + PDConst.p_Queue);
                while (currProcess != 0) {
                    currAge = read(currProcess + PDConst.p_Age);
                    if (candAge >= currAge) {
                        write_word(prevProcess + PDConst.p_Queue, processPtr);
                        write_word(processPtr + PDConst.p_Queue, currProcess);
                    }
                    prevProcess = currProcess;
                    currProcess = read_word(currProcess + PDConst.p_Queue);
                }
            }
        }
    }

    /**
     * F$PRSNAM - Parse name.
     * Names can have one to 29 characters. They must begin with an upper- or lower-case
     * letter followed by any combination of the following character classes:
     * uppercase letters [A-Z], lowercase letters [a-z], decimal digits [0-9],
     * underscore (_) and period (.)
     *  - INPUT:
     *   - (X) = Address of the pathlist
     *  - OUTPUT:
     *   - (X) = Updated path the optional "/"
     *   - (Y) = Address of the last character of the name + 1
     *   - (B) = Length of the name
     */
    public void f_prsnam() {
        int p;
        int tmpX = x.intValue();

        debug("OS9::f_prsnam: X:%4X", tmpX);

        if (read(tmpX) == '/' || Character.isLetterOrDigit(read(tmpX)) || read(tmpX) == '_' || read(tmpX) == '.') {
            p = tmpX;

            while (read(p) == '/') { // Skip slash(es)
                p++;
            }
            x.set(p);

            int m = read(p);
            while (m == '_' || m == '.' || Character.isLetterOrDigit(m)) {
                p++;
                m = read(p);
            }
            y.set(p);
            b.set(y.intValue() - x.intValue());
            for (int i = 0; i < b.intValue(); i++)
                LOGGER.trace(String.valueOf((char) read(x.intValue() + i)));
        } else {
            // We are not pointing to a pathname
            tmpX = x.intValue();
            while (read(tmpX) == ' ' || read(tmpX) == '\t') {
                tmpX++;
            }
            x.set(tmpX);
            sys_error(ErrCodes.E_BNam);
            debug("(whitespace)");
        }
    }

    /**
     * F$CMPNAM - Compare two names.
     * Given the address and length of a string, and the address of a second
     * string, compares them and indicates whether they match. Typically used
     * in conjunction with "parsename".
     * The second name must have the sign bit (bit 7) of the last character set.
     * Assumes the match is case insensitive.
     *  - INPUT:
     *   - (X) = Address of the first name.
     *   - (B) = Length of the first name.
     *   - (Y) = Address of the second name.
     *  - OUTPUT:
     *   - (CC) = C bit clear if the strings match.
     */
    public void f_cmpnam() {
        int strx = x.intValue();
        int stry = y.intValue();

        cc.setC(1);
        for (; (read(strx) & 0x5f) == (read(stry) & 0x5f); strx++, stry++) {
            if (read(stry) > 0x7f || strx > (x.intValue() + b.intValue()))
                cc.setC(0);
        }
    //  if ((read(strx) & 0x5f) - (read(stry) & 0x5f))
    //      cc.setC(0);
    }

    /**
     * F$ID - Get user id.
     */
    public void f_id() {
        LOGGER.debug("OS9::f_id");
        a.set(1);
        y.set(getuid() & 0xffff);
    }

    /**
     * F$PERR - Print error message. We have included the text strings so it
     * looks like you have used 'printerr'.
     */
    public void f_perr() {
        String buf;
        // According to sysman, a holds the path number to write to,
        // but the shell never sets a.
        buf = String.format("ERROR #%d %s\r\n", b.intValue(), ErrMsg.errmsg[b.intValue()]);
        paths[2].write(buf.getBytes(), buf.length());
    }

    /**
     * F$EXIT - Exit running program.
     */
    public void f_exit() {
        LOGGER.debug("OS9::f_exit");

        if (b.intValue() != 0)
            error("Exit code %d\n", b.intValue());
        System.out.flush();
        System.exit(b.intValue());
    }

    /**
     * I$DUP - Duplicate a path number.
     *
     * After a cursory inspection of the disassembled shell and having some
     * trouble with basic09, I've come to the conclusion that System Manager's
     * Manual is wrong. The new path number is returned in register a.
     */
    public void i_dup() {
        int t;

        LOGGER.debug("OS9::i_dup: {}", a.intValue());

        for (t = 0; t < NUM_PATHS; t++)
            if (paths[t] == null) {
                paths[t] = paths[a.intValue()];
                paths[a.intValue()].usecount++;
                break;
            }
        if (t == NUM_PATHS) {
            sys_error(ErrCodes.E_PthFul);
            return;
        }
        LOGGER.debug("i_dup: {} => {}", a.intValue(), t);
        a.set(t);
    }

    /**
     * I$CREA - Create a path to a new file.
     * input  (X) = Address of pathlist
     * input  (A) = Access mode (D S PE PW PR E W R)
     * input  (B) = File attributes.
     * output (X) = Updated past pathlist (trailing spaces skipped)
     * output (A) = Path number
     */
    public void i_crea() {
        openOrCreate(true);
    }

    /**
     * I$OPEN - Open a file.
     * input  (X) = Address of pathlist
     * input  (A) = Access mode (D S PE PW PR E W R)
     * output (X) = Updated past pathlist (trailing spaces skipped)
     * output (A) = Path number
     */
    public void i_open() {
        openOrCreate(false);
    }

    private void openOrCreate(boolean create) {
        StringBuffer upath = new StringBuffer();
        DevDrvr dev;
        int tmpMode = a.intValue();

        boolean xDir = (a.intValue() & 4) == 4;
        x.set(x.intValue() + getpath(x.intValue(), upath, xDir));

        debug("OS9::i_open: %s (%s) mode %03o", upath.toString(), create ? "create" : "open", tmpMode);

        dev = find_device(upath.toString());
        if (dev == null) {
            sys_error(ErrCodes.E_MNF);
            return;
        }

        int i;
        for (i = 0; i < NUM_PATHS; i++) {
            if (paths[i] == null) {
                paths[i] = dev.open(upath.toString(), tmpMode, create);

                if (paths[i] == null) {
                    sys_error(ErrCodes.E_PNNF);
                    return;
                }
                break;
            }
        }
        if (i == NUM_PATHS) {
            sys_error(ErrCodes.E_PthFul);
        }

        debug("= %d", i);
        a.set(i);
    }

    /**
     * I$GETSTT - Get status of path number in register A.
     * This system is a "wild card" call used to handle individual device parameters that:
     *  a) are not uniform on all devices
     *  b) are highly hardware dependent
     *  c) need to be user-changable
     * The exact operation of this call depends on the device driver and file manager
     * associated with the path. A typical use is to determine a terminal's parameters
     * for backspace character, delete character, echo on/off, null padding, paging, etc.
     * It is commonly used in conjunction with the service request which is used to set
     * the device operating parameters.
     */
    public void i_getstt() {
        debug("OS9::i_getstt: FD=%d opcode %d", a.intValue(), b.intValue());

        paths[a.intValue()].errorcode = 0;
        paths[a.intValue()].getstatus(this);
    }


    /**
     * I$SETSTT - Set file/device status.
     * This system is a "wild card" call used to handle individual device parameters that:
     *  a) are not uniform on all devices
     *  b) are highly hardware dependent
     *  c) need to be user-changable
     * The exact operation of this call depends on the device driver and file manager
     * associated with the path. A typical use is to determine a terminal's parameters
     * for backspace character, delete character, echo on/off, null padding, paging, etc.
     * It is commonly used in conjunction with the service request which is used to read
     * the device operating parameters.
     */
    public void i_setstt() {
        debug("OS9::i_setstt: FD=%d opcode %d", a.intValue(), b.intValue());
        paths[a.intValue()].errorcode = 0;
        paths[a.intValue()].setstatus(this);
    }

    /**
     * I$MDir - Make a new directory.
     * This is the only way a new directory file can be created. It will
     * create and initialize a new directory as specified by the pathlist. The
     * new directory file contains no entries, except for an entry for itself
     * (".") and its parent directory (".."). The caller is made the owner of
     * the directory. Does not return a path number because directory files are
     * not "opened" by this request (use I$Open to do so). The new directory will
     * automatically have its "directory" bit set in the access permission
     * attributes. The remaining attributes are specified by the byte passed
     * in the B register,
     * @todo: mode bits
     */
    public void i_mdir() {
        StringBuffer upath = new StringBuffer();
        DevDrvr dev;

        x.set(x.intValue() + getpath(x.intValue(), upath, false));

        LOGGER.debug("OS9::i_mdir: {}", upath.toString());

        dev = find_device(upath.toString());
        if (dev == null) {
            sys_error(ErrCodes.E_MNF);
            return;
        }
        //sys_error(dev.makdir(upath.substring(dev.getMntPoint().length()), 0777));
        sys_error(dev.makdir(upath.toString(), 0777));
        /* FIXME: mode bits */
    }

    /**
     * I$ChgDir - Change directory.
     * Contrary to what SYSMAN says, the output is that register x is updated past
     * the path.
     *
     * FIXME: If the a &amp; 4 == 4 then set the exec dir bye changing the cxd
     * string.
     */
    public void i_chgdir() {
        StringBuffer upath = new StringBuffer();
        String newcwd;
        DevDrvr dev;

        newcwd = cwd;
        getpath(x.intValue(), upath, (a.intValue() & 4) == 4);
        dev = find_device(newcwd); // TODO: this looks wrong
        if (dev == null) {
            sys_error(ErrCodes.E_MNF);
            return;
        }
        if (sys_error(dev.chdir(newcwd)) == 0) {
            cwd = upath.toString();
        }
        LOGGER.debug("Changing dir to {}", upath.toString());
    }

    /**
     * I$RdLn - Read a line.
     */
    public void i_rdln() {
        int c;

        debug("OS9::i_rdln: FD=%d pos=%x len=%d ", a.intValue(), x.intValue(), y.intValue());

        byte[] buf = new byte[y.intValue()];
        c = paths[a.intValue()].readln(buf, y.intValue());
        if (c == -1) {
            sys_error(paths[a.intValue()].errorcode);
            debug("error = %d", b.intValue());
            return;
        }
        copyBufferToMemory(buf, x.intValue(), c);
        y.set(c);
        debug("ret = %d", y.intValue());
    }

    /**
     * I$Read - Read some bytes.
     */
    public void i_read() {
        int c;

        debug("OS9::i_read: FD=%d pos=0x%x len=#%d ", a.intValue(), x.intValue(), y.intValue());

        byte[] buf = new byte[y.intValue()];
        c = paths[a.intValue()].readln(buf, y.intValue());
        if (c == -1) {
            sys_error(paths[a.intValue()].errorcode);
            debug("error = %d", b.intValue());
            return;
        }
        copyBufferToMemory(buf, x.intValue(), c);
        y.set(c);
        debug("ret = %d", y.intValue());
    }

    /**
     * I$WRLN - Write a line of text. The file descriptor is in register A.
     */
    public void i_wrln() {
        byte[] buf;
        debug("OS9::i_wrln: FD=%d y=%d x=%04x %c%c%c...", a.intValue(), y.intValue(), x.intValue(),
                  read(x.intValue()), read(x.intValue() + 1), read(x.intValue() + 2));
        paths[a.intValue()].errorcode = 0;
        buf = copyMemoryToBuffer(x.intValue(), y.intValue());
        y.set(paths[a.intValue()].writeln(buf, y.intValue())); // Return number of bytes written
        sys_error(paths[a.intValue()].errorcode);
    }

    /**
     * I$WRITE - Write some text. The file descriptor is in register A.
     */
    public void i_write() {
        byte[] buf;
        debug("OS9::i_write: FD=%d y=%d x=%04x %c%c%c...", a.intValue(), y.intValue(), x.intValue(),
              read(x.intValue()), read(x.intValue() + 1), read(x.intValue() + 2));
        paths[a.intValue()].errorcode = 0;
        buf = copyMemoryToBuffer(x.intValue(), y.intValue());
        y.set(paths[a.intValue()].write(buf, y.intValue())); // Return number of bytes written
        sys_error(paths[a.intValue()].errorcode);
    }

    /**
     * I$Close - Close a file descriptor.
     */
    public void i_close() {
        debug("OS9::i_close: FD=%d", a.intValue());
        if (paths[a.intValue()] == null) {
            sys_error(ErrCodes.E_BPNum);
            return;
        }
        paths[a.intValue()].close();

        if (paths[a.intValue()].usecount == 0) {
            //delete paths[a.intValue()];
        }
        paths[a.intValue()] = null;
    }

    /**
     * I$DELETEX - Delete a file.
     * This service request deletes the file specified by the pathlist. The
     * file must have write permission attributes (public write if not the
     * owner), and reside on a multi-file mass storage device. Attempts to
     * delete devices will result in error.
     *
     * @param xdir - whether to delete in current or execution directory.
     */
    public void i_deletex(int xdir) {
        StringBuffer upath = new StringBuffer();
        DevDrvr dev;

        boolean xDir;
        if (xdir != 0) {
            xDir = (a.intValue() & 4) == 4;
        } else {
            xDir = false;
        }

        x.set(x.intValue() + getpath(x.intValue(), upath, xDir));

        String unixPath = upath.toString();
        debug("OS9::i_deletex: %s", unixPath);

        dev = find_device(unixPath);
        if (dev != null) {
            sys_error(ErrCodes.E_MNF);
            return;
        }
        sys_error(dev.delfile(unixPath));
    }

    /**
     * I$SEEK - Seek in a random access file.
     */
    public void i_seek() {
        debug("OS9::i_seek: FD=%d pos=%04X%04X", a.intValue(), x.intValue(), u.intValue());
        paths[a.intValue()].seek((x.intValue() << 16) + u.intValue());
    }

    /**
     * Software Interrupt 2 is used for system calls. Next byte after is the OPCODE.
     */
    @Override
    protected void swi2() {
            cc.setC(0);
            int opcode = fetch();
            //debug("SWI2 call. Opcode = $%02X", opcode);
            switch (opcode) {
            case 0x00:
                f_link();
                break;
            case 0x01:
                f_load();
                break;
            case 0x02:
                f_unlink();
                break;
            case 0x03:
//              f_fork();
                break;
            case 0x04:
//              f_wait();
                break;

            case 0x05:
//              f_chain();
                break;

            case 0x06:              // F$Exit
                f_exit();
                break;
            case 0x07:
                f_mem();
                break;
            case 0x09:
                LOGGER.debug("OS9::Set intercept trap");
                break;
            case 0x0a:
//              f_sleep();
                break;
            case 0x0c:
                f_id();
                break;
            case 0x0d:              // F$SPri
                /* Ignore */
                break;

            case 0x0f:              // F$Perr
                f_perr();
                break;
            case 0x10:              // F$Pnam
                f_prsnam();
                break;
            case 0x12:              // F$SchBit
                f_schbit();
                break;
            case 0x13:
                f_allbit();           // F$ABit
                break;
            case 0x14:
                f_delbit();           // F$DBit
                break;
            case 0x15:              // F$Time
                f_time();
                break;

            case 0x16:              // F$STim
                /* Ignore */
                break;

            case 0x17:
                f_crc();
                break;

            case 0x2c:             // F$AProc
                f_aproc();
                break;

            case 0x82:
                i_dup();
                break;

            case 0x83:
                i_crea();          // I$Crea
                break;

            case 0x84:              // I$Open
                i_open();
                break;

            case 0x85:
                i_mdir();
                break;

            case 0x86:
                i_chgdir();
                break;

            case 0x87:
                i_deletex(0);
                break;

            case 0x88:
                i_seek();
                break;

            case 0x89:
                i_read();
                break;

            case 0x8a:
                i_write();
                break;

            case 0x8b:
                i_rdln();
                break;

            case 0x8c:
                i_wrln();
                break;

            case 0x8d:
                i_getstt();
                break;

            case 0x8e:
                i_setstt();
                break;

            case 0x8f:
                i_close();
                break;

            case 0x90:
                i_deletex(1);
                break;

            default:
                pc.set(pc.intValue() - 1);
                LOGGER.error("Uncaught SWI2 call request {}", Integer.toHexString(read(pc.intValue())));
                System.exit(0);
            }
    }

}
