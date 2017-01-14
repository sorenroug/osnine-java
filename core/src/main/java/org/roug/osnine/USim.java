package org.roug.osnine;

/**
 * Generic processor run state routines.
 */
public abstract class USim {

    /** Flag: is the CPU halted? */
    public boolean halted;

    /** Memory space. */
    private MemorySegment memory;

// Generic internal registers that we assume all CPUs have

    /** Instruction Register. */
    public int ir;
    /** Program Counter. */
    public final Word pc = new Word("PC");

    /**
     * Constructor.
     */
    public USim() {
    }

    /**
     * Constructor.
     */
    public USim(int memorySize) {
        this();
        allocate_memory(0, memorySize);
    }

    public void allocate_memory(int start, int memorySize) {
        MemorySegment newMemory = new MemoryBank(start, memorySize);
        addMemorySegment(newMemory);
    }

    public void addMemorySegment(MemorySegment newMemory) {
        if (memory == null) {
            memory = newMemory;
        } else {
            memory.addMemorySegment(newMemory);
        }
    }

    /**
     * Install a memory segment as the first item of the list of segments.
     */
    public void insertMemorySegment(MemorySegment newMemory) {
        newMemory.nextSegment = memory;
        memory = newMemory;
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

    /**
     * Invalid operation encountered. Halt the processor.
     */
    void invalid(final String msg) {
        System.err.format("\ninvalid %s : pc = [%04x], ir = [%04x]\r\n",
                msg == null ? msg : "",
                pc.intValue(), ir);
        halt();
        throw new RuntimeException(msg);
    }

    //----------------------------------------------------------------------------
    // Primitive (byte) memory access routines
    //----------------------------------------------------------------------------

    /**
     * Single byte read from memory.
     */
    public int read(int offset) {
        return memory.read(offset & 0xffff);
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
        memory.write(offset & 0xffff, val);
    }

}
