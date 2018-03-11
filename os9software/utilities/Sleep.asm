
 nam Sleep Utility
 ttl Definitions & constants

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!
*

 use defsfile

*****
*
*  Sleep for specified number of ticks
*
*****
*
*  Module Header
*
Type set PRGRM+OBJCT
Revs set REENT+1
 mod SleepEnd,SleepNam,Type,Revs,SleepEnt,sleepmem
SleepNam fcs /Sleep/

 fcb 2 Edition number
*****
* REVISION HISTORY
* edition 1: prehistoric
* edition 2: copyright notice removed from object;
*            stack and param space reserved
*****

*****
* Static Storage Offsets
*
          org 0
          rmb 250  room for stack
          rmb 200  room for params
sleepmem  equ .


 ttl Routines
 page
*****
*
*  Clock Initialization Routine
*
SleepEnt clra clear sleep count
 clrb
 bsr NXTDIG get first digit
 bsr NXTDIG get second digit
 bsr NXTDIG get third digit
 bsr NXTDIG get fourth digit
 bsr NXTDIG get fifth digit
 tfr D,X copy tick count
 OS9 F$Sleep go to sleep
 clrb Clear Carry
 OS9 F$EXIT

NXTDIG pshs D save current value
 ldb 0,X Get digit
 subb #$30 Remove ascii bias
 bcs NXTD10 Branch if not digit
 cmpb #9 Is it digit?
 bhi NXTD10 Branch if not
 leax 1,X skip digit
 pshs B save new digit
 ldb #10
 mul
 stb 1,S
 lda 2,S get lsb
 ldb #10
 mul
 addb ,S+ add new digit
 adca 0,S
 std 0,S
NXTD10 puls D,PC

 emod Module Crc

SleepEnd equ *


 end
