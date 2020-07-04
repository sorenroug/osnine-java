
tylg     set   Prgrm+Objct
atrv     set   ReEnt+rev
rev      set   $00
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   1
u0001    rmb   1
u0002    rmb   1
u0003    rmb   1
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
u000E    rmb   1  number of columns
u000F    rmb   1
u0010    rmb   1
u0011    rmb   1
u0012    rmb   1
u0013    rmb   1
u0014    rmb   1
u0015    rmb   1
u0016    rmb   1
u0017    rmb   1   Pointer to M09F0
u0018    rmb   1
u0019    rmb   1
MEMPTR   rmb   2
u001C    rmb   1
u001D    rmb   1   Flag for help texts discarded
u001E    rmb   2   address of help texts routine
u0020    rmb   1
u0021    rmb   1
u0022    rmb   1
u0023    rmb   1
u0024    rmb   1
u0025    rmb   1
u0026    rmb   1
u0027    rmb   1
u0028    rmb   1
u0029    rmb   1
u002A    rmb   1
u002B    rmb   1
u002C    rmb   1
u002D    rmb   2
u002F    rmb   1
u0030    rmb   2  pointer to buffer at M0331
u0032    rmb   1
u0033    rmb   1
u0034    rmb   1
u0035    rmb   1
u0036    rmb   1
u0037    rmb   2
u0039    rmb   1
u003A    rmb   1
u003B    rmb   1
u003C    rmb   1
u003D    rmb   1
u003E    rmb   1
u003F    rmb   1
u0040    rmb   1
PARAMS   rmb   2
u0043    rmb   1
u0044    rmb   1   Contains $700
u0045    rmb   1
u0046    rmb   1
u0047    rmb   2
u0049    rmb   1
u004A    rmb   1
u004B    rmb   1
u004C    rmb   1
u004D    rmb   1
u004E    rmb   1
u004F    rmb   1
u0050    rmb   1
u0051    rmb   1
u0052    rmb   1
u0053    rmb   1
u0054    rmb   1
u0055    rmb   1
u0056    rmb   1
u0057    rmb   2
u0059    rmb   1
u005A    rmb   1
u005B    rmb   1
u005C    rmb   1
u005D    rmb   1
u005E    rmb   1
u005F    rmb   1
u0060    rmb   1
u0061    rmb   1
u0062    rmb   1
u0063    rmb   1
u0064    rmb   1
u0065    rmb   1
u0066    rmb   1
u0067    rmb   1
u0068    rmb   1
u0069    rmb   1
u006A    rmb   1
u006B    rmb   1
u006C    rmb   1
u006D    rmb   1
u006E    rmb   2
u0070    rmb   1
u0071    rmb   1
u0072    rmb   1
u0073    rmb   1
u0074    rmb   1
u0075    rmb   1
u0076    rmb   1
u0077    rmb   1
u0078    rmb   1
u0079    rmb   1
u007A    rmb   2
u007C    rmb   1
u007D    rmb   1
u007E    rmb   1
u007F    rmb   1
u0080    rmb   1
u0081    rmb   1
u0082    rmb   1
u0083    rmb   1
u0084    rmb   2
u0086    rmb   1
u0087    rmb   1
u0088    rmb   1
u0089    rmb   1
u008A    rmb   1
u008B    rmb   1
u008C    rmb   1
u008D    rmb   1
u008E    rmb   2
u0090    rmb   1
u0091    rmb   1
u0092    rmb   1
u0093    rmb   1
u0094    rmb   1
u0095    rmb   1
u0096    rmb   1
u0097    rmb   1
u0098    rmb   1
u0099    rmb   1
u009A    rmb   1
u009B    rmb   2
u009D    rmb   1
u009E    rmb   3
u00A1    rmb   1
u00A2    rmb   1
u00A3    rmb   1
u00A4    rmb   1
u00A5    rmb   2
u00A7    rmb   1
u00A8    rmb   2
u00AA    rmb   1
u00AB    rmb   1
u00AC    rmb   1
u00AD    rmb   1
u00AE    rmb   1
u00AF    rmb   1
u00B0    rmb   1
u00B1    rmb   1
u00B2    rmb   1
u00B3    rmb   1
u00B4    rmb   1
u00B5    rmb   1  Row or column mode
u00B6    rmb   1
u00B7    rmb   1
u00B8    rmb   2
u00BA    rmb   1
u00BB    rmb   1
u00BC    rmb   1
u00BD    rmb   1
u00BE    rmb   1
u00BF    rmb   1
u00C0    rmb   1
u00C1    rmb   1
u00C2    rmb   1
u00C3    rmb   1
u00C4    rmb   1
u00C5    rmb   2
u00C7    rmb   1
u00C8    rmb   1
u00C9    rmb   1
u00CA    rmb   2
u00CC    rmb   1
u00CD    rmb   1
u00CE    rmb   2
u00D0    rmb   1
u00D1    rmb   1
u00D2    rmb   1
u00D3    rmb   2
u00D5    rmb   1
u00D6    rmb   1
u00D7    rmb   2
u00D9    rmb   1
u00DA    rmb   2
u00DC    rmb   2
u00DE    rmb   1
u00DF    rmb   1
u00E0    rmb   1
u00E1    rmb   1
u00E2    rmb   1
u00E3    rmb   1
u00E4    rmb   1
u00E5    rmb   3
u00E8    rmb   1
u00E9    rmb   2  Pointer to buffer at M0280
u00EB    rmb   1
u00EC    rmb   1
u00ED    rmb   1
u00EE    rmb   1
u00EF    rmb   1
u00F0    rmb   1
u00F1    rmb   1
u00F2    rmb   1
u00F3    rmb   1
u00F4    rmb   1
u00F5    rmb   1
u00F6    rmb   1
u00F7    rmb   1
u00F8    rmb   1
u00F9    rmb   1
u00FA    rmb   1
u00FB    rmb   1
u00FC    rmb   1
u00FD    rmb   1
u00FE    rmb   1
u00FF    rmb   20
u0113    rmb   75
u015E    rmb   34
u0180    rmb   63
u01BF    rmb   211
u0292    rmb   14
u02A0    rmb   88
u02F8    rmb   7
u02FF    rmb   33
u0320    rmb   120
u0398    rmb   2
u039A    rmb   23
u03B1    rmb   7
u03B8    rmb   72
u0400    rmb   1
u0401    rmb   126
u047F    rmb   10
u0489    rmb   135
u0510    rmb   16
u0520    rmb   16
u0530    rmb   32
u0550    rmb   18
u0562    rmb   350
u06C0    rmb   64
u0700    rmb   776
u0A08    rmb   11000
size     equ   .

name     equ   *
         fcs   /Dynacalc/

DPOFFSET equ   $100

PGBEGIN  lbra  L057F
         lbra  L057F
L001B    lbra  L03EE
L001E    lbra  L0550
L0021    lbra  L0512
L0024    lbra  L0069
L0027    lbra  L04E5
L002A    lbra  L02FD
L002D    lbra  L0859
L0030    lbra  L003C
L0033    lbra  L0377
L0036    lbra  L0867
L0039    lbra  L0869

L003C    lda   #$14
         sta   <u0061
         lbsr  L08F2
         lbsr  L08D4
         dec   <u006A
         ldd   <u006A
         rts

L004B    ldb   #$0A
         cmpb  ,x
         bne   L0058
         lda   $01,x
         anda  #$F7
         sta   $01,x
         rts

L0058    stx   <u00AF
         lbsr  L0332
         subb  #$89
         stb   <u00B4
         leay  >u0489,u
         lda   >u0401,u
L0069    lbsr  L4ECD
         ldb   #$80
         sta   b,y
         ldu   <MEMPTR
         leau  >u02F8,u
         sts   <u00CE
         lbsr  L2ADB
         leau  8,u
         lbsr  L2ADB
         ldu   <MEMPTR
L0083    lbsr  L055A
         clr   <u0076
         clr   <u00D9
         clr   <u00FD
         lda   <u00D0
         beq   L00F3
         cmpa  #$08
         beq   L00C5
         sta   <u0076
         sta   <u00FE
         cmpa  #$16
         bcc   L00BB
L009C    suba  #$10
         lsla
         pshs  a
         leax  >L089F,pcr
         ldd   a,x
         leax  d,x
         puls  a
         stx   <u00D3
         cmpa  #$06
         bcs   L00B6
         lbsr  L043A
         sta   <u00F1
L00B6    lbsr  L0435
         bra   L00C7
L00BB    suba  #$22
         bcs   L00C5
         com   <u00FE
         clr   <u00FB
         bra   L00C7
L00C5    clr   <u00FE
L00C7    ldb   <u00D1
         lbsr  L03A5
         sta   <u0036
         lda   <u0076
         beq   L00EE
         cmpa  #$15
         bls   L011B
         cmpa  #$1B
         bhi   L00FB
         lbeq  L0658
         tst   <u00FE
         bne   L011B
         cmpa  #$18
         bls   L00E9
         lbsr  L06AF
L00E9    suba  #$12
         lbsr  L044A

L00EE    lbsr  L05A1
         bra   L0083

L00F3    ldb   #$80
         lbsr  L03A5
         lbra  L04B0

L00FB    suba  #$1C
         lsla
         pshs  b,a
         leax  >L08AD,pcr
         ldd   a,x
         leax  d,x
         puls  b,a
         jmp   ,x
         lbsr  L025B
         lbsr  L2AA5
         lbsr  L05A1
         decb
         ldb   b,y
         stb   <u00FD
L011A    rts
L011B    stb   <u00FF
         ldx   <u00D3
         jsr   ,x
         ldb   <u00FF
L0123    cmpb  <u00D2
         beq   L012C
         lbsr  L03A5
         bra   L011B

L012C    lda   <u0076
         suba  #$12
         bls   L00EE
         ldb   <u00F1
         leax  b,u
         deca
         beq   L015D
         deca
         bne   L0165
         stb   <u00EF
L013E    lbsr  L2ACF  Copy floating point value from X to buffer in U
         lda   <u00FD
         leax  a,u
         lbsr  L2AA5
         beq   L014F
         lda   #$03
         lbsr  L044A
L014F    lbsr  L01E9
         lda   <u00F1
         lbsr  L038F
         tst   <u00EF
         beq   L011A
         bra   L00EE

L015D    lbsr  L2AA5
         lbsr  L01E9
         bra   L00EE

L0165    deca
         lbeq  L04A3
         clr   <u00EF
         bsr   L013E
         stx   <u00F2
         lbsr  L022C
         ldx   <u00F2
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         lda   #$02
         lbsr  L044A
         leax  $08,u
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         ldx   <u00F8
         lbsr  L2AA5
         lda   #$01
         lbsr  L044A
         lbsr  L2AED
         ldx   <u00F2
         tst   <u00B3
         bne   L01A5
         lbsr  L2AA5
         lbsr  L026D
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         lda   #$01
         lbsr  L044A
         leax  $08,u
L01A5    lbsr  L2ACF  Copy floating point value from X to buffer in U
         lbsr  L2AF0
         lda   #$03
         lbsr  L044A
         lda   #$04
         lbsr  L044A
         ldb   <u00DC
         stb   <u00D1
         lda   <u00DE
         lbsr  L038F
         bsr   L01E9
         lbra  L00EE

L01C3    lda   <u00FD
         leax  a,u
         lbra  L2ACF  Copy floating point value from X to buffer in U

         tst   <u00D9
         beq   L01E5
         lda   <u00FD
         leax  a,u
         lbsr  L0301
         bhi   L01E5
L01D7    rts
         tst   <u00D9
         beq   L01E5
         lda   <u00FD
         leax  a,u
         lbsr  L0301
         bcc   L01D7
L01E5    lda   #$FF
         sta   <u00D9
L01E9    lda   <u00FD
         leax  a,u
         lbra  L2AAB

L01F0    bsr   L01C3
         clra
         lbsr  L044A
         bra   L01E9

L01F8    lbsr  L026D
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         ldb   <u00F1
         leax  b,u
         pshs  x
         lbsr  L2AA5
         clra
         lbsr  L044A
         puls  x
         lbra  L2AAB

L0210    bsr   L01F0
         bra   L01F8

         lbsr  L2AED
         bsr   L0210
         lbsr  L2AF0
         bsr   L022C
         ldx   <u00F8
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         clra
         lbsr  L044A
         ldx   <u00F8
         lbra  L2AAB

L022C    leax  $08,u
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         lda   #$02
         lbra  L044A

         lda   <u0036
         cmpa  #$0B
         lbne  L048D
         com   <u00FE
         lda   <u00D1
         sta   <u00DC
         stb   <u00D1
         lda   $08,u
         bmi   L024B
         clra
L024B    sta   <u00B3
         lbsr  L043A
         sta   <u00DE
         stx   <u00F8
         lda   #$16
         sta   <u0076
         lbsr  L009C
L025B    leax  >L2AAE,pcr
         bra   L0271

L0261    leax  >L2AEA,pcr
         bra   L0271

L0267    leax  >L2AE1,pcr
         bra   L0271

L026D    leax  >L2AE4,pcr
L0271    pshs  b,a
         ldd   ,x
         leax  d,x
         puls  pc,b,a

L0279    lda   #$09
         lbra  L0468

         pshs  b
         lda   <u0036
         cmpa  #$0B
         lbne  L048D
         tst   $08,u
         bmi   L0279
         tst   $0F,u
         beq   L0279
         lda   #$09
         sta   <u0036
         bsr   L026D
         lda   #$06
         bsr   L0303
         beq   L02BA
         bhi   L02AA
L029E    leax  $08,x
         bsr   L0305
         bcc   L02B8
         dec   <u0036
         bne   L029E
         bra   L02BA

L02AA    bsr   L0261
L02AC    leax  $08,x
         bsr   L0305
         bls   L02B8
         dec   <u0036
         bne   L02AC
         bra   L02BA

L02B8    bne   L0279
L02BA    lbsr  L2AA5
         lbsr  L05BA
         stx   <u00F8
         puls  b
         clr   <u00FE
         lbsr  L03A5
         lda   $08,u
         pshs  a
         anda  #$7F
         sta   $08,u
         ldx   <u00F8
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         lda   #$03
         lbsr  L044A
         lbsr  L0261
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         clra
         lbsr  L044A
         lbsr  L05E7
         ldx   <u00F8
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         puls  a
         anda  #$80
         ora   $08,u
         sta   $08,u
         lda   #$02
         lbsr  L044A
         lbra  L00EE

L02FD    pshs  u
         bra   L030B

L0301    lda   #$07
L0303    sta   <u0025
L0305    pshs  u
         ldu   <MEMPTR
         leau  $08,u
L030B    lda   ,u
         anda  #$80
         pshs  a
         lda   ,x
         anda  #$80
         cmpa  ,s+
         bne   L0330
         tsta
         bpl   L031E
         exg   x,u
L031E    lda   $07,u
         cmpa  $07,x
         bne   L0330
         clrb
L0325    lda   b,u
         cmpa  b,x
         bne   L0330
         incb
         cmpb  <u0025
         bne   L0325
L0330    puls  pc,u
L0332    ldu   <MEMPTR
         ldb   ,x
         pshs  u,x,b
         leau  >u0400,u
         clr   <u007D
         lsrb
         rol   <u007D
         clra
         std   <u006C
         lbsr  L1AC8
         puls  pc,u,x,b
L0349    leau  $08,u
L034B    lda   b,y
         incb
         tsta
         bmi   L035D
         pshs  u,b
         ldu   b,y
         bsr   L0375
         puls  u,b
         addb  #$02
         bra   L036E

L035D    leax  b,y
         addb  #$08
         cmpa  #$C0
         bcs   L036E
         subb  #$08
         lda   b,y
         bsr   L038F
         incb
         ldb   b,y
L036E    pshs  b
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         puls  pc,b
L0375    clr   <u0033
L0377    lbsr  L1ACB
         beq   L038B
         lda   $01,x
L037E    leax  $02,x
         bita  #$10
         bne   L038B
         bita  #$08
         lbne  L0491
         rts
L038B    lbsr  L025B
L038E    rts
L038F    pshs  a
         suba  #$20
         lsra
         lsra
         lsra
         ldx   <MEMPTR
         leax  >$02FF,x
         clr   a,x
         puls  a
         ldx   <MEMPTR
         leax  a,x
         rts
L03A5    bsr   L0349
         leau  -$08,u
         bra   L03AE

L03AB    lbsr  L0443
L03AE    clra
         cmpb  <u00D2
         bge   L038E
         lda   b,y
         anda  #$3F
         cmpa  #$04
         bcs   L03AB
         bne   L03D5
         tst   $0F,u
         bne   L03C6
         lbsr  L0589
         bra   L03AE

L03C6    lda   #$06
         lbsr  L044A
         lda   #$02
         bsr   L0443
         lda   #$05
         bsr   L044A
         bra   L03AE

L03D5    tst   <u00FE
         lbeq  L048D
         cmpa  #$0A
         bne   L038E
         tst   <u00FE
         lbmi  L048D
         pshs  u,b
         incb
         ldx   b,y
         subb  #$03
         ldd   b,y
L03EE    stx   <u006C
         stx   <u00F2
         cmpa  <u00F2
         bls   L03FA
         sta   <u00F2
         lda   <u006C
L03FA    cmpb  <u00F3
         bls   L0402
         stb   <u00F3
         ldb   <u006D
L0402    tst   <u00E0
         bne   L0439
         stb   <u00FC
L0408    std   <u00F4
         ldu   <u00F4
         lbsr  L0375
         bne   L041A
         ldu   <MEMPTR
         lbsr  L2AA5
         ldx   <u00D3
         jsr   ,x
L041A    ldd   <u00F4
         incb
         beq   L0423
         cmpb  <u00F3
         bls   L0408
L0423    ldb   <u00FC
         inca
         beq   L042C
         cmpa  <u00F2
         bls   L0408
L042C    puls  u,b
         addb  #$03
         leas  $02,s
         lbra  L0123

L0435    bsr   L043A
         sta   <u00FD
L0439    rts
L043A    lbsr  L025B
         lbsr  L2AA5
         lbra  L05BA

L0443    sta   <u0036
         lbsr  L034B
         lda   <u0036

* Important function that takes A as argument
L044A    pshs  u,x,b
         anda  #$0F
         lsla
         clr   <u0033
         leax  >L2AB1,pcr
         ldd   a,x
         pshs  y
         ldy   <MEMPTR
         leay  >$0550,y
         jsr   d,x
         puls  y
         lda   <u0033
         beq   L0484
L0468    ldb   <u00C3
         bne   L0482
         bsr   L04AA
         ldb   $01,x
         bitb  #$08
         beq   L0478
         cmpa  $02,x
         beq   L0482
L0478    sta   $02,x
         lda   $01,x
         anda  #$DF
         ora   #$08
         sta   $01,x
L0482    bra   L04DF

L0484    lbsr  L08F8 Read character from keyboard
         puls  pc,u,x,b

L0489    lda   #$03
         bra   L0468

L048D    lda   #$02
         bra   L0468

L0491    tst   <u0033
         beq   L0497
         coma
         rts
L0497    lda   #$08
         tst   ,x
         beq   L04A3
         lbmi  L038B
         bra   L0468

L04A3    clra
         bra   L0468

L04A6    lda   #$33
         bra   L0468

L04AA    lbsr  L4ED0
         ldx   <u00AF
         rts
L04B0    tst   <u00C3
         bne   L04DD
         bsr   L04AA
         ldb   #$04
         ldu   <MEMPTR
         leau  $08,u
         lda   #$FF
         leay  $02,x
L04C0    ldx   ,u++
         cmpx  ,y++
         beq   L04CA
         lda   #$DF
         stx   -$02,y
L04CA    decb
         bne   L04C0
         bsr   L04AA
         ldb   $01,x
         bitb  #$08
         beq   L04D7
         lda   #$DF
L04D7    anda  $01,x
         anda  #$F7
         sta   $01,x
L04DD    clr   <u00C3
L04DF    lds   <u00CE
         bsr   L04AA
         rts

L04E5    lbsr  L1AB3
         leau  >L05D7,pcr   String 'Recalc...'
         lbsr  L1AB9  output string pointed to in U
         ldu   <u001E
         tst   <u00B5  Row or column mode
         bne   L051F
         ldb   <u00BF
         incb
         stb   <u0086
L04FA    ldb   <u00C0
         incb
         stb   <u0087
L04FF    ldx   ,--u
         beq   L0505
         bsr   L050F
L0505    dec   <u0087
         bne   L04FF
         dec   <u0086
         bne   L04FA
         bra   L054D

L050F    lbsr  L4EB8
L0512    pshs  u
         lda   $01,x
         bita  #$10
         bne   L051D
         lbsr  L004B
L051D    puls  pc,u

L051F    ldb   <u00C0
         clra
         addd  #$0001
         stb   <u0087
         lslb
         rola
         comb
         coma
         addd  #$0001
         std   <u00BA
L0530    leau  -2,u
         stu   <u00B1
         lda   <u00BF
         inca
         sta   <u0086
L0539    ldx   ,u
         beq   L053F
         bsr   L050F
L053F    ldd   <u00BA
         leau  d,u
         dec   <u0086
         bne   L0539
         ldu   <u00B1
         dec   <u0087
         bne   L0530
L054D    lbra  L4ED3

L0550    bsr   L04E5
         lbsr  L0901
         lbsr  L1AD1
         bra   L057F

L055A    ldb   #$80
         clr   <u00D0
L055E    bsr   L0589
         cmpb  <u00B4
         bge   L056C
         lda   b,y
         anda  #$3F
         cmpa  #$09
         bne   L056F
L056C    stb   <u00D2
         rts
L056F    cmpa  #$08
         beq   L057B
         cmpa  #$10
         bcs   L055E
         cmpa  #$29
         bcc   L0582
L057B    std   <u00D0
         bra   L055E

L057F    lbra  L1A9E

L0582    lbeq  L04A3
         lbra  L04A6

L0589    lda   b,y
         incb
         cmpa  #$3F
         bls   L05A0
         addb  #$02
         cmpa  #$7F
         bls   L05A0
         addb  #$06
         cmpa  #$BF
         bls   L05A0
         subb  #$07
         ldb   b,y
L05A0    rts

L05A1    ldb   <u00D1
         decb
         lda   b,y
         ora   #$C0
         sta   b,y
         lda   <u00FD
         bne   L05B0
         bsr   L05BA
L05B0    incb
         sta   b,y
         incb
         lda   <u00D2
         inca
         sta   b,y
         rts

L05BA    clra
         leax  >u02FF,u
L05BF    inca
         cmpa  #$0B
         lbeq  L0468
         tst   a,x
         bne   L05BF
         sta   a,x
         lsla
         lsla
         lsla
         adda  #$20
         leax  a,u
         lbsr  L2AAB
         rts

L05D7    fcc   "Recalc ..."
         fcb   $00

L05E2    bsr  L05E7
         lbra  L00EE

L05E7    lda   $0F,u
         suba  #$80
         bhi   L05F1
         lbsr  L2ADB
L05F0    rts
L05F1    suba  #$38
         bcc   L05F0
         ldb   #$0E
L05F7    adda  #$08
         bgt   L0600
         clr   b,u
         decb
         bra   L05F7

L0600    suba  #$08
         beq   L05F0
         sta   <u0036
L0606    lsr   b,u
         inca
         bne   L0606
         lda   <u0036
L060D    lsl   b,u
L060F    inca
         bne   L060D
         rts

* 57.29578 is 1 radian in degrees
L0613    fcb   $65,$2E,$E0,$D3,$1E,$0F,$C4,$86   Value=57.29578

         com   <u00D9
         bsr   L05BA
         sta   <u00F1
         leax  $08,u
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         bsr   L0680
         lda   #$02
         lbsr  L044A
         lbsr  L026D
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         clra
         lbsr  L044A
         lda   #$04
         lbsr  L044A
         leax  $08,u
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         lda   <u00F1
         lbsr  L038F
         tst   $07,u
         bne   L0650
         tst   <u00D9
         bne   L066D
         bra   L0663

L0650    lbsr  L2AA5
         lda   #$03
         lbsr  L044A
L0658    lda   #$09
         lbsr  L044A
         tst   <u00D9
         beq   L066D
         bsr   L0680
L0663    lbsr  L0267
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         clra
         lbsr  L044A
L066D    tst   <u005D
         bne   L067D
         leax  >L0613,pcr
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         lda   #$02
         lbsr  L044A
L067D    lbra  L00EE

L0680    lda   $08,u
         eora  #$80
         sta   $08,u
         rts

         bsr   L06AF
         lbsr  L05BA
         lda   #$08
         lbsr  L044A
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         lbsr  L2AAB
         stx   <u006C
         leax  ,u
         lbsr  L2AA5
         ldx   <u006C
         lda   #$07
         lbsr  L044A
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         lda   #$03
         lbsr  L044A
         bra   L067D

L06AF    pshs  a
         tst   <u005D
         bne   L06C1
         leax  >L0613,pcr
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         lda   #$03
         lbsr  L044A
L06C1    puls  pc,a

         lda   #$06
         lbsr  L044A
         leax  >L06D6,pcr
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         lda   #$03
         lbsr  L044A
         bra   L067D

* ln(10) = 2.302585, also ln(x) / log(x)
L06D6    fcb   $13,$5D,$8D,$DD,$AA,$A8,$AE,$82  Value=2.302585

         lda   $08,u
         anda  #$7F
         sta   $08,u
         bra   L067D

         inc   <u00D9
         bra   L0705

         lbsr  L026D
         pshs  b
         lbsr  L2ACF  Copy floating point value from X to buffer in U
L06F2    clra
         lbsr  L044A
         lbsr  L05BA
         stx   <u00FA
         lbsr  L05BA
         stx   <u00F8
         lbsr  L0435
         puls  b
L0705    lda   <u0036
         cmpa  #$0B
         lbne  L048D
         lda   b,y
         sta   <u00FC
         anda  #$C0
         cmpa  #$40
         lbne  L048D
         incb
         ldu   b,y
         addb  #$02
         lda   b,y
         cmpa  #$4A
         lbne  L048D
         incb
         ldx   b,y
         addb  #$02
         stb   <u00B3
         tst   <u00FB
         beq   L0737
         cmpb  <u00D2
         lbne  L048D
L0737    stx   <u00F6
         cmpu  <u00F6
         bcs   L074A
         bne   L0746
         tst   <u00FB
         lbeq  L0489
L0746    stu   <u00F6
         exg   u,x
L074A    tfr   u,d
         ldx   #$0001
         cmpa  <u00F6
         beq   L075C
         cmpb  <u00F7
         lbne  L0489
         ldx   #$0100
L075C    stx   <u00F2
L075E    lbsr  L0375
         tst   <u00D9
         beq   L076E
         lda   #$06
         lbsr  L0301
         bne   L077D
         bra   L0798

L076E    tst   <u00FB
         lbne  L0804
         lbsr  L0301
         bcs   L0790
         beq   L0798
L077B    clr   <u00FC
L077D    stu   <u00F4
         ldd   <u00F2
         leau  d,u
         cmpu  <u00F6
         bls   L075E
         ldu   <MEMPTR
         tst   <u00FB
         lbne  L00EE
L0790    tst   <u00FC
         lbne  L04A3
         ldu   <u00F4
L0798    ldd   <u00F2
         exg   a,b
         stu   <u00C1
         leau  d,u
         ldb   <u00B3
         cmpb  <u00D2
         beq   L07C7
         lda   b,y
         cmpa  #$4B
         lbne  L048D
         incb
         ldx   b,y
         addb  #$02
         cmpb  <u00D2
         lbne  L048D
         tfr   x,d
         tst   <u00F2
         bne   L07C3
         ldb   <u00C2
         bra   L07C5

L07C3    lda   <u00C1
L07C5    tfr   d,u
L07C7    lbsr  L1ACB
         beq   L07F4
         lda   $01,x
         bita  #$10
         beq   L07F9
         tst   <u00C3
         bne   L07F1
         lbsr  L04AA
         lda   $01,x
         bita  #$08
         beq   L07E8
         tst   $02,x
         bpl   L07E8
         cmpu  $03,x
         beq   L07F1
L07E8    stu   $03,x
         ldu   <MEMPTR
         lda   #$FF
         lbra  L0478

L07F1    lbra  L04DF

L07F4    lbsr  L025B
         bra   L07FC

L07F9    lbsr  L037E
L07FC    ldu   <MEMPTR
         lbsr  L2AA5
         lbra  L00EE

L0804    pshs  u
         ldu   <MEMPTR
         lbsr  L2AA5
         ldx   <u00F8
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         lda   #$03
         lbsr  L044A
         lbsr  L01F0
         ldx   <u00FA
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         ldx   <u00F8
         lbsr  L2AA5
         lda   #$02
         lbsr  L044A
         lbsr  L2AAB
         puls  u
         lbra  L077B

         tst   <u00D9
         bne   L0847
         lbsr  L05BA
         stx   <u00F8
         sta   <u00D9
         lbsr  L01F8
         ldx   <u00F8
         lbsr  L0301
         lbhi  L04A3
L0846    rts
L0847    lbsr  L01E9
         lbsr  L01F8
         ldx   <u00F8
         lbsr  L0301
         bls   L0846
         leas  $02,s
         lbra  L00EE

L0859    com   <u005D
         lbsr  L04E5
         com   <u005D
         ldx   #$015D
         leau  >L0892,pcr   String 'Radian mode'
L0867    ldb   #$FF
L0869    stb   <u0025
         pshs  u,x
         lbsr  L1AB3
         ldx   <MEMPTR
         puls  u,b,a
         leax  d,x
         lbsr  L1AB9  output string pointed to in U
         clrb
         leau  >L088B,pcr
         lda   ,x
         bne   L0886
         ldb   <u0025
         leau  $04,u
L0886    stb   ,x
         lbra  L1AEC

L088B    fcc   "Off"
         fcb   0
         fcc   "On"
         fcb   0

