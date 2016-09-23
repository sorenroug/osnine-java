package org.roug.osnine.os9;

import java.io.InputStream;

import org.roug.osnine.MC6809;
import org.roug.osnine.MC6850;
import org.roug.osnine.MemoryBank;
import org.roug.osnine.RegisterCC;
import java.util.Properties;
import java.io.File;

public class OS9 extends MC6809 {

    private static final int NumPaths = 16; // Whatever _NFILE is set to in os9's stdio.h
    private static final int DefIOSiz = 12;
    public static final int MAX_DEVS = 64;
    public static final int MAX_PIDS = 32;
    public static final int BITMAP_START = 0x200; // Start of memory bitmap

    public static final int TOPMEM = 0xfa00;

    public static final int MDIR_START = 0x300;

    public static final int MDIR_END   = 0x400;

    private PathDesc[] paths = new PathDesc[NumPaths];
    private String cxd; //!< Execution directory, typically /d0/CMDS
    private String cwd; //!< Working directory
    private String sys_dev;  //!< System device - as known from init module
    /** Top of RAM. */
    private int topOfRealRAM; //!< Absolute values
    private int bottomOfRAM = 0;
    private DevDrvr[] devices = new DevDrvr[MAX_DEVS]; //!< devices, typically /d0,/h0 etc.
    private int dev_end = 0;
    private int pids[] = new int[MAX_PIDS]; //!< Mapping of Process identifiers
    private int pid_end;
    private boolean debug_syscall;



    /**
     * Constructor.
     */
    public OS9() {
        super(0xFF00);
        topOfRealRAM = 0xFF00;
        SWI2Trap trap = new SWI2Trap(this);
        this.insertMemorySegment(trap);

	DevDrvTerm tmpdev = new DevDrvTerm("/term", "/dev/tty");

	debug_syscall = false;
	for (int inx = 0; inx < NumPaths; inx++) {
	    paths[inx] = null;
	}
	// Set up stdin, stdout and stderr.
	paths[0] = tmpdev.open("/dev/tty", 1, false);
	paths[1] = tmpdev.open("/dev/tty", 2, false);
	paths[2] = tmpdev.open("/dev/tty", 2, false);

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
    }

    public void setCWD(String directory) {
        cwd = directory;
    }

    public void setCXD(String directory) {
        cxd = directory;
    }

    /**
     * copytomemory: copy a UNIX string to memory at byte position
     * String is NULL-terminated, but becomes CR-terminated when
     * copied to OS9 memory.
     */
    void copytomemory(int addr, String from) {
        byte[] fromB = from.getBytes();
        for (int i = 0; i < from.length(); i++) {
            write(addr + i, fromB[i]);
        }
        write(addr + from.length(), '\r');
    }

