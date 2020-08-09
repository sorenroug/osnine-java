 nam OS-9 Level II V1.2
 ttl Module Header

********************************
* Extracted from Dragon 128/Dragon Beta computer.
* The CPUType is called DRG128, and CPUSpeed is TwoMHz
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

************************************************************
*
*     Module Header
*
 use defsfile


Type set Systm
Revs set ReEnt+8
 mod OS9End,OS9Name,Type,Revs,0,0

OS9Name fcs /OS9p1/

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
* Edition   4 - change to link to "Init" before "OS9p2"
*   83/01/19  - move "IOHook" from here to "OS9p2"
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
* Edition  12 - Added conditionals for Dragon 128         PSD 83/11/04
*               Vivaway Ltd

 fcb 12 Edition number
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
 ifeq RAMCheck-ByteType
 jmp NOWHERE Code is not available
 endc
 clra clear d
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
 tfr D,S set stack
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
 std ,X++ set psuedo-vector
 cmpx #D.XNMI end of vectors?
 bls Cold15 branch if not
 leas 2,S return scratch
 ldx D.XSWI2 get user service routine
 stx D.UsrSvc set user entry
 ldx D.XIRQ get user IRQ routine
 stx D.UsrIRQ set user entry
 leax SysSvc,PCR get system service routine
 stx D.SysSVC set system entry
 stx D.XSWI2 set system entry
 leax SysIRQ,PCR get system IRQ routine
 stx D.SysIRQ set system entry
 stx D.XIRQ set IRQ entry
 leax GoPoll,pcr get call to [D.Poll]
 stx D.SvcIRQ set in-system IRQ service
 leax IOPoll,PCR get polling routine ptr
 stx D.POLL set it
 leay SvcTbl,PCR get service routine initial
 lbsr SetSvc install service routines
 ldu D.PrcDBT get process descriptor block ptr
 ldx D.SysPrc get system process ptr
 stx 0,U set process zero page
 stx 1,U set process one page
 lda #1 set process ID
 sta P$ID,X
 lda #SysState get system state
 sta P$State,X set state
 lda #SysTask get system task
 sta D.SysTsk set system task number
 sta P$Task,X set process task number
 lda #255 get high priority
 sta P$Prior,X set process priority
 sta P$Age,X set process age
 leax P$DATImg,X get DAT image ptr
 stx D.SysDAT set system DAT image ptr
 ifeq CPUType-DRG128
 lda #$D8
 sta D.GRReg graphics control port
 endc
 ifeq DAT.WrEn
 clra
 clrb
 else
* Write Enable: The hypothesis is that the top bit in the logical address
* is used for write enable and ignored for addressing.
 ldd #DAT.WrEn
 endc
 std ,X++ use block zero for system
 ifge RAMCount-2
 incb block one
 std ,x++
 endc
 ldy #Dat.BlCt-ROMCount-RAMCount-1 get free block count
 ldd #DAT.Free get free block code
Cold16 std ,X++ mark free entry
 leay -1,Y count block
 bne Cold16 branch if more
 ifle DAT.BlMx-255
 ldb #ROMBlock get ROM block number
 std ,X++ set ROM block
 ldd #IOBlock get I/O block number
 std ,X++ set I/O block
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
 ifeq RAMCheck-BlockTyp
 ldy #DAT.BlSz*RAMCount get unused block ptr
 ldx D.BlkMap
 endc
 ifeq RAMCheck-ByteType
 jmp NOWHERE Code is not available
 endc
Cold20 equ *
 ifeq RAMCheck-BlockTyp
 pshs X
 ldd 0,S
 endc
 ifeq RAMCheck-ByteType
 jmp NOWHERE Code is not available
 endc
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
 ifeq RAMCheck-BlockTyp
 ldu 0,y get current contents
 ldx #$00FF get first test pattern
 stx 0,Y store it
 cmpx 0,Y did it store?
 bne Cold30 branch if not
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
 endc
 ifeq RAMCheck-ByteType
 jmp NOWHERE Code is not available
 endc
*
*      search Not-Ram, excluding I/O, for modules
*
 ldx D.BlkMap
 inc 0,X claim block zero for system
 ifge RAMCount-2
 inc 1,x
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
 ifne TEST
 else
 bsr MovDAT
 endc
 pshs x save Block Map ptr
 ldx #0 make block offset
 ifne (CPUType-DRG128)*(CPUType-Pal1M92)
 endc
Cold55 equ *
 ifeq ROMCheck-UnLimitd
* The code in this conditional branch is retrieved from Fujitsu FM-11
 cmpb #DAT.BlMx
 bne Cold57
 ldx #2048   Should this be DAT.BlSz?
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
 lbsr LDDDXY get module size
 leax D,X move ptr
 bra Cold75
Cold70 leax 1,X move ptr
Cold75 tfr X,D copy ptr
 tstb end of block?
 bne Cold60 branch if not
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
 ifne TEST
 jmp NOWHERE Code is not available
 endc
Cold.z1 leax InitName,pcr Get initial module name ptr
 bsr LinkSys Link to configuration module
 bcc Cold.z2
 ifne TEST
 jmp NOWHERE Code is not available
 endc
 os9 F$Boot
 bcc Cold.z1
 ifne TEST
 jmp NOWHERE Code is not available
 endc
 bra ColdErr

Cold.z2 stu D.Init
Cold.z3 leax P2Name,pcr
 bsr LinkSys
 bcc Cold.xit
 ifne TEST
 jmp NOWHERE Code is not available
 endc
 os9 F$Boot
 bcc Cold.z3
ColdErr equ *
 jmp [D$REBOOT]

Cold.xit jmp 0,y go to "OS9p2"

LinkSys lda #SYSTM set module type
 os9 F$Link link to it
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
MovDAT pshs Y,X,D save regs
 ldb #DAT.BlCt get block count
 ldx 0,S get starting block number
MovDAT.B stx ,Y++ set DAT image
 leax 1,X mov ptr
 decb done?
 bne MovDAT.B bra if not return
 puls PC,Y,X,D

 ttl Coldstart Constants
 page
*****
*
* System Service Routine Table
*
SvcTbl equ *
 fcb F$Link
 fdb Link-*-2
 fcb F$PRSNAM
 fdb PNAM-*-2
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
 fcb F$NProc+SysState
 fdb NextProc-*-2
 fcb F$VModul+SysState
 fdb VModule-*-2
 fcb F$SSVC
 fdb SSVC-*-2
 fcb F$SLink+SysState
 fdb SLink-*-2
 fcb F$Boot+SysState
 fdb Boot-*-2
 fcb F$BtMem+SysState
 fdb SRqMem-*-2
 fcb F$Move+SysState
 fdb Move-*-2
 fcb F$AllRAM
 fdb AllRAM-*-2
 fcb F$AllImg+SysState
 fdb AllImg-*-2
 fcb F$SetImg+SysState
 fdb SETIMG-*-2
 fcb F$FreeLB+SysState
 fdb FreeLB-*-2
 fcb F$FreeHB+SysState
 fdb FreeHB-*-2
 fcb F$AllTsk+SysState
 fdb AllTsk-*-2
 fcb F$DelTsk+SysState
 fdb DELTSK-*-2
 fcb F$SetTsk+SysState
 fdb SetTsk-*-2
 fcb F$ResTsk+SysState
 fdb RESTSK-*-2
 fcb F$RelTsk+SysState
 fdb RelTsk-*-2
 fcb F$DATLog+SysState
 fdb DATLOG-*-2
 fcb F$LDAXY+SysState
 fdb F.LDAXY-*-2
 fcb F$LDDDXY+SysState
 fdb F.LDDDXY-*-2
 fcb F$LDABX+SysState
 fdb F.LDABX-*-2
 fcb F$STABX+SysState
 fdb F.STABX-*-2
 fcb F$ELink+SysState
 fdb ELink-*-2
 fcb F$FModul+SysState
 fdb FMod-*-2
 ifeq CPUType-DRG128
 fcb F$GMap
 fdb GMap-*-2
 fcb F$GClr
 fdb GClr-*-2
 endc
 fcb $80

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



