         nam   OS9p2
         ttl   os9 system module    

         ifp1
         use   /d0/defs/os9defs
         endc
tylg     set   Systm+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size

size     equ   .
name     equ   *
         fcs   /OS9p2/
         fcb   $05 
         fcb   $28 (
         fcb   $43 C
         fcb   $29 )
         fcb   $31 1
         fcb   $39 9
         fcb   $38 8
         fcb   $31 1
         fcb   $4D M
         fcb   $69 i
         fcb   $63 c
         fcb   $72 r
         fcb   $6F o
         fcb   $77 w
         fcb   $61 a
         fcb   $72 r
         fcb   $65 e
L0023    fcb   $7F ÿ
         fcb   $04 
         fcb   $4E N
         fcb   $02 
         fcb   $00 
         fcb   $99 
         fcb   $04 
         fcb   $00 
         fcb   $DF _
         fcb   $06 
         fcb   $01 
         fcb   $2A *
         fcb   $07 
         fcb   $01 
         fcb   $A5 %
         fcb   $08 
         fcb   $02 
         fcb   $18 
         fcb   $09 
         fcb   $03 
         fcb   $0B 
         fcb   $0A 
         fcb   $02 
         fcb   $7B û
         fcb   $0C 
         fcb   $03 
         fcb   $2E .
         fcb   $0D 
         fcb   $03 
         fcb   $10 
         fcb   $0E 
         fcb   $03 
         fcb   $34 4
         fcb   $16 
         fcb   $03 
         fcb   $47 G
         fcb   $AF /
         fcb   $03 
         fcb   $54 T
         fcb   $B0 0
         fcb   $03 
         fcb   $74 t
         fcb   $B1 1
         fcb   $03 
         fcb   $F2 r
         fcb   $80 
start    equ   *
         leay  >L0023,pcr
         os9   F$SSvc   
         ldx   <D.PrcDBT
         os9   F$All64  
         bcs   L0091
         stx   <D.PrcDBT
         sty   <D.PROC
         tfr   s,d
         deca  
         ldb   #$01
         std   $07,y
         lda   #$80
         sta   $0D,y
         ldu   <D.Init
         bsr   L0095
         bcc   L007A
         lbsr  L0496
         bsr   L0095
L007A    bsr   L00A3
         bcc   L0083
         lbsr  L0496
         bsr   L00A3
L0083    ldd   $0E,u
         leax  d,u
         lda   #$01
         clrb  
         ldy   #$0000
         os9   F$Chain  
L0091    jmp   [>$FFFE]
L0095    clrb  
         ldd   <$10,u
         beq   L00A2
         leax  d,u
         lda   #$05
         os9   I$ChgDir 
L00A2    rts   
L00A3    clrb  
         ldd   <$12,u
         leax  d,u
         lda   #$03
         os9   I$Open   
         bcs   L00C1
         ldx   <D.PROC
         sta   <$26,x
         os9   I$Dup    
         sta   <$27,x
         os9   I$Dup    
         sta   <$28,x
L00C1    rts   
         ldd   $08,u
         beq   L0109
         ldx   <D.ModDir
L00C8    cmpd  ,x
         beq   L00D5
         leax  $04,x
         cmpx  <D.ModDir+2
         bcs   L00C8
         bra   L0109
L00D5    lda   $02,x
         beq   L00DE
         deca  
         sta   $02,x
         bne   L0109
L00DE    ldy   ,x
         cmpy  <D.BTLO
         bcc   L0109
         ldb   $06,y
         cmpb  #$D0
         bcs   L00F5
         os9   F$IODel  
         bcc   L00F5
         inc   $02,x
         bra   L010A
L00F5    clra  
         clrb  
         std   ,x
         std   ,y
         ldd   $02,y
         lbsr  L0246
         exg   d,y
         exg   a,b
         ldx   <D.FMBM
         os9   F$DelBit 
