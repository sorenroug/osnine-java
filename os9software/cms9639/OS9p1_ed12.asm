 nam OS-9 Level II kernal, part 1
 ttl System Type definitions

********************************
* Extracted from CMS 9639 ROM.

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
*               setup for os9p3 to use as vector for restart
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
LORAM set $20
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
 std D.Tasks+2
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
 tfr d,s set stack
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
 addd 0,s add offset
 std ,X++ set psuedo-vector
 cmpx #D.XNMI end of vectors?
 bls Cold15 branch if not
 leas 2,s return scratch
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
 stx 0,u set process zero page
 stx 1,u set process one page
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
     ldy #Dat.BlCt-ROMCount-RAMCount
 ldd #DAT.Free get free block code
Cold16 std ,X++ mark free entry
 leay -1,Y count block
 bne Cold16 branch if more
 ifle DAT.BlMx-255
     ldd #ROMBlock get ROM block number
     std ,X++ set ROM block
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
Cold20 equ *
 ifeq RAMCheck-BlockTyp
 pshs X
 ldd 0,S
 endc
 subd D.BlkMap
 cmpb #IOBlock   is this I/O block?
 beq Cold30 branch of so
 stb DAT.Regs+RAMCount set block register
 ldu 0,y Get current value
 ldx #$00FF Get bit pattern
 stx 0,Y Store it
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
 ifeq ROMCheck-Limited
 ldx D.BlkMap+2
 leax >-DAT.BlCt,x check uppermost 64K only
 endc
Cold50 lda 0,x is this RAM block?
 beq Cold80 branch if so
 tfr X,D copy block map ptr
 subd D.BlkMap get Block Number
         cmpd  #$00FF
         beq   Cold80
 leas -(DAT.BlCt*2),s reserve temp DAT area on stack
 leay 0,S move DATTmp ptr to Y
         lbsr  MovDAT
 pshs x save Block Map ptr
 ldx #0 make block offset
Cold55 equ *
Cold60 pshs Y,X save ptrs
 lbsr AdjImg adjust DAT image ptr
 ifle DAT.BLMx-255
 ldb 1,Y get DAT image
 stb DAT.Regs set block zero register
 lda 0,X get next byte
 clr DAT.Regs clear block zero register
 endc
 puls y,x retrieve ptrs
 cmpa #$87 could be module?
 bne Cold70 branch if not
Cold62 lbsr ValMod validate module
 bcc Cold65 branch if successful
 cmpb #E$KwnMod known module?
 bne Cold70 branch if not
Cold65 ldd #M$Size Get module size
 lbsr LDDDXY
 leax D,X Skip module
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
Cold80 leax 1,X
 cmpx D.BlkMap+2
 bcs Cold50
Cold.z1 leax InitName,pcr get name ptr
 bsr LinkSys link to "Init"
 bcc Cold.z2 branch if found
 ifne TEST
 jmp NOWHERE Code is not available
 endc
 os9 F$Boot call bootstrap
 bcc Cold.z1 branch if bootstrapped
 ifne TEST
 jmp NOWHERE Code is not available
 endc
 bra ColdErr
Cold.z2 stu D.Init
Cold.z3 leax P2Name,pcr
 bsr LinkSys
 bcc Cold.xit
 os9 F$Boot
 bcc Cold.z3
ColdErr    jmp   [$FFFE]

Cold.xit jmp 0,y go to "OS9p2"

LinkSys    clrb
L01B6    incb
         lda   ,x+
         bpl   L01B6
         negb
         leas  b,s
         negb
         tfr   s,y
         pshs  b
         exg   x,y
         decb
L01C6    lda   ,-y
         sta   b,x
         decb
         bpl   L01C6
 lda #SYSTM Get system type module
 os9 F$Link
         puls  a
         leas  a,s
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
MovDAT pshs y,x,d save regs
 ldb #DAT.BlCt get block count
 ldx 0,s get starting block number
MovDAT.B stx ,Y++ set DAT image
 leax 1,X mov ptr
 decb done?
 bne MovDAT.B bra if not
 puls PC,Y,X,D return

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
 fcb F$NProc+SysState
 fdb NextProc-*-2
 fcb F$VModul+SysState
 fdb VModule-*-2
 fcb F$SSvc
 fdb SSvc-*-2
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
 fdb SetImg-*-2
 fcb F$FreeLB+SysState
 fdb FreeLB-*-2
 fcb F$FreeHB+SysState
 fdb FreeHB-*-2
 fcb F$AllTsk+SysState
 fdb AllTsk-*-2
 fcb F$DelTsk+SysState
 fdb DelTsk-*-2
 fcb F$SetTsk+SysState
 fdb SetTsk-*-2
 fcb F$ResTsk+SysState
 fdb ResTsk-*-2
 fcb F$RelTsk+SysState
 fdb RelTsk-*-2
 fcb F$DATLog+SysState
 fdb DATLog-*-2
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

 leau 0,s get system stack ptr
 bsr GetRegs get user stack
     ldb   >Postbyte get service request code
     andcc #^IntMasks clear interrupt masks
 ldy D.UsrDis get user dispatch table ptr
 lbsr Dispatch dispatch to service routine
 ldb R$CC,u get user condition codes
 andb #^IntMasks clear interrupt masks
 stb R$CC,u update condition codes
 ldx D.Proc get process ptr
 bsr PutRegs return user stack
 lda P$State,X get process state flags
 anda #^SysState clear system state
 lbra UsrRet.a
 page
