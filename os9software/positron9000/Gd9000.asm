         nam   Gd9000
         ttl   os9 device driver

 use defsfile

tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   1
u0001    rmb   1
u0002    rmb   2
u0004    rmb   13
u0011    rmb   2
u0013    rmb   2
u0015    rmb   2
u0017    rmb   2
u0019    rmb   1
u001A    rmb   1
u001B    rmb   1
u001C    rmb   2
u001E    rmb   2
u0020    rmb   2
u0022    rmb   2
u0024    rmb   2
u0026    rmb   2
u0028    rmb   2
u002A    rmb   2
u002C    rmb   2
u002E    rmb   2
u0030    rmb   2
u0032    rmb   2
u0034    rmb   2
u0036    rmb   2
u0038    rmb   1
u0039    rmb   2
u003B    rmb   1
u003C    rmb   1
u003D    rmb   1
u003E    rmb   2
u0040    rmb   1
u0041    rmb   10
size     equ   .
         fcb   $03
name     equ   *
         fcs   /Gd9000/
         fcb   $01

start    equ   *
         lbra  L004E
         lbra  L00B1
         lbra  L00B3
         lbra  L00F9
         lbra  L0101
         lbra  L0105

L0027    fcb $00,$E0,$00,$00,$E3,$00,$01,$19,$01,$01,$30,$04,$01,$39
         fcb $08,$01,$42,$06,$01,$4D,$09,$01,$B2,$09,$01,$C4,$08,$01
         fcb $F1,$00,$02,$08,$02
L0048    fcb $20,$10,$08,$04,$02,$01


L004E    orcc  #$50
         ldb   #$01
         ldx   #$0320
         ldy   >$FF80
         stx   >$FF80
         ldx   #$0000
         lda   ,x
         cmpb  ,x
         bne   L0066
         incb
L0066    stb   ,x
         cmpb  ,x
         beq   L0077
         sty   >$FF80
         andcc #$AF
         comb
         ldb   #$F0
         bra   L00B0
L0077    sta   ,x
         ldx   #$0028
         lda   ,x
         ldb   #$01
         cmpb  ,x
         bne   L0085
         incb
L0085    stb   ,x
         cmpb  ,x
         bne   L008F
         ldb   #$01
         bra   L0090
L008F    clrb
L0090    sta   ,x
         sty   >$FF80
         andcc #$AF
         tstb
         bne   L00A0
         ldd   #$00EF
         bra   L00A3
L00A0    ldd   #$01DF
L00A3    std   <u0015,u
         std   <u003E,u
         ldd   #$00EF
         std   <u0017,u
         clrb
L00B0    rts

L00B1    clrb
         rts

L00B3    tst   <u003C,u
         bne   L00E1
         cmpa  #$0A
         bhi   L00F7
         com   <u003C,u
         leax  >L0027,pcr
         pshs  a
         lsla
         adda  ,s+
         pshs  x
         leax  a,x
         ldb   $02,x
         stb   <u003B,u
         puls  x
         ldd   a,x
         leax  d,x
         stx   <u0039,u
         tst   <u003B,u
         bne   L00F7
         jmp   ,x
L00E1    leax  <u0041,u
         ldb   <u0040,u
         sta   b,x
         incb
         stb   <u0040,u
         dec   <u003B,u
         bne   L00F7
         ldx   <u0039,u
         jmp   ,x
L00F7    clrb
         rts
L00F9    cmpa  #$01
         beq   L0105
         cmpa  #$06
         beq   L0105
L0101    comb
         ldb   #$D0
         rts
L0105    clrb
         rts
         lbra  L0267
         pshs  u
         ldu   >$FF80
         ldx   #$0320
         orcc  #$50
L0114    stx   >$FF80
         ldx   #$0000
         tfr   x,y
L011C    stx   ,y++
         tfr   y,d
         cmpb  #$50
         bne   L011C
         clrb
         inca
         tfr   d,y
         cmpa  #$08
         bne   L011C
         ldx   >$FF80
         leax  $01,x
         cmpx  #$033E
         bne   L0114
         stu   >$FF80
         andcc #$AF
         puls  u
         lbra  L0267
         lda   <u0041,u
         bne   L0149
         lda   #$01
         bra   L0151
L0149    cmpa  #$04
         bhi   L0154
         clrb
         rora
         rora
         rora
