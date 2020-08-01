         nam   Input/Output Manager
         ttl   Module Header
*
* This file has been extracted from a system disk for FM-11
*
  use   defsfile

tylg     set   Systm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   IOEnd,IOName,tylg,atrv,IOINIT,0

IOName  fcs /IOMan/  module name

         fcb   11

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
         addd  #$00FF
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

Crash    jmp   [>$FFFE]

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
L007B    ldy   V$DESC,u      descriptor exists?
         beq   L008C
         cmpx  V$DESC,u      device match?
         beq   L0093
         cmpx  ,u
         beq   L0093
         cmpx  $06,u
         beq   L0093
L008C    leau  DEVSIZ,u      move to next dev entry
         decb
         bne   L007B
         clrb
         rts

L0093    comb
         ldb   #E$ModBsy     submit error
         rts

L0097    lsra
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
 fcb $02,$E4
 fcb $02,$E4
 fcb $03,$0D
 fcb $03,$2A
 fcb $03,$60
  fcb $04,$04
 fcb $04,$12
 fcb $04,$6B
 fcb $04,$12
 fcb $04,$6B
 fcb $04,$86
 fcb $04,$04
 fcb $04,$D7
         fdb   IDeletX-UsrIODis

SysIODis fdb   IAttach-SysIODis
         fdb   IDetach-SysIODis
         fdb   SIDup-SysIODis
 fcb $02,$D5
 fcb $02,$D5
 fcb $02,$EB
 fcb $03,$08
 fcb $03,$3E
 fcb $03,$E7
 fcb $03,$F5
 fcb $04,$4E
 fcb $03,$F5
 fcb $04,$4E
 fcb $04,$6C
 fcb $03,$E7
 fcb $04,$C4
         fdb   IDeletX-SysIODis

UsrIO    leax  <UsrIODis,pcr
         bra   IODsptch
SysIO         leax  <SysIODis,pcr
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
L0105    clr   ,-s
         decb
         bpl   L0105
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
         bcs   L014E
         stu   $04,s
         ldy   <$16,s
         stx   $04,y
         lda   $0E,u
         sta   $0B,s
         ldd   $0F,u
         std   $0C,s
         ldd   $0B,u
         leax  d,u
         lda   #Drivr+0        driver
         os9   F$Link
         bcs   L014E
         stu   ,s
         ldu   $04,s
         ldd   $09,u
         leax  d,u
         lda   #FlMgr+0      link to fm
         os9   F$Link
L014E    ldx   <$14,s
         stx   D.Proc
         bcc   L0163
* Error on attach, so detach
L0155    stb   <$17,s
         leau  ,s
         os9   I$Detach
         leas  <$17,s
         comb
         puls  pc,b

L0163    stu   $06,s
         ldx   D.Init
         ldb   DevCnt,x       get device entry count
         lda   DevCnt,x       get device entry count
         ldu   D.DevTbl
L016D    ldx   V$DESC,u       get dev desc ptr
         beq   L01AA
         cmpx  $04,s
         bne   L0188
         ldx   $02,u
         bne   L0186
         pshs  a
         lda   $08,u
         beq   L0182
         os9   F$IOQu
L0182    puls  a
         bra   L016D
L0186    stu   $0E,s
L0188    ldx   V$DESC,u       get dev desc ptr
         ldy   $0F,x
         cmpy  $0C,s
         bne   L01AA
         ldy   $0E,x
         cmpy  $0B,s
         bne   L01AA
         ldx   ,u
         cmpx  ,s
         bne   L01AA
         ldx   $02,u
         stx   $02,s
         tst   $08,u
         beq   L01AA
         sta   $0A,s
L01AA    leau  DEVSIZ,u      advance to the next device entry
         decb
         bne   L016D
         ldu   $0E,s
         lbne  L0261
         ldu   D.DevTbl
L01B7    ldx   V$DESC,u       get dev desc ptr
         beq   L01C8
         leau  DEVSIZ,u     move to next dev table entry
         deca
         bne   L01B7
         ldb   #E$DevOvf      dev table overflow
         bra   L0155

