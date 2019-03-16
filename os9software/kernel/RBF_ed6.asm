***********************************
* Original version from GMX distribution

* Header for:  RBF
* Module size: $0CF2    #3314
* Module CRC:  $C06CB6 (Good)
* Hdr parity:  $16
* Edition:     $06      #6
* Ty/La At/Rv: $D1 $81
* File Man mod, 6809 obj, re-en, R/O

         nam   RBF
         ttl   Disk file manager

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
         fcs   /RBF/
         fcb   $06
L0011    fcb   DRVMEM

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
Create    pshs  y
         leas  -$05,s
         lda   $02,u
         anda  #$7F
         sta   $02,u
         lbsr  L05B8
         bcs   CREATE10
         ldb   #$DA
CREATE10    cmpb  #$D8
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
         lbsr  L08C3
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
         lbsr  L071C
         bcs   L00A7
L009E    tst   ,x
         beq   L00BC
         lbsr  L0707
         bcc   L009E
L00A7    cmpb  #$D3
         bne   L0070
         ldd   #$0020
         lbsr  L04AB
         bcs   L0070
         lbsr  L0237
         lbsr  L0CD0
         lbsr  L071C
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
         lbsr  L04DD
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
         lbsr  L0CA0
         bcs   L0144
         ldu   $08,y
         bsr   L0163
         lda   #$04
         sta   $0A,y
         ldx   $06,y
         lda   $02,x
         sta   ,u
         ldx   D.Proc
         ldd   $09,x
         std   $01,u
         lbsr  L0286
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
         lbsr  L0CA2
         bcs   L0144
         lbsr  L07B3
         stb   <$34,y
         stx   <$35,y
         lbsr  L07A7
         leas  $05,s
         bra   L01BA
L0144    puls  u,x,a
         sta   <$16,y
         stx   <$17,y
         clr   <$19,y
         stu   <$1A,y
         pshs  b
         lbsr  L0AD2
         puls  b
L0159    lbra  L0275
L015C    pshs  u,x,b,a
         leau  <$20,u
         bra   L0169
L0163    pshs  u,x,b,a
         leau  >$0100,u
L0169    clra
         clrb
         tfr   d,x
L016D    pshu  x,b,a
         cmpu  $04,s
         bhi   L016D
         puls  pc,u,x,b,a
Open    pshs  y
         lbsr  L05B8
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
         lbsr  L076D
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
MakDir    lbsr  Create
         bcs   L0235
         ldd   #$0040
         std   <$11,y
         bsr   L0247
         bcs   L0235
         lbsr  L07B4
         bcs   L0235
         ldu   $08,y
         lda   ,u
         anda  #$BF
         ora   #$80
         sta   ,u
         bsr   L0237
         bcs   L0235
         lbsr  L0163
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
         lbsr  L0CA0
L0235    bra   L0278
L0237    lbsr  L0C3E
L023A    ldx   $08,y
         ldd   $0F,y
         std   $09,x
         ldd   <$11,y
         std   $0B,x
         clr   $0A,y
L0247    lbra  L0C98
Close    clra
         tst   $02,y
         bne   L0272
         ldb   $01,y
         bitb  #$02
         beq   L0278
         lbsr  L0CD0
         bcs   L0278
         ldd   <$34,y
         bne   L0264
         lda   <$36,y
         beq   L0278
L0264    bsr   L0286
         bsr   L023A
         lbsr  L0515
         bcc   L0278
         lbsr  L0A13
         bra   L0278
L0272    rts
L0273    ldb   #$D6
L0275    coma
L0276    puls  y
L0278    pshs  b,cc
         ldu   $08,y
         beq   L0284
         ldd   #$0100
         os9   F$SRtMem
L0284    puls  pc,b,cc
L0286    lbsr  L0C3E
         ldu   $08,y
         lda   $08,u
         pshs  a
         leax  $03,u
         os9   F$Time
         puls  a
         sta   $08,u
         rts
ChgDir    pshs  y
         lda   $01,y
         ora   #$80
         sta   $01,y
         lbsr  Open
         bcs   L0276
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
         bra   L0276
Delete    pshs  y
         lbsr  L05B8
         bcs   L0276
         ldd   <$35,y
         bne   L02E2
         tst   <$34,y
         lbeq  L0273
