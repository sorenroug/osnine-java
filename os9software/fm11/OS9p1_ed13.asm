 nam OS-9 Level II kernal, part 1
 ttl System Type definitions

********************************
* Extracted from Fujitsu FM-11 computer
********************************

************************************************************
*                                                          *
*           OS-9 Level II V1.2 - Kernal, part 1            *
*                                                          *
* Copyright 1982 by Microware Systems Corporation          *
* Reproduced Under License                                 *
*                                                          *
* This source code is the proprietary confidential prop-   *
* erty of Microware Systems Corporation, and is provided   *
* to the licensee solely for documentation and educational *
* purposes. Reproduction, publication, or distribution in  *
* any form to any party other than the licensee is         *
* is strictly prohibited !!!                               *
*                                                          *
************************************************************

*****
*
*  Module Header
*
 use defsfile

Revs set REENT+1
 mod OS9End,OS9Nam,SYSTM,Revs,0,0

OS9Nam   fcs   /OS9p1/

************************************************************
*
*     Edition History
*
* Edition $28 - Beginning of history
*   pre-82/8/10
*
* Edition   1 - Addition of 6829 modifications
*   82/8/10
*
* Edition   2 - Addition of Profitel & Gimix2 CPU types
*   82/10/1
*
* Edition   3 - changes in timing of process state flag Switching
*   82/11/6
*
* Edition   4 -
*             - change "AllImage to set DAT image change flag after
*               actually changing the image
*             - change "Slice" to not decrement "D.Slice" below zero
*
* Edition   5 - change "SetImage" to set DAT image change flag after
*   83/01/20    actually changing the image
*
* Edition   6 - complete changes for write-protecting modules
*   83/01/26  - change initialization for Positron systems
*
* Edition   7 - change "ModCheck" to not give up time slice
*             - change "#SysTask" references to "D.SysTsk" references
*               where possible
*
* Edition   8 - add COMTROL CPU type
*
* Edition   9 - extensive modification for non-contiguous modules
*               WGP  83/5/4
*             - change handling of UnMemTE and WritPrTE errors
*               so debug can trap them.
*             - modify nextproc for use of suspend state   WGP 83/06/01
*             - fix bug in write protect portion of Link   WGP 83/06/02
*
* Edition  10 - added Motorola GED requirements (ramchk romchk)
*             - change handling of UnMemTE and WritPrTE errors
*               so debug can trap them.
*             - added Low RAM save for MotGED restart.  D.CldRes
*               setup for os9p3 to use as vedtor for restart
*             - Reserved more RAM for copy area
*
* Edition  11 - Added Conditionals for Delco Cpu          RES 83/07/25
*

 fcb 13
 fcc "FM11L2"
 ttl Coldstart Routines
 pag
************************************************************
*
*     Routine Cold
*
*   System Coldstart; determines system state, initializes
* system data structures, searches for the remainder of the
* system and attempts to start operation.
*
LoRAM set $20 set low RAM limit
HiRAM set DAT.Blsz*RAMCount

*
*      clear system RAM
*
TEST set 0 not test mode
Cold ldx #LoRAM get low limit ptr
 ldy #HiRAM-LoRAM get byte count
 clra CLEAR D
 clrb
Cold10 std ,X++ clear memory
 leay -2,Y count bytes
 bne Cold10 branch if more
*
*     initialize DAT image, Memory Block Map, &
*        Module Directory ptrs
*
 inca skip direct page
 std D.Tasks set Task User Table ptr
 addb #DAT.TkCt allocate Task User Table
 std D.TmpDAT set temporary DAT stack ptr
 clrb
 inca allocate DAT stack
 std D.BlkMap set free memory block map
 adda #DAT.BMSz/256 allocate memory block map
 std D.BlkMap+2 set initialization ptr
 std D.SysDis set System Dispatch Table ptr
 inca allocate table
 std D.UsrDis set User Dispatch Table ptr
 inca allocate table
 std D.PrcDBT set Process Descriptor Block ptr
 inca allocate table
 std D.SysPrc set system process ptr
 std D.Proc set current process
 adda #P$Size/256 allocate system process descriptor
 tfr D,s set stack
 inca allocate system stack
 std D.SysStk set top of system stack
 std D.SysMem set system memory map ptr
 inca allocate memory map
 std D.ModDir set module directory ptr
 std D.ModEnd set end of directory ptr
 adda #6 allocate directory and module DAT Image are
 std D.ModDir+2 set end ptr
 std D.ModDAT set end ptr for Module DAT area
 leax IntXfr,pcr get interrupt transfer
 tfr X,D copy it
 ldx #D.SWI3 get entry vectors ptr
Cold14 std ,X++ set vector
 cmpx #D.NMI end of vectors?
 bls Cold14 branch if not
 leax ROMEnd,PCR get entry offset
 pshs X save it
 leay HdlrVec,PCR get interrupt handlers
 ldx #D.Clock get psuedo-vector ptr
Cold15 ldd ,Y++ get vector
 addd 0,S add offset
 std ,X++ init dp vector
 cmpx #D.XNMI end of dp vectors?
 bls Cold15 branch if not
 leas 2,S return scratch
 ldx D.XSWI2
 stx D.UsrSvc
 ldx D.XIRQ
 stx D.UsrIRQ
 leax SYSREQ,PCR Get system service routine
 stx D.SysSVC
 stx D.XSWI2 Set service to system state
 leax SYSIRQ,PCR Get system interrupt routine
 stx D.SysIRQ
 stx D.XIRQ
 leax GoPoll,pcr
 stx D.SvcIRQ Set interrupts to system state
 leax IOPOLL,PCR Set irq polling routine
 stx D.POLL set it
 leay SvcTbl,PCR get service routine initial
 lbsr SetSvc install service routines
 ldu D.PrcDBT get process descriptor block ptr
 ldx D.SysPrc get system process ptr
 stx 0,u set process zero page
 stx 1,u set process one page
 lda #1 set process ID
 sta P$ID,x
 lda #SysState
 sta P$State,x
 lda #SysTask
 sta D.SysTsk
 sta P$Task,x
 lda #$FF
 sta P$Prior,x
 sta P$Age,x
 leax P$DATImg,x
 stx D.SysDAT
*
* Set up memory blocks in system DAT image
*
 clra
 clrb
 std ,X++ use block zero for system
 ifge RAMCount-2
 incb block one
 std ,x++
 endc
 ldy #Dat.BlCt-ROMCount-RAMCount-1
 ldd #DAT.Free  Initialize the rest of the blocks to be free
Cold16 std ,X++
 leay -1,Y
 bne Cold16
 ifle DAT.BlMx-255

 ldd #IOBlock get I/O block number
 std ,X++
 ldb #ROMBlock get ROM block number
 std ,X++

 else
 jmp NOWHERE Code is not available
 endc
 ldx D.Tasks get task number table
 inc 0,X claim system task
 ldx D.SysMem get system memory map ptr
 ldb D.ModDir+2 get number of pages used
Cold17 inc ,X+ claim page
 decb count it
 bne Cold17 branch if more
*
*      build Memory Block Map
*
 ldy #DAT.BlSz*RAMCount get unused block ptr
 ldx D.BlkMap
Cold20  equ *
 pshs X
 ldd 0,S
 subd D.BlkMap get block number
 ifle DAT.BlMx-255
 ifeq MappedIO-true
 cmpb #IOBlock is this I/O block?
 else
 cmpb #DAT.BlMx Last block?
 endc
 beq Cold30 branch of so
 stb DAT.Regs+RAMCount set block register
 else
 jmp NOWHERE Code is not available
 endc
 ldu 0,y get current contents
 ldx #$00FF get first test pattern
 stx 0,Y store it
 cmpx 0,Y Is it there?
 bne Cold30 If not, end of ram
 ldx #$FF00 Try a different pattern
 stx 0,Y Store it
 cmpx 0,Y Did it take?
 bne Cold30 If not, eor
 stu 0,y Replace current value
 bra Cold40
Cold30 ldb #NotRAM get not-RAM flag
 stb [0,s] mark block not-RAM
Cold40 puls x retrieve block map ptr
 leax 1,X next Block Map entry
 cmpx D.BlkMap+2 end of map?
 bcs Cold20 branch if not
*
*      search Not-Ram, excluding I/O, for modules
*
 ldx D.BlkMap
 inc 0,X
 ifge RAMCount-2
 inc 1,x
 endc
 ifeq CPUType-FM11L2
         lda   #NotRAM
         sta   1,x
 endc
 ifeq ROMCheck-Limited
 ldx D.BlkMap+2
 leax >-DAT.BlCt,x check uppermost 64K only
 endc
Cold50 lda 0,x is this RAM block?
 beq Cold80 branch if so
 tfr X,D copy block map ptr
 subd D.BlkMap get Block Number
 leas -(DAT.BlCt*2),s reserve temp DAT area on stack
 leay 0,S move DATTmp ptr to Y
 lbsr MovDAT
 pshs x save Block Map ptr
 ldx #0 make block offset
Cold55 equ *
 ifeq ROMCheck-UnLimitd
         cmpb  #DAT.BlMx
         bne   Cold57
         ldx   #$0800
