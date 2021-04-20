package org.roug.osnine.l2virt;

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

import org.roug.ui.terminal.AvailableEmulations;
import org.roug.ui.terminal.JTerminal;
import org.roug.ui.terminal.EmulationCore;
import org.roug.usim.Acia;
import org.roug.usim.Acia6850;
import org.roug.usim.Bus8Motorola;
import org.roug.usim.BusGimixEnhanced;
import org.roug.usim.MM58167;
import org.roug.usim.mc6809.MC6809;
import org.roug.usim.RandomAccessMemory;
import org.roug.usim.ReadOnlyMemory;
import org.roug.usim.VirtualDisk;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * GUI for GIMIX-based OS-9 Level 2 emulator.
 */
public class GUI {

    private static final Logger LOGGER = LoggerFactory.getLogger(GUI.class);

    private JFrame guiFrame;

    private PrinterDialog printerDialog;
    private JDialog t1Dialog;
    private DiskDialog d0Dialog, d1Dialog;

    private Bus8Motorola bus;
    private MC6809 cpu;

    /** Serial devices. T2 will be used for printer. */
    private Acia6850 term,t1,t2;

    private VirtualDisk diskDevice;

    /** The display of the emulator. */
    private JTerminal screen1;

    private int loadStart = 0;

    //private final JFileChooser fc = new JFileChooser(new File("."));

    private Properties configMap = new Properties();
    /**
     * Create emulator application.
     */
    public GUI(Properties config) throws Exception {
        configMap = config;
        String bootMode = configMap.getProperty("bootmode", "multiuser");
        String terminalType = configMap.getProperty("term.type");
        String fontSizeStr = configMap.getProperty("term.fontsize");
        int fontSize;
        try {
            fontSize = Integer.parseInt(fontSizeStr);
        } catch (NumberFormatException e) {
            fontSize = 16;
        }

        boolean singleUser = false;
        if ("singleuser".equals(configMap.getProperty("bootmode", "multiuser"))) {
            singleUser = true;
        }
        guiFrame = new JFrame("OS-9 Level 2 emulator");
        guiFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JMenuBar guiMenuBar = new JMenuBar();
        guiFrame.setJMenuBar(guiMenuBar);

        addFileMenu(guiMenuBar);
        addEditMenu(guiMenuBar);
        addDevicesMenu(guiMenuBar);
        addHelpMenu(guiMenuBar);

        bus = new BusGimixEnhanced();

        RandomAccessMemory ram = new RandomAccessMemory(0x0000, 0xB0000);
        bus.addMemorySegment(ram);

        ReadOnlyMemory rom = new ReadOnlyMemory(0xFF000, 0x1000);
        bus.insertMemorySegment(rom);

        loadROMToEnd(0x100000, "OS9p1");
        loadROM(0xFF000, "Boot");

        MM58167 irqBeat = new MM58167(0xFE220, bus);
        bus.insertMemorySegment(irqBeat);

        term = new Acia6850(0xFE004, bus);
        bus.insertMemorySegment(term);
        EmulationCore emulation = AvailableEmulations.createEmulation(terminalType);
        screen1 = new JTerminal(term, emulation);
        screen1.setFontSize(fontSize);
        AciaToScreen atc1 = new AciaToScreen(term, screen1);
        atc1.execute();

        t1 = new Acia6850(0xFE020, bus);
        bus.insertMemorySegment(t1);

        t1Dialog = new Terminal2(guiFrame, t1, terminalType);

        printerDialog = new PrinterDialog(guiFrame);

        t2 = new Acia6850(0xFE000, bus);
        bus.insertMemorySegment(t2);
        AciaToScreen atc3 = new AciaToScreen(t2, printerDialog);
        atc3.execute();

        diskDevice = new VirtualDisk(0xFECD1, bus);
        bus.insertMemorySegment(diskDevice);

        d0Dialog = new DiskDialog(guiFrame, diskDevice, 0);
        d1Dialog = new DiskDialog(guiFrame, diskDevice, 1);

        cpu = new MC6809(bus);

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
     * Open a file to load into RAM or ROM.
     *
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

    /**
     * Load files containing data for memory aligned to end.
     *
     * @param endAddress Address to align end of files to
     * @param filesToLoad Files to load
     * @throws IOException if there is no file
     * @throws FileNotFoundException if there is no file
     */
    private void loadROMToEnd(int endAddress, String... filesToLoad)
                            throws IOException, FileNotFoundException {
        int sumSize = 0;

        for (String fileToLoad : filesToLoad) {
            InputStream moduleStream = openFile(fileToLoad);
            int s = 0;
            int b = moduleStream.read();
            while (b != -1) {
                s++;
                b = moduleStream.read();
            }
            moduleStream.close();
            if (s == 0)
                throw new RuntimeException("Zero file size: " + fileToLoad);
            sumSize += s;
        }
        if (sumSize > endAddress) {
            throw new RuntimeException("Collective size of files to load is too big");
        }
        loadROM(endAddress - sumSize, filesToLoad);
    }

    private void loadROM(String... filesToLoad)
                            throws IOException, FileNotFoundException {
        loadROM(loadStart, filesToLoad);
    }

    /**
     * Load a file containing data for memory.
     *
     * @param loadAddress Address to load at
     * @param filesToLoad Files to load
     * @throws IOException if there is no file
     * @throws FileNotFoundException if there is no file
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

        JMenuItem menuItem;

        menuItem = new JMenuItem("Paste clipboard");
        menuItem.addActionListener(new PasteAction(null));
        guiMenu.add(menuItem);

        menuItem = new JMenuItem("Paste disk change");
        menuItem.addActionListener(new PasteAction("chd /d0 chx /d0/cmds\n"));
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

        JMenuItem menuItem = new JMenuItem("Terminal /T1");
        menuItem.addActionListener(new T1Action());
        guiMenu.add(menuItem);

        menuItem = new JMenuItem("Printer /P1");
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

    private static class QuitAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            System.exit(0);
        }
    }

    private class PasteAction implements ActionListener {

        private String cannedText = null;

        public PasteAction(String str) {
            super();
            cannedText = str;
        }

        @Override
        public void actionPerformed(ActionEvent e) {
            Clipboard c = Toolkit.getDefaultToolkit().getSystemClipboard();
            String pasteBuffer;
            try {
                if (cannedText == null) {
                    pasteBuffer = (String) c.getContents(null)
                                    .getTransferData(DataFlavor.stringFlavor);
                } else {
                    pasteBuffer = cannedText;
                }
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
