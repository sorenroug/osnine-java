         nam   OS9p2
         ttl   os9 system module


         ifp1
         use   defsfile
         endc
tylg     set   Systm+$00
Revs     set   ReEnt+1

         mod   OS9End,OS9Name,tylg,Revs,Cold,size
u0000    rmb   1
u0001    rmb   1
u0002    rmb   2
u0004    rmb   2
u0006    rmb   1
u0007    rmb   1
u0008    rmb   1
u0009    rmb   1
u000A    rmb   2
u000C    rmb   1
u000D    rmb   1
u000E    rmb   2
u0010    rmb   2
u0012    rmb   14
u0020    rmb   4
u0024    rmb   1
u0025    rmb   10
u002F    rmb   5
u0034    rmb   12
u0040    rmb   2
u0042    rmb   2
u0044    rmb   1
u0045    rmb   1
u0046    rmb   2
u0048    rmb   2
u004A    rmb   2
u004C    rmb   4
u0050    rmb   4
u0054    rmb   4
u0058    rmb   2
u005A    rmb   11
u0065    rmb   4
u0069    rmb   4
u006D    rmb   9
u0076    rmb   14
u0084    rmb   21
u0099    rmb   8
u00A1    rmb   14
u00AF    rmb   18
u00C1    rmb   11
u00CC    rmb   4
u00D0    rmb   9
u00D9    rmb   9
u00E2    rmb   30
size     equ   .
OS9Name     equ   *
         fcs   /OS9p2/
         fcb   14


 ttl Coldstart Routines
 page
*****
*
* Cold Start Routines
*
*
* Initialize Service Routine Dispatch Table
*
Cold    equ   *
         leay  >SVCTBL,pcr
         os9   F$SSvc
         ldu   D.Init
         ldd   u0009,u
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         addd  D.BlkMap
         tfr   d,x
         ldb   #$80
         bra   L0034
L002E    lda   ,x+
         bne   L0034
         stb   -$01,x
L0034    cmpx  D.BlkMap+2
         bcs   L002E
L0038    ldu   D.Init
         ldd   <u0010,u
         beq   L004D
         leax  d,u
         lda   #$05
         os9   I$ChgDir
         bcc   L004D
         os9   F$Boot
         bcc   L0038
L004D    ldu   D.Init
         ldd   StdStr,u
         beq   L0075
         leax  d,u
         lda   #$03
         os9   I$Open
         bcc   L0064
         os9   F$Boot
         bcc   L004D
         bra   L0075

L0064    ldx   D.PROC
         sta   <$30,x
         os9   I$Dup
         sta   <$31,x
         os9   I$Dup
         sta   <$32,x
L0075    leax  <L0094,pcr
         lda   #$C0
         os9   F$Link
         bcs   L0081
         jsr   ,y
L0081    ldu   D.Init
         ldd   u000E,u
         leax  d,u
         lda   #$01
         clrb
         ldy   #$0000
         os9   F$Fork
         os9   F$NProc

L0094    fcs "OS9p3"

SVCTBL equ *
 fcb F$Unlink
 fdb UNLINK-*-2
 fcb F$Fork
 fdb FORK-*-2
 fcb F$Wait
 fdb WAIT-*-2
 fcb F$Chain
 fdb CHAIN-*-2
 fcb F$EXIT
 fdb EXIT-*-2
 fcb F$MEM
 fdb USRMEM-*-2
 fcb F$SEND
 fdb SEND-*-2
 fcb F$ICPT
 fdb INTCPT-*-2
 fcb F$SLEEP
 fdb SLEEP-*-2
 fcb F$SPrior
 fdb SETPRI-*-2
 fcb F$ID
 fdb GETID-*-2
 fcb F$SSWI
 fdb SETSWI-*-2
 fcb F$STime
 fdb SETTIME-*-2
 fcb F$SchBit
 fdb SCHBIT-*-2
 fcb F$SchBit+$80
 fdb SSCHBIT-*-2
 fcb F$AllBit
 fdb ALLBIT-*-2
 fcb F$AllBit+$80
 fdb SALLBIT-*-2
 fcb F$DelBit
 fdb DELBIT-*-2
 fcb F$DelBit+$80
 fdb SDELBIT-*-2
 fcb F$GPrDsc
 fdb GPRDSC-*-2
 fcb F$GBlkMp
 fdb GBLKMP-*-2
 fcb F$GModDr
 fdb GMODDR-*-2
 fcb F$CpyMem
 fdb CPYMEM-*-2
 fcb F$SUser
 fdb SETUSER-*-2
 fcb F$Unload
 fdb UNLOAD-*-2
 fcb F$Find64+$80
 fdb F64-*-2
 fcb F$ALL64+$80
 fdb A64-*-2
 fcb F$Ret64+$80
 fdb R64-*-2
 fcb F$GProcP+$80
 fdb GPROCP-*-2
 fcb F$DelImg+$80
 fdb DELIMG-*-2
 fcb F$AllPrc+$80
 fdb ALLPRC-*-2
 fcb F$DelPrc+$80
 fdb DELPRC-*-2
 fcb F$MapBlk
 fdb MAPBLK-*-2
 fcb F$ClrBlk
 fdb CLRBLK-*-2
 fcb F$DelRam
 fdb DELRAM-*-2
 fcb F$GCMDir+$80
 fdb GCMDIR-*-2
 fcb $7F
 fdb IOHOOK-*-2
         fcb   $80

