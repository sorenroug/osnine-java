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

Revs set REENT+8
 mod OS9End,OS9Nam,SYSTM,Revs,0,0

OS9Nam fcs /OS9p1/
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
 adda #2 Allocate 512 bytes for stack
 tfr d,s
 inca
 std D.SysStk
 std D.SysMem
 inca
 std D.ModDir
 std D.ModEnd
 adda #6
 std D.ModDir+2
 std D.ModDAT
 leax >IntXfr,pcr
 tfr x,d
 ldx #D.SWI3
Cold14 std ,x++
 cmpx #D.NMI
 bls Cold14
 leax ROMEnd,PCR get vector offset
 pshs X save it
 leay HdlrVec,PCR Get interrupt entries
 ldx #D.Clock
COLD08 ldd ,Y++ get vector
 addd 0,S add offset
 std ,X++ init dp vector
 cmpx #D.XNMI end of dp vectors?
 bls COLD08 branch if not
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
 stx D.POLL
 leay SvcTbl,PCR Get ptr to service routine table
 lbsr SETSVC Set service table entries
 ldu D.PrcDBT
 ldx D.SysPrc
 stx ,u
 stx 1,u
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
 jmp NOWHERE Code is not available
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
 ldd #ROMBlock get ROM block number
 std ,X++ set ROM block
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
 ldb 1,Y get DAT image
 stb DAT.Regs set block zero register
 lda 0,X get next byte
 clr DAT.Regs clear block zero register
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
Cold70 leax 1,X Try next location
Cold75 tfr X,D
 tstb
 bne Cold60
 bita #^DAT.Addr end of block?
 bne Cold60 ..no
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
ColdErr    jmp   [>$FFFE]

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

*****
*
*  Swi3 Handler
*
UserSWI3 ldx D.Proc
 ldu P$SWI3,X
 beq UserSvc No user-supplied interrupt handler
UsrSWI10 lbra PassSWI

UserSWI2 ldx D.Proc
 ldu P$SWI2,X
 beq UserSvc No user-supplied interrupt handler
 bra UsrSWI10

UserSWI ldx D.Proc
 ldu P$SWI,X
 bne UsrSWI10
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
UserSvc ldd D.SysSvc Get system request routine
 std D.XSWI2
 ldd D.SysIRQ Get system irq routine
 std D.XIRQ
 lda P$State,X
 ora #SysState
 sta P$State,X
 sts P$SP,X
 leas (P$Stack-R$Size),X
 leau 0,S
 bsr GetRegs
         ldb   >$FFA0
 andcc #^IntMasks
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
         anda  #$7F
         clrb
         pshs  u,x,cc
 ldx P$SP,X
 bra PutReg.A



************************************************************
*
*     Subroutine PutRegs
*
PutRegs ldb P$Task,X
         andb  #$7F
         clra
         pshs  u,x,cc
 ldx P$SP,X
 exg X,U
PutReg.A orcc #IntMasks
         sta   >$FFB8 Address to copy from
         stx   >$FFC0
         stu   >$FFC4
         ldx   #12
         stx   >$FFC2
         stx   >$FFC6
         stb   >$FFB9 Address to copy to
         ldb   #$03
         stb   >$FFBC
         nop
         puls  pc,u,x,cc

*****
*
*  Subroutine SYSREQ
*
* Service Routine Dispatch
*
* Process software interupts from system state
* Entry: U=Register stack pointer
SYSREQ leau 0,S Copy stack ptr
         ldb   >$FFA0
 lda R$CC,u
 tfr a,cc
 ldy D.SysDis Get system service routine table
 bsr Dispatch Call service routine
 lbra SysRet
 page
************************************************************
*
*     Subroutine Dispatch
*
Dispatch aslb SHIFT For two byte table entries
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
 bra SETSVC



************************************************************
*
*     Subroutine SetSvc
*
SetSvc10 clra
 aslb
 tfr d,u copy routine offset
 ldd ,Y++ Get table relative offset
 leax D,Y Get routine address
 ldd D.SysDis
 stx D,U Put in system routine table
 bcs SETSVC Branch if system only
 ldd D.UsrDis
 stx D,U Put in user routine table
