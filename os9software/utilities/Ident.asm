  nam IDENT

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than 
* the licensee is strictly prohibited!
*

 use defsfile

 ttl OS9 Module header display

**********
* Ident <module>
*  OS9 Utility to display module header
* Author:  Kim Kempf
*

 mod IDNEND,IDNNAM,PRGRM+OBJCT,REENT+1,IDENT,IDNMEM
IDNNAM fcs "Ident"

 fcb 7 Edition number

**********
* Modification History
*
*    Pre 5     Beginning of history                    KKK
*    6         Make -v flag be no verify
*              Add -x option                 12/30/82  KKK
*    7         Display read-only header bit  02/18/83  KKK
*

C$BEL set $07 Beeping bell
C$CR set $0D Carriage return
C$LF set $0A Linefeed
C$Space set $20 Space
C$Comma set ', Comma
C$UPPER set $FF-$20 Uppercase conversion mask
C$Memory set 'M [-m] "in memory" option
C$Short set 'S [-s] "short form" option
C$DoCRC set 'V [-v] "no CRC verification" option
C$Exec set 'X [-x] "execution directory" option
C$HexChr set '$ hex display indicator
C$DecChr set '# dec dispaly indicator
C$CRClen set 3 Length of CRC
C$OptDlm set '- Option delimiter
C$CrcBad set '? Char to print for bad CRC (Short)
C$CrcOk set '. Char to print for good CRC (Short)
C$CRCon1 set $80 CRC constant byte 1
C$CRCon2 set $0FE3 CRC constant bytes 2 & 3
HDRLEN set M$IDSize+5 Size of disk header buffer
NAMLEN set 32 Size of name buffer
WrtEnabl equ %01000000 module header write enable

**********
* Static Storage Offsets

 org 0
LINPOS rmb 2 Current line pointer
PathPtr rmb 2 Pathlist pointer
BufCnt rmb 2 Bytes in buffer
BufPtr rmb 2 Buffer pointer
BufSiz rmb 2 Buffer size
MEMORY rmb 1 0=Display disk module
SHORT rmb 1 0=Display long form
DOCRC rmb 1 0=Check module CRC
OpenMode rmb 1 File open mode byte
MODADR rmb 2 Linked to module abs. address
MODCRC rmb C$CRClen Module CRC bytes
CRC rmb C$CRClen Calculated module CRC
MODEDIT rmb 1 Module edition
ZERSUP rmb 1 0=Zero suppression
ZERSUPBL rmb 1 0=Don't print leading blanks
IPATH rmb 1 Input path
MODATR equ . Share space with MODTYP
MODTYP rmb 1 Module type
MODREV rmb 1 Module revision
DskModLn rmb 2 Disk module length
DskBase1 rmb 2 High disk module base
DskBase2 rmb 2 Low disk module base
LINBUF rmb 80 Output line buffer

DSKBUF rmb HDRLEN Space for disk module header
NAMBUF rmb NAMLEN+1 Module name from disk (extra byte for edition)

NAMSAF rmb 1 Safety byte
 rmb 250 stack room
Stack equ . Start of stack
BufBeg rmb 2048 Buffer space
IDNMEM equ .

HLPMSG fcb C$LF
 fcc "Use: Ident [-opts] <module> [-opts]"
 fcb C$LF
 fcc "  to display module header."
 fcb C$LF
 fcc "  -m to display module in memory."
 fcb C$LF
 fcc "  -s for short form."
 fcb C$LF
 fcc "  -v for no CRC verification"
 fcb C$LF
 fcc "  -x for file in execution directory"
 fcb C$CR
HLPLEN set *-HLPMSG
BADMOD fcs "Module header is incorrect!"

IDNTLN fcs "Header for: "
MSIZLN fcs "Module size:"
MCRCLN fcs "Module CRC: "
HPARLN fcs "Hdr parity: "
EXECLN fcs "Exec. off:  "
PSSZLN fcs "Data Size:  "
TYPELN fcs "Ty/La At/Rv:"
EDITLN fcs "Edition:    "
MODULN fcs "mod,"
RENTLN fcs "re-en,"
NONSLN fcs "non-shr,"
ReadOnly fcs "R/O"
ReadWrit fcs "R/W"
OKCRCLN fcs "(Good)"
BADCRCLN fcc "(Bad)"
 fcb $80+C$BEL

