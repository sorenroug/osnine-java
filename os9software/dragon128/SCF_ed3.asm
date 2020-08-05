 nam   SCF
 ttl   Sequential Character file manager

* This is a LEVEL 2 module
* Originally from Dragon 128

* Copyright 1982 by Microware Systems Corporation
* Reproduced Under License

* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!

 use defsfile

***************
* Edition History

*  #   date    Comments                                      by
* -- -------- --------------------------------------------- ---
*  1 82/07/11 Code inserted to initialize V.XON, V.XOFF     RFD
*  1 82/10/12 Bug in ctl-A fixed; (O,S --) 2,S)             RFD

*    83/11/10 Macros added.    Vivaway Ltd.                 PSD

Edition equ 3    current edition number

 ttl Module Header
 page

***************
* Sequential Character File Manager

* Designed for terminal/printer console-type devices.
* Supports line oriented buffered input, with line
* editing (backspace, delete, repeat line, reprint
* line, echo on/off, etc.)

 mod SCFEnd,SCFName,FLMGR+OBJCT,REENT+1,SCF,0
SCFName fcs "SCF"
 fcb Edition Current Edition

SCF lbra SCCrea
 lbra SCOpen
 lbra SCOErr   makdir
 lbra SCOErr
 lbra Open90
 lbra Open90
 lbra SCRead
 lbra SCWrite
 lbra SCRdLine
 lbra SCWrLine
 lbra SCGStat
 lbra SCPstat
 lbra SCClose

EXTEND equ 1
MACROS equ 1
BuffSize equ $100
OutBfSiz equ 32 maximum size of output "buffer"
 ifne MACROS
MacBfSiz equ $100 macro buffer size
 endc

 ttl Open/Close/GetStat etc.
 page
***************
* SCCrea & SCOpen
*   Process Create/Open Request

* Passed: (Y) = Path Descriptor ptr
SCCrea equ *
SCOpen ldx PD.DEV,y
 stx   PD.TBL,y
 ldu   PD.RGS,y
 pshs  y
 ldx   R$X,u
 os9   F$PrsNam
 lbcs  SCOER1
 tsta
 bmi   Open0
 leax  0,y
 os9   F$PrsNam
 bcc   SCOER1
Open0    sty   R$X,u        Save updated name pointer to caller
 puls  y
 ifne MACROS
 ldd   #BuffSize+MacBfSiz
 else
 ldd   #BuffSize
 endc
 os9   F$SRqMem
 bcs   OPNER9
 stu   PD.BUF,y

 ifeq CPUType-DRG128
 clr   BuffSize,u show macro buffer empty
 clr   BuffSize+3,u show no macros installed
 endc
         clrb

***************
* This code may be optimized by "lda #C$CR"
* In severe cases when memory is expensive
         bsr   JAMMER
* cute message:
* "by K.Kaplan, L.Crane, R.Doggett"
 fcb   $62,$1B,$59,$6B,$65,$65,$2A,$11,$1C,$0D,$0F
 fcb   $42,$0C,$6C,$62,$6D,$31,$13,$0F,$0B,$49,$0C
 fcb   $72,$7C,$6A,$2B,$08,$00,$02,$11,$00,$79

* put cute message into our newly allocated PD buffer
JAMMER    puls  x
 clra
JAMM10    eora  ,x+
 sta   ,u+
 decb
 cmpa  #$0D
 bne   JAMM10
* end of optimizable code
***************

Open1    sta   ,u+
         decb
         bne   Open1
         ldu   PD.DEV,y     Get device table entry address
         beq   SCOErr
         ldx   V$STAT,u
         lda   PD.PAG,y  Get lines per page
         sta   V.LINE,x
         ldx   V$DESC,u
         ldd   PD.D2P,y
         beq   Open90
         leax  d,x
         lda   PD.MOD,y
         lsra
         rorb
         lsra
         rolb
         rola
         rorb
         rola
         pshs  y
         ldy   D.Proc
         ldu   D.SysPrc
         stu   D.Proc
         os9   I$Attach
         sty   D.Proc
         puls  y
         bcs   OPNER9
         stu   PD.DV2,y
Open90   clra
         rts

SCOER1    puls  pc,y

SCOErr    comb
         ldb   #E$BPNam
OPNER9    rts

