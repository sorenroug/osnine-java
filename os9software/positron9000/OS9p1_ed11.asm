 nam OS-9 Level II V1.2
 ttl Module Header


 use defsfile

Type     set   Systm
Revs     set   ReEnt+8

         mod   OS9End,OS9Name,Type,Revs,0,0

OS9Name     equ   *
         fcs   /OS9p1/
         fcb   11

COLD    ldx   #$0346
         lda   #$03
         clrb
L0019    stx   >$FF80
         sta   >$0000
         leax  $02,x
         incb
         cmpb  #$05
         bne   L0019
         ldu   #$0000
         clrb
L002A    ldx   #$0344
         stx   >$FF80
         lda   b,u
         leax  $04,x
         lslb
         leax  b,x
         lsrb
         stx   >$FF80
         sta   >$0002
         incb
         cmpb  #$04
         bne   L002A
         ldx   #$0144
         stx   >$FF80
         lda   >$0000
         anda  #$E0
         bne   L0080
         ldx   #$0350
         stx   >$FF80
         lda   #$80
         sta   >$0003
         clr   >$0000
         clr   >$0001
         lda   #$8F
         sta   >$0003
         clr   >$0003
         lda   #$14
L006B    deca
         bne   L006B
         lda   #$0F
         sta   >$0003
         ldd   >$0000
         lda   #$90
         sta   >$0003
         lda   #$12
         sta   >$0003
L0080    ldx   #$0300
         ldy   #$0000
L0087    clra
         clrb
         stx   >$FF80
L008C    clr   d,y
         incb
         cmpb  #$50
         bne   L008C
         clrb
         inca
         cmpa  #$08
         bne   L008C
         leax  $01,x
         cmpx  #$0340
         bne   L0087
         ldx   #$0308
         stx   >$FF80
         ldd   #$0702
         std   ,y++
         ldd   #$0401
         std   ,y
         ldx   #$0200
         stx   >$FF80
         ldx   #$0020
         ldy   #$17E0
 clra clear d
 clrb
Cold10    std   ,x++
         leay  -$02,y
         bne   Cold10
         inca
         std   D.Tasks
         addb  #$08
         std   D.TmpDAT
         clrb
         inca
         std   D.BlkMap
         adda  #$02
         std   D.BlkMap+2
         std   D.SysDis
         inca
         std   D.UsrDis
         inca
         std   D.PrcDBT
         inca
         std   D.SysPrc
         std   D.Proc
         adda  #$02
         tfr   d,s
         inca
         std   D.SysStk
         std   D.SysMem
         inca
         std   D.ModDir
         std   D.ModEnd
         adda  #$07
         std   D.ModDir+2
         std   D.ModDAT
 leax IntXfr,pcr get interrupt transfer
         tfr   x,d
         ldx   #$00F2
Cold14    std   ,x++
         cmpx  #$00FC
         bls   Cold14
         leax  >ROMEnd,pcr
         pshs  x
         leay  >HdlrVec,pcr
         ldx   #$00E0
Cold15    ldd   ,y++
         addd  ,s
         std   ,x++
         cmpx  #$00EC
         bls   Cold15
         leas  $02,s
         ldx   D.XSWI2
         stx   D.UsrSvc
         ldx   D.XIRQ
         stx   D.UsrIRQ
         leax  >SysSvc,pcr
         stx   D.SysSvc
         stx   D.XSWI2
         leax  >SysIRQ,pcr
         stx   D.SysIRQ
         stx   D.XIRQ
         leax  >GoPoll,pcr
         stx   D.SvcIRQ
         leax  >IOPoll,pcr
         stx   D.POLL
         leay  >SvcTbl,pcr
         lbsr  SetSvc
         ldu   D.PrcDBT
         ldx   D.SysPrc
         stx   ,u
         stx   $01,u
         lda   #$01
         sta   ,x
         lda   #$80
         sta   $0C,x
         lda   #$80
         sta   D.SysTsk
         sta   $06,x
         lda   #$FF
         sta   $0A,x
         sta   $0B,x
         leax  <$40,x
         stx   D.SysDAT
         ldd   #$0200
         std   ,x++
         incb
         std   ,x++
         incb
         std   ,x++
         ldy   #$0019
         ldd   #$015F
Cold16    std   ,x++
         leay  -$01,y
         bne   Cold16
         ldd   #$0350
         std   ,x++
         ldd   #$0340
         std   ,x++
         ldd   #$01FE
L0190    std   ,x++
         incb
         bne   L0190
         ldx   D.Tasks
         inc   ,x
         inc   $01,x
         ldx   D.SysMem
         ldb   D.ModDir+2
Cold17    inc   ,x+
         decb
         bne   Cold17
         ldy   #$1800
         ldx   D.BlkMap
L01AA    pshs  x
         ldd   ,s
         subd  D.BlkMap
         cmpd  #$0100
         bcc   Cold30
         ora   #$02
         std   >$FF86
 ldu 0,y get current contents
 ldx #$00FF get first test pattern
 stx 0,Y store it
         cmpx  ,y
         bne   Cold30
         ldx   #$FF00
         stx   ,y
         cmpx  ,y
         bne   Cold30
         stu   ,y
         bra   L01D7
Cold30    ldb   #$80
         stb   [,s]
L01D7    puls  x
         leax  $01,x
         cmpx  D.BlkMap+2
         bcs   L01AA
         ldx   D.BlkMap
         inc   ,x
         inc   $01,x
         inc   $02,x
         ldx   D.BlkMap+2
         leax  >-$0040,x
L01ED    lda   ,x
         beq   L0248
         tfr   x,d
         subd  D.BlkMap
         cmpd  #$015F
         beq   L0248
         leas  <-$40,s
         leay  ,s
         bsr   MovDAT
         pshs  x
         ldx   #$0000
L0207    pshs  y,x
         lbsr  AdjImg
         ldd   ,y
         std   >$FF80
         lda   ,x
         ldx   #$0200
         stx   >$FF80
         puls  y,x
         cmpa  #$87
         bne   L0232
         lbsr  ValMod
         bcc   L0228
         cmpb  #$E7
         bne   L0232
L0228    ldd   #$0002
         lbsr  LDDDXY
         leax  d,x
         bra   L0234
L0232    leax  $01,x
L0234    tfr   x,d
         tstb
         bne   L0207
         bita  #$07
         bne   L0207
         lsra
         lsra