L01C4    ldb   #E$BMode
         bra   L0155

L01C8    ldx   $02,s
         lbne  L0258
         stu   $0E,s
         ldx   ,s
         ldd   $0B,x
         addd  #$00FF
         clrb
         os9   F$SRqMem
         lbcs  L0155
         stu   $02,s
L01E1    clr   ,u+
         subd  #$0001
         bhi   L01E1
         ldy   #$F000  New in ed. 11
         ldd   $0B,s
         lbsr  L0097
         beq   L0238  New in ed. 11
         std   <$12,s
         ldu   #$0000
         tfr   u,y
         stu   <$10,s
         ldx   D.SysDAT
L0200    ldd   ,x++
         cmpd  <$12,s
         beq   L0238
         cmpd  #$00FE
         bne   L0214
         sty   <$10,s
         leau  -$02,x
L0214    leay  >$1000,y
         bne   L0200
         ldb   #$CF
         cmpu  #$0000
         lbeq  L0155
         ldd   <$12,s
         std   ,u
         ldx   D.SysPRC
         lda   P$State,x
         ora   #ImgChg
         sta   P$State,x
         os9   F$ID
         ldy   <$10,s
L0238    sty   <$10,s
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
         lbcs  L0155
         ldu   $0E,s
L0258    ldb   #$08
L025A    lda   b,s
         sta   b,u
         decb
         bpl   L025A
L0261    ldx   $04,u
         ldb   $07,x
         lda   $09,s
         anda  $0D,x
         ldx   ,u
         anda  $0D,x
         cmpa  $09,s
         lbne  L01C4
         inc   $08,u
         bne   L0279
         dec   $08,u
L0279    ldx   <$16,s
         stu   $08,x
         leas  <$18,s
         clrb
         rts

IDetach  ldu   R$U,u
         ldx   R$X,u
         lda   #$FF
         cmpa  $08,u
         lbeq  L034C
         dec   $08,u
         lbne  L032E
         ldx   D.Init
         ldb   DevCnt,x      get device count
         pshs  u,b
         ldx   $02,u
         clr   $02,u
         clr   $03,u
         ldy   D.DevTbl
L02A4    cmpx  $02,y
         beq   L0324
         leay  DEVSIZ,y
         decb
         bne   L02A4
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
         beq   L0324
         lbsr  L0097
         beq   L0324
         tfr   d,x
         ldb   ,s
         pshs  x,b
         ldu   D.DevTbl
L02E7    cmpu  $04,s
         beq   L02FC
         ldx   $04,u
         beq   L02FC
         ldd   $0E,x
         beq   L02FC
         lbsr  L0097
         cmpd  $01,s
         beq   L0322
L02FC    leau  $09,u
         dec   ,s
         bne   L02E7
         ldx   D.SysPRC
         ldu   D.SysDAT
         ldy   #$0010
L030A    ldd   ,u++
         cmpd  $01,s
         beq   L0317
         leay  -$01,y
         bne   L030A
         bra   L0322
L0317    ldd   #$00FE
         std   -$02,u
         lda   $0C,x
         ora   #$10
         sta   $0C,x
L0322    leas  $03,s
L0324    puls  u,b
         ldx   $04,u
         clr   $04,u
         clr   $05,u
         clr   $08,u
L032E    ldd   D.Proc
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
L034C    lbsr  L05E4
         clrb
         rts

UIDup    bsr   LocFrPth
         bcs   L0371
         pshs  x,a
         lda   $01,u
         lda   a,x
         bsr   L036A
         bcs   L0366
         puls  x,b
         stb   $01,u
         sta   b,x
         rts
L0366    puls  pc,x,a

SIDup    lda   $01,u
L036A    lbsr  GetPDesc
         bcs   L0371
         inc   $02,y
L0371    rts

LocFrPth ldx D.Proc
         leax  <$30,x
         clra
L0378    tst   a,x
         beq   L0385
         inca
         cmpa  #$10
         bcs   L0378
         comb
         ldb   #$C8
         rts
