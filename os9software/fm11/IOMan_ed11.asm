         nam   Input/Output Manager
         ttl   Module Header
*
* This file has been extracted from a system disk for FM-11
*

 mod IOEnd,IOName,Systm+Objct,ReEnt+1,IOINIT,0
IOName  fcs /IOMan/  module name

 fcb 11 edition number

 use defsfile

 ttl Initialization
 page
**********
* Ioinit
* Entry Point For Start-Up Initialization
*
IOINIT ldx D.Init From configuration table
 lda PollCnt,x get polling table entries
 ldb #POLSIZ get entry size
 mul get polling table size
 pshs d save it
 lda DEVCNT,X Get device table size
 ldb #DEVSIZ
 mul get device table size
 addd 0,s add polling table size
 addd #$FF
 clrb round up to nearest page
 os9 F$SRqMem allocate required I/O tbl memory
 bcs CRASH Death: not enough memory
 leax 0,u
IOINI1 clr ,x+ Clear systems I/O tables
 subd #1
 bhi IOINI1
 stu D.PolTbl save addr of Polling tbl
 ldd ,s++ polling tbl size
 leax d,u allocate room for polling table
 stx D.DevTbl Save device tbl addr
 ldx D.PthDBT Signal pdbt allocation
 os9 F$All64 Allocate/initialize pdbt
 bcs CRASH ..can't run without memory
 stx D.PthDBT Save path descriptor block tbl addr
 os9 F$Ret64 Return unneeded pd
 leax IOIRQ,pcr Get interrupt polling routine
 stx D.Poll
 leay <SVCTBL,pcr Get service initialization
 os9 F$SSvc Init service routine entries
 rts

Crash    jmp   [>$FFFE]
**********
 page
**********
* Service Routine Initialization Table
*
system set $80 system only calls
user set $7F system or user calls

SVCTBL equ *
 fcb $FF&user
 fdb USERIO-*-2
 fcb F$Load&user
 fdb LOAD-*-2
 ifgt LEVEL-1
 fcb F$Load+SysState
 fdb SysLoad-*-2
 endc
 fcb F$PERR&user
 fdb PRTERR-*-2
 fcb F$IOQu!system
 fdb IOQUEU-*-2
 fcb $FF!system
 fdb SYSIO-*-2
 fcb F$IRQ!system
 fdb IOPOLL-*-2
 fcb F$IODel!system
 fdb IODel-*-2
 fcb $80 end of table
 page
**********
* Iodel
*
*   Called When An I/O Module Is Unlinked For The
*    Final Time.  Error Returned if Module Busy, And
*    Module Link Count Should Stay At One.

* Passed: (U)=Register Pack
*         R$X,U=Module Addr
* Returns: CC=Set if Error
* Destroys: D

IODEL ldx R$X,u Get module addr
 ldu D.Init From configuration module
 ldb DevCnt,u Get device table size
 ldu D.DevTbl Get device table address
IODEL10 ldy   V$DESC,u empty table entry?
 beq IODEL20 ..yes; skip it
 cmpx V$DESC,u This logical device?
 beq IODELErr ..yes; return error
 cmpx V$DRIV,u This physical device driver?
 beq IODELErr ..yes; return error
 cmpx V$FMGR,u This file manager?
 beq IODELErr ..yes; return error
IODEL20 leau DEVSIZ,u skip to next entry
 decb
 bne IODEL10 Loop until end of table
 clrb return carry clear
 rts

IODELErr comb I/O Delete module error
 ldb #E$ModBsy Error: module busy
 rts

 ifgt LEVEL-1
***************
* Subroutine PortBlk

* Passed: (D)=MS port addr
* Returns: (D)=Port Extended Block number
*          CC = Equal if port is in System's I/O Block
* Destroys:

PortBlk lsra
 rorb
 ifge DAT.BlSz-2048
 lsra
 rorb
 ifge DAT.BlSz-4096
 lsra
 rorb
 endc
 endc
 lsra
 rorb (D)=Extended Block number
 anda #DAT.BlMx/256 clear untranslated bits
 ifle DAT.BlMx-255
 ifeq MappedIO-true
 cmpb #IOBlock System's I/O Block?
 rts
 else
 cmpb #DAT.BlMx  #ROMBlock System's ROM Block?
 rts
 endc
 else
 endc
 endc

UTABLE equ *
TBLBGN set UTABLE
 fdb ATTACH-TBLBGN
 fdb DETACH-TBLBGN
 fdb UDUPE-TBLBGN
 fdb UCREAT-TBLBGN
 fdb UOPEN-TBLBGN
 fdb UMDIR-TBLBGN
 fdb UCDIR-TBLBGN
 fdb UDELET-TBLBGN
 fdb USEEK-TBLBGN
 fdb UREAD-TBLBGN
 fdb UWRITE-TBLBGN
 fdb URDLN-TBLBGN
 fdb UWRLN-TBLBGN
 fdb UGSTT-TBLBGN
 fdb USSTT-TBLBGN
 fdb UCLOSE-TBLBGN
 fdb UDELETX-TBLBGN

STABLE equ *
TBLBGN set STABLE
 fdb ATTACH-TBLBGN Attach (x)=device, (a)=mode
 fdb DETACH-TBLBGN Detach (u)=devtbl ptr
 fdb SDUPE-TBLBGN (nop) duplicate (a)=pathnumber

* File Manager Name Functions
*          (X)=Pathname Ptr
*          (A)=Mode
 fdb SCREAT-TBLBGN Create file
 fdb SOPEN-TBLBGN Open   file
 fdb SMDIR-TBLBGN Make new directory
 fdb SCDIR-TBLBGN Change directory
 fdb SDELET-TBLBGN Delete (assumes write mode)

* File Manager Path Functions
*         (A)=Path Number
 fdb SSEEK-TBLBGN Seek to position (x,u)
 fdb SREAD-TBLBGN  read  (x)=destin, (y)=count
 fdb SWRITE-TBLBGN Write (x)=source, (y)=count
 fdb SRDLN-TBLBGN  readline  (x)=destin, (y)=cnt
 fdb SWRLN-TBLBGN  writeline (x)=source, (y)=cnt
 fdb SGSTT-TBLBGN Get status
 fdb SSSTT-TBLBGN Set status
 fdb SCLOSE-TBLBGN Close path
 fdb SDELETX-TBLBGN Delete from execution directory

