package org.roug.osnine.mo5;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
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
public class MO5Emu implements TapeListener {

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

    private CassetteRecorder tapeRecorder;

    private final JFileChooser fc = new JFileChooser(new File("."));

    public static void main(String[] args) throws Exception {
        new MO5Emu();
    }

    public MO5Emu() throws Exception {
        guiFrame = new JFrame("MO5 emulator");
        guiFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JMenuBar guiMenuBar = new JMenuBar();
        guiFrame.setJMenuBar(guiMenuBar);
        addFileMenu(guiMenuBar);
        addTapeMenu(guiMenuBar);

        bus = new BusStraight();

        // Create screen and attach it to the bus.
        screen = new Screen(bus);
        tapeRecorder = new CassetteRecorder(bus, this);

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

        LOGGER.info("Starting CPU");
        Thread cpuThread = new Thread(cpu, "cpu");
        cpuThread.start();

        LOGGER.debug("Starting heartbeat every 20 milliseconds");
        TimerTask clocktask = new TimerTask() {
            public void run() {
                pia.signalC1(PIA6821.B); // Send signal to PIA CB1
            }
        };

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

        guiMenuBar.add(guiMenuTape);
    }

    private static class QuitAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            System.exit(0);
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

    public void tapestationSignal(boolean newstate) {
        pia.setInputLine(PIA6821.A, 7, newstate);
    }
}
