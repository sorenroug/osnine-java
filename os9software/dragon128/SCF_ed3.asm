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
*  2 83/03/16 Now uses one 256-byte buffer instead of two.  RFD
*  2 83/03/16 Made PutStat allocate device(s).              RFD
*  2 83/03/17 Removed high-order bit stripping.             RFD
*  2 83/03/17 Line Feeds no longer print as CR LF.          RFD
*  2 83/03/17 Sends SS.Relea to driver when process dies.   RFD
*  3 83/11/01 Extended editing facilities and SS.Edit
*            Getstt call added. Vivaway Ltd.                PSD
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

SCF lbra SCCrea create
 lbra SCOpen Open
 lbra SCOErr makdir
 lbra SCOErr chgdir
 lbra Open90 delete
 lbra Open90 seek
 lbra SCRead read
 lbra SCWrite write
 lbra SCRdLine read line
 lbra SCWrLine write line
 lbra SCGStat get status
 lbra SCPstat set status
 lbra SCClose close

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
SCOpen ldx PD.DEV,y copy Device Table Ptr
 stx   PD.TBL,y for user GetSts availability
 ldu   PD.RGS,y get caller's register stack
 pshs  y save PD ptr
 ldx   R$X,u get pathname ptr
 os9   F$PrsNam parse device name
 lbcs  SCOER1 ..error; bad name
 tsta High order bit set?
 bmi   Open0 ..Yes; end of name
 leax  0,y
 os9   F$PrsNam check for more name
 bcc   SCOER1 ..error if so
Open0 sty   R$X,u save updated name ptr
 puls y retrieve PD ptr
 ifne MACROS
 ldd #BuffSize+MacBfSiz get buffer size
 else
 ldd #BuffSize
 endc
 os9 F$SRqMem allocate buffers
 bcs OPNER9 ..error; return it
 stu PD.BUF,y save buffer ptr
 ifne MACROS
 clr BuffSize,u show macro buffer empty
 clr BuffSize+3,u show no macros installed
 endc
 clrb

***************
* This code may be optimized by "lda #C$CR"
* In severe cases when memory is expensive
 bsr JAMMER
* "by K.Kaplan, L.Crane, R.Doggett"
 fcb $62,$1B,$59
 fcb $6B,$65,$65,$2A,$11,$1C,$0D,$0F
 fcb $42,$0C
 fcb $6C,$62,$6D,$31,$13,$0F,$0B
 fcb $49,$0C
 fcb $72,$7C,$6A,$2B,$08,$00,$02,$11,$00
 fcb $79

JAMMER puls x
 clra
JAMM10 eora ,x+
 sta ,u+
 decb
 cmpa  #C$CR
 bne   JAMM10
* end of optimizable code
***************

Open1 sta ,u+ clear out buffer
 decb
 bne Open1
 ldu PD.DEV,y
 beq SCOErr ..exit if no physical device
 ldx V$STAT,u
 lda PD.PAG,y reset lines-left count
 sta V.LINE,x
 ldx V$DESC,u now open echo/pause path
 ldd PD.D2P,y
 beq Open90
 leax d,x get offset of secondary pathname
 lda PD.MOD,y
 lsra reverse read & write modes
 rorb
 lsra
 rolb
 rola
 rorb
 rola
 pshs y save Path ptr
 ldy D.Proc
 ldu D.SysPrc
 stu D.Proc temp switch to System process
 os9 I$Attach attach auxilary device
 sty D.Proc switch back to User process
 puls y restore Path ptr
 bcs OPNER9 ..exit if error
 stu PD.DV2,y save echo/pause device
Open90 clra return carry clear
 rts

SCOER1 puls pc,y error; return it

SCOErr comb return carry set
 ldb #E$BPNam error - bad path name
OPNER9 rts

SCClose pshs cc save interrupt masks
 orcc #IntMasks set interrupt masks
 ldx   PD.DEV,y get device table ptr
 bsr   DenyDev disassociate device signals
 ldx   PD.DV2,y get attached device
 bsr   DenyDev disassociate it too
 puls  cc retrieve interrupt masks
 tst   PD.CNT,y Last Image?
 bne   Close.C ..No; exit
 ldu   PD.DV2,y get echo/pause device
 beq   Close.B branch if none
 os9   I$Detach detach echo/pause device