**********
* I/O Dispatcher
*
USERIO leax <UTABLE,pcr Use user table
 bra SYSIO1

SysIO leax <STABLE,pcr Use system table
SYSIO1 cmpb #I$DeletX Function out of range?
 bhi SYSIO2 ..yes; error
 pshs b Save function code
 lslb TIMES Two bytes per entry
 ldd b,x Get offset of routine
 leax d,x Form absolute entry of routine
 puls b Restore function code
 jmp 0,x Dispatch

SYSIO2 comb RETURN Carry set
 ldb #E$UnkSvc Error: unknown service code
 rts

 page
**********
* Attach I/O Device
*
* Passed: (A)=R/W/Exec Mode
*         (X)=Device Name Ptr
* Returns: (U)=Dev Tbl Ptr
*
 org 0 Stack temporary storage
 rmb DEVSIZ Temp device table entry
S.MODE rmb 1 R/w mode
S.BUSY rmb 1 Non-zero if device in use
S.PORT rmb 3 Temp port addr
S.DEVT rmb 2 Temp device table ptr
 ifgt LEVEL-1
S.LclAdr rmb 2 Local Port Absolute addr
S.Block rmb 2 Port extended Block number
S.Proc rmb 2 user's process ptr
 endc
S.STAK rmb 2 User's register stack
S.TMPS equ . Total temp size

ATTACH ldb #S.TMPS-1
ATTA02 clr ,-S Clear out temporary storage
 decb
 bpl ATTA02
 stu S.STAK,S Save user stack ptr
 lda R$A,u
 sta S.MODE,s Save requested mode
 ifgt LEVEL-1
 ldx D.Proc get process ptr
 stx S.Proc,s save it
 leay P$DATImg,x get process dat image ptr
 ldx D.SysPRC get system process ptr
 stx D.Proc make current for link
 endc
 ldx R$X,u Get device name ptr
 lda #DEVIC
 ifeq LEVEL-1
 OS9 F$Link link to device desc.
 else
 OS9 F$SLink Link device descriptor module (x)
 endc
 bcs ATTERR0 ..error; non-existing module
 stu V$DESC,s Save addr
 ldy S.STAK,s
 stx R$X,y Return updated pathname to caller
 ifgt LEVEL-1
 lda M$PORT,u Port Extended Addr
 sta S.PORT,S
 endc
 ldd M$PORT+1,u Get "base" port addr
 std S.PORT+1,s Save it
 ldd M$PDEV,u offset of driver module name
 leax D,U Get absolute addr of name
 lda #DRIVR
 os9 F$Link Link device driver module
 bcs ATTERR0 ..error; non-existing module
 stu V$DRIV,s Save device driver module addr
 ldu V$DESC,s get device descriptor addr
 ldd M$FMGR,u offset of file mgr name
 leax D,U Get absolute addr
 lda #FLMGR
 OS9 F$LINK Link file manager module
ATTERR0
 ifgt LEVEL-1
 ldx S.Proc,s get process ptr
 stx D.Proc restore it
 endc
 bcc ATTA15 .. found; continue

ATTERR stb S.TMPS-1,S Save error code
 leau 0,S Addr og psuedo device tbl entry
 os9 I$Detach ..detach device
 leas S.TMPS-1,s
 comb
 puls pc,b Return error

*
* Device Moudle Components Are All Located
* Search Device Tbl For Device
*
ATTA15 stu V$FMGR,S Save file manager module addr
 ldx D.Init From configuration rom addr
 ldb DevCnt,x Get device table entry count
 lda DevCnt,x Save an extra copy
 ldu D.DevTbl Get device tbl addr
ATTA20 ldx V$DESC,u Descriptor ptr
 beq ATTA30 ..unused entry; skip
 cmpx V$DESC,s Device descriptor module found?
 bne ATTA25 ..no; continue
 ldx V$STAT,u Is device in TERMINATE routine?
 bne ATTA22 ..No; continue
 pshs a
 lda V$USRS,u TERMINATING PROCESS ID
 beq ATTA21 ..ZERO; impossible
 os9 F$IOQu Wait for termination
ATTA21 puls a
 bra ATTA20 Try again

ATTA22 stu S.DEVT,s Save tbl ptr of found entry
ATTA25 ldx V$DESC,u Descriptor ptr
 ldy M$PORT+1,x Get device port addr
 cmpy S.PORT+1,s
 bne ATTA30
 ifgt LEVEL-1
 ldy M$PORT,x
 cmpy S.PORT,s Same PORT addr?
 bne ATTA30 ..No
 endc
 ldx V$DRIV,u
 cmpx V$DRIV,s Save device driver?
 bne ATTA30 ..no; skip to next entry
 ldx V$STAT,u Don't re-initialize it
 stx V$STAT,s Save static memory of found driver
 tst V$USRS,u Currently in use?
 beq ATTA30 ..no; continue
 sta S.BUSY,s Mark it busy (non-zero)
ATTA30 leau DEVSIZ,u Skip to next dev tbl entry
 decb
 bne ATTA20 Loop until there are no more
 ldu S.DEVT,s Device descriptor already in table?
 lbne ATTA70 yes; use same entry
*
* Create New Device Table Entry
*
 ldu D.DevTbl Get device tbl addr
ATTA35 ldx V$DESC,u Search for a free entry
 beq ATTA40 ..found one, exit loop
 leau DEVSIZ,u Skip to next entry
 deca
 bne ATTA35 Loop until end of tbl

 ldb #E$DevOvf Error: device table overflow
 bra ATTERR

ERMODE ldb #E$BMode Error: illegal mode
 bra ATTERR

* this code removed for edition 7
*
*ERBUSY ldb #E$DevBsy Error: device is busy
* bra ATTERR
*
* end of code removed for edition 7

ATTA40    ldx   $02,s
         lbne  ATTA60
