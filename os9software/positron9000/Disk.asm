         nam   Disk
         ttl   os9 device driver


 use defsfile

tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   1
u0001    rmb   2
u0003    rmb   3
u0006    rmb   9
u000F    rmb   53
u0044    rmb   12
u0050    rmb   59
u008B    rmb   1
u008C    rmb   68
u00D0    rmb   111
u013F    rmb   1
u0140    rmb   2
u0142    rmb   2
u0144    rmb   1
u0145    rmb   2
u0147    rmb   1
u0148    rmb   2
u014A    rmb   1
u014B    rmb   1
u014C    rmb   1
u014D    rmb   1
u014E    rmb   1
u014F    rmb   1
u0150    rmb   1
u0151    rmb   1
u0152    rmb   2
u0154    rmb   2
u0156    rmb   1
u0157    rmb   2
u0159    rmb   2
u015B    rmb   2
u015D    rmb   2
u015F    rmb   2
u0161    rmb   32
size     equ   .
         fcb   $FF
name     equ   *
         fcs   /Disk/
         fcb   $03

start    equ   *
         lbra  L0025
         lbra  READ
         lbra  L00C8
         lbra  L01DE
         lbra  L01E0
         lbra  L0353

L0025    lda   #$08
         sta   u0006,u
         leax  u000F,u
L002B    ldb   #$FF
         stb   $0D,x
         stb   <$15,x
         ldb   #$0A
         stb   $02,x
         ldb   #$01
         stb   <$10,x
         leax  <$26,x
         deca
         bne   L002B
         clr   >u0156,u
         ldx   #$0144
         ldy   >$FF80
         pshs  cc
         orcc  #$50
         stx   >$FF80
         lda   >$0000
         sty   >$FF80
         puls  cc
         anda  #$E0
         sta   <u008C
         clrb
         rts

READ    lbsr  L0542
         lbsr  L049C
         lbsr  L04BE
         stb   >u013F,u
         stx   >u0140,u
         lbsr  L05D5
         bcs   L00C1
         lbsr  L011B
         bcs   L00C1
         leax  >L068A,pcr
         ldb   #$04
         lbsr  L0355
         ldx   $08,y
         ldb   #$00
         lbsr  L03B2
         lbsr  L055C
         bcs   L00BC
         lbsr  L0513
         clr   <u008B
         tst   >u013F,u
         bne   L00A1
         ldd   >u0140,u
L00A1    beq   L00A5
         clrb
         rts
L00A5    ldx   $08,y
         lda   <$21,y
         ldb   #$26
         mul
         leay  u000F,u
         leay  d,y
         ldb   #$14
L00B3    lda   b,x
         sta   b,y
         decb
         bpl   L00B3
         clrb
         rts
L00BC    tstb
         bne   L00C1
         ldb   #$F4
L00C1    lbsr  L0513
         clr   <u008B
         coma
         rts

L00C8    lbsr  L0542
         lbsr  L049C
         lbsr  L04BE
         stb   >u013F,u
         stx   >u0140,u
         lbsr  L05D5
         bcs   L0114
         bsr   L011B
         bcs   L0114
         ldx   $08,y
         stx   >u0142,u
         inc   >u0144,u
         leax  >L068E,pcr
         ldb   #$04
         lbsr  L0355
L00F5    ldx   #$0001
         os9   F$Sleep
         lbsr  L05BA
         bita  >u0151,u
         beq   L00F5
         lbsr  L055C
         bcs   L010F
         lbsr  L0513
         clr   <u008B
         rts
L010F    tstb
         bne   L0114
         ldb   #$F5
L0114    lbsr  L0513
         clr   <u008B
         coma
         rts
L011B    pshs  y
         lda   <$21,y
         ldb   #$26
         mul
         leay  u000F,u
         leay  d,y
         ldb   >u013F,u
         cmpb  ,y
         lbhi  L01D8
         bcs   L013D
         ldx   >u0140,u
         cmpx  $01,y
         lbcc  L01D8
L013D    pshs  y
         ldy   $02,s
         tstb
         bne   L014A
         cmpx  <$2B,y
         bcs   L0197
L014A    lda   <$2C,y
         pshs  b,a
         tfr   x,d
         subb  ,s
         sbca  #$00
         tfr   d,x
         puls  b,a
         sbcb  #$00
         ldy   ,s
         lda   <$12,y
         lbsr  L0664
         sta   >u014D,u
         leax  $01,x
         lda   <$10,y
         ldy   $02,s
         ldb   <$21,y
         cmpb  #$04
         bcc   L017C
         anda  #$01
         inca
         bra   L0189
