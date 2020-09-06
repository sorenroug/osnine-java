         nam   SysGo
         ttl   SysGo that runs Login on /T1 and /T2
**************************
* UNFINISHED
**************************
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

TERMTAB  rmb 1 Child process id
         rmb 2 Pointer to terminal
         rmb 1 Child process id
         rmb 2 Pointer to terminal

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

TERMS    fcc   "/T1"
         fcb   C$CR
         fcc   "/T2"
         fcb   C$CR

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
*
* Create table of child pids + terminals
         ldb  #NUMTERMS
         leay TERMTAB,u   Load element 0 pointer
         leax TERMS,pcr   Load first terminal
TAB01    pshs y    Store in memory
         stx  1,y
         pshs b
         os9  F$PrsNam
         puls b
         tfr  y,x
         leax 1,x     Skip the whitespace
         puls y
         leay 3,y   Jump to next entry
         decb
         bgt  TAB01

         leay TERMTAB,u   Load element 0 pointer
         pshs y
* Close path 0, 1 and 2
         ldb  #NUMTERMS
OPENTERM
         clra
         OS9 I$Close close std input
         inca
         OS9 I$Close close std output
         inca
         OS9 I$Close close std error
* Open terminal pointed to by X
         ldx 1,y    Load address of terminal string
         lda #UPDAT.
         OS9 I$OPEN Open new std input
         bcs DeadEnd
         OS9 I$DUP Dup  new std output
         bcs DeadEnd
         OS9 I$DUP Dup  new std error
         bcs DeadEnd

FrkLogin leax  Login,pcr
         leau  LoginArg,pcr
         pshs b,y
         ldd   #OBJCT*256 Get type
         ldy   #0  No parameters
         os9   F$Fork
         bcs   DeadEnd
         puls b,y
         puls y
         sta   0,y save process id
         leay  3,y   Jump to next entry
         decb
         bgt  OPENTERM

LoginW   os9   F$Wait
         bcs   DeadEnd
         ldb  #NUMTERMS
         leay TERMTAB,u   Load element 0 pointer
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
