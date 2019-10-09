package org.roug.osnine.genericos9;

import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.Toolkit;
import java.net.URL;
import javax.help.CSH;
import javax.help.HelpBroker;
import javax.help.HelpSet;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.SwingUtilities;

import org.roug.osnine.Acia;
import org.roug.osnine.Acia6850;
import org.roug.osnine.Bus8Motorola;
import org.roug.osnine.BusStraight;
import org.roug.osnine.HWClock;
import org.roug.osnine.IRQBeat;
import org.roug.osnine.MC6809;
//import org.roug.osnine.PIA6821;
import org.roug.osnine.RandomAccessMemory;
//import org.roug.osnine.ReadOnlyMemory;
import org.roug.osnine.VirtualDisk;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.IOException;
import java.util.Timer;
import java.util.TimerTask;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * GUI for generic emulator
 */
public class GUI {

    private static final Logger LOGGER = LoggerFactory.getLogger(GUI.class);

    private static final int CLOCKDELAY = 500;  // milliseconds
    /** On MO5 the interrupt is 50 times a second. */
    private static final int CLOCKPERIOD = 20;  // milliseconds

    private JFrame guiFrame;

    private PrinterDialog printerDialog;

    private Bus8Motorola bus;
    private MC6809 cpu;

    /** Serial devices. T3 will be used for printer. */
    private Acia6850 t1,t2,t3;

    private VirtualDisk d0;

    private HWClock hwClock;

    /** The display of the emulator. */
    private Screen screen1;

    private int loadStart = 0;

    /** Content of clipboard to be sent into the emulator as key events. */
    private String pasteBuffer;
    private int pasteIndex;

    private final JFileChooser fc = new JFileChooser(new File("."));