Close.B ldu PD.BUF,y get buffer address
 beq   Close.C ..no buffer to return
 ifne MACROS
 ldd #BuffSize+MacBfSiz get buffer size
 else
 ldd #BuffSize
 endc
 os9 F$SRtMem return buffers to system store
Close.C clra
 rts

***************
* Subroutine DenyDev
*   Eliminate ownership of device for this Process
* Passed: (X)=device tbl ptr of entry to deny

DenyDev leax  0,x device in use?
 beq Close.C ..No; exit
 ldx V$STAT,x get static storage ptr
 ldb PD.PD,y get this path number
 lda   PD.CPR,y current Process ID
 pshs  y,x,b,a
 cmpa  V.LPRC,x is this last process?
 bne   Deny.Z exit if not
 ldx   D.Proc process ptr
 leax  P$Path,x ptr to path table
 clra start with path #0
Deny.A cmpb  a,x will this path still be open?
 beq   Deny.Z ..Yes; retain control
 inca
 cmpa  #NumPaths all paths checked?
 bcs   Deny.A ..no; repeat
 pshs  y save PD ptr
 ldd   #SS.Relea*256+D$PSTA
 lbsr  SCGST1 send Release putstat to driver
 puls  y

 ldx   D.Proc
 lda   P$PID,x parent's ID
 sta   0,s Try to stick parent with device
 os9   F$GProcP (Y)=parent's Process ptr
 leax  P$Path,y parent's path tbl
 ldb  1,s restore path number
 clra
Deny.B cmpb a,x Parent still own path?
 beq Deny.C Yes; return control to parent
 inca
 cmpa #NumPaths
 bcs Deny.B repeat until all paths checked
 clr 0,s Nobody responsible for abort signals
Deny.C lda 0,s responsible party
 ldx 2,s Static storage ptr
 sta V.LPRC,x
Deny.Z puls  pc,y,x,b,a

***************
 ifne MACROS

********************
* Install a macro
*
SCInMac lda R$Y,u get keycode
 beq SCInMac6 ..none; no action
 bsr SCClrM clear the macro if it exists
 ldb R$Y+1,u get length
 beq SCInMac6 ..none; exit
 ldx PD.BUF,y get a buffer ptr
 leax BuffSize+MacBfSiz,x point at end of macro buffer
 pshs x save it
 leax -MacBfSiz+3,x point at macro buffer
SCInMac1 lda ,x+ get code
 beq SCInMac2 skip if empty
 ldb ,x+ get byte count
 abx skip this entry
 cmpx ,s any more room?
 bcc   SCInMac3 ..no; error - no room
 bra   SCInMac1 ..try next

SCInMac2 ldb R$Y+1,u get byte count
 pshs  x save ptr
 abx add in byte count
 leax 1,x plus room for byte count
 cmpx 2,s enough room?
 bhi SCInMac4 ..no
 beq SCInMac5 exactly fills it
 clr ,x clear next entry
SCInMac5 puls x retrieve ptr
 stb ,x+ set byte count
 clra
 pshs  y,b,a stack byte count and PD ptr
 lda   R$Y,u get key code
 sta   -2,x set it
 ldy   D.Proc get process ptr
 lda   P$Task,y get source task
 ldb   D.SysTsk get destination task (system)
 ldu   R$X,u get source ptr
 exg   x,u swap ptrs
 puls  y get byte count
 os9   F$Move copy the macro
 puls  y retrieve PD Ptr
 leas  2,s return scratch
SCInMac6 clrb no error
 rts

SCInMac4 leas 2,s ditch scratch
SCInMac3 leas 2,s ditch scratch
 comb error -
 ldb #E$MemFul no room
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

********************
* Find a macro
*
SCFMac    ldx   PD.BUF,y
         leax  BuffSize+MacBfSiz,x
         pshs  x
         leax  -MacBfSiz+3,x
SCFMac1    tst   ,x+
         beq   SCFMac3
         ldb   ,x+
         cmpa  -$02,x
         beq   SCFMac2
         abx
         cmpx  ,s
         bcs   SCFMac1
SCFMac3    comb
SCFMac2    leas  $02,s
         rts
 endc

* (Y) = Path descriptor pointer
* (U) = Caller's register stack pointer
SCGStat ldx PD.RGS,y
 lda R$B,x
 ifne EXTEND
 cmpa #SS.Edit
 beq SCEdit
 endc
 cmpa #SS.OPT copy options stat?
 beq SCRETN ..yes; return OK
 ldb #D$GSTA

