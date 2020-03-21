         nam   OS9p2
         ttl   os9 system module

         ifp1
         use   defsfile
         endc
************************************************************
*
*     Module Header
*
Type set Systm
Revs set ReEnt+2

         mod   OS9End,OS9Name,Type,Revs,start,size
u0000    rmb   1
u0001    rmb   1
u0002    rmb   2
u0004    rmb   1
u0005    rmb   1
u0006    rmb   1
u0007    rmb   1
u0008    rmb   1
u0009    rmb   1
u000A    rmb   1
u000B    rmb   1
u000C    rmb   1
u000D    rmb   1
u000E    rmb   1
u000F    rmb   1
u0010    rmb   2
u0012    rmb   4
u0016    rmb   2
u0018    rmb   1
u0019    rmb   7
u0020    rmb   2
u0022    rmb   2
u0024    rmb   2
u0026    rmb   26
u0040    rmb   2
u0042    rmb   1
u0043    rmb   1
u0044    rmb   2
u0046    rmb   2
u0048    rmb   2
u004A    rmb   2
u004C    rmb   2
u004E    rmb   1
u004F    rmb   1
u0050    rmb   4
u0054    rmb   4
u0058    rmb   1
u0059    rmb   1
u005A    rmb   25
u0073    rmb   23
u008A    rmb   14
u0098    rmb   1
u0099    rmb   7
u00A0    rmb   15
u00AF    rmb   13
u00BC    rmb   16
u00CC    rmb   4
u00D0    rmb   14
u00DE    rmb   15
u00ED    rmb   10
u00F7    rmb   9
size     equ   .
OS9Name     equ   *
         fcs   /OS9p2/
         fcb   13
start    equ   *
         leay  >SVCTBL,pcr
         os9   F$SSvc
         ldu   <u0024
         ldd   u0009,u
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         addd  <u0040
         tfr   d,x
         ldb   #$80
         bra   L0034
L002E    lda   ,x+
         bne   L0034
         stb   -$01,x
L0034    cmpx  <u0042
         bcs   L002E
L0038    ldu   <u0024
         ldy   <u004A
         leay  >$00A0,y
         lda   #$0D
         sta   ,y
         ldd   <u0016,u
         beq   L0057
         leax  d,u
         ldb   #$20
L004E    lda   ,x+
         sta   ,y+
         bmi   L0057
         decb
         bne   L004E
L0057    ldb   #$06
L0059    clr   ,-s
         decb
         bne   L0059
         leax  ,s
         os9   F$STime
         leas  $06,s
         ldd   <u0010,u
         beq   L0078
         leax  d,u
         lda   #$05
         os9   I$ChgDir
         bcc   L0078
         os9   F$Boot
         bcc   L0038
L0078    ldu   <u0024
         ldd   <u0012,u
         beq   L00A0
         leax  d,u
         lda   #$03
         os9   I$Open
         bcc   L008F
         os9   F$Boot
         bcc   L0078
         bra   L00A0
L008F    ldx   <u0050
         sta   <$30,x
         os9   I$Dup
         sta   <$31,x
         os9   I$Dup
         sta   <$32,x
L00A0    leax  <L00BF,pcr
         lda   #$C0
         os9   F$Link
         bcs   L00AC
         jsr   ,y
L00AC    ldu   <u0024
         ldd   u000E,u
         leax  d,u
         lda   #$01
         clrb
         ldy   #$0000
         os9   F$Fork
         os9   F$NProc

L00BF    fcs "OS9p3"

SVCTBL equ *
 fcb F$Unlink
 fcb  $00,$99,$03,$01,$89,$04,$02,$8E,$05,$02,$EA
 fcb  $06,$04,$73,$07,$05,$0A,$08,$05,$66,$09,$06,$19
 fcb  $0A,$06,$24,$0D,$06,$BC,$0C,$06,$D5,$0E,$06,$DE
 fcb  $16,$06,$F6,$12,$07,$ED,$92,$07,$F7,$13,$07,$1C
 fcb  $93,$07,$26,$14,$07,$8A,$94,$07,$94,$18,$08,$43
 fcb  $19,$08,$59,$1A,$08,$71,$1B,$08,$98,$1C,$08,$8D
 fcb  $1D,$08,$F7,$AF,$09,$40,$B0,$09,$60,$B1,$09,$DE
 fcb  $B7,$0A,$0B,$BB,$0A,$2A,$CB,$01,$CC,$CC,$02,$33
 fcb  $4F,$0A,$4F,$50,$0A,$AF,$51,$0B,$02,$D2,$0B,$27,$7F,$00,$06
 fcb  $80

IOSTR    fcs "IOMan"

IOHOOK pshs D,X,Y,U Save registers
         bsr IOLink
         bcc   IOHOOK10
         os9   F$Boot
         bcs   L0152
         bsr   IOLink
         bcs   L0152
