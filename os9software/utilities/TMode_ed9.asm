
 nam TMODE

* Tmode from Dragon 64 distribution. Serial I/O is through
* an 6551 UART.

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than 
* the licensee is strictly prohibited!
*

 use defsfile

 mod SETSIZ,SETNAM,PRGRM+OBJCT,REENT+1,SETENT,SETMEM
SETNAM fcs "Tmode"

 fcb 9 edition number
*********************
* Edition History
*
* Ed  6 - Beginning of history
*
* Ed  7 - File set up for LI and LII assembly w/common defs WGP 12/2/82
*
* Ed  8 - Add conditionals for Color Computer               KKK 01/05/83
*
* Ed  8 - Add options for 6551 UART (baud, XON, XOFF)
 pag

 ifeq Screen-small
MARGIN set 22 Output line margin
 else
MARGIN set 50 Output line margin
 endc

C$PATH set '. Optional path delimiter
C$NOT set '- Logical not character
C$ASGN set '= Assignment operator
C$COMA set ', Comma
C$SPAC set $20 Space
C$PDLIM set '/

 org 0
SETPTH    rmb   1
NOTSET    rmb   1
LINPTR    rmb   2
LINPOS    rmb   1
SIGNIF    rmb   1
OPTBUF    rmb  32
OUTLIN rmb 80 Output line
 rmb 256 Stack space
 rmb 200 parameter room
SETMEM equ . Total memory requirement

 ttl OPTION Description table
 pag
**********
* Option Description Table
*
* Format Of Table:
*  (1) Type:   Logical/Numeric/Byte
*  (2) Value:  Default Value Of Option
*  (3) Positn: Offset Of Option In Status
*  (4) Negate: Natural Negation Of Logical Opts
*  (5) Name:   n-Bytes, High Bit set On Last
*
 org 0
TYPE rmb 1
VALUE rmb 1
POSITN rmb 1
NEGATE rmb 1
NAME equ .

LOGCAL equ $FF
NONZ equ 1
ZER0 equ 0
NUMRIC equ 0
BINARY equ 1

 fdb 23 Number of table entries (baud, XON, XOFF)

OPTTBL equ *
 fcb LOGCAL,NONZ,PD.UPC-PD.OPT,NONZ
 fcs "upc" Uppercase only
 fcb LOGCAL,NONZ,PD.BSO-PD.OPT,NONZ
 fcs "bsb" Bsp,space,bsp
 fcb LOGCAL,ZER0,PD.DLO-PD.OPT,ZER0
 fcs "bsl" Backspace over line
 fcb LOGCAL,NONZ,PD.EKO-PD.OPT,NONZ
 fcs "echo" Echo on
 fcb LOGCAL,NONZ,PD.ALF-PD.OPT,NONZ
 fcs "lf" Auto lf on
 fcb NUMRIC,0,PD.NUL-PD.OPT,0
 fcs "null" Null count
 fcb LOGCAL,NONZ,PD.PAU-PD.OPT,NONZ
 fcs "pause" Page pause
 fcb NUMRIC,24,PD.PAG-PD.OPT,0
 fcs "pag" Page size in lines
 fcb BINARY,C$BSP,PD.BSP-PD.OPT,0
 fcs "bsp" Backspace character
 fcb BINARY,C$DEL,PD.DEL-PD.OPT,0
 fcs "del" Delete character
 fcb BINARY,C$CR,PD.EOR-PD.OPT,0
 fcs "eor" End of record char
 fcb BINARY,C$EOF,PD.EOF-PD.OPT,0
 fcs "eof" End of file char
 fcb BINARY,C$RPRT,PD.RPR-PD.OPT,0
 fcs "reprint" Reprint line char
 fcb BINARY,C$RPET,PD.DUP-PD.OPT,0
 fcs "dup" Duplicate previous line char
 fcb BINARY,C$PAUS,PD.PSC-PD.OPT,0
 fcs "psc" Pause character
 fcb BINARY,C$INTR,PD.INT-PD.OPT,0
 fcs "abort" Keyboard interrupt char
 fcb BINARY,C$QUIT,PD.QUT-PD.OPT,0
 fcs "quit" Keyboard quit char
 fcb BINARY,C$BSP,PD.BSE-PD.OPT,0
 fcs "bse" Backspace echo char
 fcb BINARY,C$BELL,PD.OVF-PD.OPT,0
 fcs "bell" Bell character
 fcb BINARY,$15,PD.PAR-PD.OPT,0
 fcs "type" Acia no-parity type
 fcb NUMRIC,$02,PD.BAU-PD.OPT,0
 fcs "baud" baud rate
 fcb BINARY,C$XON,PD.XON-PD.OPT,0
 fcs "xon" x-on char
 fcb BINARY,C$XOFF,PD.XOFF-PD.OPT,0
 fcs "xoff"

