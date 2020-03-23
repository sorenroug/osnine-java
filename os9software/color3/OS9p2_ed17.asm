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
u0010    rmb   2
u0012    rmb   4
u0016    rmb   5
u001B    rmb   5
u0020    rmb   4
u0024    rmb   28
u0040    rmb   2
u0042    rmb   2
u0044    rmb   2
u0046    rmb   2
u0048    rmb   2
u004A    rmb   2
u004C    rmb   4
u0050    rmb   4
u0054    rmb   4
u0058    rmb   2
u005A    rmb   23
u0071    rmb   3
u0074    rmb   11
u007F    rmb   8
u0087    rmb   18
u0099    rmb   7
u00A0    rmb   1
u00A1    rmb   10
u00AB    rmb   13
u00B8    rmb   14
u00C6    rmb   6
u00CC    rmb   4
u00D0    rmb   21
u00E5    rmb   25
u00FE    rmb   2
size     equ   .

 ttl Coldstart Routines
 page
*****
*
* Cold Start Routines
*
*
* Initialize Service Routine Dispatch Table
*
Cold leay SVCTBL,PCR Get ptr to service routine table
         os9   F$SSvc
         ldu   D.Init
         ldd   u0009,u
         lsra
         rorb
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
         bra   L0036
L0030    lda   ,x+
         bne   L0036
         stb   -1,x
L0036    cmpx  D.BlkMap+2
         bcs   L0030
L003A    ldu   D.Init
         ldd   SysStr,u
         beq   L004F
         leax  d,u
         lda   #$05
         os9   I$ChgDir
         bcc   L004F
         os9   F$Boot
         bcc   L003A
L004F    ldu   D.Init
         ldd   StdStr,u Standard terminal
         beq   L0077
         leax  d,u
         lda   #$03
         os9   I$Open
         bcc   L0066
         os9   F$Boot
         bcc   L004F
         bra   L009B

L0066    ldx   D.PROC
 sta P$PATH,X set standard input
 OS9 I$DUP count open image
 sta P$PATH+1,X set standard output
 OS9 I$DUP count open image
 sta P$PATH+2,X set standard error
L0077    leax  <L0096,pcr
         lda   #$C0
         os9   F$Link
         bcs   L0083
         jsr   ,y
L0083    ldu   D.Init
         ldd   InitStr,u
         leax  d,u
         lda   #$01
         clrb
         ldy   #$0000
         os9   F$Fork
         os9   F$NProc

L0096    fcs "OS9p3"

L009B    jmp   D.Crash

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
         fcb   $80

IOSTR    fcs "IOMan"

IOHOOK pshs D,X,Y,U Save registers
         bsr IOLink
         bcc   IOHOOK10
         os9   F$Boot
         bcs   L012B
         bsr   IOLink
         bcs   L012B
IOHOOK10    jsr   ,y
         puls  u,y,x,b,a
         ldx   >$00FE,y
         jmp   ,x
L012B    stb   $01,s
         puls  pc,u,y,x,b,a

IOLink    leax  >IOSTR,pcr
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
         ldd   u0008,u
         ldx   u0008,u
         lsra
         lsra
         lsra
         lsra
         lsra
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
         lsla
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
         leax  -$01,x
         stx   u0006,u
         bne   L01B5
L0198    ldx   $02,s
         ldx   $08,x
         ldd   #$0006
         os9   F$LDDDXY
         cmpa  #$D0
         bcs   L01B3
         os9   F$IODel
         bcc   L01B3
         ldx   u0006,u
         leax  $01,x
         stx   u0006,u
         bra   L01D1
L01B3    bsr   L01D5
L01B5    ldb   ,s
         lslb
         leay  b,y
         ldx   P$DATImg,y
         leax  -$01,x
         stx   P$DATImg,y
         bne   L01D0
         ldd   u0002,u
         bsr   L0226
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
         bsr   L0226
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
         clr   $01,x
L021F    leax  $08,x
         cmpx  D.ModEnd
         bcs   L0216
L0225    rts
L0226    addd  #$1FFF
         lsra
         lsra
         lsra
         lsra
         lsra
         rts

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
* COCO specific start
         pshs  u,x
         leax  P$NIO,x
         leau  P$NIO,u
         ldb   #6*2
L0250    lda   ,x+
         sta   ,u+
         decb
         bne   L0250
         puls  u,x
* COCO specific end
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
         leay  -$01,y
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
         lda   <u00D0
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
L02CF    puls  x
         pshs  b
         lbsr  L05A5
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
         leax  -$01,x
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
         leax  u0001,u
         ldy   #$0080