IOHOOK10    jsr   ,y
         puls  u,y,x,b,a
         ldx   >$00FE,y
         jmp   ,x
L0152    stb   $01,s
         puls  pc,u,y,x,b,a

IOLink    leax  >IOSTR,pcr
         lda   #$C1
         os9   F$Link
         rts

         pshs  u,b,a
         ldd   u0008,u
         ldx   u0008,u
         lsra
         lsra
         lsra
         lsra
         sta   ,s
         beq   L01A8
         ldu   <u0050
         leay  <u0040,u
         lsla
         ldd   a,y
         ldu   <u0040
         ldb   d,u
         bitb  #$02
         beq   L01A8
         leau  <$40,y
         bra   L0187
L0183    dec   ,s
         beq   L01A8
L0187    ldb   ,s
         lslb
         ldd   b,u
         beq   L0183
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
         ldu   <u0044
         bra   L01AA
L01A1    leau  u0008,u
         cmpu  <u0058
         bcs   L01AA
L01A8    bra   L01F5
L01AA    cmpx  u0004,u
         bne   L01A1
         cmpd  [,u]
         bne   L01A1
         ldx   u0006,u
         beq   L01BD
         leax  -$01,x
         stx   u0006,u
         bne   L01DA
L01BD    ldx   $02,s
         ldx   $08,x
         ldd   #$0006
         os9   F$LDDDXY
         cmpa  #$D0
         bcs   L01D8
         os9   F$IODel
         bcc   L01D8
         ldx   u0006,u
         leax  $01,x
         stx   u0006,u
         bra   L01F6
L01D8    bsr   L01FA
L01DA    ldb   ,s
         lslb
         leay  b,y
         ldx   <$40,y
         leax  -$01,x
         stx   <$40,y
         bne   L01F5
         ldd   u0002,u
         bsr   L024B
         ldx   #$00C0
L01F0    stx   ,y++
         deca
         bne   L01F0
L01F5    clrb
L01F6    leas  $02,s
         puls  pc,u
L01FA    ldx   <u0040
         ldd   [,u]
         lda   d,x
         bmi   L024A
         ldx   <u0044
L0204    ldd   [,x]
         cmpd  [,u]
         bne   L020F
         ldd   $06,x
         bne   L024A
L020F    leax  $08,x
         cmpx  <u0058
         bcs   L0204
         ldx   <u0040
         ldd   u0002,u
         bsr   L024B
         pshs  y
         ldy   ,u
L0220    pshs  x,a
         ldd   ,y
         clr   ,y+
         clr   ,y+
         leax  d,x
         ldb   ,x
         andb  #$FC
         stb   ,x
         puls  x,a
         deca
         bne   L0220
         puls  y
         ldx   <u0044
         ldd   ,u
L023B    cmpd  ,x
         bne   L0244
         clr   ,x
         clr   $01,x
L0244    leax  $08,x
         cmpx  <u0058
         bcs   L023B
L024A    rts
L024B    addd  #$0FFF
         lsra
         lsra
         lsra
         lsra
         rts
         pshs  u
         lbsr  L02F9
         bcc   L025C
         puls  pc,u
L025C    pshs  u
         ldx   <u0050
         ldd   $08,x
         std   u0008,u
         lda   $0A,x
         sta   u000A,u
         leax  <$20,x
         leau  <u0020,u
         ldb   #$10
L0270    lda   ,x+
         sta   ,u+
         decb
         bne   L0270
         ldy   #$0003
L027B    lda   ,x+
         beq   L0285
         os9   I$Dup
         bcc   L0285
         clra
L0285    sta   ,u+
         leay  -$01,y
         bne   L027B
         ldx   ,s
         ldu   $02,s
         lbsr  L04B3
         bcs   L02DE
         pshs  b,a
         os9   F$AllTsk
         bcc   L029B
L029B    lda   $07,x
         clrb
         subd  ,s
         tfr   d,u
         ldb   $06,x
         ldx   <u0050
         lda   $06,x
         leax  ,y
         puls  y
         os9   F$Move
         ldx   ,s
         lda   <u00D0
         ldu   $04,x
         leax  >$01F4,x
         ldy   #$000C
         os9   F$Move
         puls  u,x
         os9   F$DelTsk
         ldy   <u0050
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
L02DE    puls  x
         pshs  b
         lbsr  L05A7
         lda   ,x
         lbsr  L039D
         comb
         puls  pc,u,b
         pshs  u
         bsr   L02F9
         bcs   L02F7
         ldx   ,s
         stu   $08,x
L02F7    puls  pc,u
L02F9    ldx   <u0048
L02FB    lda   ,x+
         bne   L02FB
         leax  -$01,x
         tfr   x,d
         subd  <u0048
         tsta
         beq   L030D
         comb
         ldb   #$E5
         bra   L0356
