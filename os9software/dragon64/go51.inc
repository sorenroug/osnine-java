         nam   go51
         ttl   Replace the KBVDIO driver with DRVR51

         ifp1
         use   ../DEFS/os9defs
         use   ../DEFS/scfdefs
         endc
tylg     set   Prgrm+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size

IT.UPC   equ   $13
IT.PAG   equ   $1A

KbVdAddr rmb   2
DrvrAddr rmb   2
DrvrSize rmb   2
StatBuf  rmb   32

size     equ   .
name     equ   *
         fcs   /go51/
         fcb   1 
KbVdIO   fcs   /KBVDIO/
Drvr51   fcs   /drvr51/
TermStr  fcs   /term/

start    equ   *
         leax  >KbVdIO,pcr
         lbsr  LinkIt
         lbcs  EXIT
         stx   KbVdAddr,u           * Store addr of KbVdIO
         lbsr  UnLink
         leax  >Drvr51,pcr
         lbsr  LinkIt
         lbcs  EXIT
         stx   DrvrAddr,u   * Store addr of drvr51 module
         ldd   M$Size,x
         std   DrvrSize,u      * Store size of drvr51 module
         pshs  u,cc
         orcc  #IntMasks
         ldx   >D.AltIRQ
         stx   >D.IRQ

* Copy the Drvr51 code over KBVDIO. This relies on the fact that
* the size of Drvr51 (2236 bytes) is smaller than KBVDIO (2279 bytes)
         ldy   KbVdAddr,u
         ldx   DrvrSize,u
         ldu   DrvrAddr,u
L0054    lda   ,u+
         sta   ,y+
         leax  -$01,x
         bne   L0054

         ldx   #$FF00
         lda   $01,x
         ora   #$30
         anda  #$F7
         sta   $01,x
         lda   $03,x
         anda  #$F6
         ora   #$30
         sta   $03,x

         ldx   #$FF20
         lda   $03,x
         ora   #$38
         sta   $03,x
         puls  u,cc
         ldx   DrvrAddr,u
         lbsr  UnLink
         ldx   KbVdAddr,u
         ldd   M$Name,x
         leax  d,x        Point to module name of drvr51
         leay  >KbVdIO,pcr
         ldb   #$06       Length of KBVDIO name
* Replace the module name.
L008B    lda   ,y+
         sta   ,x+
         decb  
         bne   L008B
         lda   #$01
         ldb   #SS.Opt
         leax  StatBuf,u
         os9   I$GetStt 
         bcs   EXIT
         clr   $01,x
         lda   #24
         sta   $08,x
         lda   #$01
         ldb   #SS.Opt
         os9   I$SetStt 
         bcs   EXIT
         leax  >TermStr,pcr     Link to term and set some options
         lda   #Devic+Objct
         pshs  u
         os9   F$Link       Returns module address in U
         tfr   u,x
         puls  u
         bcs   EXIT
         clr   IT.UPC,x      Modify TERM dev driver to lower case
         lda   #24
         sta   IT.PAG,x      Modify TERM dev driver to 24 lines per page
         bsr   UnLink
         clrb  
EXIT     os9   F$Exit

* Link in name pointed to in Reg. X
LinkIt   pshs  u
         lda   #Drivr+Objct
         os9   F$Link   
         tfr   u,x
         puls  pc,u

UnLink   pshs  u
         tfr   x,u
         os9   F$UnLink 
         puls  pc,u

         emod
eom      equ   *
         page





*********************************
* DRVR51 - Driver for 51x24 character display
*
* This is implemented on a 256x192 pixel display. 256 pixels allow for
* each character to be 4 pixels wide with 1 pixel in between. And 7 pixels
* tall with one pixel separation.
* One pixel row takes 32 bytes

         nam   drvr51
         ttl   Driver for 51x24 character display

dtylg     set   Drivr+Objct   
datrv     set   ReEnt+rev
drev      set   $01
PIA1A    equ   $FF20
MAXCOLS  equ   51
MAXROWS  equ   24
LASTCOL  equ   50
LASTROW  equ   23

* Defines from kbvdio
alphaSt  equ   $1D
gfxalloc equ   $2C
gfxaddr  equ   $2D

         mod   deom,dname,dtylg,datrv,dstart,dsize
         rmb   2
         rmb   1
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
u000E    rmb   1
u000F    rmb   8
u0017    rmb   4
u001B    rmb   2
nextChar rmb   1
lastChar rmb   1
u001F    rmb   1
u0020    rmb   2
u0022    rmb   2
CursorX  rmb   1    * Cursor horisontal 0-50
CursorY  rmb   1    * Cursor vertical 0-23
u0026    rmb   1
u0027    rmb   1
u0028    rmb   1
u0029    rmb   1
u002A    rmb   1
u002B    rmb   1
u002C    rmb   1
u002D    rmb   1
u002E    rmb   1
ShftLock rmb   1
u0030    rmb   1
u0031    rmb   1
u0032    rmb   1
u0033    rmb   1
u0034    rmb   1
u0035    rmb   1
u0036    rmb   1
u0037    rmb   1
ReverseF rmb   1
UndrLine rmb   1
u003A    rmb   6
u0040    rmb   2
u0042    rmb   2
u0044    rmb   6
u004A    rmb   1
u004B    rmb   10
u0055    rmb   9
u0060    rmb   18
u0080    rmb   46

