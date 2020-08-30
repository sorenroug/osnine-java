 nam Random Block File Manager - Level II
*
* Note: Microware has not put a copyright statement on this file
*
 ttl Module Header & entries
 use defsfile

included equ 1
 ifeq LEVEL-1
RCD.LOCK equ 0
 else
RCD.LOCK equ included
 endc

*C$CR equ $0D carriage return char

***************
* Edition History

*  #   Date      Comments                                      By
* ----------- ----------------------------------------------- ---
* 04 82/11/16 First Record-Locking Edition Released.         (RFD)
* 05 82/12/01 Prevented input files from gaining EOFLock     (RFD)
* 05 82/12/01 Removed E$TimOut error; redundant with E$Lock  (RFD)
* 05 82/12/02 Restored original file size if expand failed
*              in Write or SetSize to fix E$NES errors.      (RFD)
* 05 82/12/02 Added limit check in SECALL to prevent looking
*              for more then 2048 bits in bitmap.            (RFD)
* 06 82/12/09 Added conditionals for L1, V1.2 --NO rcd lock. (RFD)
* 07 82/12/23 Fixed problem that caused the root directory to
*              be considered part of the bitmap sometimes.   (RFD)
* 08 83/01/20 Some files might have been trimmed unwantedly  (RFD)
* 08 83/01/20 Modified LockSeg to release ALL if conflict.   (RFD)
* 08 83/02/04 Made PE.Wait queue into ring to fix Gain when
*              a process was aborted; fixed interaction bug. (RFD)
* 09 83/02/09 Modified LockSeg to release RCD if no conflict (RFD)

* ===================================================================
*  EDITION 9 CONTAINS A VERY NASTY BAD BUG...ELIMINATE ON CONTACT
* ===================================================================

* 10 83/03/04 If E$SLF (217) occurs, segment is now returned.(RFD)
* 11 83/03/07 Added setstat SS.FD to update FD dates  Moved
*              date modified from Close to Open routine.     (KKK)
* 11 83/03/08 Removed non-sharable Create in Makdir.         (RFD)
* 12 83/04/19 Added overlooked error exit in RBRW.       (RFD/WGP)
*    83/04/29 Fixed RBRW compare to WrByte error caused
*             by adding bytes for error exit.                (WGP)
* 12 83/06/15 Fixed numerous small problems in file lockout. (RFD)
* 13 83/06/20 Added Unqueue before sleep in Gain.            (RFD)
* 14 83/06/29 Change record locking to byte locking      (RFD/MGH)
*             This involved major changes .. also incorporated
*             internal buffer swapping when multiple processes
*             are using the same sector.
* 15 83/07/08 Corrected problem of read(0) when on a
*              sector boundry..added got next sector and position
*              was $100 greater then the seek.           (RFD/MGH)
* 16 83/07/26 Corrected problem in GCPSEC that allowed a process
*              to get a bad sector if first process is in driver.
*                                                        (RFD/MGH)

Edition equ 16

***************
* Random Block File Manager Module

* Module Header
Type set FLMGR+OBJCT
Revs set REENT+1
 mod RBFEnd,RBFNam,Type,Revs,RBFEnt,0
RBFNam fcs "RBF"
 fcb Edition Edition number

* File Manager Constants
DTBSiz fcb DRVMEM Drive tbl size

* Entry Branch Table
RBFEnt lbra Create
 lbra Open
 lbra MakDir
 lbra ChgDir
 lbra Delete
 lbra Seek
 lbra Read
 lbra Write
 lbra ReadLn
 lbra WritLine
 lbra GetStat
 lbra PutStat
 lbra Close

 ifeq RCD.LOCK-included
 page
***************
* List Structure

