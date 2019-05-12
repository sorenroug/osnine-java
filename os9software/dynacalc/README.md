# DYNACALC, Version 4.7:3
## by Scott Schaeferle

This directory contains Dynacalc v. 4.7:3 as sold for the Dragon 64. This
edition has been modified to fit the 51-column screen that was the max number
of columns the Dragon 64 could display. The control sequences for the screen
are defined in the Dynacalc.trm file and in principle it is possible to define
another terminal, but the 'install.dc' program to do so has had this
functionality removed.

There is evidence that is used to be possible to use a VT100 terminal. It is
called an 'ANSI' terminal in the code. The VT100 terminal is the most common
type to be emulated in today's tools. However, the cursor keys of a VT100
terminal send three-character sequences, and the Dynacalc.trm has only space
for one byte.