L030D    pshs  b
         ldd   #$0200
         os9   F$SRqMem
         puls  a
         bcs   L0356
         sta   ,u
         tfr   u,d
         sta   ,x
         clra
         leax  u0001,u
         ldy   #$0080
L0326    std   ,x++
         leay  -$01,y
         bne   L0326
         lda   #$80
         sta   u000C,u
         ldb   #$0F
         ldx   #$00C0
         leay  <u0040,u
L0338    stx   ,y++
         decb
         bne   L0338
         ldx   #$00FF
         stx   ,y++
         leay  >u00A0,u
         ldx   <u0050
         leax  >$00A0,x
         ldb   #$20
L034E    lda   ,x+
         sta   ,y+
         decb
         bne   L034E
         clrb
L0356    rts
         lda   u0001,u
         bra   L039D
         ldx   <u0050
         lda   $03,x
         beq   L037F
L0361    lbsr  L0B30
         lda   $0C,y
         bita  #$01
         bne   L0383
         lda   $02,y
         bne   L0361
         sta   u0001,u
         pshs  cc
         orcc  #$50
         ldd   <u0054
         std   $0D,x
         stx   <u0054
         puls  cc
         lbra  L0779
L037F    comb
         ldb   #$E2
         rts
L0383    lda   ,y
         ldb   <$19,y
         std   u0001,u
         leau  ,y
         leay  $01,x
         bra   L0393
L0390    lbsr  L0B30
L0393    lda   $02,y
         cmpa  ,u
         bne   L0390
         ldb   u0002,u
         stb   $02,y
L039D    pshs  u,x,b,a
         ldb   ,s
         ldx   <u0048
         abx
         lda   ,x
         beq   L03B8
         clrb
         stb   ,x
         tfr   d,x
         os9   F$DelTsk
         leau  ,x
         ldd   #$0200
         os9   F$SRtMem
L03B8    puls  pc,u,x,b,a
         pshs  u
         lbsr  L02F9
         bcc   L03C3
         puls  pc,u
L03C3    ldx   <u0050
         pshs  u,x
         leax  $04,x
         leau  u0004,u
         ldy   #$007E
L03CF    ldd   ,x++
         std   ,u++
         leay  -$01,y
         bne   L03CF
         ldx   <u0050
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
         lda   #$0F
         pshs  b
         suba  ,s+
         leay  <$40,x
         lslb
         leay  b,y
         ldu   #$00C0
L0409    stu   ,y++
         deca
         bne   L0409
         ldu   #$00FF
         stu   ,y++
         ldu   $02,s
         stu   <u0050
         ldu   $04,s
         lbsr  L04B3
         lbcs  L04A3
         pshs  b,a
         os9   F$AllTsk
         bcc   L0427
L0427    ldu   <u0050
         lda   u0006,u
         ldb   $06,x
         leau  >$01F4,x
         leax  ,y
         ldu   u0004,u
         pshs  u
         cmpx  ,s++
         puls  y
         bhi   L0473
         beq   L0476
         leay  ,y
         beq   L0476
         pshs  x,b,a
         tfr   y,d
         leax  d,x
         pshs  u
         cmpx  ,s++
         puls  x,b,a
         bls   L0473
         pshs  u,y,x,b,a
         tfr   y,d
         leax  d,x
         leau  d,u
L0459    ldb   ,s
         leax  -$01,x
         os9   F$LDABX
         exg   x,u
         ldb   $01,s
         leax  -$01,x
         os9   F$STABX
         exg   x,u
         leay  -$01,y
         bne   L0459
         puls  u,y,x,b,a
         bra   L0476
L0473    os9   F$Move
L0476    lda   <u00D0
         ldx   ,s
         ldu   $04,x
         leax  >$01F4,x
         ldy   #$000C
         os9   F$Move
         puls  u,x
         lda   ,u
         lbsr  L039D
         os9   F$DelTsk
         orcc  #$50
         ldd   <u004A
         std   <u0050
         lda   $0C,x
         anda  #$7F
         sta   $0C,x
         os9   F$AProc
         os9   F$NProc
L04A3    puls  u,x
         stx   <u0050
         pshs  b
         lda   ,u
         lbsr  L039D
         puls  b
         os9   F$Exit
L04B3    pshs  u,y,x,b,a
         ldd   <u0050
         pshs  b,a
         stx   <u0050
         lda   u0001,u
         ldx   u0004,u
         ldy   ,s
         leay  <$40,y
         os9   F$SLink
         bcc   L04D9
         ldd   ,s
         std   <u0050
         ldu   $04,s
         os9   F$Load
         bcc   L04D9
         leas  $04,s
         puls  pc,u,y,x
