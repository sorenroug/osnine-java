*
* Original edition from Dragon Data OS-9 (Level I)
*
 nam   SCF

* Copyright 1980 by Motorola, Inc., and Microware Systems Corp.,
* Reproduced Under License

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than 
* the licensee is strictly prohibited!!
*


 use defsfile

 ttl   Sequential Character file manager

tylg     set   FlMgr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   SCFEnd,SCFNam,tylg,atrv,SCF,0

SCFNam     equ   *
         fcs   /SCF/
         fcb   8

SCF    equ   *
         lbra  SCCrea
         lbra  SCOpen
         lbra  SCOErr
         lbra  SCOErr
         lbra  Delete
         lbra  Seek
         lbra  SCRead
         lbra  SCWrite
         lbra  SCRdLine
         lbra  SCWrLine
         lbra  SCGStat
         lbra  SCPstat
         lbra  SCClose

 ttl Open/Close/GetStat etc.
 page
***************
* SCCrea & SCOpen
*   Process Create/Open Request

* Passed: (Y) = Path Descriptor ptr

SCCrea equ *
SCOpen ldx PD.DEV,y copy Device Table Ptr
 stx PD.TBL,y for user GetSts availability
 ldu PD.RGS,y get caller's register stack
 ldx R$X,u get pathname ptr
         pshs  y
         os9   F$PrsNam
         bcs   SCOER1
         lda   -1,y
         bmi   Open0
         leax  ,y
         os9   F$PrsNam
         bcc   SCOER1
Open0    sty   R$X,u
         puls  y
         lda   #$01
         bita  $01,y
         beq   L009C
         ldd   #$0001
 os9 F$SRqMem allocate buffers
 bcs OPNER9 ..error; return it
 stu PD.BUF,y save buffer ptr
 clrb  

         bsr   L008B

* cute message:
* "by K.Kaplan, L.Crane, R.Doggett"
         fcb   $62,$1B,$59,$6B,$65,$65,$2A,$11,$1C,$0D,$0F
         fcb   $42,$0C,$6C,$62,$6D,$31,$13,$0F,$0B,$49,$0C
         fcb   $72,$7C,$6A,$2B,$08,$00,$02,$11,$00,$79

* put cute message into our newly allocated PD buffer
L008B    puls  x                       get PC into X
         clra
L008E    eora  ,x+
         sta   ,u+
         decb
         cmpa  #$0D
         bne   L008E
L0097    sta   ,u+
         decb
         bne   L0097

L009C    ldu   PD.DEV,y     Get device table entry address
         beq   SCOErr
         ldx   $02,u
         lda   PD.PAG,y  Get lines per page
         sta   V.LINE,x
         ldx   V$DESC,u
         ldd   PD.D2P,y
         beq   Seek
         leax  d,x
         lda   $01,y
         anda  #$02
         asra
         pshs  a
         lda   $01,y
         anda  #$01
         lsla
         ora   ,s+
         os9   I$Attach
         bcs   OPNER9
         stu   $0A,y
* seek/delete routine
Seek
Delete   clra
         rts
SCOER1    puls  pc,y

SCOErr   comb
         ldb   #E$BPNam
OPNER9    rts

SCClose tst PD.CNT,y Last Image?
         bne   Close.D
         ldu   PD.FST,y
         beq   Close.B
         os9   I$Detach
Close.B    ldu   PD.BUF,y
         beq   Close.C
         ldd   #$0001
         os9   F$SRtMem
Close.C    clra
Close.D    rts

SCGStat  ldx   PD.RGS,y
         lda   R$B,x
         cmpa  #$00
         beq   SCPRTN
         pshs  a
         ldd   #D$GSTA
L00F1    ldx   $03,y
 ldu V$STAT,x static storage for driver
 ldx V$DRIV,x
 addd M$Exec,x driver's lbra table
 leax D,X
 puls a restore status function code
 jmp 0,x into the hands of a friendly driver

SCPstat  ldx   PD.RGS,y
         lda   R$B,x
         cmpa  #$00
         beq   L010E
         pshs  a
         ldd   #D$PSTA
         bra   L00F1
L010E    ldx   $04,x
         leay  PD.OPT,y
         ldb   #$1A
L0115    lda   ,x+
         sta   ,y+
         decb
         bne   L0115
SCPRTN    clrb
         rts

         comb
         ldb   #E$UnkSvc
SCRETN    rts

***************
* SCRead
*   Process Read Request
*
* Passed: (Y)=File Descriptor Static Storage

SCRead     lbsr  SCALOC
         bcs   SCRETN
         inc   $0C,y
         ldx   $06,u
         beq   SCRead3
         pshs  x
         ldx   #$0000
         ldu   $04,u
         lbsr  GetChr
         bcs   SCERR
         tsta
         beq   SCRead2
         cmpa  PD.EOF,y
         bne   L0151
SCEOFX    ldb   #E$EOF
SCERR    leas  $02,s
         pshs  b
         bsr   SCRead3
         comb
         puls  pc,b