TYPTBL equ * Type text table
 fcb TYPTX0-TYPTBL
 fcb TYPTX1-TYPTBL
 fcb TYPTX2-TYPTBL
 fcb TYPTX3-TYPTBL
 fcb TYPTX4-TYPTBL
 fcb TYPTX5-TYPTBL
 fcb TYPTX6-TYPTBL
 fcb TYPTX7-TYPTBL
 fcb TYPTX8-TYPTBL
 fcb TYPTX9-TYPTBL
 fcb TYPTXA-TYPTBL
 fcb TYPTXB-TYPTBL
 fcb TYPTXC-TYPTBL
 fcb TYPTXD-TYPTBL
 fcb TYPTXE-TYPTBL
 fcb TYPTXF-TYPTBL

TYPTX0 fcs "bad type for"
TYPTX1 fcs "Prog"
TYPTX2 fcs "Subr"
TYPTX3 fcs "Multi"
TYPTX4 fcs "Data"
TYPTX5 fcs "Usr 5"
TYPTX6 fcs "Usr 6"
TYPTX7 fcs "Usr 7"
TYPTX8 fcs "Usr 8"
TYPTX9 fcs "Usr 9"
TYPTXA fcs "Usr A"
TYPTXB fcs "Usr B"
TYPTXC fcs "System"
TYPTXD fcs "File Man"
TYPTXE fcs "Dev Dvr"
TYPTXF fcs "Dev Dsc"

LANTBL equ *
 fcb LANGU0-LANTBL
 fcb LANGU1-LANTBL
 fcb LANGU2-LANTBL
 fcb LANGU3-LANTBL
 fcb LANGU4-LANTBL
 fcb LANGU5-LANTBL
 fcb LANGU6-LANTBL
 fcb LANGUX-LANTBL
 fcb LANGUX-LANTBL
 fcb LANGUX-LANTBL
 fcb LANGUX-LANTBL
 fcb LANGUX-LANTBL
 fcb LANGUX-LANTBL
 fcb LANGUX-LANTBL
 fcb LANGUX-LANTBL
 fcb LANGUX-LANTBL

LANGU0 fcs "Data,"
LANGU1 fcs "6809 obj,"
LANGU2 fcs "BASIC09 I-code,"
LANGU3 fcs "PASCAL P-code,"
LANGU4 fcs "C I-code,"
LANGU5 fcs "COBOL I-code,"
LANGU6 fcs "FORTRAN I-code,"
LANGUX fcs "????,"

**********
* Ident
*    Print module header
*
IDENT leas Stack,U Move stack
 sts BufPtr Set buffer pointer
 tfr Y,D Get end of RAM ptr
 subd BufPtr get buffer size
 std BufSiz ..and set it
 leay LINBUF,U Get output buffer addr
 sty LINPOS Reset output buffer
 clr MEMORY Assume disk module
 clr SHORT Assume full form
 clr DOCRC Assume CRC check
 clr ZERSUPBL No blanks on zero suppress
 lda #READ. Default file open mode
 sta OpenMode ..save it
 ldd #0 Get a zero
 std PathPtr Zero path pointer
 std BufCnt Clear buffer byte count

*****
* Parse out pathlist/options
*
IDNT02 lda ,X+ Get parameter character
mfree
IDNT03 cmpa #C$Space Space?
 beq IDNT02 ..yes, skip it
 cmpa #C$Comma Comma?
 beq IDNT02 ..yes, skip it
 cmpa #C$CR End-of-line?
 beq IDNT10 ..yes, take off
 cmpa #C$OptDlm Start of options?
 beq IDNT05 ..yes, go process options
 ldy PathPtr Get path pointer
 bne IDNT02 ..don't save if already found
 stx PathPtr ..first pathlist found
 bra IDNT02 look for more options

IDNT05 lda ,X+ Get the option character
 cmpa #C$OptDlm Still doing options?
 beq IDNT05 ..yes, continue processing
 cmpa #'0 A (loosly) delim?
 blo IDNT03 ..yes, back to pathlist scan

*****
* Handle -m option
*
 eora #C$Memory Check a memory module?
 anda #C$UPPER UPPER or lower case
 bne IDNT06 ..no, not this option
 inc MEMORY Display memory module
 bra IDNT05 Look for more options

