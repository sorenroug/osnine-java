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
 fcb F$Load+SysState
         fdb   SysLoad-*-2
         fcb   F$PErr    
         fdb   PRTERR-*-2 
         fcb   F$IOQu+$80
         fdb   IOQueu-*-2 
         fcb $FF
         fdb   SysIO-*-2 
         fcb   F$IRQ+$80 
         fdb   IOPOLL-*-2  
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
 cmpb #$FF  #ROMBlock System's ROM Block?
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

         ldy   #$F000  New in ed. 11
 ldd S.Port,s Get extended port addr
 lbsr PortBlk convert to block addr
         beq   IOMap40  New in ed. 11
 std S.Block,s save working block addr
 ldu #0 clear DAT entry ptr
 tfr u,y clear local address ptr
 stu S.LclAdr,s System Local addr=0
 ldx D.SysDAT get system DAT image ptr
IOMap20    ldd   ,x++
         cmpd  <$12,s
         beq   IOMap40
 cmpd #DAT.Free Unused Entry?
         bne   IOMap30
         sty   <$10,s
         leau  -$02,x
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
IOMap40    sty   <$10,s
         ldd   $0C,s
         anda  #$0F
         addd  <$10,s
         ldu   $02,s
         clr   ,u
         std   $01,u
         ldy   $04,s
         ldx   ,s
         ldd   $09,x
         jsr   d,x
         lbcs  ATTERR
         ldu   $0E,s
ATTA60    ldb   #$08
ATTA65    lda   b,s
         sta   b,u
         decb
         bpl   ATTA65
ATTA70    ldx   $04,u
         ldb   $07,x
         lda   $09,s
         anda  $0D,x
         ldx   ,u
         anda  $0D,x
         cmpa  $09,s
         lbne  ERMODE
         inc   $08,u
         bne   ATTA91
         dec   $08,u
ATTA91    ldx   <$16,s
         stu   $08,x
         leas  <$18,s
         clrb
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
         ldx   D.Init
         ldb   DevCnt,x      get device count
         pshs  u,b
         ldx   $02,u
         clr   $02,u
         clr   $03,u
         ldy   D.DevTbl
DETACH10    cmpx  $02,y
         beq   DETACH20
         leay  DEVSIZ,y
         decb
         bne   DETACH10
         ldy   D.Proc
         ldb   ,y
         stb   $08,u
         ldy   $04,u
         ldu   ,u
         exg   x,u
         ldd   $09,x
         leax  d,x
         pshs  u
         jsr   $0F,x
         puls  u
         ldx   $01,s
         ldx   ,x
         ldd   $0B,x
         addd  #$00FF
         clrb
         os9   F$SRtMem
         ldx   $01,s
         ldx   $04,x
         ldd   $0E,x
         beq   DETACH20
         lbsr  PortBlk
         beq   DETACH20
         tfr   d,x
         ldb   ,s
         pshs  x,b
         ldu   D.DevTbl
UnMap10    cmpu  $04,s
         beq   UnMap20
         ldx   $04,u
         beq   UnMap20
         ldd   $0E,x
         beq   UnMap20
         lbsr  PortBlk
         cmpd  $01,s
         beq   UnMap90
UnMap20    leau  $09,u
         dec   ,s
         bne   UnMap10
         ldx   D.SysPRC
         ldu   D.SysDAT
         ldy   #$0010
UnMap25    ldd   ,u++
         cmpd  $01,s
         beq   UnMap30
         leay  -$01,y
         bne   UnMap25
         bra   UnMap90
UnMap30 ldd #DAT.Free
 std -2,u mark DAT block as free
 lda P$State,x
 ora #ImgChg Inform system of image change
 sta P$State,x
UnMap90 leas 3,S discard scratch

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
UDUPE    bsr   FNDPTH
         bcs   SDUP90
         pshs  x,a
         lda   $01,u
         lda   a,x
         bsr   SDUP10
         bcs   SDUPER
         puls  x,b
         stb   $01,u
         sta   b,x
         rts
SDUPER    puls  pc,x,a

SDUPE    lda   $01,u
SDUP10    lbsr  FPATH
         bcs   SDUP90
         inc   $02,y
SDUP90    rts


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
         leax  <$30,x
         clra
L0378    tst   a,x
         beq   L0385
         inca
         cmpa  #$10
         bcs   L0378
         comb
         ldb   #$C8
         rts
L0385    andcc #$FE
         rts


**********
* Open
*   Process Open/Create Request
*
* Passed: (R$A)=Mode: R/W/Exec
*         (R$X)=Pathname Ptr (Preceeding Spaces Ok)
*
UCREAT equ *
UOPEN bsr   FNDPTH
         bcs   UOPEN9
         pshs  u,x,a
         bsr   SOPEN
         puls  u,x,a
         bcs   UOPEN9
         ldb   $01,u
         stb   a,x
         sta   $01,u
UOPEN9    rts

SCREAT equ *
SOPEN    pshs  b
         ldb   $01,u
         bsr   PDINIT
         bcs   SOPENX
         puls  b
         lbsr  FMEXEC
         bcs   SMDIR2
         lda   ,y
         sta   $01,u
         rts

