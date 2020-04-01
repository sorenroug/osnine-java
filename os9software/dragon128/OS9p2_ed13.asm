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
         ldd   MaxMem,u
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         addd  D.BlkMap
         tfr   d,x
         ldb   #$80
         bra   L0034

L002E    lda   ,x+
         bne   L0034
         stb   -1,x
L0034    cmpx  D.BlkMap+2
         bcs   L002E
L0038    ldu   D.Init
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
 ifne ClocType
* Clock init start
* Reset to 0
L0057    ldb   #$06
L0059    clr   ,-s
         decb
         bne   L0059
         leax  ,s
         os9   F$STime
         leas  6,s
 endc
* Clock init end
 ldd SYSSTR,U Get system device name
         beq   SETSTDS    No system device
 leax D,U Get name ptr
 lda #EXEC.+READ. Set both execution & data
 OS9 I$ChgDir Set default directory
         bcc   SETSTDS
         os9   F$Boot
         bcc   L0038
SETSTDS    ldu   D.Init
 ldd STDSTR,U get name offset
         beq   LOADP3
 leax D,U get name ptr
 lda #UPDAT. set mode
 OS9 I$OPEN open file
         bcc   SETSTD05
         os9   F$Boot
         bcc   SETSTDS
         bra   LOADP3

SETSTD05 ldx D.PROC
 sta P$PATH,X set standard input
 OS9 I$DUP count open image
 sta P$PATH+1,X set standard output
 OS9 I$DUP count open image
 sta P$PATH+2,X set standard error
LOADP3    leax  <OS9P3STR,pcr
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
         os9   F$Fork
         os9   F$NProc

OS9P3STR    fcs "OS9p3"

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
IOSTR    fcs "IOMan"

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
 ldd R$U,U Get module address
         ldx   R$U,u
         lsra
         lsra
         lsra
         lsra
         sta   ,s
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
         clrb
         nega
         leax  d,x
         ldb   ,s
         lslb
         ldd   b,y
         ldu   D.ModDir
         bra   L01AA
L01A1    leau  R$U,u
         cmpu  D.ModEnd
         bcs   L01AA
L01A8    bra   L01F5
L01AA    cmpx  R$X,u
         bne   L01A1
         cmpd  [,u]
         bne   L01A1
         ldx   R$Y,u
         beq   L01BD
         leax  -$01,x
         stx   R$Y,u
         bne   L01DA
L01BD    ldx   $02,s
         ldx   $08,x
         ldd   #$0006
         os9   F$LDDDXY
         cmpa #FLMGR Is i/o module?
         bcs   UNLK20
         os9   F$IODel
         bcc   UNLK20
         ldx   R$Y,u
         leax  $01,x
         stx   R$Y,u
         bra   L01F6
UNLK20    bsr   L01FA
L01DA    ldb   ,s
         lslb
         leay  b,y
         ldx   P$DATImg,y
         leax  -1,x
         stx   P$DATImg,y
         bne   L01F5
         ldd   2,u
         bsr   DIVBKSZ
         ldx   #DAT.Free
L01F0    stx   ,y++
         deca
         bne   L01F0
L01F5    clrb
L01F6    leas  $02,s
         puls  pc,u

L01FA    ldx   D.BlkMap
         ldd   [,u]
         lda   d,x
         bmi   L024A
         ldx   D.ModDir
L0204    ldd   [,x]
         cmpd  [,u]
         bne   L020F
         ldd   $06,x
         bne   L024A
L020F    leax  $08,x
         cmpx  D.ModEnd
         bcs   L0204
         ldx   D.BlkMap
         ldd   2,u
         bsr   DIVBKSZ
         pshs  y
         ldy   ,u
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
         ldd   ,u
L023B    cmpd  ,x
         bne   L0244
         clr   ,x
         clr   $01,x
L0244    leax  $08,x
         cmpx  D.ModEnd
         bcs   L023B
L024A    rts

*****
*
* Subroutine DivBkSz
*
* Divide By block size, Rounding Up
DIVBKSZ    addd  #DAT.Blsz-1
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
         bcc   L025C
         puls  pc,u