L0385    andcc #$FE
         rts

IUsrCall bsr   LocFrPth
         bcs   L039A
         pshs  u,x,a
         bsr   ISysCall
         puls  u,x,a
         bcs   L039A
         ldb   $01,u
         stb   a,x
         sta   $01,u
L039A    rts

ISysCall    pshs  b
         ldb   $01,u
         bsr   L0412
         bcs   L03AF
         puls  b
         lbsr  CallFMgr
         bcs   L03BE
         lda   ,y
         sta   $01,u
         rts
L03AF    puls  pc,a

IMakDir  pshs  b
         ldb   #$82
L03B5    bsr   L0412
         bcs   L03AF
         puls  b
         lbsr  CallFMgr
L03BE    pshs  b,cc
         ldu   $03,y
         os9   I$Detach
         lda   ,y
         ldx   D.PthDBT
         os9   F$Ret64
         puls  pc,b,cc

IChgDir  pshs  b
         ldb   $01,u
         orb   #$80
         bsr   L0412
         bcs   L03AF
         puls  b
         lbsr  CallFMgr
         bcs   L03BE
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
         beq   L0401
         ldx   $03,y
         stx   <$26,u
         inc   $08,x
         bne   L0401
         dec   $08,x
L0401    clrb
         bra   L03BE

IDelete  pshs  b
         ldb   #$02
         bra   L03B5

IDeletX  ldb   #$87
         pshs  b
         ldb   $01,u
         bra   L03B5

L0412    ldx   D.Proc
         pshs  u,x
         ldx   D.PthDBT
         os9   F$All64
         bcs   L047E
         inc   $02,y
         stb   $01,y
         ldx   D.Proc
         ldb   $06,x
         ldx   $04,u
L0427    os9   F$LDABX
         leax  $01,x
         cmpa  #$20
         beq   L0427
         leax  -$01,x
         stx   $04,u
         ldb   $01,y
         cmpa  #$2F
         beq   L0454
         ldx   D.Proc
         bitb  #$24
         beq   L0445
         ldx   <$26,x
         bra   L0448
L0445    ldx   <$20,x
L0448    beq   L0483
         ldd   D.SysPRC
         std   D.Proc
         ldx   $04,x
         ldd   $04,x
         leax  d,x
L0454    pshs  y
         os9   F$PrsNam
         puls  y
         bcs   L0483
         lda   $01,y
         os9   I$Attach
         stu   $03,y
         bcs   L0485
         ldx   $04,u
         leax  <$11,x
         ldb   ,x+
         leau  <$20,y
         cmpb  #$20
         bls   L047A
         ldb   #$1F
L0476    lda   ,x+
         sta   ,u+
L047A    decb
         bpl   L0476
         clrb
L047E    puls  u,x
         stx   D.Proc
         rts
L0483    ldb   #E$BPNam
L0485    pshs  b
         lda   ,y
         ldx   D.PthDBT
         os9   F$Ret64
         puls  b
         coma
         bra   L047E

S2UPath    lda   $01,u
         cmpa  #$10
         bcc   L04A4
         ldx   D.Proc
         leax  <$30,x
         andcc #$FE
         lda   a,x
         bne   L04A7
L04A4    comb
         ldb   #E$BPNum
L04A7    rts

UISeek   bsr   S2UPath       get user path #
         bcc   L04AF
         rts

SISeek   lda   R$A,u
L04AF    bsr   GetPDesc
         lbcc  CallFMgr
         rts

UIRead   bsr   S2UPath       get user path #
         bcc   L04BD
         rts

SIRead   lda   R$A,u       get user path
L04BD    pshs  b
         ldb   #EXEC.+READ.
L04C1    bsr   GetPDesc
         bcs   L050C
         bitb  PD.MOD,y    test bits against mode in path desc
         beq   L050A
         ldd   R$Y,u       else get count from user
         beq   L04F9
         addd  R$X,u       else update buffer pointer with size
         bcs   L04FE
         subd  #$0001
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
L04EA    pshs  a
         ldd   ,x++
         cmpd  #DAT.Free
         puls  a
         beq   L04FE
         deca
         bpl   L04EA
