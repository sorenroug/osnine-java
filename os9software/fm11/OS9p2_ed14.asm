         nam   OS-9 Level II V1.2, part 2
         ttl   os9 Module Header

 use  defsfile

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

************************************************************
*
*     Module Header
*
Type set Systm
Revs set ReEnt+1

 mod OS9End,OS9Name,Type,Revs,OS9Ent,256

OS9Name fcs /OS9p2/

 fcb 14 Edition

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


 ttl Coldstart Routines
 page
*****
*
* Cold Start Routines
*
*
* Initialize Service Routine Dispatch Table
*
OS9Ent leay SVCTBL,PCR Get ptr to service routine table
 OS9 F$SSVC Set service table addresses
 ldu D.Init get configuration ptr
 ldd MaxMem,u
 lsra
 rorb
 lsra
 rorb
 lsra
 rorb
 lsra
 rorb
 ifge DAT.BlSz-$2000
 lsra
 rorb
 endc
 addd D.BlkMap
 tfr d,x
 ldb #$80
 bra COLD20

COLD10 lda ,x+
 bne COLD20
 stb -1,x
COLD20 cmpx D.BlkMap+2
 bcs COLD10
COLD30 ldu D.Init
 ldd SYSSTR,U Get system device name
 beq SETSTDS No system device
 leax D,U Get name ptr
 lda #EXEC.+READ. Set both execution & data
 OS9 I$ChgDir Set default directory
 bcc SETSTDS
 os9 F$Boot
 bcc COLD30
SETSTDS ldu D.Init
 ldd STDSTR,U get name offset
 beq LOADP3
 leax D,U get name ptr
 lda #UPDAT. set mode
 OS9 I$OPEN open file
 bcc SETSTD05
 os9 F$Boot
 bcc SETSTDS
 bra LOADP3

SETSTD05 ldx D.PROC
 sta P$PATH,X set standard input
 OS9 I$DUP count open image
 sta P$PATH+1,X set standard output
 OS9 I$DUP count open image
 sta P$PATH+2,X set standard error
LOADP3 leax <OS9P3STR,pcr
 lda #SYSTM
 os9 F$Link
 bcs INITPRC
 jsr 0,y
INITPRC ldu D.Init
 ldd InitStr,U Get initial execution string
 leax D,U Get string ptr
 lda #OBJCT set type
 clrb use declared memory
 ldy #0 No parameters
 os9 F$Fork
 os9 F$NProc

OS9P3STR fcs "OS9p3"

SVCTBL equ *
 fcb F$Unlink
 fdb UNLINK-*-2
 fcb F$Fork
 fdb FORK-*-2
 fcb F$Wait
 fdb WAIT-*-2
 fcb F$Chain
 fdb CHAIN-*-2
 fcb F$EXIT
 fdb EXIT-*-2
 fcb F$MEM
 fdb USRMEM-*-2
 fcb F$SEND
 fdb SEND-*-2
 fcb F$ICPT
 fdb INTCPT-*-2
 fcb F$SLEEP
 fdb SLEEP-*-2
 fcb F$SPrior
 fdb SETPRI-*-2
 fcb F$ID
 fdb GETID-*-2
 fcb F$SSWI
 fdb SETSWI-*-2
 fcb F$STime
 fdb SETTIME-*-2
 fcb F$SchBit
 fdb SCHBIT-*-2
 fcb F$SchBit+$80
 fdb SSCHBIT-*-2
 fcb F$AllBit
 fdb ALLBIT-*-2
 fcb F$AllBit+$80
 fdb SALLBIT-*-2
 fcb F$DelBit
 fdb DELBIT-*-2
 fcb F$DelBit+$80
 fdb SDELBIT-*-2
 fcb F$GPrDsc
 fdb GPRDSC-*-2
 fcb F$GBlkMp
 fdb GBLKMP-*-2
 fcb F$GModDr
 fdb GMODDR-*-2
 fcb F$CpyMem
 fdb CPYMEM-*-2
 fcb F$SUser
 fdb SETUSER-*-2
 fcb F$Unload
 fdb UNLOAD-*-2
 fcb F$Find64+$80
 fdb F64-*-2
 fcb F$ALL64+$80
 fdb A64-*-2
 fcb F$Ret64+$80
 fdb R64-*-2
 fcb F$GProcP+$80
 fdb GPROCP-*-2
 fcb F$DelImg+$80
 fdb DELIMG-*-2
 fcb F$AllPrc+$80
 fdb ALLPRC-*-2
 fcb F$DelPrc+$80
 fdb DELPRC-*-2
 fcb F$MapBlk
 fdb MAPBLK-*-2
 fcb F$ClrBlk
 fdb CLRBLK-*-2
 fcb F$DelRam
 fdb DELRAM-*-2
 fcb F$GCMDir+$80
 fdb GCMDIR-*-2
 fcb $7F
 fdb IOHOOK-*-2
 fcb $80

 page
*****
*
*  Subroutine Iohook
*
* Handles Locating/Loading Remainder Of System
*
* Input: Y - Service Dispatch Table ptr
*
IOSTR fcs "IOMan"

