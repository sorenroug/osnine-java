 nam Drive Descriptors

 opt -c

 use defsfile

 ifeq DiskType-G68
NamSiz set 3
L1 equ 'G
L2 equ '6
L3 equ '8
 endc
 ifeq DiskType-DCB4
NamSiz set 4
L1 equ 'D
L2 equ 'c
L3 equ 'b
L4 equ '4
 endc
 ifeq DiskType-ExDiskII
NamSiz set 5
L1 equ 'E
L2 equ 'x
L3 equ 'o
L4 equ 'r
L5 equ '2
 endc
 ifeq DiskType-ExDskIII
NamSiz set 5
L1 equ 'E
L2 equ 'x
L3 equ 'o
L4 equ 'r
L5 equ '3
 endc
 ifeq DiskType-Cms9670
NamSiz set 3
L1 equ 'C
L2 equ 'm
L3 equ 's
 endc
 ifeq DiskType-DMAF2
NamSiz set 5
L1 equ 'D
L2 equ 'M
L3 equ 'A
L4 equ 'f
L5 equ '2
 endc
 ifeq DiskType-DC2
NamSiz set 3
L1 equ 'D
L2 equ 'c
L3 equ '2
 endc
 ifeq DiskType-DC3
NamSiz set 3
L1 equ 'D
L2 equ 'c
L3 equ '3
 endc
 ifeq DiskType-LFD400
NamSiz set 6
L1 equ 'P
L2 equ 'c
L3 equ 'm
L4 equ '4
L5 equ '0
L6 equ '0
 endc
 ifeq DiskType-G28
NamSiz set 3
L1 equ 'G
L2 equ '2
L3 equ '8
 endc
 ifeq DiskType-G58
NamSiz set 3
L1 equ 'G
L2 equ '5
L3 equ '8
 endc

Pass set 0
Drive set 0

 use Desc_module

 end
