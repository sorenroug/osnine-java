         nam   IOMan
         ttl   os9 system module


tylg     set   Systm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   IOEnd,IOName,tylg,atrv,IOINIT,0

IOName     equ   *
         fcs   /IOMan/
         fcb   $09
 use defsfile

IOINIT    equ   *
         ldx   D.Init
         lda   $0C,x
         ldb   #$09
         mul
         pshs  b,a
         lda   $0D,x
         ldb   #$09
         mul
         addd  ,s
         addd  #$00FF
         clrb
         os9   F$SRqMem
         bcs   CRASH
         leax  ,u
L002E    clr   ,x+
         subd  #$0001
         bhi   L002E
         stu   D.PolTbl
         ldd   ,s++
         leax  d,u
         stx   D.DevTbl
         ldx   D.PthDBT
         os9   F$All64
         bcs   CRASH
         stx   D.PthDBT
         os9   F$Ret64
         leax  >IOIRQ,pcr
         stx   D.Poll
         leay  <SVCTBL,pcr
         os9   F$SSvc
         rts
CRASH    jmp   [>$FFFE]
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
         ldu   D.Init
         ldb   $0D,u
         ldu   D.DevTbl
IODEL10    ldy   $04,u
         beq   IODEL20
         cmpx  $04,u
         beq   IODELErr
         cmpx  ,u
         beq   IODELErr
         cmpx  $06,u
         beq   IODELErr
IODEL20    leau  $09,u
         decb
         bne   IODEL10
         clrb
         rts

IODELErr    comb
         ldb   #$D1
         rts

PortBlk    lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         anda  #$01
         cmpd  #$0140
         rts

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

USERIO         leax  <UTABLE,pcr
         bra   L00F0
SysIO         leax  <STABLE,pcr
L00F0    cmpb  #$90
         bhi   SYSIO2
         pshs  b
         lslb
         ldd   b,x
         leax  d,x
         puls  b
         jmp   ,x

SYSIO2    comb
         ldb   #$D0
         rts

ATTACH         ldb   #$17
L0105    clr   ,-s
         decb
         bpl   L0105
         stu   <$16,s
         lda   $01,u
         sta   $09,s
         ldx   D.Proc
         stx   <$14,s
         leay  <$40,x
         ldx   D.SysPRC
         stx   D.Proc
         ldx   $04,u
         lda   #$F0
         os9   F$SLink
         bcs   ATTERR0
         stu   $04,s
         ldy   <$16,s
         stx   $04,y
         lda   $0E,u
         sta   $0B,s
         ldd   $0F,u
         std   $0C,s
         ldd   $0B,u
         leax  d,u
         lda   #$E0
         os9   F$Link
         bcs   ATTERR0
         stu   ,s
         ldu   $04,s
         ldd   $09,u
         leax  d,u
         lda   #$D0
         os9   F$Link
ATTERR0    ldx   <$14,s
         stx   D.Proc
         bcc   ATTA15
ATTERR    stb   <$17,s
         leau  ,s
         os9   I$Detach
         leas  <$17,s
         comb
         puls  pc,b

ATTA15    stu   $06,s
         ldx   D.Init
         ldb   $0D,x
         lda   $0D,x
         ldu   D.DevTbl
L016D    ldx   $04,u
         beq   ATTA30
         cmpx  $04,s
         bne   L0188
         ldx   $02,u
         bne   L0186
         pshs  a
         lda   $08,u
         beq   L0182
         os9   F$IOQu
L0182    puls  a
         bra   L016D

L0186    stu   $0E,s
L0188    ldx   $04,u
         ldy   $0F,x
         cmpy  $0C,s
         bne   ATTA30
         ldy   $0E,x
         cmpy  $0B,s
         bne   ATTA30
         ldx   ,u
         cmpx  ,s
         bne   ATTA30
         ldx   $02,u
         stx   $02,s
         tst   $08,u
         beq   ATTA30
         sta   $0A,s
ATTA30    leau  $09,u
         decb
         bne   L016D
         ldu   $0E,s
         lbne  ATTA70

         ldu   D.DevTbl
L01B7    ldx   $04,u
         beq   L01C8
         leau  $09,u
         deca
         bne   L01B7

         ldb   #$CC
         bra   ATTERR

ERMODE    ldb   #$CB
         bra   ATTERR

