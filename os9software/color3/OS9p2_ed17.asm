         nam   OS-9 Level II V1.2, part 2
         ttl   os9 Module Header

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

 fcb  17 edition number

 use  defsfile

 org 0
u0000    rmb   1
u0001    rmb   1
u0002    rmb   1
u0003    rmb   1
u0004    rmb   2
u0006    rmb   1
u0007    rmb   1
u0008    rmb   1
u0009    rmb   1
u000A    rmb   1
u000B    rmb   1
u000C    rmb   1
u000D    rmb   1
u000E    rmb   1
u000F    rmb   1

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
 ifge DAT.BlSz-$2000
 lsra
 rorb
 endc
 addd  D.BlkMap
 tfr   d,x
 ldb   #$80
 bra   COLD20

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
 bra P3FAIL     Fix in editions 14-17?

SETSTD05    ldx   D.PROC
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

P3FAIL jmp D.Crash

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
UNLINK   pshs  u,b,a
 ldd R$U,U Get module address
 ldx R$U,u Get module address
         lsra
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra
 endc
         sta   ,s
         beq   L0183
         ldu   D.PROC
         leay  P$DATImg,u
         lsla
         ldd   a,y
         ldu   D.BlkMap
         ldb   d,u
         bitb  #$02
         beq   L0183
         leau  P$DATImg,y
         bra   L0161
L015D    dec   ,s
         beq   L0183
L0161    ldb   ,s
         lslb
         ldd   b,u
         beq   L015D
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
         bra   L0185
L017C    leau  u0008,u
         cmpu  D.ModEnd
         bcs   L0185
L0183    bra   L01D0
L0185    cmpx  u0004,u
         bne   L017C
         cmpd  [,u]
         bne   L017C
         ldx   u0006,u
         beq   L0198
         leax  -1,x
         stx   u0006,u
         bne   L01B5
L0198    ldx   $02,s
         ldx   $08,x
         ldd   #$0006
         os9   F$LDDDXY
         cmpa  #$D0
         bcs   UNLK20
         os9   F$IODel
         bcc   UNLK20
         ldx   u0006,u
         leax  1,x
         stx   u0006,u
         bra   L01D1
UNLK20    bsr   L01D5
L01B5    ldb   ,s
         lslb
         leay  b,y
         ldx   P$DATImg,y
         leax  -1,x
         stx   P$DATImg,y
         bne   L01D0
         ldd   u0002,u
         bsr   DIVBKSZ
         ldx   #DAT.Free
L01CB    stx   ,y++
         deca
         bne   L01CB
L01D0    clrb
L01D1    leas  $02,s
         puls  pc,u

L01D5    ldx   D.BlkMap
         ldd   [,u]
         lda   d,x
         bmi   L0225
         ldx   D.ModDir
L01DF    ldd   [,x]
         cmpd  [,u]
         bne   L01EA
         ldd   $06,x
         bne   L0225
L01EA    leax  $08,x
         cmpx  D.ModEnd
         bcs   L01DF
         ldx   D.BlkMap
         ldd   u0002,u
         bsr   DIVBKSZ
         pshs  y
         ldy   ,u
L01FB    pshs  x,a
         ldd   ,y
         clr   ,y+
         clr   ,y+
         leax  d,x
         ldb   ,x
         andb  #$FC
         stb   ,x
         puls  x,a
         deca
         bne   L01FB
         puls  y
         ldx   D.ModDir
         ldd   ,u
L0216    cmpd  ,x
         bne   L021F
         clr   ,x
         clr   1,x
L021F    leax  $08,x
         cmpx  D.ModEnd
         bcs   L0216
L0225    rts

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
         lbsr  L02EA
         bcc   L0238
         puls  pc,u
L0238    pshs  u
         ldx   D.PROC
         ldd   P$User,x
         std   P$User,u
         lda   P$Prior,x
         sta   P$Prior,u
 ifeq CPUType-COLOR3 * COCO specific start
         pshs  u,x
         leax  P$NIO,x
         leau  P$NIO,u
         ldb   #NefIOSiz
