 nam   Padder
 ttl   os9 device driver

* This device is used to read/write a byte at an address in physical
* RAM ($000000-$0FFFFF)
* 
* The message has the following structure
* Byte 0: command code: 0 = read, 1 = write
* Byte 1: Physical memory address $00-$0F
* Byte 2: Physical memory address
* Byte 3: Physical memory address
* Byte 4: Byte to load/store
* How to use:
*    First write 0 if you want to read a byte, or 1 if you want to write
*    Then write the next three bytes for the memory address
*    Then read or write the byte.

 use defsfile

tylg     set   Drivr+Objct
atrv     set   ReEnt+1

 mod   eom,name,tylg,atrv,start,size
**********
* Static storage offsets
*
 org V.SCF room for scf variables
CMDCODE  rmb 1
ABOVETOP rmb 1
STATE rmb 1
ADDRMSB rmb 1
ADDRMID rmb 1
ADDRLSB rmb 1
size     equ   .

 fcb UPDAT.

name fcs   /Padder/
         fcb 1

start    equ   *
         lbra  INIT
         lbra  READ
         lbra  WRITE
         lbra  GETSTA
         lbra  PUTSTA
         lbra  TRMNAT

INIT    clrb
        rts

* Read byte
* Y = Address of path descriptor
* U = Address of device static storage
*
READ     tst   ABOVETOP,u
         bne   READ10
         tst   CMDCODE,u
         bne   READ10
         ldb   STATE,u Get state?
         cmpb  #4 State 4?
         bne   READ10 branch if not
         lbsr  MAPBLK
         pshs  u,cc
         ldu   DAT.Regs
         orcc #IntMasks set interrupt masks
         stx   DAT.Regs
         lda   ,y
         stu   DAT.Regs
         puls  u,cc
READ10   clr   STATE,u
         clr   ABOVETOP,u
         clrb
         rts

* Write to a device
* A = Char to write
* Y = Address of path descriptor
* U = Address of device static storage
*
WRITE    ldb   STATE,u
         inc   STATE,u
         tstb  starting fresh?
         beq   TESTCMD ..yes
         cmpb  #1 first byte of address?
         beq   L007B
         cmpb  #2
         beq   L008B
         cmpb  #3
         beq   L0090
         bra   WRVALUE

TESTCMD cmpa  #1 Writing legal command 0 or 1
         bhi   WRRESET branch if not
         sta   CMDCODE,u
         bra   WRDONE

WRRESET  clr   STATE,u Reset message
         bra   WRDONE

L007B    cmpa  #$0F What is the value of MSB byte in address?
         bhi   L0084
         sta   ADDRMSB,u
         bra   WRDONE

L0084    lda   #1
         sta   ABOVETOP,u
         bra   WRDONE

L008B    sta   ADDRMID,u
         bra   WRDONE

L0090    sta   ADDRLSB,u
         bra   WRDONE

WRVALUE  tst   ABOVETOP,u
         bne   WRFAIL
         tst   CMDCODE,u
         beq   WRFAIL
         bsr   MAPBLK
         pshs  u,cc
         ldu   DAT.Regs
         orcc #IntMasks set interrupt masks
         stx   DAT.Regs
         sta   ,y
         stu   DAT.Regs
         puls  u,cc
WRFAIL    clr   ABOVETOP,u
         clr   STATE,u
WRDONE   clrb
         rts

GETSTA cmpa #SS.Ready
         beq TRMNAT
         cmpa #SS.EOF
         beq TRMNAT

* Y = Address of path descriptor
* U = Address of device static storage
*
PUTSTA   cmpa  #$80 Opcode $80?
         bne   SVCERR ..no
         orcc #IntMasks set interrupt masks
         ldu DAT.Regs+$3C  >$FFBC
         pshs  u
         ldu DAT.Regs+$3E   >$FFBE
         ldy   #$01FA  Map to logical memory space
         sty DAT.Regs+$3C   >$FFBC
         leay  1,y
         sty DAT.Regs+$3E   >$FFBE
         ldd   >$FC00
         cmpd  #"FL
         bne   L00F3
         ldd   >$FC02
         cmpd  #"EX
         bne   L00F3
         jmp   >$FE18 Boot into FLEX

L00F3    stu DAT.Regs+$3E  >$FFBE
         puls  u
         stu DAT.Regs+$3C   >$FFBC
         andcc #IntMasks unset interrupt masks (Bug, missing ^)
SVCERR    comb
         ldb   #E$UnkSvc
         rts

TRMNAT   clrb
         rts

*
* Subroutine dealing with memory block computation
* Returns:
*   (X) = Block number for DAT register
*   (Y) = Logical address in block
*   
MAPBLK   pshs  a
         ldb   <ADDRMID,u
         lsrb make block count
         lsrb
         lsrb
         clra
         tfr   d,x
         lda   ADDRMSB,u
         beq   L0119
L0113    leax  $20,x
         deca
         bne   L0113
L0119    leax  $0200,x
         ldd   ADDRMID,u
         anda  #^DAT.Addr get address within block
         tfr   d,y
         puls  pc,a

         emod
eom      equ   *