L014C    lbsr  GetChr
         bcs   SCERR
L0151    tst   PD.EKO,y
         beq   SCRead2
         lbsr  PutDv2
SCRead2    leax  $01,x
         sta   ,u+
         beq   SCRead22
         cmpa  <$2B,y
         beq   SCRead25
SCRead22    cmpx  ,s
         bcs   L014C
SCRead25    leas  $02,s
SCRead3    ldu   $06,y
         stx   $06,u
         lbra  IODONE

 page
***************
* SCRdLine
*   Buffer a line from the Input device
*   using line-editing functions

* Passed: (Y)=File Descriptor address
*         (U)=Caller's register stack

SCRdLine   lbsr  SCALOC
         bcs   SCRETN
         ldx   $06,u
         beq   SCRead3
         tst   $06,u
         beq   SCRd10
         ldx   #$0100
SCRd10    pshs  x
         ldd   #$FFFF
         std   $0D,y
         lbsr  L0231
SCRd20    lbsr  GetChr
         lbcs  SCABT
         tsta
         beq   L01A0
         ldb   #$29
L0197    cmpa  b,y
         beq   L01C9
         incb
         cmpb  #$31
         bls   L0197
L01A0    cmpx  $0D,y
         bls   L01A6
         stx   $0D,y
L01A6    leax  $01,x
         cmpx  ,s
         bcs   SCRd40
         lda   <$33,y
         lbsr  L024F
         leax  -$01,x
         bra   SCRd20
SCRd40    lbsr  UPCASE
         sta   ,u+
         cmpa  #$0A
         bra   L01C4
         lbsr  EKOCR
         lda   #$0A
L01C4    lbsr  CHKEKO
         bra   SCRd20
L01C9    pshs  pc,x
         leax  >CTLTBL,pcr
         subb  #$29
         lslb
         leax  b,x
         stx   $02,s
         puls  x
         jsr   [,s++]
         bra   SCRd20

CTLTBL    bra   SCBSP        Process PD.BSP
         bra   SCDEL        Process PD.DEL
         bra   SCEOL        Process PD.EOR
         bra   SCEOF        Process PD.EOF
         bra   SCPRNT        Process PD.RPR
         bra   SCRPET
         puls  pc
         bra   SCDEL
         bra   SCDEL

* Process PD.EOR character
SCEOL    leas  $02,s
         sta   ,u
         lbsr  CHKEKO
         ldu   $06,y
         leax  $01,x
         stx   $06,u
         ldx   $04,u
         ldu   $08,y
L01FF    lda   ,u+
         sta   ,x+
         cmpa  <$2B,y
         bne   L01FF
         leas  $02,s
         lbra  IODONE

* Process PD.EOF
SCEOF    leas  $02,s
         leax  ,x
         lbeq  SCEOFX
         bra   L01A0

SCABT    pshs  b
         lda   #$0D
         sta   ,u
         bsr   EKOCR
         puls  b
         lbra  SCERR
L0224    bsr   SCBSP

* Process interrupt
SCDEL    leax  ,x
         beq   L0231
         tst   PD.DLO,y
         beq   L0224
         bsr   EKOCR
L0231    ldx   #$0000
         ldu   PD.BUF,y
         rts

* Process PD.BSP 
SCBSP    leax  ,x
         lbeq  L02BD
         leau  -1,u
         leax  -1,x
         tst   PD.BSO,y
         beq   L024C
         bsr   L024C
         lda   #$20
         bsr   L024F
L024C    lda   PD.BSE,y
L024F    bra   EKOBYT

EKOCR    lda   #$0D
         bra   EKOBYT

* Process PD.RPR
SCPRNT    lda   PD.EOR,y
         sta   ,u
         bsr   L0231
L025C    bsr   EKOCHR

SCRPET    cmpx  $0D,y
         beq   L0275
         leax  $01,x
         cmpx  $02,s
         bcc   L0273
         lda   ,u+
         beq   L025C
         cmpa  <$2B,y
         bne   L025C
         leau  -$01,u
L0273    leax  -$01,x
L0275    rts

***************
* GetChr
*   get one character from Input device

* Passed:  (Y)=File Descriptor address
* returns: (A)=char
*          (B)=error, cc set if error

GetDv2    pshs  u,y,x
         ldx   PD.FST,y
         ldu   PD.DEV,y
         bra   GetChr1

GetChr    pshs  u,y,x
         ldx   $03,y
         ldu   $0A,y
         beq   L028D
GetChr1    ldu   $02,u
         ldb   <$28,y
         stb   $07,u
L028D    leax  ,x
         beq   L029D
         tfr   u,d
         ldu   $02,x
         std   $09,u
         ldu   #$0003
         lbsr  IOEXEC
L029D    puls  pc,u,y,x

***************
* UPCASE
*   Convert lower-case to upper-case

* Passed: (A)=char
*         (Y)=PD
* Returns: (A)=upcased
* Destroys: none

