 nam OS-9 Level II V1.2, part 2
 ttl os9 Module Header

 use defsfile

************************************************************
*                                                          *
*           OS-9 Level II V1.2 - Kernal, part 2            *
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

* Originally from Dragon 128

************************************************************
*
*     Module Header
*
Type set Systm
Revs set ReEnt+2

 mod OS9End,OS9Name,Type,Revs,Cold,256
OS9Name fcs /OS9p2/

************************************************************
*
*     Edition History
*
* Edition   Date         Comments
*
*   $28   pre 82/08/18
*
*     1     82/08/18     F$Send & F$Sleep routines altered
*                        changes in routines commmented as "***V.1 -"
*
*     2     82/08/22     Modifications for MC6829

*     8     83/02/07     Add changes for write protect/enable;
*                        change "CnvBit" for speed purposes
*
*     9     83/03/17     Fix bug in "Mem" which caused it to not
*                        catch request for memory > (64K-DAT.BlSz)
*
*    10     83/04/18     Add Comtrol CPU type
*
*    11     83/05/04     Extensive mods to module load and link for
*                        non-contiguous modules
*                        Modified F$Send to clear suspend state
*                        whenever a signal is sent.
*                        Added MotGED and if needed Accupt conds.
*    12     83/08/02     Added FM11L2 CPUType
*
*    13     83/11/07     Added error messages  Vivaway Ltd PSD
*
*    13     83/12/15     Extended F$MapBlk and F$ClrBlk to allow
*                        mapping into the system task space

 fcb 13 Edition


 ttl Coldstart Routines
 page
************************************************************
*
*    Routine Cold
*
*   System Coldstart continued; add more service requests,
* set default directories, start initial process
*
Cold leay SvcTbl,PCR Get ptr to service routine table
 OS9 F$SSVC Set service table addresses
 ldu D.Init get configuration ptr
 ldd MaxMem,U
 lsra Calculate number of blocks needed
 rorb
 lsra
 rorb
 ifge DAT.BlSz-2048
 lsra
 rorb
 ifge DAT.BlSz-4096
 lsra
 rorb
 endc
 endc
 addd D.BlkMap make block map ptr
 tfr D,X copy it
 ldb #NotRAM get not RAM flag
 bra Cold.b
Cold.a lda ,X+ get block flags
 bne Cold.b branch if not free RAM
 stb -1,X mark as not RAM
Cold.b cmpx D.BlkMap+2 end of map?
 bcs Cold.a branch if not
Cold10 ldu D.Init get initializations
 ifne EXTERR
 ldy D.SysPrc point at system process descriptor
 leay P$ErrNam,Y point at error messages path name
 lda #C$CR
 sta 0,Y initially empty
 ldd ErrStr,U get name offset
 beq Cold17 ..none
 leax d,U point at name
 ldb #ErrNamSz max size
Cold15 lda ,X+ transfer the name
 sta ,Y+
 bmi Cold17 ..last chr
 decb limit?
 bne Cold15
Cold17 equ *
 endc
 ifeq CPUType-DRG128
 ldb #6 now initialise clock
Cold18 clr ,-s clear out a time buffer
 decb
 bne Cold18
 leax ,S point at it
 os9 F$STime set-time calls clock
 leas 6,S ditch scratch
 endc
 ldd SysStr,U get system device name offset
 beq Cold20 branch if none
 leax D,U get name ptr
 lda #EXEC.+READ. set both data & execution
 OS9 I$ChgDir change directories
 bcc Cold20 branch if successful
 os9 F$Boot try bootstrap
 bcc Cold10 branch if good
Cold20 ldu D.Init get initialization ptr
 ldd StdStr,U get standard I/O offset
 beq Cold30 branch if none
 leax D,U get name ptr
 lda #UPDAT. open for update
 OS9 I$OPEN open path
 bcc Cold25 branch if successful
 os9 F$Boot try bootstrap
 bcc Cold20 branch if good
 bra Cold30
Cold25 ldx D.PROC get process ptr
 sta P$PATH,X set standard input
 OS9 I$DUP count open image
 sta P$PATH+1,X set standard output
 OS9 I$DUP count open image
 sta P$PATH+2,X set standard error
Cold30 equ *
 leax <P3name,pcr get name ptr
 lda #Systm set type
 os9 F$Link link to part three
 bcs Cold40 branch if not found
 jsr 0,Y go to it
Cold40 equ *
 ldu D.Init
 ldd InitStr,U Get initial execution string
 leax D,U Get string ptr
 lda #OBJCT set type
 clrb use declared memory
 ldy #0 No parameters
 os9 F$Fork
Cold80 os9 F$NProc

** Note F$NProc does not return!!

P3name fcs "OS9p3"


 ttl Coldstart Constants
 page
***********************************************
*
*     Service Routines Initialization Table
*
SvcTbl equ *
 fcb F$Unlink
 fdb UnLink-*-2
 fcb F$Fork
 fdb FORK-*-2
 fcb F$Wait
 fdb Wait-*-2
 fcb F$Chain
 fdb CHAIN-*-2
 fcb F$EXIT
 fdb EXIT-*-2
 fcb F$MEM
 fdb Mem-*-2
 fcb F$Send
 fdb Send-*-2
 fcb F$ICPT
 fdb Intercpt-*-2
 fcb F$SLEEP
 fdb Sleep-*-2
 fcb F$SPrior
 fdb SetPri-*-2
 fcb F$ID
 fdb GetID-*-2
 fcb F$SSWI
 fdb SetSWI-*-2
 fcb F$STime
 fdb Setime-*-2
 fcb F$SchBit
 fdb UsrSBit-*-2
 fcb F$SchBit+SysState
 fdb SBit-*-2
 fcb F$AllBit
 fdb UsrABit-*-2
 fcb F$AllBit+SysState
 fdb SALLBIT-*-2
 fcb F$DelBit
 fdb UsrDBit-*-2
 fcb F$DelBit+SysState
 fdb DBit-*-2
 fcb F$GPrDsc
 fdb GPrDsc-*-2
 fcb F$GBlkMp
 fdb GBLKMP-*-2
 fcb F$GModDr
 fdb GModDr-*-2
 fcb F$CpyMem
 fdb CpyMem-*-2
 fcb F$SUser
 fdb SetUser-*-2
 fcb F$Unload
 fdb UNLOAD-*-2
 fcb F$Find64+SysState
 fdb F64-*-2
 fcb F$ALL64+SysState
 fdb A64-*-2
 fcb F$Ret64+SysState
 fdb R64-*-2
 fcb F$GProcP+SysState
 fdb GetPrc-*-2
 fcb F$DelImg+SysState
 fdb DELIMG-*-2
 fcb F$AllPrc+SysState
 fdb AllPrc-*-2
 fcb F$DelPrc+SysState
 fdb DELPRC-*-2
 fcb F$MapBlk
 fdb MapBlk-*-2
 fcb F$ClrBlk
 fdb ClrBlk-*-2
 fcb F$DelRam
 fdb DELRAM-*-2
 fcb F$GCMDir+SysState
 fdb Sewage-*-2
 fcb $7F
 fdb IOHook-*-2
 fcb $80


 ttl System Service Request Routines
 page
************************************************************
*
*      Subroutine IOHook
*
*   Handle Locating/Loading Remainder Of System
*
* Input: Y - Service Dispatch Table ptr
*
IOStr fcs "IOMan"
IOHook pshs D,X,Y,U Save registers
 bsr IOLink Link IOMan
 bcc IOHook10
 os9 F$Boot Ioman not found, try boot
 bcs IOHook20
 bsr IOLink Link ioman again
 bcs IOHook20
IOHook10 jsr 0,Y Call ioman init
 puls D,X,Y,U Retrieve registers
 ldx IOEntry,Y Get ioman entry
 jmp 0,X
