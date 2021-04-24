 nam Random Block File Manager - Level II
*
* Note: Microware has not put a copyright statement on this file
* This file comes from the Positron 9000
* There is a reference to a direct page variable at $8C

 ttl Module Header & entries
 use defsfile

included equ 1
 ifeq LEVEL-1
RCD.LOCK equ 0
 else
RCD.LOCK equ included
 endc

tylg     set   FlMgr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   RBFEnd,RBFNam,tylg,atrv,RBFEnt,0

RBFNam     equ   *
         fcs   /RBF/
         fcb   $10


* File Manager Constants
DTBSiz fcb DRVMEM Drive tbl size

* Entry Branch Table
RBFEnt    equ   *
         lbra  Create
         lbra  Open
         lbra  MakDir
         lbra  ChgDir
         lbra  Delete
         lbra  Seek
         lbra  Read
         lbra  Write
         lbra  ReadLn
         lbra  WritLine
         lbra  GetStat
         lbra  PutStat
         lbra  Close


 ttl Random Block file service request routines
 page
***************
* Subroutine Create
* Creates New Dir Entry and File Descriptor

* Stacked Temps
 org 0
S.SctAdr rmb 3 New file sector allocation addr
S.SctSiz rmb 2 New file allocation size
StkTemps set .
S.Path rmb 2 (Y) PD

Create pshs y save PD
 leas -StkTemps,S get scratch

* Look for Existing File
 lda R$B,u Clear dir attribute
 anda #$FF-DIR.
 sta R$B,u Replace user attributes
 lbsr SchDir Allocate buffer, search dir
 bcs Create10
ERCEF ldb #E$CEF
Create10 cmpb  #E$PNNF Pathname not found?
 bne CRTEX1 No; abort
 cmpa #PDELIM end of pathlist?
 beq CRTEX1 ..No; abort: dir not found
 pshs x save pathlist ptr
 ldx PD.RGS,Y
 stu R$X,x return updated ptr

* Allocate File Descriptor Sector
 ldb PD.SBP,Y
 ldx PD.SBP+1,Y
 lda PD.SSZ,Y
 ldu PD.SSZ+1,Y
 pshs U,X,D save them
 clra
 ldb #1 request one FD sector
 lbsr SECALL Call sector allocation
 bcc Create20 bra if no error
 leas 8,S return scratch
CRTEX1 leas StkTemps,S return scratch
 lbra KillPth0 abort; (B)=error code

Create20 std S.SctSiz+8,S Save sectors allocated
 ldb PD.SBP,Y get sector addr
 ldx PD.SBP+1,Y
 stb S.SctAdr+8,S save for FD
 stx S.SctAdr+1+8,S
 puls U,X,D retrieve seg info
 stb PD.SBP,Y set seg posn
 stx PD.SBP+1,Y
 sta PD.SSZ,Y Set high order seg size
 stu PD.SSZ+1,Y set low order seg size

* Find Free Entry in dir
 ldd PD.DCP,Y get dir entry
 std PD.CP,Y Make current psn
 ldd PD.DCP+2,Y
 std PD.CP+2,Y
 lbsr RdCurDir Read empty dir entry
 bcs Create13 error; EOF?
Create12 tst 0,x is dir entry still free?
 beq Create15
 lbsr RdNxtDir
 bcc Create12
* If dir is at EOF, then expand it
Create13 cmpb #E$EOF end of file?
 bne CRTEX1 ..No; abort
 ldd #DIR.SZ add size of new rcd
 lbsr WriteSub expand Dir
 bcs CRTEX1 error; abort
 lbsr WrtFDSiz Update file size in FD
* lbsr CLRBUF clear buffer
 lbsr RdCurDir re-read dir rcd

Create15 leau 0,x (U)=Dir Rcd Ptr
 lbsr ZerDir Zero out Dir entry
 puls x restore pathlist ptr
 os9 F$PrsNam parse pathname again
 bcs CRTEX1 ..error; abort
 cmpb #29 impossibly long?
 bls Create16 ..No; continue
 ldb #29 default maximum
Create16 clra
 tfr D,Y (Y)=name bytecount
 lbsr FromUser Move name from user to dir
 tfr Y,D
 ldy S.Path,S restore PD
 decb backup to last char
 lda B,U get it
 ora #$80 set name end
 sta B,U
 ldb S.SctAdr,S FD psn
 ldx S.SctAdr+1,S
 stb Dir.FD,U put in dir
 stx Dir.FD+1,U
 lbsr PCPSEC Write dir sector
