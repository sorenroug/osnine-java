* Disassembled from GIMIX dir command

         nam   Dir
         ttl   program module       

         use   defsfile

tylg     set   Prgrm+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   2
u0002    rmb   1
u0003    rmb   1
ExeDir    rmb   1
u0005    rmb   1
u0006    rmb   1
u0007    rmb   1
u0008    rmb   1
u0009    rmb   3
u000C    rmb   3
DirEnt    rmb   29
LSN1    rmb   1
LSN2    rmb   1
LSN3    rmb   1
FileDesc    rmb   1
u0030    rmb   2
u0032    rmb   6
u0038    rmb   2
u003A    rmb   2
u003C    rmb   530
size     equ   .
name     equ   *
         fcs   /Dir/
         fcb   $04 

L0011    fcb   $10 
L0012    fcb   $30

DirOf    fcb   C$LF
         fcs "   directory of "

L0024    fcb   $2E .
         fcb   C$CR

L0026    fcb   $40 @
         fcb   $0D 

Header    fcb   C$LF
         fcc "Owner Last modified attributes sector bytecount name"
         fcb   C$LF
         fcc "----- ------------- ---------- ------ --------- ----------"
         fcb   C$CR


start    equ   *
         leay  <u003C,u
         sty   <u0007
         clr   <ExeDir
         clr   <u0003
         lbsr  ParsOpts
         lda   ,-x
         cmpa  #C$CR     End of argument string?
         bne   L00B0
         leax  >L0024,pcr
L00B0    stx   <u0000
         lda   #$81
         ora   <ExeDir
         pshs  x,a
         os9   I$Open   
         sta   <u0002
         puls  x,a
         lbcs  L019D
         os9   I$ChgDir 
         lbcs  L019D
         pshs  x
         leay  >DirOf,pcr
         lbsr  WrString
         ldx   <u0000
L00D5    lda   ,x+
         lbsr  OUTCHR
         cmpx  ,s
         bcs   L00D5
         leas  $02,s
         lbsr  ParsOpts
         lbsr  WrSpace
         lbsr  WrSpace
         leax  u0009,u
         os9   F$Time   
         leax  u000C,u
         lbsr  PRTIME
         lbsr  WrLine
         tst   <u0003
         beq   L0118
         lda   #$01
         ora   <ExeDir
         leax  >L0026,pcr
         os9   I$Open   
         lbcs  L019D
         sta   <u0005
         leax  >Header,pcr
         ldy   #$0071
         lda   #$01
         os9   I$WritLn 
L0118    lda   <u0002
         ldx   #$0000
         pshs  u
         ldu   #$0040
         os9   I$Seek   
         puls  u
         bra   L018B
L0129    tst   <DirEnt
         beq   L018B
         tst   <u0003
         bne   L014D
         leay  DirEnt,u
         lbsr  WrString
L0136    lbsr  WrSpace
         ldb   <u0008
         subb  #$3C
         cmpb  >L0012,pcr
         bhi   L0188
L0143    subb  >L0011,pcr
         bhi   L0143
         bne   L0136
         bra   L018B
L014D    pshs  u
         lda   <LSN3
         clrb  
         tfr   d,u
         ldx   <LSN1
         lda   <u0005
         os9   I$Seek   
         puls  u
         bcs   L019D
         leax  <FileDesc,u
         ldy   #13
         os9   I$Read   
         bcs   L019D

         ldd   <u0030
         clr   <u0006
         bsr   L01A8
         bsr   WrSpace
         lbsr  PRTDAT
         bsr   WrSpace
         lbsr  Attrs
         bsr   WrSpace
         bsr   WrSpace
         bsr   L01A2
         bsr   L01B4
         leay  DirEnt,u
         lbsr  WrString
L0188    lbsr  WrLine
L018B    leax  DirEnt,u
         ldy   #$0020
         lda   <u0002
         os9   I$Read   
         bcc   L0129
         cmpb  #$D3
         bne   L019D
         clrb  
L019D    bsr   WrLine
         os9   F$Exit   

L01A2    lda   <LSN1
         bsr   L01CC
         ldd   <LSN2
L01A8    bsr   L01CE
         tfr   b,a
         bsr   L01C2
         inc   <u0006
         bsr   L01D0
         bra   WrSpace
L01B4    ldd   <u0038
         bsr   L01CC
         tfr   b,a
         bsr   L01CE
         bsr   WrSpace
         ldd   <u003A
         bra   L01A8

L01C2    pshs  a
         lsra  
         lsra  
         lsra  
         lsra  
         bsr   L01D2
         puls  pc,a
L01CC    clr   <u0006
L01CE    bsr   L01C2
L01D0    anda  #$0F
L01D2    tsta  
         beq   L01D7
         sta   <u0006
L01D7    tst   <u0006
         bne   L01DF
         lda   #$20
         bra   OUTCHR
L01DF    adda  #$30
         cmpa  #$39
         bls   OUTCHR
         adda  #$07
         bra   OUTCHR
WrSpace    lda   #$20
OUTCHR    pshs  x
         ldx   <u0007
         sta   ,x+
         stx   <u0007
         puls  pc,x

PermFlgs fcc   "dsewrewr"
         fcb   $FF        stop byte

Attrs    ldb  <FileDesc
         leax  <PermFlgs,pcr
         lda   ,x+
L0205    lslb  
         bcs   L020A
         lda   #$2D
L020A    bsr   OUTCHR
         lda   ,x+
         bpl   L0205
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
         leax  <u003C,u
         stx   <u0007
         ldy   #$0050
         lda   #$01
         os9   I$WritLn 
         puls  pc,y,x,a

*****
* Prtdat
*   Print "YY/MM/DD"
*
PRTDAT   leax  FileDesc+FD.DAT,u
         bsr   PRTNUM
         bsr   PRSLSH
         bsr   PRSLSH
         bsr   WrSpace
         bsr   PRTNUM
         bsr   PRTNUM
         bra   WrSpace
PRSLSH    lda   #$2F
         bra   L024D

*****
* Prtime
*   Print "HH:MM:SS"
*
PRTIME    bsr   PRTNUM
         bsr   L024B
L024B    lda   #$3A
L024D    bsr   OUTCHR

*****
* Prtnum
*   Print 8-Bit Ascii Number In (,X+)
*
PRTNUM    ldb   ,x+
         lda   #$2F
         cmpb  #$64
         bcs   PRTN10
         clrb  
PRTN10    inca  
         subb  #$64
         bcc   PRTN10
         cmpa  #$30
         beq   PRTN20
         bsr   OUTCHR
PRTN20 lda #'9+1
PRTN30 deca Form Tens digit 
         addb  #$0A
         bcc   PRTN30
         lbsr  OUTCHR
         tfr   b,a
 adda #'0  Form units digit
         lbra  OUTCHR


ParsOpts    ldd   ,x+
         cmpa  #$20
         beq   ParsOpts
         cmpa  #$2C
         beq   ParsOpts
         eora  #$45
         anda  #$DF
         bne   L028C
         cmpb  #$30
         bcc   L028C
         inc   <u0003
         bra   ParsOpts
L028C    lda   -$01,x
         eora  #$58
         anda  #$DF
         bne   L029E
         cmpb  #$30
         bcc   L029E
         lda   #$04
         sta   <ExeDir
         bra   ParsOpts
L029E    rts   
         emod
eom      equ   *