*
* Allocate New Static Storage For Device
*
 stu S.DEVT,s save Dev Tbl Entry Ptr
 ldx V$DRIV,s Get device driver addr
 ldd M$Mem,x Driver Static Storable requirement
 addd #$FF
 clrb Round up to nearest page
 os9 F$SRqMem request Device Static Storage
 lbcs ATTERR ..ABORT if error
 stu V$STAT,s Save static storage ptr
ATTA57 clr ,U+ Clear out driver static
 subd #1
 bhi ATTA57

* Map Port into System addr space
 ifeq LEVEL-1
 ldd S.Port+1,s get port addr off stack
 else
         ldy   #$F000  New in ed. 11
 ldd S.Port,s Get extended port addr
 lbsr PortBlk convert to block addr
         beq   IOMap40  New in ed. 11
 std S.Block,s save working block addr
 ldu #0 clear DAT entry ptr
 tfr u,y clear local address ptr
 stu S.LclAdr,s System Local addr=0
 ldx D.SysDAT get system DAT image ptr
IOMap20 ldd ,x++ get next DAT Entry
 ifne DAT.WrEn+DAT.WrPr
 endc
 cmpd S.Block,S same as Desirec Block?
 beq IOMap40 ..Yes; good
 cmpd #DAT.Free Unused Entry?
 bne IOMap30 ..No, continue
 sty S.LclAdr,s save System Local addr
 leau -2,x save DAT Image ptr
IOMap30 leay DAT.BLSz,y update Local Address
 bne IOMap20 repeat until Total addr space searched
 ldb #E$MemFul prime err: System process mem full
 cmpu #0 free table entry found?
 lbeq ATTERR ..No; ABORT: System Dat Image Fill
 ldd S.Block,s
 ifne DAT.WrEn
 endc
 std 0,u fill in DAT Image with block
 ldx D.SysPRC get system process ptr
 lda P$State,x
 ora #ImgChg indicate DAT image change
 sta P$State,x
 os9 F$ID Dummy SVC call to update DAT image
 ldy S.LclAdr,s get local address

* (D)=System Local addr corresponding to $XX X000 of addr
IOMap40 sty S.LclAdr,s save High order local addr
 ldd S.Port+1,S LS 2-bytes of port addr
 anda #^DAT.Addr strip off translated bits
 addd S.LclAdr,s add to local block addr
 endc
 ldu V$STAT,s Device Static Storage ptr
 clr V.PAGE,u
 std V.PORT,u save abs port addr in Static storage

 ldy V$DESC,s Pass Descriptor addr to Driver
 ldx V$DRIV,s Driver Module addr
 ldd M$EXEC,x Get execution addr
 jsr D,X Execute dev driver's init routine
 lbcs ATTERR ..error; return error code
 ldu S.DEVT,s Device table ptr to new entry
ATTA60 ldb #DEVSIZ-1
ATTA65 lda B,S
 sta B,U Copy new device table entry
 decb
 bpl ATTA65
ATTA70 ldx V$DESC,u Dev descriptor module ptr
 ldb M$REVS,x Get re-entrant (sharable) bit
 lda S.MODE,s Caller's mode specified?
 anda M$MODE,x Check with device capabilities
 ldx V$DRIV,u Get device driver ptr
 anda M$MODE,x Compare with capabilities
 cmpa S.MODE,s legal?
 lbne ERMODE ..no; error: illegal mode

* this code removed for edition 7
*
* tst S.BUSY,S Device busy?
* beq ATTA90 ..no
* andb M$REVS,X Descriptor re-entrant bit
* bitb #REENT Sharable logical device?
* lbeq ERBUSY ..no; error: device busy
*ATTA90
*
* end of code remove for edition 7


 inc V$USRS,u Update user count
 bne ATTA91 branch if no overflow
 dec V$USRS,u keep high count
ATTA91 ldx S.STAK,S
 stu R$U,x Return device tbl ptr
 leas S.TMPS,S
 clrb RETURN Carry clear
 rts
 page
**********
* Process Detach Request
*
* Passed: (R$U)=Dev Tbl Entry Ptr
* Destroys: None
*
DETACH ldu R$U,u Get device tbl addr
 ldx V$DESC,u (get for DETACH80)
 lda #255
 cmpa V$USRS,u high count
 lbeq DETACH90 ..yes; don't detach
 dec V$USRS,u Decrement user count
 lbne DETACH80

* Device is not busy, so delete it's device table entry.
* First search for other devices using the same static
* storage, and if none are found, execute TERMINATE routine.

* (U)=device table ptr to delete
 ldx D.Init from configuration module
 ldb DevCnt,x get number of device tbl entries
 pshs U,B
 ldx V$STAT,u Static is unique per incarnation
 clr V$STAT,u mar device as terminating
 clr V$STAT+1,u
 ldy D.DevTbl beginning of device table
DETACH10 cmpx V$STAT,Y The one we're deleting?
 beq DETACH20 ..yes; don't executte termination routine
 leay DEVSIZ,y Skip to next devtbl entry
 decb any left
 bne DETACH10 ..yes; keep looking

* Terminate Physical Device
*   (X)-Static Storage Addr
 ldy D.Proc
 ldb P$ID,y get terminating Process ID
 stb V$USRS,u save it in USE COUNT for Attach
 ldy V$DESC,u (Y) = Descriptor ptr
 ldu V$DRIV,u Get device driver module addr
 exg x,u (u)=static storage addr
 ldd M$EXEC,x Get execution entry offset
 leax d,x Make absolute
 pshs u save static storage addr
 jsr D$TERM,x Execute termination routine
 puls u static storage
 ldx 1,s Device Tbl entry of deleted device
 ldx V$Driv,x Device Driver Ptr
 ldd M$Mem,x (D)=Memory requirement
 addd #$FF
 clrb Round up to nearest page
 os9 F$SRtMem return Static Storage

* Determine if this was the only active I/O port in it's
* memory block, and release the block if so
 ldx 1,s Device Tbl Ptr
 ldx V$DESC,x (X)=Descriptor module
 ifgt LEVEL-1
 ldd M$PORT,X
 beq DETACH20 ..No port
 lbsr PortBlk
 beq DETACH20 ..Zero means UNDECODED I/O Block
 tfr D,X
 ldb 0,s Size of DevTbl
 pshs x,b
 ldu D.DevTbl
