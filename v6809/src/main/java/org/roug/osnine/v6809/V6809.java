package org.roug.osnine.v6809;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;
import java.util.Timer;
import java.util.TimerTask;
import org.roug.osnine.SY6551;
import org.roug.osnine.Loader;
import org.roug.osnine.MC6809;
import org.roug.osnine.OptionParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

class ClockTick extends TimerTask {

    private static final Logger LOGGER = LoggerFactory.getLogger(TimerTask.class);

    private MC6809 cpu;

    ClockTick(MC6809 cpu) {
        this.cpu = cpu;
    }

    public void run() {
        LOGGER.debug("IRQ sent");
        cpu.signalIRQ(); // Execute a hardware interrupt
    }
}

public class V6809 {

    private static final int CLOCKDELAY = 500;  // milliseconds
    private static final int CLOCKPERIOD = 500;  // milliseconds

    private static final Logger LOGGER = LoggerFactory.getLogger(V6809.class);

    private static MC6809 cpu;

    private enum KnownVectors {
            reset(MC6809.RESET_ADDR),
            swi(MC6809.SWI_ADDR),
            swi1(MC6809.SWI_ADDR),
            irq(MC6809.IRQ_ADDR),
            firq(MC6809.FIRQ_ADDR),
            swi2(MC6809.SWI2_ADDR),
            swi3(MC6809.SWI3_ADDR);
            int value;
            KnownVectors(int value) { this.value = value; }
            KnownVectors() {}
    }

    private static int getIntProperty(Properties props, String key) throws Exception {
        return Integer.decode(props.getProperty(key)).intValue();
    }

    private static void setVector(Properties props, String key, int vectorAddress) throws Exception {
        if (props.containsKey(key)) {
            int val = Integer.decode(props.getProperty(key)).intValue();
            cpu.write_word(vectorAddress, val);
            LOGGER.debug("Address: {} set to {}", Integer.toHexString(vectorAddress), Integer.toHexString(val));
        }
    }

    private static int getVectorAddress(String key) {
        for (KnownVectors v : KnownVectors.values()) {
            if (key.equalsIgnoreCase(v.toString())) {
                return v.value;
            }
        }
        return Integer.decode(key);
    }

    private static void loadBytes(Properties props) {
        for (String key : props.stringPropertyNames()) {
            if (key.startsWith("byte.") || key.startsWith("word.")) {
                String addrString = key.substring(5);
                int vectorAddress = getVectorAddress(addrString);
                int val = Integer.decode(props.getProperty(key)).intValue();
                if (key.startsWith("byte.")) {
                    cpu.write(vectorAddress, val);
                } else if (key.startsWith("word.")) {
                    cpu.write_word(vectorAddress, val);
                }
                LOGGER.debug("Address: {} set to {}", Integer.toHexString(vectorAddress), Integer.toHexString(val));
            }
        }
    }

    private static int loadModules(String[] files, int loadAddress) throws Exception {
        byte[] buf = new byte[0x10000];

        for (String fileToLoad : files) {
            LOGGER.debug("Loading {} at {}", fileToLoad, Integer.toHexString(loadAddress));
            FileInputStream moduleStream = new FileInputStream(fileToLoad);
            int len = moduleStream.read(buf);
            for (int i = 0; i < len; i++) {
                cpu.write(loadAddress + i, buf[i]);
            }
            moduleStream.close();
            loadAddress += len;
        }
        LOGGER.debug("End address: {}", Integer.toHexString(loadAddress));
        return loadAddress;
    }

    public static void main(String[] args) throws Exception {
        OptionParser op = new OptionParser(args, "c:");

        String propertiesFile = op.getOptionArgument("c");
        if (propertiesFile == null) {
            propertiesFile = "v6809.properties";
        }

        Properties props = new Properties();

//      InputStream propertiesStream = V6809.class.getResourceAsStream("/v6809.properties");
        InputStream propertiesStream = new FileInputStream(propertiesFile);
        props.load(propertiesStream);
        propertiesStream.close();

        int memory = getIntProperty(props, "memory");
        cpu = new MC6809(memory);

        SY6551 console = new SY6551(0xff04, cpu);
        cpu.insertMemorySegment(console);

        loadBytes(props);
        setVector(props, "reset", MC6809.RESET_ADDR);
        setVector(props, "swi", MC6809.SWI_ADDR);
        setVector(props, "swi1", MC6809.SWI_ADDR);
        setVector(props, "irq", MC6809.IRQ_ADDR);
        setVector(props, "firq", MC6809.FIRQ_ADDR);
        setVector(props, "swi2", MC6809.SWI2_ADDR);
        setVector(props, "swi3", MC6809.SWI3_ADDR);

        String segmentList = props.getProperty("load");
        String[] segments = segmentList.split("\\s+");
        for (String segment : segments) {
            String[] files = props.getProperty(segment).split("\\s+");
            int loadAddress = getIntProperty(props, segment + ".address");
            int endAddress = loadModules(files, loadAddress);
        }

//      Loader.load_srecord(sRecordStream, cpu);
//      System.out.format("Starting at: %x\n", cpu.pc.intValue());
        LOGGER.debug("Reset address: {}", cpu.read_word(MC6809.RESET_ADDR));
        cpu.reset();
        LOGGER.debug("Starting at: {}", cpu.pc.intValue());
        startClockTick(cpu);
        cpu.run();
        System.out.flush();
    }

    private static void startClockTick(MC6809 cpu) {
        TimerTask tasknew = new ClockTick(cpu);
        Timer timer = new Timer("clock", true);
        timer.schedule(tasknew, CLOCKDELAY, CLOCKPERIOD);
    }

}
