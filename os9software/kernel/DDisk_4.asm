***********************************************
*
         NAM   DragDisk
*         Dragon Disk Device Driver
*         Last edit 9/9/86
*         A modified version of DDisk based
*         on version 00.10 of Andrew Lindley's
*         CCDisk.
*
*
         TTL   Dragon Disk Driver

* Includes of System Definitions
         IFP1
         USE defsfile
         ENDC


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
CDrvTab  RMB   2
DrvMask  RMB   1
Settle   RMB   1
PIATemp  RMB   1
ACIATemp RMB   1
BufPtr   RMB   2
SideSel  RMB   1
DatSiz   EQU   .

         MOD   Length,Name,Type,Att,Entry,DatSiz

Type     EQU   Drivr+Objct
Att      EQU   ReEnt+2
         FCB   $FF               access modes byte
Name     FCS   /DDisk/       Module Name
         FCB   $04               revision byte

Entry    LBRA  Init             Initialise Drive
         LBRA  Read             Read Sector
         LBRA  Write           Write Sector
         LBRA  NoErr           Get Status
         LBRA  SetSta         Set Status
         LBRA  NoErr           Terminate Device

* Initialisation Routine
Init     CLRA
         STA   >D.DskTmr   Null the motor time out count
         STA   >SelReg       deselect all drives and tur
         LDX   #CmndReg     Reset the Controller
         LDA   #FrcInt
         STA   ,X
         LBSR  Delay
         LDA   ,X
         LDA   #$FF
         LDB   #NumDrvs
         LEAX  DrvBeg,U     Set up Device Memory Area so
Init1    STA   DD.Tot,X      First read will work
         STA   <V.Trak,X
         LEAX  <DrvMem,X
         DECB
         BNE   Init1
         LEAX  NMISrv,PCR Set up the NMI Vector
         STX   >NMIVec+1
         LDA   #$7E
         STA   >NMIVec
         LDD   #256             Get a page for verify bu
         PSHS  U
         OS9   F$SRqMem
         TFR   U,X
         PULS  U
         BLO   Init2
         STX   >BufPtr,U
NoErr    CLRB
Init2    RTS

* Read Rtne
Read     LDA   #$91             Retry Count
         CMPX  #0                 Is it LSN 0 ?
         BNE   Read2           No then just do the read
         BSR   Read2           Else do the read and
         BLO   Read4           copy part into the Device
         LDX   PD.Buf,Y
         PSHS  Y,X
         LDY   >CDrvTab,U
         LDB   #DD.Siz-1
Read1    LDA   B,X
         STA   B,Y
         DECB
         BPL   Read1
         CLRB
         PULS  X,Y,PC
Read4    RTS
Read3    BHS   Read2           Retry Entry Point
         PSHS  X,B,A
         LBSR  Reset           Reset to Track 0
         PULS  A,B,X
Read2    PSHS  X,B,A           Normal Entry Point
         BSR   ReadTS
         PULS  A,B,X
         BHS   Read4
         LSRA                           Check for retry,
         BNE   Read3
ReadTS   LBSR  SeekTrk
         BLO   Read4
         LDX   PD.Buf,Y     Target Address for data
         PSHS  Y,DP,CC
         LDB   #ReadCmnd
         BSR   PrDskRW       Prepare to read from disk
ReadT1   LDA   <P1PCRB       Data Ready Status
         BMI   ReadT2         Data Ready so go to the re
         LEAY  -1,Y
         BNE   ReadT1
         BSR   RecPer         Recover previous periphera
         PULS  CC,DP,Y
         LBRA  E.Read
ReadT3   SYNC                           Wait for byte re
ReadT2   LDA   <DataReg       Read data byte
         LDB   <P1PDRB        Clear Data Ready Status Fl
         STA   ,X+               Save data byte
         BRA   ReadT3         go and wait for next byte