L0250    lda   ,x+
         sta   ,u+
         decb
         bne   L0250
         puls  u,x
 endc * COCO specific end
         leax  P$DIO,x
         leau  P$DIO,u
         ldb   #DefIOSiz
L0261    lda   ,x+
         sta   ,u+
         decb
         bne   L0261
         ldy   #3     dup the first three open paths
L026C    lda   ,x+
         beq   L0276
         os9   I$Dup
         bcc   L0276
         clra
L0276    sta   ,u+
         leay  -1,y
         bne   L026C
         ldx   ,s
         ldu   $02,s
         lbsr  L04B1
         bcs   L02CF
         pshs  b,a
         os9   F$AllTsk
         bcs   L02CF
         lda   $07,x
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
         std   1,x
         lda   $0C,x
         anda  #$7F
         sta   $0C,x
         os9   F$AProc
         rts
L02CF    puls  x
         pshs  b
         lbsr  CLOSEPD
         lda   ,x
         lbsr  L0386
         comb
         puls  pc,u,b

ALLPRC   pshs  u
         bsr   L02EA
         bcs   L02E8
         ldx   ,s
         stu   $08,x
L02E8    puls  pc,u

L02EA    ldx   D.PrcDBT
L02EC    lda   ,x+
         bne   L02EC
         leax  -1,x
         tfr   x,d
         subd  D.PrcDBT
         tsta
         beq   L02FE
         comb
         ldb   #E$PrcFul
         bra   L032F
L02FE    pshs  b
         ldd   #$0200
         os9   F$SRqMem
         puls  a
         bcs   L032F
         sta   ,u
         tfr   u,d
         sta   ,x
         clra
         leax  1,u
         ldy   #$0080
L0317    std   ,x++
         leay  -1,y
         bne   L0317
         lda   #SysState
         sta   P$State,u
         ldb   #$08     counter
         ldx   #DAT.Free
         leay  P$DATImg,u
L0329    stx   ,y++
         decb
         bne   L0329
         clrb
L032F    rts

DELPRC   lda R$A,u
         bra   L0386
 page
*****
*
*  Subroutine Wait
*
* Wait for Child Process to Exit
*
WAIT     ldx   D.PROC
         lda   P$CID,x
         beq   WAIT20
WAIT10    lbsr  GETPRC
 lda P$State,Y Get child's status
 bita #DEAD Is child dead?
 bne CHILDS Branch if so
 lda P$SID,Y More children?
 bne WAIT10 Branch if so
 sta R$A,u clear child process id
         sta   R$B,u
         pshs  cc
         orcc #IRQMask+FIRQMask Set interrupt masks
         lda   P$Signal,x
         beq   L035D
         deca
         bne   L035A
         sta   P$Signal,x
L035A    lbra  SLEP10
L035D    ldd   D.WProcQ
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
CHILDS    lda   P$ID,y
         ldb   P$Signal,y
         std R$D,u
         leau  0,y  Copy of process pointer
 leay P$CID-P$SID,X Fake sibling process ptr
         bra   CHIL20
CHIL10    lbsr  GETPRC
CHIL20 lda P$SID,Y Is child next sibling?
 cmpa P$ID,u
 bne CHIL10 Branch if not
 ldb P$SID,U Get child's sibling
 stb P$SID,Y Remove child from sibling list
L0386    pshs  u,x,b,a

 ifeq CPUType-COLOR3 * COCO specific start
         cmpa  >$1015
         bne   L0393
         clr   >$1015
         clr   >$1016
L0393 equ *
 endc
         ldb   ,s
         ldx   D.PrcDBT
         abx
         lda   ,x
         beq   L03AC
         clrb
         stb   ,x
         tfr   d,x
         os9   F$DelTsk
         leau  ,x
         ldd   #$0200
         os9   F$SRtMem
L03AC    puls  pc,u,x,b,a



*****
*
* Subroutine Chain
*
* Execute Overlay
*
CHAIN pshs U Save register ptr
         lbsr  L02EA
         bcc   L03B7
         puls  pc,u

L03B7    ldx   D.PROC
         pshs  u,x
         leax  P$SP,x
         leau  P$SP,u
         ldy   #$007E
