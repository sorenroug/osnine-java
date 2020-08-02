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
* Edition   3 - changes in timing of process state flag switching
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
LoRAM set $20        set low RAM limit
HiRAM set DAT.Blsz*RAMCount

TEST set 0      not test mode
COLD ldx #LoRAM get low limit ptr
 ldy #HiRAM-LoRAM get byte count
 clra clear d
 clrb
COLD05 std ,X++ Clear system memory block
 leay -2,Y Count down
 bne COLD05
 inca ONE Page for direct page
 std D.Tasks     Start at $100
 addb #DAT.TkCt Number of task maps
 std D.TmpDAT
 clrb
 inca
 std D.BlkMap    Base address for block map
 adda #DAT.BMSz/256
 std D.BlkMap+2
 std D.SysDis   Base address for System Service Dispatch Table
 inca
 std D.UsrDis
 inca Allocate 256 bytes for User Service Dispatch Table
 std D.PrcDBT
 inca
 std D.SysPrc
 std D.Proc
 adda #P$Size/256 allocate system process ptr
 tfr D,S
 inca Allocate 256 bytes for System Stack
 std D.SysStk    Start at $900
 std D.SysMem
 inca
 std D.ModDir    Start at $A00
 std D.ModEnd
 adda #6      allocate directory and module DAT Image are
 std D.ModDir+2
 std D.ModDAT    Start at $1000
 leax IntXfr,pcr
 tfr X,D
 ldx #D.SWI3
Cold14 std ,X++
 cmpx #D.NMI
 bls Cold14
 leax ROMEnd,PCR get entry offset
 pshs X save it
 leay HdlrVec,PCR Get interrupt entries
 ldx #D.Clock
COLD08 ldd ,Y++ get vector
 addd 0,S add offset
 std ,X++ init dp vector
 cmpx #D.XNMI end of vectors?
 bls COLD08 branch if not
 leas 2,S return scratch
 ldx D.XSWI2
 stx D.UsrSvc
 ldx D.XIRQ
 stx D.UsrIRQ
 leax SysSvc,PCR Get system service routine
 stx D.SysSVC
 stx D.XSWI2 Set service to system state
 leax SysIRQ,PCR Get system interrupt routine
 stx D.SysIRQ
 stx D.XIRQ
 leax GoPoll,pcr
 stx D.SvcIRQ Set interrupts to system state
 leax IOPoll,PCR Set irq polling routine
 stx D.POLL
*
* Initialize Service Routine Dispatch Table
*
 leay SVCTBL,PCR Get ptr to service routine table
 lbsr SetSvc Set service table entries
 ldu D.PrcDBT Get Process Descriptor Block Table
 ldx D.SysPrc
 stx 0,U
 stx 1,U
 lda #1   Process id 1
 sta P$ID,X
 lda #SysState
 sta P$State,X
 lda #SysTask
 sta D.SysTsk
 sta P$Task,X
 lda #255
 sta P$Prior,X
 sta P$Age,X
 leax P$DATImg,X
 stx D.SysDAT

 ifeq CPUType-DRG128
 lda #$D8
 sta D.GRReg  Graphics control port
 endc
*
* Set up memory blocks in system DAT image
*
 clra
 clrb
 std ,X++ Mark block 0 in SysDAT
 ldy #Dat.BlCt-ROMCount-RAMCount-1
 ldd #DAT.Free  Initialize the rest of the blocks to be free
Cold16 std ,X++
 leay -1,Y
 bne Cold16
 ldb #ROMBlock Mark ROM block at $E000
 std ,X++
 ldd #IOBlock Mark IO block at $F000
 std ,X++
 ldx D.Tasks
 inc 0,X  Reserve task 0
 ldx D.SysMem
 ldb D.ModDir+2
Cold17 inc ,X+
 decb
 bne Cold17
*
* Map every physical block into block 1 to see if there is RAM
*
 ldy #DAT.BlSz*RAMCount get unused block ptr
 ldx D.BlkMap
Cold20 pshs X
 ldd 0,S
 subd D.BlkMap
 cmpb #IOBlock   is this I/O block?
 beq COLD25 ..yes
 stb DAT.Regs+RAMCount Map block above allocated RAM
 ldu 0,y get current contents
 ldx #$00FF Get bit pattern
 stx 0,Y Store it
 cmpx 0,Y Is it there?
 bne COLD25 If not, end of ram
 ldx #$FF00 Try a different pattern
 stx 0,Y Store it
 cmpx 0,Y Did it take?
 bne COLD25 If not, eor
 stu 0,y Replace current value
 bra COLD30

COLD25 ldb #NotRAM
 stb [0,s]
COLD30 puls X
 leax 1,X
 cmpx D.BlkMap+2
 bcs Cold20
 ldx D.BlkMap
 inc 0,X
 ldx D.BlkMap+2
 leax >-DAT.BlCt,X  There are 16 pages in a block
COLD35 lda 0,X
 beq COLD60
 tfr X,D
 subd D.BlkMap
 leas -(DAT.BlCt*2),s
 leay 0,S
 bsr MovDAT