************************************************************
*
*     User State Interrupt Routines
*
*   Checks for user defined routine; uses system if none
*
* Data: D.Proc
*
* Calls: UserSvc
*
UserSWI3 ldx D.Proc get current process ptr
 ldu P$SWI3,X get user interrupt routine
 beq UserSvc branch if none
UsrSWI10 lbra PassSWI

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
UserSvc ldd D.SysSvc get system SWI2 service routine
 std D.XSWI2
 ldd D.SysIRQ Get system irq routine
 std D.XIRQ
 lda P$State,X
 ora #SysState
 sta P$State,X
 sts P$SP,X
 leas (P$Stack-R$Size),X
 andcc #^IntMasks
 leau 0,S
 bsr GetRegs
 ldb P$Task,X
 ldx R$PC,U
 lbsr LDBBX Get byte from Task B
 leax 1,X Increment X
 stx R$PC,U
 ldy D.UsrDis
 lbsr Dispatch Go do request
 ldb R$CC,U get condition code
 andb #^IntMasks
 stb R$CC,U update condition codes
 ldx D.Proc
 bsr PutRegs
 lda P$State,X Clear system state
 anda #^SysState
 lbra UsrRet.a
 page
************************************************************
*
*     Subroutine GetRegs
*
GetRegs lda P$Task,X
 ldb D.SysTsk
 pshs U,Y,X,DP,D,CC
 ldx P$SP,X
 bra PutReg.A



************************************************************
*
*     Subroutine PutRegs
*
PutRegs ldb P$Task,X
 lda D.SysTsk
 pshs U,Y,X,DP,D,CC
 ldx P$SP,X
 exg X,U
PutReg.A ldy #R$Size/2
 tfr B,DP
 orcc #IntMasks
 lbra MoveRegs
 page
************************************************************
*
*     System Service Request Routine
*
*
SysSvc leau 0,S Copy stack ptr
 lda R$CC,U
 tfr a,cc
 ldx R$PC,U Get program counter
 ldb ,X+ Get service code
 stx R$PC,U Update program counter
 ldy D.SysDis Get system service routine table
 bsr Dispatch Call service routine
 lbra SysRet
 page
************************************************************
*
*     Subroutine Dispatch
*
*   Calls service routing using service request code as an
*   index in table of service routine addresses
*
* Input: B = Service Request code
*        Y = Service Routine Address Table ptr
*        U = registers ptr
*
* Output: none
*
* Data: none
*
* Calls: [max(B*2,254),Y]
*
Dispatch aslb make table offset
 bcc Dispat10 branch if not I/O request
 rorb correct code
 ldx IOEntry,y get i/o entry
 bra Dispat20
Dispat10 clra
 ldx D,Y get routine entry
 bne Dispat20 branch if good code
 comb set carry
 ldb #E$UnkSvc err: unknown service request
 bra Dispat30
Dispat20 pshs u save registers ptr
 jsr 0,X call service routine
 puls u retrieve registers ptr
Dispat30 tfr cc,a copy condition codes
 bcc Dispat40 branch if no error
 stb R$B,U return error code
Dispat40 ldb R$CC,U get calling condition
 andb #%11010000 save masks & flag
 stb R$CC,U save them
 anda #%00101111 clear masks & flag
 ora R$CC,U add masks & flag
 sta R$CC,U update condition
 rts
 page
************************************************************
*
*     Subroutine SSvc
*
*   Set Service Routine Table entry Service routine
*
* Input: U = Registers ptr
*
* Output: Carry clear
*
* Data: none
*
* Call: SetSvc
*
SSVC ldy R$Y,U Get table address
 bra SetSvc



************************************************************
*
*     Subroutine SetSvc
*
*   Set Service Routine Table entries
*
* Input: Y = Routine Initialization ptr
*
* Output: none
*
* Data: D.SysSvc, D.UsrSvc
*
* Calls: none
*
SetSvc10 clra
 aslb make table offset & set flag
 tfr D,U save offset
 ldd ,Y++ get routine offset
 leax D,Y make routing ptr
 ldd D.SysDis get system dispatch table ptr
 stx D,U set routine entry
 bcs SetSvc branch if system only
 ldd D.UsrDis get user dispatch table ptr
 stx D,U set routine entry
SetSvc ldb ,Y+ get next request code
 cmpb #$80 end of table code?
 bne SetSvc10 branch if not
 rts
 page
***********************************************************
*
*     Subroutine SLink
*
*   System Link Service routine
*
* Input: U = registers ptr
*        R$A,u = Module Type
*        R$X,u = Name String ptr
*        R$Y,a = Name string DAT Image ptr
*
* Output: U unchanged
*        R$A,u = Module Type
*        R$B,u = Module Revision
*        R$X,u = updated Name String ptr
*        R$Y,u = Module Entry ptr
*        R$U,u = Module ptr
*      Carry clear if successful; set otherwise
*
* Data: none
*
* Calls: SysLink
*
SLink ldy R$Y,U get DAT image ptr
 bra SysLink

***********************************************************
*
*     Subroutine ELink
*
*   Link using already located Module Directory entry
*
* Input: U = registers ptr
*            R$B,u = Module type byte
*            R$X,u = Module Directory entry ptr
*
* Output: Carry clear if successful; set otherwise
*
* Data: none
*
* Calls: EntLink
*
ELink pshs u save registers ptr
 ldb R$B,u get module revision
 ldx R$X,u get directory entry ptr
 bra EntLink
 page
***********************************************************
*
*     Subroutine Link
*
*   Find specified module & switch it into process space
*
* Input: U = Register Package
* Output: Cc = Carry Set If Not Found
* Local: None
* Global: D.ModDir
*
Link ldx D.Proc get process ptr
 leay P$DATImg,x get DAT image ptr
SysLink pshs U save register pptr
 ldx R$X,U get name string ptr
 lda R$A,u get type/language byte
 lbsr FModule search module directory
 lbcs LinkErr branch if not found
 leay 0,U copy directory entry ptr
 ldu 0,S get registers ptr
 stx R$X,U return string to user
 std R$D,U return type/language & revision
 leax 0,Y copy directory entry ptr
EntLink bitb #ReEnt is module reentrant?
 bne Link10 branch if so
 ldd MD$Link,x is module busy?
 beq Link10 branch if not
 ldb #E$ModBsy err: module busy
 bra LinkErr
Link10 ldd MD$MPtr,X get module block ptr
 pshs X,D save offset & entry ptr
 ldy MD$MPDAT,X get DAT image ptr
 ldd MD$MBSiz,X get block size
 addd #DAT.BlSz-1 round to next block
 tfr a,b copy MSB size
 lsrb get block count
 lsrb
 ifge DAT.BlSz-2048
 lsrb
 ifge DAT.BlSz-4096
 lsrb
 endc
 endc
 inca adjust for uppermost 256 bytes
 lsra get adjusted block count
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
Link20 lbsr SetImage set process DAT image
 ifne DAT.WrPr
 ora #DAT.WrPr
 endc
 ifne DAT.WrEn
 ora #DAT.WrEn
 endc
Link30 leax P$Links,X Point to memory block link counts
 sta 0,S save block number
 asla make table offset
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
 lbsr DATtoLog convert to logical
 stx 8,U
 ldx MD$MPtr,Y
 ldy MD$MPDAT,Y
 ldd #M$EXEC Get execution offset
 lbsr LDDDXY
 addd R$U,U add it to start of module
 std R$Y,u Return it to user
 clrb
 rts

LinkErr orcc #Carry set carry
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
 ifne DAT.WrPr+DAT.WrEn
 endc
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
 page
