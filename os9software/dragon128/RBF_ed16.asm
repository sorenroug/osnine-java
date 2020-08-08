 nam Random Block File Manager - Level II

 ttl Module Header & entries
         use defsfile

included equ 1
 ifeq LEVEL-1
 else
RCD.LOCK equ included
 endc
 page
***************
* Edition History

*  #   Date      Comments                                      By
* ----------- ----------------------------------------------- ---
* 04 82/11/16 First Record-Locking Edition Released.         (RFD)
* 05 82/12/01 Prevented input files from gaining EOFLock     (RFD)

* 09 83/02/09 Modified LockSeg to release RCD if no conflict (RFD)

* ===================================================================
*  EDITION 9 CONTAINS A VERY NASTY BAD BUG...ELIMINATE ON CONTACT
* ===================================================================

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

DTBSiz fcb DRVMEM   Drive tbl size

* Entry Branch Table
RBFEnt lbra  Create
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
 leas -StkTemps,s get scratch

* Look for Existing File
         lda   R$B,u
         anda  #$7F
         sta   R$B,u
         lbsr  SchDir
         bcs   L004A
         ldb   #E$CEF
L004A    cmpb  #E$PNNF
         bne   CRTEX1
         cmpa  #PDELIM
         beq   CRTEX1
         pshs  x
         ldx   PD.RGS,Y
         stu   $04,x
* Allocate File Descriptor Sector
         ldb   <$16,y
         ldx   <$17,y
         lda   <$19,y
         ldu   <$1A,y
         pshs  u,x,b,a
         clra
         ldb   #$01
         lbsr  SECALL
         bcc   Create20
         leas  $08,s
CRTEX1    leas  $05,s
         lbra  KillPth0
Create20 std   S.SctSiz+8,s
         ldb   <$16,y
         ldx   <$17,y
         stb   $08,s
         stx   $09,s
         puls  u,x,b,a
         stb   <$16,y
         stx   <$17,y
         sta   <$19,y
         stu   <$1A,y
* Find Free Entry in dir
         ldd   <$3A,y
         std   $0B,y
         ldd   <$3C,y
         std   $0D,y
         lbsr  RdCurDir
         bcs   L00A7
L009E    tst   ,x
         beq   L00B9
         lbsr  RdNxtDir
         bcc   L009E
* If dir is at EOF, then expand it
L00A7    cmpb  #$D3
         bne   CRTEX1
         ldd   #$0020
         lbsr  L052C
         bcs   CRTEX1
         lbsr  WrtFDSiz
* lbsr CLRBUF clear buffer
         lbsr  RdCurDir re-read dir rcd
L00B9    leau  ,x
         lbsr  ZerDir
         puls  x
         os9   F$PrsNam
         bcs   CRTEX1
         cmpb  #$1D
         bls   L00CB
         ldb   #$1D
L00CB    clra
         tfr   d,y
         lbsr  FromUser
         tfr   y,d
         ldy   $05,s
         decb
         lda   b,u
         ora   #$80
         sta   b,u
         ldb   ,s
         ldx   $01,s
         stb   <$1D,u
         stx   <$1E,u
         lbsr  PCPSEC