*****
* Tmode
*
SETENT leay 0,X (y)=command line parameters
 bsr SKIPSP Skip any [comma] spaces
 clra
 cmpb #C$PATH Path delimiter?
 bne SET10 ..no
 leay 1,Y
 lda ,Y+ Get path number
 suba #'0 Convert to ascii
 cmpa #NumPaths In range?
 lbhs SYNTAX ..no; syntax error
SET10 sta SETPTH Save path
 ldb #SS.OPT
 leax OPTBUF,U Get option pointer
 OS9 I$GetStt Read scf option bytes
 bcs SETEXT ..error; exit
 bsr SKIPSP Skip any [comma] spaces
 cmpb #C$CR End of line?
 lbeq OPTLST ..yes; list current options
SET20 bsr OPTSET set (next) option
 bcs SYNTAX ..syntax error
 cmpb #C$CR
 bne SET20 ..repeat until end of line
 lda SETPTH
 ldb #SS.OPT
 OS9 I$SetStt Rewrite options
 bcs SETEXT ..oops, error
 clrb
SETEXT OS9 F$Exit

SKIPSP ldb ,Y+ Get character
 cmpb #C$COMA Comma?
 bne SKIP20 ..no
SKIP10 ldb ,Y+ Get next character
SKIP20 cmpb #C$SPAC Space?
 beq SKIP10 ..yes; skip
 leay -1,Y
 andcc #$FF-CARRY Clear carry
 rts

OPTSET clr NOTSET
 lda 0,Y Get next char
 cmpa #C$NOT Not ("-") char?
 bne OPT10 ..not
 inc NOTSET Notset=1
 leay 1,Y
OPT10 sty LINPTR Save updated line ptr
 leax OPTTBL,PCR Option description tbl
 lbsr SEARCH ..option in table?
 bcs SYNTAX ..no; error
 lda TYPE,X Logical type option?
 bpl OPT20 ..no

OPT15 ldb VALUE,X Get default value of option
OPT17 lda POSITN,X Get offset of otpion
 eorb NOTSET Negate if "not"
 leax OPTBUF,U
 stb A,X Save default value
 bra SKIPSP Skip spaces, return

OPT20 tst NOTSET Logical not?
 bne SYNTAX ..yes; syntax error
 ldb 0,Y Get next character
 cmpb #C$ASGN Assignment symbol?
 bne OPT15 ..no; get default for symbol
 leay 1,Y Skip assignment
 tsta ..(DECIMAL) Numeric type?
 bne OPT30 ..no; go do binary
 clrb
OPT25 lda 0,Y Get (next) digit
 suba #'0 Convert to binary
 cmpa #9 Numeric?
 bhi OPT37 ..no; end of number
 pshs A Save digit
 leay 1,Y Skip digit
 lda #10
 mul PREVIOUS Sum times ten
 addb ,S+ Add in new digit
 adca #0
 beq OPT25 ..repeat if less than 256

SYNTAX leax <STXLIN,PCR
 ldy #STXLSZ
 bsr PRINT1 Print "syntax error: " message
 ldx LINPTR
 bsr PRTLIN Print unknown portion of line
 clrb
 OS9 F$Exit

STXLIN fcc "SYNTAX Error: "
STXLSZ equ *-STXLIN

PRTLIN ldy #80
PRINT1 lda #1
 OS9 I$WritLn
 rts

OPT30 bsr GETHEX Get hex digit
 bcs SYNTAX ..error; report it
 pshs B Save digit
 bsr GETHEX Get next digit
 puls A
 bcc OPT35
 clrb
 exg A,B
OPT35 asla
 asla
 asla
 asla SHIFT Msb digit
 pshs A
 addb ,S+ Form digit

OPT37 lda 0,Y
 cmpa #C$SPAC
 beq OPT17
 cmpa #C$CR
 beq OPT17
 cmpa #C$COMA
 beq OPT17
 bra SYNTAX

**********
* Gethex
*
* Get Binary (Hex) Value
*
* Passed: (Y)=Text Ptr
* Returns: (B)=Hex Value (0-F)
*         (Y)=Updated
*     Or: CC=Set If Not Valid Hex
*
GETHEX ldb 0,Y Get hex character
 subb #'0
 cmpb #9
 bls GETH10 ..0-9; number converted
 cmpb #'a-'0
 blo GETH05
 subb #'a-'A
GETH05 subb #'A-'9-1
 cmpb #$F
 bhi GETH20
 cmpb #$A
 blo GETH20
GETH10 andcc #$FF-CARRY Clear carry
 leay 1,Y
 rts
GETH20 comb
 rts

**********
* Optlst
*   List The Options Currently In Use
*
OPTLST clr LINPOS
 lda #C$PDLIM
 lbsr OUTCHR

 ifge LEVEL-2
 leax OUTLIN+10,U
 lda SETPTH tmode path number
 ldb #SS.DevNm
 OS9 I$GetStt copy the device name
 else
 ldx OPTBUF+PD.TBL-PD.OPT,U Device tbl ptr
 ldx V$DESC,X Device Descriptor ptr
 ldd M$NAME,X
 leax D,X ptr to Device name
 endc

 bsr PrtName put name in output buffer
 lda #C$CR
 lbsr OUTCHR

 leax OPTTBL,PCR Get option table ptr
 leay OPTBUF,U Ptr to actual options
 clrb
