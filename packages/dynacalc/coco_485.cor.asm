*
* DYNACALC for the TRS-80 Color computer uses the 32x16 display.
*
 ifp1
 use defsfile
DYNAVERS equ $485
 endc
 opt m
 org 0
         fcb   $ed,$87,$97,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcc   "DYNACALC, Version 4.8:5              "
         fcc   "Copyright (C) 1982,1984 by Scott Schaeferle."
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
M0088    fcb   $05,$21,$FF,$FF    Cursor on
M008C    fcb   $05,$20,$FF,$FF    Cursor off
M0090    fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
         fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  Terminal setup
M00A0    fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   Terminal kiss-off
M00A8    fcb   $FF,$FF,$00,$00    Cursor right
         fcb   $FF,$FF,$00,$00    Cursor ??
CURSPOS  fcb   $02,$27,$2C,$FF,$FF,$FF,$FF,$FF     Cyrsor XY
M00B8    fcb   $03,$FF,$FF,$FF,$FF,$FF   Cursor clear to EOL
         fcb   $FF,$FF,$FF,$FF,$FF,$FF   Cursor clear to end of screen
REVON    fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF Reverse on
REVOFF   fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF Reverse off
M00D4    fcb   $08,$20,$08,$FF,$00,$00  Destructive backspace
M00DA    fcb   $08,$FF,$00,$00   non-destructive backspace
M00DE    fcc   "                "  Terminal name (16 chars)
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
M00F7    fcb   $04  Log-off key
M00F8    fcb   $00  Upper case only
         fcb   $00
M00FA    fcb   $01
M00FB    fcb   $00  keep helps  T/F
         fcb   $FF  print borders  T/F
         fcb   79  printer page width
         fcb   $00  Pagination  T/F
M00FF    fcb   57  Lines per page
M0100    fcb   $0C     Up-arrow
DOWNKEY  fcb   $0A     Down-arrow
         fcb   $08     Left-arrow
         fcb   $09     Right-arrow
         fcb   $1C     Home key    (Ctrl-\)
         fcb   $1A     Jump window (Ctrl-Z)
         fcb   $07   Bell character