***********************************************************
*
*     Subroutine VModule
*
VModule pshs U Save register ptr
 ldx R$X,U Get new module ptr
 ldy R$D,U
 bsr ValMod Validate module
 ldx 0,s  Retrieve register ptr
 stu R$U,x Return directory entry
 puls PC,U

***********************************************************
*
*     Subroutine ValMod
*
ValMod pshs Y,X save new module ptr
 lbsr ModCheck is it good module?
 bcs ValMoErr branch if not
 ldd #M$Type get module type offset
 lbsr LDDDXY
 andb #Revsmask
 pshs D
 ldd #M$Name
 lbsr LDDDXY
 leax D,X
 puls a
 lbsr FModule
 puls a retrieve new revision level
 bcs ValMod20
 pshs a
 andb #Revsmask get old module revision
 subb ,s+ get old-net difference
 bcs ValMod20 branch if new is higher
 ldb #E$KwnMod err: known module
 bra ValMoErr
ValMoErA ldb #E$DirFul error: directory full
ValMoErr orcc #carry set carry
 puls PC,Y,X
ValMod20 ldx 0,S get block offset
 lbsr SetMoImg set DAT image for module
 bcs ValMoErA bra if error
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
 bra ValMod35
ValMod30 leax MD$ESize,X Move to next entry
ValMod35 cmpx D.ModEnd
 bcc ValMod55
 cmpx 0,S
 beq ValMod30
 cmpy [MD$MPDAT,X] module in this block?
 bne ValMod30
 bsr FreDATI
ValMod55 puls U
 ldx D.BlkMap
 ldd MD$MBSiz,U
 addd #DAT.BlSz-1 round to next block
 lsra get block count
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 ldy MD$MPDAT,U
ValMod60 pshs x,a
 ldd ,Y++
 leax D,X
 ldb 0,X Get block marker
 orb #ModBlock mark block
 stb 0,X save status bits 
 puls X,A restore count,blkmap ptr
 deca next blk
 bne ValMod60 jif not done
 clrb clear carry
 puls PC,Y,X


* non-contiguous modules
FreDATI pshs U,Y,X,D
 ldx MD$MPDAT,X
 pshs X
 clra
 clrb
Fre.Lp ldy 0,X
 beq Fre.Out
 std ,X++
 bra Fre.Lp
Fre.Out puls x
 ldy 2,S
 ldu MD$MPDAT,U
 puls D
Fre.Lp2 cmpx MD$MPDAT,Y
 bne Fre.NoCh
 stu MD$MPDAT,Y
 cmpd MD$MBSiz,y New block smaller than old?
 bcc Fre.Not
 ldd MD$MBSiz,Y
Fre.Not std MD$MBSiz,y  set new size
Fre.NoCh leay MD$ESize,Y
 cmpy D.ModEnd
 bne Fre.Lp2
 puls PC,U,Y,X


* non-contiguous modules
SetMoImg pshs U,Y,X
 ldd #M$Size
 lbsr LDDDXY
 addd 0,S
 addd #DAT.BlSz-1 Round up
 lsra
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 tfr A,B
 pshs B
 incb
 lslb
 negb
 sex
 bsr chkspce
 bcc SetI.out
 os9 F$GCMDir get rid of empty slots in module directory
 ldu #0
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
Chks.D ldu ,Y++ xfer DAT img to Mod dat img
 stu ,X++
 decb
 bne Chks.D
 clr 0,X
 clr 1,X
 rts

Chks.err orcc #Carry show error
 rts done
 page
***********************************************************
*
*     Subroutine ModCheck
*
*   Check Module ID, Header Parity, & CRC
*
ModCheck pshs Y,X save module ptr
 clra
 clrb
 lbsr LDDDXY get sync bytes
 cmpd #M$ID12 is it good ID?
 beq ModChk10 branch if so
 ldb #E$BMID err: bad module ID
 bra ModChErr
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
 ldd #M$Size get module size offset
 lbsr LDDDXY
 pshs Y,X,D
 ldd #$FFFF
 pshs D Init crc register
 pshs B Init crc register
 lbsr AdjImg
 leau 0,S get CRC accumulator ptr
ModChk40 equ *
 tstb time for a break?
 bne ModChk45
 pshs x
 ldx #1
 os9 F$Sleep
 puls x
ModChk45 lbsr LDAXYP get next module byte
 bsr CRCCal accumulate it
 ldd 3,S
 subd #1 count byte
 std 3,S
 bne ModChk40
 puls y,x,b
 cmpb #CRCCon1 is first bytes correct?
 bne ModChk50 branch if not
 cmpx #CRCCon23 are other bytes correct?
 beq ModChk60 branch if so
ModChk50 ldb #E$BMCRC err: bad module crc
ModChErr orcc #Carry SET Carry
ModChk60 puls X,Y,PC
 page
***********************************************************
*
*     Subroutine CRCCal
*
*   Calculate Next CRC Value
*
CRCCal eora 0,U add CRC MSB
 pshs A save it
 ldd 1,U get CRC mid & low
 std 0,U shift to high & mid
 clra
 ldb 0,S get old high
 lslb shift d
 rola
 eora 1,U add old lsb
 std 1,U Set crc mid & low
 clrb
 lda 0,S get old MSB
 lsra shift d
 rorb
 lsra shift d
 rorb
 eora 1,u add new mid
 eorb 2,u add new low
 std 1,u set mid & low
 lda 0,S get old MSB
 lsla
 eora 0,S add old MSB
 sta 0,S
 lsla
 lsla
 eora 0,S add altered MSB
 sta 0,S
 lsla
 lsla
 lsla
 lsla
 eora ,S+ add altered MSB
 bpl CRCC99
 ldd #$8021
 eora 0,U
 sta 0,U
 eorb 2,U
 stb 2,U
CRCC99 rts


***********************************************************
*
*     Subroutine CRCGen
*
*   CRC Accumulation Service routine
*
CRCGen ldd R$Y,u zero byte count?
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
 lbsr CRCCal update crc
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
 ifeq CPUType-Pal1M92
 endc
 page
***********************************************************
*
*     Subroutine FMod
*
*   Find Module Directory Entry Service routine
*
FMod pshs u
 lda R$A,U
 ldx R$X,U
 ldy R$Y,U
 bsr FModule
 puls y
 std R$D,Y
 stx R$X,Y
 stu R$U,Y
 rts
 page
***********************************************************
*
*     Subroutine FModule
*
FModule ldu #0 Return zero if not found
 pshs u,D
 bsr SkipSpc Skip leading spaces
 cmpa #'/ Is there leading '/'
 beq FModul55
 lbsr PrsNam Parse name
 bcs FModul60 Branch if bad name
 ldu D.ModDir Get module directory ptr
 bra FModul53 Test if end is reached
FModul10 pshs Y,X,D
 pshs Y,X
 ldy MD$MPDAT,u Get module ptr
 beq FModul40 Branch if not used
 ldx MD$MPtr,u Get name offset
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
 bcs FModul50
 ldd #M$Type Get desired language
 lbsr LDDDXY
 sta 0,S
 stb 7,S
 lda 6,S Get desired type
 beq FModul30 Branch if any
 anda #TypeMask
 beq FModul20 Branch if any
 eora 0,S Get type difference
 anda #TypeMask
 bne FModul50 Branch if different
FModul20 lda 6,S Get desired language
 anda #LangMask
 beq FModul30 Branch if any
 eora ,S
 anda #LangMask
 bne FModul50 Branch if different
FModul30 puls Y,X,D Retrieve registers
 abx
 clrb
 ldb 1,S
 leas 4,S
 rts
FModul40 leas 4,S
 ldd 8,s Free entry found?
 bne FModul50 Branch if so
 stu 8,S
FModul50 puls Y,X,D Retrieve registers
 leau MD$ESize,U Move to next entry
FModul53 cmpu D.ModEnd End of directory?
 bcs FModul10 Branch if not
 comb
 ldb #E$MNF
 bra FModul60
