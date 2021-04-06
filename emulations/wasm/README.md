Emulator for an OS-9 workstation in Webassembly
===============================================

OS-9 Level I is an operating system that provides a feeling of running UNIX,
but on an 8-bit processor and maximum 64 KB RAM. It was normally used for
single-user workstations with floppy disks, whereas Level II was for multi-user
systems.

How to build
------------

1. Run `maven build`
2. Download the latest CheerpJ from https://leaningtech.com/cheerpj/ and compile it
3. Copy target/wasm-1.0.0-jar-with-dependencies.jar to the CheerpJ build directory and call it wasm.jar
4. cheerpj_2.1/cheerpjfy.py wasm.jar


Internals
---------

The system uses the kernel from CoCo/Dragon 64. The terminal is
are implemented as emulated 6850 ACIA. The harddisk is implemented as
a pseudo device where the issues of spin up, rotational delay, noise
etc. are removed. Additionally, there is a clock device, which gets
the time from the host.
