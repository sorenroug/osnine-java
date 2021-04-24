         nam   Stylograph 2.1
         ttl   program module

 use   defsfile

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
TTYSTATE    rmb   2     Pointer to 32 byte buffer
u0010    rmb   2     Pointer to 32 byte buffer
u0012    rmb   2  Pointer to buffer
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
u0022    rmb   1
u0023    rmb   1
u0024    rmb   1
u0025    rmb   1
u0026    rmb   2
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
u0036    rmb   2
u0038    rmb   2
u003A    rmb   2
u003C    rmb   2
LASTROW    rmb   1
LASTCOL    rmb   1 Max column
SCRROW    rmb   1
u0041    rmb   1 Curr column
u0042    rmb   1
u0043    rmb   1
u0044    rmb   1
u0045    rmb   1
u0046    rmb   1
u0047    rmb   1
u0048    rmb   1
u0049    rmb   1
u004A    rmb   1
u004B    rmb   1
u004C    rmb   1
u004D    rmb   1
u004E    rmb   1
u004F    rmb   1
u0050    rmb   2
u0052    rmb   2
u0054    rmb   1
u0055    rmb   1
u0056    rmb   2
u0058    rmb   1
u0059    rmb   1
u005A    rmb   2
u005C    rmb   2
u005E    rmb   2
u0060    rmb   1
u0061    rmb   1
u0062    rmb   1    Max pages
u0063    rmb   1
u0064    rmb   1
u0065    rmb   1
u0066    rmb   2
u0068    rmb   2
u006A    rmb   1
u006B    rmb   2
u006D    rmb   2
u006F    rmb   1
u0070    rmb   1
u0071    rmb   1
u0072    rmb   2
u0074    rmb   3
u0077    rmb   1
u0078    rmb   2
u007A    rmb   2
u007C    rmb   2
u007E    rmb   2
u0080    rmb   2
u0082    rmb   2
u0084    rmb   2
u0086    rmb   2
u0088    rmb   1
u0089    rmb   1
u008A    rmb   2
u008C    rmb   2
u008E    rmb   1
u008F    rmb   1
u0090    rmb   1
u0091    rmb   2
u0093    rmb   2
u0095    rmb   1
u0096    rmb   1
u0097    rmb   1
u0098    rmb   1
u0099    rmb   1
u009A    rmb   1
u009B    rmb   1
u009C    rmb   1
u009D    rmb   1
u009E    rmb   1
u009F    rmb   1
u00A0    rmb   1
u00A1    rmb   1
u00A2    rmb   2
u00A4    rmb   1
u00A5    rmb   1
u00A6    rmb   2
u00A8    rmb   2
u00AA    rmb   2
u00AC    rmb   2
u00AE    rmb   2
u00B0    rmb   2
u00B2    rmb   2
u00B4    rmb   2
u00B6    rmb   2
u00B8    rmb   2
u00BA    rmb   6
u00C0    rmb   1
u00C1    rmb   1
u00C2    rmb   1
u00C3    rmb   2
u00C5    rmb   2
u00C7    rmb   1
u00C8    rmb   2
u00CA    rmb   1
u00CB    rmb   2
u00CD    rmb   1
u00CE    rmb   1
u00CF    rmb   1
u00D0    rmb   1
u00D1    rmb   2
u00D3    rmb   1
u00D4    rmb   1
u00D5    rmb   1
u00D6    rmb   1
u00D7    rmb   1
u00D8    rmb   1
u00D9    rmb   1
u00DA    rmb   1
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
u00E8    rmb   2
u00EA    rmb   1
u00EB    rmb   1
u00EC    rmb   1
u00ED    rmb   1
u00EE    rmb   1
u00EF    rmb   13073
size     equ   .

ESCAPE equ $1B

  ifeq PRODUCT-P.Dragon
L000D    fcb   1  Display driver select
  else
L000D    fcb   26  VT100/ANSI
  endc
L000E    fcb   $00 Type 0 printer
         fcb   20  MAXPAGES
L0010    fcb   40   Type 40 printer
L0011    fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fdb   TXTBEG
         fdb   TXTEND
         fdb   BINEND
         fdb   TRMBEG
         fdb   TRMSEQ
         fdb   TRMEND
         fdb   $0000
         fdb   $0000
         fdb   $0000
         fdb   $1B31
         fdb   $1B93
         fcb   $0D
         fcb   $37 7
         fcb   $4C L
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
         ldu   #0
         os9   F$Icpt
         ldx   <u007A
         leay  >$0100,x
         leax  >$0AD7,y
         stx   <TTYSTATE
         leax  >$0AF7,y   Jump 32 bytes
         stx   <u0010
         leax  >$0B17,y   Jump 32 bytes
         stx   <u0012
         leax  >$0B6C,y
         stx   <u0014
         bsr   L00EC
         leax  >$0BA7,y
         stx   <u0016
         bsr   L00EC
         leax  >$0BE2,y
         stx   <u0018
         bsr   L00EC
         leax  >$0FE7,y
         stx   <u001A
         bsr   L00EC
         clra   Path number 0
         clrb   Function code 0 (ss.opt)
         ldx   <TTYSTATE  Address to put status packet
         os9   I$GetStt
         ldy   <u0010
         ldd   #$0020
         lbsr  L45F5
         ldx   <u0010
         lda   #$FF
         sta   $0C,x
         clr   $04,x
         sta   $0F,x
         clra
         clrb
         os9   I$SetStt
         ldx   <u007A
         leax  >$0A87,x
         stx   <u00ED
         stx   <u00EF
         puls  pc,y,x,b,a

L00EC    leau  $05,x
         stu   ,x
         stu   $02,x
         clr   $04,x
         rts

* Interrupt handler
IRQHNDLR    rti

* Add a to buffer
WrA2BUF  pshs  y,x,b,a
         ldx   <u00ED
         anda  #$7F
         sta   ,x+
         stx   <u00ED
         leax  -80,x
         cmpx  <u00EF
         bcs   L011C
         bra   L010B

* Write content of buffer
L0109    pshs  y,x,b,a
L010B    ldd   <u00ED
         subd  <u00EF
         beq   L011C
         tfr   d,y
         ldx   <u00EF
         stx   <u00ED
         lda   #$01
         os9   I$Write
L011C    puls  pc,y,x,b,a

* Switch to dimmed font?
L011E    rts

* Write text and unset dimmed font?
L011F    bra   L0109
         rts

L0122    pshs  y,x,a
         tfr   s,x
         ldy   #1
         lda   <u0000
         os9   I$Write
         puls  pc,y,x,a

L0131    pshs  x,b,a
         lda   #$02
         ldb   #$03
         os9   I$Create
         bcs   L0142
         sta   <u0000
         andcc #$FC
         puls  pc,x,b,a

L0142    stb   <u0003
         orcc  #Carry
         andcc #$FD
         puls  pc,x,b,a

L014A    pshs  a
         lda   <u0000
         os9   I$Close
         puls  pc,a

* Read one character from stdin
L0153    bsr   L0109
         pshs  y,x,a
         tfr   s,x
         ldy   #$0001
         lda   #$00
         os9   I$Read
         puls  y,x,a
         anda  #$7F
         rts

L0167    bsr   L0170
         beq   L016F
         bsr   L0153   Read keyboard
         bra   L0167 Read key if entered
L016F    rts

* Is there a character in keyboard buffer?
L0170    pshs  b,a
         lda   #$00
         ldb   #$01
         os9   I$GetStt
         bcs   L017F
         andcc #$FB
         puls  pc,b,a
L017F    orcc  #$04
         puls  pc,b,a

L0183    pshs  y,x,b,a
         ldy   <u0004
L0188    lda   ,y+
         cmpa  #$0D
         beq   L019E
         cmpa  #$20
         beq   L0188
         cmpa  #$2C
         beq   L0188
         cmpa  >OPTCHR,pcr  Character + for command line option
         beq   L01C6
         bra   L01A4
L019E    orcc  #Carry
         andcc #$FD
         puls  pc,y,x,b,a

L01A4    leay  -$01,y
         ldb   #$36
L01A8    lda   ,y+
         cmpa  #$0D
         beq   L01BB
         cmpa  #C$SPAC
         beq   L01BB
         cmpa  #',
         beq   L01BB
         sta   ,x+
         decb
         bne   L01A8
L01BB    clr   ,x
         leay  -$01,y
         sty   <u0004
         andcc #^Carry
         puls  pc,y,x,b,a

L01C6    lda   ,y+
         cmpa  #$0D
         beq   L019E
         cmpa  #C$SPAC
         beq   L0188
         cmpa  #',
         beq   L0188
         bra   L01C6

L01D6    pshs  b,a
         ldx   <u0006
L01DA    lda   ,x+
         cmpa  >OPTCHR,pcr  Character +
         beq   L01EA
         cmpa  #$0D
         bne   L01DA
         orcc  #Carry
         puls  pc,b,a
L01EA    stx   <u0006
         andcc #^Carry
         puls  pc,b,a

L01F0    pshs  u,x,b,a
         lda   #$02
         ldb   #$03
         os9   I$Create
         ldx   <u0018
L01FB    bcs   L020D
         sta   $04,x
         leau  $05,x
         stu   ,x
         leau  >$400,u
         stu   $02,x
         andcc #$FC
         puls  pc,u,x,b,a
L020D    stb   <u0003
         cmpb  #E$CEF  Creating Existing File
         bne   L0217
         orcc  #$03
         puls  pc,u,x,b,a
L0217    orcc  #Carry
         andcc #$FD
         puls  pc,u,x,b,a

L021D    pshs  u,x,b,a
         lda   #$02
         ldb   #$03
         os9   I$Create
         ldx   <u001A
         bra   L01FB
L022A    pshs  y,x,b,a
         leax  >STYDIR,pcr
         ldy   <u0012
L0233    lda   ,x+
         beq   L023B
         sta   ,y+
         bra   L0233
L023B    ldx   $02,s
L023D    lda   ,x+
         sta   ,y+
         bne   L023D
         ldx   <u0012
         bsr   L0270
         puls  pc,y,x,b,a

L0249    pshs  u,x,a
         lda   #$01
         os9   I$Open
         ldx   <u0014
L0252    bcs   L025E
         sta   $04,x
         leau  $05,x
         stu   ,x
         stu   $02,x
         puls  pc,u,x,a

L025E    cmpb  #E$PNNF   File not found
         beq   L026A
         stb   <u0003
         orcc  #Carry
         andcc #$FD
         puls  pc,u,x,a
L026A    stb   <u0003
         orcc  #$03
         puls  pc,u,x,a
L0270    pshs  u,x,a
         lda   #$01
         os9   I$Open
         ldx   <u0016
         bra   L0252
L027B    pshs  x,a
         ldx   <u0014
         bra   L0294
L0281    pshs  x,a
         ldx   <u0016
         bra   L0294
L0287    pshs  x,a
         ldx   <u0018
         bra   L0291
L028D    pshs  x,a
         ldx   <u001A
L0291    lbsr  L043B
L0294    lda   $04,x
         beq   L029D
         clr   $04,x
         os9   I$Close
L029D    puls  pc,x,a

*
* Delete routine
L029F    pshs  y,x,b,a
         ldy   <u0012
L02A4    lda   ,x+
         beq   L02AC
         sta   ,y+
         bra   L02A4
L02AC    leax  >DOTBAK,pcr
L02B0    lda   ,x+
         sta   ,y+
         bne   L02B0
         ldx   <u0012
         os9   I$Delete
         stb   <u0003
         puls  pc,y,x,b,a

L02BF    pshs  b,a
         ldb   <u0003
         lda   #$01
         os9   F$PErr
         puls  pc,b,a
L02CA    pshs  x
         ldx   <u0018
L02CE    lbsr  L0428
         puls  pc,x
L02D3    pshs  x
         ldx   <u001A
         bra   L02CE
L02D9    pshs  x
         ldx   <u0014
L02DD    lbsr  L0460
         puls  pc,x
L02E2    pshs  x
         ldx   <u0016
         bra   L02DD
L02E8    pshs  u,y,x,b,a
         ldy   <u0012
         stx   <u000C
L02EF    lda   ,x+
         sta   ,y+
         bne   L02EF
         leay  -$01,y
         leax  >DOTBAK,pcr
L02FB    lda   ,x+
         sta   ,y+
         bne   L02FB
         lda   #$01
         ldx   <u0012
         os9   I$Open
         bcs   L0311
         os9   I$Close
         orcc  #$03
         puls  pc,u,y,x,b,a
L0311    cmpb  #E$PNNF   File not found
         beq   L031D
L0315    stb   <u0003
         orcc  #Carry
         andcc #$FD
         puls  pc,u,y,x,b,a

L031D    tst   <u004E
         beq   L0339
         ldx   <u000A
         bne   L0334
         ldx   <u0014
         lda   $04,x
         ldb   #SS.POS
         os9   I$GetStt
         bcs   L0315
         stx   <u0008
         stu   <u000A
L0334    lbsr  L027B
         bcs   L0315
L0339    ldx   <u000C
         ldy   <u0012
         lda   #$20
         sta   ,y+
L0342    lda   ,x+
         sta   ,y+
         bne   L0342
         lda   #$20
         sta   -$01,y
L034C    lda   ,-x
         cmpa  #$2F
         beq   L0358
         cmpx  <u000C
         bne   L034C
         bra   L035A
L0358    leax  $01,x
L035A    lda   ,x+
         beq   L0362
         sta   ,y+
         bra   L035A
L0362    leax  >DOTBAK,pcr
L0366    lda   ,x+
         sta   ,y+
         bne   L0366
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
         bcs   L0315
         os9   F$Wait
         tstb
         bne   L0315
         tst   <u004E
         beq   L03C0
         ldx   <u000C
         ldy   <u0012
L0394    lda   ,x+
         sta   ,y+
         bne   L0394
         leay  -$01,y
         leax  >DOTBAK,pcr
L03A0    lda   ,x+
         sta   ,y+
         bne   L03A0
         ldx   <u0012
         lda   #$01
         os9   I$Open
         lbcs  L0315
         ldx   <u0014
         sta   $04,x
         ldx   <u0008
         ldu   <u000A
         os9   I$Seek
         lbcs  L0315
L03C0    andcc #^Carry
         puls  pc,u,y,x,b,a

L03C4    pshs  u,y,x,b,a
         pshs  x
         ldx   <TTYSTATE
         ldd   #$0000
         os9   I$SetStt
         puls  x
         tfr   x,u
         ldd   #$0000
L03D7    tst   d,u
         beq   L03E0
         addd  #$0001
         bra   L03D7
L03E0    tfr   d,y
         leay  $01,y
         leax  d,u
         lda   #$0D
         sta   ,x
         ldd   #$0000
         leax  >SHELL,pcr   shell
         os9   F$Fork
         bcs   L040C
         os9   F$Wait
         tstb
         bne   L040C
         andcc #^Carry
L03FE    pshs  cc
         ldx   <u0010
         ldd   #$0000
         os9   I$SetStt
         puls  cc
         puls  pc,u,y,x,b,a
L040C    stb   <u0003
         orcc  #Carry
         bra   L03FE
L0412    lbsr  L0109
         lbsr  L0287
         lbsr  L028D
         ldd   #$0000
         ldx   <TTYSTATE
         os9   I$SetStt
         clrb
         os9   F$Exit
         rts

L0428    pshs  u
         ldu   ,x
         sta   ,u+
         stu   ,x
         cmpu  $02,x
         beq   L0439
         andcc #^Carry
         puls  pc,u
L0439    puls  u
L043B    pshs  y,x,b,a
         tst   $04,x
         beq   L045E
         tfr   x,y
         leax  $05,y
         pshs  x
         ldd   ,y
         stx   ,y
         subd  ,s++
         beq   L045E
         pshs  b,a
         lda   $04,y
         puls  y
         os9   I$Write
         bcs   L045C
         puls  pc,y,x,b,a

L045C    stb   <u0003
L045E    puls  pc,y,x,b,a
L0460    pshs  u
L0462    ldu   ,x
         cmpu  $02,x
         beq   L0471
         lda   ,u+
         stu   ,x
         andcc #^Carry
         puls  pc,u
L0471    pshs  y,x
         tfr   x,y
         lda   $04,y
         leax  $05,y
         stx   ,y
         ldy   #$0036
         os9   I$Read
         sty   <u0006
         puls  y,x
         bcs   L0493
         ldd   <u0006
         leau  $05,x
         leau  d,u
         stu   $02,x
         bra   L0462
L0493    cmpb  #E$EOF
         bne   L049B
         orcc  #$03
         puls  pc,u
L049B    orcc  #Carry
         andcc #$FD
         stb   <u0003
         puls  pc,u

*EQUATE FOR STYFIX
TXTBEG EQU *
 ifeq PRODUCT-P.Dragon
 use stytext_drg64.i
 else
 use stytext.i
 endc

DOTBAK FCC '.bak'
 FCB 0
RENAME FCC 'rename'
 FCB $0D
SHELL FCC 'shell'
 FCB $0D
STYDIR FCC '/D0/STY/'
 FCB 0

*SAVE A FEW BYTES FOR POSSIBLE LARGER TEXT OVERLAY
 FCC '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'

*EQUATE FOR STYFIX
TXTEND EQU *

         lda   <u0045    Load driver number
         cmpa  #$20      Number of types
         bhi   L149C branch if terminal number is too high
         tsta
         bne   L149F
L149C    orcc  #Carry
         rts

L149F    deca
         ldb   #$0E  size of entry
         mul
         leax  >TRMBEG+32,pcr
         leax  d,x
         clrb
         ldy   <u003C
L14AD    incb
         lda   b,x
         bne   L14B7
         ldu   #$0000
         bra   L14C2

L14B7    leau  >TRMSEQ,pcr
L14BB    tst   ,u+
         bpl   L14BB
         deca
         bne   L14BB
L14C2    lslb
         stu   b,y
         asrb
         cmpb  #$0D
         bcs   L14AD
         leau  >L14E2,pcr
         lda   ,x
         sta   ,y
         anda  #$07
         lsla
         ldd   a,u
         std   <LASTROW
         lda   ,x
         anda  #$20
         sta   <u0043
         andcc #$FE
         rts

* Table for screen sizes. This has been modified for Go51's
* unusual screen size. It is used as an index for the D codes
L14E2 equ *
  ifeq PRODUCT-P.Dragon
         fcb   23,49  D2479
  else
         fcb   23,78  D2479
  endc
         fcb   23,79  D2480
         fcb   19,81  D2082
         fcb   23,81  D2482
         fcb   24,78  D2579

*THE FIRST 32 BYTES ARE RESERVED FOR 16 ADDRESS 
*POINTERS TO MACHINE LANGUAGE ROUTINES IF USED.

  ifeq PRODUCT-P.Dragon
TRMBEG   fdb   0,0,0,0,0,0,0,0
         fdb   0,0,0,0,0,0,0,0
  else
TRMBEG   fdb   HP2621MV,TEC70MV,VT100MV,GIMIXMV,0,0,0,0
         fdb   0,0,0,0,0,0,0,0
  endc

*THE FIRST BYTE SPECIFIES THE CHARACTERISTICS OF
*THE TERMINAL.
*THE NEXT 13 BYTES INDICATE THE SEQUENCE NUMBER
*THAT IS CALLED FOR THE TERMINAL FUNCTIONS.

*TERMINAL SPECIFICATION CONSTANTS
D2479 EQU 0  24 ROW BY 79 COLUMNS
D2480 EQU 1  24 X 80
D2082 EQU 2  20 X 82
D2482 EQU 3  24 X 82
D2579 EQU 4  25 X 79
CYX EQU $80 OUTPUT Y(ROW) THEN X(COLUMN) ON CURSOR ADDRESS
CAD20 EQU $40 ADD $20 TO CURSOR ADDRESSES
SSCD EQU $20 CAN SCROLL SCREEN DOWN
LERF EQU $10 HAS LINE ERASE FUNCTION

  ifeq PRODUCT-P.Dragon
*T1 GO51 terminal
*Note that D2479 is also changed to be 24x50
         fcb   LERF+SSCD+D2479
         fcb   1  CURMV  - CURSOR MOVE
         fcb   0  CURON  - CURSOR ON
         fcb   0  CUROFF - CURSOR OFF
         fcb   0  BLINK  - BLINK CURSOR
         fcb   0  SOLID  - SOLID CURSOR
         fcb   2  CLRS  - CLEAR SCREEN
         fcb   3  LERASE - ERASE LINE
         fcb   4  SCRLUP - SCROLL UP
         fcb   5  SCRLDN  - SCROLL DOWN
         fcb   0  SCINIT  - INITIALIZE TERMINAL
         fcb   0  SSHUT  - SHUT DOWN SCREEN
         fcb   6  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   7  ATT1  - CHARACTER ATTRIBUTES
 else
*T1 SOROC IQ-120
         fcb CYX+CAD20+LERF+D2479
         fcb   1  CURMV  - CURSOR MOVE
         fcb   0  CURON  - CURSOR ON
         fcb   0  CUROFF - CURSOR OFF
         fcb   0  BLINK  - BLINK CURSOR
         fcb   0  SOLID  - SOLID CURSOR
         fcb   2  CLRS  - CLEAR SCREEN
         fcb   5  LERASE - ERASE LINE
         fcb   3  SCRLUP - SCROLL UP
         fcb   0  SCRLDN  - SCROLL DOWN
         fcb   4  SCINIT  - INITIALIZE TERMINAL
         fcb   0  SSHUT  - SHUT DOWN SCREEN
         fcb   6  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   7  ATT1  - CHARACTER ATTRIBUTES
 endc
*T2 SOROC IQ-140
         fcb   CYX+CAD20+SSCD+LERF+D2479
         fcb   1  CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   2  CLRS  - CLEAR SCREEN
         fcb   5  LERASE - ERASE LINE
         fcb   3  SCRLUP - SCROLL UP
         fcb   8  SCRLDN  - SCROLL DOWN
         fcb   4  SCINIT  - INITIALIZE TERMINAL
         fcb   0
         fcb   6  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   7  ATT1  - CHARACTER ATTRIBUTES
*T3 SOROC IQ-130/135
         fcb   CYX+CAD20+SSCD+LERF+D2479
         fcb   1  CURMV  - CURSOR MOVE
         fcb   9  CURON  - CURSOR ON
         fcb   10  CUROFF - CURSOR OFF
         fcb   0
         fcb   0
         fcb   2  CLRS  - CLEAR SCREEN
         fcb   5  LERASE - ERASE LINE
         fcb   3  SCRLUP - SCROLL UP
         fcb   8  SCRLDN  - SCROLL DOWN
         fcb   4  SCINIT  - INITIALIZE TERMINAL
         fcb   0
         fcb   6  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   7  ATT1  - CHARACTER ATTRIBUTES
*T4 Televideo TVI 912/920 and Lear-Siegler ADM-31
         fcb   CYX+CAD20+SSCD+LERF+D2479
         fcb   1  CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   2  CLRS  - CLEAR SCREEN
         fcb   5  LERASE - ERASE LINE
         fcb   3  SCRLUP - SCROLL UP
         fcb   8  SCRLDN  - SCROLL DOWN
         fcb   4  SCINIT  - INITIALIZE TERMINAL
         fcb   0
         fcb   6  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   7  ATT1  - CHARACTER ATTRIBUTES
*T5 Hazeltine 1500/1420?
         fcb   SSCD+LERF+D2479
         fcb   11  CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   12  CLRS  - CLEAR SCREEN
         fcb   13  LERASE - ERASE LINE
         fcb   14  SCRLUP - SCROLL UP
         fcb   15  SCRLDN  - SCROLL DOWN
         fcb   16  SCINIT  - INITIALIZE TERMINAL
         fcb   17  SSHUT  - SHUT DOWN SCREEN
         fcb   16  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   17  ATT1  - CHARACTER ATTRIBUTES
*T6 Hazeltine 1400
         fcb   D2479
         fcb   11  CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   12  CLRS  - CLEAR SCREEN
         fcb   0
         fcb   14  SCRLUP - SCROLL UP
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   0
*T7 Lear-Siegler ADM-3A
         fcb   CYX+CAD20+D2479
         fcb   1  CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   18  CLRS  - CLEAR SCREEN
         fcb   0
         fcb   3   SCRLUP - SCROLL UP
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   0
*T8 Lear-Siegler ADM-42
         fcb   CYX+CAD20+SSCD+LERF+D2479
         fcb   1  CURMV  - CURSOR MOVE
         fcb   19  CURON  - CURSOR ON
         fcb   20  CUROFF - CURSOR OFF
         fcb   109  BLINK  - BLINK CURSOR
         fcb   110  SOLID  - SOLID CURSOR
         fcb   2  CLRS  - CLEAR SCREEN
         fcb   5  LERASE - ERASE LINE
         fcb   3  SCRLUP - SCROLL UP
         fcb   8  SCRLDN  - SCROLL DOWN
         fcb   4  SCINIT  - INITIALIZE TERMINAL
         fcb   0
         fcb   6  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   7  ATT1  - CHARACTER ATTRIBUTES
*T9 Microterm MIME-2A
         fcb   CYX+CAD20+SSCD+LERF+D2479
         fcb   1  CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   2  CLRS  - CLEAR SCREEN
         fcb   5  LERASE - ERASE LINE
         fcb   3  SCRLUP - SCROLL UP
         fcb   21  SCRLDN  - SCROLL DOWN
         fcb   4  SCINIT  - INITIALIZE TERMINAL
         fcb   0
         fcb   6  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   7  ATT1  - CHARACTER ATTRIBUTES
*T10 Microterm ACT-5A
         fcb   CYX+SSCD+LERF+D2479
         fcb   24  CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   25  CLRS  - CLEAR SCREEN
         fcb   26  LERASE - ERASE LINE
         fcb   27  SCRLUP - SCROLL UP
         fcb   28  SCRLDN  - SCROLL DOWN
         fcb   0
         fcb   0
         fcb   22  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   23  ATT1  - CHARACTER ATTRIBUTES
*T11 Intertec INTERTUBE II
         fcb   CYX+CAD20+LERF+D2579
         fcb   1  CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   25  CLRS  - CLEAR SCREEN
         fcb   29  LERASE - ERASE LINE
         fcb   94  SCRLUP - SCROLL UP
         fcb   0
         fcb   0
         fcb   0
         fcb   30  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   31  ATT1  - CHARACTER ATTRIBUTES

*T12 SWTPC CT-82
         fcb   SSCD+LERF+D2082
         fcb   32  CURMV  - CURSOR MOVE
         fcb   33  CURON  - CURSOR ON
         fcb   34  CUROFF - CURSOR OFF
         fcb   35  BLINK  - BLINK CURSOR
         fcb   36  SOLID  - SOLID CURSOR
         fcb   37  CLRS  - CLEAR SCREEN
         fcb   38  LERASE - ERASE LINE
         fcb   39  SCRLUP - SCROLL UP
         fcb   44  SCRLDN  - SCROLL DOWN
         fcb   40  SCINIT  - INITIALIZE TERMINAL
         fcb   41  SSHUT  - SHUT DOWN SCREEN
         fcb   42  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   43  ATT1  - CHARACTER ATTRIBUTES
*T13 SWTPC CT-8209/12
         fcb   CYX+CAD20+LERF+D2479
         fcb   51 CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   25  CLRS  - CLEAR SCREEN
         fcb   29  LERASE - ERASE LINE
         fcb   53  SCRLUP - SCROLL UP
         fcb   0
         fcb   47  SCINIT  - INITIALIZE TERMINAL
         fcb   0
         fcb   30  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   131  ATT1  - CHARACTER ATTRIBUTES
*T14 DEC VT52
         fcb   CYX+CAD20+SSCD+LERF+D2479
         fcb   51 CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   52  CLRS  - CLEAR SCREEN
         fcb   29  LERASE - ERASE LINE
         fcb   53  SCRLUP - SCROLL UP
         fcb   54  SCRLDN  - SCROLL DOWN
         fcb   0
         fcb   0
         fcb   0
         fcb   0