L03C3    ldd   ,x++
         std   ,u++
         leay  -1,y
         bne   L03C3

 ifeq CPUType-COLOR3 * COCO specific start
         ldu   $02,s
         leau  $40,u
         ldx   ,s
         lda   $06,x
         lsla
         ldx   D.TskIPt
         stu   a,x
 endc

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
         addb  #(DAT.BlSz/256)-1
         lsrb
         lsrb
         lsrb
         lsrb
 ifge DAT.BlSz-$2000
         lsrb
 endc
         lda   #$08   counter
         pshs  b
         suba  ,s+
         leay  P$DatImg,x
         lslb
         leay  b,y
         ldu   #DAT.Free
L040C    stu   ,y++
         deca
         bne   L040C
         ldu   $02,s
         stu   D.PROC
         ldu   $04,s
         lbsr  L04B1
         lbcs  L04A1
         pshs  b,a
         os9   F$AllTsk
         bcc   L0425
L0425    ldu   D.PROC
         lda   u0006,u
         ldb   $06,x
         leau  (P$Stack-R$Size),x
         leax  ,y
         ldu   P$SP,u
         pshs  u
         cmpx  ,s++
         puls  y
         bhi   L0471
         beq   L0474
         leay  ,y
         beq   L0474
         pshs  x,b,a
         tfr   y,d
         leax  d,x
         pshs  u
         cmpx  ,s++
         puls  x,b,a
         bls   L0471
         pshs  u,y,x,b,a
         tfr   y,d
         leax  d,x
         leau  d,u
L0457    ldb   ,s
         leax  -1,x
         os9   F$LDABX
         exg   x,u
         ldb   1,s
         leax  -1,x
         os9   F$STABX
         exg   x,u
         leay  -1,y
         bne   L0457
         puls  u,y,x,b,a
         bra   L0474
L0471    os9   F$Move
L0474    lda   D.SysTsk
         ldx   ,s
         ldu   $04,x
         leax  (P$Stack-R$Size),x
         ldy   #$000C
         os9   F$Move
         puls  u,x
         lda   ,u
         lbsr  L0386
         os9   F$DelTsk
         orcc  #$50
         ldd   D.SysPrc
         std   D.PROC
         lda   $0C,x
         anda  #$7F
         sta   $0C,x
         os9   F$AProc
         os9   F$NProc
L04A1    puls  u,x
         stx   D.PROC
         pshs  b
         lda   ,u
         lbsr  L0386
         puls  b
         os9   F$Exit
L04B1    pshs  u,y,x,b,a
         ldd   D.PROC
         pshs  b,a
         stx   D.PROC
         lda R$A,u
         ldx R$X,u
         ldy   ,s
         leay  P$DATImg,y
         os9   F$SLink
         bcc   L04D7
         ldd   ,s
         std   D.PROC
         ldu   $04,s
         os9   F$Load
         bcc   L04D7
         leas  $04,s
         puls  pc,u,y,x
L04D7    stu   $02,s
         pshs  y,a
         ldu   $0B,s
         stx R$X,u
         ldx   $07,s
         stx   D.PROC
         ldd   $05,s
         std   P$PModul,x
         puls  a
         cmpa  #$11
         beq   L04FB
         cmpa  #$C1
         beq   L04FB
         ldb   #$EA
L04F4    leas  $02,s
         stb   $03,s
         comb
         bra   L053E
L04FB    ldd   #$000B
         leay  P$DATImg,x
         ldx   P$PModul,x
         os9   F$LDDDXY
         cmpa  R$B,u
         bcc   L050E
         lda   R$B,u
         clrb
L050E    os9   F$Mem
         bcs   L04F4
         ldx   $06,s
         leay  (P$Stack-R$Size),x
         pshs  b,a
         subd  R$Y,u
         std   $04,y
         subd  #$000C
         std   P$SP,x
         ldd   u0006,u
         std   1,y
         std   $06,s
         puls  x,b,a
         std   $06,y
         ldd   u0008,u
         std   $06,s
         lda   #$80
         sta   R$CC,y
         clra
         sta   $03,y
         clrb
         std   $08,y
         stx   R$PC,y
