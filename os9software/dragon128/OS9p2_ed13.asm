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
Revs set ReEnt+2

 mod OS9End,OS9Name,Type,Revs,OS9Ent,256

OS9Name fcs /OS9p2/

         fcb   13 Edition

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
 ifne EXTERR
* Load error messages path
         ldy   D.SysPrc
         leay  P$ErrNam,y
         lda   #$0D
         sta   ,y
         ldd   ErrStr,u
         beq   L0057
         leax  d,u
         ldb   #$20
L004E    lda   ,x+
         sta   ,y+
         bmi   L0057
         decb
         bne   L004E
 endc
 ifeq ClocType-VSYNC
* Clock init start
* Reset to 0
L0057    ldb   #6
L0059    clr   ,-s
         decb
         bne   L0059
         leax  ,s
         os9   F$STime
         leas  6,s
 endc
* Clock init end
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
IOHOOK20 stb 1,s
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
* Decrment Link Count. If Count Reaches Zero,
*    Delete Module From Directory & Return Memory
*
UNLINK pshs u,b,a
 ldd R$U,U Get module address
 ldx R$U,u Get module address
 lsra
 lsra
 lsra
 lsra
 ifge DAT.BlSz-$2000
 lsra
 endc
         sta   0,s
         beq   L01A8
         ldu   D.PROC
         leay  P$DATImg,u
         lsla
         ldd   a,y
         ldu   D.BlkMap
         ldb   d,u
         bitb  #$02
         beq   L01A8
         leau  P$DATImg,y
         bra   L0187
L0183    dec   ,s
         beq   L01A8
L0187    ldb   ,s
         lslb
         ldd   b,u
         beq   L0183
         lda   ,s
         lsla
         lsla
         lsla
         lsla
 ifge DAT.BlSz-$2000
         lsla
 endc
         clrb
         nega
         leax  d,x
         ldb   ,s
         lslb
         ldd   b,y
         ldu   D.ModDir Get directory ptr
         bra   L01AA
L01A1    leau  MD$ESize,u Move to next entry
         cmpu  D.ModEnd
         bcs   L01AA
L01A8    bra   L01F5
L01AA    cmpx  MD$MPtr,U  Is it this module?
         bne   L01A1 ..no
         cmpd  [MD$MPDAT,u]
         bne   L01A1
         ldx   MD$Link,u
         beq   L01BD
         leax  -1,x
         stx   MD$Link,u
         bne   L01DA
L01BD    ldx   $02,s
         ldx   $08,x
         ldd   #6
         os9   F$LDDDXY
         cmpa #FLMGR Is i/o module?
         bcs   UNLK20
         os9   F$IODel
         bcc   UNLK20
         ldx   MD$Link,u
         leax  1,x
         stx   MD$Link,u
         bra   L01F6
UNLK20    bsr   L01FA
L01DA    ldb   ,s
         lslb
         leay  b,y
         ldx   P$DATImg,y
         leax  -1,x
         stx   P$DATImg,y
         bne   L01F5
         ldd   MD$MBSiz,u
         bsr   DIVBKSZ
         ldx   #DAT.Free
L01F0    stx   ,y++
         deca
         bne   L01F0
L01F5    clrb
L01F6    leas  $02,s
         puls  pc,u

L01FA    ldx   D.BlkMap
         ldd   [MD$MPDAT,u] Get module DAT image
         lda   d,x
         bmi   L024A
         ldx   D.ModDir
L0204    ldd   [MD$MPDAT,x]
         cmpd  [MD$MPDAT,u]
         bne   L020F
         ldd   MD$Link,x
         bne   L024A
L020F    leax  MD$ESize,x
         cmpx  D.ModEnd
         bcs   L0204
         ldx   D.BlkMap
         ldd   2,u
         bsr   DIVBKSZ
         pshs  y
         ldy   MD$MPDAT,u
L0220    pshs  x,a
         ldd   ,y
         clr   ,y+
         clr   ,y+
         leax  d,x
         ldb   ,x
         andb  #$FC
         stb   ,x
         puls  x,a
         deca
         bne   L0220
         puls  y
         ldx   D.ModDir
         ldd   MD$MPDAT,u
L023B    cmpd  MD$MPDAT,x
         bne   L0244
         clr   ,x
         clr   1,x
