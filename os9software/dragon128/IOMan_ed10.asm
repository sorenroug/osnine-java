         nam   Input/Output Manager
         ttl   Module Header

* Copyright 1980 by Motorola, Inc., and Microware Systems Corp.,
* Copyright 1982 by Microware Systems Corporation
* Reproduced Under License

* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!

* This is a disassembly of the IOMan edition 10 distributed with OS-9 for Dragon 128
* OS-9 Level 2. It contains modifications in some allocation routines.

***************
* I/O Manager

 mod IOEnd,IOName,Systm+Objct,ReEnt+1,IOINIT,0
IOName fcs /IOMan/  module name

*******************************************
*
*    Edition History

*  10      83/11/01 add error path/module messages, improved error printing
*                                 Vivaway Ltd.             PSD

 fcb 10 edition number

 use   defsfile

 ttl Initialization
 page
**********
* Ioinit
* Entry Point For Start-Up Initialization
*
IOINIT ldx D.Init
         lda   PollCnt,x   get number of entries in table
         ldb   #POLSIZ
         mul
         pshs  b,a
         lda DEVCNT,X Get device table size
         ldb   #DEVSIZ
         mul
         addd  0,s
         addd  #$00FF
         clrb
         os9   F$SRqMem
         bcs   Crash
         leax  ,u
IOINI1    clr   ,x+
         subd  #$0001
         bhi   IOINI1
         stu   D.PolTbl
         ldd   ,s++
         leax  d,u
         stx   D.DevTbl
         ldx   D.PthDBT
         os9   F$All64
         bcs   Crash
         stx   D.PthDBT
         os9   F$Ret64
         leax  >IRQPoll,pcr
         stx   D.Poll
         leay  <SVCTBL,pcr
         os9   F$SSvc
         rts

Crash    jmp   [>$FFEE]

******************************
*
* System service routine vector table
*
system set $80 system only calls
user set $7F system or user calls

SVCTBL equ *
 fcb $FF&user
         fdb   USERIO-*-2
         fcb   F$Load&user
         fdb   FLoad-*-2
         fcb   I$Detach
         fdb   SysLoad-*-2
         fcb   F$PErr
         fdb   PrtErr-*-2
 ifne EXTERR
         fcb F$InsErr&user
         fdb  InsErr-*-2
 endc
         fcb   F$IOQu+$80
         fdb   IOQueu-*-2
         fcb $FF
         fdb   SysIO-*-2
         fcb   F$IRQ+$80
         fdb   FIRQ-*-2
         fcb F$IODel+$80
         fdb   FIODel-*-2
         fcb $80

******************************
*
* Check device status service call?
*
* Entry: U = Callers register stack pointer
*
FIODel   ldx   R$X,u
         ldu   D.Init
         ldb   DevCnt,u      get device count
         ldu   D.DevTbl
L007E    ldy   V$DESC,u      descriptor exists?
         beq   L008F
         cmpx  V$DESC,u      device match?
         beq   L0096
         cmpx  V$DRIV,u      driver match?
         beq   L0096
         cmpx  V$FMGR,u      fmgr match?
         beq   L0096
L008F    leau  DEVSIZ,u      move to next dev entry
         decb
         bne   L007E
         clrb
         rts

L0096    comb
         ldb   #E$ModBsy     submit error
         rts

PortBlk    lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         anda  #DAT.BlMx/256 clear untranslated bits
         cmpb  #IOBlock
         rts

UTABLE equ *
TBLBGN set UTABLE
 fdb ATTACH-TBLBGN
 fdb DETACH-TBLBGN
 fdb UDUPE-TBLBGN
 fdb UCREAT-TBLBGN
 fdb UOPEN-TBLBGN
 fdb UMDIR-TBLBGN
 fdb UCDIR-TBLBGN
 fdb UDELET-TBLBGN
 fdb USEEK-TBLBGN
 fdb UREAD-TBLBGN
 fdb UWRITE-TBLBGN
 fdb URDLN-TBLBGN
 fdb UWRLN-TBLBGN
 fdb UGSTT-TBLBGN
 fdb USSTT-TBLBGN
 fdb UCLOSE-TBLBGN
 fdb UDELETX-TBLBGN

STABLE equ *
TBLBGN set STABLE
 fdb ATTACH-TBLBGN Attach (x)=device, (a)=mode
 fdb   DETACH-TBLBGN
 fdb   SDUPE-TBLBGN

* File Manager Name Functions
*          (X)=Pathname Ptr
*          (A)=Mode
 fdb   SCREAT-TBLBGN
 fdb   SOPEN-TBLBGN
 fdb   SMDIR-TBLBGN
 fdb   SCDIR-TBLBGN
 fdb   SDELET-TBLBGN

* File Manager Path Functions
*         (A)=Path Number
 fdb   SSEEK-TBLBGN
 fdb   SREAD-TBLBGN
 fdb   SWRITE-TBLBGN
 fdb   SRDLN-TBLBGN
 fdb   SWRLN-TBLBGN
 fdb   SGSTT-TBLBGN
 fdb   SSSTT-TBLBGN
 fdb   SCLOSE-TBLBGN
 fdb   SDELETX-TBLBGN

**********
* I/O Dispatcher
*
USERIO leax <UTABLE,pcr
 bra SYSIO1