FModul55 comb set carry
 ldb #E$BNam
FModul60 stb 1,S Save B on stack
 puls D,U,PC


***********************************************************
*
*     Subroutine SkipSpc
*
*   Skip spaces
*
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
***********************************************************
*
*     Subroutine PNam
*
*   Parse Name Service routine
*
*
PNAM ldx D.Proc
 leay P$DATImg,X
 ldx R$X,u Get string ptr
 bsr PrsNam parse name
 std R$D,U return delimiter; byte count
 bcs PNam10 branch if error
 stx R$X,U return ptr
 abx get end of name ptr
PNam10 stx R$Y,U return end ptr
 rts
 page
***********************************************************
*
*     Subroutine PrsNam
*
*   Parse OS-9 type name
*
PrsNam pshs y
 lbsr AdjImg
 pshs Y,X
 lbsr LDAXYP Get first char
 cmpa #'/ Slash?
 bne PrsNam10 ..no
 leas 4,S
 pshs Y,X
 lbsr LDAXYP
PrsNam10 bsr ALPHA 1st character must be alphabetic
 bcs PrsNam40 Branch if bad name
 clrb
PrsNam20 incb INCREMENT Character count
 tsta End of name (high bit set)?
 bmi PrsNam30 ..yes; quit
 lbsr LDAXYP
 bsr AlphaNum Alphanumeric?
 bcc PrsNam20 ..yes; count it
PrsNam30 andcc #$ff-carry clear carry
 bra PrsNam70
PrsNam40 cmpa #', is it comma?
 bne PrsNam60 branch if not
PrsNam50 leas 4,S
 pshs Y,X
 lbsr LDAXYP
PrsNam60 cmpa #$20 is there a space?
 beq PrsNam50 branch if so
 comb set carry
 ldb #E$BNam err: bad name
PrsNam70 puls Y,X
 pshs d,cc
 tfr Y,D
 subd 3,S
 asrb get block number
 lbsr DATtoLog
 puls PC,Y,D,CC
 page
***********************************************************
*
*     Subroutine AlphaNum
*

*
* Passed:  (A)=Char
* Returns:  Cc=Set If Not Alphanumeric
* Destroys None
*
AlphaNum pshs a
 anda #$7F
 cmpa #'. period?
 beq IsAlpha branch if so
 cmpa #'0 Below zero?
 blo NotAlpha ..yes; return carry set
 cmpa #'9 Numeric?
 bls IsAlpha ..yes
 cmpa #'_ Underscore?
 bne ALPHA10
IsAlpha clra
 puls PC,a



***********************************************************
*
*     Subroutine Alpha
*
ALPHA pshs a
 anda #$7F Strip high order bit
ALPHA10 cmpa #'A
 blo NotAlpha
 cmpa #'Z Upper case alphabetic?
 bls IsAlpha ..yes
 cmpa #$61 Below lower case a?
 blo NotAlpha ..yes
 cmpa #$7A Lower case?
 bls IsAlpha ..yes
NotAlpha coma Set carry
 puls PC,a
 page
***********************************************************
*
*     Subroutine CNam
*
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
SCNam10 ldx R$Y,u get module name ptr
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
ChkNam pshs U,Y,X,D save registers
 ldu 2,S
 pulu Y,X
 lbsr AdjImg
 pshu Y,X
 ldu 4,S
 pulu Y,X
 lbsr AdjImg
 bra ChkNam15
ChkNam10 ldu 4,S
 pulu Y,X
ChkNam15 lbsr LDAXYP
 pshu Y,X
 pshs a
 ldu 3,S
 pulu Y,X
 lbsr LDAXYP
 pshu Y,X
 eora 0,S
 tst ,s+
 bmi ChkNam30 branch if not
 decb is this last target?
 beq ChkNam20 branch if so
 anda #^('a-'A) clear case difference
 beq ChkNam10 ..yes; repeat
ChkNam20 comb Set carry
 puls PC,U,Y,X,D
ChkNam30 decb
 bne ChkNam20 is this last target?
 anda #^(Sign+'a-'A) clear case & sign difference
 bne ChkNam20 branch if different
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
SRqMem ldd R$D,U get byte count
 addd #$FF round up to page
 clrb
 std R$D,U return size to user
 ldy D.SysMem get system memory map ptr
 leas -2,S get scratch
 stb 0,S set DAT image offset
SRqMem10 ldx D.SysDAT get system DAT image ptr
 aslb shift for two-byte entries
 ldd B,X get block number
 cmpd #DAT.Free is it free block?
 beq SRqMem20
 ldx D.BlkMap branch if so
 ifne DAT.WrPr+DAT.WrEn
 endc
 lda D,X get block flags
 cmpa #RAMinUse is it allocatable?
 bne SRqMem30 branch if not
 leay DAT.BlSz/256,Y leave map as is
 bra SRqMem40
SRqMem20 clra cleat page flags
SRqMem30 ldb #DAT.BlSz/256 get page count
SRqMem35 sta ,y+ set map
 decb countr page
 bne SRqMem35 branch if more
SRqMem40 inc 0,S count block
 ldb 0,S get DAT image offset
 cmpb #DAT.BlCt checked all blocks?
 bcs SRqMem10 branch if not
SRqMem50 ldb R$D,U get page count
SRqMem55 cmpy D.SysMem beginning of map?
 bhi SRqMem60 branch if not
 comb set carry
 ldb #E$MemFul err: memory full
 bra SRqMem80
SRqMem60 lda ,-y get page flag
 bne SRqMem50 branch if not free
 decb countr free page
 bne SRqMem55 branch if not enough
 sty 0,S same map ptr
 lda 1,S get page number
 lsra get block number
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 ldb 1,S get page number
 andb #^DAT.Addr get page within block
 addb R$D,U add number of pages
 addb #^DAT.Addr round up to next block
 lsrb get block count
 lsrb
 ifge DAT.BlSz-2048
 lsrb
 ifge DAT.BlSz-4096
 lsrb
 endc
 endc
 ldx D.SysPrc get system process ptr
 lbsr AllImage allocate RAM
 bcs SRqMem80 branch if error
 ldb R$A,U get page count
SRqMem70 inc ,Y+ get page flag
 decb count page
 bne SRqMem70 branch if more
 lda 1,S get page number
 std R$U,U return it to user
 clrb clear carry
SRqMem80 leas 2,S return scratch
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
SRtMem ldd R$D,U get byte count
 beq SrTM.F  branch if none
 addd #$FF round up to page
 ldb R$U+1,u is address good?
 beq SRtM.A branch if so
 comb set carry
 ldb #E$BPAddr err: bad page address
 rts
SRtM.A ldb R$U,U get page number
 beq SrTM.F branch if returning nothing
 ldx D.SysMem get system memory map ptr
 abx get entry ptr
SRtM.B ldb 0,X get page flags
 andb #^RAMinUse clear RAM in use flag
 stb ,x+ update entry
 deca count page
 bne SRtM.B branch if more
 ldx D.SysDAT get system DAT image
 ldy #DAT.BlCt get image block count
SRtM.C ldd 0,X get block number
 cmpd #DAT.Free is it free block?
 beq SRtM.E branch if so
 ldu D.BlkMap get block map ptr
 ifne DAT.WrPr+DAT.WrEn
 endc
 lda d,U get block flags
 cmpa #RAMinUse is it just RAM in use?
 bne SRtM.E branch if not
 tfr X,D copy DAT image ptr
 subd D.SysDAT get image block number
 aslb get memory page map offset
 ifge DAT.BlSz-2048
 aslb
 ifge DAT.BlSz-4096
 aslb
 endc
 endc
 ldu D.SysMem get memory page map ptr
 leau d,U get block pages ptr
 ldb #DAT.BlSz/256 get pages per block
