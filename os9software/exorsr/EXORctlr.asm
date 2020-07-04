         nam   EXORctlr
         ttl   os9 device driver


 use defsfile

tylg     set   Drivr+Objct
atrv     set   ReEnt+3

         mod   eom,name,tylg,atrv,start,0

name fcs   /EXORctlr/

start    equ   *
         lbra  L0393
         lbra  L03B8
         andcc #$FE
         pshs  x,dp,b,a,cc
         clra
         tfr   a,dp
         lda   #$00
         sta   <$6E,u
         sts   <$77,u
         ldx   <D.NMI
         stx   <$75,u
         leax  >L0126,pcr
         stx   <D.NMI
         ldx   <$7F,u
         lda   <$16,x
         sta   <$79,u
         lda   <$12,x
         sta   $02,s
         lda   #$66
         ldb   <$67,u
         lsrb
         beq   L004E
         lda   #$46
L004E    sta   $01,y
         lda   #$02
         bcc   L0055
         lsra
L0055    sta   ,y
         lda   ,y
         lsla
         lsla
         sta   <$73,u
         bcs   L00DE
         ldb   <$10,x
         bitb  #$01
         bne   L0069
         ora   #$80
L0069    ldb   <$7E,u
         bitb  #$04
         lbne  L0365
         andb  #$08
         beq   L007A
         lda   #$0B
         bra   L00AE
L007A    sta   <$73,u
L007D    ldx   <$7F,u
         lda   #$FF
         pshs  a
         ldd   <$68,u
L0087    inc   ,s
         subd  <$11,x
         bcc   L0087
         addd  <$11,x
         puls  a
         clr   <$74,u
         tst   <$73,u
         bmi   L00A1
         lsra
         bcc   L00A1
         inc   <$74,u
L00A1    decb
         stb   <$70,u
         ldx   <$6A,u
         stx   <$71,u
         ldb   <$79,u
L00AE    sta   <$79,u
         pshs  b
         suba  ,s+
         beq   L00EC
         ldb   ,y
         orb   #$08
         bcc   L00C0
         andb  #$F7
         nega
L00C0    andb  #$EF
         stb   ,y
         deca
         bmi   L00CE
         lbsr  L015B
         ldb   ,y
         bpl   L00C0
L00CE    bsr   L0112
         ldb   <$7E,u
         tsta
         ble   L00F9
         bitb  #$08
         bne   L0131
L00DA    ldb   #$F7
         bra   L012C
L00DE    ldb   #$F6
         bra   L012C
L00E2    lda   <$79,u
         beq   L00DA
         clra
         ldb   #$56
         bra   L00AE
L00EC    lda   <$7E,u
         bita  #$08
         bne   L00E2
         bita  #$10
         bne   L0131
         bra   L0105
L00F9    bitb  #$08
         bne   L00E2
         tfr   b,a
         bsr   L0112
         bita  #$10
         bne   L0131
L0105    ldb   #$6F
         rora
         bcc   L010C
         ldb   #$6A
L010C    stb   <$7A,u
         lbra  L01A4
L0112    ldx   #$0360
         bra   L0167
L0117    lda   <$7E,u
         bpl   L0131
         anda  #$40
         sta   <$7E,u
         beq   L0131
         lbra  L007D
L0126    lds   <$77,u
         ldb   #$FB
L012C    stb   <$6E,u
         inc   ,s
L0131    lda   #$3C
         sta   $02,y
         ldx   <$75,u
         stx   <D.NMI
         ldb   #$01
         bitb  ,s
         bne   L0147
         ldb   <$7E,u
         cmpb  #$10
         beq   L014F
L0147    lda   $01,y
         anda  #$F0
         ora   #$03
         sta   $01,y
L014F    clra
         ldb   <$79,u
         ldx   <$7F,u
         std   <$15,x
         puls  pc,x,dp,b,a,cc

L015B    ldb   #$34
         stb   $02,y
         ldb   #$3C
         stb   $02,y
         ldx   >$0081,u
L0167    ldb   <$7C,u
L016A    decb
         bne   L016A
         leax  -$01,x
         bne   L0167
         rts
L0172    ldx   #$D0D8
         stx   $04,y
         lda   #$50
         sta   $04,y
         lda   $01,y
         ora   #$07
         sta   $01,y
         dec   $01,y
         lda   #$40
         bsr   L018D
         sta   $04,y
         lda   #$98
         sta   $05,y
L018D    rts

L018E    ldb   $04,y
         bpl   L018E
         ldb   $05,y
         rts

L0195    deca
         sta   <$70,u
         bsr   L015B
         lbsr  L0112
         inc   <$79,u
         clr   <$74,u
L01A4    lda   ,s
         tfr   a,cc
         inc   <$70,u
         lda   <$70,u
         ldx   <$71,u
         lbeq  L0117
         ldb   $01,y
         orb   #$40
         tst   <$74,u
         beq   L01C0
         andb  #$22
L01C0    suba  $02,s
         bcs   L01D6
         tst   <$73,u
         bmi   L0195
         tst   <$74,u
         bne   L0195
         inc   <$74,u
         sta   <$70,u
         andb  #$22
L01D6    stb   $01,y
         lda   #$05
         sta   <$7B,u
         leax  -$01,x
L01DF    lda   ,s
         tfr   a,cc
         lda   #$80
         stx   <$71,u
         nega
         ldb   <$7E,u
         lslb
         bpl   L01F0
         clra
L01F0    adda  #$80
         sta   <$6F,u
         lbsr  L0357
         lda   <$79,u
         orb   #$0C
         cmpa  #$2B
         bls   L0203
         andb  #$EB
