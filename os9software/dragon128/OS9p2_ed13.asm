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
 fcb F$SEND
 fdb SEND-*-2
 fcb F$ICPT
 fdb Intercpt-*-2
 fcb F$SLEEP
 fdb SLEEP-*-2
 fcb F$SPrior
 fdb SETPRI-*-2
 fcb F$ID
 fdb GetID-*-2
 fcb F$SSWI
 fdb SETSWI-*-2
 fcb F$STime
 fdb Setime-*-2
 fcb F$SchBit
 fdb SCHBIT-*-2
 fcb F$SchBit+SysState
 fdb SSCHBIT-*-2
 fcb F$AllBit
 fdb UsrABit-*-2
 fcb F$AllBit+SysState
 fdb SALLBIT-*-2
 fcb F$DelBit
 fdb DELBIT-*-2
 fcb F$DelBit+SysState
 fdb SDELBIT-*-2
 fcb F$GPrDsc
 fdb GPrDsc-*-2
 fcb F$GBlkMp
 fdb GBLKMP-*-2
 fcb F$GModDr
 fdb GMODDR-*-2
 fcb F$CpyMem
 fdb CpyMem-*-2
 fcb F$SUser
 fdb SETUSER-*-2
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
 fdb ALLPRC-*-2
 fcb F$DelPrc+SysState
 fdb DELPRC-*-2
 fcb F$MapBlk
 fdb MAPBLK-*-2
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
 lsra
 lsra
 ifge DAT.BlSz-$2000
 lsra
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
 lsla
 ifge DAT.BlSz-4096
 lsla
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
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 rts
 page
************************************************************
*
*      Subroutine Fork
*
*   Initiate new process
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
 subd 0,S
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
 comb SET Carry
 puls pc,U,b
 page
************************************************************
*
* Allocate Image RAM blocks
*
ALLPRC pshs U
 bsr AllProc
 bcs AllPXit
 ldx 0,S Recover U register
 stu R$U,X
AllPXit puls PC,U

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
 lsrb
 ifge DAT.BlSz-4096
 lsrb
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
* Close open paths and unlink memory
TermProc pshs u
 ldb #NumPaths Get number of paths
 leay P$PATH,X Get path table ptr
Term.A lda ,Y+ Get next path number
 beq Term.B Branch if not in use
 clr -1,Y
 pshs B Save path count
 OS9 I$Close Close the file
 puls B Retrieve path count
Term.B decb COUNT Down
 bne Term.A Branch if more
 clra
 ldb P$PagCnt,X get page count
 beq Term.C
 addb #(DAT.BlSz/256)-1
 lsrb get block count
 lsrb
 lsrb
 lsrb
 ifge DAT.BlSz-$2000
 lsrb
 endc
 os9 F$DelImg
* Unlink the module
Term.C ldd D.PROC
 pshs b,a
 stx D.PROC
 ldu P$PModul,X Get primary module ptr
 os9 F$UnLink
 puls U,D
 std D.PROC
 os9 F$DelTsk
 rts
 page
************************************************************
*
*  Subroutine Mem
*
* Adjust User Memory To Requested Size
*
Mem ldx D.PROC get process ptr
 ldd R$D,U Get size requested
 beq Mem40 branch if info request
 addd #255 Round up to page
 bcc USRM05 Branch if under max
 ldb #E$MemFul
 bra USRMERR
USRM05 cmpa P$PagCnt,X Compare with already allocated
 beq Mem40 branch if same
 pshs A
 bcc USRM10
 deca
 ldb #-R$Size Deduct stack room
 cmpd P$SP,X Deallocating stack?
 bcc USRM10 Branch if not
 ldb #E$DelSP Error: request to return memory where stack is
 bra MemErr

* Determine block # from page count
USRM10 lda P$PagCnt,X
 adda #(DAT.BlSz/256)-1 Round up
 lsra
 lsra
 lsra
 lsra
 ifge DAT.BlSz-$2000
 lsra
 endc
 ldb 0,S
 addb #(DAT.BlSz/256)-1 Round up
 bcc USRM15 branch if under limit
 ldb #E$MemFul
 bra MemErr
