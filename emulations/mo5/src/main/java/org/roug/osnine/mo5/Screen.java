package org.roug.osnine.mo5;

import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.awt.image.WritableRaster;
import javax.swing.JPanel;
import org.roug.osnine.Bus8Motorola;
import org.roug.osnine.PIA6821;
import org.roug.osnine.Signal;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Graphical screen for Thomson MO5. The dimensions are 320x200 pixels,
 * one byte per pixel. This requires 8000 bytes.
 */
public class Screen extends JPanel {

    private static final Logger LOGGER
                = LoggerFactory.getLogger(Screen.class);

    private static final int COLUMNS = 320;
    private static final int ROWS = 200;

    /** Key matrix flattend to one dimension. */
    private static final int KEYS = 128;

    private Bus8Motorola bus;

    /** Gate-array chip to track lightpen. */
    private GateArray gateArray;

    private PIA6821MO5 pia;

    private BufferedImage buffImg;

    private WritableRaster raster;

    private boolean lightpenButtonPressed = false ;

    private int lightpenX = -1, lightpenY = -1;

    private int[] pixels;

    private double pixelSize;

    private boolean incrustationState;

    private Signal callback;

    /** Called from PIA to signal which memory bank is active. */
    private boolean pixelBankActive;

    /** MO5 16 colour palette. */
    private final int palette[] = {
        0x000000,   // Black
        0xF00000,   // Red
        0x00F000,   // Green
        0xF0F000,   // Yellow

        0x0000F0,   // Blue
        0xF000F0,   // Magenta
        0x00F0F0,   // Cyan
        0xF0F0F0,   // White

        0x636363,   // Gray
        0xF06363,   // Pink
        0x63F063,   // Light green
        0xF0F063,   // Chicken yellow

        0x0063F0,   // Light blie
        0xF063F0,   // Parma pink
        0x63F0F0,   // Light cyan
        0xF06300,   // Orange
    };

    /** Table of keys that are pressed on the keyboard. */
    private boolean[] keyMatrix;

    /**
     * Create the canvas for pixel (and text graphics).
     *
     * @param bus the memory bus to attach devices to.
     */
    public Screen(Bus8Motorola bus) {
        this.pixelSize = 2;
        this.bus = bus;

        keyMatrix = new boolean[KEYS];
        resetAllKeys();

        buffImg = new BufferedImage(COLUMNS, ROWS, BufferedImage.TYPE_INT_RGB);
        raster = buffImg.getRaster();
        pixels = new int[COLUMNS * ROWS];
        for (int i = 0; i < pixels.length; i++) {
            pixels[i] = 0xff00f0f0;
        }
        raster.setDataElements(0, 0, COLUMNS, ROWS, pixels);
        buffImg.setData(raster);

        ScreenMemory scrMem = new ScreenMemory(this);
        bus.addMemorySegment(scrMem);

        gateArray = new GateArray(this);
        bus.addMemorySegment(gateArray);

        // Hook up the Keyboard to the screen
        Keyboard keyboard = new Keyboard(this);
        addKeyListener(keyboard);

        // Mouse Event use for Lightpen emulation
        MouseListener mouseClick = new MouseListener() {
            public void mouseClicked(MouseEvent e) {
            }

            public void mouseEntered(MouseEvent e) {
                setMouseXY(e);
            }

            public void mouseExited(MouseEvent e) {
                lightpenX = -1;
                lightpenY = -1;
                gateArray.setLightpenXY(lightpenX, lightpenY);
            }

            // The lightpen button is directly tied to PA5 on Peripheral data port A.
            public void mousePressed(MouseEvent e) {
                setMouseXY(e);
                lightpenButtonPressed = true;
                pia.setInputLine(PIA6821.A, 5, true);
            }

            public void mouseReleased(MouseEvent e) {
                lightpenButtonPressed = false;
                pia.setInputLine(PIA6821.A, 5, false);
            }
        };

        MouseMotionListener mouseMotion = new MouseMotionListener() {
            public void mouseDragged(MouseEvent e) {
                setMouseXY(e);
            }

            public void mouseMoved(MouseEvent e) {
                setMouseXY(e);
            }
        };

        this.addMouseMotionListener(mouseMotion);
        this.addMouseListener(mouseClick);

        callback = (boolean state) -> signalCA1(state);
    }