L0892    fcc   "Radian mode "
         fcb   $00

* Table
L089F    fdb   $f951
         fdb   $f939
         fdb   $f92B
         fdb   $f959
         fdb   $f971
         fdb   $ff90
         fdb   $f975

L08AD    fdb   $fd70,$fd6e,$fdda,$fe16,$fd35,$fe31,$fe39
         fdb   $fe58,$fe3d,$f9d1,$f989,$d720

L08C5    lbra  L099B  Initialise data and terminal
L08C8    lbra  L09F1
L08CB    lbra  L1485
L08CE    lbra  L0D55
L08D1    lbra  L163E
L08D4    lbra  L0F81
L08D7    lbra  L153C
         lbra  L0F7E
         lbra  L0EE8
L08E0    lbra  L1735
L08E3    lbra  L154A
L08E6    lbra  L1798
L08E9    lbra  L0D57
L08EC    lbra  L1575
L08EF    lbra  L0C57    Display help page
L08F2    lbra  L0D95
L08F5    lbra  L1286
L08F8    lbra  L0EC3 Read character from keyboard
L08FB    lbra  L18BB
L08FE    lbra  L1710
L0901    lbra  L0A82
L0904    lbra  L0E5D
L0907    lbra  L0E8D
L090A    lbra  L1763
L090D    lbra  L17F4
         lbra  L1223
L0913    lbra  L171D
L0916    lbra  L0EC7
L0919    lbra  L0EA7
L091C    lbra  L0DE3
         lbra  L0DD3
L0922    lbra  L0D36
L0925    lbra  L0A8B  Print character
L0928    lbra  L0A98
L092B    lbra  L1043
L092E    lbra  L15D0
         lbra  L0D31
L0934    lbra  L0E44
L0937    lbra  L0E4F
L093A    lbra  L0DE8
L093D    lbra  L0DC4  print control sequence
L0940    lbra  L0E82

start    equ   *
         pshs  u,y,x,b,a
         lda   #$09
L0947    suba  #$04
         sta   <u00B3
         leax  >L098E,pcr
         os9   I$Open
         bcc   L096A
         dec   <u00B3
         bne   L0947
L0958    pshs  b
         lda   #$02
         leax  >L0983,pcr   "Can't load"
         tfr   x,y
         os9   I$WritLn
         puls  b
         os9   F$Exit
L096A    tfr   u,x       Load the Dynacalc.trm file into the memory area
         ldy   #$3200
         os9   I$Read
         bcs   L0958
         tfr   pc,x
PCSAVEPT os9   I$Close
         bcs   L0958
         ldd   #$0473    Version number
         jmp   >$0A08,u  Jump into the Dynacalc.trm code

L0983    fcc   "Can't load "
L098E    fcc   "Dynacalc.trm"
         fcb   $0D

* Initialise data and terminal
L099B    ldy   <MEMPTR  beginning of data
         ldb   #$91
         leax  >$0157,y
L09A4    clr   ,x+
         decb
         bne   L09A4
         ldb   #$3E
         leax  >$0500,y
         ldu   <u00DA
L09B1    stu   b,x
         subb  #$02
         bpl   L09B1
         ldx   <u001E
         stu   ,--x
         stx   <u00C5
         clr   <u001C
         stu   >$0580,y
         stu   >$05FE,y
         ldd   <MEMPTR
         adda  #$02
         sta   <u008C
         leau  >$0090,y   Terminal setup
         lbsr  L0DD3
         leax  >$0510,y
         stx   <u00A2
         lda   <u0006
         sta   <u0093
         ldd   #$2309
         sta   <u002D
         stb   <u0092
         stb   $08,x
         lbsr  L4EBB
         tst   <u00ED
         beq   L09F1
         lbra  L3AD8

L09F1    lds   <u0017
         lda   #$FF
         sta   <u00D5
         clr   <u00ED
         ldx   #$0700
         stx   <u0044
         clr   <u0091
         lbsr  L0D36
         clr   <u009B
         clr   <u00CC
         clr   <u00AC
         lbsr  L1AD1
         lbsr  L1ABC
         pshs  pc
         sts   <u0034
         clr   <u00BC
         tst   <u00EE
         beq   L0A20
         clr   <u00EF
         lbra  L3AEA

L0A20    ldu   <u006E
         lbsr  L1ADD
         lda   <u0091
         bne   L09F1
         inca
         sta   <u0054
         lbsr  L1B04
         tst   <u0092
         beq   L0A40
         clr   <u0092
         bsr   L0A82
         ldu   <MEMPTR  beginning of data
         leau  >M03B8,u  "Ready"
         lbsr  L1AB9  output string pointed to in U
L0A40    tst   <u00C8
         beq   L0A47
         lbsr  L0C29
L0A47    tst   <u00CC
         bne   L0A4E
         lbsr  L1ADA
L0A4E    bsr   L0A8B
         ldu   <MEMPTR  beginning of data
         leau  >M0398,u
         stu   <u0057
         clrb
         clra
         std   <u00C3
         std   <u009A
         stb   <u00E2
         stb   <u0033
         stb   <u0075
         std   <u00E0
         stb   <u0078
         stb   <u0061
         incb
         bsr   L0A98
         tst   <u0019
         lbne  L4792
         ldu   <u00A2
         ldx   -$04,u
         lbsr  L17DC
         lbsr  L0E5D
         clr   <u0060
         lbra  L0F9D

L0A82    ldx   #$011A  line 1 column 26?
L0A85    lbsr  L0D55
         lbra  L1A19

L0A8B    ldx   <MEMPTR  beginning of data
         tst   >$00F4,x
         beq   L0ABE
         ldx   #$0200
         bra   L0A85

L0A98    clra
         sta   <u0068
         sta   <u008B
         sta   <u00A5
         deca
         sta   <u00CC
         sta   <u005A
         sta   <u0060
         sta   <u0059
         sta   <u005B
         sta   <u00AD
         sta   <u00BB
         ldy   <MEMPTR  beginning of data
         sta   >$027F,y
         deca
         sta   <u005C
         ldy   <u00E9
         lbsr  L0B89
L0ABE    rts
L0ABF    pshs  b,a
         tst   <u0075
         bne   L0ACB
         ldx   #M03BE  Pointer to 'Value'
         lbsr  L0D41
L0ACB    lbsr  L0B89
         lda   #$0A
         sta   >$023F,y
         ldy   <u00E9
         sta   <u0061
         puls  b,a
         sta   <u009A
         cmpa  #$28
         lbeq  L1376
         cmpa  #$40
         lbeq  L144C
         cmpa  #$23
         lbeq  L0BC1
         cmpa  #$2D
         lbeq  L0F7E
         cmpa  #$2B
         lbeq  L0F7E
         cmpa  #$41
         lbge  L12B4
         lbra  L10D9

         ldx   #M03C4  Pointer to 'Label'
         lbsr  L0D41
         ldy   <u00E9
         lda   <u0064
         sta   <u008B
         cmpa  #$27
         lbeq  L0F81
         lbra  L0F34

         tst   <u0091
         lbne  L0BF5
         tst   <u00A5
         bne   L0ABE
         lbsr  L0D95
         cmpa  #$2E
         beq   L0B3B
         ldb   #$0A
         cmpa  #$2C
         bne   L0B58
         tst   <u0068
         bne   L0B58
L0B35    lbsr  L0D23
         lbra  L0BF5

L0B3B    tst   <u004C
         beq   L0B35
         ldb   <u0059
         incb
         ldb   b,y
         cmpa  b,y
         beq   L0B35
         tst   <u0068
         beq   L0B35
L0B4C    lbsr  L0C57
         lbsr  L0C57
         tst   <u00BB
         beq   L0B60
         ldb   #$14
L0B58    stb   <u0061
         tst   <u0075
         beq   L0B60
         bsr   L0B7B
L0B60    lbsr  L0C57
L0B63    tst   <u0054
         beq   L0B6A
         lbsr  L14F7
L0B6A    bsr   L0B89
         lbsr  L146E
         lbsr  L0D95
         tst   <u00BB
         lbne  L0F81
         lbra  L0F1E

L0B7B    ldb   #$FF
         leax  >L0B9C,pcr
L0B81    incb
         cmpa  b,x
         bne   L0B81
         lbra  L134C

L0B89    ldx   <MEMPTR  beginning of data
         leax  >$014B,x
         ldb   #$0B
         clra
L0B92    sta   b,x
         decb
         bge   L0B92
         sta   <u003A
         sta   <u002F
L0B9B    rts

L0B9C    fcb   '+,'-,'*,'/
         fcb   '^
         fcb   '>,'<,'=
         fcb   '(,'),'.,$2C,'?

L0BA9    leas  $02,s
L0BAB    lda   <u0093
         lbsr  L0DE3
         ldb   <u0059
         lda   <u005B
         decb
         stb   <u0059
         tst   <u0075
         bne   L0C06
         lbsr  L0CD7
         lbra  L0F81

L0BC1    dec   <u0059
         ldu   <u006E
         bra   L0BE4

L0BC7    cmpa  #$23
         bne   L0BF5
L0BCB    tst   <u004C
         beq   L0BF5
L0BCF    dec   <u006A
         ldu   <u006A
         bra   L0BE4

L0BD5    cmpa  #$23
         bne   L0BF5
         tst   <u0054
         beq   L0BF5
         lbsr  L14F7
         clr   <u0054
         ldu   <u0070
L0BE4    lda   #$02
         sta   <u00BD
         sta   <u0033
         sta   <u0055
         clr   <u0064
         lbsr  L0033
         lbcc  L125C
L0BF5    lda   <u0093
         lbsr  L0DE3
         tst   <u0061
         lbeq  L1937
         tst   <u0075
         lbeq  L0F81
L0C06    ldb   <u005B
         pshs  b
         ldb   <u0072
         stb   <u005B
         lbsr  L1757
         tst   <u0091
         beq   L0C22
         ldb   #$FF
         bsr   L0C85
         tst   <u0077
         bmi   L0C22
         beq   L0C22
         lbsr  L1A19
L0C22    puls  b
         lbra  L17F4

L0C27    fcb   $02,$fd

L0C29    ldy   <u00A2
         ldx   -$0A,y
         stx   -$04,y
         lbsr  L0D55
         ldx   <u007E
         bne   L0C3B
         leax  >L0C27,pcr
L0C3B    leax  $01,x
         lda   ,x
         anda  #$07
         bne   L0C45
         ora   $09,y
L0C45    sta   <u0022
         lda   -$08,y
         sta   <u0020
         sta   <u0021
         com   <u00C7
         lbsr  L1AB6
         clr   <u00C7
         clr   <u00C8
         rts

* display help page?
L0C57    tst   <u0075
         lbne  L0B9B
         pshs  x,b,a
         cmpa  <u0009
         beq   L0CC2
L0C63    clr   <u00CD
         ldb   <u005C
         cmpb  #$FE
         lbne  L0CFF
         ldb   <u005B
         incb
         lbmi  L0D8E
         sta   b,y
         stb   <u005B
         subb  <u000E
         blt   L0C80
L0C7C    bsr   L0C85
         bra   L0CBA

L0C80    lbsr  L0DE3
         bra   L0CBA

L0C85    lda   #$0D
         lbsr  L0DE8
L0C8A    lda   <u000E
L0C8C    sta   <u0077
         lbsr  L1B13
L0C91    incb
         lda   b,y
         lbsr  L0DE8
         cmpb  <u005B
         bcc   L0C9F
         dec   <u0077
         bpl   L0C91
L0C9F    lbra  L3AF3

L0CA2    ldb   <u005B
         subb  <u000E
         bpl   L0C7C
L0CA8    tst   <u005B
         ble   L0CB2
         ldb   #$FF
         bsr   L0C85
         bra   L0CB7

L0CB2    lda   #$0D
         lbsr  L0DE3
L0CB7    lbsr  L1A19
L0CBA    lda   #$FE
         sta   <u005C
         bsr   L0C9F
         puls  pc,x,b,a

L0CC2    lda   <u005B
         ldb   <u0059
         cmpa  b,y
         ble   L0CD9
         dec   <u005B
         cmpa  <u000E
         bge   L0CA2
         lda   #$D4   Destructive backspace
         lbsr  L0DC4  print control sequence
         bra   L0CBA

L0CD7    leas  -$04,s
L0CD9    sta   <u005C
         lda   b,y
         lda   a,y
         cmpa  #'(
         bne   L0CE5
         dec   <u0068
L0CE5    cmpa  #')
         bne   L0CEB
         inc   <u0068
L0CEB    bsr   L0D23
         sta   <u005B
         subb  #$40
         lda   b,y
         sta   <u0061
         lbsr  L0B89
         tst   <u005B
         bmi   L0CA8
         lbra  L0C63

L0CFF    cmpb  <u005B
         bne   L0D07
         tst   <u0055
         beq   L0CBA
L0D07    subb  <u000E
         bpl   L0CA2
         ldb   <u005B
         cmpb  <u000E
         bpl   L0CA2
         lda   <u005A
         inca
         sta   <u00BE
         bsr   L0D57
         cmpb  <u005A
         beq   L0D21
         ldb   <u005A
         lbsr  L0C8A
L0D21    bra   L0CB7

L0D23    ldb   <u0059
         incb
         lbpl  L1937
         stb   <u0059
         lda   b,y
         sta   <u005A
         rts

L0D31    ldx   #$0200
         bra   L0D39

L0D36    ldx   #$0000
L0D39    bsr   L0D55
         lbsr  L19DB
         lbra  L3AF3

* Print string at X offset in Trm-file
L0D41    stx   <u006C
         lbsr  L1AB3
         sta   <u00C4
         ldd   <u006C
         ldy   <MEMPTR  beginning of data
         leau  d,y
         lbsr  L1AB9  output string pointed to in U
         ldx   #$0200
L0D55    stx   <u00BD

* Move cursor to coord stored in u00BD
L0D57    pshs  u,x,b
         tst   <u00E0
         bne   L0D8A
         ldd   <u00BD
         cmpa  #$02
         bhi   L0D6A
         tst   <u00C4
         bne   L0D6A
         lbsr  L1B13
L0D6A    stb   <u00E5
         addd  <u000A
         ldu   <MEMPTR  beginning of data
         leau  >CURSPOS,u      Start of sequence for cursor XY
         tst   ,u
         lbmi  L1A50   Go to sequence for vt100 home
         pshs  b
         ldb   <u0010
         sta   b,u
         puls  a
         ldb   <u000C
         sta   b,u
         bsr   L0DD3
         clr   <u00E4
L0D8A    lda   #$04
         puls  pc,u,x,b

L0D8E    lda   <u0093
         bsr   L0DE3
         lbra  L0CBA

L0D95    pshs  b,a
         lda   <u0059
         ldb   <u005B
         cmpb  <u005A
         beq   L0DC2
         deca
         tst   <u0075
         beq   L0DAC
         cmpa  #$81
         lblt  L0BA9
         bra   L0DBA

L0DAC    cmpa  #$C1
         lblt  L0BA9
         suba  #$40
         ldb   <u0061
         stb   a,y
         adda  #$40
L0DBA    sta   <u0059
         ldb   <u005B
         stb   a,y
         stb   <u005A
L0DC2    puls  pc,b,a

* Print control sequence
* address of sequence is stored in register B
L0DC4    pshs  b
         tfr   a,b
         clra
         ldu   <MEMPTR  beginning of data
         leau  d,u
         puls  b
         bra   L0DD3

L0DD1    bsr   L0E24 Write char
L0DD3    lda   ,u+
         bpl   L0DD1
         clra
         exg   d,u
         cmpb  #$D4
         exg   d,u
         bls   L0DE2
         dec   <u00E4
L0DE2    rts

L0DE3    bsr   L0DE8
         lbra  L3AF3

* Output a character
L0DE8    tst   <u00E0
         bne   L0E24
         pshs  x,b,a
         cmpa  #$0A    newline
         bne   L0DF4
         inc   <u00BD   vertical pos
L0DF4    cmpa  #$0D    cariage return
         bne   L0DFC
         clr   <u00E5
         clr   <u00E4
L0DFC    cmpa  #$20    space
         bcs   L0E10
         inc   <u00E4
         cmpa  #$20
         beq   L0E10
         bsr   L0E35
         bcc   L0E10
         cmpa  b,x
         bls   L0E10
         sta   b,x
L0E10    ldx   <MEMPTR  beginning of data
         tst   >$00FA,x
         puls  x,b,a
         beq   L0E24
         cmpa  #'a
         bcs   L0E24
         cmpa  #'z
         bhi   L0E24
         anda  #$5F
* Write  char
L0E24    tst   <u00E0
         beq   L0E2C
         cmpa  #$20
         bcs   L0E33
L0E2C    anda  #$7F
         pshs  x
         lbsr  L3AE7 write char
L0E33    puls  pc,x

L0E35    lda   <u00E4
         adda  <u00E5
         ldx   <MEMPTR  beginning of data
         leax  >$00F2,x
         ldb   <u00BD   vertical pos
         cmpb  #$03
         rts

* Read the 32 byte status from path #0
L0E44    pshs  b,a
         clra
         clrb
         ldx   <u0030
         os9   I$GetStt
         puls  pc,b,a

* Restore the status to path #0
L0E4F    pshs  x,b,a
         clra
         clrb
         ldx   <u0030
         os9   I$SetStt
         puls  pc,x,b,a

L0E5A    lbsr  L0EC7
L0E5D    lbsr  L1B10
         bsr   L0E8D
         beq   L0E5A
         bsr   L0EA0
         ldb   -$01,x
         incb
         bpl   L0E6C
         clrb
L0E6C    stb   -$01,x
         lda   b,x
         cmpa  >-$0509,x

L0E74    lbeq  L479B
         cmpa  #$1B    Escape entered?
         lbeq  L1937
         tst   <u009A
         beq   L0E8C
L0E82    cmpa  #$61    Lower than 'a'?
         bcs   L0E8C
         cmpa  #$7A    Higher than 'z'?
         bhi   L0E8C
         anda  #$5F    Make it upper case
L0E8C    rts

L0E8D    bsr   L0EC3 Read character from keyboard
         bsr   L0EA0
         ldb   -$01,x
         cmpb  -$02,x
         rts

* Test for ready from keyboard
L0E96    pshs  b,a
         clra
         ldb   #$01
         os9   I$GetStt
         puls  pc,b,a

L0EA0    ldx   <MEMPTR  beginning of data
         leax  >$0600,x
         rts

* Read a character from keyboard
L0EA7    pshs  u,y,b
         clra
         ldy   #$0001
         ldu   <MEMPTR  beginning of data
         leax  >u015E,u
         os9   I$Read
         bcc   L0EBD
         cmpb  #$D3       End of file?
         beq   L0E74 .. yes
L0EBD    lda   <u005E
         anda  #$7F
         puls  pc,u,y,b

L0EC3    bsr   L0E96     Test for keyboard ready
         bcs   L0EE7  not ready
L0EC7    bsr   L0EA7   Read character
         lbsr  L479E
         bsr   L0EA0
         ldb   -$01,x
         cmpa  <u0008
         beq   L0EE3
         ldb   -$02,x
         incb
         bpl   L0EDA
         clrb
L0EDA    cmpb  -$01,x
         bne   L0EE3
         lda   <u0093
         lbra  L0DE3

L0EE3    stb   -$02,x
         sta   b,x
L0EE7    rts

L0EE8    tst   <u0091
         bne   L0EF4
         lbsr  L3AF3
         ldd   #$0002
         bsr   L0F07
L0EF4    lbsr  L0E5D
         pshs  a
         tst   <u008B
         bne   L0F05
         com   <u0060
         beq   L0F05
         bsr   L0F1E
         clr   <u0060
L0F05    puls  pc,a

L0F07    nop
         rts
         ldu   <u00A2
         ldx   -$04,u
         ldu   #$0001
         com   <u0060
         beq   L0F16
         bsr   L0F23
L0F16    lbsr  L17DC
         tfr   u,d
         bsr   L0F07
         rti

L0F1E    bsr   L0F23
L0F20    lbra  L0D55

L0F23    lda   #$02
         ldb   <u005B
         incb
         cmpb  <u000E
         bcs   L0F2E
         ldb   <u000E
L0F2E    tfr   d,x
         ldu   #$0003
         rts
L0F34    tst   <u008B
         bmi   L0F7E
         sta   <u00C8
         ldu   <u00A2
         ldb   <u005B
         incb
         ldx   -$04,u
         cmpa  <u0009
         bne   L0F48
         decb
         leax  -$01,x
L0F48    cmpb  -$08,u
         bcc   L0F7A
         bsr   L0F20
         lda   <u0064
         leax  $01,x
         cmpa  <u0009
         bne   L0F5A
         leax  -$01,x
         lda   #$20
L0F5A    stx   -$04,u
         lbsr  L0DE3
         incb
         cmpb  -$08,u
         bne   L0F75
         tst   <u00E8
         beq   L0F7A
         lda   <u0064
         ldb   <u005B
         incb
         sta   b,y
         stb   <u005B
         lda   <u0003
         bra   L0F9D

L0F75    lda   #$20
         lbsr  L0DE3
L0F7A    bsr   L0F1E
         lda   <u0064
L0F7E    lbsr  L0C57
L0F81    tst   <u0075
         beq   L0F97
         ldb   <u005B
         incb
         lda   b,y
L0F8A    stb   <u005B
         cmpa  #$2E
         bne   L0F9D
         incb
         cmpa  b,y
         beq   L0F8A
         bra   L0F9D

L0F97    lbsr  L3AF3
         lbsr  L0EE8
L0F9D    ldu   <u0057
         sta   <u0064
         clrb
         cmpa  #'E
         beq   L0FCB
         cmpa  #'e
         beq   L0FCB
         incb
         cmpa  #'A
         blt   L0FB3
         cmpa  #'[
         blt   L0FCB
L0FB3    incb
         cmpa  #$39
         bgt   L0FBC
         cmpa  #$2F
         bgt   L0FCB
L0FBC    incb
         leau  1,u
         tst   ,u
         bmi   L0FEF
L0FC3    tst   ,u
         bmi   L0FBC
         cmpa  ,u+
         bne   L0FC3
L0FCB    pshs  pc,b,a,cc
         tst   <u008B
         bne   L1034
         leax  >L1057,pcr
         addb  <u0061
         ldb   b,x
         leax  >L109D,pcr
         ldd   b,x
         pshs  pc
L0FE1    addd  ,s++
         std   $03,s
         ldx   <MEMPTR  beginning of data
         leax  >$037F,x
         stx   <u0057
         puls  pc,b,a,cc

L0FEF    tst   <u0061
         bne   L0FF7
         tst   <u008B
         beq   L0FFD
L0FF7    cmpa  <u0011 Edit from entry level
         lbeq  L17A5
L0FFD    tst   <u0043
         beq   L1011
         cmpa  #$3A
         lbeq  L099B
         cmpa  #$18
         bne   L1011
         jsr   >$F800
         lbra  L08C8

L1011    cmpa  <u0009  Edit overlay (Ctrl-O)
         bne   L101E
         tst   <u008B
         lbne  L0F34
         lbra  L0F7E

L101E    cmpa  #$20
         lbcs  L0F81
         tst   <u008B
         lbne  L0F34
         tst   <u0061
         lbne  L0F81
         ldb   #$01
         bra   L0FCB

L1034    leas  $05,s
         cmpb  #$03
         lbne  L0F34
L103C    tst   <u00AD
         bne   L1043
         lbra  L3AE4

L1043    sta   <u0088
         sty   <u0089
         ldb   <u005B
         incb
         stb   <u0074
         clrb
         lda   <u001C
         ora   #$10
         sta   <u00AE
         lbra  L1AAA

L1057    fcb   $30,$30,$32,$30,$32,$34,$3A,$38,$36,$30
         fcb   $0C,$0C,$0A,$08,$0A,$00,$1E,$14,$00,$00
         fcb   $0C,$0C,$18,$18,$18,$18,$18,$04,$18,$00
         fcb   $0A,$00,$0A,$0E,$0A,$0E,$0E,$00,$0E,$00
         fcb   $1C,$1C,$1A,$1A,$1A,$1A,$1A,$1A,$00,$00
         fcb   $00,$00,$00,$08,$12,$12,$20,$02,$16,$00
         fcb   $24,$24,$18,$22,$22,$00,$00,$00,$00,$00

L109D    fdb   L0BF5-L0FE1  ($FC14)
         fdb   L0BD5-L0FE1  ($FBF4)
         fdb   L0BC7-L0FE1  ($FBE6)
         fdb   L15C7-L0FE1  ($05E6)
         fdb   $047C
         fdb   $00F8
         fdb   $02D3
         fdb   $0140
         fdb   $F034
         fdb   $FB39
         fdb   $046B
         fdb   $05D4
         fdb   $0308
         fdb   $03BD
         fdb   $FF9D
         fdb   $0395
         fdb   $039D
         fdb   $08EC
         fdb   $02D7
         fdb   PGBEGIN-L0FE1 ($F034)
         fdb   PGBEGIN-L0FE1 ($F034)
         fdb   PGBEGIN-L0FE1 ($F034)
         fdb   PGBEGIN-L0FE1 ($F034)
         fdb   PGBEGIN-L0FE1 ($F034)
         fdb   $FB23
         fdb   $FADE
         fdb   $0AC6
         fdb   $0ACF
         fdb   $0ABA
         fdb   $093D

L10D9    ldb   #$1E
         stb   <u0061
         cmpa  #'0
         blt   L10EA
         cmpa  #'9
         bgt   L10EA
         sta   <u0053
         lbra  L0F7E

L10EA    cmpa  #'E
         beq   L1109
         cmpa  #'e
         beq   L1109
         cmpa  #'.
         bne   L1101
         tst   <u004E
         bne   L111E
         sta   <u0053
         sta   <u004F
         lbra  L0F7E

L1101    tst   <u0053
         lbeq  L0F7E
         bra   L1121

L1109    tst   <u004E
         bne   L111E
         lda   #$65
         lbsr  L0C57
         lbsr  L0D95
         clr   <u0053
         sta   <u004E
         sta   <u004F
         lbra  L0F81

L111E    lbra  L0BF5

L1121    cmpa  #',
         bne   L1129
         tst   <u0068
         beq   L111E
L1129    cmpa  #'(
         beq   L111E
         ldu   <MEMPTR  beginning of data
         leau  >u0320,u
         leax  <$10,u
         stx   <u00FD
         tfr   u,x
         lda   <u005A
         cmpa  <u005B
         beq   L111E
         tst   <u004E
         beq   L1147
         lbsr  L0D23
L1147    tst   <u0075
         beq   L114D
         dec   <u005B
L114D    bsr   L118F
         ldb   <u0050
         stb   <u003C
         cmpa  <u005B
         bhi   L111E
         deca
L1158    inca
         cmpa  <u005B
         bhi   L11BA
         ldb   a,y
         cmpb  #$2E
         bne   L1167
         stb   <u0051
         bra   L1158

L1167    cmpb  #$65
         beq   L11A3
         cmpb  #$45
         beq   L11A3
         cmpb  #$30
         bne   L117F
         tst   <u004D
         bne   L117F
         tst   <u0051
         beq   L1158
         dec   <u0052
         bra   L1158

L117F    tst   <u0051
         bne   L1185
         inc   <u0056
L1185    inc   <u004D
         cmpx  <u00FD
         beq   L1158
         stb   ,x+
         bra   L1158

L118F    inca
         lbmi  L0BA9
         ldb   a,y
         cmpb  #$2B
         beq   L118F
         cmpb  #$2D
         beq   L119F
         rts
L119F    com   <u0050
         bra   L118F

L11A3    clr   <u0050
         bsr   L118F
         deca
         cmpa  <u005B
         beq   L11BA
         lbsr  L1288
         lblt  L0BAB
         tst   <u0050
         beq   L11BB
         negb
         bra   L11BB

L11BA    clrb
L11BB    clr   ,x
         addb  <u0056
         addb  <u0052
         decb
         tfr   u,x
         stb   <u0027
         bpl   L11DB
         negb
         cmpb  #$17
         blt   L11DB
         subb  #$28
         negb
         cmpb  <u004D
         bcc   L11D8
         stb   <u004D
         clr   b,x
L11D8    ldb   <u0027
         negb
L11DB    cmpb  #$26
         lbge  L0BAB
         lda   <u004D
         cmpa  #$10
         ble   L11E9
         lda   #$10
L11E9    sta   <u004D
         cmpb  #$13
         blt   L11F1
         sta   <u004B
L11F1    ldb   <u0027
         subb  <u004D
         incb
         stb   <u0039
         pshs  y
         ldu   <MEMPTR  beginning of data
         leay  >u0550,u
         lbsr  L2AD2
         lbsr  L2AD5
         puls  y
L1208    tst   <u0075
         beq   L1230
         ldx   <u0073
         lbsr  L2AAB
         lda   #$80
         lbsr  L1365
         leax  $08,x
         lbsr  L1352
         inc   <u005B
         bra   L124B

L121F    ldb   #$20
L1221    lda   #$03
L1223    sta   <u0022
         lda   <u0020
         sta   <u0065
         stb   <u0020
         sta   <u004A
         ldu   <MEMPTR  beginning of data
         rts
L1230    bsr   L121F
         ldb   <u005A
         incb
         leax  b,y
         stx   <u00F8
         leay  >$02D0,y
         lbsr  L2AA8
         ldy   <u00F8
         clr   <u004B
         bsr   L126B
         ldb   <u0065
         stb   <u0020
L124B    ldb   #$32
         stb   <u0061
         lda   <u0064
         lbra  L0F9D

L1254    leax  >L2ADE,pcr
         ldd   ,x
         leax  d,x    X now points to the constant PI
L125C    ldy   <u00E9
         lbsr  L0D23
         ldu   <MEMPTR  beginning of data
         leau  $08,u
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         bra   L1208

