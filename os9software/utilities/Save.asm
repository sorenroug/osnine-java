
 nam Save

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!
*

 use defsfile

 ttl OS-9 module save utility
 pag
*****
* Save <filename> <module name> {<module name>...}
*   Copies Memory To File

 mod SAVEND,SAVNAM,PRGRM+OBJCT,REENT+1,SAVENT,SAVMEM
SAVNAM fcs "Save"

 fcb 3 edition number
*****
* REVISION HISTORY
* edition 3: prehistoric
* edition 4: copyright notice removed from object;
*            stack and param space reserved
*****



SVOPTH rmb 1 output path number
 rmb 250 stack space
 rmb 200 parameter space
SAVMEM equ .

SAVENT leay -1,Y Last parameter byte ptr
 pshs X,Y Save parameter bounds
 cmpx 2,S Any parameters?
 bcc SAVE99 ..no; exit
 ldd #WRITE.*256+PEXEC.+EXEC.+PREAD.+UPDAT.
 OS9 I$Create Create file
 bcs SAVEXT Branch if error
 sta SVOPTH Save output path
 lda 0,X end of parameters?
 cmpa #$0D
 bne SAVE10 ..no; continue
 ldx 0,S use same module name as pathname if so
SAVE10 lda ,X+
 cmpa #$20 skip spaces
 beq SAVE10
 cmpa #', skip commas
 beq SAVE10
 leax -1,X
 clra ANY Type & language
 OS9 F$LINK Get module address
 bcs SAVEXT
 stx 0,S Save updated ptr
 leax 0,U Get module address
 ldy M$SIZE,X Get module size
 lda SVOPTH Get output path
 OS9 I$Write Write it out
 pshs CC,B save error status
 OS9 F$Unlink Unlink module
 ror ,S+ Restore carry
 puls B and error code
 bcs SAVEXT
 ldx 0,S Get module list ptr
 cmpx 2,S Any names left?
 bcs SAVE10 Branch if so
 OS9 I$Close
 bcs SAVEXT
SAVE99 clrb
SAVEXT OS9 F$EXIT

 emod Module Crc
SAVEND equ *
