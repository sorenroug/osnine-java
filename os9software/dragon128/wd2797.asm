 nam WD2797
 TTL Floppy disk driver with bootstrap

****************************************
*
* Floppy disc driver with bootstrap routine
* for the Western Digital 2797 disc controller.
*
* For the Dragon 128 computer.
*
* last mod 21/12/83
*
****************************************

****************************************
*
* The boot routine is an extension to
* OS-9 standard disc driver capabilities.
* The entry point is the 7th entry in the
* branch table, The bootstrap routine expects
* the Y register to contain the address of
* the Device Descriptor for the boot device.
*
* This driver can handle both mini and
* full-size drives, provided the appropiate
* bit is set in the Device Descriptor.
*
* This driver can handle discs formatted with
* 128 byte sectors. The first sector on each
* track must be sector 1. The Device
* Descriptor 'sectors per track' entries must
* contain the number of sectors per track
* divided by two, and bit 5 of the DD.TYP
* entry must be set, (this is an extension
* to the standard OS-9 definitions for this
* byte). Bit 6 should also be set, to indicate
* Non-OS9 Format.
*
*
* Written by Paul Dayan of Vivaway Ltd
*
* History:
* Written 3rd November 1983
*
****************************************
    
 use defsfile

 TTL Floppy disk driver with bootstrap

Drvcnt SET 4 Four Drives
FULLSIZE equ 1 include 8" drives
DDTRACK0 equ 1 single and double density on track 0
DBLTRACK equ 1 single and double track density
TRYBOTH equ 0 get track 0 density info from PD
EXTFMT equ 1 multiple formats
HLFSECT equ 1 256 and 128 byte sectors
DBLSIDE equ 1 single and double sided
STEPIN equ 1 step in before restore

 ifeq EXTFMT
 endc


 org 0
u0000    rmb   1
XV.Port    rmb   1
u0002    rmb   1
u0003    rmb   1
u0004    rmb   1
XV.Wake    rmb   1
u0006    rmb   2
u0008    rmb   1
u0009    rmb   1
u000A    rmb   2
u000C    rmb   1
u000D    rmb   1

 ORG Drvbeg reserve RBF static storage
 RMB Drvmem*Drvcnt drive tables
V.Cdrv RMB 2 address of current drive table
V.Vbuff RMB 2 address of verify buffer
V.Wrtf    RMB   1 write type flag
V.Wait    RMB   1 'can wait by sleeping' flag
V.Active RMB   1 'command in progress' flag
V.Status RMB   1 FDC status register
V.T0stk RMB   2 sectors on track 0
V.Stk RMB   2 sectors per track
V.Drive  RMB   2 current drive number
V.Lsn    RMB   2 logical sector number
V.Fmt    RMB   1 drive type and disk format
V.TwoStp rmb   1 double stepping flag
V.Timer rmb 1 motor off timer
V.Cmd rmb 1 command code
V.Sector rmb 1 sector number
V.CrTrk    rmb   1 current track
V.Buff RMB 2 address of read/write buffer
V.Bytc RMB 2 number of bytes to transfer
V.Step RMB   1 step rate in ms
V.Track rmb   1 required track
V.Select rmb 1 current select register
V.NewTrk rmb 1 'new track' flag
 ifne DBLSIDE
V.Side rmb 1 required head
 endc
V.Freeze    rmb   1 freeze drive table flag
 ifne DDTRACK0
V.DDTr0    rmb   1 double density on track 0 flag
 endc

 ifne DBLSIDE
Dblsid SET 1 double sided bit
 endc
 ifne EXTFMT
Dblden SET 2 double density bit
 endc
 ifne DBLTRACK
Dbltrk SET 4
 endc
 ifne HLFSECT
Hlfsec SET 8
 endc
 ifne DDTRACK0
DDTr0 set 16 double density on track 0
 endc


Dskmem equ .
Btmem equ Dskmem-V.Wrtf Memory for bootstrap