L0151    sta   <u0019,u
L0154    lbra  L0267
         leay  <u0041,u
         lbsr  L026F
         lbra  L0267
         leay  <u0041,u
         lbsr  L02EE
         lbra  L0267
         leay  <u0041,u
         ldx   $04,y
         lbsr  L03F2
         lbra  L0267
L0174    leay  <u0041,u
         lda   ,y+
         sta   <u003D,u
         lbsr  L02EE
         lda   <u003D,u
         suba  #$02
         bls   L01D3
         sta   <u003D,u
         leay  -$01,y
         ldd   $05,y
         std   ,y
         ldd   $07,y
         std   $02,y
         leax  >L019C,pcr
         stx   <u0039,u
         bra   L01AF
L019C    leay  <u0041,u
         lbsr  L02EE
         dec   <u003D,u
         beq   L01B9
         ldd   $04,y
         std   ,y
         ldd   $06,y
         std   $02,y
L01AF    ldb   #$04
         stb   <u0040,u
         stb   <u003B,u
         clrb
         rts
L01B9    tst   <u0038,u
         beq   L01D6
         ldd   $04,y
         std   ,y
         ldd   $06,y
         std   $02,y
         ldd   <u0034,u
         std   $04,y
         ldd   <u0036,u
         std   $06,y
         lbsr  L02EE
L01D3    clr   <u0038,u
L01D6    lbra  L0267
         inc   <u0038,u
         leay  <u0041,u
         ldd   $01,y
         std   <u0034,u
         ldd   $03,y
         std   <u0036,u
         bra   L0174
         leay  <u0041,u
         ldd   $04,y
         cmpd  ,y
         bls   L0216
         cmpd  <u003E,u
         bhi   L0216
         ldx   $06,y
         cmpx  $02,y
         bls   L0216
         cmpx  #$00EF
         bhi   L0216
         std   <u0015,u
         stx   <u0017,u
         ldd   ,y
         std   <u0011,u
         ldd   $02,y
         std   <u0013,u
L0216    bra   L0267
         ldd   #$0000
         std   <u0011,u
         std   <u0013,u
         ldd   <u003E,u
         std   <u0015,u
         ldd   #$00EF
         std   <u0017,u
         bra   L0267
         ldd   <u0015,u
         cmpd  #$01DF
         bne   L0265
         leay  <u0041,u
         lda   $01,y
         cmpa  #$07
         bhi   L0265
         ldb   ,y
         beq   L0265
         cmpb  #$04
         bhi   L0265
         decb
         ldy   #$0308
         ldx   #$0000
         pshs  u
         orcc  #$50
         ldu   >$FF80
         sty   >$FF80
         sta   b,x
         stu   >$FF80
         andcc #$AF
         puls  u
L0265    bra   L0267
L0267    clr   <u003C,u
         clr   <u0040,u
         clrb
         rts
L026F    pshs  y
         ldx   ,y
         cmpx  <u0011,u
         bcs   L02EC
         cmpx  <u0015,u
         bhi   L02EC
         ldd   $02,y
         cmpd  <u0013,u
         bcs   L02EC
         cmpd  <u0017,u
         bhi   L02EC
         ldd   #$00EF
         subd  $02,y
         tfr   b,a
         lsrb
         lsrb
         lsrb
         ldy   #$0320
         leay  b,y
         anda  #$07
         pshs  y,a
         ldb   #$08
         pshs  b
         tfr   x,d
L02A5    lslb
         rola
         cmpa  #$06
         bcs   L02AE
         suba  #$06
         incb
L02AE    dec   ,s
         bne   L02A5
         leas  $01,s
         leax  >L0048,pcr
         lda   a,x
         sta   <u001A,u
         coma
         sta   <u001B,u
         puls  x,a
         ldy   >$FF80
         orcc  #$50
         stx   >$FF80
         tfr   d,x
         lda   ,x
         ldb   <u0019,u
         cmpb  #$01
         bne   L02DC
         anda  <u001B,u
         bra   L02E4
L02DC    ora   <u001A,u
         anda  #$3F
         ora   <u0019,u
L02E4    sta   ,x
         sty   >$FF80
         andcc #$AF
L02EC    puls  pc,y
L02EE    clra
         clrb
         std   <u001E,u
         std   <u0020,u
         incb
         std   <u001C,u
         std   <u0022,u
         ldd   $04,y
         subd  ,y
         lbeq  L03A7
         bhi   L0312
         ldx   #$FFFF
         stx   <u001C,u
         coma
         comb
         addd  #$0001