L053E    puls  b,a
         std   D.PROC
         puls  pc,u,y,x,b,a
 page
*****
*
*  Subroutine Exit
*
* Process Termination
*
EXIT ldx D.PROC Get process ptr
         bsr   CLOSEPD
         ldb R$B,u
         stb P$Signal,X Save status
         leay  1,x
         bra   EXIT30
EXIT20    clr P$SID,Y Clear sibling link
         lbsr  GETPRC
         clr   P$PID,y
         lda   P$State,y Get process status
 bita #DEAD Is process dead?
         beq   EXIT30
         lda   ,y
         lbsr  L0386
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
         lbsr  L0386
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
EXIT45    ldd   $0D,x
         std   u000D,u
         puls  cc
         ldu   $04,x
         ldu   u0008,u
         lbsr  CHILDS
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
         beq   L05CB
         addb  #(DAT.BlSz/256)-1
         lsrb
         lsrb
         lsrb
         lsrb
 ifge DAT.BlSz-$2000
         lsrb
 endc
         os9   F$DelImg
L05CB    ldd   D.PROC
         pshs  b,a
         stx   D.PROC
         ldu   P$PModul,x
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
         ldd R$D,u
         beq   USRM35
         addd  #$00FF
         bcc   L05EE
         ldb   #$CF
         bra   L0629
L05EE    cmpa  $07,x
         beq   USRM35
         pshs  a
         bcc   L0602
         deca
         ldb   #$F4
         cmpd  $04,x
         bcc   L0602
         ldb   #$DF
         bra   L0627
L0602    lda   $07,x
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
         ldb   #$CF
         bra   L0627
L0615    lsrb
         lsrb
         lsrb
         lsrb
 ifge DAT.BlSz-$2000
         lsrb
 endc
         pshs  a
         subb  ,s+
         beq   L0634
         bcs   L062C
         os9   F$AllImg
         bcc   L0634
L0627    leas  1,s
L0629    orcc  #$01
         rts
L062C    pshs  b
         adda  ,s+
         negb
         os9   F$DelImg
L0634    puls  a
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
SENSUB    lbsr  GETPRC
         pshs  u,y,a,cc
         bcs   SEND17
         tst   u0002,u
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
         ldb R$B,u
         bne   SEND30
         ldb   #$E4
         lda   $0C,y
         ora   #$02
         sta   $0C,y
SEND30    lda   P$State,y
         anda  #^Suspend
         sta   P$State,y
 lda P$Signal,Y Is signal pending?
 beq SEND40 Branch if not
 deca Is it wake-up?
 beq SEND40 Branch if so
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
L0697    leay  ,x
         ldx   P$Queue,x
         beq   SEND66
         ldu   $04,x
         addd  $04,u
         cmpx  $02,s
         bne   L0697
         pshs  b,a
 lda P$State,x get process state
 bita #TimSleep is it in timed sleep?
         beq   SEND65
         ldd   ,s
         beq   SEND65
         ldd   $04,u
         pshs  b,a
         ldd   $02,s
         std   u0004,u
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
SEND68 ldd P$Queue,x Remove from queue
 std P$Queue,Y
 lda P$Signal,X Get signal
 deca Is it wake-up?
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
         deca
         bne   SLEP05
 sta P$Signal,X Clear signal
SLEP05    lda   P$State,x
         anda  #$F7
         sta   P$State,x
SLEP10    puls  cc
         os9   F$AProc
         bra   ZZZPRC
SLEP20 ldd R$X,U Get length of sleep
         beq   L076D
 subd #1 count current tick
 std R$X,U update count
 beq SLEP10 branch if done
 pshs y,x Save process & register ptr
 ldx #D.SProcQ-P$Queue Fake process ptr
L0732    std   u0004,u
         stx   $02,s
         ldx   $0D,x
         beq   L074F
         lda   $0C,x
         bita  #$40
         beq   L074F
         ldy   $04,x
         ldd   u0004,u
         subd  $04,y
         bcc   L0732
         nega
         negb
         sbca  #$00
         std   $04,y
