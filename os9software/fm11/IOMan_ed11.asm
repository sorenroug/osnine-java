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

IOName     equ   *
         fcs   /IOMan/
         fcb   11

IOINIT    equ   *
         ldx   D.Init
         lda   $0C,x
         ldb   #$09
         mul
         pshs  b,a
         lda   $0D,x
         ldb   #$09
         mul
         addd  ,s
         addd  #$00FF
         clrb
         os9   F$SRqMem
         bcs   L0056
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
         bcs   L0056
         stx   D.PthDBT
         os9   F$Ret64
         leax  >L0681,pcr
         stx   D.Poll
         leay  <L005A,pcr
         os9   F$SSvc
         rts
L0056    jmp   [>$FFFE]

L005A   fcb $7F,$00,$8B,$01,$06,$43,$81,$06,$6D,$0F,$08,$1F,$AB,$08,$64,$FF
        fcb $00,$81,$AA,$05,$90,$B3,$00,$01,$80,$AE,$44,$DE,$24,$E6,$4D,$DE,$80

L007B    ldy   $04,u
         beq   L008C
         cmpx  $04,u
         beq   L0093
         cmpx  ,u
         beq   L0093
         cmpx  $06,u
         beq   L0093
L008C    leau  $09,u
         decb
         bne   L007B
         clrb
         rts

L0093    comb
         ldb   #$D1
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

L00A4 fcb $00,$5F,$01,$DF,$02,$AD,$02,$E4,$02,$E4,$03,$0D,$03,$2A,$03,$60
  fcb $04,$04,$04,$12,$04,$6B,$04,$12,$04,$6B,$04,$86,$04,$04,$04,$D7,$03,$66

L00C6 fcb $00,$3D,$01,$BD,$02,$A2,$02,$D5,$02,$D5,$02,$EB,$03,$08,$03,$3E
  fcb $03,$E7,$03,$F5,$04,$4E,$03,$F5,$04,$4E,$04,$6C,$03,$E7,$04,$C4,$03,$44

UsrIO    leax  <L00A4,pcr
         bra   L00F0
         leax  <L00C6,pcr
L00F0    cmpb  #$90
         bhi   L00FF
         pshs  b
         lslb
         ldd   b,x
         leax  d,x
         puls  b
         jmp   ,x
L00FF    comb
         ldb   #$D0
         rts
         ldb   #$17
L0105    clr   ,-s
         decb
         bpl   L0105
         stu   <$16,s
         lda   $01,u
         sta   $09,s
         ldx   D.Proc
         stx   <$14,s
         leay  <$40,x
         ldx   D.SysPRC
         stx   D.Proc
         ldx   $04,u
         lda   #$F0
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
         lda   #$E0
         os9   F$Link
         bcs   L014E
         stu   ,s
         ldu   $04,s
         ldd   $09,u
         leax  d,u
         lda   #$D0
         os9   F$Link
L014E    ldx   <$14,s
         stx   D.Proc
         bcc   L0163
L0155    stb   <$17,s
         leau  ,s
         os9   I$Detach
         leas  <$17,s
         comb
         puls  pc,b

L0163    stu   $06,s
         ldx   D.Init
         ldb   $0D,x
         lda   $0D,x
         ldu   D.DevTbl
L016D    ldx   $04,u
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
L0188    ldx   $04,u
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
L01AA    leau  $09,u
         decb
         bne   L016D
         ldu   $0E,s
         lbne  L0261
         ldu   D.DevTbl
L01B7    ldx   $04,u
         beq   L01C8
         leau  $09,u
         deca
         bne   L01B7
         ldb   #$CC
         bra   L0155
L01C4    ldb   #$CB
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
         ldy   #$F000
         ldd   $0B,s
         lbsr  L0097
         beq   L0238
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
         lda   $0C,x
         ora   #$10
         sta   $0C,x
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
         ldu   $08,u
         ldx   $04,u
         lda   #$FF
         cmpa  $08,u
         lbeq  L034C
         dec   $08,u
         lbne  L032E
         ldx   D.Init
         ldb   $0D,x
         pshs  u,b
         ldx   $02,u
         clr   $02,u
         clr   $03,u
         ldy   D.DevTbl