*
* Scan ROM blocks for modules
*
 pshs X
 ldx #0
COLD40 pshs Y,X
 lbsr AdjImg jump to next block?
 ldb 1,Y
 stb DAT.Regs
 lda 0,X
 clr DAT.Regs
 puls Y,X
 cmpa #$87
 bne COLD50
 lbsr VALMOD
 bcc COLD45
 cmpb #E$KwnMod Is it a known module
 bne COLD50
COLD45 ldd #M$Size Get module size
 lbsr LDDDXY
 leax D,X Skip module
 bra COLD55
COLD50 leax 1,X Try next location
COLD55 tfr X,D
 tstb
 bne COLD40
 bita #$0F   at $0F00?
 bne COLD40 ..no
 lsra Calculate block number
 lsra
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 deca
 puls X
 leax A,X
 leas 32,S Make space on stack
COLD60 leax 1,X
 cmpx D.BlkMap+2
 bcs COLD35

Cold.z1 leax InitName,pcr Get initial module name ptr
 bsr LinkSys Link to configuration module
 bcc Cold.z2
 os9 F$Boot
 bcc Cold.z1
 bra ColdErr

Cold.z2 stu D.Init
Cold.z3 leax P2Name,pcr
 bsr LinkSys
 bcc Cold.xit
 os9 F$Boot
 bcc Cold.z3
ColdErr jmp [D$REBOOT]

Cold.xit jmp 0,Y Let os9 part two finish

LinkSys lda #SYSTM Get system type module
 os9 F$Link
 rts

* Copies value on stack to all positions in block
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
*****
*
* System Service Routine Table
*
SVCTBL equ *
 fcb F$Link
 fdb Link-*-2
 fcb F$PRSNAM
 fdb PNAM-*-2
 fcb F$CmpNam
 fdb UCNam-*-2
 fcb F$CmpNam+$80
 fdb SCNam-*-2
 fcb F$CRC
 fdb CRCGen-*-2
 fcb F$SRqMem+$80
 fdb SRqMem-*-2
 fcb F$SRtMem+$80
 fdb SRTMEM-*-2
 fcb F$AProc+$80
 fdb APROC-*-2
 fcb F$NProc+$80
 fdb NextProc-*-2
 fcb F$VModul+$80
 fdb VMOD-*-2
 fcb F$SSVC
 fdb SSVC-*-2
 fcb F$SLink+$80
 fdb SLINK-*-2
 fcb F$Boot+$80
 fdb BOOT-*-2
 fcb F$BtMem+$80
 fdb SRqMem-*-2
 fcb F$Move+$80
 fdb MOVE-*-2
 fcb F$AllRAM
 fdb ALLRAM-*-2
 fcb F$AllImg+$80
 fdb AllImg-*-2
 fcb F$SetImg+$80
 fdb SETIMG-*-2
 fcb F$FreeLB+$80
 fdb FreeLB-*-2
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
 fdb FMODUL-*-2

 ifeq CPUType-DRG128
 fcb F$GMap     $54 request graphics memory
 fdb GFXMAP-*-2
 fcb F$GClr     $55 return graphics memory
 fdb GFXCLR-*-2
 endc
 fcb $80

InitName fcs /Init/ Configuration module name
P2Name fcs /OS9p2/ Kernal, part 2 name
BootName fcs /Boot/

IntXfr jmp [<(D.XSWI3-D.SWI3),x] Jump to the "x" version of the interrupt

*****
*
*  Swi3 Handler
*
UserSWI3 ldx D.Proc
 ldu P$SWI3,X
 beq UserSvc No user-supplied interrupt handler
UsrSWI10 lbra PassSWI

*****
*
*  Swi2 Handler
*
UserSWI2 ldx D.Proc
 ldu P$SWI2,X
 beq UserSvc No user-supplied interrupt handler
 bra UsrSWI10

*****
*
*  Swi Handler
*
SWIHN ldx D.Proc
 ldu P$SWI,X
 bne UsrSWI10

*****
*
*  Interrupt Service Routine UserSvc
*
* Handles Irq While In User State
*
* Entry: X=Process descriptor pointer of process that made system call
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

* Copy 12 bytes from user task to SysTask
GetRegs lda P$Task,X
 ldb D.SysTsk
 pshs U,Y,X,DP,D,CC
 ldx P$SP,X
 bra PutReg.A

* Copy 12 bytes from SysTask to U in Task B
PutRegs ldb P$Task,X
 lda D.SysTsk
 pshs U,Y,X,DP,D,CC
 ldx P$SP,X
 exg X,U
PutReg.A ldy #R$Size/2
 tfr B,DP
 orcc #IntMasks
 lbra MoveRegs

*****
*
*  Subroutine SysSvc
*
* Service Routine Dispatch
*
* Process software interupts from system state
* Entry: U=Register stack pointer
SysSvc leau 0,S Copy stack ptr
 lda R$CC,U
 tfr a,cc
 ldx R$PC,U Get program counter
 ldb ,X+ Get service code
 stx R$PC,U Update program counter
 ldy D.SysDis Get system service routine table
 bsr Dispatch Call service routine
 lbra SysRet

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
DISP20 pshs U Save register ptr
 jsr 0,X Call routine
 puls u Retrieve register ptr
