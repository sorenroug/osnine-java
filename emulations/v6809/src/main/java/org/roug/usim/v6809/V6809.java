package org.roug.usim.v6809;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.Properties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.roug.usim.Bus8Motorola;
import org.roug.usim.BusStraight;
import org.roug.usim.JarFileLoader;
import org.roug.usim.Loader;
import org.roug.usim.MemoryBus;
import org.roug.usim.MemorySegment;
import org.roug.usim.OptionParser;
import org.roug.usim.mc6809.MC6809;


/**
 * Emulator for 6809 CPU that is configured from properties file.
 */
public class V6809 {

    private static final Logger LOGGER = LoggerFactory.getLogger(V6809.class);

    private static MC6809 cpu;

    private static Bus8Motorola bus;

    private enum KnownVectors {
            reset(MC6809.RESET_ADDR),
            nmi(MC6809.NMI_ADDR),
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

    private static int getIntProperty(Properties props, String key)
                    throws Exception {
        return Integer.decode(props.getProperty(key)).intValue();
    }

    private static int getVectorAddress(String key) {
        for (KnownVectors v : KnownVectors.values()) {
            if (key.equalsIgnoreCase(v.toString())) {
                return v.value;
            }
        }
        return Integer.decode(key);
    }

    /**
     * Open a file to load into RAM.
     * Used to look in the JAR file if the file name doesn't contain a slash.
     * @param fileToLoad Name of file to load
     * @return Opened file
     * @throws FileNotFoundException if there is no file
     */
    private static InputStream openFile(String fileToLoad)
                            throws FileNotFoundException {
        InputStream moduleStream = null;

        if (fileToLoad.contains("/")) {
            moduleStream = new FileInputStream(fileToLoad);
        } else {
//          moduleStream = V6809.class.getResourceAsStream("/" + fileToLoad);
            moduleStream = new FileInputStream(fileToLoad);
        }
        if (moduleStream == null) {
            throw new FileNotFoundException("File not found: " + fileToLoad);
        }
        return moduleStream;
    }

    /**
     * Load modules.
     * If the string starts with @ then it sets the address.
     * If the string starts with $ then it is a long string of hex values.
     * If the string starts with (srec) or (intel) then it expects the file
     * to be Motorola S-record or Intel Hex format.
     */
    private static int loadModules(String[] files) throws Exception {
        int loadAddress = 0;

        for (String fileToLoad : files) {
            if (fileToLoad.startsWith("@")) {
                loadAddress = getVectorAddress(fileToLoad.substring(1));
                continue;
            }
            if (fileToLoad.startsWith("$")) {
                loadAddress = loadHexString(loadAddress, fileToLoad.substring(1));
                continue;
            }
            if (fileToLoad.toLowerCase().startsWith("(srec)")) {
                InputStream moduleStream = openFile(fileToLoad.substring(6));
                loadAddress = Loader.loadSRecord(moduleStream, bus);
                moduleStream.close();
                continue;
            }
            if (fileToLoad.toLowerCase().startsWith("(intel)")) {
                InputStream moduleStream = openFile(fileToLoad.substring(7));
                loadAddress = Loader.loadIntelHex(moduleStream, bus);
                moduleStream.close();
                continue;
            }
            //TODO Put the following into a method
            LOGGER.debug("Loading {} at {}", fileToLoad, Integer.toHexString(loadAddress));

            InputStream moduleStream = openFile(fileToLoad);
            int b = moduleStream.read();
            while (b != -1) {
                bus.forceWrite(loadAddress, b);
                loadAddress++;
                b = moduleStream.read();
            }
            moduleStream.close();
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

        String extraJars = props.getProperty("classpath");
        JarFileLoader.addPaths(extraJars);

        bus = new BusStraight();

        loadDevices(props);

        cpu = new MC6809(bus);

        String segmentList = props.getProperty("load");
        String[] segments = segmentList.split("\\s+");
        int endAddress = loadModules(segments);

        int start = cpu.read_word(MC6809.RESET_ADDR);
        LOGGER.debug("Reset address: {}", cpu.read_word(MC6809.RESET_ADDR));
        cpu.reset();
        if (props.containsKey("start")) {
            start = getIntProperty(props, "start");
        }
        cpu.pc.set(start);
        LOGGER.debug("Starting at: {}", cpu.pc.intValue());
        cpu.run();
        System.out.flush();
    }


    /**
     * Look for a property called 'devices' and install each one.
     * @param props The properties hashmap
     */
    private static void loadDevices(Properties props) throws Exception {
        String deviceList = props.getProperty("devices");
        String[] devices = deviceList.split("\\s+");

        for (String device : devices) {
            loadOneDevice(props, device);
        }
    }

    /**
     * Installs a device. Looks for the Java class to load and the address
     * in RAM to install it at.
     * Also looks for additional arguments to provide to the constructor method
     * of the device. Finally looks for additional attributes that can be set
     * on the object.
     * @param props The properties hashmap
     * @param device The name of the device
     */
    private static void loadOneDevice(Properties props, String device)
                                throws Exception {
        String deviceClsStr = props.getProperty(device + ".class");
        int addr = getIntProperty(props, device + ".addr");
        String deviceArgString = props.getProperty(device + ".args");
        String[] argsList = new String[0];
        if (deviceArgString != null) {
            argsList = deviceArgString.split("\\s+");
        }
        LOGGER.debug("Loading {} class {}", device, deviceClsStr);
        Class newClass = Class.forName(deviceClsStr);
        Constructor<MemorySegment> constructor;
        try {
            constructor = newClass.getConstructor(
                            Integer.TYPE, Bus8Motorola.class, String[].class);
        } catch (Exception e) {
            constructor = newClass.getConstructor(
                            Integer.TYPE, MemoryBus.class, String[].class);
        }
        MemorySegment deviceInstance = constructor.newInstance(addr, bus, argsList);
        bus.insertMemorySegment(deviceInstance);
        // Find additional setters.
        String prefix = device + ".";
        for (String key : props.stringPropertyNames()) {
            if (key.startsWith(prefix)) {
                if (key.equals(prefix + "class") || key.equals(prefix + "addr")
                        || key.equals(prefix + "args")) {
                    continue;
                }
                String argument = props.getProperty(key);
                String methodName = generateMethodName(key.substring(prefix.length()));
                Method method = newClass.getMethod(methodName, String.class);
                method.invoke(deviceInstance, argument);
            }
        }
    }

    /**
     * Generates the name of a setter.
     */
    private static String generateMethodName(String original) {
        if (original == null || original.length() == 0) {
            return original;
        }
        return "set" + original.substring(0, 1).toUpperCase() + original.substring(1);
    }

    /**
     * Load a hexstring into memory.
     *
     * @return the new location of the load pointer.
     */
    private static int loadHexString(int loadAddress, String input) {
	int len = input.length();

	if (len == 0) {
	    return loadAddress;
	}

	int startOffset;
	if (len % 2 != 0) {
            bus.forceWrite(loadAddress, Character.digit(input.charAt(0), 16));
	    startOffset = 1;
	} else {
	    startOffset = 0;
	}

	for (int i = startOffset; i < len; i += 2) {
	    bus.forceWrite(loadAddress + (i + 1) / 2,
                    (Character.digit(input.charAt(i), 16) << 4)
		    + Character.digit(input.charAt(i + 1), 16));
	}
        int loadSize = startOffset + (len / 2);
        LOGGER.debug("Loading {} bytes at {}", loadSize, Integer.toHexString(loadAddress));
        loadAddress += loadSize;
        return loadAddress;
    }
}