IOSTR    fcs "IOMan"

IOHOOK pshs D,X,Y,U Save registers
         bsr IOLink
         bcc   IOHOOK10
         os9   F$Boot
         bcs   L0127
         bsr   IOLink
         bcs   L0127
IOHOOK10    jsr   ,y
         puls  u,y,x,b,a
         ldx   >$00FE,y
         jmp   ,x
L0127    stb   $01,s
         puls  pc,u,y,x,b,a

IOLink    leax  >IOSTR,pcr
         lda   #$C1
         os9   F$Link
         rts

 ttl SERVICE Routines
 page
*****
*
*  Subroutine Unlink
*
* Decrment Link Count. If Count Reaches Zero,
*    Delete Module From Directory & Return Memory
*
UNLINK   pshs  u,b,a
         ldd   R$U,u
         ldx   R$U,u
         lsra
         lsra
         lsra
         lsra
         sta   ,s
         beq   L017D
         ldu   D.PROC
         leay  P$DATImg,u
         lsla
L0149    ldd   a,y
         ldu   D.BlkMap
         ldb   d,u
         bitb  #$02
         beq   L017D
         leau  P$DATImg,y
         bra   L015C
L0158    dec   ,s
         beq   L017D
L015C    ldb   ,s
         lslb
         ldd   b,u
         beq   L0158
         lda   ,s
         lsla
         lsla
         lsla
         lsla
         clrb
         nega
         leax  d,x
         ldb   ,s
         lslb
         ldd   b,y
         ldu   D.ModDir
         bra   L017F
L0176    leau  u0008,u
         cmpu  D.ModEnd
         bcs   L017F
L017D    bra   L01CA
L017F    cmpx  u0004,u
         bne   L0176
         cmpd  [,u]
         bne   L0176
         ldx   u0006,u
         beq   L0192
         leax  -$01,x
         stx   u0006,u
         bne   L01AF
L0192    ldx   $02,s
         ldx   $08,x
         ldd   #$0006
         os9   F$LDDDXY
         cmpa  #$D0
         bcs   L01AD
         os9   F$IODel
         bcc   L01AD
         ldx   u0006,u
         leax  $01,x
         stx   u0006,u
         bra   L01CB
L01AD    bsr   L01CF
L01AF    ldb   ,s
         lslb
         leay  b,y
         ldx   <$40,y
         leax  -$01,x
         stx   <$40,y
         bne   L01CA
         ldd   u0002,u
         bsr   L0220
         ldx   #$00FE
L01C5    stx   ,y++
         deca
         bne   L01C5
L01CA    clrb
L01CB    leas  $02,s
         puls  pc,u

L01CF    ldx   D.BlkMap
         ldd   [,u]
         lda   d,x
         bmi   L021F
         ldx   D.ModDir
L01D9    ldd   [,x]
         cmpd  [,u]
         bne   L01E4
         ldd   $06,x
         bne   L021F
L01E4    leax  $08,x
         cmpx  D.ModEnd
         bcs   L01D9
         ldx   D.BlkMap
         ldd   u0002,u
         bsr   L0220
         pshs  y
         ldy   ,u
L01F5    pshs  x,a
         ldd   ,y
         clr   ,y+
         clr   ,y+
         leax  d,x
         ldb   ,x
         andb  #$FC
         stb   ,x
         puls  x,a
         deca
         bne   L01F5
         puls  y
         ldx   D.ModDir
         ldd   ,u
L0210    cmpd  ,x
         bne   L0219
         clr   ,x
         clr   $01,x
L0219    leax  $08,x
         cmpx  D.ModEnd
         bcs   L0210
L021F    rts

L0220    addd  #$0FFF
         lsra
         lsra
         lsra
         lsra
         rts

FORK     pshs  u
         lbsr  L02DD
         bcc   L0231
         puls  pc,u
L0231    pshs  u
         ldx   D.PROC
         ldd   P$User,x
         std   P$User,u
         lda   P$Prior,x
         sta   P$Prior,u
         leax  P$DIO,x
         leau  P$DIO,u
         ldb   #$10
L0245    lda   ,x+
         sta   ,u+
         decb
         bne   L0245
         ldy   #3     dup the first three open paths
L0250    lda   ,x+
         beq   L025A
         os9   I$Dup
         bcc   L025A
         clra
L025A    sta   ,u+
         leay  -$01,y
         bne   L0250
         leax  <$6D,x
         leau  <u006D,u
         ldb   #$20
L0268    lda   ,x+
         sta   ,u+
         decb
         bne   L0268
         ldx   ,s
         ldu   $02,s
         lbsr  L047A
         bcs   L02C2
         pshs  b,a
         os9   F$AllTsk
         bcc   L027F
