         nam   SysGo
         ttl   SysGo that runs Login

* It seems that while operating in SysGo, i$dup and i$close are ignored.
* When opening /T2 first, the login prompt still comes on /T1

* This version without data storage

         ifp1
         use   os9defs
         use   scfdefs
         endc
tylg     set   Systm+Objct
atrv     set   ReEnt+rev
rev      set   $01
edition  set   $05

hwclock  set   $FFDA
NUMTERMS equ   2

         mod   CldEnd,name,tylg,atrv,CldEnt,size

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

T1STR    fcc   "/T1"
         fcb   C$CR
T2STR    fcc   "/T2"
         fcb   C$CR

Login    fcc   "Login"
         fcb   C$CR
         fcc   ",,,,,," room for patch

LoginArg fcb   C$CR
         fcc   ",,,,,," room for patch
LoginEnd equ   *

TERMTAB  fcb   $00 space for pid
         fdb   T1STR-TERMTAB
         fcb   $00
         fdb   T2STR-TERMTAB

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

         leay TERMTAB,pcr   Load element 0 pointer
* Close path 0, 1 and 2
         ldb  #NUMTERMS
OPENTERM
         pshs y   Save ptr to current element
         clra
         OS9 I$Close close std input
         inca
         OS9 I$Close close std output
         inca
         OS9 I$Close close std error
* Open terminal pointed to by X
         pshs b
         ldd 1,y    Load address of terminal string
         leax TERMTAB,pcr
         leax d,x
         lda #UPDAT.
         OS9 I$OPEN Open new std input
         bcs DeadEnd
         OS9 I$DUP Dup  new std output
         bcs DeadEnd
         OS9 I$DUP Dup  new std error
         bcs DeadEnd
         puls b

FrkLogin leax  Login,pcr
         leau  LoginArg,pcr
         pshs b
         ldd   #OBJCT*256 Get type
         ldy   #0  No parameters
         os9   F$Fork
         bcs   DeadEnd
         puls b,y
         sta   0,y save process id
         leay  3,y   Jump to next entry
         decb
         bgt  OPENTERM

LoginW   os9   F$Wait
         bcs   DeadEnd
         ldb  #NUMTERMS
         leay TERMTAB,pcr   Load element 0 pointer
NxtChld  cmpa  0,y Child went away?
         beq   OPENTERM
         leay  3,y   Jump to next entry
         decb
         bgt   NxtChld  More children to check
         bra   LoginW  No child matched - wait again

DeadEnd  bra   DeadEnd

* Intercept routine
IcptRtn  rti
         emod
CldEnd   equ   *
