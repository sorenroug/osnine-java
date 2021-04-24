         nam   SCF
         ttl   os9 file manager

* This is a LEVEL 2 module

 use defsfile

tylg     set   FlMgr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   SCFEnd,SCFNam,tylg,atrv,SCFEnt,0

SCFNam     equ   *
         fcs   /SCF/
         fcb   5

SCFEnt    equ   *
         lbra  SCCrea
         lbra  SCOpen
         lbra  SCOErr
         lbra  SCOErr
         lbra  Open90
         lbra  Open90
         lbra  SCRead
         lbra  SCWrite
         lbra  SCRdLine
         lbra  SCWrLine
         lbra  SCGStat
         lbra  SCPstat
         lbra  SCClose

BuffSize equ $100 path buffer size
OutBfSiz equ 32 maximum size of output "buffer"

 ttl Open/Close/GetStat etc.
 page
***************
* SCCrea & SCOpen
*   Process Create/Open Request

* Passed: (Y) = Path Descriptor ptr

SCCrea equ *
SCOpen ldx PD.DEV,y copy Device Table Ptr
 stx PD.TBL,y for user GetSts availability
 ldu PD.RGS,y get caller's register stack
 pshs y save PD ptr
 ldx R$X,u get pathname ptr
 os9 F$PrsNam parse device name
 lbcs SCOER1 ..error; bad name
 tsta High order bit set?
 bmi Open0 ..Yes; end of name
 leax 0,y
 os9 F$PrsNam check for more name
 bcc SCOER1 ..error if so
Open0 sty   R$X,u save updated name ptr
 puls y retrieve PD ptr
 ldd #BuffSize
 os9 F$SRqMem allocate buffers
 bcs OPNER9 ..error; return it
 stu PD.BUF,y save buffer ptr
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

JAMMER    puls  x
         clra
JAMM10    eora  ,x+
         sta   ,u+
         decb
         cmpa  #$0D
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
 ldx PD.DEV,y get device table ptr
 bsr DenyDev disassociate device signals
 ldx PD.DV2,y get attached device
 bsr DenyDev disassociate it too
 puls cc retrieve interrupt masks
 tst PD.CNT,y Last Image?
 bne Close.C ..No; exit
 ldu PD.DV2,y get echo/pause device
 beq Close.B branch if none
 os9 I$Detach detach echo/pause device
Close.B ldu PD.BUF,y get buffer address
 beq Close.C ..no buffer to return
 ldd #BuffSize
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
 lda PD.CPR,y current Process ID
 pshs y,x,b,a
 cmpa V.LPRC,x is this last process?
 bne Deny.Z exit if not
 ldx D.Proc process ptr
 leax P$Path,x ptr to path table
 clra start with path #0
Deny.A cmpb  a,x will this path still be open?
 beq Deny.Z ..Yes; retain control
 inca
 cmpa #NumPaths all paths checked?
 bcs Deny.A ..no; repeat
 pshs y save PD ptr
 ldd #SS.Relea*256+D$PSTA
 bsr SCGST1 send Release putstat to driver
 puls y

 ldx D.Proc
 lda P$PID,x parent's ID
 sta 0,s Try to stick parent with device
 os9 F$GProcP (Y)=parent's Process ptr
 leax P$Path,y parent's path tbl
 ldb 1,s restore path number
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
Deny.Z puls pc,y,x,b,a

SCGStat ldx PD.RGS,y
 lda R$B,x get status code
 cmpa #SS.OPT copy options stat?
 beq SCRETN ..yes; return OK
* Special for FM-11
         cmpa  #$25
         beq   L018E
*
         ldb   #D$GSTA $09

SCGST1 pshs A save function code
 clra extend entry offset to two bytes
 ldx PD.DEV,y dev tbl ptr
 ldu V$STAT,x static storage for driver
 ldx V$DRIV,x
 addd M$Exec,x driver's lbra table
 leax D,X
 puls a restore status function code
 jmp 0,x into the hands of a friendly driver

SCPstat lbsr SCALOC allocate device(s)
 bsr PutStat
 pshs b,cc save error status
 lbsr IODONE
 puls pc,b,cc

