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

 use defsfile

tylg     set   Systm

Revs set ReEnt+2
         mod   OS9End,name,tylg,Revs,Cold,size
u0000    rmb   1
u0001    rmb   1
u0002    rmb   1
u0003    rmb   1
u0004    rmb   1
u0005    rmb   1
u0006    rmb   1
u0007    rmb   1
u0008    rmb   1
u0009    rmb   1
u000A    rmb   2
u000C    rmb   1
u000D    rmb   1
u000E    rmb   2
u0010    rmb   2
u0012    rmb   1
u0013    rmb   1
u0014    rmb   2
u0016    rmb   10
u0020    rmb   2
u0022    rmb   2
u0024    rmb   12
u0030    rmb   9
u0039    rmb   6
u003F    rmb   1
u0040    rmb   2
u0042    rmb   2
u0044    rmb   2
u0046    rmb   2
u0048    rmb   2
u004A    rmb   2
u004C    rmb   4
u0050    rmb   4
u0054    rmb   2
u0056    rmb   2
u0058    rmb   2
u005A    rmb   10
u0064    rmb   6
u006A    rmb   14
u0078    rmb   8
u0080    rmb   25
u0099    rmb   1
u009A    rmb   2
u009C    rmb   48
u00CC    rmb   1
u00CD    rmb   3
u00D0    rmb   7
u00D7    rmb   37
u00FC    rmb   4
size     equ   .
name     equ   *
         fcs   /OS9p2/
         fcb   12
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

         ldx   #$0144
         ldy   #$0350
         stx   >$FF80
         lda   <u0000
         sty   >$FF80
         anda  #$E0
         beq   L0090
         lsla
         rola
         rola
         rola
         adda  #$08
         sta   <u0004
         lda   #$93
         sta   <u0003
         lda   #$20
         sta   <u0001
         clr   <u0003
         lda   #$41
         sta   <u0005
L0060    ldb   <u0001
         bitb  #$01
         lbne  L0193
         andb  #$20
         lda   <u0006
         anda  #$7F
         cmpd  #$0920
         bne   L0060
         lda   #$11
         sta   <u0003
         lda   #$01
         sta   <u0003
L007C    ldd   <u0000
         bitb  #$01
         lbne  L0193
         bita  #$10
         beq   L007C
         lda   #$12
         sta   <u0003
         lda   #$0A
         sta   <u0003
L0090    lda   #$11
         sta   <u0003
L0094    ldd   <u0000
         bitb  #$01
         lbne  L0193
         bita  #$10
         beq   L0094
         lda   #$8E
         sta   <u0003
         ldb   <u0006
         lda   #$0E
         sta   <u0003
         lda   #$12
         sta   <u0003
         stx   >$FF80
         lda   <u0000
         bita  #$E0
         beq   L00F7
         sty   >$FF80
         clr   <u0005
         lda   #$11
         sta   <u0003
L00C1    lda   <u0001
         bita  #$01
         lbne  L0193
         lda   <u0000
         bita  #$10
         beq   L00C1
         lda   #$48
         sta   <u0007
L00D3    lda   <u0001
         bita  #$01
         lbne  L0193
         lda   <u0000
         bita  #$10
         beq   L00D3
         lda   #$09
         sta   <u0007
L00E5    lda   <u0001
         bita  #$01
         lbne  L0193
         lda   <u0000
         bita  #$10
         beq   L00E5
         lda   #$12
         sta   <u0003
L00F7    ldx   #$0200
         stx   >$FF80
         pshs  b
         leas  -$02,s

 ldu D.Init get initializations
 ldd SysStr,U get system device name offset
         beq   Cold20
         leax  d,u
L010A    lda   #$F1
         stx   ,s
         tst   ,x+
         beq   Cold20
         os9   F$Link
         bcs   L010A
         lda   <u0014,u
         pshs  x,a
         os9   F$UnLink
         puls  x,a
         bita  $02,s
         beq   L010A
         ldx   ,s
 lda #EXEC.+READ. set both data & execution
 OS9 I$ChgDir change directories
