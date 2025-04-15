         nam   KBVDIO
         ttl   Device driver for keyboard and video I/O
* Dragon device driver
* The display chip does not have lower case characters. Those are instead
* displayed as green on black background. There are therefore only 64 chars
* From 0 to 63 green on black: @ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^(<)
* From 64 to 127: Same but black on green. I.e. adding 64 inverts the character.
* From 128 to 255: Block graphics. 8 color combinations with 16 blocks
* Green, Yellow, Blue, Brown, White, Dark green, Cyan, Red


         ifp1
         use   defsfile
         endc
p0ddra   equ   $FF00    ; Data direction register
p0cra    equ   $FF01    ; Control register
p0ddrb   equ   $FF02
p0crb    equ   $FF03
p1ddra   equ   $FF20
p1ddrb   equ   $FF22

* VDG/PIA and SAM addresses
*
vdgpia   equ   $FF22    ; Port B of PEA - VDG control
samv0c   equ   $FFC0    ; Used to clear V0
samv0s   equ   $FFC1    ; Used to set V0
samv1c   equ   $FFC2    ; Used to clear V1
samv1s   equ   $FFC3    ; Used to set V1 
samv2c   equ   $FFC4    ; Used to clear V2
samv2s   equ   $FFC5    ; Used to set V2 
samf0c   equ   $FFC6    ; Base address of F0-F6

* Graphics modes
mode6c   equ   $E0      ; four color mode 6 pages
mode6r   equ   $F0      ; two color mode 6 pages

MINY     equ   0
MAXY     equ   191

tylg     set   Drivr+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size

         rmb   29
alphaSt  rmb   2    Start of memory area for alpha display
alphaend rmb   2
alphapos rmb   1    Cursor offset from start of memory area
u0022    rmb   1
chrUnder rmb   1    Character under cursor
colorFmt rmb   1    Can be 1 or -1 ($FF)
ExtraArg rmb   1  How many extra args for a command to expect
Routine  rmb   2
ArgBuf1  rmb   1
ArgBuf2  rmb   2
u002B    rmb   1
gfxalloc rmb   1
gfxaddr  rmb   2
gfxend   rmb   2    gfxaddr + $1800
bitTable rmb   2
u0033    rmb   1
gcursorX rmb   1           Graphics cursor X
gcursor  equ   gcursorX    For two-byte operations
gcursorY rmb   1           Graphics cursor Y
drawColr rmb   1
currColr rmb   1
pixMask    rmb   2
colrCode rmb   1    Color code 0-15
KBPIA    rmb   2    Contains address of PIA0
u003D    rmb   1    Some sort of shift lock?
u003E    rmb   1
u003F    rmb   1
u0040    rmb   1
u0041    rmb   1
u0042    rmb   1
u0043    rmb   1
u0044    rmb   1
shftpres    rmb   1
ctrlpres rmb   1
u0047    rmb   1
lastChar rmb   1      Last char in unread buffer
nextChar rmb   1      Next unread char
readBuf  rmb   128     Buffer for incoming chars

size     equ   .
         fcb   $07 
name     equ   *
         fcs   /KBVDIO/
         fcb   $04 
start    equ   *
         lbra  Init
         lbra  Read
         lbra  Write
         lbra  GetStat
         lbra  SetStat
         lbra  Term

* Init
*
* Entry:
*    Y  = address of device descriptor
*    U  = address of device memory area
*
* Exit:
*    CC = carry set on error
*    B  = error code
*
Init     lbsr  L02BA Allocate 512 bytes ram
         lbra  L002D
L002D    pshs  cc
         orcc  #IRQMask
         stu   >D.KbdSta   Keyboard scanner static storage 
         ldd   >D.IRQ
         std   >D.AltIRQ copy current IRQ address to alternative
         leax  >AltIRQ,pcr
         stx   >D.IRQ install own driver
         ldx   #p0ddra
         stx   KBPIA,u
         clra  
         clrb  
         std   <lastChar,u
         sta   $01,x        Clear FF01
         sta   $00,x        Clear FF00
         sta   $03,x        Clear FF03
         comb  
         stb   <u003D,u     Set to $FF
         stb   $02,x        Set FF02 all output
         stb   <u003F,u
         stb   <u0040,u
         stb   <u0041,u
         lda   #%00110100
         sta   $01,x
         lda   #%00111111
         sta   $03,x
         lda   $02,x
         puls  pc,cc
         ldb   #E$Write
         orcc  #Carry
         rts   

* Getstat
* Input: U = Address of device static storage
*        Y = Address of path descriptor
*        A = Status code
GetStat  cmpa  #SS.Ready
         bne   L0082
         lda   <nextChar,u
         suba  <lastChar,u
         bne   Exit00
         ldb   #E$NotRdy
         bra   L009A
