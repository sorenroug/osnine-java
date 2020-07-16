 nam Boot module for Virtual disk (L2)
 ttl Definitions

 use defsfile

 mod   BootEnd,BootNam,Systm+Objct,ReEnt+1,BootEnt,0


 fcb   $FF ??

BootNam fcs /Boot/
 fcb 1 Edition

DISKDEV equ $FCD1

* Variables
 org 0
V.BUFADR rmb 2
V.BSZ rmb 2    Size of boot file
VARSPACE equ .

OpReg    equ 0
AddrReg  equ 1
ValuReg  equ 2

WrByte   equ 1
WrLSN    equ 2
RdLSN    equ 3
RdByte   equ 4
Reset    equ 5

* Input: None
* Output: D = Size of boot file
*         X = Address where boot file was loaded into memory
BootEnt
 leas -VARSPACE,s  Make space for variables
* Allocate 256 byte buffer for LSN 0
 ldd #256
 os9 F$SRqMem
 bcs BootErr Unable to allocate
 stu V.BUFADR,s
 ldd #0    Load LSN 0
 ldx #DISKDEV
 std AddrReg,x
 lda #RdLSN
 sta OpReg,x Tell drive to read sector
 ldb OpReg,x Check for error
 bne BootErr
 tfr U,Y
 clrb
READBYTE lda #RdByte
 sta OpReg,x      Tell the chip to fetch a byte
 lda ValuReg,x    Get the byte
 sta ,y+
 incb
 bne READBYTE     Branch if B!=0
*
* LSN is fetched, check the boot file
*
 ldx V.BUFADR,S
 ldd DD.BSZ,x
 beq BootErr  No boot file?
 std V.BSZ,S    Save the boot size
* ldb   <DD.BT,x Ignore the High LSN byte for now
 ldy DD.BT+1,x
 ldd #256
 os9 F$SRtMem  Return memory boot sector
 ldd V.BSZ,S   Get the boot size
 os9 F$BtMem   Get memory in U, size in D
 ldx #DISKDEV
 stu V.BUFADR,s
 bsr READSC    Read the sectors
 ldd V.BSZ,s
 ldx V.BUFADR,S
 leas VARSPACE,s
 rts
*
* Error handling
*
BootErr0
 puls D
BootErr
 leas VARSPACE,s
 comb
 ldb #E$BTyp
 rts

*
* Read the sectors
* Input: D: Size in bytes (rounded up)
*        U: Memory location
*        X: Addr of device
*        Y: LSN
* Every time we go to the next sector we must tell the device
READSC0
 leay 1,y  Increment the LSN
READSC
 sty AddrReg,X Set LSN
 pshs D
 lda #RdLSN
 sta OpReg,X
 ldb OpReg,X
 bne BootErr0
READBT lda #RdByte
 sta OpReg,x      Tell the chip to fetch a byte
 lda ValuReg,x    Get the byte
 sta ,U+
 decb
 bne READBT     Branch if B!=0
* Decrement A and check MSBLSN
 dec 0,s
 puls D
 bne READSC0
 rts

 emod
BootEnd equ *