SysIO leax <STABLE,pcr
SYSIO1 cmpb #I$DeletX
         bhi   SYSIO2
         pshs  b
         lslb
         ldd   b,x
         leax  d,x
         puls  b
         jmp   ,x

SYSIO2    comb
         ldb   #E$UnkSvc
         rts
 page
**********
* Attach I/O Device
*
* Passed: (A)=R/W/Exec Mode
*         (X)=Device Name Ptr
* Returns: (U)=Dev Tbl Ptr
*
 org 0
 rmb DEVSIZ
S.MODE rmb 1
S.BUSY rmb 1
S.PORT rmb 3
S.DEVT rmb 2
 ifgt LEVEL-1
S.LclAdr rmb 2
S.Block rmb 2
S.Proc rmb 2
 endc
S.STAK rmb 2
S.TMPS equ .

ATTACH ldb #S.TMPS-1
ATTA02    clr   ,-s
         decb
         bpl   ATTA02
         stu   S.STAK,s
         lda   $01,u
         sta   $09,s
         ldx   D.Proc
         stx   <$14,s
         leay  P$DATImg,x    point to DAT img of curr proc
         ldx   D.SysPRC
         stx   D.Proc
         ldx   R$X,u        get caller's X
         lda   #Devic+0        link to device desc
         os9   F$SLink
         bcs   ATTERR0
         stu   $04,s
         ldy   <$16,s
         stx   R$X,y         save updated X
         lda   $0E,u
         sta   $0B,s
         ldd   $0F,u
         std   $0C,s
         ldd   $0B,u
         leax  d,u
         lda   #Drivr+0        driver
         os9   F$Link
         bcs   ATTERR0
         stu   ,s
         ldu   $04,s
         ldd   $09,u
         leax  d,u
         lda   #FLMGR
         os9   F$Link
ATTERR0
   ldx   <$14,s
         stx   D.Proc
         bcc   ATTA15

ATTERR    stb   <$17,s
         leau  ,s
         os9   I$Detach
         leas  <$17,s
         comb
         puls  pc,b

*
* Device Moudle Components Are All Located
* Search Device Tbl For Device
*
ATTA15    stu   $06,s
         ldx   D.Init
         ldb   DevCnt,x       get device entry count
         lda   DevCnt,x       get device entry count
         ldu   D.DevTbl
L0170    ldx   V$DESC,u       get dev desc ptr
         beq   ATTA30
         cmpx  $04,s
         bne   L018B
         ldx   $02,u
         bne   L0189
         pshs  a
         lda   $08,u
         beq   L0185
         os9   F$IOQu
L0185    puls  a
         bra   L0170
L0189    stu   $0E,s
L018B    ldx   V$DESC,u       get dev desc ptr
         ldy   $0F,x
         cmpy  $0C,s
         bne   ATTA30
         ldy   $0E,x
         cmpy  $0B,s
         bne   ATTA30
         ldx   ,u
         cmpx  ,s
         bne   ATTA30
         ldx   $02,u
         stx   $02,s
         tst   $08,u
         beq   ATTA30
         sta   $0A,s
ATTA30    leau  DEVSIZ,u      advance to the next device entry
         decb
         bne   L0170
         ldu   $0E,s
         lbne  L025E
         ldu   D.DevTbl
L01BA    ldx   V$DESC,u       get desc ptr
         beq   L01CB
         leau  DEVSIZ,u     move to next dev table entry
         deca
         bne   L01BA
         ldb   #E$DevOvf      dev table overflow
         bra   ATTERR

ERMODE    ldb   #E$BMode
         bra   ATTERR

L01CB    ldx   $02,s
         lbne  ATTA60
         stu   $0E,s
         ldx   ,s
         ldd   $0B,x
         addd  #$00FF
         clrb
         os9   F$SRqMem
         lbcs  ATTERR
         stu   $02,s
L01E4    clr   ,u+
         subd  #$0001
         bhi   L01E4
         ldd   $0B,s
         lbsr  PortBlk
         std   <$12,s
         ldu   #$0000
         tfr   u,y
         stu   <$10,s
         ldx   D.SysDAT
IOMap20    ldd   ,x++
 ifne DAT.WrEn+DAT.WrPr
 endc
         cmpd  <$12,s
         beq   IOMap40
         cmpd  #$00C0
         bne   IOMap30
         sty   <$10,s
         leau  -$02,x
IOMap30 leay DAT.BLSz,y
         bne   IOMap20
         ldb   #$CF
         cmpu  #$0000
         lbeq  ATTERR
         ldd   <$12,s
 ifne DAT.WrEn
 endc
         std   ,u
         ldx   D.SysPRC
         lda   P$State,x
         ora   #ImgChg
         sta   P$State,x
         os9   F$ID
         ldy   <$10,s
IOMap40    sty   <$10,s
         ldd   $0C,s
         anda  #^DAT.Addr
         addd  <$10,s
         ldu   $02,s
         clr   ,u
         std   $01,u
         ldy   $04,s
         ldx   ,s
         ldd   $09,x
         jsr   d,x
         lbcs  ATTERR
         ldu   $0E,s
ATTA60    ldb   #$08
L0257    lda   b,s
         sta   b,u
         decb
         bpl   L0257