L0082    cmpa  #SS.EOF
         beq   Exit00
         cmpa  #SS.DStat
         lbeq  DispStat
         cmpa  #SS.Joy
         lbeq  JoyStkV
         cmpa  #SS.AlfaS
         lbeq  AlfaStat

* SetStat
*
* Entry:
*    A  = function code
*    Y  = address of path descriptor
*    U  = address of device memory area
*
* Exit:
*    CC = carry set on error
*    B  = error code
*
SetStat  ldb   #E$UnkSvc
L009A    orcc  #Carry
         rts   

* Term
*
* Entry:
*    U  = address of device memory area
*
* Exit:
*    CC = carry set on error
*    B  = error code
*
Term     pshs  cc
         orcc  #IRQMask
         ldx   >D.AltIRQ
         stx   >D.IRQ
         puls  pc,cc


* Increment B and check it is under $7F
L00A9    incb  
         cmpb  #$7F
         bls   L00AF
Exit00   clrb  
L00AF    rts   

AltIRQ   ldu   >D.KbdSta
         ldx   KBPIA,u      Set x to $FF00
         lda   $03,x        Read $FF03
         bmi   L00BE        Is there an IRQ?
         jmp   [>D.SvcIRQ]

L00BE    lda   $02,x lower IRQ
         lda   #$FF
         sta   $02,x        Force output on all lines
         lda   ,x
         coma  
         anda  #$03
         bne   L00D4
         clr   $02,x
         lda   ,x
         coma  
         anda  #$7F
         bne   L00F1
L00D4    clra  
         coma  
         sta   <u003F,u
         sta   <u0040,u
         sta   <u0041,u

* Stop the drive motor after a while
DOWNDISK lda   >D.DskTmr
         beq   L00ED
         deca  
         sta   >D.DskTmr
         bne   L00ED
         sta   >$FF48 select drive 0, stop motor
L00ED    jmp   [>D.AltIRQ]

L00F1    bsr   L013F
         bmi   DOWNDISK
         sta   <u0047,u
         cmpa  #$1F
         bne   L0101
         com   <u003D,u
         bra   DOWNDISK

L0101    ldb   <lastChar,u
         leax  <readBuf,u
         abx   
         bsr   L00A9
         cmpb  <nextChar,u
         beq   L0112
         stb   <lastChar,u
L0112    sta   ,x
         beq   L0132
         cmpa  V.PCHR,u
         bne   L0122
         ldx   V.DEV2,u
         beq   L0132
         sta   $08,x
         bra   L0132

* Send interrupt
* A holds the character
L0122    ldb   #S$Intrpt      Keyboard interrupt
         cmpa  V.INTR,u
         beq   L012E
         ldb   #S$Abort      Keyboard abort
         cmpa  V.QUIT,u
         bne   L0132
L012E    lda   V.LPRC,u
         bra   L0136
L0132    ldb   #S$Wake
         lda   V.WAKE,u
L0136    beq   L013B
         os9   F$Send   
L013B    clr   V.WAKE,u
         bra   DOWNDISK

* X contains $FF00
L013F    clra  
         sta   <u003E,u
         sta   shftpres,u
         sta   ctrlpres,u
         coma  
         sta   <u0042,u
         sta   <u0043,u
         sta   <u0044,u
         deca  
         sta   $02,x
L0156    lda   ,x
         coma  
         anda  #$7F
         beq   L0169
         ldb   #$FF
L015F    incb  
         lsra  
         bcc   L0165
         bsr   L01AF
L0165    cmpb  #$06
         bcs   L015F
L0169    inc   <u003E,u
         orcc  #Carry
         rol   $02,x
         bcs   L0156
         lbsr  L01F8
         bmi   L01AE
         suba  #$1B
         bcc   L0191    Map key if it is over $1B
         adda  #$1B
         ldb   ctrlpres,u
         bne   L0190
         adda  #$40
         ldb   shftpres,u
         eorb  <u003D,u
         andb  #$01
         bne   L0190
         adda  #$20
L0190    rts   

* Map keys
* Result is returned in A
L0191    ldb   #$03
         mul   
* Test if SHIFT is pressed
         lda   shftpres,u
         beq   L019C
         incb  
         bra   L01A3
* Test if CTRL is pressed
L019C    lda   ctrlpres,u
         beq   L01A3
         addb  #$02

L01A3    pshs  x
         leax  >KEYMAP,pcr
         clra  
         lda   d,x
         puls  x
L01AE    rts   