************************************************************
*
*     Subroutine GetRegs
*
*   Copy User interrupt register stack
*
* Input: X = Process Descriptor ptr
*        U = local stack ptr
*
* Output: none
*
* Data: none
*
* Calls: MoveRegs
*
GetRegs lda P$Task,X get process task
         anda  #^SysTask
         clrb
         pshs  u,x,cc
 ldx P$SP,X get process stack ptr
 bra PutReg.A



************************************************************
*
*     Subroutine PutRegs
*
*   Copy User interrupt register stack
*
* Input: X = Process Descriptor ptr
*        U = local stack ptr
*
* Output: none
*
* Data: none
*
* Calls: MoveRegs
*
PutRegs ldb P$Task,X get process task
         andb  #^SysTask
         clra
         pshs  u,x,cc
 ldx P$SP,X get process stack ptr
 exg X,u switch source & destination
PutReg.A equ *
         orcc #IntMasks
         sta   >Tsk.Src Task to copy from
         stx   >$FFC0 DMAC source address register
         stu   >$FFC4 DMAC destination address register
         ldx   #R$Size
         stx   >$FFC2 DMAC Source byte count register
         stx   >$FFC6 DMAC Destination byte count register
         stb   >Tsk.Dst Task to copy to
         ldb   #$03
         stb   >$FFBC send command
         nop
         puls  pc,u,x,cc
 page
************************************************************
*
*     System Service Request Routine
*
*   Process system service requests
*
* Input: S = value of stack after interrupt
*
* Output: none
*
* Data: D.SysDis, D.SysPrc
*
* Calls: Dispatch, SvcRet
*
SysSvc leau 0,s get registers ptr
 ifeq CPUType-CMS9639
 ldb Postbyte get service code
 lda R$CC,u get caller's interrupt masks
 tfr a,cc restore interrupt masks
 else
 lda R$CC,u get caller's interrupt masks
 tfr a,cc restore interrupt masks
 ldx R$PC,u get program counter
 ldb ,x+ get service code
 stx R$PC,u update program counter
 endc
 ldy D.SysDis get system dispatch table ptr
 bsr Dispatch dispatch to service routine
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
 stb R$B,u return error code
Dispat40 ldb R$CC,u get calling condition
 andb #%11010000 save masks & flag
 stb R$CC,u save them
 anda #%00101111 clear masks & flag
 ora R$CC,u add masks & flag
 sta R$CC,u update condition
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
SSvc ldy R$Y,u get table address
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
 tfr D,u save offset
 ldd ,Y++ get routine offset
 leax D,Y make routing ptr
 ldd D.SysDis get system dispatch table ptr
 stx D,u set routine entry
 bcs SetSvc branch if system only
 ldd D.UsrDis get user dispatch table ptr
 stx D,u set routine entry
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
SLink ldy R$Y,u get DAT image ptr
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
* Input: U = registers ptr
*        R$A,u = Module Type
*        R$X,u = Name String ptr
*
* Output: U unchanged
*        R$A,u = Module Type
*        R$B,u = Module Revision
*        R$X,u = updated Name String ptr
*        R$Y,u = Module Entry ptr
*        R$U,u = Module ptr
*      Carry clear if successful; set otherwise
*
* Data: D.Proc
*
* Calls: AdjImg, FModule, DATtoLog, LDDDXY, SrchPDAT,
*        FreeHBlk
*
LINK ldx D.Proc
 leay P$DATImg,x
SysLink pshs U Save register package
 ldx R$X,U Get name ptr
 lda R$A,u Get module type
 lbsr FModule
 lbcs LinkErr
 leay 0,U Make copy
 ldu 0,s Get register ptr
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
 ldy MD$MPDAT,x   Module DAT Image ptr
 ldd MD$MBSiz,x  Memory Block size
 addd  #DAT.BlSz-1
 tfr A,B
 lsrb
 lsrb
 ifge DAT.BlSz-2048
 lsrb
 ifge DAT.BlSz-4096
 lsrb
 endc
 endc
         pshs  b
 leau 0,Y copy group DAT image ptr
 bsr SrchPDAT Is it already linked in process space?
 bcc Link30 branch if yes
         lbsr  FreeHBlk
 bcc Link20
 leas 5,S Restore stack
 ldb #E$MemFul
 bra LinkErr
Link20 lbsr SetImage set process DAT image
 ifne DAT.WrPr
 ora #DAT.WrPr hypothesis
 endc
 ifne DAT.WrEn
 endc
Link30 leax P$Links,X get link count table ptr
 sta 0,s save block number
 asla make table offset
 leau A,X get link ptr
 ldx 0,u get link count
 leax 1,X count link
 beq Link40 branch if overflow
 stx 0,u update link count
Link40 ldu 3,s get entry ptr
 ldx MD$Link,u get link count
 leax 1,X count use
 beq Link50 branch if overflow
 stx MD$Link,u update link count
Link50 puls U,Y,X,B retrieve offset, entry, & registers
 lbsr DATtoLog convert to logical
 stx R$U,u return to user
 ldx MD$MPtr,Y get module ptr
 ldy MD$MPDAT,Y get DAT image ptr
 ldd #M$EXEC get module execution offset
 lbsr LDDDXY get module execution offset
 addd R$U,u make execution logical address
 std R$Y,u return to user
 clrb clear carry
 rts

LinkErr orcc #CARRY
 puls pc,u
 page