Cold57 pshs Y,X save ptrs
 lbsr AdjImg adjust DAT image ptr
 ldb 1,Y get DAT image
 stb DAT.Regs set block zero register
 ldd ,x
 clr DAT.Regs
 puls y,x retrieve ptrs
 cmpd #$87CD
 beq Cold62
 puls x
 bra Cold79
 endc
Cold60 pshs Y,X save ptrs
 lbsr AdjImg adjust DAT image ptr
 ifle DAT.BLMx-255
 ldb 1,Y get DAT image
 stb DAT.Regs set block zero register
 lda 0,X get next byte
 clr DAT.Regs clear block zero register
 else
 jmp NOWHERE Code is not available
 endc
 puls y,x retrieve ptrs
 cmpa #$87 could be module?
 bne Cold70 branch if not
Cold62 lbsr ValMod validate module
 bcc Cold65 branch if successful
 cmpb #E$KwnMod known module?
 bne Cold70 branch if not
Cold65 ldd #M$Size get module size offset
 lbsr LDDDXY
 leax D,X Skip module
 bra Cold75
Cold70 leax 1,X Try next location
Cold75 tfr X,D
 tstb
 bne Cold60
 bita #^DAT.Addr end of block?
 bne Cold60 branch if not
 lsra make block count
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 deca adjust number
 puls X
 leax A,X
Cold79 leas DAT.BlCt*2,s throw away temp DAT area
Cold80 leax 1,x move Block Map ptr
 cmpx D.BlkMap+2
 bcs Cold50

Cold.z1 leax InitName,pcr Get initial module name ptr
 bsr LinkSys Link to configuration module
 bcc Cold.z2
 os9 F$Boot
 bcc Cold.z1
 bra ColdErr

Cold.z2 stu D.Init
Cold.z3 leax P2Name,pcr get name str str
 bsr LinkSys link to "OS9p2"
 bcc Cold.xit branch if found
 os9 F$Boot
 bcc Cold.z3
ColdErr jmp [>$FFFE]

Cold.xit jmp 0,y go to "OS9p2"

LinkSys lda #SYSTM Get system type module
 os9 F$Link
 rts


************************************************************
*
*       Subroutine MovDAT
*
*   Make temporary image of of DAT-Block Addr
*
*  Input: D = DAT image offset
*         Y = ptr to DAT temp area
*
* Output: DAT image moved to temp area
*
*   Data: D.TmpDAT
*
*  Calls: None
*
MovDAT pshs Y,X,D
 ldb #DAT.BlCt  blocks/address space
 ldx 0,S
MovDAT.B stx ,Y++
 leax 1,X
 decb
 bne MovDAT.B
 puls PC,Y,X,D

 ttl Coldstart Constants
 page
************************************************************
*
*     Service Routines Initialization Table
*
SvcTbl equ *
 fcb F$Link
 fdb Link-*-2
 fcb F$PRSNAM
 fdb PNam-*-2
 fcb F$CmpNam
 fdb UCNam-*-2
 fcb F$CmpNam+SysState
 fdb SCNam-*-2
 fcb F$CRC
 fdb CRCGen-*-2
 fcb F$SRqMem+SysState
 fdb SRqMem-*-2
 fcb F$SRtMem+SysState
 fdb SRtMem-*-2
 fcb F$AProc+SysState
 fdb AProc-*-2
 fcb F$NProc+$80
 fdb NextProc-*-2
 fcb F$VModul+$80
 fdb VModule-*-2
 fcb F$SSVC
 fdb SSVC-*-2
 fcb F$SLink+$80
 fdb SLINK-*-2
 fcb F$Boot+$80
 fdb BOOT-*-2
 fcb F$BtMem+$80
 fdb SRQMEM-*-2
 fcb F$Move+$80
 fdb MOVE-*-2
 fcb F$AllRAM
 fdb ALLRAM-*-2
 fcb F$AllImg+$80
 fdb ALLIMG-*-2
 fcb F$SetImg+$80
 fdb SETIMG-*-2
 fcb F$FreeLB+$80
 fdb FREELB-*-2
 fcb F$FreeHB+$80
 fdb FREEHB-*-2
 fcb F$AllTsk+$80
 fdb ALLTSK-*-2
 fcb F$DelTsk+$80
 fdb DELTSK-*-2
 fcb F$SetTsk+$80
 fdb SETTSK-*-2
 fcb F$ResTsk+$80
 fdb RESTSK-*-2
 fcb F$RelTsk+$80
 fdb RELTSK-*-2
 fcb F$DATLog+$80
 fdb DATLOG-*-2
 fcb F$LDAXY+$80
 fdb F.LDAXY-*-2
 fcb F$LDDDXY+$80
 fdb F.LDDDXY-*-2
 fcb F$LDABX+$80
 fdb F.LDABX-*-2
 fcb F$STABX+$80
 fdb F.STABX-*-2
 fcb F$ELink+$80
 fdb ELINK-*-2
 fcb F$FModul+$80
 fdb FMod-*-2
 fcb $80



************************************************************
*
*     Module Names
*
InitName fcs "Init"
P2Name fcs "OS9p2"
BootName fcs "Boot"



 ttl System Service Request Routines
 pag
************************************************************
*
*     Interrupt Transfer
*
IntXfr jmp [-16,x] transfer to interrupt routine

*****
*
*  Swi3 Handler
*
UserSWI3 ldx D.Proc
 ldu P$SWI3,X
 beq UserSvc No user-supplied interrupt handler
UsrSWI10    lbra  PassSWI+$1000

UserSWI2 ldx D.Proc get current process ptr
 ldu P$SWI2,X get user interrupt routine
 beq UserSvc branch if none
 bra UsrSWI10
UserSWI ldx D.Proc get current process ptr
 ldu P$SWI,X get SWI routine
 bne UsrSWI10 branch if set
*
*     fall through to UserSvc
*
 page
************************************************************
*
*     User Service Request Routine
*
*   Process User service requests
*
* Input: X = Process descriptor ptr
*        S = value of stack after interrupt
*
* Output: none
*
* Data: D.SysSvc, D.SWI2, D.SysIRQ, D.IRQ, D.Proc, D.UsrDis
*
* Calls: GetRegs, PutRegs, LDBBX, Dispatch, UserRet
*
UserSvc ldd D.SysSvc get system SWI2 service routine
 std D.XSWI2 set SWI2 entry
 ldd D.SysIRQ get system IRQ service routine
 std D.XIRQ set IRQ entry
 lda P$State,X get state flag
 ora #SysState set system state
 sta P$State,X update state
 sts P$SP,X save stack ptr
 leas (P$Stack-R$Size),X move to local stack
 andcc #^IntMasks clear interrupt masks
 leau 0,s get system stack ptr
 bsr GetRegs
 ldb P$Task,X
 ldx R$PC,U
         lbsr  LDBBX+$1000
 leax 1,X Increment X
 stx R$PC,U
 ldy D.UsrDis
 lbsr DISPCH Go do request
 ldb R$CC,U get condition code
 andb #^IntMasks
 stb R$CC,U update condition codes
 ldx D.Proc
 bsr PutRegs
 lda P$State,X Clear system state
 anda #^SysState
 lbra UsrRet.a

* Copy 12 bytes from user task to SysTask
GetRegs lda P$Task,X
 ldb D.SysTsk
 pshs U,Y,X,DP,D,CC
 ldx P$SP,X
 bra CPY10

* Copy 12 bytes from SysTask to U in Task B
PutRegs ldb P$Task,X
 lda D.SysTsk
 pshs U,Y,X,DP,D,CC
 ldx P$SP,X
 exg X,U
CPY10 ldy #R$Size/2
 tfr B,DP
 orcc #IntMasks
         lbra  MoveRegs+$1000

*****
*
*  Subroutine SYSREQ
*
* Service Routine Dispatch
*
* Process software interupts from system state
* Entry: U=Register stack pointer
SYSREQ leau 0,S Copy stack ptr
 lda R$CC,U
 tfr a,cc
*
* Get Service Request Code
*
 ldx R$PC,U Get program counter
 ldb ,X+ Get service code
 stx R$PC,U Update program counter
 ldy D.SysDis Get system service routine table
 bsr DISPCH Call service routine
 lbra SYSRET

DISPCH aslb SHIFT For two byte table entries
 bcc DISP10 Branch if not i/o
 rorb RE-ADJUST Byte
 ldx IOEntry,y Get i/o routine
 bra DISP20
DISP10 clra
 ldx D,Y Get routine address
 bne DISP20 Branch is not null
 comb SET Carry
 ldb #E$UnkSvc Unknown service code
 bra DISP25
DISP20 pshs u Save register ptr
 jsr 0,X Call routine
 puls u Retrieve register ptr
*
* Return Condition Codes To Caller
*
DISP25 tfr cc,a Copy condition codes
 bcc DISP30
 stb R$B,u
DISP30 ldb R$CC,U Get condition codes
 andb #$D0 Clear h, n, z, v, c
 stb R$CC,U Save it
 anda #$2F Clear e, f, i
 ora R$CC,U Return conditions
 sta R$CC,U
 rts

 page
*****
*
*  Subroutine Ssvc
*
* Set Entries In Service Routine Dispatch Tables
*
SSVC ldy R$Y,U Get table address
 bra SetSvc