IOHook20 stb 1,S
 puls D,X,Y,U,PC

IOLink leax IOStr,PCR Get ioman name ptr
 lda #SYSTM+OBJCT Get type
 OS9 F$LINK
 rts
 page
************************************************************
*
*      Subroutine UnLink
*
*
UnLink pshs U,D
 ldd R$U,U Get module address
 ldx R$U,U Get module address
 lsra Calculate block number from address
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 sta 0,S
 beq UnLinkX1 Nothing to unlink
 ldu D.PROC
 leay P$DATImg,U
 lsla
 ldd A,Y Get block pointer
 ldu D.BlkMap
 ldb D,U
 bitb #ModBlock   Module in this block?
 beq UnLinkX1
 leau P$DATImg,Y
 bra UNLK04

UnLink10 dec 0,S
 beq UnLinkX1
UNLK04 ldb 0,S
 lslb
 ldd B,U
 beq UnLink10
 lda 0,S
 lsla Calculate address from block number
 lsla
 ifge DAT.BlSz-2048
 lsla
 ifge DAT.BlSz-4096
 lsla
 endc
 endc
 clrb
 nega
 leax D,X get expect module ptr
 ldb 0,S
 lslb
 ldd B,Y
 ifne DAT.WrPr+DAT.WrEn
 endc
 ldu D.ModDir Get directory ptr
 bra UnLink25
UnLink20 leau MD$ESize,U move to next entry
 cmpu D.ModEnd End of directory?
 bcs UnLink25
UnLinkX1 bra UnLink80
UnLink25 cmpx MD$MPtr,U do ptrs match?
 bne UnLink20 branch if not
 cmpd [MD$MPDAT,U] do block numbers match?
 bne UnLink20
 ldx MD$Link,U Get use count
 beq UNLK16 Branch if not used
 leax -1,X DOWN Link count
 stx MD$Link,U
 bne UNLK22 Branch if still used
UNLK16 ldx 2,S
 ldx 8,X
 ldd #M$Type
 OS9 F$LDDDXY Get module type
 cmpa #FLMGR Is i/o module?
 bcs UNLK20 Branch if not
 os9 F$IODel Delete from i/o system
 bcc UNLK20
 ldx MD$Link,U
 leax 1,X Reset link count
 stx MD$Link,U
 bra UnLinErr
UNLK20 bsr ClrDir Delete module
UNLK22 ldb 0,S
 lslb
 leay b,Y
 ldx P$Links-P$DATImg,Y
 leax -1,X
 stx P$Links-P$DATImg,Y
 bne UnLink80
 ldd MD$MBSiz,U
 bsr BlkCnt
 ldx #DAT.Free
UNLK24 stx ,Y++ mark DAT free
 deca
 bne UNLK24
UnLink80 clrb clear carry
UnLinErr leas 2,S
 puls PC,U


ClrDir ldx D.BlkMap
 ldd [MD$MPDAT,U] Get module DAT image
 lda D,X Is block type ROM?
 bmi ClrD.F yes, exit
 ldx D.ModDir
ClrD.A ldd [MD$MPDAT,X]
 cmpd [MD$MPDAT,U] Match
 bne ClrD.B
 ldd MD$Link,X get link count
 bne ClrD.F exit if not null
ClrD.B leax MD$ESize,X Move to next entry
 cmpx D.ModEnd at end?
 bcs ClrD.A ..no
 ldx D.BlkMap
 ldd MD$MBSiz,U
 bsr BlkCnt Divide by block size, rounding up
 pshs y
 ldy MD$MPDAT,U
ClrD.C pshs x,a
 ldd 0,Y get block number
 clr ,Y+
 clr ,Y+
 leax D,X point to blkmap entry
 ldb 0,X
 andb #^(ModBlock+RAMinUse)
 stb 0,X
 puls X,A
 deca More blocks
 bne ClrD.C .. yes
 puls Y
 ldx D.ModDir
 ldd MD$MPDAT,U
ClrD.D cmpd MD$MPDAT,X
 bne ClrD.E
 clr 0,X
 clr 1,X
ClrD.E leax MD$ESize,X
 cmpx D.ModEnd
 bcs ClrD.D
ClrD.F rts


BlkCnt addd #DAT.Blsz-1
 lsra
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 rts
 page
************************************************************
*
*      Subroutine Fork
*
*   Initiate new process
*
* Input: U = registers ptr
*
* Output: Carry clear if successful; set otherwise
*
* Data: D.PrcDBT, D.Proc
*
* Calls: InitProc
*
Fork pshs U save registers ptr
 lbsr AllProc get process descriptor
 bcc Fork.A branch if successful
 puls PC,U
Fork.A pshs U save child process ptr
 ldx D.PROC get parent process ptr
 ldd P$USER,X get parent user index
 std P$User,U copy to child
 lda P$Prior,X get parent priority
 sta P$Prior,U copy to child
 leax P$DIO,X get parent default I/O ptr
 leau P$DIO,U get child default I/O ptr
 ldb #DefIOSiz get area size
Fork.C lda ,X+ get byte
 sta ,U+ copy it
 decb count it
 bne Fork.C branch if more
 ldy #3 set count
Fork.D lda ,X+ get path number
 beq Fork.E branch if more
 OS9 I$DUP duplicate path
 bcc Fork.E branch if successful
 clra set path closed
Fork.E sta ,U+ set path number
 leay -1,Y count path
 bne Fork.D
 ldx 0,S get child ptr
 ldu 2,S get registers ptr
 lbsr InitProc initialize process
 bcs ForkErr branch if error
 pshs D save byte count
 os9 F$AllTsk allocate child task
 bcc Fork.F branch if successful
*
*   >>> need error routine here <<<
*
Fork.F lda P$PagCnt,X get high memory found
 clrb
 subd 0,s get destination ptr
 tfr D,U
 ldb P$Task,X
 ldx D.PROC
 lda P$Task,X
 leax 0,Y
 puls Y
 os9 F$Move
 ldx 0,S
 lda D.SysTsk
 ldu P$SP,X
 leax P$Stack-R$Size,X get local stack
 ldy #R$Size
 os9 F$Move
 puls U,X
 os9 F$DelTsk
 ldy D.PROC
 lda P$ID,X Get child id
 sta R$A,U Return to parent
 ldb P$CID,Y Get youngest child id
 sta P$CID,Y Set new child
 lda P$ID,Y Get parent id
 std P$PID,X Set parent & sibling ids
 lda P$State,X Get child state
 anda #^SysState clear system state
 sta P$State,X update state
 OS9 F$AProc put child in active queue
 rts
ForkErr puls x
 pshs b Save error code
 lbsr TermProc
 lda 0,X
 lbsr RetProc
 comb set carry
 puls pc,U,b
 page
************************************************************
*
*     Subroutine AllPrc
*
*   Process Descriptor allocation service routine
*
* Input: U = registers ptr
*
* Output: Carry clear if successful; set otherwise
*
* Data: none
*
* Calls: AllProc
*
AllPrc pshs u save registers ptr
 bsr AllProc get process descriptor
 bcs AllPXit branch if error
 ldx 0,S get registers ptr
 stu R$U,X return process ptr
AllPXit puls pc,u

************************************************************
*
*     Subroutine AllProc
*
*   Allocate Process Descriptor
*
AllProc ldx D.PrcDBT Get process block ptr
AllP.A lda ,X+
 bne AllP.A branch if used
 leax -1,X go back one
 tfr X,D
 subd D.PrcDBT
 tsta
 beq AllP.B
 comb
 ldb #E$PrcFul
 bra AllPrXit