L04F9    puls  b
         lbra  CallFMgr
L04FE    ldb   #$F4
         lda   ,s
         bita  #$02
         beq   L050C
         ldb   #E$Write
         bra   L050C

L050A    ldb   #E$BPNum   New in ed. 11
L050C    com   ,s+
         rts

UIWrite  bsr   S2UPath
         bcc   L0516
         rts

SIWrite  lda   R$A,u
L0516    pshs  b
         ldb   #$02
         bra   L04C1

GetPDesc pshs  x
         ldx   D.PthDBT
         os9   F$Find64
         puls  x
         lbcs  L04A4
L0529    rts

UIGetStt lbsr  S2UPath
         ldx   D.Proc
         bcc   L0536
         rts

SIGetStt lda   R$A,u
         ldx   D.SysPRC
L0536    pshs  x,b,a
         lda   R$B,u      get func code
         sta   $01,s
         puls  a
         lbsr  L04AF
         puls  x,a
         pshs  u,y,b,cc  New in ed. 11
         ldb   <$20,y  Device type?
         cmpb  #$03  New in ed. 11
         beq   L0553  New in ed. 11
         tsta              SS.Opt?
         beq   SSOpt
         cmpa  #SS.DevNm  Get device name?
         beq   SSDevNm
L0553    puls  pc,u,y,b,cc  New in ed. 11

SSOpt    lda   D.SysTsk
         ldb   P$Task,x
         leax  <PD.OPT,y
SSCopy   ldy   #PD.OPT
         ldu   R$X,u
         os9   F$Move
         leas  $01,s
         puls  pc,u,y,b  New in ed. 11

SSDevNm  lda   D.SysTsk
         ldb   P$Task,x
         pshs  b,a
         ldx   $03,y
         ldx   $04,x
         ldd   $04,x
         leax  d,x
         puls  b,a
         bra   SSCopy

UIClose  lbsr  S2UPath       get user path #
         bcs   L0529
         pshs  b
         ldb   $01,u
         clr   b,x
         puls  b
         bra   L058C

SIClose  lda   R$A,u
L058C    bsr   GetPDesc
         bcs   L0529
         dec   $02,y
         tst   $05,y
         bne   L0598
         bsr   CallFMgr
L0598    tst   $02,y
         bne   L0529
         lbra  L03BE
L059F    os9   F$IOQu
         comb
         ldb   <$19,x
         bne   L05B3
L05A8    ldx   D.Proc
         ldb   ,x
         clra
         lda   $05,y
         bne   L059F
         stb   $05,y
L05B3    rts

CallFMgr pshs  u,y,x,b
         bsr   L05A8
         bcc   L05BE
         leas  $01,s
         bra   L05D1
L05BE    stu   $06,y
         ldx   $03,y
         ldx   $06,x
         ldd   $09,x
         leax  d,x
         ldb   ,s+
         subb  #$83
         lda   #$03
         mul
         jsr   d,x
L05D1    pshs  b,cc
         bsr   L05E4
         ldy   $04,s
         ldx   D.Proc
         lda   ,x
         cmpa  $05,y
         bne   L05E2
         clr   $05,y
L05E2    puls  pc,u,y,x,b,cc

L05E4    pshs  y,x
         ldy   D.Proc
         bra   L05F8
L05EB    clr   P$IOQN,y
         ldb   #S$Wake     get wake signal
         os9   F$Send
         os9   F$GProcP
         clr   P$IOQP,y
L05F8    lda   P$IOQN,y
         bne   L05EB
         puls  pc,y,x

FIRQ     ldx   R$X,u     get ptr to IRQ packet
         ldb   ,x
         ldx   $01,x
         clra
         pshs  cc
         pshs  x,b
         ldx   D.Init
         ldb   PollCnt,x   get number of entries in table
         ldx   D.PolTbl
         ldy   $04,u
         beq   L0650
         tst   $01,s
         beq   L067B
         decb
         lda   #POLSIZ
         mul
         leax  d,x
         lda   $03,x
         bne   L067B
         orcc  #$50
