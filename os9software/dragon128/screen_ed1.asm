         nam   screen
         ttl   os9 device driver

 use defsfile

tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   1
u0001    rmb   1
u0002    rmb   1
u0003    rmb   2
u0005    rmb   3
u0008    rmb   1
u0009    rmb   2
u000B    rmb   1
u000C    rmb   1
u000D    rmb   1
u000E    rmb   2
u0010    rmb   1
u0011    rmb   7
u0018    rmb   6
u001E    rmb   1
u001F    rmb   17
u0030    rmb   6
u0036    rmb   1
u0037    rmb   1
u0038    rmb   4
u003C    rmb   1
u003D    rmb   13
u004A    rmb   6
u0050    rmb   4
u0054    rmb   10
u005E    rmb   2
u0060    rmb   31
u007F    rmb   19
u0092    rmb   2
u0094    rmb   4
u0098    rmb   7
u009F    rmb   14
u00AD    rmb   1
u00AE    rmb   4
u00B2    rmb   12
u00BE    rmb   2
u00C0    rmb   4
u00C4    rmb   2
u00C6    rmb   12
u00D2    rmb   1
u00D3    rmb   1
u00D4    rmb   2
u00D6    rmb   5
u00DB    rmb   5
u00E0    rmb   2
u00E2    rmb   2
u00E4    rmb   1
u00E5    rmb   1
u00E6    rmb   1
u00E7    rmb   1
u00E8    rmb   2
u00EA    rmb   13
u00F7    rmb   1
u00F8    rmb   7
u00FF    rmb   245
u01F4    rmb   1
u01F5    rmb   1
u01F6    rmb   2
u01F8    rmb   1
u01F9    rmb   1
u01FA    rmb   1
u01FB    rmb   1
u01FC    rmb   1
u01FD    rmb   1
u01FE    rmb   1
u01FF    rmb   1
u0200    rmb   1
u0201    rmb   1
u0202    rmb   2
u0204    rmb   2
u0206    rmb   3
u0209    rmb   1
u020A    rmb   1
u020B    rmb   1
u020C    rmb   1
u020D    rmb   2
u020F    rmb   1
u0210    rmb   1
u0211    rmb   1
u0212    rmb   11
u021D    rmb   11
u0228    rmb   11
u0233    rmb   10
u023D    rmb   1
u023E    rmb   1
u023F    rmb   1
u0240    rmb   2
u0242    rmb   2
u0244    rmb   1
u0245    rmb   2
u0247    rmb   1
u0248    rmb   1
u0249    rmb   1
u024A    rmb   1
u024B    rmb   1
u024C    rmb   2
u024E    rmb   2
u0250    rmb   1
u0251    rmb   1
u0252    rmb   1
u0253    rmb   1
u0254    rmb   2
u0256    rmb   1
u0257    rmb   1
u0258    rmb   2
u025A    rmb   5
u025F    rmb   1
u0260    rmb   1
u0261    rmb   1
u0262    rmb   1
u0263    rmb   1
u0264    rmb   1
u0265    rmb   1
u0266    rmb   100
size     equ   .

         fcb   $03

name     equ   *
         fcs   /screen/
         fcb   $01

start    equ   *
         lbra  INIT
         lbra  READ
         lbra  L01C8
         lbra  L008D
         lbra  L00DD
         lbra  TERMINAT

FDMASK    fcb $00,$C0,$80

INIT     ldb   #$01
         os9 F$GMap
         lbcs  L008C
         stx   >u0210,u
         lbsr  L0181
         bcs   L008C
         lda   >u0211,u
         lsla
         lsla
         lsla
         sta   >u020F,u
         anda  #$3F
         sta   >u020D,u
         inc   >u0209,u
         lda   #$60
         sta   >u0252,u
         lda   #$02
         lbsr  L055E
         lda   #$00
         lbsr  L056F
         ldd   #$FC25
         leay  >IRQSVC,pcr
         leax  >FDMASK,pcr
         os9   F$IRQ
         bcs   L008C
         ldx   #$FC24
         lda   #$1F
         sta   $01,x
         ldx   #$FC22
         leay  >u0228,u
         lbsr  L09CD
         lbsr  L0772
         leax  >L07B8,pcr
         os9   F$Timer
L008C    rts

L008D    ldx   $06,y
         cmpa  #$01
         bne   L00A1
         ldb   >u0253,u
         beq   L009D
         stb   $02,x
L009B    clrb
         rts

L009D    comb
         ldb   #$F6
         rts