dsize     equ   .
         fcb   $03 
dname     equ   *
         fcs   /drvr51/
         fcb   $01 
dstart    equ   *
         lbra  INITDEV
         lbra  READ
         lbra  WRITE
         lbra  GETSTA
         lbra  SETSTA
         lbra  TERM

* Init
* The loader has overwritten the kbvdio driver with the drvr51 code,
* so the kernel provides it with the static storage of kbvdio.
* Init deallocates the screen buffer ($200 bytes) and allocates a new
*
* Entry:
*    Y  = address of device descriptor
*    U  = address of device static storage
*
* Exit:
*    CC = carry set on error
*    B  = error code
*
INITDEV  pshs  u,a
         ldu   alphaSt,u    Return alpha buffer from kbvdio
         ldd   #$0200
         os9   F$SRtMem 
         ldu   $01,s
         tst   gfxalloc,u
         beq   L0044
         ldu   gfxaddr,u    Return gfx buffer from kbvdio
         ldd   #$1800
         os9   F$SRtMem 
         ldu   $01,s
L0044    ldb   #$81
         leax  alphaSt,u
L0049    clr   ,x+
         decb  
         bne   L0049
         ldd   #$1900
         os9   F$SRqMem 
         bcs   L009C
         tfr   u,d
         ldu   $01,s
         tfr   d,x
         bita  #$01
         beq   L0066
         leax  >$0100,x
         bra   L0068
L0066    adda  #$18
L0068    stx   <u0022,u
         tfr   d,u
         ldd   #$0100
         os9   F$SRtMem 
         ldu   $01,s
         lda   #$10
         sta   <u0037,u
         pshs  cc
         orcc  #IntMasks
         leay  >AltIRQ,pcr
         sty   >D.IRQ
         ldx   #$FF00
         lda   $03,x
         ora   #$01
         sta   $03,x
         inc   >IsInit,pcr
         puls  cc
         lbsr  L0475
         lbsr  L02C3
         clrb  
L009C    puls  pc,u,a

IsInit    fcb   0

* TERM
*
* Entry:
*    U  = address of device memory area
*
* Exit:
*    CC = carry set on error
*    B  = error code
*
TERM     pshs  cc
         orcc  #IntMasks
         ldx   >D.AltIRQ
         stx   >D.IRQ
         puls  cc
         clrb  
         rts   

AltIRQ   ldu   >D.KbdSta
         ldx   #$FF00
         lda   $03,x
         bmi   L00BB
         jmp   [>D.SvcIRQ]
L00BB    lda   $02,x
         lda   >D.DskTmr
         beq   L00CB
         deca  
         sta   >D.DskTmr
         bne   L00CB
         sta   >$FF48
L00CB    lbsr  L04E5
         jmp   [>D.AltIRQ]

L00D2    pshs  x,b
         lda   u0004,u
         sta   u0005,u
         ldx   #0
         os9   F$Sleep    Sleep indefinitely
         ldx   <u004B
         ldb   <$36,x
         beq   L00EC
         cmpb  #$03
         bhi   L00EC
         coma  
         puls  pc,x,a

L00EC    puls  x,b
*
*
*
READ     tst   >IsInit,pcr
         bne   L00F9
         lbsr  INITDEV
         bcs   L011C
L00F9    leax  <u003A,u
         orcc  #$10
         ldb   <nextChar,u
         cmpb  <lastChar,u
         beq   L00D2
         lda   b,x
         incb  
         cmpb  #$64
         bcs   L010E
         clrb  
L010E    stb   <nextChar,u
         andcc #$EE
         tst   u000E,u
         beq   L011C
         clr   u000E,u
         comb  
         ldb   #$F4
L011C    rts   

*
* A = character to write
* Y = Address of the path descriptor
* U = Address of device static storage
WRITE    tst   >IsInit,pcr
         bne   L012C
         pshs  a
         lbsr  INITDEV
         puls  a
         bcs   L0139
L012C    ldb   <u001F,u
         bne   L0165
         cmpa  #$1B        Escape code
         bne   L013A
         inc   <u001F,u
         clrb  
L0139    rts   

L013A    cmpa  #C$SPAC
         bcs   L0144
         cmpa  #$7F
         bcc   L0144
         bra   L0173

L0144    leax  >L066E,pcr
L0148    tst   ,x
         bne   L0150
L014C    clr   <u001F,u
         rts   

