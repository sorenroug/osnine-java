# Example emulations

* mo5 - Thomson MO5
* exbasic - Extended BASIC that interfaces with a UART
* os9dragon - Boots OS-9 from the Dragon 64
* tinybasic - Tiny BASIC

## Syntax of the properties file

The `devices` property defines what devices to install on the bus.  RAM is considered a device also. Remember to add RAM for the interrupt vectors at $FFF2 to $FFFF. Each device must then have a configuration:

device.class - The Java class to instantiate.
device.addr - The memory address on the bus where the device will be located. The value be specified in decimal, hex or octal.
device.args - Device-specific arguments that will be split on white space and give to the constructor. In the case of RAM it is the size of the memory. In case of Acias it is the class for the user interface - e.g. org.roug.osnine.AciaConsoleUI.

The `start` property is the location the program counter will be set to before the CPU is started. If there is no start property then the CPU will be started at the address stored in $FFFE.

The `load` property is a list of files or hex strings that will be loaded into memory. It has its own syntax.
- @ sets the address to load into. It can be an integer value or a token: reset, nmi, firq, irq, swi, swi2, swi3. These represent the 7 hardware vectors at $FFF2 and up.
- $ starts a hex string to load into memory.
- (srec) loads a file in Motorola S-Record format. The load and start addresses in the file overrides the values set before the load.
- (intel) loads a file in Intel Hex format. The load and start addresses in the file overrides the values set before the load.
- Any other value will be interpreted to be a binary file to load.

The `classpath` property can be used to load classes that are not in the package. It allows you to create your own devices or user interfaces.

## How to run

After you have done the `mvn install` in the directory above, you modify the `v6809.properties` to use two disks you have. The one called OS9.dsk is /d0 and must contain the `CMDS` directory and the Shell or Login commands.

    java -jar target/osnine-v6809-1.0-SNAPSHOT-jar-with-dependencies.jar

This can be put into a script. To try some of the other properties files, you git it as an argument, like:

    java -jar target/osnine-v6809-1.0-SNAPSHOT-jar-with-dependencies.jar -c tn6850.properties


Telnet service
--------------

The v6809 can be configured to start to make a serial port available as a telnet port. This is set up in the telnet.properties file.

In order to match assumptions of Linux users the end-of-file has been changed from ESC to CTRL-D,
and the reprint-line has been changed from CTRL-D to CTRL-R. The Telnet service also launches the Login command because now it is a multi-user system.

