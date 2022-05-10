         nam   Input/Output Manager
         ttl   Module Header

* This is a disassembly of the IOMan edition 4 distributed with OS-9 for Dragon 64


 mod IOEnd,IOName,SYSTM+OBJCT,REENT+1,IOINIT,0
IOName  fcs /IOMan/  module name

******************************************
*
*     Edition History
*
* Edition   Date    Comments
*
*    1   pre-82/08  beginning of history               LAC
*
*    2    82/08/24  modifications for MC6829           LAC
*
*    3    82/09/27  conditionals added for LI & LII    WGP
*
*    4    82/10/21  I$DeletX system call added         WGP
*
 fcb 4  edition number

 use   defsfile

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
IOINI1    clr   ,x+
         subd  #$0001
         bhi   IOINI1
         stu   D.PolTbl
         ldd   ,s++
         leax  d,u
         stx   D.DevTbl
         ldx   D.PthDBT
         os9   F$All64
         bcs   Crash
         stx   D.PthDBT
         os9   F$Ret64
         leax  >IOIRQ,pcr
         stx   <D.Poll
* install I/O system calls
         leay  <SVCTBL,pcr
         os9   F$SSvc
         rts                           return to OS9p2

Crash    jmp   [>$FFFE]

SVCTBL  fcb   $7F
         fdb   UsrIO-*-2

         fcb   F$Load
         fdb   Load-*-2

         fcb   F$PErr
         fdb   FPErr-*-2

         fcb   F$IOQu+$80
         fdb   IOQueu-*-2

         fcb   $FF
         fdb   SysIO-*-2

         fcb   F$IRQ+$80
         fdb   IOPOLL-*-2

         fcb   F$IODel+$80
         fdb   IODEL-*-2

         fcb   $80

IODEL   ldx   R$X,u
         pshs  u,y,x
 ldu D.Init From configuration module
 ldb DevCnt,u Get device table size
         pshs  b
         ldu   D.DevTbl
L007C    lbsr  L00FB
         bcs   L008C
         tst   $08,u
         lbne  L00F6
         leau  $09,u
         decb
         bne   L007C
L008C    ldu   D.DevTbl
         ldb   ,s
L0090    lbsr  L00FB
         lbcs  L00F3
         tst   $08,u
         lbne  L00EA
         pshs  u,b
         ldx   $02,u
         clr   $02,u
         clr   $03,u
         ldu   D.DevTbl
         ldb   $03,s
L00A9    cmpx  $02,u
         beq   L00DD
         leau  $09,u
         decb
         bne   L00A9
         ldu   $01,s
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
         addd  #$00FF                  round up to next page
         clrb
         os9   F$SRtMem                return mem
         ldx   $01,s
         ldx   $04,x
L00DD    ldu   $01,s
         clr   $04,u
         clr   $05,u
         clr   $08,u
         lbsr  UnQueue
         puls  u,b
L00EA    ldx   $01,s
         leau  $09,u
         decb
         lbne  L0090
L00F3    clra
         puls  pc,u,y,x,a

L00F6    comb
         ldb   #E$ModBsy
         puls  pc,u,y,x,a

L00FB    cmpx  $04,u
         beq   L010D
         cmpx  ,u
         beq   L010D
         cmpx  $06,u
         beq   L010D
         leau  $09,u
         decb
         bne   L00FB
         comb
L010D    rts

UTABLE equ *
TBLBGN set UTABLE
 fdb   ATTACH-TBLBGN
         fdb   DETACH-TBLBGN
         fdb   UDUPE-TBLBGN
         fdb   UCREAT-TBLBGN
         fdb   UOPEN-TBLBGN
         fdb   UMDIR-TBLBGN
         fdb   UCDIR-TBLBGN
         fdb   SDELET-TBLBGN
         fdb   USEEK-TBLBGN
         fdb   UIRead-TBLBGN
         fdb   UWRLN-TBLBGN
         fdb   UIRead-TBLBGN
         fdb   UWRLN-TBLBGN
         fdb   UGSTT-TBLBGN
         fdb   USEEK-TBLBGN
         fdb   UCLOSE-TBLBGN
         fdb   IDeletX-TBLBGN