*
* Controller commands
*
F.WRIT equ $A8 write sector
F.READ equ $88 read sector
F.SEEK equ $18 seek
F.STPI equ $48 step in
F.REST equ $08 restore
F.WRTR equ $F0 write track
F.TERM equ $D0 forced terminate
*
* Controller registers
*
 org 0
STTREG equ . status register
CMDREG rmb 1 command register
TRKREG rmb 1 track register
SECREG rmb 1 sector register
DATREG rmb 1 data register
*
* PIA equates
*
SELREG equ A.DskSel select register
INTPIA equ DAT.Task interrupt port data reg
INTBIT equ $80 interrupt flag bit
B.Motor equ $10 motor-on bit
B.PreCmp equ $20 precomp-on bit
B.DblDen equ $40 double density on bit
*
* Timings
*
MotTim equ 250 5 second motor on
RdyTim equ 12 1.2 sec pause after motor on
TickOut equ 200 abort timeout
*
* Precompensation track
*
PrcTrk40 equ 16 for 40 track
 ifne DBLTRACK
PrcTrk80 equ 40
 endc

Type set drivr+objct
Revs set reent+1


 MOD Dkend,Dknam,Type,Revs,Dkent,Dskmem
 FCB $FF

Dknam FCS 'wd2797'
 FCB 1 Edition

*Entry Table
Dkent lbra Idisk
 lbra Read
 lbra Write
 lbra Gstat
 lbra Pstat
 lbra Term
 lbra Boot

Fdcpol   fcb 0,INTBIT,128

Maxcyl equ 40
Scttrk equ 18
Trkcyl equ 1
Sctcyl equ Scttrk*Trkcyl
Maxsct equ (Maxcyl*Sctcyl)-1

* Initialise Controller And Storage
* Input: Y=Device Descriptor Pointer
*        U=Global Storage Pointer

Idisk lda #Drvcnt No. Of Drives
 sta V.Ndrv,u
 leax Drvbeg,u Get D0 Table Pointer
 stx V.Cdrv,u Set In Current Drive Pointer
 pshs U Save Static Storage Pointer
 leau V.Wrtf,u Adjust Static For Boot
 lbsr Getdd Grab Parameters From Device Descriptor
 ldd #$100 Get Verify Buffer
 os9 F$SRqMem Get Memory
 bcs   Ierr Skip If Error
 tfr   u,d Copy Buffer Pointer
 puls  u Retrieve Static Storage Pointer
 std V.Vbuff,u Save Verify Buffer Pointer
 ldd   #INTPIA+1 point at PIA control reg
 leax  <Fdcpol,pcr Get Polling Parameters
 leay  Fdcsrv,pcr Get Service Routine
 os9   F$IRQ Try For Polling Table
 bcs   Init30 Skip If Error
 inc V.Wait,u Can Now Wait By Sleeping
 ldx   #INTPIA point at interrupt PIA
 lda   ,x clear any present interrupt
 pshs  cc save masks
 orcc #IntMasks mask interrupts
 lda   1,x get control reg
* anda #$C1 set CB2 interrupt input
 ora   #3 positive edge on CA1; enable interrupt
* ora #$18 positive edge
 sta 1,x
 puls cc restore masks
 leax TimSrv,pcr install timer routine
 os9   F$Timer
 bcs   Init30 ..error
Init10  leax  Drvbeg,u Get DO Table Pointer
 ldb   #DRVCNT
 lda   #$FF
Init20 sta DD.TOT+1,x non-zero size
 sta V.TRAK,x crazy track
 leax DRVMEM,X next!
 decb
 bne Init20
 clrb No Error
Init30 rts

Ierr PULS U,Pc Abort

 pag
*************************************************************
*
* Read Sector Subroutine
* Input: B=Logical Sector Msb
*        X=Logical Sector Lsbs
*        Y=Path Descriptor
*        U=Global Storage
*
Read bsr Rngtst Check Lsn Range
         bcs   Init30 ..error
         ldx   V.Lsn,u sector 0?
         bne   Read1 ..no
         bsr   Read1 read sector
         bcs   Init30 ..error
 ldx PD.BUF,Y Get Buffer Pointer
         pshs  y,x Save Registers
         tst V.Freeze,u freeze info?
         bne   Read2 ..yes; skip copy
         ldy V.Cdrv,u Get Drive Table Pointer
         ldb   #Dd.Siz-1 Get Buffer Offset/Counter