L00A1    cmpa  #$06
         beq   L009B
         cmpa  #$20
         bne   L00BD
         ldd   >u024C,u
         std   $04,x
         ldd   >u024E,u
         std   $06,x
         lda   >u024B,u
         sta   $01,x
         clrb
         rts
L00BD    cmpa  #$02
         bne   L00D9
         lda   <u001F,u
         ldb   <u001E,u
         lsrb
         std   $06,x
         ldb   >u00D2,u
         addb  >u00BE,u
         lsrb
         lsrb
         lsrb
         clra
         std   $04,x
         rts

L00D9    comb
         ldb   #$D0
         rts

L00DD    cmpa  #$1A
         bne   L0100
         lda   $05,y
         ldx   $06,y
         ldb   $05,x
         pshs  cc
         orcc  #$50
         tst   >u0253,u
         bne   L00F9
         std   >u0254,u
         puls  cc
         bra   L009B
L00F9    puls  cc
         os9   F$Send
         clrb
         rts
L0100    cmpa  #$1B
         bne   L0111
         lda   $05,y
         cmpa  >u0254,u
         bne   L009B
         clr   >u0254,u
         rts
L0111    cmpa  #$20
         bne   L00D9
         clra
         clrb
         std   >u024C,u
         std   >u024E,u
         rts


TERMINAT ldx   #$0000
         os9   F$Timer
         ldx   #$0000
         os9   F$IRQ
         bsr   L015E
         ldx   >u0210,u
         ldb   #$01
         os9 F$GClr
         ldx   >u0240,u
         beq   L015C
         ldd   -$02,x
         lbsr  L07AA
L0142    ldx   D.Proc
         pshs  u,x
         ldx   D.SysPrc
         stx   D.Proc
         ldu   >u0242,u
         os9   F$UnLink
         puls  u,x
         stx   D.Proc
         ldx   #$0000
         stx   >u0240,u
L015C    clrb
         rts
L015E    pshs  u,y
         ldx   D.Proc
         pshs  x
         ldx   D.SysPrc
         stx   D.Proc
         ldu   >u00D6,u
         beq   L0173
         ldb   #$01
         os9   F$ClrBlk
L0173    puls  u
         stu   D.Proc
         puls  u,y
         ldx   #$0000
         stx   >u00D6,u
         rts
L0181    bsr   L015E
         tst   >u00E6,u
         bne   L0196
         ldx   >u0210,u
         bsr   L01B1
         bcs   L0195
         stx   >u00D6,u
L0195    rts
L0196    tst   <u001E,u
         beq   L0195
         ldb   >u00D4,u
         lsrb
         lsrb
         lsrb
         clra
         tfr   d,x
         pshs  x
         bsr   L01B1
         bcs   L01AF
         stx   >u00D6,u
L01AF    puls  pc,x
L01B1    pshs  u,y
         ldu   D.Proc
         pshs  u
         ldu   D.SysPrc
         stu   D.Proc
         ldb   #$01
         os9   F$MapBlk
         tfr   u,x
         puls  u
         stu   D.Proc
         puls  pc,u,y
L01C8    inc   >u0264,u
         bsr   L01D6
         pshs  cc
         clr   >u0264,u
         puls  pc,cc
L01D6    ldb   $54,u
         lbeq  L02A7
         cmpb  #$01
         lbne  L0278
         leax  >L0CE8,pcr
         lbsr  L02D4
         bcs   L01FB
         lbsr  L02F4
         tst   >u00E6,u
         beq   L0261
         clr   >u00E6,u
         bra   L0258
L01FB    ldx   >u0240,u
         bne   L0238
         ldx   D.Proc
         pshs  x
         ldx   D.SysPrc
         stx   D.Proc
         leax  >L02ED,pcr
         pshs  u,y,a
         lda   #$21
         os9   F$Link
         puls  a
         bcc   L0221
         puls  u,y
         puls  x
         stx   D.Proc
L021E    lbra  L0465
L0221    tfr   u,x
         ldu   $02,s
         sty   >u0240,u
         stx   >u0242,u
         ldx   $04,s
         stx   D.Proc
         tfr   y,x
         puls  u,y
         leas  $02,s
L0238    lbsr  L02D4
         bcs   L021E
         tst   >u00E4,u
         bne   L024E
         cmpa  -$02,x
         beq   L024E
         clr   $54,u
         comb
         ldb   #$CB
         rts
L024E    tst   >u00E6,u
         bne   L0261
         inc   >u00E6,u
L0258    pshs  x,a
         lbsr  L0181
         puls  x,a
         bcs   L02D3
L0261    suba  -$02,x
         lsla
         sta   >u00E2,u
         ldd   a,x
         leax  d,x
         stx   >u00E0,u
         leax  >u00EA,u
         stx   >u00E8,u
