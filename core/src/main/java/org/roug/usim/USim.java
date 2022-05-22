package org.roug.usim;

import java.io.FileOutputStream;
import java.io.BufferedOutputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Generic processor run state routines.
 */
public abstract class USim implements Runnable {

    private static final int MEM_TOP = 0xFFFF;
    private static final int MEM_MAX = 0x10000;

    private static final Logger LOGGER = LoggerFactory.getLogger(USim.class);

    /** Flag: is the CPU halted? */
    public volatile boolean halted;

    /** Reference to the memory bus. */
    private MemoryBus bus;

// Generic internal registers that we assume all CPUs have

    /** Instruction Register. */
    public int ir;

    /** Program Counter. */
    public final Word pc = new Word("PC");

    /**
     * Constructor.
     *
     * @param bus The memory bus that the CPU is attached to
     */
    public USim(MemoryBus bus) {
        this.bus = bus;
    }

    /**
     * Get the memory bus.
     *
     * @return the memory bus.
     */
    public MemoryBus getBus() {
        return bus;
    }

    /**
     * Install a memory segment as the last item of the list of segments.
     *
     * @param newMemory Memory segment to add
     */
    public void addMemorySegment(MemorySegment newMemory) {
        bus.addMemorySegment(newMemory);
    }

    /**
     * Install a memory segment as the first item of the list of segments.
     *
     * @param newMemory Memory segment to insert
     */
    public void insertMemorySegment(MemorySegment newMemory) {
        bus.insertMemorySegment(newMemory);
    }

    /**
     * Read 16-bit word.
     *
     * @param offset Location in memory to read
     * @return the two-byte value at the address.
     */
    public abstract int read_word(Word offset);

    /**
     * Read 16-bit word.
     *
     * @param offset Location in memory to read
     * @return the two-byte value at the address.
     */
    public abstract int read_word(int offset);

    /**
     * Write 16-bit word.
     * @param offset Location in memory to write
     * @param val Value to write
     */
    public abstract void write_word(int offset, int val);

    /**
     * Write 16-bit word.
     * @param offset Location in memory to write
     * @param val Value to write
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
    public void stopRun() {
        halted = true;
    }

    /**
     * Fetch one memory byte from program counter and increment program counter.
     *
     * @return the byte value at the program counter address
     */
    public int fetch() {
        int val = read(pc.intValue());
        pc.add(1);

        return val;
    }

    /**
     * Fetch two memory bytes from program counter.
     *
     * @return the two-byte value at the program counter address
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
            bOut.close();
            fOut.close();
        } catch (Exception e) {
            LOGGER.error("Unable to dump core");
        }
    }

    /**
     * Invalid operation encountered. Halt the processor.
     * @param msg Message to write out
     */
    protected void invalid(final String msg) {
        LOGGER.error("invalid {} : pc = [{}], ir = [{}]",
                msg != null ? msg : "",
                Integer.toHexString(pc.intValue()),
                Integer.toHexString(ir));
        halted = true;
        //dumpCore();
        throw new RuntimeException(msg);
    }

    //----------------------------------------------------------------------------
    // Primitive (byte) memory access routines
    //----------------------------------------------------------------------------

    /**
     * Single byte read from memory.
     * @param offset Location in memory to read
     * @return the value at the address.
     */
    public int read(int offset) {
        return bus.read(offset & MEM_TOP);
    }

    /**
     * Single byte read from memory.
     * @param offset Location in memory to read
     * @return the value at the address.
     */
    public int read(Word offset) {
        return read(offset.intValue());
    }

    /**
     * Single byte write to memory.
     * @param offset Location in memory to write
     * @param val Value to write
     */
    @Deprecated
    public void write(int offset, UByte val) {
        write(offset, val.intValue());
    }

    /**
     * Single byte write to memory.
     * @param offset Location in memory to write
     * @param val Value to write
     */
    public void write(Word offset, int val) {
        write(offset.intValue(), val);
    }

    /**
     * Single byte write to memory.
     * @param offset Location in memory to write
     * @param val Value to write
     */
    public void write(int offset, int val) {
        bus.write(offset & MEM_TOP, val & 0xFF);
    }

}
