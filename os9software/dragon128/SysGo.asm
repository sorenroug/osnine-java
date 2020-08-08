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
Type set Prgrm+Objct
Revs set 1
 mod SGoEnd,SGoNam,Type,Revs,SGoEnt,SGoMem
SGoNam fcs /SysGo/

 fcb 2 Edition Number
*****
* REVISION HISTORY
* edition 1: prehistoric
* edition 2: made nonreentrant and bcs on chdir removed MGH 4/8/83
*****

SGoMem equ 256 Total Static Storage requirement

DirStr fcc "Cmds"
 fcb $D
CmdStr fcc "Shell"
 fcb $D
 ifne TEST
 else
ShlFun fcc "Startup -p"
 endc
 fcb $D
FunSiz equ *-ShlFun

SGoEnt leax SGoIncpt,pc set up signal intercept
 OS9 F$ICPT
 ifeq TEST
 leax DirStr,PCR Get directory name ptr
 lda #Exec. Get execution mode
 OS9 I$ChgDir Change execution directory
*edition 2: removed to allow sys to come up even if
*           the chgdir fails-
*bcs SGoErr Branch if error
 endc
 os9 F$ID get process ID
 ldb #128 get medium priority
 os9 F$SPrior set priority
 leax CmdStr,PCR get ptr to "SHELL"
 leau ShlFun,PCR get ptr to startup file name
 ldd #Objct*256 Get Type
 ldy #FunSiz size of parameters
 OS9 F$Fork execute startup file
 bcs SGoErr branch if error
 OS9 F$Wait Wait for it
SysG.A leax CmdStr,PCR get command name ptr
 ldd #Objct*256
 ldy #0 no parameters
 OS9 F$Fork start new process
 bcs SGoErr
 OS9 F$WAIT Wait for it to die
 bcc SysG.A

SGoErr jmp [D$REBOOT]

SGoIncpt rti do-nothing intercept

 emod Module CRC

SGoEnd equ *

 end
