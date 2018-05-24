 nam ACIA51
 ttl Interrupt-Driven Acia driver for Roswell 6551

* Copyright 1982 by Microware Systems Corporation
* Reproduced Under License

* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!


         ifp1
         use   defsfile
         endc

Edition equ 4 Current Edition

***************
* Interrupt-driven Acia Device Driver


DataReg         equ   0
StatReg         equ   1
CmndReg         equ   2

NOTDSR   set   %01000000 not data set ready
DCDLST   set   %00100000 data carrier lost

INPERR   set   NOTDSR+DCDLST

tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,ACIENT,size
u0000    rmb   1
u0001    rmb   2
u0003    rmb   1
u0004    rmb   1
u0005    rmb   1
u0006    rmb   3
u0009    rmb   2
u000B    rmb   1
u000C    rmb   1
u000D    rmb   1
u000E    rmb   1
u000F    rmb   1
u0010    rmb   13
INXTI  rmb   1
INXTO    rmb   1
INCNT    rmb   1      0 = not ready?
ONXTI  rmb   1      end of circular buffer
ONXTO    rmb   1      start of circular buffer
HALTED    rmb   1      Flag register?
INHALT    rmb   1
u0024    rmb   2
u0026    rmb   1
INPBUF  rmb   80
INPSIZ   equ   .-INPBUF
OUTBUF      rmb   140
OUTSIZ   equ   .-OUTBUF       Tx Queue length
size     equ   .
         fcb   $03
name     equ   *
         fcs   /ACIA51/

 fcb Edition Current Revision

         
ACIENT lbra  INIT
         lbra  READ
         lbra  WRITE
         lbra  GETSTA
         lbra  PUTSTA
         lbra  TRMNAT


ACMASK    fcb   $00,$80,$0A

 ttl INTERRUPT-DRIVEN Acia device routines
 pag
***************
* Init
*   Initialize (Terminal) Acia
*
INIT ldx V.PORT,U I/o port address

         stb   StatReg,x
         ldb   #$02
         stb   <HALTED,u
         ldd   <$26,y       a=Parity and b=baud rate?
         andb  #$0F
         leax  <L007C,pcr
         ldb   b,x
         anda  #$F0
         sta   V.TYPE,u
         ldx   V.PORT,u
         std   CmndReg,x
         lda   ,x
         lda   ,x
         tst   StatReg,x
         lbmi  ErrNtRdy
         clra
         clrb
         std   <INXTI,u
         std   <ONXTI,u
         sta   <INHALT,u
         sta   <INCNT,u
         std   <u0024,u
         ldd   V.PORT,u        get address to poll
         addd  #StatReg         Add location of status register
         leax  >ACMASK,pcr     point to IRQ packet
         leay  >ACIRQ,pcr     point to IRQ service routine
         os9   F$IRQ
         bcs   INITERR         abnormal exit if error
         ldx   V.PORT,u
         ldb   V.TYPE,u
         orb   #$01
         stb   $02,x
         clrb
INITERR  rts

*
L007C    fcb   $13        110 baud
         fcb   $16        300 baud
         fcb   $17        600 baud
         fcb   $18       1200 baud
         fcb   $1A       2400 baud
         fcb   $1C       4800 baud
         fcb   $1E       9600 baud
         fcb   $1F      19200 baud

*****************************
* READ
*  read a byte from Uart
*  Entry: U = Address of device static Storage
*         Y = Address of the path Descriptor
*  Output A = character read
*
READ00    bsr   ACSLEP
READ     lda   INHALT,u
         ble   Read.a
         ldb   INCNT,u
         cmpb  #$0A
         bhi   Read.a
         ldb   u000F,u
         orb   #$80
 stb INHALT,U flag input resume
 ldb V.TYPE,U get control value
         orb   #$05
         ldx   V.PORT,u
         stb   CmndReg,x
Read.a    tst   <u0024,u
         bne   ErrNtRdy
         ldb   <INXTO,u
         leax  <INPBUF,u
 orcc #IntMasks calm interrupts
         cmpb  <INXTI,u
         beq   READ00      No data available
         abx
         lda   ,x
         dec   <INCNT,u
         incb
         cmpb  #INPSIZ-1
         bls   L00BF
         clrb