L0150    cmpa  ,x+
         bne   L0161
         ldd   ,x
         leax  >L066E,pcr
         leax  d,x
         stx   <u0020,u
         jmp   ,x
L0161    leax  $02,x
         bra   L0148

* Handle escape codes
L0165    inc   <u001F,u
         leax  >L0681,pcr
         cmpb  #$01
         beq   L0148
         jmp   [<u0020,u]

* Print a character
L0173    inc   <u0032,u
         bsr   L01B3
         tst   <UndrLine,u
         beq   L0185
* Print an underline 
         lda   #%11111000
         leay  <-$40,y     * decrement two pixel rows
         lbsr  L0236
* Move cursor
L0185    lda   <CursorX,u
         inca  
         cmpa  #MAXCOLS
         bcs   L01A2
         clr   <CursorX,u
         lda   <CursorY,u
         inca  
         cmpa  #MAXROWS
         bcs   L019D
         lbsr  L033E
         bra   L01A5
L019D    sta   <CursorY,u
         bra   L01A5
L01A2    sta   <CursorX,u
L01A5    clr   <u0033,u
         ldd   <CursorX,u
         std   <u0030,u
         dec   <u0032,u
         clrb  
         rts   
* Find the character in the glyph table
* The character is in reg. A
L01B3    tfr   a,b
         subb  #$20
         clra  
         leax  >GLYPHS,pcr
         lslb  
         rola  
         lslb  
         rola  
         leax  d,x
         ldb   #$05
         lda   <CursorX,u
         mul   
         pshs  b
         lsra  
         rorb  
         lsra  
         rorb  
         lsra  
         rorb  
         puls  a
         anda  #$07
         pshs  b
         sta   <u0026,u
         tst   <u0034,u
         bne   L01FF
         tfr   a,b
         lda   #$F8
         tstb  
         beq   L01FA
L01E5    lsra  
         decb  
         bhi   L01E5
         bne   L01EE
         rorb  
         bra   L01FA
L01EE    pshs  b
         ldb   #$80
L01F2    lsra  
         rorb  
         dec   ,s
         bne   L01F2
         leas  $01,s
L01FA    coma  
         comb  
         std   <u0035,u
L01FF    ldy   <u0022,u
         lda   <CursorY,u
         ldb   ,s+
         leay  d,y
         lda   #$04
         pshs  a
         inc   <u0032,u
L0211    lda   ,x
         anda  #$F0
         bsr   L0236
         lda   ,x+
         anda  #$0F
         bsr   L0227
         dec   ,s
         bne   L0211
         dec   <u0032,u
         clrb  
         puls  pc,b

L0227    ldb   <u0026,u
         subb  #$04
         bhi   L023B
         beq   L0250
L0230    lsla  
         incb  
         bne   L0230
         bra   L0250

* Draw a row of a glyph (top five bits of reg. A)
L0236    ldb   <u0026,u
         beq   L0250
L023B    lsra  
         decb  
         bhi   L023B
         bne   L0244
         rorb  
         bra   L0250

L0244    pshs  b
         ldb   #$80
L0248    lsra  
         rorb  
         dec   ,s
         bne   L0248
         leas  $01,s
*
L0250    tst   <u0034,u
         bne   L0273
         tst   <ReverseF,u
         beq   L0262
         coma  
         comb  
         eora  <u0035,u
         eorb  <u0036,u
L0262    pshs  b,a
         ldd   <u0035,u
         anda  ,y
         andb  $01,y
         addd  ,s++
L026D    std   ,y
         leay  <$20,y
         rts   
L0273    eora  ,y
         eorb  $01,y
         bra   L026D
*
* Make a beep
*
Bell     ldx   #PIA1A
         ldb   #$64
L027E    lda   ,x
         eora  #$C0
         sta   ,x
         lda   #$19
L0286    deca  
         nop   
         nop   
         bne   L0286
         decb  
         bne   L027E
         lbra  L014C

* Backspace
L0291    dec   <CursorX,u
         bpl   L02A6
         lda   #LASTCOL
         sta   <CursorX,u
L029B    dec   <CursorY,u
         bpl   L02A6
         clr   <CursorY,u
         lbsr  L035E
L02A6    lbsr  L0484
         lbra  L014C

* Linefeed
L02AC    lda   <CursorY,u
         inca  
         cmpa  #MAXROWS
         bcs   L02B9
         lbsr  L033E
         bra   L02BC
L02B9    sta   <CursorY,u
L02BC    bra   L02A6
*
* Carriage return
*
L02BE    clr   <CursorX,u
         bra   L02A6
*
* Clear screen
*
L02C3    ldy   <u0022,u
         leay  >$0080,y
         lda   #MAXROWS
         pshs  a
         inc   <u0032,u