***********************************************************
*
*     Subroutine SrchPDAT
*
*
* Input: B = Number of blocks
*        U = Module DAT Image ptr
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
SrchDAT clra clear MSB count
 pshs Y,X,D save count & registers
 subb #DAT.BlCt get negative limit
 negb get true beginning limit
 aslb shift for two-byte entries
 leay B,Y move to first search location
SrchD10 ldx 0,s get count
 pshs U,Y save DAT image ptrs
SrchD20 ldd ,Y++ get search DAT block
 ifne DAT.WrPr+DAT.WrEn
 endc
 cmpd ,u++ does it match target?
 bne SrchD30 branch if not
 leax -1,X count block
 bne SrchD20 branch if more
 puls U,D retrieve DAT image ptrs
 subd 4,s get beginning block offset
 lsrb convert to local block number
 stb 0,s save it
 clrb clear carry
 puls PC,Y,X,D
SrchD30 puls U,Y retrieve DAT image ptrs
 leay -2,Y move one block lower
 cmpy 4,s end of DAT image?
 bcc SrchD10 branch if not
 puls PC,Y,X,D
 page
***********************************************************
*
*     Subroutine VModule
*
*   Module Validation Service routine
*
* Input: U = Registers ptr
*
* Output: Carry clear if successful; set if not
*
* Data: none
*
* Calls: ValMod
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
 lbsr ModCheck is it good module?
 bcs ValMoErr branch if not
 ldd #M$Type get module type offset
 lbsr LDDDXY get module type & revision
 andb #Revsmask get revision level
 pshs D save them
 ldd #M$Name get module name offset offset
 lbsr LDDDXY get module name offset
 leax D,X make name string ptr
 puls a retrieve module type
 lbsr FModule search module directory
 puls a retrieve new revision level
 bcs ValMod20 branch if not found
 pshs a save new revision level
 andb #Revsmask get old module revision
 subb ,s+ get old-new difference
 bcs ValMod20 branch if new is higher
 ldb #E$KwnMod err: known module
 bra ValMoErr
ValMoErA ldb #E$DirFul error: directory full
ValMoErr orcc #carry set carry
 puls PC,Y,X
ValMod20 ldx 0,S
 lbsr SetMoImg set DAT image for module
 bcs ValMoErA bra if error
 sty MD$MPDAT,u install new module
 stx MD$MPtr,u store block offset in dir
 clra
 clrb
 std MD$Link,u clear out link count
 ldd #M$Size get module size offset
 lbsr LDDDXY get module size
 pshs X copy module ptr
 addd ,s++ get module end address
 std MD$MBSiz,u set block size
 ldy [MD$MPDAT,u] get block number
 ldx D.ModDir get module directory ptr
 pshs U save ptr for check
 bra ValMod35 jif done
ValMod30 leax MD$ESize,X next entry
ValMod35 cmpx D.ModEnd chk for end of dir
 bcc ValMod55 jif done
 cmpx 0,s chk if entry is new one
 beq ValMod30 jif don't check
 cmpy [MD$MPDAT,X] module in this block?
 bne ValMod30 branch if not
 bsr FreDATI
ValMod55 puls U rid pos ptr
 ldx D.BlkMap get block map ptr
 ldd MD$MBSiz,u get block size
 addd #DAT.BlSz-1 round to next block
 lsra get block count
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 ldy MD$MPDAT,u get ptr to DAT img
ValMod60 pshs x,a save count, blkmap ptr
 ldd ,Y++ get blk number to mark
 leax D,X get map position
 ldb 0,X get status bits
 orb #ModBlock mark blk
 stb 0,X save status bits 
 puls X,A restore count,blkmap ptr
 deca next blk
 bne ValMod60 jif not done
 clrb clear carry
 puls PC,Y,X


* non-contiguous modules
FreDATI pshs U,Y,X,D save regs
 ldx MD$MPDAT,X get DAT image ptr
 pshs X save copy of ptr
 clra
 clrb
Fre.Lp ldy 0,X get blk number
 beq Fre.Out bra if end of DAT image
 std ,X++ mark entry free
 bra Fre.Lp back for more
Fre.Out puls x restore reg
 ldy 2,s get ptr to position
 ldu MD$MPDAT,u get new image ptr
 puls D get blk size
Fre.Lp2 cmpx MD$MPDAT,Y chk if same blk as new
 bne Fre.NoCh bra if not
 stu MD$MPDAT,Y make ptr to new dat image
 cmpd MD$MBSiz,y chk if size bigger
 bcc Fre.Not bra if so
 ldd MD$MBSiz,Y get old size
Fre.Not std MD$MBSiz,y  set new size
Fre.NoCh leay MD$ESize,Y next mdir entry
 cmpy D.ModEnd chk for end of dir
 bne Fre.Lp2 bra if not done
 puls PC,u,Y,X done


* non-contiguous modules
SetMoImg pshs U,Y,X save DAT image ptr, entry ptr
 ldd #M$Size get module size offset
 lbsr LDDDXY get module size
 addd 0,s get total blks so far
 addd #DAT.BlSz-1 round to next whole blk
 lsra make blk count
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 tfr A,B make proper register
 pshs B save count
 incb make bytes for mod DAT img
 lslb
 negb
 sex
 bsr chkspce check if space for expand
 bcc SetI.out jif ok
 os9 F$GCMDir garbage collect
 ldu #0 clear entry found
 stu 5,s
 bsr chkspce check again for space
SetI.out puls PC,u,Y,X,B done: return result

