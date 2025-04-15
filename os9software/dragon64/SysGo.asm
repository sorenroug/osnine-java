         nam   SysGo
         ttl   os9 system module    

         ifp1
         use   defsfile
         endc
tylg     set   Systm+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
stack    rmb   200
size     equ   .
name     equ   *
         fcs   /SysGo/
         fcb   5 edition

BootMsg  fcc   "  OS-9 LEVEL ONE   VERSION 1.2"
         fcb   C$CR,C$LF
         fcc   "COPYRIGHT 1980 BY MOTOROLA INC."
         fcb   C$CR,C$LF
         fcc   "  AND MICROWARE SYSTEMS CORP."
         fcb   C$CR,C$LF
         fcc   "   REPRODUCED UNDER LICENSE"
         fcb   C$CR,C$LF
         fcc   "     TO DRAGON DATA LTD."
         fcb   C$CR,C$LF
         fcc   "     ALL RIGHTS RESERVED."
         fcb   C$CR,C$LF
         fcb   C$LF
MsgEnd   equ   *
L00C6    fcc   "Cmds"
         fcb   C$CR
         fcc   ",,,,,,,,,,"
Shell    fcc   "Shell"
         fcb   C$CR
         fcc   ",,,,,,,,,,"
Startup  fcc   "STARTUP -P"
         fcb   C$CR
         fcc   ",,,,,,,,,,"
         
BasicRst fcb   $55
         fcb   $00
         fcb   $74
         fcb   $12
         clr   >$FF03 reset keyboard
         sta   >$FFDF switch to Dragon 32 mode
         jmp >$F002

* SysGo entry point
start    equ   *
         leax  >IcptRtn,pcr
         os9   F$Icpt   
         leax  >BasicRst,pcr
         ldu   #$0071
         ldb   #start-BasicRst
CopyLoop lda   ,x+
         sta   ,u+
         decb  
         bne   CopyLoop
         leax  >BootMsg,pcr
         ldy   #MsgEnd-BootMsg
         lda   #$01
         os9   I$Write  
         leax  >L00C6,pcr
         lda   #$04
         os9   I$ChgDir 
         leax  >Shell,pcr
         leau  >Startup,pcr
         ldd   #$0100
         ldy   #$0015
         os9   F$Fork   
         bcs   DeadEnd
         os9   F$Wait   
FrkShell leax  >Shell,pcr
         ldd   #$0100
         ldy   #$0000
         os9   F$Fork   
         bcs   DeadEnd
         os9   F$Wait   
         bcc   FrkShell
DeadEnd  bra   DeadEnd

* Intercept routine
IcptRtn  rti
         emod
eom      equ   *