*****
* Handle -s option
*
IDNT06 lda -1,X Get the option character
 eora #C$Short Short form?
 anda #C$UPPER UPPER or lower case
 bne IDNT07 ..no, not this option
 inc SHORT Display short form
 bra IDNT05 Look for more options

*****
* Handle -v option
*
IDNT07 lda -1,X Get the option character
 eora #C$DoCRC Do CRC check?
 anda #C$UPPER UPPER or lower case
 bne IDNT08 ..no, not this option
 inc DOCRC No CRC check
 bra IDNT05 Look for more options

*****
* Handle -x option
*
IDNT08 lda -1,X Get the option character
 eora #C$Exec Execution directory?
 anda #C$UPPER UPPER or lower case
 bne IDNT09 ..no, not this option
 lda #READ.+EXEC. Exec mode
 sta OpenMode ..save it
 bra IDNT05 Look for more options

*****
* Handle more options here
*
IDNT09 lbra IDNT98 Bad option, print help

IDNT10 ldx PathPtr Get start of pathlist
 lbeq IDNT98 ..error if no pathlist found
 leax -1,X Backup to start of pathlist

*****
* Dispatch
*
 tst MEMORY
 beq DSKMOD

*****
* Handle module in memory
*
 pshs U Save data pointer
 clra Any module, any type
 OS9 F$Link Link to the module
 lbcs IDNT99 ..error, exit
 stu MODADR Save abs. address of module
 ldd M$Id,U Get module id bytes
 cmpd #M$Id12 Really a module header?
 beq IDNT12 yes, continue
 puls U Get data pointer again
IDNT11 leay BADMOD,PCR
 lbsr OutName Print bad module message
 lbsr OutEol Print the line
 clrb return no error
 lbra IDNT99 ..and exit


*****
* Copy module CRC
*
IDNT12 ldd M$Size,U Load module size from header
 subd #C$CRClen Backup up to the CRC bytes
 leax D,U Point to the CRC bytes
 puls U Get data pointer
 leay MODCRC,U Point to CRC holder
 pshs U Save data pointer
 lda #C$CRClen Number of bytes to transfer
IDNT20 ldb ,X+ Get a byte
 stb ,Y+ Store the byte
 deca
 bne IDNT20 Until all copied
 puls U Restore data pointer

 lbsr SHOMOD Show the module data

 ldu MODADR Load module header address
 OS9 F$Unlink Unlink the module
 lbcs IDNT99 error
 clrb Return no errors
 lbra IDNT99 ..and exit

*****
* Handle module on disk
*
DSKMOD lda #$80 Get safety byte with
 sta NAMSAF ..high bit set
 lda OpenMode Get the open mode
 OS9 I$Open Open the file
 lbcs IDNT99 ..exit, if error
 sta IPATH Save path number
 ldd #0 Get a clear byte
 std DskBase1 Initialize module
 std DskBase2 ..base offset
 std DskModLn Init module length

DSKM05 ldd DskBase2 Get low address of disk module
 addd DskModLn ..add in the length of last module
 std DskBase2 ..and save as new low address
 bcc DSKM07 Carry occur?
 ldd DskBase1 Get HI bytes
 addd #1 ..bump 'em
 std DskBase1 ..and store 'em
DSKM07 pshs U Save data pointer
 ldx DskBase1 Get HI bits
 ldu DskBase2 Get LO bits
 lda IPATH Get input path number
 OS9 I$Seek Point to the module start
 lbcs IDNT99 ..exit if error
 puls U Restore data pointer
 leax DSKBUF,U Address of disk buffer
 stx MODADR Save for SHOMOD routine
 ldy #HDRLEN Length of header
 OS9 I$Read Read the file
 bcc DSKM08 ..continue if all OK
 cmpb #E$EOF End of file?
 bne IDNT99 ..no, return error
 bra DSKM99 ..yes, clean up

DSKM08 ldd M$Id,X Get the module ID
 cmpd #M$ID12 Really a module header?
 lbne IDNT11 no, print error and exit

DSKM10 pshs X,U Save data pointers
 ldd M$Size,X Get the module size
 std DskModLn Save the module length
 addd DskBase2 Add in the disk base addr
 tfr D,U Save for I$Seek
 leau -C$CRClen,U Backup to the CRC bytes
 ldx DskBase1 Get MSB
 bcc DSKM15 disk base carry?
 leax 1,X ..yes, adjust MSB