IOHOOK pshs D,X,Y,U Save registers
 bsr IOLink Link ioman
 bcc IOHOOK10
 os9 F$Boot Ioman not found, boot
 bcs IOHOOK20
 bsr IOLink Link ioman again
 bcs IOHOOK20
IOHOOK10 jsr 0,Y Call ioman init
 puls D,X,Y,U Retrieve registers
 ldx 254,y Get ioman entry
 jmp 0,x
IOHOOK20 stb $01,s
 puls D,X,Y,U,PC

IOLink leax IOSTR,PCR Get ioman name ptr
 lda #SYSTM+OBJCT Get type
 OS9 F$LINK
 rts

 ttl SERVICE Routines
 page
*****
*
*  Subroutine Unlink
*
* Decrement Link Count. If Count Reaches Zero,
*    Delete Module From Directory & Return Memory
*
UNLINK pshs U,D
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
 beq UNLK08 Nothing to unlink
 ldu D.PROC
 leay P$DATImg,U
 lsla
 ldd A,Y Get block pointer
 ldu D.BlkMap
 ldb D,U
 bitb #ModBlock   Module in this block?
 beq UNLK08
 leau P$DATImg,Y
 bra UNLK04

UNLK03 dec 0,S
 beq UNLK08
UNLK04 ldb 0,S
 lslb
 ldd B,U
 beq UNLK03
 lda 0,S
 lsla Calculate address from block number
 lsla
 lsla
 lsla
 ifge DAT.BlSz-$2000
 lsla
 endc
 clrb
 nega
 leax D,X
 ldb 0,S
 lslb
 ldd B,Y
 ldu D.ModDir Get directory ptr
 bra UNLK10

UNLK06 leau MD$ESize,U Move to next entry
 cmpu D.ModEnd End of directory?
 bcs UNLK10
UNLK08 bra UNLK25

UNLK10 cmpx MD$MPtr,U Is it this module?
 bne UNLK06 ..no
 cmpd [MD$MPDAT,U] DAT match?
 bne UNLK06
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
 bra UNLK30
UNLK20 bsr UNLK40 Delete module
UNLK22 ldb 0,S
 lslb
 leay b,Y
 ldx P$DATImg,Y
 leax -1,X
 stx P$DATImg,Y
 bne UNLK25
 ldd MD$MBSiz,U
 bsr DIVBKSZ Divide by block size, rounding up
 ldx #DAT.Free
UNLK24 stx ,Y++ Mark blocks free
 deca
 bne UNLK24
UNLK25 clrb CLEAR Carry
UNLK30 leas 2,S
 puls PC,U

* Delete module from module directory & from memory
UNLK40 ldx D.BlkMap
 ldd [MD$MPDAT,U] Get module DAT image
 lda D,X Is block type ROM?
 bmi UNLKRT yes, exit
 ldx D.ModDir
UNLK45 ldd [MD$MPDAT,X]
 cmpd [MD$MPDAT,U] Match
 bne UNLK48
 ldd MD$Link,X Get number of links
 bne UNLKRT exit if not null
UNLK48 leax MD$ESize,X Move to next entry
 cmpx D.ModEnd at end?
 bcs UNLK45 ..no
 ldx D.BlkMap
 ldd MD$MBSiz,U
 bsr DIVBKSZ Divide by block size, rounding up
 pshs y
 ldy MD$MPDAT,U
UNLK50 pshs x,a
 ldd 0,Y get block number
 clr ,Y+
 clr ,Y+
 leax D,X point to blkmap entry
 ldb 0,X
 andb #^(ModBlock+RAMinUse)
 stb 0,X
 puls X,A
 deca More blocks
 bne UNLK50 .. yes

 puls Y
 ldx D.ModDir
 ldd MD$MPDAT,U
UNLK60 cmpd MD$MPDAT,X
 bne UNLK65
 clr 0,X
 clr 1,X
UNLK65 leax MD$ESize,X
 cmpx D.ModEnd
 bcs UNLK60
UNLKRT rts

*****
*
* Subroutine DivBkSz
*
* Divide By block size, Rounding Up
DIVBKSZ addd #DAT.Blsz-1
 ifge DAT.BlSz-$2000
 lsra
 endc
 lsra
 lsra
 lsra
 lsra
 rts

 page
*****
*
*  Subroutine Fork
*
* Creates New Child Process
*
FORK pshs U
 lbsr F.ALLPRC Allocate process descriptor
 bcc FORK05
 puls PC,U

FORK05 pshs U Store new process descriptor
 ldx D.PROC Get parent process ptr
 ldd P$USER,X Copy user index
 std P$User,U
 lda P$Prior,X Copy priority
 sta P$Prior,U
 leax P$DIO,X Get parent path ptr
 leau P$DIO,U Get child path ptr
 ldb #DefIOSiz Get byte count
FORK10 lda ,X+ Get parent byte
 sta ,U+ Pass to child
 decb COUNT Down
 bne FORK10 Branch if more
 ldy #3 Get number of paths
FORK20 lda ,X+ Get path number
 beq FORK25
 OS9 I$DUP Duplicate path
 bcc FORK25
 clra CLEAR Path number
