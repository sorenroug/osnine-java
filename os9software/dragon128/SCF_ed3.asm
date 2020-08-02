 nam   SCF
 ttl   Sequential Character file manager

* This is a LEVEL 2 module
* Originally from Dragon 128

* Copyright 1982 by Microware Systems Corporation          *
* Reproduced Under License                                 *
*                                                          *
* This source code is the proprietary confidential prop-   *
* erty of Microware Systems Corporation, and is provided   *
* to the licensee solely for documentation and educational *
* purposes. Reproduction, publication, or distribution in  *
* any form to any party other than the licensee is         *
* is strictly prohibited!                               *

 use defsfile


         mod   SCFEnd,SCFName,FlMgr+Objct,REENT+1,SCF,0

SCFName   equ   *
         fcs   /SCF/
         fcb   3

SCF   equ   *
         lbra  SCCrea
         lbra  SCOpen
         lbra  SCOErr   makdir
         lbra  ChgDir
         lbra  Open90
         lbra  Open90
         lbra  SCRead
         lbra  SCWrite
         lbra  SCRdLine
         lbra  SCWrLine
         lbra  SCGStat
         lbra  SCPstat
         lbra  SCClose

EXTEND equ 1
MACROS equ 1
BuffSize equ $100
OutBfSiz equ 32
 ifne MACROS
MacBfSiz equ $100
 endc

* (Y) = Path descriptor pointer
* (U) = Caller's register stack pointer
SCOpen
SCCrea   ldx   PD.DEV,y
         stx   PD.TBL,y
         ldu   PD.RGS,y
         pshs  y
         ldx   R$X,u
         os9   F$PrsNam
         lbcs  SCOER1
         tsta
         bmi   Open0
         leax  ,y
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
         bcs   L00D8
         stu   PD.BUF,y

 ifeq CPUType-DRG128
         clr   BuffSize,u
         clr   >$0103,u
 endc
         clrb
         bsr   JAMMER

* cute message:
* "by K.Kaplan, L.Crane, R.Doggett"
         fcb   $62,$1B,$59,$6B,$65,$65,$2A,$11,$1C,$0D,$0F
         fcb   $42,$0C,$6C,$62,$6D,$31,$13,$0F,$0B,$49,$0C
         fcb   $72,$7C,$6A,$2B,$08,$00,$02,$11,$00,$79

* put cute message into our newly allocated PD buffer
JAMMER    puls  x
         clra
L0091    eora  ,x+
         sta   ,u+
         decb
         cmpa  #$0D
         bne   L0091
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
         bcs   L00D8
         stu   PD.DV2,y
Open90   clra
         rts

SCOER1    puls  pc,y

* ChgDir/SCOErr entry
ChgDir
SCOErr    comb
         ldb   #E$BPNam
L00D8    rts

SCClose     pshs  cc
         orcc  #$50
         ldx   PD.DEV,y
         bsr   DenyDev
         ldx   PD.FST,y
         bsr   DenyDev
         puls  cc
         tst   PD.CNT,y
         bne   Close.C
         ldu   PD.FST,y
         beq   L00F2
         os9   I$Detach
L00F2    ldu   PD.BUF,y
         beq   Close.C
         ldd   #$0200     Specific for DRG128
         os9   F$SRtMem
Close.C    clra
         rts

DenyDev    leax  ,x
         beq   Close.C
         ldx   V$STAT,x
         ldb   ,y
         lda   PD.CPR,y
         pshs  y,x,b,a
         cmpa  V.LPRC,x
         bne   L0147
         ldx   D.Proc
         leax  <$30,x
         clra
L0114    cmpb  a,x
         beq   L0147
         inca
         cmpa  #$10
         bcs   L0114
         pshs  y
         ldd   #$1B0C
         lbsr  SCGST1
         puls  y
         ldx   D.Proc
         lda   $01,x
         sta   ,s
         os9   F$GProcP
         leax  <$30,y
         ldb   $01,s
         clra
L0136    cmpb  a,x
         beq   L0141
         inca
         cmpa  #$10
         bcs   L0136
         clr   ,s
L0141    lda   ,s
         ldx   $02,s
         sta   $03,x
L0147    puls  pc,y,x,b,a

  ifeq CPUType-DRG128
* Set macro
SCInMax    lda   $06,u
         beq   L019A
         bsr   SCClrM
         ldb   $07,u
         beq   L019A
         ldx   PD.BUF,y
         leax  >$0200,x
         pshs  x
         leax  >-$00FD,x
