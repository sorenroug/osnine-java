         nam   SysGo
         ttl   SysGo single user boot

         ifp1
         use   os9defs
         use   scfdefs
         endc
tylg     set   Systm+Objct   
atrv     set   ReEnt+rev
rev      set   $01
edition  set   $05

hwclock  set   $FFDA

         mod   CldEnd,CldNam,tylg,atrv,CldEnt,size
stack    rmb   200
size     equ   .

CldNam   fcs   /SysGo/
         fcb   edition
BootMsg  fcc   "OS-9 Level One Single User Boot"
         fcb   C$CR,C$LF
         fcb   C$LF
MsgSize  equ *-BootMsg

ExecDir  fcc   "Cmds"
         fcb   C$CR
         fcc   ",,,,,," room for patch

Shell    fcc   "Shell"
         fcb   C$CR
         fcc   ",,,,,," room for patch
SHLFUN   fcc   "STARTUP -P"
         fcb   C$CR
FUNSIZ   equ *-SHLFUN
         fcc   ",,,,,," room for patch
         
* SysGo entry point
CldEnt   leax  >IcptRtn,pcr
         os9   F$Icpt   

         leax  >BootMsg,pcr
         ldy   #MsgSize
         lda   #$01
         os9   I$Write  

* OS9p2 has looked for a module called "Clock" and initialised it.
         ldx   #hwclock
         os9   F$STime

         leax  ExecDir,pcr
         lda   #EXEC. Get execution mode
         os9   I$ChgDir 

* Run the startup script
         leax  >Shell,pcr
         leau  >SHLFUN,pcr
         ldd   #OBJCT*256 Get type
         ldy   #FUNSIZ
         os9   F$Fork   
         bcs   DeadEnd
         os9   F$Wait Wait for it

* Run the shell
FrkShell leax  >Shell,pcr
         ldd   #OBJCT*256 Get type
         ldy   #0  No parameters
         os9   F$Fork   
         bcs   DeadEnd
         os9   F$Wait   
         bcc   FrkShell
DeadEnd  bra   DeadEnd

* Intercept routine
IcptRtn  rti
         emod
CldEnd   equ   *