FORK25 sta ,U+ Pass path to child
 leay -1,Y COUNT Down
 bne FORK20 Branch if more
*
         leax  P$Links-DefIOSiz-3,x
         leau  P$Links-DefIOSiz-3,u
         ldb   #$20
FORK28    lda   ,x+
         sta   ,u+
         decb
         bne   FORK28
*
 ldx 0,S
 ldu 2,S restore U
 lbsr SETPRC Set up process
 bcs FORK40 Branch if error
 pshs D
 os9 F$AllTsk
 bcc FORK30
FORK30 lda P$PagCnt,X
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
 leax (P$Stack-R$Size),X
 ldy #12
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
 anda #$FF-SysState Clear system state
 sta P$State,X Update child state
 OS9 F$AProc Activate child process
 rts

FORK40 puls x
 pshs b Save error code
 lbsr CLOSEPD
 lda 0,X
 lbsr F.RETPRC
 comb SET Carry
 puls pc,U,b

*****
* Allocate Image RAM blocks
*
ALLPRC pshs U
 bsr F.ALLPRC
 bcs ALLPRC10
 ldx 0,S Recover U register
 stu R$U,X
ALLPRC10 puls PC,U

* Find unused process id
F.ALLPRC ldx D.PrcDBT Get process block ptr
ALLPRC20 lda ,X+
 bne ALLPRC20 branch if used
 leax -1,X go back one
 tfr X,D
 subd D.PrcDBT
 tsta
 beq ALLPRC30
 comb
 ldb #E$PrcFul
 bra ALLPRC60

ALLPRC30 pshs b
 ldd #P$Size
 os9 F$SRqMem
 puls a
 bcs ALLPRC60
 sta P$ID,U 
 tfr u,d
 sta 0,X Reserve slot in D.PrcDBT
 clra
 leax 1,U
 ldy #$0080 Clear process descriptor
ALLPRC40 std ,X++
 leay -1,Y
 bne ALLPRC40
 lda #SysState
 sta P$State,U
* Set up the DAT table
         ldb   #DAT.BlCt
 ldx #DAT.Free
 leay P$DATImg,U
ALLPRC50 stx ,Y++
 decb
 bne ALLPRC50

 clrb
ALLPRC60 rts

*****
* Deallocate process descriptor
*
DELPRC lda R$A,U
 bra F.RETPRC

 page
*****
*
*  Subroutine Wait
*
* Wait for Child Process to Exit
*
WAIT ldx D.PROC Get process ptr
 lda P$CID,X Does process have children?
 beq WAIT20 Branch if no
WAIT10 lbsr F.GProcP
 lda P$State,Y Get child's status
 bita #DEAD Is child dead?
 bne CHILDS Branch if so
 lda P$SID,Y More children?
 bne WAIT10 Branch if so
 sta R$A,u clear child process id
 pshs cc
 orcc #IRQMask+FIRQMask Set interrupt masks
 ldd D.WProcQ Put in waiting queue
 std P$Queue,X
 stx D.WProcQ
 puls cc
 lbra ZZZPRC Put process to sleep
WAIT20 comb Set Carry
 ldb #E$NoChld Err: no children
 rts
*****
*
*  Subroutine Childs
*
* Return Child's Death Status to Parent
*
* Input:  X - Parent Process ptr
*         Y - Child Process ptr
*         U - Parent Process Register ptr
*
CHILDS lda P$ID,Y Get process id
 ldb P$Signal,Y Get death status
 std R$D,U Return to parent
 leau 0,y
 leay P$CID-P$SID,X Fake sibling process ptr
 bra CHIL20
CHIL10 lbsr F.GProcP Get process ptr
CHIL20 lda P$SID,Y Is child next sibling?
 cmpa P$ID,u
 bne CHIL10 Branch if not
 ldb P$SID,U Get child's sibling
 stb P$SID,Y Remove child from sibling list

F.RETPRC pshs U,X,D
 ldb 0,S
 ldx D.PrcDBT Get process block ptr
 abx
 lda 0,X
 beq RETPRCX
 clrb
 stb 0,X  Clear process id
 tfr d,X
 os9 F$DelTsk
 leau 0,X
 ldd #P$Size
 os9 F$SRtMem
RETPRCX puls pc,U,X,b,a



*****
*
* Subroutine Chain
*
* Execute Overlay
*
CHAIN    pshs  u
         lbsr  F.ALLPRC
         bcc   CHAIN10
         puls  pc,u

CHAIN10    ldx   D.PROC
         pshs  u,x
         leax  P$SP,x
         leau  P$SP,u
         ldy   #$007E
CHAIN20    ldd   ,x++
         std   ,u++
         leay  -$01,y
         bne   CHAIN20
         ldx   D.PROC
         clra
         clrb
         stb   P$Task,x
         std   P$SWI,x
         std   P$SWI2,x
         std   P$SWI3,x
         sta   P$Signal,x
         std   P$SigVec,x
         ldu   P$PModul,x
         os9   F$UnLink
         ldb   P$PagCnt,x
         addb  #(DAT.BlSz/256)-1     round up to the nearest block
         lsrb
         lsrb
         lsrb
         lsrb
 ifge DAT.BlSz-$2000
         lsrb
 endc
         lda   #$10   counter
         pshs  b
         suba  ,s+
         leay  P$DatImg,x
         lslb
         leay  b,y
         ldu   #$00FE  DAT.Free