*
* Return Condition Codes To Caller
*
DISP25 tfr cc,a Copy condition codes
 bcc Dispat40
 stb R$B,U
Dispat40 ldb R$CC,U Get condition codes
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

SetSvc10 clra
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
 bne SetSvc10 Branch if not
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
Link ldx D.Proc
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
 lsrb
 lsrb
 ifge DAT.BlSz-$2000
 lsrb Divide by 32 for 8K blocks
 endc
 inca Increment number of pages needed
 lsra
 lsra
 lsra
 lsra
 ifge DAT.BlSz-$2000
 lsra Divide by 32 for 8K blocks
 endc
 pshs A
 leau 0,Y Get copy of Y
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
 addd R$U,U add it to start of module
 std R$Y,u Return it to user
 clrb
 rts

LinkErr orcc #CARRY
 puls PC,U

* Called from LINK
* Input: B = Number of blocks
*        U = Module DAT Image ptr
SrchPDAT ldx D.Proc get pointer to current process
 leay P$DATImg,X
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
VMOD pshs U Save register ptr
 ldx R$X,U Get new module ptr
 ldy R$D,U
 bsr VALMOD Validate module
 ldx 0,s  Retrieve register ptr
 stu R$U,x Return directory entry
 puls PC,U

VALMOD pshs Y,X Save registers
 lbsr ModCheck Check sync & chksum
 bcs ValMoErr
 ldd #M$Type
 lbsr LDDDXY
 andb #Revsmask
 pshs D
 ldd #M$Name
 lbsr LDDDXY
 leax D,X
 puls a
 lbsr FModule
 puls a
 bcs VMOD20
 pshs a
 andb #Revsmask
 subb ,s+
 bcs VMOD20
 ldb #E$KwnMod
 bra ValMoErr
VMOD10 ldb #E$DirFul Err: directory full
ValMoErr orcc #CARRY SET Carry
 puls PC,Y,X

VMOD20 ldx 0,S
 lbsr SetMoImg
 bcs VMOD10
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
 ifge DAT.BlSz-$2000
 lsra Divide by 32 for 8K blocks
 endc
 ldy MD$MPDAT,U
VMOD40 pshs X,A
 ldd ,Y++
 leax D,X
 ldb 0,X Get block marker
 orb #ModBlock set module in block
 stb 0,X Set block marker 
 puls X,A
 deca
 bne VMOD40
 clrb
 puls PC,Y,X

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

SetMoImg pshs U,Y,X
 ldd #M$Size
 lbsr LDDDXY
 addd 0,S
 addd #DAT.BlSz-1 Round up
 lsra
 lsra
 lsra
 lsra
 ifge DAT.BlSz-$2000
 lsra Divide by 32 for 8K blocks
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

ModCheck pshs Y,X
 clra
 clrb
 lbsr LDDDXY Get first two bytes
 cmpd #M$ID12 Check them
 beq ModChk10
 ldb #E$BMID Err: illegal id block
 bra ModChErr exit
ModChk10 leas -1,s  Save space on stack
 leax 2,X
 lbsr AdjImg Go to next DAT block?
 ldb #M$IDSize-2
 lda #(M$ID1!M$ID2)-(M$ID1&M$ID2)   M$ID1 xor M$ID2
PARI10 sta 0,S
 lbsr LDAXYP
 eora 0,S Add parity of next byte
 decb Done?
 bne PARI10 Branch if not
 leas 1,s Reset stack
 inca Add 1 to expected $FF
 beq ModChk30 Parity good?
 ldb #E$BMHP
 bra ModChErr



*****
*
*  Subroutine ModChk30
*
* Check Module Crc
*
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
 bsr CRCCal Calculate crc
 ldd 3,S
 subd #1 count byte
 std 3,S
 bne CRCC05
 puls y,x,b
 cmpb #CRCCon1 Is it good?
 bne ModChk50 Branch if not
 cmpx #CRCCon23 Is it good?
 beq ModChk60 Branch if so
ModChk50 ldb #E$BMCRC Err: bad crc
ModChErr orcc #CARRY SET Carry
ModChk60 puls X,Y,PC


*****
*
*  Subroutine CRCCal
*
* Calculate Next Crc Value
*
CRCCal eora 0,U Add crc msb
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

*****
*
*  Subroutine Fmodul
*
* Search Directory For Module
*
* Input: A = Type
*        X = Name String Ptr
* Output: U = Directory Entry Address
*         Cc = Carry Set If Not Found
* Local: None
* Global: D.ModDir

*****
* Find Module directory
*
FMODUL pshs u
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

