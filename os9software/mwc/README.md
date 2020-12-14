Microware C compiler
====================

This is an attempt to reconstruct the sources of the Microware C compiler. All the programs cc1, c.prep, c.pass1 etc. are written in C and compiled with the same C compiler.

cc1.dragon.asm is a disassembly of the CC1 distributed for the Dragon 64. The binary is called 'cc1', but the module name is 'cc1.dragon'.

cc1.c is a reconstruction in C that produces the same binary - or as close as possible. Evidently the original code is compiled with an older version, which creates code for returning from a function in a slightly different way.

To compile for different versions:
  DRAGON 64:
    cc1 -DDRAGON -E=4 -n=cc1.dragon -F=newcc1 cc1.c

  TANDY:
    cc1 -DTANDY -E=4 -F=newcc1 cc1.c

  Unbranded:
    cc1 -E=4 -F=newcc1 cc1.c

You don't want to forget the -F argument, or you will overwrite your working compiler.

ccdevice.asm is a module to direct where the include and library files are. On DRAGON and TANDY, this is hardcoded to "/d0", but in the unbranded version the original behaviour is recreated: First load a module called 'ccdevice', if found then use the name in the data section. If not found then call the defdrive() library function.
