package org.roug.osnine.wasm;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.FlowLayout;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;

import org.roug.usim.VirtualDisk;

import java.io.File;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Load disk dialog.
 */
public class DiskDialog {

    private static final Logger LOGGER = LoggerFactory.getLogger(DiskDialog.class);

    private static File startDir = new File("/files");

    private JFrame guiFrame;

    private JDialog diskDialog;

    private JLabel diskStatus;

    private VirtualDisk diskDevice;

    private int driveNumber;

    private final JFileChooser fc = new JFileChooser(startDir);

    /**
     * Create disk dialog.
     */
    public DiskDialog(JFrame parent, VirtualDisk diskDevice, int driveNum) throws Exception {
        guiFrame = parent;
        this.driveNumber = driveNum;
        this.diskDevice = diskDevice;

        diskDialog = new JDialog(guiFrame, String.format("Disk drive /D%d", driveNum), false);
        diskDialog.setLayout(new FlowLayout());

        diskStatus = new JLabel("No disk loaded");
        diskDialog.add(diskStatus);

        JButton button;

        button = new JButton("Choose disk image");
        button.addActionListener(new LoadAction());
        diskDialog.add(button);

        button = new JButton("Unload disk");
        button.addActionListener(new UnloadAction());
        diskDialog.add(button);

        button = new JButton("Close");
        button.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                diskDialog.setVisible(false);
            }
        });
        diskDialog.add(button);

        diskDialog.setSize(300,300);
 
        fc.setAcceptAllFileFilterUsed(false);
        FileNameExtensionFilter filter = new FileNameExtensionFilter("DSK images", "dsk");
        fc.addChoosableFileFilter(filter);
    }

    public void setVisible(boolean visible) {
        setDiskStatus();
        diskDialog.setVisible(visible);
    }

    private void setDiskStatus() {
        File f = diskDevice.getDisk(driveNumber);
        if (f == null) {
            diskStatus.setText("No disk loaded");
        } else {
            diskStatus.setText("Loaded: " + f.getName());
        }
    }

    private class LoadAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            try {
                int returnVal = fc.showOpenDialog(guiFrame);
                if (returnVal == JFileChooser.APPROVE_OPTION) {
                    File selectedFile = fc.getSelectedFile();
                    diskDevice.setDisk(driveNumber, selectedFile);
                    setDiskStatus();
                }
            } catch (Exception ex) {
                LOGGER.error("Unable to load disk", ex);
            }
        }
    }

    private class UnloadAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            try {
                diskDevice.removeDisk(driveNumber);
                setDiskStatus();
            } catch (Exception ex) {
                LOGGER.error("Unable to unload disk", ex);
            }
        }
    }

}
