* From Eurohard L1 v.2.0

* Header for : Rbf
* Module size: $CF5  #3317
* Module CRC : $B9BD40 (Good)
* Hdr parity : $11
* Edition    : $08  #8
* Ty/La At/Rv: $D1 $81
* File Manager mod, 6809 Obj, re-ent, R/O

         nam   Rbf
         ttl   Module Header & entries

         ifp1
         use   defsfile
         endc
tylg     set   FlMgr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   0
size     equ   .
name     equ   *
         fcs   /Rbf/
         fcb   $08
L0011    fcb   $26

start    equ   *
         lbra  Create
         lbra  L0176
         lbra  MakDir
         lbra  ChgDir
         lbra  Delete
         lbra  Seek
         lbra  L03E8
         lbra  L0483
         lbra  ReadLn
         lbra  WritLine
         lbra  GetStat
         lbra  PutStat
         lbra  Close

 ttl Random Block file service request routines

Create    pshs  y
         leas  -$05,s
         lda   $02,u
         anda  #$7F
         sta   $02,u
         lbsr  SchDir
         bcs   L004A
         ldb   #$DA
L004A    cmpb  #$D8
         bne   L0070
         cmpa  #$2F
         beq   L0070
         pshs  x
         ldx   $06,y
         stu   $04,x
         ldb   <$16,y
         ldx   <$17,y
         lda   <$19,y
         ldu   <$1A,y
         pshs  u,x,b,a
         clra
         ldb   #$01
         lbsr  L08C1
         bcc   L0075
         leas  $08,s
L0070    leas  $05,s
         lbra  L0275
L0075    std   $0B,s
         ldb   <$16,y
         ldx   <$17,y
         stb   $08,s
         stx   $09,s
         puls  u,x,b,a
         stb   <$16,y
         stx   <$17,y
         sta   <$19,y
         stu   <$1A,y
         ldd   <$3A,y
         std   $0B,y
         ldd   <$3C,y
         std   $0D,y
         lbsr  L071A
         bcs   L00A7
L009E    tst   ,x
         beq   L00BC
         lbsr  L0705
         bcc   L009E
L00A7    cmpb  #$D3
         bne   L0070
         ldd   #$0020
         lbsr  L04A9
         bcs   L0070
         lbsr  L0237
         lbsr  L0CD3
         lbsr  L071A
L00BC    leau  ,x
         lbsr  L015C
         puls  x
         os9   F$PrsNam
         bcs   L0070
         cmpb  #$1D
         bls   L00CE
         ldb   #$1D
L00CE    clra
         tfr   d,y
         lbsr  L04DB
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
         lbsr  L0CA3
         bcs   L0144
         ldu   $08,y
         bsr   ZerBuf
         lda   #$04
         sta   $0A,y
         ldx   $06,y
         lda   $02,x
         sta   ,u
         ldx   D.Proc
         ldd   $09,x
         std   $01,u
         lbsr  DateMod
         ldd   $03,u
         std   $0D,u
         ldb   $05,u
         stb   $0F,u
         ldb   #$01
         stb   $08,u
         ldd   $03,s
         subd  #$0001
         beq   L012B
         leax  <$10,u
         std   $03,x
         ldd   $01,s
         addd  #$0001
         std   $01,x
         ldb   ,s
         adcb  #$00
         stb   ,x
L012B    ldb   ,s
         ldx   $01,s
         lbsr  L0CA5
         bcs   L0144
         lbsr  L07B1
         stb   <$34,y
         stx   <$35,y
         lbsr  L07A5
         leas  $05,s
         bra   L01BA
L0144    puls  u,x,a
         sta   <$16,y
         stx   <$17,y
         clr   <$19,y
         stu   <$1A,y
         pshs  b
         lbsr  L0AD5
         puls  b
L0159    lbra  L0275
L015C    pshs  u,x,b,a
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
L0176    pshs  y
         lbsr  SchDir
         bcs   L0159
         ldu   $06,y
         stx   $04,u
         ldd   <$35,y
         bne   L01B3
         lda   <$34,y
         bne   L01B3
         ldb   $01,y
         andb  #$80
         lbne  L0273
         std   <$16,y
         sta   <$18,y
         std   <$13,y
         sta   <$15,y
         ldx   <$1E,y
         lda   $02,x
         std   <$11,y
         sta   <$1B,y
         ldd   ,x
         std   $0F,y
         std   <$19,y
         puls  pc,y
L01B3    lda   $01,y
         lbsr  L076B
         bcs   L0159