L126B    ldb   <u005B
         stb   <u005C
         tfr   y,d
         ldy   <u00E9
         subd  <u00E9
         tsta
         lbne  L0BA9
         tstb
         lbmi  L0BA9
         decb
         stb   <u005B
         lbra  L0C57

L1286    lda   <u005A
L1288    clr   ,-s
         pshs  a
L128C    inc   ,s
         lda   ,s
         ldb   a,y
         subb  #$30
         bcs   L129A
         cmpb  #$09
         bls   L129D
L129A    clrb
         bra   L12A3

L129D    addb  $01,s
         stb   <u006B
         bcs   L12AF
L12A3    cmpa  <u005B
         bcc   L12B1
         lda   #$0A
         mul
         stb   $01,s
         tsta
         beq   L128C
L12AF    lda   #$F0
L12B1    leas  $02,s
L12B3    rts
L12B4    ldb   #$14
         stb   <u0061
         tst   <u0054
         lbne  L133C
         suba  #$40
         sta   <u006A
         ldb   <u004C
         beq   L12DC
         sta   <u004C
         lda   #$1A
         mul
         addb  <u004C
         beq   L12D1
         bcs   L133C
L12D1    stb   <u004C
         tsta
         bne   L133C
         inc   <u0059
         stb   <u006A
         lda   <u0064
L12DC    sta   <u004C
         lda   <u0064
         lbsr  L0C57
         lbsr  L0D95
         lbra  L0F81

         bne   L1314
         tst   <u00A5
         beq   L12F1
         lda   #$FF
L12F1    ldb   <u005A
         cmpb  <u005B
         bne   L12FE
L12F7    tst   <u004C
         bne   L133C
         lbra  L147B

L12FE    tsta
         bmi   L12B3
         cmpa  #$2E
         beq   L1307
         clr   <u004C
L1307    inc   <u0059
         tst   <u0075
         lbeq  L124B
         bsr   L133F
         lbra  L124B

L1314    tst   <u004C
         beq   L133C
         tst   <u0053
         bne   L1326
         cmpa  #$30
         beq   L1339
         sta   <u0053
         sta   <u004C
         lsl   <u004C
L1326    lbsr  L0C57
         lbsr  L1286
         bge   L1337
         tstb
         beq   L1337
         lbsr  L0D23
         lbra  L0BAB

L1337    dec   <u006B
L1339    lbra  L0F81
L133C    lbra  L0BF5

L133F    ldb   <u006A
         decb
         ldx   <u0073
         lda   #$40
         bsr   L1365
         bsr   L134E
         ldb   <u006B
L134C    ldx   <u0073
L134E    stb   ,x+
         clr   <u00AE
L1352    pshs  x
         ldx   <MEMPTR  beginning of data
         leax  >$04F3,x
         cmpx  ,s
         puls  x
         lbcs  L0BA9
         stx   <u0073
         rts
L1365    exg   d,x
         tstb
         exg   x,d
         beq   L1371
         ora   -$01,x
         sta   -$01,x
         rts
L1371    ora   <u001C
         sta   <u001C
         rts
L1376    cmpa  #$28
         bne   L133C
         inc   <u0068
         bra   L1391

         cmpa  #$29
         bne   L133C
         tst   <u0068
         beq   L133C
         dec   <u0068
         ldb   #$32
         stb   <u0061
         lbsr  L0B89
         lda   <u0064
L1391    lbsr  L0D95
         tst   <u0075
         beq   L139B
         lbsr  L0B7B
L139B    lbra  L0B60

         cmpa  #$23
         beq   L133C
         leax  >L193F,pcr   Function names
         clr   <u0076
         lda   <u005A
         inca
         leay  a,y
         suba  <u005B
         nega
         tst   <u0075
         beq   L13B5
         deca
L13B5    sta   <u0069
         ldb   ,x+
         tfr   d,u
         clrb
L13BC    lda   b,x
         cmpa  b,y
         bne   L1437
         incb
         dec   <u0069
         bge   L13BC
         lda   <u0076
         cmpa  #$1B
         lbcc  L1254
         tst   <u0075
         bne   L13DC
L13D3    lda   b,x
         sta   b,y
         incb
         bita  #$F0
         bne   L13D3
L13DC    decb
         leay  b,y
         lda   #$32
         ldb   <u0076
         cmpb  #$19
         bge   L13F3
         tst   <u0075
         bne   L13EF
         lda   #$28
         sta   ,y+
L13EF    inc   <u0068
         lda   #$0A
L13F3    sta   <u0061
         tst   <u0075
         bne   L1425
         lbsr  L126B
L13FC    lbsr  L0D95
         tst   <u0075
         beq   L1405
         inc   <u005B
L1405    lda   <u0064
         lbsr  L0D95
         cmpa  #$28
         beq   L145A
         cmpa  #$29
         beq   L141A
         tst   <u0075
         bne   L1420
         cmpa  #$0D
         bne   L1422
L141A    ldb   <u0076
         cmpb  #$19
         blt   L145A
L1420    dec   <u005A
L1422    lbra  L0F9D

L1425    ldy   <u00E9
         ldb   <u0076
         addb  #$10
         stx   <u006C
         lbsr  L134C
         ldx   <u006C
         dec   <u005B
         bra   L13FC

L1437    inc   <u0076
         ldb   <u0076
         cmpb  #$1B
         tfr   u,d
         abx
         lbls  L13B5
         inc   <u0059
         ldy   <u00E9
         lbra  L0BAB

L144C    cmpa  #$40
         bne   L14A2
         lbsr  L0C57
         ldb   #$28
         stb   <u0061
         lbsr  L0D95
L145A    lbra  L0F81

         ldb   #$0A
         cmpb  <u0061
         beq   L1479
         tst   <u0054
         bne   L147F
         cmpa  <u0007
         beq   L14A2
         lbra  L15C7

L146E    ldx   <u006E
         stx   <u0070
         ldx   <u00A2
         ldx   ,x
         stx   <u00B8
         rts
L1479    bsr   L146E
L147B    cmpa  #$0D
         beq   L14A2
L147F    cmpa  #$0D
         lbeq  L15C7
L1485    ldx   <MEMPTR  beginning of data
         leau  >$0100,x
         leax  >$0171,x
         ldb   #$FE
         stb   <u0040
L1493    cmpa  ,u+
         beq   L14A5
         comb
         bpl   L1493
         leax  -$01,x
         inc   <u0040
         bne   L1493
         bra   L14C1

L14A2    lbra  L0BF5

L14A5    tfr   b,a
         orb   #$01
         addb  ,x
         anda  #$01
         pshs  cc
         eora  ,s+
         tfr   a,cc
         bcc   L14EB
         lda   <u00A3
         leau  a,x
         cmpb  >u039A,u
         bcs   L14EB
         stb   ,x
L14C1    tst   <u0061
         beq   L14F4
         tst   <u0054
         beq   L14CC
         lbsr  L0D23
L14CC    sta   <u005C
         lda   <u005A
         sta   <u005B
         bsr   L1548
         lbsr  L0C57
         ldb   #$32
         tst   <u00BB
         beq   L14E1
         stb   <u0061
         stb   <u004C
L14E1    lbsr  L0D95
         ldu   <u0070
         bsr   L1524
         lbra  L0F81

L14EB    tst   <u0061
         bne   L14A2
         lda   <u0093
         lbsr  L0DE3
L14F4    lbra  L1A98

L14F7    pshs  y,a
         ldu   <u006E
         ldd   <u00B8
         ldy   <u00A2
         stu   $02,y
         cmpd  ,y
         beq   L1529
         cmpb  $01,y
         beq   L150D
         clr   -$05,y
L150D    cmpa  ,y
         beq   L1513
         clr   -$06,y
L1513    pshs  b,a
         lbsr  L1AE0
         puls  b,a
         std   ,y
         lbsr  L1AD1
         lbsr  L0F1E
         bra   L1538

L1524    pshs  y,a
         ldy   <u00A2
L1529    ldx   $02,y
         ldd   <u0070
         pshs  y,x,b,a
         lbsr  L1AD4
         puls  y,x,b,a
         stx   $02,y
         std   <u0070
L1538    clr   <u0075
         puls  pc,y,a

L153C    ldx   #$0000
         lbsr  L0D55
         ldx   <u006E
         stx   <u0070
         sta   <u0075
L1548    bsr   L1575
L154A    lda   <u0071
         inca
         beq   L156A
         lbsr  L2AD8
         tstb
         beq   L1568
         cmpb  #$0A
         blt   L1564
         sta   <u0036
         tfr   b,a
         lbsr  L2AD8
         bsr   L158A
         lda   <u0036
L1564    bsr   L158A
         tfr   b,a
L1568    bra   L158C

L156A    ldd   #$0502
         bsr   L158A
         bsr   L158A
         lda   #$06
         bra   L158C

L1575    ldb   <u0070
         lda   #$3F
L1579    inca
         subb  #$1A
         bcc   L1579
         cmpa  #$40
         beq   L1584
         bsr   L158E
L1584    addb  #$5B
         tfr   b,a
         bra   L158E

L158A    exg   a,b
L158C    adda  #$30
L158E    tst   <u0075
         beq   L159B
         tst   <u0078
         lbne  L171D
         lbra  L0DE8

L159B    sta   <u0054
         sta   <u0055
         pshs  b
         ldb   <u005B
         incb
         bmi   L15AC
         sta   b,y
         stb   <u005B
         puls  pc,b
L15AC    ldb   #$FE
         stb   <u005C
         leas  $05,s
         lbra  L0BAB

         sta   <u00C3
         bra   L15C7

L15B9    dec   <u005B
         lbmi  L1937
         tst   <u008B
         lbne  L103C
         clr   <u0075
L15C7    tst   <u00A5
         beq   L15CC
         rts
L15CC    tst   <u0075
         bne   L1601
L15D0    lda   <u001C
         anda  #$3F
         sta   <u001C
         lda   #$0D
         sta   <u0075
         sta   <u00AE
         ldb   <u005B
L15DE    stb   <u0072
         incb
         bpl   L15E9
         subb  #$02
         stb   <u005B
         bra   L15DE

L15E9    sta   b,y
         ldx   <MEMPTR  beginning of data
         leax  >$0400,x
         stx   <u0073
         lbsr  L0A98
         inc   <u005B
         lda   <u0064
         sta   <u0088
         lda   ,y
         lbra  L0ABF

L1601    tst   <u00C3
         lbeq  L1A95
         clr   <u0064
         tst   <u00AE
         bne   L1620
         ldu   <MEMPTR  beginning of data
         leay  >u047F,u
         ldb   <u0074
         subb  #$7F
         stb   <u00B4
         lda   <u001C
         lbsr  L0024
         bra   L1622

L1620    clr   <u00C3
L1622    lbsr  L0A98
         clr   <u0075
         tst   <u00C3
         lbeq  L1208
         clr   <u00C3
         lda   #$40
         lbsr  L0C57
         leay  $01,y
         clrb
         leax  >L19BB,pcr   String 'ERROR'
         lbra  L13D3

L163E    tfr   y,d
         addb  ,y
         adca  #$00
         std   <u007A
         ldb   #$80
         stb   <u00CD
         stb   <u008D
         ldd   <u00E9
         std   <u005B
         ldu   <MEMPTR  beginning of data
         leau  >u03B1,u
         ldb   $01,y
         stb   <u001C
         bitb  #$10
         lbne  L173F
         lda   #$FF
         sta   <u00B7
         ldb   #$0A
         leay  $02,y
         lda   #$56
         cmpb  -$02,y
         beq   L1672
         leay  $08,y
         lda   #$45
L1672    tst   <u00E1
         bne   L1679
         lbsr  L1735
L1679    ldb   <u001C
L167B    cmpb  #$40
         bcs   L16A7
         cmpb  #$80
         bcs   L16F7
         ldb   #$14
         clr   <u004B
         lbsr  L1221
         tfr   y,x
         lbsr  L2AA5
         leay  $08,y
         com   <u004A
         pshs  y
         ldy   <MEMPTR  beginning of data
         leay  >$0550,y
         lbsr  L2AA8
         puls  y
         ldb   <u0065
         stb   <u0020
         bra   L1709

L16A7    ldb   ,y+
         leax  >L0B9C,pcr
         andb  #$3F
         cmpb  #$2C
         bne   L16B5
         ldb   #$0C
L16B5    lda   b,x
         cmpb  #$10
         blt   L16CB
         subb  #$10
         clra
         leax  >L193F,pcr   Function names
L16C2    leax  a,x
         lda   ,x+
         decb
         bpl   L16C2
         lda   #'@
L16CB    bsr   L171D
         cmpa  #'.
         bne   L16D5
         bsr   L171D
         bsr   L171D
L16D5    lda   ,x+
         cmpa  #'@
         bgt   L16CB
         cmpa  #$0F
         lbgt  L16ED
         lda   -$01,y
         anda  #$3F
         cmpa  #')
         bge   L16ED
         lda   #'(
         bsr   L171D
L16ED    ldb   -$01,y
         cmpy  <u007A
         bcs   L167B
L16F4    lbra  L3AF3

L16F7    bsr   L1710
         tst   <u00BC
         beq   L1709
         bmi   L1709
         ldu   <u00FA
         lda   <u008D
         suba  #$81
         sta   ,u+
         stu   <u00FA
L1709    cmpy  <u007A
         bcc   L16F4
         bra   L16A7

L1710    stb   <u0078
         ldb   #$FF
         stb   <u0075
         ldu   ,y++
         stu   <u0070
         lbra  L1548

L171D    tst   <u008D
         bpl   L1734
         pshs  x
         ldx   <u008C
         sta   ,x
         puls  x
         inc   <u008D
L172B    tst   <u0079
         beq   L1734
         lbsr  L0DE8
         dec   <u0079
L1734    rts
L1735    sta   $03,u
L1737    lda   ,u+
         beq   L1734
         bsr   L172B
         bra   L1737

L173F    clr   <u00B7
         ldb   #$02
         cmpb  ,y
         beq   L1756
         lda   #$4C
         bsr   L1735
         leay  $02,y
L174D    lda   ,y+
         bsr   L171D
         cmpy  <u007A
         bcs   L174D
L1756    rts
L1757    lda   <u005B
         inca
         sta   <u005B
         ldb   #$20
         stb   a,y
         clr   <u00F1
         rts
L1763    ldy   <u00E9
         lda   <u008D
         suba  #$81
         sta   <u005B
L176C    ldx   #$0200
         lbsr  L0A85
         ldb   #$FF
         lbra  L0C85

L1777    lda   <u007C
         clrb
         tst   <u00AD
         bne   L1781
         ldb   <u005A
         incb
L1781    stb   <u007C
         cmpa  <u000E
         bls   L17F4
         bsr   L176C
         bra   L1777

L178B    stb   <u005B
         lda   #$20
         sta   b,y
         lbsr  L1A19
         bsr   L17DF
         bra   L17A9

L1798    clr   <u007C
         bsr   L1763
         ldx   #$0200
         bsr   L17DC
         bsr   L1757
         bra   L17A9

L17A5    bsr   L1757
         sta   <u007C

* Main data entry loop
L17A9    lbsr  L0E5D
         ldb   <u005B
         cmpa  <DOWNKEY-DPOFFSET  down-arrow
         beq   L17F4
         cmpa  <u0000  up-arrow
         beq   L1777
         ldb   <u007C
         cmpa  <u0004   home-key
         beq   L178B
         cmpa  <u0003   right-arrow
         beq   L17E2
         cmpa  <u0002   left-arrow
         beq   L17E9
         cmpa  #$0D     CR
         lbeq  L15B9
         cmpa  <u0009   back-space
         lbeq  L1869
         cmpa  <u000F  edit overlay
         lbeq  L1892
         cmpa  #$1F
         bgt   L1819   number or alpha
         bra   L17A9

L17DC    lbsr  L0D55
L17DF    lbra  L3AF3

* Move right
L17E2    incb
         cmpb  <u005B
         bhi   L17A9
         bra   L17EC

* Move left
L17E9    decb
         bmi   L17A9
L17EC    tst   <u00AD
         bne   L17F4
         cmpb  <u005A
         bls   L17A9
* Move down
L17F4    stb   <u007C
         cmpb  <u000E   number of columns
         bhi   L1800
         bne   L1806
         cmpa  <u0002   left-arrow
         bne   L1806
L1800    subb  <u000E
         decb
         lbsr  L0C85
L1806    ldb   <u007C
         cmpb  <u000E
         bls   L180E
         ldb   <u000E
L180E    lda   #$02
         tfr   d,x
         bsr   L17DC
         tst   <u00BC
         beq   L17A9
         rts

* User typed alphanumeric key
L1819    sta   <u0036
         tst   <u00F1
         beq   L1823
         cmpb  <u005B
         bne   L183E
L1823    ldb   <u005B
         cmpb  #$7F
         bcc   L185A
         incb
         stb   <u005B
         leax  $01,y
         abx
         clr   ,x
         decb
L1832    lda   b,y
         sta   ,-x
         decb
         cmpb  <u007C
         bge   L1832
         incb
         lda   <u0036
L183E    sta   b,y
         incb
         stb   <u007C
         cmpb  <u000E
         bcc   L1800
         tst   <u00F1
         beq   L185D
         decb
         lda   #$02
         tfr   d,x
         lbsr  L0D55
         inc   <u00BE
         lda   <u0036
         lbsr  L0DE3
L185A    lbra  L17A9

L185D    subb  #$02
L185F    lda   <u007C
         suba  <u000E
         nega
         lbsr  L0C8C
         bra   L1806

L1869    tst   <u00F1
         bne   L185A
         ldb   <u007C
         beq   L185A
         decb
         stb   <u007C
         ldx   <u00E9
         abx
L1877    incb
         lda   b,y
         sta   ,x+
         cmpb  <u005B
         bne   L1877
         dec   <u005B
         lda   #$DA
         lbsr  L0DC4  print control sequence
         ldb   <u007C
         cmpb  <u000E
         lbcc  L1800
         decb
         bra   L185F

L1892    ldx   #$0128
         ldu   <u00BD
         lbsr  L0D55
         tfr   u,x
         com   <u00F1
         beq   L18A9
         leau  >L18B1,pcr
         lbsr  L1AB9  output string pointed to in U
         bra   L18AC

L18A9    lbsr  L1A19
L18AC    lbsr  L17DC
         bra   L185A

L18B1    fcc   "- Overlay"
         fcb  0

L18BB    lda   #$3C
         sta   <u0061
         lbsr  L146E
         lbsr  L0D95
         clr   <u00EF
         clr   <u0075
         clr   <u00BB
         bra   L191B

         cmpa  #$0D
         beq   L18D9
         clr   <u0064
L18D3    cmpa  #$2E
         lbne  L12F7
L18D9    ldu   <u0070
         ldb   <u0054
         bne   L1900
         lbsr  L1286
         dec   <u006B
         ldb   <u0054
         orb   <u0053
         bne   L18FC
         ldu   <u006E
L18EC    stu   <u0070
         stu   <u006A
         inc   <u006A
         lda   <u005B
         sta   <u005C
         lbsr  L1548
         lbsr  L0C57
L18FC    dec   <u006A
         ldu   <u006A
L1900    stu   <u006A
         tst   <u00EF
         lbne  L0B63
         lda   #$2E
         stu   <u00B1
         sta   <u00EF
         clr   <u0059
         clr   <u005A
         lbsr  L0B4C
         ldu   <u006A
         tst   <u0064
         bne   L18EC
L191B    lbra  L0F81

         cmpa  <u0005
         bne   L1928
         ldy   <u00A2
         lbra  L1AC2

L1928    cmpa  #$21
         bne   L192F
         lbra  L001E

L192F    cmpa  #$0D
         lbne  L1AE3
         clr   <u00E3
L1937    lds   <u0034
         jmp   [,s]
         lbra  L1AB0

L193F    fcb   3
         fcc   "SUM"
         fcb   3
         fcc   "MIN"
         fcb   3
         fcc   "MAX"
         fcb   5
         fcc   "COUNT"
         fcb   7
         fcc   "AVERAGE"
         fcb   6
         fcc   "CHOOSE"
         fcb   4
         fcc   "SQRT"
         fcb   3
         fcc   "EXP"
         fcb   2
         fcc   "LN"
         fcb   3
         fcc   "SIN"
         fcb   3
         fcc   "COS"
         fcb   4
         fcc   "ATAN"
         fcb   4
         fcc   "ASIN"
         fcb   4
         fcc   "ACOS"
         fcb   3
         fcc   "TAN"
         fcb   3
         fcc   "LOG"
         fcb   3
         fcc   "INT"
         fcb   3
         fcc   "ABS"
         fcb   5
         fcc   "INDEX"
         fcb   6
         fcc   "LOOKUP"
         fcb   3
         fcc   "NPV"
         fcb   5
         fcc   "ROUND"
         fcb   6
         fcc   "STDDEV"
         fcb   2
         fcc   "LN"
         fcb   2
         fcc   "LN"
         fcb   2
         fcc   "NA"
         fcb   5
L19BB    fcc   "ERROR"
         fcb   2
         fcc   "PI"
         fcb   0

         fcb   $5F

L19C5    incb
         sta   ,x
         lda   ,-x
         adda  #$01
         daa
         sta   ,x
         suba  #$10
         bpl   L19C5
         pshs  x
L19D5    lbra  L1A19

L19D8    lbra  L19DB

L19DB    ldu   <MEMPTR  beginning of data
         leau  >$BE,u  Cursor clear to end of screen
         tst   ,u
         lbpl  L0DD3
         ldu   <u00BD
         pshs  u
         bne   L1A09
         clrb
         lda   <u000D
         deca
         tfr   d,x
         exg   a,b
         lbsr  L0D55
         lda   #$0A
L19FA    lbsr  L0DE3
         decb
         bpl   L19FA
         puls  pc,u
L1A02    sta   <u00BD
         clr   <u00BE
         lbsr  L0D57
L1A09    bsr   L1A19
         lda   <u00BD
         inca
         cmpa  <u000D
         bne   L1A02
         puls  u
         stu   <u00BD
         lbra  L0D57

L1A19    pshs  x,b
         lbsr  L0E35
         bcs   L1A24
         ldb   <u000E
         bra   L1A2F

L1A24    abx
         cmpa  ,x
         bcc   L1A4E
         ldb   ,x
         sta   ,x
         subb  ,x
L1A2F    sta   <u00BE
         ldu   <MEMPTR  beginning of data
         leau  >$B8,u   Cursor clear to EOL
         tst   ,u     Defined?
         bmi   L1A40  ..no
         puls  x,b
         lbra  L0DD3  Print control sequence

L1A40    lda   #$20   Clear line with spaces
L1A42    lbsr  L0DE8
         decb
         bne   L1A42
         lbsr  L0D57
         lbsr  L3AF3
L1A4E    puls  pc,x,b

* VT100 Escape for 'HOME'
L1A50    ldu   <u006C
         ldb   <u0025
         pshs  u,b
         ldu   <u00BD
         ldd   <u00BD
         exg   a,b
         lda   #$1B   escape
         bsr   L1A82
         lda   #$5B   '[
         bsr   L1A82
         clr   <u00BD
         bsr   L1A85
         lda   #$3B   ';
         bsr   L1A82
         tfr   u,d
         bsr   L1A85
         lda   #$48   'H
         bsr   L1A82
         clr   <u00E4
         stu   <u00BD
         lda   #$04
         puls  u,b
         stb   <u0025
         stu   <u006C
         puls  pc,u,x,b

L1A82    lbra  L0E24 Write char

L1A85    clra
         incb
         stb   <u0025
L1A89    lbra  L47A1

L1A8C    ora   <u004F
         ldb   <u0028
         beq   L1A9B
         tsta
         beq   L1A98

* Offset for menus
L1A95    lbra  L1C26
L1A98    lbra  L1E28
L1A9B    lbra  L1DF5
L1A9E    lbra  L1D0C
L1AA1    lbra  L1B3F
L1AA4    lbra  L1D5C
         lbra  L1E00
L1AAA    lbra  L1C4D
         lbra  L240D
L1AB0    lbra  L2043
L1AB3    lbra  L2013
L1AB6    lbra  L257F
L1AB9    lbra  L2234  output string pointed to in U
L1ABC    lbra  L1D8A
         lbra  L235F
L1AC2    lbra  L27F5
L1AC5    lbra  L213B
L1AC8    lbra  L1C10
L1ACB    lbra  L1BD9
L1ACE    lbra  L211C
L1AD1    lbra  L2369
L1AD4    lbra  L1E48
L1AD7    lbra  L1DB8
L1ADA    lbra  L1D6C
L1ADD    lbra  L1DDE
L1AE0    lbra  L1ED4
L1AE3    lbra  L1E22
L1AE6    lbra  L1C8E
         lbra  L1D65
L1AEC    lbra  L2123
L1AEF    lbra  L2047
L1AF2    lbra  L28E9
L1AF5    lbra  L2306
L1AF8    lbra  L2254
L1AFB    lbra  L2196
L1AFE    lbra  L1B46
L1B01    lbra  L1B6A
L1B04    lbra  L1E3F
         lbra  L21C2
L1B0A    lbra  L20E0
L1B0D    lbra  L1E11
L1B10    lbra  L1B16
L1B13    lbra  L1B1F

L1B16    tst   <u00F0
         bne   L1B5A
         bsr   L1B29
         lbra  L3AF3

L1B1F    tst   <u00F0
         beq   L1B5A
         pshs  u,a
         lda   #$8C
         bra   L1B2D

L1B29    pshs  u,a
         lda   #$88
L1B2D    tst   <u00E0
         bne   L1B36
         lbsr  L093D
         com   <u00F0
L1B36    puls  pc,u,a
L1B38    bsr   L1B3A
L1B3A    lda   #$20
* out character in A
L1B3C    lbra  L093A

L1B3F    bsr   L1B3C
         tfr   b,a
L1B43    lbra  L091C

L1B46    tfr   u,d
L1B48    bsr   L1B5B
         bcs   L1B5A
L1B4C    lslb
         rola
         bcs   L1B5A
         std   <u006C
         ldd   <u001E
         subd  <u006C
         bcc   L1B5A
         clra
         clrb
L1B5A    rts
L1B5B    std   <u006C
         mul
         addb  <u006C
         adca  #$00
         addb  <u006D
         adca  #$00
         addd  #$0001
         rts
L1B6A    lbsr  L4EC1
         lbcs  L211C
         stu   <u00F8
         ldd   <u00F8
         subb  <u00C0
         bls   L1BAD
         stb   <u00F1
         ldd   <u00BF
         std   <u00FD
         ldb   <u00F9
         stb   <u00C0
         ldd   <u00BF
         bsr   L1B48
         bsr   L1BD1
         lda   <u00FD
L1B8B    ldb   <u00F1
         ldx   <u00DA
L1B8F    stx   ,y++
         decb
         bne   L1B8F
         sta   <u00FD
         beq   L1BAD
         ldb   <u00FE
         bsr   L1B48
         tfr   d,x
         lda   <u00FE
         inca
L1BA1    ldu   ,x++
         stu   ,y++
         deca
         bne   L1BA1
         lda   <u00FD
         deca
         bra   L1B8B

L1BAD    ldu   <u00F8
         ldd   <u00F8
         suba  <u00BF
         bls   L1BD0
         deca
         ldb   <u00C0
         bsr   L1B5B
         lslb
         rola
         pshs  b,a
         ldd   <u00C5
         subd  ,s++
         bsr   L1BD1
         clra
         clrb
L1BC6    std   ,--x
         cmpx  <u00C5
         bhi   L1BC6
         tfr   u,d
         sta   <u00BF
L1BD0    rts
L1BD1    tfr   d,y
         ldx   <u00C5
         sty   <u00C5
         rts
L1BD9    tfr   u,d
         ldx   <u00DA
         pshs  y
         cmpb  <u00C0
         bhi   L1BE7
         cmpa  <u00BF
         bls   L1BEA
L1BE7    clrb
         puls  pc,y
L1BEA    stb   <u006D
         clrb
         stb   <u006C
         tsta
         beq   L1BF9
         sta   <u0067
         ldb   <u00C0
         mul
         addd  <u0066
L1BF9    addd  <u006C
         addd  #$0001
         lbsr  L1B4C
         std   <u006C
         tfr   d,y
         ldx   ,y
         beq   L1BE7
         clrb
         decb
         lbsr  L4EB8
         puls  pc,y
L1C10    ldy   <u006C
         beq   L1C1D
L1C15    ldd   ,x++
         std   ,u++
         leay  -$01,y
         bne   L1C15
L1C1D    tst   <u007D
         beq   L1C25
         lda   ,x
         sta   ,u+
L1C25    rts
L1C26    ldx   <MEMPTR  beginning of data
         leax  >$0400,x
         stx   <u0089
         leax  >L2AAE,pcr
         ldd   ,x
         leax  d,x
         tst   <u00AE
         beq   L1C3E
         clr   <u0074
         ldx   <u0089
L1C3E    ldu   <MEMPTR  beginning of data
         leau  $08,u
         lbsr  L2ACF  Copy floating point value from X to buffer in U
         clr   <u00AE
         lda   <u001C
         anda  #$EF
         ldb   #$08
L1C4D    pshs  b,a
         ldb   <u00BC
         orb   <u0091
         bne   L1C86
         tst   <u0080
         beq   L1C86
         eora  <u001C
         bita  #$10
         bne   L1C77
         lda   ,s
         bita  #$10
         bne   L1C86
         ldu   <u007E
         lda   ,u
         cmpa  #$0A
         bne   L1C73
         tst   <u0074
         beq   L1C86
         bra   L1C77

L1C73    tst   <u0074
         bne   L1C86
L1C77    tst   <u0090
         beq   L1C86
         leau  >L29E9,pcr   "Type mismatch"
         lbsr  L21C8
         lbne  L1D0C
L1C86    puls  b,a
         sta   <u001C
         addb  #$02
         addb  <u0074