L025C    pshs  u
         ldx   D.PROC
         ldd   P$User,x
         std   P$User,u
         lda   P$Prior,x
         sta   P$Prior,u
         leax  P$DIO,x
         leau  P$DIO,u
         ldb   #DefIOSiz
L0270    lda   ,x+
         sta   ,u+
         decb
         bne   L0270
         ldy   #3     dup the first three open paths
L027B    lda   ,x+
         beq   L0285
         os9   I$Dup
         bcc   L0285
         clra
L0285    sta   ,u+
         leay  -1,y
         bne   L027B
         ldx   ,s
         ldu   $02,s
         lbsr  L04B3
         bcs   L02DE
         pshs  b,a
         os9   F$AllTsk
         bcc   L029B
L029B    lda   $07,x
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
         ldy   D.PROC
         lda   ,x
         sta R$A,u
         ldb   $03,y
         sta   $03,y
         lda   ,y
         std   $01,x
         lda   $0C,x
         anda  #$7F
         sta   $0C,x
         os9   F$AProc
         rts
L02DE    puls  x
         pshs  b
         lbsr  L05A7
         lda   ,x
         lbsr  L039D
         comb
         puls  pc,u,b

ALLPRC   pshs  u
         bsr   L02F9
         bcs   L02F7
         ldx   ,s
         stu   R$U,x
L02F7    puls  pc,u

L02F9    ldx   D.PrcDBT
L02FB    lda   ,x+
         bne   L02FB
         leax  -$01,x
         tfr   x,d
         subd  D.PrcDBT
         tsta
         beq   L030D
         comb
         ldb   #E$PrcFul
         bra   L0356
L030D    pshs  b
         ldd   #$0200
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
         leay  -$01,y
         bne   L0326
         lda   #$80
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
         leay  >P$ErrNam,u    Area for error messages
         ldx   D.PROC
         leax  >P$ErrNam,x    Area for error messages
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
WAIT     ldx   D.PROC
         lda   P$CID,x
         beq   L037F
WAIT10    lbsr  GETPRC
 lda P$State,Y Get child's status
 bita #DEAD Is child dead?
         bne   CHILDS
         lda   P$SID,y
         bne   WAIT10
         sta R$A,u
         pshs  cc
         orcc #IRQMask+FIRQMask Set interrupt masks
         ldd   D.WProcQ
         std   P$Queue,x
         stx   D.WProcQ
         puls  cc
         lbra  ZZZPRC
L037F    comb Set Carry
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
         leau  ,y
 leay P$CID-P$SID,X Fake sibling process ptr
         bra   CHIL20
CHIL10    lbsr  GETPRC Get process ptr
CHIL20 lda P$SID,Y Is child next sibling?
 cmpa 0,u
 bne CHIL10 Branch if not
 ldb P$SID,U Get child's sibling
 stb P$SID,Y Remove child from sibling list
L039D    pshs  u,x,b,a
         ldb   ,s
         ldx   D.PrcDBT
         abx
         lda   ,x
         beq   L03B8
         clrb
         stb   ,x
         tfr   d,x
         os9   F$DelTsk
         leau  ,x
         ldd   #$0200
         os9   F$SRtMem
L03B8    puls  pc,u,x,b,a

CHAIN    pshs  u
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
         leay  -$01,y
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
         lda   #$0F
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
         lbsr  L04B3
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
         leax  -$01,x
         os9   F$LDABX
         exg   x,u
         ldb   $01,s
         leax  -$01,x
         os9   F$STABX
         exg   x,u
         leay  -$01,y
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
         orcc  #$50
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
L04B3    pshs  u,y,x,b,a
         ldd   D.PROC
         pshs  b,a
         stx   D.PROC
         lda R$A,u
         ldx R$X,u
         ldy   ,s
         leay  P$DATImg,y
         os9   F$SLink
         bcc   L04D9
         ldd   ,s
         std   D.PROC
         ldu   $04,s
         os9   F$Load
         bcc   L04D9
         leas  $04,s
         puls  pc,u,y,x
L04D9    stu   $02,s
         pshs  y,a
         ldu   $0B,s
         stx R$X,u
         ldx   $07,s
         stx   D.PROC
         ldd   $05,s
         std   P$PModul,x
         puls  a
         cmpa  #$11
         beq   L04FD
         cmpa  #$C1
         beq   L04FD
         ldb   #$EA