L02E2    lda   #$42
         lbsr  L076D
         bcs   L0356
         ldu   $06,y
         stx   $04,u
         lbsr  L0C3E
         bcs   L0356
         ldx   $08,y
         dec   $08,x
         beq   L02FD
         lbsr  L0C98
         bra   L0323
L02FD    clra
         clrb
         std   $0F,y
         std   <$11,y
         lbsr  L0A13
         bcs   L0356
         ldb   <$34,y
         ldx   <$35,y
         stb   <$16,y
         stx   <$17,y
         ldx   $08,y
         ldd   <$13,x
         addd  #$0001
         std   <$1A,y
         lbsr  L0AD2
L0323    bcs   L0356
         lbsr  L0CD0
         lbsr  L07B3
         lda   <$37,y
         sta   <$34,y
         ldd   <$38,y
         std   <$35,y
         lbsr  L07A7
         lbsr  L0C3E
         bcs   L0356
         lbsr  L01BC
         ldd   <$3A,y
         std   $0B,y
         ldd   <$3C,y
         std   $0D,y
         lbsr  L071C
         bcs   L0356
         clr   ,x
         lbsr  L0CA0
L0356    lbra  L0276
Seek    ldb   $0A,y
         bitb  #$02
         beq   L0372
         lda   $05,u
         ldb   $08,u
         subd  $0C,y
         bne   L036D
         lda   $04,u
         sbca  $0B,y
         beq   L0376
L036D    lbsr  L0CD0
         bcs   L037A
L0372    ldd   $04,u
         std   $0B,y
L0376    ldd   $08,u
         std   $0D,y
L037A    rts
ReadLn    bsr   L03B7
         bsr   L03A0
         pshs  u,y,x,b,a
         exg   x,u
         ldy   #$0000
         lda   #$0D
L0389    leay  $01,y
         cmpa  ,x+
         beq   L0392
         decb
         bne   L0389
L0392    ldx   $06,s
         bsr   L03E7
         sty   $0A,s
         puls  u,y,x,b,a
         ldd   $02,s
         leax  d,x
         rts
L03A0    bsr   L0403
         lda   ,-x
         cmpa  #$0D
         beq   L03AC
         ldd   $02,s
         bne   L0409
L03AC    ldu   $06,y
         ldd   $06,u
         subd  $02,s
         std   $06,u
         leas  $08,s
         rts
L03B7    ldd   $06,u
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
         ldb   #$D3
L03E4    leas  $02,s
         rts
L03E7    lbra  L04DD
Read    bsr   L03B7
         bsr   L03FB
L03EE    pshs  u,y,x,b,a
         exg   x,u
         tfr   d,y
         bsr   L03E7
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
         lbsr  L0CD0
         bcs   L0400
         tst   $0E,y
         bne   L0428
         tst   $02,s
         beq   L0428
         leax  <L048F,pcr
         cmpx  $06,s
         bne   L0428
         lbsr  L0BB3
         bra   L042B
L0428    lbsr  L0B91
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
         lbsr  L0CD0
         inc   $0D,y
         bne   L045C
         inc   $0C,y
         bne   L045C
         inc   $0B,y
L045C    ldd   $04,s
         subd  ,s++
         std   $02,s
         jmp   [<$04,s]
WriteLn    pshs  y
         clrb
         ldy   $06,u
         beq   L0483
         ldx   $04,u
L046F    leay  -$01,y
         beq   L0483
         lda   ,x+
         cmpa  #$0D
         bne   L046F
         tfr   y,d
         nega
         negb
         sbca  #$00
         addd  $06,u
         std   $06,u
L0483    puls  y
Write    ldd   $06,u
         beq   L04A9
         bsr   L04AB
         bcs   L04AA
         bsr   L04A0
L048F    pshs  y,b,a
         tfr   d,y
         bsr   L04DD
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
L04DD    pshs  u,y,x
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
GetStat    ldb   $02,u
         cmpb  #$00
         beq   L052E
         cmpb  #$06
         bne   L051A
         clr   $02,u
         clra
L0515    ldb   #$01
         lbra  L03C0
L051A    cmpb  #$01
         bne   L0521
         clr   $02,u
         rts
L0521    cmpb  #$02
         bne   L052F
         ldd   $0F,y
         std   $04,u
         ldd   <$11,y
         std   $08,u
L052E    rts
L052F    cmpb  #$05
         bne   L053C
         ldd   $0B,y
         std   $04,u
         ldd   $0D,y
         std   $08,u
         rts