SCGST1 pshs  a
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

PutStat lda R$B,u get status code
 ifne MACROS
 cmpa #SS.SMac set macro?
 lbeq SCInMac ..yes
 cmpa #SS.CMac clear macro?
 lbeq SCClrM ..yes
 endc
 ldb   #D$PSTA
 cmpa  #SS.Opt set options?
 bne   SCGST1 ..No; pass status call to driver
 pshs  y
 ldx   D.Proc
 lda   P$Task,x
 ldb   D.SysTsk
 ldx   R$X,u
 leau  PD.OPT,y
 ldy   #OptCnt
 os9   F$Move
 puls  y
SCRETN rts

 ttl Input Routines
 page
 ifne EXTEND
***************
* Scedit
*   Process Edit Line Request
*
* Passed: (Y)=File Descriptor Static Storage
*   User regs: (X)=Pointer to buffer
*              (Y)=Max byte count
*              (U)=Start cursor position
SCEdit lbsr SCALOC Allocate device(s)
 bcs   SCRETN exit if not allocated

 ldx   R$Y,u get byte count
 lbeq  SCRead3 ..zero; return (gained ownership)
 tst   R$Y,u byte count > 255?
 beq   SCEdit10 ..no
 ldx   #256 max 256

SCEdit10 pshs  y,x
 ldx   D.Proc
 lda   P$Task,x
 ldb   D.SysTsk
 ldx   R$X,u
 ldu   PD.BUF,y
 ldy   ,s
 os9   F$Move
 puls  y,x
 tfr   u,d
 leax  d,x
 pshs  x
 lbsr  SCRPET
 ldu   PD.RGS,y
 lda   R$U+1,u
 pshs  b
 cmpa  ,s+
 bcs SCEdit12
 tfr   b,a
SCEdit12 pshs  a
 subb  ,s+
 pshs  b
 tfr   a,b
 clra
 addd  PD.BUF,y
 tfr   d,u
 ldb   ,s+
 beq   SCEDIT15
 bsr   SCEdit20
SCEDIT15 lbra  SCRd20

SCEdit20 pshs  b
 lbra  SCDLL2

 endc
***************
* SCRead
*   Process Read Request
*
* Passed: (Y)=File Descriptor Static Storage

SCRead lbsr SCALOC allocate devices
         bcs   SCRETN
         inc   PD.RAW,y
         ldx   R$Y,u
         lbeq  SCRead4
         pshs  x
 ifne EXTEND
 ldu PD.BUF,y reset buffer ptr
 ldx #0 and byte count
 else
 jmp NOWHERE
 endc
 ifne MACROS
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
 ifne MACROS
SCRead15 pshs  x,a
         pshs  y
         lbsr  SCGetDev
         bcs   SCRead8
         cmpa  PD.LdIn-PD.OPT,y
         bne   SCRead8
         ldy   ,s
         lbsr  GetChr
         ora   #$80
         bcc   SCRead8
         leas  5,s
         bra   SCERR
SCRead8    puls  y
         sta   ,s
         lbsr  SCFMac
         bcc   SCRead5
         puls  x,a
 tst PD.EKO,y echo on?
 else
SCRead15 pshs x,a
 tst PD.EKO,y echo on?
 endc
         beq   SCRead2
         lbsr  PutDv2 Print character
SCRead2  leax  1,x
         sta   ,u+
         beq   SCRead22
         cmpa  PD.EOR,y
         beq   SCRead25
SCRead22    cmpx  ,s
         bcs   SCRead1
SCRead25    leas 2,s
SCRead3    lbsr  RetData
         ldu   PD.RGS,y
         stx   R$Y,u
SCRead4    lbra  IODONE
 ifne MACROS

SCRead5 leas 1,s
         pshs  x,b
SCRead6    ldx  1,s
         lda   ,x+
         sta   ,u+
         stx  1,s
         dec   ,s
         tst   PD.EKO,y
         beq   SCRead62
         lbsr  PutDv2 Print character
SCRead62    ldx 3,s
         leax 1,x
         stx  3,s
         cmpx 5,s
         bcc   SCRead7
         tfr   x,d
         tstb
         bne   SCRead65
         lbsr  RetData
         ldu   PD.BUF,y
SCRead65    tst   ,s
         bne   SCRead6
         leas  5,s
         lbra  SCRead12