L027F    lda   $07,x
         clrb
         subd  ,s
         tfr   d,u
         ldb   $06,x
         ldx   D.PROC
         lda   P$Task,x
         leax  ,y
         puls  y
         os9   F$Move
         ldx   ,s
         lda   D.SysTsk
         ldu   $04,x
         leax  (P$Stack-R$Size),x
         ldy   #$000C
         os9   F$Move
         puls  u,x
         os9   F$DelTsk
         ldy   D.PROC
         lda   ,x
         sta   u0001,u
         ldb   $03,y
         sta   $03,y
         lda   ,y
         std   $01,x
         lda   $0C,x
         anda  #$7F
         sta   $0C,x
         os9   F$AProc
         rts
L02C2    puls  x
         pshs  b
         lbsr  L056E
         lda   ,x
         lbsr  L0369
         comb
         puls  pc,u,b

ALLPRC   pshs  u
         bsr   L02DD
         bcs   L02DB
         ldx   ,s
         stu   $08,x
L02DB    puls  pc,u

L02DD    ldx   D.PrcDBT
L02DF    lda   ,x+
         bne   L02DF
         leax  -$01,x
         tfr   x,d
         subd  D.PrcDBT
         tsta
         beq   L02F1
         comb
         ldb   #$E5
         bra   L0322
L02F1    pshs  b
         ldd   #$0200
         os9   F$SRqMem
         puls  a
         bcs   L0322
         sta   ,u
         tfr   u,d
         sta   ,x
         clra
         leax  u0001,u
         ldy   #$0080
L030A    std   ,x++
         leay  -$01,y
         bne   L030A
         lda   #$80
         sta   u000C,u
         ldb   #$10
         ldx   #$00FE
         leay  P$DATImg,u
L031C    stx   ,y++
         decb
         bne   L031C
         clrb
L0322    rts

DELPRC   lda R$A,u
         bra   L0369

 page
*****
*
*  Subroutine Wait
*
* Wait for Child Process to Exit
*
WAIT     ldx   D.PROC
         lda   $03,x
         beq   L034B
WAIT10    lbsr  L0AEA
         lda   $0C,y
         bita  #$01
         bne   CHILDS
         lda   $02,y
         bne   WAIT10
         sta   u0001,u
         pshs  cc
         orcc  #$50
         ldd   <u0054
         std   $0D,x
         stx   <u0054
         puls  cc
         lbra  L073A
L034B    comb
         ldb   #$E2
         rts

CHILDS    lda   ,y
         ldb   <$19,y
         std   u0001,u
         leau  ,y
         leay  $01,x
         bra   CHIL20
CHIL10    lbsr  L0AEA
CHIL20    lda   $02,y
         cmpa  ,u
         bne   CHIL10
         ldb R$B,u
         stb   $02,y
L0369    pshs  u,x,b,a
         ldb   ,s
         ldx   D.PrcDBT
         abx
         lda   ,x
         beq   L0384
         clrb
         stb   ,x
         tfr   d,x
         os9   F$DelTsk
         leau  ,x
         ldd   #$0200
         os9   F$SRtMem
L0384    puls  pc,u,x,b,a

CHAIN    pshs  u
         lbsr  L02DD
         bcc   L038F
         puls  pc,u
L038F    ldx   D.PROC
         pshs  u,x
         leax  $04,x
         leau  u0004,u
         ldy   #$007E
L039B    ldd   ,x++
         std   ,u++
         leay  -$01,y
         bne   L039B
         ldx   D.PROC
         clra
         clrb
         stb   $06,x
         std   <$13,x
         std   <$15,x
         std   <$17,x
         sta   <$19,x
         std   <$1A,x
         ldu   <$11,x
         os9   F$UnLink
         ldb   $07,x
         addb  #$0F
         lsrb
         lsrb
         lsrb
         lsrb
         lda   #$10
         pshs  b
         suba  ,s+
         leay  P$DatImg,x
         lslb
         leay  b,y
         ldu   #$00FE
L03D5    stu   ,y++
         deca
         bne   L03D5
         ldu   $02,s
         stu   D.PROC
         ldu   $04,s
         lbsr  L047A
         lbcs  L046A
         pshs  b,a
         os9   F$AllTsk
         bcc   L03EE
L03EE    ldu   D.PROC
         lda   u0006,u
         ldb   $06,x
         leau  (P$Stack-R$Size),x
         leax  ,y
         ldu   u0004,u
         pshs  u
         cmpx  ,s++
         puls  y
         bhi   L043A
         beq   L043D
         leay  ,y
         beq   L043D
         pshs  x,b,a
         tfr   y,d
         leax  d,x
         pshs  u
         cmpx  ,s++
         puls  x,b,a
         bls   L043A
         pshs  u,y,x,b,a
         tfr   y,d
         leax  d,x
         leau  d,u
L0420    ldb   ,s
         leax  -$01,x
         os9   F$LDABX
         exg   x,u
         ldb   $01,s
         leax  -$01,x
         os9   F$STABX
         exg   x,u
         leay  -$01,y
         bne   L0420
         puls  u,y,x,b,a
         bra   L043D
L043A    os9   F$Move
L043D    lda   D.SysTsk
         ldx   ,s
         ldu   $04,x
         leax  (P$Stack-R$Size),x
         ldy   #$000C
         os9   F$Move
         puls  u,x
         lda   ,u
         lbsr  L0369
         os9   F$DelTsk
         orcc  #$50
         ldd   D.SysPrc
         std   D.PROC
         lda   $0C,x
         anda  #$7F
         sta   $0C,x
         os9   F$AProc
         os9   F$NProc