L0244    leax  MD$ESize,x
         cmpx  D.ModEnd
         bcs   L023B
L024A    rts

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
FORK     pshs  u
         lbsr  L02F9
         bcc   FORK05
         puls  pc,u
FORK05    pshs  u
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
 leay -1,y COUNT Down
 bne FORK20 Branch if more
         ldx   0,s
         ldu   2,s
 lbsr SETPRC Set up process
 bcs FORK40 Branch if error
         pshs  D
         os9   F$AllTsk
         bcc   FORK30
FORK30 lda $07,x
         clrb
         subd  ,s
         tfr   d,u
         ldb   $06,x
         ldx   D.PROC
         lda   P$Task,x
         leax  ,y
         puls  y
         os9   F$Move
         ldx   ,s
         lda   D.SysTsk
         ldu   $04,x
         leax  (P$Stack-R$Size),x
         ldy   #$000C
         os9   F$Move
         puls  u,x
         os9   F$DelTsk
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
FORK40    puls  x
         pshs  b
         lbsr  CLOSEPD
         lda   ,x
         lbsr  L039D
 comb SET Carry
         puls  pc,u,b

ALLPRC   pshs  u
         bsr   L02F9
         bcs   L02F7
         ldx   ,s
         stu   R$U,x
L02F7    puls  pc,u

* Find unused process id
L02F9    ldx   D.PrcDBT Get process block ptr
L02FB    lda   ,x+
         bne   L02FB
         leax  -1,x
         tfr   x,d
         subd  D.PrcDBT
         tsta
         beq   L030D
         comb
         ldb   #E$PrcFul
         bra   L0356
L030D    pshs  b
         ldd   #P$Size
         os9   F$SRqMem
         puls  a
         bcs   L0356
         sta   ,u
         tfr   u,d
         sta   ,x
         clra
         leax  1,u
         ldy   #$0080
L0326    std   ,x++
         leay  -1,y
         bne   L0326
         lda   #SysState
         sta   P$State,u
         ldb   #$0F        counter
         ldx   #DAT.Free
         leay  P$DATImg,u
L0338    stx   ,y++
         decb
         bne   L0338
 ifne EXTERR
         ldx   #$00FF
         stx   ,y++
         leay  P$ErrNam,u    Area for error messages
         ldx   D.PROC
         leax  P$ErrNam,x    Area for error messages
         ldb   #$20
L034E    lda   ,x+
         sta   ,y+
         decb
         bne   L034E
 endc
         clrb
L0356    rts

DELPRC   lda R$A,u
         bra   L039D

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
WAIT10 lbsr GETPRC
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
CHIL10 lbsr GETPRC Get process ptr
CHIL20 lda P$SID,Y Is child next sibling?
 cmpa P$ID,u
 bne CHIL10 Branch if not
 ldb P$SID,U Get child's sibling
 stb P$SID,Y Remove child from sibling list
L039D    pshs  u,x,b,a
         ldb   ,s
         ldx   D.PrcDBT Get process block ptr
         abx
         lda   ,x
         beq   L03B8
         clrb
         stb   ,x  Clear process id
         tfr   d,x
         os9   F$DelTsk
         leau  0,x
         ldd   #P$Size
         os9   F$SRtMem
L03B8    puls  pc,u,x,b,a



*****
*
* Subroutine Chain
*
* Execute Overlay
*
CHAIN pshs U Save register ptr
         lbsr  L02F9
         bcc   L03C3
         puls  pc,u

L03C3    ldx   D.PROC Get process ptr
         pshs  u,x
         leax  P$SP,x
         leau  P$SP,u
         ldy   #$007E
L03CF    ldd   ,x++
         std   ,u++
         leay  -1,y
         bne   L03CF
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
         lda   #$0F   counter
         pshs  b
         suba  ,s+
         leay  P$DatImg,x
         lslb
         leay  b,y
         ldu   #DAT.Free
L0409    stu   ,y++
         deca
         bne   L0409
         ldu   #$00FF
         stu   ,y++
         ldu   $02,s
         stu   D.PROC
         ldu   $04,s
         lbsr  SETPRC
         lbcs  L04A3
         pshs  b,a
         os9   F$AllTsk
         bcc   L0427