L017C    anda  #$38
         lsra
         lsra
         lsra
         adda  #$04
         cmpa  #$09
         bcs   L0189
         suba  #$08
L0189    clrb
         lbsr  L0664
         stx   >u014A,u
         sta   >u014C,u
         bra   L01A9
L0197    tfr   x,d
         stb   >u014D,u
         clr   >u014A,u
         clr   >u014B,u
         clr   >u014C,u
L01A9    puls  y
         ldb   <$10,y
         andb  #$07
         puls  y
         lda   <$23,y
         lsra
         lsra
         lsra
         anda  #$08
         pshs  a
         orb   ,s+
         lda   #$0C
         std   >u0148,u
         leax  >u0148,u
         ldb   #$06
         lbsr  L0355
         lbsr  L055C
         bcc   L01D7
         tstb
         bne   L01D7
         ldb   #$F7
L01D7    rts
L01D8    puls  y
         comb
         ldb   #$F1
         rts

L01DE    clrb
         rts

L01E0    ldx   $06,y
         ldb   $02,x
         cmpb  #$81
         bne   L01ED
         inc   >u014E,u
         rts
L01ED    cmpb  #$82
         bne   L01FB
         dec   >u014E,u
         bne   L01FA
         lbsr  L0513
L01FA    rts
L01FB    lbsr  L0542
         lbsr  L049C
         cmpb  #$03
         bne   L0225
         lbsr  L04BE
         lbsr  L05D5
         lbcs  L02F5
         leax  >L0692,pcr
         ldb   #$06
         lbsr  L0355
L0218    lbsr  L05BA
         bita  >u0151,u
         beq   L0218
         clrb
         lbra  L02F5
L0225    cmpb  #$04
         bne   L0296
         lbsr  L04BE
         lbsr  L05D5
         lbcs  L02F5
         ldb   $07,x
         lda   <$23,y
         lsra
         lsra
         lsra
         anda  #$08
         pshs  a
         orb   ,s+
         lda   #$0C
         std   >u0148,u
         ldd   $08,x
         std   >u014A,u
         clra
         clrb
         std   >u014C,u
         pshs  x
         leax  >u0148,u
         ldb   #$06
         lbsr  L0355
L025E    lbsr  L05BA
         bita  >u0151,u
         beq   L025E
         puls  x
         clra
         ldb   $06,x
         leax  >u0148,u
         std   $02,x
         ldd   #$1800
         std   ,x
         ldb   #$04
         lbsr  L0355
L027C    lbsr  L0513
         ldx   #$0001
         os9   F$Sleep
         lbsr  L04BE
         lbsr  L05BA
         bita  >u0151,u
         beq   L027C
         lbsr  L055C
         bra   L02F5
L0296    cmpb  #$0D
         bne   L0309
         ldb   $07,x
         ldx   $04,x
         stb   >u013F,u
         stx   >u0140,u
         lbsr  L04BE
         lbsr  L05D5
         bcs   L02F5
         lbsr  L011B
         bcs   L02F5
         ldx   $06,y
         lda   $06,x
         pshs  a
         leax  >u0148,u
         lda   #$07
         sta   ,x
         ldd   #$0000
         std   $01,x
         puls  a
         sta   $03,x
         ldb   #$04
         lbsr  L0355
         lbsr  L055C
         ldb   #$F4
         bcs   L02FD
         ldx   #$0000
         ldd   >u0154,u
         stx   >u0154,u
         andb  #$F0
         cmpd  #$8010
         bne   L02F7
         ldx   $06,y
         lda   $06,x
         cmpa  #$01
         beq   L02F7
         ldb   #$F4
         bra   L02FD
L02F5    bcs   L02FD
L02F7    lbsr  L0513
         clr   <u008B
         rts
L02FD    tstb
         bne   L0302
         ldb   #$F5
L0302    lbsr  L0513
         clr   <u008B
         coma
         rts
L0309    cmpb  #$80
         bne   L0316
         lda   $05,x
         sta   >u0156,u
         clr   <u008B
         rts
L0316    cmpb  #$81
         bne   L034D
         lbsr  L04BE
         lbsr  L05D5
         bcs   L02F5
         ldx   u0001,u
         lda   #$11
         sta   $03,x
         lbsr  L03F2
         lda   >u0150,u
         anda  #$1F
         ora   #$20
         sta   $07,x
         lbsr  L03F2
         lda   #$04
         sta   $07,x
         lbsr  L03F2
         lda   #$3F
         sta   $07,x
         lbsr  L03F2
         lda   #$12
         sta   $03,x
         lbra  L027C