SETS10 clra
 lslb
 tfr D,U copy routine offset
 ldd ,Y++ Get table relative offset
 leax D,Y Get routine address
 ldd D.SysDis
 stx D,U Put in system routine table
 bcs SetSvc Branch if system only
 ldd D.UsrDis
 stx D,U Put in user routine table
SetSvc ldb ,Y+ Get next routine offset
 cmpb #$80 End of table code?
 bne SETS10 Branch if not
 rts
 page

*****
* System link
* Input: A = Module type
*        X = Module string pointer
*        Y = Name string DAT image pointer
SLINK ldy R$Y,U
 bra SysLink

*****
* Link using module directory entry
*
* Input: B = Module type
*        X = Pointer to module directory entry
ELINK pshs U
 ldb R$B,U
 ldx R$X,u Get name ptr
 bra EntLink

*****
*
*  Subroutine Link
*
* Search Module Directory & Return Module Address
*
* Input: U = Register Package
* Output: Cc = Carry Set If Not Found
* Local: None
* Global: D.ModDir
*
LINK ldx D.Proc
 leay P$DATImg,X
SysLink pshs U Save register package
 ldx R$X,U Get name ptr
 lda R$A,u Get module type
 lbsr FModule
 lbcs LinkErr
 leay 0,U Make copy
 ldu 0,S Get register ptr
 stx R$X,U
 std R$D,U
 leax 0,Y
EntLink bitb #REENT is this sharable
 bne Link10 branch if so
 ldd MD$Link,x  Check for links
 beq Link10 .. none
 ldb #E$ModBsy err: module busy
 bra LinkErr
Link10 ldd MD$MPtr,X  Module ptr
 pshs X,D
 ldy MD$MPDAT,X   Module DAT Image ptr
 ldd MD$MBSiz,X  Memory Block size
 addd #DAT.BlSz-1 Round up
 tfr A,B Calculate number of blocks needed from size
 lsrb
 lsrb
 ifge DAT.BlSz-2048
 lsrb
 ifge DAT.BlSz-4096
 lsrb
 endc
 endc
         adda  #$04
 lsra
 lsra
 lsra
 lsra
 pshs A save adjusted count
 leau 0,Y copy group DAT image ptr
 bsr SrchPDAT Is it already linked in process space?
 bcc Link30 branch if yes
 lda 0,S
 lbsr FreeHB10
 bcc Link20
 leas 5,S Restore stack
 ldb #E$MemFul
 bra LinkErr
Link20 lbsr SetImage
Link30 leax P$Links,X Point to memory block link counts
 sta 0,S Save block # on stack
 lsla
 leau A,X
 ldx 0,U Get link count for that block
 leax 1,X Increment
 beq Link40
 stx 0,U Store new link count
Link40 ldu 3,S
 ldx MD$Link,U
 leax 1,X
 beq Link50
 stx MD$Link,U
Link50 puls U,Y,X,B
 lbsr DATtoLog
 stx 8,U
 ldx MD$MPtr,Y
 ldy MD$MPDAT,Y
 ldd #M$EXEC Get execution offset
 lbsr LDDDXY
 addd R$U,U add it to start of module
 std R$Y,u Return it to user
 clrb
 rts

LinkErr orcc #CARRY
 puls PC,U
 page
***********************************************************
*
*     Subroutine SrchPDAT
*
*
* Input: B = Number of blocks
*        U = Module DAT Image ptr
*
SrchPDAT ldx D.Proc get pointer to current process
 leay P$DATImg,X
*
*     fall through to SrchDAT
*
***********************************************************
*
*     Subroutine SrchDAT
*
*   Search DAT image for specified blocks
*
* Input: B = block count
*        Y = search DAT image ptr
*        U = target DAT image ptr
*
* Output: A = beginning block number, if found
*
* Data: none
*
* Calls: none
*
SrchDAT clra
 pshs Y,X,D
 subb #DAT.BlCt
 negb
 lslb
 leay B,Y
SrchD10 ldx 0,S Get pointer to DAT image
 pshs U,Y
SrchD20 ldd ,Y++
 cmpd ,u++
 bne SrchD30
 leax -1,X
 bne SrchD20
 puls U,D
 subd 4,S
 lsrb
 stb 0,S
 clrb
 puls PC,Y,X,D
SrchD30 puls U,Y
 leay -2,Y
 cmpy 4,S
 bcc SrchD10
 puls PC,Y,X,D

*****
*
*  Subroutine Valmod
*
* Validate Module
*
VModule pshs U save registers ptr
 ldx R$X,u get module offset
 ldy R$D,u get DAT image ptr
 bsr ValMod validate module
 ldx 0,s get registers ptr
 stu R$U,x return entry ptr
VModXit puls PC,u



***********************************************************
*
*     Subroutine ValMod
*
*   Validate Module and update Module Directory
*
* Input: X = Module Block offset
*        Y = Module DAT Image ptr
*
* Output: D destroyed
*         U = Directory Entry
*         Carry clear if successful; set if not
*
* Data: none
*
* Calls: ModCheck, LDDDXY, AdjImg, FModule, DATtoLog
*
ValMod pshs Y,X save new module ptr
 lbsr ModCheck Check sync & chksum
 bcs   ValMoErr
 ldd   #M$Type
 lbsr  LDDDXY
 andb  #Revsmask
 pshs  b,a
 ldd   #M$Name
 lbsr  LDDDXY
 leax  d,x
 puls  a
 lbsr  FModule
 puls  a
 bcs VMOD20
 pshs a
 andb #Revsmask
 subb ,s+
 bcs VMOD20
 ldb #E$KwnMod
 bra ValMoErr
ValMoErA ldb #E$DirFul Err: directory full
ValMoErr orcc #CARRY SET Carry
 puls pc,y,x

VMOD20 ldx 0,S
 lbsr SetMoImg
 bcs ValMoErA
 sty MD$MPDAT,U
 stx MD$MPtr,U
 clra
 clrb
 std MD$Link,U
 ldd #M$Size
 lbsr LDDDXY
 pshs X
 addd ,s++
 std MD$MBSiz,U
 ldy [MD$MPDAT,u]
 ldx D.ModDir
 pshs U
 bra VMOD32
VMOD30 leax MD$ESize,X Move to next entry
VMOD32 cmpx D.ModEnd
 bcc VMOD35
 cmpx 0,S
 beq VMOD30
 cmpy [MD$MPDAT,X] DAT match?
 bne VMOD30
 bsr FreDATI
VMOD35 puls U
 ldx D.BlkMap
 ldd MD$MBSiz,U
 addd #DAT.BlSz-1 Round up to nearest block
 lsra
 lsra
 lsra
 lsra
 ldy MD$MPDAT,U
ValMod60 pshs X,A
 ldd ,Y++
 leax D,X
 ldb 0,X Get block marker
 orb #ModBlock set module in block
 stb 0,X Set block marker 
 puls X,A
 deca
 bne ValMod60
 clrb
 puls PC,Y,X

FreDATI pshs U,Y,X,D
 ldx 0,X
 pshs X
 clra
 clrb
Fre.Lp ldy 0,X
 beq VMOD57
 std ,X++
 bra Fre.Lp
VMOD57 puls x
 ldy 2,S
 ldu MD$MPDAT,U
 puls D
VMOD60 cmpx MD$MPDAT,Y
 bne Fre.NoCh
 stu MD$MPDAT,Y
 cmpd MD$MBSiz,y New block smaller than old?
 bcc VMOD65
 ldd MD$MBSiz,Y
VMOD65 std MD$MBSiz,y  set new size
Fre.NoCh leay MD$ESize,Y
 cmpy D.ModEnd
 bne VMOD60
 puls PC,U,Y,X

SetMoImg pshs U,Y,X
 ldd #M$Size
 lbsr LDDDXY
 addd 0,S
 addd #DAT.BlSz-1 Round up
 lsra
 lsra
 lsra
 lsra
 tfr A,B
 pshs B
 incb
 lslb
 negb
 sex
 bsr chkspce
 bcc SetI.out
 os9 F$GCMDir get rid of empty slots in module directory
 ldu #$0000
 stu 5,S
 bsr chkspce
SetI.out puls PC,U,Y,X,B

chkspce ldx D.ModDAT
 leax D,X
 cmpx D.ModEnd
 bcs Chks.err
 ldu 7,S
 bne chksp1
 pshs X
 ldy D.ModEnd
 leay MD$ESize,Y
 cmpy ,s++
 bhi Chks.err
 sty D.ModEnd
 leay -MD$ESize,Y
 sty 7,S
chksp1 stx D.ModDAT
 ldy 5,S
 ldb 2,S
 stx 5,S
Chks.D ldu ,Y++ copy images to new mod dat entry
 stu ,X++
 decb
 bne Chks.D
 clr 0,X
 clr 1,X
 rts

Chks.err orcc #CARRY
 rts
 page
***********************************************************
*
*     Subroutine ModCheck
*
*   Check Module ID, Header Parity, & CRC
*
* Input: X = Module block offset
*        Y = Module DAT Image ptr
*
* Output: D = 0, if good module
*         Carry clear if good module; set if not
*
* Data: none
*
* Calls: LDDDXY, AdjImg, LDAXYP, CRCCal
*
ModCheck pshs Y,X
 clra
 clrb
 lbsr LDDDXY Get first two bytes
 cmpd #M$ID12 Check them
 beq ModChk10
 ldb #E$BMID Err: illegal id block
 bra ModChErr exit
