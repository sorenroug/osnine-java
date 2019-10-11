package org.roug.osnine.genericos9;

import java.awt.BorderLayout;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.FlowLayout;
import java.awt.Toolkit;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.IOException;
import java.net.URL;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

import org.roug.osnine.Acia;
import org.roug.osnine.Acia6850;
import org.roug.osnine.Bus8Motorola;
import org.roug.osnine.BusStraight;
import org.roug.osnine.HWClock;
import org.roug.osnine.IRQBeat;
import org.roug.osnine.MC6809;
import org.roug.osnine.RandomAccessMemory;
//import org.roug.osnine.ReadOnlyMemory;
import org.roug.osnine.VirtualDisk;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Terminal for generic emulator
 */
public class Terminal2 extends JDialog {

    private static final Logger LOGGER = LoggerFactory.getLogger(Terminal2.class);

    private Acia6850 t2;

    private Screen screen2;

    /**
     * Create Terminal
     */
    public Terminal2(JFrame parent, Acia6850 t2) throws Exception {
        super(parent, "Terminal 2", false);
        this.t2 = t2;
        setLayout(new BorderLayout());

        JPanel buttonPane = new JPanel();
        buttonPane.setLayout(new FlowLayout());

        add(buttonPane, BorderLayout.PAGE_START);

        JButton button = new JButton("Close");
        button.addActionListener(new CloseAction());
        buttonPane.add(button);
        screen2 = new Screen(t2);
//      screen2.setPreferredSize(new Dimension(700, 500));
//      screen2.setMinimumSize(new Dimension(100, 100));


        add(screen2);

        AciaToScreen atc = new AciaToScreen(t2, screen2);
        atc.execute();
        //setSize(900, 500);
        pack();
    }

    private class CloseAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            setVisible(false);
        }
    }

}
