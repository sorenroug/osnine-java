********************************************************************
* Original edition from Dragon Data OS-9 system disk
*
* Header for : RBF
* Module size: $CF7  #3319
* Module CRC : $A0D254 (Good)
* Hdr parity : $13
* Edition    : $07  #7
* Ty/La At/Rv: $D1 $81
* File Manager mod, 6809 Obj, re-ent, R/O

         nam   RBF
         ttl   Disk file manager

         ifp1
         use   defsfile
         endc

tylg     set   FlMgr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   RBFEnd,name,tylg,atrv,start,0

name     equ   *
         fcs   /RBF/
         fcb   7

DTBSiz    fcb   DRVMEM

* All routines are entered with
* (Y) = Path descriptor pointer
* (U) = Caller's register stack pointer
start    equ   *
         lbra  Create
         lbra  Open
         lbra  MakDir
         lbra  ChgDir
         lbra  Delete
         lbra  Seek
         lbra  Read
         lbra  Write
         lbra  ReadLn
         lbra  WriteLn
         lbra  GetStat
         lbra  PutStat
         lbra  Close

********************************************************************
* Y points to path descriptor
* U points to something also
Create   pshs  y
         leas  -$05,s
         lda   R$B,u
         anda  #^DIR.
         sta   R$B,u   save perms back
         lbsr  SchDir
         bcs   CREATE10
         ldb   #E$CEF
CREATE10 cmpb  #E$PNNF
         bne   CREATE20
         cmpa  #PDELIM    Compare '/
         beq   CREATE20
         pshs  x
         ldx   PD.RGS,y
         stu   R$X,x
         ldb   <PD.SBP,y
         ldx   <PD.SBP+1,y
         lda   <PD.SSZ,y
         ldu   <PD.SSZ+1,y
         pshs  u,x,b,a
         clra
         ldb   #$01
         lbsr  L08C3
         bcc   CREATE25
         leas  $08,s
CREATE20 leas  $05,s
         lbra  KillPth0
CREATE25 std   $0B,s
         ldb   <PD.SBP,y
         ldx   <PD.SBP+1,y
         stb   $08,s
         stx   $09,s
         puls  u,x,b,a
         stb   <PD.SBP,y
         stx   <PD.SBP+1,y
         sta   <PD.SSZ,y
         stu   <PD.SSZ+1,y
         ldd   <PD.DCP,y
         std   PD.CP,y
         ldd   <PD.DCP+2,y
         std   PD.CP+2,y
         lbsr  RdCurDir
         bcs   L00A7
L009E    tst   ,x
         beq   L00BC
         lbsr  RdNxtDir
         bcc   L009E
L00A7    cmpb  #E$EOF
         bne   CREATE20
         ldd   #$0020
         lbsr  L04AB
         bcs   CREATE20
         lbsr  L0237
         lbsr  CLRBUF   Is buffer modified?
         lbsr  RdCurDir
L00BC    leau  ,x
         lbsr  ZerDir
         puls  x
         os9   F$PrsNam
         bcs   CREATE20
         cmpb  #$1D
         bls   L00CE
         ldb   #$1D
L00CE    clra
         tfr   d,y
         lbsr  FromUser
         tfr   y,d
         ldy   $05,s
         decb
         lda   b,u
         ora   #$80
         sta   b,u
         ldb   ,s
         ldx   $01,s
         stb   <$1D,u
         stx   <$1E,u
         lbsr  PCPSEC
         bcs   L0144
         ldu   $08,y
         bsr   ZerBuf
         lda   #$04
         sta   $0A,y
         ldx   $06,y
         lda   $02,x
         sta   ,u
         ldx   D.Proc
         ldd   P$User,x
         std   FD.OWN,u
         lbsr  DateMod
         ldd   FD.DAT,u
         std   FD.Creat,u
         ldb   FD.DAT+2,u
         stb   FD.Creat+2,u
         ldb   #$01
         stb   FD.LNK,u
         ldd   $03,s
         subd  #$0001
         beq   L012B
         leax  <FD.SEG,u
         std   FDSL.B,x
         ldd   $01,s
         addd  #$0001
         std   FDSL.A+1,x
         ldb   ,s
         adcb  #$00
         stb   FDSL.A,x
L012B    ldb   ,s
         ldx   $01,s
         lbsr  PUTSEC
         bcs   L0144
         lbsr  Remove
         stb   <PD.FD,y
         stx   <PD.FD+1,y
         lbsr  L07A7
         leas  $05,s
         bra   L01BA

L0144    puls  u,x,a
         sta   <PD.SBP,y
         stx   <PD.SBP+1,y
         clr   <PD.SSZ,y
         stu   <PD.SSZ+1,y
         pshs  b
         lbsr  SECDEA
         puls  b
L0159    lbra  KillPth0

ZerDir    pshs  u,x,b,a
         leau  <$20,u
         bra   L0169

ZerBuf    pshs  u,x,b,a
         leau  >$0100,u
L0169    clra
         clrb
         tfr   d,x
L016D    pshu  x,b,a
         cmpu  $04,s
         bhi   L016D
         puls  pc,u,x,b,a