Copytb    lda   b,x Get Buffer Byte
         sta   b,y Set It In Table
         decb Count Bytes
         bpl   Copytb Loop Until Done
 ifne DDTRACK0&TRYBOTH
 endc
Read2 clr V.Freeze,u clear carry; no more freeze
 puls pc,y,x Return
Read1 leax Rsect,pcr Point At Read Routine

* Fall Through To Call Controller Subroutine

* Call Controller Subroutine
* Get Controller Pointer, Adjust Static Storage
* Pointer, And Call Routine

* Input: U=Static Storage Pointer

Call pshs u,y Save Registers
 ldy   V.Port,u Get Port Address
 leau V.Wrtf,u Move Static Storage Pointer
 jsr   ,x Call Driver
 puls  pc,u,y

* Write Sector

* Input: B=Lsn Msb
*        X=Lsn Lsbs
*        Y=Path Descriptor Pointer
*        U=Global Storage

Write bsr Rngtst Check Lsn Range
 bcs Return Skip If Error
 leax Wsect,pcr Get Write Routine Pointer
 bsr Call Call Routine
 bcs Return Skip If Error
 lda Pd.Vfy,y Verify On?
 bne Return Skip If Not
 ldd PD.BUF,y saver buffer address
 pshs D
 ldd V.Vbuff,u Point At Verify Buffer
 std PD.BUF,y set verify buffer
 bsr Read do verify read
 puls X restore buffer address
 stx PD.BUF,Y
 rts

* Logical Sector Number Range Test
*
* Checks Logical Sector Number, Sets Buffer Pointer,
* Sectors/Track On Track 0, And Transfers The Information
* From The Path Descriptor For Non-Os9 Disks.

Rngtst TSTB Lsn Possibly In Range?
 bne Rngerr Skip If No
         stx   V.Lsn,u
         bsr   Getdrv
 ifne HLFSECT
         bitb  #$40 Non-Os9 Format?
         beq   Rng4
         anda  #$F8
         pshs  a
         lda   PD.SID,y
         deca
         puls  a
         beq   Rng1
         ora   #1
Rng1    ldb   PD.DNS,y
         bitb  #1
         beq   Rng2
         ora   #2
Rng2    sta   >V.Fmt,u
         ldd   PD.SCT,y
         std   V.Stk,u
 ifne DBLSIDE
         lda   PD.SID,y
         deca
         beq   Rng3
         lslb
 endc
Rng3 LDA Pd.Cyl+1,y Cylinders
 MUL Make Rough Sector Total
 STD Dd.Tot+1,x Set It
 BRA Rng5
 endc
Rng4 equ *
 ifne EXTFMT
 clra
 ldb Dd.Tks,x Set Sectors/Track
 std V.Stk,u
 endc
Rng5 ldd V.Lsn,u Get Lsn
         cmpd Dd.Tot+1,x
         bhi   Rngerr
         ldd Pd.Buf,y
         std V.Buff,u
 ifne EXTFMT
 ldd PD.T0S,y Get Track 0 Sectors/Track
 std V.T0stk,u Pass It
 endc
 clrb No Error
 rts

Rngerr COMB Indicate Error
 ldb #E$SECT Lsn Out Of Range
Return RTS

* Getdrv Drive Table Pointer
*
* Returns - A : Format
*           B : Type
*           X : Drive Table Pointer

Getdrv ldx V.Cdrv,u
         beq   Get5
         lda V.CrTrk,u
         sta V.TRAK,x