*      At run time, the RBF manager maintains two linked lists
* which contain all open paths on a particular disk drive. The
* "next file" list has its head on the driver's static storage, and
* contains one entry for each open File on that device. Entries are
* kept in order of increasing file descriptor sector. Each entry in
* the "file list" is the head of a circular "conflict list" of all
* open paths to that file.
*
*
*               File #1         File #2         File #3
* ---------   -----------     -----------     -----------
* |Static |   |Path Desc|     |Path Desc|     |Path Desc|  Next File
* |Storage|   |         |     |         |     |         |    List  -->
* |  for  |   =====X=====     =====X=====     =====X=====
* | drive |-->|         |---->|         |-----|         |---->0000
* ---------   |Extension|     |Extension|     |Extension|
*             --.--------     --.--------     --.--------
*               |               |               |
*     Next      |               V               V
*   Conflict    V             (self)          (self)
*     List    -----------
*      |      |Path Desc|
*      |      |         |
*      V      =====X=====
*             |         |--->(self)
*             |Extension|
*             --.--------
*               |
*               V
*            (File #1)
*
*             RBF Record Locking Linked List Structure
*
*      To check for a record lock conflict, only the path in the
* current conflict list are scanned. This list is usually very
* small, and the time required for conflict searching is minimal
 endc

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
 pshs u,x,b,a save them
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
 puls u,x,b,a retrieve seg info
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
 beq   Create15
 lbsr  RdNxtDir
 bcc   Create12
* If dir is at EOF, then expand it
Create13 cmpb #E$EOF end of file?
 bne   CRTEX1 ..No; abort
 ldd   #DIR.SZ add size of new rcd
 lbsr  WriteSub expand Dir
 bcs   CRTEX1 error; abort
 lbsr  WrtFDSiz Update file size in FD
* lbsr CLRBUF clear buffer
 lbsr  RdCurDir re-read dir rcd

Create15 leau 0,x (U)=Dir Rcd Ptr
 lbsr ZerDir Zero out Dir entry
 puls  x restore pathlist ptr
 os9   F$PrsNam parse pathname again
 bcs   CRTEX1 ..error; abort
 cmpb  #29 impossibly long?
 bls   Create16 ..No; continue
 ldb   #29 default maximum
Create16 clra
 tfr   D,Y (Y)=name bytecount
 lbsr  FromUser Move name from user to dir
 tfr   Y,D
 ldy   S.Path,S restore PD
 decb backup to last char
 lda   B,U get it
 ora   #$80 set name end
 sta   B,U
 ldb   S.SctAdr,S FD psn
 ldx   S.SctAdr+1,S
 stb Dir.FD,U put in dir
 stx Dir.FD+1,U
 lbsr  PCPSEC Write dir sector
* (Don't release locked-out Dir rcd)
 bcs CRTERR error; abort

* Initialize File Descriptor
 ldu   PD.BUF,Y get buffer ptr
 bsr   ZerBuf fill buffer with zeros
 lda   #FDBUF
 sta   PD.SMF,Y indicate FD in buffer
 ldx   PD.RGS,Y get register package ptr
 lda   R$B,X get attributes
 sta   FD.ATT,U
 ldx   D.PROC get process ptr
 ldd   P$USER,X get process user
 std   FD.OWN,U Set owner
 lbsr  DateMod set "last modified" date
 ldd   FD.DAT,U
 std   FD.Creat,U init create YY MM
 ldb   FD.DAT+2,U DD
 stb   FD.Creat+2,U
 ldb   #1 Set link count
 stb   FD.LNK,U
 ldd   S.SctSiz,S Retrieve sectors allocated
 subd  #1 More than one?
 beq   Create40 ..No
 leax  FD.SEG,U
 std   FDSL.B,X Set first seg size
 ldd   S.SctAdr+1,S FD addr
 addd  #1 Move to next sector
 std  FDSL.A+1,X Set seg beginning
 ldb   S.SctAdr,S
 adcb  #0
 stb   FDSL.A,X
Create40 ldb S.SctAdr,S addr of new FD sector
 ldx S.SctAdr+1,S
 lbsr  PUTSEC Write FD
 bcs   CRTERR error; abort
 lbsr  Remove Remove path from dir rcd-lock lists
 stb   PD.FD,Y move to new file's FD
 stx   PD.FD+1,Y
 lbsr  Insert Insert path into file's rcd-lock lists
 leas  StkTemps,S return scratch

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

Delete    pshs  y
         lbsr  SchDir
         bcs   KillPth
         ldd   <$35,Y
         bne   Delete10
         tst   PD.FD,Y
         lbeq  IllAcces
Delete10    lda   #$42
         lbsr  CHKACC
         bcs   Delete99
         ldu   PD.RGS,Y
         stx   $04,U
         lbsr  GETFD
         bcs   Delete99
         ldx   $08,Y
         dec   $08,X
         beq   Delete15
         lbsr  PUTFD
         bra   Delete20

Delete15    clra
         clrb
         std   PD.SIZ,Y
         std   PD.SIZ+2,Y
         lbsr  TRIM
         bcs   Delete99
         ldb   PD.FD,Y
         ldx   <$35,Y
         stb   PD.SBP,Y
         stx   PD.SBP+1,Y
         ldx   $08,Y
         ldd   <$13,X
         addd  #$0001
         std   PD.SSZ+1,Y
         lbsr  SECDEA

Delete20    bcs   Delete99
         lbsr  CLRBUF
         lbsr  Remove
         lda   <$37,Y
         sta   PD.FD,Y
         ldd   <$38,Y
         std   <$35,Y
         lbsr  Insert
         lbsr  GETFD
         bcs   Delete99
         lbsr  InitPD10
         ldd   PD.DCP,Y
         std   $0B,Y
         ldd   <$3C,Y
         std   $0D,Y
         lbsr  RdCurDir
         bcs   Delete99
         clr   0,X
         lbsr  PCPSEC
Delete99    lbra  KillPth

***************
* Subroutine Seek
*   Change Path's current posn ptr
* Flush buffer is (not empty and ptr moves to new sector)

Seek    ldb PD.SMF,Y
         bitb  #SINBUF
         beq   Seek15

* Seek Position In Current Sector?
         lda   R$X+1,U
         ldb   R$U,U
         subd  PD.CP+1,Y
         bne   Seek10
         lda   $04,U
         sbca  $0B,Y
         beq   Seek20

* Clear buffer & set posn
Seek10    lbsr  CLRBUF
         bcs   Seek99
Seek15    ldd   $04,U
         std   $0B,Y
Seek20    ldd   $08,U
         std   $0D,Y
Seek99    rts
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
         beq   RDLine0
         bsr   ReadLn10

* Read Line Subroutine
*   Move Bytes from Buffer to Destination up to carriage return

* Returns: 2,S (caller' top of stack)=Byte count

         pshs  u,y,x,D
         exg   x,U
         ldy   #0
         lda   #$0D
RDLine10    leay  $01,Y
         cmpa  ,x+
         beq   RDLine20
         decb
         bne   RDLine10
RDLine20    ldx   $06,S
         bsr   ToUser
         sty   $0A,S
         puls  u,y,x,D
         ldd   $02,S
         leax  d,X
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

         cmpa #C$CR
         beq ReadLn20
         ldd $02,S
         lbne RBRW10
ReadLn20 ldu PD.RGS,Y get register ptr
         ldd R$Y,U
         subd S.BytCnt,S
         std R$Y,U
         bra Read90

 page
***************
* Subroutine ReadInit

ReadInit    ldd   $06,U
 ifeq RCD.LOCK-included
         lbsr  Gain00
         bcs   ReadIERR
         ldd   R$Y,U
 endc
         bsr   RDSET
         bcs   ReadIERR
         std   $06,U
         rts

***************
* Subroutine Rdset

RDSET    pshs  D
         ldd   PD.SIZ+2,Y
         subd  $0D,Y
         tfr   d,X
         ldd   PD.SIZ,Y
         sbcb  $0C,Y
         sbca  $0B,Y
         bcs   RDSET80
         bne   RDSET10
         tstb
         bne   RDSET10
         cmpx  ,S
         bcc   RDSET10
         stx   ,S
         beq   RDSET80
RDSET10    clrb
         puls  PC,D

RDSET80    comb
         ldb   #E$EOF
ReadIERR leas 2,S
 ifeq RCD.LOCK-included
 bra Read95
 else
 endc

 ifeq LEVEL-1
ToUser lbra FromUser
 else
***************
* Subroutine ToUser
*   Copy bytes to user's addr space

ToUser pshs x
 ldx D.Proc
 lda D.SysTsk
 ldb P$Task,X
 puls x
 os9 F$Move
 rts
 endc

***************
* Subroutine Read
*   Read Requested Bytes from Current Position

Read bsr ReadInit Chk conflicts; EOF; maximum
         beq Read0 Read 0 bytes? .. exit; carry cleared by ReadInit
         bsr   Read1 init Read subroutine addr (S.RWaddr)

* Subroutine RdByte

RdByte    pshs  u,y,x,D
         exg   x,U
         tfr   d,Y
         bsr   ToUser
         puls  u,y,x,D
         leax  d,X
Read0    rts

Read1    bsr   RBRW00
         bne   RBRW10
Read90    clrb
RBRWER    leas  -$02,S
RBRWER1    leas  $0A,S
Read95    pshs  b,CC
         lda   $01,Y
         bita  #$02
         bne   Read99
         lbsr  UnLock
Read99    puls  b,CC
         rts
 page
***************
* Subroutine RBRW

RBRW00    ldd R$X,U
         ldx R$Y,U
         pshs  x,D
RBRW10    lda PD.SMF,Y
         bita  #SINBUF
         bne   RBRW25
         tst   $0E,Y
         bne   RBRW20
         tst   $02,S
         beq   RBRW20
         leax  >WrByte,pcr
         cmpx  $06,S
         bne   RBRW20
         lbsr  CHKSEG
         bra   RBRW22
RBRW20    lbsr  RDCP
RBRW22    bcs   RBRWER
RBRW25    ldu   $08,Y
         clra
         ldb   $0E,Y
         leau  d,U
         negb
         sbca  #$FF
         ldx   ,S
         cmpd  $02,S
         bls   RBRW30
         ldd   $02,S
RBRW30    pshs  D
         jsr   [<$08,s]
         stx   $02,S
         ldb   $01,S
         addb  $0E,Y
         stb   $0E,Y
         bne   RBRW35
         lbsr  CLRBUF
         inc   $0D,Y
         bne   RBRW34
         inc   $0C,Y
         bne   RBRW34
         inc   $0B,Y
RBRW34    bcs   RBRWER1
RBRW35    ldd   $04,S
         subd  ,s++
         std   $02,S
         jmp   [S.RWexit,s] Go to end of loop

 page
***************
* Subroutine Writline
*   Write Bytes to carriage return or Maximum

WritLine pshs y
 clrb
 ldy R$Y,U
 beq   WritLn20
 ifeq LEVEL-1
 ldx R$X,u Get address of buffer to write to
WritLn10 leay -1,Y
 beq WritLn20
 lda ,x+
 else
 ldx D.Proc
 ldb P$Task,X
 ldx R$X,U
WritLn10 leay -1,Y
 beq WritLn20
 os9 F$LDABX
 leax 1,X
 endc

 cmpa #C$CR
 bne WritLn10
 tfr y,d
 nega
 negb
 sbca #0
 addd R$Y,U
 std R$Y,U
WritLn20 puls y
* Fall through to Write

***************
* Subroutine Write
* Write Requested Bytes At Current Position

Write
 ifeq RCD.LOCK-included
 ldd   R$Y,U
 lbsr  Gain00
 bcs   Write99
 endc

* Insure Sufficient File Allocated
         ldd R$Y,U
         beq   Write90
         bsr   WriteSub
         bcs   Write99
         bsr   Write1

* Subroutine WrByte
*   Move Bytes from Source to Buffer

* Passed: (D)=bytecount
*         (X)=source ptr (in caller's addr space)
*         (U)=destination ptr (in system addr space)
* Returns: (X)=updated source ptr

WrByte pshs y,D save regs
         tfr   d,Y
         bsr   FromUser
         puls  y,D
         leax  d,X
         lda   PD.SMF,Y
         ora   #BUFMOD+SINBUF
         sta   PD.SMF,Y
         rts

Write1 lbsr RBRW00 init S.RWexit; enter RBRW

* Write Loop Exit
* Note: entered with ALL StkTemps initialized
 lbne  RBRW10 bra if more
 leas StkTemps,S return Scratch

 ifeq RCD.LOCK-included
         ldy   PD.Exten,Y
         lda   #RcdLock
         lbsr  Release
         ldy PE.PDptr,Y
 endc
Write90 clrb return without error
Write99 rts

***************
* Subroutine WriteSub
*   Update current position, expand file if needed

WriteSub addd PD.CP+2,Y Add current posn
         tfr d,X
         ldd PD.CP,Y
         adcb  #0
         adca  #0

* (D,X)=new potential file size
WriteS10    cmpd  PD.SIZ,Y
         bcs   Write90
         bhi   WriteS80
         cmpx  PD.SIZ+2,Y
         bls   Write90
WriteS80    pshs  u
         ldu   PD.SIZ+2,Y
         stx   PD.SIZ+2,Y
         ldx   PD.SIZ,Y
         std   PD.SIZ,Y
         pshs  u,X
         lbsr  EXPAND
         puls  u,X
         bcc   WriteS90
         stx   PD.SIZ,Y
         stu   PD.SIZ+2,Y
WriteS90    puls  PC,U

 ifeq LEVEL-1
FromUser pshs u,y,x
         ldd   $02,s
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
L0500    cmpx  ,s
         bcs   L04F9
         leas  $02,s
L0506    puls  PC,u,y,x
 else
***************
* Subroutine FromUser
*   Move bytes from user's addr space into system space

FromUser pshs x
 ldx D.Proc
 lda P$TASK,X
 ldb D.SysTsk
 puls x
 os9 F$Move
 rts
 endc
 page

***************
* Subroutine Getstat
*   Get Specific Status Information

GetStat ldb R$B,U
         cmpb  #SS.OPT
         beq   GetS.B9
         cmpb  #SS.EOF
         bne   GetS.A
         clr   R$B,U
EOFTest clra
         ldb   #1
         lbra  RDSET

GetS.A    cmpb  #SS.Ready
         bne   GetS.B
         clr   R$B,U
         rts
GetS.B    cmpb  #SS.Size
         bne   GetS.C
         ldd   PD.SIZ,Y
         std   R$X,U
         ldd   PD.SIZ+2,Y
         std   $08,U
GetS.B9 rts

GetS.C    cmpb  #SS.POS
         bne   GetS.D
         ldd   $0B,Y
         std   R$X,U
         ldd   $0D,Y
         std   $08,U
         rts

GetS.D    cmpb  #SS.FD
         bne   GetS.X
         lbsr  GETFD
         bcs   GetS.B9
         ldu   PD.RGS,Y
         ldd   $06,U
         tsta
         beq   GetS.D1
         ldd   #256
Gets.D1    ldx   R$X,U
         ldu   $08,Y
         lbra  RdByte

GetS.X lda #D$GSTA
 lbra  DEVDIS
 page
***************
* Subroutine Putstat
*   Set Specific Status Information

PutStat  ldb  R$B,U
         cmpb  #SS.OPT
         bne   PSt100
         ldx  R$X,U
         leax  $02,X
         leau  <$22,Y
         ldy   #PD.SAS-PD.DRV
         lbra  FromUser

PSt100    cmpb  #SS.Size
         bne   PSt110
         ldd   <$35,Y
         bne   PSt100.A
         tst   PD.FD,Y
         lbeq  PStErr
PSt100.A    lda   $01,Y
         bita  #$02
         beq   PSt100.D
         ldd   $04,U
         ldx   $08,U
         cmpd  PD.SIZ,Y
         bcs   PSt100.C
         bne   PSt100.B
         cmpx  PD.SIZ+2,Y
         bcs   PSt100.C
PSt100.B    lbra  WriteS10

PSt100.C    std   PD.SIZ,Y
         stx   PD.SIZ+2,Y
         ldd   $0B,Y
         ldx   $0D,Y
         pshs  x,D
         lbsr  TRIM
         puls  u,X
         stx   $0B,Y
         stu   $0D,Y
         rts

PSt100.D    comb
         ldb   #E$BMode
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

 org 0
S.Delim rmb 1
S.NameSz rmb 1
S.RcdPtr rmb 2
S.PathPt rmb 2
S.PD rmb 2
S.NextPt rmb 2
StkTemps set .

*   Allocate Buffers, get Pathname, Search Dir, Update pathptr
SchDir ldd  #$100 get one page
         stb   PD.SMF,Y
         os9   F$SRqMem
         bcs   Return99
         stu   PD.BUF,Y

 ifeq RCD.LOCK-included
         leau  0,Y
         ldx   D.PthDBT
         os9   F$All64
         exg   y,U
         bcs   Return99
         stu   PD.Exten,Y
         sty   $01,U
         stu   <$10,U
 endc

         ldx   PD.RGS,Y
         ldx   $04,X

* Select Dir
         pshs  u,y,X
         leas  -$04,S
         clra
         clrb
         sta   PD.FD,Y
         std   PD.FD+1,Y
         std   PD.DSK,Y

 ifeq LEVEL-1
 lda 0,x
 else
 lbsr UserByte get first pathlist byte
 endc

         sta   S.Delim,S
         cmpa  #$2F
         bne   SchDir20
         lbsr  RBPNam
         sta   ,S
         lbcs  DirErr
         leax  ,Y
         ldy   $06,S
         bra   SchDir30

* Default dir used; determine FD sector
SchDir20    anda  #$7F
         cmpa  #$40
         beq   SchDir30
         lda   #$2F
         sta   ,S
         leax  -$01,X
         lda   $01,Y
         ldu   D.Proc
         leau  <$20,U
         bita  #$24
         beq   SchDir25
         leau  $06,U
SchDir25    ldb   $03,U
         stb   PD.FD,Y
         ldd   $04,U
         std   <$35,Y

* Initial dir has been found
SchDir30    ldu   $03,Y
         stu   <$3E,Y
         lda   <$21,Y
         ldb DTBSiz,pcr
         mul
         addd  $02,U
         addd  #$000F
         std   <$1E,Y
         lda   ,S
         anda  #$7F
         cmpa  #$40
         bne   SchDir35
         leax  $01,X
         bra   SchDir50

SchDir35    lbsr  GETDD
         lbcs  DirErr10
         ldu   $08,Y
         ldd   $0E,U
         std   <$1C,Y
         ldd   <$35,Y
         bne   SchDir50
         lda   PD.FD,Y
         bne   SchDir50
         lda   $08,U
         sta   PD.FD,Y
         ldd   $09,U
         std   <$35,Y

SchDir50    stx   $04,S
         stx   $08,S
SchDir60    lbsr  CLRBUF
         lbsr  Insert
         bcs   DirErr10
         lda   ,S
         cmpa  #$2F
         bne   SchDir85
         clr   $02,S
         clr   $03,S
         lda   $01,Y
         ora   #$80
         lbsr  CHKACC
         bcs   DirErr
         lbsr  InitPD10
         ldx   $08,S
         leax  $01,X
         lbsr  RBPNam
         std   ,S
         stx   $04,S
         sty   $08,S
         ldy   $06,S
         bcs   DirErr
         lbsr  RdCurDir
         bra   SchDir80

* Repeat until name found, or error
SchDir70    bsr   SaveDel
SchDir75    bsr   RdNxtDir
SchDir80    bcs   DirErr
         tst   ,X
         beq   SchDir70
         leay  ,X
         ldx   $04,S
         ldb   $01,S
         clra
         os9   F$CmpNam
         ldx   $06,S
         exg   x,Y
         bcs   SchDir75
         bsr   SaveDir
         lda   <$1D,X
         sta   PD.FD,Y
         ldd   <$1E,X
         std   <$35,Y
         lbsr  Remove
         bra   SchDir60

SchDir85    ldx   $08,S
         tsta
         bmi   SchDir90
         os9   F$PrsNam
         leax  ,Y
         ldy   $06,S
SchDir90    stx   $04,S
         clra
SchDir99    lda   ,S
         leas  $04,S
         puls  PC,u,y,X

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
         cmpa  #PDELIM
         beq   SaveD99
         ldd S.RcdPtr+4,S
         bne   SaveD99
         puls  D

SaveDir pshs D save reg
         stx S.RcdPtr+4,S
         lda   PD.FD,Y
         sta PD.DFD,Y
         ldd PD.FD+1,Y
         std PD.DFD+1,Y
         ldd PD.CP,Y
         std PD.DCP,Y
         ldd PD.CP+2,Y
         std PD.DCP+2,Y
SaveD99 puls PC,D exit

 page
***************
* Subroutine RdNxtDir
*   Read Current or next dir rcd

RdNxtDir ldb PD.CP+3,Y update current posn
         addb  #DIR.SZ
         stb PD.CP+3,Y
         bcc RdCurDir
         lbsr CLRBUF
         inc PD.CP+2,Y
         bne   RdCurDir
         inc PD.CP+1,Y
         bne   RdCurDir
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

RBPNam    os9   F$PrsNam
         pshs  x
         bcc   RBPNam99
         clrb
RBPNam10    pshs  a
         anda  #$7F
         cmpa  #PDIR
         puls  a
         bne   RBPNam80
         incb
         leax  $01,X
         tsta
         bmi   RBPNam80

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
         anda  #EXEC.+UPDAT. get r/w/e bits
         andb  #DIR.+SHARE. get dir and sharable bit
         pshs  X,D save them
         lbsr  GETFD
         bcs   CHKAbt
         ldu   $08,Y
         ldx   D.Proc
         ldd   $08,X
         beq   ChkAcc05
         cmpd  $01,U
ChkAcc05    puls  a
         beq   CHKA10
         lsla
         lsla
         lsla
CHKA10    ora   ,S
         anda  #$BF
         pshs  a
         ora   #$80
         anda  ,U
         cmpa  ,S
         beq   CHKA20
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

Insert    pshs  u,y,X
         clra
         clrb
         std   $0B,Y
         std   $0D,Y
         sta   PD.SSZ,Y
         std   PD.SSZ+1,Y
         ldb   PD.FD,Y
         ldx   <$35,Y
         pshs  x,b
         ldu   <$1E,Y
         ldy   PD.Exten,Y
         sty   PE.Confl,Y
         leau  <$15,U
         bra   Insert20

Insert10 ldu PE.NXFil,U move to next file in list
* (Y)=PE ptr to file to be inserted
* (U)=PE ptr to previous PE in File List
Insert20 ldx PE.NXFil,U End of File list?
         beq   Insert80
         ldx   $01,X
         ldd   PD.FD,X
         cmpd  ,S
         bcs   Insert10
         bhi   Insert80
         ldb   <$36,X
         cmpb  $02,S
         bcs   Insert10
         bhi   Insert80 ..above; insert

* Equal -File List already contains this file
         ldx   PD.Exten,X
         lda   $07,Y
         bita  #FileLock sharable?
         bne   SharErr
         sty   PE.NxFil,Y
         ldd   PE.Confl,X
         std   PE.Confl,Y
         sty   PE.Confl,X
         bra   Insert90
Insert80    ldx   PE.NxFil,U
         stx   PE.NxFil,Y
         sty   PE.NxFil,U
Insert90    clrb
Insert99 leas 3,S
 puls PC,U,Y,X

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
         beq Remove90
Remove20    cmpy PE.Confl,X
         bne   Remove10
         ldd   PE.Confl,Y
         std   PE.Confl,X
         bra   Remove40

* Remove from File List if member
Remove30    ldu   PE.NxFil,U
Remove40    ldd   PE.NxFil,U
         beq   Remove90
         cmpy  PE.NxFil,U
         bne   Remove30

* (U)=ptr to predecessor of (Y) on File List
         ldx   PE.NxFil,Y
         cmpy  PE.Confl,Y Single entry Conflict List?
         beq   Remove50 ..Yes; remove file from list
         ldx   PE.Confl,Y
         ldd   PE.NxFil,Y
         std   PE.NxFil,X
Remove50    stx   PE.NxFil,U
Remove90    sty   PE.Confl,Y clear Conflict ptr
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

RelsALL    lda   #RcdLock+FileLock+EofLock
Release    pshs  u,y,x,D save regs
         bita  $07,Y
         beq   Releas05
         coma
         anda  $07,Y
         sta   $07,Y
         bita  #$02
         bne   Releas90
Releas05    leau  ,Y
Releas10    ldx   PE.Wait,U
         cmpy  PE.Wait,U
         beq   Releas85
         stu   PE.Wait,U
         leau  ,X
         lda   <$14,U
         ldb   #$01
         os9   F$Send
         bra   Releas10

Releas85    stu   PE.Wait,U
Releas90    puls  PC,u,y,x,D

LckSegER comb
 ldb #E$Share
UnLock    pshs  y,b,CC
         ldy   PD.Exten,Y
         bsr   RelsALL
         puls  PC,y,b,CC

 ttl Gain - Determined file lockout
 page
***************
* Subroutine Gain
*   Determined Lockout

Gain00 ldx #0
 bra Gain

Gain10 ldu PD.Exten,Y
         lda   PE.Req,U
         sta   PE.Lock,U
         puls  u,y,x,D
Gain    pshs  u,y,x,D
         ldu   PD.Exten,Y
         lda   PE.Lock,U
         sta   PE.Req,U
         lda   ,S
         lbsr  LockSeg
         bcc   Gain90
         ldu   D.Proc
         lda PE.Owner,X
Gain20    os9   F$GProcP
         bcs   Gain40
         lda P$DeadLk,Y
         beq   Gain40
         cmpa  P$ID,U
         bne   Gain20

* Deadly Embrace threat.
* (X)=Dominant PE ptr
* (U)=D.Proc
 ldb #E$DeadLk return Deadlock error
 bra GainErr

* Enter Lockout Waiting Queue
* (U)=D.Proc
* (X)=Dominant PE
Gain40    lda PE.Owner,X
         sta P$DeadLk,U
         bsr   UnQueue
         ldy 4,S

         ldu   PD.Exten,Y
         ldd   PE.Wait,X
         stu   PE.Wait,X
         std   PE.Wait,U
         ldx PE.TmOut,U
         os9   F$Sleep
         pshs  x
         leax 0,U
         bra   Gain55
Gain50    ldx   PE.Wait,X
Gain55    cmpu  PE.Wait,X
         bne   Gain50
         ldd   PE.Wait,U
         std   PE.Wait,X
         stu   PE.Wait,U
         puls  x
         ldu   D.Proc
         clr   <$1E,U
         lbsr  ChkSignl
         bcs   GainErr
         leax  ,X
         bne   Gain10
         ldu   PD.Exten,Y
         ldx   <$12,U
         beq   Gain10
         ldb   #$FC
GainErr    coma
         stb   $01,S
Gain90    puls  PC,u,y,x,D

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

LockSeg std -2,S
         bne   LckSeg10
         cmpx  #$0000
         lbeq  UnLock
LckSeg10    bsr   Conflct
         lbcs  LckSegER
         pshs  u,y,X
         ldy   PD.Exten,Y
         lda   #$01
         lbsr  Release
         ora   PE.Lock,Y
         sta   PE.Lock,Y
         clrb
         puls  PC,u,y,X

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

Conflct pshs  u,y,D
         leau  0,Y
         ldy   PD.Exten,Y
         subd  #1
         bcc   Conflc05
         leax  -1,X
Conflc05    addd PD.CP+2,U
         exg   d,X
         adcb  $0C,U
         adca  $0B,U
         bcc   Conflc10
         ldx   #$FFFF
         tfr   x,d
Conflc10 std PE.HiLck,Y init desired Hi lock
         stx PE.HiLck+2,Y

* Determine if EOF is required
         cmpd  PD.SIZ,U
         bcs   Conflc15
         bhi   Conflc12
         cmpx  PD.SIZ+2,U
         bcs   Conflc15
Conflc12    lda   PE.Lock,Y
         ora   #$04
         sta   PE.Lock,Y
         bra   Conflc17

Conflc15    lda   #$04
         bita  PE.Lock,Y
         beq   Conflc17
         lbsr  Release

Conflc17    ldd   PD.CP,U
         ldx   PD.CP+2,U
         std   PE.LoLck,Y
         stx   PE.LoLck+2,Y
         lda   PD.CPR,U
         sta   PE.Owner,Y

         leax  0,Y
Conflc20    cmpy  PE.Confl,X
         beq   Conflc90
         ldx   PE.Confl,X
         ldb   PE.Owner,Y
         cmpb  PE.Owner,X
         beq   Conflc20
         lda   PE.Lock,X
         beq   Conflc20
         ora   PE.Lock,Y
         bita  #$02
         bne   Conflc85
         lda   PE.Lock,X
         anda  PE.Lock,Y
         bita  #$04
         bne   Conflc85

* Check whether segments overlap
* (X)=next PE
* (Y)=requesting PE ptr
         ldd   $08,X
         cmpd  $0C,Y
         bhi   Conflc20
         bcs   Conflc30
         ldd   $0A,X
         cmpd  $0E,Y
         bhi   Conflc20
         beq   Conflc85

Conflc30    ldd   $0C,X
         cmpd  $08,Y
         bcs   Conflc20
         bhi   Conflc85
         ldd   $0E,X
         cmpd  $0A,Y
         bcs   Conflc20 ..below; not a conflict


Conflc85 comb a conflict
Conflc90 puls PC,u,y,D return

 else
Remove rts
 endc
 page
***************
* Subroutine Expand
* Expand File Size, Allocate Storage

EXPAND    pshs  u,X
EXPA10    bsr   EXPSUB
         bne   EXPA15
         cmpx  PD.SSZ+1,Y
         bcs   EXPA45
         bne   EXPA15
         lda   <$12,Y
         beq   EXPA45
EXPA15    lbsr  GETFD
         bcs   EXPERR
         ldx   $0B,Y
         ldu   $0D,Y
         pshs  u,X
         ldd   PD.SIZ,Y
         std   $0B,Y
         ldd   PD.SIZ+2,Y
         std   $0D,Y
         lbsr  GETSEG
         puls  u,X
         stx   $0B,Y
         stu   $0D,Y
         bcc   EXPA45
         cmpb  #$D5
         bne   EXPERR
         bsr   EXPSUB
         bne   EXPA30
         tst   <$12,Y
         beq   EXPA35
         leax  $01,X
         bne   EXPA35
EXPA30    ldx   #$FFFF
EXPA35    tfr   x,d
         tsta
         bne   EXPA40
         cmpb  <$2E,Y
         bcc   EXPA40
         ldb   <$2E,Y
EXPA40    bsr   SEGALL
         bcc   EXPA10
EXPERR    coma
         puls  PC,u,X

EXPA45    lbsr  CHKSEG
 ifeq RCD.LOCK-included
 bcs EXPERR ..error; abort
 bsr NewSize Copy size thru conflict list
 endc
 puls PC,U,X

EXPSUB ldd PD.SIZ+1,Y get file size
         subd PD.SBL+1,Y
         tfr   d,X
         ldb   PD.SIZ,Y
         sbcb PD.SBL,Y
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
         pshs  u,X
         ldu   PD.Exten,Y
         bra   NewSiz20

NewSiz10    ldu   $01,U
         ldx   PD.SIZ,Y
         stx   PD.SIZ,U
         ldx   PD.SIZ+2,Y
         stx   PD.SIZ+2,U
         bitb  $01,Y
         beq   NewSiz15
         inca
NewSiz15    ldu   PD.Exten,U
NewSiz20    ldu   $05,U
         cmpy  $01,U
         bne   NewSiz10
* Note: carry is clear
         tsta
 puls  PC,u,X
 endc

***************
* Subroutine SEGALL
* Segment Allocation

SEGALL    pshs  u,X
         lbsr  SECALL
         bcs   SEGALErr
         lbsr  GETFD
         bcs   SEGALErr
         ldu   $08,Y
         clra
         clrb
         std   $09,U
         std   $0B,U
         leax  <$10,U
         ldd   $03,X
         beq   SEGA20

*   Find Empty Segment List Entry
         ldd PD.BUF,Y
         inca
         pshs  D
         bra   EMPS20

EMPS10 clrb clear Carry
         ldd   FDSL.B-FDSL.S,X get seg size
         beq   EMPS30 bra if end of list
         addd FD.SIZ+1,U Update file size
         std FD.SIZ+1,U
         bcc   EMPS20 bra if no carry
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
 adcb  #0 Proagate carry
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
SEGA30 puls PC,u,X
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
S.SASSct rmb 1
S.SESCls rmb 2
S.ClSize rmb 2
S.MapSiz rmb 2
S.MapSct rmb 1
S.HiSct rmb 1
S.HiSize rmb 2
S.HiPosn rmb 2
S.BitReq rmb 2
S.x rmb 2
S.PDptr rmb 2
 rmb 2 (U)

SECALL    pshs  u,y,x,D
         ldb   #S.BitReq
SECA05    clr   ,-s
         decb
         bne   SECA05
         ldx   <$1E,Y
         ldd   $04,X
         std   $05,S
         ldd   $06,X
         std   $03,S
         std   $0B,S

* Convert Segment Allocation Size (SAS) to clusters
* (D)=cluster size
         ldx   $03,Y
         ldx   $04,X
         leax  <$12,X
         subd  #$0001
         addb  $0E,X
         adca  #$00
         bra   SECA08
SECA07    lsra
         rorb
SECA08    lsr   $0B,S
         ror   $0C,S
         bcc   SECA07
         std   $01,S

* Convert Sectors Requested to Bits Required
         ldd   $03,S
         std   $0B,S
         subd  #$0001
         addd  $0D,S
         bcc   SECA12
         ldd   #$FFFF
         bra   SECA12
SECA10 lsra While..
         rorb
SECA12 lsr S.HiPosn,S divide by cluster size
         ror S.HiPosn+1,S (even power of two)
         bcc   SECA10 ..Do
         cmpa  #$08 greater than 256*8 (1-sector of bits)?
         bcs   SECA13 ..Yes; good
         ldd   #256*8 request whole sector
SECA13    std S.BitReq,S

* Set Map Beginning Addr
         lbsr  LockBit
         lbcs  SECA85
         ldx   <$1E,Y
         ldd   <$1A,X
         cmpd  DD.DSK,X Has disk changed?
         bne   SECA14 ..Yes; start with 1st bitmap sector
         lda V.BMapSz,X
         cmpa  $04,X
         bne   SECA14
         ldd   $0D,S
         cmpd  $01,S
         bcs   SECA15
         lda   <$1D,X
         cmpa  $04,X
         bcc   SECA14
         sta   $07,S
         nega
         adda  $05,S
         sta   $05,S
         bra   SECA15

SECA14    ldd   $0E,X
         std   <$1A,X
         lda   $04,X
         sta   <$1C,X
         clr   <$1D,X
SECA15    inc   $07,S
         ldb   $07,S
         lbsr  ReadBit
         lbcs  SECA85
         ldd   $05,S
         tsta
         beq   SECA17
         ldd   #$100 use entire buffer
SECA17    ldx PD.BUF,Y
         leau  d,X
         ldy  S.BitReq,S
         clra
         clrb
         os9   F$SchBit Search bitmap
         pshs  D,CC save regs
         tst   S.SASSct+3,S already found in Min allocation?
         bne   SECA17a ..Yes; continue
         cmpy  $04,S
         bcs   SECA17a
         lda   $0A,S
         sta S.SASSct+3,S
SECA17a    puls  D,CC
         bcc SECA20 found: Allocate bits
         cmpy S.HiSize,S largest segment found?
         bls   SECA18
         sty   $09,S
         std   $0B,S
         lda   $07,S
         sta   S.HiSct,S
SECA18    ldy   <$11,S
         tst   $05,S
         beq   SECA18b
         dec   $05,S
         bra   SECA15 repeat

SECA18b    ldb S.HiSct,S
         beq   SECA80
         clra
         cmpb  $07,S
         beq   SECA19
         stb   $07,S
         lbsr  ReadBit
SECA19    ldx PD.Buf,Y
         ldd   $0B,S
         ldy   $09,S
SECA20    std   $0B,S
         sty   $09,S
         os9   F$AllBit
         ldy S.PDptr,S restore PD
         ldb S.MapSct,S
         lbsr  PUTBIT
         bcs   SECA85
         lda S.SASSct,S
         beq   SECA22
         ldx PD.DTB,Y
         deca
         sta V.MapSct,X
SECA22    lda S.MapSct,S
         deca convert to bit offset
         clrb times 8 bits/byte
         lsla
         rolb
         lsla
         rolb
         lsla
         rolb
         stb   PD.SBP,Y save beginning addr msb
         ora   $0B,S
         ldb   $0C,S
         ldx   $09,S
         ldy   <$11,S
         std   PD.SBP+1,Y
         stx   PD.SSZ+1,Y

         ldd   $03,S
         bra   SECA30
SECA25    lsl   <$18,Y
         rol   PD.SBP+1,Y
         rol   PD.SBP,Y
         lsl   <$1B,Y
         rol   PD.SSZ+1,Y
SECA30    lsra
         rorb
         bcc   SECA25
         clrb
         ldd   PD.SSZ+1,Y
         bra   SECA90

SECA80    ldb   #E$FULL Err: media full
SECA85    ldy  S.PDptr,S (Y)=PD
         lbsr  RLSBIT release bitmap
         coma abort: return carry set
SECA90    leas S.x,S discard temps
         puls  PC,u,y,X exit
 page
***************
* Subroutine Trim
*   Trim File Size, Deallocate Any Excess

* Passed: (Y)=PD
* Returns: None
* Destroys: CC,D,X,U

TRIM    clra clear carry
         lda PD.MOD,Y
         bita  #DIR.
         bne   TrimE99
         ldd   PD.SIZ,Y
         std   PD.CP,Y
         ldd   PD.SIZ+2,Y
         std   PD.CP+2,Y

 ifeq RCD.LOCK-included
 ldd #$FFFF
 tfr d,X
 lbsr GAIN
 bcs TrimErr
 lbsr NewSize
 bne TrimE99
 endc

         lbsr  GETSEG
         bcc   TRIM10
         cmpb  #E$NES Non-existing seg error?
         bra   TRIM29
TRIM10    ldd   <$14,Y
         subd  $0C,Y
         addd  PD.SSZ+1,Y
         tst   $0E,Y
         beq   TRIM20
         subd  #1
TRIM20    pshs  D
         ldu   <$1E,Y
         ldd   $06,U
         subd  #$0001
         coma
         comb
         anda  ,s+
         andb  ,s+
         ldu   PD.SSZ+1,Y
         std   PD.SSZ+1,Y
         beq   TRIM30
         tfr   u,d
         subd  PD.SSZ+1,Y
         pshs  x,D
         addd  PD.SBP+1,Y
         std   PD.SBP+1,Y
         bcc   TRIM26
         inc   PD.SBP,Y
TRIM26    bsr   SECDEA
         bcc   TRIM40
         leas  $04,S
         cmpb  #E$IBA
TRIM29 bne TrimErr
TRIM30  lbsr  GETFD
 bcc TRIM50
TrimErr coma
TrimE99 rts

TRIM40    lbsr  GETFD
         bcs   TRIM80
         puls  x,D
         std   $03,X
TRIM50    ldu   $08,Y
         ldd   PD.SIZ+2,Y
         std   $0B,U
         ldd   PD.SIZ,Y
         std   $09,U
         tfr   x,d
         clrb
         inca
         leax  $05,X
         pshs  x,D
         bra   TRIM65

TRIM60 ldd FDSL.B-FDSL.S,X get seg size
         beq   TRIM75 bra if done
         std   PD.SSZ+1,Y
         ldd FDSL.A-FDSL.S,X
         std   PD.SBP,Y
         lda FDSL.A+2-FDSL.S,X
         sta   <$18,Y
         bsr   SECDEA
         bcs   TRIM80
         stx   $02,S
         lbsr  GETFD
         bcs   TRIM80
         ldx   $02,S
         clra
         clrb
         std FDSL.A-FDSL.S,X
         sta FDSL.A+2-FDSL.S,X
         std FDSL.B-FDSL.S,X
TRIM65    lbsr PUTFD
         bcs TRIM80
         ldx 2,S
         leax FDSL.S,X
         cmpx  0,S
         bcs   TRIM60
TRIM75    clra
         clrb
         sta   PD.SSZ,Y
         std   PD.SSZ+1,Y
TRIM80    leas 4,S
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

SECDEA    pshs  u,y,x,a
         ldx   <$1E,Y
         ldd   $06,X
         subd  #$0001
         addd  PD.SBP+1,Y
         std   PD.SBP+1,Y
         ldd   $06,X
         bcc   SECD10
         inc   PD.SBP,Y
         bra   SECD10
SECD05    lsr   PD.SBP,Y
         ror   PD.SBP+1,Y
         ror   <$18,Y
         lsr   PD.SSZ+1,Y
         ror   <$1B,Y
SECD10    lsra
         rorb
         bcc   SECD05
         clrb
         ldd   PD.SSZ+1,Y
         beq   L0EC2
         ldd   PD.SBP,Y
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         tfr   b,a
         ldb   #E$IBA error code: Illegal Block Addr
         cmpa DD.MAP,X
         bhi SecDErr
         cmpa  <$1D,X
         bcc   SECD15
         sta   <$1D,X
SECD15    inca
         sta   ,S
SECD20 equ *
 bsr LockBit lockout bitmap
         bcs   SECD20
         ldb   ,S
         bsr   ReadBit
         bcs   SecDErr
         ldx PD.BUF,Y
         ldd PD.SBP+1,Y
         anda #$07 mod 2048 bits/sector
         ldy   PD.SSZ+1,Y
         os9   F$DelBit
         ldy 3,S
         ldb   ,S
         bsr   PUTBIT
         bcc   L0EC2
SecDErr    coma
L0EC2    puls  PC,U,Y,X,A

***************
* Subroutine LockBit
*   LockOut Bitmap, Read first sector

LockBit    lbsr  CLRBUF
         bra   LckBit20

LckBit10    os9   F$IOQu
         bsr   ChkSignl
LckBit20    bcs   LckBit99
         ldx   <$1E,Y
         lda   V.BMB,X
         bne   LckBit10
         lda   $05,Y
         sta   V.BMB,X
LckBit99    rts

***************
* Subroutine ChkSignal
*   See if signal received caused death

ChkSignl    ldu   D.Proc
         ldb   <$19,U
         cmpb  #$01
         bls   ChkSig10
         cmpb  #$03
         bls   ChkSErr
ChkSig10    clra
         lda P$State,U
         bita  #Condem
         beq   ChkSig90
ChkSErr    coma
ChkSig90    rts

***************
* Subroutine PUTBIT
*   Rewrite/Release Bitmap

PUTBIT    clra
         tfr   d,X
         clrb
         lbsr  PUTSEC
RLSBIT    pshs  cc
         ldx   <$1E,Y
         lda   $05,Y
         cmpa  V.BMB,X
         bne   RLSBIT99
         clr   V.BMB,X
RLSBIT99    puls  PC,CC
 page
***************
* Subroutine ReadBit
*   Read Bitmap sector

ReadBit clra
 tfr D,X
 clrb
 lbra GETSEC read bitmap sector

***************
* Subroutine WRCP
*   Write Current Position Sector

WRCP     pshs  u,X
         lbsr  PCPSEC
         bcs   WRCPXX
         lda   $0A,Y
         anda  #$FE
         sta   $0A,Y
WRCPXX    puls  PC,u,X

 page
***************
* Subroutine Chkseg
*   Check Segment ptrs For Current Position

CHKSEG    ldd   $0C,Y
         subd  <$14,Y
         tfr   d,X
         ldb   $0B,Y
         sbcb  <$13,Y
         cmpb  PD.SSZ,Y
         bcs   CHKSG90
         bhi   GETSEG
         cmpx  PD.SSZ+1,Y
         bcc   GETSEG
CHKSG90 clrb
 rts

***************
* Subroutine GETSEG
*   Get Segment Containing Current Position

GETSEG pshs U save regs
 bsr GETFD
 bcs GETS30 error; abort
 clra clear D
 clrb
 std PD.SBL,Y
         stb PD.SBL+2,Y
         ldu   $08,Y
         leax  <$10,U
         lda   $08,Y
         ldb   #-(FDSL.S-1) end-(entry size-1)
         pshs D
FNDS10    ldd   $03,X
         beq   GETS10
         addd PD.SBL+1,Y
         tfr   d,U
         ldb   <$13,Y
         adcb  #$00
         cmpb  $0B,Y
         bhi   GETS25
         bne   FNDS20
         cmpu  $0C,Y
         bhi   GETS25
FNDS20    stb PD.SBL,Y
         stu PD.SBL+1,Y
         leax  $05,X
         cmpx  ,S
         bcs   FNDS10
GETS10    clra
         clrb
         sta   PD.SSZ,Y
         std   PD.SSZ+1,Y
         comb
         ldb   #E$NES
         bra   GETS30
GETS25    ldd   ,X
         std   PD.SBP,Y
         lda   $02,X
         sta   <$18,Y
         ldd   $03,X
         std   PD.SSZ+1,Y
GETS30    leas  $02,S
         puls  PC,U
 page
***************
* Subroutine GETDD
*   Get Device Desc

GETDD pshs X,B
         lbsr  CLRBUF
         bcs   GETDD10
         clrb
         ldx   #$0000
         bsr   GETSEC
         bcc   GETDD20
GETDD10    stb   ,S
GETDD20    puls  PC,x,b

***************
* Subroutine GETFD
*   Get File Descriptor

GETFD ldb PD.SMF,Y get flag
         bitb  #FDBUF
         bne   CHKSG90
         lbsr  CLRBUF
         bcs   PUTS99
         ldb   PD.SMF,Y
         orb   #$04
         stb   PD.SMF,Y
         ldb   PD.FD,Y
         ldx   <$35,Y

***************
* Subroutine GETSEC
*   Get Specified Sector

GETSEC    lda   #D$READ
* Fall into DEVDIS

***************
* Routine DEVDIS
*   Device Driver Dispatcher

* Passed: (A)=Entry offset
*         (Y)=PD ptr

DEVDIS    pshs  u,y,x,b,a

         lda   PD.SMF,Y
         ora   #InDriver
         sta   PD.SMF,Y

         ldu PD.DEV,Y
         ldu   $02,U
         bra   DEVD20
DEVD10    os9   F$IOQu
DEVD20    lda   $04,U
         bne   DEVD10
         lda   $05,Y
         sta   $04,U
         ldd   ,S
         ldx   $02,S
         pshs  u
         bsr   GODRIV
         puls  u

         ldy   $04,S
         pshs  cc
         lda   PD.SMF,Y
         anda  #^InDriver signal I/O finished
         sta   PD.SMF,Y

         clr V.BUSY,U
         puls  cc
         bcc   DEVD30
         stb 1,S
DEVD30    puls  PC,u,y,x,b,a

GODRIV    pshs  PC,x,b,a
         ldx   PD.DEV,Y
         ldd   V$DRIV,X
         ldx   V$DRIV,X
         addd  M$EXEC,X
         addb 0,S
         adca  #0
         std 4,S
         puls  PC,x,b,a

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
         pshs  x,b,a
         ldd PD.DSK,Y
         beq   PUTS10
         ldx   <$1E,Y
         cmpd  $0E,X
PUTS10    puls  x,b,a
         beq   DEVDIS
         comb
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

CLRBUF    clrb
         pshs  u,X
         ldb   PD.SMF,Y
         andb  #SINBUF+FDBUF
         beq   CLRB10
         tfr   b,a
         eorb  PD.SMF,Y
         stb   PD.SMF,Y
         andb  #$01
         beq   CLRB10
         eorb  PD.SMF,Y
         stb   PD.SMF,Y
         bita  #$02
         beq   CLRB10
         bsr   PCPSEC
CLRB10    puls  PC,u,X

***************
* Subroutine RDCP
*   Read Current Position

RDCP    pshs  u,X
         lbsr  CHKSEG
         bcs   RDCPXX

***************
* Subroutine GCPSEC
*   Get Current Position

 bsr CLRBUF clear buffer
 bcs RDCPXX error; abort
 ifeq RCD.LOCK-included
GCPS05 ldb PD.CP,Y
 ldu PD.CP+1,Y
         leax 0,Y
         ldy PD.Exten,Y
GCPS10 ldx PD.Exten,X
         cmpy  $05,X
         beq   GCPS90
         ldx   $05,X
         ldx   $01,X
         cmpu  $0C,X
         bne   GCPS10
         cmpb  $0B,X
         bne   GCPS10
         lda   PD.SMF,X
         bita  #$20
         bne   GCPS15
         bita  #$02
         beq   GCPS10
         bra   GCPS20
GCPS15    lda   $05,X
         ldy   $01,Y
         os9   F$IOQu
         lbsr  ChkSignl
         bcc   GCPS05
         bra   RDCPXX

GCPS20 ldy PE.PDptr,Y Move to PD
 ldd PD.Buf,X Swap buffer pointers
 ldu PD.Buf,Y
 std PD.Buf,Y
 stu PD.Buf,X
 lda PD.SMF,X Get state Flags
 sta PD.SMF,Y  from holding PD
 clr PD.SMF,X
 puls PC,u,X
GCPS90 ldy PE.PDptr,Y Restore registers
 endc
 lbsr GETCP get addr of current posn
 lbsr GETSEC get sector off of disk
 bcs RDCPXX error; abort
 lda PD.SMF,Y
 ora #SINBUF Set sector in buffer
 sta PD.SMF,Y
RDCPXX puls PC,u,X

 emod
RBFEnd equ *
