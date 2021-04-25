         nam   Input/Output Manager
         ttl   Module Header

* Copyright 1980 by Motorola, Inc., and Microware Systems Corp.,
* Copyright 1982 by Microware Systems Corporation
* Reproduced Under License

* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!

* This is a disassembly of the IOMan edition 10 distributed with OS-9 for Dragon 128
* OS-9 Level 2. It contains modifications in some allocation routines.

***************
* I/O Manager

 mod IOEnd,IOName,Systm+Objct,ReEnt+1,IOINIT,0
IOName fcs /IOMan/  module name

************************************************************
*
*     Edition History
*
* Edition   Date    Comments
*
*    1   pre-82/08  beginning of history                LAC
*
*    2    82/08/24  modifications for MC6829            LAC
*
*    3    82/09/27  conditionals added for LI & LII     WGP
*
*    4    82/10/21  I$Deletx system call added          WGP
*
*    5    83/01/17  change "F$Load" to set loading process priority
*                   and to not use the system process descriptor
*
*    6    83/02/18  change "PortBlk" to ignore untranslated
*                   address bits
*         83/02/24  Moved device termination routines from IODEL
*                   into DETACH.  Minimized ATTACH and DETACH use
*                   of system's process pointer.  Changed SCDIR
*                   to leave device table use count of old directory
*                   unchanged.
*
*    7    83/04/06  Removed testing for device being busy(re-entrant).
*                   This should be taken care of in the link call.
*                   Removed to take care of problems in using multiple
*                   devices at the same address. (IO Processor)  RES
*         83/04/27  Change F$Load to open file before gobbling up
*                   it's large memory block.
*
*    8    83/05/04  extensive mods for non-contiguous modules.
*         83/06/16  fixed load bugs - mod dir entry returned must
*                   be searched for after load, by keeping block
*                   and offset for reference.  Also link count is
*                   temporarily bumped to keep module around during
*                   load.
*
*    9    83/07/17  add limit checking for I$Read, I$ReadLn, I$Write,
*                   and I$WritLn
*
*  10     83/11/01 add error path/module messages, improved error printing
*                                 Vivaway Ltd.             PSD

 fcb 10 edition number

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

**********
CRASH jmp [D$REBOOT] Doom
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
 ifne EXTERR
 fcb F$InsErr&User
 fdb  InsErr-*-2
 endc
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
IODEL10 ldy V$DESC,u empty table entry?
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
 endc
 else
 endc
 endc

 ttl File Manager I/O functions
 page
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

ATTA40 ldx V$STAT,s Is device already initialized?
 lbne ATTA60 ..yes; don't need new static
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
 ldd S.Port,s Get extended port addr
 lbsr PortBlk convert to block addr
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
*   Allocate And Initialize Path Descriptor
*
* Passed: (B)=Mode (R/W/Exec)
*         (U)=User Stack
* Returns: (Y)=Pd
*         B,CC=Set if Error
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
 bcc SSEEK1 ..continue if valid
 rts

SSEEK lda R$A,u Get (system) path#
SSEEK1 bsr FPATH Find (y)=path descriptor
 lbcc FMEXEC go call file manager
 rts

**********
* Read
* Process Read Or Readln Request
*
UREAD equ *
URDLN bsr   CHKPTH Validate path number
 bcc SRDLN1 ..continue if valid
 rts

SREAD equ *
SRDLN lda R$A,u Get (system) path#
SRDLN1 pshs B Save function code
 ldb #READ.+EXEC.
SRDLN2 bsr FPATH Find (y)=path descriptor
 bcs SRDLNX ..return error if any
 bitb PD.MOD,y Legal i/o on this path?
 beq BADPTH ..no; error - bad path number
*
*    check limits of read/write buffer
*
 ldd R$Y,u get transfer size
 beq SRDLN.d branch if none
 addd R$X,u add buffer address
 bcs BADBUF branch if overflow
 ifge LEVEL-2
 subd #1 get buffer end address
 lsra get last block number
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 ldb R$X,u get MSB buffer address
 lsrb get DAT image index
 lsrb
 ifge DAT.BlSz-2048
 lsrb
 ifge DAT.BlSz-4096
 lsrb
 endc
 endc
 pshs b make temp
 suba ,s+ get block count - 1
 ldx D.Proc get process ptr
 leax P$DATImg,x get DAT image ptr
 aslb convert index to offset
 leax b,x get block ptr