L04D9    stu   $02,s
         pshs  y,a
         ldu   $0B,s
         stx   u0004,u
         ldx   $07,s
         stx   <u0050
         ldd   $05,s
         std   <$11,x
         puls  a
         cmpa  #$11
         beq   L04FD
         cmpa  #$C1
         beq   L04FD
         ldb   #$EA
L04F6    leas  $02,s
         stb   $03,s
         comb
         bra   L0540
L04FD    ldd   #$000B
         leay  <$40,x
         ldx   <$11,x
         os9   F$LDDDXY
         cmpa  u0002,u
         bcc   L0510
         lda   u0002,u
         clrb
L0510    os9   F$Mem
         bcs   L04F6
         ldx   $06,s
         leay  >$01F4,x
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
L0540    puls  b,a
         std   <u0050
         puls  pc,u,y,x,b,a
         ldx   <u0050
         bsr   L05A7
         ldb   u0002,u
         stb   <$19,x
         leay  $01,x
         bra   L0565
L0553    clr   $02,y
         lbsr  L0B30
         clr   $01,y
         lda   $0C,y
         bita  #$01
         beq   L0565
         lda   ,y
         lbsr  L039D
L0565    lda   $02,y
         bne   L0553
         leay  ,x
         ldx   #$0047
         lds   <u00CC
         pshs  cc
         orcc  #$50
         lda   $01,y
         bne   L0586
         puls  cc
         lda   ,y
         lbsr  L039D
         bra   L05A4
L0582    cmpa  ,x
         beq   L0594
L0586    leau  ,x
         ldx   $0D,x
         bne   L0582
         puls  cc
         lda   #$81
         sta   $0C,y
         bra   L05A4
L0594    ldd   $0D,x
         std   u000D,u
         puls  cc
         ldu   $04,x
         ldu   u0008,u
         lbsr  L0383
         os9   F$AProc
L05A4    os9   F$NProc
L05A7    pshs  u
         ldb   #$10
         leay  <$30,x
L05AE    lda   ,y+
         beq   L05BB
         clr   -$01,y
         pshs  b
         os9   I$Close
         puls  b
L05BB    decb
         bne   L05AE
         clra
         ldb   $07,x
         beq   L05CC
         addb  #$0F
         lsrb
         lsrb
         lsrb
         lsrb
         os9   F$DelImg
L05CC    ldd   <u0050
         pshs  b,a
         stx   <u0050
         ldu   <$11,x
         os9   F$UnLink
         puls  u,b,a
         std   <u0050
         os9   F$DelTsk
         rts
         ldx   <u0050
         ldd   u0001,u
         beq   L0637
         addd  #$00FF
         bcc   L05EF
         ldb   #$CF
         bra   L0628
L05EF    cmpa  $07,x
         beq   L0637
         pshs  a
         bcc   L0603
         deca
         ldb   #$F4
         cmpd  $04,x
         bcc   L0603
         ldb   #$DF
         bra   L0626
L0603    lda   $07,x
         adda  #$0F
         lsra
         lsra
         lsra
         lsra
         ldb   ,s
         addb  #$0F
         bcc   L0615
         ldb   #$CF
         bra   L0626
L0615    lsrb
         lsrb
         lsrb
         lsrb
         pshs  a
         subb  ,s+
         beq   L0633
         bcs   L062B
         os9   F$AllImg
         bcc   L0633
L0626    leas  $01,s
L0628    orcc  #$01
         rts
L062B    pshs  b
         adda  ,s+
         negb
         os9   F$DelImg
L0633    puls  a
         sta   $07,x
L0637    lda   $07,x
         clrb
         std   u0001,u
         std   u0006,u
         rts
         ldx   <u0050
         lda   u0001,u
         bne   L0651
         inca
L0646    cmpa  ,x
         beq   L064C
         bsr   L0651
L064C    inca
         bne   L0646
         clrb
         rts
L0651    lbsr  L0B30
         pshs  u,y,a,cc
         bcs   L0669
         tst   u0002,u
         bne   L066C
         ldd   $08,x
         beq   L066C
         cmpd  $08,y
         beq   L066C
         ldb   #$E0
         inc   ,s
L0669    lbra  L06F3
L066C    orcc  #$50
         ldb   u0002,u
         bne   L067A
         ldb   #$E4
         lda   $0C,y
         ora   #$02
         sta   $0C,y
L067A    lda   $0C,y
         anda  #$F7
         sta   $0C,y
         lda   <$19,y
         beq   L068E
         deca
         beq   L068E
         inc   ,s
         ldb   #$E9
         bra   L06F3
L068E    stb   <$19,y
         ldx   #$0049
         clra
         clrb