L0317    std   ,x++
         leay  -$01,y
         bne   L0317
         lda   #$80
         sta   u000C,u
         ldb   #$08
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
         beq   L0368
WAIT10    lbsr  L0B2E
 lda P$State,Y Get child's status
 bita #DEAD Is child dead?
         bne   CHILDS
         lda   P$SID,y
         bne   WAIT10
         sta R$A,u
         sta   u0002,u
         pshs  cc
         orcc #IRQMask+FIRQMask Set interrupt masks
         lda   P$Signal,x
         beq   L035D
         deca
         bne   L035A
         sta   P$Signal,x
L035A    lbra  L071B
L035D    ldd   D.WProcQ
         std   P$Queue,x
         stx   D.WProcQ
         puls  cc
         lbra  L0780
L0368    comb Set Carry
 ldb #E$NoChld Err: no children
 rts
CHILDS    lda   P$ID,y
         ldb   P$Signal,y
         std R$D,u
         leau  ,y
         leay  $01,x
         bra   L037C
L0379    lbsr  L0B2E
L037C    lda   R$B,y
         cmpa  ,u
         bne   L0379
         ldb R$B,u
         stb   R$B,y
L0386    pshs  u,x,b,a
         cmpa  >$1015
         bne   L0393
         clr   >$1015
         clr   >$1016
L0393    ldb   ,s
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

CHAIN    pshs  u
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
         leay  -$01,y
         bne   L03C3
         ldu   $02,s
         leau  $40,u
         ldx   ,s
         lda   $06,x
         lsla
         ldx   <u00A1
         stu   a,x
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
         lsrb
         lda   #$08
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
         ldu   u0004,u
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
         leax  -$01,x
         os9   F$LDABX
         exg   x,u
         ldb   $01,s
         leax  -$01,x
         os9   F$STABX
         exg   x,u
         leay  -$01,y
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
         ldd   <u004A
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
         std   $01,y
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
         bsr   L05A5
         ldb R$B,u
         stb P$Signal,X Save status
         leay  $01,x
         bra   L0563
L0551    clr   $02,y
         lbsr  L0B2E
         clr   $01,y
         lda   $0C,y
         bita  #$01
         beq   L0563
         lda   ,y
         lbsr  L0386
L0563    lda   $02,y
         bne   L0551
         leay  ,x
         ldx   #$0047
         lds   D.SysStk
         pshs  cc
         orcc  #$50
         lda   $01,y
         bne   L0584
         puls  cc
         lda   ,y
         lbsr  L0386
         bra   L05A2
L0580    cmpa  ,x
         beq   L0592
L0584    leau  ,x
         ldx   $0D,x
         bne   L0580
         puls  cc
         lda   #$81
         sta   $0C,y
         bra   L05A2
L0592    ldd   $0D,x
         std   u000D,u
         puls  cc
         ldu   $04,x
         ldu   u0008,u
         lbsr  CHILDS
         os9   F$AProc
L05A2    os9   F$NProc
L05A5    pshs  u
         ldb   #$10
         leay  P$Path,x
EXIT10    lda   ,y+
         beq   EXIT15
         clr   -$01,y
         pshs  b
         os9   I$Close
         puls  b
EXIT15    decb
         bne   EXIT10
         clra
         ldb   P$PagCnt,x
         beq   L05CB
         addb  #(DAT.BlSz/256)-1
         lsrb
         lsrb
         lsrb
         lsrb
         lsrb
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

USRMEM   ldx   D.PROC
         ldd R$D,u
         beq   L0638
         addd  #$00FF
         bcc   L05EE
         ldb   #$CF
         bra   L0629
L05EE    cmpa  $07,x
         beq   L0638
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
         lsra
         ldb   ,s
         addb  #(DAT.BlSz/256)-1
         bcc   L0615
         ldb   #$CF
         bra   L0627
L0615    lsrb
         lsrb
         lsrb
         lsrb
         lsrb
         pshs  a
         subb  ,s+
         beq   L0634
         bcs   L062C
         os9   F$AllImg
         bcc   L0634
L0627    leas  $01,s
L0629    orcc  #$01
         rts
L062C    pshs  b
         adda  ,s+
         negb
         os9   F$DelImg
L0634    puls  a
         sta   $07,x
L0638    lda   $07,x
         clrb
         std   u0001,u
         std   u0006,u
         rts


 page