AllP.B pshs b
 ldd #P$Size
 os9 F$SRqMem
 puls a
 bcs AllPrXit
 sta P$ID,U 
 tfr u,d
 sta 0,X set table entry
 clra
 leax 1,U skip process ID
 ldy #P$Size/4 clear first halt of descriptor
AllP.C std ,X++
 leay -1,Y
 bne AllP.C
 lda #SysState set system state
 sta P$State,U
 ldb #DAT.BlUs get usable block count
 ldx #DAT.Free get free block code
 leay P$DATImg,U get new DAT image ptr
AllP.D stx ,Y++ clear DAT image
 decb count block
 bne AllP.D branch if more
 ifne DAT.BlCt-DAT.BlUs
 ifeq CPUType-DRG128
 ldx #IOBlock
 else
 ldx #ROMBlock
 endc
 stx ,Y++
 endc
 ifne EXTERR
 leay P$ErrNam,U    Area for error messages
 ldx D.PROC
 leax P$ErrNam,X    Area for error messages
 ldb #32
AllP.E lda ,X+ copy name
 sta ,Y+
 decb
 bne AllP.E
 endc
 clrb clear carry
AllPrXit rts


************************************************************
*
*    Subroutine DelPrc
*
* Deallocate Process Descriptor service routine
*
DELPRC lda R$A,U
 bra RetProc

 page
************************************************************
*
*  Subroutine Wait
*
* Wait for Child Process to Exit
*
Wait ldx D.PROC Get process ptr
 lda P$CID,X Does process have children?
 beq NoChdErr Branch if no
Wait10 lbsr GetProc
 lda P$State,Y Get child's status
 bita #DEAD Is child dead?
 bne ChildSts Branch if so
 lda P$SID,Y More children?
 bne Wait10 Branch if so
 sta R$A,U clear child process id
 pshs CC
 orcc #IntMasks Set interrupt masks
 ldd D.WProcQ get waiting process queue ptr
 std P$Queue,X
 stx D.WProcQ
 puls cc
 lbra ZZZProc Put process to sleep
NoChdErr comb set carry
 ldb #E$NoChld
 rts
 page
************************************************************
*
*  Subroutine ChildSts
*
* Return Child's Death Status to Parent
*
* Input:  X - Parent Process ptr
*         Y - Child Process ptr
*         U - Parent Process Register ptr
*
ChildSts lda P$ID,Y get child process ID
 ldb P$Signal,Y get exit status
 std R$D,U return to parent
 leau 0,Y copu child process ptr
 leay P$CID-P$SID,X make sibling of parent
 bra ChildS20
ChildS10 lbsr GetProc get process ptr
ChildS20 lda P$SID,Y get next sibling
 cmpa P$ID,U is child next sibling?
 bne ChildS10 branch if not
 ldb P$SID,U get child's next sibling
 stb P$SID,Y remove child from sibling list
*
*     fall through to RetProc
*
************************************************************
*
RetProc pshs U,X,D save registers
 ldb 0,S get process ID
 ldx D.PrcDBT get process table ptr
 abx get entry ptr
 lda 0,X get ptr MSB
 beq RetPrc10 branch if not used
 clrb clear ptr LSB
 stb 0,X clear table entry
 tfr d,X copy descriptor ptr
 os9 F$DelTsk get task number
 leau 0,X copy descriptor ptr
 ldd #P$Size get descriptor size
 os9 F$SRtMem return memory
RetPrc10 puls pc,U,X,b,a
 page
************************************************************
*
*     Subroutine Chain
*
*   Metamorph Process into new form
*
* Input: U = registers ptr
*
* Output: Carry set if successful; set otherwise
*
* Data: D.Proc
*
* Calls: InitProc
*
Chain pshs U save registers ptr
 lbsr AllProc get new process
 bcc Chain.A branch if no error
 puls PC,U
Chain.A ldx D.PROC get process ptr
 pshs U,X save registers
 leax P$SP,X skip process linkages
 leau P$SP,U
 ldy #P$Size/4-2 get byte count
Chain.B ldd ,X++ get data
 std ,U++ copy it
 leay -1,Y count double byte
 bne Chain.B branch if more
 ldx D.PROC get process ptr
 clra
 clrb
 stb P$Task,X clear task number
 std P$SWI,X clear interrupt entries
 std P$SWI2,X
 std P$SWI3,X
 sta P$Signal,X clear signal
 std P$SigVec,X clear signal vector
 ldu P$PModul,X get module ptr
 os9 F$UnLink unlink it
 ldb P$PagCnt,X get page count
 addb #(DAT.BlSz-1)/256 round to next block
 lsrb get next block number
 lsrb
 ifge DAT.BlSz-2048
 lsrb
 ifge DAT.BlSz-4096
 lsrb
 endc
 endc
 lda #DAT.BlUs get number of useable blocks
 pshs b save next block number
 suba ,S+ get number of blocks left
 leay P$DatImg,X get DAT image ptr
 aslb shift for two-byte entries
 leay B,Y get block ptr
 ldu #DAT.Free get free block number
Chain.C stu ,Y++ mark block free
 deca count block
 bne Chain.C branch if more
 ifne DAT.BlCt-DAT.BlUs
 ifeq CPUType-DRG128
 ldu #IOBlock
 else
 ldu #ROMBlock
 endc
 stu ,Y++
 endc
 ldu 2,S get new process ptr
 stu D.PROC make it current
 ldu 4,S get registers ptr
 lbsr InitProc initialize process
 lbcs ChainErr branch if error
 pshs d save byte count
 os9 F$AllTsk get process task number
 bcc Chain.D Branch if no error
*
* >>> need error routine here
*
Chain.D ldu D.PROC
 lda P$Task,U new task number
 ldb P$Task,X old task number
 leau (P$Stack-R$Size),X
 leax 0,Y
 ldu P$SP,U
 pshs u
 cmpx ,S++
 puls y
 bhi Chain20 Branch if something to move
 beq Chain30 Branch if X is 0
 leay 0,Y any bytes to move?
 beq Chain30 ..no
 pshs X,D
 tfr Y,D
 leax d,X
 pshs u
 cmpx ,S++
 puls X,D retrieve registers
 bls Chain20 branch if no overlap
 pshs U,Y,X,B,A save registers
 tfr Y,D copy byte count
 leax D,X get source end ptr
 leau D,U get destination end ptr
Chain15 ldb 0,S get source task
 leax -1,X predecrement ptr
 os9 F$LDABX get byte
 exg X,U swap source & destination
 ldb 1,S get destination task
 leax -1,X predecrement ptr
 os9 F$STABX copy byte
 exg X,U swap source & destination
 leay -1,Y count byte
 bne Chain15 branch if more
 puls U,Y,X,B,A retrieve registers
 bra Chain30
Chain20 os9 F$Move move data
Chain30 lda D.SysTsk get system task
 ldx 0,S get process ptr
 ldu P$SP,X get process stack
 leax P$Stack-R$Size,X get local stack
 ldy #R$Size get byte count
 os9 F$Move copy stack to process
 puls U,X retrieve process ptrs
 lda P$ID,U get process ID
 lbsr RetProc return process descriptor
 os9 F$DelTsk return task number
 orcc #IntMasks set interrupt masks
 ldd D.SysPrc get system process ptr
 std D.PROC set current process
 lda P$State,X get process state
 anda #^SysState clear system state
 sta P$State,X update state
 os9 F$AProc put in active process queue
 os9 F$NProc start next process
ChainErr puls u,x retrieve process ptrs
 stx D.PROC restore current process ptr
 pshs b save error code
 lda P$ID,U get new process ID
 lbsr RetProc return process descriptor
 puls b retrieve error code
 os9 F$Exit kill process
 page