L0696    leay  ,x
         ldx   $0D,x
         beq   L06D2
         ldu   $04,x
         addd  u0004,u
         cmpx  $02,s
         bne   L0696
         pshs  b,a
         lda   $0C,x
         bita  #$40
         beq   L06CE
         ldd   ,s
         beq   L06CE
         ldd   u0004,u
         pshs  b,a
         ldd   $02,s
         std   u0004,u
         puls  b,a
         ldu   $0D,x
         beq   L06CE
         std   ,s
         lda   u000C,u
         bita  #$40
         beq   L06CE
         ldu   u0004,u
         ldd   ,s
         addd  u0004,u
         std   u0004,u
L06CE    leas  $02,s
         bra   L06DF
L06D2    ldx   #$0047
L06D5    leay  ,x
         ldx   $0D,x
         beq   L06F3
         cmpx  $02,s
         bne   L06D5
L06DF    ldd   $0D,x
         std   $0D,y
         lda   <$19,x
         deca
         bne   L06F0
         sta   <$19,x
         lda   ,s
         tfr   a,cc
L06F0    os9   F$AProc
L06F3    puls  pc,u,y,a,cc
         ldx   <u0050
         ldd   u0004,u
         std   <$1A,x
         ldd   u0008,u
         std   <$1C,x
         clrb
         rts
         pshs  cc
         ldx   <u0050
         orcc  #$50
         lda   <$19,x
         beq   L071B
         deca
         bne   L0714
         sta   <$19,x
L0714    puls  cc
         os9   F$AProc
         bra   L0779
L071B    ldd   u0004,u
         beq   L0766
         subd  #$0001
         std   u0004,u
         beq   L0714
         pshs  y,x
         ldx   #$0049
L072B    std   u0004,u
         stx   $02,s
         ldx   $0D,x
         beq   L0748
         lda   $0C,x
         bita  #$40
         beq   L0748
         ldy   $04,x
         ldd   u0004,u
         subd  $04,y
         bcc   L072B
         nega
         negb
         sbca  #$00
         std   $04,y
L0748    puls  y,x
         lda   $0C,x
         ora   #$40
         sta   $0C,x
         ldd   $0D,y
         stx   $0D,y
         std   $0D,x
         ldx   u0004,u
         bsr   L0779
         stx   u0004,u
         ldx   <u0050
         lda   $0C,x
         anda  #$BF
         sta   $0C,x
         puls  pc,cc
L0766    ldx   #$0049
L0769    leay  ,x
         ldx   $0D,x
         bne   L0769
         ldx   <u0050
         clra
         clrb
         stx   $0D,y
         std   $0D,x
         puls  cc
L0779    pshs  pc,u,y,x
         leax  <L0795,pcr
         stx   $06,s
         ldx   <u0050
         ldb   $06,x
         cmpb  <u00D0
         beq   L078B
         os9   F$DelTsk
L078B    ldd   $04,x
         pshs  dp,b,a,cc
         sts   $04,x
         os9   F$NProc
L0795    pshs  x
         ldx   <u0050
         std   $04,x
         clrb
         puls  pc,x
         lda   u0001,u
         lbsr  L0B30
         bcs   L07B9
         ldx   <u0050
         ldd   $08,x
         beq   L07B0
         cmpd  $08,y
         bne   L07B6
L07B0    lda   u0002,u
         sta   $0A,y
         clrb
         rts
L07B6    comb
         ldb   #$E0
L07B9    rts
         ldx   <u0050
         lda   ,x
         sta   u0001,u
         ldd   $08,x
         std   u0006,u
         clrb
         rts
         ldx   <u0050
         leay  <$13,x
         ldb   u0001,u
         decb
         cmpb  #$03
         bcc   L07D8
         lslb
         ldx   u0004,u
         stx   b,y
         rts
L07D8    comb
         ldb   #$E3
         rts
L07DC    coma
         inc   $0F,s
         com   d,s
L07E1    ldx   u0004,u
         tfr   dp,a
         ldb   #$28
         tfr   d,u
         ldy   <u0050
         lda   $06,y
         ldb   <u00D0
         ldy   #$0006
         os9   F$Move
         ldx   <u0050
         pshs  x
         ldx   <u004A
         stx   <u0050
         lda   #$C1
         leax  <L07DC,pcr
         os9   F$Link
         puls  x
         stx   <u0050
         bcs   L080F
         jmp   ,y
L080F    rts
         ldd   u0001,u
         ldx   u0004,u
         bsr   L0867
         ldy   <u0050
         ldb   $06,y
         bra   L0825
         ldd   u0001,u
         ldx   u0004,u
         bsr   L0867
         ldb   <u00D0
L0825    ldy   u0006,u
         beq   L0865
         sta   ,-s
         bmi   L0840
         os9   F$LDABX
L0831    ora   ,s
         leay  -$01,y
         beq   L0860
         lsr   ,s
         bcc   L0831
         os9   F$STABX
         leax  $01,x
