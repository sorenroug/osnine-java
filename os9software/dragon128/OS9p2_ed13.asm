 nam OS-9 Level II V1.2, part 2
 ttl Module Header
 spc 5
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
 spc 2
* Originally from Dragon 128, courtesy of Richard Harding
 spc 2
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
*
*     3     82/10/1      Addition of Profitel & Gimix2 CPU types
*
*     4     82/11/22     Correction of F$Chain error recovery bug
*
*     5     82/12/15     Correction of F$Send return of timed-sleep
*                        ticks-remaining bug
*
*     6     82/12/27     Addition of F$MapBlk and F$ClrBlk system calls
*
*     7     83/01/19     Delete link to "Init"; add RAM limiting;
*                        move "IOHook" from "OS9p1" here;
*                        change "TermProc" to return task number
*
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

 fcb 13 edition number
 use defsfile
 ttl Coldstart Routines
 page
*************************************************************
*
*    Routine Cold
*
*   System Coldstart continued; add more service requests,
* set default directories, start initial process
*
Cold leay SvcTbl,pcr get service routine initial
 OS9 F$SSvc install service routines
 ldu D.Init get initializations
 ldd MaxMem,U get memory limit
 lsra convert to block number
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
Cold25 ldx D.Proc get process ptr
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
 ldu D.Init get initialization ptr
 ldd InitStr,U get initial module offset
 leax D,U get name ptr
 lda #OBJCT set type
 clrb no memory over-ride
 ldy #0 no parameters
 os9 F$Fork startup initial process
Cold80 os9 F$NProc go into normal action

** Note F$NProc does not return!!

P3name fcs "OS9p3"


 ttl Coldstart Constants
 page
************************************************************
*
*     Service Routines Initialization Table
*
SvcTbl equ *
 fcb F$Unlink
 fdb UnLink-*-2
 fcb F$Fork
 fdb Fork-*-2
 fcb F$Wait
 fdb Wait-*-2
 fcb F$Chain
 fdb Chain-*-2
 fcb F$Exit
 fdb Exit-*-2
 fcb F$Mem
 fdb Mem-*-2
 fcb F$Send
 fdb Send-*-2
 fcb F$ICPT
 fdb Intercpt-*-2
 fcb F$Sleep
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
 fdb ABit-*-2
 fcb F$DelBit
 fdb UsrDBit-*-2
 fcb F$DelBit+SysState
 fdb DBit-*-2
 fcb F$GPrDsc
 fdb GPrDsc-*-2
 fcb F$GBlkMp
 fdb GBlkMp-*-2
 fcb F$GModDr
 fdb GModDr-*-2
 fcb F$CpyMem
 fdb CpyMem-*-2
 fcb F$SUser
 fdb SetUser-*-2
 fcb F$UnLoad
 fdb UnLoad-*-2
 fcb F$Find64+SysState
 fdb F64-*-2
 fcb F$All64+SysState
 fdb A64-*-2
 fcb F$Ret64+SysState
 fdb R64-*-2
 fcb F$GProcP+SysState
 fdb GetPrc-*-2
 fcb F$DelImg+SysState
 fdb DelImg-*-2
 fcb F$AllPrc+SysState
 fdb AllPrc-*-2
 fcb F$DelPrc+SysState
 fdb DELPRC-*-2
 fcb F$MapBlk
 fdb MapBlk-*-2
 fcb F$ClrBlk
 fdb ClrBlk-*-2
 fcb F$DelRam
 fdb DelRAM-*-2
 fcb F$GCMDir+SysState
 fdb Sewage-*-2
 fcb $7F
 fdb IOHook-*-2
 fcb $80


 ttl System Service Request Routines
 page
************************************************************
*
*     Subroutine IOHook
*
*   Handle locating IOMan; attempts to Bootstrap if not found
*
* Input: Y - Service Dispatch Table ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: Boot
*
IOStr fcs "IOMan"
IOHook pshs D,X,Y,U save registers
 bsr IOLink link IOMan
 bcc IOHook10 branch if found
 os9 F$Boot IOMan not found, try boot
 bcs IOHook20 branch if not successful
 bsr IOLink Link IOMan again
 bcs IOHook20 branch if not found
IOHook10 jsr 0,Y call IOMan init
 puls D,X,Y,U retrieve registers
 ldx IOEntry,Y get IOMan entry
 jmp 0,x
IOHook20 stb 1,S return error code
 puls D,X,Y,U,PC

IOLink leax IOStr,PCR get IOMan name ptr
 lda #SYSTM+OBJCT get type
 OS9 F$LINK
 rts
 page
************************************************************
*
*      Subroutine UnLink
*
*   Service routine to locate a Module in the Module Directory
*   and decrement its link count, removing it from the directory
*   if its link count reaches zero
*
* Input: U = registers ptr
*            R$U,u = Module ptr
*
* Output: Carry clear if successful; set otherwise
*
* Data: D.Proc, D.BlkMap, D.ModDir
*
* Calls: none
*
UnLink pshs u,d save registers
 ldd R$U,U get module ptr
 ldx R$U,U get module ptr
 lsra get DAT image index
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 sta 0,s save it
 beq UnLinkX1 branch if none
 ldu D.Proc get process ptr
 leay P$DATImg,u get DAT image ptr
 asla shift for two-byte entries
 ldd A,Y get DAT image
 ldu D.BlkMap get block map ptr
 ifne DAT.WrPr+DAT.WrEn
 anda #1
 endc
 ldb d,u get block flags
 bitb #ModBlock are there modules there?
 beq UnLinkX1 branch if not
 leau P$Links-P$DATImg,Y get block links ptr
 bra UnLink15
UnLink10 dec 0,s count index down
 beq UnLinkX1 branch if lost
UnLink15 ldb 0,S get DAT index
 aslb shift for two-byte entries
 ldd B,U get block link count
 beq UnLink10 branch if not beginning
 lda 0,S get DAT index
 asla make module ptr offset
 asla
 ifge DAT.BlSz-2048
 asla
 ifge DAT.BlSz-4096
 asla
 endc
 endc
 clrb
 nega
 leax D,X get expect module ptr
 ldb 0,S get DAT index
 aslb shift for two-byte entries
 ldd B,Y get block number
 ifne DAT.WrPr+DAT.WrEn
 anda #1
 endc
 ldu D.ModDir get module directory ptr
 bra UnLink25
UnLink20 leau MD$ESize,U move to next entry
 cmpu D.ModEnd is there another?
 bcs UnLink25 branch if so
UnLinkX1 bra UnLink80
UnLink25 cmpx MD$MPtr,U do ptrs match?
 bne UnLink20 branch if not
 cmpd [MD$MPDAT,U] do block numbers match?
 bne UnLink20 branch if not
 ldx MD$Link,U get module link count
 beq UnLink30 branch if not in use
 leax -1,X decrease use
 stx MD$Link,U update link count
 bne UnLink70 branch if still in use