L04F6    leas  $02,s
         stb   $03,s
         comb
         bra   L0540
L04FD    ldd   #$000B
         leay  P$DATImg,x
         ldx   P$PModul,x
         os9   F$LDDDXY
         cmpa  R$B,u
         bcc   L0510
         lda   R$B,u
         clrb

L0510    os9   F$Mem Mem to correct size
         bcs   L04F6
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
         sta   R$CC,y
         clra
         sta   R$DP,y
         clrb
         std   $08,y
         stx   R$PC,y
L0540    puls  b,a
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
         bsr   L05A7
         ldb R$B,u Get exit status
         stb P$Signal,X Save status
         leay  $01,x
         bra   EXIT30
EXIT20    clr P$SID,Y Clear sibling link
         lbsr  GETPRC
         clr   P$PID,y
         lda   P$State,y
         bita  #$01
         beq   EXIT30
         lda   ,y
         lbsr  L039D
EXIT30    lda   P$SID,y Get sibling id
         bne   EXIT20
         leay  ,x
         ldx   #$0047
         lds   D.SysStk
         pshs  cc
         orcc  #$50
         lda   P$PID,y
         bne   EXIT40
         puls  cc
         lda   ,y
         lbsr  L039D
         bra   EXIT50
EXIT35   cmpa P$ID,X Is this parent?
         beq   EXIT45
EXIT40    leau  ,x
         ldx   P$Queue,x
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
L05A7    pshs  u
 ldb #NumPaths Get number of paths
 leay P$PATH,X Get path table ptr
EXIT10    lda   ,y+ Get next path number
 beq EXIT15 Branch if not in use
         clr   -1,y
 pshs B Save path count
 OS9 I$Close Close the file
 puls B Retrieve path count
EXIT15    decb
         bne   EXIT10
         clra
         ldb   P$PagCnt,x
         beq   L05CC
         addb  #(DAT.BlSz/256)-1
         lsrb
         lsrb
         lsrb
         lsrb
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
         cmpd  $04,x
         bcc   L0603
         ldb   #E$DelSP
         bra   L0626
L0603    lda   P$PagCnt,x
         adda  #(DAT.BlSz/256)-1
         lsra
         lsra
         lsra
         lsra
         ldb   ,s
         addb  #(DAT.BlSz/256)-1
         bcc   L0615
         ldb   #E$MemFul
         bra   L0626
L0615    lsrb
         lsrb
         lsrb
         lsrb
         pshs  a
         subb  ,s+
         beq   L0633
         bcs   L062B
         os9   F$AllImg
         bcc   L0633
L0626    leas  $01,s
L0628    orcc  #$01
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
         tst   $02,u
         bne   SEND20
         ldd   $08,x
         beq   SEND20
         cmpd  $08,y
         beq   SEND20
         ldb   #$E0
         inc   ,s
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
         anda  #$F7
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
SEND68    ldd   P$Queue,x Remove from queue
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
SLEP10    puls  cc
 OS9 F$AProc Put process in active queue
         bra   ZZZPRC
SLEP20 ldd R$X,U Get length of sleep
         beq   L0766
 subd #1 count current tick
 std R$X,U update count
 beq SLEP10 branch if done
         pshs  y,x Save process & register ptr
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
L0769    leay  ,x
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
SETPRI   lda R$A,u
         lbsr  GETPRC Find process descriptor
         bcs   SETP20
 ldx D.PROC Get setting process ptr
 ldd P$USER,X Get setting user
         beq   SETP05  Superuser?
 cmpd P$USER,Y Same as set user?
 bne SETP10 Branch if not
SETP05 lda R$B,U Get priority
 sta P$Prior,Y Set priority
 clrb
 rts
SETP10 comb SET Carry
 ldb #E$IPrcID Err: illegal process id
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
         bra   L0825

SALLBIT  ldd R$D,u
         ldx R$X,u
         bsr   FNDBIT
         ldb   D.SysTsk
L0825    ldy R$Y,u
         beq   L0865
         sta   ,-s
         bmi   L0840
         os9   F$LDABX