SETSVC ldb ,Y+ Get next routine offset
 cmpb #$80 End of table code?
 bne SetSvc10 Branch if not
 rts
 page
***********************************************************
*
*     Subroutine SLink
*

* Input: A = Module type
*        X = Module string pointer
*        Y = Name string DAT image pointer
*
SLINK ldy R$Y,u
 bra SysLink

***********************************************************
*
*     Subroutine ELink
*
*   Link using already located Module Directory entry
*
* Input: B = Module type
*        X = Pointer to module directory entry
*
ELINK pshs  u
 ldb R$B,u
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
Link20 lbsr F.SETIMG
Link30 leax P$Links,X Point to memory block link counts
 sta 0,S Save block # on stack
 lsla
 leau A,X
 ldx 0,U Get link count for that block
 leax 1,X Increment
 beq LINK50
 stx 0,U Store new link count
LINK50 ldu 3,S
 ldx MD$Link,U
 leax 1,X
 beq LINK60
 stx MD$Link,U
LINK60 puls U,Y,X,B
 lbsr DATtoLog
 stx 8,U
 ldx MD$MPtr,Y
 ldy MD$MPDAT,Y
 ldd #M$EXEC Get execution offset
 lbsr LDDDXY
 addd R$U,U
 std R$Y,u Return it to user
 clrb
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



*****
*
*  Subroutine Crcgen
*
* Generate Crc
*
CRCGen ldd R$Y,u get byte count
 beq CRCGen20 branch if none
 ldx R$X,u get data ptr
 pshs x,d
 leas -3,s
 ldx D.Proc
 lda P$Task,x
 ldb D.SysTsk
 ldx R$U,u get crc ptr
 ldy #3
 leau 0,s
 pshs y,x,d
 lbsr Mover
 ldx D.Proc
 leay P$DATImg,x
 ldx 11,s
 lbsr AdjImg
CRCGen10 lbsr LDAXYP get next data byte
 lbsr CRCCAL update crc
 ldd 9,s
 subd #1 count byte
 std 9,s
 bne CRCGen10 branch if more
 puls y,x,d
 exg a,b
 exg x,u
 lbsr Mover
 leas 7,s
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

FModule ldu #0 Return zero if not found
 pshs u,d
 bsr SkipSpc Skip leading spaces
 cmpa #'/ Is there leading '/'
 beq FModul55
 lbsr PrsNam Parse name
 bcs FModul60 Branch if bad name
 ldu D.ModDir Get module directory ptr
 bra FModul53 Test if end is reached
FModul10 pshs y,x,d
 pshs y,x
 ldy 0,u Get module ptr
 beq FModul40 Branch if not used
 ldx M$NAME,U Get name offset
 pshs y,x
 ldd #M$NAME Get name offset
 lbsr LDDDXY
 leax d,x Get name ptr
 pshs y,x
 leax 8,s
 ldb 13,s
 leay 0,s
 lbsr ChkNam Compare names
 leas 4,s
 puls y,x
 leas 4,s
 bcs FModul50
 ldd #M$Type Get desired language
 lbsr LDDDXY
 sta 0,s
 stb 7,s
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
 eora ,s
 anda #LangMask
 bne FModul50 Branch if different
FModul30 puls Y,X,D Retrieve registers
 abx
 clrb
 ldb 1,S
 leas 4,S
 rts

FModul40 leas  4,S
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
FModul55 comb SET Carry
 ldb #E$BNam
FModul60 stb 1,S Save B on stack
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
 puls pc,y,a

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
 bsr PrsNam Call parse name
 std R$D,U Return byte & size
 bcs PNam.x branch if error
 stx R$X,U Return updated string ptr
 abx
PNam.x stx R$Y,U Return name end ptr
 rts

PrsNam pshs y
 lbsr AdjImg
 pshs y,X
 lbsr LDAXYP Get first char
 cmpa #'/ Slash?
 bne PRSNA1 ..no
 leas 4,S
 pshs y,X
 lbsr LDAXYP
