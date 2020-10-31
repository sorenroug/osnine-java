 nam R0
 ttl RAMMER Device Descriptor
********************************************************************
* R0 - RAMMER Device Descriptor
*
* The way RAMMER calculates how many LSNs to allocate is broken!
*
* It first puts the RAMSize in register B, the number of sides in
* register A and multiplies. It then discards the value in A.
* Therefore the first multiplication must not have a result higher
* than 255. Rammer then loads the number of sectors per track
* into register A and does another multiplication. The result is
* the total number of sectors of the RAM disk.
*
* Therefore: Don't change the RAMsize. Instead set the number of
* sectors according to your needs.

 use defsfile

RAMSize equ 128
SAS set 4

 mod eom,name,Devic+Objct,ReEnt+0,mgrnam,drvnam

 fcb DIR.+SHARE.+PREAD.+PWRIT.+PEXEC.+READ.+WRITE.+EXEC. mode byte
 fcb IOBlock/DAT.BlCt port bank
 fdb $FFE0      physical controller address
 fcb initsize-*-1 initilization table size
 fcb DT.RBF (IT.DTP)
 fcb 0 drive number
 fcb 0 step rate
 fcb $20 drive device type
 fcb 1 media density:0=single,1=double
 fdb RAMSize  (IT.CYL)
 fcb 1 number of sides (don't change)
 fcb 1 verify disk writes:0=on
 fdb SECTORS   # of sectors per track
 fdb SECTORS   # of sectors per track (track 0)
 fcb 1        sector interleave factor
 fcb 4        minimum size of sector allocation
initsize equ   *

DD equ 0

 IFNE  DD
name fcs /DD/
 ELSE
name fcs /R0/
 ENDC
mgrnam fcs /RBF/
drvnam fcs /Rammer/

 emod
eom equ *
 end