L0278    ldx   >u00E8,u
         tst   >u00E6,u
         bne   L0286
         jmp   [>u00E0,u]
L0286    pshs  dp,a
         tfr   u,d
         tfr   a,dp
         puls  a
         jsr   [>u00E0,u]
         puls  dp
         tst   $54,u
         bne   L02A6
         tst   >u00E4,u
         bne   L02A6
         pshs  b,cc
         lbsr  L0142
         puls  b,cc
L02A6    rts

L02A7    cmpa  #$1B
         bne   L02AF
         inc   $54,u
         rts
L02AF    tst   >u00E6,u
         beq   L02C2
         pshs  a
         clr   >u00E6,u
         lbsr  L0181
         puls  a
         bcs   L02D3
L02C2    bsr   L02F4
         cmpa  #$20
         lbcs  L03CF
         cmpa  #$7F
         lbeq  L03CF
         lbra  L05D7
L02D3    rts
L02D4    cmpa  ,x+
         bcs   L02DE
         cmpa  ,x+
         bhi   L02E0
         clrb
         rts
L02DE    leax  $01,x
L02E0    ldb   -$01,x
         subb  -$02,x
         incb
         lslb
         abx
         ldb   ,x
         bne   L02D4
         comb
         rts

L02ED    fcs "gfxdrvr"

L02F4    pshs  x,a
         tst   >u00E5,u
         beq   L02FF
         lbsr  L0721
L02FF    puls  pc,x,a
L0301    lda   D.LtPen
         bpl   L0365
         lda   #$10
         ldx   #$FC80
         sta   ,x
         ldb   $01,x
         pshs  b
         inca
         sta   ,x
         ldb   $01,x
         puls  a
         subd  #$0008
         subd  >u020D,u
         tst   >u0244,u
         bne   L0337
L0324    std   >u0245,u
         lda   #$04
         sta   >u0248,u
         sta   >u0244,u
         clr   >u0247,u
         rts
L0337    cmpd  >u0245,u
         bne   L0324
         tst   >u0248,u
         beq   L0349
         dec   >u0248,u
         rts
L0349    tst   >u0247,u
         beq   L035F
         dec   >u0247,u
         bne   L035D
         bsr   L036A
         lda   #$05
L0359    sta   >u0247,u
L035D    clrb
         rts
L035F    bsr   L036A
         lda   #$32
         bra   L0359
L0365    clr   >u0244,u
         rts
L036A    lda   #$1D
         bsr   L037E
         bsr   L0381
         lda   >u024A,u
         adda  #$20
         bsr   L037E
         lda   >u0249,u
         adda  #$20
L037E    lbra  L0AB2
L0381    ldd   >u0245,u
         clr   ,-s
L0387    inc   ,s
         subb  >u01F9,u
         sbca  #$00
         bcc   L0387
         dec   ,s
         addb  >u01F9,u
         puls  a
         std   >u0249,u
         clrb
         rts


IRQSVC    ldx   #$FC24
         lda   $01,x
         ldb   ,x
         ldb   $02,x
         leax  >u024E,u
         tsta
         bpl   L03B7
         leax  >u024C,u
         bitb  #$10
         bra   L03BB
L03B7    eorb  #$20
         bitb  #$20
L03BB    bne   L03C4
         ldy   ,x
         leay  -$01,y
         bra   L03C9
L03C4    ldy   ,x
         leay  $01,y
L03C9    sty   ,x
         clrb
         clrb
         rts
L03CF    leax  >L0CA6,pcr
         cmpa  #$7F
         bne   L03D9
         lda   #$20
L03D9    lsla
         ldd   a,x
         jmp   d,x
         ldx   #$FC26
         pshs  y
         ldy   #$0014
L03E7    pshs  y
         pshs  cc
         orcc  #$50
         lda   ,x
         eora  #$01
         sta   ,x
         puls  cc
         ldy   #$0064
L03F9    leay  -$01,y
         bne   L03F9
         puls  y
         leay  -$01,y
         bne   L03E7
         clrb
         puls  pc,y
L0406    dec   >u01F5,u
         bpl   L0418
         lda   >u01F9,u
         deca
         sta   >u01F5,u
         lbra  L048B
L0418    lbra  L061C
L041B    lda   >u01F4,u
         inca
         cmpa  >u01F8,u
         lbeq  L065F
         sta   >u01F4,u
         lbra  L061C
         clr   >u01F5,u
         lbra  L061C
L0436    bsr   L045A
L0438    ldd   >u01F4,u
         pshs  b,a