*T15 ADDS REGENT 25
         fcb   CYX+CAD20+LERF+D2479
         fcb   51 CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   25  CLRS  - CLEAR SCREEN
         fcb   29  LERASE - ERASE LINE
         fcb   53  SCRLUP - SCROLL UP
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   0
*T16 Heath H19 / Zenith Z-19
         fcb   CYX+CAD20+SSCD+LERF+D2480
         fcb   51 CURMV  - CURSOR MOVE
         fcb   55  CURON  - CURSOR ON
         fcb   56  CUROFF - CURSOR OFF
         fcb   57  BLINK  - BLINK CURSOR
         fcb   58  SOLID  - SOLID CURSOR
         fcb   52  CLRS  - CLEAR SCREEN
         fcb   29  LERASE - ERASE LINE
         fcb   53  SCRLUP - SCROLL UP
         fcb   54  SCRLDN  - SCROLL DOWN
         fcb   59  SCINIT  - INITIALIZE TERMINAL
         fcb   60  SSHUT  - SHUT DOWN SCREEN
         fcb   61  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   62  ATT1  - CHARACTER ATTRIBUTES
*T17 TEC 510, 610
         fcb   CYX+CAD20+D2479
         fcb   1 CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   63  CLRS  - CLEAR SCREEN
         fcb   0
         fcb   3  SCRLUP - SCROLL UP
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   0
*T18 Beehive MICRO B2
         fcb   CYX+CAD20+SSCD+LERF+D2479
         fcb   51 CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   64  CLRS  - CLEAR SCREEN
         fcb   29  LERASE - ERASE LINE
         fcb   53  SCRLUP - SCROLL UP
         fcb   65  SCRLDN  - SCROLL DOWN
         fcb   0
         fcb   0
         fcb   66  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   67  ATT1  - CHARACTER ATTRIBUTES
*T19 Beehive B100
         fcb   CYX+CAD20+LERF+D2479
         fcb   68  CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   64  CLRS  - CLEAR SCREEN
         fcb   29  LERASE - ERASE LINE
         fcb   69  SCRLUP - SCROLL UP
         fcb   0
         fcb   0
         fcb   0
         fcb   70  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   71  ATT1  - CHARACTER ATTRIBUTES
*T20 Volker-Craig VC-404
         fcb   CYX+CAD20+LERF+D2479
         fcb   72  CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   73  CLRS  - CLEAR SCREEN
         fcb   74  LERASE - ERASE LINE
         fcb   75  SCRLUP - SCROLL UP
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   0
*T21 Hewlett packard 2621
         fcb   CYX+CAD20+SSCD+LERF+D2479
         fcb   76 CURMV  - CURSOR MOVE (Macro 0)
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   77  CLRS  - CLEAR SCREEN
         fcb   29  LERASE - ERASE LINE
         fcb   78  SCRLUP - SCROLL UP
         fcb   79  SCRLDN  - SCROLL DOWN
         fcb   0
         fcb   0
         fcb   80  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   81  ATT1  - CHARACTER ATTRIBUTES
*T22 ADDS Viewpoint
         fcb   CYX+CAD20+LERF+D2479
         fcb   51 CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   25  CLRS  - CLEAR SCREEN
         fcb   29  LERASE - ERASE LINE
         fcb   53  SCRLUP - SCROLL UP
         fcb   0
         fcb   47  SCINIT  - INITIALIZE TERMINAL
         fcb   0
         fcb   45  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   46  ATT1  - CHARACTER ATTRIBUTES
*T23 Motorola Exorterm
         fcb   CYX+CAD20+SSCD+LERF+D2479
         fcb   64 CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   82  CLRS  - CLEAR SCREEN
         fcb   83  LERASE - ERASE LINE
         fcb   84  SCRLUP - SCROLL UP
         fcb   85  SCRLDN  - SCROLL DOWN
         fcb   0
         fcb   0
         fcb   0
         fcb   0
*T24 Visual tech 300
         fcb   CYX+SSCD+LERF+D2480
         fcb   93  CURSOR MOVE (macro)
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   130  CLRS  - CLEAR SCREEN
         fcb   96  LERASE - ERASE LINE
         fcb   127  SCRLUP - SCROLL UP
         fcb   128  SCRLDN  - SCROLL DOWN
         fcb   0
         fcb   0
         fcb   99 ATT0  - NO CHARACTER ATTRIBUTES
         fcb   129  ATT1  - CHARACTER ATTRIBUTES
*T25 TEC 70
         fcb   CYX+CAD20+SSCD+LERF+D2479
         fcb   91  CURMV  - CURSOR MOVE (Macro 1)
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   87  CLRS  - CLEAR SCREEN
         fcb   88  LERASE - ERASE LINE
         fcb   89  SCRLUP - SCROLL UP
         fcb   90  SCRLDN  - SCROLL DOWN
         fcb   0
         fcb   0
         fcb   92  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   6  ATT1  - CHARACTER ATTRIBUTES
*T26 VT100/ANSI Standard
         fcb   CYX+SSCD+LERF+D2479
         fcb   93  CURMV  - CURSOR MOVE (Macro 2)
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   95  CLRS  - CLEAR SCREEN
         fcb   96  LERASE - ERASE LINE
         fcb   97  SCRLUP - SCROLL UP
         fcb   98  SCRLDN  - SCROLL DOWN
         fcb   0
         fcb   0
         fcb   99 ATT0  - NO CHARACTER ATTRIBUTES
         fcb   100 ATT1  - CHARACTER ATTRIBUTES
*T27 GIMIX Video board
         fcb   CAD20+SSCD+LERF+D2479
         fcb   48  CURMV  - CURSOR MOVE  (Macro 3)
         fcb   49  CURON  - CURSOR ON
         fcb   50  CUROFF - CURSOR OFF
         fcb   101  BLINK  - BLINK CURSOR
         fcb   102  SOLID  - SOLID CURSOR
         fcb   25  CLRS  - CLEAR SCREEN
         fcb   103  LERASE - ERASE LINE
         fcb   104  SCRLUP - SCROLL UP
         fcb   105  SCRLDN  - SCROLL DOWN
         fcb   106  SCINIT  - INITIALIZE TERMINAL
         fcb   0
         fcb   107  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   108  ATT1  - CHARACTER ATTRIBUTES
*T28 Volker-Craig VC4404
         fcb   CYX+CAD20+LERF+D2479
         fcb   72  CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   73  CLRS  - CLEAR SCREEN
         fcb   74  LERASE - ERASE LINE
         fcb   75  SCRLUP - SCROLL UP
         fcb   0
         fcb   0
         fcb   0
         fcb   44  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   39  ATT1  - CHARACTER ATTRIBUTES
*T29 CYBERNEX XL 87
         fcb   CYX+CAD20+SSCD+LERF+D2479
         fcb   51 CURMV  - CURSOR MOVE
         fcb   134  CURON  - CURSOR ON
         fcb   135  CUROFF - CURSOR OFF
         fcb   0
         fcb   0
         fcb   64  CLRS  - CLEAR SCREEN
         fcb   29  LERASE - ERASE LINE
         fcb   53  SCRLUP - SCROLL UP
         fcb   136  SCRLDN  - SCROLL DOWN
         fcb   137  SCINIT  - INITIALIZE TERMINAL
         fcb   138  SSHUT  - SHUT DOWN SCREEN
         fcb   139  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   140  ATT1  - CHARACTER ATTRIBUTES
*T30 Perkin-Elmer 550 CRT
         fcb   CAD20+LERF+D2480
         fcb   111  CURMV  - CURSOR MOVE (macro 4)
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   29  CLRS  - CLEAR SCREEN
         fcb   112  LERASE - ERASE LINE
         fcb   113  SCRLUP - SCROLL UP
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   0
*T31 Lear-Siegler ADM-5
         fcb   CYX+CAD20+LERF+D2479
         fcb   1 CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   18  CLRS  - CLEAR SCREEN
         fcb   114  LERASE - ERASE LINE
         fcb   3  SCRLUP - SCROLL UP
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   0
*T32 Hazeltine ESPRIT
         fcb   SSCD+LERF+D2480
         fcb   121 CURMV  - CURSOR MOVE
         fcb   0
         fcb   0
         fcb   0
         fcb   0
         fcb   122  CLRS  - CLEAR SCREEN
         fcb   123  LERASE - ERASE LINE
         fcb   124  SCRLUP - SCROLL UP
         fcb   125  SCRLDN  - SCROLL DOWN
         fcb   126  SCINIT  - INITIALIZE TERMINAL
         fcb   0
         fcb   132  ATT0  - NO CHARACTER ATTRIBUTES
         fcb   133  ATT1  - CHARACTER ATTRIBUTES

* Cursor move routine
TEC70MV equ *
         pshs  b,a
         lda   #ESCAPE
         jsr   ,u
         lda   #$0E
         jsr   ,u
         lda   #$7F
         suba  ,s
         jsr   ,u
         lda   #$7F
         suba  $01,s
         jsr   ,u
         puls  pc,b,a

* Cursor move routine for HP2621 ($16E4)
HP2621MV equ *
         pshs  b,a
         lda   #ESCAPE
         jsr   ,u
         lda   #'&
         jsr   ,u
         lda   #'a
         jsr   ,u
         lda   ,s
         bsr   L1704
         lda   #'y
         jsr   ,u
         lda   $01,s
         bsr   L1704
         lda   #'C
         jsr   ,u
         puls  pc,b,a

* Print number in A as ascii
L1704    cmpa  #$0A
         bcs   L171B  Number less than 10
         clrb
L1709    suba  #$0A
         bcs   L1710
         incb
         bra   L1709
L1710    adda  #$0A
         exg   a,b
         adda  #$30
         lbsr  WrA2BUF
         tfr   b,a
L171B    adda  #$30
         lbra  WrA2BUF

* Cursor move sequence for VT100 ($1720)
VT100MV  pshs  b,a
         lda   #ESCAPE
         jsr   ,u
         lda   #'[
         jsr   ,u
         lda   ,s   Get row number
         inca
         bsr   L1704  Print as number
         lda   #';
         jsr   ,u
         lda   $01,s  Get column number
         inca
         bsr   L1704  Print as number
         lda   #'H
         jsr   ,u
         puls  pc,b,a

* Cursor move routine ($173E)
GIMIXMV  equ *
         pshs  b,a
         lda   #$0B
         jsr   ,u
         lda   $01,s
         jsr   ,u
         lda   #$0E
         jsr   ,u
         lda   ,s
         jsr   ,u
         puls  pc,b,a

*------------ TERMINAL SEQUENCES ---------------
*THESE ARE THE SEQUENCES THAT ARE NORMALLY SENT TO THE
*TERMINAL FOR THE VARIOUS FUNCTIONS.
*THEY ARE IN "SERIAL" ORDER AND ARE POINTED TO
*BY THE BYTES IN THE TERMINAL SEQUENCE POINTERS
*DEFINED PREVIOUSLY.
*THE SEQUENCES ALWAYS END WITH THE "N" BIT SET.

N EQU $80
M EQU $FF


* Location $1752
TRMSEQ EQU *
*0  - NO FUNCTION, DO NOT MODIFY THIS BYTE
         fcb   N

  ifeq PRODUCT-P.Dragon
***********************
* START GO51  SEQUENCES
*
*1  - CURSOR MOVE (GO51)
         fcb   ESCAPE,'A+N
*2, - CLEAR SCREEN (GO51)
         fcb   $0C+N
*3  - ERASE LINE (GO51)
         fcb   $0D    Go to beginning of line
         fcb   ESCAPE
         fcb   'B+N
*4  - SCROLL UP (GO51)
         fcb   ESCAPE
         fcb   'A
         fcb   0      column
         fcb   23     row
         fcb   $0A+N
*5  - SCROLL DOWN (GO51)
         fcb   $0B     Cursor home
         fcb   ESCAPE
         fcb   'D+N
*6  - NO CHARACTER ATTRIBUTES (GO51)
         fcb   ESCAPE
         fcb   'G+N
*7  - CHARACTER ATTRIBUTES (GO51)
         fcb   ESCAPE
         fcb   'F+N

* NOTE. The Go51 terminal description seems to have been binary patched into
* the application.
* What you see below are the original codes and are out of sync 
*?  - 
         fcb   $29+N
 else
**********************
* START ORIGINAL SEQUENCES
*
*1  - CURSOR MOVE (ADM-3A, SOROC IQ-120)
         fcb   ESCAPE,'=+N
*2, - CLEAR SCREEN (SOROC IQ-120)
         fcb   ESCAPE,'*+N
*3  - SCROLL UP (ADM-3A, SOROC IQ-120)
         fcb   ESCAPE
         fcb   '=
         fcb   23+$20     Line 24
         fcb   0+$20        Column 1
         fcb   $0A+N
*4  - 
         fcb   ESCAPE
         fcb   $27
         fcb   ESCAPE
         fcb   $28+N
*5  -
         fcb   ESCAPE
         fcb   $54+N
*6  -
         fcb   ESCAPE
         fcb   $28+N
*7 -
         fcb   ESCAPE
         fcb   $29+N
 endc
*8
         fcb   $1E
         fcb   ESCAPE
         fcb   'E+N
*9
         fcb   ESCAPE
         fcb   '.
         fcb   '2
         fcb   '6
         fcb   '0
         fcb   '1
         fcb   $0E+N
*10
         fcb   ESCAPE
         fcb   '.
         fcb   '2
         fcb   '6
         fcb   '0
         fcb   '0
         fcb   $0E+N
*11  Move XY on Hazeltine 1000 series
         fcb   $7E
         fcb   $11+N
*12  Clear screen on Hazeltine 1000 series
         fcb   $7E
         fcb   $1C+N
*13 Clear to end of line on Hazeltine 1000 series
         fcb   $7E
         fcb   $0F+N
*14
         fcb   $7E
         fcb   $11
         fcb   $00
         fcb   $17
         fcb   $0A+N
*15
         fcb   $7E
         fcb   $12
         fcb   $7E
         fcb   $1A+N
*16
         fcb   $7E
         fcb   $1F+N
*17
         fcb   $7E
         fcb   $19+N

*18 Clear screen ADM-3 and ADM-5
         fcb   $1A+N
*19
         fcb   ESCAPE
         fcb   $7E
         fcb   '3+N
*20
         fcb   ESCAPE
         fcb   $7E
         fcb   '1+N
*21
         fcb   $1E
         fcb   ESCAPE
         fcb   'I+N
*21
         fcb   ESCAPE
         fcb   'B+N
*23
         fcb   ESCAPE
         fcb   'C+N
*24
         fcb   $14+N
*25 Clear screen
         fcb   $0C+N
*26
         fcb   $1E+N
*27
         fcb   $14
         fcb   $17
         fcb   $00
         fcb   $0A+N
*28
         fcb   $1D
         fcb   ESCAPE
         fcb   'H+N
*29
         fcb   ESCAPE
         fcb   'K+N
*30
         fcb   ESCAPE
         fcb   '0
         fcb   '@+N
*31
         fcb   ESCAPE
         fcb   '0
         fcb   'A+N

*32 Cursor move for SWTPC CT-82
         fcb   $0B+N    Ctrl-K X,Y

*33  - CURSOR ON (CT-82)
         fcb   $1E,$05+N   Ctrl-^ ctrl-E
*34  - CURSOR OFF (CT-82)
         fcb   $1E,$15+N  Ctrl-^ ctrl-U
*35  - CURSOR BLINK (CT-82)
         fcb   $1E
         fcb   $03+N
*36  - non-blinking cursor
         fcb   $1E,$13+N   Ctrl-^ ctrl-S

*37  - CLEAR SCREEN (CT-82)
         fcb   $10,$16+N
*38  - ERASE LINE (CT-82)
         fcb   $06+N       Ctrl-F
*39  - SCROLL UP (CT-82)
         fcb   $0E+N       Ctrl-N
*40 - INITIALIZE SCREEN (CT-82)
         fcb   $1E,$01   Don't show control characters
         fcb   $1E,$13   Non-blinking cursor
         fcb   $1E,$04   Set block cursor
         fcb   $1E,$05   Display cursor
         fcb   $1E,$07   Ignore protection status
         fcb   $1E,$1A   Don't wrap on line overflow
         fcb   $1E,$0C   Enable upper and lower case
         fcb   $1E,$1D   Disable shift inversion
         fcb   $1C,$12+N  Set format 82x20 with standard character rom

*41  - SHUT DOWN SCREEN (CT-82)
         fcb   $1E,$0A+N

*42  - NO CHARACTER ATTRIBUTE
 FCB $1E,$6+N HIGH INTENSITY
*43  - CHARACTER ATTRIBUTE (CT-82)
 FCB $1E,$16+N LOW INTENSITY
*44
         fcb   $0F+N
*45
         fcb   $0F+N
*46
         fcb   $0E+N
*47
         fcb   ESCAPE
         fcb   '0
         fcb   'A+N

*48  GIMIX Video board CURSOR MOVE (macro)
         fcb   3,M
*49
         fcb   $03+N
*50
         fcb   $04+N

*51 CURSOR MOVE (VT52)
         fcb   ESCAPE
         fcb   'Y+N

*52 CLEAR TO END OF SCREEN (VT52)
         fcb   ESCAPE
         fcb   'H
         fcb   ESCAPE
         fcb   'J+N
*53 Scroll screen up for H19
         fcb   ESCAPE
         fcb   'Y
         fcb   $20+23
         fcb   $20
         fcb   $0A+N
*54 Scroll screen down for H19
         fcb   ESCAPE
         fcb   'H
         fcb   ESCAPE
         fcb   'I+N
*55 Cursor on for H19
         fcb   ESCAPE
         fcb   'y
         fcb   '5+N    Cursor on
*56 Cursor off for H19
         fcb   ESCAPE
         fcb   'x
         fcb   '5+N    Cursor off
*57 Cursor blink for H19
         fcb   ESCAPE
         fcb   'x
         fcb   '4+N    Block cursor
*58 Cursor solid for H19
         fcb   ESCAPE
         fcb   'y
         fcb   '4+N    underscore cursor
*59
         fcb   ESCAPE
         fcb   'x
         fcb   '4    Block cursor
         fcb   ESCAPE
         fcb   'w+N
*60
         fcb   ESCAPE
         fcb   'z+N   Reset all
*61 Insert mode attribute off (H19)
         fcb   ESCAPE
         fcb   'q+N
*62 Insert mode attribute on (H19)
         fcb   ESCAPE
         fcb   'p+N
*63
         fcb   $18+N
*64
         fcb   ESCAPE
         fcb   'E+N
*65
         fcb   ESCAPE
         fcb   'H
         fcb   ESCAPE
         fcb   $CC L
*66
         fcb   ESCAPE
         fcb   'd
         fcb   $C0 @
*67
         fcb   ESCAPE
         fcb   'd
         fcb   $C1 A
*68
         fcb   ESCAPE
         fcb   $C6 F
*69
         fcb   ESCAPE
         fcb   'F
         fcb   '7
         fcb   $20
         fcb   $0A+N
*70
         fcb   ESCAPE
         fcb   '[+N
*71
         fcb   ESCAPE
         fcb   ']+N
*72
         fcb   $10+N
*73
         fcb   $19
         fcb   $17+N
*74
         fcb   $16+N
*75
         fcb   $10
         fcb   '7
         fcb   $20
         fcb   $0A+N

*76 Hewlett packard 2621 CURSOR MOVE (macro)
         fcb   0,M
*77
         fcb   ESCAPE
         fcb   'H
         fcb   ESCAPE
         fcb   'J+N
*78
         fcb   ESCAPE
         fcb   '&
         fcb   'a
         fcb   '2
         fcb   '3
         fcb   'y
         fcb   '0
         fcb   'C
         fcb   $0A+N
*79
         fcb   ESCAPE
         fcb   '&
         fcb   'a
         fcb   '0
         fcb   'y
         fcb   '0
         fcb   'C
         fcb   ESCAPE
         fcb   'L+N
*80
         fcb   ESCAPE
         fcb   '&
         fcb   'd
         fcb   '@+N
*81
         fcb   ESCAPE
         fcb   '&
         fcb   'd
         fcb   'A+N
*82
         fcb   ESCAPE
         fcb   'X+N

*83 Motorola Exorterm line erase
         fcb   ESCAPE
         fcb   'U+N

*84 Motorola Exorterm scroll up
         fcb   ESCAPE
         fcb   'E
         fcb   '7
         fcb   $20
         fcb   $0A+N

*85 Motorola Exorterm scroll down
         fcb   ESCAPE
         fcb   'S
         fcb   ESCAPE
         fcb   'G
         fcb   ESCAPE
         fcb   'V
         fcb   ESCAPE
         fcb   'H
         fcb   ESCAPE
         fcb   'R+N
*86 (Unused) Same as CT-82 except for last sequence
         fcb   $1E,$01
         fcb   $1E,$13
         fcb   $1E,$04
         fcb   $1E,$05
         fcb   $1E,$07
         fcb   $1E,$1A
         fcb   $1E,$0C
         fcb   $1E,$1D
         fcb   $1C,$14+N  Set format 82x20 with alternate character PROM

*87 TEC 70 clear screen
         fcb   ESCAPE
         fcb   $06+N
*88 TEC 70 line erase
         fcb   ESCAPE
         fcb   $0B+N
*89 TEC 70 scroll up
         fcb   ESCAPE
         fcb   $0E
         fcb   'h
         fcb   $7F
         fcb   $0A+N
*90 TEC 70 scroll down
         fcb   ESCAPE
         fcb   $08
         fcb   ESCAPE
         fcb   $0C+N

*91 TEC 70 CURSOR MOVE (macro)
         fcb   1,M
*92 TEC 70 attributes
         fcb   ESCAPE
         fcb   $20+N

*93 VT100 CURSOR MOVE (macro)
         fcb   2,M

*94 Scroll up - INTERTUBE II
         fcb   ESCAPE
         fcb   '=
         fcb   $20+24
         fcb   $20
         fcb   $0A+N

*95  VT100  Clear screen
         fcb   ESCAPE
         fcb   '[
         fcb   'H
         fcb   ESCAPE
         fcb   '[
         fcb   '2
         fcb   'J+N

*96 VT100 Clear entire line
         fcb   $0D
         fcb   ESCAPE
         fcb   '[
         fcb   '2
         fcb   'K+N
*97
         fcb   ESCAPE
         fcb   '[
         fcb   'S+N
*98
         fcb   ESCAPE
         fcb   '[
         fcb   'T+N
*99 VT100 Turn off character attributes
         fcb   ESCAPE
         fcb   '[
         fcb   '0
         fcb   'm+N
*100 VT100 Turn low intensity mode on
         fcb   ESCAPE
         fcb   '[
         fcb   '2
         fcb   'm+N
*101
         fcb   $05+N
*102
         fcb   $06+N
*103
         fcb   $09+N
*104
         fcb   $10+N
*105
         fcb   $0F+N
*106
         fcb   $15
         fcb   $00
         fcb   $00
         fcb   'P
         fcb   $18
         fcb   $01+N
*107
         fcb   $01+N
*108
         fcb   $02+N
*109
         fcb   ESCAPE
         fcb   $7E
         fcb   '3+N
*110
         fcb   ESCAPE
         fcb   $7E
         fcb   '2+N

*111 Perkin-Elmer 550 CURSOR MOVE (macro)
         fcb   4,M
*112
         fcb   ESCAPE
         fcb   'I+N
*113
         fcb   ESCAPE
         fcb   'X
         fcb   '7
         fcb   ESCAPE
         fcb   'B+N
*114
         fcb   ESCAPE
         fcb   'T+N
*115
         fcb   $17+N
*116
         fcb   $01
         fcb   $00
         fcb   $17
         fcb   $0A+N
*117 (macro)
         fcb   7,M
*118 (macro)
         fcb   5,M
*119 (macro)
         fcb   6,M
*120 (macro)
         fcb   8,M
*121
         fcb   ESCAPE
         fcb   $11+N
*122
         fcb   ESCAPE
         fcb   $1C+N
*123
         fcb   $0D
         fcb   ESCAPE
         fcb   $0F+N
*124
         fcb   ESCAPE
         fcb   $11
         fcb   $00
         fcb   $17
         fcb   $0A+N
*125
         fcb   ESCAPE
         fcb   $12
         fcb   ESCAPE
         fcb   $1A+N
*126
         fcb   ESCAPE
         fcb   $06
         fcb   ESCAPE
         fcb   $24 $
         fcb   ESCAPE
         fcb   $1F+N
*127
         fcb   ESCAPE
         fcb   '[
         fcb   $18
         fcb   'H
         fcb   ESCAPE
         fcb   'D+N
*128 VT100 Move cursor to upper left corner
         fcb   ESCAPE
         fcb   '[
         fcb   'H
         fcb   ESCAPE
         fcb   'M+N

*129  Set attributes for 
         fcb   ESCAPE
         fcb   '[
         fcb   '7
         fcb   'm+N

*130 VT100 Clear entire screen
         fcb   ESCAPE
         fcb   '[
         fcb   '2
         fcb   'J+N
*131
         fcb   ESCAPE
         fcb   '0
         fcb   'P+N
*132
         fcb   ESCAPE
         fcb   $1F+N
*133
         fcb   ESCAPE
         fcb   $19+N
*134
         fcb   ESCAPE
         fcb   '#+N

*135 Cursor off for CYBERNEX XL 87
         fcb   ESCAPE
         fcb   '$+N
*136 Scroll down for CYBERNEX XL 87
         fcb   ESCAPE
         fcb   'H
         fcb   ESCAPE
         fcb   'A+N
*137 Initialize terminal for CYBERNEX XL 87
         fcb   $04
         fcb   ESCAPE
         fcb   $23 #
         fcb   ESCAPE
         fcb   $3E >
         fcb   ESCAPE
         fcb   'M
         fcb   ESCAPE
         fcb   'E
         fcb   ESCAPE
         fcb   'Q
         fcb   ESCAPE
         fcb   'U
         fcb   ESCAPE
         fcb   '[
         fcb   ESCAPE
         fcb   $5E ^
         fcb   ESCAPE
         fcb   'b
         fcb   ESCAPE
         fcb   'e
         fcb   ESCAPE
         fcb   'g
         fcb   ESCAPE
         fcb   'i
         fcb   ESCAPE
         fcb   'n+N
*138 Shutdown for CYBERNEX XL 87
         fcb   $1E
         fcb   $0A+N
*139 No attributes for CYBERNEX XL 87
         fcb   ESCAPE
         fcb   'e
         fcb   ESCAPE
         fcb   'g
         fcb   ESCAPE
         fcb   'i+N
*140 Set attributte for CYBERNEX XL 87
         fcb   ESCAPE
         fcb   'd+N

TRMEND   equ *

* Print character in A repeatedly B times
OUTREPT  tst   <u0042
         beq   L192C
         clr   <u0042
         pshs  b
         ldb   #$18
L1928    bsr   L198F
         puls  b
L192C    pshs  b
         ldb   <u0041 Curr column
         cmpb  <LASTCOL Max column
         puls  b
         bhi   L193B
         inc   <u0041 Curr column
         lbra  WrA2BUF
L193B    rts

L193C    tst   <u0042
         bne   L192C
         sta   <u0042
         pshs  b
         ldb   #$1A
         bra   L1928

*
* Write string in X on line A column B
*
GOROWCOL std   <SCRROW
         pshs  x
         ldb   #$02
         bsr   L198F
         bcs   L1976
         ldx   <u003C
         ldb   ,x
         bitb  #CYX   On = row (Y) first
         beq   L1978
         lda   <SCRROW
         bitb  #CAD20   On = add 32 to coordinate
         beq   L1962
         adda  #$20
L1962    lbsr  WrA2BUF
         lda   <u0041 Curr column
         ldx   <u003C
         ldb   ,x
         bitb  #CAD20   On = add 32 to coordinate
         beq   L1971
L196F    adda  #$20
L1971    lbsr  WrA2BUF
         ldd   <SCRROW
L1976    puls  pc,x

L1978    lda   <u0041 Curr column
         bitb  #CAD20
         beq   L1980
         adda  #$20
L1980    lbsr  WrA2BUF
         lda   <SCRROW
         ldx   <u003C
         ldb   ,x
         bitb  #CAD20
         beq   L1971
         bra   L196F

L198F    pshs  x,b,a
         ldx   <u003C
         ldx   b,x
         beq   L19A8
         lda   $01,x
         cmpa  #M  Is the terminal sequence a Macro?
         beq   L19AC