************************************************************
*
*  Subroutine InitProc
*
* Set Up Process Descriptor
*
InitProc pshs U,Y,X,D
 ldd D.PROC Get process ptr
 pshs D
 stx D.PROC
 lda R$A,U   Language/type code
 ldx R$X,U   Address of module name
 ldy 0,S Get process ptr
 leay P$DATImg,Y
 os9 F$SLink
 bcc SETPRC05 Branch if found
 ldd 0,S
 std D.PROC
 ldu 4,S  get X from stack
 os9 F$Load Try loading it
 bcc SETPRC05 Branch if loadable
 leas 4,S
 puls PC,U,Y,X

SETPRC05 stu 2,S
 pshs Y,A
 ldu $0B,S
 stx R$X,U
 ldx 7,S
 stx D.PROC
 ldd 5,S
 std P$PModul,X
 puls A
 cmpa #PRGRM+OBJCT is it program object?
 beq SETPRC15 branch if so
 cmpa #SYSTM+OBJCT is it system object?
 beq SETPRC15 branch if so
 ldb #E$NEMod err: non-executable module
SETPRC10 leas 2,S Restore stack
 stb 3,S
 comb set carry
 bra SETPRC50

SETPRC15 ldd #M$Mem get module's memory requirement
 leay P$DATImg,X
 ldx P$PModul,X
 os9 F$LDDDXY
 cmpa R$B,U Compare with user request
 bcc SETPRC25 ..use program specification if higher
 lda R$B,U user specified data size in pages
 clrb
SETPRC25 os9 F$Mem Mem to correct size
 bcs SETPRC10 Branch if no memory
 ldx 6,S
 leay (P$Stack-R$Size),X
 pshs d
 subd R$Y,U
 std $04,Y
 subd #R$Size Deduct stack room
 std P$SP,X Set stack ptr
 ldd R$Y,U
 std R$D,Y
 std 6,S
 puls x,d
 std 6,Y
 ldd R$U,U
 std 6,S Pass to process
 lda #ENTIRE Set cc entire bit
 sta R$CC,Y
 clra
 sta R$DP,Y Get direct page ptr
 clrb
 std R$U,Y
 stx R$PC,Y Set new program counter
SETPRC50 puls D
 std D.PROC
 puls PC,U,Y,X,D
 page
************************************************************
*
*  Subroutine Exit
*
* Process Termination
*
EXIT ldx D.PROC
 bsr TermProc
 ldb R$B,U Get exit status
 stb P$Signal,X Save status
 leay 1,X
 bra EXIT30
EXIT20 clr P$SID,Y Clear sibling link
 lbsr GetProc
 clr P$PID,Y
 lda P$State,Y Get process status
 bita #DEAD Is process dead?
 beq EXIT30 Branch if not
 lda P$ID,Y
 lbsr RetProc
EXIT30 lda P$SID,Y Get sibling id
 bne EXIT20
 leay 0,X
 ldx #D.WProcQ-P$Queue Fake process ptr
 lds D.SysStk
 pshs CC
 orcc #IRQMask+FIRQMask Set interrupt masks
 lda P$PID,Y
 bne EXIT40
 puls CC
 lda P$ID,Y
 lbsr RetProc
 bra EXIT50

EXIT35 cmpa P$ID,X Is this parent?
 beq EXIT45
EXIT40 leau 0,X Copy X
 ldx P$Queue,X
 bne EXIT35
 puls CC
 lda #SysState+DEAD
 sta P$State,Y
 bra EXIT50

EXIT45 ldd P$Queue,X take parent out of Wait queue
 std P$Queue,U
 puls CC
 ldu P$SP,X Get parent's stack
 ldu R$U,U
 lbsr ChildSts Return child status
 os9 F$AProc Move parent to active queue
EXIT50 os9 F$NProc

************************************************************
*
*     Subroutine TermProc
*
*   Return Process resources
*
* Input: X = Process Descriptor ptr
*
* Output: none
*
* Data: none
*
* Calls: none
*
TermProc pshs u save register
 ldb #NumPaths get number of paths
 leay P$PATH,X get paths ptr
Term.A lda ,Y+ get next path
 beq Term.B branch if closed
 clr -1,Y establish closed path
 pshs B save path count
 OS9 I$Close close path
 puls B retrieve path count
Term.B decb count path
 bne Term.A branch if more
 clra clear block number
 ldb P$PagCnt,X get number of pages
 beq Term.C branch if none
 addb #(DAT.BlSz/256)-1 round to next block
 lsrb make block count
 lsrb
 ifge DAT.BlSz-2048
 lsrb
 ifge DAT.BlSz-4096
 lsrb
 endc
 endc
 os9 F$DelImg release memory
Term.C ldd D.PROC get current process ptr
 pshs d save it
 stx D.PROC make process current
 ldu P$PModul,X get primary module ptr
 os9 F$UnLink release module
 puls u,d retrieve current process & register
 std D.PROC reset it
 os9 F$DelTsk return task number
 rts
 page
************************************************************
*
*     Subroutine Mem
*
*   Set Process Memory size
*
* Input: U = registers ptr
*
* Output: Carry clear if successful; set otherwise
*
* Data: D.Proc
*
* Calls: none
*
Mem ldx D.PROC get process ptr
 ldd R$D,U Get size requested
 beq Mem40 branch if info request
 addd #255 round up to page
 bcc Mem05 bra if request ok
 ldb #E$MemFul return error if too much requested
 bra MemErr1
Mem05 cmpa P$PagCnt,X expanding or contracting?
 beq Mem40 branch if no change
 pshs a save new page count
 bcc Mem10 branch if expanding
 deca adjust for stack
 ldb #-R$Size
 cmpd P$SP,X is stack safe?
 bcc Mem10 branch if so
 ldb #E$DelSP err: deallocating stack
 bra MemErr
Mem10 lda P$PagCnt,X get current size
 adda #(DAT.BlSz/256)-1 round to next block
 lsra get block number
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 ldb 0,s get new size
 addb #(DAT.BlSz/256)-1 round to next block
 bcc Mem15 branch if no overflow
 ldb #E$MemFul err: memory full
 bra MemErr
Mem15 lsrb get block number
 lsrb
 ifge DAT.BlSz-2048
 lsrb
 ifge DAT.BlSz-4096
 lsrb
 endc
 endc
 pshs a copy current high block
 subb ,S+ get number of blocks
 beq Mem30 branch if none
 bcs Mem20 branch if contracting
 os9 F$AllImg allocate RAM for image
 bcc Mem30 branch if no error
MemErr leas 1,S return scratch
MemErr1 orcc #Carry set carry
 rts
Mem20 pshs b copy negative block count
 adda ,S+ get beginning block number
 negb get number of blocks
 os9 F$DelImg deallocate RAM blocks
Mem30 puls a retrieve new size
 sta P$PagCnt,X set new size
Mem40 lda P$PagCnt,X get process size
 clrb
 std R$D,U return process size
 std R$Y,U return end ptr
 rts
 page
************************************************************
*
*     Subroutine Send
*
*   Send signal to one process or all processes
*
* Input: U = registers ptr
*            R$A,u = Intended Receiver Process ID
*            R$B = Signal code
*
* Output: Carry clear if successful; set otherwise
*
* Data: D.Proc, D.PrcDBT, D.SProcQ, D.WProcQ
*
* Calls: none
*
Send ldx D.PROC get sending process ptr
 lda R$A,U get intended receiver
 bne SendSub do single send
 inca begin with ID 1
Send10 cmpa P$ID,X is this sending process ID?
 beq Send15 branch if so
 bsr SendSub send signal
Send15 inca get next ID
 bne Send10 branch if more
 clrb clear carry
 rts