********************************************************************
* Y points to path descriptor
Open     pshs  y
         lbsr  SchDir
         bcs   L0159
         ldu   PD.RGS,y
         stx   R$X,u
         ldd   <PD.FD+1,y
         bne   L01B3
         lda   <PD.FD,y
         bne   L01B3
         ldb   PD.MOD,y
         andb  #DIR.
         lbne  L0273
         std   <PD.SBP,y
         sta   <PD.SBP+2,y
         std   <PD.SBL,y
         sta   <PD.SBL+2,y
         ldx   <PD.DTB,y
         lda   $02,x
         std   <$11,y
         sta   <$1B,y
         ldd   ,x
         std   $0F,y
         std   <$19,y
         puls  pc,y
L01B3    lda   $01,y
         lbsr  CHKACC
         bcs   L0159
L01BA    puls  y

* Copy from file descriptor to path descriptor
* U = file descriptor, Y = Path descriptor
L01BC    clra
         clrb
         std   PD.CP,y
         std   PD.CP+2,y
         std   <PD.SBL,y
         sta   <PD.SBL+2,y
         sta   <PD.SSZ,y
         lda   FD.ATT,u
         sta   <PD.ATT,y
         ldd   <FD.SEG+FDSL.A,u     Copy first segment from file descriptor
         std   <PD.SBP,y
         lda   <FD.SEG+FDSL.A+2,u
         sta   <PD.SBP+2,y
         ldd   <FD.SEG+FDSL.B,u
         std   <PD.SSZ+1,y
         ldd   FD.SIZ,u
         ldx   FD.SIZ+2,u
         std   PD.SIZ,y
         stx   <PD.SIZ+2,y
         clrb
         rts

********************************************************************
MakDir   lbsr  Create
         bcs   MakDir90
         ldd   #$0040       Set size for .. and .
         std   <PD.SIZ+2,y
         bsr   L0247
         bcs   MakDir90
         lbsr  L07B4
         bcs   MakDir90
         ldu   $08,y
         lda   ,u
         anda  #$BF
         ora   #$80    Set the directory flag
         sta   ,u
         bsr   L0237
         bcs   MakDir90
         lbsr  ZerBuf
         ldd   #$2EAE     Add ..
         std   DIR.NM,u
         stb   <DIR.SZ+DIR.NM,u   Add .
         lda   <PD.DFD,y
         sta   <DIR.FD,u
         ldd   <PD.DFD+1,y
         std   <DIR.FD+1,u
         lda   <PD.FD,y
         sta   <DIR.SZ+DIR.FD,u
         ldd   <PD.FD+1,y
         std   <DIR.SZ+DIR.FD+1,u
         lbsr  PCPSEC
MakDir90 bra   KillPth1

L0237    lbsr  GETFD

* Write file size in memory to file descriptor
L023A    ldx   PD.BUF,y
         ldd   PD.SIZ,y
         std   FD.SIZ,x
         ldd   <PD.SIZ+2,y
         std   FD.SIZ+2,x
         clr   PD.SMF,y
L0247    lbra  PUTFD

* Y points to path descriptor
Close    clra
         tst   PD.CNT,y
         bne   CLOSE20
         ldb   PD.MOD,y
         bitb  #WRITE.
         beq   KillPth1
         lbsr  CLRBUF   Is buffer modified?
         bcs   KillPth1
         ldd   <PD.FD,y
         bne   CLOSE10
         lda   <PD.FD+2,y
         beq   KillPth1
CLOSE10  bsr   DateMod
         bsr   L023A
         lbsr  L0515
         bcc   KillPth1
         lbsr  L0A18
         bra   KillPth1
CLOSE20  rts

L0273    ldb   #E$FNA   File not accessible
KillPth0    coma

KillPth puls  y
KillPth1  pshs  b,cc
         ldu   PD.BUF,y
         beq   L0284
         ldd   #$0100
         os9   F$SRtMem
L0284    puls  pc,b,cc

* Get date
DateMod  lbsr  GETFD
         ldu   PD.BUF,y
         lda   FD.LNK,u   Save link count as it will be overwritten by F$Time
         pshs  a
         leax  FD.DAT,u
         os9   F$Time
         puls  a
         sta   FD.LNK,u
         rts

* Y points to path descriptor
ChgDir   pshs  y
         lda   PD.MOD,y
         ora   #$80
         sta   PD.MOD,y
         lbsr  Open
         bcs   KillPth
         ldx   D.Proc
         lda   <$21,y
         ldu   <PD.FD+1,y
         ldb   $01,y
         bitb  #$03
         beq   L02BD
         ldb   <PD.FD,y
         std   <$1C,x
         stu   <$1E,x
L02BD    ldb   $01,y
         bitb  #$04
         beq   L02CC
         ldb   <PD.FD,y
         std   <$22,x
         stu   <$24,x
L02CC    clrb
         bra   KillPth

********************************************************************
Delete   pshs  y
         lbsr  SchDir
         bcs   KillPth
         ldd   <PD.FD+1,y
         bne   L02E2
         tst   <PD.FD,y
         lbeq  L0273
L02E2    lda   #$42
         lbsr  CHKACC
         bcs   L0356
         ldu   PD.RGS,y
         stx   R$X,u
         lbsr  GETFD
         bcs   L0356
         ldx   $08,y
         dec   $08,x
         beq   L02FD
         lbsr  PUTFD
         bra   L0323