L043E    lbsr  L063D
         clr   >u01F5,u
         inc   >u01F4,u
         lda   >u01F4,u
         cmpa  >u01F8,u
         bcs   L043E
         puls  b,a
         std   >u01F4,u
         rts
L045A    clr   >u01F4,u
         clr   >u01F5,u
         lbra  L061C
L0465    clr   $54,u
         rts
         lbsr  L0406
         bra   L0465
L046E    lda   >u01F5,u
         inca
         sta   >u01F5,u
         cmpa  >u01F9,u
         bcs   L0484
         clr   >u01F5,u
         lbra  L041B
L0484    lbra  L061C
         bsr   L046E
         bra   L0465
L048B    dec   >u01F4,u
         bpl   L0484
         clr   >u01F4,u
         lbra  L06A4
         bsr   L048B
         bra   L0465
         lbsr  L041B
         bra   L0465
         ldb   $54,u
         suba  #$20
         inc   $54,u
         subb  #$01
         bne   L04AE
         rts
L04AE    decb
         bne   L04C2
L04B1    cmpa  >u01F9,u
         bcs   L04BC
         lda   >u01F9,u
         deca
L04BC    sta   >u01F5,u
         clrb
         rts
L04C2    bsr   L04DD
L04C4    lbsr  L061C
         bra   L04F1
         ldb   $54,u
         suba  #$20
         inc   $54,u
         subb  #$01
         bne   L04D6
         rts
L04D6    decb
         beq   L04DD
         bsr   L04B1
         bra   L04C4
L04DD    cmpa  >u01F8,u
         bcs   L04E8
         lda   >u01F8,u
         deca
L04E8    sta   >u01F4,u
         clrb
         rts
         lbsr  L063D
L04F1    lbra  L0465
         lbsr  L0438
         bra   L04F1
         ldb   #$01
         bsr   L053C
         sta   >u0258,u
         lbsr  L0744
         bra   L04F1
         ldb   #$03
         bsr   L053C
         clrb
         lsra
         bcc   L0510
         ldb   #$80
L0510    stb   >u0250,u
         sta   >u0251,u
         lbsr  L0744
         bra   L04F1
         lbsr  L0721
         bra   L04F1
         ldb   #$02
         bsr   L053C
         leax  <L0539,pcr
         ldb   a,x
         stb   >u0252,u
         lda   #$0A
         sta   >$FC80
         stb   >$FC81
         bra   L04F1

L0539    fcb $60,$69,$20

L053C    pshs  b
         ldb   <$54,u
         inc   <$54,u
         subb  #$01
         bne   L054C
         leas  $03,s
         clrb
         rts

L054C    suba  #$30
         bcs   L0556
         cmpa  ,s
         bhi   L0556
         puls  pc,b
L0556    leas  $03,s
         bra   L0593
         ldb   #$07
         bsr   L053C
L055E    sta   >u01FD,u
         lsla
         lsla
         lsla
         sta   >u01FA,u
         bra   L0590
         ldb   #$07
         bsr   L053C
L056F    sta   >u01FB,u
         lsla
         lsla
         lsla
         sta   >u01FC,u
         bra   L0590
         lda   #$40
         sta   >u01FF,u
         bra   L0590
         clr   >u01FF,u
         bra   L0590
         lda   #$80
         sta   >u0200,u
L0590    lbsr  L05F7
L0593    lbra  L0465
         clr   >u0200,u
         bra   L0590
         lda   #$01
         sta   >u0209,u
L05A2    lbsr  L0772
         bra   L0593
         clr   >u0209,u
         bra   L05A2
         clr   >u020A,u
         bra   L0593
         lda   #$01
         sta   >u020A,u
         bra   L0593
         lda   #$01
         sta   >u01FE,u
         bra   L0590
         clr   >u01FE,u
         bra   L0590
         lda   #$01
         sta   >u00E7,u
         bra   L0593
         clr   >u00E7,u
         bra   L0593
L05D7    ldb   >u0201,u
         tsta
         bpl   L05EC
         cmpa  #$A0
         bls   L05E4
         clrb
         rts
L05E4    bcs   L05EA
         lda   #$7F
         bra   L05EC
L05EA    anda  #$1F
L05EC    ora   >u0250,u
         std   [>u0202,u]
         lbra  L046E
L05F7    ldb   >u01FF,u
         orb   >u0200,u
         tst   >u01FE,u
         bne   L060F
         orb   >u01FA,u
         orb   >u01FB,u
         bra   L0617
L060F    orb   >u01FC,u
         orb   >u01FD,u
L0617    stb   >u0201,u
         rts