PrDskRW  LDA   #$FF             Set up DP Reg for more e
         TFR   A,DP               access of disk control
         LDA   <ACIACmnd   Save current ACIA set up
         STA   >ACIATemp,U
         ANDA  #$FE             Disable ACIA
         STA   <ACIACmnd
         BITA  #$40             Tx interrupts enabled ?
         BEQ   PrDsk1
PrDsk2   LDA   <ACIAStat   wait until any oustanding
         BITA  #$10              characters have been tr
         BEQ   PrDsk2
PrDsk1   ORCC  #IntMasks   Mask Interrupts
         LDA   <P0PCRB       Save current PIA0 set up
         STA   >PIATemp,U
         LDA   #$34
         STA   <P0PCRB
         LDA   <ACIACmnd
         ANDA  #$FE
         STA   <ACIACmnd
         LDA   <P1PCRB       Set up PIA to generate FIRQ
         ORA   #$03              when disk controller ge
         STA   <P1PCRB
         LDA   <P1PDRB       Clear any oustanding interr
         LDY   #$FFFF         Time out count for read
         LDA   #NMIEn+MotorOn
         ORA   >DrvMask,U
         ORB   >SideSel,U Set up Side
         STB   <CmndReg     Issue command to controller
         STA   <SelReg       Turn on selected drive
         RTS

RecPer   LDA   >DrvMask,U Deselect drive but leave motor
         ORA   #MotorOn
         STA   <SelReg
         LDA   >PIATemp,U Recover previous PIA set up
         STA   <P0PCRB
         LDA   <P1PCRB       Disable FIRQ source
         ANDA  #$FC
         STA   <P1PCRB
         LDA   >ACIATemp,U Recover previous ACIA set up
         STA   <ACIACmnd
         RTS

* Write Rtne
Write    LDA   #$91             Retry byte, set bits cau
Write2   PSHS  X,B,A
         BSR   Write4         Do the Write
         PULS  A,B,X
         BLO   Write3         If error goto the Retry ro
         TST   <PD.Vfy,Y   Good write , is verify requir
         BNE   Write1
         BSR   Verify         Yes then do the verify
         BLO   Write3
Write1   CLRB
         RTS
Write3   LSRA                           Retry Entry Poin
         LBEQ  E.Write
         BHS   Write2
         PSHS  X,B,A
         LBSR  Reset
         PULS  A,B,X
         BRA   Write2
Write4   BSR   SeekTrk       Set Track and Sector
         LBLO  Read4
         LDX   PD.Buf,Y     Data address
         PSHS  Y,DP,CC
         LDB   #WritCmnd
WtTkJmp  LBSR  PrDskRW       Prepare for write to disk
         LDA   ,X+               Read data byte to be wr
Write5   LDB   <P1PCRB       Read drive status
         BMI   Write6         Ready, so go to write loop
         LEAY  -1,Y
         BNE   Write5
         BSR   RecPer         Recover previous periphera
         PULS  CC,DP,Y
         LBRA  E.Write
Write7   LDA   ,X+               Read data byte to be wr
         SYNC                           Wait until drive
Write6   STA   <DataReg       Write byte
         LDB   <P1PDRB        Clear Ready Status flag
         BRA   Write7         Go to write next byte

* NMI Service Rtne
NMISrv   LEAS  R$Size,S    Discard old registers
         BSR   RecPer         Recover previous Periphera
         PULS  CC,DP,Y
         LDB   >CmndReg
         BITB  #LostMask   Check for lost record
         LBNE  E.Read
         LBRA  ErrTst         Test for another type of e

* Verify sector just written
Verify   PSHS  X,B,A           Swap the data buffer and
         LDX   PD.Buf,Y      buffer pointers then read b
         PSHS  X                    data just written
         LDX   >BufPtr,U
         STX   PD.Buf,Y
         LDX   4,S
         LBSR  ReadTS
         PULS  X
         STX   PD.Buf,Y
         BLO   Verify1
         LDA   #$20
         PSHS  U,Y,A
         LDY   >BufPtr,U   Compare every 4th word
         TFR   X,U