SCClose pshs  cc
         orcc #IntMasks
         ldx   PD.DEV,y
         bsr   DenyDev
         ldx   PD.DV2,y
         bsr   DenyDev
         puls  cc
         tst   PD.CNT,y
         bne   Close.C
         ldu   PD.DV2,y
         beq   Close.B
         os9   I$Detach
Close.B    ldu   PD.BUF,y
         beq   Close.C
 ifne MACROS
 ldd #BuffSize+MacBfSiz get buffer size
 else
 ldd #BuffSize
 endc
 os9 F$SRtMem
Close.C    clra
         rts

***************
* Subroutine DenyDev
*   Eliminate ownership of device for this Process
* Passed: (X)=device tbl ptr of entry to deny

DenyDev    leax  0,x
         beq   Close.C
         ldx   V$STAT,x
         ldb   ,y
         lda   PD.CPR,y
         pshs  y,x,b,a
         cmpa  V.LPRC,x
         bne   Deny.Z
         ldx   D.Proc
         leax  P$Path,x
         clra
Deny.A cmpb  a,x
         beq   Deny.Z
         inca
         cmpa  #NumPaths
         bcs   Deny.A
         pshs  y
         ldd   #SS.Relea*256+D$PSTA
         lbsr  SCGST1
         puls  y
         ldx   D.Proc
         lda   P$PID,x
         sta   0,s
         os9   F$GProcP
         leax  P$Path,y
         ldb  1,s
         clra
L0136    cmpb  a,x
         beq   L0141
         inca
         cmpa  #NumPaths
         bcs   L0136
         clr   0,s
L0141    lda   0,s
         ldx   2,s
         sta   V.LPRC,x
Deny.Z    puls  pc,y,x,b,a

  ifeq CPUType-DRG128

********************
* Install a macro
*
SCInMac lda R$Y,u
         beq   SCInMac6
         bsr   SCClrM
         ldb   $07,u
         beq   SCInMac6
         ldx   PD.BUF,y
         leax  BuffSize+MacBfSiz,x
         pshs  x
         leax  >-MacBfSiz+3,x point at macro buffer
SCInMac1    lda   ,x+
         beq   SCInMac2
         ldb   ,x+
         abx
         cmpx  ,s
         bcc   SCInMac3
         bra   SCInMac1
SCInMac2    ldb   R$Y+1,u
         pshs  x
         abx
         leax  1,x
         cmpx  2,s
         bhi   SCInMac4
         beq   SCInMac5
         clr   ,x
SCInMac5    puls  x
         stb   ,x+
         clra
         pshs  y,b,a
         lda   $06,u
         sta   -$02,x
         ldy   D.Proc
         lda   $06,y
         ldb   D.SysTsk
         ldu   $04,u
         exg   x,u
         puls  y
         os9   F$Move
         puls  y
         leas  $02,s
SCInMac6    clrb
         rts
SCInMac4    leas  $02,s
SCInMac3    leas  $02,s
         comb
         ldb   #E$MemFul
         rts

********************
* Clear a macro
*
SCClrM    ldx   PD.BUF,y
         leax  BuffSize,x
         lda   R$Y,u
         beq   SCClrM3
         leax  MacBfSiz,x
         pshs  x
         leax  -MacBfSiz+3,x
SCClrM1    cmpa  ,x
         beq   SCClrM2
         tst   ,x+
         beq   SCClrM4
         ldb   ,x+
         abx
         cmpx  ,s
         bcs   SCClrM1
         bra   SCClrM4

SCClrM2    ldb   1,x
         pshs  y
         tfr   x,y
         abx
         leax  $02,x
SCClrM7    cmpx  $02,s
         bcc   SCClrM5
         tst   ,x
         beq   SCClrM5
         lda   ,x+
         sta   ,y+
         ldb   ,x+
         stb   ,y+
SCClrM6    lda   ,x+
         sta   ,y+
         decb
         bne   SCClrM6
         bra   SCClrM7
SCClrM5    clr   ,y
         puls  y
SCClrM4    leas  $02,s
         clrb
         rts
SCClrM3    clr   $03,x
         rts
  endc

********************
* Find a macro
*
SCFMac    ldx   PD.BUF,y
         leax  BuffSize+MacBfSiz,x
         pshs  x
         leax  -MacBfSiz+3,x
