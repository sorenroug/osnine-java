 nam Rammer
 ttl OS-9/NitrOS-9 Level 2 RAM Disk
********************************************************************
* Rammer - NitrOS-9 Level 2 RAM Disk
*
* Alan DeKok's version of RAMMER - Based on original Keving Darling version
*
* NOTE: For some reason, when DEINIZing /r0, the INIT routine gets called...
*       but it still deallocates memory!
*
* Edt/Rev  YYYY/MM/DD  Modified by
* Comment
* ------------------------------------------------------------------
*   4      ????/??/??  ???
* Original Kevin Darling Version.
*
*   5      2000/03/14  L. Curtis Boyle
* Several changes
*
*   5r2    2000/05/09  L. Curtis Boyle
* Allowed driver to go past 400K, attempted some fixes for handling /MD,
* so that setting vfy=0 on /R0 would not completely crash the system.
* Fixed some error reporting bugs that would crash the system, and
* moved entry table to between READ/WRITE to allow short branches to both.
*
*   6      2020/10/31  S. Roug
* Modifications for 4 KB DAT blocks. Fixed a bug where lda a,x didn't
* work if a >= 128. Removed the H6309 code.


* Following CAN be set higher, but will take another page of system RAM then.
* 200 will allow maximum of 1,638,400 byte RAM drive for 8K blocks.
MAXBLOCK set   201         Maximum # of MMU blocks allowed in RAM drive

 use defsfile

IT.CYL equ $17
IT.SID equ $19
IT.SCT equ $1B
IT.T0S equ $1D

edition set 6

 mod RDSKEnd,RDSKNam,Drivr+Objct,ReEnt+2,RDSKEnt,RDSKSiz

* Device mem stuff - can make MMUTable bigger, but will take 2 pages of system
*  RAM then for device memory
*
 org DRVBEG
 rmb DRVMEM Reserve room for 1 entry drive table
MDFlag rmb 1 0=R0 descriptor, <>0=MD descriptor
NumOfBlk rmb 1 # of MMU blocks allocated for RAM drive
MMUTable rmb MAXBLOCK  Table of MMU Block #'s being used.
RDSKSiz equ .

 fcb DIR.+SHARE.+PREAD.+PWRIT.+PEXEC.+READ.+WRITE.+EXEC.

RDSKNam fcs /Rammer/
 fcb edition

*****************************************************************
*
* Terminate routine - deallocates RAM
*
TERMINAT lda NumOfBlk,u Get # blocks we had allocated
 beq TERM20 exit if none
 leay MMUTable,u Point to MMU block table
TERM10 ldb ,y
 clr ,y+ Zero it out in table
 pshs a
 clra
 tfr d,x
 puls a
 ldb #1 one block to deallocate
 os9 F$DelRAM Deallocate the block
 deca Dec # of blocks to clean out
 bne TERM10 Do until entire RAM drive is deallocated
TERM20 clrb Exit w/o error
 rts

* Deallocate RAM allocated so far, exit with no RAM error
DelRAM bsr TERMINAT Deallocate all RAM Drive ram blocks
EMemFul comb Exit no RAM left error
 ldb #E$MemFul
 rts
 page
*****************************************************************
*
* Init routine - only gets called once per driver inited.
* Called if you INIZ the device as well
* Entry: Y=Address of device descriptor
*        U=Device mem area
* NOTE: All of device mem (Except V.PORT) is cleared to 0's
*
Init lda #1
 sta V.NDRV,u only can handle 1 drive descriptor
 leax DRVBEG,u Point to start of drive table
 sta DD.TOT+2,x Set DD.TOT to non 0 value
 lda M$Opt,y Get # of bytes in device descriptor table
 deca
* Following is if 1st access to RAMMER is on /MD
 beq GetStat If 0 (/MD desciptor), then exit w/o error
 ldb IT.CYL+1,y Get LSB of # of cylinders
 lda IT.SID,y Get # of heads
 mul Calculate # head/cyls total
 lda IT.SCT+1,y  Get # of sectors/track
 mul Calculate # of sectors for RAM drive
 subd IT.SCT,y Subtract 1 tracks worth
 addd IT.T0S,y Add in the special track 0's # sectors/track
 std DD.TOT+1,x Save as # sectors on drive
 addd #(DAT.BlSz-1)/256 round to next block
 rolb
 rola
 rolb
 rola
 rolb
 rola
 ifle DAT.BlSz-4096
 rolb
 rola
 ifle DAT.BlSz-2048
 rolb
 rola
 endc
 endc
 cmpa #MAXBLOCK If higher than max, exit with mem full error
 bhi EMemFul
 leax MMUTable,u Point to RAM block table
INIT10 ldb #1 Try to allocate 1 RAM block
 pshs A
 os9 F$AllRAM
 puls A
 bcs DelRAM If error, deallocate RAM, and exit
 inc NumOfBlk,u Bump up # of blocks allocated
 stb ,x+ Save MMU block # allocated in table
 deca Do until done all blocks requested
 bne INIT10
