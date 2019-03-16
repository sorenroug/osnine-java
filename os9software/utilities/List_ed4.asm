*****
*  LIST UTILITY COMMAND
*  Syntax: list <pathname>
*  COPIES INPUT FROM SPECIFIED FILE TO STANDARD OUTPUT

 ifp1
 use   os9defs
 endc

 mod LSTEND,LSTNAM,PRGRM+OBJCT,REENT+1,LSTENT,LSTMEM
LSTNAM fcs "List"
 fcb   4

* STATIC STORAGE OFFSETS
*
BUFSIZ equ 200 size of input buffer
 ORG 0
IPATH rmb 1 input path number
PRMPTR rmb 2 parameter pointer
BUFFER rmb BUFSIZ allocate line buffer
 rmb 200 allocate stack
 rmb 200 room for parameter list
LSTMEM EQU .

LSTENT stx PRMPTR save parameter ptr
 lda #READ. select read access mode
 os9 I$Open open input file
 bcs LIST50 exit if error
 sta IPATH save input path number
 stx PRMPTR save updated param ptr

LIST20 lda IPATH load input path number
 leax BUFFER,U load buffer pointer
 ldy #BUFSIZ maximum bytes to read
 os9 I$ReadLn read line of input
 bcs LIST30 exit if error
 lda #1 load std. out. path #
 os9 I$WritLn output line
 bcc LIST20 Repeat if no error
 bra LIST50 exit if error

LIST30 cmpb #E$EOF at end of file?
 bne LIST50 branch if not
 lda IPATH load input path number
 os9 I$Close close input path
 bcs LIST50 ..exit if error
 ldx PRMPTR restore parameter ptr
 lda 0,X
 cmpa #$0D End of parameter line?
 bne LSTENT ..no; list next file
 clrb
LIST50 os9 F$Exit ... terminate

 emod Module CRC

LSTEND EQU *

