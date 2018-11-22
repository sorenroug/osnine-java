package org.roug.osnine.mo5;

import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.awt.image.WritableRaster;
import java.util.Timer;
import java.util.TimerTask;
import javax.swing.JPanel;
import org.roug.osnine.Bus8Motorola;
import org.roug.osnine.PIA6821;
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

    private static final int CLOCKDELAY = 500;  // milliseconds
    /** On MO5 the interrupt is 50 times a second. */
    private static final int CLOCKPERIOD = 20;  // milliseconds

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

        0x636363,
        0xF06363,
        0x63F063,
        0xF0F063,

        0x0063F0,
        0xF063F0,
        0x63F0F0,
        0xF06300,
    };

    /** Table of keys that are pressed on the keyboard. */
    private boolean[] keyMatrix;

    /**
     * Create the canvas for pixel (and text graphics).
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

        pia = new PIA6821MO5(bus, this);
        bus.addMemorySegment(pia);

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

            public void mousePressed(MouseEvent e) {
                setMouseXY(e);
                lightpenButtonPressed = true;
                // The lightpen button is directly tied to PA5 on Peripheral data port A.
                pia.setInputLine(PIA6821MO5.A, 5, true);
            }

            public void mouseReleased(MouseEvent e) {
                lightpenButtonPressed = false;
                pia.setInputLine(PIA6821MO5.A, 5, false);
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

        LOGGER.debug("Starting heartbeat every 20 milliseconds");
        TimerTask clocktask = new TimerTask() {
            public void run() {
                pia.signalC1(PIA6821.B); // Send signal to PIA CB1
            }
        };

        Timer timer = new Timer("clock", true);
        timer.schedule(clocktask, CLOCKDELAY, CLOCKPERIOD);
    }

    private void setMouseXY(MouseEvent e) {
        //LOGGER.info("Setting light pen coords: {},{}", lightpenX, lightpenY);
        lightpenX = (int)(e.getX() / pixelSize);
        lightpenY = (int)(e.getY() / pixelSize);
        gateArray.setLightpenXY(lightpenX, lightpenY);
        pia.signalCA1(true);  // Causes the PIA to send FIRQ to the CPU
    }

    void signalCA1(boolean state) {
        pia.signalCA1(state);
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

    public void setPixelSize(double ps) {
        pixelSize = ps;
    }

    public double getPixelSize() {
        return pixelSize;
    }

    /**
     * Tell the screen if pixels or colours are selected in the PIA.
     */
    public void setPixelBankActive(boolean flag) {
        pixelBankActive = flag;
    }

    public boolean isLightpenButtonPressed() {
        return lightpenButtonPressed;
    }

    /**
     * Ask if pixels or colours are selected in the PIA.
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
        if (addr >= 8000) {LOGGER.debug("Painting addr: {}", addr); return; }
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