L0831    ora   ,s
         leay  -$01,y
         beq   L0860
         lsr   ,s
         bcc   L0831
         os9   F$STABX
         leax  $01,x
L0840    lda   #$FF
         bra   L084B
L0844    os9   F$STABX
         leax  $01,x
         leay  -$08,y
L084B    cmpy  #$0008
         bhi   L0844
         beq   L0860
L0853    lsra
         leay  -$01,y
         bne   L0853
         coma
         sta   ,s
         os9   F$LDABX
         ora   ,s
L0860    os9   F$STABX
         leas  $01,s
L0865    clrb
         rts

FNDBIT pshs y,b
 lsra PAGE/2
 rorb
 lsra PAGE/4
 rorb
 lsra PAGE/8
 rorb
 leax D,X Get byte address
 puls B Get lsb
         leay  <L087C,pcr
 andb #7 Page modulo 8
         lda   b,y
         puls  pc,y

L087C    fcb  $80,$40,$20,$10,$08,$04,$02,$01

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
         ldy   D.PROC
         ldb   P$Task,y
         bra   L0899

SDELBIT ldd R$D,u
 ldx R$X,u
 bsr FNDBIT Adjust map ptr & get bit mask
         ldb   D.SysTsk
L0899    ldy R$Y,u
         beq   DEAL40
         coma
         sta   ,-s
         bpl   L08B5
         os9   F$LDABX
DEAL05 anda 0,S Clear bit
 leay -1,Y Decrement page count
 beq DEAL30 Branch if done
 asr 0,S Shift mask
 bcs DEAL05 Branch if more
         os9   F$STABX
         leax  1,x
L08B5    clra
         bra   DEAL20
DEAL15    os9   F$STABX
         leax  1,x
         leay  -$08,y
DEAL20 cmpy #8 Are there eight left?
 bhi DEAL15 Branch if so
 beq DEAL30 Branch if done
 coma
DEAL25 lsra
 leay -1,y Decrement page count
 bne   DEAL25
         sta   0,s
         os9   F$LDABX
         anda  0,s
DEAL30 os9 F$STABX
 leas 1,s
DEAL40 clrb
 rts

SCHBIT   ldd R$D,u Get beginning bit number
         ldx R$X,u Get bit map ptr
         bsr FNDBIT
         ldy D.PROC
         ldb P$Task,y
         bra FLOBLK

SSCHBIT  ldd R$D,u
         ldx R$X,u
         lbsr  FNDBIT
         ldb   D.SysTsk
FLOBLK    pshs  u,y,x,b,a,cc
         clra
         clrb
         std   3,s
         ldy   R$D,u
         sty   7,s
         bra   L090A
FLOB10 sty 7,s
FLOB15 lsr 1,S Shift mask
 bcc FLOB25 Branch if mask okay
 ror 1,S Shift mask around end
 leax 1,X Move map ptr
L090A    cmpx  R$U,u
 bcc FLOB30 Branch if so
         ldb   2,s
         os9   F$LDABX
         sta   0,s
FLOB25    leay  1,y
         lda   0,s
         anda  1,s
         bne   FLOB10
         tfr   y,d Copy page number
         subd  7,s
         cmpd  R$Y,u
         bcc   FLOB35 Branch if so
         cmpd  3,s
         bls   FLOB15
         std   3,s
         ldd   7,s
         std   5,s
         bra   FLOB15
FLOB30 ldd 3,s
 std   R$Y,u
 comb SET Carry
 ldd 5,s
 bra FLOB40
FLOB35 ldd 7,s
FLOB40 std R$D,u
 leas 9,s Return scratch
 rts

GPRDSC   ldx   D.PROC
         ldb   P$Task,x
         lda R$A,u
         os9   F$GProcP
         bcs   L095B
         lda   D.SysTsk
         leax  ,y
         ldy   #$0200
         ldu   R$X,u
         os9   F$Move
L095B    rts

