*
* DYNACALC for the TRS-80 Color computer uses the 32x16 display.
*
 ifp1
 use defsfile
DYNAVERS equ 485
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
         fcb   $01
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
         fcb   $20
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
M0A2B    lbra  M0A21

         pshs  x,a
         tfr   pc,x
         leax  >-$5C32,x
         stx   >M0575,pcr
         lda   #$FF
         sta   >$0143,u
         puls  x,a
         bra   L0A97

M0A21    cmpd  #$0485   version number test
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
M0B33         stb   <$0013
         bne   M0B44
         bra   M0B3D

M0B39    clr   >M0680,pcr
M0B3D    lda   <$0012   data file path number
         os9   I$Close
         clr   <$0012   data file path number
M0B44    ldx   <$0030
         os9   F$Time
         fcb   $31 1
         fcb   $06
         fcb   $33 3
         fcb   $8D
         fcb   $FA z
         fcb   $2C ,
         fcb   $C6 F
         fcb   $04
         fcb   $A6 &
         fcb   $3F ?
         fcb   $88
         fcb   $5A Z
         fcb   $49 I
         fcb   $A8 (
         fcb   $A2 "
         fcb   $A7 '
         fcb   $C2 B
         fcb   $5A Z
         fcb   $26 &
         fcb   $F8 x
         fcb   $31 1
         fcb   $8D
         fcb   $FA z
         fcb   $01
         fcb   $A6 &
         fcb   $01
         fcb   $4A J
         fcb   $81
         fcb   $0B
         fcb   $23 #
         fcb   $01
         fcb   $4F O
         fcb   $C6 F
         fcb   $09
         fcb   $3D =
         fcb   $33 3
         fcb   $8D
         fcb   $01
         fcb   $B1 1
         fcb   $33 3
         fcb   $CB K
         fcb   $C6 F
         fcb   $09
         fcb   $A6 &
         fcb   $C0 @
         fcb   $A7 '
         fcb   $A0
         fcb   $5A Z
         fcb   $26 &
         fcb   $F9 y
         fcb   $86
         fcb   $20
         fcb   $A7 '
         fcb   $A0
         fcb   $E6 f
         fcb   $02
         fcb   $8D
         fcb   $14
         fcb   $CC L
         fcb   $2C ,
         fcb   $20
         fcb   $ED m
         fcb   $A1 !
         fcb   $CC L
         fcb   $31 1
         fcb   $39 9
         fcb   $ED m
         fcb   $A1 !
         fcb   $9E
         fcb   $30 0
         fcb   $E6 f
         fcb   $84
         fcb   $8D
         fcb   $04
         fcb   $6F o
         fcb   $A4 $
         fcb   $20
         fcb   $1C
         fcb   $4F O
         fcb   $CE N
         fcb   $07
         fcb   $00
         fcb   $DF _
         fcb   $44 D
         fcb   $EE n
         fcb   $8D
         fcb   $F9 y
         fcb   $D4 T
         fcb   $AD -
         fcb   $C9 I
         fcb   $49 I
         fcb   $28 (
         fcb   $CE N
         fcb   $07
         fcb   $00
         fcb   $DF _
         fcb   $44 D
         fcb   $DC \
         fcb   $1A
         fcb   $33 3
         fcb   $CB K
         fcb   $EC l
         fcb   $43 C
         fcb   $ED m
         fcb   $A1 !
         fcb   $39 9
         fcb   $10
         fcb   $AE .
         fcb   $8D
         fcb   $F9 y
         fcb   $BD =
         fcb   $AD -
         fcb   $A9 )
         fcb   $10
         fcb   $96
         fcb   $E6 f
         fcb   $01
         fcb   $26 &
         fcb   $04
         fcb   $E6 f
         fcb   $8D
         fcb   $F5 u
         fcb   $34 4
         fcb   $E7 g
         fcb   $8D
         fcb   $F5 u
         fcb   $32 2
         fcb   $6F o
         fcb   $0C
         fcb   $6F o
         fcb   $0F
         fcb   $6F o
         fcb   $88
         fcb   $10
         fcb   $6F o
         fcb   $88
         fcb   $11
         fcb   $6F o
         fcb   $88
         fcb   $16
         fcb   $6F o
         fcb   $04
         fcb   $6F o
         fcb   $07
         fcb   $AD -
         fcb   $A9 )
         fcb   $10
         fcb   $A1 !
         fcb   $CE N
         fcb   $01
         fcb   $F1 q
         fcb   $DF _
         fcb   $EB k
         fcb   $0F
         fcb   $E0 `
         fcb   $0F
         fcb   $E8 h
         fcb   $0F
         fcb   $C4 D
         fcb   $6D m
         fcb   $8D
         fcb   $F5 u
         fcb   $0B
         fcb   $26 &
         fcb   $06
         fcb   $86
         fcb   $04
         fcb   $A7 '
         fcb   $8D
         fcb   $F5 u
         fcb   $03
         fcb   $86
         fcb   $90
         fcb   $10
         fcb   $AE .
         fcb   $8D
         fcb   $F9 y
         fcb   $7A z
         fcb   $AD -
         fcb   $A9 )
         fcb   $10
         fcb   $48 H
         fcb   $86
         fcb   $FF
         fcb   $97
         fcb   $F0 p
         fcb   $AD -
         fcb   $A9 )
         fcb   $0F
         fcb   $C6 F
         fcb   $33 3
         fcb   $8D
         fcb   $01
         fcb   $82
         fcb   $DC \
         fcb   $0D
         fcb   $83
         fcb   $10
         fcb   $1F
         fcb   $44 D
         fcb   $54 T
         fcb   $34 4
         fcb   $06
         fcb   $EC l
         fcb   $C1 A
         fcb   $27 '
         fcb   $0E
         fcb   $E3 c
         fcb   $E4 d
         fcb   $1F
         fcb   $01
         fcb   $AD -
         fcb   $A9 )
         fcb   $0F
         fcb   $DF _
         fcb   $AD -
         fcb   $A9 )
         fcb   $1C
         fcb   $94
         fcb   $20
         fcb   $EE n
         fcb   $32 2
         fcb   $62 b
         fcb   $DC \
         fcb   $C1 A
         fcb   $10
         fcb   $83
         fcb   $00
         fcb   $01
         fcb   $23 #
         fcb   $47 G
         fcb   $10
         fcb   $9E
         fcb   $41 A
         fcb   $A6 &
         fcb   $A4 $
         fcb   $81
         fcb   $2D -
         fcb   $27 '
         fcb   $2E .
         fcb   $C6 F
         fcb   $11
         fcb   $9E
         fcb   $E9 i
         fcb   $A6 &
         fcb   $A0
         fcb   $81
         fcb   $20
         fcb   $27 '
         fcb   $1C
         fcb   $81
         fcb   $0D
         fcb   $27 '
         fcb   $09
         fcb   $5C \
         fcb   $D7 W
         fcb   $ED m
         fcb   $A7 '
         fcb   $85
         fcb   $C1 A
         fcb   $2F /
         fcb   $26 &
         fcb   $ED m
         fcb   $0D
         fcb   $ED m
         fcb   $27 '
         fcb   $23 #
         fcb   $33 3
         fcb   $8D
         fcb   $01
         fcb   $BC <
         fcb   $10
         fcb   $AE .
         fcb   $8D
         fcb   $F9 y
         fcb   $18
         fcb   $20
         fcb   $32 2
         fcb   $A6 &
         fcb   $A0
         fcb   $81
         fcb   $20
         fcb   $27 '
         fcb   $FA z
         fcb   $31 1
         fcb   $3F ?
         fcb   $E6 f
         fcb   $21 !
         fcb   $C4 D
         fcb   $5F _
         fcb   $10
         fcb   $83
         fcb   $2D -
         fcb   $48 H
         fcb   $26 &
         fcb   $DF _
         fcb   $A7 '
         fcb   $8D
         fcb   $F4 t
         fcb   $86
         fcb   $20
         fcb   $D9 Y
         fcb   $10
         fcb   $AE .
         fcb   $8D
         fcb   $F8 x
         fcb   $F9 y
         fcb   $C6 F
         fcb   $04
         fcb   $D7 W
         fcb   $25 %
         fcb   $AD -
         fcb   $A9 )
         fcb   $1C
         fcb   $A0
         fcb   $26 &
         fcb   $04
         fcb   $0A
         fcb   $25 %
         fcb   $26 &
         fcb   $F6 v
         fcb   $0D
         fcb   $43 C
         fcb   $27 '
         fcb   $03
         fcb   $17
         fcb   $25 %
         fcb   $6F o
         fcb   $C6 F
         fcb   $08
         fcb   $30 0
         fcb   $8D
         fcb   $F4 t
         fcb   $69 i
         fcb   $33 3
         fcb   $8D
         fcb   $00
         fcb   $66 f
         fcb   $10
         fcb   $9E
         fcb   $1A
         fcb   $A6 &
         fcb   $80
         fcb   $34 4
         fcb   $16
         fcb   $EC l
         fcb   $C1 A
         fcb   $30 0
         fcb   $AB +
         fcb   $A6 &
         fcb   $E4 d
         fcb   $A7 '
         fcb   $84
         fcb   $EC l
         fcb   $C1 A
         fcb   $30 0
         fcb   $AB +
         fcb   $35 5
         fcb   $02
         fcb   $A7 '
         fcb   $84
         fcb   $35 5
         fcb   $14
         fcb   $5A Z
         fcb   $26 &
         fcb   $E7 g
         fcb   $AE .
         fcb   $8D
         fcb   $F8 x
         fcb   $BA :
         fcb   $31 1
         fcb   $A9 )
         fcb   $0F
         fcb   $00
         fcb   $EC l
         fcb   $26 &
         fcb   $97
         fcb   $1D
         fcb   $0F
         fcb   $7D ý
         fcb   $44 D
         fcb   $56 V
         fcb   $06
         fcb   $7D ý
         fcb   $DD ]
         fcb   $6C l
         fcb   $EC l
         fcb   $26 &
         fcb   $33 3
         fcb   $AB +
         fcb   $9E
         fcb   $41 A
         fcb   $30 0
         fcb   $01
         fcb   $34 4
         fcb   $10
         fcb   $9E
         fcb   $1A
         fcb   $6D m
         fcb   $89
         fcb   $00
         fcb   $FB
         fcb   $35 5
         fcb   $10
         fcb   $26 &
         fcb   $0D
         fcb   $30 0
         fcb   $1E
         fcb   $0F
         fcb   $1D
         fcb   $10
         fcb   $AE .
         fcb   $8D
         fcb   $F8 x
         fcb   $8D
         fcb   $AD -
         fcb   $A9 )
         fcb   $3C <
         fcb   $6A j
         fcb   $12
         fcb   $1F
         fcb   $10
         fcb   $DD ]
         fcb   $1E
         fcb   $93
         fcb   $17
         fcb   $44 D
         fcb   $56 V
         fcb   $D3 S
         fcb   $17
         fcb   $DD ]
         fcb   $23 #
         fcb   $EE n
         fcb   $8D
         fcb   $F8 x
         fcb   $78 x
         fcb   $6E n
         fcb   $C9 I
         fcb   $50 P
         fcb   $B2 2

         fdb   $0381  Up-arrow
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
         fcb   $16
         fcb   $01
         fcb   $41 A

M0F0D    ldu   <$1A
         fcb   $10
         fcb   $AE .
         fcb   $C9 I
         fcb   $05
         fcb   $75 u
         fcb   $33 3
         fcb   $8D
         fcb   $00
         fcb   $44 D
         fcb   $AD -
         fcb   $A9 )
         fcb   $1C
         fcb   $94
         fcb   $AD -
         fcb   $A9 )
         fcb   $0A
         fcb   $CF O
         fcb   $81
         fcb   $59 Y
         fcb   $27 '
         fcb   $04
         fcb   $6E n
         fcb   $A9 )
         fcb   $1C
         fcb   $79 y
         fcb   $DE ^
         fcb   $1E
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
         fcb   $DE ^
         fcb   $1A
         fcb   $10
         fcb   $AE .
         fcb   $C9 I
         fcb   $05
         fcb   $75 u
         fcb   $CC L
         fcb   $2C ,
         fcb   $20
         fcb   $AD -
         fcb   $A9 )
         fcb   $1C
         fcb   $7C ü
         fcb   $D6 V
         fcb   $25 %
         fcb   $30 0
         fcb   $8D
         fcb   $1C
         fcb   $59 Y
         fcb   $C0 @
         fcb   $C8 H
         fcb   $C1 A
         fcb   $35 5
         fcb   $23 #
         fcb   $02
         fcb   $C6 F
         fcb   $36 6
         fcb   $58 X
         fcb   $3A :
         fcb   $EC l
         fcb   $84
         fcb   $33 3
         fcb   $8D
         fcb   $19
         fcb   $12
         fcb   $33 3
         fcb   $CB K
         fcb   $AD -
         fcb   $A9 )
         fcb   $41 A
         fcb   $32 2
         rts

 use help32.inc
Target set $3200
 use filler.inc