L023F    lsra
         deca
         puls  x
         leax  a,x
         leas  <$40,s
L0248    leax  $01,x
         cmpx  D.BlkMap+2
         bcs   L01ED
Cold.z1    leax  >InitName,pcr
         bsr   LinkSys
         bcc   Cold.z2
         os9   F$Boot
         bcc   Cold.z1
         bra   ColdErr
Cold.z2    stu   D.Init
Cold.z3    leax  >P2Name,pcr
         bsr   LinkSys
         bcc   Cold.xit
         os9   F$Boot
         bcc   Cold.z3

ColdErr    jmp   [>$FFFE]

Cold.xit    jmp   ,y
LinkSys    lda   #$C0
         os9   F$Link
         rts

MovDAT    pshs  y,x,b,a
         ldb   #$20
         ldx   ,s
L027E    stx   ,y++
         leax  $01,x
         decb
         bne   L027E
         puls  pc,y,x,b,a

 ttl Coldstart Constants
 page
************************************************************
*
*     Service Routines Initialization Table
*
SvcTbl equ *
 fcb F$Link
 fdb Link-*-2
 fcb F$PRSNAM
 fdb PNam-*-2
 fcb F$CmpNam
 fdb UCNam-*-2
 fcb F$CmpNam+SysState
 fdb SCNam-*-2
 fcb F$CRC
 fdb CRCGen-*-2
 fcb F$SRqMem+SysState
 fdb SRqMem-*-2
 fcb F$SRtMem+SysState
 fdb SRtMem-*-2
 fcb F$AProc+SysState
 fdb AProc-*-2
 fcb F$NProc+SysState
 fdb NextProc-*-2
 fcb F$VModul+SysState
 fdb VModule-*-2
 fcb F$SSvc
 fdb SSvc-*-2
 fcb F$SLink+SysState
 fdb SLink-*-2
 fcb F$Boot+SysState
 fdb Boot-*-2
 fcb F$BtMem+SysState
 fdb SRqMem-*-2
 fcb F$Move+SysState
 fdb Move-*-2
 fcb F$AllRAM
 fdb AllRAM-*-2
 fcb F$AllImg+SysState
 fdb AllImg-*-2
 fcb F$SetImg+SysState
 fdb SetImg-*-2
 fcb F$FreeLB+SysState
 fdb FreeLB-*-2
 fcb F$FreeHB+SysState
 fdb FreeHB-*-2
 fcb F$AllTsk+SysState
 fdb AllTsk-*-2
 fcb F$DelTsk+SysState
 fdb DelTsk-*-2
 fcb F$SetTsk+SysState
 fdb SetTsk-*-2
 fcb F$ResTsk+SysState
 fdb ResTsk-*-2
 fcb F$RelTsk+SysState
 fdb RelTsk-*-2
 fcb F$DATLog+SysState
 fdb DATLog-*-2
 fcb F$LDAXY+SysState
 fdb F.LDAXY-*-2
 fcb F$LDDDXY+SysState
 fdb F.LDDDXY-*-2
 fcb F$LDABX+SysState
 fdb F.LDABX-*-2
 fcb F$STABX+SysState
 fdb F.STABX-*-2
 fcb F$ELink+SysState
 fdb ELink-*-2
 fcb F$FModul+SysState
 fdb FMod-*-2
 fcb $80
************************************************************
*
*     Module Names
*
InitName fcs "Init"
P2Name fcs "OS9p2"
BootName fcs "Boot"

IntXfr      fdb $6E98
         subb  >$9E50
         ldu   <$17,x
         beq   UserSvc

UsrSWI10    lbra  PassSWI
         ldx   D.Proc
         ldu   <$15,x
         beq   UserSvc
         bra   UsrSWI10
         ldx   D.Proc
         ldu   <$13,x
         bne   UsrSWI10

UserSvc    ldd   D.SysSvc
         std   D.XSWI2
         ldd   D.SysIRQ
         std   D.XIRQ
         lda   $0C,x
         ora   #$80
         sta   $0C,x
         sts   $04,x
         leas  >$01F4,x
         andcc #$AF
         leau  ,s
         bsr   L034F
         ldb   $06,x
         ldx   $0A,u
         lbsr  L0CCB
         leax  $01,x
         stx   $0A,u
         ldy   D.UsrDis
         lbsr  Dispatch
         ldb   ,u
         andb  #$AF
         stb   ,u
         ldx   D.Proc
         bsr   L035E
         lda   $0C,x
         anda  #$7F
         lbra  L0E02
L034F    pshs  u,y,x,cc
         ldb   $06,x
         ldx   $04,x
         lbsr  L0C6F
         leax  >-$2000,x
         bra   L036D
L035E    pshs  u,y,x,cc
         ldb   $06,x
         ldx   $04,x
         lbsr  L0C6F
         leax  >-$2000,x
         exg   x,u
L036D    pshs  u
         ldu   #$FF80
         leau  a,u
         orcc  #$50
         stb   >$FFCA
         pulu  y,b,a
         clr   >$FFCA
         ldu   #$FFBC
         pshu  y,b,a
         puls  u
         ldy   #$000C
L0389    ldd   ,x++
         std   ,u++
         leay  -$02,y
         bne   L0389
         ldx   D.SysDAT
         ldd   <$38,x
         std   >$FFB8
         ldd   <$3A,x
         std   >$FFBA
         puls  pc,u,y,x,cc

SysSvc    leau  ,s
         lda   ,u
         tfr   a,cc
         ldx   $0A,u
         ldb   ,x+
         stx   $0A,u
         ldy   D.SysDis
         bsr   Dispatch
         lbra  SysRet

Dispatch    lslb
         bcc   L03BF
         rorb
         ldx   >$00FE,y
         bra   L03C9
L03BF    clra
         ldx   d,y
         bne   L03C9
         comb
         ldb   #$D0
         bra   L03CF
L03C9    pshs  u
         jsr   ,x
         puls  u
L03CF    tfr   cc,a
         bcc   L03D5
         stb   $02,u
L03D5    ldb   ,u
         andb  #$D0
         stb   ,u
         anda  #$2F
         ora   ,u
         sta   ,u
         rts

SSvc     ldy   $06,u
         bra   SetSvc