SCRead7    ldx   PD.BUF,y
         puls  b
         stb   BuffSize,x
         puls  b,a
         std   BuffSize+1,x
         puls  x
         bra   SCRead25
 endc
 page
***************
* SCRdLine
*   Buffer a line from the Input device
*   using line-editing functions

* Passed: (Y)=File Descriptor address
*         (U)=Caller's register stack

SCRdLine lbsr SCALOC Allocate device(s)
 ifne EXTEND
 lbcs SCRETN ..exit if not allocated
 else
 endc

SCRd05 ldx   R$Y,u Get byte count
 beq   SCRead3 ..zero; return (gained ownership)
 tst   R$Y,u Byte count above 255?
 beq   SCRd10 ..no
 ldx   #256 Maximum of 256 permitted
 ifne EXTEND
SCRd10 tfr x,d
 addd PD.BUF,y
 pshs b,a
 else
 endc
 lbsr  SCDEL9
 ifne MACROS
 clr BuffSize,u cancel any current macro
 endc
SCRd20 lbsr GetChr Input one char
 lbcs SCABT ..i/o tremors, abort
* anda #$7F was used to strip high bit
 tsta null?
 beq SCRd30 Ignore control char checking if null
 ldb #PD.BSP
SCRd25 cmpa  b,y control character?
 beq   SCCTLC
 incb
 cmpb #PD.QUT
 bls SCRd25
 ifne EXTEND

 pshs  y
 bsr   SCGetDev
 bcs   SCRd27

 cmpa  PD.LdIn-PD.OPT,Y lead-in code?
 bne   SCRd60
 pshs  y
 ldy   $02,s
 lbsr  GetChr
 puls  y
 bcs   SCRd90
 ora   #$80
SCRd60 ldb #PD.QUT+1
 leay  PD.Left-PD.OPT,y
SCRd65    cmpa  ,y+
 beq   SCRd70
 incb
 cmpb  #PD.QUT+PD.DEol-PD.Left+1 more?
 bls   SCRd65
SCRd27    puls  y
 else
 endc
 ifne MACROS
 lbra SCChkMac
 endc
 ifne MACROS+EXTEND
SCRd30
 endc
SCRd35 leax 1,x
 cmpx 0,s
 ifne EXTEND
 leax -1,x
 endc
 blo SCRd40
SCRd37    lda   PD.OVF,y
 lbsr OUTCHR
 ifeq EXTEND
 endc
 bra   SCRd20
SCRd40    lbsr  UPCASE
 ifne EXTEND
 lbsr  SCINS
 else
 endc
SCRd50 bra SCRd20 Go get more
 ifne EXTEND

SCRd90 puls y
 lbra SCABT

SCRd70 puls y

 endc

SCCTLC pshs pc,x save regs
 leax  CTLTBL,pcr get dispatch table
 subb  #PD.BSP
 ifne EXTEND
 pshs  a
 lslb
 ldd   b,x
 leax  d,x
 puls  a
 else
 endc
 stx   2,s
 puls  x
 jsr [,s++] call routine
 ifne EXTEND
 lbra SCRd20
 else
 endc
 ifne EXTEND
* Process "Edit" character
* Sets Y
SCGetDev pshs a save A
 lda PD.Edit,y
 pshs  a
 ldy   PD.DEV,y
 ldy   V$DESC,y
 leay  M$DTyp,y
 coma
 lda ,s+ editing functions available
 bne SCGetD1 ..no
 clra clear carry
SCGetD1 puls  pc,a
 endc

**********
* Path control char Dispatch Table
CTLTBL
 ifne EXTEND
 fdb SCBSP-CTLTBL        Process PD.BSP
 fdb SCDEL-CTLTBL        Process PD.DEL
 fdb SCEOL-CTLTBL        Process PD.EOR
 fdb SCEOF-CTLTBL        Process PD.EOF
 fdb SCPRNT-CTLTBL        Process PD.RPR
 fdb SCRPET-CTLTBL Pd.dup
 fdb SCDEL4-CTLTBL Pd.psc (ignore)
 fdb SCDEL-CTLTBL Pd.int
 fdb SCDEL-CTLTBL Pd.qut
 fdb SCLFT-CTLTBL Pd.left
 fdb SCRT-CTLTBL Pd.right
 fdb SCDLRT-CTLTBL Pd.delch
 fdb SCDELR-CTLTBL Pd.deol

 else
 endc

