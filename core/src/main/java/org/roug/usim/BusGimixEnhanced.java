package org.roug.usim;

import java.util.concurrent.locks.ReentrantLock;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * A bus that implements the Enhanced Dynamic Address Translation of the GIMIX.
 * The DAT registers are located at addresses $FFF0-$FFFF. The task register
 * is at $FF7F.
 *
 * Since the DAT contains random values at power on, there is special logic
 * to ensure that the last 256 byte always map to $FFFxx.
 */
public class BusGimixEnhanced extends BusStraight {

    private static final Logger LOGGER = LoggerFactory.getLogger(BusGimixEnhanced.class);

    private static final int TASK_REG = 0xFF7F;
    private static final int DAT_REGS = 0xFFF0;

    private static final int PROT_START = 0x0FF00;
    private static final int PROT_END   = 0x10000;

    /** Number of task maps in the MMU. */
    private static final int DAT_TKCT = 16;

    /** Current task number 0-15. */
    private int currentTask;

    /** Mapping when banking switch is on. */
    private int bankingLines = 0xFFF00;

    /** When writing, logical address must match this bit. */
    private int writeProtectBit = 0x0;

    private int[][] mmu = new int[DAT_TKCT][16];

    /**
     * Constructor.
     */
    public BusGimixEnhanced() {
        super();
    }

    /**
     * Constructor.
     *
     * @param memoryProtection - flag to specify if memory protection is to be
     * enabled.
     */
    public BusGimixEnhanced(boolean memoryProtection) {
        super();
        if (memoryProtection) writeProtectBit = 0x80000;
    }

    /**
     * Single byte read from memory.
     */
    @Override
    public int read(int offset) {
        if (offset >= PROT_START && offset < PROT_END) {
            offset |= bankingLines;
        } else {
            int mmuInx = ((offset & 0xF000) >> 12);
            offset = offset & 0x0FFF | mmu[currentTask][mmuInx];
        }
        return super.read(offset);
    }

    /**
     * Single byte write to memory.
     */
    @Override
    public void write(int offset, int val) {
        if (offset == TASK_REG) {
            currentTask = val & 0x0F;
            return;
        } else if (offset >= DAT_REGS && offset < DAT_REGS + 16) {
            mmu[currentTask][offset - DAT_REGS] = (val & 0xFF) << 12;
            return;
        } else if (offset >= PROT_START && offset < PROT_END) {
            offset |= bankingLines;
        } else {
            int mmuInx = ((offset & 0xF000) >> 12);
            offset = offset & 0x0FFF | mmu[currentTask][mmuInx];
        }
        super.write(offset, val);
    }

}