L0202    tst   ,x+
         beq   L0211
         ldb   ,x+
         cmpa  -$02,x
         beq   SCFMac2
         abx
         cmpx  ,s
         bcs   L0202
L0211    comb
SCFMac2    leas  $02,s
         rts
* endc HERE

* (Y) = Path descriptor pointer
* (U) = Caller's register stack pointer
SCGStat  ldx   PD.RGS,y
         lda   R$B,x
 ifeq CPUType-DRG128
         cmpa  #SS.Edit   $1C
         beq   SCEdit
 endc
         cmpa  #SS.OPT
         beq   SCRETN
         ldb   #D$GSTA

SCGST1    pshs  a
         clra
         ldx   PD.DEV,y
         ldu   V$STAT,x
         ldx   V$DRIV,x
         addd  M$Exec,x
         leax  d,x
         puls  a restore status function code
         jmp   0,x    into the hands of a friendly driver

SCPstat  lbsr  SCALOC
         bsr   PutStat
         pshs  b,cc
         lbsr  IODONE
         puls  pc,b,cc

PutStat    lda   R$B,u
  ifeq CPUType-DRG128
         cmpa  #SS.SMac
         lbeq  SCInMac
         cmpa  #SS.CMac
         lbeq  SCClrM
 endc
         ldb   #D$PSTA
         cmpa  #SS.Opt
         bne   SCGST1
         pshs  y
         ldx   D.Proc
         lda   P$Task,x
         ldb   D.SysTsk
         ldx   R$X,u
         leau  PD.OPT,y
         ldy   #OptCnt
         os9   F$Move
         puls  y
SCRETN    rts

 ttl Input Routines
 page
  ifeq CPUType-DRG128
***************
* Scedit
*   Process Edit Line Request
*
* Passed: (Y)=File Descriptor Static Storage
*   User regs: (X)=Pointer to buffer
*              (Y)=Max byte count
*              (U)=Start cursor position
SCEdit    lbsr  SCALOC
         bcs   SCRETN
         ldx   $06,u
         lbeq  SCRead3
         tst   $06,u
         beq   SCEdit10
         ldx   #256

SCEdit10    pshs  y,x
         ldx   D.Proc
         lda   P$Task,x
         ldb   D.SysTsk
         ldx   $04,u
         ldu   PD.BUF,y
         ldy   ,s
         os9   F$Move
         puls  y,x
         tfr   u,d
         leax  d,x
         pshs  x
         lbsr  SCRPET
         ldu   PD.RGS,y
         lda   $09,u
         pshs  b
         cmpa  ,s+
         bcs   L02A6
         tfr   b,a
L02A6    pshs  a
         subb  ,s+
         pshs  b
         tfr   a,b
         clra
         addd  $08,y
         tfr   d,u
         ldb   ,s+
         beq   L02B9
         bsr   SCEdit20
L02B9    lbra  SCRd20

SCEdit20    pshs  b
         lbra  SCDLL2
 endc
***************
* SCRead
*   Process Read Request
*
* Passed: (Y)=File Descriptor Static Storage

SCRead     lbsr  SCALOC
         bcs   SCRETN
         inc   PD.RAW,y
         ldx   $06,u
         lbeq  L0351
         pshs  x
*ifne EXTEND here
         ldu   PD.BUF,y
         ldx   #$0000
*else
*endc
 ifeq CPUType-DRG128
         pshs  x,a save regs
         ldx   BuffSize+1,u get possible current macro ptr
         ldb   BuffSize,u is there some?
         bne   SCRead5 ..yes; send it
         puls  x,a retrieve regs
 endc
         lbsr  GetChr get character
         bcs   SCERR
         tsta null byte?
         beq   SCRead2
         cmpa  PD.EOF,y
         bne   SCRead15
SCEOFX    ldb   #E$EOF
SCERR    leas  2,s
         pshs  b
         bsr   SCRead3
         comb
         puls  pc,b

SCRead1    tfr   x,d
         tstb
         bne   SCRead12
         lbsr  RetData
         ldu   PD.BUF,y
SCRead12    lbsr  GetChr
         bcs   SCERR



 ifeq CPUType-DRG128
SCRead15 pshs  x,a
         pshs  y
         lbsr  SCGetDev
         bcs   L0326
         cmpa  <$1C,y
         bne   L0326
         ldy   ,s
         lbsr  GetChr
         ora   #$80
         bcc   L0326
         leas  $05,s
         bra   SCERR