ModChk10 leas -1,s get scratch
 leax 2,X skip ID bytes
 lbsr AdjImg adjust DAT image ptr
 ldb #M$Parity-1 get byte count
 lda #($87!$CD)-($87&$CD) init parity
ModChk20 sta 0,S
 lbsr LDAXYP
 eora 0,S Add parity of next byte
 decb Done?
 bne ModChk20 Branch if not
 leas 1,s Reset stack
 inca Add 1 to expected $FF
 beq ModChk30 Parity good?
 ldb #E$BMHP
 bra ModChErr
ModChk30 puls Y,X
 ldd #M$Size Get module size
 lbsr LDDDXY
 pshs Y,X,D
 ldd #$FFFF
 pshs D Init crc register
 pshs B Init crc register
 lbsr AdjImg
 leau 0,S Get crc register ptr
CRCC05 tstb
 bne CRCC10
 pshs x
 ldx #1
 os9 F$Sleep
 puls x
CRCC10 lbsr LDAXYP Get next byte
 bsr CRCCAL Calculate crc
 ldd 3,S
 subd #1 count byte
 std 3,S
 bne CRCC05
 puls y,x,b
 cmpb #CRCCon1 Is it good?
 bne CRCC15 Branch if not
 cmpx #CRCCon23 Is it good?
 beq CRCC30 Branch if so
CRCC15 ldb #E$BMCRC Err: bad crc
ModChErr orcc #CARRY SET Carry
CRCC30 puls X,Y,PC


*****
*
*  Subroutine Crccal
*
* Calculate Next Crc Value
*
CRCCAL eora 0,U Add crc msb
 pshs A save it
 ldd 1,U Get crc mid & low
 std 0,U Shift to high & mid
 clra
 ldb 0,S Get old msb
 lslb SHIFT D
 rola
 eora 1,U Add old lsb
 std 1,U Set crc mid & low
 clrb
 lda 0,S Get old msb
 lsra SHIFT D
 rorb
 lsra SHIFT D
 rorb
 eora 1,U Add new mid
 eorb 2,U Add new low
 std 1,U Set crc mid & low
 lda 0,S Get old msb
 lsla
 eora 0,S Add old msb
 sta 0,S
 lsla
 lsla
 eora 0,S Add altered msb
 sta 0,S
 lsla
 lsla
 lsla
 lsla
 eora ,S+ Add altered msb
 bpl CRCC99
 ldd #$8021
 eora 0,U
 sta 0,U
 eorb 2,U
 stb 2,U
CRCC99 rts



*****
*
*  Subroutine Crcgen
*
* Generate Crc
*
CRCGen ldd R$Y,u get byte count
 beq CRCGen20 branch if none
 ldx R$X,u get data ptr
 pshs X,D
 leas -3,S
 ldx D.Proc
 lda P$Task,X
 ldb D.SysTsk
 ldx R$U,u get crc ptr
 ldy #3
 leau 0,S
 pshs Y,X,D
 lbsr Mover
 ldx D.Proc
 leay P$DATImg,X
 ldx 11,S
 lbsr AdjImg
CRCGen10 lbsr LDAXYP get next data byte
 lbsr CRCCAL update crc
 ldd 9,S
 subd #1 count byte
 std 9,S
 bne CRCGen10 branch if more
 puls Y,X,D
 exg A,B
 exg X,U
 lbsr Mover
 leas 7,S
CRCGen20 clrb clear carry
 rts
 page
***********************************************************
*
*     Subroutine FMod
*
*   Find Module Directory Entry Service routine
*
* Input: U = registers ptr
*            R$A,u = Module Type
*            R$X,u = Name string offset
*            R$Y,u = DAT Image ptr
*
* Output: Y = registers ptr
*             R$A,u = Module Type
*             R$B,u = Module Revision
*             R$X,u = Updated Name string offset
*             R$U,u = Directory Entry ptr
*         Carry clear if successful; set otherwise
*
* Data: none
*
* Calls: FModule
*
FMod pshs u
 lda R$A,u
 ldx R$X,u
 ldy R$Y,u
 bsr FModule
 puls y
 std R$D,y
 stx R$X,y
 stu R$U,y
 rts

FModule ldu #0 Return zero if not found
 pshs u,D
 bsr SkipSpc Skip leading spaces
 cmpa #'/ Is there leading '/'
 beq FMOD35
 lbsr F.PRSNAM Parse name
 bcs FMOD40 Branch if bad name
 ldu D.ModDir Get module directory ptr
 bra FMOD33 Test if end is reached
FMOD10 pshs Y,X,D
 pshs Y,X
 ldy 0,u Get module ptr
 beq FModul40 Branch if not used
 ldx M$NAME,U Get name offset
 pshs Y,X
 ldd #M$NAME Get name offset
 lbsr LDDDXY
 leax D,X Get name ptr
 pshs Y,X
 leax 8,S
 ldb 13,S
 leay 0,S
 lbsr ChkNam Compare names
 leas 4,S
 puls Y,X
 leas 4,S
 bcs FMOD30
 ldd #M$Type Get desired language
 lbsr LDDDXY
 sta 0,S
 stb 7,S
 lda 6,S Get desired type
 beq FMOD16 Branch if any
 anda #TypeMask
 beq FMOD14 Branch if any
 eora 0,S Get type difference
 anda #TypeMask
 bne FMOD30 Branch if different
FMOD14 lda 6,S Get desired language
 anda #LangMask
 beq FMOD16 Branch if any
 eora ,S
 anda #LangMask
 bne FMOD30 Branch if different
FMOD16 puls Y,X,D Retrieve registers
 abx
 clrb
 ldb 1,S
 leas 4,S
 rts

FModul40 leas 4,S
 ldd 8,s Free entry found?
 bne FMOD30 Branch if so
 stu 8,S
FMOD30 puls Y,X,D Retrieve registers
 leau MD$ESize,U Move to next entry
FMOD33 cmpu D.ModEnd End of directory?
 bcs FMOD10 Branch if not
 comb
 ldb #E$MNF
 bra FMOD40
FMOD35 comb SET Carry
 ldb #E$BNam
FMOD40 stb 1,S Save B on stack
 puls D,U,PC

* Skip spaces
SkipSpc pshs y
SkipSp10 lbsr AdjImg
 lbsr LDAXY Get byte from other DAT
 leax 1,x move forward
 cmpa #'  compare with space
 beq SkipSp10
 leax -1,x Get not space
 pshs a
 tfr Y,D
 subd 1,S
 asrb
 lbsr DATtoLog
 puls PC,y,a

 page
***************
* Parse Path Name
*
* Passed:  (X)=Pathname Ptr
* Returns: (X)=Skipped Past Prefix '/'
*          (Y)=Ptr To 1St Delim In Pathname
*          (A)=Delimiter Character
*          (B)=Number Of Characters Found <=255
*           Cc=Set If No Characters Found
* Unaffects: U
*
PNAM ldx D.Proc
 leay P$DATImg,x
 ldx R$X,u Get string ptr
 bsr F.PRSNAM Call parse name
 std R$D,U Return byte & size
 bcs PNam.x branch if error
 stx R$X,U Return updated string ptr
 abx
PNam.x stx R$Y,U Return name end ptr
 rts

F.PRSNAM pshs y
 lbsr AdjImg
 pshs Y,X
 lbsr LDAXYP Get first char
 cmpa #'/ Slash?
 bne PRSNA1 ..no
 leas 4,S
 pshs Y,X
 lbsr LDAXYP
PRSNA1 bsr ALPHA 1st character must be alphabetic
 bcs PRSNA4 Branch if bad name
 clrb
PRSNA2 incb INCREMENT Character count
 tsta End of name (high bit set)?
 bmi PRSNA3 ..yes; quit
 lbsr LDAXYP
 bsr ALFNUM Alphanumeric?
 bcc PRSNA2 ..yes; count it
PRSNA3 andcc #^CARRY clear carry
 bra PRSNA10
PRSNA4 cmpa #', Comma (skip if so)?
 bne PRSNA6 ..no
PRSNA5 leas 4,S
 pshs Y,X
 lbsr LDAXYP
PRSNA6 cmpa #$20 Space?
 beq PRSNA5 ..yes; skip
 comb (NAME Not found)
 ldb #E$BNam
PRSNA10 puls Y,X
 pshs d,cc
 tfr Y,D
 subd 3,S
 asrb
 lbsr DATtoLog
 puls PC,Y,D,CC

* Check For Alphanumeric Character
*
* Passed:  (A)=Char
* Returns:  Cc=Set If Not Alphanumeric
* Destroys None
*
ALFNUM pshs a
 anda #$7F
 cmpa #'. period?
 beq RETCC branch if so
 cmpa #'0 Below zero?
 blo RETCS ..yes; return carry set
 cmpa #'9 Numeric?
 bls RETCC ..yes
 cmpa #'_ Underscore?
 bne ALPHA10
RETCC clra
 puls PC,a

ALPHA pshs a
 anda #$7F Strip high order bit
ALPHA10 cmpa #'A
 blo RETCS
 cmpa #'Z Upper case alphabetic?
 bls RETCC ..yes
 cmpa #$61 Below lower case a?
 blo RETCS ..yes
 cmpa #$7A Lower case?
 bls RETCC ..yes