* Investigate what key is read
L01AF    pshs  b
         cmpb  #$06
         beq   L01BF
         cmpb  #$01
         bhi   L01BD
         addb  #$04
         bra   L01BF
L01BD    subb  #$02
L01BF    lslb  
         lslb  
         lslb  
         addb  <u003E,u
         cmpb  #$31
         bne   L01CE
         inc   ctrlpres,u
         puls  pc,b

L01CE    cmpb  #$37
         bne   L01D7
         com   shftpres,u   Set shift is pressed flag
         puls  pc,b

L01D7    pshs  x
         leax  <u0042,u
         bsr   L01E2
         puls  x
         puls  pc,b

L01E2    pshs  a
         lda   ,x
         bpl   L01EC
         stb   ,x
         puls  pc,a

L01EC    lda   $01,x
         bpl   L01F4
         stb   $01,x
         puls  pc,a
L01F4    stb   $02,x
         puls  pc,a

L01F8    pshs  y,x,b
         leax  <u003F,u
         ldb   #$03
         pshs  b
L0201    leay  <u0042,u
         ldb   #$03
         lda   ,x
         bmi   L021D
L020A    cmpa  ,y
         bne   L0214
         clr   ,y
         com   ,y
         bra   L021D
L0214    leay  $01,y
         decb  
         bne   L020A
         lda   #$FF
         sta   ,x
L021D    leax  $01,x
         dec   ,s
         bne   L0201
         leas  $01,s
         leax  <u0042,u
         lda   #$03
L022A    ldb   ,x+
         bpl   L0235
         deca  
         bne   L022A
         orcc  #Negative
         puls  pc,y,x,b

L0235    leax  <u003F,u
         bsr   L01E2
         tfr   b,a
         puls  pc,y,x,b

* Keyboard mapping: See user manual appendix D
* letter keys are not mapped by index.
* First byte: normal
* Second byte: shift
* Third byte: ctrl (clear key)

KEYMAP
* Up arrow key
         fcb   $0C
         fcb   $1C
         fcb   $13
* Down arrow key
         fcb   $0A
         fcb   $1A
         fcb   $12
* Left arrow key (backspace)
         fcb   $08
         fcb   $18
         fcb   $10
* Right arrow key
         fcb   $09
         fcb   $19
         fcb   $11 
* Space key
         fcb   $20
         fcb   $20
         fcb   $20

         fcb   '0     $30
         fcb   '0     $30
         fcb   $1F

         fcb   '1     $31
         fcb   '!     $21
         fcb   '|     $7C

         fcb   '2     $32
         fcb   '"     $22
         fcb   $00

         fcb   '3     $33
         fcb   '#     $23
         fcb   $7E

         fcb   '4     $34
         fcb   '$     $24
         fcb   $00

         fcb   '5     $35
         fcb   '%     $25
         fcb   $00

         fcb   '6     $36
         fcb   '&     $26
         fcb   $00

         fcb   '7     $37
         fcb   ''     $27
         fcb   $5E

         fcb   '8     $38
         fcb   '(     $28
         fcb   $5B

         fcb   '9     $39
         fcb   ')     $29
         fcb   ']     $5D

         fcb   ':     $3A
         fcb   '*     $2A
         fcb   $00

         fcb   ';     $3B
         fcb   '+     $2B
         fcb   $00

         fcb   ',     $2C
         fcb   '<     $3C
         fcb   $7B

         fcb   '-     $2D
         fcb   '=     $3D
         fcb   $5F

         fcb   '.     $2E
         fcb   '>     $3E
         fcb   $7D

         fcb   '/     $2F
         fcb   '?     $3F
         fcb   $5C
* Enter key
         fcb   $0D
         fcb   $0D
         fcb   $0D
* Clear key (used for Ctrl)
         fcb   $00
         fcb   $00
         fcb   $00
* Break key
         fcb   $05
         fcb   $03
         fcb   $1B

* Read
*
* Entry:
*    Y  = address of path descriptor
*    U  = address of device memory area
*
* Exit:
*    A  = character read
*    CC = carry set on error
*    B  = error code
*
Read     leax  readBuf,u
         ldb   <nextChar,u
         orcc  #IRQMask
         cmpb  <lastChar,u
         beq   L029F
         abx               Add B to X
         lda   ,x
         lbsr  L00A9
         stb   <nextChar,u
         andcc #^(IRQMask+Carry)
         rts   

L029F    lda   V.BUSY,u
         sta   V.WAKE,u
         andcc #^IRQMask
         ldx   #$0000
         os9   F$Sleep  
         clr   V.WAKE,u
         ldx   <D.Proc
L02AF    ldb   <P$Signal,x
         beq   Read
         cmpb  #$04
         bcc   Read
         coma  
         rts   

