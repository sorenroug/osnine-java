package org.roug.osnine.dragon32;

import java.io.InputStream;
import java.util.Timer;
import java.util.TimerTask;

import org.roug.osnine.MC6809;
import org.roug.osnine.Acia6551Console;
import org.roug.osnine.MemoryBank;
import org.roug.osnine.Loader;

class ClockTick extends TimerTask {

    MC6809 cpu;

    ClockTick(MC6809 cpu) {
        this.cpu = cpu;
    }

    public void run() {
        System.out.println("timer working");      
        //cpu.signalIRQ(); // Execute a hardware interrupt
    }    
}

public class Main {

    /**
     * 
     */
    public static void main(String[] args) throws Exception {
        MC6809 cpu = new MC6809(0x8000);
        MemoryBank basicRom = new MemoryBank(0x8000, 0x4000);
        cpu.addMemorySegment(basicRom);
        InputStream sRecordStream = Main.class.getResourceAsStream("/d32.srec");
        Loader.load_srecord(sRecordStream, cpu);
        System.out.format("Starting at: %x\n", cpu.pc.intValue());

        // Could also load from BFF0..
        cpu.write(0xfff2, 0x01);
        cpu.write(0xfff3, 0x00);
        cpu.write(0xfff4, 0x01);
        cpu.write(0xfff5, 0x03);
        cpu.write(0xfff6, 0x01);
        cpu.write(0xfff7, 0x0f);
        cpu.write(0xfff8, 0x01);
        cpu.write(0xfff9, 0x0c);
        cpu.write(0xfffa, 0x01);
        cpu.write(0xfffb, 0x06);
        cpu.write(0xfffc, 0x01);
        cpu.write(0xfffd, 0x09);
        cpu.write(0xfffe, 0xb3);
        cpu.write(0xffff, 0xb4);

        Acia6551Console uart = new Acia6551Console(0xb000, cpu);
        cpu.addMemorySegment(uart);
        //for (int i = 0; i < 60; i++) {
        //    cpu.write(0x0400 + i, 0x40);
        //}
        startClockTick(cpu);
        try {
            cpu.reset();
            cpu.run();
        } catch (Exception e) {
            System.err.println(e.toString());
        }
        System.out.flush();
    }

    private static void startClockTick(MC6809 cpu) {
        TimerTask tasknew = new ClockTick(cpu);
        Timer timer = new Timer("clock", true);
        timer.schedule(tasknew, 20, 20);
    }

}
