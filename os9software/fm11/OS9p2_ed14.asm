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

         fcb   14 Edition

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
* Decrment Link Count. If Count Reaches Zero,
*    Delete Module From Directory & Return Memory
*
UNLINK   pshs  u,b,a
         ldd   R$U,u
         ldx   R$U,u
         lsra
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra
 endc
         sta   ,s
         beq   UNLK08
         ldu   D.PROC
         leay  P$DATImg,u
         lsla
    ldd   a,y
         ldu   D.BlkMap
         ldb   d,u
         bitb  #$02
         beq   UNLK08
         leau  P$DATImg,y
         bra   UNLK04
UNLK03    dec   ,s
         beq   UNLK08
UNLK04    ldb   ,s
         lslb
         ldd   b,u
         beq   UNLK03
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
         ldu   D.ModDir
         bra   UNLK10
UNLK06    leau  8,u
         cmpu  D.ModEnd
         bcs   UNLK10
UNLK08    bra   UNLK25
UNLK10    cmpx  R$X,u
         bne   UNLK06
         cmpd  [,u]
         bne   UNLK06
         ldx   R$Y,u
         beq   L0192
         leax  -$01,x
         stx   R$Y,u
         bne   L01AF
L0192    ldx   $02,s
         ldx   $08,x
         ldd   #6
         os9   F$LDDDXY
         cmpa #FLMGR Is i/o module?
         bcs   UNLK20
         os9   F$IODel
         bcc   UNLK20
         ldx   R$Y,u
         leax  $01,x
         stx   R$Y,u
         bra   L01CB
UNLK20    bsr   L01CF
L01AF    ldb   ,s
         lslb
         leay  b,y
         ldx   <$40,y
         leax  -1,x
         stx   <$40,y
         bne   UNLK25
         ldd   2,u
         bsr   DIVBKSZ
         ldx   #$00FE
L01C5    stx   ,y++
         deca
         bne   L01C5
UNLK25    clrb
L01CB    leas  $02,s
         puls  pc,u

L01CF    ldx   D.BlkMap
         ldd   [,u]
         lda   d,x
         bmi   L021F
         ldx   D.ModDir
L01D9    ldd   [,x]
         cmpd  [,u]
         bne   L01E4
         ldd   $06,x
         bne   L021F
L01E4    leax  $08,x
         cmpx  D.ModEnd
         bcs   L01D9
         ldx   D.BlkMap
         ldd   2,u
         bsr   DIVBKSZ
         pshs  y
         ldy   ,u
L01F5    pshs  x,a
         ldd   ,y
         clr   ,y+
         clr   ,y+
         leax  d,x
         ldb   ,x
         andb  #$FC
         stb   ,x
         puls  x,a
         deca
         bne   L01F5
         puls  y
         ldx   D.ModDir
         ldd   ,u
L0210    cmpd  ,x
         bne   L0219
         clr   ,x
         clr   $01,x
L0219    leax  $08,x
         cmpx  D.ModEnd
         bcs   L0210
L021F    rts

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
         lbsr  L02DD
         bcc   L0231
         puls  pc,u
L0231    pshs  u
         ldx   D.PROC
         ldd   P$User,x
         std   P$User,u
         lda   P$Prior,x
         sta   P$Prior,u
         leax  P$DIO,x
         leau  P$DIO,u
         ldb   #$10
FORK10    lda   ,x+
         sta   ,u+
         decb
         bne   FORK10
         ldy   #3     dup the first three open paths
FORK20    lda   ,x+
         beq   FORK25
         os9   I$Dup
         bcc   FORK25
         clra
FORK25    sta   ,u+
         leay  -1,y
         bne   FORK20
*
         leax  <$6D,x
         leau  <$6D,u
         ldb   #$20
L0268    lda   ,x+
*
         sta   ,u+
         decb
         bne   L0268
         ldx   ,s
         ldu   $02,s
         lbsr  SETPRC
         bcs   FORK40
         pshs  b,a
         os9   F$AllTsk
         bcc   FORK30
FORK30    lda   $07,x
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
         std   $01,x
         lda   $0C,x
         anda  #$7F
         sta   $0C,x
         os9   F$AProc
         rts
FORK40    puls  x
         pshs  b
         lbsr  CLOSEPD
         lda   ,x
         lbsr  L0369
         comb
         puls  pc,u,b

ALLPRC   pshs  u
         bsr   L02DD
         bcs   L02DB
         ldx   ,s
         stu   R$U,x
L02DB    puls  pc,u