RETCS coma Set carry
 puls PC,a

* Compare Pathname With Module Name
*
* Passed:  (X)=Pathname
*          (Y)=Module Name (High Bit Set Delim)
*          (B)=Length Of Pathname
* Returns:  Cc=Set If Names Not Equal
*
UCNam ldx D.Proc
 leay P$DATImg,X
 ldx R$X,U
 pshs Y,X
 bra SCNam10

SCNam ldx D.Proc
 leay P$DATImg,X
 ldx R$X,U
 pshs Y,X
 ldy D.SysDAT
SCNam10 ldx R$Y,u Get module name
 pshs Y,X
 ldd R$D,U
 leax 4,S
 leay 0,S
 bsr ChkNam
 leas 8,S
 rts
 page
***********************************************************
*
*     Subroutine ChkNam
*
*   Compare two OS-9 type names
*
* Input: D = Target name length
*        X = Target DAT-Block address ptr
*            [ x :x+1] = Target name block offset
*            [x+2:x+2] = Target DAT Image ptr
*        Y = Module DAT-Block address ptr
*            [ y :y+1] = Module name block offset
*            [y+2:y+3] = Module DAT Image ptr
*
* Output: Carry clear if names are the same
*               set if names differ
*
* Data: none
*
* Calls: LDAXYP
*
ChkNam pshs U,Y,X,D Save registers
 ldu 2,S
 pulu Y,X
 lbsr AdjImg
 pshu Y,X
 ldu 4,S
 pulu Y,X
 lbsr AdjImg
 bra CHKN15

CHKN10 ldu 4,S
 pulu Y,X
CHKN15 lbsr LDAXYP
 pshu Y,X
 pshs a
 ldu 3,S
 pulu Y,X
 lbsr LDAXYP
 pshu Y,X
 eora 0,S
 tst ,s+
 bmi CHKN20 Branch if last module char
 decb DECREMENT Char count
 beq RETCS1 Branch if last character
 anda #$FF-$20 Match upper/lower case
 beq CHKN10 ..yes; repeat
RETCS1 comb Set carry
 puls PC,U,Y,X,D

CHKN20 decb
 bne RETCS1 LAST Char of pathname?
 anda #$FF-$A0 Match upper/lower & high order bit
 bne RETCS1 ..no; return carry set
 clrb
 puls PC,u,Y,X,D


***********************************************************
*
*     Subroutine SRqMem
*
*   Allocate memory for system
*
* Input: U = registers ptr
*
* Output: Carry clear if successful; set if not
*
* Data: D.SysPrc. D.TmpDAT
*
* Calls: none
*
SRqMem ldd R$D,u get byte count
 addd #$FF Round up to page
 clrb
 std R$D,U Return size to user
 ldy D.SysMem
 leas -2,S
 stb 0,S
SRQM10 ldx D.SysDAT
 lslb
 ldd B,X
 cmpd #DAT.Free
 beq SRQM15
 ldx D.BlkMap
 lda D,X
 cmpa #$01   #RAMinUse
 bne SRQM20
 leay DAT.BlCt,Y
 bra SRQM30
SRQM15 clra
SRQM20 ldb #DAT.BlCt
SRQM25 sta ,y+
 decb
 bne SRQM25
SRQM30 inc 0,S
 ldb 0,S
 cmpb #DAT.BlCt
 bcs SRQM10
SRQM40 ldb 1,U
SRQM45 cmpy D.SysMem
 bhi SRQM50
 comb
 ldb #E$MemFul Get error code
 bra SRQMXX
SRQM50 lda ,-y
 bne SRQM40
 decb
 bne SRQM45
 sty 0,S
 lda 1,S
 lsra
 lsra
 lsra
 lsra
 ifge DAT.BlSz-$2000
 lsra Divide by 32 for 8K blocks
 endc
 ldb 1,S
 andb #^DAT.Addr get page within block
 addb R$D,u add number of pages
 addb #^DAT.Addr round up to next block
 lsrb get block count
 lsrb
 lsrb
 lsrb
 ifge DAT.BlSz-$2000
 lsrb Divide by 32 for 8K blocks
 endc
 ldx D.SysPrc
 lbsr F.ALLIMG
 bcs SRQMXX
 ldb R$A,U Get page count
SRQM60 inc ,Y+
 decb
 bne SRQM60
 lda 1,S
 std R$U,U Return ptr to memory
 clrb
SRQMXX leas 2,S
 rts
 page
***********************************************************
*
*     Subroutine SRtMem
*
*   Deallocate system memory
*
* Input: U = registers ptr
*
* Output: Carry clear if successful; set otherwise
*
* Data: D.SysMem
*
* Calls: ClrBit
*
SRtMem ldd R$D,U Get byte count
 beq SrTM.F  Branch if returning nothing
 addd #$FF Round up to page
 ldb R$U+1,u Is address on page boundary?
 beq SRTM10 yes
 comb
 ldb #E$BPAddr
 rts

SRTM10 ldb R$U,U
 beq SrTM.F Branch if returning nothing
 ldx D.SysMem
 abx
SRTM20 ldb 0,X
 andb #^RAMinUse
 stb ,x+
 deca
 bne SRTM20
 ldx D.SysDAT
 ldy #DAT.BlCt
SRTM30 ldd 0,X
 cmpd #DAT.Free
 beq SRtM.E
 ldu D.BlkMap
 lda d,U
 cmpa #RAMinUse
 bne SRtM.E
 tfr X,D
 subd D.SysDAT
 lslb
 lslb
 lslb
 ldu D.SysMem
 leau d,U
 ldb #DAT.TkCt
SRTM40 lda ,U+
 bne SRtM.E
 decb
 bne SRTM40
 ldd 0,X
 ldu D.BlkMap
 clr D,U
 ldd #DAT.Free
 std 0,X
SRtM.E leax 2,X
 leay -1,Y
 bne SRTM30
SrTM.F clrb
 rts
 page
***********************************************************
*
*     Subroutine Boot
*
*   Links to module name "Boot" or as specified in "Init" module,
*   calls linked module expects return of ptr & size of area which
*   is searched for new modules
*
* Input: none
*
* Output: Carry clear if successful; set otherwise
*
* Data: D.Boot, D.Init
*
* Calls: module linked
*
Boot comb set carry
 lda D.Boot has Bootstrap been tried?
 bne BootXX branch if so
 inc D.Boot set flag
 ldx D.Init get init address
 beq Boot10 branch if none
 ldd BootStr,X get bootstrap name ptr
 beq Boot10 branch if none
 leax D,X get name ptr
 bra Boot20
Boot10 leax BootName,pcr get default name ptr
Boot20 lda #SYSTM+OBJCT get type
 OS9 F$LINK find bootstrap module
 bcs BootXX can't Boot without module
 jsr 0,Y call Boot entry
 bcs BootXX Boot failed
 leau D,X get bootstrap end ptr
 tfr X,D copy bootstrap ptr
 anda #DAT.Addr get translated bits
 clrb
 pshs U,D
 lsra get DAT image offset
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 ldy D.SysDAT get system DAT image ptr
 leay A,Y get DAT image ptr
Boot30 ldd 0,X get module beginning
 cmpd #M$ID12 is it module sync code?
 bne Boot40 branch if not
 tfr X,D copy boot ptr
 subd 0,s get block offset
 tfr D,X copy offset
 tfr Y,D pass DAT img ptr
 ifne DAT.WrEn
 endc
 OS9 F$VModul validate module
 pshs B save error code (if any)
 ldd 1,s get bootstrap begin
 leax D,X get current ptr
 puls B retrieve error code
 bcc Boot35 branch if no error
 cmpb #E$KwnMod is it known module?
 bne Boot40 branch if not
Boot35 ldd M$SIZE,X get module size
 leax D,X skip module
 bra Boot50
Boot40 leax 1,X try next
Boot50 cmpx 2,s end of Boot?
 bcs Boot30 branch if not
 leas 4,s return scratch
BootXX rts
 page


 ttl Dynamic Address Translator Routines
 page
*****
*
* Allocate RAM blocks
*
ALLRAM ldb R$B,u Get number of blocks
 bsr ALRAM10
 bcs ALRAM05
 std R$D,U
ALRAM05 rts

ALRAM10 pshs Y,X,D
 ldx D.BlkMap
ALRAM20 leay 0,X
 ldb 1,S
ALRAM30 cmpx D.BlkMap+2
 bcc ALRAMERR
 lda ,x+
 bne ALRAM20 Reset B counter
 decb
 bne ALRAM30
 tfr Y,D
 subd D.BlkMap
 sta 0,S
 lda 1,S
 stb 1,S
ALRAM40 inc ,y+
 deca
 bne ALRAM40
 clrb
 puls PC,Y,X,D

ALRAMERR comb
 ldb #E$NoRam
 stb 1,S Save error code
 puls PC,Y,X,D

*****
*
* Allocate image RAM blocks
*
ALLIMG ldd R$D,u  Get beginning and number of blocks
 ldx R$X,u Process descriptor pointer
F.ALLIMG pshs u,Y,X,D
 lsla
 leay P$DATImg,X
 leay A,Y
 clra
 tfr D,X
 ldu D.BlkMap
 pshs U,Y,X,D
