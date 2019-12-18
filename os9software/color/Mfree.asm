         nam   Mfree
         ttl   program module

         ifp1
         use   defsfile
         endc

tylg     set   Prgrm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size

FMBM.S   rmb   2
FMBM.E   rmb   2
ZERSUP   rmb   1 0=zero suppression
TOTPAGES rmb   1
u0006    rmb   2
u0008    rmb   2
u000A    rmb   1
BUFPTR   rmb   2
LINEBUF  rmb   530
size     equ   .
name     equ   *
         fcs   /Mfree/
         fcb   $05
title    fcb   C$LF
         fcc " Address  pages"
         fcb   C$LF
         fcc "--------- -----"
         fcb   $8D       Signed CR

totxt    fcb   C$LF
         fcs   "Total pages free = "

gfxtitle fcs  "Graphics Memory "
notalloc fcs   "Not Allocated"
gfxat    fcs   "at: $"

start    equ   *
         leay  LINEBUF,u
         sty   <BUFPTR
         leay  <title,pcr
         bsr   OUTSTR
         bsr   L00EC
         ldx   >D.FMBM
         stx   <FMBM.S
         ldx   >D.FMBM+2
         stx   <FMBM.E
         clra
         clrb
         sta   <TOTPAGES
         std   <u0006
         std   <u0008
         stb   <u000A
         ldx   <FMBM.S
L008C    lda   ,x+
         bsr   L00A8
         cmpx  <FMBM.E
         bcs   L008C
         bsr   L00B8
         leay  <totxt,pcr
         bsr   OUTSTR
         ldb   <TOTPAGES
         bsr   L0101
         bsr   L00EC
         lbsr  L014A
         clrb
         os9   F$Exit

* Count 1-bits in byte
L00A8    bsr   L00AA
L00AA    bsr   L00AC
L00AC    bsr   L00AE
L00AE    lsla
         bcs   L00B8
         inc   <TOTPAGES
         inc   <u000A
         inc   <u0006
         rts

* Write line for segment of free pages
L00B8    pshs  b,a
         ldb   <u000A
         beq   L00D7
         ldd   <u0008
         bsr   Bin4Hx
         lda   #'-
         bsr   OUTCH
         ldd   <u0006
         subd  #1
         bsr   Bin4Hx
         bsr   L0122
         bsr   L0122
         ldb   <u000A
         bsr   L0101
         bsr   L00EC
L00D7    inc   <u0006
         ldd   <u0006
         std   <u0008
         clr   <u000A
         puls  pc,b,a

OUTSTR   lda   ,y
         anda  #$7F
         bsr   OUTCH
         lda   ,y+
         bpl   OUTSTR
         rts
L00EC    pshs  y,x,a
         lda   #$0D
         bsr   OUTCH
         leax  LINEBUF,u
         stx   <BUFPTR
         ldy   #$0050
         lda   #$01
         os9   I$WritLn
         puls  pc,y,x,a
L0101    lda   #$FF
         clr   <ZERSUP
L0105    inca
         subb  #$64
         bcc   L0105
         bsr   L0119
         lda   #$0A
L010E    deca
         addb  #$0A
         bcc   L010E
         bsr   L0119
         tfr   b,a
         inc   <ZERSUP
L0119    tsta
         beq   L011E
         sta   <ZERSUP
L011E    tst   <ZERSUP
         bne   L0124
L0122    lda   #$F0
L0124    adda  #$30
         cmpa  #$3A
         bcs   OUTCH
         adda  #$07

OUTCH    pshs  x
         ldx   <BUFPTR
         sta   ,x+
         stx   <BUFPTR
         puls  pc,x

**********
* Bin4Hx
*  Convert word in D register to
*    four-char hex
Bin4Hx   clr   <ZERSUP
         bsr   Bin2Hx
         tfr   b,a
* Fall through to convert low byte

**********
* Bin2Hx
*  Convert byte in A register to
*    two-char hex
*
Bin2Hx   pshs  a
         lsra
         lsra
         lsra
         lsra
         bsr   L0146
         puls  a
L0146    anda  #$0F
         bra   L0119

L014A    pshs  y,x
         leay  >gfxtitle,pcr
         bsr   OUTSTR
         lda   #1
         ldb   #$12    #SS.DStat
         os9   I$GetStt
         bcc   L0163
         leay  >notalloc,pcr
         bsr   OUTSTR
         bra   L016E
L0163    leay  >gfxat,pcr
         lbsr  OUTSTR
         tfr   x,d
         bsr   Bin4Hx
L016E    puls  y,x
         lbra  L00EC
         emod
eom      equ   *