Cold20    leas  $03,s
 ldu D.Init get initialization ptr
 ldd StdStr,U get standard I/O offset
         beq   Cold40
         leax  d,u
         ldd  ProtFlag,u   Problem - ProtFlag is only one byte
         beq   Cold40
         leay  d,u
         ldd   #$0300
         std   >$FF80
         ldd   #$00FF
         std   <u0000
         ldd   <u0000
         cmpd  #$00FF
         bne   L0162
         ldd   #$FF00
         std   <u0000
         ldd   <u0000
         cmpd  #$FF00
         bne   L0162
         clr   <u0000
         leax  ,y
L0162    ldd   #$0200
         std   >$FF80
 lda #UPDAT. open for update
 OS9 I$OPEN open path
         bcs   Cold40
 ldx D.Proc get process ptr
 sta P$PATH,X set standard input
 OS9 I$DUP count open image
 sta P$PATH+1,X set standard output
 OS9 I$DUP count open image
 sta P$PATH+2,X set standard error
Cold40 equ *
 ldu D.Init get initialization ptr
 ldd InitStr,U get initial module offset
 leax D,U get name ptr
 lda #OBJCT set type
 clrb no memory over-ride
 ldy #0 no parameters
 os9 F$Fork startup initial process
Cold80 os9 F$NProc go into normal action

L0193    ldb   #$80
         stb   <u0003
         jmp   [>$FFFE]

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
AllProc    ldx   D.PrcDBT
AllP.A    lda   ,x+
         bne   AllP.A
         leax  -$01,x
         tfr   x,d
         subd  D.PrcDBT
         tsta
         beq   AllP.B
         comb
         ldb   #$E5
         bra   AllPrXit
AllP.B    pshs  b
         ldd   #$0200
         os9   F$SRqMem
         puls  a
         bcs   AllPrXit
         sta   ,u
         tfr   u,d
         sta   ,x
         clra
         leax  u0001,u
         ldy   #$0080
AllP.C    std   ,x++
         leay  -$01,y
         bne   AllP.C
         lda   #$80
         sta   u000C,u
         ldb   #$20
         ldx   #$015F
         leay  D.BlkMap,u
AllP.D    stx   ,y++
         decb
         bne   AllP.D
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
RetProc    pshs  u,x,b,a
         ldb   ,s
         ldx   D.PrcDBT
         abx
         lda   ,x
         beq   L0478
         clrb
         stb   ,x
         tfr   d,x
         os9   F$DelTsk
         leau  ,x
         ldd   #$0200
         os9   F$SRtMem
L0478    puls  pc,u,x,b,a

Chain         pshs  u
         lbsr  AllProc
         bcc   L0483
         puls  pc,u
L0483    ldx   D.Proc
         pshs  u,x
         leax  $04,x
         leau  u0004,u
         ldy   #$007E
L048F    ldd   ,x++
         std   ,u++
         leay  -$01,y
         bne   L048F
         ldx   D.Proc
         clra
         clrb
         stb   $06,x
         std   <$13,x
         std   <$15,x
         std   <$17,x
         sta   <$19,x
         std   <$1A,x
         ldu   <$11,x
         os9   F$UnLink
         ldb   $07,x
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

InitProc    pshs  u,y,x,b,a
         ldd   D.Proc
         pshs  b,a
         stx   D.Proc
         lda   u0001,u
         ldx   u0004,u
         ldy   ,s
         leay  <$40,y
         os9   F$SLink
         bcc   L0593
         ldd   ,s
         std   D.Proc
         ldu   $04,s
         os9   F$Load
         bcc   L0593
         leas  $04,s
         puls  pc,u,y,x
L0593    stu   $02,s
         pshs  y,a
         ldu   $0B,s
         stx   u0004,u
         ldx   $07,s
         stx   D.Proc
         ldd   $05,s
         std   <$11,x
         puls  a
         cmpa  #$11
         beq   L05B7
         cmpa  #$C1
         beq   L05B7
         ldb   #$EA