    /**
     * Load a file into memory as a module including allocating a data area and
     * creating a process descriptor.
     *  - INPUT:
     *    - (X) = Address of module name or file name
     */
    public void loadmodule(String parm) {
        PathDesc fd;
        int moduleAddr;
        DevDrvr dev;
        int val;
        byte[] parmBytes;

        f_load();
        moduleAddr = y.intValue();

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
        d.set(parm.length());
        f_srqmem(); // Request memory for parm area. Returned in U
        s.set(y.intValue() - d.intValue());
        // Copy the parm value into memory
        parmBytes = parm.getBytes();
        int parmInx = 0;
        for (int i = s.intValue(); i < y.intValue() ; i++) {
            write(i, (int)parmBytes[parmInx]);
            parmInx++;
        }
        // Sect. 8.2: The U register will have the lower bound of the data memory
        // area, and the DP register will contain its page number.
        d.set(read_word(moduleAddr + 0x0b));
        f_srqmem(); // Request memory for data area. Returned in U
        if (debug_syscall) {
            System.err.printf("module size: %04X\n",  read_word((moduleAddr + 0x02)));
            System.err.printf("execution offset: %04X\n",  read_word((moduleAddr + 0x09)));
            System.err.printf("permanent storage size: %04X\n",  read_word((moduleAddr + 0x0b)));
        }
        x.set(s.intValue());
        dp.set(u.intValue() >> 8);
        createProcess(moduleAddr, d.intValue());
        cc.setF(0);
        cc.setI(0);
        if (debug_syscall) {
            System.err.printf("loadmodule: PC:%04X U:%04X DP:%02X X:%04X Y:%04X S:%04X\n",
                pc.intValue(), u.intValue(), dp.intValue(), x.intValue(), y.intValue(), s.intValue());
        }
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
        int mdirp, mcand, mname, maddr;

        if (debug_syscall) {
            System.err.printf("OS9::f_link: x=%04X a=%02X\n", x.intValue(), a.intValue());
        }
        mcand = x.intValue();
    //    f_prsnam();
        for (mdirp = MDIR_START; mdirp < MDIR_END; mdirp += 4) {
            maddr = read_word(mdirp);
            if (maddr == 0)
                continue;
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
        byte modhead[] = new byte[14];
        DevDrvr dev;
        PathDesc fd;
        int modname = 0;
        int modsize = 0;
        int langtype = 0;

        getpath(x.intValue(), upath, true);
        f_prsnam();

        if (debug_syscall) {
            System.err.printf("OS9::f_load: %s\n", upath.toString());
        }

        dev = find_device(upath.toString());
        if (dev == null) {
            sys_error(ErrCodes.E_MNF);
            return;
        }
        fd = dev.open(upath.substring(dev.getMntPoint().length()), 5, false);
        if (fd == null) {
            sys_error(ErrCodes.E_PNNF);
            return;
        }

        boolean first = true;
        // Read 1 or more modules into memory
        while (true) {
            if (fd.read(modhead, 14) == -1)
                break;
            d.set(modsize = modhead[2] * 256 + modhead[3]); // Module size
            f_srqmem();                      // Request memory of D size
            copyBufferToMemory(modhead, u.intValue(), 14);   // copy the header
            readIntoMemory(fd, u.intValue() + 14, modsize - 14); // Read the rest
            add_to_mdir(u.intValue());
            if (first) {
                first = false;
                modname = u.intValue() + modhead[4] * 256 + modhead[5];
                langtype = modhead[6];
            }
        }
        fd.close();
        //if (fd.usecount == 0) delete fd;

        x.set(modname);
        a.set(langtype);  // (A) - Language / type
        f_link();
    }

    /**
     * Copy a byte buffer to memory.
     */
    private void copyBufferToMemory(byte[] buf, int startAddr, int len) {
        for (int i = 0; i < len; i++) {
            write(startAddr + i, buf[1]);
        }
    }

    /**
     * Read a specied number of bytes into memory.
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
        }

        for (; read(mp) != 0; mp++) {
            if (read(mp) <= '-' || read(mp) == '<' || read(mp) == '>')
                break;
            unixPath.append(read(mp) & 0x7f);
            if ((read(mp) & 0x80) == 0x80)
                break;
        }

        // Skip past spaces
        for (;read(mp) == ' '; mp++)
           ;
        return mp - mem;
    }

    /**
     * Compare two OS9 case-insensitive strings. A string is terminated with
     * highorder bit set, CR or NULL
     */
    int os9strcmp(int str1, int str2) {
	for (;(read(str1) & 0x5f) == (read(str2) & 0x5f); str1++, str2++)
	    if (read(str1) > 0x7f || read(str1) < 32)
		return 0;
	return (read(str1) & 0x5f) - (read(str2)& 0x5f);
    }

    public void addDevice(DevDrvr device) {
        if (dev_end < MAX_DEVS ) {
            devices[dev_end++] = device;
        } else {
            System.err.printf("Overflow: %s device not added as OS9 device\n", device.toString());
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
	if (debug_syscall)
            System.err.printf("No driver for %s\n", new String(path));
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
        int base = x.intValue();
        while (from < to) {
            int addr = x.intValue() + (from / 8);
            int oldVal = read(addr);
            write(addr, oldVal & ~(0x80 >> (from % 8)));
            from++;
        }
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
        return;
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
                return;
            }
        }
        sys_error(ErrCodes.E_NoRam);
        return;
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
        return;
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
    private void createProcess(int moduleStart, int allocatedMemory) {
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

        if (debug_syscall) {
            System.err.printf("OS9::f_prsnam: X:%4X\n", tmpX);
        }

        if (read(tmpX) == '/' || Character.isLetterOrDigit(read(tmpX)) || read(tmpX) == '_' || read(tmpX) == '.') {
            p = tmpX;

            while (read(p) == '/')   // Skip slash(es)
                p++;

            x.set(p);

            int m = read(p);
            while (m == '_' || m == '.' || Character.isLetterOrDigit(m) ) {
                p++;
                m = read(p);
            }
            y.set(p);
            b.set(y.intValue() - x.intValue());
            if (debug_syscall) {
                for (int i = 0; i < b.intValue(); i++)
                    System.err.printf("%c", read(x.intValue() + i));
                System.err.printf("\n");
            }
        } else {
            // We are not pointing to a pathname
            tmpX = x.intValue();
            while (read(tmpX) == ' ' || read(tmpX) == '\t') {
                tmpX++;
            }
            x.set(tmpX);
            sys_error(ErrCodes.E_BNam);
            if (debug_syscall)
                System.err.printf("(whitespace)\n");
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
	for (;(read(strx) & 0x5f) == (read(stry) & 0x5f); strx++, stry++) {
	    if (read(stry) > 0x7f || strx > (x.intValue() + b.intValue()))
		cc.setC(0);
	}
    //  if ((read(strx) & 0x5f) - (read(stry) & 0x5f))
    //      cc.setC(0);
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

}