Get5    lda   PD.DRV,y
         sta V.Drive,u
 ldb #DRVMEM
         mul
         leax  Drvbeg,u
         leax  d,x
         stx   >V.Cdrv,u
         lda   <$15,x
         sta   >V.CrTrk,u
         lda   PD.STP,y
         anda  #$03
         sta   >V.Step,u
         ldb   PD.DNS,y
         andb  #$02
         stb   >V.TwoStp,u
         lda   <$10,x
         ldb   PD.TYP,y
         andb  #$20
         stb   >V.DDTr0,u
         ldb   PD.TYP,y
         bitb  #$40
         bne   Get10
         bita  #$04
         beq   Get10
         clr   >V.TwoStp,u
Get10    bitb  #$01
         beq   Get15
         ora   #$80
Get15    bitb  #$08
         beq   Get20
         ora   #$08
Get20    sta   >V.Fmt,u
         rts

* Get Status - Not Used
*

Gstat bra Pstat1


* Put Status.
* Used For Restore And Write Track (Format)
*
* Input: Y=Path Descriptor Pointer
*        U=Static Storage

Pstat pshs U,Y
 ldx PD.RGS,Y Point to parameters
 ldb R$B,X Get stat call
 cmpb #SS.Reset Restore?
 beq Rstor ..yes; do it.
 cmpb #SS.WTrk Write track call?
 beq Wtrk ..yes; do it.
 cmpb #SS.FRZ Freeze dd. info?
 beq SetFrz Yes; ....flag it.
 cmpb #SS.SPT Set sect/trk?
 beq SetSpt Yes; ....set it.
         puls  u,y
Pstat1    comb
         ldb   #$D0
         rts

SetFrz    ldb   #$01
         stb   >V.Freeze,u
         clrb
         puls  pc,u,y

SetSpt    ldx   $04,x
         pshs  x
         lbsr  Getdrv
         puls  b,a
         std   $03,x
         clrb
         puls  pc,u,y

Rstor    lbsr  Getdrv
         ldx   >V.Cdrv,u
         clr   <$15,x
         leax  >Brstor,pcr
         lbsr  Call
         puls  pc,u,y

* Write Track (Format)
*

Wtrk lda R$Y+1,x
         ldb R$U+1,x
         pshs  b,a
         lbsr  Getdrv
 ifne EXTFMT
         ldd Pd.Sct,y
         std V.Stk,u
         ldd Pd.T0s,y
         std V.T0stk,u
 endc
         ldd #0
         std V.Lsn,u
         puls D
         sta Dd.Fmt,x
         stb V.Track,u
 ifne DBLSIDE
         anda #1
         sta V.Side,u
 endc
         lbsr  Getdrv
         ldd   #41*256
         os9   F$SRqMem
         bcs   Wtrk8
         ldx D.Proc get process ptr
         lda P$Task,x
         ldb   D.SysTsk
         ldy ,S get PD ptr
         ldx PD.RGS,y
         ldx R$X,x
         ldy #41*256
         os9 F$Move
         leax ,u copy buffer ptr
         ldu 2,s
         stx V.Buff,u
         leau V.Wrtf,u
         ldy V.Port-V.Wrtf,u get port address
         lbsr Select
         bcs Wtrk8
         lbsr Settrk
         ldd #41*256
         std V.Bytc-V.Wrtf,u
         lda   #F.WRTR
         sta V.Cmd-V.Wrtf,u
         lda   #1
         sta   V.Wrtf-V.Wrtf,u
         lbsr  IssXfr
         pshs  b,cc
         ldu   V.Buff-V.Wrtf,u
         ldd   #41*256 size
         os9   F$SRtMem
         puls  b,cc
Wtrk8    puls  pc,u,y

* Terminate Device Usage
*
* Input: U=Static Storage

Term    pshs  u
         ldu   V.Vbuff,u
         ldd   #$100
         os9   F$SRtMem
         puls  u
         ldx   #INTPIA
         lda   1,x
         anda  #$FE
         sta 1,x
         ldx #0
         os9 F$IRQ
         ldx #0
         os9 F$Timer
         clrb
         rts




****************************************
*
* Bootstrap Routine, And Disk Controller
* Interface Routines
*
****************************************