L053C    cmpb  #$0F
         bne   L0556
         lbsr  L0C3E
         bcs   L052E
         ldu   $06,y
         ldd   $06,u
         tsta
         beq   L054F
         ldd   #$0100
L054F    ldx   $04,u
         ldu   $08,y
         lbra  L03EE
L0556    lda   #$09
         lbra  L0C5F
PutStat    ldb   $02,u
         cmpb  #$00
         bne   L056F
         ldx   $04,u
         leax  $02,x
         leau  <$22,y
         ldy   #$000D
         lbra  L04DD
L056F    cmpb  #$02
         bne   L05AF
         ldd   <$35,y
         bne   L057D
         tst   <$34,y
         beq   L05B4
L057D    lda   $01,y
         bita  #$02
         beq   L05AB
         ldd   $04,u
         ldx   $08,u
         cmpd  $0F,y
         bcs   L0596
         bne   L0593
         cmpx  <$11,y
         bcs   L0596
L0593    lbra  L04B5
L0596    std   $0F,y
         stx   <$11,y
         ldd   $0B,y
         ldx   $0D,y
         pshs  x,b,a
         lbsr  L0A13
         puls  u,x
         stx   $0B,y
         stu   $0D,y
         rts
L05AB    comb
         ldb   #$CB
         rts
L05AF    lda   #$0C
         lbra  L0C5F
L05B4    comb
         ldb   #$D0
L05B7    rts
L05B8    ldd   #$0100
         stb   $0A,y
         os9   F$SRqMem
         bcs   L05B7
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
         bne   L05EF
         lbsr  L073C
         sta   ,s
         lbcs  L06D2
         leax  ,y
         ldy   $06,s
         bra   L0612
L05EF    anda  #$7F
         cmpa  #$40
         beq   L0612
         lda   #$2F
         sta   ,s
         leax  -$01,x
         lda   $01,y
         ldu   D.Proc
         leau  <$1A,u
         bita  #$24
         beq   L0608
         leau  $06,u
L0608    ldb   $03,u
         stb   <$34,y
         ldd   $04,u
         std   <$35,y
L0612    ldu   $03,y
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
         bne   L0633
         leax  $01,x
         bra   L0655
L0633    lbsr  L0C2B
         lbcs  L06DA
         ldu   $08,y
         ldd   $0E,u
         std   <$1C,y
         ldd   <$35,y
         bne   L0655
         lda   <$34,y
         bne   L0655
         lda   $08,u
         sta   <$34,y
         ldd   $09,u
         std   <$35,y
L0655    stx   $04,s
         stx   $08,s
L0659    lbsr  L0CD0
         lbsr  L07A7
         bcs   L06DA
         lda   ,s
         cmpa  #$2F
         bne   L06BC
         clr   $02,s
         clr   $03,s
         lda   $01,y
         ora   #$80
         lbsr  L076D
         bcs   L06D2
         lbsr  L01BC
         ldx   $08,s
         leax  $01,x
         lbsr  L073C
         std   ,s
         stx   $04,s
         sty   $08,s
         ldy   $06,s
         bcs   L06D2
         lbsr  L071C
         bra   L0693
L068F    bsr   L06DD
L0691    bsr   L0707
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
         sta   <$34,y
         ldd   <$1E,x
         std   <$35,y
         lbsr  L07B3
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
         bsr   L06DD
         ldb   #$D8
L06DA    coma
         bra   L06CC
L06DD    pshs  b,a
         lda   $04,s
         cmpa  #$2F
         beq   L0705
         ldd   $06,s
         bne   L0705
         puls  b,a
L06EB    pshs  b,a
         stx   $06,s
         lda   <$34,y
         sta   <$37,y
         ldd   <$35,y
         std   <$38,y
         ldd   $0B,y
         std   <$3A,y
         ldd   $0D,y
         std   <$3C,y
L0705    puls  pc,b,a
L0707    ldb   $0E,y
         addb  #$20
         stb   $0E,y
         bcc   L071C
         lbsr  L0CD0
         inc   $0D,y
         bne   L071C
         inc   $0C,y
         bne   L071C
         inc   $0B,y
L071C    ldd   #$0020
         lbsr  L03C0
         bcs   L073B
         lda   $0A,y
         bita  #$02
         bne   L0734
         lbsr  L0BB3
         bcs   L073B
         lbsr  L0B91
         bcs   L073B
L0734    ldb   $0E,y
         lda   $08,y
         tfr   d,x
         clrb
