package org.roug.osnine.mo5;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.FlowLayout;
import java.awt.Toolkit;
import java.net.URL;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;

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
public class TapeDialog {

    private static final Logger LOGGER = LoggerFactory.getLogger(TapeDialog.class);

    private JFrame guiFrame;

    private JDialog tapeDialog;

    private JLabel tapeStatus;

    /** The display of the MO5. */
    private Screen screen;

    /** Cassete recorder device. */
    private TapeRecorder tapeRecorder;

    private final JFileChooser fc = new JFileChooser(new File("."));

    private File selectedFile;

    /**
     * Create tape dialog
     */
    public TapeDialog(JFrame parent, Screen screen, TapeRecorder tapeRecorder) throws Exception {
        guiFrame = parent;
        this.screen = screen;
        this.tapeRecorder = tapeRecorder;

        tapeDialog = new JDialog(guiFrame, "Cassette device", false);
        tapeDialog.setLayout(new FlowLayout());

        tapeStatus = new JLabel("Loaded: None");
        tapeDialog.add(tapeStatus);

        JButton button = new JButton("Insert tape for record");
        button.addActionListener(new RecordAction());
        tapeDialog.add(button);

        button = new JButton("Insert tape for play");
        button.addActionListener(new PlayAction());
        tapeDialog.add(button);

        button = new JButton("Rewind tape");
        button.addActionListener(new RewindAction());
        tapeDialog.add(button);

        button = new JButton("Record at end of tape");
        button.addActionListener(new RecordToEndAction());
        tapeDialog.add(button);

        button = new JButton("Unload tape");
        button.addActionListener(new UnloadAction());
        tapeDialog.add(button);

        button = new JButton("Close");
        button.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                tapeDialog.setVisible(false);
            }
        });
        tapeDialog.add(button);

        tapeDialog.setSize(300,300);
 
    }

    public void setVisible(boolean visible) {
        tapeDialog.setVisible(visible);
    }


    private class PlayAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            try {
                int returnVal = fc.showOpenDialog(screen);
                if (returnVal == JFileChooser.APPROVE_OPTION) {
                    selectedFile = fc.getSelectedFile();
                    tapeStatus.setText("Loaded: " + selectedFile.getName());
                    tapeRecorder.loadForPlay(selectedFile);
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
                    selectedFile = fc.getSelectedFile();
                    tapeStatus.setText("Loaded: " + selectedFile.getName());
                    tapeRecorder.loadForRecord(selectedFile, false);
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

    private class RecordToEndAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            try {
                int returnVal = fc.showSaveDialog(screen);
                if (returnVal == JFileChooser.APPROVE_OPTION) {
                    selectedFile = fc.getSelectedFile();
                    tapeStatus.setText("Loaded: " + selectedFile.getName());
                    tapeRecorder.loadForRecord(selectedFile, true);
                }
            } catch (Exception ex) {
                LOGGER.error("Unable to load tape", ex);
            }
        }
    }

    private class UnloadAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            tapeRecorder.unloadCassetteFile();
            selectedFile = null;
            tapeStatus.setText("Loaded: None");
        }
    }

}
