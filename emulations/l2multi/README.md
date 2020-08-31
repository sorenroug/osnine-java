Multi-user OS-9 Level 2 emulation
=================================

This emulator is a Java Swing GUI application, that supports two serial terminals at 80x24, one serial printer and a 5 MB harddisk.

To use it you must download the disk image, and rename it to boot-os9l2.dsk. It is a raw image of a small harddisk.

java -jar l2multi-1.0.0-jar-with-dependencies.jar

It is possible to start it up in single user mode by giving a '-s' argument.

Usage
-----

The two terminals are called '/Term' and '/T1'. The printer device is
called '/P' and the harddisk is '/D0'. The OS-9 User Guide is available
from the help menu.

Internals
---------

The system uses the kernel from Dragon 128 and the GIMIX enhanced DAT. The
terminals and printer are implemented as emulated 6850 ACIAs. The harddisk
is implemented as a pseudo device where the issues of spin up, rotational
delay, noise etc. are removed. Additionally, there is a clock device,
which gets the time from the host. The CPU is interrupted 50 times a
second to facilitate multitasking.

Memory Map
----------

$FE000-$FE001 ACIA serial port address (/P1)
$FE004-$FE005 ACIA serial port address (/Term)
$FE020-$FE021 ACIA serial port address (/T1)
$FE220-$FE239 MM58167 real time clock
$FECD1-$FECD3 Virtual disk
$FF7F         Task register
$FFF0-$FFFF DAT registers