STABLE equ *
TBLBGN set STABLE
 fdb   ATTACH-TBLBGN
         fdb   DETACH-TBLBGN
         fdb   SDUPE-TBLBGN
         fdb   ISysCall-TBLBGN
         fdb   ISysCall-TBLBGN
         fdb   SMDIR-TBLBGN
         fdb   SCDIR-TBLBGN
         fdb   SDELET-TBLBGN
         fdb   SSEEK-TBLBGN
         fdb   SRDLN-TBLBGN
         fdb   SWRLN-TBLBGN
         fdb   SRDLN-TBLBGN
         fdb   SWRLN-TBLBGN
         fdb   SGSTT-TBLBGN
         fdb   SSEEK-TBLBGN
         fdb   SCLOSE-TBLBGN
         fdb   IDeletX-TBLBGN

UsrIO    leax  <UTABLE,pcr
         bra   SYSIO1
SysIO    leax  <STABLE,pcr
SYSIO1 cmpb  #I$DeletX
         bhi   SYSIO2
         pshs  b
         lslb                          multiply by 2
         ldd   b,x                     offset
         leax  d,x                     get addr
         puls  b
         jmp   ,x

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

ATTACH  ldb   #$11
ATTA02    clr   ,-s
         decb
         bpl   ATTA02
         stu   <$10,s
         lda   $01,u
         sta   $09,s
         ldx   $04,u
         lda   #Devic+0
         os9   F$Link
         bcs   ATTERR
         stu   $04,s
         ldy   <$10,s
         stx   $04,y
         ldd   $0F,u
         std   $0C,s
         ldd   $0B,u
         leax  d,u
         lda   #Drivr+0
         os9   F$Link
         bcs   ATTERR
         stu   ,s
         ldu   $04,s
         ldd   $09,u
         leax  d,u
         lda   #FlMgr+0
         os9   F$Link
         bcc   ATTA15

ATTERR stb S.TMPS-1,S Save error code
 leau 0,S Addr og psuedo device tbl entry
 os9 I$Detach ..detach device
 leas S.TMPS-1,s
 comb
 puls pc,b Return error

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
         lbne  ATTA70
         ldu   D.DevTbl
ATTA35    ldx   $04,u
         beq   ATTA40
         leau  $09,u
         deca
         bne   ATTA35
         ldb   #E$DevOvf               device table overflow
         bra   ATTERR
ERMODE    ldb   #E$BMode                bad mode
         bra   ATTERR

ERBUSY    ldb   #E$DevBsy
         bra   ATTERR

ATTA40    ldx   $02,s
         lbne  ATTA60

         stu   $0E,s
         ldx   ,s
         ldd   $0B,x
         addd  #$00FF                  round up to next page
         clrb
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
         tst   $0A,s
         beq   ATTA90
         andb  $07,x
         bitb  #$80
         lbeq  ERBUSY
ATTA90


 inc V$USRS,u Update user count
 ldx S.STAK,S
 stu R$U,x Return device tbl ptr
 leas S.TMPS,S
 clrb RETURN Carry clear
 rts
 page

DETACH  ldu   R$U,u
         dec   $08,u
         ldx   $06,u
         ldy   ,u
         ldu   $04,u
         os9   F$UnLink
         leau  ,y
         os9   F$UnLink
         leau  ,x
         os9   F$UnLink                unlink descriptor
         clrb
         rts

* user state I$Dup
UDUPE     bsr   FNDPTH
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
FNDPTH ldx   D.Proc
         leax  <$26,x
         clra
L02C4    tst   a,x
         beq   L02D1
         inca
         cmpa  #$10
         bcs   L02C4
         comb
         ldb   #$C8
         rts