SRDLN.c pshs a save count
 ldd ,x++ get block number
 cmpd #DAT.Free is it allocated?
 puls a retrieve count
 beq BADBUF branch if not allocated
 deca count block
 bpl SRDLN.c branch if more
 endc
SRDLN.d puls B Restore function code
 lbra FMEXEC ..execute file mgr's function

BADBUF ldb #E$Read err: read error
 lda 0,s get function
 bita #WRITE. writing?
 beq SRDLNX branch if not
 ldb #E$Write err: write error
 bra SRDLNX

BADPTH ldb #E$BPNam Error: bad path number
SRDLNX com ,S+
 rts

**********
* Write
*   Process Write or Writeln Request
*
UWRITE equ *
UWRLN bsr CHKPTH Validate path number
 bcc SWRLN1 ..continue if valid
 rts

SWRITE equ *
SWRLN lda R$A,U Get (system) path#
SWRLN1 pshs B Save function code
 ldb #WRITE.
 bra SRDLN2 Get pd, check code, exec function

FPath pshs x save x
 ldx D.PthDBT
 os9 F$Find64 Find (x)=path desc ptr
 puls x retrieve x
 lbcs CHKERR ..error; return useful error code
FPath9 rts

**********
* Gstt
*   Process Getstat Request
*
UGSTT lbsr CHKPTH Validate path number
 ifgt LEVEL-1
 ldx D.Proc get process ptr
 endc
 bcc SGSTT10 ..good
 rts

SGSTT lda R$A,U Get system path#

 ifeq LEVEL-1
 else
 ldx D.SysPRC get system process ptr
SGSTT10 pshs D,X save function code, process ptr
 lda R$B,u recover getstat code
 sta 1,S
 puls a
 lbsr SSEEK1 exec file manager getstat
 puls x,a restore getstat code, process ptr
 pshs u,y,cc save error status
 tsta Read options Getstat code?
 beq SGSTT20 ..yes
 cmpa #SS.DevNm Read Device Name?
 beq SGSTT30 ..Ues
 puls pc,u,y,cc return error status

SGSTT20 lda D.SysTsk get source task
 ldb P$Task,x get destination task
 leax PD.OPT,y get source ptr
SGSTT25 ldy #32 Copy 32 Bytes
 ldu R$X,u get destination ptr
 os9 F$Move move options
 leas 1,s
 puls pc,u,y

SGSTT30 lda D.SysTsk source task
 ldb P$Task,x Destination task
 pshs D
 ldx PD.DEV,y device table ptr
 ldx V$DESC,x Device descriptor
 ldd M$Name,x Name offset
 leax D,X
 puls D
 bra SGSTT25 move 32 bytes
 endc

***********
* PSTT
USSTT equ USEEK
SSSTT equ SSEEK

**********
* Close
*   Process Close Request
*
UCLOSE lbsr CHKPTH Validate path number
 bcs FPATH9 ..return if error
 pshs b
 ldb R$A,u Get user's path number
 clr b,x Release user's path tbl entry
 puls b Restore function code
 bra SCLOS1

SCLOSE lda R$A,u
SCLOS1 bsr FPATH Find (y)=path desc ptr
 bcs FPATH9 ..return if error
 dec PD.CNT,y decrement image count
 tst PD.CPR,y is path currently busy?
 bne SCClos2 ..Yes; don't interrupt File Manager
 bsr FMEXEC ..else notify FM of dead user
SCClos2 tst Pd.Cnt,y detach only if last
 bne FPATH9 ..close only if last image
 lbra SMDIR2 Detach device, release pd

***************
* Subroutine GainPath
*   Gain control of Current Path

* Passed: none
* Returns: CC carry set, B=signal code if signal error
*          B=PD.CPR = this process if success
* Destroys: A,B,X

GainP.zz os9 F$IOQU Wait in I/O queue
 comb set carry
 ldb P$Signal,x Wake up signal?
 bne GainP.9 ..no; return signal as error

