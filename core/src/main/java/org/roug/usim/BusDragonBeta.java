package org.roug.usim;

import java.util.concurrent.locks.ReentrantLock;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * A bus that implements the Dynamic Address Translation of the Dragon 128.
 * It is assumed that bit 6 in the task register controls if the MMU is active.
 * If the bit is on then the MMU is not active and the 16 KB ROM is mapped into
 * the address space at $C000-$FFFF. The devices would be mapped at $FC00 to
 * $FEFF, shadowing the ROM underneath. The ROM has $39 in those positions.
 * If the MMU is active then the ROM is located at $FC000 to $FFFFF. I.e.
 * the bit turns on the 4 selector bits when the MPU addresses $C000 or higher.
 *
 * When OS-9 initializes the MMU, then it maps $E000 to $FE000, and $F000 to
 * $FF000. These are both ROMS blocks, the upper half having some I/O devices.
 *
 * Somehow the ROM is mapped at powerup eventhough the PIA is reset to all
 * zeros. Bit 7 might affect it, but inverted, since all tasks have bit 7 set.
 * (ORed with SysTask).
 */
public class BusDragonBeta extends BusStraight {

    private static final Logger LOGGER = LoggerFactory.getLogger(BusDragonBeta.class);

    private static final int TASK_REG = 0xFCC0;
    private static final int DAT_REGS = 0xFE00;

    /** Number of task maps in the MMU. */
    private static final int DAT_TKCT = 16;

    /** Current task number 0-15. */
    private int currentTask;

    /** Mapping when banking switch is on. */
    private int bankingLines = 0xF0000;

    private int[][] mmu = new int[DAT_TKCT][16];

    /**
     * Constructor.
     */
    public BusDragonBeta() {
        super();
    }

    /**
     * Constructor: Create bus and allocate memory from address 0 and up.
     *
     * @param memorySize - The size of the memory.
     */
/*
    public BusDragonBeta(int memorySize) {
        super();
    }
*/
    /**
     * Single byte read from memory.
     */
    @Override
    public int read(int offset) {
        int mmuInx = ((offset & 0xF000) >> 12);
        if (bankingLines == 0) {
            offset = offset & 0x0FFF | mmu[currentTask][mmuInx];
        } else {
            if (offset >= 0x0C000) {
                offset |= bankingLines;
            }
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
            if (((val & 0x80) == 0x80) && ((val & 0x40) == 0x00)) {
                bankingLines = 0;
            } else {
                bankingLines = 0xF0000;
            }
            return;
        } else if (offset >= DAT_REGS && offset < DAT_REGS + 16) {
            mmu[currentTask][offset - DAT_REGS] = (val & 0xFF) << 12;
            return;
        } else {
            int mmuInx = ((offset & 0xF000) >> 12);
            if (bankingLines == 0) {
                offset = offset & 0x0FFF | mmu[currentTask][mmuInx];
            } else {
                if (offset >= 0x0C000) {
                    offset |= bankingLines;
                }
            }
        }
        super.write(offset, val);
    }

}