CHAIN30    stu   ,y++
         deca
         bne   CHAIN30
         ldu   $02,s
         stu   D.PROC
         ldu   $04,s
         lbsr  SETPRC
         lbcs  CHAINERR
         pshs  b,a
         os9   F$AllTsk
         bcc   CHAIN40
CHAIN40    ldu   D.PROC
         lda   P$Task,u
         ldb   $06,x
         leau  (P$Stack-R$Size),x
         leax  ,y
         ldu   P$SP,u
         pshs  u
         cmpx  ,s++
         puls  y
         bhi   CHAIN60
         beq   CHAIN70
         leay  ,y
         beq   CHAIN70
         pshs  x,b,a
         tfr   y,d
         leax  d,x
         pshs  u
         cmpx  ,s++
         puls  x,b,a
         bls   CHAIN60
         pshs  u,y,x,b,a
         tfr   y,d
         leax  d,x
         leau  d,u
CHAIN50    ldb   ,s
         leax  -$01,x
         os9   F$LDABX
         exg   x,u
         ldb   $01,s
         leax  -$01,x
         os9   F$STABX
         exg   x,u
         leay  -$01,y
         bne   CHAIN50
         puls  u,y,x,b,a
         bra   CHAIN70
CHAIN60    os9   F$Move

CHAIN70    lda   D.SysTsk
         ldx   ,s
         ldu   $04,x
         leax  (P$Stack-R$Size),x
         ldy   #$000C
         os9   F$Move
         puls  u,x
         lda   ,u
         lbsr  F.RETPRC
         os9   F$DelTsk
         orcc  #$50
         ldd   D.SysPrc
         std   D.PROC
         lda   $0C,x
         anda  #$7F
         sta   $0C,x
         os9   F$AProc
         os9   F$NProc
CHAINERR    puls  u,x
         stx   D.PROC
         pshs  b
         lda   ,u
         lbsr  F.RETPRC
         puls  b
         os9   F$Exit

SETPRC    pshs  u,y,x,b,a
         ldd   D.PROC
         pshs  b,a
         stx   D.PROC
         lda R$A,u
         ldx R$X,u
         ldy   ,s
         leay  <$40,y
         os9   F$SLink
         bcc   SETPRC05
         ldd   ,s
         std   D.PROC
         ldu   $04,s
         os9   F$Load
         bcc   SETPRC05
         leas  $04,s
         puls  pc,u,y,x
SETPRC05    stu   $02,s
         pshs  y,a
         ldu   $0B,s
         stx R$X,u
         ldx   $07,s
         stx   D.PROC
         ldd   $05,s
         std   <$11,x
         puls  a
         cmpa  #$11
         beq   SETPRC15
         cmpa  #$C1
         beq   SETPRC15
         ldb   #$EA
SETPRC10    leas  $02,s
         stb   $03,s
         comb
         bra   SETPRC50
SETPRC15    ldd   #$000B
         leay  P$DatImg,x
         ldx   <$11,x
         os9   F$LDDDXY
         cmpa  R$B,u
         bcc   SETPRC25
         lda   R$B,u
         clrb

SETPRC25    os9   F$Mem
         bcs   SETPRC10
         ldx   $06,s
         leay  (P$Stack-R$Size),x
         pshs  b,a
         subd  R$Y,u
         std   $04,y
         subd  #R$Size Deduct stack room
         std   P$SP,x
         ldd   R$Y,u
         std   $01,y
         std   $06,s
         puls  x,b,a
         std   $06,y
         ldd   R$U,u
         std   $06,s
         lda   #$80
         sta   ,y
         clra
         sta   $03,y
         clrb
         std   $08,y
         stx   $0A,y
SETPRC50    puls  b,a
         std   D.PROC
         puls  pc,u,y,x,b,a
 page
*****
*
*  Subroutine Exit
*
* Process Termination
*
EXIT     ldx   D.PROC
         bsr   CLOSEPD
         ldb R$B,u
         stb   <$19,x
         leay  $01,x
         bra   EXIT30
EXIT20    clr   $02,y
         lbsr  F.GProcP
         clr   $01,y
         lda   $0C,y
         bita  #$01
         beq   EXIT30
         lda   ,y
         lbsr  F.RETPRC
EXIT30    lda   $02,y
         bne   EXIT20
         leay  ,x
         ldx   #$0047
         lds   D.SysStk
         pshs  cc
         orcc  #$50
         lda   $01,y
         bne   EXIT40
         puls  cc
         lda   ,y
         lbsr  F.RETPRC
         bra   EXIT50
EXIT35    cmpa  ,x
         beq   EXIT45
EXIT40    leau  ,x
         ldx   $0D,x
         bne   EXIT35
         puls  cc
         lda   #$81
         sta   $0C,y
         bra   EXIT50
EXIT45    ldd   P$Queue,x
         std   P$Queue,u
         puls  cc
         ldu P$SP,X Get parent's stack
         ldu   R$U,u
         lbsr  CHILDS Return child status
         os9   F$AProc