SRtM.D lda ,U+ get page flags
 bne SRtM.E branch if not free
 decb count page
 bne SRtM.D branch if more pages
 ldd 0,X get block number
 ldu D.BlkMap get block map ptr
 ifne DAT.WrPr+DAT.WrEn
 endc
 clr D,U mark block free
 ldd #DAT.Free get free block
 std 0,X mark image free
SRtM.E leax 2,X skip to next block
 leay -1,Y count block
 bne SRtM.C branch if more
SrTM.F clrb clear carry
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
 subd 0,S get block offset
 tfr D,X copy offset
 tfr Y,D pass DAT img ptr
 ifne DAT.WrEn
 endc
 OS9 F$VModul validate module
 pshs B save error code (if any)
 ldd 1,S get bootstrap begin
 leax D,X get current ptr
 puls B retrieve error code
 bcc Boot35 branch if no error
 cmpb #E$KwnMod is it known module?
 bne Boot40 branch if not
Boot35 ldd M$SIZE,X get module size
 leax D,X skip module
 bra Boot50
Boot40 leax 1,X try next
Boot50 cmpx 2,S end of Boot?
 bcs Boot30 branch if not
 leas 4,S return scratch
BootXX rts
 page


 ttl Dynamic Address Translator Routines
 page
***********************************************************
*
*     Subroutine RAMBlk
*
*   Search Memory Block Map for contiguous free RAM blocks
*
AllRAM ldb R$B,u get block count
 bsr RAMBlk allocate blocks
 bcs AllRAM10 branch if failed
 std R$D,u get block number
AllRAM10 rts

RAMBlk pshs Y,X,D save registers
 ldx D.BlkMap get Block Map ptr
RAMBlk10 leay 0,X copy map ptr
 ldb 1,S get block count
RAMBlk20 cmpx D.BlkMap+2 end of map?
 bcc RAMBlk30 branch if so
 lda ,x+ free block?
 bne RAMBlk10 branch if not
 decb found enough?
 bne RAMBlk20 branch if not
 tfr Y,D copy beginning block ptr
 subd D.BlkMap get block number
 sta 0,S return block number
 lda 1,S get block count
 stb 1,S return block number
RAMBlk25 inc ,y+ update flags
 deca done?
 bne RAMBlk25 branch if not
 clrb clear carry
 puls PC,Y,X,D
 page
RAMBlk30 comb set carry
 ldb #E$NoRam err: no RAM
 stb 1,S
 puls PC,Y,X,D

***********************************************************
*
*     Subroutine AllImg
*
*   Allocate RAM blocks for DAT image
*
AllImg ldd R$D,u  Get beginning and number of blocks
 ldx R$X,u
*
*    fall through to AllImage
*
***********************************************************
*
*     Subroutine AllImage
*
*   Allocate RAM blocks for process DAT image
*
* Input: A = beginning Block Number
*        B = Block count
*        x = Process Descriptor ptr
*
* Output: none
*
* Data: D.TmpDAT
*
* Calls: none
AllImage pshs u,Y,X,D
 asla
 leay P$DATImg,X
 leay A,Y
 clra
 tfr D,X
 ldu D.BlkMap
 pshs U,Y,X,D
AllI.A ldd ,Y++
 cmpd #DAT.Free
 beq AllI.B
 ifne DAT.WrPr+DAT.WrEn
 endc
 lda D,U
 cmpa #RAMinUse
 puls D
 bne AllImErr
 subd #1
 pshs D
AllI.B leax -1,X
 bne AllI.A
 ldx ,s++
 beq AllI.E
 ifeq CPUType-DRG128
 leau DAT.GBlk,U skip graphics blocks at first
 endc
AllI.C lda ,u+
 bne AllI.D
 leax -1,X
 beq AllI.E
AllI.D cmpu D.BlkMap+2
 bcs AllI.C
 ifeq CPUType-DRG128
 ldu D.BlkMap
 clrb now try graphics blocks
 leay BlkTrans,pcr
AllI.D1 lda B,Y
 lda A,U
 bne AllI.D2
 leax -1,X
 beq AllI.E
AllI.D2 incb
 cmpb #DAT.GBlk
 bcs AllI.D1
 endc
AllImErr ldb #E$MemFul err: memory full
 leas 6,S
 stb 1,S
 comb set carry
 puls PC,U,Y,X,D
AllI.E puls U,Y,X
 ifeq CPUType-DRG128
 leau DAT.GBlk,U skip graphics blocks initially
 endc
AllI.F ldd ,Y++
 cmpd #DAT.Free
 bne AllI.H
 ifeq CPUType-DRG128
AllI.G cmpu D.BlkMap+2 end of map?
 beq AllI.I ..yes
 lda ,U+ is this free block?
 else
AllI.G lda ,U+ is this free block?
 endc
 bne AllI.G branch if not
 inc ,-U claim block
 tfr U,D copy map ptr
 subd D.BlkMap get block number
 ifne DAT.WrEn
 endc
 std -2,y set image
AllI.H leax -1,x count block
 bne AllI.F branch if more
 ifeq CPUType-DRG128
 bra AllI.N finish off
AllI.I ldu D.BlkMap reset map ptr
 clrb clear counter
 bra AllI.P
AllI.L pshs b
 ldd ,Y++ get block number
 cmpd #DAT.Free is it free block?
 puls B
 bne AllI.M branch if not
AllI.P pshs Y save y
 leay BlkTrans,pcr point at translation table
AllI.K lda B,Y get block number
 incb bump counter
 tst a,u get block flags
 bne AllI.K not free block
 inc A,U claim block
 pshs B save counter
 tfr A,B get block number in d
 clra
 ifne DAT.WrEn
 andb #^DAT.WrEn
 endc
 ldy 1,S get image ptr
 std -2,Y set image
 puls Y,B retrieve regs
AllI.M leax -1,X count block
 bne AllI.L branch if more
AllI.N equ *
 endc
 ldx 2,S get process descriptor ptr
 lda P$State,X
 ora #ImgChg
 sta P$State,X
 clrb
 puls PC,U,Y,X,D

 ifeq CPUType-DRG128
*
* Graphics block translation table.
* Optimizes graphics memory allocation.
*
BlkTrans fcb $00,$01,$02,$03,$04,$05,$06,$07
         fcb $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
         fcb $10,$11,$12,$13,$14,$15,$16,$17
         fcb $18,$19,$1A,$1B,$1C,$1D,$1E,$1F

* OS-9 Level 2 normally allocates memory blocks from physical
* block 0 upwards. On the Dragon 128 the first 128k bytes (32
* blocks) can be allocated to the screen. In certain screen
* modes the same blocks in the two 64k byte pages must be
* allocated together, (eg blocks 10 to 14 with blocks 26 to 30).
* Therefore OS-9 has been expanded with the addition of two
* system calls to manage screen memory. F$GMap reserves screen
* memory, in the lower or both pages. F$GClr returns the memory.
* In order to maximise the availability of memory for the screen
* display, the normal OS-9 memory allocation routines have been
* modified . First, any memory above the first 32 blocks is used.
* Then blocks a reallocated from the first 32 in an order
* designed to maximise the availability of screen memory, (which
* is allocated by F$GMap from the top down). This order is
* determined by a table in the source file BlkTrans, used in the
* assembly of OS9P1 and IOMAN.

***********************************************************
*
*     Subroutine GMap
*
*   Allocate graphics display memory
*
* Input B = required block count per 64k page
*       A = 0 bottom 64k page only
*           1 both 64k pages
* Output X = beginning block number in bottom page
*        B,CC error code if memory not available
*
* Data: D.BlkMap
*
* Calls: none
*
GMap ldb R$B,U
 bsr GfxMap
 bcs GMap10
 stx R$X,U
GMap10 rts

GfxMap pshs X,D
 ldx D.BlkMap
 leax DAT.GBlk,X
GfxMap10 ldb 1,S
GfxMap20 cmpx D.BlkMap
 beq GfxMap50
 tst ,-x  free block?
 bne GfxMap10 ..no
 decb
 bne GfxMap20
 tfr X,D
 subd D.BlkMap
 std 2,S
 ldd 0,S