L061C    ldd   >u01F4,u
         lbsr  L06F0
         pshs  b,a
         lsra
         rorb
         std   >u01F6,u
         puls  b,a
         addd  >u00D6,u
         std   >u0202,u
         ldb   #$01
         stb   >u020B,u
         clrb
         rts
L063D    ldd   >u01F4,u
         lbsr  L06E4
         ldb   >u01F9,u
         subb  >u01F5,u
         pshs  b
         ldb   >u0201,u
         andb  #$3F
         lda   #$20
L0656    std   ,x++
         dec   ,s
         bne   L0656
         clrb
         puls  pc,a
L065F    ldd   >u01F4,u
         pshs  b,a
         lda   >u01F8,u
         deca
         clrb
         std   >u01F4,u
         clrb
         lda   #$01
         pshs  u,y
         lbsr  L06E4
         ldy   >u0206,u
         ldu   >u00D6,u
         bsr   L068F
         puls  u,y
L0684    bsr   L063D
         puls  b,a
         std   >u01F4,u
         lbra  L061C
L068F    ldd   ,x++
         std   ,u++
         ldd   ,x++
         std   ,u++
         ldd   ,x++
         std   ,u++
         ldd   ,x++
         std   ,u++
         leay  -$04,y
         bne   L068F
         rts
L06A4    ldd   >u01F4,u
         pshs  b,a
         clra
         clrb
         std   >u01F4,u
         clrb
         lda   >u01F8,u
         deca
         pshs  u,y
         bsr   L06E4
         ldy   >u0206,u
         ldu   >u00D6,u
         tfr   y,d
         lslb
         rola
         leau  d,u
         bsr   L06CF
         puls  u,y
         bra   L0684
L06CF    ldd   ,--x
         std   ,--u
         ldd   ,--x
         std   ,--u
         ldd   ,--x
         std   ,--u
         ldd   ,--x
         std   ,--u
         leay  -$04,y
         bne   L06CF
         rts
L06E4    pshs  b,a
         bsr   L06F0
         ldx   >u00D6,u
         leax  d,x
         puls  pc,b,a
L06F0    lslb
         pshs  b
         ldb   >u01F9,u
         lslb
         mul
         addb  ,s+
         adca  #$00
         rts
L06FE    leax  >L0C8E,pcr
         ldb   #$50
         tst   >u0209,u
         beq   L0710
         leax  >L0C9A,pcr
         ldb   #$28
L0710    stb   >u01F9,u
         lda   #$19
         sta   >u01F8,u
         deca
         mul
         std   >u0206,u
         rts
L0721    bsr   L06FE
         clra
         ldb   #$0C
         pshs  cc
         orcc  #$50
         bsr   L0785
         lda   #$0A
         sta   >$FC80
         lda   >u0252,u
         sta   >$FC81
         lda   #$01
         sta   >u020C,u
         sta   >u020B,u
         puls  cc
L0744    lda   >u020F,u
         anda  #$C0
         ora   >u0258,u
         tst   >u0251,u
         beq   L0756
         ora   #$02
L0756    tst   >u0209,u
         bne   L0760
         ora   #$2C
         bra   L0762
L0760    ora   #$08
L0762    pshs  cc
         orcc  #$50
         sta   >$FCC2
         sta   D.GRReg
         puls  cc
         clr   >u00E5,u
         rts
L0772    clra
         clrb
         std   >u01F4,u
         std   >u01F6,u
         lbsr  L06FE
         lbsr  L0436
         lbra  L0721
L0785    pshs  y,b
         ldy   #$FC80
L078B    sta   ,y
         ldb   ,x+
         stb   $01,y
         inca
         dec   ,s
         bne   L078B
         puls  pc,y,b
L0798    tst   >u00E4,u
         beq   L07D8
         ldx   >u0240,u
         beq   L07D8
         ldd   -$04,x
         bsr   L07AA
         clrb
         rts
L07AA    leax  d,x
         leax  $02,x
         pshs  dp
         tfr   u,d
         tfr   a,dp
         jsr   ,x
         puls  pc,dp
L07B8    bsr   L07D9
         lbsr  L0301
         bsr   L081B
         tst   >u0264,u
         bne   L07D8
         tst   >u0265,u
         beq   L07D8
         clr   >u0265,u
         tst   >u00E5,u
         beq   L0798
         lbsr  L0721
L07D8    rts
L07D9    tst   >u020B,u
         beq   L07EB
         lda   #$0E
         leax  >u01F6,u
         bsr   L0804
         clr   >u020B,u
