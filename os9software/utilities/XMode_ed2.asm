         nam   Xmode
         ttl   program module

 use defsfile

tylg     set   Prgrm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   SETSIZ,SETNAM,tylg,atrv,SETENT,SETMEM

SETNAM   fcs   /Xmode/
         fcb 2 edition number

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

u0000    rmb   2
NOTSET    rmb   1
LINPTR    rmb   2
LINPOS    rmb   1
SIGNIF    rmb   1
ERRCOD    rmb   1
u0008    rmb   1
OPTBUF    rmb   8
u0011    rmb   1
u0012    rmb   23
OUTLIN    rmb   80
u0079    rmb   456
SETMEM     equ   .


USELIN    fcc "Use: Xmode </device> [options]"
         fcb   $0A
         fcc "to change dev descriptor"
         fcb   $0D

SMLLIN    fcc "Descriptor too small to change."
         fcb   $0D

STXLIN    fcc "Syntax Error, couldn't process:"
         fcb   $0D
         fcb   $00

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

 fcb 23 Number of table entries (baud, XON, XOFF)

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

SETENT    equ   *
         leay  <u0079,u
         pshs  u
L0141    clr   ,-y
         cmpy  ,s
         bhi   L0141
         leas  $02,s
         bsr   SKIPSP
         cmpb  #C$PDLIM
         lbne  USAGE
         leax  $01,x
         pshs  u
         lda   #$F1
         os9   F$Link
         lbcs  ERRXIT
         stu   <u0000
         lda   <u0012,u
         leay  <u0011,u
         puls  u
         cmpa  #$00
         bne   USAGE
         pshs  x
         leax  OPTBUF,u
         ldb   ,y+
         stb   <u0008
L0175    lda   ,y+
         sta   ,x+
         subb  #$01
         bhi   L0175
         puls  x
         bsr   SKIPSP
         cmpb  #$0D
         lbeq  OPTLST
SET20    bsr   OPTSET
         bcs   SYNTAX
         cmpb  #$0D
         bne   SET20
         leax  OPTBUF,u
         ldy   <u0000
         leay  <$12,y
         ldb   <u0008
L0199    lda   ,x+
         sta   ,y+
         subb  #$01
         bhi   L0199
         ldx   <u0000
         ldd   $02,x
         subd  #$0003
         tfr   d,y
         leau  d,x
         ldd   #$FFFF
         std   1,u
         sta   0,u
         os9   F$CRC
         com   0,u
         com   1,u
         com   NOTSET,u
L01BC    ldu   <u0000
         beq   L01C3
         os9   F$UnLink
L01C3    clrb
         ldb ERRCOD
         os9   F$Exit

SKIPSP ldb ,X+ Get character
 cmpb #C$COMA Comma?
 bne SKIP20 ..no
SKIP10 ldb ,X+ Get next character
SKIP20 cmpb #C$SPAC Space?
 beq SKIP10 ..yes; skip
 leax -1,X
 clra
 rts

TSMALL    leax  >SMLLIN,pcr
         bsr   PRTLIN
SYNTAX leax >STXLIN,pcr
 bsr PRTLIN Print "syntax error: " message
 ldx LINPTR
         bra   L01EF

ERRXIT stb ERRCOD
USAGE leax USELIN,pcr
L01EF    bsr   PRTLIN
         bra   L01BC

PRTLIN ldy #80
 lda #1
 OS9 I$WritLn
 rts

OPTSET clr NOTSET
         lda   ,x
 cmpa #C$NOT Not ("-") char?
 bne OPT10 ..not
 inc NOTSET Notset=1
 leax 1,X
OPT10 stx LINPTR Save updated line ptr
         leay  >OPTTBL,pcr
         lbsr  SEARCH
         bcs   SYNTAX
 lda TYPE,Y Logical type option?
 bpl OPT20 ..no

OPT15    ldb   $01,y
OPT17    lda   $02,y
         cmpa  <u0008
         bhi   TSMALL
         eorb  <NOTSET
         leay  OPTBUF,u
         stb   a,y
         bra   SKIPSP
OPT20    tst   <NOTSET
         bne   SYNTAX
         ldb   ,x
         cmpb  #$3D
         bne   OPT15
         leax  $01,x
         tsta
         bne   OPT30
         clrb