L02BA    pshs  y,x
         clr   ExtraArg,u
         clr   <gfxalloc,u
         pshs  u
         ldd   #$0300
         os9   F$SRqMem  Request alpha buffer + 256 byte
         tfr   u,d
         tfr   u,x
         bita  #$01      Check that it is on an even page boundary
         beq   L02D8
         leax  >$0100,x
         bra   L02DC

L02D8    leau  >$0200,u
L02DC    ldd   #$0100
         os9   F$SRtMem    Return redundant page
         puls  u
         stx   <alphaSt,u
         clra  
         clrb  
         bsr   DISPMOD
         stx   <alphapos,u
         leax  >$0200,x
         stx   <alphaend,u
         lbsr  L0459
         lda   #$60
         sta   <chrUnder,u
         sta   <u002B,u
         clrb  
         puls  pc,y,x

* Set display mode
* Input registers: A - mode
* B = 0 - alpha, B = 1 - two color mode, B = 3 - four color mode
*    $00 = Alpha mode
*    $E0 = 4-color resolution mode
*    $F0 = high resolution mode

DISPMOD  pshs  x,a
         lda   >vdgpia
         anda  #$07
         ora   ,s+
         sta   >vdgpia
         tstb  
         bne   L0320
         stb   >samv0c   Clear V0
         stb   >samv1c   Clear V1
         stb   >samv2c   Clear V2
         lda   <alphaSt,u
         bra   L032C

L0320    stb   >samv0c     Clear V0
         stb   >samv1s     Set V1
         stb   >samv2s     Set V2
         lda   <gfxaddr,u
L032C    ldb   #$07
         ldx   #samf0c
         lsra  
L0332    lsra  
         bcs   L033B
         sta   ,x+
         leax  $01,x
         bra   L033F
L033B    leax  $01,x
         sta   ,x+
L033F    decb  
         bne   L0332
         clrb  
         puls  pc,x

* Write
*
* Entry:
*    A  = character to write
*    Y  = address of path descriptor
*    U  = address of device memory area
*
* Exit:
*    CC = carry set on error
*    B  = error code
*
Write    ldb   ExtraArg,u
         bne   L0387
         tsta  
         bmi   DispChar
         cmpa  #$1F
         bls   CtrlCode     go to control codes
         cmpa  #$7C         if | display inverted exclamation point
         bne   L0359
         lda   #$61
         bra   DispChar

L0359    cmpa  #$7E         if ~ display inverted minus
         bne   L0361
         lda   #$6D
         bra   DispChar

L0361    cmpa  #$60
         bcs   L036B
         suba  #$20
         ora   #$40
         bra   DispChar
L036B    cmpa  #$40
         bcs   DispChar
         suba  #$40

DispChar ldx   <alphapos,u
         eora  #$40
         sta   ,x+        Write char to display area
         stx   <alphapos,u
         cmpx  <alphaend,u
         bcs   L0382
         bsr   ScrolScr
L0382    lbsr  DispCrsr
         clrb  
         rts   

L0387    cmpb  #$01
         beq   L0394
         clr   ExtraArg,u
         sta   <ArgBuf2,u
         jmp   [<Routine,u]

L0394    sta   <ArgBuf1,u
         inc   ExtraArg,u
Exit0    clrb
         rts   

* Scroll screen one line up
ScrolScr ldx   <alphaSt,u
         leax  <$20,x
L03A2    ldd   ,x++
         std   <-$22,x
         cmpx  <alphaend,u
         bcs   L03A2
         leax  <-$20,x
         stx   <alphapos,u
         lda   #$20
         ldb   #$60
L03B6    stb   ,x+       * Blank out bottom line
         deca  
         bne   L03B6
L03BB    rts   

* Control codes
CtrlCode cmpa  #C$EOF
         bcc   L03BB
         cmpa  #$10
         bcs   L03CE
         ldb   <gfxalloc,u
         bne   L03CE
         ldb   #E$NotRdy
         orcc  #Carry
         rts   

L03CE    leax  <L03D6,pcr
         lsla
         ldd   a,x
         jmp   d,x

