Emulator for a OS-9 Level I workstation
=======================================

OS-9 Level I is an operating system that provides a feeling of running UNIX,
but on an 8-bit processor and maximum 64 KB RAM. It was normally used for
single-user workstations with floppy disks, whereas Level II was for multi-user
systems.

Usage
-----

This emulator is a Java Swing GUI application, that supports two serial
terminals at 80x24, one serial printer and a 5 MB harddisk.

To use it you must download the disk image, and rename it to OS9.dsk. It
is a raw image of a small harddisk. It is also possible to use a OS-9
boot diskette as long as it contains the Shell command.

java -jar l1ws-2.1.0-jar-with-dependencies.jar

The two terminals are called '/Term' and '/T1'. The printer device is
called '/P' and the harddisk is '/D0'. The OS-9 User Guide is available
from the help menu.

Internals
---------

The system uses the kernel from CoCo/Dragon 64. The terminals and printer
are implemented as emulated 6850 ACIAs. The harddisk is implemented as
a pseudo device where the issues of spin up, rotational delay, noise
etc. are removed. Additionally, there is a clock device, which gets
the time from the host.