L034D    clr   <u008B
         comb
         ldb   #$D0
         rts
L0353    clrb
         rts
L0355    pshs  y,x,b,a
         stx   >u0145,u
         stb   >u0147,u
         ldx   u0001,u
         lda   #$11
         sta   $03,x
         lbsr  L03F2
         lda   >u0150,u
         anda  #$1F
         ora   #$20
         sta   $07,x
         bsr   L03F2
         lda   #$8A
         sta   $03,x
         lda   #$0B
         sta   $03,x
         bsr   L03F2
         lbsr  L041C
         tst   >u0144,u
         beq   L039C
         clr   >u0147,u
         ldy   >u0142,u
         sty   >u0145,u
         clr   >u0144,u
         lbsr  L041C
L039C    lda   #$0C
         sta   $03,x
         bsr   L03F2
         lda   #$0A
         sta   $03,x
         lda   #$3F
         sta   $07,x
         bsr   L03F2
         lda   #$12
         sta   $03,x
         puls  pc,y,x,b,a
L03B2    pshs  y,x,b,a
         stx   >u0145,u
         stb   >u0147,u
         ldx   u0001,u
         lda   #$11
         sta   $03,x
         bsr   L03F2
         lda   >u0150,u
         anda  #$1F
         ora   #$40
         sta   $07,x
         bsr   L03F2
         lda   #$89
         sta   $03,x
         lda   #$0B
         sta   $03,x
         bsr   L0404
         bsr   L043C
         lda   #$0C
         sta   $03,x
         bsr   L03F2
         lda   #$09
         sta   $03,x
         lda   #$5F
         sta   $07,x
         bsr   L03F2
         lda   #$12
         sta   $03,x
         puls  pc,y,x,b,a
L03F2    pshs  x
         ldx   u0001,u
L03F6    lda   $01,x
         bita  #$01
         bne   L045E
         lda   ,x
         bita  #$10
         beq   L03F6
         puls  pc,x
L0404    pshs  x
L0406    ldx   #$0001
         os9   F$Sleep
         ldx   u0001,u
         lda   $01,x
         bita  #$01
         bne   L045E
         lda   ,x
         bita  #$20
         beq   L0406
         puls  pc,x
L041C    pshs  y,b
         ldy   >u0145,u
         ldb   >u0147,u
L0427    lda   ,y+
         sta   $07,x
L042B    lda   $01,x
         bita  #$01
         bne   L045E
         lda   ,x
         bita  #$10
         beq   L042B
         decb
         bne   L0427
         puls  pc,y,b
L043C    pshs  y,b
         ldy   >u0145,u
         ldb   >u0147,u
         bra   L0455
L0449    lda   $01,x
         bita  #$01
         bne   L045E
         lda   ,x
         bita  #$20
         beq   L0449
L0455    lda   $07,x
         sta   ,y+
         decb
         bne   L0449
         puls  pc,y,b
L045E    ldx   u0001,u
         lda   #$80
         sta   $03,x
         clr   $05,x
         ldx   #$C350
L0469    leax  -$01,x
         bne   L0469
         lda   <u008C
         beq   L0483
         lsla
         rola
         rola
         rola
         adda  #$08
         ldx   u0001,u
         sta   $04,x
         lda   #$93
         sta   $03,x
         lda   #$20
         sta   $01,x
L0483    ldx   >u0159,u
         ldy   >u015B,u
         lds   >u015D,u
         ldd   >u015F,u
         pshs  b,a
         ldd   >u0157,u
         rts
L049C    std   >u0157,u
         stx   >u0159,u
         sty   >u015B,u
         leax  $02,s
         stx   >u015D,u
         ldd   ,s
         std   >u015F,u
         ldd   >u0157,u
         ldx   >u0159,u
         rts
L04BE    pshs  x,b,a
         tst   <u008C
         bne   L04C6
L04C4    puls  pc,x,b,a
L04C6    tst   >u014F,u
         bne   L04C4
         ldx   u0001,u
         clr   $03,x
         lda   $01,x
         bita  #$01
         lbne  L045E
         lda   #$41
         sta   $05,x
L04DC    ldx   #$0001
         os9   F$Sleep
         ldx   u0001,u
         ldb   $01,x
         bitb  #$01
         lbne  L045E
         andb  #$20
         lda   $06,x
         anda  #$7F
         cmpd  #$0920
         bne   L04DC
         lda   #$11
         sta   $03,x
         lda   #$01
         sta   $03,x
         lbsr  L03F2
         lda   #$12
         sta   $03,x
         lda   #$0A
         sta   $03,x
         lda   #$01
         sta   >u014F,u
         puls  pc,x,b,a
