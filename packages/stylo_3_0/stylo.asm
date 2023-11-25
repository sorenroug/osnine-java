     nam   Stylo
     ttl  Stylograph 3

 use defsfile

tylg     set   Prgrm+Objct
atrv     set   ReEnt+0

         mod   BINEND,name,tylg,atrv,start,size

u0000    rmb   1
u0001    rmb   1
u0002    rmb   1
u0003    rmb   1
u0004    rmb   2
u0006    rmb   2
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
u0038    rmb   2
u003A    rmb   2
u003C    rmb   1
u003D    rmb   1
u003E    rmb   1
u003F    rmb   2
u0041    rmb   1 Active terminal type
u0042    rmb   2
u0044    rmb   1
LASTROW    rmb   1
u0046    rmb   1
u0047    rmb   1
u0048    rmb   1
u0049    rmb   2
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
u005F    rmb   2
u0061    rmb   2
u0063    rmb   1
u0064    rmb   1
u0065    rmb   1
u0066    rmb   1
u0067    rmb   2
u0069    rmb   2
u006B    rmb   2
u006D    rmb   1
u006E    rmb   1
u006F    rmb   1 Variable for max pages
u0070    rmb   2
u0072    rmb   1
u0073    rmb   2
u0075    rmb   2
u0077    rmb   1
u0078    rmb   2
u007A    rmb   2
u007C    rmb   1
u007D    rmb   1
u007E    rmb   1
u007F    rmb   2
u0081    rmb   3
u0084    rmb   1
u0085    rmb   2
u0087    rmb   2
u0089    rmb   2
u008B    rmb   2
u008D    rmb   2
u008F    rmb   2
u0091    rmb   2
u0093    rmb   2
u0095    rmb   1
u0096    rmb   1
u0097    rmb   2
u0099    rmb   2
u009B    rmb   1
u009C    rmb   1
u009D    rmb   1
u009E    rmb   2
u00A0    rmb   1
u00A1    rmb   1
u00A2    rmb   1
u00A3    rmb   1
u00A4    rmb   1
u00A5    rmb   1
u00A6    rmb   2
u00A8    rmb   1
u00A9    rmb   1
u00AA    rmb   1
u00AB    rmb   2
u00AD    rmb   1
u00AE    rmb   2
u00B0    rmb   1
u00B1    rmb   1
u00B2    rmb   2
u00B4    rmb   2
u00B6    rmb   2
u00B8    rmb   2
u00BA    rmb   2
u00BC    rmb   2
u00BE    rmb   2
u00C0    rmb   2
u00C2    rmb   2
u00C4    rmb   2
u00C6    rmb   2
u00C8    rmb   1
u00C9    rmb   1
u00CA    rmb   1
u00CB    rmb   2
u00CD    rmb   2
u00CF    rmb   1
u00D0    rmb   2
u00D2    rmb   1
u00D3    rmb   2
u00D5    rmb   1
u00D6    rmb   1
u00D7    rmb   1
u00D8    rmb   1
u00D9    rmb   2
u00DB    rmb   1
u00DC    rmb   1
u00DD    rmb   1
u00DE    rmb   1
u00DF    rmb   1
u00E0    rmb   1
u00E1    rmb   1
u00E2    rmb   1
u00E3    rmb   1
u00E4    rmb   1
u00E5    rmb   1
u00E6    rmb   1
u00E7    rmb   1
u00E8    rmb   1
u00E9    rmb   1
u00EA    rmb   1
u00EB    rmb   1
u00EC    rmb   1
u00ED    rmb   1
u00EE    rmb   2
u00F0    rmb   1
u00F1    rmb   1
u00F2    rmb   1
u00F3    rmb   2
u00F5    rmb   2
u00F7    rmb   1
u00F8    rmb   1
u00F9    rmb   1
u00FA    rmb   11782
size     equ   .

ESCAPE equ $1B

L000D    fcb   3 Terminal type

         fcb   $0B
L000F    fcb   10   MAXPAGES
         fcb   $0B
L0011    fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00

         fdb   TXTBEG   $04BE
         fdb   $0E98   TXTEND
         fdb   $4EF4   BINEND
         fdb   TRMBEG   $0F41
         fdb   $0FBE   TRMSEQ
         fdb   $1016   TRMEND

         fdb   $0000
         fdb   $0000
         fdb   $0000
         fdb   $34A5
         fcb   $80
         fcb   $62 b
         fcb   $09
         fcb   $A7 '
         fcb   $98
         fcb   $00
         fcb   $0D
         fcc " STYLOGRAPH "
         fcb   $0D
         fcc "COPYRIGHT 1982"
         fcb   $0D
         fcc "GREAT PLAINS COMPUTER CO.,INC."
         fcb   $0D
name     equ   *
         fcs   /Stylo/

L0072    tfr   u,d
         tfr   s,y
         rts

L0077    pshs  y,x,b,a
         leax  $08,s
         stx   <u0004
         stx   <u0006
         leax  >IRQHNDLR,pcr
         ldu   #$0000
         os9   F$Icpt
         ldx   <u0087
         leay  >$0100,x
         leax  >$0C1E,y
         stx   <TTYSTATE
         leax  >$0C3E,y
         stx   <u0010
         leax  >$0C5E,y
         stx   <u0012
         leax  >$0CB3,y
         stx   <u0014
         bsr   L00EE
         leax  >$0CEE,y
         stx   <u0016
         bsr   L00EE
         leax  >$0D29,y
         stx   <u0018
         bsr   L00EE
         leax  >$112E,y
         stx   <u001A
         bsr   L00EE
         clra
         clrb     Function code 0 (ss.opt)
         ldx   <TTYSTATE
         os9   I$GetStt
         ldy   <u0010
         ldd   #$0020
         lbsr  L3EDA
         ldx   <u0010
         clr   $04,x
         clr   $07,x
         lda   #$FF
         sta   $0C,x
         sta   $0F,x
         clra
         clrb
         os9   I$SetStt
         ldx   <u0087
         leax  >$0BCE,x
         stx   <u00F3
         stx   <u00F5
         puls  pc,y,x,b,a

L00EE    leau  $05,x
         stu   ,x
         stu   $02,x
         clr   $04,x
         rts

* Interrupt handler
IRQHNDLR    rti

WrA2BUF  pshs  y,x,b,a
         ldx   <u00F3
         anda  #$7F
         sta   ,x+
         stx   <u00F3
         leax  <-$50,x
         cmpx  <u00F5
         bcs   L011E
         bra   L010D

L010B    pshs  y,x,b,a
L010D    ldd   <u00F3
         subd  <u00F5
         beq   L011E
         tfr   d,y
         ldx   <u00F5
         stx   <u00F3
         lda   #$01
         os9   I$Write
L011E    puls  pc,y,x,b,a

L0120    rts

L0121    bra   L010B
         rts

L0124    pshs  y,x,a
         tfr   s,x
         ldy   #$0001
         lda   <u0000
         os9   I$Write
         puls  pc,y,x,a

L0133    pshs  x,b,a
         lda   #$02
         ldb   #$03
         os9   I$Create
         bcs   L0144
         sta   <u0000
         andcc #$FC
         puls  pc,x,b,a

L0144    stb   <u0003
         orcc  #Carry
         andcc #$FD
         puls  pc,x,b,a

L014C    pshs  a
         lda   <u0000
         os9   I$Close
         puls  pc,a

* Read one character from stdin
L0155    bsr   L010B
         pshs  y,x,a
         tfr   s,x
         ldy   #$0001
         lda   #$00
         os9   I$Read
         puls  y,x,a
         anda  #$7F
         rts

L0169    bsr   L0172
         beq   L0171
         bsr   L0155   Read keyboard
         bra   L0169
L0171    rts

L0172    pshs  b,a
         lda   #$00
         ldb   #$01
         os9   I$GetStt
         bcs   L0181
         andcc #$FB
         puls  pc,b,a
L0181    orcc  #$04
         puls  pc,b,a

L0185    pshs  y,x,b,a
         ldy   <u0004
L018A    lda   ,y+
         cmpa  #$0D
         beq   L01A0
         cmpa  #$20
         beq   L018A
         cmpa  #$2C
         beq   L018A
         cmpa  >OPTCHR,pcr  Character + for command line option
         beq   L01C8
         bra   L01A6
L01A0    orcc  #Carry
         andcc #$FD
         puls  pc,y,x,b,a

L01A6    leay  -$01,y
         ldb   #$36
L01AA    lda   ,y+
         cmpa  #$0D
         beq   L01BD
         cmpa  #$20
         beq   L01BD
         cmpa  #$2C
         beq   L01BD
         sta   ,x+
         decb
         bne   L01AA
L01BD    clr   ,x
         leay  -$01,y
         sty   <u0004
         andcc #^Carry
         puls  pc,y,x,b,a

L01C8    lda   ,y+
         cmpa  #$0D
         beq   L01A0
         cmpa  #$20
         beq   L018A
         cmpa  #$2C
         beq   L018A
         bra   L01C8

L01D8    pshs  b,a
         ldx   <u0006
L01DC    lda   ,x+
         cmpa  >OPTCHR,pcr
         beq   L01EC
         cmpa  #$0D
         bne   L01DC
         orcc  #Carry
         puls  pc,b,a
L01EC    stx   <u0006
         andcc #^Carry
         puls  pc,b,a

L01F2    pshs  u,x,b,a
         lda   #$02
         ldb   #$03
         os9   I$Create
         ldx   <u0018
L01FD    bcs   L020F
         sta   $04,x
         leau  $05,x
         stu   ,x
         leau  >$400,u
         stu   $02,x
         andcc #$FC
         puls  pc,u,x,b,a
L020F    stb   <u0003
         cmpb  #E$CEF  Creating Existing File
         bne   L0219
         orcc  #$03
         puls  pc,u,x,b,a
L0219    orcc  #Carry
         andcc #$FD
         puls  pc,u,x,b,a

L021F    pshs  u,x,b,a
         lda   #$02
         ldb   #$03
         os9   I$Create
         ldx   <u001A
         bra   L01FD

* Create path from stydir
L022C    pshs  y,x,b,a
         leax  >STYDIR,pcr
         ldy   <u0012
L0235    lda   ,x+
         beq   L023D
         sta   ,y+
         bra   L0235
L023D    ldx   $02,s
         lda   #$2F
         sta   ,y+
L0243    lda   ,x+
         sta   ,y+
         bne   L0243
         ldx   <u0012
         bsr   L0276
         puls  pc,y,x,b,a

L024F    pshs  u,x,a
         lda   #$01
         os9   I$Open
         ldx   <u0014
L0258    bcs   L0264
         sta   $04,x
         leau  $05,x
         stu   ,x
         stu   $02,x
         puls  pc,u,x,a

L0264    cmpb  #E$PNNF   File not found
         beq   L0270
         stb   <u0003
         orcc  #Carry
         andcc #$FD
         puls  pc,u,x,a
L0270    stb   <u0003
         orcc  #$03
         puls  pc,u,x,a
L0276    pshs  u,x,a
         lda   #$01
         os9   I$Open
         ldx   <u0016
         bra   L0258
L0281    pshs  x,a
         ldx   <u0014
         bra   L029A
L0287    pshs  x,a
         ldx   <u0016
         bra   L029A
L028D    pshs  x,a
         ldx   <u0018
         bra   L0297
L0293    pshs  x,a
         ldx   <u001A
L0297    lbsr  L044A
L029A    lda   $04,x
         beq   L02A3
         clr   $04,x
         os9   I$Close
L02A3    puls  pc,x,a

*
* Delete routine
L02A5    pshs  y,x,b,a
         ldy   <u0012
L02AA    lda   ,x+
         beq   L02B2
         sta   ,y+
         bra   L02AA
L02B2    leax  >DOTBAK,pcr
L02B6    lda   ,x+
         sta   ,y+
         bne   L02B6
         ldx   <u0012
         os9   I$Delete
         stb   <u0003
         puls  pc,y,x,b,a
L02C5    pshs  b,a
         ldb   <u0003
         lda   #$01
         os9   F$PErr
         puls  pc,b,a

L02D0    pshs  x
         ldx   <u0018
L02D4    lbsr  L0437
         puls  pc,x

L02D9    pshs  x
         ldx   <u001A
         bra   L02D4
L02DF    pshs  x,b
         ldx   <u0014
L02E3    lbsr  L046F
         puls  pc,x,b
L02E8    pshs  x,b
         ldx   <u0016
         bra   L02E3
         pshs  x,b
         ldx   <u0016
         lbsr  L0480
         puls  pc,x,b
L02F7    pshs  u,y,x,b,a
         ldy   <u0012
         stx   <u000C
L02FE    lda   ,x+
         sta   ,y+
         bne   L02FE
         leay  -$01,y
         leax  >DOTBAK,pcr
L030A    lda   ,x+
         sta   ,y+
         bne   L030A
         lda   #$01
         ldx   <u0012
         os9   I$Open
         bcs   L0320
         os9   I$Close
         orcc  #$03
         puls  pc,u,y,x,b,a
L0320    cmpb  #E$PNNF Path name not found?
         beq   L032C
L0324    stb   <u0003
         orcc  #Carry
         andcc #$FD
         puls  pc,u,y,x,b,a

L032C    tst   <u005D
         beq   L0348
         ldx   <u000A
         bne   L0343
         ldx   <u0014
         lda   $04,x
         ldb   #$05
         os9   I$GetStt
         bcs   L0324
         stx   <u0008
         stu   <u000A
L0343    lbsr  L0281
         bcs   L0324
L0348    ldx   <u000C
         ldy   <u0012
         lda   #$20
         sta   ,y+
L0351    lda   ,x+
         sta   ,y+
         bne   L0351
         lda   #$20
         sta   -$01,y
L035B    lda   ,-x
         cmpa  #$2F
         beq   L0367
         cmpx  <u000C
         bne   L035B
         bra   L0369
L0367    leax  $01,x
L0369    lda   ,x+
         beq   L0371
         sta   ,y+
         bra   L0369
L0371    leax  >DOTBAK,pcr
L0375    lda   ,x+
         sta   ,y+
         bne   L0375
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
         bcs   L0324
         os9   F$Wait
         tstb
         bne   L0324
         tst   <u005D
         beq   L03CF
         ldx   <u000C
         ldy   <u0012
L03A3    lda   ,x+
         sta   ,y+
         bne   L03A3
         leay  -$01,y
         leax  >DOTBAK,pcr
L03AF    lda   ,x+
         sta   ,y+
         bne   L03AF
         ldx   <u0012
         lda   #$01
         os9   I$Open
         lbcs  L0324
         ldx   <u0014
         sta   $04,x
         ldx   <u0008
         ldu   <u000A
         os9   I$Seek
         lbcs  L0324
L03CF    andcc #^Carry
         puls  pc,u,y,x,b,a

L03D3    pshs  u,y,x,b,a
         pshs  x
         ldx   <TTYSTATE
         ldd   #$0000
         os9   I$SetStt
         puls  x
         tfr   x,u
         ldd   #$0000
L03E6    tst   d,u
         beq   L03EF
         addd  #$0001
         bra   L03E6
L03EF    tfr   d,y
         leay  $01,y
         leax  d,u
         lda   #$0D
         sta   ,x
         ldd   #$0000
         leax  >SHELL,pcr
         os9   F$Fork
         bcs   L041B
         os9   F$Wait
         tstb
         bne   L041B
         andcc #^Carry
L040D    pshs  cc
         ldx   <u0010
         ldd   #$0000
         os9   I$SetStt
         puls  cc
         puls  pc,u,y,x,b,a
L041B    stb   <u0003
         orcc  #Carry
         bra   L040D
L0421    lbsr  L010B
         lbsr  L028D
         lbsr  L0293
         ldd   #$0000
         ldx   <TTYSTATE
         os9   I$SetStt
         clrb
         os9   F$Exit
         rts

L0437    pshs  u
         ldu   ,x
         sta   ,u+
         stu   ,x
         cmpu  $02,x
         beq   L0448
         andcc #^Carry
         puls  pc,u
L0448    puls  u
L044A    pshs  y,x,b,a
         tst   $04,x
         beq   L046D
         tfr   x,y
         leax  $05,y
         pshs  x
         ldd   ,y
         stx   ,y
         subd  ,s++
         beq   L046D
         pshs  b,a
         lda   $04,y
         puls  y
         os9   I$Write
         bcs   L046B
         puls  pc,y,x,b,a

L046B    stb   <u0003
L046D    puls  pc,y,x,b,a
L046F    pshs  u
L0471    ldu   ,x
         cmpu  $02,x
         beq   L0482
         lda   ,u+
         stu   ,x
         andcc #^Carry
         puls  pc,u
L0480    pshs  u
L0482    pshs  y,x
         tfr   x,y
         lda   $04,y
         leax  $05,y
         stx   ,y
         ldy   #$0036
         os9   I$Read
         sty   <u0006
         puls  y,x
         bcs   L04A4
         ldd   <u0006
         leau  $05,x
         leau  d,u
         stu   $02,x
         bra   L0471
L04A4    cmpb  #$D3
         bne   L04AC
         orcc  #$03
         puls  pc,u
L04AC    orcc  #Carry
         andcc #$FD
         stb   <u0003
         puls  pc,u

L04B4    os9   I$Seek
         rts

         ldb   #$0E
         os9   I$GetStt
         rts

*EQUATE FOR STYFIX
TXTBEG EQU *

*ESCAPE CHARACTER CONSTANTS
ESCTBL EQU *

CURUC    fcb   $49 I
         fcb   $4C L
CURDC    fcb   $2C ,  $04C0
         fcb   $4A J
         fcb   $55 U
 FCC 'M' SCROLL DOWN
         fcb   $59 Y
         fcb   $40 @
 FCC 'F' FIND CHARACTERS
 FCC 'R' REPLACE CHARACTERS
 FCC ';' ENTER TEXT
 FCC 'W' WITHDRAW RESERVED TEXT
 FCC 'Z' BLOCK DELETE
 FCC 'S' RESERVE BLOCK OF TEXT
 FCC '/' COMMAND MODE
 FCC 'D' DUPLICATE
 FCC 'O' MOVE SCREEN UP
 FCC '.' MOVE SCREEN DOWN
CURLRC FCC 'K' MOVE CURSOR LEFT-RIGHT $04D0
PAGC FCC 'P' MOVE TO PAGE #
         fcb   $7D
         fcb   $14
         fcb   $2D -
 FCC '7' SCROLL LEFT
 FCC '9' SCROLL RIGHT
 FCC '1' OVERWRITE 1
 FCC '^' INSERT 1

*CHARACTER MOD CHARACTERS (ALSO CONTROL)
* $04D9
ULMCHR FCB $15 ^U UNDERLINE
OLMCHR FCB $F ^O OVERLINE
BFMCHR FCB 2 ^B BOLDFACE
L04DC    fcb   $19
L04DD    fcb   $0B
L04DE    fcb   $11
         fcb   $20
BSC    fcb   $08