FModule ldu #0 Return zero if not found
 pshs u,D
 bsr SKIPSP Skip leading spaces
 cmpa #'/ Is there leading '/'
 beq FMOD35
 lbsr PrsNam Parse name
 bcs FMOD40 Branch if bad name
 ldu D.ModDir Get module directory ptr
 bra FMOD33 Test if end is reached
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
 lbsr F.CHKNAM Compare names
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
 beq FModul20 Branch if any
 eora 0,S Get type difference
 anda #TypeMask
 bne FMOD30 Branch if different
FModul20 lda 6,S Get desired language
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
 bcs FModul10 Branch if not
 comb
 ldb #E$MNF
 bra FMOD40
FMOD35 comb SET Carry
 ldb #E$BNam
FMOD40 stb 1,S Save B on stack
 puls D,U,PC

* Skip spaces
SKIPSP pshs y
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
 leay P$DATImg,X
 ldx R$X,u Get string ptr
 bsr PrsNam Call parse name
 std R$D,U Return byte & size
 bcs PNam10 branch if error
 stx R$X,U Return updated string ptr
 abx
PNam10 stx R$Y,U Return name end ptr
 rts

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
 puls PC,a

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
 bsr F.CHKNAM
 leas 8,S
 rts

F.CHKNAM pshs U,Y,X,D Save registers
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
 beq ChkNam20 Branch if last character
 anda #$FF-$20 Match upper/lower case
 beq CHKN10 ..yes; repeat
ChkNam20 comb Set carry
 puls PC,U,Y,X,D

CHKN20 decb
 bne ChkNam20 LAST Char of pathname?
 anda #$FF-$A0 Match upper/lower & high order bit
 bne ChkNam20 ..no; return carry set
 clrb
 puls PC,u,Y,X,D

*****
*
*  Subroutine SRqMem
*
* System Memory Request
*
SRqMem ldd R$D,U Get byte count
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
 cmpa #RAMinUse
 bne SRqMem30
 leay DAT.BlSz/256,Y
 bra SRQM30
SRQM15 clra
SRqMem30 ldb #DAT.BlSz/256 get page count
SRQM25 sta ,y+
 decb
 bne SRQM25
SRQM30 inc 0,S
 ldb 0,S
 cmpb #DAT.BlCt
 bcs SRQM10
SRQM40 ldb R$D,U
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
 lda 1,S
 lsra
 lsra
 lsra
 lsra
 ifge DAT.BlSz-$2000
 lsra Divide by 32 for 8K blocks
 endc
 ldb 1,S
 andb #^DAT.Addr
 addb R$D,U
 addb #^DAT.Addr
 lsrb
 lsrb
 lsrb
 lsrb
 ifge DAT.BlSz-$2000
 lsrb Divide by 32 for 8K blocks
 endc
 ldx D.SysPrc
 lbsr AllImage
 bcs SRqMem80
 ldb R$A,U Get page count
SRQM60 inc ,Y+
 decb
 bne SRQM60
 lda 1,S
 std R$U,U Return ptr to memory
 clrb
SRqMem80 leas 2,S
 rts

 page
*****
*
*  Subroutine Srtmem
*
* System Memory Return
*
SRTMEM ldd R$D,U Get byte count
 beq SRTMXX  Branch if returning nothing
 addd #$FF Round up to page
 ldb R$U+1,u Is address on page boundary?
 beq SRTM10 yes
 comb
 ldb #E$BPAddr
 rts

SRTM10 ldb R$U,U
 beq SRTMXX Branch if returning nothing
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
 ldb #DAT.TkCt
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
SRTMXX clrb
 rts

*****
BOOT comb set carry
 lda D.Boot
 bne BootXX Don't boot if already tried
 inc D.Boot
 ldx D.Init
 beq BOOT05 No init module
 ldd BootStr,X
 beq BOOT05 No boot string in init module
 leax D,X Get name ptr
 bra BOOT06
BOOT05 leax BootName,pcr
BOOT06 lda #SYSTM+OBJCT get type
 OS9 F$LINK find bootstrap module
 bcs BootXX Can't boot without module
 jsr 0,Y Call boot entry
* D now contains the size of the boot file
* X contains the address where the file was loaded into memory
 bcs BootXX Boot failed
 leau D,X Set U to end of boot
 tfr X,D
 anda #DAT.Addr Calculate start of block
 clrb
 pshs U,D
 lsra
 lsra
 lsra
 ifge DAT.BlSz-$2000
 lsra
 endc
* Shifting one less time because SysDAT entries are words
 ldy D.SysDAT
 leay A,Y Get DAT image pointer for boot module
BOOT10 ldd M$ID,X get module beginning
 cmpd #M$ID12 is it module sync code?
 bne Boot40 branch if not
 tfr X,D
 subd 0,S Subtract start of block (U on stack)
 tfr D,X Module block offset
 tfr Y,D Transfer DAT image pointer to D
 OS9 F$VModul Validate module
 pshs B
 ldd 1,S Get U back from stack
 leax D,X
 puls B
 bcc Boot35
 cmpb #E$KwnMod
 bne Boot40
Boot35 ldd M$SIZE,X Get module size
 leax D,X
 bra Boot50