L025E    ldx   $04,u
         ldb   $07,x
         lda   $09,s
         anda  $0D,x
         ldx   ,u
         anda  $0D,x
         cmpa  $09,s
         lbne  ERMODE
         inc   $08,u
         bne   L0276
         dec   $08,u
L0276    ldx   <$16,s
         stu   $08,x
         leas  <$18,s
         clrb
         rts
 page
**********
* Process Detach Request
*
DETACH  ldu   R$U,u
         ldx   R$X,u
         lda   #$FF
         cmpa  $08,u
         lbeq  L0349
         dec   $08,u
         lbne  DETACH80

         ldx   D.Init
         ldb   DevCnt,x      get device count
         pshs  u,b
         ldx   $02,u
         clr   $02,u
         clr   $03,u
         ldy   D.DevTbl
L02A1    cmpx  $02,y
         beq   L0321
         leay  DEVSIZ,y
         decb
         bne   L02A1

         ldy   D.Proc
         ldb   ,y
         stb   $08,u
         ldy   $04,u
         ldu   ,u
         exg   x,u
         ldd   $09,x
         leax  d,x
         pshs  u
         jsr   $0F,x
         puls  u
         ldx   $01,s
         ldx   ,x
         ldd   $0B,x
         addd  #$00FF
         clrb
         os9   F$SRtMem

* Determine if this was the only active I/O port in it's
* memory block, and release the block if so
         ldx   $01,s
         ldx   $04,x
         ldd   $0E,x
         beq   L0321
         lbsr  PortBlk
         beq   L0321
         tfr   d,x
         ldb   ,s
         pshs  x,b
         ldu   D.DevTbl
UnMap10    cmpu  $04,s
         beq   UnMap20
         ldx   $04,u
         beq   UnMap20
         ldd   $0E,x
         beq   UnMap20
         lbsr  PortBlk
         cmpd  $01,s
         beq   L031F
UnMap20    leau  $09,u
         dec   ,s
         bne   UnMap10
         ldx   D.SysPRC
         ldu   D.SysDAT
         ldy   #DAT.BlCt
L0307    ldd   ,u++
         cmpd  $01,s
         beq   UnMap30
         leay  -$01,y
         bne   L0307
         bra   L031F
UnMap30 ldd #DAT.Free
         std   -$02,u
         lda   $0C,x
         ora   #$10
         sta   $0C,x
L031F    leas  $03,s
L0321    puls  u,b
         ldx   $04,u
         clr   $04,u
         clr   $05,u
         clr   $08,u
DETACH80
 ifgt LEVEL-1
 ldd   D.Proc
         pshs  b,a
         ldd   D.SysPRC
         std   D.Proc
 endc
         ldy   ,u
         ldu   $06,u
         os9   F$UnLink
         leau  ,y
         os9   F$UnLink
         leau  ,x
         os9   F$UnLink
         puls  b,a
         std   D.Proc
L0349    lbsr  UnQueue
         clrb
         rts

UDUPE    bsr   FNDPTH
         bcs   SDUP90
         pshs  x,a
         lda   $01,u
         lda   a,x
         bsr   SDUP10
         bcs   L0363
         puls  x,b
         stb   $01,u
         sta   b,x
         rts

L0363    puls  pc,x,a

SDUPE    lda   $01,u
SDUP10    lbsr  FPATH
         bcs   SDUP90
         inc   $02,y
SDUP90    rts

 ttl I/O Name function calls
 page
FNDPTH ldx D.Proc
         leax  <$30,x
         clra
L0375    tst   a,x
         beq   L0382
         inca
         cmpa  #$10
         bcs   L0375
         comb
         ldb   #E$PthFul
         rts
L0382    andcc #$FE
         rts

UCREAT equ *
UOPEN bsr   FNDPTH
         bcs   UOPEN9
         pshs  u,x,a
         bsr   SOPEN
         puls  u,x,a
         bcs   UOPEN9
         ldb   $01,u
         stb   a,x
         sta   $01,u
UOPEN9    rts

SCREAT equ *
SOPEN pshs B
         ldb   $01,u
         bsr   PDINIT
         bcs   SOPENX
         puls  b
         lbsr  FMEXEC
         bcs   L03BB
         lda   ,y
         sta   $01,u
         rts

SOPENX    puls  pc,a

**********
* Makdir
*   Process Makdir Request
*
UMDIR equ *
SMDIR  pshs  b
         ldb   #$82
SMDIR1    bsr   PDINIT
         bcs   SOPENX
         puls  b
         lbsr  FMEXEC

L03BB    pshs  b,cc
         ldu   $03,y
         os9   I$Detach
         lda   ,y
         ldx   D.PthDBT
         os9   F$Ret64
         puls  pc,b,cc

UCDIR equ *
SCDIR  pshs  b
         ldb   $01,u
         orb   #$80
         bsr   PDINIT
         bcs   SOPENX
         puls  b
         lbsr  FMEXEC
         bcs   L03BB
         ldu   D.Proc
         ldb   $01,y
         bitb  #$1B
         beq   SCDIR2
         ldx   $03,y
         stx   <$20,u
         inc   $08,x
         bne   SCDIR2
         dec   $08,x