Boot pshs  u,y,x,b,a
 leas -Btmem,s Get Global Storage
 ldd #256 Get A Page
 os9 F$SRqMem
 bcs Bterr2 Skip If None
 stu V.Buff-V.Wrtf,S Set Buffer Pointer
 leau ,S Set Storage Pointer
 clr V.Wait-V.Wrtf,u can't sleep
Boot40 clra
 clrb
 std V.Lsn-V.Wrtf,u Logical Sector 0
 ldy Btmem+4,S Get Device Descriptor Pointer
 bsr Getdd Grab parameters
 lda INTPIA+1 get control reg
 ora #1 enable disk controller interrupts
 sta INTPIA+1
 lbsr Brstor Restore Drive
 bcs Boot40 Skip If Error - Try Again
 lbsr Rsect Read Sector 0
 bcs Boot40 Try Again On Error
 ldx V.Buff-V.Wrtf,u Get Buffer Pointer
 ifne EXTFMT
 lda Dd.Fmt,X Get Disk Format
 ifne FULLSIZE
 ora V.Fmt-V.Wrtf,u Set Drive Type In Format
 sta V.Fmt-V.Wrtf,u Set It
 endc
 ifne DBLTRACK
 bita #4 double track disk?
 beq Boot20 ..no
 clr V.TwoStp-V.Wrtf,u can't need double stepping
Boot20 clra
 ldb Dd.Tks,x Get Sects/Trk
 std V.Stk-V.Wrtf,u Set It
 endc
 ldd Dd.Bsz,x Get Boot File Size
 std Btmem,u
 ldd #256 Return Page
 leau  ,x
 ldx DD.Bt+1,x Get Start Sector Number
 os9 F$SRtMem
 ldd Btmem,S was there a boot file?
 beq Noboot
 ifeq LEVEL-1
 os9 F$SRqMem Get memory for bootstrap
 else
 os9 F$BtMem Get memory for bootstrap
 endc
 bcs Bterr2 Skip If None
 stu Btmem+2,S Return Address To Caller
 stu V.Buff-V.Wrtf,s Set Buffer Pointer
 leau ,S Get Global Storage Pointer
Boot10 pshs x,a Save Pages And Sector Number
 stx V.Lsn-V.Wrtf,u Set Sector Number
 bsr Rsect Read Sector
 bcs Bterr1 Skip If Error
 puls x,a Retrieve Pages And Sector Number
 leax 1,x Next Sector
 inc V.Buff-V.Wrtf,u Move Buffer Pointer
 deca Done All Pages
 bne Boot10 Loop If Not
 leas Btmem,s Return Global Storage
 clrb No Error, Clear Carry
 puls pc,u,y,x,b,a Return, With Boot Address In D
Noboot comb Set Carry
 ldb #E$BTYP No Boot File
 bra Bterr2
Bterr1 leas 3,s Pitch Pages And Sector Number
Bterr2 leas Btmem+2,S Pitch Global And D
 puls pc,u,y,x

* Get Parameters From Device Descriptor
Getdd    leay $12,y
         lda   $01,y
         sta   V.Drive-V.Wrtf,u
         lda   $02,y
         anda  #3
         sta V.Step-V.Wrtf,u
 ifne EXTFMT
         lda   $03,y
         clrb
 ifne FULLSIZE
         bita  #1
         beq   Getdd1
         ldb   #$80
 endc

Getdd1 equ *
 ifne DBLTRACK
    lda   $04,y
         anda #2
         sta V.TwoStp-V.Wrtf,u
 endc
 ifne DDTRACK0
 ifeq TRYBOTH
         lda   $03,y
         anda  #$20
         sta V.DDTr0-V.Wrtf,u
 endc
 endc
         stb  V.Fmt-V.Wrtf,u
         ldd   $0B,y
         std  V.T0stk-V.Wrtf,u
 endc
         ldy   -$03,y
         lda   ,y
         rts

* Read Sector Routine
*

Rsect    clr   V.Wrtf-V.Wrtf,u
         lda   #$88
         sta   V.Cmd-V.Wrtf,u