L02D2    bsr   L0314
         dec   ,s
         bne   L02D2
         leas  $01,s
         clra  
         clrb  
         sta   <u0033,u
         std   <u0030,u
         std   <CursorX,u
         dec   <u0032,u
         ldx   #PIA1A
         lda   $02,x
         ora   #$F0
         sta   $02,x
         ldx   #$FFC0
         lda   #$06
         ldb   #$03
         bsr   L0305
         lda   <u0022,u
         lsra  
         ldb   #$07
         bsr   L0305
         lbra  L014C

L0305    lsra  
         bcc   L030E
         leax  $01,x
         sta   ,x+
         bra   L0310
L030E    sta   ,x++
L0310    decb  
         bne   L0305
         rts   

L0314    lda   #$10
L0316    pshs  a
         lda   <ReverseF,u
         tfr   a,b
L031D    std   <-$80,y
         std   <-$60,y
         std   <-$40,y
         std   <-$20,y
         std   <$20,y
         std   <$40,y
         std   <$60,y
         std   ,y++
         dec   ,s
         bne   L031D
         leay  >$00E0,y
         puls  pc,b
L033E    ldy   <u0022,u
         inc   <u0032,u
         pshs  u
         leau  >$0100,y
         lda   #$10
         bsr   L037C
         puls  u
         dec   <u0031,u
L0354    leay  >$0080,y
         bsr   L0314
         dec   <u0032,u
         rts   
L035E    ldy   <u0022,u
         leay  >$17F0,y
         inc   <u0032,u
         pshs  u
         leau  >-$0100,y
         lda   #$F0
         bsr   L037C
         leay  ,u
         puls  u
         inc   <u0031,u
         bra   L0354
L037C    ldb   #LASTROW
         pshs  b
L0380    ldb   #$10
L0382    ldx   $00,u
         stx   $00,y
         ldx   $02,u
         stx   $02,y
         ldx   $04,u
         stx   $04,y
         ldx   $06,u
         stx   $06,y
         ldx   $08,u
         stx   $08,y
         ldx   $0A,u
         stx   $0A,y
         ldx   $0C,u
         stx   $0C,y
         ldx   $0E,u
         stx   $0E,y
         leay  a,y
         leau  a,u
         decb  
         bne   L0382
         dec   ,s
         bne   L0380
         puls  pc,b
*
* CLEAR EOL
*
L03AF    inc   <u0032,u
         bsr   L03BA
         dec   <u0032,u
         lbra  L014C

* Calculate X pixel position
L03BA    clr   <u0033,u
         ldb   <CursorX,u
         pshs  b
         bitb  #$07
         bne   L03CB
         lda   #$05
         mul   
         bra   L03F3

L03CB    lda   #$01
         pshs  a
L03CF    lda   #$20
         lbsr  L01B3
         lda   <CursorX,u
         inca  
         sta   <CursorX,u
         cmpa  #MAXCOLS
         bcs   L03E3
         leas  $01,s
         bra   L040D
L03E3    dec   ,s
         bpl   L03CF
         lda   <CursorX,u
         ldb   #$05
         mul   
         bitb  #$08
         bne   L03CF
         leas  $01,s

L03F3    lsrb  
         lsrb  
         lsrb  
         ldy   <u0022,u
         lda   <CursorY,u
         leay  d,y
         leay  >$0080,y
         lda   #$20
         pshs  b
         suba  ,s+
         lsra  
         lbsr  L0316
L040D    puls  a
         sta   <CursorX,u
         rts   
         inc   <u0032,u
         bsr   L03BA
         lda   #LASTROW
         suba  <CursorY,u
         bls   L042A
         pshs  a
L0421    lbsr  L0314
         dec   ,s
         bne   L0421
         leas  $01,s
L042A    dec   <u0032,u
         lbra  L014C

* Cursor Home
L0430    clr   <CursorX,u
         clr   <CursorY,u
         lbra  L02A6

* Set cursor X,Y
L0439    ldb   <u001F,u
         subb  #$02
         bne   L0442
         clrb  
         rts   

L0442    decb  
         bne   L0450
         cmpa  #MAXCOLS
         bcs   L044B
         lda   #LASTCOL
L044B    sta   <CursorX,u
         clrb  
         rts   

L0450    cmpa  #MAXROWS
         bcs   L0456
         lda   #LASTROW
L0456    sta   <CursorY,u
L0459    lbra  L02A6

* CURSOR RIGHT
L045C    inc   <CursorX,u
         lda   <CursorX,u
         cmpa  #MAXCOLS
         bcs   L0459
         clr   <CursorX,u
         lbra  L02AC
* Reverse on
L046C    lda   #$FF
         coma  
L046F    sta   <ReverseF,u
         lbra  L014C
* Reverse off
L0475    lda   #$FF
         bra   L046F

* Underline on
L0479    lda   #$FF
L047B    sta   <UndrLine,u
         lbra  L014C

* Underline off
L0481    clra  
         bra   L047B

L0484    ldd   <CursorX,u
         inc   <u0032,u
         tst   <u0033,u
         bne   L0494
         std   <u0030,u
         bra   L04B9
