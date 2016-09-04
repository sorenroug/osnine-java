package org.roug.osnine.os9;

import java.io.InputStream;

import org.roug.osnine.MC6809;
import org.roug.osnine.MC6850;
import org.roug.osnine.MemoryBank;
import org.roug.osnine.RegisterCC;


public class OS9 extends MC6809 {

    private static final int NumPaths = 16; // Whatever _NFILE is set to in os9's stdio.h
    private static final int DefIOSiz = 12;
    public static final int MAX_DEVS = 64;
    public static final int MAX_PIDS = 32;
    public static final int BITMAP_START = 0x200; // Start of memory bitmap

    private PathDesc[] paths = new PathDesc[NumPaths];
    private String cxd; //!< Execution directory, typically /d0/CMDS
    private String cwd; //!< Working directory
    private String sys_dev;  //!< System device - as known from init module
    private int uppermem; //!< Absolute values
    private int lowermem;
    private DevDrvr[] devices = new DevDrvr[MAX_DEVS]; //!< devices, typically /d0,/h0 etc.
    private int dev_end;
    private int pids[] = new int[MAX_PIDS]; //!< Mapping of Proces identifiers
    private int pid_end;
    private boolean debug_syscall;

    /**
     * 
     */
    public static void main(String[] args) throws Exception {
        OS9 cpu = new OS9();

        MC6850 uart = new MC6850(0xb000);
        cpu.addMemorySegment(uart);

        cpu.setDebugCalls(1);
        // Put the initial command into an unused area of the memory.
        cpu.copytomemory(0xfe00, (args.length == 0) ? "shell" : args[0]);
        cpu.x.set(0xfe00);
        String parm = createParm(args);
        cpu.loadmodule(parm);
        cpu.run();
        System.out.flush();
    }

    /**
     * Construct the parameters from the arguments given to the application.
     * Java has split the command line for us. We now have to put it back to one string.
     */
    private static String createParm(String[] args) {
        String result = "";
        for (int i = 1; i < args.length; i++) {
            result = result + args[i];
            if (i + 1 < args.length) result = result + " ";
        }
        result = result + "\r";
        return result;
    }

    public OS9() {
        super(0x10000);
        SWI2Trap trap = new SWI2Trap(this);
        this.insertMemorySegment(trap);
        // Block reserved space in bitmap
        x.set(BITMAP_START);
        d.set(255);
        y.set(1);
        f_allbit();
        x.set(0);
        d.set(0);
        y.set(0);
    }

    /**
     * Stub.
     * 1 = print syscalls, 2 = print reads/writes
     */
    private void setDebugCalls(int flag) {
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
    private void loadmodule(String parm) {
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
        uppermem = moduleAddr + ((read(moduleAddr + 0x0b) + 1) << 8)
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

    private void createProcess(int moduleStart, int allocatedMemory) {
    //FIXME
    }


    void f_load() {
    //FIXME
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
           y.set(uppermem);
           d.set(uppermem - lowermem);
       } else {
       // FIXME: check that the program requests less than what we have
           y.set(uppermem);
           d.set(uppermem - lowermem);
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

}