Boot40 leax 1,X Try next
Boot50 cmpx 2,S End of boot?
 bcs BOOT10 Branch if not
 leas 4,S Restore stack
BootXX rts

*****
*
* Allocate RAM blocks
*
ALLRAM ldb R$B,u Get number of blocks
 bsr RAMBlk
 bcs ALRAM05
 std R$D,U
ALRAM05 rts

RAMBlk pshs Y,X,D
 ldx D.BlkMap
RAMBlk10 leay 0,X
 ldb 1,S
ALRAM30 cmpx D.BlkMap+2
 bcc RAMBlk30
 lda ,x+
 bne RAMBlk10 Reset B counter
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

RAMBlk30 comb
 ldb #E$NoRam
 stb 1,S Save error code
 puls PC,Y,X,D

*****
*
* Allocate image RAM blocks
*
AllImg ldd R$D,u  Get beginning and number of blocks
 ldx R$X,u Process descriptor pointer

AllImage pshs u,Y,X,D
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
 cmpa #RAMinUse
 puls D
 bne AllImErr
 subd #1
 pshs D
ALLIMG20 leax -1,X
 bne ALLIMG10
 ldx ,s++
 beq AllI.E
 ifeq CPUType-DRG128
 leau DAT.GBlk,U Skip the lowest 32 blocks as it is used for screen
 endc
ALLIMG30 lda ,u+
 bne ALLIMG40
 leax -1,X
 beq AllI.E
ALLIMG40 cmpu D.BlkMap+2
 bcs ALLIMG30

 ifeq CPUType-DRG128
 ldu D.BlkMap
 clrb
 leay BlkTrans,pcr
ALLIMG45 lda B,Y
 lda A,U
 bne AllI.D2
 leax -1,X
 beq AllI.E
AllI.D2 incb
 cmpb #DAT.GBlk
 bcs ALLIMG45
 endc

AllImErr ldb #E$MemFul
 leas 6,S
 stb 1,S
 comb
 puls PC,U,Y,X,D

AllI.E puls U,Y,X
 ifeq CPUType-DRG128
 leau DAT.GBlk,U Skip the lowest 32 blocks as it is used for screen
 endc

ALLIMG65 ldd ,Y++
 cmpd #DAT.Free
 bne ALLIMG70
AllI.G equ *

 ifeq CPUType-DRG128
 cmpu D.BlkMap+2 Reached end of block map?
 beq ALLIMG75 try the graphics area.
 endc

 lda ,U+             BUG in Allocation
 bne AllI.G
 inc ,-U
 tfr U,D
 subd D.BlkMap
 std -2,Y
ALLIMG70 leax -1,X
 bne ALLIMG65

 ifeq CPUType-DRG128
 bra AllI.N
ALLIMG75 ldu D.BlkMap
 clrb
 bra ALLIMG85

ALLIMG80 pshs B
 ldd ,Y++
 cmpd #DAT.Free
 puls B
 bne ALLIMG90
ALLIMG85 pshs Y
 leay BlkTrans,pcr
ALLIMG88 lda B,Y
 incb
 tst a,U
 bne ALLIMG88
 inc A,U
 pshs B
 tfr A,B
 clra
 ldy 1,S
 std -2,Y
 puls Y,B
ALLIMG90 leax -1,X
 bne ALLIMG80
 endc

AllI.N ldx 2,S Get process ptr
 lda P$State,X
 ora #ImgChg
 sta P$State,X
 clrb
 puls PC,U,Y,X,D

 ifeq CPUType-DRG128

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

*****
* F$GMap
* Input B = number of 4k blocks required in each 64k page
*       A = 0 required in lower page only
*           1 required in both pages
* Output X = first block number in lower page
*            or carry set, B has error code, if memory not available
GFXMAP ldb R$B,U
 bsr GFXMAP20
 bcs GFXMAP10
 stx R$X,U
GFXMAP10 rts

GFXMAP20 pshs X,D
 ldx D.BlkMap
 leax DAT.GBlk,X
GFXMAP30 ldb 1,S
GFXMAP40 cmpx D.BlkMap
 beq GFXFUL
 tst ,-x  RAM block free
 bne GFXMAP30 ..no
 decb
 bne GFXMAP40
 tfr X,D
 subd D.BlkMap
 std 2,S
 ldd 0,S
GFXMAP50 inc ,X+
 decb
 bne GFXMAP50
 clrb
 puls PC,X,D

GFXFUL comb SET Carry
 ldb #E$NoRAM
 stb 1,S
 puls PC,X,D

*****
* F$GClr
* Input B = number of blocks to deal locate in each 64k page
*       A = 0 deallocate in lower page only
*           1 deallocate in both pages
*       X = first block number in lower page
* Output: None
GFXCLR ldb R$B,U
 ldx R$X,U
 pshs X,D
 abx
 cmpx #DAT.GBlk
 bhi GCLRRET not a graphics block
 ldx D.BlkMap
 ldd 2,S
 leax D,X
 ldb 1,S
 beq GCLRRET