L199D    lda   ,x+
         pshs  a
         lbsr  WrA2BUF
         lda   ,s+
         bpl   L199D
L19A8    andcc #^Carry
L19AA    puls  pc,x,b,a


* Call macro in TRMBEG table
L19AC    ldb   ,x
         lslb
         leax  >TRMBEG,pcr
         ldd   b,x
         leax  >0,pcr
         leax  d,x
         ldd   <SCRROW
         pshs  u
         leau  >WrA2BUF,pcr
         jsr   ,x
         puls  u
         orcc  #Carry
         bra   L19AA

L19CB    pshs  b
         ldb   #$06
         bsr   L198F
         puls  pc,b

L19D3    pshs  b
         ldb   #$04
         bsr   L198F
         puls  pc,b

L19DB    pshs  x,b
         clr   <SCRROW
         clr   <u0041 Curr column
         ldb   #$0C
         bsr   L198F
         lbsr  L0109
         ldx   #$1F40
L19EB    leax  -$01,x
         bne   L19EB
         puls  pc,x,b
L19F1    pshs  b,a
         ldb   #$10
         bsr   L198F
         ldd   <SCRROW
         deca
         lbsr  GOROWCOL
         puls  pc,b,a

L19FF    pshs  b,a
         ldb   #$12
         bsr   L198F
         ldd   <SCRROW
         inca
         lbsr  GOROWCOL
         puls  pc,b,a

L1A0D    pshs  x,b
         clr   <SCRROW
         clr   <u0041 Curr column
         ldb   #$14
         lbsr  L198F
         lbsr  L0109
         ldx   #10000
L1A1E    leax  -$01,x
         bne   L1A1E
         puls  pc,x,b

L1A24    pshs  b
         ldb   #$16
         lbsr  L198F
         puls  pc,b

L1A2D    pshs  b
         ldb   #$0A
         lbsr  L198F
         puls  pc,b

L1A36    pshs  b
         ldb   #$08
         lbsr  L198F
         puls  pc,b

L1A3F    pshs  x,b,a
         ldd   <SCRROW
         pshs  b,a
         ldd   $02,s
         clrb
         lbsr  GOROWCOL
         ldx   <u003C
         lda   ,x
         bita  #$10
         beq   L1A5F
         ldb   #$0E
         lbsr  L198F
L1A58    puls  b,a
         lbsr  GOROWCOL
         puls  pc,x,b,a

L1A5F    ldb   <LASTCOL Max column
         lda   #C$SPAC
L1A63    lbsr  WrA2BUF
         decb
         bpl   L1A63
         bra   L1A58

start    equ   *
         lbsr  L0072
         tfr   a,dp
         tfr   d,u
         tfr   d,x
         clra
* Clear page
L1A75    clr   ,u+
         adda  #$01
         bcc   L1A75

         stx   <u007A
         leay  1,y
         sty   <u005E
         sty   <u0063
         ldx   <u007A
         leay  >$0100,x
         leax  >$017D,y
         stx   <u0020
         leax  >$01B4,y
         stx   <u0022
         leax  >$01EB,y
         stx   <u0024
         leax  >$0222,y
         stx   <u0026
         leax  >$0359,y
         stx   <u0028
         leax  >$04B7,y
         stx   <u002A
         leax  >$0615,y
         stx   <u002C
         leax  >$0615,y
         stx   <u002E
         leax  >$062B,y
         stx   <u0030
         leax  >$0662,y
         stx   <u0032
         leax  ,y
         stx   <u001C
         leax  >$015E,y
         stx   <u001E
         leax  >$0A81,y
         stx   <u0034
         leax  >$0259,y
         stx   <u0036
         leax  >$015F,y
         stx   <u003C    String to reverse
         leax  >$088D,y
         stx   <u003A
         leax  >$0699,y
         stx   <u0038
         leax  >$13EC,y
         stx   <u007C
         leax  ,x
         stx   <u0072
         lbsr  L0077
         lds   <u001E
         lda   >L000E,pcr
         sta   <u0044 Active printer type
         lda   >L000D,pcr  Driver select
         sta   <u0045
         lda   >MAXPAGES,pcr
         sta   <u0062    Max pages
         lbsr  L3A44
         lbsr  TXTEND
         lbcs  L3AA3 branch to illegal printer or terminal
         lbsr  L1A0D
         lda   <u0044 Active printer type
         bne   L1B28 branch if not type 0
         lda   #$28
         ldb   #$78
         bra   L1B47

L1B28    cmpa  #10 Printer type 10
         bne   L1B32 branch if not type 10
         lda   #$0F
         ldb   #$78
         bra   L1B47
L1B32    cmpa  #20
         bne   L1B3C branch if not type 20
         lda   #$06
         ldb   #$96
         bra   L1B47
L1B3C    cmpa  #30 Printer type 30
         beq   L1B47 branch if not type 30
         cmpa  #40
         beq   L1B47
         lbra  L3AA3 branch to illegal printer or terminal
L1B47    sta   <u00E3
         stb   <u00E4
         ldx   <u0072
         lda   <u0062    Max pages
         ldb   #$37
         mul
         leax  d,x
         stx   <u005C
         stx   <u006D
         ldd   #$FFFF
         std   <u007E
         sta   <u006F
         inc   <u006A
         ldx   <u002A
         stx   <u0084
         lda   <LASTROW
         inca
         sta   <u0060
         ldx   <u0036
         clra
         ldb   #$0A
L1B6F    stb   ,x+
         sta   ,x+
         inca
         bpl   L1B6F
         ldx   <u002E
         ldb   #$16
         lda   #$08
L1B7C    sta   ,x+
         decb
         beq   L1B85
         adda  #$08
         bra   L1B7C
L1B85    ldy   <u0072
         ldb   #$37
L1B8A    clr   ,y+
         decb
         bne   L1B8A
         ldy   <u0072
         ldd   <u005C
         std   $04,y
         ldx   #$0000
         stx   ,y
         ldb   <LASTCOL Max column
         leax  b,x
         stx   $02,y
         ldb   >STLM,pcr
         stb   <$17,y
         ldb   >STLL,pcr
         bne   L1BB0
         ldb   <LASTCOL Max column
L1BB0    stb   <$1B,y
         ldb   >STJU,pcr
         stb   <$25,y
         ldb   >STPL,pcr
         stb   <$2A,y
         incb
         stb   <$1A,y
         ldb   >STMS,pcr
         stb   <$23,y
         ldb   >STHFLL,pcr
         bne   L1BD4
         ldb   <LASTCOL Max column
L1BD4    stb   <$1F,y
         com   $08,y
         ldb   >STCS,pcr
         stb   <$2C,y
         ldb   >STVS,pcr
         stb   <$2D,y
         ldb   >STBFS,pcr
         stb   <$2E,y
         ldb   #$01
         ldb   >STPADC,pcr
         stb   <$31,y
         ldb   >STMMC,pcr
         stb   <$32,y
         ldb   >STPC,pcr
         stb   <$30,y
         stb   <$12,y
         tfr   y,x
         ldy   <u0022
         ldd   #$0037
         lbsr  L45F5
         ldu   <u0022
         ldx   <u005E
         leax  -$01,x
         stx   u0006,u
         stx   u0004,u
         lda   #$F0
         sta   ,x
         lbsr  L23D5
         lbra  L542D
L1C27    lbsr  L0170
         beq   L1C38
L1C2C    lbsr  L0153   Read keyboard
         anda  #$7F
         tst   <u00A0
         beq   L1C37
         bsr   L1C44
L1C37    rts
L1C38    lbsr  L1C4F
         bcs   L1C27
         lbsr  L3183
         bcs   L1C27
         bra   L1C2C
L1C44    cmpa  #'a
         bcs   L1C4E
         cmpa  #'z
         bhi   L1C4E
         suba  #$20
L1C4E    rts

L1C4F    pshs  u,y,x,b,a
         tst   <u0093
         bne   L1C94
         tst   <u0086
         bne   L1C5D
         andcc #^Carry
         bra   L1C92
L1C5D    ldu   <u0026
         ldx   <u0082
         ldd   ,u
         std   ,x
         ldd   u0004,u
         std   $02,x
         lda   u0008,u
         sta   $04,x
         leax  $05,x
         stx   <u0082
         ldx   <u002A
         cmpx  <u0082
         beq   L1C8E
L1C77    lbsr  L23D5
         tst   $0E,u
         beq   L1C8E
         tst   u0008,u
         beq   L1C8A
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L1C77
L1C8A    orcc  #Carry
         bra   L1C92
L1C8E    clr   <u0086
         orcc  #Carry
L1C92    puls  pc,u,y,x,b,a

L1C94    clr   <u0093
         lda   #$01
         sta   <u0086
         ldd   <u0080
         cmpd  <u0050
         beq   L1CC0
         subd  #$0001
         std   <u007E
         subd  <u0050
         lda   #$37
         mul
         ldx   <u0072
         leax  d,x
         ldy   <u0026
         ldd   #$0037
         lbsr  L45F5
         ldx   <u0028
         stx   <u0082
         orcc  #Carry
         bra   L1C92
L1CC0    clr   <u0086
         ldd   #$FFFF
         std   <u007E
         andcc #^Carry
         lbra  L1C92
L1CCC    lbsr  L19DB
         lbsr  L1A24
         lbra  L0412
L1CD5    sta   <u00CD
         tst   <u004B
         lbne  L1E0F
         tst   <u0099
         bne   L1CE7
         lda   #$FF
         sta   <u00CE
         clr   <u00D0
L1CE7    cmpu  <u0022
         bne   L1D17
         lda   <u00CD
         beq   L1D17
         cmpa  #$A0
         beq   L1D17
         tst   <u00CF
         bne   L1CFF
         cmpy  u0006,u
         bne   L1D17
         bra   L1D13
L1CFF    lda   <u0099
         cmpa  <u0071
         bhi   L1D0A
         sty   u0006,u
         bra   L1D13
L1D0A    lda   <u00CE
         cmpa  #$FF
         bne   L1D17
         sty   u0006,u
L1D13    lda   <u0099
         sta   <u00CE
L1D17    lda   <u00CD
         beq   L1D62
         cmpa  #$F0
         beq   L1D62
         lda   <u0099
         cmpa  <u0098
         bcs   L1D62
         tst   <u0041 Curr column
         bne   L1D3E
         tst   <u0098
         beq   L1D3E
         lda   #$01
         sta   <u00D0
         tst   <u0074
         beq   L1D3E
         lda   >LARCHR,pcr
         lbsr  OUTREPT
         bra   L1D62
L1D3E    lda   <u0099
         suba  <u0098
         cmpa  <LASTCOL Max column
         bcs   L1D5B
         bhi   L1D62
         tst   <u0074
         beq   L1D53
         lda   >RARCHR,pcr
         lbsr  OUTREPT
L1D53    lda   <u00D0
         ora   #$50
         sta   <u00D0
         bra   L1D62
L1D5B    tst   <u0074
         beq   L1D62
         lbsr  L2181
L1D62    lda   <u00CD
         beq   L1D6D
         cmpa  #$F0
         beq   L1D6D
         inc   <u0099
         rts
L1D6D    lda   <u0099
         suba  <u0098
         bcs   L1D94
         cmpa  <LASTCOL Max column
         bhi   L1DB7
         beq   L1D98
         lda   #C$SPAC
         tst   <u0041 Curr column
         bne   L1D8D
         tst   <u0098
         beq   L1D8D
         lda   #$01
         andb  <u00D0
         stb   <u00D0
         lda   >LARCHR,pcr
L1D8D    tst   <u0074
         beq   L1D94
         lbsr  OUTREPT
L1D94    inc   <u0099
         bra   L1D6D
L1D98    tst   <u00D0
         bmi   L1DB7
         tst   <u0074
         beq   L1DB7
         tst   <u00CD
         beq   L1DB2
         tst   u0008,u
         beq   L1DAC
         lda   #'-
         bra   L1DB4

L1DAC    lda   >CRCHR,pcr  character |
         bra   L1DB4

L1DB2    lda   #C$SPAC
L1DB4    lbsr  OUTREPT
L1DB7    cmpu  <u0022
         bne   L1E0E
         clr   <u0097
         ldd   u0006,u
         cmpd  ,u
         bcs   L1E0E
         cmpd  u0002,u
         bcc   L1E0E
         lda   <u00CD
         cmpa  #$F0
         bne   L1DD9
         cmpy  u0006,u
         bne   L1DD9
         ldb   <LASTCOL Max column
         bra   L1E09
L1DD9    ldb   <u00CE
         subb  <u0098
         bcs   L1E00
         cmpb  <LASTCOL Max column
         bhi   L1E05
         tst   <u00D0
         beq   L1E09
         tstb
         bne   L1DF4
         lda   <u00D0
         bita  #$01
         beq   L1E09
         inc   <u0097
         bra   L1E09
L1DF4    cmpb  <LASTCOL Max column
         bne   L1E09
         tst   <u00D0
         bpl   L1E09
         inc   <u0097
         bra   L1E09
L1E00    inc   <u0097
         clrb
         bra   L1E09
L1E05    inc   <u0097
         ldb   <LASTCOL Max column
L1E09    lda   <SCRROW
         lbsr  GOROWCOL
L1E0E    rts
L1E0F    tsta
         beq   L1E7D
         cmpa  #$F0
         beq   L1E7D
         cmpa  #$A0
         beq   L1E3A
         lda   ,y
         cmpa  <u0030,u
         lbeq  L20B8
         tsta
         bpl   L1E3A
         cmpa  #$F1
         bne   L1E34
         leax  $01,y
         cmpx  u0002,u
         bne   L1E7D
         lda   #$2D
         bra   L1E3A
L1E34    bsr   L1E7E
         lda   $01,y
         bra   L1E3C
L1E3A    clr   <u00D7
L1E3C    cmpa  >PNCHR,pcr character #
         bne   L1E45
         lbsr  L21C1
L1E45    anda  #$7F
         sta   <u00D5
         tst   <u00DC
         beq   L1E57
         dec   <u00DC
         bne   L1E57
         tst   <u00DB
         beq   L1E57
         dec   <u00DB
L1E57    lda   <u0044 Active printer type
         cmpa  #20
         beq   L1E6C
         lda   <u002C,u
         ldb   <u00E4
         lbsr  L323C
         adda  <u00DB
         sta   <u00D6
         lbra  L1EC3
L1E6C    lda   <u00D5
         cmpa  #$20
         lbne  L1EC3
         lda   #$07
         adda  <u00DB
         sta   <u00D6
         lbra  L1EC3
L1E7D    rts
L1E7E    ldb   ,y
         andb  #$7F
         cmpb  #$5F
         beq   L1EBB
         cmpb  #$7E
         beq   L1EBF
         decb
         stb   <u0058
         bitb  #$08
         lbne  L1EB8
         andb  #$70
         cmpb  #$30
         bne   L1E9F
         ldb   #$0F
         andb  <u0058
         bra   L1EB5
L1E9F    cmpb  #$40
         bne   L1EAB
         ldb   #$0F
         andb  <u0058
         addb  #$10
         bra   L1EB5
L1EAB    cmpb  #$60
         bne   L1EB8
         ldb   #$0F
         andb  <u0058
         addb  #$20
L1EB5    stb   <u00D7
         rts
L1EB8    clrb
         bra   L1EB5
L1EBB    ldb   #$01
         bra   L1EB5
L1EBF    ldb   #$02
         bra   L1EB5
L1EC3    lda   <u00D5
         cmpa  <u0031,u
         bne   L1ED3
         tst   <u0031,u
         beq   L1ED3
         lda   #$20
         sta   <u00D5
L1ED3    tst   <u002F,u
         beq   L1EE1
         lda   <u0044 Active printer type
         cmpa  #$14
         beq   L1EE1
         lbsr  L2054
L1EE1    clr   <u00DF
         lda   <u00D6
         cmpa  <u00E3
         bls   L1EEF
         suba  <u00E3
         sta   <u00DF
         lda   <u00E3
L1EEF    lbsr  L3F1D
         ldb   <u00D7
         lda   <u0044 Active printer type
         cmpa  #$1E
         bcc   L1F21
         bitb  #$20
         beq   L1F01
         lbsr  L3F8B
L1F01    bitb  #$10
         beq   L1F08
         lbsr  L3F5B
L1F08    bitb  #$04
         beq   L1F21
         lda   <u0044 Active printer type
         cmpa  #20
         beq   L1F21
         lbsr  L3F5B
         lbsr  L3F5B
         lbsr  L1FBF
         lbsr  L3F8B
         lbsr  L3F8B
L1F21    bitb  #$01
         beq   L1F3D
         lda   <u0044 Active printer type
         cmpa  #$1F
         bcc   L1F4C
         cmpa  #20
         beq   L1F34
         lbsr  L1FBF
         bra   L1F4C
L1F34    lda   #$0F
         sta   <u00E2
         lbsr  L3F53
         bra   L1F4C
L1F3D    lda   <u0044 Active printer type
         cmpa  #20
         bne   L1F4C
         tst   <u00E2
         beq   L1F4C
         lda   #$0E
         lbsr  L3F53
L1F4C    lda   <u0044 Active printer type
         cmpa  #20
         beq   L1F62
         bitb  #$02
         beq   L1F5B
         lbsr  L2004
         bra   L1F97
L1F5B    lda   <u00D5
         lbsr  L3F53
         bra   L1F97
L1F62    clr   <u00DF
         tst   <u002F,u
         beq   L1F5B
         lda   <u00D5
         cmpa  #$20
         beq   L1F76
         lbsr  L3F53
         lda   <u00DB
         sta   <u00D6
L1F76    lda   <u00D6
         cmpa  #$06
         bls   L1F84
         suba  #$06
         sta   <u00D6
         lda   #$06
         bra   L1F86
L1F84    clr   <u00D6
L1F86    tsta
         beq   L1F97
         pshs  a
         lda   #$1B
         lbsr  L3F53
         puls  a
         lbsr  L3F53
         bra   L1F76
L1F97    lda   <u0044 Active printer type
         cmpa  #20
         bhi   L1FAB
         bitb  #$20
         beq   L1FA4
         lbsr  L3F5B
L1FA4    bitb  #$10
         beq   L1FAB
         lbsr  L3F8B
L1FAB    tst   <u00DF
         bne   L1FB2
         andcc #^Carry
         rts
L1FB2    clr   <u00D7
         lda   #$20
         sta   <u00D5
         lda   <u00DF
         sta   <u00D6
         lbra  L1EE1
L1FBF    tst   <u002F,u
         bne   L1FCB
         lda   #$5F
         lbsr  L3F53
         bra   L1FFF
L1FCB    ldx   <u0036
         leax  >$00BE,x
         lda   $01,x
         cmpa  #$20
         bcc   L1FED
         adda  #$40
         tst   <u00D4
         bne   L1FFC
         pshs  a
         lda   #$0E
         lbsr  L3F53
         puls  a
         lbsr  L3F53
         lda   #$0F
         bra   L1FFC
L1FED    tst   <u00D4
         beq   L1FFC
         pshs  a
         lda   #$0F
         lbsr  L3F53
         puls  a
         lda   #$0E
L1FFC    lbsr  L3F53
L1FFF    lda   #$08
         lbra  L3F53
L2004    pshs  b
         lda   <u0044 Active printer type
         cmpa  #$1E
         bls   L2010
         lda   <u00D5
         bra   L2037
L2010    cmpa  #10
         bhi   L203C
         lda   #$01
         lbsr  L3FB1
         ldb   <u002E,u
         asrb
L201D    lda   <u00D5
         lbsr  L3F53
         lbsr  L3F53
         lda   #$08
         lbsr  L3F53
         lbsr  L3F53
         decb
         bne   L201D
         lda   <u0047
         lbsr  L3FB1
         lda   #$20
L2037    lbsr  L3F53
L203A    puls  pc,b
L203C    ldb   <u002E,u
L203F    lda   <u00D5
         lbsr  L3F53
         decb
         beq   L203A
         lda   #$08
         lbsr  L3F53
         bra   L203F
L204E    lda   #$08
         lbsr  L3F53
         rts
L2054    pshs  x,b,a
         lda   <u00D5
         beq   L206F
         anda  #$7F
         ldx   <u0036
         lsla
         tfr   a,b
         abx
         ldb   ,x
         lda   <u00D9
         stb   <u00D9
         adda  <u00D9
         asra
         adda  <u00DB
         sta   <u00D6
L206F    ldb   <u00D8
         ldx   <u0036
         lslb
         abx
         lda   $01,x
         cmpa  #$20
         bcc   L208E
         adda  #$40
         tst   <u00D4
         bne   L209A
         pshs  a
         lda   #$0E
         sta   <u00D4
L2087    lbsr  L3F53
         puls  a
         bra   L209A
L208E    tst   <u00D4
         beq   L209A
         pshs  a
         clr   <u00D4
         lda   #$0F
         bra   L2087
L209A    ldb   <u00D5
         sta   <u00D5
         stb   <u00D8
         ldb   <u00D7
         lda   <u00DA
         stb   <u00DA
         sta   <u00D7
         tst   <u00D8
         beq   L20AE
L20AC    puls  pc,x,b,a
L20AE    lda   #$20
         sta   <u00D8
         clr   <u00D9
         clr   <u00DA
         bra   L20AC
L20B8    pshs  x
         sty   <u0054
         leax  $01,y
L20BF    lda   ,x+
         bmi   L20CC
         cmpa  <u0030,u
         beq   L20D0
         cmpx  u0002,u
         bcs   L20BF
L20CC    tfr   x,y
         puls  pc,x
L20D0    ldx   <u0054
L20D2    leax  $01,x
L20D4    lda   ,x
         cmpa  <u0030,u
         beq   L20CC
         cmpa  #$20
         beq   L20D2
         cmpa  #$2C
         beq   L20D2
         lbsr  L1C44
         cmpa  >PSCHR,pcr
         beq   L2108
         cmpa  >PTCHR,pcr
         beq   L212E
         cmpa  >PBCHR,pcr
         beq   L2166
         lbsr  L4FFD
         bcs   L20CC
         pshs  x
         lbsr  L3F53
         puls  x
         leax  -$01,x
         bra   L20D4
L2108    lda   $01,x
         cmpa  #$20
         beq   L2119
         cmpa  #$2C
         beq   L2119
         cmpa  <u0030,u
         lbne  L20CC
L2119    pshs  x
         lda   #$03
         lbsr  L1A3F
         ldx   >PSQS1,pcr
         lbsr  WRLINE3
         lbsr  L1C27
         puls  x
         bra   L20D2
L212E    leax  $01,x
         lbsr  L4A0C
         bcs   L20CC
         pshs  x
         pshs  b
         clr   <u00D7
         clr   <u00D6
         lda   #$20
         sta   <u00D5
         lbsr  L1EC3
         lda   #$0D
         lbsr  L3F53
         ldy   <u001C
         lda   #$20
         sta   ,y
L2150    tst   ,s
         beq   L215D
         lda   #$20
         lbsr  L1E0F
         dec   ,s
         bra   L2150
L215D    puls  b
         puls  x
         leax  -$01,x
         lbra  L20D4
L2166    lda   $01,x
         cmpa  #$20
         beq   L2177
         cmpa  #$2C
         beq   L2177
         cmpa  <u0030,u
         lbne  L20CC
L2177    pshs  x
         lbsr  L204E
         puls  x
         lbra  L20D2
L2181    lda   <u00CD
         cmpa  #$A0
         beq   L21BE
         lda   ,y
         bpl   L21B6
         cmpa  #$F0
         bne   L2195
         lda   >CRCHR,pcr  character |
         bra   L21B6

L2195    cmpa  #$F1
         bne   L219D
         lda   #$2D
         bra   L21B6
L219D    tst   <u0070
         beq   L21A9
         cmpa  #$B2
         bne   L21B3
         lda   #$5F
         bra   L21B3
L21A9    lda   $01,y
         cmpa  >PNCHR,pcr character #
         bne   L21B3
         bsr   L21C1
L21B3    lbra  L193C

L21B6    cmpa  >PNCHR,pcr character #
         bne   L21BE
         bsr   L21C1
L21BE    lbra  OUTREPT
L21C1    tst   u0008,u
         bne   L21C6
         rts
L21C6    pshs  x,b
         tst   <u00A5
         beq   L21DD
         ldb   <u00A4
         incb
         ldx   <u0034
         lda   b,x
         beq   L21D9
         stb   <u00A4
         puls  pc,x,b
L21D9    lda   #$20
         puls  pc,x,b

L21DD    ldd   <$11,u
         lbsr  L2CAE
         ldx   <u0034
         clrb
L21E6    lda   b,x
         cmpa  #$20
         bne   L21EF
         incb
         bra   L21E6
L21EF    stb   <u00A4
         inc   <u00A5
         puls  pc,x,b
L21F5    ldx   ,u
         lbeq  L2293
         clr   <u0033,u
         lda   #$05
         sta   <u00EA
         lbsr  L3717
         tst   <u002F,u
         lbne  L22F0
         incb
L220D    decb
         beq   L2256
         cmpx  <u0063
         beq   L228B
         lda   ,x+
         bmi   L2294
         cmpa  <u0030,u
         bne   L220D
         incb
         clr   <u00E0
L2220    inc   <u00E0
         lda   #$18
         cmpa  <u00E0
         bcs   L224C
         lda   ,x+
         bmi   L228B
         lbsr  L1C44
         cmpa  >PBCHR,pcr
         beq   L22A9
         cmpa  >PTCHR,pcr
         lbeq  L22CF
         cmpa  <u0030,u
         bne   L2220
         lda   <u0033,u
         adda  <u00E0
         sta   <u0033,u
         bra   L220D
L224C    lda   <u0033,u
         adda  <u00E0
         sta   <u0033,u
         bra   L228B
L2256    stx   u0002,u
         tst   u0008,u
         bne   L225E
         stx   u0004,u
L225E    lda   ,x
         cmpa  #$20
         bne   L226C
         leax  $01,x
         dec   <u00EA
         beq   L228B
         bra   L225E
L226C    cmpa  #$F0
         beq   L2289
L2270    lda   ,-x
         cmpa  #$20
         beq   L2289
         cmpa  #$F1
         beq   L2289
         cmpa  #$2D
         beq   L2289
         cmpa  <u0030,u
         beq   L229C
         cmpx  ,u
         bne   L2270
         bra   L2293
L2289    leax  $01,x
L228B    stx   u0002,u
         tst   u0008,u
         bne   L2293
         stx   u0004,u
L2293    rts
L2294    cmpa  #$F0
         beq   L228B
         incb
         lbra  L220D
L229C    lda   ,-x
         cmpa  <u0030,u
         beq   L2270
         cmpx  ,u
         bhi   L229C
         bra   L2293
L22A9    lda   -$02,x
         cmpa  #$20
         beq   L22BA
         cmpa  #$2C
         beq   L22BA
         cmpa  <u0030,u
         lbne  L2220
L22BA    lda   ,x
         cmpa  #$20
         beq   L22CB
         cmpa  #$2C
         beq   L22CB
         cmpa  <u0030,u
         lbne  L2220
L22CB    incb
         lbra  L2220
L22CF    pshs  x,b,a
         lbsr  L4A0C
         bcs   L22EB
         stb   <u0059
         ldb   <u0095
         subb  <u0059
         bcs   L22EB
         stb   <u0059
         cmpb  #$06
         bcs   L22EB
         puls  x,b,a
         ldb   <u0059
         lbra  L2220
L22EB    puls  x,b,a
         lbra  L2220
L22F0    ldy   <u0036
         lda   <u002C,u
         ldb   <u00E4
         lbsr  L323C
         ldb   <u0095
         mul
         std   <u005A
L2300    cmpx  <u0063
         lbeq  L2385
         ldb   ,x+
         lbmi  L238E
         cmpb  <u0030,u
         beq   L2324
         lslb
         clra
         ldb   d,y
         stb   <u00D9
         clra
         pshs  b,a
         ldd   <u005A
         subd  ,s++
         std   <u005A
         bcc   L2300
         bra   L2353
