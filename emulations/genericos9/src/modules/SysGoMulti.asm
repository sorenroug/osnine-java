         nam   SysGo
         ttl   SysGo that runs Login on /Term

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

TSMonArg fcc   "/T1"
         fcb   C$CR
TSMonEnd equ   *

Login    fcc   "Login"
         fcb   C$CR
         fcc   ",,,,,," room for patch

LoginArg fcb   C$CR
*        fcc   ",,,,,," room for patch
LoginSiz equ   *-LoginArg

Shell    fcc   "Shell"
         fcb   C$CR
         fcc   ",,,,,," room for patch
SHLFUN   fcc   "STARTUP -P"
         fcb   C$CR
FUNSIZ   equ *-SHLFUN
         fcc   ",,,,," room for patch

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

* Run the startup script
         leax  >Shell,pcr
         leau  >SHLFUN,pcr
         ldd   #OBJCT*256 Get type
         ldy   #FUNSIZ
         os9   F$Fork
         bcs   DeadEnd
         os9   F$Wait Wait for it

* Start up TSMon on terminal 1
* Ignore any failures
         leax  >TSMon,pcr
         leau  >TSMonArg,pcr
         ldd   #OBJCT*256 Get type
         ldy   #TSMonEnd-TSMonArg   Parameter size
         os9   F$Fork

FrkLogin leax  >Login,pcr
         leau  >LoginArg,pcr
         ldd   #OBJCT*256+3 Set type and 3 pages of data for shell
         ldy   #0      No parameters
         os9   F$Fork
         bcs   DeadEnd

*        pshs  a
LoginW   os9   F$Wait
         bcs   DeadEnd
*        cmpa  1,s Login Child went away?
*        bne   LoginW
*        puls  a
         bra   FrkLogin

DeadEnd  bra   DeadEnd

* Intercept routine
IcptRtn  rti
         emod
CldEnd      equ   *
