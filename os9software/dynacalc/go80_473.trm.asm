*
* A terminal driver that is compatible with DragonPlus board
*
 ifp1
 use defsfile
 use dynacalc_473.inc
 endc
 opt m
 org 0
 use header_473.inc
 use go80.keys
 use rest.inc
 use banner_drg.inc
Target set $F00
 use filler.inc
 use helps_473.inc
 use help80.inc
Target set $3200
 use filler.inc