L02D1    andcc #^Carry
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
         bcs   L02E6
         pshs  u,x,a
         bsr   ISysCall
         puls  u,x,a
         bcs   L02E6
         ldb   $01,u
         stb   a,x
         sta   $01,u
L02E6    rts

ISysCall pshs  b
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
SMDIR pshs B Save function code
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
SCDIR pshs B Save function code
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
         beq   L0341
         ldx   <$1A,u
         beq   L033A
         dec   $08,x
L033A    ldx   $03,y
         stx   <$1A,u
         inc   $08,x
L0341    bitb  #$24
         beq   SCDIR5
         ldx   <$20,u
         beq   L034C
         dec   $08,x
L034C    ldx   $03,y
         stx   <$20,u
         inc   $08,x
SCDIR5    clrb
         bra   SMDIR2

**********
* Delet
*   Process Delete Request
*
UDELET equ *
SDELET pshs B Save function code
         ldb   #$02
         bra   SMDIR1

IDeletX  ldb   #$87
         pshs  b
         ldb   $01,u
         bra   SMDIR1

* create path descriptor and initialize
* Entry:
*   B  = path mode
PDINIT
    pshs  u
         ldx   <D.PthDBT
         os9   F$All64
         bcs   PDIN90
         inc   $02,y
         stb   $01,y
         ldx   $04,u
PDIN10    lda   ,x+
 cmpa #$20 Skip spaces
 beq PDIN10
 leax -1,x Back up to non-space character
 stx R$X,u Save updated pathname ptr
 ldb PD.MOD,y get mode
 cmpa #PDELIM Path delimiter?
         beq   PDIN40
         ldx   D.Proc
         bitb  #$24
         beq   L038E
         ldx   <$20,x
         bra   L0391
L038E    ldx   <$1A,x
L0391    beq   ERRBPN
         ldx   $04,x
         ldd   $04,x
         leax  d,x
PDIN40    pshs  y
         os9   F$PrsNam
         puls  y
         bcs   ERRBPN
         lda   $01,y
         os9   I$Attach
         stu   $03,y
         bcs   L03C7
         ldx   $04,u
         leax  <$11,x
         ldb   ,x+
         leau  <$20,y
         cmpb  #$20
         bls   L03BF
         ldb   #$1F
L03BB    lda   ,x+
         sta   ,u+
L03BF    decb
         bpl   L03BB
         clrb
PDIN90
    puls  pc,u

ERRBPN    ldb   #$D7
L03C7    pshs  b
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
* Destroys: None
* Error: (B)=Error Code, CC=Set
*
CHKPTH lda R$A,u Get caller's path number
         cmpa  #$10
         bcc   L03E6
         ldx   D.Proc
         leax  <$26,x
         andcc #^Carry
         lda   a,x
         bne   L03E9
L03E6    comb
         ldb   #E$BPNum
L03E9    rts

USEEK   bsr   CHKPTH
         bcc   SSEEK1
         rts

SSEEK   lda   $01,u
SSEEK1  bsr   FPATH
         lbcc  FMEXEC
         rts

UIRead   bsr   CHKPTH
         bcc   SRDLN1
         rts

SREAD equ *
SRDLN lda R$A,u Get (system) path#
SRDLN1 pshs B Save function code
 ldb #READ.+EXEC.
SRDLN2 bsr FPATH Find (y)=path descriptor
 bcs SRDLNX ..return error if any
 bitb PD.MOD,y Legal i/o on this path?
 beq BADPTH ..no; error - bad path number

 puls B Restore function code
 lbra FMEXEC ..execute file mgr's function

BADPTH    ldb   #$D7
SRDLNX    com   ,s+
         rts

UWRITE equ *
UWRLN  bsr   CHKPTH
         bcc   L041C
         rts

SWRITE equ *
SWRLN  lda   $01,u
L041C    pshs  b
         ldb   #$02
         bra   SRDLN2