L0326    puls  y
         sta   ,s
         lbsr  SCFMac
         bcc   SCRead5
         puls  x,a
 tst PD.EKO,y echo on?
 else
SCRead15 pshs  x,a
 tst PD.EKO,y echo on?
 endc
         beq   SCRead2
         lbsr  PutDv2 Print character
SCRead2    leax  1,x
         sta   ,u+
         beq   L0344
         cmpa  PD.EOR,y
         beq   SCRead25
L0344    cmpx  ,s
         bcs   SCRead1
SCRead25    leas  $02,s
SCRead3    lbsr  RetData
         ldu   $06,y
         stx   $06,u
L0351    lbra  IODONE

 ifeq CPUType-DRG128

SCRead5 leas 1,s
         pshs  x,b
L0358    ldx  1,s
         lda   ,x+
         sta   ,u+
         stx  1,s
         dec   ,s
         tst   PD.EKO,y
         beq   SCRead62
         lbsr  PutDv2 Print character
SCRead62    ldx   $03,s
         leax  $01,x
         stx   $03,s
         cmpx  $05,s
         bcc   SCRead7
         tfr   x,d
         tstb
         bne   L037E
         lbsr  RetData
         ldu   PD.BUF,y
L037E    tst   ,s
         bne   L0358
         leas  $05,s
         lbra  SCRead12
SCRead7    ldx   PD.BUF,y
         puls  b
         stb   BuffSize,x
         puls  b,a
         std   BuffSize+1,x
         puls  x
         bra   SCRead25
 endc

* SCRdLine
*   Buffer a line from the Input device
*   using line-editing functions
* Passed: (Y)=File Descriptor address
*         (U)=Caller's register stack

SCRdLine   lbsr  SCALOC        Go wait for device to be ready
 ifne EXTEND
         lbcs  SCRETN
 else
 endc
         ldx   R$Y,u        Get character count
         beq   SCRead3
         tst   R$Y,u               Past 256 bytes?
         beq   SCRd10
         ldx   #256       Get new character count
 ifne EXTEND
SCRd10    tfr   x,d
         addd  PD.BUF,y
         pshs  b,a
 else
 endc
         lbsr  SCDEL9
 ifeq CPUType-DRG128
 clr   BuffSize,u cance any current macro
 endc
SCRd20    lbsr  GetChr
         lbcs  SCABT
* anda #$7F was used to strip high bit
         tsta
         beq   SCRd35
         ldb   #PD.BSP Test special characters
SCRd25    cmpa  b,y
         beq   SCCTLC
         incb
         cmpb  #PD.QUT
         bls   SCRd25

 ifeq CPUType-DRG128

         pshs  y
         bsr   SCGetDev
         bcs   SCRd27
         cmpa  PD.LdIn-PD.OPT,Y lead-in code?
         bne   L03E6
         pshs  y
         ldy   $02,s
         lbsr  GetChr
         puls  y
         bcs   SCRd90
         ora   #$80
L03E6    ldb   #PD.QUT+1
         leay  PD.Left-PD.OPT,y
SCRd65    cmpa  ,y+
         beq   SCRd70
         incb
         cmpb  #PD.QUT+PD.DEol-PD.Left+1 more?
         bls   SCRd65
SCRd27    puls  y
         lbra  SCChkMac
 endc
 ifne MACROS+EXTEND
SCRd30
 endc
SCRd35    leax  1,x
         cmpx  0,s
 ifne EXTEND
 leax  -1,x
 endc
         bcs   SCRd40
L0401    lda   PD.OVF,y
 lbsr OUTCHR
 ifeq EXTEND
 endc
 bra   SCRd20
SCRd40    lbsr  UPCASE
 ifne EXTEND
 lbsr  SCINS
 else
 endc
         bra   SCRd20
 ifne EXTEND
SCRd90    puls  y
         lbra  SCABT

SCRd70    puls  y

 endc

SCCTLC    pshs  pc,x
         leax  CTLTBL,pcr    Point to branch table
         subb  #PD.BSP
 ifne EXTEND
         pshs  a
         lslb
         ldd   b,x
         leax  d,x
         puls  a
 else
 endc
         stx   $02,s
         puls  x
         jsr   [,s++]       Execute routine
 ifne EXTEND
 lbra  SCRd20
 else
 endc

 ifne EXTEND