GainPath ldx D.PROC
 ldb P$ID,x get current process id
 clra clear carry
 lda PD.CPR,y Path descriptor busy?
 bne GainP.zz ..Yes; sleep for user
 stb PD.CPR,y mark current user
GainP.9 rts

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

UnQueue pshs Y,X save regs
 ldy D.Proc
 bra UnQue80 While not last proc in IO queue

UnQue10 clr P$IOQN,y clear next ptr
 ldb #S$Wake
 os9 F$Send wake up next process in queue

 ifeq LEVEL-1
 ldx D.PrcDBT
 os9 F$Find64 find next process descriptor
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
 beq IOPOL4 ..yes
 tst 1,s Mask zero?
 beq POLFUL ..yes; error: mask must be non-zero
 decb
 lda #POLSIZ
 mul
 leax D,X Compute addr of last tbl entry
 lda Q$MASK,x Is the table full (mask not 0)?
 bne POLFUL ..yes; error: polling table full
 orcc #IntMasks Disable IRQs during Maintenance
IOPOL1 ldb 2,s Get priority of new device
 cmpb (Q$PRTY-POLSIZ),X Above the previous entry's?
 bcs IOPOL3 ..no; insert it here in the table
 ldb #POLSIZ
IOPO11 lda ,-x
 sta POLSIZ,x Copy table entry down
 decb
 bne IOPO11 (move to next higher entry)
 cmpx D.PolTbl Is this the top of the table?
 bhi IOPOL1 ..no; repeat
IOPOL3 ldd R$D,u Copy parameters into tbl entry
 std Q$POLL,x ..polling address
 ldd ,s++
 sta Q$FLIP,x ..flip
 stb Q$MASK,x ..masl
 ldb ,s+
 stb Q$PRTY,x ..priority
 ldd R$Y,u
 std Q$SERV,x ..service address
 ldd R$U,u
 std Q$STAT,x ..static storage address
 puls PC,CC return (carry clear)

* Delete An Entry From Polling Tbl
IOPOL4 leas 4,s Clean up stack
 ldy R$U,u Caller's static address
IOPOL5 cmpy Q$STAT,x Is this the entry?
 beq IOPOL6 ..yes; good
 leax POLSIZ,x Skip to next table entry
 decb end of table?
 bne IOPOL5 ..no; repeat
* Error? - Table Entry Not Found
 clrb return Carry clear
IORTS rts

IOPOL6 pshs b,cc Save entry count
 orcc #IntMasks Disable IRQs during Maintenance
 bra IOPO75
IOPOL7 ldb POLSIZ,x
 stb ,x+ Copy next entry up over this one
 deca
 bne IOPOL7 (move down to next entry)
IOPO75 lda #POLSIZ Get polling table entry size
 dec 1,s At last entry yet?
 bne IOPOL7 ..no; copy another entry
IOPOL8 clr ,x+ Clear out last entry
 deca
 bne IOPOL8
 puls pc,a,cc return

POLFUL leas 4,S discard temps
POLLERR comb return carry set
 ldb #E$Poll Error: polling table entry not found
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

 page
 ifeq LEVEL-1
        jmp NOWHERE
 else
************************************************************
*
*     Subroutine Load
*
*   Load Module service routine
*
* Input: U = registers ptr
*            R$X,y = Path name string ptr
*
* Output: Carry clear if successful; set otherwise
*
* Data: none
*
* Calls: Lmodule
*
Load pshs u save registers ptr
 ldx R$X,u get path name ptr
 bsr LModule load module
 bcs LoadXit branch if load error
 puls y retrieve registers ptr
Load.A pshs y save registers ptr
 stx R$X,y return update ptr
 ldy MD$MPDAT,u get module DAT image ptr
 ldx MD$MPtr,u get module offset
 ldd #M$Type get module type offset
 os9 F$LDDDXY get type & revision bytes
 ldx 0,s get registers ptr
 std R$D,x return type & revision
 leax 0,u copy module entry ptr
 os9 F$ELink link module in
 bcs LoadXit branch if error
 ldx 0,s get registers ptr
 sty R$Y,x return execution entry
 stu R$U,x return module ptr
LoadXit puls pc,u
 page
