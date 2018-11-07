package org.roug.osnine.gui;

import java.awt.*;
import java.net.URL;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.image.*;

/**
 * Graphical screen for Thomson MO5. The dimensions are 320x200 pixels,
 * one byte per pixel. This requires 8000 bytes.
 */
public class Screen extends Canvas {

    private static final long serialVersionUID = 1L;
    private static final int COLUMNS = 320;
    private static final int ROWS = 200;

    BufferedImage buffImg;

    WritableRaster raster;

    public boolean mouse_clic = false ;

    public int mouse_X = -1, mouse_Y = -1;

    int[] pixels;

    public double pixelSize;

    private Graphics og;

    public boolean filter = false;

    /** MO5 16 colour palette. */
    private final int palette[] = {
        0x000000,
        0xF00000,
        0x00F000,
        0xF0F000,

        0x0000F0,
        0xF000F0,
        0x00F0F0,
        0xF0F0F0,

        0x636363,
        0xF06363,
        0x63F063,
        0xF0F063,

        0x0063F0,
        0xF063F0,
        0x63F0F0,
        0xF06300,
    };

    public Screen() {
        this.pixelSize = 2;
        buffImg = new BufferedImage(COLUMNS, ROWS, BufferedImage.TYPE_INT_RGB);
        raster = buffImg.getRaster();
        pixels = new int[COLUMNS * ROWS];
        for (int i = 0; i < pixels.length; i++) {
            pixels[i] = 0xff00f000;
        }
        raster.setDataElements(0, 0, COLUMNS, ROWS, pixels);
        buffImg.setData(raster);

        // Mouse Event use for Lightpen emulation
        MouseListener _Click = new MouseListener() {
            public void mouseClicked(MouseEvent e) {
            }

            public void mouseEntered(MouseEvent e) {
            }

            public void mouseExited(MouseEvent e) {
            }

            public void mousePressed(MouseEvent e) {
                mouse_X = e.getX();
                mouse_Y = e.getY();
                mouse_X = (int)((mouse_X ) / pixelSize);
                mouse_Y = (int)((mouse_Y ) / pixelSize);
                mouse_clic = true;
            }

            public void mouseReleased(MouseEvent e) {
                mouse_clic = false;
            }
        };

        MouseMotionListener _Motion = new MouseMotionListener() {
            public void mouseDragged(MouseEvent e) {
              mouse_X = e.getX();
              mouse_Y = e.getY();
              mouse_X = (int)((mouse_X ) / pixelSize);
              mouse_Y = (int)((mouse_Y ) / pixelSize);
            }

            public void mouseMoved(MouseEvent e) {

            }
        };

        this.addMouseMotionListener(_Motion);
        this.addMouseListener(_Click);

    }

    public void setPixelSize(double ps) {
        pixelSize = ps;
    }

    public double getPixelSize() {
        return pixelSize;
    }

    /**
     * Change the pixel buffer at the given address.
     * There are always 8 pixels to update.
     */
    public void updatePixels(int addr, int pixelByte, int colorByte) {
        int offset = addr * 8;
        int bgInx = colorByte & 0x0F;
        int fgInx = (colorByte & 0xF0) >> 4;
        int fgColor = palette[fgInx];
        int bgColor = palette[bgInx];
        for (int i = 0; i < 7; i++) {
            if ((pixelByte & 0x80) != 0) {
                pixels[offset + i] = fgColor;
            } else {
                pixels[offset + i] = bgColor;
            }
            pixelByte <<= 1;
        }
    }

    public void update(Graphics gc) {
        paint(gc);
    }

    @Override
    public void paint(Graphics gc) {
        raster.setDataElements(0, 0, COLUMNS, ROWS, pixels);
        if (filter) {
            Graphics2D g2 = (Graphics2D) gc;
            g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
                    RenderingHints.VALUE_INTERPOLATION_BILINEAR);
            gc = g2;
        }
        og = buffImg.getGraphics();
        gc.drawImage(buffImg, 0, 0, (int)(COLUMNS * pixelSize), (int)(ROWS * pixelSize), this);
    }
}