*CONTROL CHARACTER CONSTANTS
CTRTBL EQU *
         fcb   $0C
         fcb   $0A
         fcb   $09
         fcb   $60 `
LNDELC    fcb   $18   L04E5
         fcb   $04
         fcb   $17
         fcb   $06
NMERC    fcb   $0E  L04E9
         fcb   $16
PAGSTC    fcb   $10
         fcb   $07
         fcb   $12
         fcb   $1E
 FCB $01 ^A HELP, ASSISTANCE
         fcb   $05 ^E  Programmer mode
 PAG

*MISC. CHARACTER CONSTANTS
ESCC    fcb   $1B
L04F2    fcb   $14
L04F3    fcb   $15
L04F4    fcb   $2D -
L04F5    fcb   $7C
PRCCHR FCC ',' PROC COMMAND CHARACTER
MRKCHR FCC '}' MARKER CHARACTER
PNCHR    fcb   $23 #
STMODC  fcb   $7C
L04FA    fcb   $3E >
L04FB    fcb   $3C <
YCHR    fcb   $59 Y L04FC
NCHR    fcb   $4E N
SCHR FCC 'S' STOP
ACHR    fcb   $41 A
PSCHR    fcb   $53 S
L0501    fcb   $54 T
L0502    fcb   $42 B
L0503    fcb   $43 C
L0504    fcb   $4E N
L0505    fcb   $45 E
L0506    fcb   $57 W
L0507    fcb   $58 X
L0508    fcb   $59 Y
L0509    fcb   $5A Z
CTMCHR    fcb   $54 T
CPTCHR FCC 'P' COMMAND LINE PRINTER OPTION
CPGCHR    fcb   $4D M
OPTCHR    fcb   $2B +
L050E    fcb   $7D
LBCHR    fcb   $7B

STLM    fcb   $00
L0511    fcb   $00
L0512    fcb   $00
L0513    fcb   $00
L0514    fcb   $00
STPL FCB 66 PAGE LENGTH
STCS FCB 12 CHARACTERS/INCH
STVS FCB 6 VERTICAL SPACING
STBFS FCB 4 BOLDFACE STRIKE COUNT
STPS FCB 0 NON-PROPORTIONAL SPACE
STPADC    fcb   $00
STMMC    fcb   $00
STPC    fcb   $00

*VECTORS FOR THE STRINGS

FMTTBL    fdb  XFMTTBL $05B1
ERRTBL    fdb   XERRTBL
BELS1    fdb  XBELS1 $064F
BAVM1    fdb XBAVM1  $0658
PAGS1    fdb  XPAGS1 $0681

L0527    fdb   L061C
L0529    fdb   L062C
         fdb   L0637
L052D    fdb   L0643
L052F    fdb   L0648
PGBS1    fdb XPGBS1  $0693
SAVM1    fdb XSAVM1  $0698
SAVMB    fdb XSAVMB  $06AF
SAVM2    fdb XSAVM2  $06BA
SAVM3    fdb XSAVM3  $06C8
L053B    fdb XSAVM4  $06E6
L053D    fdb XSAVM5  $0702
L053F    fdb XSVMS1  $070E
L0541    fdb XDSTM1  $0720
L0543    fdb XDSTM2  $073C
DSTM3    fdb XDSTM3  $075D
DSTM5    fdb XDSTM5  $076D
DSTM6    fdb XDSTM6  $0797
DSTM7    fdb XDSTM7  $07AC
OSPS1    fdb XOSPS1  $0827
OSPS2    fdb XOSPS2  $0836
EXTM1    fdb XEXTM1  $0925
EXTM2    fdb XEXTM2  $093A
ERMM1    fdb XERMM1  $0949
L0557    fdb   $0967
L0559    fdb   $0979
L055B    fdb   $09A7
L055D    fdb   $09C8
L055F    fdb   $09D3
PRNS1    fdb XPRNS1
PRNS2    fdb XPRNS2  $09FB
L0565    fdb XPRNS3  $0A12
PRNS4    fdb XPRNS4  $0A24
OTXS1    fdb XOTXS1  $0A40
L056B    fdb XOTXS2  $0A72
L056D    fdb   $0A8B
L056F    fdb   $0A9C
L0571    fdb   $0AAE
PSQS1    fdb   XPSQS1
L0575    fdb   $087B
L0577    fdb   $0899
L0579    fdb   $08B6
L057B    fdb   $08C0
L057D    fdb   $08CB
L057F    fdb   $08E9
L0581    fdb   $08FB
L0583    fdb XNEWM9  $0909
L0585    fdb   $0AC9
L0587    fdb   $0AD6
L0589    fdb   $0AF7
L058B    fdb XRPLS1  $0B09
RPLS2    fdb XRPLS2  $0B16
L058F    fdb XRPLS3  $0B23
L0591    fdb XBDLS1  $0B38
L0593    fdb XBDLS2  $0B44
L0595    fdb XSUPS1  $0B53
BANNER    fdb  XBANNER $0D57
HLPS1 fdb XHLPS1 $0D87
HLPS2 FDB XHLPS2
HLPS3   fdb XHLPS3  $0E20
HLPS4    fdb XHLPS4  $0E28
HLPS5    fdb XHLPS5  $0E30
HLPS6    fdb XHLPS6  $0E38
HLPS7    fdb XHLPS7  $0E40

         fdb   L0E48
L05A9    fdb   L0E51
L05AB    fdb   L07BB
         fdb   L07F4

TMODE  fdb  XTMODE


*FORMAT COMMAND TABLE
XFMTTBL EQU *  $05B1
 FCC 'CE'
 FCB 0
 FCC 'LL'
 FCB 0
 FCC 'RJ'
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
 FCC 'TF'
 FCB 0
 FCC 'BFS'
 FCB 0
 FCB 0 END OF TABLE

L061C    fcc   "STYPSTAT"
         fcb   $00

XERRTBL  fcc   "STYERR"
         fcb   $00
L062C    fcc   "---NONE---"
         fcb   $00
L0637    fcc   "STATUS:    "
         fcb   $00
L0643    fcc   "OPEN"
         fcb   $00
L0648    fcc   "CLOSED"
         fcb   $00
XBELS1   fcc   "NO ERROR"
         fcb   $00

* $0658
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
XSAVM4 FCC 'Delete backup file (Y*/N)? '
 FCB 0
XSAVM5 FCC 'File name? '
 FCB 0
XSVMS1 FCC 'Marker not found.'
 FCB 0
XDSTM1 FCC 'WARNING! FILE TOO LARGE - '
         fcb   $0D
         fcb   $0A
XDSTM2 FCC 'ENTIRE FILE MAY NOT BE LOADED!!!'
 FCB 0
XDSTM3 FCC 'FILE NOT LOADED'
 FCB 0
* $076D
XDSTM5 FCB $D,$A
 FCC 'ILLEGAL PRINTER, TERMINAL, OR FILE NAME'
 FCB 0
XDSTM6 FCC 'INPUT FILE NOT FOUND-'
XDSTM7 FCC 'NO TEXT LOADED'
 FCB 0

*NOTE: Typo in original code: NUMBBER
L07BB fcc "BAD TERM_STY/PRINT_STY OR TERMINAL/PRINTER NUMBBER!!!!"
         fcb   $0D
         fcb   $0A
         fcb   $00

L07F4    fcc "CANT FIND PRINTER FILE."
         fcb   $0D
         fcb   $0A
         fcc  "ENTER CORRECT PATHNAME:"
         fcb   $0D
         fcb   $0A
         fcb   $00
XOSPS1   fcc  "DOS command:  "
         fcb   $00
XOSPS2 FCB 7
 FCC 'Command not allowed with files open.'
 FCB 0
XPSQS1 FCC 'Hit any key to restart printer'
 FCB 0

XNEWM1 FCC 'No dump.  Cursor on top page.'
 FCB 0
XNEWM3 fcc "Dump text in memory (Y*/N)? "
 FCB 0
XNEWM4 fcc 'Dump to "'
 FCB 0
XNEWM5 fcc '" (Y*/N)? '
 FCB 0
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
XPRNS3 FCC '   Printer name? '
 FCB 0
XPRNS4 FCC 'Stop for new pages (Y/N*)? '
 FCB 0
XOTXS1 FCC "Hit SPACE to pause or continue, RETURN to abort. "
 FCB 0
XOTXS2 FCC 'Print all pages (Y*/N)? '
 FCB 0
XOTXS3 FCC '   First page = '
 FCB 0
XOTXS4 FCC '     Last page = '
 FCB 0
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
XBDLS2 FCC '  CHARACTERS? '  $0B44
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

* $0D57
XBANNER FCC "STYLOGRAPH WORD PROCESSING SYSTEM V3.0 (c) 1984"
 FCB 0

XHLPS1 FCC 'RETURN'
 FCB 0
 FCC 'ESCAPE Commands'
 FCB 0
 fcc 'CONTROL Commands'
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

L0E48 FCC "TERM_STY"
 FCB 0
L0E51 FCC "PRINT_STY"
 FCB 0

XTMODE   fcc   "TMODE  -PAUSE"
         fcb   $0D
 FCB 0

*SAVE A FEW BYTES FOR POSSIBLE LARGER TEXT OVERLAY
         fcc   "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
TXTEND equ *
XSTYP1  fcc "                            /P"
         fcb   $00

STYDIR   FCC "                       /D0/STY"
         fcb   $00

STYP1    fdb   XSTYP1

DOTBAK    FCC "_BAK"
         fcb   $00

RENAME FCC 'rename'
 FCB $0D
SHELL FCC 'shell'
 FCB $0D

L0EEA  lda   <u0041    Load active model number
    cmpa  #$03  Number of types
    bhi L0EF3
         tsta
         bne  L0EF6
L0EF3    orcc  #Carry
         rts

L0EF6    deca
         ldb   #$13
         mul
         leax  >TRMBEG+10,pcr
         leax  d,x
         clrb
         ldy   <u0042
L0F04    incb
         lda   b,x
         bne   L0F0E
         ldu   #$0000
         bra   L0F19

L0F0E    leau  >TRMSEQ,pcr
L0F12    tst   ,u+
         bpl   L0F12
         deca
         bne   L0F12
L0F19    decb
         lslb
         stu   b,y
         asrb
         incb
         cmpb  #$12
         bcs   L0F04
         leau  >L0F3B,pcr
         lda   ,x
         sta   <u0044
         anda  #$07
         lsla
         ldd   a,u
         std   <LASTROW
         lda   ,x
         anda  #$20
         sta   <u0047
         andcc #$FE

         rts

* Table for screen sizes.
L0F3B equ *
         fcb   23,78  D2479
         fcb   23,49  D2450
         fcb   15,32  D1633

*THE FIRST 10 BYTES ARE RESERVED FOR 5 ADDRESS
*POINTERS TO MACHINE LANGUAGE ROUTINES IF USED.

TRMBEG equ *       Address $0F41
         fdb   L0F84
         fdb   L11DF
         fdb   L11DF
         fdb   L11DF
         fdb   L11DF

*TERMINAL SPECIFICATION CONSTANTS
D2479 EQU 0  24 ROW BY 79 COLUMNS
D2450 EQU 1  24 X 50
D1633 EQU 2  16 X 33


CYX EQU $80 OUTPUT Y(ROW) THEN X(COLUMN) ON CURSOR ADDRESS
CAD20 EQU $40 ADD $20 TO CURSOR ADDRESSES
SSCD EQU $20 CAN SCROLL SCREEN DOWN
LERF EQU $10 HAS LINE ERASE FUNCTION

*T1 FHL O-PAK 51x24
         fcb   CAD20+SSCD+LERF+D2450
         fcb   1  CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   4  CLRS  - CLEAR SCREEN
         fcb   5  LERASE - ERASE LINE
         fcb   6  SCRLUP - SCROLL UP
         fcb   7  SCRLDN  - SCROLL DOWN
         fcb   8  SCINIT  - INITIALIZE TERMINAL
         fcb   9  SSHUT  - SHUT DOWN SCREEN
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   0
*T2 Word-Pak 80 column board
         fcb   CYX+CAD20+LERF+D2479
         fcb   12  CURMV  - CURSOR MOVE
         fcb   13  CURON  - CURSOR ON
         fcb   14  CUROFF - CURSOR OFF
         fcb   15  BLINK  - BLINK CURSOR
         fcb   16  SOLID  - SOLID CURSOR
         fcb   1   CLRS  - CLEAR SCREEN
         fcb   17  LERASE - ERASE LINE
         fcb   18  SCRLUP - SCROLL UP
         fcb   0
         fcb   0
         fcb   0
         fcb   19  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   20  ATT1  - CHARACTER ATTRIBUTES
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   0
*T3 GO51 terminal
         fcb   SSCD+LERF+D2450
         fcb   22  CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   4  CLRS  - CLEAR SCREEN
         fcb   23  LERASE - ERASE LINE
         fcb   24  SCRLUP - SCROLL UP
         fcb   25  SCRLDN  - SCROLL DOWN
         fcb   0
         fcb   0
         fcb   26  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   27  ATT1  - CHARACTER ATTRIBUTES
         fcb   0
         fcb   29  UNDERLINE ON
         fcb   30  UNDERLINE OFF
         fcb   0
         fcb   0

L0F84 equ *  First macro
         pshs  u,y,x,b,a
         ldd >TMODE,pcr
         leax >0,pcr
         leax  d,x
         stx   <u0061
         ldy   <u0012
L0F95    lda   ,x+
         sta   ,y+
         bne   L0F95
         lda   #$0D
         sta   ,y
         ldy   #$0100
         ldd   #$0001
         ldx   <u0012
         ldu   <u0012
         os9   F$Fork
         bcs   L0FB7
         os9   F$Wait
         bcs   L0FB7
L0FB4    puls  u,y,x,b,a
         rts

L0FB7    lda   #$03
         lbsr  L2AF4
         bra   L0FB4


*------------ TERMINAL SEQUENCES ---------------
*THESE ARE THE SEQUENCES THAT ARE NORMALLY SENT TO THE
*TERMINAL FOR THE VARIOUS FUNCTIONS.
*THEY ARE IN "SERIAL" ORDER AND ARE POINTED TO
*BY THE BYTES IN THE TERMINAL SEQUENCE POINTERS
*DEFINED PREVIOUSLY.
*THE SEQUENCES ALWAYS END WITH THE "N" BIT SET.

N EQU $80
M EQU $FF


* Location $0FBE
TRMSEQ equ *
*0  - NO FUNCTION, DO NOT MODIFY THIS BYTE
         fcb   N
*1
         fcb   $02+N
*2
         fcb   ESCAPE
         fcb   $56 V
         fcb   ESCAPE
         fcb   $57 W
         fcb   $2A+N
*3
         fcb   ESCAPE
         fcb   $D6 V
*4
         fcb   $0C+N
*5
         fcb   $03+N
*6
         fcb   $01
         fcb   ESCAPE
         fcb   $46 F
         fcb   $02
         fcb   $00
         fcb   $A3 #
*7
         fcb   $01
         fcb   ESCAPE
         fcb   $C5 E
*8
         fcb   $0C
         fcb   ESCAPE
         fcb   $58 X
         fcb   $30 0
         fcb   ESCAPE
         fcb   $56 V
         fcb   ESCAPE
         fcb   $57 W
         fcb   $AA *
*9
         fcb   ESCAPE
         fcb   $F1 q
*10
         fcb   ESCAPE
         fcb   $52 R
         fcb   $20
         fcb   ESCAPE
         fcb   $53 S
         fcb   $A3 #
*11
         fcb   ESCAPE
         fcb   $52 R
         fcb   $23 #
         fcb   ESCAPE
         fcb   $53 S
         fcb   $A0
*12
         fcb   $14+N
*13
         fcb   ESCAPE
         fcb   $2E .
         fcb   $82
*14
         fcb   ESCAPE
         fcb   $2E .
         fcb   $80
*15
         fcb   ESCAPE
         fcb   $2E .
         fcb   $81
*16
         fcb   ESCAPE
         fcb   $2E .
         fcb   $82
*17
         fcb   $0D
         fcb   $85
*18
         fcb   $14
         fcb   $18
         fcb   $00
         fcb   $8A
*19
         fcb   $86
*20
         fcb   $86
*21
         fcb   $80
*22
         fcb   ESCAPE
         fcb   'A+N
*23 Erase line
         fcb   $0D
         fcb   ESCAPE
         fcb   'B+N
*24 Scroll up
         fcb   ESCAPE
         fcb   'A
         fcb   $00
         fcb   23
         fcb   $0A+N
*25 Scroll down
         fcb   $0B    cursor home
         fcb   ESCAPE
         fcb   'D+N
*26 Reverse off
         fcb   ESCAPE
         fcb   'G+N
*27 Reverse on
         fcb   ESCAPE
         fcb   'F+N
*28 (macro)
         fcb   0,M
*29 Underline on
         fcb   ESCAPE
         fcb   'H+N
*30 Underline off
         fcb   ESCAPE
         fcb   'I+N
TRMEND   equ *

OUTREPT    pshs  b
         ldb   <u003F
         cmpb  <u0046
         puls  b
         bhi   L1025
         inc   <u003F
         lbra WrA2BUF

L1025    rts
L1026    pshs  b
         ldb   <u003F
         cmpb  <u0046
         bhi   L1064
         lbsr  L18D6
         bra   L1035

L1033    pshs  b
L1035    andb  #$01
         beq   L1045
         ldb   #$1C
         bsr   L10AD
         beq   L1045
         ldb   <u00DF
         andb  #$FE
         beq   L1049
L1045    ldb   #$18
         bsr   L10AD
L1049    inc   <u003F
         lbsr  WrA2BUF
         ldb   <u00DF
         andb  #$01
         beq   L1060
         ldb   #$1E
         bsr   L10AD
         beq   L1060
         ldb   <u00DF
         andb  #$FE
         beq   L1064
L1060    ldb   #$16
         bsr   L10AD
L1064    puls  pc,b

*
* Write string in X on line A column B
*
GOROWCOL std   <u003E
         pshs  x
         ldb   #$00
         bsr   L10AD
         bcs   L1094
         ldx   <u0042
         ldb   <u0044
         bitb  #$80
         beq   L1096
         lda   <u003E
         bitb  #$40
         beq   L1080
         adda  #$20
L1080    lbsr  WrA2BUF
         lda   <u003F
         ldx   <u0042
         ldb   <u0044
         bitb  #$40
         beq   L108F
L108D    adda  #$20
L108F    lbsr  WrA2BUF
         ldd   <u003E
L1094    puls  pc,x

L1096    lda   <u003F
         bitb  #$40
         beq   L109E
         adda  #$20
L109E    lbsr  WrA2BUF
         lda   <u003E
         ldx   <u0042
         ldb   <u0044
         bitb  #$40
         beq   L108F
         bra   L108D

L10AD    pshs  x,b,a
         ldx   <u0042
         ldx   b,x
         beq   L10CA
         lda   $01,x
         cmpa  #$FF  Is the terminal sequence a Macro?
         beq   L10CC
L10BB    lda   ,x+
         pshs  a
         lbsr  WrA2BUF
         lda   ,s+
         bpl   L10BB
         andcc #^Carry
L10C8    andcc #$FB
L10CA    puls  pc,x,b,a

* Call macro in TRMBEG table
L10CC    ldb   ,x
         lslb
         leax  >TRMBEG,pcr
         ldd   b,x
         leax  >0,pcr
         leax  d,x
         ldd   <u003E
         pshs  u
         leau  >WrA2BUF,pcr
         jsr   ,x
         puls  u
         orcc  #Carry
         bra   L10C8

L10EB    pshs  b
         ldb   #$04
         bsr   L10AD
         puls  pc,b

L10F3    pshs  b
         ldb   #$02
         bsr   L10AD
         puls  pc,b

L10FB    pshs  x,b
         clr   <u003E
         clr   <u003F
         ldb   #$0A
         bsr   L10AD
         lbsr  L010B
         ldx   #$1F40
L110B    leax  -$01,x
         bne   L110B
         puls  pc,x,b
L1111    pshs  b,a
         ldb   #$0E
         bsr   L10AD
         ldd   <u003E
         deca
         lbsr  GOROWCOL
         puls  pc,b,a

L111F    pshs  b,a
         ldb   #$10
         bsr   L10AD
         beq   L112D
         ldd   <u003E
         inca
         lbsr  GOROWCOL
L112D    puls  pc,b,a

L112F    pshs  x,b
         clr   <u003E
         clr   <u003F
         ldb   #$12
         lbsr  L10AD
         lbsr  L010B
         ldx   #$2710
L1140    leax  -$01,x
         bne   L1140
         puls  pc,x,b

L1146    pshs  b
         ldb   #$14
         lbsr  L10AD
         puls  pc,b

         pshs  b
         ldb   #$1A
         lbsr  L10AD
         puls  pc,b

         pshs  b
         ldb   #$20
         lbsr  L10AD
         puls  pc,b

         pshs  b
         ldb   #$1E
         lbsr  L10AD
         puls  pc,b

         pshs  b
         ldb   #$1C
         lbsr  L10AD
         puls  pc,b

L1173    pshs  b
         ldb   #$08
         lbsr  L10AD
         puls  pc,b

L117C    pshs  b
         ldb   #$06
         lbsr  L10AD
         puls  pc,b

L1185    pshs  x,b,a
         ldd   <u003E
         pshs  b,a
         ldd   $02,s
         clrb
         lbsr  GOROWCOL
         ldb   #$0C
         lbsr  L10AD
         beq   L119F
L1198    puls  b,a
         lbsr  GOROWCOL
         puls  pc,x,b,a

L119F    ldb   <u0046
         lda   #$20
L11A3    lbsr  WrA2BUF
         decb
         bpl   L11A3
         bra   L1198

L11AB    clrb
         lbsr  L02E8
         bcs   L11E0
         sta   <u0065
L11B3    lbsr  L02E8
         bcs   L11E0
         pshs  x
         tsta
         bpl   L11C4
         cmpa  #$80
         bne   L11C4
         ldx   #$0000
L11C4    lslb
         stx   b,y
         asrb
         puls  x
         incb
         sta   ,x+
         bmi   L11D8
L11CF    lbsr  L02E8
         bcs   L11E0
         sta   ,x+
         bpl   L11CF
L11D8    cmpb  <u0065
         bcs   L11B3
         lbsr  L0287
L11DF    rts

L11E0    ldx   >L05AB,pcr "Bad sty file"
         lbsr  L02C5
         lbra  L0421
L11EA    ldd   >L05A9,pcr
         leax  >0,pcr
         leax  d,x
         lbsr  L022C
         lbcs  L11E0
         lda   <u0048
         ldb   #$FF
         mul
         addd  #$01B8
         exg   d,u
         ldx   <u0016
         lda   $04,x
         ldx   #$0000
         lbsr  L04B4 os9 seek
         ldx   <u0049
         leax  <$3A,x
         ldy   <u0049
         lbsr  L02E8
         lbcs  L11E0
         sta   <u004B
         lbsr  L02E8
         lbcs  L11E0
         sta   <u004C
         lbsr  L02E8
         lbcs  L11E0
         sta   <u004D
         lbsr  L02E8
         lbcs  L11E0
         sta   <u004E
         lbsr  L02E8
         lbcs  L11E0
         sta   <u004F
         lbsr  L02E8
         lbcs  L11E0
         sta   <u0050
         lbsr  L02E8
         lbcs  L11E0
         sta   <u0051
         lbsr  L02E8
         lbcs  L11E0
         sta   <u0052
         lbsr  L02E8
         lbcs  L11E0
         sta   <u0053
         lbsr  L02E8
         lbcs  L11E0
         sta   <u0054
         lbsr  L02E8
         lbcs  L11E0
         sta   <u0055
         lbsr  L02E8
         lbcs  L11E0
         sta   <u0056
         lbra  L11AB
L1286    pshs  b
         ldb   #$04
L128A    lbsr  L14D4
         puls  pc,b
L128F    pshs  b
         ldb   #$06
         bra   L128A
L1295    pshs  b
         ldb   #$08
         bra   L128A
L129B    pshs  b
         ldb   #$1E
         bra   L128A
L12A1    tst   <u00E1
         beq   L12B6
         clr   <u00DD
         clr   <u00DF
         lbsr  L1443
         tst   <u00DC
         beq   L12B6
         clr   <u00DC
         lda   #$0F
         bsr   L12B8
L12B6    lda   #$0D

L12B8    pshs  u
         ldu   <u0057
         jsr   ,u
         puls  pc,u

L12C0    ldb   <u004B
         andb  #$04
         beq   L12D3
         ldb   <u004C
         beq   L1301
         lbsr  L2C1E
L12CD    cmpa  <u003D
         beq   L1301
         sta   <u003D
L12D3    pshs  b
         ldb   #$20
         cmpa  <u0051
         beq   L12FA
         ldb   #$22
         cmpa  <u0052
         beq   L12FA
         ldb   #$24
         cmpa  <u0053
         beq   L12FA
L12E7    puls  b
L12E9    pshs  b
         ldb   #$02
         lbsr  L14D4
         bcs   L1334
         adda  <u0050
         bsr   L12B8
         andcc #^Carry
         puls  pc,b
L12FA    lbsr  L14D4
         bcs   L12E7
         puls  b
L1301    rts
L1302    ldb   <u004D
         beq   L133D
         lbsr  L2C1E
         cmpa  <u003C
         beq   L133D
         sta   <u003C
         pshs  b
         ldb   #$26
         cmpa  <u0054
         beq   L1336
         ldb   #$28
         cmpa  <u0055
         beq   L1336
         ldb   #$2A
         cmpa  <u0056
         beq   L1336
         puls  b
L1325    pshs  b
         ldb   #$00
         lbsr  L14D4
         bcs   L1334
         adda  <u004F
         bsr   L12B8
         andcc #^Carry
L1334    puls  pc,b
L1336    lbsr  L14D4
         bcs   L1325
         puls  b
L133D    rts
L133E    lda   #$20
         sta   <u0066
         lda   #$0A
         lbsr  L149B
         rts
L1348    lda   #$10
         sta   <u0066
         lda   #$0E
         lbsr  L149B
         rts
L1352    lda   #$04
         sta   <u0066
         lda   #$16
         lbsr  L149B
         bcc   L1381
         lda   #$02
         bita  <u004B
         beq   L1381
         pshs  x,a
         ldx   <u0049
         lda   #$06
         ldx   a,x
         puls  x,a
         beq   L1381
         lbsr  L1286
         bcs   L1381
         lda   #$5F
         lbsr  L12B8
         lda   #$08
         lbsr  L12B8
         lbsr  L128F
L1381    rts
L1382    lda   #$01
         sta   <u0066
         lda   #$12
         lbsr  L149B
         bcc   L13D8
         lda   #$02
         bita  <u004B
         beq   L13D8
         tst   <u0030,u
         bne   L139F
         lda   #$5F
         lbsr  L12B8
         bra   L13D3
L139F    ldx   <u0036
         leax  >$00BE,x
         lda   $01,x
         cmpa  #$20
         bcc   L13C1
         adda  #$40
         tst   <u00DC
         bne   L13D0
         pshs  a
         lda   #$0E
         lbsr  L12B8
         puls  a
         lbsr  L12B8
         lda   #$0F
         bra   L13D0
L13C1    tst   <u00DC
         beq   L13D0
         pshs  a
         lda   #$0F
         lbsr  L12B8
         puls  a
         lda   #$0E
L13D0    lbsr  L12B8
L13D3    lda   #$08
         lbsr  L12B8
L13D8    rts

L13D9    pshs  b
         lda   #$02
         sta   <u0066
         lda   #$1A
         lbsr  L149B
         bcc   L1436
         lda   #$02
         bita  <u004B
         bne   L13F0
         lda   <u00DD
         bra   L141D
L13F0    ldx   <u0049
         lda   #$02
         ldx   a,x
         beq   L1424
         lda   #$01
         lbsr  L12E9
         bcs   L1424
         ldb   <u002F,u
         asrb
L1403    lda   <u00DD
         lbsr  L12B8
         lbsr  L12B8
         lda   #$08
         lbsr  L12B8
         lbsr  L12B8
         decb
         bne   L1403
         lda   <u003D
         lbsr  L12E9
         lda   #$20
L141D    lbsr  L12B8
L1420    orcc  #Carry
         puls  pc,b
L1424    ldb   <u002F,u
L1427    lda   <u00DD
         lbsr  L12B8
         decb
         beq   L1420
         lda   #$08
         lbsr  L12B8
         bra   L1427
L1436    puls  pc,b
L1438    lda   #$02
         bita  <u004B
         rts

         lda   #$08
         lbsr  L12B8
         rts
L1443    lda   <u00DD
         cmpa  <u0032,u
         bne   L1453
         tst   <u0032,u
         beq   L1453
         lda   #$20
         sta   <u00DD
L1453    tst   <u0030,u
         beq   L145B
         lbsr  L191B
L145B    clr   <u00E7
         lda   <u00DE
         cmpa  <u004E
         bls   L1469
         suba  <u004E
         sta   <u00E7
         lda   <u004E
L1469    lbsr  L12CD
         ldb   <u00DF
         lbsr  L133E
         lbsr  L1348
         lbsr  L1352
         lbsr  L1382
         lbsr  L13D9
         bcc   L1481
         bra   L1488
L1481    lda   <u00DD
         lbsr  L12B8
         bra   L1488
L1488    tst   <u00E7
         bne   L148F
         andcc #^Carry
         rts

L148F    clr   <u00DF
         lda   #$20
         sta   <u00DD
         lda   <u00E7
         sta   <u00DE
         bra   L145B
L149B    bitb  <u0066
         beq   L14B9
         pshs  a
         lda   <u0066
         bita  <u00EA
         puls  a
         bne   L14D1
         exg   a,b
         bsr   L14D4
         exg   a,b
         bcs   L14D3
         lda   <u00EA
         ora   <u0066
         sta   <u00EA
         bra   L14D1
L14B9    pshs  a
         lda   <u0066
         bita  <u00EA
         puls  a
         beq   L14D1
         inca
         inca
         exg   a,b
         bsr   L14D4
         exg   a,b
         lda   <u00EA
         eora  <u0066
         sta   <u00EA
L14D1    andcc #^Carry
L14D3    rts

L14D4    pshs  x,b,a
         orcc  #Carry
         ldx   <u0049
         ldx   b,x
         beq   L14FB
         lda   $01,x
         cmpa  #$FF
         bne   L14E6
         jmp   $03,x
L14E6    lda   ,x
         anda  #$7F
         beq   L14FB
L14EC    lda   ,x+
         pshs  a
         anda  #$7F
         lbsr  L12B8
         lda   ,s+
         bpl   L14EC
         andcc #^Carry
L14FB    puls  pc,x,b,a

* Address 14FD
start    equ   *
         lbsr  L0072
         tfr   a,dp
         tfr   d,u
         tfr   d,x
         clra
* Clear page
L1507    clr   ,u+
         adda  #$01
         bcc   L1507

         stx   <u0087
         leay  $01,y
         sty   <u006B
         sty   <u0070
         ldx   <u0087
         leay  >$0100,x
         leax  >$02C0,y
         stx   <u0020
         leax  >$02F8,y
         stx   <u0022
         leax  >$0330,y
         stx   <u0024
         leax  >$0368,y
         stx   <u0026
         leax  >$04A0,y
         stx   <u0028
         leax  >$05FE,y
         stx   <u002A
         leax  >$075C,y
         stx   <u002C
         leax  >$075C,y
         stx   <u002E
         leax  >$0772,y
         stx   <u0030
         leax  >$07A9,y
         stx   <u0032
         leax  ,y
         stx   <u001C
         leax  >$015E,y
         stx   <u001E
         leax  >$0BC8,y
         stx   <u0034
         leax  >$03A0,y
         stx   <u0036
         leax  >$015F,y
         stx   <u0042
         leax  >$0187,y
         stx   <u0049
         leax  >$09D4,y
         stx   <u003A
         leax  >$07E0,y
         stx   <u0038
         leax  >$1533,y
         stx   <u0089
         leax  ,x
         stx   <u007F
         lbsr  L0077
         lds   <u001E
         lda   #$00
         sta   <u0048
         lda   >L000D,pcr Get terminal type
         sta   <u0041
         lda   >L000F,pcr
         sta   <u006F max pages
         lbsr  L3418
         lbsr  L0EEA
         lbsr  L112F
         lbsr  L11EA
         ldx   <u007F
         lda   <u006F max pages
         ldb   #$38
         mul
         leax  d,x
         stx   <u0069
         stx   <u007A
         ldd   #$FFFF
         std   <u008B
         sta   <u007C
         inc   <u0077
         ldx   <u002A
         stx   <u0091
         lda   <LASTROW
         inca
         sta   <u006D
         ldx   <u0036
         clra
         ldb   #$0A
L15D7    stb   ,x+
         sta   ,x+
         inca
         bpl   L15D7
         ldx   <u002E
         ldb   #$16
         lda   #$08
L15E4    sta   ,x+
         decb
         beq   L15ED
         adda  #$08
         bra   L15E4
L15ED    clr   <u00FA
         lda   #$00
         sta   <u00F9
         ldy   <u007F
         ldb   #$38
L15F8    clr   ,y+
         decb
         bne   L15F8
         ldy   <u007F
         ldd   <u0069
         std   $04,y
         ldx   #$0000
         stx   ,y
         ldb   <u0046
         leax  b,x
         stx   $02,y
         ldb   >STLM,pcr
         stb   <$17,y
         stb   <$18,y
         ldb   >L0511,pcr
         bne   L1621
         ldb   <u0046
L1621    stb   <$1C,y
         ldb   >L0514,pcr
         stb   <$26,y
         ldb   >STPL,pcr
         stb   <$2B,y
         incb
         stb   <$1B,y
         ldb   >L0512,pcr
         stb   <$24,y
         ldb   >L0513,pcr
         bne   L1645
         ldb   <u0046
L1645    stb   <$20,y
         com   $08,y
         ldb   >STCS,pcr 12 CHARACTERS/INCH
         stb   <$2D,y
         ldb   >STVS,pcr VERTICAL SPACING
         stb   <$2E,y
         ldb   >STBFS,pcr BOLDFACE STRIKE COUNT
         stb   <$2F,y
         ldb   #$01
         ldb   >STPADC,pcr
         stb   <$32,y
         ldb   >STMMC,pcr
         stb   <$33,y
         ldb   >STPC,pcr
         stb   <$31,y
         stb   <$12,y
         tfr   y,x
         ldy   <u0022
         ldd   #$0038
         lbsr  L3EDA
         ldu   <u0022
         ldx   <u006B
         leax  -$01,x
         stx   u0006,u
         stx   u0004,u
         lda   #$F0
         sta   ,x
         lbsr  L1D2C
         lbra  L4EB8
L1698    lbsr  L0172
         beq   L16A9
L169D    lbsr  L0155   Read keyboard
         anda  #$7F
         tst   <u00AB
         beq   L16A8
         bsr   L16B4
L16A8    rts

L16A9    bsr   L16BF
         bcs   L1698
         lbsr  L2B65
         bcs   L1698
         bra   L169D
L16B4    cmpa  #$61
         bcs   L16BE
         cmpa  #$7A
         bhi   L16BE
         suba  #$20
L16BE    rts

L16BF    pshs  u,y,x,b,a
         tst   <u009E
         bne   L1704
         tst   <u0093
         bne   L16CD
         andcc #^Carry
         bra   L1702
L16CD    ldu   <u0026
         ldx   <u008F
         ldd   ,u
         std   ,x
         ldd   u0004,u
         std   $02,x
         lda   u0008,u
         sta   $04,x
         leax  $05,x
         stx   <u008F
         ldx   <u002A
         cmpx  <u008F
         beq   L16FE
L16E7    lbsr  L1D2C
         tst   TTYSTATE,u
         beq   L16FE
         tst   u0008,u
         beq   L16FA
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L16E7
L16FA    orcc  #Carry
         bra   L1702
L16FE    clr   <u0093
         orcc  #Carry
L1702    puls  pc,u,y,x,b,a
L1704    clr   <u009E
         lda   #$01
         sta   <u0093
         ldd   <u008D
         cmpd  <u005F
         beq   L1730
         subd  #$0001
         std   <u008B
         subd  <u005F
         lda   #$38
         mul
         ldx   <u007F
         leax  d,x
         ldy   <u0026
         ldd   #$0038
         lbsr  L3EDA
         ldx   <u0028
         stx   <u008F
         orcc  #Carry
         bra   L1702
L1730    clr   <u0093
         ldd   #$FFFF
         std   <u008B
         andcc #^Carry
         bra   L1702
L173B    lbsr  L10FB
         lbsr  L1146
         lbra  L0421
L1744    sta   <u00D5
         tst   <u005A
         lbne  L187E
         tst   <u00A4
         bne   L1756
         lda   #$FF
         sta   <u00D6
         clr   <u00D8
L1756    cmpu  <u0022
         bne   L1786
         lda   <u00D5
         beq   L1786
         cmpa  #$A0
         beq   L1786
         tst   <u00D7
         bne   L176E
         cmpy  u0006,u
         bne   L1786
         bra   L1782
L176E    lda   <u00A4
         cmpa  <u007E
         bhi   L1779
         sty   u0006,u
         bra   L1782
L1779    lda   <u00D6
         cmpa  #$FF
         bne   L1786
         sty   u0006,u
L1782    lda   <u00A4
         sta   <u00D6
L1786    lda   <u00D5
         beq   L17D1
         cmpa  #$F0
         beq   L17D1
         lda   <u00A4
         cmpa  <u00A3
         bcs   L17D1
         tst   <u003F
         bne   L17AD
         tst   <u00A3
         beq   L17AD
         lda   #$01
         sta   <u00D8
         tst   <u0081
         beq   L17AD
         lda   >L04FB,pcr
         lbsr  OUTREPT
         bra   L17D1
L17AD    lda   <u00A4
         suba  <u00A3
         cmpa  <u0046
         bcs   L17CA
         bhi   L17D1
         tst   <u0081
         beq   L17C2
         lda   >L04FA,pcr
         lbsr  OUTREPT
L17C2    lda   <u00D8
         ora   #$50
         sta   <u00D8
         bra   L17D1
L17CA    tst   <u0081
         beq   L17D1
         lbsr  L1AD8
L17D1    lda   <u00D5
         beq   L17DC
         cmpa  #$F0
         beq   L17DC
         inc   <u00A4
         rts
L17DC    lda   <u00A4
         suba  <u00A3
         bcs   L1803
         cmpa  <u0046
         bhi   L1826
         beq   L1807
         lda   #$20
         tst   <u003F
         bne   L17FC
         tst   <u00A3
         beq   L17FC
         lda   #$01
         andb  <u00D8
         stb   <u00D8
         lda   >L04FB,pcr
L17FC    tst   <u0081
         beq   L1803
         lbsr  OUTREPT
L1803    inc   <u00A4
         bra   L17DC
L1807    tst   <u00D8
         bmi   L1826
         tst   <u0081
         beq   L1826
         tst   <u00D5
         beq   L1821
         tst   u0008,u
         beq   L181B
         lda   #$2D
         bra   L1823
L181B    lda   >L04F5,pcr
         bra   L1823
L1821    lda   #$20
L1823    lbsr  OUTREPT
L1826    cmpu  <u0022
         bne   L187D
         clr   <u00A2
         ldd   u0006,u
         cmpd  ,u
         bcs   L187D
         cmpd  u0002,u
         bcc   L187D
         lda   <u00D5
         cmpa  #$F0
         bne   L1848
         cmpy  u0006,u
         bne   L1848
         ldb   <u0046
         bra   L1878
L1848    ldb   <u00D6
         subb  <u00A3
         bcs   L186F
         cmpb  <u0046
         bhi   L1874
         tst   <u00D8
         beq   L1878
         tstb
         bne   L1863
         lda   <u00D8
         bita  #$01
         beq   L1878
         inc   <u00A2
         bra   L1878
L1863    cmpb  <u0046
         bne   L1878
         tst   <u00D8
         bpl   L1878
         inc   <u00A2
         bra   L1878
L186F    inc   <u00A2
         clrb
         bra   L1878
L1874    inc   <u00A2
         ldb   <u0046
L1878    lda   <u003E
         lbsr  GOROWCOL
L187D    rts

L187E    tsta
         beq   L18D5
         cmpa  #$F0
         beq   L18D5
         cmpa  #$A0
         beq   L18A9
         lda   ,y
         cmpa  <u0031,u
         lbeq  L19C4
         tsta
         bpl   L18A9
         cmpa  #$F1
         bne   L18A3
         leax  $01,y
         cmpx  u0002,u
         bne   L18D5
         lda   #$2D
         bra   L18A9
L18A3    bsr   L18D6
         lda   $01,y
         bra   L18AB
L18A9    clr   <u00DF
L18AB    cmpa  >PNCHR,pcr
         bne   L18B4
         lbsr  L1B18
L18B4    anda  #$7F
         sta   <u00DD
         tst   <u00E4
         beq   L18C6
         dec   <u00E4
         bne   L18C6
         tst   <u00E3
         beq   L18C6
         dec   <u00E3
L18C6    lda   <u002D,u
         ldb   <u004C
         lbsr  L2C1E
         adda  <u00E3
         sta   <u00DE
         lbra  L1443
L18D5    rts

L18D6    ldb   ,y
         andb  #$7F
         cmpb  #$5F
         beq   L1913
         cmpb  #$7E
         beq   L1917
         decb
         stb   <u0065
         bitb  #$08
         lbne  L1910
         andb  #$70
         cmpb  #$30
         bne   L18F7
         ldb   #$0F
         andb  <u0065
         bra   L190D
L18F7    cmpb  #$40
         bne   L1903
         ldb   #$0F
         andb  <u0065
         addb  #$10
         bra   L190D
L1903    cmpb  #$60
         bne   L1910
         ldb   #$0F
         andb  <u0065
         addb  #$20
L190D    stb   <u00DF
         rts
L1910    clrb
         bra   L190D
L1913    ldb   #$01
         bra   L190D
L1917    ldb   #$02
         bra   L190D

L191B    pshs  x,b,a
         lda   <u004B
         anda  #$04
         bne   L192B
         lda   <u004B
         anda  #$01
         beq   L1981
         bra   L198D
L192B    lda   <u00DD
         beq   L1944
         anda  #$7F
         ldx   <u0036
         lsla
         tfr   a,b
         abx
         ldb   ,x
         lda   <u00E1
         stb   <u00E1
         adda  <u00E1
         asra
         adda  <u00E3
         sta   <u00DE
L1944    ldb   <u00E0
         ldx   <u0036
         lslb
         abx
         lda   $01,x
         cmpa  #$20
         bcc   L1963
         adda  #$40
         tst   <u00DC
         bne   L196F
         pshs  a
         lda   #$0E
         sta   <u00DC
L195C    lbsr  L12B8
         puls  a
         bra   L196F
L1963    tst   <u00DC
         beq   L196F
         pshs  a
         clr   <u00DC
         lda   #$0F
         bra   L195C
L196F    ldb   <u00DD
         sta   <u00DD
         stb   <u00E0
         ldb   <u00DF
         lda   <u00E2
         stb   <u00E2
         sta   <u00DF
         tst   <u00E0
         beq   L1983
L1981    puls  pc,x,b,a
L1983    lda   #$20
         sta   <u00E0
         clr   <u00E1
         clr   <u00E2
         bra   L1981
L198D    clr   <u00E7
         tst   <u0030,u
         beq   L19C2
         lda   <u00DD
         cmpa  #$20
         beq   L19A1
         lbsr  L12B8
         lda   <u00E3
         sta   <u00DE
L19A1    lda   <u00DE
         cmpa  #$06
         bls   L19AF
         suba  #$06
         sta   <u00DE
         lda   #$06
         bra   L19B1
L19AF    clr   <u00DE
L19B1    tsta
         beq   L19C2
         pshs  a
         lda   #$1B
         lbsr  L12B8
         puls  a
         lbsr  L12B8
         bra   L19A1
L19C2    bra   L1981
L19C4    pshs  x
         sty   <u0063
         leax  $01,y
L19CB    lda   ,x+
         bmi   L19D8
         cmpa  <u0031,u
         beq   L19DC
         cmpx  u0002,u
         bcs   L19CB
L19D8    tfr   x,y
         puls  pc,x
L19DC    ldx   <u0063
L19DE    leax  $01,x
L19E0    lda   ,x
         cmpa  <u0031,u
         beq   L19D8
         cmpa  #$20
         beq   L19DE
         cmpa  #$2C
         beq   L19DE
         lbsr  L16B4
         cmpa  >PSCHR,pcr 'S'
         beq   L1A36
         cmpa  >L0501,pcr
         beq   L1A5C
         cmpa  >L0502,pcr
         lbeq  L1A96
         cmpa  >L0506,pcr
         lbeq  L1AB1
         cmpa  >L0507,pcr
         lbeq  L1ABD
         cmpa  >L0508,pcr
         lbeq  L1AC6
         cmpa  >L0509,pcr
         lbeq  L1ACF
         lbsr  L4A83
         bcs   L19D8
         pshs  x
         lbsr  L12B8
         puls  x
         leax  -$01,x
         bra   L19E0
L1A36    lda   $01,x
         cmpa  #$20
         beq   L1A47
         cmpa  #$2C
         beq   L1A47
         cmpa  <u0031,u
         lbne  L19D8
L1A47    pshs  x
         lda   #$03
         lbsr  L1185
         ldx   >PSQS1,pcr Hit any key to restart printer
         lbsr  WRLINE3
         lbsr  L1698
         puls  x
         bra   L19DE
L1A5C    leax  $01,x
         lbsr  L4364
         lbcs  L19D8
         pshs  x
         pshs  b
         clr   <u00DF
         clr   <u00DE
         lda   #$20
         sta   <u00DD
         lbsr  L1443
         lda   #$0D
         lbsr  L12B8
         ldy   <u001C
         lda   #$20
         sta   ,y
L1A80    tst   ,s
         beq   L1A8D
         lda   #$20
         lbsr  L187E
         dec   ,s
         bra   L1A80
L1A8D    puls  b
         puls  x
         leax  -$01,x
         lbra  L19E0
L1A96    lda   $01,x
         cmpa  #$20
         beq   L1AA7
         cmpa  #$2C
         beq   L1AA7
         cmpa  <u0031,u
         lbne  L19D8
L1AA7    pshs  x
         lbsr  L1438
         puls  x
         lbra  L19DE
L1AB1    pshs  b
         ldb   #$2C
         lbsr  L14D4
L1AB8    puls  b
         lbra  L19DE
L1ABD    pshs  b
         ldb   #$2E
         lbsr  L14D4
         bra   L1AB8
L1AC6    pshs  b
         ldb   #$30
         lbsr  L14D4
         bra   L1AB8
L1ACF    pshs  b
         ldb   #$32
         lbsr  L14D4
         bra   L1AB8
L1AD8    lda   <u00D5
         cmpa  #$A0
         beq   L1B15
         lda   ,y
         bpl   L1B0D
         cmpa  #$F0
         bne   L1AEC
         lda   >L04F5,pcr
         bra   L1B0D
L1AEC    cmpa  #$F1
         bne   L1AF4
         lda   #$2D
         bra   L1B0D
L1AF4    tst   <u007D
         beq   L1B00
         cmpa  #$B2
         bne   L1B0A
         lda   #$5F
         bra   L1B0A
L1B00    lda   $01,y
         cmpa  >PNCHR,pcr
         bne   L1B0A
         bsr   L1B18
L1B0A    lbra  L1026
L1B0D    cmpa  >PNCHR,pcr
         bne   L1B15
         bsr   L1B18
L1B15    lbra  OUTREPT
L1B18    tst   u0008,u
         bne   L1B1D
         rts
L1B1D    pshs  x,b
         tst   <u00B1
         beq   L1B34
         ldb   <u00B0
         incb
         ldx   <u0034
         lda   b,x
         beq   L1B30
         stb   <u00B0
         puls  pc,x,b
L1B30    lda   #$20
         puls  pc,x,b
L1B34    ldd   <u0011,u
         lbsr  L2672
         ldx   <u0034
         clrb
L1B3D    lda   b,x
         cmpa  #$20
         bne   L1B46
         incb
         bra   L1B3D
L1B46    stb   <u00B0
         inc   <u00B1
         puls  pc,x,b
L1B4C    ldx   ,u
         lbeq  L1BEA
         clr   <u0034,u
         lda   #$05
         sta   <u00F0
         lbsr  L30F5
         tst   <u0030,u
         lbne  L1C47
         incb
L1B64    decb
         beq   L1BAD
         cmpx  <u0070
         beq   L1BE2
         lda   ,x+
         bmi   L1BEB
         cmpa  <u0031,u
         bne   L1B64
         incb
         clr   <u00E8
L1B77    inc   <u00E8
         lda   #$18
         cmpa  <u00E8
         bcs   L1BA3
         lda   ,x+
         bmi   L1BE2
         lbsr  L16B4
         cmpa  >L0502,pcr
         beq   L1C00
         cmpa  >L0501,pcr
         lbeq  L1C26
         cmpa  <u0031,u
         bne   L1B77
         lda   <u0034,u
         adda  <u00E8
         sta   <u0034,u
         bra   L1B64
L1BA3    lda   <u0034,u
         adda  <u00E8
         sta   <u0034,u
         bra   L1BE2
L1BAD    stx   u0002,u
         tst   u0008,u
         bne   L1BB5
         stx   u0004,u
L1BB5    lda   ,x
         cmpa  #$20
         bne   L1BC3
         leax  $01,x
         dec   <u00F0
         beq   L1BE2
         bra   L1BB5
L1BC3    cmpa  #$F0
         beq   L1BE0
L1BC7    lda   ,-x
         cmpa  #$20
         beq   L1BE0
         cmpa  #$F1
         beq   L1BE0
         cmpa  #$2D
         beq   L1BE0
         cmpa  <u0031,u
         beq   L1BF3
         cmpx  ,u
         bne   L1BC7
         bra   L1BEA
L1BE0    leax  $01,x
L1BE2    stx   u0002,u
         tst   u0008,u
         bne   L1BEA
         stx   u0004,u
L1BEA    rts
L1BEB    cmpa  #$F0
         beq   L1BE2
         incb
         lbra  L1B64
L1BF3    lda   ,-x
         cmpa  <u0031,u
         beq   L1BC7
         cmpx  ,u
         bhi   L1BF3
         bra   L1BEA
L1C00    lda   -$02,x
         cmpa  #$20
         beq   L1C11
         cmpa  #$2C
         beq   L1C11
         cmpa  <u0031,u
         lbne  L1B77
L1C11    lda   ,x
         cmpa  #$20
         beq   L1C22
         cmpa  #$2C
         beq   L1C22
         cmpa  <u0031,u
         lbne  L1B77
L1C22    incb
         lbra  L1B77
L1C26    pshs  x,b,a
         lbsr  L4364
         bcs   L1C42
         stb   <u0066
         ldb   <u00A0
         subb  <u0066
         bcs   L1C42
         stb   <u0066
         cmpb  #$06
         bcs   L1C42
         puls  x,b,a
         ldb   <u0066
         lbra  L1B77
L1C42    puls  x,b,a
         lbra  L1B77
L1C47    ldy   <u0036
         lda   <u002D,u
         ldb   <u004C
         lbsr  L2C1E
         ldb   <u00A0
         mul
         std   <u0067
L1C57    cmpx  <u0070
         lbeq  L1CDC
         ldb   ,x+
         lbmi  L1CE5
         cmpb  <u0031,u
         beq   L1C7B
         lslb
         clra
         ldb   d,y
         stb   <u00E1
         clra
         pshs  b,a
         ldd   <u0067
         subd  ,s++
         std   <u0067
         bcc   L1C57
         bra   L1CAA
L1C7B    clr   <u00E8
L1C7D    inc   <u00E8
         lda   #$18
         cmpa  <u00E8
         bcs   L1CA0
         lda   ,x+
         bmi   L1CDC
         cmpa  >L0502,pcr
         lbeq  L1D02
         cmpa  <u0031,u
         bne   L1C7D
         lda   <u0034,u
         adda  <u00E8
         sta   <u0034,u
         bra   L1C57
L1CA0    lda   <u0034,u
         adda  <u00E8
         sta   <$34,y
         bra   L1CDC
L1CAA    leax  -$01,x
         stx   u0002,u
         tst   u0008,u
         bne   L1CB4
         stx   u0004,u
L1CB4    lda   ,x
         cmpa  #$20
         bne   L1CC2
         leax  $01,x
         dec   <u00F0
         beq   L1CDC
         bra   L1CB4
L1CC2    cmpa  #$F0
         beq   L1CDA
L1CC6    lda   ,-x
         cmpa  #$20
         beq   L1CDA
         cmpa  #$F1
         beq   L1CDA
         cmpa  #$2D
         beq   L1CDA
         cmpx  ,u
         bne   L1CC6
         bra   L1CE4
L1CDA    leax  $01,x
L1CDC    stx   u0002,u
         tst   u0008,u
         bne   L1CE4
         stx   u0004,u
L1CE4    rts
L1CE5    cmpb  #$F0
         beq   L1CDC
         cmpa  #$F1
         lbne  L1C57
         ldb   #$5A
         clra
         ldb   d,y
         clra
         pshs  b,a
         ldd   <u0067
         subd  ,s++
         lbcs  L1CAA
         lbra  L1C57
L1D02    lda   -$02,x
         cmpa  #$20
         beq   L1D13
         cmpa  #$2C
         beq   L1D13
         cmpa  <u0031,u
         lbne  L1C7D
L1D13    lda   ,x
         cmpa  #$20
         beq   L1D24
         cmpa  #$2C
         beq   L1D24
         cmpa  <u0031,u
         lbne  L1C7D
L1D24    ldb   <u00E1
         clra
         addd  <u0067
         lbra  L1C7D
L1D2C    tst   u0008,u
         beq   L1D38
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L1DA8
L1D38    ldx   u0002,u
         cmpx  <u0070
         bcs   L1D43
         lda   #$0A
         orcc  #Carry
         rts
L1D43    cmpu  <u0022
         bne   L1DA8
         ldd   u000F,u
         subd  <u005F
         addb  #$02
         cmpb  <u006F max pages
         bcs   L1D68
         lda   <u0024,u
         inca
         adda  <u002C,u
         cmpa  <u001B,u
         bcc   L1D63
         cmpa  <u002B,u
         bcs   L1D68
L1D63    lda   #$0B
         orcc  #Carry
         rts
L1D68    tst   u0008,u
         bne   L1D7F
         ldy   <u007A
         sty   <u00B8
         ldx   ,u
L1D74    lda   ,x+
         sta   ,y+
         cmpx  u0004,u
         bne   L1D74
         sty   <u007A
L1D7F    ldx   <u002C
         stx   <u0061
         ldx   <u0091
         cmpx  <u0061
         beq   L1DA8
         tst   u0008,u
         bne   L1D98
         ldd   <u00B8
         std   ,x
         sty   $02,x
         clr   $04,x
         bra   L1DA4
L1D98    ldd   ,u
         std   ,x
         ldd   <u007A
         std   $02,x
         lda   #$01
         sta   $04,x
L1DA4    leax  $05,x
         stx   <u0091
L1DA8    lbsr  L1E8E
         lda   <u002C,u
         cmpa  <u002B,u
         bhi   L1E14
         cmpa  <u001B,u
         bcc   L1DFF
         cmpa  <u0019,u
         bls   L1DDD
         clr   u0008,u
         ldx   u0004,u
L1DC1    stx   ,u
         lbsr  L1B4C
         tst   u0008,u
         beq   L1DDA
         ldd   [,u]
         cmpa  >PRCCHR,pcr
         bne   L1DDA
         cmpb  >PRCCHR,pcr
         lbne  L1D2C
L1DDA    andcc #^Carry
         rts
L1DDD    lda   #$01
         sta   u0008,u
         lda   TTYSTATE,u
         cmpa  #$01
         bne   L1DF3
         ldx   #$0000
         cmpx  ,u
         bne   L1DF3
         ldx   <u0015,u
         bra   L1DF5
L1DF3    ldx   u0002,u
L1DF5    cmpx  <u007A
         bne   L1DC1
         ldx   <u0022
         ldx   ,x
         bra   L1DC1
L1DFF    lda   #$01
         sta   u0008,u
         ldx   u0004,u
         cmpx  u0002,u
         bne   L1DF3
         lda   <u001B,u
         sta   <u002C,u
         ldx   <u0013,u
         bra   L1DF5
L1E14    lda   <u001E,u
         sta   <u0019,u
         lda   <u001F,u
         sta   <u001A,u
         lbsr  L412E
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
         cmpu  <u0022
         beq   L1E4F
         andcc #^Carry
         rts
L1E4F    ldy   <u0028
         ldx   <u002A
         ldd   #$015E
         lbsr  L3EDA
         ldd   <u0091
         subd  #$015E
         std   <u008F
         ldd   <u008D
         std   <u008B
         addd  #$0001
         std   <u008D
         ldx   <u002A
         stx   <u0091
         clr   <u0093
         ldd   u000F,u
         subd  <u005F
         lda   #$38
         mul
         ldx   <u007F
         leay  d,x
         ldx   <u0022
         ldd   #$0038
         pshs  y
         lbsr  L3EDA
         puls  x
         ldd   <u007A
         std   $04,x
         andcc #^Carry
         rts
L1E8E    tst   u0008,u
         beq   L1E9C
         lda   [,u]
         cmpa  >PRCCHR,pcr
         lbeq  L1F69
L1E9C    ldx   u0009,u
         leax  $01,x
         stx   u0009,u
         inc   u000D,u
         lda   <u001D,u
         bne   L1EF2
         lda   [,u]
         cmpa  >PRCCHR,pcr
         lbeq  L1F69
         ldx   u000B,u
         leax  $01,x
         stx   u000B,u
         inc   TTYSTATE,u
         tst   u0008,u
         bne   L1EDE
         lda   <u0024,u
         inca
         adda  <u002C,u
         sta   <u002C,u
         clr   <u0029,u
         tst   <u0025,u
         beq   L1ED4
         dec   <u0025,u
L1ED4    tst   <u0027,u
         beq   L1EDC
         dec   <u0027,u
L1EDC    bra   L1EF1
L1EDE    inc   <u002C,u
         tst   <u0021,u
         beq   L1EE9
         dec   <u0021,u
L1EE9    tst   <u0022,u
         beq   L1EF1
         dec   <u0022,u
L1EF1    rts
L1EF2    ldd   [,u]
         cmpa  >PRCCHR,pcr
         bne   L1F52
         cmpb  >PRCCHR,pcr
         bne   L1F52
         lda   <u001D,u
         cmpa  #$01
         bne   L1F1D
         lda   <u002B,u
         suba  <u001A,u
         bcs   L1F6D
         suba  <u001E,u
         bcs   L1F6D
         cmpa  #$03
         bls   L1F6D
         clr   <u001D,u
         bra   L1EF1
L1F1D    clr   <u001D,u
         lda   <u002B,u
         suba  <u0019,u
         bcs   L1F6D
         suba  <u001F,u
         bcs   L1F6D
         cmpa  #$03
         bls   L1F6D
         lda   <u001A,u
         ldb   <u001B,u
         pshs  b,a
         lda   <u001F,u
         sta   <u001A,u
         lbsr  L412E
         lda   <u001B,u
         cmpa  TTYSTATE,u
         puls  b,a
         bhi   L1EF1
         stb   <u001B,u
         sta   <u001A,u
         rts
L1F52    lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L1F69
         lda   <u001D,u
         cmpa  #$01
         bne   L1F65
         inc   <u001E,u
         rts
L1F65    inc   <u001F,u
         rts
L1F69    lbsr  L3EED
         rts
L1F6D    clrb
         stb   <u0019,u
         comb
         stb   <u001B,u
         clr   <u001E,u
         clr   <u001F,u
         clr   <u001D,u
         cmpu  <u0022
         lbne  L1EF1
         lda   #$10
         lbsr  L2AF4
         rts

L1F8B    lbsr  L1173
         clr   <u00CA
L1F90    ldu   <u0022
L1F92    lbsr  L2FBE
L1F95    lda   <u003F
         cmpa  <u0046
         bcc   L1F90
         ldd   u000F,u
         subd  <u005F
         addb  #$02
         cmpb  <u006F
         bcs   L1FBE
         lda   <u0024,u
         inca
         adda  <u002C,u
         cmpa  <u001B,u
         bcc   L1FB6
         cmpa  <u002B,u
         bcs   L1FBE
L1FB6    lda   #$0B
         lbsr  L2AF4
         lbra  L20D4
L1FBE    lbsr  L1698
         cmpa  >L04DE,pcr
         bne   L1FCB
         clr   <u00CA
         bra   L1F95
L1FCB    cmpa  #$1F
         lbls  L20A4
         cmpa  #$7F
         lbhi  L20A4
L1FD7    sta   <u0084
         tst   <u00CA
         lbne  L205A
L1FDF    lbsr  L2ABC
         bcs   L1F95
         lda   <u0084
         cmpa  #$20
         lbeq  L206C
         cmpa  #$2D
         lbeq  L206C
         cmpa  #$F0
         lbeq  L200D
L1FF8    lbsr  L237E
         bcs   L1F92
         ldy   u0006,u
         tst   <u00CA
         beq   L2006
         leay  -$01,y
L2006    leay  -$01,y
         lbsr  L1AD8
         bra   L1F95
L200D    lda   <u00FA
         cmpa  #$00
         beq   L206C
         lda   <u00F9
         cmpa  #$00
         beq   L206C
         lbsr  L237E
         lda   <u00F9
         suba  <u002A,u
         sta   <u0029,u
         lbsr  L2FBE
         ldy   u0006,u
         lbsr  L1698
         cmpa  #$0D
         beq   L204A
         pshs  a
         lda   <u0029,u
         clr   <u0029,u
L2039    pshs  a
         lda   #$20
         lbsr  L2ABC
         puls  a
         deca
         bne   L2039
         puls  a
         lbra  L1FCB
L204A    lda   #$07
         lbsr  WrA2BUF
         clr   <u00F9
         clr   <u0029,u
         lbsr  L237E
         lbra  L1F92
L205A    cmpa  #$F0
         lbeq  L1FDF
         pshs  a
         lda   <u00CA
         lbsr  L2ABC
         puls  a
         lbra  L1FDF
L206C    lda   u000D,u
         cmpa  #$01
         lbeq  L1FF8
         ldx   <u007A
         lda   -$01,x
         cmpa  #$F0
         lbeq  L1FF8
         ldx   u0006,u
         leax  -$01,x
         stx   <u0061
         ldx   ,u
         bra   L2096
L2088    lda   ,x+
         cmpa  #$20
         lbeq  L1FF8
         cmpa  #$2D
         lbeq  L1FF8
L2096    cmpx  <u0061
         bne   L2088
         lbsr  L220A
         lbcs  L1F92
         lbra  L1FF8
L20A4    cmpa  >BSC,pcr
         lbeq  L2143
         cmpa  #$0D
         beq   L20CF
         cmpa  >ESCC,pcr
         beq   L20D4
         cmpa  >L04F2,pcr
         beq   L20FC
         lbsr  L3924
         tstb
         beq   L20C5
         lbra  L1F95
L20C5    lbsr  L26BF
         lbcc  L1F95
         lbra  L1F92
L20CF    lda   #$F0
         lbra  L1FD7
L20D4    andcc #^Carry
         lbsr  L117C
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L20E9
         tst   <u001D,u
         beq   L20E9
         lbra  L23E3
L20E9    tst   <u007C
         bne   L20F2
         inc   <u007C
         lbra  L23E7
L20F2    lda   <u0077
         inca
         sta   <u006D
         sta   <u0075
         lbra  L23E3
L20FC    ldx   <u007A
         lda   -$01,x
         cmpa  #$F0
         beq   L2113
         ldx   u0009,u
         cmpx  #$0001
         beq   L2113
L210B    lda   #$1D
         lbsr  L2AF4
         lbra  L1F95
L2113    lbsr  L2A89
         bcs   L210B
         sta   <u00AD
         tst   <u001D,u
         bne   L2124
         lda   <u001C,u
         bra   L2127
L2124    lda   <u0020,u
L2127    cmpa  <u00AD
         bcs   L210B
         lda   <u00AD
         suba  <u00A5
         bls   L213D
L2131    pshs  a
         lda   #$20
         lbsr  L2ABC
         puls  a
         deca
         bne   L2131
L213D    lbsr  L237E
         lbra  L1F92
L2143    ldx   u0006,u
         lbsr  L0169
         cmpx  ,u
         beq   L2199
         lda   ,-x
         cmpa  #$F1
         bne   L215C
L2152    lda   ,-x
         cmpx  ,u
         beq   L2166
         cmpa  #$F1
         beq   L2152
L215C    cmpx  ,u
         beq   L2166
         lda   -$01,x
         bpl   L2166
         leax  -$01,x
L2166    ldy   u0006,u
         tfr   x,d
         subd  ,u
         lbsr  L3EC7
         sty   ,u
L2173    lbsr  L220A
         lbcs  L1F92
         lbsr  L237E
         lbcs  L1F92
         ldd   <u003E
         decb
         lbsr  GOROWCOL
         lda   >L04F4,pcr
         ldb   #$02
         lbsr  L1033
         ldd   <u003E
         decb
         lbsr  GOROWCOL
         lbra  L1F95
L2199    tst   <u007C
         beq   L21A1
         ldx   u0009,u
         bra   L21A3
L21A1    ldx   u000B,u
L21A3    leax  -$01,x
         cmpx  #$FFFF
         bne   L21B4
         ldu   <u0022
         lda   #$07
         lbsr  L2AF4
         lbra  L1F90
L21B4    lbsr  L24D0
         tst   <u007C
         bne   L21D0
         ldy   <u0022
         ldd   $09,y
         subd  $0B,y
         addd  u000B,u
         subd  u0009,u
         beq   L21D0
         lda   #$11
         lbsr  L2AF4
         lbra  L1F90
L21D0    tst   u0008,u
         beq   L21D8
         ldu   <u0020
         bra   L2199
L21D8    lda   [,u]
         cmpa  #$F0
         beq   L21E8
         ldx   <u007A
         leax  -$01,x
         stx   <u007A
         ldu   <u0022
         bra   L2173
L21E8    ldy   <u0022
         ldd   ,y
         std   ,u
         ldd   $02,y
         std   u0002,u
         std   u0004,u
         ldd   $09,y
         std   <u00BA
         ldx   <u007A
         leax  -$01,x
         stx   <u00B6
         leax  >L1F90,pcr
         pshs  x
         leas  -$04,s
         lbra  L2290
L220A    pshs  u,y
         ldy   <u0022
         ldx   $09,y
         stx   <u00BA
L2213    cmpx  #$0000
         beq   L2285
         leax  -$01,x
         beq   L2285
         lda   <u007C
         pshs  a
         lda   #$01
         sta   <u007C
         sta   <u00CF
         lbsr  L24D0
         puls  a
         sta   <u007C
         tst   u0008,u
         beq   L2245
         ldx   <u007F
         ldy   <u0020
         ldd   $0F,y
         subd  <u005F
         lda   #$38
         beq   L2285
         mul
         leax  d,x
         ldx   $09,x
         bra   L2213
L2245    ldx   <u007A
         ldy   <u0022
         ldy   ,y
         bra   L2253
L224F    lda   ,-x
         sta   ,-y
L2253    cmpx  ,u
         bne   L224F
         sty   ,u
         stx   <u00B6
         ldd   u0004,u
         pshs  b,a
         lbsr  L1B4C
         puls  b,a
         ldx   u0002,u
         ldy   <u0022
         cmpx  ,y
         bne   L2289
         cmpd  <u007A
         lbne  L22F8
         ldx   <u00B6
         ldy   ,u
         bra   L2280
L227C    lda   ,y+
         sta   ,x+
L2280    cmpy  u0004,u
         bne   L227C
L2285    andcc #^Carry
L2287    puls  pc,u,y
L2289    ldy   <u0022
         cmpx  $06,y
         bls   L22F8
L2290    ldd   u000F,u
         ldy   <u0022
         cmpd  $0F,y
         beq   L22B0
         ldy   <u002A
         ldx   <u0028
         ldd   #$015E
         lbsr  L3EDA
         ldd   <u008B
         std   <u008D
         ldd   #$FFFF
         sta   <u009E
         std   <u008B
L22B0    ldb   u000D,u
         lda   #$05
         mul
         ldx   <u002A
         cmpd  #$015E
         bls   L22C1
         ldx   <u002C
         bra   L22C3
L22C1    leax  d,x
L22C3    stx   <u0091
         ldy   <u0022
         ldx   $06,y
         pshs  x
         ldx   <u0020
         ldb   #$38
         clra
         lbsr  L3EDA
         puls  x
         ldy   <u0022
         stx   $06,y
         ldx   <u00B6
         stx   <u007A
         ldd   <u00BA
         subd  u0009,u
         pshs  b,a
         ldb   <u003E
         clra
         subd  ,s++
         bcc   L22ED
         clrb
L22ED    stb   <u0077
         incb
         stb   <u006D
         stb   <u0075
         orcc  #Carry
         bra   L2287
L22F8    ldx   <u00B6
         ldy   ,u
         bra   L2303
L22FF    lda   ,y+
         sta   ,x+
L2303    cmpy  u0004,u
         bne   L22FF
         stx   <u00BC
         stx   <u007A
         ldx   <u0022
         sty   ,x
         ldd   u000F,u
         cmpd  <u008B
         bne   L2347
         ldx   <u002A
         stx   <u0061
         lda   #$05
         ldb   u000D,u
         mul
         ldx   <u0028
         leax  d,x
         bra   L232D
L2327    ldd   <u007A
         std   $02,x
         leax  $05,x
L232D    cmpx  <u0061
         bcs   L2327
         ldy   <u0022
         ldd   $0F,y
         subd  <u005F
         lda   #$38
         mul
         ldx   <u007F
         leax  d,x
         ldd   <u007A
         std   $04,x
         ldx   <u002A
         bra   L2358
L2347    ldx   <u002A
         lda   #$05
         ldb   u000D,u
         mul
         leax  d,x
         bra   L2358
L2352    ldd   <u007A
         std   $02,x
         leax  $05,x
L2358    cmpx  <u0091
         bcs   L2352
         ldd   <u00BA
         subd  u0009,u
         pshs  b,a
         ldb   <u003E
         clra
         subd  ,s++
         bcs   L2379
         tfr   b,a
         ldb   #$01
         stb   <u0081
         lbsr  L2C2B
         lda   <u0077
         inca
         sta   <u006D
         sta   <u0075
L2379    orcc  #Carry
         lbra  L2287
L237E    ldd   u0002,u
         pshs  b,a
         lbsr  L1B4C
         puls  b,a
         clr   <u0065
         cmpd  u0002,u
         beq   L2390
         inc   <u0065
L2390    ldd   u0006,u
         cmpd  u0002,u
         bcc   L23A8
         tst   <u0065
         bne   L239E
         andcc #^Carry
         rts
L239E    lda   <u0077
         inca
         sta   <u0075
         sta   <u006D
         orcc  #Carry
         rts
L23A8    tst   <u007C
         bne   L23B9
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L23D2
         tst   <u001D,u
         bne   L23D2
L23B9    lda   <u003E
         ldb   #$01
         stb   <u0081
         clr   <u00D7
         lbsr  L2C2B
         cmpa  <LASTROW
         bne   L23CB
         lbsr  L1111
L23CB    lda   <u003E
         inca
         clrb
         lbsr  GOROWCOL
L23D2    lbsr  L1D2C
         tst   u0008,u
         bne   L23A8
         lda   <u003E
         sta   <u0077
         bra   L239E
         nop
         pshs  y
         fcb   $55 U
L23E3    bsr   L23EB
         bra   L241D
L23E7    bsr   L23EB
         bra   L240D
L23EB    clr   <u0081
         ldu   <u0022
         lbsr  L220A
         bsr   L237E
         ldx   u0006,u
         cmpx  ,u
         bcs   L23FF
         cmpx  u0002,u
         bcc   L23FF
         rts
L23FF    lda   #$01
         sta   <u00D7
         clr   <u0081
         clr   <u007E
         lda   <u0077
         lbsr  L2C2B
         rts
L240D    ldu   <u0022
         lbsr  L2BBB
         lda   <u0077
         sta   <u003E
         inca
         sta   <u006D
         sta   <u0075
         clr   <u00A1
L241D    ldu   <u0022
         ldx   u0006,u
         cmpx  ,u
         bcs   L2429
         cmpx  u0002,u
         bcs   L242D
L2429    ldx   ,u
         stx   u0006,u
L242D    lda   #$01
         sta   <u0081
         clr   <u00D7
         lda   <u0077
         lbsr  L2C2B
L2438    ldu   <u0022
         lda   <u003E
         sta   <u0077
         lds   <u001E
         lbsr  L1698
         lbsr  L0169
L2447    lbsr  L26BF
         bcs   L241D
         lbsr  L16B4
         ldu   <u0022
         leax  >ESCTBL,pcr Start of keyboard commands i,l,...
         leay  >L2481,pcr
         bsr   L2466
         bcc   L2464
L245D    lda   #$03
         lbsr  L2AF4
         bra   L2438
L2464    jmp   ,x
L2466    cmpa  ,x+
         beq   L2473
         leay  $02,y
         tst   ,y
         bne   L2466
         orcc  #Carry
         rts

L2473    pshs  a
         leax  >0,pcr
         ldd   ,y
         leax  d,x
         andcc #^Carry
         puls  pc,a

L2481    fdb   L444D  I: Cursor up
         fdb   L4548  L: Cursor right
         fdb   L44DD  ,: Cursor down
         fdb L458A  J:Cursor left
 fdb $45EE
 fdb $4614
 fdb $43B7
 fdb L440F
 fdb L3B11
 fdb L3BA1
 fdb L1F8B
 fdb $3A22
 fdb $3AB1

 fdb $39A7,$3137,$3A65,$46E4,$4673,$45C3,$4783
 fdb L3B04,$476A,$23E1,$4861,$4876,$4883

 fdb $498E
 fdb L38EE,L38EE,L38EE,L38EE,L38EE,$3980,L4548
 fdb L458A
 fdb L444D
 fdb L44DD
 fdb L4548
 fdb L440F

 fcb $00

L24D0    stx   <u0078
         ldu   <u0020
L24D4    ldy   <u0022
         ldd   $0F,y
         subd  <u005F
         lda   #$38
         mul
         ldy   <u007F
         leay  d,y
L24E3    ldd   <u0078
         tst   <u007C
         beq   L24EE
         cmpd  $09,y
         bra   L24F1
L24EE    cmpd  $0B,y
L24F1    bcc   L24F8
         leay  <-$38,y
         bra   L24E3
L24F8    tfr   y,x
         ldy   <u0020
         ldd   #$0038
         lbsr  L3EDA
         ldd   u000F,u
         cmpd  <u008B
         beq   L2543
         cmpd  <u008D
         beq   L2552
L250F    lbsr  L1B4C
L2512    ldd   <u007A
         cmpd  u0004,u
         bcc   L2521
         std   u0004,u
         tst   u0008,u
         bne   L2521
         std   u0002,u
L2521    bsr   L2535
         beq   L2571
         tst   <u00CF
         beq   L2530
         ldd   u0004,u
         cmpd  <u007A
         bcc   L2571
L2530    lbsr  L1D2C
         bra   L2512
L2535    ldd   <u0078
         tst   <u007C
         beq   L253F
         cmpd  u0009,u
         rts
L253F    cmpd  u000B,u
         rts
L2543    lbsr  L16BF
         bcs   L2543
         ldy   <u0028
         sty   <u00B2
         ldx   <u002A
         bra   L255A
L2552    ldy   <u002A
         sty   <u00B2
         ldx   <u002C
L255A    stx   <u00B4
L255C    bsr   L2535
         bne   L2574
         tst   <u007C
         bne   L2571
         tst   <u001D,u
         bne   L2574
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L2574
L2571    clr   <u00CF
         rts
L2574    tst   <u00CF
         beq   L257F
         ldd   u0004,u
         cmpd  <u007A
         bcc   L2571
L257F    ldy   <u00B2
         leay  $05,y
         sty   <u00B2
         cmpy  <u00B4
         beq   L250F
         tst   $04,y
         beq   L2598
         lbsr  L1B4C
         lbsr  L1D2C
         bra   L255C
L2598    lbsr  L1E8E
         ldy   <u00B2
         ldx   ,y
         stx   ,u
         ldd   $02,y
         std   u0004,u
         lda   $04,y
         sta   u0008,u
         bra   L255C
L25AC    pshs  u
         ldu   <u0020
         ldy   <u0022
         ldd   $0F,y
         subd  u000F,u
         beq   L2623
         cmpd  #$0001
         beq   L2608
         ldd   u000F,u
         subd  <u005F
         lda   #$38
         mul
         ldx   <u007F
         leax  d,x
         ldy   <u0026
         ldd   #$0038
         lbsr  L3EDA
         ldx   <u002A
         stx   <u0091
         ldx   u000F,u
         stx   <u008D
         ldu   <u0026
         bra   L25FA
L25DF    ldx   <u0091
         ldd   ,u
         std   ,x
         ldd   u0004,u
         std   $02,x
         lda   u0008,u
         sta   $04,x
         leax  $05,x
         stx   <u0091
         ldx   <u002C
         cmpx  <u0091
         beq   L2604
         lbsr  L1D2C
L25FA    ldd   u0009,u
         ldy   <u0020
         cmpd  $09,y
         bne   L25DF
L2604    ldu   <u0020
         bra   L261C
L2608    lbsr  L16BF
         bcs   L2608
         ldy   <u002A
         ldd   #$015E
         ldx   <u0028
         lbsr  L3EDA
         ldd   <u008B
         std   <u008D
L261C    ldd   #$FFFF
         sta   <u009E
         std   <u008B
L2623    ldb   u000D,u
         lda   #$05
         mul
         ldx   <u002A
         cmpd  #$015E
         bls   L2633
         ldd   #$015E
L2633    leax  d,x
         stx   <u0091
         tst   u0008,u
         beq   L263F
         ldd   u0004,u
         bra   L2641
L263F    ldd   ,u
L2641    ldx   <u007A
         stx   <u0061
         std   <u007A
         ldd   <u0061
         subd  <u007A
         ldy   <u0022
         ldy   ,y
         lbsr  L3EC7
         tst   u0008,u
         beq   L265D
         sty   u0004,u
         bra   L2660
L265D    sty   ,u
L2660    ldx   <u0020
         ldy   <u0022
         ldd   #$0038
         lbsr  L3EDA
         ldu   <u0022
         lbsr  L1B4C
         puls  pc,u
L2672    pshs  y,x,b,a
         ldx   <u0034
         clr   $05,x
         leay  >L26B5,pcr
         pshs  a
         lda   #$05
         sta   <u0066
         puls  a
         clr   <u0065
L2686    subd  ,y
         bcs   L268E
         inc   <u0065
         bra   L2686
L268E    addd  ,y
         pshs  a
         lda   <u0065
         adda  #$30
         sta   ,x+
         puls  a
         leay  $02,y
         clr   <u0065
         dec   <u0066
         bne   L2686
         ldx   <u0034
         ldb   #$04
L26A6    lda   #$30
         cmpa  ,x
         bne   L26B3
         lda   #$20
         sta   ,x+
         decb
L26B1    bne   L26A6
L26B3    puls  pc,y,x,b,a

L26B5    fdb  10000,1000,100,10,1

* Check for control codes
L26BF    pshs  y,x,b,a
         leax  >LNDELC,pcr
         leay  >L26E8,pcr
         lbsr  L2466
         bcs   L26D6
         jsr   ,x
         bcs   L26DA
         orcc  #Carry
L26D4    puls  pc,y,x,b,a

L26D6    andcc #^Carry
         bra   L26D4
L26DA    lbsr  L2BBB
         lda   <u0077
         inca
         sta   <u0075
         sta   <u006D
         orcc  #Carry
         bra   L26D4

L26E8    fdb  L2968  Line delete
         fdb  L28C5  Character delete
         fdb  L28FC
         fdb  L270B,L272C,L2706
         fdb  L2732,L2A0D,L2A31
         fdb  L2701  Toggle upper case lock
         fdb  L299F  Ctrl-A Display help menu
         fdb  L29F7  Programmer mode
         fcb  0

L2701    com   <u00AB
         andcc #^Carry
         rts

L2706    com   <u007D
         orcc  #Carry
         rts


L270B         tst   <u007C
         beq   L2725
         clra
         tst   <u001D,u
         bne   L271D
         ldb   [,u]
         cmpb  >PRCCHR,pcr
         bne   L2727
L271D    lda   #$0F
         lbsr  L2AF4
         andcc #^Carry
         rts

L2725    lda   #$01
L2727    sta   <u007C
         orcc  #Carry
L272B    rts

L272C    lbsr  L2AFF
         andcc #^Carry
         rts

L2732    lda   #$FF
         sta   <u006D
         lbsr  L10FB
         leax  >L0527,pcr "STYPSTAT"
         ldd   ,x
         leax  >0,pcr
         leax  d,x
         lbsr  L022C
         bcs   L2760
         lbsr  L10FB

L274D    lbsr  L02E8
         bcs   L2766
L2752    cmpa  #$0D
         bne   L275B
         lbsr  WrA2BUF
         lda   #$0A
L275B    lbsr  WrA2BUF
         bra   L274D
L2760    lbsr  L02C5
         lbra  L286F
L2766    ldd   #$010D
         lbsr  GOROWCOL
         tst   <u006E
         bne   L2776
         ldx   >L0529,pcr
         bra   L277D
L2776    ldx   <u0030
         lbsr  L312A
         bra   L2780
L277D    lbsr  L310F  Write string in X
L2780    ldd   #$040E
         lbsr  GOROWCOL
         tst   <u006E
         bne   L2790
         ldx   >L0529,pcr
         bra   L2797
L2790    ldx   <u0032
         lbsr  L312A
         bra   L279A
L2797    lbsr  L310F  Write string in X
L279A    ldd   #$0208
         lbsr  GOROWCOL
         tst   <u005D
         beq   L27AA
         ldx   >L052D,pcr
         bra   L27AE
L27AA    ldx   >L052F,pcr
L27AE    lbsr  L310F  Write string in X
         ldd   #$0508
         lbsr  GOROWCOL
         tst   <u005E
         beq   L27C1
         ldx   >L052D,pcr
         bra   L27C5
L27C1    ldx   >L052F,pcr
L27C5    lbsr  L310F  Write string in X
         clr   <u00A9
         lda   #$07
         sta   <u00A8
         ldd   u000F,u
         addd  #$0001
         lbsr  L2881
         ldd   <u0011,u
         lbsr  L2881
         ldb   <u002C,u
         clra
         lbsr  L2881
         ldb   <u002B,u
         lbsr  L2881
         ldb   <u0019,u
         lbsr  L2881
         ldb   <u001A,u
         lbsr  L2881
         ldb   <u0024,u
         incb
         lbsr  L2881
         ldb   <u002E,u
         lbsr  L2881
         ldb   <u001C,u
         lbsr  L2881
         ldb   <u0020,u
         lbsr  L2881
         ldb   <u0017,u
         bsr   L2881
         ldb   <u0018,u
         bsr   L2881
         ldb   <u002A,u
         bsr   L2881
         ldb   <u002D,u
         bsr   L2881
         lda   #$1C
         sta   <u00A9
         lda   #$07
         sta   <u00A8
         clra
         ldb   <u0035,u
         bsr   L2881
         ldb   <u0036,u
         bsr   L2881
         ldb   <u0037,u
         bsr   L2881
         ldb   #$59
         tst   <u0026,u
         bne   L2843
         ldb   #$4E
L2843    bsr   L28B2
         ldb   #$59
         tst   <u0030,u
         bne   L284E
         ldb   #$4E
L284E    bsr   L28B2
         ldb   <u0031,u
         bsr   L28B2
         ldb   <u0032,u
         bsr   L28B2
         ldb   <u0033,u
         bsr   L28B2
         ldb   #$20
         bsr   L28B2
         ldd   ,u
         subd  <u007A
         bsr   L2881
         lbsr  L0287
         lbsr  L0169
L286F    lbsr  L1698
         cmpa  >ESCC,pcr
         beq   L287E
         cmpa  >PAGSTC,pcr
         bne   L286F
L287E    orcc  #Carry
         rts
L2881    pshs  b,a
         lda   <u00A8
         ldb   <u00A9
         lbsr  GOROWCOL
         inc   <u00A8
         ldd   ,s
         lbsr  L2672
         pshs  x
         ldx   <u0034
         lda   $01,x
         cmpa  #$20
         bne   L28A4
         leax  $02,x
         ldd   <u00A8
         deca
         addb  #$13
         bra   L28A9
L28A4    ldd   <u00A8
         deca
         addb  #$11
L28A9    lbsr  GOROWCOL
         lbsr  L312A
         puls  x,b,a
         rts
L28B2    pshs  b
         lda   <u00A8
         ldb   <u00A9
         addb  #$15
         lbsr  GOROWCOL
         inc   <u00A8
         puls  a
         lbsr  OUTREPT
         rts

L28C5    tst   <u00A2
         bne   L28D3
         ldy   u0006,u
         leay  $01,y
         cmpy  <u0070
         bcs   L28DB
L28D3    lda   #$12
         lbsr  L2AF4
         andcc #^Carry
         rts
L28DB    lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L28E8
         tst   <u001D,u
         beq   L28EA
L28E8    inc   <u0075
L28EA    ldx   u0006,u
         lda   ,x
         bpl   L28FA
         cmpa  #$F0
         beq   L28FA
         cmpa  #$F1
         beq   L28FA
         leay  $01,y
L28FA    bra   L2944

L28FC    tst   <u00A2
         bne   L28D3
         ldx   u0006,u
         lda   ,x
         cmpa  #$F0
         beq   L28C5
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L2915
         tst   <u001D,u
         beq   L2917
L2915    inc   <u0075
L2917    cmpx  ,u
         beq   L292D
         lda   ,x
         bmi   L2927
         cmpa  #$20
         beq   L292B
L2923    leax  -$01,x
         bra   L2917
L2927    cmpa  #$F0
         bne   L2923
L292B    leax  $01,x
L292D    ldy   u0006,u
L2930    lda   ,y+
         cmpa  #$20
         beq   L293C
         cmpa  #$F0
         bne   L2930
         leay  -$01,y
L293C    lda   ,y+
         cmpa  #$20
         beq   L293C
         leay  -$01,y
L2944    sty   u0006,u
L2947    cmpx  ,u
         beq   L2951
         lda   ,-x
         sta   ,-y
         bra   L2947
L2951    sty   ,u
         lbsr  L220A
         lbsr  L237E
         tst   <u0075
         beq   L2965
L295E    lda   <u0077
         inca
         sta   <u0075
         sta   <u006D
L2965    andcc #^Carry
         rts

* Line delete
L2968    ldx   <u007A
         lda   -$01,x
         cmpa  #$F0
         beq   L2980
         ldd   u0009,u
         cmpd  #$0001
         beq   L2980
L2978    lda   #$14
         lbsr  L2AF4
         andcc #^Carry
         rts

L2980    ldx   u0002,u
         lda   ,-x
         cmpa  #$F0
         bne   L2978
         ldy   ,u
         stx   ,u
         stx   u0006,u
         lda   ,y
         cmpa  >PRCCHR,pcr
         beq   L295E
         tst   <u001D,u
         bne   L295E
         andcc #^Carry
         rts

* Display help menu
L299F    lda   #$FF
         sta   <u006D
         lbsr  L10FB
         ldb   #$07
         ldx   >HLPS1,pcr
         lbsr  L4B2E
L29AF    tsta
         beq   L29F4
         leax  >HLPS2,pcr
         deca
         lsla
         leax  a,x
         ldd   ,x
         leax  >0,pcr
         leax  d,x
         lbsr  L022C
         bcs   L29DD
         lbsr  L10FB
L29CA    lbsr  L02E8
         bcs   L29EB
         cmpa  #$0D
         bne   L29D8
         lbsr  WrA2BUF
         lda   #$0A
L29D8    lbsr  WrA2BUF
         bra   L29CA
L29DD    ldd   #$0000
         lbsr  GOROWCOL
         lbsr  L02C5
         lbsr  L4BAF
         bra   L29AF
L29EB    lbsr  L0287
         lbsr  L0169
         lbsr  L1698
L29F4    orcc  #Carry
         rts

*   Programmer mode
L29F7    lda   <u00FA
         cmpa  #$01 Is on?
         beq   L2A03 branch if yes
         lda   #$01
         sta   <u00FA
         bra   L2A07
L2A03    lda   #$00 Turn off
         sta   <u00FA
L2A07    lda   #$07
         lbsr  WrA2BUF
         rts

L2A0D    ldx   u0006,u
         lda   ,x
         cmpa  #$F1
         beq   L2A2E
         cmpx  ,u
         beq   L2A2E
         lda   -$01,x
         cmpa  #$F1
         beq   L2A2E
         cmpa  #$20
         beq   L2A2E
         lda   #$F1
         lbsr  L2ABC
         lbsr  L220A
         lbsr  L237E
L2A2E    andcc #^Carry
         rts

L2A31    ldb   <u003F
         addb  <u00A3
         beq   L2A4E
         ldx   <u002E
         clra
L2A3A    cmpb  a,x
         bcs   L2A4F
         beq   L2A4E
         tst   a,x
         beq   L2A4F
         inca
         cmpa  #$16
         bne   L2A3A
         lda   #$1B
         lbsr  L2AF4
L2A4E    rts
L2A4F    sta   <u0065
         ldb   #$15
         bra   L2A5C
L2A55    decb
         lda   b,x
         incb
         sta   b,x
         decb
L2A5C    cmpb  <u0065
         bne   L2A55
         lda   <u003F
         adda  <u00A3
         sta   b,x
         rts
         ldx   <u002E
         clrb
         lda   <u003F
         adda  <u00A3
L2A6E    cmpa  b,x
         beq   L2A78
         incb
         cmpb  #$16
         bne   L2A6E
L2A77    rts
L2A78    clr   b,x
L2A7A    incb
         cmpb  #$16
         beq   L2A77
         lda   b,x
         beq   L2A77
         decb
         sta   b,x
         incb
         bra   L2A7A
L2A89    ldx   ,u
         clr   <u00A5
L2A8D    cmpx  u0006,u
         bcc   L2A9F
         inc   <u00A5
         lda   ,x+
         bpl   L2A8D
         cmpa  #$F1
         beq   L2A8D
         leax  $01,x
         bra   L2A8D
L2A9F    ldx   <u002E
         lda   <u00A5
         clrb
L2AA4    cmpa  b,x
         bcs   L2AB5
         incb
         cmpb  #$16
         bne   L2AA4
         lda   #$1C
         lbsr  L2AF4
         orcc  #Carry
         rts
L2AB5    lda   b,x
         sta   <u00F9
         andcc #^Carry
         rts
L2ABC    pshs  y,a
         ldd   ,u
         subd  <u007A
         cmpd  #$00C8
         bhi   L2ADE
         cmpd  #$000A
         bcs   L2AD5
         lda   #$19
         lbsr  L2AF4
         bra   L2ADE
L2AD5    lda   #$1A
         lbsr  L2AF4
         orcc  #Carry
         puls  pc,y,a
L2ADE    ldd   u0006,u
         subd  ,u
         ldx   ,u
         leay  -$01,x
         sty   ,u
         lbsr  L3EDA
         puls  a
         sta   ,y
         andcc #^Carry
         puls  pc,y
L2AF4    pshs  a
         sta   <u0085
         lda   #$07
         lbsr  WrA2BUF
         puls  pc,a
L2AFF    pshs  x,b,a
         clrb
         lda   <u003E
         lbsr  GOROWCOL
         ldb   #$01
         pshs  b
         leax  >ERRTBL,pcr
         ldd   ,x
         leax  >0,pcr
         leax  d,x
         lbsr  L022C
         bcs   L2B3C
L2B1C    lbsr  L02E8
         bcs   L2B5C
         cmpa  #$0D
         bne   L2B1C
         puls  b
         incb
         pshs  b
         cmpb  <u0085
         bne   L2B1C
L2B2E    lbsr  L02E8
         bcs   L2B41
         cmpa  #$0D
         beq   L2B41
         lbsr  WrA2BUF
         bra   L2B2E
L2B3C    lbsr  L02C5
         bra   L2B47
L2B41    lbsr  L0287
         lbsr  L0169
L2B47    lbsr  L1698
         cmpa  >NMERC,pcr
         beq   L2B56
         cmpa  >ESCC,pcr
         bne   L2B47
L2B56    puls  b
         orcc  #Carry
         puls  pc,x,b,a

L2B5C    ldx   >BELS1,pcr
         lbsr  L310F  Write string in X  Write string in X
         bra   L2B41
L2B65    pshs  u,y,x,b,a
         tst   <u0075
         beq   L2B78
         clr   <u0075
         ldx   <u0022
         ldy   <u0024
         ldd   #$0038
         lbsr  L3EDA
L2B78    lda   <u006D
         cmpa  <LASTROW
         bls   L2B87
         lda   <LASTROW
         inca
         sta   <u006D
         andcc #^Carry
         puls  pc,u,y,x,b,a

L2B87    ldu   <u0024
L2B89    lbsr  L1D2C
         bcs   L2BB4
         tst   u0008,u
         beq   L2BA1
L2B92    lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L2B89
         tst   <u001D,u
         bne   L2B89
         bra   L2BA5
L2BA1    tst   <u007C
         beq   L2B92
L2BA5    lda   #$01
         sta   <u0081
         lda   <u006D
         lbsr  L2C2B
L2BAE    inc   <u006D
         orcc  #Carry
         puls  pc,u,y,x,b,a
L2BB4    lda   <u006D
         lbsr  L1185
         bra   L2BAE
L2BBB    pshs  u,y,x,b,a
         lda   #$01
         sta   <u0081
         tst   <u0077
         beq   L2C1C
         tst   <u007C
         bne   L2BCD
         ldd   u000B,u
         bra   L2BCF
L2BCD    ldd   u0009,u
L2BCF    subb  <u0077
         sbca  #$00
         bcc   L2BDD
         addb  <u0077
         stb   <u0077
         beq   L2C1C
         clra
         clrb
L2BDD    tfr   d,x
         lbsr  L24D0
         ldu   <u0020
         lbsr  L1B4C
         clr   <u00A9
         bra   L2C05
L2BEB    lbsr  L1D2C
         tst   u0008,u
         beq   L2C01
L2BF2    lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L2BEB
         tst   <u001D,u
         bne   L2BEB
         bra   L2C05
L2C01    tst   <u007C
         beq   L2BF2
L2C05    ldd   <u007A
         cmpd  u0002,u
         bhi   L2C0E
         std   u0002,u
L2C0E    lda   <u00A9
         lbsr  L2C2B
         lda   <u00A9
         inca
         sta   <u00A9
         cmpa  <u0077
         bne   L2BEB
L2C1C    puls  pc,u,y,x,b,a
L2C1E    sta   <u0065
         clra
L2C21    subb  <u0065
         bcs   L2C28
         inca
         bra   L2C21
L2C28    addb  <u0065
         rts
L2C2B    pshs  y,x,b,a
         clr   <u00A4
         lbsr  L30F5
         tst   <u005A
         bne   L2C44
         lbsr  L0120
         lbsr  L10EB
         ldx   <u003E
         stx   <u00D9
         clrb
         lbsr  GOROWCOL
L2C44    ldy   ,u
         lda   ,y
         cmpa  >PRCCHR,pcr
         beq   L2C7F
         tst   u0008,u
         beq   L2C69
         clr   <u00B1
         tst   u000D,u
         lbeq  L2F83
         tst   <u0021,u
         bne   L2CC1
         tst   <u0022,u
         lbne  L2EAF
         bra   L2C7F
L2C69    tst   <u0025,u
         bne   L2CC1
         tst   <u0027,u
         lbne  L2EAF
         tst   <u0026,u
         lbne  L2D7C
L2C7C    lbsr  L2F60
L2C7F    lda   ,y
         bpl   L2C98
         cmpa  #$F0
         beq   L2CA8
         cmpa  #$F1
         beq   L2C92
         lbsr  L1744
         leay  $01,y
         bra   L2C9B
L2C92    leax  $01,y
         cmpx  u0002,u
         bne   L2C9B
L2C98    lbsr  L1744
L2C9B    leay  $01,y
         cmpy  u0002,u
         bcs   L2C7F
L2CA2    clra
         lbsr  L1744
         bra   L2CAB
L2CA8    lbsr  L1744
L2CAB    tst   <u005A
         bne   L2CBF
         cmpu  <u0022
         beq   L2CB9
         ldd   <u00D9
         lbsr  GOROWCOL
L2CB9    lbsr  L10F3
         lbsr  L0121
L2CBF    puls  pc,y,x,b,a
L2CC1    tst   <u0030,u
         beq   L2CCC
         tst   <u005A
         lbne  L2EC9
L2CCC    bsr   L2CDA
         ldb   <u00A0
         subb  <u0097
         bcs   L2C7F
         lsrb
         lbsr  L2F75
         bra   L2C7F
L2CDA    ldy   ,u
         clr   <u0097
         clr   <u0099
         clr   <u0095
         clr   <u0096
         clrb
L2CE6    cmpy  u0002,u
         beq   L2D35
         lda   ,y+
         bmi   L2CE6
         cmpa  <u0031,u
         beq   L2D43
         inc   <u0097
         cmpa  #$20
         bne   L2CFE
         inc   <u0095
         bra   L2CE6
L2CFE    incb
L2CFF    cmpy  u0002,u
         bcc   L2D35
         lda   ,y+
         bpl   L2D15
         cmpa  #$F1
         bne   L2CFF
         cmpy  u0002,u
         bne   L2CFF
         inc   <u0097
         bra   L2D35
L2D15    cmpa  #$20
         beq   L2D26
         cmpa  <u0031,u
         beq   L2D43
         ldb   #$01
         inc   <u0097
         clr   <u0096
         bra   L2CFF
L2D26    inc   <u0096
         inc   <u0097
         tstb
         bne   L2D30
         clrb
         bra   L2CFF
L2D30    clrb
         inc   <u0099
         bra   L2CFF
L2D35    ldy   ,u
         tst   <u0096
         beq   L2D42
         tst   <u0099
         beq   L2D42
         dec   <u0099
L2D42    rts
L2D43    lda   ,y+
         bmi   L2CFF
         cmpa  <u0031,u
         beq   L2CFF
         cmpy  u0002,u
         bcc   L2D35
         lbsr  L16B4
         cmpa  >L0502,pcr
         bne   L2D43
         lda   -$02,y
         cmpa  #$20
         beq   L2D69
         cmpa  #$2C
         beq   L2D69
         cmpa  <u0031,u
         bne   L2D43
L2D69    lda   ,y
         cmpa  #$20
         beq   L2D78
         cmpa  #$2C
         beq   L2D78
         cmpa  <u0031,u
         bne   L2D43
L2D78    dec   <u0097
         bra   L2D43
L2D7C    ldx   u0002,u
         lda   ,-x
         cmpa  #$F0
         lbeq  L2C7C
         tst   <u005A
         beq   L2D90
         lda   <u004C
         lbne  L2E2B
L2D90    lbsr  L2F60
         lbsr  L2CDA
         tst   <u0099
         lbeq  L2C7F
         lda   <u001C,u
         adda  <u0096
         suba  <u0097
         suba  <u0029,u
         suba  <u002A,u
         lbmi  L2C7F
         lbeq  L2C7F
         clr   <u009B
L2DB3    suba  <u0099
         bls   L2DBB
         inc   <u009B
         bra   L2DB3
L2DBB    adda  <u0099
         sta   <u009D
         beq   L2DC3
         inc   <u009B
L2DC3    lda   <u009B
         deca
         sta   <u009C
         clr   <u00EE
         clr   <u0066
L2DCC    cmpy  u0002,u
         lbeq  L2CA2
         lda   ,y+
         bmi   L2DF8
         cmpa  #$20
         beq   L2DE1
         orcc  #Carry
         ror   <u0066
         bra   L2E0F
L2DE1    tst   <u0066
         beq   L2E0F
         tst   <u009D
         beq   L2DEF
         dec   <u009D
         ldb   <u009B
         bra   L2DF1
L2DEF    ldb   <u009C
L2DF1    lbsr  L2F75
         clr   <u0066
         bra   L2E0F
L2DF8    cmpa  #$F0
         lbeq  L2CA8
         cmpa  #$F1
         bne   L2E09
         cmpy  u0002,u
         bne   L2DCC
         bra   L2E13
L2E09    lda   #$01
         sta   <u00EE
         bra   L2DCC
L2E0F    tst   <u00EE
         bne   L2E1E
L2E13    leay  -$01,y
         lda   #$20
         lbsr  L1744
         leay  $01,y
         bra   L2DCC
L2E1E    leay  -$02,y
         lda   #$20
         lbsr  L1744
         leay  $02,y
         clr   <u00EE
         bra   L2DCC
L2E2B    lbsr  L2CDA
         ldb   <u0095
         addb  <u002A,u
         addb  <u0029,u
         lbsr  L2F75
         tst   <u0030,u
         beq   L2E55
         lbsr  L2F1C
         ldy   <u0036
         ldb   #$40
         ldb   b,y
         lda   <u0096
         mul
         std   <u0067
         ldd   <u00E5
         subd  <u0067
         std   <u00E5
         bra   L2E5E
L2E55    ldb   <u0097
         subb  <u0096
         lda   <u003D
         mul
         std   <u00E5
L2E5E    ldy   ,u
L2E61    lda   ,y
         bmi   L2E6D
L2E65    cmpa  #$20
         bne   L2E79
         leay  $01,y
         bra   L2E61
L2E6D    cmpa  #$F0
         beq   L2E79
         cmpa  #$F1
         beq   L2E79
         lda   $01,y
         bra   L2E65
L2E79    clra
         ldb   <u0097
         subb  <u0096
         subb  <u0095
         decb
         std   <u0067
         lda   <u002D,u
         ldb   <u004C
         lbsr  L2C1E
         ldb   <u001C,u
         subb  <u002A,u
         subb  <u0029,u
         mul
         clr   <u0065
         subd  <u00E5
L2E99    subd  <u0067
         bcs   L2EA1
         inc   <u0065
         bra   L2E99
L2EA1    addd  <u0067
         lda   <u0065
         stb   <u00E4
         beq   L2EAA
         inca
L2EAA    sta   <u00E3
         lbra  L2C7F
L2EAF    lbsr  L2CDA
         tst   <u0030,u
         beq   L2EBB
         tst   <u005A
         bne   L2EC9
L2EBB    ldb   <u00A0
         subb  <u0097
         lbcs  L2C7C
         lbsr  L2F75
         lbra  L2C7F
L2EC9    bsr   L2F1C
         ldy   ,u
         lda   <u002D,u
         ldb   <u004C
         lbsr  L2C1E
         ldb   <u00A0
         mul
         subd  <u00E5
         lbcs  L2C7C
         tst   u0008,u
         beq   L2EEA
         tst   <u0021,u
         beq   L2EF1
         bra   L2EEF
L2EEA    tst   <u0025,u
         beq   L2EF1
L2EEF    asra
         rorb
L2EF1    std   <u00E5
L2EF3    subd  #$00FF
         bcs   L2F0B
         std   <u00E5
         lda   #$FF
         sta   <u00DE
         lda   #$20
         sta   <u00DD
         clr   <u00DF
         lbsr  L145B
         ldd   <u00E5
         bra   L2EF3
L2F0B    addd  #$00FF
         stb   <u00DE
         lda   #$20
         sta   <u00DD
         clr   <u00DF
         lbsr  L145B
         lbra  L2C7F
L2F1C    clr   <u00E5
         clr   <u00E6
         ldy   <u0036
         ldx   ,u
L2F25    cmpx  <u0070
         bcc   L2F41
         cmpx  u0002,u
         bcc   L2F41
         ldb   ,x+
         bmi   L2F42
         cmpb  <u0031,u
         beq   L2F52
L2F36    lslb
         clra
         ldb   d,y
         clra
         addd  <u00E5
         std   <u00E5
         bra   L2F25
L2F41    rts
L2F42    cmpb  #$F0
         beq   L2F41
         cmpb  #$F1
         bne   L2F25
         cmpx  u0002,u
         bne   L2F25
         ldb   #$2D
         bra   L2F36
L2F52    lda   ,x+
         bmi   L2F42
         cmpa  <u0031,u
         beq   L2F25
         cmpx  u0002,u
         bcs   L2F52
         rts
L2F60    tst   u0008,u
         beq   L2F68
         clrb
         stb   <u0066
         rts
L2F68    ldb   <u0029,u
         addb  <u002A,u
         stb   <u0066
         bsr   L2F75
         ldb   <u0066
         rts
L2F75    stb   <u00E9
         beq   L2F82
L2F79    lda   #$A0
         lbsr  L1744
         dec   <u00E9
         bne   L2F79
L2F82    rts
L2F83    ldd   u000F,u
         addd  #$0001
         lbsr  L2672
         ldb   #$1B
         lda   #$2D
L2F8F    lbsr  OUTREPT
         decb
         bne   L2F8F
         lda   #$20
         lbsr  OUTREPT
         ldx   >PGBS1,pcr
         lbsr  L310F  Write string in X
         ldx   <u0034
         leax  $02,x
         lbsr  L312A
         lda   #$20
         lbsr  OUTREPT
         lda   #$2D
L2FAF    lbsr  OUTREPT
         ldb   <u003F
         cmpb  <u0046
         bcs   L2FAF
         lbsr  OUTREPT
         lbra  L2CAB
L2FBE    pshs  y
         lbsr  L0120
         lbsr  L30F5
         lbsr  L2CDA
         lbsr  L10EB
         clrb
         lda   <u0077
         lbsr  GOROWCOL
         ldx   ,u
         clr   <u00A5
L2FD6    cmpx  u0006,u
         beq   L2FE8
         inc   <u00A5
         lda   ,x+
         bpl   L2FD6
         cmpa  #$F1
         beq   L2FD6
         leax  $01,x
         bra   L2FD6
L2FE8    ldy   ,u
         clr   <u0065
         ldb   <u0046
         decb
         tst   <u001D,u
         bne   L3007
         subb  <u0029,u
         bpl   L3000
         cmpb  #$C8
         bcs   L3000
         inc   <u0065
L3000    subb  <u002A,u
         bcc   L3007
         inc   <u0065
L3007    subb  <u00A5
         bcc   L3030
         clra
L300C    adda  #$19
         addb  #$19
         bcc   L300C
         inca
         tst   <u001D,u
         bne   L3026
         suba  <u0029,u
         bpl   L3021
         cmpa  #$C8
         bhi   L3045
L3021    suba  <u002A,u
         bcs   L3045
L3026    deca
         beq   L3045
         tst   ,y+
         bpl   L3026
         inca
         bra   L3026
L3030    tst   <u001D,u
         bne   L3045
         ldb   <u002A,u
         addb  <u0029,u
         beq   L3045
         lda   #$20
L303F    lbsr  OUTREPT
         decb
         bne   L303F
L3045    cmpy  u0006,u
         bcc   L3060
         lda   ,y
         bpl   L3059
         cmpa  #$F1
         beq   L305C
         lbsr  L1AD8
         leay  $02,y
         bra   L3045
L3059    lbsr  L1AD8
L305C    leay  $01,y
         bra   L3045
L3060    ldb   <u003F
         stb   <u0066
         ldb   <u00A0
         addb  <u0096
         subb  <u0097
         bls   L3082
L306C    lda   <u003F
         cmpa  <u0046
         bcc   L30DD
         lda   >L04F4,pcr
         pshs  b
         ldb   #$02
         lbsr  L1033
         puls  b
         decb
         bne   L306C
L3082    ldb   <u0046
         cmpb  <u003F
         bls   L30DD
         cmpy  u0002,u
         bcc   L30B0
         lda   ,y
         bpl   L30A0
         cmpa  #$F1
         beq   L30A7
         cmpa  #$F0
         beq   L30B0
         lbsr  L1AD8
         leay  $02,y
         bra   L3082
L30A0    lbsr  L1AD8
L30A3    leay  $01,y
         bra   L3082
L30A7    leax  $01,y
         cmpx  u0002,u
         bne   L30A3
         lbsr  L1AD8
L30B0    ldb   <u0046
         lda   #$20
L30B4    cmpb  <u003F
         bls   L30BD
         lbsr  OUTREPT
         bra   L30B4
L30BD    ldy   u0002,u
         ldb   -$01,y
         cmpb  #$F0
         bne   L30CA
         lda   >L04F5,pcr
L30CA    lbsr  OUTREPT
L30CD    lda   <u003E
         ldb   <u0066
         lbsr  GOROWCOL
         lbsr  L10F3
         lbsr  L0121
         puls  pc,y
         rts
L30DD    cmpy  u0002,u
         bcc   L30BD
         lda   ,y
         cmpa  #$F1
         bne   L30F0
         leax  $01,y
         cmpx  u0002,u
         beq   L30F0
         leay  $01,y
L30F0    lbsr  L1AD8
         bra   L30CD
L30F5    tst   u0008,u
         beq   L30FE
L30F9    ldb   <u0020,u
         bra   L310C
L30FE    tst   <u001D,u
         bne   L30F9
         ldb   <u001C,u
         subb  <u002A,u
         subb  <u0029,u
L310C    stb   <u00A0
         rts

L310F    pshs  b,a
         lbsr  L0120
         tfr   x,d
         leax  >0,pcr
         leax  d,x
         bra   L3121
L311E    lbsr  OUTREPT
L3121    lda   ,x+
         bne   L311E
         lbsr  L0121
         puls  pc,b,a
L312A    pshs  b,a
         lbsr  L0120
         bra   L3121
L3131    lbsr  L0169
         lbra  L0155   Read keyboard
L3137    lbsr  L10FB
         clr   <u00EB
         lda   #$FF
         sta   <u006D
L3140    lbsr  L10F3
         clr   <u005A
         pshs  x,a
         lda   <u00F8
         beq   L3156
         clr   <u00F8
         ldx   >L0541,pcr
         lbsr  WRLINE3
         bra   L3163
L3156    lda   <u00F7
         beq   L3163
         clr   <u00F7
         ldx   >DSTM6,pcr
         lbsr  WRLINE3
L3163    puls  x,a
         ldu   <u0022
         tst   <u00EB
         bne   L3176
         ldx   >L0595,pcr
         ldb   #$0C
         lbsr  L4B2E
         bra   L3179
L3176    lbsr  L4BAF
L3179    tsta
         lbeq  L3207
         pshs  a
         lbsr  L3E8A
         puls  a
         lsla
         leax  >L3192,pcr
         ldd   a,x
         leax  >0,pcr
         jmp   d,x

L3192    fdb L3207 EDIT
         fdb L3668 PRINT
         fdb L3481 Save/return
 fdb L34E1 Save
 fdb $35F1 SAVE TO MARK
 fdb L3282 Return
 fdb $3305 Load
 fdb L3216 Erase
 fdb L32B7 PASS
 fdb $3631 SPOOL
 fdb $49B6 WHEEL
 fdb $4BC8 NEW
 fdb $0000,$0000

L31AE    ldx   <u001C
         leay  <$37,x
         sty   <u0061
L31B6    lbsr  L0155   Read keyboard
         cmpa  >ESCC,pcr
         beq   L3207
         cmpa  >LNDELC,pcr
         beq   L31E3
         cmpa  >BSC,pcr
         beq   L31EB
         cmpa  #$0D
         beq   L31D7
         cmpa  #$1F
         bls   L31B6
         cmpx  <u0061
         beq   L31B6
L31D7    sta   ,x+
         cmpa  #$0D
         beq   L31E2
         lbsr  OUTREPT
         bra   L31B6
L31E2    rts
L31E3    cmpx  <u001C
         beq   L31B6
         bsr   L31F3
         bra   L31E3
L31EB    cmpx  <u001C
         beq   L31B6
         bsr   L31F3
         bra   L31B6
L31F3    leax  -$01,x
         ldd   <u003E
         decb
         lbsr  GOROWCOL
         lda   #$20
         lbsr  OUTREPT
         ldd   <u003E
         decb
         lbsr  GOROWCOL
         rts

L3207    ldu   <u0022
         clr   <u005A
         tst   u0008,u
         lbeq  L23E7
         lbsr  L1D2C
         bra   L3207

* Erase text
L3216    clr   <u00F8
         clr   <u00F7
         tst   <u005D
         bne   L3222
         tst   <u005E
         beq   L322C
L3222    ldx   >OSPS2,pcr 'Command not allowed with files open.'
         lbsr  WRLINE0 Write at 0,0
         lbra  L3140

L322C    ldx   >ERMM1,pcr
         lbsr  WRLINE1
         lbsr  L3131
         lbsr  OUTREPT
         lbsr  L16B4
         cmpa  >YCHR,pcr
         lbne  L3140
         ldx   >EXTM2,pcr 'Are you sure? '
         lbsr  WRLINE2
         lbsr  L3131
         lbsr  OUTREPT
         lbsr  L16B4
         cmpa  >YCHR,pcr
         lbne  L3140
         ldx   #$0000
         lbsr  L24D0
         lbsr  L25AC
         ldx   <u007F
         ldy   <u0022
         ldd   #$0038
         lbsr  L3EDA
         ldu   <u0022
         ldx   <u0070
         leax  -$01,x
         stx   u0006,u
         stx   u0004,u
         lbsr  L1D2C
         clr   <u006E
         lbra  L3140

L3282    tst   <u005E
         bne   L3222
         ldx   >EXTM1,pcr 'Is the text secure? '
         bsr   WRLINE1
         lbsr  L3131
         lbsr  WrA2BUF
         lbsr  L16B4
         cmpa  >YCHR,pcr
         lbne  L3140
         ldx   >EXTM2,pcr 'Are you sure? '
         bsr   WRLINE2
         lbsr  L3131
         lbsr  WrA2BUF
         lbsr  L16B4
         cmpa  >YCHR,pcr
         lbne  L3140
         lbra  L173B

* Pass command
L32B7    lda   #$01
         bne   L32C7
         tst   <u005D
         lbne  L3222
         tst   <u005E
         lbne  L3222
L32C7    ldx   >OSPS1,pcr "DOS command:  "
         bsr   WRLINE0 Write at 0,0
         lbsr  L31AE
         ldx   <u001C
         lda   #$0D
L32D4    cmpa  ,x+
         bne   L32D4
         clr   -$01,x
         lbsr  L10FB
         ldx   <u001C
         lbsr  L03D3
         bcc   L32E7
         lbsr  L02C5
L32E7    lbsr  L3131
         lbra  L3137

WRLINE0  ldd   #$0000
         bra   L32FF

WRLINE1  ldd   #$0100
         bra   L32FF

WRLINE2  ldd   #$0200
         bra   L32FF

WRLINE3  ldd   #$0300
L32FF    lbsr  GOROWCOL
         lbra  L310F  Write string in X

         ldx   >L053D,pcr
         bsr   WRLINE0 Write at 0,0
         lbsr  L31AE
         leax  -$01,x
         cmpx  <u001C
         lbeq  L3140
         lda   #$01
         sta   <u007C
         ldx   <u001C
         lbsr  L3402
         tst   <u006E
         bne   L3358
         ldy   <u001C
         bsr   L333A
         lda   #$01
         sta   <u006E
         ldd   #$0037
         ldx   <u0030
         ldy   <u0032
         lbsr  L3EDA
         lbra  L4EBC
L333A    pshs  y,x,b,a
         ldb   #$37
         ldx   <u0030
L3340    lda   ,y+
         cmpa  #$0D
         beq   L3353
         cmpa  #$20
         beq   L3353
         cmpa  #$2C
         beq   L3353
         sta   ,x+
         decb
         bne   L3340
L3353    clra
         sta   ,x
         puls  pc,y,x,b,a
L3358    lbsr  L0276
         bcs   L33D7
         ldy   <u007A
         ldx   <u0022
         ldd   $06,x
         std   <u0067
         ldx   ,x
         bra   L336E
L336A    lda   ,x+
         sta   ,y+
L336E    cmpx  <u0067
         bne   L336A
         ldx   <u0067
         leax  >-$00C8,x
         stx   <u0061
L337A    lbsr  L02E8
         bcs   L339E
         cmpa  #$20
         bcc   L3389
         cmpa  #$0D
         bne   L337A
         lda   #$F0
L3389    sta   ,y+
         cmpy  <u0061
         bne   L337A
         lda   #$07
         lbsr  WrA2BUF
         ldx   >L0541,pcr
         lbsr  WRLINE3
         bra   L33A0
L339E    bvc   L33ED
L33A0    lbsr  L0287
         ldu   <u0022
         ldx   u0006,u
         leax  $01,x
         cmpx  <u0070
         bne   L33B5
         lda   -$01,y
         cmpa  #$F0
         bne   L33B5
         leax  $01,x
L33B5    leax  -$01,x
         bra   L33BD
L33B9    lda   ,-y
         sta   ,-x
L33BD    cmpy  <u007A
         bne   L33B9
         ldu   <u0022
         stx   ,u
         stx   u0006,u
         lbsr  L220A
         lbsr  L237E
         lda   #$FF
         sta   <u006D
         clr   <u0075
         lbra  L3140
L33D7    ldd   #$0100
         lbsr  GOROWCOL
         lbsr  L02C5
         lbsr  L0287
         ldx   >DSTM3,pcr
         lbsr  WRLINE3
         lbra  L3140
L33ED    ldd   #$0100
         lbsr  GOROWCOL
         lbsr  L02C5
         lbsr  L0287
         ldx   >L0543,pcr
         lbsr  WRLINE3
         bra   L33A0
L3402    pshs  x,a
L3404    lda   ,x+
         cmpa  #$0D
         beq   L3412
         cmpa  #$20
         beq   L3412
         cmpa  #$2C
         bne   L3404
L3412    stx   <u0073
         clr   -$01,x
         puls  pc,x,a
L3418    ldx   <u0030
         lbsr  L0185
         bvs   L3477
         bcc   L3425
         clr   <u006E
         bra   L3443
L3425    ldx   <u0032
         lbsr  L0185
         bvs   L3477
         bcs   L3434
         lda   #$02
         sta   <u006E
         bra   L3443
L3434    lda   #$01
         sta   <u006E
         ldd   #$0037
         ldx   <u0030
         ldy   <u0032
         lbsr  L3EDA
L3443    lbsr  L01D8
         bcc   L3449
         rts
L3449    pshs  x
         leax  $01,x
         lbsr  L4364
         puls  x
         bcs   L3477
         lda   ,x
         lbsr  L16B4
         cmpa  >CTMCHR,pcr
         beq   L346F
         cmpa  >CPTCHR,pcr  Printer option
         beq   L3473
         cmpa  >CPGCHR,pcr  'M'
         bne   L3477
         stb   <u006F
         bra   L3443

* Set terminal type from command line
L346F    stb   <u0041
         bra   L3443

* Set printer type from command line
L3473    stb   <u0048
         bra   L3443

L3477    ldx   >DSTM5,pcr 'ILLEGAL PRINTER, TERMINAL, OR FILE NAME'
         lbsr  L310F  Write string in X
         lbra  L0421

* Save/return
L3481    lda   #$01
         sta   <u00D2
         clr   <u00D0
         tst   <u005E
         beq   L34F1
         leax  >L02D0,pcr
         stx   <u0063
         lbra  L359D

L3494    tst   <u005D
         beq   L34BD
         ldx   <u007F
L349A    lbsr  L02DF
         bcs   L34B7
         sta   ,x+
         cmpx  <u006B
         bcs   L349A
L34A5    stx   <u0061
         ldx   <u007F
         ldu   <u0063
L34AB    lda   ,x+
         jsr   ,u
         bcs   L34C1
         cmpx  <u0061
         bcs   L34AB
         bra   L3494
L34B7    bvc   L34C1
         clr   <u005D
         bra   L34A5
L34BD    clr   <u0065
         bra   L34C5
L34C1    lda   #$01
         sta   <u0065
L34C5    lbsr  L10FB
         lbsr  L1146
         tst   <u0065
         beq   L34D2
         lbsr  L02C5
L34D2    lbsr  L0281
         lbsr  L0287
         lbsr  L028D
         lbsr  L0293
         lbra  L0421

* Save
L34E1    clr   <u00D2
         clr   <u00D0
         tst   <u005D
         lbne  L3222
         tst   <u005E
         lbne  L3222
L34F1    leax  >L02D9,pcr
         stx   <u0063
         tst   <u006E
         beq   L3532
L34FB    ldx   >SAVM1,pcr 'Save under file name "'
         lbsr  WRLINE0 Write at 0,0
         ldx   <u0032
         lbsr  L312A
         ldx   >SAVMB,pcr
         lbsr  L310F  Write string in X
         lbsr  L3131
         lbsr  L16B4
         cmpa  >NCHR,pcr
         beq   L352F
         cmpa  >YCHR,pcr
         beq   L3524
         cmpa  #$0D
         bne   L34FB
L3524    lda   >YCHR,pcr
         lbsr  OUTREPT
         ldx   <u0032
         bra   L354B
L352F    lbsr  OUTREPT
L3532    ldx   >L053D,pcr
         lbsr  WRLINE1
         lbsr  L31AE
         leax  -$01,x
         cmpx  <u001C
         lbeq  L3140
         ldx   <u001C
         lbsr  L3402
         ldx   <u001C
L354B    stx   <u0061
         lbsr  L021F
         bcc   L359D
         bvc   L3587
         lbsr  L0293
L3557    ldx   <u0061
         lbsr  L02F7
         bcc   L354B
         bvc   L3587
         ldx   >L053B,pcr
         lbsr  WRLINE2
         lbsr  L3131
         lbsr  L16B4
         cmpa  >YCHR,pcr
         beq   L3577
         cmpa  #$0D
         bne   L3590
L3577    lda   >YCHR,pcr
         lbsr  WrA2BUF
         ldx   <u0061
         lbsr  L02A5
         bcs   L3587
         bra   L3557
L3587    ldd   #$0100
         lbsr  GOROWCOL
         lbsr  L02C5
L3590    ldx   >SAVM2,pcr 'NO TEXT SAVED'
         lbsr  WRLINE3
         lbsr  L0293
         lbra  L3140
L359D    ldy   <u0069
         tst   <u00D0
         bne   L35FD
L35A4    cmpy  <u007A
         beq   L35CA
         lda   ,y+
         cmpa  #$F0
         bne   L35B1
         lda   #$0D
L35B1    ldx   <u0063
         jsr   ,x
         bcc   L35A4
L35B7    ldd   #$0100
         lbsr  GOROWCOL
         lbsr  L02C5
         ldx   >SAVM3,pcr 'PART OR ALL OF TEXT NOT SAVED'
         lbsr  WRLINE3
         lbra  L3140
L35CA    ldy   <u0022
         ldy   ,y
L35D0    cmpy  <u0070
         beq   L35E5
         lda   ,y+
         cmpa  #$F0
         bne   L35DD
         lda   #$0D
L35DD    ldx   <u0063
         jsr   ,x
         bcc   L35D0
         bra   L35B7
L35E5    tst   <u00D2
         lbne  L3494
L35EB    lbsr  L0293
         lbra  L3140
         lbsr  L3E9E
         bcs   L3616
         inc   <u00D0
         clr   <u00D2
         lbra  L3532
L35FD    ldu   <u0022
         ldy   u0006,u
L3602    cmpy  <u00CB
         beq   L35EB
         lda   ,y+
         cmpa  #$F0
         bne   L360F
         lda   #$0D
L360F    lbsr  L02D9
         bcc   L3602
         bra   L35B7
L3616    lda   #$07
         lbsr  WrA2BUF
         ldx   >L053F,pcr
         lbsr  WRLINE0 Write at 0,0
         lbra  L3140
L3625    ldd   #$0200
         lbsr  GOROWCOL
         lbsr  L02C5
         lbra  L3140
         lda   #$01
         sta   <u00F2
         clr   <u00AE
         leax  >L365C,pcr
         stx   <u0057
         ldx   >L0571,pcr
         lbsr  WRLINE0 Write at 0,0
         lbsr  L31AE
         ldx   <u001C
         lbsr  L3402
         lbsr  L021F
         lbcs  L3587
         lbsr  L3725
         lbsr  L0293
         lbra  L3718
L365C    lbsr  L02D9
         bcs   L3662
         rts
L3662    lds   <u001E
         lbra  L3625

* Start printing
L3668    clr   <u00F2
         leax  >L0124,pcr
         stx   <u0057
         ldx   >PRNS1,pcr  Ptr to "Different printer"
         lbsr  WRLINE0 Write at 0,0
L3677    lbsr  L3131
         cmpa  >ESCC,pcr
         lbeq  L3140
         cmpa  #$0D
         beq   L36B2
         lbsr  L16B4
         beq   L36B2
         cmpa  >NCHR,pcr
         beq   L36B2
         cmpa  >YCHR,pcr
         beq   L369E
         lda   #$07
         lbsr  WrA2BUF
         bra   L3677
L369E    lbsr  OUTREPT
         ldx   >L0565,pcr
         lbsr  L310F  Write string in X
         lbsr  L31AE
         ldx   <u001C
         lbsr  L3402
         bra   L36C3
L36B2    lda   >NCHR,pcr
         lbsr  OUTREPT
         ldd   >STYP1,pcr '/p'
         leax  >0,pcr
         leax  d,x
L36C3    lbsr  L0133 Create file
         bcc   L36D6
         lbvc  L3625
         ldx   >PRNS2,pcr 'PRINT DRIVER NOT FOUND'
         lbsr  WRLINE2
         lbra  L3140
L36D6    lbsr  L129B
         ldx   >PRNS4,pcr 'Stop for new pages (Y/N*)? '
         lbsr  WRLINE1
         clr   <u00AE
L36E2    lbsr  L3131
         cmpa  >ESCC,pcr
         beq   L3715
         lbsr  L16B4
         cmpa  >NCHR,pcr
         beq   L370C
         cmpa  #$0D
         beq   L370C
         cmpa  >YCHR,pcr
         beq   L3705
         lda   #$07
         lbsr  WrA2BUF
         bra   L36E2
L3705    lbsr  OUTREPT
         inc   <u00AE
         bra   L3713
L370C    lda   >NCHR,pcr
         lbsr  OUTREPT
L3713    bsr   L3725
L3715    lbsr  L014C
L3718    clr   <u005A
         lda   #$01
         sta   <u0077
         sta   <u007C
         ldu   <u0022
         lbra  L3140
L3725    lda   #$20
         sta   <u00E0
         clr   <u00E2
         clr   <u00E1
         clr   <u003D
         clr   <u003C
         lda   >STCS,pcr 12 CHARACTERS/INCH
         lbsr  L12C0
         lda   >STVS,pcr VERTICAL SPACING
         lbsr  L1302
         lda   #$01
         sta   <u0059
         sta   <u005A
         clr   <u0081
L3747    lda   #$03
         lbsr  L1185
         ldx   >L056B,pcr
         lbsr  WRLINE2
L3753    lbsr  L3131
         cmpa  >ESCC,pcr
         lbeq  L384B
         lbsr  L16B4
         cmpa  >NCHR,pcr
         beq   L3785
         cmpa  #$0D
         beq   L3778
         cmpa  >YCHR,pcr
         beq   L3778
         lda   #$07
         lbsr  WrA2BUF
         bra   L3753
L3778    lda   >YCHR,pcr
         lbsr  OUTREPT
         clr   <u00C8
         ldb   #$FF
         bra   L37B0
L3785    lbsr  OUTREPT
         ldx   >L056D,pcr
         lbsr  L310F  Write string in X
         lbsr  L31AE
         ldx   <u001C
         lbsr  L4364
         bcs   L3747
         tstb
         beq   L379D
         decb
L379D    stb   <u00C8
         ldx   >L056F,pcr
         lbsr  L310F  Write string in X
         lbsr  L31AE
         ldx   <u001C
         lbsr  L4364
         bcs   L3747
L37B0    stb   <u00C9
         cmpb  <u00C8
         bls   L3747
         ldx   #$0000
         lbsr  L24D0
         lbsr  L25AC
         ldx   >OTXS1,pcr
         lbsr  WRLINE3
         ldx   <u0022
         ldy   <u0024
         ldd   #$0038
         lbsr  L3EDA
         ldu   <u0024
L37D3    lda   <u0010,u
         cmpa  <u00C9
         beq   L3813
         cmpa  <u00C8
         bcs   L380E
         lbsr  L385F
         lbcs  L384B
         tst   <u00F2
         bne   L380E
         lbsr  L0172
         beq   L380E
         lbsr  L0155   Read keyboard
         cmpa  #$20
         beq   L37FB
         cmpa  >ESCC,pcr
         bne   L380E
L37FB    lbsr  L3131
         cmpa  >ESCC,pcr
         beq   L380E
         cmpa  #$20
         beq   L380E
         cmpa  #$0D
         beq   L384B
         bra   L37FB
L380E    lbsr  L1D2C
         bcc   L37D3
L3813    lda   <u001B,u
         cmpa  <u002B,u
         bcc   L383B
         deca
         sta   <u002C,u
         clr   u0002,u
         clr   u0004,u
L3823    lbsr  L1D2C
         lda   <u002C,u
         beq   L383B
         lda   <u0010,u
         cmpa  <u00C9
         beq   L383B
         lbsr  L385F
         lbcs  L384B
         bra   L3823
L383B    ldb   <u002B,u
         subb  <u0059
         incb
L3841    pshs  b
         lbsr  L12A1
         puls  b
         decb
         bne   L3841
L384B    lda   >STCS,pcr 12 CHARACTERS/INCH
         lbsr  L12C0
         lda   >STVS,pcr VERTICAL SPACING
         lbsr  L1302
         ldu   <u0022
         lbsr  L1D2C
         rts
L385F    lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L3871
         tst   <u001D,u
         bne   L3871
         tst   <u002C,u
         bne   L3874
L3871    andcc #^Carry
         rts

L3874    lda   <u002D,u
         lbsr  L12C0
         lda   <u002E,u
         lbsr  L1302
         clr   <u00E3
         clr   <u00E4
L3884    lda   <u002C,u
         cmpa  <u0059
         beq   L38B6
         lbsr  L12A1
         lda   <u0059
         inca
         sta   <u0059
         cmpa  <u002B,u
         bls   L3884
         lda   #$01
         sta   <u0059
         tst   <u00AE
         beq   L3884
L38A0    lbsr  L3131
         cmpa  >ESCC,pcr
         beq   L3884
         cmpa  #$20
         beq   L3884
         cmpa  #$0D
         beq   L38B3
         bra   L38A0
L38B3    orcc  #Carry
         rts
L38B6    ldd   u0002,u
         subd  ,u
         cmpd  #$0001
         bne   L38C3
         andcc #^Carry
         rts
L38C3    ldd   <u0011,u
         bitb  #$01
         beq   L38CF
         ldb   <u0018,u
         bra   L38D2
L38CF    ldb   <u0017,u
L38D2    decb
         bmi   L38E8
         lda   #$20
         sta   <u00DD
         clr   <u00DF
         lda   <u003D
         sta   <u00DE
         pshs  b
         lbsr  L1443
         puls  b
         bra   L38D2
L38E8    lbsr  L2C2B
         andcc #^Carry
         rts

L38EE    ldb   [<u0006,u]
         bmi   L3904
         clr   <u00CA
         bsr   L3924
         tfr   b,a
         lbsr  L2ABC
         ldx   u0006,u
         leax  -$01,x
         stx   u0006,u
         bra   L3913
L3904    cmpb  #$F0
         beq   L3921
         cmpb  #$F1
         beq   L3921
         stb   <u00CA
         bsr   L3924
         stb   [<u0006,u]
L3913    ldy   u0006,u
         clr   <u00D5
         lbsr  L1AD8
         ldd   <u003E
         decb
         lbsr  GOROWCOL
L3921    lbra  L4548

L3924    pshs  a
         tst   <u00CA
         beq   L392C
         dec   <u00CA
L392C    cmpa  >ULMCHR,pcr Underline char?
         beq   L3953 ..yes
         cmpa  >OLMCHR,pcr
         beq   L3957
         cmpa  >BFMCHR,pcr
         beq   L395B
         cmpa  >L04DC,pcr
         beq   L395F
         cmpa  >L04DD,pcr
         beq   L3967
         tst   <u00CA
         beq   L3950
         inc   <u00CA
L3950    clrb
         puls  pc,a
* Underline
L3953    ldb   #$01
         bra   L396F
* Overline
L3957    ldb   #$04
         bra   L396F
* Bold
L395B    ldb   #$02
         bra   L396F
* Superscript
L395F    ldb   <u00CA
         andb  #$0F   Remove existing sub-/superscript attribute
         orb   #$40
         bra   L3979
* Subscript
L3967    ldb   <u00CA
         andb  #$0F
         orb   #$60
         bra   L3979

L396F    lda   <u00CA
         anda  #$70
         bne   L3977
         orb   #$30
L3977    orb   <u00CA
L3979    orb   #$80
         incb
         stb   <u00CA
         puls  pc,a

         lda   [<u0006,u]
         lbpl  L4548
         cmpa  #$F0
         lbeq  L4548
         cmpa  #$F1
         lbeq  L4548
         ldx   u0006,u
         leay  $01,x
         ldd   u0006,u
         sty   u0006,u
         subd  ,u
         lbsr  L3EC7
         sty   ,u
         lbra  L3913
         tst   <u0072
         beq   L39B3
         lda   #$16
         lbsr  L2AF4
         lbra  L2438
L39B3    lbsr  L3E9E
         lbcs  L2438
         ldd   <u00CB
         subd  u0006,u
         std   <u00CD
         ldd   ,u
         subd  <u007A
         subd  #$0002
         subd  <u00CD
         bcc   L39D3
         lda   #$17
         lbsr  L2AF4
         lbra  L2438
L39D3    ldd   <u00CD
         ldy   <u007A
         ldx   u0006,u
         lbsr  L3EDA
         ldd   <u0070
         subd  <u00CB
         subd  #$0002
         ldx   <u00CB
         leax  $02,x
         ldy   u0006,u
         leay  $02,y
         lbsr  L3EDA
         sty   <u0070
         lda   #$01
         sta   <u0072
         ldd   <u00CD
         ldx   <u007A
         ldy   <u0070
         lbsr  L3EDA
         ldd   u0006,u
         subd  ,u
         ldx   u0006,u
         leay  $02,x
         sty   u0006,u
         lbsr  L3EC7
         sty   ,u
L3A12    lbsr  L220A
         lbsr  L237E
         lda   <u0077
         inca
         sta   <u0075
         sta   <u006D
         lbra  L241D
         tst   <u0072
         bne   L3A2E
         lda   #$18
         lbsr  L2AF4
         lbra  L2438
L3A2E    ldd   ,u
         subd  <u007A
         subd  <u00CD
         bcc   L3A3E
         lda   #$17
         lbsr  L2AF4
         lbra  L2438
L3A3E    ldx   <u0070
         ldy   <u007A
         ldd   <u00CD
         lbsr  L3EDA
         ldd   <u0070
         subd  u0006,u
         ldx   <u0070
         ldy   <u006B
         sty   <u0070
         lbsr  L3EC7
         clr   <u0072
         ldd   <u00CD
         ldx   <u007A
         ldy   u0006,u
         lbsr  L3EDA
         bra   L3A12
         tst   <u0072
         bne   L3A71
         lda   #$18
         lbsr  L2AF4
         lbra  L2438
L3A71    ldd   ,u
         subd  <u007A
         cmpd  #$00C8
         bcs   L3A85
         subd  <u00CD
         bcs   L3A85
         cmpd  #$00C8
         bhi   L3A8D
L3A85    lda   #$17
         lbsr  L2AF4
         lbra  L2438
L3A8D    ldd   ,u
         subd  <u00CD
         ldx   ,u
         std   ,u
         ldy   ,u
         stx   <u0067
         ldd   u0006,u
         subd  <u0067
         lbsr  L3EDA
         sty   u0006,u
         ldx   <u0070
         ldy   u0006,u
         ldd   <u00CD
         lbsr  L3EDA
         lbra  L3A12
         lbsr  L3E9E
         lbcs  L2438
         lda   <u0077
         lbsr  L1185
         lda   <u0077
         clrb
         lbsr  GOROWCOL
         ldd   <u00CB
         subd  u0006,u
         lbsr  L2672
         ldx   >L0591,pcr
         lbsr  L310F  Write string in X
         ldx   <u0034
         lbsr  L312A
         ldx   >L0593,pcr
         lbsr  L310F  Write string in X
         lbsr  L1698
         lbsr  OUTREPT
         anda  #$5F
         cmpa  >YCHR,pcr
         lbne  L241D
         ldy   <u00CB
         leay  $02,y
         ldx   u0006,u
         ldd   u0006,u
         subd  ,u
         sty   u0006,u
         lbsr  L3EC7
         sty   ,u
         lbra  L3A12

L3B04    lda   >MRKCHR,pcr
         lbsr  L2ABC
         lbsr  L237E
         lbra  L241D

L3B11    clr   <u00F1
         clr   <u00D3
         lda   #$01
         sta   <u007C
         lda   #$04
         sta   <u0077
         clr   <u00D7
         lbsr  L2C2B
         lda   <u0077
         inca
         sta   <u0075
         sta   <u006D
L3B29    lbsr  L3E8A
         ldd   #$0000
         lbsr  GOROWCOL
         ldx   >L0585,pcr
         lbsr  L310F  Write string in X
L3B39    ldx   <u001C
         stx   <u00C0
         lbsr  L3D1D
         bcs   L3B29
         ldx   <u001C
         pshs  x
         ldd   <u00C0
         subd  ,s++
         cmpd  #$0001
         beq   L3B39
L3B50    lbsr  L3DC4
         bcs   L3B87
         lda   <u0077
         inca
         sta   <u0075
         sta   <u006D
         ldd   #$0200
         lbsr  GOROWCOL
         ldx   >L0587,pcr
         lbsr  L310F  Write string in X
         lda   #$01
         sta   <u0081
         lda   <u0077
         clr   <u00D7
         lbsr  L2C2B
L3B74    lbsr  L1698
         cmpa  #$0D
         beq   L3B8C
         cmpa  >ESCC,pcr
         beq   L3B8C
         cmpa  #$20
         bne   L3B74
         bra   L3B50
L3B87    lda   #$20
         lbsr  L2AF4
L3B8C    lda   #$04
         sta   <u0077
         lbsr  L2BBB
         lda   <u0077
         cmpa  #$04
         beq   L3B9E
         inca
         sta   <u006D
         sta   <u0075
L3B9E    lbra  L23E3

L3BA1    clr   <u00F1
         clr   <u00D3
         lda   #$01
         sta   <u007C
         clr   <u00AE
         lda   #$04
         sta   <u0077
         clr   <u00D7
         lbsr  L2C2B
         lda   <u0077
         inca
         sta   <u0075
         sta   <u006D
L3BBB    lbsr  L3E8A
         ldd   #$0000
         lbsr  GOROWCOL
         ldx   >L058B,pcr
         lbsr  L310F  Write string in X
         ldx   <u001C
         stx   <u00C0
L3BCF    lbsr  L3D1D
         bcs   L3BBB
         ldx   <u001C
         pshs  x
         ldd   <u00C0
         subd  ,s++
         cmpd  #$0001
         beq   L3BCF
         ldd   <u00C0
         std   <u00BE
         ldd   #$0100
         lbsr  GOROWCOL
         ldx   >RPLS2,pcr '*** WITH    '
         lbsr  L310F  Write string in X
         lbsr  L3D1D
         bcs   L3BBB
L3BF8    lbsr  L3DC4
         lbcs  L3CFF
         tst   <u00AE
         bne   L3C50
         lda   #$05
         sta   <u0075
         sta   <u006D
         lda   #$02
         lbsr  L1185
         lda   #$03
         lbsr  L1185
         ldd   #$0200
         lbsr  GOROWCOL
         ldx   >L058F,pcr
         lbsr  L310F  Write string in X
         lda   #$01
         sta   <u0081
         lda   #$04
         sta   <u0077
         clr   <u00D7
         lbsr  L2C2B
L3C2D    lbsr  L1698
         cmpa  >ESCC,pcr
         lbeq  L3B8C
         anda  #$5F
         cmpa  >NCHR,pcr
         beq   L3C92
         cmpa  >ACHR,pcr
         beq   L3C4E
         cmpa  >YCHR,pcr
         bne   L3C2D
         bra   L3C50
L3C4E    inc   <u00AE
L3C50    ldd   <u00BE
         addd  #$0001
         addd  <u00C4
         subd  <u00C2
         subd  <u00C0
         bcs   L3CC2
         ldx   u0006,u
         leay  b,x
         ldd   u0006,u
         subd  ,u
         sty   u0006,u
         lbsr  L3EC7
         sty   ,u
L3C6E    ldd   <u00C0
         subd  <u00BE
         subd  #$0001
         ldx   <u00BE
         ldy   u0006,u
         lbsr  L3EDA
         sty   <u00D3
         lbsr  L220A
         lbsr  L237E
         tst   <u00AE
         lbne  L3BF8
         lda   #$05
         sta   <u006D
         sta   <u0075
L3C92    ldd   #$0200
         lbsr  GOROWCOL
         ldx   >L0587,pcr
         lbsr  L310F  Write string in X
         lda   #$01
         sta   <u0081
         lda   #$04
         clr   <u00D7
         lbsr  L2C2B
L3CAA    lbsr  L1698
         cmpa  #$0D
         lbeq  L3B8C
         cmpa  >ESCC,pcr
         lbeq  L3B8C
         cmpa  #$20
         bne   L3CAA
         lbra  L3BF8
L3CC2    stb   <u0066
         addd  ,u
         subd  <u007A
         bcs   L3CF1
         cmpd  #$000A
         bcs   L3CF1
         cmpd  #$00C8
         bhi   L3CDB
         lda   #$19
         lbsr  L2AF4
L3CDB    ldx   ,u
         ldb   <u0066
         leay  b,x
         ldd   u0006,u
         subd  ,u
         sty   ,u
         lbsr  L3EDA
         sty   u0006,u
         lbra  L3C6E
L3CF1    lda   #$1A
         lbsr  L2AF4
         lda   <u0077
         inca
         sta   <u0075
         sta   <u006D
         bra   L3D04
L3CFF    lda   #$20
         lbsr  L2AF4
L3D04    lda   #$04
         sta   <u0077
         lbsr  L2BBB
         lda   #$04
         cmpa  <u0077
         bne   L3D15
         tst   <u00AE
         beq   L3D1A
L3D15    inca
         sta   <u006D
         sta   <u0075
L3D1A    lbra  L23E3
L3D1D    lda   >LBCHR,pcr
         ldb   #$02
         lbsr  L1033
         clrb
         ldx   <u00C0
L3D29    lbsr  L1698
         cmpa  >ESCC,pcr
         lbeq  L3B8C
         cmpa  >LNDELC,pcr
         beq   L3DA4
         cmpa  #$0D
         beq   L3D58
         cmpa  >L04F3,pcr
         beq   L3DA7
         cmpa  >BSC,pcr
         beq   L3D79
         cmpa  >L04F5,pcr
         bne   L3D54
         lda   #$F0
         bra   L3D58
L3D54    cmpa  #$20
         bcs   L3D29
L3D58    sta   b,x
         cmpa  #$0D
         beq   L3D94
         incb
         cmpb  #$32
         bcs   L3D6C
         lda   #$1F
         lbsr  L2AF4
         cmpb  #$32
         bhi   L3DA4
L3D6C    cmpa  #$F0
         bne   L3D74
         lda   >L04F5,pcr
L3D74    lbsr  OUTREPT
         bra   L3D29
L3D79    tstb
         beq   L3DA4
         pshs  b
         ldd   <u003E
         decb
         lbsr  GOROWCOL
         lda   #$20
         lbsr  OUTREPT
         ldd   <u003E
         decb
         lbsr  GOROWCOL
         puls  b
         decb
         bra   L3D29
L3D94    incb
         abx
         stx   <u00C0
         lda   >L050E,pcr
         ldb   #$02
         lbsr  L1033
         andcc #^Carry
         rts
L3DA4    orcc  #Carry
         rts
L3DA7    lda   #$0D
         sta   b,x
         incb
         abx
         stx   <u00C0
         lda   >L050E,pcr
         ldb   #$02
         lbsr  L1033
         ldx   >L0589,pcr
         lbsr  L310F  Write string in X
         inc   <u00F1
         andcc #^Carry
         rts
L3DC4    ldx   u0006,u
         cmpx  <u00D3
         bhi   L3DCE
         ldx   <u00D3
         bra   L3DDC
L3DCE    lda   ,x+
         bpl   L3DDC
         cmpa  #$F0
         beq   L3DDC
         cmpa  #$F1
         beq   L3DDC
         leax  $01,x
L3DDC    stx   <u00C2
         cmpx  <u0070
         bcc   L3E17
L3DE2    ldy   <u001C
         ldx   <u00C2
L3DE7    lda   ,x
         tst   <u00F1
         beq   L3E03
         cmpa  #$41
         bcs   L3E03
         cmpa  #$5A
         bhi   L3DF9
         adda  #$20
         bra   L3E03
L3DF9    cmpa  #$61
         bcs   L3E03
         cmpa  #$7A
         bhi   L3E03
         suba  #$20
L3E03    ldb   ,x+
         bpl   L3E0B
         cmpa  #$F0
         bne   L3E13
L3E0B    cmpa  ,y
         beq   L3E1A
         cmpb  ,y
         beq   L3E1A
L3E13    cmpx  <u0070
         bcs   L3DE7
L3E17    orcc  #Carry
         rts
L3E1A    stx   <u00C2
         leay  $01,y
         bra   L3E52
L3E20    lda   ,y
         cmpa  #$0D
         beq   L3E58
         lda   ,x
         tst   <u00F1
         beq   L3E42
         cmpa  #$41
         bcs   L3E42
         cmpa  #$5A
         bhi   L3E38
         adda  #$20
         bra   L3E42
L3E38    cmpa  #$61
         bcs   L3E42
         cmpa  #$7A
         bhi   L3E42
         suba  #$20
L3E42    ldb   ,x+
         bpl   L3E4A
         cmpa  #$F0
         bne   L3E52
L3E4A    cmpb  ,y+
         beq   L3E52
         cmpa  -$01,y
         bne   L3DE2
L3E52    cmpx  <u0070
         bne   L3E20
         bra   L3DE2
L3E58    cmpx  <u0070
         bcc   L3E17
         stx   <u00C4
         ldx   <u00C2
         leax  -$01,x
         stx   <u00C2
         lda   -$01,x
         bpl   L3E74
         cmpa  #$F0
         beq   L3E74
         cmpa  #$F1
         beq   L3E74
         leax  -$01,x
         stx   <u00C2
L3E74    ldx   <u00C2
         cmpx  u0002,u
         bcs   L3E81
         lbsr  L1D2C
         bcs   L3E86
         bra   L3E74
L3E81    andcc #^Carry
         stx   u0006,u
         rts
L3E86    clr   <u0077
         bra   L3E17

L3E8A    clra
         lbsr  L1185
         lda   #$01
         lbsr  L1185
         lda   #$02
         lbsr  L1185
         lda   #$03
         lbsr  L1185
         rts

L3E9E    ldx   u0006,u
L3EA0    lda   ,x+
         cmpx  <u0070
         beq   L3EBF
         cmpa  >MRKCHR,pcr
         bne   L3EA0
         lda   ,x+
         cmpx  <u0070
         beq   L3EBF
         cmpa  >MRKCHR,pcr
         bne   L3EA0
         leax  -$02,x
         stx   <u00CB
         andcc #^Carry
         rts
L3EBF    lda   #$15
         lbsr  L2AF4
         orcc  #Carry
         rts
L3EC7    inca
         pshs  a
         tstb
         bra   L3ED2
L3ECD    lda   ,-x
         sta   ,-y
         decb
L3ED2    bne   L3ECD
         dec   ,s
         bne   L3ECD
         puls  pc,a
L3EDA    inca
         pshs  a
         tstb
         bra   L3EE5
L3EE0    lda   ,x+
         sta   ,y+
         decb
L3EE5    bne   L3EE0
         dec   ,s
         bne   L3EE0
         puls  pc,a
L3EED    clr   <u0065
         leay  >0,pcr
         ldd   >FMTTBL,pcr
         leay  d,y
L3EF9    ldx   ,u
         leax  $01,x
L3EFD    lda   ,x+
         cmpa  #$20
         beq   L3F24
         cmpa  #$2C
         beq   L3F24
         lbsr  L16B4
         cmpa  ,y+
         bne   L3F24
         tst   ,y
         bne   L3EFD
         lda   ,x
         cmpa  #$20
         beq   L3F4F
         cmpa  #$2C
         beq   L3F4F
         cmpa  #$F0
         beq   L3F4F
         leay  $01,y
         bra   L3F28
L3F24    tst   ,y+
         bne   L3F24
L3F28    inc   <u0065
         tst   ,y
         bne   L3EF9
L3F2E    cmpu  <u0022
         bne   L3F38
         lda   #$0C
         lbra  L2AF4
L3F38    rts
L3F39    cmpu  <u0022
         bne   L3F38
         lda   #$0D
         lbra  L2AF4
         rts
L3F44    cmpu  <u0022
         bne   L3F38
         lda   #$0E
         lbra  L2AF4
         rts

L3F4F    leay  >L3F6D,pcr
         lda   <u0065
         cmpa  #$03
         ble   L3F64
         tst   <u001D,u
         bne   L3F44
         tst   u0008,u
         lbne  L3F2E
L3F64    lsla
         ldd   a,y
         leay  >0,pcr
         jmp   d,y

* Labels here
L3F6D    fdb $3FC3,$4060,$3FEB,L3F38,$402C,$4099,$3FE7
         fdb $4005,$4107,$4119,$41AD,$41E1,$3FE1,$4140
         fdb $4139,$416E,$414B,L3FB1,$4215,$4255,$4295
         fdb $42A4,$42B7,$42BD,$42C3,$42D5,$42E7,$42F8
         fdb $433B,$4349,$4353,$435A,$0000,$0000

L3FB1    lbsr  L4364
         lbcs  L3F2E
L3FB8    cmpb  <u002C,u
         lbls  L3F39
         stb   <u002C,u
         rts
         lbsr  L4364
         lbcs  L3F2E
         cmpb  #$00
         bne   L3FD0
         ldb   #$01
L3FD0    tst   <u001D,u
         bne   L3FD9
         tst   u0008,u
         beq   L3FDD
L3FD9    stb   <u0021,u
         rts
L3FDD    stb   <u0025,u
         rts
         lda   #$01
         sta   <u0026,u
         rts
         clr   <u0026,u
         rts
         lbsr  L4364
         cmpb  #$00
         bne   L3FF4
         ldb   #$01
L3FF4    tst   <u001D,u
         bne   L3FFD
         tst   u0008,u
         beq   L4001
L3FFD    stb   <u0022,u
         rts
L4001    stb   <u0027,u
         rts
         lbsr  L4364
         lbcs  L3F2E
         cmpb  #$78
         lbhi  L3F39
         stb   <u0017,u
         stb   <u0018,u
         lbsr  L4364
         tstb
         beq   L402B
         lbcs  L3F2E
         cmpb  #$78
         lbhi  L3F39
         stb   <u0018,u
L402B    rts
         lbsr  L4364
         lbcs  L3F2E
         cmpd  #$0003
         lbcs  L3F39
         cmpb  #$64
         lbhi  L3F39
         stb   <u002B,u
         tfr   b,a
         suba  <u001E,u
         lbcs  L3F39
         suba  <u001A,u
         lbcs  L3F39
         cmpa  #$02
         lbls  L3F39
         lbsr  L412E
         lbra  L3F38
         lbsr  L4364
         lbcs  L3F2E
L4067    tst   <u001D,u
         bne   L4085
         tst   u0008,u
         bne   L4085
         lda   <u001C,u
         pshs  a
         stb   <u001C,u
         bsr   L40D1
         puls  a
         bcc   L4084
         sta   <u001C,u
         lbra  L3F39
L4084    rts
L4085    lda   <u0020,u
         stb   <u0020,u
         pshs  a
         bsr   L40D1
         puls  a
         bcc   L4084
         sta   <u0020,u
         lbra  L3F39
         lbsr  L4364
         lbcs  L3F2E
         bsr   L4067
         lbsr  L4364
         lbcs  L3F2E
         lbsr  L4152
         lda   #$16
         sta   <u0065
         ldy   <u002E
L40B3    clr   ,y+
         deca
         bne   L40B3
         ldy   <u002E
L40BB    lbsr  L4364
         tstb
         beq   L40CD
         lbcs  L3F2E
         bsr   L40CE
         dec   <u0065
         beq   L40CD
         bra   L40BB
L40CD    rts
L40CE    stb   ,y+
         rts
L40D1    pshs  a
         lda   <u0020,u
         cmpa  #$96
         bhi   L40F9
         lda   <u002A,u
         adda  <u0029,u
         bmi   L40F9
         lda   <u001C,u
         cmpa  #$96
         bhi   L40F9
         suba  <u002A,u
         bcs   L40F9
         suba  <u0029,u
         cmpa  #$0A
         bcs   L40F9
         andcc #^Carry
         puls  pc,a
L40F9    cmpu  <u0022
         bne   L4103
         lda   #$0D
         lbsr  L2AF4
L4103    orcc  #Carry
         puls  pc,a
         lbsr  L4364
         lbcs  L3F2E
         tstb
         bne   L4112
         incb
L4112    addb  <u002C,u
         stb   <u002C,u
         rts
         lbsr  L4364
         lbcs  L3F2E
         tstb
         beq   L412A
         cmpb  #$03
         lbhi  L3F39
         decb
L412A    stb   <u0024,u
         rts
L412E    lda   <u002B,u
         suba  <u001A,u
         inca
         sta   <u001B,u
         rts
L4139    lda   <u001B,u
         sta   <u002C,u
         rts
         lbsr  L4364
         lbcs  L3F2E
         std   <u0011,u
         rts
         lbsr  L4364
         lbcs  L3F2E
L4152    tst   u0008,u
         lbne  L3F44
         tst   <u001D,u
         lbne  L3F44
         lda   <u002A,u
         stb   <u002A,u
         lbsr  L40D1
         bcc   L416D
         sta   <u002A,u
L416D    rts
         clr   <u0065
L4170    leax  $01,x
         lda   ,x
         cmpa  #$20
         beq   L4170
         cmpa  #$2C
         beq   L4170
         cmpa  #$2D
         bne   L4184
         com   <u0065
         leax  $01,x
L4184    lbsr  L4364
         lbcs  L3F2E
         tst   <u0065
         beq   L4191
         comb
         incb
L4191    tst   u0008,u
         lbne  L3F44
         tst   <u001D,u
         lbne  L3F44
         lda   <u0029,u
         stb   <u0029,u
         lbsr  L40D1
         bcc   L416D
         sta   <u0029,u
         rts
         tst   <u001D,u
         lbne  L3F44
         tst   u0008,u
         lbne  L3F44
         lda   #$01
         sta   <u001D,u
         clr   <u001E,u
         cmpu  <u0022
         beq   L41CB
         ldd   u0004,u
         bra   L41DD
L41CB    ldd   <u007A
         ldx   u0004,u
         pshs  u
         ldu   <u0024
         cmpx  <u0015,u
         bne   L41DB
         std   <u0015,u
L41DB    puls  u
L41DD    std   <u0015,u
         rts
         tst   <u001D,u
         lbne  L3F44
         tst   u0008,u
         lbne  L3F44
         lda   #$02
         sta   <u001D,u
         clr   <u001F,u
         cmpu  <u0022
         beq   L41FF
         ldd   u0004,u
         bra   L4211
L41FF    ldd   <u007A
         ldx   u0004,u
         pshs  u
         ldu   <u0024
         cmpx  <u0013,u
         bne   L420F
         std   <u0013,u
L420F    puls  u
L4211    std   <u0013,u
         rts
         lbsr  L4364
         bcc   L4238
         lbsr  L16B4
         ldb   <u0051
         cmpa  >L0503,pcr
         beq   L4251
         ldb   <u0052
         cmpa  >L0504,pcr
         beq   L4251
         ldb   <u0053
         cmpa  >L0505,pcr
         beq   L4251
         lbra  L3F2E
L4238    cmpb  <u0051
         beq   L4251
         cmpb  <u0052
         beq   L4251
         cmpb  <u0053
         beq   L4251
         cmpb  #$0C
         beq   L4251
         cmpb  #$0A
         beq   L4251
         lda   #$1E
         lbsr  L2AF4
L4251    stb   <u002D,u
         rts
         lbsr  L4364
         bcc   L4278
         lbsr  L16B4
         ldb   <u0056
         cmpa  >L0505,pcr
         beq   L4291
         ldb   <u0054
         cmpa  >L0503,pcr
         beq   L4291
         ldb   <u0055
         cmpa  >L0504,pcr
         beq   L4291
         lbra  L3F2E
L4278    cmpb  <u0056
         beq   L4291
         cmpb  <u0054
         beq   L4291
         cmpb  <u0055
         beq   L4291
         cmpb  #$06
         beq   L4291
         cmpb  #$08
         beq   L4291
         lda   #$23
         lbsr  L2AF4
L4291    stb   <u002E,u
         rts
         tst   <u00DB
         bne   L429E
         lda   #$22
         lbra  L2AF4
L429E    lda   #$01
         sta   <u0030,u
         rts
         clr   <u0030,u
         tst   <u005A
         beq   L42B6
         tst   <u00E1
         beq   L42B6
         clr   <u00DD
         clr   <u00DF
         lbsr  L1443
L42B6    rts
         bsr   L42C9
         sta   <u0031,u
         rts
         bsr   L42C9
         sta   <u0033,u
         rts
         bsr   L42C9
         sta   <u0032,u
         rts
L42C9    lda   ,x+
         cmpa  #$20
         beq   L42C9
         cmpa  #$F0
         bne   L42D4
         clra
L42D4    rts
         lbsr  L4364
         lbcs  L3F2E
L42DC    addb  <u002C,u
         cmpb  <u001B,u
         lbcc  L4139
         rts
         ldb   <u0035,u
         lbsr  L4191
         ldb   <u0037,u
         bsr   L42DC
         ldb   <u0036,u
         lbra  L4112
         clr   <u0065
L42FA    leax  $01,x
         lda   ,x
         cmpa  #$20
         beq   L42FA
         cmpa  #$2C
         beq   L42FA
         cmpa  #$2D
         bne   L430E
         com   <u0065
         leax  $01,x
L430E    bsr   L4364
         lbcs  L3F2E
         tst   <u0065
         beq   L431A
         comb
         incb
L431A    tst   u0008,u
         lbne  L3F44
         tst   <u001D,u
         lbne  L3F44
         lda   <u0029,u
         stb   <u0029,u
         lbsr  L40D1
         sta   <u0029,u
         lbcs  L3F39
         stb   <u0035,u
         rts
         bsr   L4364
         lbcs  L3F2E
         tstb
         bne   L4345
         incb
L4345    stb   <u0036,u
         rts
         bsr   L4364
         lbcs  L3F2E
         stb   <u0037,u
L4352    rts
         tst   <u005A
         beq   L4352
         lbra  L1295
         bsr   L4364
         lbcs  L3F2E
         stb   <u002F,u
         rts
L4364    clra
         clrb
         std   <u0067
L4368    lda   ,x+
         cmpa  #$20
         beq   L4368
         cmpa  #$2C
         beq   L4368
         bra   L4376
L4374    lda   ,x+
L4376    cmpa  #$F0
         beq   L43AF
         cmpa  #$0D
         beq   L43AF
         cmpa  #$20
         beq   L43AF
         cmpa  #$2C
         beq   L43AF
         cmpa  #$2D
         beq   L43AF
         cmpa  <u0031,u
         beq   L43AF
         cmpa  #$30
         bcs   L43B4
         cmpa  #$39
         bhi   L43B4
         anda  #$0F
         pshs  a
         ldd   <u0067
         lslb
         rola
         lslb
         rola
         lslb
         rola
         addd  <u0067
         addd  <u0067
         addb  ,s+
         adca  #$00
         std   <u0067
         bra   L4374
L43AF    andcc #^Carry
         ldd   <u0067
         rts
L43B4    orcc  #Carry
         rts
         ldx   u0006,u
         cmpx  ,u
         bls   L43ED
L43BD    lda   ,-x
         bmi   L43BD
         cmpx  ,u
         bcs   L43ED
         cmpa  #$20
         beq   L43D7
L43C9    lda   ,-x
         bmi   L43C9
         cmpx  ,u
         bcs   L43F9
         cmpa  #$20
         bne   L43C9
         bra   L43F9
L43D7    lda   ,-x
         cmpx  ,u
         bcs   L43ED
         cmpa  #$20
         beq   L43D7
L43E1    lda   ,-x
         cmpx  ,u
         bls   L43FB
         cmpa  #$20
         beq   L43F9
         bra   L43E1
L43ED    lda   <u00A3
         adda  <u0046
         sta   <u007E
         lbsr  L4452
         lbra  L2438
L43F9    leax  $01,x
L43FB    stx   u0006,u
         clr   <u0081
         clr   <u00D7
         lda   <u0077
         lbsr  L2C2B
         lda   <u003F
         adda  <u00A3
         sta   <u007E
         lbra  L2438

L440F    ldx   u0006,u
L4411    lda   ,x+
         bpl   L441F
         cmpa  #$F0
         beq   L441F
         cmpa  #$F1
         beq   L441F
         lda   ,x+
L441F    cmpx  u0002,u
         bcc   L4443
         cmpa  #$20
         bne   L4411
L4427    lda   ,x+
         cmpa  #$20
         beq   L4427
         leax  -$01,x
         stx   u0006,u
         clr   <u00D7
         clr   <u0081
         lda   <u0077
         lbsr  L2C2B
         lda   <u003F
         adda  <u00A3
         sta   <u007E
         lbra  L2438
L4443    lda   <u00A3
         sta   <u007E
         lbsr  L44E2
         lbra  L2438

L444D    bsr   L4452
         lbra  L2438

L4452    tst   <u007C
         bne   L445A
         ldx   u000B,u
         bra   L445C
L445A    ldx   u0009,u
L445C    leax  -$01,x
         cmpx  #$FFFF
         beq   L4475
         pshs  x
         lbsr  L24D0
         ldu   <u0022
         puls  x
         ldy   <u0020
         tst   $08,y
         bne   L445C
         bra   L447B
L4475    lda   #$07
         lbsr  L2AF4
         rts
L447B    ldy   <u0020
         ldb   <u003E
         clra
         clr   <u0081
         tst   <u007C
         bne   L448D
         addd  $0B,y
         subd  u000B,u
         bra   L4491
L448D    addd  $09,y
         subd  u0009,u
L4491    bcc   L44BC
         cmpb  #$FF
         bne   L44A5
         inc   <u006D
         lbsr  L111F
         beq   L44AF
         lda   #$01
         sta   <u00A1
         clrb
         bra   L44B8
L44A5    inc   <u006D
         lbsr  L111F
         beq   L44AF
         incb
         bne   L44A5
L44AF    lda   #$01
         sta   <u006D
         sta   <u0075
         clr   <u00A1
         clrb
L44B8    lda   #$01
         sta   <u0081
L44BC    tfr   b,a
         clrb
         lbsr  GOROWCOL
         lbsr  L25AC
         ldu   <u0022
         lbsr  L1B4C
         lda   #$01
         sta   <u00D7
         lda   <u003E
         sta   <u0077
         lbsr  L2C2B
         tst   <u0075
         beq   L44DC
         lbsr  L2B65
L44DC    rts

L44DD    bsr   L44E2
         lbra  L2438
L44E2    lbsr  L1D2C
         bcc   L44ED
         lbsr  L2AF4
         lbra  L2438
L44ED    tst   <u007C
         bne   L44FE
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L44E2
         tst   <u001D,u
         bne   L44E2
L44FE    lda   <u003E
         clr   <u0081
         inca
         cmpa  <LASTROW
         bls   L4512
         lbsr  L1111
         lda   #$01
         sta   <u0081
         sta   <u00A1
         lda   <LASTROW
L4512    clrb
         lbsr  GOROWCOL
         cmpa  <u006D
         bcs   L451C
         sta   <u0081
L451C    tst   u0008,u
         beq   L4531
         tst   <u0081
         beq   L44E2
         clr   <u00D7
         ldb   #$01
         stb   <u0081
         lda   <u003E
         lbsr  L2C2B
         bra   L44E2
L4531    ldb   #$01
         stb   <u00D7
         lda   <u003E
         lbsr  L2C2B
         lda   <u003E
         sta   <u0077
         tst   <u0081
         beq   L4547
         inca
         sta   <u006D
         sta   <u0075
L4547    rts

* Cursor right
L4548    bsr   L454D
         lbra  L2438
L454D    ldx   u0006,u
L454F    lda   ,x
         bpl   L455D
         cmpa  #$F0
         beq   L455D
         cmpa  #$F1
         beq   L455D
         leax  $01,x
L455D    leax  $01,x
         cmpx  u0002,u
         bcs   L456B
         lda   <u00A3
         sta   <u007E
         lbra  L44E2
         rts
L456B    lda   ,x
         cmpa  #$F1
         bne   L4578
         leay  $01,x
         cmpy  u0002,u
         bne   L454F
L4578    stx   u0006,u
         clr   <u00D7
         clr   <u0081
         lda   <u0077
         lbsr  L2C2B
         lda   <u003F
         adda  <u00A3
         sta   <u007E
         rts

L458A    bsr   L458F
         lbra  L2438
L458F    ldx   u0006,u
L4591    cmpx  ,u
         bne   L459F
         lda   <u00A3
         adda  <u0046
         sta   <u007E
         lbsr  L4452
         rts
L459F    tst   ,-x
         bmi   L4591
         cmpx  ,u
         beq   L45B1
         lda   -$01,x
         bpl   L45B1
         cmpa  #$F1
         beq   L45B1
         leax  -$01,x
L45B1    stx   u0006,u
         clr   <u0081
         clr   <u00D7
         lda   <u0077
         lbsr  L2C2B
         lda   <u003F
         adda  <u00A3
         sta   <u007E
         rts
         lda   <u00A3
         sta   <u007E
         lda   #$01
         sta   <u00D7
         clr   <u0081
         lda   <u0077
         lbsr  L2C2B
         lbsr  L1698
         lbsr  L16B4
         cmpa  >CURLRC,pcr
         lbne  L2447
         lda   <u00A3
         adda  <u0046
         sta   <u007E
         lda   <u0077
         lbsr  L2C2B
         lbra  L2438
         tst   <u003E
         bne   L45F5
         lbsr  L44E2
L45F5    lbsr  L1111
         tst   <u00A1
         bne   L4608
         lda   <u006D
         deca
         cmpa  <u003E
         bls   L4608
         sta   <u006D
         lbra  L2438
L4608    lda   <u003E
         inca
         sta   <u006D
         sta   <u0075
         clr   <u00A1
         lbra  L2438
         tst   <u007C
         beq   L461C
         ldd   u0009,u
         bra   L461E
L461C    ldd   u000B,u
L461E    subb  <u003E
         sbca  #$00
         subd  #$0001
         bcc   L462F
         lda   #$07
         lbsr  L2AF4
         lbra  L2438
L462F    pshs  b,a
         lda   <u003E
         cmpa  <LASTROW
         bne   L463A
         lbsr  L4452
L463A    lda   <u006D
         inca
         cmpa  <LASTROW
         bcc   L4643
         sta   <u006D
L4643    lbsr  L111F
         beq   L4661
         lda   #$01
         sta   <u00A1
         puls  x
         lbsr  L24D0
         ldu   <u0020
         lbsr  L1B4C
         lda   #$01
         sta   <u0081
         clra
         lbsr  L2C2B
         lbra  L2438
L4661    lda   <u0077
         inca
         sta   <u0077
         inca
         sta   <u006D
         sta   <u0075
         clr   <u00A1
         lbsr  L2BBB
         lbra  L241D
         tst   <u007C
         beq   L467B
         ldd   u0009,u
         bra   L467D
L467B    ldd   u000B,u
L467D    cmpd  #$0001
         bne   L468B
         lda   #$07
         lbsr  L2AF4
         lbra  L2438
L468B    subb  <u003E
         sbca  #$00
         subb  <LASTROW
         sbca  #$00
         bcc   L4697
         clra
         clrb
L4697    tfr   d,x
         clr   <u00AA
         lbsr  L24D0
L469E    tst   u0008,u
         bne   L46B5
         tst   <u007C
         bne   L46D1
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L46CC
         tst   <u001D,u
         beq   L46D1
         bra   L46CC
L46B5    lda   <u00AA
         cmpa  <LASTROW
         bcs   L46C3
         lbsr  L1111
         lda   <LASTROW
         deca
         sta   <u00AA
L46C3    ldb   #$01
         stb   <u0081
         lbsr  L2C2B
         inc   <u00AA
L46CC    lbsr  L1D2C
         bra   L469E
L46D1    lbsr  L25AC
         ldu   <u0022
         lda   <u00AA
         sta   <u0077
         inca
         sta   <u006D
         sta   <u0075
         clr   <u00A1
         lbra  L241D
         lda   <u003E
         sta   <u00A6
         bra   L46F7
L46EA    lda   <u00A6
         cmpa  <LASTROW
         beq   L4710
         inc   <u00A6
L46F2    lbsr  L1D2C
         bcs   L4710
L46F7    tst   u0008,u
         beq   L470A
L46FB    lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L46F2
         tst   <u001D,u
         bne   L46F2
         bra   L46EA
L470A    tst   <u007C
         beq   L46FB
         bra   L46EA
L4710    clr   <u0077
L4712    tst   u0008,u
         bne   L4729
         tst   <u007C
         bne   L4748
         tst   <u001D,u
         bne   L4741
         lda   [,u]
         cmpa  >PRCCHR,pcr
         bne   L4748
         bra   L4741
L4729    ldb   #$01
         sta   <u0081
         clr   <u00D7
         lda   <u0077
         lbsr  L2C2B
         lda   <u0077
         cmpa  <LASTROW
         bne   L473F
         lbsr  L1111
         dec   <u0077
L473F    inc   <u0077
L4741    lbsr  L1D2C
         bcs   L4748
         bra   L4712
L4748    tst   <u007C
         bne   L4760
         tst   <u001D,u
         bne   L4759
         lda   [,u]
         cmpa  >PRCCHR,pcr
         bne   L4760
L4759    lda   #$01
         sta   <u007C
         lbsr  L2BBB
L4760    lda   <u0077
         inca
         sta   <u006D
         sta   <u0075
         lbra  L241D
         lbsr  L2A89
         bcs   L4780
         clr   u0006,u
         clr   <u0081
         sta   <u007E
         lda   #$01
         sta   <u00D7
         clr   <u0081
         lda   <u0077
         lbsr  L2C2B
L4780    lbra  L2438
         lda   <u0077
         lbsr  L1185
         lda   <u0077
         clrb
         lbsr  GOROWCOL
         ldx   >PAGS1,pcr
         lbsr  L310F  Write string in X
         ldx   <u001C
L4797    lbsr  L1698
         anda  #$7F
         cmpa  >ESCC,pcr
         lbeq  L241D
         cmpa  #$0D
         beq   L47D0
         lbsr  OUTREPT
         cmpa  #$30
         bcs   L47B7
         cmpa  #$39
         bhi   L47B7
         sta   ,x+
         bra   L4797
L47B7    lbsr  L16B4
         cmpa  >PAGC,pcr
         lbeq  L47CA
         lda   #$21
         lbsr  L2AF4
         lbra  L241D
L47CA    clr   <u00A3
         ldd   <u005F
         bra   L47E2
L47D0    sta   ,x
         ldx   <u001C
         lbsr  L4364
         bcs   L47B7
         cmpd  #$0000
         beq   L47E2
         subd  #$0001
L47E2    std   <u00C6
         ldd   #$0000
         lbsr  GOROWCOL
         ldd   <u00C6
         cmpd  u000F,u
         bls   L4843
L47F1    lbsr  L1D2C
         bcc   L4800
         ldb   #$08
         stb   <u0077
         lbsr  L2AF4
         lbra  L23E7
L4800    ldd   u000F,u
         cmpd  <u00C6
         bne   L47F1
L4807    lda   #$01
         sta   <u0081
         lda   <u003E
         lbsr  L2C2B
         lda   <u003E
         cmpa  <LASTROW
         bcs   L4819
         lbsr  L1111
L4819    ldd   <u003E
         inca
         lbsr  GOROWCOL
L481F    lbsr  L1D2C
         tst   u0008,u
         bne   L4807
         tst   <u007C
         bne   L4837
         tst   <u001D,u
         bne   L481F
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L481F
L4837    lda   <u003E
         sta   <u0077
         inca
         sta   <u006D
         sta   <u0075
         lbra  L23E3
L4843    ldd   <u00C6
         subd  <u005F
         bcc   L484C
         ldd   #$0000
L484C    lda   #$38
         mul
         ldx   <u007F
         leax  d,x
         ldy   <u0020
         ldd   #$0038
         lbsr  L3EDA
         lbsr  L25AC
         bra   L4807
         lda   <u00A3
         cmpa  #$96
         bcc   L486E
         adda  #$19
         sta   <u00A3
         lbra  L240D
L486E    lda   #$02
         lbsr  L2AF4
         lbra  L2438
         lda   <u00A3
         beq   L486E
         suba  #$19
         bcs   L486E
         sta   <u00A3
         lbra  L240D
L4883    clr   <u00CA
         clr   <u0066
L4887    ldy   u0006,u
         pshs  y
         leay  $01,y
         cmpy  <u0070
         puls  y
         lbcc  L1F8B
         ldb   ,y
         bpl   L48A5
         cmpb  #$F0
         beq   L48A5
         cmpb  #$F1
         beq   L48A5
         stb   <u0066
L48A5    lbsr  L1698
         cmpa  >L04DE,pcr
         bne   L48B2
         clr   <u00CA
         bra   L48A5
L48B2    cmpa  #$20
         lbcs  L491E
         cmpa  #$7F
         lbeq  L491E
         tst   <u00CA
         bne   L48E9
         tst   <u0066
         beq   L48E5
         pshs  a
         leay  $01,y
         ldx   u0006,u
         sty   u0006,u
L48CF    cmpx  ,u
         beq   L48D9
         lda   ,-x
         sta   ,-y
         bra   L48CF
L48D9    sty   ,u
         puls  a
         ldy   u0006,u
         sta   ,y
         bra   L4902
L48E5    sta   ,y
         bra   L4902
L48E9    tst   <u0066
         beq   L48F5
         ldb   <u00CA
         stb   ,y
         sta   $01,y
         bra   L4902
L48F5    pshs  a
         lda   <u00CA
         lbsr  L2ABC
         puls  a
         sta   ,y
         bra   L4902
L4902    lbsr  L1AD8
         lbsr  L220A
         lbsr  L237E
         lda   #$01
         sta   <u0081
         clr   <u00D7
         ldu   <u0022
         lda   <u0077
         lbsr  L2C2B
         lbsr  L454D
         lbra  L4887
L491E    cmpa  >BSC,pcr
         lbeq  L4988
         cmpa  #$0D
         beq   L4959
         cmpa  >ESCC,pcr
         lbeq  L240D
         cmpa  >L04F2,pcr
         lbeq  L4969
         lbsr  L3924
         tstb
         lbne  L4887
         lbsr  L26BF
         lbcc  L4887
         lda   #$01
         sta   <u0081
         clr   <u00D7
         ldu   <u0022
         lda   <u0077
         lbsr  L2C2B
         lbra  L4887
L4959    lda   #$F0
         lbsr  L2ABC
         ldy   u0006,u
         leay  -$01,y
         sty   u0006,u
         lbra  L4902
L4969    lbsr  L2A89
         bcs   L4980
         clr   <u0081
         sta   <u007E
         lda   #$01
         sta   <u00D7
         clr   <u0081
         lda   <u0077
         lbsr  L2C2B
         lbra  L4883
L4980    lda   #$1D
         lbsr  L2AF4
         lbra  L4887
L4988    lbsr  L458F
         lbra  L4887
         lbsr  L1698
         cmpa  #$20
         lbcs  L245D
         cmpa  #$7F
         lbcc  L245D
         lbsr  L2ABC
         lbsr  L220A
         lbsr  L237E
         tst   <u0075
         lbne  L241D
         lda   <u0077
         inca
         sta   <u0075
         sta   <u006D
         lbra  L241D
         ldx   #$0001
         ldu   <u0022
         cmpx  u0009,u
         bcc   L49CB
         lbsr  L24D0
         lbsr  L25AC
         lda   #$01
         sta   <u0077
         sta   <u007C
L49CB    ldx   >L055B,pcr
         lbsr  WRLINE0 Write at 0,0
         ldx   >L0557,pcr
         lbsr  L310F  Write string in X
         ldx   >L055D,pcr
         lbsr  L310F  Write string in X
L49E0    lbsr  L3131
         lbsr  L16B4
         cmpa  #$0D
         beq   L4A11
         cmpa  >YCHR,pcr
         beq   L4A11
         cmpa  >NCHR,pcr
         beq   L49FD
         lda   #$07
         lbsr  WrA2BUF
         bra   L49E0
L49FD    lbsr  OUTREPT
         ldx   >L055F,pcr
         lbsr  WRLINE1
         lbsr  L31AE
         ldx   <u001C
         lbsr  L3402
         bra   L4A20
L4A11    lda   #$59
         lbsr  OUTREPT
L4A16    ldd   >L0557,pcr
         leax  >0,pcr
         leax  d,x
L4A20    lbsr  L022C
         bcs   L4A3F
L4A25    ldx   <u001C
L4A27    lbsr  L02E8
         bcs   L4A36
         anda  #$7F
         sta   ,x+
         cmpa  #$0D
         bne   L4A27
         bra   L4A51
L4A36    pshs  cc
         lbsr  L0287
         puls  cc
         bvs   L4A4A
L4A3F    ldd   #$0000
         lbsr  GOROWCOL
         lbsr  L02C5
         bra   L4A74
L4A4A    lda   #$01
         sta   <u00DB
         lbra  L3140
L4A51    ldx   <u001C
         lda   ,x
         cmpa  #$0D
         beq   L4A25
         bsr   L4A83
         bcs   L4A74
         ldy   <u0036
         lsla
         tfr   a,b
         clra
         leay  d,y
         bsr   L4A83
         bcs   L4A74
         sta   ,y
         bsr   L4A83
         bcs   L4A74
         sta   $01,y
         bra   L4A25
L4A74    clr   <u00DB
         ldx   >L0559,pcr
         lbsr  WRLINE2
         lbsr  L0287
         lbra  L3140
L4A83    clr   <u0065
L4A85    lda   ,x
         cmpa  #$20
         beq   L4A8F
         cmpa  #$2C
         bne   L4A93
L4A8F    leax  $01,x
         bra   L4A85
L4A93    leax  $01,x
         cmpa  #$2D
         bne   L4A9D
         inc   <u0065
         lda   ,x+
L4A9D    cmpa  #$24
         beq   L4AB6
         cmpa  #$27
         beq   L4AB2
         leax  -$01,x
         lbsr  L4364
         bcs   L4B0B
         tfr   b,a
         leax  -$01,x
         bra   L4ADF
L4AB2    lda   ,x+
         bra   L4ADF
L4AB6    lda   ,x+
         bsr   L4B0E
         bcs   L4B0B
         sta   <u0066
         lda   ,x+
         cmpa  #$20
         beq   L4ADD
         cmpa  <u0031,u
         beq   L4ADD
         cmpa  #$2C
         beq   L4ADD
         bsr   L4B0E
         bcs   L4B0B
         lsl   <u0066
         lsl   <u0066
         lsl   <u0066
         lsl   <u0066
         adda  <u0066
         bra   L4ADF
L4ADD    lda   <u0066
L4ADF    tst   <u0065
         beq   L4AE5
         suba  #$40
L4AE5    anda  #$7F
         sta   <u0066
L4AE9    lda   ,x
         cmpa  #$20
         beq   L4B00
         cmpa  #$2C
         beq   L4B00
         cmpa  <u0031,u
         beq   L4B04
         cmpa  #$0D
         beq   L4B00
         cmpa  #$F0
         bne   L4B06
L4B00    leax  $01,x
         bra   L4AE9
L4B04    leax  $01,x
L4B06    lda   <u0066
         andcc #^Carry
         rts
L4B0B    orcc  #Carry
         rts
L4B0E    cmpa  #$30
         bcs   L4B2B
         cmpa  #$39
         bhi   L4B1B
         suba  #$30
         andcc #^Carry
         rts
L4B1B    lbsr  L16B4
         cmpa  #$41
         bcs   L4B1B
         cmpa  #$46
         bhi   L4B2B
         suba  #$37
         andcc #^Carry
         rts
L4B2B    orcc  #Carry
         rts
L4B2E    stb   <u00EB
         tfr   x,d
         leax  >0,pcr
         leax  d,x
         lda   #$04
L4B3A    ldb   #$02
         lbsr  GOROWCOL
         lbsr  L312A
         lda   <u003E
         inca
         ldb   <u003E
         subb  #$03
         cmpb  <u00EB
         bne   L4B3A
         ldd   #$1303
         lbsr  GOROWCOL
         ldx   >BANNER,pcr
         lbsr  L310F  Write string in X
L4B5A    clr   <u00EC
L4B5C    lda   #$20
         lbsr  OUTREPT
         lda   <u00EC
         adda  #$04
         clrb
         lbsr  GOROWCOL
         lda   #$3E
         lbsr  OUTREPT
         ldd   <u003E
         decb
         lbsr  GOROWCOL
L4B74    lbsr  L0155   Read keyboard
         lbsr  L16B4
         cmpa  #$0D
         beq   L4BAA
         cmpa  >ESCC,pcr
         beq   L4BAD
         cmpa  >CURUC,pcr
         beq   L4B9B
         cmpa  >CURDC,pcr
         bne   L4B74
         lda   <u00EC
         inca
         cmpa  <u00EB
         bcc   L4B5A
         inc   <u00EC
         bra   L4B5C
L4B9B    tst   <u00EC
         bne   L4BA6
         lda   <u00EB
         deca
         sta   <u00EC
         bra   L4B5C
L4BA6    dec   <u00EC
         bra   L4B5C
L4BAA    lda   <u00EC
         rts
L4BAD    clra
         rts
L4BAF    clrb
         lda   #$04
L4BB2    clrb
         lbsr  GOROWCOL
         lda   #$20
         lbsr  OUTREPT
         lda   <u003E
         inca
         ldb   <u003E
         subb  #$04
         cmpb  <u00EB
         bne   L4BB2
         bra   L4B5A
L4BC8    clr   <u005B
         clr   <u005C
         ldd   u000F,u
         cmpd  <u005F
         bne   L4BDD
         ldx   >L0575,pcr
         lbsr  WRLINE0 Write at 0,0
         lbra  L4C7A
L4BDD    clra
         lbsr  L1185
         ldx   >L0577,pcr
         lbsr  WRLINE0 Write at 0,0
         lbsr  L3131
         lbsr  L16B4
         cmpa  >ESCC,pcr
         lbeq  L3140
         cmpa  >NCHR,pcr
         lbeq  L4CBC
         cmpa  #$0D
         beq   L4C0F
         cmpa  >YCHR,pcr
         beq   L4C0F
L4C08    lda   #$07
         lbsr  WrA2BUF
         bra   L4BC8
L4C0F    lda   >YCHR,pcr
         lbsr  WrA2BUF
         inc   <u005B
         tst   <u005E
         bne   L4C7A
         tst   <u006E
         beq   L4C51
         ldx   >L0579,pcr
         lbsr  WRLINE1
         ldx   <u0032
         lbsr  L312A
         ldx   >L057B,pcr
         lbsr  L310F  Write string in X
         lbsr  L3131
         lbsr  L16B4
         cmpa  >ESCC,pcr
         lbeq  L3140
         cmpa  >YCHR,pcr
         beq   L4C7A
         cmpa  #$0D
         beq   L4C7A
         cmpa  >NCHR,pcr
         bne   L4C08
L4C51    lda   #$01
         lbsr  L1185
         ldx   >L053D,pcr
         lbsr  WRLINE1
         lbsr  L31AE
         leax  -$01,x
         cmpx  <u001C
         lbeq  L3140
         ldx   <u001C
         lbsr  L3402
         ldy   <u0032
         ldd   #$0036
         lbsr  L3EDA
         lda   #$02
         sta   <u006E
L4C7A    tst   <u005D
         bne   L4C87
         ldx   >L0583,pcr
         lbsr  WRLINE2
         bra   L4CBF
L4C87    ldx   >L057D,pcr
         lbsr  WRLINE2
         lbsr  L3131
         lbsr  L16B4
         cmpa  >ESCC,pcr
         lbeq  L3140
         cmpa  >YCHR,pcr
         beq   L4CB1
         cmpa  #$0D
         beq   L4CB1
         cmpa  >NCHR,pcr
         bne   L4C87
         lbsr  OUTREPT
         bra   L4CBF
L4CB1    lda   >YCHR,pcr
         lbsr  OUTREPT
         inc   <u005C
         bra   L4CBF
L4CBC    lbsr  OUTREPT
L4CBF    tst   <u005B
         lbeq  L4DDA
         tst   <u005E
         bne   L4D1A
L4CC9    ldx   <u0032
         lbsr  L01F2
         bcc   L4D18
         lbvc  L4EA2
         ldx   <u0032
L4CD6    lbsr  L02F7
         bcc   L4CC9
         lbvc  L4EA2
L4CDF    ldx   >L053B,pcr
         lbsr  WRLINE3
         lbsr  L3131
         lbsr  L16B4
         cmpa  >ESCC,pcr
         lbeq  L3140
         cmpa  >NCHR,pcr
         lbeq  L3140
         cmpa  >YCHR,pcr
         beq   L4D06
         cmpa  #$0D
         bne   L4CDF
L4D06    lda   >YCHR,pcr
         lbsr  WrA2BUF
         ldx   <u0032
         lbsr  L02A5
         lbcs  L4EA2
         bra   L4CD6
L4D18    inc   <u005E
L4D1A    ldu   <u0022
         ldd   u000F,u
         subd  <u005F
         lda   #$38
         mul
         ldy   <u007F
         leay  d,y
         sty   <u0063
         ldx   $04,y
         stx   <u0061
         ldu   <u0063
         ldx   <u0013,u
         beq   L4D4B
         cmpx  <u003A
         beq   L4D4B
         ldy   <u003A
         sty   <u0013,u
         ldd   #$01F2
         lbsr  L3EDA
         lda   #$F0
         sta   ,y
L4D4B    ldx   <u0015,u
         beq   L4D65
         cmpx  <u0038
         beq   L4D65
         ldy   <u0038
         sty   <u0015,u
         ldd   #$01F2
         lbsr  L3EDA
         lda   #$F0
         sta   ,y
L4D65    ldx   <u0069
L4D67    cmpx  <u0061
         bcc   L4D89
         lda   ,x+
         cmpa  #$F0
         bne   L4D73
         lda   #$0D
L4D73    lbsr  L02D0
         bcc   L4D67
         ldd   #$0200
         lbsr  GOROWCOL
         lbsr  L02C5
         lbsr  L028D
         clr   <u005E
         lbra  L3140
L4D89    ldy   <u0020
         ldx   <u0063
         ldd   #$0038
         lbsr  L3EDA
         lbsr  L25AC
         ldy   <u0069
         sty   <u007A
         ldu   <u0022
         ldx   #$0000
         stx   ,u
         stx   u0009,u
         stx   u000B,u
         ldy   <u007F
         ldx   <u0022
         ldd   #$0038
         lbsr  L3EDA
         ldy   <u007F
         ldd   $0F,y
         std   <u005F
         ldd   <u0069
         std   $04,y
         ldd   u000F,u
         std   <u008D
         ldd   #$FFFF
         std   <u008B
         ldx   <u002A
         stx   <u0091
         clr   <u009E
         clr   <u0093
         ldu   <u0022
L4DD1    tst   u0008,u
         beq   L4DDA
         lbsr  L1D2C
         bra   L4DD1
L4DDA    tst   <u005C
         lbeq  L3140
L4DE0    ldu   <u0022
         tst   u0008,u
         beq   L4DEA
         ldd   u0004,u
         bra   L4DEC
L4DEA    ldd   ,u
L4DEC    std   <u0067
         ldx   <u007A
         leax  >$01F4,x
         cmpx  <u0067
         bcs   L4E07
         leax  >L057F,pcr
         lbsr  WRLINE3
         lda   #$07
         lbsr  WrA2BUF
         lbra  L3140
L4E07    ldd   <u0070
         subd  #$0001
         subd  <u0067
         ldx   <u0067
         ldy   <u007A
         lbsr  L3EDA
         ldx   <u0070
         leax  <-100,x
         stx   <u0067
         leax  <-50,x
         stx   <u0063
         leax  >-1000,x
         stx   <u0061
         tfr   y,x
         tst   <u005C
         bne   L4E3B
L4E2E    lbsr  L02DF
         bcs   L4E60
         bita  #$60
         bne   L4E3D
         cmpa  #$0D
         bne   L4E2E
L4E3B    lda   #$F0
L4E3D    sta   ,x+
         cmpx  <u0061
         bcs   L4E2E
         cmpa  #$F0
         bne   L4E4B
         inc   <u00F8
         bra   L4E71
L4E4B    cmpx  <u0063
         bcs   L4E2E
         cmpa  #$20
         bne   L4E57
         inc   <u00F8
         bra   L4E71
L4E57    cmpx  <u0067
         bcs   L4E2E
         tsta
         bmi   L4E2E
         bra   L4E71
L4E60    bvs   L4E6C
         ldx   >L0543,pcr
         lbsr  WRLINE2
         lbsr  L02C5
L4E6C    lbsr  L0281
         clr   <u005D
L4E71    tfr   x,d
         subd  <u007A
         ldy   <u0070
         pshs  a
         lda   -$01,x
         cmpa  #$F0
         puls  a
         beq   L4E84
         leay  -$01,y
L4E84    lbsr  L3EC7
         ldu   <u0022
         tst   u0008,u
         bne   L4E92
         sty   ,u
         bra   L4E95
L4E92    sty   u0004,u
L4E95    lbsr  L1B4C
         lbsr  L220A
L4E9B    tst   <u00ED
         beq   L4EDB
         lbra  L3140
L4EA2    lda   #$02
         lbsr  L1185
         lda   #$03
         lbsr  L1185
         ldx   >L0581,pcr
         lbsr  L310F  Write string in X
         lbsr  L02C5
         bra   L4E9B
L4EB8    tst   <u006E
         beq   L4EDB
L4EBC    clr   <u00F8
         clr   <u00F7
         ldx   <u0030
         lbsr  L024F
         bcc   L4ED6
         bvc   L4ECD
         inc   <u00F7
         bra   L4EDB
L4ECD    lbsr  L02C5
         lbsr  L1146
         lbra  L0421
L4ED6    inc   <u005D
         lbra  L4DE0
L4EDB    inc   <u00ED
         tst   >L0011,pcr
         lbeq  L3137
         lbsr  L10FB
         clr   <u00EB
         lda   #$FF
         sta   <u006D
         lbra  L4A16
         emod
BINEND   equ   *