L1C8E    stb   <u00FF
         lbsr  L4EC4
         lda   <u00FF
         ldb   <u001C
         andb  #$DF
         std   ,x++
         tst   <u00BC
         bmi   L1CDD
         bitb  #$10
         bne   L1CAC
         ldu   <u0089
         leau  -$08,u
         lbsr  L2AAB
         leax  $08,x
L1CAC    ldu   <u0089
         lda   <u0074
         beq   L1CD5
         tst   <u00BC
         beq   L1CBC
         tst   <u008B
         lbeq  L1D28
L1CBC    clr   <u007D
         lsra
         ror   <u007D
         sta   <u0025
         beq   L1CCD
L1CC5    ldd   ,u++
         std   ,x++
         dec   <u0025
         bne   L1CC5
L1CCD    tst   <u007D
         beq   L1CD5
         ldb   ,u+
         stb   ,x+
L1CD5    tst   <u0091
         bne   L1CDD
         tst   <u00BC
         beq   L1CDE
L1CDD    rts
L1CDE    clr   <u00C8
         tst   <u00AE
         beq   L1CEA
         lda   <u0080
         anda  <u00B7
         beq   L1CFB
L1CEA    tst   <u00B6
         beq   L1CF5
         ldx   <u007E
         lbsr  L0021
         bra   L1CFB

L1CF5    lbsr  L0027
         lbsr  L0901
L1CFB    bsr   L1D5C
         sta   <u0080
         lda   <u0088
         cmpa  #$0D
         bne   L1D14
         lda   <u00E3
         bne   L1D16
         lbsr  L1D6C
L1D0C    lds   <u0034
         lbsr  L2369
         jmp   [,s]

L1D14    sta   <u00E3
L1D16    lbra  L1DF5

L1D19    leas  $02,s
L1D1B    tfr   x,d
         stu   <u006C
         subd  <u006C
         tfr   b,a
         ldx   <u00AF
         lbra  L1CBC

L1D28    stx   <u00AF
         ldx   <MEMPTR
         leax  <$20,x
         pshs  x
         tfr   u,x
         tfr   a,b
         abx
         stx   <u0051
         ldx   <MEMPTR
         ldd   <$64,x
         subd  <u006E
         std   <u00F2
         leax  -1,u
L1D43    lbsr  L4067
         bcc   L1D19
         bsr   L1D1B
         ldd   ,u++
         tst   [,s]
         bne   L1D52
         subd  <u00F2
L1D52    std   ,x++
         inc   $01,s
         stx   <u00AF
         tfr   u,x
         bra   L1D43

L1D5C    ldx   #$0111
         lbsr  L20E3
L1D62    lbra  L4EB5

L1D65    bsr   L1D5C
         ldu   <u0068
         lbra  L1E2C

L1D6C    lda   <u000E
         inca
         sta   <u0079
         sta   <u0078
         lda   #$80
         sta   <u008D
         lbsr  L08D7
         ldy   <u007E
         beq   L1D86
         lbsr  L08D1
         lda   <u0079
         beq   L1D89
L1D86    lbsr  L1F0D
L1D89    rts
L1D8A    ldx   #$0100
         lbsr  L20E3
         leau  >L2A56,pcr   write Mode=
         lbsr  L2234  output string pointed to in U
         ldb   #',
         lda   #'C
         tst   <u00B5  Row or column mode?
         beq   L1DA1 ..column
         lda   #'R
L1DA1    lbsr  L1B3F
         lda   #'A
         tst   <u00B6
         beq   L1DAC
         lda   #'M
L1DAC    lbsr  L1B3C  output char in a
         leau  >L2A5C,pcr
         lbsr  L2234  output string pointed to in U
         bra   L1D62

L1DB8    lda   <u00ED
         beq   L1DC2
         ldx   <MEMPTR
         jmp   >M0608,x   Print out of memory

L1DC2    inca
         sta   <u00EF
         lbsr  L3AEA
         tst   <u00BC
         bpl   L1DCF
         lbsr  L1EFE
L1DCF    com   <u0054
         ldu   <u006E
         bsr   L1E2E
         bsr   L1D5C
         leau  >L2A1C,pcr  String 'OUT OF MEMORY'
         lbra  L2120

L1DDE    stu   <u006E
         lbsr  L1BD9
         lbsr  L4ECD
         stx   <u007E
         stb   <u0080
         beq   L1DF0
         ldb   $01,x
         andb  #$1F
L1DF0    clr   <u0077
         stb   <u001C
         rts
L1DF5    ldx   <u006E
         stx   <u0070
         clr   <u0061
         sta   <u0075
         lbra  L08CB

L1E00    lbsr  L20E0
         leau  >L29C8,pcr   String 'GO TO'
         lbsr  L28D9
         com   <u009A
         lbsr  L0030
         tfr   d,u
L1E11    ldx   <u00A2
         cmpa  $0A,x
         bcs   L1E1B
         cmpb  $0B,x
         bcc   L1E2C
L1E1B    leau  >L1FC0,pcr
         lbra  L2123

L1E22    ldu   <u00A2
         ldu   $0A,u
         bra   L1E2C

L1E28    ldu   <u0070
         clr   <u00D5
L1E2C    clr   <u0054
L1E2E    bsr   L1DDE
         tst   <u0080
         bne   L1E3C
         lbsr  L08D7
         lbsr  L1F0D
         bra   L1E3F

L1E3C    lbsr  L1D6C
L1E3F    ldy   <u00A2
         lda   #$FF
         sta   <u00D7
         ldu   <u006E
L1E48    stu   $02,y
L1E4A    lbsr  L2665
         bne   L1E77
         inc   <u0015
L1E51    tst   <u00D6
         bne   L1E67
         lbsr  L2369
         clr   <u0060
         ldx   <u00A2
         ldx   -$04,x
         lbsr  L20E3
         ldb   #$FF
         tst   <u0054
         beq   L1E68
L1E67    rts
L1E68    stb   <u00D5
         tst   <u00AB
         beq   L1E74
         tst   <u0077
         lbeq  L2832
L1E74    lbra  L1D0C

L1E77    stu   $0D,y
         ldd   -$06,y
         std   -$04,y
         clrb
         stb   <u00D7
L1E80    clr   -$06,y
         lda   $0D,y
         comb
         suba  ,y
         bcs   L1E97
         suba  -$02,y
         bcc   L1EA6
         lda   #$04
         anda  -$04,y
         sta   -$06,y
         lda   ,y
         sta   $0D,y
L1E97    leay  $01,y
         tstb
         bmi   L1E80
         leay  -$02,y
         ldu   $0D,y
         bsr   L1ED0
         stu   ,y
         bra   L1E51

L1EA6    tstb
         bmi   L1EB2
         lda   $0D,y
         suba  -$02,y
         inca
         sta   $0D,y
         bra   L1E97

L1EB2    lda   $0F,y
         sta   <u00B3
         sta   <u0094
         inc   $0D,y
L1EBA    lda   $0D,y
         deca
         lbsr  L2306
         bcs   L1EC8
         dec   $0D,y
         clr   <u00B3
         bra   L1EBA

L1EC8    tst   <u00B3
         beq   L1E97
         dec   $0D,y
         bra   L1E97

L1ED0    ldd   <u0097
         beq   L1EFE
L1ED4    pshs  u,x
         ldd   -$06,y
         pshs  y,b,a
         stb   <u0025
         ora   <u0025
         bne   L1EEA
         tst   -$0B,y
         bne   L1EEA
         ldb   #$F0
         stb   -$0B,y
         stb   -$0D,y
L1EEA    ldb   #$FF
         stb   -$07,y
         clr   <u0015
         clra
         lbsr  L2376
         puls  y,b,a
         clr   -$0D,y
         clr   -$0C,y
         std   -$06,y
         puls  pc,u,x
L1EFE    pshs  u,x
         ldx   #$0300
         lbsr  L20E3
         clr   <u00AC
         lbsr  L19D8
         puls  pc,u,x
L1F0D    pshs  u
         lbsr  L19D5
         lda   #$04
         puls  pc,u

CMDSTR    fcc   "Commands"
         fcb   $00

         fcb   'A
         fdb   L2037-L1A95   $05a2
         fcb   'B
         fdb   L2161-L1A95   $06cc
         fcb   'C
         fdb   L21B5-L1A95   $0720
         fcb   'D
         fdb   L4065-L1A95   $25d0
         fcb   'E
         fdb   L21F7-L1A95   $0762
         fcb   'F
         fdb   L26B0-L1A95   $0c1b
         fcb   'I
         fdb   L4065-L1A95   $25d0
         fcb   'L
         fdb   L406A-L1A95   $25d5  (Locate-Not in the manual)
         fcb   'M
         fdb   L4065-L1A95   $25d0
         fcb   'P
         fdb   L4798-L1A95   $2d03
         fcb   'Q
         fdb   L201C-L1A95   $0587
         fcb   'R
         fdb   L4065-L1A95   $25d0
         fcb   'S
         fdb   L2028-L1A95   $0593
         fcb   'T
         fdb   L202E-L1A95   $0599
         fcb   'W
         fdb   L203D-L1A95   $05a8
         fcb   '?,$80

L1F4E    fcc   "Attributes"
         fcb   0

         fcb   'B
         fdb   L20E6-L1A95   $0651
         fcb   'D
         fdb   L298F-L1A95   $0EFA
         fcb   'G
         fdb   L2945-L1A95   $0EB0
         fcb   'H
         fdb   L20D1-L1A95   $063C
         fcb   'L
         fdb   L20FC-L1A95   $0667
         fcb   'M
         fdb   L235F-L1A95   $08CA
         fcb   'O
         fdb   L2159-L1A95   $06C4
         fcb   'P
         fdb   L478D-L1A95   $2CF8
         fcb   'R
         fdb   L2155-L1A95   $06C0
         fcb   'S
         fdb   L4065-L1A95   $25d0
         fcb   'T  Type protection
         fdb   L20F2-L1A95   $065D
         fcb   'W
         fdb   L2022-L1A95   $058D
         fcb   '?,$82

L1F7F    fcc   "Formats"
         fcb   0

L1F87    fcb   'D
         fdb   L2702-L1A95   $0C6D
         fcb   'G
         fdb   L2702-L1A95   $0C6D
         fcb   'R
         fdb   L2702-L1A95   $0C6D
         fcb   'L
         fdb   L2702-L1A95   $0C6D
         fcb   'P
         fdb   L2702-L1A95   $0C6D
         fcb   'I
         fdb   L2702-L1A95   $0C6D
         fcb   '$
         fdb   L2702-L1A95   $0C6D
         fcb   'C
         fdb   L2702-L1A95   $0C6D
         fcb   '?,$88

L1FA1    fcc   "Windows"
         fcb   $00

         fcb   'D
         fdb   L2105-L1A95   $0670
         fcb   'F
         fdb   L26CE-L1A95   $0C39
         fcb   'H
         fdb   L2726-L1A95   $0C91
         fcb   'N
         fdb   L280D-L1A95   $0D78
         fcb   'S
         fdb   L2832-L1A95   $0D9D
         fcb   'U
         fdb   L2852-L1A95   $0DBD
         fcb   'V
         fdb   L273F-L1A95   $0CAA
         fcb   '?,$8A

L1FC0    fcc   " In "
L1FC4    fcc   "Titles"
         fcb   $00

         fcb   'B
         fdb   L2793-L1A95   $0CFE
         fcb   'H
         fdb   L2795-L1A95   $0D00
         fcb   'N
         fdb   L27CB-L1A95   $0D36
         fcb   'V
         fdb   L2797-L1A95   $0D02
         fcb   '?,$8C

L1FD9    fcc   "System"
         fcb   $00

         fcb   'C
         fdb   L2967-L1A95   $0ED2   change directory
         fcb   'L
         fdb   L2986-L1A95   $0EF1
         fcb   'S
         fdb   L2989-L1A95   $0EF4
         fcb   'X
         fdb   L298C-L1A95   $0EF7   fork
         fcb   '#
         fdb   L478D-L1A95   $2CF8
         fcb   '?,$8E

L1FF1    fcc   "Column width"
         fcb  0

         fcb  'C
         fdb  L2857-L1A95   $0DC2
         fcb  'W
         fdb  L2918-L1A95   $0E83
         fcb  '?,$90

L2006    fcc   "Quit"
         fcb  0

         fcb  'O
         fdb  L218E-L1A95   $06F9
         fcb  'S
         fdb  L21AC-L1A95   $0717
         fcb  '?,$92

L2013    ldx   #$011A
         lbsr  L21E6
         sta   <u0092
         rts

L201C    leau  >L2006,pcr    "Quit"
         bra   L2047

L2022    leau  >L1FF1,pcr    "Column width"
         bra   L2047

L2028    leau  >L1FD9,pcr    "System"
         bra   L2047

L202E    leau  >L1FC4,pcr    "Titles"
         ldy   <u00A2
         bra   L2047

L2037    leau  >L1F4E,pcr   Attributes
         bra   L2047

L203D    leau  >L1FA1,pcr   Windows
         bra   L2047

L2043    leau  >CMDSTR,pcr   String 'Commands'
L2047    bsr   L2013
         sta   <u009A
         clr   <u00E3
L204D    lbsr  L2234  output string pointed to in U
         stu   <u008E
         lda   #':
         lbsr  L1B3C  output char in A
L2057    lda   0,u
         cmpa  #'?  Is this help commmand?
         bne   L2061 ..no
         tst   <u001D  help texts discarded?
         bne   L2064
L2061    lbsr  L1B3C  output char in A
L2064    leau  3,u
         cmpa  #'?   help is last
         bne   L2057 not at last char
         lbsr  L20DD  Has now listed all command characters
         lbsr  L3AF3
L2070    lbsr  L0904
         clrb
         ldx   <u008E
L2076    cmpa  ,x+
         bne   L2092
         cmpa  #'?    help command?
         beq   L20A1 .. yes
         tfr   x,u
         pshs  pc,b,a
         ldd   ,x
         leax  >L1A95,pcr
         pshs  x
         addd  ,s++
         tfr   u,x
         std   $02,s
         puls  pc,b,a

L2092    incb
         leax  $02,x
         tst   -$02,x
         bpl   L2076
         ldb   -$03,x
         cmpb  #$3F
         bne   L2076
         bra   L2070

L20A1    tst   <u001D    texts discarded?
         bne   L20AD  ..yes
         ldu   <u001E
         pshs  u
         jsr   [,s++]
         bra   L2070

L20AD    leau  >L20BC,pcr   String 'helps not available'
         lbsr  L2234  output string pointed to in U
         lbsr  L213B
         lbsr  L0925
         bra   L2070

L20BC    fcc   "HELPS NOT AVAILABLE."
         fcb 0

L20D1    tst   <u001D  help texts discarded?
         lbne  L215E
         ldu   <u001E
         leau  $03,u
         tfr   u,pc

L20DD    lbsr  L1F0D
L20E0    ldx   #$0200
L20E3    lbra  L08CE

* Toggle Bell
L20E6    ldx   #$0193
         leau  >L29C0,pcr  String 'Signal'
         ldb   <u0006
         lbra  L0039

* Tupe protection
L20F2    ldx   #$0190
         leau  >L29D0,pcr  String 'Protection'
L20F9    lbra  L0036

L20FC    ldx   #$01E8
         leau  >L29DC,pcr  String 'Label entry'
         bra   L20F9

L2105    ldb   <u00A3
         lda   #$05
         ldx   #$FFF2
         leax  d,x
         leau  >L29F7,pcr  String 'Formula dump'
         com   <u00E1
         lbsr  L20F9
         clr   <u00E1
         lbra  L235F

L211C    leau  >L2A05,pcr  String 'Cell table overflow'
L2120    lbsr  L2013
L2123    lbsr  L2234  output string pointed to in U
         lbsr  L21E9
L2129    bsr   L213B
         tst   <u00E1
         beq   L2130
         rts

L2130    tst   <u00BC
         beq   L215E
         clr   <u0091
         lbsr  L0027
         bra   L215E

* Wait for input
L213B    pshs  y
         lbsr  L3AF3
         ldy   #$1000
L2144    ldx   #$0001
         os9   F$Sleep
         lbsr  L0907   Read character
         bne   L2153
         leay  -$01,y
         bne   L2144
L2153    puls  pc,y

L2155    com   <u00B6
         bra   L215B

L2159    com   <u00B5  Row or column mode
L215B    lbsr  L1D8A
L215E    lbra  L1D0C

* Attributes B
L2161    tst   <u0080
         beq   L215E
         leau  >L2A4B,pcr  "Blank cell"
         lbsr  L21C8
         bne   L215E
L216E    lda   #$0D
         sta   <u0088
         lda   <u001C
         ora   #$10
         clrb
         stb   <u0074
         sta   <u00AE
         lbra  L1C4D

L217E    fcc   "Clear Worksheet"
         fcb 0

* Quit
L218E    leau  >L2006,pcr
         bsr  L21C8
         bne  L215E

L2196    clr   <u00ED
         clr   <u00EE
         lbsr  L0922
         lbsr  L3AED
         lda   #$A0
         lbsr  L093D
         clrb
         lbsr  L3AF3
         os9   F$Exit

L21AC    lbsr  L0922
         lbsr  L0919
         lbra  L08C8

L21B5    leau  >L217E,pcr   "Clear worksheet"
         bsr   L21C8
         lbeq  L08C5 Initialise data and terminal
         lbra  L1D0C

L21C2    leau  >L21E1,pcr
         bra   L21D1

L21C8    lbsr  L2013
         bsr   L2234  output string pointed to in U
         leau  >L21DE,pcr    "Sure?"
L21D1    bsr   L2234  output string pointed to in U
         lbsr  L1F0D
         sta   <u009A
         lbsr  L0904
         cmpa  #'Y
         rts

L21DE    fcc   ": S"
L21E1    fcc   "ure?"
         fcb   $00

L21E6    lbsr  L20E3
L21E9    lbra  L1F0D

L21EC    lda   #$20
         bra   L21F3

L21F0    lbsr  L1B3C  output char in a
L21F3    decb
         bpl   L21F0
         rts

* Attribute E
L21F7    tst   <u0080
         lbeq  L215E
         tst   <u00CD
         bne   L2204
         lbsr  L1D6C
L2204    lbsr  L2013
         leau  >L299E,pcr
         bsr   L2234  output string pointed to in U
         leau  >L29A6,pcr
         ldx   <u007E
         ldb   ,x
         cmpb  #$02
         beq   L223E
         ldb   $01,x
         bitb  #$10
         beq   L2227
         stb   <u008B
         clr   <u009A
         leau  >L29AC,pcr
L2227    bsr   L2234  output string pointed to in U
         lbsr  L20DD
         clr   <u00CD
         lbra  L08E6

L2231    lbsr  L1B3C  output char in a
L2234    lda   ,u+
         bne   L2231
         lbra  L3AF3

L223B    lbsr  L2369
L223E    lbra  L1D0C

L2241    bne   L2245
L2243    ldb   <u000E
L2245    subb  #$04
         stb   <u0094
L2249    rts
L224A    ldu   $04,y
         stu   ,y
         stu   $02,y
         clra
         clrb
         std   $06,y
L2254    lda   #REVON   Location of reverse on
         bsr   L22C6
         lbsr  L234E
         ldb   <u0098
         bsr   L2241
         lda   #$03
         sta   <u0075
         clr   <u0078
L2265    sta   <u00BD
         clr   <u00BE
L2269    lda   -$06,y
         anda  <u00AC
         bne   L22A2
         lbsr  L2303
         ldb   #$04
         lbsr  L21EC
         lda   $06,y
         beq   L2285
         sta   <u0096
         lda   $04,y
         sta   <u0070
         bsr   L22C9
         bne   L224A
L2285    lda   <u0094
         cmpa  #$03
         bcs   L224A
         sta   $0F,y
         tst   <u009B
         bne   L2249
         lda   ,y
         sta   <u0070
         clr   -$02,y
         clr   <u0096
         bsr   L22C9
         ldb   <u0021
         beq   L22A2
         lbsr  L21EC
L22A2    cmpy  <u004D
         bne   L22C4
         ldy   <u004F
         lda   <u0098
         bne   L22B8
         lda   <u0097
         beq   L22C4
         bsr   L2243
         adda  #$04
         bra   L2265

L22B8    sta   <u00BE
         ldb   <u0098
         subb  <u000E
         negb
         lbsr  L2245
         bra   L2269

L22C4    lda   #REVOFF   Location of reverse off
L22C6    lbra  L093D

L22C9    clr   -$02,y
L22CB    lda   <u0070
         bsr   L2306
         bcc   L22D9
         tst   -$02,y
         bne   L22F6
         clr   <u0096
         clr   <u0094
L22D9    inc   -$02,y
         bsr   L2331
         lda   #'[
         lbsr  L1B3C  output char in a
         bsr   L22F7
         lbsr  L08EC
         ldb   <u0099
         bsr   L22F7
         lda   #']
         lbsr  L1B3C  output char in a
         inc   <u0070
         dec   <u0096
         bne   L22CB
L22F6    rts
L22F7    decb
         beq   L22F6
         cmpb  #$04
         lbra  L21EC

         addb  <u00BE
         stb   <u00BE
L2303    lbra  L08E9
L2306    clr   <u00BA
         ldx   <MEMPTR
         leax  >$0580,x
         stx   <u0046
L2310    ldb   ,x+
         beq   L231C
         cmpa  ,x+
         bne   L2310
         com   <u00BA
         subb  $08,y
L231C    addb  $08,y
         stb   <u0021
         stb   <u0020
         ldb   <u0094
         subb  <u0021
         bcc   L232E
         lda   <u0094
         sta   <u0020
         sta   <u0021
L232E    stb   <u0094
         rts
L2331    ldb   <u0021
         lsrb
         decb
         stb   <u0025
         adcb  #$00
         stb   <u0099
         lda   <u0070
         suba  #$1A
         bcc   L234B
         inc   <u0099
         cmpb  <u0025
         beq   L234B
         stb   <u0025
         dec   <u0099
L234B    ldb   <u0025
         rts
L234E    ldy   <MEMPTR
         leay  >$0530,y
         sty   <u004F
         leay  <-$20,y
         sty   <u004D
         rts
L235F    clr   <u00AC
         lbsr  L19D8
         lbra  L223B

L2367    leas  $04,s
L2369    lbsr  L1B1F
         lbsr  L4ECD
         tst   <u009B
         bne   L2376
         lbsr  L2254
L2376    clra
         bsr   L234E
         ldb   #$01
         stb   <u0075
         sta   <u00BE
L237F    sta   <u0095
         ldb   <u0097
         bne   L2389
         ldb   <u000D
         subb  #$04
L2389    stb   <u009E
         ldb   #$03
         stb   <u00BD
L238F    clr   <u00FE
         lda   <u00AC
         anda  -$05,y
         sta   -$05,y
         lda   $07,y
         beq   L23A5
         sta   <u00A1
         ldb   $05,y
         stb   <u00F9
         bsr   L23EE
         beq   L23E0
L23A5    lda   <u009E
         sta   -$01,y
         lda   $01,y
         sta   <u00F9
         clr   <u00A1
         com   <u00FE
         bsr   L23EE
         lda   #$04
         sta   -$06,y
         sta   -$05,y
         ldb   -$0B,y
         andb  -$07,y
         stb   -$0B,y
         lda   #$F0
         sta   -$0D,y
         clr   -$07,y
         cmpy  <u004F
         beq   L23E0
         ldy   <u004F
         lda   <u0097
         beq   L23DC
         suba  <u000D
         coma
         suba  #$04
         sta   <u009E
         inc   <u00BD
         bra   L238F

L23DC    lda   <u0098
         bne   L237F
L23E0    lda   #$FF
         sta   <u00AC
         clr   <u00C7
         clr   <u0015
         lbsr  L4ED0
         lbra  L3AF3

L23EE    tst   <u00E0
         beq   L23F5
         lbsr  L478F
L23F5    clr   <u009D
         clr   <u007D
         lda   -$05,y
         adda  <u0095
         sta   <u00BE
         inc   <u00BD
         tst   <u009B
         bne   L2443
         tst   -$05,y
         bne   L2443
         ldb   <u00D5
         andb  -$07,y
L240D    beq   L2415
         adda  #$04
         sta   <u00BE
         bra   L2443

L2415    clr   <u0078
         lbsr  L2303
         sta   <u007D
         lda   #$C4
         lbsr  L093D
         lda   <u00F9
         sta   <u0071
         cmpa  #$62
         bhi   L2433
         ldb   #$01
         cmpa  #$08
         bhi   L2430
         incb
L2430    lbsr  L21EC
L2433    ldb   #$04
         lbsr  L2541
         lbsr  L08E3
         lda   #'-
         lbsr  L1B3C  output char in a
         lbsr  L22C4
L2443    lda   <u00FE
         coma
         ora   -$05,y
         sta   <u00A4
         clr   <u00FD
         lda   $06,y
         beq   L245E
         sta   <u00A8
         sta   <u0096
         lda   #$80
         sta   <u0094
         lda   $04,y
         sta   <u00F8
         bsr   L2485
L245E    clr   <u00A8
         lda   $0F,y
         sta   <u0094
         com   <u00FD
         lda   ,y
         sta   <u00F8
         lda   <u00A4
         anda  -$06,y
         sta   <u00A4
         lda   -$02,y
         sta   <u0096
         bsr   L2485
         inc   <u00F9
         dec   <u009E
         beq   L2484
         dec   <u00A1
         lbne  L23EE
         dec   <u00A1
L2484    rts
L2485    lda   <u00F8
         lbsr  L2306
         ldu   <u00F8
         cmpu  $02,y
         bne   L24A4
         cmpy  <u00A2
         bne   L24A4
         ldb   <u009D
         addb  <u00BE
         lda   <u00BD
         std   -$04,y
         std   -$0A,y
         ldb   <u0020
         stb   -$08,y
L24A4    tst   <u0015
         bne   L24C3
         lbsr  L1BD9
         beq   L24C3
         stb   <u00C7
         leax  $01,x
         lda   ,x
         tst   <u00A4
         beq   L24CB
         tst   <u00AC
         beq   L24CB
         tst   -$07,y
         bne   L24C3
         bita  #$20
         beq   L24CB
L24C3    ldb   <u009D
         addb  <u0020
         stb   <u009D
         bra   L24E9

L24CB    ldb   <u0097
         orb   <u0098
         beq   L24DB
         cmpy  <u004F
         beq   L24DB
         lbsr  L266D
         beq   L24DF
L24DB    ora   #$20
         sta   ,x
L24DF    anda  #$07
         bne   L24E5
         ora   $09,y
L24E5    sta   <u0022
         bsr   L2546
L24E9    inc   <u00F8
         beq   L24F3
         dec   <u0096
         lbne  L2485
L24F3    tst   <u00A8
         bne   L253E
         lbsr  L0907
         beq   L253E
         incb
         lda   b,x
         cmpa  <u0000  Up-arrow
         beq   L250F
         cmpa  <u0001  Down-arrow
         beq   L250F
         cmpa  <u0002  Left-arrow
         beq   L250F
         cmpa  <u0003  Right-arrow
         bne   L253E
* Arrow key was entered
L250F    ldb   -$07,y
         orb   <u00D5
         bne   L253E
         cmpy  <u00A2
         bne   L253E
         clr   <u00C7
         lda   <u0054
         com   <u00D6
         ldx   <u00BD
         pshs  u,x,a
         lbsr  L0904
         lbsr  L1DF5
         clr   <u00D6
         puls  u,x,a
         sta   <u0054
         stx   <u00BD
         lda   <u00D7
         lbeq  L2367
         clr   <u004A
         clr   <u0078
         clr   <u0015
L253E    rts

L253F    ldb   <u0020
L2541    addb  <u00BE
         stb   <u00BE
         rts
L2546    ldu   -$0D,y
         bne   L2551
         tst   -$07,y
         beq   L2551
         leas  $02,s
         rts
L2551    ldb   <u009D
         beq   L256A
         tst   <u00E0
         beq   L2561
L2559    lbsr  L1B3A
         decb
         bne   L2559
         bra   L2566

L2561    bsr   L2541
L2563    lbsr  L2303
L2566    sta   <u007D
         clr   <u009D
L256A    tst   <u007D
         beq   L2563
         bsr   L253F
         tst   -$07,y
         beq   L257B
         leau  -1,u
         stu   -$0D,y
         lbra  L25FC

L257B    leau  1,u
         stu   -$0D,y
L257F    lda   ,x
         bita  #$10
         bne   L25F6
         tst   -$0E,y
         beq   L25A7
         pshs  y
         lda   <u0020
         sta   <u00E1
         deca
         sta   <u0079
         clr   <u00C7
         leay  -$01,x
         lbsr  L1B3A
         lbsr  L08D1
         clr   <u00CD
         clr   <u00E1
         ldb   <u0079
         lbsr  L21EC
         puls  pc,y
L25A7    bita  #$08
         bne   L25C1
         ldu   <MEMPTR
         leax  $01,x
         lbsr  L2AA5
         clr   <u004B
         clr   <u004A
         pshs  y
         leay  >u0550,u
         lbsr  L2AA8
         puls  pc,y

L25C1    tst   $01,x
         bmi   L25EF
         ldb   <u0020
         subb  #$04
         lsrb
         stb   <u0020
         adcb  #$00
         lbsr  L21EC
         lda   #'>
         lbsr  L1B3C  output char in a
         lda   $01,x
         cmpa  #$0C
         bls   L25DE
         lda   #$0C    General error
L25DE    lsla
         leau  >L264B,pcr
         ldd   a,u
         lbsr  L1B3F
         lda   #'<
         lbsr  L1B3C  output char in a
         bra   L25FC

L25EF    ldu   $02,x
         lbsr  L1BD9
         leax  $01,x
L25F6    ldb   -$01,x
         subb  #$02
         bne   L2601
L25FC    ldb   <u0020
         lbra  L21EC

L2601    lda   <u0022
         cmpa  #$07
         beq   L2633
         clr   <u0025
         subb  <u0020
         bcc   L261F
         negb
         stb   <u0025
         cmpa  #$02
         bne   L2619
         clr   <u0025
         lbsr  L21EC
