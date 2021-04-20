         nam   Stylo
         ttl   program module

         use defsfile

tylg     set   Prgrm+Objct
atrv     set   ReEnt+rev
rev      set   $03

L0000    mod   BINEND,name,tylg,atrv,start,size

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
TTYSTATE    rmb   1
u000F    rmb   1
u0010    rmb   1
u0011    rmb   1
u0012    rmb   1
u0013    rmb   1
u0014    rmb   1
u0015    rmb   1
u0016    rmb   1
u0017    rmb   1
u0018    rmb   1
u0019    rmb   1
u001A    rmb   1
u001B    rmb   1
u001C    rmb   1
u001D    rmb   1
u001E    rmb   1
u001F    rmb   1
u0020    rmb   1
u0021    rmb   1
u0022    rmb   2
u0024    rmb   1
u0025    rmb   1
u0026    rmb   1
u0027    rmb   1
u0028    rmb   1
u0029    rmb   1
u002A    rmb   1
u002B    rmb   1
u002C    rmb   1
u002D    rmb   1
u002E    rmb   1
u002F    rmb   1
u0030    rmb   1
u0031    rmb   1
u0032    rmb   1
u0033    rmb   1
u0034    rmb   1
u0035    rmb   1
u0036    rmb   1
u0037    rmb   1
u0038    rmb   1
u0039    rmb   1
u003A    rmb   1
u003B    rmb   1
u003C    rmb   2
u003E    rmb   1
u003F    rmb   1
u0040    rmb   1
u0041    rmb   1
u0042    rmb   1
u0043    rmb   2
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
u0057    rmb   1
u0058    rmb   1
u0059    rmb   2
u005B    rmb   1
u005C    rmb   1
u005D    rmb   2
u005F    rmb   1
u0060    rmb   1
u0061    rmb   1
u0062    rmb   1
u0063    rmb   1
u0064    rmb   1
u0065    rmb   3
u0068    rmb   2
u006A    rmb   2
u006C    rmb   1
u006D    rmb   1
u006E    rmb   2
u0070    rmb   2
u0072    rmb   2
u0074    rmb   1
u0075    rmb   1
u0076    rmb   1
u0077    rmb   2
u0079    rmb   1
u007A    rmb   2
u007C    rmb   2
u007E    rmb   1
u007F    rmb   2
u0081    rmb   2
u0083    rmb   1
u0084    rmb   1
u0085    rmb   1
u0086    rmb   2
u0088    rmb   3
u008B    rmb   1
u008C    rmb   2
u008E    rmb   2
u0090    rmb   2
u0092    rmb   2
u0094    rmb   2
u0096    rmb   2
u0098    rmb   2
u009A    rmb   1
u009B    rmb   1
u009C    rmb   1
u009D    rmb   1
u009E    rmb   2
u00A0    rmb   3
u00A3    rmb   1
u00A4    rmb   1
u00A5    rmb   1
u00A6    rmb   2
u00A8    rmb   1
u00A9    rmb   1
u00AA    rmb   1
u00AB    rmb   1
u00AC    rmb   1
u00AD    rmb   2
u00AF    rmb   2
u00B1    rmb   2
u00B3    rmb   2
u00B5    rmb   2
u00B7    rmb   2
u00B9    rmb   2
u00BB    rmb   2
u00BD    rmb   2
u00BF    rmb   2
u00C1    rmb   2
u00C3    rmb   1
u00C4    rmb   1
u00C5    rmb   1
u00C6    rmb   2
u00C8    rmb   2
u00CA    rmb   1
u00CB    rmb   2
u00CD    rmb   1
u00CE    rmb   2
u00D0    rmb   1
u00D1    rmb   1
u00D2    rmb   1
u00D3    rmb   1
u00D4    rmb   2
u00D6    rmb   1
u00D7    rmb   1
u00D8    rmb   1
u00D9    rmb   1
u00DA    rmb   1
u00DB    rmb   1
u00DC    rmb   1
u00DD    rmb   2
u00DF    rmb   1
u00E0    rmb   1
u00E1    rmb   1
u00E2    rmb   1
u00E3    rmb   1
u00E4    rmb   1
u00E5    rmb   3
u00E8    rmb   1
u00E9    rmb   1
u00EA    rmb   1
u00EB    rmb   2
u00ED    rmb   2
u00EF    rmb   1
u00F0    rmb   1
u00F1    rmb   1
u00F2    rmb   1
u00F3    rmb   2
u00F5    rmb   1
u00F6    rmb   1
u00F7    rmb   1
u00F8    rmb   1
u00F9    rmb   1
u00FA    rmb   5
u00FF    rmb   769
u0400    rmb   19456
size     equ   .

         fcb   $10
         fcb   $00
L000F    fcb   $14    MAXPAGES
         fcb   $28 (
L0011    fcb   $00
         fcb   $00
L0013    fcb   $00
         fcb   $00
L0015    fcb   $01  Load STYPS
         fcb   $00

         fdb   $0556 TXTBEG
         fdb   $1621 TXTEND
         fdb   $662B   BINEND
         fdb TRMBEG  $16BF
         fcb   $00
         fcb   $00
         fcb   $16
         fcb   $ED
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $0D
         fcc " STYLOGRAPH "
         fcb   $0D
         fcc "COPYRIGHT 1985"
         fcb   $0D
         fcc "STYLO SOFTWARE INC."
         fcb   $0D
name     equ   *
         fcs   /Stylo/

L0067    tfr   u,d
         tfr   s,y
         rts

L006C    pshs  y,x,b,a
         leax  $08,s
         stx   <u0004
         stx   <u0006
         leax  >IRQHNDLR,pcr
         ldu   #$0000
         os9   F$Icpt
         ldx   <u008E
         leay  >$0100,x
         leax  >$0BB5,y
         stx   <TTYSTATE
         leax  >$0BD5,y
         stx   <u0010
         leax  >$0BF5,y
         stx   <u0012
         ldu   <u0014
         leax  >$0B4D,y
         stx   u000A,u
         leax  >$0B59,y
         stx   u000C,u
         leax  >$0C4A,y
         stx   ,u
         bsr   L00F9
         leax  >$0C85,y
         stx   u0002,u
         bsr   L00F9
         leax  >$0CC0,y
         stx   u0004,u
         bsr   L00F9
         leax  >$0CFB,y
         stx   u0006,u
         bsr   L00F9
         leax  >$1100,y
         stx   u0008,u
         bsr   L00F9
         ldx   <u008E
         leax  >$0B65,x
         stx   <u00EB
         stx   <u00ED
         clra
         clrb
         ldx   <TTYSTATE
         os9   I$GetStt
         ldy   <u0010
         ldd   #$0020
         lbsr  L4D27
         ldx   <u0010
         clr   $04,x
         clr   $07,x
         lda   #$FF
         sta   $0C,x
         sta   $0F,x
         clra
         clrb
         os9   I$SetStt
         puls  pc,y,x,b,a
L00F9    pshs  u
         leau  $05,x
         stu   ,x
         stu   $02,x
         clr   $04,x
         puls  pc,u
L0105    pshs  y,x,b,a
         ldx   <u00EB
         anda  #$7F
         sta   ,x+
         stx   <u00EB
         leax  <-$50,x
         cmpx  <u00ED
         bcs   L012B
         bra   L011A
L0118    pshs  y,x,b,a
L011A    ldd   <u00EB
         subd  <u00ED
         beq   L012B
         tfr   d,y
         ldx   <u00ED
         stx   <u00EB
         lda   #$01
         os9   I$Write
L012B    puls  pc,y,x,b,a
L012D    rts
L012E    bra   L0118
         rts

* Read one character from stdin
L0131    bsr   L0118
         pshs  y,x,a
         tfr   s,x
         ldy   #$0001
         lda   #$00
         os9   I$Read
         puls  y,x,a
         anda  #$7F
         rts

* Interrupt handler
IRQHNDLR    rti

         pshs  b,a
         os9   F$Time
         lda   ,x
         ldb   $05,x
         sta   $05,x
         stb   ,x
         lda   $01,x
         ldb   $04,x
         sta   $04,x
         stb   $01,x
         lda   $02,x
         ldb   $03,x
         sta   $03,x
         stb   $02,x
         puls  pc,b,a

L0165    pshs  y,x,a
         tfr   s,x
         ldy   #$0001
         lda   <u0000
         os9   I$Write
         puls  pc,y,x,a

L0174    pshs  x,b,a
         lda   #$02
         ldb   #$03
         os9   I$Create
         bcs   L0185
         sta   <u0000
         andcc #$FC
         puls  pc,x,b,a

L0185    stb   <u0003
         orcc  #$01
         andcc #$FD
         puls  pc,x,b,a

L018D    pshs  a
         lda   <u0000
         os9   I$Close
         puls  pc,a

L0196    bsr   L019F
         beq   L019E
         bsr   L0131   Read keyboard
         bra   L0196
L019E    rts

L019F    pshs  b,a
         lda   #$00
         ldb   #$01
         os9   I$GetStt
         bcs   L01AE
         andcc #$FB
         puls  pc,b,a
L01AE    orcc  #$04
         puls  pc,b,a
L01B2    pshs  y,x,b,a
         ldy   <u0004
L01B7    lda   ,y+
         cmpa  #$0D
         beq   L01CB
         cmpa  #$20
         beq   L01B7
         cmpa  #$2C
         beq   L01B7
         cmpa  #$2D
         beq   L01F3
         bra   L01D1
L01CB    orcc  #$01
         andcc #$FD
         puls  pc,y,x,b,a
L01D1    leay  -$01,y
         ldb   #$36
L01D5    lda   ,y+
         cmpa  #$0D
         beq   L01E8
         cmpa  #$20
         beq   L01E8
         cmpa  #$2C
         beq   L01E8
         sta   ,x+
         decb
         bne   L01D5
L01E8    clr   ,x
         leay  -$01,y
         sty   <u0004
         andcc #$FE
         puls  pc,y,x,b,a
L01F3    lda   ,y+
         cmpa  #$0D
         beq   L01CB
         cmpa  #$20
         beq   L01B7
         cmpa  #$2C
         beq   L01B7
         bra   L01F3
L0203    pshs  b,a
         ldx   <u0006
L0207    lda   ,x+
         cmpa  #$2D
         beq   L0215
         cmpa  #$0D
         bne   L0207
         orcc  #$01
         puls  pc,b,a
L0215    stx   <u0006
         andcc #$FE
         puls  pc,b,a
L021B    pshs  u,x,b,a
         lda   #$02
         ldb   #$03
         os9   I$Create
         ldx   <u0014
         ldx   $06,x
L0228    bcs   L023A
         sta   $04,x
         leau  $05,x
         stu   ,x
         leau  >u0400,u
         stu   $02,x
         andcc #$FC
         puls  pc,u,x,b,a
L023A    stb   <u0003
         cmpb  #$DA
         bne   L0244
         orcc  #$03
         puls  pc,u,x,b,a
L0244    orcc  #$01
         andcc #$FD
         puls  pc,u,x,b,a
L024A    pshs  u,x,b,a
         lda   #$02
         ldb   #$03
         os9   I$Create
         ldx   <u0014
         ldx   $08,x
         bra   L0228
L0259    pshs  y,x,b,a
         leax  >L1640,pcr
         ldy   <u0012
L0262    lda   ,x+
         beq   L026A
         sta   ,y+
         bra   L0262
L026A    ldx   $02,s
         lda   #$2F
         sta   ,y+
L0270    lda   ,x+
         sta   ,y+
         bne   L0270
         puls  y,x,b,a
         ldx   <u0012
         pshs  u,x,a
         lda   #$01
         os9   I$Open
         ldx   <u0014
         ldx   $04,x
         bra   L0292
L0287    pshs  u,x,a
         lda   #$01
         os9   I$Open
         ldx   <u0014
         ldx   ,x
L0292    bcs   L029E
         sta   $04,x
         leau  $05,x
         stu   ,x
         stu   $02,x
         puls  pc,u,x,a
L029E    cmpb  #$D8
         beq   L02AA
         stb   <u0003
         orcc  #$01
         andcc #$FD
         puls  pc,u,x,a
L02AA    stb   <u0003
         orcc  #$03
         puls  pc,u,x,a
L02B0    pshs  u,x,a
         lda   #$01
         os9   I$Open
         ldx   <u0014
         ldx   $02,x
         bra   L0292
L02BD    pshs  x,a
         ldx   <u0014
         ldx   ,x
         bra   L02E6
L02C5    pshs  x,a
         ldx   <u0014
         ldx   $02,x
         bra   L02E6
L02CD    pshs  x,a
         ldx   <u0014
         ldx   $04,x
         bra   L02E6
L02D5    pshs  x,a
         ldx   <u0014
         ldx   $06,x
         bra   L02E3
L02DD    pshs  x,a
         ldx   <u0014
         ldx   $08,x
L02E3    lbsr  L04CB
L02E6    lda   $04,x
         beq   L02EF
         clr   $04,x
         os9   I$Close
L02EF    puls  pc,x,a
L02F1    pshs  y,x,b,a
         ldy   <u0012
L02F6    lda   ,x+
         beq   L02FE
         sta   ,y+
         bra   L02F6
L02FE    leax  >DOTBAK,pcr
L0302    lda   ,x+
         sta   ,y+
         bne   L0302
         ldx   <u0012
         os9   I$Delete
         stb   <u0003
         puls  pc,y,x,b,a
L0311    pshs  x
         ldx   <u0014
         ldx   $06,x
L0317    lbsr  L04B8
         puls  pc,x
L031C    pshs  x
         ldx   <u0014
         ldx   $08,x
         bra   L0317
L0324    pshs  b,a
         ldb   <u0003
         lda   #$01
         os9   F$PErr
         puls  pc,b,a
L032F    pshs  x,b
         ldx   <u0014
         ldx   ,x
L0335    lbsr  L04F0
         puls  pc,x,b
L033A    pshs  x,b
         ldx   <u0014
         ldx   $02,x
         bra   L0335
L0342    pshs  x,b
         ldx   <u0014
         ldx   $04,x
         bra   L0335
L034A    pshs  x,b
         ldx   <u0014
         ldx   $04,x
         lbsr  L0501
         puls  pc,x,b
L0355    lbsr  L0118
         lbsr  L02D5
         lbsr  L02DD
         ldd   #$0000
         ldx   <TTYSTATE
         os9   I$SetStt
         clrb
         lds   <u0018
         os9   F$Exit
L036D    pshs  u,y,x,b,a
         ldy   <u0012
         stx   <u000C
L0374    lda   ,x+
         sta   ,y+
         bne   L0374
         leay  -$01,y
         leax  >DOTBAK,pcr
L0380    lda   ,x+
         sta   ,y+
         bne   L0380
         lda   #$01
         ldx   <u0012
         os9   I$Open
         bcs   L0396
         os9   I$Close
         orcc  #$03
         puls  pc,u,y,x,b,a
L0396    cmpb  #$D8
         beq   L03BA
L039A    stb   <u0003
         cmpb  #$CF
         beq   L03AA
         cmpb  #$ED
         beq   L03AA
L03A4    orcc  #$01
         andcc #$FD
         puls  pc,u,y,x,b,a
L03AA    ldx   >L05E2,pcr
         lbsr  L4027
         ldx   >L05E4,pcr
         lbsr  L402C
         bra   L03A4
L03BA    tst   <u0063
         beq   L03D8
         ldx   <u000A
         bne   L03D3
         ldx   <u0014
         ldx   ,x
         lda   $04,x
         ldb   #$05
         os9   I$GetStt
         bcs   L039A
         stx   <u0008
         stu   <u000A
L03D3    lbsr  L02BD
         bcs   L039A
L03D8    ldx   <u000C
         ldy   <u0012
         lda   #$20
         sta   ,y+
L03E1    lda   ,x+
         sta   ,y+
         bne   L03E1
         lda   #$20
         sta   -$01,y
L03EB    lda   ,-x
         cmpa  #$2F
         beq   L03F7
         cmpx  <u000C
         bne   L03EB
         bra   L03F9
L03F7    leax  $01,x
L03F9    lda   ,x+
         beq   L0401
         sta   ,y+
         bra   L03F9
L0401    leax  >DOTBAK,pcr
L0405    lda   ,x+
         sta   ,y+
         bne   L0405
         lda   #$0D
         sta   -$01,y
         leax  >RENAME,pcr
         tfr   y,d
         subd  <u0012
         incb
         tfr   d,y
         ldu   <u0012
         ldd   #$0000
         os9   F$Fork
         lbcs  L039A
         os9   F$Wait
         tstb
         lbne  L039A
         tst   <u0063
         beq   L0465
         ldx   <u000C
         ldy   <u0012
L0437    lda   ,x+
         sta   ,y+
         bne   L0437
         leay  -$01,y
         leax  >DOTBAK,pcr
L0443    lda   ,x+
         sta   ,y+
         bne   L0443
         ldx   <u0012
         lda   #$01
         os9   I$Open
         lbcs  L039A
         ldx   <u0014
         ldx   ,x
         sta   $04,x
         ldx   <u0008
         ldu   <u000A
         os9   I$Seek
         lbcs  L039A
L0465    andcc #$FE
         puls  pc,u,y,x,b,a
L0469    pshs  u,y,x,b,a
         pshs  x
         ldx   <TTYSTATE
         ldd   #$0000
         os9   I$SetStt
         puls  x
         tfr   x,u
         ldd   #$0000
L047C    tst   d,u
         beq   L0485
         addd  #$0001
         bra   L047C
L0485    tfr   d,y
         leay  $01,y
         leax  d,u
         lda   #$0D
         sta   ,x
         ldd   #$0000
         leax  >SHELL,pcr
         os9   F$Fork
         bcs   L04B1
         os9   F$Wait
         tstb
         bne   L04B1
         andcc #$FE
L04A3    pshs  cc
         ldx   <u0010
         ldd   #$0000
         os9   I$SetStt
         puls  cc
         puls  pc,u,y,x,b,a
L04B1    stb   <u0003
         orcc  #$01
         bra   L04A3
         rts
L04B8    pshs  u
         ldu   ,x
         sta   ,u+
         stu   ,x
         cmpu  $02,x
         beq   L04C9
         andcc #$FE
         puls  pc,u
L04C9    puls  u
L04CB    pshs  y,x,b,a
         tst   $04,x
         beq   L04EE
         tfr   x,y
         leax  $05,y
         pshs  x
         ldd   ,y
         stx   ,y
         subd  ,s++
         beq   L04EE
         pshs  b,a
         lda   $04,y
         puls  y
         os9   I$Write
         bcs   L04EC
         puls  pc,y,x,b,a
L04EC    stb   <u0003
L04EE    puls  pc,y,x,b,a
L04F0    pshs  u
L04F2    ldu   ,x
         cmpu  $02,x
         beq   L0503
         lda   ,u+
         stu   ,x
         andcc #$FE
         puls  pc,u
L0501    pshs  u
L0503    pshs  y,x
         tfr   x,y
         lda   $04,y
         leax  $05,y
         stx   ,y
         ldy   #$0036
         os9   I$Read
         sty   <u0057
         puls  y,x
         bcs   L0525
         ldd   <u0057
         leau  $05,x
         leau  d,u
         stu   $02,x
         bra   L04F2
L0525    cmpb  #$D3
         bne   L052D
         orcc  #$03
         puls  pc,u
L052D    orcc  #$01
         andcc #$FD
         stb   <u0003
         puls  pc,u
L0535    ldx   <u0014
         ldx   $04,x
         lda   $04,x
         ldx   #$0000
         os9   I$Seek
         rts
L0542    ldb   #$0E
         os9   I$GetStt
         rts
         pshs  x,b,a
         lda   #$00
         ldx   <u0014
         ldx   $0C,x
         leax  $01,x
         bsr   L0542
         puls  pc,x,b,a

*EQUATE FOR STYFIX
TXTBEG EQU *

*ESCAPE CHARACTER CONSTANTS
ESCTBL EQU *


CURUC    fcb   $49 I
         fcb   $4C L
CURDC    fcb   $2C , $0558
         fcb   $4A J
         fcb   $55 U
         fcb   $4D M
         fcb   $59 Y
         fcb   $40 @
         fcb   $46 F
         fcb   $52 R
         fcb   $3B ;
         fcb   $57 W
         fcb   $5A Z
         fcb   $53 S
         fcb   $2F /
         fcb   $44 D
         fcb   $4F O
         fcb   $2E .
CURLRC FCC 'K' MOVE CURSOR LEFT-RIGHT  L0568
L0569    fcb   $50 P
         fcb   $5D ]
         fcb   $14
         fcb   $2D -
 FCC '7' SCROLL LEFT
 FCC '9' SCROLL RIGHT
 FCC '1' OVERWRITE 1
         fcb   $30 0
         fcb   $38 8
         fcb   $5E ^
         fcb   $43 C

*CHARACTER MOD CHARACTERS (ALSO CONTROL)
L0574    fcb   $15
L0575    fcb   $0F
L0576    fcb   $02
L0577    fcb   $19
L0578    fcb   $0B
L0579    fcb   $03
L057A    fcb   $11
         fcb   $20
L057C    fcb   $08

