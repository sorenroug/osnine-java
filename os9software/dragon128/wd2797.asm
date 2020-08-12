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
* trach must be sector 1. The Device
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
u000E    rmb   1
u000F    rmb   1
u0010    rmb   1
u0011    rmb   1
u0012    rmb   2
u0014    rmb   2
u0016    rmb   1
u0017    rmb   1
u0018    rmb   1
u0019    rmb   1
u001A    rmb   2
u001C    rmb   1
u001D    rmb   24
u0035    rmb   2
u0037    rmb   2
u0039    rmb   23
u0050    rmb   48
u0080    rmb   38
u00A6    rmb   1

 ORG Drvbeg reserve RBF static storage
 RMB Drvmem*Drvcnt drive tables
V.Cdrv RMB 2 address of current drive table
V.Vbuff    rmb   1
u00AA    rmb   1
V.Wrtf    rmb   1
V.Wait    rmb   1
u00AD    rmb   1
V.Status    rmb   1
V.T0stk    rmb   2
V.Stk    rmb   2
u00B3    rmb   2
V.Lsn    rmb   2
V.fmt    rmb   1
V.TwoStp    rmb   1
V.Timer    rmb   3
V.CrTrk    rmb   1
u00BD    rmb   4
V.Step    rmb   1
u00C2    rmb   1
V.Select    rmb   2
u00C5    rmb   1
V.Freeze    rmb   1
V.DDTr0    rmb   1
Dskmem     equ   .

Type     set   drivr+objct
Revs     set   reent+1

         mod   Dkend,Dknam,Type,Revs,Dkent,Dskmem

 fcb $FF

Dknam fcs 'wd2797'
 fcb  1 Edition

Dkent    equ   *
         lbra  Idisk
         lbra  READSK
         lbra  Write
         lbra  Gstat
         lbra  Pstat
         lbra  Term
         lbra  BOOT

Fdcpol   fcb  $00 no flip bits
         fcb  $80
         fcb  $80

* Initialise Controller And Storage
* Input: Y=Device Descriptor Pointer
*        U=Global Storage Pointer
Idisk   lda   #Drvcnt
         sta   u0006,u
         leax  u000F,u
         stx   >V.Cdrv,u
 pshs U Save "u" we need it later
         leau  >V.Wrtf,u
         lbsr  Getdd
 ldd #256 "d" passes memory req size
         os9   F$SRqMem Request 1 pag of mem
         bcs   Ierr
         tfr   u,d
         puls  u
         std   >V.Vbuff,u
         ldd   #$FCC1
         leax  <Fdcpol,pcr
         leay  Fdcsrv,pcr
         os9   F$IRQ
         bcs   Init30
         inc   >V.Wait,u
         ldx   #DAT.Task
         lda   ,x
         pshs  cc
         orcc  #$50
         lda   $01,x
         ora   #$03
         sta   $01,x
         puls  cc
         leax  >TimSrv,pcr
         os9   F$Timer
         bcs   Init30
         leax  u000F,u
         ldb   #$04 #DriveCnt
         lda   #$FF
INILUP    sta   $01,x
         sta   <$15,x
 leax DRVMEM,X next
 decb
         bne   INILUP
         clrb
Init30    rts
Ierr    puls  pc,u

 pag
*************************************************************
*
* Read Sector Command
*
* Input: B = Msb Of Logical Sector Number
*        X = Lsb'S Of Logical Sector Number
*        Y = Ptr To Path Descriptor
*        U = Ptr To Global Storage
*
* Output: 256 Bytes Of Data Returned In Buffer
*
* Error: Cc=Set, B=Error Code
*
READSK    bsr   Rngtst
         bcs   Init30
         ldx   V.Lsn,u
         bne   Read1
         bsr   Read1
         bcs   Init30
 ldx PD.BUF,Y Point to buffer
         pshs  y,x
         tst   >V.Freeze,u
         bne   Read2
         ldy   >V.Cdrv,u
         ldb   #$14
Copytb    lda   b,x
         sta   b,y
         decb
         bpl   Copytb