L0427    ldu   D.PROC
         lda   P$Task,u
         ldb   $06,x
         leau  (P$Stack-R$Size),x
         leax  ,y
         ldu   P$SP,u
         pshs  u
         cmpx  ,s++
         puls  y
         bhi   L0473
         beq   L0476
         leay  ,y
         beq   L0476
         pshs  x,b,a
         tfr   y,d
         leax  d,x
         pshs  u
         cmpx  ,s++
         puls  x,b,a
         bls   L0473
         pshs  u,y,x,b,a
         tfr   y,d
         leax  d,x
         leau  d,u
L0459    ldb   ,s
         leax  -1,x
         os9   F$LDABX
         exg   x,u
         ldb   1,s
         leax  -1,x
         os9   F$STABX
         exg   x,u
         leay  -1,y
         bne   L0459
         puls  u,y,x,b,a
         bra   L0476
L0473    os9   F$Move
L0476    lda   D.SysTsk
         ldx   ,s
         ldu   $04,x
         leax  (P$Stack-R$Size),x
         ldy   #$000C
         os9   F$Move
         puls  u,x
         lda   ,u
         lbsr  L039D
         os9   F$DelTsk
         orcc #IRQMask+FIRQMask Set interrupt masks
         ldd   D.SysPrc
         std   D.PROC
         lda   $0C,x
         anda  #$7F
         sta   $0C,x
         os9   F$AProc
         os9   F$NProc
L04A3    puls  u,x
         stx   D.PROC
         pshs  b
         lda   ,u
         lbsr  L039D
         puls  b
         os9   F$Exit

SETPRC    pshs  u,y,x,b,a
 ldd   D.PROC Get process ptr
         pshs  D
         stx   D.PROC
         lda R$A,u
         ldx R$X,u
         ldy   ,s Get process ptr
         leay  P$DATImg,y
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
         std   P$PModul,x
         puls  a
 cmpa #PRGRM+OBJCT is it program object?
 beq SETPRC15 branch if so
 cmpa #SYSTM+OBJCT is it system object?
 beq SETPRC15 branch if so
 ldb #E$NEMod err: non-executable module
SETPRC10    leas  $02,s
         stb   $03,s
         comb
         bra   SETPRC50
SETPRC15    ldd   #$000B
         leay  P$DATImg,x
         ldx   P$PModul,x
         os9   F$LDDDXY
         cmpa  R$B,u
         bcc   SETPRC25
         lda   R$B,u
         clrb
SETPRC25    os9   F$Mem Mem to correct size
         bcs   SETPRC10 Branch if no memory
         ldx   $06,s
         leay  (P$Stack-R$Size),x
         pshs  d
         subd  R$Y,u
         std   $04,y
         subd  #R$Size Deduct stack room
         std   P$SP,x
         ldd   R$Y,u
         std   R$D,y
         std   $06,s
         puls  x,d
         std   $06,y
         ldd   R$U,u
         std   $06,s
         lda   #$80
         sta   R$CC,y
         clra
         sta   R$DP,y Get direct page ptr
         clrb
         std   R$U,y
         stx   R$PC,y
SETPRC50 puls  D
         std   D.PROC
         puls  pc,u,y,x,D
 page
*****
*
*  Subroutine Exit
*
* Process Termination
*
EXIT     ldx   D.PROC
         bsr   CLOSEPD
         ldb R$B,u Get exit status
         stb P$Signal,X Save status
         leay  1,x
         bra   EXIT30
EXIT20    clr P$SID,Y Clear sibling link
         lbsr  GETPRC
         clr   P$PID,y
         lda   P$State,y Get process status
 bita #DEAD Is process dead?
         beq   EXIT30 Branch if not
         lda   P$ID,y
         lbsr  L039D
EXIT30    lda   P$SID,y Get sibling id
         bne   EXIT20
         leay  ,x
         ldx #D.WProcQ-P$Queue Fake process ptr
         lds   D.SysStk
         pshs  cc
         orcc #IRQMask+FIRQMask Set interrupt masks
         lda   P$PID,y
         bne   EXIT40
         puls  cc
         lda   ,y
         lbsr  L039D
         bra   EXIT50
EXIT35   cmpa P$ID,X Is this parent?
         beq   EXIT45
