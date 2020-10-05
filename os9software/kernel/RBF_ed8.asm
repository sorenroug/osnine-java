 nam Random Block File Manager - Level I
* From Eurohard L1 v.2.0

 ttl Module Header & entries

 use defsfile

Edition equ 8

***************
* Random Block File Manager Module

* Module Header
Type set FLMGR+OBJCT
Revs set REENT+1

* Module Header
Type set FLMGR+OBJCT
Revs set REENT+1
 mod RBFEnd,RBFNam,Type,Revs,RBFEnt,0

RBFNam fcs "Rbf"
 fcb Edition Edition number

* File Manager Constants
DTBSiz fcb DRVMEM Drive tbl size

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
         bne   CRTEX1
         cmpa  #$2F
         beq   CRTEX1
         pshs  x
         ldx   $06,y
         stu   $04,x
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

Create20    std   $0B,s
         ldb   <$16,y
         ldx   <$17,y
         stb   $08,s
         stx   $09,s
         puls  u,x,b,a
         stb   <$16,y
         stx   <$17,y
         sta   <$19,y
         stu   <$1A,y
         ldd   <$3A,y
         std   $0B,y
         ldd   <$3C,y
         std   $0D,y
         lbsr  RdCurDir
         bcs   L00A7
Create12    tst   ,x
         beq   L00BC
         lbsr  RdNxtDir
         bcc   Create12
L00A7    cmpb  #$D3
         bne   CRTEX1
         ldd   #$0020
         lbsr  WriteSub
         bcs   CRTEX1
         lbsr  WrtFDSiz
         lbsr  CLRBUF
         lbsr  RdCurDir

L00BC    leau  ,x
         lbsr  ZerDir
         puls  x
         os9   F$PrsNam
         bcs   CRTEX1
         cmpb  #$1D
         bls   L00CE
         ldb   #$1D
L00CE    clra
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
         bcs   L0144
         ldu   $08,y
         bsr   ZerBuf
         lda   #$04
         sta   $0A,y
         ldx   $06,y
         lda   $02,x
         sta   ,u
         ldx   D.Proc
         ldd   $09,x
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
         beq   L012B
         leax  <$10,u
         std   $03,x
         ldd   $01,s
         addd  #$0001
         std   $01,x
         ldb   ,s
         adcb  #$00
         stb   ,x
L012B    ldb   ,s
         ldx   $01,s
         lbsr  PUTSEC
         bcs   L0144
         lbsr  Remove
         stb   <$34,y
         stx   <$35,y
         lbsr  Insert
         leas  $05,s
         bra   InitPd
L0144    puls  u,x,a
         sta   <$16,y
         stx   <$17,y
         clr   <$19,y
         stu   <$1A,y
         pshs  b
         lbsr  SECDEA
         puls  b
CRTERR99    lbra  KillPth0
***************
* Subroutines ZerDir, ZerBuf
*   Zero Dir size rcd, or buffer
* Record size MUST be evenly divisive by 4

* Passed: (U)=rcd ptr
* Destroys: CC

ZerDir pshs u,x,D
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

Open    pshs  y
         lbsr  SchDir
         bcs   CRTERR99

         ldu   $06,y
         stx   $04,u
         ldd   <$35,y
         bne   Open15
         lda   <$34,y
         bne   Open15
         ldb   $01,y
         andb  #$80
         lbne  L0273
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

Open15    lda   $01,y
         lbsr  CHKACC
         bcs   CRTERR99

InitPd    puls  y
L01BC    clra
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
         std   $0F,y
         stx   <$11,y
         clrb
         rts

 page
***************
* Subroutine Makdir
*   Creates A New (Sub-Ordinate) Dir

* Passed: (Y)=PD

MakDir    lbsr  Create
         bcs   MakDir90
         ldd   #$0040
         std   <$11,y
         bsr   WrtFDS90
         bcs   MakDir90
         lbsr  EXPAND
         bcs   MakDir90
         ldu   $08,y
         lda   ,u
         anda  #$BF
         ora   #$80
         sta   ,u
         bsr   WrtFDSiz
         bcs   MakDir90
         lbsr  ZerBuf
         ldd   #$2EAE
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
*   Update file size in FD sector.  Called by Create, Makdir.