USRM15 lsrb
 lsrb
 lsrb
 lsrb
 ifge DAT.BlSz-$2000
 lsrb
 endc
 pshs A
 subb ,S+ Subtract existing from requested
 beq USRM30 No need to allocate a new block
 bcs USRM25 Branch if a block can be deleted
 os9 F$AllImg
 bcc USRM30
MemErr leas 1,S Restore stack pointer
USRMERR orcc #Carry
 rts

USRM25 pshs B
 adda ,S+ Subtract B from existing max block
 negb Make difference positive
 os9 F$DelImg Deallocate blocks
USRM30 puls A
 sta P$PagCnt,X Set new amount of pages
Mem40 lda P$PagCnt,X
 clrb
 std R$D,U Size of new memory area in bytes
 std R$Y,U Address of upper bound in new area
 rts
 page
************************************************************
*
*  Subroutine Send
*
* Send a Signal to Process(es)
*
SEND ldx D.PROC
 lda R$A,U Get destination process id
 bne SENSUB Branch if not all processes
*
* Loop thru all Process Ids, send Signal to all but Sender
*
 inca Start with process 1
SEND10 cmpa P$ID,X Is this sender?
 beq SEND15 Branch if so
 bsr SENSUB Signal process
SEND15 inca Get next process id
 bne SEND10 Branch if more
 clrb Clear Carry
 rts
*
* Get destination Process ptr
*
SENSUB lbsr GetProc Get process ptr
 pshs U,Y,A,CC
 bcs SEND17
 tst R$B,U Is it unconditional abort signal (code 0)?
 bne SEND20 ... no
 ldd P$User,X
 beq SEND20  is it user 0?
 cmpd P$User,Y Same as process owner?
 beq SEND20 Branch if yes
 ldb #E$IPrcID Err: illegal process id
 inc R$CC,S  Set carry
SEND17 lbra SEND75
*
* Check Signal type
*
SEND20 orcc #IRQMask+FIRQMask Set interrupt masks
 ldb R$B,U Is it unconditional abort signal?
 bne SEND30 Branch if not
 ldb #E$PrcAbt
 lda P$State,Y Get process status
 ora #Condem Condem process
 sta P$State,Y Update status
SEND30 lda P$State,Y
 anda #^Suspend
 sta P$State,Y
*
* Check for Signal collision
*
 lda P$Signal,Y Is signal pending?
 beq SEND40 Branch if not
 deca Is it wake-up?
 beq SEND40 Branch if so
 inc 0,S Set Carry
 ldb #E$USigP Err: unprocessed signal pending
 bra SEND75
SEND40 stb P$Signal,Y Save signal
*
* Look for Process in Sleeping Queue
*
 ldx #D.SProcQ-P$Queue Fake process ptr
 clra
 clrb
SendS30 leay 0,X Copy process ptr
 ldx P$Queue,X More in queue?
 beq SEND66 ..no
 ldu P$SP,X get process stack ptr
 addd R$X,U
 cmpx 2,S Is this destination process?
 bne SendS30 branch if not
 pshs D save remaining time
 lda P$State,X get process state
 bita #TimSleep is process in timed sleep?
 beq SEND65 branch if not
 ldd 0,S get remaining time
 beq SEND65 branch if none
 ldd 4,U
 pshs D
 ldd 2,S
 std 4,U
 puls D
 ldu P$Queue,X get next process in queue
 beq SEND65 branch if none
 std 0,S save remaining time
 lda P$State,U get process state
 bita #TimSleep is it in timed sleep?
 beq SEND65 branch if not
 ldu P$SP,U get process stack ptr
 ldd 0,S retrieve remaining time
 addd R$X,U add remaining time
 std R$X,U update it
SEND65 leas 2,S Restore stack pointer
 bra SEND68
*
* Look for Process in Waiting Queue
*
SEND66 ldx #D.WProcQ-P$Queue Fake process ptr
SEND67 leay 0,X Copy process ptr
 ldx P$Queue,X More in queue?
 beq SEND75 Branch if not
 cmpx 2,S Is this destination process?
 bne SEND67 Branch if not