L05B0    leas  $02,s
         stb   $03,s
         comb
         bra   L05FA
L05B7    ldd   #$000B
         leay  <$40,x
         ldx   <$11,x
         os9   F$LDDDXY
         cmpa  u0002,u
         bcc   L05CA
         lda   u0002,u
         clrb
L05CA    os9   F$Mem
         bcs   L05B0
         ldx   $06,s
         leay  >$01F4,x
         pshs  b,a
         subd  u0006,u
         std   $04,y
         subd  #$000C
         std   $04,x
         ldd   u0006,u
         std   $01,y
         std   $06,s
         puls  x,b,a
         std   $06,y
         ldd   u0008,u
         std   $06,s
         lda   #$80
         sta   ,y
         clra
         sta   $03,y
         clrb
         std   $08,y
         stx   $0A,y
L05FA    puls  b,a
         std   D.Proc
         puls  pc,u,y,x,b,a

Exit         ldx   D.Proc
         bsr   TermProc
         ldb   u0002,u
         stb   <$19,x
         leay  $01,x
         bra   L061F
L060D    clr   $02,y
         lbsr  GetProc
         clr   $01,y
         lda   $0C,y
         bita  #$01
         beq   L061F
         lda   ,y
         lbsr  RetProc
L061F    lda   $02,y
         bne   L060D
         leay  ,x
         ldx   #$0047
         lds   <u00CC
         pshs  cc
         orcc  #$50
         lda   $01,y
         bne   Exit35
         puls  cc
         lda   ,y
         lbsr  RetProc
         bra   L065E
L063C    cmpa  ,x
         beq   L064E
Exit35    leau  ,x
         ldx   $0D,x
         bne   L063C
         puls  cc
         lda   #$81
         sta   $0C,y
         bra   L065E
L064E    ldd   $0D,x
         std   u000D,u
         puls  cc
         ldu   $04,x
         ldu   u0008,u
         lbsr  ChildSts
         os9   F$AProc
L065E    os9   F$NProc

TermProc    pshs  u
         ldb   #$10
         leay  <$30,x
L0668    lda   ,y+
         beq   L0675
         clr   -$01,y
         pshs  b
         os9   I$Close
         puls  b
L0675    decb
         bne   L0668
         clra
         ldb   $07,x
         beq   L0685
         addb  #$07
         lsrb
         lsrb
         lsrb
         os9   F$DelImg
L0685    ldd   D.Proc
         pshs  b,a
         stx   D.Proc
         ldu   <$11,x
         os9   F$UnLink
         puls  u,b,a
         std   D.Proc
         os9   F$DelTsk
         rts

Mem      ldx   D.Proc
         ldd   u0001,u
         beq   L06EE
         addd  #$00FF
         bcc   L06A8
         ldb   #$CF
         bra   L06DF
L06A8    cmpa  $07,x
         beq   L06EE
         pshs  a
         bcc   L06BC
         deca
         ldb   #$F4
         cmpd  $04,x
         bcc   L06BC
         ldb   #$DF
         bra   L06DD
L06BC    lda   $07,x
         adda  #$07
         lsra
         lsra
         lsra
         ldb   ,s
         addb  #$07
         bcc   L06CD
         ldb   #$CF
         bra   L06DD
L06CD    lsrb
         lsrb
         lsrb
         pshs  a
         subb  ,s+
         beq   L06EA
         bcs   L06E2
         os9   F$AllImg
         bcc   L06EA
L06DD    leas  $01,s
L06DF    orcc  #$01
         rts
L06E2    pshs  b
         adda  ,s+
         negb
         os9   F$DelImg
L06EA    puls  a
         sta   $07,x
L06EE    lda   $07,x
         clrb
         std   u0001,u
         std   u0006,u
         rts

Send         ldx   D.Proc
         lda   u0001,u
         bne   L0708
         inca
L06FD    cmpa  ,x
         beq   L0703
         bsr   L0708
L0703    inca
         bne   L06FD
         clrb
         rts