SCDIR2 bitb  #$24
         beq   L03FE
         ldx   $03,y
         stx   <$26,u
         inc   $08,x
         bne   L03FE
         dec   $08,x
L03FE    clrb
         bra   L03BB

UDELET equ *
SDELET  pshs  b
         ldb   #$02
         bra   SMDIR1

UDELETX equ *
SDELETX ldb #I$Delete
         pshs  b
         ldb   R$A,u
         bra   SMDIR1

**********
* Pdinit
*
PDINIT
 ldx   D.Proc
         pshs  u,x
         ldx   D.PthDBT
         os9   F$All64
         bcs   PDIN90
         inc   $02,y
         stb   $01,y
         ldx   D.Proc
         ldb   $06,x
         ldx   $04,u
L0424    os9   F$LDABX
         leax  $01,x
         cmpa  #$20
         beq   L0424
         leax  -$01,x
         stx   $04,u
         ldb   $01,y
         cmpa  #$2F
         beq   L0451
         ldx   D.Proc
         bitb  #$24
         beq   L0442
         ldx   <$26,x
         bra   PDIN30
L0442    ldx   <$20,x
PDIN30    beq   ERRBPN
         ldd   D.SysPRC
         std   D.Proc
         ldx   $04,x
         ldd   $04,x
         leax  d,x
L0451    pshs  y
         os9   F$PrsNam
         puls  y
         bcs   ERRBPN
         lda   $01,y
         os9   I$Attach
         stu   $03,y
         bcs   L0482
         ldx   $04,u
         leax  <$11,x
         ldb   ,x+
         leau  <$20,y
         cmpb  #$20
         bls   L0477
         ldb   #$1F
L0473    lda   ,x+
         sta   ,u+
L0477    decb
         bpl   L0473
         clrb
PDIN90    puls  u,x
         stx   D.Proc
         rts
ERRBPN    ldb   #E$BPNam
L0482    pshs  b
         lda   ,y
         ldx   D.PthDBT
         os9   F$Ret64
         puls  b
         coma
         bra   PDIN90

 ttl I/O Path function calls
 page
**********
* Chkpth
*   Validate User Path, And Map Into System Path
*
* Passed: (U)=User Regs, (R$A)=User Path#
* Returns: (A)=System Path#
*          (X)=User Path Table Ptr
*
CHKPTH  lda   $01,u
         cmpa  #$10
         bcc   CHKERR
         ldx   D.Proc
         leax  <$30,x
         andcc #$FE
         lda   a,x
         bne   L04A4
CHKERR    comb
         ldb   #E$BPNum
L04A4    rts


**********
* Seek
*   Position File
*
USEEK   bsr   CHKPTH       get user path #
         bcc   SSEEK1
         rts

SSEEK   lda   R$A,u
SSEEK1    bsr   FPATH
         lbcc  FMEXEC
         rts

**********
* Read
* Process Read Or Readln Request
*
UREAD equ *
URDLN   bsr   CHKPTH       get user path #
         bcc   SRDLN1
         rts

SREAD equ *
SRDLN   lda   R$A,u       get user path
SRDLN1    pshs  b
         ldb   #$05
L04BE    bsr   FPATH
         bcs   SRDLNX
         bitb  PD.MOD,y    test bits against mode in path desc
         beq   BADPTH
*
*    check limits of read/write buffer
*
         ldd   R$Y,u       else get count from user
         beq   L04F6
         addd  R$X,u       else update buffer pointer with size
         bcs   BADBUF
         subd  #1
         lsra
         lsra
         lsra
         lsra
         ldb   R$X,u       get address of buffer to hold read data
         lsrb
         lsrb
         lsrb
         lsrb
         pshs  b
         suba  ,s+
         ldx   D.Proc
         leax P$DATImg,x
         aslb
         leax  b,x
SRDLN.c    pshs  a
         ldd   ,x++
         cmpd  #DAT.Free
         puls  a
         beq   BADBUF
         deca
         bpl   SRDLN.c
L04F6    puls  b
         lbra  FMEXEC

BADBUF    ldb   #$F4
         lda   ,s
         bita  #$02
         beq   SRDLNX
         ldb   #E$Write
         bra   SRDLNX

BADPTH    ldb   #E$BPNam
SRDLNX    com   ,s+
         rts

UWRITE equ *
UWRLN  bsr   CHKPTH
         bcc   SWRLN1
         rts

SWRITE equ *
SWRLN  lda   R$A,u
SWRLN1    pshs  b
         ldb   #$02
         bra   L04BE

FPATH    pshs  x
         ldx   D.PthDBT
         os9   F$Find64
         puls  x
         lbcs  CHKERR
L0526    rts

UGSTT lbsr  CHKPTH
         ldx   D.Proc
         bcc   SGSTT10
         rts

SGSTT lda   R$A,u

         ldx   D.SysPRC
SGSTT10    pshs  x,b,a
         lda   R$B,u
         sta   $01,s
         puls  a
         lbsr  SSEEK1
         puls  x,a
         pshs  u,y,cc
         tsta
         beq   SGSTT20
         cmpa  #$0E
         beq   SGSTT30
         puls  pc,u,y,cc
SGSTT20    lda   D.SysTsk
         ldb   P$Task,x
         leax  <PD.OPT,y