L03E7    clra
         lslb
         tfr   d,u
         ldd   ,y++
         leax  d,y
         ldd   D.SysDis
         stx   d,u
         bcs   SetSvc
         ldd   D.UsrDis
         stx   d,u
SetSvc    ldb   ,y+
         cmpb  #$80
         bne   L03E7
         rts

SLink    ldy   $06,u
         bra   SysLink

ELink    pshs  u
         ldb   $02,u
         ldx   $04,u
         bra   EntLink

Link     ldx   D.Proc
         leay  <$40,x
SysLink    pshs  u
         ldx   $04,u
         lda   $01,u
         lbsr  FModule
         lbcs  LinkErr
         leay  ,u
         ldu   ,s
         stx   $04,u
         std   $01,u
         leax  ,y
EntLink    bitb  #$80
         bne   L0435
         ldd   $06,x
         beq   L0435
         ldb   #$D1
         bra   LinkErr
L0435    ldd   $04,x
         pshs  x,b,a
         ldy   ,x
         ldd   $02,x
         addd  #$07FF
         tfr   a,b
         lsrb
         lsrb
         lsrb
         pshs  b
         leau  ,y
         bsr   SrchPDAT
         bcc   L0479
         lbsr  FreeHBlk
         bcc   L0459
         leas  $05,s
         ldb   #$CF
         bra   LinkErr
L0459    lbsr  SetImage
         pshs  u,b,a
         lsla
         leau  a,y
         ldy   $09,s
         lda   $02,y
         bita  #$40
         beq   L0477
         clra
         tfr   d,y
L046D    ldd   ,u
         ora   #$02
         std   ,u++
         leay  -$01,y
         bne   L046D
L0477    puls  u,b,a
L0479    leax  >$0080,x
         sta   ,s
         lsla
         leau  a,x
         ldx   ,u
         leax  $01,x
         beq   L048A
         stx   ,u
L048A    ldu   $03,s
         ldx   $06,u
         leax  $01,x
         beq   L0494
         stx   $06,u
L0494    puls  u,y,x,b
         lbsr  DATtoLog
         stx   $08,u
         ldx   $04,y
         ldy   ,y
         ldd   #$0009
         lbsr  LDDDXY
         addd  $08,u
         std   $06,u
         clrb
         rts
LinkErr    orcc  #$01
         puls  pc,u

SrchPDAT    ldx   D.Proc
         leay  <$40,x

SrchDAT  clra
         pshs  y,x,b,a
         subb  #$20
         negb
         lslb
         leay  b,y
L04BE    ldx   ,s
         pshs  u,y
L04C2    ldd   ,y++
         anda  #$01
         cmpd  ,u++
         bne   SrchD30
         leax  -$01,x
         bne   L04C2
         puls  u,b,a
         subd  $04,s
         lsrb
         stb   ,s
         clrb
         puls  pc,y,x,b,a
SrchD30    puls  u,y
         leay  -$02,y
         cmpy  $04,s
         bcc   L04BE
         puls  pc,y,x,b,a

VModule  pshs  u
         ldx   $04,u
         ldy   $01,u
         bsr   ValMod
         ldx   ,s
         stu   $08,x
         puls  pc,u

ValMod    pshs  y,x
         lbsr  ModCheck
         bcs   L0523
         ldd   #$0006
         lbsr  LDDDXY
         andb  #$0F
         pshs  b,a
         ldd   #$0004
         lbsr  LDDDXY
         leax  d,x
         puls  a
         lbsr  FModule
         puls  a
         bcs   ValMod20
         pshs  a
         andb  #$0F
         subb  ,s+
         bcs   ValMod20
         ldb   #$E7
         bra   L0523
L0521    ldb   #$CE
L0523    orcc  #$01
         puls  pc,y,x
ValMod20    ldx   ,s
         lbsr  SetMoImg
         bcs   L0521
         sty   ,u
         stx   $04,u
         clra
         clrb
         std   $06,u
         ldd   #$0002
         lbsr  LDDDXY
         pshs  x
         addd  ,s++
         std   $02,u
         ldy   [,u]
         ldx   D.ModDir
         pshs  u
         bra   L054E
L054C    leax  $08,x
L054E    cmpx  D.ModEnd
         bcc   ValMod55
         cmpx  ,s
         beq   L054C
         cmpy  [,x]
         bne   L054C
         bsr   FreDATI
ValMod55    puls  u
         ldx   D.BlkMap
         ldd   $02,u
         addd  #$07FF
         lsra
         lsra
         lsra
         ldy   ,u
L056C    pshs  x,a
         ldd   ,y++
         leax  d,x
         ldb   ,x
         orb   #$02
         stb   ,x
         puls  x,a
         deca
         bne   L056C
         clrb
         puls  pc,y,x

FreDATI    pshs  u,y,x,b,a
         ldx   ,x
         pshs  x
         clra
         clrb
L0588    ldy   ,x
         beq   L0591
         std   ,x++
         bra   L0588
L0591    puls  x
         ldy   $02,s
         ldu   ,u
         puls  b,a
L059A    cmpx  ,y
         bne   L05A9
         stu   ,y
         cmpd  $02,y
         bcc   L05A7
         ldd   $02,y
L05A7    std   $02,y
L05A9    leay  $08,y
         cmpy  D.ModEnd
         bne   L059A
         puls  pc,u,y,x

SetMoImg    pshs  u,y,x
         ldd   #$0002
         lbsr  LDDDXY
         addd  ,s
         addd  #$07FF
         lsra
         lsra
         lsra
         tfr   a,b
         pshs  b
         incb
         lslb
         negb
         sex
         bsr   chkspce
         bcc   L05D8
         os9   F$GCMDir
         ldu   #$0000
         stu   $05,s
         bsr   chkspce
L05D8    puls  pc,u,y,x,b

chkspce    ldx   D.ModDAT
         leax  d,x
         cmpx  D.ModEnd
         bcs   L060F
         ldu   $07,s
         bne   L05FA
         pshs  x
         ldy   D.ModEnd
         leay  $08,y
         cmpy  ,s++
         bhi   L060F
         sty   D.ModEnd
         leay  -$08,y
         sty   $07,s
L05FA    stx   D.ModDAT
         ldy   $05,s
         ldb   $02,s
         stx   $05,s
L0603    ldu   ,y++
         stu   ,x++
         decb
         bne   L0603
         clr   ,x
         clr   $01,x
         rts
