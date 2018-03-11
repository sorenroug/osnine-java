
 nam LOAD

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than 
* the licensee is strictly prohibited!
*

 use defsfile

 ttl OS9 Load utility
 pag
*****
* Load <pathname>
*   Loads Specified Module
*

 mod LoadEnd,LoadName,PRGRM+OBJCT,REENT+1,LoadEnt,LoadMem
LoadName fcs "Load"

 fcb 4 edition number
*****
* REVISION HISTORY
* edition 4: prehistoric
*****

 org 0
 rmb 250 stack room
 rmb 200 room for params
LoadMem equ . static storage requirement

LoadEnt OS9 F$LOAD
 bcs LoadExit
 lda 0,X
 cmpa #$0D end of line?
 bne LoadEnt ..No; repeat
 clrb
LoadExit OS9 F$EXIT

 emod Module Crc

LoadEnd equ *