GfxMap40 inc ,X+
 decb
 bne GfxMap40
 clrb
 puls PC,X,D

GfxMap50 comb SET Carry
 ldb #E$NoRAM
 stb 1,S
 puls PC,X,D
 page
***********************************************************
*
*     Subroutine GClr
*
* Input: B = block count per 64k page
*       A = 0 bottom 64k page only
*           1 both 64k pages
*       X = beginning block number in first page
*
* Output: Carry clear
*
GClr ldb R$B,U
 ldx R$X,U get beginning block number
 pshs X,D
 abx calculate end block
 cmpx #DAT.GBlk
 bhi GfxClr30 not a graphics block
 ldx D.BlkMap get map ptr
 ldd 2,S get block number
 leax D,X point into map
 ldb 1,S get count
 beq GfxClr30 branch if none
GfxClr10 lda ,x get block flags
 anda #^RamInUse clear flag
 sta ,x+ update flags
 decb all done?
 bne GfxClr10 branch if not
GfxClr30 clrb clear carry
 puls PC,X,D
 endc
 page
***********************************************************
*
*     Subroutine FreeHB
*
*   Free High Block Service routine
*
FreeHB ldb R$B,u get block count
 ldy R$Y,u get DAT image ptr
 bsr FreeHBlk get free high block
 bcs FrHB10 branch if error
 sta R$A,u return block number
FrHB10 rts


***********************************************************
*
*     Subroutine FreeHBlk
*
*   Search DAT image for highest free block
*
FreeHBlk tfr b,a
FreeHB10 suba #DAT.BlCt+1 get negative beginning
 nega
 pshs X,D
 ldd #-1
 pshs D
 bra FreeBlk

***********************************************************
*
*     Subroutine FreeLB
*
*   Free Low Block Service routine
*
FreeLB ldb R$B,u get block count
 ldy R$Y,u get DAT image ptr
 bsr FreeLBlk get free low block
 bcs FrLB10 branch if error
 sta R$A,u return block number
FrLB10 rts



***********************************************************
*
*     Subroutine FreeLBlk
*
*   Search DAT image for lowest free block
*
FreeLBlk lda #-1 set low beginning
 pshs X,D
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
FreeBlk clra clear found count
 ldb 2,S get beginning block number
 addb 0,S add increment
 stb 2,S save beginning
 cmpb 1,S hit limit?
 bne FreeB20
 ldb #E$MemFul
 stb 3,S Save error code
 comb set carry
 bra FreeBXit
FreeB10 tfr A,B copy found count
 addb 2,s add beginning block number
FreeB20 lslb shift for two-byte entries
 ldx B,Y get next block image
 cmpx #DAT.Free is it free?
 bne FreeBlk branch if not
 inca count block
 cmpa 3,S found enough?
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
SETIMG ldd R$D,u Get beginning and number of blocks
 ldx R$X,u Process descriptor pointer
 ldu R$U,u New image pointer
SetImage pshs U,Y,X,D
 leay P$DATImg,X
 lsla
 leay A,Y
SETIMG10 ldx ,u++
 stx ,Y++
 decb
 bne SETIMG10
 ldx 2,S
 lda P$State,X
 ora #ImgChg
 sta P$State,X
 clrb
 puls PC,U,Y,X,D
 page

***********************************************************
*
*     Subroutine AllImg
*
*   Convert DAT image block number and block offset to
*   logical address Service routine
*
DATLOG ldb R$B,u  DAT image offset
 ldx R$X,u Block offset
 bsr DATtoLog
 stx R$X,u Return logical address
 clrb
 rts


***********************************************************
*
*     Subroutine DATtoLog
*
* Input: B, X
* Effect: updated X
DATtoLog pshs X,D
 aslb shift image to block offset
 aslb
 ifge DAT.BlSz-2048
 aslb
 ifge DAT.BlSz-4096
 aslb
 endc
 endc
 addb 2,S combine nibbles
 stb 2,S
 puls PC,X,D
 page
***********************************************************
*
*     Subroutine FLDAXY
*
*   Load A X, [Y] Service routine
F.LDAXY ldx R$X,u Block offset
 ldy R$Y,u DAT image pointer
 bsr LDAXY
 sta R$A,u return byte
 clrb
 rts


***********************************************************
*
*     Subroutine LDAXY
*
LDAXY pshs CC
 lda 1,Y
 orcc #IntMasks
 sta DAT.Regs
 lda 0,X
 clr DAT.Regs
 puls PC,CC
 page
***********************************************************
*
*     Subroutine LDAXYP
*
LDAXYP lda 1,Y
 pshs cc
 orcc #IntMasks
 sta DAT.Regs
 lda ,x+
 clr DAT.Regs
 puls cc
 bra AdjImg


***********************************************************
*
*     Subroutine AdjImg
*
AdjImg10 leax -DAT.BlSz,X
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
F.LDDDXY ldd R$D,u get offset offset
 leau R$X,U
 pulu Y,X
 bsr LDDDXY
 std -7,U
 clrb
 rts


***********************************************************
*
*     Subroutine LDDDXY
*
LDDDXY pshs Y,X
 leax D,X
 bsr AdjImg
 bsr LDAXYP
 pshs A
 bsr LDAXY
 tfr A,B
 puls PC,Y,X,A
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
F.LDABX ldb R$B,u get task number
 ldx R$X,u get data ptr
 lbsr LDABX call routine
 sta R$A,U return data
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
F.STABX ldd R$D,U get data & task number
 ldx R$X,U get data ptr
 lbra STABX
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
 ldx R$X,u get user X register
 ldy R$Y,u get user Y register
 ldu R$U,u get user U register
*
*     fall through to Mover
*
***********************************************************
*
*     Subroutine Mover
*
Mover andcc #^Carry clear carry
 leay 0,y zero byte count?
 beq MoveNone branch if so
 pshs U,Y,X,DP,D,CC save registers
 tfr Y,D copy byte count
 lsra divide by 2
 rorb
 tfr D,Y copy double byte count
 ldd 1,S get task numbers
 tfr B,DP copy destination task number
 lbra Mover00
MoveNone rts
 page
***********************************************************
*
*     Subroutine AllTsk
*
*   Process Task allocation service routine
*
AllTsk ldx R$X,u get process ptr
*
*     fall through to AllPrTsk
*
***********************************************************
*
*     Subroutine AllPrTsk
*
*   Allocate process task number
*
AllPrTsk ldb P$Task,x get process task number
 bne AllPrT10 branch if assigned
 bsr ResvTask get free DAT
 bcs AllPrXit branch if none
 stb P$Task,x set process task number
 bsr SetPrTsk set process task
AllPrT10 clrb clear carry
AllPrXit rts
 page
***********************************************************
*
*     Subroutine DelTsk
*
*   Deallocate Process Task service routine
*
DELTSK ldx R$X,u get process ptr
*
*     fall through to DelPrTsk
*
***********************************************************
*
*     Subroutine DelPrTsk
*
*   Deallocate Process Task number
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
SetTsk ldx R$X,U get process ptr
*
*     fall through to SetPrTsk
*
***********************************************************
*
*     Subroutine SetPrTsk
*
*   Set Process Task DAT registers
*
SetPrTsk lda P$State,X
 anda #^ImgChg
 sta P$State,X
 andcc #^Carry clear carry
 pshs U,Y,X,D,CC
 ldb P$Task,X
 leax P$DATImg,X
 ldy #DAT.ImSz/2
 ldu #DAT.Regs
 lbra SetDAT00 Copy DAT image to DAT registers

*****
* Reserve Task Number
* Output: B = Task number
RESTSK bsr ResvTask
 stb R$B,u Set task number
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
 ldb #E$NoTask
 bra ResTsk30
ResTsk20 inc b,x reserve task
 orb D.SysTsk
 clra