L2619    ldb   -$01,x
         subb  #$02
         stb   <u0020
L261F    ldb   <u0020
         leax  $01,x
L2623    lda   ,x+
         lbsr  L1B3C  output char in a
         decb
         bne   L2623
         ldb   <u0025
         beq   L2632
         lbsr  L21EC
L2632    rts
L2633    leax  $01,x
         stx   <u006C
L2637    ldb   -$02,x
         subb  #$02
L263B    lda   ,x+
         lbsr  L1B3C  output char in a
         dec   <u0020
         beq   L2632
         decb
         bne   L263B
         ldx   <u006C
         bra   L2637

L264B    fcc   "NAD0SNRNOVNRLNEXREAEXAHOER"  Error codes

L2665    pshs  y,b,a
         lda   #$FF
         sta   <u007C
         bra   L2678

L266D    pshs  y,b,a
         leay  <$20,y
         bra   L2676

         pshs  y,b,a
L2676    clr   <u007C
L2678    stu   $0D,y
         ldb   #$FE
L267C    lda   $06,y
         beq   L2690
         tst   <u007C
         bne   L2690
         adda  $04,y
         cmpa  $0D,y
         bls   L2690
         lda   $04,y
         cmpa  $0D,y
         bls   L269D
L2690    lda   ,y
         cmpa  $0D,y
         bhi   L26A4
         adda  -$02,y
         deca
         cmpa  $0D,y
         bcs   L26A4
L269D    leay  $01,y
         incb
         stb   <u0025
         bne   L267C
L26A4    stb   <u0025
         puls  pc,y,b,a

L26A8    lda   <u0093
         lbsr  L1B43
         lbra  L1D0C

L26B0    ldu   <MEMPTR
         leay  >u0113,u
         lbsr  L2013
         bsr   L26DD
         tst   <u0080
         lbeq  L216E
         ldx   <u007E
         lda   $01,x
         anda  #$D8
         ora   <u0025
         sta   $01,x
         lbra  L1D0C

L26CE    ldy   <u00A2
         lbsr  L2013
         inc   <u00E1
         bsr   L26E1
         com   <u00AC
         lbra  L1D0C

L26DD    tst   <u0080
         beq   L26FB
L26E1    leau  >L2A2D,pcr
         lbsr  L2234  output string pointed to in U
         ldb   $09,y
         leax  >L1F87,pcr
         andb  #$07
         lda   #$03
         mul
         lda   b,x
         lbsr  L1B43
         lbsr  L1B38
L26FB    leau  >L1F7F,pcr
         lbra  L204D

* Set format of cell
L2702    lda   $09,y
         anda  #$F8
         stb   <u0025
         ora   <u0025
         sta   $09,y
         rts

L270D    ldd   <u0097
         bne   L278C
         ldu   <MEMPTR
         leay  >u0510,u
         leau  <$10,y
         lda   #$20
L271C    clr   ,u+
         deca
         bne   L271C
         ldd   $08,y
         std   -$08,u
         rts

L2726    bsr   L270D
         ldb   -$04,y
         incb
         cmpb  <u000D
         bcc   L278C
         subb  #$05
         bls   L278C
         stb   <u0083
         lda   ,y
         ldb   $03,y
         cmpb  $01,y
         bls   L278C
         bra   L275F

L273F    bsr   L270D
         ldb   -$03,y
         beq   L278C
         stb   <u0083
         subb  <u000E
         negb
         subb  #$03
         stb   <u0094
         lda   $02,y
         lbsr  L2306
         bcs   L278C
         lda   $02,y
         cmpa  ,y
         beq   L278C
         ldb   $01,y
         leay  $01,y
L275F    ldu   <MEMPTR
         leau  >u0530,u
         std   ,u
         lda   $06,y
         sta   <$26,y
         lda   $04,y
         sta   <$24,y
         lda   $0A,y
         sta   <$2A,y
         ldb   <u0083
         stb   >-$0379,y
         leax  <-$20,u
         stu   <u00A2
         ldd   $02,x
         std   2,u
         ldd   ,x
         std   $02,x
         lbra  L235F

L278C    leau  >L29B4,pcr  "NOT VALID"
         lbra  L2123

L2793    bsr   L27A9
L2795    leay  $01,y
L2797    bsr   L27A9
L2799    ldy   <u00A2
         clr   -$06,y
         lbsr  L2254
         ldy   <u00A2
         com   -$06,y
L27A6    lbra  L1D0C

L27A9    tst   $06,y
         bne   L278C
         lda   $02,y
         suba  ,y
         beq   L278C
         sta   $06,y
         suba  -$02,y
         nega
         sta   -$02,y
         lda   ,y
         sta   $04,y
         lda   $02,y
         sta   ,y
         ldu   <u00A2
         ldd   $04,u
         addd  $06,u
         std   $0A,u
         rts

L27CB    ldu   <u00DA
         ldd   $06,y
         stu   $06,y
         ldx   $0A,y
         stu   $0A,y
         cmpx  ,y
         bne   L27E3
         ldu   $04,y
         stu   ,y
         addd  -$02,y
         std   -$02,y
         bra   L2799

L27E3    stu   -$06,y
         lbra  L235F

L27E8    ldd   <u00A2
         cmpb  #$30
         bne   L27F0
         ldb   #$F0
L27F0    addb  #$20
         tfr   d,y
         rts
L27F5    ldu   <u0097
         beq   L27A6
         bsr   L27E8
         stb   <u00A3
         ldu   $02,y
         lbsr  L2665
         lbeq  L1E2C
         ldu   ,y
         stu   $02,y
         lbra  L1E2C

L280D    ldb   <u00A3
         cmpb  #$10
         beq   L2829
         ldu   <MEMPTR
         leau  >u0520,u
         leax  <-$20,u
         ldb   #$20
L281E    lda   b,u
         sta   b,x
         decb
         bne   L281E
         ldb   #$10
         stb   <u00A3
L2829    clr   <u0098
         clr   <u0097
         clr   <u00AB
         lbra  L235F

L2832    ldu   <u00A2
         bsr   L27E8
         tfr   d,x
         sta   <u0077
         ldd   <u0097
         beq   L2854
         tstb
         beq   L2845
         leau  1,u
         leax  $01,x
L2845    lda   2,u
         sta   $02,x
         ldu   $02,y
         lda   #$FF
         sta   <u00AB
         lbra  L1E4A

L2852    clr   <u00AB
L2854    lbra  L1D0C

L2857    ldb   #$43
         lbsr  L28C5
         lda   <u006E
         lbsr  L2306
         lda   -$02,x
         stx   <u00B8
         ldx   <u0046
         leau  <$40,x
         stu   <u0046
L286C    tst   ,x++
         bne   L286C
         stx   <u00B1
         tst   <u00BA
         beq   L287A
         bsr   L28E0
         bra   L2885

L287A    lda   #$44
         lbsr  L08EF
         clr   ,x
         stx   <u00B8
         bsr   L28DC
L2885    beq   L28A6
         ldx   <u00B8
         cmpx  <u0046
         bcs   L2897
         leau  >L2A3D,pcr
         lbsr  L28D9
         lbsr  L2129
L2897    lda   <u006E
         sta   -$01,x
         stb   -$02,x
L289D    ldx   <u00A2
         lda   <u006E
         sta   ,x
         lbra  L235F

L28A6    tst   <u00BA
         beq   L2854
         ldx   <u00B8
         leax  -$02,x
         leay  $02,x
L28B0    ldu   ,y++
         stu   ,x++
         cmpx  <u00B1
         bcs   L28B0
         clr   ,x
         bra   L289D

L28BC    leau  >L29B2,pcr
         bsr   L28D9
         lbra  L2129

L28C5    ldx   #$011A
         leax  $0F,x
         lbsr  L20E3
         tfr   b,a
         lbsr  L1B3C  output char in a
         lbsr  L20DD
         leau  >L2A31,pcr
L28D9    lbra  L3ADE

L28DC    bsr   L28F8
         bra   L28E2

L28E0    bsr   L28E9
L28E2    beq   L28E8
         cmpb  #$03
         bls   L28BC
L28E8    rts
L28E9    deca
         sta   <u0071
         clr   <u0075
         lda   <u005B
         sta   <u005C
         lbsr  L08E3
         lbsr  L08EF
L28F8    lda   #$20
         lbsr  L08EF
         lbsr  L08F2
         lbsr  L3ADB
         lda   <u005A
         inca
         lda   a,y
         cmpa  #$44
         beq   L28E8
         cmpa  #$0D
         beq   L2964
         lbsr  L08F5
         blt   L28BC
         andcc #$FB
         rts

* Width of window
L2918    ldb   #$57
         bsr   L28C5
         ldx   <u00A2
         lda   $08,x
         bsr   L28E0
         bne   L2926
         ldb   #$09
L2926    ldy   <u00A2
         pshs  b
         clr   -$06,y
         clr   -$05,y
         lbsr  L1ED0
         puls  b
         stb   $08,y
         ldu   ,y
         stu   $02,y
         lbsr  L1DDE
         lbsr  L1D6C
         lbra  L1D0C

L2943    sta   <u002D
L2945    ldx   #$0200
         lbsr  L20E3
         leau  >L2992,pcr
         lbsr  L2234  output string pointed to in U
         lda   <u002D
         ldb   #$20
         lbsr  L1B3F
L2959    lbsr  L0904
         cmpa  #$20
         bhi   L2943
         cmpa  #$0D
         bne   L2959
L2964    lbra  L1D0C

* Change directory
L2967    leau  >L2A66,pcr  New directory
         lbsr  L28D9
         clr   <u009A
         lbsr  L3ADB
         decb
         lda   b,y
         ora   #$80
         sta   b,y
         leax  $0F,y
         lda   #$03
         os9   I$ChgDir
         bcc   L2964
         lbra  L3B05
L2986    lbra  L3AD8
L2989    lbra  L3AD5
L298C    lbra  L3AE1  fork
L298F    lbra  L002D

L2992    fcc   "Graph is : "
         fcb   $00

L299E    fcc   "Edit : "
         fcb   $00

L29A6    fcc   "Value"
         fcb   $00

L29AC    fcc   "Label"
         fcb   $00

L29B2    fcc   "  "
L29B4    fcc   "NOT VALID !"
         fcb   $00
L29C0    fcc   "Signal "
         fcb   $00
L29C8    fcc   "Goto : "
         fcb   $00

L29D0    fcc   "Protection "
         fcb   $00
L29DC    fcc   "Label entry "
         fcb   $00
L29E9    fcc   "Type mismatch"
         fcb   $00
L29F7    fcc   "Formula dump "
         fcb   $00
L2A05    fcc   "CELL TABLE OVERFLOW !"
         fcb   $07
         fcb   $00

L2A1C    fcc   "OUT OF MEMORY !"
         fcb   $07
         fcb   $00
L2A2D    fcc   "is "
         fcb   $00

L2A31    fcc   "Width is : "
         fcb   $00

L2A3D    fcc   " NO MORE ROOM"
         fcb   $00

L2A4B    fcc   "Blank cell"
         fcb   $00

L2A56    fcc   "Mode="
         fcb   $00
L2A5C    fcc   "  Memory="
         fcb   $00

L2A66    fcc   "New directory? "
         fcb   $00

L2A76    fcb   $DE   LDU here
         cmpb  #$17
         eorb  >$7817
         ldb   #$92
         ldu   <u006A
         ldx   <u00B1
         ldd   <u006A
         cmpa  <u00B1
         beq   L2A8C
         cmpb  <u00B2
         fcb   $26,$dc
L2A8C    cmpu  <u00B1
L2A8F    rts

         leax  >L2F47,pcr
         fcb   $8d,$d8
         bhi   L2A9A
         exg   u,x
L2A9A    rts

         fcb   $20,$3c
         fcc   "INVALID."

L2AA5    lbra  L3327
L2AA8    lbra  L300D
L2AAB    lbra  L2F25

* Series of integers here
L2AAE    clr   <u00D2
         nop
L2AB1    fcb   $01
         eora  >$017C
L2AB5    fcb   $02
         lda   >$02DF
         dec   <u000F
         fcb   $0B
L2ABC    jmp   $0A,x
         dec   >$0C2F
         inc   <u0032
         inc   <u0088
         neg   <u0000
         neg   <u0000
         neg   <u0000
         neg   <u0000
         neg   <u0000

L2ACF    lbra  L2FDD  Copy floating point value from X to buffer in U
L2AD2    lbra  L2B53
L2AD5    lbra  L2AF3
L2AD8    lbra  L2B2B
L2ADB    lbra  L2FAC

L2ADE    fdb   L39F8-L2ADE ($0F1A)  Points to PI
         nop
L2AE1    fdb   $0F0F
         nop
L2AE4    fdb   $0DB4
         nop
         fdb   $0000
         nop
L2AEA    fdb   $0D46
         nop

L2AED    lbra  L2BD9
L2AF0    lbra  L2BEE

L2AF3    ldb   #$B8
         stb   $0F,u
         lbsr  L2F3B
         lda   <u0039
         bpl   L2AFF
         nega
L2AFF    cmpa  #$0A
         bls   L2B0F
         bsr   L2B2B
         pshs  a
         addb  #$09
         tfr   b,a
         bsr   L2B0F
         puls  a
L2B0F    cmpa  #$0D
         bcc   L2B28
         lsla
         beq   L2B43
         lsla
         lsla
         tfr   a,b
         leax  >L3830,pcr
         abx
         tst   <u0039
         lbpl  L2F98
         lbra  L2FA2
L2B28    lbra  L3008

L2B2B    clrb
L2B2C    cmpa  #$0A
         bcs   L2B43
         suba  #$0A
         incb
         bra   L2B2C

L2B35    bsr   L2B47
         cmpa  #$30
         bcs   L2B43
         cmpa  #$3A
         bcc   L2B44
         anda  #$0F
         andcc #$FE
L2B43    rts

L2B44    orcc  #$01
         rts

L2B47    leax  -$01,x
L2B49    leax  $01,x
         lda   ,x
         cmpa  #$20
         beq   L2B49
         rts
L2B52    rts
L2B53    clra
         lbsr  L2FAF
         bsr   L2B35
         bcs   L2B52
         leax  $01,x
         sta   $0E,u
         inc   -$04,y
L2B61    bsr   L2B35
         bcs   L2B52
         leax  $01,x
         pshs  a
         inc   -$04,y
         ldd   $0D,u
         lslb
         rola
         std   $0D,u
         std   $05,u
         ldd   $0B,u
         rolb
         rola
         std   $0B,u
         std   $03,u
         ldd   $09,u
         rolb
         rola
         std   $09,u
         std   $01,u
         lda   $08,u
         rola
         sta   $08,u
         sta   ,u
         lsl   $0E,u
         rol   $0D,u
         rol   $0C,u
         rol   $0B,u
         rol   $0A,u
         rol   $09,u
         rol   $08,u
         lbcs  L3008
         lsl   $0E,u
         rol   $0D,u
         rol   $0C,u
         rol   $0B,u
         rol   $0A,u
         rol   $09,u
         rol   $08,u
         lbcs  L3008
         lbsr  L2FBE
         lbcs  L3008
         puls  b
         clra
         addd  $0D,u
         std   $0D,u
         ldd   <u00DA
         adcb  $0C,u
         adca  $0B,u
         std   $0B,u
         ldd   <u00DA
         adcb  $0A,u
         adca  $09,u
         std   $09,u
         lda   #$00
         adca  $08,u
         sta   $08,u
         lbcs  L3008
         lbra  L2B61

L2BD9    ldx   $08,u
         stx   <$18,u
         ldx   $0A,u
         stx   <$1A,u
         ldx   $0C,u
         stx   <$1C,u
         ldx   $0E,u
         stx   <$1E,u
         rts
L2BEE    ldx   <$18,u
         stx   $08,u
         ldx   <$1A,u
         stx   $0A,u
         ldx   <$1C,u
         stx   $0C,u
         ldx   <$1E,u
         stx   $0E,u
         rts
L2C03    ldx   $08,u
         stx   <$20,u
         ldx   $0A,u
         stx   <$22,u
         ldx   $0C,u
         stx   <$24,u
         ldx   $0E,u
         stx   <$26,u
         rts
L2C18    ldx   $08,u
         stx   <$10,u
         ldx   $0A,u
         stx   <$12,u
         ldx   $0C,u
         stx   <$14,u
         ldx   $0E,u
         stx   <$16,u
         rts

L2C2D    lbsr  L2ED8
         lda   -1,u
         beq   L2C49
         ldb   $0E,y
         eorb  #$80
         stb   $0E,y
         eorb  $0D,y
         stb   $0C,y
         ldb   7,u
         bne   L2C72
         bsr   L2C58
         lda   ,u
         lbra  L2D45

L2C49    lda   ,u
         ldb   $0D,y
         lbra  L2D47

L2C50    ldd   ,x
         anda  #$7F
         ora   $0E,y
         bra   L2C5A

L2C58    ldd   ,x
L2C5A    std   ,u
         ldd   $02,x
         std   $02,u
         ldd   $04,x
         std   $04,u
         ldd   $06,x
         std   $06,u
         rts

L2C69    lbsr  L2ED8
         beq   L2C50
         lda   -$01,u
         beq   L2C49
L2C72    suba  $07,u
         beq   L2C94
         sta   $01,y
         bcc   L2C9A
         ldd   -$08,u
L2C7C    lsra
         rorb
         ror   -$06,u
         ror   -$05,u
         ror   -$04,u
         ror   -$03,u
         ror   -$02,u
         inc   $01,y
         bne   L2C7C
         std   -$08,u
         lda   $0C,y
         bpl   L2CB6
         bra   L2CD4

L2C94    inc   $01,y
         orcc  #$01
         bra   L2CB2

L2C9A    ldb   -$01,u
         stb   $07,u
         ldd   ,u
L2CA0    lsra
         rorb
         ror   $02,u
         ror   $03,u
         ror   $04,u
         ror   $05,u
         ror   $06,u
         dec   $01,y
         bne   L2CA0
         std   ,u
L2CB2    lda   $0C,y
         bmi   L2CD1
L2CB6    lbsr  L2DCE
         bcc   L2CCB
         inc   $07,u
         ror   ,u
         ror   $01,u
         ror   $02,u
         ror   $03,u
         ror   $04,u
         ror   $05,u
         ror   $06,u
L2CCB    lda   $0E,y
         sta   $0C,y
         bra   L2D0F

L2CD1    rola
         coma
         asra
L2CD4    ldd   $05,u
         sbcb  -$02,u
         sbca  -$03,u
         std   $05,u
         ldd   $03,u
         sbcb  -$04,u
         sbca  -$05,u
         std   $03,u
         ldd   $01,u
         sbcb  -$06,u
         sbca  -$07,u
         std   $01,u
         lda   ,u
         sbca  -$08,u
         sta   ,u
         lda   $0D,y
         bcc   L2D0D
         com   ,u
         com   $01,u
         com   $02,u
         com   $03,u
         com   $04,u
         com   $05,u
         com   $06,u
         lda   $01,y
         beq   L2D0B
         lbsr  L2EF7
L2D0B    lda   $0E,y
L2D0D    sta   $0C,y
L2D0F    clr   $01,y
L2D11    lda   ,u
         bmi   L2D45
         ora   $01,u
         ora   $02,u
         ora   $03,u
         ora   $04,u
         ora   $05,u
         ora   $06,u
         beq   L2D56
         ldd   ,u
L2D25    tst   $07,u
         beq   L2D59
         dec   $07,u
         bne   L2D2F
         dec   ,y
L2D2F    lsl   $01,y
         rol   $06,u
         rol   $05,u
         rol   $04,u
         rol   $03,u
         rol   $02,u
         rolb
         rola
         bpl   L2D25
         stb   $01,u
         ldb   $07,u
         beq   L2D59
L2D45    ldb   $0C,y
L2D47    anda  #$7F
         andb  #$80
         pshs  b
         adda  ,s+
         sta   ,u
         tst   ,y
         bne   L2D59
L2D55    rts
L2D56    sta   $07,u
         rts
L2D59    lda   ,y
         ldb   $07,u
         cmpd  <u00DA
         beq   L2D8A
         bmi   L2D8A
         lbra  L3008

L2D67    lbsr  L2ED8
         beq   L2D8A
         lda   -$01,u
         beq   L2D8A
         lbsr  L2DED
         clra
         ldb   $07,u
         addb  -$01,u
         adca  #$00
         subd  #$0080
         stb   $07,u
         sta   ,y
         bsr   L2D11
         lda   $01,y
         bpl   L2D55
         lbra  L2EF7

L2D8A    clra
         sta   $07,u
         lbra  L2E45

L2D90    lbsr  L2ED8
         ldb   -$01,u
         bne   L2D9C
         lda   #$01
         lbra  L300A

L2D9C    tsta
         beq   L2D8A
         lbsr  L2E50
         clra
         ldb   $07,u
         subb  -$01,u
         sbca  #$00
         addd  #$0081
         sta   ,y
         stb   $07,u
         lda   $07,y
         coma
         asra
         ror   ,u
         ror   $01,u
         ror   $02,u
         ror   $03,u
         ror   $04,u
         ror   $05,u
         ror   $06,u
         ror   $01,y
         lbsr  L2D11
         lda   $01,y
         bpl   L2DEC
         lbra  L2EF7

L2DCE    ldd   $05,u
         adcb  -$02,u
         adca  -$03,u
         std   $05,u
         ldd   $03,u
         adcb  -$04,u
         adca  -$05,u
         std   $03,u
         ldb   $02,u
         adcb  -$06,u
         stb   $02,u
         ldd   ,u
         adcb  -$07,u
         adca  -$08,u
         std   ,u
L2DEC    rts
L2DED    bsr   L2E35
         ldb   #$38
         stb   $08,y
L2DF3    lda   $07,y
         lsra
         bcc   L2E14
         ldd   $05,u
         addd  -$03,u
         std   $05,u
         ldd   $03,u
         adcb  -$04,u
         adca  -$05,u
         std   $03,u
         ldd   $01,u
         adcb  -$06,u
         adca  -$07,u
         std   $01,u
         lda   ,u
         adca  -$08,u
         sta   ,u
L2E14    ror   ,u
         ror   $01,u
         ror   $02,u
         ror   $03,u
         ror   $04,u
         ror   $05,u
         ror   $06,u
         ror   $01,y
         ror   $02,y
         ror   $03,y
         ror   $04,y
         ror   $05,y
         ror   $06,y
         ror   $07,y
         dec   $08,y
         bne   L2DF3
         rts
L2E35    ldd   ,u
         std   $01,y
         ldd   $02,u
         std   $03,y
         ldd   $04,u
         std   $05,y
         ldb   $06,u
         stb   $07,y

* Clear floating point
L2E45    clra
         clrb
         std   ,u
         std   $02,u
         std   $04,u
         sta   $06,u
         rts

L2E50    bsr   L2E35
         ldb   #$39
         stb   $08,y
L2E56    ldb   $01,y
         cmpb  -$08,u
         bcs   L2E86
         ldd   $06,y
         subd  -$03,u
         std   -$02,y
         ldd   $04,y
         sbcb  -$04,u
         sbca  -$05,u
         std   $0A,y
         ldb   $03,y
         sbcb  -$06,u
         stb   $09,y
         ldd   $01,y
         sbcb  -$07,u
         sbca  -$08,u
         bcs   L2E86
         std   $01,y
         lda   $09,y
         sta   $03,y
         ldd   $0A,y
         std   $04,y
         ldd   -$02,y
         std   $06,y
L2E86    rol   $06,u
         rol   $05,u
         rol   $04,u
         rol   $03,u
         rol   $02,u
         rol   $01,u
         rol   ,u
         rol   $07,y
         rol   $06,y
         rol   $05,y
         rol   $04,y
         rol   $03,y
         rol   $02,y
         rol   $01,y
         dec   $08,y
         bhi   L2E56
         beq   L2EC7
         ldd   $06,y
         subd  -$03,u
         std   $06,y
         ldd   $04,y
         sbcb  -$04,u
         sbca  -$05,u
         std   $04,y
         ldd   $02,y
         sbcb  -$06,u
         sbca  -$07,u
         std   $02,y
         lda   $01,y
         sbca  -$08,u
         sta   $01,y
         clra
         bra   L2E86

L2EC7    ror   $01,y
         com   ,u
         com   $01,u
         com   $02,u
         com   $03,u
         com   $04,u
         com   $05,u
         com   $06,u
         rts
L2ED8    leax  ,u
         leau  $08,u
         clr   ,y
         lda   -$08,u
         sta   $0E,y
         ora   #$80
         ldb   -$08,u
         sta   -$08,u
         eorb  ,u
         stb   $0C,y
         lda   ,u
         sta   $0D,y
         ora   #$80
         sta   ,u
         lda   $07,u
         rts
L2EF7    inc   $06,u
         bne   L2F24
         inc   $05,u
         bne   L2F24
         inc   $04,u
         bne   L2F24
         inc   $03,u
         bne   L2F24
         inc   $02,u
         bne   L2F24
         inc   $01,u
         bne   L2F24
         ldb   ,u
         tfr   b,a
         anda  #$7F
         inca
         bpl   L2F1C
         inc   $07,u
         anda  #$7F
L2F1C    andb  #$80
         pshs  b
         adda  ,s+
         sta   ,u
L2F24    rts
L2F25    pshs  u,x,b,a
         leau  $08,u
         ldd   ,u++
         std   ,x++
         ldd   ,u++
         std   ,x++
         ldd   ,u++
         std   ,x++
         ldd   ,u++
         std   ,x++
         puls  pc,u,x,b,a

L2F3B    clr   -$03,y
         lda   $08,u
         bmi   L2F6D
         ora   $09,u
         ora   $0A,u
         ora   $0B,u
L2F47    ora   $0C,u
         ora   $0D,u
         ora   $0E,u
         beq   L2F7E
         ldd   $08,u
L2F51    dec   $0F,u
         bne   L2F57
         dec   <u003A
L2F57    lsl   -$03,y
         rol   $0E,u
         rol   $0D,u
         rol   $0C,u
         rol   $0B,u
         rol   $0A,u
         rolb
         rola
         bpl   L2F51
         stb   $09,u
         ldb   $0F,u
         beq   L2F81
L2F6D    ldb   <u003C
         anda  #$7F
         andb  #$80
         pshs  b
         adda  ,s+
         sta   $08,u
         tst   <u003A
         bne   L2F81
         rts
L2F7E    sta   $0F,u
         rts
L2F81    lda   <u003A
         ldb   $0F,u
         cmpd  <u00DA
         beq   L2F8F
         bmi   L2F8F
         lbra  L3008

L2F8F    lda   -$0C,y
         lbeq  L3008
         lbra  L2FAC

L2F98    pshs  u,x
         lbsr  L2FDD  Copy floating point value from X to buffer in U
         lbsr  L2D67
         puls  pc,u,x

L2FA2    pshs  u,x
         lbsr  L2FDD  Copy floating point value from X to buffer in U
         lbsr  L2D90
         puls  pc,u,x

L2FAC    clra
         sta   $0F,u
L2FAF    sta   $08,u
         sta   $09,u
         sta   $0A,u
         sta   $0B,u
         sta   $0C,u
         sta   $0D,u
         sta   $0E,u
         rts
L2FBE    ldd   $0D,u
         adcb  $06,u
         adca  $05,u
         std   $0D,u
         ldd   $0B,u
         adcb  $04,u
         adca  $03,u
         std   $0B,u
         ldb   $0A,u
         adcb  $02,u
         stb   $0A,u
         ldd   $08,u
         adcb  $01,u
         adca  ,u
         std   $08,u
         rts

* Copy floating point value from X to buffer in U
L2FDD    ldd   $06,x
         std   $06,u
         ldd   $04,x
         std   $04,u
         ldd   $02,x
         std   $02,u
         ldd   ,x
         std   ,u
         rts

         leax  $08,u
         clr   $02,x
         clr   $03,x
         clr   $04,x
         clr   $05,x
         clr   $06,x
L2FFA    clr   $07,x
L2FFC    clr   ,x
         clr   $01,x
         rts
L3001    ldx   <u0046
         leax  $08,x
         stx   <u0046
         rts
L3008    lda   #$04
L300A    sta   <u0033
         rts
L300D    lbsr  L3400
         leax  >-$046F,y
         stx   -$10,y
         clra
         sta   -$04,y
         sta   <u002F
         sta   <u0026
         sta   <u002B
         inca
         sta   -$0E,y
         ldb   $0F,u
         beq   L305A
         stb   <u0039
         subb  #$80
         bpl   L302D
         negb
L302D    lda   #$4E
         mul
         tfr   a,b
         tst   <u0039
         bmi   L3037
         negb
L3037    incb
         stb   <u002F
         lbsr  L2AFF
         leax  >L3838,pcr
L3041    lda   $0F,u
         cmpa  #$81
         bcc   L304E
         lbsr  L2F98
         dec   <u002F
         bra   L3041

L304E    lbsr  L333D
         bcs   L305A
         lbsr  L2FA2
         inc   <u002F
         bra   L304E

L305A    ldb   $08,u
         bpl   L3064
         stb   <u0026
         andb  #$7F
         stb   $08,u
L3064    ldb   #$10
         stb   <u0025
         leax  >L3898,pcr
         stx   <u0046
L306E    clr   -$0B,y
         pshs  x
         leax  >L3928,pcr
         cmpx  ,s
         puls  x
         bne   L3084
         clrb
         lbsr  L30A4
         ldx   <u0046
         bra   L3098

L3084    lbsr  L333D
         bcs   L3090
         inc   -$0B,y
         lbsr  L33B3
         bra   L3084

L3090    ldb   -$0B,y
         lbsr  L30A4
         lbsr  L3001
L3098    dec   <u0025
         bmi   L30B1
         bgt   L306E
         lda   <u002B
         sta   <u0036
         bra   L306E