L0109    clra  
L010A    rts   
         ldy   <D.PROC
         ldx   <D.PrcDBT
         lda   $03,y
         bne   L0118
         comb  
         ldb   #$E2
         rts   
L0118    os9   F$Find64 
         lda   $0D,y
         bita  #$01
         bne   L0134
         lda   $02,y
         bne   L0118
         clr   $01,u
         ldx   <D.PROC
         orcc  #$50
         ldd   <D.WProcQ
         std   $0E,x
         stx   <D.WProcQ
         lbra  L0329
L0134    ldx   <D.PROC
L0136    lda   ,y
         ldb   <$36,y
         std   $01,u
         pshs  u,y,x,a
         leay  $01,x
         ldx   <D.PrcDBT
         bra   L0148
L0145    os9   F$Find64 
L0148    lda   $02,y
         cmpa  ,s
         bne   L0145
         ldu   $03,s
         ldb   $02,u
         stb   $02,y
         os9   F$Ret64  
         puls  pc,u,y,x,a
         ldx   <D.PROC
         ldb   $02,u
         stb   <$36,x
         ldb   #$10
         leay  <$26,x
L0165    lda   ,y+
         beq   L0170
         pshs  b
         os9   I$Close  
         puls  b
L0170    decb  
         bne   L0165
         lda   $07,x
         tfr   d,u
         lda   $08,x
         os9   F$SRtMem 
         ldu   <$12,x
         os9   F$UnLink 
         ldu   <D.PROC
         leay  $01,u
         ldx   <D.PrcDBT
         bra   L019C
L018A    clr   $02,y
         os9   F$Find64 
         lda   $0D,y
         bita  #$01
         beq   L019A
         lda   ,y
         os9   F$Ret64  
L019A    clr   $01,y
L019C    lda   $02,y
         bne   L018A
         ldx   #$0041
         lda   $01,u
         bne   L01B4
         ldx   <D.PrcDBT
         lda   ,u
         os9   F$Ret64  
         bra   L01D2
L01B0    cmpa  ,x
         beq   L01C2
L01B4    leay  ,x
         ldx   $0E,x
         bne   L01B0
         lda   $0D,u
         ora   #$01
         sta   $0D,u
         bra   L01D2
L01C2    ldd   $0E,x
         std   $0E,y
         os9   F$AProc  
         leay  ,u
         ldu   $04,x
         ldu   $01,u
         lbsr  L0136
L01D2    clra  
         clrb  
         std   <D.PROC
         rts   
         ldx   <D.PROC
         ldd   $01,u
         beq   L0237
         bsr   L0246
         subb  $08,x
         beq   L0237
         bcs   L0217
         tfr   d,y
         ldx   $07,x
         pshs  u,y,x
         ldb   ,s
         beq   L01F1
         addb  $01,s
L01F1    ldx   <D.FMBM
         ldu   <D.FMBM+2
         os9   F$SchBit 
         bcs   L0241
         stb   $02,s
         ldb   ,s
         beq   L0206
         addb  $01,s
         cmpb  $02,s
         bne   L0241
L0206    ldb   $02,s
         os9   F$AllBit 
         ldd   $02,s
         suba  $01,s
         addb  $01,s
         puls  u,y,x
         ldx   <D.PROC
         bra   L0235
L0217    negb  
         tfr   d,y
         negb  
         addb  $08,x
         addb  $07,x
         cmpb  $04,x
         bhi   L0227
         comb  
         ldb   #$DF
         rts   
L0227    ldx   <D.FMBM
         os9   F$DelBit 
         tfr   y,d
         negb  
         ldx   <D.PROC
         addb  $08,x
         lda   $07,x
L0235    std   $07,x
L0237    lda   $08,x
         clrb  
         std   $01,u
         adda  $07,x
         std   $06,u
         rts   
L0241    comb  
         ldb   #$CF
         puls  pc,u,y,x
L0246    addd  #$00FF
         clrb  
         exg   a,b
         rts   
         lda   $01,u
         bne   L025F
         inca  