* Jump table
L03D6    fdb   Exit0-L03D6    * 00
         fdb   L0467-L03D6   01 = Home
         fdb   L047B-L03D6   02 = Cursor XY
         fdb   L04A6-L03D6   03 = Erase line
         fdb   Exit0-L03D6   04
         fdb   Exit0-L03D6   05
         fdb   L044B-L03D6   06 = Cursor right
         fdb   Exit0-L03D6   07
         fdb   L043D-L03D6   08 = Cursor left
         fdb   L04B8-L03D6   09 = Cursor up
         fdb   L0424-L03D6   10 = Cursor down
         fdb   Exit0-L03D6   11
         fdb   L0459-L03D6   12 = Clear screen
         fdb   L040C-L03D6   13 = Carriage return
         fdb   L04C8-L03D6   14 = Display Alpha
         fdb   L0520-L03D6   15 = Display graphics
         fdb   L0604-L03D6   16 = Preset screen
         fdb   L05DF-L03D6   17 = Set color
         fdb   QuitGFX-L03D6   18 = Quit graphics
         fdb   L0624-L03D6   19 = Erase graphics
         fdb   L062F-L03D6   20 = Home graphics cursor
         fdb   L0648-L03D6   21 = Set graphics cursor
         fdb   DrawLine-L03D6   22 = Draw line
         fdb   L06B0-L03D6   23 = Erase line
         fdb   SetPoint-L03D6   24 = Set point
         fdb   L065A-L03D6   25 = Erase point
         fdb   Circle-L03D6   26 = Draw circle


* Return cursor to leftmost column
L040C    bsr   RstrChar
         tfr   x,d
         andb  #%11100000
         stb   <u0022,u

DispCrsr ldx   <alphapos,u
         lda   ,x
         sta   <chrUnder,u
         lda   #$20
         sta   ,x
         andcc #^Carry
         rts   

* Cursor down
L0424    bsr   RstrChar
         leax  <$20,x
         cmpx  <alphaend,u
         bcs   L0438
         leax  <-$20,x
         pshs  x
         lbsr  ScrolScr
         puls  x
L0438    stx   <alphapos,u
         bra   DispCrsr

* Cursor left
L043D    bsr   RstrChar
         cmpx  <alphaSt,u
         bls   L0449
         leax  -$01,x
         stx   <alphapos,u
L0449    bra   DispCrsr

* Cursor right
L044B    bsr   RstrChar
         leax  $01,x
         cmpx  <alphaend,u
         bcc   L0457
         stx   <alphapos,u
L0457    bra   DispCrsr

* Clear screen
L0459    bsr   L0467
         lda   #$60
L045D    sta   ,x+
         cmpx  <alphaend,u
         bcs   L045D
         lbra  DispCrsr

* Home cursor
L0467    bsr   RstrChar
         ldx   <alphaSt,u
         stx   <alphapos,u
         lbra  DispCrsr

* Returns the cursor position in X
RstrChar ldx   <alphapos,u
         lda   <chrUnder,u
         sta   ,x
         rts   

L047B    leax  <L0481,pcr
         lbra  StRt2Arg
L0481    bsr   RstrChar
         ldb   <ArgBuf2,u
         subb  #$20
         lda   #$20
         mul   
         addb  <ArgBuf1,u
         adca  #$00
         subd  #$0020
         addd  <alphaSt,u
         cmpd  <alphaend,u
         bcc   L04A3
         std   <alphapos,u
         lbsr  DispCrsr
         clrb  
L04A3    lbra  DispCrsr

* Erase line
L04A6    lbsr  L040C
         ldb   #$20
         lda   #$60
         ldx   <alphapos,u
L04B0    sta   ,x+
         decb  
         bne   L04B0
         lbra  DispCrsr

* Cursor up
L04B8    bsr   RstrChar
         leax  <-$20,x
         cmpx  <alphaSt,u
         bcs   L04C5
         stx   <alphapos,u
L04C5    lbra  DispCrsr

* Display alpha
L04C8    clra  
         clrb  
         lbra  DISPMOD

* Return display status
AlfaStat ldx   PD.RGS,y
         ldd   <alphaSt,u
         std   R$X,x
         ldd   <alphapos,u
         std   R$Y,x
         ldb   <u003D,u
         stb   R$A,x
         clrb  
         rts   

* Color codes 
L04E0    fcb %00000000,%01010101,%10101010,%11111111

* Get display status
* Returns X = address of graphics display
* Y = Graphics cursor address
* A = Color code
DispStat lda   gfxalloc,u
         bne   L04EE
         ldb   #E$NotRdy
         orcc  #Carry
         rts   

* Get pixel value
L04EE    ldd   <gcursor,u
         lbsr  ByteOfXY
         tfr   a,b
         andb  ,x
L04F8    bita  #$01
         bne   L0507
         lsra  
         lsrb  
         tst   <colorFmt,u
         bmi   L04F8
         lsra  
         lsrb  
         bra   L04F8

* Get graphics coords and base address
L0507    pshs  b
         ldb   <colrCode,u
         andb  #$FC         Mask last two bits of color code
