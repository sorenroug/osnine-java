* Disassembled from GIMIX dir command

         nam   Dir
         ttl   program module

         use   defsfile

tylg     set   Prgrm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   DIREND,name,tylg,atrv,DIRENT,size
DIRPATH    rmb   2
DirPN    rmb   1
Extended    rmb   1
ExeDir    rmb   1
DISKPN    rmb   1
SUPZER    rmb   1
BufPtr    rmb   1
u0008    rmb   1
DATEBUF    rmb   6
DIRREC    rmb   29
LSN1    rmb   1
LSN2    rmb   1
LSN3    rmb   1
FileDesc    rmb   13
Buffer    rmb   530
size     equ   .
name     equ   *
         fcs   /Dir/
         fcb   $04

L0011    fcb   $10
MARGIN    fcb   $30

DirOf    fcb   C$LF
         fcs "   directory of "

DEFDIR    fcb   $2E .
         fcb   C$CR

L0026    fcb   $40 @
         fcb   $0D

Header    fcb   C$LF
         fcc "Owner Last modified attributes sector bytecount name"
         fcb   C$LF
         fcc "----- ------------- ---------- ------ --------- ----------"
         fcb   C$CR


DIRENT   leay  Buffer,u
         sty   BufPtr
         clr   ExeDir
         clr   Extended
         lbsr  ParsOpts
         lda   ,-x
         cmpa  #C$CR     End of argument string?
         bne   DIRENT10
         leax  >DEFDIR,pcr
DIRENT10 stx DIRPATH
 lda #DIR.+READ.
         ora   ExeDir
         pshs  x,a
         os9   I$Open
         sta   DirPN
         puls  x,a
         lbcs  Exit
         os9   I$ChgDir
         lbcs  Exit
         pshs  x
         leay  >DirOf,pcr
         lbsr  WrString
         ldx   DIRPATH
DIRENT20    lda   ,x+
         lbsr  OUTCHR
         cmpx  ,s
         bcs   DIRENT20
         leas  $02,s
         lbsr  ParsOpts
         lbsr  OUTSPC
         lbsr  OUTSPC
         leax  DATEBUF,u
         os9   F$Time
         leax  DATEBUF+3,u
         lbsr  PRTIME
         lbsr  WrLine
         tst   Extended
         beq   BEGIN
         lda   #$01
         ora   ExeDir
         leax  >L0026,pcr
         os9   I$Open
         lbcs  Exit
         sta   DISKPN
         leax  >Header,pcr
         ldy   #$0071
         lda   #$01
         os9   I$WritLn
BEGIN    lda   DirPN
         ldx   #$0000
         pshs  u
         ldu   #$0040
         os9   I$Seek
         puls  u
         bra   NEXTENT
PRENT    tst   DIRREC
         beq   NEXTENT
         tst   Extended
         bne   LSTEXT
         leay  DIRREC,u
         lbsr  WrString
PRENT10 lbsr OUTSPC
 ldb BufPtr+1
 subb #Buffer
         cmpb  MARGIN,pcr
         bhi   NEWLINE
PRENT20    subb  >L0011,pcr
         bhi   PRENT20
         bne   PRENT10
         bra   NEXTENT
LSTEXT    pshs  u
         lda   LSN3
         clrb
         tfr   d,u
         ldx   LSN1
         lda   DISKPN
         os9   I$Seek
         puls  u
         bcs   Exit
         leax  <FileDesc,u
         ldy   #13
         os9   I$Read
         bcs   Exit

         ldd   FileDesc+FD.OWN
         clr   SUPZER
         bsr   HEXWORD
         bsr   OUTSPC
         lbsr  PRTDAT
         bsr   OUTSPC
         lbsr  ATTRS
         bsr   OUTSPC
         bsr   OUTSPC
         bsr   WrStart
         bsr   WrSize
         leay  DIRREC,u
         lbsr  WrString
NEWLINE    lbsr  WrLine
NEXTENT    leax  DIRREC,u
         ldy   #$0020
         lda   DirPN
         os9   I$Read
         bcc   PRENT
         cmpb  #$D3
         bne   Exit
         clrb