OPT25    lda   ,x
         suba  #$30
         cmpa  #$09
         bhi   OPT37
         pshs  a
         leax  $01,x
         lda   #$0A
         mul
         addb  ,s+
         adca  #$00
         beq   OPT25
         bra   SYNTAX

OPT30    bsr   GETHEX
         bcs   SYNTAX
         pshs  b
         bsr   GETHEX
         puls  a
         bcc   OPT35
         clrb
         exg   a,b
OPT35    lsla
         lsla
         lsla
         lsla
         pshs  a
         addb  ,s+

OPT37    lda   ,x  !uses x
         cmpa  #$20
         beq   OPT17
         cmpa  #$0D
         beq   OPT17
         cmpa  #$2C
         beq   OPT17
         lbra  SYNTAX

GETHEX    ldb   0,x
         subb  #$30
         cmpb  #$09
         bls   GETH10
         cmpb  #$31
         bcs   GETH05
         subb  #$20
GETH05    subb  #$07
         cmpb  #$0F
         bhi   GETH20
         cmpb  #$0A
         bcs   GETH20
GETH10    andcc #$FE
         leax  $01,x
         rts
GETH20    comb
         rts

OPTLST    clr   <LINPOS
         leax  >OPTTBL,pcr
         leay  OPTBUF,u
         clrb
OPTL10    lda   b,y
         bsr   OPTPRT
         incb
         cmpb  #$20
         bcs   OPTL10
         lda   #$0D
         lbsr  OUTCHR
         lbra  L01BC

OPTPRT    pshs  u,y,x,b,a
         ldy   -$02,x
OPTP10    cmpb  $02,x
         beq   OPTP30
         leax  $04,x
OPTP20    lda   ,x+
         bpl   OPTP20
         leay  -$01,y
         bne   OPTP10
         puls  pc,u,y,x,b,a

OPTP30    bsr   OUTSPC
         tst   ,x
         bpl   OPTP40
         lda   ,s
         cmpa  $03,x
         beq   OPTP35
         lda   #$2D
         bsr   OUTCHR
OPTP35    bsr   PRTNAM
         puls  pc,u,y,x,b,a

PrtName  pshs  x
         bra   PRTN10

PRTNAM    pshs  x
         leax  $04,x
PRTN10    lda   ,x
         anda  #$7F
         bsr   OUTCHR
         lda   ,x+
         bpl   PRTN10
         puls  pc,x

OPTP40    bsr   PRTNAM
         lda   #$3D
         bsr   OUTCHR
         tst   ,x
         bne   OPTP50
         ldb   ,s
         lda   #$2F
         clr   <SIGNIF
OPTP43    inca
         subb  #$64
         bcc   OPTP43
         bsr   ZERSUP
         lda   #$3A
OPTP46    deca
         addb  #$0A
         bcc   OPTP46
         bsr   ZERSUP
         tfr   b,a
         adda  #$30
         bsr   OUTCHR
         puls  pc,u,y,x,b,a

ZERSUP    inc   <SIGNIF
         cmpa  #$30
         bne   OUTCHR
         dec   <SIGNIF
         bne   OUTCHR
         rts

OPTP50    lda   ,s
         anda  #$F0
         lsra
         lsra
         lsra
         lsra
         bsr   OUT1HX
         lda   ,s
         anda  #$0F
         bsr   OUT1HX
         puls  pc,u,y,x,b,a

OUT1HX    adda  #$30
         cmpa  #$39
         bls   OUTCHR
         adda  #$07
         bra   OUTCHR

OUTSPC    lda   #$20
OUTCHR    pshs  y,x,b,a
         leax  <OUTLIN,u
         ldb   <LINPOS
         sta   b,x
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
         ldu   -2,y   ! uses y
SEAR10    ldx   ,s
         sty   $02,s
         leay  $04,y
SEAR20    lda   ,y+
         eora  ,x+
 anda #$FF-$20 Upper or lower case match?
 asla
 bne SEAR30 ..no
 bcc SEAR20 Continue until string end
         stx   ,s
 clra RETURN Carry clear
 puls X,Y,U,PC Return

SEAR30    leay  -$01,y   * Uses Y
SEAR35    lda   ,y+
         bpl   SEAR35
 leau -1,U Decrement tbl count
 cmpu #0 Last entry?
 bhi SEAR10 ..no; repeat
 coma RETURN Carry set
 puls X,Y,U,PC Return

 emod Module Crc

SETSIZ equ *
