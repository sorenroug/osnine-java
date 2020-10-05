********************************************************************
* RBF - Disk file manager
*
* Ed.    Comments                                       Who YY/MM/DD
* ------------------------------------------------------------------
* 24     Tandy/Microware original version

         nam   RBF
         ttl   Disk file manager

* LEVEL 1 without RCD.lock

 use   defsfile

included equ 1
 ifeq LEVEL-1
RCD.LOCK equ 0
 else
RCD.LOCK equ included
 endc

 pag
***************
* Edition History

*  #   Date      Comments                                      By
* ----------- ----------------------------------------------- ---

Edition equ 24

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
         lbsr  SchDir
         bcs   Create10
         ldb   #$DA
Create10    cmpb  #$D8
         bne   CRTEX1
         cmpa  #$2F
         beq   CRTEX1
         pshs  x
         ldx   $06,y
         stu   $04,x

* Allocate File Descriptor Sector
 ldb PD.SBP,Y
 ldx PD.SBP+1,Y
 lda PD.SSZ,Y
 ldu PD.SSZ+1,Y
 pshs U,X,D save them
 clra
 ldb #1 request one FD sector
         lbsr  SECALL
         bcc   Create20
         leas 6,s return scratch
L0070    leas 2,s
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
         bne   L0070
 ldd #DIR.SZ add size of new rcd
 lbsr WriteSub expand Dir
         bcs   L0070
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
         lbsr  SECDEA
         puls  b
CRTERR99    lbra  KillPth0
***************
* Subroutines ZerDir, ZerBuf
*   Zero Dir size rcd, or buffer
* Record size MUST be evenly divisive by 4

* Passed: (U)=rcd ptr
* Destroys: CC

ZerDir    pshs  u,x,b,a
         leau  <$20,u
         bra   L0169

ZerBuf    pshs  u,x,b,a
         leau  >$0100,u
L0169    clra
         clrb
         tfr   d,x
L016D    pshu  x,b,a
         cmpu  $04,s
         bhi   L016D
         puls  pc,u,x,b,a

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
         lbsr  GETFD
 ldu PD.BUF,Y FD buffer ptr
 lda FD.ATT,u get file attributes
 ora #DIR. mark as dir
 sta FD.ATT,u update FD
         bsr   WrtFDS10 update size in FD sector
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

WrtFDSiz    lbsr  GETFD
WrtFDS10    ldx   $08,y
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
         lbsr  EOFTest
         bcc   KillPth1
         lbsr  TRIM
         bra   KillPth1
Close99    rts

IllAcces    ldb   #$D6
KillPth0    coma

KillPth puls  y
KillPth1  pshs  b,cc
         ldu   PD.BUF,y     address of buffer
         beq   KillPth9
         ldd   #$0100    size of buffer
         os9   F$SRtMem

KillPth9    puls  pc,b,cc

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
 ldu PD.FD+1,Y get lsbs of FD psn
 ldb PD.MOD,Y get mode
 bitb #READ.+WRITE. R/W dir?
 beq ChgDir10 ..no
 ldb PD.FD,Y FD psn msb
         stb   <$1D,x
         stu   <$1E,x
ChgDir10    ldb   $01,y
         bitb  #$04
 beq ChgDir90 ..no; exit
 ldb PD.FD,Y FD psn msb
         stb   <$23,x
         stu   <$24,x
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

Delete15    clra
         clrb
         std   $0F,y
         std   <$11,y
         lbsr  TRIM
         bcs   Delete99
         ldb   <$34,y
         ldx   <$35,y
         stb   <$16,y
         stx   <$17,y
         ldx   $08,y
         ldd   <$13,x
         addd  #$0001
         std   <$1A,y
         lbsr  SECDEA

Delete20    bcs   Delete99
         lbsr  CLRBUF
         lbsr  Remove
         lda   <$37,y
         sta   <$34,y
         ldd   <$38,y
         std   <$35,y
         lbsr  GETFD
         bcs   Delete99
         lbsr  Insert
         ldu   $08,y
         lbsr  InitPD10
         ldd   <$3A,y
         std   $0B,y
         ldd   <$3C,y
         std   $0D,y
         lbsr  RdCurDir
         bcs   Delete99
         clr   ,x
         lbsr  PCPSEC
Delete99    lbra  KillPth

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
RDLine10    leay  $01,y
         cmpa  ,x+
         beq   RDLine20
         decb
         bne   RDLine10
RDLine20    ldx   $06,s
         bsr   ToUser
         sty   $0A,s
         puls  u,y,x,b,a
         ldd   $02,s
         leax  d,x
