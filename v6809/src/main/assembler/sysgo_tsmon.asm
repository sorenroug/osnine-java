         nam   SysGo
         ttl   SysGo that runs TSMON

         ifp1
         use   os9defs
         use   scfdefs
         endc
tylg     set   Systm+Objct   
atrv     set   ReEnt+rev
rev      set   $01
edition  set   $05

hwclock  set   $FF10
         mod   eom,name,tylg,atrv,start,size
stack    rmb   200
size     equ   .
name     equ   *
         fcs   /SysGo/
         fcb   edition
BootMsg  fcc   "BOOT"
         fcb   C$CR,C$LF
         fcb   C$LF
MsgEnd   equ   *
ExecDir  fcc   "Cmds"
         fcb   C$CR
         fcc   ",,,,,," room for patch
TSMon    fcc   "TSMon"
         fcb   C$CR
         fcc   ",,,,,," room for patch
TSMonArg fcb   C$CR
         fcc   ",,,,,," room for patch
         
* SysGo entry point
start    equ   *
         leax  >IcptRtn,pcr     * Set up empty intercept
         os9   F$Icpt   

         leax  >BootMsg,pcr
         ldy   #MsgEnd-BootMsg
         lda   #$01
         os9   I$Write  

* OS9p2 has looked for a module called "Clock" and initialised it.
         ldx   #hwclock
         os9   F$STime
* Set the execution directory
         leax  >ExecDir,pcr
         lda   #$04      EXEC.
         os9   I$ChgDir 

FrkTSMon leax  >TSMon,pcr
         leau  >TSMonArg,pcr
         ldd   #$0100
         ldy   #start-TSMonArg   Parameter size
         os9   F$Fork   
         bcs   DeadEnd
         os9   F$Wait   
         bcc   FrkTSMon
DeadEnd  bra   DeadEnd

* Intercept routine
IcptRtn  rti
         emod
eom      equ   *