L01BA    puls  y
L01BC    clra
         clrb
         std   $0B,y
         std   $0D,y
         std   <$13,y
         sta   <$15,y
         sta   <$19,y
         lda   ,u
         sta   <$33,y
         ldd   <$10,u
         std   <$16,y
         lda   <$12,u
         sta   <$18,y
         ldd   <$13,u
         std   <$1A,y
         ldd   $09,u
         ldx   $0B,u
         std   $0F,y
         stx   <$11,y
         clrb
         rts

 page
***************
* Subroutine Makdir
*   Creates A New (Sub-Ordinate) Dir

* Passed: (Y)=PD

MakDir    lbsr  Create
         bcs   MakDir90
         ldd   #$0040
         std   <$11,y
         bsr   WrtFDS90
         bcs   MakDir90
         lbsr  L07B2
         bcs   MakDir90
         ldu   $08,y
         lda   ,u
         anda  #$BF
         ora   #$80
         sta   ,u
         bsr   L0237
         bcs   MakDir90
         lbsr  ZerBuf
         ldd   #$2EAE
         std   ,u
         stb   <$20,u
         lda   <$37,y
         sta   <$1D,u
         ldd   <$38,y
         std   <$1E,u
         lda   <$34,y
         sta   <$3D,u
         ldd   <$35,y
         std   <$3E,u
         lbsr  L0CA3
MakDir90    bra   KillPth1

***************
* Subroutine WrtFDSiz
*   Update file size in FD sector.  Called by Create, Makdir.

L0237    lbsr  GETFD
L023A    ldx   $08,y
         ldd   $0F,y
         std   $09,x
         ldd   <$11,y
         std   $0B,x
         clr   $0A,y
WrtFDS90    lbra  PUTFD

 page
***************
* Subroutine Close
*   Close Path, Update FD if necessary

Close    clra
         tst   $02,y
         bne   L0272
         ldb   $01,y
         bitb  #$02
         beq   KillPth1
         lbsr  L0CD3
         bcs   KillPth1
         ldd   <$34,y
         bne   L0264
         lda   <$36,y
         beq   KillPth1
L0264    bsr   DateMod
         bsr   L023A
         lbsr  L0513
         bcc   KillPth1
         lbsr  L0A16
         bra   KillPth1
L0272    rts

L0273    ldb   #$D6
L0275    coma

KillPth    puls  y
KillPth1    pshs  b,cc
         ldu   $08,y
         beq   L0284
         ldd   #$0100
         os9   F$SRtMem

L0284    puls  pc,b,cc

DateMod    lbsr  GETFD
         ldu   $08,y
         lda   $08,u
         pshs  a
         leax  $03,u
         os9   F$Time
         puls  a
         sta   $08,u
         rts

***************
* Subroutine Chgdir
*   Change User'S Current Working Dir

* Passed: (Y)=PD

ChgDir    pshs  y
         lda   $01,y
         ora   #$80
         sta   $01,y
         lbsr  L0176
         bcs   KillPth
         ldx   D.Proc
         lda   <$21,y
         ldu   <$35,y
         ldb   $01,y
         bitb  #$03
         beq   L02BD
         ldb   <$34,y
         std   <$1C,x
         stu   <$1E,x
L02BD    ldb   $01,y
         bitb  #$04
         beq   L02CC
         ldb   <$34,y
         std   <$22,x
         stu   <$24,x
L02CC    clrb
         bra   KillPth

 page
***************
* Subroutine Delete

Delete    pshs  y
         lbsr  SchDir
         bcs   KillPth
         ldd   <$35,y
         bne   L02E0
         tst   <$34,y
         beq   L0273
L02E0    lda   #$42
         lbsr  L076B
         bcs   L0354
         ldu   $06,y
         stx   $04,u
         lbsr  GETFD
         bcs   L0354
         ldx   $08,y
         dec   $08,x
         beq   L02FB
         lbsr  PUTFD
         bra   L0321
L02FB    clra
         clrb
         std   $0F,y
         std   <$11,y
         lbsr  L0A16
         bcs   L0354
         ldb   <$34,y
         ldx   <$35,y
         stb   <$16,y
         stx   <$17,y
         ldx   $08,y
         ldd   <$13,x
         addd  #$0001
         std   <$1A,y
         lbsr  L0AD5
L0321    bcs   L0354
         lbsr  L0CD3
         lbsr  L07B1
         lda   <$37,y
         sta   <$34,y
         ldd   <$38,y
         std   <$35,y
         lbsr  L07A5
         lbsr  GETFD
         bcs   L0354
         lbsr  L01BC
         ldd   <$3A,y
         std   $0B,y
         ldd   <$3C,y
         std   $0D,y
         lbsr  L071A
         bcs   L0354
         clr   ,x
         lbsr  L0CA3
L0354    lbra  KillPth

