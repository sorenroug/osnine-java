         nam   Input/Output Manager
         ttl   Module Header

* This is a disassembly of the IOMan edition 10 distributed with OS-9 for Dragon 128
* OS-9 Level 2. It contains modifications in some allocation routines.

tylg     set   Systm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   IOEnd,IOName,tylg,atrv,IOINIT,0

IOName  fcs /IOMan/  module name

         fcb 10

 use   defsfile

IOINIT equ *
* allocate device and polling tables
         ldx   D.Init
         lda   PollCnt,x   get number of entries in table
         ldb   #POLSIZ
         mul
         pshs  b,a
         lda   DevCnt,x      get device count
         ldb   #DEVSIZ
         mul
         addd  ,s
         addd  #$00FF  Round up
         clrb
         os9   F$SRqMem
         bcs   Crash
         leax  ,u
L002E    clr   ,x+
         subd  #$0001
         bhi   L002E
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
         leay  <IOCalls,pcr
         os9   F$SSvc
         rts

Crash    jmp   [>$FFEE]

******************************
*
* System service routine vector table
*
IOCalls  fcb $7F
         fdb   UsrIO-*-2 
         fcb   F$Load    
         fdb   FLoad-*-2 
         fcb   I$Detach  
         fdb   IDetach0-*-2
         fcb   F$PErr    
         fdb   FPErr-*-2 
 ifne EXTERR
         fcb F$InsErr
         fdb  FInsErr-*-2
 endc
         fcb   F$IOQu+$80
         fdb   FIOQu-*-2 
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

L009A    lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         anda  #$00
         cmpb  #$FF
         rts

UsrIODis fdb   IAttach-UsrIODis
         fdb   IDetach-UsrIODis
         fdb   UIDup-UsrIODis
         fdb   IUsrCall-UsrIODis
         fdb   IUsrCall-UsrIODis
         fdb   IMakDir-UsrIODis
         fdb   IChgDir-UsrIODis
         fdb   IDelete-UsrIODis
         fdb   UISeek-UsrIODis
         fdb   UIRead-UsrIODis
         fdb   UIWrite-UsrIODis
         fdb   UIRead-UsrIODis
         fdb   UIWrite-UsrIODis
         fdb   UIGetStt-UsrIODis
         fdb   UISeek-UsrIODis
         fdb   UIClose-UsrIODis
         fdb   IDeletX-UsrIODis

SysIODis fdb   IAttach-SysIODis
         fdb   IDetach-SysIODis
         fdb   SIDup-SysIODis
         fdb   ISysCall-SysIODis
         fdb   ISysCall-SysIODis
         fdb   IMakDir-SysIODis
         fdb   IChgDir-SysIODis
         fdb   IDelete-SysIODis
         fdb   SISeek-SysIODis
         fdb   SIRead-SysIODis
         fdb   SIWrite-SysIODis
         fdb   SIRead-SysIODis
         fdb   SIWrite-SysIODis
         fdb   SIGetStt-SysIODis
         fdb   SISeek-SysIODis
         fdb   SIClose-SysIODis
         fdb   IDeletX-SysIODis

UsrIO    leax  <UsrIODis,pcr
         bra   IODsptch
SysIO    leax  <SysIODis,pcr
IODsptch    cmpb  #$90
         bhi   ErrSvc
         pshs  b
         lslb
         ldd   b,x
         leax  d,x
         puls  b
         jmp   ,x

ErrSvc    comb
         ldb   #E$UnkSvc
         rts

IAttach  ldb   #$17
L0108    clr   ,-s
         decb
         bpl   L0108
         stu   <$16,s
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
         bcs   L0151
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
         bcs   L0151
         stu   ,s
         ldu   $04,s
         ldd   $09,u
         leax  d,u
         lda   #FlMgr+0      link to fm
         os9   F$Link
L0151    ldx   <$14,s
         stx   D.Proc
         bcc   L0166
* Error on attach, so detach
L0158    stb   <$17,s
         leau  ,s
         os9   I$Detach
         leas  <$17,s
         comb
         puls  pc,b

L0166    stu   $06,s
         ldx   D.Init
         ldb   DevCnt,x       get device entry count
         lda   DevCnt,x       get device entry count
         ldu   D.DevTbl
L0170    ldx   V$DESC,u       get dev desc ptr
         beq   L01AD
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
         bne   L01AD
         ldy   $0E,x
         cmpy  $0B,s
         bne   L01AD
         ldx   ,u
         cmpx  ,s
         bne   L01AD
         ldx   $02,u
         stx   $02,s
         tst   $08,u
         beq   L01AD
         sta   $0A,s