EXIT50    os9   F$NProc

CLOSEPD    pshs  u
         ldb   #$10
         leay  <$30,x
CLOSE10    lda   ,y+
         beq   CLOSE20
         clr   -$01,y
         pshs  b
         os9   I$Close
         puls  b
CLOSE20    decb
         bne   CLOSE10
         clra
         ldb   $07,x
         beq   EXIT60
         addb  #$0F
         lsrb
         lsrb
         lsrb
         lsrb
 ifge DAT.BlSz-$2000
         lsrb
 endc
         os9   F$DelImg
EXIT60    ldd   D.PROC
         pshs  b,a
         stx   D.PROC
         ldu   P$PModul,x Get primary module ptr
         os9   F$UnLink
         puls  u,b,a
         std   D.PROC
         os9   F$DelTsk
         rts
 page
*****
*
*  Subroutine Usrmem
*
* Adjust User Memory To Requested Size
*
USRMEM ldx D.PROC get process ptr
 ldd R$D,U Get size requested
 beq USRM35 branch if info request
 addd #$00FF Round up to whole pages
USRM05 cmpa P$PagCnt,X Compare with already allocated
 beq USRM35 branch if same
 pshs A
 bcc USRM10
 deca
 ldb #-R$Size Deduct stack room
 cmpd P$SP,X Deallocating stack?
 bcc USRM10 Branch if not
 ldb #E$DelSP Error: request to return memory where stack is
 bra USRMER1

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
* Determine block # from requested num of pages
 ldb 0,S
 addb #(DAT.BlSz/256)-1 Round up
 bcc USRM15 branch if under limit
 ldb #E$MemFul
 bra USRMER1
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
USRMER1 leas 1,S Restore stack pointer
USRMERR orcc #Carry
 rts

USRM25 pshs B
 adda ,S+ Subtract B from existing max block
 negb Make difference positive
 os9 F$DelImg Deallocate blocks
USRM30 puls A
 sta P$PagCnt,X Set new amount of pages
USRM35 lda P$PagCnt,X
 clrb
 std R$D,U Size of new memory area in bytes
 std R$Y,U Address of upper bound in new area
 rts
 page
*****
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
SENSUB lbsr F.GProcP Get process ptr
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
SEND50    leay  ,x
         ldx   P$Queue,x
         beq   SEND66
 ldu P$SP,x get process stack ptr
         addd  R$X,u
         cmpx  $02,s
         bne   SEND50
 pshs d save remaining time
 lda P$State,x get process state
 bita #TimSleep is it in timed sleep?
         beq   SEND65
         ldd   ,s
         beq   SEND65
         ldd   $4,u
         pshs  b,a
         ldd   $02,s
         std   4,u
         puls  b,a
         ldu   $0D,x
         beq   SEND65
         std   ,s
         lda   P$State,u
         bita  #$40
         beq   SEND65
 ldu P$SP,u get process stack ptr
         ldd   ,s
 addd R$X,u add remaining time
 std R$X,u update it
SEND65    leas  $02,s
         bra   SEND68
*
* Look for Process in Waiting Queue
*
SEND66 ldx #D.WProcQ-P$Queue Fake process ptr
SEND67 leay 0,X Copy process ptr
 ldx P$Queue,x More in queue?
 beq SEND75 Branch if not
 cmpx 2,s Is this destination process?
 bne SEND67 Branch if not
*
* Move Process from it's current Queue to Active Queue
*
SEND68    ldd   P$Queue,x Remove from queue
         std   $0D,y
         lda   <$19,x
         deca
         bne   SEND70
         sta   <$19,x
         lda   ,s
         tfr   a,cc
SEND70    os9   F$AProc
SEND75    puls  pc,u,y,a,cc
 page
*****
*
*  Subroutine Intcpt
*
* Signal Intercept Handler
*
INTCPT ldx D.PROC Get process ptr
 ldd R$X,U Get vector
 std P$SigVec,X Save it
 ldd R$U,U Get data address
 std P$SigDat,X Save it
 clrb CLEAR Carry
 rts

page
*****
*
*  Subroutine Sleep
*
* Suspend Process
*
SLEEP pshs  cc
 ldx D.PROC Get current process
 orcc #IRQMask+FIRQMask Set interrupt mask
 lda P$Signal,X Signal waiting?
 beq SLEP20 Branch if not
 deca IS It wake-up?
 bne SLEP10 Branch if not
 sta P$Signal,X Clear signal
SLEP10    puls  cc
         os9   F$AProc
         bra   ZZZPRC
SLEP20 ldd R$X,U Get length of sleep
         beq   SLEP50
 subd #1 count current tick
 std R$X,U update count
 beq SLEP10 branch if done
         pshs  y,x
         ldx   #$0049
SLEP30    std   R$X,u
         stx   $02,s
         ldx   $0D,x
         beq   SLEP40
         lda   $0C,x
         bita  #$40
         beq   SLEP40
         ldy   $04,x
         ldd   R$X,u
         subd  $04,y
         bcc   SLEP30
         nega
         negb
         sbca  #$00
         std   $04,y