ALLIMG10 ldd ,Y++
 cmpd #DAT.Free
 beq ALLIMG20
 lda D,U
 cmpa #$01   #RAMinUse
 puls D
 bne ALLIMG50
 subd #1
 pshs D
ALLIMG20 leax -1,X
 bne ALLIMG10
 ldx ,s++
 beq ALLIMG60
ALLIMG30 lda ,u+
 bne ALLIMG40
 leax -1,X
 beq ALLIMG60
ALLIMG40 cmpu D.BlkMap+2
 bcs ALLIMG30

ALLIMG50 ldb #E$MemFul
 leas 6,S
 stb 1,S
 comb
 puls PC,U,Y,X,D

ALLIMG60 puls U,Y,X
ALLIMG65 ldd ,Y++
 cmpd #DAT.Free
 bne ALLIMG70

ALLIMG68    lda   ,u+
 bne ALLIMG68
 inc ,-U
 tfr U,D
 subd D.BlkMap
 std -2,Y
ALLIMG70 leax -1,X
 bne ALLIMG65

 ldx 2,S Get process ptr
 lda P$State,X
 ora #ImgChg
 sta P$State,X
 clrb
 puls PC,U,Y,X,D

*****
*
* Get free high block
*
FREEHB ldb R$B,u Get block count
 ldy R$Y,u DAT image pointer
 bsr FRHB20 Go find free blocks in high part of DAT
 bcs FRHB10
 sta R$A,u return beginning block number
FRHB10 rts

FRHB20 tfr b,a
FreeHB10 suba #$11  DAT.BlCt+1
 nega
 pshs X,D
 ldd #$FFFF
 pshs D
 bra FREEBLK

*****
* Get Free low block
*
FREELB ldb R$B,u Get block count
 ldy R$Y,u DAT image pointer
 bsr FreeLBlk
 bcs FRLB10
 sta R$A,u return beginning block number
FRLB10 rts



***********************************************************
*
*     Subroutine FreeLBlk
*
*   Search DAT image for lowest free block
*
* Input: B = block count
*        Y = DAT image ptr
*
* Output: A = beginning block number
*
* Data: none
*
* Calls: FreeBlk
*
FreeLBlk lda #-1 set low beginning
 pshs X,D save beginning, count & register
 lda #1 set next-try increment
 subb #DAT.BlCt+1 get negative limit
 negb get limit block
 pshs d save them
 bra FreeBlk
 page
***********************************************************
*
*     Subroutine FreeBlk
*
*   Search DAT image for free block
*
* Input: Y = DAT image ptr
*        0,s = next-try increment
*        1,s = search limit
*        2,s = beginning block number
*        3,s = block count
*        4,s:5,s = return address
*
* Output: A = beginning block number
*         B = block count
*
* Data: none
*
* Calls: none
*
FreeBlk clra clear found count
 ldb 2,s get beginning block number
 addb 0,s add increment
 stb 2,s save beginning
 cmpb 1,s hit limit?
 bne FreeB20 branch if not
 ldb #E$MemFul err: memory full
 stb 3,s save for return
 comb set carry
 bra FreeBXit
FreeB10 tfr A,B copy found count
 addb 2,s add beginning block number
FreeB20 aslb shift for two-byte entries
 ldx B,Y get next block image
 cmpx #DAT.Free is it free?
 bne FreeBlk branch if not
 inca count block
 cmpa 3,s found enough?
 bne FreeB10 branch if not
FreeBXit leas 2,s return parameters
 puls PC,X,D
 page
***********************************************************
*
*     Subroutine SetImage
*
*   Set Process DAT Image
*
* Input: A = Beginning image block number
*        B = block count
*        X = Process Descriptor ptr
*        U = New Image ptr
*
* Output: none
*
* Data: none
*
* Calls: none
*
SetImg ldd R$D,u get block number & count
 ldx R$X,u get process ptr
 ldu R$U,u get new image ptr

SetImage pshs U,Y,X,D save registers
 leay P$DATImg,X get DAT image ptr
 asla shift for two-byte entries
 leay A,Y get image ptr
SetImg10 ldx ,u++ get new image
 stx ,Y++ set process image
 decb done?
 bne SetImg10 branch if not
 ldx 2,s get process descriptor ptr
 lda P$State,X get process state
 ora #ImgChg make image change
 sta P$State,X update state
 clrb clear carry
 puls PC,u,Y,X,D
 page
***********************************************************
*
*     Subroutine DATLog
*
*   Convert DAT image block number and block offset to
*   logical address Service routine
*
* Input: U = registers ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: DATtoLog
*
DATLog ldb R$B,u get DAT image offset
 ldx R$X,u get block offset
 bsr DATtoLog convert it
 stx R$X,u return logical address
 clrb clear carry
 rts


***********************************************************
*
*     Subroutine DATtoLog
*
* Input: B = DAT Image offset
*        X = Block offset
*
* Output: X = Logical address
*
* Data: none
*
* Calls: none
*
DATtoLog pshs X,D save registers
 aslb shift image to block offset
 aslb
 ifge DAT.BlSz-2048
 aslb
 ifge DAT.BlSz-4096
 aslb
 endc
 endc
 addb 2,s combine nibbles
 stb 2,s
 puls PC,X,D
 page
***********************************************************
*
*     Subroutine FLDAXY
*
*   Load A X, [Y] Service routine
*
* Input: U = registers ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: LDAXY
*
F.LDAXY ldx R$X,u Block offset
 ldy R$Y,u DAT image pointer
         bsr AdjImg
 bsr LDAXY
 sta R$A,u Store result
 clrb
 rts


***********************************************************
*
*     Subroutine LDAXY
*
*   Load A register from X offset of Y block
*
* Input: X = Block offset
*        Y = DAT Image ptr
*
* Output: A = [X,Y]
*
* Data: none
*
* Calls: none
*
LDAXY equ *
 ifge DAT.BlSz-4096
 pshs cc save masks
 lda 1,Y get block number
 orcc #IntMasks set interrupt masks
 sta DAT.Regs set block zero
 lda 0,X get byte
 clr DAT.Regs reset block zero
 puls pc,cc
 else
 endc
 page
***********************************************************
*
*     Subroutine LDAXYP
*
*   Load A register from X offset of Y block; post increment
*
* Input: X = Block offset
*        Y = DAT Image ptr
*
* Output: A = [X,Y]
*         X,Y updated
*
* Data: none
*
* Calls: AdjImg
*
LDAXYP equ *
 ifge DAT.BlSz-4096
 lda 1,y get DAT block image
 pshs cc save masks
 orcc #IntMasks set interrupt masks
 sta DAT.Regs set block zero
 lda ,x+ get byte
 clr DAT.Regs reset block zero
 puls cc reset interrupt masks
 else
 jmp NOWHERE Code is not available
 endc
 bra AdjImg adjust image


***********************************************************
*
*     Subroutine AdjImg
*
AdjImg10 leax >-DAT.BlSz,X
 leay 2,Y
AdjImg cmpx #DAT.BlSz
 bcc AdjImg10
 rts
 page
***********************************************************
*
*     Subroutine FLDDDXY
*
*   Load D D+X,[Y]] Service routine
*
* Input: U = registers ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: LDDDXY
*
F.LDDDXY ldd R$D,u get offset offset
 leau R$X,u get ptrs ptr
 pulu Y,X get ptrs
 bsr LDDDXY get bytes
 std R$D-R$U,u return bytes
 clrb clear carry
 rts


***********************************************************
*
*     Subroutine LDDDXY
*
*   Load D register from X+D offset of Y block
*
* Input: D = Address offset
*        X = Block offset
*        Y = DAT Image ptr
*
* Output: D = [D+X,Y]
*
* Data: none
*
* Calls: AdjImg, LDAXYP, LDAXY
*
LDDDXY pshs Y,X save registers
 leax D,X add address offset
 ifge DAT.BlSz-4096
 bsr AdjImg adjust DAT-Block address
 bsr LDAXYP get MSB
 pshs a save data byte
 bsr LDAXY get LSB
 tfr A,B copy LSB
 puls pc,y,x,a
 else
 jmp NOWHERE Code is not available
 endc
 page
***********************************************************
*
*     Subroutine F.LDABX
*
*   Load A 0,X from address space B
*
* Input: U = registers ptrs
*
* Output: Carry clear
*
* Data: none
*
* Calls: LDABX
*
F.LDABX ldb R$B,u Task number
 ldx R$X,u Data pointer
         lbsr  LDABX+$1000
 sta R$A,U
 rts


***********************************************************
*
*     Subroutine F.STABX
*
*   Store A 0,X in address space B
*
* Input: U = registers ptrs
*
* Output: Carry clear
*
* Data: none
*
* Calls: STABX
*
F.STABX ldd R$D,U
 ldx R$X,U
         lbra  STABX+$1000
 page
***********************************************************
*
*     Subroutine Move
*
*   Move Data service routine
*
* Input: U = Registers ptr
*        R$A,u = Source Task number
*        R$B,u = Destination Task number
*        R$X,u = Source ptr
*        R$Y,u = Byte count
*        R$U,u = Destination ptr
*
* Output: carry clear
*
* Data: none
*
* Calls: Mover
*
Move ldd R$D,u get user D register
 ldx R$X,u Source pointer
 ldy R$Y,u Byte count
 ldu R$U,u Destination pointer