GFXCLR10 lda 0,X
 anda #$FE #^RamInUse
 sta ,x+
 decb
 bne GFXCLR10
GCLRRET clrb
 puls PC,X,D
 endc

*****
*
* Get free high block
*
FREEHB ldb R$B,u Get block count
 ldy R$Y,u DAT image pointer
 bsr FreeHBlk Go find free blocks in high part of DAT
 bcs FRHB10
 sta R$A,u return beginning block number
FRHB10 rts

FreeHBlk tfr b,a
FreeHB10 suba #DAT.BlCt+1
 nega
 pshs X,D
 ldd #$FFFF
 pshs D
 bra FreeBlk

*****
* Get Free low block
*
FreeLB ldb R$B,u Get block count
 ldy R$Y,u DAT image pointer
 bsr FRLB20
 bcs FRLB10
 sta R$A,u return beginning block number
FRLB10 rts

FRLB20 lda #$FF
 pshs X,D
 lda #$01
 subb #DAT.BlCt+1
 negb
 pshs D
 bra FreeBlk

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

FREBLK10 tfr A,B
 addb 2,s Add to current start block #
FREBLK20 lslb Multiply block # by 2
 ldx B,Y Get DAT marker for that block
 cmpx #DAT.Free Empty block?
 bne FreeBlk ..No, move to next block
 inca
 cmpa 3,S
 bne FREBLK10
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
 puls PC,X,D

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

* Get byte from other DAT
* Input: X - location
*        Y - DAT image number
LDAXY pshs CC
 lda 1,Y
 orcc #IntMasks
 sta DAT.Regs
 lda 0,X
 clr DAT.Regs
 puls PC,CC

* Get byte and increment X
* Input: X - location
*        Y - DAT image number
* Output: A - result
LDAXYP lda 1,Y
 pshs cc
 orcc #IntMasks
 sta DAT.Regs
 lda ,x+
 clr DAT.Regs
 puls cc
 bra AdjImg

AdjImg10 leax -DAT.BlSz,X
 leay 2,Y
AdjImg cmpx #DAT.BlSz
 bcc AdjImg10
 rts

*****
* Load D [D+X],[Y]]
* Loads two bytes from the address space described by the DAT image
* pointed to by Y.
*
F.LDDDXY ldd R$D,u Offset to the offset within DAT image
 leau 4,U
 pulu Y,X
 bsr LDDDXY
 std -7,U
 clrb
 rts

*****
* Get word at D offset into X
LDDDXY pshs Y,X
 leax D,X
 bsr AdjImg
 bsr LDAXYP
 pshs A
 bsr LDAXY
 tfr A,B
 puls PC,Y,X,A

*****
* Load A from 0,X in task B
*
F.LDABX ldb R$B,u Task number
 ldx R$X,u Data pointer
 lbsr LDABX
 sta R$A,U
 rts

*****
* Store A at 0,X in task B
*
F.STABX ldd R$D,U
 ldx R$X,U
 lbra STABX

****
* Move data (low bound first)
*
MOVE ldd R$D,u Source and destination task number
 ldx R$X,u Source pointer
 ldy R$Y,u Byte count
 ldu R$U,u Destination pointer
Mover andcc #^CARRY clear carry
 leay 0,y How many bytes to move?
 beq MoveNone ..branch if zero
 pshs U,Y,X,DP,D,CC
 tfr Y,D
 lsra Divide number of bytes by 2
 rorb
 tfr D,Y
 ldd 1,S
 tfr B,DP
 lbra Mover00
MoveNone rts

*****
* Allocate Process Task number
*
ALLTSK ldx R$X,u Get process descriptor
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

SetPrTsk lda P$State,X
 anda #^ImgChg
 sta P$State,X
 andcc #^CARRY clear carry
 pshs U,Y,X,D,CC
 ldb P$Task,X
 leax P$DATImg,X
 ldy #DAT.ImSz/2
 ldu #DAT.Regs
 lbra SETDAT00 Copy DAT image to DAT registers

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
RESTSK10 lda B,X
 beq RESTSK20
 incb
 cmpb #DAT.TkCt Last task slot?
 bne RESTSK10 ..yes
 comb
 ldb #E$NoTask
 bra ResTsk30
RESTSK20 inc b,x Mark occupied
 orb D.SysTsk
 clra
ResTsk30 puls PC,X

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
*****
*
*  Clock Tick Routine
*
* Wake Sleeping Processes
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
TICK10 ldu P$Queue,X Get next process ptr
 bsr ActvProc Activate process
 leax 0,U Copy process ptr
 beq TICK20 Branch if end of queue
 lda P$State,X Get process status
 bita #TimSleep In timed sleep?
 beq TICK20 Branch if not
 ldu P$SP,X Get stack ptr
 ldd R$X,U Get tick count
 beq TICK10 Branch if time
TICK20 stx D.SProcQ Update sleep queue ptr
*
* Update Time Slice counter
*
SLICE dec D.Slice Count tick
 bne SLIC10 Branch if slice not over
 inc D.Slice
