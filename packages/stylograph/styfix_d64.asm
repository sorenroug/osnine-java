         nam   Styfix
         ttl   program module

         use   defsfile

tylg     set   Prgrm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   1
u0001    rmb   1
u0002    rmb   8
u000A    rmb   3
u000D    rmb   3
u0010    rmb   16
u0020    rmb   13
u002D    rmb   3
u0030    rmb   4
u0034    rmb   15
u0043    rmb   6
u0049    rmb   3
u004C    rmb   4
u0050    rmb   172
u00FC    rmb   1     Path number for subject file
u00FD    rmb   2
u00FF    rmb   2
u0101    rmb   5
INPBUF   rmb   40    Buffer for input
u012E    rmb   23
u0145    rmb   24553
size     equ   .
name     equ   *
         fcs   /Styfix/

start    equ   *
         subd  #$0002
         bcc   L001C
         leax  >L0277,pcr    default file name
L001C    lda   #$07
         os9   I$Open
         lbcs  FATAL
         sta   >u00FC,u
         leax  >u012E,u
         ldy   #$0030
         os9   I$Read
         lbcs  FATAL
L0038    leax  >MENU,pcr
         lbsr  OUTSTR
L003F    leax  >L0355,pcr "Choice?"
         lbsr  OUTSTR
         leax  >INPBUF,u
         lbsr  L0466
         lda   >INPBUF,u
         cmpa  #'1
         lbeq  L011A
         cmpa  #'2
         beq   L0077
         cmpa  #'3
         beq   L0087
         cmpa  #'4
         beq   L00AF
         cmpa  #'5
         lbeq  L01EC
L0069    lda   #$07   Bell
         lbsr  OUTCH
         leax  >L03E2,pcr  "Illegal choice"
         lbsr  OUTSTR
         bra   L003F

*
* Set default printer type
L0077    leax  >L036D,pcr  Printer number ?
         lbsr  OUTSTR
         bsr   L00C0
         ldx   #PRTTYPE
         bsr   L00EE
         bra   L0038

*
* Change proportional font
L0087    leax  >L037E,pcr   Load styps ?
         lbsr  OUTSTR
         leax  >INPBUF,u
         lbsr  L0466
         lda   >INPBUF,u
         anda  #$5F   Convert to upper case
         cmpa  #'Y
         beq   L00A6
         cmpa  #'N
         bne   L0069
         clrb
         bra   L00A8
L00A6    ldb   #$01
L00A8    ldx   #LOADPROP
         bsr   L00EE
         bra   L0038

*
* Change maximum pages
L00AF    leax  >L03B9,pcr   Number of pages ?
         lbsr  OUTSTR
         bsr   L00C0
         ldx   #MAXPAGES
         bsr   L00EE
         lbra  L0038

*
* Ask for a string
L00C0    leax  >INPBUF,u
         lbsr  L0466
         leax  >INPBUF,u
         lda   ,x
         anda  #$5F   Convert to upper case
         cmpa  #'T
         beq   L00DB
         cmpa  #'P
         beq   L00DB
         cmpa  #'M
         bne   L00DD
L00DB    leax  $01,x
L00DD    lbsr  L01A5
         bcs   L00E9
         cmpd  #$0064
         bhi   L00E9
         rts
L00E9    leas  $02,s
         lbra  L0069

*
* Write byte to file
*
L00EE    stb   >INPBUF,u
         lda   >u00FC,u
         pshs  u
         tfr   x,u
         ldx   #$0000
         os9   I$Seek
         puls  u
         lbcs  FATAL
         leax  >INPBUF,u
         ldy   #1
         lda   >u00FC,u
         os9   I$Write
         lbcs  FATAL
         rts
*
* Set default printer name
L011A    leax  >L035E,pcr
         lbsr  OUTSTR
         leax  >INPBUF,u
         ldy   #$000B
         clra
         os9   I$ReadLn
         lbcs  FATAL
         ldd   >u0145,u
         addd  #$009E
         tfr   d,x
         bsr   L0190
         leax  >u00FD,u
         ldy   #$0002
         lda   >u00FC,u
         os9   I$Read
         lbcs  FATAL
         ldx   >u00FD,u
         leax  $01,x
         bsr   L0190
         leax  >INPBUF,u
         lda   ,x
         cmpa  #$2F
         bne   L0163
         leax  $01,x
L0163    leay  ,x
         clrb
L0166    lda   ,y+
         incb
         cmpa  #$0D
         bne   L0166
         clr   -$01,y
         cmpb  #$01
         lbeq  L0069