WrtFDSiz    lbsr  GETFD
L023A    ldx   $08,y
         ldd   $0F,y
         std   $09,x
         ldd   <$11,y
         std   $0B,x
         clr   $0A,y
WrtFDS90    lbra  PUTFD

 page
***************
* Subroutine Close
*   Close Path, Update FD if necessary

Close    clra
         tst   $02,y
         bne   L0272
         ldb   $01,y
         bitb  #$02
         beq   KillPth1
         lbsr  CLRBUF
         bcs   KillPth1
         ldd   <$34,y
         bne   L0264
         lda   <$36,y
         beq   KillPth1
L0264    bsr   DateMod
         bsr   L023A
         lbsr  L0513
         bcc   KillPth1
         lbsr  TRIM
         bra   KillPth1
L0272    rts

L0273    ldb   #$D6
KillPth0    coma

KillPth    puls  y
KillPth1    pshs  b,cc
         ldu   $08,y
         beq   L0284
         ldd   #$0100
         os9   F$SRtMem

L0284    puls  pc,b,cc

DateMod    lbsr  GETFD
         ldu   $08,y
         lda   $08,u
         pshs  a
         leax  $03,u
         os9   F$Time
         puls  a
         sta   $08,u
         rts

***************
* Subroutine Chgdir
*   Change User'S Current Working Dir

* Passed: (Y)=PD

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
         beq   L02BD
         ldb   <$34,y
         std   <$1C,x
         stu   <$1E,x
L02BD    ldb   $01,y
         bitb  #$04
         beq   L02CC
         ldb   <$34,y
         std   <$22,x
         stu   <$24,x
L02CC    clrb
         bra   KillPth

 page
***************
* Subroutine Delete

Delete    pshs  y
         lbsr  SchDir
         bcs   KillPth
         ldd   <$35,y
         bne   L02E0
         tst   <$34,y
         beq   L0273
L02E0    lda   #$42
         lbsr  CHKACC
         bcs   Delete99
         ldu   $06,y
         stx   $04,u
         lbsr  GETFD
         bcs   Delete99
         ldx   $08,y
         dec   $08,x
         beq   L02FB
         lbsr  PUTFD
         bra   Delete20
L02FB    clra
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
         lbsr  Insert
         lbsr  GETFD
         bcs   Delete99
         lbsr  L01BC
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

Seek    ldb   $0A,y
         bitb  #$02
         beq   L0370
         lda   $05,u
         ldb   $08,u
         subd  $0C,y
         bne   L036B
         lda   $04,u
         sbca  $0B,y
         beq   L0374
L036B    lbsr  CLRBUF
         bcs   Seek99
L0370    ldd   $04,u
         std   $0B,y
L0374    ldd   $08,u
         std   $0D,y
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

ReadLn    bsr   ReadInit
         bsr   ReadLn10
         pshs  u,y,x,b,a
         exg   x,u
         ldy   #$0000
         lda   #$0D
L0387    leay  $01,y
         cmpa  ,x+
         beq   L0390
         decb
         bne   L0387
L0390    ldx   $06,s
         bsr   ToUser
         sty   $0A,s
         puls  u,y,x,b,a
         ldd   $02,s
         leax  d,x
         rts

ReadLn10    bsr   RBRW00
         lda   ,-x

         cmpa  #$0D
         beq   ReadLn20
         ldd   $02,s
         bne   L0407
ReadLn20    ldu   $06,y
         ldd   $06,u
         subd  $02,s
         std   $06,u
         leas  $08,s
         rts

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
         bcs   L03E2
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
         bcs   L03DF
         bne   L03DC
         tstb
         bne   L03DC
         cmpx  ,s
         bcc   L03DC
         stx   ,s
         beq   L03DF
L03DC    clrb
         puls  pc,b,a
