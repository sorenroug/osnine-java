         nam   Dir
         ttl   program module       

         use   defsfile

tylg     set   Prgrm+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size

C$SLSH set '/
C$COLN set ':

u0000    rmb   2
DirPN    rmb   1
Extended    rmb   1
ExeDir    rmb   1
u0005    rmb   1
u0006    rmb   1
BufPtr    rmb   1
u0008    rmb   1
u0009    rmb   3
u000C    rmb   3
DirEnt   rmb   29
LSN1     rmb   1
LSN2     rmb   1
LSN3     rmb   1
u002F    rmb   30
u004D    rmb   2
FileDesc rmb   1
FileOwnr rmb   2
u0052    rmb   6
u0058    rmb   2
u005A    rmb   2
Buffer    rmb   280
size     equ   .
name     equ   *
         fcs   /Dir/
         fcb   $03 

DirOf    fcb   C$LF
         fcs   " Directory of "

L0020    fcc   "."
         fcb   C$CR

Header    fcb   C$LF
 ifeq Screen-small
         fcc   "CREATED ON   OWNER   NAME"
         fcb   C$LF
         fcc   "  ATTR     START      SIZE"
         fcb   C$LF
         fcc   "==============================="
 else
         fcc   "Attr    Owner  Created on      Start      Size  Name"
         fcb   C$LF
         fcc   "===================================================="
 endc
         fcb   C$CR
HeadEnd  equ   *

start    equ   *
         leay  <Buffer,u
         sty   <BufPtr
         clr   <ExeDir
         clr   <Extended
         lbsr  ParsOpts
         lda   ,-x
         cmpa  #C$CR     End of argument string?
         bne   L008F
         leax  >L0020,pcr
L008F    stx   <u0000
         lda   #$81      Mode bit for open
         ora   <ExeDir
         os9   I$Open   
         lbcs  Exit
         sta   <DirPN
         pshs  x
         leay  >DirOf,pcr
         lbsr  WrString
         ldx   <u0000
L00A9    lda   ,x+
         lbsr  OUTCHR
         cmpx  ,s
         bcs   L00A9
         leas  $02,s
         lbsr  ParsOpts
         lbsr  WrSpace
         lbsr  WrSpace
         leax  u0009,u
         os9   F$Time   
         leax  u000C,u
         lbsr  PRTIME
         lbsr  WrLine
         tst   <Extended
         beq   L0111
         lda   <DirPN
         ldb   #$00
         leax  <u002F,u
         os9   I$GetStt 
         lbcs  Exit
         ldx   <u004D
         ldx   $04,x
         ldd   $04,x
         leay  d,x
         lda   #'/
         lbsr  OUTCHR
         lbsr  WrString
         lda   #$40
         lbsr  OUTCHR
         lbsr  WrSpace
         leax  <Buffer,u
         stx   <BufPtr
         lda   #$01
         os9   I$Open   
         lbcs  Exit
         sta   <u0005
         leax  >Header,pcr
         ldy   #HeadEnd-Header
         lda   #$01
         os9   I$WritLn 
L0111    lda   <DirPN
         ldx   #$0000
         pshs  u
         ldu   #$0040
         os9   I$Seek   
         puls  u
         bra   L0181
L0122    tst   <DirEnt
         beq   L0181
         tst   <Extended
         bne   L0142
         leay  DirEnt,u
         lbsr  WrString
L012F    lbsr  WrSpace
         ldb   <u0008
         subb  #$5C
         cmpb  #$14
         bhi   L017E
L013A    subb  #10
         bhi   L013A
         bne   L012F
         bra   L0181

* Read file descriptor of file
L0142    pshs  u
         lda   LSN3
         clrb  
         tfr   d,u
         ldx   LSN1
         lda   <u0005
         os9   I$Seek   
         puls  u
         bcs   Exit
         leax  <FileDesc,u
         ldy   #$000D
         os9   I$Read   
         bcs   Exit