L0840    lda   #$FF
         bra   L084B
L0844    os9   F$STABX
         leax  $01,x
         leay  -$08,y
L084B    cmpy  #$0008
         bhi   L0844
         beq   L0860
L0853    lsra
         leay  -$01,y
         bne   L0853
         coma
         sta   ,s
         os9   F$LDABX
         ora   ,s
L0860    os9   F$STABX
         leas  $01,s
L0865    clrb
         rts
L0867    pshs  y,b
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         leax  d,x
         puls  b
         leay  <L087C,pcr
         andb  #$07
         lda   b,y
         puls  pc,y

L087C    fcb  $80,$40,$20,$10,$08,$04,$02,$01

DELBIT   ldd   u0001,u
         ldx   u0004,u
         bsr   L0867
         ldy   <u0050
         ldb   $06,y
         bra   L0899

SDELBIT  ldd   u0001,u
         ldx   u0004,u
         bsr   L0867
         ldb   <u00D0
L0899    ldy   u0006,u
         beq   L08D9
         coma
         sta   ,-s
         bpl   L08B5
         os9   F$LDABX
L08A6    anda  ,s
         leay  -$01,y
         beq   L08D4
         asr   ,s
         bcs   L08A6
         os9   F$STABX
         leax  $01,x
L08B5    clra
         bra   L08BF
L08B8    os9   F$STABX
         leax  $01,x
         leay  -$08,y
L08BF    cmpy  #$0008
         bhi   L08B8
         beq   L08D4
         coma
L08C8    lsra
         leay  -$01,y
         bne   L08C8
         sta   ,s
         os9   F$LDABX
         anda  ,s
L08D4    os9   F$STABX
         leas  $01,s
L08D9    clrb
         rts
         ldd   u0001,u
         ldx   u0004,u
         bsr   L0867
         ldy   <u0050
         ldb   $06,y
         bra   L08F1
         ldd   u0001,u
         ldx   u0004,u
         lbsr  L0867
         ldb   <u00D0
L08F1    pshs  u,y,x,b,a,cc
         clra
         clrb
         std   $03,s
         ldy   u0001,u
         sty   $07,s
         bra   L090A
L08FF    sty   $07,s
L0902    lsr   $01,s
         bcc   L0915
         ror   $01,s
         leax  $01,x
L090A    cmpx  u0008,u
         bcc   L0933
         ldb   $02,s
         os9   F$LDABX
         sta   ,s
L0915    leay  $01,y
         lda   ,s
         anda  $01,s
         bne   L08FF
         tfr   y,d
         subd  $07,s
         cmpd  u0006,u
         bcc   L093C
         cmpd  $03,s
         bls   L0902
         std   $03,s
         ldd   $07,s
         std   $05,s
         bra   L0902
L0933    ldd   $03,s
         std   u0006,u
         comb
         ldd   $05,s
         bra   L093E
L093C    ldd   $07,s
L093E    std   u0001,u
         leas  $09,s
         rts
         ldx   <u0050
         ldb   $06,x
         lda   u0001,u
         os9   F$GProcP
         bcs   L095B
         lda   <u00D0
         leax  ,y
         ldy   #$0200
         ldu   u0004,u
         os9   F$Move
L095B    rts
         ldd   #$1000
         std   u0001,u
         ldd   <u0042
         subd  <u0040
         std   u0006,u
         tfr   d,y
         lda   <u00D0
         ldx   <u0050
         ldb   $06,x
         ldx   <u0040
         ldu   u0004,u
         os9   F$Move
         rts
         ldd   <u0046
         subd  <u0044
         tfr   d,y
         ldd   <u0058
         subd  <u0044
         ldx   u0004,u
         leax  d,x
         stx   u0006,u
         ldx   <u0044
         stx   u0008,u
         lda   <u00D0
         ldx   <u0050
         ldb   $06,x
         ldx   <u0044
         ldu   u0004,u
         os9   F$Move
         rts
         ldx   <u0050
         ldd   u0006,u
         std   $08,x
         clrb
         rts
         ldd   u0006,u
         beq   L0A04
         addd  u0008,u
         ldy   <u0022
         leay  <$20,y
         sty   <u0022
         leay  <-$20,y
         pshs  y,b,a
         ldy   <u0050
         ldb   $06,y
         pshs  b
         ldx   u0001,u
         leay  <$40,y
         ldb   #$10
         pshs  u,b
         ldu   $06,s
L09C7    clra
         clrb
         os9   F$LDDDXY
         std   ,u++
         leax  $02,x
         dec   ,s
         bne   L09C7
         puls  u,b
         ldx   u0004,u
         ldu   u0008,u
         ldy   $03,s
