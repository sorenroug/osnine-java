 nam SysGo
 ttl SysGo - system bootstrap startup module

* Copyright 1980 by Motorola, Inc., and Microware Systems Corp.,
* Reproduced Under License

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than 
* the licensee is strictly prohibited!
*

 use defsfile

*****
*
*  Coldstart Module
*
* Starts Cmd Module On Path "/Term"
*
Type set SYSTM+OBJCT
Revs set REENT+2
 mod CldEnd,CldNam,Type,Revs,CldEnt,CldMem
CldNam fcs /SysGo/

 fcb 6 Edition number

 rmb 256 stack space
CldMem equ .

DirStr fcc "Cmds"
 fcb $D
 fcc "," room for patch
CMDSTR fcc "Shell"
 fcb $D
 fcc ",,,,,,,,,," room for patch
SHLFUN fcc "STARTUP -p"
 fcb $D
FUNSIZ equ *-SHLFUN
 fcc ",,,,,,,,,," room for patch

RELMSG fcb $A
 fcb $D
 fcc "OS9 Level 1 Version 1.2"
 fcb $A
 fcb $D
 fcc "SYNTEL MICROSYSTEMS  Release 2.0"
 fcb $A
 fcb $D
MSGEND equ *-RELMSG

CLKSTR    fcc "clock"
         fcb   $0D

CldEnt leax CLICPT,PCR Set up signal intercept
 OS9 F$ICPT
         leax  >CLKSTR,pcr
         lda   #$C1
         os9   F$Link
         bcs   CHGXD
         jsr   ,y
CHGXD leax DirStr,PCR Get directory name ptr
 lda #EXEC. Get execution mode
 OS9 I$ChgDir Change execution directory
         os9   F$ID
         ldb   #$80
         os9   F$SPrior
         leax  >RELMSG,pcr
         ldy   #MSGEND
         lda   #$01
         os9   I$Write
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

CLDERR jmp [$FFFE]

CLICPT rti COLDSTART Intercept routine

 emod Module Crc

CldEnd equ *
