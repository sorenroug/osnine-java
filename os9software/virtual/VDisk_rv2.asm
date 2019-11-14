 nam VDisk
 ttl Device Driver for a virtual disk

*********************************************
* VDisk - A driver for a virtual disk.
* This complements the VirtualDisk.java in osnine-java.
* Revisions:
*
* 2019-11-14 Added the ability to format disks
*
* 2019-11-13 Support for up to four disks. Edition 2.

         ifp1
         use defsfile
         endc

Revision equ 2
Edition  equ 1
NumDrvs  set 4              Number of drives

         org DrvBeg
         rmb NumDrvs*DrvMem
LSNZERO  rmb 1
CURDRV rmb 1
DSKSTA   equ .

         mod DSKEND,DSKNAM,Drivr+Objct,Reent+Revision,DSKENT,DSKSTA
         fcb $FF        Mode byte
DSKNAM   fcs /VDisk/
         fcb  Edition

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
INIT     lda #NumDrvs
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

*
* Get the drive number and shift it to top two bits
* Entry:
*        Y = Path Descriptor
SELECT lda PD.DRV,Y Get drive number
 cmpa  #4 Drive num ok?
 bcc BADUNIT ..yes
* could also be 3 rora
 lsla
 lsla
 lsla
 lsla
 lsla
 lsla
 rts

BADUNIT comb
 ldb #E$UNIT Error: illegal unit (drive)
 rts

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
         cmpx #$0000
         bne NOTLSN0
         inc LSNZERO,u
NOTLSN0  tfr x,d
         ldx V.PORT,u
         std AddrReg,x    Write the LSN to the at AddrReg, AddrReg+1
         bsr SELECT       Get drive number
         ora #RdLSN
         sta OpReg,x      Tell the chip to read a sector
         ldb OpReg,x      Read status code
         bne FAIL
         pshs y           preserve pointer to PD
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
         ldb #DrvMem
         mul
         leax DrvBeg,u
         leax d,x
         ldy PD.BUF,y
         ldb #DD.SIZ-1
COPLSN0  lda b,y
         sta b,x
         decb
         bpl COPLSN0
READ90   clrb
         rts

* Raise failure. B already contains error code
FAIL     orcc  #Carry
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
* 2. Write the LSN to the chip at AddrReg, AddrReg+1
* 3. Tell the chip to write a sector to disk
*
WRITE    pshs x,y         preserve LSN and PD
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
         puls x,y    Y = Path Descriptor
         bsr SELECT       Get drive number
         ldy V.PORT,u
         stx AddrReg,y    Write the LSN to the at AddrReg, AddrReg+1
         ora #WrLSN
         sta OpReg,y      Tell the chip to write a sector
         ldb OpReg,y      Read status code
         bne FAIL
WRIT99   rts

**************************
* GETSTA
*  get device status
*
GETSTA
Unknown  comb             Set carry
         ldb #E$UnkSVC
         rts

**************************
* PUTSTA
*  Set device Status
* Entry: U = Static Storage
*        Y = Path Descriptor
*        A = Status code
PUTSTA   cmpa #SS.Reset
         beq PUTSTA90
         cmpa #SS.SQD  Sequence down disk
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