* Set up for Read/Write Transfer
Xfr    lda   #$DB
         pshs  a
         lda  V.Fmt-V.Wrtf,u
         bita  #$08
         beq   Xfr1
         ldd   #$0080
         std V.Bytc-V.Wrtf,u
         bsr   Xfr2
         bcs   Xfr70
         ldd  V.Buff-V.Wrtf,u
         leas  $01,s
         pshs  b,a
         addd  #$0080
         std   V.Buff-V.Wrtf,u
         lda   #$DB
         pshs  a
         bsr   Xfr2
         puls  x
         stx   V.Buff-V.Wrtf,u
         bra   Xfr70
Xfr1    ldd   #$100
         std  V.Bytc-V.Wrtf,u
Xfr2    ldd  V.Lsn-V.Wrtf,u
         bne   Xfr20
Xfr10    lbsr  Brstor
Xfr20    bsr   Select
         bcs   Xfr70
         clr   V.Track-V.Wrtf,u
         clr   V.Side-V.Wrtf,u
         ldd   V.Lsn-V.Wrtf,u
         cmpd  V.T0stk-V.Wrtf,u
         bcs   Xfr40
         subd  V.T0stk-V.Wrtf,u
Xfr30    inc   V.Track-V.Wrtf,u
 ifne EXTFMT
         subd  V.Stk-V.Wrtf,u
         bcc   Xfr30
         addd  V.Stk-V.Wrtf,u
 else
 endc
 ifne DBLSIDE
         lda   V.Fmt-V.Wrtf,u
         bita  #$01
         beq   Xfr40
         lsr   V.Track-V.Wrtf,u
         rol   V.Side-V.Wrtf,u
 endc
 ifne HLFSECT
Xfr40    lda   V.Fmt-V.Wrtf,u
         bita  #$08
         beq   Xfr90
         lslb
         decb
         bra   Xfr95
 endc
Xfr90 equ *
 ifne DDTRACK0
         tst  V.DDTr0-V.Wrtf,u
         beq   Xfr95
         incb
 endc
Xfr95    stb  V.Sector-V.Wrtf,u
Xfr50    lbsr  Settrk
         lda   V.Sector-V.Wrtf,u
* Extend to check of sector reg once written
* as recommended by Western Digital for the 2797
* sta SECREG,Y set it in fdc
         bsr   SetSect set sector number in FDC
         lbsr  IssXfr Do Transfer
         bcc   Xfr70 Skip If No Error
         cmpb  #E$NotRdy not ready?
         orcc  #$01
         beq   Xfr70
         lsr   ,s
         bcc   Xfr10
         bne   Xfr50
Xfr70    leas  $01,s
         rts

* Set the sector number in the WD2797
* wait for 32usec, then check it
* as recommended by Western Digital
SetSect    sta   $02,y
         ldb   #12
SetSect1 decb
         bne   SetSect1
         cmpa  $02,y
         bne   SetSect
         rts

* Write Sector Routine
*

Wsect    lda   #1
         sta   V.Wrtf-V.Wrtf,u
         lda   #$A8
         sta   V.Cmd-V.Wrtf,u
         lbra  Xfr

* Select Drive Routine
*
Select    lda V.Drive-V.Wrtf,u
         cmpa  #DrvCnt
         bcs   L041D
         comb error -
         ldb   #E$Unit bad unit
         rts

L041D    coma
         ldb   #$01
         stb   V.Active-V.Wrtf,u
         anda  #$FF-B.Motor-B.DPHalt $6F
         ldb   V.Drive-V.Wrtf,u
         cmpb  u0009,u
         beq   L0456
         stb   u0009,u
         ldb   V.Select-V.Wrtf,u
         orb   #$04
         stb   >SELREG
         ldx   #$0014
L0437    leax  -$01,x
         bne   L0437
         sta   >SELREG
         tst   V.Port,u
         bne   L0450
         ldb   #$03