L01C8    ldx   $02,s
         lbne  ATTA60
         stu   $0E,s
         ldx   ,s
         ldd   $0B,x
         addd  #$00FF
         clrb
         os9   F$SRqMem
         lbcs  ATTERR
         stu   $02,s
ATTA57    clr   ,u+
         subd  #$0001
         bhi   ATTA57

         ldd   $0B,s
         lbsr  PortBlk
         std   <$12,s
         ldu   #$0000
         tfr   u,y
         stu   <$10,s
         ldx   D.SysDAT
IOMap20    ldd   ,x++
         anda  #$01
         cmpd  <$12,s
         beq   L0236
         cmpd  #$015F
         bne   L0210
         sty   <$10,s
         leau  -$02,x
L0210    leay  >$0800,y
         bne   IOMap20
         ldb   #$CF
         cmpu  #$0000
         lbeq  ATTERR
         ldd   <$12,s
         ora   #$02
         std   ,u
         ldx   D.SysPRC
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         os9   F$ID
         ldy   <$10,s

L0236    sty   <$10,s
         ldd   $0C,s
         anda  #$07
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
L0258    lda   b,s
         sta   b,u
         decb
         bpl   L0258
ATTA70    ldx   $04,u
         ldb   $07,x
         lda   $09,s
         anda  $0D,x
         ldx   ,u
         anda  $0D,x
         cmpa  $09,s
         lbne  ERMODE
         inc   $08,u
         bne   L0277
         dec   $08,u
L0277    ldx   <$16,s
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
         ldx   $04,u
         lda   #$FF
         cmpa  $08,u
         lbeq  DETACH90
         dec   $08,u
         lbne  DETACH80
         ldx   D.Init
         ldb   $0D,x
         pshs  u,b
         ldx   $02,u
         clr   $02,u
         clr   $03,u
         ldy   D.DevTbl
L02A2    cmpx  $02,y
         beq   DETACH20
         leay  $09,y
         decb
         bne   L02A2
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
L02E5    cmpu  $04,s
         beq   UnMap20
         ldx   $04,u
         beq   UnMap20
         ldd   $0E,x
         beq   UnMap20
         lbsr  PortBlk
         cmpd  $01,s
         beq   L0322
UnMap20    leau  $09,u
         dec   ,s
         bne   L02E5
 ldx D.SysPRC Systen process ptr
 ldu D.SysDAT system DAT image ptr
         ldy   #$0020
L0308    ldd   ,u++
         anda  #$01
         cmpd  $01,s
         beq   L0317
         leay  -$01,y
         bne   L0308
         bra   L0322
L0317    ldd   #$015F
         std   -$02,u
         lda   $0C,x
         ora   #$10
         sta   $0C,x
L0322    leas  $03,s
DETACH20    puls  u,b
         ldx   $04,u
         clr   $04,u
         clr   $05,u
         clr   $08,u

DETACH80
    ldd   D.Proc
         pshs  b,a
         ldd   D.SysPRC
         std   D.Proc
         ldy   ,u
         ldu   $06,u
         os9   F$UnLink
         leau  ,y
         os9   F$UnLink
         leau  ,x
         os9   F$UnLink
         puls  b,a
         std   D.Proc
DETACH90    lbsr  UnQueue
         clrb
         rts

**********
* Dupe
*   Process Path Duplication Request
*
UDUPE bsr FNDPTH Find available path
         bcs   SDUP90
         pshs  x,a
         lda   $01,u
         lda   a,x
         bsr   L036A
         bcs   SDUPER
         puls  x,b
         stb   $01,u
         sta   b,x
         rts
SDUPER    puls  pc,x,a

SDUPE lda R$A,u Get path number
L036A    lbsr  FPATH
         bcs   SDUP90
         inc   $02,y
SDUP90    rts

FNDPTH    ldx   D.Proc
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
UOPEN bsr FNDPTH Find available local path#
         bcs   L039A
         pshs  u,x,a
         bsr   SOPEN
         puls  u,x,a
         bcs   L039A
         ldb   $01,u
         stb   a,x
         sta   $01,u
L039A    rts

SCREAT equ *
SOPEN pshs B Save function code
         ldb   $01,u
         bsr   PDINIT
         bcs   L03AF
         puls  b
         lbsr  FMEXEC
         bcs   SMDIR2
         lda   ,y
         sta   $01,u
         rts

L03AF    puls  pc,a

**********
* Makdir
*   Process Makdir Request
*
UMDIR equ *
SMDIR pshs B Save function code
         ldb   #$82