************************************************************
*
*     Subroutine Sysload
*
*   System Load service routine
*
* Input: U = registers ptr
*        R$X,u = Path name string ptr
*        R$U,u = Process Descriptor to load
*
* Output: Carry clear if successful; set otherwise
*
* Data: D.Proc
*
* Calls: Lmodule, Load.A
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
*
* Input: X = Path Name string ptr
*
* Output: U = Module Directory entry of first module loaded
*
* Data: D.Blkmap, D.Proc, D.Sysprc
*
* Calls: none
*
*
*     Local Definitions
*
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
 bcc LMod.1 branch if successful
 rts
LMod.1 leay 0,u copy process ptr
 ldu #0 clear directory entry ptr
 pshs u,y,x,b,a save registers
 leas -locals,s make room for scratch
 clr ErrCode+stacked,s clear error code
 stu TotRAM+stacked,s clear total ram
 stu TotMod+stacked,s clear total module
 ldu D.Proc get current process ptr
 stu CurrProc+stacked,s save it
 clr Path+stacked,s clear path number
 lda P$Prior,u get requesting process priority
 sta P$Prior,y set loading process priority
 lda #EXEC. get open mode
 os9 I$Open open path
 bcs LModErr branch if error
 sta Path+stacked,s save path number
 stx PathName+stacked,s save string ptr
 ldx ProcPtr+stacked,s get process ptr
 os9 F$AllTsk set task
 bcs LModErr branch if error
 stx D.Proc install as current process
LMod.J ldd #M$IDSize get header size
 ldx TotMod+stacked,s get present module size
 lbsr GetModul check/expand RAM space, read ID
 bcs LModErr branch if error
 ldu ProcPtr+stacked,s get new process ptr
 lda P$Task,u get process task number
 ldb D.SysTsk get system task number
 leau Header+stacked,s get module header ptr
 pshs x save advanced TotMod ptr
stacked set stacked+2
 ldx ToTMod+stacked,s get mod beg ptr
 os9 F$Move move header here
 puls x restore advanced TotMod ptr
stacked set stacked-2
 ldd 0,u get module sync bytes
 cmpd #M$ID12 are they good?
 bne LModErrA branch if not
 ldd M$Size,u get module size
 subd #M$IDSize subtract header, already gotten
* X already contains old modsiz + new ID
 lbsr GetModul check/expand RAM, read module
 bcs LModErr branch if error
 ldy ProcPtr+stacked,s get process ptr
 leay P$DATImg,y make ptr to DAT image
 tfr y,d
 ldx TotMod+stacked,s get module beginning ptr
 os9 F$VModul validate module
 bcc LMod.K branch if no error
 cmpb #E$KwnMod is it known module?
 beq LMod.L branch if so
 bra LModErr
LMod.K ldd TotMod+stacked,s get total size
 addd Header+M$Size+stacked,s add module size
 std TotMod+stacked,s update size
LMod.L ldd ModBlk+stacked,s module found/loaded?
 bne LMod.J branch if so
 ldd MD$MPtr,u get module offset ptr
 std ModPtr+stacked,s save module ptr
 ldx MD$MPDAT,u get DAT image ptr
 ldd 0,x get first block number
 std ModBlk+stacked,s save it
 ldd MD$Link,u get link count
 addd #1 bump it temporarily
 beq LMod.J Skip store if rollover
 std MD$Link,u save new count
 bra LMod.J branch to check all
LModErrA ldb #E$BMID err: bad module id
LModErr stb ErrCode+stacked,s save err for return
 ldd CurrProc+stacked,s get current process ptr
 beq LMod.M branch if not set
 std D.Proc return to current process status
LMod.M lda Path+stacked,s get path number
 beq LMod.O branch if none
 os9 I$Close close path