L050E    orb   ,s+
         ldx   $06,y
         stb   $01,x
         ldd   <gcursor,u
         std   $06,x
         ldd   <gfxaddr,u
         std   $04,x
         clrb  
         rts   

* Display graphics
L0520    leax  <L0526,pcr
         lbra  StRt2Arg

L0526    ldb   <gfxalloc,u
         bne   L0566
         pshs  u
         ldd   #$1900
         os9   F$SRqMem    Request graphics buffer
         tfr   u,d
         puls  u
         bcs   L0585
         tfr   a,b
         bita  #$01
         beq   L0543
         adda  #$01
         bra   L0545
L0543    addb  #$18
L0545    pshs  u,a
         tfr   b,a
         clrb  
         tfr   d,u
         ldd   #$0100
         os9   F$SRtMem    Return redundant page
         puls  u,a
         bcs   L0585
         clrb  
         std   <gfxaddr,u
         addd  #$1800
         std   <gfxend,u
         inc   <gfxalloc,u
         lbsr  L0624
L0566    lda   <ArgBuf2,u
         sta   <colrCode,u
         anda  #$03
         leax  >L04E0,pcr
         lda   a,x
         sta   <drawColr,u
         sta   <currColr,u
         lda   <ArgBuf1,u   Get graphics mode (0 or 1)
         cmpa  #$01
         bls   SetGMode
         ldb   #E$BMode
         orcc  #Carry
L0585    rts   

* Set Graphics mode
* INPUT: A: mode  0 = two color, 1 = four color
SetGMode tsta  
         beq   L05A6
* Four color mode
         ldd   #%1100000000000011
         std   <pixMask,u
         lda   #$01
         sta   <colorFmt,u
         lda   #mode6c
         ldb   <ArgBuf2,u
         andb  #$08          Color set 3 or 4
         beq   L059F
         lda   #mode6r
L059F    ldb   #$03
         leax  <bitmask4,pcr
         bra   L05BE

* Two color mode
L05A6    ldd   #%1000000000000001
         std   <pixMask,u
         lda   #$FF
         sta   <drawColr,u
         sta   <currColr,u
         sta   <colorFmt,u
         lda   #mode6r
         ldb   #$07
         leax  <bitmask2,pcr
L05BE    stb   <u0033,u
         stx   <bitTable,u
         ldb   <ArgBuf2,u
         andb  #$04
         lslb  
         pshs  b
         ora   ,s+
         ldb   #$01
         lbra  DISPMOD

bitmask4 fcb %11000000,%00110000,%00001100,%00000011

bitmask2 fcb $80,$40,$20,$10,$08,$04,$02,$01

* Set color
L05DF    leax  <L05E4,pcr
         lbra  NextArg

L05E4    clr   <ArgBuf1,u
         lda   <colorFmt,u
L05EB    bmi   L05F0
         inc   <ArgBuf1,u
L05F0    lbra  L0566

* Quit graphics
* Does not switch to alpha mode
QuitGFX  pshs  u
         ldu   <gfxaddr,u
         ldd   #$1800
         os9   F$SRtMem 
         puls  u
         clr   <gfxalloc,u
         rts   

* Preset screen
L0604    leax  <L060A,pcr
         lbra  NextArg

L060A    lda   <ArgBuf2,u
         tst   <colorFmt,u
         bpl   L061A
         ldb   #$FF
         anda  #$01
         beq   L0624
         bra   L0625
L061A    anda  #$03
         leax  >L04E0,pcr
         ldb   a,x
         bra   L0625

* Erase graphics
L0624    clrb
L0625    ldx   <gfxaddr,u
L0628    stb   ,x+
         cmpx  <gfxend,u
         bcs   L0628

* Home graphics cursor
L062F    clra  
         clrb  
         std   <gcursor,u
         rts   

VerifyXY ldd   <ArgBuf1,u
         cmpb  #192       Check that Y is below 192
         bcs   L063E
         ldb   #MAXY
L063E    tst   <colorFmt,u
         bmi   L0644
         lsra  
L0644    std   <ArgBuf1,u
         rts   

* Set graphics cursor
L0648    leax  <SetCur1,pcr
StRt2Arg stx   <Routine,u     Store routine and expect two byte args
         inc   ExtraArg,u
         clrb  
         rts   

SetCur1  bsr   VerifyXY
         std   <gcursor,u
         clrb  
         rts   

* Erase point
L065A    clr   <drawColr,u
         bra   SetPoint

* Set point (Draw a pixel)
SetPoint leax  <SetPnt1,pcr
         bra   StRt2Arg

SetPnt1  bsr   VerifyXY
         std   <gcursor,u
         bsr   PutPixel
         lda   <currColr,u
         sta   <drawColr,u
         clrb  
         rts   

