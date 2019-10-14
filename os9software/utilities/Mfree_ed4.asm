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
u0004    rmb   1
TOTPAGES rmb   1
u0006    rmb   2
u0008    rmb   2
u000A    rmb   1
BUFPTR   rmb   2
LINEBUF  rmb   530
size     equ   .
name     equ   *
         fcs   /Mfree/
         fcb   $04 

title    fcb   C$LF
         fcc " Address  pages"
         fcb   C$LF
         fcc "--------- -----"
         fcb   $8D       Signed CR
totxt    fcb   C$LF
         fcs   "Total pages free = "

start    equ   *
         leay  LINEBUF,u
         sty   <BUFPTR
         leay  <title,pcr
         bsr   OUTSTR
         bsr   PRINT
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
L006A    lda   ,x+
         bsr   L0083
         cmpx  <FMBM.E
         bcs   L006A
         bsr   L0093
         leay  <totxt,pcr
         bsr   OUTSTR
         ldb   <TOTPAGES
         bsr   PRTNUM
         bsr   PRINT
         clrb  
         os9   F$Exit   

* Count 1-bits in byte
L0083    bsr   L0085   Executed once
L0085    bsr   L0087   Executed twice
L0087    bsr   L0089   Executed four times
L0089    lsla          Executed eight times - shift highest bit into CC
         bcs   L0093   Occupied page?
         inc   <TOTPAGES
         inc   <u000A
         inc   <u0006
         rts   

* Write line for segment of free pages
L0093    pshs  b,a
         ldb   <u000A
         beq   L00B2
         ldd   <u0008
         bsr   Bin4Hx
         lda   #'-
         bsr   OUTCH
         ldd   <u0006
         subd  #1
         bsr   Bin4Hx
         bsr   L00FD
         bsr   L00FD
         ldb   <u000A
         bsr   PRTNUM
         bsr   PRINT
L00B2    inc   <u0006
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

PRINT    pshs  y,x,a
         lda   #C$CR
         bsr   OUTCH
         leax  LINEBUF,u
         stx   <BUFPTR
         ldy   #80
         lda   #1
         os9   I$WritLn 
         puls  pc,y,x,a

PRTNUM   lda   #$FF
         clr   <u0004
PRTN10 inca form hundreds digit
         subb  #100
         bcc   PRTN10
         bsr   L00F4
         lda   #10
PRTN20   deca form tens digit
         addb  #10
         bcc   PRTN20
         bsr   L00F4
         tfr   b,a
         inc   <u0004
L00F4    tsta  
         beq   L00F9
         sta   <u0004
L00F9    tst   <u0004
         bne   L00FF
L00FD    lda   #$F0
L00FF    adda  #'0  Make it ASCII
         cmpa  #'9+1
         bcs   OUTCH
         adda #'A-'9-1 Adjust for A-F

OUTCH    pshs  x
         ldx   <BUFPTR
         sta   ,x+
         stx   <BUFPTR
         puls  pc,x

**********
* Bin4Hx
*  Convert word in D register to
*    four-char hex
Bin4Hx   clr   <u0004
         bsr   Bin2Hx
         tfr   b,a
* Fall through to convert low byte

**********
* Bin2Hx
*  Convert byte in B register to
*    two-char hex
*
Bin2Hx   pshs  a Save byte
         lsra  Shift it to right
         lsra  
         lsra  
         lsra  
         bsr   L0121
         puls  a Restore byte
L0121    anda  #$0F Mask low byte
         bra   L00F4
         emod
eom      equ   *
