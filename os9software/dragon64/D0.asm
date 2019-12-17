********************************************************************
* progname - program module
*
* Ed.    Comments                                       Who YY/MM/DD
* ------------------------------------------------------------------
*  -     Original Dragon Data distribution version
*
 nam   D0
 ttl   40-track floppy disk device descriptor

 use defsfile

Type set DEVIC+OBJCT
Revs set REENT+1
 mod DescEnd,DescName,Type,Revs,DscMgr,DscDrv
 fcb DIR.+SHARE.+PREAD.+PWRIT.+UPDAT.+EXEC.+PEXEC.
 fcb   $FF extended controller address
 fdb DPort port address
 fcb DescName-*-1 Bytes of options
 fcb DT.RBF
 fcb 0 drive number
 fcb 0 step rate
 fcb $20 drive device type
 fcb 1 media density:0=single,1=double
 fdb 40 number of cylinders (tracks)
 fcb 1 number of sides
 fcb 0 Verify turned on
 fdb 18 # of sectors per track
 fdb 18 # of sectors per track (track 0)
 fcb 2 sector interleave factor
 fcb 8 Sector allocation size

DescName fcs "D0"
DscMgr fcs "RBF"
DscDrv fcs "DDisk"
 emod
DescEnd equ *