L03DF    comb
         ldb   #$D3
L03E2    leas  $02,s
         rts

ToUser    lbra  FromUser

***************
* Subroutine Read
*   Read Requested Bytes from Current Position

Read    bsr   ReadInit
         bsr   Read1
L03EC    pshs  u,y,x,b,a
         exg   x,u
         tfr   d,y
         bsr   ToUser
         puls  u,y,x,b,a
         leax  d,x
         rts

Read1    bsr   RBRW00
         bne   L0407
         clrb
RBRWER    leas  $08,s
         rts
 page
***************
* Subroutine RBRW
*   Transfer Loop of Read & Write

*   S.Destin,S = Destination addr
*   S.BytCnt,S = Bytecount
*   S.RWexit,S = R/W subroutine addr
*   S.RWaddr,S = R/W endloop addr

RBRW00    ldd   $04,u
         ldx   $06,u
         pshs  x,b,a
L0407    lda   $0A,y
         bita  #$02
         bne   L042B
         lbsr  CLRBUF
         bcs   RBRWER
         tst   $0E,y
         bne   L0426
         tst   $02,s
         beq   L0426
         leax  <L048D,pcr
         cmpx  $06,s
         bne   L0426
         lbsr  CHKSEG
         bra   L0429
L0426    lbsr  RDCP
L0429    bcs   RBRWER
L042B    ldu   $08,y
         clra
         ldb   $0E,y
         leau  d,u
         negb
         sbca  #$FF
         ldx   ,s
         cmpd  $02,s
         bls   L043E
         ldd   $02,s
L043E    pshs  b,a
         jsr   [<$08,s]
         stx   $02,s
         ldb   $01,s
         addb  $0E,y
         stb   $0E,y
         bne   L045A
         lbsr  CLRBUF
         inc   $0D,y
         bne   L045A
         inc   $0C,y
         bne   L045A
         inc   $0B,y
L045A    ldd   $04,s
         subd  ,s++
         std   $02,s
         jmp   [<$04,s]

 page
***************
* Subroutine Writline
*   Write Bytes to carriage return or Maximum

WritLine    pshs  y
         clrb
         ldy   $06,u
         beq   L0481
         ldx   $04,u
L046D    leay  -$01,y
         beq   L0481
         lda   ,x+
         cmpa  #$0D
         bne   L046D
         tfr   y,d
         nega
         negb
         sbca  #$00
         addd  $06,u
         std   $06,u
L0481    puls  y
* Fall through to Write

***************
* Subroutine Write
* Write Requested Bytes At Current Position

Write    ldd   $06,u
         beq   L04A7
         bsr   WriteSub
         bcs   L04A8
         bsr   Write1
L048D    pshs  y,b,a
         tfr   d,y
         bsr   FromUser
         puls  y,b,a
         leax  d,x
         lda   $0A,y
         ora   #$03
         sta   $0A,y
         rts
Write1    lbsr  RBRW00
         lbne  L0407
         leas  $08,s
L04A7    clrb
L04A8    rts

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
WriteS10    cmpd  $0F,y
         bcs   L04A7
         bhi   L04BF
         cmpx  <$11,y
         bls   L04A7
L04BF    pshs  u
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

FromUser    pshs  u,y,x
         ldd   $02,s
         beq   L0504
         leay  d,u
         lsrb
         bcc   L04EA
         lda   ,x+
         sta   ,u+
L04EA    lsrb
         bcc   L04F1
         ldd   ,x++
         std   ,u++
L04F1    pshs  y
         exg   x,u
         bra   L04FE
L04F7    pulu  y,b,a
         std   ,x++
         sty   ,x++
L04FE    cmpx  ,s
         bcs   L04F7
         leas  $02,s
L0504    puls  pc,u,y,x


 page
***************
* Subroutine Getstat
*   Get Specific Status Information

GetStat ldb R$B,U get status code
 cmpb #SS.OPT options?
         beq   L052C
         cmpb  #$06
         bne   L0518
         clr   $02,u
         clra
L0513    ldb   #$01
         lbra  RDSET
