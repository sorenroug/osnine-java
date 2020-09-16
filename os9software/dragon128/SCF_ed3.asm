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

EXTEND equ 1 include extended editing facilities
MACROS equ 1 include macros
BuffSize equ $100 path buffer size
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
 cmpa #C$CR
 bne JAMM10
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
 lbsr SCGST1 send Release putstat to driver
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
 bcc SCInMac3 ..no; error - no room
 bra SCInMac1 ..try next

SCInMac2 ldb R$Y+1,u get byte count
 pshs x save ptr
 abx add in byte count
 leax 1,x plus room for byte count
 cmpx 2,s enough room?
 bhi SCInMac4 ..no
 beq SCInMac5 exactly fills it
 clr ,x clear next entry
SCInMac5 puls x retrieve ptr
 stb ,x+ set byte count
 clra
 pshs y,b,a stack byte count and PD ptr
 lda R$Y,u get key code
 sta -2,x set it
 ldy D.Proc get process ptr
 lda P$Task,y get source task
 ldb D.SysTsk get destination task (system)
 ldu R$X,u get source ptr
 exg x,u swap ptrs
 puls y get byte count
 os9 F$Move copy the macro
 puls y retrieve PD Ptr
 leas 2,s return scratch
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
SCClrM ldx PD.BUF,y get buffer ptr
 leax BuffSize,x point at macro buffer
 lda R$Y,u get key to delete
 beq SCClrM3 ..clear all
 leax MacBfSiz,x calculate buffer end
 pshs x save it
 leax -MacBfSiz+3,x back to buffer
SCClrM1 cmpa ,x this one?
 beq SCClrM2 ..yes
 tst ,x+ end of buffer?
 beq SCClrM4 ..yes; not found
 ldb ,x+ get entry size
 abx skip this entry
 cmpx ,s end of buffer?
 bcs SCClrM1 ..no; try again
 bra SCClrM4 ..not found

SCClrM2 ldb 1,x get byte count
 pshs y save PD ptr
 tfr x,y copy ptr
 abx point to next entry
 leax 2,x code and count
SCClrM7 cmpx 2,s end of buffer?
 bcc SCClrM5 ..yes; no copy needed
 tst ,x entry to copy?
 beq SCClrM5 ..no
 lda ,x+ copy code
 sta ,y+
 ldb ,x+ get byte count
 stb ,y+ copy it
SCClrM6 lda ,x+ copy the data
 sta ,y+
 decb
 bne SCClrM6
 bra SCClrM7 copy next

SCClrM5 clr ,y delete last entry
 puls y retrieve PD ptr
SCClrM4 leas 2,s ditch scratch
 clrb no error
 rts

SCClrM3 clr 3,x delete first entry (and so all)
 rts

********************
* Find a macro
*
SCFMac ldx PD.BUF,y get buffer ptr
 leax BuffSize+MacBfSiz,x point past macro buffer
 pshs x save end pointer
 leax -MacBfSiz+3,x point at buffer
SCFMac1 tst ,x+ end of entries?
 beq SCFMac3 ..yes; not found
 ldb ,x+ get byte count
 cmpa -2,x this one?
 beq SCFMac2 ..yes; found it
 abx skip this entry
 cmpx ,s end of buffer?
 bcs SCFMac1 ..no; try next
SCFMac3 comb error - not found
SCFMac2 leas 2,s ditch scratch
 rts
 endc

SCGStat ldx PD.RGS,y
 lda R$B,x get status code
 ifne EXTEND
 cmpa #SS.Edit edit line?
 beq SCEdit ..yes; do it
 endc
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
 ifne MACROS
 cmpa #SS.SMac set macro?
 lbeq SCInMac ..yes
 cmpa #SS.CMac clear macro?
 lbeq SCClrM ..yes
 endc
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
 bcs SCRETN exit if not allocated

 ldx R$Y,u get byte count
 lbeq SCRead3 ..zero; return (gained ownership)
 tst R$Y,u byte count > 255?
 beq SCEdit10 ..no
 ldx #256 max 256

SCEdit10 pshs y,x save regs
 ldx D.Proc get process ptr
 lda P$Task,x get source task
 ldb D.SysTsk get destination task
 ldx R$X,u get source ptr
 ldu PD.BUF,y get destination ptr
 ldy ,s get byte count
 os9 F$Move get the line to edit
 puls y,x retrieve regs
 tfr u,d put buffer ptr in D
 leax d,x calculate max EOL ptr
 pshs x save it
 lbsr SCRPET display the line, get EOL ptr
 ldu PD.RGS,y get register ptr
 lda R$U+1,u get desired cursor position
 pshs b push chr count
 cmpa ,s+ valid cursor?
 bcs SCEdit12 ..yes
 tfr b,a stop at end of line
