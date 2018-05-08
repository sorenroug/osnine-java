# Retrocomputing: A Java-based 6809 emulator

The purpose of this project is to create an 6809 emulator that can
be configured at runtime with a range of memory mapped devices.

Devices:
* Acia6551Console emulates a Roswell 6551 UART. It writes to Java's System.out and reads from System.in.
* Acia6551Telnet is another UART emulator. It opens a socket on port 2323, which the user can `telnet` to.
* Acia6850Console emulates a Motorola 6850 UART.
* IRQBeat sends an IRQ interrupt every 20 milliseconds to the CPU.
* HWClock makes it possible to get the date and time from the host of the emulator.
* VirtualDisk interfaces a DSK image to the emulator as a floppy or harddisk.

Because of their modularity, the Microware OS-9 or NitroOS9 operating
systems can easily be configured to take advantage of these devices.
Each device has a corresponding OS-9 device driver.

The MC6809 was an 8-bit CPU with some 16-bit features from Motorola
introduced in the late 70-ies.  OS-9 was sold as a business operating
system that enabled word processing, spreadsheets and various programming
languages.  By today's standards it is obsolete. It only handles 7
bit ASCII and it is not year 2000 aware.

## Build instructions

This project uses Maven. You can get the software from https://maven.apache.org/.
To build the software type:
```
mvn install
```
To create the PDF editions of the manuals type:
```
mvn pre-site
```
Visit the sub-directories to learn how to use the tools.