L02FD    clra
         clrb
         std   PD.SIZ,y
         std   <PD.SIZ+2,y
         lbsr  L0A18
         bcs   L0356
         ldb   <PD.FD,y
         ldx   <PD.FD+1,y
         stb   <PD.SBP,y
         stx   <PD.SBP+1,y
         ldx   PD.BUF,y
         ldd   <$13,x
         addd  #$0001
         std   <$1A,y
         lbsr  SECDEA
L0323    bcs   L0356
         lbsr  CLRBUF   Is buffer modified?
         lbsr  Remove
         lda   <PD.DFD,y
         sta   <PD.FD,y
         ldd   <PD.DFD+1,y
         std   <PD.FD+1,y
         lbsr  L07A7
         lbsr  GETFD
         bcs   L0356
         lbsr  L01BC Copy from file descriptor to path descriptor
         ldd   <PD.DCP,y
         std   PD.CP,y
         ldd   <PD.DCP+2,y
         std   PD.CP+2,y
         lbsr  RdCurDir
         bcs   L0356
         clr   ,x
         lbsr  PCPSEC
L0356    lbra  KillPth

********************************************************************
Seek     ldb   PD.SMF,y
         bitb  #$02
         beq   L0372
         lda   $05,u
         ldb   $08,u
         subd  $0C,y
         bne   L036D
         lda   $04,u
         sbca  $0B,y
         beq   L0376
L036D    lbsr  CLRBUF   Is buffer modified?
         bcs   L037A
L0372    ldd   $04,u
         std   PD.CP,y
L0376    ldd   $08,u
         std   PD.CP+2,y
L037A    rts

********************************************************************
ReadLn   bsr   ReadInit
         bsr   L03A0
         pshs  u,y,x,b,a
         exg   x,u
         ldy   #$0000
         lda   #C$CR
L0389    leay  $01,y
         cmpa  ,x+     Detected CR?
         beq   L0392
         decb
         bne   L0389
L0392    ldx   $06,s
         bsr   ToUser
         sty   $0A,s
         puls  u,y,x,b,a
         ldd   $02,s
         leax  d,x
         rts

L03A0    bsr   L0403
         lda   ,-x
         cmpa  #C$CR
         beq   L03AC
         ldd   $02,s
         bne   L0409
L03AC    ldu   $06,y
         ldd   $06,u
         subd  $02,s
         std   $06,u
         leas  $08,s
         rts

ReadInit    ldd   $06,u
         bsr   L03C0
         bcs   L03E4
         std   $06,u
         rts

L03C0    pshs  b,a
         ldd   <$11,y
         subd  $0D,y
         tfr   d,x
         ldd   $0F,y
         sbcb  $0C,y
         sbca  $0B,y
         bcs   L03E1
         bne   L03DE
         tstb
         bne   L03DE
         cmpx  ,s
         bcc   L03DE
         stx   ,s
         beq   L03E1
L03DE    clrb
         puls  pc,b,a
L03E1    comb
         ldb   #E$EOF
L03E4    leas  $02,s
         rts

ToUser    lbra  FromUser

********************************************************************
Read     bsr   ReadInit
         bsr   L03FB
L03EE    pshs  u,y,x,b,a
         exg   x,u
         tfr   d,y
         bsr   ToUser
         puls  u,y,x,b,a
         leax  d,x
         rts

L03FB    bsr   L0403
         bne   L0409
         clrb
L0400    leas  $08,s
         rts

L0403    ldd   $04,u
         ldx   $06,u
         pshs  x,b,a
L0409    lda   $0A,y
         bita  #$02
         bne   L042D
         lbsr  CLRBUF   Is buffer modified?
         bcs   L0400
         tst   $0E,y
         bne   L0428
         tst   $02,s
         beq   L0428
         leax  <L048F,pcr
         cmpx  $06,s
         bne   L0428
         lbsr  L0BB8
         bra   L042B
L0428    lbsr  L0B96
L042B    bcs   L0400
L042D    ldu   $08,y
         clra
         ldb   $0E,y
         leau  d,u
         negb
         sbca  #$FF
         ldx   ,s
         cmpd  $02,s
         bls   L0440
         ldd   $02,s
L0440    pshs  b,a
         jsr   [<$08,s]
         stx   $02,s
         ldb   $01,s
         addb  $0E,y
         stb   $0E,y
         bne   L045C
         lbsr  CLRBUF   Is buffer modified?
         inc   $0D,y
         bne   L045C
         inc   $0C,y
         bne   L045C
         inc   $0B,y
L045C    ldd   $04,s
         subd  ,s++
         std   $02,s
         jmp   [<$04,s]

********************************************************************
WriteLn  pshs  y
         clrb
         ldy   R$Y,u
         beq   L0483
         ldx   R$X,u    Get address of buffer to write to
L046F    leay  -$01,y
         beq   L0483
         lda   ,x+
         cmpa  #C$CR
         bne   L046F
         tfr   y,d
         nega
         negb
         sbca  #$00
         addd  R$Y,u
         std   R$Y,u
L0483    puls  y

********************************************************************
Write    ldd   R$Y,u
         beq   L04A9
         bsr   L04AB
         bcs   L04AA
         bsr   L04A0
L048F    pshs  y,b,a
         tfr   d,y
         bsr   FromUser
         puls  y,b,a
         leax  d,x
         lda   $0A,y
         ora   #$03
         sta   $0A,y
         rts