L073B    rts
L073C    os9   F$PrsNam
         pshs  x
         bcc   L076B
         clrb
L0744    pshs  a
         anda  #$7F
         cmpa  #$2E
         puls  a
         bne   L075F
         incb
         leax  $01,x
         tsta
         bmi   L075F
         lda   ,x
         cmpb  #$03
         bcs   L0744
         lda   #$2F
         decb
         leax  -$03,x
L075F    tstb
         bne   L0767
         comb
         ldb   #$D7
         puls  pc,x
L0767    leay  ,x
         andcc #$FE
L076B    puls  pc,x
L076D    tfr   a,b
         anda  #$07
         andb  #$C0
         pshs  x,b,a
         lbsr  L0C3E
         bcs   L079C
         ldu   $08,y
         ldx   D.Proc
         ldd   $09,x
         beq   L0785
         cmpd  $01,u
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
         ldb   #$D6
L079C    leas  $02,s
         coma
         puls  pc,x
         ldb   #$FD
         bra   L079C
L07A5    puls  pc,x,b,a
L07A7    clra
         clrb
         std   $0B,y
         std   $0D,y
         sta   <$19,y
         std   <$1A,y
L07B3    rts
L07B4    pshs  u,x
L07B6    bsr   L0812
         bne   L07C6
         cmpx  <$1A,y
         bcs   L080D
         bne   L07C6
         lda   <$12,y
         beq   L080D
L07C6    lbsr  L0C3E
         bcs   L080A
         ldx   $0B,y
         ldu   $0D,y
         pshs  u,x
         ldd   $0F,y
         std   $0B,y
         ldd   <$11,y
         std   $0D,y
         lbsr  L0BCD
         puls  u,x
         stx   $0B,y
         stu   $0D,y
         bcc   L080D
         cmpb  #$D5
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
L080D    lbsr  L0BB3
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
         lbsr  L0C3E
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
         ldb   #$D9
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
L08BE    lbsr  L0C98
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
         lbsr  L0B44
         lbcs  L0A07
         ldx   <$1E,y
         ldd   <$1A,x
         cmpd  $0E,x
         bne   L093F
         lda   <$1C,x
         cmpa  $04,x
         bne   L093F
         ldd   $0D,s
         cmpd  $01,s
         bcs   L094C
         lda   <$1D,x
         cmpa  $04,x
         bhi   L093F
         sta   $07,s
         bra   L094C
L093F    ldd   $0E,x
         std   <$1A,x
         lda   $04,x
         sta   <$1C,x
         clr   <$1D,x
L094C    inc   $07,s
         ldb   $07,s
         lbsr  L0B8A
         lbcs  L0A07
         ldd   $05,s
         tsta
         beq   L095F
         ldd   #$0100
L095F    ldx   $08,y
         leau  d,x
         ldy   $0D,s
         clra
         clrb
         os9   F$SchBit
         pshs  b,a,cc
         tst   $03,s
         bne   L097A
         cmpy  $04,s
         bcs   L097A
         lda   $0A,s
         sta   $03,s
L097A    puls  b,a,cc
         bcc   L09AD
         cmpy  $09,s
         bls   L098C
         sty   $09,s
         std   $0B,s
         lda   $07,s
         sta   $08,s
L098C    ldy   <$11,s
         tst   $05,s
         beq   L0998
         dec   $05,s
         bra   L094C
L0998    ldb   $08,s
         beq   L0A05
         clra
         cmpb  $07,s
         beq   L09A6
         stb   $07,s
         lbsr  L0B8A
L09A6    ldx   $08,y
         ldd   $0B,s
         ldy   $09,s
L09AD    std   $0B,s
         sty   $09,s
         os9   F$AllBit
         ldy   <$11,s
         ldb   $07,s
         lbsr  L0B72
         bcs   L0A07
         lda   ,s
         beq   L09CB
         ldx   <$1E,y
         deca
         sta   <$1D,x
L09CB    lda   $07,s
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
         bra   L09FB
L09EC    lsl   <$18,y
         rol   <$17,y
         rol   <$16,y
         lsl   <$1B,y
         rol   <$1A,y
L09FB    lsra
         rorb
         bcc   L09EC
         clrb
         ldd   <$1A,y
         bra   L0A0F
L0A05    ldb   #$F8
L0A07    ldy   <$11,s
         lbsr  L0B79
         coma