L0312    std   <u0024,u
         lsra
         rorb
         std   <u0028,u
         ldd   $06,y
         subd  $02,y
         lbeq  L03C8
         bhi   L032F
         ldx   #$FFFF
         stx   <u0022,u
         coma
         comb
         addd  #$0001
L032F    std   <u0026,u
         cmpd  <u0024,u
         lbeq  L03DB
         bls   L035F
         ldx   <u0024,u
         std   <u0024,u
         lsra
         rorb
         std   <u0028,u
         stx   <u0026,u
         ldd   <u001C,u
         std   <u0020,u
         ldd   <u0022,u
         std   <u001E,u
         ldd   #$0000
         std   <u001C,u
         std   <u0022,u
L035F    lbsr  L026F
         ldx   #$0000
L0365    ldd   ,y
         addd  <u001C,u
         std   ,y
         ldd   $02,y
         addd  <u001E,u
         std   $02,y
         ldd   <u0028,u
         addd  <u0026,u
         std   <u0028,u
         bcs   L0384
         cmpd  <u0024,u
         bls   L0398
L0384    subd  <u0024,u
         std   <u0028,u
         ldd   ,y
         addd  <u0020,u
         std   ,y
         ldd   $02,y
         addd  <u0022,u
         std   $02,y
L0398    pshs  x
         lbsr  L026F
         puls  x
         leax  $01,x
         cmpx  <u0024,u
         bne   L0365
         rts
L03A7    ldd   $06,y
         subd  $02,y
         beq   L03C4
         bhi   L03B5
         ldd   #$FFFF
         std   <u0022,u
L03B5    lbsr  L026F
         ldd   $02,y
         addd  <u0022,u
         std   $02,y
         cmpd  $06,y
         bne   L03B5
L03C4    lbsr  L026F
         rts
L03C8    lbsr  L026F
         ldd   ,y
         addd  <u001C,u
         std   ,y
         cmpd  $04,y
         bne   L03C8
         lbsr  L026F
         rts
L03DB    lbsr  L026F
         ldd   ,y
         addd  <u001C,u
         std   ,y
         ldd   $02,y
         addd  <u0022,u
         std   $02,y
         cmpd  $06,y
         bne   L03DB
         rts
L03F2    clra
         clrb
         std   <u002A,u
         stx   <u002C,u
         tfr   x,d
         addd  <u002C,u
         coma
         comb
         addd  #$0001
         addd  #$0003
         std   <u0032,u
L040A    ldd   <u002A,u
         cmpd  <u002C,u
         bcc   L044B
         bsr   L0457
         ldb   <u0032,u
         bpl   L0426
         ldd   <u002A,u
         lslb
         rola
         lslb
         rola
         addd  #$0006
         bra   L043B
L0426    ldx   <u002C,u
         leax  -$01,x
         stx   <u002C,u
         ldd   <u002A,u
         subd  <u002C,u
         lslb
         rola
         lslb
         rola
         addd  #$000A
L043B    addd  <u0032,u
         std   <u0032,u
         ldx   <u002A,u
         leax  $01,x
         stx   <u002A,u
         bra   L040A
L044B    ldd   <u002A,u
         cmpd  <u002C,u
         bne   L0456
         bsr   L0457
L0456    rts
L0457    ldd   <u002A,u
         coma
         comb
         addd  #$0001
         std   <u002E,u
         ldd   <u002C,u
         coma
         comb
         addd  #$0001
         std   <u0030,u
         ldx   <u002E,u
         bsr   L04AB
         ldx   <u002E,u
         ldd   <u002C,u
         bsr   L04AB
         ldx   <u002A,u
         ldd   <u002C,u
         bsr   L04AB
         ldx   <u002A,u
         ldd   <u0030,u
         bsr   L04AB
         ldx   <u0030,u
         ldd   <u002E,u
         bsr   L04AB
         ldx   <u002C,u
         ldd   <u002E,u
         bsr   L04AB
         ldx   <u002C,u
         ldd   <u002A,u
         bsr   L04AB
         ldx   <u0030,u
         ldd   <u002A,u
         bsr   L04AB
         rts
L04AB    addd  $02,y
         std   <u001E,u
         tfr   x,d
         addd  ,y
         std   <u001C,u
         pshs  y
         leay  <u001C,u
         lbsr  L026F
         puls  pc,y
         emod
eom      equ   *