L0518    cmpb  #$01
         bne   L051F
         clr   $02,u
         rts
L051F    cmpb  #$02
         bne   L052D
         ldd   $0F,y
         std   $04,u
         ldd   <$11,y
         std   $08,u
L052C    rts
L052D    cmpb  #$05
         bne   L053A
         ldd   $0B,y
         std   $04,u
         ldd   $0D,y
         std   $08,u
         rts
L053A    cmpb  #$0F
         bne   L0554
         lbsr  GETFD
         bcs   L052C
         ldu   $06,y
         ldd   $06,u
         tsta
         beq   L054D
         ldd   #$0100
L054D    ldx   $04,u
         ldu   $08,y
         lbra  L03EC
L0554    lda   #$09
         lbra  DEVDIS

 page
***************
* Subroutine Putstat
*   Set Specific Status Information

PutStat  ldb   $02,u
         cmpb  #$00
         bne   L056D
         ldx   $04,u
         leax  $02,x
         leau  <$22,y
         ldy   #$000D
         lbra  FromUser
L056D    cmpb  #SS.Size
         bne   L05AD
         ldd   <$35,y
         bne   L057B
         tst   <$34,y
         beq   L05B2
L057B    lda   $01,y
         bita  #$02
         beq   L05A9
         ldd   $04,u
         ldx   $08,u
         cmpd  $0F,y
         bcs   L0594
         bne   L0591
         cmpx  <$11,y
         bcs   L0594
L0591    lbra  WriteS10
L0594    std   $0F,y
         stx   <$11,y
         ldd   $0B,y
         ldx   $0D,y
         pshs  x,b,a
         lbsr  TRIM
         puls  u,x
         stx   $0B,y
         stu   $0D,y
         rts
L05A9    comb
         ldb   #$CB
         rts

L05AD    lda   #$0C
         lbra  DEVDIS

L05B2    comb
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
         stb   $0A,y
         os9   F$SRqMem
         bcs   Return99
         stu   $08,y
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
         leau  <$1A,u
         bita  #$24
         beq   L0606
         leau  $06,u
L0606    ldb   $03,u
         stb   <$34,y
         ldd   $04,u
         std   <$35,y
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
         bne   SchDir35
         leax  $01,x
         bra   L0653

SchDir35    lbsr  GETDD
         lbcs  DirErr10
         ldu   $08,y
         ldd   $0E,u
         std   <$1C,y
         ldd   <$35,y
         bne   L0653
         lda   <$34,y
         bne   L0653
         lda   $08,u
         sta   <$34,y
         ldd   $09,u
         std   <$35,y

L0653    stx   $04,s
         stx   $08,s
L0657    lbsr  CLRBUF
         lbsr  Insert
         bcs   DirErr10
         lda   ,s
         cmpa  #$2F
         bne   L06BA
         clr   $02,s
         clr   $03,s
         lda   $01,y
         ora   #$80
         lbsr  CHKACC
         bcs   DirErr
         lbsr  L01BC
         ldx   $08,s
         leax  $01,x
         lbsr  RBPNam
         std   ,s
         stx   $04,s
         sty   $08,s
         ldy   $06,s
         bcs   DirErr
         lbsr  RdCurDir
         bra   L0691
L068D    bsr   SaveDel
L068F    bsr   RdNxtDir
L0691    bcs   DirErr
         tst   ,x
         beq   L068D
         leay  ,x
         ldx   $04,s
         ldb   $01,s
         clra
         os9   F$CmpNam
         ldx   $06,s
         exg   x,y
         bcs   L068F
         bsr   SaveDir
         lda   <$1D,x
         sta   <$34,y
         ldd   <$1E,x
         std   <$35,y
         lbsr  Remove
         bra   L0657
L06BA    ldx   $08,s
         tsta
         bmi   L06C7
         os9   F$PrsNam
         leax  ,y
         ldy   $06,s
L06C7    stx   $04,s
         clra
L06CA    lda   ,s
         leas  $04,s
         puls  pc,u,y,x
