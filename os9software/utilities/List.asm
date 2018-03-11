
 name LIST

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!
*

 use defsfile

 ttl OS9 File list utility
 pag
*****
*  List <pathname>
*   Copies Input From Specified File To Standard Output

 mod LSTEND,LSTNAM,PRGRM+OBJCT,REENT+1,LSTENT,LSTMEM
LSTNAM fcs "List"

 fcb 5 edition number
*****
* REVISION HISTORY
* edition 4: prehistoric
* edition 5: copyright notice removed from object;
*            stack and param space reserved
*****

BUFSIZ set 200

*****
* Static Storage Offsets
*
 org 0
IPATH rmb 1 Input path number
PRMPTR rmb 2 paramter ptr
BUFFER rmb BUFSIZ Reserve buffer
 rmb 250 Reserve stack
 rmb 200 room for parameter list
LSTMEM equ .

 pag
LSTENT stx PRMPTR save parameter ptr
 lda #READ. Get mode
 OS9 I$OPEN Open file
 bcs LIST50 Exit if error
 sta IPATH Save input path
 stx PRMPTR save updated parameter ptr

LIST20 lda IPATH Get input path
 leax BUFFER,U Get buffer ptr
 ldy #BUFSIZ Maximum byte count
 OS9 I$ReadLn Get input line
 bcs LIST30 Branch if error
 lda #1 Get standard output path
 OS9 I$WritLn Write
 bcc LIST20 Repeat if no error
 bra LIST50 Exit if error

LIST30 cmpb #E$EOF End of file?
 bne LIST50 Branch if not
 lda IPATH
 OS9 I$Close close input path
 bcs LIST50 ..exit if error
 ldx PRMPTR restore parameter ptr
 lda 0,X
 cmpa #$0D End of parameter line?
 bne LSTENT ..no; list next file
 clrb
LIST50 OS9 F$EXIT Terminate

 emod Module Crc

LSTEND equ *

