package org.roug.osnine.v6809;

import org.roug.osnine.MC6809;
import org.roug.osnine.Console;
import org.roug.osnine.Loader;
import java.io.FileInputStream;

public class V6809 {

    public static void main(String[] args) throws Exception {
        MC6809 cpu = new MC6809(0x8000);

        Console console = new Console(0xb000);
        cpu.addMemorySegment(console);
        FileInputStream sRecordStream = new FileInputStream(args[0]);
        Loader.load_srecord(sRecordStream, cpu);
        System.out.format("Starting at: %x\n", cpu.pc.intValue());
        try {
            cpu.run();
        } catch (Exception e) {
            System.err.println(e.toString());
        }
        System.out.flush();
    }
}
