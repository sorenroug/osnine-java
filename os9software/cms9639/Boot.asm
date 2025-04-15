         nam   Boot
         ttl   os9 system module

         use   defsfile

tylg     set   Systm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   BootEnd,name,tylg,atrv,start,0

EXTDEVC EQU     $FF80
EXTDEVD EQU     $FF81

name     fcs   /Boot/
         fcb   5 edition

 org 0
S.UNK1 rmb 22
S.BUF rmb 2   at $16
S.UNK2 rmb 8
S.END equ .   $20

ST.D equ 0
ST.B equ 1 order of registers pushed to stack

DRV.PUP equ %00010000
DRV.BSY equ %01000000

* Variables on the U stack.
 org $10
V.U10 rmb 1
V.SECTHI rmb 1
V.SECT rmb 3 = $12
V.U15 rmb 1 = $15
V.U16 rmb 2 = $16
V.CMDLOC rmb 2 = $18
V.DATLOC rmb 2 = $1A Location in main memory for data
V.SCSIST rmb 1 = $1C
V.CMDST rmb 1 = $1D
V.NUMBLK rmb 1 = $1E
V.U1F rmb 1

L0012    fcb   $02,$00,$21,$01,$01,$04,$02,$64,$02,$65,$02,$65,$00,$00

L0020    fcb   $00,$00,$21,$01,$01,$02,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00

* Input B = command
SETCMD lda EXTDEVC
         orcc  #Carry
         bita  #DRV.BSY
         bne   L0046
         stx   <V.CMDLOC,u
         sty   <V.DATLOC,u
         stb   <V.CMDST,u
         stb   EXTDEVC
         andcc #^Carry success, clear carry
L0046    rts

L0047    lda   EXTDEVC Read status of drive
         bmi   L0052 branch if $80 is active
         bita  #DRV.BSY
         bne   L0047
         bra   CLEANUP

L0052    tfr   a,b
         bita  #DRV.BSY
         beq   DDERR
         anda  #$07     mask command from status
         leax  >L0074,pcr
         lda   a,x
         jsr   a,x
CLEANUP  tst <V.CMDST,u
         bne   L0047
         lda   <V.SCSIST,u
         bita  #$02
         bne   DDERR
         andcc #^Carry
         rts

DDERR    orcc  #Carry
         rts

L0074    fcb   L008F-L0074  0 Copy to drive
         fcb   L00A2-L0074  1 Copy from drive
         fcb   L007C-L0074  2
         fcb   L00B3-L0074  3 Read SCSI status from drive
         fcb   RETRN-L0074  4 Send command to drive
         fcb   RETRN-L0074  5
         fcb   RETRN-L0074  6
         fcb   L00BA-L0074  7 Message from drive

* 2.3.5 Command Phase
L007C    ldx   V.CMDLOC,u
L007F    lda   ,x+
         sta   EXTDEVD
L0084    brn   L0084    * Delay two clock cycles
         cmpb  EXTDEVC
         beq   L007F
         stx   V.CMDLOC,u
RETRN    rts

* Copy to drive
L008F    ldx   V.DATLOC,u
L0092    lda   ,x+
         sta   EXTDEVD
L0097    brn   L0097
         cmpb  EXTDEVC
         beq   L0092
         stx   V.DATLOC,u
         rts

* Copy from drive
* Input:
* B = original ready status byte from drive
L00A2    ldx   V.DATLOC,u
L00A5    lda EXTDEVD Read byte from device
         sta   ,x+
         cmpb  EXTDEVC any changes in status?
         beq   L00A5 ... no
         stx   V.DATLOC,u store new last location
         rts

* Read SCSI status
L00B3    lda   EXTDEVD
         sta   <V.SCSIST,u
         rts

* Read control register
L00BA    tst   EXTDEVD
         clr   V.CMDST,u
         rts

L00C1    pshs  y,x,d
         sta   V.SECT+2,u
         stx   V.SECT,u
         clrb
         lda   EXTDEVC
         bita  #DRV.PUP
         bne   L00D3
         ldb   #$40
L00D3    orb   $01,s
         stb   V.SECTHI,u
         clr   V.U15,u
         puls  pc,y,x,d

L00DD    pshs  y,x,d
         leax  V.U10,u
         ldy   V.U16,u
         bsr   ACKNOW
         bcc   L00EC
         stb   $01,s
L00EC    puls  pc,y,x,d

ACKNOW ldb #$01
         lbsr  SETCMD
         bcs   ACKNOW
         lbsr  L0047
         bcc   L00FC
         ldb   #E$Read
L00FC    rts

****
* Read sectors
* Input:
* A: number of blocks to read.
* X: Starting LSN to read
RDSEC2 pshs u,y,x,d
         sta   V.NUMBLK,u
         lda   #$01
         bsr   L00C1
         clr   V.U10,u
L0109    bsr   L00DD
         bcs   L0109
         lda   #$08
         sta   V.U10,u
L0112    leax  V.U10,u
         ldy   V.DATLOC,u
         bsr   ACKNOW
         bcs   L0135
         ldd   V.SECT,u increase sector number
         addd  #1
         std   V.SECT,u
         ldb   #$00
         adcb  V.SECTHI,u  add carry t V.SECTHI
         stb   V.SECTHI,u
         dec   V.NUMBLK,u decrease number of blocks to read
         bne   L0112
         bra   L0137
L0135    stb   ST.B,s Store error code
L0137    puls  pc,u,y,x,d

* Delay
DLY25MS pshs d,cc
 ldd #7142
DLY25M2 subd #1
 bne DLY25M2
 puls pc,d,cc

******************************************
* Start
start pshs  u,y,x,d
         leas  <-S.END,s
         ldd   #256   Reserve 256 bytes for LSN0 buffer
         os9   F$SRqMem
         lbcs  BOOTERR unable to allocate buffer
         stu   S.BUF,s Store allocated buffer
         leau  0,s
         lda   #$10
         sta   EXTDEVC save to device control
         bsr   DLY25MS wait for spin up
         lda   EXTDEVC get device status
         leay  L0012,pcr
         clrb
         clr   V.U1F,u
         bita  #DRV.PUP
         bne   L0175
         leay  L0020,pcr
         ldb   #$40
L0175    stb   V.SECTHI,u
         lda   #$C4
         leax  V.U10,u
         sta   ,x
         clr   V.U15,u
         pshs  y,x
         lbsr  ACKNOW
         puls  y,x
         lbsr  ACKNOW
         ldd   #256
         ldx   #0 Get sector zero
         lbsr  RDSEC2
         bcs   BOOTERR
         ldx   DD.BT+1,u Get boot sector low bytes
         ldy   DD.BSZ,x
         beq   BADDISK    No boot file?
         sty   <S.END+ST.D,s Save size in register D on stack
         ldb   DD.BT,x
         leau  0,x copy x to u
         ldx   DD.BT+1,x
         pshs  y,x,b
         ldd   #256
         os9   F$SRtMem  Return memory boot sector
         ldd   3,s   get size of memory request from x on stack
         os9   F$SRqMem
         puls  y,x,b
         stu   S.BUF,s Store allocated buffer
         stu   S.END+2,s Store in register X on stack
         leau  0,s
         lbsr  RDSEC2
         bcc   L01D0
         bcs   BOOTERR

BADDISK comb
         ldb   #E$BTyp
BOOTERR  stb <S.END+ST.B,s Store in register B on stack
L01D0    leas <S.END,s Return scratch
         puls  pc,u,y,x,d return to kernel routine
         emod

BootEnd      equ   *