PRSNA1 bsr Alpha 1st character must be alphabetic
 bcs PRSNA4 Branch if bad name
 clrb
PRSNA2 incb INCREMENT Character count
 tsta End of name (high bit set)?
 bmi PRSNA3 ..yes; quit
 lbsr LDAXYP
 bsr AlphaNum Alphanumeric?
 bcc PRSNA2 ..yes; count it
PRSNA3 andcc #^CARRY clear carry
 bra PrsNam70
PRSNA4 cmpa #', Comma (skip if so)?
 bne PRSNA6 ..no
PRSNA5 leas 4,S
 pshs Y,X
 lbsr LDAXYP
PRSNA6 cmpa #$20 Space?
 beq PRSNA5 ..yes; skip
 comb (NAME Not found)
 ldb #E$BNam 
PrsNam70 puls Y,X
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
 puls  pc,a

Alpha pshs a
 anda #$7F Strip high order bit
Alpha10 cmpa #'A
 blo NotAlpha
 cmpa #'Z Upper case alphabetic?
 bls IsAlpha ..yes
 cmpa #$61 Below lower case a?
 blo NotAlpha ..yes
 cmpa #$7A Lower case?
 bls IsAlpha ..yes
NotAlpha coma Set carry
 puls  pc,a
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
UCNam ldx D.Proc
 leay P$DATImg,X
 ldx R$X,U
 pshs  Y,X
 bra SCNam10

SCNam ldx D.Proc
 leay P$DATImg,X
 ldx R$X,u
 pshs y,x
 ldy D.SysDAT
SCNam10 ldx R$Y,u Get module name
 pshs Y,X
 ldd R$D,U
 leax 4,S
 leay 0,S
 bsr ChkNam
 leas 8,S
 rts

ChkNam pshs U,Y,X,D Save registers
 ldu 2,S
 pulu y,X
 lbsr AdjImg
 pshu y,X
 ldu 4,S
 pulu y,X
 lbsr AdjImg
 bra ChkNam15
ChkNam10 ldu 4,S
 pulu y,X
ChkNam15 lbsr LDAXYP
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
 beq ChkNam20 Branch if last character
 anda #$FF-$20 Match upper/lower case
 beq ChkNam10 ..yes; repeat
ChkNam20 comb Set carry
 puls PC,U,Y,X,D

CHKN20 decb
 bne ChkNam20 LAST Char of pathname?
 anda #$FF-$A0 Match upper/lower & high order bit
 bne ChkNam20 ..no; return carry set
 clrb
 puls  pc,u,Y,X,D

*****
*
*  Subroutine Srqmem
*
* System Memory Request
*
SRQMEM ldd R$D,U Get byte count
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
 bra SRqMem80
SRQM50 lda ,-y
 bne SRQM40
 decb
 bne SRQM45
 sty 0,S
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
 ldb R$A,U Get page count
SRqMem70 inc ,Y+ get page flag
 decb count page
 bne SRqMem70 branch if more
 lda 1,s get page number
 std R$U,u return it to user
 clrb clear carry
SRqMem80 leas 2,s return scratch
 rts
 page
*****
*
*  Subroutine Srtmem
*
* System Memory Return
*
SRTMEM ldd R$D,U Get byte count
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
 beq SRTM50
 ldu D.BlkMap
 lda d,U
 cmpa #RAMinUse
 bne SRTM50
 tfr X,D
 subd D.SysDAT
 lslb
 lslb
 lslb
 ldu D.SysMem
 leau d,U
 ldb #DAT.BlSz/256 get pages per block
SRTM40 lda ,U+
 bne SRTM50
 decb
 bne SRTM40
 ldd 0,X
 ldu D.BlkMap
 clr D,U
 ldd #DAT.Free
 std 0,X
SRTM50 leax 2,X
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
 bsr RAMBlk
 bcs AllRAM10
 std R$D,U
AllRAM10 rts

RAMBlk pshs Y,X,D
 ldx D.BlkMap
RAMBlk10 leay 0,X
 ldb 1,S