L01AD    leau  DEVSIZ,u      advance to the next device entry
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
         bra   L0158

L01C7    ldb   #E$BMode
         bra   L0158

L01CB    ldx   $02,s
         lbne  L0255
         stu   $0E,s
         ldx   ,s
         ldd   $0B,x
         addd  #$00FF
         clrb
         os9   F$SRqMem
         lbcs  L0158
         stu   $02,s
L01E4    clr   ,u+
         subd  #$0001
         bhi   L01E4
         ldd   $0B,s
         lbsr  L009A
         std   <$12,s
         ldu   #$0000
         tfr   u,y
         stu   <$10,s
         ldx   D.SysDAT
L01FD    ldd   ,x++
         cmpd  <$12,s
         beq   L0235
         cmpd  #$00C0
         bne   L0211
         sty   <$10,s
         leau  -$02,x
L0211    leay  >$1000,y
         bne   L01FD
         ldb   #$CF
         cmpu  #$0000
         lbeq  L0158
         ldd   <$12,s
         std   ,u
         ldx   D.SysPRC
         lda   P$State,x
         ora   #ImgChg
         sta   P$State,x
         os9   F$ID
         ldy   <$10,s
L0235    sty   <$10,s
         ldd   $0C,s
         anda  #$0F
         addd  <$10,s
         ldu   $02,s
         clr   ,u
         std   $01,u
         ldy   $04,s
         ldx   ,s
         ldd   $09,x
         jsr   d,x
         lbcs  L0158
         ldu   $0E,s
L0255    ldb   #$08
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
         lbne  L01C7
         inc   $08,u
         bne   L0276
         dec   $08,u
L0276    ldx   <$16,s
         stu   $08,x
         leas  <$18,s
         clrb
         rts

IDetach  ldu   R$U,u
         ldx   R$X,u
         lda   #$FF
         cmpa  $08,u
         lbeq  L0349
         dec   $08,u
         lbne  L032B
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
         ldx   $01,s
         ldx   $04,x
         ldd   $0E,x
         beq   L0321
         lbsr  L009A
         beq   L0321
         tfr   d,x
         ldb   ,s
         pshs  x,b
         ldu   D.DevTbl
L02E4    cmpu  $04,s
         beq   L02F9
         ldx   $04,u
         beq   L02F9
         ldd   $0E,x
         beq   L02F9
         lbsr  L009A
         cmpd  $01,s
         beq   L031F
L02F9    leau  $09,u
         dec   ,s
         bne   L02E4
         ldx   D.SysPRC
         ldu   D.SysDAT
         ldy   #$0010
L0307    ldd   ,u++
         cmpd  $01,s
         beq   L0314
         leay  -$01,y
         bne   L0307
         bra   L031F
L0314    ldd   #$00C0
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
L032B    ldd   D.Proc
         pshs  b,a
         ldd   D.SysPRC
         std   D.Proc
         ldy   ,u
         ldu   $06,u
         os9   F$UnLink
         leau  ,y
         os9   F$UnLink
         leau  ,x
         os9   F$UnLink
         puls  b,a
         std   D.Proc
L0349    lbsr  L05DA
         clrb
         rts

UIDup    bsr   LocFrPth
         bcs   L036E
         pshs  x,a
         lda   $01,u
         lda   a,x
         bsr   L0367
         bcs   L0363
         puls  x,b
         stb   $01,u
         sta   b,x
         rts
L0363    puls  pc,x,a

SIDup    lda   $01,u
L0367    lbsr  GetPDesc
         bcs   L036E
         inc   $02,y
L036E    rts

LocFrPth ldx D.Proc
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

IUsrCall bsr   LocFrPth
         bcs   L0397
         pshs  u,x,a
         bsr   ISysCall
         puls  u,x,a
         bcs   L0397
         ldb   $01,u
         stb   a,x
         sta   $01,u
L0397    rts

ISysCall    pshs  b
         ldb   $01,u
         bsr   L040F
         bcs   L03AC
         puls  b
         lbsr  CallFMgr
         bcs   L03BB
         lda   ,y
         sta   $01,u
         rts
L03AC    puls  pc,a

IMakDir  pshs  b
         ldb   #$82
L03B2    bsr   L040F
         bcs   L03AC
         puls  b
         lbsr  CallFMgr
L03BB    pshs  b,cc
         ldu   $03,y
         os9   I$Detach
         lda   ,y
         ldx   D.PthDBT
         os9   F$Ret64
         puls  pc,b,cc

