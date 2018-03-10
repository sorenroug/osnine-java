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