UnMap10 cmpu 4,s is this the entry being deleted?
 beq UnMap20 ..Yes; skip it
 ldx V$DESC,u else get Descriptor addr
 beq UnMap20 ..Unused entry; skip it
 ldd M$PORT,x
 beq UnMap20 ..No port
 lbsr PortBlk (D)=Block addr of suspect port
 cmpd 1,s same as block being deleted?
 beq UnMap90 ..Yes; don't release block
UnMap20 leau DevSiz,u skip to next Tbl entry
 dec 0,s entire table searched?
 bne UnMap10 ..No; repeat
 ldx D.SysPRC Systen process ptr
 ldu D.SysDAT system DAT image ptr
 ldy #DAT.BlCt number of DAT Blocks per image
UnMap25 ldd ,u++ get entry
 ifne DAT.WrEn+DAT.WrPr
 endc
 cmpd 1,s this the block?
 beq UnMap30 branch if so
 leay -1,y count block
 bne UnMap25 branch if more
* that's odd, block not found ???
 bra UnMap90
UnMap30 ldd #DAT.Free
 std -2,u mark DAT block as free
 lda P$State,x
 ora #ImgChg Inform system of image change
 sta P$State,x
UnMap90 leas 3,S discard scratch
 endc

DETACH20 puls u,b entry count, desc tbl entry
 ldx V$DESC,u
 clr V$DESC,u Mark Dev Tbl Entry FREE
 clr V$DESC+1,u
 clr V$USRS,u

DETACH80
 ifgt LEVEL-1
 ldd D.Proc get user process ptr
 pshs d save it
 ldd D.SysPRC get system process ptr
 std D.Proc make it current
 endc
* (X)=V$DESC, U device descriptor ptr
 ldy V$DRIV,u
 ldu V$FMGR,u
 os9 F$UnLink Unlink file manager
 leau 0,y
 os9 F$UnLink unlink device driver
 leau 0,x
 os9 F$UnLink unlink device descriptor
 ifgt LEVEL-1
 puls d retrieve user process ptr
 std D.Proc restore it
 endc
DETACH90 lbsr UnQueue Restart any process in I/O queue
 clrb return without error
 rts

**********
* Dupe
*   Process Path Duplication Request
*
UDUPE bsr FNDPTH Find available path
 bcs SDUP90 ..path not found; return error
 pshs x,a Save path#, path tbl ptr
 lda R$A,u Get caller's path
 lda a,x Make system path#
 bsr SDUP10 incr pd use count
 bcs SDUPER Error; return it
 puls x,b
 stb R$A,u Return new path# to user
 sta b,x Duplicate path number
 rts

SDUPER puls pc,x,a Return error

SDUPE lda R$A,u Get path number
SDUP10 lbsr FPATH find (y)=path #
 bcs SDUP90 ..error; return it
 inc PD.CNT,y Increment pd use count
SDUP90 rts

 ttl I/O Name function calls
 page
**********
* Fndpth
*   Find Unused Entry in User'S Local Path Tbl
*
* Passed: None
* Returns: (A)=User Path# found
*          (X)=User Path Tbl Ptr
*         B,CC=Set if Error
* Destroys: None
*
FNDPTH ldx D.Proc
 leax P$PATH,x User's path table ptr
 clra
FNDPD1 tst A,X Available path?
 beq FNDP90 ..yes; return carry clear
 inca
 cmpa #NumPaths End of user's path table?
 bcs FNDPD1 ..no; keep looking
 comb RETURN Carry set
 ldb #E$PthFul Error: path table full
 rts
FNDP90 andcc #$FF-CARRY Return carry clear
 rts

**********
* Open
*   Process Open/Create Request
*
* Passed: (R$A)=Mode: R/W/Exec
*         (R$X)=Pathname Ptr (Preceeding Spaces Ok)
*
UCREAT equ *
UOPEN bsr FNDPTH Find available local path#
 bcs UOPEN9 ..return error if none available
 pshs u,x,a User path#, path tbl ptr, stack
 bsr SOPEN Execute system open/create
 puls u,x,a
 bcs UOPEN9 Error; return error code
 ldb R$A,u Get system path number
 stb a,x Store in user's path table
 sta R$A,u Return user path#
UOPEN9 rts

SCREAT equ *
SOPEN pshs B Save function code
 ldb R$A,u Get r/w/exec mode
 bsr PDINIT Allocate & initialize path desc
 bcs SOPENX ..return if error
 puls b Restore function code
 lbsr FMEXEC Execute file mgr's function
 bcs SMDIR2 ..error; return path
 lda PD.PD,y Return path number to user
 sta R$A,u
 rts

SOPENX puls pc,a Return error

**********
* Makdir
*   Process Makdir Request
*
UMDIR equ *
SMDIR pshs B Save function code
 ldb #DIR.+WRITE. Mode=write new dir
SMDIR1 bsr PDINIT Initialize path descriptor
 bcs SOPENX ..return if error
 puls B
 lbsr FMEXEC Execute file mgr's routine

SMDIR2 pshs b,cc Save error status, error code
 ldu PD.DEV,y
 os9 I$Detach Detach I/O device
 lda PD.PD,y
 ldx D.PthDBT
 os9 F$Ret64 Return path descriptor
 puls pc,b,cc return error status

**********
* Cdir
*   Process Change Directory Request
*
UCDIR equ *
SCDIR pshs B Save function code
 ldb R$A,u Get caller's mode
 orb #DIR. Must be directory file
 bsr PDINIT Allocate/initialize path descriptor
 bcs SOPENX ..return if error
 puls B Restore function code
 lbsr FMEXEC Execute file mgr's routine
 bcs SMDIR2 ..error; detach device, return pd

 ldu D.Proc
 ldb PD.MOD,y Check caller's mode
 bitb #PREAD.+PWRIT.+READ.+WRITE.
 beq SCDIR2 ..no; don't update r/w default
 ldx PD.DEV,y
 stx P$DIO,u Setup new default
 inc V$USRS,x
 bne SCDIR2 branch if no overflow
 dec V$USRS,x keep high count