chkspce ldx D.ModDAT get DAT-top ptr
 leax D,X make ptr to new dat img
 cmpx D.ModEnd check if overrun
 bcs Chks.err jif no space
 ldu 7,s get entry ptr
 bne chksp1 jif don't check
 pshs X save for chk
 ldy D.ModEnd check if entry space
 leay MD$ESize,Y
 cmpy ,s++
 bhi Chks.err jif no space
 sty D.ModEnd set new modend
 leay -MD$ESize,Y make entry ptr
 sty 7,s return entry ptr
chksp1 stx D.ModDAT ser new moddat
 ldy 5,s get DAT image ptr
 ldb 2,s and blk count
 stx 5,s set new mod DAT image ptr
Chks.D ldu ,Y++ xfer DAT img to Mod dat img
 stu ,X++
 decb
 bne Chks.D jif more
 clr 0,X make end of Mod Dat img
 clr 1,X
 rts done

Chks.err orcc #CARRY show error
 rts done
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
ModChk20 sta 0,s save parity
 lbsr LDAXYP get next header byte
 eora 0,s accumulate it
 decb count byte
 bne ModChk20 branch if more
 leas 1,s return scratch
 inca good parity?
 beq ModChk30 branch if so
 ldb #E$BMHP err: bad module header parity
 bra ModChErr
ModChk30 puls Y,X retrieve module ptr
 ldd #M$Size get module size offset
 lbsr LDDDXY get module size 
 pshs Y,X,D save module size & ptr
 ldd #$FFFF init CRC accumulator
 pshs d
 pshs b
 lbsr AdjImg adjust DAT image ptr
 leau 0,s get CRC accumulator ptr
ModChk40 equ *
 tstb time for a break?
 bne ModChk45 branch if not
 pshs x save module ptr
 ldx #1
 os9 F$Sleep give up time slice
 puls x retrieve module ptr
ModChk45 lbsr LDAXYP get next module byte
 bsr CRCCal accumulate it
 ldd 3,s get module size
 subd #1 count byte
 std 3,s save count
 bne ModChk40 branch if more
 puls y,x,b retrieve CRC & scratch
 cmpb #CRCCon1 is first byte correct?
 bne ModChk50 branch if not
 cmpx #CRCCon23 are other bytes correct?
 beq ModChk60 branch if so
ModChk50 ldb #E$BMCRC err: bad module crc
ModChErr orcc #carry set carry
ModChk60 puls x,y,pc
 page
***********************************************************
*
*     Subroutine CRCCal
*
*   Calculate Next CRC Value
*
* Input: A = next data byte
*        U = CRC accumulator ptr
*
* Output: A = MSB CRC accumulator
*         B = LSB CRC accumulator
*
* Data: none
*
* Calls: none
*
CRCCal eora 0,u add CRC MSB
 pshs A save it
 ldd 1,u get CRC mid & low
 std 0,u shift to high & mid
 clra
 ldb 0,s get old high
 lslb shift d
 rola
 eora 1,u add old lsb
 std 1,u Set crc mid & low
 clrb
 lda 0,s get old MSB
 lsra shift d
 rorb
 lsra shift d
 rorb
 eora 1,u add new mid
 eorb 2,u add new low
 std 1,u set mid & low
 lda 0,s get old MSB
 lsla
 eora 0,s add old MSB
 sta 0,s
 lsla
 lsla
 eora 0,s add altered MSB
 sta 0,s
 lsla
 lsla
 lsla
 lsla
 eora ,s+ add altered MSB
 bpl CRCC99
 ldd #$8021
 eora 0,u
 sta 0,u
 eorb 2,u
 stb 2,u
CRCC99 rts


***********************************************************
*
*     Subroutine CRCGen
*
*   CRC Accumulation Service routine
*
* Input: U = Registers ptr
*
* Output: Carry clear if successful; set if not
*         D, X, Y, U destroyed
*
* Data: none
*
* Calls: Mover, AdjImg, LDAXYP, CRCCal
*
CRCGen ldd R$Y,u zero byte count?
 beq CRCGen20 branch if so
 ldx R$X,u get data ptr
 pshs X,D save count & ptr
 leas -3,s make accumulator scratch
 ldx D.Proc get process ptr
 lda P$Task,X get process task number
 ldb D.SysTsk get system task number
 ldx R$U,u get accumulator ptr
 ldy #3 get byte count
 leau 0,s get scratch ptr
 pshs Y,X,D save parameters
 lbsr Mover copy accumulator
 ldx D.Proc get process ptr
 leay P$DATImg,X get DAT image ptr
 ldx 11,s get data ptr
 lbsr AdjImg adjust DAT image ptr
CRCGen10 lbsr LDAXYP get data byte
 lbsr CRCCal accumulate it
 ldd 9,s get byte count
 subd #1 count it
 std 9,s update it
 bne CRCGen10 branch if more
 puls Y,X,D retrieve parameters
 exg A,B reverse tasks
 exg X,u reverse ptrs
 lbsr Mover copy accumulator
 leas 7,s return scratch
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
FMod pshs u save registers ptr
 lda R$A,u get module type
 ldx R$X,u get name string offset
 ldy R$Y,u get DAT image ptr
 bsr FModule search Module Directory
 puls y retrieve registers ptr
 std R$D,Y return type/revision
 stx R$X,Y return name string offset
 stu R$U,Y return directory entry ptr
 rts
 page