UnLink30 ldx 2,S get registers ptr
 ldx R$U,X get module ptr
 ldd #M$Type get module type offset
 OS9 F$LDDDXY get module type
 cmpa #FLMGR is it I/O module?
 bcs UnLink35 branch if not
 os9 F$IODel remove from I/O system
 bcc UnLink35 branch if no error
 ldx MD$Link,U get link count
 leax 1,X reset link count
 stx MD$Link,U
 bra UnLinErr
UnLink35 bsr ClrDir clear directory entry
UnLink70 ldb 0,S get DAT index
 aslb shift for two-byte entries
 leay b,y make DAT image ptr
 ldx P$Links-P$DATImg,y get link count
 leax -1,X count link down
 stx P$Links-P$DATImg,y update link count
 bne UnLink80 branch if block in use
 ldd MD$MBSiz,U get block size
 bsr BlkCnt get block count
 ldx #DAT.Free get free block code
UnLink75 stx ,Y++ mark DAT free
 deca count block
 bne UnLink75 branch if more
UnLink80 clrb clear carry
UnLinErr leas 2,s return scratch
 puls pc,u


ClrDir ldx D.BlkMap get block map ptr
 ldd [MD$MPDAT,U] get module block number
 lda D,X get block flags
 bmi ClrD.F branch if not-RAM
 ldx D.ModDir get module directory ptr
ClrD.A ldd [MD$MPDAT,X] get next block number
 cmpd [MD$MPDAT,U] is it this block?
 bne ClrD.B branch if not
 ldd MD$Link,X get link count
 bne ClrD.F branch if in use
ClrD.B leax MD$ESize,X move to next entry
 cmpx D.ModEnd is there another?
 bcs ClrD.A branch if so
 ldx D.BlkMap get block map ptr
 ldd MD$MBSiz,U get module block size
 bsr BlkCnt
 pshs y save y-reg
 ldy MD$MPDAT,U get mod DAT image ptr
ClrD.C pshs x,a save count, blkmap
 ldd 0,Y get block number
 clr ,Y+
 clr ,Y+ clear out DAT image ptr
 leax D,X get ptr to blk status
 ldb 0,X get status bits
 andb #^(ModBlock+RAMinUse) clear module and Ram in use
 stb 0,X save bits
 puls X,A get count, blkmap ptr
 deca next block
 bne ClrD.C branch back till done
 puls Y restore y-reg
 ldx D.ModDir get Module Directory ptr
 ldd MD$MPDAT,U get DAT image ptr
ClrD.D cmpd MD$MPDAT,X this module in group?
 bne ClrD.E branch if not
 clr MD$MPDAT,x clear entry
 clr MD$MPDAT+1,x
ClrD.E leax MD$ESize,x move to next entry
 cmpx D.ModEnd is there another?
 bcs ClrD.D branch if so
ClrD.F rts


BlkCnt addd #DAT.Blsz-1 round to next block
 lsra get block count
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
 ldx D.Proc get parent process ptr
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
 tfr D,U copy it
 ldb P$Task,X get destination task
 ldx D.Proc get parent ptr
 lda P$Task,X get source task
 leax 0,Y copy source ptr
 puls Y get byte count
 os9 F$Move move parameter area
 ldx 0,S get child ptr
 lda D.SysTsk get system task
 ldu P$SP,X get process stack
 leax P$Stack-R$Size,X get local stack
 ldy #R$Size get byte count
 os9 F$Move copy stack to process
 puls U,X retrieve child & registers ptr
 os9 F$DelTsk deallocate child task number
 ldy D.Proc get parent process
 lda P$ID,X get child process ID
 sta R$A,U return it to parent
 ldb P$CID,Y get parent's child ID
 sta P$CID,Y install new child
 lda P$ID,Y get parent process id
 std P$PID,X install parent & siblings
 lda P$State,X get child state
 anda #^SysState clear system state
 sta P$State,X update state
 OS9 F$AProc put child in active queue
 rts
ForkErr puls x retrieve child process ptr
 pshs b save error code
 lbsr TermProc infanticide !
 lda 0,X get process ID
 lbsr RetProc dispose of body
 comb set carry
 puls pc,u,b
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
* Input: none
*
* Output: X   destroyed
*         U = Process Descriptor ptr
*
* Data: D.PrcDBT
*
* Calls: none
*
AllProc ldx D.PrcDBT get process descriptor table ptr
AllP.A lda ,X+ is next entry free?
 bne AllP.A branch if not
 leax -1,X backup to free entry
 tfr X,D copy table ptr
 subd D.PrcDBT get process number
 tsta still in table?
 beq AllP.B branch if so
 comb set carry
 ldb #E$PrcFul err: Process Table Full
 bra AllPrXit
AllP.B pshs b save process number
 ldd #P$Size get process descriptor size
 os9 F$SRqMem get memory
 puls a retrieve process number
 bcs AllPrXit branch if no memory
 sta P$ID,u set process number
 tfr u,d copy process descriptor ptr
 sta 0,X set table entry
 clra
 leax 1,U skip process ID
 ldy #P$Size/4 clear first half of descriptor
AllP.C std ,X++ clear process descriptor
 leay -1,Y count bytes
 bne AllP.C
 lda #SysState set system state
 sta P$State,u
 ldb #DAT.BlUs get usable block count
 ldx #DAT.Free get free block code
 leay P$DATImg,U get new DAT image ptr
AllP.D stx ,Y++ clear DAT image
 decb count block
 bne AllP.D branch if more
 ifne DAT.BlCt-DAT.BlUs
 ifeq CPUType-DRG128
* I suspect that Vivaway has changed the next line
* without a conditional for drg128
 ldx #IOBlock
 else
 ldx #ROMBlock
 endc
 stx ,y++
 endc
 ifne EXTERR
 leay P$ErrNam,u copy error messages path name
 ldx D.Proc
 leax P$ErrNam,x inherit parent's
 ldb #ErrNamSz area size
AllP.E lda ,x+ copy name
 sta ,y+
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
* Input: U = registers ptr
*            R$A,u = Process ID
*
* Output: Carry clear if successful; set otherwise
*
* Data: none
*
* Calls: RetProc
*
DelPrc lda R$A,U get process ID
 bra RetProc
 page
************************************************************
*
*  Subroutine Wait
*
* Wait for Child Process to Exit
*
* Input: U = registers ptr
*
* Output: Carry clear if successful; set otherwise
*
* Data: D.Proc, D.WProcQ
*
* Calls: ChildSts, ZZZProc
*
Wait ldx D.Proc get process ptr
 lda P$CID,X get first child ID
 beq NoChdErr branch if none