L0513    pshs  x,b,a
         tst   <u008C
         beq   L0540
         tst   >u014E,u
         bne   L0540
         ldx   u0001,u
         clr   $05,x
         lda   #$11
         sta   $03,x
         lbsr  L03F2
         lda   #$48
         sta   $07,x
         lbsr  L03F2
         lda   #$09
         sta   $07,x
         lbsr  L03F2
         lda   #$12
         sta   $03,x
         clr   >u014F,u
L0540    puls  pc,x,b,a
L0542    pshs  x
L0544    pshs  cc
         orcc  #$50
         tst   <u008B
         beq   L0556
         puls  cc
         ldx   #$0001
         os9   F$Sleep
         bra   L0544
L0556    inc   <u008B
         puls  cc
         puls  pc,x
L055C    bsr   L05BA
         bita  >u0151,u
         beq   L055C
         leax  ,-s
         ldb   #$01
         lbsr  L03B2
         puls  a
         cmpa  #$01
         bne   L05B8
         leax  >L0698,pcr
         ldb   #$02
         lbsr  L0355
         leax  >u0152,u
         ldb   #$04
         lbsr  L03B2
         ldd   >u0154,u
         cmpd  #$8002
         bne   L0591
         ldb   #$F6
         bra   L05B6
L0591    cmpd  #$903D
         beq   L059D
         cmpd  #$901D
         bne   L05A1
L059D    ldb   #$F2
         bra   L05B6
L05A1    andb  #$F0
         cmpd  #$8010
         beq   L05B8
         tst   >u0156,u
         beq   L05B5
         ldd   >u0154,u
         bsr   L05F1
L05B5    clrb
L05B6    coma
         rts
L05B8    clrb
         rts
L05BA    pshs  x,b
         ldx   u0001,u
         lda   #$11
         sta   $03,x
         lbsr  L03F2
         lda   #$8E
         sta   $03,x
         lda   $06,x
         ldb   #$0E
         stb   $03,x
         ldb   #$12
         stb   $03,x
         puls  pc,x,b
L05D5    lda   <$21,y
         sta   >u0150,u
         lda   <$22,y
         sta   >u0151,u
         bsr   L05BA
         bita  >u0151,u
         bne   L05EF
         comb
         ldb   #$F0
         rts
L05EF    clrb
         rts
L05F1    pshs  b,a
         leay  >u0161,u
         leax  >L069A,pcr
         ldb   ,x+
L05FD    stb   ,y+
         ldb   ,x+
         bpl   L05FD
         lda   >u0150,u
         bsr   L064C
         stb   ,y+
         ldb   ,x+
L060D    stb   ,y+
         ldb   ,x+
         bpl   L060D
         puls  a
         bsr   L064C
         std   ,y++
         puls  a
         bsr   L064C
         std   ,y++
         ldb   #$0D
         stb   ,y
         pshs  u
         ldx   <u0050
         ldy   $04,x
         ldb   $06,x
         leax  >u0161,u
         leau  <-$20,y
         lda   <u00D0
         ldy   #$0020
         os9   F$Move
         ldx   <u0050
         lda   <$32,x
         leax  ,u
         ldy   #$0020
         os9   I$WritLn
         puls  pc,u
L064C    tfr   a,b
         lsra
         lsra
         lsra
         lsra
         andb  #$0F
         addd  #$3030
         cmpa  #$39
         ble   L065D
         adda  #$07
L065D    cmpb  #$39
         ble   L0663
         addb  #$07
L0663    rts
L0664    pshs  y,x,b,a
         ldd   #$0018
         stb   $04,s
         clrb
L066C    lsl   $03,s
         rol   $02,s
         rol   $01,s
         rolb
         subb  ,s
         bmi   L067B
         inc   $03,s
         bra   L067D
L067B    addb  ,s
L067D    dec   $04,s
         bne   L066C
         tfr   b,a
         ldx   $02,s
         ldb   $01,s
         leas  $06,s
         rts

L068A    fcb $05,$00,$00,$01
L068E    fcb $08,$00,$00,$01
L0692    fcb $02,$00,$00,$00,$00,$00
L0698    fcb $03,$00

L069A    fcc "Drive "
         fcb $FF
         fcc ": Controller Error #"
         fcb $FF
         emod
eom      equ   *
