***********************************************
*
* Original edition.
* Known bugs: Unable to use two-sided disks
         nam   DDisk
         TTL   Dragon Disk Driver

         ifp1
         use   defsfile
         endc

NMIVec   EQU   $109
NumDrvs  EQU   4
DensMask EQU   %00000001
T80Mask  EQU   %00000010

P1PDRB   EQU   $FF22
P1PCRB   EQU   $FF23
P0PCRB   EQU   $FF03
ACIAStat EQU   $FF05
ACIACmnd EQU   $FF06

* SelReg Masks
NMIEn    EQU   %00100000
WPCEn    EQU   %00010000
MotorOn  EQU   %00000100
SDensEn  EQU   %00001000

* Disk port locations
SelReg   EQU   $FF48
CmndReg  EQU   $FF40
TrkReg   EQU   $FF41
SecReg   EQU   $FF42
DataReg  EQU   $FF43

* Disk Commands
FrcInt   EQU   %11010000
ReadCmnd EQU   %10001000
RestCmnd EQU   %00000000
SeekCmnd EQU   %00010000
StpICmnd EQU   %01000000
WritCmnd EQU   %10101000
WtTkCmnd EQU   %11110000
Sid2Sel  EQU   %00000010

* Disk Status Bits
BusyMask EQU   %00000001
LostMask EQU   %00000100
ErrMask  EQU   %11111000
CRCMask  EQU   %00001000
RNFMask  EQU   %00010000
RTypMask EQU   %00100000
WPMask   EQU   %01000000
NotRMask EQU   %10000000

* Data Area Defs
         ORG   DRVBEG
         RMB   NumDrvs*DrvMem
CDrvTab  rmb   2
DrvMask  rmb   1
Settle   rmb   1
PIATemp  rmb   1
ACIATemp rmb   1
BufPtr   rmb   2
DatSiz   equ   .

tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $01

         mod   Length,Name,tylg,atrv,Entry,DatSiz

         fcb   $FF

Name     fcs   /DDisk/
         fcb   $03

Entry    lbra  Init
         lbra  Read
         lbra  Write
         lbra  NoErr
         lbra  SetSta
         lbra  NoErr

* Initialisation Routine
Init     clra
         STA   >D.DskTmr   Null the motor time out count
         sta   >SelReg
         ldx   #CmndReg
         lda   #FrcInt
         sta   ,x
         lbsr  Delay
         lda   ,x
         lda   #$FF
         ldb   #NumDrvs
         leax  DrvBeg,u
Init1    sta   ,x
         STA   <V.Trak,X
         leax  <$26,x
         decb
         bne   Init1
         leax  >NMISrv,pcr
         stx   >NMIVec+1
         lda   #$7E
         sta   >NMIVec
         ldd   #$0100
         pshs  u
         os9   F$SRqMem
         tfr   u,x
         puls  u
         bcs   Init2
         stx   >BufPtr,u
         clrb
Init2    rts

NoErr    clrb
         rts

Read     lda   #$91
         cmpx  #$0000
         bne   Read2
         bsr   Read2
         bcs   Read4
         ldx   PD.Buf,y
         pshs  y,x
         ldy   >CDrvTab,u
         ldb   #$14
Read1    lda   b,x
         sta   b,y
         decb
         bpl   Read1
         clrb
         puls  pc,y,x
Read4    rts
Read3    bcc   Read2
         pshs  x,b,a
         lbsr  Reset
         puls  x,b,a
Read2    pshs  x,b,a
         bsr   L00A1
         puls  x,b,a
         bcc   Read4
         lsra
         bne   Read3
L00A1    lbsr  SeekTrk
         bcs   Read4
         ldx   PD.Buf,y
         pshs  y,dp,cc
         ldb   #$88
         bsr   PrDskRW
L00AE    lda   <P1PCRB
         bmi   ReadT2
         leay  -$01,y
         bne   L00AE
         bsr   RecPer
         puls  y,dp,cc
         lbra  E.Read