Wait10 lbsr GetProc get process ptr
 lda P$State,Y get process state
 bita #DEAD is it dead process?
 bne ChildSts branch if so
 lda P$SID,Y is there another child?
 bne Wait10 branch if so
 sta R$A,U return process number
 pshs CC save interrupt masks
 orcc #IntMasks set interrupt masks
 ldd D.WProcQ get waiting process queue ptr
 std P$Queue,X link to new process
 stx D.WProcQ set new queue
 puls cc retrieve interrupt masks
 lbra ZZZProc
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
* Output: Carry clear
*
* Data: none
*
* Calls: RetProc
*
ChildSts lda P$ID,Y get child process ID
 ldb P$Signal,Y get exit status
 std R$D,U return to parent
 leau 0,Y copy child process ptr
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
*     Subroutine RetProc
*
*   Return process descriptor memory to free
*
* Input: A = Process ID
*
* Output: Carry clear
*
* Data: D.PrcDBT
*
* Calls: none
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
RetPrc10 puls pc,u,x,b,a
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
Chain.A ldx D.Proc get process ptr
 pshs U,X save registers
 leax P$SP,X skip process linkages
 leau P$SP,U
 ldy #P$Size/4-2 get byte count
Chain.B ldd ,X++ get data
 std ,U++ copy it
 leay -1,Y count double byte
 bne Chain.B branch if more
 ldx D.Proc get process ptr
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
 stu D.Proc make it current
 ldu 4,S get registers ptr
 lbsr InitProc initialize process
 lbcs ChainErr branch if error
 pshs d save byte count
 os9 F$AllTsk get process task number
 bcc Chain.D branch if no error
*
* >>> need error routine here
*
Chain.D ldu D.Proc get process copy ptr
 lda P$Task,U get source task
 ldb P$Task,X get destination task
 leau (P$Stack-R$Size),X get new registers
 leax 0,Y copy source ptr
 ldu R$X,U get destination ptr
 pshs u copy destination ptr
 cmpx ,S++ moving down?
 puls y retrieve byte count
 bhi Chain20 branch if so
 beq Chain30 branch if no movement
 leay 0,Y zero byte count?
 beq Chain30 branch if so
 pshs X,D save registers
 tfr Y,D copy byte count
 leax d,X get source end ptr
 pshs u save destination ptr
 cmpx ,S++ is there overlap?
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
 std D.Proc set current process
 lda P$State,X get process state
 anda #^SysState clear system state
 sta P$State,X update state
 os9 F$AProc put in active process queue
 os9 F$NProc start next process
ChainErr puls u,x retrieve process ptrs
 stx D.Proc restore current process ptr
 pshs b save error code
 lda P$ID,U get new process ID
 lbsr RetProc return process descriptor
 puls b retrieve error code
 os9 F$Exit kill process
 page
************************************************************
*
*     Subroutine InitProc
*
*   Initialize Process Descriptor
*
* Input: X = Process Descriptor ptr
*        Y = DAT image ptr
*        U = registers ptr
*
* Output: D = Parameter size
*         Y = Parameter ptr
*         Carry clear if successful; set otherwise
*
* Data: D.Proc
*
* Calls: none
*
InitProc pshs u,y,x,d save registers
stacked set 8 track stacking
paramsiz set -stacked
newproc set -stacked+2
paramptr set -stacked+4
regsptr set -stacked+6
 ldd D.Proc get current process
 pshs D save it
stacked set stacked+2
currproc set -stacked
 stx D.Proc make new process current
 lda R$A,U get desired type/language
 ldx R$X,U get name string ptr
 ldy currproc+stacked,s get current process
 leay P$DATImg,Y get DAT image ptr
 os9 F$SLink link to module
 bcc Init.A branch if found
 ldd currproc+stacked,S get current process
 std D.Proc reset it
 ldu newproc+stacked,s get new process ptr
 os9 F$Load try to load module
 bcc Init.A branch if loaded
 leas newproc+stacked,s return scratch
 puls pc,u,y,x
Init.A stu paramsiz+stacked,s save module ptr
 pshs y,a
stacked set stacked+3 track stacking
modtype set -stacked
modentry set -stacked+1
 ldu regsptr+stacked,s get registers ptr
 stx R$X,u return updated name ptr
 ldx newproc+stacked,s get new process ptr
 stx D.Proc set current process ptr
 ldd paramsiz+stacked,s get module ptr
 std P$PModul,X set primary module
 puls a retrieve type/language
stacked set stacked-1 track stacking
 cmpa #Prgrm+Objct is it executable?
 beq Init.B branch if so
 cmpa #Systm+Objct is it executable?
 beq Init.B branch if so
 ldb #E$NEMod err: Non-Executable module
InitPErr leas currproc+stacked,s dump scratch
 stb paramsiz+1-currproc,s save error
 comb set carry
 bra InitPXit
Init.B ldd #M$Mem get module memory offset
 leay P$DATImg,X get DAT image ptr
 ldx P$PModul,X get module ptr
 os9 F$LDDDXY get module memory
 cmpa R$B,U is memory override larger?
 bcc Init.C branch if not
 lda R$B,U get override size
 clrb clear LSB
Init.C os9 F$Mem set process memory
 bcs InitPErr
 ldx newproc+stacked,s get new process ptr
 leay P$Stack-R$Size,x get new stack ptr
 pshs d save memory size
stacked set stacked+2 track stacking
 subd R$Y,U get parameter ptr
 std R$X,Y set it
 subd #R$Size get new stack ptr
 std P$SP,X set it
 ldd R$Y,U get parameter size
 std R$D,Y set it
 std paramsiz+stacked,s return to user
 puls x,d retrieve memory size & entry ptr
stacked set stacked-4 track stacking
 std R$Y,Y set memory limit
 ldd R$U,U get parameter ptr
 std paramptr+stacked,s return it
 lda #Entire get full registers flag
 sta R$CC,Y set condition codes
 clra
 sta R$DP,Y clear direct page
 clrb
 std R$U,Y clear base ptr
 stx R$PC,Y set program counter
InitPXit puls d retrieve current process ptr
stacked set stacked-2
 std D.Proc reset it
 puls pc,u,y,x,d
 page
************************************************************
*
*     Subroutine Exit
*
*   Process Exit Service routine
*
* Input: U = registers ptr
*            R$B,u = exit status
*
* Output: Carry clear if successful; set otherwise
*
* Data: D.Proc
*
* Calls: RetProc
*
Exit ldx D.Proc get process ptr
 bsr TermProc clear process resources
 ldb R$B,U get exit status
 stb P$Signal,X save it
 leay P$CID-P$SID,x make sibling of self
 bra Exit25
Exit20 clr P$SID,Y clear sibling link
 lbsr GetProc get process ptr
 clr P$PID,Y clear parent process ID
 lda P$State,Y get process state
 bita #DEAD is process dead?
 beq Exit25 branch if not
 lda P$ID,Y get process id
 lbsr RetProc release process descriptor
Exit25 lda P$SID,Y get next sibling
 bne Exit20 branch if one exists
 leay 0,X copy child process ptr
 ldx #D.WProcQ-P$Queue make process of root
 lds D.SysStk move stack to safety
 pshs CC save interrupt masks
 orcc #IntMasks set interrupt masks
 lda P$PID,Y get parent process ID
 bne Exit35 branch if it exists
 puls CC retrieve interrupt masks
 lda P$ID,Y get process ID
 lbsr RetProc release process descriptor
 bra Exit45
