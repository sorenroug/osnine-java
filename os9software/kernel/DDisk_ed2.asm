***********************************************
*
* Original edition from Dragon Data OS-9 system disk
*
* Header for : DDisk
* Module size: $31C  #796
* Module CRC : $E01A55 (Good)
* Hdr parity : $C4
* Exec. off  : $0014  #20
* Data size  : $00AF  #175
* Edition    : $02  #2
* Ty/La At/Rv: $E1 $81
* Device Driver mod, 6809 Obj, re-ent, R/O

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

tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   3
u0003    rmb   2
u0005    rmb   1
u0006    rmb   2
u0008    rmb   7
u000F    rmb   19
u0022    rmb   1
u0023    rmb   29
u0040    rmb   3
u0043    rmb   5
u0048    rmb   95
u00A7    rmb   2
u00A9    rmb   1
u00AA    rmb   1
u00AB    rmb   1
u00AC    rmb   1
u00AD    rmb   2
size     equ   .
         fcb   $FF
name     equ   *
         fcs   /DDisk/
         fcb   $02
start    equ   *
         lbra  Init
         lbra  Read
         lbra  Write
         lbra  NoErr
         lbra  SetSta
         lbra  NoErr
Init    clra
         sta   >$006F
         sta   >$FF48
         ldx   #$FF40
         lda   #$D0
         sta   ,x
         lbsr  L02A3
         lda   ,x
         lda   #$FF
         ldb   #$04
         leax  u000F,u
L003F    sta   ,x
         sta   <$15,x
         leax  <$26,x
         decb
         bne   L003F
         leax  >L0172,pcr
         stx   >$010A
         lda   #$7E
         sta   >$0109
         ldd   #$0100
         pshs  u
         os9   F$SRqMem
         tfr   u,x
         puls  u
         bcs   L0069
         stx   >u00AD,u
         clrb
L0069    rts

NoErr    clrb
         rts
Read    lda   #$91
         cmpx  #$0000
         bne   L0096
         bsr   L0096
         bcs   L008C
         ldx   $08,y
         pshs  y,x
         ldy   >u00A7,u
         ldb   #$14
L0082    lda   b,x
         sta   b,y
         decb
         bpl   L0082
         clrb
         puls  pc,y,x
L008C    rts
L008D    bcc   L0096
         pshs  x,b,a
         lbsr  L02E1
         puls  x,b,a
L0096    pshs  x,b,a
         bsr   L00A1
         puls  x,b,a
         bcc   L008C
         lsra
         bne   L008D
L00A1    lbsr  L01BC
         bcs   L008C
         ldx   $08,y
         pshs  y,dp,cc
         ldb   #$88
         bsr   L00C6
L00AE    lda   <u0023
         bmi   L00BE
         leay  -$01,y
         bne   L00AE
         bsr   L0107
         puls  y,dp,cc
         lbra  L0280
L00BD    sync
L00BE    lda   <u0043
         ldb   <u0022
         sta   ,x+
         bra   L00BD
L00C6    lda   #$FF
         tfr   a,dp
         lda   <u0006
         sta   >u00AC,u
         anda  #$FE
         sta   <u0006
         bita  #$40
         beq   L00DE
L00D8    lda   <u0005
         bita  #$10
         beq   L00D8
L00DE    orcc  #$50
         lda   <u0003
         sta   >u00AB,u
         lda   #$34
         sta   <u0003
         lda   <u0006
         anda  #$FE
         sta   <u0006
         lda   <u0023
         ora   #$03
         sta   <u0023
         lda   <u0022
         ldy   #$FFFF
         lda   #$24
         ora   >u00A9,u
         stb   <u0040
         sta   <u0048
         rts
L0107    lda   >u00A9,u
         ora   #$04
         sta   <u0048
         lda   >u00AB,u
         sta   <u0003
         lda   <u0023
         anda  #$FC
         sta   <u0023
         lda   >u00AC,u
         sta   <u0006
         rts


Write    lda   #$91
L0124    pshs  x,b,a
         bsr   L0148
         puls  x,b,a
         bcs   L0138
         tst   <$28,y
         bne   L0136
         lbsr  L0184
         bcs   L0138
L0136    clrb
         rts
L0138    lsra
         lbeq  L0274
         bcc   L0124
         pshs  x,b,a
         lbsr  L02E1
         puls  x,b,a
         bra   L0124
L0148    lbsr  L01BC
         lbcs  L008C
         ldx   $08,y
         pshs  y,dp,cc
         ldb   #$A8
L0155    lbsr  L00C6
         lda   ,x+