DirErr    cmpb  #$D3
         bne   DirErr10
         bsr   SaveDel
         ldb   #$D8
DirErr10    coma
         bra   L06CA

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

SaveDel    pshs  b,a
         lda   $04,s
         cmpa  #$2F
         beq   L0703
         ldd   $06,s
         bne   L0703
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
L0703    puls  pc,b,a

 page
***************
* Subroutine RdNxtDir
*   Read Current or next dir rcd

* Passed: (Y)=PD
* Returns: (X)=Dir Rcd ptr
* Destroys: (D)
* Error: CC=carry set
*       (B)=Error code

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
         lda   $0A,y
         bita  #$02
         bne   L0732
         lbsr  CHKSEG
         bcs   RdNxtD90
         lbsr  RDCP
         bcs   RdNxtD90
L0732    ldb   $0E,y
         lda   $08,y
         tfr   d,x
         clrb
RdNxtD90    rts

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
         bcc   L0769
         clrb
L0742    pshs  a
         anda  #$7F
         cmpa  #$2E
         puls  a
         bne   L075D
         incb
         leax  $01,x
         tsta
         bmi   L075D
         lda   ,x
         cmpb  #$03
         bcs   L0742
         lda   #$2F
         decb
         leax  -$03,x
L075D    tstb
         bne   L0765
         comb
         ldb   #$D7
         puls  pc,x
L0765    leay  ,x
         andcc #$FE
L0769    puls  pc,x
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
         bcs   L079A
         ldu   $08,y
         ldx   D.Proc
         ldd   $09,x
         beq   L0783
         cmpd  $01,u
L0783    puls  a
         beq   L078A
         lsla
         lsla
         lsla
L078A    ora   ,s
         anda  #$BF
         pshs  a
         ora   #$80
         anda  ,u
         cmpa  ,s
         beq   L07A3
         ldb   #$D6
L079A    leas  $02,s
         coma
         puls  pc,x
         ldb   #$FD
         bra   L079A
L07A3    puls  pc,x,b,a

Insert    clra
         clrb
         std   $0B,y
         std   $0D,y
         sta   <$19,y
         std   <$1A,y
Remove    rts

 page
***************
* Subroutine Expand
* Expand File Size, Allocate Storage

* Passed: (Y)=PD
* Returns: None
* Destroys: CC,D,X

EXPAND    pshs  u,x
L07B4    bsr   EXPSUB
         bne   EXPA15
         cmpx  <$1A,y
         bcs   EXPA45
         bne   EXPA15
         lda   <$12,y
         beq   EXPA45
EXPA15    lbsr  GETFD
         bcs   L0808
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
         bne   L0808
         bsr   EXPSUB
         bne   L07F4
         tst   <$12,y
         beq   L07F7
         leax  $01,x
         bne   L07F7
L07F4    ldx   #$FFFF
L07F7    tfr   x,d
         tsta
         bne   L0804
         cmpb  <$2E,y
         bcc   L0804
         ldb   <$2E,y
L0804    bsr   SEGALL
         bcc   L07B4
L0808    coma
         puls  pc,u,x

EXPA45    lbsr  CHKSEG
         puls  pc,u,x

EXPSUB    ldd   <$10,y
         subd  <$14,y
         tfr   d,x
         ldb   $0F,y
         sbcb  <$13,y
         rts

***************
* Subroutine SEGALL
* Segment Allocation

* Passed: (D)=Number Sectors
*         (Y)=PD
* Returns: CC Carry Set On Error
* Destroys: D

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
         beq   L08A2
         ldd   $08,y
         inca
         pshs  b,a
         bra   L084D
L0840    clrb
         ldd   -$02,x
         beq   EMPS30
         addd  $0A,u
         std   $0A,u
         bcc   L084D
         inc   $09,u
L084D    leax  $05,x
         cmpx  ,s
         bcs   L0840
         comb
         ldb   #$D9
EMPS30    leas  $02,s
         leax  -$05,x