SCDIR2 bitb #PEXEC.+EXEC. Execute mode?
 beq SCDIR5 ..no; dont update exec default
 ldx PD.DEV,y
 stx P$DIO+6,u
 inc V$USRS,x
 bne SCDIR5 branch if no overflow
 dec V$USRS,x keep high count

SCDIR5 clrb CLEAR Error status
 bra SMDIR2 Detach device, release pd

**********
* Delet
*   Process Delete Request
*
UDELET equ *
SDELET pshs B Save function code
 ldb #WRITE. Default write mode
 bra SMDIR1

**********
* DeletX
*  delete from specified directory
*
UDELETX equ *
SDELETX ldb #I$Delete make a delete call
 pshs B save function code
 ldb R$A,u get deletion mode
 bra SMDIR1


**********
* Pdinit
*
PDINIT
 ifeq LEVEL-1
 pshs  u
 else
 ldx D.Proc get current process ptr
 pshs u,x save process & registers ptr
 endc
 ldx D.PthDBT Get addr of path descr block tbl
 os9 F$All64 Allocate pd storage
 bcs PDIN90 Error - memory full
 inc PD.CNT,y
 stb PD.MOD,y Save mode
 ifeq LEVEL-1
PDIN10 lda ,x+
 else
 ldx D.Proc get process ptr
 ldb P$Task,x get process task number
 ldx R$X,u Get caller's pathname ptr
PDIN10 os9 F$LDABX get next character
 leax 1,x move ptr
 endc
 cmpa #$20 Skip spaces
 beq PDIN10
 leax -1,x Back up to non-space character
 stx R$X,u Save updated pathname ptr
 ldb PD.MOD,y get mode
 cmpa #PDELIM Path delimiter?
 beq PDIN40 ..yes; don't use default name
 ldx D.Proc Get process descriptor addr
 bitb #PEXEC.+EXEC. ..execute mode?
 beq PDIN20 ..no
 ldx P$DIO+6,x Default execution directory
 bra PDIN30
PDIN20 ldx P$DIO,x Default data directory
PDIN30 beq ERRBPN ..no default; bad path name
 ifgt LEVEL-1
 ldd D.SysPRC get system process ptr
 std D.Proc set current process ptr
 endc
 ldx V$DESC,x Device descriptor module ptr
 ldd M$NAME,x Name offset
 leax D,X Device descriptor name ptr
PDIN40 pshs y Save path descriptor
 os9 F$PrsNam Parse device name
 puls y Restore path descriptor
 bcs ERRBPN ..oops; bad path name
 lda PD.MOD,y
 os9 I$Attach
 stu PD.DEV,y
 bcs PDIN.ERR
 ldx V$DESC,u
 leax M$OPT,x
 ldb ,x+
 leau PD.OPT,y
 cmpb #PDSIZE-PD.OPT
 bls PDIN60
 ldb #PDSIZE-PD.OPT-1 Move entire options field
PDIN50 lda ,x+
 sta ,u+ Copy the bytes
PDIN60 decb
 bpl PDIN50
 clrb RETURN Carry clear
PDIN90
 ifeq LEVEL-1
 puls PC,U
 else
 puls U,X retrieve current process ptr
 stx D.Proc reset current process
 rts
 endc

ERRBPN ldb #E$BPNam Error: bad path name
PDIN.ERR pshs B
 lda PD.PD,y
 ldx D.PthDBT
 os9 F$Ret64 return path
 puls b
 coma return carry set
 bra PDIN90 return error

 ttl I/O Path function calls
 page
**********
* Chkpth
*   Validate User Path, And Map Into System Path
*
* Passed: (U)=User Regs, (R$A)=User Path#
* Returns: (A)=System Path#
*          (X)=User Path Table Ptr
* Destroys: None
* Error: (B)=Error Code, CC=Set
*
CHKPTH lda R$A,u Get caller's path number
 cmpa #NumPaths Illegal path number?
 bcc CHKERR ..yes; return error
 ldx D.Proc Get caller's process descriptor addr
 leax P$PATH,x Get caller's local path table
 andcc #$FF-CARRY return carry clear
 lda a,x Get actual path number
 bne CHKP90 ..exit if path is used
CHKERR comb return Carry set
 ldb #E$BPNum Error: bad path number
CHKP90 rts


**********
* Seek
*   Position File
*
USEEK bsr CHKPTH Validate path number
 bcc SSEEK1 ..continue if va
 rts

SSEEK   lda   R$A,u
SSEEK1    bsr   FPATH
         lbcc  FMEXEC
         rts

**********
* Read
* Process Read Or Readln Request
*
UREAD equ *
URDLN   bsr   CHKPTH       get user path #
         bcc   SRDLN1
         rts

SREAD equ *
SRDLN   lda   R$A,u       get user path
SRDLN1    pshs  b
         ldb   #EXEC.+READ.
SRDLN2    bsr   FPATH
         bcs   SRDLNX
         bitb  PD.MOD,y    test bits against mode in path desc
         beq   L050A
         ldd   R$Y,u       else get count from user
         beq   SRDLN.d
         addd  R$X,u       else update buffer pointer with size
         bcs   BADBUF
         subd  #$0001
         lsra
         lsra
         lsra
         lsra
         ldb   R$X,u       get address of buffer to hold read data
         lsrb
         lsrb
         lsrb
         lsrb
         pshs  b
         suba  ,s+
         ldx   D.Proc
         leax  <P$DATImg,x
         lslb
         leax  b,x
SRDLN.c    pshs  a
         ldd   ,x++
         cmpd  #DAT.Free
         puls  a
         beq   BADBUF
         deca
         bpl   SRDLN.c
SRDLN.d    puls  b
         lbra  FMEXEC

BADBUF    ldb   #$F4
         lda   ,s
         bita  #$02
         beq   SRDLNX
         ldb   #E$Write
         bra   SRDLNX

L050A    ldb   #E$BPNum   New in ed. 11
SRDLNX    com   ,s+
         rts


**********
* Write
*   Process Write or Writeln Request
*
UWRITE equ *
UWRLN  bsr   CHKPTH
         bcc   L0516
         rts

SWRITE equ *
SWRLN  lda   R$A,u
L0516    pshs  b
         ldb   #$02
         bra   SRDLN2

