
 nam MAKDIR

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!
*

 use defsfile

 ttl OS9 Utility to make a new directory
 pag
************
* Makdir
*

 mod MKDEND,MKDNAM,PRGRM+OBJCT,REENT+1,MKDENT,MKDMEM
MKDNAM fcs "Makdir"

 fcb 4 edition number
*****
* REVISION HISTORY
* edition 3: prehistoric
* edition 4: copyright notice removed from object;
*            stack and param space reserved
*****

 rmb 250 stack space
 rmb 200 room for params
MKDMEM equ .

MKDENT ldb #PEXEC.+PREAD.+PWRIT.+EXEC.+UPDAT.+DIR.
 OS9 I$MakDir Make directory
 bcs MAKDI9 ..error; return it
 clrb
MAKDI9 OS9 F$EXIT

 emod Module Crc

MKDEND equ *

