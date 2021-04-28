 nam SysGo
 ttl SysGo - system bootstrap startup module

 use defsfile

***********************************************************
*
*     Program SysGo
*
*   Sets execution directory, executes startup file,
*   and loops, forking a shell and waiting for it
*
TEST set 0
Type     set   Prgrm+Objct
Revs     set   ReEnt+1

 mod SGoEnd,SGoNam,Type,Revs,SGoEnt,200

SGoNam fcs /SysGo/

 fcb 1 Edition Number

DirStr fcs "Cmds"

CmdStr fcc "Shell"
 fcb $0D

Setime fcc "Setime"
 fcb $0D

Welcome fcb $0A
 fcb $0A
 fcc "Positron Computers Limited"
 fcb $0A
 fcb $0A
 fcc "********  Welcome  *******"
 fcb $0A
 fcb $0A
 fcb $0D
WelcSiz equ *-Welcome

ShlFun fcc "Startup"
 fcb $0D
FunSiz equ *-ShlFun

SGoEnt leax SGoIncpt,pc set up signal intercept
 OS9 F$ICPT
 leax DirStr,PCR Get directory name ptr
 lda #Exec. Get execution mode
 OS9 I$ChgDir Change execution directory

 os9 F$ID get process ID
 ldb #128 get medium priority
 os9 F$SPrior set priority
 leax Setime,pcr
 ldd #Objct*256
 ldy #0 no parameters
 os9 F$Fork
 bcs SysG.A
 os9 F$Wait
SysG.A leax Welcome,pcr
 ldy #WelcSiz
 lda #1
 os9 I$WritLn
 leax CmdStr,PCR get ptr to "SHELL"
 ldd #Objct*256 Get Type
 ldy #FunSiz size of parameters
 leau ShlFun,pcr
 os9 F$Fork
 bcs SysG.B
 os9 F$Wait
SysG.B leax CmdStr,pcr
 ldd #Objct*256
 ldy #0 no parameters
 OS9 F$Fork start new process
 OS9 F$WAIT Wait for it to die
 bra SysG.B

SGoIncpt rti do-nothing intercept

 emod
SGoEnd equ *