L060F    orcc  #$01
         rts

ModCheck    pshs  y,x
         clra
         clrb
         lbsr  LDDDXY
         cmpd  #$87CD
         beq   L0623
         ldb   #$CD
         bra   L067F
L0623    leas  -$01,s
         leax  $02,x
         lbsr  AdjImg
         ldb   #$07
         lda   #$4A
L062E    sta   ,s
         lbsr  LDAXYP
         eora  ,s
         decb
         bne   L062E
         leas  $01,s
         inca
         beq   L0641
         ldb   #$EC
         bra   L067F
L0641    puls  y,x
         ldd   #$0002
         lbsr  LDDDXY
         pshs  y,x,b,a
         ldd   #$FFFF
         pshs  b,a
         pshs  b
         lbsr  AdjImg
         leau  ,s
L0657    tstb
         bne   L0664
         pshs  x
         ldx   #$0001
         os9   F$Sleep
         puls  x
L0664    lbsr  LDAXYP
         bsr   CRCCal
         ldd   $03,s
         subd  #$0001
         std   $03,s
         bne   L0657
         puls  y,x,b
         cmpb  #$80
         bne   L067D
         cmpx  #$0FE3
         beq   L0681
L067D    ldb   #$E8
L067F    orcc  #$01
L0681    puls  pc,y,x

CRCCal    eora  ,u
         pshs  a
         ldd   $01,u
         std   ,u
         clra
         ldb   ,s
         lslb
         rola
         eora  $01,u
         std   $01,u
         clrb
         lda   ,s
         lsra
         rorb
         lsra
         rorb
         eora  $01,u
         eorb  $02,u
         std   $01,u
         lda   ,s
         lsla
         eora  ,s
         sta   ,s
         lsla
         lsla
         eora  ,s
         sta   ,s
         lsla
         lsla
         lsla
         lsla
         eora  ,s+
         bpl   L06C1
         ldd   #$8021
         eora  ,u
         sta   ,u
         eorb  $02,u
         stb   $02,u
L06C1    rts

CRCGen   ldd   $06,u
         beq   L0703
         ldx   $04,u
         pshs  x,b,a
         leas  -$03,s
         ldx   D.Proc
         lda   $06,x
         ldb   D.SysTsk
         ldx   $08,u
         ldy   #$0003
         leau  ,s
         pshs  y,x,b,a
         lbsr  Mover
         ldx   D.Proc
         leay  <$40,x
         ldx   $0B,s
         lbsr  AdjImg
L06E9    lbsr  LDAXYP
         lbsr  CRCCal
         ldd   $09,s
         subd  #$0001
         std   $09,s
         bne   L06E9
         puls  y,x,b,a
         exg   a,b
         exg   x,u
         lbsr  Mover
         leas  $07,s
L0703    clrb
         rts

FMod     pshs  u
         lda   $01,u
         ldx   $04,u
         ldy   $06,u
         bsr   FModule
         puls  y
         std   $01,y
         stx   $04,y
         stu   $08,y
         rts
FModule    ldu   #$0000
         pshs  u,b,a
         bsr   SkipSpc
         cmpa  #$2F
         beq   L0798
         lbsr  PrsNam
         bcs   L079B
         ldu   D.ModDir
         bra   L078E
L072D    pshs  y,x,b,a
         pshs  y,x
         ldy   ,u
         beq   L0782
         ldx   $04,u
         pshs  y,x
         ldd   #$0004
         lbsr  LDDDXY
         leax  d,x
         pshs  y,x
         leax  $08,s
         ldb   $0D,s
         leay  ,s
         lbsr  ChkNam
         leas  $04,s
         puls  y,x
         leas  $04,s
         bcs   L078A
         ldd   #$0006
         lbsr  LDDDXY
         sta   ,s
         stb   $07,s
         lda   $06,s
         beq   L0779
         anda  #$F0
         beq   L076D
         eora  ,s
         anda  #$F0
         bne   L078A
L076D    lda   $06,s
         anda  #$0F
         beq   L0779
         eora  ,s
         anda  #$0F
         bne   L078A
L0779    puls  y,x,b,a
         abx
         clrb
         ldb   $01,s
         leas  $04,s
         rts

L0782    leas  $04,s
         ldd   $08,s
         bne   L078A
         stu   $08,s
L078A    puls  y,x,b,a
         leau  $08,u
L078E    cmpu  D.ModEnd
         bcs   L072D
         comb
         ldb   #$DD
         bra   L079B
L0798    comb
         ldb   #$EB
L079B    stb   $01,s
         puls  pc,u,b,a

SkipSpc    pshs  y
L07A1    lbsr  AdjImg
         lbsr  LDAXY
         leax  $01,x
         cmpa  #$20
         beq   L07A1
         leax  -$01,x
         pshs  a
         tfr   y,d
         subd  $01,s
         asrb
         lbsr  DATtoLog
         puls  pc,y,a

PNam     ldx   D.Proc
         leay  <$40,x
         ldx   $04,u
         bsr   PrsNam
         std   $01,u
         bcs   L07CB
         stx   $04,u
         abx
L07CB    stx   $06,u
         rts

PrsNam    pshs  y
         lbsr  AdjImg
         pshs  y,x
         lbsr  LDAXYP
         cmpa  #$2F
         bne   L07E3
         leas  $04,s
         pshs  y,x
         lbsr  LDAXYP
L07E3    bsr   Alpha
         bcs   L07F7
         clrb
L07E8    incb
         tsta
         bmi   L07F3
         lbsr  LDAXYP
         bsr   AlphaNum
         bcc   L07E8
L07F3    andcc #$FE
         bra   L0809
L07F7    cmpa  #$2C
         bne   L0802
L07FB    leas  $04,s
         pshs  y,x
         lbsr  LDAXYP
L0802    cmpa  #$20
         beq   L07FB
         comb
         ldb   #$EB
L0809    puls  y,x
         pshs  b,a,cc
         tfr   y,d
         subd  $03,s
         asrb
         lbsr  DATtoLog
         puls  pc,y,b,a,cc

AlphaNum    pshs  a
         anda  #$7F
         cmpa  #$2E
         beq   L082B
         cmpa  #$30
         bcs   L0842
         cmpa  #$39
         bls   L082B
         cmpa  #$5F
         bne   L0832