L0708    lbsr  GetProc
         pshs  u,y,a,cc
         bcs   L0720
         tst   u0002,u
         bne   L0723
         ldd   $08,x
         beq   L0723
         cmpd  $08,y
         beq   L0723
         ldb   #$E0
         inc   ,s
L0720    lbra  L07AA
L0723    orcc  #$50
         ldb   u0002,u
         bne   L0731
         ldb   #$E4
         lda   $0C,y
         ora   #$02
         sta   $0C,y
L0731    lda   $0C,y
         anda  #$F7
         sta   $0C,y
         lda   <$19,y
         beq   L0745
         deca
         beq   L0745
         inc   ,s
         ldb   #$E9
         bra   L07AA
L0745    stb   <$19,y
         ldx   #$0049
         clra
         clrb
L074D    leay  ,x
         ldx   $0D,x
         beq   L0789
         ldu   $04,x
         addd  u0004,u
         cmpx  $02,s
         bne   L074D
         pshs  b,a
         lda   $0C,x
         bita  #$40
         beq   L0785
         ldd   ,s
         beq   L0785
         ldd   u0004,u
         pshs  b,a
         ldd   $02,s
         std   u0004,u
         puls  b,a
         ldu   $0D,x
         beq   L0785
         std   ,s
         lda   u000C,u
         bita  #$40
         beq   L0785
         ldu   u0004,u
         ldd   ,s
         addd  u0004,u
         std   u0004,u
L0785    leas  $02,s
         bra   L0796
L0789    ldx   #$0047
L078C    leay  ,x
         ldx   $0D,x
         beq   L07AA
         cmpx  $02,s
         bne   L078C
L0796    ldd   $0D,x
         std   $0D,y
         lda   <$19,x
         deca
         bne   L07A7
         sta   <$19,x
         lda   ,s
         tfr   a,cc
L07A7    os9   F$AProc
L07AA    puls  pc,u,y,a,cc

Intercpt         ldx   D.Proc
         ldd   u0004,u
         std   <$1A,x
         ldd   u0008,u
         std   <$1C,x
         clrb
         rts

Sleep         pshs  cc
         ldx   D.Proc
         orcc  #$50
         lda   <$19,x
         beq   L07D2
         deca
         bne   L07CB
         sta   <$19,x
L07CB    puls  cc
         os9   F$AProc
         bra   ZZZProc
L07D2    ldd   u0004,u
         beq   L081D
         subd  #$0001
         std   u0004,u
         beq   L07CB
         pshs  y,x
         ldx   #$0049
L07E2    std   u0004,u
         stx   $02,s
         ldx   $0D,x
         beq   L07FF
         lda   $0C,x
         bita  #$40
         beq   L07FF
         ldy   $04,x
         ldd   u0004,u
         subd  $04,y
         bcc   L07E2
         nega
         negb
         sbca  #$00
         std   $04,y
L07FF    puls  y,x
         lda   $0C,x
         ora   #$40
         sta   $0C,x
         ldd   $0D,y
         stx   $0D,y
         std   $0D,x
         ldx   u0004,u
         bsr   ZZZProc
         stx   u0004,u
         ldx   D.Proc
         lda   $0C,x
         anda  #$BF
         sta   $0C,x
         puls  pc,cc
L081D    ldx   #$0049
L0820    leay  ,x
         ldx   $0D,x
         bne   L0820
         ldx   D.Proc
         clra
         clrb
         stx   $0D,y
         std   $0D,x
         puls  cc

ZZZProc    pshs  pc,u,y,x
         leax  <WakeProc,pcr
         stx   $06,s
         ldx   D.Proc
         ldb   $06,x
         cmpb  D.SysTsk
         beq   L0842
         os9   F$DelTsk
L0842    ldd   $04,x
         pshs  dp,b,a,cc
         sts   $04,x
         os9   F$NProc
WakeProc    pshs  x
         ldx   D.Proc
         std   $04,x
         clrb
         puls  pc,x