SCEdit12 pshs A save it
 subb ,S+ calculate number to move back
 pshs b save it
 tfr a,b calculate cursor position
 clra
 addd PD.BUF,y add buffer start
 tfr d,u put in U
 ldb ,s+ get number to move back
 beq SCEDIT15 ..none
 bsr SCEdit20 move back to cursor position
SCEDIT15 lbra SCRd20 and read in the response

SCEdit20 pshs B stack the count
 lbra SCDLL2 and move back

 endc
***************
* SCRead
*   Process Read Request
*
* Passed: (Y)=File Descriptor Static Storage

SCRead lbsr SCALOC allocate devices
 bcs SCRETN ..exit if not gotten
 inc PD.RAW,y read mode (don't cook CR)
 ldx R$Y,u called with zero byte count?
 lbeq SCRead4 ..yes; exit (gained ownership)
 pshs X save byte count
 ifne EXTEND
 ldu PD.BUF,y reset buffer ptr
 ldx #0 and byte count
 else
 jmp NOWHERE
 endc
 ifne MACROS
 pshs x,a save regs
 ldx BuffSize+1,u get possible current macro ptr
 ldb BuffSize,u is there some?
 bne SCRead5 ..yes; send it
 puls x,a retrieve regs
 endc
 lbsr GetChr get character
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
 ifne MACROS
SCRead15 pshs x,a save chr and byte count
 pshs y save PD ptr
 lbsr SCGetDev extended edit facilities?
 bcs SCRead8 ..no
 cmpa PD.LdIn-PD.OPT,y lead-in character?
 bne SCRead8 ..no
 ldy ,s retrieve PD ptr
 lbsr GetChr get next chr
 ora #$80 set bit 7 for matching
 bcc SCRead8 ..no read error
 leas 5,s ditch scratch
 bra SCERR ..abort
SCRead8 puls y retrieve PD ptr
 sta ,s update the save character
 lbsr SCFMac macro?
 bcc SCRead5 ..yes
 puls x,a retrieve regs
 tst PD.EKO,y echo on?
 else
SCRead15 pshs x,a
 tst PD.EKO,y echo on?
 endc
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
 ifne MACROS

SCRead5 leas 1,s ditch chr
 pshs x,b save macro ptr and byte count
SCRead6 ldx  1,s get macro ptr
 lda ,x+ get a chr
 sta ,u+ put in buffer
 stx 1,s update ptr
 dec ,s keep macro count
 tst PD.EKO,y echo on?
 beq SCRead62 ..no
 lbsr PutDv2 echo chr
SCRead62 ldx 3,s get byte count
 leax 1,x bump it
 stx 3,s update it
 cmpx 5,s enough for caller?
 bcc SCRead7 ..yes
 tfr x,d buffer full?
 tstb
 bne SCRead65 ..no
 lbsr RetData return a bufferfull
 ldu PD.BUF,y update buffer ptr
SCRead65 tst ,s end of macro?
 bne SCRead6 ..no
 leas 5,s ditch scratch
 lbra SCRead12 and get next chr

SCRead7 ldx PD.BUF,y get buffer ptr
 puls b get remaining count
 stb BuffSize,x save it
 puls D get macro ptr
 std BuffSize+1,x save that too
 puls x retrieve byte count
 bra SCRead25 and return to caller
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

SCRd05 ldx R$Y,u Get byte count
 beq SCRead3 ..zero; return (gained ownership)
 tst R$Y,u Byte count above 255?
 beq SCRd10 ..no
 ldx #256 Maximum of 256 permitted
 ifne EXTEND
SCRd10 tfr x,d
 addd PD.BUF,y
 pshs b,a
 else
 endc
 lbsr SCDEL9
 ifne MACROS
 clr BuffSize,u cancel any current macro
 endc
SCRd20 lbsr GetChr Input one char
 lbcs SCABT ..i/o tremors, abort
* anda #$7F was used to strip high bit
 tsta null?
 beq SCRd30 Ignore control char checking if null
 ldb #PD.BSP
SCRd25 cmpa b,y control character?
 beq SCCTLC ..yes; dispatch to routine
 incb
 cmpb #PD.QUT more to check?
 bls SCRd25 ..yes; repeat
 ifne EXTEND

 pshs y save path descriptor ptr
 bsr SCGetDev get device descriptor options ptr
 bcs SCRd27 skip if editing functions not available

 cmpa PD.LdIn-PD.OPT,Y lead-in code?
 bne SCRd60 ..no
 pshs y save options ptr
 ldy 2,s retrieve PD ptr
 lbsr GetChr get next chr
 puls y restore options ptr
 bcs SCRd90 ..error
 ora #$80 set bit 7 for matching

SCRd60 ldb #PD.QUT+1 point to next dispatch table
 leay PD.Left-PD.OPT,y point at edit key-codes
SCRd65 cmpa ,y+ this key?
 beq SCRd70 ..yes
 incb
 cmpb #PD.QUT+PD.DEol-PD.Left+1 more?
 bls SCRd65 ..yes
* anda #$7F used to clear bit 7 and fall through
SCRd27 puls y retrieve PD ptr

 else
 endc
 ifne MACROS
 lbra SCChkMac check for macros
 endc
 ifne MACROS+EXTEND
SCRd30
 endc
SCRd35 leax 1,x Increment byte count
 cmpx 0,S Input overrun?
 ifne EXTEND
 leax -1,x restore EOL ptr
 endc
 blo SCRd40 ..no
SCRd37 lda PD.OVF,y Get line overflow char
 lbsr OUTCHR
 ifeq EXTEND
 endc
 bra SCRd20 get next char
SCRd40 lbsr UPCASE Check for upcase only
 ifne EXTEND
 lbsr SCINS put chr in buffer and echo
 else
 endc
SCRd50 bra SCRd20 Go get more
 ifne EXTEND

SCRd90 puls Y retrieve path descriptor ptr
 lbra SCABT and abort

SCRd70 puls y retrieve path descriptor ptr, fall through

 endc

SCCTLC pshs pc,x save regs
 leax  CTLTBL,pcr get dispatch table
 subb  #PD.BSP
 ifne EXTEND
 pshs a save chr
 lslb two bytes per entry
 ldd b,x get routine offset
 leax d,x make routine address
 puls a retrieve chr
 else
 endc
 stx 2,s address of table dispatch
 puls x
 jsr [,s++] call routine
 ifne EXTEND
 lbra SCRd20 back to main loop
 else
 endc
 ifne EXTEND
 page
SCGetDev pshs A save A
 lda PD.Edit,y
 pshs  a
 ldy PD.DEV,y
 ldy V$DESC,y get device descriptor address
 leay M$DTyp,y point at options section
 coma set carry
 lda ,s+ editing functions available?
 bne SCGetD1 ..no
 clra clear carry
SCGetD1 puls pc,a
 endc

**********
* Path control char Dispatch Table
CTLTBL
 ifne EXTEND
 fdb SCBSP-CTLTBL Pd.bsp
 fdb SCDEL-CTLTBL Pd.del
 fdb SCEOL-CTLTBL Pd.eor
 fdb SCEOF-CTLTBL Pd.eof
 fdb SCPRNT-CTLTBL Pd.rpr
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

SCEOL leas 2,s discard return addr
 ifne EXTEND
 bsr SCMKEL Mark end of line with CR
 else
 endc
 lbsr CHKEKO Echo character
 ldu PD.RGS,y
 ifne EXTEND
 bsr SCGetLen calculate number of chrs
 endc
 leax 1,x count CR
 stx R$Y,u
 lbsr RetData return line
 leas 2,s ditch max count
 lbra IODONE

 ifne EXTEND
SCGetLen exg x,d calculate line length
 subd PD.BUF,y from EOL ptr
 exg d,x
 rts

SCMKEL lda #C$CR mark EOL with CR
 sta ,X
 rts

SCChkEol pshs x stack EOL ptr
 cmpu ,s check for EOL
 puls pc,x
 endc

SCEOF leas 2,s discard return addr
 ifne EXTEND
 cmpx PD.BUF,y first chr?
 lbne SCRd30 ..no
 ldx #0 zero chr count
 lbra SCEOFX end of file
 else
 endc

SCABT pshs B save error code
 ifne EXTEND
 bsr SCMKEL mark end of line with CR
 else
 endc
 ifne EXTEND
 lbsr EKOCR Print carriage return
 else
 endc
 puls B restore error code
 lbra SCERR detach drivers; return error

 ifne EXTEND
* Delete line left
SCDEL tfr u,d calculate chrs to delete
 subd PD.BUF,y
 beq SCDEL4 exit if none
 pshs B save count
 pshs B three times
 pshs B
 pshs Y save path descriptor ptr
 ldy PD.BUF,y point at start of buffer
 bsr SCChkEol at end of line?
 bcc SCDEL5 ..yes
SCDEL1 lda ,u+ move chrs back in buffer
 sta ,y+
 inc 4,S keep count
 bsr SCChkEol end of line?
 bcs SCDEL1 ..no
SCDEL5 leax ,y get new EOL ptr
 puls y retrieve PD ptr
 ldu PD.BUF,y reset cursor pointer
 tst PD.DLO,y backspace over line?
 beq SCDEL2 ..yes
 leas 3,s ditch counters
 lbra EKOCR and send CR-LF

SCDEL4 rts

SCDEL2 bsr SCMLFT back one
 dec ,s at start of line?
 bne SCDEL2 ..no
 lbsr SCShLn display the line
SCDEL3 bsr SCSPACE overwrite with spaces
 dec 1,s
 bne SCDEL3
 leas 2,s return scratch
 lbra SCDLL2 return to start of line

* Delete line right
SCDELR clr ,-s clear counter
 pshs u,x save cursor and EOL ptr
 leax ,u new EOL ptr
SCDELR1 cmpu ,s check end of line
 beq SCDELR2 ..yes
 leau 1,u bump cursor
 bsr SCSPACE clear a space
 inc 4,s keep count
 bra SCDELR1 until end of line

SCDELR2 puls U,D retrieve cursor and scratch
 tst ,S any backspaces needed?
 lbne SCDLL2 ..yes
 puls PC,B

SCSPACE lda #C$SPAC write a space
 lbra CHKEKO

SCMLFT pshs y save path descriptor ptr
 lbsr SCGetDev point into device descriptor
 bcs SCMLFT20
 ldb #PD.Mlft-PD.OPT
 bra SCOutX10 send it

SCMLFT20 puls y retrieve PD ptr
 lbra SCBSP2 use backspace echo chr

SCMRT pshs y save path descriptor ptr.
 ldb #PD.MRt-PD.OPT offset to 'move right' code
SCOutX lbsr SCGetDev point into device descriptor
 bcs SCMRT30 skip if no editing functions
SCOutX10 pshs x save EOL ptr
 leax ,y point at codes with X
 ldy 2,s retrieve PD ptr
 lda b,x get code
 bpl SCMRT20
 anda #$7F clear high bit
 pshs a save code
 lda PD.LdOut-PD.OPT,X get lead-in chr
 beq SCMRT10 skip if none
 bsr OUTCHR send lead-in
SCMRT10 puls a retrieve code
SCMRT20 bsr OUTCHR send it
SCMRT30 puls pc,y,x

SCRT bsr SCChkE at end of line?
 bcc SCRT20 ..yes; go to start of line
 bsr SCMRT else move right one
 bcs SCRT10 skip if didn't move
 leau 1,u bump the cursor
SCRT10 rts

SCRT20 tfr u,d calculate chrs to move back..
 subd PD.BUF,y ..to start of line
 beq SCRT10 ..none
 pshs b stack the count
 ldu PD.BUF,y reset the cursor
 bra SCDLL2 move to start of line

SCLFT cmpu PD.BUF,y at start of line?
 beq SCLFT20 ..yes; move to end of line
 bsr SCMLFT move back one
 bcs SCLFT10 skip if couldn't
 leau -1,u update cursor
SCLFT10 rts

SCLFT20 bsr SCChkE at end of line?
 beq SCLFT30 ..yes; finished
 leau 1,u bump cursor
 bsr SCMRT move right one
 bcc SCLFT20 repeat if OK

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
SCBSP cmpu PD.BUF,y at start
 beq SCLFT30 ..yes; return
 bsr SCChkE at end of line?
 bne SCDLLF ..no; delete left
 else
 endc
 leau -1,u Back up buffer ptr
 leax -1,x Back up byte count
 tst PD.BSO,y Bsp? or bsp,sp,bsp?
 beq SCBSP2 ..just send bsp
 bsr SCBSP2
 ifne EXTEND
 lbsr SCSPACE send space
 else
 endc
SCBSP2 lda PD.BSE,y Get backspace echo char
 ifne EXTEND
OUTCHR lbra EKOBYT
 else
 endc

 ifne EXTEND
SCChkE lbra SCChkEol

* Delete left one
SCDLLF lbsr SCMLFT back one
 leau -1,u move cursor back
SCDL pshs U save cursor position
SCDLL1 lda 1,u move characters back one
 sta ,u+
 bsr SCChkE all done?
 bcs SCDLL1 ..no
 puls u retrieve cursor position
 leax -1,x decrement EOL ptr
 bsr SCShLn display the line
SCDL1 incb count space to come
 pshs b save forward chr count
 lbsr SCSPACE overwrite the last chr

SCDLL2 lbsr SCMLFT move back one
 dec ,S all done?
 bne SCDLL2 ..no
 puls pc,a

* Delete character under cursor
SCDLRT bsr SCChkE at end of line?
 bcc SCDLR1 ..yes; no action
 leax -1,x decrement EOL ptr
 clrb clear counter
 bsr SCChkE last chr on line?
 bcc SCDL1 ..yes; overwrite one chr
 leax 1,x restore EOL ptr
 bra SCDL delete the chr

SCDLR1 rts

* Display to end of line
SCShLn clrb clear byte count
 pshs u,b save count and U
SCShL1 bsr SCChkE end of line?
 bcc SCShL2 ..yes
 lda ,u+ get a chr
 cmpa #C$CR done?
 beq SCShL2 ..yes
 lbsr CHKEKO display the chr
 inc ,s keep count
 bra SCShL1

SCShL2 puls  pc,u,b return with forward count

* Insert a character into the buffer
SCINS bsr SCChkE at end of line?
 bcs SCINS1 ..no
 sta ,u+ put chr in buffer
 leax 1,x bump EOL ptr
 lbra CHKEKO and echo the chr

SCINS1 pshs u save cursor position
 leau ,x point at end of line
SCINS3 ldb ,-U move chrs right one
 stb 1,u
 cmpu ,s done?
 bne SCINS3 ..no; loop
 leas 2,s return scratch
 sta ,u put chr in buffer
 leax 1,x increment EOL ptr
 bsr SCShLn display to end of line
 leau 1,u move cursor forward one
 decb one less backspace
 pshs B save count
 bra SCDLL2 end move back to cursor position

 endc
EKOCR lda #C$CR
 lbra EKOBYT

 ifne EXTEND
SCPRNT lbsr SCMKEL mark end of line
 else
 endc
 ifne EXTEND
 lbsr SCDEL9 reset buffer ptr, count
 else
 endc
SCPRT1 lbsr EKOCHR Print one char

 ifne EXTEND
SCRPET ldx 2,s get max EOL
 bsr SCShLn display rest of line
 clra
 pshs u
 addd ,s++
 tfr d,x put in X
 leau ,X and U, cursor ptr
 rts
 else
 endc

 ifne MACROS
* Check character against macro table
SCChkMac pshs x,a save EOL ptr and chr
 lbsr SCFMac macro key?
 bcc SCRd80 ..yes
 puls x,a retrieve EOL ptr and chr
 lbra SCRd35
SCRd80 leas 1,s ditch chr
 pshs x,b save macro ptr and byte count
 ldx 3,s get EOL ptr
 abx add in count
 cmpx 5,s room in buffer?
 bcs SCRd87 ..yes
 leas 3,s ditch scratch
 puls x retrieve EOL ptr
 lbra SCRd37 ..line overflow
SCRd87 pshs u save buffer ptr
 cmpu 5,s at end of line?
 bcc SCRd95 ..yes; no copy
 ldu 5,s get EOL ptr
 tfr u,d put in d
 subd ,s calculate chrs to move
SCRd88 lda ,-u copy chrs forward
 sta ,-x
 decb
 bne SCRd88
 ldu ,s retrieve buffer ptr
 ldb 2,s and byte count
SCRd95 ldx 3,s get macro ptr
SCRd100 lda ,x+ copy the macro
 sta ,u+ (updates buffer ptr too)
 decb
 bne SCRd100
 ldx 5,s get EOL ptr
 ldb 2,s retrieve byte count
 abx update EOL ptr
 stu 3,s save new buffer ptr
 ldu ,s retrieve old ptr
 lbsr SCShLn display the line
 subb 2,s need to move back?
 beq SCRd110 ..no
 bsr SCRd120 move back to cursor position
SCRd110 ldu 3,s retrieve new buffer ptr
 leas 7,s ditch scratch
 lbra SCRd20 and go for next chr

SCRd120 pshs B push byte count
 lbra SCDLL2 move back
 endc

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

EKOCHR cmpa #$7F control chr?
 bcc EKOCH2 ..yes
 cmpa #C$SPAC CTL char?
 bhs EKOBYT ..no; echo it
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
**********
 tst PD.RAW,y 'cooked' mode?
 bne PutChr2 ..no
**********
 cmpa #C$CR carriage return?
 bne PutChr2 ..no
 bra PutChr17 check EOL functions if so

PutChr pshs U,X,A
 ldx PD.DEV,y
**********
 tst PD.RAW,y 'cooked' mode?
 bne PutChr2 ..no
**********
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