*****
*
*  Subroutine Send
*
* Send a Signal to Process(es)
*
SEND     ldx   D.PROC
         lda R$A,u
         bne   SENSUB
         inca
L0647    cmpa  ,x
         beq   L064D
         bsr   SENSUB
L064D    inca
         bne   L0647
         clrb
         rts
*
* Get destination Process ptr
*
SENSUB    lbsr  L0B2E
         pshs  u,y,a,cc
         bcs   L066A
         tst   u0002,u
         bne   L066D
         ldd   $08,x
         beq   L066D
         cmpd  $08,y
         beq   L066D
         ldb   #$E0
         inc   ,s
L066A    lbra  L06F4
L066D    orcc  #$50
         ldb R$B,u
         bne   L067B
         ldb   #$E4
         lda   $0C,y
         ora   #$02
         sta   $0C,y
L067B    lda   $0C,y
         anda  #$F7
         sta   $0C,y
         lda   <$19,y
         beq   L068F
         deca
         beq   L068F
         inc   ,s
         ldb   #$E9
         bra   L06F4
L068F    stb   <$19,y
         ldx   #$0049
         clra
         clrb
L0697    leay  ,x
         ldx   $0D,x
         beq   L06D3
         ldu   $04,x
         addd  u0004,u
         cmpx  $02,s
         bne   L0697
         pshs  b,a
         lda   $0C,x
         bita  #$40
         beq   L06CF
         ldd   ,s
         beq   L06CF
         ldd   u0004,u
         pshs  b,a
         ldd   $02,s
         std   u0004,u
         puls  b,a
         ldu   $0D,x
         beq   L06CF
         std   ,s
         lda   u000C,u
         bita  #$40
         beq   L06CF
         ldu   u0004,u
         ldd   ,s
         addd  u0004,u
         std   u0004,u
L06CF    leas  $02,s
         bra   L06E0
L06D3    ldx   #$0047
L06D6    leay  ,x
         ldx   $0D,x
         beq   L06F4
         cmpx  $02,s
         bne   L06D6
L06E0    ldd   $0D,x
         std   $0D,y
         lda   <$19,x
         deca
         bne   L06F1
         sta   <$19,x
         lda   ,s
         tfr   a,cc
L06F1    os9   F$AProc
L06F4    puls  pc,u,y,a,cc
 page
*****
*
*  Subroutine Intcpt
*
* Signal Intercept Handler
*
INTCPT ldx D.PROC Get process ptr
         ldd   u0004,u
         std   <$1A,x
         ldd   u0008,u
         std   <$1C,x
         clrb
         rts
page
*****
*
*  Subroutine Sleep
*
* Suspend Process
*
SLEEP pshs  cc
         ldx   D.PROC
         orcc  #$50
         lda   <$19,x
         beq   L0722
         deca
         bne   L0715
         sta   <$19,x
L0715    lda   $0C,x
         anda  #$F7
         sta   $0C,x
L071B    puls  cc
         os9   F$AProc
         bra   L0780
L0722    ldd   u0004,u
         beq   L076D
         subd  #$0001
         std   u0004,u
         beq   L071B
         pshs  y,x
         ldx   #$0049
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
         lda   $0C,x
         ora   #$40
         sta   $0C,x
         ldd   $0D,y
         stx   $0D,y
         std   $0D,x
         ldx R$X,u
         bsr   L0780
         stx R$X,u
         ldx   D.PROC
         lda   $0C,x
         anda  #$BF
         sta   $0C,x
         puls  pc,cc
L076D    ldx   #$0049
L0770    leay  ,x
         ldx   $0D,x
         bne   L0770
         ldx   D.PROC
         clra
         clrb
         stx   $0D,y
         std   $0D,x
         puls  cc
L0780    pshs  pc,u,y,x
         leax  <L079C,pcr
         stx   $06,s
         ldx   D.PROC
         ldb   $06,x
         cmpb  D.SysTsk
         beq   L0792
         os9   F$DelTsk
L0792    ldd   $04,x
         pshs  dp,b,a,cc
         sts   P$SP,x
         os9   F$NProc
L079C    pshs  x
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
         lbsr  L0B2E
         bcs   SETP20
         ldx   D.PROC
         ldd   P$User,x
         beq   L07B7
         cmpd  P$User,y
         bne   SETP10
L07B7    lda   R$B,u
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
         ldx   <u004A
         stx   D.PROC
         lda   #$C1
         leax  <ClockNam,pcr
         os9   F$Link
         puls  x
         stx   D.PROC
         bcs   L0816
         jmp   ,y