L02DD    ldx   D.PrcDBT
L02DF    lda   ,x+
         bne   L02DF
         leax  -$01,x
         tfr   x,d
         subd  D.PrcDBT
         tsta
         beq   L02F1
         comb
         ldb   #$E5
         bra   L0322
L02F1    pshs  b
         ldd   #$0200
         os9   F$SRqMem
         puls  a
         bcs   L0322
         sta   ,u
         tfr   u,d
         sta   ,x
         clra
         leax  1,u
         ldy   #$0080
L030A    std   ,x++
         leay  -$01,y
         bne   L030A
         lda   #SysState
         sta   P$State,u
         ldb   #DAT.BlCt
         ldx   #DAT.Free
         leay  P$DATImg,u
L031C    stx   ,y++
         decb
         bne   L031C
         clrb
L0322    rts

DELPRC   lda R$A,u
         bra   L0369

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
L0369    pshs  u,x,b,a
         ldb   ,s
         ldx   D.PrcDBT
         abx
         lda   ,x
         beq   L0384
         clrb
         stb   ,x
         tfr   d,x
         os9   F$DelTsk
         leau  ,x
         ldd   #$0200
         os9   F$SRtMem
L0384    puls  pc,u,x,b,a



*****
*
* Subroutine Chain
*
* Execute Overlay
*
CHAIN    pshs  u
         lbsr  L02DD
         bcc   L038F
         puls  pc,u

L038F    ldx   D.PROC
         pshs  u,x
         leax  P$SP,x
         leau  P$SP,u
         ldy   #$007E
L039B    ldd   ,x++
         std   ,u++
         leay  -$01,y
         bne   L039B
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
L03D5    stu   ,y++
         deca
         bne   L03D5
         ldu   $02,s
         stu   D.PROC
         ldu   $04,s
         lbsr  SETPRC
         lbcs  L046A
         pshs  b,a
         os9   F$AllTsk
         bcc   L03EE
L03EE    ldu   D.PROC
         lda   P$Task,u
         ldb   $06,x
         leau  (P$Stack-R$Size),x
         leax  ,y
         ldu   P$SP,u
         pshs  u
         cmpx  ,s++
         puls  y
         bhi   L043A
         beq   L043D
         leay  ,y
         beq   L043D
         pshs  x,b,a
         tfr   y,d
         leax  d,x
         pshs  u
         cmpx  ,s++
         puls  x,b,a
         bls   L043A
         pshs  u,y,x,b,a
         tfr   y,d
         leax  d,x
         leau  d,u
L0420    ldb   ,s
         leax  -$01,x
         os9   F$LDABX
         exg   x,u
         ldb   $01,s
         leax  -$01,x
         os9   F$STABX
         exg   x,u
         leay  -$01,y
         bne   L0420
         puls  u,y,x,b,a
         bra   L043D
L043A    os9   F$Move
L043D    lda   D.SysTsk
         ldx   ,s
         ldu   $04,x
         leax  (P$Stack-R$Size),x
         ldy   #$000C
         os9   F$Move
         puls  u,x
         lda   ,u
         lbsr  L0369
         os9   F$DelTsk
         orcc  #$50
         ldd   D.SysPrc
         std   D.PROC
         lda   $0C,x
         anda  #$7F
         sta   $0C,x
         os9   F$AProc
         os9   F$NProc
L046A    puls  u,x
         stx   D.PROC
         pshs  b
         lda   ,u
         lbsr  L0369
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
         lbsr  GETPRC
         clr   $01,y
         lda   $0C,y
         bita  #$01
         beq   EXIT30
         lda   ,y
         lbsr  L0369
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
         lbsr  L0369
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
         beq   L0593
         addb  #$0F
         lsrb
         lsrb
         lsrb
         lsrb
 ifge DAT.BlSz-$2000
         lsrb
 endc
         os9   F$DelImg
L0593    ldd   D.PROC
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
         beq   USRM35
         addd  #$00FF
         cmpa  $07,x
         beq   USRM35
         pshs  a
         bcc   L05C4
         deca
         ldb   #$F4
         cmpd  $04,x
         bcc   L05C4
         ldb   #$DF
         bra   L05E7
L05C4    lda   $07,x
         adda  #$0F
         lsra
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra
 endc
         ldb   ,s
         addb  #$0F
         bcc   L05D6
         ldb   #$CF
         bra   L05E7
L05D6    lsrb
         lsrb
         lsrb
         lsrb
 ifge DAT.BlSz-$2000
         lsrb
 endc
         pshs  a
         subb  ,s+
         beq   L05F4
         bcs   L05EC
         os9   F$AllImg
         bcc   L05F4