L00BF    stb   <INXTO,u
         clrb
         ldb   V.ERR,u
         beq   L00CF
         stb   <PD.ERR,y
         clr   V.ERR,u
         comb
         ldb   #E$Read
L00CF    andcc #^IntMasks       Allow I and F interrupts
         rts

ErrNtRdy comb
 ldb #E$NotRdy
 rts

**********
* Acslep - Sleep for I/O activity
*  This version Hogs Cpu if signal pending
*
* Passed: (cc)=Irq's Must be disabled
*         (U)=Global Storage
*         V.Busy,U=current proc id
* Destroys: possibly Pc

ACSLEP pshs D,X
 lda V.BUSY,U get current process id
 sta V.Wake,U arrange wake up signal
 andcc #^IntMasks interrupts ok now
 ldx #0
 OS9 F$Sleep wait for input data
         ldx   <D.Proc
         ldb   <P$Signal,x
         beq   ACSL90
         cmpb  #$03       Abort?
         bls   ACSLER
ACSL90    clra
         lda   $0D,x
         bita  #$02
         bne   ACSLER
         puls  pc,x,b,a
ACSLER    leas  $06,s
         coma
         rts

***************
* Write
*   Write char Through Acia
*
* Passed: (A)=char to write
*         (Y)=Path Descriptor
*         (U)=Static Storage address
* returns: CC=Set If Busy (output buffer Full)
*
WRIT00    bsr   ACSLEP
WRITE    leax  <OUTBUF,u   Base of buffer?
         ldb   <ONXTI,u
         abx              Add B into X
         sta   ,x
         incb
         cmpb  #OUTSIZ-1           ; End of Queue area ?
         bls   L010D
         clrb
L010D    orcc  #IntMasks       Block I and F interrupts
         cmpb  <ONXTO,u
         beq   WRIT00
         stb   <ONXTI,u
         lda   <HALTED,u
         beq   L012B
         anda  #$FD
         sta   <HALTED,u
         bne   L012B
         lda   V.TYPE,u
         ora   #$05
         ldx   V.PORT,u
         sta   CmndReg,x
L012B    andcc #^IntMasks      Allow I and F interrupts
Write90  clrb
         rts

**************************
* GETSTA
*  get device status
* (A) = opcode
* (U) = Address of device static storage

GETSTA   cmpa  #SS.Ready
         bne   GETS10
         ldb   <INCNT,u
         beq   ErrNtRdy
         ldx   PD.RGS,y
         stb   R$B,x
L013C    clrb
         rts
GETS10   cmpa  #SS.EOF   We never have EOF
         beq   Write90
unksvc   comb
         ldb   #E$UnkSvc
         rts
**************************
* PUTSTA
*  Set device Status
* (U) = Address of device static storage

PUTSTA   cmpa  #SS.SSig   Send signal on data ready
         bne   SetRel
         lda   PD.CPR,y
         ldx   PD.RGS,y
         ldb   $05,x
         orcc  #IntMasks       Block I and F interrupts
         tst   <INCNT,u
         bne   L015C
         std   <u0024,u
         bra   L012B
L015C    andcc #^IntMasks       Allow I and F interrupts
         lbra  Signal
SetRel   cmpa  #SS.Relea
         bne   unksvc
         lda   PD.CPR,y
         cmpa  <u0024,u
         bne   L013C
         clr   <u0024,u
         rts
***************************
*
TRMN00    lbsr  ACSLEP
TRMNAT     ldx   <D.Proc
         lda   ,x
         sta   V.BUSY,u
         sta   V.LPRC,u
         ldb   <ONXTI,u
         orcc  #IntMasks       Block I and F interrupts
         cmpb  <ONXTO,u
         bne   TRMN00
         lda   V.TYPE,u
         ldx   V.PORT,u
         sta   CmndReg,x
         andcc #^IntMasks       Allow I and F interrupts
         ldx   #$0000
         os9   F$IRQ
         rts
