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
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Load disk dialog.
 */
public class CatalogDialog {

    private static final Logger LOGGER = LoggerFactory.getLogger(CatalogDialog.class);

    private static File workDir = null; //new File("/files");

    private JFrame guiFrame;

    private JDialog catalogDialog;

    private Properties configMap;

    private JFileChooser chooseFile;

    /**
     * Create disk dialog.
     */
    public CatalogDialog(JFrame parent, Properties config) throws Exception {
        File startDir;
        guiFrame = parent;
        this.configMap = config;

        catalogDialog = new JDialog(guiFrame, "Catalog", false);
        catalogDialog.setLayout(new FlowLayout());

        String cDir = config.getProperty("catalog");
        if (cDir != null) startDir = new File(cDir);
        else startDir = new File("/");

        String wDir = config.getProperty("workdir");
        if (wDir != null) workDir = new File(wDir);

        chooseFile = new JFileChooser(startDir);

        JButton button;

        button = new JButton("Choose disk image to fetch");
        button.addActionListener(new CopyAction());
        catalogDialog.add(button);

        button = new JButton("Close");
        button.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                catalogDialog.setVisible(false);
            }
        });
        catalogDialog.add(button);

        catalogDialog.setSize(300,200);
 
        chooseFile.setAcceptAllFileFilterUsed(false);
        FileNameExtensionFilter filter = new FileNameExtensionFilter("DSK images", "dsk");
        chooseFile.addChoosableFileFilter(filter);
    }

    public void setVisible(boolean visible) {
        catalogDialog.setVisible(visible);
    }

    private class CopyAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            try {
                int returnVal = chooseFile.showOpenDialog(guiFrame);
                if (returnVal == JFileChooser.APPROVE_OPTION) {
                    File selectedFile = chooseFile.getSelectedFile();
                    OS9Emu.copyDisk(selectedFile,
                            new File(workDir, selectedFile.getName()));
                }
            } catch (Exception ex) {
                LOGGER.error("Unable to download disk", ex);
            }
        }
    }

}
