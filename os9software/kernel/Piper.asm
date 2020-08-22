 nam Pipe Device Driver
 ttl Definitions

Type set Drivr+Objct
Revs set ReEnt+1
 mod   PipeEnd,PipeNam,Type,Revs,PipeEnt,V.User
 fcb Updat. mode
PipeNam fcs "Piper"
 fcb 2 edition number

 use defsfile

PipeEnt clrb
 rts
 nop
 clrb read
 rts
 nop
 clrb write
 rts
 nop
 clrb getstat
 rts
 nop
 clrb putstat
 rts
 nop
 clrb terminate
 rts

 emod
PipeEnd equ *

 end