SMDIR1    bsr   PDINIT
         bcs   L03AF
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
         bcs   L03AF
         puls  b
         lbsr  FMEXEC
         bcs   SMDIR2

         ldu   D.Proc
         ldb   $01,y
         bitb  #$1B
         beq   L03F2
         ldx   $03,y
         stx   <$20,u
         inc   $08,x
         bne   L03F2
         dec   $08,x

L03F2    bitb  #$24
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
SDELET pshs B Save function code
         ldb   #$02
         bra   SMDIR1


**********
* DeletX
*  delete from specified directory
*
UDELETX equ *
SDELETX ldb #I$Delete make a delete call
         pshs  b
         ldb   $01,u
         bra   SMDIR1

PDINIT    ldx   D.Proc
         pshs  u,x
         ldx   D.PthDBT
         os9   F$All64
         bcs   PDIN90
         inc   $02,y
         stb   $01,y
         ldx   D.Proc
         ldb   $06,x
         ldx   $04,u
L0427    os9   F$LDABX
         leax  $01,x
         cmpa  #$20
         beq   L0427
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
L0448    beq   ERRBPN
         ldd   D.SysPRC
         std   D.Proc
         ldx   $04,x
         ldd   $04,x
         leax  d,x
L0454    pshs  y
         os9   F$PrsNam
         puls  y
         bcs   ERRBPN
         lda   $01,y
         os9   I$Attach
         stu   $03,y
         bcs   PDIN.ERR
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

ERRBPN    ldb   #$D7
PDIN.ERR    pshs  b
         lda   ,y
         ldx   D.PthDBT
         os9   F$Ret64
         puls  b
         coma
         bra   PDIN90

CHKPTH    lda   $01,u
         cmpa  #$10
         bcc   CHKERR
         ldx   D.Proc
         leax  <$30,x
         andcc #$FE
         lda   a,x
         bne   L04A7
CHKERR    comb
         ldb   #$C9
L04A7    rts



**********
* Seek
*   Position File
*
USEEK bsr CHKPTH Validate path number
         bcc   SSEEK1
         rts

SSEEK lda R$A,u Get (system) path#
SSEEK1    bsr   FPATH
         lbcc  FMEXEC
         rts


**********
* Read
* Process Read Or Readln Request
*
UREAD equ *
URDLN bsr   CHKPTH Validate path number
         bcc   L04BD
         rts

SREAD equ *
SRDLN lda R$A,u Get (system) path#
L04BD    pshs  b
         ldb   #$05
L04C1    bsr   FPATH
         bcs   SRDLNX
         bitb  $01,y
         beq   BADPTH
         ldd   $06,u
         beq   L04F7
         addd  $04,u
         bcs   BADBUF
         subd  #$0001
         lsra
         lsra
         lsra
         ldb   $04,u
         lsrb
         lsrb
         lsrb
         pshs  b
         suba  ,s+
         ldx   D.Proc
         leax  <$40,x
         lslb
         leax  b,x
L04E8    pshs  a
         ldd   ,x++
         cmpd  #$015F
         puls  a
         beq   BADBUF
         deca
         bpl   L04E8
L04F7    puls  b
         lbra  FMEXEC
BADBUF    ldb   #$F4
         lda   ,s
         bita  #$02
         beq   SRDLNX
         ldb   #$F5
         bra   SRDLNX
BADPTH    ldb   #$D7
SRDLNX    com   ,s+
         rts

**********
* Write
*   Process Write or Writeln Request
*
UWRITE equ *
UWRLN bsr CHKPTH Validate path number
         bcc   L0514
         rts

SWRITE equ *
SWRLN lda R$A,U Get (system) path#
L0514    pshs  b
         ldb   #$02
         bra   L04C1

FPATH    pshs  x
         ldx   D.PthDBT
         os9   F$Find64
         puls  x
         lbcs  CHKERR
FPATH9    rts

**********
* Gstt
*   Process Getstat Request
*
UGSTT lbsr CHKPTH Validate path number
         ldx   D.Proc
         bcc   L0534
         rts

SGSTT lda R$A,U Get system path#

         ldx   D.SysPRC
L0534    pshs  x,b,a
         lda   $02,u
         sta   $01,s
         puls  a
         lbsr  SSEEK1
         puls  x,a
         pshs  u,y,cc
         tsta
         beq   L054C
         cmpa  #$0E
         beq   L0560
         puls  pc,u,y,cc

