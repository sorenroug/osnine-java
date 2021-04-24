 nam   INSTALL
 ttl   program module

 opt -m

C$EOT    set   $04
TRMBASE  equ   $14C
Q$KEY    equ   1
Q$YN     equ   2
Q$SEQ    equ   4
Q$NUM    equ   5

         mod   eom,name,Prgrm+Objct,ReEnt+1,start,size
u0000    rmb   1
u0001    rmb   1
u0002    rmb   1
u0003    rmb   1 Flag to ask if the user want to change a section
u0004    rmb   1
u0005    rmb   1
u0006    rmb   1
u0007    rmb   1
u0008    rmb   1
u0009    rmb   1
u000A    rmb   3
u000D    rmb   8
u0015    rmb   1
u0016    rmb   1
u0017    rmb   1
u0018    rmb   7
u001F    rmb   1
u0020    rmb   1
u0021    rmb   2
u0023    rmb   2
ANSIFLAG rmb   1   flag for ansi terminal
u0026    rmb   1   TRM file descriptor
errcode  rmb   1   error code
u0028    rmb   2
V.LABEL    rmb   2
u002C    rmb   1
u002D    rmb   4    Upper case flag
u0031    rmb   3
u0034    rmb   1
u0035    rmb   1
u0036    rmb   3
u0039    rmb   11
u0044    rmb   1
u0045    rmb   4
u0049    rmb   3
u004C    rmb   179    buffer for input
u00FF    rmb   213
u01D4    rmb   138
u025E    rmb   366
u03CC    rmb   1024
u07CC    rmb   11386
size     equ   .

NAME     fcs   /INSTALL/
         fcc   "     Install- a utility for DYNACALC  "
         fcb   $0D
         fcb   $0A
         fcc   "Version 4.7:3  "
         fcb   $0D
         fcb   $0A
         fcc   "Copyright (C) 1983, by Scott Schaeferle  "
         fcb   $0D
         fcb   $0A
         fcc   "All rights reserved     "

start    equ   *
         leay  -$01,y
         sty   V.LABEL
         stu   <u0028
         lda   #$28
L0099    clr   ,u+
         deca
         bne   L0099
         ldy   <u0028
         leax  <$2C,y
         clra
         clrb
         os9   I$GetStt
         lbcs  FATAL
         leax  >L08A1,pcr banner
         lbsr  CRTEXT
         tfr   s,x
         cmpx  V.LABEL
         beq   L0123 No arguments on the command line

* Test if there is an 'I' argument to skip instructions
L00BA    ldd   ,x
         anda  #$5F
         cmpd  #$4920    I+space
         beq   L012A    skip instructions
         cmpd  #$490D    I+cr
         beq   L012A    skip instructions
         tst   <u0026   TRM file descriptor
         bne   L0123   Instructions
         ldy   <u0028
         leau  >TRMBASE,y
* Copy the next argument, which should be a file name
L00D5    lda   ,x+
         sta   ,u+
         cmpa  #$0D
         beq   L00E9
         cmpa  #$20
         bne   L00D5
L00E1    lda   ,x+
         cmpa  #$20
         beq   L00E1
         leax  -1,x
* Check if the file name ends with .trm
L00E9    pshs  x
         ldx   -3,u
         cmpx  #$726D     rm
         beq   L00F7
         cmpx  #$524D     RM
         bne   L0103
L00F7    ldx   -5,u
         cmpx  #$2E74     .t
         beq   L010F
         cmpx  #$2E54     .T
         beq   L010F
L0103    leau  -1,u
         ldx   #$2E74     .t
         stx   ,u++
         ldx   #$72ED     rm
         stx   ,u++
L010F    leax  >TRMBASE,y
         lda   #$01
         os9   I$Open
         puls  x
         lbcs  L01A9
         sta   <u0026
* The file is a patch file
         lbra  L00BA

L0123    leax  >L.INSTR,pcr  Instructions
         lbsr  CRTEXT
L012A    ldy   <u0028
         clra
         clrb
         leax  >TRMBASE,y
         os9   I$GetStt
         lbcs  FATAL
         clr   PD.EKO-PD.OPT,x    $04,x
         clr   PD.EOF-PD.OPT,x    $0C,x
         clr   PD.PSC-PD.OPT,x    $0F,x   pause character
         clr   PD.INT-PD.OPT,x    <$10,x  interrupt character
         clr   PD.QUT-PD.OPT,x   quit
         clr   <$16,x
         os9   I$SetStt
         lbcs  FATAL
         leax  >L078E,pcr   Dynacalc.trm
         lda   #EXEC.+READ.
         os9   I$Open
         bcc   L0163
         cmpb  #E$PNNF
         lbne  FATAL
         bra   L016B

L0163    leax  >L083D,pcr  dynacalc.trm already exists
         clrb
         lbra  ERREXIT
L016B    leax  >L079A,pcr  dynacalc.cor
         lda   #$01
         os9   I$Open
         bcs   L018A

LOADTRM  ldx   <u0028
         leax  >TRMBASE,x
         ldy   #$3200
         os9   I$Read
         bcs   L018A
         os9   I$Close
         bcc   L0191
L018A    leax  >L07CA,pcr  Error loading dynacalc.cor
         lbra  ERREXIT