L09DD    cmpx  #$1000
         bcs   L09EA
         leax  >-$1000,x
         leay  $02,y
         bra   L09DD
L09EA    os9   F$LDAXY
         ldb   ,s
         pshs  x
         leax  ,u+
         os9   F$STABX
         puls  x
         leax  $01,x
         cmpu  $01,s
         bcs   L09DD
         puls  y,x,b
         sty   <u0022
L0A04    clrb
         rts
         pshs  u
         lda   u0001,u
         ldx   <u0050
         leay  <$40,x
         ldx   u0004,u
         os9   F$FModul
         puls  y
         bcs   L0A51
         stx   $04,y
         ldx   u0006,u
         beq   L0A24
         leax  -$01,x
         stx   u0006,u
         bne   L0A50
L0A24    cmpa  #$D0
         bcs   L0A4D
         clra
         ldx   [,u]
         ldy   <u004C
L0A2E    adda  #$02
         cmpa  #$20
         bcc   L0A4D
         cmpx  a,y
         bne   L0A2E
         lsla
         lsla
         lsla
         clrb
         addd  u0004,u
         tfr   d,x
         os9   F$IODel
         bcc   L0A4D
         ldx   u0006,u
         leax  $01,x
         stx   u0006,u
         bra   L0A51
L0A4D    lbsr  L01FA
L0A50    clrb
L0A51    rts
         lda   u0001,u
         ldx   u0004,u
         bsr   L0A5E
         bcs   L0A5D
         sty   u0006,u
L0A5D    rts
L0A5E    pshs  b,a
         tsta
         beq   L0A72
         clrb
         lsra
         rorb
         lsra
         rorb
         lda   a,x
         tfr   d,y
         beq   L0A72
         tst   ,y
         bne   L0A73
L0A72    coma
L0A73    puls  pc,b,a
         ldx   u0004,u
         bne   L0A81
         bsr   L0A8B
         bcs   L0A8A
         stx   ,x
         stx   u0004,u
L0A81    bsr   L0AA1
         bcs   L0A8A
         sta   u0001,u
         sty   u0006,u
L0A8A    rts
L0A8B    pshs  u
         ldd   #$0100
         os9   F$SRqMem
         leax  ,u
         puls  u
         bcs   L0AA0
         clra
         clrb
L0A9B    sta   d,x
         incb
         bne   L0A9B
L0AA0    rts
L0AA1    pshs  u,x
         clra
L0AA4    pshs  a
         clrb
         lda   a,x
         beq   L0AB6
         tfr   d,y
         clra
L0AAE    tst   d,y
         beq   L0AB8
         addb  #$40
         bcc   L0AAE
L0AB6    orcc  #$01
L0AB8    leay  d,y
         puls  a
         bcc   L0AE3
         inca
         cmpa  #$40
         bcs   L0AA4
         clra
L0AC4    tst   a,x
         beq   L0AD2
         inca
         cmpa  #$40
         bcs   L0AC4
         comb
         ldb   #$C8
         bra   L0AF0
L0AD2    pshs  x,a
         bsr   L0A8B
         bcs   L0AF2
         leay  ,x
         tfr   x,d
         tfr   a,b
         puls  x,a
         stb   a,x
         clrb
L0AE3    lslb
         rola
         lslb
         rola
         ldb   #$3F
L0AE9    clr   b,y
         decb
         bne   L0AE9
         sta   ,y
L0AF0    puls  pc,u,x
L0AF2    leas  $03,s
         puls  pc,u,x
         lda   u0001,u
         ldx   u0004,u
         pshs  u,y,x,b,a
         clrb
         tsta
         beq   L0B24
         lsra
         rorb
         lsra
         rorb
         pshs  a
         lda   a,x
         beq   L0B22
         tfr   d,y
         clr   ,y
         clrb
         tfr   d,u
         clra
L0B12    tst   d,u
         bne   L0B22
         addb  #$40
         bne   L0B12
         inca
         os9   F$SRtMem
         lda   ,s
         clr   a,x
L0B22    clr   ,s+
L0B24    puls  pc,u,y,x,b,a
         lda   u0001,u
         bsr   L0B30
         bcs   L0B2F
         sty   u0006,u
L0B2F    rts
L0B30    pshs  x,b,a
         ldb   ,s
         beq   L0B42
         ldx   <u0048
         abx
         lda   ,x
         beq   L0B42
         clrb
         tfr   d,y
         puls  pc,x,b,a
L0B42    puls  x,b,a
         comb
         ldb   #$EE
         rts
         ldx   u0004,u
         ldd   u0001,u
         leau  <$40,x
         lsla
         leau  a,u
         clra
         tfr   d,y
         pshs  x