FPATH pshs  x
         ldx   D.PthDBT
         os9   F$Find64
         puls  x
         lbcs  CHKERR
FPATH9    rts

**********
* Gstt
*   Process Getstat Request
*
UGSTT lbsr  CHKPTH
         ldx   D.Proc
         bcc   SGSTT10
         rts

SGSTT lda   R$A,u
         ldx   D.SysPRC
SGSTT10    pshs  x,b,a
         lda   R$B,u      get func code
         sta   $01,s
         puls  a
         lbsr  SSEEK1
         puls  x,a
         pshs  u,y,b,cc  New in ed. 11
         ldb   <$20,y  Device type?
         cmpb  #$03  New in ed. 11
         beq   L0553  New in ed. 11
         tsta              SS.Opt?
         beq   SGSTT20
         cmpa  #SS.DevNm  Get device name?
         beq   SGSTT30
L0553    puls  pc,u,y,b,cc  New in ed. 11

SGSTT20    lda   D.SysTsk
         ldb   P$Task,x
         leax  <PD.OPT,y
SGSTT25   ldy   #PD.OPT
         ldu   R$X,u
         os9   F$Move
         leas  $01,s
         puls  pc,u,y,b  New in ed. 11

SGSTT30  lda   D.SysTsk
         ldb   P$Task,x
         pshs  b,a
         ldx   $03,y
         ldx   $04,x
         ldd   $04,x
         leax  d,x
         puls  b,a
         bra   SGSTT25


***********
* PSTT
USSTT equ USEEK
SSSTT equ SSEEK

**********
* Close
*   Process Close Request
*
UCLOSE  lbsr  CHKPTH       get user path #
         bcs   FPATH9
         pshs  b
         ldb   $01,u
         clr   b,x
         puls  b
         bra   SCLOS1

SCLOSE  lda   R$A,u
SCLOS1    bsr   FPATH
         bcs   FPATH9
         dec   $02,y
         tst   $05,y
         bne   SCClos2
         bsr   FMEXEC
SCClos2    tst   $02,y
         bne   FPATH9
         lbra  SMDIR2

***************
* Subroutine GainPath
*   Gain control of Current Path

GainP.zz    os9   F$IOQu
         comb
         ldb   <$19,x
         bne   GainP.9
GainPath    ldx   D.Proc
         ldb   ,x
         clra
         lda   $05,y
         bne   GainP.zz
         stb   $05,y
GainP.9    rts


***************
* Subroutine FMEXEC
*   Dispatch To File MgrS Routine
*
* Passed: (B)=Function Code
*         (Y)=Path Descriptor Ptr
*         (U)=User'S Register Stack
* Error: B,CC=Set id Error
* Destroys: D
*
FMEXEC pshs u,y,x,b Save regs
 bsr GainPath gain control of path
 bcc FMEX20 ..gotten; continue
 leas 1,S discard function code
 bra FMEX30 ..Exit if Signal Error

FMEX20 stu PD.RGS,y Save user register stack
 ldx PD.DEV,y Get device tbl entry address
 ldx V$FMGR,x Get file manager module address
 ldd M$EXEC,X
 leax D,X Get file mgr's execution entry addr
 ldb ,S+ Restore caller's function byte
 subb #I$Create Make it an index
 lda #3
 mul TIMES 3 bytes per lbra entry
 jsr D,X Exec file mgr's routine
FMEX30 pshs B,CC save error status, code
 bsr UnQueue Wake Up next in I/O Queue
 ldy 4,s path descriptor ptr
 ldx D.Proc
 lda P$ID,x get current process id
 cmpa PD.CPR,y controlling Path Descriptor?
 bne FMEX90 ..No
 clr PD.CPR,y release path
FMEX90 puls pc,u,y,x,b,cc return

***************
* Subroutine UnQueue
*   Wake next process in I/O queue (if any)

UnQueue pshs y,x save regs
 ldy D.Proc
 bra UnQue80 While not last proc in IO queue

UnQue10 clr P$IOQN,y clear next ptr
 ldb #S$Wake
 os9 F$Send wake up next process in queue

 ifeq LEVEL-1
         ldx D.PrcDBT
         os9   F$Find64
 else
 os9 F$GProcP find next process descriptor
 endc

 clr P$IOQP,y clear previous link in next
UnQue80 lda P$IOQN,y process ID of next process
 bne UnQue10 Endwhile
 puls pc,y,x
 page
***************
* Irq Service Routines
* ====================
************************
* Irq Polling Table Format
*
* Polling Address  (2)
* Flip Byte        (1)
* Poll Mask        (1) Must Be Non-Zero
* Service Address  (2)
* Static Storage   (2) Must Be Unique To Device
* Priority         (1) 0=Lowest, 255=Highest
*
* Irq Polling Table Maintenance Entry Point
*
* (U)=Caller'S Register Save
*   R$D,U=Polling Addr
*   R$X,U=Ptr To Flip,Mask,Priority
*   R$Y,U=Service Addr
*   R$U,U=Storage Addr
*
IOPOLL ldx R$X,u Get ptr to flip,mask,priority
 ldb 0,x
 ldx 1,x
 clra default carry clear
 pshs cc save Interrupt State
 pshs x,b Save flip,mask,priority
 ldx D.Init From configuration rom addr
 ldb PollCnt,x Get polling table entry count
 ldx D.PolTbl Get addr of polling tbl
 ldy R$X,u Delete?
         beq   IOPOL4
         tst   $01,s
         beq   L067B
         decb
         lda   #POLSIZ
         mul
         leax  d,x
         lda   $03,x
         bne   L067B
         orcc  #$50
IOPOL1    ldb   $02,s
         cmpb  -(POLSIZ-Q$PRTY),x compare with prev entry's prior
         bcs   IOPOL3
         ldb   #POLSIZ
IOPO11    lda   ,-x
         sta   POLSIZ,x
         decb
         bne   IOPO11
         cmpx  D.PolTbl
         bhi   IOPOL1
IOPOL3    ldd   $01,u
         std   ,x
         ldd   ,s++
         sta   $02,x
         stb   $03,x
         ldb   ,s+
         stb   $08,x
         ldd   $06,u
         std   $04,x
         ldd   $08,u
         std   $06,x
         puls  pc,cc