*
*     fall through to Mover
*
***********************************************************
*
*     Subroutine Mover
*
*   Move data from one task to another
*
* Input: A = Source Task number
*        B = Destination Task number
*        X = Source ptr
*        Y = Byte count
*        U = Destination ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: Mover00
*
Mover andcc #^Carry clear carry
 leay 0,y zero byte count?
 beq MoveNone branch if so
 pshs U,Y,X,DP,D,CC save registers
 tfr Y,D copy byte count
 lsra divide by 2
 rorb
 tfr D,Y copy double byte count
 ldd 1,s get task numbers
 tfr B,DP copy destination task number
         lbra  Mover00+$1000
MoveNone    rts

*****
* Allocate Process Task number
*
ALLTSK ldx R$X,u Get process descriptor
*
*     fall through to AllPrTsk
*
***********************************************************
*
*     Subroutine AllPrTsk
*
*   Allocate process task number
*
* Input: X = Process ptr
*
* Output: carry clear if successful; set otherwise
*
* Data: none
*
* Calls: ResvTask, SetPrTsk
*
AllPrTsk ldb P$Task,X
 bne AllPrT10
 bsr ResvTask Reserve task number
 bcs AllPrXit
 stb P$Task,X
 bsr SetPrTsk Set process task registers
AllPrT10 clrb
AllPrXit rts
 page
***********************************************************
*
*     Subroutine DelTsk
*
*   Deallocate Process Task service routine
*
* Input: U = Registers ptr
*        R$X,y = Process Descriptor ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: DelPrTsk
*
DelTsk ldx R$X,u get process ptr
*
*     fall through to DelPrTsk
*
***********************************************************
*
*     Subroutine DelPrTsk
*
*   Deallocate Process Task number
*
* Input: X = Process Descriptor ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: RelsTask
*
DelPrTsk ldb P$Task,x get process task
 beq AllPrXit branch if none
 clr P$Task,x clear process task
 bra RelsTask release task number
 page
***********************************************************
*
*     Subroutine ChkPrTsk
*
*   Update process task in DAT image has changed
*
* Input: X = Process ptr
*
* Output: A = Process state
*
* Data: none
*
* Calls: SetPrTsk
*
ChkPrTsk lda P$State,x get process state
 bita #ImgChg has DAT image changed?
 bne SetPrTsk branch if so
 rts
 page
***********************************************************
*
*     Subroutine SetTsk
*
*   Set task DAT registers service routine
*
* Input: U = Registers ptr
*        R$X,y = Process Descriptor ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: SetPrTsk
*
SetTsk ldx R$X,u get process ptr
*
*     fall through to SetPrTsk
*
***********************************************************
*
*     Subroutine SetPrTsk
*
*   Set Process Task DAT registers
*
* Input: X = Process Descriptor ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: MoveRegs
*
SetPrTsk lda P$State,X
 anda #^ImgChg
 sta P$State,X
 andcc #^CARRY clear carry
 pshs U,Y,X,D,CC
 ldb P$Task,X
 leax P$DATImg,X
 ldy #DAT.ImSz/2
 ldu #DAT.Regs
         lbra  SETDAT00+$1000 Copy DAT image to DAT registers

***********************************************************
*
*     Subroutine ResTsk
*
*   Reserve Task Number
*
* Output: B = New task number
*
* Calls: ResvTask
*
ResTsk bsr ResvTask
 stb R$B,u set task number
 rts

* Find free task and reserve it
ResvTask pshs x
 ldb #1
 ldx D.Tasks
ResTsk10 lda B,X
 beq ResTsk20
 incb
 cmpb #DAT.TkCt Last task slot?
 bne ResTsk10 ..yes
 comb
 ldb #E$NoTask err: no tasks
 bra ResTsk30
ResTsk20 inc b,x reserve task
 orb D.SysTsk set selected bits
 clra clear carry
ResTsk30 puls PC,X

***********************************************************
*
*     Subroutine RelsTask
*
*   Release Task number
*
* Input: B = Task number
*
* Output: none
*
* Data: D.Tasks
*
* Calls: none
*
RelTsk ldb R$B,u get task number

RelsTask pshs x,b save registers
 ldb D.SysTsk get selected bits
 comb make mask
 andb 0,s clear selected bits
 beq RelTsk10 branch if system task
 ldx D.Tasks get task number table
 clr B,X release task number
RelTsk10 puls PC,x,b
 page
***********************************************************
*
*     Clock Tick Subroutine
*
*   Update timed-sleep processes' time, make active if
*   time expires; update current process's time slice
*
* Input: none
*
* Output: Carry clear
*
* Data: D.SProcQ, D.Slice, D.TSlice, D.Proc
*
* Calls: ActvProc
*
Tick ldx D.SProcQ get sleep queue ptr
 beq Slice branch if queue empty
 lda P$State,X get process state
 bita #TimSleep timed-sleep state?
 beq Slice branch if not
 ldu P$SP,X get process stack ptr
 ldd R$X,u get sleep time
 subd #1 count tick
 std R$X,u update time
 bne Slice branch if not expired
Tick.A ldu P$Queue,X get next queue ptr
 bsr ActvProc make process active
 leax 0,u copy next queue ptr
 beq Tick.B branch if none
 lda P$State,X get process state
 bita #TimSleep timed-sleep state
 beq Tick.B branch if not
 ldu P$SP,X get process stack ptr
 ldd R$X,u get sleep time
 beq Tick.A branch if expired
Tick.B stx D.SProcQ update queue ptr
*
*     fall through to Slice
*
Slice dec D.Slice Count tick
 bne Slic.a Branch if slice not over
 inc D.Slice reset to last tick of slice
 ldx D.Proc get current process ptr
 beq Slic.a branch if none
 lda P$State,X get process state
 ora #TIMOUT set time-out flag
 sta P$State,X update state
Slic.a clrb clear carry
 rts
 page
***********************************************************
*
*     Subroutine AProc
*
*   Put process in Active Process Queue Service routine
*
* Input: U = Registers ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: ActvProc
*
AProc ldx R$X,u get process ptr
*
*     fall through to ActvProc
*
***********************************************************
*
*     Subroutine ActvProc
*
*   Put process in Active Process Queue
*
* Input: X = Process Descriptor ptr
*
* Output: Carry clear
*
* Data: D.AProcQ
*
* Calls: none
*
ActvProc clrb clear carry
 pshs U,Y,X,CC save registers
 lda P$Prior,X get new process priority
 sta P$AGE,X set queue age
 orcc #IRQMask+FIRQMask set interrupt masks
 ldu #D.AProcQ-P$Queue fake process ptr
 bra ActvPr30
ActvPr10 inc P$AGE,u get process queue age
 bne ActvPr20 branch if not high
 dec P$AGE,u update age
ActvPr20 cmpa P$AGE,u is new higher priority
 bhi ActvPr40 branch if so
ActvPr30 leay 0,u copy process ptr
ActvPr40 ldu P$Queue,u get next process ptr
 bne ActvPr10 branch if more
 ldd P$Queue,Y get next process ptr
 stx P$Queue,Y attach new to previous
 std P$Queue,X attach previous to new
 puls PC,u,Y,X,CC
 page
***********************************************************
*
*     User Hardware Interrupt Service Routine
*
*   Handle state/stack, call polling routine, & return
*
* Input: S = value of stack after interrupt
*
* Output: none directly
*
* Data: D.Proc, D.SysSvc, D.SWI2, D.SysIRQ, D.IRQ, D.Poll
*
* Calls: [D.Poll], UIRQRet
*
UserIRQ ldx D.Proc get process ptr
 sts P$SP,x save stack ptr
 lds D.SysStk move to system stack
 ldd D.SysSvc get system service routine
 std D.XSWI2 set SWI 2 vector
 ldd D.SysIRQ get system interrupt routine
 std D.XIRQ set IRQ vector
 jsr [D.SvcIRQ] call IRQ service
 bcc UserRet branch if serviced
 ldx D.Proc get process ptr
 ldb P$Task,X get process task number
 ldx P$SP,x get process stack
         lbsr  LDABX+$1000
 ora #IntMasks inhibit interrupts in process
         lbsr  STABX+$1000
*
*     fall through to UserRet
*
***********************************************************
*
*     Subroutine UserRet
*
*   Return to User process after interrupt
*
* Input: A = Process State flags
*        X = Process Descriptor ptr
*
* Output: none
*
* Data: none
*
* Calls: NextProc (@ CurrProc), ActvProc, NextProc
*
UserRet orcc #IntMasks
 ldx D.Proc
 ldu P$SP,X
 lda P$State,X
 bita #TimOut
 beq NXTP30
UsrRet.a anda #^TimOut
 sta P$State,X
 lbsr DelPrTsk
GoActv bsr ActvProc

*****
*
*  Routine Nxtprc
*
* Starts next Process in Active Queue
* If no Active Processes, Wait for one
*
NextProc ldx D.SysPrc
 stx D.Proc Clear current process
 lds D.SysStk
 andcc #^IntMasks
 bra NXTP06