***********************************************************
*
*     Subroutine FModule
*
*   Search Module Directory
*
* Input: A = Module type
*        X = Name string block offset
*        Y = Name DAT Image ptr
*
* Output: A = Module type
*         B = Module revision
*         X = updated Name String ptr
*         U = Directory Entry ptr
*         Carry clear if found; set if not
*
* Data: D.ModDir, D.TmpDAT
*
* Calls: SkipsSpc, PrsNam, ChkNam, LDDDXY
*
FModule ldu #0 clear directory entry ptr
 pshs u,d save registers
 bsr SkipSpc skip leading spaces
 cmpa #'/ ss there "/" prefix?
 beq FModul55 branch if so
 lbsr PrsNam parse name
 bcs FModul60 branch if bad
 ldu D.ModDir get module directory ptr
 bra FModul53 enter loop
FModul10 pshs Y,X,D save name length & ptr
 pshs Y,X make DAT-Block address for PrsNam
 ldy MD$MPDAT,u get module DAT image ptr
 beq FModul40 branch if entry entry
 ldx MD$MPtr,u get module ptr
 pshs Y,X save module ptr
 ldd #M$NAME get module name offset offset
 lbsr LDDDXY get module name offset
 leax D,X get name string ptr
 pshs Y,X save name length & ptr
 leax 8,s get target DAT-block address ptr
 ldb 13,s get name size
 leay 0,s get module DAT-block address ptr
 lbsr ChkNam compare names
 leas 4,s return module name ptr
 puls Y,X retrieve module ptr
 leas 4,s return target name ptr
 bcs FModul50 branch if names differ
 ldd #M$Type get module type offset
 lbsr LDDDXY get module type & revision
 sta 0,s save module type
 stb 7,s return module revision
 lda 6,s get desired type/language
 beq FModul30 branch if any
 anda #TypeMask get type
 beq FModul20 branch if any
 eora 0,s get type difference
 anda #TypeMask clear language difference
 bne FModul50 branch if different
FModul20 lda 6,s get desired type/language
 anda #LangMask get desired language
 beq FModul30 branch if any
 eora 0,s get language difference
 anda #LangMask clear type difference
 bne FModul50 branch if different
FModul30 puls Y,X,D retrieve type & name ptr
 abx move string ptr
 clrb clear carry
 ldb 1,s retrieve register
 leas 4,s return scratch
 rts

FModul40 leas 4,s return scratch
 ldd 8,s free entry found?
 bne FModul50 branch if so
 stu 8,s save free entry ptr
FModul50 puls Y,X,D retrieve type & name ptr
 leau MD$ESize,u next directory entry
FModul53 cmpu D.ModEnd end of directory?
 bcs FModul10 branch if not
 comb set carry
 ldb #E$MNF err: module not found
 bra FModul60
FModul55 comb set carry
 ldb #E$BNam err: bad name
FModul60 stb 1,s save for return
 puls D,u,PC


***********************************************************
*
*     Subroutine SkipSpc
*
*   Skip spaces
*
* Input: X = Block offset
*        Y = DAT Image ptr
*
* Output: A = first non-blank character
*
* Data: none
*
* Calls: LDAXY, AdjImg
*
SkipSpc pshs y save initial DAT image ptr
SkipSp10 lbsr AdjImg adjust DAT image ptr
 lbsr LDAXY get character
 leax 1,x move ptr
 cmpa #'  is it space?
 beq SkipSp10 branch if so
 leax -1,x backup to character
 pshs a save character
 tfr Y,D copy DAT image ptr
 subd 1,s get logical block number
 asrb adjust for two-byte entries
 lbsr DATtoLog convert to logical ptr
 puls pc,y,a
 page
***********************************************************
*
*     Subroutine PNam
*
*   Parse Name Service routine
*
* Input: U = Registers ptr
*
* Output: Carry clear if successful; set if not
*
* Data: D.Proc
*
* Calls: AdjImg, PrsNam
*
PNam ldx D.Proc get process ptr
 leay P$DATImg,X get DAT image ptr
 ldx R$X,u get name string ptr
 bsr PrsNam parse name
 std R$D,u return delimiter; byte count
 bcs PNam10 branch if error
 stx R$X,u return ptr
 abx get end of name ptr
PNam10 stx R$Y,u return end ptr
 rts
 page
***********************************************************
*
*     Subroutine PrsNam
*
*   Parse OS-9 type name
*
* Input: B = Block number
*        X = Block offset
*        Y = DAT Image ptr
*
* Output: A = Delimiter char
*         B = Name size (byte count)
*         X,Y updated past "/" prefix
*
* Data: none
*
* Calls: LDAXY, AdjImg, Alpha, AlphaNum
*
PrsNam pshs y save initial DAT image ptr
 lbsr AdjImg adjust DAT image ptr
 pshs Y,X save ptr
 lbsr LDAXYP get next byte
 cmpa #'/ is it "/" prefix
 bne PrsNam10 branch if not
 leas 4,s unsave ptr
 pshs Y,X save string ptr
 lbsr LDAXYP get next byte
PrsNam10 bsr Alpha is it alphabetic?
 bcs PrsNam40 branch if not
 clrb clear byte count
PrsNam20 incb count byte
 tsta is this last byte?
 bmi PrsNam30 branch if so
 lbsr LDAXYP get next byte
 bsr AlphaNum is it alphanumeric?
 bcc PrsNam20 branch if so
PrsNam30 andcc #$ff-carry clear carry
 bra PrsNam70
PrsNam40 cmpa #', is it comma?
 bne PrsNam60 branch if not
PrsNam50 leas 4,s pitch last ptr
 pshs Y,X save string ptr
 lbsr LDAXYP get next byte