* (Don't release locked-out Dir rcd)
 bcs CRTERR error; abort

* Initialize File Descriptor
 ldu PD.BUF,Y get buffer ptr
 bsr ZerBuf fill buffer with zeros
 lda #FDBUF
 sta PD.SMF,Y indicate FD in buffer
 ldx PD.RGS,Y get register package ptr
 lda R$B,X get attributes
 sta FD.ATT,U
 ldx D.PROC get process ptr
 ldd P$USER,X get process user
 std FD.OWN,U Set owner
 lbsr DateMod set "last modified" date
 ldd FD.DAT,U
 std FD.Creat,U init create YY MM
 ldb FD.DAT+2,U DD
 stb FD.Creat+2,U
 ldb #1 Set link count
 stb FD.LNK,U
 ldd S.SctSiz,S Retrieve sectors allocated
 subd #1 More than one?
 beq Create40 ..No
 leax FD.SEG,U
 std FDSL.B,X Set first seg size
 ldd S.SctAdr+1,S FD addr
 addd #1 Move to next sector
 std FDSL.A+1,X Set seg beginning
 ldb S.SctAdr,S
 adcb #0
 stb FDSL.A,X
Create40 ldb S.SctAdr,S addr of new FD sector
 ldx S.SctAdr+1,S
 lbsr PUTSEC Write FD
 bcs CRTERR error; abort
 lbsr Remove Remove path from dir rcd-lock lists
 stb PD.FD,Y move to new file's FD
 stx PD.FD+1,Y
 lbsr Insert Insert path into file's rcd-lock lists
 leas StkTemps,S return scratch

 ifeq RCD.LOCK-included
 ldx PD.Exten,Y
 lda #EOFLock
 sta PE.Lock,x Lock out "End" of file
 endc
 lbra InitPd

*  Error: Deallocate sectors & return
CRTERR puls U,X,A Recover allocation info
 sta PD.SBP,Y Set sector addr
 stx PD.SBP+1,Y
 clr PD.SSZ,Y Set high order sector to zero
 stu PD.SSZ+1,Y Zero number of sectors
 pshs b save error code
 lbsr SECDEA Return sector(s)
 puls b
CRTERR99 lbra KillPth0 return resources; abort
***************
* Subroutines ZerDir, ZerBuf
*   Zero Dir size rcd, or buffer
* Record size MUST be evenly divisive by 4

* Passed: (U)=rcd ptr
* Destroys: CC

ZerDir pshs u,x,D
 leau DIR.SZ,U
 bra ZerBuf10

ZerBuf pshs U,X,D
 leau $100,U end of buffer+1
ZerBuf10 clra
 clrb
 tfr D,X
ZerBuf20 pshu X,D
 cmpu 4,S entire rcd cleared?
 bhi ZerBuf20 ..No; loop
 puls PC,U,X,D return

 page
***************
* Subroutine Open
*   Locates File Descriptor and Initializes PD

Open pshs  y Save PD
 lbsr SchDir Allocate buffer, search dir
 bcs CRTERR99 ..Error; abort

 ldu PD.RGS,Y
 stx R$X,U return update pathlist ptr
 ldd PD.FD+1,Y Using entire device?
 bne Open15 ..No; open normal file
 lda PD.FD,Y entire device?
 bne Open15 ..No
 ldb PD.MOD,Y check access
 andb #Dir. trying to open as dir?
 lbne IllAcces ..Yes; abort
 std PD.SBP,Y Clear seg beg phys
 sta PD.SBP+2,Y
 std PD.SBL,Y Clear seg beginning logical
 sta PD.SBL+2,Y
 ldx PD.DTB,Y get device tbl ptr
 lda DD.TOT+2,X get low byte of disk size
 std PD.SIZ+2,Y Set low bytes of file size
 sta PD.SSZ+2,Y Set low byt of seg size
 ldd DD.TOT,X get disk size
 std PD.SIZ,Y Set file size
 std PD.SSZ,Y Set seg size
 puls PC,Y

* Check File Accessibility
Open15 lda PD.MOD,Y get requested mode
 lbsr CHKACC Check access
 bcs CRTERR99 ..Not accessible; abort
 bita #WRITE. write mode?
 beq InitPd ..no
 lbsr DateMod set date file modified
 lbsr PUTFD update the FD

* fall thru to Initpd

 page
***************
* Initialize PD

InitPd puls y recover PD
InitPD10 clra
 clrb
 std PD.CP,Y Clear current posn
 std PD.CP+2,Y
 std PD.SBL,Y Clear seg beginning logical
 sta PD.SBL+2,Y
 sta PD.SSZ,Y Clear high order seg siz
 lda FD.ATT,U get file attributes
 sta PD.ATT,Y
 ldd FD.SEG+FDSL.A,U get first seg list entry
 std PD.SBP,Y Set seg beginning physical
 lda FD.SEG+FDSL.A+2,U
 sta PD.SBP+2,Y
 ldd FD.SEG+FDSL.B,U get seg size
 std PD.SSZ+1,Y
 ldd FD.SIZ,U get file size
 ldx FD.SIZ+2,U

 ifeq RCD.LOCK-included
 ldu PD.Exten,Y get PE ptr
 cmpu PE.Confl,U Only open image to this path?
 beq InitPD80 ..Yes
 ldu PE.Confl,U
 ldu PE.PDptr,U
 ldd PD.SIZ,U
 ldx PD.SIZ+2,U
InitPD80
 endc

 std PD.SIZ,Y Set highest byte written
 stx PD.SIZ+2,Y
 clr PD.SMF,Y clear buffer flag and carry
 rts

 page
***************
* Subroutine Makdir
*   Creates A New (Sub-Ordinate) Dir

* Passed: (Y)=PD

MakDir lbsr Create create file
 bcs MakDir90 error; abort

 ifeq RCD.LOCK-included
 lda PD.ATT,Y
 ora #Share. protect baby dir until grown
 lbsr CHKACC set File Lock
 bcs MakDir90 ..abort if error
 endc

 ldd #DIR.SZ*2 room for two Dir Rcds
 std PD.SIZ+2,Y
 bsr WrtFDS90 write FD sector
 bcs MakDir90 error; abort
 lbsr EXPAND allocate first two entries
 bcs MakDir90 error; abort
 ldu PD.BUF,Y FD buffer ptr
 lda FD.ATT,u get file attributes
 ora #DIR. mark as dir
 sta FD.ATT,u update FD
 bsr WrtFDSiz update size in FD sector
 bcs MakDir90
 lbsr ZerBuf clear first dir sector
 ldd #"..+$80
 std 0,U Parent Dir name, '..'
 stb DIR.SZ,U Current Dir name, '.'
 lda PD.DFD,Y get parent dir FD psn
 sta DIR.FD,U put in new dir
 ldd PD.DFD+1,Y
 std DIR.FD+1,U
 lda PD.FD,Y get new dir FD psn
 sta DIR.FD+DIR.SZ,U put in new dir
 ldd PD.FD+1,Y
 std DIR.FD+1+DIR.SZ,U
 lbsr PCPSEC write first sector
MakDir90 bra KillPth1


***************
* Subroutine WrtFDSiz
*   Update file size in FD sector.  Called by Create, Makdir.

WrtFDSiz lbsr GETFD read FD
 ldx PD.BUF,Y
 ldd PD.SIZ,Y
 std FD.SIZ,X
 ldd PD.SIZ+2,Y update file size in FD
 std FD.SIZ+2,X
 clr PD.SMF,Y clear buffer contents flag
WrtFDS90 lbra PUTFD rewrite FD sector

 page
***************
* Subroutine Close
*   Close Path, Update FD if necessary

Close clra init carry clear
 tst PD.CNT,Y last image?
 bne Close99 ..No; exit, carry clear
 lbsr CLRBUF clear buffer
 bcs KillPth1 error; abort
 ldb PD.MOD,Y get mode
 bitb #WRITE. Write mode?
 beq KillPth1 ..No; return resources, exit
 ldd PD.FD,Y Using entire disk?
 bne Close10 ..No; trim file
 lda PD.FD+2,Y entire disk?
 beq KillPth1 ..Yes; exit (carry clear)
Close10 bsr WrtFDSiz write filesize
 lbsr EOFTest at End of File?
 bcc KillPth1 ..No; don't trim file
 lbsr TRIM Trim file size
 bra KillPth1 exit, return error status
Close99 rts

IllAcces ldb #E$FNA Err: file not accesible
KillPth0 coma set carry

KillPth puls y restore PD
KillPth1 pshs B,CC save error status
 ldu PD.BUF,Y get buffer ptr
 beq KillPth9
 ldd #$100 return one page
 os9 F$SRtMem Return memory

 ifeq RCD.LOCK-included
 ldx PD.Exten,Y get Extension ptr
 beq KillPth9
 lbsr Remove Remove path from rcd-lock lists
 lda 0,X (A)=PE number
 ldx D.PthDBT
 os9 F$Ret64 return path extension
 endc

KillPth9 puls PC,B,CC return error status

 page
***************
* Subroutine DateMod
*  Update Date last modified in FD

* Passed: (Y)=PD
* Returns: (U)=Buffer ptr, FD sector in buffer
* Destroys: CC,D,X

DateMod lbsr GETFD read FD sector
 ldu PD.BUF,Y
 lda FD.LNK,U Link count

 ifeq LEVEL-1
 pshs a
 leax FD.DAT,U
 os9 F$Time Set time last modified
 puls a
 else
 ldx D.Proc current process ID
 pshs x,a save them
 ldx D.SysPrc
 stx D.Proc make system current process
 leax FD.DAT,U
 os9 F$Time Set time last modified
 puls x,a
 stx D.Proc
 endc

 sta FD.LNK,U
 rts

***************
* Subroutine Chgdir
*   Change User'S Current Working Dir

* Passed: (Y)=PD

ChgDir pshs Y save PD
 lda PD.MOD,Y get mode
 ora #DIR. set dir mode
 sta PD.MOD,Y
 lbsr Open open file
 bcs KillPth error; abort
 ldx D.Proc get process ptr
 lda PD.DRV,Y get drive number
 ldu PD.FD+1,Y get lsbs of FD psn
 ldb PD.MOD,Y get mode
 bitb #READ.+WRITE. R/W dir?
 beq ChgDir10 ..no
 ldb PD.FD,Y FD psn msb
 std P$DIO+2,X set default
 stu P$DIO+4,X
ChgDir10 ldb PD.MOD,Y get mode
 bitb #EXEC. execution dir?
 beq ChgDir90 ..no; exit
 ldb PD.FD,Y FD psn msb
 std P$DIO+8,X set default
 stu P$DIO+10,X Set up default dir
ChgDir90 clrb clear carry
 bra KillPth return resources; exit

 page
***************
* Subroutine Delete
*   Remove file from Dir, return storage if link count zero.

Delete pshs y Save PD
 lbsr SchDir Allocate buffer, search dir
 bcs KillPth error; abort
 ldd PD.FD+1,Y trying to delete disk?
 bne Delete10 ..No; continue
 tst PD.FD,Y
 lbeq IllAcces ..Yes; abort
Delete10 lda #WRITE.+SHARE.
 lbsr CHKACC file accessible for write?
 bcs Delete99 ..No, abort
 ldu PD.RGS,Y get register package
 stx R$X,U return updated pathlist ptr
 lbsr GETFD
 bcs Delete99 error; abort
 ldx PD.BUF,Y get buffer ptr
 dec FD.LNK,X Count link down, last use?
 beq Delete15 ..Yes; remove file
 lbsr PUTFD rewrite FD
 bra Delete20 exit

Delete15 clra
 clrb
 std PD.SIZ,Y
 std PD.SIZ+2,Y
 lbsr TRIM Trim file down
 bcs Delete99 error; abort
 ldb PD.FD,Y
 ldx PD.FD+1,Y FD addr
 stb PD.SBP,Y Set seg addr
 stx PD.SBP+1,Y
 ldx PD.BUF,Y FD ptr
 ldd FD.SEG+FDSL.B,X get first seg size
 addd #1 Add FD size
 std PD.SSZ+1,Y Set seg
 lbsr SECDEA Deallocate sectors

Delete20 bcs Delete99 error; abort
 lbsr CLRBUF clear buffer
 lbsr Remove exit from file's rcd-lock list
 lda PD.DFD,Y
 sta PD.FD,Y return to parent dir
 ldd PD.DFD+1,Y
 std PD.FD+1,Y
 lbsr Insert place in parent's rcd-lock list
 lbsr GETFD
 bcs Delete99 ..error; abort
 lbsr InitPD10 init PD for dir
 ldd PD.DCP,Y restore rcd addr
 std PD.CP,Y
 ldd PD.DCP+2,Y
 std PD.CP+2,Y
 lbsr RdCurDir access dir rcd
 bcs Delete99 error; abort
 clr 0,X Mark dir entry unused
 lbsr PCPSEC Rewrite sector
Delete99 lbra KillPth return resources; exit


***************
* Subroutine Seek
*   Change Path's current posn ptr
* Flush buffer is (not empty and ptr moves to new sector)

Seek ldb PD.SMF,Y get flags
 bitb #SINBUF sector in buffer?
 beq Seek15 ..No

* Seek Position In Current Sector?
 lda R$X+1,U get middle byte of seek
 ldb R$U,U get lsb seek posn
 subd PD.CP+1,Y Subtract current posn
 bne Seek10 ..Not current sector
 lda R$X,U get msb seek posn
 sbca PD.CP,Y
 beq Seek20 bra if current sector

* Clear buffer & set posn
Seek10 lbsr CLRBUF Clear sector buffer
 bcs Seek99
Seek15 ldd R$X,U get msb seek posn
 std PD.CP,Y Set current posn
Seek20 ldd R$U,U get lsb seek posn
 std PD.CP+2,Y Set current posn
Seek99 rts

 page
***************
* Stacked temporaries used by RBRW
 org 0
S.Destin rmb 2 User's Source/Destination ptr
S.BytCnt rmb 2 Byte Count
S.RWexit rmb 2 R/W endloop addr
S.RWaddr rmb 2 R/W subroutine addr
StkTemps set .

***************
* Subroutine ReadLn

ReadLn bsr ReadInit Chk conflicts; EOF; maximum
 beq RDLine0 Read 0 bytes? .. exit; carry cleared by ReadInit
 bsr ReadLn10 Init S.RWaddr on stack

* Read Line Subroutine
*   Move Bytes from Buffer to Destination up to carriage return

* Returns: 2,S (caller' top of stack)=Byte count

 pshs U,Y,X,D save regs
 exg X,U
 ldy #0 init bytecount
 lda #C$CR
RDLine10 leay 1,Y increment bytecount
 cmpa ,X+ carriage return in buffer?
 beq RDLine20 ..Yes; end of data
 decb decrement requested bytecount
 bne RDLine10 Repeat if not exhausted
RDLine20 ldx 6,S restore source ptr
 bsr ToUser copy bytes to caller's addr space
 sty 10,S return bytes actually transferred
 puls U,Y,X,D restore regs
 ldd 2,S
 leax D,X update caller's destination ptr
RDLine0 rts

ReadLn10 lbsr RBRW00 Init S.RWexit; enter RBRW

* Read Line End Of Loop
*  Entered with ALL StkTemps on stack

 ifeq LEVEL-1
 lda ,-x
 else
 leax -1,X
 lbsr UserByte get last byte transferred
 endc

 cmpa #C$CR carriage return?
 beq ReadLn20 ..Yes; done
 ldd S.BytCnt,S get remaining maximum
 lbne RBRW10 ..non-zero; read next sector
ReadLn20 ldu PD.RGS,Y get register ptr
 ldd R$Y,U get maximum
 subd S.BytCnt,S Subtract remaining maximum
 std R$Y,U Return bytes transferred
 bra Read90 ..exit (carry clear)

 page
***************
* Subroutine ReadInit
*   Initialize Path for Read/Readline request

* Passed: (Y)=PD
*         (U)=User's register stack
* Returns: R$Y,U=max(requested, remaining) bytcnt
*          CC,B set if error occurs
* Destroys: D,X

ReadInit ldd R$y,U get requested bytecount
 ifeq RCD.LOCK-included
 lbsr Gain00 Determined Lock seq requested
 bcs ReadIERR ..return if not busy
 ldd R$Y,U get requested bytecount
 endc
 bsr RDSET EOF test & maximum check
 bcs ReadIERR error; abort (return to caller's caller)
 std R$Y,U save maximum byte count
 rts

***************
* Subroutine Rdset
* End of File Test & Maximum Check

* Passed: (D)=requested bytecount
*         (Y)=PD
* Returns: (D)=max(requested, remaining) bytecount
* Destroys: X

RDSET pshs D save requested bytecount
 ldd PD.SIZ+2,Y get bytes remaining
 subd PD.CP+2,Y from current posn
 tfr D,X Save lsdb
 ldd PD.SIZ,Y Do msdb
 sbcb PD.CP+1,Y
 sbca PD.CP,Y
 bcs RDSET80 end of file; exit
 bne RDSET10 bra if lots left
 tstb LOTS Left?
 bne RDSET10 ..Yes
 cmpx 0,S Remaining >= requested?
 bhs RDSET10 ..Yes
 stx 0,S Return bytes available
 beq RDSET80 ..None; return EOF
RDSET10 clrb clear Carry
 puls PC,D return

RDSET80 comb set Carry
 ldb #E$EOF Err: End of File
ReadIERR leas 2,S return scratch
 ifeq RCD.LOCK-included
 bra Read95
 else
 rts
 endc

 ifeq LEVEL-1
ToUser lbra FromUser
 else
***************
* Subroutine ToUser
*   Copy bytes to user's addr space

* Passed: (X)=system's source ptr
*         (Y)=bytecount
*         (U)=user's destination ptr
* Destroys: CC,D

ToUser pshs x
 ldx D.Proc
 lda D.SysTsk from system's addr space
 ldb P$Task,X to user's addr space
 puls X
 os9 F$Move copy bytes
 rts
 endc

***************
* Subroutine Read
*   Read Requested Bytes from Current Position

Read bsr ReadInit Chk conflicts; EOF; maximum
 beq Read0 Read 0 bytes? .. exit; carry cleared by ReadInit
 bsr Read1 init Read subroutine addr (S.RWaddr)

* Subroutine RdByte
*   Moce Bytes from Buffer to Destination

* Passed: (D)=bytecount
*         (X)=destination (in user's addr space)
*         (U)=source (in system's addr space=
* Returns: (X)=updated destination ptr

RdByte pshs U,Y,X,D save regs
 exg X,U
 tfr D,Y
 bsr ToUser move data to user's buffer
 puls U,Y,X,D restore regs
 leax D,X update destination ptr
Read0 rts

Read1 bsr RBRW00 Init S.RWexit; enter RBRW

*  Read/Write Loop End
 bne RBRW10 bra if more
Read90 clrb Clear Carry

RBRWER leas -2,S adjust stack
RBRWER1 leas StkTemps+2,S return stack
 ifeq RCD.LOCK-included
Read95 pshs B,CC Save error status
 lda PD.MOD,Y
 bita #WRITE. open for write or update?
 bne Read99 ..Yes; keep record locked out
 lbsr UnLock release everything
Read99 puls B,CC Restore error status
 endc
 rts
 page
***************
* Subroutine RBRW
*   Transfer Loop of Read & Write

*   S.Destin,S = Destination addr
*   S.BytCnt,S = Bytecount
*   S.RWexit,S = R/W subroutine addr
*   S.RWaddr,S = R/W endloop addr

RBRW00 ldd R$X,U Source/Destination ptr
 ldx R$Y,U Byte Count
 pshs X,D init S.Destin, S.BytCnt

* Main Transfer Loop
RBRW10 lda PD.SMF,Y get buffer flags
 bita #SINBUF Sector in buffer?
 bne RBRW25 ..Yes
 tst PD.CP+3,Y at sector bounday?
 bne RBRW20 ..No; read current sector
 tst S.BytCnt,S Bytecount greater than $100
 beq RBRW20 ..No; read current sector
 leax WrByte,PCR
 cmpx S.RWaddr,S Writing?
 bne RBRW20 ..No; pre-read sector
 lbsr CHKSEG Check seg ptrs
 bra RBRW22
RBRW20 lbsr RDCP get sector
RBRW22 bcs RBRWER error; abort
RBRW25 ldu PD.BUF,Y get buffer ptr
 clra
 ldb PD.CP+3,Y
 leau d,U get buffer ptr
 negb get Bytes in buffer
 sbca #-1
 ldx S.Destin,S get source ptr
 cmpd S.BytCnt,S Remaining > requested?
 bls RBRW30 ..No
 ldd S.BytCnt,S get requested
RBRW30 pshs D Save byte count
 jsr [S.RWaddr+2,S] Transfer bytes
 stx S.Destin+2,S Update source/destination
 ldb 1,S get count
 addb PD.CP+3,Y Update current posn
 stb PD.CP+3,Y
 bne RBRW35 ..bra if not end sector
 lbsr CLRBUF clear buffer (carry set if I/O error)
 inc PD.CP+2,Y update position
 bne RBRW34 bra if no carry
 inc PD.CP+1,Y Propagate carry
 bne RBRW34
 inc PD.CP,Y Propagate carry
RBRW34 bcs RBRWER1 abort if I/O error
RBRW35 ldd S.BytCnt+2,S get requested
 subd ,s++ Subtract transferred
 std S.BytCnt,S Update count
 jmp [S.RWexit,s] Go to end of loop

 page
***************
* Subroutine Writline
*   Write Bytes to carriage return or Maximum

WritLine pshs y Save PD
 clrb clear Carry
 ldy R$Y,U get maximum
 beq WritLn20 ..None; release current seg

 ifeq LEVEL-1
 ldx R$X,u Get address of buffer to write to
WritLn10 leay -1,Y Count byte
 beq WritLn20 bra if maximum reached
 lda ,x+ get caller's next byte
 else
 ldx D.PROC
 ldb P$Task,X get caller's Task number
 ldx R$X,U get source ptr
WritLn10 leay -1,Y Count byte
 beq WritLn20 bra if maximum reached
 os9 F$LDABX get caller's next byte
 leax 1,X
 endc

 cmpa #C$CR Next byte carriage return?
 bne WritLn10 ..No
 tfr y,d Copy maximum
 nega get Negative bytes not transfered
 negb
 sbca #0
 addd R$Y,U Add maximum
 std R$Y,U Return bytes transfered
WritLn20 puls y Retrieve PD
* Fall through to Write

***************
* Subroutine Write
* Write Requested Bytes At Current Position

Write
 ifeq RCD.LOCK-included
 ldd R$Y,U get bytes requested
 lbsr Gain00 Dominate seg being written
 bcs Write99 ..error; abort
 endc

* Insure Sufficient File Allocated
 ldd R$Y,U bytes requested
 beq Write90 ..exit if no data to write
 bsr WriteSub expand file if necessary
 bcs Write99 error; abort
 bsr Write1 init Write subroutine addr (S.RWAddr)

* Subroutine WrByte
*   Move Bytes from Source to Buffer

* Passed: (D)=bytecount
*         (X)=source ptr (in caller's addr space)
*         (U)=destination ptr (in system addr space)
* Returns: (X)=updated source ptr

WrByte pshs Y,D save regs
 tfr D,Y
 bsr FromUser copy user's bytes into buffer
 puls Y,D
 leax D,X update source ptr
 lda PD.SMF,Y get buffer flags
 ora #BUFMOD+SINBUF Mark buffer modified
 sta PD.SMF,Y
 rts

Write1 lbsr RBRW00 init S.RWexit; enter RBRW

* Write Loop Exit
* Note: entered with ALL StkTemps initialized
 lbne  RBRW10 bra if more
 leas StkTemps,S return Scratch

 ifeq RCD.LOCK-included
 ldy PD.Exten,Y switch to extension
 lda #RcdLock
 lbsr Release release current seg
 ldy PE.PDptr,Y switch back to PD
 endc
Write90 clrb return without error
Write99 rts

***************
* Subroutine WriteSub
*   Update current position, expand file if needed

* Passed: (D)=Bytes written
*         (Y)=PD
* Returns: CC,B=Error status
* Destroys: D,X

WriteSub addd PD.CP+2,Y Add current posn
 tfr d,X Save lsdb
 ldd PD.CP,Y get msdb
 adcb #0
 adca #0

* (D,X)=new potential file size
WriteS10 cmpd PD.SIZ,Y greater than current size?
 bcs Write90 ..No; continue
 bhi WriteS80
 cmpx PD.SIZ+2,Y
 bls Write90 ..No; continue
WriteS80 pshs U save reg
 ldu PD.SIZ+2,Y
 stx PD.SIZ+2,Y Set new size
 ldx PD.SIZ,Y
 std PD.SIZ,Y
 pshs U,X save Old size
 lbsr EXPAND Expand file allocation
 puls U,X
 bcc WriteS90 exit if no error
 stx PD.SIZ,Y restore Old size
 stu PD.SIZ+2,Y
WriteS90 puls PC,U exit

 ifeq LEVEL-1
FromUser pshs u,y,x
         ldd 2,s
         beq   L0506
         leay  d,u
         lsrb
         bcc   L04EC
         lda   ,x+
         sta   ,u+
L04EC    lsrb
         bcc   L04F3
         ldd   ,x++
         std   ,u++
L04F3    pshs  y
         exg   x,u
         bra   L0500
L04F9    pulu  y,D
         std   ,x++
         sty   ,x++
L0500    cmpx 0,s
         bcs   L04F9
         leas 2,s
L0506    puls  PC,U,Y,X
 else
***************
* Subroutine FromUser
*   Move bytes from user's addr space into system space

* Passed: (X)=User's source addr
*         (Y)=bytecount
*         (U)=Systems destination addr
* Destroys: CC,D

FromUser pshs X save source ptr
 ldx D.PROC
 lda P$TASK,X from user's task space
 ldb D.SysTsk to system task space
 puls X retrieve source ptr
 os9 F$Move copy bytes
 rts
 endc

 page
***************
* Subroutine Getstat
*   Get Specific Status Information

GetStat ldb R$B,U get status code
 cmpb #SS.OPT options?
 beq GetS.B9 ..Yes
 cmpb #SS.EOF end of file?
 bne GetS.A ..No
 clr R$B,U clear flag
EOFTest clra
 ldb #1
 lbra RDSET Test for end of file

GetS.A cmpb #SS.Ready data ready?
 bne GetS.B No; continue
* Record Lock: Lockout next portion of file
 clr R$B,U clear flag (always ready)
 rts
GetS.B cmpb #SS.Size get size?
 bne GetS.C ..No
 ldd PD.SIZ,Y get file size
 std R$X,U Return to user
 ldd PD.SIZ+2,Y
 std R$U,U
GetS.B9 rts

GetS.C cmpb #SS.POS get posn?
 bne GetS.D ..No
 ldd PD.CP,Y get file current posn
 std R$X,U Return to user
 ldd PD.CP+2,Y
 std R$U,U
 rts

GetS.D cmpb #SS.FD Read FD sector?
 bne GetS.X ..No
 lbsr GETFD read FD sector
 bcs GetS.B9 ..error; abort
 ldu PD.RGS,Y
 ldd R$Y,U bytecount
 tsta
 beq GetS.D1
 ldd #256 maximum 256 bytes
Gets.D1 ldx R$X,U user's destination ptr
 ldu PD.BUF,Y
 lbra RdByte copy the bytes

GetS.X lda #D$GSTA get driver entry offset
 lbra DEVDIS

PutStat ldb R$B,U
 cmpb #SS.OPT set options?
 bne PSt100 ..No
 ldx R$X,U get options ptr
 leax PD.STP-PD.OPT,X ptr to changable options
 leau PD.STP,Y
 ldy #PD.SAS-PD.DRV
 lbra FromUser copy options from user

PSt100 cmpb #SS.Size change file size?
 bne PSt110 ..No
 ldd PD.FD+1,Y resetting "@" file?
 bne PSt100.A ..no; continue
 tst PD.FD,Y
 lbeq PStErr ..Yes; abort (?)
PSt100.A lda PD.MOD,Y get path mode
 bita #WRITE. open for write?
 beq PSt100.D ..No; abort
 ldd R$X,U
 ldx R$U,U (D,X)=Desired file size
 cmpd PD.SIZ,Y Trim needed?
 bcs PSt100.C ..Yes
 bne PSt100.B ..No
 cmpx PD.SIZ+2,Y Trim needed?
 bcs PSt100.C ..Yes
PSt100.B lbra WriteS10 Expand file

PSt100.C std PD.SIZ,Y
 stx PD.SIZ+2,Y
 ldd PD.CP,Y save current position
 ldx PD.CP+2,Y
 pshs x,D
 lbsr TRIM trim file size
 puls U,X
 stx PD.CP,Y restore current position
 stu PD.CP+2,Y
 rts

PSt100.D comb
 ldb #E$BMode Error; bad mode
 rts

PSt110 cmpb #SS.FD write FD option?
 bne PSt200 ..no
 lda PD.MOD,Y
 bita #WRITE. open for write?
 beq PSt100.D ..no; abort
 lbsr GETFD read FD sector
 bcs Return99 ..abort if error
 pshs y save User ID, PD ptr
 ldx R$X,U get user's addr
 ldu PD.BUF,Y FD buffer addr
 ldy D.Proc Get process descriptor
 ldd P$User,Y get user ID; Super User?
 bne PSt110.A ..No
 ldd #FD.OWN*256+2 copy 2 FD.OWN bytes
 bsr PSt110.C
PSt110.A ldd #FD.DAT*256+5 copy 5 FD.DAT bytes
 bsr PSt110.C
 ldd #FD.Creat*256+3 copy 3 FD.Creat bytes
 bsr PSt110.C
 puls y restore PD ptr
 lbra PUTFD update FD

PSt110.C pshs U,X save regs
 leax A,X (X)=ptr to user's bytes
 leau A,U (U)=pre to FD posn
 clra
 tfr D,Y bytecnt
 lbsr FromUser get user id
 puls PC,U,X return

PSt200
 ifeq RCD.LOCK-included
 cmpb #SS.Lock Record Lock?
 bne PSt300 ..No
 ldd R$U,U get lsb size desired
 ldx R$X,U get msb size
 cmpx #$FFFF Lock entire file?
 bne PSt200.A ..No
 cmpx R$U,U
 bne PSt200.A ..No
 ldu PD.Exten,Y get PE ptr
 lda PE.Lock,U
 ora #FileLock
 sta PE.Lock,U request file lockout
 lda #$FF
PSt200.A lbra Gain Gain segment requested

PSt300 cmpb #SS.Ticks set Gain Delay interval?
 bne PSt999 ..No
 ldd R$X,U get interval
 ldx PD.Exten,Y
 std PE.TmOut,X set it
 rts (carry clear)
 endc

* Pass putstat to driver
PSt999 lda #D$PStA get putstat entry
 lbra DEVDIS Call driver

PStErr comb Return Carry set
 ldb #e$unksvc Error: unknown service code
Return99 rts


 ttl Internal Routines
 page
***************
* Subroutine SchDir
*   Select Directory & Search it
* If pathlist found, PD.FD will be the requested path
* Else, PD is in list of failing dir; at EOF

* Passed: (X)=Pathlist ptr
*         (Y)=PD
* Returns: (A)=last pathlist delimiter found
*          (X)=updated pathlist ptr
*          (U)=ptr to next pathlist element
* Error: CC=carry set, B=error code
* Destroys: D

 org 0 Stack temporaries
S.Delim rmb 1 current delimiter char
S.NameSz rmb 1 pathlist name size
S.RcdPtr rmb 2 abs addr of dir rcd found
S.PathPt rmb 2 (X) current pathptr
S.PD rmb 2 (Y) PD
S.NextPt rmb 2 (U) ptr to next pathlist element
StkTemps set .

*   Allocate Buffers, get Pathname, Search Dir, Update pathptr
SchDir ldd  #$100 get one page
 stb PD.SMF,Y Clear flags
 os9 F$SRqMem Request memory
 bcs Return99 Error; abort
 stu PD.BUF,Y Save buffer ptr

 ifeq RCD.LOCK-included
 leau 0,Y save PD
 ldx D.PthDBT
 os9 F$All64 allocate Path Extention block
 exg Y,U (Y)=PD, (U)=PE ptr
 bcs Return99 error; abort
 stu PD.Exten,Y save extension ptr
 sty PE.PDptr,U save back ptr to PD
 stu PE.Wait,U initialize Waiting queue (ring)
 endc

 ldx PD.RGS,Y get user register package
 ldx R$X,X get pathptr

* Select Dir
 pshs U,Y,X init S.PathPt, S.PD
 leas S.Delim-S.PathPt,S allocate remaining temps
 clra
 clrb
 sta PD.FD,Y clear FD posn
 std PD.FD+1,Y
 std PD.DSK,Y clear disk ID

 ifeq LEVEL-1
 lda 0,x
 else
 lbsr UserByte get first pathlist byte
 endc

 sta S.Delim,S
 cmpa #PDELIM Device specified?
 bne SchDir20 ..No; continue
 lbsr RBPNam Parse device name
 sta S.Delim,S save delimiter char
 lbcs DirErr ..abort if illegal name
 leax 0,Y skip device name
 ldy S.PD,S restore PD
 bra SchDir30 default root dir

* Default dir used; determine FD sector
SchDir20 anda #$7F strip ms bit
 cmpa #PENTIR entire device?
 beq SchDir30 ..Yes; use sector zero as FD
 lda #PDELIM ..No; delim=pathlist separator
 sta S.Delim,S
 leax -1,X back up to psuedo path delim
 lda PD.MOD,Y caller's I/O mode
 ldu D.Proc caller's process desc
 leau P$DIO,U ptr to R/W default I/O
 bita #PEXEC.+EXEC. Execute requested?
 beq SchDir25
 leau 6,U Skip to execution default I/O
SchDir25 ldb 3,U
 stb PD.FD,Y ..default dir msb
 ldd 4,U
 std PD.FD+1,Y ..default dir lsb's

* Initial dir has been found
SchDir30 ldu PD.DEV,Y copy device tbl ptr for user
 stu PD.DVT,Y
 lda PD.DRV,Y compute Drive Tbl ptr
 ldb DTBSiz,pcr
 mul
 addd V$STAT,U
 addd  #DRVBEG
 std PD.DTB,Y save Drive Tbl ptr
 lda S.Delim,S get last delimiter
 anda #$7F strip ms bit
 cmpa #PENTIR Entire device?
 bne SchDir35
 leax 1,X ..Yes; skip "@" char
 bra SchDir50 ..don't init from sector zero

SchDir35 lbsr GETDD read sector zero
 lbcs DirErr10 error; abort
 ldu PD.BUF,Y buffer ptr
 ldd DD.DSK,U save disk ID for continuity check
 std PD.DSK,Y
 ldd PD.FD+1,Y Default dir used?
 bne SchDir50 ..Yes
 lda PD.FD,Y
 bne SchDir50 ..Yes
 lda DD.DIR,U ..No; use root dir FD
 sta PD.FD,Y
 ldd DD.DIR+1,U
 std PD.FD+1,Y

* While not end of pathlist Do
SchDir50 stx S.PathPt,S save pathlist ptr
 stx S.NextPt,S save next ptr
SchDir60 lbsr CLRBUF clear buffer
 lbsr Insert insert to new file, clear ptrs
 bcs DirErr10 ..Error; abort
 lda S.Delim,S get last delimiter
 cmpa #PDELIM end of pathlist?
 bne SchDir85 ..Yes; path is found, exit
 clr S.RcdPtr,S
 clr S.RcdPtr+1,S
 lda PD.MOD,Y get desired I/O mode
 ora #DIR.
 lbsr CHKACC is dir accesible?
 bcs DirErr ..No; abort
 lbsr InitPD10 init PD
 ldx S.NextPt,S
 leax 1,X skip PDELIM char
 lbsr RBPNam Parse next pathlist element
 std S.Delim,S save delim char; name size
 stx S.PathPt,S save name ptr
 sty S.NextPt,S save ptr to next element
 ldy S.PD,S restore PD
 bcs DirErr ..abort if illegal name
 lbsr RdCurDir read current(first) dir rcd
 bra SchDir80

* Repeat until name found, or error
SchDir70 bsr SaveDel Save deleted entry if appropriate
SchDir75 bsr RdNxtDir read next dir rcd
SchDir80 bcs DirErr ..exit if error of EOF
 tst 0,X deleted entry?
 beq SchDir70 ..Yes; record it
 leay 0,X
 ldx S.PathPt,S pathname ptr
 ldb S.NameSz,S get name size
 clra
 os9 F$CmpNam Pathname found in dir?
 ldx S.PD,S PD
 exg X,Y
 bcs SchDir75 ..No; keep searching
 bsr SaveDir Save dir ptr
 lda DIR.FD,X
 sta PD.FD,Y
 ldd DIR.FD+1,X
 std PD.FD+1,Y
 lbsr Remove remove from prev rcd lock list
 bra SchDir60 ..move to next pathname

SchDir85 ldx S.NextPt,S retrieve updated pathlist ptr
 tsta sign bit on last byte?
 bmi SchDir90 ..no; return updated pathlist ptr
 os9 F$PrsNam skip pathlist delimiter
 leax 0,Y
 ldy S.PD,S restore PD
SchDir90 stx S.PathPt,S
 clra return carry clear
SchDir99 lda S.Delim,S return last delimiter char
 leas S.PathPt,S return temps
 puls PC,U,Y,X return (X)=updated pathptr

* (Y)=PD, (B)=Error Code
DirErr cmpb #E$EOF end of file?
 bne DirErr10 ..No; abort
 bsr SaveDel save end as next free; if not found
 ldb #E$PNNF Return "Pathname not found"
DirErr10 coma return carry set
 bra SchDir99 abort

 page
***************
* Subroutine SaveDel, SaveDir
*   Save the current dir file ptr

* Passed: (X)=rcd ptr
*         (Y)=PD
* Returns: none
* Destroys: CC
* Updates: S.RcdPtr, PD.DFD, PD,DCP

* SaveDel: saves the first deleted entry found during create.
* It is unnecessary for OPEN (possible optimization).

SaveDel pshs D save reg
 lda S.Delim+4,S
 cmpa #PDELIM is this the last pathlist element?
 beq SaveD99 ..No; exit
 ldd S.RcdPtr+4,S has a deleted entry been found?
 bne SaveD99 ..Yes; exit
 puls D

SaveDir pshs D save reg
 stx S.RcdPtr+4,S save current Dir Rcd ptr
 lda PD.FD,Y
 sta PD.DFD,Y
 ldd PD.FD+1,Y save dir FD sector
 std PD.DFD+1,Y
 ldd PD.CP,Y
 std PD.DCP,Y
 ldd PD.CP+2,Y save current file posn
 std PD.DCP+2,Y
SaveD99 puls PC,D exit

 page
***************
* Subroutine RdNxtDir
*   Read Current or next dir rcd

* Passed: (Y)=PD
* Returns: (X)=Dir Rcd ptr
* Destroys: (D)
* Error: CC=carry set
*       (B)=Error code

RdNxtDir ldb PD.CP+3,Y update current posn
 addb #DIR.SZ to next dir rcd
 stb PD.CP+3,Y End of current sector?
 bcc RdCurDir ..No; read current sector
 lbsr CLRBUF clear buffer
 inc PD.CP+2,Y propagate carry
 bne RdCurDir
 inc PD.CP+1,Y
 bne RdCurDir
 inc PD.CP,Y

RdCurDir ldd #DIR.SZ size of one dir entry
 lbsr RDSET eof test
 bcs RdNxtD90

 ifeq RCD.LOCK-included
 ldd #DIR.SZ
 lbsr Gain00 Dominate current dir sector
 bcs RdNxtD90 ..File is busy; ABORT
 endc

 lda PD.SMF,Y
 bita #SINBUF is current sector in buffer?
 bne RdNxtD20 ..yes; return updated rcd ptr
 lbsr CHKSEG get current seg ptr
 bcs RdNxtD90 ..exit if EOF or error
 lbsr RDCP read current buffer posn
 bcs RdNxtD90 ..I/O error; abort
RdNxtD20 ldb PD.CP+3,Y get LSB rcd ptr
 lda PD.BUF,Y get MSB rcd ptr
 tfr D,X
 clrb return carry clear
RdNxtD90 rts

 page
 ifne LEVEL-1
***************
* Subroutine UserByte
*   Return byte from (0,X) in caller's memory

* Passed: (X)=ptr to user's addr
* Returns: (A)=byte at that addr
* Destroys: CC

UserByte pshs u,x,b save regs
 ldu D.Proc
 ldb P$Task,U get user's task number
 os9 F$LDABX retrieve byte
 puls PC,U,X,B
 endc

***************
* Subroutine RBPNam
*   Parse a legal RBF pathlist element

* Passed: (X)=pathlist ptr
* Returns: (A) = S.Delim = delimiter char
*          (B) = S.NameSz = name size
*          (X) = S.PathPt = updated past optional "/"
*          (Y) = S.NextPt = next pathlist ptr
* Error: CC=Carry set
*        (B)=E$bpnam (Bad Pathname Error)

RBPNam os9 F$PrsNam parse normal pathname
 pshs x save ptr
 bcc RBPNam99 ..Return if valid pathname
 clrb NameSize = 0
RBPNam10 pshs a save delim char
 anda #$7F strip MSB
 cmpa #PDIR Dir (".") name?
 puls a restore delim char
 bne RBPNam80 ..no; exit
 incb update NameSize
 leax 1,X update pathlist ptr
 tsta is MSB set (end of pathlist)?
 bmi RBPNam80 ..Yes; exit

 ifeq LEVEL-1
 lda 0,x
 else
 bsr UserByte get next user byte at (0,X)
 endc

 cmpb #3 less than 3 bytes examined?
 blo RBPNam10 ..Yes; check for parental signal

* The pathlist contains "..." (grandparent).  Code here
* makes this look like "../.." for any number of dots.
 lda #PDelim return "/" as delimiter
 decb return NameSize=2
 leax -3,X skip only the first dot

RBPNam80 tstb any pathlist found?
 bne RBPNam90 ..Yes; return it
 comb
 ldb #E$bpnam error; Bad Pathname
 puls PC,X abort
RBPNam90 leay 0,X return (Y)=next pathptr
 andcc #^carry return carry clear
RBPNam99 puls PC,X
 page
***************
* Subroutine ChkAcc
*   Check File Accessibility

* Passed: (A)=desired mode
*         (Y)=PD
* Returns: CC,B set if file inaccessable
* Destroys: D

CHKACC tfr A,B copy desired mode
 anda #EXEC.+UPDAT. get r/w/e bits
 andb #DIR.+SHARE. get dir and sharable bit
 pshs X,D Save them
 lbsr GETFD
 bcs CHKAbt error; abort
 ldu PD.BUF,Y get buffer ptr
 ldx D.Proc get process ptr
 ldd P$USER,X get process user
 beq ChkAcc05 .."Super" user owns ALL files
 cmpd FD.OWN,U Process owner = file owner ?
ChkAcc05 puls A Retrieve r/w/e bits
 beq CHKA10 bra if owned
 asla SHIFT to public permission posn
 asla
 asla
CHKA10 ora 0,S Set dir bit
 anda #^SHARE. strip sharable bit
 pshs a Save requested mode
 ora #DIR. Match dir request
 anda FD.ATT,U get common bits
 cmpa 0,S Common = desired ?
 beq CHKA20 continue if accessible
 ldb #E$FNA Err: file not accesible
CHKAbt leas 2,S
 coma set Carry
 puls PC,X

CHKAErr ldb #E$Share non-sharable file busy
 bra CHKAbt abort

CHKA20

 ifeq RCD.LOCK-included
 ldb 1,S
 orb FD.ATT,U
 bitb #SHARE. non-sharable file, or request?
 beq CHKA90 ..No; exit
 ldx PD.Exten,Y
 cmpx PE.Confl,X empty conflict list?
 bne CHKAErr ..Inaccessible if not
 lda #FileLock
 sta PE.Lock,X Lockout Entire File
 endc
CHKA90 puls PC,X,D return (carry clear)

 ifeq RCD.LOCK-included
 ttl Record Locking Subroutines
 page
***************
* Subroutine Insert
*   Add path to file list Structure

* Passed: (Y)=PD of File to insert
* Returns: B=error code, CC=Carry set if error
* Destroys: D

Insert pshs U,Y,X save regs
 clra
 clrb
 std PD.CP,Y
 std PD.CP+2,Y clear current posn
 sta PD.SSZ,Y
 std PD.SSZ+1,Y clear current seg size
 ldb PD.FD,Y
 ldx PD.FD+1,Y
 pshs x,b save desired file's FD sector
 ldu PD.DTB,Y (U)=Drive Table ptr in device static
 ldy PD.Exten,Y Switch to PD extension
 sty PE.Confl,Y Next Conflict=Self (none)
 leau V.FileHd-PE.NxFil,U make static look like head PE
 bra Insert20

Insert10 ldu PE.NXFil,U move to next file in list
* (Y)=PE ptr to file to be inserted
* (U)=PE ptr to previous PE in File List
Insert20 ldx PE.NXFil,U End of File list?
 beq Insert80 ..Yes; extend File List with Self
 ldx PE.PDptr,X get PD (X)=PD of next file
 ldd PD.FD,X
 cmpd 0,S Next file below file to be inserted
 bcs Insert10 ..below; keep searching list
 bhi Insert80 ..above; insert
 ldb PD.FD+2,X
 cmpb 2,S
 bcs Insert10 ..below; keep searching list
 bhi Insert80 ..above; insert

* Equal -File List already contains this file
 ldx PD.Exten,X PE of list member found
 lda PE.Lock,Y
 bita #FileLock sharable?
 bne SharErr ..No; abort
 sty PE.NxFil,Y Insert file NOT on File List
 ldd PE.Confl,X Link file into conflict list
 std PE.Confl,Y
 sty PE.Confl,X
 bra Insert90 ..Exit; no error

* Insert new file into file list
* (Y)=PE ptr to file to insert
* (U)=PE ptr to predecessor in File list
Insert80 ldx PE.NxFil,U
 stx PE.NxFil,Y Inserted File --> tail of list
 sty PE.NxFil,U Predecessor --> Inserted File
Insert90 clrb
Insert99 leas 3,S
 puls PC,U,Y,X return carry clear

SharErr comb
 ldb #E$Share ..Error; Non-sharable file in use
 bra Insert99 abort
 page
***************
* Subroutine Remove
*   Remove path from conflict lists

* Passed: (Y)=PD of path to remove
* Returns: none
* Destroys: CC

Remove pshs U,Y,X,D save regs
 ldu PD.DTB,Y
 leau V.FileHd-PE.NxFil,u (U)=psuedo PE Head of file list
 ldx PD.Exten,Y switch to path extension
 leay 0,X
 bsr RelsALL release any locked out seg
 bra Remove20

Remove10 ldx PE.Confl,x move to next path in conflict list
 beq Remove90 ..file not in conflict list; exit
Remove20 cmpy PE.Confl,X find predecessor PE in list
 bne Remove10 ..loop until found
 ldd PE.Confl,Y
 std PE.Confl,X remove path from circular conflict list
 bra Remove40

* Remove from File List if member
Remove30 ldu PE.NxFil,U move to next path in file list
Remove40 ldd PE.NxFil,U End of file List?
 beq Remove90 ..Yes; Exit -not on File List
 cmpy PE.NxFil,U
 bne Remove30 repeat until predecessor found

* (U)=ptr to predecessor of (Y) on File List
 ldx PE.NxFil,Y
 cmpy PE.Confl,Y Single entry Conflict List?
 beq Remove50 ..Yes; remove file from list
 ldx PE.Confl,Y
 ldd PE.NxFil,Y
 std PE.NxFil,X
Remove50 stx PE.NxFil,U
Remove90 sty PE.Confl,Y clear Conflict ptr
 puls PC,u,y,x,D return

 ttl Release -Unlock Current Segment
 page
***************
* Subroutine Release
*   Remove protection(s) from file
* Wake Up any other processes waiting for seg

* Passed: (A)=mode to release
*         (Y)=PE ptr of path to release
* Destroys: CC

RelsALL lda #RcdLock+FileLock+EofLock
Release pshs U,Y,X,D save regs
 bita PE.Lock,Y Checked Locked Status
 beq Releas05 ..Not releasing anything; exit
 coma
 anda PE.Lock,Y strip released bits
 sta PE.Lock,Y Release lock
 bita #FileLock entire file locked out?
 bne Releas90 ..Yes; keep it
Releas05 leau 0,Y
Releas10 ldx PE.Wait,U
 cmpy PE.Wait,U end of queue?
 beq Releas85 ..Yes; exit
 stu PE.Wait,U erase link
 leau 0,X
 lda PE.Owner,U sleeper's Current Process ID
 ldb #S$Wake
 os9 F$Send send Wake Up Call
 bra Releas10 Wake up All contenders

Releas85 stu PE.Wait,U initialize last link
Releas90 puls PC,U,Y,X,D return

LckSegER comb
 ldb #E$Share
UnLock pshs Y,B,CC save error status, PD
 ldy PD.Exten,Y switch to PE
 bsr RelsALL
 puls PC,Y,B,CC exit

 ttl Gain - Determined file lockout
 page
***************
* Subroutine Gain
*   Determined Lockout

* Passed: X,D=Byte count to lock out
*         (Y)=PD
* Returns: CC set, (B)=error code
* Destroys: D,X

Gain00 ldx #0
 bra Gain

Gain10 ldu PD.Exten,Y
 lda PE.Req,U Restore requested bits
 sta PE.Lock,U
 puls u,y,x,D restore regs
Gain pshs  u,y,x,D save regs (Entry Pt)
 ldu PD.Exten,Y
 lda PE.Lock,U Save requested lock bits
 sta PE.Req,U
 lda 0,S Restore MS byte of size
 lbsr LockSeg Lock out seg requested
 bcc Gain90 ..success; return
 ldu D.Proc
 lda PE.Owner,X (A)=Proc ID of conflict's owner
Gain20 os9 F$GProcP get (Y)=owners's Process Desc ptr
 bcs Gain40 ..error; Strange -assume ok
 lda P$DeadLk,Y also waiting?
 beq Gain40 ..No; continue
 cmpa P$ID,U Does it lead to ME?
 bne Gain20 ..No; check next

* Deadly Embrace threat.
* (X)=Dominant PE ptr
* (U)=D.Proc
 ldb #E$DeadLk return Deadlock error
 bra GainErr

* Enter Lockout Waiting Queue
* (U)=D.Proc
* (X)=Dominant PE
Gain40 lda PE.Owner,X Owner's process ID
 sta P$DeadLk,U save for deadlock chk
 bsr UnQueue Unlink anybody asleep in IOQue
 ldy 4,S restore PD

 ldu PD.Exten,Y
 ldd PE.Wait,X
 stu PE.Wait,X link into Waiting queue
 std PE.Wait,U finish linking into queue
 ldx PE.TmOut,U maximum tick count to wait
 os9 F$Sleep wait for record
 pshs X save tick count remaining
 leax 0,U copy PE ptr
 bra Gain55

Gain50 ldx PE.Wait,X move to next element in ring
Gain55 cmpu PE.Wait,X found one pointing to this?
 bne Gain50 ..No; round about
 ldd PE.Wait,U
 std PE.Wait,X unlink
 stu PE.Wait,U
 puls x restore tick count remaining
 ldu D.Proc
 clr P$DeadLk,U erase Deadlock check
 lbsr ChkSignl Interrogate wake up
 bcs GainErr ..abort if error
 leax 0,X Time elapsed?
 bne Gain10 ..No; try again
 ldu PD.Exten,Y (U)=PE ptr
 ldx PE.TmOut,U waiting indefinately?
 beq Gain10 ..Yes; try again
 ldb #E$Lock ..No; Record Lock error
GainErr coma set carry
 stb 1,S return (B)=error code
Gain90 puls PC,U,Y,X,D exit

*******************
* Subroutine UnQueue
*   Wake next process in I/O queue (if any)
*
* Passed: none
* Destroys: D,CC

UnQueue pshs Y,X Save regs
 ldy D.Proc
 bra UnQue80 While not last proc in IO Queue

UnQue10 clr P$IOQN,Y Clear next ptr
 ldb #S$Wake
 os9 F$Send

 ifeq LEVEL-1
 jmp NOWHERE code no available
 else
 os9 F$GProcP Find next process descriptor
 endc

 clr P$IOQP,Y clear previous link in next
UnQue80 lda P$IOQN,Y Process ID of next process
 bne UnQue10 Endwhile
 puls PC,Y,X

 ttl LockSeg -Lock out file seg
 page
***************
* Subroutine LockSeg
*   Lock out given number of bytes at current posn

LockSeg std -2,S Zero byte count requested?
 bne LckSeg10 ..No; continue
 cmpx #0 (cc=clear)
 lbeq UnLock ..Yes; release all locks
LckSeg10 bsr Conflct seg busy?
 lbcs LckSegER ..Yes; abort
 pshs u,y,X save regs
 ldy PD.Exten,Y switch to path extension
 lda #RcdLock
 lbsr Release Unlock any of file owned
 ora PE.Lock,Y set RcdLock bit
 sta PE.Lock,Y Lock Out Record
 clrb return carry clear
 puls PC,U,Y,X return (X)=Dominant PE ptr

 ttl RBF Record lock Conflict recognition
 page
***************
* Subroutine Conflct
*   Determines if rcd lockout conflict will occur
* Eliminates conflicts where possible

* Passed: X,D=ByteCnt Desired
*         (Y)=PD
*             PD.CP,Y =Beginning logical I/O byte
* Returns: (X)=Dominant PE ptr
* Error: CC=carry set if rcd is locked/unavailable
* Destroys: none

Conflct pshs  U,Y,D save regs
 leau 0,Y copy PD ptr
 ldy PD.Exten,Y Switch to Path Extension (PE)
 subd #1
 bcc Conflc05
 leax -1,X
Conflc05 addd PD.CP+2,U
 exg d,X
 adcb PD.CP+1,U
 adca PD.CP,U
 bcc Conflc10
 ldx #$FFFF overflow; default max
 tfr X,D
Conflc10 std PE.HiLck,Y init desired Hi lock
 stx PE.HiLck+2,Y

* Determine if EOF is required
 cmpd PD.SIZ,U
 bcs Conflc15 ..No
 bhi Conflc12 ..Yes
 cmpx PD.SIZ+2,U
 bcs Conflc15 ..No
Conflc12 lda PE.Lock,Y I/O involves EOF
 ora #EOFLock Request it
 sta PE.Lock,Y
 bra Conflc17 continue

Conflc15 lda #EOFLock End of file is not involved
 bita PE.Lock,Y Is EOFLock possesed?
 beq Conflc17 ..No; continue
 lbsr Release Release it if so

Conflc17 ldd PD.CP,U init desired Lo lock
 ldx PD.CP+2,U
 std PE.LoLck,Y
 stx PE.LoLck+2,Y
 lda PD.CPR,U get current process ID
 sta PE.Owner,Y save process ID of "owner"

 leax 0,Y
Conflc20 cmpy PE.Confl,X end of conflict list?
 beq Conflc90 ..Yes; return (no conflicts)
 ldx PE.Confl,X next potential conflict PE
 ldb PE.Owner,Y Same process owner test
 cmpb PE.Owner,X
 beq Conflc20 ..Yes; Ignore any conflict
 lda PE.Lock,X Other user have abything locked out?
 beq Conflc20 ..no, not a conflict
 ora PE.Lock,Y
 bita #FileLock Either user want entire file?
 bne Conflc85 ..Yes; conflict
 lda PE.Lock,X Any Lock bits set
 anda PE.Lock,Y
 bita #EOFLock Both users want End of File?
 bne Conflc85 ..Yes; probable conflict

* Check whether segments overlap
* (X)=next PE
* (Y)=requesting PE ptr
 ldd PE.LoLck,X Locked out Low LSN
 cmpd PE.HiLck,Y above requested high?
 bhi Conflc20 ..above; not a conflict
 bcs Conflc30 ..below; possible conflict
 ldd PE.LoLck+2,X
 cmpd PE.HiLck+2,Y
 bhi Conflc20 ..above; not a conflict
 beq Conflc85 ..equal; is a conflict

Conflc30 ldd PE.HiLck,X Locked out HSN
 cmpd PE.LoLck,Y below requested low?
 bcs Conflc20 ..below; not a conflict
 bhi Conflc85 ..above; a conflict
 ldd PE.HiLck+2,X
 cmpd PE.LoLck+2,Y
 bcs Conflc20 ..below; not a conflict


Conflc85 comb a conflict
Conflc90 puls PC,u,y,D return

 else
Insert    clra
         clrb
         std   $0B,y
         std   $0D,y
         sta   PD.SSZ,y
         std   PD.SSZ+1,y
Remove rts
 endc

 page
***************
* Subroutine Expand
* Expand File Size, Allocate Storage

* Passed: (Y)=PD
* Returns: None
* Destroys: CC,D,X

EXPAND pshs U,X save regs
EXPA10 bsr EXPSUB get file size -seg beginning
 bne EXPA15 ..Not this seg
 cmpx PD.SSZ+1,Y In this seg?
 bcs EXPA45 ..Yes
 bne EXPA15 ..No
 lda PD.SIZ+3,Y any of next sector used?
 beq EXPA45 ..No
EXPA15 lbsr GETFD get FD before changing PD.cp
 bcs EXPERR error; abort
 ldx PD.CP,Y get current posn
 ldu PD.CP+2,Y
 pshs U,X save it
 ldd PD.SIZ,Y set current posn
 std PD.CP,Y to file size
 ldd PD.SIZ+2,Y
 std PD.CP+2,Y
 lbsr GETSEG get seg ptrs
 puls U,X Retrieve current posn
 stx PD.CP,Y Restore it
 stu PD.CP+2,Y
 bcc EXPA45 bra if they exist
 cmpb #E$NES Not existing seg?
 bne EXPERR ..No; abort
 bsr EXPSUB get file size -seg beginning
 bne EXPA30 Use Max if > $FFFF
 tst PD.SIZ+3,Y Anything in last sector?
 beq EXPA35 ..No
 leax 1,X get extra sector
 bne EXPA35 Continue of no overflow
EXPA30 ldx #$FFFF Allocate maximum seg
EXPA35 tfr X,D copy seg size
 tsta request > minimum?
 bne EXPA40 ..Yes
 cmpb PD.SAS,Y request > minimum?
 bcc EXPA40 ..Yes
 ldb PD.SAS,Y get minimum
EXPA40 bsr SEGALL Allocate new seg
 bcc EXPA10 Check expansion
EXPERR coma set Carry
 puls PC,U,X

EXPA45 lbsr CHKSEG get current seg ptrs
 ifeq RCD.LOCK-included
 bcs EXPERR ..error; abort
 bsr NewSize Copy size thru conflict list
 endc
 puls PC,U,X

EXPSUB ldd PD.SIZ+1,Y get file size
 subd PD.SBL+1,Y Subtract seg beginning lsn
 tfr D,X save lsdb
 ldb PD.SIZ,Y get file size
 sbcb PD.SBL,Y Do msb
 rts

 ifeq RCD.LOCK-included
***************
* Subroutine NewSize
*   Update conflict list with new file size

* Passed: (Y)=PD ptr
* Returns: (A)=non-zero if other writers exist
*          CC=eq set as result of tsta (above)
*          CC=Carry clear
* Destroys: D

NewSize clra
 ldb #WRITE.
 pshs U,X save regs
 ldu PD.Exten,Y (U)=PE ptr
 bra NewSiz20 step through conflict list

NewSiz10 ldu PE.PDptr,U switch to PD ptr
 ldx PD.SIZ,Y copy file size
 stx PD.SIZ,U
 ldx PD.SIZ+2,Y
 stx PD.SIZ+2,U update file size
 bitb PD.MOD,Y (also) open for write?
 beq NewSiz15 ..No
 inca
NewSiz15 ldu PD.Exten,U
NewSiz20 ldu PE.Confl,U move to next PE in list
 cmpy PE.PDptr,U end of list?
 bne NewSiz10 ..No; loop
* Note: carry is clear
 tsta return EQ flag
 puls PC,U,X
 endc

***************
* Subroutine SEGALL
* Segment Allocation

* Passed: (D)=Number Sectors
*         (Y)=PD
* Returns: CC Carry Set On Error
* Destroys: D

SEGALL pshs U,X save regs
 lbsr SECALL Call sector allocation
 bcs SEGALErr
 lbsr GETFD
 bcs SEGALErr
 ldu PD.BUF,Y get buffer addr
 clra clear File size
 clrb
 std FD.SIZ,U
 std FD.SIZ+2,U
 leax FD.SEG,U get seg list ptr
 ldd FDSL.B,X first empty?
 beq SEGA20 ..Yes

*   Find Empty Segment List Entry
 ldd PD.BUF,Y make ptr to end + 1
 inca
 pshs D save it
 bra EMPS20

EMPS10 clrb clear Carry
 ldd FDSL.B-FDSL.S,X get seg size
 beq EMPS30 bra if end of list
 addd FD.SIZ+1,U Update file size
 std FD.SIZ+1,U
 bcc EMPS20 bra if no carry
 inc FD.SIZ,U
EMPS20 leax FDSL.S,X Move to next entry
 cmpx 0,S End of list?
 bcs EMPS10 ..No
 lbsr SECDEA return sectors allocated
 comb set Carry
 ldb #E$SLF Err: seg list full
EMPS30 leas 2,S Return scratch
 leax -FDSL.S,X Backup to entry
SEGALErr bcs SEGA30

 ldd FDSL.A-FDSL.S+1,X get lsb of last seg addr
 addd FDSL.B-FDSL.S,X Add size last seg
 pshs D save lsdb result
 ldb FDSL.A-FDSL.S,X get msb last seg addr
 adcb  #0 Propagate carry
 cmpb  PD.SBP,Y End last = beginning new?
 puls  D Retrieve lsdb result
 bne   SEGA20 ..No
 cmpd  PD.SBP+1,Y Make sure
 bne   SEGA20 ..No
* Now insure that they are in same bitmap sector
 ldu PD.DTB,Y drive tbl ptr
 ldd DD.BIT,U sectors per bit
 ldu PD.BUF,Y restore buffer ptr
 subd #1 form mask
 coma
 comb
 pshs D
 ldd FDSL.A-FDSL.S,X in same bitmap sector?
 eora PD.SBP,Y
 eorb PD.SBP+1,Y
 lsra
 rorb
 lsra
 rorb
 lsra
 rorb
 anda ,s+ match significant bits
 andb ,s+
 std -2,S zero? (indicates match)
 bne SEGA20 ..Different sectors, don't merge
 ldd FDSL.B-FDSL.S,X get size last seg
 addd PD.SSZ+1,Y Add size new
 bcs SEGA20 nra if seg size overflow
 std FDSL.B-FDSL.S,X Update seg size
 bra   SEGA25
SEGA20 ldd PD.SBP,Y get new seg physical
 std FDSL.A,X Set seg beginning
 lda PD.SBP+2,Y
 sta FDSL.A+2,X
 ldd PD.SSZ+1,Y get seg size
 std FDSL.B,X Set seg size
SEGA25 ldd FD.SIZ+1,U Set file size 
 addd PD.SSZ+1,Y Add new seg size
 std FD.SIZ+1,U
 bcc SEGA27 bra if no carry
 inc FD.SIZ,U Propagate carry
SEGA27 lbsr PUTFD
SEGA30 puls PC,U,X
 page
***************
* Subroutine Secall
*   Sector Allocation

* Passed: (D)=Number Sectors desired
*         (Y)=PD
* Returns: CC Carry Set On Error
* Destroys: D

* Stacked Temps
 org 0
S.SASSct rmb 1 First sector with SAS bits free
S.SASCls rmb 2 Segment alloc size in clusters
S.ClSize rmb 2 Cluster size (sectors/bit)
S.MapSiz rmb 2 (remaining) BitMap Size in bytes
S.MapSct rmb 1 current bitmap sct number
S.HiSct rmb 1 bitmap sector containing S.HiSize
S.HiSize rmb 2 largest segment found in bitmap
S.HiPosn rmb 2 addr of largest seg
S.BitReq rmb 2 (D) Clusters (bits) requested
S.x rmb 2 (X)
S.PDptr rmb 2 (Y) PD
 rmb 2 (U)

SECALL pshs U,Y,X,D save regs
 ldb #S.BitReq
SECA05 clr ,-S init stacked temps
 decb
 bne   SECA05
 ldx PD.DTB,Y drive tbl ptr
 ldd DD.MAP,X bitmap size
 std S.MapSiz,S init bitmap size
 ldd DD.BIT,X get sectors/bit
 std S.ClSize,S init cluster size
 std S.HiPosn,S HiPosn=scratch for divide

* Convert Segment Allocation Size (SAS) to clusters
* (D)=cluster size
 ldx PD.DEV,Y Device Tbl Entry
 ldx V$DESC,X Device Descriptor ptr
 leax M$DTyp,X (X)=ptr to descriptor options
 subd #1
 addb PD.SAS-PD.OPT,X
 adca #0 (D)=SAS + Clustersize - 1
 bra SECA08 (While)
SECA07 lsra
 rorb
SECA08 lsr S.HiPosn,S divide by cluster size
 ror S.HiPosn+1,S (even power of two)
 bcc SECA07
 std S.SASCls,S save allocation cluster size

* Convert Sectors Requested to Bits Required
 ldd S.ClSize,S
 std S.HiPosn,S scratch for divide
 subd #1
 addd S.BitReq,S (D)=SctReg + ClSize - 1
 bcc SECA12
 ldd #$FFFF get maximum sectors if overflow
 bra SECA12
SECA10 lsra While..
 rorb
SECA12 lsr S.HiPosn,S divide by cluster size
 ror S.HiPosn+1,S (even power of two)
 bcc SECA10 ..Do
 cmpa #$08 greater than 256*8 (1-sector of bits)?
 bcs SECA13 ..Yes; good
 ldd #256*8 request whole sector
SECA13  std S.BitReq,S set Bits Required

* Set Map Beginning Addr
 lbsr LockBit lock out bitmap
 lbcs SECA85 error; abort
 ldx PD.DTB,Y Drive Tbl ptr
 ldd V.DiskID,X
 cmpd DD.DSK,X Has disk changed?
 bne SECA14 ..Yes; start with 1st bitmap sector
 lda V.BMapSz,X
 cmpa DD.MAP,X Has disk changed?
 bne SECA14 ..Yes
 ldd S.BitReq,S get Bits required
 cmpd S.SASCls,S greater than minimal allocation?
 blo SECA15 ..No; begin searching at start of bitmap
 lda V.MapSct,X get lowest productive bitmap sector
 cmpa DD.MAP,X reasonable number?
 bcc SECA14 ..No; start with sector one
 sta S.MapSct,S
 nega
 adda S.MapSiz,S subtract from number of sectors to search
 sta S.MapSiz,S
 bra SECA15 begin bitmap search

SECA14 ldd DD.DSK,X
 std V.DiskID,X save Disk ID
 lda DD.MAP,X
 sta V.BMapSz,X and Bitmap Size
 clr V.MapSct,X default first bitmap sector
SECA15 inc S.MapSct,S update bitmap sector
 ldb S.MapSct,S
 lbsr ReadBit read (next) bitmap sector
 lbcs SECA85 error; abort
 ldd S.MapSiz,S
 tsta More than 256 bytes left?
 beq SECA17 ..No; cont
 ldd #$100 use entire buffer
SECA17 ldx PD.BUF,Y ptr to bitmap
 leau D,X ptr to bitmap end
 ldy S.BitReq,S bits required
 clra start at beginning
 clrb
 os9 F$SchBit Search bitmap
 pshs D,CC save regs
 tst S.SASSct+3,S already found in Min allocation?
 bne SECA17a ..Yes; continue
 cmpy S.SASCls+3,S Min alloc clusters found?
 bcs SECA17a ..No; cont
 lda S.MapSct+3,S
 sta S.SASSct+3,S save lowest reasonable bitmap sector
SECA17a puls D,CC restore regs
 bcc SECA20 found: Allocate bits
 cmpy S.HiSize,S largest segment found?
 bls SECA18 ..No; read next sector
 sty S.HiSize,S save largest size
 std S.HiPosn,S save addr
 lda S.MapSct,S
 sta S.HiSct,S save bitmap sector
SECA18 ldy S.PDptr,S restore PD
 tst S.MapSiz,S end of bitmap?
 beq SECA18b ..Yes, use largest found
 dec S.MapSiz,S decr size left one sector
 bra SECA15 repeat

SECA18b ldb S.HiSct,S any free space?
 beq SECA80 ..No; abort
 clra
 cmpb S.MapSct,S already in buffer?
 beq SECA19 ..Yes
 stb S.MapSct,S
 lbsr ReadBit reread bitmap sector
SECA19 ldx PD.Buf,Y buffer ptr
 ldd S.HiPosn,S bit addr
 ldy S.HiSize,S bit count
SECA20 std S.HiPosn,S save bit offset
 sty S.HiSize,S save bit count
 os9 F$AllBit Allocate in bitmap
 ldy S.PDptr,S restore PD
 ldb S.MapSct,S used bitmap sector number
 lbsr PUTBIT rewrite/release bitmap
 bcs SECA85 error; abort
 lda S.SASSct,S Minimum allocation sector found?
 beq SECA22 ..No; cont
 ldx PD.DTB,Y
 deca
 sta V.MapSct,X ..Yes; save it
SECA22 lda S.MapSct,S bitmap sector number
 deca convert to bit offset
 clrb times 8 bits/byte
 lsla
 rolb
 lsla
 rolb
 lsla
 rolb
 stb PD.SBP,Y save beginning addr msb
 ora S.HiPosn,S form mid
 ldb S.HiPosn+1,S lsb
 ldx S.HiSize,S size
 ldy S.PDptr,S get PD
 std PD.SBP+1,Y Set addr
 stx PD.SSZ+1,Y Set size

 ldd S.ClSize,S Mulitply sectors/bit
 bra SECA30 While..
SECA25 asl PD.SBP+2,Y times bit addr
 rol PD.SBP+1,Y
 rol PD.SBP,Y
 asl PD.SSZ+2,Y and bit size
 rol PD.SSZ+1,Y
SECA30 lsra
 rorb
 bcc SECA25 ..Do
 clrb clear Carry
 ldd PD.SSZ+1,Y return sectors allocated
 bra SECA90 exit

SECA80 ldb #E$FULL Err: media full
SECA85 ldy S.PDptr,S (Y)=PD
 lbsr RLSBIT release bitmap
 coma abort: return carry set
SECA90 leas S.x,S discard temps
 puls PC,U,Y,X exit
 page
***************
* Subroutine Trim
*   Trim File Size, Deallocate Any Excess

* Passed: (Y)=PD
* Returns: None
* Destroys: CC,D,X,U

TRIM clra clear carry
 lda PD.MOD,Y
 bita #DIR. dir file?
 bne TrimE99 ..Yes; don't trim
 ldd PD.SIZ,Y get file size
 std PD.CP,Y set current posn
 ldd PD.SIZ+2,Y
 std PD.CP+2,Y

 ifeq RCD.LOCK-included
 ldd #$FFFF
 tfr d,X
 lbsr GAIN lockout from desired file to EOF
 bcs TrimErr ..abort if error
 lbsr NewSize Copy size thru conflict list
 bne TrimE99 ..Return if other writer(s) exit
 endc

 lbsr GETSEG get last seg needed
 bcc TRIM10 continu if no error
 cmpb #E$NES Non-existing seg error?
 bra TRIM29

TRIM10 ldd PD.SBL+1,Y get seg beginning logical
 subd PD.CP+1,Y Subtract current posn
 addd PD.SSZ+1,Y get excess seg sectors
 tst PD.CP+3,Y any of final sector used?
 beq TRIM20 ..No
 subd #1 Use it
TRIM20 pshs D save excess size
 ldu PD.DTB,Y get drive tbl ptr
 ldd DD.BIT,U get sectors/bit
 subd #1 form mask
 coma
 comb
 anda ,s+ Mask msb
 andb ,s+ Mask lsb
 ldu PD.SSZ+1,Y get seg size
 std PD.SSZ+1,Y Set excess
 beq TRIM30 bra if no excess
 tfr u,d Copy size
 subd PD.SSZ+1,Y get sectors needed
 pshs x,D save sectors & entry ptr
 addd PD.SBP+1,Y Make ptr to excess
 std PD.SBP+1,Y
 bcc TRIM26 bra if no carry
 inc PD.SBP,Y Propagate carry
TRIM26 bsr SECDEA Deallocate excess
 bcc TRIM40 bra if no error
 leas 4,S Return scratch
 cmpb #E$IBA Illegal block addr
TRIM29 bne TrimErr ..No; abort
TRIM30 lbsr GETFD
 bcc TRIM50
TrimErr coma set Carry
TrimE99 rts

TRIM40 lbsr GETFD
 bcs TRIM80
 puls X,D get sectors needed & seg entry ptr
 std FDSL.B,X Set seg size
TRIM50 ldu PD.BUF,Y get buffer ptr
 ldd PD.SIZ+2,Y get file size
 std FD.SIZ+2,U
 ldd PD.SIZ,Y
 std FD.SIZ,U
 tfr X,D Copy seg list ptr
 clrb make Limit ptr
 inca
 leax FDSL.S,X
 pshs x,D save ptr & limit
 bra TRIM65

TRIM60 ldd FDSL.B-FDSL.S,X get seg size
 beq TRIM75 bra if done
 std PD.SSZ+1,Y save seg size
 ldd FDSL.A-FDSL.S,X get sector number
 std PD.SBP,Y
 lda FDSL.A+2-FDSL.S,X
 sta PD.SBP+2,Y
 bsr SECDEA Deallocate sectors
 bcs TRIM80
 stx 2,S save entry ptr
 lbsr GETFD
 bcs TRIM80
 ldx 2,S get entry ptr
 clra
 clrb
 std FDSL.A-FDSL.S,X
 sta FDSL.A+2-FDSL.S,X
 std FDSL.B-FDSL.S,X
TRIM65 lbsr PUTFD Rewrite FD
 bcs TRIM80
 ldx 2,S get entry ptr
 leax FDSL.S,X
 cmpx 0,S Done?
 bcs TRIM60 ..No
TRIM75 clra clear Carry
 clrb
 sta PD.SSZ,Y clear current seg size high byte
 std PD.SSZ+1,Y clear current seg size low bytes
TRIM80 leas 4,S
 rts

 page
***************
* Subroutine SECDEA - Sector Deallocation
*   Releases the sector(s), erasing bitmap

* Passed: (Y)=PD
*         PD.SBP=Beginning sector ptr
*         PD.SSZ=Size in sectors
* Returns: CC,B set if error
* Destroys: D

SECDEA pshs U,Y,X,A save regs
 ldx PD.DTB,Y get drive tbl ptr
 ldd DD.BIT,X get sectors/bit
 subd #1
 addd PD.SBP+1,Y Segment Begin ptr
 std PD.SBP+1,Y round up
 ldd DD.BIT,X
 bcc SECD10
 inc PD.SBP,Y propagate carry
 bra SECD10

SECD05 lsr PD.SBP,Y convert Segment ptr
 ror PD.SBP+1,Y to bit offset in bitmap
 ror PD.SBP+2,Y
 lsr PD.SSZ+1,Y convert segment size
 ror PD.SSZ+2,Y to bits returning
SECD10 lsra divide by sectors per bit
 rorb (cluster size Must be even power of two)
 bcc SECD05
 clrb clear carry
 ldd PD.SSZ+1,Y Any block left?
 beq SECD90 ..No, return without error
 ldd PD.SBP,Y ms bytes of bit offset
 lsra
 rorb divice by 8 bits/byte
 lsra
 rorb
 lsra
 rorb
 tfr b,a
 ldb #E$IBA error code: Illegal Block Addr
 cmpa DD.MAP,X reasonable number?
 bhi SecDErr ..No; abort
 cmpa V.MapSct,X below low bitmap sector searched?
 bcc SECD15 ..No; continue
 sta V.MapSct,X
SECD15 inca (B)=Bitmap sector addr
 sta 0,S save sector num
SECD20 equ * potential deadly loop
 bsr LockBit lockout bitmap
 bcs SECD20 ..error; keep trying
 ldb 0,S get bitmap sector
 lbsr ReadBit read bitmap
 bcs SecDErr ..error; abort
 ldx PD.BUF,Y get buffer ptr
 ldd PD.SBP+1,Y get beginning block number
 anda #$07 mod 2048 bits/sector
 ldy PD.SSZ+1,Y get block size
 os9 F$DelBit De-allocate in bitmap
 ldy 3,S PD
 ldb 0,S Bitmap sector
 bsr PUTBIT rewrite/release bitmap
 bcc SECD90 ..return error status
SecDErr coma set carry
SECD90 puls PC,U,Y,X,A

***************
* Subroutine LockBit
*   LockOut Bitmap, Read first sector

* Passed: (Y)=PD
* Returns: CC,B=set if error
* Destroys: D,X,U

LockBit lbsr CLRBUF clear buffer
 bra LckBit20

LckBit10 os9 F$IOQU get in I/O queue
 bsr ChkSignl Interrogate Signal recieved
LckBit20 bcs LckBit99 ..exit if error
 ldx PD.DTB,Y get drive tbl ptr
 lda V.BMB,X bitmap busy?
 bne LckBit10 ..Yes
 lda PD.CPR,Y get current process ID
 sta V.BMB,X Claim bitmap (carry clear)
         tst   <$8C    Page 0 variable
         beq   LckBit99
         pshs  b,cc
         lda   #$0C
         ldx   PD.RGS,y
         ldb   R$B,x
         pshs  b
         ldb   #$81
         stb   R$B,x
         lbsr  DEVDIS
         puls  b
         stb   R$B,x
         puls  b,cc
LckBit99 rts

***************
* Subroutine ChkSignal
*   See if signal received caused death

* Returns: CC,B=set if error
* Destroys: D,U

ChkSignl ldu D.Proc
 ldb P$Signal,U
 cmpb #S$Wake Wake-up signal?
 bls ChkSig10 ..Continue if wakeup
 cmpb #S$Intrpt deadly signal?
 bls ChkSErr ..Yes; give up

ChkSig10 clra clear carry
 lda P$State,U check process state flags
 bita #Condem has process died?
 beq ChkSig90 ..No; return carry clear
ChkSErr coma set carry
ChkSig90 rts

***************
* Subroutine PUTBIT
*   Rewrite/Release Bitmap

* Passed: (B)=bitmap sector number
*         (Y)=PD
* Returns: CC,B set if error
* Destroys: D,X

PUTBIT clra
 tfr D,X
 clrb (B,X)=sector number
 lbsr PUTSEC
RLSBIT pshs CC save error status
 ldx PD.DTB,Y get drive tbl ptr
 lda PD.CPR,Y current process ID
 cmpa V.BMB,X this process controlling bitmap?
 bne RLSBIT99 ..No; exit
 clr V.BMB,X Release bitmap
         tst   <$8C   Page 0 variable
         beq   RLSBIT99
         pshs  b
         lda   #$0C
         ldx   PD.RGS,y
         ldb   R$B,x
         pshs  b
         ldb   #$82
         stb   R$B,x
         lbsr  DEVDIS
         puls  b
         stb   R$B,x
         puls  b
RLSBIT99 puls PC,CC return


 page
***************
* Subroutine ReadBit
*   Read Bitmap sector

* Passed: (B)=sector number
*         (Y)=PD
* Returns: CC=carry set if error
*         (B)=error code
* Destroys: (X)

ReadBit clra
 tfr D,X
 clrb
 lbra GETSEC read bitmap sector

***************
* Subroutine WRCP
*   Write Current Position Sector

WRCP pshs U,X save regs
 lbsr PCPSEC Put current sector
 bcs WRCPXX error; abort
 lda PD.SMF,Y get buffer flags
 anda #$FF-BUFMOD Clear flags
 sta PD.SMF,Y
WRCPXX puls PC,U,X

 page
***************
* Subroutine Chkseg
*   Check Segment ptrs For Current Position

CHKSEG ldd PD.CP+1,Y get current posn
 subd PD.SBL+1,Y Subtract seg beginning logical
 tfr D,X
 ldb PD.CP,Y
 sbcb PD.SBL,Y
 cmpb PD.SSZ,Y In this seg?
 bcs CHKSG90 yes
 bhi GETSEG No, ..get another
 cmpx PD.SSZ+1,Y In this seg?
 bcc GETSEG ..No
CHKSG90 clrb clear carry
 rts

***************
* Subroutine GETSEG
*   Get Segment Containing Current Position

* Passed: (Y)=PD ptr
* Returns: CC Carry set if no segment found
* Destroys: D

GETSEG pshs U save regs
 bsr GETFD
 bcs GETS30 error; abort
 clra clear D
 clrb
 std PD.SBL,Y Clear seg beginning logical
 stb PD.SBL+2,Y
 ldu PD.BUF,Y get buffer addr
 leax FD.SEG,U get seg list ptr
 lda PD.BUF,Y make limit ptr at
 ldb #-(FDSL.S-1) end-(entry size-1)
 pshs D save limit ptr
FNDS10 ldd FDSL.B,X get seg size
 beq GETS10 bra if end of used entries
 addd PD.SBL+1,Y Add seg beginning logical
 tfr D,U save it
 ldb PD.SBL,Y get msb
 adcb #0 Propagate carry
 cmpb PD.CP,Y This seg?
 bhi GETS25 ..Yes
 bne FNDS20 ..No
 cmpu PD.CP+1,Y Make sure
 bhi GETS25 bra if in this seg
FNDS20 stb PD.SBL,Y Actually in next seg
 stu PD.SBL+1,Y
FNDS25 leax FDSL.S,X Move to next entry
 cmpx 0,S End of list?
 bcs FNDS10 ..No
GETS10 clra
 clrb
 sta PD.SSZ,Y Clear seg size high byte
 std PD.SSZ+1,Y Clear seg size low bytes
 comb set Carry
 ldb #E$NES Err: non-existing seg
 bra GETS30
GETS25 ldd FDSL.A,X get seg beginning
 std PD.SBP,Y Set set beginning physical
 lda FDSL.A+2,X
 sta PD.SBP+2,Y
 ldd FDSL.B,X get seg size
 std PD.SSZ+1,Y
GETS30 leas 2,S return scratch
 puls PC,U
 page
***************
* Subroutine GETDD
*   Get Device Desc

GETDD pshs X,B
 lbsr CLRBUF clear buffer
 bcs GETDD10 error; abort
 clrb
 ldx #0
 bsr GETSEC get sector
 bcc GETDD20 bra if no error
GETDD10 stb 0,S
GETDD20 puls PC,X,B

***************
* Subroutine GETFD
*   Get File Descriptor

GETFD ldb PD.SMF,Y get flag
 bitb #FDBUF FD in buffer
 bne CHKSG90 ..Yes; return (carry clear) ..Yes
 lbsr CLRBUF clear buffer
 bcs PUTS99 error; abort
 ldb PD.SMF,Y get flags
 orb #FDBUF Mark FD in buffer
 stb PD.SMF,Y
 ldb PD.FD,Y FD addr
 ldx PD.FD+1,Y

***************
* Subroutine GETSEC
*   Get Specified Sector

GETSEC lda #D$READ Set entry offset
* Fall into DEVDIS

***************
* Routine DEVDIS
*   Device Driver Dispatcher

* Passed: (A)=Entry offset
*         (Y)=PD ptr

DEVDIS pshs U,Y,X,D save regs

 lda PD.SMF,Y
 ora #InDriver indicate I/O "in progress"
 sta PD.SMF,Y

 ldu PD.DEV,Y get device tbl entry
 ldu V$STAT,U get device static storage
 bra DEVD20
DEVD10 os9 F$IOQU Wait for device
DEVD20 lda V.BUSY,U Device busy?
 bne DEVD10 ..Yes
 lda PD.CPR,Y get process ID
 sta V.BUSY,U Set busy flag
 ldd 0,S get code & sector psn msb
 ldx 2,S get sector psn lsbs
 pshs U save static storage
 bsr GODRIV Go to driver
 puls U Retrieve static storage

 ldy 4,S restore PD ptr
 pshs cc save error status
 lda PD.SMF,Y
 anda #^InDriver signal I/O finished
 sta PD.SMF,Y

 clr V.BUSY,U Clear busy flag
 puls cc restore error status
 bcc DEVD30 bra if no error
 stb 1,S return error code
DEVD30 puls PC,U,Y,X,D

GODRIV pshs PC,X,D save regs
 ldx PD.DEV,Y get device driver addr
 ldd V$DRIV,X get module addr
 ldx V$DRIV,X get module addr
 addd M$EXEC,X Add module entry offset
 addb 0,S Add entry tbl offset
 adca #0 Propagate carry
 std 4,S Put in stack for dispatch
 puls PC,X,D Dispatch

***************
* Subroutine PUTFD
*   Put File Descriptor

PUTFD ldb PD.FD,Y
 ldx PD.FD+1,Y
 bra PUTSEC

***************
* Subroutine PCPSEC
*   Put Current Position Sector

PCPSEC bsr GETCP get addr of current posn
* Fall into PUTSEC

***************
* Subroutine PUTSEC
*   Put Sector

PUTSEC lda #D$WRIT get entry offset
 pshs X,D save regs
 ldd PD.DSK,Y get disk ID
 beq PUTS10 bra if clear
 ldx PD.DTB,Y get drive tbl ptr
 cmpd DD.DSK,X same disk?
PUTS10 puls X,D restore regs
 beq DEVDIS ..Yes; execute Write
 comb set Carry
 ldb #E$DIDC Err: disk ID change
PUTS99 rts

***************
* Subroutine GETCP
*   Get Addr of Current Position Sector

GETCP ldd PD.CP+1,Y get current posn
 subd PD.SBL+1,Y get offset in seg
 tfr D,X save lsb
 ldb PD.CP,Y get current posn msb
 sbcb PD.SBL,Y
 exg D,X Swap msb & lsb
 addd PD.SBP+1,Y get sector physical addr
 exg D,X
 adcb PD.SBP,Y
 rts

***************
* Subroutine CLRBUF
*   Clear Buffer

CLRBUF clrb clear Carry
 pshs U,X save regs
 ldb PD.SMF,Y get flags
 andb #SINBUF+FDBUF Sector in buffer?
 beq CLRB10 ..No
 tfr b,a Copy flag
 eorb PD.SMF,Y Clear sector in buffer
 stb PD.SMF,Y
 andb #BUFMOD Buffer modified?
 beq CLRB10 ..No
 eorb PD.SMF,Y clear buffer modified
 stb PD.SMF,Y
 bita #SINBUF current sector in buffer?
 beq CLRB10 ..No
 bsr PCPSEC Write current sector
CLRB10 puls PC,U,X

***************
* Subroutine RDCP
*   Read Current Position

RDCP pshs U,X save regs
 lbsr CHKSEG Check seg ptrs
 bcs RDCPXX error; abort

***************
* Subroutine GCPSEC
*   Get Current Position Sector

 bsr CLRBUF clear buffer
 bcs RDCPXX error; abort
 ifeq RCD.LOCK-included
GCPS05 ldb PD.CP,Y
 ldu PD.CP+1,Y
 leax 0,Y Point X at Current PD
 ldy PD.Exten,Y Change to PE of Path
GCPS10 ldx PD.Exten,X Point X at testing PE
 cmpy PE.Confl,X End of conflict list?
 beq GCPS90 Yes .. Read in sector
 ldx PE.Confl,X Next PE in Conflict List
 ldx PE.PDptr,X Move to PD
 cmpu PD.CP+1,X Match sector addr bytes 1&2
 bne GCPS10 No .. Try next path
 cmpb PD.CP,X Match sector addr byte 0
 bne GCPS10 No .. Try next path
 lda PD.SMF,X
 bita #InDriver Other path doing I/O on this sector?
 bne GCPS15 Yes, wait for it to finish
 bita #SINBUF Is sector in buffer?
 beq GCPS10 ..No; try next path
 bra GCPS20 ..Yes, go copy it
GCPS15 lda PD.CPR,X get other path's owner ID
 ldy PE.PDptr,Y
 os9 F$IOQu Wait for I/O to finish
 lbsr ChkSignl Interrogate signal recieved
 bcc GCPS05
 bra RDCPXX Abort if error

GCPS20 ldy PE.PDptr,Y Move to PD
 ldd PD.Buf,X Swap buffer pointers
 ldu PD.Buf,Y
 std PD.Buf,Y
 stu PD.Buf,X
 lda PD.SMF,X Get state Flags
 sta PD.SMF,Y  from holding PD
 clr PD.SMF,X
 puls PC,U,X
GCPS90 ldy PE.PDptr,Y Restore registers
 endc
 lbsr GETCP get addr of current posn
 lbsr GETSEC get sector off of disk
 bcs RDCPXX error; abort
 lda PD.SMF,Y
 ora #SINBUF Set sector in buffer
 sta PD.SMF,Y
RDCPXX puls PC,U,X

 emod
RBFEnd equ *

