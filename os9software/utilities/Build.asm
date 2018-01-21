
 nam BUILD

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!
*

 use defsfile

 ttl OS9 Build utility
 pag
*****
*  Build <Pathname>
*   Copies Standard input to Specified file.
*   Terminates when null line (Cr) is entered.

 mod BLDEND,BLDNAM,PRGRM+OBJCT,REENT+1,BLDENT,BLDMEM
BLDNAM fcs "Build"

 fcb 5 edition level
*****
* REVISION HISTORY
* edition 4: prehistoric
* edition 5: copyright notice removed; stack and param area reserved
*****

* Static Storage offsets
 org 0
OUTPATH rmb 1
BUFFER rmb 128
 rmb 250 Room for stack
 rmb 200 Room for params
BLDMEM equ .

 pag
BLDENT ldd #WRITE.*256+UPDAT.+PREAD. mode=write; attr=update
 OS9 I$Create create output path
 bcs BUIL40 Abort if error
 sta OUTPATH save output path
BUIL20 lda #1 to std output path
 leax <PROMPT,PCR prompt string
 ldy #2 bytecount
 OS9 I$WritLn Print prompt
 clra from Std input
 leax BUFFER,U Buffer ptr
 ldy #128 maximum 128 bytes
 OS9 I$ReadLn Read input line
 bcs BUIL30 Exit if error
 cmpy #1 carriage return only?
 beq BUIL30 ..yes; exit
 lda OUTPATH To output path
 OS9 I$WritLn Write line
 bcc BUIL20 repeat if no error
 bra BUIL40 Exit if error

BUIL30 lda OUTPATH Output path
 OS9 I$Close Close output path
 bcs BUIL40 exit if error
 clrb return without error
BUIL40 OS9 F$EXIT Terminate

PROMPT fcc '? '

 emod Module Crc

BLDEND equ *



