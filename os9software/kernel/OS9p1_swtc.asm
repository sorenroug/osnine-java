         use CPUTypeDefs

CPUType set SWTC

CPort equ $E090
A.Term equ $E004
A.T1 equ $E000
A.T.init equ $15
A.P1 equ $E020
A.P equ $E082

DPort set $E014

Drive set 0 start assembly with drive #0
DriveCnt set 4 drives max on system
Densy set 0 FM only
Sides set 2 single or double
StpRat set 0 slowest
IntrLeav set 3
DrvSiz set 535
Density set Densy+0 single track density

        use OS9p1
