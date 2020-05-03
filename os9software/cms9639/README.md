Creative Micro Systems 9639
===========================

* OS-9 Level II
* The DEFS files come from FM-11.

The OS-9 kernel was installed in a 4 KB ROM that must be mapped to $F000 at CPU reset. The Boot binary starts at $0000 in the ROM. OS9p1 must be located so the top matches $0FFF in the ROM. There is a gab of 56 bytes between them.

For more information see http://www.sardis-technologies.com/oth6809/cms9639.htm