*
* If Process not in System State, Give up Time-Slice
*
 ldx D.PROC Get current process ptr
 beq SLIC10 Branch if none
 lda P$State,X Get status
 ora #TIMOUT Set time-out flag
 sta P$State,X Update process status
SLIC10 clrb
 rts
 page
*****
*
*  Subroutine Actprc
*
* Put Process In Active Process Queue
*
APROC ldx R$X,U  Address of process descriptor
ActvProc clrb
 pshs U,Y,X,CC
 lda P$Prior,X Get process priority/age
 sta P$AGE,X Set age to priority
 orcc #IRQMask+FIRQMask Set interrupt masks
*
* Age Active Processes
*
 ldu #D.AProcQ-P$Queue Fake process ptr
 bra ACTP30
ACTP10 inc P$AGE,U
 bne ACTP20 is not 0
 dec P$AGE,u too high
ACTP20 cmpa P$AGE,U Who has bigger priority?
 bhi ACTP40
ACTP30 leay 0,U Copy ptr to this process
ACTP40 ldu P$Queue,U Get ptr to next process
 bne ACTP10
 ldd P$Queue,Y
 stx P$Queue,Y
 std P$Queue,X
 puls PC,U,Y,X,CC

*****
*
*  Irq Handler
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
NextPr10 cwai #$FF-IRQMask-FIRQMask Clear interrupt masks & wait
NXTP06 orcc #IRQMask+FIRQMask Set interrupt masks
 ldy #D.AProcQ-P$Queue Fake process ptr
 bra NXTP20
NXTP10 leay 0,x Copy process pointer
NXTP20 ldx P$Queue,Y Get first process in active queue
 beq NextPr10 Branch if none
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
 bmi SysRet Branch if so
NXTP30 bita #CONDEM Is process condemmed?
 bne KillProc Branch if so
 lbsr ChkPrTsk
 ldb P$Signal,X Is a signal waiting?
 beq CurrPr25 Branch if not
 decb Wake-up Signal?
 beq CurrPr20 Branch if so
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
 beq KillProc Branch if none
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
CurrPr20 stb P$Signal,X Clear signal
*
* Switch to User State
*
CurrPr25 ldd D.UsrSvc
 std D.XSWI2
 ldd D.UsrIRQ Get user irq
 std D.XIRQ
 lbra SVCRET Start next process

KillProc lda P$State,x Get process status
 ora #SysState Set system state
 sta P$State,X Update status
 leas P$Stack,X
 andcc #^IntMasks Clear interrupt masks
 ldb P$Signal,X Return fatal signal
 clr P$Signal,X
 OS9 F$EXIT Terminate process

*****
*
*  Interrupt Routine SysIRQ
*
* Handles Irq While In System State
*
SysIRQ jsr [D.SvcIRQ] Go to interrupt service
 bcc SYSI10 branch if interrupt identified
 ldb R$CC,S get condition codes
 orb #IntMasks set interrupt mask
 stb R$CC,S update condition codes
SYSI10 rti

* Return from a system call
SysRet ldx D.SysPrc Get system process dsc. ptr
 lbsr ChkPrTsk
 leas 0,u Reset stack pointer
 rti

GoPoll jmp [D.Poll]

IOPoll orcc #CARRY
 rts

 ifeq CPUType-DRG128
DATInit clra
 tfr a,dp
 ldx #DAT.Task ($FCC0)
 lda 1,X am I the DMA processor
 lbne beDMAC ..no
 ldb #4  Select output register in PIA
 stb 1,X
 lda #$F0 Set values in output register
 sta 0,X
 clra
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
DATINT10 stb 0,X
 clra
 sta 0,Y    assume RAM in block 0
 lda #$1F
 sta $06,Y Graphics at $6000
 lda #ROMBlock
 sta 14,y   DAT.Regs+$E
 lda #IOBlock
 sta 15,y   DAT.Regs+$F
 incb
 bne DATINT10
 lda #$F0
 sta 0,X
*
* Configure periphicals
*
InitIO ldx #A.Mouse ($FC24)
 lda #$7F  now enable DMA processor
 ldb #$04
 stb 1,X
 sta 0,X
 stb 3,X
 lda #$02
 sta 2,X
 clra
 sta $03,X
 lda #$83
 sta 2,X
 stb 3,X
 lda #$02
 sta 1,X
 lda #$FF
 sta 0,X
 stb 1,X
 ldx #$FC22 A.P+2
 lda #$18
 sta 0,X
 stb 1,X
 ldx #A.Crtc address of 6845 CRTC ($FC80)
 clrb
 leay CRTCCNF,pcr
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
 leay >LOADMSG,pcr
 ldx #$6000+$3C0
DATINT40 lda ,Y+
 beq DATINTBT
 sta ,X++
 bra DATINT40
DATINTBT lbra COLD

CRTCCNF fcb 55 Horizontal total (R0)
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
CRTCSIZ equ *-CRTCCNF

LOADMSG fcc " OS-9 is loading - please wait ...."
 fcb 0