PutStat lda R$B,u get status code
 ldb #D$PSTA
         cmpa  #$25
         beq   L01BC
 cmpa #SS.Opt set options?
 bne SCGST1 ..No; pass status call to driver
 pshs y save PD ptr
 ldx D.Proc get process ptr
 lda P$Task,x get process task
 ldb D.SysTsk get system task
 ldx R$X,u get user's option bytes
 leau PD.OPT,y get options ptr
 ldy #OptCnt get byte count
 os9 F$Move copy options
 puls y retrieve PD ptr
SCRETN rts

L018E    ldb   $07,u
         beq   L01B7
         clra
         pshs  b,a
         ldy   $03,y
         ldy   $02,y
         lda   <$11,y
         sta   $01,u
         beq   L01B5
         ldx   D.Proc
         ldb   $06,x
         lda   <D.SysTsk
         ldx   <$12,y
         leax  $05,x
         ldu   $04,u
         ldy   ,s
         os9   F$Move
L01B5    leas  $02,s
L01B7    rts

L01B8    fcs  "KSys"

L01BC lda   $09,u
         pshs  u,y,a
         ldx   $03,y
         ldy   $02,x
         tsta
         beq   L0225
         tst   <$11,y
         bne   L0207
         ldd   #$0100
         os9   F$SRqMem
         bcs   L0223
         stu   <$12,y
         pshs  u
         clrb
L01DB    clr   ,u+
         decb
         bne   L01DB
         puls  u
         leax  >GetChr,pcr
         stx   ,u
         leax  >PutDv2,pcr
         stx   $02,u
         ldx   D.Proc
         pshs  y,x
         ldx   D.SysPrc
         stx   D.Proc
         leax  <L01B8,pcr
         lda   #$C1
         os9   F$Link
         puls  y,x
         stx   D.Proc
         bcs   L0223
         stu   <$14,y
L0207    lda   ,s
         sta   <$11,y
         ldx   D.Proc
         lda   $06,x
         ldb   <D.SysTsk
         ldu   <$12,y
         leau  $05,u
         ldx   $03,s
         ldy   $06,x
         beq   L0223
         ldx   $04,x
         os9   F$Move
L0223    puls  pc,u,y,a

L0225    lda   <$11,y
         beq   L025A
         ldu   D.Proc
         pshs  u
         ldu   D.SysPrc
         stu   D.Proc
         tsta
         bpl   L023D
         ldx   <$12,y
         lda   $04,x
         os9   I$Close
L023D    ldu   <$14,y
         beq   L0245
         os9   F$UnLink
L0245    puls  u
         stu   D.Proc
         ldu   <$12,y
         ldd   #$0100
         os9   F$SRtMem
         clra
         clrb
         std   <$14,y
         clr   <$11,y
L025A    puls  pc,u,y,a

***************
* SCRead
*   Process Read Request
*
* Passed: (Y)=File Descriptor Static Storage