PrsNam60 cmpa #$20 is there a space?
 beq PrsNam50 branch if so
 comb set carry
 ldb #E$BNam err: bad name
PrsNam70 puls Y,X retrieve string ptr
 pshs d,cc save registers
 tfr Y,D copy DAT image ptr
 subd 3,s get image offset
 asrb get block number
 lbsr DATtoLog convert to logical address
 puls PC,Y,D,CC
 page
***********************************************************
*
*     Subroutine AlphaNum
*
*   Determine if byte is alphanumeric
*
* Input: A = Byte
*
* Output: carry set if not alphanumeric
*
* Data: none
*
* Calls: Alpha
*
AlphaNum pshs a save byte
 anda #^Sign clear sign bit
 cmpa #'. is it period?
 beq IsAlpha branch if so
 cmpa #'0 BELOW ZERO?
 blo NotAlpha branch if so
 cmpa #'9 NUMERIC?
 bls IsAlpha branch if so
 cmpa #'_ UNDERSCORE?
 bne Alpha10 branch if not
IsAlpha clra clear carry
 puls PC,a



***********************************************************
*
*     Subroutine Alpha
*
*   Determine if byte is alphabetic
*
* Input: A = Byte
*
* Output: carry set if not alphabetic
*
* Data: none
*
* Calls: none
*
Alpha pshs a save byte
 anda #^Sign clear sign bit
Alpha10 cmpa #'A below alphabet?
 blo NotAlpha branch if so
 cmpa #'Z upper case alphabetic?
 bls IsAlpha branch if so
 cmpa #'a below alphabet?
 blo NotAlpha branch if so
 cmpa #'z lower case alphabetic?
 bls IsAlpha branch if so
NotAlpha coma set carry
 puls PC,a
 page
***********************************************************
*
*     Subroutine CNam
*
*   Compare Names Service routine
*
* Input: U = Registers ptr
*
* Output: Carry clear if same; set if not
*
* Data: D.Proc
*
* Calls: AdjImg, ChkNam
*
UCNam ldx D.Proc get process ptr
 leay P$DATImg,X get DAT image ptr
 ldx R$X,u get target ptr
 pshs Y,X save DAT image
 bra SCNam10


SCNam ldx D.Proc get current process ptr
 leay P$DATImg,X get DAT image ptr
 ldx R$X,u get target string ptr
 pshs Y,X save them
 ldy D.SysDAT get system DAT ptr
SCNam10 ldx R$Y,u get module name ptr
 pshs Y,X save them
 ldd R$D,u get target name length
 leax 4,s get target name ptr
 leay 0,s get module name ptr
 bsr ChkNam compare names
 leas 8,s return scratch
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
 ldu 2,s get target ptr ptr
 pulu Y,X get target ptr
 lbsr AdjImg adjust DAT image ptr
 pshu Y,X save them
 ldu 4,s get module ptr ptr
 pulu Y,X get module ptr
 lbsr AdjImg adjust DAT image ptr
 bra ChkNam15
ChkNam10 ldu 4,s get module ptr
 pulu Y,X get module ptr
ChkNam15 lbsr LDAXYP get next byte
 pshu Y,X save module ptr
 pshs a save module byte
 ldu 3,s get target ptr
 pulu Y,X get target ptr
 lbsr LDAXYP get next byte
 pshu Y,X save target ptr
 eora 0,s get module-target difference
 tst ,s+ is this last module?
 bmi ChkNam30 branch if not
 decb is this last target?
 beq ChkNam20 branch if so
 anda #^('a-'A) clear case difference
 beq ChkNam10 ..yes; repeat
ChkNam20 comb Set carry
 puls PC,u,Y,X,D
ChkNam30 decb is this last target?
 bne ChkNam20 branch if not
 anda #^(Sign+'a-'A) clear case & sign difference
 bne ChkNam20 branch if different
 clrb clear carry
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
 addd #$FF round up to page
 clrb
 std R$D,u return size to user
 ldy D.SysMem get system memory map ptr
 leas -2,s get scratch
 stb 0,s set DAT image offset
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
SRqMem40 inc 0,s count block
 ldb 0,s get DAT image offset
 cmpb #DAT.BlCt checked all blocks?
 bcs SRqMem10 branch if not
SRqMem50 ldb R$D,u get page count
SRqMem55 cmpy D.SysMem beginning of map?
 bhi SRqMem60 branch if not
 comb set carry
 ldb #E$MemFul err: memory full
 bra SRqMem80
SRqMem60 lda ,-y get page flag
 bne SRqMem50 branch if not free
 decb countr free page
 bne SRqMem55 branch if not enough
 sty 0,s same map ptr
 lda 1,s get page number
 lsra get block number
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 ldb 1,s get page number
 andb #^DAT.Addr get page within block
 addb R$D,u add number of pages
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
 ldb R$A,u get page count
SRqMem70 inc ,Y+ get page flag
 decb count page
 bne SRqMem70 branch if more
 lda 1,s get page number
 std R$U,u return it to user
 clrb clear carry
SRqMem80 leas 2,s return scratch
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
SRtMem ldd R$D,u get byte count
 beq SrTM.F  branch if none
 addd #$FF round up to page
 ldb R$U+1,u is address good?
 beq SRtM.A branch if so
 comb set carry
 ldb #E$BPAddr err: bad page address
 rts
SRtM.A ldb R$U,u get page number
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
 lda d,u get block flags
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
 leau d,u get block pages ptr
 ldb #DAT.BlSz/256 get pages per block