L05E7    leas  $01,s
         orcc  #$01
         rts
L05EC    pshs  b
         adda  ,s+
         negb
         os9   F$DelImg
L05F4    puls  a
         sta   $07,x
USRM35    lda   $07,x
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
         lda R$A,u
         bne   SENSUB
         inca
SEND10    cmpa  ,x
         beq   SEND15
         bsr   SENSUB
SEND15    inca
         bne   SEND10
         clrb
         rts

*
* Get destination Process ptr
*
SENSUB    lbsr  GETPRC
         pshs  u,y,a,cc
         bcs   SEND17
         tst   R$B,u Is it unconditional abort signal (code 0)?
         bne   SEND20
         ldd   $08,x
         beq   SEND20
         cmpd  $08,y
         beq   SEND20
         ldb   #$E0
         inc   ,s
SEND17    lbra  SEND75
SEND20    orcc  #$50
         ldb R$B,u
         bne   SEND30
         ldb   #$E4
         lda   $0C,y
         ora   #$02
         sta   $0C,y
SEND30    lda   $0C,y
         anda  #$F7
         sta   $0C,y
         lda   <$19,y
         beq   SEND40
         deca
         beq   SEND40
         inc   ,s
         ldb   #$E9
         bra   SEND75
SEND40 stb P$Signal,Y Save signal
*
* Look for Process in Sleeping Queue
*
 ldx #D.SProcQ-P$Queue Fake process ptr
 clra
 clrb
L0657    leay  ,x
         ldx   P$Queue,x
         beq   SEND66
 ldu P$SP,x get process stack ptr
         addd  R$X,u
         cmpx  $02,s
         bne   L0657
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
         beq   L0727
 subd #1 count current tick
 std R$X,U update count
 beq SLEP10 branch if done
         pshs  y,x
         ldx   #$0049
L06EC    std   R$X,u
         stx   $02,s
         ldx   $0D,x
         beq   L0709
         lda   $0C,x
         bita  #$40
         beq   L0709
         ldy   $04,x
         ldd   R$X,u
         subd  $04,y
         bcc   L06EC
         nega
         negb
         sbca  #$00
         std   $04,y
L0709    puls  y,x
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
L0727    ldx   #$0049
L072A    leay  ,x
         ldx   $0D,x
         bne   L072A
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
         lbsr  GETPRC
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
         tfr   dp,a
         ldb   #$28
         tfr   d,u
         ldy   D.PROC
         lda   $06,y
         ldb   D.SysTsk
         ldy   #$0006
         os9   F$Move
         ldx   D.PROC
         pshs  x
         ldx   D.SysPrc
         stx   D.PROC
         lda   #$C1
         leax  <ClockNam,pcr
         os9   F$Link
         puls  x
         stx   D.PROC
         bcs   SeTime99
         jmp   ,y
SeTime99    rts
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
ALLBIT   ldd R$D,u
         ldx R$X,u
         bsr   FNDBIT
         ldy   D.PROC
         ldb   $06,y
         bra   ALOCAT

SALLBIT  ldd R$D,u
         ldx R$X,u
         bsr   FNDBIT
         ldb   D.SysTsk
ALOCAT    ldy R$Y,u
         beq   ALOC40
         sta   ,-s
         bmi   ALOC15
         os9   F$LDABX
ALOC10    ora   ,s
         leay  -$01,y
         beq   ALOC35
         lsr   ,s
         bcc   ALOC10
         os9   F$STABX
         leax  $01,x
ALOC15    lda   #$FF
         bra   ALOC25
ALOC20    os9   F$STABX
         leax  $01,x
         leay  -$08,y
ALOC25    cmpy  #$0008
         bhi   ALOC20
         beq   ALOC35
ALOC30    lsra
         leay  -$01,y
         bne   ALOC30
         coma
         sta   ,s
         os9   F$LDABX
         ora   ,s
ALOC35    os9   F$STABX
         leas  $01,s
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
         leax  d,x
         puls  b
         leay  <BITTBL,pcr
         andb  #$07
         lda   b,y
         puls  pc,y

BITTBL    fcb  $80,$40,$20,$10,$08,$04,$02,$01

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
DELBIT   ldd R$D,u
         ldx R$X,u
         bsr   FNDBIT
         ldy   D.PROC
         ldb   $06,y
         bra   DEALOC

SDELBIT  ldd R$D,u
         ldx R$X,u
         bsr   FNDBIT
         ldb   D.SysTsk