* Process "Edit" character
* Sets Y
SCGetDev    pshs  a
         lda   <$3B,y   PD.Edit,y
         pshs  a
         ldy   PD.DEV,y
         ldy   V$DESC,y
         leay  M$DTyp,y
         coma
         lda   ,s+     No-edit flag set?
         bne   SCGetD1  ..yes
         clra    Clear carry
SCGetD1    puls  pc,a
 endc

CTLTBL
 fdb SCBSP-CTLTBL        Process PD.BSP
 fdb SCDEL-CTLTBL        Process PD.DEL
 fdb SCEOL-CTLTBL        Process PD.EOR
 fdb SCEOF-CTLTBL        Process PD.EOF
 fdb SCPRNT-CTLTBL        Process PD.RPR
 fdb SCRPET-CTLTBL        Process PD.DUP
 fdb L04D7-CTLTBL        Process PD.PSC
 fdb SCDEL-CTLTBL   Process PD.INT
 fdb SCDEL-CTLTBL   Process PD.QUT
 fdb SCLFT-CTLTBL   $0110
 fdb SCRT-CTLTBL   $00F9
 fdb SCDLRT-CTLTBL   $0170
 fdb SCDELR-CTLTBL Pd.deol



* Process PD.EOR character
SCEOL    leas  $02,s
 ifne EXTEND
         bsr   SCMKEL
 else
 endc
         lbsr  CHKEKO
         ldu   PD.RGS,y
 ifne EXTEND
         bsr   SCGetLen
 endc
         leax  $01,x
         stx   $06,u
         lbsr  RetData
         leas  $02,s
         lbra  IODONE

 ifne EXTEND
SCGetLen    exg   x,d
         subd  $08,y
         exg   d,x
         rts

SCMKEL    lda   #$0D
         sta   ,x
         rts

SCChkEol    pshs  x
         cmpu  ,s
         puls  pc,x
 endc

SCEOF    leas  $02,s
 ifne EXTEND
         cmpx  PD.BUF,y
         lbne  SCRd30
         ldx   #0
         lbra  SCEOFX
 else
 endc

SCABT    pshs  b
 ifne EXTEND
 bsr   SCMKEL
 else
 endc
 ifne EXTEND
 lbsr  EKOCR
 else
 endc
         puls  b
         lbra  SCERR

* Process interrupt
SCDEL    tfr   u,d
         subd  PD.BUF,y
         beq   L04D7
         pshs  b
         pshs  b
         pshs  b
         pshs  y
         ldy   PD.BUF,y
         bsr   SCChkEol
         bcc   L04C7
L04BD    lda   ,u+
         sta   ,y+
         inc   $04,s
         bsr   SCChkEol
         bcs   L04BD
L04C7    leax  ,y
         puls  y
         ldu   PD.BUF,y
         tst   PD.DLO,y
         beq   SCDEL2
         leas  $03,s
         lbra  EKOCR
L04D7    rts

SCDEL2    bsr   SCMLFT
         dec   ,s
         bne   SCDEL2
         lbsr  SCShLn
L04E1    bsr   SCSPACE
         dec  1,s
         bne   L04E1
         leas  $02,s
         lbra  SCDLL2

* Delete line right
SCDELR    clr   ,-s clear counter
         pshs  u,x save cursor and EOL ptr
         leax  ,u new EOL ptr
SCDELR1    cmpu  ,s check end of line
         beq   SCDELR2 ..yes
         leau  1,u bump cursor
         bsr   SCSPACE clear a space
         inc   4,s keep count
         bra   SCDELR1

SCDELR2    puls  u,b,a retrieve cursor and scratch
         tst   ,s any backspaces needed?
         lbne  SCDLL2 ..yes
         puls  pc,b

SCSPACE    lda   #C$SPAC write a space
         lbra  CHKEKO

SCMLFT    pshs  y save path descriptor ptr
         lbsr  SCGetDev point into device descriptor
         bcs   SCMLFT20
         ldb   #$1E PD.Mlft-PD.OPT
         bra   SCOutX10 send it

SCMLFT20    puls  y retrieve PD ptr
         lbra  SCBSP2 use backspace echo chr

SCMRT    pshs  y save path descriptor ptr.
         ldb   #$1F  PD.MRt-PD.OPT offset to 'move right' code
         lbsr  SCGetDev point into device descriptor
         bcs   SCMRT30