SRtM.D lda ,u+ get page flags
 bne SRtM.E branch if not free
 decb count page
 bne SRtM.D branch if more pages
 ldd 0,X get block number
 ldu D.BlkMap get block map ptr
 ifne DAT.WrPr+DAT.WrEn
 endc
 clr D,u mark block free
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
         ldx   #$F000
         ldd   M$EXEC,x
         jsr   d,x
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
***********************************************************
*
*     Subroutine RAMBlk
*
*   Search Memory Block Map for contiguous free RAM blocks
*
* Input: B = block count
*
* Output: D = block number
*
* Data: D.BlkMap
*
* Calls: none
*
AllRAM ldb R$B,u get block count
 bsr RAMBlk allocate blocks
 bcs AllRAM10 branch if failed
 std R$D,u get block number
AllRAM10 rts

RAMBlk pshs Y,X,D save registers
 ldx D.BlkMap get Block Map ptr
RAMBlk10 leay 0,X copy map ptr
 ldb 1,s get block count
RAMBlk20 cmpx D.BlkMap+2 end of map?
 bcc RAMBlk30 branch if so
 lda ,x+ free block?
 bne RAMBlk10 branch if not
 decb found enough?
 bne RAMBlk20 branch if not
 tfr Y,D copy beginning block ptr
 subd D.BlkMap get block number
 sta 0,s return block number
 lda 1,s get block count
 stb 1,s return block number
RAMBlk25 inc ,y+ update flags
 deca done?
 bne RAMBlk25 branch if not
 clrb clear carry
 puls PC,Y,X,D
 page
RAMBlk30 comb set carry
 ldb #E$NoRam err: no RAM
 stb 1,s
 puls PC,Y,X,D

***********************************************************
*
*     Subroutine AllImg
*
*   Allocate RAM blocks for DAT image
*
* Input: U = registers ptr
*
* Output: Carry clear if successful; set otherwise
*
* Data: none
*
* Calls: AllImage
*
AllImg ldd R$D,u  get block number & count
 ldx R$X,u get process ptr
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
AllImage pshs u,Y,X,D save registers
 asla shift for two-byte entries
 leay P$DATImg,X get process DAT image ptr
 leay A,Y get block image ptr
 clra
 tfr D,X copy block count
 ldu D.BlkMap get block map ptr
 pshs U,Y,X,D save registers
AllI.A ldd ,Y++ get current image
 cmpd #DAT.Free is block allocated?
 beq AllI.B branch if not
 ifne DAT.WrPr+DAT.WrEn
 endc
 lda D,u get block flags
 cmpa #RAMinUse is it just RAM in use?
 puls D get new block needed
 bne AllImErr branch if not RAM
 subd #1 uncount allocated block
 pshs D save it
AllI.B leax -1,X enough blocks?
 bne AllI.A branch if not
 ldx ,s++ get new blocks needed
 beq AllI.E branch if none
AllI.C lda ,u+ get block flags
 bne AllI.D branch if not free
 leax -1,X count free block
 beq AllI.E branch if enough
AllI.D cmpu D.BlkMap+2 end of map?
 bcs AllI.C branch if not
AllImErr ldb #E$MemFul err: memory full
 leas 6,s return scratch
 stb 1,s save error code
 comb set carry
 puls PC,u,Y,X,D
AllI.E puls U,Y,X
AllI.F ldd ,Y++
 cmpd #DAT.Free
 bne AllI.H
AllI.G equ *
 lda ,U+
 bne AllI.G
 inc ,-U
 tfr U,D
 subd D.BlkMap
 std -2,Y
AllI.H leax -1,x count block
 bne AllI.F branch if more
 ldx 2,s get process descriptor ptr
 lda P$State,X
 ora #ImgChg
 sta P$State,X
 clrb
 puls PC,u,Y,X,D
 page
***********************************************************
*
*     Subroutine FreeHB
*
*   Free High Block Service routine
*
* Input: U = registers ptr
*
* Output: Carry clear if successful; set otherwise
*
* Data: none
*
* Calls: FreeHBlk
*
FreeHB ldb R$B,u get block count
 ldy R$Y,u DAT image pointer
 bsr FreeHBlk Go find free blocks in high part of DAT
 bcs FrHB10
 sta R$A,u return beginning block number
FrHB10 rts


***********************************************************
*
*     Subroutine FreeHBlk
*
*   Search DAT image for highest free block
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
FreeHBlk tfr b,a copy block count
FreeHB10 suba #DAT.BlCt+1 get negative beginning
 nega make it positive
 pshs X,D save beginning, count & register
 ldd #-1 set next-try & limit
 pshs D save them
 bra FreeBlk
 page
***********************************************************
*
*     Subroutine FreeLB
*
*   Free Low Block Service routine
*
* Input: U = registers ptr
*
* Output: Carry clear if successful; set otherwise
*
* Data: none
*
* Calls: FreeLBlk
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
F.LDAXY ldx R$X,u get block offset
 ldy R$Y,u DAT get DAT image ptr
 bsr LDAXY
 sta R$A,u return byte
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
*   Adjust offset to within block range
*
* Input: X = Block offset
*        Y = DAT Image ptr
*
* Output: X,Y updated
*
* Data: none
*
* Calls: none
*
AdjImg10 leax -DAT.BlSz,x reduce offset
 leay 2,y move image ptr