EXIT40    leau  0,x
         ldx   P$Queue,x
         bne   EXIT35
         puls  cc
         lda   #SysState+DEAD
         sta   P$State,y
         bra   EXIT50
EXIT45    ldd   P$Queue,x
         std   P$Queue,u
         puls  cc
         ldu P$SP,X Get parent's stack
         ldu   R$U,u
         lbsr  CHILDS Return child status
         os9   F$AProc
EXIT50    os9   F$NProc

CLOSEPD pshs u
 ldb #NumPaths Get number of paths
 leay P$PATH,X Get path table ptr
CLOSE10 lda ,y+ Get next path number
 beq CLOSE20 Branch if not in use
 clr -1,y
 pshs B Save path count
 OS9 I$Close Close the file
 puls B Retrieve path count
CLOSE20 decb COUNT Down
 bne CLOSE10 Branch if more
 clra
         ldb   P$PagCnt,x
         beq   L05CC
         addb  #(DAT.BlSz/256)-1
         lsrb
         lsrb
         lsrb
         lsrb
 ifge DAT.BlSz-$2000
         lsrb
 endc
         os9   F$DelImg
L05CC    ldd   D.PROC
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
         addd  #$00FF
         bcc   L05EF
         ldb   #E$MemFul
         bra   L0628
L05EF    cmpa  P$PagCnt,x
         beq   USRM35
         pshs  a
         bcc   L0603
         deca
         ldb   #$F4
         cmpd  P$SP,x
         bcc   L0603
         ldb   #E$DelSP
         bra   L0626
L0603    lda   P$PagCnt,x
         adda  #(DAT.BlSz/256)-1
         lsra
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra
 endc
         ldb   ,s
         addb  #(DAT.BlSz/256)-1
         bcc   L0615
         ldb   #E$MemFul
         bra   L0626
L0615    lsrb
         lsrb
         lsrb
         lsrb
 ifge DAT.BlSz-$2000
         lsrb
 endc
         pshs  a
         subb  ,s+
         beq   L0633
         bcs   L062B
         os9   F$AllImg
         bcc   L0633
L0626    leas  1,s
L0628    orcc  #Carry
         rts
L062B    pshs  b
         adda  ,s+
         negb
         os9   F$DelImg
L0633    puls  a
         sta   P$PagCnt,x
USRM35    lda   P$PagCnt,x
         clrb
         std R$D,u
         std R$Y,u
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
SEND10 cmpa P$ID,x Is this sender?
 beq SEND15 Branch if so
 bsr SENSUB Signal process
SEND15 inca Get next process id
 bne SEND10 Branch if more
 clrb Clear Carry
 rts
*
* Get destination Process ptr
*
SENSUB lbsr GETPRC Get process ptr
         pshs  u,y,a,cc
         bcs   SEND17
         tst   R$B,u Is it unconditional abort signal (code 0)?
         bne   SEND20 ... no
         ldd   P$User,x
         beq   SEND20  is it user 0?
         cmpd  P$User,y Same as process owner?
         beq   SEND20 Branch if yes
 ldb #E$IPrcID Err: illegal process id
         inc   R$CC,s  Set carry
SEND17    lbra  SEND75
*
* Check Signal type
*
SEND20 orcc #IRQMask+FIRQMask Set interrupt masks
         ldb R$B,u Is it unconditional abort signal?
         bne   SEND30
         ldb   #E$PrcAbt
         lda   P$State,y
         ora   #Condem
         sta   P$State,y
SEND30    lda   P$State,y
         anda  #^Suspend
         sta   P$State,y
 lda P$Signal,Y Is signal pending?
 beq SEND40 Branch if not
 deca Is it wake-up?
 beq SEND40 Branch if so
         inc   ,s
 ldb #E$USigP Err: unprocessed signal pending
         bra   SEND75
SEND40 stb P$Signal,Y Save signal
*
* Look for Process in Sleeping Queue
*
 ldx #D.SProcQ-P$Queue Fake process ptr
 clra
 clrb