DSKM15 lda IPATH
 OS9 I$Seek Seek to the CRC bytes
 bcs IDNT99 ..exit if error
 puls X,U Restore data pointers
 leax MODCRC,U Point to CRC holder
 ldy #C$CRClen Read the CRC bytes only
 lda IPATH
 OS9 I$Read
 bcs IDNT99 exit if error

 pshs X,U Save data pointers
 ldy MODADR get module address
 ldd M$Name,Y Get the name offset
 addd DskBase2 Add in the disk base addr
 tfr D,U Save for I$Seek
 ldx DskBase1 Get MSB
 bcc DSKM20 disk base carry?
 leax 1,X ..yes, adjust MSB
DSKM20 lda IPATH
 OS9 I$Seek Seek to the name bytes
 bcs IDNT99 exit if error
 puls X,U Restore data pointers
 leax NAMBUF,U Point to name holder
 ldy #NAMLEN+1 Read the name (and edition) bytes
 lda IPATH
 OS9 I$Read
 bcs IDNT99 exit if error
 
 bsr SHOMOD Show the module data
 lbra DSKM05 Do next disk module

DSKM99 clrb return no errors
 bra IDNT99

IDNT98 lda #1 Std output
 leax HLPMSG,PCR Point to help message
 ldy #HLPLEN ..and it's length
 OS9 I$Writln Print the help
 clrb Return no errors

IDNT99 OS9 F$Exit Terminate

**********
* SHOMOD
*    Print the module description
*
SHOMOD tst SHORT Short form?
 lbne ShoShrt ..yes, show short form

 lbsr OutEol
 leay IDNTLN,PCR
 lbsr Outname Print "Description of..."
 lbsr ShoName Print the name
 lbsr OutEol Print the line

 leay MSIZLN,PCR
 lbsr Outname Print "Module size:"
 ldy MODADR Get address of module
 ldd M$Size,Y Get module size
 lbsr HexLine Print the info line

 leay MCRCLN,PCR
 lbsr Outname Print "Module CRC:"
 lbsr CrcOut Print the CRC bytes
 tst DOCRC Do the CRC check?
 bne SHOM07 ..yes
 lbsr CheckCrc Verify the CRC
 tsta Was it OK?
 beq SHOM05 ..yes
 leay BADCRCLN,PCR
 lbsr OutName Print " *** Bad CRC "
 bra SHOM07
SHOM05 leay OKCRCLN,PCR
 lbsr OutName Print " (Correct)"
SHOM07 lbsr OutEol Print the line

 leay HPARLN,PCR
 lbsr Outname Print "Header parity:"
 ldy MODADR Get module addr
 ldb M$Parity,Y Get module parity
 lbsr Hex2Out Print the hex bytes
 lbsr OutEol Print the line

 ldy MODADR Get module address
 ldb M$Type,Y Get module type
 stb MODTYP Save module type
 andb #$F0 Save hi nybble of type
 cmpb #Drivr ..is a device driver
 beq SHOM10 ..yes; show parity and exec. offset
 cmpb #Prgrm ..is a program module
 bne SHOM20 ..no; skip parity and exec. offset

SHOM10 leay EXECLN,PCR
 lbsr Outname Print "Execution offset:"
 ldy MODADR Get module address
 ldd M$Exec,Y Get execution offset
 lbsr HexLine Print the info line

 leay PSSZLN,PCR
 lbsr Outname Print "Perm. Storage..."
 ldy MODADR Get module address
 ldd M$Mem,Y Get memory size
 lbsr HexLine Print the info line

