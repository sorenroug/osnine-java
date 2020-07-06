# V6809 emulator

This is an emulator that is configured with a Java properties file.

## Configurations

The tinybasic, exbasic directories show different ways to wire the emulator.

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

## Docker image

The docker image build a configuration that makes it possible to have OS9 on a host on the Internet. To build do:
```
docker build -t sorenroug/v6809:latest .
docker push sorenroug/v6809:latest
```
It then expects a volume to be mounted at /var/local where it can find its two disks and the configuration file.

Example docker-compose.yml file:
```
kernel:
  image: sorenroug/v6809:latest
  user: nobody
  environment:
    TZ: Europe/Copenhagen
    JAVA_OPTS: |
      -Dorg.slf4j.simpleLogger.log.org.roug.usim.Acia6551=info
      -Dorg.slf4j.simpleLogger.showDateTime=true
      -Dorg.slf4j.simpleLogger.showLogName=false
      -Dorg.slf4j.simpleLogger.showShortLogName=true
  volumes:
  - /exports/V6809:/var/local
  ports:
  - 23:2323
```