***************
* Subroutine Seek
*   Change Path's current posn ptr
* Flush buffer is (not empty and ptr moves to new sector)

Seek    ldb   $0A,y
         bitb  #$02
         beq   L0370
         lda   $05,u
         ldb   $08,u
         subd  $0C,y
         bne   L036B
         lda   $04,u
         sbca  $0B,y
         beq   L0374
L036B    lbsr  L0CD3
         bcs   L0378
L0370    ldd   $04,u
         std   $0B,y
L0374    ldd   $08,u
         std   $0D,y
L0378    rts
ReadLn    bsr   L03B5
         bsr   L039E
         pshs  u,y,x,b,a
         exg   x,u
         ldy   #$0000
         lda   #$0D
L0387    leay  $01,y
         cmpa  ,x+
         beq   L0390
         decb
         bne   L0387
L0390    ldx   $06,s
         bsr   L03E5
         sty   $0A,s
         puls  u,y,x,b,a
         ldd   $02,s
         leax  d,x
         rts
L039E    bsr   L0401
         lda   ,-x
         cmpa  #$0D
         beq   L03AA
         ldd   $02,s
         bne   L0407
L03AA    ldu   $06,y
         ldd   $06,u
         subd  $02,s
         std   $06,u
         leas  $08,s
         rts
L03B5    ldd   $06,u
         bsr   L03BE
         bcs   L03E2
         std   $06,u
         rts
L03BE    pshs  b,a
         ldd   <$11,y
         subd  $0D,y
         tfr   d,x
         ldd   $0F,y
         sbcb  $0C,y
         sbca  $0B,y
         bcs   L03DF
         bne   L03DC
         tstb
         bne   L03DC
         cmpx  ,s
         bcc   L03DC
         stx   ,s
         beq   L03DF
L03DC    clrb
         puls  pc,b,a
L03DF    comb
         ldb   #$D3
L03E2    leas  $02,s
         rts
L03E5    lbra  L04DB
L03E8    bsr   L03B5
         bsr   L03F9
L03EC    pshs  u,y,x,b,a
         exg   x,u
         tfr   d,y
         bsr   L03E5
         puls  u,y,x,b,a
         leax  d,x
         rts
L03F9    bsr   L0401
         bne   L0407
         clrb
L03FE    leas  $08,s
         rts
L0401    ldd   $04,u
         ldx   $06,u
         pshs  x,b,a
L0407    lda   $0A,y
         bita  #$02
         bne   L042B
         lbsr  L0CD3
         bcs   L03FE
         tst   $0E,y
         bne   L0426
         tst   $02,s
         beq   L0426
         leax  <L048D,pcr
         cmpx  $06,s
         bne   L0426
         lbsr  L0BB6
         bra   L0429
L0426    lbsr  L0B94
L0429    bcs   L03FE
L042B    ldu   $08,y
         clra
         ldb   $0E,y
         leau  d,u
         negb
         sbca  #$FF
         ldx   ,s
         cmpd  $02,s
         bls   L043E
         ldd   $02,s
L043E    pshs  b,a
         jsr   [<$08,s]
         stx   $02,s
         ldb   $01,s
         addb  $0E,y
         stb   $0E,y
         bne   L045A
         lbsr  L0CD3
         inc   $0D,y
         bne   L045A
         inc   $0C,y
         bne   L045A
         inc   $0B,y
L045A    ldd   $04,s
         subd  ,s++
         std   $02,s
         jmp   [<$04,s]
WritLine    pshs  y
         clrb
         ldy   $06,u
         beq   L0481
         ldx   $04,u
L046D    leay  -$01,y
         beq   L0481
         lda   ,x+
         cmpa  #$0D
         bne   L046D
         tfr   y,d
         nega
         negb
         sbca  #$00
         addd  $06,u
         std   $06,u
L0481    puls  y
L0483    ldd   $06,u
         beq   L04A7
         bsr   L04A9
         bcs   L04A8
         bsr   L049E
L048D    pshs  y,b,a
         tfr   d,y
         bsr   L04DB
         puls  y,b,a
         leax  d,x
         lda   $0A,y
         ora   #$03
         sta   $0A,y
         rts
L049E    lbsr  L0401
         lbne  L0407
         leas  $08,s
L04A7    clrb
L04A8    rts
L04A9    addd  $0D,y
         tfr   d,x
         ldd   $0B,y
         adcb  #$00
         adca  #$00
L04B3    cmpd  $0F,y
         bcs   L04A7
         bhi   L04BF
         cmpx  <$11,y
         bls   L04A7