DEALOC ldy R$Y,u
         beq   DEAL40
         coma
         sta   ,-s
         bpl   DEAL10
         os9   F$LDABX
DEAL05    anda  ,s
         leay  -$01,y
         beq   DEAL30
         asr   ,s
         bcs   DEAL05
         os9   F$STABX
         leax  $01,x
DEAL10    clra
         bra   DEAL20
DEAL15    os9   F$STABX
         leax  $01,x
         leay  -$08,y
DEAL20    cmpy  #$0008
         bhi   DEAL15
         beq   DEAL30
         coma
DEAL25    lsra
         leay  -$01,y
         bne   DEAL25
         sta   ,s
         os9   F$LDABX
         anda  ,s
DEAL30    os9   F$STABX
         leas  $01,s
DEAL40    clrb
         rts

SCHBIT   ldd R$D,u Get beginning bit number
         ldx R$X,u Get bit map ptr
         bsr   FNDBIT
         ldy   D.PROC
         ldb   $06,y
         bra   FLOBLK

SSCHBIT  ldd R$D,u
         ldx R$X,u
         lbsr  FNDBIT
         ldb   D.SysTsk

FLOBLK pshs U,Y,X,D,CC Save registers
 clra
 clrb
 std 3,S Clear size found
 ldy R$D,u Copy beginning page number
         sty   $07,s
         bra   FLOB20
FLOB10    sty   $07,s
FLOB15    lsr   $01,s
         bcc   FLOB25
         ror   $01,s
         leax  $01,x
FLOB20 cmpx R$U,u
         bcc   FLOB30
         ldb   $02,s
         os9   F$LDABX
         sta   ,s
FLOB25    leay  $01,y
         lda   ,s
         anda  $01,s
         bne   FLOB10
         tfr   y,d
         subd  $07,s
 cmpd R$Y,u Block big enough?
         bcc   FLOB35
         cmpd  $03,s
         bls   FLOB15
         std   $03,s
         ldd   $07,s
         std   $05,s
         bra   FLOB15
FLOB30    ldd   $03,s
 std R$Y,u
         comb
         ldd   $05,s
         bra   FLOB40
FLOB35    ldd   $07,s
FLOB40 std R$D,u
         leas  $09,s
         rts

GPRDSC   ldx   D.PROC
         ldb   $06,x
         lda R$A,u   Process id
         os9   F$GProcP
         bcs   GPRDSC10
         lda   D.SysTsk
         leax  ,y
         ldy   #P$Size
         ldu   R$X,u  512 byte buffer
         os9   F$Move
GPRDSC10    rts

GBLKMP   ldd   #DAT.BlSz
         std R$D,u
         ldd   D.BlkMap+2
         subd  D.BlkMap
         std   R$Y,u
         tfr   d,y
         lda   D.SysTsk
         ldx   D.PROC
         ldb   $06,x
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
         ldx R$X,u
         leax  d,x
         stx   R$Y,u
         ldx   D.ModDir
         stx   R$u,u
         lda   D.SysTsk
         ldx   D.PROC
         ldb   $06,x
         ldx   D.ModDir
         ldu   R$X,u
         os9   F$Move
         rts

SETUSER  ldx   D.PROC
         ldd   R$Y,u
         std   P$User,x
         clrb
         rts

CPYMEM   ldd   R$Y,u
         beq   L09BE
         addd  R$U,u  destination buffer
         leas  <-$20,s
         leay  ,s
         pshs  y,b,a
         ldy   D.PROC
         ldb   $06,y
         pshs  b
         ldx   R$D,u  pointer to DAT image
         leay  <$40,y
         ldb   #$10
         pshs  u,b
         ldu   $06,s
L0981    clra
         clrb
         os9   F$LDDDXY
         std   ,u++
         leax  $02,x
         dec   ,s
         bne   L0981
         puls  u,b
         ldx R$X,u
         ldu   R$U,u  destination buffer
         ldy   $03,s
L0997    cmpx  #$1000
         bcs   L09A4
         leax  >-$1000,x
         leay  $02,y
         bra   L0997
L09A4    os9   F$LDAXY
         ldb   ,s
         pshs  x
         leax  ,u+
         os9   F$STABX
         puls  x
         leax  $01,x
         cmpu  $01,s
         bcs   L0997
         puls  y,x,b
         leas  <$20,s
L09BE    clrb
         rts