*
* Loop until there is a Process in the Active Queue
*
NXTP04 cwai #$FF-IRQMask-FIRQMask Clear interrupt masks & wait
NXTP06 orcc #IRQMask+FIRQMask Set interrupt masks
 ldy #D.AProcQ-P$Queue Fake process ptr
 bra NXTP20
NXTP10 leay 0,x Copy process pointer
NXTP20 ldx P$Queue,Y Get first process in active queue
 beq NXTP04 Branch if none
 lda P$State,X
 bita #Suspend
 bne NXTP10
*
* Remove Process from Active Queue
*
 ldd P$Queue,X Get next process ptr
 std P$Queue,Y Remove first from active queue
 stx D.Proc Set current process
 lbsr AllPrTsk Allocate Process Task number
 bcs GoActv
 lda D.TSlice
 sta D.Slice
 ldu P$SP,X Get stack ptr
*
* Check Process Status, check for Signal pending
*
 lda P$State,X Is process in system state?
 bmi SYSRET Branch if so
NXTP30 bita #CONDEM Is process condemmed?
 bne NXTOUT Branch if so
 lbsr ChkPrTsk
 ldb P$Signal,X Is a signal waiting?
 beq NXTP50 Branch if not
 decb Wake-up Signal?
 beq NXTP40 Branch if so
*
* Signal is pending; If an Intercept has been set
* Build an Interrupt Stack for User
*
 leas -R$Size,S Make space for copy
 leau 0,S Copy stack pointer
 lbsr GetRegs Copy 12 bytes from P$SP to U
 lda P$Signal,X
 sta 2,U
 ldd P$SigVec,X Get intercept vector
 beq NXTOUT Branch if none
 std 10,U
 ldd P$SigDat,X Get intercept data address
 std 8,U
 ldd P$SP,X
 subd #R$Size Make space for copy
 std P$SP,X
 lbsr PutRegs Copy 12 bytes from U to P$SP
 leas R$Size,S Reset stack
 ldu P$SP,X
 clrb
NXTP40 stb P$Signal,X Clear signal
*
* Switch to User State
*
NXTP50 ldd D.UsrSvc
 std D.XSWI2
 ldd D.UsrIRQ Get user irq
 std D.XIRQ
         lbra  SVCRET+$1000 Start next process

NXTOUT lda P$State,x Get process status
 ora #SysState Set system state
 sta P$State,X Update status
 leas P$Stack,X
 andcc #^IntMasks Clear interrupt masks
 ldb P$Signal,X Return fatal signal
 clr P$Signal,X
 OS9 F$EXIT Terminate process
 page
***********************************************************
*
*     System Hardware Interrupt Service Routine
*
*   Call Device Polling routine & return
*
* Input: S = value of stack after interrupt
*
* Output: non directly
*
* Data: D.Poll
*
* Calls: [D.Poll]
*
SysIRQ equ *
 jsr [D.SvcIRQ] call service routine
 bcc SysIRQ20 branch if serviced
 ldb R$CC,s get condition codes
 orb #IntMasks set interrupt masks
 stb R$CC,s update masks
SysIRQ20 rti



***********************************************************
*     Routine SysRet
*
*   Return to system after service request
*
* Input: U = reqisters ptr
*
* Output: does not return to caller
*
* Data: D.SysPrc
*
* Calls: SvcRet
*
SysRet ldx D.SysPrc get system process ptr
 lbsr ChkPrTsk get task
 leas 0,u move stack ptr
 rti start process


***********************************************************
*
*     In-System IRQ Transfer
*
GoPoll jmp [D.Poll]


***********************************************************
*
*     Subroutine IOPoll
*
IOPoll orcc #Carry set carry
 rts

FIRQHN   jmp   [>$00F8]
         rts
         rts

DATInit clra
 tfr a,dp
         ldb   #SysTask
         stb   DAT.Task
         sta   DAT.Regs
         lda   #IOBlock
         sta   >$FD8E   DAT.Regs+$E
         lda   #ROMBlock
         sta   >$FD8F   DAT.Regs+$F
         lbra  COLD+$F000

***********************************************************
*
*     Service Request Return
*
*   Switch to user's address space
*
* Input: X = Process Descriptor ptr
*        U = Process Stack ptr
*
* Output: does not return
*
* Data: none
*
* Calls: none
*
SVCRET ldb P$Task,x Get task number from process
 orcc #IntMasks
 stb DAT.Task
 leas 0,u Reset stack pointer
 rti


PassSWI ldb P$Task,x get process task
 ifeq DAT.Uniq
 endc
 stb DAT.Task swith to task
 jmp 0,u go to user routine

* Get byte at 0,X in task B
* Returns value in A
LDABX andcc #^CARRY clear carry
 pshs B,CC
 orcc #IntMasks
 stb DAT.Task
 lda 0,X
 ldb #SysTask
 stb DAT.Task
 puls PC,B,CC

STABX andcc #^Carry clear carry
 pshs B,CC save registers
 orcc #IntMasks set interrupt masks
 ifeq DAT.Uniq
 endc
 stb DAT.Task switch tasks
 sta 0,X store data byte
 ifeq DAT.Uniq
 else
 ldb #SysTask get system task
 endc
 stb DAT.Task switch tasks
 puls PC,B,CC

LDBBX andcc #^Carry clear carry
 pshs a,cc save registers
 orcc #IntMasks set interrupt masks
 ifeq DAT.Uniq
 endc
 stb DAT.Task switch tasks
 ldb 0,X get data byte
 ifeq DAT.Uniq
 else
 lda #SysTask get system task
 endc
 sta DAT.Task switch tasks
 puls PC,A,CC
 ifeq DAT.Uniq
 endc
 page
***********************************************************
*
*     Subroutines Mover00
*
*   Actual move routine (MUST be in upper 256 bytes)
*
Mover00 orcc #IntMasks set interrupt masks
 ifeq DAT.Uniq
 endc
 bcc MoveRegs branch if no carry
 sta DAT.Task set source task
 lda ,X+ get data byte
 stb DAT.Task set destination task
 sta ,u+ copy data byte
 leay 1,Y adjust double byte count
 bra Mover30
Mover10 lda 1,s get source task number
 orcc #IntMasks set interrupt masks
MoveRegs sta DAT.Task set source task
 ldd ,X++ get data double byte
 exg b,dp switch data & task
 stb DAT.Task
 exg b,dp switch back
 std ,u++
 ifeq DAT.Uniq
 else
Mover30 lda #SysTask get system task
 endc
 sta DAT.Task set system task
 lda 0,s get previous masks
 tfr A,CC reset interrupt masks
 leay -1,Y count double byte
 bne Mover10 branch if more
 puls PC,u,Y,X,DP,D,CC


SetDAT00 orcc #IntMasks set interrupt masks
 ifeq DAT.Uniq
 endc
SetDAT10 lda 1,X get DAT image
 leax 2,X move image ptr
 stb DAT.Task set task register
 sta ,u+ set block register
 ifeq DAT.Uniq
 else
 lda #SysTask get system task number
 endc
 sta DAT.Task set task register
 leay -1,Y count register
 bne SetDAT10 branch if more
 puls pc,u,y,x,d,cc
 page
***********************************************************
*
*     Interrupt Vector Routines
*
*   Set interrupt masks, of necessary, set system memory,
*   and jump through direct page psuedo-vector
*
* Data: none
*
* Calls: [D.SWI3], [D.SWI2], [D.FIRQ], [D.IRQ], [D.SWI], [D.NMI]
*

SWI3RQ orcc #IntMasks
 ldb #D.SWI3
 bra Switch

SWI2RQ orcc #IntMasks
 ldb #D.SWI2
 bra Switch

FIRQ   tst   ,s
         bmi   FIRQ10
         pshs  a
         lda   1,s
         pshs  y,x,dp,b,a
         ora   #$80
         pshs  a
         lda   $08,s
         sta   1,s
         stu   $08,s
FIRQ10    ldb   #D.FIRQ
         bra   Switch

IRQ orcc #IntMasks
 ldb #D.IRQ

Switch lda #SysTask
 sta DAT.Task
Switch10 clra
 tfr A,DP
 tfr D,X
 jmp [,X]

SWIRQ ldb #D.SWI
 bra Switch

NMIRQ ldb #D.NMI
 bra Switch

 emod
OS9End equ *

  fcb $9F,$1A,$C8,$30,$10,$34,$AD,$EC,$A0

HdlrVec equ *
 fdb TICK+$FFE0-*   Clock tick
 fdb UserSWI3+$FFE2-*      Swi3 handler
 fdb UserSWI2+$FFE4-*    Swi2 handler
 fdb FIRQHN+$FFE6-*      Fast irq handler
 fdb UserIRQ+$FFE8-*     Irq handler
 fdb UserSWI+$FFEA-*     Swi handler
 fdb 0000+$FFEC-*   Nmi handler
 fdb 0000+$FFEE-*

 fdb 0000+$FFF0-*
 fdb SWI3RQ+$FFF2-* Swi3 handler
 fdb SWI2RQ+$FFF4-* Swi2 handler
 fdb FIRQ+$FFF6-* Fast irq handler
 fdb IRQ+$FFF8-* Irq handler
 fdb SWIRQ+$FFFA-* Swi handler
 fdb NMIRQ+$FFFC-* Nmi handler
 fdb DATInit+$FFFE-*
ROMEnd equ *