L0696    leay  ,x
         ldx   P$Queue,x
         beq   SEND66
 ldu P$SP,x get process stack ptr
         addd  R$X,u
         cmpx  $02,s
         bne   L0696
 pshs d save remaining time
 lda P$State,x get process state
 bita #TimSleep is it in timed sleep?
         beq   SEND65
         ldd   ,s
         beq   SEND65
         ldd   $04,u
         pshs  b,a
         ldd   $02,s
         std   $04,u
         puls  b,a
         ldu   $0D,x
         beq   SEND65
         std   ,s
         lda   P$State,u
         bita  #TimSleep
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
SEND68 ldd P$Queue,x Remove from queue
 std P$Queue,Y
 lda P$Signal,X Get signal
 deca Is it wake-up?
         bne   SEND70
         sta   P$Signal,x
         lda   ,s
         tfr   a,cc
SEND70   os9   F$AProc
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
SLEP10 puls cc
 OS9 F$AProc Put process in active queue
         bra   ZZZPRC
SLEP20 ldd R$X,U Get length of sleep
         beq   L0766
 subd #1 count current tick
 std R$X,U update count
 beq SLEP10 branch if done
 pshs y,x Save process & register ptr
 ldx #D.SProcQ-P$Queue Fake process ptr
L072B    std   R$X,u
         stx   2,s
         ldx   P$Queue,x
         beq   L0748
 lda P$State,X Get process status
 bita #TimSleep In timed sleep?
         beq   L0748
         ldy   P$SP,x
         ldd   R$X,u
         subd  $04,y
         bcc   L072B
         nega
         negb
         sbca  #$00
         std   $04,y
L0748    puls  y,x
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
 lda P$State,X Get status
 anda #$FF-TimSleep Set not timed sleep
 sta P$State,X
         puls  pc,cc

L0766    ldx #D.SProcQ-P$Queue Fake process ptr
L0769    leay  0,x Copy process pointer
         ldx   P$Queue,x
         bne   L0769
         ldx   D.PROC
         clra
         clrb
 stx P$Queue,Y Link into queue
 std P$Queue,X
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
ZZZPRC pshs  pc,u,y,x
         leax  <WAKPRC,pcr Get wakeup address
         stx   $06,s
         ldx   D.PROC Get process ptr
         ldb   P$Task,x
         cmpb  D.SysTsk
         beq   ZZZPRC10
         os9   F$DelTsk
ZZZPRC10 ldd   P$SP,x Get process stack
         pshs  dp,b,a,cc
         sts   P$SP,x Note location
 OS9 F$NProc Start another process

WAKPRC    pshs  x
         ldx   D.PROC
         std   P$SP,x
         clrb
         puls  pc,x



*****
*
*  Subroutine Setpri
*
* Set Process Priority
*
SETPRI lda R$A,U Get process id
 lbsr GETPRC Find process descriptor
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
SETSWI ldx D.PROC
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
 tfr dp,a
 ldb   #D.Time
 tfr d,u
 ldy D.PROC
 lda P$Task,y
 ldb D.SysTsk
 ldy #6
 os9 F$Move
 ldx D.PROC
 pshs  x
 ldx D.SysPrc
 stx D.PROC
 lda #SYSTM+OBJCT
 leax <ClockNam,pcr
 os9 F$Link link to clock module
 puls x
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
ALLBIT ldd R$D,u Get beginning bit number
         ldx R$X,u
         bsr   FNDBIT
         ldy   D.PROC
         ldb   P$Task,y
         bra   ALOCAT

SALLBIT  ldd R$D,u
         ldx R$X,u
         bsr FNDBIT
         ldb D.SysTsk
ALOCAT    ldy R$Y,u
         beq   ALOC40
 sta ,-s Save mask
 bmi ALOC15 Branch if first bit of byte
 os9 F$LDABX
ALOC10 ora 0,S Set bit
 leay -1,Y Decrement page count
 beq ALOC35 Branch if done
 lsr 0,S Shift mask
 bcc ALOC10 Branch if more in this byte
 os9 F$STABX
 leax 1,x
ALOC15 lda #$FF Get eight pages worth
 bra ALOC25
ALOC20 os9 F$STABX
 leax 1,x
         leay  -$08,y
ALOC25 cmpy #8 Are there eight left?
         bhi   ALOC20
         beq   ALOC35
ALOC30 lsra
 leay -1,y
 bne ALOC30
 coma
 sta 0,s
 os9 F$LDABX
 ora 0,s
ALOC35 os9 F$STABX
 leas 1,s
