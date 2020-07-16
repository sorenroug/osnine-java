Multi-user OS-9 Level 2 emulation
=================================

This emulator is a Java Swing GUI application, that supports two serial terminals at 80x24, one serial printer and a 5 MB harddisk.

Instead of launching Shell at start up, it starts Login on terminal /T1 and TSMon on /T2. You can log in on any of the terminals and try what it was like to use OS-9 as a multi-user system.

To use it you must download the disk image, and rename it to OS9.dsk. It is a raw image of a small harddisk. It is also possible to use a OS-9 boot diskette as long as it contains the commands Shell, Login, TSMon and a password file.

java -jar genericos9-1.0.0-jar-with-dependencies.jar

It is possible to start it up in single user mode by giving a '-s' argument.

Usage
-----

The two terminals are called '/Term' and '/T1'. The printer device is called '/P' and the harddisk is '/D0'. The OS-9 User Guide is available from the help menu.

Internals
---------

The system uses the kernel from Dragon 128. The terminals and printer
are implemented as emulated 6850 ACIAs. The harddisk is implemented as
a pseudo device where the issues of spin up, rotational delay, noise
etc. are removed. Additionally, there is a clock device, which gets
the time from the host. The CPU is interrupted 50 times a second to
facilitate multitasking.

Memory Map
----------

$FCB0-$FCB1 ACIA serial port address (/Term)
$FCB2-$FCB3 ACIA serial port address (/T1)
$FCB4-$FCB5 ACIA serial port address (/P)
$FCC0-$FCC3 Task register (Only $FCC0 is used)
$FCD0       Interrupts from clock (50 Hz)
$FCD1-$FCD3 Virtual disk
$FCDA-$FCDF Date and time from host
$FE00-$FE0F DAT registers