* find path descriptor of path passed in A
* Exit:
*   Y  = addr of path desc (if no error)
FPATH pshs  x
         ldx   D.PthDBT
         os9   F$Find64
         puls  x
         bcs   L03E6
FPATH9    rts

UGSTT bsr   CHKPTH
         bcc   SGSTT10
         rts

SGSTT lda   $01,u
SGSTT10    pshs  b,a
         lda   $02,u
         sta   $01,s
         puls  a
         bsr   SSEEK1
         puls  a
         pshs  cc
         tsta  Is a SS.OPT?
         beq   L044C ..yes
         cmpa  #SS.DevNm
         beq   L045E
         puls  pc,cc

* Return 32 byte option section of path descriptor
* Y contains the path descriptor
L044C    leax  <32,y
L044F    ldy   R$X,u
         ldb   #32
L0454    lda   ,x+
         sta   ,y+
         decb
         bne   L0454
         leas  $01,s
         rts

* Return device name
L045E    ldx   PD.DEV,y
         ldx   V$DESC,x
         ldd   M$Name,x
         leax  d,x
         bra   L044F


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

SCLOSE  lda   $01,u
SCLOS1    bsr   FPATH
         bcs   FPATH9
         dec   $02,y
         tst   $05,y
         bne   L0485
         bsr   FMEXEC
L0485    tst   $02,y
         bne   FPATH9
         lbra  SMDIR2

GainP.zz    os9   F$IOQu
         comb
         ldb   <$36,x
         bne   GainP.9
GainPath    ldx   D.Proc
         ldb   ,x
         clra
         lda   $05,y
         bne   GainP.zz
         stb   $05,y
GainP.9    rts

* B = entry point into FMgr
* Y = path desc
FMEXEC pshs  u,y,x,b
         bsr   GainPath
         bcc   FMEX20
         leas  $01,s
         bra   FMEX30

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
FMEX30    pshs  b,cc
         bsr   UnQueue
         ldy   $04,s
         ldx   D.Proc
         lda   ,x
         cmpa  $05,y
         bne   FMEX90
         clr   $05,y
FMEX90    puls  pc,u,y,x,b,cc

UnQueue    pshs  y,x
         ldy   D.Proc
         bra   UnQue80
UnQue10    clr   <$11,y
         ldb   #$01
         os9   F$Send
         ldx   D.PrcDBT
         os9   F$Find64
         clr   <$10,y
UnQue80    lda   <$11,y
         bne   UnQue10
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
IOPOLL     ldx   $04,u
         ldb   ,x                      B = flip byte
         ldx   $01,x
         clra
         pshs  cc
         pshs  x,b
         ldx   D.Init
         ldb   $0C,x
         ldx   D.PolTbl
         ldy   $04,u
         beq   IOPOL4
         tst   $01,s
         beq   L056B
         decb
         lda   #$09
         mul
         leax  d,x
         lda   $03,x
         bne   L056B
         orcc  #$50
L0515    ldb   $02,s
         cmpb  -$01,x
         bcs   L0528
         ldb   #$09
L051D    lda   ,-x
         sta   $09,x
         decb
         bne   L051D
         cmpx  D.PolTbl
         bhi   L0515
L0528    ldd   $01,u
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
         beq   L0551
         leax  $09,x
         decb
         bne   IOPOL5
         clrb
         rts
L0551    pshs  b,cc
         orcc  #$50
         bra   L055E
L0557    ldb   $09,x
         stb   ,x+
         deca
         bne   L0557
L055E    lda   #$09
         dec   $01,s
         bne   L0557
L0564    clr   ,x+
         deca
         bne   L0564
         puls  pc,a,cc
L056B    leas  $04,s
L056D    comb
         ldb   #$CA
         rts

* IRQ polling routine
IOIRQ    ldy   D.PolTbl
         ldx   D.Init
         ldb   $0C,x
         bra   L057F
L057A    leay  $09,y
         decb
         beq   L056D