L0816    rts

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
         bsr   L086E
         ldy   D.PROC
         ldb   $06,y
         bra   L082C

SALLBIT  ldd R$D,u
         ldx R$X,u
         bsr   L086E
         ldb   D.SysTsk
L082C    ldy R$Y,u
         beq   L086C
         sta   ,-s
         bmi   L0847
         os9   F$LDABX
L0838    ora   ,s
         leay  -$01,y
         beq   L0867
         lsr   ,s
         bcc   L0838
         os9   F$STABX
         leax  $01,x
L0847    lda   #$FF
         bra   L0852
L084B    os9   F$STABX
         leax  $01,x
         leay  -$08,y
L0852    cmpy  #$0008
         bhi   L084B
         beq   L0867
L085A    lsra
         leay  -$01,y
         bne   L085A
         coma
         sta   ,s
         os9   F$LDABX
         ora   ,s
L0867    os9   F$STABX
         leas  $01,s
L086C    clrb
         rts
L086E    pshs  y,b
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         leax  d,x
         puls  b
         leay  <L0883,pcr
         andb  #$07
         lda   b,y
         puls  pc,y

L0883    fcb  $80,$40,$20,$10,$08,$04,$02,$01

DELBIT   ldd R$D,u
         ldx R$X,u
         bsr   L086E
         ldy   D.PROC
         ldb   $06,y
         bra   L08A0

SDELBIT  ldd R$D,u
         ldx R$X,u
         bsr   L086E
         ldb   D.SysTsk
L08A0    ldy R$Y,u
         beq   L08E0
         coma
         sta   ,-s
         bpl   L08BC
         os9   F$LDABX
L08AD    anda  ,s
         leay  -$01,y
         beq   L08DB
         asr   ,s
         bcs   L08AD
         os9   F$STABX
         leax  $01,x
L08BC    clra
         bra   L08C6
L08BF    os9   F$STABX
         leax  $01,x
         leay  -$08,y
L08C6    cmpy  #$0008
         bhi   L08BF
         beq   L08DB
         coma
L08CF    lsra
         leay  -$01,y
         bne   L08CF
         sta   ,s
         os9   F$LDABX
         anda  ,s
L08DB    os9   F$STABX
         leas  $01,s
L08E0    clrb
         rts

SCHBIT   ldd R$D,u
         ldx R$X,u
         bsr   L086E
         ldy   D.PROC
         ldb   $06,y
         bra   L08F8

SSCHBIT     ldd R$D,u
         ldx R$X,u
         lbsr  L086E
         ldb   D.SysTsk
L08F8    pshs  u,y,x,b,a,cc
         clra
         clrb
         std   $03,s
         ldy R$D,u
         sty   $07,s
         bra   L0911
L0906    sty   $07,s
L0909    lsr   $01,s
         bcc   L091C
         ror   $01,s
         leax  $01,x
L0911    cmpx  u0008,u
         bcc   L093A
         ldb   $02,s
         os9   F$LDABX
         sta   ,s
L091C    leay  $01,y
         lda   ,s
         anda  $01,s
         bne   L0906
         tfr   y,d
         subd  $07,s
         cmpd  u0006,u
         bcc   L0943
         cmpd  $03,s
         bls   L0909
         std   $03,s
         ldd   $07,s
         std   $05,s
         bra   L0909
L093A    ldd   $03,s
         std   u0006,u
         comb
         ldd   $05,s
         bra   L0945
L0943    ldd   $07,s
L0945    std   u0001,u
         leas  $09,s
         rts

GPRDSC   ldx   D.PROC
         ldb   $06,x
         lda R$A,u
         os9   F$GProcP
         bcs   L0962
         lda   D.SysTsk
         leax  ,y
         ldy   #$0200
         ldu   u0004,u
         os9   F$Move
L0962    rts

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

SETUSER  ldx   D.PROC
         ldd   u0006,u
         std   $08,x
         clrb
         rts

CPYMEM   ldd   u0006,u
         beq   L0A01
         addd  u0008,u
         bcs   L0A01
         leas  -$10,s
         leay  ,s
         pshs  y,b,a
         ldx   D.PROC
         ldb   $06,x
         pshs  b
         leay  P$DATImg,x
         ldx   u0001,u
         ldb   #$08
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
         ldu   u0008,u
         ldy   $03,s
         puls  b
         bra   L09E7
L09E1    leax  -DAT.BlSz,x
         leay  $02,y
