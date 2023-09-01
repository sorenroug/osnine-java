         nam   Init
         ttl   os9 system module

* Disassembled 23/08/28 22:24:33 by Disasm v1.5 (C) 1988 by RML

         ifp1
         use   /dd/defs/os9defs
         endc
tylg     set   Systm+$00
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv
 fcb 0 no extended memory
 fdb $C000 High free memory bound
 fcb 12 Entries in interrupt polling table

         fcb   $0C
         fcb   $00
         fcb   $1A
         fcb   $00
         fcb   $1F
         fcb   $00
         fcb   $22 "
         fcb   $00
         fcb   $00
name     equ   *
         fcs   /Init/
         fcb   $53 S
         fcb   $79 y
         fcb   $73 s
         fcb   $47 G
         fcb   $EF o
         fcb   $2F /
         fcb   $44 D
         fcb   $B0 0
         fcb   $2F /
         fcb   $54 T
         fcb   $65 e
         fcb   $72 r
         fcb   $ED m
         fcb   $42 B
         fcb   $6F o
         fcb   $6F o
         fcb   $F4 t
         emod
eom      equ   *