L30A4    ldx   -$10,y
         inc   <u002B
         stb   ,x+
         beq   L30AE
         clr   <u002B
L30AE    stx   -$10,y
         rts
L30B1    ldb   <u004A
         orb   <u0091
         bne   L30BC
         lda   #$20
         lbsr  L091C
L30BC    ldb   #$10
         subb  <u0036
L30C0    stb   <u002B
         ldb   <u0020
         decb
         tst   <u0026
         beq   L30CA
         decb
L30CA    stb   <u0021
         clrb
         stb   <u0028
         stb   <u0029
         stb   <u002C
         stb   <u0027
         stb   <u002A
         lda   <u0022
         ldb   #$20
         tst   <u004B
         lbne  L32BD
         ldb   <u002F
         lbgt  L3156
         negb
         cmpa  #$04
         blt   L3124
         suba  #$05
         ble   L30F4
         inca
         sta   <u0028
         inca
L30F4    inca
         suba  <u0021
         lbgt  L32F6
         nega
         sta   <u002A
L30FE    inc   <u002B
         lda   >-$046D,y
         sta   >-$046C,y
         lda   >-$046E,y
         sta   >-$046D,y
         lda   >-$046F,y
         sta   >-$046E,y
         clr   >-$046F,y
         decb
         bpl   L30FE
         inc   <u0029
         lbra  L3190

L3124    dec   <u0021
         stb   <u002C
         addb  <u002B
         bne   L3137
         ldb   #$01
         stb   <u0029
         ldb   <u0021
         stb   <u002A
         lbra  L31FA

L3137    subb  <u0021
         ble   L314A
         lda   <u002C
         cmpa  #$03
         lbgt  L32BD
         cmpa  <u0021
         blt   L314E
         lbra  L32F6

L314A    negb
         stb   <u002A
         clrb
L314E    subb  <u002B
         negb
         stb   <u0028
         lbra  L3190

L3156    stb   <u0029
         subb  <u0021
         lbgt  L32B9
         negb
         cmpa  #$04
         blt   L3171
         cmpa  #$06
         bne   L3184
         lda   #$02
         cmpb  #$03
         lblt  L32F6
         bra   L317A

L3171    tstb
         beq   L3190
         lda   <u002B
         suba  <u002F
         ble   L3182
L317A    sta   <u0028
         decb
         bne   L3182
         stb   <u0028
         incb
L3182    subb  <u0028
L3184    stb   <u002A
         bpl   L3190
         addb  <u002B
         subb  <u002F
         stb   <u0028
         clr   <u002A
L3190    ldb   <u0029
         addb  <u0028
         clr   >-$0470,y
         leax  >-$046F,y
         lda   #$D0
         cmpb  <u002B
         ble   L31A4
         ldb   #$10
L31A4    abx
         ldb   ,x
         sta   ,x
         addb  #$05
         cmpb  #$09
         ble   L31D3
         clrb
L31B0    incb
         sta   ,x
         lda   ,-x
         adda  #$01
         daa
         sta   ,x
         suba  #$10
         bpl   L31B0
         pshs  x
         puls  a
         puls  a
         cmpa  #$E0
         bne   L31D9
         inc   <u002F
         ldb   #$01
         stb   >-$046F,y
         lbra  L30C0

L31D3    clrb
L31D4    incb
         lda   ,-x
         beq   L31D4
L31D9    lda   <u0022
         cmpa  #$06
         beq   L31FA
         tst   <u0028
         beq   L31FA
         decb
         stb   <u0025
         lda   <u002A
         adda  <u0025
         sta   <u002A
         subb  <u0028
         negb
         stb   <u0028
         bgt   L31FA
         addb  <u002A
         incb
         stb   <u002A
         clr   <u0028
L31FA    leax  >-$046F,y
         lda   <u0022
         cmpa  #$04
         bne   L324D
         tst   <u0026
         beq   L320E
         ldb   <u0020
         decb
         lbra  L32B4

L320E    clrb
         lda   <u0029
         deca
         bmi   L320E
         tst   <u0027
         bne   L322C
         ldb   ,x+
         deca
         bmi   L3228
         bne   L322C
         lda   #$0A
         mul
         addb  ,x
         bpl   L3228
         ldb   #$0A
L3228    cmpb  <u0020
         bcs   L3232
L322C    ldb   <u0020
         subb  #$02
         stb   <u0026
L3232    lda   <u0020
         stb   <u0025
         suba  <u0025
         deca
         sta   <u002A
         lda   <u002D
         lbsr  L3312
         tst   <u0026
         beq   L324B
         dec   <u002A
         lda   #$3E
         lbsr  L3316
L324B    bra   L32B0

L324D    cmpa  #$03
         beq   L325A
         ldb   <u002A
         lda   #$20
         lbsr  L3312
         clr   <u002A
L325A    tst   <u0026
         beq   L3263
         lda   #$2D
         lbsr  L3316
L3263    ldb   <u0029
         beq   L326A
         lbsr  L32FE
L326A    lda   #$2E
         ldb   <u002C
         beq   L3279
         lbsr  L3316
         lda   #$30
         lbsr  L3312
         clra
L3279    ldb   <u0028
         beq   L3286
         tsta
         beq   L3283
         lbsr  L3316
L3283    lbsr  L32FE
L3286    ldb   <u0027
         bne   L328C
         bra   L32B0

L328C    lda   #$65
         lbsr  L3316
         tstb
         bpl   L329A
         lda   #$2D
         lbsr  L3316
         negb
L329A    tfr   b,a
         lbsr  L2B2B
         tstb
         beq   L32AB
         exg   a,b
         adda  #$30
         lbsr  L3316
         exg   a,b
L32AB    adda  #$30
         lbsr  L3316
L32B0    ldb   <u002A
         andb  <u00C7
L32B4    lda   #$20
         lbra  L3312

L32B9    cmpa  #$05
         bge   L32F6
L32BD    lda   <u002F
         deca
         sta   <u0027
         bpl   L32C7
         nega
         clr   <u002C
L32C7    ldb   #$01
         stb   <u0029
         ldb   <u0021
         cmpa  #$09
         ble   L32D2
         decb
L32D2    subb  #$03
         lblt  L32F6
         lbeq  L3190
         subb  <u002B
         blt   L32E3
         stb   <u002A
         clrb
L32E3    addb  <u002B
         decb
         bne   L32EA
         inc   <u002A
L32EA    stb   <u0028
         ldb   <u004B
         beq   L32F3
         decb
         stb   <u0028
L32F3    lbra  L3190

L32F6    lda   #$3E
         ldb   <u0020
         decb
         lbra  L3312

L32FE    lda   ,x+
         adda  #$30
         bne   L3308
         leax  -$01,x
         lda   #$30
L3308    lbsr  L3316
         decb
         bne   L32FE
         rts
L330F    lbsr  L3316
L3312    decb
         bpl   L330F
         rts
L3316    tst   <u004A
         lbeq  L093A
         lbmi  L0913
         ldu   <u00F8
         sta   ,u+
         stu   <u00F8
         rts

L3327    pshs  u,x,b,a
         leau  $08,u
         ldd   ,x++
         std   ,u++
         ldd   ,x++
         std   ,u++
         ldd   ,x++
         std   ,u++
         ldd   ,x++
         std   ,u++
         puls  pc,u,x,b,a

L333D    lda   $08,u
         eora  ,x
         bmi   L33A6
         lda   $08,u
         bmi   L337D
         lda   $0F,u
         beq   L3377
         ldb   $07,x
         beq   L33AA
         pshs  b
         cmpa  ,s+
         bne   L33AE
         ldd   $08,u
         cmpd  ,x
         bne   L33AE
         ldd   $0A,u
         cmpd  $02,x
         bne   L33AE
         ldd   $0C,u
         cmpd  $04,x
         bne   L33AE
         lda   $0E,u
         anda  #$FE
         ldb   $06,x
         andb  #$FE
         pshs  b
         cmpa  ,s+
         rts
L3377    lda   $07,x
         bne   L33AF
         clra
         rts
L337D    lda   $07,x
         cmpa  $0F,u
         beq   L3384
         rts
L3384    ldd   ,x
         cmpd  $08,u
         bne   L33AE
         ldd   $02,x
         cmpd  $0A,u
         bne   L33AE
         ldd   $04,x
         cmpd  $0C,u
         bne   L33AE
         lda   $06,x
         anda  #$FE
         ldb   $0E,u
         andb  #$FE
         pshs  b
         cmpa  ,s+
         rts
L33A6    lda   ,x
         bpl   L33AF
L33AA    lda   #$01
         andcc #$FE
L33AE    rts
L33AF    clra
         cmpa  #$01
         rts

L33B3    pshs  u,x
         lbsr  L2FDD  Copy floating point value from X to buffer in U
         lbsr  L2C2D
         puls  pc,u,x

* Something to do with floating point
L33BD    pshs  u,x
         lbsr  L2FDD  Copy floating point value from X to buffer in U
         lbsr  L2C69
         puls  pc,u,x

L33C7    leax  $08,u
L33C9    lda   #$90
         sta   $07,x
         clr   $02,x
         clr   $03,x
         clr   $04,x
         clr   $05,x
         clr   $06,x
         lda   ,x
         tfr   a,b
         orb   $01,x
         lbeq  L2FFA
         ldb   $01,x
         tsta
         bpl   L33ED
         coma
         comb
         addd  #$0001
         bvs   L33F3
L33ED    dec   $07,x
         lslb
         rola
         bpl   L33ED
L33F3    anda  #$7F
         tst   ,x
         bpl   L33FB
         ora   #$80
L33FB    sta   ,x
         stb   $01,x
         rts
L3400    inc   $0E,u
         bne   L342D
         inc   $0D,u
         bne   L342D
         inc   $0C,u
         bne   L342D
         inc   $0B,u
         bne   L342D
         inc   $0A,u
         bne   L342D
         inc   $09,u
         bne   L342D
         ldb   $08,u
         tfr   b,a
         anda  #$7F
         inca
         bpl   L3425
         inc   $0F,u
         anda  #$7F
L3425    andb  #$80
         pshs  b
         adda  ,s+
         sta   $08,u
L342D    rts
L342E    clr   <u002F
L3430    lsra
         rorb
         ror   $02,x
         ror   $03,x
         ror   $04,x
         ror   $05,x
         ror   $06,x
         bcc   L3440
         ror   <u002F
L3440    dec   <u0039
         bne   L3430
         rts
L3445    leax  >L3898,pcr
L3449    pshs  a
         ldd   ,x
         std   $08,u
         ldd   $02,x
         std   $0A,u
         ldd   $04,x
         std   $0C,u
         ldd   $06,x
         std   $0E,u
         puls  pc,a
L345D    leax  $08,u
L345F    ldb   $07,x
         beq   L349B
         subb  #$81
         bcs   L3493
         negb
         addb  #$0F
         beq   L349F
         bmi   L3490
         stb   <u0039
         ldd   ,x
         bpl   L34AD
         bsr   L342E
         tst   <u002F
         bne   L347E
L347A    tst   $02,x
         beq   L3489
L347E    cmpd  #$8000
         beq   L3490
         addd  #$0001
         bcs   L3490
L3489    coma
         comb
         addd  #$0001
         bra   L34B5

L3490    lbra  L3008

L3493    lda   ,x
         lbpl  L2FFC
         ldb   #$FF
L349B    tfr   b,a
         bra   L34B5

L349F    lda   ,x
         bpl   L3490
         bita  #$7F
         bne   L3490
         ldb   $01,x
         bne   L3490
         bra   L347A

L34AD    ora   #$80
L34AF    lsra
         rorb
         dec   <u0039
         bne   L34AF
L34B5    stb   $01,x
         sta   ,x
         rts
L34BA    rts
L34BB    lda   #$05
         lbra  L300A

         lda   $08,u
         bmi   L34BB
         lda   $0F,u
         beq   L34BA
         sta   -$0D,y
         anda  #$01
         tfr   a,b
         adda  #$80
         sta   $0F,u
         lbsr  L2BD9
         leax  >L3928,pcr
         tstb
         beq   L34E0
         leax  >L3940,pcr
L34E0    stx   <u0046
         lbsr  L33BD
         lbsr  L2C18
         lbsr  L3001
         lbsr  L3449
         leax  <$10,u
         lbsr  L2FA2
         lbsr  L3001
         lbsr  L33BD
         lbsr  L2C18
         lbsr  L2BEE
         leax  <$10,u
         lbsr  L2FA2
         lbsr  L33BD
         dec   $0F,u
         lbsr  L2C18
         lbsr  L2BEE
         leax  <$10,u
         lbsr  L2FA2
         lbsr  L33BD
         dec   $0F,u
         lda   -$0D,y
         suba  #$80
         asra
         adda  $0F,u
         sta   $0F,u
         rts
L3526    lda   #$06
         lbra  L300A

         inc   -$0C,y
         lda   $08,u
         bmi   L3526
         lda   $0F,u
         beq   L3526
         cmpa  #$81
         bcs   L3544
         deca
         sta   -$0B,y
         lda   #$81
         sta   $0F,u
         clr   -$0D,y
         bra   L354E

L3544    sta   -$0B,y
         lda   #$80
         sta   $0F,u
         lda   #$01
         sta   -$0D,y
L354E    lbsr  L2BD9
         lbsr  L2C18
         lda   <$17,u
         adda  #$03
         sta   <$17,u
         leax  <$10,u
         lbsr  L345F
         addb  -$0D,y
         andb  #$0E
         stb   -$0D,y
         stb   <$11,u
         lbsr  L33C9
         lda   <$17,u
         suba  #$03
         sta   <$17,u
         lbsr  L33BD
         lbsr  L2C03
         lbsr  L2BEE
         leax  <$10,u
         lda   $0E,u
         anda  #$F0
         sta   $0E,u
         lda   $06,x
         anda  #$F0
         sta   $06,x
         lbsr  L33B3
         leax  <$20,u
         lbsr  L2FA2
         lbsr  L2BD9
         leax  <$18,u
         lbsr  L2F98
         lbsr  L2C18
         leax  >L3958,pcr
         ldb   #$02
         lbsr  L35EF
         leax  <$10,u
         lbsr  L2F98
         leax  <$18,u
         lbsr  L2F98
         lda   $07,x
         beq   L35C1
         inc   $07,x
         lbsr  L33BD
L35C1    ldb   -$0D,y
         subb  #$04
         lslb
         lslb
         leax  >L3978,pcr
         abx
         lbsr  L33B3
         lbsr  L2BD9
         clra
         ldb   -$0B,y
         subb  #$80
         bpl   L35DA
         coma
L35DA    std   $08,u
         lbsr  L33C7
         leax  >L3978,pcr
         lbsr  L2F98
         leax  <$18,u
         lbsr  L33BD
         clr   -$0C,y
         rts
L35EF    pshs  b
         stx   <u0046
         lbsr  L3449
L35F6    leax  <$10,u
         lbsr  L33BD
         lbsr  L2C03
         ldx   <u0046
         leax  $08,x
         stx   <u0046
         lbsr  L3449
         leax  <$20,u
         lbsr  L2FA2
         dec   ,s
         beq   L361D
         ldx   <u0046
         leax  $08,x
         stx   <u0046
         lbsr  L33BD
         bra   L35F6

L361D    puls  pc,b
         leax  >L39E8,pcr
         lbsr  L2F98
         lbsr  L2BD9
         lbsr  L3689
         lda   $08,u
         eora  #$80
         sta   $08,u
         leax  <$18,u
         lbsr  L33BD
         lbsr  L2BD9
         leax  <$18,u
         lbsr  L2F98
         lbsr  L2C18
         leax  >L39C0,pcr
         ldb   #$02
         lbsr  L35EF
         leax  <$10,u
         lbsr  L2F98
         leax  >L39E0,pcr
         lbsr  L33BD
         leax  <$18,u
         lbsr  L33B3
         tst   $07,x
         beq   L3666
         inc   $07,x
L3666    lbsr  L2C18
         lbsr  L2BEE
         leax  <$10,u
         lbsr  L2FA2
         leax  >L3898,pcr
         lbsr  L33BD
         ldb   $0F,u
         clra
         addd  -$0B,y
         tsta
         bne   L3684
         stb   $0F,u
         rts
L3684    lda   #$07
         lbra  L300A

L3689    lda   $08,u
         sta   -$0B,y
         anda  #$7F
         sta   $08,u
         leax  >L3830,pcr
         lbsr  L33BD
         lbsr  L345D
         ldd   $08,u
         tst   -$0B,y
         bpl   L36A6
         coma
         comb
         addd  #$0001
L36A6    std   -$0B,y
         lbsr  L33C7
         lda   -$0B,y
         anda  #$80
         ora   $08,u
         sta   $08,u
         rts

L36B4    lbsr  L2C03
         leax  >L39F0,pcr
         lbsr  L2FA2
         lbsr  L3689
         lda   $08,u
         eora  #$80
         sta   $08,u
         leax  >L39F0,pcr
         lbsr  L2F98
         leax  <$20,u
         lbsr  L33BD
         lbsr  L2BD9
         leax  <$18,u
         lbsr  L2F98
         lbra  L2C18

         clra
         bra   L36E5

         lda   #$01
L36E5    sta   -$0E,y
         lbsr  L36B4
         ldb   -$0E,y
         addb  -$0A,y
         stb   -$0A,y
         bitb  #$01
         bne   L3712
         leax  >L3A00,pcr
         ldb   #$03
         lbsr  L35EF
         leax  <$10,u
         lbsr  L2F98
         leax  >L3898,pcr
         lbsr  L33BD
         leax  <$18,u
         lbsr  L2F98
         bra   L3728

L3712    leax  >L3A30,pcr
         ldb   #$03
         lbsr  L35EF
         leax  <$10,u
         lbsr  L2F98
         leax  >L3898,pcr
         lbsr  L33BD
L3728    lda   -$0A,y
         bita  #$02
         beq   L3738
         lda   $0F,u
         beq   L3738
         lda   $08,u
         eora  #$80
         sta   $08,u
L3738    rts
         lda   $0F,u
         beq   L3738
         clr   -$0D,y
         ldb   $08,u
         stb   -$0E,y
         andb  #$7F
         stb   $08,u
         lbsr  L2BD9
         cmpa  #$81
         bcs   L379A
         lbsr  L3445
         ldb   #$84
         stb   $0F,u
         leax  <$18,u
         lbsr  L2FA2
         lbsr  L3689
         ldb   $0F,u
         beq   L3766
         subb  #$03
         stb   $0F,u
L3766    lbsr  L2C18
         leax  <$18,u
         lbsr  L33BD
         lbsr  L2C03
         lbsr  L2BEE
         leax  <$10,u
         lbsr  L2F98
         lda   $08,u
         eora  #$80
         sta   $08,u
         leax  >L3898,pcr
         lbsr  L33BD
         leax  <$20,u
         lda   $0F,u
         cmpa  #$60
         bhi   L3793
         clr   $0F,u
L3793    lbsr  L2FA2
         com   -$0D,y
         bra   L37D3

L379A    adda  #$03
         sta   $0F,u
         lbsr  L3689
         lda   $0F,u
         beq   L37A9
         suba  #$03
         sta   $0F,u
L37A9    lbsr  L2C18
         leax  <$18,u
         lbsr  L2F98
         leax  >L3898,pcr
         lbsr  L33BD
         lbsr  L2C03
         lbsr  L2BEE
         leax  <$10,u
         lbsr  L33B3
         leax  <$20,u
         lda   $0F,u
         cmpa  #$60
         bhi   L37D0
         clr   $0F,u
L37D0    lbsr  L2FA2
L37D3    lbsr  L2BD9
         leax  <$18,u
         lbsr  L2F98
         lbsr  L2C18
         leax  >L3A60,pcr
         ldb   #$01
         lbsr  L35EF
         lbsr  L3001
         lbsr  L33BD
         leax  <$10,u
         lbsr  L2F98
         lbsr  L3001
         lbsr  L33BD
         leax  <$10,u
         lbsr  L2F98
         leax  <$18,u
         lbsr  L2F98
         lbsr  L33BD
         ldb   -$0A,y
         lslb
         lslb
         lslb
         leax  >L3A80,pcr
         abx
         lbsr  L33BD
         tst   -$0D,y
         beq   L3827
         lda   $08,u
         eora  #$80
         sta   $08,u
         leax  >L39F0,pcr
         lbsr  L33BD
L3827    lda   -$0E,y
         anda  #$80
         eora  $08,u
         sta   $08,u
         rts

* Floating point constants.
* The format is the same as the 'double' in Microware C

L3830    fcb   $00,$00,$00,$00,$00,$00,$00,$80  Value=0.5
L3838    fcb   $20,$00,$00,$00,$00,$00,$00,$84  Value 10
         fcb   $48,$00,$00,$00,$00,$00,$00,$87  Value 100
         fcb   $7A,$00,$00,$00,$00,$00,$00,$8A  Value 1000
         fcb   $1C,$40,$00,$00,$00,$00,$00,$8E  Value 10000
         fcb   $43,$50,$00,$00,$00,$00,$00,$91  Value 100000
         fcb   $74,$24,$00,$00,$00,$00,$00,$94  Value 1000000
         fcb   $18,$96,$80,$00,$00,$00,$00,$98  Value 10000000
         fcb   $3E,$BC,$20,$00,$00,$00,$00,$9B  Value=1.000000e+08
         fcb   $6E,$6B,$28,$00,$00,$00,$00,$9E  Value=1.000000e+09
         fcb   $15,$02,$F9,$00,$00,$00,$00,$A2  Value=1.000000e+10
         fcb   $2D,$78,$EB,$C5,$AC,$62,$00,$C3  Value=1.000000e+20
         fcb   $49,$F2,$C9,$CD,$04,$67,$4F,$E4  Value=1.000000e+30
L3898    fcb   $00,$00,$00,$00,$00,$00,$00,$81  Value 1 in floating point
         fcb   $4C,$CC,$CC,$CC,$CC,$CC,$CD,$7D  Value 0.1
         fcb   $23,$D7,$0A,$3D,$70,$A3,$D7,$7A  Value 0.01
         fcb   $03,$12,$6E,$97,$8D,$4F,$DF,$77  Value=0.001
         fcb   $51,$B7,$17,$58,$E2,$19,$65,$73  Value=0.0001
         fcb   $27,$C5,$AC,$47,$1B,$47,$84,$70  Value=0.00001
         fcb   $06,$37,$BD,$05,$AF,$6C,$6A,$6D  Value=0.000001
         fcb   $56,$BF,$94,$D5,$E5,$7A,$43,$69
         fcb   $2B,$CC,$77,$11,$84,$61,$CF,$66
         fcb   $09,$70,$5F,$41,$36,$B4,$A5,$63
         fcb   $5B,$E6,$FE,$CE,$BD,$ED,$D6,$5F
         fcb   $2F,$EB,$FF,$0B,$CB,$24,$AC,$5C
         fcb   $0C,$BC,$CC,$09,$6F,$50,$89,$59
         fcb   $61,$2E,$13,$42,$4B,$B4,$0E,$55
         fcb   $34,$24,$DC,$35,$09,$5C,$D8,$52
         fcb   $10,$1D,$7C,$F7,$3A,$B0,$AD,$4F
         fcb   $66,$95,$94,$BE,$C4,$4D,$E1,$4B
         fcb   $38,$77,$AA,$32,$36,$A4,$B4,$48
L3928    fcb   $08,$C8,$CA,$61,$10,$A7,$C3,$82  Value=2.137255
         fcb   $9A,$CD,$07,$75,$87,$CB,$EC,$83  Value=-4.837528
         fcb   $22,$AA,$36,$DB,$AD,$01,$02,$82  Value=2.541639

L3940    fcb   $08,$C8,$CA,$61,$10,$A7,$C3,$83  Value=4.274511
         fcb   $DA,$EB,$E9,$14,$85,$BD,$68,$84  Value=-13.682595
         fcb   $66,$0A,$FB,$F5,$8B,$01,$CE,$82
L3958    fcb   $F9,$7F,$B4,$FC,$E3,$9F,$24,$81  Value=-1.94921
         fcb   $8B,$62,$81,$A3,$99,$03,$C8,$81
         fcb   $AC,$FE,$0B,$40,$5D,$17,$CD,$82
         fcb   $B6,$FB,$F7,$37,$54,$55,$6B,$81
L3978    fcb   $31,$72,$17,$F7,$D1,$CF,$7C,$80  Value=0.693147 (ln(2))
         fcb   $13,$4B,$10,$89,$A6,$DC,$A3,$7F  Value=0.287682
         fcb   $00,$00,$00,$00,$00,$00,$00,$00
         fcb   $E4,$7F,$BE,$3C,$D4,$D1,$0D,$7E  Value=-0.223144
         fcb   $CF,$99,$1F,$65,$FC,$C2,$60,$7F  Value=-0.405465
         fcb   $8F,$42,$FA,$F3,$82,$06,$82,$80  Value=-0.559616
         fcb   $9E,$48,$9C,$8E,$AC,$BC,$BE,$AA  Value=-2.719292e+12
         fcb   $68,$08,$50,$26,$66,$8E,$28,$48
         fcb   $5E,$4C,$44,$42,$44,$6A,$56,$04

L39C0    fcb   $3B,$5F,$D5,$41,$8C,$88,$DF,$88  Value=187.374348
         fcb   $F7,$0C,$BC,$CF,$C3,$85,$80,$90  Value=-63244.737545
         fcb   $2B,$D7,$E1,$DF,$DA,$A8,$31,$8A  Value=687.373161
         fcb   $21,$A9,$43,$DB,$7A,$8F,$EE,$86  Value=40.415298
L39E0    fcb   $38,$AA,$3B,$29,$5C,$17,$F0,$82  Value=2.88539
L39E8    fcb   $38,$AA,$3B,$29,$5C,$17,$F0,$81  Value=1.442695

L39F0    fcb   $49,$0F,$DA,$A2,$21,$68,$C2,$81  Value=1.570796 (PI/2)
L39F8    fcb   $49,$0F,$DA,$A2,$21,$68,$C2,$82  Value=3.141593 (PI)

L3A00    fcb   $B5,$4D,$F0,$11,$62,$9E,$06,$84  Value=-11.331528
         fcb   $33,$23,$67,$F6,$25,$F3,$3A,$8C  Value=2866.212881
         fcb   $B1,$02,$A9,$F3,$29,$C1,$EE,$87  Value=-88.505203
         fcb   $15,$18,$89,$17,$50,$B5,$90,$90  Value=38168.535512
         fcb   $07,$B2,$83,$51,$03,$D5,$EC,$89  Value=271.394632
         fcb   $D4,$D0,$2A,$23,$DA,$7E,$59,$85  Value=-26.601643

L3A30    fcb   $43,$FA,$82,$84,$2C,$97,$BB,$81  Value=1.531082
         fcb   $35,$24,$37,$05,$1F,$D4,$5B,$8B  Value=1449.131716
         fcb   $93,$05,$A0,$B6,$D2,$D5,$3E,$87  Value=-73.510992
         fcb   $2C,$89,$82,$22,$D7,$2F,$16,$8F  Value=22084.754172
         fcb   $49,$54,$97,$B7,$42,$D9,$54,$88  Value=201.33044
         fcb   $E2,$A1,$07,$39,$21,$A1,$B1,$87  Value=-113.314508

L3A60    fcb   $24,$A2,$79,$05,$8D,$0D,$3C,$81  Value=1.286208
         fcb   $72,$01,$3E,$98,$C4,$58,$45,$7E  Value=0.236333
         fcb   $05,$2B,$98,$E4,$05,$AD,$89,$7B  Value=0.016256
         fcb   $AA,$AA,$AA,$AA,$AA,$81,$EE,$7F  Value=-0.333333
L3A80    fcb   $00,$00,$00,$00,$00,$00,$00,$00  Value 0
         fcb   $7E,$AD,$D4,$D5,$61,$7B,$6D,$7D  Value=0.124355
         fcb   $7A,$DB,$AF,$C9,$64,$86,$EB,$7E  Value=0.244979
         fcb   $37,$B0,$CA,$0F,$26,$F7,$84,$7F  Value=0.358771
         fcb   $6D,$63,$38,$2B,$0D,$DA,$7D,$7F  Value=0.463648
         fcb   $0F,$00,$5D,$5E,$F7,$F5,$A0,$80  Value=0.558599
         fcb   $24,$BC,$7D,$19,$34,$F7,$09,$80  Value=0.643501
         fcb   $38,$05,$3E,$2B,$C2,$31,$9E,$80  Value=0.71883
         fcb   $49,$0F,$DA,$A2,$21,$68,$C2,$80  Value=0.785398 (PI/4)
         fcb   $00,$00,$00,$00,$00,$00,$00,$00
         fcb   $00,$00,$00,$00,$00

L3AD5    lbra  L3C78
L3AD8    lbra  L3DF0
L3ADB    lbra  L3B1F
L3ADE    lbra  L3B33
L3AE1    lbra  L3F8E   Fork
L3AE4    lbra  L3B11
L3AE7    lbra  L3EA5
L3AEA    lbra  L3CD3
L3AED    lbra  L3FC6
L3AF0    lbra  L3B97
L3AF3    lbra  L3E52
L3AF6    lbra  L403A
L3AF9    lbra  L3C09
L3AFC    lbra  L3EA9
L3AFF    lbra  L4024
L3B02    lbra  L3B9B
L3B05    lbra  L3C23
L3B08    lbra  L3DE6
L3B0B    lbra  L3BF3
L3B0E    lbra  L3F61

L3B11    cmpa  #$0D
         bne   L3B2A
         ldb   <u005B
         incb
         bpl   L3B1B
         decb
L3B1B    sta   b,y
         puls  pc,x
L3B1F    com   <u008B
         pshs  x
         lbsr  L08F2
         inc   <u0060
         clr   <u00AD
L3B2A    lbra  L08D4

L3B2D    ldy   <u00E9
         lbsr  L08EF