L0191    ldu   <u0028
         leax  >$88+TRMBASE,u
         lda   <u0026
         beq   L01B0
         ldy   #$0200 Load patch file as overlay from $88
         os9   I$Read
         bcs   L01A9
         os9   I$Close
         bcc   L01B6
L01A9    leax  >L07A6,pcr  Error loading trm file
         lbsr  ERREXIT
L01B0    leay  >L18AC,pcr  Buffer for failed TRM patch file load
         bra   L01CB

* Copy name of printer from patch file into printer location
L01B6    leay  >$112+TRMBASE,u
         leax  >$680+TRMBASE,u
L01BE    lda   0,y
         clr   ,y+
         sta   ,x+
         bne   L01BE
         ldd   #$2000 Append space and null
         std   -1,x

L01CB    tfr   u,y
         com   <u0003
         tst   <u0026
         beq   L01D5
         clr   <u0003
* Start asking questions
L01D5    clr   <ANSIFLAG

         leax  >H.PRINT,pcr   printer characteristics heading
         lbsr  OUT.SECT
         bcs   L01F5
         leax  >L12D5,pcr   enter the printer settings
         lbsr  L0304
         lda   >$F9+TRMBASE,y   $0245 line feeds after each line
         cmpa  #$08
         bcs   L01F5
         lda   #$07
         sta   >$F9+TRMBASE,y
*
* Ask for the name of the printer
L01F5    leax  >H.PSTRS,pcr printer strings heading
         lbsr  OUT.SECT
         bcs   QTERM
         leax  >L.PRTSEQ,pcr  enter the character sequences for printer
         lbsr  L0304

QTERM equ *

*
* Ask for terminal here
*
 ifeq ASKTERM
* Only ask if not loaded from TRM file.
*        tst   <u0003
*        bne QCHARS
*        lbsr Q.TNAME

QCHARS   leax  >H.TERM,pcr   Terminal characteristics heading
         lbsr  OUT.SECT
         bcs   QHELPS
* First ask for ANSI
         leax  >L0B3A,pcr   ANSI terminal?
         lbsr  Q.YESNO  ask Y/N question
         bcs   QATTRs   skip sequences if ANSI
         com   <ANSIFLAG Invert, because it gets inverted back
QATTRS   leax  >L.TATTRS,pcr   Enter terminal attributes
         lbsr  L0304
         leax  >H.TSTRS,pcr printer strings heading
         lbsr  OUT.SECT
         bcs   QHELPS
         leax  >L.TRMSEQ,pcr   enter the terminal sequences
         lbsr  L0304
QKEYS    leax  >L.KEYS,pcr   enter the terminal keys - always
         lbsr  L0304
 endc

QHELPS leax  >L.KEEPH,pcr Do you wish to keep helps
         leau  >$FB+TRMBASE,y
         inc   <u001F
         lbsr  Q.YESNO  ask Y/N question
         bcs   L021A
         clr   >$FB+TRMBASE,y   yes to keep helps
         bra   L0220
L021A    ldb   #$FF    no to keep helps
         stb   >$FB+TRMBASE,y
L0220    leax  >L0D34,pcr Do you want to change anything
         clr   <u0003
         lbsr  Q.YESNO  ask Y/N question
         lbcc  L01D5
         tst   <ANSIFLAG   check if ANSI chars should be initialised
         beq   L0248    0 - skip
         ldb   #12
         leau  >$B8+TRMBASE,y     
         leax  >L0273,pcr
L023B    lda   ,x+
         sta   ,u+
         decb
         bne   L023B
         lda   #$FF    Set ANSI flag
         sta   >$B0+TRMBASE,y   CURSPOS

* Save the settings
L0248    leax  >L078E,pcr   Dynacalc.trm
         lda   #$06
         ldb   #$3F
         os9   I$Create
         bcs   L0262
         leax  >TRMBASE,y
         ldy   #$3200
         os9   I$Write
         bcc   L0269
L0262    leax  >L07F3,pcr
         lbra  ERREXIT
L0269    leax  >L088A,pcr  Installation complete
         lbsr  CRTEXT
         lbra  L06ED

L0273    fcb   $1B,'[,'K     ANSI Clear from cursor to end of line
         fcb   $FF,$FF,$FF
         fcb   $1B,'[,'J     ANSI Clear screen from cursor and down
         fcb   $FF,$FF,$FF

L027F    equ *
* Code for repeat printer questions here?
         rts

* Write section heading and ask if change.
OUT.SECT    lbsr  OUT.CR
         lbsr  OUT.CR
         tst   <u0003
         bne   L0295
         pshs  x
         leax  >L.CHANGE,pcr   Change
         lbsr  OUT.TXT
         puls  x
L0295    lbsr  OUT.TXT
         clra
         tst   <u0003
         bne   L027F
         leax  >L.QMARK,pcr
         stx   V.LABEL
         lbra  Q.YESNO2

L02A6    tst   <u0003
         bne   L027F
L02AA    pshs  x
         tst   ,u
         bpl   L02C0
         lda   ,u
         leax  >L0D8D,pcr    **col**
         cmpa  #$88
         beq   L02DD
         leax  >L0D85,pcr    ++row++
         bra   L02DD
L02C0    tfr   u,x
         tst   <u0008
         bne   L02CE
         lda   #'$
         lbsr  OUTCHAR
         lbsr  OUT.HEX