beDMAC lds #$FFFF   load stack, allow NMIs
 sync

DMACNMI lds #$FFFF
 ldx D.DMPort
 ldu D.DMMem
 ldb D.DMDir  Direction is out?
 bne DMACRead ..yes
* Copy from Port to Memory
* Breaks out of loop if interrupt is longer than 3 cycles
DMAIN sync
 lda ,X
 sta ,u+
 bra DMAIN

* Copy from Memory to Port
DMACRead lda ,u+
 sync
 sta ,X
 bra DMACRead

         else
*
* Not DRG128 - virtual computer
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
DATINT10 stb 0,X
 clra
 sta 0,Y    RAM at $0000
 lda #ROMBlock
 sta $E,y   DAT.Regs+$E
 lda #IOBlock
 sta $F,y   DAT.Regs+$F
 incb
 bne DATINT10
 lda #%10110000 Turn on MMU by turning of bit 6
 sta DAT.Task
DATINTBT lbra COLD

* We don't use NMI in the Virtual OS-9
*
DMACNMI rti

*
* END Not DRG128
*
         endc

* Restore DAT image and return from interrupt
*
SVCRET ldb P$Task,x Get task number from process
 orcc #IntMasks
 stb DAT.Task
 leas 0,u Reset stack pointer
 rti

* Switch task and execute user supplied SWI vector
*
PassSWI ldb P$Task,x Get task number from process
 stb DAT.Task
 jmp 0,U Execute user interrupt handler

 emod
OS9End equ *

 ifeq CPUType-DRG128
Target set $1225-$100
 else
Target set $1000-$100
 endc
 use filler

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

* Store register A at 0,X
STABX andcc #^CARRY clear carry
 pshs B,CC
 orcc #IntMasks
 stb DAT.Task
 sta 0,X
 ldb #SysTask
 stb DAT.Task
 puls PC,B,CC

* Get byte from Task in task B
* Returns value in B
LDBBX andcc #^CARRY clear carry
 pshs a,cc
 orcc #IntMasks
 stb DAT.Task
 ldb 0,X
 lda #SysTask
 sta DAT.Task
 puls PC,A,CC

* Move Y*2 bytes from X in TASK A to U in Task B
* Input: Y = Number of bytes divided 2 (lsr)
*        CC = carry set if Y was odd.
Mover00 orcc #IntMasks
 bcc MoveRegs branch if no carry
 sta DAT.Task
 lda ,X+
 stb DAT.Task
 sta ,U+
 leay 1,Y
 bra MOVER30
MOVER10 lda 1,S
 orcc #IntMasks
MoveRegs sta DAT.Task
 ldd ,X++
 exg B,DP
 stb DAT.Task
 exg B,DP
 std ,U++
MOVER30 lda #SysTask
 sta DAT.Task
 lda 0,S
 tfr A,CC
 leay -1,Y
 bne MOVER10
 puls PC,U,Y,X,DP,D,CC

* Copy DAT image to DAT register
* Input: B: Task number
*        X: Pointer to DAT image
*        Y: Number of bytes
*        U: Pointer to DAT.Regs
SETDAT00 orcc #IntMasks
SETDAT10 lda 1,X
 leax 2,X
 stb DAT.Task
 sta ,u+
 lda #SysTask
 sta DAT.Task
 leay -1,Y
 bne SETDAT10
 puls PC,U,Y,X,D,CC

SWI3RQ orcc #IntMasks
 ldb #D.SWI3
 bra SWITCH

SWI2RQ orcc #IntMasks
 ldb #D.SWI2
 bra SWITCH

FIRQ ldb #D.FIRQ
 bra SWITCH

IRQ orcc #IntMasks
 ldb #D.IRQ

SWITCH lda #SysTask
 sta DAT.Task
SWITCH10 clra
 tfr A,DP
 tfr D,X
 jmp [,X]

SWIRQ ldb #D.SWI
 bra SWITCH

NMIRQ ldb #D.NMI
 bra SWITCH10

 ifeq CPUType-DRG128
Target set $1225-$20
 else
Target set $1000-$20
 endc
 use filler

HdlrVec fdb TICK+$FFE0-* Clock tick handler
 fdb UserSWI3+$FFE2-* Swi3 handler
 fdb UserSWI2+$FFE4-* Swi2 handler
 fdb 0000+$FFE6-* Fast irq handler
 fdb UserIRQ+$FFE8-* Irq handler
 fdb SWIHN+$FFEA-* Swi handler
 fdb DMACNMI+$FFEC-* Nmi handler
 fdb COLD+$FFEE-*

 fdb 0000+$FFF0-*
 fdb SWI3RQ+$FFF2-* Swi3
 fdb SWI2RQ+$FFF4-* Swi2
 fdb FIRQ+$FFF6-* Firq
 fdb IRQ+$FFF8-* Irq
 fdb SWIRQ+$FFFA-* Swi
 fdb NMIRQ+$FFFC-* Nmi
 fdb DATInit+$FFFE-* Dynamic address translator initialization
ROMEnd equ *

 end