SLEP40    puls  y,x
 lda P$State,X Set timed sleep status
 ora #TimSleep
 sta P$State,X
 ldd P$Queue,Y Put process in queue
 stx P$Queue,Y
 std P$Queue,X
         ldx R$X,u
         bsr   ZZZPRC
         stx R$X,u
         ldx   D.PROC
         lda   $0C,x
         anda  #$BF
         sta   $0C,x
         puls  pc,cc
SLEP50    ldx   #$0049
SLEP60    leay  ,x
         ldx   $0D,x
         bne   SLEP60
         ldx   D.PROC
         clra
         clrb
         stx   $0D,y
         std   $0D,x
         puls  cc
*
*      Fall Thru To Zzzprc
*
*****
*
*  Subroutine Zzzprc
*
* Deactivate Process, Start Another
*
ZZZPRC    pshs  pc,u,y,x
         leax  <WAKPRC,pcr
         stx   $06,s
         ldx   D.PROC
         ldb   $06,x
         cmpb  D.SysTsk
         beq   ZZZPRC10
         os9   F$DelTsk
ZZZPRC10    ldd   $04,x
         pshs  dp,b,a,cc
         sts   $04,x
         os9   F$NProc

WAKPRC    pshs  x
         ldx   D.PROC
         std   $04,x
         clrb
         puls  pc,x



*****
*
*  Subroutine Setpri
*
* Set Process Priority
*
SETPRI   lda R$A,u
         lbsr  F.GProcP
         bcs   SETP20
         ldx   D.PROC
         ldd   $08,x
         beq   SETP05
         cmpd  $08,y
         bne   SETP10
SETP05 lda R$B,U Get priority
 sta P$Prior,Y Set priority
         clrb
         rts
SETP10    comb
         ldb   #$E0
SETP20    rts



*****
*
*  Subroutine Getid
*
GETID ldx D.PROC Get process ptr
 lda P$ID,X Get process id
 sta R$A,U Return to user
 ldd P$USER,X Get user index
 std R$Y,U Return to user
 clrb
 rts
 page
*****
*
*  Subroutine Setswi
*
* Set Software Interrupt Vectors
*
SETSWI   ldx   D.PROC
 leay P$SWI,X Get ptr to vectors
 ldb R$A,U Get swi code
 decb ADJUST Range
 cmpb #3 Is it in range
 bcc SSWI10 Branch if not
 aslb
 ldx R$X,U
 stx B,Y
 rts
SSWI10 comb
 ldb #E$ISWI
 rts

**********
*
* Subroutine Settime
*

ClockNam fcs "Clock"

SetTime ldx R$X,U get date ptr
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
*****
*
*  Subroutine Alocat
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
ALLBIT ldd R$D,U Get beginning bit number
 ldx R$X,U
 bsr FNDBIT
 ldy D.PROC
 ldb P$Task,Y
 bra ALOCAT

SALLBIT ldd R$D,U
 ldx R$X,U
 bsr FNDBIT
 ldb D.SysTsk
ALOCAT ldy R$Y,U
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
*****
*
*  Subroutine Fndbit
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
FNDBIT pshs y,b
 lsra PAGE/2
 rorb
 lsra PAGE/4
 rorb
 lsra PAGE/8
 rorb
 leax D,X Get byte address
 puls B Get lsb
 leay <BITTBL,pcr
 andb #7 Page modulo 8
 lda b,Y
 puls pc,Y

BITTBL fcb $80,$40,$20,$10,$08,$04,$02,$01

 page
*****
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
 bsr FNDBIT Adjust map ptr & get bit mask
 ldy D.PROC
 ldb P$Task,Y
 bra DEALOC

SDELBIT ldd R$D,U
 ldx R$X,U
 bsr FNDBIT Adjust map ptr & get bit mask
 ldb D.SysTsk
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
 bsr FNDBIT
 ldy D.PROC
 ldb P$Task,Y
 bra FLOBLK

SSCHBIT ldd R$D,U
 ldx R$X,U
 lbsr FNDBIT
 ldb D.SysTsk

FLOBLK pshs U,Y,X,D,CC Save registers
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
GPRDSC ldx D.PROC
 ldb P$Task,X
 lda R$A,U   Process id
 os9 F$GProcP
 bcs GPRDSC10
 lda D.SysTsk
 leax 0,Y
 ldy #P$Size
 ldu R$X,U  512 byte buffer
 os9 F$Move
GPRDSC10 rts

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
CPYMEM ldd R$Y,U byte count
 beq CPYMEM40  Nothing to copy
 addd R$U,U  destination buffer
         leas  <-DAT.ImSz,s
         leay  0,s
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
CPYMEM10 clra
 clrb
 os9 F$LDDDXY
 std ,U++
 leax 2,X
 dec 0,S
 bne CPYMEM10
 puls U,B
 ldx R$X,U  offset in block to begin copy
 ldu R$U,U  destination buffer
 ldy 3,S Get copy of Y
CPYMEM20 cmpx #DAT.BlSz
 bcs CPYMEM30
 leax -DAT.BlSz,X
 leay 2,Y next block
 bra CPYMEM20