SEGALErr    bcs   SEGA30
         ldd   -$04,x
         addd  -$02,x
         pshs  b,a
         ldb   -$05,x
         adcb  #$00
         cmpb  <$16,y
         puls  b,a
         bne   L08A2
         cmpd  <$17,y
         bne   L08A2
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
         bne   L08A2
         ldd   -$02,x
         addd  <$1A,y
         bcs   L08A2
         std   -$02,x
         bra   L08B1
L08A2    ldd   <$16,y
         std   ,x
         lda   <$18,y
         sta   $02,x
         ldd   <$1A,y
         std   $03,x
L08B1    ldd   $0A,u
         addd  <$1A,y
         std   $0A,u
         bcc   L08BC
         inc   $09,u
L08BC    lbsr  PUTFD
SEGA30    puls  pc,u,x
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

SECALL    pshs  u,y,x,b,a
         ldb   #$0D
L08C5    clr   ,-s
         decb
         bne   L08C5
         ldx   <$1E,y
         ldd   $04,x
         std   $05,s
         ldd   $06,x
         std   $03,s
         std   $0B,s
         ldx   $03,y
         ldx   $04,x
         leax  <$12,x
         subd  #$0001
         addb  $0E,x
         adca  #$00
         bra   L08E9
SECA07    lsra
         rorb
L08E9    lsr   $0B,s
         ror   $0C,s
         bcc   SECA07
         std   $01,s
         ldd   $03,s
         std   $0B,s
         subd  #$0001
         addd  $0D,s
         bcc   SECA12
         ldd   #$FFFF
         bra   SECA12
L0901    lsra
         rorb
SECA12    lsr   $0B,s
         ror   $0C,s
         bcc   L0901
         cmpa  #$08
         bcs   SECA13
         ldd   #$0800
SECA13    std   $0D,s

         lbsr  LockBit
         lbcs  L0A0A
         ldx   <$1E,y
         ldd   <$1A,x
         cmpd  $0E,x
         bne   L0942
         lda   <$1C,x
         cmpa  $04,x
         bne   L0942
         ldd   $0D,s
         cmpd  $01,s
         bcs   SECA15
         lda   <$1D,x
         cmpa  $04,x
         bcc   L0942
         sta   $07,s
         nega
         adda  $05,s
         sta   $05,s
         bra   SECA15

L0942    ldd   $0E,x
         std   <$1A,x
         lda   $04,x
         sta   <$1C,x
         clr   <$1D,x
SECA15    inc   $07,s
         ldb   $07,s
         lbsr  L0B8D
         lbcs  L0A0A
         ldd   $05,s
         tsta
         beq   L0962
         ldd   #$0100
L0962    ldx   $08,y
         leau  d,x
         ldy   $0D,s
         clra
         clrb
         os9   F$SchBit
         pshs  b,a,cc
         tst   $03,s
         bne   L097D
         cmpy  $04,s
         bcs   L097D
         lda   $0A,s
         sta   $03,s
L097D    puls  b,a,cc
         bcc   L09B0
         cmpy  $09,s
         bls   L098F
         sty   $09,s
         std   $0B,s
         lda   $07,s
         sta   $08,s
L098F    ldy   <$11,s
         tst   $05,s
         beq   L099B
         dec   $05,s
         bra   SECA15

L099B    ldb   $08,s
         beq   L0A08
         clra
         cmpb  $07,s
         beq   L09A9
         stb   $07,s
         lbsr  L0B8D
L09A9    ldx   $08,y
         ldd   $0B,s
         ldy   $09,s
L09B0    std   $0B,s
         sty   $09,s
         os9   F$AllBit
         ldy   <$11,s
         ldb   $07,s
         lbsr  L0B75
         bcs   L0A0A
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
         bra   L09FE
L09EF    lsl   <$18,y
         rol   <$17,y
         rol   <$16,y
         lsl   <$1B,y
         rol   <$1A,y
L09FE    lsra
         rorb
         bcc   L09EF
         clrb
         ldd   <$1A,y
         bra   SECA90