RDLine0    rts

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
         beq   ReadLn20
         ldd   $02,s
         lbne  RBRW10
ReadLn20    ldu   $06,y
         ldd   $06,u
         subd  $02,s
         std   $06,u
         bra   Read90

 page
***************
* Subroutine ReadInit
*   Initialize Path for Read/Readline request

* Passed: (Y)=PD
*         (U)=User's register stack
* Returns: R$Y,U=max(requested, remaining) bytcnt
*          CC,B set if error occurs
* Destroys: D,X

ReadInit    ldd   $06,u
         bsr   RDSET
         bcs   ReadIERR
         std   $06,u
         rts

***************
* Subroutine Rdset
* End of File Test & Maximum Check

* Passed: (D)=requested bytecount
*         (Y)=PD
* Returns: (D)=max(requested, remaining) bytecount
* Destroys: X

RDSET    pshs  b,a
         ldd   <$11,y
         subd  $0D,y
         tfr   d,x
         ldd   $0F,y
         sbcb  $0C,y
         sbca  $0B,y
         bcs   RDSET80
         bne   RDSET10
         tstb
         bne   RDSET10
         cmpx  ,s
         bcc   RDSET10
         stx   ,s
         beq   RDSET80
RDSET10    clrb
         puls  pc,b,a

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
         beq   RBRW20
         leax  WrByte,pcr
         cmpx  $06,s
         bne   RBRW20
         lbsr  CHKSEG
         bra   RBRW22
RBRW20    lbsr  RDCP
RBRW22    bcs   RBRWER
RBRW25    ldu   $08,y
         clra
         ldb   $0E,y
         leau  d,u
         negb
         sbca  #$FF
         ldx   ,s
         cmpd  $02,s
         bls   RBRW30
         ldd   $02,s
RBRW30    pshs  b,a
         jsr   [<$08,s]
         stx   $02,s
         lda   $0A,y
         anda  #$BF
         sta   $0A,y
         ldb   $01,s
         addb  $0E,y
         stb   $0E,y
         bne   RBRW35
         lbsr  CLRBUF
         inc   $0D,y
         bne   RBRW34
         inc   $0C,y
         bne   RBRW34
         inc   $0B,y
RBRW34    bcs   RBRWER1
RBRW35    ldd   $04,s
         subd  ,s++
         std   $02,s
         jmp   [<$04,s]

 page
***************
* Subroutine Writline
*   Write Bytes to carriage return or Maximum

WritLine  pshs  y
         clrb
         ldy   $06,u
         beq   WritLn20
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

Write    ldd   $06,u
         beq   L04BE
         bsr   WriteSub
         bcs   L04BF
         bsr   Write1

* Subroutine WrByte
*   Move Bytes from Source to Buffer