L2324    clr   <u00E0
L2326    inc   <u00E0
         lda   #$18
         cmpa  <u00E0
         bcs   L2349
         lda   ,x+
         bmi   L2385
         cmpa  >PBCHR,pcr
         lbeq  L23AB
         cmpa  <u0030,u
         bne   L2326
         lda   <u0033,u
         adda  <u00E0
         sta   <u0033,u
         bra   L2300
L2349    lda   <u0033,u
         adda  <u00E0
         sta   <$33,y
         bra   L2385
L2353    leax  -$01,x
         stx   u0002,u
         tst   u0008,u
         bne   L235D
         stx   u0004,u
L235D    lda   ,x
         cmpa  #$20
         bne   L236B
         leax  $01,x
         dec   <u00EA
         beq   L2385
         bra   L235D
L236B    cmpa  #$F0
         beq   L2383
L236F    lda   ,-x
         cmpa  #$20
         beq   L2383
         cmpa  #$F1
         beq   L2383
         cmpa  #$2D
         beq   L2383
         cmpx  ,u
         bne   L236F
         bra   L238D
L2383    leax  $01,x
L2385    stx   u0002,u
         tst   u0008,u
         bne   L238D
         stx   u0004,u
L238D    rts
L238E    cmpb  #$F0
         beq   L2385
         cmpa  #$F1
         lbne  L2300
         ldb   #$5A
         clra
         ldb   d,y
         clra
         pshs  b,a
         ldd   <u005A
         subd  ,s++
         lbcs  L2353
         lbra  L2300
L23AB    lda   -$02,x
         cmpa  #$20
         beq   L23BC
         cmpa  #$2C
         beq   L23BC
         cmpa  <u0030,u
         lbne  L2326
L23BC    lda   ,x
         cmpa  #$20
         beq   L23CD
         cmpa  #$2C
         beq   L23CD
         cmpa  <u0030,u
         lbne  L2326
L23CD    ldb   <u00D9
         clra
         addd  <u005A
         lbra  L2326

L23D5    tst   u0008,u
         beq   L23E1
         lda   [,u]
         cmpa  >PRCCHR,pcr PROC COMMAND CHARACTER
         beq   L2451
L23E1    ldx   u0002,u
         cmpx  <u0063
         bcs   L23EC
         lda   #$0A
         orcc  #Carry
         rts
L23EC    cmpu  <u0022
         bne   L2451
         ldd   $0F,u
         subd  <u0050
         addb  #$02
         cmpb  <u0062    Max pages
         bcs   L2411
         lda   <u0023,u
         inca
         adda  <u002B,u
         cmpa  <u001A,u
         bcc   L240C
         cmpa  <u002A,u
         bcs   L2411
L240C    lda   #$0B
         orcc  #Carry
         rts
L2411    tst   u0008,u
         bne   L2428
         ldy   <u006D
         sty   <u00AC
         ldx   ,u
L241D    lda   ,x+
         sta   ,y+
         cmpx  u0004,u
         bne   L241D
         sty   <u006D
L2428    ldx   <u002C
         stx   <u0052
         ldx   <u0084
         cmpx  <u0052
         beq   L2451
         tst   u0008,u
         bne   L2441
         ldd   <u00AC
         std   ,x
         sty   $02,x
         clr   $04,x
         bra   L244D
L2441    ldd   ,u
         std   ,x
         ldd   <u006D
         std   $02,x
         lda   #$01
         sta   $04,x
L244D    leax  $05,x
         stx   <u0084
L2451    lbsr  L2537
         lda   <u002B,u
         cmpa  <u002A,u
         bhi   L24BD
         cmpa  <u001A,u
         bcc   L24A8
         cmpa  <u0018,u
         bls   L2486
         clr   u0008,u
         ldx   u0004,u
L246A    stx   ,u
         lbsr  L21F5
         tst   u0008,u
         beq   L2483
         ldd   [,u]
         cmpa  >PRCCHR,pcr
         bne   L2483
         cmpb  >PRCCHR,pcr
         lbne  L23D5
L2483    andcc #^Carry
         rts

L2486    lda   #$01
         sta   u0008,u
         lda   $0E,u
         cmpa  #$01
         bne   L249C
         ldx   #$0000
         cmpx  ,u
         bne   L249C
         ldx   <u0015,u
         bra   L249E
L249C    ldx   u0002,u
L249E    cmpx  <u006D
         bne   L246A
         ldx   <u0022
         ldx   ,x
         bra   L246A
L24A8    lda   #$01
         sta   u0008,u
         ldx   u0004,u
         cmpx  u0002,u
         bne   L249C
         lda   <u001A,u
         sta   <u002B,u
         ldx   <$13,u
         bra   L249E
L24BD    lda   <u001D,u
         sta   <u0018,u
         lda   <u001E,u
         sta   <u0019,u
         lbsr  L47E7
         clr   $0E,u
         clr   u000D,u
         clr   <u002B,u
         ldx   <$11,u
         leax  $01,x
         stx   <$11,u
         ldx   $0F,u
         leax  $01,x
         stx   $0F,u
         lda   #$01
         sta   u0008,u
         ldx   #$0000
         stx   ,u
         stx   u0002,u
         lda   #$01
         sta   u0008,u
         cmpu  <u0022
         beq   L24F8
         andcc #^Carry
         rts

L24F8    ldy   <u0028
         ldx   <u002A
         ldd   #$015E
         lbsr  L45F5
         ldd   <u0084
         subd  #$015E
         std   <u0082
         ldd   <u0080
         std   <u007E
         addd  #$0001
         std   <u0080
         ldx   <u002A
         stx   <u0084
         clr   <u0086
         ldd   $0F,u
         subd  <u0050
         lda   #$37
         mul
         ldx   <u0072
         leay  d,x
         ldx   <u0022
         ldd   #$0037
         pshs  y
         lbsr  L45F5
         puls  x
         ldd   <u006D
         std   $04,x
         andcc #^Carry
         rts

L2537    tst   u0008,u
         beq   L2545
         lda   [,u]
         cmpa  >PRCCHR,pcr
         lbeq  L2611
L2545    ldx   u0009,u
         leax  $01,x
         stx   u0009,u
         inc   u000D,u
         lda   <u001C,u
         bne   L259B
         lda   [,u]
         cmpa  >PRCCHR,pcr
         lbeq  L2611
         ldx   u000B,u
         leax  $01,x
         stx   u000B,u
         inc   $0E,u
         tst   u0008,u
         bne   L2587
         lda   <u0023,u
         inca
         adda  <u002B,u
         sta   <u002B,u
         clr   <u0028,u
         tst   <u0024,u
         beq   L257D
         dec   <u0024,u
L257D    tst   <u0026,u
         beq   L2585
         dec   <u0026,u
L2585    bra   L259A
L2587    inc   <u002B,u
         tst   <u0020,u
         beq   L2592
         dec   <u0020,u
L2592    tst   <u0021,u
         beq   L259A
         dec   <u0021,u
L259A    rts
L259B    ldd   [,u]
         cmpa  >PRCCHR,pcr
         bne   L25FA
         cmpb  >PRCCHR,pcr
         bne   L25FA
         lda   <u001C,u
         cmpa  #$01
         bne   L25C6
         lda   <u002A,u
         suba  <u0019,u
         bcs   L2615
         suba  <u001D,u
         bcs   L2615
         cmpa  #$03
         bls   L2615
         clr   <u001C,u
         bra   L259A
L25C6    clr   <u001C,u
         lda   <u002A,u
         suba  <u0018,u
         bcs   L2615
         suba  <u001E,u
         bcs   L2615
         cmpa  #$03
         bls   L2615
         lda   <u0019,u
         ldb   <u001A,u
         pshs  b,a
         lda   <u001E,u
         sta   <u0019,u
         lbsr  L47E7
         lda   <u001A,u
         cmpa  $0E,u
         puls  b,a
         bhi   L259A
         stb   <u001A
         sta   <u0019,u
         rts
L25FA    lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L2611
         lda   <u001C,u
         cmpa  #$01
         bne   L260D
         inc   <u001D,u
         rts
L260D    inc   <u001E,u
         rts
L2611    lbsr  L4608
         rts
L2615    clrb
         stb   <u0018,u
         comb
         stb   <u001A,u
         clr   <u001D,u
         clr   <u001E,u
         clr   <u001C,u
         cmpu  <u0022
         lbne  L259A
         lda   #$10
         lbsr  L3111
         rts

L2633    lbsr  L1A2D
         clr   <u00C2
L2638    ldu   <u0022
L263A    lbsr  L35E5
L263D    lda   <u0041 Curr column
         cmpa  <LASTCOL Max column
         bcc   L2638
         ldd   $0F,u
         subd  <u0050
         addb  #$02
         cmpb  <u0062    Max pages
         bcs   L2666
         lda   <u0023,u
         inca
         adda  <u002B,u
         cmpa  <u001A,u
         bcc   L265E
         cmpa  <u002A,u
         bcs   L2666
L265E    lda   #$0B
         lbsr  L3111
         lbra  L271B
L2666    lbsr  L1C27
         cmpa  >ENMODC,pcr
         bne   L2673
         clr   <u00C2
         bra   L263D
L2673    cmpa  #$1F
         lbls  L26E9
         cmpa  #$7F
         bhi   L26E9
L267D    sta   <u0077
         tst   <u00C2
         bne   L26AB
L2683    lbsr  L30DA
         bcs   L263D
         lda   <u0077
         cmpa  #$20
         beq   L26BA
         cmpa  #$2D
         beq   L26BA
         cmpa  #$F0
         beq   L26BA
L2696    lbsr  L29C5
         bcs   L263A
         ldy   u0006,u
         tst   <u00C2
         beq   L26A4
         leay  -$01,y
L26A4    leay  -$01,y
         lbsr  L2181
         bra   L263D
L26AB    cmpa  #$F0
         beq   L2683
         pshs  a
         lda   <u00C2
         lbsr  L30DA
         puls  a
         bra   L2683
L26BA    lda   u000D,u
         cmpa  #$01
         beq   L2696
         ldx   <u006D
         lda   -$01,x
         cmpa  #$F0
         beq   L2696
         ldx   u0006,u
         leax  -$01,x
         stx   <u0052
         ldx   ,u
         bra   L26DC
L26D2    lda   ,x+
         cmpa  #$20
         beq   L2696
         cmpa  #$2D
         beq   L2696
L26DC    cmpx  <u0052
         bne   L26D2
         lbsr  L2851
         lbcs  L263A
         bra   L2696
L26E9    cmpa  >BSC,pcr Backspace
         lbeq  L278A
         cmpa  #$0D       Character return
         beq   L2716
         cmpa  >ESCC,pcr  Escape
         beq   L271B
         cmpa  >TABC,pcr
         lbeq  L2743
         lbsr  L403D
         tstb
         beq   L270C
         lbra  L263D
L270C    lbsr  L2CFB
         lbcc  L263D
         lbra  L263A

L2716    lda   #$F0
         lbra  L267D

L271B    andcc #^Carry
         lbsr  L1A36
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L2730
         tst   <u001C,u
         beq   L2730
         lbra  L2A2B
L2730    tst   <u006F
         bne   L2739
         inc   <u006F
         lbra  L2A2F
L2739    lda   <u006A
         inca
         sta   <u0060
         sta   <u0068
         lbra  L2A2B
L2743    ldx   <u006D
         lda   -$01,x
         cmpa  #$F0
         beq   L275A
         ldx   u0009,u
         cmpx  #$0001
         beq   L275A
L2752    lda   #$1D
         lbsr  L3111
         lbra  L263D
L275A    lbsr  L30BD
         bcs   L2752
         sta   <u00A1
         tst   <u001C,u
         bne   L276B
         lda   <u001B,u
         bra   L276E
L276B    lda   <u001F,u
L276E    cmpa  <u00A1
         bcs   L2752
         lda   <u00A1
         suba  <u0041 Curr column
         bls   L2784
L2778    pshs  a
         lda   #$20
         lbsr  L30DA
         puls  a
         deca
         bne   L2778
L2784    lbsr  L29C5
         lbra  L263A
L278A    ldx   u0006,u
         lbsr  L0167 Read key if entered
         cmpx  ,u
         beq   L27DF
         lda   ,-x
         cmpa  #$F1
         bne   L27A3
L2799    lda   ,-x
         cmpx  ,u
         beq   L27AD
         cmpa  #$F1
         beq   L2799
L27A3    cmpx  ,u
         beq   L27AD
         lda   -$01,x
         bpl   L27AD
         leax  -$01,x
L27AD    ldy   u0006,u
         tfr   x,d
         subd  ,u
         lbsr  L45E2
         sty   ,u
L27BA    lbsr  L2851
         lbcs  L263A
         lbsr  L29C5
         lbcs  L263A
         ldd   <SCRROW
         decb
         lbsr  GOROWCOL
         lda   >INSFIL,pcr  character -
         clrb
         lbsr  L193C
         ldd   <SCRROW
         decb
         lbsr  GOROWCOL
         lbra  L263D

L27DF    tst   <u006F
         beq   L27E7
         ldx   u0009,u
         bra   L27E9
L27E7    ldx   u000B,u
L27E9    leax  -$01,x
         cmpx  #$FFFF
         bne   L27FA
         ldu   <u0022
         lda   #$07
         lbsr  L3111
         lbra  L2638
L27FA    lbsr  L2B0C
         tst   <u006F
         bne   L2816
         ldy   <u0022
         ldd   $09,y
         subd  $0B,y
         addd  u000B,u
         subd  u0009,u
         beq   L2816
         lda   #$11
         lbsr  L3111
         lbra  L2638
L2816    tst   u0008,u
         beq   L281E
         ldu   <u0020
         bra   L27DF
L281E    lda   [,u]
         cmpa  #$F0
         beq   L282F
         ldx   <u006D
         leax  -$01,x
         stx   <u006D
         ldu   <u0022
         lbra  L27BA
L282F    ldy   <u0022
         ldd   ,y
         std   ,u
         ldd   $02,y
         std   u0002,u
         std   u0004,u
         ldd   $09,y
         std   <u00AE
         ldx   <u006D
         leax  -$01,x
         stx   <u00AA
         leax  >L2638,pcr
         pshs  x
         leas  -$04,s
         lbra  L28D7
L2851    pshs  u,y
         ldy   <u0022
         ldx   $09,y
         stx   <u00AE
L285A    cmpx  #$0000
         beq   L28CC
         leax  -$01,x
         beq   L28CC
         lda   <u006F
         pshs  a
         lda   #$01
         sta   <u006F
         sta   <u00C7
         lbsr  L2B0C
         puls  a
         sta   <u006F
         tst   u0008,u
         beq   L288C
         ldx   <u0072
         ldy   <u0020
         ldd   $0F,y
         subd  <u0050
         lda   #$37
         beq   L28CC
         mul
         leax  d,x
         ldx   $09,x
         bra   L285A
L288C    ldx   <u006D
         ldy   <u0022
         ldy   ,y
         bra   L289A
L2896    lda   ,-x
         sta   ,-y
L289A    cmpx  ,u
         bne   L2896
         sty   ,u
         stx   <u00AA
         ldd   u0004,u
         pshs  b,a
         lbsr  L21F5
         puls  b,a
         ldx   u0002,u
         ldy   <u0022
         cmpx  ,y
         bne   L28D0
         cmpd  <u006D
         lbne  L293F
         ldx   <u00AA
         ldy   ,u
         bra   L28C7
L28C3    lda   ,y+
         sta   ,x+
L28C7    cmpy  u0004,u
         bne   L28C3
L28CC    andcc #^Carry
L28CE    puls  pc,u,y
L28D0    ldy   <u0022
         cmpx  $06,y
         bls   L293F
L28D7    ldd   $0F,u
         ldy   <u0022
         cmpd  $0F,y
         beq   L28F7
         ldy   <u002A
         ldx   <u0028
         ldd   #$015E
         lbsr  L45F5
         ldd   <u007E
         std   <u0080
         ldd   #$FFFF
         sta   <u0093
         std   <u007E
L28F7    ldb   u000D,u
         lda   #$05
         mul
         ldx   <u002A
         cmpd  #$015E
         bls   L2908
         ldx   <u002C
         bra   L290A
L2908    leax  d,x
L290A    stx   <u0084
         ldy   <u0022
         ldx   $06,y
         pshs  x
         ldx   <u0020
         ldb   #$37
         clra
         lbsr  L45F5
         puls  x
         ldy   <u0022
         stx   $06,y
         ldx   <u00AA
         stx   <u006D
         ldd   <u00AE
         subd  u0009,u
         pshs  b,a
         ldb   <SCRROW
         clra
         subd  ,s++
         bcc   L2934
         clrb
L2934    stb   <u006A
         incb
         stb   <u0060
         stb   <u0068
         orcc  #Carry
         bra   L28CE
L293F    ldx   <u00AA
         ldy   ,u
         bra   L294A
L2946    lda   ,y+
         sta   ,x+
L294A    cmpy  u0004,u
         bne   L2946
         stx   <u00B0
         stx   <u006D
         ldx   <u0022
         sty   ,x
         ldd   $0F,u
         cmpd  <u007E
         bne   L298E
         ldx   <u002A
         stx   <u0052
         lda   #$05
         ldb   u000D,u
         mul
         ldx   <u0028
         leax  d,x
         bra   L2974
L296E    ldd   <u006D
         std   $02,x
         leax  $05,x
L2974    cmpx  <u0052
         bcs   L296E
         ldy   <u0022
         ldd   $0F,y
         subd  <u0050
         lda   #$37
         mul
         ldx   <u0072
         leax  d,x
         ldd   <u006D
         std   $04,x
         ldx   <u002A
         bra   L299F
L298E    ldx   <u002A
         lda   #$05
         ldb   u000D,u
         mul
         leax  d,x
         bra   L299F
L2999    ldd   <u006D
         std   $02,x
         leax  $05,x
L299F    cmpx  <u0084
         bcs   L2999
         ldd   <u00AE
         subd  u0009,u
         pshs  b,a
         ldb   <SCRROW
         clra
         subd  ,s++
         bcs   L29C0
         tfr   b,a
         ldb   #$01
         stb   <u0074
         lbsr  L3249
         lda   <u006A
         inca
         sta   <u0060
         sta   <u0068
L29C0    orcc  #Carry
         lbra  L28CE
L29C5    ldd   u0002,u
         pshs  b,a
         lbsr  L21F5
         puls  b,a
         clr   <u0058
         cmpd  u0002,u
         beq   L29D7
         inc   <u0058
L29D7    ldd   u0006,u
         cmpd  u0002,u
         bcc   L29EF
         tst   <u0058
         bne   L29E5
         andcc #^Carry
         rts
L29E5    lda   <u006A
         inca
         sta   <u0068
         sta   <u0060
         orcc  #Carry
         rts
L29EF    tst   <u006F
         bne   L2A00
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L2A19
         tst   <u001C,u
         bne   L2A19
L2A00    lda   <SCRROW
         ldb   #$01
         stb   <u0074
         clr   <u00CF
         lbsr  L3249
         cmpa  <LASTROW
         bne   L2A12
         lbsr  L19F1
L2A12    lda   <SCRROW
         inca
         clrb
         lbsr  GOROWCOL
L2A19    lbsr  L23D5
         tst   u0008,u
         bne   L29EF
         lda   <SCRROW
         sta   <u006A
         bra   L29E5
         nop
         fcb   $34  Unreachable instruction

L2A28    lbra  L2A80
L2A2B    bsr   L2A33
         bra   L2A65
L2A2F    bsr   L2A33
         bra   L2A55
L2A33    clr   <u0074
         ldu   <u0022
         lbsr  L2851
         bsr   L29C5
         ldx   u0006,u
         cmpx  ,u
         bcs   L2A47
         cmpx  u0002,u
         bcc   L2A47
         rts
L2A47    lda   #$01
         sta   <u00CF
         clr   <u0074
         clr   <u0071
         lda   <u006A
         lbsr  L3249
         rts
L2A55    ldu   <u0022
         lbsr  L31D9
         lda   <u006A
         sta   <SCRROW
         inca
         sta   <u0060
         sta   <u0068
         clr   <u0096
L2A65    ldu   <u0022
         ldx   u0006,u
         cmpx  ,u
         bcs   L2A71
         cmpx  u0002,u
         bcs   L2A75
L2A71    ldx   ,u
         stx   u0006,u
L2A75    lda   #$01
         sta   <u0074
         clr   <u00CF
         lda   <u006A
         lbsr  L3249
L2A80    ldu   <u0022
         lda   <SCRROW
         sta   <u006A
         lds   <u001E
         lbsr  L1C27
         lbsr  L0167 Read key if entered
L2A8F    lbsr  L2CFB
         bcs   L2A65
         lbsr  L1C44
         ldu   <u0022
         leax  >ESCTBL,pcr
         leay  >L2AC9,pcr
         bsr   L2AAE
         bcc   L2AAC
L2AA5    lda   #$03
         lbsr  L3111
         bra   L2A80
L2AAC    jmp   ,x

L2AAE    cmpa  ,x+
         beq   L2ABB
         leay  $02,y
         tst   ,y
         bne   L2AAE
         orcc  #Carry
         rts

L2ABB    pshs  a
         leax  >0,pcr
         ldd   ,y
         leax  d,x
         andcc #^Carry
         puls  pc,a

* Command table in ESCAPE mode
L2AC9    fdb   L4A5F   Cursor up
         fdb   L4B5E   Cursor right
         fdb   L4AF3
         fdb   L4B9C
         fdb   L4BFC
         fdb   L4C22
         fdb   L422B
         fdb   L42BD
         fdb   L2633
         fdb   L413B
         fdb   L41CB
         fdb   L40C0
         fdb   L3759
         fdb   L417F
         fdb   L4CF4
         fdb   L4C83
         fdb   L4BD1
         fdb   L4D91
         fdb   L421E
         fdb   L4D7A
         fdb   L2A28
         fdb   L4E6D
         fdb   L4E82
         fdb   L4E8F
         fdb   L4F01
         fdb   L4007
         fdb   L4007
         fdb   L4007
         fdb   L4007
         fdb   L4007
         fdb   L4099
         fdb   L4B5E
         fdb   L4B9C
 FCB 0

L2B0C    stx   <u006B
         ldu   <u0020
         ldy   <u0022
         ldd   $0F,y
         subd  <u0050
         lda   #$37
         mul
L2B1A    ldy   <u0072
         leay  d,y
L2B1F    ldd   <u006B
         tst   <u006F
         beq   L2B2A
         cmpd  $09,y
         bra   L2B2D
L2B2A    cmpd  $0B,y
L2B2D    bcc   L2B34
         leay  <-$37,y
         bra   L2B1F
L2B34    tfr   y,x
         ldy   <u0020
         ldd   #$0037
         lbsr  L45F5
         ldd   $0F,u
         cmpd  <u007E
         beq   L2B7F
         cmpd  <u0080
         beq   L2B8E
L2B4B    lbsr  L21F5
L2B4E    ldd   <u006D
         cmpd  u0004,u
         bcc   L2B5D
         std   u0004,u
         tst   u0008,u
         bne   L2B5D
         std   u0002,u
L2B5D    bsr   L2B71
         beq   L2BAD
         tst   <u00C7
         beq   L2B6C
         ldd   u0004,u
         cmpd  <u006D
         bcc   L2BAD
L2B6C    lbsr  L23D5
         bra   L2B4E
L2B71    ldd   <u006B
         tst   <u006F
         beq   L2B7B
         cmpd  u0009,u
         rts
L2B7B    cmpd  u000B,u
         rts
L2B7F    lbsr  L1C4F
         bcs   L2B7F
         ldy   <u0028
         sty   <u00A6
         ldx   <u002A
         bra   L2B96
L2B8E    ldy   <u002A
         sty   <u00A6
         ldx   <u002C
L2B96    stx   <u00A8
L2B98    bsr   L2B71
         bne   L2BB0
         tst   <u006F
         bne   L2BAD
         tst   <u001C,u
         bne   L2BB0
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L2BB0
L2BAD    clr   <u00C7
         rts
L2BB0    tst   <u00C7
         beq   L2BBB
         ldd   u0004,u
         cmpd  <u006D
         bcc   L2BAD
L2BBB    ldy   <u00A6
         leay  $05,y
         sty   <u00A6
         cmpy  <u00A8
         beq   L2B4B
         tst   $04,y
         beq   L2BD4
         lbsr  L21F5
         lbsr  L23D5
         bra   L2B98
L2BD4    lbsr  L2537
         ldy   <u00A6
         ldx   ,y
         stx   ,u
         ldd   $02,y
         std   u0004,u
         lda   $04,y
         sta   u0008,u
         bra   L2B98
L2BE8    pshs  u
         ldu   <u0020
         ldy   <u0022
         ldd   $0F,y
         subd  $0F,u
         beq   L2C5F
         cmpd  #$0001
         beq   L2C44
         ldd   $0F,u
         subd  <u0050
         lda   #$37
         mul
         ldx   <u0072
         leax  d,x
         ldy   <u0026
         ldd   #$0037
         lbsr  L45F5
         ldx   <u002A
         stx   <u0084
         ldx   $0F,u
         stx   <u0080
         ldu   <u0026
         bra   L2C36
L2C1B    ldx   <u0084
         ldd   ,u
         std   ,x
         ldd   u0004,u
         std   $02,x
         lda   u0008,u
         sta   $04,x
         leax  $05,x
         stx   <u0084
         ldx   <u002C
         cmpx  <u0084
         beq   L2C40
         lbsr  L23D5
L2C36    ldd   u0009,u
         ldy   <u0020
         cmpd  $09,y
         bne   L2C1B
L2C40    ldu   <u0020
         bra   L2C58
L2C44    lbsr  L1C4F
         bcs   L2C44
         ldy   <u002A
         ldd   #$015E
         ldx   <u0028
         lbsr  L45F5
         ldd   <u007E
         std   <u0080
L2C58    ldd   #$FFFF
         sta   <u0093
         std   <u007E
L2C5F    ldb   u000D,u
         lda   #$05
         mul
         ldx   <u002A
         cmpd  #$015E
         bls   L2C6F
         ldd   #$015E
L2C6F    leax  d,x
         stx   <u0084
         tst   u0008,u
         beq   L2C7B
         ldd   u0004,u
         bra   L2C7D
L2C7B    ldd   ,u
L2C7D    ldx   <u006D
         stx   <u0052
         std   <u006D
         ldd   <u0052
         subd  <u006D
         ldy   <u0022
         ldy   ,y
         lbsr  L45E2
         tst   u0008,u
         beq   L2C99
         sty   u0004,u
         bra   L2C9C
L2C99    sty   ,u
L2C9C    ldx   <u0020
         ldy   <u0022
         ldd   #$0037
         lbsr  L45F5
         ldu   <u0022
         lbsr  L21F5
         puls  pc,u
L2CAE    pshs  y,x,b,a
         ldx   <u0034
         clr   $05,x
         leay  >L2CF1,pcr
         pshs  a
         lda   #$05
         sta   <u0059
         puls  a
         clr   <u0058
L2CC2    subd  ,y
         bcs   L2CCA
         inc   <u0058
         bra   L2CC2
L2CCA    addd  ,y
         pshs  a
         lda   <u0058
         adda  #$30
         sta   ,x+
         puls  a
         leay  $02,y
         clr   <u0058
         dec   <u0059
         bne   L2CC2
         ldx   <u0034
         ldb   #$04
L2CE2    lda   #$30
         cmpa  ,x
         bne   L2CEF
         lda   #$20
         sta   ,x+
         decb
         bne   L2CE2
L2CEF    puls  pc,y,x,b,a


L2CF1    fdb 10000
         fdb  1000
         fdb   100
         fdb    10
         fdb     1

* Check for control codes
L2CFB    pshs  y,x,b,a
         leax  >CTRTBL,pcr
         leay  >L2D25,pcr
         lbsr  L2AAE
         bcs   L2D12
         jsr   ,x
         bcs   L2D16
         orcc  #Carry
L2D10    puls  pc,y,x,b,a

L2D12    andcc #^Carry
         bra   L2D10
L2D16    lbsr  L31D9
         lda   <u006A
         inca
         sta   <u0068
         sta   <u0060
         orcc  #Carry
         lbra  L2D10