L02CE    clr   <u0008
         lbsr  L02FF
         lda   ,x
         cmpa  #$20
         bne   L02E2
         leax  >L0D1A,pcr  (S)
L02DD    lbsr  OUT.TXT
         bra   L02F8
L02E2    bhi   L02F1
         pshs  a
         dec   <u0006
         lda   #'^
         lbsr  OUTCHAR
         puls  a
         ora   #$40
L02F1    lbsr  OUTCHAR
         inc   <u0006
         inc   <u0006
L02F8    lbsr  L02FD
         puls  pc,x
L02FD    bsr   L02FF
L02FF    lda   #$20
         lbra  OUTCHAR

* Entry of character sequences
L0304 equ *
* Skip certain sections that are not relevant for Dragon
         tst   <ANSIFLAG
         beq   L0324  skip skips if ANSI is 0
         leau  >L.CURSOR,pcr  Direct cursor addr for terminal
         pshs  u
         cmpx  ,s++
         bne   L0316 continue if X is not L.CURSOR
         leax  >L.HILITE,pcr   highlight on (7 chars)

L0316    leau  >L.OFFSET,pcr   direct cursor addressing row offset
         pshs  u
         cmpx  ,s++
         bne   L0324
         leax  >L.NUMCOL,pcr   Number of columns

L0324    stx   V.LABEL
         lbsr  CRTEXT
         ldd   ,x++   Get the address of the parameter
         addd  #TRMBASE
         leau  d,y
         lda   ,x+    Get question type
         anda  #$0F  Is it cursor addressing question
         bne   L0397 ..no
* Entry of sequence for cursor position
L0336    lda   #$FF
         sta   >$10C+TRMBASE,y
         sta   >$110+TRMBASE,y  Flush type-ahead buffer
         stu   <u0023
         stx   <u0021
         inc   <u0020
         lbsr  L0505  Ask about direct cursor addressing
         clr   <u0020
         leau  >CURSPOS+TRMBASE,y
         ldb   #$FF
L0351    incb
         lda   b,u
         bpl   L0351
         cmpa  #$88
         bne   L0366
         tst   >$10C+TRMBASE,y
         bpl   L0391
         stb   >$10C+TRMBASE,y
         bra   L0351
L0366    cmpa  #$99
         bne   L0376
         tst   >$110+TRMBASE,y
         bpl   L0391
         stb   >$110+TRMBASE,y
         bra   L0351
L0376    tst   >$110+TRMBASE,y
         bmi   L0384
         tst   >$10C+TRMBASE,y
         lbpl  L03FF
L0384    leax  >L0DDB,pcr
L0388    lbsr  CRTEXT
         ldu   <u0023
         ldx   <u0021
         bra   L0336
L0391    leax  >L0D95,pcr
         bra   L0388

* Ask question depending on type
L0397    deca
         bne   Q.TYPE2 Not type 1 question
* Ask about keys
         lbsr  L02A6
         lbsr  Q.KEY
         tst   <u0007
         bne   L03AC
         cmpa  #$0D
         beq   L0405
         cmpa  #$20
         beq   L03AE
L03AC    sta   ,u
L03AE    lbsr  L02AA
         lbra  L03FF

Q.TYPE2    deca
         bne   Q.TYPE3 Not type 2 question
         clrb
         pshs  x
         inc   <u001F
         lbsr  Q.YESNO2
         bcc   L03C2
         comb
L03C2    stb   ,u
         puls  x
         lbra  L03FF
Q.TYPE3    deca
         bne   Q.TYPE4 Not type 3 question
         lda   ,u
         lbsr  L040E
         sta   ,u
         lbra  L03FF
Q.TYPE4    deca
         bne   Q.TYPE5 Not type 4 question
         lbsr  L0505
         lbra  L03FF
Q.TYPE5    deca
         bne   Q.TYPE6 Not type 5 question
         lda   ,u
         lbsr  L0406
         tst   <u0004
         beq   L0405
         sta   ,u
         lbra  L03FF
Q.TYPE6    deca
         bne   L03F8 Not type 6 question
         lbsr  Q.PNAME
         bra   L03FF

L03F8    leax  >L0D1E,pcr   Program got to...
         lbsr  CRTEXT
L03FF    tst   ,x
         lbpl  L0304
L0405    rts

L0406    inca
         lbsr  L040E
         beq   L040D
         deca
L040D    rts

L040E    pshs  u,x
L0410    clr   <u0000
         sta   <u0001
         leax  ,y
         clrb
         lbsr  L0732
         lbsr  L02FD
         clr   <u0004
         clr   <u0005
L0421    lbsr  Q.KEY
         cmpa  #$0D
         bne   L0431
         tst   <u0004
         bne   L0479
         puls  u,x
         leas  $02,s
         rts
L0431    cmpa  #$20
         bne   L0441
         leax  ,y
         clrb
         lbsr  L0732
         lda   <u0001
         inc   <u0004
         puls  pc,u,x

L0441    cmpa  <u0035
         beq   L0465
         cmpa  <u0036
         beq   L0465
         sta   <u0002
         lbsr  L0727
         bcs   L0421
         tfr   a,b
         lda   <u0002
         lbsr  OUTCHAR
         stb   <u0002
         ldb   <u0005
         lda   #$0A
         mul
         tsta
         bne   L0465
         addb  <u0002
         bcc   L046E
