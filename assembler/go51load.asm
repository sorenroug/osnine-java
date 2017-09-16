         nam   go51
         ttl   program module       

         ifp1
         use   os9defs
         use   scfdefs
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
         fcb   $01 
KbVdIO   fcs   /KBVDIO/
Drvr51   fcs   /drvr51/
Term     fcs   /term/

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
         ldd   $02,x
         std   DrvrSize,u      * Store size of drvr51 module
         pshs  u,cc
         orcc  #$50
         ldx   >$006B      * D.AltIRQ
         stx   >$0032      * D.IRQ
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
         leax  d,x        Point to module name of KBVDIO
         leay  >KbVdIO,pcr
         ldb   #$06       Length of KBVDIO name
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
         lda   #$18
         sta   $08,x
         lda   #$01
         ldb   #SS.Opt
         os9   I$SetStt 
         bcs   EXIT
         leax  >Term,pcr
         lda   #Devic+Objct
         pshs  u
         os9   F$Link   
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