ResTsk30 puls PC,X

***********************************************************
*
*     Subroutine RelsTask
*
*   Release Task number
*
RelTsk ldb R$B,u get task number

RelsTask pshs x,b save registers
 ldb D.SysTsk get selected bits
 comb make mask
 andb 0,S clear selected bits
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
 ldd R$X,U get sleep time
 subd #1 count tick
 std R$X,U update time
 bne Slice branch if not expired
Tick.A ldu P$Queue,X get next queue ptr
 bsr ActvProc make process active
 leax 0,U copy next queue ptr
 beq Tick.B branch if none
 lda P$State,X get process state
 bita #TimSleep timed-sleep state
 beq Tick.B branch if not
 ldu P$SP,X get process stack ptr
 ldd R$X,U get sleep time
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
AProc ldx R$X,U get process ptr
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
ActvProc clrb
 pshs U,Y,X,CC
 lda P$Prior,X Get process priority/age
 sta P$AGE,X Set age to priority
 orcc #IRQMask+FIRQMask Set interrupt masks
 ldu #D.AProcQ-P$Queue Fake process ptr
 bra ActvPr30
ActvPr10 inc P$AGE,U
 bne ActvPr20 is not 0
 dec P$AGE,u too high
ActvPr20 cmpa P$AGE,U Who has bigger priority?
 bhi ActvPr40
ActvPr30 leay 0,U Copy ptr to this process
ActvPr40 ldu P$Queue,U Get ptr to next process
 bne ActvPr10
 ldd P$Queue,Y
 stx P$Queue,Y
 std P$Queue,X
 puls PC,U,Y,X,CC
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
 lbsr LDABX get condition codes
 ora #IntMasks set interrupt masks
 lbsr STABX update condition codes
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
UserRet orcc #IntMasks set interrupt masks
 ldx D.Proc get process ptr
 ldu P$SP,x get process stack ptr
 lda P$State,x get process state
 bita #TimOut time slice over?
 beq CurrProc branch if not
UsrRet.a anda #^TimOut clear time-out flag
 sta P$State,X update state
 lbsr DelPrTsk deallocate process task
GoActv bsr ActvProc put in active process queue
*
*    fall through to NextProc
*
***********************************************************
*
*     Subroutine NextProc
*
*   Start next process in Active Process Queue
*
* Input: none
*
* Output: does not return to caller
*
* Data: D.SysPrc, D.Proc, D.AProcQ
*
* Calls: SvcRet
*
NextProc ldx D.SysPrc get system process ptr
 stx D.Proc set current process
 lds D.SysStk move to system stack
 andcc #^IntMasks clear interrupt masks
 bra NextPr20
NextPr10 cwai #^IntMasks wait with clear masks
NextPr20 orcc #IntMasks set interrupt masks
 ldy #D.AProcQ-P$Queue get ptr proc queue
 bra NextPr40 enter search loop

NextPr30 leay 0,x move ptr
NextPr40 ldx P$Queue,Y get ptr to next proc
 beq NextPr10 branch if none
 lda P$State,X get process state
 bita #Suspend is it suspended?
 bne NextPr30 bra if so
 ldd P$Queue,X get remainder of queue
 std P$Queue,Y update queue ptr
 stx D.Proc set current process
 lbsr AllPrTsk allocate process task number
 bcs GoActv branch if none available
 lda D.TSlice get ticks/slice
 sta D.Slice reset slice tick count
 ldu P$SP,X get process stack ptr
 lda P$State,X get process state flags
 bmi SysRet branch if system state
CurrProc bita #Condem is process condemmed?
 bne KillProc branch if so
 lbsr ChkPrTsk update process task
 ldb P$Signal,X is signal waiting?
 beq CurrPr25 branch if not
 decb is it wake signal?
 beq CurrPr20 branch if so
 leas -R$Size,S get scratch
 leau 0,S get local stack
 lbsr GetRegs get current stack
 lda P$Signal,X get signal
 sta R$B,U pass to process
 ldd P$SigVec,X get intercept entry
 beq KillProc branch if none
 std R$PC,U get program counter
 ldd P$SigDat,X get data ptr
 std R$U,U
 ldd P$SP,X get process stack
 subd #R$Size make room for intercept
 std P$SP,X update stack ptr
 lbsr PutRegs copy new stack
 leas R$Size,S Reset stack
 ldu P$SP,X get process stack ptr
 clrb
CurrPr20 stb P$Signal,X clear signal code
CurrPr25 ldd D.UsrSvc get user service routine
 std D.XSWI2 get SWI2 vector
 ldd D.UsrIRQ get user interrupt routine
 std D.XIRQ set IRQ vector
 lbra SvcRet
KillProc lda P$State,x get process state
 ora #SysState set system state
 sta P$State,X update process
 leas P$Stack,X move stack
 andcc #^IntMasks clear interrupt masks
 ldb P$Signal,X get lethal signal code
 clr P$Signal,X clear signal
 OS9 F$EXIT terminate process
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
 ldb R$CC,S get condition codes
 orb #IntMasks set interrupt masks
 stb R$CC,S update masks
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
GoPoll jmp [D.Poll] call polling routine

***********************************************************
*
*     Subroutine IOPoll
*
IOPoll orcc #Carry set carry
 rts

***********************************************************
*
*     Routine DATInit
*
*   Initialize DAT for RAM in block zero and this
* ROM in block fifteen.   This code MUST reside in
* the upper 256 bytes of the ROM.
*
 ifeq CPUType-PAL1M92
 endc
 ifeq CPUType-DRG128
DATInit clra
 tfr a,dp set direct page
 ldx #DAT.Task point at task reg pia
 ifeq TEST
 lda 1,X am I the DMA processor
 lbne beDMAC ..no
 endc
 ldb #4
 stb 1,X access port A
 lda #$F0
 sta ,X select task 0 (system task)
 clra access DDRA
 sta 1,X Select data direction register
 lda #%11001111 Set direction: output=1, input=0
 sta 0,X
 lda #$FF
 sta 2,X
 lda #%00111110 select output register et al
 sta 1,X Set value in control register A
 stb 3,X Set value in control register B
 lda #%11011000
 sta 2,X
*
* Initialize all tasks in DAT registers
*
 ldy #DAT.Regs
 ldb #$F0
DATIn1 stb ,X
 clra
 sta 0,Y    assume RAM in block 0
 lda #$1F
 sta $06,Y Graphics at $6000
 lda #ROMBlock get ROM block number
 sta 14,y set ROM block
 lda #IOBlock get I/O Block number
 sta 15,y set I/O block
 incb next map
 bne DATIn1 ..until all done
 lda #$F0 set task 0
 sta ,X

* Initialise known on-board multi-purpose I/O
InitIO ldx #A.Mouse start with mouse pia
 lda #$7F  now enable DMA processor
 ldb #$04
 stb 1,X access port A
 sta ,X
 stb 3,X access PRB
 lda #$02
 sta 2,X
 clra
 sta 3,X access DDRB
 lda #$83
 sta 2,X
 stb 3,X
 lda #2
 sta 1,X access DDRA
 lda #$FF all outputs
 sta ,X - enables DMA processor HERE
 stb 1,X access PRA
 ldx #$FC22 A.P+2
 lda #$18
 sta 0,X
 stb 1,X
 ldx #A.Crtc address of 6845 CRTC ($FC80)
 clrb
 leay InitCrtc,pcr
DATINT20 lda ,y+
 stb 0,X
 sta 1,X
 incb
 cmpb #CRTCSIZ
 bcs DATINT20

 lda #%10110000 Turn on MMU by turning of bit 6
 sta DAT.Task
 ldx #$6000  Start of graphics memory
 ldd #$2008  Space + attribute
DATINT30 std ,X++
 cmpx #$7000
 bne DATINT30

* Put message on screen
 leay >LogMsg,pcr
 ldx #$6000+$3C0
