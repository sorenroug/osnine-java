* ACIA51 is a device driver for the serial port.

         nam   ACIA51
         ttl   os9 device driver

         ifp1
         use   defsfile
         endc
DataReg         equ   0
StatReg         equ   1
CmndReg         equ   2

NOTDSR   set   %01000000 not data set ready
DCDLST   set   %00100000 data carrier lost

INPERR   set   NOTDSR+DCDLST

tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
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
ReadPtr  rmb   1
u001E    rmb   1
u001F    rmb   1      0 = not ready?
WritPtr  rmb   1      end of circular buffer
u0021    rmb   1      start of circular buffer
u0022    rmb   1      Flag register?
u0023    rmb   1
u0024    rmb   2
u0026    rmb   1
ReadBuf  rmb   80
RxQLen   equ   .-ReadBuf
TxQ      rmb   140
TxQLen   equ   .-TxQ       Tx Queue length
size     equ   .
         fcb   $03
name     equ   *
         fcs   /ACIA51/
         fcb   $04
start    equ   *
         lbra  INIT
         lbra  READ
         lbra  WRITE
         lbra  GETSTA
         lbra  PUTSTA
         lbra  TERM
*****************************
* Init
* (U) = Address of device static storage
* (Y) = Address of device descriptor module
IRQPKT    fcb   $00,$80,$0A

INIT     ldx   V.PORT,u

         stb   StatReg,x
         ldb   #$02
         stb   <u0022,u
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
         lbmi  NotRdy
         clra
         clrb
         std   <ReadPtr,u
         std   <WritPtr,u
         sta   <u0023,u
         sta   <u001F,u
         std   <u0024,u
         ldd   V.PORT,u        get address to poll
         addd  #StatReg         Add location of status register
         leax  >IRQPKT,pcr     point to IRQ packet
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
L0084    bsr   NoData
READ     lda   <u0023,u
         ble   L00A1
         ldb   <u001F,u
         cmpb  #$0A
         bhi   L00A1
         ldb   u000F,u
         orb   #$80
         stb   <u0023,u
         ldb   V.TYPE,u
         orb   #$05
         ldx   V.PORT,u
         stb   CmndReg,x
L00A1    tst   <u0024,u
         bne   NotRdy
         ldb   <u001E,u
         leax  <ReadBuf,u
         orcc  #IntMasks       Block I and F interrupts
         cmpb  <ReadPtr,u
         beq   L0084      No data available
         abx
         lda   ,x
         dec   <u001F,u
         incb
         cmpb  #RxQLen-1
         bls   L00BF
         clrb
L00BF    stb   <u001E,u
         clrb
         ldb   V.ERR,u
         beq   L00CF
         stb   <PD.ERR,y
         clr   V.ERR,u
         comb
         ldb   #E$Read
L00CF    andcc #^IntMasks       Allow I and F interrupts
         rts
NotRdy   comb
         ldb   #E$NotRdy
         rts

NoData   pshs  x,b,a
         lda   V.BUSY,u   get proc ID
         sta   V.WAKE,u   arrange for wakeup
         andcc #^IntMasks       Allow I and F interrupts
         ldx   #0         Sleep indefinitely (x=0)
         os9   F$Sleep    Await an IRQ
         ldx   <D.Proc
         ldb   <P$Signal,x
         beq   L00EF
         cmpb  #$03       Abort?
         bls   L00F8
L00EF    clra
         lda   $0D,x
         bita  #$02
         bne   L00F8
         puls  pc,x,b,a
L00F8    leas  $06,s
         coma
         rts

*****************************
* WRITE
* Write a byte
*  Entry: U = Address of device static Storage
*         Y = Address of the path Descriptor
*  Output A = character to write
*
L00FC    bsr   NoData
WRITE    leax  <TxQ,u   Base of buffer?
         ldb   <WritPtr,u
         abx              Add B into X
         sta   ,x
         incb
         cmpb  #TxQLen-1           ; End of Queue area ?
         bls   L010D
         clrb
L010D    orcc  #IntMasks       Block I and F interrupts
         cmpb  <u0021,u
         beq   L00FC
         stb   <WritPtr,u
         lda   <u0022,u
         beq   L012B
         anda  #$FD
         sta   <u0022,u
         bne   L012B
         lda   V.TYPE,u
         ora   #$05
         ldx   V.PORT,u
         sta   CmndReg,x