SGSTT25    ldy   #$0020
         ldu   $04,u
         os9   F$Move
         leas  $01,s
         puls  pc,u,y

SGSTT30  lda   D.SysTsk
         ldb   $06,x
         pshs  b,a
         ldx   $03,y
         ldx   $04,x
         ldd   $04,x
         leax  d,x
         puls  b,a
         bra   SGSTT25

***********
* PSTT
USSTT equ USEEK
SSSTT equ SSEEK

UCLOSE  lbsr  CHKPTH       get user path #
         bcs   L0526
         pshs  b
         ldb   $01,u
         clr   b,x
         puls  b
         bra   L0582

SCLOSE  lda   R$A,u
L0582    bsr   FPATH
         bcs   L0526
         dec   $02,y
         tst   $05,y
         bne   L058E
         bsr   FMEXEC
L058E    tst   $02,y
         bne   L0526
         lbra  L03BB
L0595    os9   F$IOQu
         comb
         ldb   <$19,x
         bne   L05A9
L059E    ldx   D.Proc
         ldb   ,x
         clra
         lda   $05,y
         bne   L0595
         stb   $05,y
L05A9    rts

FMEXEC pshs  u,y,x,b
         bsr   L059E
         bcc   L05B4
         leas  $01,s
         bra   L05C7
L05B4    stu   $06,y
         ldx   $03,y
         ldx   $06,x
         ldd   $09,x
         leax  d,x
         ldb   ,s+
         subb  #$83
         lda   #$03
         mul
         jsr   d,x
L05C7    pshs  b,cc
         bsr   UnQueue
         ldy   $04,s
         ldx   D.Proc
         lda   ,x
         cmpa  $05,y
         bne   L05D8
         clr   $05,y
L05D8    puls  pc,u,y,x,b,cc

UnQueue    pshs  y,x
         ldy   D.Proc
         bra   L05EE
L05E1    clr   P$IOQN,y
         ldb   #S$Wake     get wake signal
         os9   F$Send
         os9   F$GProcP
         clr   P$IOQP,y
L05EE    lda   P$IOQN,y
         bne   L05E1
         puls  pc,y,x

FIRQ     ldx   R$X,u     get ptr to IRQ packet
         ldb   ,x        B = flip byte
         ldx   $01,x     X = mask/priority
         clra
         pshs  cc
         pshs  x,b
         ldx   D.Init
         ldb   PollCnt,x   get number of entries in table
         ldx   D.PolTbl
         ldy   $04,u
         beq   L0646
         tst   $01,s
         beq   L0671
         decb
         lda   #POLSIZ
         mul
         leax  d,x
         lda   $03,x
         bne   L0671
         orcc  #$50
IOPOL1    ldb   $02,s
         cmpb  -(POLSIZ-Q$PRTY),x compare with prev entry's prior
         bcs   L062E
         ldb   #POLSIZ
L0623    lda   ,-x
         sta   POLSIZ,x
         decb
         bne   L0623
         cmpx  D.PolTbl
         bhi   IOPOL1
L062E    ldd   $01,u
         std   ,x
         ldd   ,s++
         sta   $02,x
         stb   $03,x
         ldb   ,s+
         stb   $08,x
         ldd   $06,u
         std   $04,x
         ldd   $08,u
         std   $06,x
         puls  pc,cc
L0646    leas  $04,s
         ldy   $08,u
L064B    cmpy  $06,x
         beq   IOPOL6
         leax  POLSIZ,x
         decb
         bne   L064B
         clrb
         rts

IOPOL6    pshs  b,cc
         orcc  #$50
         bra   L0664
L065D    ldb   $09,x
         stb   ,x+
         deca
         bne   L065D
L0664    lda   #$09
         dec   $01,s
         bne   L065D
L066A    clr   ,x+
         deca
         bne   L066A
         puls  pc,a,cc

L0671    leas  $04,s
L0673    comb
         ldb   #E$Poll
         rts

***************************
*
* Device polling routine
*
* Entry: None
*

IRQPoll  ldy   D.PolTbl
         ldx   D.Init
         ldb   PollCnt,x   get number of entries in table
         bra   L0685
L0680    leay  POLSIZ,y    else move to next entry
         decb
         beq   L0673
L0685    lda   [Q$POLL,y]  get device's status register
         eora  Q$FLIP,y    flip it
         bita  Q$MASK,y    origin of IRQ?
         beq   L0680
         ldu   $06,y
         pshs  y,b
         jsr   [Q$SERV,y]  execute service routine
         puls  y,b
         bcs   L0680
         rts

FLoad    pshs  u
         ldx   R$X,u     get pathname to load
         bsr   LModule
         bcs   LoadXit
         puls  y
L06A3    pshs  y
         stx   R$X,y       save updated pathlist
         ldy   ,u          get DAT image pointer
         ldx   $04,u       get offset within DAT image
         ldd   #$0006
         os9   F$LDDDXY
         ldx   ,s
         std   $01,x
         leax  ,u
         os9   F$ELink
         bcs   LoadXit
         ldx   ,s
         sty   $06,x
         stu   $08,x
LoadXit    puls  pc,u

SysLoad pshs  u          save off regs ptr
         ldx   R$X,u      get ptr to device name
         bsr   LModule
         bcs   L06DE
         puls  y
         ldd   D.Proc
         pshs  y,b,a
         ldd   $08,y
         std   D.Proc
         bsr   L06A3
         puls  x
         stx   D.Proc