L04A0    lbsr  L0403
         lbne  L0409
         leas  $08,s
L04A9    clrb
L04AA    rts
L04AB    addd  $0D,y
         tfr   d,x
         ldd   $0B,y
         adcb  #$00
         adca  #$00
L04B5    cmpd  $0F,y
         bcs   L04A9
         bhi   L04C1
         cmpx  <$11,y
         bls   L04A9
L04C1    pshs  u
         ldu   <$11,y
         stx   <$11,y
         ldx   $0F,y
         std   $0F,y
         pshs  u,x
         lbsr  L07B4
         puls  u,x
         bcc   L04DB
         stx   $0F,y
         stu   <$11,y
L04DB    puls  pc,u

FromUser    pshs  u,y,x
         ldd   $02,s
         beq   L0506
         leay  d,u
         lsrb
         bcc   L04EC
         lda   ,x+
         sta   ,u+
L04EC    lsrb
         bcc   L04F3
         ldd   ,x++
         std   ,u++
L04F3    pshs  y
         exg   x,u
         bra   L0500
L04F9    pulu  y,b,a
         std   ,x++
         sty   ,x++
L0500    cmpx  ,s
         bcs   L04F9
         leas  $02,s
L0506    puls  pc,u,y,x

********************************************************************
GetStat  ldb   R$B,u
         cmpb  #SS.Opt
         beq   L052E
         cmpb  #SS.EOF
         bne   L051A
         clr   R$B,u
         clra
L0515    ldb   #$01
         lbra  L03C0

L051A    cmpb  #SS.Ready
         bne   L0521
         clr   R$B,u
         rts

L0521    cmpb  #SS.Size
         bne   L052F
         ldd   PD.SIZ,y
         std   R$X,u
         ldd   <PD.SIZ+2,y
         std   R$U,u
L052E    rts

L052F    cmpb  #SS.Pos
         bne   L053C
         ldd   PD.CP,y
         std   R$X,u
         ldd   PD.CP+2,y
         std   R$U,u
         rts

L053C    cmpb  #SS.FD  Read PD sector
         bne   L0556
         lbsr  GETFD
         bcs   L052E
         ldu   PD.RGS,y
         ldd   R$Y,u
         tsta
         beq   L054F
         ldd   #$0100
L054F    ldx   R$X,u
         ldu   PD.BUF,y
         lbra  L03EE

L0556    lda   #3*3 Getstat entry in branch table
         lbra  L0C64

********************************************************************
PutStat  ldb   R$B,u
         cmpb  #SS.Opt
         bne   L056F
         ldx   R$X,u
         leax  $02,x
         leau  <$22,y
         ldy   #$000D
         lbra  FromUser

L056F    cmpb  #SS.Size
         bne   L05AF
         ldd   <PD.FD+1,y
         bne   L057D
         tst   <PD.FD,y
         beq   L05B4
L057D    lda   $01,y
         bita  #$02
         beq   L05AB
         ldd   R$X,u
         ldx   R$U,u
         cmpd  PD.SIZ,y
         bcs   L0596
         bne   L0593
         cmpx  <PD.SIZ+2,y
         bcs   L0596
L0593    lbra  L04B5

L0596    std   PD.SIZ,y
         stx   <PD.SIZ+2,y
         ldd   PD.CP,y
         ldx   PD.CP+2,y
         pshs  x,d
         lbsr  L0A18
         puls  u,x
         stx   PD.CP,y
         stu   PD.CP+2,y
         rts
L05AB    comb
         ldb   #E$BMode
         rts

L05AF    lda   #4*3  Putstat entry in branch table
         lbra  L0C64

L05B4    comb
         ldb   #E$UnkSvc
L05B7    rts


SchDir    ldd   #$0100
         stb   $0A,y
         os9   F$SRqMem
         bcs   L05B7
         stu   PD.BUF,y
         ldx   PD.RGS,y
         ldx   R$X,x
         pshs  u,y,x
         leas  -$04,s
         clra
         clrb
         sta   <PD.FD,y
         std   <PD.FD+1,y
         std   <PD.DSK,y
         lda   R$CC,x
         sta   ,s
         cmpa  #PDELIM
         bne   SchDir20
         lbsr  RBPNam
         sta   ,s
         lbcs  L06D2
         leax  ,y
         ldy   $06,s
         bra   L0612
SchDir20    anda  #$7F     Remove high bit
         cmpa  #'@
         beq   L0612
         lda   #PDELIM
         sta   ,s
         leax  -$01,x
         lda   $01,y
         ldu   D.Proc
         leau  <P$DIO,u
         bita  #$24
         beq   L0608
         leau  $06,u
L0608    ldb   $03,u
         stb   <PD.FD,y
         ldd   $04,u
         std   <PD.FD+1,y
L0612    ldu   PD.DEV,y
         stu   <PD.DVT,y
         lda   <PD.DRV,y
         ldb   >DTBSiz,pcr
         mul
         addd  $02,u
         addd  #$000F
         std   <PD.DTB,y
         lda   ,s
         anda  #$7F
         cmpa  #'@
         bne   L0633
         leax  $01,x
         bra   L0655