L046A    puls  u,x
         stx   D.PROC
         pshs  b
         lda   ,u
         lbsr  L0369
         puls  b
         os9   F$Exit
L047A    pshs  u,y,x,b,a
         ldd   D.PROC
         pshs  b,a
         stx   D.PROC
         lda   u0001,u
         ldx R$X,u
         ldy   ,s
         leay  <$40,y
         os9   F$SLink
         bcc   L04A0
         ldd   ,s
         std   D.PROC
         ldu   $04,s
         os9   F$Load
         bcc   L04A0
         leas  $04,s
         puls  pc,u,y,x
L04A0    stu   $02,s
         pshs  y,a
         ldu   $0B,s
         stx R$X,u
         ldx   $07,s
         stx   D.PROC
         ldd   $05,s
         std   <$11,x
         puls  a
         cmpa  #$11
         beq   L04C4
         cmpa  #$C1
         beq   L04C4
         ldb   #$EA
L04BD    leas  $02,s
         stb   $03,s
         comb
         bra   L0507
L04C4    ldd   #$000B
         leay  P$DatImg,x
         ldx   <$11,x
         os9   F$LDDDXY
         cmpa  u0002,u
         bcc   L04D7
         lda   u0002,u
         clrb

L04D7    os9   F$Mem
         bcs   L04BD
         ldx   $06,s
         leay  (P$Stack-R$Size),x
         pshs  b,a
         subd  u0006,u
         std   $04,y
         subd  #$000C
         std   $04,x
         ldd   u0006,u
         std   $01,y
         std   $06,s
         puls  x,b,a
         std   $06,y
         ldd   u0008,u
         std   $06,s
         lda   #$80
         sta   ,y
         clra
         sta   $03,y
         clrb
         std   $08,y
         stx   $0A,y
L0507    puls  b,a
         std   D.PROC
         puls  pc,u,y,x,b,a
 page
*****
*
*  Subroutine Exit
*
* Process Termination
*
EXIT     ldx   D.PROC
         bsr   L056E
         ldb R$B,u
         stb   <$19,x
         leay  $01,x
         bra   L052C
L051A    clr   $02,y
         lbsr  L0AEA
         clr   $01,y
         lda   $0C,y
         bita  #$01
         beq   L052C
         lda   ,y
         lbsr  L0369
L052C    lda   $02,y
         bne   L051A
         leay  ,x
         ldx   #$0047
         lds   <u00CC
         pshs  cc
         orcc  #$50
         lda   $01,y
         bne   L054D
         puls  cc
         lda   ,y
         lbsr  L0369
         bra   L056B
L0549    cmpa  ,x
         beq   EXIT45
L054D    leau  ,x
         ldx   $0D,x
         bne   L0549
         puls  cc
         lda   #$81
         sta   $0C,y
         bra   L056B
EXIT45    ldd   $0D,x
         std   u000D,u
         puls  cc
         ldu   $04,x
         ldu   u0008,u
         lbsr  CHILDS
         os9   F$AProc
L056B    os9   F$NProc
L056E    pshs  u
         ldb   #$10
         leay  <$30,x
EXIT10    lda   ,y+
         beq   L0582
         clr   -$01,y
         pshs  b
         os9   I$Close
         puls  b
L0582    decb
         bne   EXIT10
         clra
         ldb   $07,x
         beq   L0593
         addb  #$0F
         lsrb
         lsrb
         lsrb
         lsrb
         os9   F$DelImg
L0593    ldd   D.PROC
         pshs  b,a
         stx   D.PROC
         ldu   <$11,x
         os9   F$UnLink
         puls  u,b,a
         std   D.PROC
         os9   F$DelTsk
         rts

USRMEM   ldx   D.PROC get process ptr
 ldd R$D,U Get size requested
         beq   USRM35
         addd  #$00FF
         cmpa  $07,x
         beq   USRM35
         pshs  a
         bcc   L05C4
         deca
         ldb   #$F4
         cmpd  $04,x
         bcc   L05C4
         ldb   #$DF
         bra   L05E7
L05C4    lda   $07,x
         adda  #$0F
         lsra
         lsra
         lsra
         lsra
         ldb   ,s
         addb  #$0F
         bcc   L05D6
         ldb   #$CF
         bra   L05E7
L05D6    lsrb
         lsrb
         lsrb
         lsrb
         pshs  a
         subb  ,s+
         beq   L05F4
         bcs   L05EC
         os9   F$AllImg
         bcc   L05F4
L05E7    leas  $01,s
         orcc  #$01
         rts
L05EC    pshs  b
         adda  ,s+
         negb
         os9   F$DelImg
L05F4    puls  a
         sta   $07,x
USRM35    lda   $07,x
         clrb
         std   u0001,u
         std   u0006,u
         rts

SEND     ldx   D.PROC
         lda R$A,u
         bne   SENSUB
         inca
L0607    cmpa  ,x
         beq   L060D
         bsr   SENSUB
L060D    inca
         bne   L0607
         clrb
         rts