L06DE    puls  pc,u

* Load module from file
* Entry: X = pathlist to file containing module(s)
* A fake process descriptor is created, then the file is
* opened and validated into memory.

LModule  os9   F$AllPrc
         bcc   L06E6
         rts
L06E6    leay  ,u
         ldu   #0
         pshs  u,y,x,b,a
         leas  <-$11,s
         clr   $07,s
         stu   ,s
         stu   $02,s
         ldu   D.Proc
         stu   $04,s
         clr   $06,s
         lda   P$Prior,u  get priority
         sta   P$Prior,y  save
         lda   #EXEC.     from exec dir
         os9   I$Open
         bcs   L077E
         sta   $06,s
         stx   <$13,s
         ldx   <$15,s
         os9   F$AllTsk
         bcs   L077E
         stx   D.Proc
L0716    ldd   #$0009
         ldx   $02,s
         lbsr  GetModul
         bcs   L077E
         ldu   <$15,s
         lda   $06,u
         ldb   D.SysTsk
         leau  $08,s
         pshs  x
         ldx   $04,s
         os9   F$Move
         puls  x
         ldd   M$ID,u
         cmpd  #M$ID12
         bne   L077C
         ldd   M$Size,u
         subd  #M$IDSize
         lbsr  GetModul
         bcs   L077E
         ldy   <$15,s     get proc desc ptr
         leay  <P$DATImg,y
         tfr   y,d
         ldx   $02,s
         os9   F$VModul
         bcc   L075A
         cmpb  #E$KwnMod
         beq   L0760
         bra   L077E
L075A    ldd   $02,s
         addd  $0A,s
         std   $02,s
L0760    ldd   <$17,s
         bne   L0716
         ldd   MD$MPtr,u
         std   <$11,s
         ldx   ,u
         ldd   ,x
         std   <$17,s
         ldd   $06,u
         addd  #$0001
         beq   L0716
         std   $06,u
         bra   L0716
L077C    ldb   #E$BMID
L077E    stb   $07,s
         ldd   $04,s
         beq   L0786
         std   D.Proc
L0786    lda   $06,s
         beq   LMod.O
         os9   I$Close
LMod.O    ldd   $02,s
         addd #DAT.BlSz-1 Round up
         lsra
         lsra
         lsra
         lsra
         sta   $02,s
         ldb   ,s
         beq   LMod.Q
         lsrb
         lsrb
         lsrb
         lsrb
         subb  $02,s
         beq   LMod.Q
         ldx   <$15,s
         leax  <P$DATImg,x
         lsla
         leax  a,x
         clra
         tfr   d,y
         ldu   D.BlkMap
L07B2    ldd   ,x++
         clr   d,u
         leay  -$01,y
         bne   L07B2
LMod.Q    ldx   <$15,s
         lda   P$ID,x
         os9   F$DelPrc
         ldd   <$17,s
         bne   L07CF
         ldb   $07,s
         stb   <$12,s
         comb
         bra   LModXit
L07CF    ldu   D.ModDir
         ldx   <$11,s
         ldd   <$17,s
         leau  -MD$ESize,u
L07D9    leau  MD$ESize,u
         cmpu  D.ModEnd
         bcs   L07E8
         comb
         ldb   #E$MNF
         stb   <$12,s
         bra   LModXit
L07E8    cmpx  MD$MPtr,u
         bne   L07D9
         cmpd  [MD$MPDAT,u]
         bne   L07D9
         ldd   MD$Link,u
         beq   L07FA
         subd  #1
         std   MD$Link,u
L07FA    stu   <$17,s
         clrb
LModXit    leas  <$11,s
         puls  pc,u,y,x,b,a

*****************************************************
*
*            GetModul routine
*
*  Input: D = Size of new section
*         X = Present module size in RAM
*
* Output: X = New module size in RAM
*
GetModul    pshs  y,x,b,a
         addd  $02,s
         std 4,s
         cmpd  $08,s is there enough RAM?
 ifeq CPUType-DRG128
 lbls GetM.R yes. skip mem request
 else
 bls GetM.R yes. skip mem request
 endc
 addd #DAT.BlSz-1 round to next block
         lsra
         lsra
         lsra
         lsra
         cmpa  #DAT.BlCt-1
         bhi   GetM.Err
         ldb   $08,s
         lsrb
         lsrb
         lsrb
         lsrb
         pshs  b
         exg   b,a
         subb  ,s+
         lsla
         ldu   <$1D,s
         leau  <P$DATImg,u
         leau  a,u
         clra
         tfr   d,x
         ldy   D.BlkMap
         clra
TESTM set 0
 ifeq CPUTYPE-DRG128
 ldb #DAT.GBlk start above graphics blocks
 leay  b,y
 else
 clrb
 endc
GetM.B    tst   ,y+
         beq   GetM.D
GetM.C    addd  #1
         cmpy  D.BlkMap+2
         bne   GetM.B
 ifeq CPUTYPE-DRG128
         ldy   D.BlkMap
         clra
GetM.F    pshs  y
         leay  BlkTrans,pcr
         ldb   a,y
         puls  y
         tst   b,y
         beq   GetM.H