L0633    lbsr  L0C30
         lbcs  L06DA
         ldu   PD.BUF,y
         ldd   $0E,u
         std   <PD.DSK,y
         ldd   <PD.FD+1,y
         bne   L0655
         lda   <PD.FD,y
         bne   L0655
         lda   $08,u
         sta   <PD.FD,y
         ldd   $09,u
         std   <PD.FD+1,y
L0655    stx   $04,s
         stx   $08,s
L0659    lbsr  CLRBUF   Is buffer modified?
         lbsr  L07A7
         bcs   L06DA
         lda   ,s
         cmpa  #PDELIM
         bne   L06BC
         clr   $02,s
         clr   $03,s
         lda   PD.MOD,y
         ora   #$80
         lbsr  CHKACC
         bcs   L06D2
         lbsr  L01BC Copy from file descriptor to path descriptor
         ldx   $08,s
         leax  $01,x
         lbsr  RBPNam
         std   ,s
         stx   $04,s
         sty   $08,s
         ldy   $06,s
         bcs   L06D2
         lbsr  RdCurDir
         bra   L0693
L068F    bsr   SaveDel
L0691    bsr   RdNxtDir
L0693    bcs   L06D2
         tst   ,x
         beq   L068F
         leay  ,x
         ldx   $04,s
         ldb   $01,s
         clra
         os9   F$CmpNam
         ldx   $06,s
         exg   x,y
         bcs   L0691
         bsr   L06EB
         lda   <$1D,x
         sta   <PD.FD,y
         ldd   <$1E,x
         std   <PD.FD+1,y
         lbsr  Remove
         bra   L0659
L06BC    ldx   $08,s
         tsta
         bmi   L06C9
         os9   F$PrsNam
         leax  ,y
         ldy   $06,s
L06C9    stx   $04,s
         clra
L06CC    lda   ,s
         leas  $04,s
         puls  pc,u,y,x
L06D2    cmpb  #$D3
         bne   L06DA
         bsr   SaveDel
         ldb   #E$PNNF
L06DA    coma
         bra   L06CC

SaveDel    pshs  b,a
         lda   $04,s
         cmpa  #PDELIM
         beq   L0705
         ldd   $06,s
         bne   L0705
         puls  b,a
L06EB    pshs  b,a
         stx   $06,s
         lda   <PD.FD,y
         sta   <PD.DFD,y
         ldd   <PD.FD+1,y
         std   <PD.DFD+1,y
         ldd   PD.CP,y
         std   <PD.DCP,y
         ldd   PD.CP+2,y
         std   <PD.DCP+2,y
L0705    puls  pc,b,a

RdNxtDir    ldb   $0E,y
         addb  #$20
         stb   $0E,y
         bcc   RdCurDir
         lbsr  CLRBUF   Is buffer modified?
         inc   $0D,y
         bne   RdCurDir
         inc   $0C,y
         bne   RdCurDir
         inc   $0B,y
RdCurDir    ldd   #$0020
         lbsr  L03C0
         bcs   L073B
         lda   $0A,y
         bita  #$02
         bne   L0734
         lbsr  L0BB8
         bcs   L073B
         lbsr  L0B96
         bcs   L073B
L0734    ldb   $0E,y
         lda   $08,y
         tfr   d,x
         clrb
L073B    rts

RBPNam    os9   F$PrsNam
         pshs  x
         bcc   L076B
         clrb
L0744    pshs  a
         anda  #$7F
         cmpa  #PDIR
         puls  a
         bne   L075F
         incb
         leax  $01,x
         tsta
         bmi   L075F
         lda   ,x
         cmpb  #$03
         bcs   L0744
         lda   #PDELIM
         decb
         leax  -$03,x
L075F    tstb
         bne   L0767
         comb
         ldb   #E$BPNam
         puls  pc,x

L0767    leay  ,x
         andcc #$FE
L076B    puls  pc,x

CHKACC    tfr   a,b
         anda  #$07
         andb  #$C0
         pshs  x,b,a
         lbsr  GETFD
         bcs   L079C
         ldu   $08,y
         ldx   D.Proc
         ldd   P$User,x
         beq   L0785      Is userid=0?
         cmpd  FD.OWN,u
L0785    puls  a
         beq   L078C
         lsla
         lsla
         lsla
L078C    ora   ,s
         anda  #$BF
         pshs  a
         ora   #$80
         anda  ,u
         cmpa  ,s
         beq   L07A5
         ldb   #E$FNA
L079C    leas  $02,s
         coma
         puls  pc,x
         ldb   #E$Share
         bra   L079C
L07A5    puls  pc,x,b,a

L07A7    clra
         clrb
         std   PD.CP,y
         std   PD.CP+2,y
         sta   <PD.SSZ,y
         std   <PD.SSZ+1,y
Remove    rts

L07B4    pshs  u,x
L07B6    bsr   L0812
         bne   L07C6
         cmpx  <$1A,y
         bcs   L080D
         bne   L07C6
         lda   <$12,y
         beq   L080D
L07C6    lbsr  GETFD
         bcs   L080A
         ldx   PD.CP,y
         ldu   PD.CP+2,y
         pshs  u,x
         ldd   PD.SIZ,y
         std   PD.CP,y
         ldd   <PD.SIZ+2,y
         std   PD.CP+2,y
         lbsr  L0BD2
         puls  u,x
         stx   PD.CP,y
         stu   PD.CP+2,y
         bcc   L080D
         cmpb  #E$NES
         bne   L080A
         bsr   L0812
         bne   L07F6
         tst   <$12,y
         beq   L07F9
         leax  $01,x
         bne   L07F9