*
* Get destination Process ptr
*
SENSUB    lbsr  L0AEA
         pshs  u,y,a,cc
         bcs   L062A
         tst   u0002,u
         bne   L062D
         ldd   $08,x
         beq   L062D
         cmpd  $08,y
         beq   L062D
         ldb   #$E0
         inc   ,s
L062A    lbra  L06B4
L062D    orcc  #$50
         ldb R$B,u
         bne   L063B
         ldb   #$E4
         lda   $0C,y
         ora   #$02
         sta   $0C,y
L063B    lda   $0C,y
         anda  #$F7
         sta   $0C,y
         lda   <$19,y
         beq   SEND40
         deca
         beq   SEND40
         inc   ,s
         ldb   #$E9
         bra   L06B4
SEND40    stb   <$19,y
         ldx   #$0049
         clra
         clrb
L0657    leay  ,x
         ldx   $0D,x
         beq   L0693
         ldu   $04,x
         addd  u0004,u
         cmpx  $02,s
         bne   L0657
         pshs  b,a
         lda   $0C,x
         bita  #$40
         beq   L068F
         ldd   ,s
         beq   L068F
         ldd   u0004,u
         pshs  b,a
         ldd   $02,s
         std   u0004,u
         puls  b,a
         ldu   $0D,x
         beq   L068F
         std   ,s
         lda   u000C,u
         bita  #$40
         beq   L068F
         ldu   u0004,u
         ldd   ,s
         addd  u0004,u
         std   u0004,u
L068F    leas  $02,s
         bra   L06A0
L0693    ldx   #$0047
L0696    leay  ,x
         ldx   $0D,x
         beq   L06B4
         cmpx  $02,s
         bne   L0696
L06A0    ldd   $0D,x
         std   $0D,y
         lda   <$19,x
         deca
         bne   SEND70
         sta   <$19,x
         lda   ,s
         tfr   a,cc
SEND70    os9   F$AProc
L06B4    puls  pc,u,y,a,cc
 page
*****
*
*  Subroutine Intcpt
*
* Signal Intercept Handler
*
INTCPT ldx D.PROC Get process ptr
         ldd   u0004,u
         std   <$1A,x
         ldd   u0008,u
         std   <$1C,x
         clrb
         rts

page
*****
*
*  Subroutine Sleep
*
* Suspend Process
*
SLEEP pshs  cc
         ldx   D.PROC
         orcc  #$50
         lda   <$19,x
         beq   SLEP20
         deca
         bne   L06D5
         sta   <$19,x
L06D5    puls  cc
         os9   F$AProc
         bra   L073A
SLEP20    ldd   u0004,u
         beq   L0727
         subd  #$0001
         std   u0004,u
         beq   L06D5
         pshs  y,x
         ldx   #$0049
L06EC    std   u0004,u
         stx   $02,s
         ldx   $0D,x
         beq   L0709
         lda   $0C,x
         bita  #$40
         beq   L0709
         ldy   $04,x
         ldd   u0004,u
         subd  $04,y
         bcc   L06EC
         nega
         negb
         sbca  #$00
         std   $04,y
L0709    puls  y,x
         lda   $0C,x
         ora   #$40
         sta   $0C,x
         ldd   $0D,y
         stx   $0D,y
         std   $0D,x
         ldx R$X,u
         bsr   L073A
         stx R$X,u
         ldx   D.PROC
         lda   $0C,x
         anda  #$BF
         sta   $0C,x
         puls  pc,cc
L0727    ldx   #$0049
L072A    leay  ,x
         ldx   $0D,x
         bne   L072A
         ldx   D.PROC
         clra
         clrb
         stx   $0D,y
         std   $0D,x
         puls  cc
L073A    pshs  pc,u,y,x
         leax  <L0756,pcr
         stx   $06,s
         ldx   D.PROC
         ldb   $06,x
         cmpb  D.SysTsk
         beq   L074C
         os9   F$DelTsk
L074C    ldd   $04,x
         pshs  dp,b,a,cc
         sts   $04,x
         os9   F$NProc

L0756    pshs  x
         ldx   D.PROC
         std   $04,x
         clrb
         puls  pc,x



*****
*
*  Subroutine Setpri
*
* Set Process Priority
*
SETPRI   lda R$A,u
         lbsr  L0AEA
         bcs   SETP20
         ldx   D.PROC
         ldd   $08,x
         beq   L0771
         cmpd  $08,y
         bne   L0777
L0771    lda   u0002,u
         sta   $0A,y
         clrb
         rts
L0777    comb
         ldb   #$E0
SETP20    rts



*****
*
*  Subroutine Getid
*
GETID ldx D.PROC Get process ptr
 lda P$ID,X Get process id
         sta   u0001,u
         ldd   $08,x
         std   u0006,u
         clrb
         rts
*****
*
*  Subroutine Setswi
*
* Set Software Interrupt Vectors
*
SETSWI   ldx   D.PROC
         leay  <$13,x
         ldb   u0001,u
         decb
         cmpb  #$03
         bcc   SSWI10
         lslb
         ldx R$X,u
         stx   b,y
         rts
SSWI10    comb
         ldb   #$E3
         rts

**********
*
* Subroutine Settime
*

ClockNam fcs "Clock"