L054C    lda   D.SysTsk
         ldb   $06,x
         leax  <$20,y
L0553    ldy   #$0020
         ldu   $04,u
         os9   F$Move
         leas  $01,s
         puls  pc,u,y

L0560    lda   D.SysTsk
         ldb   $06,x
         pshs  b,a
         ldx   $03,y
         ldx   $04,x
         ldd   $04,x
         leax  d,x
         puls  b,a
         bra   L0553


***********
* PSTT
USSTT equ USEEK
SSSTT equ SSEEK

**********
* Close
*   Process Close Request
*
UCLOSE lbsr CHKPTH Validate path number
         bcs   FPATH9
         pshs  b
         ldb   $01,u
         clr   b,x
         puls  b
         bra   L0583

SCLOSE lda R$A,u
L0583    bsr   FPATH
         bcs   FPATH9
         dec   $02,y
         tst   $05,y
         bne   L058F
         bsr   FMEXEC
L058F    tst   $02,y
         bne   FPATH9
         lbra  SMDIR2

GainP.zz    os9   F$IOQu
         comb
         ldb   <$19,x
         bne   L05AA
GainPath    ldx   D.Proc
         ldb   ,x
         clra
         lda   $05,y
         bne   GainP.zz
         stb   $05,y
L05AA    rts

FMEXEC    pshs  u,y,x,b
         bsr   GainPath
         bcc   L05B5
         leas  $01,s
         bra   L05C8
L05B5    stu   $06,y
         ldx   $03,y
         ldx   $06,x
         ldd   $09,x
         leax  d,x
         ldb   ,s+
         subb  #$83
         lda   #$03
         mul
         jsr   d,x
L05C8    pshs  b,cc
         bsr   UnQueue
         ldy   $04,s
         ldx   D.Proc
         lda   ,x
         cmpa  $05,y
         bne   L05D9
         clr   $05,y
L05D9    puls  pc,u,y,x,b,cc

UnQueue    pshs  y,x
         ldy   D.Proc
         bra   UnQue80

UnQue10    clr   <$10,y
         ldb   #$01
         os9   F$Send

         os9   F$GProcP
         clr   $0F,y
UnQue80    lda   <$10,y
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
IOPOLL ldx R$X,u Get ptr to flip,mask,priority
         ldb   ,x
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
         beq   POLFUL
         decb
         lda   #$09
         mul
         leax  d,x
         lda   $03,x
         bne   POLFUL
         orcc  #$50
L061C    ldb   $02,s
         cmpb  -$01,x
         bcs   L062F
         ldb   #$09
L0624    lda   ,-x
         sta   $09,x
         decb
         bne   L0624
         cmpx  D.PolTbl
         bhi   L061C
L062F    ldd   $01,u
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
L064C    cmpy  $06,x
         beq   L0658
         leax  $09,x
         decb
         bne   L064C
         clrb
         rts

L0658    pshs  b,cc
         orcc  #$50
         bra   L0665
L065E    ldb   $09,x
         stb   ,x+
         deca
         bne   L065E
L0665    lda   #$09
         dec   $01,s
         bne   L065E
L066B    clr   ,x+
         deca
         bne   L066B
         puls  pc,a,cc

POLFUL    leas  $04,s
POLLERR    comb
         ldb   #$CA
         rts

IOIRQ    ldy   D.PolTbl
         ldx   D.Init
         ldb   $0C,x
         bra   L0686
L0681    leay  $09,y
         decb
         beq   POLLERR
L0686    lda   [,y]
         eora  $02,y
         bita  $03,y
         beq   L0681
         ldu   $06,y
         pshs  y,b
         jsr   [<$04,y]
         puls  y,b
         bcs   L0681
         rts
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
         ldx   $04,u
         bsr   LModule
         bcs   L06DF
         puls  y
         ldd   D.Proc
         pshs  y,b,a
         ldd   $08,y
         std   D.Proc
         bsr   Load.A
         puls  x
         stx   D.Proc
