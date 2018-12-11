package org.roug.osnine.mo5;

import org.roug.osnine.MemorySegment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Gate Array at $A7E4 to $A7E7.
 * The Gate Array double-register A7E4 and A7E5 allows you to read the Gate
 * Array internal counters used for video generation. The register is only
 * updated when the lightpen detects the raster beam.
 * <dl>
 * <dt>The 0xA7E4 register is made of the following bits:</dt>
 * <dd>Bits 15 to 6: GPL counter. This is incremented every 8 octets in the
 * visible area.</dd>
 * <dd>Bits 5 to 3: Octet in current segment</dd>
 * <dd>Bits 2 to 0: 1MHz, 2MHz and 4MHz clocks to specify bit.</dd>
 * </dl>
 * It takes one micro-second to paint one byte of pixels (i.e. 8 pixels).
 * During that time the 1MHz, 2MHz and 4MHz clocks go from 0 to 1 to 0 at
 * their respective frequencies. The 1 MHz can tell you which half of the
 * byte is being painted, the 2 MHz which half of the half and so on.
 * <dl>
 * <dt>0xA7E6: Line counter</dt>
 * <dd>bit 7: TL3, mirror bit of the counter above.</dd>
 * <dd>bit 6: INILN: 0 when the GA is drawing vertical borders on the left and
 * right of the screen.</dd>
 * <dt>0xA7E7</dt>
 * <dd>INITN bit 7: 0 when the GA is drawing horizontal borders above and below
 * the screen. When both INITN and INILN are set, the GA is drawing pixels.</dd>
 * </dl>
 * <h2>Light pen algorithm</h2>
 * <p>
 * The algorithm waits for the beam to get under the active area by looking for
 * INITN to go from 0 to 1 to 0. It then activates FIRQ signalling for CA1 in
 * the PIA and sets 0xA7E4 to 1.
 *
 * As soon as the 6809 detects the possibility of using the light pen, it
 * will use a special routine. The latter will set the D0 bit to the $A7E4
 * address of the gate-array, which will validate the CKLP if it occurs.
 */
public class GateArray extends MemorySegment {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(GateArray.class);

    private static final int SIZE = 4;

    private static final int INITN = 0x80;

    /** Memory space. */
    private int[] memory;

    /** The graphical effect of modifying these bytes. */
    private Screen screen;

    /**
     * Constructor.
     * The screen memory is always 8192 bytes, but only uses 8000.
     * A7E6 bit 6 is set when the beam is in the "active horizontal area"
     * A7E7 bit 7 does the same for the "active vertical area".
     *
     * @param screen - Connection to the GUI
     */
    public GateArray(Screen screen) {
        super(0xA7E4, 0xA7E4 + 4);
        this.screen = screen;
        memory = new int[SIZE];
        for (int i = 0; i < SIZE; i++) memory[i] = 0;
        memory[2] = 0x40;
        memory[3] = INITN + 0x40;
    }

    @Override
    protected int load(int addr) {
        int relAddr = addr - getStartAddress();
        memory[3] ^= INITN;
        LOGGER.debug("Load: {} - {}", relAddr, memory[relAddr] & 0xFF);
        return memory[addr - getStartAddress()] & 0xFF;
    }

    @Override
    protected void store(int addr, int val) {
        int relAddr = addr - getStartAddress();
        LOGGER.debug("Store: {} val: {}", relAddr, val);
        if (relAddr == 0) {
            screen.setIncrustation(val == 1);
        }

//      memory[relAddr] = (byte)(val & 0xFF);
    }

    /**
     * Store the lightpen coordinates in the gate array. On a real TV screen
     * the beam paints 312 lines, of which 200 lines are visible. The vertical
     * coordinate must therefore be offset by 56 rows to match. Horizontally
     * the beam paints 512 pixels (320 visible). The X coordinate must be
     * offset by 96 pixels.
     * @param x - horisonal coordinate 0 - 319
     * @param y - vertical coordinate 0 - 199
     * FIXME: Make it work.
     */
    void setLightpenXY(int x, int y) {
        if (x != -1) {
            y += 56;
            x += 96;
            int inx = (y * 64 + (x / 8)) << 3;
            memory[0] = (inx >> 8) & 0xFF;
            memory[1] = (inx & 0xF8) | (x % 8);
            memory[2] &= 0x7F | ((memory[1] << 1) & 0x80);
        } else {
            memory[0] = 0;
            memory[1] = 0;
            memory[2] = 0;
        }
    }

}