L07F6    ldx   #$FFFF
L07F9    tfr   x,d
         tsta
         bne   L0806
         cmpb  <$2E,y
         bcc   L0806
         ldb   <$2E,y
L0806    bsr   L0820
         bcc   L07B6
L080A    coma
         puls  pc,u,x
L080D    lbsr  L0BB8
         puls  pc,u,x
L0812    ldd   <$10,y
         subd  <$14,y
         tfr   d,x
         ldb   $0F,y
         sbcb  <$13,y
         rts
L0820    pshs  u,x
         lbsr  L08C3
         bcs   L085C
         lbsr  GETFD
         bcs   L085C
         ldu   $08,y
         clra
         clrb
         std   $09,u
         std   $0B,u
         leax  <$10,u
         ldd   $03,x
         beq   L08A4
         ldd   $08,y
         inca
         pshs  b,a
         bra   L084F
L0842    clrb
         ldd   -$02,x
         beq   L0858
         addd  $0A,u
         std   $0A,u
         bcc   L084F
         inc   $09,u
L084F    leax  $05,x
         cmpx  ,s
         bcs   L0842
         comb
         ldb   #E$SLF
L0858    leas  $02,s
         leax  -$05,x
L085C    bcs   L08C1
         ldd   -$04,x
         addd  -$02,x
         pshs  b,a
         ldb   -$05,x
         adcb  #$00
         cmpb  <$16,y
         puls  b,a
         bne   L08A4
         cmpd  <$17,y
         bne   L08A4
         ldu   <$1E,y
         ldd   $06,u
         ldu   $08,y
         subd  #$0001
         coma
         comb
         pshs  b,a
         ldd   -$05,x
         eora  <$16,y
         eorb  <$17,y
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         anda  ,s+
         andb  ,s+
         std   -$02,s
         bne   L08A4
         ldd   -$02,x
         addd  <$1A,y
         bcs   L08A4
         std   -$02,x
         bra   L08B3
L08A4    ldd   <$16,y
         std   ,x
         lda   <$18,y
         sta   $02,x
         ldd   <$1A,y
         std   $03,x
L08B3    ldd   $0A,u
         addd  <$1A,y
         std   $0A,u
         bcc   L08BE
         inc   $09,u
L08BE    lbsr  PUTFD
L08C1    puls  pc,u,x

L08C3    pshs  u,y,x,b,a
         ldb   #$0D
L08C7    clr   ,-s
         decb
         bne   L08C7
         ldx   <$1E,y
         ldd   $04,x
         std   $05,s
         ldd   $06,x
         std   $03,s
         std   $0B,s
         ldx   $03,y
         ldx   $04,x
         leax  <$12,x
         subd  #$0001
         addb  $0E,x
         adca  #$00
         bra   L08EB

L08E9    lsra
         rorb
L08EB    lsr   $0B,s
         ror   $0C,s
         bcc   L08E9
         std   $01,s
         ldd   $03,s
         std   $0B,s
         subd  #$0001
         addd  $0D,s
         bcc   L0905
         ldd   #$FFFF
         bra   L0905

L0903    lsra
         rorb
L0905    lsr   $0B,s
         ror   $0C,s
         bcc   L0903
         cmpa  #$08
         bcs   L0912
         ldd   #$0800
L0912    std   $0D,s
         lbsr  L0B49
         lbcs  L0A0C
         ldx   <$1E,y
         ldd   <$1A,x
         cmpd  $0E,x
         bne   L0944
         lda   <$1C,x
         cmpa  $04,x
         bne   L0944
         ldd   $0D,s
         cmpd  $01,s
         bcs   L0951
         lda   <$1D,x
         cmpa  $04,x
         bcc   L0944
         sta   $07,s
* Difference from Ed 6.
         nega
         adda  $05,s
         sta   $05,s
         bra   L0951
L0944    ldd   $0E,x
         std   <$1A,x
         lda   $04,x
         sta   <$1C,x
         clr   <$1D,x
L0951    inc   $07,s
         ldb   $07,s
         lbsr  L0B8F
         lbcs  L0A0C
         ldd   $05,s
         tsta
         beq   L0964
         ldd   #$0100
L0964    ldx   $08,y
         leau  d,x
         ldy   $0D,s
         clra
         clrb
         os9   F$SchBit
         pshs  b,a,cc
         tst   $03,s
         bne   L097F
         cmpy  $04,s
         bcs   L097F
         lda   $0A,s
         sta   $03,s
L097F    puls  b,a,cc
         bcc   L09B2
         cmpy  $09,s
         bls   L0991
         sty   $09,s
         std   $0B,s
         lda   $07,s
         sta   $08,s
L0991    ldy   <$11,s
         tst   $05,s
         beq   L099D
         dec   $05,s
         bra   L0951
L099D    ldb   $08,s
         beq   L0A0A
         clra
         cmpb  $07,s
         beq   L09AB
         stb   $07,s
         lbsr  L0B8F
L09AB    ldx   $08,y
         ldd   $0B,s
         ldy   $09,s
