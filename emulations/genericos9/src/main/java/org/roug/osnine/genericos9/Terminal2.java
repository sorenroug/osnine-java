package org.roug.osnine.genericos9;

import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.FlowLayout;
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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Terminal for generic emulator
 */
public class Terminal2 extends JDialog {

    private static final Logger LOGGER = LoggerFactory.getLogger(Terminal2.class);

    private Acia t2;

    private Screen screen;

    /**
     * Create Terminal
     */
    public Terminal2(JFrame parent, Acia t2) throws Exception {
        super(parent, "Terminal 2", false);
        this.t2 = t2;
        setLayout(new BorderLayout());

        JPanel buttonPane = new JPanel();
        buttonPane.setLayout(new FlowLayout());

        add(buttonPane, BorderLayout.PAGE_START);

        JButton button = new JButton("Close");
        button.addActionListener(new CloseAction());
        buttonPane.add(button);
        screen = new Screen(t2);

        add(screen);

        addWindowFocusListener(new WindowAdapter() {
            @Override
            public void windowGainedFocus(WindowEvent e) {
                screen.requestFocusInWindow();
            }
        });

/*
        addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent e) {
                screen.requestFocusInWindow();
            }
        });
*/               
        AciaToScreen atc = new AciaToScreen(t2, screen);
        atc.execute();
        pack();
    }

    @Override
    public boolean requestFocusInWindow() {
        return screen.requestFocusInWindow();
    }

    private class CloseAction implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            setVisible(false);
        }
    }

}