L0203    stb   ,y
         ldx   #$D270
         stx   $04,y
         ldx   #$D1F5
         stx   $04,y
         orcc  #$50
L0211    lbsr  L0172
         lbsr  L018E
         cmpb  #$7E
         bne   L0211
         lbsr  L018E
         lda   $05,y
         cmpb  <$79,u
         bne   L0211
         lbsr  L018E
         lda   $05,y
         cmpb  <$70,u
         bne   L0211
         lbsr  L018E
         lda   <$7C,u
L0235    suba  #$03
         bhi   L0235
         lda   $01,y
         bmi   L027A
         lda   $05,y
         lda   #$04
L0241    lbsr  L018E
         cmpa  $05,y
         deca
         bne   L0241
         ldb   <$7E,u
         bmi   L02CB
         ldb   <$7C,u
         lslb
L0252    cmpb  $04,y
         cmpb  $04,y
         decb
         bne   L0252
         ldb   #$04
L025B    lbsr  L0172
         ldx   <$6C,u
L0261    lda   $04,y
         bpl   L0261
         lda   $05,y
         cmpa  #$6F
         beq   L0293
         cmpa  #$6A
         beq   L028E
         decb
         bne   L025B
         ldb   #$FC
         bra   L027C
L0276    ldb   #$F3
         bra   L027C
L027A    ldb   #$FD
L027C    dec   <$7B,u
         lbeq  L012C
         ldx   <$71,u
         lbra  L01DF
L0289    ldb   #$F2
         lbra  L012C
L028E    ldb   #$FA
         lbra  L012C
L0293    ldb   <$7E,u
         lslb
         bmi   L02AA
         ldb   #$80
L029B    lda   $04,y
         bpl   L029B
         lda   $05,y
         sta   ,x+
         lda   $05,y
         sta   ,x+
         decb
         bne   L029B
L02AA    ldb   <$6F,u
L02AD    lda   $04,y
         bpl   L02AD
         decb
         bmi   L02BA
         lda   $05,y
         lda   $05,y
         bra   L02AD
L02BA    lda   <$7C,u
L02BD    suba  #$03
         bhi   L02BD
         lda   $01,y
         bmi   L0276
         stx   <$6C,u
         lbra  L01A4

L02CB    lda   <$7C,u
         suba  #$03
         lsla
L02D1    deca
         bpl   L02D1
         inc   $01,y
         lda   $01,y
         ldx   #$C0DA
         stx   $04,y
         ldx   #$C1AA
         stx   $04,y
         ldx   #$8270
         stx   $04,y
         anda  #$F2
         sta   $01,y
         bita  #$10
         beq   L0289
         anda  #$60
         sta   $01,y
         rorb
         bcs   L02F7
         rorb
L02F7    ldx   #$0005
         lbsr  L0167
         ldb   #$80
         lda   <$7A,u
         ldx   #$83F5
         stx   $04,y
         ldx   <$6C,u
         sta   $05,y
         lda   <L0311,pcr
         bra   L031C

L0311    lda   #$40
L0313    bita  $04,y
         beq   L0313
         lda   <L0311,pcr
         bra   L031C
L031C    lda   ,x
         sta   $05,y
         lda   $01,x
         sta   $05,y
         bcs   L0328
         leax  $02,x
L0328    decb
         bne   L0311
         stx   <$6C,u
         lda   #$40
L0330    bita  $04,y
         beq   L0330
         stb   $05,y
L0336    bita  $04,y
         beq   L0336
         ldb   $01,y
         orb   #$08
         stb   $01,y
         stb   $05,y
L0342    bita  $04,y
         beq   L0342
         ldb   #$FF
         stb   $05,y
         stb   $05,y
L034C    bita  $04,y
         beq   L034C
         dec   $01,y
         dec   $01,y
         lbra  L01A4
L0357    lda   #$36
         sta   $03,y
         lda   #$3E
         sta   $03,y
         ldb   ,y
         deca
         sta   $02,y
         rts

L0365    bsr   L0357
         ldb   $01,y
         clra
L036A    ldb   $03,y
         bpl   L036A
         ldb   $01,y
L0370    clrb
L0371    decb
         nop
         bne   L0371
         inca
         tst   $03,y
         bpl   L0370
         incb
         suba  #$45
L037D    incb
         suba  #$10
         bcc   L037D
         stb   <$7C,u
         lsrb
         bcc   L038D
         cmpb  #$01
         bls   L038D
         incb
L038D    stb   <$7D,u
         lbra  L0131

L0393    pshs  x,b,a
         clra
         clrb
         std   $02,y
         std   ,y
         ldx   #$D0DA
         stx   $04,y
         ldx   #$0404
         stx   $02,y
         ldx   #$0B62
         stx   ,y
         std   $02,y
         ldx   #$1F6F
         stx   ,y
         ldx   #$3C3E
         stx   $02,y
         puls  pc,x,b,a

L03B8    tstb
         bne   PHYERR
         sta   <$7E,u
         lda   <$21,y
         cmpa  $06,u
         bcc   L03EF
         sta   <$67,u
         ldb   #$18
         mul
         pshs  x
         leax  $07,u
         leax  d,x
         stx   <$7F,u
         puls  b,a
         cmpd  $01,x
         bhi   PHYERR
         std   <$68,u
         ldd   $08,y
         std   <$6C,u
         ldd   #$0001
         std   <$6A,u
         clrb
         rts

PHYERR    comb
         ldb   #E$Sect
         rts

L03EF    comb
         ldb   #E$Unit Error: illegal unit (drive)
         rts

         emod
eom      equ   *