L04BF    pshs  u
         ldu   <$11,y
         stx   <$11,y
         ldx   $0F,y
         std   $0F,y
         pshs  u,x
         lbsr  L07B2
         puls  u,x
         bcc   L04D9
         stx   $0F,y
         stu   <$11,y
L04D9    puls  pc,u
L04DB    pshs  u,y,x
         ldd   $02,s
         beq   L0504
         leay  d,u
         lsrb
         bcc   L04EA
         lda   ,x+
         sta   ,u+
L04EA    lsrb
         bcc   L04F1
         ldd   ,x++
         std   ,u++
L04F1    pshs  y
         exg   x,u
         bra   L04FE
L04F7    pulu  y,b,a
         std   ,x++
         sty   ,x++
L04FE    cmpx  ,s
         bcs   L04F7
         leas  $02,s
L0504    puls  pc,u,y,x
GetStat    ldb   $02,u
         cmpb  #$00
         beq   L052C
         cmpb  #$06
         bne   L0518
         clr   $02,u
         clra
L0513    ldb   #$01
         lbra  L03BE
L0518    cmpb  #$01
         bne   L051F
         clr   $02,u
         rts
L051F    cmpb  #$02
         bne   L052D
         ldd   $0F,y
         std   $04,u
         ldd   <$11,y
         std   $08,u
L052C    rts
L052D    cmpb  #$05
         bne   L053A
         ldd   $0B,y
         std   $04,u
         ldd   $0D,y
         std   $08,u
         rts
L053A    cmpb  #$0F
         bne   L0554
         lbsr  GETFD
         bcs   L052C
         ldu   $06,y
         ldd   $06,u
         tsta
         beq   L054D
         ldd   #$0100
L054D    ldx   $04,u
         ldu   $08,y
         lbra  L03EC
L0554    lda   #$09
         lbra  L0C62

PutStat  ldb   $02,u
         cmpb  #$00
         bne   L056D
         ldx   $04,u
         leax  $02,x
         leau  <$22,y
         ldy   #$000D
         lbra  L04DB
L056D    cmpb  #SS.Size
         bne   L05AD
         ldd   <$35,y
         bne   L057B
         tst   <$34,y
         beq   L05B2
L057B    lda   $01,y
         bita  #$02
         beq   L05A9
         ldd   $04,u
         ldx   $08,u
         cmpd  $0F,y
         bcs   L0594
         bne   L0591
         cmpx  <$11,y
         bcs   L0594
L0591    lbra  L04B3
L0594    std   $0F,y
         stx   <$11,y
         ldd   $0B,y
         ldx   $0D,y
         pshs  x,b,a
         lbsr  L0A16
         puls  u,x
         stx   $0B,y
         stu   $0D,y
         rts
L05A9    comb
         ldb   #$CB
         rts

L05AD    lda   #$0C
         lbra  L0C62

L05B2    comb
         ldb   #$D0
L05B5    rts
SchDir    ldd   #$0100
         stb   $0A,y
         os9   F$SRqMem
         bcs   L05B5
         stu   $08,y
         ldx   $06,y
         ldx   $04,x
         pshs  u,y,x
         leas  -$04,s
         clra
         clrb
         sta   <$34,y
         std   <$35,y
         std   <$1C,y
         lda   ,x
         sta   ,s
         cmpa  #$2F
         bne   L05ED
         lbsr  L073A
         sta   ,s
         lbcs  L06D0
         leax  ,y
         ldy   $06,s
         bra   L0610
L05ED    anda  #$7F
         cmpa  #$40
         beq   L0610
         lda   #$2F
         sta   ,s
         leax  -$01,x
         lda   $01,y
         ldu   D.Proc
         leau  <$1A,u
         bita  #$24
         beq   L0606
         leau  $06,u
L0606    ldb   $03,u
         stb   <$34,y
         ldd   $04,u
         std   <$35,y
L0610    ldu   $03,y
         stu   <$3E,y
         lda   <$21,y
         ldb   >L0011,pcr
         mul
         addd  $02,u
         addd  #$000F
         std   <$1E,y
         lda   ,s
         anda  #$7F
         cmpa  #$40
         bne   L0631
         leax  $01,x
         bra   L0653
L0631    lbsr  L0C2E
         lbcs  L06D8
         ldu   $08,y
         ldd   $0E,u
         std   <$1C,y
         ldd   <$35,y
         bne   L0653
         lda   <$34,y
         bne   L0653
         lda   $08,u
         sta   <$34,y
         ldd   $09,u
         std   <$35,y
L0653    stx   $04,s
         stx   $08,s