L074F    puls  y,x
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
L076D    ldx #D.SProcQ-P$Queue Fake process ptr
L0770    leay  ,x
         ldx   $0D,x
         bne   L0770
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
         sts   P$SP,x
         os9   F$NProc

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
SETPRI lda R$A,u
         lbsr  GETPRC
         bcs   SETP20
         ldx   D.PROC
         ldd   P$User,x
         beq   SETP05
         cmpd  P$User,y
         bne   SETP10
SETP05    lda   R$B,u
         sta   P$Prior,y
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
SETSWI  ldx   D.PROC
         leay  <$13,x
         ldb   u0001,u
         decb
         cmpb  #$03
         bcc   SSWI10
         lslb
         ldx R$X,u
         stx   b,y
         rts
SSWI10    comb
         ldb   #$E3
         rts



**********
*
* Subroutine Settime
*

ClockNam fcs "Clock"

SetTime  ldx R$X,u
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
         leay  -1,y
         beq   ALOC35
         lsr   ,s
         bcc   ALOC10
         os9   F$STABX
         leax  1,x
ALOC15    lda   #$FF
         bra   ALOC25
ALOC20    os9   F$STABX
         leax  1,x
         leay  -$08,y
ALOC25    cmpy  #$0008
         bhi   ALOC20
         beq   ALOC35
ALOC30    lsra
         leay  -1,y
         bne   ALOC30
         coma
         sta   ,s
         os9   F$LDABX
         ora   ,s
ALOC35    os9   F$STABX
         leas  1,s
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
         bra   L08A0

SDELBIT  ldd R$D,u
         ldx R$X,u
         bsr   FNDBIT
         ldb   D.SysTsk
L08A0    ldy R$Y,u
         beq   DEAL40
         coma
         sta   ,-s
         bpl   DEAL10
         os9   F$LDABX
DEAL05    anda  ,s
         leay  -1,y
         beq   DEAL30
         asr   ,s
         bcs   DEAL05
         os9   F$STABX
         leax  1,x
DEAL10    clra
         bra   DEAL20
DEAL15    os9   F$STABX
         leax  1,x
         leay  -$08,y
DEAL20    cmpy  #$0008
         bhi   DEAL15
         beq   DEAL30
         coma
DEAL25    lsra
         leay  -1,y
         bne   DEAL25
         sta   ,s
         os9   F$LDABX
         anda  ,s
DEAL30    os9   F$STABX
         leas  1,s
DEAL40    clrb
         rts

SCHBIT   ldd R$D,u
         ldx R$X,u
         bsr   FNDBIT
         ldy   D.PROC
         ldb   $06,y
         bra   FLOBLK

SSCHBIT     ldd R$D,u
         ldx R$X,u
         lbsr  FNDBIT
         ldb   D.SysTsk

FLOBLK    pshs  u,y,x,b,a,cc
         clra
         clrb
         std   $03,s
         ldy R$D,u
         sty   $07,s
         bra   FLOB20
FLOB10    sty   $07,s
FLOB15    lsr   1,s
         bcc   FLOB25
         ror   1,s
         leax  1,x
FLOB20    cmpx  u0008,u
         bcc   FLOB30
         ldb   $02,s
         os9   F$LDABX
         sta   ,s
FLOB25    leay  1,y
         lda   ,s
         anda  1,s
         bne   FLOB10
         tfr   y,d
         subd  $07,s
         cmpd  u0006,u
         bcc   FLOB35
         cmpd  $03,s
         bls   FLOB15
         std   $03,s
         ldd   $07,s
         std   $05,s
         bra   FLOB15
FLOB30    ldd   $03,s
         std   u0006,u
         comb
         ldd   $05,s
         bra   FLOB40
FLOB35    ldd   $07,s
FLOB40    std   u0001,u
         leas  $09,s
         rts

*
* Get process descriptor copy
*
GPRDSC   ldx   D.PROC
         ldb   $06,x
         lda R$A,u
         os9   F$GProcP
         bcs   GPRDSC10
         lda   D.SysTsk
         leax  ,y
         ldy   #$0200
         ldu   u0004,u
         os9   F$Move
GPRDSC10    rts

