 nam ccdevice
 ttl Select device containing definitions

 ifp1
 use os9defs
 endc

 mod eom,name,Data+0,ReEnt+1,devname,0

name fcs "CCDevice"

devname fcc "/d0"
 fcb 0
 emod

eom equ *