L0657    lbsr  L0CD3
         lbsr  L07A5
         bcs   L06D8
         lda   ,s
         cmpa  #$2F
         bne   L06BA
         clr   $02,s
         clr   $03,s
         lda   $01,y
         ora   #$80
         lbsr  L076B
         bcs   L06D0
         lbsr  L01BC
         ldx   $08,s
         leax  $01,x
         lbsr  L073A
         std   ,s
         stx   $04,s
         sty   $08,s
         ldy   $06,s
         bcs   L06D0
         lbsr  L071A
         bra   L0691
L068D    bsr   L06DB
L068F    bsr   L0705
L0691    bcs   L06D0
         tst   ,x
         beq   L068D
         leay  ,x
         ldx   $04,s
         ldb   $01,s
         clra
         os9   F$CmpNam
         ldx   $06,s
         exg   x,y
         bcs   L068F
         bsr   L06E9
         lda   <$1D,x
         sta   <$34,y
         ldd   <$1E,x
         std   <$35,y
         lbsr  L07B1
         bra   L0657
L06BA    ldx   $08,s
         tsta
         bmi   L06C7
         os9   F$PrsNam
         leax  ,y
         ldy   $06,s
L06C7    stx   $04,s
         clra
L06CA    lda   ,s
         leas  $04,s
         puls  pc,u,y,x
L06D0    cmpb  #$D3
         bne   L06D8
         bsr   L06DB
         ldb   #$D8
L06D8    coma
         bra   L06CA
L06DB    pshs  b,a
         lda   $04,s
         cmpa  #$2F
         beq   L0703
         ldd   $06,s
         bne   L0703
         puls  b,a
L06E9    pshs  b,a
         stx   $06,s
         lda   <$34,y
         sta   <$37,y
         ldd   <$35,y
         std   <$38,y
         ldd   $0B,y
         std   <$3A,y
         ldd   $0D,y
         std   <$3C,y
L0703    puls  pc,b,a
L0705    ldb   $0E,y
         addb  #$20
         stb   $0E,y
         bcc   L071A
         lbsr  L0CD3
         inc   $0D,y
         bne   L071A
         inc   $0C,y
         bne   L071A
         inc   $0B,y
L071A    ldd   #$0020
         lbsr  L03BE
         bcs   L0739
         lda   $0A,y
         bita  #$02
         bne   L0732
         lbsr  L0BB6
         bcs   L0739
         lbsr  L0B94
         bcs   L0739
L0732    ldb   $0E,y
         lda   $08,y
         tfr   d,x
         clrb
L0739    rts
L073A    os9   F$PrsNam
         pshs  x
         bcc   L0769
         clrb
L0742    pshs  a
         anda  #$7F
         cmpa  #$2E
         puls  a
         bne   L075D
         incb
         leax  $01,x
         tsta
         bmi   L075D
         lda   ,x
         cmpb  #$03
         bcs   L0742
         lda   #$2F
         decb
         leax  -$03,x
L075D    tstb
         bne   L0765
         comb
         ldb   #$D7
         puls  pc,x
L0765    leay  ,x
         andcc #$FE
L0769    puls  pc,x
L076B    tfr   a,b
         anda  #$07
         andb  #$C0
         pshs  x,b,a
         lbsr  GETFD
         bcs   L079A
         ldu   $08,y
         ldx   D.Proc
         ldd   $09,x
         beq   L0783
         cmpd  $01,u
L0783    puls  a
         beq   L078A
         lsla
         lsla
         lsla
L078A    ora   ,s
         anda  #$BF
         pshs  a
         ora   #$80
         anda  ,u
         cmpa  ,s
         beq   L07A3
         ldb   #$D6
L079A    leas  $02,s
         coma
         puls  pc,x
         ldb   #$FD
         bra   L079A
L07A3    puls  pc,x,b,a
L07A5    clra
         clrb
         std   $0B,y
         std   $0D,y
         sta   <$19,y
         std   <$1A,y
L07B1    rts
L07B2    pshs  u,x
L07B4    bsr   L0810
         bne   L07C4
         cmpx  <$1A,y
         bcs   L080B
         bne   L07C4
         lda   <$12,y
         beq   L080B
L07C4    lbsr  GETFD
         bcs   L0808
         ldx   $0B,y
         ldu   $0D,y
         pshs  u,x
         ldd   $0F,y
         std   $0B,y
         ldd   <$11,y
         std   $0D,y
         lbsr  L0BD0
         puls  u,x
         stx   $0B,y
         stu   $0D,y
         bcc   L080B
         cmpb  #$D5
         bne   L0808
         bsr   L0810
         bne   L07F4
         tst   <$12,y
         beq   L07F7
         leax  $01,x
         bne   L07F7
L07F4    ldx   #$FFFF
L07F7    tfr   x,d
         tsta
         bne   L0804
         cmpb  <$2E,y
         bcc   L0804
         ldb   <$2E,y