SOPENX    puls  pc,a


**********
* Makdir
*   Process Makdir Request
*
UMDIR equ *
SMDIR  pshs  b
         ldb   #$82
SMDIR1    bsr   PDINIT
         bcs   SOPENX
         puls  b
         lbsr  FMEXEC
SMDIR2    pshs  b,cc
         ldu   $03,y
         os9   I$Detach
         lda   ,y
         ldx   D.PthDBT
         os9   F$Ret64
         puls  pc,b,cc

**********
* Cdir
*   Process Change Directory Request
*
UCDIR equ *
SCDIR  pshs  b
         ldb   $01,u
         orb   #$80
         bsr   PDINIT
         bcs   SOPENX
         puls  b
         lbsr  FMEXEC
         bcs   SMDIR2
         ldu   D.Proc
         ldb   $01,y
         bitb  #$1B
         beq   SCDIR2
         ldx   $03,y
         stx   <$20,u
         inc   $08,x
         bne   SCDIR2
         dec   $08,x

SCDIR2 bitb  #$24
         beq   SCDIR5
         ldx   $03,y
         stx   <$26,u
         inc   $08,x
         bne   SCDIR5
         dec   $08,x

SCDIR5    clrb
         bra   SMDIR2


**********
* Delet
*   Process Delete Request
*
UDELET equ *
SDELET  pshs  b
         ldb   #$02
         bra   SMDIR1

**********
* DeletX
*  delete from specified directory
*
UDELETX equ *
SDELETX ldb #I$Delete
         pshs  b
         ldb   $01,u
         bra   SMDIR1


**********
* Pdinit
*
PDINIT
    ldx   D.Proc
         pshs  u,x
         ldx   D.PthDBT
         os9   F$All64
         bcs   PDIN90
         inc   $02,y
         stb   $01,y
         ldx   D.Proc
         ldb   $06,x
         ldx   $04,u
PDIN10    os9   F$LDABX
         leax  $01,x
         cmpa  #$20
         beq   PDIN10
         leax  -$01,x
         stx   $04,u
         ldb   $01,y
         cmpa  #$2F
         beq   L0454
         ldx   D.Proc
         bitb  #$24
         beq   L0445
         ldx   <$26,x
         bra   L0448
L0445    ldx   <$20,x
L0448    beq   L0483
         ldd   D.SysPRC
         std   D.Proc
         ldx   $04,x
         ldd   $04,x
         leax  d,x
L0454    pshs  y
         os9   F$PrsNam
         puls  y
         bcs   L0483
         lda   $01,y
         os9   I$Attach
         stu   $03,y
         bcs   L0485
         ldx   $04,u
         leax  <$11,x
         ldb   ,x+
         leau  <$20,y
         cmpb  #$20
         bls   L047A
         ldb   #$1F
L0476    lda   ,x+
         sta   ,u+
L047A    decb
         bpl   L0476
         clrb
PDIN90    puls  u,x
         stx   D.Proc
         rts
L0483    ldb   #E$BPNam
L0485    pshs  b
         lda   ,y
         ldx   D.PthDBT
         os9   F$Ret64
         puls  b
         coma
         bra   PDIN90

 ttl I/O Path function calls
 page
**********
* Chkpth
*   Validate User Path, And Map Into System Path
*
* Passed: (U)=User Regs, (R$A)=User Path#
* Returns: (A)=System Path#
*          (X)=User Path Table Ptr
*
CHKPTH    lda   $01,u
         cmpa  #$10
         bcc   CHKERR
         ldx   D.Proc
         leax  <$30,x
         andcc #$FE
         lda   a,x
         bne   CHKP90
CHKERR    comb
         ldb   #E$BPNum
CHKP90    rts


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
         beq   L04F9
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
L04F9    puls  b
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
         bne   L0598
         bsr   FMEXEC
L0598    tst   $02,y
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
FMEXEC pshs  u,y,x,b
         bsr   GainPath
         bcc   L05BE
         leas  $01,s
         bra   FMEX30

L05BE    stu   $06,y
         ldx   $03,y
         ldx   $06,x
         ldd   $09,x
         leax  d,x
         ldb   ,s+
         subb  #$83
         lda   #$03
         mul
         jsr   d,x
FMEX30    pshs  b,cc
         bsr   UnQueue
         ldy   $04,s
         ldx   D.Proc
         lda   ,x
         cmpa  $05,y
         bne   FMEX90
         clr   $05,y
FMEX90    puls  pc,u,y,x,b,cc

***************
* Subroutine UnQueue
*   Wake next process in I/O queue (if any)

UnQueue    pshs  y,x
         ldy   D.Proc
         bra   L05F8
L05EB    clr   P$IOQN,y
         ldb   #S$Wake     get wake signal
         os9   F$Send
         os9   F$GProcP
         clr   P$IOQP,y