Sele7b    ldx   #25000 100ms
Sele8b    leax  -1,x
         bne   Sele8b
         decb
         bne   Sele7b
         bra   L0456
L0450    ldx   #$000F
         os9   F$Sleep
L0456    anda  #$FB
         ldb   V.Select-V.Wrtf,u
         sta   V.Select-V.Wrtf,u
         sta   >SELREG set select
         lda   #MotTim
         sta  V.Timer-V.Wrtf,u
         bitb  #B.Motor
         beq   Sele5
         ldb   V.Fmt-V.Wrtf,u
         bmi   Sele5
         tst   V.Port,u
         bne   L047F
         ldb   #RdyTim
Sele7    ldx   #25000
Sele8    leax -1,x
         bne   Sele8
         decb
         bne   Sele7
         bra   Sele5
L047F    ldx   #RdyTim*5
         os9   F$Sleep
Sele5    lda   STTREG,y get controller status
         clrb clear carry
         bita  #$80 drive ready?
         beq   Sele4 ..yes
         clr   V.Active-V.Wrtf,u no longer active
         comb error -
         ldb   #E$NotRdy Not ready
Sele4    rts

*
* Seek routine
*
Settrk lda V.CrTrk-V.Wrtf,u get current track
 clr V.NewTrk-V.Wrtf,u clear 'new track'
 ifne DBLTRACK
 tst V.TwoStp-V.Wrtf,u double stepping?
 beq Sett1 ..no
 lsla double the track
 endc
Sett1    sta   $01,y
         lda  V.Track-V.Wrtf,u
         ldb  V.Fmt-V.Wrtf,u
         bmi   Sett7
         bitb  #$04
         beq   Sett5
Sett7    cmpa  #$28
         bra   L04B0
Sett5    cmpa  #$10
L04B0    bcs   Sett4
         ldb   V.Select-V.Wrtf,u
         andb  #$DF
         stb   V.Select-V.Wrtf,u
         stb   >SELREG
Sett4    cmpa  V.CrTrk-V.Wrtf,u
         beq   Sett8
         sta   V.CrTrk-V.Wrtf,u
 ifne DBLTRACK
 tst V.TwoStp-V.Wrtf,u double stepping?
 beq Sett9 ..no
 lsla double the target track
Sett9 equ *
 endc
 ldb #4
         stb  V.NewTrk-V.Wrtf,u
         sta  DATREG,y
         lda   #F.SEEK
Sett3    ora  V.Step-V.Wrtf,u
         lbsr  Outcom
         bsr   Sett8
         ldb  V.Status-V.Wrtf,u
         andb  #$90
         lbra  STCK

Sett8    lda   V.CrTrk-V.Wrtf,u
         sta   $01,y
         rts


* Restore Drive Routine
*
*
*   INPUT: (Y)= POINTER TO PATH DECSRIPTOR
*          (U)= POINTER TO GLOBAL STORAGE
*
*   IF ERROR: (B)= ERROR CODE & CARRY IS SET
*
 ifne STEPIN
* NOTE:  WE ARE STEPPING IN SEVERAL TRACKS BEFORE
*        ISSUING THE RESTORE AS SUGGESTED IN THE
*        FD 1973 APPLICATION NOTES.
 endc

Brstor    lbsr  SELECT
         clr  V.CrTrk-V.Wrtf,u
         ldb   #5 REPEAT FIVE TIMES
RESTR2    lda   #F.STPI STEP IN COMMAND
         ora  V.Step-V.Wrtf,u
         pshs  b
         bsr   Outcom
         puls  b
         decb
         bne   RESTR2
         lda   #F.REST RESTORE COMMAND
         bra   Sett3

* Execute Transfer Requiring DMA
*

IssXfr    clrb
         pshs  cc
         ldb   V.Cmd-V.Wrtf,u
         tst   V.Side-V.Wrtf,u
         beq   L0510
         orb   #2
         stb   Drvbeg,u
L0510    orcc #IntMasks
         ldx   D.DMport
         beq   IssXfr2
         ldx   #1
         os9   F$Sleep
         bra   L0510