SCOutX10    pshs  x
         leax  ,y point at codes with X
         ldy   2,s retrieve PD ptr
         lda   b,x get code
         bpl   SCMRT20
         anda  #$7F clear high bit
         pshs  a save code
         lda   <$1D,x PD.LdOut-PD.OPT,X get lead-in chr
         beq   SCMRT10 skip if none
         bsr   OUTCHR Print lead-out character
SCMRT10    puls  a
SCMRT20    bsr   OUTCHR Print character
SCMRT30    puls  pc,y,x

SCRT    bsr   SCChkE at end of line?
         bcc   L054E
         bsr   SCMRT
         bcs   L054D
         leau  1,u bump the cursor
L054D    rts

L054E    tfr   u,d calculate chrs to move back..
         subd  PD.BUF,y
         beq   L054D
         pshs  b
         ldu   PD.BUF,y
         bra   SCDLL2 move to start of line

SCLFT    cmpu  PD.BUF,y
         beq   SCLFT20
         bsr   SCMLFT
         bcs   SCLFT10
         leau  -1,u update cursor
SCLFT10    rts

SCLFT20    bsr   SCChkE
         beq   SCLFT30
         leau  $01,u
         bsr   SCMRT
         bcc   SCLFT20

SCLFT30 rts

*else
*endc
 ifne EXTEND
SCDEL9 ldx PD.BUF,y reset EOL ptr
 tfr x,u and cursor
 else
 endc
 rts

 ifne EXTEND
SCBSP    cmpu  PD.BUF,y at start
 beq   SCLFT30 ..yes; return
 bsr   SCChkE at end of line?
 bne   SCDLLF ..no; delete left
 else
 endc
         leau  -1,u
         leax  -1,x
         tst   PD.BSO,y
         beq   SCBSP2
         bsr   SCBSP2
 ifne EXTEND
 lbsr  SCSPACE send space
 else
 endc
SCBSP2 lda PD.BSE,y Get backspace echo char
 ifne EXTEND
OUTCHR    lbra  EKOBYT Print character
 else
 endc
 ifne EXTEND
SCChkE lbra SCChkEol

* Delete left one
SCDLLF    lbsr  SCMLFT
         leau  -1,u
SCDL    pshs  u
SCDLL1    lda   1,u
         sta   ,u+
         bsr   SCChkE
         bcs   SCDLL1
         puls  u
         leax  -1,x
         bsr   SCShLn
SCDL1    incb
         pshs  b
         lbsr  SCSPACE

SCDLL2    lbsr  SCMLFT
         dec   ,s
         bne   SCDLL2
         puls  pc,a

* Delete character under cursor
SCDLRT    bsr   SCChkE
         bcc   L05C9
         leax  -$01,x
         clrb
         bsr   SCChkE
         bcc   SCDL1
         leax  $01,x
         bra   SCDL

L05C9    rts

* Display to end of line
SCShLn    clrb
         pshs  u,b
L05CD    bsr   SCChkE
         bcc   L05DE
         lda   ,u+
         cmpa  #$0D done?
         beq   L05DE
         lbsr  CHKEKO
         inc   ,s
         bra   L05CD
L05DE    puls  pc,u,b

* Insert a character into the buffer
SCINS    bsr   SCChkE
         bcs   SCINS1
         sta   ,u+
         leax  $01,x
         lbra  CHKEKO

SCINS1    pshs  u
         leau  ,x
L05EF    ldb   ,-u
         stb   $01,u
         cmpu  ,s
         bne   L05EF
         leas  $02,s
         sta   ,u
         leax  $01,x
         bsr   SCShLn
         leau  $01,u
 decb one less backspace
 pshs  b save count
 bra SCDLL2 end move back to cursor position

 endc
EKOCR    lda   #C$CR
         lbra  EKOBYT Print character

 ifne EXTEND
SCPRNT    lbsr  SCMKEL
 else
 endc
 ifne EXTEND
         lbsr  SCDEL9
 else
 endc
SCPRT1 lbsr EKOCHR

 ifne EXTEND
SCRPET    ldx   $02,s
         bsr   SCShLn
         clra
         pshs  u
         addd  ,s++
         tfr   d,x
         leau  ,x
         rts
 else
 endc

 ifeq CPUType-DRG128