L015A    ldb   <u0023
         bmi   L016C
         leay  -$01,y
         bne   L015A
         bsr   L0107
         puls  y,dp,cc
         lbra  L0274
L0169    lda   ,x+
         sync
L016C    sta   <u0043
         ldb   <u0022
         bra   L0169
L0172    leas  $0C,s
         bsr   L0107
         puls  y,dp,cc
         ldb   >$FF40
         bitb  #$04
         lbne  L0280
         lbra  L0252
L0184    pshs  x,b,a
         ldx   $08,y
         pshs  x
         ldx   >u00AD,u
         stx   $08,y
         ldx   $04,s
         lbsr  L00A1
         puls  x
         stx   $08,y
         bcs   L01BA
         lda   #$20
         pshs  u,y,a
         ldy   >u00AD,u
         tfr   x,u
L01A6    ldx   ,u
         cmpx  ,y
         bne   L01B6
         leau  u0008,u
         leay  $08,y
         dec   ,s
         bne   L01A6
         bra   L01B8
L01B6    orcc  #$01
L01B8    puls  u,y,a
L01BA    puls  pc,x,b,a
L01BC    clr   >u00AA,u
         bsr   L0227
         tstb
         bne   L01D6
         tfr   x,d
         ldx   >u00A7,u
         cmpd  #$0000
         beq   L01FB
         cmpd  $01,x
         bcs   L01DA
L01D6    comb
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
         lda   >u00A9,u
         ora   #$10
         sta   >u00A9,u
         puls  a
L01FB    incb
         stb   >$FF42
L01FF    ldb   <$15,x
         stb   >$FF41
         tst   >u00AA,u
         bne   L0210
         cmpa  <$15,x
         beq   L0225
L0210    sta   <$15,x
         sta   >$FF43
         ldb   #$12
         bsr   L0284
         pshs  x
         ldx   #$222E
L021F    leax  -$01,x
         bne   L021F
         puls  x
L0225    clrb
         rts
L0227    lbsr  L02FD
         lda   <$21,y
         cmpa  #$04
         bcs   L0235
         comb
         ldb   #$F0
         rts
L0235    pshs  x,b,a
         sta   >u00A9,u
         leax  u000F,u
         ldb   #$26
         mul
         leax  d,x
         cmpx  >u00A7,u
         beq   L0250
         stx   >u00A7,u
         com   >u00AA,u
L0250    puls  pc,x,b,a
L0252    bitb  #$F8
         beq   L026A
         bitb  #$80
         bne   L026C
         bitb  #$40
         bne   L0270
         bitb  #$20
         bne   L0274
         bitb  #$10
         bne   L0278
         bitb  #$08
         bne   L027C
L026A    clrb
         rts
L026C    comb
         ldb   #$F6
         rts
L0270    comb
         ldb   #$F2
         rts
L0274    comb
         ldb   #$F5
         rts
L0278    comb
         ldb   #$F7
         rts
L027C    comb
         ldb   #$F3
         rts
L0280    comb
         ldb   #$F4
         rts
L0284    bsr   L02A1
L0286    ldb   >$FF40
         bitb  #$01
         beq   L02A9
         lda   #$F0
         sta   >$006F
         bra   L0286
L0294    lda   #$04
         ora   >u00A9,u
         sta   >$FF48
         stb   >$FF40
         rts
L02A1    bsr   L0294
L02A3    lbsr  L02A6
L02A6    lbsr  L02A9
L02A9    rts
SetSta    ldx   $06,y
         ldb   $02,x
         cmpb  #$03
         beq   L02E1
         cmpb  #$04
         beq   L02BA
         comb
         ldb   #$D0
L02B9    rts
L02BA    lbsr  L0227
         lda   $09,x
         cmpa  #$10
         bls   L02CD
         ldb   >u00A9,u
         orb   #$10
         stb   >u00A9,u
L02CD    ldx   >u00A7,u
         lbsr  L01FF
         bcs   L02B9
         ldx   $06,y
         ldx   $04,x
         ldb   #$F0
         pshs  y,dp,cc
         lbra  L0155
L02E1    lbsr  L0227
         ldx   >u00A7,u
         clr   <$15,x
         lda   #$05
L02ED    ldb   #$42
         pshs  a
         lbsr  L0284
         puls  a
         deca
         bne   L02ED
         ldb   #$02
         bra   L0284
L02FD    pshs  x,b,a
         lda   >$006F
         bne   L0312
         lda   #$04
         sta   >$FF48
         ldx   #$A000
L030C    nop
         nop
         leax  -$01,x
         bne   L030C
L0312    lda   #$F0
         sta   >$006F
         puls  pc,x,b,a
         emod
eom      equ   *