*
* Move Process from it's current Queue to Active Queue
*
SEND68 ldd P$Queue,X Remove from queue
 std P$Queue,Y
 lda P$Signal,X Get signal
 deca Is it wake-up?
 bne SEND70 Branch if not
 sta P$Signal,X Clear signal
 lda 0,S
 tfr A,CC
SEND70 os9 F$AProc Put in active queue
SEND75 puls PC,U,Y,A,CC
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
*  Subroutine Sleep
*
* Suspend Process
*
SLEEP pshs CC
 ldx D.PROC Get current process
 orcc #IRQMask+FIRQMask Set interrupt mask
 lda P$Signal,X Signal Waiting?
 beq SLEP20 Branch if not
 deca IS It wake-up?
 bne SLEP10 Branch if not
 sta P$Signal,X Clear signal
SLEP10 puls CC
 OS9 F$AProc Put process in active queue
 bra ZZZProc
SLEP20 ldd R$X,U Get length of sleep
 beq Sleep50 Branch if indefinite
 subd #1 count current tick
 std R$X,U update count
 beq SLEP10 branch if done
 pshs y,X Save process & register ptr
 ldx #D.SProcQ-P$Queue Fake process ptr
SLEP30 std R$X,U
 stx 2,S
 ldx P$Queue,X Get next process
 beq SLEP40 Branch if end of queue
 lda P$State,X Get process status
 bita #TimSleep In timed sleep?
 beq SLEP40
 ldy P$SP,X Get process stack ptr
 ldd R$X,U
 subd R$X,Y Subtract sleep time
 bcc SLEP30 Branch if not greater
 nega
 negb
 sbca #0
 std R$X,Y Fix sleep time
SLEP40 puls Y,X Retrieve process & register ptr
 lda P$State,X Set timed sleep status
 ora #TimSleep
 sta P$State,X
 ldd P$Queue,Y Put process in queue
 stx P$Queue,Y
 std P$Queue,X
 ldx R$X,U
 bsr ZZZProc
 stx R$X,U
 ldx D.PROC
 lda P$State,X Get status
 anda #^TimSleep Set not timed sleep
 sta P$State,X
 puls PC,CC
Sleep50 ldx #D.SProcQ-P$Queue make process of sleep root
Sleep60 leay 0,X Copy process pointer
 ldx P$Queue,X Get next process ptr
 bne Sleep60
 ldx D.PROC
 clra
 clrb
 stx P$Queue,Y Link into queue
 std P$Queue,X
 puls CC

ZZZProc pshs PC,U,Y,X
 leax <WakeProc,PCR Get wakeup address
 stx 6,S Make new pc
 ldx D.PROC Get process ptr
 ldb P$Task,X
 cmpb D.SysTsk
 beq ZZZPrc10
 os9 F$DelTsk
ZZZPrc10 ldd P$SP,X Get process stack
 pshs DP,D,CC Make new stack
 sts P$SP,X Note location
 OS9 F$NProc Start another process

WakeProc pshs X
 ldx D.PROC
 std P$SP,X Restore previous stack
 clrb CLEAR Carry
 puls pc,X
 page
************************************************************
*
*  Subroutine Setpri
*
* Set Process Priority
*
SETPRI lda R$A,U Get process id
 lbsr GetProc Find process descriptor
 bcs SETP20
 ldx D.PROC Get setting process ptr
 ldd P$USER,X Get setting user
 beq SETP05  Superuser?
 cmpd P$USER,Y Same as set user?
 bne SETP10 Branch if not
SETP05 lda R$B,U Get priority
 sta P$Prior,Y Set priority
 clrb
 rts
SETP10 comb SET Carry
 ldb #E$IPrcID Err: illegal process id
SETP20 rts
 page
************************************************************
*
*  Subroutine GetID
*
GetID ldx D.PROC get process ptr
 lda P$ID,X get process ID
 sta R$A,U return to user
 ldd P$USER,X get user ID
 std R$Y,U return to User
 clrb
 rts
 page