Exit30 cmpa P$ID,X is this parent process?
 beq Exit40 branch if so
Exit35 leau 0,X copy process ptr
 ldx P$Queue,X get next process in queue
 bne Exit30 branch if one exists
 puls CC retrieve interrupt masks
 lda #SysState+Dead mark process dead
 sta P$State,Y
 bra Exit45
Exit40 ldd P$Queue,X get remainder of queue
 std P$Queue,U remove parent process
 puls CC retrieve interrupt masks
 ldu P$SP,X get parent suspend stack
 ldu R$U,U get parent wait stack
 lbsr ChildSts return exit status to parent
 os9 F$AProc activate parent process
Exit45 os9 F$NProc start next process

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
Term.C ldd D.Proc get current process ptr
 pshs d save it
 stx D.Proc make process current
 ldu P$PModul,X get primary module ptr
 os9 F$UnLink release module
 puls u,d retrieve current process & register
 std D.Proc reset it
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
Mem ldx D.Proc get process ptr
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
Send ldx D.Proc get sending process ptr
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
 ldd 0,S any ticks remaining?
 beq SendS35 branch if none
 ldd R$X,U get delta tick count
 pshs D save it
 ldd 2,S get ticks remaining
 std R$X,U return to caller
 puls D retrieve delta tick count
 ldu P$Queue,X get following process ptr
 beq SendS35 branch if none
 std 0,S save delta tick count
 lda P$State,U get following process state
 bita #TimSleep is it in timed sleep?
 beq SendS35 branch if not timed sleep
 ldu P$SP,U get following stack ptr
 ldd 0,S get delta tick count
 addd R$X,U add it to following
 std R$X,U update following delta tick count
SendS35 leas 2,S return scratch
 bra SendS60
SendS40 ldx #D.WProcQ-P$Queue make process of wait root
SendS50 leay 0,X copy process ptr
 ldx P$Queue,X get next process ptr
 beq SendS90 branch if none
 cmpx 2,S is it receiving process?
 bne SendS50
SendS60 ldd P$Queue,X get remainder of queue
 std P$Queue,Y remove receiving process
 lda P$Signal,X get signal code
 deca is it wake up?
 bne SendS70 branch if not
 sta P$Signal,X clear wake up signal
*
***V.1 - following two lines were moved from before the preceeding
*        four line to this location
 lda 0,S get interrupt masks
 tfr A,CC reset masks
SendS70 os9 F$AProc activate receiver
SendS90 puls pc,u,y,a,cc
 page
************************************************************
*
*     Subroutine Intercpt
*
*   Initialize process signal intercept variables
*
* Input: U = registers ptr
*            R$X = process intercept vector
*            R$U = process intercept data ptr
*
* Output: Carry clear
*
* Data: D.Proc
*
* Calls: none
*
Intercpt ldx D.Proc get process ptr
 ldd R$X,U get intercept vector
 std P$SigVec,X set it
 ldd R$U,U get intercept data ptr
 std P$SigDat,X set it
 clrb clear carry
 rts
 page
************************************************************
*
*     Subroutine Sleep
*
*   Sleep Service routine
*
* Input: U = reigsters ptr
*            R$X,u = ticks to sleep
*
* Output: none
*
* Data: D.Proc, D.SProcQ
*
* Calls: ZZZProc
*
Sleep pshs cc save interrupt masks
 ldx D.Proc get process ptr
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
 ldx D.Proc get process ptr
 lda P$State,X get process state
 anda #^TimSleep clear timed-sleep flag
 sta P$State,X update process state
 puls PC,CC
Sleep50 ldx #D.SProcQ-P$Queue make process of sleep root
Sleep60 leay 0,X copy process pointer
 ldx P$Queue,X get next process ptr
 bne Sleep60 branch if one exists
 ldx D.Proc get current process ptr
 clra clear remaining link
 clrb
 stx P$Queue,Y link queue to current
 std P$Queue,X link current to remaining
 puls CC retrieve interrupt masks

ZZZProc pshs PC,U,Y,X make partial stack
 leax <WakeProc,PCR get activation routine
 stx 6,S set new pc
 ldx D.Proc get process ptr
 ldb P$Task,X get process task
 cmpb D.SysTsk is this system task?
 beq ZZZPrc10 branch if so
 os9 F$DelTsk deallocate process task
ZZZPrc10 ldd P$SP,X get current stack
 pshs DP,D,CC complete stack
 sts P$SP,X mark new stack
 OS9 F$NProc start next process

WakeProc pshs X save register
 ldx D.Proc get process ptr
 std P$SP,X reset stack
 clrb clear carry
 puls pc,x
 page
************************************************************
*
*     Subroutine Setpri
*
*   Set Process priority service routine
*
* Input: U = Registers ptr
*            R$A,u = Process ID
*            R$B,u = Process Priority
*
* Output: Carry clear if successful; set otherwise
*
* Data: D.PrcDBT, D.Proc
*
* Calls: none
*
SetPri lda R$A,U get process id
 lbsr GetProc get process ptr
 bcs SetPri30 branch of not found
 ldx D.Proc get setting process ptr
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
*     Subroutine GetID
*
*   Get Process ID & User number service routine
*
* Input: U = Registers ptr
*
* Output: Carry clear
*
* Data: D.Proc
*
* Calls: none
*
GetID ldx D.Proc get Process ptr
 lda P$ID,X get Process ID
 sta R$A,U return to User
 ldd P$USER,X get User ID
 std R$Y,U return to User
 clrb clear carry
 rts
 page
************************************************************
*
*     Subroutine SetSWI
*
*   Set Process SWI Vectors service routine
*
* Input: U = Registers ptr
*            R$A,u = SWI code
*            R$X,u = SWI vector address
*
* Output: Carry clear if successful; set otherwise
*
* Data: D.Proc
*
* Calls: none
*
SetSWI ldx D.Proc get process pointer
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
* Input: U = Registers ptr
*            R$X,u = Time ptr
*
* Output: Carry clear if successful;
*         Carry set, B=error code if error
*
* Data: D.Proc, D.Year, D.Day, D.Min
*
* Calls: Clock module initialization routine
*

ClockNam fcs "Clock"

Setime ldx R$X,U get date/time ptr
 tfr DP,A
 ldb #D.TIME
 tfr D,U Destination is Sys D.TIME
 ldy D.PROC
 lda P$Task,Y
 ldb D.SysTsk
 ldy #6
 os9 F$Move copy bytes to system area
 ldx D.Proc get current process ptr
 pshs X save it
 ldx D.SysPrc get system process ptr
 stx D.Proc make it current
 lda #Systm+Objct
 leax <ClockNam,PCR
 os9 F$Link link to clock module
 puls X retrieve current process ptr
 stx D.Proc reset current process
 bcs SeTime99 ..Exit if error
 jmp 0,Y execute clock's initialization routine

SeTime99 rts
 page