GBLKMP   ldd   #DAT.BlSz
         std   u0001,u
         ldd   D.BlkMap+2
         subd  D.BlkMap
         std   u0006,u
         tfr   d,y
         lda   D.SysTsk
         ldx   D.PROC
         ldb   $06,x
         ldx   D.BlkMap
         ldu   u0004,u
         os9   F$Move
         rts

GMODDR   ldd   D.ModDir+2
         subd  D.ModDir
         tfr   d,y
         ldd   D.ModEnd
         subd  D.ModDir
         ldx R$X,u
         leax  d,x
         stx   u0006,u
         ldx   D.ModDir
         stx   u0008,u
         lda   D.SysTsk
         ldx   D.PROC
         ldb   $06,x
         ldx   D.ModDir
         ldu   u0004,u
         os9   F$Move
         rts

SETUSER ldx D.PROC
 ldd R$Y,u   Desired user id number
 std P$User,x
 clrb
 rts

CPYMEM   ldd   R$Y,u byte count
         beq   L0A01
         addd  R$U,u  destination buffer
         bcs   L0A01
         leas  -DAT.ImSz,s
         leay  ,s
         pshs  y,d
         ldx   D.PROC
         ldb   P$Task,x
         pshs  b
         leay  P$DATImg,x
         ldx   R$D,u  pointer to DAT image
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
         puls  b
         bra   L09E7
L09E1    leax  -DAT.BlSz,x
         leay  $02,y
L09E7    cmpx  #DAT.BlSz
         bcc   L09E1
         os9   F$LDAXY
         leax  1,x
         exg   x,u
         os9   F$STABX
         leax  1,x
         cmpx  ,s
         exg   x,u
         bcs   L09E7
         leas  <$14,s
L0A01    clrb
         rts

UNLOAD   pshs  u
         lda R$A,u
         ldx   D.PROC
         leay  P$DATImg,x
         ldx R$X,u
         os9   F$FModul
         puls  y
         bcs   L0A4F
         stx   $04,y
         ldx   R$Y,u
         beq   L0A21
         leax  -1,x
         stx   u0006,u
         bne   L0A4E
L0A21    cmpa  #$D0
         bcs   L0A4B
         clra
         ldx   [,u]
         ldy   D.SysDAT
L0A2B    adda  #$02
         cmpa  #DAT.ImSz
         bcc   L0A4B
         cmpx  a,y
         bne   L0A2B
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
         bcc   L0A4B
         ldx   R$Y,u
         leax  1,x
         stx   R$Y,u
         bra   L0A4F
L0A4B    lbsr  L01D5
L0A4E    clrb
L0A4F    rts
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
         sta R$A,u
         sty R$Y,u
A6420    rts

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
         beq   L0AB6
         addb  #$40
         bcc   ALPD11
ALPD12    orcc  #$01
L0AB6    leay  d,y
         puls  a
         bcc   L0AE1
         inca
         cmpa  #$40
         bcs   ALCPD1
         clra
L0AC2    tst   a,x
         beq   L0AD0
         inca
         cmpa  #$40
         bcs   L0AC2
         comb
         ldb   #$C8
         bra   L0AEE
L0AD0    pshs  x,a
         bsr   A64ADD
         bcs   ALCPDR
         leay  ,x
         tfr   x,d
         tfr   a,b
         puls  x,a
         stb   a,x
         clrb
L0AE1    lslb
         rola
         lslb
         rola
         ldb   #$3F
L0AE7    clr   b,y
         decb
         bne   L0AE7
         sta   ,y
L0AEE    puls  pc,u,x

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
R64 lda R$A,U Get block number
 ldx R$X,U Get block ptr
 pshs D,X,Y,U Save registers
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
         bcs   L0B2D
         sty R$Y,u
L0B2D    rts

GETPRC    pshs  x,b,a
         ldb   ,s
         beq   L0B40
         ldx   D.PrcDBT
         abx
         lda   ,x
         beq   L0B40
         clrb
         tfr   d,y
         puls  pc,x,b,a
L0B40    puls  x,b,a
         comb
         ldb   #$E0
         rts