SetPri         lda   u0001,u
         lbsr  GetProc
         bcs   L0870
         ldx   D.Proc
         ldd   $08,x
         beq   L0867
         cmpd  $08,y
         bne   L086D
L0867    lda   u0002,u
         sta   $0A,y
         clrb
         rts
L086D    comb
         ldb   #$E0
L0870    rts

GetID         ldx   D.Proc
         lda   ,x
         sta   u0001,u
         ldd   $08,x
         std   u0006,u
         clrb
         rts

SetSWI         ldx   D.Proc
         leay  <$13,x
         ldb   u0001,u
         decb
         cmpb  #$03
         bcc   L088F
         lslb
         ldx   u0004,u
         stx   b,y
         rts
L088F    comb
         ldb   #$E3
         rts

ClockNam    coma
         inc   $0F,s
         com   d,s

Setime         ldx   u0004,u
         tfr   dp,a
         ldb   #$28
         tfr   d,u
         ldy   D.Proc
         lda   $06,y
         ldb   D.SysTsk
         ldy   #$0006
         os9   F$Move
         ldx   D.Proc
         pshs  x
         ldx   <u004A
         stx   D.Proc
         lda   #$C1
         leax  <ClockNam,pcr
         os9   F$Link
         puls  x
         stx   D.Proc
         bcs   L08C6
         jmp   ,y

L08C6    rts

UsrABit         ldd   u0001,u
         ldx   u0004,u
         bsr   CnvBit
         ldy   D.Proc
         ldb   $06,y
         bra   SetBit

ABit         ldd   u0001,u
         ldx   u0004,u
         bsr   CnvBit
         ldb   D.SysTsk

SetBit    ldy   u0006,u
         beq   L091C
         sta   ,-s
         bmi   L08F7
         os9   F$LDABX
L08E8    ora   ,s
         leay  -$01,y
         beq   L0917
         lsr   ,s
         bcc   L08E8
         os9   F$STABX
         leax  $01,x
L08F7    lda   #$FF
         bra   L0902
L08FB    os9   F$STABX
         leax  $01,x
         leay  -$08,y
L0902    cmpy  #$0008
         bhi   L08FB
         beq   L0917
L090A    lsra
         leay  -$01,y
         bne   L090A
         coma
         sta   ,s
         os9   F$LDABX
         ora   ,s
L0917    os9   F$STABX
         leas  $01,s
L091C    clrb
         rts

CnvBit    pshs  y,b
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         leax  d,x
         puls  b
         leay  <CnvBit.T,pcr
         andb  #$07
         lda   b,y
         puls  pc,y

CnvBit.T fcb %10000000
 fcb %01000000
 fcb %00100000
 fcb %00010000
 fcb %00001000
 fcb %00000100
 fcb %00000010
 fcb %00000001

UsrDBit         ldd   u0001,u
         ldx   u0004,u
         bsr   CnvBit
         ldy   D.Proc
         ldb   $06,y
         bra   ClrBit

DBit         ldd   u0001,u
         ldx   u0004,u
         bsr   CnvBit
         ldb   D.SysTsk
ClrBit    ldy   u0006,u
         beq   L0990
         coma
         sta   ,-s
         bpl   L096C
         os9   F$LDABX
L095D    anda  ,s
         leay  -$01,y
         beq   L098B
         asr   ,s
         bcs   L095D
         os9   F$STABX
         leax  $01,x
L096C    clra
         bra   L0976
L096F    os9   F$STABX
         leax  $01,x
         leay  -$08,y
L0976    cmpy  #$0008
         bhi   L096F
         beq   L098B
         coma
L097F    lsra
         leay  -$01,y
         bne   L097F
         sta   ,s
         os9   F$LDABX
         anda  ,s
L098B    os9   F$STABX
         leas  $01,s
L0990    clrb
         rts

UsrSBit         ldd   u0001,u
         ldx   u0004,u
         bsr   CnvBit
         ldy   D.Proc
         ldb   $06,y
         bra   FindBit

SBit         ldd   u0001,u
         ldx   u0004,u
         lbsr  CnvBit
         ldb   D.SysTsk