L0A0F    leas  $0F,s
         puls  pc,u,y,x
L0A13    clra
         lda   $01,y
         bita  #$80
         bne   L0A75
         ldd   $0F,y
         std   $0B,y
         ldd   <$11,y
         std   $0D,y
         lbsr  L0BCD
         bcc   L0A2C
         cmpb  #$D5
         bra   L0A6D
L0A2C    ldd   <$14,y
         subd  $0C,y
         addd  <$1A,y
         tst   $0E,y
         beq   L0A3B
         subd  #$0001
L0A3B    pshs  b,a
         ldu   <$1E,y
         ldd   $06,u
         subd  #$0001
         coma
         comb
         anda  ,s+
         andb  ,s+
         ldu   <$1A,y
         std   <$1A,y
         beq   L0A6F
         tfr   u,d
         subd  <$1A,y
         pshs  x,b,a
         addd  <$17,y
         std   <$17,y
         bcc   L0A65
         inc   <$16,y
L0A65    bsr   L0AD2
         bcc   L0A76
         leas  $04,s
         cmpb  #$DB
L0A6D    bne   L0A74
L0A6F    lbsr  L0C3E
         bcc   L0A7F
L0A74    coma
L0A75    rts
L0A76    lbsr  L0C3E
         bcs   L0ACF
         puls  x,b,a
         std   $03,x
L0A7F    ldu   $08,y
         ldd   <$11,y
         std   $0B,u
         ldd   $0F,y
         std   $09,u
         tfr   x,d
         clrb
         inca
         leax  $05,x
         pshs  x,b,a
         bra   L0ABA
L0A94    ldd   -$02,x
         beq   L0AC7
         std   <$1A,y
         ldd   -$05,x
         std   <$16,y
         lda   -$03,x
         sta   <$18,y
         bsr   L0AD2
         bcs   L0ACF
         stx   $02,s
         lbsr  L0C3E
         bcs   L0ACF
         ldx   $02,s
         clra
         clrb
         std   -$05,x
         sta   -$03,x
         std   -$02,x
L0ABA    lbsr  L0C98
         bcs   L0ACF
         ldx   $02,s
         leax  $05,x
         cmpx  ,s
         bcs   L0A94
L0AC7    clra
         clrb
         sta   <$19,y
         std   <$1A,y
L0ACF    leas  $04,s
         rts
L0AD2    pshs  u,y,x,a
         ldx   <$1E,y
         ldd   $06,x
         subd  #$0001
         addd  <$17,y
         std   <$17,y
         ldd   $06,x
         bcc   L0AFA
         inc   <$16,y
         bra   L0AFA
L0AEB    lsr   <$16,y
         ror   <$17,y
         ror   <$18,y
         lsr   <$1A,y
         ror   <$1B,y
L0AFA    lsra
         rorb
         bcc   L0AEB
         clrb
         ldd   <$1A,y
         beq   L0B42
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
         bhi   L0B41
         cmpa  <$1D,x
         bcc   L0B1D
         sta   <$1D,x
L0B1D    inca
         sta   ,s
L0B20    bsr   L0B44
         bcs   L0B20
         ldb   ,s
         bsr   L0B8A
         bcs   L0B41
         ldx   $08,y
         ldd   <$17,y
         anda  #$07
         ldy   <$1A,y
         os9   F$DelBit
         ldy   $03,s
         ldb   ,s
         bsr   L0B72
         bcc   L0B42
L0B41    coma
L0B42    puls  pc,u,y,x,a
L0B44    lbsr  L0CD0
         bra   L0B4E
L0B49    os9   F$IOQu
         bsr   L0B5E
L0B4E    bcs   L0B5D
         ldx   <$1E,y
         lda   <$17,x
         bne   L0B49
         lda   $05,y
         sta   <$17,x
L0B5D    rts
L0B5E    ldu   D.Proc
         ldb   <$36,u
         beq   L0B69
         cmpb  #$03
         bls   L0B70
L0B69    clra
         lda   $0D,u
         bita  #$02
         beq   L0B71
L0B70    coma
L0B71    rts
L0B72    clra
         tfr   d,x
         clrb
         lbsr  L0CA2
L0B79    pshs  cc
         ldx   <$1E,y
         lda   $05,y
         cmpa  <$17,x
         bne   L0B88
         clr   <$17,x
L0B88    puls  pc,cc
L0B8A    clra
         tfr   d,x
         clrb
         lbra  L0C5D