SHOM20 leay EDITLN,PCR
 lbsr OutName Print "Edition:"
 ldb MODEDIT Get module edition
 pshs B Save for later
 lbsr Hex2Out Print the hex value
 ldb #5 Output some
 lbsr SpaceOut ..spaces
 puls B Get edition
 clra Do only the lo nybble
 lbsr DecOut Print in decimal
 lbsr OutEol Print the line

 leay TYPELN,PCR
 lbsr OutName Print "Type/Lang Attr/Rev:"
 ldb MODTYP
 lbsr Hex2Out Output the Type/Lan byte
 ldy MODADR Get module address
 ldb M$Revs,Y Get module revs
 stb MODREV Save for later
 lbsr Hex2Out Output the Attr/Rev bytes
 lbsr OutEol

 ldb MODTYP Get module type
 lsrb Shift down the high nibble
 lsrb 
 lsrb 
 lsrb
 leax TYPTBL,PCR Get addr of addr table
 lda B,X Get the address of the text
 leay A,X Make the text address
 lbsr OutName Print the type text
 leay MODULN,PCR
 lbsr Outname Print " module"

 ldb MODTYP Load module type
 andb #$0F Keep only the language nybble
 leax LANTBL,PCR Get addr of addr table
 lda B,X Get the address of the text
 leay A,X Make the text address
 lbsr OutName Print the language type

 ldb MODREV Get revision byte
 bitb #ReEnt Is module re-entrant?
 beq ATTR10 ..no
 leay RENTLN,PCR
 lbsr OutName Print "Re-entrant" and return
 bra ATTR20 

ATTR10 leay NONSLN,PCR
 lbsr OutName Print "Non-sharable"
ATTR20 bitb #WrtEnabl write enabled?
 beq Attr25 bra if not
 leay ReadWrit,pcr
 bra SHOM98
Attr25 leay ReadOnly,pcr
SHOM98 lbsr OutName
 lbsr OutEol Print the line and return

SHOM99 rts

ShoName tst MEMORY Module in memory?
 beq SHON02 ..no, get from special buffer
 ldy MODADR Get address of module
 ldd M$Name,Y Get offset to name
 leay D,Y Point to module name
 bra SHON05 Go print the name

SHON02 leay NAMBUF,U Load address of name buffer

SHON05 lbsr Outname Print the module name
 lda ,Y Get the Edition byte
 sta MODEDIT Save it for later
 rts Exit

**********
* ShoShrt
*  Show display in short form
*
ShoShrt ldb #6 Save some space in buffer
 lbsr SpaceOut ..for module edition

 ldy MODADR Get address of module
 ldb M$Type,Y Get module type/lang
 lbsr Hex2Out Display in hex
 bsr CrcOut Display CRC in hex
 tst DOCRC Do the CRC check?
 beq Shos05 ..yes
 lda #C$Space Just a space if no CRC check
 bra ShoS10 go print it
ShoS05  bsr CheckCrc Verify the CRC
 tsta Was it ok?
 bne ShoS10 ..no, branch
 lda #C$CrcOk print CRCok character
Shos10 lbsr OutChar Print the CRCbad character
ShoS20 lbsr PutSpc Space separator

 bsr ShoName Show the module name
 ldx LINPOS Get the current line pointer
 pshs X ..and save it
 leax LINBUF,U Reset the line pointer
 stx LINPOS ..to beginning of buffer
 ldb MODEDIT Get module edition
 inc ZERSUPBL Show blanks on zero supp
 clra
 lbsr BinDec Show the edition
 clr ZERSUPBL No blanks on zero supp
 puls X Get the line pointer back
 stx LINPOS ..and restore it
 lbsr OutEol Print the short line
 rts ..and return

**********
* CrcOut
*  Display CRC bytes
*
CrcOut lda #C$HexChr Put the hex sign
 lbsr Outchar ..in the buffer
 ldd MODCRC Get the first 2 CRC bytes
 lbsr Bin4Hx ..and store in buffer
 ldb MODCRC+2 Get the third CRC byte
 lbsr Bin2Hs ..and store in buffer
 rts

**********
* CheckCrc
*  Verify module CRC
*
* Returns: (A)=0 if CRC is OK
*
CheckCrc ldd #$FFFF Initialize CRC accumulator
 std CRC ..high bytes
 stb CRC+2 ..and the lo byte
 pshs X,Y,U Save these regs
 leau CRC,U Addr of the CRC accumulator
 tst MEMORY Is module in memory?
 beq Check50 ..no, do disk CRC check
 
*****
* Get Memory module CRC
*
 ldx MODADR Start addr of memory module
 ldy M$Size,X Length of module (with CRC)
 OS9 F$CRC Do the CRC
 lbcs IDNT99 ..in case of error
 bra Check60