ReadT3    sync
ReadT2    lda   <DataReg
         ldb   <P1PDRB
         sta   ,x+
         bra   ReadT3

PrDskRW    lda   #$FF
         tfr   a,dp
         lda   <ACIACmnd
         sta   >ACIATemp,u
         anda  #$FE
         sta   <ACIACmnd
         bita  #$40
         beq   PrDsk1
L00D8    lda   <ACIAStat
         bita  #$10
         beq   L00D8
PrDsk1    orcc  #$50
         lda   <P0PCRB
         sta   >PIATemp,u
         lda   #$34
         sta   <P0PCRB
         lda   <ACIACmnd
         anda  #$FE
         sta   <ACIACmnd
         lda   <P1PCRB
         ora   #$03
         sta   <P1PCRB
         lda   <P1PDRB
         ldy   #$FFFF
         lda   #$24
         ora   >DrvMask,u
         stb   <CmndReg
         sta   <SelReg
         rts
RecPer    lda   >DrvMask,u
         ora   #MotorOn
         sta   <SelReg
         lda   >PIATemp,u
         sta   <P0PCRB
         lda   <P1PCRB
         anda  #$FC
         sta   <P1PCRB
         lda   >ACIATemp,u
         sta   <ACIACmnd
         rts

* Write Rtne
Write    lda   #$91
Write2    pshs  x,b,a
         bsr   Write4
         puls  x,b,a
         bcs   Write3
         tst   <PD.Vfy,y
         bne   Write1
         lbsr  Verify
         bcs   Write3
Write1   clrb
         rts
Write3   lsra
         lbeq  E.Write
         bcc   Write2
         pshs  x,b,a
         lbsr  Reset
         puls  x,b,a
         bra   Write2

Write4   lbsr  SeekTrk
         lbcs  Read4
         ldx   PD.Buf,y
         pshs  y,dp,cc
         ldb   #$A8
L0155    lbsr  PrDskRW
         lda   ,x+
Write5   ldb   <P1PCRB
         bmi   Write6
         leay  -1,y
         bne   Write5
         bsr   RecPer
         puls  y,dp,cc
         lbra  E.Write
Write7   lda   ,x+
         sync
Write6   sta   <DataReg
         ldb   <P1PDRB
         bra   Write7

NMISrv   leas  $0C,s
         bsr   RecPer
         puls  y,dp,cc
         ldb   >CmndReg
         bitb  #LostMask
         lbne  E.Read
         lbra  ErrTst

* Verify sector just written
Verify   pshs  x,b,a
         ldx   PD.Buf,y
         pshs  x
         ldx   >BufPtr,u
         stx   PD.Buf,y
         ldx   4,s
         lbsr  L00A1
         puls  x
         stx   PD.Buf,y
         bcs   Verify1
         lda   #$20
         pshs  u,y,a
         ldy   >BufPtr,u
         tfr   x,u
Verify2    ldx   ,u
         cmpx  ,y
         bne   Verify3
         leau  8,u
         leay  8,y
         dec   ,s
         bne   Verify2
         bra   Verify4
Verify3  orcc  #$01
Verify4  puls  u,y,a
Verify1  puls  pc,x,b,a

* Set Head to Required track and sector number
SeekTrk  clr   >Settle,u
         bsr   SelDrv
         tstb
         bne   E.Sect
         tfr   x,d
         ldx   >CDrvTab,u
         cmpd  #$0000
         beq   L01FB
         cmpd  $01,x
         bcs   L01DA
E.Sect   comb
         ldb   #$F1
         rts

L01DA    clr   ,-s
         bra   L01E0
L01DE    inc   ,s
L01E0    subd  #$0012
         bcc   L01DE
         addb  #$12
         puls  a
         cmpa  #$10
         bls   L01FB
         pshs  a
         lda   >DrvMask,u
         ora   #$10
         sta   >DrvMask,u
         puls  a
L01FB    incb
L01FC    stb   >SecReg
         lbsr  Delay
         cmpb  >SecReg
         bne   L01FC
