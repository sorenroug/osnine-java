
 nam ECHO

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!
*

 use defsfile

 ttl OS9 Echo utility
 pag

*****
* Echo <data to be written>
*   Copy parameter to Std Output
*   Author: Robert Doggett
*
 mod ECHEND,ECHNAM,PRGRM+OBJCT,REENT+1,ECHO,ECHMEM
ECHNAM fcs "Echo"

 fcb 5 edition number
*****
* REVISION HISTORY
* edition 4: prehistoric
* edition 5: copyright notice removed from object;
*            stack and param space reserved
*****

 org 0
 rmb 250 stack room
 rmb 200 parameter room
ECHMEM equ . static storage requirement

ECHO tfr D,Y size of parameters
*      (X)=addr of parameters
 lda #1 write to std output
 OS9 I$WritLn
 bcs ECHO90
 clrb
ECHO90 OS9 F$EXIT

 emod Module Crc

ECHEND equ *

