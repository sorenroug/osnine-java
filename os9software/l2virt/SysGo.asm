 nam SysGo
 ttl SysGo - system bootstrap startup module

 use defsfile


*****
*
*  Coldstart Module
*
* Starts Cmd Module On Path "/Term"
*
Type set PRGRM+OBJCT
Revs set 1
 mod CldEnd,CldNam,Type,Revs,CldEnt,CldMem
CldNam fcs /SysGo/
 fcb 2 

 rmb   256
CldMem equ .

DirStr fcc "Cmds"
 fcb $D
CMDSTR fcc "Shell"
 fcb $D
SHLFUN fcc "Startup -p"
 fcb $D
FUNSIZ equ *-SHLFUN

CldEnt leax CLICPT,PCR Set up signal intercept
 OS9 F$ICPT
 leax DirStr,PCR Get directory name ptr
 lda #EXEC. Get execution mode
 OS9 I$ChgDir Change execution directory
* NOTE: do not test for error, at least system will boot
         os9   F$ID     
         ldb   #$80
         os9   F$SPrior 
 leax CMDSTR,PCR Get ptr to "shell"
 leau SHLFUN,PCR Get ptr to startup file name
 ldd #OBJCT*256 Get type
 ldy #FUNSIZ Size of parameters
 OS9 F$FORK Execute startup file
 bcs CLDERR Branch if error
 OS9 F$WAIT Wait for it
CLDM10 leax CMDSTR,PCR Get command name ptr
 ldd #OBJCT*256
 ldy #0 No parameters
 OS9 F$FORK Start new process
 bcs CLDERR
 OS9 F$WAIT Wait for it to die
 bcc CLDM10

CLDERR jmp [$FFEE]

CLICPT rti COLDSTART Intercept routine

 emod Module Crc

CldEnd equ *