IChgDir  pshs  b
         ldb   $01,u
         orb   #$80
         bsr   L040F
         bcs   L03AC
         puls  b
         lbsr  CallFMgr
         bcs   L03BB
         ldu   D.Proc
         ldb   $01,y
         bitb  #$1B
         beq   IChgExec
         ldx   $03,y
         stx   <$20,u
         inc   $08,x
         bne   IChgExec
         dec   $08,x
IChgExec bitb  #$24
         beq   L03FE
         ldx   $03,y
         stx   <$26,u
         inc   $08,x
         bne   L03FE
         dec   $08,x
L03FE    clrb
         bra   L03BB

IDelete  pshs  b
         ldb   #$02
         bra   L03B2

IDeletX  ldb   #$87
         pshs  b
         ldb   $01,u
         bra   L03B2

L040F    ldx   D.Proc
         pshs  u,x
         ldx   D.PthDBT
         os9   F$All64
         bcs   L047B
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
         bra   L0445
L0442    ldx   <$20,x
L0445    beq   L0480
         ldd   D.SysPRC
         std   D.Proc
         ldx   $04,x
         ldd   $04,x
         leax  d,x
L0451    pshs  y
         os9   F$PrsNam
         puls  y
         bcs   L0480
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
L047B    puls  u,x
         stx   D.Proc
         rts
L0480    ldb   #E$BPNam
L0482    pshs  b
         lda   ,y
         ldx   D.PthDBT
         os9   F$Ret64
         puls  b
         coma
         bra   L047B

S2UPath  lda   $01,u
         cmpa  #$10
         bcc   L04A1
         ldx   D.Proc
         leax  <$30,x
         andcc #$FE
         lda   a,x
         bne   L04A4
L04A1    comb
         ldb   #E$BPNum
L04A4    rts

UISeek   bsr   S2UPath       get user path #
         bcc   L04AC
         rts

SISeek   lda   R$A,u
L04AC    bsr   GetPDesc
         lbcc  CallFMgr
         rts

UIRead   bsr   S2UPath       get user path #
         bcc   L04BA
         rts

SIRead   lda   R$A,u       get user path
L04BA    pshs  b
         ldb   #$05
L04BE    bsr   GetPDesc
         bcs   L0509
         bitb  PD.MOD,y    test bits against mode in path desc
         beq   L0507
         ldd   R$Y,u       else get count from user
         beq   L04F6
         addd  R$X,u       else update buffer pointer with size
         bcs   L04FB
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
         leax  <P$DATImg,x
         lslb
         leax  b,x
L04E7    pshs  a
         ldd   ,x++
         cmpd  #DAT.Free
         puls  a
         beq   L04FB
         deca
         bpl   L04E7
L04F6    puls  b
         lbra  CallFMgr
L04FB    ldb   #$F4
         lda   ,s
         bita  #$02
         beq   L0509
         ldb   #E$Write
         bra   L0509

L0507    ldb   #E$BPNam
L0509    com   ,s+
         rts

UIWrite  bsr   S2UPath
         bcc   L0513
         rts

SIWrite  lda   R$A,u
L0513    pshs  b
         ldb   #$02
         bra   L04BE

GetPDesc    pshs  x
         ldx   D.PthDBT
         os9   F$Find64
         puls  x
         lbcs  L04A1
L0526    rts

UIGetStt lbsr  S2UPath
         ldx   D.Proc
         bcc   L0533
         rts

SIGetStt lda   R$A,u
         ldx   D.SysPRC
L0533    pshs  x,b,a
         lda   R$B,u      get func code
         sta   $01,s
         puls  a
         lbsr  L04AC
         puls  x,a
         pshs  u,y,cc
         tsta
         beq   SSOpt
         cmpa  #$0E
         beq   SSDevNm
         puls  pc,u,y,cc
SSOpt    lda   D.SysTsk
         ldb   P$Task,x
         leax  <PD.OPT,y
SSCopy    ldy   #$0020
         ldu   $04,u
         os9   F$Move
         leas  $01,s
         puls  pc,u,y

SSDevNm  lda   D.SysTsk
         ldb   $06,x
         pshs  b,a
         ldx   $03,y
         ldx   $04,x
         ldd   $04,x
         leax  d,x
         puls  b,a
         bra   SSCopy

UIClose  lbsr  S2UPath       get user path #
         bcs   L0526
         pshs  b
         ldb   $01,u
         clr   b,x
         puls  b
         bra   L0582

SIClose  lda   R$A,u
L0582    bsr   GetPDesc
         bcs   L0526
         dec   $02,y
         tst   $05,y
         bne   L058E
         bsr   CallFMgr
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

