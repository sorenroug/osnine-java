package org.roug.osnine.gui;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.*;

import org.roug.osnine.Bus8Motorola;
import org.roug.osnine.BusStraight;
import org.roug.osnine.MC6809;
import org.roug.osnine.RandomAccessMemory;
import org.roug.osnine.ReadOnlyMemory;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.FileInputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class GuiEmu {

    private static final Logger LOGGER = LoggerFactory.getLogger(GuiEmu.class);

    private Frame guiFrame;
    private Menu guiMenuFile;
    private PIA6821MO5 pia;

    private Bus8Motorola bus;
    private static MC6809 cpu;

    public static void main(String[] args) throws Exception {
        new GuiEmu();
    }

    public GuiEmu() throws Exception {
        guiFrame = new Frame("6809 emulator");
        guiFrame.setLayout(new BorderLayout());
        MenuBar guiMenuBar = new MenuBar();

        guiMenuFile = new Menu("File");

        guiFrame.setMenuBar(guiMenuBar);

        MenuItem guiMenuFileExit = new MenuItem("Exit");
        guiMenuFileExit.addActionListener(new QuitAction());
        guiMenuFile.add(guiMenuFileExit);

        guiMenuBar.add(guiMenuFile);

        // Create screen and attach it to the bus.
        Screen screen = new Screen();
        bus = new BusStraight();
        ScreenMemory scrMem = new ScreenMemory(bus, screen);
        bus.addMemorySegment(scrMem);

        RandomAccessMemory ram = new RandomAccessMemory(0x2000, bus, "0x8000");
        bus.addMemorySegment(ram);
        ReadOnlyMemory rom = new ReadOnlyMemory(0xC000, bus, "0x4000");
        bus.addMemorySegment(rom);
        loadROM("basic5.rom", 0xC000);
        loadROM("mo5.rom", 0xF000);

        pia = new PIA6821MO5(bus);
        bus.addMemorySegment(pia);

        cpu = new MC6809(bus);
        int start = cpu.read_word(MC6809.RESET_ADDR);

        // Hook up the Keyboard to the PIA
        Keyboard keyboard = new Keyboard(pia);
        screen.addKeyListener(keyboard);
        guiFrame.add(screen);
        guiFrame.pack();
        Insets insets = guiFrame.getInsets();
        guiFrame.setSize((int)(320 * screen.getPixelSize()
                    + (insets.left + insets.right)),
                (int)(200 * screen.getPixelSize()
                    + (insets.top + insets.bottom)));
        screen.requestFocusInWindow();
        guiFrame.setVisible(true);
        cpu.reset();
        cpu.pc.set(start);
        LOGGER.info("Starting at: {}", cpu.pc.intValue());
        Thread cpuThread = new Thread(cpu, "cpu");
        cpuThread.start();
    }

    /**
     * Open a file to load into RAM.
     * Used to look in the JAR file if the file name doesn't contain a slash.
     * @param fileToLoad Name of file to load
     * @return Opened file
     * @throws FileNotFoundException if there is no file
     */
    private static InputStream openFile(String fileToLoad)
                            throws FileNotFoundException {
        InputStream moduleStream = null;

        if (fileToLoad.contains("/")) {
            moduleStream = new FileInputStream(fileToLoad);
        } else {
            moduleStream = GuiEmu.class.getResourceAsStream("/" + fileToLoad);
        }
        if (moduleStream == null) {
            throw new FileNotFoundException("File not found: " + fileToLoad);
        }
        return moduleStream;
    }

    private void loadROM(String fileToLoad, int loadAddress)
                            throws IOException, FileNotFoundException {
        LOGGER.debug("Loading {} at {}", fileToLoad, Integer.toHexString(loadAddress));

        InputStream moduleStream = openFile(fileToLoad);
        int b = moduleStream.read();
        while (b != -1) {
            bus.forceWrite(loadAddress, b);
            loadAddress++;
            b = moduleStream.read();
        }
        moduleStream.close();
    }

    private class QuitAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            System.exit(0);
        }
    }
}