IssXfr2    leax  $03,y
         stx   D.DMPort
         ldx   V.Buff-V.Wrtf,u
         stx   D.DMMem
         lda   V.Wrtf-V.Wrtf,u
         sta   D.DMDir

**********

         ldx   #DAT.Task
         lda   #SysTask-B.DPNMI
         sta   ,x
         ora   #B.DPNMI remove NMI
         sta   ,x

**********

 ifne EXTFMT
 ifne DDTRACK0
         tst   V.DDTr0-V.Wrtf,u
         bne   IssXfr4
 endc
         ldb   V.Fmt-V.Wrtf,u
         tst   V.Track-V.Wrtf,u
         bne   L0547
         tst  V.Side-V.Wrtf,u
         beq   IssXfr5
L0547    bitb  #2
         beq   IssXfr5
 endc
IssXfr4    lda   V.Select-V.Wrtf,u
         anda  #$BF
         sta   >SELREG
         sta   V.Select-V.Wrtf,u
IssXfr5    lda   V.Cmd-V.Wrtf,u
         ora   V.NewTrk-V.Wrtf,u
         bsr   Outcom
         bsr   ChkErr
         ldx   #$0000
         stx   D.DMPort
         bcc   IssXfr3
         lda   ,s
         ora   #1
         sta   ,s
IssXfr3    puls  pc,cc

Outcom    pshs  cc
         orcc #IntMasks
         ldb   #$FA
         stb  V.Timer-V.Wrtf,u
         stb  V.Active-V.Wrtf,u
         sta   ,y
         tst   V.Wait-V.Wrtf,u
         bne   Fdccmd

* Start Fdc And Wait, Hogging Cpu
IssFdc SYNC wait for interrupt
         lda   >INTPIA+1
         bita  #INTBIT
         beq   IssFdc
         lda   STTREG,y
         sta   V.Status-V.Wrtf,u
         bra   FdcCmd3

* Start FDC and Wait by Sleeping
Fdccmd    ldx   #$00C8
         lda   V.Busy-V.Wrtf,u
         sta   V.Wake-V.Wrtf,u
FdcCmd1    os9   F$Sleep
         orcc #IntMasks
         tst   V.Wake-V.Wrtf,u
         beq   FdcCmd2
         leax  ,x
         bne   FdcCmd1
         clr   V.Wake-V.Wrtf,u
         lda   #$80
         sta   V.Status-V.Wrtf,u
         lda   #F.TERM
         sta   CMDREG,y
         bsr   STCK3
FdcCmd3    lda   >INTPIA
FdcCmd2    clr   V.Active-V.Wrtf,u
         puls  pc,cc
*
* Translate error status
*
ChkErr    ldb   V.Status-V.Wrtf,u

STCK    clra
         andb  #$FC
         beq   STCK3
SCK1    lslb
         inca
         bcc   SCK1
         deca
         leax  <ERTABLE,pcr
         ldb   a,x
         cmpb  #$F4
         bne   STCK2
         tst   V.Wrtf-V.Wrtf,u
         beq   STCK2
         ldb   #$F5
STCK2    coma
STCK3    rts

ERTABLE fcb E$NotRdy,E$WP,E$Read,E$Seek
 fcb E$Read,E$Read

* Interrupt Request Service For Fdc
*
* Input: U=Static Storage

Fdcsrv    ldy   V.Port,u
         ldb   ,y
         stb   >V.Status,u
         lda   >INTPIA
         lda   V.Wake,u
         beq   Fdcsrc2
         clr   V.Wake,u
 ldb #S$Wake
 os9 F$Send
Fdcsrc2    clrb
         rts

TimSrv tst V.Timer,u get counter
 beq TimSrv1 ..none
 tst V.Active,u command in progress?
 bne TimSrv1 ..yes
 dec V.Timer,u keep count
 bne TimSrv1 ..not yet
 lda #$FF-B.DPHalt turn everything off
 sta >SELREG
 sta V.Select,u
TimSrv1 rts

 EMOD

Dkend EQU *