************************************************************
*
*     Subroutine UsrABit
*
*   User Bit Map Allocate Service routine
*
* Input: U = registers ptr
*
* Output: Carry clear
*
* Data: D.Proc
*
* Calls: CnvBit, SetBit
*
UsrABit ldd R$D,U get beginning bit number
 ldx R$X,U get bit map ptr
 bsr CnvBit get byte ptr & mask
 ldy D.Proc get user process ptr
 ldb P$Task,Y get process task number
 bra SetBit



************************************************************
*
*     Subroutine ABit
*
*   Bit Map Allocate Service routine
*
* Input: U = registers ptr
*
* Output: Carry clear
*
* Data: D.SysTsk
*
* Calls: SetBit
*
ABit ldd R$D,U get beginning bit number
 ldx R$X,U get bit map ptr
 bsr CnvBit get byte ptr & mask
 ldb D.SysTsk get system task number
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
* Input: A = bit mask
*        B = Task Number
*        X = Bit Map ptr
*        U = registers ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: none
*
SetBit ldy R$Y,U get bit count
 beq SetB.G branch if none
 sta ,-S test & save mask
 bmi SetB.B branch if first bit of byte
 os9 F$LDABX get map byte
SetB.A ora 0,S set bit
 leay -1,Y decrement page count
 beq SetB.F branch if done
 lsr 0,S shift mask
 bcc SetB.A branch if more in this byte
 os9 F$STABX restore byte
 leax 1,X move ptr
SetB.B lda #$FF get eight pages worth
 bra SetB.D
SetB.C os9 F$STABX set eight pages
 leax 1,X move ptr
 leay -8,Y count bits
SetB.D cmpy #8 are there eight pages left?
 bhi SetB.C branch if so
 beq SetB.F branch if not
SetB.E lsra make final mask
 leay -1,Y count byte
 bne SetB.E branch if more
 coma reverse bits
 sta 0,S save byte
 os9 F$LDABX get map byte
 ora 0,S set final bits
SetB.F os9 F$STABX set map byte
 leas 1,s return scratch
SetB.G clrb clear carry
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
 lda b,y get mask
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
* Input: U = registers ptr
*
* Output: Carry clear
*
* Data: D.Proc
*
* Calls: ClrBit
*
UsrDBit ldd R$D,U get beginning bit number
 ldx R$X,U get bit map ptr
 bsr CnvBit get byte ptr & mask
 ldy D.Proc get user process ptr
 ldb P$Task,Y get process task number
 bra ClrBit


************************************************************
*
*     Subroutine DBit
*
*   Bit Map Deallocate Service routine
*
* Input: U = registers ptr
*
* Output: Carry clear
*
* Data: D.SysTsk
*
* Calls: ClrBit
*
DBit ldd R$D,U get beginning bit number
 ldx R$X,U get bit map ptr
 bsr CnvBit get byte & mask
 ldb D.SysTsk get system task number
*
*      fall through to ClrBit
*
 page
************************************************************
*
*      Subroutine ClrBit
*
*   Clear bits in bit map
*
* Input: A = bit mask
*        B = Task Number
*        X = Bit Map ptr
*        U = registers ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: none
*
ClrBit ldy R$Y,U get bit count
 beq ClrB.G branch if none
 coma reverse mask
 sta ,-s test & save it
 bpl ClrB.B branch if first bit of byte
 os9 F$LDABX get map byte
ClrB.A anda 0,S clear bit
 leay -1,Y decrement bit count
 beq ClrB.F branch if done
 asr 0,S shift mask
 bcs ClrB.A branch if more
 os9 F$STABX set map byte
 leax 1,X move map ptr
ClrB.B clra get eight clear bits
 bra ClrB.D
ClrB.C os9 F$STABX set map byte
 leax 1,X move ptr
 leay -8,Y count bits
ClrB.D cmpy #8 are there eight left?
 bhi ClrB.C branch if so
 beq ClrB.F branch if done
 coma get eight set bits
ClrB.E lsra make final mask
 leay -1,Y count bit
 bne ClrB.E branch if more
 sta 0,S save mask
 os9 F$LDABX get map byte
 anda 0,S clear bits
ClrB.F os9 F$STABX set map byte
 leas 1,S return scratch
ClrB.G clrb clear carry
 rts
 page
************************************************************
*
*      Subroutine UsrSBit
*
*   Uset Bit Map Free Search Service routine
*
* Input: U = registers ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: FindBit
*
UsrSBit ldd R$D,U get beginning bit number
 ldx R$X,U get bit map ptr
 bsr CnvBit get byte ptr & mask
 ldy D.Proc get user process ptr
 ldb P$Task,Y get process task
 bra FindBit


************************************************************
*
*      Subroutine SBit
*
*   Bit Map Free Search Service routine
*
* Input: U = Registers ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: FindBit
*
SBit ldd R$D,U get beginning bit number
 ldx R$X,U get map ptr
 lbsr CnvBit get byte ptr & mask
 ldb D.SysTsk get system task number
*
*      fall through to FindBit
*
 page
************************************************************
*
*      Subroutine FindBit
*
*   Find clear bits in bit map
*
* Input: D = beginning Bit Number
*        X = Bit Map ptr
*        Y = Bit count
*        U = Bit Map end + 1 ptr
*
* Output: D = beginning Bit Number (of block found)
*
* Data: none
*
* Calls: CnvBit
*
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
 std BitSize,s clear size found
 ldy R$D,U get beginning bit number
 sty CurBegin,s set it
 bra FindB.C
FindB.A sty CurBegin,s save beginning block number
FindB.B lsr BitMask,s shift mask
 bcc FindB.D branch if mask okay
 ror 1,s shift mask around end
 leax 1,X move map ptr
FindB.C cmpx R$U,U end of map?
 bcc FindB.E branch if so
 ldb TaskNum,s get task number
 os9 F$LDABX get map byte
 sta CurMap,s save it
FindB.D leay 1,Y move beginning bit number
 lda CurMap,s get current map byte
 anda BitMask,s mask bit
 bne FindB.A branch if in use
 tfr y,d copy bit number
 subd CurBegin,s subtract beginning bit number
 cmpd R$Y,U block big enough?
 bcc FindB.F branch if so
 cmpd BitSize,s biggest so far?
 bls FindB.B branch if not
 std BitSize,s save size
 ldd CurBegin,s copy beginning bit number
 std BitBegin,s
 bra FindB.B
FindB.E ldd BitSize,s get size of largest
 std R$Y,U return it
 comb set carry
 ldd BitBegin,s get beginning bit number of largest
 bra FindB.G
FindB.F ldd CurBegin,s get beginning bit number
FindB.G std R$D,U return it
 leas CurBegin+2,s return scratch
 rts
 page