UPCASE    tst   PD.UPC,y
         beq   L02AE
         cmpa  #$61
         bcs   L02AE
         cmpa  #$7A
         bhi   L02AE
         suba  #$20
L02AE    rts

CHKEKO    tst   PD.EKO,y       Echo turned on?
         bne   EKOCHR
         cmpa  #$0D
         bne   L02BD
         tst   PD.ALF,y
         bne   EKOCHR
L02BD    rts

EKOCHR    cmpa  #$20
         bcc   EKOBYT
         cmpa  #$0D
         bne   EKOCH2
EKOBYT    lbra  PutDv2 Print character

* Non-printable character
EKOCH2    pshs  a
         lda   #'.
         bsr   EKOBYT
         puls  pc,a

IODONE    ldx   D.Proc
         lda   ,x
         ldx   $03,y
         bsr   L02DB
         ldx   $0A,y
L02DB    beq   L02E5
         ldx   $02,x
         cmpa  $04,x
         bne   L02E5
         clr   $04,x
L02E5    rts

GetDev    pshs  x,a
         ldx   $02,x
         lda   $04,x
         beq   GetDev10
         cmpa  ,s
         beq   L0324
         pshs  a
         bsr   IODONE
         puls  a
         os9   F$IOQu
         inc   $0F,y
         ldx   D.Proc
         ldb   P$Signal,X
         puls  x,a
         beq   GetDev
         coma
         rts

GetDev10    lda   ,s
         sta   $04,x
         sta   $03,x
         lda   <$2F,y
         sta   $0D,x
         ldd   <$30,y
         std   $0B,x
         ldd   <$38,y
         std   $0F,x
         lda   <$34,y
         beq   L0324
         sta   $06,x
L0324    clra
         puls  pc,x,a

SCALOC    ldx   D.Proc
         lda   P$ID,x         Get process ID #
         clr   $0F,y
         ldx   $03,y
         bsr   GetDev
         bcs   L0341
         ldx   $0A,y
         beq   L033B
         bsr   GetDev
         bcs   L0341
L033B    tst   $0F,y
         bne   SCALOC
         clr   $0C,y
L0341    ldu   $06,y
         rts

SCWrLine  bsr   SCALOC
         bra   SCWrit00

SCWrite    bsr   SCALOC
         inc   $0C,y
SCWrit00    ldx   $04,u
         ldu   $06,u
         beq   SCWrit99
SCWrit10    lda   ,x+
         tst   $0C,y
         bne   L036C
         lbsr  UPCASE
         cmpa  #$0A
         bne   L036C
         lda   #$0D
         tst   <$25,y
         bne   L036C
         bsr   PutChr
         bcs   L0390
         lda   #$0A
L036C    bsr   PutChr
         bcs   L0390
         leau  -$01,u
         cmpu  #$0000
         bls   SCWrit99
         lda   -$01,x
         beq   SCWrit10
         cmpa  <$2B,y
         bne   SCWrit10
         tst   $0C,y
         bne   SCWrit10
L0385    ldu   $06,y
         tfr   x,d
         subd  $04,u
         std   $06,u
SCWrit99    lbra  IODONE

L0390    pshs  b,cc
         bsr   L0385
         puls  pc,b,cc

 page
***************
* PutChr
*   put character in output buffer

* Passed:  (A)=char
*          (Y)=PD address
* Destroys: B,CC
PutDv2    pshs  u,x,a
         ldx   $0A,y
         beq   PutChr9
         cmpa  #$0D
         bne   L03F8
         bra   L03D1

PutChr    pshs  u,x,a
         ldx   $03,y
         cmpa  #$0D
         bne   L03F8
         ldu   $02,x
         tst   V.PAUS,u
         bne   L03BF
         tst   $0C,y
         bne   L03D1
         tst   <$27,y
         beq   L03D1
         dec   $07,u
         bne   L03D1
         bra   L03C9
L03BF    lbsr  GetDv2
         bcs   L03C9
         cmpa  PD.PSC,y
         bne   L03BF
L03C9    lbsr  GetDv2
         cmpa  PD.PSC,y
         beq   L03C9
L03D1    ldu   $02,x
         clr   $08,u
         lda   #$0D
         bsr   WrChar
         tst   $0C,y
         bne   PutChr9

EOL         ldb   PD.NUL,y
         pshs  b
         tst   PD.ALF,y  Add linefeed?
         beq   L03ED
         lda   #$0A
EOL0    bsr   WrChar
         bcs   L03F4
L03ED    lda   #$00
         dec   ,s
         bpl   EOL0
         clra
L03F4    leas  1,s
PutChr9    puls  pc,u,x,a

L03F8    bsr   WrChar
         puls  pc,u,x,a

WrChar    ldu   #D$WRIT

IOEXEC    pshs  u,y,x,a
         ldu   V$STAT,x
         clr   V.WAKE,u
         ldx   V$DRIV,x
         ldd   M$Exec,x
         addd  $05,s
         leax  d,x
         lda   ,s+
         jsr   ,x
         puls  pc,u,y,x
         emod
SCFEnd      equ   *