Verify2  LDX   ,U
         CMPX  ,Y
         BNE   Verify3
         LEAU  8,U
         LEAY  8,Y
         DEC   ,S
         BNE   Verify2
         BRA   Verify4
Verify3  ORCC  #Carry         Error exit
Verify4  PULS  A,Y,U
Verify1  PULS  A,B,X,PC

* Set Head to Required track and sector number
SeekTrk  CLR   >Settle,U   default no settle
         LBSR  SelDrv         select and start correct d
         TSTB
         BNE   E.Sect
         TFR   X,D
         LDX   >CDrvTab,U
         CMPD  #0                 Skip calculation of tr
         BEQ   SeekT1
         CMPD  1,X               Has an illegal LSN been
         BLO   SeekT2
E.Sect   COMB
         LDB   #E$Sect
         RTS
SeekT2   CLR   ,-S               Calculate track number
         SUBD  PD.T0S,Y     subtract no. of sectors in t
         BHS   SeekT4
         ADDB  PD.T0S+1,Y
         BRA   SeekT3
SeekT4   INC   ,S
         SUBD  DD.Spt,X     sectors per track for rest o
         BHS   SeekT4
         ADDB  DD.Spt+1,X
SeekT3   PULS  A
         LBSR  SetWPC         set write precompensation
         PSHS  B
         LDB   DD.Fmt,X     Is the media double sided ?
         LSRB
         BCC   SeekT9         skip if not
         LDB   PD.Sid,Y     Is the drive double sided ?
         DECB
         BNE   SeekT10
         PULS  B                   No then its an error
         COMB
         LDB   #E$BTyp
         RTS
SeekT10  LSRA                           Media & drive ar
         BCC   SeekT9
         BSR   SetSide
         BRA   SeekT9
SeekT1   PSHS  B
SeekT9   LDB   PD.Typ,Y     Dragon and Coco disks
         BITB  #$20              count sectors from 1 no
         BEQ   SeekT8
         PULS  B
         INCB
         BRA   SeekT11
SeekT8   PULS  B                   Count from 0 for othe
SeekT11  STB   >SecReg
         LBSR  Delay
         CMPB  >SecReg
         BNE   SeekT11
SeekTS   LDB   <V.Trak,X   Entry point for SS.WTrk comma
         STB   >TrkReg
         TST   >Settle,U   If settle has been flagged th
         BNE   SeekT5
         CMPA  <V.Trak,X   otherwise check if this is a
         BEQ   SeekT6          track number to the last
SeekT5   STA   <V.Trak,X   Do the seek
         STA   >DataReg
         LDB   #SeekCmnd
         ORB   PD.Stp,Y     Set Step Rate according to P
         BSR   FDCCmnd
         PSHS  X
         LDX   #$222E         Wait for head to settle
SeekT7   LEAX  -1,X
         BNE   SeekT7
         PULS  X
SeekT6   CLRB
         RTS
* Set Side2 Mask
SetSide  PSHS  A
         BCC   Side1           Side 1 if even track no.
         LDA   #Sid2Sel     Odd track no. so side 2
         BRA   Side
Side1    CLRA
Side     STA   >SideSel,U
         PULS  A,PC

* Select & start the drive required
SelDrv   LBSR  StrtMot
         LDA   <PD.Drv,Y   Check its a valid drive
         CMPA  #NumDrvs
         BLO   SelDrv1
E.Unit   COMB
         LDB   #E$Unit
         RTS
SelDrv1  PSHS  X,B,A
         STA   >DrvMask,U
         LEAX  DrvBeg,U     Calculate drives DD table ad
         LDB   #DrvMem
         MUL
         LEAX  D,X
         CMPX  >CDrvTab,U
         BEQ   SelDrv2
         STX   >CDrvTab,U Force seek if its a different
         COM   >Settle,U    the last request
SelDrv2  PULS  A,B,X,PC