ALOC40    clrb
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
 lda b,y
 puls pc,y

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
DELBIT ldd R$D,u Get beginning bit number
 ldx R$X,u
 bsr FNDBIT Adjust map ptr & get bit mask
 ldy D.PROC
 ldb P$Task,y
 bra DEALOC

SDELBIT ldd R$D,u
 ldx R$X,u
 bsr FNDBIT Adjust map ptr & get bit mask
 ldb D.SysTsk
DEALOC ldy R$Y,u
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
 os9   F$STABX
 leax  1,x
DEAL10 clra
 bra DEAL20
DEAL15 os9 F$STABX
 leax 1,x
 leay -8,y
DEAL20 cmpy #8 Are there eight left?
 bhi DEAL15 Branch if so
 beq DEAL30 Branch if done
 coma
DEAL25 lsra
 leay -1,y Decrement page count
 bne DEAL25
 sta 0,s
 os9 F$LDABX
 anda 0,s Clear map bits
DEAL30 os9 F$STABX
 leas 1,s
DEAL40 clrb
 rts

SCHBIT ldd R$D,u Get beginning bit number
 ldx R$X,u Get bit map ptr
 bsr FNDBIT
 ldy D.PROC
 ldb P$Task,y
 bra FLOBLK

SSCHBIT ldd R$D,u
 ldx R$X,u
 lbsr FNDBIT
 ldb D.SysTsk

FLOBLK pshs U,Y,X,D,CC Save registers
 clra
 clrb
 std 3,S Clear size found
 ldy R$D,u Copy beginning page number
 sty 7,S
 bra FLOB20
FLOB10 sty 7,S
FLOB15 lsr 1,S Shift mask
 bcc FLOB25 Branch if mask okay
 ror 1,S Shift mask around end
 leax 1,X Move map ptr
FLOB20 cmpx R$U,u
 bcc FLOB30 Branch if so
 ldb 2,S
 os9 F$LDABX
 sta 0,S
FLOB25 leay  1,y
 lda 0,S Get map byte
 anda 1,S Mask bit
 bne FLOB10 Branch if in use
 tfr y,d Copy page number
 subd 7,S Subtract beginning page number
 cmpd R$Y,u Block big enough?
 bcc FLOB35 Branch if so
 cmpd 3,S Biggest so far?
 bls FLOB15 Branch if not
 std 3,S
 ldd 7,S Copy beginning page number
 std 5,S
 bra FLOB15
FLOB30 ldd 3,S Get beginning page number of largest
 std R$Y,u
 comb SET Carry
 ldd 5,S
 bra FLOB40
FLOB35 ldd 7,S
FLOB40 std R$D,u
 leas 9,S Return scratch
 rts

*
* Get process descriptor copy
*
GPRDSC   ldx   D.PROC
         ldb   P$Task,x
         lda R$A,u   Process id
         os9   F$GProcP
         bcs   GPRDSC10
         lda   D.SysTsk
         leax  ,y
         ldy   #P$Size
         ldu   R$X,u  512 byte buffer
         os9   F$Move
GPRDSC10    rts

*
* Get system block map copy
*
GBLKMP   ldd   #DAT.BlSz
         std R$D,u  Number of bytes per block
         ldd   D.BlkMap+2
         subd  D.BlkMap
         std   R$Y,u
         tfr   d,y
         lda   D.SysTsk
         ldx   D.PROC
         ldb   P$Task,x
         ldx   D.BlkMap
         ldu   R$X,u   1024 byte buffer
         os9   F$Move
         rts

*
* Get module directory copy
*
GMODDR   ldd   D.ModDir+2
         subd  D.ModDir
         tfr   d,y
         ldd   D.ModEnd
         subd  D.ModDir
         ldx R$X,u  2048 byte buffer pointer
         leax  d,x
         stx   R$Y,u
         ldx   D.ModDir
         stx   R$u,u
         lda   D.SysTsk
         ldx   D.PROC
         ldb   P$Task,x
         ldx   D.ModDir
         ldu   R$X,u
         os9   F$Move
         rts

SETUSER ldx D.PROC
 ldd R$Y,u   Desired user id number
 std P$User,x
 clrb
 rts