L082B    clra
         puls  pc,a
Alpha    pshs  a
         anda  #$7F
L0832    cmpa  #$41
         bcs   L0842
         cmpa  #$5A
         bls   L082B
         cmpa  #$61
         bcs   L0842
         cmpa  #$7A
         bls   L082B
L0842    coma
         puls  pc,a

UCNam    ldx   D.Proc
         leay  <$40,x
         ldx   $04,u
         pshs  y,x
         bra   L085C


SCNam    ldx   D.Proc
         leay  <$40,x
         ldx   $04,u
         pshs  y,x
         ldy   D.SysDAT
L085C    ldx   $06,u
         pshs  y,x
         ldd   $01,u
         leax  $04,s
         leay  ,s
         bsr   ChkNam
         leas  $08,s
         rts

ChkNam    pshs  u,y,x,b,a
         ldu   $02,s
         pulu  y,x
         lbsr  AdjImg
         pshu  y,x
         ldu   $04,s
         pulu  y,x
         lbsr  AdjImg
         bra   L0883
L087F    ldu   $04,s
         pulu  y,x
L0883    lbsr  LDAXYP
         pshu  y,x
         pshs  a
         ldu   $03,s
         pulu  y,x
         lbsr  LDAXYP
         pshu  y,x
         eora  ,s
         tst   ,s+
         bmi   L08A3
         decb
         beq   L08A0
         anda  #$DF
         beq   L087F
L08A0    comb
         puls  pc,u,y,x,b,a
L08A3    decb
         bne   L08A0
         anda  #$5F
         bne   L08A0
         clrb
         puls  pc,u,y,x,b,a

SRqMem   ldd   $01,u
         addd  #$00FF
         clrb
         std   $01,u
         ldy   D.SysMem
         leas  -$02,s
         stb   ,s
L08BC    ldx   D.SysDAT
         lslb
         ldd   b,x
         cmpd  #$015F
         beq   L08D5
         ldx   D.BlkMap
         anda  #$01
         lda   d,x
         cmpa  #$01
         bne   L08D6
         leay  $08,y
         bra   L08DD
L08D5    clra
L08D6    ldb   #$08
L08D8    sta   ,y+
         decb
         bne   L08D8
L08DD    inc   ,s
         ldb   ,s
         cmpb  #$20
         bcs   L08BC
L08E5    ldb   $01,u
L08E7    cmpy  D.SysMem
         bhi   L08F1
         comb
         ldb   #$CF
         bra   L091E
L08F1    lda   ,-y
         bne   L08E5
         decb
         bne   L08E7
         sty   ,s
         lda   $01,s
         lsra
         lsra
         lsra
         ldb   $01,s
         andb  #$07
         addb  $01,u
         addb  #$07
         lsrb
         lsrb
         lsrb
         ldx   D.SysPrc
         lbsr  AllImage
         bcs   L091E
         ldb   $01,u
L0914    inc   ,y+
         decb
         bne   L0914
         lda   $01,s
         std   $08,u
         clrb
L091E    leas  $02,s
         rts

SRtMem   ldd   $01,u
         beq   SrTM.F
         addd  #$00FF
         ldb   $09,u
         beq   L0930
         comb
         ldb   #$D2
         rts
L0930    ldb   $08,u
         beq   SrTM.F
         ldx   D.SysMem
         abx
L0937    ldb   ,x
         andb  #$FE
         stb   ,x+
         deca
         bne   L0937
         ldx   D.SysDAT
         ldy   #$0020
L0946    ldd   ,x
         cmpd  #$015F
         beq   L0978
         ldu   D.BlkMap
         anda  #$01
         lda   d,u
         cmpa  #$01
         bne   L0978
         tfr   x,d
         subd  D.SysDAT
         lslb
         lslb
         ldu   D.SysMem
         leau  d,u
         ldb   #$08
L0964    lda   ,u+
         bne   L0978
         decb
         bne   L0964
         ldd   ,x
         ldu   D.BlkMap
         anda  #$01
         clr   d,u
         ldd   #$015F
         std   ,x
L0978    leax  $02,x
         leay  -$01,y
         bne   L0946
SrTM.F   clrb
         rts

Boot         comb
         lda   D.Boot $0031
         bne   BootXX
         inc   D.Boot
         ldx   D.Init
         beq   L0994
         ldd   <$14,x
         beq   L0994
         leax  d,x
         bra   L0998
L0994    leax BootName,pcr
L0998    lda   #$C1
         os9   F$Link
         bcs   BootXX
         jsr   ,y
         bcs   BootXX
         leau  d,x
         tfr   x,d
         anda  #$F8
         clrb
         pshs  u,b,a
         lsra
         lsra
         ldy   D.SysDAT
         leay  a,y
L09B3    ldd   ,x
         cmpd  #$87CD
         bne   L09DC
         tfr   x,d
         subd  ,s
         tfr   d,x
         tfr   y,d
         anda  #$FD
         os9   F$VModul
         pshs  b
         ldd   $01,s
         leax  d,x
         puls  b
         bcc   L09D6
         cmpb  #$E7
         bne   L09DC
L09D6    ldd   $02,x
         leax  d,x
         bra   L09DE
L09DC    leax  $01,x
L09DE    cmpx  $02,s
         bcs   L09B3
         leas  $04,s
BootXX    rts

AllRAM   ldb   $02,u
         bsr   RAMBlk
         bcs   L09ED
         std   $01,u
L09ED    rts

RAMBlk    pshs  y,x,b,a
         ldx   D.BlkMap
L09F2    leay  ,x
         ldb   $01,s
L09F6    cmpx  D.BlkMap+2
         bcc   RAMBlk30
         lda   ,x+
         bne   L09F2
         decb
         bne   L09F6
         tfr   y,d
         subd  D.BlkMap
         sta   ,s
         lda   $01,s
         stb   $01,s
L0A0B    inc   ,y+
         deca
         bne   L0A0B
         clrb
         puls  pc,y,x,b,a
RAMBlk30    comb
         ldb   #$ED
         stb   $01,s
         puls  pc,y,x,b,a

AllImg   ldd   $01,u
         ldx   $04,u


AllImage    pshs  u,y,x,b,a
         lsla
         leay  <$40,x
         leay  a,y
         clra
         tfr   d,x
         ldu   D.BlkMap
         pshs  u,y,x,b,a
