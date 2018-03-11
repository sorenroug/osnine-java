
 nam UNLINK
 ttl OS9 unlink utility

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!
*


************************************************************
*
*     Unlink Utility
*
*   Make Os-9 F$Unload system call for specified modules
*
 mod UNLEND,UNLNAM,PRGRM+OBJCT,REENT+1,UNLENT,UNLMEM
UNLNAM fcs "Unlink"

 fcb 2 edition number
*********************
* Edition History
*
* Ed  1 - Beginning of history
*
* Ed  2 - Conditionals added for Li, Lii      Wgp  12/2/82
*         File downcased

 use defsfile

UNLMEM equ $200

UNLENT clra ANY Type,revision
 ifge LEVEL-2
 OS9 F$UnLoad unlink by any other name ..
 else
 clrb
 OS9 F$Link link to requested module
 bcs UnLink10 exit if error
 OS9 F$Unlink
 bcs UnLink10 exit if error
 OS9 F$Unlink
 endc
 bcs UnLink10 branch if error
 lda ,x+
 cmpa #', another?
 beq UNLENT ..yes; unlink it
 lda ,-X
 cmpa #$0D ..end of parameter list?
 bne UNLENT ..no; unlink next
 clrb
UnLink10 OS9 F$EXIT

 emod Module Crc
UNLEND equ *

 end