L05F8    lda   P$IOQN,y
         bne   L05EB
         puls  pc,y,x
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
IOPOLL     ldx   R$X,u     get ptr to IRQ packet
         ldb   ,x
         ldx   $01,x
         clra
         pshs  cc
         pshs  x,b
         ldx   D.Init
         ldb   PollCnt,x   get number of entries in table
         ldx   D.PolTbl
         ldy   $04,u
         beq   L0650
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
         bcs   L0638
         ldb   #POLSIZ
L062D    lda   ,-x
         sta   POLSIZ,x
         decb
         bne   L062D
         cmpx  D.PolTbl
         bhi   IOPOL1
L0638    ldd   $01,u
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
L0650    leas  $04,s
         ldy   $08,u
L0655    cmpy  $06,x
         beq   IOPOL6
         leax  POLSIZ,x
         decb
         bne   L0655
         clrb
         rts

IOPOL6    pshs  b,cc
         orcc  #$50
         bra   L066E
L0667    ldb   POLSIZ,x
         stb   ,x+
         deca
         bne   L0667
L066E    lda   #POLSIZ
         dec   $01,s
         bne   L0667
L0674    clr   ,x+
         deca
         bne   L0674
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
         ldb   PollCnt,x   get number of entries in table
         bra   L068F
L068A    leay  POLSIZ,y    else move to next entry
         decb
         beq   POLLERR
L068F    lda   [Q$POLL,y]  get device's status register
         eora  Q$FLIP,y    flip it
         bita  Q$MASK,y    origin of IRQ?
         beq   L068A
         ldu   $06,y
         pshs  y,b
         jsr   [Q$SERV,y]  execute service routine
         puls  y,b
         bcs   L068A
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
L06AD    pshs  y
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
         ldx   $04,u
         bsr   LModule
         bcs   SysLXit
         puls  y
         ldd   D.Proc
         pshs  y,b,a
         ldd   $08,y
         std   D.Proc
         bsr   L06AD
         puls  x
         stx   D.Proc
SysLXit    puls  pc,u

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
         bcc   L06F0
         rts
L06F0    leay  ,u
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
         bne   L0786
         ldd   M$Size,u
         subd  #M$IDSize
         lbsr  GetModul
         bcs   LModErr
         ldy   <$15,s     get proc desc ptr
         leay  <P$DATImg,y
         tfr   y,d
         ldx   $02,s
         os9   F$VModul
         bcc   L0764
         cmpb  #E$KwnMod
         beq   L076A
         bra   LModErr
L0764    ldd   $02,s
         addd  $0A,s
         std   $02,s
L076A    ldd   <$17,s
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
L0786    ldb   #E$BMID
LModErr    stb   $07,s
         ldd   $04,s
         beq   L0790
         std   D.Proc
L0790    lda   $06,s
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
L07BC    ldd   ,x++
         clr   d,u
         leay  -$01,y
         bne   L07BC
LMod.Q    ldx   <$15,s
         lda   P$ID,x
         os9   F$DelPrc
         ldd   <$17,s
         bne   L07D9
         ldb   $07,s
         stb   <$12,s
         comb
         bra   LModXit
L07D9    ldu   D.ModDir
         ldx   <$11,s
         ldd   <$17,s
         leau  -MD$ESize,u
L07E3    leau  MD$ESize,u
         cmpu  D.ModEnd
         bcs   L07F2
         comb
         ldb   #E$MNF
         stb   <$12,s
         bra   LModXit
L07F2    cmpx  MD$MPtr,u
         bne   L07E3
         cmpd  [MD$MPDAT,u]
         bne   L07E3
         ldd   MD$Link,u
         beq   L0804
         subd  #$0001
         std   MD$Link,u
L0804    stu   <$17,s
         clrb
LModXit    leas  <$11,s
         puls  pc,u,y,x,b,a


*****************************************************
*
*            GetModul routine
*
*  Input: D = Size of new section
*         X = Present module size in RAM
*
* Output: X = New module size in RAM
*
GetModul    pshs  y,x,b,a
         addd  $02,s
         std   $04,s
         cmpd  $08,s
         bls   GetM.R
         addd #DAT.BlSz-1 Round up
         lsra
         lsra
         lsra
         lsra
         cmpa  #$0F
         bhi   GetM.Err
         ldb   $08,s
         lsrb
         lsrb
         lsrb
         lsrb
         pshs  b
         exg   b,a
         subb  ,s+
         lsla
         ldu   <$1D,s
         leau  <P$DATImg,u
         leau  a,u
         clra
         tfr   d,x
         ldy   D.BlkMap
         clra
         clrb
L0840    tst   ,y+
         beq   GetM.D
L0844    addd  #1
         cmpy  D.BlkMap+2
         bne   L0840
GetM.Err    comb
         ldb   #$CF
         bra   GetM.X

GetM.D    inc   -1,y
         std   ,u++
         pshs  b,a
         ldd   $0A,s
         addd  #DAT.BlSz
         std   $0A,s
         puls  b,a
         leax  -$01,x
         bne   L0844
         ldx   <$1D,s
         os9   F$SetTsk
         bcs   GetM.X
GetM.R    lda   $0E,s
         ldx   $02,s
         ldy   ,s
         os9   I$Read
GetM.X    leas  $04,s
         puls  pc,x

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