* A,B contains the X,Y coordinates
PutPixel bsr   ByteOfXY
         tfr   a,b
         comb  
         andb  ,x
         stb   ,x
         anda  <drawColr,u
         ora   ,x
         sta   ,x         Write the pixel
         rts   

* Find the address of the byte to modify
* A,B contains the X,Y coordinates
* Returns with the address in Reg X and bit mask in Reg A
ByteOfXY pshs  y,b,a
         ldb   <colorFmt,u
         bpl   L068C      * Branch if two color mode
         lsra  
L068C    lsra  
         lsra  
         pshs  a
         ldb   #MAXY
         subb  $02,s
         lda   #$20
         mul   
         addb  ,s+
         adca  #$00
         ldy   <gfxaddr,u
         leay  d,y
         lda   ,s
         sty   ,s
         anda  <u0033,u
         ldx   <bitTable,u
         lda   a,x
         puls  pc,y,x

* Erase line
L06B0    clr   <drawColr,u
         bra   DrawLine

* Draw line
DrawLine leax  <Line2,pcr
         bra   StRt2Arg

CurrBit  equ   $00
EndBit   equ   $01
EndAddr  equ   $02
XDir     equ   $06

Line2    lbsr  VerifyXY
         leas  -$0E,s
         std   $0C,s      Store end coordinates
         bsr   ByteOfXY    Returns end address in X, and bit mask in A
         stx   EndAddr,s
         sta   EndBit,s
         ldd   <gcursor,u
         bsr   ByteOfXY
         sta   CurrBit,s
         clra  
         clrb  
         std   $04,s
         lda   #MAXY
         suba  <gcursorY,u
         sta   <gcursorY,u
         lda   #MAXY
         suba  <ArgBuf2,u
         sta   <ArgBuf2,u
         lda   #$FF
         sta   XDir,s
         clra  
         ldb   <gcursorX,u
         subb  <ArgBuf1,u
         sbca  #$00
         bpl   L06F7
         nega  
         negb  
         sbca  #$00
         neg   XDir,s
L06F7    std   $08,s
         bne   L0700
         ldd   #$FFFF
         std   $04,s
L0700    lda   #$E0
         sta   $07,s
         clra  
         ldb   <gcursorY,u
         subb  <ArgBuf2,u
         sbca  #$00
         bpl   L0715
* Negative delta Y
         nega  
         negb  
         sbca  #$00
         neg   $07,s
* Positive delta Y
L0715    std   $0A,s
         bra   L0721

* Line drawing loop
LineLoop sta   CurrBit,s
         ldd   $04,s
         subd  $0A,s
         std   $04,s

L0721    lda   CurrBit,s
         tfr   a,b
         anda  <drawColr,u
         comb  
         andb  ,x
         pshs  b
         ora   ,s+
         sta   ,x
         cmpx  EndAddr,s
         bne   L073B
         lda   CurrBit,s
         cmpa  EndBit,s
         beq   EndLine
L073B    ldd   $04,s
         bpl   StepX
         addd  $08,s
         std   $04,s
         lda   $07,s
         leax  a,x
         bra   L0721

StepX    lda   CurrBit,s
         ldb   XDir,s
         bpl   L075F

* Draw left - A shifts by 1 (or 2 depending on mode)
         lsla  
         ldb   <colorFmt,u
         bmi   L0756
         lsla  
L0756    bcc   LineLoop
         lda   <pixMask+1,u
         leax  -$01,x
         bra   LineLoop

* Draw right
L075F    lsra  
         ldb   <colorFmt,u
         bmi   L0766
         lsra  
L0766    bcc   LineLoop
         lda   <pixMask,u
         leax  $01,x
         bra   LineLoop

* Update coordinates and draw color
EndLine  ldd   $0C,s       Load end coordinates
         std   <gcursor,u
         leas  $0E,s       Reset stack pointer
         lda   <currColr,u
         sta   <drawColr,u
         clrb  
         rts   

* Draw circle command
* Uses Bresenham's algorithm
Circle   leax  <Circle1,pcr

NextArg  stx   <Routine,u
         com   ExtraArg,u
         clrb  
         rts   

CircleX  equ   $00
CircleY  equ   $01
Pk       equ   $02

* Takes radius from Argbuf2
Circle1  leas  -$04,s
         ldb   <ArgBuf2,u
         stb   CircleY,s
         clra  
         sta   CircleX,s
         addb  CircleY,s
         adca  #0
         nega  
         negb  
         sbca  #0
         addd  #3     Pk = 3-(2*radius)
         std   Pk,s