L07EB    tst   >u00E5,u
         bne   L0803
         tst   >u020C,u
         beq   L0803
         lda   #$0C
         leax  >u0204,u
         bsr   L0804
         clr   >u020C,u
L0803    rts
L0804    pshs  a
         ldd   ,x
         addd  >u020D,u
         tfr   d,x
         puls  a
         pshs  x
         leax  ,s
         ldb   #$02
         lbsr  L0785
         puls  pc,x
L081B    lbsr  L0A9D
         bne   L0825
L0820    clr   >u025A,u
         rts
L0825    lda   >u025A,u
         bne   L0852
         lda   #$01
         sta   >u023D,u
         sta   >u025A,u
         leay  >u021D,u
         lbsr  L09CD
         bcs   L0820
         leay  >u0212,u
         ldb   #$0A
         clra
L0845    sta   ,y+
         decb
         bne   L0845
L084A    ldb   #$01
         stb   >u023E,u
L0850    clrb
         rts
L0852    leay  >u0228,u
         lbsr  L09CD
         bcs   L0850
         leay  >u0228,u
         leax  >u021D,u
         clr   ,-s
         ldb   #$0B
L0867    lda   ,y+
         cmpa  ,x+
         beq   L0871
         inc   ,s
         sta   -$01,x
L0871    decb
         bne   L0867
         lda   ,s+
         bne   L084A
         lda   >u023E,u
         lbeq  L0949
         dec   >u023E,u
         beq   L0895
         clrb
         rts
L0888    pshs  u,a
         ldu   $06,s
         lda   #$01
         sta   >u023D,u
         puls  u,a
         rts
L0895    leay  >u0212,u
         leax  >u021D,u
         lda   $0A,x
         sta   >u024B,u
         ldb   #$0B
         pshs  u
         leau  >u0228,u
         clr   ,-s
L08AD    lda   ,x+
         eora  ,y+
         sta   ,u+
         beq   L08CD
         anda  -$01,x
         cmpa  -u0001,u
         beq   L08BD
         bsr   L0888
L08BD    sta   -u0001,u
         beq   L08C9
         inc   ,s
         cmpb  #$01
         bne   L08C9
         bsr   L0888
L08C9    lda   -$01,x
         sta   -$01,y
L08CD    decb
         bne   L08AD
         lda   ,s+
         puls  u
         beq   L0949
         clr   >u025F,u
         clr   >u0260,u
         clr   >u0261,u
         lda   >u0212,u
         bita  #$01
         beq   L08EE
         inc   >u025F,u
L08EE    bita  #$10
         beq   L08F6
         inc   >u0260,u
L08F6    bita  #$02
         beq   L08FE
         inc   >u0261,u
L08FE    lda   #$32
         sta   >u023F,u
         lda   >u0228,u
         bita  #$13
         beq   L0918
         anda  #$EC
         sta   >u0228,u
         lda   #$01
         sta   >u023D,u
L0918    ldd   #$000B
         pshs  b,a
         leay  >u0228,u
L0921    ldb   ,y+
         beq   L0941
         clra
L0926    inca
         lsrb
         bcc   L0926
         deca
         pshs  b,a
         lda   $02,s
         ldb   #$07
         mul
         addb  ,s
         stb   >u0262,u
         lbsr  L095D
         puls  b,a
         inca
         tstb
         bne   L0926
L0941    inc   ,s
         dec   $01,s
         bne   L0921
         puls  pc,b,a
L0949    dec   >u023F,u
         beq   L0951
L094F    clrb
         rts
L0951    lda   #$05
         sta   >u023F,u
         tst   >u023D,u
         bne   L094F
L095D    lda   >u0262,u
         leax  >L0B1B,pcr
         tst   >u0261,u
         beq   L096F
         leax  >L0BF3,pcr
L096F    tst   >u0260,u
         beq   L0979
         leax  >L0BAB,pcr
L0979    tst   >u025F,u
         beq   L0983
         leax  >L0B63,pcr
L0983    lda   a,x
         tst   >u0263,u
         beq   L0995
         cmpa  #$61
         bcs   L0995
         cmpa  #$7A
         bhi   L0995
         suba  #$20
L0995    cmpa  #$FF
         bne   L09A5
         com   >u0263,u
L099D    lda   #$01
         sta   >u023D,u
         clrb
         rts
L09A5    cmpa  #$FE
         bne   L09B1
         lda   #$01
         sta   >u0265,u
         bra   L099D
L09B1    clr   >u023D,u
         tsta
         bpl   L09CA
         tst   >u020A,u
         bne   L09CA
         pshs  x
         leax  >L0BF3,pcr
         cmpx  ,s++
         beq   L09CA
         anda  #$3F