L0B57    ldd   ,u
         addd  <u0040
         tfr   d,x
         lda   ,x
         anda  #$FE
         sta   ,x
         ldd   #$00C0
         std   ,u++
         leay  -$01,y
         bne   L0B57
         puls  x
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         clrb
         rts
         lda   u0002,u
         cmpa  #$10
         bcc   L0BD5
         leas  <-$20,s
         ldx   u0004,u
         leay  ,s
L0B83    stx   ,y++
         leax  $01,x
         deca
         bne   L0B83
         ldb   u0002,u
         ldx   <u0050
         leay  <$40,x
         os9   F$FreeHB
         bcs   L0BD1
         pshs  b,a
         lsla
         lsla
         lsla
         lsla
         clrb
         std   u0008,u
         ldd   ,s
         pshs  u
         leau  $04,s
         os9   F$SetImg
         puls  u
         cmpx  <u004A
         bne   L0BCE
         tfr   x,y
         ldx   <u004E
         ldb   u0008,u
         abx
         leay  <$40,y
         lda   ,s
         lsla
         leay  a,y
         ldu   <u0040
L0BBF    ldd   ,y++
         lda   d,u
         ldb   #$10
L0BC5    sta   ,x+
         decb
         bne   L0BC5
         dec   $01,s
         bne   L0BBF
L0BCE    leas  $02,s
         clrb
L0BD1    leas  <$20,s
         rts
L0BD5    comb
         ldb   #$DB
         rts
         ldb   u0002,u
         beq   L0C2D
         ldd   u0008,u
         tstb
         bne   L0BD5
         bita  #$0F
         bne   L0BD5
         ldx   <u0050
         cmpx  <u004A
         beq   L0BFC
         lda   $04,x
         anda  #$F0
         suba  u0008,u
         bcs   L0BFC
         lsra
         lsra
         lsra
         lsra
         cmpa  u0002,u
         bcs   L0BD5
L0BFC    lda   u0008,u
         lsra
         lsra
         lsra
         leay  <$40,x
         leay  a,y
         ldb   u0002,u
         ldx   #$00C0
L0C0B    stx   ,y++
         decb
         bne   L0C0B
         ldx   <u0050
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         cmpx  <u004A
         bne   L0C2D
         ldx   <u004E
         ldb   u0008,u
         abx
         ldb   u0002,u
L0C23    lda   #$10
L0C25    clr   ,x+
         deca
         bne   L0C25
         decb
         bne   L0C23
L0C2D    clrb
         rts
         ldb   u0002,u
         beq   L0C55
         ldd   <u0042
         subd  <u0040
         subd  u0004,u
         bls   L0C55
         tsta
         bne   L0C44
         cmpb  u0002,u
         bcc   L0C44
         stb   u0002,u
L0C44    ldx   <u0040
         ldd   u0004,u
         leax  d,x
         ldb   u0002,u
L0C4C    lda   ,x
         anda  #$FE
         sta   ,x+
         decb
         bne   L0C4C
L0C55    clrb
         rts
         ldx   <u0044
         bra   L0C61
L0C5B    ldu   ,x
         beq   L0C67
         leax  $08,x
L0C61    cmpx  <u0058
         bne   L0C5B
         bra   L0C8F
L0C67    tfr   x,y
         bra   L0C6F
L0C6B    ldu   ,y
         bne   L0C78
L0C6F    leay  $08,y
         cmpy  <u0058
         bne   L0C6B
         bra   L0C8D
L0C78    ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         cmpy  <u0058
         bne   L0C6B
L0C8D    stx   <u0058
L0C8F    ldx   <u0046
         bra   L0C97
L0C93    ldu   ,x
         beq   L0C9F
L0C97    leax  -$02,x
         cmpx  <u005A
         bne   L0C93
         bra   L0CD7
L0C9F    ldu   -$02,x
         bne   L0C97
         tfr   x,y
         bra   L0CAB
L0CA7    ldu   ,y
         bne   L0CB4
L0CAB    leay  -$02,y
L0CAD    cmpy  <u005A
         bcc   L0CA7
         bra   L0CC5
L0CB4    leay  $02,y
         ldu   ,y
         stu   ,x
L0CBA    ldu   ,--y
         stu   ,--x
         beq   L0CCB
         cmpy  <u005A
         bne   L0CBA
L0CC5    stx   <u005A
         bsr   L0CD9
         bra   L0CD7
L0CCB    leay  $02,y
         leax  $02,x
         bsr   L0CD9
         leay  -$04,y
         leax  -$02,x
         bra   L0CAD
L0CD7    clrb
         rts
L0CD9    pshs  u
         ldu   <u0044
         bra   L0CE8
L0CDF    cmpy  ,u
         bne   L0CE6
         stx   ,u
L0CE6    leau  u0008,u
L0CE8    cmpu  <u0058
         bne   L0CDF
         puls  pc,u
         emod
OS9End      equ   *