*
ACIRQ    ldx   V.PORT,U get port address
         tfr   a,b copy status
         andb  #INPERR mask status error bits
         cmpb  <u0026,u
         beq   L01AB
         stb   <u0026,u
         bitb  #INPERR
         lbne  InXOFF
         lbra  InXON

L01AB    bita  #$08
         bne   L01FD
         lda   <INHALT,u
         bpl   L01C4
         anda  #$7F
         sta   DataReg,x
         eora  u000F,u
         sta   <INHALT,u
         lda   <HALTED,u
         bne   L01EA
         clrb
         rts
*
L01C4    leay  <OUTBUF,u
         ldb   <ONXTO,u
         cmpb  <ONXTI,u
         beq   L01E2
         clra
         lda   d,y
         incb
         cmpb  #OUTSIZ-1           ; End of Queue area ?
         bls   L01D8
         clrb              Reset buffer tail
L01D8    stb   <ONXTO,u
         sta   ,x
         cmpb  <ONXTI,u
         bne   WakeUp
L01E2    lda   <HALTED,u
         ora   #$02
         sta   <HALTED,u   Set bit 2
L01EA    ldb   V.TYPE,u
         orb   #$01
         stb   $02,x
WakeUp   ldb   #S$Wake     get wakeup signal
         lda   V.WAKE,u
L01F4    beq   IRQSVC80
         clr   V.WAKE,u
Signal   os9   F$Send    A=process ID, B=signal to send
IRQSVC80 clrb            clear the carry bit
         rts
*
L01FD    bita  #$07
         beq   InIRQ
         tfr   a,b
         tst   ,x
         anda  #$07
         ora   V.ERR,u
         sta   V.ERR,u
         lda   $02,x
         sta   $01,x
         sta   $02,x
         bra   IRQSVC80

InIRQ    lda   ,x
         beq   InIRQ1
         cmpa  V.INTR,u
         beq   InAbort
         cmpa  V.QUIT,u
         beq   InQuit
         cmpa  V.PCHR,u
         beq   InPause
         cmpa  u000F,u
         beq   InXON
         cmpa  <u0010,u
         lbeq  InXOFF

InIRQ1    leax  <INPBUF,u
         ldb   <INXTI,u
         abx
         sta   ,x
         incb
         cmpb  #INPSIZ-1
         bls   L023D
         clrb
L023D    cmpb  <INXTO,u
         bne   L024A
         ldb   #$04
         orb   V.ERR,u
         stb   V.ERR,u
         bra   WakeUp
L024A    stb   <INXTI,u
         inc   <INCNT,u
         tst   <u0024,u
         beq   L025D
         ldd   <u0024,u
         clr   <u0024,u
         bra   Signal
L025D    lda   <u0010,u
         beq   WakeUp
         ldb   <INCNT,u
         cmpb  #$46
         bcs   WakeUp
         ldb   <INHALT,u
         bne   WakeUp
         anda  #$7F
         sta   <u0010,u
         ora   #$80
         sta   <INHALT,u
         ldb   V.TYPE,u
         orb   #$05
         ldx   V.PORT,u
         stb   CmndReg,x
         lbra  WakeUp

InPause    ldx   V.DEV2,u
         beq   InIRQ1
         sta   $08,x
         bra   InIRQ1
InAbort   ldb   #S$Intrpt
         bra   InQuit10

InQuit    ldb   #S$Abort
InQuit10    pshs  a
         lda   V.LPRC,u   Wake up last active process
         lbsr  L01F4
         puls  a
         bra   InIRQ1

InXON    lda   <HALTED,u
         anda  #$FE       clear bit 1
         sta   <HALTED,u
         bne   L02AC
         lda   V.TYPE,u
         ora   #$05
         sta   $02,x
L02AC    clrb
         rts
*
InXOFF    lda   <HALTED,u
         bne   L02B9
         ldb   V.TYPE,u
         orb   #$01
         stb   $02,x
L02B9    ora   #$01       set bit 1
         sta   <HALTED,u
         clrb
         rts
*
         emod
eom      equ   *