L015F    lda   ,x+
         beq   L016C
         ldb   ,x+
         abx
         cmpx  ,s
         bcc   L019E
         bra   L015F
L016C    ldb   $07,u
         pshs  x
         abx
         leax  $01,x
         cmpx  $02,s
         bhi   L019C
         beq   L017B
         clr   ,x
L017B    puls  x
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
L019A    clrb
         rts
L019C    leas  $02,s
L019E    leas  $02,s
         comb
         ldb   #E$MemFul
         rts

* Clear macro
SCClrM    ldx   PD.BUF,y
         leax  >$0100,x
         lda   $06,u
         beq   L01F3
         leax  >$0100,x
         pshs  x
         leax  >-$00FD,x
L01B8    cmpa  ,x
         beq   L01C9
         tst   ,x+
         beq   L01EF
         ldb   ,x+
         abx
         cmpx  ,s
         bcs   L01B8
         bra   L01EF
L01C9    ldb   $01,x
         pshs  y
         tfr   x,y
         abx
         leax  $02,x
L01D2    cmpx  $02,s
         bcc   L01EB
         tst   ,x
         beq   L01EB
         lda   ,x+
         sta   ,y+
         ldb   ,x+
         stb   ,y+
L01E2    lda   ,x+
         sta   ,y+
         decb
         bne   L01E2
         bra   L01D2
L01EB    clr   ,y
         puls  y
L01EF    leas  $02,s
         clrb
         rts
L01F3    clr   $03,x
         rts
  endc

* Scan for macro codes
* If not found then set carry
SCFMac    ldx   PD.BUF,y
         leax  >$0200,x
         pshs  x
         leax  >-$00FD,x
L0202    tst   ,x+
         beq   L0211
         ldb   ,x+
         cmpa  -$02,x
         beq   L0212
         abx
         cmpx  ,s
         bcs   L0202
L0211    comb
L0212    leas  $02,s
         rts

* (Y) = Path descriptor pointer
* (U) = Caller's register stack pointer
SCGStat  ldx   PD.RGS,y
         lda   R$B,x
 ifeq CPUType-DRG128
         cmpa  #SS.Edit   $1C
         beq   SCEdit
 endc
         cmpa  #$00
         beq   SCRETN
         ldb   #D$GSTA

SCGST1    pshs  a
         clra
         ldx   PD.DEV,y
         ldu   V$STAT,x
         ldx   V$DRIV,x
         addd  M$Exec,x
         leax  d,x
         puls  a
         jmp   0,x    Call device driver

SCPstat  lbsr  SCALOC
         bsr   PutStat
         pshs  b,cc
         lbsr  IODONE
         puls  pc,b,cc

PutStat    lda   R$B,u
  ifeq CPUType-DRG128
         cmpa  #SS.SMac $1D
         lbeq  SCInMax
         cmpa  #SS.CMac  $1E
         lbeq  SCClrM
 endc
         ldb   #D$PSTA
         cmpa  #SS.Opt   $00
         bne   SCGST1
         pshs  y
         ldx   D.Proc
         lda   P$Task,x
         ldb   D.SysTsk
         ldx   $04,u
         leau  PD.OPT,y
         ldy   #$001C
         os9   F$Move
         puls  y
SCRETN    rts

  ifeq CPUType-DRG128
SCEdit    lbsr  SCALOC
         bcs   SCRETN
         ldx   $06,u
         lbeq  SCRead3
         tst   $06,u
         beq   L027D
         ldx   #$0100
L027D    pshs  y,x
         ldx   D.Proc
         lda   $06,x
         ldb   D.SysTsk
         ldx   $04,u
         ldu   PD.BUF,y
         ldy   ,s
         os9   F$Move
         puls  y,x
         tfr   u,d
         leax  d,x
         pshs  x
         lbsr  L0615
         ldu   $06,y
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

SCRead     lbsr  SCALOC
         bcs   SCRETN
         inc   $0C,y
         ldx   $06,u
         lbeq  L0351
         pshs  x
*ifne EXTEND here
         ldu   PD.BUF,y
         ldx   #$0000
*else
*endc

 ifeq CPUType-DRG128
* Start test for macros - lead-in
         pshs  x,a
         ldx   >$0101,u
         ldb   >$0100,u
         bne   SCRead5
         puls  x,a