************************************************************
*
*      Subroutine GPrDsc
*
*   Copy Process Descriptor to user
*
* Input: U = registers ptr
*            R$A = Process ID
*            R$X = 512 byte buffer pointer
*
* Output: Carry clear if successful; set otherwise
*
* Data: D.Proc
*
* Calls: none
*
GPrDsc ldx D.Proc get current process ptr
 ldb P$Task,X get process task
 lda R$A,U get Process ID
 os9 F$GProcP get process ptr
 bcs GPrDsc10
 lda D.SysTsk get source task
 leax 0,Y get Process Descriptor ptr
 ldy #P$Size get byte count
 ldu R$X,U get destination ptr
 os9 F$Move copy process descriptor
GPrDsc10 rts return



************************************************************
*
*      Subroutine GBlkMp
*
*   Copy System Block Map to user
*
* Input: U = registers ptr
*            R$X,u = 512 byte buffer ptr
*
*         R$Y,u = bytes in block map
*
* Data: D.BlkMap, D.Proc
*
* Calls: none
*
GBlkMp ldd #DAT.BlSz get byte per block
 std R$D,U return to user
 ldd D.BlkMap+2 get map end ptr
 subd D.BlkMap get map size
 std R$Y,U return to user
 tfr D,Y copy byte count
 lda D.SysTsk system task number
 ldx D.Proc get process descriptor
 ldb P$Task,X get task number
 ldx D.BlkMap get block map ptr
 ldu R$X,U destination pointer
 os9 F$Move move it.
 rts
 page
************************************************************
*
*      Subroutine GModDr
*
* Input: U = registers ptr
*            R$X,u = 2048 byte buffer ptr
*
* Output: R$Y,u = ptr to end of moddir entries
*         R$U,u = Start of moddir in system map
*
* Data: D.ModDir, D.Proc
*
* Calls: none
*
GModDr ldd D.ModDir+2 get directory end ptr
 subd D.ModDir get directory size
 tfr D,Y copy byte count
 ldd D.ModEnd get ptr to end of entries
 subd D.ModDir
 ldx R$X,U get user dest ptr
 leax D,X point to end in user map
 stx R$Y,U return it to user
 ldx D.ModDir get start on system map
 stx R$U,U return it to user
 lda D.SysTsk get system task
 ldx D.Proc get process ptr
 ldb P$Task,X get process task
 ldx D.ModDir get directory ptr
 ldu R$X,U get destination
 os9 F$Move copy directory
 rts



************************************************************
*
*      Subroutine SetUser
*
*   Set User ID system call
*
* Input: U = registers ptr
*            R$Y,u = desired User ID number
* Output: none
*
* Data: D.Proc
*
* Calls: none
*
SetUser ldx D.Proc
 ldd R$Y,U get desired User id
 std P$User,X set it
 clrb
 rts
 page
************************************************************
*
*      Subroutine CpyMem
*
*   Read External Memory system call
*
* Input: U = Register pack
*         R$D,U = Pointer to DAT image
*         R$X,U = Offset in block
*         R$Y,U = Byte count
*         R$U,U = Destination ptr in caller's addr space
*
* Data: D.Proc
*
* Calls: F$DATTmp, F$LDAXYP, F$STABX
*
CpyMem ldd R$Y,U bytecount
 beq CpyMem90 ..Zero; return
 addd R$U,U plus destination addr
 ldy D.TmpDAT allocate DAT space
 leay DAT.ImSz,Y
 sty D.TmpDAT save new value
 leay -DAT.ImSz,Y ptr to temp area
 pshs Y,D ptr to end of Destination area + 1
 ldy D.Proc
 ldb P$Task,Y
 pshs B Destination Task number
 ldx R$D,U get offset into user memory
 leay P$DATImg,Y point to user dat image
 ldb #DAT.BlCt make blk count
 pshs U,B
 ldu 6,S get ptr to dat temp
CpyMem03 clra no offset
 clrb
 os9 F$LDDDXY get dat image of memory
 std ,U++ save in temp
 leax 2,X
 dec 0,S done?
 bne CpyMem03 jif not
 puls U,B rid temp, get regs ptr
 ldx R$X,U get offset into mem
 ldu R$U,U get buffer ptr
 ldy 3,S get dat ptr
CpyMem05 cmpx #DAT.BlSZ is offset in block range?
 bcs CpyMem10 ..Yes; continue
 leax -DAT.BlSz,X reduce offset
 leay 2,Y move image ptr
 bra CpyMem05

CpyMem10 os9 F$LDAXY get (next) source byte
 ldb 0,S destination task
 pshs x save source ptr
 leax ,U+ (next) destination ptr
 os9 F$STABX move byte to caller's area
 puls x save source ptr
 leax 1,X
 cmpu 1,S end of transfer?
 bcs CpyMem05 ..No; repeat
 puls y,X,b
 sty D.TmpDAT return temporary DAT image
CpyMem90 clrb
 rts
 page
*************************************************
*
*     Subroutine UnLoad
*
*   Unlink by Name Service routine
*
* Input: U = registers ptr
*            R$A,u = Module Type
*            R$X,u = Name String ptr
*
* Output: Carry clear if successful; set otherwise
*
* Data: D.Proc, D.SysDAT
*
* Calls: ClrDir
*
UnLoad pshs U save registers ptr
 lda R$A,U get module type
 ldx D.Proc get process ptr
 leay P$DATImg,X get DAT image ptr
 ldx R$X,U get name string ptr
 os9 F$FModul search module directory
 puls Y retrieve registers ptr
 bcs UnLd.E branch if not found
 stx R$X,Y return updated name string ptr
 ldx MD$Link,U get link count
 beq UnLd.A branch if clear
 leax -1,X count down
 stx MD$Link,U update link count
 bne UnLd.D branch if still in use
UnLd.A cmpa #FlMgr is it I/O module?
 bcs UnLd.C branch if not
 clra
 ldx [MD$MPDAT,U] get group block number
 ldy D.SysDAT get system DAT image ptr
UnLd.B adda #2 get next block offset
 cmpa #DAT.ImSz end of image?
 bcc UnLd.C branch if so
 cmpx A,Y is it in system?
 bne UnLd.B branch if not
 lsla make block adjustment
 ifge DAT.BlSz-2048
 asla
 ifge DAT.BlSz-4096
 asla
 endc
 endc
 clrb
 addd MD$MPtr,U make module ptr
 tfr D,X copy it
 os9 F$IODel delete from I/O system
 bcc UnLd.C  branch if successful
 ldx MD$Link,U reset link count
 leax 1,X
 stx MD$Link,U
 bra UnLd.E
UnLd.C lbsr ClrDir clear directory entry
UnLd.D clrb clear carry
UnLd.E rts
 page
*************************************************
*
*     Subroutine F64
*
*   Find PD service routine
*
* Input: U = Registers ptr
*            R$A,u = Block number
*            R$X,u = Block pointer
*
* Output: Registers ptr
*         R$Y,u = PD address
*
* Data: none
*
* Calls: FindPD
*
F64 lda R$A,U get block number
 ldx R$X,U get block pointer
 bsr FINDPD find the block
 bcs F6410 branch if not found
 sty R$Y,U return result
F6410 rts



