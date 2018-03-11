
 nam LINK

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!
*

 use defsfile

 ttl OS9 link utility
 pag
*****
*  Link <module name> {,<module name>}
*   Links specified module(s)

 mod LNKEND,LNKNAM,PRGRM+OBJCT,REENT+1,LNKENT,LNKMEM
LNKNAM fcs "Link"

 fcb 5 edition number
*****
* REVISION HISTORY
* edition 4: prehistoric
* edition 5: copyright notice removed from object;
*            stack and param space reserved
*****

 org 0
 rmb 250 stack space
 rmb 200 parameter space
LNKMEM equ .

LNKENT clra ANY Type,revision
 clrb
 OS9 F$LINK Link requested module
 bcs LINK10 ..exit if error
 lda ,X+
 cmpa #', another?
 beq LNKENT ..yes; unlink it
 lda ,-X
 cmpa #$0D ..end of parameter list?
 bne LNKENT ..no; unlink next
 clrb
LINK10 OS9 F$EXIT

 emod Module Crc

LNKEND equ *