* End test for macros
 endc

         lbsr  GetChr
         bcs   SCERR
         tsta
         beq   L0339
         cmpa  PD.EOF,y
         bne   SCRead15
L02F0    ldb   #E$EOF
SCERR    leas  $02,s
         pshs  b
         bsr   SCRead3
         comb
         puls  pc,b

L02FB    tfr   x,d
         tstb
         bne   L0305
         lbsr  RetData
         ldu   PD.BUF,y
L0305    lbsr  GetChr
         bcs   SCERR

SCRead15

 ifeq CPUType-DRG128
* Start test for macros
         pshs  x,a
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
* End test for macros
 endc
         tst   PD.EKO,y
         beq   L0339
         lbsr  PutDv2 Print character
L0339    leax  $01,x
         sta   ,u+
         beq   L0344
         cmpa  PD.EOR,y
         beq   L0348
L0344    cmpx  ,s
         bcs   L02FB
L0348    leas  $02,s
SCRead3    lbsr  RetData
         ldu   $06,y
         stx   $06,u
L0351    lbra  IODONE

 ifeq CPUType-DRG128
* Start test for macros
SCRead5    leas  $01,s
         pshs  x,b
L0358    ldx   $01,s
         lda   ,x+
         sta   ,u+
         stx   $01,s
         dec   ,s
         tst   PD.EKO,y
         beq   L036A
         lbsr  PutDv2 Print character
L036A    ldx   $03,s
         leax  $01,x
         stx   $03,s
         cmpx  $05,s
         bcc   L0387
         tfr   x,d
         tstb
         bne   L037E
         lbsr  RetData
         ldu   PD.BUF,y
L037E    tst   ,s
         bne   L0358
         leas  $05,s
         lbra  L0305
L0387    ldx   PD.BUF,y
         puls  b
         stb   >$0100,x
         puls  b,a
         std   >$0101,x
         puls  x
         bra   L0348
* End test for macros
 endc

* (Y) = Path descriptor pointer
* (U) = Caller's register stack pointer
SCRdLine   lbsr  SCALOC        Go wait for device to be ready
 ifne EXTEND
         lbcs  SCRETN
 else
 endc
         ldx   R$Y,u        Get character count
         beq   SCRead3
         tst   R$Y,u               Past 256 bytes?
         beq   SCRd10
         ldx   #$0100       Get new character count
 ifne EXTEND
SCRd10    tfr   x,d
         addd  PD.BUF,y
         pshs  b,a
 else
 endc
         lbsr  SCDEL9
 ifeq CPUType-DRG128
         clr   BuffSize,u   Buffer for lead-in match?
 endc
SCRd20    lbsr  GetChr
         lbcs  SCABT
         tsta
         beq   SCRd35
         ldb   #PD.BSP Test special characters
L03C4    cmpa  b,y
         beq   SCCTLC
         incb
         cmpb  #PD.QUT
         bls   L03C4

 ifeq CPUType-DRG128
* Start test for macros
         pshs  y
         bsr   SCGetDev
         bcs   SCRd27
         cmpa  <$1C,y
         bne   L03E6
         pshs  y
         ldy   $02,s
         lbsr  GetChr
         puls  y
         bcs   L0411
         ora   #$80
L03E6    ldb   #$32
         leay  <$20,y
L03EB    cmpa  ,y+
         beq   L0416
         incb
         cmpb  #$35
         bls   L03EB
SCRd27    puls  y
         lbra  SCChkMac
* End test for macros
 endc

SCRd35    leax  1,x
         cmpx  ,s
 ifne EXTEND
         leax  -1,x
 endc
         bcs   L0409
L0401    lda   PD.OVF,y
         lbsr  OUTCHR Print character
 ifeq EXTEND
 endc
         bra   SCRd20

L0409    lbsr  UPCASE
         lbsr  SCINS
         bra   SCRd20
 ifne EXTEND
L0411    puls  y
         lbra  SCABT

L0416    puls  y

 endc

SCCTLC    pshs  pc,x
         leax  >CTLTBL,pcr    Point to branch table
         subb  #$29
         pshs  a
         lslb
         ldd   b,x
         leax  d,x
         puls  a
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
         leay  <$12,y
         coma
         lda   ,s+     No-edit flag set?
         bne   L0448  ..yes
         clra    Clear carry
L0448    puls  pc,a
 endc