L0465    ldx   V.LABEL
         lbsr  CRTEXT
         lda   <u0001
         bra   L0410
L046E    stb   <u0005
         ldb   <u0004
         incb
         stb   <u0004
         cmpb  #$03
         bne   L0421
L0479    lda   <u0005
         puls  pc,u,x

* Ask for terminal model name
Q.TNAME  leax  >L0C62,pcr  Enter your terminal's name
         lbsr  CRTEXT
         lbsr  L0654 Read line
         leau  >$DE+TRMBASE,y
         ldb   #$10
         leax  <$4C,y
L0490    lda   ,x+
         cmpa  #$0D
         beq   L049D
         sta   ,u+
         decb
         bne   L0490
         bra   L04A5
L049D    lda   #$20
L049F    sta   ,u+
         subb  #$01
         bgt   L049F
L04A5    lda   #$04
         sta   >$EE+TRMBASE,y
         rts

* Ask for name of printer
Q.PNAME    pshs  x
         leau  >$680+TRMBASE,y
         ldb   #$FF
L04B4    incb
         tst   b,u
         bne   L04B4 Next byte if not null
         tstb
         beq   L04D0 Null in first byte?
         leax  >L0B96,pcr Printer device currently...
         lbsr  CRTEXT
         lda   #C$EOT set end of text
         sta   b,u
         tfr   u,x
         lbsr  OUT.TXT
         clr   b,u  set back to 0
         bra   L04D7

L04D0    leax  >L0BB1,pcr   No printer currently
         lbsr  CRTEXT
L04D7    leax  >L0BD3,pcr   Do you wish to change it?
         lbsr  Q.YESNO  ask Y/N question
         bcs   L0503
         leax  >L0BEC,pcr  Printer pathname
         lbsr  CRTEXT
         lbsr  L0654
         leau  >$680+TRMBASE,y
         leax  <$4C,y
         ldb   #$3C
* Copy user input to TRM file
L04F3    lda   ,x+
         cmpa  #$0D
         beq   L04FE
         sta   ,u+
         decb
         bne   L04F3
L04FE    ldd   #$2000 Append space and null
         std   ,u
L0503    puls  pc,x

* Direct cursor addressing sequence
L0505    pshs  x
         lda -1,x
         lsra
         lsra
         lsra
         lsra
         sta   <u0004
         clr   <u0000
         clr   <u0001
L0513    inc   <u0001
L0515    lbsr  L057F
         ldb   <u0001
         decb
L051B    lbsr  Q.KEY
         tst   <u0007
         bne   L055D
         tst   <u0020
         beq   L0536
         cmpa  #'*
         bne   L052E
         lda   #$88
         bra   L055D
L052E    cmpa  #'+
         bne   L0536
         lda   #$99
         bra   L055D
L0536    cmpa  #$20
         bne   L0544
         lda   b,u
         bpl   L055F
         cmpa  #$A0
         bhi   L057A
         bra   L055F
L0544    cmpa  #'.
         beq   L056E
         cmpa  #$0D
         beq   L057A
         cmpa  <u0035
         bne   L055D
         dec   <u0001
         bne   L0558
         inc   <u0001
         bra   L051B
L0558    inc   <u0004
         decb
         bra   L0515

L055D    sta   b,u
L055F    pshs  u
         leau  b,u
         lbsr  L02AA
         puls  u
         dec   <u0004
         bne   L0513
         inc   <u0001
* Copy $FF into TRM
L056E    lda   #$FF
         ldb   <u0001
         decb
L0573    sta   b,u
         incb
         dec   <u0004
         bpl   L0573
L057A    lbsr  OUT.CR
         puls  pc,x

L057F    pshs  u
         lbsr  OUT.CR
         ldb   #$FF
         leax  ,y
         lbsr  L0732
         lda   #'>
         lbsr  OUTCHAR
         lda   #$20
         lbsr  OUTCHAR
         ldb   <u0001
         decb
         clr   <u0006
         lda   b,u
         bpl   L05A2
         cmpa  #$A0
         bhi   L05A7
L05A2    leau  b,u
         lbsr  L02AA
L05A7    lda   #$20
         ldb   <u0006
L05AB    lbsr  OUTCHAR
         decb
         bpl   L05AB
         puls  pc,u

* Ask Y/N question
Q.YESNO    stx   V.LABEL
Q.YESNO1    ldx   V.LABEL
         lbsr  CRTEXT
Q.YESNO2    lda   #'?
         lbsr  OUTCHAR
         lda   #$20
         lbsr  OUTCHAR
         lbsr  L0682
         cmpa  #$11   Ctrl-Q
         lbne  L05D5
         leax  >E.QUIT,pcr  Unconditional quit
         clrb
         lbra  ERREXIT
L05D5    anda  #$5F
         cmpa  #'Y
         beq   L05FD
         cmpa  #'N
         beq   L05FC
         cmpa  #$0D    Newline entered?
         beq   L05FC   interpret as no
         tsta
         bne   Q.YESNO1
         tst   <u001F
         beq   Q.YESNO1
         clr   <u001F
         lda   ,u
         bne   L05F7
         lda   #'Y
         lbsr  OUTCHAR
         clra
         rts
L05F7    lda   #'N
         lbsr  OUTCHAR
L05FC    coma
L05FD    rts