L057F    lda   [,y]
         eora  $02,y
         bita  $03,y
         beq   L057A
         ldu   $06,y
         pshs  y,b
         jsr   [<$04,y]
         puls  y,b
         bcs   L057A
         rts

* load a module
Load    pshs  u
         ldx   $04,u
         bsr   L05B5
         bcs   LoadXit
         inc   $02,u
         ldy   ,u
         ldu   ,s
         stx   $04,u
         sty   $08,u
         lda   $06,y
         ldb   $07,y
         std   $01,u
         ldd   $09,y
         leax  d,y
         stx   $06,u
LoadXit    puls  pc,u

L05B5    lda   #EXEC.
         os9   I$Open
         bcs   L062B
         leas  -$0A,s
         ldu   #$0000
         pshs  u,y,x
         sta   $06,s
L05C5    ldd   $04,s
         bne   L05CB
         stu   $04,s
L05CB    lda   $06,s
         leax  $07,s
         ldy   #M$IDSize
         os9   I$Read
         bcs   L0617
         ldd   M$ID,x
         cmpd  #$87CD
         bne   L0615
         ldd   9,s
         os9   F$SRqMem
         bcs   L0617
         ldb   #M$IDSize
L05E9    lda   ,x+
         sta   ,u+
         decb
         bne   L05E9
         lda   $06,s
         leax  ,u
         ldu   9,s
         leay  -M$IDSize,u
         os9   I$Read
         leax  -M$IDSize,x
         bcs   L0604
         os9   F$VModul
         bcc   L05C5
L0604    pshs  u,b
         leau  ,x
         ldd   M$Size,x
         os9   F$SRtMem
         puls  u,b
         cmpb  #E$KwnMod
         beq   L05C5
         bra   L0617
L0615    ldb   #E$BMID
L0617    puls  u,y,x
         lda   ,s
         stb   ,s
         os9   I$Close
         ldb   ,s
         leas  $0A,s
         cmpu  #$0000
         bne   L062B
         coma
L062B    rts

ErrHead  fcc   /ERROR #/
ErrNum   equ   *-ErrHead
         fcb   $2F,$3A,$30,$0D
ErrLen   equ   *-ErrHead

FPErr    ldx   D.Proc
         lda   <P$PATH+2,x Get standard error path
         beq   L066D ..not open
         leas  -$0B,s
         leax  <ErrHead,pcr
         leay  ,s
L0645    lda   ,x+
         sta   ,y+
         cmpa  #$0D
         bne   L0645
         ldb   $02,u
L064F    inc   $07,s
         subb  #$64
         bcc   L064F
L0655    dec   $08,s
         addb  #$0A
         bcc   L0655
         addb  #$30
         stb   $09,s
         ldx   D.Proc
         leax  ,s
         ldu   D.Proc
         lda   <P$PATH+2,u Get standard error path
         os9   I$WritLn
         leas  $0B,s
L066D    rts

*****
*
*  Subroutine Ioqueu
*
* Link Process Into Ioqueue And Go To Sleep
*
IOQueu    ldy   D.Proc
IOQ.A    lda   <P$IOQN,y
         beq   IOQ.C
         cmpa  R$A,u
         bne   IOQ.B
         clr   <P$IOQN,y
         ldx   D.PrcDBT
         os9   F$Find64
         bcs   IOQuExit
         clr   <P$IOQP,y
         ldb   #S$Wake
         os9   F$Send
         bra   IOQ.E
IOQ.B
 ldx D.PrcDBT
 os9 F$Find64
 bcc IOQ.A branch if found
IOQ.C    lda   R$A,u
IOQ.D
 ldx D.PrcDBT
 os9 F$Find64
         bcs   IOQuExit
IOQ.E    lda   <P$IOQN,y
         bne   IOQ.D
         ldx   D.Proc
         lda   ,x
         sta   <P$IOQN,y
         lda   ,y
         sta   <P$IOQP,x
         ldx   #$0000
         os9   F$Sleep
         ldu   D.Proc
         lda   <P$IOQP,u
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