* Copy DD.TOT to LSN on RAM drive
* clrb
* ldx #0 LSN 0
* bsr CALC20  FIXME: check registers
* leay DRVBEG,u Point to start of drive table
* exg x,y
* bsr TRANSFER
 clrb No error & return
 rts
 page
*****************************************************************
*
* Entry: B:X=LSN to read (only X will be used, even with 2 MB)
*        Y=Path dsc. ptr
*        U=Device mem ptr
*
Read pshs y,x Preserve path & device mem ptrs
 bsr CALCBLK Calculate MMU block & offset for sector
 bcs ErrExit Error, exit with it
 bsr TRANSFER Transfer sector from RAM drive to PD.BUF
 puls y,x Restore ptrs
 leax 0,x Sector 0?
 bne GetStat No, exit without error
 ldx PD.BUF,y Get buffer ptr
 leay DRVBEG,u Point to start of drive table
 ldb #DD.SIZ Copy the info we need into drive table
ReadLp lda ,x+
 sta ,y+
 decb
 bne ReadLp


*****************************************************************
*
* GetStat/SetStat - no calls, just exit w/o error
*
PutStat equ *
GetStat  clrb
Retrn    rts

ErrExit puls y,x,pc

*****************************************************************
* Entry table
*
RDSKEnt bra Init
 nop
 bra Read
 nop
 bra Write
 nop
 bra GetStat
 nop
 bra PutStat Actually GetStat (no calls, so same routine)
 nop
 lbra TERMINAT Terminate (returns memory)
 page
*****************************************************************
* Subroutine Write
*
* Entry: B:X = LSN to write
*        Y=Path dsc. ptr
*        U=Device mem ptr
*
Write bsr CALCBLK Calculate MMU Block & offset for sector
 bcs Retrn Error,exit with it
 exg x,y X=Sector buffer ptr, Y=Offset within MMU block
*
* Fall through to transfer
*
* Transfer between RBF sector buffer & RAM drive image sector buffer
* Called by both READ and WRITE (with X,Y swapping between the two)
*
TRANSFER orcc #IntMasks
 pshs x Preserve X
 ldx D.SysDAT Get ptr to system DAT image
 ldb 1,x Get original System MMU block #0
 puls x Get X back
 sta DAT.Regs+0 Map in RAM drive block into block #0
 clrb
WriteLp lda ,x+
 sta ,y+
 decb
 bne WriteLp
 stb DAT.Regs+0 Remap in system block 0
 andcc #^(IntMasks+Carry) Turn IRQ's back on & no error
 rts
 page
*****************************************************************
*      Subroutine CALCBLK
*
* Calculate MMU block # and offset based on sector # requested
*
* Entry: Y=path dsc. ptr
*        U=device mem ptr
*        B:X=LSN to calculate for
* Exit: A=MMU block # we need to map in
*       X=offset within MMU block to get sector from (always <8K)
*       Y=Sector buffer ptr for RBF
*       MDFlag,u=0 if NOT MD, else MD
*
CALCBLK clr MDFlag,u Flag that we are on "real" RAM Drive
 pshs x
 ldx PD.DEV,y Get our Device table entry ptr
 ldx V$DESC,x Get device descriptor ptr
 lda M$Opt,x Get size of options table
 puls x
 deca
 bne CALC10 branch if not MD
 inc MDFlag,u Flag we are on MD
 sta <PD.SIZ,y
 sta <PD.SIZ+3,y
 sta <PD.SSZ,y
 ldd D.BlkMap+2 Get end of block memory ptr
 subd D.BlkMap Calc # of blocks of RAM

 lda #256/DAT.BlCt # of 'sectors' in block
 mul
 std <PD.SIZ+1,y Save as middle word of file size
 std <PD.SSZ+1,y Save as segment size
 bra CALC20 Skip ahead (sector # will allow all 2 MB)

CALC10 tstb Test MSB of sector #
 bne TooHigh <>0, exit with Sector error
CALC20 pshs x Preserve LSW of sector #
 ldd 0,s Load it again into D
 tst MDFlag,u We on MD?
 bne CALC30 Yes, skip ahead
 leax DRVBEG,u Point to drive table
 cmpd DD.TOT+1,x LSW of sector compared to table's # of sectors
 bhs TooHigh2 Sector # too large, exit with error

CALC30 rolb
 rola
 rolb
 rola
 rolb
 rola
 ifle DAT.BlSz-4096
 rolb
 rola
 ifle DAT.BlSz-2048
 rolb
 rola
 endc
 endc
 tst MDFlag,u We on /MD?
 bne CALC40 ..yes, skip calculating MMU stuff
 leax MMUTable,u Point to MMU table
 clrb
 exg a,b
 lda D,X get MMU block (2's complement offset)
 beq TooHigh2 if 0, exit with sector error
CALC40 pshs A save block number
 clrb
 lda 2,S Calculate offset within block we want
 anda #(DAT.BlSz/256)-1 Mask out all but within block address offset
 std 1,s save offset
 ldy PD.BUF,y get sector buffer address
 puls x,a,pc return offset, MMU block

TooHigh2 leas 2,s Eat X on stack
TooHigh comb Exit with bad sector #
 ldb #E$Sect
 rts

 emod
RDSKEnd equ *
 end