RAMBlk20 cmpx D.BlkMap+2
 bcc RAMBlk30
 lda ,x+
 bne RAMBlk10 Reset B counter
 decb
 bne RAMBlk20
 tfr Y,D
 subd D.BlkMap
 sta 0,S
 lda 1,S
 stb 1,S
RAMBlk25 inc ,y+
 deca
 bne RAMBlk25
 clrb
 puls PC,Y,X,D
 page
RAMBlk30 comb
 ldb #E$NoRam
 stb 1,S Save error code
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
FreeBlk clra
 ldb 2,S
 addb 0,S Add block increment (point to next block)
 stb 2,S
 cmpb 1,S
 bne FREBLK20
 ldb #E$MemFul
 stb 3,S Save error code
 comb set carry
 bra FreeBXit

FreeB10 tfr A,B
 addb  2,s Add to current start block #
FREBLK20 lslb Multiply block # by 2
 ldx B,Y Get DAT marker for that block
 cmpx #DAT.Free Empty block?
 bne FreeBlk ..No, move to next block
 inca
 cmpa 3,S
 bne FreeB10
FreeBXit leas 2,s Reset stack
 puls PC,X,D Restore reg, error code & return

*****
*
* Set Process DAT Image
* Copies DAT Image into the process descriptor
*
SETIMG ldd R$D,u Get beginning and number of blocks
 ldx R$X,u Process descriptor pointer
 ldu R$U,u New image pointer
F.SETIMG pshs U,Y,X,D
 leay P$DATImg,X
 lsla
 leay A,Y
SETIMG10 ldx ,u++
 stx ,y++
 decb
 bne SETIMG10
 ldx 2,S
 lda P$State,X
 ora #ImgChg
 sta P$State,X
 clrb
 puls PC,U,Y,X,D

*****
* Convert DAT block/offset to logical address
*
DATLOG ldb R$B,u  DAT image offset
 ldx R$X,u Block offset
 bsr DATtoLog
 stx R$X,u Return logical address
 clrb
 rts

* Convert offset into real address
* Input: B, X
* Effect: updated X
DATtoLog pshs X,D
 lslb
 lslb
 lslb
 lslb
 ifge DAT.BlSz-$2000
 lslb Divide by 32 for 8K blocks
 endc
 addb 2,S
 stb 2,S
 puls pc,X,D

*****
* Load A [X, [Y]]
* Returns one byte in the memory block specified by the DAT image in Y
* offset by X.
F.LDAXY ldx R$X,u Block offset
 ldy R$Y,u DAT image pointer
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
         leau  $01,s
         andb  #$7F
         clra
         exg   a,b
         exg   x,u
         bra   L0A98

* Store register A
STABX andcc #^CARRY clear carry
         pshs  u,x,b,a,cc
         leau  $01,s
         andb  #$7F
         clra
L0A98  orcc #IntMasks
         stu   >$FFC0
         stx   >$FFC4
         ldu   #$0001
         stu   >$FFC2
         stu   >$FFC6
         sta   >$FFB8 Address to copy from
         stb   >$FFB9 Address to copy to
         ldb   #$03
         stb   >$FFBC
         nop
         puls  pc,u,x,b,a,cc

****
* Move data (low bound first)
*
MOVE ldd R$D,u Source and destination task number
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
Mover andcc #^CARRY clear carry
         pshs  b,a,cc
         anda  #$7F
         andb  #$7F
 leay 0,y How many bytes to move?
 beq MoveNone ..branch if zero
 orcc #IntMasks
         stx   >$FFC0
         stu   >$FFC4
         sty   >$FFC2
         sty   >$FFC6
         sta   >$FFB8 Address to copy from
         stb   >$FFB9
         ldb   #$03
         stb   >$FFBC
         nop
MoveNone puls PC,B,A,CC
 page
***********************************************************
*
*     Subroutine AllTsk
*
ALLTSK ldx R$X,u Get process descriptor
*
*     fall through to AllPrTsk
*
***********************************************************
*
*     Subroutine AllPrTsk
*
AllPrTsk ldb P$Task,X
 bne ALLTSK10
 bsr ResvTask Reserve task number
 bcs AllPrXit
 stb P$Task,X
 bsr SetPrTsk Set process task registers