SetTime ldx R$X,U get date ptr
         tfr   dp,a
         ldb   #$28
         tfr   d,u
         ldy   D.PROC
         lda   $06,y
         ldb   D.SysTsk
         ldy   #$0006
         os9   F$Move
         ldx   D.PROC
         pshs  x
         ldx   D.SysPrc
         stx   D.PROC
         lda   #$C1
         leax  <ClockNam,pcr
         os9   F$Link
         puls  x
         stx   D.PROC
         bcs   SeTime99
         jmp   ,y
SeTime99    rts

ALLBIT   ldd R$D,u
         ldx R$X,u
         bsr   L0828
         ldy   D.PROC
         ldb   $06,y
         bra   L07E6

SALLBIT  ldd R$D,u
         ldx R$X,u
         bsr   L0828
         ldb   D.SysTsk
L07E6    ldy   u0006,u
         beq   L0826
         sta   ,-s
         bmi   L0801
         os9   F$LDABX
L07F2    ora   ,s
         leay  -$01,y
         beq   L0821
         lsr   ,s
         bcc   L07F2
         os9   F$STABX
         leax  $01,x
L0801    lda   #$FF
         bra   L080C
L0805    os9   F$STABX
         leax  $01,x
         leay  -$08,y
L080C    cmpy  #$0008
         bhi   L0805
         beq   L0821
L0814    lsra
         leay  -$01,y
         bne   L0814
         coma
         sta   ,s
         os9   F$LDABX
         ora   ,s
L0821    os9   F$STABX
         leas  $01,s
L0826    clrb
         rts
L0828    pshs  y,b
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         leax  d,x
         puls  b
         leay  <L083D,pcr
         andb  #$07
         lda   b,y
         puls  pc,y

L083D    fcb  $80,$40,$20,$10,$08,$04,$02,$01

DELBIT   ldd R$D,u
         ldx R$X,u
         bsr   L0828
         ldy   D.PROC
         ldb   $06,y
         bra   L085A

SDELBIT  ldd R$D,u
         ldx R$X,u
         bsr   L0828
         ldb   D.SysTsk
L085A    ldy   u0006,u
         beq   L089A
         coma
         sta   ,-s
         bpl   L0876
         os9   F$LDABX
L0867    anda  ,s
         leay  -$01,y
         beq   L0895
         asr   ,s
         bcs   L0867
         os9   F$STABX
         leax  $01,x
L0876    clra
         bra   L0880
L0879    os9   F$STABX
         leax  $01,x
         leay  -$08,y
L0880    cmpy  #$0008
         bhi   L0879
         beq   L0895
         coma
L0889    lsra
         leay  -$01,y
         bne   L0889
         sta   ,s
         os9   F$LDABX
         anda  ,s
L0895    os9   F$STABX
         leas  $01,s
L089A    clrb
         rts

SCHBIT   ldd R$D,u Get beginning bit number
         ldx R$X,u Get bit map ptr
         bsr   L0828
         ldy   D.PROC
         ldb   $06,y
         bra   L08B2

SSCHBIT  ldd R$D,u
         ldx R$X,u
         lbsr  L0828
         ldb   D.SysTsk
L08B2    pshs  u,y,x,b,a,cc
         clra
         clrb
         std   $03,s
         ldy   u0001,u
         sty   $07,s
         bra   L08CB
L08C0    sty   $07,s
L08C3    lsr   $01,s
         bcc   L08D6
         ror   $01,s
         leax  $01,x
L08CB    cmpx  u0008,u
         bcc   L08F4
         ldb   $02,s
         os9   F$LDABX
         sta   ,s
L08D6    leay  $01,y
         lda   ,s
         anda  $01,s
         bne   L08C0
         tfr   y,d
         subd  $07,s
         cmpd  u0006,u
         bcc   L08FD
         cmpd  $03,s
         bls   L08C3
         std   $03,s
         ldd   $07,s
         std   $05,s
         bra   L08C3
L08F4    ldd   $03,s
         std   u0006,u
         comb
         ldd   $05,s
         bra   L08FF
L08FD    ldd   $07,s
L08FF    std   u0001,u
         leas  $09,s
         rts

GPRDSC   ldx   D.PROC
         ldb   $06,x
         lda   u0001,u
         os9   F$GProcP
         bcs   L091C
         lda   D.SysTsk
         leax  ,y
         ldy   #$0200
         ldu   u0004,u
         os9   F$Move
L091C    rts

GBLKMP   ldd   #DAT.BlSz
         std R$D,u
         ldd   D.BlkMap+2
         subd  D.BlkMap
         std   u0006,u
         tfr   d,y
         lda   D.SysTsk
         ldx   D.PROC
         ldb   $06,x
         ldx   D.BlkMap
         ldu   u0004,u
         os9   F$Move
         rts

GMODDR   ldd   D.ModDir+2
         subd  D.ModDir
         tfr   d,y
         ldd   D.ModEnd
         subd  D.ModDir
         ldx R$X,u
         leax  d,x
         stx   u0006,u
         ldx   D.ModDir
         stx   u0008,u
         lda   D.SysTsk
         ldx   D.PROC
         ldb   $06,x
         ldx   D.ModDir
         ldu   u0004,u
         os9   F$Move
         rts

SETUSER  ldx   D.PROC
         ldd   u0006,u
         std   $08,x
         clrb
         rts