Read2    clr   >V.Freeze,u
         puls  pc,y,x
Read1    leax  >Rsect,pcr

Call    pshs  u,y
         ldy   V.Port,u
         leau  >V.Wrtf,u
         jsr   ,x
         puls  pc,u,y

Write    bsr   Rngtst
         bcs   Return
         leax  >Wsect,pcr
         bsr   Call
         bcs   Return
         lda   <$28,y
         bne   Return
         ldd   $08,y
         pshs  b,a
         ldd   >V.Vbuff,u
         std   $08,y
         bsr   READSK
         puls  x
         stx   $08,y
         rts

 pag
**************************************************************
*
* Convert Logical Sector Number
* To Rngtstal Track And Sector
*
*  Input:  B = Msb Of Logical Sector Number
*          X = Lsb'S Of Logical Sector Number
*  Output: A = Rngtstal Track Number
*          Sector Reg = Rngtstal Sector Number
*  Error:  Carry Set & B = Error Code
*
Rngtst    tstb
         bne   Rngerr
         stx   V.Lsn,u
         bsr   Getdrv
         bitb  #$40 Non-Os9 Format?
         beq   Rng4
         anda  #$F8
         pshs  a
         lda   PD.SID,y
         deca
         puls  a
         beq   L010C
         ora   #$01
L010C    ldb   PD.DNS,y
         bitb  #$01
         beq   L0115
         ora   #$02
L0115    sta   >V.fmt,u
         ldd   PD.SCT,y
         std   >V.Stk,u
         lda   PD.SID,y
         deca
         beq   L0127
         lslb
L0127    lda   <$26,y
         mul
         std   $01,x
         bra   Rng5
Rng4    clra
         ldb   $03,x
         std   >V.Stk,u
Rng5    ldd   V.Lsn,u
         cmpd  $01,x
         bhi   Rngerr
         ldd   $08,y
         std   >u00BD,u
         ldd   PD.T0S,y
         std   >V.T0stk,u
         clrb
         rts

Rngerr comb
 ldb #E$SECT Error: bad sector number
Return    rts
 pag
***************************************************************
*
* Getdrv Drive
*
*  Input: (U)= Pointer To Global Storage
*
* Output: Curtbl,U=Current Drive Tbl
*         Curdrv,U=Drive Number
*
Getdrv    ldx   >V.Cdrv,u
         beq   Get5
         lda   >V.CrTrk,u
         sta   <$15,x
Get5    lda   PD.DRV,y
         sta   >u00B3,u
 ldb #DRVMEM
         mul
         leax  u000F,u
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
         bne   L01A5
         bita  #$04
         beq   L01A5
         clr   >V.TwoStp,u
L01A5    bitb  #$01
         beq   L01AB
         ora   #$80
L01AB    bitb  #$08
         beq   L01B1
         ora   #$08
L01B1    sta   >V.fmt,u
         rts

Gstat bra Pstat1

 pag
************************************************************
*
* Put Status Call
*
*
*
Pstat pshs U,Y
 ldx PD.RGS,Y Point to parameters
 ldb R$B,X Get stat call
 cmpb #SS.Reset Restore call?
 beq RESTOR ..yes; do it.
 cmpb #SS.WTrk Write track call?
 beq WRTTRK ..yes; do it.
 cmpb #SS.FRZ Freeze dd. info?
 beq SETFRZ Yes; ....flag it.
 cmpb #SS.SPT Set sect/trk?
 beq SETSPT Yes; ....set it.
         puls  u,y
Pstat1    comb
         ldb   #$D0
         rts

SETFRZ    ldb   #$01
         stb   >V.Freeze,u
         clrb
         puls  pc,u,y

SETSPT    ldx   $04,x
         pshs  x
         lbsr  Getdrv
         puls  b,a
         std   $03,x
         clrb
         puls  pc,u,y

RESTOR    lbsr  Getdrv
         ldx   >V.Cdrv,u
         clr   <$15,x
         leax  >Brstor,pcr
         lbsr  Call
         puls  pc,u,y