*****
* Get Disk module CRC
*
Check50 pshs X,U Save regs
 ldx DskBase1 Load byte addr
 ldu DskBase2 ..of disk module
 lda IPATH Input data path
 OS9 I$Seek Point to the module start
 puls X,U Restore regs
 lbcs IDNT99 ..exit if error
 ldd DskModLn Get the module length
 pshs D ..and save it
 bsr DskCRC
 puls D Restore the
 std DskModLn ..module length

Check60 puls X,Y,U Restore regs
 lda CRC Get first CRC byte
 cmpa #C$CRCon1 CRC ok?
 bne Check90 ..no, exit
 ldd CRC+1 Get rest of CRC
 cmpd #C$CRCon2 CRC ok?
 bne Check90 ..no, exit
 bra Check95 CRC good, exit

Check90 lda #C$CrcBad Say the CRC is bad
 rts ..and return
Check95 clra Say the CRC is good
Check99 rts ..and return

**********
* GetBuf
*  Fill buffer with disk module data
*
GetBuf lda IPATH Get disk path
 ldx BufPtr Get buffer pointer
 ldy BufSiz Get buffer size
 cmpy DskModLn module smalr than mem used?
 bls GetBuf10 ..no
 ldy DskModLn Get module remaining size
GetBuf10 OS9 I$Read get a buffer
 sty BufCnt Save bytes in buffer
 rts

**********
* DskCRC
*   Verify Disk module CRC
*
DskCRC10 bsr GetBuf get more module
 lbcs IDNT99 ..exit if error
DskCRC ldy BufCnt Get bytes in buffer
 beq DskCRC10 ..go get some if none
 OS9 F$CRC Get CRC
 ldd DskModLn Get remaining size
 subd BufCnt count those done
 std DskModLn set remaining size
 bne DskCRC10 do more, if more
 std BufCnt Clear bytes in buffer
 rts

**********
* HexLine
*  Print line of Hex4 and Decimal
*
HexLine pshs D Save the value
 bsr Hex4Out Output the hex value
 ldb #3 Output some
 bsr SpaceOut ..spaces
 puls D Get the value again
 bsr DecOut Output the decimal value
 bsr OutEol Print the buffer
 rts
 
**********
* HiNyble
*  Print line of Hi nybble of B
*
HiNybble pshs A,B Save regs
 andb #$F0 Mask high nybble
 lsrb Shift if to right
 lsrb ..2
 lsrb ..3
 lsrb ..4 times
DoNybble lda #C$HexChr Put $ in buffer
 bsr OutChar ..for $0
 lbsr HexChr Print the hex char
 ldb #2 Output some
 bsr SpaceOut ..spaces
 puls A,B,PC Restore regs and RTS

LoNybble pshs A,B Save byte
 andb #$0F Mask low byte
 bra DoNybble And show it

**********
* Outname
*    Print name, High byte delimiter
*
* Passed: (Y)=Ptr to name
* Destroys: A,CC
*
Outname lda 0,Y
 anda #$7F
 bsr Outchar
 lda ,Y+
 bpl Outname
* Fall through to Outchar

**********
* Outchar
*    Put one char in output buffer
*
* Passed: (A)+Char
* Destroys: CC
*
Outspace lda #C$Space

Outchar pshs X
 ldx LINPOS
 sta ,X+
 stx LINPOS
 puls X,PC

**********
* OutEol
*    Print buffer
*
* Destroys: CC
*
OutEol pshs A,X,Y
 lda #C$CR
 bsr Outchar Put carriage return in buffer
 leax LINBUF,U
 stx LINPOS Reset line ptr
 ldy #80
 lda #1
 OS9 I$Writln
 puls A,X,Y,PC

**********
* Hex4Out
*  Convert D to hex value; store in LINBUF
*
Hex4Out pshs A Save regs
 lda #C$HexChr Put a $ in the
 bsr OutChar ..buffer for $0000
 puls A Restore regs
 bsr Bin4Hs Put the hex value in buffer
 rts Restore regs and RTS

**********
* Hex2Out
*  Convert B to hex value; store in LINBUF
*
Hex2Out pshs A Save regs
 lda #C$HexChr Put a $ in the
 bsr OutChar ..buffer for $00
 puls A Restore regs
 bsr Bin2Hs Put the hex value in buffer
 rts Return