L07A0    lda   CircleX,s
         cmpa  CircleY,s
         bcc   EndCircl
         ldb   CircleY,s
         bsr   PLOT8
         clra  
         ldb   Pk,s
         bpl   L07BA
         ldb   CircleX,s
         lslb  
         rola  
         lslb  
         rola  
         addd  #6       Pk = (Pk+(4*x)+6)
         bra   L07CA

L07BA    dec   CircleY,s
         clra  
         ldb   CircleX,s
         subb  CircleY,s
         sbca  #0
         lslb  
         rola  
         lslb  
         rola  
         addd  #10       Pk = Pk+((4*(x-y)+10))
L07CA    addd  Pk,s
         std   Pk,s
         inc   CircleX,s
         bra   L07A0

* End circle drawing
EndCircl lda   ,s
         cmpa  CircleY,s
         bne   L07DC
         ldb   CircleY,s
         bsr   PLOT8
L07DC    leas  $04,s
         clrb  
         rts   

Xorg     equ   $00
Yorg     equ   $02
Xneg     equ   $04
Yneg     equ   $06

* Input: A contains X coordinate relative to center
*        B Contains Y coordinate relative to center
PLOT8    leas  -$08,s
         sta   Xorg,s
         clra  
         std   Yorg,s
         nega  
         negb  
         sbca  #0
         std   Yneg,s
         ldb   Xorg,s
         clra  
         std   Xorg,s
         nega  
         negb  
         sbca  #0
         std   Xneg,s
         ldx   Yneg,s
         bsr   CirPoint
         ldd   Xneg,s
         ldx   Yorg,s
         bsr   CirPoint
         ldd   Xorg,s
         ldx   Yorg,s
         bsr   CirPoint
         ldd   Xorg,s
         ldx   Yneg,s
         bsr   CirPoint
         ldd   Yorg,s
         ldx   Xorg,s
         bsr   CirPoint
         ldd   Yorg,s
         ldx   Xneg,s
         bsr   CirPoint
         ldd   Yneg,s
         ldx   Xneg,s
         bsr   CirPoint
         ldd   Yneg,s
         ldx   Xorg,s
         bsr   CirPoint
         leas  $08,s
         rts   

* Check that Y is within the drawing area.
* Reg X contains Y Coordinate relative to center
* Reg D contains X Coordinate relative to center
CirPoint pshs  b,a
         ldb   <gcursorY,u
         clra  
         leax  d,x
         cmpx  #MINY
         bmi   L083B
         cmpx  #MAXY
         ble   L083D
L083B    puls  pc,b,a

* Check that X is within the drawing area
L083D    ldb   <gcursorX,u
         clra  
         tst   <colorFmt,u
         bmi   L0848
         lslb  
         rola  
L0848    addd  ,s++
         tsta  
         beq   L084E
         rts

L084E    pshs  b
         tfr   x,d
         puls  a
         tst   <colorFmt,u
         lbmi  PutPixel
         lsra  
         lbra  PutPixel

* Getstat code $13 - get joystick values
JoyStkV  ldx   PD.RGS,y
         pshs  y,cc
         orcc  #IRQMask
         lda   #$FF
         clr   >p0ddrb
         ldb   >p0ddra
         ldy   R$X,x     Joystick selection
         bne   L0878
         andb  #$01     Right joystick
         bne   L087C    If clear then button not pressed
         bra   L087D

L0878    andb  #$02     Left joystick
         beq   L087D    If set then button not pressed
L087C    clra  
L087D    sta   R$A,x
         lda   >p0crb
         ora   #$08
         ldy   R$X,x     Joystick selection
         bne   L088B
         anda  #$F7
L088B    sta   >p0crb
         lda   >p0cra
         anda  #$F7
         bsr   L08AA
         std   R$X,x
         lda   >p0cra
         ora   #$08
         bsr   L08AA
         pshs  b,a
         ldd   #$003F
         subd  ,s++
         std   R$Y,x
         clrb  
         puls  pc,y,cc

L08AA    sta   >p0cra
         clrb  
         bsr   L08BA
         bsr   L08BA
         bsr   L08BA
         bsr   L08BA
         lsrb  
         lsrb  
         clra  
         rts   

L08BA    pshs  b
         lda   #$7F
         tfr   a,b
L08C0    lsrb  
         cmpb  #$03
         bhi   L08CC
         lsra  
         lsra  
         tfr   a,b
         addb  ,s+
         rts   

L08CC    addb  #$02
         andb  #$FC
         pshs  b
         anda  #$FC
         sta   >p1ddra
         tst   >p0ddra
         bpl   L08E0
         adda  ,s+
         bra   L08C0
L08E0    suba  ,s+
         bra   L08C0

         emod
eom      equ   *