GBLKMP   ldd   #DAT.BlSz
         std R$D,u
         ldd   D.BlkMap+2
         subd  D.BlkMap
         std   R$Y,u
         tfr   d,y
         lda   D.SysTsk
         ldx   D.PROC
         ldb   P$Task,x
         ldx   D.BlkMap
         ldu   R$X,u
         os9   F$Move
         rts

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
         ldb   P$Task,x
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
         beq   L0A04
         addd  8,u
         ldy   D.TmpDAT
         leay  <$20,y
         sty   D.TmpDAT
         leay  <-$20,y
         pshs  y,b,a
         ldy   D.PROC
         ldb   P$Task,y
         pshs  b
         ldx   R$D,u
         leay  P$DATImg,y
         ldb   #$10
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
         ldx R$X,u
         ldu   R$U,u
         ldy   $03,s
L09DD    cmpx  #DAT.BlSz
         bcs   L09EA
         leax  >-DAT.BlSz,x
         leay  $02,y
         bra   L09DD
L09EA    os9   F$LDAXY
         ldb   ,s
         pshs  x
         leax  ,u+
         os9   F$STABX
         puls  x
         leax  $01,x
         cmpu  $01,s
         bcs   L09DD
         puls  y,x,b
         sty   D.TmpDAT
L0A04    clrb
         rts

UNLOAD   pshs  u
         lda R$A,u
         ldx   D.PROC
         leay  P$DATImg,x
         ldx R$X,u
         os9   F$FModul
         puls  y
         bcs   L0A51
         stx   $04,y
         ldx   R$Y,u
         beq   L0A24
         leax  -$01,x
         stx   R$Y,u
         bne   L0A50
L0A24    cmpa  #$D0
         bcs   L0A4D
         clra
         ldx   [,u]
         ldy   D.SysDAT
L0A2E    adda  #$02
         cmpa  #$20
         bcc   L0A4D
         cmpx  a,y
         bne   L0A2E
         lsla
         lsla
         lsla
         clrb
         addd  R$X,u
         tfr   d,x
         os9   F$IODel
         bcc   L0A4D
         ldx   R$Y,u
         leax  $01,x
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
F64      lda R$A,u
         ldx R$X,u
         bsr   FINDPD
         bcs   F6410
         sty R$Y,u
F6410    rts

FINDPD    pshs  b,a
         tsta
         beq   L0A72
         clrb
         lsra
         rorb
         lsra
         rorb
         lda   a,x
         tfr   d,y
         beq   L0A72
         tst   ,y
         bne   L0A73
L0A72    coma
L0A73    puls  pc,b,a

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
         bne   L0A81
         bsr   L0A8B
         bcs   L0A8A
         stx   ,x
         stx R$X,u
L0A81    bsr   L0AA1
         bcs   L0A8A
         sta R$A,u
         sty R$Y,u
L0A8A    rts
L0A8B    pshs  u
         ldd   #$0100
         os9   F$SRqMem
         leax  ,u
         puls  u
         bcs   L0AA0
         clra
         clrb
L0A9B    sta   d,x
         incb
         bne   L0A9B
L0AA0    rts
L0AA1    pshs  u,x
         clra
L0AA4    pshs  a
         clrb
         lda   a,x
         beq   L0AB6
         tfr   d,y
         clra
L0AAE    tst   d,y
         beq   L0AB8
         addb  #$40
         bcc   L0AAE
L0AB6    orcc  #$01
L0AB8    leay  d,y
         puls  a
         bcc   L0AE3
         inca
         cmpa  #$40
         bcs   L0AA4
         clra
L0AC4    tst   a,x
         beq   L0AD2
         inca
         cmpa  #$40
         bcs   L0AC4
         comb
         ldb   #$C8
         bra   L0AF0
L0AD2    pshs  x,a
         bsr   L0A8B
         bcs   L0AF2
         leay  ,x
         tfr   x,d
         tfr   a,b
         puls  x,a
         stb   a,x
         clrb
L0AE3    lslb
         rola
         lslb
         rola
         ldb   #$3F
L0AE9    clr   b,y
         decb
         bne   L0AE9
         sta   ,y
L0AF0    puls  pc,u,x
L0AF2    leas  $03,s
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
         beq   L0B24
         lsra
         rorb
         lsra
         rorb
         pshs  a
         lda   a,x
         beq   L0B22
         tfr   d,y
         clr   ,y
         clrb
         tfr   d,u
         clra