L0804    bsr   L081E
         bcc   L07B4
L0808    coma
         puls  pc,u,x
L080B    lbsr  L0BB6
         puls  pc,u,x
L0810    ldd   <$10,y
         subd  <$14,y
         tfr   d,x
         ldb   $0F,y
         sbcb  <$13,y
         rts
L081E    pshs  u,x
         lbsr  L08C1
         bcs   L085A
         lbsr  GETFD
         bcs   L085A
         ldu   $08,y
         clra
         clrb
         std   $09,u
         std   $0B,u
         leax  <$10,u
         ldd   $03,x
         beq   L08A2
         ldd   $08,y
         inca
         pshs  b,a
         bra   L084D
L0840    clrb
         ldd   -$02,x
         beq   L0856
         addd  $0A,u
         std   $0A,u
         bcc   L084D
         inc   $09,u
L084D    leax  $05,x
         cmpx  ,s
         bcs   L0840
         comb
         ldb   #$D9
L0856    leas  $02,s
         leax  -$05,x
L085A    bcs   L08BF
         ldd   -$04,x
         addd  -$02,x
         pshs  b,a
         ldb   -$05,x
         adcb  #$00
         cmpb  <$16,y
         puls  b,a
         bne   L08A2
         cmpd  <$17,y
         bne   L08A2
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
         bne   L08A2
         ldd   -$02,x
         addd  <$1A,y
         bcs   L08A2
         std   -$02,x
         bra   L08B1
L08A2    ldd   <$16,y
         std   ,x
         lda   <$18,y
         sta   $02,x
         ldd   <$1A,y
         std   $03,x
L08B1    ldd   $0A,u
         addd  <$1A,y
         std   $0A,u
         bcc   L08BC
         inc   $09,u
L08BC    lbsr  PUTFD
L08BF    puls  pc,u,x
L08C1    pshs  u,y,x,b,a
         ldb   #$0D
L08C5    clr   ,-s
         decb
         bne   L08C5
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
         bra   L08E9
L08E7    lsra
         rorb
L08E9    lsr   $0B,s
         ror   $0C,s
         bcc   L08E7
         std   $01,s
         ldd   $03,s
         std   $0B,s
         subd  #$0001
         addd  $0D,s
         bcc   L0903
         ldd   #$FFFF
         bra   L0903
L0901    lsra
         rorb
L0903    lsr   $0B,s
         ror   $0C,s
         bcc   L0901
         cmpa  #$08
         bcs   L0910
         ldd   #$0800
L0910    std   $0D,s
         lbsr  L0B47
         lbcs  L0A0A
         ldx   <$1E,y
         ldd   <$1A,x
         cmpd  $0E,x
         bne   L0942
         lda   <$1C,x
         cmpa  $04,x
         bne   L0942
         ldd   $0D,s
         cmpd  $01,s
         bcs   L094F
         lda   <$1D,x
         cmpa  $04,x
         bcc   L0942
         sta   $07,s
         nega
         adda  $05,s
         sta   $05,s
         bra   L094F
L0942    ldd   $0E,x
         std   <$1A,x
         lda   $04,x
         sta   <$1C,x
         clr   <$1D,x
L094F    inc   $07,s
         ldb   $07,s
         lbsr  L0B8D
         lbcs  L0A0A
         ldd   $05,s
         tsta
         beq   L0962
         ldd   #$0100
L0962    ldx   $08,y
         leau  d,x
         ldy   $0D,s
         clra
         clrb
         os9   F$SchBit
         pshs  b,a,cc
         tst   $03,s
         bne   L097D
         cmpy  $04,s
         bcs   L097D
         lda   $0A,s
         sta   $03,s
L097D    puls  b,a,cc
         bcc   L09B0
         cmpy  $09,s
         bls   L098F
         sty   $09,s
         std   $0B,s
         lda   $07,s
         sta   $08,s
L098F    ldy   <$11,s
         tst   $05,s
         beq   L099B
         dec   $05,s
         bra   L094F
L099B    ldb   $08,s
         beq   L0A08
         clra
         cmpb  $07,s
         beq   L09A9
         stb   $07,s
         lbsr  L0B8D
L09A9    ldx   $08,y
         ldd   $0B,s
         ldy   $09,s
L09B0    std   $0B,s
         sty   $09,s
         os9   F$AllBit
         ldy   <$11,s
         ldb   $07,s
         lbsr  L0B75
         bcs   L0A0A
         lda   ,s
         beq   L09CE
         ldx   <$1E,y
         deca
         sta   <$1D,x