CallFMgr pshs  u,y,x,b
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
         bsr   L05DA
         ldy   $04,s
         ldx   D.Proc
         lda   ,x
         cmpa  $05,y
         bne   L05D8
         clr   $05,y
L05D8    puls  pc,u,y,x,b,cc

L05DA    pshs  y,x
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
L061B    ldb   $02,s
         cmpb  -(POLSIZ-Q$PRTY),x compare with prev entry's prior
         bcs   L062E
         ldb   #POLSIZ
L0623    lda   ,-x
         sta   POLSIZ,x
         decb
         bne   L0623
         cmpx  D.PolTbl
         bhi   L061B
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
         beq   L0657
         leax  POLSIZ,x
         decb
         bne   L064B
         clrb
         rts

L0657    pshs  b,cc
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
         bsr   LoadMod
         bcs   L06C4
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
         bcs   L06C4
         ldx   ,s
         sty   $06,x
         stu   $08,x
L06C4    puls  pc,u

IDetach0 pshs  u          save off regs ptr
         ldx   R$X,u      get ptr to device name
         bsr   LoadMod
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

LoadMod  os9   F$AllPrc
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
         lbsr  L0803
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
         lbsr  L0803
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
         beq   L078D
         os9   I$Close
L078D    ldd   $02,s
         addd #DAT.BlSz-1 Round up
         lsra
         lsra
         lsra
         lsra
         sta   $02,s
         ldb   ,s
         beq   L07BA
         lsrb
         lsrb
         lsrb
         lsrb
         subb  $02,s
         beq   L07BA
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
L07BA    ldx   <$15,s
         lda   P$ID,x
         os9   F$DelPrc
         ldd   <$17,s
         bne   L07CF
         ldb   $07,s
         stb   <$12,s
         comb
         bra   L07FE
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
         bra   L07FE
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
L07FE    leas  <$11,s
         puls  pc,u,y,x,b,a

L0803    pshs  y,x,b,a
         addd  $02,s
         std   $04,s
         cmpd  $08,s
         lbls  L0895
         addd #DAT.BlSz-1 Round up
         lsra
         lsra
         lsra
         lsra
         cmpa  #DAT.BlCt-1
         bhi   L085E
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
 ifeq CPUTYPE-DRG128
         ldb   #DAT.GBlk
         leay  b,y
 else
         clrb
 endc
L083B    tst   ,y+
         beq   L087A
L083F    addd  #1
         cmpy  D.BlkMap+2
         bne   L083B

* Probably special for Dragon 128
 ifeq CPUTYPE-DRG128
         ldy   D.BlkMap
         clra
D084B    pshs  y
         leay  TRANSTBL,pcr
         ldb   a,y
         puls  y
         tst   b,y
         beq   D0863
D0859    inca
         cmpa  #DAT.GBlk
         bcs   D084B
 endc

L085E    comb
         ldb   #E$MemFul
         bra   L089F

* Probably special for Dragon 128
 ifeq CPUTYPE-DRG128
D0863    inc   b,y
         clr   ,u+
         stb   ,u+
         pshs  a
         ldd   $09,s
         addd  #DAT.BlSz
         std   $09,s
         puls  a
         leax  -1,x
         bne   D0859
         bra   L088D
 endc

L087A    inc   -1,y
         std   ,u++
         pshs  b,a
         ldd   $0A,s
         addd  #DAT.BlSz
         std   $0A,s
         puls  b,a
         leax  -1,x
         bne   L083F
L088D    ldx   <$1D,s
         os9   F$SetTsk
         bcs   L089F
L0895    lda   $0E,s
         ldx   $02,s
         ldy   ,s
         os9   I$Read
L089F    leas  $04,s
         puls  pc,x

 ifeq CPUTYPE-DRG128
TRANSTBL fcb $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
      fcb $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F
 endc

********************************
*
* F$PErr System call entry point
*
* Entry: U = Register stack pointer
*
 ifne EXTERR
ERRMSGLN equ 80

FPErr
         ldb   R$B,u
         beq   L092F
         ldx   D.Proc
         lda   <P$PATH+2,x  get stderr path
         beq   L092F  return if not there
         pshs  u
         leas  -(ERRMSGLN+$B),s
         leau  ,s
         std   0,u
         stx   $02,u
         ldy   D.SysPRC
         sty   D.Proc
         lbsr  L0990 Write label and error number
         clr   $0A,u
         ldx   $02,u
D08E6    leax  >P$ErrNam,x
         clr   $09,u
         pshs  u,x
         clra
         os9   F$Link
         tfr   u,y
         puls  u,x
         sty   $04,u
         bcc   L0931
         lda   #$05
         os9   I$Open
         sta   $08,u
         inc   $09,u
         bcc   L0931