UNLOAD   pshs  u
         lda R$A,u
         ldx   D.PROC
         leay  P$DatImg,x
         ldx R$X,u
         os9   F$FModul
         puls  y
         bcs   L0A0B
         stx   $04,y
         ldx   R$Y,u
         beq   L09DE
         leax  -$01,x
         stx   R$Y,u
         bne   L0A0A
L09DE    cmpa  #$D0
         bcs   L0A07
         clra
         ldx   [,u]
         ldy   D.SysDAT
L09E8    adda  #$02
         cmpa  #$20
         bcc   L0A07
         cmpx  a,y
         bne   L09E8
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
         bcc   L0A07
         ldx   R$Y,u
         leax  $01,x
         stx   R$Y,u
         bra   L0A0B
L0A07    lbsr  L01CF
L0A0A    clrb
L0A0B    rts
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
F64      lda R$A,u
         ldx R$X,u
         bsr   FINDPD
         bcs   F6410
 sty R$Y,U
F6410    rts

FINDPD    pshs  b,a
         tsta
         beq   FPDERR
         clrb
         lsra
         rorb
         lsra
         rorb
         lda   a,x
         tfr   d,y
         beq   FPDERR
         tst   ,y
         bne   FINDP9
FPDERR    coma
FINDP9    puls  pc,b,a

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
         bsr   GETPRC
         bcs   GPROCP10
         sty R$Y,u
GPROCP10    rts

* Find process descriptor
GETPRC    pshs  x,b,a
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

CLRBLK   ldb R$B,u
         beq   CLRBLK50
         ldd   R$U,u Get address of first block
         tstb
         bne   IBAERR
         bita  #$0F
         bne   IBAERR
         ldx   D.PROC
         lda   $04,x
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
CLRBLK10    lda   $0C,x
         ora   #$10
         sta   $0C,x
         lda   R$U,u
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra
 endc
         leay  P$DatImg,x
         leay  a,y
         ldb R$B,u
         ldx   #$00FE
CLRBLK20    stx   ,y++
         decb
         bne   CLRBLK20
CLRBLK50    clrb
         rts

DELRAM   ldb R$B,u
         beq   L0BC9
         ldd   D.BlkMap+2
         subd  D.BlkMap
         subd  R$X,u
         bls   L0BC9
         tsta
         bne   L0BB8
         cmpb  R$B,u
         bcc   L0BB8
         stb R$B,u
L0BB8    ldx   D.BlkMap
         ldd   R$X,u
         leax  d,x
         ldb R$B,u
L0BC0    lda   ,x
         anda  #$FE
         sta   ,x+
         decb
         bne   L0BC0
L0BC9    clrb
         rts

GCMDIR   ldx   D.ModDir
         bra   L0BD5
L0BCF    ldu   ,x
         beq   L0BDB
         leax  $08,x
L0BD5    cmpx  D.ModEnd
         bne   L0BCF
         bra   L0C03
L0BDB    tfr   x,y
         bra   L0BE3
L0BDF    ldu   ,y
         bne   L0BEC
L0BE3    leay  $08,y
         cmpy  D.ModEnd
         bne   L0BDF
         bra   L0C01
L0BEC    ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         cmpy  D.ModEnd
         bne   L0BDF
L0C01    stx   D.ModEnd
L0C03    ldx   D.ModDir+2
         bra   L0C0B
L0C07    ldu   ,x
         beq   L0C13
L0C0B    leax  -$02,x
         cmpx  D.ModDat
         bne   L0C07
         bra   L0C4B
L0C13    ldu   -$02,x
         bne   L0C0B
         tfr   x,y
         bra   L0C1F
L0C1B    ldu   ,y
         bne   L0C28
L0C1F    leay  -$02,y
L0C21    cmpy  D.ModDat
         bcc   L0C1B
         bra   L0C39
L0C28    leay  $02,y
         ldu   ,y
         stu   ,x
L0C2E    ldu   ,--y
         stu   ,--x
         beq   L0C3F
         cmpy  D.ModDat
         bne   L0C2E
L0C39    stx   D.ModDat
         bsr   L0C4D
         bra   L0C4B
L0C3F    leay  $02,y
         leax  $02,x
         bsr   L0C4D
         leay  -$04,y
         leax  -$02,x
         bra   L0C21
L0C4B    clrb
         rts
L0C4D    pshs  u
         ldu   D.ModDir
         bra   L0C5C
L0C53    cmpy  ,u
         bne   L0C5A
         stx   ,u
L0C5A    leau  8,u
L0C5C    cmpu  D.ModEnd
         bne   L0C53
         puls  pc,u
         emod
OS9End      equ   *