L0A2D    ldd   ,y++
         cmpd  #$015F
         beq   AllI.B
         anda  #$01
         lda   d,u
         cmpa  #$01
         puls  b,a
         bne   L0A59
         subd  #$0001
         pshs  b,a
AllI.B    leax  -$01,x
         bne   L0A2D
         ldx   ,s++
         beq   AllI.E
AllI.C    lda   ,u+
         bne   L0A54
         leax  -$01,x
         beq   AllI.E
L0A54    cmpu  D.BlkMap+2
         bcs   AllI.C
L0A59    ldb   #$CF
         leas  $06,s
         stb   $01,s
         comb
         puls  pc,u,y,x,b,a
AllI.E    puls  u,y,x
AllI.F    ldd   ,y++
         cmpd  #$015F
         bne   AllI.H
L0A6C    lda   ,u+
         bne   L0A6C
         inc   ,-u
         tfr   u,d
         subd  D.BlkMap
         ora   #$02
         std   -$02,y
AllI.H    leax  -$01,x
         bne   AllI.F
         ldx   $02,s
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         clrb
         puls  pc,u,y,x,b,a

***********************************************************
*
*     Subroutine FreeHB
*
*   Free High Block Service routine
*
* Input: U = registers ptr
*
* Output: Carry clear if successful; set otherwise
*
* Data: none
*
* Calls: FreeHBlk
*
FreeHB    ldb   $02,u
         ldy   $06,u
         bsr   FreeHBlk
         bcs   L0A94
         sta   $01,u
L0A94    rts

FreeHBlk    tfr   b,a
         suba  #$21
         nega
         pshs  x,b,a
         ldd   #$FFFF
         pshs  b,a
         bra   FreeBlk

FreeLB   ldb   $02,u
         ldy   $06,u
         bsr   FreeLBlk
         bcs   FrLB10
         sta   $01,u
FrLB10    rts

FreeLBlk    lda   #$FF
         pshs  x,b,a
         lda   #$01
         subb  #$21
         negb
         pshs  b,a
         bra   FreeBlk

FreeBlk    clra
         ldb   $02,s
         addb  ,s
         stb   $02,s
         cmpb  $01,s
         bne   L0AD2
         ldb   #$CF
         stb   $03,s
         comb
         bra   FreeBXit
L0ACE    tfr   a,b
         addb  $02,s
L0AD2    lslb
         ldx   b,y
         cmpx  #$015F
         bne   FreeBlk
         inca
         cmpa  $03,s
         bne   L0ACE
FreeBXit    leas  $02,s
         puls  pc,x,b,a

SetImg   ldd   $01,u
         ldx   $04,u
         ldu   $08,u

SetImage    pshs  u,y,x,b,a
         leay  <$40,x
         lsla
         leay  a,y
L0AF1    ldx   ,u++
         stx   ,y++
         decb
         bne   L0AF1
         ldx   $02,s
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         clrb
         puls  pc,u,y,x,b,a

DATLog   ldb   $02,u
         ldx   $04,u
         bsr   DATtoLog
         stx   $04,u
         clrb
         rts

DATtoLog    pshs  x,b,a
         lslb
         lslb
         lslb
         addb  $02,s
         stb   $02,s
         puls  pc,x,b,a

F.LDAXY        ldx   $04,u
         ldy   $06,u
         bsr   LDAXY
         sta   $01,u
         clrb
         rts



***********************************************************
*
*     Subroutine LDAXY
*
*   Load A register from X offset of Y block
*
* Input: X = Block offset
*        Y = DAT Image ptr
*
* Output: A = [X,Y]
*
* Data: none
*
* Calls: none
*
LDAXY    pshs  x,b,cc
         ldd   ,y
         orcc  #$50
         std   >$FF80
         lda   ,x
         ldx   #$0200
         stx   >$FF80
         puls  pc,x,b,cc
 page
***********************************************************
*
*     Subroutine LDAXYP
*
*   Load A register from X offset of Y block; post increment
*
* Input: X = Block offset
*        Y = DAT Image ptr
*
* Output: A = [X,Y]
*         X,Y updated
*
* Data: none
*
* Calls: AdjImg
*
LDAXYP    pshs  x,b,cc
         ldd   ,y
         orcc  #$50
         std   >$FF80
         lda   ,x
         ldx   #$0200
         stx   >$FF80
         puls  x,b,cc
         leax  $01,x
         bra   AdjImg

AdjImg10    leax  >-$0800,x
         leay  $02,y
AdjImg    cmpx  #$0800
         bcc   AdjImg10
         rts

F.LDDDXY ldd   $01,u
         leau  $04,u
         pulu  y,x
         bsr   LDDDXY
         std   -$07,u
         clrb
         rts


***********************************************************
*
*     Subroutine LDDDXY
*
*   Load D register from X+D offset of Y block
*
* Input: D = Address offset
*        X = Block offset
*        Y = DAT Image ptr
*
* Output: D = [D+X,Y]
*
* Data: none
*
* Calls: AdjImg, LDAXYP, LDAXY
*
LDDDXY    pshs  y,x
         leax  d,x
         lbsr  L0C6F
         leay  a,y
         bsr   LDAXYP
         pshs  a,cc
         ldd   ,y
         orcc  #$50
         std   >$FF80
         ldb   ,x
         ldx   #$0200
         stx   >$FF80
         puls  pc,y,x,a,cc

F.LDABX ldb R$B,u get task number
         ldx   $04,u
         lbsr  LDABX
         sta   $01,u
         rts

F.STABX ldd R$D,u get data & task number
         ldx   $04,u
         lbra  STABX

Move     ldd   $01,u
         ldx   $04,u
         ldy   $06,u
         ldu   $08,u
*
*     fall through to Mover
*
***********************************************************
*
*     Subroutine Mover
*
*   Move data from one task to another
*
* Input: A = Source Task number
*        B = Destination Task number
*        X = Source ptr
*        Y = Byte count
*        U = Destination ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: Mover00
*
Mover    pshs  u,y,x,b,a
         leay  ,y
         lbeq  MoveNone
         pshs  y,b,a
         ldu   #$FF80
         lbsr  L0C6F
         leay  a,u
         pshs  y,x
         ldx   $0E,s
         lbsr  L0C6F
         leay  a,u
         pshs  y,x
         ldd   #$0800
         subd  ,s
         pshs  b,a
         ldd   #$0800
         subd  $06,s
         pshs  b,a
         ldx   $08,s
         leax  >-$2000,x
         ldu   $04,s
         leau  >-$1800,u