L012B    andcc #^IntMasks      Allow I and F interrupts
noerror  clrb
         rts

**************************
* GETSTA
*  get device status
* (A) = opcode
* (U) = Address of device static storage

GETSTA   cmpa  #SS.Ready
         bne   ASKEOF
         ldb   <u001F,u
         beq   NotRdy
         ldx   PD.RGS,y
         stb   R$B,x
L013C    clrb
         rts
ASKEOF   cmpa  #SS.EOF   We never have EOF
         beq   noerror
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
         tst   <u001F,u
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
L0170    lbsr  NoData
TERM     ldx   <D.Proc
         lda   ,x
         sta   V.BUSY,u
         sta   V.LPRC,u
         ldb   <WritPtr,u
         orcc  #IntMasks       Block I and F interrupts
         cmpb  <u0021,u
         bne   L0170
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
         lbne  L02AE
         lbra  L029C

L01AB    bita  #$08
         bne   L01FD
         lda   <u0023,u
         bpl   L01C4
         anda  #$7F
         sta   DataReg,x
         eora  u000F,u
         sta   <u0023,u
         lda   <u0022,u
         bne   L01EA
         clrb
         rts
*
L01C4    leay  <TxQ,u
         ldb   <u0021,u
         cmpb  <WritPtr,u
         beq   L01E2
         clra
         lda   d,y
         incb
         cmpb  #TxQLen-1           ; End of Queue area ?
         bls   L01D8
         clrb              Reset buffer tail
L01D8    stb   <u0021,u
         sta   ,x
         cmpb  <WritPtr,u
         bne   WakeUp
L01E2    lda   <u0022,u
         ora   #$02
         sta   <u0022,u   Set bit 2
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
         beq   L0213
         tfr   a,b
         tst   ,x
         anda  #$07
         ora   V.ERR,u
         sta   V.ERR,u
         lda   $02,x
         sta   $01,x
         sta   $02,x
         bra   IRQSVC80

L0213    lda   ,x
         beq   L022E
         cmpa  V.INTR,u
         beq   Intrpt
         cmpa  V.QUIT,u
         beq   Abort
         cmpa  V.PCHR,u
         beq   L0283
         cmpa  u000F,u
         beq   L029C
         cmpa  <u0010,u
         lbeq  L02AE
L022E    leax  <ReadBuf,u
         ldb   <ReadPtr,u
         abx
         sta   ,x
         incb
         cmpb  #RxQLen-1
         bls   L023D
         clrb
L023D    cmpb  <u001E,u
         bne   L024A
         ldb   #$04
         orb   V.ERR,u
         stb   V.ERR,u
         bra   WakeUp
L024A    stb   <ReadPtr,u
         inc   <u001F,u
         tst   <u0024,u
         beq   L025D
         ldd   <u0024,u
         clr   <u0024,u
         bra   Signal
L025D    lda   <u0010,u
         beq   WakeUp
         ldb   <u001F,u
         cmpb  #$46
         bcs   WakeUp
         ldb   <u0023,u
         bne   WakeUp
         anda  #$7F
         sta   <u0010,u
         ora   #$80
         sta   <u0023,u
         ldb   V.TYPE,u
         orb   #$05
         ldx   V.PORT,u
         stb   CmndReg,x
         lbra  WakeUp

L0283    ldx   V.DEV2,u
         beq   L022E
         sta   $08,x
         bra   L022E
Intrpt   ldb   #S$Intrpt
         bra   L0291

Abort    ldb   #S$Abort
L0291    pshs  a
         lda   V.LPRC,u   Wake up last active process
         lbsr  L01F4
         puls  a
         bra   L022E

L029C    lda   <u0022,u
         anda  #$FE       clear bit 1
         sta   <u0022,u
         bne   L02AC
         lda   V.TYPE,u
         ora   #$05
         sta   $02,x
L02AC    clrb
         rts
*
L02AE    lda   <u0022,u
         bne   L02B9
         ldb   V.TYPE,u
         orb   #$01
         stb   $02,x
L02B9    ora   #$01       set bit 1
         sta   <u0022,u
         clrb
         rts
*
         emod
eom      equ   *
