package org.roug.osnine.mo5;

import org.roug.osnine.Bus8Motorola;
import org.roug.osnine.BusStraight;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Test;

class ScreenMock extends Screen {

    public ScreenMock(Bus8Motorola bus) {
        super(bus);
    }

    public void setPixelBankActive(boolean state) {}

    public boolean hasKeyPress(int m) { return false; }
}

class PIAMock extends PIA6821MO5 {

    public PIAMock(Bus8Motorola bus, Screen screen) {
        super(bus, screen);
    }

    protected int load(int addr) {
        return super.load(addr);
    }

    protected void store(int addr, int operation) {
        super.store(addr, operation);
    }
    
}

public class PIA6821MO5Test {

    private static final int PIAADDR = 0xA7C0;

    private static final int DDRA = PIAADDR + 0;
    private static final int ORA = PIAADDR + 0;

    private static final int DDRB = PIAADDR + 1;
    private static final int ORB = PIAADDR + 1;

    private static final int CRA = PIAADDR + 2;
    private static final int CRB = PIAADDR + 3;

    /**
     * Set PA5 register to output and then try to write to it.
     */
    @Test
    public void inputToPA5() {
        Bus8Motorola bus = new BusStraight();
        ScreenMock screen = new ScreenMock(bus);
        PIAMock pia = new PIAMock(bus, screen);
        pia.store(CRA, 0);     // Select DDRA
        pia.store(DDRA, 0xF0); // Make top 4 bits output, the others input
        pia.store(CRA, 0x04);  // Select output register
        pia.store(ORA, 0xD0);
        pia.setInputLine(PIA6821MO5.A, 5, false); // This should be ignored
        assertEquals(0xD0, pia.load(ORA));

        pia.setInputLine(PIA6821MO5.A, 2, true);
        assertEquals(0xD4, pia.load(ORA));
    }
}