D0906    tst   $0A,u
         bne   L0910
         inc   $0A,u
         ldx   D.SysPRC
         bra   D08E6
L0910    lda   #$0D  Write carriage return
         pshs  a
         leax  ,s
         ldy   #1
         lbsr  D09BA
         leas  1,s
         bra   L0924

L0921    lbsr  L09CE
L0924    ldy   $02,u
         sty   D.Proc
         leas  <$5B,s
         puls  u
L092F    clrb
         rts

* Module linked
L0931    tst   $09,u
         bne   L093F
         ldx   $04,u
         ldd   $0D,x
         leax  d,x
         stx   $06,u
         bra   L095B
L093F    ldx   #$000D
         bsr   D09C0
         bcs   L098B
         lda   $08,u
         ldy   #$0002
         leas  -$02,s
         leax  ,s
         os9   I$Read
         puls  x
         bcs   L098B
         bsr   D09C0
         bcs   L098B
L095B    lbsr  L09E1
         bcs   L098B
         lbsr  L0A08
         beq   L098B
         cmpb  $01,u
         bne   L095B
         pshs  x
         leax  >ErrSepa,pcr  Write hyphen
         ldy   #$0003
         bsr   D09BA
         puls  x
L0977    ldy   #$004F
         bsr   D09BA
         bsr   L09E1
         bcs   L0921
         lda   ,x+
         beq   L0921
         cmpa  #$30
         bcs   L0977
         bra   L0921
L098B    bsr   L09CE
         lbra  D0906

* Write label and error number
L0990    leax  >ErrHead,pcr
         ldy   #ErrHLen    length
         bsr   D09BA
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
D09BA    lda   ,u
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
L09CE    lda   $08,u
         tst   $09,u
         bne   L09DD
         pshs  u
         ldu   $04,u
         os9   F$UnLink
         puls  pc,u
L09DD    os9   I$Close
         rts

* Read one line from error message file
L09E1    leax  $0B,u
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
L0A08    clrb
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

ErrHead fcc "Error #"
ErrHLen   equ   *-ErrHead 
ErrSepa fcc " - "

*
* Insert error message module
*
FInsErr  pshs u
         ldx   R$X,u
         clra
         os9   F$Link Is it already loaded?
         bcs   D0A37 ..no, then try to open the file
         pshs  x
         os9   F$UnLink
         bra   D0A47
D0A37    ldu   ,s
         ldx   R$X,u
         lda   #READ.
         os9   I$Open
         bcs   D0A63
         pshs  x
         os9   I$Close
D0A47    ldu   D.Proc
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
D0A63    puls  pc,u

 else
* Normal error service

********************************
*
* F$PErr System call entry point
*
* Entry: U = Register stack pointer
*

ErrHead   fcc "ERROR #"
ErrNum   equ   *-ErrHead 
 fcb  '0-1,'9+1,'0
         fcb   C$CR
ErrMessL equ   *-ErrHead 

FPErr    ldx   D.Proc
         lda   <P$PATH+2,x  get stderr path
         beq   L08CC
         leas  -ErrMessL,s  make room on stack
         leax  <ErrHead,pcr
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

*****
* Enter I/O Queue and perform a timed sleep
* Input: A = Process number
*
FIOQu    ldy   D.Proc
L0A68    lda   P$IOQN,y
         beq   L0A87
         cmpa  R$A,u
         bne   L0A82
         clr   P$IOQN,y
         os9   F$GProcP
         bcs   L0ACA
         clr   P$IOQP,y
         ldb   #S$Wake
         os9   F$Send
         bra   L0A8E

L0A82    os9   F$GProcP
         bcc   L0A68
L0A87    lda   R$A,u
L0A89    os9   F$GProcP
         bcs   L0ACA
L0A8E    lda   P$IOQN,y
         bne   L0A89
         ldx   D.Proc
         lda   P$ID,x
         sta   P$IOQN,y
         lda   P$ID,y
         sta   P$IOQP,x
         ldx   #0
         os9   F$Sleep
         ldu   D.Proc
         lda   P$IOQP,u
         beq   L0AC8
         os9   F$GProcP
         bcs   L0AC8
         lda   P$IOQN,y
         beq   L0AC8
         lda   P$IOQN,u
         sta   P$IOQN,y
         beq   L0AC8
         clr   P$IOQN,u
         os9   F$GProcP
         bcs   L0AC8
         lda   P$IOQP,u
         sta   P$IOQP,y
L0AC8    clr   P$IOQP,u
L0ACA    rts
         emod
IOEnd      equ   *
