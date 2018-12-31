package org.roug.osnine.mo5;

import org.roug.osnine.MemorySegment;

/**
 * Screen memory at $0000 to $1FFF (or 1F3F).
 * When the machine writes a byte here then the screen is repainted.
 * The pixel and color information is multiplexed on the same addresses.
 * To select bank the user must write to bit 0 of address 0xA7C0:
 *   0 = color, 1 = pixels
 *
 */
public class ScreenMemory extends MemorySegment {

    private static final int SIZE = 8192;

    /** Memory space. */
    private byte[] pixels; // FORME/FOND
    private byte[] color; //

    /** The graphical effect of modifying these bytes. */
    private Screen screen;

    /**
     * Constructor.
     * The screen memory is always 8192 bytes, but only uses 8000.
     *
     * @param screen - Connection to the GUI
     */
    public ScreenMemory(Screen screen) {
        super(0, SIZE);
        this.screen = screen;
        pixels = new byte[SIZE];
        color = new byte[SIZE];
    }

    @Override
    protected int load(int addr) {
        if (screen.isPixelBankActive())
            return pixels[addr - getStartAddress()] & 0xFF;
        else
            return color[addr - getStartAddress()] & 0xFF;
    }

    @Override
    protected void store(int addr, int val) {
        int relAddr = addr - getStartAddress();
        if (screen.isPixelBankActive())
            pixels[relAddr] = (byte)(val & 0xFF);
        else
            color[relAddr] = (byte)(val & 0xFF);

        screen.updatePixels(addr, pixels[relAddr], color[relAddr]);
    }

}