GETADDR  fcb   $18   Get address (Ctrl-X)
         fcb   $03   Flush type-ahead buffer (Ctrl-C)
         fcb   $05
         fcb   $20   direct cursor addressing row offset
         fcb   $20   direct cursor addressing columns offset
         fcb   $01
         fcb   16    number of rows on screen
         fcb   31  number of columns on screen
         fcb   $18
         fcb   $02
         fcb   $00
         fcb   $00

         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $64 d
         fcb   $13
         fcb   $00
         fcb   $5A Z
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $04
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $5D ]
         fcb   $31 1
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $94
         fcb   $FF
         fcb   $00
         fcb   $07
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $24 $
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $01
         fcb   $01
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $0C
         fcb   $07
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $01
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $0D
         fcb   $61 a
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $07
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $5C \
         fcb   $80
         fcb   $01
         fcb   $F1 q
         fcb   $03
         fcb   $00
         fcb   $00
         fcb   $FF
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   $00
         fcb   $01
         fcb   $01
         fcb   $00
         fcb   $00
         fcb   $01
         fcb   $00
         fcb   $00
         fcb   $10
         fcb   $08
         fcb   $18
         fcb   $0D
         fcb   $00
         fcb   $04
         fcb   $01
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $08
         fcb   $07
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $2E .
         fcb   $00
         fcb   $00
         fcb   $20
         fcb   $B9 9
         fcb   $75 u
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $01
         fcb   $01
         fcb   $00
         fcb   $01
         fcb   $01
         fcb   $00
         fcb   $01
         fcb   $10
         fcb   $08
         fcb   $18
         fcb   $0D
         fcb   $1B
         fcb   $04
         fcb   $01
         fcb   $17
         fcb   $03
         fcb   $05
         fcb   $08
         fcb   $07
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $2E .
         fcb   $00
         fcb   $00
         fcb   $20
         fcb   $B9 9
         fcb   $75 u
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $80
         fcb   $80
         fcb   $80
         fcb   $80
         fcb   $80
         fcb   $0D
         fcb   $FF
         fcb   $2B +
         fcb   $2D -
         fcb   $2E .
         fcb   $FF
         fcb   $2F /
         fcb   $2A *
         fcb   $5E ^
         fcb   $3C <
         fcb   $3E >
         fcb   $3D =
         fcb   $2C ,
         fcb   $FF
         fcb   $28 (
         fcb   $29 )
         fcb   $FF
         fcb   $23 #
         fcb   $40 @
         fcb   $FF
         fcb   $21 !
         fcb   $FF
         fcb   $FF
         fcb   $22 "
         fcb   $FF
         fcb   $2B +
         fcb   $2D -
         fcb   $28 (
         fcb   $2E .
         fcb   $40 @
         fcb   $23 #
         fcb   $FF
         fcb   $3E >
         fcb   $FF
         fcb   $58 X
         fcb   $21 !
         fcb   $0D
         fcb   $80
         fcb   $FF
         fcb   $80
         fcb   $80
         fcb   $80
         fcb   $80
         fcb   $FF
         fcb   $2F /
         fcb   $FF
         fcb   $FF
         fcb   $20
         fcb   $20
         fcb   $28 (
         fcb   $58 X
         fcb   $29 )
         fcb   $20
         fcb   $00

M03BB    fcc   "Ready"
         fcb   $00
M03C1    fcc   "Value"
         fcb   $00
M03C7    fcc   "Label"
         fcb   $00
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
M0562    fcc   "  January  0, 19 0"
         fcb   $00

M0575    fcb   $08
         fcb   $00
         fcb   $A8 (
         fcb   $D4 T
         fcb   $6A j
         fcb   $B5 5
M057B    fcb   $20
         fcb   $02
         fcb   $6A j
         fcb   $62 b
         fcb   $39 9
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   $08
         fcb   $C8 H
         fcb   $CA J
         fcb   $61 a
         fcb   $10
         fcb   $A7 '
         fcb   $C3 C
         fcb   $82
         fcb   $9A
         fcb   $CD M
         fcb   $07
         fcb   $75 u
         fcb   $87
         fcb   $CB K
         fcb   $EC l
         fcb   $83
         fcb   $22 "
         fcb   $AA *
         fcb   $36 6
         fcb   $DB [
         fcb   $AD -
         fcb   $01
         fcb   $02
         fcb   $82
         fcb   $08
         fcb   $C8 H
         fcb   $CA J
         fcb   $61 a
         fcb   $10
         fcb   $A7 '
         fcb   $C3 C
         fcb   $83
         fcb   $DA Z
         fcb   $EB k
         fcb   $E9 i
         fcb   $14
         fcb   $85
         fcb   $BD =
         fcb   $68 h
         fcb   $84
         fcb   $66 f
         fcb   $0A
         fcb   $FB
         fcb   $F5 u
         fcb   $8B
         fcb   $01
         fcb   $CE N
         fcb   $82
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $FF
         fcb   $FF
         fcb   $00
         fcb   $00
         fcb   $01
         fcb   $00
M0600    fcb   $00
         fcb   $24 $
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00

* Out of memory routine
M0608    ldy   #$004F
         leax  >M0629,pcr
         lda   #$02
         os9   I$Write
         clra
         leax  >M0629,pcr
         ldy   #$0001
         os9   I$Read
         ldu   >M0575,pcr
         jmp   >$3C55,u


M0629    fcb   $0D
         fcb   $0A
         fcc   "OUT OF MEMORY-"
         fcb   $0D
         fcb   $0A
         fcc   "Worksheet not completely loaded"
         fcb   $0D
         fcb   $0A
         fcc   "Press any key to continue."
         fcb   $0D
         fcb   $0A
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00

* Default printer name (60 bytes)
M0680    fcc   "/P "
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
M06C0    fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

M0700    fcb   $05
         fcb   $21 !
         fcb   $FF
         fcc   "VERSION 01.00.00"
         fcb   $FF
         fcc   " CORPORATION"
         fcb   $FF
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   $06
         fcb   $FF
         fcb   $00
         fcb   $FD
         fcb   $81
         fcb   $00
         fcb   $06
         fcb   $FF
         fcb   $00
         fcb   $D1 Q
         fcb   $44 D
         fcb   $D7 W
         fcb   $3C <
         fcb   $F2 r
         fcb   $F8 x
         fcb   $FF
         fcb   $AA *
         fcb   $00
         fcb   $F8 x
         fcb   $FF
         fcb   $AA *
         fcb   $00
         fcb   $B7 7
         fcb   $00
         fcb   $D6 V
         fcb   $0E
         fcb   $B7 7
         fcb   $00
         fcb   $CE N
         fcb   $C3 C
         fcb   $B8 8
         fcb   $B8 8
         fcb   $00
         fcb   $B8 8
         fcb   $80
         fcb   $B7 7
         fcb   $00
         fcb   $91
         fcb   $00
         fcb   $00
         fcb   $01
         fcb   $CE N
         fcb   $DA Z
         fcb   $D4 T
         fcb   $00
         fcb   $AA *
         fcb   $00
         fcb   $D4 T
         fcb   $00
         fcb   $AA *
         fcb   $00
         fcb   $B7 7
         fcb   $00
         fcb   $D6 V
         fcb   $1C
         fcb   $B7 7
         fcb   $00
         fcb   $CE N
         fcb   $C3 C
         fcb   $98
         fcb   $B8 8
         fcb   $00
         fcb   $B8 8
         fcb   $80
         fcb   $B7 7
         fcb   $00
         fcb   $91
         fcb   $00
         fcb   $01
         fcb   $53 S
         fcb   $CE N
         fcb   $DA Z
         fcb   $CD M
         fcb   $66 f
         fcb   $B7 7
         fcb   $00
         fcb   $B1 1
         fcb   $00
         fcb   $63 c
         fcb   $00
         fcb   $01
         fcb   $00
         fcb   $B0 0
         fcb   $00
         fcb   $C5 E
         fcb   $7C ü
         fcb   $01
         fcb   $00
         fcb   $B8 8
         fcb   $80
         fcb   $C5 E
         fcb   $2C ,
         fcb   $01
         fcb   $00
         fcb   $63 c
         fcb   $00
         fcb   $29 )
         fcb   $00
         fcb   $C5 E
         fcb   $8A
         fcb   $C5 E
         fcb   $76 v
         fcb   $BE >
         fcb   $BE >
         fcb   $EF o
         fcb   $E6 f
         fcb   $B8 8
         fcb   $80
         fcb   $64 d
         fcb   $05
         fcb   $F2 r
         fcb   $E7 g
         fcb   $64 d
         fcb   $05
         fcb   $F2 r
         fcb   $AA *
         fcb   $90
         fcb   $03
         fcb   $3F ?
         fcb   $5B [
         fcb   $5A Z
         fcb   $00
         fcb   $32 2
         fcb   $00
         fcb   $8D
         fcb   $3D =
         fcb   $8C
         fcb   $E6 f
         fcb   $66 f
         fcb   $91

M0A13    nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop

M0A28    lbra  M0A4D
* Entry point for start routine in dynacalc program
* X contains the program counter a few instructions before the jump.
M0A2B    lbra  M0A44

         pshs  x,a
         tfr   pc,x
         leax  >-$5C32,x
         stx   >M0575,pcr
         lda   #$FF
         sta   >$0143,u
         puls  x,a
         bra   L0A97

M0A44    cmpd  #$0485   version number test
         beq M0A8D
M0A4D    lda   #$02
         leax  >M0A5B,pcr
         ldy   #$FFFF
         os9   I$WritLn
         clrb
         os9   F$Exit

M0A5B    fcc   "DYNACALC and DYNACALC.TRM are different versions."
         fcb   $0D

M0A8D    leax  >-$0B44,x
         stx   >M0575,pcr
         puls  u,y,x,b,a
L0A97         std   >$01C1,u
         tfr   dp,a
         inca  
         tfr   a,dp
         stx   <$41    PARAMS
         stu   <$1A  MEMPTR   beginning of data
         leax  >$0280,u
         stx   <$00E9
         ldx   #$0700
         stx   <$0044
         clr   <$00ED
         clr   <$00EE
         clr   <$0019
         clr   <$00A7
         clr   >M06C0,pcr
         ldu   <$001A
         leax  >$0A13,u
         stx   <$0017
         tfr   x,s
         leax  >$0331,u
         stx   <$0030
         leax  <$2F,x
         clra
         clrb    Code 0 - SS.Opt
         os9   I$GetStt
         lda   #$01
         ldb   #$26   SS.ScSiz  Return screen size for COCO (level 2)
         os9   I$GetStt
         tfr   x,d
         decb  
         stb   <$000E
         tfr   y,d
         stb   <$000D
         leax  >M0600,pcr
         clra  
         clrb  
         std   -$02,x
         sta   -$04,x
         coma  
         comb  
         std   -$06,x
         leax  >M0680,pcr
         lda   #$02
         os9   I$Open
         bcc   M0B0F
         leax  >M0680,pcr
         lda   #$02
         ldb   #%00011011 File permissions for new file
         os9   I$Create
         bcc   M0B0F
         clr   >M0680,pcr
         bra   M0B44

M0B0F    sta   <$0012
         ldx   <$0030
         clrb  

         os9   I$GetStt
         bcs   M0B39
         ldx   <$0030
         clrb  
         lda   ,x
         beq   M0B33
         deca  
         bne   M0B39
         lda   <$0012
         ldb   #$02
         os9   I$GetStt 
         bcs   M0B39
         os9   I$Seek   
         bcs   M0B39
         ldb   #$FF
M0B33    stb   <$0013
         bne   M0B44
         bra   M0B3D

M0B39    clr   >M0680,pcr
M0B3D    lda   <$0012   data file path number
         os9   I$Close
         clr   <$0012   data file path number
M0B44    ldx   <$0030
         os9   F$Time

* Seed the random number generator
         leay  $06,x
         leau  >M057B,pcr
         ldb   #$04
         lda   -$01,y
         eora  #$5A
M0B55    rola  
         eora  ,-y
         sta   ,-u
         decb  
         bne   M0B55
         leay  >M0562,pcr
         lda   $01,x
         deca  
         cmpa  #$0B
         bls   M0B69
         clra  

M0B69    ldb   #$09
         mul   
         leau  >MONTHS,pcr
         leau  d,u
         ldb   #$09
M0B74    lda   ,u+
         sta   ,y+
         decb  
         bne   M0B74
         lda   #$20
         sta   ,y+
         ldb   $02,x
         bsr   M0B97
         ldd   #$2C20
         std   ,y++
         ldd   #$3139

         std   ,y++
         ldx   <$0030
         ldb   ,x
         bsr   M0B97
         clr   ,y
         bra   M0BB3
M0B97    clra  
         ldu   #$0700
         stu   <$0044
         ldu   >M0575,pcr
         jsr   >$4928,u
         ldu   #$0700
         stu   <$0044

         ldd   <$001A
         leau  d,u
         ldd   $03,u
         std   ,y++
         rts   
M0BB3    ldy   >M0575,pcr
         jsr   >$1096,y
         ldb   $01,x
         bne   M0BC4
         ldb   >M00F8,pcr
M0BC4    stb   >M00FA,pcr
         clr   $0C,x

         clr   $0F,x
         clr   <$10,x
         clr   <$11,x
         clr   <$16,x
         clr   $04,x
         clr   $07,x
         jsr   >$10A1,y
         ldu   #$01F1
         stu   <$00EB
         clr   <$00E0
         clr   <$00E8
         clr   <$00C4
         tst   >M00F7,pcr
         bne   M0BF4
         lda   #$04
         sta   >M00F7,pcr
M0BF4    lda   #$90
         ldy   >M0575,pcr
         jsr   >$1048,y
         lda   #$FF
         sta   <$00F0
         jsr   >$0FC6,y
         leau  >BANNER,pcr
         ldd   <$000D
         subd  #$101F
         lsra  
         lsrb  
         pshs  b,a
M0C14    ldd   ,u++
         beq   M0C26
         addd  ,s
         tfr   d,x
         jsr   >$0FDF,y
         jsr   >$1C94,y
         bra   M0C14

M0C26    leas  $02,s
         ldd   <$00C1
         cmpd  #$0001
         bls   M0C77
         ldy   <$0041
         lda   ,y
         cmpa  #$2D    minus
         beq   M0C67
         ldb   #$11
         ldx   <$00E9
M0C3D    lda   ,y+
         cmpa  #$20
         beq   M0C5F
         cmpa  #$0D
         beq   M0C50
         incb  
         stb   <$00ED
         sta   b,x
         cmpb  #$2F
         bne   M0C3D
M0C50    tst   <$00ED
         beq   M0C77
         leau  >M0E14,pcr
         ldy   >M0575,pcr
         bra   M0C91

M0C5F    lda   ,y+
         cmpa  #$20
         beq   M0C5F
         leay  -$01,y
M0C67    ldb   $01,y
         andb  #$5F
         cmpd  #$2D48  -H  deletes builtin help messages
         bne   M0C50
         sta   >M00FB,pcr
         bra   M0C50

M0C77    ldy   >M0575,pcr
         ldb   #$04
         stb   <$0025
M0C80    jsr   >$1CA0,y
         bne   M0C8A
         dec   <$0025
         bne   M0C80
M0C8A    tst   <$0043
         beq   M0C91
         lbsr  $3200
M0C91    ldb   #$08
         leax  >M0100,pcr
         leau  >M0D01,pcr
         ldy   <$001A
M0C9E    lda   ,x+
         pshs  x,b,a
         ldd   ,u++
         leax  d,y
         lda   ,s
         sta   ,x
         ldd   ,u++
         leax  d,y
         puls  a
         sta   ,x
         puls  x,b
         decb  
         bne   M0C9E
         ldx   >M0575,pcr
         leay  >$0F00,y
         ldd   $06,y
         sta   <$001D
         clr   <$007D
         lsra  
         rorb  
         ror   <$007D
         std   <$006C
         ldd   $06,y
         leau  d,y
         ldx   <$0041
         leax  $01,x
         pshs  x
         ldx   <$001A
         tst   >$00FB,x
         puls  x
         bne   M0CEC
         leax  -$02,x
         clr   <$001D  Clear helps flag
         ldy   >M0575,pcr
         jsr   >$3C6A,y
M0CEC    nop   
         tfr   x,d
         std   <$001E
         subd  <$0017
         lsra  
         rorb  
         addd  <$0017
         std   <$0023
         ldu   >M0575,pcr
         jmp   >$50B2,u


M0D01    fdb   $0381  Up-arrow
         fcb   $03
         fcb   $AC ,
         fcb   $03
         fcb   $82
         fcb   $03
         fcb   $AD -
         fcb   $03
         fcb   $83
         fcb   $03
         fcb   $AE .
         fcb   $03
         fcb   $84
         fcb   $03
         fcb   $AF /
         fcb   $03
         fcb   $AA *
         fcb   $03
         fcb   $AA *
         fcb   $03
         fcb   $A7 '
         fcb   $03
         fcb   $A7 '
         fdb   $0380
         fdb   $0380
         fdb   $0380
         fdb   $0380

MONTHS   fcc   "  January"
         fcc   " February"
         fcc   "    March"
         fcc   "    April"
         fcc   "      May"
         fcc   "     June"
         fcc   "     July"
         fcc   "   August"
         fcc   "September"
         fcc   "  October"
         fcc   " November"
         fcc   " December"

BANNER   fcb   $03
         fcb   $07
         fcc   "**** DYNACALC ****"
         fcb   $00
         fcb   $05
         fcb   $09
         fcc   "Copyright 1984"
         fcb   $00
         fcb   $06
         fcb   $06
         fcc   "By Scott Schaeferle"
         fcb   $00
         fcb   $08
         fcb   $06
         fcc   "All Rights Reserved"
         fcb   $00
         fcb   $0A
         fcb   $01
         fcc   "Licensed to Tandy Corporation"
         fcb   $00
         fcb   $0C
         fcb   $07
         fcc   "Version 01.00.00"
         fcb   $00
         fcb   $00
         fcb   $00
M0E14    fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
         fcb   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

M0F00    lbra  M0F79
         lbra  M0F0D
         fdb   ENDHELP-M0F00   $1E4D
         fdb   ENDHELP-M0F00+$6100      $6100+$1e4d
         lbra  M104E

M0F0D    ldu   <$001A
         ldy   >$0575,u
         leau  >M0F5C,pcr
         jsr   >$1C94,y
         jsr   >$0ACF,y
         cmpa  #$59
         beq   M0F28
         jmp   >$1C79,y

* Delete helps
M0F28    ldu   <$001E



         fcb   $9E
         fcb   $41 A
         fcb   $30 0
         fcb   $01
         fcb   $9F
         fcb   $1E
         fcb   $34 4
         fcb   $50 P
         fcb   $03
         fcb   $1D
         fcb   $DC \
         fcb   $41 A
         fcb   $93
         fcb   $17
         fcb   $44 D
         fcb   $56 V
         fcb   $D3 S
         fcb   $17
         fcb   $AD -
         fcb   $A9 )
         fcb   $50 P
         fcb   $B5 5
         fcb   $1F
         fcb   $30 0
         fcb   $93
         fcb   $C5 E
         fcb   $DD ]
         fcb   $6C l
         fcb   $DC \
         fcb   $1E
         fcb   $93
         fcb   $6C l
         fcb   $DD ]
         fcb   $C5 E
         fcb   $DC \
         fcb   $6C l
         fcb   $0F
         fcb   $7D ý
         fcb   $44 D
         fcb   $56 V
         fcb   $06
         fcb   $7D ý
         fcb   $DD ]
         fcb   $6C l
         fcb   $35 5
         fcb   $50 P
         fcb   $6E n
         fcb   $A9 )
         fcb   $3C <
         fcb   $61 a