ALLTSK10 clrb
AllPrXit rts

*****
* Deallocate Process Task number
*
DELTSK ldx R$X,u  Get process descriptor
DelPrTsk ldb P$Task,X
 beq AllPrXit
 clr P$Task,X
 bra RelsTask

*
* Update process task registers if changed
*
ChkPrTsk lda P$State,X
 bita #ImgChg Did task image change?
 bne SetPrTsk Set process task registers
 rts

*****
*
* Set process Task DAT registers
*
SETTSK ldx R$X,U Process descriptor pointer
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
         andb  #$7F
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
RESTSK bsr ResvTask
 stb R$B,u Set task number
 rts

* Find free task and reserve it
ResvTask pshs x
 ldb #1
 ldx D.Tasks
RESTSK10 lda B,X
 beq RESTSK20
 incb
 cmpb #DAT.TkCt Last task slot?
 bne RESTSK10 ..yes
 comb
 ldb #E$NoTask
 bra RESTSK30
RESTSK20 inc b,x Mark occupied
 orb D.SysTsk
 clra
RESTSK30 puls PC,X

*****
* Release Task number
*
RELTSK ldb R$B,u Task number

RelsTask pshs x,b
 ldb D.SysTsk
 comb
 andb 0,S
 beq RELTSK20
 ldx D.Tasks
 clr B,X
RELTSK20 puls PC,x,b
 page
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
TICK ldx D.SProcQ Get sleeping queue ptr
 beq SLICE Branch if none
 lda P$State,X Get process status
 bita #TimSleep Is it in timed sleep?
 beq SLICE Branch if not
 ldu P$SP,X Get stack ptr
 ldd R$X,U Get tick count
 subd #1 Count down
 std R$X,U Update tick count
 bne SLICE Branch if ticks left
Tick.A ldu P$Queue,X Get next process ptr
 bsr ActvProc Activate process
 leax 0,U Copy process ptr
 beq Tick.B Branch if end of queue
 lda P$State,X Get process status
 bita #TimSleep In timed sleep?
 beq Tick.B Branch if not
 ldu P$SP,X Get stack ptr
 ldd R$X,U Get tick count
 beq Tick.A Branch if time
Tick.B stx D.SProcQ Update sleep queue ptr
*
* Update Time Slice counter
*
SLICE dec D.Slice Count tick
 bne Slic.a Branch if slice not over
 inc D.Slice
 ldx D.PROC Get current process ptr
 beq Slic.a Branch if none
 lda P$State,X Get status
 ora #TIMOUT Set time-out flag
 sta P$State,X Update process status
Slic.a clrb
 rts
 page
*****
*
*  Subroutine Actprc
*
* Put Process In Active Process Queue
*
APROC ldx R$X,U  Address of process descriptor
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
UserIRQ ldx D.Proc
 sts P$SP,x Save stack pointer of running process
 lds D.SysStk
 ldd D.SysSvc
 std D.XSWI2
 ldd D.SysIRQ
 std D.XIRQ
 jsr [D.SvcIRQ] Go to interrupt service
 bcc UserRet branch if service failed
 ldx D.Proc
 ldb P$Task,X
 ldx P$SP,X
 lbsr LDABX Get saved cc
 ora #IntMasks inhibit interrupts in process
 lbsr STABX Save CC
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
SysRet ldx D.SysPrc Get system process dsc. ptr
 lbsr ChkPrTsk
 leas 0,u Reset stack pointer
 rti


***********************************************************
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
         sta   >$FFBA
         ldy   #$F010  DAT.Regs+16
         lda   #$FF   IOBlock
         ldb   #$01
DATINT10    sta   ,-y
         decb
         bne   DATINT10
         ldb   #$0D
         lda   #$FF  ROMBlock or IOBlock
DATINT20    sta   ,-y
         decb
         bne   DATINT20
         ldb   #$01
DATINT30    stb   ,-y  Two blocks of ram
         decb
         bpl   DATINT30
         ldb   #$03
         stb   >$FFD4
         ldb   #$00
         stb   >$FFD1
         orb   #$01
         stb   >$FFD0
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