L0B91    pshs  u,x
         bsr   L0BB3
         bcs   L0BA2
         lbsr  L0C57
         bcs   L0BA2
         lda   $0A,y
         ora   #$02
         sta   $0A,y
L0BA2    puls  pc,u,x
         pshs  u,x
         lbsr  L0CA0
         bcs   L0BB1
         lda   $0A,y
         anda  #$FE
         sta   $0A,y
L0BB1    puls  pc,u,x
L0BB3    ldd   $0C,y
         subd  <$14,y
         tfr   d,x
         ldb   $0B,y
         sbcb  <$13,y
         cmpb  <$19,y
         bcs   L0BCB
         bhi   L0BCD
         cmpx  <$1A,y
         bcc   L0BCD
L0BCB    clrb
         rts
L0BCD    pshs  u
         bsr   L0C3E
         bcs   L0C27
         clra
         clrb
         std   <$13,y
         stb   <$15,y
         ldu   $08,y
         leax  <$10,u
         lda   $08,y
         ldb   #$FC
         pshs  b,a
L0BE6    ldd   $03,x
         beq   L0C0B
         addd  <$14,y
         tfr   d,u
         ldb   <$13,y
         adcb  #$00
         cmpb  $0B,y
         bhi   L0C18
         bne   L0BFF
         cmpu  $0C,y
         bhi   L0C18
L0BFF    stb   <$13,y
         stu   <$14,y
         leax  $05,x
         cmpx  ,s
         bcs   L0BE6
L0C0B    clra
         clrb
         sta   <$19,y
         std   <$1A,y
         comb
         ldb   #$D5
         bra   L0C27
L0C18    ldd   ,x
         std   <$16,y
         lda   $02,x
         sta   <$18,y
         ldd   $03,x
         std   <$1A,y
L0C27    leas  $02,s
         puls  pc,u
L0C2B    pshs  x,b
         lbsr  L0CD0
         bcs   L0C3A
         clrb
         ldx   #$0000
         bsr   L0C5D
         bcc   L0C3C
L0C3A    stb   ,s
L0C3C    puls  pc,x,b
L0C3E    ldb   $0A,y
         bitb  #$04
         bne   L0BCB
         lbsr  L0CD0
         bcs   L0CB8
         ldb   $0A,y
         orb   #$04
         stb   $0A,y
         ldb   <$34,y
         ldx   <$35,y
         bra   L0C5D
L0C57    bsr   L0CD0
         bcs   L0CB8
         bsr   L0CB9
L0C5D    lda   #$03
L0C5F    pshs  u,y,x,b,a
         ldu   $03,y
         ldu   $02,u
         bra   L0C6A
L0C67    os9   F$IOQu
L0C6A    lda   $04,u
         bne   L0C67
         lda   $05,y
         sta   $04,u
         ldd   ,s
         ldx   $02,s
         pshs  u
         bsr   L0C86
         puls  u
         lda   #$00
         sta   $04,u
         bcc   L0C84
         stb   $01,s
L0C84    puls  pc,u,y,x,b,a
L0C86    pshs  pc,x,b,a
         ldx   $03,y
         ldd   ,x
         ldx   ,x
         addd  $09,x
         addb  ,s
         adca  #$00
         std   $04,s
         puls  pc,x,b,a
L0C98    ldb   <$34,y
         ldx   <$35,y
         bra   L0CA2
L0CA0    bsr   L0CB9
L0CA2    lda   #$06
         pshs  x,b,a
         ldd   <$1C,y
         beq   L0CB1
         ldx   <$1E,y
         cmpd  $0E,x
L0CB1    puls  x,b,a
         beq   L0C5F
         comb
         ldb   #$FB
L0CB8    rts
L0CB9    ldd   $0C,y
         subd  <$14,y
         tfr   d,x
         ldb   $0B,y
         sbcb  <$13,y
         exg   d,x
         addd  <$17,y
         exg   d,x
         adcb  <$16,y
         rts
L0CD0    clrb
         pshs  u,x
         ldb   $0A,y
         andb  #$06
         beq   L0CED
         tfr   b,a
         eorb  $0A,y
         stb   $0A,y
         andb  #$01
         beq   L0CED
         eorb  $0A,y
         stb   $0A,y
         bita  #$02
         beq   L0CED
         bsr   L0CA0
L0CED    puls  pc,u,x
         emod
eom      equ   *