FindBit    pshs  u,y,x,b,a,cc
         clra
         clrb
         std   $03,s
         ldy   u0001,u
         sty   $07,s
         bra   L09C1
L09B6    sty   $07,s
L09B9    lsr   $01,s
         bcc   L09CC
         ror   $01,s
         leax  $01,x
L09C1    cmpx  u0008,u
         bcc   L09EA
         ldb   $02,s
         os9   F$LDABX
         sta   ,s
L09CC    leay  $01,y
         lda   ,s
         anda  $01,s
         bne   L09B6
         tfr   y,d
         subd  $07,s
         cmpd  u0006,u
         bcc   L09F3
         cmpd  $03,s
         bls   L09B9
         std   $03,s
         ldd   $07,s
         std   $05,s
         bra   L09B9
L09EA    ldd   $03,s
         std   u0006,u
         comb
         ldd   $05,s
         bra   L09F5
L09F3    ldd   $07,s
L09F5    std   u0001,u
         leas  $09,s
         rts

GPrDsc         ldx   D.Proc
         ldb   $06,x
         lda   u0001,u
         os9   F$GProcP
         bcs   L0A12
         lda   D.SysTsk
         leax  ,y
         ldy   #$0200
         ldu   u0004,u
         os9   F$Move
L0A12    rts

GBlkMp         ldd   #$0800
         std   u0001,u
         ldd   D.BlkMap+2
         subd  D.BlkMap
         std   u0006,u
         tfr   d,y
         lda   D.SysTsk
         ldx   D.Proc
         ldb   $06,x
         ldx   D.BlkMap
         ldu   u0004,u
         os9   F$Move
         rts

GModDr         ldd   <u0046
         subd  D.ModDir
         tfr   d,y
         ldd   D.ModEnd
         subd  D.ModDir
         ldx   u0004,u
         leax  d,x
         stx   u0006,u
         ldx   D.ModDir
         stx   u0008,u
         lda   D.SysTsk
         ldx   D.Proc
         ldb   $06,x
         ldx   D.ModDir
         ldu   u0004,u
         os9   F$Move
         rts

SetUser         ldx   D.Proc
         ldd   u0006,u
         std   $08,x
         clrb
         rts

CpyMem         ldd   u0006,u
         beq   CpyMem90
         addd  u0008,u
         ldy   <u0022
         leay  <$40,y
         sty   <u0022
         leay  <-$40,y
         pshs  y,b,a
         ldy   D.Proc
         ldb   $06,y
         pshs  b
         ldx   u0001,u
         leay  <$40,y
         ldb   #$20
         pshs  u,b
         ldu   $06,s
L0A7E    clra
         clrb
         os9   F$LDDDXY
         std   ,u++
         leax  $02,x
         dec   ,s
         bne   L0A7E
         puls  u,b
         ldx   u0004,u
         ldu   u0008,u
         ldy   $03,s
L0A94    cmpx  #$0800
         bcs   L0AA1
         leax  >-$0800,x
         leay  $02,y
         bra   L0A94
L0AA1    os9   F$LDAXY
         ldb   ,s
         pshs  x
         leax  ,u+
         os9   F$STABX
         puls  x
         leax  $01,x
         cmpu  $01,s
         bcs   L0A94
         puls  y,x,b
         sty   <u0022
CpyMem90    clrb
         rts

UnLoad         pshs  u
         lda   u0001,u
         ldx   D.Proc
         leay  <$40,x
         ldx   u0004,u
         os9   F$FModul
         puls  y
         bcs   L0B07
         stx   $04,y
         ldx   u0006,u
         beq   L0ADB
         leax  -$01,x
         stx   u0006,u
         bne   L0B06
L0ADB    cmpa  #$D0
         bcs   L0B03
         clra
         ldx   [,u]
         ldy   <u004C