* Check character against macro table
SCChkMac    pshs  x,a
         lbsr  SCFMac
         bcc   SCRd80
         puls  x,a
         lbra  SCRd35
 endc Not in source

SCRd80    leas 1,s
         pshs  x,b
         ldx   $03,s
         abx
         cmpx  $05,s
         bcs   SCRd87
         leas  $03,s
         puls  x
         lbra  L0401
SCRd87    pshs  u
         cmpu  $05,s
         bcc   SCRd95
         ldu   $05,s
         tfr   u,d
         subd  ,s
SCRd88    lda   ,-u
         sta   ,-x
         decb
         bne   SCRd88
         ldu   ,s
         ldb   $02,s
SCRd95    ldx   $03,s
L065B    lda   ,x+
         sta   ,u+
         decb
         bne   L065B
         ldx   $05,s
         ldb   $02,s
         abx
         stu   $03,s
         ldu   ,s
         lbsr  SCShLn
         subb  $02,s
         beq   L0674
         bsr   SCRd120
L0674    ldu 3,s
 leas 7,s ditch scratch
 lbra SCRd20 and go for next chr

SCRd120 pshs  b push byte count
 lbra  SCDLL2 move back
*endc here in source

***************
* GetChr
*   get one character from Input device

GetDv2    pshs  u,y,x
         ldx   PD.FST,y
         ldu   PD.DEV,y
         bra   L0690

GetChr    pshs  u,y,x
         ldx   PD.DEV,y
         ldu   PD.FST,y
         beq   L0697
L0690    ldu   $02,u
         ldb   PD.PAG,y
         stb   V.LINE,u
L0697    leax  ,x
         beq   L06A7
         tfr   u,d
         ldu   V$STAT,x
         std   V.DEV2,u
         ldu   #D$READ
         lbsr  IOEXEC
L06A7    puls  pc,u,y,x

*
UPCASE    tst   PD.UPC,y
         beq   UPCAS9
         cmpa  #'a
         bcs   UPCAS9
         cmpa  #'z
         bhi   UPCAS9
         suba  #'a-'A convert to uppercase
UPCAS9    rts

* Check for printable character
CHKEKO    tst   PD.EKO,y       Echo turned on?
         beq   UPCAS9
EKOCHR    cmpa  #$7F
         bcc   EKOCH2
         cmpa  #$20
         bcc   EKOBYT Print character
         cmpa  #$0D
         bne   EKOCH2
EKOBYT    lbra  PutDv2 Print character

* Non-printable character
EKOCH2    pshs  a              Save code
         lda   #'.
         bsr   EKOBYT Print character
         puls  pc,a

RetData    pshs  y,x
         ldd   ,s
         beq   L06FB
         tstb
         bne   RetDat10
         deca
RetDat10    clrb
         ldu   $06,y
         ldu   $04,u
         leau  d,u
         clra
         ldb  1,s
         bne   L06EC
         inca
L06EC    pshs  b,a
         lda   D.SysTsk
         ldx   D.Proc
         ldb   $06,x
         ldx   $08,y
         puls  y
         os9   F$Move
L06FB    puls  pc,y,x

*****************
* IODONE
IODONE    ldx  D.Proc
         lda   P$ID,x
         ldx   PD.DEV,y
         bsr   L0707
         ldx   $0A,y
L0707    beq   IODO90
         ldx   $02,x
         cmpa  $04,x
         bne   IODO90
         clr   $04,x
IODO90    rts

GetDev    pshs  x,a
         ldx   $02,x
         lda   $04,x
         beq   GetDev10
         cmpa  ,s
         beq   GetDev20
         pshs  a
         bsr   IODONE
         puls  a
         os9   F$IOQu
         inc   $0F,y
         ldx   D.Proc
         ldb   P$Signal,X
         puls  x,a
         beq   GetDev
         coma
         rts

GetDev10    lda 0,s
         sta   V.Busy,x mark device as owned
         sta   V.LPRC,x
         lda   PD.PSC,y
         sta   V.PCHR,x initialize pause char
         ldd   PD.INT,y
         std   V.INTR,x
         ldd   <$38,y
         std   $0F,x
         lda   <$34,y
         beq   GetDev20
         sta   $06,x
GetDev20    clra
         puls  pc,x,a