GetM.G    inca
         cmpa  #DAT.GBlk
         bcs   GetM.F
 endc

GetM.Err    comb
 ldb #E$MemFul
         bra   GetM.X

 ifeq CPUTYPE-DRG128+TESTM
GetM.H inc b,y
         clr   ,u+
         stb   ,u+
         pshs  a
         ldd   $09,s
         addd  #DAT.BlSz
         std   $09,s
         puls  a
         leax  -1,x
         bne   GetM.G
         bra   GetM.I
 endc
GetM.D    inc   -1,y
         std   ,u++
         pshs  b,a
         ldd   $0A,s
         addd  #DAT.BlSz
         std   $0A,s
         puls  b,a
         leax  -1,x
         bne   GetM.C
GetM.I    ldx   <$1D,s
         os9   F$SetTsk
         bcs   GetM.X
GetM.R    lda   $0E,s
         ldx   $02,s
         ldy   ,s
         os9   I$Read
GetM.X leas 4,s return scratch
 puls pc,x done

 ifeq CPUTYPE-DRG128
BlkTrans fcb $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
      fcb $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F
 endc

*****
*
*  Print Error Routine
*

 ifne EXTERR
**********************************************
*
*       Subroutine PrtErr
*
*  Print error message
*
ERRMSGLN equ 80
PrtBufSz equ 80
 org 0
PrtPath rmb 1
PrtNum rmb 1
PrtProc rmb 2
PrtMod rmb 2
PrtTbl rmb 2
PrtEPath rmb 1
PrtPFlag rmb 1
PrtFlag rmb 1
PrtBuf rmb PrtBufSz
PrtMem equ .

PrtErr ldb   R$B,u
         beq   PrtErr90
         ldx   D.Proc
         lda   <P$PATH+2,x  get stderr path
         beq   PrtErr90  return if not there
         pshs  u
         leas  -PrtMem,s
         leau  ,s
         std   0,u
         stx   $02,u
         ldy   D.SysPRC
         sty   D.Proc
         lbsr  PrtErrNm Write label and error number
         clr   $0A,u
         ldx   $02,u

D08E6    leax  P$ErrNam,x
         clr   $09,u
         pshs  u,x
         clra
         os9   F$Link
         tfr   u,y
         puls  u,x
         sty   $04,u
         bcc   PrtErr20

         lda   #$05
         os9   I$Open
         sta   $08,u
         inc   $09,u
         bcc   PrtErr20

D0906    tst   $0A,u
         bne   L0910
         inc   $0A,u
         ldx   D.SysPRC
         bra   D08E6

L0910    lda   #$0D  Write carriage return
         pshs  a
         leax  ,s
         ldy   #1
         lbsr  PrtLine
         leas  1,s
         bra   L0924

L0921    lbsr  PrtUndo
L0924    ldy   $02,u
         sty   D.Proc
         leas  <$5B,s
         puls  u
PrtErr90    clrb
         rts

* Module linked
PrtErr20    tst   $09,u
         bne   L093F
         ldx   $04,u
         ldd   $0D,x
         leax  d,x
         stx   $06,u
         bra   PrtErr40

L093F    ldx   #$000D
         bsr   D09C0
         bcs   PrtErr70
         lda   $08,u
         ldy   #$0002
         leas  -$02,s
         leax  ,s
         os9   I$Read
         puls  x
         bcs   PrtErr70
         bsr   D09C0
         bcs   PrtErr70

PrtErr40    lbsr  PrtRdRcd
         bcs   PrtErr70
         lbsr  PrtGetNm
         beq   PrtErr70
         cmpb  $01,u
         bne   PrtErr40
         pshs  x
         leax  >ErrMsg2,pcr  Write hyphen
         ldy   #$0003
         bsr   PrtLine
         puls  x
PrtErr50    ldy   #PrtBufSz-1
         bsr   PrtLine
         bsr   PrtRdRcd
         bcs   L0921
         lda   ,x+
         beq   L0921
         cmpa  #$30
         bcs   PrtErr50
         bra   L0921

PrtErr70    bsr   PrtUndo
         lbra  D0906

PrtErrNm    leax  >ErrMsg1,pcr
         ldy   #MsgLen1    length
         bsr   PrtLine
         ldb   $01,u
         leax  $0B,u
         tfr   x,y
         lda   #'0-1
L09A2    inca
         subb  #100
         bcc   L09A2
         sta   ,y+
         lda   #'9+1
L09AB    deca
         addb  #10
         bcc   L09AB
         sta   ,y+
         addb  #'0
         stb   ,y+
         ldy   #3
PrtLine    lda   ,u
         os9   I$WritLn
         rts

* Seek to location
D09C0    lda   $08,u
         pshs  u,x
         tfr   x,u
         ldx   #0
         os9   I$Seek
         puls  pc,u,x

* close or unlink error file
PrtUndo    lda   $08,u
         tst   $09,u
         bne   L09DD
         pshs  u
         ldu   $04,u
         os9   F$UnLink
         puls  pc,u
L09DD    os9   I$Close
         rts

* Read one line from error message file
PrtRdRcd    leax  $0B,u
         ldy   #ERRMSGLN
         lda   $08,u
         tst   $09,u
         beq   L09F1
         os9   I$ReadLn
         rts

