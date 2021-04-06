package org.roug.osnine.wasm;

import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.Toolkit;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.IOException;
import java.net.URL;
import java.util.Properties;
import java.util.Timer;
import java.util.TimerTask;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;

import org.roug.ui.terminal.AvailableEmulations;
import org.roug.ui.terminal.JTerminal;
import org.roug.ui.terminal.EmulationCore;
import org.roug.usim.Acia;
import org.roug.usim.Acia6850;
import org.roug.usim.Bus8Motorola;
import org.roug.usim.BusStraight;
import org.roug.usim.HWClock;
import org.roug.usim.IRQBeat;
import org.roug.usim.mc6809.MC6809;
import org.roug.usim.RandomAccessMemory;
import org.roug.usim.VirtualDisk;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * GUI for generic emulator
 */
public class GUI {

    private static final Logger LOGGER = LoggerFactory.getLogger(GUI.class);

    private static final int CLOCKDELAY = 500;  // milliseconds
    /** The interrupt is 50 times a second. */
    private static final int CLOCKPERIOD = 20;  // milliseconds

    private JFrame guiFrame;

    private DiskDialog d0Dialog, d1Dialog;

    private Bus8Motorola bus;
    private MC6809 cpu;

    private Acia6850 term;

    private VirtualDisk diskDevice;

    private HWClock hwClock;

    /** The display of the emulator. */
    private JTerminal screen1;

    private int loadStart = 0;

    private Properties configMap = new Properties();
    /**
     * Create emulator application.
     */
    public GUI(Properties config) throws Exception {
        configMap = config;
        //String bootMode = configMap.getProperty("bootmode", "multiuser");
        String terminalType = configMap.getProperty("term.type");
        String fontSizeStr = configMap.getProperty("term.fontsize");
        int fontSize;
        try {
            fontSize = Integer.parseInt(fontSizeStr);
        } catch (NumberFormatException e) {
            fontSize = 16;
        }

        guiFrame = new JFrame("OS-9 emulator");
        //guiFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JMenuBar guiMenuBar = new JMenuBar();
        guiFrame.setJMenuBar(guiMenuBar);

        addFileMenu(guiMenuBar);
        //addEditMenu(guiMenuBar);
        addDevicesMenu(guiMenuBar);
        //addHelpMenu(guiMenuBar);

        bus = new BusStraight();

        RandomAccessMemory ram = new RandomAccessMemory(0x0000, 0x10000);
        bus.addMemorySegment(ram);

//      ReadOnlyMemory rom = new ReadOnlyMemory(0xC000, 0x4000);
//      bus.insertMemorySegment(rom);

        IRQBeat irqBeat = new IRQBeat(0xFFD0, bus, 20);
        bus.insertMemorySegment(irqBeat);

        term = new Acia6850(0xFFD4, bus);
        bus.insertMemorySegment(term);
        EmulationCore emulation = AvailableEmulations.createEmulation(terminalType);
        screen1 = new JTerminal(term, emulation);
//      screen1.setFontFace("Bitstream Vera Sans Mono");
        screen1.setFontSize(fontSize);
        AciaToScreen atc1 = new AciaToScreen(term, screen1);
        atc1.execute();

        hwClock = new HWClock(0xFFDA, bus);
        bus.insertMemorySegment(hwClock);

        diskDevice = new VirtualDisk(0xFFD1, bus);
        bus.insertMemorySegment(diskDevice);

        d0Dialog = new DiskDialog(guiFrame, diskDevice, 0);
        d1Dialog = new DiskDialog(guiFrame, diskDevice, 1);

        loadROM(0xF000, "OS9p1", "OS9p2", "SysGoSingle",
                    "BootDyn", "HWClock", "VDisk_rv2");
        loadROM(0x3800, "D0", "D1", "IOMan_ed4", "SCF_ed8", "Acia_ed2", "RBF_ed8",
                     "Term", "PipeMan", "Piper", "Pipe");
        loadROM("Shell"); // Don't rely on the harddisk

        cpu = new MC6809(bus);

        // Interrupt vectors
        setWord(MC6809.RESET_ADDR, 0xF076);
        setWord(MC6809.SWI3_ADDR, 0x100);
        setWord(MC6809.SWI2_ADDR, 0x103);
        setWord(MC6809.SWI_ADDR, 0x106);
        setWord(MC6809.IRQ_ADDR, 0x10C);
        setWord(MC6809.FIRQ_ADDR, 0x10F);

        guiFrame.add(screen1);

        guiFrame.pack();

        guiFrame.addWindowFocusListener(new WindowAdapter() {
            @Override
            public void windowGainedFocus(WindowEvent e) {
                screen1.requestFocusInWindow();
            }
        });

        screen1.requestFocusInWindow();
        guiFrame.setVisible(true);
        int start = cpu.read_word(MC6809.RESET_ADDR);
        cpu.reset();
        cpu.pc.set(start);

        LOGGER.debug("Starting CPU");
        Thread cpuThread = new Thread(cpu, "cpu");
        cpuThread.start();

    }