L02A4    cmpx  $02,y
         beq   L0324
         leay  $09,y
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
         bsr   L0372
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
         lda   $01,u
L036A    lbsr  L051C
         bcs   L0371
         inc   $02,y
L0371    rts
L0372    ldx   D.Proc
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
         bsr   L0372
         bcs   L039A
         pshs  u,x,a
         bsr   L039B
         puls  u,x,a
         bcs   L039A
         ldb   $01,u
         stb   a,x
         sta   $01,u
L039A    rts
L039B    pshs  b
         ldb   $01,u
         bsr   L0412
         bcs   L03AF
         puls  b
         lbsr  L05B4
         bcs   L03BE
         lda   ,y
         sta   $01,u
         rts
L03AF    puls  pc,a
         pshs  b
         ldb   #$82
L03B5    bsr   L0412
         bcs   L03AF
         puls  b
         lbsr  L05B4
L03BE    pshs  b,cc
         ldu   $03,y
         os9   I$Detach
         lda   ,y
         ldx   D.PthDBT
         os9   F$Ret64
         puls  pc,b,cc
         pshs  b
         ldb   $01,u
         orb   #$80
         bsr   L0412
         bcs   L03AF
         puls  b
         lbsr  L05B4
         bcs   L03BE
         ldu   D.Proc
         ldb   $01,y
         bitb  #$1B
         beq   L03F2
         ldx   $03,y
         stx   <$20,u
         inc   $08,x
         bne   L03F2
         dec   $08,x
L03F2    bitb  #$24
         beq   L0401
         ldx   $03,y
         stx   <$26,u
         inc   $08,x
         bne   L0401
         dec   $08,x
L0401    clrb
         bra   L03BE
         pshs  b
         ldb   #$02
         bra   L03B5
         ldb   #$87
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
L0483    ldb   #$D7
L0485    pshs  b
         lda   ,y
         ldx   D.PthDBT
         os9   F$Ret64
         puls  b
         coma
         bra   L047E
L0493    lda   $01,u
         cmpa  #$10
         bcc   L04A4
         ldx   D.Proc
         leax  <$30,x
         andcc #$FE
         lda   a,x
         bne   L04A7
L04A4    comb
         ldb   #$C9
L04A7    rts
         bsr   L0493
         bcc   L04AF
         rts
         lda   $01,u
L04AF    bsr   L051C
         lbcc  L05B4
         rts
         bsr   L0493
         bcc   L04BD
         rts
         lda   $01,u
L04BD    pshs  b
         ldb   #$05
L04C1    bsr   L051C
         bcs   L050C
         bitb  $01,y
         beq   L050A
         ldd   $06,u
         beq   L04F9
         addd  $04,u
         bcs   L04FE
         subd  #$0001
         lsra
         lsra
         lsra
         lsra
         ldb   $04,u
         lsrb
         lsrb
         lsrb
         lsrb
         pshs  b
         suba  ,s+
         ldx   D.Proc
         leax  <$40,x
         lslb
         leax  b,x
L04EA    pshs  a
         ldd   ,x++
         cmpd  #$00FE
         puls  a
         beq   L04FE
         deca
         bpl   L04EA
L04F9    puls  b
         lbra  L05B4
L04FE    ldb   #$F4
         lda   ,s
         bita  #$02
         beq   L050C
         ldb   #$F5
         bra   L050C
L050A    ldb   #$C9
L050C    com   ,s+
         rts
         bsr   L0493
         bcc   L0516
         rts
         lda   $01,u
L0516    pshs  b
         ldb   #$02
         bra   L04C1
L051C    pshs  x
         ldx   D.PthDBT
         os9   F$Find64
         puls  x
         lbcs  L04A4
L0529    rts
         lbsr  L0493
         ldx   D.Proc
         bcc   L0536
         rts
         lda   $01,u
         ldx   D.SysPRC