L0494    pshs  b,a
         ldd   <u0030,u
         inc   <u0034,u
         tstb  
         bmi   L04AB
         cmpb  #MAXROWS
         bcc   L04AB
         std   <CursorX,u
         lda   #$7F
         lbsr  L01B3
L04AB    puls  b,a
         std   <CursorX,u
         std   <u0030,u
         clr   <u0033,u
         dec   <u0034,u
L04B9    dec   <u0032,u
         clrb  
         rts   

* Getstat
*
* Input: U = Address of device static storage
*        Y = Address of path descriptor
*        A = Status code

GETSTA   cmpa  #SS.Ready
         bne   ASKEOF
         lda   <nextChar,u
         cmpa  <lastChar,u
         beq   L04CC
noerror  clrb  
         rts   
L04CC    comb  
         ldb   #E$NRDY
         rts   

ASKEOF   cmpa  #SS.EOF
         beq   noerror
         cmpa  #SS.Size
         bne   SETSTA
         ldx   PD.RGS,y
         ldd   <u0022,u
         std   R$X,x
         clrb  
         rts   

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

SETSTA   comb  
         ldb   #E$UnkSvc
         rts   

L04E5    tst   <u0032,u
         bne   L0512
         dec   <u0037,u
         bne   L0512
         lda   #$10
         sta   <u0037,u
         inc   <u0034,u
         ldd   <CursorX,u
         pshs  b,a
         ldd   <u0030,u
         std   <CursorX,u
         lda   #$7F
         lbsr  L01B3
         puls  b,a
         std   <CursorX,u
         com   <u0033,u
         dec   <u0034,u
L0512    ldx   #$FF00
         lda   #$FF
         sta   $02,x
         bsr   L053B
         anda  #$03
         bne   L0526
         clra  
         sta   $02,x
         bsr   L053B
         bne   L052D
L0526    clr   <u0027,u
         clr   <u0028,u
         rts   
L052D    tst   <u0028,u
         bne   L0541
         sta   <u0028,u
L0535    clrb  
         rts   
L0537    clrb  
         stb   $02,x
         rts   
L053B    lda   ,x
         coma  
         anda  #$7F
         rts   
L0541    cmpa  <u0028,u
         bne   L0526
         clr   <u002A,u
         clr   <u002B,u
         clr   <u002C,u
         clr   <u002D,u
         clr   <u002E,u
         ldb   #$01
L0557    comb  
         stb   $02,x
         bsr   L053B
         beq   L05A1
         bita  #$40
         beq   L0583
         cmpb  #$7F
         bne   L056B
         inc   <u002D,u
         bra   L057F
L056B    cmpb  #$FD
         bne   L0574
         inc   <u002E,u
         bra   L057F
L0574    tst   <u002C,u
         bne   L0537
         stb   <u002C,u
         com   <u002C,u
L057F    anda  #$3F
         beq   L05A1
L0583    pshs  b,a
         clrb  
L0586    lsra  
         bcc   L058A
         incb  
L058A    tsta  
         bne   L0586
         cmpb  #$01
         puls  b,a
         bne   L0537
         tst   <u002A,u
         bne   L0537
         sta   <u002A,u
         stb   <u002B,u
         com   <u002B,u
L05A1    comb  
         lslb  
         bne   L0557
         stb   $02,x
         ldb   <u002C,u
         beq   L05B5
         tst   <u002A,u
         bne   L0535
         lda   #$40
         bra   L05BF
L05B5    ldb   <u002B,u
         lda   <u002A,u
         lbeq  L0526
L05BF    pshs  b
         tst   <u0027,u
         beq   L05D0
         dec   <u0027,u
         beq   L05D4
         puls  b
         lbra  L0665
L05D0    ldb   #LASTCOL
         bra   L05D6
L05D4    ldb   #$05
L05D6    stb   <u0027,u
         lbsr  L0667
         lslb  
         lslb  
         lslb  
         puls  a
         pshs  b
         lbsr  L0667
         orb   ,s+
         stb   <u0029,u
         leax  >NrmlMap,pcr
         lda   b,x
         tst   <u002E,u
         beq   L05FE
         leax  >CtrlMap,pcr
         lda   b,x
         bra   L0609

L05FE    tst   <u002D,u
         beq   L0612
         leax  >ShftMap,pcr
         lda   b,x
L0609    cmpa  #$1F        * Shift lock pressed
         bne   L0621
         com   <ShftLock,u
         bra   L0665

L0612    tst   <ShftLock,u
         beq   L0621
         cmpa  #$61
         bcs   L0621
         cmpa  #$7A
         bhi   L0621
         suba  #$20
L0621    leax  <u003A,u
         ldb   <lastChar,u
         sta   b,x
         incb  
         cmpb  #$64
         bcs   L062F
         clrb  
L062F    cmpb  <nextChar,u
         bne   L0638
         inc   u000E,u
         bra   L063B