LMod.O ldd TotMod+stacked,s get modules size
 addd #DAT.BlSz-1 round to next block
 lsra get block number
 lsra
 ifge DAT.BlSz-2048
 lsra
 ifge DAT.BlSz-4096
 lsra
 endc
 endc
 sta TotMod+stacked,s save block number
 ldb TotRAM+stacked,s get total ram size
 beq LMod.Q branch if none
 lsrb make block count
 lsrb
 ifge DAT.BlSz-2048
 lsrb
 ifge DAT.BlSz-4096
 lsrb
 endc
 endc
 subb TotMod+stacked,s get unused count
 beq LMod.Q branch if none
 ldx ProcPtr+stacked,s get proc ptr
 leax P$DATImg,x make ptr to image
 lsla make 2 byte entries
 leax a,x get to extra blks
 clra make proper reg
 tfr d,y
 ldu D.BlkMap get blk bits
LMod.O2 ldd ,x++ get blk number
 clr d,u show blk not in use
 leay -1,y dec max blk cnt
 bne LMod.O2 bra if more blks
LMod.Q ldx ProcPtr+stacked,s get process ptr
 lda P$ID,x get process ID
 os9 F$DelPrc remove process
 ldd ModBlk+stacked,s has entry been found?
 bne LMod.R branch if so
 ldb ErrCode+stacked,s any other errors?
 stb locals+stacked+1,s return it
 comb set carry
 bra LModXit
LMod.R ldu D.ModDir get ptr to module dir
 ldx ModPtr+stacked,s get module offset in block
 ldd ModBlk+stacked,s get module block number
 leau -MD$ESize,u preset back one entry
LMod.S leau MD$ESize,u get next dir entry
 cmpu D.ModEnd end of search?
 bcs LMod.T bra if not
 comb
 ldb #E$MNF module entry not found
 stb locals+stacked+1,s
 bra LModXit error exit
LMod.T cmpx MD$MPtr,u is this module?
 bne  LMod.S bra if no chance
 cmpd [MD$MPDAT,u] is this really module?
 bne LMod.S bra if not
 ldd MD$Link,u get link count
 beq LMod.U bra if already zero
 subd #1 decrement link count(for above inc)
 std MD$Link,u save it
LMod.U stu ModBlk+stacked,s return U --> Mod Dir entry
 clrb clear carry
LModXit leas locals,s return scratch
 puls pc,u,y,x,b,a

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
 ifeq CPUType-DRG128
 lbls GetM.R yes. skip mem request
 else
 bls GetM.R yes. skip mem request
 endc
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
TESTM set 0
 ifeq CPUTYPE-DRG128+TESTM
 ldb #DAT.GBlk start above graphics blocks
 leay  b,y
 else
 clrb
 endc
GetM.B tst ,y+ chk if blk free
 beq GetM.D bra if so
GetM.C addd #1 update blk number
 cmpy D.BlkMap+2 chk if end of map
 bne GetM.B bra if not end
 ifeq CPUTYPE-DRG128+TESTM
 ldy D.BlkMap now try graphics blocks
 clra
GetM.F pshs y save map ptr
 leay BlkTrans,pcr point at translation table
 ldb a,y get block number
 puls y retrieve map ptr
 tst b,y is block free?
 beq GetM.H ..yes; claim it
GetM.G inca bump counter
 cmpa #DAT.GBlk any blocks left?
 bcs GetM.F ..yes
 endc
GetM.Err comb set carry for error
 ldb #E$MemFul
 bra GetM.X exit

 ifeq CPUTYPE-DRG128+TESTM
GetM.H inc b,y claim block
 clr ,u+ put block number in image
 stb ,u+
 pshs a save count
stacked set stacked+1
 ldd TotRAM+stacked,s get old RAM count
 addd #DAT.BlSz add new block
 std TotRAM+stacked,s save RAM count
 puls a retrieve block count
stacked set stacked-1
 leax -1,x count down blocks
 bne GetM.G ..more needed
 bra GetM.I ..finish off
 endc
GetM.D inc -1,y allocate block
 std ,u++ save blk # in image
stacked set stacked+2
 pshs d save blk number
 ldd TotRAM+stacked,s get old RAM count
 addd #DAT.BlSz add new block
 std TotRAM+stacked,s save new RAM count
 puls d restore lbk number
stacked set stacked-2
 leax -1,x count down blocks needed. done?
 bne GetM.C bra if not
GetM.I ldx ProcPtr+stacked,s get process ptr
 os9 F$SetTsk set DAT image for task
 bcs GetM.X bra if error