L0252    ldx   <D.PROC
         cmpa  ,x
         beq   L025A
         bsr   L025F
L025A    inca  
         bne   L0252
         clrb  
         rts   
L025F    ldx   <D.PrcDBT
         os9   F$Find64 
         bcc   L0269
         ldb   #$E0
         rts   
L0269    orcc  #$50
         pshs  y,a
         ldb   $02,u
         bne   L0277
         lda   $0D,y
         ora   #$02
         sta   $0D,y
L0277    lda   <$36,y
         beq   L0284
         deca  
         beq   L0284
         comb  
         ldb   #$E9
         puls  pc,y,a
L0284    stb   <$36,y
         ldx   #$0043
         bra   L0290
L028C    cmpx  $01,s
         beq   L02A3
L0290    leay  ,x
         ldx   $0E,y
         bne   L028C
         ldx   #$0041
L0299    leay  ,x
         ldx   $0E,y
         beq   L02B3
         cmpx  $01,s
         bne   L0299
L02A3    ldd   $0E,x
         std   $0E,y
         lda   <$36,x
         deca  
         bne   L02B0
         sta   <$36,x
L02B0    os9   F$AProc  
L02B3    clrb  
         puls  pc,y,a
         ldx   <D.PROC
         orcc  #$50
         lda   <$36,x
         beq   L02CA
         deca  
         bne   L02C5
         sta   <$36,x
L02C5    os9   F$AProc  
         bra   L0329
L02CA    ldd   $04,u
         beq   L0316
         subd  #$0001
         std   $04,u
         beq   L02C5
         pshs  u,x
         ldx   #$0043
L02DA    leay  ,x
         ldx   $0E,x
         beq   L02F2
         pshs  b,a
         lda   $0D,x
         bita  #$40
         puls  b,a
         beq   L02F2
         ldu   $04,x
         subd  $04,u
         bcc   L02DA
         addd  $04,u
L02F2    puls  u,x
         std   $04,u
         ldd   $0E,y
         stx   $0E,y
         std   $0E,x
         lda   $0D,x
         ora   #$40
         sta   $0D,x
         ldx   $0E,x
         beq   L0329
         lda   $0D,x
         bita  #$40
         beq   L0329
         ldx   $04,x
         ldd   $04,x
         subd  $04,u
         std   $04,x
         bra   L0329
L0316    lda   $0D,x
         anda  #$BF
         sta   $0D,x
         ldd   #$0043
L031F    tfr   d,y
         ldd   $0E,y
         bne   L031F
         stx   $0E,y
         std   $0E,x
L0329    leay  <L033D,pcr
         pshs  y
         ldy   <D.PROC
         ldd   $04,y
         ldx   $04,u
         pshs  u,y,x,dp,b,a,cc
         sts   $04,y
         os9   F$NProc  
L033D    std   $04,y
         stx   $04,u
         clrb  
         rts   
         ldx   <D.PROC
         ldd   $04,u
         std   <$37,x
         ldd   $08,u
         std   <$39,x
         clrb  
         rts   
         lda   $01,u
         ldx   <D.PrcDBT
         os9   F$Find64 
         bcs   L0368
         ldx   <D.PROC
         ldd   $09,x
         cmpd  $09,y
         bne   L0368
         lda   $02,u
         sta   $0B,y
         rts   
L0368    comb  
         ldb   #$E0
         rts   
         ldx   <D.PROC
         lda   ,x
         sta   $01,u
         ldd   $09,x
         std   $06,u
         clrb  
         rts   
         ldx   <D.PROC
         leay  <$14,x
         ldb   $01,u
         decb  
         cmpb  #$03
         bcc   L038A
         lslb  
         ldx   $04,u
         stx   b,y
         rts   