CPYMEM   ldd   R$Y,u byte count
         beq   L0A04
         addd  R$U,u  destination buffer
         ldy   D.TmpDAT
         leay  <DAT.ImSz,y
         sty   D.TmpDAT
         leay  <-DAT.ImSz,y
         pshs  y,d
         ldy   D.PROC
         ldb   P$Task,y
         pshs  b
         ldx   R$D,u  pointer to DAT image
         leay  P$DATImg,y
         ldb   #DAT.BlCt
         pshs  u,b
         ldu   $06,s
L09C7    clra
         clrb
         os9   F$LDDDXY
         std   ,u++
         leax  $02,x
         dec   ,s
         bne   L09C7
         puls  u,b
         ldx R$X,u  offset in block to begin copy
         ldu   R$U,u  destination buffer
         ldy   $03,s
L09DD    cmpx  #DAT.BlSz
         bcs   L09EA
         leax  -DAT.BlSz,x
         leay  $02,y
         bra   L09DD
L09EA    os9   F$LDAXY
         ldb   ,s
         pshs  x
         leax  ,u+
         os9   F$STABX
         puls  x
         leax  1,x
         cmpu  1,s
         bcs   L09DD
         puls  y,x,b
         sty   D.TmpDAT
L0A04    clrb
         rts

UNLOAD   pshs  u
         lda R$A,u  module type
         ldx   D.PROC
         leay  P$DATImg,x
         ldx R$X,u  module name pointer
         os9   F$FModul
         puls  y
         bcs   L0A51
         stx   $04,y
         ldx   R$Y,u
         beq   L0A24
         leax  -1,x
         stx   R$Y,u
         bne   L0A50
L0A24    cmpa  #$D0
         bcs   L0A4D
         clra
         ldx   [,u]
         ldy   D.SysDAT
L0A2E    adda  #$02
         cmpa  #DAT.ImSz
         bcc   L0A4D
         cmpx  a,y
         bne   L0A2E
         lsla
         lsla
         lsla
 ifge DAT.BlSz-$2000
         lsla
 endc
         clrb
         addd  R$X,u
         tfr   d,x
         os9   F$IODel
         bcc   L0A4D
         ldx   R$Y,u
         leax  1,x
         stx   R$Y,u
         bra   L0A51
L0A4D    lbsr  L01FA
L0A50    clrb
L0A51    rts
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
 beq RTRNEX
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
RTRNEX puls D,X,Y,U,PC Return to caller


GPROCP lda R$A,u
         bsr   GETPRC
         bcs   GPROCP10
         sty R$Y,u
GPROCP10    rts

* Find process descriptor from process ID
GETPRC    pshs  x,b,a
         ldb   ,s
         beq   GETPRC10
         ldx   D.PrcDBT
         abx
         lda   P$ID,x
         beq   GETPRC10
         clrb
         tfr   d,y
         puls  pc,x,b,a
GETPRC10    puls  x,b,a
         comb
         ldb   #E$BPrcId
         rts

*****
*
*  Deallocate image RAM blocks
*
DELIMG ldx R$X,u process descriptor pointer
 ldd R$D,u beginning block number and count
 leau  P$DATImg,x
 lsla multiply by 2
 leau a,u
 clra
 tfr d,y
 pshs x
DELIMG10 ldd ,u
         addd  D.BlkMap
         tfr   d,x
         lda   0,x
         anda  #$FE
         sta   0,x
         ldd   #DAT.Free
         std   ,u++
         leay  -1,y
         bne   DELIMG10
         puls  x
         lda   P$State,x
         ora   #ImgChg
         sta   P$State,x
         clrb
         rts

MAPBLK   lda   R$B,u  Number of blocks
         cmpa  #DAT.BlCt
         bcc   IBAERR
         leas  <-DAT.ImSz,s
         ldx R$X,u
         leay  ,s
MAPBLK10    stx   ,y++
         leax  1,x
         deca
         bne   MAPBLK10
         ldb R$B,u
         ldx   D.PROC
         leay  P$DATImg,x
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
         ldd   ,s
         pshs  u
         leau  $04,s
         os9   F$SetImg
         puls  u
         cmpx  D.SysPrc
         bne   MAPBLK40
         tfr   x,y
         ldx   D.SysMem
         ldb   R$U,u
         abx
         leay  P$DATImg,y
         lda   ,s
         lsla
         leay  a,y
         ldu   D.BlkMap
MAPBLK20    ldd   ,y++
         lda   d,u
         ldb   #$10