*****************************************************************
*
* Write Full Track
*  Input: (A)=Track
*         (Y)=Path Descriptor
*         (U)=Global Storage
*
WRTTRK    lda   $07,x
         ldb   $09,x
         pshs  b,a
         lbsr  Getdrv
         ldd   <$29,y
         std   >V.Stk,u
         ldd   <$2B,y
         std   >V.T0stk,u
         ldd   #$0000
         std   V.Lsn,u
         puls  b,a
         sta   <$10,x
         stb   >u00C2,u
         anda  #$01
         sta   >u00C5,u
         lbsr  Getdrv
         ldd   #$2900
         os9   F$SRqMem
         bcs   L0281
         ldx   <u0050
         lda   $06,x
         ldb   D.SysTsk
         ldy   ,s
         ldx   $06,y
         ldx   $04,x
         ldy   #$2900
         os9   F$Move
         leax  ,u
         ldu   $02,s
         stx   >u00BD,u
         leau  >V.Wrtf,u
         ldy   >-u00AA,u
         lbsr  L0413
         bcs   L0281
         lbsr  Settrk
         ldd   #$2900
         std   <u0014,u
         lda   #$F0
         sta   u000F,u
         lda   #$01
         sta   ,u
         lbsr  IssXfr
         pshs  b,cc
         ldu   <u0012,u
         ldd   #$2900
         os9   F$SRtMem
         puls  b,cc
L0281    puls  pc,u,y

Term    pshs  u
         ldu   >V.Vbuff,u
         ldd   #$0100
         os9   F$SRtMem
         puls  u
         ldx   #DAT.Task
         lda   $01,x
         anda  #$FE
         sta   $01,x
         ldx   #$0000
         os9   F$IRQ
         ldx   #$0000
         os9   F$Timer
         clrb
         rts

* Boot from floppy disk.
BOOT    pshs  u,y,x,b,a
         leas  <-$1D,s
         ldd   #$0100
         os9   F$SRqMem
         bcs   L032F
         stu   <$12,s
         leau  ,s
         clr   V.Port,u
L02BC    clra
         clrb
         std   u000A,u
         ldy   <$21,s
         bsr   Getdd
         lda   >$FCC1
         ora   #$01
         sta   >$FCC1
         lbsr  Brstor
         bcs   L02BC
         lbsr  Rsect
         bcs   L02BC
         ldx   <u0012,u
         lda   <$10,x
         ora   u000C,u
         sta   u000C,u
         bita  #$04
         beq   L02E8
         clr   u000D,u
L02E8    clra
         ldb   $03,x
         std   u0006,u
         ldd   <$18,x
         std   <u001D,u
         ldd   #$0100
         leau  ,x
         ldx   <$16,x
         os9   F$SRtMem
         ldd   <$1D,s
         beq   Noboot
         os9   F$BtMem
         bcs   L032F
         stu   <$1F,s
         stu   <$12,s
         leau  ,s
Boot10    pshs  x,a
         stx   u000A,u
         bsr   Rsect
         bcs   L032D
         puls  x,a
         leax  $01,x
         inc   <u0012,u
         deca
         bne   Boot10
         leas  <$1D,s
         clrb
         puls  pc,u,y,x,b,a

Noboot    comb
         ldb   #$F9
         bra   L032F

L032D    leas  $03,s
L032F    leas  <$1F,s
         puls  pc,u,y,x

Getdd    leay  <$12,y
         lda   $01,y
         sta   u0008,u
         lda   $02,y
         anda  #$03
         sta   <u0016,u
         lda   $03,y
         clrb
         bita  #$01
         beq   L034B
         ldb   #$80
L034B    lda   $04,y
         anda  #$02
         sta   u000D,u
         lda   $03,y
         anda  #$20
         sta   <u001C,u
         stb   u000C,u
         ldd   $0B,y
         std   u0004,u
         ldy   -$03,y
         lda   ,y
         rts

* Read Sector Routine
*