************************************************************
*
*  Subroutine Setswi
*
* Set Software Interrupt Vectors
*
SETSWI ldx D.PROC
 leay P$SWI,X Get ptr to vectors
 ldb R$A,U Get swi code
 decb ADJUST Range
 cmpb #3 Is SWI code in range?
 bcc SSWI10 branch if not
 aslb
 ldx R$X,U
 stx B,Y
 rts
SSWI10 comb
 ldb #E$ISWI
 rts

************************************************************
*
* Subroutine Setime
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
UsrABit ldd R$D,U Get beginning bit number
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

************************************************************
*
SetBit ldy R$Y,U
 beq ALOC40
 sta ,-S Save mask
 bmi ALOC15 Branch if first bit of byte
 os9 F$LDABX
ALOC10 ora 0,S Set bit
 leay -1,Y Decrement page count
 beq ALOC35 Branch if done
 lsr 0,S Shift mask
 bcc ALOC10 Branch if more in this byte
 os9 F$STABX
 leax 1,X
ALOC15 lda #$FF Get eight pages worth
 bra ALOC25
ALOC20 os9 F$STABX
 leax 1,X
 leay -8,Y
ALOC25 cmpy #8 Are there eight left?
 bhi ALOC20
 beq ALOC35
ALOC30 lsra
 leay -1,Y
 bne ALOC30
 coma
 sta 0,S
 os9 F$LDABX
 ora 0,S
ALOC35 os9 F$STABX
 leas 1,S
ALOC40 clrb
 rts
 page
************************************************************
*
*  Subroutine CnvBit
*
* Make Page Number Into Ptr & Mask
*
* Input: D = Page Number
*        X = Map Beginning Address
* Output: A = Bit Mask
*         B = 0
*         X = Byte Address
* Local: None
* Global: None
*
CnvBit pshs y,b
 lsra PAGE/2
 rorb
 lsra PAGE/4
 rorb
 lsra PAGE/8
 rorb
 leax D,X Get byte address
 puls B Get lsb
 leay <CnvBit.T,pcr
 andb #7 Page modulo 8
 lda b,Y
 puls pc,Y

CnvBit.T fcb $80,$40,$20,$10,$08,$04,$02,$01

 page
************************************************************
*
*  Subroutine Dealoc
*
* Deallocates Space In Bit Map
*
* Input: D = Beginning Page Number
*        X = Bit Map Address
*        Y = Page Count
* Output: None
* Local: None
* Global: None
*
DELBIT ldd R$D,U Get beginning bit number
 ldx R$X,U
 bsr CnvBit Adjust map ptr & get bit mask
 ldy D.PROC
 ldb P$Task,Y
 bra DEALOC

************************************************************
*
SDELBIT ldd R$D,U
 ldx R$X,U
 bsr CnvBit Adjust map ptr & get bit mask
 ldb D.SysTsk

************************************************************
*
DEALOC ldy R$Y,U
 beq DEAL40
 coma REVERSE Mask
 sta ,-s
 bpl DEAL10
 os9 F$LDABX
DEAL05 anda 0,S Clear bit
 leay -1,Y Decrement page count
 beq DEAL30 Branch if done
 asr 0,S Shift mask
 bcs DEAL05 Branch if more
 os9 F$STABX
 leax 1,X
DEAL10 clra
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
DEAL40 clrb
 rts

SCHBIT ldd R$D,U Get beginning bit number
 ldx R$X,U Get bit map ptr
 bsr CnvBit
 ldy D.PROC
 ldb P$Task,Y
 bra FindBit

SSCHBIT ldd R$D,U
 ldx R$X,U
 lbsr CnvBit
 ldb D.SysTsk

FindBit pshs U,Y,X,D,CC Save registers
 clra
 clrb
 std 3,S Clear size found
 ldy R$D,U Copy beginning page number
 sty 7,S
 bra FLOB20
FLOB10 sty 7,S
FLOB15 lsr 1,S Shift mask
 bcc FLOB25 Branch if mask okay
 ror 1,S Shift mask around end
 leax 1,X Move map ptr
FLOB20 cmpx R$U,U
 bcc FLOB30 Branch if so
 ldb 2,S
 os9 F$LDABX
 sta 0,S