L0536    pshs  x,b,a
         lda   $02,u
         sta   $01,s
         puls  a
         lbsr  L04AF
         puls  x,a
         pshs  u,y,b,cc
         ldb   <$20,y
         cmpb  #$03
         beq   L0553
         tsta
         beq   L0555
         cmpa  #$0E
         beq   L0569
L0553    puls  pc,u,y,b,cc
L0555    lda   D.SysTsk
         ldb   $06,x
         leax  <$20,y
L055C    ldy   #$0020
         ldu   $04,u
         os9   F$Move
         leas  $01,s
         puls  pc,u,y,b
L0569    lda   D.SysTsk
         ldb   $06,x
         pshs  b,a
         ldx   $03,y
         ldx   $04,x
         ldd   $04,x
         leax  d,x
         puls  b,a
         bra   L055C
         lbsr  L0493
         bcs   L0529
         pshs  b
         ldb   $01,u
         clr   b,x
         puls  b
         bra   L058C
         lda   $01,u
L058C    bsr   L051C
         bcs   L0529
         dec   $02,y
         tst   $05,y
         bne   L0598
         bsr   L05B4
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
L05B4    pshs  u,y,x,b
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
L05EB    clr   <$10,y
         ldb   #$01
         os9   F$Send
         os9   F$GProcP
         clr   $0F,y
L05F8    lda   <$10,y
         bne   L05EB
         puls  pc,y,x
         ldx   $04,u
         ldb   ,x
         ldx   $01,x
         clra
         pshs  cc
         pshs  x,b
         ldx   D.Init
         ldb   $0C,x
         ldx   D.PolTbl
         ldy   $04,u
         beq   L0650
         tst   $01,s
         beq   L067B
         decb
         lda   #$09
         mul
         leax  d,x
         lda   $03,x
         bne   L067B
         orcc  #$50
L0625    ldb   $02,s
         cmpb  -$01,x
         bcs   L0638
         ldb   #$09
L062D    lda   ,-x
         sta   $09,x
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
         leax  $09,x
         decb
         bne   L0655
         clrb
         rts
L0661    pshs  b,cc
         orcc  #$50
         bra   L066E
L0667    ldb   $09,x
         stb   ,x+
         deca
         bne   L0667
L066E    lda   #$09
         dec   $01,s
         bne   L0667
L0674    clr   ,x+
         deca
         bne   L0674
         puls  pc,a,cc
L067B    leas  $04,s
L067D    comb
         ldb   #$CA
         rts
L0681    ldy   D.PolTbl
         ldx   D.Init
         ldb   $0C,x
         bra   L068F
L068A    leay  $09,y
         decb
         beq   L067D
L068F    lda   [,y]
         eora  $02,y
         bita  $03,y
         beq   L068A
         ldu   $06,y
         pshs  y,b
         jsr   [<$04,y]
         puls  y,b
         bcs   L068A
         rts
         pshs  u
         ldx   $04,u
         bsr   L06EA
         bcs   L06CE
         puls  y
L06AD    pshs  y
         stx   $04,y
         ldy   ,u
         ldx   $04,u
         ldd   #$0006
         os9   F$LDDDXY
         ldx   ,s
         std   $01,x
         leax  ,u
         os9   F$ELink
         bcs   L06CE
         ldx   ,s
         sty   $06,x
         stu   $08,x
L06CE    puls  pc,u
         pshs  u
         ldx   $04,u
         bsr   L06EA
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
L06EA    os9   F$AllPrc
         bcc   L06F0
         rts
L06F0    leay  ,u
         ldu   #$0000
         pshs  u,y,x,b,a
         leas  <-$11,s
         clr   $07,s
         stu   ,s
         stu   $02,s
         ldu   D.Proc
         stu   $04,s
         clr   $06,s
         lda   $0A,u
         sta   $0A,y
         lda   #$04
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
         lda   $06,u
         ldb   D.SysTsk
         leau  $08,s
         pshs  x
         ldx   $04,s
         os9   F$Move
         puls  x
         ldd   ,u
         cmpd  #$87CD
         bne   L0786
         ldd   $02,u
         subd  #$0009
         lbsr  L080D
         bcs   L0788
         ldy   <$15,s
         leay  <$40,y
         tfr   y,d
         ldx   $02,s
         os9   F$VModul
         bcc   L0764
         cmpb  #$E7
         beq   L076A
         bra   L0788