GetM.R lda Path+stacked,s get path number
 ldx 2,s get ptr to RAM for module
 ldy 0,s get size of read
 os9 I$Read get the module
GetM.X leas 4,s return scratch
 puls pc,x done

 ifeq CPUTYPE-DRG128
*
* Graphics block translation table.
* Optimizes graphics memory allocation
*
BlkTrans fcb $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
      fcb $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F
 endc
 page
 endc
*****
*
*  Print Error Routine
*

 ifne EXTERR
**********************************************
*
*       Subroutine PrtErr
*
*  Print error message
*
* Input: U = registers pointer
*         R$B,U=error number
*
* Output: U unchanged
*         Carry clear
*
* Data: D.Proc, D.SysPrc
*
* Calls: F$Link, F$Unlink, I$Open, I$Close,
*        I$ReadLn, I$WritLn
*
* CAUTION: THIS SUBROUTINE TAKES 100+ BYTES OF STACK
*
* The mechanism.
* A 32 byte space in the process descriptor of each process
* is reserved for a name/pathlist of a module or file
* that is assumed to contain the error messages for that
* process. This name is installed by a call to InsErr,
* (F$InsErr). When PrtErr is called, this name is first
* used to try and link to a module, then to a file,
* in the EXEC mode. Both file and module
* have the same structure - i.e., the file is the module
* on disk! The message table in the module/file is then
* searched for the error number, just as in Printerr. If
* it is not found, or no module or file could be found,
* there is a default for the whole system, and a process
* can install a replacement for a subset of error numbers.
* Because of the module structure - the offset
* to the table follows the memory size in the header -
* program modules can contain error message tables that
* they install themselves. Because the structure is that
* of a module, but can also be read from disk, error
* message tables can be left on disk to save memory, or
* loaded into memory for speed.
*
PrtBufSz equ 80 line buffer size
 org 0
PrtPath rmb 1 error output path number
PrtNum rmb 1 error number
PrtProc rmb 2 process descriptor ptr
PrtMod rmb 2 error messages module ptr
PrtTbl rmb 2 error messages table ptr
PrtEPath rmb 1 error messages path number
PrtPFlag rmb 1 Path in use flag
PrtFlag rmb 1 user/system path flag
PrtBuf rmb PrtBufSz reserve line buffer
PrtMem equ .

PrtErr ldb R$B,u get error number
 beq PrtErr90 ..none; exit
 ldx D.Proc get user process descriptor
 lda P$PATH+2,x get standard error path
 beq PrtErr90 ..none; exit
 pshs u save registers ptr
 leas -PrtMem,s get memory
 leau ,s point at it
 std PrtPath,u save path and error number
 stx PrtProc,u save process descriptor
 ldy D.SysPRC fix process descriptor
 sty D.Proc
 lbsr PrtErrNm print the error number
 clr PrtFlag,u clear 'tried system' flag
 ldx PrtProc,u try user path first

PrtErr10 leax P$ErrNam,x point at error name
 clr PrtPFlag,u clear path flag
 pshs u,x save regs
 clra module type=don't care
 os9 F$Link try to link to module
 tfr u,y put module ptr in Y
 puls u,x retrieve regs
 sty PrtMod,u save module ptr
 bcc PrtErr20 skip if module found

 lda #READ.+EXEC. try open file for read
 os9 I$Open
 sta PrtEPath,u save path number
 inc PrtPFlag,u show path rather than module
 bcc PrtErr20 skip if file opened

PrtErr15 tst PrtFlag,u tried system path?
 bne PrtErr85 ..yes; no more hope
 inc PrtFlag,u show system path
 ldx D.SysPRC get system process descriptor
 bra PrtErr10 try on system path

PrtErr85 lda #C$CR just print CR-LF
 pshs a stack it
 leax ,s point at it
 ldy #1 one byte
 lbsr PrtLine print it
 leas 1,s return scratch
 bra PrtErr95 and exit

PrtErr80 lbsr PrtUndo unlink/close
PrtErr95 ldy PrtProc,u restore process descriptor
 sty D.Proc
 leas PrtMem,s return memory
 puls u retrieve regs ptr
PrtErr90 clrb no error
 rts