L0B12    tst   d,u
         bne   L0B22
         addb  #$40
         bne   L0B12
         inca
         os9   F$SRtMem
         lda   ,s
         clr   a,x
L0B22    clr   ,s+
L0B24    puls  pc,u,y,x,b,a

GPROCP   lda R$A,u
         bsr   GETPRC
         bcs   L0B2F
         sty R$Y,u
L0B2F    rts

* Find process descriptor
GETPRC    pshs  x,b,a
         ldb   ,s
         beq   L0B42
         ldx   D.PrcDBT
         abx
         lda   P$ID,x
         beq   L0B42
         clrb
         tfr   d,y
         puls  pc,x,b,a
L0B42    puls  x,b,a
         comb
         ldb   #E$BPrcId
         rts

DELIMG   ldx R$X,u
         ldd R$D,u
         leau  P$DATImg,x
         lsla
         leau  a,u
         clra
         tfr   d,y
         pshs  x
L0B57    ldd   ,u
         addd  D.BlkMap
         tfr   d,x
         lda   ,x
         anda  #$FE
         sta   ,x
         ldd   #DAT.Free
         std   ,u++
         leay  -$01,y
         bne   L0B57
         puls  x
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         clrb
         rts

MAPBLK   lda   R$B,u
         cmpa  #$10
         bcc   L0BD5
         leas  <-$20,s
         ldx R$X,u
         leay  ,s
L0B83    stx   ,y++
         leax  $01,x
         deca
         bne   L0B83
         ldb R$B,u
         ldx   D.PROC
         leay  P$DATImg,x
         os9   F$FreeHB
         bcs   L0BD1
         pshs  b,a
         lsla
         lsla
         lsla
         lsla
         clrb
         std   R$U,u
         ldd   ,s
         pshs  u
         leau  $04,s
         os9   F$SetImg
         puls  u
         cmpx  D.SysPrc
         bne   L0BCE
         tfr   x,y
         ldx   D.SysMem
         ldb   R$U,u
         abx
         leay  P$DATImg,y
         lda   ,s
         lsla
         leay  a,y
         ldu   D.BlkMap
L0BBF    ldd   ,y++
         lda   d,u
         ldb   #$10
L0BC5    sta   ,x+
         decb
         bne   L0BC5
         dec   $01,s
         bne   L0BBF
L0BCE    leas  $02,s
         clrb
L0BD1    leas  <$20,s
         rts

L0BD5    comb
         ldb   #$DB
         rts

CLRBLK   ldb R$B,u Get number of blocks
         beq   CLRBLK50
         ldd   R$U,u Get address of first block
         tstb
         bne   L0BD5
         bita  #(DAT.BlSz/256)-1
         bne   L0BD5
         ldx   D.PROC
         cmpx  D.SysPrc
         beq   L0BFC
         lda   $04,x
         anda  #$F0
         suba  R$U,u
         bcs   L0BFC
         lsra
         lsra
         lsra
         lsra
         cmpa  R$B,u
         bcs   L0BD5
L0BFC    lda   R$U,u
         lsra
         lsra
         lsra
         leay  P$DATImg,x
         leay  a,y
         ldb R$B,u
         ldx   #DAT.Free
L0C0B    stx   ,y++
         decb
         bne   L0C0B
         ldx   D.PROC
         lda   P$State,x
         ora   #$10
         sta   P$State,x
         cmpx  D.SysPrc
         bne   CLRBLK50
         ldx   D.SysMem
         ldb R$U,u
         abx
         ldb R$B,u
CLRBLK30 lda #$10
CLRBLK40 clr ,x+
         deca
         bne   CLRBLK40
         decb
         bne   CLRBLK30
CLRBLK50    clrb
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

GCMDIR   ldx   D.ModDir
         bra   L0C61
L0C5B    ldu   ,x
         beq   L0C67
         leax  $08,x
L0C61    cmpx  D.ModEnd
         bne   L0C5B
         bra   L0C8F
L0C67    tfr   x,y
         bra   L0C6F
L0C6B    ldu   ,y
         bne   L0C78
L0C6F    leay  $08,y
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
