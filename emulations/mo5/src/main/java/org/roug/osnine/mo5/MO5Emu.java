package org.roug.osnine.mo5;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.Insets;
import javax.swing.*;

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

public class MO5Emu {

    private static final Logger LOGGER = LoggerFactory.getLogger(MO5Emu.class);

    private JFrame guiFrame;
    private PIA6821MO5 pia;

    private Bus8Motorola bus;
    private MC6809 cpu;

    /** The display of the MO5. */
    private Screen screen;

    public static void main(String[] args) throws Exception {
        new MO5Emu();
    }

    public MO5Emu() throws Exception {
        guiFrame = new JFrame("MO5 emulator");
        guiFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JMenuBar guiMenuBar = new JMenuBar();
        guiFrame.setJMenuBar(guiMenuBar);
        addFileMenu(guiMenuBar);

        // Create screen and attach it to the bus.
        screen = new Screen();
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

        // Hook up the Keyboard to the PIA
        Keyboard keyboard = new Keyboard(pia);
        screen.addKeyListener(keyboard);
        guiFrame.add(screen);
        guiFrame.pack();

        screen.requestFocusInWindow();
        guiFrame.setVisible(true);
        cpu.reset();

        LOGGER.info("Starting CPU");
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
    private InputStream openFile(String fileToLoad)
                            throws FileNotFoundException {
        InputStream moduleStream = null;

        if (fileToLoad.contains("/")) {
            moduleStream = new FileInputStream(fileToLoad);
        } else {
            moduleStream = MO5Emu.class.getResourceAsStream("/" + fileToLoad);
        }
        if (moduleStream == null) {
            throw new FileNotFoundException("File not found: " + fileToLoad);
        }
        return moduleStream;
    }

    /**
     * Load a file containing data for memory.
     */
    private void loadROM(String fileToLoad, int loadAddress)
                            throws IOException, FileNotFoundException {
        LOGGER.debug("Loading {} at {}", fileToLoad,
                Integer.toHexString(loadAddress));

        InputStream moduleStream = openFile(fileToLoad);
        int b = moduleStream.read();
        while (b != -1) {
            bus.forceWrite(loadAddress, b);
            loadAddress++;
            b = moduleStream.read();
        }
        moduleStream.close();
    }

    private void addFileMenu(JMenuBar guiMenuBar) {
        JMenu guiMenuFile = new JMenu("File");

        JMenuItem guiMenuFileZoom2 = new JMenuItem("Zoom 2x");
        guiMenuFileZoom2.addActionListener(new Zoom2Action());
        guiMenuFile.add(guiMenuFileZoom2);

        JMenuItem guiMenuFileZoom4 = new JMenuItem("Zoom 4x");
        guiMenuFileZoom4.addActionListener(new Zoom4Action());
        guiMenuFile.add(guiMenuFileZoom4);

        JMenuItem guiMenuFileReset = new JMenuItem("Reset CPU");
        guiMenuFileReset.addActionListener(new ResetAction());
        guiMenuFile.add(guiMenuFileReset);

        JMenuItem guiMenuFileExit = new JMenuItem("Exit");
        guiMenuFileExit.addActionListener(new QuitAction());
        guiMenuFile.add(guiMenuFileExit);

        guiMenuBar.add(guiMenuFile);
    }

    private class QuitAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            System.exit(0);
        }
    }

    private class ResetAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            cpu.signalReset();
        }
    }

    private class Zoom2Action implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            screen.setPixelSize(2);
            guiFrame.pack();
        }
    }

    private class Zoom4Action implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            screen.setPixelSize(4);
            guiFrame.pack();
        }
    }

}