************************************************************
*
*     Subroutine FindPD
*
*   Find the address of a Path or Process Descriptor
*
* Input: A = PD number
*        X = PD table address
*
* Output: Carry clear if successful; set otherwise
*
* Data: none
*
* Calls: none
*
FindPD pshs D save PD number, table address
 tsta legal number?
 beq FPDerr no. Error out
 clrb
 lsra
 rorb
 lsra
 rorb divided by 4 PD's per PD block
 lda A,X map into high order PD address
 tfr D,Y Y = address of path descriptor
 beq FPDerr Pd block not allocated!
 tst 0,Y is pd in use?
 bne Findp9 allocated PD, good!
FPDerr coma error - return carry set
Findp9 puls d,pc
 page
************************************************************
*
*     Subroutine Aloc64
*
*   Allocate a Path Descriptor (64 Bytes)
*
* Input: U = Register ptr
*            R$X,u = Path Descriptor Block Table Address
*
* Output: U = Registers ptr
*             R$A = Block number
*             R$Y = PD address
*
* Data: none
*
* Calls: none
*
A64 ldx R$X,U get block pointer
 bne A6410 branch if set
 bsr A64Add add a page
 bcs A6420 branch if none
 stx 0,X init block
 stx R$X,U return the block pointer
A6410 bsr Aloc64 allocate block
 bcs A6420 branch if none
 sta R$A,U return block number
 sty R$Y,U return block pointer
A6420 rts

A64Add pshs U save registers ptr
 ldd #$100 get a page
 OS9 F$SRqMem get memory
 leax 0,U copy page pointer
 puls U retrieve registers ptr
 bcs A64Add20 branch if no memory
 clra
 clrb
A64Add10 sta D,X clear page
 incb
 bne A64Add10
A64Add20 rts

Aloc64 pshs x,u
 clra

ALCPD1 pshs A save index of PD block
 clrb
 lda a,x
 beq AlPD12 empty block (not found)
 tfr D,Y Y = address of PD block
 clra
AlPd11 tst D,Y available PD?
 beq AlPD13 ..yes
 addb #64 skip to next block
 bcc AlPD11 repeat until end of PD block
AlPD12 orcc #Carry set carry - not found
AlPD13 leay D,Y get address of path descriptor
 puls A restore PD block index
 bcc ALCPD4 found a PD, return it
 inca skip to next PD block
 cmpa #64 last one checked?
 blo ALCPD1 ..no; keep looking
 clra
AlcPD2 tst A,X search for an unused PDB
 beq AlcPD3 ..found one
 inca skip to next
 cmpa #64 all tried?
 blo AlcPD2 ..no; keep looking
 comb set carry
 ldb #E$PthFul err: path table full
 bra AlcPD9 return

AlcPD3 pshs A,X
 bsr A64Add add a page
 bcs AlcPDR allocate error
 leay 0,X set up PD address as first PD
 tfr x,d
 tfr a,b B = page address of new PD block
 puls A,X
* A = PDBT index, X = PDBT
 stb a,x
 clrb
*
* A = index into PDBT of PDB containing PD
* B = Low order address of PD in PDB
* Y = address Of PD
*
AlcPD4 aslb form path number
 rola
 aslb
 rola
 ldb #64-1
AlcPD5 clr b,y
 decb
 bne AlcPD5 clear out fresh path descriptor
 sta 0,Y mark block in use
AlcPD9 puls x,u,pc return carry clear

AlcPDR leas 3,S return not enough memory error
 puls X,U,PC return

************************************************************
*
*     Subroutine Rtrn64
*
*   Return Path Descriptor To free status
*
* Input: U = Registers ptr
*            R$A,u = block number
*            R$X,u = block pointer
*
* Output: none
*
* Data: none
*
* Calls: none
*
R64 lda R$A,U get block number
 ldx R$X,U get block ptr
 pshs D,X,Y,U save registers
 clrb clear page offset
 tsta check block number
 beq RtrnPD99 branch if bad
 lsra divide block number
 rorb >by four
 lsra >to get table index
 rorb  >and page offset
 pshs A save table index
 lda A,X get page number
 beq RtrnPD20 impossible path number - return
 tfr D,Y copy address of block
 clr 0,Y mark it as unused
 clrb get block's page address
 tfr D,U copy it
 clra
RtrnPD10 tst d,u PD in use?
 bne RtrnPD20 ..yes; return
 addb #64
 bne RtrnPD10 repeat for each PD in block
 inca D = $0100
 OS9 F$SRtMem return unused memory
 lda 0,S
 clr A,X mark page unused
RtrnPD20 clr ,S+ return scratch with carry clear
RtrnPD99 puls D,X,Y,U,PC return to caller
 page
************************************************************
*
*     Subroutine GetPrc
*
*   Get Process Descriptor ptr from Process ID service
*
* Input: U = Registers ptr
*            R$A,u = Process ID
*
* Output: Carry clear if successful; set otherwise
*
* Data: none
*
* Calls: GetProc
*
GetPrc lda R$A,U get process ID
 bsr GetProc get process ptr
 bcs GetPrc10 branch if not found
 sty R$Y,U return process ptr
GetPrc10 rts



************************************************************
*
*     Subroutine GetProc
*
*   Convert Process ID number into Process Descriptor ptr
*
* Input: A = Process ID
*
* Output: Y = Process Descriptor ptr
*
* Data: D.PrcDBT
*
* Calls: none
*
GetProc pshs X,D save register
 ldb 0,S get process ID number
 beq NoProc branch if none
 ldx D.PrcDBT get Process Table ptr
 abx get table entry ptr
 lda 0,X get process ptr MSB
 beq NoProc branch if not used
 clrb clear process LSB
 tfr d,y copy process ptr
 puls PC,X,D
NoProc puls X,B,A retrieve register
 comb set carry
 ldb #E$BPrcId err: bad process ID
RTS100 rts
 page
*************************************************
*
*     Subroutine DelImg
*
*   Deallocate RAM blocks of DAT image
*
* Input: U = registers ptr
*            R$A,u = beginning block number
*            R$B,u = block count
*            R$X,u = process descriptor ptr
*
* Output: Carry clear
*
* Data: D.BlkMap
*
* Calls: none
*
DelImg ldx R$X,u get process ptr
 ldd R$D,u get block number & count
 leau P$DATImg,x get DAT image ptr
 asla shift for two-byte entries
 leau A,U get DAT block ptr
 clra clear MSB count
 tfr D,Y copy it
 pshs X save process ptr
DelImg10 ldd 0,U get block number
 ifne DAT.WrPr+DAT.WrEn
 anda #1
 endc
 addd D.BlkMap get block map entry ptr
 tfr D,X copy it
 lda 0,X get block flags
 anda #^RAMInUse clear RAM in use flag
 sta 0,X update entry
 ldd #DAT.Free get free marker
 std ,U++ mark DAT block free
 leay -1,Y count block
 bne DelImg10 branch if more
 puls x retrieve process ptr
 lda P$State,X get process state
 ora #ImgChg mark image change
 sta P$State,X update state
 clrb clear carry
 rts
 page