SeekTS   ldb   <V.Trak,x
         stb   >TrkReg
         tst   >Settle,u
         bne   SeekT6
         cmpa  <V.Trak,x
         beq   L022D
SeekT6   sta   <V.Trak,x
         sta   >DataReg
         ldb   #SeekCmnd+Sid2Sel
         bsr   FDCCmnd
         pshs  x
         ldx   #$222E
SeekT7   leax  -1,x
         bne   SeekT7
         puls  x
L022D    clrb
         rts

* Select & start the drive required
SelDrv   lbsr  StrtMot
         lda   <PD.Drv,y
         cmpa  #NumDrvs
         bcs   SelDrv1
         comb
         ldb   #$F0
         rts
SelDrv1    pshs  x,b,a
         sta   >DrvMask,u
         leax  DrvBeg,u
         ldb   #$26
         mul
         leax  d,x
         cmpx  >CDrvTab,u
         beq   SelDrv2
         stx   >CDrvTab,u
         com   >Settle,u
SelDrv2  puls  pc,x,b,a

ErrTst   bitb  #$F8
         beq   ErrTst1
         bitb  #$80
         bne   E.NotRdy
         bitb  #$40
         bne   E.WP
         bitb  #$20
         bne   E.Write
         bitb  #$10
         bne   E.Seek
         bitb  #$08
         bne   E.CRC
ErrTst1  clrb
         rts

E.NotRdy COMB
         LDB   #E$NotRdy
         RTS
E.WP    comb
         ldb   #$F2
         rts
E.Write    comb
         ldb   #$F5
         rts
E.Seek    comb
         ldb   #$F7
         rts
E.CRC    comb
         ldb   #$F3
         rts
E.Read    comb
         ldb   #$F4
         rts

FDCCmnd  bsr   L02A9
FDCC2    ldb   >CmndReg
         bitb  #$01
         beq   L02B1
         lda   #$F0
         sta   >D.DskTmr
         bra   FDCC2
L029C    lda   #MotorOn
         ora   >DrvMask,u
         sta   >SelReg
         stb   >CmndReg
         rts
L02A9    bsr   L029C
Delay    lbsr  L02AE
L02AE    lbsr  L02B1
L02B1    rts

* Rtne called When a Set Status call is made
SetSta   LDX   PD.Rgs,Y     Retrieve request code from u
         LDB   R$B,X
         CMPB  #SS.Reset   Dispatch valid codes
         beq   Reset
         cmpb  #SS.Wtrk
         beq   WTrk
         comb
         LDB   #E$UnkSvc
SetSt1    rts

WTrk     lbsr  SelDrv
         lda   $09,x
         cmpa  #$10
         bls   L02D5
         ldb   >DrvMask,u
         orb   #$10
         stb   >DrvMask,u
L02D5    ldx   >CDrvTab,u
         lbsr  SeekTS
         bcs   SetSt1
         ldx   PD.Rgs,y
         ldx   R$X,x
         ldb   #WtTkCmnd
         pshs  y,dp,cc
         lbra  L0155


Reset    lbsr  SelDrv
         ldx   >CDrvTab,u
         CLR   <V.Trak,X   Set current track as track 0
         lda   #$05
Reset1   LDB   #StpICmnd+Sid2Sel   Step away from track 0 five t
         pshs  a
         lbsr  FDCCmnd
         puls  a
         deca
         bne   Reset1
         LDB   #RestCmnd+Sid2Sel   Now issue Restore to get to t
         bra   FDCCmnd

* Start Drive Motors and wait for them if necessary
StrtMot  pshs  x,b,a
         lda   >D.DskTmr
         bne   Strt1
         lda   #MotorOn
         sta   >SelReg
         ldx   #$A000
Strt2    nop
         nop
         leax  -1,x
         bne   Strt2
Strt1    lda   #$F0
         sta   >D.DskTmr
         puls  pc,x,b,a

         emod
Length   equ   *