L0625    ldb   $02,s
         cmpb  -(POLSIZ-Q$PRTY),x compare with prev entry's prior
         bcs   L0638
         ldb   #POLSIZ
L062D    lda   ,-x
         sta   POLSIZ,x
         decb
         bne   L062D
         cmpx  D.PolTbl
         bhi   L0625
L0638    ldd   $01,u
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
L0650    leas  $04,s
         ldy   $08,u
L0655    cmpy  $06,x
         beq   L0661
         leax  POLSIZ,x
         decb
         bne   L0655
         clrb
         rts

L0661    pshs  b,cc
         orcc  #$50
         bra   L066E
L0667    ldb   POLSIZ,x
         stb   ,x+
         deca
         bne   L0667
L066E    lda   #POLSIZ
         dec   $01,s
         bne   L0667
L0674    clr   ,x+
         deca
         bne   L0674
         puls  pc,a,cc

L067B    leas  $04,s
L067D    comb
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
         bra   L068F
L068A    leay  POLSIZ,y    else move to next entry
         decb
         beq   L067D
L068F    lda   [Q$POLL,y]  get device's status register
         eora  Q$FLIP,y    flip it
         bita  Q$MASK,y    origin of IRQ?
         beq   L068A
         ldu   $06,y
         pshs  y,b
         jsr   [Q$SERV,y]  execute service routine
         puls  y,b
         bcs   L068A
         rts

FLoad    pshs  u
         ldx   R$X,u       get pathname to load
         bsr   LoadMod
         bcs   L06CE
         puls  y           get caller's reg ptr in Y
L06AD    pshs  y
         stx   R$X,y       save updated pathlist
         ldy   ,u          get DAT image pointer
         ldx   $04,u       get offset within DAT image
         ldd   #$0006
         os9   F$LDDDXY
         ldx   ,s
         std   $01,x
         leax  ,u
         os9   F$ELink
         bcs   L06CE
         ldx   ,s
         sty   R$Y,x
         stu   R$U,x
L06CE    puls  pc,u

IDetach0 pshs  u
         ldx   $04,u
         bsr   LoadMod
         bcs   L06E8
         puls  y
         ldd   D.Proc
         pshs  y,b,a
         ldd   $08,y
         std   D.Proc
         bsr   L06AD
         puls  x
         stx   D.Proc
L06E8    puls  pc,u

* Load module from file
* Entry: X = pathlist to file containing module(s)
* A fake process descriptor is created, then the file is
* opened and validated into memory.

LoadMod  os9   F$AllPrc
         bcc   L06F0
         rts
L06F0    leay  ,u
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
         bcs   L0788
         sta   $06,s
         stx   <$13,s
         ldx   <$15,s
         os9   F$AllTsk
         bcs   L0788
         stx   D.Proc
L0720    ldd   #$0009
         ldx   $02,s
         lbsr  L080D
         bcs   L0788
         ldu   <$15,s
         lda   P$Task,u
         ldb   D.SysTsk
         leau  $08,s
         pshs  x
         ldx   $04,s
         os9   F$Move
         puls  x
         ldd   M$ID,u
         cmpd  #M$ID12
         bne   L0786
         ldd   M$Size,u
         subd  #M$IDSize
         lbsr  L080D
         bcs   L0788
         ldy   <$15,s     get proc desc ptr
         leay  <P$DATImg,y
         tfr   y,d
         ldx   $02,s
         os9   F$VModul
         bcc   L0764
         cmpb  #E$KwnMod
         beq   L076A
         bra   L0788
L0764    ldd   $02,s
         addd  $0A,s
         std   $02,s
L076A    ldd   <$17,s
         bne   L0720
         ldd   MD$MPtr,u
         std   <$11,s
         ldx   ,u
         ldd   ,x
         std   <$17,s
         ldd   $06,u
         addd  #$0001
         beq   L0720
         std   $06,u
         bra   L0720