L2D25    fdb   L2FB2  Line delete
         fdb   L2F0F  Character delete
         fdb   L2F46
         fdb   L2D48
         fdb   L2D69
         fdb   L2D43
         fdb   L2D6F
         fdb   L3041
         fdb   L3065
         fdb   L309B
         fdb   L2D3E  Toggle upper case lock
         fdb   L2FE9  Ctrl-A Display help menu
         fcb 0

L2D3E    com   <u00A0
         andcc #^Carry
         rts

L2D43    com   <u0070
         orcc  #Carry
         rts

L2D48    tst   <u006F
         beq   L2D62
         clra
         tst   <u001C,u
         bne   L2D5A
         ldb   [,u]
         cmpb  >PRCCHR,pcr
         bne   L2D64
L2D5A    lda   #$0F
         lbsr  L3111
         andcc #^Carry
         rts

L2D62    lda   #$01
L2D64    sta   <u006F
         orcc  #Carry
         rts

L2D69    lbsr  L311C
         andcc #^Carry
         rts

L2D6F    lda   <LASTCOL Max column
L2D71    inca
         sta   <u0060
L2D74    lbsr  L19DB
         ldd   #$0011
         lbsr  GOROWCOL
         ldx   >PGMS1,pcr
         lbsr  L3731  Write string in X
         ldd   #$0200
         lbsr  GOROWCOL
         ldx   >PGM50,pcr
         lbsr  L3731  Write string in X
         tst   <u0061
         bne   L2D9B
         ldx   >PGM52,pcr
         bra   L2DA2

L2D9B    ldx   <u0030
         lbsr  L374C  Write string in X
         bra   L2DA5
L2DA2    lbsr  L3731  Write string in X
L2DA5    ldd   #$0500
         lbsr  GOROWCOL
         ldx   >PGM51,pcr
         lbsr  L3731  Write string in X
         tst   <u0061
         bne   L2DBC
         ldx   >PGM52,pcr
         bra   L2DC3
L2DBC    ldx   <u0032
         lbsr  L374C  Write string in X
         bra   L2DC6
L2DC3    lbsr  L3731  Write string in X
L2DC6    ldd   #$0300
         lbsr  GOROWCOL
         ldx   >PGM53,pcr
         lbsr  L3731  Write string in X
         tst   <u004E
         beq   L2DDD
         ldx   >PGM54,pcr
         bra   L2DE1
L2DDD    ldx   >PGM55,pcr
L2DE1    lbsr  L3731  Write string in X
         ldd   #$0600
         lbsr  GOROWCOL
         ldx   >PGM53,pcr
         lbsr  L3731  Write string in X
         tst   <u004F
         beq   L2DFB
         ldx   >PGM54,pcr
         bra   L2DFF
L2DFB    ldx   >PGM55,pcr
L2DFF    lbsr  L3731  Write string in X
         ldy   <u001C
         ldd   $0F,u
         addd  #$0001
         std   ,y++
         ldd   <$11,u
         std   ,y++
         ldb   <u002B,u
         clra
         std   ,y++
         ldb   <u002A,u
         std   ,y++
         ldb   <u0018,u
         std   ,y++
         ldb   <u0019,u
         std   ,y++
         ldb   <u0023,u
         incb
         std   ,y++
         ldb   <u002D,u
         std   ,y++
         ldb   <u001B,u
         std   ,y++
         ldb   <u001F,u
         std   ,y++
         ldb   <u0017,u
         std   ,y++
         ldb   <u0029,u
         std   ,y++
         ldb   <u002C,u
         std   ,y++
         ldb   <u0034,u
         std   ,y++
         ldb   <u0035,u
         std   ,y++
         ldb   <u0036,u
         std   ,y++
         lda   #$FF
         ldb   #$59
         tst   <u0025,u
         bne   L2E64
         ldb   #$4E
L2E64    std   ,y++
         ldb   #$59
         tst   <u002F,u
         bne   L2E6F
         ldb   #$4E
L2E6F    std   ,y++
         ldb   <u0030,u
         std   ,y++
         ldb   <u0031,u
         std   ,y++
         ldb   <u0032,u
         std   ,y++
         ldd   ,u
         subd  <u006D
         std   ,y++
         ldy   <u001C
         ldd   >PGMS6,pcr
         leax  >0,pcr
         leax  d,x
         clr   <u009E
         lda   #$08
         sta   <u009D
         bsr   L2EB7
         lda   #$19
         sta   <u009E
         lda   #$08
         sta   <u009D
         bsr   L2EB7
L2EA5    lbsr  L1C27
         cmpa  >ESCC,pcr  Escape
         beq   L2EB4
         cmpa  >PAGSTC,pcr
         bne   L2EA5
L2EB4    orcc  #Carry
         rts
L2EB7    lda   #$10
         sta   <u009C
L2EBB    dec   <u009C
         beq   L2F0E
         ldd   <u009D
         lbsr  GOROWCOL
         inc   <u009D
         tst   ,x+
         beq   L2EBB
         leax  -$01,x
         lbsr  L374C  Write string in X
         ldd   ,y++
         cmpa  #$FF
         beq   L2EFA
         lbsr  L2CAE
         pshs  x
         ldx   <u0034
         lda   $01,x
         cmpa  #$20
         bne   L2EEB
         leax  $02,x
         ldd   <u009D
         deca
         addb  #$14
         bra   L2EF0
L2EEB    ldd   <u009D
         deca
         addb  #$0D
L2EF0    lbsr  GOROWCOL
         lbsr  L374C  Write string in X
         puls  x
         bra   L2EBB
L2EFA    tstb
         beq   L2EBB
         pshs  b
         ldd   <u009D
         deca
         addb  #$16
         lbsr  GOROWCOL
         puls  a
         lbsr  OUTREPT
         bra   L2EBB
L2F0E    rts
L2F0F    tst   <u0097
         bne   L2F1D
         ldy   u0006,u
         leay  $01,y
         cmpy  <u0063
         bcs   L2F25
L2F1D    lda   #$12
         lbsr  L3111
         andcc #^Carry
         rts
L2F25    lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L2F32
         tst   <u001C,u
         beq   L2F34
L2F32    inc   <u0068
L2F34    ldx   u0006,u
         lda   ,x
         bpl   L2F44
         cmpa  #$F0
         beq   L2F44
         cmpa  #$F1
         beq   L2F44
         leay  $01,y
L2F44    bra   L2F8E

L2F46    tst   <u0097
         bne   L2F1D
         ldx   u0006,u
         lda   ,x
         cmpa  #$F0
         beq   L2F0F
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L2F5F
         tst   <u001C,u
         beq   L2F61
L2F5F    inc   <u0068
L2F61    cmpx  ,u
         beq   L2F77
         lda   ,x
         bmi   L2F71
         cmpa  #$20
         beq   L2F75
L2F6D    leax  -$01,x
         bra   L2F61
L2F71    cmpa  #$F0
         bne   L2F6D
L2F75    leax  $01,x
L2F77    ldy   u0006,u
L2F7A    lda   ,y+
         cmpa  #$20
         beq   L2F86
         cmpa  #$F0
         bne   L2F7A
         leay  -$01,y
L2F86    lda   ,y+
         cmpa  #$20
         beq   L2F86
         leay  -$01,y
L2F8E    sty   u0006,u
L2F91    cmpx  ,u
         beq   L2F9B
         lda   ,-x
         sta   ,-y
         bra   L2F91
L2F9B    sty   ,u
         lbsr  L2851
         lbsr  L29C5
         tst   <u0068
         beq   L2FAF
L2FA8    lda   <u006A
         inca
         sta   <u0068
         sta   <u0060
L2FAF    andcc #^Carry
         rts

* Line delete
L2FB2    ldx   <u006D
         lda   -$01,x
         cmpa  #$F0
         beq   L2FCA
         ldd   u0009,u
         cmpd  #$0001
         beq   L2FCA
L2FC2    lda   #$14
         lbsr  L3111
         andcc #^Carry
         rts

L2FCA    ldx   u0002,u
         lda   ,-x
         cmpa  #$F0
         bne   L2FC2
         ldy   ,u
         stx   ,u
         stx   u0006,u
         lda   ,y
         cmpa  >PRCCHR,pcr
         beq   L2FA8
         tst   <u001C,u
         bne   L2FA8
         andcc #^Carry
         rts

* Display help menu
L2FE9    lda   #$FF
         sta   <u0060
         lbsr  L19DB
         ldb   #$07
         ldx   >HLPS1,pcr
         lbsr  L50A8
L2FF9    tsta
         beq   L303E
         leax  >HLPS2,pcr
         deca
         lsla
         leax  a,x
         ldd   ,x
         leax  >0,pcr
         leax  d,x
         lbsr  L022A
         bcs   L3027
         lbsr  L19DB
L3014    lbsr  L02E2
         bcs   L3035
         cmpa  #$0D
         bne   L3022
         lbsr  WrA2BUF
         lda   #$0A
L3022    lbsr  WrA2BUF
         bra   L3014
L3027    ldd   #$0000
         lbsr  GOROWCOL
         lbsr  L02BF
         lbsr  L5129
         bra   L2FF9
L3035    lbsr  L0281
         lbsr  L0167 Read key if entered
         lbsr  L1C27
L303E    orcc  #Carry
         rts

L3041    ldx   u0006,u
         lda   ,x
         cmpa  #$F1
         beq   L3062
         cmpx  ,u
         beq   L3062
         lda   -$01,x
         cmpa  #$F1
         beq   L3062
         cmpa  #$20
         beq   L3062
         lda   #$F1
         lbsr  L30DA
         lbsr  L2851
         lbsr  L29C5
L3062    andcc #^Carry
         rts

L3065    ldb   <u0041 Curr column
         addb  <u0098
         beq   L3082
         ldx   <u002E
         clra
L306E    cmpb  a,x
         bcs   L3083
         beq   L3082
         tst   a,x
         beq   L3083
         inca
         cmpa  #$16
         bne   L306E
         lda   #$1B
         lbsr  L3111
L3082    rts
L3083    sta   <u0058
         ldb   #$15
         bra   L3090
L3089    decb
         lda   b,x
         incb
         sta   b,x
         decb
L3090    cmpb  <u0058
         bne   L3089
         lda   <u0041 Curr column
         adda  <u0098
         sta   b,x
         rts

L309B    ldx   <u002E
         clrb
         lda   <u0041 Curr column
         adda  <u0098
L30A2    cmpa  b,x
         beq   L30AC
         incb
         cmpb  #$16
         bne   L30A2
L30AB    rts
L30AC    clr   b,x
L30AE    incb
         cmpb  #$16
         beq   L30AB
         lda   b,x
         beq   L30AB
         decb
         sta   b,x
         incb
         bra   L30AE
L30BD    ldx   <u002E
         clrb
         lda   <u0041 Curr column
         adda  <u0098
L30C4    cmpa  b,x
         bcs   L30D5
         incb
         cmpb  #$16
         bne   L30C4
         lda   #$1C
         lbsr  L3111
         orcc  #Carry
         rts
L30D5    lda   b,x
         andcc #^Carry
         rts
L30DA    pshs  a
         ldd   ,u
         subd  <u006D
         cmpd  #$00C8
         bhi   L30FC
         cmpd  #$000A
         bcs   L30F3
         lda   #$19
         lbsr  L3111
         bra   L30FC
L30F3    lda   #$1A
         lbsr  L3111
         orcc  #Carry
         puls  pc,a
L30FC    ldd   u0006,u
         subd  ,u
         ldx   ,u
         leay  -$01,x
         sty   ,u
         lbsr  L45F5
         puls  a
         sta   ,y
         andcc #^Carry
         rts

* Send character?
L3111    pshs  a
         sta   <u0078
         lda   #$07
         lbsr  WrA2BUF
         puls  pc,a

L311C    pshs  x,b,a
         clrb
         lda   <SCRROW
         lbsr  GOROWCOL
         lda   #'*
         lbsr  OUTREPT
         lbsr  OUTREPT
         lbsr  OUTREPT
         lda   #$20
         lbsr  OUTREPT
         ldd   >ERRTBL,pcr
         leax  >0,pcr
         leax  d,x
         lda   ,x+
L3140    cmpa  <u0078
         beq   L314E
L3144    lda   ,x+
         bne   L3144
         lda   ,x+
         bne   L3140
         bra   L317A
L314E    lbsr  L374C  Write string in X
L3151    lda   #C$SPAC
         lbsr  OUTREPT
         lbsr  OUTREPT
         lda   #'*
         ldb   <LASTCOL Max column
L315D    lbsr  OUTREPT
         cmpb  <u0041 Curr column
         bne   L315D
         lbsr  OUTREPT
L3167    lbsr  L1C27
         cmpa  >NMERC,pcr
         beq   L3176
         cmpa  >ESCC,pcr  Escape
         bne   L3167
L3176    orcc  #Carry
         puls  pc,x,b,a

L317A    ldx   >BELS1,pcr
         lbsr  L3731  Write string in X
         bra   L3151
L3183    pshs  u,y,x,b,a
         tst   <u0068
         beq   L3196
         clr   <u0068
         ldx   <u0022
         ldy   <u0024
         ldd   #$0037
         lbsr  L45F5
L3196    lda   <u0060
         cmpa  <LASTROW
         bls   L31A5
         lda   <LASTROW
         inca
         sta   <u0060
         andcc #^Carry
         puls  pc,u,y,x,b,a

L31A5    ldu   <u0024
L31A7    lbsr  L23D5
         bcs   L31D2
         tst   u0008,u
         beq   L31BF
L31B0    lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L31A7
         tst   <u001C,u
         bne   L31A7
         bra   L31C3
L31BF    tst   <u006F
         beq   L31B0
L31C3    lda   #$01
         sta   <u0074
         lda   <u0060
         lbsr  L3249
L31CC    inc   <u0060
         orcc  #Carry
         puls  pc,u,y,x,b,a
L31D2    lda   <u0060
         lbsr  L1A3F
         bra   L31CC
L31D9    pshs  u,y,x,b,a
         lda   #$01
         sta   <u0074
         tst   <u006A
         beq   L323A
         tst   <u006F
         bne   L31EB
         ldd   u000B,u
         bra   L31ED
L31EB    ldd   u0009,u
L31ED    subb  <u006A
         sbca  #$00
         bcc   L31FB
         addb  <u006A
         stb   <u006A
         beq   L323A
         clra
         clrb
L31FB    tfr   d,x
         lbsr  L2B0C
         ldu   <u0020
         lbsr  L21F5
         clr   <u009E
         bra   L3223
L3209    lbsr  L23D5
         tst   u0008,u
         beq   L321F
L3210    lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L3209
         tst   <u001C,u
         bne   L3209
         bra   L3223
L321F    tst   <u006F
         beq   L3210
L3223    ldd   <u006D
         cmpd  u0002,u
         bhi   L322C
         std   u0002,u
L322C    lda   <u009E
         lbsr  L3249
         lda   <u009E
         inca
         sta   <u009E
         cmpa  <u006A
         bne   L3209
L323A    puls  pc,u,y,x,b,a

L323C    sta   <u0058
         clra
L323F    subb  <u0058
         bcs   L3246
         inca
         bra   L323F
L3246    addb  <u0058
         rts
L3249    pshs  y,x,b,a
         clr   <u0099
         lbsr  L3717
         tst   <u004B
         bne   L3262
         lbsr  L011E  Start dimmed text
         lbsr  L19CB
         ldx   <SCRROW
         stx   <u00D1
         clrb
         lbsr  GOROWCOL
L3262    ldy   ,u
         lda   ,y
         cmpa  >PRCCHR,pcr
         beq   L329D
         tst   u0008,u
         beq   L3287
         clr   <u00A5
         tst   u000D,u
         lbeq  L35AA
         tst   <u0020,u
         bne   L32DF
         tst   <u0021,u
         lbne  L34D5
         bra   L329D
L3287    tst   <u0024,u
         bne   L32DF
         tst   <u0026,u
         lbne  L34D5
         tst   <u0025,u
         lbne  L3397
L329A    lbsr  L3587
L329D    lda   ,y
         bpl   L32B6
         cmpa  #$F0
         beq   L32C6
         cmpa  #$F1
         beq   L32B0
         lbsr  L1CD5
         leay  $01,y
         bra   L32B9
L32B0    leax  $01,y
         cmpx  u0002,u
         bne   L32B9
L32B6    lbsr  L1CD5
L32B9    leay  $01,y
         cmpy  u0002,u
         bcs   L329D
L32C0    clra
         lbsr  L1CD5
         bra   L32C9
L32C6    lbsr  L1CD5
L32C9    tst   <u004B
         bne   L32DD
         cmpu  <u0022
         beq   L32D7
         ldd   <u00D1
         lbsr  GOROWCOL
L32D7    lbsr  L19D3
         lbsr  L011F   Write txt and stop dimmed
L32DD    puls  pc,y,x,b,a
L32DF    tst   <u002F,u
         beq   L32EA
         tst   <u004B
         lbne  L34EF
L32EA    bsr   L32FA
         ldb   <u0095
         subb  <u008A
         lbcs  L329D
         lsrb
         lbsr  L359C
         bra   L329D
L32FA    ldy   ,u
         clr   <u008A
         clr   <u008C
         clr   <u0088
         clr   <u0089
         clrb
L3306    cmpy  u0002,u
         beq   L3350
         lda   ,y+
         bmi   L3306
         inc   <u008A
         cmpa  #$20
         bne   L3319
         inc   <u0088
         bra   L3306
L3319    incb
L331A    cmpy  u0002,u
         bcc   L3350
         lda   ,y+
         bpl   L3330
         cmpa  #$F1
         bne   L331A
         cmpy  u0002,u
         bne   L331A
         inc   <u008A
         bra   L3350
L3330    cmpa  #$20
         beq   L3341
         cmpa  <u0030,u
         beq   L335E
         ldb   #$01
         inc   <u008A
         clr   <u0089
         bra   L331A
L3341    inc   <u0089
         inc   <u008A
         tstb
         bne   L334B
         clrb
         bra   L331A
L334B    clrb
         inc   <u008C
         bra   L331A
L3350    ldy   ,u
         tst   <u0089
         beq   L335D
         tst   <u008C
         beq   L335D
         dec   <u008C
L335D    rts
L335E    lda   ,y+
         bmi   L331A
         cmpa  <u0030,u
         beq   L331A
         cmpy  u0002,u
         bcc   L3350
         lbsr  L1C44
         cmpa  >PBCHR,pcr
         bne   L335E
         lda   -$02,y
         cmpa  #$20
         beq   L3384
         cmpa  #$2C
         beq   L3384
         cmpa  <u0030,u
         bne   L335E
L3384    lda   ,y
         cmpa  #$20
         beq   L3393
         cmpa  #$2C
         beq   L3393
         cmpa  <u0030,u
         bne   L335E
L3393    dec   <u008A
         bra   L335E
L3397    ldx   u0002,u
         lda   ,-x
         cmpa  #$F0
         lbeq  L329A
         tst   <u004B
         beq   L33B6
         lda   <u0044 Active printer type
         cmpa  #$14
         lbcs  L3451
         bne   L33B6
         tst   <u002F,u
         lbne  L3451
L33B6    lbsr  L3587
         lbsr  L32FA
         tst   <u008C
         lbeq  L329D
         lda   <u001B,u
         adda  <u0089
         suba  <u008A
         suba  <u0028,u
         suba  <u0029,u
         lbmi  L329D
         lbeq  L329D
         clr   <u008E
L33D9    suba  <u008C
         bls   L33E1
         inc   <u008E
         bra   L33D9
L33E1    adda  <u008C
         sta   <u0090
         beq   L33E9
         inc   <u008E
L33E9    lda   <u008E
         deca
         sta   <u008F
         clr   <u00E8
         clr   <u0059
L33F2    cmpy  u0002,u
         lbeq  L32C0
         lda   ,y+
         bmi   L341E
         cmpa  #$20
         beq   L3407
         orcc  #Carry
         ror   <u0059
         bra   L3435
L3407    tst   <u0059
         beq   L3435
         tst   <u0090
         beq   L3415
         dec   <u0090
         ldb   <u008E
         bra   L3417
L3415    ldb   <u008F
L3417    lbsr  L359C
         clr   <u0059
         bra   L3435
L341E    cmpa  #$F0
         lbeq  L32C6
         cmpa  #$F1
         bne   L342F
         cmpy  u0002,u
         bne   L33F2
         bra   L3439
L342F    lda   #$01
         sta   <u00E8
         bra   L33F2
L3435    tst   <u00E8
         bne   L3444
L3439    leay  -$01,y
         lda   #$20
         lbsr  L1CD5
         leay  $01,y
         bra   L33F2
L3444    leay  -$02,y
         lda   #$20
         lbsr  L1CD5
         leay  $02,y
         clr   <u00E8
         bra   L33F2
L3451    lbsr  L32FA
         ldb   <u0088
         addb  <u0029,u
         addb  <u0028,u
         lbsr  L359C
         tst   <u002F,u
         beq   L347B
         lbsr  L3543
         ldy   <u0036
         ldb   #$40
         ldb   b,y
         lda   <u0089
         mul
         std   <u005A
         ldd   <u00DD
         subd  <u005A
         std   <u00DD
         bra   L3484
L347B    ldb   <u008A
         subb  <u0089
         lda   <u0047
         mul
         std   <u00DD
L3484    ldy   ,u
L3487    lda   ,y
         bmi   L3493
L348B    cmpa  #$20
         bne   L349F
         leay  $01,y
         bra   L3487
L3493    cmpa  #$F0
         beq   L349F
         cmpa  #$F1
         beq   L349F
         lda   $01,y
         bra   L348B
L349F    clra
         ldb   <u008A
         subb  <u0089
         subb  <u0088
         decb
         std   <u005A
         lda   <u002C,u
         ldb   <u00E4
         lbsr  L323C
         ldb   <u001B,u
         subb  <u0029,u
         subb  <u0028,u
         mul
         clr   <u0058
         subd  <u00DD
L34BF    subd  <u005A
         bcs   L34C7
         inc   <u0058
         bra   L34BF
L34C7    addd  <u005A
         lda   <u0058
         stb   <u00DC
         beq   L34D0
         inca
L34D0    sta   <u00DB
         lbra  L329D
L34D5    lbsr  L32FA
         tst   <u002F,u
         beq   L34E1
         tst   <u004B
         bne   L34EF
L34E1    ldb   <u0095
         subb  <u008A
         lbcs  L329A
         lbsr  L359C
         lbra  L329D
L34EF    lbsr  L3543
         ldy   ,u
         lda   <u002C,u
         ldb   <u00E4
         lbsr  L323C
         ldb   <u0095
         mul
         subd  <u00DD
         lbcs  L329A
         tst   u0008,u
         beq   L3511
         tst   <u0020,u
         beq   L3518
         bra   L3516
L3511    tst   <u0024,u
         beq   L3518
L3516    asra
         rorb
L3518    std   <u00DD
L351A    subd  #$00FF
         bcs   L3532
         std   <u00DD
         lda   #$FF
         sta   <u00D6
         lda   #$20
         sta   <u00D5
         clr   <u00D7
         lbsr  L1EE1
         ldd   <u00DD
         bra   L351A
L3532    addd  #$00FF
         stb   <u00D6
         lda   #$20
         sta   <u00D5
         clr   <u00D7
         lbsr  L1EE1
         lbra  L329D
L3543    clr   <u00DD
         clr   <u00DE
         ldy   <u0036
         ldx   ,u
L354C    cmpx  <u0063
         bcc   L3568
         cmpx  u0002,u
         bcc   L3568
         ldb   ,x+
         bmi   L3569
         cmpb  <u0030,u
         beq   L3579
L355D    lslb
         clra
         ldb   d,y
         clra
         addd  <u00DD
         std   <u00DD
         bra   L354C
L3568    rts
L3569    cmpb  #$F0
         beq   L3568
         cmpb  #$F1
         bne   L354C
         cmpx  u0002,u
         bne   L354C
         ldb   #$2D
         bra   L355D
L3579    lda   ,x+
         bmi   L3569
         cmpa  <u0030,u
         beq   L354C
         cmpx  u0002,u
         bcs   L3579
         rts
L3587    tst   u0008,u
         beq   L358F
         clrb
         stb   <u0059
         rts
L358F    ldb   <u0028,u
         addb  <u0029,u
         stb   <u0059
         bsr   L359C
         ldb   <u0059
         rts
L359C    stb   <u00E1
         beq   L35A9
L35A0    lda   #$A0
         lbsr  L1CD5
         dec   <u00E1
         bne   L35A0
L35A9    rts
L35AA    ldd   $0F,u
         addd  #$0001
         lbsr  L2CAE
         ldb   #27
         lda   #'-
L35B6    lbsr  OUTREPT
         decb
         bne   L35B6
         lda   #C$SPAC
         lbsr  OUTREPT
         ldx   >PGBS1,pcr  Ptr to "PAGE"
         lbsr  L3731  Write string in X
         ldx   <u0034
         leax  $02,x
         lbsr  L374C  Write string in X
         lda   #C$SPAC
         lbsr  OUTREPT
         lda   #'-
L35D6    lbsr  OUTREPT
         ldb   <u0041 Curr column
         cmpb  <LASTCOL Max column
         bcs   L35D6
         lbsr  OUTREPT
         lbra  L32C9

L35E5    lbsr  L011E  Start dimmed text
         lbsr  L3717
         lbsr  L32FA
         lbsr  L19CB
         clrb
         lda   <u006A
         lbsr  GOROWCOL
         ldx   ,u
         clr   <u009A
L35FB    cmpx  u0006,u
         beq   L360D
         inc   <u009A
         lda   ,x+
         bpl   L35FB
         cmpa  #$F1
         beq   L35FB
         leax  $01,x
         bra   L35FB
L360D    ldy   ,u
         clr   <u0058
         ldb   <LASTCOL Max column
         decb
         tst   <u001C,u
         bne   L362C
         subb  <u0028,u
         bpl   L3625
         cmpb  #$C8
         bcs   L3625
         inc   <u0058
L3625    subb  <u0029,u
         bcc   L362C
         inc   <u0058
L362C    subb  <u009A
         bcc   L3655
         clra
L3631    adda  #$19
         addb  #$19
         bcc   L3631
         inca
         tst   <u001C,u
         bne   L364B
         suba  <u0028,u
         bpl   L3646
         cmpa  #$C8
         bhi   L366A
L3646    suba  <u0029,u
         bcs   L366A
L364B    deca
         beq   L366A
         tst   ,y+
         bpl   L364B
         inca
         bra   L364B
L3655    tst   <u001C,u
         bne   L366A
         ldb   <u0029,u
         addb  <u0028,u
         beq   L366A
         lda   #$20
L3664    lbsr  OUTREPT
         decb
         bne   L3664
L366A    cmpy  u0006,u
         bcc   L3685
         lda   ,y
         bpl   L367E
         cmpa  #$F1
         beq   L3681
         lbsr  L2181
         leay  $02,y
         bra   L366A
L367E    lbsr  L2181
L3681    leay  $01,y
         bra   L366A

L3685    ldb   <u0041 Curr column
         stb   <u0059
         ldb   <u0095
         addb  <u0089
         subb  <u008A
         bls   L36A6
L3691    lda   <u0041 Curr column
         cmpa  <LASTCOL Max column
         bcc   L36FF
         lda   >INSFIL,pcr  character -
         pshs  b
         clrb
         lbsr  L193C
         puls  b
         decb
         bne   L3691
L36A6    ldb   <LASTCOL Max column
         cmpb  <u0041 Curr column
         bls   L36FF
         cmpy  u0002,u
         bcc   L36D4
         lda   ,y
         bpl   L36C4
         cmpa  #$F1
         beq   L36CB
         cmpa  #$F0
         beq   L36D4
         lbsr  L2181
         leay  $02,y
         bra   L36A6

L36C4    lbsr  L2181
L36C7    leay  $01,y
         bra   L36A6

L36CB    leax  $01,y
         cmpx  u0002,u
         bne   L36C7
         lbsr  L2181
L36D4    ldb   <LASTCOL Max column
         lda   #$20
L36D8    cmpb  <u0041 Curr column
         bls   L36E1
         lbsr  OUTREPT
         bra   L36D8

L36E1    ldy   u0002,u
         ldb   -$01,y
         cmpb  #$F0
         bne   L36EE
         lda   >CRCHR,pcr  character |