SCRead    lbsr  SCALOC
         bcs   L02B6
 inc PD.RAW,y read mode (don't cook CR)
 ldx R$Y,u called with zero byte count?
 beq SCRead4 ..yes; exit (gained ownership)
 pshs X save byte count
         lbsr  L0374
         lbsr  L03B9
 bcs SCERR ..error; return it
 tsta null byte?
 beq SCRead2 ..yes
 cmpa PD.EOF,y End-of-File?
 bne SCRead15 ..no
SCEOFX ldb #E$EOF
SCERR leas 2,s
 pshs b
 bsr SCRead3
 comb
 puls PC,B return error

SCRead1 tfr X,D check byte count
 tstb buffer full?
 bne SCRead12 branch if not
 lbsr RetData return data to process
 ldu PD.BUF,y reset buffer ptr
SCRead12    lbsr  L03B9
         bcs   SCERR
SCRead15    tst   PD.EKO,y
         beq   SCRead2
         lbsr  PutDv2 Print character
SCRead2    leax  $01,x
         sta   ,u+
         beq   SCRead22
         cmpa  PD.EOR,y
         beq   SCRead25
SCRead22 cmpx 0,S bytes read >= byte count requested?
 bcs SCRead1 ..no; repeat
SCRead25 leas 2,s return scratch
SCRead3 lbsr RetData return data to process
 ldu PD.RGS,y get user stack
 stx R$Y,u return actual byte count
SCRead4 lbra IODONE
L02B6    rts


SCRdLine    lbsr  SCALOC
         bcs   L02B6
         ldx   $06,u
         beq   SCRead3
         tst   $06,u
         beq   SCRd10
         ldx   #$0100
SCRd10    pshs  x
         ldd   #$FFFF
         std   $0D,y
         lbsr  L0374
SCRd20    lbsr  L03B9
         lbcs  SCABT
         tsta
         beq   L02F6
         ldb   #$29
L02DD    cmpa  b,y
         beq   SCCTLC
         incb
         cmpb  #$31
         bls   L02DD
* Special for FM-11 start
         cmpa  #$0C
         beq   L0311
         cmpa  #$0B
         beq   L0311
         cmpa  #$15
         beq   L0311
         cmpa  #$16
         beq   L0311
L02F6    cmpx  $0D,y
         bls   L02FC
         stx   $0D,y
* Special for FM-11 end
L02FC    leax  $01,x
         cmpx  ,s
         bcs   L030C
         lda   <$33,y
         lbsr  L0390
         leax  -$01,x
         bra   SCRd20
L030C    lbsr  UPCASE
         sta   ,u+
L0311    lbsr  CHKEKO
         bra   SCRd20
SCCTLC    pshs  pc,x
         leax  CTLTBL,pcr
         subb  #$29
         lslb
         leax  b,x
         stx   $02,s
         puls  x
         jsr   [,s++]
         bra   SCRd20

**********
* Path control char Dispatch Table
CTLTBL    bra   SCBSP
         bra   SCDEL        Process PD.DEL
         bra   SCEOL        Process PD.EOR
         bra   SCEOF
         bra   SCPRNT
         bra   SCRPET
         puls  pc
         bra   SCDEL
         bra   SCDEL

* Process PD.EOR character
SCEOL    leas  $02,s
         sta   ,u
         lbsr  CHKEKO
 ldu PD.RGS,y
 leax 1,x count CR
 stx R$Y,u
 lbsr RetData return line
 leas 2,s ditch max count
 lbra IODONE

SCEOF leas 2,s discard return addr
         leax  ,x
         lbeq  SCEOFX
         bra   L02F6

SCABT pshs B save error code
         lda   #$0D
         sta   ,u
         bsr   EKOCR
 puls B restore error code
 lbra SCERR detach drivers; return error

L0367    bsr   SCBSP

* Delete line left
SCDEL    leax  ,x
         beq   L0374
         tst   <$23,y
         beq   L0367
         bsr   EKOCR
L0374    ldx   #$0000
         ldu   $08,y
         rts
SCBSP    leax  ,x
         beq   L03B8
         leau  -$01,u
         leax  -$01,x
         tst   <$22,y
         beq   L038D
         bsr   L038D
         lda   #$20
         bsr   L0390
L038D    lda   <$32,y
L0390    lbra  EKOBYT

EKOCR lda #C$CR
 lbra EKOBYT

SCPRNT    lda   <$2B,y
         sta   ,u
         bsr   L0374
L039F    bsr   L0408

SCRPET    cmpx  $0D,y
         beq   L03B8
         leax  $01,x
         cmpx  $02,s
         bcc   L03B6
         lda   ,u+
         beq   L039F
         cmpa  <$2B,y
         bne   L039F
         leau  -$01,u
L03B6    leax  -$01,x
L03B8    rts

L03B9    pshs  u,y,x
         ldx   $03,y
         ldu   $02,x
         ldx   <$14,u
         beq   L03D4
         ldd   $09,x
         jsr   d,x
         puls  pc,u,y,x

GetDv2    pshs  u,y,x
         ldx   $0A,y
         ldu   $03,y
         bra   GetChr1

GetChr    pshs  u,y,x
L03D4    ldx   $03,y
 ldu PD.DV2,y get attached device ptr
 beq GetChr2 return if no attached device
GetChr1 ldu V$STAT,u
 ldb PD.PAG,y
 stb V.LINE,u reset lines-left count
GetChr2    leax  ,x
         beq   GetChr3
         tfr   u,d
         ldu   $02,x
         std   $09,u
 ldu #D$READ
 lbsr IOEXEC read one character
GetChr3 puls PC,U,Y,X

***************
* UPCASE
*   Convert lower-case to upper-case

* Passed: (A)=char
*         (Y)=PD
* Returns: (A)=upcased
* Destroys: none

UPCASE tst PD.UPC,y uppercase only?
 beq UPCAS9 ..no; return
 cmpa #'a
 bcs UPCAS9
 cmpa #'z
 bhi UPCAS9
 suba #'a-'A convert to uppercase
UPCAS9    rts

***************
* CHKEKO
*   If echo is appropriate, do it

* Passed:  (A)=char to echo
*          (Y)=File Descriptor

CHKEKO tst PD.EKO,y echo?
 beq UPCAS9 ..no

L0408    cmpa  #$20
         bcc   EKOBYT
         cmpa  #$0C
         beq   EKOBYT
         cmpa  #$0B
         beq   EKOBYT
         cmpa  #$15
         beq   EKOBYT
         cmpa  #$16
         beq   EKOBYT
 cmpa #C$CR carriage return?
 bne EKOCH2 ..no; check other CTL chars
EKOBYT lbra PutDv2 echo char

EKOCH2 pshs A save character
 lda #C$PERD echo period for CTL chars
 bsr EKOBYT
 puls pc,a return char


***************
* Subroutine RetData
*   Return Data to User's address space
*
* Passed: (X)=Bytecount
*         (Y)=PD ptr

RetData pshs Y,X save registers
 ldd 0,s get byte count
 beq RetDat30
 tstb end of buffer?
 bne RetDat10 branch if not
 deca adjust offset
RetDat10 clrb make beginning of buffer
 ldu PD.Rgs,y get registers ptr
 ldu R$X,u get destination ptr
 leau d,u get current position ptr
 clra
 ldb 1,s get byte count
 bne RetDat20 branch if partial buffer
 inca adjust byte count
RetDat20 pshs D save byte count
 lda D.SysTsk get system task
 ldx D.Proc get process ptr
 ldb P$Task,x get process task
 ldx PD.BUF,y get buffer ptr
 puls Y get byte count
 os9 F$Move move data
RetDat30 puls PC,Y,X

*****************
* IODONE

IODONE ldx D.Proc
 lda P$ID,x get current process ID
 ldx PD.DEV,y from device table entry
 bsr IODO10
 ldx PD.DV2,y
IODO10 beq IODO90 exit if null device
 ldx V$STAT,x
 cmpa V.Busy,x
 bne IODO90
 clr V.Busy,x set other device not busy
IODO90 rts

GetDev pshs X,A save P$ID, Dev Tbl ptr
 ldx V$STAT,x get ptr to device static storage
         pshs  cc
         orcc  #$50
         lda   $04,x
         beq   GetDev10
         cmpa  $01,s
         beq   GetDev20
         puls  cc
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

GetDev10 lda 1,s
 sta V.Busy,x mark device as owned
 sta V.LPRC,x
 lda PD.PSC,y
 sta V.PCHR,x initialize pause char
 ldd PD.INT,y
 std V.INTR,x initialize Interrupt, Abort chars
 ldd PD.XON,y
 std V.XON,x initialize XON, XOFF chars
 lda PD.PAR,y reset device type
 beq GetDev20
 sta V.Type,x
GetDev20    puls  cc
         clra
         puls  pc,x,a

SCALOC ldx D.Proc
 lda P$ID,x get current process ID
 clr PD.MIN,y
 ldx PD.DEV,y
 bsr GetDev allocate Input device
 bcs SCAL90
 ldx PD.DV2,y
 beq SCAL20
 bsr GetDev allocate output device
 bcs SCAL90
SCAL20 tst PD.MIN,y ..devices mine?
 bne SCALOC ..no; try again
 clr PD.RAW,y init to cooked mode
SCAL90 ldu PD.RGS,y
 rts

 ttl Output Routines
 page
***************
* SCWrLine
*   Process Write Line Request

* Passed: (Y)= Path Descriptor ptr

SCWrLine    bsr   SCALOC
         bra   SCWrit00

SCWrite    bsr   SCALOC
         inc   $0C,y
SCWrit00    ldx   $06,u
         beq   SCWrit99
         pshs  x
         ldx   #$0000
         bra   SCWrit20
SCWrit10    tfr   u,d
         tstb
         bne   SCWrit40
SCWrit20    pshs  y,x
         ldd   ,s
         ldu   $06,y
         ldx   $04,u
         leax  d,x
         ldd   $06,u
         subd  ,s
         cmpd  #$0020
         bls   SCWrit30
         ldd   #$0020
SCWrit30    pshs  b,a
         ldd   $08,y
         inca
         subd  ,s
         tfr   d,u
         lda   #$0D
         sta   -$01,u
         ldy   D.Proc
         lda   $06,y
         ldb   D.SysTsk
         puls  y
         os9   F$Move
         puls  y,x
SCWrit40    lda   ,u+
         tst   $0C,y
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
         bcc   SCWrit60
         lda   -$01,u
         beq   SCWrit10
         cmpa  <$2B,y
         bne   SCWrit10
         tst   $0C,y
         bne   SCWrit10
SCWrit60    leas  $02,s
SCWrit70    ldu   $06,y
         stx   $06,u
SCWrit99    lbra  IODONE

SCWrErr    leas  $02,s
         pshs  b,cc
         bsr   SCWrit70
         puls  pc,b,cc

* Print character
PutDv2    pshs  u,x,a
         ldx   $0A,y
         beq   PutChr9
         cmpa  #$0D
         bne   PutChr2
         bra   PutChr17

PutChr    pshs  u,x,a
         ldx   $03,y
         cmpa  #$0D
         bne   PutChr2
         ldu   $02,x
         tst   $08,u
         bne   L0583
         tst   <$27,y
         beq   PutChr17
         tst   $0C,y
         bne   PutChr17
         dec   $07,u
         bne   PutChr17
         bra   L058D
L0583    lbsr  GetDv2
         bcs   L058D
         cmpa  <$2F,y
         bne   L0583
L058D    lbsr  GetDv2
         cmpa  <$2F,y
         beq   L058D
PutChr17    ldu   $02,x
         clr   $08,u
         lda   #$0D
         bsr   WrChar
         tst   $0C,y
         bne   PutChr9

         ldb   <$26,y
         pshs  b
         tst   <$25,y
         beq   EOL1
         lda   #$0A
EOL0    bsr   WrChar
         bcs   EOL2
EOL1    lda   #$00
         dec   ,s
         bpl   EOL0
         clra
EOL2    leas  $01,s
PutChr9    puls  pc,u,x,a

PutChr2 bsr WrChar write character
 puls pc,u,x,a

WrChar ldu #D$WRIT

***************
* IOEXEC
*   Execute SCF Device's Read/Write routine

* Passed: (A)=output char (write)
*         (X)=Device Table entry ptr
*         (Y)= Path Descriptor ptr
*         (U)=offset of routine (D$ReaD, D$Write)
* returns: (A)=Input char (read)
*          (B)=error code, C=set if error
* Destroys: B,CC

IOEXEC pshs U,Y,X,A save registers
 ldu V$STAT,x get static storage for driver
 clr V.WAKE,u clear wake-up call
 ldx V$DRIV,x get driver module address
 ldd M$Exec,x and offset of execution entries
 addd 5,S offset by read/write
 leax d,x absolute entry address
 lda ,s+ restore char (for write)
 jsr 0,x execute driver Read/Write
 puls pc,u,y,x return (A)=char, (B)=error

 emod Module CRC
SCFEnd equ *