* Process PD.EOR character
SCEOL leas 2,s
 ifne EXTEND
 bsr SCMKEL
 else
 endc
 lbsr  CHKEKO
 ldu   PD.RGS,y
 ifne EXTEND
 bsr SCGetLen
 endc
 leax 1,x
 stx R$Y,u
 lbsr RetData
 leas 2,s
 lbra IODONE

 ifne EXTEND
SCGetLen    exg   x,d
         subd  PD.BUF,y
         exg   d,x
         rts

SCMKEL    lda   #C$CR
         sta   ,x
         rts

SCChkEol    pshs  x
         cmpu  ,s
         puls  pc,x
 endc

SCEOF    leas 2,s
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

 ifne EXTEND
* Delete line left
SCDEL    tfr   u,d
         subd  PD.BUF,y
         beq   SCDEL4
         pshs  b
         pshs  b
         pshs  b
         pshs  y
         ldy   PD.BUF,y
         bsr   SCChkEol
         bcc   SCDEL5
SCDEL1    lda   ,u+
         sta   ,y+
         inc   $04,s
         bsr   SCChkEol
         bcs   SCDEL1
SCDEL5    leax  ,y
         puls  y
         ldu   PD.BUF,y
         tst   PD.DLO,y
         beq   SCDEL2
         leas  $03,s
         lbra  EKOCR
SCDEL4    rts

SCDEL2    bsr   SCMLFT
         dec   ,s
         bne   SCDEL2
         lbsr  SCShLn
SCDEL3    bsr   SCSPACE
         dec  1,s
         bne   SCDEL3
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
         ldb   #PD.Mlft-PD.OPT
         bra   SCOutX10 send it

SCMLFT20    puls  y retrieve PD ptr
         lbra  SCBSP2 use backspace echo chr

SCMRT    pshs  y save path descriptor ptr.
         ldb   #PD.MRt-PD.OPT offset to 'move right' code
SCOutX lbsr  SCGetDev point into device descriptor
 bcs SCMRT30
SCOutX10    pshs  x
         leax  ,y point at codes with X
         ldy   2,s retrieve PD ptr
         lda   b,x get code
         bpl   SCMRT20
         anda  #$7F clear high bit
         pshs  a save code
         lda   PD.LdOut-PD.OPT,X get lead-in chr
         beq   SCMRT10 skip if none
         bsr   OUTCHR Print lead-out character
SCMRT10    puls  a
SCMRT20    bsr   OUTCHR Print character
SCMRT30    puls  pc,y,x

SCRT    bsr   SCChkE at end of line?
         bcc   SCRT20
         bsr   SCMRT
         bcs   SCRT10
         leau  1,u bump the cursor
SCRT10    rts

SCRT20 tfr u,d calculate chrs to move back..
         subd  PD.BUF,y
         beq   SCRT10
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

 else
 endc
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

 ifne MACROS
* Check character against macro table
SCChkMac    pshs  x,a
         lbsr  SCFMac
         bcc   SCRd80
         puls  x,a
         lbra  SCRd35
SCRd80    leas 1,s
         pshs  x,b
         ldx   $03,s
         abx
         cmpx  $05,s
         bcs   SCRd87
         leas  $03,s
         puls  x
         lbra  SCRd37
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
 endc

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
         bne   SCWrit40
L0788    pshs  y,x
         ldd   ,s
         ldu   $06,y
         ldx   $04,u
         leax  d,x
         ldd   $06,u
         subd  ,s
         cmpd  #OutBfSiz
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
SCWrit40    lda   ,u+
         tst  PD.RAW,y
         bne   SCWrit50
         lbsr  UPCASE
         cmpa  #$0A
         bne   SCWrit50
         lda   #$0D
         tst   <$25,y
         bne   SCWrit50
         bsr   PutChr
         bcs   SCWrErr
         lda   #$0A
SCWrit50    bsr   PutChr
         bcs   SCWrErr
         leax  $01,x
         cmpx  ,s
         bcc   L07EB
         lda   -$01,u
         beq   SCWrit10
         cmpa  PD.EOR,y
         bne   SCWrit10
         tst   PD.RAW,y
         bne   SCWrit10
L07EB    leas  $02,s
L07ED    ldu   PD.RGS,y
         stx   R$Y,u
L07F1    lbra  IODONE

SCWrErr    leas 2,s
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