L0BD4    pshs  cc
         orcc  #$50
         lda   <$11,s
         sta   >$FFCA
         ldd   [<$0B,s]
         clr   >$FFCA
         std   >$FFB8
         lda   <$12,s
         sta   >$FFCA
         ldd   [<$07,s]
         clr   >$FFCA
         std   >$FFBA
         ldd   $0F,s
         cmpd  $01,s
         bls   L0BFF
         ldd   $01,s
L0BFF    cmpd  $03,s
         bls   L0C06
         ldd   $03,s
L0C06    cmpd  #$0040
         bls   L0C0F
         ldd   #$0040
L0C0F    std   $0D,s
         lsra
         rorb
         tfr   d,y
         bcc   L0C1F
         lda   ,x+
         sta   ,u+
         leay  ,y
         beq   L0C27
L0C1F    ldd   ,x++
         std   ,u++
         leay  -$01,y
         bne   L0C1F
L0C27    ldy   D.SysDAT
         ldd   <$38,y
         std   >$FFB8
         ldd   <$3A,y
         std   >$FFBA
         puls  cc
         ldd   $0E,s
         subd  $0C,s
         beq   L0C69
         std   $0E,s
         ldd   ,s
         subd  $0C,s
         bne   L0C51
         ldd   #$0800
         leax  >-$0800,x
         inc   $0B,s
         inc   $0B,s
L0C51    std   ,s
         ldd   $02,s
         subd  $0C,s
         bne   L0C64
         ldd   #$0800
         leau  >-$0800,u
         inc   $07,s
         inc   $07,s
L0C64    std   $02,s
         lbra  L0BD4
L0C69    leas  <$10,s
MoveNone    clrb
         puls  pc,u,y,x,b,a

L0C6F    pshs  b
         tfr   x,d
         anda  #$F8
         beq   L0C7F
         exg   d,x
         anda  #$07
         exg   d,x
         lsra
         lsra
L0C7F    puls  pc,b
LDABX    andcc #$FE
         pshs  u,x,b,cc
         bsr   L0C6F
         ldu   #$FF80
         orcc  #$50
         stb   >$FFCA
         ldu   a,u
         ldb   D.SysTsk
         stb   >$FFCA
         stu   >$FF80
         lda   ,x
         ldu   #$0200
         stu   >$FF80
         puls  pc,u,x,b,cc
STABX    andcc #$FE
         pshs  u,x,b,a,cc
         bsr   L0C6F
         ldu   #$FF80
         orcc  #$50
         stb   >$FFCA
         ldd   a,u
         ora   #$02
         tfr   d,u
         ldb   D.SysTsk
         stb   >$FFCA
         lda   $01,s
         stu   >$FF80
         sta   ,x
         ldu   #$0200
         stu   >$FF80
         puls  pc,u,x,b,a,cc

L0CCB    andcc #$FE
         pshs  u,x,a,cc
         bsr   L0C6F
         ldu   #$FF80
         orcc  #$50
         stb   >$FFCA
         ldu   a,u
         ldb   D.SysTsk
         stb   >$FFCA
         stu   >$FF80
         ldb   ,x
         ldu   #$0200
         stu   >$FF80
         puls  pc,u,x,a,cc

AllTsk      ldx   $04,u
*
*     fall through to AllPrTsk
*
***********************************************************
*
*     Subroutine AllPrTsk
*
*   Allocate process task number
*
* Input: X = Process ptr
*
* Output: carry clear if successful; set otherwise
*
* Data: none
*
* Calls: ResvTask, SetPrTsk
*
AllPrTsk    ldb   $06,x
         bne   L0CFB
         bsr   ResvTask
         bcs   AllPrXit
         stb   $06,x
         bsr   SetPrTsk
L0CFB    clrb
AllPrXit    rts

DelTsk        ldx   $04,u
DelPrTsk    ldb   $06,x
         beq   AllPrXit
         clr   $06,x
         bra   L0D5E

ChkPrTsk    lda   $0C,x
         bita  #$10
         bne   SetPrTsk
         rts

SetTsk        ldx   $04,u
SetPrTsk    lda   $0C,x
         anda  #$EF
         sta   $0C,x
         andcc #$FE
         pshs  u,y,x,b,a,cc
         ldb   $06,x
         leax  <$40,x
         ldy   #$0020
         ldu   #$FF80
         orcc  #$50
         stb   >$FFCA
L0D2B    ldd   ,x++
         ora   #$02
         std   ,u++
         leay  -$01,y
         bne   L0D2B
         ldb   D.SysTsk
         stb   >$FFCA
         puls  pc,u,y,x,b,a,cc

ResTsk   bsr   ResvTask
         stb   $02,u
         rts
ResvTask    pshs  x
         ldb   #$02
         ldx   D.Tasks
L0D47    lda   b,x
         beq   L0D55
         incb
         cmpb  #$08
         bne   L0D47
         comb
         ldb   #$EF
         bra   L0D5A
L0D55    inc   b,x
         orb   D.SysTsk
         clra
L0D5A    puls  pc,x

RelTsk   ldb   $02,u
L0D5E    pshs  x,b
         ldb   D.SysTsk
         comb
         andb  ,s
         beq   L0D6B
         ldx   D.Tasks
         clr   b,x
L0D6B    puls  pc,x,b

Tick     ldx   D.SProcQ
         beq   Slice
         lda   $0C,x
         bita  #$40
         beq   Slice
         ldu   $04,x
         ldd   $04,u
         subd  #$0001
         std   $04,u
         bne   Slice
L0D82    ldu   $0D,x
         bsr   ActvProc
         leax  ,u
         beq   L0D96
         lda   $0C,x
         bita  #$40
         beq   L0D96
         ldu   $04,x
         ldd   $04,u
         beq   L0D82
L0D96    stx   D.SProcQ

Slice    dec   D.Slice
         bne   L0DA8
         inc   D.Slice
         ldx   D.Proc
         beq   L0DA8
         lda   $0C,x
         ora   #$20
         sta   $0C,x
L0DA8    clrb
         rts