OPTL10 lda B,Y Get (next) option
 bsr OPTPRT Print option
 incb
 cmpb #PDSIZE-PD.OPT End of option buffer?
 blo OPTL10 ..no; repeat
 lda #C$CR
 lbsr OUTCHR
 clrb
 OS9 F$Exit Return

**********
* Optprt
*   Print One Option'S Value
*
* Passed: (A)=Value Of Option
*         (B)=Offset Of Option In Buf
*         (X)=Option Table
* Returns: None
* Destroys: CC
*
OPTPRT pshs D,X,Y,U Save registers
 ldy -2,X Number of entries in opttbl
OPTP10 cmpb POSITN,X Right option?
 beq OPTP30 ..yes; print it
 leax NAME,X
OPTP20 lda ,X+ Skip table entry
 bpl OPTP20
 leay -1,Y Count down number of entries
 bne OPTP10 ..repeat until none more or found
 puls D,X,Y,U,PC Return

OPTP30 bsr OUTSPC
 tst TYPE,X Logical type?
 bpl OPTP40 ..no
 lda 0,S Get value in buffer
 cmpa NEGATE,X Same as natural usage?
 beq OPTP35 ..yes; just print name
 lda #C$NOT Print "not" character
 bsr OUTCHR
OPTP35 bsr PRTNAM Print option name
 puls D,X,Y,U,PC Return

PrtName pshs X
 bra PRTN10

PRTNAM pshs X
 leax NAME,X
PRTN10 lda 0,X
 anda #$7F
 bsr OUTCHR
 lda ,X+
 bpl PRTN10
 puls X,PC

OPTP40 bsr PRTNAM Print option name
 lda #C$ASGN
 bsr OUTCHR Print assignment symbol
 tst TYPE,X (decimal) numerical?
 bne OPTP50 ..no; print hex value
 ldb 0,S Get value to print
 lda #'0-1
 clr SIGNIF ..no significant digits
OPTP43 inca FORM Hundreds digit
 subb #100
 bcc OPTP43
 bsr ZERSUP Print if not zero
 lda #'9+1
OPTP46 deca FORM Tens digit
 addb #10
 bcc OPTP46
 bsr ZERSUP Print if not zero
 tfr B,A
 adda #'0 Form units digit
 bsr OUTCHR
 puls D,X,Y,U,PC Return

ZERSUP inc SIGNIF
 cmpa #'0
 bne OUTCHR
 dec SIGNIF
 bne OUTCHR
 rts

OPTP50 lda 0,S Get option value
  ANDA #$f0 strip msb value
 lsra
 lsra
 lsra
 lsra
 bsr OUT1HX Print msb nibble
 lda 0,S Get value again
 anda #$0F Strip lsb value
 bsr OUT1HX
 puls D,X,Y,U,PC

* Print Hex Value
* Passed: (A)=Hex Digit<=$0F
OUT1HX adda #'0
 cmpa #'9
 bls OUTCHR
 adda #'A-'9-1
 bra OUTCHR

OUTSPC lda #C$SPAC
OUTCHR pshs D,X,Y Save regs
 leax OUTLIN,U Get print buffer ptr
 ldb LINPOS
 sta B,X
 cmpa #C$CR
 beq OUTC05
 incb
 cmpb #MARGIN Beyond outer margin?
 blo OUTC10 ..no
 cmpa #C$SPAC Printing a space?
 bne OUTC10 ..no
 lda #C$CR Print a carriage return instead
 sta B,X
OUTC05 lbsr PRTLIN Print line
 clrb
OUTC10 stb LINPOS Save updated position
 puls D,X,Y,PC Return

**********
* Search
*   Find String In Table
*
* Passed: (X)=Search Tbl Ptr
*         (Y)=Target String Ptr
* Returns: (X)=Updated To Entry Found
*          (Y)=Updated Past String
* Error: CC=Set
*


SEARCH pshs X,Y,U Save registers
 ldu -2,X Number of table entries
SEAR10 ldy 2,S Reset target string ptr
 stx 0,S Save current tbl ptr
 leax NAME,X Ignore "skip" bytes
SEAR20 lda ,X+ Get next table char
 eora ,Y+
 anda #$FF-$20 Upper or lower case match?
 asla
 bne SEAR30 ..no
 bcc SEAR20 Continue until string end
 sty 2,S Return updated string ptr
 clra RETURN Carry clear
 puls X,Y,U,PC Return

SEAR30 leax -1,X
SEAR35 lda ,X+
 bpl SEAR35 Skip this entry
 leau -1,U Decrement tbl count
 cmpu #0 Last entry?
 bne SEAR10 ..no; repeat
 coma RETURN Carry set
 puls X,Y,U,PC Return

 emod Module Crc

SETSIZ equ *