Rsect    clr   ,u
         lda   #$88
         sta   u000F,u
Xfr    lda   #$DB
         pshs  a
         lda   u000C,u
         bita  #$08
         beq   L0398
         ldd   #$0080
         std   <u0014,u
         bsr   L039E
         bcs   Xfr70
         ldd   <u0012,u
         leas  $01,s
         pshs  b,a
         addd  #$0080
         std   <u0012,u
         lda   #$DB
         pshs  a
         bsr   L039E
         puls  x
         stx   <u0012,u
         bra   Xfr70
L0398    ldd   #$0100
         std   <u0014,u
L039E    ldd   u000A,u
         bne   L03A5
L03A2    lbsr  Brstor
L03A5    bsr   L0413
         bcs   Xfr70
         clr   <u0017,u
         clr   <u001A,u
         ldd   u000A,u
         cmpd  u0004,u
         bcs   L03CD
         subd  u0004,u
L03B8    inc   <u0017,u
         subd  u0006,u
         bcc   L03B8
         addd  u0006,u
         lda   u000C,u
         bita  #$01
         beq   L03CD
         lsr   <u0017,u
         rol   <u001A,u
L03CD    lda   u000C,u
         bita  #$08
         beq   L03D7
         lslb
         decb
         bra   L03DD
L03D7    tst   <u001C,u
         beq   L03DD
         incb
L03DD    stb   <u0010,u
Xfr50    lbsr  Settrk
         lda   <u0010,u
         bsr   SetSect
         lbsr  IssXfr
         bcc   Xfr70
         cmpb  #E$NotRdy Error: drive not ready
         orcc  #$01
         beq   Xfr70
         lsr   ,s
         bcc   L03A2
         bne   Xfr50
Xfr70    leas  $01,s
         rts

SetSect    sta   $02,y
         ldb   #$0C
SetSect1    decb
         bne   SetSect1
         cmpa  $02,y
         bne   SetSect
         rts

Wsect    lda   #$01
         sta   ,u
         lda   #$A8
         sta   u000F,u
         lbra  Xfr
L0413    lda   u0008,u
         cmpa  #$04
         bcs   L041D
         comb
         ldb   #E$Unit bad unit
         rts

L041D    coma
         ldb   #$01
         stb   u0002,u
         anda  #$6F
         ldb   u0008,u
         cmpb  u0009,u
         beq   L0456
         stb   u0009,u
         ldb   <u0018,u
         orb   #$04
         stb   >$FC24
         ldx   #$0014
L0437    leax  -$01,x
         bne   L0437
         sta   >$FC24
         tst   V.Port,u
         bne   L0450
         ldb   #$03
L0444    ldx   #$61A8
L0447    leax  -$01,x
         bne   L0447
         decb
         bne   L0444
         bra   L0456
L0450    ldx   #$000F
         os9   F$Sleep
L0456    anda  #$FB
         ldb   <u0018,u
         sta   <u0018,u
         sta   >$FC24
         lda   #$FA
         sta   u000E,u
         bitb  #$10
         beq   Sele5
         ldb   V.Fmt-V.Wrtf,u
         bmi   Sele5
         tst   V.Port,u
         bne   L047F
         ldb   #$0C
Sele7    ldx   #$61A8
L0476    leax  -$01,x
         bne   L0476
         decb
         bne   Sele7
         bra   Sele5
L047F    ldx   #$003C
         os9   F$Sleep
Sele5    lda   ,y
         clrb
         bita  #$80
         beq   Sele4
         clr   u0002,u
         comb
         ldb   #$F6
Sele4    rts

*
* Seek routine
*
Settrk    lda   <u0011,u
         clr   <u0019,u
         tst   u000D,u
         beq   Sett1
         lsla
Sett1    sta   $01,y
         lda   <u0017,u
         ldb   u000C,u
         bmi   L04AA
         bitb  #$04
         beq   L04AE
L04AA    cmpa  #$28
         bra   L04B0
L04AE    cmpa  #$10
L04B0    bcs   L04BD
         ldb   <u0018,u
         andb  #$DF
         stb   <u0018,u
         stb   >$FC24
