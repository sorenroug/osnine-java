 nam   Padder
 ttl   os9 device driver

* This device is used to send/receive a message
* The message has the following structure
* Byte 0: opcode: 0 = read, 1 = write
* Byte 1: Physical memory address $00-$0F
* Byte 2: Physical memory address
* Byte 3: Physical memory address
* Byte 4: Byte to load/store
* How to use:
*    First write 0 if you want to read a byte, or 1 if you want to write
*    Then write the next three bytes for the memory address
*    Then read or write the next byte.

 use defsfile

tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
**********
* Static storage offsets
*
 org V.SCF room for scf variables
CMDCODE    rmb   1
OVERFLOW    rmb   1
BUFINX    rmb   1
u0020    rmb   1
u0021    rmb   1
u0022    rmb   1
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
READ    tst   OVERFLOW,u
         bne   L004E
         tst   CMDCODE,u
         bne   L004E
         ldb   BUFINX,u
         cmpb  #$04
         bne   L004E
         lbsr  MAPBLK
         pshs  u,cc
         ldu   DAT.Regs
         orcc  #$50
         stx   DAT.Regs
         lda   ,y
         stu   DAT.Regs
         puls  u,cc
L004E    clr   BUFINX,u
         clr   OVERFLOW,u
         clrb
         rts

* Write to a device
* A = Char to write
* Y = Address of path descriptor
* U = Address of device static storage
*
WRITE    ldb   BUFINX,u
         inc   BUFINX,u
         tstb  starting fresh?
         beq   L006D ..yes
         cmpb  #$01 first byte of address?
         beq   L007B
         cmpb  #$02
         beq   L008B
         cmpb  #$03
         beq   L0090
         bra   L0095

L006D    cmpa  #$01 Opcode 0 or 1
         bhi   L0076
         sta   CMDCODE,u
         bra   WRDONE

L0076    clr   BUFINX,u Reset message
         bra   WRDONE

L007B    cmpa  #$0F
         bhi   L0084
         sta   <u0020,u
         bra   WRDONE

L0084    lda   #1
         sta   OVERFLOW,u
         bra   WRDONE

L008B    sta   <u0021,u
         bra   WRDONE

L0090    sta   <u0022,u
         bra   WRDONE

L0095    tst   OVERFLOW,u
         bne   L00B2
         tst   CMDCODE,u
         beq   L00B2
         bsr   MAPBLK
         pshs  u,cc
         ldu   DAT.Regs
         orcc  #$50
         stx   DAT.Regs
         sta   ,y
         stu   DAT.Regs
         puls  u,cc
L00B2    clr   OVERFLOW,u
         clr   BUFINX,u
WRDONE   clrb
         rts

GETSTA    cmpa  #SS.Ready
         beq   TRMNAT
         cmpa  #SS.EOF
         beq   TRMNAT

* Y = Address of path descriptor
* U = Address of device static storage
*
PUTSTA    cmpa  #$80
         bne   L00FD
         orcc  #$50
         ldu   >$FFBC
         pshs  u
         ldu   >$FFBE
         ldy   #$01FA
         sty   >$FFBC
         leay  1,y
         sty   >$FFBE
         ldd   >$FC00
         cmpd  #$464C 'FL
         bne   L00F3
         ldd   >$FC02
         cmpd  #$4558 'EX
         bne   L00F3
         jmp   >$FE18

L00F3    stu   >$FFBE
         puls  u
         stu   >$FFBC
         andcc #$50
L00FD    comb
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
         ldb   <u0021,u
         lsrb make block count
         lsrb
         lsrb
         clra
         tfr   d,x
         lda   <u0020,u
         beq   L0119
L0113    leax  <$20,x
         deca
         bne   L0113
L0119    leax  >$0200,x
         ldd   <u0021,u
         anda  #^DAT.Addr get address within block
         tfr   d,y
         puls  pc,a

         emod
eom      equ   *
