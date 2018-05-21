         nam   SysGo
         ttl   os9 system module    

         ifp1
         use   /dd/defs/os9defs
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
L0030    fcc   /STARTUP -p/
         fcb   $0D 
start    equ   *
         leax  >L007B,pcr
         os9   F$Icpt   
* CXD to cmds
         leax  >L0025,pcr
         lda   #$04
         os9   I$ChgDir 
*
         leax  >Shell,pcr
         leau  >L0030,pcr
         ldd   #$0100
         ldy   #$000B
         os9   F$Fork   
         bcs   L0077
         os9   F$Wait   
L0062    leax  >Shell,pcr
         ldd   #$0100
         ldy   #$0000
         os9   F$Fork   
         bcs   L0077
         os9   F$Wait   
         bcc   L0062
L0077    jmp   [>$FFFE]

L007B    rti   
         emod
eom      equ   *