CTLTBL
 fdb SCBSP-CTLTBL        Process PD.BSP
 fdb SCDEL-CTLTBL        Process PD.DEL
 fdb SCEOL-CTLTBL        Process PD.EOR
 fdb SCEOF-CTLTBL        Process PD.EOF
 fdb SCPRNT-CTLTBL        Process PD.RPR
 fdb L0615-CTLTBL        Process PD.DUP
 fdb L04D7-CTLTBL        Process PD.PSC
 fdb SCDEL-CTLTBL   Process PD.INT
 fdb SCDEL-CTLTBL   Process PD.QUT
 fdb SCLFT-CTLTBL   $0110
 fdb SCRT-CTLTBL   $00F9
 fdb SCDLRT-CTLTBL   $0170
 fdb SCDELR-CTLTBL   $00A2



* Process PD.EOR character
SCEOL    leas  $02,s
         bsr   SCMKEL
         lbsr  CHKEKO
         ldu   $06,y
         bsr   SCGetLen
         leax  $01,x
         stx   $06,u
         lbsr  RetData
         leas  $02,s
         lbra  IODONE

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

* Process PD.EOF
SCEOF    leas  $02,s
         cmpx  PD.BUF,y
         lbne  SCRd35
         ldx   #$0000
         lbra  L02F0

SCABT    pshs  b
         bsr   SCMKEL
         lbsr  EKOCR
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
         beq   L04D8
         leas  $03,s
         lbra  EKOCR
L04D7    rts

L04D8    bsr   SCMLFT
         dec   ,s
         bne   L04D8
         lbsr  SCShLn
L04E1    bsr   SCSPACE
         dec   $01,s
         bne   L04E1
         leas  $02,s
         lbra  SCDLL2

SCDELR    clr   ,-s
         pshs  u,x
         leax  ,u
L04F2    cmpu  ,s
         beq   L04FF
         leau  $01,u
         bsr   SCSPACE
         inc   $04,s
         bra   L04F2

L04FF    puls  u,b,a
         tst   ,s
         lbne  SCDLL2
         puls  pc,b

SCSPACE    lda   #$20
         lbra  CHKEKO

SCMLFT    pshs  y
         lbsr  SCGetDev
         bcs   L0519
         ldb   #$1E
         bra   L0527

L0519    puls  y
         lbra  L058D

SCMRT    pshs  y
         ldb   #$1F
         lbsr  SCGetDev
         bcs   L0541
L0527    pshs  x
         leax  ,y
         ldy   $02,s
         lda   b,x
         bpl   L053F
         anda  #$7F
         pshs  a
         lda   <$1D,x
         beq   L053D
         bsr   OUTCHR Print lead-out character
L053D    puls  a
L053F    bsr   OUTCHR Print character
L0541    puls  pc,y,x

SCRT    bsr   SCChkE
         bcc   L054E
         bsr   SCMRT
         bcs   L054D
         leau  $01,u
L054D    rts

L054E    tfr   u,d
         subd  $08,y
         beq   L054D
         pshs  b
         ldu   $08,y
         bra   SCDLL2

SCLFT    cmpu  $08,y
         beq   L0566
         bsr   SCMLFT
         bcs   L0565
         leau  -$01,u
L0565    rts

L0566    bsr   SCChkE
         beq   L0570
         leau  $01,u
         bsr   SCMRT
         bcc   L0566
L0570    rts

SCDEL9    ldx   PD.BUF,y
         tfr   x,u
         rts

* Process PD.BSP 
SCBSP    cmpu  PD.BUF,y  Empty buffer?
         beq   L0570 ..yes
         bsr   SCChkE
         bne   SCDLLF
         leau  -1,u
         leax  -1,x
         tst   PD.BSO,y
         beq   L058D
         bsr   L058D   Print backspace char
         lbsr  SCSPACE   Print space
L058D    lda   PD.BSE,y

OUTCHR    lbra  EKOBYT Print character

SCChkE    lbra  SCChkEol

SCDLLF    lbsr  SCMLFT
         leau  -1,u
SCDL    pshs  u
L059D    lda   1,u
         sta   ,u+
         bsr   SCChkE
         bcs   L059D
         puls  u
         leax  -1,x
         bsr   SCShLn
L05AB    incb
         pshs  b
         lbsr  SCSPACE
SCDLL2    lbsr  SCMLFT
         dec   ,s
         bne   SCDLL2
         puls  pc,a

SCDLRT    bsr   SCChkE
         bcc   L05C9
         leax  -$01,x
         clrb
         bsr   SCChkE
         bcc   L05AB
         leax  $01,x
         bra   SCDL