    /**
     * Create emulator application.
     */
    public GUI() throws Exception {
        guiFrame = new JFrame("OS-9 emulator");
        guiFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JMenuBar guiMenuBar = new JMenuBar();
        guiFrame.setJMenuBar(guiMenuBar);

        addFileMenu(guiMenuBar);
        addEditMenu(guiMenuBar);
        addDevicesMenu(guiMenuBar);
        addHelpMenu(guiMenuBar);

        bus = new BusStraight();

        RandomAccessMemory ram = new RandomAccessMemory(0x0000, bus, "0x10000");
        bus.addMemorySegment(ram);

//      ReadOnlyMemory rom = new ReadOnlyMemory(0xC000, bus, "0x4000");
//      bus.insertMemorySegment(rom);

        IRQBeat irqBeat = new IRQBeat(0xFF00, bus, "20");
        bus.insertMemorySegment(irqBeat);

        t1 = new Acia6850(0xFF02, bus);
        bus.insertMemorySegment(t1);
        screen1 = new Screen(t1);
        AciaToScreen atc1 = new AciaToScreen(t1, screen1);
        atc1.execute();

        t2 = new Acia6850(0xFF04, bus);
        bus.insertMemorySegment(t2);

        printerDialog = new PrinterDialog(guiFrame);

        t3 = new Acia6850(0xFF06, bus);
        bus.insertMemorySegment(t3);
        AciaToScreen atc3 = new AciaToScreen(t3, printerDialog);
        atc3.execute();

        hwClock = new HWClock(0xFF10, bus);
        bus.insertMemorySegment(hwClock);

        d0 = new VirtualDisk(0xFF40, bus, "OS9.dsk");
        bus.insertMemorySegment(d0);


        loadROM(0xF000, "OS9p1_d64", "OS9p2_ed9", "SysGo", "Init",
                "BootDyn", "HWClock");
        loadROM(0x3800, "IOMan_ed4", "SCF_ed8", "Acia_ed4", "RBF_ed8", "VDisk",
                "D0", "T1", "P");

        cpu = new MC6809(bus);

        setWord(MC6809.RESET_ADDR, 0xF076);
        setWord(MC6809.SWI3_ADDR, 0x100);
        setWord(MC6809.SWI2_ADDR, 0x103);
        setWord(MC6809.SWI_ADDR, 0x106);
        setWord(MC6809.IRQ_ADDR, 0x10C);
        setWord(MC6809.FIRQ_ADDR, 0x10F);

        guiFrame.setSize(900, 600);
        guiFrame.add(screen1);

        //guiFrame.pack();

        screen1.requestFocusInWindow();
        guiFrame.setVisible(true);
        int start = cpu.read_word(MC6809.RESET_ADDR);
        cpu.reset();
        cpu.pc.set(start);

        LOGGER.debug("Starting CPU");
        Thread cpuThread = new Thread(cpu, "cpu");
        cpuThread.start();

/*
        LOGGER.debug("Starting heartbeat every 20 milliseconds");
        TimerTask clocktask = new ClockTask();

        Timer timer = new Timer("clock", true);
        timer.schedule(clocktask, CLOCKDELAY, CLOCKPERIOD);
        */
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
     * Set the size of the window.
     *
     * @param size size of a pixel in host computer pixels.
     */
    void setPixelSize(int size) {
        //screen1.setPixelSize(size);
        guiFrame.pack();
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

        JMenuItem menuItem = new JMenuItem("Zoom 1x");
        menuItem.addActionListener(new Zoom1Action());
        guiMenu.add(menuItem);

        menuItem = new JMenuItem("Zoom 2x");
        menuItem.addActionListener(new Zoom2Action());
        guiMenu.add(menuItem);

        menuItem = new JMenuItem("Zoom 4x");
        menuItem.addActionListener(new Zoom4Action());
        guiMenu.add(menuItem);

        menuItem = new JMenuItem("Reset CPU");
        menuItem.addActionListener(new ResetAction());
        guiMenu.add(menuItem);

        menuItem = new JMenuItem("Exit");
        menuItem.addActionListener(new QuitAction());
        guiMenu.add(menuItem);

        guiMenuBar.add(guiMenu);
    }

    private void addEditMenu(JMenuBar guiMenuBar) {
        JMenu guiMenu = new JMenu("Edit");

        JMenuItem menuItem = new JMenuItem("Paste text");
        menuItem.addActionListener(new PasteAction());
        guiMenu.add(menuItem);

        guiMenuBar.add(guiMenu);
    }

    private void addHelpMenu(JMenuBar guiMenuBar) {
        String helpHS = "javahelp-os9/jhelpset.hs";
        ClassLoader cl = GUI.class.getClassLoader();
        HelpSet hs;
        try {
            URL hsURL = HelpSet.findHelpSet(cl, helpHS);
            hs = new HelpSet(null, hsURL);
        } catch (Exception ee) {
            LOGGER.error("HelpSet "+ helpHS +" not found");
            return;
        }

        HelpBroker hb = hs.createHelpBroker();

        JMenu guiMenu = new JMenu("Help");

        JMenuItem menuItem = new JMenuItem("Quick Reference");
        menuItem.addActionListener(new CSH.DisplayHelpFromSource(hb));
        guiMenu.add(menuItem);

        menuItem = new JMenuItem("About");
        menuItem.addActionListener(new AboutAction());
        guiMenu.add(menuItem);

        guiMenuBar.add(guiMenu);
    }

    private void addDevicesMenu(JMenuBar guiMenuBar) {
        JMenu guiMenuDevices = new JMenu("Devices");

        JMenuItem menuItem = new JMenuItem("Printer");
        menuItem.addActionListener(new PrinterAction());
        guiMenuDevices.add(menuItem);

        guiMenuBar.add(guiMenuDevices);
    }

    /**
     * Interrupts the CPU 50 times a second.
     * If the user has clicked 'Paste text' then sends the text one character
     * at a time to the keyboard input routine.
     */
    private class ClockTask extends TimerTask {
        private static final int PASTE_INTERVAL = 4;
        private static final int PASTE_RELEASE = PASTE_INTERVAL / 2;
        private int beats = 0;

        private boolean pasting;

        public void run() {
            if ((beats % PASTE_INTERVAL) == 0 && pasteBuffer != null) {
                int code = pasteBuffer.charAt(pasteIndex);
                pasting = true;
                LOGGER.debug("Paste {}", code);
                if (code >= 0)
                    screen1.setKey(code, true);
            }
            if ((beats % PASTE_INTERVAL) == PASTE_RELEASE && pasting) {
                int code = pasteBuffer.charAt(pasteIndex);
                if (code >= 0)
                    screen1.setKey(code, false);
                pasting = false;
                pasteIndex++;
                if (pasteIndex >= pasteBuffer.length()) {
                    pasteBuffer = null;
                    pasteIndex = 0;
                }
            }

            //pia.signalC1(PIA6821.B); // Send signal to PIA CB1
            beats++;
        }
    }

    private static class QuitAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            System.exit(0);
        }
    }

    private class PasteAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            Clipboard c = Toolkit.getDefaultToolkit().getSystemClipboard();
            try {
                pasteBuffer = (String) c.getContents(null).getTransferData(DataFlavor.stringFlavor);
                LOGGER.debug("To paste:{}", pasteBuffer);
                pasteIndex = 0;
            } catch (UnsupportedFlavorException | IOException e1) {
                LOGGER.error("Unsupported flavor", e1);
            }
        }
    }

    private class PrinterAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            printerDialog.setVisible(true);
        }
    }

    private class ResetAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            cpu.signalReset();
        }
    }

    private class Zoom1Action implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            //screen1.setPixelSize(1);
            guiFrame.pack();
        }
    }

    private class Zoom2Action implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            //screen1.setPixelSize(2);
            guiFrame.pack();
        }
    }

    private class Zoom4Action implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            //screen1.setPixelSize(4);
            guiFrame.pack();
        }
    }

    private class AboutAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            JOptionPane.showMessageDialog(guiFrame,
                String.format("%s v. %s\nby Søren Roug",
                    getClass().getPackage().getImplementationTitle(),
                    getClass().getPackage().getImplementationVersion()));
        }
    }

}
