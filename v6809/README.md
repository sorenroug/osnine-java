6809 CPU with configurable devices
==================================

The v6809 is an emulator that can be configured via a properties file.
You can allocate RAM, load data into the memory and set up devices.

Devices:
* Acia6551Console writes to Java's System.out and reads from System.in
* IRQBeat sends an IRQ interrupt every 20 milliseconds to the CPU.
* HWClock makes it possible to get the date and time from the host of the emulator.
* VirtualDisk interfaces a DSK image to the emulator as a floppy or harddisk.

The v6809.properties file shows how it can be used to load the OS9 Level I kernel and modules into RAM and run.

When OS9 and OS9p2 are loaded into $F000, then OS9 only scans upward in
RAM from its own location to find other modules.

OS9 installs a few system calls and then calls OS9p2, which installs
more system calls and attempts a link to IOMan.

The OS9.dsk was created with

   os9 format disk.dsk -c1 -h1 -n"1.2 MB disk" -t80 -s48
   os9 format disk.dsk -c1 -h2 -n"50 MB disk" -t1024 -s96

The files in `src/main/microware` are downloaded from the disk images at
http://archive.worldofdragon.org/archive/index.php and extracted.

Telnet service
--------------

The v6809 can be configured to start to make a serial port available as
a telnet port. This is set up in the telnet.properties file.

In order to match assumptions of Linux users the end-of-file has been changed from ESC to CTRL-D,
and the reprint-line has been changed from CTRL-D to CTRL-R. The Telnet service also launches the TSMon application.

Tiny BASIC
----------

The Tiny BASIC (tbasic) is included to show how the v6809 can be wired for other configurations. TBasic expects an MC6850 ACIA located at $C000. It doesn't use interrupts and wants end-of-line to CR+NL.

Docker image
------------

The docker image build a configuration that makes it possible to have OS9 on a host on the Internet. To build do:
```
docker build -t sorenroug/v6809:latest .
docker push sorenroug/v6809:latest
```
It then expects a volume to be mounted at /var/local where it can find its two disks and the configuration file.

