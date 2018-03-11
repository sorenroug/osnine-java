
 nam Verify Utility
 ttl Module Header & data definitions

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
*  Verify Utility
*
* Verifies and updates Header Parity & Module Crc
*
Type set PRGRM+OBJCT
Revs set REENT+1
 mod versize,vername,Type,Revs,Verify,memsize
vername fcs /Verify/ module name

 fcb 5 edition number
*****
* REVISION HISTORY
* edition 3: prehistoric
* edition 4: copyright notice removed from object;
*            stack and param space reserved
* edition 5: minor change to wording of messages
*            removed "Module's" from each line
*            so color computer doesn't wrap around
*****

* direct page storage definitions
CRC rmb 3 Current crc
ModSize rmb 2 module size
Update rmb 1 update mode flag
BuffPtr rmb 2 buffer ptr
BuffSize rmb 2 buffer size
BuffCnt rmb 2 bytes in buffer
 rmb 250 room for stack
Buffer rmb 200 room for params
 rmb 800 added buffer space
memsize equ .

 ttl Main Routine
 pag
Verify leas Buffer,U move stack ptr
 sts BuffPtr set buffer ptr
 tfr Y,D copy end of ram ptr
 subd BuffPtr get buffer size
 std BuffSize set it
 clr Update clear update mode flag
Verify10 lda ,X+ get next byte
 cmpa #'  is it space?
 beq Verify10 branch if so
 anda #$5f clear sign & upcase
 cmpa #'U turn on update mode?
 bne Verify20 branch if not
 inc Update
Verify20 ldd #9 get module header
 std ModSize
 lbsr GetBuff get in buffer
 bcs Verify30 branch if error
 cmpy #9 enough for a header?
 bne NotMod
 ldd 0,X get sync bytes
 cmpd #$87CD are they good?
 bne NotMod branch if not
 bsr VerMod verify module
 bra Verify20
Verify30 cmpb #E$EOF end of file?
 bne VerErr branch if not
 clrb clear error
VerErr OS9 F$EXIT

NotMod ldb #E$BMID Err: illegal module id
 bra VerErr

* verify header parity
VerMod clrb clear parity accumulator
 lda #8 number of bytes to do
VerMod10 eorb ,X+ do exclusive or
 deca decrement count
 bne VerMod10 loop til done
 lda Update updating?
 bne VerMod25 branch if so
 eorb 0,X include parity byte
 incb check parity
 beq VerMod15 branch if good
 leax Hdr.Bad,PCR
 bra VerMod20
VerMod15 leax Hdr.OK,PCR
VerMod20 lbsr OutStr print message
 bra VerMod30
VerMod25 comb set parity
 stb 0,X update it
VerMod30 ldx BuffPtr get buffer ptr
 ldy M$SIZE,X get module size
 leay -3,Y exclude crc itself
 sty ModSize set module size
 ldd #$FFFF initialize crc accumulator
 std CRC
 stb CRC+2
 bsr VerCRC do crc check
 lda Update updating?
 bne VerMod50 branch if so
 ldd #3 do crc itself
 std ModSize
 bsr VerCRC
 lda CRC check crc
 cmpa #CRCCon1
 bne VerMod35 branch if bad
 ldd CRC+1 finish crc check
 cmpd #CRCCon23
 beq VerMod40 branch if good
VerMod35 leax CRC.Bad,PCR
 bra VerMod45
VerMod40 leax CRC.OK,PCR
VerMod45 bsr OutStr print message
 bra VerDone
VerMod50 com CRC compliment crc
 com CRC+1
 com CRC+2
 lda #1 get std output path
 leax 0,U get crc ptr
 ldy #3 get byte count
 OS9 I$Write write it
 bcs VerErr branch if error
 clra get std input path
 OS9 I$READ skip existing crc
 bcs VerErr branch if error
VerDone rts

VerCRC10 bsr GetBuff get more module
 lbcs VerErr branch if error
VerCRC ldy BuffCnt get bytes in buffer
 beq VerCRC10 branch if none
 OS9 F$CRC get crc
 lda Update updating?
 beq VerCRC20 branch if not
 lda #1 get std output path
 OS9 I$Write write out module
 lbcs VerErr barnch if error
VerCRC20 ldd ModSize get remaining size
 subd BuffCnt count those done
 std ModSize set remaining size
 bne VerCRC10 branch if more
 std BuffCnt clear bytes in buffer
 rts

GetBuff clra get std input path
 ldx BuffPtr get buffer ptr
 ldy BuffSize get buffer size
 cmpy ModSize module smaller than memory used?
 bls GetBuf10 branch if not
 ldy ModSize get module remaining size
GetBuf10 OS9 I$READ get a buffer
 sty BuffCnt
 rts

* subroutine Outstr: output string to
* to standard error path.  Enter with
* X = address of string

OutStr lda #2 load error path number
 ldy #80 max byte count
 os9 I$WritLn call os-9 to write
 rts


* message strings
Hdr.OK fcc /Header parity is correct./
eol fcb $d
Hdr.Bad fcc /Header parity is INCORRECT !/
 fcb $d
CRC.OK fcc /CRC is correct./
 fcb $d
CRC.Bad fcc /CRC is INCORRECT !/
 fcb $d

 emod Module Crc

versize equ * module size


 end
