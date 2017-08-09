package org.roug.osnine;

import java.io.IOException;

/**
 * PIO0 is wired to keyboard, joystick and printer output.
 *
 * It is mapped to FF00 - FF03 in memory.
 * $ff00           PIA 0 A side Data reg.
 *           PA7    i/p    Comparator input
 *           PA6    i/p    Keyboard Matrix   Ent Clr Brk N/c N/c N/c N/c Shift
 *           PA5    i/p    Keyboard Matrix   X   Y   Z   Up  Dwn Lft Rgt Space
 *           PA4    i/p    Keyboard Matrix   P   Q   R   S   T   U   V   W
 *           PA3    i/p    Keyboard Matrix   H   I   J   K   L   M   N   O
 *           PA2    i/p    Keyboard Matrix   @   A   B   C   D   E   F   G
 *           PA1    i/p    Keyboard Matrix   8   9   :   ;   ,   -   .   /
 *                  i/p    Left Joystick Button
 *           PA0    i/p    Keyboard Matrix   0   1   2   3   4   5   6   7
 *                  i/p    Right Joystick Button
 * $ff01           PIA 0 A side Control reg.
 *           CA1    i/p    Horiz Sync Interrupt from VDG (15625Hz; CoCo 15750Hz)
 *           CA2    o/p    Analogue Mux channel select line A
 *                         Selects Joystick Axis (0 x-axis, 1 y-axis)
 * $ff02           PIA 0 B side Data reg.
 *           PB7    o/p    Keyboard Matrix   7   /   G   O   W   Space  Shift
 *                  o/p    Printer Out bit 7
 *           PB6    o/p    Keyboard Matrix   6   .   F   N   V   Right  N/c
 *                  o/p    Printer Out bit 6
 *           PB5    o/p    Keyboard Matrix   5   -   E   M   U   Left   N/c
 *                  o/p    Printer Out bit 5
 *           PB4    o/p    Keyboard Matrix   4   ,   D   L   T   Down   N/c
 *                  o/p    Printer Out bit 4
 *           PB3    o/p    Keyboard Matrix   3   ;   C   K   S   Up     N/c
 *                  o/p    Printer Out bit 3
 *           PB2    o/p    Keyboard Matrix   2   :   B   J   R   Z      Break
 *                  o/p    Printer Out bit 2
 *           PB1    o/p    Keyboard Matrix   1   9   A   I   Q   Y      Clear
 *                  o/p    Printer Out bit 1
 *           PB0    o/p    Keyboard Matrix   0   8   @   H   P   X      Enter
 *                  o/p    Printer Out bit 0
 * $ff03           PIA 0 B side Control reg.
 *           CB1    i/p    Field Sync Interrupt from VDG (50Hz; CoCo 60Hz)
 *           CB2    o/p    Analogue Mux channel select line B
 *                         Selects Joystick (0 right, 1 left)
 */
public class PIO0 extends MemorySegment {

    public PIO0(int start) {
        super(start, start);
    }

    @Override
    public int load(int addr) {
        try {
            return System.in.read();
        } catch (IOException e) {
            System.exit(1);
            return -1;
        }
    }

    @Override
    public void store(int addr, int val) {
        System.out.write(val);
    }

}