L06DF    puls  pc,u


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
         ldb   ,s
         beq   LMod.Q
 lsrb make block count
 lsrb
 ifge DAT.BlSz-2048
 lsrb
 ifge DAT.BlSz-4096
 lsrb
 endc
 endc
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
         subd  #1
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
GetModul    pshs  y,x,b,a
         addd  $02,s
         std   $04,s
         cmpd  $08,s
         bls   L085F
         addd  #$07FF
         lsra
         lsra
         lsra
         cmpa  #$1F
         bhi   GetM.Err
         ldb   $08,s
         lsrb
         lsrb
         lsrb
         pshs  b
         exg   b,a
         subb  ,s+
         lsla
         ldu   <$1D,s
         leau  <$40,u
         leau  a,u
         clra
         tfr   d,x
         ldy   D.BlkMap
         clra
         clrb
GetM.B    tst   ,y+
         beq   GetM.D
GetM.C    addd  #$0001
         cmpy  D.BlkMap+2
         bne   GetM.B
GetM.Err    comb
         ldb   #$CF
         bra   GetM.X

GetM.D    inc   -$01,y
         std   ,u++
         pshs  b,a
         ldd   $0A,s
         addd  #$0800
         std   $0A,s
         puls  b,a
         leax  -$01,x
         bne   GetM.C
         ldx   <$1D,s
         os9   F$SetTsk
         bcs   GetM.X
L085F    lda   $0E,s
         ldx   $02,s
         ldy   ,s
         os9   I$Read
GetM.X    leas  $04,s
         puls  pc,x

********************************
*
* F$PErr System call entry point
*
* Entry: U = Register stack pointer
*

ErrMsg1  fcc "ERROR #"
ErrMsg2 fcb  '0-1,'9+1,'0
         fcb   C$CR

L0878   fcs "PrintErr"


PRTERR   leas  <-$3D,s
         ldb   $02,u
         stb   <$3A,s
         leax  >ErrMsg1,pcr
         leay  ,s
L088E    lda   ,x+
         sta   ,y+
         cmpa  #$23
         bne   L088E
         sty   <$3B,s
         ldx   D.Proc
         stx   <$38,s
         ldx   D.SysPRC
         stx   D.Proc
         leax  >L0878,pcr
         lda   #$11
         os9   F$Link
         bcs   L08C6
         ldb   <$3A,s
         jsr   $03,y
         ldy   <$3B,s
         leay  -$01,y
L08B9    lda   ,x+
         sta   ,y+
         cmpa  #$0D
         bne   L08B9
         os9   F$UnLink
         bra   L08ED

L08C6    leax  >ErrMsg2,pcr
         ldy   <$3B,s
L08CE    lda   ,x+
         sta   ,y+
         cmpa  #$0D
         bne   L08CE
         ldy   <$3B,s
         ldb   <$3A,s
PrtNm1    inc   ,y
         subb  #$64
         bcc   PrtNm1
PrtNm2    dec   $01,y
         addb  #$0A
         bcc   PrtNm2
         addb  #$30
         stb   $02,y
L08ED    ldx   <$38,s
         stx   D.Proc
         ldu   $04,x
         leau  <-$38,u
         lda   D.SysTsk
         ldb   $06,x
         leax  ,s
         ldy   #$0038
         os9   F$Move
         ldx   D.Proc
         lda   <$32,x
         beq   L0910
         leax  ,u
         os9   I$WritLn
L0910    leas  <$3D,s
         clrb
         rts

 page
*****
*
*  Subroutine Ioqueu
*
* Link Process Into Ioqueue And Go To Sleep
*
IOQueu   ldy   D.Proc
L0918    lda   <$10,y
         beq   L0937
         cmpa  $01,u
         bne   L0932
         clr   <$10,y

         os9   F$GProcP
         bcs   IOQuExit
         clr   $0F,y
         ldb   #$01
         os9   F$Send
         bra   IOQ.E

L0932    os9   F$GProcP
         bcc   L0918
L0937    lda   $01,u
L0939    os9   F$GProcP
         bcs   IOQuExit
IOQ.E    lda   <$10,y
         bne   L0939
         ldx   D.Proc
         lda   ,x
         sta   <$10,y
         lda   ,y
         sta   $0F,x
         ldx   #$0000
         os9   F$Sleep
         ldu   D.Proc
         lda   $0F,u
         beq   IOQ.F
         os9   F$GProcP
         bcs   IOQ.F
         lda   <$10,y
         beq   IOQ.F
         lda   <$10,u
         sta   <$10,y
         beq   IOQ.F
         clr   <$10,u
         os9   F$GProcP
         bcs   IOQ.F
         lda   $0F,u
         sta   $0F,y
IOQ.F    clr   $0F,u
IOQuExit    rts
         emod
IOEnd      equ   *