L09CA    lbra  L0AB2

L09CD    lda   >$FC26
         anda  #$0C
         lsra
         lsra
         sta   $0A,y
         lda   #$2C
         sta   $01,x
         ldb   ,x
         orb   #$10
         bsr   L0A5A
         andb  #$EF
         stb   ,x
         lda   #$3C
         sta   $01,x
         orb   #$10
         stb   ,x
         clr   ,-s
         ldb   #$0A
         pshs  u,b
         leau  >u0233,u
L09F6    clr   ,y+
         clr   ,u+
         ldb   ,x
         lda   #$34
         sta   $01,x
         lda   #$3C
         sta   $01,x
         bitb  #$04
         beq   L0A34
         clr   ,-s
         lda   #$07
         pshs  a
         clra
L0A0F    andb  #$EF
         stb   ,x
         orb   #$10
         stb   ,x
         ldb   ,x
         lsla
         bitb  #$20
         beq   L0A21
         inca
         inc   $01,s
L0A21    dec   ,s
         bne   L0A0F
         leas  $01,s
         sta   -$01,y
         lda   ,s+
         beq   L0A34
         deca
         beq   L0A34
         sta   -u0001,u
         inc   $03,s
L0A34    dec   ,s
         bne   L09F6
         puls  u,a
         andb  #$EF
         lda   #$2C
         sta   $01,x
         bsr   L0A58
         lda   #$34
         sta   $01,x
         orb   #$10
         tst   >u0263,u
         beq   L0A50
         andb  #$EF
L0A50    stb   ,x
         lda   ,s+
         bne   L0A6D
         clrb
         rts

L0A58    stb   ,x
L0A5A    stb   ,x
         stb   ,x
         stb   ,x
         stb   ,x
         stb   ,x
         stb   ,x
         stb   ,x
         stb   ,x
         stb   ,x
         rts
L0A6D    leay  -$0A,y
         leax  >u0233,u
         lda   #$0A
         pshs  y,a
L0A77    lda   ,y+
         ldb   ,x+
         beq   L0A96
         ldb   #$0A
         pshs  y
         ldy   $03,s
L0A84    bita  ,y+
         beq   L0A91
         cmpy  ,s
         beq   L0A91
         leas  $05,s
         comb
         rts
L0A91    decb
         bne   L0A84
         puls  y
L0A96    dec   ,s
         bne   L0A77
         clrb
         puls  pc,y,a
L0A9D    ldx   #$FC22
         lda   ,x
         bita  #$04
         bne   L0AB1
         lda   >$FC26
         anda  #$0C
         lsra
         lsra
         cmpa  >u024B,u
L0AB1    rts
L0AB2    leax  >u0266,u
         ldb   >u0256,u
         sta   b,x
         incb
         cmpb  #$64
         bcs   L0AC2
         clrb
L0AC2    cmpb  >u0257,u
         bne   L0ACE
         ldb   #$F4
         stb   u000E,u
         bra   L0AD6
L0ACE    stb   >u0256,u
         inc   >u0253,u
L0AD6    tsta
         beq   L0AFA
         cmpa  u000D,u
         bne   L0AE5
         ldx   u0009,u
         beq   L0AFA
         sta   $08,x
         bra   L0AFA
L0AE5    ldb   #$03
         cmpa  u000B,u
         beq   L0AF1
         ldb   #$02
         cmpa  u000C,u
         bne   L0AFA
L0AF1    lda   u0003,u
         beq   L0AFA
         os9   F$Send
         bra   L0B18
L0AFA    tst   >u0254,u
         beq   L0B0B
         ldd   >u0254,u
         clr   >u0254,u
         os9   F$Send
L0B0B    clrb
         lda   u0005,u
         beq   L0B18
         tfr   d,x
         lda   $0C,x
         anda  #$F7
         sta   $0C,x
L0B18    clr   u0005,u
         rts

L0B1B    fcb $00,$00,$0C,$38,$00,$FF,$1B,$62,$6A,$69,$39,$75,$68,$37,$6E,$6B
         fcb $6F,$30,$79,$67,$36,$6D,$6C,$70,$2D,$74,$66,$35,$2C,$3B,$40,$5E
         fcb $76,$64,$34,$2E,$3A,$5C,$5B,$72,$73,$33,$2F,$0D,$08,$5D,$63,$78
         fcb $20,$AA,$B7,$B4,$B1,$65,$7A,$32,$B0,$B8,$B5,$B2,$77,$61,$31,$A3
         fcb $B9,$B6,$B3,$71,$09,$AE,$1E,$1F