* (X)=D.Proc
SendSub lbsr GetProc get process ptr
 pshs U,Y,A,CC save registers
 bcs SendS91 abort if error
 tst R$B,U kill signal?
 bne SendS05 ..No; continue
 ldd P$User,X get caller's User ID
 beq SendS05 SuperUser is capable of mass murder
 cmpd P$User,Y killing his own kind?
 beq SendS05 ..Yes; continue
 ldb #E$IPrcID ..Illegal Process ID
 inc 0,S return carry set
SendS91 lbra SendS90 ..Abort

SendS05 orcc #IntMasks set interrupt masks
 ldb R$B,U get signal code
 bne SendS10 branch if not abort
 ldb #E$PrcAbt get error code
 lda P$State,Y force process to exit
 ora #Condem set condemmed status
 sta P$State,Y update process state
SendS10 lda P$State,y get process state
 anda #^Suspend release process from any suspension
 sta P$State,Y store in process desc
 lda P$Signal,Y is signal pending
 beq SendS20 branch if not
 deca is it wake up?
 beq SendS20
 inc 0,S set carry
 ldb #E$USigP err: unprocessed signal pending
 bra SendS90
SendS20 stb P$Signal,Y set signal
 ldx #D.SProcQ-P$Queue make process of sleep root
 clra clear ticks-remainint count
 clrb
SendS30 leay 0,X copy process ptr
 ldx P$Queue,X get next process ptr
 beq SendS40 ..no
 ldu P$SP,X get process stack ptr
 addd R$X,U
 cmpx 2,S Is this destination process?
 bne SendS30 branch if not
 pshs D save remaining time
 lda P$State,X get process state
 bita #TimSleep is process in timed sleep?
 beq SendS35 branch if not
 ldd 0,S get remaining time
 beq SendS35 branch if none
 ldd 4,U
 pshs D
 ldd 2,S
 std 4,U
 puls D
 ldu P$Queue,X get next process in queue
 beq SendS35 branch if none
 std 0,S save remaining time
 lda P$State,U get process state
 bita #TimSleep is it in timed sleep?
 beq SendS35 branch if not
 ldu P$SP,U get process stack ptr
 ldd 0,S retrieve remaining time
 addd R$X,U add remaining time
 std R$X,U update it
SendS35 leas 2,S Restore stack pointer
 bra SendS60
*
* Look for Process in Waiting Queue
*
SendS40 ldx #D.WProcQ-P$Queue Fake process ptr
SendS50 leay 0,X Copy process ptr
 ldx P$Queue,X More in queue?
 beq SendS90 Branch if not
 cmpx 2,S Is this destination process?
 bne SendS50 Branch if not
*
* Move Process from it's current Queue to Active Queue
*
SendS60 ldd P$Queue,X Remove from queue
 std P$Queue,Y
 lda P$Signal,X Get signal
 deca Is it wake-up?
 bne SendS70 Branch if not
 sta P$Signal,X Clear signal
 lda 0,S
 tfr A,CC
SendS70 os9 F$AProc Put in active queue
SendS90 puls PC,U,Y,A,CC
 page
************************************************************
*
*  Subroutine Intercpt
*
* Signal Intercept Handler
*
Intercpt ldx D.PROC Get process ptr
 ldd R$X,U Get vector
 std P$SigVec,X Save it
 ldd R$U,U Get data address
 std P$SigDat,X Save it
 clrb CLEAR Carry
 rts
 page
************************************************************
*
*     Subroutine Sleep
*
*   Sleep Service routine
*
* Input: U = registers ptr
*            R$X,u = ticks to sleep
*
* Output: none
*
* Data: D.Proc, D.SProcQ
*
* Calls: ZZZProc
*
Sleep pshs cc save interrupt masks
 ldx D.PROC get process ptr
 orcc #IntMasks set interrupt masks
 lda P$Signal,X is there signal waiting?
 beq Sleep20 branch if not
 deca is it wake up?
 bne Sleep10 branch if not
 sta P$Signal,X clear wake up
Sleep10 puls cc retrieve interrupt masks
 OS9 F$AProc keep process active
 bra ZZZProc
Sleep20 ldd R$X,U get sleep tick count
 beq Sleep50 branch if not timed
 subd #1 count current tick
 std R$X,U update count
 beq Sleep10 branch if time expired
 pshs y,X save registers
 ldx #D.SProcQ-P$Queue make process of sleep root
Sleep30 std R$X,U update sleep time
 stx 2,S save process ptr
 ldx P$Queue,X get next process ptr
 beq Sleep40 branch if none
 lda P$State,X get process state
 bita #TimSleep is it in timed sleep?
 beq Sleep40 branch if not
 ldy P$SP,X get process stack
 ldd R$X,U get current process sleep time
 subd R$X,Y subtract queue process sleep time
 bcc Sleep30 branch if less than current
 nega get queue process remaining time
 negb
 sbca #0
 std R$X,Y update queue process sleep time
Sleep40 puls Y,X retrieve queue process ptr
 lda P$State,X get process state
 ora #TimSleep mark timed sleep
 sta P$State,X update state
 ldd P$Queue,Y get remaining queue ptr
 stx P$Queue,Y link queue to current
 std P$Queue,X link current to remaining
 ldx R$X,U get sleep time
 bsr ZZZProc suspend process
 stx R$X,U return remaining tick count
*
***V.1 - following four lines were inserted
*
 ldx D.PROC get process ptr
 lda P$State,X get process state
 anda #^TimSleep clear timed-sleep flag
 sta P$State,X update process state
 puls PC,CC
Sleep50 ldx #D.SProcQ-P$Queue make process of sleep root
Sleep60 leay 0,X copy process pointer
 ldx P$Queue,X get next process ptr
 bne Sleep60 branch if one exists
 ldx D.PROC get current process ptr
 clra clear remaining link
 clrb
 stx P$Queue,Y link queue to current
 std P$Queue,X link current to remaining
 puls CC retrieve interrupt masks

ZZZProc pshs PC,U,Y,X make partial stack
 leax <WakeProc,PCR get activation routine
 stx 6,S set new pc
 ldx D.PROC get process ptr
 ldb P$Task,X get process task
 cmpb D.SysTsk is this system task?
 beq ZZZPrc10 branch if so
 os9 F$DelTsk deallocate process task
ZZZPrc10 ldd P$SP,X get current stack
 pshs DP,D,CC complete stack
 sts P$SP,X mark new stack
 OS9 F$NProc start next process

WakeProc pshs X save register
 ldx D.PROC get process ptr
 std P$SP,X reset stack
 clrb clear carry
 puls pc,x
 page
************************************************************
*
*  Subroutine Setpri
*
* Set Process Priority
*
SetPri lda R$A,U get process id
 lbsr GetProc get process ptr
 bcs SetPri30 branch of not found
 ldx D.PROC get setting process ptr
 ldd P$USER,X get User ID
 beq SetPri10 branch if system
 cmpd P$USER,Y same as reciever?
 bne SetPri20 branch if not
SetPri10 lda R$B,U get new priority
 sta P$Prior,Y and set it.
 clrb clear carry
 rts
SetPri20 comb set carry and error code
 ldb #E$IPrcID Err: illegal process id
SetPri30 rts
 page
************************************************************
*
*  Subroutine GetID
*
GetID ldx D.PROC get Process ptr
 lda P$ID,X get Process ID
 sta R$A,U return to User
 ldd P$USER,X get User ID
 std R$Y,U return to User
 clrb clear carry
 rts
 page
************************************************************
*
*  Subroutine SetSWI
*
* Set Software Interrupt Vectors
*
SetSWI ldx D.PROC
 leay P$SWI,X get pointer to vectors
 ldb R$A,U get SWI code
 decb adjust range
 cmpb #3 is SWI code in range?
 bcc SSWI10 branch if not
 aslb multiply by 2
 ldx R$X,U get new SWI vector
 stx B,Y and install it.
 rts return clean