M0F5C    fcc   "Delete helps: Are you sure? "
         fcb   $00

M0F79    fcb   $34 4
         fcb   $20
         fcb   $10
         fcb   $9E
         fcb   $1A
         fcb   $10
         fcb   $AE .
         fcb   $A9 )
         fcb   $05
         fcb   $75 u
         fcb   $E6 f
         fcb   $84
         fcb   $C1 A
         fcb   $88
         fcb   $26 &
         fcb   $08
         fcb   $0D
         fcb   $E1 a
         fcb   $27 '
         fcb   $04
         fcb   $C6 F
         fcb   $9A
         fcb   $0F
         fcb   $E1 a
         fcb   $D7 W
         fcb   $25 %
         fcb   $DE ^
         fcb   $B1 1
         fcb   $96
         fcb   $B3 3
         fcb   $D6 V
         fcb   $75 u
         fcb   $34 4
         fcb   $46 F
         fcb   $17
         fcb   $00
         fcb   $AC ,
         fcb   $86
         fcb   $0A
         fcb   $AD -
         fcb   $A9 )
         fcb   $0B
         fcb   $05
         fcb   $30 0
         fcb   $8D
         fcb   $1D
         fcb   $01
         fcb   $D6 V
         fcb   $25 %
         fcb   $3A :
         fcb   $EC l
         fcb   $84
         fcb   $33 3
         fcb   $8D
         fcb   $00
         fcb   $C8 H
         fcb   $33 3
         fcb   $CB K
         fcb   $A6 &
         fcb   $C0 @
         fcb   $27 '
         fcb   $37 7
         fcb   $81
         fcb   $11
         fcb   $26 &
         fcb   $27 '
         fcb   $AD -
         fcb   $A9 )
         fcb   $1C
         fcb   $E5 e
         fcb   $AD -
         fcb   $A9 )
         fcb   $3C <
         fcb   $5E ^
         fcb   $AD -
         fcb   $A9 )
         fcb   $0A
         fcb   $E1 a
         fcb   $E6 f
         fcb   $1F
         fcb   $5C \
         fcb   $A6 &
         fcb   $85
         fcb   $34 4
         fcb   $02
         fcb   $6F o
         fcb   $85
         fcb   $AD -
         fcb   $A9 )
         fcb   $0A
         fcb   $CF O
         fcb   $35 5
         fcb   $02
         fcb   $81
         fcb   $1B
         fcb   $27 '
         fcb   $4B K
         fcb   $34 4
         fcb   $40 @
         fcb   $8D
         fcb   $6C l
         fcb   $35 5
         fcb   $40 @
         fcb   $20
         fcb   $08
         fcb   $AD -
         fcb   $A9 )
         fcb   $0B
         fcb   $05
         fcb   $81
         fcb   $0D
         fcb   $26 &
         fcb   $C9 I
         fcb   $86
         fcb   $0A
         fcb   $20
         fcb   $F4 t
         fcb   $AD -
         fcb   $A9 )
         fcb   $1C
         fcb   $E5 e
         fcb   $AD -
         fcb   $A9 )
         fcb   $3C <
         fcb   $5E ^
         fcb   $AD -
         fcb   $A9 )
         fcb   $0A
         fcb   $E1 a
         fcb   $96
         fcb   $25 %
         fcb   $81
         fcb   $80
         fcb   $26 &
         fcb   $25 %
         fcb   $E6 f
         fcb   $1F
         fcb   $5C \
         fcb   $A6 &
         fcb   $85
         fcb   $81
         fcb   $40 @
         fcb   $26 &
         fcb   $04
         fcb   $C6 F
         fcb   $9C
         fcb   $20
         fcb   $06
         fcb   $81
         fcb   $3E >
         fcb   $26 &
         fcb   $0A
         fcb   $C6 F
         fcb   $9E
         fcb   $D7 W
         fcb   $25 %
         fcb   $AD -
         fcb   $A9 )
         fcb   $0A
         fcb   $CF O
         fcb   $20
         fcb   $80
         fcb   $84
         fcb   $5F _
         fcb   $81
         fcb   $47 G
         fcb   $26 &
         fcb   $04
         fcb   $C6 F
         fcb   $84
         fcb   $20
         fcb   $EE n
         fcb   $8D
         fcb   $23 #
         fcb   $0F
         fcb   $AC ,
         fcb   $AD -
         fcb   $A9 )
         fcb   $1C
         fcb   $AC ,
         fcb   $10
         fcb   $9E
         fcb   $1A
         fcb   $10
         fcb   $AE .
         fcb   $A9 )
         fcb   $05
         fcb   $75 u
         fcb   $8E
         fcb   $02
         fcb   $00
         fcb   $AD -
         fcb   $A9 )
         fcb   $0A
         fcb   $99
         fcb   $AD -
         fcb   $A9 )
         fcb   $3C <
         fcb   $5E ^
         fcb   $35 5
         fcb   $46 F
         fcb   $97
         fcb   $B3 3
         fcb   $DF _
         fcb   $B1 1
         fcb   $D7 W
         fcb   $75 u
         fcb   $35 5
         fcb   $A0
         fcb   $6E n
         fcb   $A9 )
         fcb   $0A
         fcb   $FC

M104E    ldu   <$001A
         ldy   >$0575,u
         ldd   #$2C20
         jsr   >$1C7C,y
         ldb   <$0025
         leax  >ERRTBL,pcr
         subb  #$C8
         cmpb  #$35
         bls   M106A
         ldb   #$36
M106A    lslb  
         abx   
         ldd   ,x
         leau  >ERRMSGS,pcr
         leau  d,u
         jsr   >$4132,y
         rts   


 use help32.inc
Target set $3200
 use filler.inc