AdjImg cmpx #DAT.BlSz is offset in block range?
 bcc AdjImg10 branch if not
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
F.LDABX ldb R$B,u get task number
 ldx R$X,u get data ptr
 lbsr LDABX call routine
 sta R$A,u return data
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
F.STABX ldd R$D,u get data & task number
 ldx R$X,u get data ptr
 lbra STABX
 page

* Get byte at 0,X in task B
* Returns value in A
LDABX andcc #^CARRY clear carry
         pshs  u,x,b,a,cc
         leau 1,s
         andb  #^SysTask
         clra
         exg   a,b
         exg   x,u
         bra   L0A98

* Store register A
STABX andcc #^CARRY clear carry
         pshs  u,x,b,a,cc
         leau  $01,s
         andb  #^SysTask
         clra
L0A98  orcc #IntMasks
         stu   >$FFC0 DMAC source address register
         stx   >$FFC4 DMAC destination address register
         ldu   #1
         stu   >$FFC2 DMAC Source byte count register
         stu   >$FFC6 DMAC Destination byte count register
         sta   >$FFB8 Address to copy from
         stb   >$FFB9 Address to copy to
         ldb   #$03
         stb   >$FFBC
         nop
         puls  pc,u,x,b,a,cc
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
Mover andcc #^CARRY clear carry
         pshs  b,a,cc
         anda  #^SysTask
         andb  #^SysTask
 leay 0,y How many bytes to move?
 beq MoveNone ..branch if zero
 orcc #IntMasks
         stx   >$FFC0 DMAC source address register
         stu   >$FFC4 DMAC destination address register
         sty   >$FFC2 DMAC Source byte count register
         sty   >$FFC6 DMAC Destination byte count register
         sta   >$FFB8 Address to copy from
         stb   >$FFB9 Address to copy to
         ldb   #$03
         stb   >$FFBC
         nop
MoveNone puls PC,B,A,CC
 page
***********************************************************
*
*     Subroutine AllTsk
*
*   Process Task allocation service routine
*
* Input: U = registers ptr
*        R$X,y = Process ptr
*
* Output: Carry clear if successful; set otherwise
*
* Data: none
*
* Calls: AllPrTsk
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
* Input: X = Process ptr
*
* Output: carry clear if successful; set otherwise
*
* Data: none
*
* Calls: ResvTask, SetPrTsk
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
 pshs Y,X,D,CC
 ldb P$Task,X
         andb  #^SysTask
         clra
         lslb
         rola
         lslb
         rola
         lslb
         rola
         lslb
         rola
 leax P$DATImg,X
 orcc #IntMasks
 ldy #DAT.Regs
         leay  d,y
         ldb   #DAT.ImSz/2
L0B31    lda   ,x+
         cmpa  #$80   Unassigned block?
         beq   L0B3B
         lda   ,x+
         bra   L0B3F
L0B3B    lda   #$FF
         leax  1,x
L0B3F    sta   ,y+
         decb
         bne   L0B31
         puls  PC,Y,X,D,CC

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
*             lbsr DelPrTsk
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
 bra NextPr40
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
 leas -R$Size,s get scratch
 leau 0,s get local stack
 lbsr GetRegs get current stack
 lda P$Signal,X get signal
 sta R$B,u pass to process
 ldd P$SigVec,X get intercept entry
 beq KillProc branch if none
 std R$PC,u get program counter
 ldd P$SigDat,X get data ptr
 std R$U,u
 ldd P$SP,X get process stack
 subd #R$Size make room for intercept
 std P$SP,X update stack ptr
 lbsr PutRegs copy new stack
 leas R$Size,s Reset stack
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
 OS9 F$Exit terminate process
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
DATInit clra
 tfr a,dp
         sta   >Tsk.Syst
         ldy   #DAT.Regs+16
         lda   #ROMBlock
         ldb   #ROMCount
DATINT10    sta   ,-y
         decb
         bne   DATINT10
         ldb   #Dat.BlCt-ROMCount-RAMCount
         lda   #$FF  ROMBlock or IOBlock
DATINT20    sta   ,-y
         decb
         bne   DATINT20
         ldb #RAMCount-1
DATINT30 stb ,-y  Two blocks of ram
         decb
         bpl   DATINT30
         ldb   #$03
         stb   >DMAC.Pri
         ldb   #$00
         stb   >DMAC.Dst
         orb   #$01
         stb   >DMAC.Src
         lbra  COLD

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
 stb DAT.Task switch to task
 leas 0,u move stack ptr
         ldb   #$04
         stb   >$FFBC
         rti

PassSWI    leas  -$0C,s
         sts   P$SP,x
         leas  (P$Stack-R$Size),X
         ldb   #$80
         stb   ,s
         stu   $0A,s
         tfr   s,u
         lbsr  PutRegs
         lds   P$SP,x
 ldb P$Task,x Get task number from process
 stb DAT.Task
         ldb   #$04
         stb   >$FFBC
         rti

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
 clr   >$FFBC  Switch to system task
 clra
 tfr a,dp clear direct page register
 tfr d,x copy direct page ptr
 jmp [0,x] go through vector

SWIRQ ldb #D.SWI get direct page offset
 bra Switch

NMIRQ ldb #D.NMI
 bra Switch

 emod
OS9End equ *

Target set $0DF0-$20
 use filler

offset set $FFE0-*

HdlrVec fdb Tick+offset
 fdb UserSWI3+offset
 fdb UserSWI2+offset
 fdb offset
 fdb UserIRQ+offset
 fdb UserSWI+offset
 fdb offset
 fdb offset


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