L0B63    fcb $00,$00,$1C,$28,$00,$FF,$05,$42,$4A,$49,$29,$55,$48,$27,$4E,$4B
         fcb $4F,$5F,$59,$47,$26,$4D,$4C,$50,$3D,$54,$46,$25,$3C,$2B,$60,$7E
         fcb $56,$44,$24,$3E,$2A,$7C,$7B,$52,$53,$23,$3F,$0D,$18,$7D,$43,$58
         fcb $20,$EA,$F7,$F4,$F1,$45,$5A,$22,$F0,$F8,$F5,$F2,$57,$41,$21,$E3
         fcb $F9,$F6,$F3,$51,$1D,$EE,$1E,$1F

L0BAB    fcb $00,$00,$1E,$38,$00,$FF,$03,$02
         fcb $0A,$09,$39,$15,$08,$37,$00,$0B,$0F,$30,$19,$07,$36,$0D,$0C,$10
         fcb $2D,$14,$06,$35,$29,$3B


         fcb $00,$5E,$16,$04,$34,$2E,$3A,$5C,$5B,$12,$13,$33,$2F,$0D,$7F,$5D
         fcb $03,$18,$20,$8A,$97,$94,$91,$05,$1A,$32,$90,$98,$95,$92,$17,$01
         fcb $31,$83,$99,$96,$93,$11,$1F,$8E,$1E,$1F

L0BF3 fcb $00,$00,$8C,$B8,$00,$FE,$8B,$C2,$CA,$C9,$B9,$D5,$C8,$B7,$CE,$CB
      fcb $CF,$B0,$D9,$C7,$B6,$CD,$CC,$D0,$AD,$D4,$C6,$B5,$AC,$BB,$80,$DE
      fcb $D6,$C4,$B4,$AE,$BA,$DC,$DB,$D2,$D3,$B3,$AF,$0D,$88,$DD,$C3,$F8
      fcb $A0,$AA,$B7,$B4,$B1,$C5,$DA,$B2,$B0,$B8,$B5,$B2,$D7,$C1,$B1,$A3
      fcb $B9,$B6,$B3,$D1,$89,$AE,$9E,$9F



L0C3B    lda   D.Proc
         sta   u0005,u
         ldx   D.Proc
         lda   $0C,x
         ora   #$08
         sta   $0C,x
         andcc #$AF
         ldx   #$0001
         os9   F$Sleep
         ldx   D.Proc
         ldb   <$19,x
         beq   L0C5C
         cmpb  #$03
         bhi   L0C5C
L0C5A    coma
         rts
L0C5C    clra
         lda   $0C,x
         bita  #$02
         bne   L0C5A
READ     leax  >u0266,u
         orcc  #$50
         ldb   >u0257,u
         tst   >u0253,u
         beq   L0C3B
         lda   b,x
         dec   >u0253,u
         incb
         cmpb  #$64
         bcs   L0C7F
         clrb
L0C7F    stb   >u0257,u
         andcc #$AE
         ldb   u000E,u
         beq   L0C8D
         clr   u000E,u
         orcc  #$01
L0C8D    rts

L0C8E    fcb $6F,$50,$5A,$3A,$1E,$02,$19,$1B,$50,$09,$60,$09
L0C9A    fcb $37,$28,$2E,$35,$1E,$02,$19,$1B,$50,$09,$60,$09

L0CA6 fcb $F7,$27,$F7,$27,$F7,$27,$F7,$27,$F7,$27,$F7,$27,$F7,$27,$F7,$38
      fcb $F7,$60,$F7,$27,$F7,$75,$F7,$B4,$F7,$90,$F7,$89,$F7,$27,$F7,$27
      fcb $F7,$27,$F7,$27,$F7,$27,$F7,$27,$F7,$27,$F7,$27,$F7,$27,$F7,$27
      fcb $F7,$27,$F7,$27,$F7,$27,$F7,$27,$F7,$27,$F7,$27,$F7,$27,$F7,$27
      fcb $F7,$27

L0CE8 fcb $41,$5A,$F7,$B7,$F8,$04,$F7,$9D,$F7,$A1,$F7,$B2,$F8,$D1,$F8,$D9
      fcb $F8,$92,$F8,$9A,$F8,$0A,$F7,$7F,$F7,$DF,$F8,$0F,$F8,$1C,$F8,$33
      fcb $F8,$38,$F8,$70,$F8,$81,$F8,$A0,$F8,$AC,$F8,$B2,$F8,$BD,$F8,$C3
      fcb $F8,$C9,$F8,$DF,$F8,$E7,$00

         emod
eom      equ   *