SSWI10 comb set error flag and code
 ldb #E$ISWI Err: Illegal SWI code
 rts and return
 page
************************************************************
*
*     Subroutine Setime
*
*   Set current system Date/Time service routine
*
ClockNam fcs "Clock"

Setime ldx R$X,U get date/time ptr
 tfr DP,A
 ldb #D.Time
 tfr D,U
 ldy D.PROC
 lda P$Task,Y
 ldb D.SysTsk
 ldy #6
 os9 F$Move
 ldx D.PROC
 pshs X
 ldx D.SysPrc
 stx D.PROC
 lda #SYSTM+OBJCT
 leax <ClockNam,pcr
 os9 F$Link link to clock module
 puls X
 stx D.PROC
 bcs SeTime99
 jmp 0,Y execute clock's initialization

SeTime99 rts
 page
************************************************************
*
*  Subroutine UsrABit
*
* Set Bits In Bit Map
*
* Input: D = Beginning Page Number
*        X = Bit Map Address
*        Y = Page Count
* Output: None
* Local: None
* Global: None
*
UsrABit ldd R$D,U get beginning bit number
 ldx R$X,U
 bsr CnvBit
 ldy D.PROC
 ldb P$Task,Y
 bra SetBit

************************************************************
*
SALLBIT ldd R$D,U
 ldx R$X,U
 bsr CnvBit
 ldb D.SysTsk
*
*      fall through to SetBit
*
 page
************************************************************
*
*     Subroutine SetBit
*
*   Set bits in bit map
*
SetBit ldy R$Y,U
 beq SetB.G
 sta ,-S Save mask
 bmi SetB.B Branch if first bit of byte
 os9 F$LDABX
SetB.A ora 0,S Set bit
 leay -1,Y Decrement page count
 beq SetB.F Branch if done
 lsr 0,S Shift mask
 bcc SetB.A Branch if more in this byte
 os9 F$STABX
 leax 1,X
SetB.B lda #$FF Get eight pages worth
 bra SetB.D
SetB.C os9 F$STABX
 leax 1,X
 leay -8,Y
SetB.D cmpy #8 are there eight pages left?
 bhi SetB.C
 beq SetB.F
SetB.E lsra
 leay -1,Y
 bne SetB.E
 coma
 sta 0,S
 os9 F$LDABX
 ora 0,S
SetB.F os9 F$STABX
 leas 1,S
SetB.G clrb
 rts
 page
************************************************************
*
*      Subroutine CnvBit
*
*   Convert Bit Map ptr & bit number to byte ptr & mask
*
* Input: D = Bit number
*        X = Bit Map ptr
*
* Output: A = Mask
*         B = 0
*         X = byte ptr
*
* Date: none
*
* Calls: none
*
CnvBit pshs y,b save LSB bit number & register
 lsra get bit number / 2
 rorb
 lsra get bit number / 4
 rorb
 lsra get bit number / 8
 rorb
 leax D,X get byte address
 puls B retrieve LSB bit number
 leay <CnvBit.T,pcr get table ptr
 andb #7 page modulo 8
 lda b,y get make
CnvBit20 puls pc,y

CnvBit.T fcb %10000000
 fcb %01000000
 fcb %00100000
 fcb %00010000
 fcb %00001000
 fcb %00000100
 fcb %00000010
 fcb %00000001
 page
************************************************************
*
*      Subroutine UsrDBit
*
*   User Bit Map Deallocate Service routine
*
*
UsrDBit ldd R$D,U get beginning bit number
 ldx R$X,U
 bsr CnvBit Adjust map ptr & get bit mask
 ldy D.PROC
 ldb P$Task,Y
 bra ClrBit

************************************************************
*
DBit ldd R$D,U
 ldx R$X,U
 bsr CnvBit Adjust map ptr & get bit mask
 ldb D.SysTsk
*
*      fall through to ClrBit
*
 page
************************************************************
*
*      Subroutine ClrBit
*
ClrBit ldy R$Y,U
 beq ClrB.G
 coma reverse mask
 sta ,-s
 bpl ClrB.B
 os9 F$LDABX
ClrB.A anda 0,S Clear bit
 leay -1,Y Decrement page count
 beq DEAL30 Branch if done
 asr 0,S Shift mask
 bcs ClrB.A Branch if more
 os9 F$STABX
 leax 1,X
ClrB.B clra
 bra DEAL20
DEAL15 os9 F$STABX
 leax 1,X
 leay -8,Y
DEAL20 cmpy #8 Are there eight left?
 bhi DEAL15 Branch if so
 beq DEAL30 Branch if done
 coma
DEAL25 lsra
 leay -1,Y Decrement page count
 bne DEAL25
 sta 0,S
 os9 F$LDABX
 anda 0,S Clear map bits
DEAL30 os9 F$STABX
 leas 1,S
ClrB.G clrb
 rts
 page
************************************************************
*
*      Subroutine UsrSBit
*
UsrSBit ldd R$D,U Get beginning bit number
 ldx R$X,U Get bit map ptr
 bsr CnvBit
 ldy D.PROC
 ldb P$Task,Y
 bra FindBit

************************************************************
*
*      Subroutine SBit
*
SBit ldd R$D,U
 ldx R$X,U
 lbsr CnvBit
 ldb D.SysTsk
*
*      fall through to FindBit
*
 page
FindBit pshs U,Y,X,D,CC save registers & scratch
stacked set 0
CurMap set stacked
BitMask set stacked+1
TaskNum set stacked+2
BitSize set stacked+3
BitBegin set stacked+5
CurBegin set stacked+7
 clra
 clrb
 std BitSize,S Clear size found
 ldy R$D,U Copy beginning page number
 sty 7,S
 bra FindB.C
FindB.A sty 7,S
FindB.B lsr 1,S Shift mask
 bcc FLOB25 Branch if mask okay
 ror 1,S Shift mask around end
 leax 1,X Move map ptr
FindB.C cmpx R$U,U
 bcc FLOB30 Branch if so
 ldb 2,S
 os9 F$LDABX
 sta 0,S
FLOB25 leay  1,Y
 lda 0,S Get map byte
 anda 1,S Mask bit
 bne FindB.A Branch if in use
 tfr y,d Copy page number
 subd 7,S Subtract beginning page number
 cmpd R$Y,U Block big enough?
 bcc FLOB35 Branch if so
 cmpd 3,S Biggest so far?
 bls FindB.B Branch if not
 std 3,S
 ldd 7,S Copy beginning page number
 std 5,S
 bra FindB.B
FLOB30 ldd 3,S Get beginning page number of largest
 std R$Y,U
 comb SET Carry
 ldd 5,S
 bra FLOB40
FLOB35 ldd 7,S
FLOB40 std R$D,U
 leas 9,S Return scratch
 rts
 page
************************************************************
*
*      Subroutine GPrDsc
*
*   Copy Process Descriptor to user
*
GPrDsc ldx D.PROC
 ldb P$Task,X
 lda R$A,U   Process id
 os9 F$GProcP
 bcs GPrDsc10
 lda D.SysTsk
 leax 0,Y
 ldy #P$Size
 ldu R$X,U  512 byte buffer
 os9 F$Move
GPrDsc10 rts

*****
*
* Get system block map copy
*
GBLKMP ldd #DAT.BlSz
 std R$D,U  Number of bytes per block
 ldd D.BlkMap+2
 subd D.BlkMap
 std R$Y,U
 tfr D,Y
 lda D.SysTsk
 ldx D.PROC
 ldb P$Task,X
 ldx D.BlkMap
 ldu R$X,U   1024 byte buffer
 os9 F$Move
 rts