L09F1    tfr   y,d
         ldy   $06,u

D09F6    lda   ,y+
         sta   ,x+
         decb
         beq   L0A01
         cmpa  #$0D
         bne   D09F6

L0A01    leax  $0B,u
         sty   $06,u
         clrb
         rts

* Parse number in ASCII
PrtGetNm    clrb
L0A09    lda   ,x+
         beq   L0A1A
         suba  #'0
         bcs   L0A1B
         pshs  a
         lda   #10
         mul
         addb  ,s+
         bra   L0A09
L0A1A    tstb
L0A1B    rts

ErrMsg1 fcc "Error #"
MsgLen1   equ   *-ErrMsg1
ErrMsg2 fcc " - "
MsgLen2   equ   *-ErrMsg2

******************************
*
*       Subroutine InsErr
*
*  Install error message path/module
*  name string
*
* Input: U = Registers ptr
*         R$X,U=ptr to name string
*
* Output: U unchanged
*         Carry set if error, B has error code
*
* Data: D.Proc
*
* Calls: F$Move, F$Link, F$UnLink, I$Open, I$Close
*
* The name string MUST be 32 chrs or less
*
InsErr  pshs u
         ldx   R$X,u
         clra
         os9   F$Link Is it already loaded?
         bcs   InsErr1 ..no, then try to open the file
         pshs  x
         os9   F$UnLink
         bra   InsErr2
InsErr1    ldu   ,s
         ldx   R$X,u
         lda   #READ.
         os9   I$Open
         bcs   InsErrx
         pshs  x
         os9   I$Close
InsErr2    ldu   D.Proc
         lda   P$Task,u
         ldb   D.SysTsk
         ldy   #$0020
         leau  P$ErrNam,u
         ldx   $02,s
         ldx   $04,x
         os9   F$Move
         ldu   $02,s
         puls  x
         stx   R$X,u
         clrb
InsErrx    puls  pc,u

 else
* Normal error service

********************************
*
* F$PErr System call entry point
*
* Entry: U = Register stack pointer
*

ErrMsg1   fcc "ERROR #"
ErrNum   equ   *-ErrMsg1
 fcb  '0-1,'9+1,'0
         fcb   C$CR
ErrMessL equ   *-ErrMsg1

PrtErr    ldx   D.Proc
         lda   <P$PATH+2,x  get stderr path
         beq   L08CC
         leas  -ErrMessL,s  make room on stack
         leax  <ErrMsg1,pcr
         leay  ,s
L0893    lda   ,x+
         sta   ,y+
         cmpa  #C$CR       done?
         bne   L0893
         ldb   R$B,u
* Convert error code to decimal
L089D    inc   ErrNum+0,s
         subb  #100
         bcc   L089D
L08A3    dec   ErrNum+1,s
         addb  #10
         bcc   L08A3
         addb  #$30
         stb   ErrNum+2,s
         ldx   D.Proc
         ldu   P$SP,x      get the stack pointer
         leau  -ErrMessL,u put a buffer on it
         lda   D.SysTsk
         ldb   P$Task,x    get task number of process
         leax  ,s
         ldy   #ErrMessL  get length of text
L08BD    os9   F$Move
         leax  ,u
         ldu   D.Proc
         lda   <P$PATH+2,u get path number
         os9   I$WritLn
         leas  ErrMessL,s  purge the buffer
L08CC    rts

 endc
 page
*****
* Enter I/O Queue and perform a timed sleep
* Input: A = Process number
*
IOQueu    ldy   D.Proc
IOQ.A    lda   P$IOQN,y
         beq   L0A87
         cmpa  R$A,u
         bne   IOQ.B
         clr   P$IOQN,y

 ifeq LEVEL-1
 else
 os9 F$GProcP get process ptr
 endc

         bcs   IOQuExit
         clr   P$IOQP,y
         ldb   #S$Wake
         os9   F$Send
         bra   L0A8E

IOQ.B
 ifeq LEVEL-1
 else
 os9 F$GProcP get process ptr
 endc
         bcc   IOQ.A
L0A87    lda   R$A,u
IOQ.D
 ifeq LEVEL-1
 else
 os9 F$GProcP get process ptr
 endc
         bcs   IOQuExit
L0A8E    lda   P$IOQN,y
         bne   IOQ.D
         ldx   D.Proc
         lda   P$ID,x
         sta   P$IOQN,y
         lda   P$ID,y
         sta   P$IOQP,x
         ldx   #0
         os9   F$Sleep
         ldu   D.Proc
         lda   P$IOQP,u
         beq   IOQ.F

 ifeq LEVEL-1
 else
 os9 F$GProcP get process ptr
 endc

         bcs   IOQ.F
         lda   P$IOQN,y
         beq   IOQ.F
*
* Graceful Abnormal Queue Queue Exit
*
         lda   P$IOQN,u
         sta   P$IOQN,y
         beq   IOQ.F
         clr   P$IOQN,u

 ifeq LEVEL-1
 else
 os9 F$GProcP get process ptr
 endc

         bcs   IOQ.F
         lda   P$IOQP,u
         sta   P$IOQP,y
IOQ.F    clr   P$IOQP,u
IOQuExit rts

 emod
IOEnd equ   *
