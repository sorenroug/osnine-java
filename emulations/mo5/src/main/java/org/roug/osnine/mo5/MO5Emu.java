package org.roug.osnine.mo5;

import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.Toolkit;
import java.net.URL;
import javax.help.*;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;

import org.roug.osnine.Bus8Motorola;
import org.roug.osnine.BusStraight;
import org.roug.osnine.MC6809;
import org.roug.osnine.PIA6821;
import org.roug.osnine.RandomAccessMemory;
import org.roug.osnine.ReadOnlyMemory;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.FileInputStream;
import java.util.Timer;
import java.util.TimerTask;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * GUI for Thomson MO5 emulator.
 */
public class MO5Emu {

    private static final Logger LOGGER = LoggerFactory.getLogger(MO5Emu.class);

    private static final int CLOCKDELAY = 500;  // milliseconds
    /** On MO5 the interrupt is 50 times a second. */
    private static final int CLOCKPERIOD = 20;  // milliseconds

    private JFrame guiFrame;

    private Bus8Motorola bus;
    private MC6809 cpu;
    private PIA6821MO5 pia;

    /** The display of the MO5. */
    private Screen screen;

    private TapeRecorder tapeRecorder;

    /** Content of clipboard to be sent into the emulator as key events. */
    private String pasteBuffer;
    private int pasteIndex;

    private final JFileChooser fc = new JFileChooser(new File("."));

    public static void main(String[] args) throws Exception {
        new MO5Emu();
    }

    /**
     * Create emulator application.
     */
    public MO5Emu() throws Exception {
        guiFrame = new JFrame("MO5 emulator");
        guiFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JMenuBar guiMenuBar = new JMenuBar();
        guiFrame.setJMenuBar(guiMenuBar);

        addFileMenu(guiMenuBar);
        addEditMenu(guiMenuBar);
        addTapeMenu(guiMenuBar);
        addHelpMenu(guiMenuBar);

        bus = new BusStraight();

        // Create screen and attach it to the bus.
        screen = new Screen(bus);
        tapeRecorder = new TapeRecorder(bus);
        tapeRecorder.setReceiver((boolean state) -> pia.setInputLine(PIA6821.A, 7, state));

        pia = new PIA6821MO5(bus, screen, tapeRecorder);
        bus.addMemorySegment(pia);
        screen.connectPIA(pia);


        RandomAccessMemory ram = new RandomAccessMemory(0x2000, bus, "0x8000");
        bus.addMemorySegment(ram);

        ReadOnlyMemory rom = new ReadOnlyMemory(0xC000, bus, "0x4000");
        bus.addMemorySegment(rom);
        loadROM("basic5.rom", 0xC000);
        loadROM("mo5.rom", 0xF000);

        cpu = new MC6809(bus);

        guiFrame.add(screen);
        guiFrame.pack();

        screen.requestFocusInWindow();
        guiFrame.setVisible(true);
        cpu.reset();

        LOGGER.debug("Starting CPU");
        Thread cpuThread = new Thread(cpu, "cpu");
        cpuThread.start();

        LOGGER.debug("Starting heartbeat every 20 milliseconds");
        TimerTask clocktask = new ClockTask();

        Timer timer = new Timer("clock", true);
        timer.schedule(clocktask, CLOCKDELAY, CLOCKPERIOD);
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

        JMenuItem guiMenuFileZoom1 = new JMenuItem("Zoom 1x");
        guiMenuFileZoom1.addActionListener(new Zoom1Action());
        guiMenuFile.add(guiMenuFileZoom1);

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

    private void addEditMenu(JMenuBar guiMenuBar) {
        JMenu guiMenu = new JMenu("Edit");

        JMenuItem menuItem = new JMenuItem("Paste text");
        menuItem.addActionListener(new PasteAction());
        guiMenu.add(menuItem);

        guiMenuBar.add(guiMenu);
    }

    private void addHelpMenu(JMenuBar guiMenuBar) {
        String helpHS = "javahelp/jhelpset.hs";
        ClassLoader cl = MO5Emu.class.getClassLoader();
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

        guiMenuBar.add(guiMenu);
    }

    private void addTapeMenu(JMenuBar guiMenuBar) {
        JMenu guiMenuTape = new JMenu("Cassette");

        JMenuItem guiMenuTapeRecord = new JMenuItem("Insert tape for record");
        guiMenuTapeRecord.addActionListener(new RecordAction());
        guiMenuTape.add(guiMenuTapeRecord);

        JMenuItem guiMenuTapePlay = new JMenuItem("Insert tape for play");
        guiMenuTapePlay.addActionListener(new PlayAction());
        guiMenuTape.add(guiMenuTapePlay);

        JMenuItem guiMenuTapeRewind = new JMenuItem("Rewind tape");
        guiMenuTapeRewind.addActionListener(new RewindAction());
        guiMenuTape.add(guiMenuTapeRewind);

        JMenuItem guiMenuTapeSeekEnd = new JMenuItem("Seek to end of tape");
        guiMenuTapeSeekEnd.addActionListener(new SeekEndAction());
        guiMenuTape.add(guiMenuTapeSeekEnd);

        JMenuItem guiMenuTapeUnload = new JMenuItem("Unload tape");
        guiMenuTapeUnload.addActionListener(new UnloadAction());
        guiMenuTape.add(guiMenuTapeUnload);

        guiMenuBar.add(guiMenuTape);
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
                int code = Keyboard.getKeyForAscii(pasteBuffer.charAt(pasteIndex));
                pasting = true;
                LOGGER.debug("Paste {}", code);
                if (code >= 0)
                    screen.setKey(code, true);
            }
            if ((beats % PASTE_INTERVAL) == PASTE_RELEASE && pasting) {
                int code = Keyboard.getKeyForAscii(pasteBuffer.charAt(pasteIndex));
                if (code >= 0)
                    screen.setKey(code, false);
                pasting = false;
                pasteIndex++;
                if (pasteIndex >= pasteBuffer.length()) {
                    pasteBuffer = null;
                    pasteIndex = 0;
                }
            }

            pia.signalC1(PIA6821.B); // Send signal to PIA CB1
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

    private class PlayAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            try {
                int returnVal = fc.showOpenDialog(screen);
                if (returnVal == JFileChooser.APPROVE_OPTION) {
                    File file = fc.getSelectedFile();
                    tapeRecorder.loadForPlay(file);
                }
            } catch (Exception ex) {
                LOGGER.error("Unable to load tape", ex);
            }
        }
    }

    private class RecordAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            try {
                int returnVal = fc.showSaveDialog(screen);
                if (returnVal == JFileChooser.APPROVE_OPTION) {
                    File file = fc.getSelectedFile();
                    tapeRecorder.loadForRecord(file);
                }
            } catch (Exception ex) {
                LOGGER.error("Unable to load tape", ex);
            }
        }
    }

    private class RewindAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            tapeRecorder.rewind();
        }
    }

    private class SeekEndAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            tapeRecorder.seekToEnd();
        }
    }

    private class UnloadAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            tapeRecorder.unloadCassetteFile();
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
            screen.setPixelSize(1);
            guiFrame.pack();
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
