6809 CPU with virtualised devices
=================================

The v6809 is a cpu, that has some devices attached that can interact
with the host computer.  The first device is a MC6850 UART that writes
to Java's System.out and reads from System.in.

It can then be used to load OS9 kernel and modules into RAM and run.

When OS9 and OS9p2 are loaded into $F000, then OS9 only scans upward in
RAM from its own location to find other modules.

OS9 installs a few system calls and then calls OS9p2, which installs
more system calls and attempts a link to IOMan.

TODO:
Implement IRQ 50 times a second


The OS9.dsk was created with

   os9 format disk.dsk -c1 -h1 -n"1.2 MB disk" -t80 -s48