    /**
     * Load an disk image into a drive. Used by the command line parameters.
     */
    void setDisk(int driveNumber, File diskFile)
                throws IOException, FileNotFoundException {
        diskDevice.setDisk(driveNumber, diskFile);
    }

    /**
     * Write a two-byte value into a memory location.
     */
    private void setWord(int address, int value) {
        LOGGER.debug("Writing word {} at {}", value, address);
        bus.forceWrite(address, (value >> 8) & 0xFF);
        bus.forceWrite(address + 1, value & 0xFF);
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
            moduleStream = GUI.class.getResourceAsStream("/" + fileToLoad);
        }
        if (moduleStream == null) {
            throw new FileNotFoundException("File not found: " + fileToLoad);
        }
        return moduleStream;
    }

    private void loadROM(String... filesToLoad)
                            throws IOException, FileNotFoundException {
        loadROM(loadStart, filesToLoad);
    }

    /**
     * Load a file containing data for memory.
     */
    private void loadROM(int loadAddress, String... filesToLoad)
                            throws IOException, FileNotFoundException {
        for (String fileToLoad : filesToLoad) {
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
            loadStart = loadAddress;
        }
    }

    private void addFileMenu(JMenuBar guiMenuBar) {
        JMenu guiMenu = new JMenu("File");
        guiMenu.setMnemonic(KeyEvent.VK_F);

        JMenuItem menuItem;

        menuItem = new JMenuItem("Decrease font size");
        menuItem.addActionListener(new DecreaseFontAction());
        guiMenu.add(menuItem);

        menuItem = new JMenuItem("Increase font size");
        menuItem.addActionListener(new IncreaseFontAction());
        guiMenu.add(menuItem);

        menuItem = new JMenuItem("Reset CPU");
        menuItem.addActionListener(new ResetAction());
        guiMenu.add(menuItem);

        menuItem = new JMenuItem("Exit");
        menuItem.setMnemonic(KeyEvent.VK_X);
        menuItem.addActionListener(new QuitAction());
        guiMenu.add(menuItem);

        guiMenuBar.add(guiMenu);
    }


    private void addDevicesMenu(JMenuBar guiMenuBar) {
        JMenu guiMenu = new JMenu("Devices");
        guiMenu.setMnemonic(KeyEvent.VK_D);

        JMenuItem menuItem = new JMenuItem("Drive /D0");
        menuItem.setMnemonic(KeyEvent.VK_0);
        menuItem.addActionListener(new D0Action());
        guiMenu.add(menuItem);

        menuItem = new JMenuItem("Drive /D1");
        guiMenu.setMnemonic(KeyEvent.VK_1);
        menuItem.addActionListener(new D1Action());
        guiMenu.add(menuItem);

        guiMenuBar.add(guiMenu);
    }

    private static class QuitAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            System.exit(0);
        }
    }

    private class D0Action implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            d0Dialog.setVisible(true);
        }
    }

    private class D1Action implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            d1Dialog.setVisible(true);
        }
    }

    private class ResetAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            cpu.signalReset();
        }
    }

    private class DecreaseFontAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            int fs = screen1.getFontSize();
            if (fs >= 10) fs -= 2;
            screen1.setFontSize(fs);
            guiFrame.pack();
        }
    }

    private class IncreaseFontAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            int fs = screen1.getFontSize();
            if (fs <= 30) fs += 2;
            screen1.setFontSize(fs);
            configMap.setProperty("term.fontsize", Integer.toString(fs));
            guiFrame.pack();
        }
    }

    private class AboutAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            JOptionPane.showMessageDialog(guiFrame,
                String.format("%s v. %s%nby Søren Roug",
                    getClass().getPackage().getImplementationTitle(),
                    getClass().getPackage().getImplementationVersion()));
        }
    }
}