L3B33    lda   ,u+
         bne   L3B2D
         clr   <u005A
         clr   <u0059
         clr   <u00CD
         com   <u00A5
         lbsr  L08F8 Read character from keyboard
         rts

         lda   #$14
         sta   <u0061
         lbsr  L08F2
         lbsr  L3B2A
         dec   <u006A
         ldu   <u006A
         rts

L3B52    fcb   $3d,$C6,$C5,$A0,$BB,$A3,$0C,$0E,$0F,$0D,$09,$F8,$6D

L3B5F    ldu   #$80
L3B62    stu   <u00C1
         leau  >L3B52,pcr
         ldx   <u00DA
L3B6A    clra
         leax  $01,x
         ldb   ,u+
         addd  #$00F0
         addd  <MEMPTR
         tfr   d,y
         tst   <u00EF
         bne   L3B81
         lda   ,y
         lbsr  L3EA9
         bra   L3B86

L3B81    lbsr  L3EA9
         sta   ,y
L3B86    cmpx  #$000A
         bcs   L3B6A
         tst   <u00C2
         bpl   L3B94
         cmpx  #$000D
         bcs   L3B6A
L3B94    rts
L3B95    dec   <u00E1
L3B97    leau  >L3FE8,pcr
L3B9B    bsr   L3BF7
L3B9D    bcc   L3BA5
         cmpb  #$CB
         bne   L3BBE
         bra   L3BBC

L3BA5    tst   <u0019
         bne   L3BEA
         ldx   <u0030
         pshs  a
         clrb
         os9   I$GetStt
         puls  a
         os9   I$Close
         ldx   <u0030
         lda   ,x
         bne   L3BCF
L3BBC    inc   <u00E1
L3BBE    lda   #$0D
         sta   <u00D0
         lda   #$02
         ldb   #$1B
         leax  $0D,y
         os9   I$Create
         bcs   L3C23
         bra   L3C1E

L3BCF    deca
         lbne  L3C23
         leau  >L4007,pcr  String 'Delete original?'
         lbsr  L3FC3
         inc   <u009A
         lbsr  L0904
         cmpa  #'Y
         bne   L3C04
         lbsr  L0925
         lbsr  L3E52
L3BEA    leax  $0D,y
         os9   I$Delete
         bcs   L3C23
         bra   L3BBE

L3BF3    bsr   L3BFA
         bra   L3B9D

L3BF7    lbsr  L3D4C
L3BFA    clr   <u00EF
         leax  $0D,y
         lda   #$01
         os9   I$Open
         rts

L3C04    lbra  L1A9E

L3C07    inc   <u00E1
L3C09    leau  >L3FE1,pcr  String 'Load'
         bsr   L3BF7
         bcs   L3C23
         ldb   #$0C
         stb   <u00D0
         ldx   #$0900
         stx   <u0044
         inc   <u00EF
         bra   L3C20

L3C1E    bcs   L3C23
L3C20    sta   <u00EE
         rts
L3C23    tst   <u0019
         bne   L3C75
         pshs  b,a
         inc   <u00EF
         ldd   <u00ED
         std   <u00C1
         clr   <u00ED
         clra
         tstb
         beq   L3C3F
         tfr   b,a
         os9   I$Close
         clr   <u00EE
         lbsr  L3CD3
L3C3F    lbsr  L1B0A
         lbsr  L19D5
         puls  b,a
         stb   <u0025
         leau  >L401B,pcr String 'Error! #'
         lbsr  L3FC3
         stb   <u0075
         decb
         stb   <u0071
         lbsr  L08E3
         tst   <u001D  help texts discarded?
         bne   L3C62
         ldx   <u001E
         leax  $0A,x
         jsr   ,x
L3C62    lbsr  L1AC5
         lda   <u00C1
         ora   <u00C2
         beq   L3C04
         lbra  L08C8

L3C6E    bsr   L3C72
         tfr   b,a
L3C72    lbra  L3EA9

L3C75    lbra  L1AFB

L3C78    lbsr  L3B95
         ldx   <MEMPTR
         lda   #$21
         sta   <u0040
         ldd   #$FFFF
         bsr   L3C6E
         ldd   #$0080
         leau  >$0580,x
L3C8D    bsr   L3C6E
         ldd   ,u++
         tsta
         bne   L3C8D
         leau  >$0500,x
L3C98    bsr   L3C6E
         ldd   ,u++
         dec   <u0040
         bne   L3C98
         ldd   <u006E
         bsr   L3C6E
         ldd   <u00A2
         bsr   L3C6E
         ldd   <u0097
         bsr   L3C6E
         lbsr  L3B5F
         ldu   <u001E
         clra
         clrb
L3CB3    leau  -$02,u
         lbsr  L3D0A
         incb
         beq   L3CC0
         cmpb  <u00C0
         bls   L3CB3
         clrb
L3CC0    inca
         beq   L3CC7
         cmpa  <u00BF
         bls   L3CB3
L3CC7    lda   #$FF
         bsr   L3D07
         bsr   L3D07
         clra
         bsr   L3D07
         lbsr  L4ED0
L3CD3    pshs  b,a
         ldd   <u00ED
         beq   L3CEE
         lda   <u00D0
         cmpa  #$0D
         bne   L3CE2
         lbsr  L3E56
L3CE2    clra
         clr   <u00EE
         tfr   b,a
         os9   I$Close
         lbcs  L3C23
L3CEE    ldx   #$0700
         stx   <u0044
         clr   <u00A7  number of characters in input buffer
         tst   <u0019
         lbne  L3C75
         tst   <u00ED
         lbne  L08C8
         tst   <u00EF
         beq   L3D34
         puls  pc,b,a

L3D07    lbra  L3EA9

L3D0A    pshs  x,b,a
         ldx   ,u
         beq   L3D2E
         lbsr  L4EB8
         bsr   L3D07
         tfr   b,a
         bsr   L3D07
         lda   ,x
         ldb   ,x+
         bsr   L3D07
         lda   ,x+
         bsr   L3D07
         subb  #$02
         beq   L3D2E
L3D27    lda   ,x+
         bsr   L3D07
         decb
         bne   L3D27
L3D2E    puls  pc,x,b,a
L3D30    tst   <u00E1
         bmi   L3D37
L3D34    lbra  L1A9E

L3D37    cmpa  #$2F
         beq   L3D34
         leax  >$0440,y
         tst   ,x
         beq   L3D34
         leau  $0D,y
         lbsr  L3F61
         addb  #$0C
         bra   L3DB9

L3D4C    ldb   <u00ED
         bne   L3D54
         ldb   <u0019
         beq   L3D5B
L3D54    stb   <u005B
         ldy   <u00E9
         bra   L3D73

L3D5B    lbsr  L3B33
         leau  >L3FD9,pcr  String 'File?'
         lbsr  L3B33
         clr   <u009A
         lbsr  L3B1F
         cmpb  #$0D
         beq   L3D30
         tst   <u00E1
         beq   L3DB9
L3D72    decb
L3D73    cmpb  #$0C
         beq   L3D7D
         lda   b,y
         cmpa  #$2F
         bne   L3D72
L3D7D    stb   <u00E1
         ldb   <u005B
         subb  <u00E1
         cmpb  #$19
         bcc   L3D89
         clr   <u00E1
L3D89    lda   <u005B
         cmpb  #$1D
         bls   L3D93
         lda   <u00E1
         adda  #$1D
L3D93    tfr   a,b
         deca
         ldx   #$2E63  ".cal"
         ldu   #$616C
         cmpu  a,y
         bne   L3DA7
         suba  #$02
         cmpx  a,y
         beq   L3DB8
L3DA7    ldb   <u00E1
         bne   L3DAF
         ldb   <u005B
         subb  #$19
L3DAF    addb  #$1A
         stx   b,y
         addb  #$02
         stu   b,y
         incb
L3DB8    incb
L3DB9    clr   b,y
         stb   <u0036
         clr   <u00E1
         tst   <u0019
         bne   L3E1F
         lda   <u000E
         suba  #$21
         leau  $0D,y
         tst   <u00ED
         bne   L3DDD
         lbsr  L0925
         lda   #$2D
         sta   $0B,y
         lbsr  L1AB3
         lda   <u000E
         suba  #$1A
         tfr   y,u
L3DDD    bsr   L3DE6
         ldb   <u0036
         lda   #$20
         sta   b,y
         rts
L3DE6    sta   <u0079
         lda   $03,u
         lbsr  L08E0
         lbra  L3E56

L3DF0    lbsr  L3C07
         ldu   <u006E
         stu   <u0068
         bsr   L3E15
         cmpu  #$FFFF
         bne   L3E4B
         bsr   L3E15
         pshs  u
         ldx   <MEMPTR
         leau  >$0580,x
L3E09    bsr   L3E20
         sta   ,u+
         beq   L3E23
         bsr   L3E20
         sta   ,u+
         bra   L3E09

L3E15    bsr   L3E20
         tfr   a,b
         bsr   L3E20
         exg   a,b
         tfr   d,u
L3E1F    rts
L3E20    lbra  L3EA9

L3E23    leau  >$04FF,x
         ldb   #$41
L3E29    bsr   L3E20
         sta   ,u+
         decb
         bne   L3E29
         bsr   L3E15
         stu   <u0068
         bsr   L3E15
         tfr   u,d
         stb   <u00A3
         bsr   L3E15
         stu   <u0097
         puls  u
         cmpu  #$0010
         bcs   L3E49
         lbsr  L3B62
L3E49    bsr   L3E15
L3E4B    com   <u00BC
         stu   <u00F4
         lbra  L3EE8

L3E52    tst   <u00A7  number of characters in input buffer
         bne   L3E1F
L3E56    pshs  u,y,x,b,a
         ldu   <MEMPTR
         leau  >u0700,u
         stu   <u00D1
         ldx   <u0044
         leax  >-$0700,x
         beq   L3EA3
         ldd   <u00ED
         clra
         tstb
         bne   L3E74
         ldb   #$0D
         stb   <u00D0
         ldb   #$01
L3E74    tfr   x,y
         tfr   b,a
         ldx   <u00D1
         ldb   <u00D0
         cmpb  #$0C
         bne   L3E85
         os9   I$Read
         bra   L3E88

L3E85    os9   I$Write
L3E88    lbcs  L3C23
         tfr   y,d
         cmpd  #$0200
         beq   L3E9E
         ldx   <MEMPTR
         leax  >$0700,x
         clr   d,x
         com   d,x
L3E9E    ldx   #$0700
         stx   <u0044
L3EA3    puls  pc,u,y,x,b,a

L3EA5    tst   <u00A7  number of characters in input buffer
         bne   L3ED6  call os9 write
L3EA9    pshs  x,b
         ldx   <u0044
         cmpx  #$0900
         bne   L3EB6
         bsr   L3E56
         ldx   <u0044
L3EB6    pshs  a
         ldd   <MEMPTR
         leax  d,x
         puls  a
         tst   <u00EE
         beq   L3EC8
         ldb   <u00D0
         cmpb  #$0D
         bne   L3ECC
L3EC8    sta   ,x
         bra   L3ECE

L3ECC    lda   ,x
L3ECE    ldx   <u0044
         leax  $01,x
         stx   <u0044
         puls  pc,x,b

L3ED6    pshs  y,x,a
         lda   #$01
         leax  ,s
         ldy   #$0001
         os9   I$Write
         puls  pc,y,x,a

L3EE5    lbsr  L3E15
L3EE8    cmpu  <u00F4
         lbcs  L3F52
         stu   <u00F4
         lbsr  L1ADD
         bsr   L3EA9
         tsta
         beq   L3F2A
         tfr   a,b
         bsr   L3EA9
         cmpb  #$02
         bne   L3F15
         tst   <u0080
         beq   L3EE5
         anda  #$07
         sta   <u0036
         ldx   <u007E
         lda   $01,x
         anda  #$D8
         ora   <u0036
         sta   $01,x
         bra   L3EE5

L3F15    sta   <u001C
         lbsr  L1AE6
         ldb   <u00FF
         subb  #$02
         tfr   x,u
L3F20    lbsr  L3EA9
         sta   ,u+
         decb
         bne   L3F20
         bra   L3EE5

L3F2A    ldu   <u006E
         cmpu  #$FFFF
         lbne  L3F52
         ldu   <MEMPTR
         leax  >u0292,u
         leau  >u06C0,u
         bsr   L3F61
         ldu   <u0068
         lbsr  L1ADD
         lbsr  L3CD3
         lbsr  L0027
         clr   <u00D6
         clr   <u00BC
         lbra  L08C8

L3F52    lbsr  L3CD3
         leau  >L3FF6,pcr  string 'Wrong format'
         bsr   L3FC3
         lbsr  L1AC5
         lbra  L08C5 Initialise data and terminal

* Copy path until space or question mark
L3F61    clrb
L3F62    lda   b,x
         sta   b,u
         incb
         cmpa  #$20
         beq   L3F71
         cmpb  #$3F
         bne   L3F62
         clr   ,u
L3F71    clr   b,u
         rts

L3F74    lbsr  L0934    Read the option section from path #0
         clr   $04,x   Turn off echo
         clr   <$10,x  Turn off interrupt character
         clr   <$11,x  Turn of abort character
         clr   $0C,x   Turn of EOF character
         lbsr  L0937   Write the option section
         lbra  L08C8

L3F87    lda   #$02
         os9   F$PErr
         bra   L3F93

L3F8E    lbsr  L0922
         bsr   L3FC6
L3F93    leau  >L3FEF,pcr   String "OS9>"
         bsr   L3FC3
         clra
         ldx   <MEMPTR
         leax  >$0200,x
         tfr   x,u
         ldy   #$01FF
         os9   I$ReadLn
         cmpy  #$0001
         beq   L3F74
         leax  >L3FD4,pcr  String 'SHELL'
         ldd   #$1100
         os9   F$Fork
         bcs   L3F87
         os9   F$Wait
         tstb
         bne   L3F87
         bra   L3F93

L3FC3    lbra  L1AB9  output string pointed to in U

L3FC6    lbsr  L1B10
         ldx   <u0030
         leax  <$2F,x
         clra
         clrb
         os9   I$SetStt
         rts

L3FD4    fcs   "SHELL"
L3FD9    fcc   " File? "
         fcb   $00
L3FE1    fcc   "Load :"
         fcb   $00
L3FE8    fcc   "Save :"
         fcb   $00

L3FEF    fcb   $0D
         fcc   "OS9> "
         fcb   $00

L3FF6    fcb   $0D
         fcb   $0A
L3FF8    fcc   "Wrong Format !"
         fcb   $00

L4007    fcb   $0D
         fcb   $0A
         fcc   "Delete original? "
         fcb   $00
L401B    fcc   "Error! #"
         fcb   $00

L4024    ldy   <u006C
         beq   L4031
L4029    ldd   ,--u
         std   ,--x
         leay  -$01,y
         bne   L4029
L4031    tst   <u007D
         beq   L4039
         lda   ,-u
         sta   ,-x
L4039    rts
L403A    bsr   L4024
         lbsr  L1AA4
         lbra  L1A9E

L4042    fcb   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcb   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcb   $00

L4065    bra  L406D
L4067    lbra  L42AB
L406A    lbra  L45E4

* Delete/Insert/move/replicate
L406D    cmpa  #'S
         bne   L40DB
         lbsr  L1AB3
         leau  >L408B,pcr  String "Max Col/Row - "
         lbsr  L40BF
         ldu   <MEMPTR
         leay  >u01BF,u
         clrb
         lbsr  L429C
         lbsr  L1AC5
L4088    lbra  L1A9E

L408B    fcc   "Max Col/Row - "
         fcb  0

L409A    ldy   <u0068
         bra   L40A2

L409F    ldy   <u00CE
L40A2    stx   ,y
         stu   $02,y
         ldu   #$0100
         lda   ,y
         cmpa  $02,y
         bne   L40B2
         ldu   #$0001
L40B2    stu   $06,y
L40B4    ldd   ,y
         subd  $06,y
         std   $04,y
         lda   #$FF
         sta   $08,y
         rts
L40BF    lbra  L1AB9  output string pointed to in U

L40C2    lbsr  L0901
L40C5    lbra  L1B0A

L40C8    ldx   <MEMPTR
         leau  <$20,x
         stu   <u00F4
         leau  <$60,x
         stu   <u00CE
         leau  >u02A0,u
         stu   <u0068
         rts

L40DB    cmpa  #'R
         lbne  L42B0
         bsr   L40C2
         leau  >L4705,pcr  String 'Replicate'
         lbsr  L3ADE
         leau  >L4727,pcr  String 'Source'
         lbsr  L427B
         bsr   L409F
         stu   <u006C
         clra
         clrb
         subd  <u006C
         std   <u00CA
         leau  >L4712,pcr  String 'Destination'
         lbsr  L427B
         bsr   L409A
         ldu   $02,y
         lbsr  L4EC1
         bcc   L410E
         lbra  L1ACE

L410E    lbsr  L1AB3
         leau  >L4705,pcr  String 'Replicate'
         bsr   L40BF
         ldy   <u00CE
         lbsr  L4291
         leau  >L472E,pcr  String ' > '
         bsr   L40BF
         ldy   <u0068
         lbsr  L4291
         lbsr  L0925
         lbsr  L3AF3
         ldu   <u006E
         pshs  u
         inc   <u00BC
L4135    lbsr  L4230
         ldd   $06,y
         addd  <u00CA
         std   <u00CA
         tst   <u00C9
         lbne  L4217
         lbsr  L1ACB
         stb   <u008B
         stb   <u00AE
         beq   L4135
         ldb   ,x
         lda   $01,x
         sta   <u001C
         leax  $02,x
         bita  #$10
         bne   L41BF
         clr   <u008B
         cmpb  #$0A
         beq   L41BF
         pshs  x,b,a
         ldb   -$02,x
         clra
         stu   <u006E
         leay  -$02,x
         leau  d,y
         stu   <u0051
         lda   -$01,x
         leax  $08,x
         lbsr  L42A1
         bcc   L41B2
         clr   <u00CC
         ldu   <u00F4
         stu   <u00FA
         clr   <u0079
         lbsr  L08D1
         ldx   <u00DA
         lbsr  L08CE
         clr   <u0078
         lbsr  L08D7
         leau  >L4747,pcr   String "  < R(elative) or S(ame) ?"
         lbsr  L40BF
         lbsr  L19D5
         lbsr  L090A
         ldu   <u00F4
L4199    ldb   ,u
         coma
         lbsr  L090D
L419F    lbsr  L0904
         cmpa  #$53
         beq   L41AB
         cmpa  #$52
         bne   L419F
         clra
L41AB    sta   ,u+
         cmpu  <u00FA
         bne   L4199
L41B2    puls  x,b,a
         ldu   <MEMPTR
         lbsr  L2AA5
         clr   <u00AE
         subb  #$08
         leax  $08,x
L41BF    subb  #$02
         stb   <u0074
         clra
         sta   <u007D
         lsrb
         ror   <u007D
         std   <u006C
         ldu   <MEMPTR
         leau  >u0400,u
         stu   <u0089
         lda   <u001C
         sta   -1,u
         lbsr  L1AC8
L41DA    bsr   L422B
         tst   <u00C9
         lbne  L4135
         ldd   $04,y
         addd  <u00CA
         tfr   d,u
         lbsr  L1ACB
         stx   <u007E
         stu   <u006E
         tst   <u008B
         bne   L41F8
         lbsr  L1A95
         bra   L41DA

L41F8    lda   <u001C
         clrb
         tst   <u0074
         beq   L4204
         lbsr  L1AAA
         bra   L41DA

L4204    cmpx  #$0000
         beq   L41DA
         anda  #$07
         sta   <u0036
         lda   $01,x
         anda  #$D8
         ora   <u0036
         sta   $01,x
         bra   L41DA

L4217    puls  u
         clr   <u00BC
         lbsr  L1ADD
         lbsr  L1AA4
         tst   <u00B6
         bne   L4228
         lbra  L001E

L4228    lbra  L4088

L422B    ldy   <u0068
         bra   L4233

L4230    ldy   <u00CE
L4233    clr   <u00C9
         ldd   $04,y
         addd  $06,y
         bcc   L423F
         tst   $08,y
         beq   L4246
L423F    clr   $08,y
         cmpd  $02,y
         bls   L424E
L4246    com   <u00C9
         ldd   ,y
         subd  $06,y
         inc   $08,y
L424E    std   $04,y
         tfr   d,u
         rts
L4253    leau  >L4286,pcr   String ' <INVALID'
         ldx   <u00C1
L4259    stx   <u00C1
         lbsr  L3ADE
         lbsr  L40C8
         ldu   <u00C1
         lbsr  L3ADE
         lbsr  L08FB
         ldu   <u006A
         ldx   <u00B1
         ldd   <u006A
         cmpa  <u00B1
         beq   L4277
         cmpb  <u00B2
         bne   L4253
L4277    cmpu  <u00B1
         rts
L427B    leax  >L4732,pcr String 'Range?'
         bsr   L4259
         bhi   L4285
         exg   u,x
L4285    rts

L4286    fcc  " <INVALID."
         fcb 0

L4291    clrb
         bsr   L429C
         leau  >L476A,pcr  String '...'
         lbsr  L40BF
         clrb
L429C    lbra  L08FE

L429F    lda   ,x+
L42A1    cmpa  #$40
         bcs   L42AB
         cmpa  #$80
         bcs   L42AF
         leax  $08,x
L42AB    cmpx  <u0051
         bcs   L429F
L42AF    rts

L42B0    cmpa  #'D
         lbeq  L4340
         cmpa  #'M
         bne   L42C3
         clr   <u00DE
         leau  >L46F5,pcr  String 'Move'
         lbra  L4471

L42C3    lbsr  L4463
         clr   $0E,y
         lbsr  L4499
         inc   -$0D,y
         tfr   y,u
         lda   -$0D,y
         sta   $0E,y
         lbsr  L4499
         tsta
         bne   L42EF
         dec   $0E,u
         dec   -$0D,u
L42DD    ldu   <u008E
         lbsr  L1ACB
         beq   L42EB
         leau  >L476E,pcr
         lbra  L1AEC

L42EB    inc   $0E,y
         bne   L42DD
L42EF    ldu   <u0073
         bsr   L4304
L42F3    clra
L42F4    sta   -$10,y
         bsr   L430B
         lda   -$10,y
         inca
         beq   L4301
         cmpa  -$0D,y
         bls   L42F4
L4301    lbra  L4371

L4304    pshs  y
         lbsr  L1B01
         puls  pc,y
L430B    pshs  y
         lbsr  L4499
         lda   <$31,y
         sta   -$10,y
         lbsr  L43C0
         ldu   <u006C
         stu   <u00DC
         ldx   ,u
         bra   L432D

L4320    ldu   <u008E
         pshs  y
         ldy   <u006C
         ldx   ,y
         stu   ,y
         puls  y
L432D    stx   <u008E
         lbsr  L43B0
         bcs   L4320
         tst   <u00A1
         bne   L433A
         ldx   <u00DA
L433A    ldu   <u00DC
         stx   ,u
         puls  pc,y
L4340    lbsr  L445D
L4343    clr   <$31,y
         ldu   <u0081
         stu   <u0084
L434A    ldu   <u00B1
         tst   <u00A1
         bne   L435C
         lbsr  L1ACB
         beq   L435C
         pshs  y
         lbsr  L4EBE
         puls  y
L435C    bsr   L4385
         lda   <$31,y
         inca
         beq   L436B
         sta   <$31,y
         cmpa  -$0D,y
         bls   L434A
L436B    ldx   <u0084
         stx   <u0081
         com   <u00E1
L4371    lbsr  L43C7
L4374    clr   <u00E1
         tst   <u00DF
         bne   L43C6
         ldu   <u006E
         lbsr  L1ADD
         lbsr  L0027
         lbra  L08C8

L4385    pshs  y
         lbsr  L4499
         ldu   <u00B1
         stu   <u0070
         bsr   L43C0
         tst   <u00A1
         beq   L439A
         ldu   <u006C
         ldx   ,u
         stx   <u00DC
L439A    bsr   L43B0
         bcc   L43A8
         ldu   <u006C
         ldx   ,u
         ldu   <u00AF
         stx   ,u
         bra   L439A

L43A8    ldx   <u00DC
         ldu   <u00AF
         stx   ,u
         puls  pc,y
L43B0    ldd   <u006C
         std   <u00AF
         clra
         lda   -$10,y
         inca
         beq   L43C6
         cmpa  -$0D,y
         bhi   L43C6
         sta   -$10,y
L43C0    ldu   <u0070
         lbsr  L1ACB
         coma
L43C6    rts
L43C7    lbsr  L4499
         ldx   <u0017
         stx   <u0051
L43CE    lbsr  L4ED6
         bcs   L43E9
         tst   <u00B3
         bne   L43C6
         ldx   <MEMPTR
         leax  >$0580,x
L43DD    ldb   ,x+
         beq   L43C6
         lda   ,x+
         bsr   L442A
         sta   -$01,x
         bra   L43DD

L43E9    lda   $01,x
         bita  #$10
         bne   L43CE
         cmpb  #$0A
         bls   L43CE
         leax  $09,x
         ldb   ,x
         sta   ,x
         pshs  x,b
L43FB    lbsr  L42AB
         bcc   L4420
         ldu   ,x++
         stu   <u008E
         lda   $0E,y
         clrb
         bsr   L442A
         bcs   L4413
         sta   $0E,y
         ldu   <u008E
         stu   -$02,x
         bra   L43FB

L4413    lda   -$03,x
         anda  #$3F
         sta   -$03,x
         ldd   #$2A2C
         std   -$02,x
         bra   L43FB

L4420    puls  x,b
         lda   ,x
         stb   ,x
         sta   -$08,x
         bra   L43CE

L442A    cmpa  <u0089
         bcs   L445B
         bne   L4442
         comb
         tst   <u00A1
         beq   L443D
         tst   <u00E1
         beq   L4454
         lda   <u008A
         bra   L445B

L443D    tst   <u00E1
         beq   L4454
         rts
L4442    cmpa  <u008A
         bhi   L445B
         bne   L4454
         tst   <u00A1
         beq   L4454
         tst   <u00E1
         bne   L4454
         lda   <u0089
         bra   L445B

L4454    inca
         tst   <u00E1
         beq   L445B
         suba  #$02
L445B    clrb
         rts

L445D    leau  >L46D7,pcr  String 'Delete'
         bra   L4467

L4463    leau  >L46E6,pcr   String 'Insert'
L4467    stu   <u00AF
         ldx   <MEMPTR
         leay  >$0180,x
         clr   <u00B3
L4471    lbra  L1AEF

         leay  $01,y
         com   <u00B3
         lda   <-$12,y
         cmpa  <$3F,y
         bhi   L44B4
         lda   <-$12,y
         sta   <u0089
         ldu   <u00BF
         stu   <u0073
         ldu   <u00DA
         stu   <u00DC
         clr   <u00A1
         lda   #$FF
         sta   <u008A
         bsr   L44A6
         ldu   <u006E
         stu   <u00B1
L4499    leay  $01,y
         exg   d,y
         cmpb  #$81
         exg   d,y
         beq   L44A5
         leay  -$02,y
L44A5    rts
L44A6    lbsr  L1AB3
         ldu   <u00AF
         bsr   L44B1
         leau  >L4762,pcr  String 'Working'
L44B1    lbra  L40BF

L44B4    lbra  L4088

         lbsr  L40C2
         leax  >L473B,pcr  String 'From...To'
         leau  >L46F5,pcr  String 'Move'
         lbsr  L4259
         beq   L44B4
         bcs   L44CB
         inc   <u00E1
L44CB    clr   <u00B3
         ldu   <MEMPTR
         leay  >u0180,u
         cmpa  <u00B1
         bne   L44DD
         leay  $01,y
         lda   <u00B2
         com   <u00B3
L44DD    lda   <$31,y
         ldb   <-$16,y
         tst   <u00E1
         bne   L44E9
         exg   a,b
L44E9    std   <u0089
         stb   <u00A1
         ldu   <u00BF
         stu   <u0073
         lda   <$31,y
         cmpa  <-$16,y
         bhi   L44FC
         lda   <-$16,y
L44FC    sta   -$0D,y
         ldu   <u0073
         lbsr  L4304
         lbsr  L4499
         tst   <u00E1
         lbne  L4343
         ldu   <u006A
         stu   <u00B1
         lbra  L42F3

         inc   <u00DE
         leau  >L4720,pcr  String 'Sort'
         stu   <u00AF
         lbsr  L427B
         lbeq  L4088
         pshs  u,x
         lbsr  L44A6
         puls  u,x
         pshs  u,x
         lbsr  L409F
         puls  u,x
         lbsr  L409A
         lbsr  L4230
L4536    ldy   <u0068
         lbsr  L40B4
         stu   $02,y
         lbsr  L4230
         clr   <u00DF
         tst   <u00C9
         lbne  L4374
         stu   <u00C1
         inc   <u00DF
         bsr   L45AD
         beq   L45A9
         std   <u00F6
         lbsr  L4ED9
L4556    lbsr  L422B
         tst   <u00C9
         bne   L45A9
         lda   <u00F6
         sta   <u00FC
         bsr   L45AD
         beq   L458F
         cmpb  <u00F7
         bne   L458F
         ldu   <u00FA
         tstb
         bne   L4577
         lda   #$07
         sta   <u0025
         lbsr  L002A
         bra   L458F

L4577    lda   ,x+
         bsr   L45CF
         pshs  a
         lda   ,u+
         bsr   L45CF
         cmpa  ,s+
         bne   L458F
         dec   <u0099
         beq   L458E
         coma
         dec   <u00FC
         bne   L4577
L458E    incb
L458F    beq   L4556
         tfr   cc,a
         eora  <u00DE
         tfr   a,cc
         bcc   L4556
         ldx   <MEMPTR
         ldx   <$64,x
         ldu   $04,y
         stx   <u00B1
         stu   <u006A
         lda   <u006A
         lbsr  L44CB