*****
*
* Get module directory copy
*
GModDr ldd D.ModDir+2
 subd D.ModDir
 tfr D,Y
 ldd D.ModEnd
 subd D.ModDir
 ldx R$X,U  2048 byte buffer pointer
 leax D,X
 stx R$Y,U
 ldx D.ModDir
 stx R$u,U
 lda D.SysTsk
 ldx D.PROC
 ldb P$Task,X
 ldx D.ModDir
 ldu R$X,U
 os9 F$Move
 rts

*****
*
*
SetUser ldx D.PROC
 ldd R$Y,U get desired User id
 std P$User,X set it
 clrb
 rts
 page
*****
*
* Copy external memory
*
CpyMem ldd R$Y,U byte count
 beq CpyMem90  Nothing to copy
 addd R$U,U  destination buffer
 ldy D.TmpDAT
 leay DAT.ImSz,Y
 sty D.TmpDAT
 leay -DAT.ImSz,Y
 pshs Y,D
 ldy D.PROC
 ldb P$Task,Y
 pshs B
* Copy DAT image to tmp DAT
 ldx R$D,U  pointer to DAT image
 leay P$DATImg,Y
 ldb #DAT.BlCt
 pshs U,B
 ldu 6,S Get copy of Y
CpyMem03 clra
 clrb
 os9 F$LDDDXY
 std ,U++
 leax 2,X
 dec 0,S
 bne CpyMem03

 puls U,B
 ldx R$X,U  offset in block to begin copy
 ldu R$U,U  destination buffer
 ldy 3,S Get copy of Y
CpyMem05 cmpx #DAT.BlSz
 bcs CpyMem10
 leax -DAT.BlSz,X
 leay 2,Y next block
 bra CpyMem05

CpyMem10 os9 F$LDAXY
 ldb 0,S
 pshs x
 leax ,U+
 os9 F$STABX
 puls x
 leax 1,X
 cmpu 1,S
 bcs CpyMem05
 puls y,X,b
 sty D.TmpDAT
CpyMem90 clrb
 rts
 page
*************************************************
*
*     Subroutine UnLoad
*
UNLOAD pshs U
 lda R$A,U  module type
 ldx D.PROC
 leay P$DATImg,X
 ldx R$X,U  module name pointer
 os9 F$FModul
 puls Y
 bcs UnLd.E
 stx R$X,Y
 ldx MD$Link,U
 beq UnLd.A
 leax -1,X
 stx MD$Link,U
 bne UNLOAD40
UnLd.A cmpa #FLMGR Is i/o module?
 bcs UNLOAD30 no, remove module from memory
 clra
 ldx [MD$MPDAT,U]
 ldy D.SysDAT
UNLOAD20 adda #2
 cmpa #DAT.ImSz
 bcc UNLOAD30
 cmpx A,Y find block?
 bne UNLOAD20
 lsla make block adjustment
 ifge DAT.BlSz-2048
 asla
 ifge DAT.BlSz-4096
 asla
 endc
 endc
 clrb
 addd MD$MPtr,U make module ptr
 tfr D,X
 os9 F$IODel
 bcc UNLOAD30  branch if no error
 ldx MD$Link,U Restore link count
 leax 1,X
 stx MD$Link,U
 bra UnLd.E

UNLOAD30 lbsr ClrDir Delete module
UNLOAD40 clrb
UnLd.E rts
 page
***************
*
*     Subroutine F64
*
*   Find Address Of Path Descriptor Or Process Descriptor
*
*
F64 lda R$A,U Get block number
 ldx R$X,U Get block ptr
 bsr FINDPD Find block
 bcs F6410
 sty R$Y,U
F6410 rts

*************************************************
*
*     Subroutine FindPD
*
FINDPD pshs D Save registers
 tsta legal number?
 beq FPDERR ..yes; error
 clrb
 lsra
 rorb
 lsra
 rorb divided by 4 PD's per PD block
 lda A,X Map into high order pd address
 tfr D,Y (y)=address of path descriptor
 beq FPDERR Pd block not allocated!
 tst 0,Y Is pd in use?
 bne FINDP9 Allocated pd, good!
FPDERR coma ERROR - return carry set
FINDP9 puls D,PC Return
 page
***************
* Aloc64
*   Allocate Path Descriptor (64 Bytes)
*
* Passed:  X=Pdbt, Path Descriptor Block Table Addr
* Returns: A=Path Number
*          Y=Pd Address
*          Cc=Set If Unable To Allocate
*           B=Error Code If Unable To Allocate
* Destroys: B
*
A64 ldx R$X,U Get block ptr
 bne A6410 Branch if set
 bsr A64ADD Add a page
 bcs A6420 Branch if error
 stx 0,X Init block
 stx R$X,U Return block ptr
A6410 bsr ALOC64 Alocate block
 bcs A6420
 sta R$A,U Return block number
 sty R$Y,U Return block ptr
A6420 rts

A64ADD pshs U Save register ptr
 ldd #$100 Get a page
 OS9 F$SRqMem
 leax 0,U Copy page ptr
 puls U Retrieve register ptr
 bcs A64Add20 Branch if no memory
 clra
 clrb
A64Add10 sta D,X Clear page
 incb
 bne A64Add10
A64Add20 rts

ALOC64 pshs X,U
 clra

ALCPD1 pshs A Save index of pd block
 clrb
 lda A,X
 beq AlPD12 Empty block (not found)
 tfr D,Y (y)=address of pd block
 clra
AlPD11 tst D,Y Available pd?
 beq AlPD13 ..yes
 addb #64 Skip to next block
 bcc AlPD11 Repeat until end of pd block
AlPD12 orcc #Carry set carry - not found
AlPD13 leay D,Y Get address of path descriptor
 puls A Restore pd block index
 bcc ALCPD4 Found a pd, return it
 inca SKIP To next pd block
 cmpa #64 last one checked?
 blo ALCPD1 ..no; keep looking
 clra
ALCPD2 tst A,X Search for an unused pdb
 beq ALCPD3 ..found one
 inca SKIP To next
 cmpa #64 all tried?
 blo ALCPD2 ..no; keep looking
 comb RETURN Carry set - error
 ldb #E$PthFul No available path
 bra ALCPD9 Return

ALCPD3 pshs A,X
 bsr A64ADD Add a page
 bcs ALCPDR Allocate error
 leay 0,X Set up pd address as first pd in block
 tfr X,D
 tfr A,B (b)=page address of new pd block
 puls A,X
* A = PDBT index, X = PDBT
 stb A,X
 clrb
*
* A = index into PDBT of PDB containing PD
* B = Low order address of PD in PDB
* Y = address Of PD
*
ALCPD4 aslb form path number
 rola
 aslb
 rola
 ldb #64-1
ALCPD5 clr B,Y
 decb
 bne ALCPD5 Clear out fresh path descriptor
 sta PD.PD,Y Set pd# in pd (indicates in use)
ALCPD9 puls X,U,PC Return carry clear

ALCPDR leas 3,S Return not enough memory error
 puls X,U,PC Return

***************
*
*     Subroutine Rtrn64
*
*   Return Path Descriptor To free status
*
*
R64 lda R$A,U Get block number
 ldx R$X,U Get block ptr
 pshs D,X,Y,U Save registers
 clrb
 tsta
 beq RtrnPD99
 lsra
 rorb
 lsra PATH #
 rorb DIVIDED By 4 pd's per block
 pshs A Save a
 lda A,X
 beq RtrnPD20 Impossible path number - return
 tfr D,Y Get address of pd
 clr 0,Y Mark it as unused
 clrb
 tfr D,U Get address of pdb in which pd lies
 clra
RtrnPD10 tst D,U Pd in use?
 bne RtrnPD20 ..yes; return
 addb #64
 bne RtrnPD10 Repeat for each pd in block
 inca (D)=$0100
 OS9 F$SRtMem Return (unused) pdb to system store
 lda 0,S
 clr A,X Mark pd unused