L36EE    lbsr  OUTREPT
L36F1    lda   <SCRROW
         ldb   <u0059
         lbsr  GOROWCOL
         lbsr  L19D3
         lbsr  L011F   Write txt and stop dimmed
         rts
L36FF    cmpy  u0002,u
         bcc   L36E1
         lda   ,y
         cmpa  #$F1
         bne   L3712
         leax  $01,y
         cmpx  u0002,u
         beq   L3712
         leay  $01,y
L3712    lbsr  L2181
         bra   L36F1

L3717    tst   u0008,u
         beq   L3720
L371B    ldb   <u001F,u
         bra   L372E

L3720    tst   <u001C,u
         bne   L371B
         ldb   <u001B,u
         subb  <u0029,u
         subb  <u0028,u
L372E    stb   <u0095
         rts

* Dim test state, write, undim state?
L3731    pshs  d
         lbsr  L011E  Start dimmed text
         tfr   x,d
         leax  >0,pcr
         leax  d,x
         bra   L3743
L3740    lbsr  OUTREPT
L3743    lda   ,x+
         bne   L3740
         lbsr  L011F   Write txt and stop dimmed
         puls  pc,d

* Write null-terminated string
L374C    pshs  b,a
         lbsr  L011E  Start dimmed text
         bra   L3743

L3753    lbsr  L0167 Read key if entered
         lbra  L0153   Read keyboard

L3759    lbsr  L19DB
         clr   <u00E5
         lda   #$FF
         sta   <u0060
L3762    lbsr  L19D3
         clr   <u004B
         ldu   <u0022
         tst   <u00E5
         bne   L3778
         ldx   >SUPS1,pcr   EDIT menu choice
         ldb   #$0E       14 strings
         lbsr  L50A8
         bra   L377B

L3778    lbsr  L5129
L377B    tsta
         lbeq  L380F
         pshs  a
         lbsr  L45A5
         puls  a
         lsla
         leax  >L3794,pcr
         ldd   a,x
         leax  >0,pcr
         jmp   d,x


L3794    fdb   L380F    Select EDIT
         fdb   L3C94    Select PRINT
         fdb   L3AAD    Select SAVE & RETURN
         fdb   L3B0D    Select SAVE
         fdb   L3C1D    Select SAVE TO MARK
         fdb   L38A6    Select RETURN
         fdb   L392E
         fdb   L383E
         fdb   L382E
         fdb   L381E
         fdb   L38DF
         fdb   L3C5D
         fdb   L4F29    Select WHEEL
         fdb   L5143    Select NEW
         fdb   $0000,$0000

L37B4    ldx   <u001C
         leay  <$37,x
         sty   <u0052
L37BC    lbsr  L0153   Read keyboard
         cmpa  >ESCC,pcr  Escape
         lbeq  L380F
         cmpa  >LNDELC,pcr
         beq   L37EB
         cmpa  >BSC,pcr Backspace
         beq   L37F3
         cmpa  #$0D
         beq   L37DF
         cmpa  #$1F
         bls   L37BC
L37DB    cmpx  <u0052
         beq   L37BC
L37DF    sta   ,x+
         cmpa  #$0D
         beq   L37EA
         lbsr  OUTREPT
         bra   L37BC

L37EA    rts
L37EB    cmpx  <u001C
         beq   L37BC
         bsr   L37FB
         bra   L37EB

L37F3    cmpx  <u001C
         beq   L37BC
         bsr   L37FB
         bra   L37BC

* Remove character
L37FB    leax  -$01,x
         ldd   <SCRROW
         decb
L3800    lbsr  GOROWCOL
         lda   #C$SPAC
         lbsr  OUTREPT
         ldd   <SCRROW
         decb
         lbsr  GOROWCOL
         rts

L380F    ldu   <u0022
         clr   <u004B
         tst   u0008,u
         lbeq  L2A2F
         lbsr  L23D5
         bra   L380F

L381E    ldx   >TTYS1,pcr 'Output set for "TTY" printer.'
         lbsr  WRLINE0 Ask question at 0,0
         lda   >L0010,pcr
         sta   <u0044 Active printer type
         lbra  L3762

L382E    ldx   >SPCLS1,pcr 'Output set for "Specialty" printer.'
         lbsr  WRLINE0 Ask question at 0,0
         lda   >L000E,pcr
         sta   <u0044 Active printer type
         lbra  L3762

L383E    tst   <u004E
         bne   L3846
         tst   <u004F
         beq   L3850
L3846    ldx   >OSPS2,pcr
         lbsr  WRLINE0 Ask question at 0,0
         lbra  L3762

L3850    ldx   >ERMM1,pcr  Ptr to "Erase entire text?"
         lbsr  WRLINE1
         lbsr  L3753 Wait for key
         lbsr  OUTREPT
         lbsr  L1C44
         cmpa  >YCHR,pcr  character Y
         lbne  L3762
         ldx   >EXTM2,pcr  Ptr to "Are you sure?"
         lbsr  WRLINE2
         lbsr  L3753 Wait for key
         lbsr  OUTREPT
         lbsr  L1C44
         cmpa  >YCHR,pcr  character Y
         lbne  L3762
         ldx   #$0000
         lbsr  L2B0C
         lbsr  L2BE8
         ldx   <u0072
         ldy   <u0022
         ldd   #$0037
         lbsr  L45F5
         ldu   <u0022
         ldx   <u0063
         leax  -$01,x
         stx   u0006,u
         stx   u0004,u
         lbsr  L23D5
         clr   <u0061
         lbra  L3762
L38A6    tst   <u004F
         lbne  L3846
         ldx   >EXTM1,pcr  "Is the text secure?"
         lbsr  WRLINE1
         lbsr  L3753 Wait for key
         lbsr  WrA2BUF
         lbsr  L1C44
         cmpa  >YCHR,pcr  character Y
         lbne  L3762
         ldx   >EXTM2,pcr
         lbsr  WRLINE2
         lbsr  L3753 Wait for key
         lbsr  WrA2BUF
         lbsr  L1C44
         cmpa  >YCHR,pcr  character Y
         lbne  L3762
         lbra  L1CCC
L38DF    lda   #$01
         bne   L38EF
         tst   <u004E
         lbne  L3846
         tst   <u004F
         lbne  L3846
L38EF    ldx   >OSPS1,pcr 'OS-9 command:  '
         lbsr  WRLINE0 Ask question at 0,0
         lbsr  L37B4
         ldx   <u001C
         lda   #$0D
L38FD    cmpa  ,x+
         bne   L38FD
         clr   -$01,x
         lbsr  L19DB
         ldx   <u001C
         lbsr  L03C4
         bcc   L3910
         lbsr  L02BF
L3910    lbsr  L3753 Wait for key
         lbra  L3759

WRLINE0    ldd   #$0000
         bra   L3928

WRLINE1  ldd   #$0100   Line 1
         bra   L3928

WRLINE2  ldd   #$0200   Line 2
         bra   L3928

WRLINE3  ldd   #$0300   Line 3
L3928    lbsr  GOROWCOL
         lbra  L3731  Write string in X
L392E    ldx   >SAVM5,pcr
         lbsr  WRLINE0 Ask question at 0,0
         lbsr  L37B4
         leax  -$01,x
         cmpx  <u001C
         lbeq  L3762
         lda   #$01
         sta   <u006F
         ldx   <u001C
         lbsr  L3A2E
         tst   <u0061
         bne   L3982
         ldy   <u001C
         bsr   L3964
         lda   #$01
         sta   <u0061
         ldd   #$0037
         ldx   <u0030
         ldy   <u0032
         lbsr  L45F5
         lbra  L5431
L3964    pshs  y,x,b,a
         ldb   #$37
         ldx   <u0030
L396A    lda   ,y+
         cmpa  #$0D
         beq   L397D
         cmpa  #$20
         beq   L397D
         cmpa  #$2C
         beq   L397D
         sta   ,x+
         decb
         bne   L396A
L397D    clra
         sta   ,x
         puls  pc,y,x,b,a
L3982    lbsr  L0270
         lbcs  L3A03
         ldy   <u006D
         ldx   <u0022
         ldd   $06,x
         std   <u005A
         ldx   ,x
         bra   L399A
L3996    lda   ,x+
         sta   ,y+
L399A    cmpx  <u005A
         bne   L3996
         ldx   <u005A
         leax  >-$00C8,x
         stx   <u0052
L39A6    lbsr  L02E2
         bcs   L39CA
         cmpa  #$20
         bcc   L39B5
         cmpa  #$0D
         bne   L39A6
         lda   #$F0
L39B5    sta   ,y+
         cmpy  <u0052
         bne   L39A6
         lda   #$07
         lbsr  WrA2BUF
         ldx   >DSTM1,pcr
         lbsr  WRLINE2
         bra   L39CC
L39CA    bvc   L3A19
L39CC    lbsr  L0281
         ldu   <u0022
         ldx   u0006,u
         leax  $01,x
         cmpx  <u0063
         bne   L39E1
         lda   -$01,y
         cmpa  #$F0
         bne   L39E1
         leax  $01,x
L39E1    leax  -$01,x
         bra   L39E9
L39E5    lda   ,-y
         sta   ,-x
L39E9    cmpy  <u006D
         bne   L39E5
         ldu   <u0022
         stx   ,u
         stx   u0006,u
         lbsr  L2851
         lbsr  L29C5
         lda   #$FF
         sta   <u0060
         clr   <u0068
         lbra  L3762
L3A03    ldd   #$0100
         lbsr  GOROWCOL
         lbsr  L02BF
         lbsr  L0281
         ldx   >DSTM3,pcr
         lbsr  WRLINE3
         lbra  L3762
L3A19    ldd   #$0100
         lbsr  GOROWCOL
         lbsr  L02BF
         lbsr  L0281
         ldx   >DSTM2,pcr
         lbsr  WRLINE3
         bra   L39CC
L3A2E    pshs  x,a
L3A30    lda   ,x+
         cmpa  #$0D
         beq   L3A3E
         cmpa  #$20
         beq   L3A3E
         cmpa  #$2C
         bne   L3A30
L3A3E    stx   <u0066
         clr   -$01,x
         puls  pc,x,a

L3A44    ldx   <u0030
         lbsr  L0183
         bvs   L3AA3 branch to illegal printer or terminal
         bcc   L3A51
         clr   <u0061
         bra   L3A6F
L3A51    ldx   <u0032
         lbsr  L0183
         bvs   L3AA3 branch to illegal printer or terminal
         bcs   L3A60
         lda   #$02
         sta   <u0061
         bra   L3A6F
L3A60    lda   #$01
         sta   <u0061
         ldd   #$0037
         ldx   <u0030
         ldy   <u0032
         lbsr  L45F5
L3A6F    lbsr  L01D6
         bcc   L3A75
         rts

L3A75    pshs  x
         leax  $01,x
         lbsr  L4A0C
         puls  x
         bcs   L3AA3 branch to illegal printer or terminal
         lda   ,x
         lbsr  L1C44
         cmpa  >CTMCHR,pcr   Character T
         beq   L3A9B
         cmpa  >CPTCHR,pcr   Character P
         beq   L3A9F
         cmpa  >CPGCHR,pcr   Character M
         bne   L3AA3 branch to illegal printer or terminal
         stb   <u0062    Max pages
         bra   L3A6F

L3A9B    stb   <u0045   Terminal type number
         bra   L3A6F

L3A9F    stb   <u0044 Active printer type
         bra   L3A6F

L3AA3    ldx   >DSTM5,pcr 'ILLEGAL PRINTER, TERMINAL, OR FILE NAME'
         lbsr  L3731  Write string in X
         lbra  L0412
L3AAD    lda   #$01
         sta   <u00CA
         clr   <u00C8
         tst   <u004F
         beq   L3B1D
         leax  >L02CA,pcr
         stx   <u0056
         lbra  L3BC9
L3AC0    tst   <u004E
         beq   L3AE9
         ldx   <u0072
L3AC6    lbsr  L02D9
         bcs   L3AE3
         sta   ,x+
         cmpx  <u005E
         bcs   L3AC6
L3AD1    stx   <u0052
         ldx   <u0072
         ldu   <u0056
L3AD7    lda   ,x+
         jsr   ,u
         bcs   L3AED
         cmpx  <u0052
         bcs   L3AD7
         bra   L3AC0
L3AE3    bvc   L3AED
         clr   <u004E
         bra   L3AD1
L3AE9    clr   <u0058
         bra   L3AF1
L3AED    lda   #$01
         sta   <u0058
L3AF1    lbsr  L19DB
         lbsr  L1A24
         tst   <u0058
         beq   L3AFE
         lbsr  L02BF
L3AFE    lbsr  L027B
         lbsr  L0281
         lbsr  L0287
         lbsr  L028D
         lbra  L0412
L3B0D    clr   <u00CA
         clr   <u00C8
         tst   <u004E
         lbne  L3846
         tst   <u004F
         lbne  L3846
L3B1D    leax  >L02D3,pcr
         stx   <u0056
         tst   <u0061
         beq   L3B5E
L3B27    ldx   >SAVM1,pcr
         lbsr  WRLINE0 Ask question at 0,0
         ldx   <u0032
         lbsr  L374C  Write string in X
         ldx   >SAVMB,pcr
         lbsr  L3731  Write string in X
         lbsr  L3753 Wait for key
         lbsr  L1C44
         cmpa  >NCHR,pcr  character N
         beq   L3B5B
         cmpa  >YCHR,pcr  character Y
         beq   L3B50
         cmpa  #$0D
         bne   L3B27
L3B50    lda   >YCHR,pcr  character Y
         lbsr  OUTREPT
         ldx   <u0032
         bra   L3B77
L3B5B    lbsr  OUTREPT
L3B5E    ldx   >SAVM5,pcr
         lbsr  WRLINE1
         lbsr  L37B4
         leax  -$01,x
         cmpx  <u001C
         lbeq  L3762
         ldx   <u001C
         lbsr  L3A2E
         ldx   <u001C
L3B77    stx   <u0052
         lbsr  L021D
         bcc   L3BC9
         bvc   L3BB3
         lbsr  L028D
L3B83    ldx   <u0052
         lbsr  L02E8
         bcc   L3B77
         bvc   L3BB3
         ldx   >SAVM4,pcr
         lbsr  WRLINE2
         lbsr  L3753 Wait for key
         lbsr  L1C44
         cmpa  >YCHR,pcr  character Y
         beq   L3BA3
         cmpa  #$0D
         bne   L3BBC
L3BA3    lda   >YCHR,pcr  character Y
         lbsr  WrA2BUF
         ldx   <u0052
         lbsr  L029F
         bcs   L3BB3
         bra   L3B83
L3BB3    ldd   #$0100
         lbsr  GOROWCOL
         lbsr  L02BF
L3BBC    ldx   >SAVM2,pcr
         lbsr  WRLINE3
         lbsr  L028D
         lbra  L3762
L3BC9    ldy   <u005C
         tst   <u00C8
         bne   L3C29
L3BD0    cmpy  <u006D
         beq   L3BF6
         lda   ,y+
         cmpa  #$F0
         bne   L3BDD
         lda   #$0D
L3BDD    ldx   <u0056
         jsr   ,x
         bcc   L3BD0
L3BE3    ldd   #$0100
         lbsr  GOROWCOL
         lbsr  L02BF
         ldx   >SAVM3,pcr
         lbsr  WRLINE3
         lbra  L3762
L3BF6    ldy   <u0022
         ldy   ,y
L3BFC    cmpy  <u0063
         beq   L3C11
         lda   ,y+
         cmpa  #$F0
         bne   L3C09
         lda   #$0D
L3C09    ldx   <u0056
         jsr   ,x
         bcc   L3BFC
         bra   L3BE3
L3C11    tst   <u00CA
         lbne  L3AC0
L3C17    lbsr  L028D
         lbra  L3762
L3C1D    lbsr  L45B9
         bcs   L3C42
         inc   <u00C8
         clr   <u00CA
         lbra  L3B5E
L3C29    ldu   <u0022
         ldy   u0006,u
L3C2E    cmpy  <u00C3
         beq   L3C17
         lda   ,y+
         cmpa  #$F0
         bne   L3C3B
         lda   #$0D
L3C3B    lbsr  L02D3
         bcc   L3C2E
         bra   L3BE3
L3C42    lda   #$07
         lbsr  WrA2BUF
         ldx   >SVMS1,pcr
         lbsr  WRLINE0 Ask question at 0,0
         lbra  L3762
L3C51    ldd   #$0200
         lbsr  GOROWCOL
         lbsr  L02BF
         lbra  L3762
L3C5D    lda   #$01
         sta   <u00EC
         clr   <u00A2 Stop for new page?
         leax  >L3C88,pcr
         stx   <u0048
         ldx   >SPLS1,pcr
         lbsr  WRLINE0 Ask question at 0,0
         lbsr  L37B4
         ldx   <u001C
         lbsr  L3A2E
         lbsr  L021D
         lbcs  L3BB3
         lbsr  L3D4E
         lbsr  L028D
         lbra  L3D41
L3C88    lbsr  L02D3
         bcs   L3C8E
         rts

L3C8E    lds   <u001E
         lbra  L3C51

* Start printing
L3C94    clr   <u00EC
         leax  >L0122,pcr
         stx   <u0048
         ldx   >PRNS1,pcr  Ptr to "Different printer (Y/N*)? "
         lbsr  WRLINE0 Ask question at 0,0
L3CA3    lbsr  L3753 Wait for key
         cmpa  >ESCC,pcr  Escape
         lbeq  L3762
         cmpa  #$0D
         beq   L3CDE
         lbsr  L1C44
         beq   L3CDE
         cmpa  >NCHR,pcr  character N
         beq   L3CDE
         cmpa  >YCHR,pcr  character Y
         beq   L3CCA
         lda   #$07
         lbsr  WrA2BUF
         bra   L3CA3
L3CCA    lbsr  OUTREPT
         ldx   >PRNS3,pcr
         lbsr  L3731  Write string in X
         lbsr  L37B4
         ldx   <u001C
         lbsr  L3A2E
         bra   L3CEF
L3CDE    lda   >NCHR,pcr  character N
         lbsr  OUTREPT
         ldd   >STYS1,pcr "/p"
         leax  >0,pcr
         leax  d,x
L3CEF    lbsr  L0131  Create file
         bcc   L3D02
         lbvc  L3C51
         ldx   >PRNS2,pcr 'PRINT DRIVER NOT FOUND'
         lbsr  WRLINE2
         lbra  L3762
L3D02    ldx   >PRNS4,pcr 'Stop for new pages (Y/N*)? '
         lbsr  WRLINE1
         clr   <u00A2 Stop for new page?
L3D0B    lbsr  L3753 Wait for key
         cmpa  >ESCC,pcr  Escape
         beq   L3D3E
         lbsr  L1C44
         cmpa  >NCHR,pcr  character N
         beq   L3D35
         cmpa  #$0D
         beq   L3D35
         cmpa  >YCHR,pcr  character Y
         beq   L3D2E
         lda   #$07
         lbsr  WrA2BUF
         bra   L3D0B
L3D2E    lbsr  OUTREPT
         inc   <u00A2 Stop for new page?
         bra   L3D3C
L3D35    lda   >NCHR,pcr  character N
         lbsr  OUTREPT
L3D3C    bsr   L3D4E
L3D3E    lbsr  L014A
L3D41    clr   <u004B
         lda   #$01
         sta   <u006A
         sta   <u006F
         ldu   <u0022
         lbra  L3762
L3D4E    lda   #$20
         sta   <u00D8
         clr   <u00DA
         clr   <u00D9
         clr   <u0047
         clr   <u0046
         lda   >STCS,pcr CHARACTERS/INCH
         lbsr  L3F12
         lda   >STVS,pcr VERTICAL SPACING
         lbsr  L3F25
         lda   #$01
         sta   <u004A
         sta   <u004B
         clr   <u0074
L3D70    lda   #$03
         lbsr  L1A3F
         ldx   >OTXS2,pcr 'Print all pages (Y*/N)? '
         lbsr  WRLINE2
L3D7C    lbsr  L3753 Wait for key
         cmpa  >ESCC,pcr  Escape
         lbeq  L3E6F
         lbsr  L1C44
         cmpa  >NCHR,pcr  character N
         beq   L3DAE
         cmpa  #$0D
         beq   L3DA1
         cmpa  >YCHR,pcr  character Y
         beq   L3DA1
         lda   #$07
         lbsr  WrA2BUF
         bra   L3D7C
L3DA1    lda   >YCHR,pcr  character Y
         lbsr  OUTREPT
         clr   <u00C0
         ldb   #$FF
         bra   L3DD9
L3DAE    lbsr  OUTREPT
         ldx   >OTXS3,pcr
         lbsr  L3731  Write string in X
         lbsr  L37B4
         ldx   <u001C
         lbsr  L4A0C
         bcs   L3D70
         tstb
         beq   L3DC6
         decb
L3DC6    stb   <u00C0
         ldx   >OTXS4,pcr
         lbsr  L3731  Write string in X
         lbsr  L37B4
         ldx   <u001C
         lbsr  L4A0C
         bcs   L3D70
L3DD9    stb   <u00C1
         cmpb  <u00C0
         bls   L3D70
         ldx   #$0000
         lbsr  L2B0C
         lbsr  L2BE8
         ldx   >OTXS1,pcr 'Hit "ESC" to stop, any other key to continue. '
         lbsr  WRLINE3
         ldx   <u0022
         ldy   <u0024
         ldd   #$0037
         lbsr  L45F5
         ldu   <u0024
L3DFC    lda   <u0010,u
         cmpa  <u00C1
         beq   L3E3A
         cmpa  <u00C0
         bcs   L3E35
         lbsr  L3E83
         bcs   L3E6F
         tst   <u00EC
         bne   L3E35
         lbsr  L0170 Char in keyboard buffer
         beq   L3E35
         lbsr  L0153   Read keyboard
         cmpa  #$20
         beq   L3E22
         cmpa  >ESCC,pcr  Escape
         bne   L3E35
L3E22    lbsr  L3753 Wait for key
         cmpa  >ESCC,pcr  Escape
         beq   L3E35
         cmpa  #$20
         beq   L3E35
         cmpa  #$0D
         beq   L3E6F
         bra   L3E22
L3E35    lbsr  L23D5
         bcc   L3DFC
L3E3A    lda   <u001A,u
         cmpa  <u002A,u
         bcc   L3E5F
         deca
         sta   <u002B,u
         clr   u0002,u
         clr   u0004,u
L3E4A    lbsr  L23D5
         lda   <u002B,u
         beq   L3E5F
         lda   <u0010,u
         cmpa  <u00C1
         beq   L3E5F
         bsr   L3E83
         bcs   L3E6F
         bra   L3E4A
L3E5F    ldb   <u002A,u
         subb  <u004A
         incb
L3E65    pshs  b
         lbsr  L3F38
         puls  b
         decb
         bne   L3E65
L3E6F    lda   >STCS,pcr
         lbsr  L3F12
         lda   >STVS,pcr
         lbsr  L3F25
         ldu   <u0022
         lbsr  L23D5
         rts
L3E83    lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L3E95
         tst   <u001C,u
         bne   L3E95
         tst   <u002B,u
         bne   L3E98
L3E95    andcc #^Carry
         rts

L3E98    lda   <u002C,u
         lbsr  L3F12
         lda   <u002D,u
         lbsr  L3F25
         clr   <u00DB
         clr   <u00DC
L3EA8    lda   <u002B,u
         cmpa  <u004A
         beq   L3EDA
         lbsr  L3F38
         lda   <u004A
         inca
         sta   <u004A
         cmpa  <u002A,u
         bls   L3EA8
         lda   #$01
         sta   <u004A
         tst   <u00A2 Stop for new page?
         beq   L3EA8
L3EC4    lbsr  L3753 Wait for key
         cmpa  >ESCC,pcr  Escape
         beq   L3EA8
         cmpa  #$20
         beq   L3EA8
         cmpa  #$0D
         beq   L3ED7
         bra   L3EC4
L3ED7    orcc  #Carry
         rts
L3EDA    ldd   u0002,u
         subd  ,u
         cmpd  #$0001
         bne   L3EE7
         andcc #^Carry
         rts

L3EE7    ldb   <u0017,u
L3EEA    decb
         bmi   L3F0C
         lda   #$20
         sta   <u00D5
         clr   <u00D7
         lda   <u0044 Active printer type
         cmpa  #20
         bne   L3EFF
         lda   #$07
         sta   <u00D6
         bra   L3F03
L3EFF    lda   <u0047
         sta   <u00D6
L3F03    pshs  b
         lbsr  L1EC3
         puls  b
         bra   L3EEA
L3F0C    lbsr  L3249
         andcc #^Carry
         rts

L3F12    ldb   <u0044 Active printer type
         cmpb  #10
         bhi   L3F37
         ldb   <u00E4
         lbsr  L323C
L3F1D    cmpa  <u0047
         beq   L3F37
         lbsr  L3FAF
         rts

L3F25    ldb   <u0044 Active printer type
         cmpb  #10
         bhi   L3F37
         ldb   #$30
         lbsr  L323C
         cmpa  <u0046
         beq   L3F37
         lbsr  L3FD9
L3F37    rts

L3F38    tst   <u00D9
         beq   L3F4D
         clr   <u00D5
         clr   <u00D7
         lbsr  L1EC3
         tst   <u00D4
         beq   L3F4D
         clr   <u00D4
         lda   #$0F
         bsr   L3F53
L3F4D    lda   #$0D
         bsr   L3F53
         lda   #$0A

L3F53    pshs  u
         ldu   <u0048
         jsr   ,u
         puls  pc,u

L3F5B    pshs  a
         lda   <u0044 Active printer type
         cmpa  #20
         beq   L3F81
         bhi   L3F89
         lda   #$04
         lbsr  L3FDB
         lda   #$1B
         bsr   L3F53
         tst   <u0044 Active printer type
         beq   L3F76
         lda   #$39
         bra   L3F78
L3F76    lda   #$0A
L3F78    bsr   L3F53
         lda   <u0046
         lbsr  L3FDB
         puls  pc,a
L3F81    lda   #$1B
         bsr   L3F53
         lda   #$1E
         bsr   L3F53
L3F89    puls  pc,a

L3F8B    pshs  a
         lda   <u0044 Active printer type
         cmpa  #20
         beq   L3FA5
         bhi   L3FAD
         lda   #$04
         lbsr  L3FDB
         lda   #$0A
         bsr   L3F53
         lda   <u0046
         lbsr  L3FDB
         puls  pc,a
L3FA5    lda   #$1B
         bsr   L3F53
         lda   #$1C
         bsr   L3F53
L3FAD    puls  pc,a

L3FAF    sta   <u0047
L3FB1    pshs  a
         lda   <u0044 Active printer type
         beq   L3FC9 branch if type 0
         cmpa  #10
         bne   L3FD7
         lda   #$1B   ESC
         bsr   L3F53
         lda   #$5D   ']
         bsr   L3F53
         lda   ,s
         adda  #$40
         bra   L3FD4
L3FC9    lda   #$1B   ESC Type 0 printer
         bsr   L3F53
         lda   #$1F
         bsr   L3F53
         lda   ,s
         inca
L3FD4    lbsr  L3F53
L3FD7    puls  pc,a

L3FD9    sta   <u0046
L3FDB    pshs  a
         lda   <u0044 Active printer type
         beq   L3FF5
         cmpa  #$0A
         bne   L4005
         lda   #$1B
         lbsr  L3F53
         lda   #$5D   ']
         lbsr  L3F53
         lda   ,s
         adda  #$4F
         bra   L4002
L3FF5    lda   #$1B
         lbsr  L3F53
         lda   #$1E
         lbsr  L3F53
         lda   ,s
         inca
L4002    lbsr  L3F53
L4005    puls  pc,a
L4007    ldb   [<u0006,u]
         bmi   L401D
         clr   <u00C2
         bsr   L403D
         tfr   b,a
         lbsr  L30DA
         ldx   u0006,u
         leax  -$01,x
         stx   u0006,u
         bra   L402C
L401D    cmpb  #$F0
         beq   L403A
         cmpb  #$F1
         beq   L403A
         stb   <u00C2
         bsr   L403D
         stb   [<u0006,u]