L038A    comb  
         ldb   #$E3
         rts   
         ldx   $04,u
         ldd   ,x
         std   <D.Year
         ldd   $02,x
         std   <D.Day
         ldd   $04,x
         std   <D.Min
         clrb  
         rts   
         lda   $01,u
         ldx   $04,u
         bsr   L03AA
         bcs   L03A9
         sty   $06,u
L03A9    rts   
L03AA    pshs  b,a
         tsta  
         beq   L03BE
         clrb  
         lsra  
         rorb  
         lsra  
         rorb  
         lda   a,x
         tfr   d,y
         beq   L03BE
         tst   ,y
         bne   L03BF
L03BE    coma  
L03BF    puls  pc,b,a
         ldx   $04,u
         bne   L03CD
         bsr   L03D7
         bcs   L03D6
         stx   ,x
         stx   $04,u
L03CD    bsr   L03ED
         bcs   L03D6
         sta   $01,u
         sty   $06,u
L03D6    rts   
L03D7    pshs  u
         ldd   #$0100
         os9   F$SRqMem 
         leax  ,u
         puls  u
         bcs   L03EC
         clra  
         clrb  
L03E7    sta   d,x
         incb  
         bne   L03E7
L03EC    rts   
L03ED    pshs  u,x
         clra  
L03F0    pshs  a
         clrb  
         lda   a,x
         beq   L0402
         tfr   d,y
         clra  
L03FA    tst   d,y
         beq   L0404
         addb  #$40
         bcc   L03FA
L0402    orcc  #$01
L0404    leay  d,y
         puls  a
         bcc   L042F
         inca  
         cmpa  #$40
         bcs   L03F0
         clra  
L0410    tst   a,x
         beq   L041E
         inca  
         cmpa  #$40
         bcs   L0410
         ldb   #$C8
         coma  
         bra   L043C
L041E    pshs  x,a
         bsr   L03D7
         bcs   L043E
         leay  ,x
         tfr   x,d
         tfr   a,b
         puls  x,a
         stb   a,x
         clrb  
L042F    lslb  
         rola  
         lslb  
         rola  
         ldb   #$3F
L0435    clr   b,y
         decb  
         bne   L0435
         sta   ,y
L043C    puls  pc,u,x
L043E    leas  $03,s
         puls  pc,u,x
         lda   $01,u
         ldx   $04,u
         pshs  u,y,x,b,a
         clrb  
         lsra  
         rorb  
         lsra  
         rorb  
         pshs  a
         lda   a,x
         beq   L046B
         tfr   d,y
         clr   ,y
         clrb  
         tfr   d,u
         clra  
L045B    tst   d,u
         bne   L046B
         addb  #$40
         bne   L045B
         inca  
         os9   F$SRtMem 
         lda   ,s
         clr   a,x
L046B    clr   ,s+
         puls  pc,u,y,x,b,a
L046F    rola  
         clra  
         tsta  
         fcb   $41 A
         ldu   #$3476
         bsr   L048C
         bcc   L0482
         bsr   L0496
         bcs   L048A
         bsr   L048C
         bcs   L048A
L0482    jsr   ,y
         puls  u,y,x,b,a
         ldx   -$02,y
         jmp   ,x
L048A    puls  pc,u,y,x,b,a
L048C    leax  >L046F,pcr
         lda   #$C1
         os9   F$Link   
         rts   
L0496    ldx   <D.Init
         comb  
         ldd   <$14,x
         beq   L04CC
         leax  d,x
         lda   #$C1
         os9   F$Link   
         bcs   L04CC
         jsr   ,y
         bcs   L04CC
         stx   <D.MLIM
         stx   <D.BTLO
         leau  d,x
         stu   <D.BTHI
L04B3    ldd   ,x
         cmpd  #$87CD
         bne   L04C6
         os9   F$VModul 
         bcs   L04C6
         ldd   $02,x
         leax  d,x
         bra   L04C8
L04C6    leax  $01,x
L04C8    cmpx  <D.BTHI
         bcs   L04B3
L04CC    rts   
         emod
eom      equ   *