L09CE    lda   $07,s
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
         bra   L09FE
L09EF    lsl   <$18,y
         rol   <$17,y
         rol   <$16,y
         lsl   <$1B,y
         rol   <$1A,y
L09FE    lsra
         rorb
         bcc   L09EF
         clrb
         ldd   <$1A,y
         bra   L0A12
L0A08    ldb   #$F8
L0A0A    ldy   <$11,s
         lbsr  L0B7C
         coma
L0A12    leas  $0F,s
         puls  pc,u,y,x
L0A16    clra
         lda   $01,y
         bita  #$80
         bne   L0A78
         ldd   $0F,y
         std   $0B,y
         ldd   <$11,y
         std   $0D,y
         lbsr  L0BD0
         bcc   L0A2F
         cmpb  #$D5
         bra   L0A70
L0A2F    ldd   <$14,y
         subd  $0C,y
         addd  <$1A,y
         tst   $0E,y
         beq   L0A3E
         subd  #$0001
L0A3E    pshs  b,a
         ldu   <$1E,y
         ldd   $06,u
         subd  #$0001
         coma
         comb
         anda  ,s+
         andb  ,s+
         ldu   <$1A,y
         std   <$1A,y
         beq   L0A72
         tfr   u,d
         subd  <$1A,y
         pshs  x,b,a
         addd  <$17,y
         std   <$17,y
         bcc   L0A68
         inc   <$16,y
L0A68    bsr   L0AD5
         bcc   L0A79
         leas  $04,s
         cmpb  #$DB
L0A70    bne   L0A77
L0A72    lbsr  GETFD
         bcc   L0A82
L0A77    coma
L0A78    rts
L0A79    lbsr  GETFD
         bcs   L0AD2
         puls  x,b,a
         std   $03,x
L0A82    ldu   $08,y
         ldd   <$11,y
         std   $0B,u
         ldd   $0F,y
         std   $09,u
         tfr   x,d
         clrb
         inca
         leax  $05,x
         pshs  x,b,a
         bra   L0ABD
L0A97    ldd   -$02,x
         beq   L0ACA
         std   <$1A,y
         ldd   -$05,x
         std   <$16,y
         lda   -$03,x
         sta   <$18,y
         bsr   L0AD5
         bcs   L0AD2
         stx   $02,s
         lbsr  GETFD
         bcs   L0AD2
         ldx   $02,s
         clra
         clrb
         std   -$05,x
         sta   -$03,x
         std   -$02,x
L0ABD    lbsr  PUTFD
         bcs   L0AD2
         ldx   $02,s
         leax  $05,x
         cmpx  ,s
         bcs   L0A97
L0ACA    clra
         clrb
         sta   <$19,y
         std   <$1A,y
L0AD2    leas  $04,s
         rts
L0AD5    pshs  u,y,x,a
         ldx   <$1E,y
         ldd   $06,x
         subd  #$0001
         addd  <$17,y
         std   <$17,y
         ldd   $06,x
         bcc   L0AFD
         inc   <$16,y
         bra   L0AFD
L0AEE    lsr   <$16,y
         ror   <$17,y
         ror   <$18,y
         lsr   <$1A,y
         ror   <$1B,y
L0AFD    lsra
         rorb
         bcc   L0AEE
         clrb
         ldd   <$1A,y
         beq   L0B45
         ldd   <$16,y
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         tfr   b,a
         ldb   #$DB
         cmpa  $04,x
         bhi   L0B44
         cmpa  <$1D,x
         bcc   L0B20
         sta   <$1D,x
L0B20    inca
         sta   ,s
L0B23    bsr   L0B47
         bcs   L0B23
         ldb   ,s
         bsr   L0B8D
         bcs   L0B44
         ldx   $08,y
         ldd   <$17,y
         anda  #$07
         ldy   <$1A,y
         os9   F$DelBit
         ldy   $03,s
         ldb   ,s
         bsr   L0B75
         bcc   L0B45
L0B44    coma
L0B45    puls  pc,u,y,x,a
L0B47    lbsr  L0CD3
         bra   L0B51
L0B4C    os9   F$IOQu
         bsr   L0B61
L0B51    bcs   L0B60
         ldx   <$1E,y
         lda   <$17,x
         bne   L0B4C
         lda   $05,y
         sta   <$17,x
L0B60    rts
L0B61    ldu   D.Proc
         ldb   <$36,u
         beq   L0B6C
         cmpb  #$03
         bls   L0B73
L0B6C    clra
         lda   $0D,u
         bita  #$02
         beq   L0B74
L0B73    coma
L0B74    rts
L0B75    clra
         tfr   d,x
         clrb
         lbsr  L0CA5
