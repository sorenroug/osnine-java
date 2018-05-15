This is a configuration for Microsoft extended basic from 1982.
The ROM can be downloaded from http://searle.hostei.com/grant/6809/ExBasRom.zip
It is configured for a Motorola 6850 UART at location $A000 and 16K ROM at C000-FFFF

In the unmodified ExBasRom.zip  you could enter programs, but 'RUN' didn't work.

The 6850 emulation in this project implements the interrupt mechanism. In
the BASIC code, the Acia's control register is initialised with $95,
which enables recieve IRQ.  At label LAD9E the IRQ is enabled. The
intention is to allow keyboard interrupts.  Unfortunately, the BIRQSV
interrupt routine simply does an RTI instead of reading the ACIA and
the interrupt stays raised. This causes an infinite loop.

This is now fixed and CTRL-C stops a running program.

The assembler file was compiled with AS9 from http://home.hccnet.nl/a.w.m.van.der.horst/m6809.html

For a list of valid commands in BASIC see http://searle.hostei.com/grant/6809/Simple6809.html
