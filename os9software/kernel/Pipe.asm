 nam Pipe Device Descriptor
 ttl Definitions 

 use defsfile

**********************************************************
*     Module Header
*
Type set Devic+Objct   
Revs set ReEnt+1
 mod   PipeEnd,PipeNam,Type,Revs,PipeMgr,PipeDrv
 fcb UPDAT. mode
 fcb 0,0,0 no port address
 fcb 1 option byte count
 fcb DT.Pipe
initsize equ   *
PipeNam fcs "Pipe" device name
PipeMgr fcs "PipeMan" file manager
PipeDrv fcs "Piper" device driver

 emod Module CRC
PipeEnd equ *

 end
