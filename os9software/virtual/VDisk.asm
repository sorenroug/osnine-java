*********************************************
* VDisk - A driver for a virtual disk.
* This complements the VirtualDisk.java in osnine-java.
*
         nam VDisk
         ttl A Device Driver for a virtual disk

         ifp1
         use defsfile
         endc

Revision equ 1
NumDrvs  set 1              Number of drives

         org DrvBeg
         rmb NumDrvs*DrvMem
LSNZERO  rmb 1
DSKSTA   equ .

         mod DSKEND,DSKNAM,Drivr+Objct,Reent+Revision,DSKENT,DSKSTA
         fcb $FF        Mode byte
DSKNAM   fcs /VDisk/

OpReg    equ 0
AddrReg  equ 1
ValuReg  equ 2

WrByte   equ 1
WrLSN    equ 2
RdLSN    equ 3
RdByte   equ 4
Reset    equ 5

DSKENT   lbra INIT
         lbra READ
         lbra WRITE
         lbra GETSTA
         lbra PUTSTA
         lbra TERM

*****************************
* INIT
* Set up the virtual disk. The disk is attached to a memory location
* of three bytes.
*  Entry: U = Static Storage
*         Y = Path Descriptor
INIT     lda #NumDrvs     Set no drives to 1
         sta V.NDRV,U
         ldb #Reset
         ldx V.PORT,u
         stb OpReg,x      Reset chip
         ldb #$FF         non-zero value
         leax DrvBeg,U    X=Start of drive table
initdrv
         stb DD.Tot,x     Write in non-zero values
*        stb DD.Tot+1,x
*        stb DD.Tot+2,x
         stb V.Trak,x
         leax DrvMem,x    Jump to next drive
         deca             loop through drives
         bne initdrv
         clrb
INITXIT  rts

*****************************
* READ
*  read a sector from disk
*  Entry: U = Static Storage
*         Y = Path Descriptor
*         B = MSB of LSN (Ignored)
*         X = 2*LSB of LSN
*  Exit: 256 byte sector in PD.BUF buffer
*
* Algoritm
* 1 Write the LSN to the chip at AddrReg, AddrReg+1
* 2. Tell the chip to fetch a sector from disk
* 3. Copy the 256 bytes into the buffer.
READ     clr LSNZERO,u
         pshs y           preserve pointer to PD
         cmpx #$0000
         bne NOTLSN0
         inc LSNZERO,u
NOTLSN0  tfr x,d
         ldx V.PORT,u
         std AddrReg,x    Write the LSN to the at AddrReg, AddrReg+1
         ldb #RdLSN
         stb OpReg,x      Tell the chip to read a sector
         ldy PD.BUF,y
         clrb
READBYTE lda #RdByte
         sta OpReg,x      Tell the chip to fetch a byte
         lda ValuReg,x    Get the byte
         sta ,y+
         incb
         bne READBYTE     Branch if B!=0
         puls y           Restore y
* Special code for LSN 0
         tst LSNZERO,u
         beq READ90
         lda PD.DRV,y
         ldb #DRVMEM
         mul
         leax DRVBEG,u
         leax d,x
         ldy PD.BUF,y
         ldb #DD.SIZ-1
COPLSN0  lda b,y
         sta b,x
         decb
         bpl COPLSN0
READ90   clrb
         rts

*****************************
* WRITE
*  Write a sector to disk
* Entry: U = Static Storage
*        Y = Path Descriptor
*        B = MSB of LSN (Ignored)
*        X = 2*LSB of LSN
*        PD.Buf,Y = Address of buffer to write
*
* Algoritm
* 1. Copy the 256 bytes into the buffer.
* 2 Write the LSN to the chip at AddrReg, AddrReg+1
* 3. Tell the chip to write a sector to disk
*
WRITE    pshs x           preserve LSN
         ldx PD.BUF,y     put the buffer address in X
         ldy V.PORT,u     put the port address in Y
         lda #Reset
         sta OpReg,y      Tell the chip to reset
         clrb
WRTLOOP  lda ,x+
         sta ValuReg,y    Write the byte
         lda #WrByte
         sta OpReg,y      Tell the chip to copy a byte
         incb
         bne WRTLOOP      Branch if B!=0

* write LSN address to chip
         puls x
         stx AddrReg,y    Write the LSN to the at AddrReg, AddrReg+1

         lda #WrLSN
         sta OpReg,y      Tell the chip to write a sector

         clrb
WRIT99   rts

**************************
* GETSTA
*  get device status
*
GETSTA
         ldx V.PORT,u
         sta OpReg,x      Send noop to chip
Unknown  comb             Set carry
         ldb #E$UnkSVC
         rts

**************************
* PUTSTA
*  Set device Status
* Entry: U = Static Storage
*        Y = Path Descriptor
*        A = Status code
PUTSTA   ldb #$80
         ldx V.PORT,u
         stb OpReg,x      Send noop to chip
         cmpa #SS.Reset
         beq PUTSTA90
         cmpa #SS.WTrk
         bne Unknown

PUTSTA90 clrb
         rts

*****************************
* TERM
*  terminate Driver
*
TERM     clrb
         rts

         emod
DSKEND   equ *