* (Don't release locked-out Dir rcd
         bcs   CRTERR
         ldu   $08,y
         bsr   ZerBuf
         lda   #$04
         sta   $0A,y
         ldx   PD.RGS,Y
         lda   $02,x
         sta   ,u
         ldx   D.Proc
         ldd   $08,x
         std   $01,u
         lbsr  DateMod
         ldd   $03,u
         std   $0D,u
         ldb   $05,u
         stb   $0F,u
         ldb   #$01
         stb   $08,u
         ldd   $03,s
         subd  #$0001
         beq   L0128
         leax  <$10,u
         std   $03,x
         ldd   $01,s
         addd  #$0001
         std   $01,x
         ldb   ,s
         adcb  #$00
         stb   ,x
L0128    ldb   ,s
         ldx   $01,s
         lbsr  PUTSEC
         bcs   CRTERR
         lbsr  Remove
         stb   <$34,y
         stx   <$35,y
         lbsr  Insert
         leas  $05,s
         ldx   <$30,y
         lda   #$04
         sta   $07,x
         lbra  InitPd

*  Error: Deallocate sectors & return
CRTERR    puls  u,x,a
         sta   <$16,y
         stx   <$17,y
         clr   <$19,y
         stu   <$1A,y
         pshs  b
         lbsr  SECDEA
         puls  b
L015E    lbra  KillPth0
***************
* Subroutines ZerDir, ZerBuf
*   Zero Dir size rcd, or buffer
* Record size MUST be evenly divisive by 4
ZerDir    pshs  u,x,b,a
         leau  <$20,u
         bra   L016E

ZerBuf    pshs  u,x,b,a
         leau  >$0100,u
L016E    clra
         clrb
         tfr   d,x
L0172    pshu  x,b,a
         cmpu  $04,s
         bhi   L0172
         puls  pc,u,x,b,a

***************
* Subroutine Open
*   Locates File Descriptor and Initializes PD

Open    pshs  y
         lbsr  SchDir
         bcs   L015E
         ldu   PD.RGS,Y
         stx   $04,u
         ldd   <$35,y
         bne   L01B8
         lda   <$34,y
         bne   L01B8
         ldb   $01,y
         andb  #$80
         lbne  IllAcces
         std   <$16,y
         sta   <$18,y
         std   <$13,y
         sta   <$15,y
         ldx   <$1E,y
         lda   $02,x
         std   <$11,y
         sta   <$1B,y
         ldd   ,x
         std   $0F,y
         std   <$19,y
         puls  pc,y

* Check File Accessibility
L01B8    lda   $01,y
         lbsr  CHKACC
         bcs   L015E
         bita  #$02
         beq   InitPd
         lbsr  DateMod
         lbsr  PUTFD

* fall thru to Initpd
 page
***************
* Initialize PD

InitPd    puls  y
InitPD10    clra
         clrb
         std   $0B,y
         std   $0D,y
         std   <$13,y
         sta   <$15,y
         sta   <$19,y
         lda   ,u
         sta   <$33,y
         ldd   <$10,u
         std   <$16,y
         lda   <$12,u
         sta   <$18,y
         ldd   <$13,u
         std   <$1A,y
         ldd   $09,u
         ldx   $0B,u
 ifeq RCD.LOCK-included
         ldu   <$30,y
         cmpu  $05,u
         beq   InitPD80
         ldu   $05,u
         ldu   $01,u
         ldd   PD.SIZ,u
         ldx   PD.SIZ+2,u
InitPD80
 endc

 std   PD.SIZ,y
         stx   PD.SIZ+2,y
         clr   $0A,y
         rts
 page
***************
* Subroutine Makdir
*   Creates A New (Sub-Ordinate) Dir

* Passed: (Y)=PD

MakDir    lbsr  Create
         bcs   MakDir90
 ifeq RCD.LOCK-included
         lda   <$33,y
         ora   #$40
         lbsr  CHKACC
         bcs   MakDir90
 endc
         ldd   #$0040
         std   <$11,y
         bsr   L0270
         bcs   MakDir90
         lbsr  EXPAND
         bcs   MakDir90
         ldu   $08,y
         lda   ,u
         ora   #$80
         sta   ,u
         bsr   WrtFDSiz
         bcs   MakDir90
         lbsr  ZerBuf
         ldd   #"..+$80
         std   ,u
         stb   <$20,u
         lda   <$37,y
         sta   <$1D,u
         ldd   <$38,y
         std   <$1E,u
         lda   <$34,y
         sta   <$3D,u
         ldd   <$35,y
         std   <$3E,u
         lbsr  PCPSEC
MakDir90    bra   KillPth1

***************
* Subroutine WrtFDSiz

WrtFDSiz    lbsr  GETFD
         ldx   $08,y
         ldd   $0F,y
         std   $09,x
         ldd   <$11,y
         std   $0B,x
         clr   $0A,y
L0270    lbra  PUTFD
 page
***************
* Subroutine Close

Close    clra
         tst   $02,y
         bne   Close99
         lbsr  CLRBUF
         bcs   KillPth1
         ldb   $01,y
         bitb  #$02
         beq   KillPth1
         ldd   <$34,y
         bne   L028D
         lda   <$36,y
         beq   KillPth1
L028D    bsr   WrtFDSiz
         lbsr  L0578
         bcc   KillPth1
         lbsr  TRIM
         bra   KillPth1
Close99    rts

IllAcces    ldb   #$D6
KillPth0    coma

KillPth    puls  y
KillPth1    pshs  b,cc
         ldu   $08,y
         beq   L02BA
         ldd   #$0100
         os9   F$SRtMem

 ifeq RCD.LOCK-included
         ldx   <$30,y
         beq   L02BA
         lbsr  Remove
         lda   ,x
         ldx   D.PthDBT
         os9   F$Ret64
 endc
L02BA    puls  pc,b,cc
 page
***************
* Subroutine DateMod

DateMod  lbsr  GETFD
         ldu   $08,y
         lda   $08,u
 ifeq LEVEL-1
 else
         ldx   D.Proc
         pshs  x,a
         ldx   D.SysPrc
         stx   D.Proc
         leax  $03,u
         os9   F$Time
         puls  x,a
         stx   D.Proc
 endc

         sta   $08,u
         rts

***************
* Subroutine Chgdir

ChgDir    pshs  y
         lda   $01,y
         ora   #$80
         sta   $01,y
         lbsr  Open
         bcs   KillPth
         ldx   D.Proc
         lda   <$21,y
         ldu   <$35,y
         ldb   $01,y
         bitb  #$03
         beq   L02FB
         ldb   <$34,y
         std   <$22,x
         stu   <$24,x
L02FB    ldb   $01,y
         bitb  #$04
         beq   L030A
         ldb   <$34,y
         std   <$28,x
         stu   <$2A,x
L030A    clrb
         bra   KillPth

***************
* Subroutine Delete

Delete    pshs  y
         lbsr  SchDir
         bcs   KillPth
         ldd   <$35,y
         bne   L0320
         tst   <$34,y
         lbeq  IllAcces
L0320    lda   #$42
         lbsr  CHKACC
         bcs   Delete99
         ldu   PD.RGS,Y
         stx   $04,u
         lbsr  GETFD
         bcs   Delete99
         ldx   $08,y
         dec   $08,x
         beq   L033B
         lbsr  PUTFD
         bra   L0361

L033B    clra
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

L0361    bcs   Delete99
         lbsr  CLRBUF
         lbsr  Remove
         lda   <$37,y
         sta   <$34,y
         ldd   <$38,y
         std   <$35,y
         lbsr  Insert
         lbsr  GETFD
         bcs   Delete99
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

Seek    ldb   $0A,y
         bitb  #$02
         beq   L03B0
         lda   $05,u
         ldb   $08,u
         subd  $0C,y
         bne   L03AB
         lda   $04,u
         sbca  $0B,y
         beq   L03B4
L03AB    lbsr  CLRBUF
         bcs   L03B8
L03B0    ldd   $04,u
         std   $0B,y
L03B4    ldd   $08,u
         std   $0D,y
L03B8    rts
 page
***************
* Stacked temporaries used by RBRW
 org 0

***************
* Subroutine ReadLn

ReadLn    bsr   ReadInit
         beq   RDLine0
         bsr   L03E0
         pshs  u,y,x,b,a
         exg   x,u
         ldy   #$0000
         lda   #$0D
L03C9    leay  $01,y
         cmpa  ,x+
         beq   L03D2
         decb
         bne   L03C9
L03D2    ldx   $06,s
         bsr   ToUser
         sty   $0A,s
         puls  u,y,x,b,a
         ldd   $02,s
         leax  d,x
RDLine0    rts

L03E0    lbsr  RBRW00
         leax  -$01,x
         lbsr  UserByte
         cmpa  #$0D
         beq   L03F2
         ldd   $02,s
         lbne  L0472
L03F2    ldu   PD.RGS,Y
         ldd   $06,u
         subd  $02,s
         std   $06,u
         bra   L0459

***************
* Subroutine ReadInit

ReadInit    ldd   $06,u
 ifeq RCD.LOCK-included
         lbsr  Gain00
         bcs   ReadIERR
         ldd   $06,u
 endc
         bsr   RDSET
         bcs   ReadIERR
         std   $06,u
         rts

***************
* Subroutine Rdset

RDSET    pshs  b,a
         ldd   <$11,y
         subd  $0D,y
         tfr   d,x
         ldd   $0F,y
         sbcb  $0C,y
         sbca  $0B,y
         bcs   L042D
         bne   L042A
         tstb
         bne   L042A
         cmpx  ,s
         bcc   L042A
         stx   ,s
         beq   L042D
L042A    clrb
         puls  pc,b,a
L042D    comb
         ldb   #$D3
ReadIERR    leas  $02,s
         bra   L045E
 ifeq LEVEL-1
 else
 page
***************
* Subroutine ToUser

ToUser    pshs  x
         ldx   D.Proc
         lda   D.SysTsk
         ldb   $06,x
         puls  x
         os9   F$Move
         rts
 endc

***************
* Subroutine Read

Read    bsr   ReadInit
         beq   L0454
         bsr   L0455

* Subroutine RdByte

RdByte    pshs  u,y,x,b,a
         exg   x,u
         tfr   d,y
         bsr   ToUser
         puls  u,y,x,b,a
         leax  d,x
L0454    rts

L0455    bsr   RBRW00
         bne   L0472
L0459    clrb
L045A    leas  -$02,s
L045C    leas  $0A,s
L045E    pshs  b,cc
         lda   $01,y
         bita  #$02
         bne   L0469
         lbsr  UnLock
L0469    puls  b,cc
         rts

***************
* Subroutine RBRW

RBRW00    ldd   $04,u
         ldx   $06,u
         pshs  x,b,a
L0472    lda   $0A,y
         bita  #$02
         bne   L0492
         tst   $0E,y
         bne   L048D
         tst   $02,s
         beq   L048D
         leax  >WrByte,pcr
         cmpx  $06,s
         bne   L048D
         lbsr  CHKSEG
         bra   L0490
L048D    lbsr  RDCP
L0490    bcs   L045A
L0492    ldu   $08,y
         clra
         ldb   $0E,y
         leau  d,u
         negb
         sbca  #$FF
         ldx   ,s
         cmpd  $02,s
         bls   L04A5
         ldd   $02,s
L04A5    pshs  b,a
         jsr   [<$08,s]
         stx   $02,s
         ldb   $01,s
         addb  $0E,y
         stb   $0E,y
         bne   L04C3
         lbsr  CLRBUF
         inc   $0D,y
         bne   L04C1
         inc   $0C,y
         bne   L04C1
         inc   $0B,y
L04C1    bcs   L045C
L04C3    ldd   $04,s
         subd  ,s++
         std   $02,s
         jmp   [<$04,s]

***************
* Subroutine Writline

WritLine    pshs  y
         clrb
         ldy   $06,u
         beq   L04F1
         ldx   D.Proc
         ldb   $06,x
         ldx   $04,u
L04DA    leay  -$01,y
         beq   L04F1
         os9   F$LDABX
         leax  $01,x
         cmpa  #$0D
         bne   L04DA
         tfr   y,d
         nega
         negb
         sbca  #$00
         addd  $06,u
         std   $06,u
L04F1    puls  y

***************
* Subroutine Write

Write    ldd   $06,u
         lbsr  Gain00
         bcs   Write99

         ldd   $06,u
         beq   L052A
         bsr   L052C
         bcs   Write99
         bsr   L0515

* Subroutine WrByte

WrByte    pshs  y,b,a
         tfr   d,y
         bsr   FromUser
         puls  y,b,a
         leax  d,x
         lda   $0A,y
         ora   #$03
         sta   $0A,y
         rts

L0515    lbsr  RBRW00
         lbne  L0472
         leas  $08,s
         ldy   <$30,y
         lda   #$01
         lbsr  Release
         ldy   $01,y
L052A    clrb
Write99    rts

***************
* Subroutine WriteSub

L052C    addd  $0D,y
         tfr   d,x
         ldd   $0B,y
         adcb  #$00
         adca  #$00
L0536    cmpd  $0F,y
         bcs   L052A
         bhi   L0542
         cmpx  <$11,y
         bls   L052A
L0542    pshs  u
         ldu   <$11,y
         stx   <$11,y
         ldx   $0F,y
         std   $0F,y
         pshs  u,x
         lbsr  EXPAND
         puls  u,x
         bcc   L055C
         stx   $0F,y
         stu   <$11,y
L055C    puls  pc,u

 ifeq LEVEL-1
 else
***************
* Subroutine FromUser

FromUser    pshs  x
         ldx   D.Proc
         lda   $06,x
         ldb   D.SysTsk
         puls  x
         os9   F$Move
         rts
 endc
 page

***************
* Subroutine Getstat

GetStat    ldb   $02,u
         cmpb  #$00
         beq   L0592
         cmpb  #$06
         bne   L057E
         clr   $02,u
L0578    clra
         ldb   #$01
         lbra  RDSET

L057E    cmpb  #$01
         bne   L0585
         clr   $02,u
         rts
L0585    cmpb  #$02
         bne   L0593
         ldd   $0F,y
         std   $04,u
         ldd   <$11,y
         std   $08,u
L0592    rts
L0593    cmpb  #$05
         bne   L05A0
         ldd   $0B,y
         std   $04,u
         ldd   $0D,y
         std   $08,u
         rts
L05A0    cmpb  #$0F
         bne   L05BA
         lbsr  GETFD
         bcs   L0592
         ldu   PD.RGS,Y
         ldd   $06,u
         tsta
         beq   L05B3
         ldd   #$0100
L05B3    ldx   $04,u
         ldu   $08,y
         lbra  RdByte
L05BA    lda   #$09
         lbra  DEVDIS

***************
* Subroutine Putstat

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
         bne   L05E3
         tst   <$34,y
         lbeq  L0684
L05E3    lda   $01,y
         bita  #$02
         beq   L0611
         ldd   $04,u
         ldx   $08,u
         cmpd  $0F,y
         bcs   L05FC
         bne   L05F9
         cmpx  <$11,y
         bcs   L05FC
L05F9    lbra  L0536
L05FC    std   $0F,y
         stx   <$11,y
         ldd   $0B,y
         ldx   $0D,y
         pshs  x,b,a
         lbsr  TRIM
         puls  u,x
         stx   $0B,y
         stu   $0D,y
         rts
L0611    comb
         ldb   #$CB
         rts

PSt110    cmpb  #$0F
         bne   L0653
         lda   $01,y
         bita  #$02
         beq   L0611
         lbsr  GETFD
         bcs   L0687
         pshs  y
         ldx   $04,u
         ldu   $08,y
         ldy   D.Proc
         ldd   $08,y
         bne   L0636
         ldd   #$0102
         bsr   L0645
L0636    ldd   #$0305
         bsr   L0645
         ldd   #$0D03
         bsr   L0645
         puls  y
         lbra  PUTFD
L0645    pshs  u,x
         leax  a,x
         leau  a,u
         clra
         tfr   d,y
         lbsr  FromUser
         puls  pc,u,x
L0653    cmpb  #$11
         bne   L0672
         ldd   $08,u
         ldx   $04,u
         cmpx  #$FFFF
         bne   L066F
         cmpx  $08,u
         bne   L066F
         ldu   <$30,y
         lda   $07,u
         ora   #$02
         sta   $07,u
         lda   #$FF
L066F    lbra  Gain
L0672    cmpb  #$10
         bne   L067F
         ldd   $04,u
         ldx   <$30,y
         std   <$12,x
         rts
L067F    lda   #$0C
         lbra  DEVDIS

L0684    comb
         ldb   #$D0
L0687    rts

***************
* Subroutine SchDir

SchDir    ldd   #$0100
         stb   $0A,y
         os9   F$SRqMem
         bcs   L0687
         stu   $08,y
         leau  ,y
         ldx   D.PthDBT
         os9   F$All64
         exg   y,u
         bcs   L0687
         stu   <$30,y
         sty   $01,u
         stu   <$10,u
         ldx   PD.RGS,Y
         ldx   $04,x
         pshs  u,y,x
         leas  -$04,s
         clra
         clrb
         sta   <$34,y
         std   <$35,y
         std   <$1C,y
         lbsr  UserByte
         sta   ,s
         cmpa  #$2F
         bne   SchDir20
         lbsr  RBPNam
         sta   ,s
         lbcs  DirErr
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
         ldu   D.Proc
         leau  <$20,u
         bita  #$24
         beq   L06ED
         leau  $06,u
L06ED    ldb   $03,u
         stb   <$34,y
         ldd   $04,u
         std   <$35,y

* Initial dir has been found
SchDir30    ldu   $03,y
         stu   <$3E,y
         lda   <$21,y
         ldb DTBSiz,pcr
         mul
         addd  $02,u
         addd  #$000F
         std   <$1E,y
         lda   ,s
         anda  #$7F
         cmpa  #$40
         bne   L0718
         leax  $01,x
         bra   L073A

L0718    lbsr  GETDD
         lbcs  L07BF
         ldu   $08,y
         ldd   $0E,u
         std   <$1C,y
         ldd   <$35,y
         bne   L073A
         lda   <$34,y
         bne   L073A
         lda   $08,u
         sta   <$34,y
         ldd   $09,u
         std   <$35,y

L073A    stx   $04,s
         stx   $08,s
SchDir60    lbsr  CLRBUF
         lbsr  Insert
         bcs   L07BF
         lda   ,s
         cmpa  #$2F
         bne   L07A1
         clr   $02,s
         clr   $03,s
         lda   $01,y
         ora   #$80
         lbsr  CHKACC
         bcs   DirErr
         lbsr  InitPD10
         ldx   $08,s
         leax  $01,x
         lbsr  RBPNam
         std   ,s
         stx   $04,s
         sty   $08,s
         ldy   $06,s
         bcs   DirErr
         lbsr  RdCurDir
         bra   SchDir80

L0774    bsr   SaveDel
L0776    bsr   RdNxtDir
SchDir80    bcs   DirErr
         tst   ,x
         beq   L0774
         leay  ,x
         ldx   $04,s
         ldb   $01,s
         clra
         os9   F$CmpNam
         ldx   $06,s
         exg   x,y
         bcs   L0776
         bsr   SaveDir
         lda   <$1D,x
         sta   <$34,y
         ldd   <$1E,x
         std   <$35,y
         lbsr  Remove
         bra   SchDir60
L07A1    ldx   $08,s
         tsta
         bmi   L07AE
         os9   F$PrsNam
         leax  ,y
         ldy   $06,s
L07AE    stx   $04,s
         clra
L07B1    lda   ,s
         leas  $04,s
         puls  pc,u,y,x

DirErr    cmpb  #$D3
         bne   L07BF
         bsr   SaveDel
         ldb   #$D8
L07BF    coma
         bra   L07B1

***************
* Subroutine SaveDel, SaveDir

SaveDel    pshs  b,a
         lda   $04,s
         cmpa  #$2F
         beq   L07EA
         ldd   $06,s
         bne   L07EA
         puls  b,a

SaveDir    pshs  b,a
         stx   $06,s
         lda   <$34,y
         sta   <$37,y
         ldd   <$35,y
         std   <$38,y
         ldd   $0B,y
         std   <$3A,y
         ldd   $0D,y
         std   <$3C,y
L07EA    puls  pc,b,a
 page
***************
* Subroutine RdNxtDir

RdNxtDir    ldb   $0E,y
         addb  #$20
         stb   $0E,y
         bcc   RdCurDir
         lbsr  CLRBUF
         inc   $0D,y
         bne   RdCurDir
         inc   $0C,y
         bne   RdCurDir
         inc   $0B,y
RdCurDir    ldd   #$0020
         lbsr  RDSET
         bcs   RdNxtD90
         ldd   #$0020
         lbsr  Gain00
         bcs   RdNxtD90
         lda   $0A,y
         bita  #$02
         bne   L0821
         lbsr  CHKSEG
         bcs   RdNxtD90
         lbsr  RDCP
         bcs   RdNxtD90
L0821    ldb   $0E,y
         lda   $08,y
         tfr   d,x
         clrb
RdNxtD90    rts

 ifne LEVEL-1
UserByte    pshs  u,x,b
         ldu   D.Proc
         ldb   P$Task,u
         os9   F$LDABX
         puls  pc,u,x,b
 endc

RBPNam    os9   F$PrsNam
         pshs  x
         bcc   RBPNam99
         clrb
RBPNam10    pshs  a
         anda  #$7F
         cmpa  #$2E
         puls  a
         bne   L0857
         incb
         leax  $01,x
         tsta
         bmi   L0857
         bsr   UserByte
         cmpb  #3
         bcs   RBPNam10

* The pathlist contains "..." (grandparent).  Code here
* makes this look like "../.." for any number of dots.
         lda   #$2F
         decb
         leax  -$03,x
L0857    tstb
         bne   L085F
         comb
         ldb   #$D7
         puls  pc,x
L085F    leay  ,x
         andcc #$FE
RBPNam99    puls  pc,x
 page

CHKACC    tfr   a,b
         anda  #$07
         andb  #$C0
         pshs  x,b,a
         lbsr  GETFD
         bcs   L0894
         ldu   $08,y
         ldx   D.Proc
         ldd   $08,x
         beq   L087D
         cmpd  $01,u
L087D    puls  a
         beq   L0884
         lsla
         lsla
         lsla
L0884    ora   ,s
         anda  #$BF
         pshs  a
         ora   #$80
         anda  ,u
         cmpa  ,s
         beq   CHKA20
         ldb   #$D6
L0894    leas  $02,s
         coma
         puls  pc,x

CHKAErr    ldb   #$FD
         bra   L0894

CHKA20

 ifeq RCD.LOCK-included
 ldb 1,s
         orb   ,u
         bitb  #$40
         beq   CHKA90
         ldx   <$30,y
         cmpx  $05,x
         bne   CHKAErr
         lda   #$02
         sta   $07,x
 endc
CHKA90    puls  pc,x,b,a

 ifeq RCD.LOCK-included
 ttl Record Locking Subroutines
 page

Insert    pshs  u,y,x
         clra
         clrb
         std   $0B,y
         std   $0D,y
         sta   <$19,y
         std   <$1A,y
         ldb   <$34,y
         ldx   <$35,y
         pshs  x,b
         ldu   <$1E,y
         ldy   <$30,y
         sty   $05,y
         leau  <$15,u
         bra   L08D9

L08D7    ldu   $03,u
L08D9    ldx   $03,u
         beq   Insert80
         ldx   $01,x
         ldd   <$34,x
         cmpd  ,s
         bcs   L08D7
         bhi   Insert80
         ldb   <$36,x
         cmpb  $02,s
         bcs   L08D7
         bhi   Insert80
         ldx   <$30,x
         lda   $07,y
         bita  #$02
         bne   SharErr
         sty   $03,y
         ldd   $05,x
         std   $05,y
         sty   $05,x
         bra   L090E
Insert80    ldx   $03,u
         stx   $03,y
         sty   $03,u
L090E    clrb
L090F    leas  $03,s
         puls  pc,u,y,x
SharErr    comb
         ldb   #$FD
         bra   L090F

Remove    pshs  u,y,x,b,a
         ldu   <$1E,y
         leau  <$15,u
         ldx   <$30,y
         leay  ,x
         bsr   L0957
         bra   L092D
L0929    ldx   $05,x
         beq   Remove90
L092D    cmpy  $05,x
         bne   L0929
         ldd   $05,y
         std   $05,x
         bra   L093A
L0938    ldu   $03,u
L093A    ldd   $03,u
         beq   Remove90
         cmpy  $03,u
         bne   L0938
         ldx   $03,y
         cmpy  $05,y
         beq   L0950
         ldx   $05,y
         ldd   $03,y
         std   $03,x
L0950    stx   $03,u
Remove90    sty   $05,y
         puls  pc,u,y,x,b,a

L0957    lda   #$07
Release    pshs  u,y,x,b,a
         bita  $07,y
         beq   L0968
         coma
         anda  $07,y
         sta   $07,y
         bita  #$02
         bne   L0985
L0968    leau  ,y
L096A    ldx   <$10,u
         cmpy  <$10,u
         beq   L0982
         stu   <$10,u
         leau  ,x
         lda   <$14,u
         ldb   #$01
         os9   F$Send
         bra   L096A
L0982    stu   <$10,u
L0985    puls  pc,u,y,x,b,a

L0987    comb
         ldb   #$FD

UnLock    pshs  y,b,cc
         ldy   <$30,y
         bsr   L0957
         puls  pc,y,b,cc

Gain00    ldx   #$0000
         bra   Gain
L0999    ldu   <$30,y
         lda   <$15,u
         sta   $07,u
         puls  u,y,x,b,a
Gain    pshs  u,y,x,b,a
         ldu   <$30,y
         lda   $07,u
         sta   <$15,u
         lda   ,s
         lbsr  LockSeg
         bcc   L0A1D
         ldu   D.Proc
         lda   <$14,x
L09B9    os9   F$GProcP
         bcs   Gain40
         lda   <$1E,y
         beq   Gain40
         cmpa  P$ID,u
         bne   L09B9
         ldb   #$FE
         bra   GainErr
Gain40    lda   <$14,x
         sta   <$1E,u
         bsr   UnQueue
         ldy   $04,s
         ldu   <$30,y
         ldd   <$10,x
         stu   <$10,x
         std   <$10,u
         ldx   <$12,u
         os9   F$Sleep
         pshs  x
         leax  ,u
         bra   L09F1
L09EE    ldx   <$10,x
L09F1    cmpu  <$10,x
         bne   L09EE
         ldd   <$10,u
         std   <$10,x
         stu   <$10,u
         puls  x
         ldu   D.Proc
         clr   <$1E,u
         lbsr  ChkSignl
         bcs   GainErr
         leax  ,x
         bne   L0999
         ldu   <$30,y
         ldx   <$12,u
         beq   L0999
         ldb   #$FC
GainErr    coma
         stb   $01,s
L0A1D    puls  pc,u,y,x,b,a

UnQueue    pshs  y,x
         ldy   D.Proc
         bra   L0A33
L0A26    clr   <$10,y
         ldb   #$01
         os9   F$Send
         os9   F$GProcP
         clr   $0F,y
L0A33    lda   <$10,y
         bne   L0A26
         puls  pc,y,x

LockSeg    std   -$02,s
         bne   L0A45
         cmpx  #$0000
         lbeq  UnLock
L0A45    bsr   Conflct
         lbcs  L0987
         pshs  u,y,x
         ldy   <$30,y
         lda   #$01
         lbsr  Release
         ora   $07,y
         sta   $07,y
         clrb
         puls  pc,u,y,x

Conflct    pshs  u,y,b,a
         leau  ,y
         ldy   <$30,y
         subd  #$0001
         bcc   L0A6C
         leax  -$01,x
L0A6C    addd  $0D,u
         exg   d,x
         adcb  $0C,u
         adca  $0B,u
         bcc   L0A7B
         ldx   #$FFFF
         tfr   x,d
L0A7B    std   $0C,y
         stx   $0E,y
         cmpd  $0F,u
         bcs   Conflc15
         bhi   L0A8B
         cmpx  <$11,u
         bcs   Conflc15
L0A8B    lda   $07,y
         ora   #$04
         sta   $07,y
         bra   L0A9C
Conflc15    lda   #$04
         bita  $07,y
         beq   L0A9C
         lbsr  Release
L0A9C    ldd   $0B,u
         ldx   $0D,u
         std   $08,y
         stx   $0A,y
         lda   $05,u
         sta   <$14,y
         leax  ,y
L0AAB    cmpy  $05,x
         beq   L0AEF
         ldx   $05,x
         ldb   <$14,y
         cmpb  <$14,x
         beq   L0AAB
         lda   $07,x
         beq   L0AAB
         ora   $07,y
         bita  #$02
         bne   Conflc85
         lda   $07,x
         anda  $07,y
         bita  #$04
         bne   Conflc85
         ldd   $08,x
         cmpd  $0C,y
         bhi   L0AAB
         bcs   L0ADE
         ldd   $0A,x
         cmpd  $0E,y
         bhi   L0AAB
         beq   Conflc85

L0ADE    ldd   $0C,x
         cmpd  $08,y
         bcs   L0AAB
         bhi   Conflc85
         ldd   $0E,x
         cmpd  $0A,y
         bcs   L0AAB
Conflc85    comb
L0AEF    puls  pc,u,y,b,a

 else
 endc
 page

EXPAND    pshs  u,x
L0AF3    bsr   EXPSUB
         bne   EXPA15
         cmpx  <$1A,y
         bcs   EXPA45
         bne   EXPA15
         lda   <$12,y
         beq   EXPA45
EXPA15    lbsr  GETFD
         bcs   L0B47
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
         bne   L0B47
         bsr   EXPSUB
         bne   L0B33
         tst   <$12,y
         beq   L0B36
         leax  $01,x
         bne   L0B36
L0B33    ldx   #$FFFF
L0B36    tfr   x,d
         tsta
         bne   EXPA40
         cmpb  <$2E,y
         bcc   EXPA40
         ldb   <$2E,y
EXPA40    bsr   SEGALL
         bcc   L0AF3
L0B47    coma
         puls  pc,u,x

EXPA45    lbsr  CHKSEG
 ifeq RCD.LOCK-included
         bcs   L0B47
         bsr   NewSize
 endc
         puls  pc,u,x

EXPSUB    ldd   <$10,y
         subd  <$14,y
         tfr   d,x
         ldb   $0F,y
         sbcb  <$13,y
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

NewSize    clra
         ldb   #$02
         pshs  u,x
         ldu   <$30,y
         bra   L0B7F
L0B6B    ldu   $01,u
         ldx   $0F,y
         stx   $0F,u
         ldx   <$11,y
         stx   <$11,u
         bitb  $01,y
         beq   L0B7C
         inca
L0B7C    ldu   <$30,u
L0B7F    ldu   $05,u
         cmpy  $01,u
         bne   L0B6B
         tsta
         puls  pc,u,x
 endc

SEGALL    pshs  u,x
         lbsr  SECALL
         bcs   SEGALErr
         lbsr  GETFD
         bcs   SEGALErr
         ldu   $08,y
         clra
         clrb
         std   $09,u
         std   $0B,u
         leax  <$10,u
         ldd   $03,x
         beq   SEGA20
         ldd   $08,y
         inca
         pshs  b,a
         bra   L0BB8

EMPS10    clrb
         ldd   FDSL.B-FDSL.S,x
         beq   L0BC4
         addd  $0A,u
         std   $0A,u
         bcc   L0BB8
         inc   $09,u
L0BB8    leax  $05,x
         cmpx  ,s
         bcs   EMPS10
         lbsr  SECDEA
         comb
         ldb   #$D9
L0BC4    leas  $02,s
         leax  -$05,x
SEGALErr    bcs   L0C2D

         ldd   -$04,x
         addd  -$02,x
         pshs  b,a
         ldb   -$05,x
         adcb  #$00
         cmpb  <$16,y
         puls  b,a
         bne   SEGA20
         cmpd  <$17,y
         bne   SEGA20
* Now insure that they are in same bitmap sector
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
         bne   SEGA20
         ldd   -$02,x
         addd  <$1A,y
         bcs   SEGA20
         std   -$02,x
         bra   L0C1F
SEGA20    ldd   <$16,y
         std   ,x
         lda   <$18,y
         sta   $02,x
         ldd   <$1A,y
         std   $03,x
L0C1F    ldd   FD.SIZ+1,u
         addd  <$1A,y
         std   FD.SIZ+1,u
         bcc   L0C2A
         inc   FD.SIZ,u
L0C2A    lbsr  PUTFD
L0C2D    puls  pc,u,x
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

SECALL    pshs  u,y,x,b,a
         ldb   #S.BitReq
SECA05    clr   ,-s
         decb
         bne   SECA05
         ldx   <$1E,y
         ldd   $04,x
         std   $05,s
         ldd   $06,x
         std   $03,s
         std   $0B,s

* Convert Segment Allocation Size (SAS) to clusters
* (D)=cluster size
         ldx   $03,y
         ldx   $04,x
         leax  <$12,x
         subd  #$0001
         addb  $0E,x
         adca  #$00
         bra   SECA08
L0C55    lsra
         rorb
SECA08    lsr   $0B,s
         ror   $0C,s
         bcc   L0C55
         std   $01,s
         ldd   $03,s
         std   $0B,s
         subd  #$0001
         addd  $0D,s
         bcc   L0C71
         ldd   #$FFFF
         bra   L0C71
L0C6F    lsra
         rorb
L0C71    lsr   $0B,s
         ror   $0C,s
         bcc   L0C6F
         cmpa  #$08
         bcs   L0C7E
         ldd   #$0800
L0C7E    std   $0D,s
         lbsr  LockBit
         lbcs  L0D78
         ldx   <$1E,y
         ldd   <$1A,x
         cmpd  $0E,x
         bne   SECA14
         lda   <$1C,x
         cmpa  $04,x
         bne   SECA14
         ldd   $0D,s
         cmpd  $01,s
         bcs   L0CBD
         lda   <$1D,x
         cmpa  $04,x
         bcc   SECA14
         sta   $07,s
         nega
         adda  $05,s
         sta   $05,s
         bra   L0CBD
SECA14    ldd   $0E,x
         std   <$1A,x
         lda   $04,x
         sta   <$1C,x
         clr   <$1D,x
L0CBD    inc   $07,s
         ldb   $07,s
         lbsr  ReadBit
         lbcs  L0D78
         ldd   $05,s
         tsta
         beq   L0CD0
         ldd   #$0100
L0CD0    ldx   $08,y
         leau  d,x
         ldy   $0D,s
         clra
         clrb
         os9   F$SchBit
         pshs  b,a,cc
         tst   $03,s
         bne   SECA17a
         cmpy  $04,s
         bcs   SECA17a
         lda   $0A,s
         sta   $03,s
SECA17a    puls  b,a,cc
         bcc   L0D1E
         cmpy  $09,s
         bls   L0CFD
         sty   $09,s
         std   $0B,s
         lda   $07,s
         sta   $08,s
L0CFD    ldy   <$11,s
         tst   $05,s
         beq   L0D09
         dec   $05,s
         bra   L0CBD
L0D09    ldb   $08,s
         beq   L0D76
         clra
         cmpb  $07,s
         beq   L0D17
         stb   $07,s
         lbsr  ReadBit
L0D17    ldx   $08,y
         ldd   $0B,s
         ldy   $09,s
L0D1E    std   $0B,s
         sty   $09,s
         os9   F$AllBit
         ldy   <$11,s
         ldb   $07,s
         lbsr  PUTBIT
         bcs   L0D78
         lda   ,s
         beq   SECA22
         ldx   <$1E,y
         deca
         sta   <$1D,x
SECA22    lda   $07,s
         deca
         clrb
         lsla
         rolb
         lsla
         rolb
         lsla
         rolb
         stb   <$16,y
         ora   $0B,s
         ldb   $0C,s
         ldx   $09,s
         ldy   <$11,s
         std   <$17,y
         stx   <$1A,y
         ldd   $03,s
         bra   L0D6C
L0D5D    lsl   <$18,y
         rol   <$17,y
         rol   <$16,y
         lsl   <$1B,y
         rol   <$1A,y
L0D6C    lsra
         rorb
         bcc   L0D5D
         clrb
         ldd   <$1A,y
         bra   SECA90
L0D76    ldb   #$F8
L0D78    ldy   <$11,s
         lbsr  RLSBIT
         coma
SECA90    leas  $0F,s
         puls  pc,u,y,x
 page


TRIM    clra
         lda   $01,y
         bita  #$80
         bne   L0DF5
         ldd   $0F,y
         std   $0B,y
         ldd   <$11,y
         std   $0D,y
         ldd   #$FFFF
         tfr   d,x
         lbsr  Gain
         bcs   TrimErr
         lbsr  NewSize
         bne   L0DF5
         lbsr  GETSEG
         bcc   L0DAC
         cmpb  #$D5
         bra   L0DED
L0DAC    ldd   <$14,y
         subd  $0C,y
         addd  <$1A,y
         tst   $0E,y
         beq   L0DBB
         subd  #$0001
L0DBB    pshs  b,a
         ldu   <$1E,y
         ldd   $06,u
         subd  #$0001
         coma
         comb
         anda  ,s+
         andb  ,s+
         ldu   <$1A,y
         std   <$1A,y
         beq   L0DEF
         tfr   u,d
         subd  <$1A,y
         pshs  x,b,a
         addd  <$17,y
         std   <$17,y
         bcc   L0DE5
         inc   <$16,y
L0DE5    bsr   SECDEA
         bcc   L0DF6
         leas  $04,s
         cmpb  #$DB
L0DED    bne   TrimErr
L0DEF    lbsr  GETFD
         bcc   L0DFF
TrimErr    coma
L0DF5    rts

L0DF6    lbsr  GETFD
         bcs   TRIM80
         puls  x,b,a
         std   $03,x
L0DFF    ldu   $08,y
         ldd   <$11,y
         std   $0B,u
         ldd   $0F,y
         std   $09,u
         tfr   x,d
         clrb
         inca
         leax  $05,x
         pshs  x,b,a
         bra   TRIM65

L0E14    ldd   -$02,x
         beq   L0E47
         std   <$1A,y
         ldd   -$05,x
         std   <$16,y
         lda   -$03,x
         sta   <$18,y
         bsr   SECDEA
         bcs   TRIM80
         stx   $02,s
         lbsr  GETFD
         bcs   TRIM80
         ldx   $02,s
         clra
         clrb
         std   -$05,x
         sta   -$03,x
         std   -$02,x
TRIM65    lbsr  PUTFD
         bcs   TRIM80
         ldx   $02,s
         leax  $05,x
         cmpx  ,s
         bcs   L0E14
L0E47    clra
         clrb
         sta   <$19,y
         std   <$1A,y
TRIM80    leas  $04,s
         rts
 page


SECDEA    pshs  u,y,x,a
         ldx   <$1E,y
         ldd   $06,x
         subd  #$0001
         addd  <$17,y
         std   <$17,y
         ldd   $06,x
         bcc   L0E7A
         inc   <$16,y
         bra   L0E7A
L0E6B    lsr   <$16,y
         ror   <$17,y
         ror   <$18,y
         lsr   <$1A,y
         ror   <$1B,y
L0E7A    lsra
         rorb
         bcc   L0E6B
         clrb
         ldd   <$1A,y
         beq   L0EC2
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
         bhi   L0EC1
         cmpa  <$1D,x
         bcc   L0E9D
         sta   <$1D,x
L0E9D    inca
         sta   ,s
L0EA0    bsr   LockBit
         bcs   L0EA0
         ldb   ,s
         bsr   ReadBit
         bcs   L0EC1
         ldx   $08,y
         ldd   <$17,y
         anda  #$07
         ldy   <$1A,y
         os9   F$DelBit
         ldy   $03,s
         ldb   ,s
         bsr   PUTBIT
         bcc   L0EC2
L0EC1    coma
L0EC2    puls  pc,u,y,x,a

LockBit    lbsr  CLRBUF
         bra   L0ECE
L0EC9    os9   F$IOQu
         bsr   ChkSignl
L0ECE    bcs   L0EDD
         ldx   <$1E,y
         lda   <$17,x
         bne   L0EC9
         lda   $05,y
         sta   <$17,x
L0EDD    rts

ChkSignl    ldu   D.Proc
         ldb   <$19,u
         cmpb  #$01
         bls   L0EEB
         cmpb  #$03
         bls   L0EF2
L0EEB    clra
         lda   $0C,u
         bita  #$02
         beq   L0EF3
L0EF2    coma
L0EF3    rts


PUTBIT    clra
         tfr   d,x
         clrb
         lbsr  PUTSEC
RLSBIT    pshs  cc
         ldx   <$1E,y
         lda   $05,y
         cmpa  <$17,x
         bne   L0F0A
         clr   <$17,x
L0F0A    puls  pc,cc
 page

ReadBit    clra
         tfr   d,x
         clrb
         lbra  GETSEC

WRCP     pshs  u,x
         lbsr  PCPSEC
         bcs   L0F20
         lda   $0A,y
         anda  #$FE
         sta   $0A,y
L0F20    puls  pc,u,x
 page

CHKSEG    ldd   $0C,y
         subd  <$14,y
         tfr   d,x
         ldb   $0B,y
         sbcb  <$13,y
         cmpb  <$19,y
         bcs   L0F3A
         bhi   GETSEG
         cmpx  <$1A,y
         bcc   GETSEG
L0F3A    clrb
         rts

GETSEG    pshs  u
         bsr   GETFD
         bcs   L0F96
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
         beq   GETS10
         addd  <$14,y
         tfr   d,u
         ldb   <$13,y
         adcb  #$00
         cmpb  $0B,y
         bhi   L0F87
         bne   L0F6E
         cmpu  $0C,y
         bhi   L0F87
L0F6E    stb   <$13,y
         stu   <$14,y
         leax  $05,x
         cmpx  ,s
         bcs   FNDS10
GETS10    clra
         clrb
         sta   <$19,y
         std   <$1A,y
         comb
         ldb   #$D5
         bra   L0F96
L0F87    ldd   ,x
         std   <$16,y
         lda   $02,x
         sta   <$18,y
         ldd   $03,x
         std   <$1A,y
L0F96    leas  $02,s
         puls  pc,u
 page

GETDD    pshs  x,b
         lbsr  CLRBUF
         bcs   L0FA9
         clrb
         ldx   #$0000
         bsr   GETSEC
         bcc   L0FAB
L0FA9    stb   ,s
L0FAB    puls  pc,x,b

GETFD    ldb   $0A,y
         bitb  #$04
         bne   L0F3A
         lbsr  CLRBUF
         bcs   L1030
         ldb   $0A,y
         orb   #$04
         stb   $0A,y
         ldb   <$34,y
         ldx   <$35,y

GETSEC    lda   #$03

DEVDIS    pshs  u,y,x,b,a
         lda   $0A,y
         ora   #$20
         sta   $0A,y
         ldu   $03,y
         ldu   $02,u
         bra   L0FD7
L0FD4    os9   F$IOQu
L0FD7    lda   $04,u
         bne   L0FD4
         lda   $05,y
         sta   $04,u
         ldd   ,s
         ldx   $02,s
         pshs  u
         bsr   GODRIV
         puls  u
         ldy   $04,s
         pshs  cc
         lda   $0A,y
         anda  #$DF
         sta   $0A,y
         clr   $04,u
         puls  cc
         bcc   L0FFC
         stb   $01,s
L0FFC    puls  pc,u,y,x,b,a

GODRIV    pshs  pc,x,b,a
         ldx   $03,y
         ldd   ,x
         ldx   ,x
         addd  $09,x
         addb  ,s
         adca  #$00
         std   $04,s
         puls  pc,x,b,a

PUTFD    ldb   <$34,y
         ldx   <$35,y
         bra   PUTSEC

PCPSEC    bsr   GETCP

***************
* Subroutine PUTSEC
*   Put Sector

PUTSEC    lda   #$06
         pshs  x,b,a
         ldd   <$1C,y
         beq   L1029
         ldx   <$1E,y
         cmpd  $0E,x
L1029    puls  x,b,a
         beq   DEVDIS
         comb
         ldb   #$FB
L1030    rts

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

CLRBUF    clrb
         pshs  u,x
         ldb   PD.SMF,y
         andb  #$06
         beq   L1065
         tfr   b,a
         eorb  PD.SMF,y
         stb   PD.SMF,y
         andb  #$01
         beq   L1065
         eorb  PD.SMF,y
         stb   PD.SMF,y
         bita  #$02
         beq   L1065
         bsr   PCPSEC
L1065    puls  pc,u,x

RDCP    pshs  u,x
         lbsr  CHKSEG
         bcs   RDCPXX

***************
* Subroutine GCPSEC
*   Get Current Position

         bsr   CLRBUF
         bcs   RDCPXX
 ifeq RCD.LOCK-included
L1072    ldb   $0B,y
         ldu   $0C,y
         leax  ,y
         ldy   <$30,y
GCPS10    ldx   <$30,x
         cmpy  $05,x
         beq   GCPS90
         ldx   $05,x
         ldx   $01,x
         cmpu  $0C,x
         bne   GCPS10
         cmpb  $0B,x
         bne   GCPS10
         lda   PD.SMF,x
         bita  #$20
         bne   GCPS15
         bita  #$02
         beq   GCPS10
         bra   GCPS20
GCPS15    lda   $05,x
         ldy   $01,y
         os9   F$IOQu
         lbsr  ChkSignl
         bcc   L1072
         bra   RDCPXX

GCPS20    ldy   $01,y
         ldd   PD.Buf,x
         ldu   PD.Buf,y
         std   PD.Buf,y
         stu   PD.Buf,x
         lda   PD.SMF,x
         sta   PD.SMF,y
         clr   PD.SMF,x
         puls  pc,u,x
GCPS90    ldy   $01,y
 endc
         lbsr  GETCP
         lbsr  GETSEC
         bcs   RDCPXX
         lda   PD.SMF,y
         ora   #$02
         sta   PD.SMF,y
RDCPXX    puls  pc,u,x
         emod
RBFEnd      equ   *
