# DYNACALC, Version 4.7:3

This directory contains Dynacalc v. 4.7:3 as sold for the Dragon 64. This
edition has been modified to fit the 51-column screen that was the max number
of columns the Dragon 64 could display. The control sequences for the screen
are defined in the Dynacalc.trm file and in principle it is possible to define
another terminal, but the 'install.dc' program to do so has had this
functionality removed.

There is evidence that it used to be possible to use a VT100 terminal. It is
called an 'ANSI' terminal in the code. The VT100 terminal is the most common
type to be emulated in today's tools. However, the cursor keys of a VT100
terminal send three-character sequences, and the Dynacalc.trm has only space
for one byte. Apparently the characters '{', '}', '[' and ']' were used.

Dynacalc was originally created by Scott Schaeferle.

## Number format

-1    = 0A A0 80 0000 0000 0000 81 FF FF00

1     = 0A A0 00 0000 0000 0000 81 FF FF00   2^0 + 1
2     = 0A A0 00 0000 0000 0000 82 FF FF00   2^1 * 1
3     = 0A A0 40 0000 0000 0000 82 FF FF00   2^1 * 1.1b
4     = 0A A0 00 0000 0000 0000 83 FF FF00   2^2 + 1
5     = 0A A0 20 0000 0000 0000 83 FF FF00   2^2 + 1 * 1.01b
7     = 0A A0 60 0000 0000 0000 83 FF FF00

3/256 = 0A A0 40 0000 0000 0000 7A FF FF00 = 0.01171875

111   = 0A A0 5E 0000 0000 0000 87 FF FF00
255   = 0A A0 7F 0000 0000 0000 88 FF FF00  2^7 * 1.1111111b

65535 = 0A A0 7F FF00 0000 0000 90 FF FF00

PI    = 0A A0 49 0FDA A221 68BD 82 FF FF00  (3.141592653589793)
@PI   = 0A A0 49 0FDA A221 68BD 82 FF FF00
                                ^--- sign bit for exponent
        ||    ^ -----signbit i bit 7
        || ^------ Field type
        ^^----- length of content incl. type



'1    = 03 3031 FFFF 00
'AB.. = 0F 3041 4243 4445 4647 4849 4A4B 4C4D FFFF 00 'ABCDEFGHIJKLM' = len(13)