* Analyse device status Rtne
ErrTst   BITB  #ErrMask
         BEQ   ErrTst1
         BITB  #NotRMask
         BNE   E.NotRdy
         BITB  #WPMask
         BNE   E.WP
         BITB  #RTypMask
         BNE   E.Write
         BITB  #RNFMask
         BNE   E.Seek
         BITB  #CRCMask
         BNE   E.CRC
ErrTst1  CLRB
         RTS
E.NotRdy COMB
         LDB   #E$NotRdy
         RTS
E.WP     COMB
         LDB   #E$WP
         RTS
E.Write  COMB
         LDB   #E$Write
         RTS
E.Seek   COMB
         LDB   #E$Seek
         RTS
E.CRC    COMB
         LDB   #E$CRC
         RTS
E.Read   COMB
         LDB   #E$Read
         RTS

* Issue a command to the FDC and wait until its ready
FDCCmnd  BSR   FDCC1
FDCC2    LDB   >CmndReg     Poll Disk until its ready
         BITB  #BusyMask
         BEQ   Delay2
         LDA   #$F0
         STA   >D.DskTmr
         BRA   FDCC2
FDCC3    LDA   #MotorOn     send command to drive
         ORA   >DrvMask,U
         STA   >SelReg
         STB   >CmndReg
         RTS
FDCC1    BSR   FDCC3
Delay    LBSR  Delay1         Delay routine
Delay1   LBSR  Delay2
Delay2   RTS

* Rtne called When a Set Status call is made
SetSta   LDX   PD.Rgs,Y     Retrieve request code from u
         LDB   R$B,X
         CMPB  #SS.Reset   Dispatch valid codes
         BEQ   Reset
         CMPB  #SS.Wtrk
         BEQ   WTrk
         COMB                           Unknown code so
         LDB   #E$UnkSvc
SetSt1   RTS

* Write Track routine
WTrk     LBSR  SelDrv
         LDA   R$Y+1,X
         LSRA
         LBSR  SetSide       Set Side 2 if appropriate
         LDA   R$U+1,X
         BSR   SetWPC         Set WPC by disk type
         LDX   >CDrvTab,U
         LBSR  SeekTS         Move head to correct track
         BLO   SetSt1
         LDX   PD.Rgs,Y
         LDX   R$X,X
         LDB   #WtTkCmnd
         PSHS  Y,DP,CC
         LBRA  WtTkJmp       Do the write

* Resets head to track 0
Reset    LBSR  SelDrv
         LDX   >CDrvTab,U
         CLR   <V.Trak,X   Set current track as track 0
         LDA   #5
Reset1   LDB   #StpICmnd   Step away from track 0 five t
         ORB   PD.Stp,Y      Without updating track reg
         PSHS  A                    controller is out of
         LBSR  FDCCmnd
         PULS  A
         DECA
         BNE   Reset1
         LDB   #RestCmnd   Now issue Restore to get to t
         ORB   PD.Stp,Y
         LBRA  FDCCmnd

* Start Drive Motors and wait for them if necessary
StrtMot  PSHS  X,B,A
         LDA   >D.DskTmr   If the timer is 0 then wait f
         BNE   Strt1            motors to get up to spee
         LDA   #MotorOn
         STA   >SelReg
         LDX   #$A000
Strt2    NOP
         NOP
         LEAX  -1,X
         BNE   Strt2
Strt1    LDA   #$F0             Start the motor timer, t
         STA   >D.DskTmr    external to the disk device
         PULS  A,B,X,PC

* Set Write Precompensation according to media type
SetWPC   PSHS  A,B
         LDB   PD.DNS,Y
         BITB  #T80Mask      Is it 96 tpi drive
         BNE   SetWP1
         ASLA                             no then double
SetWP1   CMPA  #32                WPC needed ?
         BLS   SetWP2
         LDA   >DrvMask,U
         ORA   #WPCEn
         STA   >DrvMask,U
SetWP2   PULS  A,B,PC

         EMOD
Length   EQU   *