*************************************************
*
*     Subroutine MapBlk
*
* Map specified block number into process address space
*
* Input: U =registers ptr
*           R$B,u = number of consecutive blocks
*           R$X,u = beginning physical block number
*
* Output: R$U,u = ptr to mapped block(s)
*
* Data: D.Proc
*
* Calls: F$FreeHB, F$SetImg
*
MapBlk lda R$B,U get block count
 cmpa #DAT.BlCt is it in range?
 bcc MapB.err branch if not
 leas -DAT.ImSz,S get scratch DAT image
 ldx R$X,U get beginning block number
 leay 0,S copy scratch ptr
MapB.a stx ,Y++ set block number
 leax 1,X get next block number
 deca count block
 bne MapB.a branch if not
 ldb R$B,U get block count
 ldx D.Proc get process ptr
 leay P$DATImg,X get DAT image ptr
 os9 F$FreeHB is there enough free?
 bcs MapB.xit branch if not
 pshs D save parameters
 asla make mapped ptr
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
 leau 0,s
 os9 F$SetImg
 endc
MapB.xit leas DAT.ImSz,S return scratch
 rts

MapB.err comb set carry
 ldb #E$IBA err: illegal block address
 rts
 page
*************************************************
*
*     Subroutine ClrBlk
*
*   Unmap specified area of process address space
*
* Input: U = registers ptr
*            R$B,u = number of blocks
*            R$U,u = beginning of area ptr
*
* Output: Carry set if error
*
* Data: D.Proc
*
* Calls: F$SetImg
*
ClrBlk ldb R$B,U get block count
 beq ClBl.c branch if do-nothing
 ldd R$U,U get area ptr
 tstb valid area ptr?
 bne MapB.err branch if not
 bita #^DAT.Addr valid area ptr?
 bne MapB.err branch if not
 ldx D.Proc get process ptr
 cmpx D.SysPrc system address space?
 beq ClBl.a ..yes; don't check stack
 lda P$SP,X get process stack ptr
 anda #DAT.Addr get block ptr
 suba R$U,U clearing stack memory?
 bcs ClBl.a branch if not
 lsra make block number
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 cmpa R$B,U clearing stack memory?
 bcs MapB.err branch if so
ClBl.a lda R$U,U get area ptr
 lsra make DAT image offset
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 leay P$DATImg,X get process DAT image ptr
 leay A,Y get block ptr
 ldb R$B,U get block count
 ldx #DAT.Free get free block number
ClBl.b stx ,Y++ clear block
 decb count it
 bne ClBl.b branch if more
 ldx D.Proc get process descriptor ptr
 lda P$State,X get process state
 ora #ImgChg mark image change
 sta P$State,X set process state
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
*************************************************
*
*     Subroutine DelRAM
*
*   Deallocate RAM blocks
*
* Input: U = registers ptr
*            R$B,u = block count
*            R$X,u = beginning block number
*
* Output: Carry clear
*
* Data: D.BlkMap
*
* Calls: none
*
DelRAM ldb R$B,U clear any blocks?
 beq DelR.xit branch if not
 ldd D.BlkMap+2 get block map end
 subd D.BlkMap get max block number
 subd R$X,U beginning block in range?
 bls DelR.xit branch if not
 tsta near end of map?
 bne DelR.a branch if not
 cmpb R$B,U all blocks in range?
 bcc DelR.a branch if so
 stb R$B,U clear known blocks
DelR.a ldx D.BlkMap get block map ptr
 ldd R$X,U get beginning block number
 leax D,X get beginning block ptr
 ldb R$B,U get block count
DerR.b lda 0,X get block flags
 anda #^RAMInUse clear RAM in use flag
 sta ,X+ update block flags
 decb count block
 bne DerR.b branch if more
DelR.xit clrb clear carry
 rts

 page
******************************************************************
*
*  Sewage: module directory garbage collect routine
*
*  collects freespace in the module directory, and in the DAT
*  image space, compacting the entries.
*
*  Input: none
*
*  Output: none
*
*  Errors: none
*
*******************************************************************
Sewage ldx D.ModDir collect freespace in dir
 bra Sew.A1
Sew.A ldu MD$MPDAT,X get dat ptr
 beq Sew.B jif empty entry
 leax MD$ESize,X next entry
Sew.A1 cmpx D.ModEnd chk if end of dir
 bne Sew.A jif not end
 bra Sew.2 do DAT compact
Sew.B tfr X,Y make ptr copy
 bra Sew.D
Sew.C ldu ,y get dat ptr
 bne Sew.E jif entry used
Sew.D leay MD$ESize,Y next entry
 cmpy D.ModEnd chk if end of dir
 bne Sew.C jif not end
 bra Sew.F do DAT compact
Sew.E ldu ,Y++ move entries over freespace
 stu ,x++
 ldu ,y++
 stu ,x++
 ldu ,y++
 stu ,x++
 ldu ,y++
 stu ,x++
 cmpy D.ModEnd chk if end of dir
 bne Sew.C back for entry check
Sew.F stx D.ModEnd save new dir end
Sew.2 ldx D.ModDir+2 collect DAT free entries
 bra Sew.G1
Sew.G ldu ,X get DAT entry
 beq Sew.H jif empty
Sew.G1 leax -2,X next entry
 cmpx D.ModDat chk if end of DAT
 bne Sew.G jif not end
 bra Sew.Exit done if none empty
Sew.H ldu -2,X chk to see if DAT img end
 bne Sew.G1 jif is just DAT img end
 tfr x,y make ptr copy
 bra Sew.J
Sew.I ldu ,Y get DAT entry
 bne Sew.K jif used
Sew.J leay -2,Y next entry
Sew.J1 cmpy D.ModDat chk if end of DAT
 bcc Sew.I jif not end
 bra Sew.L1
Sew.K leay 2,Y back up an entry
 ldu ,y copy end DAT img bytes
 stu ,x
Sew.L ldu ,--y copy DAT image
 stu ,--x
 beq Sew.M jif end bytes or free
 cmpy D.ModDat chk if end of DAT
 bne Sew.L jif not end
Sew.L1 stx D.ModDat save new DAT top
 bsr ChgImgP make idr entries point to new
 bra Sew.Exit
Sew.M leay 2,Y back up an entry
 leax 2,X
 bsr ChgImgP make dir entries point to new
 leay -4,Y skip over end of DAT img to new
 leax -2,X make x point to last free
 bra Sew.J1 back for freespace skip
Sew.Exit clrb show no errors
 rts done


* non-contiguous modules
ChgImgP pshs U save only used
 ldu D.ModDir get start of directory
 bra Chg.B
Chg.C cmpy MD$MPDAT,U chk for ol dat ptr
 bne Chg.A jif not
 stx MD$MPDAT,U substitute new DAT ptr
Chg.A leau MD$ESize,U next dir entry
Chg.B cmpu D.ModEnd chk for end of directory
 bne Chg.C jif not end
 puls PC,U done


 emod module CRC
OS9End equ *

 end