DATINT40 lda ,Y+
 beq DATINTBT
 sta ,X++
 bra DATINT40
DATINTBT lbra COLD

InitCrtc fcb 55 Horizontal total (R0)
 fcb 40  Horizontal characters displayed (R1)
 fcb $2E Horizontal sync position
 fcb $35 Sync width
 fcb 30 Vertical total (R4)
 fcb 2 Vertical total adjust (R5)
 fcb 25 Vertical displayed (R6)
 fcb $1B Vertical sync (R7)
 fcb $50 Interlace mode (0) and skew (R8)
 fcb $09 Maximum scan line (R9)
 fcb $20 Cursor start line + blink (R10)
 fcb $09 Last scan line of cursor (R11)
 fcb $38 Start address register (R12)
 fcb $00 Start address register (R13)
 fcb $38 Cursor register (R14)
 fcb $00 Cursor register (R15)
CRTCSIZ equ *-InitCrtc

LogMsg fcc " OS-9 is loading - please wait ...."
 fcb 0
*
* DMA Processor routine
*
beDMAC lds #$FFFF   load stack, allow NMIs
 sync wait for it ..
DMACNMI lds #$FFFF get ready for action
 ldx D.DMPort get port address
 ldu D.DMMem memory address
 ldb D.DMDir DMA direction 1=Read Memory
 bne DMACRead ..read
* Copy from Port to Memory
* Breaks out of loop if interrupt is longer than 3 cycles
DMACWrit sync wait for FIRQ
 lda ,X get byte from port
 sta ,u+ put in memory
 bra DMACWrit ad nauseam

DMACRead lda ,u+ get byte from memory
 sync wait for FIRQ
 sta ,X put in port
 bra DMACRead
 endc

 ifeq CPUType-L2VIRT
*
* Virtual computer
*
DATInit clra
 tfr a,dp
 ldx #DAT.Task ($FCC0)
 lda #$F0 Set values in output register
 sta 0,X
*
* Initialize all tasks in DAT registers
*
 ldy #DAT.Regs
 ldb #$F0
DATIn1 stb 0,X
 clra
 sta 0,Y    RAM at $0000
 lda #ROMBlock
 sta $E,y   DAT.Regs+$E
 lda #IOBlock
 sta $F,y   DAT.Regs+$F
 incb
 bne DATIn1
 lda #%10110000 Turn on MMU by turning of bit 6
 sta DAT.Task
DATINTBT lbra COLD
*
* END Virtual computer
*
 endc

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
SvcRet ldb P$Task,x get task number
 orcc #IntMasks set interrupt masks
 ifeq DAT.Uniq
 jmp NOWHERE Code is not available
 endc
 stb DAT.Task Switch to task
 leas 0,u move stack ptr
 rti


PassSWI ldb P$Task,x get process task
 ifeq DAT.Uniq
 jmp NOWHERE Code is not available
 endc
 stb DAT.Task swith to task
 jmp 0,U go to user routine

**********
*
* Skip 768 byte I/O block
*
 emod
OS9End equ *


 ifeq CPUType-DRG128

**********
*
* Skip 768 byte I/O block
*
Target set *+768
 use filler
 opt -c
* Filler bytes included
 opt l
 opt c
*
 endc

 ifeq CPUType-L2VIRT
Target set $1000-$100
 use filler
 endc

LDABX andcc #^Carry clear carry
 pshs B,CC save registers
 orcc #IntMasks
 ifeq DAT.Uniq
 jmp NOWHERE Code is not available
 endc
 stb DAT.Task
 lda 0,X
 ifeq DAT.Uniq
 jmp NOWHERE Code is not available
 else
 ldb #SysTask
 endc
 stb DAT.Task
 puls PC,B,CC


STABX andcc #^Carry clear carry
 pshs B,CC
 orcc #IntMasks
 ifeq DAT.Uniq
 jmp NOWHERE Code is not available
 endc
 stb DAT.Task
 sta 0,X
 ifeq DAT.Uniq
 jmp NOWHERE Code is not available
 else
 ldb #SysTask
 endc
 stb DAT.Task
 puls PC,B,CC

LDBBX andcc #^Carry clear carry
 pshs a,cc
 orcc #IntMasks
 ifeq DAT.Uniq
 jmp NOWHERE Code is not available
 endc
 stb DAT.Task
 ldb 0,X
 ifeq DAT.Uniq
 jmp NOWHERE Code is not available
 else
 lda #SysTask
 endc
 sta DAT.Task
 puls PC,A,CC
 ifeq DAT.Uniq
 jmp NOWHERE Code is not available
 endc
 page
***********************************************************
*
*     Subroutines Mover00
*
*   Actual move routine (MUST be in upper 256 bytes)
*
Mover00 orcc #IntMasks
 ifeq DAT.Uniq
 jmp NOWHERE Code is not available
 endc
 bcc MoveRegs branch if no carry
 sta DAT.Task set source task
 lda ,X+
 stb DAT.Task
 sta ,U+
 leay 1,Y
 bra Mover30
Mover10 lda 1,S
 orcc #IntMasks set interrupt masks
MoveRegs sta DAT.Task
 ldd ,X++ get data double byte
 exg b,dp switch data & task
 stb DAT.Task
 exg b,dp switch back
 std ,U++
 ifeq DAT.Uniq
 jmp NOWHERE Code is not available
 else
Mover30 lda #SysTask
 endc
 sta DAT.Task
 lda 0,S
 tfr A,CC
 leay -1,Y
 bne Mover10
 puls PC,U,Y,X,DP,D,CC


SetDAT00 orcc #IntMasks set interrupt masks
 ifeq DAT.Uniq
 jmp NOWHERE Code is not available
 endc
SetDAT10 lda 1,X get DAT image
 leax 2,X move image ptr
 stb DAT.Task set task register
 sta ,u+ set block register
 ifeq DAT.Uniq
 jmp NOWHERE Code is not available
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

SWI3RQ orcc #IntMasks set interrupt masks
 ldb #D.SWI3 get direct page offset
 bra Switch

SWI2RQ orcc #IntMasks set interrupt masks
 ldb #D.SWI2 get direct page offset
 bra Switch

FIRQ ldb #D.FIRQ get direct page offset
 bra Switch

IRQ orcc #IntMasks set fast interrupt masks
 ldb #D.IRQ get direct page offset

Switch equ *
 ifeq DAT.Uniq
 jmp NOWHERE Code is not available
 else
 lda #SysTask
 endc
 sta DAT.Task
Switch10 clra
 tfr A,DP
 tfr D,X
 jmp [0,x]

SWIRQ ldb #D.SWI get direct page offset
 bra Switch

NMIRQ ldb #D.NMI get direct page offset
 bra Switch10
 page

 ifeq CPUType-PAL1M92
 endc
 ifeq CPUType-DRG128
target set $400+OS9End-$20
 use filler
 opt -c
* Filler bytes included
 opt l
 opt c
*
 endc
 ifeq CPUType-L2VIRT
Target set $1000-$20
 use filler
 endc

offset set $FFE0-*

***********************************************************
*
*     System Interrupt Psuedo-Vectors
*
HdlrVec fdb Tick+offset
 fdb UserSWI3+offset
 fdb UserSWI2+offset
 fdb offset
 fdb UserIRQ+offset
 fdb UserSWI+offset
 ifeq CPUType-DRG128
 fdb DMACNMI+offset
 fdb Cold+offset reboot entry vector = COLDStart
 else
 fdb offset
 fdb Cold+offset reboot entry vector = COLDStart
 endc


***********************************************************
*
*     System Interrupt Vectors
*
 fdb offset
 fdb SWI3RQ+offset
 fdb SWI2RQ+offset
 fdb FIRQ+offset
 fdb IRQ+offset
 fdb SWIRQ+offset
 fdb NMIRQ+offset
 fdb DATInit+offset

ROMEnd equ *

 end
