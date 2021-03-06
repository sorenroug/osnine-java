# OS-9 with Dragon 64 kernel

This is a configuration for the v6809 emulator.

The v6809.properties file shows how it can be used to load the OS9 Level I
kernel and modules into RAM and run. Java has the problem that the System
in and out is always in line-mode. It means that Java echoes you keyboard
entries back you and presents an entire line to the emulator. Ctrl-C also
has the effect to stop the emulation rather than send the key stroke to
the emulator. This is the reason there is a telnet service option.

When OS9 and OS9p2 are loaded into $F000, then OS9 only scans upward in
RAM from its own location to find other modules.

OS9 installs a few system calls and then calls OS9p2, which installs more system calls and attempts a link to IOMan.

How to run
----------

After you have done the `mvn install`, you can modify the
`v6809.properties` in target to use two disks of your own. The one called
OS9.dsk is /d0 and must contain the `CMDS` directory and the Shell or
Login commands.

    ./v6809

This can be put into a script. To try some of the other properties files, you give it as an argument, like:

    ./v6809 -c tn6850.properties

Graphical User Interface
------------------------

The Acia can be configured to show a graphical UI written Java Swing. See `gui6551.properties`.

Telnet service
--------------

The v6809 can be configured to start to make a serial port available as
a telnet port. This is set up in the telnet.properties file. To execute
do ./vtelnet and then in another terminal:

    telnet localhost 2323

In order to match assumptions of Linux users the end-of-file has been
changed from ESC to CTRL-D, and the reprint-line has been changed from
CTRL-D to CTRL-R. The Telnet service also launches the Login command
because now it is a multi-user system.
