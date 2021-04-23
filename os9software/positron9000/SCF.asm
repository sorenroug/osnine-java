 nam   SCF
 ttl   Sequential Character file manager

* This is a LEVEL 2 module
* Originally from Positron 9000

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

Edition equ 2    current edition number
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
Open0 sty R$X,u save updated name ptr
 puls y retrieve PD ptr
 ldd #BuffSize
 os9 F$SRqMem allocate buffers
 bcs OPNER9 ..error; return it
 stu PD.BUF,y save buffer ptr
 clrb  

***************
* This code may be optimized by "lda #C$CR"
* In severe cases when memory is expensive
 lda #C$CR

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
 ldb #D$GSTA

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

***************
* SCRead
*   Process Read Request
*
* Passed: (Y)=File Descriptor Static Storage

SCRead lbsr SCALOC allocate devices
 bcs SCRETN ..exit if not gotten
 inc PD.RAW,y read mode (don't cook CR)
 ldx R$Y,u called with zero byte count?
 beq SCRead4 ..yes; exit (gained ownership)
 pshs X save byte count
         lbsr  L025F
         lbsr  GetChr
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
SCRead12 lbsr GetChr
 bcs SCERR ..error; return it
SCRead15  tst PD.EKO,y echo on?
 beq SCRead2 ..no
 lbsr PutDv2 echo raw chars
SCRead2 leax 1,x increment byte count
 sta ,U+ put char in buffer
 beq SCRead22
 cmpa PD.EOR,y End-of-Record?
 beq SCRead25 ..yes; exit
SCRead22 cmpx 0,S bytes read >= byte count requested?
 bcs SCRead1 ..no; repeat
SCRead25 leas 2,s return scratch
SCRead3 lbsr RetData return data to process
 ldu PD.RGS,y get user stack
 stx R$Y,u return actual byte count
SCRead4 lbra IODONE
 page
***************
* SCRdLine
*   Buffer a line from the Input device
*   using line-editing functions

* Passed: (Y)=File Descriptor address
*         (U)=Caller's register stack

SCRdLine lbsr SCALOC Allocate device(s)
 bcs SCRETN ..exit if not allocated

SCRd05 ldx R$Y,u Get byte count
 beq SCRead3 ..zero; return (gained ownership)
 tst R$Y,u Byte count above 255?
 beq SCRd10 ..no
 ldx #256 Maximum of 256 permitted
SCRd10    pshs  x
         ldd   #$FFFF
         std   PD.MAX,y
         lbsr  L025F
SCRd20 lbsr GetChr Input one char
 bcs SCABT ..i/o tremors, abort
 tsta null?
 beq SCRd30 Ignore control char checking if null
 ldb #PD.BSP
SCRd25 cmpa b,y control character?
 beq SCCTLC ..yes; dispatch to routine
 incb
 cmpb #PD.QUT more to check?
 bls SCRd25 ..yes; repeat
SCRd30    cmpx  PD.MAX,y
         bls   SCRd35
         stx   PD.MAX,y
SCRd35 leax 1,x Increment byte count
 cmpx 0,S Input overrun?
 blo SCRd40 ..no
 lda PD.OVF,y Get line overflow char
 lbsr OUTCHR
 leax -1,x
 bra SCRd20 get next char
SCRd40 lbsr UPCASE Check for upcase only
         sta   ,u+
         lbsr  CHKEKO
SCRd50 bra SCRd20 Go get more

SCCTLC pshs pc,x save regs
 leax CTLTBL,pcr get dispatch table
 subb #PD.BSP
 lslb two bytes per entry
 leax b,x get routine offset
 stx 2,s address of table dispatch
 puls x
 jsr [,s++] call routine
 bra SCRd20 back to main loop

**********
* Path control char Dispatch Table
CTLTBL bra SCBSP
 bra SCDEL
 bra SCEOL
 bra SCEOF
 bra SCPRNT
 bra SCRPET Pd.dup
 puls pc
 bra SCDEL
 bra SCDEL

SCEOL leas 2,s discard return addr
         sta   ,u
 lbsr CHKEKO Echo character
 ldu PD.RGS,y
 leax 1,x count CR
 stx R$Y,u
 lbsr RetData return line
 leas 2,s ditch max count
 lbra IODONE

SCEOF leas 2,s discard return addr
         leax  ,x
         lbeq  SCEOFX
         bra   SCRd30

SCABT pshs B save error code
         lda   #$0D
         sta   ,u
 bsr EKOCR Print carriage return
 puls B restore error code
 lbra SCERR detach drivers; return error
L0252    bsr   SCBSP
* Delete line left
SCDEL    leax  ,x
         beq   L025F
         tst   PD.DLO,y
         beq   L0252
         bsr   EKOCR
L025F    ldx   #$0000
         ldu   PD.BUF,y
         rts   

SCBSP    leax  ,x
         beq   L02A1
 leau -1,u Back up buffer ptr
 leax -1,x Back up byte count
 tst PD.BSO,y Bsp? or bsp,sp,bsp?
 beq SCBSP2 ..just send bsp
 bsr SCBSP2
 lda #C$SPAC
 bsr OUTCHR
SCBSP2 lda PD.BSE,y Get backspace echo char
OUTCHR bra EKOBYT

EKOCR lda #C$CR
 bra EKOBYT

SCPRNT    lda   PD.EOR,y
         sta   0,u
         bsr   L025F
L0288    bsr   EKOCHR

SCRPET    cmpx  PD.MAX,y
         beq   L02A1
         leax  1,x
         cmpx  $02,s
         bcc   L029F
         lda   ,u+
         beq   L0288
         cmpa  PD.EOR,y
         bne   L0288
         leau  -1,u
L029F    leax  -1,x
L02A1    rts   


***************
* GetChr
*   get one character from Input device

* Passed:  (Y)=File Descriptor address
* returns: (A)=char
*          (B)=error, cc set if error

GetDv2 pshs u,y,x
 ldx PD.DV2,y
 ldu PD.DEV,y get attached device
 bra GetChr1

GetChr pshs U,Y,X
 ldx PD.DEV,y
 ldu PD.DV2,y get attached device ptr
 beq GetChr2 return if no attached device
GetChr1 ldu V$STAT,u
 ldb PD.PAG,y
 stb V.LINE,u reset lines-left count
GetChr2 leax 0,x
 beq GetChr3 ..exit if no Input device
 tfr U,D
 ldu V$STAT,x
 std V.DEV2,u save static for pause
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

EKOCHR cmpa #C$SPAC CTL char?
 bhs EKOBYT ..no; echo it
         cmpa  #$02
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
 lda V.Busy,x is device busy?
 beq GetDev10 ..no; return
 cmpa 0,s current process owned?
 beq GetDev20 ..yes; return
 pshs a save device owner
 bsr IODONE release devices
 puls a restore device owner
 os9 F$IOQu sleep until device is available
 inc PD.MIN,y
 ldx D.Proc
 ldb P$Signal,X is it wake-up?
 puls x,a
 beq GetDev ..yes; try again
 coma
 rts return signal as error

GetDev10 lda 0,s
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
GetDev20 clra
 puls pc,x,a

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

SCWrLine bsr SCALOC get I/O devices
 bra SCWrit00 write line

***************
* SCWrite
*   Write Characters to Output device

* Passed: (Y)=File Descriptor address

SCWrite bsr SCALOC get I/O devices
 inc PD.RAW,y write mode (don't cook CR)
SCWrit00 ldx R$Y,u get caller's byte count
 beq SCWrit99 none; return (have gained last CTL of device)
 pshs x save byte count
 ldx #0 clear byte count
 bra SCWrit20

SCWrit10 tfr U,D copy byte count
 tstb end of buffer?
 bne SCWrit40 branch if not
SCWrit20 pshs  y,x save registers
 ldd 0,s get byte count
 ldu PD.Rgs,y get registers ptr
 ldx R$X,u get source ptr
 leax d,x get current ptr
 ldd R$Y,u get byte count
 subd 0,s get bytes remaining
 cmpd #OutBfSiz more than one "chunk"?
 bls SCWrit30 branch if not
 ldd #OutBfSiz set max byte count
SCWrit30 pshs D save byte count
 ldd PD.Buf,y get buffer ptr
 inca end of buffer + 1
 subd 0,s minus bytes to read
 tfr D,U (U)=destination ptr
 lda #C$CR mark end of buffer
 sta -1,u
 ldy D.Proc get process ptr
 lda P$Task,y get process task
 ldb D.SysTsk get system task number
 puls y retrieve byte count
 os9 F$Move get user data
 puls y,x retrieve registers
SCWrit40 lda ,u+ get next output character
 tst PD.RAW,y cooked mode?
 bne SCWrit50 ..no
* anda #$7F used to strip high order bit
 lbsr UPCASE check for uppercase convert
 cmpa #C$LF
 bne SCWrit50
 lda #C$CR output EOL for line feeds
 tst PD.ALF,y auto line feed on?
 bne SCWrit50 ..Yes
 bsr PutChr output CR
 bcs SCWrErr abort if write error
 lda #C$LF
SCWrit50 bsr PutChr put char in output buffer
 bcs SCWrErr exit if write error
 leax 1,x count byte
 cmpx 0,s written enough?
 bcc SCWrit60 branch if so
 lda -1,u get last char
 beq SCWrit10 nulls can't be end of lines
 cmpa PD.EOR,y end of line?
 bne SCWrit10 ..no; loop
 tst PD.RAW,y write line mode?
 bne SCWrit10 ..no; loop
SCWrit60 leas 2,s return scratch
SCWrit70 ldu PD.RGS,y get registers ptr
 stx R$Y,u return to user
SCWrit99 lbra IODONE


SCWrErr leas 2,s return scratch
 pshs b,cc save error status
 bsr SCWrit70 return byte count sent
 puls pc,b,cc return error status
 page
***************
* PutChr
*   put character in output buffer

* Passed:  (A)=char
*          (Y)=PD address
* Destroys: B,CC

PutDv2 pshs U,X,A
 ldx PD.DV2,y
 beq PutChr9 ..no output device
 cmpa #C$CR carriage return?
 bne PutChr2 ..no
 bra PutChr17 check EOL functions if so

PutChr pshs U,X,A
 ldx PD.DEV,y
 cmpa #C$CR carriage return?
 bne PutChr2 ..no
 ldu V$STAT,x get driver storage
 tst V.PAUS,u immediate pause?
 bne PutChr1 ..yes
 tst PD.PAU,y End-of-Page pause?
 beq PutChr17 ..no
 dec V.LINE,u End-of-Page?
 bne PutChr17 ..no
 bra PutChr15
PutChr1 lbsr  GetDv2
 bcs PutChr15 ..continue if error
 cmpa PD.PSC,y pause?
 bne PutChr1 ..no; flush out type-ahead buffer
PutChr15 lbsr  GetDv2 ..then pause for one char
 cmpa PD.PSC,y pause?
 beq PutChr15 ..yes; igore
PutChr17 ldu V$STAT,x in device static storage
 clr V.PAUS,u clear pause mode if set
 lda #C$CR restore carriage return char
 bsr WrChar write out carriage return
 tst PD.RAW,Y "cooked" mode?
 bne PutChr9 ..no; just return


***************
* EOL . Process end of line functions
* Passed: (X)=Device Table ptr
*         (Y)= Path Descriptor
* returns: B,CC=error code (if error)
* Destroys: A

EOL ldb PD.NUL,y get null count
 pshs B save null count
 tst PD.ALF,y auto line feed?
 beq EOL1 ..no
 lda #C$LF get line feed character
EOL0 bsr WrChar write it
 bcs EOL2 ..exit if error
EOL1 lda #C$Null get null char
 dec 0,S enough nulls sent?
 bpl EOL0 ..no; send more
 clra return carry clear
EOL2 leas 1,s
PutChr9 puls pc,u,x,a return

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