PrtErr20 tst PrtPFlag,U module?
 bne PrtErr30 ..no
 ldx PrtMod,u get module address
 ldd M$Mem+2,x GET TABLE OFFSET ***
 leax d,x make table address
 stx PrtTbl,u save table address
 bra PrtErr40 print the message

PrtErr30 ldx #M$Mem+2 seek to offset
 bsr PrtSeek
 bcs PrtErr70 skip if error
 lda PrtEPath,u get path number
 ldy #2 two bytes to read
 leas -2,s get scratch
 leax ,s point at it
 os9 I$Read read the offset
 puls x retrieve offset
 bcs PrtErr70 ..error
 bsr PrtSeek seek to table
 bcs PrtErr70 ..error

PrtErr40 lbsr PrtRdRcd read a record
 bcs PrtErr70 ..error
 lbsr PrtGetNm get error number
 beq PrtErr70 ..end of table
 cmpb PrtNum,u the one we want?
 bne PrtErr40 ..no; try again
 pshs x save message ptr
 leax ErrMsg2,PCR " - " string
 ldy #MsgLen2
 bsr PrtLine print it
 puls x

PrtErr50 ldy #PrtBufSz-1 max line size
 bsr PrtLine print the line
 bsr PrtRdRcd read next record
 bcs PrtErr80 ..no more; done
 lda ,x+ get first byte
 beq PrtErr80 ..zero; end of table
 cmpa #'0 delimiter?
 bcs PrtErr50 ..yes; another line
 bra PrtErr80 ..else exit

PrtErr70 bsr PrtUndo unlink/close
 lbra PrtErr15 might try system path...

PrtErrNm leax ErrMsg1,pcr point at "Error #"
 ldy #MsgLen1 string length
 bsr PrtLine print the string
 ldb PrtNum,u get the error number
 leax PrtBuf,u point at buffer area
 tfr x,y twice
 lda #'0-1 initialise hundreds
PrtNm1 inca
 subb #100 make hundreds
 bcc PrtNm1
 sta ,y+ put in buffer
 lda #'9+1 initialise tens
PrtNm2 deca
 addb #10 make tens
 bcc PrtNm2
 sta ,y+ put in buffer
 addb #'0 make units
 stb ,y+ put in buffer
 ldy #3 number size
* Fall through to print it

PrtLine lda PrtPath,u get output path
 os9 I$WritLn write the string
 rts

PrtSeek lda PrtEPath,u get path
 pshs u,x save regs
 tfr x,u put low word in U
 ldx #0 high word is 0
 os9 I$Seek seek!
 puls pc,u,x retrieve regs and return

PrtUndo lda PrtEPath,u get path
 tst PrtPFlag,u
 bne PrtUndo1 ..there is one
 pshs U save U
 ldu PrtMod,U get module ptr
 os9 F$UnLink unlink it
 puls U,PC

PrtUndo1 os9 I$Close close the path
 rts

PrtRdRcd leax PrtBuf,u point at the buffer
 ldy #PrtBufSz max line length
 lda PrtEPath,u get path number
 tst PrtPFlag,u
 beq PrtRd10 ..none; must be a module
 os9 I$ReadLn read a line
 rts

PrtRd10 tfr y,d put buffer size in B
 ldy PrtTbl,u get table ptr

PrtRd20 lda ,y+
 sta ,x+ put in buffer
 decb end of buffer?
 beq PrtRd30 ..yes
 cmpa #C$CR end of line?
 bne PrtRd20 ..no; get more

PrtRd30 leax PrtBuf,u retrieve buffer ptr
 sty PrtTbl,u update table ptr
 clrb
 rts

PrtGetNm clrb initialise counter
PrtGet10 lda ,x+ get a chr
 beq PrtGet20 ..end of table
 suba #'0 name numeric
 bcs PrtGet30 ..exit if separator
 pshs a save digit
 lda #10
 mul multiply present result by 10
 addb ,s+ add new digit
 bra PrtGet10 next!
PrtGet20 tstb check answer
PrtGet30 rts

ErrMsg1 fcc 'Error #'
MsgLen1 equ *-ErrMsg1
ErrMsg2 fcc ' - '
MsgLen2 equ *-ErrMsg2