CPYMEM   ldd   R$Y,u
         beq   L09BE
         addd  u0008,u
         leas  <-$20,s
         leay  ,s
         pshs  y,b,a
         ldy   D.PROC
         ldb   $06,y
         pshs  b
         ldx   u0001,u
         leay  <$40,y
         ldb   #$10
         pshs  u,b
         ldu   $06,s
L0981    clra
         clrb
         os9   F$LDDDXY
         std   ,u++
         leax  $02,x
         dec   ,s
         bne   L0981
         puls  u,b
         ldx R$X,u
         ldu   u0008,u
         ldy   $03,s
L0997    cmpx  #$1000
         bcs   L09A4
         leax  >-$1000,x
         leay  $02,y
         bra   L0997
L09A4    os9   F$LDAXY
         ldb   ,s
         pshs  x
         leax  ,u+
         os9   F$STABX
         puls  x
         leax  $01,x
         cmpu  $01,s
         bcs   L0997
         puls  y,x,b
         leas  <$20,s
L09BE    clrb
         rts

UNLOAD   pshs  u
         lda R$A,u
         ldx   D.PROC
         leay  P$DatImg,x
         ldx R$X,u
         os9   F$FModul
         puls  y
         bcs   L0A0B
         stx   $04,y
         ldx   u0006,u
         beq   L09DE
         leax  -$01,x
         stx   u0006,u
         bne   L0A0A
L09DE    cmpa  #$D0
         bcs   L0A07
         clra
         ldx   [,u]
         ldy   <u004C
L09E8    adda  #$02
         cmpa  #$20
         bcc   L0A07
         cmpx  a,y
         bne   L09E8
         lsla
         lsla
         lsla
         clrb
         addd  u0004,u
         tfr   d,x
         os9   F$IODel
         bcc   L0A07
         ldx   u0006,u
         leax  $01,x
         stx   u0006,u
         bra   L0A0B
L0A07    lbsr  L01CF
L0A0A    clrb
L0A0B    rts
 page
***************
* Findpd
*   Find Address Of Path Descriptor Or Process Descriptor
*
* Calling Seq: (A)=Pd Number
*              (X)=Pd Table Addr
* Returns: (Y)=Addr Of Pd
*          Cc=Set If Pd Is Not Owned By Caller
* Destroys: B,Cc
*
F64      lda R$A,u
         ldx R$X,u
         bsr   FINDPD
         bcs   F6410
         sty   u0006,u
F6410    rts

FINDPD    pshs  b,a
         tsta
         beq   L0A2C
         clrb
         lsra
         rorb
         lsra
         rorb
         lda   a,x
         tfr   d,y
         beq   L0A2C
         tst   ,y
         bne   L0A2D
L0A2C    coma
L0A2D    puls  pc,b,a

 page
***************
* Aloc64
*   Allocate Path Descriptor (64 Bytes)
*
* Passed:  X=Pdbt, Path Descriptor Block Table Addr
* Returns: A=Path Number
*          Y=Pd Address
*          Cc=Set If Unable To Allocate
*           B=Error Code If Unable To Allocate
* Destroys: B
*
A64      ldx R$X,u
         bne   L0A3B
         bsr   L0A45
         bcs   L0A44
         stx   ,x
         stx R$X,u
L0A3B    bsr   L0A5B
         bcs   L0A44
         sta   u0001,u
         sty   u0006,u
L0A44    rts
L0A45    pshs  u
         ldd   #$0100
         os9   F$SRqMem
         leax  ,u
         puls  u
         bcs   L0A5A
         clra
         clrb
L0A55    sta   d,x
         incb
         bne   L0A55
L0A5A    rts
L0A5B    pshs  u,x
         clra
L0A5E    pshs  a
         clrb
         lda   a,x
         beq   L0A70
         tfr   d,y
         clra
L0A68    tst   d,y
         beq   L0A72
         addb  #$40
         bcc   L0A68
L0A70    orcc  #$01
L0A72    leay  d,y
         puls  a
         bcc   L0A9D
         inca
         cmpa  #$40
         bcs   L0A5E
         clra
L0A7E    tst   a,x
         beq   L0A8C
         inca
         cmpa  #$40
         bcs   L0A7E
         comb
         ldb   #$C8
         bra   L0AAA
L0A8C    pshs  x,a
         bsr   L0A45
         bcs   L0AAC
         leay  ,x
         tfr   x,d
         tfr   a,b
         puls  x,a
         stb   a,x
         clrb
L0A9D    lslb
         rola
         lslb
         rola
         ldb   #$3F
L0AA3    clr   b,y
         decb
         bne   L0AA3
         sta   ,y
L0AAA    puls  pc,u,x
L0AAC    leas  $03,s
         puls  pc,u,x

***************
* Rtrn64
*   Return Path Descriptor To Free Status
*
* Passed: (A)=Path Number
*         (X)=D.Pdbt Path Descriptor Block Table Addr
* Returns: None
* Destroys: Cc
*
R64      lda R$A,u
         ldx R$X,u
         pshs  u,y,x,b,a
         clrb
         tsta
         beq   L0ADE
         lsra
         rorb
         lsra
         rorb
         pshs  a
         lda   a,x
         beq   L0ADC
         tfr   d,y
         clr   ,y
         clrb
         tfr   d,u
         clra