CPYMEM30 os9 F$LDAXY
 ldb 0,S
 pshs x
 leax ,U+
 os9 F$STABX
 puls x
 leax 1,X
 cmpu 1,S
 bcs CPYMEM20
 puls y,X,b
         leas  DAT.ImSz,s
CPYMEM40 clrb
 rts

UNLOAD pshs U
 lda R$A,U  module type
 ldx D.PROC
 leay P$DATImg,X
 ldx R$X,U  module name pointer
 os9 F$FModul
 puls Y
 bcs UNLOAD50
 stx R$X,Y
 ldx MD$Link,U
 beq UNLOAD10
 leax -1,X
 stx MD$Link,U
 bne UNLOAD40
UNLOAD10 cmpa #FLMGR Is i/o module?
 bcs UNLOAD30 no, remove module from memory
 clra
 ldx [MD$MPDAT,U]
 ldy D.SysDAT
UNLOAD20 adda #2
 cmpa #DAT.ImSz
 bcc UNLOAD30
 cmpx A,Y find block?
 bne UNLOAD20
 lsla Calculate size from block number
 lsla
 lsla
 ifge DAT.BlSz-$2000
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
 bra UNLOAD50

UNLOAD30 lbsr UNLK40 Delete module
UNLOAD40 clrb
UNLOAD50 rts
 page
***************
* Findpd
*   Find Address Of Path Descriptor Or Process Descriptor
*
* Calling Seq: (A)=Pd Number
*              (X)=Pd Table Addr
* Returns: (Y)=Addr Of Pd
*          Cc=Set If Pd Is Not Owned By Caller
* Destroys: B,Cc
*
F64 lda R$A,U Get block number
 ldx R$X,U Get block ptr
 bsr FINDPD Find block
 bcs F6410
 sty R$Y,U
F6410 rts

FINDPD pshs D Save registers
 tsta LEGAL Number?
 beq FPDERR ..yes; error
 clrb
 lsra
 rorb
 lsra
 rorb DIVIDED By 4 pd's per pd block
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
A64      ldx R$X,u
         bne   A6410
         bsr   A64ADD
         bcs   A6420
         stx   ,x
         stx R$X,u
A6410    bsr   ALOC64
         bcs   A6420
 sta R$A,U Return block number
 sty R$Y,U Return block ptr
A6420 rts

A64ADD    pshs  u
         ldd   #$0100
         os9   F$SRqMem
         leax  ,u
         puls  u
         bcs   A64A20
         clra
         clrb
A64A10    sta   d,x
         incb
         bne   A64A10
A64A20    rts
ALOC64    pshs  u,x
         clra
ALCPD1    pshs  a
         clrb
         lda   a,x
         beq   ALPD12
         tfr   d,y
         clra
ALPD11    tst   d,y
         beq   ALPD13
         addb  #$40
         bcc   ALPD11
ALPD12    orcc  #$01
ALPD13    leay  d,y
         puls  a
         bcc   ALCPD4
         inca
         cmpa  #$40
         bcs   ALCPD1
         clra
ALCPD2 tst A,X Search for an unused pdb
 beq ALCPD3 ..found one
 inca SKIP To next
 cmpa #PDSIZE All tried?
 blo ALCPD2 ..no; keep looking
 comb RETURN Carry set - error
 ldb #E$PthFul No available path
         bra   ALCPD9
ALCPD3    pshs  x,a
         bsr   A64ADD
         bcs   ALCPDR
         leay  ,x
         tfr   x,d
         tfr   a,b
         puls  x,a
         stb   a,x
         clrb
ALCPD4    lslb
         rola
         lslb
         rola
         ldb   #$3F
ALCPD5    clr   b,y
         decb
         bne   ALCPD5
         sta   ,y
ALCPD9    puls  pc,u,x
ALCPDR    leas  $03,s
         puls  pc,u,x

***************
* Rtrn64
*   Return Path Descriptor To Free Status
*
* Passed: (A)=Path Number
*         (X)=D.Pdbt Path Descriptor Block Table Addr
* Returns: None
* Destroys: Cc
*
R64      lda R$A,u
         ldx R$X,u
         pshs  u,y,x,b,a
         clrb
         tsta
         beq   RTRNEX
         lsra
         rorb
         lsra
         rorb
         pshs  a
         lda   a,x
         beq   RTRNP9
         tfr   d,y
         clr   ,y
         clrb
         tfr   d,u
         clra
RTRNP1    tst   d,u
         bne   RTRNP9
         addb  #$40
         bne   RTRNP1
         inca
         os9   F$SRtMem
         lda   ,s
         clr   a,x
RTRNP9    clr   ,s+
RTRNEX    puls  pc,u,y,x,b,a

GPROCP   lda R$A,u
         bsr   F.GProcP
         bcs   GPROCP10
         sty R$Y,u
GPROCP10    rts

* Find process descriptor
F.GProcP    pshs  x,b,a
         ldb   ,s
         beq   L0AFC
         ldx   D.PrcDBT
         abx
         lda   ,x
         beq   L0AFC
         clrb
         tfr   d,y
         puls  pc,x,b,a
L0AFC    puls  x,b,a
         comb
         ldb   #E$BPrcId
         rts