L09E7    cmpx  #DAT.BlSz
         bcc   L09E1
         os9   F$LDAXY
         leax  $01,x
         exg   x,u
         os9   F$STABX
         leax  $01,x
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
         ldx   u0006,u
         beq   L0A21
         leax  -$01,x
         stx   u0006,u
         bne   L0A4E
L0A21    cmpa  #$D0
         bcs   L0A4B
         clra
         ldx   [,u]
         ldy   <u004C
L0A2B    adda  #$02
         cmpa  #$10
         bcc   L0A4B
         cmpx  a,y
         bne   L0A2B
         lsla
         lsla
         lsla
         lsla
         clrb
         addd  u0004,u
         tfr   d,x
         os9   F$IODel
         bcc   L0A4B
         ldx   u0006,u
         leax  $01,x
         stx   u0006,u
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
         beq   L0A70
         clrb
         lsra
         rorb
         lsra
         rorb
         lda   a,x
         tfr   d,y
         beq   L0A70
         tst   ,y
         bne   L0A71
L0A70    coma
L0A71    puls  pc,b,a

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
         bne   L0A7F
         bsr   L0A89
         bcs   L0A88
         stx   ,x
         stx R$X,u
L0A7F    bsr   L0A9F
         bcs   L0A88
         sta R$A,u
         sty R$Y,u
L0A88    rts
L0A89    pshs  u
         ldd   #$0100
         os9   F$SRqMem
         leax  ,u
         puls  u
         bcs   L0A9E
         clra
         clrb
L0A99    sta   d,x
         incb
         bne   L0A99
L0A9E    rts
L0A9F    pshs  u,x
         clra
L0AA2    pshs  a
         clrb
         lda   a,x
         beq   L0AB4
         tfr   d,y
         clra
L0AAC    tst   d,y
         beq   L0AB6
         addb  #$40
         bcc   L0AAC
L0AB4    orcc  #$01
L0AB6    leay  d,y
         puls  a
         bcc   L0AE1
         inca
         cmpa  #$40
         bcs   L0AA2
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
         bsr   L0A89
         bcs   L0AF0
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
L0AF0    leas  $03,s
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
         beq   L0B22
         lsra
         rorb
         lsra
         rorb
         pshs  a
         lda   a,x
         beq   L0B20
         tfr   d,y
         clr   ,y
         clrb
         tfr   d,u
         clra
L0B10    tst   d,u
         bne   L0B20
         addb  #$40
         bne   L0B10
         inca
         os9   F$SRtMem
         lda   ,s
         clr   a,x
L0B20    clr   ,s+
L0B22    puls  pc,u,y,x,b,a


GPROCP   lda R$A,u
         bsr   L0B2E
         bcs   L0B2D
         sty R$Y,u
L0B2D    rts
L0B2E    pshs  x,b,a
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
L0B55    ldd   ,u
         addd  D.BlkMap
         tfr   d,x
         lda   ,x
         anda  #$FE
         sta   ,x
         ldd   #DAT.Free
         std   ,u++
         leay  -$01,y
         bne   L0B55
         puls  x
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         clrb
         rts

MAPBLK   lda   u0002,u
         beq   L0BAA
         cmpa  #$08
         bhi   L0BAA
         leas  -$10,s
         ldx R$X,u
         leay  ,s
L0B82    stx   ,y++
         leax  $01,x
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
         lsla
         clrb
         std   u0008,u
         puls  b,a
         leau  ,s
         os9   F$SetImg
L0BA6    leas  <$10,s
         rts

L0BAA    comb
         ldb   #$DB
         rts

CLRBLK   ldb R$B,u
         beq   L0BE9
         ldd   u0008,u
         tstb
         bne   L0BAA
         bita  #(DAT.BlSz/256)-1
         bne   L0BAA
         ldx   D.PROC
         lda   $04,x
         anda  #$E0
         suba  u0008,u
         bcs   L0BCE
         lsra
         lsra
         lsra
         lsra
         lsra
         cmpa  u0002,u
         bcs   L0BAA
L0BCE    lda   $0C,x
         ora   #$10
         sta   $0C,x
         lda   u0008,u
         lsra
         lsra
         lsra
         lsra
         leay  P$DATImg,x
         leay  a,y
         ldb R$B,u
         ldx   #DAT.Free
L0BE4    stx   ,y++
         decb
         bne   L0BE4
L0BE9    clrb
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
L0CA2    leau  u0008,u
L0CA4    cmpu  D.ModEnd
         bne   L0C9B
         puls  pc,u
         emod
OS9End   equ   *