L0786    ldb   #E$BMID
L0788    stb   $07,s
         ldd   $04,s
         beq   L0790
         std   D.Proc
L0790    lda   $06,s
         beq   L0797
         os9   I$Close
L0797    ldd   $02,s
         addd #DAT.BlSz-1 Round up
         lsra
         lsra
         lsra
         lsra
         sta   $02,s
         ldb   ,s
         beq   L07C4
         lsrb
         lsrb
         lsrb
         lsrb
         subb  $02,s
         beq   L07C4
         ldx   <$15,s
         leax  <P$DATImg,x
         lsla
         leax  a,x
         clra
         tfr   d,y
         ldu   D.BlkMap
L07BC    ldd   ,x++
         clr   d,u
         leay  -$01,y
         bne   L07BC
L07C4    ldx   <$15,s
         lda   P$ID,x
         os9   F$DelPrc
         ldd   <$17,s
         bne   L07D9
         ldb   $07,s
         stb   <$12,s
         comb
         bra   L0808
L07D9    ldu   D.ModDir
         ldx   <$11,s
         ldd   <$17,s
         leau  -MD$ESize,u
L07E3    leau  MD$ESize,u
         cmpu  D.ModEnd
         bcs   L07F2
         comb
         ldb   #E$MNF
         stb   <$12,s
         bra   L0808
L07F2    cmpx  MD$MPtr,u
         bne   L07E3
         cmpd  [MD$MPDAT,u]
         bne   L07E3
         ldd   MD$Link,u
         beq   L0804
         subd  #$0001
         std   MD$Link,u
L0804    stu   <$17,s
         clrb
L0808    leas  <$11,s
         puls  pc,u,y,x,b,a

L080D    pshs  y,x,b,a
         addd  $02,s
         std   $04,s
         cmpd  $08,s
         bls   L086C
         addd #DAT.BlSz-1 Round up
         lsra
         lsra
         lsra
         lsra
         cmpa  #$0F
         bhi   L084C
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
         clrb
L0840    tst   ,y+
         beq   L0851
L0844    addd  #1
         cmpy  D.BlkMap+2
         bne   L0840
L084C    comb
         ldb   #$CF
         bra   L0876
L0851    inc   -1,y
         std   ,u++
         pshs  b,a
         ldd   $0A,s
         addd  #DAT.BlSz
         std   $0A,s
         puls  b,a
         leax  -$01,x
         bne   L0844
         ldx   <$1D,s
         os9   F$SetTsk
         bcs   L0876
L086C    lda   $0E,s
         ldx   $02,s
         ldy   ,s
         os9   I$Read
L0876    leas  $04,s
         puls  pc,x

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

*****
* Enter I/O Queue and perform a timed sleep
* Input: A = Process number
*
FIOQu    ldy   D.Proc
L08D0    lda   P$IOQN,y
         beq   L08EF
         cmpa  $01,u
         bne   L08EA
         clr   P$IOQN,y
         os9   F$GProcP
         bcs   L0932
         clr   $0F,y
         ldb   #$01
         os9   F$Send
         bra   L08F6

L08EA    os9   F$GProcP
         bcc   L08D0
L08EF    lda   $01,u
L08F1    os9   F$GProcP
         bcs   L0932
L08F6    lda   P$IOQN,y
         bne   L08F1
         ldx   D.Proc
         lda   ,x
         sta   P$IOQN,y
         lda   ,y
         sta   $0F,x
         ldx   #$0000
         os9   F$Sleep
         ldu   D.Proc
         lda   P$IOQP,u
         beq   L0930
         os9   F$GProcP
         bcs   L0930
         lda   P$IOQN,y
         beq   L0930
         lda   P$IOQN,u
         sta   P$IOQN,y
         beq   L0930
         clr   P$IOQN,u
         os9   F$GProcP
         bcs   L0930
         lda   P$IOQP,u
         sta   P$IOQP,y
L0930    clr   P$IOQP,u
L0932    rts
         emod
IOEnd      equ   *