MAPBLK30    sta   ,x+
         decb
         bne   MAPBLK30
         dec   1,s
         bne   MAPBLK20
MAPBLK40    leas  $02,s
         clrb
MAPBLK50    leas  <$20,s
         rts

IBAERR comb
 ldb #E$IBA illegal block address
 rts

CLRBLK   ldb R$B,u Get number of blocks
         beq   CLRBLK50
         ldd   R$U,u Get address of first block
         tstb
         bne   IBAERR
         bita  #(DAT.BlSz/256)-1
         bne   IBAERR
         ldx   D.PROC
         cmpx  D.SysPrc
         beq   CLRBLK10
         lda   P$SP,x
         anda  #$F0
         suba  R$U,u
         bcs   CLRBLK10
         lsra
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra
 endc
         cmpa  R$B,u
         bcs   IBAERR
CLRBLK10 lda   R$U,u
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra
 endc
         leay  P$DATImg,x
         leay  a,y
         ldb R$B,u get number of blocks
 ldx #DAT.Free
CLRBLK20 stx ,y++ mark as free
 decb
 bne CLRBLK20
         ldx   D.PROC
         lda   P$State,x
         ora   #ImgChg
         sta   P$State,x
         cmpx  D.SysPrc
         bne   CLRBLK50
         ldx   D.SysMem
         ldb R$U,u
         abx
         ldb R$B,u
CLRBLK30 lda #16
CLRBLK40 clr ,x+
         deca
         bne   CLRBLK40
         decb
         bne   CLRBLK30
CLRBLK50 clrb
 rts

DELRAM   ldb R$B,u
         beq   L0C55
         ldd   D.BlkMap+2
         subd  D.BlkMap
         subd  R$X,u
         bls   L0C55
         tsta
         bne   L0C44
         cmpb  R$B,u
         bcc   L0C44
         stb R$B,u
L0C44    ldx   D.BlkMap
         ldd   R$X,u
         leax  d,x
         ldb R$B,u
L0C4C    lda   ,x
         anda  #$FE
         sta   ,x+
         decb
         bne   L0C4C
L0C55    clrb
         rts

*****
*
*
GCMDIR ldx D.ModDir
 bra   GCMDIR20
GCMDIR10 ldu   MD$MPDAT,x Is there a DAT Image?
 beq   GCMDIR30 ..yes
 leax  MD$ESize,x
GCMDIR20 cmpx D.ModEnd
 bne GCMDIR10
         bra   L0C8F
GCMDIR30    tfr   x,y
         bra   L0C6F
L0C6B    ldu   ,y
         bne   L0C78
L0C6F    leay  MD$ESize,y
         cmpy  D.ModEnd
         bne   L0C6B
         bra   L0C8D
L0C78    ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         cmpy  D.ModEnd
         bne   L0C6B
L0C8D    stx   D.ModEnd
L0C8F    ldx   D.ModDir+2
         bra   L0C97
L0C93    ldu   ,x
         beq   L0C9F
L0C97    leax  -$02,x
         cmpx  D.ModDat
         bne   L0C93
         bra   L0CD7
L0C9F    ldu   -$02,x
         bne   L0C97
         tfr   x,y
         bra   L0CAB
L0CA7    ldu   ,y
         bne   L0CB4
L0CAB    leay  -$02,y
L0CAD    cmpy  D.ModDat
         bcc   L0CA7
         bra   L0CC5
L0CB4    leay  $02,y
         ldu   ,y
         stu   ,x
L0CBA    ldu   ,--y
         stu   ,--x
         beq   L0CCB
         cmpy  D.ModDat
         bne   L0CBA
L0CC5    stx   D.ModDat
         bsr   L0CD9
         bra   L0CD7
L0CCB    leay  $02,y
         leax  $02,x
         bsr   L0CD9
         leay  -$04,y
         leax  -$02,x
         bra   L0CAD
L0CD7    clrb
         rts
L0CD9    pshs  u
         ldu   D.ModDir
         bra   L0CE8
L0CDF    cmpy  ,u
         bne   L0CE6
         stx   ,u
L0CE6    leau  8,u
L0CE8    cmpu  D.ModEnd
         bne   L0CDF
         puls  pc,u
         emod
OS9End   equ   *
