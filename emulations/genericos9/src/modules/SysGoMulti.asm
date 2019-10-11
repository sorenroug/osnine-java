         nam   SysGo
         ttl   SysGo that runs Login

         ifp1
         use   os9defs
         use   scfdefs
         endc
tylg     set   Systm+Objct
atrv     set   ReEnt+rev
rev      set   $01
edition  set   $05

hwclock  set   $FFDA

         mod   eom,name,tylg,atrv,CldEnt,size
T1PROC   rmb 1 Child process id
stack    rmb   200
size     equ   .
name     equ   *
         fcs   /SysGo/
         fcb   edition

*BootMsg  fcc   "BOOT"
*         fcb   C$CR,C$LF
*         fcb   C$LF
*MsgSize  equ *-BootMsg

ExecDir  fcc   "Cmds"
         fcb   C$CR
         fcc   ",,,,,," room for patch

TSMon    fcc   "TSMon"
         fcb   C$CR
         fcc   ",,,,,," room for patch

TSMonArg fcc   "/T2"
         fcb   C$CR
TSMonEnd equ   *

Login    fcc   "Login"
         fcb   C$CR
         fcc   ",,,,,," room for patch

LoginArg fcb   C$CR
         fcc   ",,,,,," room for patch
LoginEnd equ   *

* SysGo entry point
CldEnt   leax  >IcptRtn,pcr     * Set up empty intercept
         os9   F$Icpt

*        leax  >BootMsg,pcr
*        ldy   #MsgSize
*        lda   #$01
*        os9   I$Write

* OS9p2 has looked for a module called "Clock" and initialised it.
         ldx   #hwclock
         os9   F$STime

* Set the execution directory
         leax  >ExecDir,pcr
         lda   #EXEC. Get execution mode
         os9   I$ChgDir

* Start up TSMon on terminal 2
* Ignore any failures
         leax  >TSMon,pcr
         leau  >TSMonArg,pcr
         ldd   #OBJCT*256 Get type
         ldy   #TSMonEnd-TSMonArg   Parameter size
         os9   F$Fork

FrkLogin leax  >Login,pcr
         leau  >LoginArg,pcr
         ldd   #OBJCT*256 Get type
         ldy   #LoginEnd-LoginArg   Parameter size
         os9   F$Fork
         bcs   DeadEnd
         sta   T1PROC save process id
LoginW   os9   F$Wait
         bcs   DeadEnd
         cmpa  T1PROC Child went away?
         bne   LoginW
         bra   FrkLogin

DeadEnd  bra   DeadEnd

* Intercept routine
IcptRtn  rti
         emod
eom      equ   *