L0B7C    pshs  cc
         ldx   <$1E,y
         lda   $05,y
         cmpa  <$17,x
         bne   L0B8B
         clr   <$17,x
L0B8B    puls  pc,cc
L0B8D    clra
         tfr   d,x
         clrb
         lbra  L0C60
L0B94    pshs  u,x
         bsr   L0BB6
         bcs   L0BA5
         lbsr  L0C5A
         bcs   L0BA5
         lda   $0A,y
         ora   #$02
         sta   $0A,y
L0BA5    puls  pc,u,x
         pshs  u,x
         lbsr  L0CA3
         bcs   L0BB4
         lda   $0A,y
         anda  #$FE
         sta   $0A,y
L0BB4    puls  pc,u,x
L0BB6    ldd   $0C,y
         subd  <$14,y
         tfr   d,x
         ldb   $0B,y
         sbcb  <$13,y
         cmpb  <$19,y
         bcs   L0BCE
         bhi   L0BD0
         cmpx  <$1A,y
         bcc   L0BD0
L0BCE    clrb
         rts
L0BD0    pshs  u
         bsr   GETFD
         bcs   L0C2A
         clra
         clrb
         std   <$13,y
         stb   <$15,y
         ldu   $08,y
         leax  <$10,u
         lda   $08,y
         ldb   #$FC
         pshs  b,a
L0BE9    ldd   $03,x
         beq   L0C0E
         addd  <$14,y
         tfr   d,u
         ldb   <$13,y
         adcb  #$00
         cmpb  $0B,y
         bhi   L0C1B
         bne   L0C02
         cmpu  $0C,y
         bhi   L0C1B
L0C02    stb   <$13,y
         stu   <$14,y
         leax  $05,x
         cmpx  ,s
         bcs   L0BE9
L0C0E    clra
         clrb
         sta   <$19,y
         std   <$1A,y
         comb
         ldb   #$D5
         bra   L0C2A
L0C1B    ldd   ,x
         std   <$16,y
         lda   $02,x
         sta   <$18,y
         ldd   $03,x
         std   <$1A,y
L0C2A    leas  $02,s
         puls  pc,u
L0C2E    pshs  x,b
         lbsr  L0CD3
         bcs   L0C3D
         clrb
         ldx   #$0000
         bsr   L0C60
         bcc   L0C3F
L0C3D    stb   ,s
L0C3F    puls  pc,x,b
GETFD    ldb   $0A,y
         bitb  #$04
         bne   L0BCE
         lbsr  L0CD3
         bcs   L0CBB
         ldb   $0A,y
         orb   #$04
         stb   $0A,y
         ldb   <$34,y
         ldx   <$35,y
         bra   L0C60
L0C5A    bsr   L0CD3
         bcs   L0CBB
         bsr   L0CBC
L0C60    lda   #$03
L0C62    pshs  u,y,x,b,a
         ldu   $03,y
         ldu   $02,u
         bra   L0C6D
L0C6A    os9   F$IOQu
L0C6D    lda   $04,u
         bne   L0C6A
         lda   $05,y
         sta   $04,u
         ldd   ,s
         ldx   $02,s
         pshs  u
         bsr   L0C89
         puls  u
         lda   #$00
         sta   $04,u
         bcc   L0C87
         stb   $01,s
L0C87    puls  pc,u,y,x,b,a
L0C89    pshs  pc,x,b,a
         ldx   $03,y
         ldd   ,x
         ldx   ,x
         addd  $09,x
         addb  ,s
         adca  #$00
         std   $04,s
         puls  pc,x,b,a
PUTFD    ldb   <$34,y
         ldx   <$35,y
         bra   L0CA5
L0CA3    bsr   L0CBC
L0CA5    lda   #$06
         pshs  x,b,a
         ldd   <$1C,y
         beq   L0CB4
         ldx   <$1E,y
         cmpd  $0E,x
L0CB4    puls  x,b,a
         beq   L0C62
         comb
         ldb   #$FB
L0CBB    rts
L0CBC    ldd   $0C,y
         subd  <$14,y
         tfr   d,x
         ldb   $0B,y
         sbcb  <$13,y
         exg   d,x
         addd  <$17,y
         exg   d,x
         adcb  <$16,y
         rts
L0CD3    clrb
         pshs  u,x
         ldb   $0A,y
         andb  #$06
         beq   L0CF0
         tfr   b,a
         eorb  $0A,y
         stb   $0A,y
         andb  #$01
         beq   L0CF0
         eorb  $0A,y
         stb   $0A,y
         bita  #$02
         beq   L0CF0
         bsr   L0CA3
L0CF0    puls  pc,u,x
         emod
eom      equ   *