DELIMG   ldx R$X,u
         ldd R$D,u
         leau  P$DatImg,x
         lsla
         leau  a,u
         clra
         tfr   d,y
         pshs  x
DELIMG10    ldd   ,u
         addd  D.BlkMap
         tfr   d,x
         lda   ,x
         anda  #$FE
         sta   ,x
         ldd   #$00FE
         std   ,u++
         leay  -$01,y
         bne   DELIMG10
         puls  x
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         clrb
         rts

MAPBLK   lda   R$B,u  Number of blocks
         cmpa  #$10
         bcc   IBAERR
         leas  <-$20,s
         ldx R$X,u
         leay  ,s
MAPBLK10    stx   ,y++
         leax  $01,x
         deca
         bne   MAPBLK10
         ldb R$B,u
         ldx   D.PROC
         leay  P$DatImg,x
         os9   F$FreeHB
         bcs   MAPBLK50
         pshs  b,a
         lsla
         lsla
         lsla
         lsla
 ifge DAT.BlSz-$2000
         lsla
 endc
         clrb
         std   R$U,u
         puls  b,a
         leau  ,s
         os9   F$SetImg
MAPBLK50    leas  <$20,s
         rts

IBAERR comb
 ldb #E$IBA illegal block address
 rts
*****
*
* Clear Specific Block
*
CLRBLK ldb R$B,U Get number of blocks
 beq CLRBLK50
 ldd R$U,U Get address of first block
 tstb
 bne IBAERR
 bita #(DAT.BlSz/256)-1
 bne IBAERR
 ldx D.PROC
*
 lda P$SP,X
 anda #$F0
 suba R$U,U
 bcs CLRBLK10
 lsra
 lsra
 lsra
 lsra
 ifge DAT.BlSz-$2000
 lsra
 endc
 cmpa R$B,U
 bcs IBAERR
CLRBLK10 lda P$State,X
 ora #ImgChg
 sta P$State,X
 lda R$U,u
 lsra
 lsra
 lsra
 ifge DAT.BlSz-$2000
 lsra
 endc
 leay P$DATImg,X
 leay A,Y
 ldb R$B,U get number of blocks
 ldx #DAT.Free
CLRBLK20 stx ,Y++ mark as free
 decb
 bne CLRBLK20
*
CLRBLK50 clrb
 rts

*****
*
* Deallocate RAM blocks
*
DELRAM ldb R$B,U
 beq DELRAM30
 ldd D.BlkMap+2
 subd D.BlkMap
 subd R$X,U
 bls DELRAM30
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
DELRAM30 clrb
 rts

*****
*
* Pack module directory
*
GCMDIR ldx D.ModDir
 bra GCMDIR20
GCMDIR10 ldu MD$MPDAT,X Is there a DAT Image?
 beq GCMDIR30 ..yes
 leax MD$ESize,X
GCMDIR20 cmpx D.ModEnd
 bne GCMDIR10
 bra GCMDIR41

* Move all entrys up 1 slot in directory
GCMDIR30 tfr X,Y
 bra GCMDIR36
GCMDIR32 ldu MD$MPDAT,Y
 bne GCMDIR38
GCMDIR36 leay MD$ESize,Y
 cmpy D.ModEnd
 bne GCMDIR32
 bra GCMDIR40

* Move MD$ESize bytes
GCMDIR38 ldu ,Y++
 stu ,X++
 ldu ,Y++
 stu ,X++
 ldu ,Y++
 stu ,X++
 ldu ,Y++
 stu ,X++
 cmpy D.ModEnd
 bne GCMDIR32
GCMDIR40 stx D.ModEnd
GCMDIR41 ldx D.ModDir+2
 bra GCMDIR46
GCMDIR44 ldu 0,X
 beq GCMDIR48
GCMDIR46 leax -2,X
 cmpx D.ModDat
 bne GCMDIR44
 bra GCMDIREX
GCMDIR48 ldu -2,X
 bne GCMDIR46
 tfr x,Y
 bra GCMDIR51

GCMDIR50 ldu 0,Y
 bne GCMDIR60
GCMDIR51 leay -2,Y
GCMDIR55 cmpy D.ModDat
 bcc GCMDIR50
 bra GCMDIR70

GCMDIR60 leay 2,Y
 ldu 0,Y
 stu 0,X
GCMDIR65 ldu ,--y
 stu ,--x
 beq GCMDIR80
 cmpy D.ModDat
 bne GCMDIR65
GCMDIR70 stx D.ModDat
 bsr GCMDIR90
 bra GCMDIREX

GCMDIR80 leay 2,Y
 leax 2,X
 bsr GCMDIR90
 leay -4,Y
 leax -2,X
 bra GCMDIR55

GCMDIREX clrb
 rts

* Update Module Dir Image Ptrs
GCMDIR90 pshs U
 ldu D.ModDir
 bra GCMDIR99
GCMDIR93 cmpy MD$MPDAT,U
 bne GCMDIR95
 stx MD$MPDAT,U
GCMDIR95 leau MD$ESize,U
GCMDIR99 cmpu D.ModEnd
 bne GCMDIR93
 puls PC,U

 emod
OS9End equ *