FLOB25 leay  1,Y
 lda 0,S Get map byte
 anda 1,S Mask bit
 bne FLOB10 Branch if in use
 tfr y,d Copy page number
 subd 7,S Subtract beginning page number
 cmpd R$Y,U Block big enough?
 bcc FLOB35 Branch if so
 cmpd 3,S Biggest so far?
 bls FLOB15 Branch if not
 std 3,S
 ldd 7,S Copy beginning page number
 std 5,S
 bra FLOB15
FLOB30 ldd 3,S Get beginning page number of largest
 std R$Y,U
 comb SET Carry
 ldd 5,S
 bra FLOB40
FLOB35 ldd 7,S
FLOB40 std R$D,U
 leas 9,S Return scratch
 rts

*
* Get process descriptor copy
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
GMODDR ldd D.ModDir+2
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
SETUSER ldx D.PROC
 ldd R$Y,U   Desired user id number
 std P$User,X
 clrb
 rts

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
 lsla
 ifge DAT.BlSz-4096
 lsla
 endc
 clrb
 addd MD$MPtr,U
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
 bcs A64A20 Branch if no memory
 clra
 clrb
A64A10 sta D,X Clear page
 incb
 bne A64A10
A64A20 rts

ALOC64 pshs X,U
 clra

ALCPD1 pshs A Save index of pd block
 clrb
 lda A,X
 beq ALPD12 Empty block (not found)
 tfr D,Y (y)=address of pd block
 clra
ALPD11 tst D,Y Available pd?
 beq ALPD13 ..yes
 addb #PDSIZE Skip to next pd
 bcc ALPD11 Repeat until end of pd block
ALPD12 orcc #CARRY Set carry - not found
ALPD13 leay D,Y Get address of path descriptor
 puls A Restore pd block index
 bcc ALCPD4 Found a pd, return it
 inca SKIP To next pd block
 cmpa #PDSIZE Last one checked?
 blo ALCPD1 ..no; keep looking
 clra
ALCPD2 tst A,X Search for an unused pdb
 beq ALCPD3 ..found one
 inca SKIP To next
 cmpa #PDSIZE All tried?
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
* (A)=Pdbt Index, (X)=Pdbt
 stb A,X
 clrb
*
* A=Index Into Pdbt Of Pdb Containing Pd
* B=Low Order Address Of Pd In Pdb
* Y=Address Of Pd
*
ALCPD4 aslb FORM Path number
 rola
 aslb
 rola
 ldb #PDSIZE-1
ALCPD5 clr B,Y
 decb
 bne ALCPD5 Clear out fresh path descriptor
 sta PD.PD,Y Set pd# in pd (indicates in use)
ALCPD9 puls X,U,PC Return carry clear

ALCPDR leas 3,S Return not enough memory error
 puls X,U,PC Return

***************
* Rtrn64
*   Return Path Descriptor To Free Status
*
* Passed: (A)=Path Number
*         (X)=D.Pdbt Path Descriptor Block Table Addr
* Returns: None
* Destroys: Cc
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
 beq RTRNP9 Impossible path number - return
 tfr D,Y Get address of pd
 clr 0,Y Mark it as unused
 clrb
 tfr D,U Get address of pdb in which pd lies
 clra
RTRNP1 tst D,U Pd in use?
 bne RTRNP9 ..yes; return
 addb #PDSIZE
 bne RTRNP1 Repeat for each pd in block
 inca (D)=$0100
 OS9 F$SRtMem Return (unused) pdb to system store
 lda 0,S
 clr A,X Mark pd unused
RTRNP9 clr ,S+ Return scratch with carry clear
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

* Find process descriptor from process ID
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
 rts
 page
*****
*
*  Deallocate RAM blocks
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
*****
*
* Map Specific Block
*
MAPBLK lda R$B,U get block count
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
 lsla
 lsla
 lsla
 ifge DAT.BlSz-4096
 lsla
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
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 cmpa R$B,U
 bcs MapB.err
ClBl.a lda R$U,U
 lsra
 lsra
 ifge DAT.BlSz-4096
 lsra
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