L0AE5    adda  #$02
         cmpa  #$40
         bcc   L0B03
         cmpx  a,y
         bne   L0AE5
         lsla
         lsla
         clrb
         addd  u0004,u
         tfr   d,x
         os9   F$IODel
         bcc   L0B03
         ldx   u0006,u
         leax  $01,x
         stx   u0006,u
         bra   L0B07
L0B03    lbsr  ClrDir
L0B06    clrb
L0B07    rts

F64         lda   u0001,u
         ldx   u0004,u
         bsr   FindPD
         bcs   L0B13
         sty   u0006,u
L0B13    rts

FindPD    pshs  b,a
         tsta
         beq   L0B28
         clrb
         lsra
         rorb
         lsra
         rorb
         lda   a,x
         tfr   d,y
         beq   L0B28
         tst   ,y
         bne   L0B29
L0B28    coma
L0B29    puls  pc,b,a

A64         ldx   u0004,u
         bne   L0B37
         bsr   L0B41
         bcs   L0B40
         stx   ,x
         stx   u0004,u
L0B37    bsr   L0B57
         bcs   L0B40
         sta   u0001,u
         sty   u0006,u
L0B40    rts

L0B41    pshs  u
         ldd   #$0100
         os9   F$SRqMem
         leax  ,u
         puls  u
         bcs   L0B56
         clra
         clrb
L0B51    sta   d,x
         incb
         bne   L0B51
L0B56    rts

L0B57    pshs  u,x
         clra

ALCPD1    pshs  a
         clrb
         lda   a,x
         beq   L0B6C
         tfr   d,y
         clra
L0B64    tst   d,y
         beq   L0B6E
         addb  #$40
         bcc   L0B64
L0B6C    orcc  #$01
L0B6E    leay  d,y
         puls  a
         bcc   L0B99
         inca
         cmpa  #$40
         bcs   ALCPD1
         clra
L0B7A    tst   a,x
         beq   L0B88
         inca
         cmpa  #$40
         bcs   L0B7A
         comb
         ldb   #$C8
         bra   L0BA6

L0B88    pshs  x,a
         bsr   L0B41
         bcs   L0BA8
         leay  ,x
         tfr   x,d
         tfr   a,b
         puls  x,a
         stb   a,x
         clrb

L0B99    lslb
         rola
         lslb
         rola
         ldb   #$3F
L0B9F    clr   b,y
         decb
         bne   L0B9F
         sta   ,y
L0BA6    puls  pc,u,x

L0BA8    leas  $03,s
         puls  pc,u,x

R64         lda   u0001,u
         ldx   u0004,u
         pshs  u,y,x,b,a
         clrb
         tsta
         beq   L0BDA
         lsra
         rorb
         lsra
         rorb
         pshs  a
         lda   a,x
         beq   L0BD8
         tfr   d,y
         clr   ,y
         clrb
         tfr   d,u
         clra
L0BC8    tst   d,u
         bne   L0BD8
         addb  #$40
         bne   L0BC8
         inca
         os9   F$SRtMem
         lda   ,s
         clr   a,x
L0BD8    clr   ,s+
L0BDA    puls  pc,u,y,x,b,a

GetPrc         lda   u0001,u
         bsr   GetProc
         bcs   L0BE5
         sty   u0006,u
L0BE5    rts

GetProc    pshs  x,b,a
         ldb   ,s
         beq   L0BF8
         ldx   D.PrcDBT
         abx
         lda   ,x
         beq   L0BF8
         clrb
         tfr   d,y
         puls  pc,x,b,a
L0BF8    puls  x,b,a
         comb
         ldb   #$EE
         rts

DelImg         ldx   u0004,u
         ldd   u0001,u
         leau  <$40,x
         lsla
         leau  a,u
         clra
         tfr   d,y
         pshs  x
DelImg10    ldd   ,u
 ifne DAT.WrPr+DAT.WrEn
 anda #1
 endc
 addd D.BlkMap get block map entry ptr
 tfr D,X copy it
 lda 0,X get block flags
 anda #^RAMInUse clear RAM in use flag
 sta 0,X update entry
         ldd   #$015F
         std   ,u++
         leay  -$01,y
         bne   DelImg10
         puls  x
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         clrb
         rts