IOPOL4    leas  $04,s
         ldy   $08,u
IOPOL5    cmpy  $06,x
         beq   IOPOL6
         leax  POLSIZ,x
         decb
         bne   IOPOL5
         clrb
         rts

IOPOL6    pshs  b,cc
         orcc  #$50
         bra   IOPO75
IOPOL7    ldb   POLSIZ,x
         stb   ,x+
         deca
         bne   IOPOL7
IOPO75    lda   #POLSIZ
         dec   $01,s
         bne   IOPOL7
IOPOL8    clr   ,x+
         deca
         bne   IOPOL8
         puls  pc,a,cc

L067B    leas  $04,s
POLLERR    comb
         ldb   #E$Poll   
         rts

 page
***************
* Irq Polling Routine
* ===================

* Polling Table Format:

* Polling Address  (2)
* Flip Byte        (1)
* Poll Mask        (1)
* Service Address  (2)
* Static Storage   (2)
* Priority         (1)

* Interrupt Request (Irq) Service Entry Point

IOIRQ ldy D.PolTbl Get addr of polling table
 ldx D.Init From configuration module
 ldb PollCnt,x Get polling table entry count
 bra IOIRQ2
IOIRQ1 leay POLSIZ,y Skip to next entry in table
 decb end of table?
 beq POLLERR ..yes; exit - not found
IOIRQ2 lda [Q$POLL,y] Poll device
 eora Q$FLIP,y Flip any inverted hardware bits
 bita Q$MASK,y Is device interrupting?
 beq IOIRQ1 ..no; go try next device
 ldu Q$STAT,y Get storage for device handler
 pshs Y,B
 jsr [Q$SERV,y] Exec interrupt service routine
 puls y,b
 bcs IOIRQ1 false interrupt, keep checking
 rts

************************************************************
*
*     Subroutine Load
*
*   Load Module service routine
*
LOAD    pshs  u
         ldx   R$X,u       get pathname to load
         bsr   LModule
         bcs   LoadXit
         puls  y           get caller's reg ptr in Y
Load.A    pshs  y
         stx   R$X,y       save updated pathlist
         ldy   ,u          get DAT image pointer
         ldx   $04,u       get offset within DAT image
         ldd   #$0006
         os9   F$LDDDXY
         ldx   ,s
         std   $01,x
         leax  ,u
         os9   F$ELink
         bcs   LoadXit
         ldx   ,s
         sty   R$Y,x
         stu   R$U,x
LoadXit    puls  pc,u
 page
************************************************************
*
*     Subroutine Sysload
*
SysLoad pshs u save registers ptr
 ldx R$X,u get name string ptr
 bsr LModule load module
 bcs SysLXit branch if error
 puls y retrieve registers ptr
 ldd D.Proc get current process ptr
 pshs y,d save registers
 ldd R$U,y get process ptr
 std D.Proc make it current
 bsr Load.A link loaded module
 puls x retrieve current process ptr
 stx D.Proc reset current process
SysLXit puls pc,u

 page
************************************************************
*
*     Subroutine Lmodule
*
*   Open specified path, read and validate modules until error

realorg set .
 org 0
TotRAM rmb 2 total ram acquired for block
TotMod rmb 2 total module size in block
CurrProc rmb 2 current process ptr
Path rmb 1 path number
ErrCode rmb 1 error code
Header rmb M$IDSize module header scratch
locals set .

 org realorg
ModPtr set locals+0 Module block offset
PathName set locals+2 Path name string ptr
ProcPtr set locals+4 temporary process ptr
ModBlk set locals+6 Module block number

stacked set 0


LModule os9 F$AllPrc get process descriptor
         bcc   LMod.1
         rts
LMod.1    leay  ,u
         ldu   #0
         pshs  u,y,x,b,a
         leas  <-$11,s
         clr   $07,s
         stu   ,s
         stu   $02,s
         ldu   D.Proc
         stu   $04,s
         clr   $06,s
         lda   P$Prior,u  get priority
         sta   P$Prior,y  save
         lda   #EXEC.     from exec dir
         os9   I$Open
         bcs   LModErr
         sta   $06,s
         stx   <$13,s
         ldx   <$15,s
         os9   F$AllTsk
         bcs   LModErr
         stx   D.Proc
LMod.J    ldd   #$0009
         ldx   $02,s
         lbsr  GetModul
         bcs   LModErr
         ldu   <$15,s
         lda   P$Task,u
         ldb   D.SysTsk
         leau  $08,s
         pshs  x
         ldx   $04,s
         os9   F$Move
         puls  x
         ldd   M$ID,u
         cmpd  #M$ID12
         bne   LModErrA
         ldd   M$Size,u
         subd  #M$IDSize
         lbsr  GetModul
         bcs   LModErr
         ldy   <$15,s     get proc desc ptr
         leay  <P$DATImg,y
         tfr   y,d
         ldx   $02,s
         os9   F$VModul
         bcc   LMod.K
         cmpb  #E$KwnMod
         beq   LMod.L
         bra   LModErr
LMod.K    ldd   $02,s
         addd  $0A,s
         std   $02,s
LMod.L    ldd   <$17,s
         bne   LMod.J
         ldd   MD$MPtr,u
         std   <$11,s
         ldx   ,u
         ldd   ,x
         std   <$17,s
         ldd   $06,u
         addd  #$0001
         beq   LMod.J
         std   $06,u
         bra   LMod.J
LModErrA    ldb   #E$BMID
LModErr    stb   $07,s
         ldd   $04,s
         beq   LMod.M
         std   D.Proc
LMod.M    lda   $06,s
         beq   LMod.O
         os9   I$Close
LMod.O    ldd   $02,s
         addd #DAT.BlSz-1 Round up
         lsra
         lsra
         lsra
         lsra
         sta   $02,s
         ldb   ,s
         beq   LMod.Q
         lsrb
         lsrb
         lsrb
         lsrb
         subb  $02,s
         beq   LMod.Q
         ldx   <$15,s
         leax  <P$DATImg,x
         lsla
         leax  a,x
         clra
         tfr   d,y
         ldu   D.BlkMap