L0638    stb   <lastChar,u
L063B    tsta  
         beq   L065A
         cmpa  u000D,u
L0640    bne   L064A
         ldx   u0009,u
         beq   L065A
L0646    sta   $08,x
         bra   L065A
L064A    ldb   #$03
         cmpa  u000B,u
         beq   L0656
         ldb   #$02
         cmpa  u000C,u
         bne   L065A
L0656    lda   u0003,u
         bra   L065E
L065A    ldb   #$01
         lda   u0005,u
L065E    beq   L0663
         os9   F$Send   
L0663    clr   u0005,u
L0665    clrb  
         rts   
L0667    clrb  
L0668    incb  
         lsra  
         bne   L0668
         decb  
         rts   

* Jump table for ASCII commands
L066E    fcb   C$BELL
         fdb   Bell-L066E
         fcb   C$BSP          * BACKSPACE (CURSOR LEFT)
         fdb   L0291-L066E
         fcb   C$LF           * LINE FEED
         fdb   L02AC-L066E
         fcb   C$CR           * CARRIAGE RETURN
         fdb   L02BE-L066E
         fcb   C$FORM         * CLEAR SCREEN
         fdb   L02C3-L066E
         fcb   $0B            * CURSOR HOME
         fdb   L0430-L066E
         fcb   $00            * No more

L0681    fcb   $41
         fdb   L0439-L066E    * CURSOR XY
         fcb   $42
         fdb   L03AF-L066E    * CLEAR EOL
         fcb   $43
         fdb   L045C-L066E    * CURSOR RIGHT
         fcb   $44
         fdb   L029B-L066E    * CURSOR UP
         fcb   $45
         fdb   L02AC-L066E    * CURSOR DOWN
         fcb   $46
         fdb   L046C-L066E    * REVERSE ON
         fcb   $47
         fdb   L0475-L066E    * REVERSE OFF
         fcb   $48
         fdb   L0479-L066E    * UNDERLINE ON
         fcb   $49
         fdb   L0481-L066E    * UNDERLINE OFF
         fcb   $4A
         fdb   $FDA5    * CLEAR EOS
         fcb   $00           * No more