Q.KEY    pshs  x,b
         lbsr  READCHR
         clr   <u0007
         clr   <u0008
         cmpa  #'&    Prefix for special characters '&', '$' etc.
         beq   L060F
         cmpa  #'$   ASCII code entered in hexadecimal
         bne   L0652
L060F    sta   <u0007
L0611    lbsr  READCHR
         cmpa  <u0007
         beq   L0652
         ldb   <u0007
         cmpb  #'$
         beq   L0626
         cmpa  #'@
         bcs   L0652 Lower than @
         anda  #$1F
         bra   L0652

* Read hex value
L0626    lbsr  L0716
         bcs   L0611
         lsla
         lsla
         lsla
         lsla
         pshs  a
         lda   #'$
         lbsr  OUTCHAR
         com   <u0008
         lda   <u0009
         lbsr  OUTCHAR
L063D    lbsr  READCHR
         lbsr  L0716
         bcs   L063D
         adda  ,s+
         pshs  a
         lda   <u0009
         lbsr  OUTCHAR
         puls  a
         anda  #$7F
L0652    puls  pc,x,b

L0654    pshs  u,y
         clra
         clrb
         ldu   <u0028
         leax  >u03CC,u
         os9   I$GetStt
         inc   $04,x
         os9   I$SetStt
         clra
         leax  <u004C,u
         ldy   #$0100
         os9   I$ReadLn
         lbcs  FATAL
         leax  >u03CC,u
         clr   $04,x
         clra
         clrb
         os9   I$SetStt
         puls  pc,u,y

L0682    bsr   READCHR
         lbra  OUTCHAR

* Read a character
READCHR    pshs  y,x,a
         tfr   s,x
         ldy   #$0001
         clra
         os9   I$Read
         lbcs  FATAL
         puls  a
         anda  #$7F
         sta   <u0009
         puls  pc,y,x

OUT.CR    lda   #$0D
* Write a character
OUTCHAR    pshs  y,x,a
         tst   <u002D  Upper case needed?
         beq   L06B1 ..no
         cmpa  #$61
         bcs   L06B1
         cmpa  #$7A
         bhi   L06B1
         anda  #$5F
L06B1    pshs  a
         tfr   s,x
         lda   #$01
         ldy   #$0001
         os9   I$Write
         lbcs  FATAL
         puls  a
         cmpa  #$0D
         bne   L06D0
         tst   <u0031
         beq   L06D0
         lda   #$0A
         bra   L06B1
L06D0    puls  pc,y,x,a

* Write a line starting with CR
* Line must end with C$EOT
* Output X points to address after end of string
CRTEXT   lda   #$0D
L06D4    bsr   OUTCHAR
* Write line
OUT.TXT    lda   ,x+
         cmpa  #C$EOT
         bne   L06D4
         rts

FATAL    leax  >L07E7,pcr  Fatal error
ERREXIT  stb   <errcode
         lbsr  CRTEXT
         leax  >L0821,pcr  Installation aborted
         lbsr  OUT.TXT
L06ED    lbsr  OUT.CR
         clra
         clrb
         ldx   <u0028
         leax  <$2C,x
         os9   I$SetStt
         ldb   <errcode
         os9   F$Exit

* Print byte as hex
OUT.HEX   lda   ,x
         lsra
         lsra
         lsra
         lsra
         bsr   L070B
         lda   ,x
         anda  #$0F
L070B    adda  #'0
         cmpa  #'9+1
         bcs   L0713
         adda  #'A-'9-1
L0713    lbra  OUTCHAR

* Parse hex value
L0716    bsr   L0727
         bcc   L0726
         suba  #$11
         bcs   L0726
         pshs  a
         adda  #$0A
         ldb   #$05
         subb  ,s+
L0726    rts

L0727    suba  #'0
         bcs   L0731
         pshs  a
         ldb   #$09
         subb  ,s+
L0731    rts

L0732    pshs  u,y,x,b,a
         stb   <u0015
         ldd   ,x
         leay  <$18,y
         bsr   L074B
         ldb   #$04
         stb   ,y
         ldx   <u0028
         leax  <$18,x
         lbsr  OUT.TXT
         puls  pc,u,y,x,b,a

L074B    clr   <u0017
         leax  >L0786,pcr
L0751    bsr   L0769
         leau  >L078E,pcr   Dynacalc.trm
         pshs  u
         cmpx  ,s++
         bne   L0751
         tfr   b,a
         pshs  cc
L0761    inc   <u0017
L0763    adda  #$30
         sta   ,y+
L0767    puls  pc,a

L0769    clr   <u0016
L076B    inc   <u0016
         subd  0,x
         bcc   L076B
         addd  ,x++
         pshs  a
         lda   <u0016
         deca
         bne   L0761
         tst   <u0017
         bne   L0761
         tst   <u0015
         bne   L0767
         lda   #$F0
         bra   L0763

L0786    fdb   10000,1000,100,10

L078E    fcs   "Dynacalc.trm"
L079A    fcs   "Dynacalc.cor"
L07A6    fcb   $0D,$0A
         fcc   "Error loading specified .trm file"
         fcb   C$EOT
L07CA    fcc   'Error loading "Dynacalc.cor"'
         fcb   C$EOT
L07E7    fcc   "Fatal error"
         fcb   C$EOT
L07F3    fcc   "Error writing Dynacalc.trm"
         fcb   C$EOT
E.QUIT   fcc   "Unconditional quit"
         fcb   C$EOT
