package org.roug.osnine.genericos9;

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
import java.util.Timer;
import java.util.TimerTask;
import javax.help.CSH;
import javax.help.HelpBroker;
import javax.help.HelpSet;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;

import org.roug.usim.Acia;
import org.roug.usim.Acia6850;
import org.roug.usim.Bus8Motorola;
import org.roug.usim.BusStraight;
import org.roug.usim.HWClock;
import org.roug.usim.IRQBeat;
import org.roug.usim.mc6809.MC6809;
import org.roug.usim.RandomAccessMemory;
import org.roug.terminal.JTerminal;
import org.roug.usim.VirtualDisk;

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
    private JDialog t1Dialog;
    private DiskDialog d0Dialog, d1Dialog;

    private Bus8Motorola bus;
    private MC6809 cpu;

    /** Serial devices. T2 will be used for printer. */
    private Acia6850 term,t1,t2;

    private VirtualDisk diskDevice;

    private HWClock hwClock;

    /** The display of the emulator. */
    private JTerminal screen1;

    private int loadStart = 0;

    /** Content of clipboard to be sent into the emulator as key events. */
    private String pasteBuffer;
    private int pasteIndex;

    private final JFileChooser fc = new JFileChooser(new File("."));

    /**
     * Create emulator application.
     */
    public GUI(boolean singleUser) throws Exception {
        guiFrame = new JFrame("OS-9 emulator");
        guiFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JMenuBar guiMenuBar = new JMenuBar();
        guiFrame.setJMenuBar(guiMenuBar);

        addFileMenu(guiMenuBar);
        addEditMenu(guiMenuBar);
        addDevicesMenu(guiMenuBar);
        addHelpMenu(guiMenuBar);

        bus = new BusStraight();

        RandomAccessMemory ram = new RandomAccessMemory(0x0000, 0x10000);
        bus.addMemorySegment(ram);

//      ReadOnlyMemory rom = new ReadOnlyMemory(0xC000, 0x4000);
//      bus.insertMemorySegment(rom);

        IRQBeat irqBeat = new IRQBeat(0xFFD0, bus, 20);
        bus.insertMemorySegment(irqBeat);

        term = new Acia6850(0xFFD4, bus);
        bus.insertMemorySegment(term);
        screen1 = new JTerminal(term, 80, 24);
        AciaToScreen atc1 = new AciaToScreen(term, screen1);
        atc1.execute();

        t1 = new Acia6850(0xFFD6, bus);
        bus.insertMemorySegment(t1);

        t1Dialog = new Terminal2(guiFrame, t1);

        printerDialog = new PrinterDialog(guiFrame);

        t2 = new Acia6850(0xFFD8, bus);
        bus.insertMemorySegment(t2);
        AciaToScreen atc3 = new AciaToScreen(t2, printerDialog);
        atc3.execute();

        hwClock = new HWClock(0xFFDA, bus);
        bus.insertMemorySegment(hwClock);

        diskDevice = new VirtualDisk(0xFFD1, bus);
        bus.insertMemorySegment(diskDevice);

        d0Dialog = new DiskDialog(guiFrame, diskDevice, 0);
        d1Dialog = new DiskDialog(guiFrame, diskDevice, 1);

        if (singleUser) {
            loadROM(0xF000, "OS9p1", "OS9p2_ed9", "SysGoSingle",
                    "BootDyn", "HWClock", "VDisk_rv2");
        } else {
            loadROM(0xF000, "OS9p1", "OS9p2_ed9", "SysGoMulti",
                    "BootDyn", "HWClock", "VDisk_rv2");
        }
        loadROM(0x3800, "D0", "D1", "IOMan_ed4", "SCF_ed8", "Acia_ed2", "RBF_ed8",
                     "Term", "T1", "P", "PipeMan", "Piper", "Pipe");
        if (singleUser) loadROM("Shell"); // Don't rely on the harddisk

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
                screen1.resetState();
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
        guiMenu.setMnemonic(KeyEvent.VK_H);

        JMenuItem menuItem = new JMenuItem("OS-9 User Guide");
        menuItem.addActionListener(new CSH.DisplayHelpFromSource(hb));
        guiMenu.add(menuItem);

        menuItem = new JMenuItem("About");
        menuItem.addActionListener(new AboutAction());
        guiMenu.add(menuItem);

        guiMenuBar.add(guiMenu);
    }

    private void addDevicesMenu(JMenuBar guiMenuBar) {
        JMenu guiMenu = new JMenu("Devices");
        guiMenu.setMnemonic(KeyEvent.VK_D);

        JMenuItem menuItem = new JMenuItem("Terminal 2");
        menuItem.addActionListener(new T1Action());
        guiMenu.add(menuItem);

        menuItem = new JMenuItem("Printer");
        menuItem.addActionListener(new PrinterAction());
        guiMenu.add(menuItem);

        menuItem = new JMenuItem("Drive /D0");
        menuItem.setMnemonic(KeyEvent.VK_0);
        menuItem.addActionListener(new D0Action());
        guiMenu.add(menuItem);

        menuItem = new JMenuItem("Drive /D1");
        guiMenu.setMnemonic(KeyEvent.VK_1);
        menuItem.addActionListener(new D1Action());
        guiMenu.add(menuItem);

        guiMenuBar.add(guiMenu);
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
            }
            if ((beats % PASTE_INTERVAL) == PASTE_RELEASE && pasting) {
                int code = pasteBuffer.charAt(pasteIndex);
                pasting = false;
                pasteIndex++;
                if (pasteIndex >= pasteBuffer.length()) {
                    pasteBuffer = null;
                    pasteIndex = 0;
                }
            }

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
                pasteBuffer = (String) c.getContents(null)
                                .getTransferData(DataFlavor.stringFlavor);
                LOGGER.debug("To paste:{}", pasteBuffer);
                for (char ch : pasteBuffer.toCharArray()) {
                    if (ch == '\n')
                        term.eolReceived();
                    else
                        term.dataReceived(ch);
                }
            } catch (UnsupportedFlavorException | IOException e1) {
                LOGGER.error("Unsupported flavor", e1);
            }
        }
    }

    private class T1Action implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            t1Dialog.setVisible(true);
            t1Dialog.requestFocusInWindow();
        }
    }

    private class PrinterAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            printerDialog.setVisible(true);
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