DELIMG   ldx R$X,u
         ldd R$D,u
         leau  P$DATImg,x
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
         beq   IBAERR
         cmpa  #DAT.BlCt
         bhi   IBAERR
         leas  -DAT.ImSz,s
         ldx R$X,u
         leay  ,s
L0B82    stx   ,y++
         leax  1,x
         deca
         bne   L0B82
         ldb R$B,u
         ldx   D.PROC
         leay  P$DATImg,x
         os9   F$FreeHB
         bcs   L0BA6
         pshs  b,a
         lsla
         lsla
         lsla
         lsla
 ifge DAT.BlSz-$2000
         lsla
 endc
         clrb
         std   u0008,u
         puls  b,a
         leau  ,s
         os9   F$SetImg
L0BA6    leas  <$10,s
         rts

IBAERR    comb
         ldb   #$DB
         rts

CLRBLK   ldb R$B,u
         beq   CLRBLK50
         ldd   u0008,u
         tstb
         bne   IBAERR
         bita  #(DAT.BlSz/256)-1
         bne   IBAERR
         ldx   D.PROC
         lda   $04,x
         anda  #$E0
         suba  u0008,u
         bcs   CLRBLK10
         lsra
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra
 endc
         cmpa  u0002,u
         bcs   IBAERR
CLRBLK10    lda   P$State,x   fix in later editions?
         ora   #$10
         sta   P$State,x
         lda   R$U,u
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra
 endc
         leay  P$DATImg,x
         leay  a,y
         ldb R$B,u
         ldx   #DAT.Free
CLRBLK20    stx   ,y++
         decb
         bne   CLRBLK20
CLRBLK50    clrb
         rts

DELRAM   ldb R$B,u
         beq   L0C11
         ldd   D.BlkMap+2
         subd  D.BlkMap
         subd  u0004,u
         bls   L0C11
         tsta
         bne   L0C00
         cmpb  u0002,u
         bcc   L0C00
         stb R$B,u
L0C00    ldx   D.BlkMap
         ldd   u0004,u
         leax  d,x
         ldb R$B,u
L0C08    lda   ,x
         anda  #$FE
         sta   ,x+
         decb
         bne   L0C08
L0C11    clrb
         rts

GCMDIR   ldx   D.ModDir
         bra   L0C1D
L0C17    ldu   ,x
         beq   L0C23
         leax  $08,x
L0C1D    cmpx  D.ModEnd
         bne   L0C17
         bra   L0C4B
L0C23    tfr   x,y
         bra   L0C2B
L0C27    ldu   ,y
         bne   L0C34
L0C2B    leay  $08,y
         cmpy  D.ModEnd
         bne   L0C27
         bra   L0C49
L0C34    ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         ldu   ,y++
         stu   ,x++
         cmpy  D.ModEnd
         bne   L0C27
L0C49    stx   D.ModEnd
L0C4B    ldx   D.ModDir+2
         bra   L0C53
L0C4F    ldu   ,x
         beq   L0C5B
L0C53    leax  -$02,x
         cmpx  D.ModDat
         bne   L0C4F
         bra   L0C93
L0C5B    ldu   -$02,x
         bne   L0C53
         tfr   x,y
         bra   L0C67
L0C63    ldu   ,y
         bne   L0C70
L0C67    leay  -$02,y
L0C69    cmpy  D.ModDat
         bcc   L0C63
         bra   L0C81
L0C70    leay  $02,y
         ldu   ,y
         stu   ,x
L0C76    ldu   ,--y
         stu   ,--x
         beq   L0C87
         cmpy  D.ModDat
         bne   L0C76
L0C81    stx   D.ModDat
         bsr   L0C95
         bra   L0C93
L0C87    leay  $02,y
         leax  $02,x
         bsr   L0C95
         leay  -$04,y
         leax  -$02,x
         bra   L0C69
L0C93    clrb
         rts
L0C95    pshs  u
         ldu   D.ModDir
         bra   L0CA4
L0C9B    cmpy  ,u
         bne   L0CA2
         stx   ,u
L0CA2    leau  8,u
L0CA4    cmpu  D.ModEnd
         bne   L0C9B
         puls  pc,u
         emod
OS9End   equ   *