L05C9    rts

SCShLn    clrb
         pshs  u,b
L05CD    bsr   SCChkE
         bcc   L05DE
         lda   ,u+
         cmpa  #$0D Stop at carriage return
         beq   L05DE
         lbsr  CHKEKO
         inc   ,s
         bra   L05CD
L05DE    puls  pc,u,b

SCINS    bsr   SCChkE
         bcs   L05EB
         sta   ,u+
         leax  $01,x
         lbra  CHKEKO
L05EB    pshs  u
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
         decb
         pshs  b
         bra   SCDLL2

EKOCR    lda   #$0D
         lbra  EKOBYT Print character

SCPRNT    lbsr  SCMKEL
         lbsr  SCDEL9
         lbsr  EKOCHR
L0615    ldx   $02,s
         bsr   SCShLn
         clra
         pshs  u
         addd  ,s++
         tfr   d,x
         leau  ,x
         rts

 ifeq CPUType-DRG128
* Start test for macros
SCChkMac    pshs  x,a
         lbsr  SCFMac
         bcc   SCRd80
         puls  x,a
         lbra  SCRd35
* End test for macros
 endc

SCRd80    leas  $01,s
         pshs  x,b
         ldx   $03,s
         abx
         cmpx  $05,s
         bcs   L0641
         leas  $03,s
         puls  x
         lbra  L0401
L0641    pshs  u
         cmpu  $05,s
         bcc   SCRd95
         ldu   $05,s
         tfr   u,d
         subd  ,s
L064E    lda   ,-u
         sta   ,-x
         decb
         bne   L064E
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
         bsr   L067B
L0674    ldu   $03,s
         leas  $07,s
         lbra  SCRd20
L067B    pshs  b
         lbra  SCDLL2

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

* Check for forced uppercase
UPCASE    tst   PD.UPC,y
         beq   L06B8
         cmpa  #'a
         bcs   L06B8
         cmpa  #'z
         bhi   L06B8
         suba  #$20
L06B8    rts

* Check for printable character
CHKEKO    tst   PD.EKO,y       Echo turned on?
         beq   L06B8
EKOCHR    cmpa  #$7F
         bcc   L06CD
         cmpa  #$20
         bcc   EKOBYT Print character
         cmpa  #$0D
         bne   L06CD
EKOBYT    lbra  PutDv2 Print character

* Non-printable character
L06CD    pshs  a              Save code
         lda   #'.
         bsr   EKOBYT Print character
         puls  pc,a

RetData    pshs  y,x
         ldd   ,s
         beq   L06FB
         tstb
         bne   L06DF
         deca
L06DF    clrb
         ldu   $06,y
         ldu   $04,u
         leau  d,u
         clra
         ldb   $01,s
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

IODONE    ldx  D.Proc
         lda   P$ID,x
         ldx   $03,y
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
         beq   L0750
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

GetDev10    lda   ,s
         sta   $04,x
         sta   $03,x
         lda   <$2F,y
         sta   $0D,x
         ldd   <$30,y
         std   $0B,x
         ldd   <$38,y
         std   $0F,x
         lda   <$34,y
         beq   L0750
         sta   $06,x
L0750    clra
         puls  pc,x,a

* Wait for device ?
SCALOC    ldx   D.Proc Get current process ID
         lda   P$ID,x         Get process ID #
         clr   $0F,y
         ldx   $03,y
         bsr   GetDev
         bcs   L076D
         ldx   $0A,y
         beq   L0767
         bsr   GetDev
         bcs   L076D
L0767    tst   $0F,y
         bne   SCALOC
         clr   $0C,y
L076D    ldu   $06,y
         rts

SCWrLine  bsr   SCALOC
         bra   SCWrit10

SCWrite    bsr   SCALOC
         inc   $0C,y
SCWrit10    ldx   $06,u
         beq   L07F1
         pshs  x
         ldx   #$0000
         bra   L0788
L0783    tfr   u,d
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
         beq   L0783
         cmpa  <$2B,y
         bne   L0783
         tst   $0C,y
         bne   L0783
L07EB    leas  $02,s
L07ED    ldu   $06,y
         stx   $06,u
L07F1    lbra  IODONE

SCWrErr    leas  $02,s
         pshs  b,cc
         bsr   L07ED
         puls  pc,b,cc

* Print character
PutDv2    pshs  u,x,a
         ldx   $0A,y
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