L09B2    std   $0B,s
         sty   $09,s
         os9   F$AllBit
         ldy   <$11,s
         ldb   $07,s
         lbsr  L0B77
         bcs   L0A0C
         lda   ,s
         beq   L09D0
         ldx   <$1E,y
         deca
         sta   <$1D,x
L09D0    lda   $07,s
         deca
         clrb
         lsla
         rolb
         lsla
         rolb
         lsla
         rolb
         stb   <$16,y
         ora   $0B,s
         ldb   $0C,s
         ldx   $09,s
         ldy   <$11,s
         std   <$17,y
         stx   <$1A,y
         ldd   $03,s
         bra   L0A00
L09F1    lsl   <$18,y
         rol   <$17,y
         rol   <$16,y
         lsl   <$1B,y
         rol   <$1A,y
L0A00    lsra
         rorb
         bcc   L09F1
         clrb
         ldd   <$1A,y
         bra   L0A14
L0A0A    ldb   #E$Full
L0A0C    ldy   <$11,s
         lbsr  L0B7E
         coma
L0A14    leas  $0F,s
         puls  pc,u,y,x

L0A18    clra
         lda   PD.MOD,y
         bita  #$80
         bne   L0A7A
         ldd   PD.SIZ,y
         std   PD.CP,y
         ldd   <PD.SIZ+2,y
         std   PD.CP+2,y
         lbsr  L0BD2
         bcc   L0A31
         cmpb  #E$NES
         bra   L0A72

L0A31    ldd   <$14,y
         subd  $0C,y
         addd  <$1A,y
         tst   $0E,y
         beq   L0A40
         subd  #$0001
L0A40    pshs  b,a
         ldu   <PD.DTB,y
         ldd   $06,u
         subd  #$0001
         coma
         comb
         anda  ,s+
         andb  ,s+
         ldu   <$1A,y
         std   <$1A,y
         beq   L0A74
         tfr   u,d
         subd  <$1A,y
         pshs  x,b,a
         addd  <$17,y
         std   <$17,y
         bcc   L0A6A
         inc   <$16,y
L0A6A    bsr   SECDEA
         bcc   L0A7B
         leas  $04,s
         cmpb  #E$IBA
L0A72    bne   L0A79
L0A74    lbsr  GETFD
         bcc   L0A84
L0A79    coma
L0A7A    rts

L0A7B    lbsr  GETFD
         bcs   L0AD4
         puls  x,b,a
         std   $03,x
L0A84    ldu   PD.BUF,y
         ldd   <PD.SIZ+2,y
         std   FD.SIZ+2,u
         ldd   PD.SIZ,y
         std   FD.SIZ,u
         tfr   x,d
         clrb
         inca
         leax  $05,x
         pshs  x,b,a
         bra   L0ABF
L0A99    ldd   -$02,x
         beq   L0ACC
         std   <$1A,y
         ldd   -$05,x
         std   <$16,y
         lda   -$03,x
         sta   <$18,y
         bsr   SECDEA
         bcs   L0AD4
         stx   $02,s
         lbsr  GETFD
         bcs   L0AD4
         ldx   $02,s
         clra
         clrb
         std   -$05,x
         sta   -$03,x
         std   -$02,x
L0ABF    lbsr  PUTFD
         bcs   L0AD4
         ldx   $02,s
         leax  $05,x
         cmpx  ,s
         bcs   L0A99
L0ACC    clra
         clrb
         sta   <PD.SSZ,y
         std   <PD.SSZ+1,y
L0AD4    leas  $04,s
         rts

SECDEA    pshs  u,y,x,a
         ldx   <$1E,y
         ldd   $06,x
         subd  #$0001
         addd  <PD.SBP+1,y
         std   <PD.SBP+1,y
         ldd   $06,x
         bcc   L0AFF
         inc   <PD.SBP,y
         bra   L0AFF
L0AF0    lsr   <$16,y
         ror   <$17,y
         ror   <$18,y
         lsr   <$1A,y
         ror   <$1B,y
L0AFF    lsra
         rorb
         bcc   L0AF0
         clrb
         ldd   <$1A,y
         beq   L0B47
         ldd   <$16,y
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         tfr   b,a
         ldb   #E$IBA
         cmpa  $04,x
         bhi   L0B46
         cmpa  <$1D,x
         bcc   L0B22
         sta   <$1D,x
L0B22    inca
         sta   ,s
L0B25    bsr   L0B49
         bcs   L0B25
         ldb   ,s
         bsr   L0B8F
         bcs   L0B46
         ldx   $08,y
         ldd   <$17,y
         anda  #$07
         ldy   <PD.SSZ+1,y
         os9   F$DelBit
         ldy   $03,s
         ldb   ,s
         bsr   L0B77
         bcc   L0B47
L0B46    coma
L0B47    puls  pc,u,y,x,a
L0B49    lbsr  CLRBUF   Is buffer modified?
         bra   L0B53

L0B4E    os9   F$IOQu
         bsr   L0B63
L0B53    bcs   L0B62
         ldx   <$1E,y
         lda   <$17,x
         bne   L0B4E
         lda   $05,y
         sta   <$17,x
L0B62    rts

L0B63    ldu   D.Proc
         ldb   <P$Signal,u
         beq   L0B6E
         cmpb  #$03
         bls   L0B75