* Print extended entry
         lbsr  L0228
         ldd   <FileOwnr
         clr   <u0006
         bsr   L019E
         bsr   WrSpace
         leay  DirEnt,u
         lbsr  WrString
         lbsr  WrLine
         lbsr  Attrs
         bsr   WrSpace
         bsr   WrSpace
         bsr   WrStart
         bsr   WrSize
L017E    lbsr  WrLine
L0181    leax  DirEnt,u
         ldy   #$0020
         lda   <DirPN
         os9   I$Read   
         bcc   L0122
         cmpb  #$D3
         bne   Exit
         clrb  
Exit     bsr   WrLine
         os9   F$Exit   

WrStart  lda   <LSN1
         bsr   L01C2
         ldd   <LSN2
L019E    bsr   L01C4
         tfr   b,a
         bsr   L01B8
         inc   <u0006
         bsr   L01C6
         bra   WrSpace
WrSize   ldd   <u0058
         bsr   L01C2
         tfr   b,a
         bsr   L01C4
         bsr   WrSpace
         ldd   <u005A
         bra   L019E
L01B8    pshs  a
         lsra  
         lsra  
         lsra  
         lsra  
         bsr   L01C8
         puls  pc,a

* Print number in hex
L01C2    clr   <u0006
L01C4    bsr   L01B8
L01C6    anda  #$0F
L01C8    tsta  
         beq   L01CD
         sta   <u0006
L01CD    tst   <u0006
         bne   L01D5
         lda   #$20
         bra   OUTCHR
L01D5    adda  #$30
         cmpa  #$39
         bls   OUTCHR
         adda  #$07
         bra   OUTCHR

WrSpace  lda   #$20
OUTCHR   pshs  x
         ldx   <BufPtr
         sta   ,x+
         stx   <BufPtr
         puls  pc,x

PermFlgs fcc   "dsewrewr"
         fcb   $FF        stop byte

Attrs    ldb  <FileDesc
         leax  <PermFlgs,pcr
         lda   ,x+
L01FB    lslb  
         bcs   L0200
         lda   #$2D
L0200    bsr   OUTCHR
         lda   ,x+
         bpl   L01FB
         rts   

WrString    lda   ,y
         anda  #$7F
         bsr   OUTCHR
         lda   ,y+
         bpl   WrString
         rts   

WrLine pshs  y,x,a
         lda   #$0D
         bsr   OUTCHR
         leax  <Buffer,u
         stx   <BufPtr
         ldy   #$0050
         lda   #$01
         os9   I$WritLn 
         puls  pc,y,x,a

L0228    leax  <u0052,u
         bsr   PRTNUM
         bsr   L0239
         bsr   L0239
         bsr   WrSpace
         bsr   PRTNUM
         bsr   PRTNUM
         bra   WrSpace

L0239    lda   #C$SLSH
         bra   L0243

*****
* Prtime
*   Print "HH:MM:SS"
*
PRTIME bsr PRTNUM
 bsr PRTI10
PRTI10 lda #C$COLN
L0243    bsr   OUTCHR

*****
* Prtnum
*   Print 8-Bit Ascii Number In (,X+)
*
PRTNUM ldb ,X+
 lda #'0-1
 cmpb  #100
 bcs   PRTN10
 clrb  
PRTN10 inca Form Hundreds digit
 subb #100
 bcc PRTN10
 cmpa  #'0
 beq PRTN20 Print if not zero
 bsr OUTCHR
PRTN20 lda #'9+1
PRTN30 deca Form Tens digit 
 addb #10
 bcc PRTN30
 lbsr OUTCHR
 tfr b,a
 adda #'0  Form units digit
 lbra OUTCHR

ParsOpts  ldd   ,x+
         cmpa  #$20    Space
         beq   ParsOpts
         cmpa  #$2C    Comma
         beq   ParsOpts
         eora  #'E
         anda  #$DF
         bne   L0282
         cmpb  #$30
         bcc   L0282
         inc   <Extended
         bra   ParsOpts
L0282    lda   -$01,x
         eora  #'X
         anda  #$DF
         bne   L0294
         cmpb  #$30      followed by a letter?
         bcc   L0294
         lda   #$04
         sta   <ExeDir
         bra   ParsOpts
L0294    rts   
         emod
eom      equ   *