Exit    bsr   WrLine
         os9   F$Exit

WrStart    lda   LSN1
         bsr   OUTHEX10
         ldd   <LSN2
HEXWORD    bsr   OUTHEX20
         tfr   b,a
         bsr   OUTHEX
         inc   SUPZER
         bsr   OUTHEX30
         bra   OUTSPC
WrSize ldd <FileDesc+FD.SIZ
         bsr   OUTHEX10
         tfr   b,a
         bsr   OUTHEX20
         bsr   OUTSPC
 ldd <FileDesc+FD.SIZ+2
         bra   HEXWORD

OUTHEX    pshs  a
         lsra
         lsra
         lsra
         lsra
         bsr   OUTHEX40
         puls  pc,a

OUTHEX10    clr   SUPZER
OUTHEX20    bsr   OUTHEX
OUTHEX30    anda  #$0F
OUTHEX40    tsta
         beq   L01D7
         sta   SUPZER
L01D7    tst   SUPZER
         bne   OUT1HX
         lda   #$20
         bra   OUTCHR
OUT1HX    adda  #$30
         cmpa  #$39
         bls   OUTCHR
         adda  #$07
         bra   OUTCHR
OUTSPC    lda   #$20
OUTCHR    pshs  x
         ldx   BufPtr
         sta   ,x+
         stx   BufPtr
         puls  pc,x

PermFlgs fcc   "dsewrewr"
         fcb   $FF        stop byte

ATTRS    ldb  <FileDesc
         leax  <PermFlgs,pcr
         lda   ,x+
ATTRS10    lslb
         bcs   ATTRS20
         lda   #$2D
ATTRS20    bsr   OUTCHR
         lda   ,x+
         bpl   ATTRS10
         rts

WrString    lda   ,y
         anda  #$7F
         bsr   OUTCHR
         lda   ,y+
         bpl   WrString
         rts

WrLine    pshs  y,x,a
         lda   #$0D
         bsr   OUTCHR
         leax  Buffer,u
         stx   BufPtr
         ldy   #$0050
         lda   #$01
         os9   I$WritLn
         puls  pc,y,x,a

*****
* Prtdat
*   Print "YY/MM/DD"
*
PRTDAT leax FileDesc+FD.DAT,u
 bsr PRTNUM
 bsr PRSLSH
 bsr PRSLSH
 bsr OUTSPC
 bsr PRTNUM
 bsr PRTNUM
 bra OUTSPC

PRSLSH    lda   #$2F
         bra   PRTI20

*****
* Prtime
*   Print "HH:MM:SS"
*
PRTIME    bsr   PRTNUM
         bsr   PRTI10
PRTI10    lda   #$3A
PRTI20    bsr   OUTCHR

*****
* Prtnum
*   Print 8-Bit Ascii Number In (,X+)
*   Only used for date and time
PRTNUM ldb ,X+
 ifne Y2K
PRTN10 subb #100 Remove any hundreds
 else
 lda #'0-1
 cmpb #100
 bcs PRTN10
 clrb
PRTN10 inca
 subb #100 Remove any hundreds
 endc
 bcc PRTN10
 ifeq Y2K
 cmpa  #'0
 beq PRTN20 Print if not zero
 bsr OUTCHR
 endc
PRTN20 lda #'9+1
PRTN30 deca Form Tens digit
 addb #10
 bcc PRTN30
 lbsr OUTCHR
 tfr b,a
 adda #'0  Form units digit
 lbra OUTCHR

ParsOpts  ldd   ,x+
 cmpa #$20    Space
 beq ParsOpts
 cmpa #$2C    Comma
 beq ParsOpts
 eora #'E
 anda #$DF
 bne PARSE10
 cmpb #$30
 bcc PARSE10
 inc Extended
 bra ParsOpts
PARSE10 lda -$01,x
 eora #'X
 anda #$DF
 bne PARSE20
 cmpb #'0 followed by a letter?
 bcc PARSE20
 lda #EXEC.
 sta ExeDir
 bra ParsOpts
PARSE20 rts
 emod

DIREND equ *