* Passed: (D)=bytecount
*         (X)=source ptr (in caller's addr space)
*         (U)=destination ptr (in system addr space)
* Returns: (X)=updated source ptr

WrByte    pshs  y,b,a
         tfr   d,y
         bsr   FromUser
         puls  y,b,a
         leax  d,x
         lda   $0A,y
         ora   #$03
         sta   $0A,y
         rts

Write1    lbsr  RBRW00

* Write Loop Exit
* Note: entered with ALL StkTemps initialized
         lbne  RBRW10
         leas  $08,s

L04BE    clrb
L04BF    rts

***************
* Subroutine WriteSub
*   Update current position, expand file if needed

* Passed: (D)=Bytes written
*         (Y)=PD
* Returns: CC,B=Error status
* Destroys: D,X

WriteSub    addd  $0D,y
         tfr   d,x
         ldd   $0B,y
         adcb  #$00
         adca  #$00

* (D,X)=new potential file size
WriteS10    cmpd  $0F,y
         bcs   L04BE
         bhi   L04D6
         cmpx  <$11,y
         bls   L04BE
L04D6    pshs  u
         ldu   <$11,y
         stx   <$11,y
         ldx   $0F,y
         std   $0F,y
         pshs  u,x
         lbsr  EXPAND
         puls  u,x
         bcc   WriteS90
         stx   $0F,y
         stu   <$11,y
WriteS90    puls  pc,u

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

GetS.A    cmpb  #$01
         bne   L0536
         clr   $02,u
         rts
L0536    cmpb  #$02
         bne   GetS.C
         ldd   $0F,y
         std   $04,u
         ldd   <$11,y
         std   $08,u
GetS.B9    rts

GetS.C    cmpb  #$05
         bne   GetS.D
         ldd   $0B,y
         std   $04,u
         ldd   $0D,y
         std   $08,u
         rts

GetS.D    cmpb  #$0F
         bne   GetS.X
         lbsr  GETFD
         bcs   GetS.B9
         ldu   $06,y
         ldd   $06,u
         tsta
         beq   Gets.D1
         ldd   #$0100
Gets.D1    ldx   $04,u
         ldu   $08,y
         lbra  RdByte

GetS.X    lda   #$09
         lbra  DEVDIS


 page
***************
* Subroutine Putstat
*   Set Specific Status Information

PutStat  ldb   $02,u
         cmpb  #$00
         bne   PSt100
         ldx   $04,u
         leax  $02,x
         leau  <$22,y
         ldy   #$000D
         lbra  FromUser

PSt100    cmpb  #$02
         bne   PSt110
         ldd   <$35,y
         bne   PSt100.A
         tst   <$34,y
         lbeq  PStErr
PSt100.A    lda   $01,y
         bita  #$02
         beq   L05C2
         ldd   $04,u
         ldx   $08,u
         cmpd  $0F,y
         bcs   L05AD
         bne   L05AA
         cmpx  <$11,y
         bcs   L05AD
L05AA    lbra  WriteS10

L05AD    std   $0F,y
         stx   <$11,y
         ldd   $0B,y
         ldx   $0D,y
         pshs  x,b,a
         lbsr  TRIM
         puls  u,x
         stx   $0B,y
         stu   $0D,y
         rts

L05C2    comb
         ldb   #$CB
         rts

PSt110    cmpb  #$0F
         bne   L0604
         lda   $01,y
         bita  #$02
         beq   L05C2
         lbsr  GETFD
         bcs   Return99
         pshs  y
         ldx   $04,u
         ldu   $08,y
         ldy   <$004B
         ldd   $09,y
         bne   L05E7
         ldd   #$0102
         bsr   L05F6
L05E7    ldd   #$0305
         bsr   L05F6
         ldd   #$0D03
         bsr   L05F6
         puls  y
         lbra  PUTFD
L05F6    pshs  u,x
         leax  a,x
         leau  a,u
         clra
         tfr   d,y
         lbsr  FromUser
         puls  pc,u,x

L0604    cmpb  #$1E
         bne   PSt999
         ldx   <$1E,y
         lda   $05,u
         sta   <$1E,x
         clr   <$1D,x
         rts

* Pass putstat to driver
PSt999    lda   #$0C
         lbra  DEVDIS

PStErr    comb
         ldb   #$D0
Return99    rts

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
SchDir    ldd   #$0100
         stb   PD.SMF,y
         os9   F$SRqMem
         bcs   Return99
         stu   PD.BUF,y      store address of buffer
         ldx   $06,y
         ldx   $04,x
         pshs  u,y,x
         leas  -$04,s
         clra
         clrb
         sta   <$34,y
         std   <$35,y
         std   <$1C,y
         lda   ,x
         sta   ,s
         cmpa  #$2F
         bne   SchDir20
         lbsr  RBPNam
         sta   ,s
         lbcs  L0752
         leax  ,y
         ldy   $06,s
         bra   SchDir30

SchDir20    anda  #$7F
         cmpa  #$40
         beq   SchDir30
         lda   #$2F
         sta   ,s
         leax  -$01,x
         lda   $01,y
         ldu   <$004B
         leau  <$1A,u
         bita  #$24
         beq   L066D
         leau  $06,u
L066D    ldb   $03,u
         stb   <$34,y
         ldd   $04,u
         std   <$35,y

* Initial dir has been found
SchDir30    ldu   $03,y
         stu   <$3E,y
         lda   <$21,y
         ldb   >DTBSiz,pcr
         mul
         addd  $02,u
         addd  #$000F
         std   <$1E,y
         lda   ,s
         anda  #$7F
         cmpa  #$40
         bne   L0698
         leax  $01,x
         bra   L06BA

L0698    lbsr  GETDD
         lbcs  L075A
         ldu   $08,y
         ldd   $0E,u
         std   <$1C,y
         ldd   <$35,y
         bne   L06BA
         lda   <$34,y
         bne   L06BA
         lda   $08,u
         sta   <$34,y
         ldd   $09,u
         std   <$35,y
L06BA    stx   $04,s
         stx   $08,s
L06BE    lbsr  CLRBUF
         lbcs  L075A
         lda   ,s
         anda  #$7F
         cmpa  #$40
         beq   L06D4
         lbsr  GETFD
         lbcs  L075A
L06D4    lbsr  Insert
         lda   ,s
         cmpa  #$2F
         bne   L0734
         clr   $02,s
         clr   $03,s
         lda   $01,y
         ora   #$80
         lbsr  CHKACC
         bcs   L0752
         lbsr  InitPD10
         ldx   $08,s
         leax  $01,x
         lbsr  RBPNam
         std   ,s
         stx   $04,s
         sty   $08,s
         ldy   $06,s
         bcs   L0752
         lbsr  RdCurDir
         bra   L070A
L0705    bsr   L075D
L0707    lbsr  RdNxtDir
L070A    bcs   L0752
         tst   ,x
         beq   L0705
         clra
         ldb   $01,s    length of first name to compare
         leay  ,x
         ldx   $04,s
         os9   F$CmpNam
         ldx   $06,s
         exg   x,y
         bcs   L0707
         bsr   L076B
         lda   <$1D,x
         sta   <$34,y
         ldd   <$1E,x
         std   <$35,y
         lbsr  Remove
         lbra  L06BE
L0734    ldx   $08,s       start of path
         tsta
         bmi   L0741
         os9   F$PrsNam
         leax  ,y          address of last char + 1
         ldy   $06,s
L0741    stx   $04,s
         clra
L0744    lda   ,s
         leas  $04,s
         pshs  b,a,cc
         lda   $0A,y
         anda  #$BF
         sta   $0A,y
         puls  pc,u,y,x,b,a,cc
L0752    cmpb  #$D3
         bne   L075A
         bsr   L075D
         ldb   #$D8
L075A    coma
         bra   L0744
L075D    pshs  b,a
         lda   $04,s
         cmpa  #$2F
         beq   SaveD99
         ldd   $06,s
         bne   SaveD99
         puls  b,a
L076B    pshs  b,a
         stx   $06,s
         lda   <$34,y
         sta   <$37,y
         ldd   <$35,y
         std   <$38,y
         ldd   $0B,y
         std   <$3A,y
         ldd   $0D,y
         std   <$3C,y
SaveD99    puls  pc,b,a

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

RdCurDir    ldd   #$0020
         lbsr  RDSET
         bcs   RdNxtD90
         lda   $0A,y
         bita  #$02
         bne   L07B4
         lbsr  CHKSEG
         bcs   RdNxtD90
         lbsr  RDCP
         bcs   RdNxtD90
L07B4    ldb   $0E,y
         lda   $08,y
         tfr   d,x
         clrb
RdNxtD90    rts

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

RBPNam    os9   F$PrsNam
         pshs  x
         bcc   RBPNam99
         clrb
RBPNam10    pshs  a
         anda  #$7F
         cmpa  #$2E
         puls  a
         bne   RBPNam80
         incb
         leax  $01,x
         tsta
         bmi   RBPNam80

 ifeq LEVEL-1
 lda 0,x
 else
 bsr UserByte get next user byte at (0,X)
 endc

         cmpb  #$03
         bcs   RBPNam10
         lda   #$2F
         decb
         leax  -$03,x
RBPNam80    tstb
         bne   L07E7
L07E2    comb
         ldb   #$D7
         puls  pc,x
L07E7    leay  ,x
RBPNam99    cmpb  #$20
         bhi   L07E2
         andcc #$FE
         puls  pc,x
 page
***************
* Subroutine ChkAcc
*   Check File Accessibility

* Passed: (A)=desired mode
*         (Y)=PD
* Returns: CC,B set if file inaccessable
* Destroys: D

CHKACC    tfr   a,b
         anda  #$07
         andb  #$C0
         pshs  x,b,a
         lbsr  GETFD
         bcs   CHKAbt
         ldu   $08,y
         ldx   <$004B
         ldd   $09,x
         beq   ChkAcc05
         cmpd  $01,u
ChkAcc05    puls  a
         beq   CHKA10
         lsla
         lsla
         lsla
CHKA10    ora   ,s
         anda  #$BF
         pshs  a
         ora   #$80
         anda  ,u
         cmpa  ,s
         beq   CHKA20
         ldb   #E$FNA
CHKAbt    leas  $02,s
         coma
         puls  pc,x

         ldb   #E$Share
         bra   CHKAbt

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

Insert    clra
         clrb
         std   $0B,y
         std   $0D,y
         sta   PD.SSZ,y
         std   PD.SSZ+1,y
Remove    rts

L0838    pshs  y,x,b,a
         ldx  D.Proc
         lda   <$11,x
         beq   L0851
         clr   <$11,x
         ldb   #$01
         os9   F$Send
         ldx   D.PrcDBT
         os9   F$Find64
         clr   <$10,y
L0851    clrb
         puls  pc,y,x,b,a

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
         lda   <$12,y
         beq   EXPA45
EXPA15    lbsr  GETFD
         bcs   EXPERR
         ldx   $0B,y
         ldu   $0D,y
         pshs  u,x
         ldd   $0F,y
         std   $0B,y
         ldd   <$11,y
         std   $0D,y
         lbsr  GETSEG
         puls  u,x
         stx   $0B,y
         stu   $0D,y
         bcc   EXPA45
         cmpb  #$D5
         bne   EXPERR
         bsr   EXPSUB
         bne   EXPA30
         tst   <$12,y
         beq   EXPA35
         leax  $01,x
         bne   EXPA35
EXPA30    ldx   #$FFFF
EXPA35    tfr   x,d
         tsta
         bne   EXPA40
         cmpb  <$2E,y
         bcc   EXPA40
         ldb   <$2E,y
EXPA40    bsr   SEGALL
         bcc   EXPA10
EXPERR    coma
         puls  pc,u,x
EXPA45    lbsr  CHKSEG
         puls  pc,u,x
EXPSUB    ldd   <$10,y
         subd  <$14,y
         tfr   d,x
         ldb   $0F,y
         sbcb  <$13,y
         rts
SEGALL    pshs  u,x
         lbsr  SECALL
         bcs   L08FF
         lbsr  GETFD
         bcs   L08FF
         ldu   $08,y
         clra
         clrb
         std   $09,u
         std   $0B,u
         leax  <$10,u
         ldd   $03,x
         beq   L0947
         ldd   $08,y
         inca
         pshs  b,a
         bra   L08EF
L08E2    clrb
         ldd   -$02,x
         beq   L08FB
         addd  $0A,u
         std   $0A,u
         bcc   L08EF
         inc   $09,u
L08EF    leax  $05,x
         cmpx  ,s
         bcs   L08E2
         lbsr  SECDEA
         comb
         ldb   #$D9
L08FB    leas  $02,s
         leax  -$05,x
L08FF    bcs   L0964
         ldd   -$04,x
         addd  -$02,x
         pshs  b,a
         ldb   -$05,x
         adcb  #$00
         cmpb  <$16,y
         puls  b,a
         bne   L0947
         cmpd  <$17,y
         bne   L0947
         ldu   <$1E,y
         ldd   $06,u
         ldu   $08,y
         subd  #$0001
         coma
         comb
         pshs  b,a
         ldd   -$05,x
         eora  <$16,y
         eorb  <$17,y
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         anda  ,s+
         andb  ,s+
         std   -$02,s
         bne   L0947
         ldd   -$02,x
         addd  <$1A,y
         bcs   L0947
         std   -$02,x
         bra   L0956
L0947    ldd   <$16,y
         std   ,x
         lda   <$18,y
         sta   $02,x
         ldd   <$1A,y
         std   $03,x
L0956    ldd   $0A,u
         addd  <$1A,y
         std   $0A,u
         bcc   L0961
         inc   $09,u
L0961    lbsr  PUTFD
L0964    puls  pc,u,x
SECALL    pshs  u,y,x,b,a
         ldb   #$0C
L096A    clr   ,-s
         decb
         bne   L096A
         ldx   <$1E,y
         ldd   $04,x
         std   $04,s
         ldd   $06,x
         std   $02,s
         std   $0A,s
         ldx   $03,y
         ldx   $04,x
         leax  <$12,x
         subd  #$0001
         addb  $0E,x
         adca  #$00
         bra   L098E
L098C    lsra
         rorb
L098E    lsr   $0A,s
         ror   $0B,s
         bcc   L098C
         std   ,s
         ldd   $02,s
         std   $0A,s
         subd  #$0001
         addd  $0C,s
         bcc   L09A8
         ldd   #$FFFF
         bra   L09A8
L09A6    lsra
         rorb
L09A8    lsr   $0A,s
         ror   $0B,s
         bcc   L09A6
         cmpa  #$08
         bcs   L09B5
         ldd   #$0800
L09B5    std   $0C,s
         lbsr  LockBit
         lbcs  L0AA3
         ldx   <$1E,y
         ldd   <$1A,x
         cmpd  $0E,x
         bne   L09D7
         lda   <$1C,x
         cmpa  $04,x
         bne   L09D7
         ldb   <$1D,x
         cmpb  $04,x
         bcs   L09E5
L09D7    ldd   $0E,x
         std   <$1A,x
         lda   $04,x
         sta   <$1C,x
         clrb
         stb   <$1D,x
L09E5    incb
         stb   $06,s
         ldx   <$1E,y
         cmpb  <$1E,x
         beq   L0A21
         lbsr  ReadBit
         lbcs  L0AA3
         ldb   $06,s
         cmpb  $04,s
         bls   L0A02
         clra
         ldb   $05,s
         bra   L0A05
L0A02    ldd   #$0100
L0A05    ldx   $08,y
         leau  d,x
         ldy   $0C,s
         clra
         clrb
         os9   F$SchBit
         bcc   L0A4E
         cmpy  $08,s
         bls   L0A21
         sty   $08,s
         std   $0A,s
         lda   $06,s
         sta   $07,s
L0A21    ldy   <$10,s
         ldb   $06,s
         cmpb  $04,s
         bcs   L0A32
         bhi   L0A31
         tst   $05,s
         bne   L0A32
L0A31    clrb
L0A32    ldx   <$1E,y
         cmpb  <$1D,x
         bne   L09E5
         ldb   $07,s
         beq   L0AA1
         cmpb  $06,s
         beq   L0A47
         stb   $06,s
         lbsr  ReadBit
L0A47    ldx   $08,y
         ldd   $0A,s
         ldy   $08,s
L0A4E    std   $0A,s
         sty   $08,s
         os9   F$AllBit
         ldy   <$10,s
         ldb   $06,s
         lbsr  PUTBIT
         bcs   L0AA3
         ldx   <$1E,y
         lda   $06,s
         deca
         sta   <$1D,x
         clrb
         lsla
         rolb
         lsla
         rolb
         lsla
         rolb
         stb   <$16,y
         ora   $0A,s
         ldb   $0B,s
         ldx   $08,s
         ldy   <$10,s
         std   <$17,y
         stx   <$1A,y
         ldd   $02,s
         bra   L0A97
L0A88    lsl   <$18,y
         rol   <$17,y
         rol   <$16,y
         lsl   <$1B,y
         rol   <$1A,y
L0A97    lsra
         rorb
         bcc   L0A88
         clrb
         ldd   <$1A,y
         bra   L0AAB
L0AA1    ldb   #$F8
L0AA3    ldy   <$10,s
         lbsr  RLSBIT
         coma
L0AAB    leas  $0E,s
         puls  pc,u,y,x
TRIM    clra
         lda   $01,y
         bita  #$80
         bne   L0B11
         ldd   $0F,y
         std   $0B,y
         ldd   <$11,y
         std   $0D,y
         lbsr  GETSEG
         bcc   L0AC8
         cmpb  #$D5
         bra   L0B09
L0AC8    ldd   <$14,y
         subd  $0C,y
         addd  <$1A,y
         tst   $0E,y
         beq   L0AD7
         subd  #$0001
L0AD7    pshs  b,a
         ldu   <$1E,y
         ldd   $06,u
         subd  #$0001
         coma
         comb
         anda  ,s+
         andb  ,s+
         ldu   <$1A,y
         std   <$1A,y
         beq   L0B0B
         tfr   u,d
         subd  <$1A,y
         pshs  x,b,a
         addd  <$17,y
         std   <$17,y
         bcc   L0B01
         inc   <$16,y
L0B01    bsr   SECDEA
         bcc   L0B12
         leas  $04,s
         cmpb  #$DB
L0B09    bne   L0B10
L0B0B    lbsr  GETFD
         bcc   L0B1B
L0B10    coma
L0B11    rts
L0B12    lbsr  GETFD
         bcs   L0B6B
         puls  x,b,a
         std   $03,x
L0B1B    ldu   $08,y
         ldd   <$11,y
         std   $0B,u
         ldd   $0F,y
         std   $09,u
         tfr   x,d
         clrb
         inca
         leax  $05,x
         pshs  x,b,a
         bra   L0B56
L0B30    ldd   -$02,x
         beq   L0B63
         std   <$1A,y
         ldd   -$05,x
         std   <$16,y
         lda   -$03,x
         sta   <$18,y
         bsr   SECDEA
         bcs   L0B6B
         stx   $02,s
         lbsr  GETFD
         bcs   L0B6B
         ldx   $02,s
         clra
         clrb
         std   -$05,x
         sta   -$03,x
         std   -$02,x
L0B56    lbsr  PUTFD
         bcs   L0B6B
         ldx   $02,s
         leax  $05,x
         cmpx  ,s
         bcs   L0B30
L0B63    clra
         clrb
         sta   <$19,y
         std   <$1A,y
L0B6B    leas  $04,s
         rts

SECDEA    pshs  u,y,x,a
         ldx   <$1E,y
         ldd   $06,x
         subd  #$0001
         addd  <$17,y
         std   <$17,y
         ldd   $06,x
         bcc   L0B96
         inc   <$16,y
         bra   L0B96
L0B87    lsr   <$16,y
         ror   <$17,y
         ror   <$18,y
         lsr   <$1A,y
         ror   <$1B,y
L0B96    lsra
         rorb
         bcc   L0B87
         clrb
         ldd   <$1A,y
         beq   L0BD6
         ldd   <$16,y
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         tfr   b,a
         ldb   #$DB
         cmpa  $04,x
         bhi   L0BD5
         inca
         sta   ,s
L0BB4    bsr   LockBit
         bcs   L0BB4
         ldb   ,s
         bsr   ReadBit
         bcs   L0BD5
         ldx   $08,y
         ldd   <$17,y
         anda  #$07
         ldy   <$1A,y
         os9   F$DelBit
         ldy   $03,s
         ldb   ,s
         bsr   PUTBIT
         bcc   L0BD6
L0BD5    coma
L0BD6    puls  pc,u,y,x,a


***************
* Subroutine LockBit
*   LockOut Bitmap, Read first sector

* Passed: (Y)=PD
* Returns: CC,B=set if error
* Destroys: D,X,U

LockBit    lbsr  CLRBUF
         bra   LckBit20

L0BDD    lbsr  L0838
         os9   F$IOQu
         bsr   ChkSignl
LckBit20    bcs   L0BF4
         ldx   <$1E,y
         lda   <$17,x
         bne   L0BDD
         lda   $05,y
         sta   <$17,x
L0BF4    rts

***************
* Subroutine ChkSignal
*   See if signal received caused death

* Returns: CC,B=set if error
* Destroys: D,U

ChkSignl ldu D.Proc
 ldb P$Signal,U
 cmpb #S$Wake Wake-up signal?
         bls   ChkSig10
         cmpb  #$03
         bls   ChkSErr
ChkSig10    clra
         lda   $0D,u
         bita  #$02
         beq   ChkSig90
ChkSErr    coma
ChkSig90    rts

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
RLSBIT    pshs  cc
         ldx   <$1E,y
         lda   $05,y
         cmpa  <$17,x
         bne   L0C31
         clr   <$17,x
         ldx   <$004B
         lda   <$11,x
         beq   L0C31
         lbsr  L0838
         ldx   #1
         os9   F$Sleep
L0C31    puls  pc,cc


 page
***************
* Subroutine ReadBit
*   Read Bitmap sector

* Passed: (B)=sector number
*         (Y)=PD
* Returns: CC=carry set if error
*         (B)=error code
* Destroys: (X)

ReadBit    clra
         tfr   d,x
         clrb
         lbra  GETSEC

***************
* Subroutine WRCP
*   Write Current Position Sector

WRCP pshs U,X save regs
 lbsr PCPSEC Put current sector
         bcs   WRCPXX
         lda   $0A,y
         anda  #$FE
         sta   $0A,y
WRCPXX    puls  pc,u,x

CHKSEG    ldd   $0C,y
         subd  <$14,y
         tfr   d,x
         ldb   $0B,y
         sbcb  <$13,y
         cmpb  <$19,y
         bcs   CHKSG90
         bhi   GETSEG
         cmpx  <$1A,y
         bcc   GETSEG
CHKSG90    clrb
L0C62    rts

***************
* Subroutine GETSEG
*   Get Segment Containing Current Position

* Passed: (Y)=PD ptr
* Returns: CC Carry set if no segment found
* Destroys: D

GETSEG    pshs  u
         bsr   GETFD
         bcs   L0CBF
         clra
         clrb
         std   <$13,y
         stb   <$15,y
         ldu   $08,y
         leax  <$10,u
         lda   $08,y
         ldb   #$FC
         pshs  b,a
FNDS10    ldd   $03,x
         beq   L0CA1
         addd  <$14,y
         tfr   d,u
         ldb   <$13,y
         adcb  #$00
         cmpb  $0B,y
         bhi   L0CAE
         bne   L0C95
         cmpu  $0C,y
         bhi   L0CAE
L0C95    stb   <$13,y
         stu   <$14,y
         leax  $05,x
         cmpx  ,s
         bcs   FNDS10
L0CA1    clra
         clrb
         sta   <$19,y
         std   <$1A,y
         comb
         ldb   #$D5
         bra   L0CBD
L0CAE    ldd   ,x
         std   <$16,y
         lda   $02,x
         sta   <$18,y
         ldd   $03,x
         std   <$1A,y
L0CBD    leas  $02,s
L0CBF    puls  pc,u
 page
***************
* Subroutine GETDD
*   Get Device Desc

GETDD    pshs  x,b
         lbsr  CLRBUF
         bcs   L0CD0
         clrb
         ldx   #$0000
         bsr   GETSEC
         bcc   GETDD20
L0CD0    stb   ,s
GETDD20    puls  pc,x,b

***************
* Subroutine GETFD
*   Get File Descriptor

GETFD    ldb   $0A,y
         bitb  #$04
         bne   CHKSG90
         lbsr  CLRBUF
         bcs   L0C62
         ldb   $0A,y
         orb   #$04
         stb   $0A,y
         ldb   <$34,y
         ldx   <$35,y

***************
* Subroutine GETSEC
*   Get Specified Sector

GETSEC    lda   #$03
* Fall into DEVDIS

***************
* Routine DEVDIS
*   Device Driver Dispatcher

* Passed: (A)=Entry offset
*         (Y)=PD ptr

DEVDIS    pshs  u,y,x,b,a
         lda   $0A,y
         ora   #$20
         sta   $0A,y
         ldu   $03,y
         ldu   $02,u
         bra   L0D01
L0CFB    lbsr  L0838
         os9   F$IOQu
L0D01    lda   $04,u
         bne   L0CFB
         lda   $05,y
         sta   $04,u
         ldd   ,s
         ldx   $02,s
         pshs  u
         bsr   L0D26
         puls  u
         ldy   $04,s
         pshs  cc
         bcc   L0D1C
         stb   $02,s
L0D1C    lda   $0A,y
         anda  #$DF
         sta   $0A,y
         clr   $04,u
         puls  pc,u,y,x,b,a,cc
L0D26    pshs  pc,x,b,a
         ldx   $03,y
         ldd   ,x
         ldx   ,x
         addd  $09,x
         addb  ,s
         adca  #$00
         std   $04,s
         puls  pc,x,b,a

***************
* Subroutine PUTFD
*   Put File Descriptor

PUTFD    ldb   <$34,y
         ldx   <$35,y
         bra   PUTSEC

***************
* Subroutine PCPSEC
*   Put Current Position Sector

PCPSEC    bsr   GETCP
* Fall into PUTSEC

***************
* Subroutine PUTSEC
*   Put Sector

PUTSEC    lda   #$06
         pshs  x,b,a
         ldd   <$1C,y
         beq   L0D51
         ldx   <$1E,y
         cmpd  $0E,x
L0D51    puls  x,b,a
         lbeq  DEVDIS
         comb
         ldb   #$FB
         rts

***************
* Subroutine GETCP
*   Get Addr of Current Position Sector

GETCP    ldd   $0C,y
         subd  <$14,y
         tfr   d,x
         ldb   $0B,y
         sbcb  <$13,y
         exg   d,x
         addd  <$17,y
         exg   d,x
         adcb  <$16,y
         rts

***************
* Subroutine CLRBUF
*   Clear Buffer

CLRBUF clrb clear Carry
 pshs U,X save regs
 ldb PD.SMF,Y get flags
         andb  #$46
 beq CLRB10 ..No
 tfr b,a Copy flag
 eorb PD.SMF,Y Clear sector in buffer
 stb PD.SMF,Y
 andb #BUFMOD Buffer modified?
         beq   CLRB10
         eorb  $0A,y
         stb   $0A,y
         bita  #$02
         beq   CLRB10
         bsr   PCPSEC
CLRB10    puls  pc,u,x

***************
* Subroutine RDCP
*   Read Current Position

RDCP    pshs  u,x
         lbsr  CHKSEG
         bcs   RDCPXX

***************
* Subroutine GCPSEC
*   Get Current Position Sector

         bsr   CLRBUF
         bcs   RDCPXX

 lbsr GETCP get addr of current posn
 lbsr GETSEC get sector off of disk
 bcs RDCPXX error; abort
 lda PD.SMF,Y
         ora   #$42
 sta PD.SMF,Y
RDCPXX puls PC,U,X

         emod
RBFEnd      equ   *
         end