MapBlk        lda   u0002,u
         cmpa  #$20
         bcc   MapB.err
         leas  <-$40,s
         ldx   u0004,u
         leay  ,s
L0C3B    stx   ,y++
         leax  $01,x
         deca
         bne   L0C3B
         ldb   u0002,u
         ldx   D.Proc
         leay  <$40,x
         os9   F$FreeHB
         bcs   MapB.xit
         pshs  b,a
         lsla
         lsla
         lsla
         clrb
         std   u0008,u
         puls  b,a
         leau  ,s
         os9   F$SetImg
MapB.xit    leas  <$40,s
         rts

MapB.err    comb
         ldb   #$DB
         rts

ClrBlk         ldb   u0002,u
         beq   ClBl.c
         ldd   u0008,u
         tstb
         bne   MapB.err
         bita  #$07
         bne   MapB.err
         ldx   D.Proc
         lda   $04,x
         anda  #$F8
         suba  u0008,u
         bcs   L0C83
         lsra
         lsra
         lsra
         cmpa  u0002,u
         bcs   MapB.err
L0C83    lda   $0C,x
         ora   #$10
         sta   $0C,x
         lda   u0008,u
         lsra
         lsra
         leay  <$40,x
         leay  a,y
         ldb   u0002,u
         ldx   #$015F
ClBl.b    stx   ,y++
         decb
         bne   ClBl.b
ClBl.c    clrb
         rts

DelRAM         ldb   u0002,u
         beq   L0CC4
         ldd   D.BlkMap+2
         subd  D.BlkMap
         subd  u0004,u
         bls   L0CC4
         tsta
         bne   L0CB3
         cmpb  u0002,u
         bcc   L0CB3
         stb   u0002,u
L0CB3    ldx   D.BlkMap
         ldd   u0004,u
         leax  d,x
         ldb   u0002,u
L0CBB    lda   ,x
         anda  #$FE
         sta   ,x+
         decb
         bne   L0CBB
L0CC4    clrb
         rts

Sewage         ldx   D.ModDir
         bra   L0CD0
L0CCA    ldu   ,x
         beq   L0CD6
         leax  $08,x
L0CD0    cmpx  D.ModEnd
         bne   L0CCA
         bra   L0CFE
L0CD6    tfr   x,y
         bra   L0CDE
L0CDA    ldu   ,y
         bne   L0CE7
L0CDE    leay  $08,y
         cmpy  D.ModEnd
         bne   L0CDA
         bra   L0CFC
L0CE7    ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         cmpy  D.ModEnd
         bne   L0CDA
L0CFC    stx   D.ModEnd
L0CFE    ldx   <u0046
         bra   L0D06
L0D02    ldu   ,x
         beq   L0D0E
L0D06    leax  -$02,x
         cmpx  <u005A
         bne   L0D02
         bra   L0D46
L0D0E    ldu   -$02,x
         bne   L0D06
         tfr   x,y
         bra   L0D1A
L0D16    ldu   ,y
         bne   L0D23
L0D1A    leay  -$02,y
L0D1C    cmpy  <u005A
         bcc   L0D16
         bra   L0D34
L0D23    leay  $02,y
         ldu   ,y
         stu   ,x
L0D29    ldu   ,--y
         stu   ,--x
         beq   L0D3A
         cmpy  <u005A
         bne   L0D29
L0D34    stx   <u005A
         bsr   ChgImgP
         bra   L0D46
L0D3A    leay  $02,y
         leax  $02,x
         bsr   ChgImgP
         leay  -$04,y
         leax  -$02,x
         bra   L0D1C
L0D46    clrb
         rts

ChgImgP    pshs  u
         ldu   D.ModDir
         bra   L0D57
L0D4E    cmpy  ,u
         bne   L0D55
         stx   ,u
L0D55    leau  u0008,u
L0D57    cmpu  D.ModEnd
         bne   L0D4E
         puls  pc,u
         emod
OS9End      equ   *
