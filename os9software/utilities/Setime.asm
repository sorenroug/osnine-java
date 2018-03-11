
 nam Setime Utility
 ttl Definitions & constants

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than 
* the licensee is strictly prohibited!
*
 page

***************
* Clock Initializer Module
*   Sets System Time

*  Module Header
Type set PRGRM+OBJCT
Revs set REENT+1
 mod STimEnd,STimNam,Type,Revs,STimEnt,STmem
STimNam fcs "Setime"

 fcb 9 Edition number
*****
* REVISION HISTORY
* edition 8: prehistoric
* edition 9: stack and param space reserved
*****

 use defsfile

*****
* Static Storage
*
          org 0
          rmb 250 room for stack
          rmb 200 room for params
STmem     equ .


C$LF set $0A
C$Bell set $07

NOCLK fcb C$LF,C$LF,C$Bell
 fcc "  >> No Clock module found <<"
 fcb C$LF,C$LF
NOCLSZ equ *-NOCLK

BADCLK fcb C$LF,C$LF,C$Bell
 fcc "  >> Clock Initialization Errors <<"
 fcb C$LF,C$LF
BADCSZ equ *-BADCLK

CLKPRT fcb C$LF
 fcc "       yy/mm/dd hh:mm:ss"
 fcb C$LF
 fcc "Time ? "
CLKPSZ equ *-CLKPRT


 ttl Routines
 pag
***************
*  Clock Initialization Routine

* Stacked Time offsets
 org 0
Year rmb 1
Month rmb 1
Day rmb 1
Hour rmb 1
Minute rmb 1
Second rmb 1
Time set .

STimEnt cmpd #2 More than cr?
 bcc STim10 Branch if some
 leas -20,S Make buffer
 leax CLKPRT,PCR Get clock prompt
 ldy #CLKPSZ Get prompt size
 lda #1 Get output path
 OS9 I$WritLn Display prompt
 leax 0,S Get buffer ptr
 lda #$D Set end of line
 sta 0,X .. in case of error
 ldy #19 Get buffer size
 clra Get Input path
 OS9 I$ReadLn Get time line
STim10 leas -Time,S get scratch
 bsr NXTNUM Get year
 stb Year,S
 bsr NXTNUM Get month
 stb Month,S
 bsr NXTNUM Get day
 stb Day,S
 bsr NXTNUM Get hour
 stb Hour,S
 bsr NXTNUM Get minute
 stb Minute,S
 bsr NXTNUM Get second
 stb Second,S
 leax Year,S
 OS9 F$STime Set time
 bcc STim90 ..No error; done
 cmpb #e$nemod Non-existing module?
 bne STim20 ..No
 leax NOCLK,PCR Report no clock
 ldy #NOCLSZ
 bra STim30

STim20 leax BADCLK,PCR Report problems
 ldy #BADCSZ Get message size
STim30 lda #1 Get output path
 OS9 I$WritLn Print message

STim90 clrb Clear Carry
 OS9 F$Exit

 pag
NXTNUM clrb Clear Number
 bsr NXTDIG Get first digit
 bsr NXTDIG Get second digit
 lda ,X+ Get delimiter
 cmpa #$20 Is it space?
 beq NXTN10 Branch if so
 cmpa #'/ Slash?
 beq NXTN10
 cmpa #': Colon?
 beq NXTN10
 cmpa #', Comma?
 beq NXTN10
 cmpa #'. Point?
 beq NXTN10
 leax -1,X Backup to unknown
NXTN10 rts

NXTDIG lda 0,X Get digit
 suba #'0 Remove ascii bias
 bcs NXTD10 Branch if not digit
 cmpa #9 Is it digit?
 bhi NXTD10 Branch if not
 leax 1,X Skip digit
 pshs A Save digit
 lda #10 Multiply by 10
 mul
 addb ,S+ Add digit
NXTD10 rts

 emod Module Crc
STimEnd equ *