L402C    ldy   u0006,u
         clr   <u00CD
         lbsr  L2181
         ldd   <SCRROW
         decb
         lbsr  GOROWCOL
L403A    lbra  L4B5E

L403D    pshs  a
         tst   <u00C2
         beq   L4045
         dec   <u00C2
L4045    cmpa  >ULMCHR,pcr
         beq   L406C
         cmpa  >OLMCHR,pcr
         beq   L4070
         cmpa  >BFMCHR,pcr
         beq   L4074
         cmpa  >SPMCHR,pcr
         beq   L4078
         cmpa  >SBMCHR,pcr
         beq   L4080
         tst   <u00C2
         beq   L4069
         inc   <u00C2
L4069    clrb
         puls  pc,a

* Underline
L406C    ldb   #$01
         bra   L4088
* Overline
L4070    ldb   #$04
         bra   L4088
* Bold
L4074    ldb   #$02
         bra   L4088
* Superscript
L4078    ldb   <u00C2
         andb  #$0F   Remove existing sub-/superscript attribute
         orb   #$40
         bra   L4092
* Subscript
L4080    ldb   <u00C2
         andb  #$0F   Remove existing sub-/superscript attribute
         orb   #$60
         bra   L4092

L4088    lda   <u00C2
         anda  #$70
         bne   L4090
         orb   #$30
L4090    orb   <u00C2
L4092    orb   #$80
         incb
         stb   <u00C2
         puls  pc,a

L4099    lda   [<u0006,u]
         lbpl  L4B5E
         cmpa  #$F0
         lbeq  L4B5E
         cmpa  #$F1
         lbeq  L4B5E
         ldx   u0006,u
         leay  $01,x
         ldd   u0006,u
         sty   u0006,u
         subd  ,u
         lbsr  L45E2
         sty   ,u
         lbra  L402C
L40C0    tst   <u0065
         beq   L40CC
         lda   #$16
         lbsr  L3111
         lbra  L2A80
L40CC    lbsr  L45B9
         lbcs  L2A80
         ldd   <u00C3
         subd  u0006,u
         std   <u00C5
         ldd   ,u
         subd  <u006D
         subd  #$0002
         subd  <u00C5
         bcc   L40EC
         lda   #$17
         lbsr  L3111
         lbra  L2A80
L40EC    ldd   <u00C5
         ldy   <u006D
         ldx   u0006,u
         lbsr  L45F5
         ldd   <u0063
         subd  <u00C3
         subd  #$0002
         ldx   <u00C3
         leax  $02,x
         ldy   u0006,u
         leay  $02,y
         lbsr  L45F5
         sty   <u0063
         lda   #$01
         sta   <u0065
         ldd   <u00C5
         ldx   <u006D
         ldy   <u0063
         lbsr  L45F5
         ldd   u0006,u
         subd  ,u
         ldx   u0006,u
         leay  $02,x
         sty   u0006,u
         lbsr  L45E2
         sty   ,u
L412B    lbsr  L2851
         lbsr  L29C5
         lda   <u006A
         inca
         sta   <u0068
         sta   <u0060
         lbra  L2A65
L413B    tst   <u0065
         bne   L4147
         lda   #$18
         lbsr  L3111
         lbra  L2A80
L4147    ldd   ,u
         subd  <u006D
         subd  <u00C5
         bcc   L4157
         lda   #$17
         lbsr  L3111
         lbra  L2A80
L4157    ldx   <u0063
         ldy   <u006D
         ldd   <u00C5
         lbsr  L45F5
         ldd   <u0063
         subd  u0006,u
         ldx   <u0063
         ldy   <u005E
         sty   <u0063
         lbsr  L45E2
         clr   <u0065
         ldd   <u00C5
         ldx   <u006D
         ldy   u0006,u
         lbsr  L45F5
         lbra  L412B
L417F    tst   <u0065
         bne   L418B
         lda   #$18
         lbsr  L3111
         lbra  L2A80
L418B    ldd   ,u
         subd  <u006D
         cmpd  #$00C8
         bcs   L419F
         subd  <u00C5
         bcs   L419F
         cmpd  #$00C8
         bhi   L41A7
L419F    lda   #$17
         lbsr  L3111
         lbra  L2A80
L41A7    ldd   ,u
         subd  <u00C5
         ldx   ,u
         std   ,u
         ldy   ,u
         stx   <u005A
         ldd   u0006,u
         subd  <u005A
         lbsr  L45F5
         sty   u0006,u
         ldx   <u0063
         ldy   u0006,u
         ldd   <u00C5
         lbsr  L45F5
         lbra  L412B
L41CB    lbsr  L45B9
         lbcs  L2A80
         lda   <u006A
         lbsr  L1A3F
         lda   <u006A
         clrb
         lbsr  GOROWCOL
         ldd   <u00C3
         subd  u0006,u
         lbsr  L2CAE
         ldx   >BDLS1,pcr
         lbsr  L3731  Write string in X
         ldx   <u0034
         lbsr  L374C  Write string in X
         ldx   >BDLS2,pcr
         lbsr  L3731  Write string in X
         lbsr  L1C27
         lbsr  OUTREPT
         anda  #$5F
         cmpa  >YCHR,pcr  character Y
         lbne  L2A65
         ldy   <u00C3
         leay  $02,y
         ldx   u0006,u
         ldd   u0006,u
         subd  ,u
         sty   u0006,u
         lbsr  L45E2
         sty   ,u
         lbra  L412B
L421E    lda   >MRKCHR,pcr
         lbsr  L30DA
         lbsr  L29C5
         lbra  L2A65
L422B    clr   <u00EB
         clr   <u00CB
         lda   #$01
         sta   <u006F
         lda   #$04
         sta   <u006A
         clr   <u00CF
         lbsr  L3249
         lda   <u006A
         inca
         sta   <u0068
         sta   <u0060
L4243    lbsr  L45A5
         ldd   #$0000
         lbsr  GOROWCOL
         ldx   >FNDS1,pcr
         lbsr  L3731  Write string in X
L4253    ldx   <u001C
         stx   <u00B4
         lbsr  L443A
         bcs   L4243
         ldx   <u001C
         pshs  x
         ldd   <u00B4
         subd  ,s++
         cmpd  #$0001
         beq   L4253
L426A    lbsr  L44DF
         lbcs  L42A3
         lda   <u006A
         inca
         sta   <u0068
         sta   <u0060
         ldd   #$0200
         lbsr  GOROWCOL
         ldx   >FNDS2,pcr
         lbsr  L3731  Write string in X
         lda   #$01
         sta   <u0074
         lda   <u006A
         clr   <u00CF
         lbsr  L3249
L4290    lbsr  L1C27
         cmpa  #$0D
         beq   L42A8
         cmpa  >ESCC,pcr  Escape
         beq   L42A8
         cmpa  #$20
         bne   L4290
         bra   L426A
L42A3    lda   #$20
         lbsr  L3111
L42A8    lda   #$04
         sta   <u006A
         lbsr  L31D9
         lda   <u006A
         cmpa  #$04
         beq   L42BA
         inca
         sta   <u0060
         sta   <u0068
L42BA    lbra  L2A2B
L42BD    clr   <u00EB
         clr   <u00CB
         lda   #$01
         sta   <u006F
         clr   <u00A2 Stop for new page?
         lda   #$04
         sta   <u006A
         clr   <u00CF
         lbsr  L3249
         lda   <u006A
         inca
         sta   <u0068
         sta   <u0060
L42D7    lbsr  L45A5
         ldd   #$0000
         lbsr  GOROWCOL
         ldx   >RPLS1,pcr
         lbsr  L3731  Write string in X
         ldx   <u001C
         stx   <u00B4
L42EB    lbsr  L443A
         bcs   L42D7
         ldx   <u001C
         pshs  x
         ldd   <u00B4
         subd  ,s++
         cmpd  #$0001
         beq   L42EB
         ldd   <u00B4
         std   <u00B2
         ldd   #$0100
         lbsr  GOROWCOL
         ldx   >RPLS2,pcr
         lbsr  L3731  Write string in X
         lbsr  L443A
         bcs   L42D7
L4314    lbsr  L44DF
         lbcs  L441C
         tst   <u00A2 Stop for new page?
         bne   L436C
         lda   #$05
         sta   <u0068
         sta   <u0060
         lda   #$02
         lbsr  L1A3F
         lda   #$03
         lbsr  L1A3F
         ldd   #$0200
         lbsr  GOROWCOL
         ldx   >RPLS3,pcr
         lbsr  L3731  Write string in X
         lda   #$01
         sta   <u0074
         lda   #$04
         sta   <u006A
         clr   <u00CF
         lbsr  L3249
L4349    lbsr  L1C27
         cmpa  >ESCC,pcr  Escape
         lbeq  L42A8
         anda  #$5F
         cmpa  >NCHR,pcr  character N
         beq   L43AE
         cmpa  >ACHR,pcr
         beq   L436A
         cmpa  >YCHR,pcr  character Y
         bne   L4349
         bra   L436C
L436A    inc   <u00A2 Stop for new page?
L436C    ldd   <u00B2
         addd  #$0001
         addd  <u00B8
         subd  <u00B6
         subd  <u00B4
         bcs   L43DE
         ldx   u0006,u
         leay  b,x
         ldd   u0006,u
         subd  ,u
         sty   u0006,u
         lbsr  L45E2
         sty   ,u
L438A    ldd   <u00B4
         subd  <u00B2
         subd  #$0001
         ldx   <u00B2
         ldy   u0006,u
         lbsr  L45F5
         sty   <u00CB
         lbsr  L2851
         lbsr  L29C5
         tst   <u00A2 Stop for new page?
         lbne  L4314
         lda   #$05
         sta   <u0060
         sta   <u0068
L43AE    ldd   #$0200
         lbsr  GOROWCOL
         ldx   >FNDS2,pcr
         lbsr  L3731  Write string in X
         lda   #$01
         sta   <u0074
         lda   #$04
         clr   <u00CF
         lbsr  L3249
L43C6    lbsr  L1C27
         cmpa  #$0D
         lbeq  L42A8
         cmpa  >ESCC,pcr  Escape
         lbeq  L42A8
         cmpa  #$20
         bne   L43C6
         lbra  L4314

L43DE    stb   <u0059
         addd  ,u
         subd  <u006D
         bcs   L440D
         cmpd  #$000A
         bcs   L440D
         cmpd  #$00C8
         bhi   L43F7
         lda   #$19
         lbsr  L3111
L43F7    ldx   ,u
         ldb   <u0059
         leay  b,x
         ldd   u0006,u
         subd  ,u
         sty   ,u
         lbsr  L45F5
         sty   u0006,u
         lbra  L438A
L440D    lda   #$1A
         lbsr  L3111
         lda   <u006A
         inca
         sta   <u0068
         sta   <u0060
         lbra  L4421
L441C    lda   #$20
         lbsr  L3111
L4421    lda   #$04
         sta   <u006A
         lbsr  L31D9
         lda   #$04
         cmpa  <u006A
         bne   L4432
         tst   <u00A2 Stop for new page?
         beq   L4437
L4432    inca
         sta   <u0060
         sta   <u0068
L4437    lbra  L2A2B
L443A    lda   >LBCHR,pcr  character {
         ldb   #$02
         lbsr  L193C
         clrb
         ldx   <u00B4
L4446    lbsr  L1C27
         cmpa  >ESCC,pcr  Escape
         lbeq  L42A8
         cmpa  >LNDELC,pcr
         beq   L44C1
         cmpa  #$0D
         beq   L4475
         cmpa  >FLDCHR,pcr
         beq   L44C4
         cmpa  >BSC,pcr Backspace
         beq   L4496
         cmpa  >CRCHR,pcr  character |
         bne   L4471
         lda   #$F0
         bra   L4475
L4471    cmpa  #$20
         bcs   L4446
L4475    sta   b,x
         cmpa  #$0D
         beq   L44B1
         incb
         cmpb  #$32
         bcs   L4489
         lda   #$1F
         lbsr  L3111
         cmpb  #$32
         bhi   L44C1
L4489    cmpa  #$F0
         bne   L4491
         lda   >CRCHR,pcr  character |
L4491    lbsr  OUTREPT
         bra   L4446
L4496    tstb
         beq   L44C1
         pshs  b
         ldd   <SCRROW
         decb
         lbsr  GOROWCOL
         lda   #$20
         lbsr  OUTREPT
         ldd   <SCRROW
         decb
         lbsr  GOROWCOL
         puls  b
         decb
         bra   L4446
L44B1    incb
         abx
         stx   <u00B4
         lda   >RBCHR,pcr  character }
         ldb   #$02
         lbsr  L193C
         andcc #^Carry
         rts

L44C1    orcc  #Carry
         rts

L44C4    lda   #$0D
         sta   b,x
         incb
         abx
         stx   <u00B4
         lda   >RBCHR,pcr  character }
         lbsr  L193C
         ldx   >FNDS3,pcr
         lbsr  L3731  Write string in X
         inc   <u00EB
         andcc #^Carry
         rts

L44DF    ldx   u0006,u
         cmpx  <u00CB
         bhi   L44E9
         ldx   <u00CB
         bra   L44F7
L44E9    lda   ,x+
         bpl   L44F7
         cmpa  #$F0
         beq   L44F7
         cmpa  #$F1
         beq   L44F7
         leax  $01,x
L44F7    stx   <u00B6
         cmpx  <u0063
         bcc   L4532
L44FD    ldy   <u001C
         ldx   <u00B6
L4502    lda   ,x
         tst   <u00EB
         beq   L451E
         cmpa  #$41
         bcs   L451E
         cmpa  #$5A
         bhi   L4514
         adda  #$20
         bra   L451E
L4514    cmpa  #$61
         bcs   L451E
         cmpa  #$7A
         bhi   L451E
         suba  #$20
L451E    ldb   ,x+
         bpl   L4526
         cmpa  #$F0
         bne   L452E
L4526    cmpa  ,y
         beq   L4535
         cmpb  ,y
         beq   L4535
L452E    cmpx  <u0063
         bcs   L4502
L4532    orcc  #Carry
         rts
L4535    stx   <u00B6
         leay  $01,y
         bra   L456D
L453B    lda   ,y
         cmpa  #$0D
         beq   L4573
         lda   ,x
         tst   <u00EB
         beq   L455D
         cmpa  #$41
         bcs   L455D
         cmpa  #$5A
         bhi   L4553
         adda  #$20
         bra   L455D
L4553    cmpa  #$61
         bcs   L455D
         cmpa  #$7A
         bhi   L455D
         suba  #$20
L455D    ldb   ,x+
         bpl   L4565
         cmpa  #$F0
         bne   L456D
L4565    cmpb  ,y+
         beq   L456D
         cmpa  -$01,y
         bne   L44FD
L456D    cmpx  <u0063
         bne   L453B
         bra   L44FD
L4573    cmpx  <u0063
         bcc   L4532
         stx   <u00B8
         ldx   <u00B6
         leax  -$01,x
         stx   <u00B6
         lda   -$01,x
         bpl   L458F
         cmpa  #$F0
         beq   L458F
         cmpa  #$F1
         beq   L458F
         leax  -$01,x
         stx   <u00B6
L458F    ldx   <u00B6
         cmpx  u0002,u
         bcs   L459C
         lbsr  L23D5
         bcs   L45A1
         bra   L458F
L459C    andcc #^Carry
         stx   u0006,u
         rts
L45A1    clr   <u006A
         bra   L4532

L45A5    clra
         lbsr  L1A3F
         lda   #$01
         lbsr  L1A3F
         lda   #$02
         lbsr  L1A3F
         lda   #$03
         lbsr  L1A3F
         rts

L45B9    ldx   u0006,u
L45BB    lda   ,x+
         cmpx  <u0063
         beq   L45DA
         cmpa  >MRKCHR,pcr
         bne   L45BB
         lda   ,x+
         cmpx  <u0063
         beq   L45DA
         cmpa  >MRKCHR,pcr
         bne   L45BB
         leax  -$02,x
         stx   <u00C3
         andcc #^Carry
         rts
L45DA    lda   #$15
         lbsr  L3111
         orcc  #Carry
         rts
L45E2    inca
         pshs  a
         tstb
         bra   L45ED
L45E8    lda   ,-x
         sta   ,-y
         decb
L45ED    bne   L45E8
         dec   ,s
         bne   L45E8
         puls  pc,a

L45F5    inca
         pshs  a
         tstb
         bra   L4600

L45FB    lda   ,x+
         sta   ,y+
         decb
L4600    bne   L45FB
         dec   ,s
         bne   L45FB
         puls  pc,a

L4608    clr   <u0058
         leay  >0,pcr
         ldd   >FMTTBL,pcr
         leay  d,y
L4614    ldx   ,u
         leax  $01,x
L4618    lda   ,x+
         cmpa  #$20
         beq   L463F
         cmpa  #',
         beq   L463F
         lbsr  L1C44
         cmpa  ,y+
         bne   L463F
         tst   ,y
         bne   L4618
         lda   ,x
         cmpa  #$20
         beq   L466A
         cmpa  #$2C
         beq   L466A
         cmpa  #$F0
         beq   L466A
         leay  $01,y
         bra   L4643
L463F    tst   ,y+
         bne   L463F
L4643    inc   <u0058
         tst   ,y
         bne   L4614
L4649    cmpu  <u0022
         bne   L4653
         lda   #$0C
         lbra  L3111
L4653    rts

L4654    cmpu  <u0022
         bne   L4653
         lda   #$0D
         lbra  L3111
         rts

L465F    cmpu  <u0022
         bne   L4653
         lda   #$0E
         lbra  L3111
         rts

L466A    leay  >L4679,pcr
         lda   <u0058
         lsla
         ldd   a,y
         leay  >0,pcr
         jmp   d,y

L4679    fdb   L46D2,L474F,L471B,L46EB
         fdb   L46F5,L46F1,L470A,L47C0
         fdb   L47D2,L4866,L489A,L4653
         fdb   L47F9,L47F2,L4827,L4804
         fdb   L46BB,L48CE,L48EF,L4910
         fdb   L493D,L4959,L495F,L4965
         fdb   L4977,L4989,L499A,L49DE
         fdb   L49ED,L49F8,L4A01,$0000,$0000

L46BB    lbsr  L4A0C
         bcs   L4649
         tst   u0008,u
         bne   L465F
         tst   <u001C,u
         bne   L465F
         cmpb  <u002B,u
         bls   L4654
         stb   <u002B,u
         rts

L46D2    lbsr  L4A0C
         lbcs  L4649
         cmpb  #$00
         bne   L46DF
         ldb   #$01
L46DF    tst   u0008,u
         beq   L46E7
         stb   <u0020,u
         rts
L46E7    stb   <u0024,u
         rts

L46EB    lda   #$01
         sta   <u0025,u
         rts
L46F1    clr   <u0025,u
         rts
L46F5    lbsr  L4A0C
         cmpb  #$00
         bne   L46FE
         ldb   #$01
L46FE    tst   u0008,u
         beq   L4706
         stb   <u0021,u
         rts
L4706    stb   <u0026,u
         rts
L470A    lbsr  L4A0C
         lbcs  L4649
         cmpb  #$78
         lbhi  L4654
         stb   <u0017,u
         rts

L471B    lbsr  L4A0C
         lbcs  L4649
         cmpd  #$000A
         lbcs  L4654
         cmpb  #$64
         lbhi  L4654
         stb   <u002A,u
         tfr   b,a
         suba  <u001D,u
         lbcs  L4654
         suba  <u0019,u
         lbcs  L4654
         cmpa  #$03
         lbls  L4654
         lbsr  L47E7
         lbra  L4653

L474F    lbsr  L4A0C
         lbcs  L4649
         stb   <u0059
         tst   u0008,u
         bne   L4776
         tst   <u001C,u
         bne   L4776
         lda   <u001B,u
         pshs  a
         stb   <u001B,u
         bsr   L478A
         puls  a
         bcc   L4775
         sta   <u001B,u
         lbra  L4654
L4775    rts
L4776    lda   <u001F,u
         stb   <u001F,u
         pshs  a
         bsr   L478A
         puls  a
         bcc   L4775
         sta   <u001F,u
         lbra  L4654
L478A    pshs  a
         lda   <u001F,u
         cmpa  #$96
         bhi   L47B2
         lda   <u0029,u
         adda  <u0028,u
         bmi   L47B2
         lda   <u001B,u
         cmpa  #$96
         bhi   L47B2
         suba  <u0029,u
         bcs   L47B2
         suba  <u0028,u
         cmpa  #$0A
         bcs   L47B2
         andcc #^Carry
         puls  pc,a
L47B2    cmpu  <u0022
         bne   L47BC
         lda   #$0D
         lbsr  L3111
L47BC    orcc  #Carry
         puls  pc,a
L47C0    lbsr  L4A0C
         lbcs  L4649
         tstb
         bne   L47CB
         incb
L47CB    addb  <u002B,u
         stb   <u002B,u
         rts

L47D2    lbsr  L4A0C
         lbcs  L4649
         tstb
         beq   L47E3
         cmpb  #$03
         lbhi  L4654
         decb
L47E3    stb   <u0023,u
         rts

L47E7    lda   <u002A,u
         suba  <u0019,u
         inca
         sta   <u001A,u
         rts

L47F2    lda   <u001A,u
         sta   <u002B,u
         rts

L47F9    lbsr  L4A0C
         lbcs  L4649
         std   <$11,u
         rts

L4804    lbsr  L4A0C
         lbcs  L4649
         tst   u0008,u
         lbne  L465F
         tst   <u001C,u
         lbne  L465F
         lda   <u0029,u
         stb   <u0029,u
         lbsr  L478A
         bcc   L4826
         sta   <u0029,u
L4826    rts

L4827    clr   <u0058
L4829    leax  $01,x
         lda   ,x
         cmpa  #$20
         beq   L4829
         cmpa  #$2C
         beq   L4829
         cmpa  #$2D
         bne   L483D
         com   <u0058
         leax  $01,x
L483D    lbsr  L4A0C
         lbcs  L4649
         tst   <u0058
         beq   L484A
         comb
         incb
L484A    tst   u0008,u
         lbne  L465F
         tst   <u001C,u
         lbne  L465F
         lda   <u0028,u
         stb   <u0028,u
         lbsr  L478A
         bcc   L4826
         sta   <u0028,u
         rts
L4866    tst   <u001C,u
         lbne  L465F
         tst   u0008,u
         lbne  L465F
         lda   #$01
         sta   <u001C,u
         clr   <u001D,u
         cmpu  <u0022
         beq   L4884
         ldd   u0004,u
         bra   L4896
L4884    ldd   <u006D
         ldx   u0004,u
         pshs  u
         ldu   <u0024
         cmpx  <u0015,u
         bne   L4894
         std   <u0015,u
L4894    puls  u
L4896    std   <u0015,u
         rts
L489A    tst   <u001C,u
         lbne  L465F
         tst   u0008,u
         lbne  L465F
         lda   #$02
         sta   <u001C,u
         clr   <u001E,u
         cmpu  <u0022
         beq   L48B8
         ldd   u0004,u
         bra   L48CA
L48B8    ldd   <u006D
         ldx   u0004,u
         pshs  u
         ldu   <u0024
         cmpx  <$13,u
         bne   L48C8
         std   <$13,u
L48C8    puls  u
L48CA    std   <$13,u
         rts

L48CE    lbsr  L4A0C
         lbcs  L4649
         cmpu  <u0022
         bne   L48EB
         cmpb  #$0C
         beq   L48EB
         cmpb  #$0A
         beq   L48EB
         cmpb  #$0F
         beq   L48EB
         lda   #$1E
         lbsr  L3111
L48EB    stb   <u002C,u
         rts

L48EF    lbsr  L4A0C
         lbcs  L4649
         cmpu  <u0022
         bne   L490C
         cmpb  #$04
         beq   L490C
         cmpb  #$08
         beq   L490C
         cmpb  #$06
         beq   L490C
         lda   #$1E
         lbsr  L3111
L490C    stb   <u002D,u
         rts

L4910    lda   #$01
         sta   <u002F,u
         tst   <u004B
         beq   L492E
         lda   <u0044 Active printer type
         cmpa  #20
         bne   L492E
         lda   #$0D
         lbsr  L3F53
         lda   #$1B
         lbsr  L3F53
         lda   #$11
         lbsr  L3F53
L492E    tst   <u00D3
         bne   L493C
         cmpu  <u0022
         bne   L493C
         lda   #$22
         lbra  L3111
L493C    rts

L493D    clr   <u002F,u
         tst   <u004B
         beq   L493C
         lda   <u0044 Active printer type
         cmpa  #20
         bne   L493C
         lda   #$0D
         lbsr  L3F53
         lda   #$1B
         lbsr  L3F53
         lda   #$13
         lbra  L3F53
L4959    bsr   L496B
         sta   <u0030,u
         rts
L495F    bsr   L496B
         sta   <u0032,u
         rts
L4965    bsr   L496B
         sta   <u0031,u
         rts
L496B    lda   ,x+
         cmpa  #$20
         beq   L496B
         cmpa  #$F0
         bne   L4976
         clra
L4976    rts
L4977    lbsr  L4A0C
         lbcs  L4649
L497E    addb  <u002B,u
         cmpb  <u001A,u
         lbcc  L47F2
         rts
L4989    ldb   <u0034,u
         lbsr  L484A
         ldb   <u0036,u
         bsr   L497E
         ldb   <u0035,u
         lbra  L47CB
L499A    clr   <u0058
L499C    leax  $01,x
         lda   ,x
         cmpa  #$20
         beq   L499C
         cmpa  #$2C
         beq   L499C
         cmpa  #$2D
         bne   L49B0
         com   <u0058
         leax  $01,x
L49B0    lbsr  L4A0C
         lbcs  L4649
         tst   <u0058
         beq   L49BD
         comb
         incb
L49BD    tst   u0008,u
         lbne  L465F
         tst   <u001C,u
         lbne  L465F
         lda   <u0028,u
         stb   <u0028,u
         lbsr  L478A
         sta   <u0028,u
         lbcs  L4654
         stb   <u0034,u
         rts
L49DE    lbsr  L4A0C
         lbcs  L4649
         tstb
         bne   L49E9
         incb
L49E9    stb   <u0035,u
         rts
L49ED    lbsr  L4A0C
         lbcs  L4649
         stb   <u0036,u
L49F7    rts
L49F8    tst   <u004B
         beq   L49F7
         lda   #$0C
         lbra  L3F53
L4A01    lbsr  L4A0C
         lbcs  L4649
         stb   <u002E,u
         rts
L4A0C    clra
         clrb
         std   <u005A
L4A10    lda   ,x+
         cmpa  #$20
         beq   L4A10
         cmpa  #$2C
         beq   L4A10
         bra   L4A1E
L4A1C    lda   ,x+
L4A1E    cmpa  #$F0
         beq   L4A57
         cmpa  #$0D
         beq   L4A57
         cmpa  #$20
         beq   L4A57
         cmpa  #$2C
         beq   L4A57
         cmpa  #$2D
         beq   L4A57
         cmpa  <u0030,u
         beq   L4A57
         cmpa  #$30
         bcs   L4A5C
         cmpa  #$39
         bhi   L4A5C
         anda  #$0F
         pshs  a
         ldd   <u005A
         lslb
         rola
         lslb
         rola
         lslb
         rola
         addd  <u005A
         addd  <u005A
         addb  ,s+
         adca  #$00
         std   <u005A
         bra   L4A1C
L4A57    andcc #^Carry
         ldd   <u005A
         rts
L4A5C    orcc  #Carry
         rts

* 'I' key in Escape mode
L4A5F    bsr   L4A64
         lbra  L2A80

L4A64    tst   <u006F
         bne   L4A6C
         ldx   u000B,u
         bra   L4A6E
L4A6C    ldx   u0009,u
L4A6E    leax  -$01,x
         cmpx  #$FFFF
         beq   L4A87
         pshs  x
         lbsr  L2B0C
         ldu   <u0022
         puls  x
         ldy   <u0020
         tst   $08,y
         bne   L4A6E
         bra   L4A8D
L4A87    lda   #$07
         lbsr  L3111
         rts