* The characters are stored 1 row per nibble.
GLYPHS   fcb  %00000000    * space
         fcb  %00000000
         fcb  %00000000
         fcb  %00000000

         fcb  %01000100    * !
         fcb  %01000000
         fcb  %01000000
         fcb  %00000000

         fcb  %01010101    * "
         fcb  %00000000
         fcb  %00000000
         fcb  %00000000

         fcb  %01101111    * $23 #
         fcb  %01101111
         fcb  %01100000
         fcb  %00000000

         fcb  %00100111    * $24 $
         fcb  %10000110
         fcb  %00011110
         fcb  %00100000

         fcb  %10010001    * $25 %
         fcb  %00100100
         fcb  %10001001
         fcb  %00000000

         fcb  %01001010    * $26 &
         fcb  %01001010
         fcb  %11010000
         fcb  %00000000

         fcb  %01000100    * $27 '
         fcb  %00000000
         fcb  %00000000
         fcb  %00000000

         fcb  %00100100    * $28 (
         fcb  %01000100
         fcb  %00100000
         fcb  %00000000

         fcb  %01000010    * $29 )
         fcb  %00100010
         fcb  %01000000
         fcb  %00000000

         fcb  %10010110    * $2A *
         fcb  %11110110
         fcb  %10010000
         fcb  %00000000

         fcb  %01000100    * $2B +
         fcb  %11100100
         fcb  %01000000
         fcb  %00000000

         fcb  %00000000    * $2C ,
         fcb  %00000010
         fcb  %00100100
         fcb  %00000000

         fcb  %00000000    * $2D -
         fcb  %11110000
         fcb  %00000000
         fcb  %00000000

         fcb  %00000000    * $2E .
         fcb  %00000110
         fcb  %01100000
         fcb  %00000000

         fcb  %00000001    * $2F /
         fcb  %00100100
         fcb  %10000000
         fcb  %00000000

         fcb  %01101001    * $30 0
         ifeq Charset-ASCII
         fcb  %10111101
         endc
         ifeq (Charset-NORDIC)*(Charset-NORDICKB)
         fcb  %11011011
         endc
         fcb  %01100000
         fcb  %00000000

         fcb  %00100110    * $31 1
         fcb  %00100010
         fcb  %01110000
         fcb  %00000000

         fcb  %01101001    * $32 2
         fcb  %00101100
         fcb  %11110000
         fcb  %00000000

         fcb  %11100001
         fcb  %01100001
         fcb  %11100000
         fcb  %00000000

         fcb  %00100110
         fcb  %10101111
         fcb  %00100000
         fcb  %00000000

         fcb  %11111000
         fcb  %11100001
         fcb  %11100000
         fcb  %00000000

         fcb  %01111000
         fcb  %11101001
         fcb  %01100000
         fcb  %00000000

         fcb  %11110001
         fcb  %00100100
         fcb  %01000000
         fcb  %00000000

         fcb  %01101001
         fcb  %01101001
         fcb  %01100000
         fcb  %00000000

         fcb  %01101001
         fcb  %01110001
         fcb  %01100000
         fcb  %00000000

         fcb  %00000000    * $3A :
         fcb  %01000000
         fcb  %01000000
         fcb  %00000000

         fcb  %00000000    * $3B ;
         fcb  %00100000
         fcb  %00100100
         fcb  %00000000

         fcb  %00100100    * $3C <
         fcb  %10000100
         fcb  %00100000
         fcb  %00000000

         fcb  %00001111    * $3D =
         fcb  %00001111
         fcb  %00000000
         fcb  %00000000

         fcb  %01000010
         fcb  %00010010
         fcb  %01000000
         fcb  %00000000

         fcb  %01101001
         fcb  %00100010
         fcb  %00000010
         fcb  %00000000

         fcb  %01101001    * $40 @
         fcb  %10111011
         fcb  %10000111
         fcb  %00000000

         fcb  %01101001    * $41 A
         fcb  %11111001
         fcb  %10010000
         fcb  %00000000

         fcb  %11101001
         fcb  %11101001
         fcb  %11100000
         fcb  %00000000

         fcb  %01111000   * $43 C
         fcb  %10001000
         fcb  %01110000
         fcb  %00000000

         fcb  %11101001
         fcb  %10011001
         fcb  %11100000
         fcb  %00000000

         fcb  %11111000
         fcb  %11101000
         fcb  %11110000
         fcb  %00000000

         fcb  %11111000
         fcb  %11101000
         fcb  %10000000
         fcb  %00000000

         fcb  %01111000   * $47 G
         fcb  %10111001
         fcb  %01110000
         fcb  %00000000

         fcb  %10011001
         fcb  %11111001
         fcb  %10010000
         fcb  %00000000

         fcb  %11100100
         fcb  %01000100
         fcb  %11100000
         fcb  %00000000

         fcb  %11110010
         fcb  %00101010
         fcb  %01000000
         fcb  %00000000

         fcb  %10011010
         fcb  %11001010
         fcb  %10010000
         fcb  %00000000

         fcb  %10001000
         fcb  %10001000
         fcb  %11110000
         fcb  %00000000

         fcb  %11111101   * $4D M
         fcb  %11011001
         fcb  %10010000
         fcb  %00000000

         fcb  %10011101
         fcb  %10111001
         fcb  %10010000
         fcb  %00000000

         fcb  %01101001
         fcb  %10011001
         fcb  %01100000
         fcb  %00000000

         fcb  %11101001
         fcb  %11101000
         fcb  %10000000
         fcb  %00000000

         fcb  %01101001
         fcb  %10011011
         fcb  %01110000
         fcb  %00000000

         fcb  %11101001
         fcb  %11101010
         fcb  %10010000
         fcb  %00000000

         fcb  %01111000   * $53 S
         fcb  %01100001
         fcb  %11100000
         fcb  %00000000

         fcb  %11100100
         fcb  %01000100
         fcb  %01000000
         fcb  %00000000

         fcb  %10011001
         fcb  %10011001
         fcb  %01100000
         fcb  %00000000

         fcb  %10011001
         fcb  %10010110
         fcb  %01100000
         fcb  %00000000

         fcb  %10011001   * $57 W
         fcb  %11011101
         fcb  %11110000
         fcb  %00000000

         fcb  %10011001
         fcb  %01101001
         fcb  %10010000
         fcb  %00000000

         fcb  %10011001
         fcb  %01110001
         fcb  %11100000
         fcb  %00000000

         fcb  %11110001
         fcb  %01101000
         fcb  %11110000
         fcb  %00000000

         ifeq Charset-ASCII
         fcb  %11101000   * $5B [
         fcb  %10001000
         fcb  %11100000
         fcb  %00000000

         fcb  %00001000   * $5C \
         fcb  %01000010
         fcb  %00010000
         fcb  %00000000

         fcb  %01110001
         fcb  %00010001
         fcb  %01110000
         fcb  %00000000
         endc
         ifeq (Charset-NORDIC)*(Charset-NORDICKB)
         fcb  %01111110   * $5B AE
         fcb  %11111010
         fcb  %10110000
         fcb  %00000000

         fcb  %01111011   * $5C O/
         fcb  %11111101
         fcb  %11100000
         fcb  %00000000

         fcb  %01100110
         fcb  %10011111
         fcb  %10010000
         fcb  %00000000
         endc

         fcb  %01101001
         fcb  %00000000
         fcb  %00000000
         fcb  %00000000

         fcb  %00000000   * $5F _
         fcb  %00000000
         fcb  %00001111
         fcb  %00000000

         fcb  %00100010   * $60 `
         fcb  %00000000
         fcb  %00000000
         fcb  %00000000

         fcb  %00000111   * $61 a
         fcb  %10011001
         fcb  %01110000
         fcb  %00000000

         fcb  %10001110
         fcb  %10011001
         fcb  %11100000
         fcb  %00000000

         fcb  %00000111
         fcb  %10001000
         fcb  %01110000
         fcb  %00000000

         fcb  %00010111
         fcb  %10011001
         fcb  %01110000
         fcb  %00000000

         fcb  %00000111
         fcb  %10101100
         fcb  %01110000
         fcb  %00000000

         fcb  %00110100   * $66 f
         fcb  %11110100
         fcb  %01000000
         fcb  %00000000

         fcb  %00000110
         fcb  %10011001
         fcb  %01110001
         fcb  %11100000

         fcb  %10001110
         fcb  %10011001
         fcb  %10010000
         fcb  %00000000

         fcb  %01000000
         fcb  %01000100
         fcb  %01000000
         fcb  %00000000

         fcb  %00100000
         fcb  %00100010
         fcb  %00100010
         fcb  %11000000

         fcb  %10001010   * $6B k
         fcb  %11001010
         fcb  %10010000
         fcb  %00000000

         fcb  %01000100
         fcb  %01000100
         fcb  %01000000
         fcb  %00000000

         fcb  %00001110
         fcb  %11011101
         fcb  %10010000
         fcb  %00000000

         fcb  %00001110
         fcb  %10011001
         fcb  %10010000
         fcb  %00000000

         fcb  %00000110   * $6F o
         fcb  %10011001
         fcb  %01100000
         fcb  %00000000

         fcb  %00001110
         fcb  %10011001
         fcb  %11101000
         fcb  %10000000

         fcb  %00000111
         fcb  %10011001
         fcb  %01110001
         fcb  %00010000

         fcb  %00000111
         fcb  %10001000
         fcb  %10000000
         fcb  %00000000

         fcb  %00000111   * $73 s
         fcb  %11000011
         fcb  %11100000
         fcb  %00000000

         fcb  %01001111
         fcb  %01000100
         fcb  %00110000
         fcb  %00000000

         fcb  %00001001
         fcb  %10011001
         fcb  %01110000
         fcb  %00000000

         fcb  %00001001
         fcb  %10010110
         fcb  %01100000
         fcb  %00000000

         fcb  %00001001   * $77 w
         fcb  %11011101
         fcb  %01100000
         fcb  %00000000

         fcb  %00001001   * $78 x
         fcb  %01100110
         fcb  %10010000
         fcb  %00000000

         fcb  %00001001   * $79 y
         fcb  %10011001
         fcb  %01110001
         fcb  %11100000

         fcb  %00001111   * $7A z
         fcb  %00100100
         fcb  %11110000
         fcb  %00000000

         ifeq Charset-ASCII
         fcb  %00110100   * $7B {
         fcb  %11000100
         fcb  %00110000
         fcb  %00000000

         fcb  %01000100   * $7C |
         fcb  %00000100
         fcb  %01000000
         fcb  %00000000

         fcb  %11000010   * $7D }
         fcb  %00110010
         fcb  %11000000
         fcb  %00000000
         endc

         ifeq (Charset-NORDIC)*(Charset-NORDICKB)
         fcb  %00001111   * $7B {
         fcb  %01101010
         fcb  %11110000
         fcb  %00000000

         fcb  %00000101   * $7C |
         fcb  %10111101
         fcb  %11110000
         fcb  %00000000

         fcb  %00100000   * $7D }
         fcb  %01111001
         fcb  %01110000
         fcb  %00000000
         endc

         fcb  %00000101   * $7E ~
         fcb  %10100000
         fcb  %00000000
         fcb  %00000000

         fcb  %11111111   * $7F inverted cursor
         fcb  %11111111
         fcb  %11111111
         fcb  %11110000

NrmlMap  fcc  "0123456789:;,-./"
         fcc  "@abcdefghijklmno"
         fcc  "pqrstuvwxyz"
         fcb  $0C,$0A,$08,$09,$20,$0D,$00,$05

ShftMap  fcc  /0!"#$%&'()*+<=>?/
         fcc  /|ABCDEFGHIJKLMNO/
         fcc  /PQRSTUVWXYZ/
         fcb  $1C,$1A,$18,$19,$20,$0D,$00,$03

* Mappings when CTRL is pressed.
CtrlMap  fcb  $1F
         ifeq (Charset-ASCII)*(Charset-NORDIC)
         fcb  $7C,$00,$7E,$00,$00,$00,$5E,$5B,$5D
         endc
         ifeq Charset-NORDICKB
         fcb  $5B,$5C,$5D,$5E,$7E,$60,$7B,$7C,$7D
         endc
         fcb  $00,$00,$7B,$5F,$7D,$5C
         fcb  $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
         fcb  $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A
         fcb  $13,$12,$10,$11,$20,$0D,$00,$1B

         emod
deom      equ   *