L0ACC    tst   d,u
         bne   L0ADC
         addb  #$40
         bne   L0ACC
         inca
         os9   F$SRtMem
         lda   ,s
         clr   a,x
L0ADC    clr   ,s+
L0ADE    puls  pc,u,y,x,b,a

GPROCP   lda R$A,u
         bsr   L0AEA
         bcs   L0AE9
         sty   u0006,u
L0AE9    rts

L0AEA    pshs  x,b,a
         ldb   ,s
         beq   L0AFC
         ldx   D.PrcDBT
         abx
         lda   ,x
         beq   L0AFC
         clrb
         tfr   d,y
         puls  pc,x,b,a
L0AFC    puls  x,b,a
         comb
         ldb   #$EE
         rts

DELIMG   ldx R$X,u
         ldd R$D,u
         leau  P$DatImg,x
         lsla
         leau  a,u
         clra
         tfr   d,y
         pshs  x
L0B11    ldd   ,u
         addd  D.BlkMap
         tfr   d,x
         lda   ,x
         anda  #$FE
         sta   ,x
         ldd   #$00FE
         std   ,u++
         leay  -$01,y
         bne   L0B11
         puls  x
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         clrb
         rts

MAPBLK   lda   u0002,u
         cmpa  #$10
         bcc   L0B64
         leas  <-$20,s
         ldx R$X,u
         leay  ,s
L0B3D    stx   ,y++
         leax  $01,x
         deca
         bne   L0B3D
         ldb R$B,u
         ldx   D.PROC
         leay  P$DatImg,x
         os9   F$FreeHB
         bcs   L0B60
         pshs  b,a
         lsla
         lsla
         lsla
         lsla
         clrb
         std   u0008,u
         puls  b,a
         leau  ,s
         os9   F$SetImg
L0B60    leas  <$20,s
         rts

L0B64    comb
         ldb   #$DB
         rts

CLRBLK   ldb R$B,u
         beq   L0BA1
         ldd   u0008,u
         tstb
         bne   L0B64
         bita  #$0F
         bne   L0B64
         ldx   D.PROC
         lda   $04,x
         anda  #$F0
         suba  u0008,u
         bcs   L0B87
         lsra
         lsra
         lsra
         lsra
         cmpa  u0002,u
         bcs   L0B64
L0B87    lda   $0C,x
         ora   #$10
         sta   $0C,x
         lda   u0008,u
         lsra
         lsra
         lsra
         leay  P$DatImg,x
         leay  a,y
         ldb R$B,u
         ldx   #$00FE
L0B9C    stx   ,y++
         decb
         bne   L0B9C
L0BA1    clrb
         rts

DELRAM   ldb R$B,u
         beq   L0BC9
         ldd   D.BlkMap+2
         subd  D.BlkMap
         subd  u0004,u
         bls   L0BC9
         tsta
         bne   L0BB8
         cmpb  u0002,u
         bcc   L0BB8
         stb R$B,u
L0BB8    ldx   D.BlkMap
         ldd   u0004,u
         leax  d,x
         ldb R$B,u
L0BC0    lda   ,x
         anda  #$FE
         sta   ,x+
         decb
         bne   L0BC0
L0BC9    clrb
         rts

GCMDIR   ldx   D.ModDir
         bra   L0BD5
L0BCF    ldu   ,x
         beq   L0BDB
         leax  $08,x
L0BD5    cmpx  D.ModEnd
         bne   L0BCF
         bra   L0C03
L0BDB    tfr   x,y
         bra   L0BE3
L0BDF    ldu   ,y
         bne   L0BEC
L0BE3    leay  $08,y
         cmpy  D.ModEnd
         bne   L0BDF
         bra   L0C01
L0BEC    ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         cmpy  D.ModEnd
         bne   L0BDF
L0C01    stx   D.ModEnd
L0C03    ldx   <u0046
         bra   L0C0B
L0C07    ldu   ,x
         beq   L0C13
L0C0B    leax  -$02,x
         cmpx  <u005A
         bne   L0C07
         bra   L0C4B
L0C13    ldu   -$02,x
         bne   L0C0B
         tfr   x,y
         bra   L0C1F
L0C1B    ldu   ,y
         bne   L0C28
L0C1F    leay  -$02,y
L0C21    cmpy  <u005A
         bcc   L0C1B
         bra   L0C39
L0C28    leay  $02,y
         ldu   ,y
         stu   ,x
L0C2E    ldu   ,--y
         stu   ,--x
         beq   L0C3F
         cmpy  <u005A
         bne   L0C2E
L0C39    stx   <u005A
         bsr   L0C4D
         bra   L0C4B
L0C3F    leay  $02,y
         leax  $02,x
         bsr   L0C4D
         leay  -$04,y
         leax  -$02,x
         bra   L0C21
L0C4B    clrb
         rts
L0C4D    pshs  u
         ldu   D.ModDir
         bra   L0C5C
L0C53    cmpy  ,u
         bne   L0C5A
         stx   ,u
L0C5A    leau  u0008,u
L0C5C    cmpu  D.ModEnd
         bne   L0C53
         puls  pc,u
         emod
OS9End      equ   *
