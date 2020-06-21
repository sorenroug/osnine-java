         nam   SysGo
         ttl   os9 system module    

         ifp1
         use   defsfile
         endc
tylg     set   Systm+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   200
size     equ   .
name     equ   *
         fcs   /SysGo/
         fcb   $04 
         fcc   /(C) 1982 Microware/

L0025    fcc   /Cmds/
         fcb   $0D 
Shell    fcc   /Shell/
         fcb   $0D 
SHLFUN    fcc   /STARTUP -p/
         fcb   $0D 
start    equ   *
         leax  >CLICPT,pcr
         os9   F$Icpt   
* CXD to cmds
         leax  >L0025,pcr
         lda   #$04
         os9   I$ChgDir 
*
         leax  >Shell,pcr
         leau  >SHLFUN,pcr
         ldd   #$0100
         ldy   #$000B
         os9   F$Fork   
         bcs   CLDERR
         os9   F$Wait   
CLDM10   leax  >Shell,pcr
         ldd   #$0100
         ldy   #$0000
         os9   F$Fork   
         bcs   CLDERR
         os9   F$Wait   
         bcc   CLDM10
CLDERR    jmp   [>$FFFE]

CLICPT rti COLDSTART Intercept routine
         emod
eom      equ   *
