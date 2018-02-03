
 nam DUMP

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!
*

 use defsfile

 ttl OS9 File dump utility
 pag
***************
* Dump [<input-pathname> [<output-pathname>]]
*   Display a file in hex format (64-char line)
* Author: Robert Doggett

* The file is printed in both hex and ascii.
* Non-printable ascii characters are printed as "."

* If input-pathname is not specified, Std Input
* is dumped to Std output.  Output defaults to
* Std Output.  This makes Dump useful in pipelines.

 mod DMPEND,DMPNAM,PRGRM+OBJCT,REENT+1,DMPENT,DMPMEM
DMPNAM fcs "Dump"

 fcb 4 edition number
*****
* REVISION HISTORY
* edition 3: prehistoric
* edition 4: copyright notice removed from object;
*            stack and param space reserved;
*            header chars made upcase;
*****


 pag
*****
* Dump Static Storage

 org 0
DMPINP rmb 1 Input path (to dump)
DMPOUT rmb 1 Output path (for listing)
DMPADR rmb 2 Position in dump file
DMPCNT rmb 1 Count of bytes read (<=16)
HEXPTR rmb 2
ASCPTR rmb 2
DMPBUF rmb 16 Input buffer
DMPLIN equ .
HEXADR rmb 6 Position field
HEXDAT rmb 40 Eight 5-byte fields
 rmb 1
ASCDAT rmb 16 Ascii field
LINLEN equ .-DMPLIN Length of line
DMPCR rmb 1 Carriage return
 rmb 250 Stack room
 rmb 200 room for params
DMPMEM equ . Dump memory requirement

 pag
DMPHD1 equ *
 fcc "Addr   0 1  2 3  4 5  6 7  8 9  A B  C D  E F  0 2 4 6 8 A C E"
 fcb $D
DMPHD2 equ *
 fcc "----  ---- ---- ---- ---- ---- ---- ---- ----  ----------------"
HDRCR fcb $D

CHKEOL lda ,X+ Get next character
 cmpa #$20 Space?
 beq CHKEOL ..yes; skip it
 leax -1,X Back up to non-space character
 cmpa #$D Eol?
 rts

***************
* Dump Entry Point

DMPENT ldd #1 Set standard paths
 std DMPINP
 bsr CHKEOL Check for end of command line
 beq DUMP1
 lda #READ.
 OS9 I$OPEN Open input path
 lbcs DUMP9 ..oops; error
 sta DMPINP Save input path
 bsr CHKEOL End of command line yet?
 beq DUMP1
 lda #WRITE.
 ldb #UPDAT.+PREAD.
 OS9 I$Create Open output path
 lbcs DUMP9 ..oops; error
 sta DMPOUT Save output path
DUMP1 ldd #0
DUMP2 std DMPADR Save file position
 tstb EVEN "page" boundary?
 bne DUMP3 ..no; don't print heading
 leax <HDRCR,PCR
 bsr PRINT
 leax DMPHD1,PCR
 bsr PRINT
 leax DMPHD2,PCR
 bsr PRINT
DUMP3 leax DMPLIN,U Get addr of output line
 lda #$20
 ldb #LINLEN
DUMP4 sta ,X+ Blank out print line
 decb
 bne DUMP4 Repeat for entire line
 leax HEXADR,U
 stx HEXPTR Setup for outhex
 lda DMPADR
 bsr OUTHEX Put msb of file positn in line
 lda DMPADR+1 Put lsb in line
 bsr OUTHEX
 leax HEXDAT,U Skip over to data portion
 stx HEXPTR
 leax ASCDAT,U
 stx ASCPTR
 leax DMPBUF,U Get addr of input buffer
 ldy #16
 lda DMPINP
 OS9 I$READ Read 16 bytes of input data
 bcs DUMP7 ..error; eof?
 tfr Y,D
 stb DMPCNT Save bytecount actually read
DUMP5 bsr DMPCHR Dump byte
 decb DECREMENT Count
 beq DUMP6 ..exit if done
 bsr DMPCHR Dump another byte
 lda #$20
 bsr HEXCHR Space one
 decb DECREMENT Count
 bne DUMP5 ..repeat until zero
DUMP6 lda #$0D
 sta DMPCR Move carriage return to end of line
 leax DMPLIN,U Restore addr of print line
 bsr PRINT
 bcs DUMP9 ..oops; error
 ldd DMPADR
 addb DMPCNT Update file position
 adca #0
 bra DUMP2 Repeat until eof

PRINT ldy #80
 lda DMPOUT
 OS9 I$WritLn
 rts

DUMP7 cmpb #E$EOF End of file "error"?
 bne DUMP9 ..no; exit
 clrb return No error
DUMP9 OS9 F$EXIT Terminate

***************
* Dump Subroutines
*
OUTHEX pshs A (a)=char to print in hex
 lsra
 lsra
 lsra
 lsra SHIFT High nibble down
 bsr OUTHX2 Print in ascii form
 lda 0,S Restore byte
 bsr OUTHX2 Print low nibble in ascii form
 puls A,PC return

OUTHX2 anda #$0F Strip of ms nibble
 cmpa #9
 bls OUTHX3
 adda #7 Adjust for $a-$f
OUTHX3 adda #'0 Convert to ascii
HEXCHR pshs X
 ldx HEXPTR
 sta ,X+ Put char in line
 stx HEXPTR Update line ptr
 puls X,PC return

DMPCHR lda ,X+ Get next char
 bsr OUTHEX Dump hex

ASCII pshs A,X Save regs
 anda #$7F Strip "parity" bit
 cmpa #$20 control character?
 blo ASCII1 ..yes; print "." instead
 cmpa #$7E unprintable?
 blo ASCII2 ..no; print character
ASCII1 lda #'. Translate non-printables
ASCII2 ldx ASCPTR
 sta ,X+ put char in line
 stx ASCPTR Save updated ptr
 puls A,X,PC return

 emod Module Crc

DMPEND equ *