L45A9    ldu   <u00C1
         bra   L4536

L45AD    lbsr  L1ACB
         beq   L45CE
         ldd   ,x++
         andb  #$10
         suba  #$02
         beq   L45CE
         sta   <u0099
         tstb
         beq   L45CC
         lda   #$20
L45C1    cmpa  ,x
         bne   L45CC
         leax  $01,x
         dec   <u0099
         bne   L45C1
         rts
L45CC    lda   <u0099
L45CE    rts
L45CF    cmpa  #$20
         beq   L45E3
         cmpa  #$40
         bcs   L45E1
         sta   <u0036
         anda  #$DF
         cmpa  #$5A
         bls   L45E3
         lda   <u0036
L45E1    ora   #$80
L45E3    rts

* Locate command
L45E4    leau  >L46CA,pcr String 'Search for?'
         lbsr  L3ADE
         clr   <u009A
         lbsr  L3ADB
         subb  #$0C
         beq   L4608
         ldd   <u006E
         std   <u00F1
         cmpa  <u00BF
         bcs   L4613
         bne   L4602
         cmpb  <u00C0
         bls   L4613
L4602    inc   <u00E1
         clra
         clrb
         bra   L4629

L4608    lbra  L4088

L460B    ldd   <u00F1
         bra   L4629

L460F    cmpa  #$1B
         beq   L460B
L4613    ldd   <u006E
         tfr   d,x
         cmpb  <u00C0
         bcs   L4628
         ldb   #$FF
         cmpa  <u00BF
         bne   L4627
         lda   #$FF
         tst   <u00E1
         bne   L460B
L4627    inca
L4628    incb
L4629    std   <u006E
         cmpd  <u00F1
         bcs   L4636
         beq   L4608
         cmpx  <u00F1
         bcs   L460B
L4636    ldu   <u006E
         lbsr  L1ADD
         lbsr  L1ACB
         beq   L4613
         ldd   ,x++
         bitb  #$10
         beq   L4613
         suba  #$02
         bls   L4613
         tfr   a,b
L464C    ldu   <u00E9
         leau  >$0C,u
         lda   ,u
         suba  #$40
         bne   L465A
         leau  1,u
L465A    sta   <u00B3
         bsr   L46AC
         bne   L466B
         pshs  u,x,b
L4662    bsr   L46AC
         bne   L4669
         decb
         bne   L4662
L4669    puls  u,x,b
L466B    decb
         bne   L464C
         bra   L4613

L4670    leas  $07,s
         clr   <u00CC
         lda   <MEMPTR
         adda  #$04
         sta   <u008C
         lbsr  L1ADA
L467D    lda   <MEMPTR
         adda  #$02
         sta   <u008C
         lbsr  L1AB3
         leau  >L46F5,pcr  String 'Move'
         lbsr  L40BF
         ldd   #$3F20
         lbsr  L1AA1
         lbsr  L1B10
         lbsr  L0919
         anda  #$5F
         cmpa  #$59
         lbne  L460F
         ldu   <u006E
         ldd   <u006E
         ldx   <u00F1
         stx   <u006E
         lbra  L1B0D

L46AC    lda   ,u+
         cmpa  #$0D
         beq   L4670
         cmpa  #$3F
         bne   L46B8
         lda   ,x
L46B8    bsr   L46C3
         pshs  a
         lda   ,x+
         bsr   L46C3
         cmpa  ,s+
L46C2    rts
L46C3    tst   <u00B3
         beq   L46C2
         lbra  L0940

L46CA    fcc   "Search for? "
         fcb 0

L46D7    fcc   "Delete"
         fcb 0
         fcb   'C,$29,$e3
         fcb   'R,$29,$df
         fcb   '?,$96

L46E6    fcc   "Insert"
         fcb 0
         fcb   'C,$29,$e3
         fcb   'R,$29,$df
         fcb   '?,$98

L46F5    fcc   "Move"
         fcb 0
         fcb   'A,$2A,$80
         fcb   'D,$2A,$7E
         fcb   'M,$2A,$22
         fcb   '?,$A0

L4705    fcc   "Replicate - "
         fcb 0
L4712    fcc   "  Destination"
         fcb 0
L4720    fcc   "Sort :"
         fcb 0
L4727    fcc   "Source"
         fcb 0
L472E    fcc   " > "
         fcb 0
L4732    fcc   " Range? "
         fcb 0
L473B    fcc   " From...To "
         fcb 0
L4747    fcc   "  < R(elative) or S(ame) ?"
         fcb 0
L4762    fcc   " Working"
L476A    fcc   "..."
         fcb 0
L476E    fcb $0D
         fcb $0A
         fcc "NO ROOM !"
         fcb 0
         fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

L478D    bra L47A4
L478F    lbra  L4A0E
L4792    lbra  L4E73
L4795    lbra  L4E2B
L4798    lbra  L4814
L479B    lbra  L4E6C
L479E    lbra  L47B5
L47A1    lbra  L4E2D

L47A4    cmpa  #'P
         bne   L47AF
         leau  >L4CDF,pcr  String 'Printer'
L47AC    lbra  L1AEF

L47AF    leau  >L4CBC,pcr  String 'Data file'
L47B3    bra   L47AC

L47B5    tst   <u00E0
         beq   L47C6
         cmpa  #$1B
L47BB    bne   L47C6
L47BD    lbsr  L0919
         cmpa  #$1B
         bne   L47C7
         leas  $02,s
L47C6    rts
L47C7    cmpa  #$03
         beq   L47CF
         cmpa  #$0D
         bne   L47BD
L47CF    lbra  L4977

L47D2    lbsr  L0928
         bsr   L4811
         leau  >L4C60,pcr   String 'Range?'
         bsr   L4811
         lbsr  L1B10
         lbsr  L0916
         cmpa  #$0D
         beq   L47FE
         lbsr  L08FB
L47EA    ldb   <u005B
         incb
         clr   b,y
         lbsr  L1AB3
         lda   #$2D
         sta   $0E,y
         tfr   y,u
         lbsr  L49B5  output string pointed to in U
         lbra  L0925

L47FE    lbsr  L0904
         clra
         clrb
         std   <u00B1
         ldd   <u00BF
         std   <u006A
         leau  >L4C6B,pcr  String 'Entire'
         bsr   L4811
         bra   L47EA

L4811    lbra  L3ADE

* Printer
L4814    leau  >-$0187,y
         lda   ,u
         sta   <u0069
         leau  $03,u
         ldd   ,u++
         sta   <u003B
         stb   <u003F
         ldd   ,u
         std   <u0062
         lbsr  L0901
         lbsr  L4D3F
         tst   <u0012
         bne   L487B
         leax  >$0400,y
         tst   ,x
         beq   L485E
         leau  $0D,y
         lbsr  L3B0E
         lbsr  L3B0B  Open file
         sta   <u0012 store new path number
         clr   <u00EE
         bsr   L4850
         bra   L4869

L484A    ldx   #$0200
         lbra  L08CE

L4850    lbsr  L4D3A
         lda   <u000E
         suba  #$34
         leau  >$0400,y
         lbra  L3B08

L485E    bsr   L484A
         leau  >L4C87,pcr  String 'Output'
         lbsr  L3B02
         sta   <u0012
L4869    clr   <u00EE
         ldb   <u00E1
         decb
         stb   <u0013
         leax  $0D,y
         leau  >$0400,y
         lbsr  L3B0E
         bra   L487D

L487B    bsr   L4850
L487D    lda   #$0D
         sta   <u00D0
         sta   <u009A
         bsr   L484A
         leau  >L4C54,pcr  String 'Print'
         lbsr  L47D2
         lda   <u0013
         sta   <u00E2
         tst   <u0062
         bne   L48D8
         lbsr  L0928
         leau  >L4C7E,pcr  String 'Title?'
         lbsr  L4811
         clr   <u009A
         inc   <u0060
         lbsr  L3ADB
         lda   <u003F
         suba  #$2E
         clr   b,y
         subb  #$08
         stb   <u0025
         leax  >$0180,y
         leay  $08,y
         clr   a,y
         clrb
L48B8    ldu   b,y
         stu   b,x
         addb  #$02
         cmpb  <u0025
         bls   L48B8
         suba  <u0025
         bhi   L48C7
         clra
L48C7    adda  #$05
         tst   <u003B
         beq   L48CF
         adda  #$07
L48CF    sta   <u00F1
         lbsr  L4A38
         inc   <u00F4
         clr   <u00F5
L48D8    lbsr  L49B2
         ldb   <u0012
         stb   <u00EE
         lda   #$A8
         bsr   L4944
         inc   <u00E0
         lbsr  L49F6
         ldd   <u00B1
         ldx   <u006A
         lbsr  L001B
         std   <u006A
         ldx   <u000D
         ldu   <u0097
         clra
         clrb
         std   <u0097
         pshs  u,x
         ldx   <MEMPTR
         leax  >$0500,x
         leay  <$10,x
         ldd   #$FB28
         bsr   L494B
         clrb
         std   $06,y
         ldu   <u00A2
         sts   <u00CE
         ldd   $08,u
         std   $08,y
         ldd   <u006A
         std   ,y
         ldd   <u00F2
         subd  <u006A
         addb  #$05
         stb   <u000D
         tsta
         bpl   L4926
         lda   #$7F
L4926    sta   <u0036
         lda   <u006A
         ldb   <u003F
         tst   <u003B
         bne   L4932
         subb  #$04
L4932    stb   <u0094
         clr   -$02,y
L4936    inc   -$02,y
         lbsr  L1AF5
         bcs   L4957
         inca
         dec   <u0036
         bpl   L4936
         bra   L495F

L4944    tst   <u00E2
         bne   L4956
         lbra  L093D

L494B    leau  d,x
         lda   #$20
L494F    ldb   ,x+
         stb   ,u+
         deca
         bne   L494F
L4956    rts
L4957    dec   -$02,y
         bne   L495D
         inc   -$02,y
L495D    ldb   #$04
L495F    subb  #$04
         subb  <u003F
         negb
         stb   <u000E
         clr   <u00AC
         stb   $0F,y
         tst   <u0062
         bne   L4970
         bsr   L49B8
L4970    lda   <u003B
         sta   <u009B
         lbsr  L1AD1
L4977    lds   <u00CE
         ldx   <MEMPTR
         leax  <$28,x
         ldd   #$04D8
         bsr   L494B
         puls  u,x
         stx   <u000D
         stu   <u0097
         dec   <u00AC
         bsr   L49F6
         clr   <u00E0
         lda   #$AC
         bsr   L4944
         clr   <u00EE
         ldy   <u00E9
         tst   >-$01D4,y
         lbpl  L08C8
         tst   <u0013
         lbne  L4D82
         lbra  L4B50

L49AA    lda   #$20
         lbsr  L3AE7 write char
         decb
         bne   L49AA
L49B2    lbra  L3AF3


L49B5    lbra  L1AB9  output string pointed to in U

L49B8    clr   <u00E0
         leau  >L4E24,pcr   Series of newlines
         bsr   L49B5  output string pointed to in U
         inc   <u00E0
         ldu   <MEMPTR
         leau  >u0400,u
         bsr   L49B5  output string pointed to in U
         ldb   <u00F1
         bsr   L49AA
L49CE    ldu   <MEMPTR
         leau  >u0562,u    Date string M0562
         bsr   L49B5  output string pointed to in U
         tst   <u0091
         bne   L4A08
         leau  >L4E12,pcr  String 'DYNACALC'
         tst   <u003B
         beq   L49EA
         ldb   #$04
         bsr   L49AA
         leau  >L4E1F,pcr   String "PAGE"
L49EA    bsr   L49B5  output string pointed to in U
         inc   <u00F5
         ldb   <u00F5
         clra
         lbsr  L4E2B   number in decimal
         bsr   L49F6
L49F6    clr   <u00E0
         bsr   L4A09
         tst   <u00E2
         bne   L4A03
         lda   #$0A
         lbsr  L4AE5
L4A03    inc   <u00E0
         lbsr  L08F8 Read character from keyboard
L4A08    rts

L4A09    lda   #$0D
         lbra  L4AE5

L4A0E    tst   <u0062
         bne   L4A2D
         ldb   <u00F4
         subb  #$01
         bcs   L4A1E
         subb  <u0069
         stb   <u00F4
         bcc   L4A2D
L4A1E    bsr   L49B8
         bsr   L4A38
         tst   <u003B
         bne   L4A43
         pshs  y
         lbsr  L1AF8
         puls  y
L4A2D    ldb   <u0069
         stb   <u009D
L4A31    bsr   L49F6
         dec   <u009D
         bpl   L4A31
         rts
L4A38    lda   <u0063
         suba  #$06
         tst   <u003B
         bne   L4A41
         deca
L4A41    sta   <u00F4
L4A43    rts

L4A44    clr   <u00B3
         inc   <u00A7  number of characters in input buffer
         lbsr  L49B2
         leay  >-$0090,y
         leau  >L4CB7,pcr  String '/Row'
         stu   <u00DC
         leau  >L4CCE,pcr  String 'Order'
         lbra  L47AC

         tst   <u00EF
         beq   L4A75
         lbsr  L4C4D
         cmpa  #'/
         bne   L4A75
         lbsr  L4C22
         lbsr  L4C41
         anda  #$5F
         cmpa  #'R
         beq   L4A85
         bra   L4A7D

L4A75    sta   <u00D7
         lda   <u00EC
         cmpa  #$F0
         beq   L4A85
L4A7D    leay  $01,y
         leau  >L4CB2,pcr   String '/Col'
         stu   <u00DC
L4A85    sty   <u00EB
         rts

         leau  >L4C8E,pcr   string 'Save'
         lbsr  L3AF0
         bsr   L4A44
         leau  >L4C5A,pcr   String 'Block'
         lbsr  L47D2
         clr   <u00EF
         ldx   <u00B1
         ldd   <u006A
         inc   <u00E0
         lbsr  L001B
         std   <u00F6
         std   <u00F4
         ldy   #$51E8
         lda   #$03
         sta   <u0022
         clr   <u00E0
         clr   <u00C7
         inc   <u0091
         clr   <u00A7  number of characters in input buffer
         leau  >L4C9C,pcr  String "*DYNACALC Data File  "
         lbsr  L49B5  output string pointed to in U
         lbsr  L49CE
         bsr   L4AE0
         ldu   <u00DC
         lbsr  L49B5  output string pointed to in U
         bsr   L4AE0
L4ACB    ldu   <u00F4
L4ACD    lbsr  L1ACB
         beq   L4AD8
         lda   ,x
         suba  #$02
         bne   L4AE8
L4AD8    lda   #$3E
         bsr   L4AE5
         bsr   L4AE0
         bra   L4B16

L4AE0    lbra  L4A09

L4AE3    bsr   L4AE5
L4AE5    lbra  L091C

L4AE8    sta   <u0036
         leax  $01,x
         lda   ,x
         bita  #$08
         beq   L4AFA
         ldu   $02,x
         tst   $01,x
         bmi   L4ACD
         bra   L4AD8

L4AFA    ldb   #$14
         bita  #$10
         beq   L4B0C
         lda   $01,x
         bsr   L4B5D is char text?
         bne   L4B0A ..no
         lda   #$27  single quote
         bsr   L4AE5
L4B0A    ldb   <u0036
L4B0C    stb   <u0020
         ldy   <u00A2
         lbsr  L1AB6
         bsr   L4AE0
L4B16    ldu   <u00EB
         clr   <u00B3
L4B1A    inc   $04,u
         lda   $04,u
         beq   L4B24
         cmpa  2,u
         bls   L4ACB
L4B24    lda   $06,u
         sta   $04,u
         tst   <u00B3
         bne   L4B45
         inc   <u00B3
         bsr   L4B38
         lda   #$40
         bsr   L4AE5
         bsr   L4AE0
         bra   L4B1A

L4B38    leau  1,u
         exg   d,u
         cmpb  #$F1
         exg   d,u
         beq   L4B44
         leau  -2,u
L4B44    rts
L4B45    clr   <u00E0
         clr   <u0091
L4B49    lbra  L3AEA

         clr   >$0400,y
L4B50    clra
         sta   <u00D0
         sta   <u00EF
         ldb   <u0012
         std   <u00ED
         sta   <u0012
         bra   L4B49

L4B5D    cmpa  #$27   single quote
         beq   L4B7B
         cmpa  #'*
         beq   L4B7B
L4B65    cmpa  #'9
         bhi   L4B7B
         cmpa  #'0
         bcc   L4B79
         cmpa  #'.
         beq   L4B79
         cmpa  #'-
         beq   L4B79
         cmpa  #'+
         bne   L4B7B
L4B79    orcc  #Zero
L4B7B    rts

* Load file
         leau  >L4C95,pcr   String 'Load'
         lbsr  L3AF9
         clr   <u00D7
         com   <u00E2
         dec   <u0091
         lbsr  L4A44
         ldu   <u006E
         stu   <u00F4
         stu   <u00F6
         lbsr  L4C4D
         sta   <u00D7
         clr   <u00CD
         cmpa  #$2F
         bne   L4BA2
         clr   <u00D7
         lbsr  L4C41
L4BA2    lbsr  L4C4D
         cmpa  #$40
         beq   L4BF6
         cmpa  #$0D
         beq   L4BF0
         cmpa  #$3E
         bne   L4BB6
         clrb
         pshs  b
         bra   L4BD1

L4BB6    bsr   L4B65
         pshs  cc
         cmpa  #$27
         bne   L4BC8
         bsr   L4C22
         cmpa  #$0D
         bne   L4BC8
         sta   <u00D7
         lda   #$20
L4BC8    ldy   <u00E9
         clrb
L4BCC    sta   b,y
         incb
         bpl   L4BD5
L4BD1    bsr   L4C41
         bra   L4BDB

L4BD5    bsr   L4C22
         cmpa  #$0D
         bne   L4BCC
L4BDB    decb
         stb   <u005B
         ldu   <u00F4
         lbsr  L1ADD
         puls  cc
         beq   L4BED
         clra
         lbsr  L092B
         bra   L4BF0

L4BED    lbsr  L092E
L4BF0    ldu   <u00EB
         inc   $04,u
         bra   L4BA2

L4BF6    clrb
L4BF7    bsr   L4C22
         lbsr  L4B65
         bne   L4C0B
         suba  #$30
         bcs   L4C0B
         pshs  a
         lda   #$0A
         mul
         addb  ,s+
         bra   L4BF7

L4C0B    cmpa  #$0D
         beq   L4C11
         bsr   L4C41
L4C11    incb
         ldu   <u00EB
         lda   $06,u
         sta   $04,u
         lbsr  L4B38
         addb  $04,u
         stb   $04,u
         lbra  L4BA2

L4C22    lda   <u00D7
         bne   L4C2C
         lbsr  L3AFC
         tsta
         bmi   L4C2F
L4C2C    clr   <u00D7
         rts
L4C2F    ldu   <u00F6
         clr   <u004B
         stu   <u006E
         tst   <u00B6
         bne   L4C3C
         lbsr  L0027
L4C3C    inc   <u00ED
         lbra  L4B49

L4C41    pshs  a
L4C43    bsr   L4C22
         cmpa  #$0D
         bne   L4C43
         puls  pc,a
L4C4B    bsr   L4C41
L4C4D    bsr   L4C22
         cmpa  #$2A
         beq   L4C4B
         rts

L4C54    fcc  "Print"
         fcb   $00
L4C5A    fcc   "Block"
         fcb   $00
L4C60    fcc   " : Range ?"
         fcb   $00
L4C6B    fcc   "Entire"
         fcb   $00
L4C72    fcc   "NO DRIVER !"
         fcb   $00
L4C7E    fcc   "Title ? "
         fcb   $00
L4C87    fcc   "Output"
         fcb   $00
L4C8E    fcc   "Save :"
         fcb   $00
L4C95    fcc   "Load :"
         fcb   $00
L4C9C    fcc   "*DYNACALC Data File  "
         fcb   $00
L4CB2    fcc   "/Col"
         fcb   $00
L4CB7    fcc   "/Row"
         fcb   $00

L4CBC    fcc   "Data file"
         fcb   $00

         fcb   'L,$30,$e7
         fcb   'S,$2f,$f4
         fcb   '?,$86

L4CCE    fcc   "Order"
         fcb   $00
         fcb   'C,$2f,$e8
         fcb   $44,$2f,$c7
         fcb   $52,$2f,$f0
         fcb   '?,$a2

L4CDF    fcc   "Printer"
         fcb   $00
         fcb   'B,$32,$6F
         fcb   'C,$30,$b7
         fcb   'L,$32,$dc
         fcb   $50,$32,$66
         fcb   $53
         fcb   $33,$12
         fcb   $57,$32,$d3
         fcb   '?,$94

         ldx   #$00FE   Pagination variable (T/F)
         leau  >L4DC5,pcr  String 'Pagination now'
         bra   L4D0B

         ldx   #$00FC   Borders variable (T/F)
         leau  >L4DB8,pcr  String 'Borders now'
L4D0B    pshs  u,x
         lbsr  L1AB3
         ldx   <MEMPTR
         puls  u,b,a
         leax  d,x
         lbsr  L49B5  output string pointed to in U
         clrb
         leau  >L4DD5,pcr  String 'On'
         lda   ,x
         bne   L4D25
         comb
         leau  3,u
L4D25    stb   ,x
         lbra  L1AEC

L4D2A    ldb   #$3D
         lbsr  L1AA1
         lda   #$59
         tst   ,x+
         beq   L4D37
         lda   #$4E
L4D37    lbsr  L4AE5
L4D3A    lda   #$20
         lbra  L4AE3

L4D3F    lda   #$42
L4D41    leax  >-$0184,y
         bsr   L4D2A
         lda   #$57
         bsr   L4D58
         lda   #$50
         bsr   L4D2A
         lda   #$4C
         bsr   L4D58
         leax  -$07,x
         ldd   #$533D
L4D58    sta   <u0075
         lbsr  L1AA1
         lda   ,x+
         sta   <u0071
         lbsr  L08E3
         clr   <u0075
         bra   L4D3A

         ldx   #$FE7D
         leau  >L4DDC,pcr  String 'Printer width is'
         bra   L4D78

         ldx   #$FE7F
         leau  >L4DF0,pcr  String 'Lines per page'
L4D78    bsr   L4D85
         cmpb  #$0A    Test for value under 10
         bcs   L4D82
L4D7E    ldx   <u008E
         stb   ,x
L4D82    lbra  L1A9E

* Print string in U and decimal value in X
L4D85    pshs  u,x
         lbsr  L0901
         lbsr  L484A
         ldy   <u00E9
         puls  u,d
         leax  d,y
         stx   <u008E
         lbsr  L4811
         ldx   <u008E
         lda   ,x
         inca
         lbsr  L1AF2
         subb  #$01
         bcc   L4DA6
         incb
L4DA6    rts

         ldx   #$FE79   - Relative to content in u00E9
         leau  >L4E02,pcr  String 'Line spacing'
         bsr   L4D85
         cmpb  #$08     Check that max 8 was entered
         bcs   L4D7E
         ldb   #$07
         bra   L4D7E

L4DB8    fcc   "Borders now "
         fcb   $00

L4DC5    fcc   "Pagination now "
         fcb   $00

L4DD5    fcc   "On"
         fcb   $00
         fcc   "Off"
         fcb   $00
L4DDC    fcc   "Printer width is : "
         fcb   $00

L4DF0    fcc   "Lines per page : "
         fcb   $00
L4E02    fcc   "Line spacing : "
         fcb   $00

L4E12    fcc   "   DYNACALC  "
L4E1F    fcc   "PAGE"
         fcb   $00
L4E24    fcb   $0D,$0C,$0A,$0A,$0A,$0A,$00

* Print number in decimal
L4E2B    clr   <u0025
L4E2D    clr   <u006D
L4E2F    leax  >L4E63,pcr  Pointer to digits table
L4E33    bsr   L4E46
         tst   ,x
         bpl   L4E33
         tfr   b,a
         pshs  cc
L4E3D    inc   <u006D
L4E3F    adda  #$30
         lbsr  L3AE7 write char
L4E44    puls  pc,a
L4E46    clr   <u006C
L4E48    inc   <u006C
         subd  ,x
         bcc   L4E48
         addd  ,x++
         pshs  a
         lda   <u006C
         deca
         bne   L4E3D
         tst   <u006D
         bne   L4E3D
         tst   <u0025
         bne   L4E44
         lda   #$F0
         bra   L4E3F

L4E63    fdb   10000
         fdb   1000
         fdb   100
         fdb   10
         fcb   $FF

L4E6C    lda   #$1B
         sta   <u0019
         lbra  L4D82

* Create temporary file name
L4E73    leay  <$11,y
         leax  >L4EA6,pcr   String 'dyna.'
L4E7A    sta   <u006D
         sta   ,y+
         lda   ,x+
         bne   L4E7A
         ldu   #$0700
         stu   <u0044
         pshs  y
         os9   F$ID
         tfr   y,d
         puls  y
         bsr   L4E2F
         stu   <u0044
         ldd   <MEMPTR
         leau  d,u
         ldb   #$05
L4E9A    lda   ,u+
         sta   ,y+
         decb
         bne   L4E9A
         clr   <u00E1
         lbra  L3AD5

L4EA6    fcc   "dyna."
         fcb  0

L4EAC    fcb   $ef,$ff
         fcb   $ef,$ff
         fcb   $ef,$ff
         fcb   $ef,$ff
         fcb   $ef

L4EB5    lbra  L4EDC

L4EB8    rts

         fcb   $ff,$ff

L4EBB    lbra  L4FF5
L4EBE    lbra  L4F31
L4EC1    lbra  L4F6B
L4EC4    lbra  L4EEE
L4EC7    lbra  L08C5 Initialise data and terminal

         rts
         fdb   $FFFF
L4ECD    rts
         fdb   $FFFF
L4ED0    rts
         fdb   $FFFF
L4ED3    rts
         fdb   $FFFF

L4ED6    lbra  L4FFA

L4ED9    stx   <u00FA
         rts

L4EDC    ldd   <PARAMS
         subd  <u00C5
         addd  #$0001
         pshs  b,a
         ldd   <u0081
         subd  <u0017
         addd  ,s++
         lbra  L4795

L4EEE    clra
         ldx   <u007E
         beq   L4EFB
         stx   <u0084
         subb  ,x
         beq   L4F20
         sbca  #$00
L4EFB    ldu   <u006E
         bsr   L4F6B
         bcc   L4F08
         lda   <u00BC
         bne   L4F17
         lbra  L1ACE

L4F08    ldx   <u0081
         stx   <u0084
         leay  d,x
         sty   <u0081
         bsr   L4F6B
         bcc   L4F1A
         stx   <u0081
L4F17    lbra  L1AD7

L4F1A    ldx   <u007E
         beq   L4F20
         bsr   L4F31
L4F20    ldu   <u006E
         lbsr  L1B01
         lbsr  L1ACB
         ldu   <u006C
         ldx   <u0084
         stx   <u007E
         stx   ,u
         rts

L4F31    ldb   ,x
         tfr   x,u
         abx
         stx   <u006C
         ldd   <u0084
         subd  <u006C
         clr   <u007D
         lsra
         rorb
         ror   <u007D
         ldx   <u006C
         std   <u006C
         bsr   L4F4E
         lbsr  L1AC8
         stu   <u0084
         rts

L4F4E    pshs  u,x
         stx   <u00F8
         tfr   u,d
         subd  <u00F8
         std   <u00F2
         ldx   <u00C5
L4F5A    ldd   ,x++
         cmpd  <u00F8
         bcs   L4F65
         addd  <u00F2
         std   -$02,x
L4F65    cmpx  <u001E
         bcs   L4F5A
         puls  pc,u,x

L4F6B    pshs  u,x,b,a
         ldx   <u0023
         cmpx  <u0081
         bcc   L4F75
         ldx   <u0081
L4F75    tfr   u,d
         cmpa  <u00BF
         bcc   L4F7D
         lda   <u00BF
L4F7D    cmpb  <u00C0
         bcc   L4F83
         ldb   <u00C0
L4F83    tfr   d,u
L4F85    lbsr  L1AFE
         bcs   L4F95
         stx   <u006C
         cmpd  <u006C
         bcc   L4F95
         bsr   L4F97
         bcc   L4F85
L4F95    puls  pc,u,x,b,a

* Request more memory
L4F97    pshs  u,y,x,b,a
         ldd   #$0F00
         std   <u0046
L4F9E    ldd   <PARAMS
         subd  <MEMPTR
         tst   <u0043
         beq   L4FA9
         addd  #$5800
L4FA9    addd  #$0001
         std   <u006C
         addd  <u0046
         os9   F$Mem
         bcc   L4FC0
         lda   <u0046
         suba  #$02
         sta   <u0046
         bcc   L4F9E
         coma
         puls  pc,u,y,x,b,a

L4FC0    subd  <u006C
         std   <u0046
         lsra
         rorb
         addd  <u0023
         std   <u0023
         ldd   <u0046
         addd  <u001E
         std   <u001E
         ldd   <PARAMS
         subd  <u00C5
         addd  #$0002
         clr   <u007D
         lsra
         rorb
         lsr   <u007D
         std   <u006C
         ldd   <u0046
         addd  <u00C5
         std   <u00C5
         ldu   <PARAMS
         leax  -$01,y
         stx   <PARAMS
         tfr   y,x
         leau  1,u
         lbsr  L3AFF
         clra
         puls  pc,u,y,x,b,a

L4FF5    ldd   <u0017
         std   <u0081
         rts

L4FFA    ldx   <u0051
         ldb   ,x
         clra
         leau  d,x
         stu   <u0051
         cmpx  <u0081
         rts

         lbsr  L1AEC
         lbra  L1937

         fcc   "OK"
         fcb   0
         fcc   "BAD"
         fcb   0

         fcb   $02
         fcb   $08
         emod
eom      equ   *