L0175    cmpb  #$0B
         beq   L017E
         clr   ,y+
         incb
         bra   L0175
L017E    ldy   #$000B
         lda   >u00FC,u
         os9   I$Write
         lbcs  FATAL
         lbra  L0038

L0190    pshs  u
         lda   >u00FC,u
         tfr   x,u
         ldx   #$0000
         os9   I$Seek
         puls  u
         lbcs  FATAL
         rts
L01A5    ldd   #$0000
         std   >u00FD,u
L01AC    lda   ,x+
         cmpa  #$20
         beq   L01AC
         bra   L01B6
L01B4    lda   ,x+
L01B6    cmpa  #$0D
         beq   L01E2
         cmpa  #$30
         bcs   L01E9
         cmpa  #$39
         bhi   L01E9
         anda  #$0F
         pshs  a
         ldd   >u00FD,u
         lslb
         rola
         lslb
         rola
         lslb
         rola
         addd  >u00FD,u
         addd  >u00FD,u
         addb  ,s+
         adca  #$00
         std   >u00FD,u
         bra   L01B4
L01E2    andcc #$FE
         ldd   >u00FD,u
         rts
L01E9    orcc  #$01
         rts

*
* Return to OS-9
*
L01EC    lda   >u00FC,u
         ldx   #$0000
         pshs  u
         ldu   #$0000
         os9   I$Seek
         puls  u
         lbcs  FATAL
         leax  >u012E,u
         ldy   #$6000
         lda   >u00FC,u
         os9   I$Read
         lbcs  FATAL
         tfr   y,d
         subd  #$0003
         std   >u00FF,u
         leax  >u012E,u
         leax  d,x
         stx   >u0101,u
         ldd   #$FFFF
         std   ,x
         sta   $02,x
         leax  >u012E,u
         ldy   >u00FF,u
         pshs  u
         ldu   >u0101,u
         os9   F$CRC
         com   ,u
         com   u0001,u
         com   u0002,u
         puls  u
         lda   >u00FC,u
         ldx   #$0000
         ldy   >u00FF,u
         pshs  u
         tfr   y,u
         os9   I$Seek
         puls  u
         lbcs  FATAL
         ldx   >u0101,u
         ldy   #$0003
         lda   >u00FC,u
         os9   I$Write
         lbcs  FATAL
         lbra  L047B

L0277    fcc  "STYLO"
         fcb 0
MENU    fcb $0D
         fcb $0A
         fcb $0D
         fcb $0A
         fcc "------- STYLOGRAPH configuration program -------"
         fcb $0D
         fcb $0A
         fcc "  1. Set default printer name"
         fcb $0D
         fcb $0A
         fcc "  2. Set default printer type."
         fcb $0D
         fcb $0A
         fcc "  3. Change proportional table load at startup."
         fcb $0D
         fcb $0A
         fcc "  4. Change maximum pages."
         fcb $0D
         fcb $0A
         fcc "  5. Return to OS-9"
         fcb $0D
         fcb $0A
         fcb 0

L0355    fcc "Choice? "
         fcb 0
L035E    fcc "Printer name? "
         fcb 0
L036D    fcc "Printer number? "
         fcb 0
L037E    fcc 'Load "STYPS" proportional spacing table at startup (Y/N)? '
         fcb 0

L03B9    fcc "Maximum pages that Stylograph can edit? "
         fcb 0
L03E2    fcc "ILLEGAL CHOICE!!!"
         fcb 0

ERRMSG   fcc "FATAL ERROR"
         fcb $0D
         fcb $0A
         fcc "STYLOGRAPH CRC may be wrong."
         fcb $0D
         fcb $0A
         fcc "Using STYFIX again will correct it"
         fcb $0D
         fcb $0A
         fcb 0

*
* Error
*
FATAL    pshs  b
         leax  >ERRMSG,pcr
         bsr   OUTSTR
         puls  b
         os9   F$Exit

*
* Write one character to stdout
*
OUTCH    pshs  y,x,a
         anda  #$7F
         pshs  a
         tfr   s,x
         ldy   #1
         lda   #1
         os9   I$Write
         puls  a
         puls  pc,y,x,a

L0466    pshs  y,x,b,a
         ldy   #$0014
         clra
         os9   I$ReadLn
         puls  pc,y,x,b,a

*
* Write null-terminated string
*
OUTSTR   lda   ,x+
         beq   L047A
         bsr   OUTCH
         bra   OUTSTR
L047A    rts

L047B    clrb
         os9   F$Exit
         emod
eom      equ   *