******************************
*
*       Subroutine InsErr
*
*  Install error message path/module
*  name string
*
* Input: U = Registers ptr
*         R$X,U=ptr to name string
*
* Output: U unchanged
*         Carry set if error, B has error code
*
* Data: D.Proc
*
* Calls: F$Move, F$Link, F$UnLink, I$Open, I$Close
*
* The name string MUST be 32 chrs or less
*
InsErr pshs u save registers ptr
 ldx R$X,u get name ptr
 clra any module type
 os9 F$Link try to link
 bcs InsErr1 ..not found
 pshs x save updated ptr
 os9 F$UnLink don't hang on to it
 bra InsErr2
InsErr1 ldu ,s retrieve reg ptr
 ldx R$X,u retrieve name ptr
 lda #READ.
 os9 I$Open try to open
 bcs InsErrx ..couldn't
 pshs x save updated name ptr
 os9 I$Close close it again
InsErr2 ldu D.Proc get process descriptor
 lda P$Task,u get source task number
 ldb D.SysTsk get destination (system)
 ldy #ErrNamSz error name area size
 leau P$ErrNam,u destination area ptr
 ldx 2,s retrieve regs ptr
 ldx R$X,X get source ptr
 os9 F$Move move name into process descriptor
 ldu 2,s retrieve regs ptr
 puls x retrieve updated name ptr
 stx R$X,u return to caller
 clrb no error
InsErrx puls U,PC

 else
* Normal error service

********************************
*
* F$PErr System call entry point
*
* Entry: U = Register stack pointer
*

ErrMsg1 fcc "ERROR #"
ErrNum  equ  *-ErrMsg1
 fcb '0-1,'9+1,'0
 fcb   C$CR
ErrMessL equ   *-ErrMsg1

PrtErr    ldx   D.Proc
         lda   <P$PATH+2,x  get stderr path
         beq   L08CC
         leas  -ErrMessL,s  make room on stack
         leax  <ErrMsg1,pcr
         leay  ,s
L0893    lda   ,x+
         sta   ,y+
         cmpa  #C$CR       done?
         bne   L0893
         ldb   R$B,u
* Convert error code to decimal
PrtNm1    inc   ErrNum+0,s
 subb #100 make hundreds
         bcc   PrtNm1
PrtNm2    dec   ErrNum+1,s
         addb  #10
         bcc   PrtNm2
         addb  #'0
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

 endc
 page
*****
*
*  Subroutine Ioqueu
*
* Link Process Into Ioqueue And Go To Sleep
*
IOQueu ldy D.Proc get process ptr
IOQ.A lda P$IOQN,y get next process ID
 beq IOQ.C branch if none
 cmpa R$A,u is this queue process?
 bne IOQ.B branch if not
 clr P$IOQN,y clear link

 ifeq LEVEL-1
 ldx D.PrcDBT
 os9 F$Find64
 else
 os9 F$GProcP get process ptr
 endc

 bcs IOQuExit branch if dead
 clr P$IOQP,y clear link
 ldb #S$Wake get signal
 os9 F$Send wake process
 bra IOQ.E

IOQ.B
 ifeq LEVEL-1
  jmp NOWHERE
 else
 os9 F$GProcP get process ptr
 endc
 bcc IOQ.A branch if found
IOQ.C lda R$A,u get queue process ID
IOQ.D
 ifeq LEVEL-1
    jmp NOWHERE
 else
 os9 F$GProcP get process ptr
 endc
 bcs IOQuExit branch if error
IOQ.E lda P$IOQN,y get net process ID
 bne IOQ.D branch if there is one
 ldx D.Proc get current process ptr
 lda P$ID,x get current process ID
 sta P$IOQN,y link into queue
 lda P$ID,y get previous process ID
 sta P$IOQP,x set predecessor link
 ldx #0 sleep until signal
 os9 F$Sleep
 ldu D.Proc get process ptr
 lda P$IOQP,u normal queue exit?
 beq IOQ.F branch if so

 ifeq LEVEL-1
 ldx D.PrcDBT
 os9 F$Find64
 else
 os9 F$GProcP get process ptr
 endc

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
 ldx D.PrcDBT
 os9 F$Find64
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