LMod.O2    ldd   ,x++
         clr   d,u
         leay  -$01,y
         bne   LMod.O2
LMod.Q    ldx   <$15,s
         lda   P$ID,x
         os9   F$DelPrc
         ldd   <$17,s
         bne   LMod.R
         ldb   $07,s
         stb   <$12,s
         comb
         bra   LModXit
LMod.R    ldu   D.ModDir
         ldx   <$11,s
         ldd   <$17,s
         leau  -MD$ESize,u
LMod.S    leau  MD$ESize,u
         cmpu  D.ModEnd
         bcs   LMod.T
         comb
         ldb   #E$MNF
         stb   <$12,s
         bra   LModXit
LMod.T    cmpx  MD$MPtr,u
         bne   LMod.S
         cmpd  [MD$MPDAT,u]
         bne   LMod.S
         ldd   MD$Link,u
         beq   LMod.U
         subd  #$0001
         std   MD$Link,u
LMod.U    stu   <$17,s
         clrb
LModXit    leas  <$11,s
         puls  pc,u,y,x,b,a

 page
stacked set stacked+8
*****************************************************
*
*            GetModul routine
*
*  Input: D = Size of new section
*         X = Present module size in RAM
*
* Output: X = New module size in RAM
*
*   Data: ProcPtr(stacked), D.BlkMap, Totram(stacked)
*
*  Calls: None
*
GetModul pshs y,x,b,a save regs
 addd 2,s find new totmod size
 std 4,s save it for caller
 cmpd TotRAM+stacked,s is there enough RAM?
 bls GetM.R yes. skip mem request
 addd #DAT.BlSz-1 round to next block
 lsra
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 cmpa #DAT.BlCt-1 check for full map
 bhi GetM.Err bra if so
 ldb TotRAM+stacked,s get RAM used
 lsrb
 lsrb get blks RAM used
 ifge DAT.BlSz-2048
 lsrb
 ifge DAT.BlSz-4096
 lsrb
 endc
 endc
 pshs b stack it
 exg b,a
 subb ,s+ get delta blks
 lsla adj for 2 byte entries
 ldu ProcPtr+stacked,s get process ptr
 leau P$DATImg,u make it ptr to DAT image
 leau a,u make ptr to free space
 clra
 tfr d,x get count of blocks in X
 ldy D.BlkMap get blk bits
 clra init blk number
 clrb
GetM.B tst ,y+ chk if blk free
 beq GetM.D bra if so
GetM.C addd #1 update blk number
 cmpy D.BlkMap+2 chk if end of map
 bne GetM.B bra if not end
GetM.Err    comb
 ldb #E$MemFul
 bra GetM.X exit

GetM.D    inc   -1,y
         std   ,u++
         pshs  b,a
         ldd   $0A,s
         addd  #DAT.BlSz
         std   $0A,s
         puls  b,a
         leax  -$01,x
         bne   GetM.C
         ldx   <$1D,s
         os9   F$SetTsk
         bcs   GetM.X
GetM.R    lda   $0E,s
         ldx   $02,s
         ldy   ,s
         os9   I$Read
GetM.X leas 4,s return scratch
 puls pc,x done

*****
*
*  Print Error Routine
*

ErrHead   fcc "ERROR #"
ErrNum   equ   *-ErrHead 
 fcb  '0-1,'9+1,'0
         fcb   C$CR
ErrMessL equ   *-ErrHead 

PRTERR    ldx   D.Proc
         lda   <P$PATH+2,x  get stderr path
         beq   L08CC
         leas  -ErrMessL,s  make room on stack
         leax  <ErrHead,pcr
         leay  ,s
L0893    lda   ,x+
         sta   ,y+
         cmpa  #C$CR       done?
         bne   L0893
         ldb   R$B,u
* Convert error code to decimal
L089D    inc   ErrNum+0,s
         subb  #100
         bcc   L089D
L08A3    dec   ErrNum+1,s
         addb  #10
         bcc   L08A3
         addb  #$30
         stb   ErrNum+2,s
         ldx   D.Proc
         ldu   P$SP,x      get the stack pointer
         leau  -ErrMessL,u put a buffer on it
         lda   D.SysTsk
         ldb   P$Task,x    get task number of process
         leax  ,s
         ldy   #ErrMessL  get length of text
L08BD    os9   F$Move
         leax  ,u
         ldu   D.Proc
         lda   <P$PATH+2,u get path number
         os9   I$WritLn
         leas  ErrMessL,s  purge the buffer
L08CC    rts
 page
*****
*
*  Subroutine Ioqueu
*
* Link Process Into Ioqueue And Go To Sleep
*
IOQueu    ldy   D.Proc
L08D0    lda   P$IOQN,y
         beq   L08EF
         cmpa  $01,u
         bne   L08EA
         clr   P$IOQN,y
         os9   F$GProcP
         bcs   IOQuExit
         clr   $0F,y
         ldb   #$01
         os9   F$Send
         bra   L08F6

L08EA    os9   F$GProcP
         bcc   L08D0
L08EF    lda   $01,u
L08F1    os9   F$GProcP
         bcs   IOQuExit
L08F6    lda   P$IOQN,y
         bne   L08F1
         ldx   D.Proc
         lda   ,x
         sta   P$IOQN,y
         lda   ,y
         sta   $0F,x
         ldx   #$0000
         os9   F$Sleep
         ldu   D.Proc
         lda   P$IOQP,u
         beq   IOQ.F
         os9   F$GProcP
 bcs IOQ.F branch if dead
 lda P$IOQN,y normal queue exit?
 beq IOQ.F branch if so
*
* Graceful Abnormal Queue Queue Exit
*
 lda P$IOQN,u get next process ID
 sta P$IOQN,y put in previous process
 beq IOQ.F branch if none
 clr P$IOQN,u clear next process link

 ifeq LEVEL-1
         ldx   D.PrcDBT
         os9   F$Find64
 else
 os9 F$GProcP get process ptr
 endc

 bcs IOQ.F branch if dead
 lda P$IOQP,u get previous process ID
 sta P$IOQP,y put in next process
IOQ.F clr P$IOQP,u clear predecessor link
IOQuExit rts

 emod Module Crc
IOEnd equ *