AProc    ldx   $04,u
ActvProc    clrb
         pshs  u,y,x,cc
         lda   $0A,x
         sta   $0B,x
         orcc  #$50
         ldu   #$0045
         bra   L0DC4
L0DBA    inc   $0B,u
         bne   ActvPr20
         dec   $0B,u
ActvPr20    cmpa  $0B,u
         bhi   L0DC6
L0DC4    leay  ,u
L0DC6    ldu   $0D,u
         bne   L0DBA
         ldd   $0D,y
         stx   $0D,y
         std   $0D,x
         puls  pc,u,y,x,cc

UserIRQ  ldx   D.Proc
         sts   $04,x
         lds   D.SysStk
         ldd   D.SysSvc
         std   D.XSWI2
         ldd   D.SysIRQ
         std   D.XIRQ
         jsr   [>$00CE]
         bcc   UserRet
         ldx   D.Proc
         ldb   $06,x
         ldx   $04,x
         lbsr  LDABX
         ora   #$50
         lbsr  STABX
*
*     fall through to UserRet
*
***********************************************************
*
*     Subroutine UserRet
*
*   Return to User process after interrupt
*
* Input: A = Process State flags
*        X = Process Descriptor ptr
*
* Output: none
*
* Data: none
*
* Calls: NextProc (@ CurrProc), ActvProc, NextProc
*
UserRet    orcc  #$50
         ldx   D.Proc
         ldu   $04,x
         lda   $0C,x
         bita  #$20
         beq   CurrProc
L0E02    anda  #$DF
         sta   $0C,x
         lbsr  DelPrTsk
GoActv    bsr   ActvProc
*
*    fall through to NextProc
*
***********************************************************
*
*     Subroutine NextProc
*
*   Start next process in Active Process Queue
*
* Input: none
*
* Output: does not return to caller
*
* Data: D.SysPrc, D.Proc, D.AProcQ
*
* Calls: SvcRet
*
NextProc ldx   D.SysPrc
         stx   D.Proc
         lds   D.SysStk
         andcc #$AF
         bra   L0E18
L0E16    cwai  #$AF
L0E18    orcc  #$50
         ldy   #$0045
         bra   NextPr40

L0E20    leay  ,x
NextPr40    ldx   $0D,y
         beq   L0E16
         lda   $0C,x
         bita  #$08
         bne   L0E20
         ldd   $0D,x
         std   $0D,y
         stx   D.Proc
         lbsr  AllPrTsk
         bcs   GoActv
         lda   D.TSlice
         sta   D.Slice
         ldu   $04,x
         lda   $0C,x
         bmi   SysRet
CurrProc    bita  #$02
         bne   KillProc
         lbsr  ChkPrTsk
         ldb   <$19,x
         beq   L0E7A
         decb
         beq   CurrPr20
         leas  -$0C,s
         leau  ,s
         lbsr  L034F
         lda   <$19,x
         sta   $02,u
         ldd   <$1A,x
         beq   KillProc
         std   $0A,u
         ldd   <$1C,x
         std   $08,u
         ldd   $04,x
         subd  #$000C
         std   $04,x
         lbsr  L035E
         leas  $0C,s
         ldu   $04,x
         clrb
CurrPr20    stb   <$19,x
L0E7A    ldd   D.UsrSvc
         std   D.XSWI2
         ldd   D.UsrIRQ
         std   D.XIRQ
         lbra  SvcRet
KillProc    lda   $0C,x
         ora   #$80
         sta   $0C,x
         leas  >$0200,x
         andcc #$AF
         ldb   <$19,x
         clr   <$19,x
         os9   F$Exit

SysIRQ    jsr   [>$00CE]
         bcc   L0EA6
         ldb   ,s
         orb   #$50
         stb   ,s
L0EA6    rti



***********************************************************
*     Routine SysRet
*
*   Return to system after service request
*
* Input: U = reqisters ptr
*
* Output: does not return to caller
*
* Data: D.SysPrc
*
* Calls: SvcRet
*
SysRet    ldx   D.SysPrc
         lbsr  ChkPrTsk
         leas  ,u
         rti

GoPoll    jmp   [>$0026]

IOPoll    orcc  #$01
         rts

***********************************************************
*
*     Routine DATInit
*
DATInit  clra
         tfr   a,dp
         ldu   #$FFC8
         ldb   #$07
L0EBE    stb   ,-u
         decb
         bne   L0EBE
         leay  ,-u
         ldx   #$01FF
         ldb   #$02
L0ECA    stx   ,--y
         leax  -$01,x
         decb
         bne   L0ECA
         ldx   #$0340
         stx   ,--y
         ldx   #$0350
         stx   ,--y
         ldb   #$19
         ldx   #$015F
L0EE0    stx   ,--y
         decb
         bne   L0EE0
         ldd   #$0202
L0EE8    std   ,--y
         decb
         bpl   L0EE8
         clra
         sta   ,u
         lbra  COLD


***********************************************************
*
*     Service Request Return
*
*   Switch to user's address space
*
* Input: X = Process Descriptor ptr
*        U = Process Stack ptr
*
* Output: does not return
*
* Data: none
*
* Calls: none
*
SvcRet    ldb   $06,x
         orcc  #$50
         stb   >$FFCB
         leas  ,u
         ldb   #$02
         stb   >$FFC9
         rti

PassSWI    ldb   $06,x
         stb   >$FFCB
         ldb   #$03
         stb   >$FFC9
         jmp   ,u
         orcc  #$50
         ldb   #$F2
         bra   L0F22
         orcc  #$50
         ldb   #$F4
         bra   L0F22
         ldb   #$F6
         bra   L0F22
         orcc  #$50
         ldb   #$F8
L0F22    lda   #$80
         sta   >$FFCB
         clra
         tfr   a,dp
         tfr   d,x
         jmp   [,x]
         ldb   #$FA
         bra   L0F22
         ldb   #$FC
         bra   L0F22
         emod
OS9End      equ   *

 fcb $39,$39,$39,$39,$39,$39,$39
 fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

HdlrVec fcb $FD,$AD,$F3,$38,$F3,$42,$F0,$40,$FE,$12,$F3,$4B,$F0,$40,$F0,$40
 fcb $F0,$40,$FF,$4E,$FF,$54,$FF,$5A,$FF,$5E,$FF,$6E,$FF,$72,$FE,$F6

ROMEnd equ *

 end