L0A08    ldb   #$F8
L0A0A    ldy   <$11,s
         lbsr  L0B7C
         coma
SECA90    leas  $0F,s
         puls  pc,u,y,x
 page
***************
* Subroutine Trim
*   Trim File Size, Deallocate Any Excess

* Passed: (Y)=PD
* Returns: None
* Destroys: CC,D,X,U

TRIM    clra
         lda   $01,y
         bita  #$80
         bne   L0A78
         ldd   $0F,y
         std   $0B,y
         ldd   <$11,y
         std   $0D,y
         lbsr  GETSEG
         bcc   L0A2F
         cmpb  #$D5
         bra   TRIM29

L0A2F    ldd   <$14,y
         subd  $0C,y
         addd  <$1A,y
         tst   $0E,y
         beq   TRIM20
         subd  #$0001
TRIM20    pshs  b,a
         ldu   <$1E,y
         ldd   $06,u
         subd  #$0001
         coma
         comb
         anda  ,s+
         andb  ,s+
         ldu   <$1A,y
         std   <$1A,y
         beq   L0A72
         tfr   u,d
         subd  <$1A,y
         pshs  x,b,a
         addd  <$17,y
         std   <$17,y
         bcc   L0A68
         inc   <$16,y
L0A68    bsr   SECDEA
         bcc   L0A79
         leas  $04,s
         cmpb  #$DB
TRIM29    bne   TrimErr
L0A72    lbsr  GETFD
         bcc   TRIM50
TrimErr    coma
L0A78    rts
L0A79    lbsr  GETFD
         bcs   L0AD2
         puls  x,b,a
         std   $03,x
TRIM50    ldu   $08,y
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

L0A97    ldd   -$02,x
         beq   L0ACA
         std   <$1A,y
         ldd   -$05,x
         std   <$16,y
         lda   -$03,x
         sta   <$18,y
         bsr   SECDEA
         bcs   L0AD2
         stx   $02,s
         lbsr  GETFD
         bcs   L0AD2
         ldx   $02,s
         clra
         clrb
         std   -$05,x
         sta   -$03,x
         std   -$02,x
TRIM65    lbsr  PUTFD
         bcs   L0AD2
         ldx   $02,s
         leax  $05,x
         cmpx  ,s
         bcs   L0A97
L0ACA    clra
         clrb
         sta   <$19,y
         std   <$1A,y
L0AD2    leas  $04,s
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
         ldx   <$1E,y
         ldd   $06,x
         subd  #$0001
         addd  <$17,y
         std   <$17,y
         ldd   $06,x
         bcc   L0AFD
         inc   <$16,y
         bra   L0AFD
L0AEE    lsr   <$16,y
         ror   <$17,y
         ror   <$18,y
         lsr   <$1A,y
         ror   <$1B,y
L0AFD    lsra
         rorb
         bcc   L0AEE
         clrb
         ldd   <$1A,y
         beq   L0B45
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
         bhi   L0B44
         cmpa  <$1D,x
         bcc   L0B20
         sta   <$1D,x
L0B20    inca
         sta   ,s
L0B23    bsr   LockBit
         bcs   L0B23
         ldb   ,s
         bsr   L0B8D
         bcs   L0B44
         ldx   $08,y
         ldd   <$17,y
         anda  #$07
         ldy   <$1A,y
         os9   F$DelBit
         ldy   $03,s
         ldb   ,s
         bsr   L0B75
         bcc   L0B45
L0B44    coma
L0B45    puls  pc,u,y,x,a
LockBit    lbsr  CLRBUF
         bra   L0B51
L0B4C    os9   F$IOQu
         bsr   L0B61
L0B51    bcs   L0B60
         ldx   <$1E,y
         lda   <$17,x
         bne   L0B4C
         lda   $05,y
         sta   <$17,x
L0B60    rts
L0B61    ldu   D.Proc
         ldb   <$36,u
         beq   L0B6C
         cmpb  #$03
         bls   L0B73
L0B6C    clra
         lda   $0D,u
         bita  #$02
         beq   L0B74