RtrnPD20 clr ,S+ Return scratch with carry clear
RtrnPD99 puls D,X,Y,U,PC Return to caller
 page
*****
*
* Get Process Pointer
*
GetPrc lda R$A,U
 bsr GetProc
 bcs GetPrc10
 sty R$Y,U
GetPrc10 rts

*************************************************
*
*     Subroutine GetProc
*
GetProc pshs X,D
 ldb 0,S
 beq NoProc
 ldx D.PrcDBT
 abx
 lda P$ID,X
 beq NoProc
 clrb
 tfr d,Y
 puls PC,X,D
NoProc puls X,B,A
 comb
 ldb #E$BPrcId
RTS100 rts
 page
*************************************************
*
*     Subroutine DelImg
*
*   Deallocate RAM blocks of DAT image
*
DELIMG ldx R$X,U process descriptor pointer
 ldd R$D,U beginning block number and count
 leau P$DATImg,X
 lsla multiply by 2
 leau A,U
 clra
 tfr D,Y
 pshs X
DELIMG10 ldd 0,U
 addd D.BlkMap
 tfr D,X
 lda 0,X
 anda #^RAMInUse
 sta 0,X
 ldd #DAT.Free
 std ,U++
 leay -1,Y
 bne DELIMG10
 puls X
 lda P$State,X
 ora #ImgChg
 sta P$State,X
 clrb
 rts
 page
*************************************************
*
*     Subroutine MapBlk
*
* Map specified block number into process address space
*
MapBlk lda R$B,U get block count
 cmpa #DAT.BlCt
 bcc MapB.err
 leas -DAT.ImSz,S
 ldx R$X,U
 leay 0,S
MapB.a stx ,Y++
 leax 1,X
 deca
 bne MapB.a
 ldb R$B,U
 ldx D.PROC
 leay P$DATImg,X
 os9 F$FreeHB
 bcs MapB.xit
 pshs D
 asla
 asla
 ifge DAT.BlSz-2048
 asla
 ifge DAT.BlSz-4096
 asla
 endc
 endc
 clrb
 std R$U,u return ptr
 ifeq CPUType-DRG128
 ldd ,s retrieve parameters
 pshs u save regs ptr
 leau 4,S get scratch image ptr
 os9 F$SetImg set DAT image
 puls u retrieve regs ptr
 cmpx D.SysPrc system process descriptor?
 bne MapB.b ..no; exit
 tfr x,y put process descriptor ptr in y
 ldx D.SysMem get system page map
 ldb R$U,U get mapped address
 abx make ptr into map
 leay P$DATImg,Y point at system DAT image
 lda ,S get start block
 lsla two bytes per entry
 leay A,Y point at first block
 ldu D.BlkMap get block map ptr
MapB.d ldd ,Y++ get block number
 lda D,U
 ldb #DAT.BlSz/256 pages per block
MapB.c sta ,X+ set block flags in page map
 decb
 bne MapB.c
 dec 1,S done all blocks?
 bne MapB.d ..no
MapB.b leas 2,S ditch scratch
 clrb no error
 else
* The following comes from FM-11
 puls b,a
 leau ,s
 os9 F$SetImg
 endc
MapB.xit leas DAT.ImSz,S return scratch
 rts

MapB.err comb set carry
 ldb #E$IBA err: illegal block address
 rts
 page
*****
*
* Clear Specific Block
*
ClrBlk ldb R$B,U Get number of blocks
 beq ClBl.c
 ldd R$U,U Get address of first block
 tstb
 bne MapB.err
 bita #^DAT.Addr
 bne MapB.err
 ldx D.PROC
 cmpx D.SysPrc
 beq ClBl.a
 lda P$SP,X
 anda #DAT.Addr
 suba R$U,U
 bcs ClBl.a
 lsra
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 cmpa R$B,U
 bcs MapB.err
ClBl.a lda R$U,U
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 leay P$DATImg,X
 leay A,Y
 ldb R$B,U get number of blocks
 ldx #DAT.Free
ClrBlk20 stx ,Y++ mark as free
 decb
 bne ClrBlk20
 ldx D.PROC
 lda P$State,X
 ora #ImgChg
 sta P$State,X
 ifeq CPUType-DRG128
 cmpx D.SysPrc system?
 bne ClBl.c ..no; exit
 ldx D.SysMem get system page map ptr
 ldb R$U,U get logical page number
 abx point to first page
 ldb R$B,U get number of blocks
ClBl.d lda #DAT.BlSz/256 pages per block
ClBl.e clr ,X+ deallocate the pages
 deca
 bne ClBl.e
 decb done all blocks?
 bne ClBl.d ..no
 endc
ClBl.c clrb
 rts
 page
*****
*
* Deallocate RAM blocks
*
DELRAM ldb R$B,U
 beq DelR.xit
 ldd D.BlkMap+2
 subd D.BlkMap
 subd R$X,U
 bls DelR.xit
 tsta
 bne DELRAM10
 cmpb R$B,U
 bcc DELRAM10
 stb R$B,U
DELRAM10 ldx D.BlkMap
 ldd R$X,U
 leax D,X
 ldb R$B,U
DELRAM20 lda 0,X
 anda #^RAMInUse
 sta ,X+
 decb
 bne DELRAM20
DelR.xit clrb
 rts

*****
*
* Pack module directory
*
Sewage ldx D.ModDir
 bra Sew.A1
Sew.A ldu MD$MPDAT,X Is there a DAT Image?
 beq GCMDIR30 ..yes
 leax MD$ESize,X
Sew.A1 cmpx D.ModEnd
 bne Sew.A
 bra Sew.2

* Move all entrys up 1 slot in directory
GCMDIR30 tfr X,Y
 bra GCMDIR36
Sew.C ldu MD$MPDAT,Y
 bne GCMDIR38
GCMDIR36 leay MD$ESize,Y
 cmpy D.ModEnd
 bne Sew.C
 bra Sew.F
GCMDIR38 ldu ,Y++
 stu ,X++
 ldu ,Y++
 stu ,X++
 ldu ,Y++
 stu ,X++
 ldu ,Y++
 stu ,X++
 cmpy D.ModEnd
 bne Sew.C
Sew.F stx D.ModEnd
Sew.2 ldx D.ModDir+2
 bra GCMDIR46
GCMDIR44 ldu 0,X
 beq GCMDIR48
GCMDIR46 leax -2,X
 cmpx D.ModDat
 bne GCMDIR44
 bra Sew.Exit
GCMDIR48 ldu -2,X
 bne GCMDIR46
 tfr x,Y
 bra GCMDIR51

GCMDIR50 ldu 0,Y
 bne Sew.K
GCMDIR51 leay -2,Y
GCMDIR55 cmpy D.ModDat
 bcc GCMDIR50
 bra GCMDIR70
Sew.K leay 2,Y
 ldu 0,Y
 stu 0,X
GCMDIR65 ldu ,--y
 stu ,--x
 beq Sew.M
 cmpy D.ModDat
 bne GCMDIR65
GCMDIR70 stx D.ModDat
 bsr ChgImgP
 bra Sew.Exit

Sew.M leay 2,Y
 leax 2,X
 bsr ChgImgP
 leay -4,Y
 leax -2,X
 bra GCMDIR55

Sew.Exit clrb
 rts


* non-contiguous modules
ChgImgP pshs U
 ldu D.ModDir
 bra Chg.B
Chg.C cmpy MD$MPDAT,U
 bne Chg.A
 stx MD$MPDAT,U
Chg.A leau MD$ESize,U
Chg.B cmpu D.ModEnd
 bne Chg.C
 puls PC,U

 emod
OS9End equ *
