 nam R0
 ttl RAMMER Device Descriptor
********************************************************************
* R0 - RAMMER Device Descriptor
*
* The way RAMMER calculates how many LSNs to allocate is broken!
*
* It first puts the Cyls in register B, the number of sides in
* register A and multiplies. It then discards the value in A.
* Therefore the first multiplication must not have a result higher
* than 255. Rammer then loads the number of sectors per track
* into register A and does another multiplication. The result is
* the total number of sectors of the RAM disk.
*
* Therefore: Don't change the RAMsize. Instead set the number of
* sectors according to your needs.

 use defsfile

Type set DEVIC+OBJCT
Revs set REENT+0

 mod DescEnd,DescName,Type,Revs,DscMgr,DscDrv
 fcb DIR.+SHARE.+PREAD.+PWRIT.+PEXEC.+READ.+WRITE.+EXEC.
 fcb IOBlock/DAT.BlCt port bank
 fdb $FFE0      physical controller address
 ifeq DrvSiz-535
DrvTyp set 0 5" drive
Cyls set 35
 ifeq Densy
SecTrk set 10
SecTr0 set 10
 else
SecTrk set 16
SecTr0 set 10
 endc
 endc
 ifeq DrvSiz-535-40
DrvTyp set $40 5" drive (Percom)
Cyls set 35
SecTrk set 10
SecTr0 set 10
 endc
 ifeq DrvSiz-540
DrvTyp set 0 5" drive
Cyls set 40
 ifeq Densy
SecTrk set 10
SecTr0 set 10
 else
SecTrk set 16
SecTr0 set 10
 endc
 endc
 ifeq DrvSiz-580
DrvTyp set 0 5" drive
Cyls set 80
 ifeq Densy
SecTrk set 10
SecTr0 set 10
 else
SecTrk set 16
SecTr0 set 10
 endc
 endc
 ifeq DrvSiz-877
DrvTyp set 1 8" drive
Cyls set 77
 ifeq Densy
SecTrk set 16
SecTr0 set 16
 else
SecTrk set 28
SecTr0 set 16
 endc
 endc
 fcb DescName-*-1 initilization table size
 fcb DT.RBF (IT.DTP)
 fcb 0 drive number
 fcb 0 step rate
 fcb $20 drive device type
 fcb 1 media density:0=single,1=double
 fdb Cyls  (IT.CYL)
 fcb Sides
 fcb 1 verify disk writes:0=on
 fdb SecTrk   # of sectors per track
 fdb SecTr0   # of sectors per track (track 0)
 fcb 1        sector interleave factor
 fcb 4        minimum size of sector allocation

DD equ 0

 IFNE  DD
DescName fcs /DD/
 ELSE
DescName fcs /R0/
 ENDC
DscMgr fcs /RBF/
DscDrv fcs /Rammer/

 emod
DescEnd equ *
 end