L0B73    coma
L0B74    rts
L0B75    clra
         tfr   d,x
         clrb
         lbsr  PUTSEC
L0B7C    pshs  cc
         ldx   <$1E,y
         lda   $05,y
         cmpa  <$17,x
         bne   L0B8B
         clr   <$17,x
L0B8B    puls  pc,cc
L0B8D    clra
         tfr   d,x
         clrb
         lbra  GETSEC
RDCP    pshs  u,x
         bsr   CHKSEG
         bcs   L0BA5
         lbsr  L0C5A
         bcs   L0BA5
         lda   $0A,y
         ora   #$02
         sta   $0A,y
L0BA5    puls  pc,u,x

         pshs  u,x
         lbsr  PCPSEC
         bcs   L0BB4
         lda   $0A,y
         anda  #$FE
         sta   $0A,y
L0BB4    puls  pc,u,x

 page
***************
* Subroutine Chkseg
*   Check Segment ptrs For Current Position

CHKSEG    ldd   $0C,y
         subd  <$14,y
         tfr   d,x
         ldb   $0B,y
         sbcb  <$13,y
         cmpb  <$19,y
         bcs   L0BCE
         bhi   GETSEG
         cmpx  <$1A,y
         bcc   GETSEG
L0BCE    clrb
         rts

***************
* Subroutine GETSEG
*   Get Segment Containing Current Position

* Passed: (Y)=PD ptr
* Returns: CC Carry set if no segment found
* Destroys: D

GETSEG    pshs  u
         bsr   GETFD
         bcs   GETS30
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
         bhi   L0C1B
         bne   L0C02
         cmpu  $0C,y
         bhi   L0C1B
L0C02    stb   <$13,y
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
         bra   GETS30
L0C1B    ldd   ,x
         std   <$16,y
         lda   $02,x
         sta   <$18,y
         ldd   $03,x
         std   <$1A,y
GETS30    leas  $02,s
         puls  pc,u

GETDD    pshs  x,b
         lbsr  CLRBUF
         bcs   L0C3D
         clrb
         ldx   #$0000
         bsr   GETSEC
         bcc   L0C3F
L0C3D    stb   ,s
L0C3F    puls  pc,x,b
GETFD    ldb   $0A,y
         bitb  #$04
         bne   L0BCE
         lbsr  CLRBUF
         bcs   L0CBB
         ldb   $0A,y
         orb   #$04
         stb   $0A,y
         ldb   <$34,y
         ldx   <$35,y
         bra   GETSEC

L0C5A    bsr   CLRBUF
         bcs   L0CBB
         bsr   GETCP

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
         ldu   $03,y
         ldu   $02,u
         bra   L0C6D
L0C6A    os9   F$IOQu
L0C6D    lda   $04,u
         bne   L0C6A
         lda   $05,y
         sta   $04,u
         ldd   ,s
         ldx   $02,s
         pshs  u
         bsr   GODRIV
         puls  u
         lda   #$00
         sta   $04,u
         bcc   L0C87
         stb   $01,s
L0C87    puls  pc,u,y,x,b,a

GODRIV    pshs  pc,x,b,a
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
PCPSEC    bsr   GETCP
* Fall into PUTSEC

***************
* Subroutine PUTSEC
*   Put Sector

PUTSEC    lda   #$06
         pshs  x,b,a
         ldd   <$1C,y
         beq   L0CB4
         ldx   <$1E,y
         cmpd  $0E,x
L0CB4    puls  x,b,a
         beq   DEVDIS
         comb
         ldb   #$FB
L0CBB    rts

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

CLRBUF    clrb
         pshs  u,x
         ldb   $0A,y
         andb  #$06
         beq   CLRB10
         tfr   b,a
         eorb  $0A,y
         stb   $0A,y
         andb  #$01
         beq   CLRB10
         eorb  $0A,y
         stb   $0A,y
         bita  #$02
         beq   CLRB10
         bsr   PCPSEC
CLRB10    puls  pc,u,x
         emod
RBFEnd      equ   *