L4A8D    ldy   <u0020
         ldb   <SCRROW
         clra
         clr   <u0074
         tst   <u006F
         bne   L4A9F
         addd  $0B,y
         subd  u000B,u
         bra   L4AA3
L4A9F    addd  $09,y
         subd  u0009,u
L4AA3    bcc   L4AD2
         cmpb  #$FF
         bne   L4AB9
         inc   <u0060
         tst   <u0043
         beq   L4AC5
         lbsr  L19FF
         lda   #$01
         sta   <u0096
         clrb
         bra   L4ACE
L4AB9    inc   <u0060
         tst   <u0043
         beq   L4AC5
         lbsr  L19FF
         incb
         bne   L4AB9
L4AC5    lda   #$01
         sta   <u0060
         sta   <u0068
         clr   <u0096
         clrb
L4ACE    lda   #$01
         sta   <u0074
L4AD2    tfr   b,a
         clrb
         lbsr  GOROWCOL
         lbsr  L2BE8
         ldu   <u0022
         lbsr  L21F5
         lda   #$01
         sta   <u00CF
         lda   <SCRROW
         sta   <u006A
         lbsr  L3249
         tst   <u0068
         beq   L4AF2
         lbsr  L3183
L4AF2    rts
L4AF3    bsr   L4AF8
         lbra  L2A80
L4AF8    lbsr  L23D5
         bcc   L4B03
         lbsr  L3111
         lbra  L2A80
L4B03    tst   <u006F
         bne   L4B14
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L4AF8
         tst   <u001C,u
         bne   L4AF8
L4B14    lda   <SCRROW
         clr   <u0074
         inca
         cmpa  <LASTROW
         bls   L4B28
         lbsr  L19F1
         lda   #$01
         sta   <u0074
         sta   <u0096
         lda   <LASTROW
L4B28    clrb
         lbsr  GOROWCOL
         cmpa  <u0060
         bcs   L4B32
         sta   <u0074
L4B32    tst   u0008,u
         beq   L4B47
         tst   <u0074
         beq   L4AF8
         clr   <u00CF
         ldb   #$01
         stb   <u0074
         lda   <SCRROW
         lbsr  L3249
         bra   L4AF8
L4B47    ldb   #$01
         stb   <u00CF
         lda   <SCRROW
         lbsr  L3249
         lda   <SCRROW
         sta   <u006A
         tst   <u0074
         beq   L4B5D
         inca
         sta   <u0060
         sta   <u0068
L4B5D    rts

L4B5E    ldx   u0006,u
L4B60    lda   ,x
         bpl   L4B6E
         cmpa  #$F0
         beq   L4B6E
         cmpa  #$F1
         beq   L4B6E
         leax  $01,x
L4B6E    leax  $01,x
         cmpx  u0002,u
         bcs   L4B7B
         lda   <u0098
         sta   <u0071
         lbra  L4AF3

L4B7B    lda   ,x
         cmpa  #$F1
         bne   L4B88
         leay  $01,x
         cmpy  u0002,u
         bne   L4B60
L4B88    stx   u0006,u
         clr   <u00CF
         clr   <u0074
         lda   <u006A
         lbsr  L3249
         lda   <u0041 Curr column
         adda  <u0098
         sta   <u0071
         lbra  L2A80
L4B9C    ldx   u0006,u
L4B9E    cmpx  ,u
         bne   L4BAB
         lda   <u0098
         adda  <LASTCOL Max column
         sta   <u0071
         lbra  L4A5F
L4BAB    tst   ,-x
         bmi   L4B9E
         cmpx  ,u
         beq   L4BBD
         lda   -$01,x
         bpl   L4BBD
         cmpa  #$F1
         beq   L4BBD
         leax  -$01,x
L4BBD    stx   u0006,u
         clr   <u0074
         clr   <u00CF
         lda   <u006A
         lbsr  L3249
         lda   <u0041 Curr column
         adda  <u0098
         sta   <u0071
         lbra  L2A80
L4BD1    lda   <u0098
         sta   <u0071
         lda   #$01
         sta   <u00CF
         clr   <u0074
         lda   <u006A
         lbsr  L3249
         lbsr  L1C27
         lbsr  L1C44
         cmpa  >CURLRC,pcr
         lbne  L2A8F
         lda   <u0098
         adda  <LASTCOL Max column
         sta   <u0071
         lda   <u006A
         lbsr  L3249
         lbra  L2A80
L4BFC    tst   <SCRROW
         bne   L4C03
         lbsr  L4AF8
L4C03    lbsr  L19F1
         tst   <u0096
         bne   L4C16
         lda   <u0060
         deca
         cmpa  <SCRROW
         bls   L4C16
         sta   <u0060
         lbra  L2A80
L4C16    lda   <SCRROW
         inca
         sta   <u0060
         sta   <u0068
         clr   <u0096
         lbra  L2A80
L4C22    tst   <u006F
         beq   L4C2A
         ldd   u0009,u
         bra   L4C2C
L4C2A    ldd   u000B,u
L4C2C    subb  <SCRROW
         sbca  #$00
         subd  #$0001
         std   <u0091
         bcc   L4C3F
         lda   #$07
         lbsr  L3111
         lbra  L2A80
L4C3F    lda   <SCRROW
         cmpa  <LASTROW
         bne   L4C48
         lbsr  L4A64
L4C48    lda   <u0060
         inca
         cmpa  <LASTROW
         bcc   L4C51
         sta   <u0060
L4C51    tst   <u0043
         beq   L4C71
         lbsr  L19FF
         lda   #$01
         sta   <u0096
         ldx   <u0091
         lbsr  L2B0C
         ldu   <u0020
         lbsr  L21F5
         lda   #$01
         sta   <u0074
         clra
         lbsr  L3249
         lbra  L2A80
L4C71    lda   <u006A
         inca
         sta   <u006A
         inca
         sta   <u0060
         sta   <u0068
         clr   <u0096
         lbsr  L31D9
         lbra  L2A65
L4C83    tst   <u006F
         beq   L4C8B
         ldd   u0009,u
         bra   L4C8D
L4C8B    ldd   u000B,u
L4C8D    cmpd  #$0001
         bne   L4C9B
         lda   #$07
         lbsr  L3111
         lbra  L2A80
L4C9B    subb  <SCRROW
         sbca  #$00
         subb  <LASTROW
         sbca  #$00
         bcc   L4CA7
         clra
         clrb
L4CA7    tfr   d,x
         clr   <u009F
         lbsr  L2B0C
L4CAE    tst   u0008,u
         bne   L4CC5
         tst   <u006F
         bne   L4CE1
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L4CDC
         tst   <u001C,u
         beq   L4CE1
         bra   L4CDC
L4CC5    lda   <u009F
         cmpa  <LASTROW
         bcs   L4CD3
         lbsr  L19F1
         lda   <LASTROW
         deca
         sta   <u009F
L4CD3    ldb   #$01
         stb   <u0074
         lbsr  L3249
         inc   <u009F
L4CDC    lbsr  L23D5
         bra   L4CAE
L4CE1    lbsr  L2BE8
         ldu   <u0022
         lda   <u009F
         sta   <u006A
         inca
         sta   <u0060
         sta   <u0068
         clr   <u0096
         lbra  L2A65
L4CF4    lda   <SCRROW
         sta   <u009B
         bra   L4D07
L4CFA    lda   <u009B
         cmpa  <LASTROW
         beq   L4D20
         inc   <u009B
L4D02    lbsr  L23D5
         bcs   L4D20
L4D07    tst   u0008,u
         beq   L4D1A
L4D0B    lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L4D02
         tst   <u001C,u
         bne   L4D02
         bra   L4CFA
L4D1A    tst   <u006F
         beq   L4D0B
         bra   L4CFA
L4D20    clr   <u006A
L4D22    tst   u0008,u
         bne   L4D39
         tst   <u006F
         bne   L4D58
         tst   <u001C,u
         bne   L4D51
         lda   [,u]
         cmpa  >PRCCHR,pcr
         bne   L4D58
         bra   L4D51
L4D39    ldb   #$01
         sta   <u0074
         clr   <u00CF
         lda   <u006A
         lbsr  L3249
         lda   <u006A
         cmpa  <LASTROW
         bne   L4D4F
         lbsr  L19F1
         dec   <u006A
L4D4F    inc   <u006A
L4D51    lbsr  L23D5
         bcs   L4D58
         bra   L4D22
L4D58    tst   <u006F
         bne   L4D70
         tst   <u001C,u
         bne   L4D69
         lda   [,u]
         cmpa  >PRCCHR,pcr
         bne   L4D70
L4D69    lda   #$01
         sta   <u006F
         lbsr  L31D9
L4D70    lda   <u006A
         inca
         sta   <u0060
         sta   <u0068
         lbra  L2A65
L4D7A    lbsr  L30BD
         clr   u0006,u
         clr   <u0074
         sta   <u0071
         lda   #$01
         sta   <u00CF
         clr   <u0074
         lda   <u006A
         lbsr  L3249
         lbra  L2A80
L4D91    lda   <u006A
         lbsr  L1A3F
         lda   <u006A
         clrb
         lbsr  GOROWCOL
         ldx   >PAGS1,pcr         Ptr to "*** page ="
         lbsr  L3731  Write string in X
         ldx   <u001C
L4DA5    lbsr  L1C27
         anda  #$7F
         cmpa  >ESCC,pcr  Escape
         lbeq  L2A65
         cmpa  #$0D
         beq   L4DDC
         lbsr  OUTREPT
         cmpa  #$30
         bcs   L4DC5
         cmpa  #$39
         bhi   L4DC5
         sta   ,x+
         bra   L4DA5
L4DC5    lbsr  L1C44
         cmpa  >PAGC,pcr
         beq   L4DD6
         lda   #$21
         lbsr  L3111
         lbra  L2A65
L4DD6    clr   <u0098
         ldd   <u0050
         bra   L4DEE
L4DDC    sta   ,x
         ldx   <u001C
         lbsr  L4A0C
         bcs   L4DC5
         cmpd  #$0000
         beq   L4DEE
         subd  #$0001
L4DEE    std   <u00BA
         ldd   #$0000
         lbsr  GOROWCOL
         ldd   <u00BA
         cmpd  $0F,u
         bls   L4E4F
L4DFD    lbsr  L23D5
         bcc   L4E0C
         ldb   #$08
         stb   <u006A
         lbsr  L3111
         lbra  L2A2F

L4E0C    ldd   $0F,u
         cmpd  <u00BA
         bne   L4DFD
L4E13    lda   #$01
         sta   <u0074
         lda   <SCRROW
         lbsr  L3249
         lda   <SCRROW
         cmpa  <LASTROW
         bcs   L4E25
         lbsr  L19F1
L4E25    ldd   <SCRROW
         inca
         lbsr  GOROWCOL
L4E2B    lbsr  L23D5
         tst   u0008,u
         bne   L4E13
         tst   <u006F
         bne   L4E43
         tst   <u001C,u
         bne   L4E2B
         lda   [,u]
         cmpa  >PRCCHR,pcr
         beq   L4E2B
L4E43    lda   <SCRROW
         sta   <u006A
         inca
         sta   <u0060
         sta   <u0068
         lbra  L2A2B
L4E4F    ldd   <u00BA
         subd  <u0050
         bcc   L4E58
         ldd   #$0000
L4E58    lda   #$37
         mul
         ldx   <u0072
         leax  d,x
         ldy   <u0020
         ldd   #$0037
         lbsr  L45F5
         lbsr  L2BE8
         bra   L4E13
L4E6D    lda   <u0098
         cmpa  #$96
         bcc   L4E7A
         adda  #$19
         sta   <u0098
         lbra  L2A55
L4E7A    lda   #$02
         lbsr  L3111
         lbra  L2A80

L4E82    lda   <u0098
         beq   L4E7A
         suba  #$19
         bcs   L4E7A
         sta   <u0098
         lbra  L2A55
L4E8F    clr   <u0058
         lbsr  L1C27
         cmpa  #$20
         lbcs  L2AA5
         cmpa  #$7F
         lbeq  L2AA5
         sta   <u0077
         lbsr  L1C44
         cmpa  #$41
         bcs   L4EAD
         cmpa  #$5A
         bls   L4EAF
L4EAD    inc   <u0058
L4EAF    ldy   u0006,u
         lda   ,y
         bpl   L4EBE
         cmpa  #$F1
         lbeq  L2A80
         lda   $01,y
L4EBE    lbsr  L1C44
         cmpa  #$41
         bcs   L4EC9
         cmpa  #$5A
         bls   L4ECB
L4EC9    inc   <u0058
L4ECB    lda   <u0077
         tst   ,y
         bpl   L4ED5
         sta   $01,y
         bra   L4ED7
L4ED5    sta   ,y
L4ED7    lbsr  L2181
         tst   <u0058
         lbeq  L4B5E
         lbsr  L2851
         lbsr  L29C5
         tst   <u0068
         bne   L4EF1
         lda   <u006A
         inca
         sta   <u0068
         sta   <u0060
L4EF1    lda   #$01
         sta   <u0074
         clr   <u00CF
         ldu   <u0022
         lda   <u006A
         lbsr  L3249
         lbra  L4B5E
L4F01    lbsr  L1C27
         cmpa  #$20
         lbcs  L2AA5
         cmpa  #$7F
         lbcc  L2AA5
         lbsr  L30DA
         lbsr  L2851
         lbsr  L29C5
         tst   <u0068
         lbne  L2A65
         lda   <u006A
         inca
         sta   <u0068
         sta   <u0060
         lbra  L2A65
L4F29    ldx   #$0001
         ldu   <u0022
         cmpx  u0009,u
         bcc   L4F3E
         lbsr  L2B0C
         lbsr  L2BE8
         lda   #$01
         sta   <u006A
         sta   <u006F
L4F3E    ldx   >PSWS3,pcr
         lbsr  WRLINE0 Ask question at 0,0
         ldx   >PSWS1,pcr
         lbsr  L3731  Write string in X
         ldx   >PSWS4,pcr
         lbsr  L3731  Write string in X
L4F53    lbsr  L3753 Wait for key
         lbsr  L1C44
         cmpa  #$0D
         beq   L4F84
         cmpa  >YCHR,pcr  character Y
         beq   L4F84
         cmpa  >NCHR,pcr  character N
         beq   L4F70
         lda   #$07
         lbsr  WrA2BUF
         bra   L4F53
L4F70    lbsr  OUTREPT
         ldx   >PSWS5,pcr
         lbsr  WRLINE1
         lbsr  L37B4
         ldx   <u001C
         lbsr  L3A2E
         bra   L4F93
L4F84    lda   #$59
         lbsr  OUTREPT
L4F89    ldd   >PSWS1,pcr
         leax  >0,pcr
         leax  d,x
L4F93    lbsr  L022A
         bcs   L4FB2
L4F98    ldx   <u001C
L4F9A    lbsr  L02E2
         bcs   L4FA9
         anda  #$7F
         sta   ,x+
         cmpa  #$0D
         bne   L4F9A
         bra   L4FC5
L4FA9    pshs  cc
         lbsr  L0281
         puls  cc
         bvs   L4FBE
L4FB2    ldd   #$0000
         lbsr  GOROWCOL
         lbsr  L02BF
         lbra  L4FEE
L4FBE    lda   #$01
         sta   <u00D3
         lbra  L3762
L4FC5    ldx   <u001C
         lda   ,x
         cmpa  #$0D
         beq   L4F98
         bsr   L4FFD
         lbcs  L4FEE
         ldy   <u0036
         lsla
         tfr   a,b
         clra
         leay  d,y
         bsr   L4FFD
         lbcs  L4FEE
         sta   ,y
         bsr   L4FFD
         lbcs  L4FEE
         sta   $01,y
         bra   L4F98
L4FEE    clr   <u00D3
         ldx   >PSWS2,pcr
         lbsr  WRLINE2
         lbsr  L0281
         lbra  L3762
L4FFD    clr   <u0058
L4FFF    lda   ,x
         cmpa  #$20
         beq   L5009
         cmpa  #$2C
         bne   L500D
L5009    leax  $01,x
         bra   L4FFF
L500D    leax  $01,x
         cmpa  #$2D
         bne   L5017
         inc   <u0058
         lda   ,x+
L5017    cmpa  #$24
         beq   L5030
         cmpa  #$27
         beq   L502C
         leax  -$01,x
         lbsr  L4A0C
         bcs   L5085
         tfr   b,a
         leax  -$01,x
         bra   L5059
L502C    lda   ,x+
         bra   L5059
L5030    lda   ,x+
         bsr   L5088
         bcs   L5085
         sta   <u0059
         lda   ,x+
         cmpa  #$20
         beq   L5057
         cmpa  <u0030,u
         beq   L5057
         cmpa  #$2C
         beq   L5057
         bsr   L5088
         bcs   L5085
         lsl   <u0059
         lsl   <u0059
         lsl   <u0059
         lsl   <u0059
         adda  <u0059
         bra   L5059
L5057    lda   <u0059
L5059    tst   <u0058
         beq   L505F
         suba  #$40
L505F    anda  #$7F
         sta   <u0059
L5063    lda   ,x
         cmpa  #$20
         beq   L507A
         cmpa  #$2C
         beq   L507A
         cmpa  <u0030,u
         beq   L507E
         cmpa  #$0D
         beq   L507A
         cmpa  #$F0
         bne   L5080
L507A    leax  $01,x
         bra   L5063
L507E    leax  $01,x
L5080    lda   <u0059
         andcc #^Carry
         rts
L5085    orcc  #Carry
         rts
L5088    cmpa  #$30
         bcs   L50A5
         cmpa  #$39
         bhi   L5095
         suba  #$30
         andcc #^Carry
         rts
L5095    lbsr  L1C44
         cmpa  #$41
         bcs   L5095
         cmpa  #$46
         bhi   L50A5
         suba  #$37
         andcc #^Carry
         rts

L50A5    orcc  #Carry
         rts

*
* Display supervisor menu
*
L50A8    stb   <u00E5
         tfr   x,d
         leax  >0,pcr
         leax  d,x
         lda   #$04
L50B4    ldb   #$03
         lbsr  GOROWCOL
         lbsr  L374C  Write string in X
         lda   <SCRROW
         inca
         ldb   <SCRROW
         subb  #$03
         cmpb  <u00E5
         bne   L50B4
         ldd   #$1303
         lbsr  GOROWCOL
         ldx   >BANNER,pcr
         lbsr  L3731  Write string in X
L50D4    clr   <u00E6

L50D6    lda   #C$SPAC
         lbsr  OUTREPT
         lda   <u00E6
         adda  #$04
         clrb
         lbsr  GOROWCOL
         lda   #'>
         lbsr  OUTREPT
         ldd   <SCRROW
         decb
         lbsr  GOROWCOL
L50EE    lbsr  L0153   Read keyboard
         lbsr  L1C44
         cmpa  #$0D    Select item in supervisor menu
         beq   L5124
         cmpa  >ESCC,pcr  Escape
         beq   L5127
         cmpa  >CURUC,pcr   check 'I' key
         beq   L5115
         cmpa  >CURDC,pcr   check ',' key
         bne   L50EE
* Move down in supervisor mode
         lda   <u00E6
         inca
         cmpa  <u00E5
         bcc   L50D4
         inc   <u00E6
         bra   L50D6

* Move up in supervisor mode
L5115    tst   <u00E6
         bne   L5120
         lda   <u00E5
         deca
         sta   <u00E6
         bra   L50D6

L5120    dec   <u00E6
         bra   L50D6

* Make selection in supervisor menu
L5124    lda   <u00E6
         rts

L5127    clra
         rts
L5129    clrb
         lda   #$04
L512C    clrb
         lbsr  GOROWCOL
         lda   #$20
         lbsr  OUTREPT
         lda   <SCRROW
         inca
         ldb   <SCRROW
         subb  #$04
         cmpb  <u00E5
         bne   L512C
         lbra  L50D4

L5143    clr   <u004C
         clr   <u004D
         ldd   $0F,u
         cmpd  <u0050
         bne   L5158
         ldx   >NEWM1,pcr
         lbsr  WRLINE0 Ask question at 0,0
         lbra  L51F5
L5158    clra
         lbsr  L1A3F
         ldx   >NEWM3,pcr
         lbsr  WRLINE0 Ask question at 0,0
         lbsr  L3753 Wait for key
         lbsr  L1C44
         cmpa  >ESCC,pcr  Escape
         lbeq  L3762
         cmpa  >NCHR,pcr  character N
         lbeq  L5237
         cmpa  #$0D
         beq   L518A
         cmpa  >YCHR,pcr  character Y
         beq   L518A
L5183    lda   #$07
         lbsr  WrA2BUF
         bra   L5143
L518A    lda   >YCHR,pcr  character Y
         lbsr  WrA2BUF
         inc   <u004C
         tst   <u004F
         bne   L51F5
         tst   <u0061
         beq   L51CC
         ldx   >NEWM4,pcr
         lbsr  WRLINE1
         ldx   <u0032
         lbsr  L374C  Write string in X
         ldx   >NEWM5,pcr
         lbsr  L3731  Write string in X
         lbsr  L3753 Wait for key
         lbsr  L1C44
         cmpa  >ESCC,pcr  Escape
         lbeq  L3762
         cmpa  >YCHR,pcr  character Y
         beq   L51F5
         cmpa  #$0D
         beq   L51F5
         cmpa  >NCHR,pcr  character N
         bne   L5183
L51CC    lda   #$01
         lbsr  L1A3F
         ldx   >SAVM5,pcr
         lbsr  WRLINE1
         lbsr  L37B4
         leax  -$01,x
         cmpx  <u001C
         lbeq  L3762
         ldx   <u001C
         lbsr  L3A2E
         ldy   <u0032
         ldd   #$0036
         lbsr  L45F5
         lda   #$02
         sta   <u0061
L51F5    tst   <u004E
         bne   L5202
         ldx   >NEWM9,pcr
         lbsr  WRLINE2
         bra   L523A
L5202    ldx   >NEWM6,pcr
         lbsr  WRLINE2
         lbsr  L3753 Wait for key
         lbsr  L1C44
         cmpa  >ESCC,pcr  Escape
         lbeq  L3762
         cmpa  >YCHR,pcr  character Y
         beq   L522C
         cmpa  #$0D
         beq   L522C
         cmpa  >NCHR,pcr  character N
         bne   L5202
         lbsr  OUTREPT
         bra   L523A
L522C    lda   >YCHR,pcr  character Y
         lbsr  OUTREPT
         inc   <u004D
         bra   L523A
L5237    lbsr  OUTREPT
L523A    tst   <u004C
         lbeq  L5357
         tst   <u004F
         bne   L5297
L5244    ldx   <u0032
         lbsr  L01F0
         bcc   L5295
         lbvc  L5417
         ldx   <u0032
L5251    lbsr  L02E8
         bcc   L5244
         lbvc  L5417
L525A    ldx   >SAVM4,pcr
         lbsr  WRLINE3
         lbsr  L3753 Wait for key
         lbsr  L1C44
         cmpa  >ESCC,pcr  Escape
         lbeq  L3762
         cmpa  >NCHR,pcr  character N
         lbeq  L3762
         cmpa  >YCHR,pcr  character Y
         beq   L5283
         cmpa  #$0D
         lbne  L525A
L5283    lda   >YCHR,pcr  character Y
         lbsr  WrA2BUF
         ldx   <u0032
         lbsr  L029F
         lbcs  L5417
         bra   L5251
L5295    inc   <u004F
L5297    ldu   <u0022
         ldd   $0F,u
         subd  <u0050
         lda   #$37
         mul
         ldy   <u0072
         leay  d,y
         sty   <u0054
         ldx   $04,y
         stx   <u0052
         ldu   <u0054
         ldx   <$13,u
         beq   L52C8
         cmpx  <u003A
         beq   L52C8
         ldy   <u003A
         sty   <$13,u
         ldd   #$01F2
         lbsr  L45F5
         lda   #$F0
         sta   ,y
L52C8    ldx   <u0015,u
         beq   L52E2
         cmpx  <u0038
         beq   L52E2
         ldy   <u0038
         sty   <u0015,u
         ldd   #$01F2
         lbsr  L45F5
         lda   #$F0
         sta   ,y
L52E2    ldx   <u005C
L52E4    cmpx  <u0052
         bcc   L5306
         lda   ,x+
         cmpa  #$F0
         bne   L52F0
         lda   #$0D
L52F0    lbsr  L02CA
         bcc   L52E4
         ldd   #$0200
         lbsr  GOROWCOL
         lbsr  L02BF
         lbsr  L0287
         clr   <u004F
         lbra  L3762
L5306    ldy   <u0020
         ldx   <u0054
         ldd   #$0037
         lbsr  L45F5
         lbsr  L2BE8
         ldy   <u005C
         sty   <u006D
         ldu   <u0022
         ldx   #$0000
         stx   ,u
         stx   u0009,u
         stx   u000B,u
         ldy   <u0072
         ldx   <u0022
         ldd   #$0037
         lbsr  L45F5
         ldy   <u0072
         ldd   $0F,y
         std   <u0050
         ldd   <u005C
         std   $04,y
         ldd   $0F,u
         std   <u0080
         ldd   #$FFFF
         std   <u007E
         ldx   <u002A
         stx   <u0084
         clr   <u0093
         clr   <u0086
         ldu   <u0022
L534E    tst   u0008,u
         beq   L5357
         lbsr  L23D5
         bra   L534E
L5357    tst   <u004D
         lbeq  L3762
L535D    ldu   <u0022
         tst   u0008,u
         beq   L5367
         ldd   u0004,u
         bra   L5369
L5367    ldd   ,u
L5369    std   <u005A
         ldx   <u006D
         leax  >$01F4,x
         cmpx  <u005A
         bcs   L5384
         leax  >NEWM7,pcr
         lbsr  WRLINE3
         lda   #$07
         lbsr  WrA2BUF
         lbra  L3762
L5384    ldd   <u0063
         subd  #$0001
         subd  <u005A
         ldx   <u005A
         ldy   <u006D
         lbsr  L45F5
         ldx   <u0063
         leax  <-100,x
         stx   <u0056
         leax  <-50,x
         stx   <u0054
         leax  >-1000,x
         stx   <u0052
         tfr   y,x
         tst   <u004D
         bne   L53B8
L53AB    lbsr  L02D9
         bcs   L53D5
         bita  #$60
         bne   L53BA
         cmpa  #$0D
         bne   L53AB
L53B8    lda   #$F0
L53BA    sta   ,x+
         cmpx  <u0052
         bcs   L53AB
         cmpa  #$F0
         beq   L53E6
         cmpx  <u0054
         bcs   L53AB
         cmpa  #$20
         beq   L53E6
         cmpx  <u0056
         bcs   L53AB
         tsta
         bmi   L53AB
         bra   L53E6
L53D5    bvs   L53E1
         ldx   >DSTM2,pcr
         lbsr  WRLINE2
         lbsr  L02BF
L53E1    lbsr  L027B
         clr   <u004E
L53E6    tfr   x,d
         subd  <u006D
         ldy   <u0063
         pshs  a
         lda   -$01,x
         cmpa  #$F0
         puls  a
         beq   L53F9
         leay  -$01,y
L53F9    lbsr  L45E2
         ldu   <u0022
         tst   u0008,u
         bne   L5407
         sty   ,u
         bra   L540A
L5407    sty   u0004,u
L540A    lbsr  L21F5
         lbsr  L2851
L5410    tst   <u00E7
         beq   L5448
         lbra  L3762
L5417    lda   #$02
         lbsr  L1A3F
         lda   #$03
         lbsr  L1A3F
         ldx   >NEWM8,pcr
         lbsr  L3731  Write string in X
         lbsr  L02BF
         bra   L5410
L542D    tst   <u0061
         beq   L5448
L5431    ldx   <u0030
         lbsr  L0249
         bcc   L5443
         bvs   L5448
         lbsr  L02BF
         lbsr  L1A24
         lbra  L0412
L5443    inc   <u004E
         lbra  L535D
L5448    inc   <u00E7
         tst   >L0011,pcr
         lbeq  L3759
         lbsr  L19DB
         clr   <u00E5
         lda   #$FF
         sta   <u0060
         lbra  L4F89
         emod
BINEND   equ   *