*CONTROL CHARACTER CONSTANTS
CTRTBL    fcb   $0C
L057E    fcb   $0A
L057F    fcb   $09
         fcb   $60 `
L0581    fcb   $18
         fcb   $04
         fcb   $17
         fcb   $06
L0585    fcb   $0E
         fcb   $16
L0587    fcb   $10
         fcb   $07
         fcb   $12
         fcb   $1E
         fcb   $01
         fcb   $05
         fcb   $11
         fcb   $1A
 PAG

*MISC. CHARACTER CONSTANTS
ESCC    fcb   $1B
L0590    fcb   $14
L0591    fcb   $15
L0592    fcb   $2D -
L0593    fcb   $7C
L0594    fcb   $2C ,
L0595    fcb   $5D ]
L0596    fcb   $23 #
         fcb   $7C
L0598    fcb   $3E >
L0599    fcb   $3C <
YCHR    fcb   $59 Y
NCHR    fcb   $4E N
SCHR FCC 'S' STOP
L059D    fcb   $41 A
L059E    fcb   $53 S
L059F    fcb   $54 T
L05A0    fcb   $42 B
L05A1    fcb   $43 C
L05A2    fcb   $4E N
L05A3    fcb   $45 E
L05A4    fcb   $57 W
L05A5    fcb   $58 X
L05A6    fcb   $59 Y
L05A7    fcb   $5A Z
CTMCHR    fcb   $54 T
CPTCHR FCC 'P' COMMAND LINE PRINTER OPTION
L05AA    fcb   $4D M
L05AB    fcb   $7D
L05AC    fcb   $7B

L05AD    fcb   $00
L05AE    fcb   $00
L05AF    fcb   $00
L05B0    fcb   $00
L05B1    fcb   $00
STPL FCB 66 PAGE LENGTH
L05B3    fcb   $0C
L05B4    fcb   $06
L05B5    fcb   $04
         fcb   $00
L05B7    fcb   $00
L05B8    fcb   $00
L05B9    fcb   $00

FMTTBL    fdb XFMTTBL
L05BC    fdb   $06C9
L05BE    fdb   $0D49
         fdb   $0D52
L05C2    fdb   $0D7B
L05C4    fdb   $0A3D
L05C6    fdb   $0A7F
L05C8    fdb   $0D0A
L05CA    fdb   $0D18
L05CC    fdb   $0D26
L05CE    fdb   $0D31
L05D0    fdb   $0D3D
L05D2    fdb   $0D42
L05D4    fdb   $0D8D
L05D6    fdb   $0D92
L05D8    fdb   $0DA9
L05DA    fdb   $0DB4
L05DC    fdb   $0DC2
L05DE    fdb   $0DE0
L05E0    fdb   $0E09
L05E2    fdb   $0E15
L05E4    fdb   $0E3A
L05E6    fdb   $0E6F
         fdb   $0E81
L05EA    fdb   $0E8E
L05EC    fdb   $0EA8
L05EE    fdb   $0EC9
L05F0    fdb   $0ED9
L05F2    fdb   $0F03
         fdb   $0F18
L05F6    fdb   $0F9B
L05F8    fdb   $0FAA
L05FA    fdb   $1099
L05FC    fdb   $10AE
L05FE    fdb   $10BD
L0600    fdb   $10DB
L0602    fdb   $10ED
L0604    fdb   $111B
L0606    fdb   $113C
L0608    fdb   $1147
L060A    fdb   $1154
L060C    fdb   $116F
L060E    fdb   $1186
L0610    fdb   $11A4
L0612    fdb   $11A8
L0614    fdb   $11C4
L0616    fdb   $11DB
L0618    fdb   $11FC
L061A    fdb   $1215
L061C    fdb   $1226
L061E    fdb   $1238
L0620    fdb   $1273
L0622    fdb   $0FD0
L0624    fdb   $0FEF
L0626    fdb   $100D
L0628    fdb   $102A
L062A    fdb   $1034
L062C    fdb   $103F
L062E    fdb   $105D
L0630    fdb   $106F
L0632    fdb   $107D
L0634    fdb   $128E
L0636    fdb   $129B
L0638    fdb   $12BC
L063A    fdb   $12CE
L063C    fdb   $12DB
L063E    fdb   $12E8
L0640    fdb   $12FD
L0642    fdb   $1309
L0644    fdb   $1318
L0646    fdb   $151C
L0648    fdb   $154D
L064A    fdb   $15DE
         fdb   $15E6
         fdb   $15EE
         fdb   $15F6
         fdb   $15FE
         fdb   $1606
L0656    fdb   $160E
L0658    fdb   $1617
L065A    fdb   L0F27 'BAD TERM_STY...
         fdb   L0F68

*FORMAT COMMAND TABLE
XFMTTBL EQU *    $065E
 FCC 'CE'
 FCB 0
 FCC 'LL'
 FCB 0
 FCC 'RJ'
 FCB 0
 FCC 'TF'
 FCB 0
 FCC '*'
 FCB 0
 FCC 'PL'
 FCB 0
 FCC 'RU'
 FCB 0
 FCC 'NJ'
 FCB 0
 FCC 'LM'
 FCB 0
 FCC 'SP'
 FCB 0
 FCC 'SS'
 FCB 0
 FCC 'HD'
 FCB 0
 FCC 'FT'
 FCB 0
 FCC 'JU'
 FCB 0
 FCC 'PN'
 FCB 0
 FCC 'PG'
 FCB 0
 FCC 'SI'
 FCB 0
 FCC 'IN'
 FCB 0
 FCC 'VT'
 FCB 0
 FCC 'CS'
 FCB 0
 FCC 'VS'
 FCB 0
 FCC 'PS'
 FCB 0
 FCC 'NPS'
 FCB 0
 FCC 'PC'
 FCB 0
 FCC 'MMC'
 FCB 0
 FCC 'PADC'
 FCB 0
 FCC 'NL'
 FCB 0
 FCC 'PP'
 FCB 0
 FCC 'PPSI'
 FCB 0
 FCC 'PPSP'
 FCB 0
 FCC 'PPNL'
 FCB 0
 FCC 'BFS'
 FCB 0
 FCB 0 END OF TABLE

XERRTBL EQU *
 FCB 2
 FCC 'L/R SCROLL OUT OF BOUNDS'
 FCB 0
 FCB 3
 FCC 'INVALID ESCAPE COMMAND ENTERED'
 FCB 0
 FCB 7
 FCC 'TOP OF TEXT REACHED'
 FCB 0
 FCB 10
 FCC 'BOTTOM OF TEXT REACHED'
 FCB 0
 FCB 11
 FCC 'MAXIMUM PAGE LIMIT'
 FCB 0
 FCB 12
 FCC 'INVALID FORMAT COMMAND'
 FCB 0
 FCB 13
 FCC 'FORMAT VALUE OUT OF BOUNDS'
 FCB 0
 FCB 14
 FCC 'ILLEGAL HEADER OR FOOTER COMMAND'
 FCB 0
 FCB 15
 FCC "CURSOR ON FORMAT LINE - CAN'T BUNDLE"
 FCB 0
 FCB 16
 FCC "HEADER OR FOOTER TOO LONG FOR PAGE"
 FCB 0
 FCB 17
 FCC "CAN'T BACKSPACE TO BUNDLED FORMAT LINE"
 FCB 0
 FCB 18
 FCC "ILLEGAL DELETE"
 FCB 0
 FCB 20
 FCC "CAN'T DELETE - NOT BRACKETED BY RETURNS"
 FCB 0
 FCB 21
 FCC "CAN'T FIND MARKER"
 FCB 0
 FCB 22
 FCC "TEXT ALREADY SAVED"
 FCB 0
 FCB 23
 FCC "NOT ENOUGH MEMORY TO DO COMMAND"
 FCB 0
 FCB 24
 FCC "NO TEXT SAVED, CAN'T WITHDRAW OR DUPLICATE"
 FCB 0
 FCB 25
 FCC "WARNING - MEMORY NEARLY FULL"
 FCB 0
 FCB 26
 FCC "MEMORY FULL"
 FCB 0
 FCB 27
 FCC "TOO MANY TABS"
 FCB 0
 FCB 28
 FCC "NO MORE TABS SET"
 FCB 0
 FCB 29
 FCC "CAN'T TAB"
 FCB 0
 FCB 30
 FCC "WARNING - NONSTANDARD CHARACTER SPACING"
 FCB 0
 FCB 31
 FCC "STRING OVERFLOW"
 FCB 0
 FCB 32
 FCC "STRING NOT FOUND"
 FCB 0
 FCB 33
 FCC "ILLEGAL PAGE NUMBER"
 FCB 0
 FCB 34
 FCC 'WARNING - NO "PS-TABLE" SET'
 FCB 0
 FCB 35
 FCC 'WARNING - NONSTANDARD VERTICAL SPACING'
 FCB 0
 FCB 36
 FCC 'FATAL - TRYING TO GO PAST STYFIXED AMOUNT OF PAGES!!'
 FCB 0
 FCB 37
 FCC 'ENTERED PROGRAMMERS MODE'
 FCB 0
 FCB 38
 FCC 'EXITED PROGRAMMERS MODE'
 FCB 0
 FCB 39
 FCC 'BAD CHARACTER FROM KEYBOARD'
 FCB 0
 FCB 0 END OF TABLE

*MESSAGES AND NUMBER AREAS
XPGMS1 FCC '- PAGE STATUS -'
 FCB 0
         fcb   $52 R
         fcb   $45 E
         fcb   $41 A
         fcb   $44 D
         fcb   $20
         fcb   $46 F
         fcb   $49 I
         fcb   $4C L
         fcb   $45 E
         fcb   $20
         fcb   $3D =
         fcb   $20
         fcb   $00
         fcb   $57 W
         fcb   $52 R
         fcb   $49 I
         fcb   $54 T
         fcb   $45 E
         fcb   $20
         fcb   $46 F
         fcb   $49 I
         fcb   $4C L
         fcb   $45 E
         fcb   $20
         fcb   $3D =
         fcb   $20
         fcb   $00
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $20
         fcb   $4E N
         fcb   $4F O
         fcb   $4E N
         fcb   $45 E
         fcb   $20
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $00
         fcb   $53 S
         fcb   $45 E
         fcb   $52 R
         fcb   $49 I
         fcb   $41 A
         fcb   $4C L
         fcb   $20
         fcb   $50 P
         fcb   $41 A
         fcb   $47 G
         fcb   $45 E
         fcb   $20
         fcb   $23 #
         fcb   $20
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $00
         fcb   $50 P
         fcb   $52 R
         fcb   $49 I
         fcb   $4E N
         fcb   $54 T
         fcb   $45 E
         fcb   $44 D
         fcb   $20
         fcb   $50 P
         fcb   $41 A
         fcb   $47 G
         fcb   $45 E
         fcb   $20
         fcb   $23 #
         fcb   $20
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $00
         fcb   $4C L
         fcb   $49 I
         fcb   $4E N
         fcb   $45 E
         fcb   $20
         fcb   $23 #
         fcb   $20
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $00
         fcb   $00
         fcb   $50 P
         fcb   $41 A
         fcb   $47 G
         fcb   $45 E
         fcb   $20
         fcb   $4C L
         fcb   $45 E
         fcb   $4E N
         fcb   $47 G
         fcb   $54 T
         fcb   $48 H
         fcb   $20
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $20
         fcb   $2C ,
         fcb   $50 P
         fcb   $4C L
         fcb   $00
         fcb   $48 H
         fcb   $45 E
         fcb   $41 A
         fcb   $44 D
         fcb   $45 E
         fcb   $52 R
         fcb   $20
         fcb   $4C L
         fcb   $49 I
         fcb   $4E N
         fcb   $45 E
         fcb   $53 S
         fcb   $20
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $20
         fcb   $2C ,
         fcb   $48 H
         fcb   $44 D
         fcb   $20
         fcb   $2C ,
         fcb   $2C ,
         fcb   $00
         fcb   $46 F
         fcb   $4F O
         fcb   $4F O
         fcb   $54 T
         fcb   $45 E
         fcb   $52 R
         fcb   $20
         fcb   $4C L
         fcb   $49 I
         fcb   $4E N
         fcb   $45 E
         fcb   $53 S
         fcb   $20
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $20
         fcb   $2C ,
         fcb   $46 F
         fcb   $54 T
         fcb   $20
         fcb   $2C ,
         fcb   $2C ,
         fcb   $00
         fcb   $53 S
         fcb   $50 P
         fcb   $41 A
         fcb   $43 C
         fcb   $49 I
         fcb   $4E N
         fcb   $47 G
         fcb   $20
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $20
         fcb   $2C ,
         fcb   $53 S
         fcb   $53 S
         fcb   $00
         fcb   $4C L
         fcb   $49 I
         fcb   $4E N
         fcb   $45 E
         fcb   $53 S
         fcb   $2F /
         fcb   $49 I
         fcb   $4E N
         fcb   $43 C
         fcb   $48 H
         fcb   $20
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $20
         fcb   $2C ,
         fcb   $56 V
         fcb   $53 S
         fcb   $00
         fcb   $00
         fcb   $4C L
         fcb   $49 I
         fcb   $4E N
         fcb   $45 E
         fcb   $20
         fcb   $4C L
         fcb   $45 E
         fcb   $4E N
         fcb   $47 G
         fcb   $54 T
         fcb   $48 H
         fcb   $20
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $20
         fcb   $2C ,
         fcb   $4C L
         fcb   $4C L
         fcb   $00
         fcb   $48 H
         fcb   $2F /
         fcb   $46 F
         fcb   $20
         fcb   $4C L
         fcb   $49 I
         fcb   $4E N
         fcb   $45 E
         fcb   $20
         fcb   $4C L
         fcb   $45 E
         fcb   $4E N
         fcb   $47 G
         fcb   $54 T
         fcb   $48 H
         fcb   $20
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $20
         fcb   $2C ,
         fcb   $4C L
         fcb   $4C L
         fcb   $00
         fcb   $4C L
         fcb   $45 E
         fcb   $46 F
         fcb   $54 T
         fcb   $20
         fcb   $4D M
         fcb   $41 A
         fcb   $52 R
         fcb   $47 G
         fcb   $49 I
         fcb   $4E N
         fcb   $20
         fcb   $28 (
         fcb   $4F O
         fcb   $44 D
         fcb   $44 D
         fcb   $20
         fcb   $50 P
         fcb   $41 A
         fcb   $47 G
         fcb   $45 E
         fcb   $29 )
         fcb   $2D -
         fcb   $20
         fcb   $2C ,
         fcb   $4C L
         fcb   $4D M
         fcb   $31 1
         fcb   $00
         fcb   $4C L
         fcb   $45 E
         fcb   $46 F
         fcb   $54 T
         fcb   $20
         fcb   $4D M
         fcb   $41 A
         fcb   $52 R
         fcb   $47 G
         fcb   $49 I
         fcb   $4E N
         fcb   $20
         fcb   $28 (
         fcb   $45 E
         fcb   $56 V
         fcb   $45 E
         fcb   $4E N
         fcb   $20
         fcb   $50 P
         fcb   $41 A
         fcb   $47 G
         fcb   $45 E
         fcb   $29 )
         fcb   $20
         fcb   $2C ,
         fcb   $4C L
         fcb   $4D M
         fcb   $32 2
         fcb   $00
         fcb   $49 I
         fcb   $4E N
         fcb   $44 D
         fcb   $45 E
         fcb   $4E N
         fcb   $54 T
         fcb   $20
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $20
         fcb   $2C ,
         fcb   $49 I
         fcb   $4E N
         fcb   $00
         fcb   $43 C
         fcb   $48 H
         fcb   $41 A
         fcb   $52 R
         fcb   $41 A
         fcb   $43 C
         fcb   $54 T
         fcb   $45 E
         fcb   $52 R
         fcb   $53 S
         fcb   $2F /
         fcb   $49 I
         fcb   $4E N
         fcb   $43 C
         fcb   $48 H
         fcb   $20
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $20
         fcb   $2C ,
         fcb   $43 C
         fcb   $53 S
         fcb   $00
         fcb   $50 P
         fcb   $41 A
         fcb   $52 R
         fcb   $41 A
         fcb   $47 G
         fcb   $52 R
         fcb   $41 A
         fcb   $50 P
         fcb   $48 H
         fcb   $20
         fcb   $49 I
         fcb   $4E N
         fcb   $44 D
         fcb   $45 E
         fcb   $4E N
         fcb   $54 T
         fcb   $20
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $20
         fcb   $2C ,
         fcb   $50 P
         fcb   $50 P
         fcb   $53 S
         fcb   $49 I
         fcb   $00
 FCC 'PARAGRAPH SPACE ------- ,PPSP'
 FCB 0
 FCC 'PARAGRAPH NEED LINES -- ,PPNL'
 FCB 0
 FCB 0
 FCC 'JUSTIFIED ------------- ,JU/,NJU'
 FCB 0
 FCC 'PROPORTIONAL SPACED --- ,PS/,NPS'
 FCB 0
 FCB 0
 FCC 'PRINTER CHARACTER ----- ,PC'
 FCB 0
 FCC 'SPACE PAD CHARACTER --- ,PADC'
 FCB 0
 FCC 'MAIL-MERGE CHARACTER -- ,MMC'
 FCB 0
 FCB 0
 FCC 'ROOM LEFT'
 FCB 0
 FCB 0,0,0,0,0
XPGM50 FCC 'READ FILE:   '
 FCB 0
XPGM51 FCC 'WRITE FILE:  '
 FCB 0
XPGM52 FCC '---NONE---'
 FCB 0
XPGM53 FCC 'STATUS:    '
 FCB 0
XPGM54 FCC 'OPEN'
 FCB 0
XPGM55 FCC 'CLOSED'
 FCB 0

XBELS1   fcc   "NO ERROR"
 FCB 0

XBAVM1   fcc   "CANNOT MOVE TO LAST PAGE, TOO MANY PAGES"
 FCB 0

XPAGS1 FCC "*********** PAGE="
 FCB 0

XPGBS1 FCC 'PAGE'
 FCB 0
XSAVM1 FCC 'Save under file name "'
 FCB 0
XSAVMB FCC '" (Y*/N)? '
 FCB 0
XSAVM2 FCC 'NO TEXT SAVED'
 FCB 0
XSAVM3 FCC 'PART OR ALL OF TEXT NOT SAVED'
 FCB 0
XSAVM4 FCC 'Can old BACKUP file be replaced (Y*/N)? '
 FCB 0
XSAVM5 FCC 'File name? '
 FCB 0
         fcb   $4E N
         fcb   $4F O
         fcb   $54 T
         fcb   $20
         fcb   $45 E
         fcb   $4E N
         fcb   $4F O
         fcb   $55 U
         fcb   $47 G
         fcb   $48 H
         fcb   $20
         fcb   $4D M
         fcb   $45 E
         fcb   $4D M
         fcb   $4F O
         fcb   $52 R
         fcb   $59 Y
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $46 F
         fcb   $49 I
         fcb   $4C L
         fcb   $45 E
         fcb   $20
         fcb   $4E N
         fcb   $4F O
         fcb   $54 T
         fcb   $20
         fcb   $53 S
         fcb   $41 A
         fcb   $56 V
         fcb   $45 E
         fcb   $44 D
         fcb   $21 !
         fcb   $21 !
         fcb   $00
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $50 P
         fcb   $4C L
         fcb   $45 E
         fcb   $41 A
         fcb   $53 S
         fcb   $45 E
         fcb   $20
         fcb   $53 S
         fcb   $41 A
         fcb   $56 V
         fcb   $45 E
         fcb   $20
         fcb   $55 U
         fcb   $4E N
         fcb   $44 D
         fcb   $45 E
         fcb   $52 R
         fcb   $20
         fcb   $41 A
         fcb   $20
         fcb   $55 U
         fcb   $4E N
         fcb   $49 I
         fcb   $51 Q
         fcb   $55 U
         fcb   $45 E
         fcb   $20
         fcb   $46 F
         fcb   $49 I
         fcb   $4C L
         fcb   $45 E
         fcb   $20
         fcb   $4E N
         fcb   $41 A
         fcb   $4D M
         fcb   $45 E
         fcb   $2E .
         fcb   $00
XSVMS1 FCC 'Marker not found.'
 FCB 0
         fcb   $2C ,
         fcb   $2A *
         fcb   $20
         fcb   $4D M
         fcb   $4F O
         fcb   $44 D
         fcb   $49 I
         fcb   $46 F
         fcb   $49 I
         fcb   $45 E
         fcb   $44 D
         fcb   $20
         fcb   $00
XDSTM1 FCC 'WARNING! FILE TOO LARGE - '
XDSTM2 FCC 'ENTIRE FILE MAY NOT BE LOADED!!!'
 FCB 0
XDSTM3 FCC 'FILE NOT LOADED'
 FCB 0
XDSTM5 FCB $D,$A
 FCC 'ILLEGAL PRINTER, TERMINAL, OR FILE NAME'
 FCB 0
XDSTM6 FCC 'INPUT FILE NOT FOUND-NO TEXT LOADED'
 FCB 0
L0F27 fcc "BAD TERM_STY or PRINT_STY file (OR bad TERM or PRINTER NUMBER)"
         fcb   $0D
         fcb   $0A
         fcb   $00
L0F68 fcc "CANT FIND PRINTER FILE."
         fcb   $0D
         fcb   $0A
 fcc "ENTER CORRECT PATHNAME:"
         fcb   $0D
         fcb   $0A
         fcb   $00
XOSPS1 FCC 'DOS command:  '
 FCB 0
XOSPS2 FCB 7
 FCC 'Command not allowed with files open.'
 FCB 0
SQS1 FCC 'Hit any key to restart printer'
 FCB 0

XNEWM1 FCC 'No dump.  Cursor on top page.'
 FCB 0
XNEWM3 FCC "Dump text in memory (Y*/N)? "
 FCB 0
         fcb   $44 D
         fcb   $75 u
         fcb   $6D m
         fcb   $70 p
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $22 "
         fcb   $00
         fcb   $22 "
         fcb   $20
         fcb   $28 (
         fcb   $59 Y
         fcb   $2A *
         fcb   $2F /
         fcb   $4E N
         fcb   $29 )
         fcb   $3F ?
         fcb   $20
         fcb   $00
XNEWM6 FCC 'Fill from input file (Y*/N)? '
 FCB 0
XNEWM7 FCC 'No room for fill.'
 FCB 0
XNEWM8 FCC 'DISK ERROR!!!'
 FCB 0
XNEWM9 FCC 'No fill.  Input file empty.'
 FCB 0

XEXTM1 FCC 'Is the text secure? '
 FCB 0
XEXTM2 FCC 'Are you sure? '
 FCB 0
XERMM1 FCC 'Erase entire file in memory? '
 FCB 0

XPSWS1 FCC 'STYPS'
 FCB 0,0,0,0,0,0,0,0,0,0,0,0,0
XPSWS2 FCC 'ERROR - PROPORTIONAL SPACING TABLE NOT LOADED'
 FCB 0
XPSWS3 FCC 'Set proportional spacing table "'
 FCB 0
XPSWS4 FCC '" (Y*/N)? '
 FCB 0
XPSWS5 FCC 'Table name? '
 FCB 0

XPRNS1 FCC 'Different printer (Y/N*)? '
 FCB 0
XPRNS2 FCC 'PRINT DRIVER NOT FOUND'
 FCB 0
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $50 P
         fcb   $72 r
         fcb   $69 i
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $50 P
         fcb   $61 a
         fcb   $74 t
         fcb   $68 h
         fcb   $20
         fcb   $3F ?
         fcb   $20
         fcb   $28 (
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $6C l
         fcb   $79 y
         fcb   $20
         fcb   $00
         fcb   $20
         fcb   $29 )
         fcb   $20
         fcb   $00
XPRNS4 FCC 'Stop for new pages (Y/N*)? '
 FCB 0
         fcb   $50 P
         fcb   $72 r
         fcb   $69 i
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $23 #
         fcb   $20
         fcb   $3F ?
         fcb   $20
         fcb   $28 (
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $6C l
         fcb   $79 y
         fcb   $00
         fcb   $50 P
         fcb   $72 r
         fcb   $69 i
         fcb   $6E n
         fcb   $74 t
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $20
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $20
         fcb   $48 H
         fcb   $69 i
         fcb   $74 t
         fcb   $20
         fcb   $53 S
         fcb   $50 P
         fcb   $41 A
         fcb   $43 C
         fcb   $45 E
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $70 p
         fcb   $61 a
         fcb   $75 u
         fcb   $73 s
         fcb   $65 e
         fcb   $2E .
         fcb   $00
XOTXS2 FCC 'Print all pages (Y*/N)? '
 FCB 0
XOTXS3 FCC '   First page = '
 FCB 0
XOTXS4 FCC '     Last page = '
 FCB 0
         fcb   $50 P
         fcb   $72 r
         fcb   $69 i
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $50 P
         fcb   $61 a
         fcb   $75 u
         fcb   $73 s
         fcb   $65 e
         fcb   $64 d
         fcb   $20
         fcb   $2D -
         fcb   $2D -
         fcb   $2D -
         fcb   $20
         fcb   $48 H
         fcb   $69 i
         fcb   $74 t
         fcb   $20
         fcb   $53 S
         fcb   $50 P
         fcb   $41 A
         fcb   $43 C
         fcb   $45 E
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $63 c
         fcb   $6F o
         fcb   $6E n
         fcb   $74 t
         fcb   $69 i
         fcb   $6E n
         fcb   $75 u
         fcb   $65 e
         fcb   $2C ,
         fcb   $20
         fcb   $72 r
         fcb   $65 e
         fcb   $74 t
         fcb   $75 u
         fcb   $72 r
         fcb   $6E n
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $61 a
         fcb   $62 b
         fcb   $6F o
         fcb   $72 r
         fcb   $74 t
         fcb   $2E .
         fcb   $00
XSPLS1 FCC 'Spooled output file name? '
 FCB 0
XFNDS1 FCC '*** FIND    '
 FCB 0
XFNDS2 FCC '*** STOP (RET) OR CONTINUE (SP)?'
 FCB 0
XFNDS3 FCC ' UPPER/LOWER CASE'
 FCB 0
XRPLS1 FCC '*** REPLACE '
 FCB 0
XRPLS2 FCC '*** WITH    '
 FCB 0
XRPLS3 FCC '*** REPLACE (Y-N-A)?'
 FCB 0
XBDLS1 FCC '*** DELETE '
 FCB 0
XBDLS2 FCC '  CHARACTERS? '
 FCB 0

XSUPS1 equ *
 fcc   "EDIT -------- return to ESCAPE mode to edit text"
 FCB 0
 FCC   'PRINT ------- print the text'
 FCB 0
 FCC   "SAVE/RETURN - save the text and return to DOS"
 FCB 0
 fcc   "SAVE -------- save the text"
 FCB 0
 FCC   'SAVE TO MARK- save text from cursor to marker'
 FCB 0
 fcc   "RETURN ------ return to disk operating system"
 FCB 0
 fcc   "LOAD -------- insert file at cursor position"
 FCB 0
 fcc   "ERASE ------- erase text without saving it"
 FCB 0
 fcc   "PASS -------- pass command to operating system"
 FCB 0
 fcc   "SPOOL ------- output text to disk to print later"
 FCB 0
 fcc   "WHEEL ------- specify proportional spacing wheel"
 FCB 0
 fcc   "NEW --------- new text from input file"
 FCB 0

XBANNER FCC "STYLOGRAPH WORD PROCESSING SYSTEM V3.40 (c) 1987"
 FCB 0

XHLPS1 FCC 'RETURN'
 FCB 0
 FCC 'ESCAPE Commands'
 FCB 0
 FCC 'CONTROL Commands'
 FCB 0
 FCC 'FORMAT Commands (vertical)'
 FCB 0
 fcc 'FORMAT Commands (horizontal)'
 FCB 0
 FCC 'FORMAT Commands (misc.)'
 FCB 0
 fcc 'Displayed character mods'
 FCB 0
XHLPS2 FCC "STYHLP1"
 FCB 0
XHLPS3 FCC "STYHLP2"
 FCB 0
XHLPS4 FCC "STYHLP3"
 FCB 0
XHLPS5 FCC "STYHLP4"
 FCB 0
XHLPS6 FCC "STYHLP5"
 FCB 0
XHLPS7 FCC "STYHLP6"
 FCB 0

TRMSTY FCC "TERM_STY"
 FCB 0
PRTSTY FCC "PRINT_STY"
 FCB 0
 FCC '                           /P1'
         fcb   $00
L1640 FCC '                       /h0/STY'
         fcb   $00

L165F    fdb   $1621

DOTBAK    FCC "_BAK"
         fcb   $00
RENAME FCC 'rename'
 FCB $0D
SHELL FCC 'shell'
 FCB $0D

L1673    lbsr  L1A39
         ldd   >L0656,pcr
         leax  >L0000,pcr
         leax  d,x
         lbsr  L0259
         lbcs  L19EC
         lda   <u003B
         ldb   #$D2
         mul
         addd  #$02E4
         exg   d,u
         lbsr  L0535
         lbsr  L034A
         lbcs  L19EC
         sta   <u003E
         anda  #$04
         sta   <u0041
         lbsr  L0342
         lbcs  L19EC
         deca
         sta   <u003F
         lbsr  L0342
         lbcs  L19EC
         sta   <u0040
         ldx   <u003C
         leax  <$50,x
         ldy   <u003C
         lbra  L19B7

*THE FIRST 16 BYTES ARE RESERVED FOR 8 ADDRESS
*POINTERS TO MACHINE LANGUAGE ROUTINES IF USED.

TRMBEG equ *       Address $16BF

         fdb   L19EB
         fdb   L19EB
         fdb   L16CF
         fdb   L19EB
         fdb   L19EB
         fdb   L19EB
         fdb   L19EB
         fdb   L19EB

* ANSI cursor position
L16CF    pshs  b,a
         lda   #$1B
         jsr   ,u
         lda   #'[
         jsr   ,u
         lda   ,s
         inca
         bsr   L16ED
         lda   #';
         jsr   ,u
         lda   $01,s
         inca
         bsr   L16ED
         lda   #$48
         jsr   ,u
         puls  pc,b,a

* Write byte as text number
L16ED    cmpa  #$0A
         bcs   L1704
         clrb
L16F2    suba  #$0A
         bcs   L16F9
         incb
         bra   L16F2
L16F9    adda  #$0A
         exg   a,b
         adda  #$30
         lbsr  L0105
         tfr   b,a
L1704    adda  #$30
         lbra  L0105
L1709    tst   <u003A
         beq   L1712
         lbsr  L1737
         clr   <u003A
L1712    pshs  b
         ldb   <u0039
         cmpb  <u0040
         puls  b
         bhi   L1721
         inc   <u0039
         lbra  L0105
L1721    rts

L1722    lbsr  L21F7
L1725    cmpb  <u003A
         bne   L172B
         bra   L1712
L172B    pshs  b
         bsr   L1737
         ldb   ,s+
         stb   <u003A
         lbsr  L18A8
         rts

L1737    pshs  b
         clr   <u006C
         ldb   <u003A
         lbsr  L1939
         puls  pc,b
L1742    std   <u0038
         pshs  x
         ldb   #$00
         bsr   L1789
         bcs   L1770
         ldx   <u003C
         ldb   <u003E
         bitb  #$02
         beq   L1772
         lda   <u0038
         bitb  #$01
         beq   L175C
         adda  #$20
L175C    lbsr  L0105
         lda   <u0039
         ldx   <u003C
         ldb   <u003E
         bitb  #$01
         beq   L176B
L1769    adda  #$20
L176B    lbsr  L0105
         ldd   <u0038
L1770    puls  pc,x
L1772    lda   <u0039
         bitb  #$01
         beq   L177A
         adda  #$20
L177A    lbsr  L0105
         lda   <u0038
         ldx   <u003C
         ldb   <u003E
         bitb  #$01
         beq   L176B
         bra   L1769
L1789    pshs  x,b,a
         ldx   <u003C
         ldx   b,x
         beq   L17A6
         lda   $01,x
         cmpa  #$FF
         beq   L17A8
L1797    lda   ,x+
         pshs  a
         lbsr  L0105
         lda   ,s+
         bpl   L1797
         andcc #$FE
L17A4    andcc #$FB
L17A6    puls  pc,x,b,a
L17A8    ldb   ,x
         lslb
         leax  >TRMBEG,pcr
         ldd   b,x
         leax  >L0000,pcr
         leax  d,x
         ldd   <u0038
         pshs  u
         leau  >L0105,pcr
         jsr   ,x
         puls  u
         orcc  #$01
         bra   L17A4
L17C7    pshs  b
         ldb   #$04
         bsr   L1789
         puls  pc,b
L17CF    pshs  b
         ldb   #$02
         bsr   L1789
         puls  pc,b
L17D7    pshs  x,b
         clr   <u0038
         clr   <u0039
         ldb   #$0A
         bsr   L1789
         lbsr  L0118
         ldx   #$1F40
L17E7    leax  -$01,x
         bne   L17E7
         puls  pc,x,b
L17ED    pshs  b,a
         ldb   #$0E
         bsr   L1789
         ldd   <u0038
         deca
         lbsr  L1742
         puls  pc,b,a
L17FB    pshs  b,a
         ldb   #$10
         bsr   L1789
         beq   L1809
         ldd   <u0038
         inca
         lbsr  L1742
L1809    puls  pc,b,a
L180B    pshs  x,b
         clr   <u0038
         clr   <u0039
         ldb   #$12
         lbsr  L1789
         ldb   <u003B
         cmpb  #$22
         bne   L1827
         pshs  x
         leax  >L1833,pcr
         lbsr  L3E54
         puls  x
L1827    lbsr  L0118
         ldx   #$2710
L182D    leax  -$01,x
         bne   L182D
         puls  pc,x,b

L1833    fcb   $1B
         fcb   $5B [
         fcb   $30 0
         fcb   $3B ;
         fcb   $37 7
         fcb   $31 1
         fcb   $72 r
         fcb   $00

L183B    pshs  b
         fcb   $C6 F
         fcb   $14
         fcb   $17
         fcb   $FF
         fcb   $47 G
         puls  pc,b

         pshs  b
         ldb   #$26
         lbsr  L1789
         puls  pc,b
         pshs  b
         ldb   #$28
         lbsr  L1789
         puls  pc,b
         pshs  b
         ldb   #$1C
         lbsr  L1789
         puls  pc,b
         pshs  b
         ldb   #$1E
         lbsr  L1789
         puls  pc,b
L1868    pshs  b
         ldb   #$08
         lbsr  L1789
         puls  pc,b
L1871    pshs  b
         ldb   #$06
         lbsr  L1789
         puls  pc,b
L187A    pshs  x,b,a
         ldd   <u0038
         pshs  b,a
         bra   L188E
L1882    pshs  x,b,a
         ldd   <u0038
         pshs  b,a
         ldd   $02,s
         clrb
         lbsr  L1742
L188E    ldb   #$0C
         lbsr  L1789
         beq   L189C
L1895    puls  b,a
         lbsr  L1742
         puls  pc,x,b,a
L189C    ldb   <u0040
         lda   #$20
L18A0    lbsr  L0105
         decb
         bpl   L18A0
         bra   L1895
L18A8    pshs  b
         clr   <u006C
         andb  #$01
         beq   L18B9
         ldb   #$1E
         lbsr  L1789
         bne   L18B9
         inc   <u006C
L18B9    ldb   ,s
         andb  #$48
         cmpb  #$00
         beq   L18EE
         cmpb  #$48
         bne   L18D0
         ldb   #$2E
         lbsr  L1789
         bne   L18EE
         inc   <u006C
         bra   L18EE
L18D0    cmpb  #$08
         bne   L18DF
         ldb   #$2A
         lbsr  L1789
         bne   L18EE
         inc   <u006C
         bra   L18EE
L18DF    cmpb  #$40
         bne   L18EE
         ldb   #$26
         lbsr  L1789
         bne   L18EE
         inc   <u006C
         bra   L18EE
L18EE    ldb   ,s
         andb  #$02
         beq   L18FD
         ldb   #$22
         lbsr  L1789
         bne   L18FD
         inc   <u006C
L18FD    ldb   ,s
         andb  #$20
         beq   L190E
         ldb   #$44
         lbsr  L1789
         bne   L191D
         inc   <u006C
         bra   L191D
L190E    ldb   ,s
         andb  #$10
         beq   L191D
         ldb   #$40
         lbsr  L1789
         bne   L191D
         inc   <u006C
L191D    tst   <u006C
         bne   L1927
         ldb   ,s
         andb  #$04
         beq   L192C
L1927    ldb   #$18
         lbsr  L1789
L192C    ldb   <u0039
         cmpb  <u0040
         bhi   L1937
         inc   <u0039
         lbsr  L0105
L1937    puls  pc,b
L1939    pshs  b
         clr   <u006C
         andb  #$01
         beq   L194A
         ldb   #$1C
         lbsr  L1789
         bne   L194A
         inc   <u006C
L194A    ldb   ,s
         andb  #$48
         cmpb  #$00
         beq   L1979
         cmpb  #$48
         bne   L195F
         ldb   #$30
         lbsr  L1789
         bne   L1979
         inc   <u006C
L195F    cmpb  #$08
         beq   L196C
         ldb   #$2C
         lbsr  L1789
         bne   L1979
         inc   <u006C
L196C    cmpb  #$40
         bne   L1979
         ldb   #$28
         lbsr  L1789
         bne   L1979
         inc   <u006C
L1979    ldb   ,s
         andb  #$02
         beq   L1988
         ldb   #$24
         lbsr  L1789
         bne   L1988
         inc   <u006C
L1988    ldb   ,s
         andb  #$20
         beq   L1997
         ldb   #$46
         lbsr  L1789
         bne   L1997
         inc   <u006C
L1997    ldb   ,s
         andb  #$10
         beq   L19A6
         ldb   #$42
         lbsr  L1789
         bne   L19A6
         inc   <u006C
L19A6    tst   <u006C
         bne   L19B0
         ldb   ,s
         andb  #$04
         beq   L19B5
L19B0    ldb   #$16
         lbsr  L1789
L19B5    puls  pc,b
L19B7    clrb
         lbsr  L0342
         bcs   L19EC
         sta   <u006C
L19BF    lbsr  L0342
         bcs   L19EC
         pshs  x
         tsta
         bpl   L19D0
         cmpa  #$80
         bne   L19D0
         ldx   #$0000
L19D0    lslb
         stx   b,y
         asrb
         puls  x
         incb
         sta   ,x+
         bmi   L19E4
L19DB    lbsr  L0342
         bcs   L19EC
         sta   ,x+
         bpl   L19DB
L19E4    cmpb  <u006C
         bcs   L19BF
         lbsr  L02CD
L19EB    rts

L19EC    ldx   >L065A,pcr 'BAD TERM_STY...
         lbsr  L0324
         lbra  L0355
L19F6    ldd   >L0658,pcr
         leax  >L0000,pcr
         leax  d,x
         lbsr  L0259
         lbcs  L19EC
         lda   <u0042
         ldb   #$FF
         mul
         addd  #$01B8
         exg   d,u
         lbsr  L0535
         ldx   <u0043
         leax  <$38,x
         lbsr  L0342
         bcs   L19EC
         sta   <u006C
         ldy   <u008E
         leay  <$45,y
L1A26    lbsr  L0342
         lbcs  L19EC
         sta   ,y+
         dec   <u006C
         bne   L1A26
         ldy   <u0043
         lbra  L19B7
L1A39    ldd   >L0658,pcr
         leax  >L0000,pcr
         leax  d,x
         lbsr  L0259
         lbcs  L19EC
         ldu   #$0DAC
         lbsr  L0535
         ldd   #$01E0
         std   <u006E
         ldx   <u0043
L1A57    lbsr  L0342
         lbcs  L19EC
         sta   ,x+
         ldd   <u006E
         subd  #$0001
         std   <u006E
         bne   L1A57
         ldx   <u0016
         leax  $01,x
         lda   #$00
         lbsr  L0542
         lbcs  L0355
         ldx   <u0016
         lda   #$2F
         sta   ,x
         pshs  x
L1A7E    lda   ,x
         bpl   L1A88
         anda  #$7F
         ldb   #$00
         stb   $01,x
L1A88    lbsr  L1F92
         sta   ,x+
         bne   L1A7E
         puls  x
         lda   #$0B
         lbsr  L1AFA
         ldy   <u0043
         lbsr  L1AD4
         bcc   L1AD0
         leax  $0B,x
         tst   <u003B
         bpl   L1AAA
         lda   ,x+
         sta   <u003B
         bra   L1AAC
L1AAA    leax  $01,x
L1AAC    ldy   <u0014
         ldy   $0A,y
         ldb   #$0B
L1AB4    lda   ,x+
         cmpa  #$20
         beq   L1AC1
         sta   ,y+
         decb
         bne   L1AB4
         bra   L1AC8
L1AC1    lda   #$00
         sta   ,y+
         decb
         bne   L1AB4
L1AC8    tst   <u0042
         bpl   L1AD0
         lda   ,x+
         sta   <u0042
L1AD0    lbsr  L02CD
         rts
L1AD4    pshs  y,b,a
L1AD6    clrb
L1AD7    cmpb  #$04
         beq   L1AF0
         lda   b,x
         sta   <u006D
         lda   b,y
         cmpa  <u006D
         bne   L1AE8
         incb
         bra   L1AD7
L1AE8    tsta
         beq   L1AF4
         leay  <$18,y
         bra   L1AD6
L1AF0    orcc  #$01
         bra   L1AF6
L1AF4    andcc #$FE
L1AF6    tfr   y,x
         puls  pc,y,b,a
L1AFA    pshs  x,b
         adda  #$01
L1AFE    deca
         beq   L1B0E
         ldb   ,x+
         bne   L1AFE
         leax  -$01,x
         ldb   #$20
L1B09    stb   ,x+
         deca
         bne   L1B09
L1B0E    leax  -$01,x
         sta   ,x
         puls  pc,x,b
L1B14    pshs  b
         ldb   #$34
         lbsr  L1D89
         puls  pc,b
L1B1D    pshs  b
         ldb   #$36
         lbsr  L1D89
         puls  pc,b
L1B26    pshs  b
         ldb   #$04
L1B2A    lbsr  L1D89
         puls  pc,b
L1B2F    pshs  b
         ldb   #$06
         bra   L1B2A
L1B35    pshs  b
         ldb   #$08
         bra   L1B2A
L1B3B    pshs  b
         ldb   #$1E
         bra   L1B2A
L1B41    lda   <u0045
         bita  #$04
         beq   L1B53
         tst   <u0030,u
         beq   L1B53
         clr   <u00D7
         clr   <u00D9
         lbsr  L1CCD
L1B53    lda   #$0D
         bsr   L1B6C
         lda   <u0045
         bita  #$08
         beq   L1B61
         lda   #$0A
         bsr   L1B6C
L1B61    clra
         ldb   <u00F5
L1B64    beq   L1B6B
         bsr   L1B6C
         decb
         bra   L1B64
L1B6B    rts
L1B6C    pshs  u
         ldu   <u005D
         jsr   ,u
         puls  pc,u
L1B74    pshs  b
         cmpa  <u0037
         beq   L1BAD
         sta   <u0037
         ldb   #$20
         cmpa  <u004B
         beq   L1BA8
         ldb   #$22
         cmpa  <u004C
         beq   L1BA8
         ldb   #$24
         cmpa  <u004D
         beq   L1BA8
L1B8E    ldb   <u0046
         beq   L1BAD
         lbsr  L369E
         puls  b
L1B97    pshs  b
         ldb   #$02
         lbsr  L1D89
         bcs   L1BAD
         adda  <u004A
         bsr   L1B6C
         andcc #$FE
         bra   L1BAD
L1BA8    lbsr  L1D89
         bcs   L1B8E
L1BAD    puls  pc,b
L1BAF    pshs  b
         cmpa  <u0036
         beq   L1BEE
         sta   <u0036
         ldb   #$26
         cmpa  <u004E
         beq   L1BE9
         ldb   #$28
         cmpa  <u004F
         beq   L1BE9
         ldb   #$2A
         cmpa  <u0050
         beq   L1BE9
L1BC9    ldb   <u0047
         beq   L1BEE
         lbsr  L369E
         puls  b
         pshs  b
         cmpa  <u0036
         beq   L1BEE
         sta   <u0036
         ldb   #$00
         lbsr  L1D89
         bcs   L1BEE
         adda  <u0049
         bsr   L1B6C
         andcc #$FE
         bra   L1BEE
L1BE9    lbsr  L1D89
         bcs   L1BC9
L1BEE    puls  pc,b
L1BF0    lda   #$20
         sta   <u006D
         lda   #$0A
         lbsr  L1D50
         rts
L1BFA    lda   #$10
         sta   <u006D
         lda   #$0E
         lbsr  L1D50
         rts
L1C04    lda   #$04
         sta   <u006D
         lda   #$16
         lbsr  L1D50
         bcc   L1C33
         lda   #$02
         bita  <u0045
         beq   L1C33
         pshs  x,a
         ldx   <u0043
         lda   #$06
         ldx   a,x
         puls  x,a
         beq   L1C33
         lbsr  L1B26
         bcs   L1C33
         lda   #$5F
         lbsr  L1B6C
         lda   #$08
         lbsr  L1B6C
         lbsr  L1B2F
L1C33    rts
L1C34    lda   #$01
         sta   <u006D
         lda   #$12
         lbsr  L1D50
         bcc   L1C61
         lda   #$02
         bita  <u0045
         beq   L1C61
         tst   <u0030,u
         bne   L1C51
         lda   #$5F
         lbsr  L1B6C
         bra   L1C5C
L1C51    ldx   <u0030
         leax  >$00BE,x
         lda   $01,x
         lbsr  L1B6C
L1C5C    lda   #$08
         lbsr  L1B6C
L1C61    rts
L1C62    pshs  b
         lda   #$02
         sta   <u006D
         lda   #$1A
         lbsr  L1D50
         bcc   L1CBF
         lda   #$02
         bita  <u0045
         bne   L1C79
         lda   <u00D7
         bra   L1CA6
L1C79    ldx   <u0043
         lda   #$02
         ldx   a,x
         beq   L1CAD
         lda   #$01
         lbsr  L1B97
         bcs   L1CAD
         ldb   <u002F,u
         asrb
L1C8C    lda   <u00D7
         lbsr  L1B6C
         lbsr  L1B6C
         lda   #$08
         lbsr  L1B6C
         lbsr  L1B6C
         decb
         bne   L1C8C
         lda   <u00D8
         lbsr  L1B97
         lda   #$20
L1CA6    lbsr  L1B6C
L1CA9    orcc  #$01
         puls  pc,b
L1CAD    ldb   <u002F,u
L1CB0    lda   <u00D7
         lbsr  L1B6C
         decb
         beq   L1CA9
         lda   #$08
         lbsr  L1B6C
         bra   L1CB0
L1CBF    puls  pc,b
L1CC1    lda   #$02
         bita  <u0045
         beq   L1CCC
         lda   #$08
         lbsr  L1B6C
L1CCC    rts
L1CCD    lda   <u00D7
         cmpa  <u0032,u
         bne   L1CDD
         tst   <u0032,u
         beq   L1CDD
         lda   #$20
         sta   <u00D7
L1CDD    tst   <u0030,u
         beq   L1D26
         lda   <u0045
         bita  #$01
         beq   L1D26
         bita  #$04
         beq   L1D26
         lda   <u00DB
         ldb   <u00D8
         stb   <u00DB
         adda  <u00DB
         asra
         sta   <u00D8
         ldx   <u0030
         ldb   <u00DA
         clra
         lslb
         leax  d,x
         lda   $01,x
         ldb   <u00D7
         sta   <u00D7
         stb   <u00DA
         ldb   <u00D9
         lda   <u00DC
         stb   <u00DC
         sta   <u00D9
         lda   <u00DA
         beq   L1D17
         cmpa  #$F0
         bne   L1D1F
L1D17    lda   #$20
         sta   <u00DA
         clr   <u00DB
         clr   <u00DC
L1D1F    lda   <u00D8
         adda  <u00DF
         lbsr  L1B97
L1D26    ldb   <u00D9
         lbsr  L1BF0
         lbsr  L1BFA
         lbsr  L1C04
         lbsr  L1C34
         lbsr  L1C62
         bcs   L1D46
         lda   <u00D7
         beq   L1D46
         cmpa  #$F0
         beq   L1D46
         anda  #$7F
         lbsr  L1B6C
L1D46    andcc #$FE
         rts
         lda   <u00DF
         lbsr  L1B97
         bra   L1D26
L1D50    bitb  <u006D
         beq   L1D6E
         pshs  a
         lda   <u006D
         bita  <u00E2
         puls  a
         bne   L1D86
         exg   a,b
         bsr   L1D89
         exg   a,b
         bcs   L1D88
         lda   <u00E2
         ora   <u006D
         sta   <u00E2
         bra   L1D86
L1D6E    pshs  a
         lda   <u006D
         bita  <u00E2
         puls  a
         beq   L1D86
         inca
         inca
         exg   a,b
         bsr   L1D89
         exg   a,b
         lda   <u00E2
         eora  <u006D
         sta   <u00E2
L1D86    andcc #$FE
L1D88    rts
L1D89    pshs  x,b,a
         orcc  #$01
         ldx   <u0043
         ldx   b,x
         beq   L1DB0
         lda   $01,x
         cmpa  #$FF
         bne   L1D9B
         jmp   $03,x
L1D9B    lda   ,x
         anda  #$7F
         beq   L1DB0
L1DA1    lda   ,x+
         pshs  a
         anda  #$7F
         lbsr  L1B6C
         lda   ,s+
         bpl   L1DA1
         andcc #$FE
L1DB0    puls  pc,x,b,a

* L1DB2
start    equ   *
         lbsr  L0067
         tfr   a,dp
         tfr   d,u
         tfr   d,x
         clra
L1DBC    clr   ,u+
         adda  #$01
         bcc   L1DBC
         stx   <u008E
         leay  $01,y
         sty   <u0072
         sty   <u0077
         ldx   <u008E
         leay  >$0100,x
         leax  ,y
         stx   <u0014
         leax  >$0407,y
         stx   <u001A
         leax  >$043F,y
         stx   <u001C
         leax  >$0477,y
         stx   <u001E
         leax  >$04AF,y
         stx   <u0020
         leax  >$05E7,y
         stx   <u0022
         leax  >$0745,y
         stx   <u0024
         leax  >$08A3,y
         stx   <u0026
         leax  >$08A3,y
         stx   <u0028
         leax  >$08E5,y
         stx   <u002A
         leax  >$091C,y
         stx   <u002C
         leax  <$32,y
         stx   <u0016
         leax  >$0190,y
         stx   <u0018
         leax  >$0B47,y
         stx   <u002E
         leax  >$04E7,y
         stx   <u0030
         leax  >$0191,y
         stx   <u003C
         leax  >$02C7,y
         stx   <u0043
         leax  >$0A4D,y
         stx   <u0034
         leax  >$0953,y
         stx   <u0032
         leax  >$1505,y
         stx   <u0090
         leax  ,x
         stx   <u0086
         lbsr  L006C
         lds   <u0018
         ldx   >L165F,pcr
         ldy   <u0014
         ldy   $0A,y
         ldb   #$0B
L1E5D    lda   ,x+
         cmpa  #$20
         beq   L1E5D
         sta   ,y+
         beq   L1E6A
         decb
         bne   L1E5D
L1E6A    lda   #$80
         sta   <u0042
         sta   <u003B
         lda   >L000F,pcr
         sta   <u0076
         lbsr  L4150
         lbsr  L1673
         lbsr  L180B
         lbsr  L19F6
         lda   >L0013,pcr
         sta   <u00F5
         ldx   <u0086
         lda   <u0076
         ldb   #$38
         mul
         leax  d,x
         stx   <u0070
         stx   <u0081
         ldd   #$FFFF
         std   <u0092
         sta   <u0083
         inc   <u007E
         ldx   <u0024
         stx   <u0098
         lda   <u003F
         inca
         sta   <u0074
         ldx   <u0030
         clra
         ldb   #$0A
L1EAC    stb   ,x+
         sta   ,x+
         inca
         bpl   L1EAC
         ldx   <u0028
         ldb   #$16
         lda   #$08
L1EB9    sta   ,x+
         pshs  b,a
         lda   #$4C
         clrb
         std   ,x++
         puls  b,a
         decb
         beq   L1ECB
         adda  #$08
         bra   L1EB9
L1ECB    clr   <u00F2
         lda   #$00
         sta   <u00F1
         ldy   <u0086
         ldb   #$38
L1ED6    clr   ,y+
         decb
         bne   L1ED6
         ldy   <u0086
         ldd   <u0070
         std   $04,y
         ldx   #$0000
         stx   ,y
         ldb   <u0040
         leax  b,x
         stx   $02,y
         ldb   >L05AD,pcr
         stb   <$17,y
         stb   <$18,y
         ldb   >L05AE,pcr
         bne   L1EFF
         ldb   <u0040
L1EFF    stb   <$1C,y
         ldb   >L05B1,pcr
         stb   <$26,y
         ldb   >STPL,pcr
         stb   <$2B,y
         incb
         stb   <$1B,y
         ldb   >L05AF,pcr
         stb   <$24,y
         ldb   >L05B0,pcr
         bne   L1F23
         ldb   <u0040
L1F23    stb   <$20,y
         com   $08,y
         ldb   >L05B3,pcr
         stb   <$2D,y
         ldb   >L05B4,pcr
         stb   <$2E,y
         ldb   >L05B5,pcr
         stb   <$2F,y
         ldb   #$01
         ldb   >L05B7,pcr
         stb   <$32,y
         ldb   >L05B8,pcr
         stb   <$33,y
         ldb   >L05B9,pcr
         stb   <$31,y
         stb   <$12,y
         tfr   y,x
         ldy   <u001C
         ldd   #$0038
         lbsr  L4D27
         ldu   <u001C
         ldx   <u0072
         leax  -$01,x
         stx   u0006,u
         stx   u0004,u
         lda   #$F0
         sta   ,x
         lbsr  L25FD
         lbra  L5E30
L1F76    lbsr  L019F
         beq   L1F87
L1F7B    lbsr  L0131   Read keyboard
         anda  #$7F
         tst   <u0056
         beq   L1F86
         bsr   L1F92
L1F86    rts
L1F87    bsr   L1F9D
         bcs   L1F76
         lbsr  L371D
         bcs   L1F76
         bra   L1F7B
L1F92    cmpa  #$61
         bcs   L1F9C
         cmpa  #$7A
         bhi   L1F9C
         suba  #$20
L1F9C    rts
L1F9D    pshs  u,y,x,b,a
         tst   <u00A5
         bne   L1FE2
         tst   <u009A
         bne   L1FAB
         andcc #$FE
         bra   L1FE0
L1FAB    ldu   <u0020
         ldx   <u0096
         ldd   ,u
         std   ,x
         ldd   u0004,u
         std   $02,x
         lda   u0008,u
         sta   $04,x
         leax  $05,x
         stx   <u0096
         ldx   <u0024
         cmpx  <u0096
         beq   L1FDC
L1FC5    lbsr  L25FD
         tst   TTYSTATE,u
         beq   L1FDC
         tst   u0008,u
         beq   L1FD8
         lda   [,u]
         cmpa  >L0594,pcr
         beq   L1FC5
L1FD8    orcc  #$01
         bra   L1FE0
L1FDC    clr   <u009A
         orcc  #$01
L1FE0    puls  pc,u,y,x,b,a
L1FE2    clr   <u00A5
         lda   #$01
         sta   <u009A
         ldd   <u0094
         cmpd  <u0065
         beq   L200E
         subd  #$0001
         std   <u0092
         subd  <u0065
         lda   #$38
         mul
         ldx   <u0086
         leax  d,x
         ldy   <u0020
         ldd   #$0038
         lbsr  L4D27
         ldx   <u0022
         stx   <u0096
         orcc  #$01
         bra   L1FE0
L200E    clr   <u009A
         ldd   #$FFFF
         std   <u0092
         andcc #$FE
         bra   L1FE0
L2019    lbsr  L17D7
         lbsr  L183B
         lbra  L0355
L2022    cmpa  #$F2
         lbeq  L218E
         sta   <u00D0
         tst   <u0060
         lbne  L218F
         tst   <u00AB
         bne   L203A
         lda   #$FF
         sta   <u00D1
         clr   <u00D3
L203A    cmpu  <u001C
         bne   L206A
         lda   <u00D0
         beq   L206A
         cmpa  #$A0
         beq   L206A
         tst   <u00D2
         bne   L2052
         cmpy  u0006,u
         bne   L206A
         bra   L2066
L2052    lda   <u00AB
         cmpa  <u0085
         bhi   L205D
         sty   u0006,u
         bra   L2066
L205D    lda   <u00D1
         cmpa  #$FF
         bne   L206A
         sty   u0006,u
L2066    lda   <u00AB
         sta   <u00D1
L206A    lda   <u00D0
         beq   L20B5
         cmpa  #$F0
         beq   L20B5
         lda   <u00AB
         cmpa  <u00AA
         bcs   L20B5
         tst   <u0039
         bne   L2091
         tst   <u00AA
         beq   L2091
         lda   #$01
         sta   <u00D3
         tst   <u0088
         beq   L2091
         lda   >L0599,pcr
         lbsr  L1709
         bra   L20B5
L2091    lda   <u00AB
         suba  <u00AA
         cmpa  <u0040
         bcs   L20AE
         bhi   L20B5
         tst   <u0088
         beq   L20A6
         lda   >L0598,pcr
         lbsr  L1709
L20A6    lda   <u00D3
         ora   #$50
         sta   <u00D3
         bra   L20B5
L20AE    tst   <u0088
         beq   L20B5
         lbsr  L2361
L20B5    lda   <u00D0
         beq   L20C0
         cmpa  #$F0
         beq   L20C0
         inc   <u00AB
         rts
L20C0    ldb   <u00AB
         subb  <u00AA
         bcs   L2107
         cmpb  <u0040
         bhi   L212A
         beq   L210B
         lda   #$20
         tst   <u0039
         bne   L20E0
         tst   <u00AA
         beq   L20E0
         lda   #$01
         anda  <u00D3
         sta   <u00D3
         lda   >L0599,pcr
L20E0    tst   <u0088
         beq   L2107
         cmpa  #$20
         bne   L2104
         pshs  b
         addb  #$05
         cmpb  <u0040
         puls  b
         bhi   L2104
         lbsr  L187A
         lda   <u0038
         ldb   <u0040
         lbsr  L1742
         ldb   <u0040
         addb  <u00AA
         stb   <u00AB
         bra   L20C0
L2104    lbsr  L1709
L2107    inc   <u00AB
         bra   L20C0
L210B    tst   <u00D3
         bmi   L212A
         tst   <u0088
         beq   L212A
         tst   <u00D0
         beq   L2125
         tst   u0008,u
         beq   L211F
         lda   #$2D
         bra   L2127
L211F    lda   >L0593,pcr
         bra   L2127
L2125    lda   #$20
L2127    lbsr  L1709
L212A    cmpu  <u001C
         bne   L218E
         clr   <u00A9
         ldd   u0006,u
         cmpd  ,u
         bcs   L218E
         cmpd  u0002,u
         bcc   L218E
         lda   <u00D0
         cmpa  #$09
         bne   L214C
         ldb   <u00D1
         lbsr  L297B
         stb   <u00D1
         bra   L2159
L214C    cmpa  #$F0
         bne   L2159
         cmpy  u0006,u
         bne   L2159
         ldb   <u0040
         bra   L2189
L2159    ldb   <u00D1
         subb  <u00AA
         bcs   L2180
         cmpb  <u0040
         bhi   L2185
         tst   <u00D3
         beq   L2189
         tstb
         bne   L2174
         lda   <u00D3
         bita  #$01
         beq   L2189
         inc   <u00A9
         bra   L2189
L2174    cmpb  <u0040
         bne   L2189
         tst   <u00D3
         bpl   L2189
         inc   <u00A9
         bra   L2189
L2180    inc   <u00A9
         clrb
         bra   L2189
L2185    inc   <u00A9
         ldb   <u0040
L2189    lda   <u0038
         lbsr  L1742
L218E    rts
L218F    tsta
         beq   L21EE
         cmpa  #$F0
         beq   L21EE
         cmpa  #$A0
         beq   L21BA
         lda   ,y
         cmpa  <u0031,u
         lbeq  L2243
         cmpa  #$F1
         bne   L21B1
         leax  $01,y
         cmpx  u0002,u
         bne   L21ED
         lda   #$2D
         bra   L21BA
L21B1    tsta
         bpl   L21BA
         bsr   L21F7
         lda   $01,y
         bra   L21BC
L21BA    clr   <u00D9
L21BC    cmpa  >L0596,pcr
         bne   L21C5
         lbsr  L23A1
L21C5    anda  #$7F
         sta   <u00D7
         lbsr  L3CC5
         stb   <u00D8
         tst   <u0030,u
         beq   L21EA
         lda   <u0045
         bita  #$01
         beq   L21EA
         tst   <u0026,u
         beq   L21EA
         lda   <u00A3
         sta   <u00DF
         tst   <u00A4
         beq   L21EA
         dec   <u00A4
         inc   <u00DF
L21EA    lbra  L1CCD
L21ED    rts
L21EE    lda   #$20
         clr   <u00D9
         sta   <u00D7
         lbra  L1CCD
L21F7    pshs  a
         ldb   ,y
         andb  #$07
         decb
         stb   <u006C
         ldb   ,y
         andb  #$08
         orb   <u006C
         stb   <u006C
         lda   ,y
         anda  #$70
         ldb   <u006C
         cmpa  #$30
         bne   L2216
         orb   #$00
         bra   L223C
L2216    cmpa  #$40
         bne   L221E
         orb   #$10
         bra   L223C
L221E    cmpa  #$60
         bne   L2226
         orb   #$20
         bra   L223C
L2226    cmpa  #$20
         bne   L222E
         orb   #$40
         bra   L223C
L222E    cmpa  #$50
         bne   L2236
         orb   #$50
         bra   L223C
L2236    cmpa  #$70
         bne   L2240
         orb   #$60
L223C    stb   <u00D9
         puls  pc,a
L2240    clrb
         bra   L223C
L2243    pshs  x
         sty   <u006A
         leax  $01,y
L224A    lda   ,x+
         cmpa  #$F0
         beq   L2260
         tsta
         bmi   L225C
         cmpa  <u0031,u
         beq   L2260
         cmpx  u0002,u
         bcs   L224A
L225C    tfr   x,y
         puls  pc,x
L2260    ldx   <u006A
L2262    leax  $01,x
L2264    lda   ,x
         cmpa  <u0031,u
         beq   L225C
         cmpa  #$F0
         beq   L225C
         cmpa  #$20
         beq   L2262
         cmpa  #$2C
         beq   L2262
         lbsr  L1F92
         cmpa  >L059E,pcr
         beq   L22BE
         cmpa  >L059F,pcr
         beq   L22E5
         cmpa  >L05A0,pcr
         lbeq  L231F
         cmpa  >L05A4,pcr
         lbeq  L233A
         cmpa  >L05A5,pcr
         lbeq  L2346
         cmpa  >L05A6,pcr
         lbeq  L234F
         cmpa  >L05A7,pcr
         lbeq  L2358
         lbsr  L59DA
         bcs   L225C
         pshs  x
         lbsr  L1B6C
         puls  x
         leax  -$01,x
         bra   L2264
L22BE    lda   $01,x
         cmpa  #$20
         beq   L22CF
         cmpa  #$2C
         beq   L22CF
         cmpa  <u0031,u
         lbne  L225C
L22CF    pshs  x
         lda   #$03
         lbsr  L1882
         ldx   >L0622,pcr
         lbsr  L402C
         lbsr  L1F76
         puls  x
         lbra  L2262
L22E5    leax  $01,x
         lbsr  L5221
         lbcs  L225C
         pshs  x
         pshs  b
         clr   <u00D9
         clr   <u00D8
         lda   #$20
         sta   <u00D7
         lbsr  L1CCD
         lda   #$0D
         lbsr  L1B6C
         ldy   <u0016
         lda   #$20
         sta   ,y
L2309    tst   ,s
         beq   L2316
         lda   #$20
         lbsr  L218F
         dec   ,s
         bra   L2309
L2316    puls  b
         puls  x
         leax  -$01,x
         lbra  L2264
L231F    lda   $01,x
         cmpa  #$20
         beq   L2330
         cmpa  #$2C
         beq   L2330
         cmpa  <u0031,u
         lbne  L225C
L2330    pshs  x
         lbsr  L1CC1
         puls  x
         lbra  L2262
L233A    pshs  b
         ldb   #$2C
         lbsr  L1D89
L2341    puls  b
         lbra  L2262
L2346    pshs  b
         ldb   #$2E
         lbsr  L1D89
         bra   L2341
L234F    pshs  b
         ldb   #$30
         lbsr  L1D89
         bra   L2341
L2358    pshs  b
         ldb   #$32
         lbsr  L1D89
         bra   L2341
L2361    lda   <u00D0
         cmpa  #$A0
         beq   L239E
         lda   ,y
         bpl   L2396
         cmpa  #$F0
         bne   L2375
         lda   >L0593,pcr
         bra   L2396
L2375    cmpa  #$F1
         bne   L237D
         lda   #$2D
         bra   L2396
L237D    tst   <u0084
         beq   L2389
         cmpa  #$B2
         bne   L2393
         lda   #$5F
         bra   L2393
L2389    lda   $01,y
         cmpa  >L0596,pcr
         bne   L2393
         bsr   L23A1
L2393    lbra  L1722
L2396    cmpa  >L0596,pcr
         bne   L239E
         bsr   L23A1
L239E    lbra  L1709
L23A1    tst   u0008,u
         bne   L23A6
         rts
L23A6    pshs  x,b
         tst   <u005C
         beq   L23BD
         ldb   <u005B
         incb
         ldx   <u002E
         lda   b,x
         beq   L23B9
         stb   <u005B
         puls  pc,x,b
L23B9    lda   #$20
         puls  pc,x,b
L23BD    ldd   <u0011,u
         lbsr  L3200
         ldx   <u002E
         clrb
L23C6    lda   b,x
         cmpa  #$20
         bne   L23CF
         incb
         bra   L23C6
L23CF    stb   <u005B
         inc   <u005C
         puls  pc,x,b
L23D5    ldx   ,u
         lbeq  L24A3
         lbsr  L3B7C
         clr   <u006D
         lda   #$05
         sta   <u00E8
         clr   <u0034,u
         clr   <u006C
         tst   <u0030,u
         lbne  L251C
L23F0    incb
L23F1    decb
         beq   L2446
         cmpx  <u0077
         lbeq  L2495
         lda   ,x+
         cmpa  #$09
         lbeq  L24A4
         tsta
         lbmi  L24AB
         cmpa  <u0031,u
         bne   L23F1
         incb
         clr   <u00E0
L240F    inc   <u00E0
         cmpa  #$F0
         beq   L2432
         tstb
         lda   ,x+
         bmi   L2495
         lbsr  L1F92
         cmpa  >L05A0,pcr
         lbeq  L24D1
         cmpa  >L059F,pcr
         lbeq  L24F7
         cmpa  <u0031,u
         bne   L240F
L2432    lda   <u0034,u
         adda  <u00E0
         sta   <u0034,u
         bra   L23F1
         lda   <u0034,u
         adda  <u00E0
         sta   <u0034,u
         bra   L2495
L2446    tfr   x,y
         tst   <u006D
         bne   L2454
         stx   u0002,u
         tst   u0008,u
         bne   L2454
         stx   u0004,u
L2454    lda   ,x
         cmpa  #$20
         bne   L2462
         leax  $01,x
         dec   <u00E8
         beq   L2495
         bra   L2454
L2462    cmpa  #$F0
         beq   L2493
         tst   <u006D
         beq   L246E
         cmpa  #$09
         beq   L2495
L246E    lda   ,-x
         cmpa  #$20
         beq   L2491
         cmpa  #$F1
         beq   L2491
         cmpa  #$2D
         beq   L2491
         cmpa  <u0031,u
         beq   L24C4
         tst   <u006D
         beq   L2489
         cmpa  #$09
         beq   L248D
L2489    cmpx  ,u
         bne   L246E
L248D    inc   <u006C
         bra   L24A3
L2491    inc   <u006C
L2493    leax  $01,x
L2495    tfr   x,y
         tst   <u006D
         bne   L24A3
         stx   u0002,u
         tst   u0008,u
         bne   L24A3
         stx   u0004,u
L24A3    rts
L24A4    tst   <u006D
         bne   L2495
         lbra  L24F7
L24AB    cmpa  #$F0
         beq   L2495
         cmpa  #$F2
         bne   L24C0
         tst   <u006D
         lbeq  L23F1
         lda   #$02
         sta   <u006C
         lbra  L2495
L24C0    incb
         lbra  L23F1
L24C4    lda   ,-x
         cmpa  <u0031,u
         beq   L246E
         cmpx  ,u
         bhi   L24C4
         bra   L24A3
L24D1    lda   -$02,x
         cmpa  #$20
         beq   L24E2
         cmpa  #$2C
         beq   L24E2
         cmpa  <u0031,u
         lbne  L240F
L24E2    lda   ,x
         cmpa  #$20
         beq   L24F3
         cmpa  #$2C
         beq   L24F3
         cmpa  <u0031,u
         lbne  L240F
L24F3    incb
         lbra  L240F
L24F7    pshs  x
         pshs  b
         ldb   <u00A6
         subb  ,s+
         lbsr  L297B
         puls  x
         lbcs  L2446
         pshs  b
         ldb   <u00A6
         subb  ,s+
         tst   <u00F3
         beq   L2519
         pshs  b
         lbsr  L28FD
         addb  ,s+
L2519    lbra  L23F0
L251C    ldy   <u0030
         lda   #$33
         lbsr  L3CC5
         lda   <u00A6
         mul
         std   <u006E
L2529    cmpx  <u0077
         lbeq  L25AD
         ldb   ,x+
         lbmi  L25B6
         cmpb  <u0031,u
         beq   L254D
         lslb
         clra
         ldb   d,y
         stb   <u00DB
         clra
         pshs  b,a
         ldd   <u006E
         subd  ,s++
         std   <u006E
         bcc   L2529
         bra   L257B
L254D    clr   <u00E0
L254F    inc   <u00E0
         cmpa  #$F0
         beq   L2567
         tsta
         lda   ,x+
         bmi   L25AD
         cmpa  >L05A0,pcr
         lbeq  L25D3
         cmpa  <u0031,u
         bne   L254F
L2567    lda   <u0034,u
         adda  <u00E0
         sta   <u0034,u
         bra   L2529
         lda   <u0034,u
         adda  <u00E0
         sta   <u0034,u
         bra   L25AD
L257B    leax  -$01,x
         stx   u0002,u
         tst   u0008,u
         bne   L2585
         stx   u0004,u
L2585    lda   ,x
         cmpa  #$20
         bne   L2593
         leax  $01,x
         dec   <u00E8
         beq   L25AD
         bra   L2585
L2593    cmpa  #$F0
         beq   L25AB
L2597    lda   ,-x
         cmpa  #$20
         beq   L25AB
         cmpa  #$F1
         beq   L25AB
         cmpa  #$2D
         beq   L25AB
         cmpx  ,u
         bne   L2597
         bra   L25B5
L25AB    leax  $01,x
L25AD    stx   u0002,u
         tst   u0008,u
         bne   L25B5
         stx   u0004,u
L25B5    rts
L25B6    cmpb  #$F0
         beq   L25AD
         cmpa  #$F1
         lbne  L2529
         ldb   #$5A
         clra
         ldb   d,y
         clra
         pshs  b,a
         ldd   <u006E
         subd  ,s++
         lbcs  L257B
         lbra  L2529
L25D3    lda   -$02,x
         cmpa  #$20
         beq   L25E4
         cmpa  #$2C
         beq   L25E4
         cmpa  <u0031,u
         lbne  L254F
L25E4    lda   ,x
         cmpa  #$20
         beq   L25F5
         cmpa  #$2C
         beq   L25F5
         cmpa  <u0031,u
         lbne  L254F
L25F5    ldb   <u00DB
         clra
         addd  <u006E
         lbra  L254F
L25FD    tst   u0008,u
         beq   L2609
         lda   [,u]
         cmpa  >L0594,pcr
         beq   L2679
L2609    ldx   u0002,u
         cmpx  <u0077
         bcs   L2614
         lda   #$0A
         orcc  #$01
         rts
L2614    cmpu  <u001C
         bne   L2679
         ldd   u000F,u
         subd  <u0065
         addb  #$02
         cmpb  <u0076
         bcs   L2639
         lda   <u0024,u
         inca
         adda  <u002C,u
         cmpa  <u001B,u
         bcc   L2634
         cmpa  <u002B,u
         bcs   L2639
L2634    lda   #$0B
         orcc  #$01
         rts
L2639    tst   u0008,u
         bne   L2650
         ldy   <u0081
         sty   <u00B3
         ldx   ,u
L2645    lda   ,x+
         sta   ,y+
         cmpx  u0004,u
         bne   L2645
         sty   <u0081
L2650    ldx   <u0026
         stx   <u0068
         ldx   <u0098
         cmpx  <u0068
         beq   L2679
         tst   u0008,u
         bne   L2669
         ldd   <u00B3
         std   ,x
         sty   $02,x
         clr   $04,x
         bra   L2675
L2669    ldd   ,u
         std   ,x
         ldd   <u0081
         std   $02,x
         lda   #$01
         sta   $04,x
L2675    leax  $05,x
         stx   <u0098
L2679    lbsr  L275F
         lda   <u002C,u
         cmpa  <u002B,u
         bhi   L26E5
         cmpa  <u001B,u
         bcc   L26D0
         cmpa  <u0019,u
         bls   L26AE
         clr   u0008,u
         ldx   u0004,u
L2692    stx   ,u
         lbsr  L23D5
         tst   u0008,u
         beq   L26AB
         ldd   [,u]
         cmpa  >L0594,pcr
         bne   L26AB
         cmpb  >L0594,pcr
         lbne  L25FD
L26AB    andcc #$FE
         rts
L26AE    lda   #$01
         sta   u0008,u
         lda   TTYSTATE,u
         cmpa  #$01
         bne   L26C4
         ldx   #$0000
         cmpx  ,u
         bne   L26C4
         ldx   <u0015,u
         bra   L26C6
L26C4    ldx   u0002,u
L26C6    cmpx  <u0081
         bne   L2692
         ldx   <u001C
         ldx   ,x
         bra   L2692
L26D0    lda   #$01
         sta   u0008,u
         ldx   u0004,u
         cmpx  u0002,u
         bne   L26C4
         lda   <u001B,u
         sta   <u002C,u
         ldx   <u0013,u
         bra   L26C6
L26E5    lda   <u001E,u
         sta   <u0019,u
         lda   <u001F,u
         sta   <u001A,u
         lbsr  L4FAD
         clr   TTYSTATE,u
         clr   u000D,u
         clr   <u002C,u
         ldx   <u0011,u
         leax  $01,x
         stx   <u0011,u
         ldx   u000F,u
         leax  $01,x
         stx   u000F,u
         lda   #$01
         sta   u0008,u
         ldx   #$0000
         stx   ,u
         stx   u0002,u
         lda   #$01
         sta   u0008,u
         cmpu  <u001C
         beq   L2720
         andcc #$FE
         rts
L2720    ldy   <u0022
         ldx   <u0024
         ldd   #$015E
         lbsr  L4D27
         ldd   <u0098
         subd  #$015E
         std   <u0096
         ldd   <u0094
         std   <u0092
         addd  #$0001
         std   <u0094
         ldx   <u0024
         stx   <u0098
         clr   <u009A
         ldd   u000F,u
         subd  <u0065
         lda   #$38
         mul
         ldx   <u0086
         leay  d,x
         ldx   <u001C
         ldd   #$0038
         pshs  y
         lbsr  L4D27
         puls  x
         ldd   <u0081
         std   $04,x
         andcc #$FE
         rts
L275F    tst   u0008,u
         beq   L276D
         lda   [,u]
         cmpa  >L0594,pcr
         lbeq  L283A
L276D    ldx   u0009,u
         leax  $01,x
         stx   u0009,u
         inc   u000D,u
         lda   <u001D,u
         bne   L27C3
         lda   [,u]
         cmpa  >L0594,pcr
         lbeq  L283A
         ldx   u000B,u
         leax  $01,x
         stx   u000B,u
         inc   TTYSTATE,u
         tst   u0008,u
         bne   L27AF
         lda   <u0024,u
         inca
         adda  <u002C,u
         sta   <u002C,u
         clr   <u0029,u
         tst   <u0025,u
         beq   L27A5
         dec   <u0025,u
L27A5    tst   <u0027,u
         beq   L27AD
         dec   <u0027,u
L27AD    bra   L27C2
L27AF    inc   <u002C,u
         tst   <u0021,u
         beq   L27BA
         dec   <u0021,u
L27BA    tst   <u0022,u
         beq   L27C2
         dec   <u0022,u
L27C2    rts
L27C3    ldd   [,u]
         cmpa  >L0594,pcr
         bne   L2823
         cmpb  >L0594,pcr
         bne   L2823
         lda   <u001D,u
         cmpa  #$01
         bne   L27EE
         lda   <u002B,u
         suba  <u001A,u
         bcs   L283E
         suba  <u001E,u
         bcs   L283E
         cmpa  #$03
         bls   L283E
         clr   <u001D,u
         bra   L27C2
L27EE    clr   <u001D,u
         lda   <u002B,u
         suba  <u0019,u
         bcs   L283E
         suba  <u001F,u
         bcs   L283E
         cmpa  #$03
         bls   L283E
         lda   <u001A,u
         ldb   <u001B,u
         pshs  b,a
         lda   <u001F,u
         sta   <u001A,u
         lbsr  L4FAD
         lda   <u001B,u
         cmpa  TTYSTATE,u
         puls  b,a
         bhi   L27C2
         stb   <u001B,u
         sta   <u001A,u
         rts
L2823    lda   [,u]
         cmpa  >L0594,pcr
         beq   L283A
         lda   <u001D,u
         cmpa  #$01
         bne   L2836
         inc   <u001E,u
         rts
L2836    inc   <u001F,u
         rts
L283A    lbsr  L4D3A
         rts
L283E    clrb
         stb   <u0019,u
         comb
         stb   <u001B,u
         clr   <u001E,u
         clr   <u001F,u
         clr   <u001D,u
         cmpu  <u001C
         lbne  L27C2
         lda   #$10
         lbsr  L36AB
         rts
L285C    pshs  y,x,a
         lbsr  L3B96
         pshs  b
         lbsr  L297B
         subb  ,s+
         tst   <u00F3
         beq   L287B
         pshs  b
         tfr   y,x
         leax  $01,x
         lbsr  L28FD
         stb   <u006C
         puls  b
         subb  <u006C
L287B    tstb
         bcs   L2882
         andcc #$FE
         puls  pc,y,x,a
L2882    orcc  #$01
         puls  pc,y,x,a
         lbsr  L3B96
         stb   <u006D
         lbsr  L2913
         pshs  b,a
         ldb   <u006D
         lbsr  L297B
         pshs  b
         lda   #$20
         lbsr  L3CC5
         puls  a
         inca
         mul
         subd  ,s++
         tst   <u00F3
         beq   L28C6
         pshs  y
         std   <u006E
         ldd   #$0000
         pshs  b,a
L28AF    lda   ,y+
         lbsr  L28D7
         bcs   L28C0
         lbsr  L3CC5
         clra
         addd  ,s++
         pshs  b,a
         bra   L28AF
L28C0    ldd   <u006E
         subd  ,s++
         puls  y
L28C6    pshs  b,a
         lda   #$20
         lbsr  L3CC5
         clra
         std   <u006E
         puls  b,a
         lbsr  L3CEC
         bra   L287B
L28D7    cmpa  #$2C
         beq   L28F7
         cmpa  #$20
         beq   L28F7
         cmpa  #$2D
         beq   L28F7
         cmpa  #$2B
         beq   L28F7
         cmpa  #$23
         beq   L28F7
         cmpa  #$24
         beq   L28F7
         cmpa  #$30
         blt   L28FA
         cmpa  #$39
         bhi   L28FA
L28F7    andcc #$FE
         rts
L28FA    orcc  #$01
         rts
L28FD    pshs  x,a
         clrb
         leax  -$01,x
         lda   ,x+
         cmpa  #$09
         bne   L2911
L2908    lda   ,x+
         bsr   L28D7
         bcs   L2911
         incb
         bra   L2908
L2911    puls  pc,x,a
L2913    pshs  y,x
         ldd   #$0000
         ldx   ,u
         sty   <u006A
         pshs  b,a
L291F    cmpx  <u006A
         bcc   L2979
         lda   ,x+
         bmi   L291F
         cmpa  #$09
         beq   L2935
         lbsr  L3CC5
         clra
         addd  ,s++
         pshs  b,a
         bra   L291F
L2935    lda   #$20
         lbsr  L3CC5
         clra
         std   <u006E
         ldd   ,s++
         lbsr  L3CEC
         lbsr  L297B
         pshs  b
         lda   #$20
         lbsr  L3CC5
         puls  a
         mul
         tst   <u00F3
         beq   L2973
         stx   <u0057
         std   <u006E
         ldd   #$0000
         pshs  b,a
L295C    lda   ,x+
         lbsr  L28D7
         bcs   L296D
         lbsr  L3CC5
         clra
         addd  ,s++
         pshs  b,a
         bra   L295C
L296D    ldd   <u006E
         subd  ,s++
         leax  -$01,x
L2973    ldx   <u0057
         pshs  b,a
         bra   L291F
L2979    puls  pc,y,x,b,a
L297B    pshs  x,a
         ldx   <u0028
         clra
         clr   <u00F3
L2982    cmpb  a,x
         bcs   L299C
         pshs  b
         ldb   a,x
         puls  b
         inca
         inca
         inca
         cmpa  #$42
         bne   L2982
         lda   #$1C
         lbsr  L36AB
         orcc  #$01
         puls  pc,x,a
L299C    ldb   a,x
         pshs  b
         inca
         ldb   a,x
         cmpb  #$44
         bne   L29A9
         inc   <u00F3
L29A9    puls  b
         stb   <u00F1
         andcc #$FE
         puls  pc,x,a
L29B1    lda   #$01
         sta   <u00F6
         lbsr  L1868
         clr   <u00C5
         bra   L29BE
L29BC    ldu   <u001C
L29BE    lbsr  L39E7
L29C1    ldb   <u0039
         addb  <u00AA
         stb   <u00D1
         lbsr  L30EB
         lda   <u0039
         cmpa  <u0040
         bcc   L29BC
         ldd   u000F,u
         subd  <u0065
         addb  #$02
         cmpb  <u0076
         bcs   L29F3
         lda   <u0024,u
         inca
         adda  <u002C,u
         cmpa  <u001B,u
         bcc   L29EB
         cmpa  <u002B,u
         bcs   L29F3
L29EB    lda   #$0B
         lbsr  L36AB
         lbra  L2B2D
L29F3    lbsr  L1F76
         tst   <u00F3
         beq   L2A01
         lbsr  L28D7
         bcc   L2A01
         clr   <u00F3
L2A01    cmpa  >L057A,pcr
         bne   L2A0B
         clr   <u00C5
         bra   L29C1
L2A0B    cmpa  #$1F
         lbls  L2AF1
         cmpa  #$7F
         lbhi  L2AF1
L2A17    sta   <u008B
         tst   <u00C5
         lbne  L2AA7
L2A1F    lbsr  L3666
         bcs   L29C1
         lda   <u008B
         cmpa  #$20
         lbeq  L2AB9
         cmpa  #$2D
         lbeq  L2AB9
         cmpa  #$F2
         beq   L2A3C
         cmpa  #$F0
         lbeq  L2A5A
L2A3C    lbsr  L2DEC
         lbcs  L29BE
         ldy   u0006,u
         tst   <u00C5
         beq   L2A4C
         leay  -$01,y
L2A4C    leay  -$01,y
         lbsr  L2361
         tst   <u00F3
         lbne  L29BE
         lbra  L29C1
L2A5A    lda   <u00F2
         cmpa  #$00
         beq   L2AB9
         lda   <u00F1
         cmpa  #$00
         beq   L2AB9
         lbsr  L2DEC
         lda   <u00F1
         suba  <u002A,u
         sta   <u0029,u
         lbsr  L39E7
         ldy   u0006,u
         lbsr  L1F76
         cmpa  #$0D
         beq   L2A97
         pshs  a
         lda   <u0029,u
         clr   <u0029,u
L2A86    pshs  a
         lda   #$20
         lbsr  L3666
         puls  a
         deca
         bne   L2A86
         puls  a
         lbra  L2A0B
L2A97    lda   #$07
         lbsr  L0105
         clr   <u00F1
         clr   <u0029,u
         lbsr  L2DEC
         lbra  L29BE
L2AA7    cmpa  #$F0
         lbeq  L2A1F
         pshs  a
         lda   <u00C5
         lbsr  L3666
         puls  a
         lbra  L2A1F
L2AB9    lda   u000D,u
         cmpa  #$01
         lbeq  L2A3C
         ldx   <u0081
         lda   -$01,x
         cmpa  #$F0
         lbeq  L2A3C
         ldx   u0006,u
         leax  -$01,x
         stx   <u0068
         ldx   ,u
         bra   L2AE3
L2AD5    lda   ,x+
         cmpa  #$20
         lbeq  L2A3C
         cmpa  #$2D
         lbeq  L2A3C
L2AE3    cmpx  <u0068
         bne   L2AD5
         lbsr  L2C78
         lbcs  L29BE
         lbra  L2A3C
L2AF1    cmpa  >L057C,pcr
         lbeq  L2B97
         cmpa  #$0D
         beq   L2B28
         cmpa  >ESCC,pcr
         beq   L2B2D
         cmpa  >L0590,pcr
         beq   L2B57
         cmpa  >L057F,pcr
         bne   L2B15
         lbsr  L347B
         lbra  L29BE
L2B15    lbsr  L46D4
         tstb
         beq   L2B1E
         lbra  L29C1
L2B1E    lbsr  L324D
         lbcc  L29C1
         lbra  L29BE
L2B28    lda   #$F0
         lbra  L2A17
L2B2D    clr   <u00F6
         andcc #$FE
         lbsr  L1871
         lda   [,u]
         cmpa  >L0594,pcr
         beq   L2B44
         tst   <u001D,u
         beq   L2B44
         lbra  L2E51
L2B44    tst   <u0083
         bne   L2B4D
         inc   <u0083
         lbra  L2E55
L2B4D    lda   <u007E
         inca
         sta   <u0074
         sta   <u007C
         lbra  L2E51
L2B57    ldx   <u0081
         lda   -$01,x
         cmpa  #$F0
         beq   L2B6E
         ldx   u0009,u
         cmpx  #$0001
         beq   L2B6E
L2B66    lda   #$1D
         lbsr  L36AB
         lbra  L29C1
L2B6E    ldy   u0006,u
         lbsr  L3B96
         lbsr  L297B
         bcs   L2B66
         stb   <u0058
         tst   <u001D,u
         bne   L2B85
         lda   <u001C,u
         bra   L2B88
L2B85    lda   <u0020,u
L2B88    cmpa  <u0058
         bcs   L2B66
         lda   #$09
         lbsr  L3666
         lbsr  L2DEC
         lbra  L29BE
L2B97    ldx   u0006,u
         lbsr  L0196
         cmpx  ,u
         beq   L2C01
         lda   ,-x
         cmpa  #$09
         bne   L2BB6
         ldy   u0006,u
         tfr   x,d
         subd  ,u
         lbsr  L4D14
         sty   ,u
         lbra  L29BE
L2BB6    cmpa  #$F1
         bne   L2BC4
L2BBA    lda   ,-x
         cmpx  ,u
         beq   L2BCE
         cmpa  #$F1
         beq   L2BBA
L2BC4    cmpx  ,u
         beq   L2BCE
         lda   -$01,x
         bpl   L2BCE
         leax  -$01,x
L2BCE    ldy   u0006,u
         tfr   x,d
         subd  ,u
         lbsr  L4D14
         sty   ,u
L2BDB    lbsr  L2C78
         lbcs  L29BE
         lbsr  L2DEC
         lbcs  L29BE
         ldd   <u0038
         decb
         lbsr  L1742
         lda   >L0592,pcr
         ldb   #$02
         lbsr  L1725
         ldd   <u0038
         decb
         lbsr  L1742
         lbra  L29C1
L2C01    tst   <u0083
         beq   L2C09
         ldx   u0009,u
         bra   L2C0B
L2C09    ldx   u000B,u
L2C0B    leax  -$01,x
         cmpx  #$FFFF
         bne   L2C1C
         ldu   <u001C
         lda   #$07
         lbsr  L36AB
         lbra  L29BC
L2C1C    lbsr  L2F49
         tst   <u0083
         bne   L2C38
         ldy   <u001C
         ldd   $09,y
         subd  $0B,y
         addd  u000B,u
         subd  u0009,u
         beq   L2C38
         lda   #$11
         lbsr  L36AB
         lbra  L29BC
L2C38    tst   u0008,u
         beq   L2C40
         ldu   <u001A
         bra   L2C01
L2C40    lda   [,u]
         cmpa  #$F0
         beq   L2C56
         ldx   <u0081
         leax  -$01,x
         lda   -$01,x
         bpl   L2C50
         leax  -$01,x
L2C50    stx   <u0081
         ldu   <u001C
         bra   L2BDB
L2C56    ldy   <u001C
         ldd   ,y
         std   ,u
         ldd   $02,y
         std   u0002,u
         std   u0004,u
         ldd   $09,y
         std   <u00B5
         ldx   <u0081
         leax  -$01,x
         stx   <u00B1
         leax  >L29BC,pcr
         pshs  x
         leas  -$04,s
         lbra  L2CFE
L2C78    pshs  u,y
         ldy   <u001C
         ldx   $09,y
         stx   <u00B5
L2C81    cmpx  #$0000
         beq   L2CF3
         leax  -$01,x
         beq   L2CF3
         lda   <u0083
         pshs  a
         lda   #$01
         sta   <u0083
         sta   <u00CA
         lbsr  L2F49
         puls  a
         sta   <u0083
         tst   u0008,u
         beq   L2CB3
         ldx   <u0086
         ldy   <u001A
         ldd   $0F,y
         subd  <u0065
         lda   #$38
         beq   L2CF3
         mul
         leax  d,x
         ldx   $09,x
         bra   L2C81
L2CB3    ldx   <u0081
         ldy   <u001C
         ldy   ,y
         bra   L2CC1
L2CBD    lda   ,-x
         sta   ,-y
L2CC1    cmpx  ,u
         bne   L2CBD
         sty   ,u
         stx   <u00B1
         ldd   u0004,u
         pshs  b,a
         lbsr  L23D5
         puls  b,a
         ldx   u0002,u
         ldy   <u001C
         cmpx  ,y
         bne   L2CF7
         cmpd  <u0081
         lbne  L2D66
         ldx   <u00B1
         ldy   ,u
         bra   L2CEE
L2CEA    lda   ,y+
         sta   ,x+
L2CEE    cmpy  u0004,u
         bne   L2CEA
L2CF3    andcc #$FE
L2CF5    puls  pc,u,y
L2CF7    ldy   <u001C
         cmpx  $06,y
         bls   L2D66
L2CFE    ldd   u000F,u
         ldy   <u001C
         cmpd  $0F,y
         beq   L2D1E
         ldy   <u0024
         ldx   <u0022
         ldd   #$015E
         lbsr  L4D27
         ldd   <u0092
         std   <u0094
         ldd   #$FFFF
         sta   <u00A5
         std   <u0092
L2D1E    ldb   u000D,u
         lda   #$05
         mul
         ldx   <u0024
         cmpd  #$015E
         bls   L2D2F
         ldx   <u0026
         bra   L2D31
L2D2F    leax  d,x
L2D31    stx   <u0098
         ldy   <u001C
         ldx   $06,y
         pshs  x
         ldx   <u001A
         ldb   #$38
         clra
         lbsr  L4D27
         puls  x
         ldy   <u001C
         stx   $06,y
         ldx   <u00B1
         stx   <u0081
         ldd   <u00B5
         subd  u0009,u
         pshs  b,a
         ldb   <u0038
         clra
         subd  ,s++
         bcc   L2D5B
         clrb
L2D5B    stb   <u007E
         incb
         stb   <u0074
         stb   <u007C
         orcc  #$01
         bra   L2CF5
L2D66    ldx   <u00B1
         ldy   ,u
         bra   L2D71
L2D6D    lda   ,y+
         sta   ,x+
L2D71    cmpy  u0004,u
         bne   L2D6D
         stx   <u00B7
         stx   <u0081
         ldx   <u001C
         sty   ,x
         ldd   u000F,u
         cmpd  <u0092
         bne   L2DB5
         ldx   <u0024
         stx   <u0068
         lda   #$05
         ldb   u000D,u
         mul
         ldx   <u0022
         leax  d,x
         bra   L2D9B
L2D95    ldd   <u0081
         std   $02,x
         leax  $05,x
L2D9B    cmpx  <u0068
         bcs   L2D95
         ldy   <u001C
         ldd   $0F,y
         subd  <u0065
         lda   #$38
         mul
         ldx   <u0086
         leax  d,x
         ldd   <u0081
         std   $04,x
         ldx   <u0024
         bra   L2DC6
L2DB5    ldx   <u0024
         lda   #$05
         ldb   u000D,u
         mul
         leax  d,x
         bra   L2DC6
L2DC0    ldd   <u0081
         std   $02,x
         leax  $05,x
L2DC6    cmpx  <u0098
         bcs   L2DC0
         ldd   <u00B5
         subd  u0009,u
         pshs  b,a
         ldb   <u0038
         clra
         subd  ,s++
         bcs   L2DE7
         tfr   b,a
         ldb   #$01
         stb   <u0088
         lbsr  L37D6
         lda   <u007E
         inca
         sta   <u0074
         sta   <u007C
L2DE7    orcc  #$01
         lbra  L2CF5
L2DEC    ldd   u0002,u
         pshs  b,a
         lbsr  L23D5
         puls  b,a
         clr   <u006C
         cmpd  u0002,u
         beq   L2DFE
         inc   <u006C
L2DFE    ldd   u0006,u
         cmpd  u0002,u
         bcc   L2E16
         tst   <u006C
         bne   L2E0C
         andcc #$FE
         rts
L2E0C    lda   <u007E
         inca
         sta   <u007C
         sta   <u0074
         orcc  #$01
         rts
L2E16    tst   <u0083
         bne   L2E27
         lda   [,u]
         cmpa  >L0594,pcr
         beq   L2E40
         tst   <u001D,u
         bne   L2E40
L2E27    lda   <u0038
         ldb   #$01
         stb   <u0088
         clr   <u00D2
         lbsr  L37D6
         cmpa  <u003F
         bne   L2E39
         lbsr  L17ED
L2E39    lda   <u0038
         inca
         clrb
         lbsr  L1742
L2E40    lbsr  L25FD
         tst   u0008,u
         bne   L2E16
         lda   <u0038
         sta   <u007E
         bra   L2E0C
         nop
         pshs  y
         fcb   $55 U
L2E51    bsr   L2E59
         bra   L2E8B
L2E55    bsr   L2E59
         bra   L2E7B
L2E59    clr   <u0088
         ldu   <u001C
         lbsr  L2C78
         bsr   L2DEC
         ldx   u0006,u
         cmpx  ,u
         bcs   L2E6D
         cmpx  u0002,u
         bcc   L2E6D
         rts
L2E6D    lda   #$01
         sta   <u00D2
         clr   <u0088
         clr   <u0085
         lda   <u007E
         lbsr  L37D6
         rts
L2E7B    ldu   <u001C
         lbsr  L3773
         lda   <u007E
         sta   <u0038
         inca
         sta   <u0074
         sta   <u007C
         clr   <u00A8
L2E8B    ldu   <u001C
         ldx   u0006,u
         cmpx  ,u
         bcs   L2E97
         cmpx  u0002,u
         bcs   L2E9B
L2E97    ldx   ,u
         stx   u0006,u
L2E9B    lda   #$01
         sta   <u0088
         clr   <u00D2
         lda   <u007E
         lbsr  L37D6
L2EA6    ldu   <u001C
         lbsr  L30EB
         lda   <u0038
         sta   <u007E
         lds   <u0018
         lbsr  L1F76
         lbsr  L0196
L2EB8    lbsr  L324D
         bcs   L2E8B
         lbsr  L1F92
         ldu   <u001C
         leax  >CURUC,pcr
         leay  >L2EF2,pcr
         bsr   L2ED7
         bcc   L2ED5
L2ECE    lda   #$03
         lbsr  L36AB
         bra   L2EA6
L2ED5    jmp   ,x
L2ED7    cmpa  ,x+
         beq   L2EE4
         leay  $02,y
         tst   ,y
         bne   L2ED7
         orcc  #$01
         rts
L2EE4    pshs  a
         leax  >0,pcr
         ldd   ,y
         leax  d,x
         andcc #$FE
         puls  pc,a

L2EF2  fcb $53,$5C,$54,$5D,$53,$F0,$54,$A8,$55,$1A
       fcb $55,$45,$52,$76,$52,$DA,$49,$5E,$49,$EE
       fcb $29,$B1,$48,$6A,$48,$F9,$47,$EF,$3E,$61
       fcb $48,$AD,$56,$15,$55,$A4,$54,$EC,$56,$BA
       fcb $49,$4C,$56,$9B,$2E,$4F,$57,$98,$57,$AD
       fcb $57,$BA,$53,$21,$53,$3F,$58,$E5,$60,$07
       fcb $46,$9E,$46,$9E,$46,$9E,$46,$9E,$46,$9E
       fcb $46,$9E,$47,$C8,$54,$5D,$54,$A8,$53,$5C,$53,$F0,$54,$5D,$52,$DA,$00

L2F49    stx   <u007F
         ldu   <u001A
         ldy   <u001C
         ldd   $0F,y
         subd  <u0065
         lda   #$38
         mul
         ldy   <u0086
         leay  d,y
L2F5C    ldd   <u007F
         tst   <u0083
         beq   L2F67
         cmpd  $09,y
         bra   L2F6A
L2F67    cmpd  $0B,y
L2F6A    bcc   L2F71
         leay  <-$38,y
         bra   L2F5C
L2F71    tfr   y,x
         ldy   <u001A
         ldd   #$0038
         lbsr  L4D27
         ldd   u000F,u
         cmpd  <u0092
         beq   L2FBC
         cmpd  <u0094
         beq   L2FCB
L2F88    lbsr  L23D5
L2F8B    ldd   <u0081
         cmpd  u0004,u
         bcc   L2F9A
         std   u0004,u
         tst   u0008,u
         bne   L2F9A
         std   u0002,u
L2F9A    bsr   L2FAE
         beq   L2FEA
         tst   <u00CA
         beq   L2FA9
         ldd   u0004,u
         cmpd  <u0081
         bcc   L2FEA
L2FA9    lbsr  L25FD
         bra   L2F8B
L2FAE    ldd   <u007F
         tst   <u0083
         beq   L2FB8
         cmpd  u0009,u
         rts
L2FB8    cmpd  u000B,u
         rts
L2FBC    lbsr  L1F9D
         bcs   L2FBC
         ldy   <u0022
         sty   <u00AD
         ldx   <u0024
         bra   L2FD3
L2FCB    ldy   <u0024
         sty   <u00AD
         ldx   <u0026
L2FD3    stx   <u00AF
L2FD5    bsr   L2FAE
         bne   L2FED
         tst   <u0083
         bne   L2FEA
         tst   <u001D,u
         bne   L2FED
         lda   [,u]
         cmpa  >L0594,pcr
         beq   L2FED
L2FEA    clr   <u00CA
         rts
L2FED    tst   <u00CA
         beq   L2FF8
         ldd   u0004,u
         cmpd  <u0081
         bcc   L2FEA
L2FF8    ldy   <u00AD
         leay  $05,y
         sty   <u00AD
         cmpy  <u00AF
         beq   L2F88
         tst   $04,y
         beq   L3011
         lbsr  L23D5
         lbsr  L25FD
         bra   L2FD5
L3011    lbsr  L275F
         ldy   <u00AD
         ldx   ,y
         stx   ,u
         ldd   $02,y
         std   u0004,u
         lda   $04,y
         sta   u0008,u
         bra   L2FD5
L3025    pshs  u
         ldu   <u001A
         ldy   <u001C
         ldd   $0F,y
         subd  u000F,u
         beq   L309C
         cmpd  #$0001
         beq   L3081
         ldd   u000F,u
         subd  <u0065
         lda   #$38
         mul
         ldx   <u0086
         leax  d,x
         ldy   <u0020
         ldd   #$0038
         lbsr  L4D27
         ldx   <u0024
         stx   <u0098
         ldx   u000F,u
         stx   <u0094
         ldu   <u0020
         bra   L3073
L3058    ldx   <u0098
         ldd   ,u
         std   ,x
         ldd   u0004,u
         std   $02,x
         lda   u0008,u
         sta   $04,x
         leax  $05,x
         stx   <u0098
         ldx   <u0026
         cmpx  <u0098
         beq   L307D
         lbsr  L25FD
L3073    ldd   u0009,u
         ldy   <u001A
         cmpd  $09,y
         bne   L3058
L307D    ldu   <u001A
         bra   L3095
L3081    lbsr  L1F9D
         bcs   L3081
         ldy   <u0024
         ldd   #$015E
         ldx   <u0022
         lbsr  L4D27
         ldd   <u0092
         std   <u0094
L3095    ldd   #$FFFF
         sta   <u00A5
         std   <u0092
L309C    ldb   u000D,u
         lda   #$05
         mul
         ldx   <u0024
         cmpd  #$015E
         bls   L30AC
         ldd   #$015E
L30AC    leax  d,x
         stx   <u0098
         tst   u0008,u
         beq   L30B8
         ldd   u0004,u
         bra   L30BA
L30B8    ldd   ,u
L30BA    ldx   <u0081
         stx   <u0068
         std   <u0081
         ldd   <u0068
         subd  <u0081
         ldy   <u001C
         ldy   ,y
         lbsr  L4D14
         tst   u0008,u
         beq   L30D6
         sty   u0004,u
         bra   L30D9
L30D6    sty   ,u
L30D9    ldx   <u001A
         ldy   <u001C
         ldd   #$0038
         lbsr  L4D27
         ldu   <u001C
         lbsr  L23D5
         puls  pc,u
L30EB    tst   >L0015,pcr
         bne   L30F2
         rts
L30F2    pshs  y,x,b,a
         ldd   <u0038
         pshs  b,a
         lda   <u003F
         adda  #$01
         clrb
         lbsr  L1742
         ldb   #$0C
         lbsr  L1789
         ldb   <u00D1
         clra
         lbsr  L3200
         ldx   >L31F2,pcr
         lbsr  L3E39
         ldx   <u002E
         leax  $02,x
         lbsr  L3E54
         ldx   >L31F4,pcr
         lbsr  L3E39
         ldb   TTYSTATE,u
         clra
         lbsr  L3200
         ldx   <u002E
         leax  $02,x
         lbsr  L3E54
         ldx   >L31F6,pcr
         lbsr  L3E39
         ldd   u000F,u
         addd  #$0001
         lbsr  L3200
         ldx   <u002E
         leax  $02,x
         lbsr  L3E54
         tst   <u00F6
         beq   L3150
         ldx   >L31FA,pcr
         lbsr  L3E39
         bra   L3164
L3150    tst   <u00F7
         beq   L315D
         ldx   >L31FC,pcr
         lbsr  L3E39
         bra   L3164
L315D    ldx   >L31F8,pcr
         lbsr  L3E39
L3164    puls  b,a
         lbsr  L1742
         puls  pc,y,x,b,a

L316B fcc "   Column:"
      fcb 0
L3176 fcc "   Line:"
 fcb 0
L317F fcc "   Page #:"
 fcb 0
L318A fcc "     ESCAPE MODE         "
 fcb 0
L31A4 fcc "     INSERT MODE         "
 fcb 0
L31BE fcc "     OVERWRITE MODE      "
 fcb 0
L31D8 fcc "     MULTI-COLUMN MODE   "
 fcb 0

L31F2 fdb L316B
L31F4 fdb L3176
L31F6 fdb L317F
L31F8 fdb L318A
L31FA fdb L31A4
L31FC fdb L31BE
L31FE fdb L31D8

L3200    pshs  y,x,b,a
         ldx   <u002E
         clr   $05,x
         leay  >L3243,pcr
         pshs  a
         lda   #$05
         sta   <u006D
L3210    puls  a
         clr   <u006C
L3214    subd  ,y
         bcs   L321C
         inc   <u006C
         bra   L3214
L321C    addd  ,y
         pshs  a
         lda   <u006C
         adda  #$30
         sta   ,x+
         puls  a
         leay  $02,y
         clr   <u006C
         dec   <u006D
         bne   L3214
         ldx   <u002E
         ldb   #$04
L3234    lda   #$30
         cmpa  ,x
L3238    bne   L3241
         lda   #$20
         sta   ,x+
         decb
         bne   L3234
L3241    puls  pc,y,x,b,a

L3243    fdb  10000,1000,100,10,1

* Check for control codes
L324D    pshs  y,x,b,a
         leax  >L0581,pcr
         leay  >L3276,pcr
         lbsr  L2ED7
         bcs   L3264
         jsr   ,x
         bcs   L3268
         orcc  #$01
L3262    puls  pc,y,x,b,a
L3264    andcc #$FE
         bra   L3262
L3268    lbsr  L3773
         lda   <u007E
         inca
         sta   <u007C
         sta   <u0074
         orcc  #$01
L3274    bra   L3262
L3276    puls  u,a,cc
         pshs  u,y,x,dp,a,cc
         pshs  pc,y,x,b,a,cc
         leas  [>L653E,pcr]
         leas  [<$32,x]
         andb  #$35
         orb   -$0A,y
         jmp   <u0032
         subd  <u0035
         dec   >$35D2
         pshs  u,y,dp,cc
         fcb   $5E ^
         fcb   $6B k
         neg   <u0003
         rorb
         andcc #$FE
         rts
         com   <u0084
         orcc  #$01
         rts
         tst   <u0083
         beq   L32B7
         clra
         tst   <u001D,u
         bne   L32AF
         ldb   [,u]
         cmpb  >L0594,pcr
         bne   L32B9
L32AF    lda   #$0F
         lbsr  L36AB
         andcc #$FE
         rts
L32B7    lda   #$01
L32B9    sta   <u0083
         orcc  #$01
         rts
         lbsr  L36B6
         andcc #$FE
         rts
         lda   <u0040
         inca
         sta   <u0074
         lbsr  L17D7
         ldd   #$0019
         lbsr  L1742
         ldx   >L05C4,pcr
         lbsr  L3E39
         ldd   #$0200
         lbsr  L1742
         ldx   >L05C8,pcr
         lbsr  L3E39
         tst   <u0075
         bne   L32F0
         ldx   >L05CC,pcr
         bra   L32F7
L32F0    ldx   <u002A
         lbsr  L3E54
         bra   L32FA
L32F7    lbsr  L3E39
L32FA    ldd   #$0500
         lbsr  L1742
         ldx   >L05CA,pcr
         lbsr  L3E39
         tst   <u0075
         bne   L3311
         ldx   >L05CC,pcr
         bra   L3318
L3311    ldx   <u002C
         lbsr  L3E54
         bra   L331B
L3318    lbsr  L3E39
L331B    ldd   #$0300
         lbsr  L1742
         ldx   >L05CE,pcr
         lbsr  L3E39
         tst   <u0063
         beq   L3332
         ldx   >L05D0,pcr
         bra   L3336
L3332    ldx   >L05D2,pcr
L3336    lbsr  L3E39
         ldd   #$0600
         lbsr  L1742
         ldx   >L05CE,pcr
         lbsr  L3E39
         tst   <u0064
         beq   L3350
         ldx   >L05D0,pcr
         bra   L3354
L3350    ldx   >L05D2,pcr
L3354    lbsr  L3E39
         ldy   <u0016
         ldd   u000F,u
         addd  #$0001
         std   ,y++
         ldd   <u0011,u
         std   ,y++
         ldb   <u002C,u
         clra
         std   ,y++
         ldb   <u002B,u
         std   ,y++
         ldb   <u0019,u
         std   ,y++
         ldb   <u001A,u
         std   ,y++
         ldb   <u0024,u
         incb
         std   ,y++
         ldb   <u002E,u
         std   ,y++
         ldb   <u001C,u
         std   ,y++
         ldb   <u0020,u
         std   ,y++
         ldb   <u0017,u
         std   ,y++
         ldb   <u0018,u
         std   ,y++
         ldb   <u002A,u
         std   ,y++
         ldb   <u002D,u
         std   ,y++
         ldb   <u0035,u
         std   ,y++
         ldb   <u0036,u
         std   ,y++
         ldb   <u0037,u
         std   ,y++
         lda   #$FF
         ldb   #$59
         tst   <u0026,u
         bne   L33BE
         ldb   #$4E
L33BE    std   ,y++
         ldb   #$59
         tst   <u0030,u
         bne   L33C9
         ldb   #$4E
L33C9    std   ,y++
         ldb   <u0031,u
         std   ,y++
         ldb   <u0032,u
         std   ,y++
         ldb   <u0033,u
         std   ,y++
         ldd   ,u
         subd  <u0081
         std   ,y++
         ldy   <u0016
         ldd   >L05C6,pcr
         leax  >0,pcr
         leax  d,x
         clr   <u0054
         lda   #$08
         sta   <u0053
         bsr   L3411
         lda   #$2B
         sta   <u0054
         lda   #$08
         sta   <u0053
         bsr   L3411
L33FF    lbsr  L1F76
         cmpa  >ESCC,pcr
         beq   L340E
         cmpa  >L0587,pcr
         bne   L33FF
L340E    orcc  #$01
         rts
L3411    lda   #$10
         sta   <u0052
L3415    dec   <u0052
         beq   L3468
         ldd   <u0053
         lbsr  L1742
         inc   <u0053
         tst   ,x+
         beq   L3415
         leax  -$01,x
         lbsr  L3E54
         ldd   ,y++
         cmpa  #$FF
         beq   L3454
         lbsr  L3200
         pshs  x
         ldx   <u002E
         lda   $01,x
         cmpa  #$20
         bne   L3445
         leax  $02,x
         ldd   <u0053
         deca
         addb  #$1F
         bra   L344A
L3445    ldd   <u0053
         deca
         addb  #$1D
L344A    lbsr  L1742
         lbsr  L3E54
         puls  x
         bra   L3415
L3454    tstb
         beq   L3415
         pshs  b
         ldd   <u0053
         deca
         addb  #$21
         lbsr  L1742
         puls  a
         lbsr  L1709
         bra   L3415
L3468    rts
         tst   <u00A9
         bne   L3489
         ldy   u0006,u
         lda   ,-y
         bne   L3489
         tfr   y,x
         leay  $01,y
         lbra  L350F
L347B    tst   <u00A9
         bne   L3489
         ldy   u0006,u
         leay  $01,y
         cmpy  <u0077
         bcs   L3491
L3489    lda   #$12
         lbsr  L36AB
         andcc #$FE
         rts
L3491    lda   [,u]
         cmpa  >L0594,pcr
         beq   L349E
         tst   <u001D,u
         beq   L34A0
L349E    inc   <u007C
L34A0    ldx   u0006,u
         lda   ,x
         cmpa  #$09
         beq   L34B3
         tsta
         bpl   L34B5
         cmpa  #$F0
         beq   L34B5
         cmpa  #$F1
         beq   L34B5
L34B3    leay  $01,y
L34B5    bra   L350F
         tst   <u00A9
         bne   L3489
         ldx   u0006,u
         lda   ,x
         cmpa  #$F0
         beq   L347B
         lda   [,u]
         cmpa  >L0594,pcr
         beq   L34D0
         tst   <u001D,u
         beq   L34D2
L34D0    inc   <u007C
L34D2    cmpx  ,u
         beq   L34EC
         lda   ,x
         bmi   L34E6
         cmpa  #$20
         beq   L34EA
         cmpa  #$09
         beq   L34EA
L34E2    leax  -$01,x
         bra   L34D2
L34E6    cmpa  #$F0
         bne   L34E2
L34EA    leax  $01,x
L34EC    ldy   u0006,u
L34EF    lda   ,y+
         cmpa  #$20
         beq   L34FF
         cmpa  #$09
         beq   L3509
         cmpa  #$F0
         bne   L34EF
         leay  -$01,y
L34FF    lda   ,y+
         cmpa  #$20
         beq   L34FF
         leay  -$01,y
         bra   L350F
L3509    lda   ,-y
         cmpa  #$09
         bne   L3509
L350F    sty   u0006,u
L3512    cmpx  ,u
         beq   L351C
         lda   ,-x
         sta   ,-y
         bra   L3512
L351C    sty   ,u
         lbsr  L2C78
         lbsr  L2DEC
         tst   <u007C
         beq   L3530
L3529    lda   <u007E
         inca
         sta   <u007C
         sta   <u0074
L3530    ldy   u0006,u
         lda   ,y
         cmpa  #$09
         bne   L3540
         leay  $01,y
         sty   u0006,u
         bra   L3530
L3540    andcc #$FE
         rts
         ldx   <u0081
         lda   -$01,x
         cmpa  #$F0
         beq   L355B
         ldd   u0009,u
         cmpd  #$0001
         beq   L355B
L3553    lda   #$14
         lbsr  L36AB
         andcc #$FE
         rts
L355B    ldx   u0002,u
         lda   ,-x
         cmpa  #$F0
         bne   L3553
         ldy   ,u
         stx   ,u
         stx   u0006,u
         lda   ,y
         cmpa  >L0594,pcr
         beq   L3529
         tst   <u001D,u
         bne   L3529
         andcc #$FE
         rts
         lda   #$FF
         sta   <u0074
         lbsr  L17D7
         ldb   #$07
         ldx   >L0648,pcr
         lbsr  L5A85
L358A    tsta
         beq   L35CF
         leax  >L064A,pcr
         deca
         lsla
         leax  a,x
         ldd   ,x
         leax  >0,pcr
         leax  d,x
         lbsr  L0259
         bcs   L35B8
         lbsr  L17D7
L35A5    lbsr  L0342
         bcs   L35C6
         cmpa  #$0D
         bne   L35B3
         lbsr  L0105
         lda   #$0A
L35B3    lbsr  L0105
         bra   L35A5
L35B8    ldd   #$0000
         lbsr  L1742
         lbsr  L0324
         lbsr  L5B12
         bra   L358A
L35C6    lbsr  L02CD
         lbsr  L0196
         lbsr  L1F76
L35CF    orcc  #$01
         rts
         lda   <u00F2
         cmpa  #$01
         beq   L35E0
         lda   #$01
         sta   <u00F2
         lda   #$25
         bra   L35E6
L35E0    lda   #$00
         sta   <u00F2
         lda   #$26
L35E6    lbsr  L36AB
         rts
         ldx   u0006,u
         lda   ,x
         cmpa  #$F1
         beq   L360B
         cmpx  ,u
         beq   L360B
         lda   -$01,x
         cmpa  #$F1
         beq   L360B
         cmpa  #$20
         beq   L360B
         lda   #$F1
         lbsr  L3666
         lbsr  L2C78
         lbsr  L2DEC
L360B    andcc #$FE
         rts
         ldb   <u0039
         addb  <u00AA
         beq   L362B
         ldx   <u0028
         clra
L3617    cmpb  a,x
         bcs   L362C
         beq   L362B
         tst   a,x
         beq   L362C
         inca
         cmpa  #$16
         bne   L3617
         lda   #$1B
         lbsr  L36AB
L362B    rts
L362C    sta   <u006C
         ldb   #$15
         bra   L3639
L3632    decb
         lda   b,x
         incb
         sta   b,x
         decb
L3639    cmpb  <u006C
         bne   L3632
         lda   <u0039
         adda  <u00AA
         sta   b,x
         rts
         ldx   <u0028
         clrb
         lda   <u0039
         adda  <u00AA
L364B    cmpa  b,x
         beq   L3655
         incb
         cmpb  #$16
         bne   L364B
L3654    rts
L3655    clr   b,x
L3657    incb
         cmpb  #$16
         beq   L3654
         lda   b,x
         beq   L3654
         decb
         sta   b,x
         incb
         bra   L3657
L3666    pshs  y,a
         ldd   ,u
         subd  <u0081
         cmpd  #$00C8
         bhi   L3688
         cmpd  #$000A
         bcs   L367F
         lda   #$19
         lbsr  L36AB
         bra   L3688
L367F    lda   #$1A
         lbsr  L36AB
         orcc  #$01
         puls  pc,y,a
L3688    ldd   u0006,u
         subd  ,u
         ldx   ,u
         leay  -$01,x
         sty   ,u
         lbsr  L4D27
         puls  a
         sta   ,y
         andcc #$FE
         puls  pc,y

L369E    sta   <u006C
         clra
L36A1    subb  <u006C
         bcs   L36A8
         inca
         bra   L36A1
L36A8    addb  <u006C
         rts
L36AB    pshs  a
         sta   <u008C
         lda   #$07
         lbsr  L0105
         puls  pc,a
L36B6    pshs  x,b,a
         clrb
         lda   <u0038
         lbsr  L1742
         lda   #$2A
         lbsr  L1709
         lbsr  L1709
         lbsr  L1709
         lda   #$20
         lbsr  L1709
         ldd   >L05BC,pcr
         leax  >0,pcr
         leax  d,x
         lda   ,x+
L36DA    cmpa  <u008C
         beq   L36E8
L36DE    lda   ,x+
         bne   L36DE
         lda   ,x+
         bne   L36DA
         bra   L3714
L36E8    lbsr  L3E54
L36EB    lda   #$20
         lbsr  L1709
         lbsr  L1709
         lda   #$2A
         ldb   <u0040
L36F7    lbsr  L1709
         cmpb  <u0039
         bne   L36F7
         lbsr  L1709
L3701    lbsr  L1F76
         cmpa  >L0585,pcr
         beq   L3710
         cmpa  >ESCC,pcr
         bne   L3701
L3710    orcc  #$01
         puls  pc,x,b,a
L3714    ldx   >L05BE,pcr
         lbsr  L3E39
         bra   L36EB
L371D    pshs  u,y,x,b,a
         tst   <u007C
         beq   L3730
         clr   <u007C
         ldx   <u001C
         ldy   <u001E
         ldd   #$0038
         lbsr  L4D27
L3730    lda   <u0074
         cmpa  <u003F
         bls   L373F
         lda   <u003F
         inca
         sta   <u0074
         andcc #$FE
         puls  pc,u,y,x,b,a
L373F    ldu   <u001E
L3741    lbsr  L25FD
         bcs   L376C
         tst   u0008,u
         beq   L3759
L374A    lda   [,u]
         cmpa  >L0594,pcr
         beq   L3741
         tst   <u001D,u
         bne   L3741
         bra   L375D
L3759    tst   <u0083
         beq   L374A
L375D    lda   #$01
         sta   <u0088
         lda   <u0074
         lbsr  L37D6
L3766    inc   <u0074
         orcc  #$01
         puls  pc,u,y,x,b,a
L376C    lda   <u0074
         lbsr  L1882
         bra   L3766
L3773    pshs  u,y,x,b,a
         lda   #$01
         sta   <u0088
         tst   <u007E
         beq   L37D4
         tst   <u0083
         bne   L3785
         ldd   u000B,u
         bra   L3787
L3785    ldd   u0009,u
L3787    subb  <u007E
         sbca  #$00
         bcc   L3795
         addb  <u007E
         stb   <u007E
         beq   L37D4
         clra
         clrb
L3795    tfr   d,x
         lbsr  L2F49
         ldu   <u001A
         lbsr  L23D5
         clr   <u0054
         bra   L37BD
L37A3    lbsr  L25FD
         tst   u0008,u
         beq   L37B9
L37AA    lda   [,u]
         cmpa  >L0594,pcr
         beq   L37A3
         tst   <u001D,u
         bne   L37A3
         bra   L37BD
L37B9    tst   <u0083
         beq   L37AA
L37BD    ldd   <u0081
         cmpd  u0002,u
         bhi   L37C6
         std   u0002,u
L37C6    lda   <u0054
         lbsr  L37D6
         lda   <u0054
         inca
         sta   <u0054
         cmpa  <u007E
         bne   L37A3
L37D4    puls  pc,u,y,x,b,a
L37D6    pshs  y,x,b,a
         clr   <u00AB
         lbsr  L3B7C
         tst   <u0060
         bne   L37EF
         lbsr  L012D
         lbsr  L17C7
         ldx   <u0038
         stx   <u00D4
         clrb
         lbsr  L1742
L37EF    clr   <u00DF
         ldy   ,u
         beq   L37FE
         lda   ,y
         cmpa  >L0594,pcr
         beq   L3832
L37FE    tst   u0008,u
         beq   L381A
         clr   <u005C
         tst   u000D,u
         lbeq  L39A9
         tst   <u0021,u
         lbne  L3890
         tst   <u0022,u
         lbne  L3939
         bra   L3832
L381A    tst   <u0025,u
         lbne  L3890
         tst   <u0027,u
         lbne  L3939
         tst   <u0026,u
         lbne  L3893
L382F    lbsr  L3986
L3832    lda   ,y
         cmpa  #$09
         beq   L387D
         tsta
         bpl   L3854
         cmpa  #$F0
         beq   L3864
         cmpa  #$F1
         beq   L384E
         cmpa  #$F2
         beq   L3857
         lbsr  L2022
         leay  $01,y
         bra   L3857
L384E    leax  $01,y
         cmpx  u0002,u
         bne   L3857
L3854    lbsr  L2022
L3857    leay  $01,y
         cmpy  u0002,u
         bcs   L3832
L385E    clra
         lbsr  L2022
         bra   L3867
L3864    lbsr  L2022
L3867    tst   <u0060
         bne   L387B
         cmpu  <u001C
         beq   L3875
         ldd   <u00D4
         lbsr  L1742
L3875    lbsr  L17CF
         lbsr  L012E
L387B    puls  pc,y,x,b,a
L387D    lbsr  L285C
         bcs   L388E
L3882    lda   #$A0
         pshs  b
         lbsr  L2022
         puls  b
         decb
         bne   L3882
L388E    bra   L3857
L3890    lbra  L393C
L3893    ldx   u0002,u
         lda   ,-x
         cmpa  #$F0
         lbeq  L382F
         lbsr  L3BBC
         lbsr  L3986
         lbsr  L3D0B
         tst   <u00A0
         beq   L3832
         lda   #$33
         lbsr  L3CC5
         lda   <u009D
         adda  <u00A6
         mul
         clr   <u00DB
         subd  <u00DD
         lbcs  L3832
         lbsr  L3D67
L38BF    cmpy  u0002,u
         lbeq  L385E
         lda   ,y
         cmpa  #$20
         bne   L38D7
         lda   #$A0
         lbsr  L2022
         leay  $01,y
         bra   L38BF
L38D5    leay  $01,y
L38D7    cmpy  u0002,u
         lbeq  L385E
         lda   ,y
         bmi   L390F
         cmpa  #$09
         bcs   L390F
         beq   L38FC
         cmpa  #$20
         bne   L38F7
L38EC    leax  $01,y
         cmpx  u0002,u
         beq   L38D5
         lbsr  L3DEA
         bra   L38D5
L38F7    lbsr  L2022
         bra   L38D5
L38FC    lbsr  L285C
         bcs   L390D
L3901    lda   #$A0
         pshs  b
         lbsr  L2022
         puls  b
         decb
         bne   L3901
L390D    bra   L38D5
L390F    cmpa  #$F0
         lbeq  L3864
         cmpa  #$F1
         beq   L392C
         lda   #$20
         cmpa  $01,y
         bne   L3923
         leay  $01,y
         bra   L38EC
L3923    lda   #$20
         lbsr  L2022
         leay  $01,y
         bra   L38D5
L392C    ldx   u0002,u
         leax  -$01,x
         pshs  x
         cmpy  ,s++
         bne   L38D5
         bra   L38F7
L3939    lbsr  L3BBC
L393C    lbsr  L3D0B
         ldy   ,u
         lda   #$33
         lbsr  L3CC5
         lda   <u00A6
         mul
         addd  #$0008
         subd  <u00DD
         lbcs  L382F
         tst   u0008,u
         beq   L395E
         tst   <u0021,u
         beq   L396F
         bra   L3963
L395E    tst   <u0025,u
         beq   L396F
L3963    pshs  b,a
         ldd   #$0002
         std   <u006E
         puls  b,a
         lbsr  L3CEC
L396F    std   <u00DD
         lda   #$20
         lbsr  L3CC5
         clra
         std   <u006E
         ldd   <u00DD
         lbsr  L3CEC
         clr   <u00DB
         lbsr  L399B
         lbra  L3832
L3986    tst   u0008,u
         beq   L398E
         clrb
         stb   <u006D
         rts
L398E    ldb   <u0029,u
         addb  <u002A,u
         stb   <u006D
         bsr   L399B
         ldb   <u006D
         rts
L399B    stb   <u00E1
         beq   L39A8
L399F    lda   #$A0
         lbsr  L2022
         dec   <u00E1
         bne   L399F
L39A8    rts
L39A9    ldd   u000F,u
         addd  #$0001
         lbsr  L3200
         ldb   <u0040
         subb  #$09
         asrb
         lda   #$2D
L39B8    lbsr  L1709
         decb
         bne   L39B8
         lda   #$20
         lbsr  L1709
         ldx   >L05D4,pcr
         lbsr  L3E39
         ldx   <u002E
         leax  $02,x
         lbsr  L3E54
         lda   #$20
         lbsr  L1709
         lda   #$2D
L39D8    lbsr  L1709
         ldb   <u0039
         cmpb  <u0040
         bcs   L39D8
         lbsr  L1709
         lbra  L3867
L39E7    pshs  y
         lbsr  L012D
         lbsr  L3B7C
         lbsr  L3BBC
         lbsr  L17C7
         clrb
         lda   <u007E
         lbsr  L1742
         ldy   u0006,u
         lbsr  L3B96
         stb   <u00AC
         ldy   ,u
         clr   <u006C
         ldb   <u0040
         decb
         tst   <u001D,u
         bne   L3A22
         subb  <u0029,u
         bpl   L3A1B
         cmpb  #$C8
         bcs   L3A1B
         inc   <u006C
L3A1B    subb  <u002A,u
         bcc   L3A22
         inc   <u006C
L3A22    subb  <u00AC
         bcc   L3A4B
         clra
L3A27    adda  #$19
         addb  #$19
         bcc   L3A27
         inca
         tst   <u001D,u
         bne   L3A41
         suba  <u0029,u
         bpl   L3A3C
         cmpa  #$C8
         bhi   L3A60
L3A3C    suba  <u002A,u
         bcs   L3A60
L3A41    deca
         beq   L3A60
         tst   ,y+
         bpl   L3A41
         inca
         bra   L3A41
L3A4B    tst   <u001D,u
         bne   L3A60
         ldb   <u002A,u
         addb  <u0029,u
         beq   L3A60
         lda   #$20
L3A5A    lbsr  L1709
         decb
         bne   L3A5A
L3A60    cmpy  u0006,u
         bcc   L3A94
         lda   ,y
         cmpa  #$09
         bne   L3A7B
         lbsr  L285C
         bcs   L3A90
L3A70    tstb
         beq   L3A90
         lda   #$20
         lbsr  L1709
         decb
         bra   L3A70
L3A7B    tsta
         bpl   L3A8D
         cmpa  #$F2
         beq   L3A90
         cmpa  #$F1
         beq   L3A90
         lbsr  L2361
         leay  $02,y
         bra   L3A60
L3A8D    lbsr  L2361
L3A90    leay  $01,y
         bra   L3A60
L3A94    ldb   <u0039
         stb   <u006D
         tst   <u0030,u
         bra   L3ACA
         lda   #$33
         lbsr  L3CC5
         lda   <u00A6
         mul
         pshs  b,a
         lbsr  L3D0B
         puls  b,a
         subd  <u00DD
         tstb
         bmi   L3AC5
         pshs  b,a
         lda   >L0592,pcr
         lbsr  L3CC5
         clra
         std   <u006E
         puls  b,a
         lbsr  L3CEC
         tstb
         bcc   L3AC6
L3AC5    clrb
L3AC6    stb   <u009D
         bra   L3AD4
L3ACA    ldb   <u00A6
         addb  <u009D
         subb  <u009E
         ble   L3AEC
         stb   <u009D
L3AD4    lda   <u0039
         cmpa  <u0040
         lbcc  L3B64
         lda   >L0592,pcr
         pshs  b
         ldb   #$02
         lbsr  L1725
         puls  b
         decb
         bne   L3AD4
L3AEC    ldb   <u0040
         cmpb  <u0039
         bls   L3B64
         cmpy  u0002,u
         bcc   L3B37
         lda   ,y
         cmpa  #$09
         bne   L3B11
         lbsr  L285C
         bcs   L3B2A
         subb  <u009D
         clr   <u009D
L3B06    tstb
         ble   L3B2A
         lda   #$20
         lbsr  L1709
         decb
         bra   L3B06
L3B11    tsta
         bpl   L3B27
         cmpa  #$F2
         beq   L3B2A
         cmpa  #$F1
         beq   L3B2E
         cmpa  #$F0
         beq   L3B37
         lbsr  L2361
         leay  $02,y
         bra   L3AEC
L3B27    lbsr  L2361
L3B2A    leay  $01,y
         bra   L3AEC
L3B2E    leax  $01,y
         cmpx  u0002,u
         bne   L3B2A
         lbsr  L2361
L3B37    ldb   <u0040
         lda   #$20
L3B3B    cmpb  <u0039
         bls   L3B44
         lbsr  L1709
         bra   L3B3B
L3B44    ldy   u0002,u
         ldb   -$01,y
         cmpb  #$F0
         bne   L3B51
         lda   >L0593,pcr
L3B51    lbsr  L1709
L3B54    lda   <u0038
         ldb   <u006D
         lbsr  L1742
         lbsr  L17CF
         lbsr  L012E
         puls  pc,y
         rts
L3B64    cmpy  u0002,u
         bcc   L3B44
         lda   ,y
         cmpa  #$F1
         bne   L3B77
         leax  $01,y
         cmpx  u0002,u
         beq   L3B77
         leay  $01,y
L3B77    lbsr  L2361
         bra   L3B54
L3B7C    tst   u0008,u
         beq   L3B85
L3B80    ldb   <u0020,u
         bra   L3B93
L3B85    tst   <u001D,u
         bne   L3B80
         ldb   <u001C,u
         subb  <u002A,u
         subb  <u0029,u
L3B93    stb   <u00A6
         rts
L3B96    sty   <u006A
         lda   <u009E
         ldb   <u00A0
         pshs  x,b,a
         lda   <u009C
         ldb   <u009D
         pshs  b,a
         ldy   ,u
         bsr   L3BD0
         puls  b,a
         sta   <u009C
         stb   <u009D
         ldb   <u009E
         puls  a
         sta   <u009E
         puls  a
         sta   <u00A0
         puls  pc,x
L3BBC    ldy   u0002,u
         sty   <u006A
         ldy   ,u
         bsr   L3BD0
         ldy   ,u
         rts
         sty   <u006A
         tfr   x,y
L3BD0    clr   <u009E
         clr   <u00A0
         clr   <u009C
         clr   <u009D
         clrb
         pshs  b
L3BDB    cmpy  <u006A
         lbeq  L3C80
         lda   ,y+
         bmi   L3BDB
         cmpa  <u0031,u
         lbeq  L3C8C
         cmpa  #$09
         bne   L3C15
         ldb   <u009E
         lbsr  L297B
         tst   <u00F3
         beq   L3C0F
         pshs  x
         stb   <u009E
         tfr   y,x
         lbsr  L28FD
         puls  x
         pshs  b
         ldb   <u009E
         subb  ,s+
         tstb
         bpl   L3C0F
         clrb
L3C0F    stb   <u009E
         stb   <u009C
         bra   L3BDB
L3C15    inc   <u009E
         cmpa  #$20
         bne   L3C1F
         inc   <u009C
         bra   L3BDB
L3C1F    inc   ,s
L3C21    cmpy  <u006A
         bcc   L3C80
         lda   ,y+
         bpl   L3C37
         cmpa  #$F1
         bne   L3C21
         cmpy  <u006A
         bne   L3C21
         inc   <u009E
         bra   L3C80
L3C37    cmpa  #$20
         beq   L3C70
         cmpa  #$09
         bne   L3C63
         ldb   <u009E
         lbsr  L297B
         tst   <u00F3
         beq   L3C59
         pshs  x
         stb   <u009E
         tfr   y,x
         lbsr  L28FD
         puls  x
         pshs  b
         ldb   <u009E
         subb  ,s+
L3C59    clr   <u009D
         clr   <u00A0
         stb   <u009E
         clr   ,s
         bra   L3C21
L3C63    cmpa  <u0031,u
         beq   L3C8C
         inc   ,s
         inc   <u009E
         clr   <u009D
         bra   L3C21
L3C70    inc   <u009D
         inc   <u009E
         tst   ,s
         bne   L3C7C
         clr   ,s
         bra   L3C21
L3C7C    inc   <u00A0
         bra   L3C21
L3C80    tst   <u009D
         beq   L3C8A
         tst   <u00A0
         beq   L3C8A
         dec   <u00A0
L3C8A    puls  pc,b
L3C8C    lda   ,y+
         bmi   L3C21
         cmpa  <u0031,u
         beq   L3C21
         cmpy  <u006A
         bcc   L3C80
         lbsr  L1F92
         cmpa  >L05A0,pcr
         bne   L3C8C
         lda   -$02,y
         cmpa  #$20
         beq   L3CB2
         cmpa  #$2C
         beq   L3CB2
         cmpa  <u0031,u
         bne   L3C8C
L3CB2    lda   ,y
         cmpa  #$20
         beq   L3CC1
         cmpa  #$2C
         beq   L3CC1
         cmpa  <u0031,u
         bne   L3C8C
L3CC1    dec   <u009E
         bra   L3C8C
L3CC5    pshs  y,x,a
         ldx   <u006E
         tst   <u0030,u
         beq   L3CDB
         ldy   <u0030
         tfr   a,b
         andb  #$7F
         lslb
         clra
         ldb   d,y
         bra   L3CE8
L3CDB    ldd   #$0000
         ldb   <u002D,u
         std   <u006E
         ldb   <u0046
         lbsr  L3CEC
L3CE8    stx   <u006E
         puls  pc,y,x,a
L3CEC    pshs  x
         ldx   #$0000
L3CF1    subd  <u006E
         leax  $01,x
         cmpd  #$0000
         bpl   L3CF1
         beq   L3D01
         addd  <u006E
         leax  -$01,x
L3D01    std   <u006E
         tfr   x,d
         cmpd  #$0000
         puls  pc,x
L3D0B    ldd   #$0000
         std   <u00DD
         ldx   ,u
L3D12    cmpx  <u0077
         bcc   L3D35
         cmpx  u0002,u
         bcc   L3D35
         ldb   ,x+
         bmi   L3D36
         cmpb  #$09
         bcs   L3D36
         beq   L3D46
         cmpb  <u0031,u
         beq   L3D59
L3D29    tfr   b,a
         lbsr  L3CC5
         clra
         addd  <u00DD
         std   <u00DD
         bra   L3D12
L3D35    rts
L3D36    cmpb  #$F0
         beq   L3D35
         cmpb  #$F1
         bne   L3D12
         cmpx  u0002,u
         bne   L3D12
         ldb   #$2D
         bra   L3D29
L3D46    lda   #$33
         lbsr  L3CC5
         tfr   b,a
         tfr   x,y
         leay  -$01,y
         lbsr  L285C
         mul
         std   <u00DD
         bra   L3D12
L3D59    lda   ,x+
         bmi   L3D36
         cmpa  <u0031,u
         beq   L3D12
         cmpx  u0002,u
         bcs   L3D59
         rts
L3D67    cmpd  #$0000
         lbls  L3DB1
         pshs  b,a
         lda   #$20
         lbsr  L3CC5
         lda   <u00A0
         mul
         std   <u006E
         cmpd  #$0000
         puls  b,a
         beq   L3DB1
         lbsr  L3CEC
         stb   <u00F9
         tst   <u0030,u
         beq   L3DBB
         tst   <u0060
         beq   L3DBB
         lda   <u0045
         bita  #$01
         beq   L3DBB
         bita  #$04
         beq   L3DD1
         ldd   <u006E
         pshs  b,a
         clra
         ldb   <u009E
         std   <u006E
         puls  b,a
         lbsr  L3CEC
         stb   <u00A3
         ldd   <u006E
         stb   <u00A4
         bra   L3DD0
L3DB1    clr   <u00F8
         clr   <u00F9
         clr   <u00A3
         clr   <u00A4
         bra   L3DD0
L3DBB    ldd   <u006E
         pshs  b,a
         lda   #$20
         lbsr  L3CC5
         clra
         std   <u006E
         puls  b,a
         lbsr  L3CEC
         beq   L3DD0
         stb   <u00A4
L3DD0    rts
L3DD1    ldd   <u006E
         pshs  b,a
         clra
         ldb   <u00A0
         std   <u006E
         puls  b,a
         lbsr  L3CEC
         stb   <u00A3
         incb
         stb   <u00F8
         ldd   <u006E
         stb   <u00A4
         bra   L3DD0
L3DEA    tst   <u0030,u
         beq   L3E01
         tst   <u0060
         beq   L3E13
         lda   <u0045
         bita  #$01
         beq   L3E01
         bita  #$04
         beq   L3E19
         ldb   <u00F9
         bra   L3E0A
L3E01    ldb   <u00F9
         tst   <u00A4
         beq   L3E0A
         dec   <u00A4
         incb
L3E0A    lbsr  L399B
         lda   #$20
         lbsr  L2022
         rts
L3E13    lda   #$20
         lbsr  L2022
         rts
L3E19    tst   <u00A4
         beq   L3E23
         dec   <u00A4
         lda   <u00F8
         bra   L3E25
L3E23    lda   <u00A3
L3E25    sta   <u00DF
         lbsr  L1B97
         lda   #$20
         lbsr  L2022
         clra
         lbsr  L1B97
         ldb   <u00F9
         lbsr  L399B
         rts
L3E39    pshs  b,a
         lbsr  L012D
         tfr   x,d
         leax  >0,pcr
         leax  d,x
         bra   L3E4B
L3E48    lbsr  L1709
L3E4B    lda   ,x+
         bne   L3E48
         lbsr  L012E
         puls  pc,b,a
L3E54    pshs  b,a
         lbsr  L012D
         bra   L3E4B
L3E5B    lbsr  L0196
         lbra  L0131   Read keyboard
L3E61    lbsr  L17D7
         clr   <u00E3
         lda   #$FF
         sta   <u0074
L3E6A    lbsr  L17CF
         clr   <u0060
         pshs  x,a
         lda   <u00F0
         beq   L3E80
         clr   <u00F0
         ldx   >L05EA,pcr
         lbsr  L402C
         bra   L3E93
L3E80    lda   <u00EF
         anda  #$01
         beq   L3E93
         lda   <u00EF
         anda  #$FE
         sta   <u00EF
         ldx   >L05F2,pcr
         lbsr  L402C
L3E93    puls  x,a
         ldu   <u001C
         tst   <u00E3
         bne   L3EA6
         ldx   >L0644,pcr
         ldb   #$0C
         lbsr  L5A85
         bra   L3EA9
L3EA6    lbsr  L5B12
L3EA9    tsta
         lbeq  L3F37
         pshs  a
         lbsr  L4CD7
         puls  a
         lsla
         leax  >L3EC2,pcr
         ldd   a,x
         leax  >0,pcr
         jmp   d,x
L3EC2    fcb $3F,$37,$43,$A6,$41,$B9,$42,$19,$43,$2C,$3F,$B2,$40,$3D
 fcb $3F,$46,$3F,$E7,$43,$6D,$59,$0D,$5B,$2B,$00,$00,$00,$00

L3EDE    ldx   <u0016
         leay  <$37,x
         sty   <u0068
L3EE6    lbsr  L0131   Read keyboard
         cmpa  >ESCC,pcr
         beq   L3F37
         cmpa  >L0581,pcr
         beq   L3F13
         cmpa  >L057C,pcr
         beq   L3F1B
         cmpa  #$0D
         beq   L3F07
         cmpa  #$1F
         bls   L3EE6
         cmpx  <u0068
         beq   L3EE6
L3F07    sta   ,x+
         cmpa  #$0D
         beq   L3F12
         lbsr  L1709
         bra   L3EE6
L3F12    rts
L3F13    cmpx  <u0016
         beq   L3EE6
         bsr   L3F23
         bra   L3F13
L3F1B    cmpx  <u0016
         beq   L3EE6
         bsr   L3F23
         bra   L3EE6
L3F23    leax  -$01,x
         ldd   <u0038
         decb
         lbsr  L1742
         lda   #$20
         lbsr  L1709
         ldd   <u0038
         decb
         lbsr  L1742
         rts
L3F37    ldu   <u001C
         clr   <u0060
         tst   u0008,u
         lbeq  L2E55
         lbsr  L25FD
         bra   L3F37
         clr   <u00F0
         clr   <u00EF
         tst   <u0063
         bne   L3F52
         tst   <u0064
         beq   L3F5C
L3F52    ldx   >L05F8,pcr
         lbsr  L401D
         lbra  L3E6A
L3F5C    ldx   >L05FE,pcr
         lbsr  L4022
         lbsr  L3E5B
         lbsr  L1709
         lbsr  L1F92
         cmpa  >YCHR,pcr
         lbne  L3E6A
         ldx   >L05FC,pcr
         lbsr  L4027
         lbsr  L3E5B
         lbsr  L1709
         lbsr  L1F92
         cmpa  >YCHR,pcr
         lbne  L3E6A
         ldx   #$0000
         lbsr  L2F49
         lbsr  L3025
         ldx   <u0086
         ldy   <u001C
         ldd   #$0038
         lbsr  L4D27
         ldu   <u001C
         ldx   <u0077
         leax  -$01,x
         stx   u0006,u
         stx   u0004,u
         lbsr  L25FD
         clr   <u0075
         lbra  L3E6A
         tst   <u0064
         bne   L3F52
         ldx   >L05FA,pcr
         bsr   L4022
         lbsr  L3E5B
         lbsr  L0105
         lbsr  L1F92
         cmpa  >YCHR,pcr
         lbne  L3E6A
         ldx   >L05FC,pcr
         bsr   L4027
         lbsr  L3E5B
         lbsr  L0105
         lbsr  L1F92
         cmpa  >YCHR,pcr
         lbne  L3E6A
         lbra  L2019
         lda   #$01
         bne   L3FF7
         tst   <u0063
         lbne  L3F52
         tst   <u0064
         lbne  L3F52
L3FF7    ldx   >L05F6,pcr
         bsr   L401D
         lbsr  L3EDE
         ldx   <u0016
         lda   #$0D
L4004    cmpa  ,x+
         bne   L4004
         clr   -$01,x
         lbsr  L17D7
         ldx   <u0016
         lbsr  L0469
         bcc   L4017
         lbsr  L0324
L4017    lbsr  L3E5B
         lbra  L3E61
L401D    ldd   #$0000
         bra   L4034
L4022    ldd   #$0100
         bra   L4034
L4027    ldd   #$0200
         bra   L4034
L402C    ldd   #$0300
         bra   L4034
         ldd   #$0400
L4034    lbsr  L1742
         lbra  L3E39
         lbsr  L1882
         ldx   >L05E0,pcr
         bsr   L401D
         lbsr  L3EDE
         leax  -$01,x
         cmpx  <u0016
         lbeq  L3E6A
         lda   #$01
         sta   <u0083
         ldx   <u0016
         lbsr  L413A
         tst   <u0075
         bne   L4090
         ldy   <u0016
         bsr   L4072
         lda   #$01
         sta   <u0075
         ldd   #$0037
         ldx   <u002A
         ldy   <u002C
         lbsr  L4D27
         lbra  L5E36
L4072    pshs  y,x,b,a
         ldb   #$37
         ldx   <u002A
L4078    lda   ,y+
         cmpa  #$0D
         beq   L408B
         cmpa  #$20
         beq   L408B
         cmpa  #$2C
         beq   L408B
         sta   ,x+
         decb
         bne   L4078
L408B    clra
         sta   ,x
         puls  pc,y,x,b,a
L4090    lbsr  L02B0
         bcs   L410F
         ldy   <u0081
         ldx   <u001C
         ldd   $06,x
         std   <u006E
         ldx   ,x
         bra   L40A6
L40A2    lda   ,x+
         sta   ,y+
L40A6    cmpx  <u006E
         bne   L40A2
         ldx   <u006E
         leax  >-$00C8,x
         stx   <u0068
L40B2    lbsr  L033A
         bcs   L40D6
         cmpa  #$20
         bcc   L40C1
         cmpa  #$0D
         bne   L40B2
         lda   #$F0
L40C1    sta   ,y+
         cmpy  <u0068
         bne   L40B2
         lda   #$07
         lbsr  L0105
         ldx   >L05EA,pcr
         lbsr  L402C
         bra   L40D8
L40D6    bvc   L4125
L40D8    lbsr  L02C5
         ldu   <u001C
         ldx   u0006,u
         leax  $01,x
         cmpx  <u0077
         bne   L40ED
         lda   -$01,y
         cmpa  #$F0
         bne   L40ED
         leax  $01,x
L40ED    leax  -$01,x
         bra   L40F5
L40F1    lda   ,-y
         sta   ,-x
L40F5    cmpy  <u0081
         bne   L40F1
         ldu   <u001C
         stx   ,u
         stx   u0006,u
         lbsr  L2C78
         lbsr  L2DEC
         lda   #$FF
         sta   <u0074
         clr   <u007C
         lbra  L3E6A
L410F    ldd   #$0100
         lbsr  L1742
         lbsr  L0324
         lbsr  L02C5
         ldx   >L05EE,pcr
         lbsr  L402C
         lbra  L3E6A
L4125    ldd   #$0100
         lbsr  L1742
         lbsr  L0324
         lbsr  L02C5
         ldx   >L05EC,pcr
         lbsr  L402C
         bra   L40D8
L413A    pshs  x,a
L413C    lda   ,x+
         cmpa  #$0D
         beq   L414A
         cmpa  #$20
         beq   L414A
         cmpa  #$2C
         bne   L413C
L414A    stx   <u007A
         clr   -$01,x
         puls  pc,x,a
L4150    ldx   <u002A
         lbsr  L01B2
         bvs   L41AF
         bcc   L415D
         clr   <u0075
         bra   L417B
L415D    ldx   <u002C
         lbsr  L01B2
         bvs   L41AF
         bcs   L416C
         lda   #$02
         sta   <u0075
         bra   L417B
L416C    lda   #$01
         sta   <u0075
         ldd   #$0037
         ldx   <u002A
         ldy   <u002C
         lbsr  L4D27
L417B    lbsr  L0203
         bcc   L4181
         rts
L4181    pshs  x
         leax  $02,x
         lbsr  L5221
         puls  x
         bcs   L41AF
         lda   ,x
         lbsr  L1F92
         cmpa  >CTMCHR,pcr
         beq   L41A7
         cmpa  >CPTCHR,pcr
         beq   L41AB
         cmpa  >L05AA,pcr
         bne   L41AF
         stb   <u0076
         bra   L417B
L41A7    stb   <u003B
         bra   L417B
L41AB    stb   <u0042
         bra   L417B
L41AF    ldx   >L05F0,pcr
         lbsr  L3E39
         lbra  L0355
         lda   #$01
         sta   <u00CD
         clr   <u00CB
         tst   <u0064
         beq   L4229
         leax  >L0311,pcr
         stx   <u006A
         lbra  L42D5
L41CC    tst   <u0063
         beq   L41F5
         ldx   <u0086
L41D2    lbsr  L032F
         bcs   L41EF
         sta   ,x+
         cmpx  <u0072
         bcs   L41D2
L41DD    stx   <u0068
         ldx   <u0086
         ldu   <u006A
L41E3    lda   ,x+
         jsr   ,u
         bcs   L41F9
         cmpx  <u0068
         bcs   L41E3
         bra   L41CC
L41EF    bvc   L41F9
         clr   <u0063
         bra   L41DD
L41F5    clr   <u006C
         bra   L41FD
L41F9    lda   #$01
         sta   <u006C
L41FD    lbsr  L17D7
         lbsr  L183B
         tst   <u006C
         beq   L420A
         lbsr  L0324
L420A    lbsr  L02BD
         lbsr  L02C5
         lbsr  L02D5
         lbsr  L02DD
         lbra  L0355
         clr   <u00CD
         clr   <u00CB
         tst   <u0063
         lbne  L3F52
         tst   <u0064
         lbne  L3F52
L4229    leax  >L031C,pcr
         stx   <u006A
         tst   <u0075
         beq   L426A
L4233    ldx   >L05D6,pcr
         lbsr  L401D
         ldx   <u002C
         lbsr  L3E54
         ldx   >L05D8,pcr
         lbsr  L3E39
         lbsr  L3E5B
         lbsr  L1F92
         cmpa  >NCHR,pcr
         beq   L4267
         cmpa  >YCHR,pcr
         beq   L425C
         cmpa  #$0D
         bne   L4233
L425C    lda   >YCHR,pcr
         lbsr  L1709
         ldx   <u002C
         bra   L4283
L4267    lbsr  L1709
L426A    ldx   >L05E0,pcr
         lbsr  L4022
         lbsr  L3EDE
         leax  -$01,x
         cmpx  <u0016
         lbeq  L3E6A
         ldx   <u0016
         lbsr  L413A
         ldx   <u0016
L4283    stx   <u0068
         lbsr  L024A
         bcc   L42D5
         bvc   L42BF
         lbsr  L02DD
L428F    ldx   <u0068
         lbsr  L036D
         bcc   L4283
         bvc   L42BF
         ldx   >L05DE,pcr
         lbsr  L4027
         lbsr  L3E5B
         lbsr  L1F92
         cmpa  >YCHR,pcr
         beq   L42AF
         cmpa  #$0D
         bne   L42C8
L42AF    lda   >YCHR,pcr
         lbsr  L0105
         ldx   <u0068
         lbsr  L02F1
         bcs   L42BF
         bra   L428F
L42BF    ldd   #$0100
         lbsr  L1742
         lbsr  L0324
L42C8    ldx   >L05DA,pcr
         lbsr  L402C
         lbsr  L02DD
         lbra  L3E6A
L42D5    lbsr  L436C
         ldy   <u0070
         tst   <u00CB
         bne   L4338
L42DF    cmpy  <u0081
         beq   L4305
         lda   ,y+
         cmpa  #$F0
         bne   L42EC
         lda   #$0D
L42EC    ldx   <u006A
         jsr   ,x
         bcc   L42DF
L42F2    ldd   #$0100
         lbsr  L1742
         lbsr  L0324
         ldx   >L05DC,pcr
         lbsr  L402C
         lbra  L3E6A
L4305    ldy   <u001C
         ldy   ,y
L430B    cmpy  <u0077
         beq   L4320
         lda   ,y+
         cmpa  #$F0
         bne   L4318
         lda   #$0D
L4318    ldx   <u006A
         jsr   ,x
         bcc   L430B
         bra   L42F2
L4320    tst   <u00CD
         lbne  L41CC
L4326    lbsr  L02DD
         lbra  L3E6A
         lbsr  L4CEB
         bcs   L4351
         inc   <u00CB
         clr   <u00CD
         lbra  L426A
L4338    ldu   <u001C
         ldy   u0006,u
L433D    cmpy  <u00C6
         beq   L4326
         lda   ,y+
         cmpa  #$F0
         bne   L434A
         lda   #$0D
L434A    lbsr  L031C
         bcc   L433D
         bra   L42F2
L4351    lda   #$07
         lbsr  L0105
         ldx   >L05E6,pcr
         lbsr  L401D
         lbra  L3E6A
L4360    ldd   #$0200
         lbsr  L1742
         lbsr  L0324
         lbra  L3E6A
L436C    rts
         lda   #$01
         sta   <u00EA
         clr   <u0059
         leax  >L439A,pcr
         stx   <u005D
         bra   L43AE
L437B    ldx   >L0620,pcr
         lbsr  L4022
         lbsr  L3EDE
         ldx   <u0016
         lbsr  L413A
         lbsr  L024A
         lbcs  L42BF
         lbsr  L44C4
         lbsr  L02DD
         lbra  L44B3
L439A    lbsr  L031C
         bcs   L43A0
         rts
L43A0    lds   <u0018
         lbra  L4360
         clr   <u00EA
         leax  >L0165,pcr
         stx   <u005D
L43AE    ldx   >L060A,pcr
         lbsr  L401D
L43B5    lbsr  L3E5B
         cmpa  >ESCC,pcr
         lbeq  L3E6A
         cmpa  #$0D
         lbeq  L4454
         lbsr  L1F92
         cmpa  >NCHR,pcr
         lbeq  L4454
         cmpa  >YCHR,pcr
         beq   L43E6
         lda   #$07
         lbsr  L0105
         bra   L43B5
L43DE    lda   #$27
         lbsr  L36AB
         lbra  L2E8B
L43E6    ldx   >L0614,pcr
         lbsr  L401D
         clra
         ldb   <u0042
         lbsr  L3200
         ldx   <u002E
         leax  $02,x
         lbsr  L3E54
         ldx   >L0610,pcr
         lbsr  L3E39
         lbsr  L3EDE
         ldx   <u0016
         lda   ,x
         cmpa  #$0D
         beq   L4416
         lbsr  L5221
         bcs   L43DE
         stb   <u0042
         lbsr  L19F6
L4416    tst   <u00EA
         lbne  L437B
         ldx   >L060E,pcr
         lbsr  L3E39
         ldx   <u0014
         ldx   $0A,x
         lbsr  L3E54
         ldx   >L0610,pcr
         lbsr  L3E39
         lbsr  L3EDE
         ldx   <u0016
         lda   ,x
         cmpa  #$0D
         beq   L4454
         lbsr  L413A
         ldy   <u0014
         ldy   $0A,y
         ldb   #$0B
L4447    lda   ,x+
         cmpa  #$20
         beq   L4447
         sta   ,y+
         beq   L4454
         decb
         bne   L4447
L4454    tst   <u00EA
         lbne  L437B
         ldx   <u0014
         ldx   $0A,x
         lbsr  L0174
         bcc   L4471
         lbvc  L4360
         ldx   >L060C,pcr
         lbsr  L4027
         lbra  L3E6A
L4471    lbsr  L1B3B
         ldx   >L0612,pcr
         lbsr  L4022
         clr   <u0059
L447D    lbsr  L3E5B
         cmpa  >ESCC,pcr
         beq   L44B0
         lbsr  L1F92
         cmpa  >NCHR,pcr
         beq   L44A7
         cmpa  #$0D
         beq   L44A7
         cmpa  >YCHR,pcr
         beq   L44A0
         lda   #$07
         lbsr  L0105
         bra   L447D
L44A0    lbsr  L1709
         inc   <u0059
         bra   L44AE
L44A7    lda   >NCHR,pcr
         lbsr  L1709
L44AE    bsr   L44C4
L44B0    lbsr  L018D
L44B3    clr   <u0060
         lda   #$01
         sta   <u007E
         sta   <u0083
         ldu   <u001C
         ldx   ,u
         stx   u0006,u
         lbra  L3E6A
L44C4    lda   #$20
         sta   <u00DA
         clr   <u00DC
         clr   <u00DB
         clr   <u0037
         clr   <u0036
         lda   #$01
         sta   <u005F
         sta   <u0060
         clr   <u0088
L44D8    lda   #$03
         lbsr  L1882
         ldx   >L0618,pcr
         lbsr  L4027
L44E4    lbsr  L3E5B
         cmpa  >ESCC,pcr
         lbeq  L45EA
         lbsr  L1F92
         cmpa  >NCHR,pcr
         beq   L4516
         cmpa  #$0D
         beq   L4509
         cmpa  >YCHR,pcr
         beq   L4509
         lda   #$07
         lbsr  L0105
         bra   L44E4
L4509    lda   >YCHR,pcr
         lbsr  L1709
         clr   <u00C3
         ldb   #$FF
         bra   L4541
L4516    lbsr  L1709
         ldx   >L061A,pcr
         lbsr  L3E39
         lbsr  L3EDE
         ldx   <u0016
         lbsr  L5221
         bcs   L44D8
         tstb
         beq   L452E
         decb
L452E    stb   <u00C3
         ldx   >L061C,pcr
         lbsr  L3E39
         lbsr  L3EDE
         ldx   <u0016
         lbsr  L5221
         bcs   L44D8
L4541    stb   <u00C4
         cmpb  <u00C3
         bls   L44D8
         ldx   #$0000
         lbsr  L2F49
         lbsr  L3025
         ldx   >L0616,pcr
         lbsr  L402C
         ldx   <u001C
         ldy   <u001E
         ldd   #$0038
         lbsr  L4D27
         ldu   <u001E
L4564    lda   <u0010,u
         cmpa  <u00C4
         beq   L45B2
         cmpa  <u00C3
         bcs   L45AD
         lbsr  L45FE
         lbcs  L45EA
         tst   <u00EA
         bne   L45AD
         lbsr  L019F
         beq   L45AD
         lbsr  L0131   Read keyboard
         cmpa  #$20
         beq   L458C
         cmpa  >ESCC,pcr
         bne   L45AD
L458C    ldx   >L061E,pcr
         lbsr  L402C
         lbsr  L3E5B
         cmpa  >ESCC,pcr
         beq   L45A6
         cmpa  #$20
         beq   L45A6
         cmpa  #$0D
         beq   L45EA
         bra   L458C
L45A6    ldx   >L0616,pcr
         lbsr  L402C
L45AD    lbsr  L25FD
         bcc   L4564
L45B2    lda   <u001B,u
         cmpa  <u002B,u
         bcc   L45DA
         deca
         sta   <u002C,u
         clr   u0002,u
         clr   u0004,u
L45C2    lbsr  L25FD
         lda   <u002C,u
         beq   L45DA
         lda   <u0010,u
         cmpa  <u00C4
         beq   L45DA
         lbsr  L45FE
         lbcs  L45EA
         bra   L45C2
L45DA    ldb   <u002B,u
         subb  <u005F
         incb
L45E0    pshs  b
         lbsr  L1B41
         puls  b
         decb
         bne   L45E0
L45EA    lda   >L05B3,pcr
         lbsr  L1B74
         lda   >L05B4,pcr
         lbsr  L1BAF
         ldu   <u001C
         lbsr  L25FD
         rts
L45FE    lda   [,u]
         cmpa  >L0594,pcr
         beq   L4610
         tst   <u001D,u
         bne   L4610
         tst   <u002C,u
         bne   L4613
L4610    andcc #$FE
         rts
L4613    tst   <u0030,u
         bne   L461E
         lda   <u002D,u
         lbsr  L1B74
L461E    lda   <u002E,u
         lbsr  L1BAF
L4624    lda   <u002C,u
         cmpa  <u005F
         beq   L4666
         lbsr  L1B41
         lda   <u005F
         inca
         sta   <u005F
         cmpa  <u002B,u
         bls   L4624
         lda   #$01
         sta   <u005F
         tst   <u0059
         beq   L4624
         ldx   >L061E,pcr
         lbsr  L402C
L4647    lbsr  L3E5B
         cmpa  >ESCC,pcr
         beq   L4624
         cmpa  #$20
         beq   L4624
         cmpa  #$0D
         beq   L465A
         bra   L4647
L465A    orcc  #$01
         rts
         ldx   >L0616,pcr
         lbsr  L402C
         bra   L4624
L4666    ldd   u0002,u
         subd  ,u
         cmpd  #$0001
         bne   L4673
         andcc #$FE
         rts
L4673    ldd   <u0011,u
         bitb  #$01
         beq   L467F
         ldb   <u0018,u
         bra   L4682
L467F    ldb   <u0017,u
L4682    decb
         bmi   L4698
         lda   #$20
         sta   <u00D7
         clr   <u00D9
         lda   <u0037
         sta   <u00D8
         pshs  b
         lbsr  L1CCD
         puls  b
         bra   L4682
L4698    lbsr  L37D6
         andcc #$FE
         rts
         ldb   [<u0006,u]
         bmi   L46B4
         clr   <u00C5
         bsr   L46D4
         tfr   b,a
         lbsr  L3666
         ldx   u0006,u
         leax  -$01,x
         stx   u0006,u
         bra   L46C3
L46B4    cmpb  #$F0
         beq   L46D1
         cmpb  #$F1
         beq   L46D1
         stb   <u00C5
         bsr   L46D4
         stb   [<u0006,u]
L46C3    ldy   u0006,u
         clr   <u00D0
         lbsr  L2361
         ldd   <u0038
         decb
         lbsr  L1742
L46D1    lbra  L545D
L46D4    pshs  a
         tst   <u00C5
         beq   L46DC
         dec   <u00C5
L46DC    cmpa  >L0574,pcr
         beq   L470F
         cmpa  >L0575,pcr
         beq   L4713
         cmpa  >L0576,pcr
         beq   L4717
         ldb   <u00C5
         andb  #$70
         cmpa  >L0579,pcr
         lbeq  L479F
         cmpa  >L0577,pcr
         beq   L471B
         cmpa  >L0578,pcr
         beq   L473B
         tst   <u00C5
         beq   L470C
         inc   <u00C5
L470C    clrb
         puls  pc,a
L470F    ldb   #$01
         bra   L4789
L4713    ldb   #$04
         bra   L4789
L4717    ldb   #$02
         bra   L4789
L471B    cmpb  #$30
         beq   L4733
         cmpb  #$40
         beq   L4733
         cmpb  #$60
         beq   L4733
         cmpb  #$20
         beq   L4737
         cmpb  #$50
         beq   L4737
         cmpb  #$70
         beq   L4737
L4733    ldb   #$40
         bra   L477F
L4737    ldb   #$50
         bra   L477F
L473B    cmpb  #$30
         beq   L4753
         cmpb  #$40
         beq   L4753
         cmpb  #$60
         beq   L4753
         cmpb  #$20
         beq   L4757
         cmpb  #$50
         beq   L4757
         cmpb  #$70
         beq   L4757
L4753    ldb   #$60
         bra   L477F
L4757    ldb   #$70
         bra   L477F
L475B    cmpb  #$30
         beq   L4773
         cmpb  #$40
         beq   L4777
         cmpb  #$60
         beq   L477B
         cmpb  #$20
         beq   L4773
         cmpb  #$50
         beq   L4777
         cmpb  #$70
         beq   L477B
L4773    ldb   #$20
         bra   L477F
L4777    ldb   #$50
         bra   L477F
L477B    ldb   #$70
         bra   L477F
L477F    lda   <u00C5
         anda  #$0F
         sta   <u00C5
         orb   <u00C5
         bra   L4793
L4789    lda   <u00C5
         anda  #$70
         bne   L4791
         orb   #$30
L4791    orb   <u00C5
L4793    orb   #$80
         incb
         cmpb  #$F0
         bne   L479B
         decb
L479B    stb   <u00C5
         puls  pc,a
L479F    lbsr  L019F
         beq   L479F
         lbsr  L0131   Read keyboard
         anda  #$7F
         tst   <u0056
         beq   L47B0
         lbsr  L1F92
L47B0    cmpa  #$31
         beq   L47C2
         cmpa  #$32
         beq   L47C0
         cmpa  #$33
         bne   L47C6
         ldb   #$18
         bra   L4789
L47C0    bra   L475B
L47C2    ldb   #$08
         bra   L475B
L47C6    puls  pc,a
         lda   [<u0006,u]
         lbpl  L545D
         cmpa  #$F0
         lbeq  L545D
         cmpa  #$F1
         lbeq  L545D
         ldx   u0006,u
         leay  $01,x
         ldd   u0006,u
         sty   u0006,u
         subd  ,u
         lbsr  L4D14
         sty   ,u
         lbra  L46C3
         tst   <u0079
         beq   L47FB
         lda   #$16
         lbsr  L36AB
         lbra  L2EA6
L47FB    lbsr  L4CEB
         lbcs  L2EA6
         ldd   <u00C6
         subd  u0006,u
         std   <u00C8
         ldd   ,u
         subd  <u0081
         subd  #$0002
         subd  <u00C8
         bcc   L481B
         lda   #$17
         lbsr  L36AB
         lbra  L2EA6
L481B    ldd   <u00C8
         ldy   <u0081
         ldx   u0006,u
         lbsr  L4D27
         ldd   <u0077
         subd  <u00C6
         subd  #$0002
         ldx   <u00C6
         leax  $02,x
         ldy   u0006,u
         leay  $02,y
         lbsr  L4D27
         sty   <u0077
         lda   #$01
         sta   <u0079
         ldd   <u00C8
         ldx   <u0081
         ldy   <u0077
         lbsr  L4D27
         ldd   u0006,u
         subd  ,u
         ldx   u0006,u
         leay  $02,x
         sty   u0006,u
         lbsr  L4D14
         sty   ,u
L485A    lbsr  L2C78
         lbsr  L2DEC
         lda   <u007E
         inca
         sta   <u007C
         sta   <u0074
         lbra  L2E8B
         tst   <u0079
         bne   L4876
         lda   #$18
         lbsr  L36AB
         lbra  L2EA6
L4876    ldd   ,u
         subd  <u0081
         subd  <u00C8
         bcc   L4886
         lda   #$17
         lbsr  L36AB
         lbra  L2EA6
L4886    ldx   <u0077
         ldy   <u0081
         ldd   <u00C8
         lbsr  L4D27
         ldd   <u0077
         subd  u0006,u
         ldx   <u0077
         ldy   <u0072
         sty   <u0077
         lbsr  L4D14
         clr   <u0079
         ldd   <u00C8
         ldx   <u0081
         ldy   u0006,u
         lbsr  L4D27
         bra   L485A
         tst   <u0079
         bne   L48B9
         lda   #$18
         lbsr  L36AB
         lbra  L2EA6
L48B9    ldd   ,u
         subd  <u0081
         cmpd  #$00C8
         bcs   L48CD
         subd  <u00C8
         bcs   L48CD
         cmpd  #$00C8
         bhi   L48D5
L48CD    lda   #$17
         lbsr  L36AB
         lbra  L2EA6
L48D5    ldd   ,u
         subd  <u00C8
         ldx   ,u
         std   ,u
         ldy   ,u
         stx   <u006E
         ldd   u0006,u
         subd  <u006E
         lbsr  L4D27
         sty   u0006,u
         ldx   <u0077
         ldy   u0006,u
         ldd   <u00C8
         lbsr  L4D27
         lbra  L485A
         lbsr  L4CEB
         lbcs  L2EA6
         lda   <u007E
         lbsr  L1882
         lda   <u007E
         clrb
         lbsr  L1742
         ldd   <u00C6
         subd  u0006,u
         lbsr  L3200
         ldx   >L0640,pcr
         lbsr  L3E39
         ldx   <u002E
         lbsr  L3E54
         ldx   >L0642,pcr
         lbsr  L3E39
         lbsr  L1F76
         lbsr  L1709
         anda  #$5F
         cmpa  >YCHR,pcr
         lbne  L2E8B
         ldy   <u00C6
         leay  $02,y
         ldx   u0006,u
         ldd   u0006,u
         subd  ,u
         sty   u0006,u
         lbsr  L4D14
         sty   ,u
         lbra  L485A
         lda   >L0595,pcr
         lbsr  L3666
         lbsr  L3666
         ldx   u0009,u
         lbsr  L2DEC
         lbra  L2E8B
         clr   <u00E9
         clr   <u00CE
         lda   #$01
         sta   <u0083
         lda   #$04
         sta   <u007E
         clr   <u00D2
         lbsr  L37D6
         lda   <u007E
         inca
         sta   <u007C
         sta   <u0074
L4976    lbsr  L4CD7
         ldd   #$0000
         lbsr  L1742
         ldx   >L0634,pcr
         lbsr  L3E39
L4986    ldx   <u0016
         stx   <u00BB
         lbsr  L4B6A
         bcs   L4976
         ldx   <u0016
         pshs  x
         ldd   <u00BB
         subd  ,s++
         cmpd  #$0001
         beq   L4986
L499D    lbsr  L4C11
         bcs   L49D4
         lda   <u007E
         inca
         sta   <u007C
         sta   <u0074
         ldd   #$0200
         lbsr  L1742
         ldx   >L0636,pcr
         lbsr  L3E39
         lda   #$01
         sta   <u0088
         lda   <u007E
         clr   <u00D2
         lbsr  L37D6
L49C1    lbsr  L1F76
         cmpa  #$0D
         beq   L49D9
         cmpa  >ESCC,pcr
         beq   L49D9
         cmpa  #$20
         bne   L49C1
         bra   L499D
L49D4    lda   #$20
         lbsr  L36AB
L49D9    lda   #$04
         sta   <u007E
         lbsr  L3773
         lda   <u007E
         cmpa  #$04
         beq   L49EB
         inca
         sta   <u0074
         sta   <u007C
L49EB    lbra  L2E51
         clr   <u00E9
         clr   <u00CE
         lda   #$01
         sta   <u0083
         clr   <u0059
         lda   #$04
         sta   <u007E
         clr   <u00D2
         lbsr  L37D6
         lda   <u007E
         inca
         sta   <u007C
         sta   <u0074
L4A08    lbsr  L4CD7
         ldd   #$0000
         lbsr  L1742
         ldx   >L063A,pcr
         lbsr  L3E39
         ldx   <u0016
         stx   <u00BB
L4A1C    lbsr  L4B6A
         bcs   L4A08
         ldx   <u0016
         pshs  x
         ldd   <u00BB
         subd  ,s++
         cmpd  #$0001
         beq   L4A1C
         ldd   <u00BB
         std   <u00B9
         ldd   #$0100
         lbsr  L1742
         ldx   >L063C,pcr
         lbsr  L3E39
         lbsr  L4B6A
         bcs   L4A08
L4A45    lbsr  L4C11
         lbcs  L4B4C
         tst   <u0059
         bne   L4A9D
         lda   #$05
         sta   <u007C
         sta   <u0074
         lda   #$02
         lbsr  L1882
         lda   #$03
         lbsr  L1882
         ldd   #$0200
         lbsr  L1742
         ldx   >L063E,pcr
         lbsr  L3E39
         lda   #$01
         sta   <u0088
         lda   #$04
         sta   <u007E
         clr   <u00D2
         lbsr  L37D6
L4A7A    lbsr  L1F76
         cmpa  >ESCC,pcr
         lbeq  L49D9
         anda  #$5F
         cmpa  >NCHR,pcr
         beq   L4ADF
         cmpa  >L059D,pcr
         beq   L4A9B
         cmpa  >YCHR,pcr
         bne   L4A7A
         bra   L4A9D
L4A9B    inc   <u0059
L4A9D    ldd   <u00B9
         addd  #$0001
         addd  <u00BF
         subd  <u00BD
         subd  <u00BB
         bcs   L4B0F
         ldx   u0006,u
         leay  b,x
         ldd   u0006,u
         subd  ,u
         sty   u0006,u
         lbsr  L4D14
         sty   ,u
L4ABB    ldd   <u00BB
         subd  <u00B9
         subd  #$0001
         ldx   <u00B9
         ldy   u0006,u
         lbsr  L4D27
         sty   <u00CE
         lbsr  L2C78
         lbsr  L2DEC
         tst   <u0059
         lbne  L4A45
         lda   #$05
         sta   <u0074
         sta   <u007C
L4ADF    ldd   #$0200
         lbsr  L1742
         ldx   >L0636,pcr
         lbsr  L3E39
         lda   #$01
         sta   <u0088
         lda   #$04
         clr   <u00D2
         lbsr  L37D6
L4AF7    lbsr  L1F76
         cmpa  #$0D
         lbeq  L49D9
         cmpa  >ESCC,pcr
         lbeq  L49D9
         cmpa  #$20
         bne   L4AF7
         lbra  L4A45
L4B0F    stb   <u006D
         addd  ,u
         subd  <u0081
         bcs   L4B3E
         cmpd  #$000A
         bcs   L4B3E
         cmpd  #$00C8
         bhi   L4B28
         lda   #$19
         lbsr  L36AB
L4B28    ldx   ,u
         ldb   <u006D
         leay  b,x
         ldd   u0006,u
         subd  ,u
         sty   ,u
         lbsr  L4D27
         sty   u0006,u
         lbra  L4ABB
L4B3E    lda   #$1A
         lbsr  L36AB
         lda   <u007E
         inca
         sta   <u007C
         sta   <u0074
         bra   L4B51
L4B4C    lda   #$20
         lbsr  L36AB
L4B51    lda   #$04
         sta   <u007E
         lbsr  L3773
         lda   #$04
         cmpa  <u007E
         bne   L4B62
         tst   <u0059
         beq   L4B67
L4B62    inca
         sta   <u0074
         sta   <u007C
L4B67    lbra  L2E51
L4B6A    lda   >L05AC,pcr
         ldb   #$02
         lbsr  L1725
         clrb
         ldx   <u00BB
L4B76    lbsr  L1F76
         cmpa  >ESCC,pcr
         lbeq  L49D9
         cmpa  >L0581,pcr
         beq   L4BF1
         cmpa  #$0D
         beq   L4BA5
         cmpa  >L0591,pcr
         beq   L4BF4
         cmpa  >L057C,pcr
         beq   L4BC6
         cmpa  >L0593,pcr
         bne   L4BA1
         lda   #$F0
         bra   L4BA5
L4BA1    cmpa  #$20
         bcs   L4B76
L4BA5    sta   b,x
         cmpa  #$0D
         beq   L4BE1
         incb
         cmpb  #$32
         bcs   L4BB9
         lda   #$1F
         lbsr  L36AB
         cmpb  #$32
         bhi   L4BF1
L4BB9    cmpa  #$F0
         bne   L4BC1
         lda   >L0593,pcr
L4BC1    lbsr  L1709
         bra   L4B76
L4BC6    tstb
         beq   L4BF1
         pshs  b
         ldd   <u0038
         decb
         lbsr  L1742
         lda   #$20
         lbsr  L1709
         ldd   <u0038
         decb
         lbsr  L1742
         puls  b
         decb
         bra   L4B76
L4BE1    incb
         abx
         stx   <u00BB
         lda   >L05AB,pcr
         ldb   #$02
         lbsr  L1725
         andcc #$FE
         rts
L4BF1    orcc  #$01
         rts
L4BF4    lda   #$0D
         sta   b,x
         incb
         abx
         stx   <u00BB
         lda   >L05AB,pcr
         ldb   #$02
         lbsr  L1725
         ldx   >L0638,pcr
         lbsr  L3E39
         inc   <u00E9
         andcc #$FE
         rts
L4C11    ldx   u0006,u
         cmpx  <u00CE
         bhi   L4C1B
         ldx   <u00CE
         bra   L4C29
L4C1B    lda   ,x+
         bpl   L4C29
         cmpa  #$F0
         beq   L4C29
         cmpa  #$F1
         beq   L4C29
         leax  $01,x
L4C29    stx   <u00BD
         cmpx  <u0077
         bcc   L4C64
L4C2F    ldy   <u0016
         ldx   <u00BD
L4C34    lda   ,x
         tst   <u00E9
         beq   L4C50
         cmpa  #$41
         bcs   L4C50
         cmpa  #$5A
         bhi   L4C46
         adda  #$20
         bra   L4C50
L4C46    cmpa  #$61
         bcs   L4C50
         cmpa  #$7A
         bhi   L4C50
         suba  #$20
L4C50    ldb   ,x+
         bpl   L4C58
         cmpa  #$F0
         bne   L4C60
L4C58    cmpa  ,y
         beq   L4C67
         cmpb  ,y
         beq   L4C67
L4C60    cmpx  <u0077
         bcs   L4C34
L4C64    orcc  #$01
         rts
L4C67    stx   <u00BD
         leay  $01,y
         bra   L4C9F
L4C6D    lda   ,y
         cmpa  #$0D
         beq   L4CA5
         lda   ,x
         tst   <u00E9
         beq   L4C8F
         cmpa  #$41
         bcs   L4C8F
         cmpa  #$5A
         bhi   L4C85
         adda  #$20
         bra   L4C8F
L4C85    cmpa  #$61
         bcs   L4C8F
         cmpa  #$7A
         bhi   L4C8F
         suba  #$20
L4C8F    ldb   ,x+
         bpl   L4C97
         cmpa  #$F0
         bne   L4C9F
L4C97    cmpb  ,y+
         beq   L4C9F
         cmpa  -$01,y
         bne   L4C2F
L4C9F    cmpx  <u0077
         bne   L4C6D
         bra   L4C2F
L4CA5    cmpx  <u0077
         bcc   L4C64
         stx   <u00BF
         ldx   <u00BD
         leax  -$01,x
         stx   <u00BD
         lda   -$01,x
         bpl   L4CC1
         cmpa  #$F0
         beq   L4CC1
         cmpa  #$F1
         beq   L4CC1
         leax  -$01,x
         stx   <u00BD
L4CC1    ldx   <u00BD
         cmpx  u0002,u
         bcs   L4CCE
         lbsr  L25FD
         bcs   L4CD3
         bra   L4CC1
L4CCE    andcc #$FE
         stx   u0006,u
         rts
L4CD3    clr   <u007E
         bra   L4C64
L4CD7    clra
         lbsr  L1882
         lda   #$01
         lbsr  L1882
         lda   #$02
         lbsr  L1882
         lda   #$03
         lbsr  L1882
         rts
L4CEB    ldx   u0006,u
L4CED    lda   ,x+
         cmpx  <u0077
         beq   L4D0C
         cmpa  >L0595,pcr
         bne   L4CED
         lda   ,x+
         cmpx  <u0077
         beq   L4D0C
         cmpa  >L0595,pcr
         bne   L4CED
         leax  -$02,x
         stx   <u00C6
         andcc #$FE
         rts
L4D0C    lda   #$15
         lbsr  L36AB
         orcc  #$01
         rts
L4D14    inca
         pshs  a
         tstb
         bra   L4D1F
L4D1A    lda   ,-x
         sta   ,-y
         decb
L4D1F    bne   L4D1A
         dec   ,s
         bne   L4D1A
         puls  pc,a
L4D27    inca
         pshs  a
         tstb
         bra   L4D32
L4D2D    lda   ,x+
         sta   ,y+
         decb
L4D32    bne   L4D2D
         dec   ,s
         bne   L4D2D
         puls  pc,a
L4D3A    clr   <u006C
         leay  >0,pcr
         ldd   >FMTTBL,pcr
         leay  d,y
L4D46    ldx   ,u
         leax  $01,x
L4D4A    lda   ,x+
         cmpa  #$20
         beq   L4D71
         cmpa  #$2C
         beq   L4D71
         lbsr  L1F92
         cmpa  ,y+
         bne   L4D71
         tst   ,y
         bne   L4D4A
         lda   ,x
         cmpa  #$20
         beq   L4D9C
         cmpa  #$2C
         beq   L4D9C
         cmpa  #$F0
         beq   L4D9C
         leay  $01,y
         bra   L4D75
L4D71    tst   ,y+
         bne   L4D71
L4D75    inc   <u006C
         tst   ,y
         bne   L4D46
L4D7B    cmpu  <u001C
         bne   L4D85
         lda   #$0C
         lbra  L36AB
L4D85    rts
L4D86    cmpu  <u001C
         bne   L4D85
         lda   #$0D
         lbra  L36AB
         rts
L4D91    cmpu  <u001C
         bne   L4D85
         lda   #$0E
         lbra  L36AB
         rts
L4D9C    leay  >L4DBA,pcr
         lda   <u006C
         cmpa  #$05
         ble   L4DB1
         tst   <u001D,u
         bne   L4D91
         tst   u0008,u
         lbne  L4D7B
L4DB1    lsla
         ldd   a,y
         leay  >0,pcr
         jmp   d,y

L4DBA    fdb  L4E10,$4EAD,$4E38,$5210,$4D85,L4E79
 fdb $4EE8,$4E34,$4E52,$4F86,$4F98,$5041
 fdb $5075,$4E2E,$4FD4,$4FB8,$5002,$4FDF
 fdb L4DFE,$50A9,$50EE,$5133,$5159,$5174
 fdb $517A,$5180,$5192,$51A4,$51B5,$51F8
 fdb $5206,$5217,$0000,$0000

L4DFE    lbsr  L5221
         lbcs  L4D7B
         cmpb  <u002C,u
         lbls  L4D86
         stb   <u002C,u
         rts

L4E10    lbsr  L5221
         lbcs  L4D7B
         cmpb  #$00
         bne   L4E1D
         ldb   #$01
L4E1D    tst   <u001D,u
         bne   L4E26
         tst   u0008,u
         beq   L4E2A
L4E26    stb   <u0021,u
         rts
L4E2A    stb   <u0025,u
         rts
         lda   #$01
         sta   <u0026,u
         rts
         clr   <u0026,u
         rts
         lbsr  L5221
         cmpb  #$00
         bne   L4E41
         ldb   #$01
L4E41    tst   <u001D,u
         bne   L4E4A
         tst   u0008,u
         beq   L4E4E
L4E4A    stb   <u0022,u
         rts
L4E4E    stb   <u0027,u
         rts
         lbsr  L5221
         lbcs  L4D7B
         cmpb  #$78
         lbhi  L4D86
         stb   <u0017,u
         stb   <u0018,u
         lbsr  L5221
         tstb
         beq   L4E78
         lbcs  L4D7B
         cmpb  #$78
         lbhi  L4D86
         stb   <u0018,u
L4E78    rts

L4E79    lbsr  L5221
         lbcs  L4D7B
         cmpd  #$0003
         lbcs  L4D86
         cmpb  #$64
         lbhi  L4D86
         stb   <u002B,u
         tfr   b,a
         suba  <u001E,u
         lbcs  L4D86
         suba  <u001A,u
         lbcs  L4D86
         cmpa  #$02
         lbls  L4D86
         lbsr  L4FAD
         lbra  L4D85
         lbsr  L5221
         lbcs  L4D7B
L4EB4    tst   <u001D,u
         bne   L4ED3
         tst   u0008,u
         bne   L4ED3
         lda   <u001C,u
         pshs  a
         stb   <u001C,u
         lbsr  L4F50
         puls  a
         bcc   L4ED2
         sta   <u001C,u
         lbra  L4D86
L4ED2    rts
L4ED3    lda   <u0020,u
         stb   <u0020,u
         pshs  a
         lbsr  L4F50
         puls  a
         bcc   L4ED2
         sta   <u0020,u
         lbra  L4D86
         lbsr  L5221
         lbcs  L4D7B
         bsr   L4EB4
         lbcs  L4D7B
         lbsr  L5221
         lbcs  L4D7B
         lbsr  L4FE6
         lda   #$16
         sta   <u006C
         ldy   <u0028
L4F06    lda   ,x+
         lbsr  L1F92
         cmpa  #$2C
         beq   L4F06
         cmpa  #$20
         beq   L4F06
         cmpa  #$44
         bne   L4F1B
         sta   <u006D
         bra   L4F29
L4F1B    cmpa  #$4C
         bne   L4F23
         sta   <u006D
         bra   L4F29
L4F23    lda   #$4C
         sta   <u006D
         leax  -$01,x
L4F29    lbsr  L5221
         tstb
         beq   L4F41
         lbcs  L4D7B
         std   <u006E
         stb   ,y+
         lda   <u006D
         sta   ,y++
         dec   <u006C
         beq   L4F4F
         bra   L4F06
L4F41    ldd   <u006E
L4F43    addb  #$06
         stb   ,y+
         lda   <u006D
         sta   ,y++
         dec   <u006C
         bne   L4F43
L4F4F    rts
L4F50    pshs  a
         lda   <u0020,u
         cmpa  #$96
         bhi   L4F78
         lda   <u002A,u
         adda  <u0029,u
         bmi   L4F78
         lda   <u001C,u
         cmpa  #$96
         bhi   L4F78
         suba  <u002A,u
         bcs   L4F78
         suba  <u0029,u
         cmpa  #$0A
         bcs   L4F78
         andcc #$FE
         puls  pc,a
L4F78    cmpu  <u001C
         bne   L4F82
         lda   #$0D
         lbsr  L36AB
L4F82    orcc  #$01
         puls  pc,a
         lbsr  L5221
         lbcs  L4D7B
         tstb
         bne   L4F91
         incb
L4F91    addb  <u002C,u
         stb   <u002C,u
         rts
         lbsr  L5221
         lbcs  L4D7B
         tstb
         beq   L4FA9
         cmpb  #$03
         lbhi  L4D86
         decb
L4FA9    stb   <u0024,u
         rts
L4FAD    lda   <u002B,u
         suba  <u001A,u
         inca
         sta   <u001B,u
         rts
L4FB8    ldd   u000F,u
         addd  #$0001
         cmpb  <u0076
         bne   L4FCD
         cmpu  <u001C
         lbne  L4D85
         lda   #$24
         lbra  L36AB
L4FCD    lda   <u001B,u
         sta   <u002C,u
         rts
         lbsr  L5221
         lbcs  L4D7B
         std   <u0011,u
         rts
         lbsr  L5221
         lbcs  L4D7B
L4FE6    tst   u0008,u
         lbne  L4D91
         tst   <u001D,u
         lbne  L4D91
         lda   <u002A,u
         stb   <u002A,u
         lbsr  L4F50
         bcc   L5001
         sta   <u002A,u
L5001    rts
         clr   <u006C
L5004    leax  $01,x
         lda   ,x
         cmpa  #$20
         beq   L5004
         cmpa  #$2C
         beq   L5004
         cmpa  #$2D
         bne   L5018
         com   <u006C
         leax  $01,x
L5018    lbsr  L5221
         lbcs  L4D7B
         tst   <u006C
         beq   L5025
         comb
         incb
L5025    tst   u0008,u
         lbne  L4D91
         tst   <u001D,u
         lbne  L4D91
         lda   <u0029,u
         stb   <u0029,u
         lbsr  L4F50
         bcc   L5001
         sta   <u0029,u
         rts
         tst   <u001D,u
         lbne  L4D91
         tst   u0008,u
         lbne  L4D91
         lda   #$01
         sta   <u001D,u
         clr   <u001E,u
         cmpu  <u001C
         beq   L505F
         ldd   u0004,u
         bra   L5071
L505F    ldd   <u0081
         ldx   u0004,u
         pshs  u
         ldu   <u001E
         cmpx  <u0015,u
         bne   L506F
         std   <u0015,u
L506F    puls  u
L5071    std   <u0015,u
         rts
         tst   <u001D,u
         lbne  L4D91
         tst   u0008,u
         lbne  L4D91
         lda   #$02
         sta   <u001D,u
         clr   <u001F,u
         cmpu  <u001C
         beq   L5093
         ldd   u0004,u
         bra   L50A5
L5093    ldd   <u0081
         ldx   u0004,u
         pshs  u
         ldu   <u001E
         cmpx  <u0013,u
         bne   L50A3
         std   <u0013,u
L50A3    puls  u
L50A5    std   <u0013,u
         rts
         lbsr  L5221
         bcc   L50CC
         lbsr  L1F92
         ldb   <u004B
         cmpa  >L05A1,pcr
         beq   L50EA
         ldb   <u004C
         cmpa  >L05A2,pcr
         beq   L50EA
         ldb   <u004D
         cmpa  >L05A3,pcr
         beq   L50EA
         lbra  L4D7B
L50CC    tstb
         lbeq  L4D7B
         cmpb  <u004B
         beq   L50EA
         cmpb  <u004C
         beq   L50EA
         cmpb  <u004D
         beq   L50EA
         cmpb  #$0C
         beq   L50EA
         cmpb  #$0A
         beq   L50EA
         lda   #$1E
         lbsr  L36AB
L50EA    stb   <u002D,u
         rts
         lbsr  L5221
         bcc   L5111
         lbsr  L1F92
         ldb   <u0050
         cmpa  >L05A3,pcr
         beq   L512F
         ldb   <u004E
         cmpa  >L05A1,pcr
         beq   L512F
         ldb   <u004F
         cmpa  >L05A2,pcr
         beq   L512F
         lbra  L4D7B
L5111    tstb
         lbeq  L4D7B
         cmpb  <u0050
         beq   L512F
         cmpb  <u004E
         beq   L512F
         cmpb  <u004F
         beq   L512F
         cmpb  #$06
         beq   L512F
         cmpb  #$08
         beq   L512F
         lda   #$23
         lbsr  L36AB
L512F    stb   <u002E,u
         rts
         tst   <u00D6
         bne   L513C
         lda   #$22
         lbra  L36AB
L513C    lda   #$01
         sta   <u0030,u
         tst   <u0060
         beq   L5158
         lda   <u0045
         bita  #$01
         bne   L5152
         lda   #$00
         sta   <u0030,u
         bra   L5158
L5152    bita  #$04
         lbeq  L1B14
L5158    rts
         clr   <u0030,u
         tst   <u0060
         beq   L5173
         tst   <u00DB
         beq   L5173
         clr   <u00D7
         clr   <u00D9
         lbsr  L1CCD
         lda   <u0045
         bita  #$04
         lbeq  L1B1D
L5173    rts
         bsr   L5186
         sta   <u0031,u
         rts
         bsr   L5186
         sta   <u0033,u
         rts
         bsr   L5186
         sta   <u0032,u
         rts
L5186    lda   ,x+
         cmpa  #$20
         beq   L5186
         cmpa  #$F0
         bne   L5191
         clra
L5191    rts
         lbsr  L5221
         lbcs  L4D7B
L5199    addb  <u002C,u
         cmpb  <u001B,u
         lbcc  L4FB8
         rts
         ldb   <u0035,u
         lbsr  L5025
         ldb   <u0037,u
         bsr   L5199
         ldb   <u0036,u
         lbra  L4F91
         clr   <u006C
L51B7    leax  $01,x
         lda   ,x
         cmpa  #$20
         beq   L51B7
         cmpa  #$2C
         beq   L51B7
         cmpa  #$2D
         bne   L51CB
         com   <u006C
         leax  $01,x
L51CB    bsr   L5221
         lbcs  L4D7B
         tst   <u006C
         beq   L51D7
         comb
         incb
L51D7    tst   u0008,u
         lbne  L4D91
         tst   <u001D,u
         lbne  L4D91
         lda   <u0029,u
         stb   <u0029,u
         lbsr  L4F50
         sta   <u0029,u
         lbcs  L4D86
         stb   <u0035,u
         rts
         bsr   L5221
         lbcs  L4D7B
         tstb
         bne   L5202
         incb
L5202    stb   <u0036,u
         rts
         bsr   L5221
         lbcs  L4D7B
         stb   <u0037,u
L520F    rts
         tst   <u0060
         beq   L520F
         lbra  L1B35
         bsr   L5221
         lbcs  L4D7B
         stb   <u002F,u
         rts
L5221    clra
         clrb
         std   <u006E
L5225    lda   ,x+
         cmpa  #$20
         beq   L5225
         cmpa  #$2C
         beq   L5225
         bra   L5235
L5231    lda   ,x+
         beq   L526E
L5235    cmpa  #$F0
         beq   L526E
         cmpa  #$0D
         beq   L526E
         cmpa  #$20
         beq   L526E
         cmpa  #$2C
         beq   L526E
         cmpa  #$2D
         beq   L526E
         cmpa  <u0031,u
         beq   L526E
         cmpa  #$30
         bcs   L5273
         cmpa  #$39
         bhi   L5273
         anda  #$0F
         pshs  a
         ldd   <u006E
         lslb
         rola
         lslb
         rola
         lslb
         rola
         addd  <u006E
         addd  <u006E
         addb  ,s+
         adca  #$00
         std   <u006E
         bra   L5231
L526E    andcc #$FE
         ldd   <u006E
         rts
L5273    orcc  #$01
         rts
         ldx   u0006,u
         cmpx  ,u
         bls   L52B8
L527C    lda   ,-x
         bmi   L527C
         cmpx  ,u
         bcs   L52B8
         cmpa  #$20
         beq   L529A
         cmpa  #$09
         beq   L529A
L528C    lda   ,-x
         bmi   L528C
         cmpx  ,u
         bcs   L52C4
         cmpa  #$20
         bne   L528C
         bra   L52C4
L529A    lda   ,-x
         cmpx  ,u
         bcs   L52B8
         cmpa  #$20
         beq   L529A
         cmpa  #$09
         beq   L529A
L52A8    lda   ,-x
         cmpx  ,u
         bls   L52C6
         cmpa  #$20
         beq   L52C4
         cmpa  #$09
         beq   L52C4
         bra   L52A8
L52B8    lda   <u00AA
         adda  <u0040
         sta   <u0085
         lbsr  L5361
         lbra  L2EA6
L52C4    leax  $01,x
L52C6    stx   u0006,u
         clr   <u0088
         clr   <u00D2
         lda   <u007E
         lbsr  L37D6
         lda   <u0039
         adda  <u00AA
         sta   <u0085
         lbra  L2EA6
         ldx   u0006,u
L52DC    lda   ,x+
         cmpa  #$09
         beq   L52F7
         tsta
         bpl   L52EF
         cmpa  #$F0
         beq   L52EF
         cmpa  #$F1
         beq   L52EF
         lda   ,x+
L52EF    cmpx  u0002,u
         bcc   L5317
         cmpa  #$20
         bne   L52DC
L52F7    lda   ,x+
         cmpa  #$20
         beq   L52F7
         cmpa  #$09
         beq   L52F7
         leax  -$01,x
         stx   u0006,u
         clr   <u00D2
         clr   <u0088
         lda   <u007E
         lbsr  L37D6
         lda   <u0039
         adda  <u00AA
         sta   <u0085
         lbra  L2EA6
L5317    lda   <u00AA
         sta   <u0085
         lbsr  L53F5
         lbra  L2EA6
         pshs  x
L5323    lbsr  L53F5
         bcs   L533A
         ldx   ,u
         lda   -$01,x
         cmpa  #$F0
         bne   L5323
         lda   ,x
         cmpa  #$F0
         beq   L5323
         cmpa  #$2C
         beq   L5323
L533A    puls  x
         lbra  L2EA6
         pshs  x
L5341    bsr   L5361
         bcs   L5357
         ldx   ,u
         lda   -$01,x
         cmpa  #$F0
         bne   L5341
         lda   ,x
         cmpa  #$F0
         beq   L5341
         cmpa  #$2C
         beq   L5341
L5357    puls  x
         lbra  L2EA6
         bsr   L5361
         lbra  L2EA6
L5361    tst   <u0083
         bne   L5369
         ldx   u000B,u
         bra   L536B
L5369    ldx   u0009,u
L536B    leax  -$01,x
         cmpx  #$FFFF
         beq   L5384
         pshs  x
         lbsr  L2F49
         ldu   <u001C
         puls  x
         ldy   <u001A
         tst   $08,y
         bne   L536B
         bra   L538C
L5384    lda   #$07
         lbsr  L36AB
         orcc  #$01
         rts
L538C    ldy   <u001A
         ldb   <u0038
         clra
         clr   <u0088
         tst   <u0083
         bne   L539E
         addd  $0B,y
         subd  u000B,u
         bra   L53A2
L539E    addd  $09,y
         subd  u0009,u
L53A2    bcc   L53CD
         cmpb  #$FF
         bne   L53B6
         inc   <u0074
         lbsr  L17FB
         beq   L53C0
         lda   #$01
         sta   <u00A8
         clrb
         bra   L53C9
L53B6    inc   <u0074
         lbsr  L17FB
         beq   L53C0
         incb
         bne   L53B6
L53C0    lda   #$01
         sta   <u0074
         sta   <u007C
         clr   <u00A8
         clrb
L53C9    lda   #$01
         sta   <u0088
L53CD    tfr   b,a
         clrb
         lbsr  L1742
         lbsr  L3025
         ldu   <u001C
         lbsr  L23D5
         lda   #$01
         sta   <u00D2
         lda   <u0038
         sta   <u007E
         lbsr  L37D6
         tst   <u007C
         beq   L53ED
         lbsr  L371D
L53ED    andcc #$FE
         rts
         bsr   L53F5
         lbra  L2EA6
L53F5    lbsr  L25FD
         bcc   L5400
         lbsr  L36AB
         orcc  #$01
         rts
L5400    tst   <u0083
         bne   L5411
         lda   [,u]
         cmpa  >L0594,pcr
         beq   L53F5
         tst   <u001D,u
         bne   L53F5
L5411    lda   <u0038
         clr   <u0088
         inca
         cmpa  <u003F
         bls   L5425
         lbsr  L17ED
         lda   #$01
         sta   <u0088
         sta   <u00A8
         lda   <u003F
L5425    clrb
         lbsr  L1742
         cmpa  <u0074
         bcs   L542F
         sta   <u0088
L542F    tst   u0008,u
         beq   L5444
         tst   <u0088
         beq   L53F5
         clr   <u00D2
         ldb   #$01
         stb   <u0088
         lda   <u0038
         lbsr  L37D6
         bra   L53F5
L5444    ldb   #$01
         stb   <u00D2
         lda   <u0038
         lbsr  L37D6
         lda   <u0038
         sta   <u007E
         tst   <u0088
         beq   L545A
         inca
         sta   <u0074
         sta   <u007C
L545A    andcc #$FE
         rts
L545D    bsr   L5462
         lbra  L2EA6
L5462    ldx   u0006,u
L5464    lda   ,x
         bpl   L5472
         cmpa  #$F0
         beq   L5472
         cmpa  #$F1
         beq   L5472
         leax  $01,x
L5472    leax  $01,x
         cmpx  u0002,u
         bcs   L5485
         lda   <u00AA
         sta   <u0085
         lbsr  L53F5
         bcc   L5484
         lbra  L2EA6
L5484    rts
L5485    lda   ,x
         cmpa  #$09
         beq   L5472
         cmpa  #$F1
         bne   L5496
         leay  $01,x
         cmpy  u0002,u
         bne   L5464
L5496    stx   u0006,u
         clr   <u00D2
         clr   <u0088
         lda   <u007E
         lbsr  L37D6
         lda   <u0039
         adda  <u00AA
         sta   <u0085
         rts
         bsr   L54AD
         lbra  L2EA6
L54AD    ldx   u0006,u
L54AF    cmpx  ,u
         bne   L54BD
         lda   <u00AA
         adda  <u0040
         sta   <u0085
         lbsr  L5361
         rts
L54BD    tst   ,-x
         bmi   L54AF
         lda   ,x
         cmpa  #$09
         beq   L54AF
         cmpx  ,u
         beq   L54DA
         lda   -$01,x
         cmpa  #$09
         beq   L54DA
         tsta
         bpl   L54DA
         cmpa  #$F1
         beq   L54DA
         leax  -$01,x
L54DA    stx   u0006,u
         clr   <u0088
         clr   <u00D2
         lda   <u007E
         lbsr  L37D6
         lda   <u0039
         adda  <u00AA
         sta   <u0085
         rts
         lda   <u00AA
         sta   <u0085
         lda   #$01
         sta   <u00D2
         clr   <u0088
         lda   <u007E
         lbsr  L37D6
         lbsr  L30EB
         lbsr  L1F76
         lbsr  L1F92
         cmpa  >CURLRC,pcr
         lbne  L2EB8
         lda   <u00AA
         adda  <u0040
         sta   <u0085
         lda   <u007E
         lbsr  L37D6
         lbra  L2EA6
         tst   <u0038
         bne   L5526
         lbsr  L53F5
         bcc   L5526
         lbra  L2EA6
L5526    lbsr  L17ED
         tst   <u00A8
         bne   L5539
         lda   <u0074
         deca
         cmpa  <u0038
         bls   L5539
         sta   <u0074
         lbra  L2EA6
L5539    lda   <u0038
         inca
         sta   <u0074
         sta   <u007C
         clr   <u00A8
         lbra  L2EA6
         tst   <u0083
         beq   L554D
         ldd   u0009,u
         bra   L554F
L554D    ldd   u000B,u
L554F    subb  <u0038
         sbca  #$00
         subd  #$0001
         bcc   L5560
         lda   #$07
         lbsr  L36AB
         lbra  L2EA6
L5560    pshs  b,a
         lda   <u0038
         cmpa  <u003F
         bne   L556B
         lbsr  L5361
L556B    lda   <u0074
         inca
         cmpa  <u003F
         bcc   L5574
         sta   <u0074
L5574    lbsr  L17FB
         beq   L5592
         lda   #$01
         sta   <u00A8
         puls  x
         lbsr  L2F49
         ldu   <u001A
         lbsr  L23D5
         lda   #$01
         sta   <u0088
         clra
         lbsr  L37D6
         lbra  L2EA6
L5592    lda   <u007E
         inca
         sta   <u007E
         inca
         sta   <u0074
         sta   <u007C
         clr   <u00A8
         lbsr  L3773
         lbra  L2E8B
         tst   <u0083
         beq   L55AC
         ldd   u0009,u
         bra   L55AE
L55AC    ldd   u000B,u
L55AE    cmpd  #$0001
         bne   L55BC
         lda   #$07
         lbsr  L36AB
         lbra  L2EA6
L55BC    subb  <u0038
         sbca  #$00
         subb  <u003F
         sbca  #$00
         bcc   L55C8
         clra
         clrb
L55C8    tfr   d,x
         clr   <u0055
         lbsr  L2F49
L55CF    tst   u0008,u
         bne   L55E6
         tst   <u0083
         bne   L5602
         lda   [,u]
         cmpa  >L0594,pcr
         beq   L55FD
         tst   <u001D,u
         beq   L5602
         bra   L55FD
L55E6    lda   <u0055
         cmpa  <u003F
         bcs   L55F4
         lbsr  L17ED
         lda   <u003F
         deca
         sta   <u0055
L55F4    ldb   #$01
         stb   <u0088
         lbsr  L37D6
         inc   <u0055
L55FD    lbsr  L25FD
         bra   L55CF
L5602    lbsr  L3025
         ldu   <u001C
         lda   <u0055
         sta   <u007E
         inca
         sta   <u0074
         sta   <u007C
         clr   <u00A8
         lbra  L2E8B
         lda   <u0038
         sta   <u0051
         bra   L5628
L561B    lda   <u0051
         cmpa  <u003F
         beq   L5641
         inc   <u0051
L5623    lbsr  L25FD
         bcs   L5641
L5628    tst   u0008,u
         beq   L563B
L562C    lda   [,u]
         cmpa  >L0594,pcr
         beq   L5623
         tst   <u001D,u
         bne   L5623
         bra   L561B
L563B    tst   <u0083
         beq   L562C
         bra   L561B
L5641    clr   <u007E
L5643    tst   u0008,u
         bne   L565A
         tst   <u0083
         bne   L5679
         tst   <u001D,u
         bne   L5672
         lda   [,u]
         cmpa  >L0594,pcr
         bne   L5679
         bra   L5672
L565A    ldb   #$01
         sta   <u0088
         clr   <u00D2
         lda   <u007E
         lbsr  L37D6
         lda   <u007E
         cmpa  <u003F
         bne   L5670
         lbsr  L17ED
         dec   <u007E
L5670    inc   <u007E
L5672    lbsr  L25FD
         bcs   L5679
         bra   L5643
L5679    tst   <u0083
         bne   L5691
         tst   <u001D,u
         bne   L568A
         lda   [,u]
         cmpa  >L0594,pcr
         bne   L5691
L568A    lda   #$01
         sta   <u0083
         lbsr  L3773
L5691    lda   <u007E
         inca
         sta   <u0074
         sta   <u007C
         lbra  L2E8B
         ldy   u0006,u
         lbsr  L3B96
         lbsr  L297B
         bcs   L56B7
         clr   u0006,u
         clr   <u0088
         stb   <u0085
         lda   #$01
         sta   <u00D2
         clr   <u0088
         lda   <u007E
         lbsr  L37D6
L56B7    lbra  L2EA6
         lda   <u007E
         lbsr  L1882
         lda   <u007E
         clrb
         lbsr  L1742
         ldx   >L05C2,pcr
         lbsr  L3E39
         ldx   <u0016
L56CE    lbsr  L1F76
         anda  #$7F
         cmpa  >ESCC,pcr
         lbeq  L2E8B
         cmpa  #$0D
         beq   L5707
         lbsr  L1709
         cmpa  #$30
         bcs   L56EE
         cmpa  #$39
         bhi   L56EE
         sta   ,x+
         bra   L56CE
L56EE    lbsr  L1F92
         cmpa  >L0569,pcr
         lbeq  L5701
         lda   #$21
         lbsr  L36AB
         lbra  L2E8B
L5701    clr   <u00AA
         ldd   <u0065
         bra   L5719
L5707    sta   ,x
         ldx   <u0016
         lbsr  L5221
         bcs   L56EE
         cmpd  #$0000
         beq   L5719
         subd  #$0001
L5719    std   <u00C1
         ldd   #$0000
         lbsr  L1742
         ldd   <u00C1
         cmpd  u000F,u
         bls   L577A
L5728    lbsr  L25FD
         bcc   L5737
         ldb   #$08
         stb   <u007E
         lbsr  L36AB
         lbra  L2E55
L5737    ldd   u000F,u
         cmpd  <u00C1
         bne   L5728
L573E    lda   #$01
         sta   <u0088
         lda   <u0038
         lbsr  L37D6
         lda   <u0038
         cmpa  <u003F
         bcs   L5750
         lbsr  L17ED
L5750    ldd   <u0038
         inca
         lbsr  L1742
L5756    lbsr  L25FD
         tst   u0008,u
         bne   L573E
         tst   <u0083
         bne   L576E
         tst   <u001D,u
         bne   L5756
         lda   [,u]
         cmpa  >L0594,pcr
         beq   L5756
L576E    lda   <u0038
         sta   <u007E
         inca
         sta   <u0074
         sta   <u007C
         lbra  L2E51
L577A    ldd   <u00C1
         subd  <u0065
         bcc   L5783
         ldd   #$0000
L5783    lda   #$38
         mul
         ldx   <u0086
         leax  d,x
         ldy   <u001A
         ldd   #$0038
         lbsr  L4D27
         lbsr  L3025
         bra   L573E
         lda   <u00AA
         cmpa  #$96
         bcc   L57A5
         adda  #$19
         sta   <u00AA
         lbra  L2E7B
L57A5    lda   #$02
         lbsr  L36AB
         lbra  L2EA6
         lda   <u00AA
         beq   L57A5
         suba  #$19
         bcs   L57A5
         sta   <u00AA
         lbra  L2E7B
L57BA    lda   #$01
         sta   <u00F7
         clr   <u00C5
L57C0    lbsr  L30EB
         clr   <u006D
         ldy   u0006,u
         pshs  y
         leay  $01,y
         cmpy  <u0077
         puls  y
         lbcc  L29B1
         ldb   ,y
         bpl   L57E3
         cmpb  #$F0
         beq   L57E3
         cmpb  #$F1
         beq   L57E3
         stb   <u006D
L57E3    lbsr  L1F76
         cmpa  >L057A,pcr
         bne   L57F0
         clr   <u00C5
         bra   L57E3
L57F0    cmpa  #$20
         lbcs  L585C
         cmpa  #$7F
         lbeq  L585C
         tst   <u00C5
         bne   L5827
         tst   <u006D
         beq   L5823
         pshs  a
         leay  $01,y
         ldx   u0006,u
         sty   u0006,u
L580D    cmpx  ,u
         beq   L5817
         lda   ,-x
         sta   ,-y
         bra   L580D
L5817    sty   ,u
         puls  a
         ldy   u0006,u
         sta   ,y
         bra   L5840
L5823    sta   ,y
         bra   L5840
L5827    tst   <u006D
         beq   L5833
         ldb   <u00C5
         stb   ,y
         sta   $01,y
         bra   L5840
L5833    pshs  a
         lda   <u00C5
         lbsr  L3666
         puls  a
         sta   ,y
         bra   L5840
L5840    lbsr  L2361
         lbsr  L2C78
         lbsr  L2DEC
         lda   #$01
         sta   <u0088
         clr   <u00D2
         ldu   <u001C
         lda   <u007E
         lbsr  L37D6
         lbsr  L5462
         lbra  L57C0
L585C    cmpa  >L057C,pcr
         lbeq  L58DF
         cmpa  #$0D
         beq   L58A6
         cmpa  >ESCC,pcr
         beq   L589B
         cmpa  >L0590,pcr
         lbeq  L58B6
         cmpa  >L057F,pcr
         beq   L58A0
         lbsr  L46D4
         tstb
         lbne  L57C0
         lbsr  L324D
         lbcc  L57C0
         lda   #$01
         sta   <u0088
         clr   <u00D2
         ldu   <u001C
         lda   <u007E
         lbsr  L37D6
         lbra  L57C0
L589B    clr   <u00F7
         lbra  L2E7B
L58A0    lbsr  L5462
         lbra  L57C0
L58A6    lda   #$F0
         lbsr  L3666
         ldy   u0006,u
         leay  -$01,y
         sty   u0006,u
         lbra  L5840
L58B6    pshs  y
         ldy   u0006,u
         lbsr  L3B96
         lbsr  L297B
         puls  y
         bcs   L58D7
         clr   <u0088
         stb   <u0085
         lda   #$01
         sta   <u00D2
         clr   <u0088
         lda   <u007E
         lbsr  L37D6
         lbra  L57BA
L58D7    lda   #$1D
         lbsr  L36AB
         lbra  L57C0
L58DF    lbsr  L54AD
         lbra  L57C0
         lbsr  L1F76
         cmpa  #$20
         lbcs  L2ECE
         cmpa  #$7F
         lbcc  L2ECE
         lbsr  L3666
         lbsr  L2C78
         lbsr  L2DEC
         tst   <u007C
         lbne  L2E8B
         lda   <u007E
         inca
         sta   <u007C
         sta   <u0074
         lbra  L2E8B
         ldx   #$0001
         ldu   <u001C
         cmpx  u0009,u
         bcc   L5922
         lbsr  L2F49
         lbsr  L3025
         lda   #$01
         sta   <u007E
         sta   <u0083
L5922    ldx   >L0604,pcr
         lbsr  L401D
         ldx   >L0600,pcr
         lbsr  L3E39
         ldx   >L0606,pcr
         lbsr  L3E39
L5937    lbsr  L3E5B
         lbsr  L1F92
         cmpa  #$0D
         beq   L5968
         cmpa  >YCHR,pcr
         beq   L5968
         cmpa  >NCHR,pcr
         beq   L5954
         lda   #$07
         lbsr  L0105
         bra   L5937
L5954    lbsr  L1709
         ldx   >L0608,pcr
         lbsr  L4022
         lbsr  L3EDE
         ldx   <u0016
         lbsr  L413A
         bra   L5977
L5968    lda   #$59
         lbsr  L1709
L596D    ldd   >L0600,pcr
         leax  >0,pcr
         leax  d,x
L5977    lbsr  L0259
         bcs   L5996
L597C    ldx   <u0016
L597E    lbsr  L0342
         bcs   L598D
         anda  #$7F
         sta   ,x+
         cmpa  #$0D
         bne   L597E
         bra   L59A8
L598D    pshs  cc
         lbsr  L02CD
         puls  cc
         bvs   L59A1
L5996    ldd   #$0000
         lbsr  L1742
         lbsr  L0324
         bra   L59CB
L59A1    lda   #$01
         sta   <u00D6
         lbra  L3E6A
L59A8    ldx   <u0016
         lda   ,x
         cmpa  #$0D
         beq   L597C
         bsr   L59DA
         bcs   L59CB
         ldy   <u0030
         lsla
         tfr   a,b
         clra
         leay  d,y
         bsr   L59DA
         bcs   L59CB
         sta   ,y
         bsr   L59DA
         bcs   L59CB
         sta   $01,y
         bra   L597C
L59CB    clr   <u00D6
         ldx   >L0602,pcr
         lbsr  L4027
         lbsr  L02CD
         lbra  L3E6A
L59DA    clr   <u006C
L59DC    lda   ,x
         cmpa  #$20
         beq   L59E6
         cmpa  #$2C
         bne   L59EA
L59E6    leax  $01,x
         bra   L59DC
L59EA    leax  $01,x
         cmpa  #$2D
         bne   L59F4
         inc   <u006C
         lda   ,x+
L59F4    cmpa  #$24
         beq   L5A0D
         cmpa  #$27
         beq   L5A09
         leax  -$01,x
         lbsr  L5221
         bcs   L5A62
         tfr   b,a
         leax  -$01,x
         bra   L5A36
L5A09    lda   ,x+
         bra   L5A36
L5A0D    lda   ,x+
         bsr   L5A65
         bcs   L5A62
         sta   <u006D
         lda   ,x+
         cmpa  #$20
         beq   L5A34
         cmpa  <u0031,u
         beq   L5A34
         cmpa  #$2C
         beq   L5A34
         bsr   L5A65
         bcs   L5A62
         lsl   <u006D
         lsl   <u006D
         lsl   <u006D
         lsl   <u006D
         adda  <u006D
         bra   L5A36
L5A34    lda   <u006D
L5A36    tst   <u006C
         beq   L5A3C
         suba  #$40
L5A3C    anda  #$7F
         sta   <u006D
L5A40    lda   ,x
         cmpa  #$20
         beq   L5A57
         cmpa  #$2C
         beq   L5A57
         cmpa  <u0031,u
         beq   L5A5B
         cmpa  #$0D
         beq   L5A57
         cmpa  #$F0
         bne   L5A5D
L5A57    leax  $01,x
         bra   L5A40
L5A5B    leax  $01,x
L5A5D    lda   <u006D
         andcc #$FE
         rts
L5A62    orcc  #$01
         rts
L5A65    cmpa  #$30
         bcs   L5A82
         cmpa  #$39
         bhi   L5A72
         suba  #$30
         andcc #$FE
         rts
L5A72    lbsr  L1F92
         cmpa  #$41
         bcs   L5A72
         cmpa  #$46
         bhi   L5A82
         suba  #$37
         andcc #$FE
         rts
L5A82    orcc  #$01
         rts
L5A85    stb   <u00E3
         tfr   x,d
         leax  >0,pcr
         leax  d,x
         lda   #$04
L5A91    ldb   #$02
         lbsr  L1742
         lbsr  L3E54
         lda   <u0038
         inca
         ldb   <u0038
         subb  #$03
         cmpb  <u00E3
         bne   L5A91
         ldd   #$1303
         lbsr  L1742
         ldx   >L0646,pcr
         lbsr  L3E39
L5AB1    clr   <u00E4
L5AB3    lda   #$20
         lbsr  L1709
         lda   <u00E4
         adda  #$04
         clrb
         lbsr  L1742
         lda   #$3E
         lbsr  L1709
         ldd   <u0038
         decb
         lbsr  L1742
L5ACB    lbsr  L0131   Read keyboard
         lbsr  L1F92
         cmpa  #$0D
         beq   L5B0D
         cmpa  >ESCC,pcr
         beq   L5B10
         cmpa  >CURUC,pcr
         beq   L5AFE
         cmpa  >CTRTBL,pcr
         beq   L5AFE
         cmpa  >L057E,pcr
         beq   L5AF3
         cmpa  >CURDC,pcr
         bne   L5ACB
L5AF3    lda   <u00E4
         inca
         cmpa  <u00E3
         bcc   L5AB1
         inc   <u00E4
         bra   L5AB3
L5AFE    tst   <u00E4
         bne   L5B09
         lda   <u00E3
         deca
         sta   <u00E4
         bra   L5AB3
L5B09    dec   <u00E4
         bra   L5AB3
L5B0D    lda   <u00E4
         rts
L5B10    clra
         rts
L5B12    clrb
         lda   #$04
L5B15    clrb
         lbsr  L1742
         lda   #$20
         lbsr  L1709
         lda   <u0038
         inca
         ldb   <u0038
         subb  #$04
         cmpb  <u00E3
         bne   L5B15
         bra   L5AB1
L5B2B    clr   <u0061
         clr   <u0062
         ldd   u000F,u
         cmpd  <u0065
         bne   L5B40
         ldx   >L0624,pcr
         lbsr  L401D
         lbra  L5BDD
L5B40    clra
         lbsr  L1882
         ldx   >L0626,pcr
         lbsr  L401D
         lbsr  L3E5B
         lbsr  L1F92
         cmpa  >ESCC,pcr
         lbeq  L3E6A
         cmpa  >NCHR,pcr
         lbeq  L5C1F
         cmpa  #$0D
         beq   L5B72
         cmpa  >YCHR,pcr
         beq   L5B72
L5B6B    lda   #$07
         lbsr  L0105
         bra   L5B2B
L5B72    lda   >YCHR,pcr
         lbsr  L0105
         inc   <u0061
         tst   <u0064
         bne   L5BDD
         tst   <u0075
         beq   L5BB4
         ldx   >L0628,pcr
         lbsr  L4022
         ldx   <u002C
         lbsr  L3E54
         ldx   >L062A,pcr
         lbsr  L3E39
         lbsr  L3E5B
         lbsr  L1F92
         cmpa  >ESCC,pcr
         lbeq  L3E6A
         cmpa  >YCHR,pcr
         beq   L5BDD
         cmpa  #$0D
         beq   L5BDD
         cmpa  >NCHR,pcr
         bne   L5B6B
L5BB4    lda   #$01
         lbsr  L1882
         ldx   >L05E0,pcr
         lbsr  L4022
         lbsr  L3EDE
         leax  -$01,x
         cmpx  <u0016
         lbeq  L3E6A
         ldx   <u0016
         lbsr  L413A
         ldy   <u002C
         ldd   #$0036
         lbsr  L4D27
         lda   #$02
         sta   <u0075
L5BDD    tst   <u0063
         bne   L5BEA
         ldx   >L0632,pcr
         lbsr  L4027
         bra   L5C22
L5BEA    ldx   >L062C,pcr
         lbsr  L4027
         lbsr  L3E5B
         lbsr  L1F92
         cmpa  >ESCC,pcr
         lbeq  L3E6A
         cmpa  >YCHR,pcr
         beq   L5C14
         cmpa  #$0D
         beq   L5C14
         cmpa  >NCHR,pcr
         bne   L5BEA
         lbsr  L1709
         bra   L5C22
L5C14    lda   >YCHR,pcr
         lbsr  L1709
         inc   <u0062
         bra   L5C22
L5C1F    lbsr  L1709
L5C22    tst   <u0061
         lbeq  L5D4C
         tst   <u0064
         bne   L5C8C
L5C2C    ldx   <u002C
         lbsr  L021B
         bcc   L5C8A
         lbvc  L5E1A
         ldx   <u002C
L5C39    lbsr  L036D
         bcc   L5C2C
         lbvc  L5E1A
L5C42    ldx   >L05DE,pcr
         lbsr  L402C
         lbsr  L3E5B
         lbsr  L1F92
         cmpa  >ESCC,pcr
         lbeq  L3E6A
         cmpa  >NCHR,pcr
         lbeq  L5C7B
         cmpa  >YCHR,pcr
         beq   L5C69
         cmpa  #$0D
         bne   L5C42
L5C69    lda   >YCHR,pcr
         lbsr  L0105
         ldx   <u002C
         lbsr  L02F1
         lbcs  L5E1A
         bra   L5C39
L5C7B    ldx   >L05DA,pcr
         lbsr  L402C
         lda   #$07
         lbsr  L0105
         lbra  L3E6A
L5C8A    inc   <u0064
L5C8C    ldu   <u001C
         ldd   u000F,u
         subd  <u0065
         lda   #$38
         mul
         ldy   <u0086
         leay  d,y
         sty   <u006A
         ldx   $04,y
         stx   <u0068
         ldu   <u006A
         ldx   <u0013,u
         beq   L5CBD
         cmpx  <u0034
         beq   L5CBD
         ldy   <u0034
         sty   <u0013,u
         ldd   #$00F8
         lbsr  L4D27
         lda   #$F0
         sta   ,y
L5CBD    ldx   <u0015,u
         beq   L5CD7
         cmpx  <u0032
         beq   L5CD7
         ldy   <u0032
         sty   <u0015,u
         ldd   #$00F8
         lbsr  L4D27
         lda   #$F0
         sta   ,y
L5CD7    ldx   <u0070
L5CD9    cmpx  <u0068
         bcc   L5CFB
         lda   ,x+
         cmpa  #$F0
         bne   L5CE5
         lda   #$0D
L5CE5    lbsr  L0311
         bcc   L5CD9
         ldd   #$0200
         lbsr  L1742
         lbsr  L0324
         lbsr  L02D5
         clr   <u0064
         lbra  L3E6A
L5CFB    ldy   <u001A
         ldx   <u006A
         ldd   #$0038
         lbsr  L4D27
         lbsr  L3025
         ldy   <u0070
         sty   <u0081
         ldu   <u001C
         ldx   #$0000
         stx   ,u
         stx   u0009,u
         stx   u000B,u
         ldy   <u0086
         ldx   <u001C
         ldd   #$0038
         lbsr  L4D27
         ldy   <u0086
         ldd   $0F,y
         std   <u0065
         ldd   <u0070
         std   $04,y
         ldd   u000F,u
         std   <u0094
         ldd   #$FFFF
         std   <u0092
         ldx   <u0024
         stx   <u0098
         clr   <u00A5
         clr   <u009A
         ldu   <u001C
L5D43    tst   u0008,u
         beq   L5D4C
         lbsr  L25FD
         bra   L5D43
L5D4C    tst   <u0062
         lbeq  L3E6A
L5D52    ldu   <u001C
         tst   u0008,u
         beq   L5D5C
         ldd   u0004,u
         bra   L5D5E
L5D5C    ldd   ,u
L5D5E    std   <u006E
         ldx   <u0081
         leax  >$01F4,x
         cmpx  <u006E
         bcs   L5D79
         leax  >L062E,pcr
         lbsr  L402C
         lda   #$07
         lbsr  L0105
         lbra  L3E6A
L5D79    ldd   <u0077
         subd  #$0001
         subd  <u006E
         ldx   <u006E
         ldy   <u0081
         lbsr  L4D27
         ldx   <u0077
         leax  <-$64,x
         stx   <u006E
         leax  <-$32,x
         stx   <u006A
         leax  >-$03E8,x
         stx   <u0068
         tfr   y,x
         tst   <u0062
         bne   L5DB1
L5DA0    lbsr  L032F
         bcs   L5DD6
         cmpa  #$09
         beq   L5DB3
         bita  #$60
         bne   L5DB3
         cmpa  #$0D
         bne   L5DA0
L5DB1    lda   #$F0
L5DB3    sta   ,x+
         cmpx  <u0068
         bcs   L5DA0
         cmpa  #$F0
         bne   L5DC1
         inc   <u00F0
         bra   L5DE7
L5DC1    cmpx  <u006A
         bcs   L5DA0
         cmpa  #$20
         bne   L5DCD
         inc   <u00F0
         bra   L5DE7
L5DCD    cmpx  <u006E
         bcs   L5DA0
         tsta
         bmi   L5DA0
         bra   L5DE7
L5DD6    bvs   L5DE2
         ldx   >L05EC,pcr
         lbsr  L4027
         lbsr  L0324
L5DE2    lbsr  L02BD
         clr   <u0063
L5DE7    tfr   x,d
         subd  <u0081
         ldy   <u0077
         pshs  a
         lda   -$01,x
         cmpa  #$F0
         puls  a
         beq   L5DFA
         leay  -$01,y
L5DFA    lbsr  L4D14
         ldu   <u001C
         tst   u0008,u
         bne   L5E08
         sty   ,u
         bra   L5E0B
L5E08    sty   u0004,u
L5E0B    lbsr  L23D5
         lbsr  L2C78
L5E11    tst   <u00E5
         lbeq  L5E55
         lbra  L3E6A
L5E1A    lda   #$02
         lbsr  L1882
         lda   #$03
         lbsr  L1882
         ldx   >L0630,pcr
         lbsr  L3E39
         lbsr  L0324
         bra   L5E11
L5E30    tst   <u0075
         lbeq  L5E55
L5E36    clr   <u00F0
         clr   <u00EF
         ldx   <u002A
         lbsr  L0287
         bcc   L5E50
         bvc   L5E47
         inc   <u00EF
         bra   L5E55
L5E47    lbsr  L0324
         lbsr  L183B
         lbra  L0355
L5E50    inc   <u0063
         lbra  L5D52
L5E55    inc   <u00E5
         tst   >L0011,pcr
         lbeq  L3E61
         lbsr  L17D7
         clr   <u00E3
         lda   #$FF
         sta   <u0074
         lbra  L596D
         lbsr  L1F76
         lbsr  L1F92
         cmpa  #$43
         beq   L5E7C
         cmpa  #$52
         lbeq  L5F16
         rts
L5E7C    leas  <-$39,s
         leay  ,s
         clr   <$1B,y
         ldx   ,u
         ldb   #$00
L5E88    lda   ,x+
         cmpa  #$09
         bne   L5E8F
         incb
L5E8F    cmpx  u0006,u
         bls   L5E88
         stb   <$27,y
         ldx   u0009,u
L5E98    leax  -$01,x
         stx   <$25,y
         beq   L5EEF
         pshs  y
         lbsr  L2F49
         lbsr  L23D5
         puls  y
         ldx   ,u
         ldb   <$27,y
         beq   L5EBD
L5EB0    cmpx  u0002,u
         bcc   L5EEF
         lda   ,x+
         cmpa  #$09
         bne   L5EB0
         decb
         bne   L5EB0
L5EBD    leau  ,x
         lbsr  L64E6
         leau  -u0001,u
         bcs   L5ED9
         cmpa  #$2D
         beq   L5ED9
         cmpa  #$2B
         beq   L5ED9
         cmpa  #$2E
         beq   L5ED9
         lbsr  L28D7
         bcs   L5EEF
         leau  u0001,u
L5ED9    lbsr  L642F
         leax  <$1B,y
         lbsr  L6125
         leax  <$1B,y
         lbsr  L637A
         ldu   <u001A
         ldx   <$25,y
         bra   L5E98
L5EEF    bsr   L5EF5
         leas  <$39,s
         rts
L5EF5    leax  <$1B,y
         lbsr  L6363
         leau  <$25,y
         lbsr  L64F6
         leax  <$25,y
         leax  $01,x
         ldu   <u001C
L5F08    lda   ,x+
         beq   L5F15
         pshs  x
         lbsr  L3666
         puls  x
         bra   L5F08
L5F15    rts
L5F16    leas  <-$39,s
         leay  ,s
         clr   <$1B,y
         ldx   ,u
L5F20    lda   ,x+
         cmpa  >L0595,pcr
         beq   L5F30
         cmpx  u0002,u
         bne   L5F20
         ldx   ,u
         bra   L5F4C
L5F30    lda   ,x+
         cmpa  >L0595,pcr
         bne   L5F20
         ldd   u0006,u
         leax  -$02,x
         stx   u0006,u
         pshs  y,b,a
         lbsr  L347B
         lbsr  L347B
         ldx   u0006,u
         puls  y,b,a
         std   u0006,u
L5F4C    ldd   u0006,u
         std   <$19,y
         leau  ,x
L5F53    bsr   L5F84
         bcc   L5F53
         bsr   L5F5D
         leas  <$39,s
         rts
L5F5D    leax  <$1B,y
         lbsr  L6363
         leau  <$25,y
         lbsr  L64F6
         leax  <$25,y
         ldu   <u001C
L5F6E    lda   ,x+
         beq   L5F7B
         pshs  x
         lbsr  L3666
         puls  x
         bra   L5F6E
L5F7B    lda   #$20
         pshs  x
         lbsr  L3666
         puls  pc,x
L5F84    clr   <$25,y
L5F87    cmpu  <$19,y
         bcc   L6004
         lbsr  L64E6
         bcs   L5FC7
         cmpa  #$2D
         bne   L5F9F
         pshs  u,a
         lbsr  L64E6
         puls  u,a
         bcs   L5FC7
L5F9F    cmpa  #$2B
         bne   L5FAC
         pshs  u,a
         lbsr  L64E6
         puls  u,a
         bcs   L5FC7
L5FAC    cmpa  #$2E
         beq   L5FC7
         ldb   #$01
         cmpa  #$2D
         beq   L5FC2
         ldb   #$02
         cmpa  #$2A
         beq   L5FC2
         ldb   #$03
         cmpa  #$2F
         bne   L5F87
L5FC2    stb   <$25,y
         bra   L5F87
L5FC7    leau  -u0001,u
         lbsr  L642F
         leau  -u0001,u
         leax  <$20,y
         lbsr  L637A
         leax  <$1B,y
         lda   <$25,y
         cmpa  #$03
         beq   L5FEB
         cmpa  #$02
         beq   L5FF3
         cmpa  #$01
         beq   L5FF8
         lbsr  L6125
         bra   L5FFB
L5FEB    lbsr  L6288
         lbsr  L62E1
         bra   L5FFB
L5FF3    lbsr  L622E
         bra   L5FFB
L5FF8    lbsr  L611B
L5FFB    leax  <$1B,y
         lbsr  L637A
         andcc #$FE
         rts
L6004    orcc  #$01
         rts
         ldy   <u0016
         leay  <$64,y
L600D    clr   <$1B,y
         clr   <$20,y
L6013    lbsr  L4CD7
         ldd   #$0000
         lbsr  L1742
         leax  >L6093,pcr
         lbsr  L3E54
         ldd   #$0100
         lbsr  L1742
         leax  >L60D3,pcr
         lbsr  L3E54
         leax  <$20,y
         lbsr  L6363
         leau  <$25,y
         lbsr  L64F6
         leax  <$25,y
         lbsr  L3E54
         ldd   #$0200
         lbsr  L1742
         leax  >L60F7,pcr
         lbsr  L3E54
         leax  <$1B,y
         lbsr  L6363
         leau  <$25,y
         lbsr  L64F6
         leax  <$25,y
         lbsr  L3E54
         lda   #$20
         lbsr  L1709
         pshs  y
         lbsr  L3EDE
         puls  y
         stx   <$19,y
         ldu   <u0016
         lda   ,u
         cmpa  #$0D
         beq   L6013
         cmpa  #$43
         beq   L600D
         cmpa  #$63
         beq   L600D
         cmpa  #$53
         beq   L6088
         cmpa  #$73
         bne   L608E
L6088    lbsr  L5F5D
         lbra  L2E55
L608E    lbsr  L5F84
         bra   L6013
L6093   fcc '"+" ADD  | "-" SUBt  -- Calculator ----------------------------'
 fcb 0
L60D3 fcc '"*" MULT | "/" DIV   |  Last Entry:'
 fcb 0

L60F7 fcc '"S" Save   "C" Clear |       TOTAL:'
 fcb 0

L611B    lbsr  L6288
         com   $05,y
         com   <$12,y
         bra   L6128
L6125    lbsr  L6288
L6128    tstb
         lbeq  L6393
         leax  $06,y
L612F    tfr   a,b
L6131    tstb
         beq   L61A3
         subb  ,y
         beq   L61A6
         bcs   L6143
         sta   ,y
         lda   $0B,y
         sta   $05,y
         leax  ,y
         negb
L6143    cmpb  #$F8
         ble   L61A6
L6147    clra
         lsr   $01,x
         lbsr  L6223
L614D    ldb   <$12,y
         bpl   L615D
         com   $01,x
         com   $02,x
         com   $03,x
         com   $04,x
         coma
         adca  #$00
L615D    sta   <$11,y
         lda   $04,y
         adca  $0A,y
         sta   $04,y
         lda   $03,y
         adca  $09,y
         sta   $03,y
         lda   $02,y
         adca  $08,y
         sta   $02,y
         lda   $01,y
         adca  $07,y
         sta   $01,y
         tstb
         bpl   L61C5
L617B    bcs   L617F
         bsr   L61E8
L617F    clrb
L6180    lda   $01,y
         bne   L61B7
L6184    lda   $02,y
         sta   $01,y
         lda   $03,y
         sta   $02,y
         lda   $04,y
         sta   $03,y
         lda   <$11,y
         sta   $04,y
         clr   <$11,y
         addb  #$08
         cmpb  #$28
         blt   L6180
L619E    clra
         sta   ,y
         sta   $05,y
L61A3    andcc #$FE
         rts
L61A6    bsr   L6216
         clrb
         bra   L614D
L61AB    incb
         lsl   <$11,y
         rol   $04,y
         rol   $03,y
         rol   $02,y
         rol   $01,y
L61B7    bpl   L61AB
         lda   ,y
         pshs  b
         suba  ,s+
         sta   ,y
         bls   L619E
         andcc #$FE
L61C5    bcs   L61D1
         lsl   <$11,y
         lda   #$00
         sta   <$11,y
         bra   L61DF
L61D1    inc   ,y
         lbeq  L62BD
         ror   $01,y
         ror   $02,y
         ror   $03,y
         ror   $04,y
L61DF    bcc   L61E5
         bsr   L61F2
         beq   L61D1
L61E5    andcc #$FE
         rts
L61E8    com   $05,y
L61EA    com   $01,y
         com   $02,y
         com   $03,y
         com   $04,y
L61F2    ldx   $03,y
         leax  $01,x
         stx   $03,y
         bne   L6200
         ldx   $01,y
         leax  $01,x
         stx   $01,y
L6200    rts
L6201    leax  $0C,y
L6203    lda   $04,x
         sta   <$11,y
         lda   $03,x
         sta   $04,x
         lda   $02,x
         sta   $03,x
         lda   $01,x
         sta   $02,x
         clr   $01,x
L6216    addb  #$08
         ble   L6203
         lda   <$11,y
         subb  #$08
         beq   L622D
L6221    asr   $01,x
L6223    ror   $02,x
         ror   $03,x
         ror   $04,x
         rora
         incb
         bne   L6221
L622D    rts
L622E    bsr   L6288
         beq   L6287
         bsr   L62A2
         lda   #$00
         sta   $0D,y
         sta   $0E,y
         sta   $0F,y
         sta   <$10,y
         ldb   $04,y
         bsr   L6255
         ldb   $03,y
         bsr   L6255
         ldb   $02,y
         bsr   L6255
         ldb   $01,y
         bsr   L6255
         lbsr  L635A
         lbra  L617F
L6255    beq   L6201
         coma
L6258    lda   $0D,y
         rorb
         beq   L6287
         bcc   L6277
         lda   <$10,y
         adda  $0A,y
         sta   <$10,y
         lda   $0F,y
         adca  $09,y
         sta   $0F,y
         lda   $0E,y
         adca  $08,y
         sta   $0E,y
         lda   $0D,y
         adca  $07,y
L6277    rora
         sta   $0D,y
         ror   $0E,y
         ror   $0F,y
         ror   <$10,y
         ror   <$11,y
         clra
         bra   L6258
L6287    rts
L6288    ldd   $01,x
         sta   $0B,y
         ora   #$80
         std   $07,y
         ldb   $0B,y
         eorb  $05,y
         stb   <$12,y
         ldd   $03,x
         std   $09,y
         lda   ,x
         sta   $06,y
         ldb   ,y
         rts
L62A2    tsta
         beq   L62B7
         adda  ,y
         rora
         rola
         bvc   L62B7
         adda  #$80
         sta   ,y
         beq   L62B9
         lda   <$12,y
         sta   $05,y
         rts
L62B7    leas  $02,s
L62B9    lbpl  L619E
L62BD    orcc  #$01
         rts
L62C0    lbsr  L63A9
         beq   L62D3
         adda  #$02
         bcs   L62BD
         clr   <$12,y
         lbsr  L612F
         inc   ,y
         beq   L62BD
L62D3    rts
L62D4    lbsr  L63A9
         leax  >L65EA,pcr
         clr   <$12,y
         lbsr  L6363
L62E1    lbeq  L62BD
         neg   ,y
         bsr   L62A2
         inc   ,y
         beq   L62BD
         leax  $0D,y
         ldb   #$04
         stb   <$13,y
         ldb   #$01
L62F6    lda   $01,y
         cmpa  $07,y
         bne   L630F
         lda   $02,y
         cmpa  $08,y
         bne   L630F
         lda   $03,y
         cmpa  $09,y
         bne   L630F
         lda   $04,y
         cmpa  $0A,y
         bne   L630F
         coma
L630F    tfr   cc,a
         rolb
         bcc   L631F
         stb   ,x+
         dec   <$13,y
         bmi   L634F
         beq   L634B
         ldb   #$01
L631F    tfr   a,cc
         bcs   L6331
L6323    lsl   $0A,y
         rol   $09,y
         rol   $08,y
         rol   $07,y
         bcs   L630F
         bmi   L62F6
         bra   L630F
L6331    lda   $0A,y
         suba  $04,y
         sta   $0A,y
         lda   $09,y
         sbca  $03,y
         sta   $09,y
         lda   $08,y
         sbca  $02,y
         sta   $08,y
         lda   $07,y
         sbca  $01,y
         sta   $07,y
         bra   L6323
L634B    ldb   #$40
         bra   L631F
L634F    rorb
         rorb
         rorb
         stb   <$11,y
         bsr   L635A
         lbra  L617F
L635A    ldx   $0D,y
         stx   $01,y
         ldx   $0F,y
         stx   $03,y
         rts
L6363    pshs  a
         ldd   $01,x
         sta   $05,y
         ora   #$80
         std   $01,y
         clr   <$11,y
         ldb   ,x
         ldx   $03,x
         stx   $03,y
         stb   ,y
         puls  pc,a
L637A    lda   ,y
         sta   ,x
         lda   $05,y
         ora   #$7F
         anda  $01,y
         sta   $01,x
         lda   $02,y
         sta   $02,x
         lda   $03,y
         sta   $03,x
         lda   $04,y
         sta   $04,x
         rts
L6393    lda   $0B,y
         sta   $05,y
         ldx   $06,y
         stx   ,y
         clr   <$11,y
         lda   $08,y
         sta   $02,y
         lda   $05,y
         ldx   $09,y
         stx   $03,y
         rts
L63A9    ldd   ,y
         std   $06,y
         ldx   $02,y
         stx   $08,y
         ldx   $04,y
         stx   $0A,y
         tsta
         rts
L63B7    ldb   ,y
         beq   L63C3
         ldb   $05,y
L63BD    rolb
         ldb   #$FF
         bcs   L63C3
         negb
L63C3    rts
         bsr   L63B7
L63C6    stb   $01,y
         clr   $02,y
         ldb   #$88
         lda   $01,y
         suba  #$80
         stb   ,y
         ldd   #$0000
         std   $03,y
         sta   <$11,y
         sta   $05,y
         lbra  L617B
L63DF    ldb   ,y
         cmpb  ,x
         bne   L6402
         ldb   $01,x
         orb   #$7F
         andb  $01,y
         cmpb  $01,x
         bne   L6402
         ldb   $02,y
         cmpb  $02,x
         bne   L6402
         ldb   $03,y
         cmpb  $03,x
         bne   L6402
         ldb   $04,y
         subb  $04,x
         bne   L6402
         rts
L6402    rorb
         eorb  $05,y
         bra   L63BD
L6407    ldb   ,y
         beq   L6426
         subb  #$A0
         lda   $05,y
         bpl   L6414
         lbsr  L61EA
L6414    leax  ,y
         cmpb  #$F8
         bgt   L641E
         lbsr  L6216
         rts
L641E    lda   $05,y
         rola
         ror   $01,y
         lbra  L6223
L6426    stb   $01,y
         stb   $02,y
         stb   $03,y
         stb   $04,y
         rts
L642F    ldd   #$0000
         std   ,y
         std   $01,y
         std   $03,y
         std   <$16,y
         std   <$14,y
         sta   <$18,y
         lbsr  L64E6
         bcs   L64B1
         cmpa  #$2D
         bne   L644F
         com   <$18,y
         bra   L6453
L644F    cmpa  #$2B
         bne   L6458
L6453    lbsr  L64E6
         bcs   L64B1
L6458    cmpa  #$2E
         beq   L6481
         cmpa  #$45
         bne   L6486
         lbsr  L64E6
         bcs   L64D2
         cmpa  #$2D
         beq   L646F
         cmpa  #$2B
         beq   L6472
         bra   L6477
L646F    com   <$17,y
L6472    lbsr  L64E6
         bcs   L64D2
L6477    tst   <$17,y
         beq   L6486
         neg   <$16,y
         bra   L6486
L6481    com   <$15,y
         bne   L6453
L6486    lda   <$16,y
         suba  <$14,y
         sta   <$16,y
         beq   L64A5
         bpl   L649D
L6493    lbsr  L62D4
         inc   <$16,y
         bne   L6493
         bra   L64A5
L649D    lbsr  L62C0
         dec   <$16,y
         bne   L649D
L64A5    lda   <$18,y
         beq   L64B0
         lda   ,y
         beq   L64B0
         com   $05,y
L64B0    rts
L64B1    ldb   <$14,y
         subb  <$15,y
         stb   <$14,y
         pshs  a
         lbsr  L62C0
         puls  b
         subb  #$30
         leax  $0C,y
         lbsr  L637A
         lbsr  L63C6
         leax  $0C,y
         lbsr  L6125
         bra   L6453
L64D2    ldb   <$16,y
         lslb
         lslb
         addb  <$16,y
         lslb
         suba  #$30
         pshs  b
         adda  ,s+
         sta   <$16,y
         bra   L6472
L64E6    lda   ,u+
         cmpa  #$30
         bcs   L64F3
         cmpa  #$39
         bhi   L64F3
         orcc  #$01
         rts
L64F3    andcc #$FE
         rts
L64F6    lda   #$20
         ldb   $05,y
         bpl   L64FE
         lda   #$2D
L64FE    sta   ,u+
         stu   <$19,y
         sta   $05,y
         lda   #$30
         ldb   ,y
         lbeq  L65E5
         clra
         cmpb  #$80
         bhi   L651B
         leax  >L65F9,pcr
         lbsr  L622E
         lda   #$F7
L651B    sta   <$14,y
L651E    leax  >L65F4,pcr
         lbsr  L63DF
         bgt   L6538
L6527    leax  >L65EF,pcr
         lbsr  L63DF
         bgt   L6540
         lbsr  L62C0
         dec   <$14,y
         bra   L6527
L6538    lbsr  L62D4
         inc   <$14,y
L653E    bra   L651E
L6540    leax  >L65FE,pcr
         lbsr  L6125
         lbsr  L6407
         ldb   #$01
         lda   <$14,y
         adda  #$0A
         bmi   L655C
         cmpa  #$0B
         bcc   L655C
         deca
         tfr   a,b
         lda   #$02
L655C    deca
         deca
         sta   <$16,y
         stb   <$14,y
         bgt   L6574
         ldu   <$19,y
         lda   #$2E
         sta   ,u+
         tstb
         beq   L6574
         lda   #$30
         sta   ,u+
L6574    leax  >L6603,pcr
         ldb   #$80
L657A    lda   $04,y
         adda  $03,x
         sta   $04,y
         lda   $03,y
         adca  $02,x
         sta   $03,y
         lda   $02,y
         adca  $01,x
         sta   $02,y
         lda   $01,y
         adca  ,x
         sta   $01,y
         incb
         rorb
         rolb
         bvc   L657A
         bcc   L659C
         subb  #$0B
         negb
L659C    addb  #$2F
         leax  $04,x
         tfr   b,a
         anda  #$7F
         sta   ,u+
         dec   <$14,y
         bne   L65AF
         lda   #$2E
         sta   ,u+
L65AF    comb
         andb  #$80
         lda   ,x
         cmpa  #$01
         bne   L657A
L65B8    lda   ,-u
         cmpa  #$30
         beq   L65B8
         cmpa  #$2E
         bne   L65C4
         leau  -u0001,u
L65C4    lda   #$2B
         ldb   <$16,y
         beq   L65E7
         bpl   L65D0
         lda   #$2D
         negb
L65D0    sta   u0002,u
         lda   #$45
         sta   u0001,u
         lda   #$2F
L65D8    inca
         subb  #$0A
         bcc   L65D8
         addb  #$3A
         std   u0003,u
         clr   u0005,u
         bra   L65E9
L65E5    sta   ,u
L65E7    clr   u0001,u
L65E9    rts

L65EA fcb $84,$20,$00,$00,$00
L65EF fcb $9B,$3E,$BC,$1F,$FD
L65F4 fcb $9E,$6E,$6B,$27,$FD
L65F9 fcb $9E,$6E,$6B,$28,$00
L65FE fcb $80,$00,$00,$00,$00
L6603 fcb $FA
      fcb $0A,$1F,$00,$00,$98,$96,$80,$FF,$F0,$BD,$C0,$00,$01
      fcb $86,$A0,$FF,$FF,$D8,$F0,$00,$00,$03,$E8,$FF,$FF,$FF
      fcb $9C,$00,$00,$00,$0A,$FF,$FF,$FF,$FF,$01
         emod
BINEND      equ   *