SCALOC    ldx   D.Proc
         lda   P$ID,x get current process ID
         clr   PD.MIN,y
         ldx   PD.DEV,y
         bsr   GetDev
         bcs   SCAL90
         ldx   $0A,y
         beq   SCAL20
         bsr   GetDev
         bcs   SCAL90
SCAL20    tst   $0F,y
         bne   SCALOC
         clr  PD.RAW,y
SCAL90    ldu PD.RGS,y
         rts

 ttl Output Routines
 page
***************
* SCWrLine
*   Process Write Line Request

SCWrLine  bsr   SCALOC
         bra   SCWrit00

***************
* SCWrite
SCWrite    bsr   SCALOC
         inc   PD.RAW,y
SCWrit00    ldx   R$Y,u
         beq   L07F1
         pshs  x
         ldx   #0
         bra   L0788
SCWrit10    tfr   u,d
         tstb
         bne   L07BA
L0788    pshs  y,x
         ldd   ,s
         ldu   $06,y
         ldx   $04,u
         leax  d,x
         ldd   $06,u
         subd  ,s
         cmpd  #$0020
         bls   L079F
         ldd   #$0020
L079F    pshs  b,a
         ldd   $08,y
         inca
         subd  ,s
         tfr   d,u
         lda   #$0D
         sta   -1,u
         ldy   D.Proc
         lda   P$Task,y
         ldb   D.SysTsk
         puls  y
         os9   F$Move
         puls  y,x
L07BA    lda   ,u+
         tst   $0C,y
         bne   L07D4
         lbsr  UPCASE
         cmpa  #$0A
         bne   L07D4
         lda   #$0D
         tst   <$25,y
         bne   L07D4
         bsr   PutChr
         bcs   SCWrErr
         lda   #$0A
L07D4    bsr   PutChr
         bcs   SCWrErr
         leax  $01,x
         cmpx  ,s
         bcc   L07EB
         lda   -$01,u
         beq   SCWrit10
         cmpa  <$2B,y
         bne   SCWrit10
         tst   $0C,y
         bne   SCWrit10
L07EB    leas  $02,s
L07ED    ldu   $06,y
         stx   $06,u
L07F1    lbra  IODONE

SCWrErr    leas  $02,s
         pshs  b,cc
         bsr   L07ED
         puls  pc,b,cc
 page
***************
* PutChr
*   put character in output buffer

PutDv2    pshs  u,x,a
         ldx   PD.DV2,y
         beq   PutChr9

         tst   $0C,y
         bne   PutChr2

         cmpa  #$0D
         bne   PutChr2
         bra   L083B
PutChr    pshs  u,x,a
         ldx   $03,y
         tst   $0C,y
         bne   PutChr2
         cmpa  #$0D
         bne   PutChr2
         ldu   $02,x
         tst   V.PAUS,u
         bne   L0829
         tst   PD.PAU,y
         beq   L083B
         dec   V.LINE,u
         bne   L083B
         bra   L0833
L0829    lbsr  GetDv2
         bcs   L0833
         cmpa  PD.PSC,y
         bne   L0829
L0833    lbsr  GetDv2
         cmpa  PD.PSC,y
         beq   L0833
L083B    ldu   $02,x
         clr   $08,u
         lda   #$0D
         bsr   WrChar
**********
* tst PD.RAW,Y "cooked" mode?
* bne PutChr9 ..no; just return
**********

***************
* EOL . Process end of line functions
* Passed: (X)=Device Table ptr
*         (Y)= Path Descriptor
* returns: B,CC=error code (if error)
* Destroys: A

EOL      ldb   PD.NUL,y
         pshs  b
         tst   PD.ALF,y  Add linefeed?
         beq   EOL1
         lda   #$0A
L084F    bsr   WrChar
         bcs   L085A
EOL1    lda   #$00
         dec   ,s
         bpl   L084F
         clra
L085A    leas  1,s
PutChr9    puls  pc,u,x,a

PutChr2    bsr   WrChar
         puls  pc,u,x,a

WrChar    ldu   #D$WRIT

IOEXEC    pshs  u,y,x,a
         ldu   V$STAT,x
         clr   V.WAKE,u
         ldx   V$DRIV,x
         ldd   M$Exec,x
         addd  $05,s
         leax  d,x
         lda   ,s+
         jsr   0,x
         puls  pc,u,y,x

 emod
SCFEnd equ *