    public void connectPIA(PIA6821MO5 pia) {
        this.pia = pia;
    }

    private void setMouseXY(MouseEvent e) {
        //LOGGER.info("Setting light pen coords: {},{}", lightpenX, lightpenY);
        lightpenX = (int)(e.getX() / pixelSize);
        lightpenY = (int)(e.getY() / pixelSize);
        gateArray.setLightpenXY(lightpenX, lightpenY);
    }

    int getLightpenX() {
        return lightpenX;
    }

    void setLightpenX(int x) {
        lightpenX = x;
    }

    int getLightpenY() {
        return lightpenY;
    }

    void setLightpenY(int y) {
        lightpenY = y;
    }

    /**
     * Send a signal to PIA every 1000 cycles while in incrustation mode.
     *
     * @param state - not used
     */
    private void signalCA1(boolean dummyState) {
        pia.signalC1(PIA6821.A);
        if (incrustationState) {
            bus.callbackIn(1000, callback);
        }
    }

    /**
     * Incrustation is apparently a synchronisation signal.
     * Here we simulate that the lightpen has seen the beam.
     */
    void setIncrustation(boolean state) {
        incrustationState = state;
        if (state) {
            signalCA1(state);
        }
    }

    public void setPixelSize(double ps) {
        pixelSize = ps;
    }

    public double getPixelSize() {
        return pixelSize;
    }

    /**
     * Tell the screen if pixels or colours are selected in the PIA.
     *
     * @param flag true if pixels are chosen, false if colours are chosen
     */
    public void setPixelBankActive(boolean flag) {
        pixelBankActive = flag;
    }

    public boolean isLightpenButtonPressed() {
        return lightpenButtonPressed;
    }

    /**
     * Ask if pixels or colours are selected in the PIA.
     *
     * @return true if pixels are chosen, false if colours are chosen
     */
    public boolean isPixelBankActive() {
        return pixelBankActive;
    }

    /**
     * Called from the keyboard event handler.
     * @param i - index into key matrix
     * @param pressed - flag to say if key is on or off.
     */
    public void setKey(int i, boolean pressed) {
        keyMatrix[i] = pressed;
    }

    public boolean hasKeyPress(int i) {
        return keyMatrix[i];
    }

    public void resetAllKeys() {
        for (int i = 0; i < KEYS; i++) keyMatrix[i] = false;
    }

    /**
     * Change the pixel buffer at the given address.
     * There are always 8 pixels to update.
     * @param addr - address of screen byte. 0 is pixels 0-7 in top left corner
     * @param pixelByte - on/off for 8 pixels.
     * @param colorByte - color index for foreground and background.
     */
    public void updatePixels(int addr, int pixelByte, int colorByte) {
        if (addr >= 8000) return;
        int offset = addr * 8;
        int bgInx = colorByte & 0x0F;
        int fgInx = (colorByte & 0xF0) >> 4;
        int fgColor = palette[fgInx];
        int bgColor = palette[bgInx];
        for (int i = 0; i < 8; i++) {
            if ((pixelByte & 0x80) != 0) {
                pixels[offset + i] = fgColor;
            } else {
                pixels[offset + i] = bgColor;
            }
            pixelByte <<= 1;
        }
        repaint();
    }

    @Override
    public Dimension getPreferredSize() {
        return (new Dimension((int)(COLUMNS * pixelSize),
                              (int)(ROWS * pixelSize)));
    }

    @Override
    protected void paintComponent(Graphics gc) {
        super.paintComponent(gc);
        raster.setDataElements(0, 0, COLUMNS, ROWS, pixels);
        gc.drawImage(buffImg, 0, 0, (int)(COLUMNS * pixelSize),
                                    (int)(ROWS * pixelSize), null);
    }

}