L0821    fcc   "- Installation aborted !!"
         fcb   $07
         fcb   $0d
         fcb   C$EOT
L083D    fcc   "Output file (Dynacalc.trm) already exists in"
         fcb   $0d
         fcc   "the Working Execution Directory"
         fcb   C$EOT
L088A    fcc   "Installation complete."
         fcb   C$EOT

L08A1    fcc   "DYNACALC Customization program, Version 4.7:3"
         fcb   $0D
         fcb   C$EOT

* FLEX instructions:
* INSTRUCTIONS-
* THIS PROGRAM WILL PROMPT YOU FOR VARIOUS ATTRIBUTES OF YOUR TERMINAL AND
* PRINTER. YOU MAY RESPOND BY PRESSING THE APPROPRIATE KEY, ENTERING THE HEX
* VALUE (IE, $20), OR AN AMPERSAND (&) FOLLOWED BY A LETTER OR SYMBOL WHICH
* WILL BE CONVERTED TO ITS CONTROL EQUIVALENT. TO ENTER A "$" OR "&" AS A
* CHARACTER, SIMPLY TYPE THEM TWICE AND THE FIRST ONE WILL BE "SWALLOWED"
* EACH FUNCTION AND ITS CURRENT SETTING (IF IT HAS ONE) WILL BE DISPLAYED.
* YOU THEN HAVE THE OPTION OF CHANGING IT, OR GOING TO THE NEXT ONE BY
* HITTING THE SPACE BAR. THIS IMPLIES THAT IF A SPACE IS MEANT TO BE
* ENTERED, ONE MUST ENTER EITHER "$20" OR "& (SPACE)". IF YOU ARE INPUTTING
* NUMBER STRINGS, YOU CAN USE THE "BACKSPACE CHARACTER" (SEE FLEX'S "TTYSET")
* TO BACK UP TO THE PREVIOUS VALUE. THIS ALSO IMPLIES THAT TO ENTER THE BACK-
* SPACE CHARACTER YOU MUST TYPE "$08" OR "&H" (IF B.S. IS SET TO THAT).
* PRESSING A CARRIAGE RETURN WILL MOVE YOU TO THE NEXT CATEGORY.
* A CARRIAGE RETURN IN RESPONSE TO A YES/NO QUESTION WILL BE TAKEN AS NO.
*
* DON'T WORRY IF YOU MAKE A MISTAKE ENTERING ANYTHING, AS YOU WILL BE
* GIVEN ANOTHER CHANCE BEFORE ANY DISK WRITING IS DONE. HAVE FUN !!!

* If terminal questions are not activated then we know this is the 51 columns
 ifeq ASKTERM
L.INSTR fcc "INSTRUCTIONS-"
 fcc   "INSTALL.DC is a program for changing some of the characteristics of DYNACALC."
 fcb   $0D
 fcc   "To use it, you must have the file DYNACALC.COR in your execution directory,"
 fcb   $0D
 fcc   "and you must delete your old DYNACALC.TRM, eg:"
 fcb   $0D
 fcc   "   OS9: del /d0/cmds/dynacalc.trm"
 fcb   $0D
 fcc   "INSTALL will prompt you for various attributes of your terminal and printer."
 fcb   $0D
 fcc   "Pressing ENTER will retain the existing setting and move to the next category."
 fcb   $0D
 fcc   "Pressing ENTER in response to a YES/NO question will be taken as NO."
 fcb   $0D
 fcb   $0A
 fcc   "Don't worry if you make a mistake entering anything. You will be given another"
 fcb   $0D
 fcc   "chance before INSTALL changes DYNACALC on the disk."
 fcb   $0D
 fcb   C$EOT
 else
L.INSTR    fcc   "INSTRUCTIONS-"
         fcb   $0D
         fcc   "INSTALL.DC is a program for changing some of"
         fcb   $0D
         fcc   "characteristics of DYNACALC. To use it, you"
         fcb   $0D
         fcc   "must have the file DYNACALC.COR in your"
         fcb   $0D
         fcc   "execution directory, and you must delete your"
         fcb   $0D
         fcc   "old DYNACALC.TRM, eg:"
         fcb   $0D
         fcc   "   OS9: del /d0/cmds/dynacalc.trm"
         fcb   $0D
         fcc   "INSTALL will prompt you for various attributes"
         fcb   $0D
         fcc   "of your printer. Pressing ENTER will retain the"
         fcb   $0D
         fcc   "existing setting, otherwise enter the setting"
         fcb   $0D
         fcc   "you require. Pressing ENTER in response to a"
         fcb   $0D
         fcc   "YES/NO question will be taken as NO."
         fcb   $0D
         fcb   $0A
         fcc   "Don't worry if you make a mistake entering"
         fcb   $0D
         fcc   "anything. You will be given another chance"
         fcb   $0D
         fcc   "before INSTALL changes DYNACALC on the disk."
         fcb   $0D
         fcb   C$EOT
 endc

* Unused
L0B29    fcc   "Now set-up for :"
         fcb   C$EOT

* Unused
L0B3A    fcb   $0A
         fcc   "Does your terminal conform to the American National"
         fcb   $0D
         fcc   'Standards Institute, "ANSI", standards'
         fcb   C$EOT

L0B96    fcc   "Printer device currently: "
         fcb   C$EOT
L0BB1    fcc   "No printer device currently used."
         fcb   C$EOT
L0BD3    fcc   "Do you wish to change it"
         fcb   C$EOT
L0BEC    fcb   $0D
         fcc   "Enter your printer device pathname (Limit 60 char.):"
         fcb   $0D
         fcb   C$EOT

* Unused
L0C23    fcc   "Do you wish to change any screen/keyboard values"
         fcb   C$EOT

* Unused
L0C54    fcc   "Terminal name"
         fcb   C$EOT

L0C62    fcb   $0D
         fcc   "Enter your terminal's name (Up to 16 characters):"
         fcb   $0D
         fcb   C$EOT

* Unused
L0C96    fcc   "Special keys"
         fcb   C$EOT

H.TERM   fcc   "Terminal characteristics"
         fcb   C$EOT
H.TSTRS  fcc   "Terminal strings"
         fcb   C$EOT
H.PSTRS  fcc   "Printer strings"
         fcb   C$EOT

* Section header for printer
H.PRINT    fcc   "Printer characteristics"
         fcb   C$EOT
L.KEEPH    fcb   $0D
         fcc   "Do you wish to keep helps"
         fcb   C$EOT
L.CHANGE    fcc   "Change "
         fcb   C$EOT
L.QMARK    fcc   "?"
         fcb   C$EOT
L0D1A    fcc   "(S)"
         fcb   C$EOT
L0D1E    fcc   "PROGRAM GOT TO XXXXXX"
         fcb   C$EOT
L0D34    fcb   $0A
         fcc   "Do you want to change anything before the data"
         fcb   $0D
         fcc   "is saved (Type cntrl Q to abort)"
         fcb   C$EOT
L0D85    fcc   "++Row++"
         fcb   C$EOT
L0D8D    fcc   "**Col**"
         fcb   C$EOT
L0D95    fcc   "**** You may only specify one column and one row position- Try again."
         fcb   C$EOT
L0DDB    fcc   "**** You must specify both row and column position's- Try again."
         fcb   C$EOT

* Unused - truncated
L0E1C    fcc   "The current string will be printed, along with its"
         fcb   $0D
         fcc   "hex equivalent. Hit the keys you want to be entered"

L.PRTSEQ    fcc   "Enter the character sequences needed for your"
         fcb   $0D
         fcc   "printer. When all characters in a sequence are"
         fcb   $0D
         fcc   "entered, hit period (.). If you need to enter"
         fcb   $0D
         fcc   "period as a character, type $2E. You should note"
         fcb   $0D
         fcc   "that most printers don't need these strings. If"
         fcb   $0D
         fcc   "this is your case, simply hit period for each"
         fcb   $0D
         fcc   "string."
         fcb   $0D
         fcc   "Sequence to turn on printer (3 Char.):"
         fcb   C$EOT
         fdb   $00A8
         fcb   $30+Q$SEQ
         fcc   "Sequence to turn off printer (3 Char.):"
         fcb   C$EOT
         fdb   $00AC
         fcb   $30+Q$SEQ
         fcb   $FF

* Ask about keys
* In some cases arrow keys will be {,[,],}
L.KEYS    fcc   "The function of the key will be displayed, along with"
         fcb   $0D
         fcc   "its current assignment (if it has one). To change, simply"
         fcb   $0D
         fcc   "press the appropriate key. If if's O.K., just press space"
         fcb   $0D
         fcc   "Up arrow- "
         fcb   C$EOT
         fdb   $0100
         fcb   Q$KEY
         fcc   "Down arrow- "
         fcb   C$EOT
         fdb   $0101
         fcb   Q$KEY
L10C2    fcc   "Left arrow- "
         fcb   C$EOT
         fdb   $0102
         fcb   Q$KEY
L10D2    fcc   "Right arrow- "
         fcb   C$EOT
         fdb   $0103
         fcb   Q$KEY
L10E3    fcc   "Home- "
         fcb   C$EOT
         fdb   $0104
         fcb   Q$KEY
L10ED    fcc   "Jump window- "
         fcb   C$EOT
         fdb   $0105
         fcb   Q$KEY
L10FE    fcc   "Get address- "
         fcb   C$EOT
         fdb   GETADDR
         fcb   Q$KEY
L110F    fcc   "Flush type-ahead buffer- "
         fcb   C$EOT
         fdb   $0108
         fcb   Q$KEY
L112C    fcc   "Log-off- "
         fcb   C$EOT
         fdb   $00F7
         fcb   Q$KEY
L1139    fcc   "Backspace- "
         fcb   C$EOT
         fdb   $0109
         fcb   Q$KEY
L1148    fcc   "Edit (From entry level)- "
         fcb   C$EOT
         fdb   $0111
         fcb   Q$KEY
L1165    fcc   "Edit overlay- "
         fcb   C$EOT
         fdb   $010F
         fcb   Q$KEY
         fcb   $FF


L.TATTRS fcc   "The individual attributes will be displayed, along with"
         fcb   $0D
         fcc   "their current value (if present). To change, enter"
         fcb   $0D
         fcc   "the new value. Press space if it's O.K. the way it is."
         fcb   $0D
         fcc   "Bell character- "
         fcb   C$EOT
         fdb   $0106
         fcb   Q$KEY
L.OFFSET fcc   "Direct cursor addressing row offset- "
         fcb   C$EOT
         fdb   $010A
         fcb   Q$KEY
         fcc   "Column offset- "
         fcb   C$EOT
         fdb   $010B
         fcb   Q$KEY
L.NUMCOL fcc   "Number of columns (Limit 127)- "
         fcb   C$EOT
         fdb   $010E
         fcb   Q$NUM
         fcc   "Number of rows - "
         fcb   C$EOT
         fdb   $010D
         fcb   $03
         fcc   "Use UPPER CASE only (regardless of TMODE flag)"
         fcb   C$EOT
         fdb   $00F8
         fcb   Q$YN
         fcb   $FF


L12D5    fcc   "Enter the printer default characteristics. If"
         fcb   $0D
         fcc   "the displayed value is correct, simply hit space."
         fcb   $0D
         fcc   "Note that these are defaults only, and can be"
         fcb   $0D
         fcc   "changed while in DYNACALC using /AP."
         fcb   $0D
         fcb   $0A
         fcc   "Printer device pathname-"
         fcb   C$EOT
         fdb   $0000
         fcb   $06
         fcb   $0D
L13A6    fcc   "Lines per page- "
         fcb   C$EOT
         fdb   $00FF
         fcb   Q$NUM
L13BA    fcc   "Printer width- "
         fcb   C$EOT
         fdb   $00FD
         fcb   Q$NUM
L13CD    fcc   "Line feeds after each line-"
         fcb   $0D
         fcc   "(Range 1 to 8)- "
         fcb   C$EOT
         fdb   $00F9
         fcb   Q$NUM
L13FD    fcc   "Do you want pagination"
         fcb   C$EOT
         fdb   $00FE
         fcb   Q$YN
         fcc   "Do you want to print borders"
         fcb   C$EOT
         fdb   $00FC
         fcb   Q$YN
         fcb   $FF

L.TRMSEQ fcc   "Enter the character strings needed for your terminal."
         fcb   $0D
         fcc   "When all are entered, hit period. If you want"
         fcb   $0D
         fcc   "to enter period as a character, simply type $2E"
         fcb   $0D
         fcc   "Terminal setup (15 CHAR.):"
         fcb   C$EOT
         fdb   $0090
         fcb   $F0+Q$SEQ
         fcc   'Terminal "Kiss-Off" (7 CHAR.):'
         fcb   C$EOT
         fdb   $00A0
         fcb   $70+Q$SEQ
L.CURSOR fcc   "Direct cursor addr. Enter the correct sequence for your"
         fcb   $0D
         fcc   'terminal, typing a "*" where the column position goes and'
         fcb   $0D
         fcc   'a "+" where the row position goes. If you need to enter'
         fcb   $0D
         fcc   'the * or + as a character, preceed with "&". (7 CHAR.):'
         fcb   C$EOT
         fdb   CURSPOS
         fcb   $70
         fcc   "Erase to end of line (Just type period if your terminal"
         fcb   $0D
         fcc   "does not have this feature) (5 CHAR.):"
         fcb   C$EOT
         fdb   $00B8
         fcb   $50+Q$SEQ
         fcc   "Erase to end of page (Just type period if your terminal"
         fcb   $0D
         fcc   "does not have this feature) (5 CHAR.):"
         fcb   C$EOT
         fdb   $00BE
         fcb   $50+Q$SEQ
L.HILITE    fcc   "Hilite on (Period if not used) (7 CHAR.):"
         fcb   C$EOT
         fdb   REVON
         fcb   $70+Q$SEQ
         fcc   "Hilite off (Period if not used) (7 CHAR.):"
         fcb   C$EOT
         fdb   REVOFF
         fcb   $70+Q$SEQ
         fcc   "Following are the terminal cursor on/off strings."
         fcb   $0D
         fcc   "If your terminal does not support this, type a period"
         fcb   $0D
         fcc   "for the next two prompts. If your terminal has only"
         fcb   $0D
         fcc   '"Toggle cursor on/off", enter that string for both'
         fcb   $0D
         fcc   '"Cursor on" and "Cursor off".'
         fcb   $0A,$0D
         fcc   "Cursor on (3 CHAR.):"
         fcb   C$EOT
         fdb   $0088
         fcb   $30+Q$SEQ
         fcc   "Cursor off (3 CHAR.):"
         fcb   C$EOT
         fdb   $008C
         fcb   $30+Q$SEQ
         fcc   "Destructive backspace -"
         fcb   $0D
         fcc   "On most terminals, &H,&(space),&H (5 CHAR.):"
         fcb   C$EOT
         fdb   $00D4
         fcb   $50+Q$SEQ
         fcc   "Non-destructive backspace, usually &H (3 CHAR.):"
         fcb   C$EOT
         fdb   $00DA
         fcb   $30+Q$SEQ
         fcb   $FF

* Default values for key codes and printer
L18AC    fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
         fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
         fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
         fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
         fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
         fcb   $FF,$FF,$FF,$FF,$FF,$FF,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
         fcb   $20,$20,$20,$20,$20,$20,$FF,$FF,$FF,$FF,$00,$00,$00,$FF,$FF,$04
         fcb   $00,$00,$00,$00,$FF,$4F,$00,57,$00,$00,$00,$00,$00,$00,$00,$00
         fcb   $00,$00,$00,$00,$00,24,79,$00,$02,$05,'/,'P,$00

         emod
eom      equ   *