L0B6E    clra
         lda   P$State,u
         bita  #$02
         beq   L0B76
L0B75    coma
L0B76    rts

L0B77    clra
         tfr   d,x
         clrb
         lbsr  PUTSEC
L0B7E    pshs  cc
         ldx   <$1E,y
         lda   $05,y
         cmpa  <$17,x
         bne   L0B8D
         clr   <$17,x
L0B8D    puls  pc,cc
L0B8F    clra
         tfr   d,x
         clrb
         lbra  GETSEC
L0B96    pshs  u,x
         bsr   L0BB8
         bcs   L0BA7
         lbsr  L0C5C
         bcs   L0BA7
         lda   $0A,y
         ora   #$02
         sta   $0A,y
L0BA7    puls  pc,u,x

         pshs  u,x
         lbsr  PCPSEC
         bcs   L0BB6
         lda   $0A,y
         anda  #$FE
         sta   $0A,y
L0BB6    puls  pc,u,x

L0BB8    ldd   $0C,y
         subd  <$14,y
         tfr   d,x
         ldb   $0B,y
         sbcb  <$13,y
         cmpb  <$19,y
         bcs   L0BD0
         bhi   L0BD2
         cmpx  <$1A,y
         bcc   L0BD2
L0BD0    clrb
         rts

L0BD2    pshs  u
         bsr   GETFD
         bcs   L0C2C
         clra
         clrb
         std   <$13,y
         stb   <$15,y
         ldu   $08,y
         leax  <$10,u
         lda   $08,y
         ldb   #E$Lock
         pshs  b,a
L0BEB    ldd   $03,x
         beq   L0C10
         addd  <$14,y
         tfr   d,u
         ldb   <$13,y
         adcb  #$00
         cmpb  $0B,y
         bhi   L0C1D
         bne   L0C04
         cmpu  $0C,y
         bhi   L0C1D
L0C04    stb   <$13,y
         stu   <$14,y
         leax  $05,x
         cmpx  ,s
         bcs   L0BEB
L0C10    clra
         clrb
         sta   <$19,y
         std   <$1A,y
         comb
         ldb   #E$NES
         bra   L0C2C
L0C1D    ldd   ,x
         std   <$16,y
         lda   $02,x
         sta   <$18,y
         ldd   $03,x
         std   <$1A,y
L0C2C    leas  $02,s
         puls  pc,u
L0C30    pshs  x,b
         lbsr  CLRBUF   Is buffer modified?
         bcs   L0C3F
         clrb
         ldx   #$0000
         bsr   GETSEC
         bcc   L0C41
L0C3F    stb   ,s
L0C41    puls  pc,x,b

* Check/load descriptor sector into buffer
GETFD    ldb   PD.SMF,y
         bitb  #$04
         bne   L0BD0      Clear B and return
         lbsr  CLRBUF   Is buffer modified?
         bcs   L0CBD
         ldb   PD.SMF,y
         orb   #$04
         stb   PD.SMF,y
         ldb   <PD.FD,y
         ldx   <PD.FD+1,y
         bra   GETSEC

L0C5C    bsr   CLRBUF   Is buffer modified?
         bcs   L0CBD
         bsr   GETCP
GETSEC    lda   #1*3    Read entry in branch table

L0C64    pshs  u,y,x,b,a
         ldu   PD.DEV,y
         ldu   V$STAT,u
         bra   L0C6F

L0C6C    os9   F$IOQu
L0C6F    lda   $04,u
         bne   L0C6C
         lda   PD.CPR,y
         sta   $04,u
         ldd   0,s
         ldx   2,s
         pshs  u
         bsr   L0C8B
         puls  u
         lda   #0
         sta   $04,u
         bcc   L0C89
         stb   $01,s
L0C89    puls  pc,u,y,x,b,a

L0C8B    pshs  pc,x,b,a
         ldx   PD.DEV,y
         ldd   ,x
         ldx   ,x
         addd  $09,x
         addb  ,s
         adca  #$00
         std   $04,s
         puls  pc,x,b,a

PUTFD    ldb   <PD.FD,y
         ldx   <PD.FD+1,y
         bra   PUTSEC

PCPSEC    bsr   GETCP
PUTSEC    lda   #2*3 Write-entry in branch table
         pshs  x,b,a
         ldd   <PD.DSK,y
         beq   L0CB6
         ldx   <PD.DTB,y
         cmpd  DD.DSK,x
L0CB6    puls  x,b,a
         beq   L0C64
         comb
         ldb   #E$DIDC  Disk ID change
L0CBD    rts

GETCP    ldd   $0C,y
         subd  <$14,y
         tfr   d,x
         ldb   $0B,y
         sbcb  <$13,y
         exg   d,x
         addd  <$17,y
         exg   d,x
         adcb  <$16,y
         rts

***************
* Subroutine CLRBUF
*   Clear Buffer

CLRBUF    clrb
         pshs  u,x
         ldb   PD.SMF,y
         andb  #$06
         beq   L0CF2
         tfr   b,a
         eorb  PD.SMF,y
         stb   PD.SMF,y
         andb  #$01
         beq   L0CF2
         eorb  PD.SMF,y
         stb   PD.SMF,y
         bita  #$02
         beq   L0CF2
         bsr   PCPSEC
L0CF2    puls  pc,u,x
         emod
RBFEnd      equ   *