**********
* Hex1Out
* Convert low nybble of B to hex value; store in LINBUF
*
Hex1Out pshs A Save regs
 lda #C$HexChr Put a $ in the
 bsr OutChar ..buffer for $0
 puls A REsotre regs
 bsr HexChr Put the hex char in buffer
 rts Return

**********
* DecOut
*  Convert D to decimal value; store in LINBUF
*
DecOut pshs A
 lda #C$DecChr Put a # in the
 bsr OutChar ..buffer for #00000
 puls A Restore regs
 bsr BinDec Put the decimal value in buffer
 rts Return

**********
* SpaceOut
*  Put spaces in output buffer
*
* Passed: (B) number of spaces to output
*
SpaceOut pshs A,B
Space01 tstb More?
 ble Space99 ..no, exit
 bsr OutSpace Output a space
 decb bump counter
 bra Space01

Space99 puls A,B,PC Restore regs and RTS

**********
* Bin4Hs
*  Subroutine to convert word in D reg
*    to four-char hex followed by a space
*
* Passed: (D) Word to convert
* Destroys: CC
*
Bin4Hs bsr Bin4Hx Perform conversion
 bra Putspc Go output a space and return

**********
* Bin2Hs
*  Subroutine to convert byte in B reg
*    to two-char hex followed by a space
*
* Passed: (B) Byte to convert
* Destroys: CC
*
Bin2Hs bsr Bin2Hx Perform conversion
* Fall through to Putspc

**********
* PutSpc
*  Put a space character in output buffer
*
PutSpc pshs A
 lda #C$Space
 bsr OutChar
 puls A,PC

**********
* Bin4Hx
*  Convert word in D register to
*    four-char hex
*
Bin4Hx exg A,B Swap bytes
 bsr Bin2Hx Convert Hi order byte
 tfr A,B Move Lo order byte to B
* Fall through to convert low byte

**********
* Bin2Hx
*  Convert byte in B register to
*    two-char hex
*
Bin2Hx pshs B Save byte
 andb #$F0 Mask HI nybble
 lsrb Shift it to right
 lsrb ..2
 lsrb ..3
 lsrb ..4 times
 bsr HexChr ..then convert it
 puls B Restore byte
 andb #$0F Mask low byte

HexChr cmpb #9 Range 0-9?
 bls HxChr2 ..yes, skip correction
 addb #7 Adjust for A-F
HxChr2 addb #$30 Make it ASCII
 exg A,B
 lbsr OutChar Put in buffer
 exg A,B
 rts

**********
* BinDec
*  Convert word in D reg to
*    five-char decimal
BinDec pshs B,Y,U Save local registers
 leau <TnsTbl,PCR Get constants table address
 clr ZERSUP set zero suppression
 ldy #5 Y is loop counter

* Digit conversion loop
BinDc2 clr ,S Clear digit temp
BinDc3 subd ,U Subtract power-of-ten
 bcs BinDc4 ..exit if underflow
 inc ,S ..else bump count
 bra BinDc3 ...and do it again
BinDc4 addd ,U++ Restore and bump pointer
 pshs B Save low byte
 ldb 1,S Get digit counter
 exg A,B
 bsr ZeroSup Print with zero suppress
 exg A,B
 puls B restore lo byte
 cmpy #2 On last digit?
 bgt BinDc5 ..no, continue
 inc ZERSUP ..yes, print the digit always
BinDc5 leay -1,Y decr loop count
 bne BinDc2 loop if more to do
 puls B,Y,U,PC Pop regs and RTS

* Power-of-Tens conversion table
TnsTbl fdb 10000
 fdb 1000
 fdb 100
 fdb 10
 fdb 1

**********
* ZeroSup
*  Print with zero suppression
*
* Passed: (A)=Digit
* Destroys: A,CC
*
ZeroSup tsta Zero?
 beq Zero10
 sta ZERSUP ..no; end zero suppression
Zero10 tst ZERSUP Zero suppression?
 bne Zero20 ..no: print digit
 tst ZERSUPBL Show blanks on suppress?
 beq Zero15 ..no; exit
 lda #C$Space Print a space
 bra Zero30
Zero15 rts

Zero20 adda #'0 Make is ASCII
Zero30 lbra OutChar

 emod Module CRC

IDNEND equ *
 end