L04BD    cmpa  <u0011,u
         beq   L04E2
         sta   <u0011,u
         tst   u000D,u
         beq   L04CA
         lsla
L04CA    ldb   #$04
         stb   <u0019,u
         sta   $03,y
         lda   #$18
L04D3    ora   <u0016,u
         lbsr  L056E
         bsr   L04E2
         ldb   u0003,u
         andb  #$90
         lbra  L05BD
L04E2    lda   <u0011,u
         sta   $01,y
         rts

Brstor    lbsr  L0413
         clr   <u0011,u
         ldb   #$05
RESTR2    lda   #$48
         ora   <u0016,u
         pshs  b
         bsr   L056E
         puls  b
         decb
         bne   RESTR2
         lda   #$08
         bra   L04D3
IssXfr    clrb
         pshs  cc
         ldb   u000F,u
         tst   <u001A,u
         beq   L0510
         orb   #$02
         stb   u000F,u
L0510    orcc  #$50
         ldx   <u0035
         beq   L051E
         ldx   #$0001
         os9   F$Sleep
         bra   L0510
L051E    leax  $03,y
         stx   <u0035
         ldx   <u0012,u
         stx   <u0037
         lda   ,u
         sta   <u0039
         ldx   #DAT.Task
         lda   #$00
         sta   ,x
         ora   #$80
         sta   ,x
         tst   <u001C,u
         bne   L054B
         ldb   u000C,u
         tst   <u0017,u
         bne   L0547
         tst   <u001A,u
         beq   L0556
L0547    bitb  #$02
         beq   L0556
L054B    lda   <u0018,u
         anda  #$BF
         sta   >$FC24
         sta   <u0018,u
L0556    lda   u000F,u
         ora   <u0019,u
         bsr   L056E
         bsr   L05BB
         ldx   #$0000
         stx   <u0035
         bcc   L056C
         lda   ,s
         ora   #$01
         sta   ,s
L056C    puls  pc,cc

L056E    pshs  cc
         orcc  #$50
         ldb   #$FA
         stb   u000E,u
         stb   u0002,u
         sta   ,y
         tst   V.Port,u
         bne   Fdccmd

IssFdc    sync
         lda   >$FCC1
         bita  #$80
         beq   IssFdc
         lda   ,y
         sta   u0003,u
         bra   L05B4
Fdccmd    ldx   #$00C8
         lda   >-V.Cdrv,u
         sta   >-u00A6,u
L0597    os9   F$Sleep
         orcc  #$50
         tst   >-u00A6,u
         beq   L05B7
         leax  ,x
         bne   L0597
         clr   >-u00A6,u
         lda   #$80
         sta   u0003,u
         lda   #$D0
         sta   ,y
         bsr   L05D7
L05B4    lda   >DAT.Task
L05B7    clr   u0002,u
         puls  pc,cc

L05BB    ldb   u0003,u
L05BD    clra
         andb  #$FC
         beq   L05D7
L05C2    lslb
         inca
         bcc   L05C2
         deca
         leax  <ERTABLE,pcr
         ldb   a,x
         cmpb  #$F4
         bne   STCK2
         tst   ,u
         beq   STCK2
         ldb   #$F5
STCK2    coma
L05D7    rts

ERTABLE    ldb   >$F2F4
         stb   >$F4F4

Fdcsrv    ldy   V.Port,u
         ldb   ,y
         stb   >V.Status,u
         lda   >DAT.Task
         lda   V.Wake,u
         beq   Fdcsrc2
         clr   V.Wake,u
 ldb #S$Wake
 os9 F$Send
Fdcsrc2    clrb
         rts

TimSrv    tst   >V.Timer,u
         beq   TimSrv1
         tst   >u00AD,u
         bne   TimSrv1
         dec   >V.Timer,u
         bne   TimSrv1
         lda   #$7F
         sta   >$FC24
         sta   >V.Select,u
TimSrv1    rts

         emod
Dkend equ *
