
 nam MERGE

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!
*

 use defsfile

 ttl OS9 file merge (for pipe fitting)
 pag
 mod MRGEND,MRGNAM,PRGRM+OBJCT,REENT+1,MRGENT,MRGMEM
MRGNAM fcs "Merge"

 fcb 4 edition number
*****
* REVISION HISTORY
* edition 3: prehistoric
* edition 4: copyright notice removed from object;
*            stack and param space reserved
*****

STACK equ 256

* Static Storage requiments
 org 0
INPATH rmb 1 Input path number
PRMPTR rmb 2 ptr to parameter string
BUFPTR rmb 2 Ptr to data buffer
BUFSIZ rmb 2 Size of buffer (bytes)
BUFFER rmb 2040 Reserve buffer
 rmb STACK hardware stack space
 rmb 200 parameter room
MRGMEM equ .

 pag
*****
* Merge
*
MRGENT pshs U Ptr to low mem bound
 stx PRMPTR save parameter ptr
 tfr X,D Ptr high mem bound
 subd #STACK+BUFFER
 subd ,S++ Compute buffer size
 std BUFSIZ
 leau BUFFER,U Ptr to begin buffer
 stu BUFPTR
MRG2 ldx PRMPTR restore parameter ptr
 bsr SKPSPX Skip leading spaces
 clrb
 cmpa #$D End of line?
 beq MRGX If so: done
 lda #READ. Open file for read
 OS9 I$OPEN
 bcs MRGX Branch and report error
 sta INPATH Save input path
 stx PRMPTR save updated parameter ptr
MRG4 lda INPATH Get input path
 ldy BUFSIZ Get buffer size
 ldx BUFPTR Getptr to buffer
 OS9 I$READ Refill the buffer
 bcs MRG6 Bra if error
 lda #1 write to std output path
 OS9 I$Write Write out the buffer
 bcc MRG4 ..no error; go get next buffer
 bra MRGX Print error; exit

MRG6 cmpb #E$EOF End file?
 bne MRG8 If end file: copy next file
 lda INPATH Get input path
 OS9 I$Close Close it
 bcc MRG2 Go merge next file
MRG8 coma set carry bit
MRGX OS9 F$EXIT

*****
* Skip Spaces
* Input:
*   (X) = Line Ptr
* Output:
*   (X) = Ptr To First Non-Blank Char
*   (A) = First Non-Blank Char

SKPSPX lda ,X+ Get char
 cmpa #$20 Space?
 beq SKPSPX
 leax -1,X Move back to char
 rts

 emod Module Crc

MRGEND equ *

