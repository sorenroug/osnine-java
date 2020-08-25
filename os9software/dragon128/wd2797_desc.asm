 nam Drive Descriptors for WD2797 Controller

 opt -c

 use defsfile

FORMAT equ 0 use Microware 40 track format for d0 and d1

Drive set 0
DrvNam set 0 first descriptor drive number
DrvCnt set 4 number of descriptors
DrvSiz set 5
Sides set 2
DDTr0 set 0
StpRat set 1
IntrLeav equ 4
* ifeq DiskType-LFD400
NamSiz equ 6
L1 equ 'w
L2 equ 'd
L3 equ '2
L4 equ '7
L5 equ '9
L6 equ '7
* endc

N1 set 'd drive name letter
N2 set 0 no second letter

Pass set 0

 use desc

Drive set 0
DrvName set 0
DDTr0 set 4
N1 set 'f Dragon format descriptors
 use desc
 end