L0764    ldd   $02,s
         addd  $0A,s
         std   $02,s
L076A    ldd   <$17,s
         bne   L0720
         ldd   $04,u
         std   <$11,s
         ldx   ,u
         ldd   ,x
         std   <$17,s
         ldd   $06,u
         addd  #$0001
         beq   L0720
         std   $06,u
         bra   L0720
L0786    ldb   #$CD
L0788    stb   $07,s
         ldd   $04,s
         beq   L0790
         std   D.Proc
L0790    lda   $06,s
         beq   L0797
         os9   I$Close
L0797    ldd   $02,s
         addd  #$0FFF
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
         leax  <$40,x
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
         lda   ,x
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
         leau  -$08,u
L07E3    leau  $08,u
         cmpu  D.ModEnd
         bcs   L07F2
         comb
         ldb   #$DD
         stb   <$12,s
         bra   L0808
L07F2    cmpx  $04,u
         bne   L07E3
         cmpd  [,u]
         bne   L07E3
         ldd   $06,u
         beq   L0804
         subd  #$0001
         std   $06,u
L0804    stu   <$17,s
         clrb
L0808    leas  <$11,s
         puls  pc,u,y,x,b,a
L080D    pshs  y,x,b,a
         addd  $02,s
         std   $04,s
         cmpd  $08,s
         bls   L086C
         addd  #$0FFF
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
         leau  <$40,u
         leau  a,u
         clra
         tfr   d,x
         ldy   D.BlkMap
         clra
         clrb
L0840    tst   ,y+
         beq   L0851
L0844    addd  #$0001
         cmpy  D.BlkMap+2
         bne   L0840
L084C    comb
         ldb   #$CF
         bra   L0876
L0851    inc   -$01,y
         std   ,u++
         pshs  b,a
         ldd   $0A,s
         addd  #$1000
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

L087A   fcc "ERROR #"

         ble   L08BD
         leax  $0D,x
         ldx   D.Proc
         lda   <$32,x
         beq   L08CC
         leas  -$0B,s
         leax  <L087A,pcr
         leay  ,s
L0893    lda   ,x+
         sta   ,y+
         cmpa  #$0D
         bne   L0893
         ldb   $02,u
L089D    inc   $07,s
         subb  #$64
         bcc   L089D
L08A3    dec   $08,s
         addb  #$0A
         bcc   L08A3
         addb  #$30
         stb   $09,s
         ldx   D.Proc
         ldu   $04,x
         leau  -$0B,u
         lda   D.SysTsk
         ldb   $06,x
         leax  ,s
         ldy   #$000B
L08BD    os9   F$Move
         leax  ,u
         ldu   D.Proc
         lda   <$32,u
         os9   I$WritLn
         leas  $0B,s
L08CC    rts

FIOQu    ldy   D.Proc
L08D0    lda   <$10,y
         beq   L08EF
         cmpa  $01,u
         bne   L08EA
         clr   <$10,y
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
L08F6    lda   <$10,y
         bne   L08F1
         ldx   D.Proc
         lda   ,x
         sta   <$10,y
         lda   ,y
         sta   $0F,x
         ldx   #$0000
         os9   F$Sleep
         ldu   D.Proc
         lda   $0F,u
         beq   L0930
         os9   F$GProcP
         bcs   L0930
         lda   <$10,y
         beq   L0930
         lda   <$10,u
         sta   <$10,y
         beq   L0930
         clr   <$10,u
         os9   F$GProcP
         bcs   L0930
         lda   $0F,u
         sta   $0F,y
L0930    clr   $0F,u
L0932    rts
         emod
IOEnd      equ   *
