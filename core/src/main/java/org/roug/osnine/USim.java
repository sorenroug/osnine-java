package org.roug.osnine;

import java.io.FileOutputStream;
import java.io.BufferedOutputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Generic processor run state routines.
 */
public abstract class USim {

    private static final int MEM_TOP = 0xFFFF;
    private static final int MEM_MAX = 0x10000;

    private static final Logger LOGGER = LoggerFactory.getLogger(USim.class);

    /** Flag: is the CPU halted? */
    public boolean halted;

    /** Reference to the memory bus. */
    protected Bus6809 bus;

// Generic internal registers that we assume all CPUs have

    /** Instruction Register. */
    public int ir;

    /** Program Counter. */
    public final Word pc = new Word("PC");

    /**
     * Constructor.
     */
    public USim() {
        bus = new BusStraight();
    }

    /**
     * Constructor.
     */
    public USim(Bus6809 bus) {
        this.bus = bus;
    }

    /**
     * Constructor.
     */
    public USim(int memorySize) {
        this();
        allocate_memory(0, memorySize);
    }

    void allocate_memory(int start, int memorySize) {
        MemorySegment newMemory = new RAMMemory(start, memorySize);
        bus.addMemorySegment(newMemory);
    }

    public Bus6809 getBus() {
        return bus;
    }

    /**
     * Install a memory segment as the last item of the list of segments.
     */
    public void addMemorySegment(MemorySegment newMemory) {
        bus.addMemorySegment(newMemory);
    }

    /**
     * Install a memory segment as the first item of the list of segments.
     */
    public void insertMemorySegment(MemorySegment newMemory) {
        bus.insertMemorySegment(newMemory);
    }

    /**
     * Read 16-bit word.
     */
    public abstract int read_word(Word offset);

    /**
     * Read 16-bit word.
     */
    public abstract int read_word(int offset);

    /**
     * Write 16-bit word.
     */
    public abstract void write_word(int offset, int val);

    /**
     * Write 16-bit word.
     */
    public abstract void write_word(Word offset, Word val);

    /**
     * Reset the simulator.
     */
    public abstract void reset();

    /**
     * Output a status somehow.
     */
    public void status() {
    }

    /**
     * Execute one instruction.
     */
    public abstract void execute();

    /**
     * Run until illegal instrution is encountered and then show status.
     */
    public void run() {
        halted = false;
        while (!halted) {
            execute();
        }
        status();
    }

    /**
     * Execute one instruction and then show status.
     */
    public void step() {
        execute();
        status();
    }

    /**
     * Run until illegal instrution is encountered and show status.
     */
    public void trace() {
        halted = false;
        while (!halted) {
            execute();
            status();
        }
    }
    /*
     * Set the halt flag.
     */
    public void halt() {
        halted = true;
    }

    /**
     * Fetch one memory byte from program counter and increment program counter.
     */
    public int fetch() {
        int val = read(pc.intValue());
        pc.add(1);

        return val;
    }

    /**
     * Fetch two memory bytes from program counter.
     */
    public int fetch_word() {
        int val = read_word(pc.intValue());
        pc.add(2);

        return val;
    }

    private void dumpCore() {
        try {
            FileOutputStream fOut = new FileOutputStream("core");
            BufferedOutputStream bOut = new BufferedOutputStream(fOut, 0x1000);
            for (int i = 0; i < MEM_MAX; i++) {
                bOut.write(read(i));
            }
            bOut.flush();
            fOut.close();
        } catch (Exception e) {
        }
    }

    /**
     * Invalid operation encountered. Halt the processor.
     */
    void invalid(final String msg) {
        LOGGER.error("invalid {} : pc = [{}], ir = [{}]",
                msg != null ? msg : "",
                Integer.toHexString(pc.intValue()),
                Integer.toHexString(ir));
        halt();
        //dumpCore();
        throw new RuntimeException(msg);
    }

    //----------------------------------------------------------------------------
    // Primitive (byte) memory access routines
    //----------------------------------------------------------------------------

    /**
     * Single byte read from memory.
     */
    public int read(int offset) {
        return bus.read(offset & MEM_TOP);
    }

    /**
     * Single byte read from memory.
     */
    public int read(Word offset) {
        return read(offset.intValue());
    }

    /**
     * Single byte write to memory.
     */
    @Deprecated
    public void write(int offset, UByte val) {
        write(offset, val.intValue());
    }

    /**
     * Single byte write to memory.
     */
    public void write(Word offset, int val) {
        write(offset.intValue(), val);
    }

    /**
     * Single byte write to memory.
     */
    public void write(int offset, int val) {
        bus.write(offset & MEM_TOP, val & 0xFF);
    }

}
