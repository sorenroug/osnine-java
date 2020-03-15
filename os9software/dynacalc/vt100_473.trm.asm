 ifp1
 use defsfile
 use dynacalc_473.inc
 endc
 opt m
 org 0
         fcb   $59,$A6,$59,$00,$00,$00,$00,$00,$87,$41,$0D,$09,$40,$01,$04,$09
         fcc   "DYNACALC, Version 4.7:3              "
         fcc   "Copyright (C) 1982,1983 by Scott Schaeferle."
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
M0080    fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
M0088    fcb   $FF,$FF,$FF,$FF    Cursor on
M008C    fcb   $FF,$FF,$FF,$FF    Cursor off
M0090    fcb   $FF,$FF,$FF,$FF,$FF,$00,$00,$00   Terminal setup
         fcb   $00,$00,$00,$00,$00,$00,$00,$00
M00A0    fcb   $FF,$FF,$00,$00,$00,$00,$00,$00   Terminal kiss-off
M00A8    fcb   $FF,$FF,$00,$00    Cursor right
         fcb   $FF,$FF,$00,$00    Cursor ??
CURSPOS  fcb   $FF,$FF,$FF,$FF    Cyrsor XY
         fcb   $FF,$00,$00,$00
M00B8    fcb   $1B,'[,'K,$FF,$00,$00    Cursor clear to EOL
M00BE    fcb   $1B,'[,'J,$FF,$00,$00    Cursor clear to end of screen
REVON    fcb   $1B,'[,'7,'m    Reverse on
         fcb   $FF,$00,$00,$00
REVOFF   fcb   $1B,'[,'0,'m    Reverse off
M00D0    fcb   $FF,$00,$00,$00
M00D4    fcb   $08,$20,$08,$FF,$00,$00  Destructive backspace
M00DA    fcb   $08,$FF,$00,$00   non-destructive backspace
M00DE    fcc   "                "  Terminal name (16 chars)
M00EE    fcb   $00
         fcb   $00
M00F0    fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
M00F7    fcb   $04  Log-off key
M00F8    fcb   $00  Upper case only
         fcb   $00  line feeds after each line
M00FA    fcb   $00
M00FB    fcb   $00  keep helps  T/F
         fcb   $FF  print borders  T/F
         fcb   79  printer page width
         fcb   $00  Pagination  T/F
M00FF    fcb   57  Lines per page
M0100    fcb   '{     Up-arrow
DOWNKEY  fcb   '}     Down-arrow
         fcb   '[     Left-arrow
         fcb   ']     Right-arrow
         fcb   $1C     Home key    (Ctrl-\)
         fcb   $19     Jump window (Ctrl-Y)
M0106    fcb   $07   Bell character
GETADDR  fcb   $1A   Get address (Ctrl-Z)
         fcb   $03   Flush type-ahead buffer (Ctrl-C)
         fcb   $08   Backspace key
         fcb   $00   direct cursor addressing row offset
         fcb   $00   direct cursor addressing columns offset
M010C    fcb   $02
         fcb   24   number of rows on screen
         fcb   79  number of columns on screen
         fcb   $0F  Edit overlay (Ctrl-O)
M0110    fcb   $03
         fcb   $05  Edit from entry level (Ctrl-E)
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $61 a
         fcb   $F0 p
         fcb   $00
         fdb   $5800    MEMPTR
         fcb   $FF
         fcb   $FF
         fcb   $FF
         fcb   $FF
M0120    fcb   $FF
         fcb   $04
         fcb   $FF
         fcb   $04
         fcb   $FF
         fcb   $04
         fcb   $FF
         fcb   $04
         fcb   $FF
         fcb   $04
         fcb   $FF
         fcb   $00
         fcb   $01
         fcb   $22 "
         fcb   $67 g
         fcb   $36 6
M0130    fcb   $5B [
         fcb   $31 1
         fcb   $67 g
         fcb   $36 6
         fcb   $FA z
         fcb   $55 U
         fcb   $01
         fcb   $22 "
         fcb   $67 g
         fcb   $40 @
         fcb   $FA z
         fcb   $70 p
         fcb   $67 g
         fcb   $40 @
         fcb   $FA z
         fcb   $55 U
M0140    fcb   $D4 T
         fcb   $94     PARAMS
         fcb   $FF
         fcb   $00
         fcb   $07
         fcb   $00
         fcb   $67 g
         fcb   $4E N
         fcb   $FA z
         fcb   $70 p
         fcb   $67 g
         fcb   $4E N
         fcb   $FA z
         fcb   $55 U
         fcb   $D4 T
         fcb   $00
M0150    fcb   $00
         fcb   $00
         fcb   $DF _
         fcb   $C0 @
         fcb   $00
         fcb   $43 C
         fcb   $67 g
         fcb   $63 c
         fcb   $F2 r
         fcb   $B3 3
         fcb   $03
         fcb   $DF _
         fcb   $C0 @
         fcb   $FA z
         fcb   $24 $
         fcb   $67 g
         fcb   $63 c
         fcb   $FA z
         fcb   $55 U
         fcb   $94
         fcb   $03
         fcb   $01
         fcb   $00
         fcb   $E3 c
         fcb   $00
         fcb   $B9 9
         fcb   $3A :
         fcb   $B7 7
         fcb   $09
         fcb   $02
         fcb   $FC
         fcb   $BF ?
         fcb   $1C
         fcb   $0A
         fcb   $B9 9
         fcb   $3A :
         fcb   $F9 y
         fcb   $A5 %
         fcb   $84
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $01
         fcb   $22 "
         fcb   $67 g
         fcb   $88
         fcb   $FA z
         fcb   $A0
         fcb   $FA z
         fcb   $70 p
         fcb   $67 g
         fcb   $88
         fcb   $FA z
         fcb   $55 U
         fcb   $D0 P
         fcb   $67 g
         fcb   $E2 b
         fcb   $00
         fcb   $00
         fcb   $63 c
         fcb   $DF _
         fcb   $C0 @
         fcb   $67 g
         fcb   $A6 &
         fcb   $F3 s
         fcb   $3D =
         fcb   $D0 P
         fcb   $67 g
         fcb   $E2 b
         fcb   $00
         fcb   $00
         fcb   $62 b
         fcb   $DF _
         fcb   $C0 @
         fcb   $67 g
         fcb   $A6 &
         fcb   $F3 s
         fcb   $3D =
         fcb   $FA z
         fcb   $70 p
         fcb   $67 g
         fcb   $A6 &
         fcb   $FA z
         fcb   $55 U
         fcb   $84
         fcb   $00
         fcb   $64 d
         fcb   $00
         fcb   $00
         fcb   $63 c
         fcb   $E3 c
         fcb   $00
         fcb   $B7 7
         fcb   $EA j
         fcb   $CF O
         fcb   $2A *
         fcb   $CE N
         fcb   $D7 W
         fcb   $CD M
         fcb   $3E >
         fcb   $CB K
         fcb   $DB [
         fcb   $B7 7
         fcb   $23 #
         fcb   $A1 !
         fcb   $12
         fcb   $00
         fcb   $0F
         fcb   $06
         fcb   $80
         fcb   $80
         fcb   $00
         fcb   $01
         fcb   $01
         fcb   $00
         fcb   $00
         fcb   $81
         fcb   $84
         fcb   $84
         fcb   $03
         fcb   $0D
         fcb   $01
         fcb   $07
         fcb   $00
         fcb   $A1 !
         fcb   $11
         fcb   $0D
         fcb   $5F _
         fcb   $00
         fcb   $1A
         fcb   $12
         fcb   $00
         fcb   $80
         fcb   $01
         fcb   $0D
         fcb   $01
         fcb   $07
         fcb   $00
         fcb   $00
         fcb   $01
         fcb   $07
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $84
         fcb   $00
         fcb   $1E
         fcb   $06
         fcb   $03
         fcb   $60 `
         fcb   $00
         fcb   $5A Z
         fcb   $80
         fcb   $01
         fcb   $F1 q
         fcb   $03
         fcb   $00
         fcb   $12
M01F0    fcb   $FF
         fcb   $30 0
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $53 S
         fcb   $4F O
         fcb   $46 F
         fcb   $54 T
         fcb   $57 W
         fcb   $41 A
         fcb   $52 R

         fcb   $18
         fcb   $30 0
         fcc   "         dollar rate ="

         fcb   $18
         fcb   $30 0
         fcc   "                duty ="

         fcb   $14
         fcb   $32 2
         fcb   $2A *
         fcb   $20
         fcb   $43 C
         fcb   $52 R
         fcb   $41 A
         fcb   $53 S
         fcb   $4D M
         fcb   $42 B
         fcb   $20
         fcb   $77 w
         fcb   $69 i
         fcb   $74 t
         fcb   $68 h
         fcb   $20
         fcb   $36 6
         fcb   $38 8
         fcb   $30 0
         fcb   $39 9

         fcb   $14
         fcb   $32 2
         fcb   $2A *
         fcb   $20
         fcb   $61 a
         fcb   $64 d
         fcb   $64 d
         fcb   $69 i
         fcb   $74 t
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $43 C
         fcb   $50 P
         fcb   $4D M
         fcb   $27 '
         fcb   $73 s

         fcb   $18
         fcb   $32 2
         fcb   $2A *
         fcb   $20
         fcb   $61 a
         fcb   $64 d
         fcb   $64 d
         fcb   $69 i
         fcb   $74 t
         fcb   $20
         fcb   $43 C
         fcb   $50 P
         fcb   $4D M
         fcb   $27 '
         fcb   $73 s
         fcb   $20
         fcb   $77 w
         fcb   $69 i
         fcb   $74 t
         fcb   $68 h
         fcb   $20
         fcb   $73 s
         fcb   $63 c
         fcb   $65 e

         fcb   $17
         fcb   $32 2
         fcb   $36 6
         fcb   $38 8
         fcb   $30 0
         fcb   $30 0
         fcb   $30 0
         fcb   $20
M0280    fcb   $6D m
         fcb   $61 a
         fcb   $63 c
         fcb   $72 r
         fcb   $6F o
         fcb   $20
         fcb   $63 c
         fcb   $72 r
         fcb   $6F o
         fcb   $73 s
         fcb   $73 s
         fcb   $20
         fcb   $61 a
         fcb   $73 s
         fcb   $73 s

         fcb   $0D
         fcb   $32
         fcc   "with source"

         fcb   $0F
         fcb   $32 2
         fcb   $2B +
         fcb   $20
         fcb   $53 S
         fcb   $75 u
         fcb   $70 p
         fcb   $65 e
         fcb   $72 r
         fcb   $53 S
         fcb   $6C l
         fcb   $65 e
         fcb   $75 u
         fcb   $74 t
         fcb   $68 h

         fcb   $13
         fcb   $32
         fcc   "+ Z80 SuperSleuth"

         fcb   $12
         fcb   $32
         fcb   $2B +
         fcb   $20
         fcb   $36 6
         fcb   $38 8
         fcb   $30 0
         fcb   $35 5
         fcb   $20
         fcb   $73 s
         fcb   $69 i
         fcb   $6D m
         fcb   $75 u
         fcb   $6C l
         fcb   $61 a
         fcb   $74 t
         fcb   $6F o
         fcb   $72 r

         fcb   $12
         fcb   $32 2
         fcb   $2B +
         fcb   $20
         fcb   $36 6
         fcb   $35 5
         fcb   $30 0
         fcb   $32 2
         fcb   $20
         fcb   $73 s
         fcb   $69 i
         fcb   $6D m
         fcb   $75 u
         fcb   $6C l
         fcb   $61 a
         fcb   $74 t
         fcb   $6F o
         fcb   $72 r

         fcb   $12
         fcb   $32 2
         fcb   $2A *
         fcb   $20
         fcb   $48 H
         fcb   $44 D
         fcb   $53 S
         fcb   $32 2
         fcb   $30 0
         fcb   $30 0
         fcb   $20
         fcb   $75 u
         fcb   $74 t
         fcb   $69 i
         fcb   $6C l
         fcb   $69 i
         fcb   $74 t
         fcb   $79 y

         fcb   $16
         fcb   $32 2
         fcc   " development package"

         fcb   $16
         fcb   $32 2
         fcb   $2B +
         fcb   $20
         fcb   $36 6
         fcb   $35 5
         fcb   $30 0
         fcb   $32 2
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $36 6
         fcb   $38 8
         fcb   $30 0
         fcb   $39 9
         fcb   $20
         fcb   $74 t
         fcb   $72 r
         fcb   $61 a
         fcb   $6E n
         fcb   $73 s

         fcb   $16
         fcb   $32 2
         fcb   $2B +
         fcb   $20
         fcb   $36 6
         fcb   $38 8
         fcb   $30 0
         fcb   $30 0
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $36 6
         fcb   $38 8
         fcb   $30 0
         fcb   $39 9
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $01
         fcb   $00
         fcb   $00
         fcb   $01
         fcb   $00
         fcb   $01
         fcb   $18
         fcb   $08
         fcb   $18
         fcb   $0D
         fcb   $00
         fcb   $04
         fcb   $01
         fcb   $17
         fcb   $03
         fcb   $05
         fcb   $08
         fcb   $07
         fcb   $15
         fcb   $00
         fcb   $00
         fcb   $35 5
         fcb   $11
         fcb   $13
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $9F
         fcb   $87
         fcb   $00
         fcb   $4F O
         fcb   $20
         fcb   $6A j
         fcb   $6F o
         fcb   $62 b
         fcb   $20
         fcb   $63 c
         fcb   $6F o
         fcb   $6E n
         fcb   $74 t
         fcb   $72 r
         fcb   $6F o
         fcb   $6C l
         fcb   $20
         fcb   $6C l
         fcb   $00
         fcb   $00
         fcb   $01
         fcb   $00
         fcb   $01
         fcb   $01
         fcb   $00
         fcb   $01
         fcb   $18
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
         fcb   $15
         fcb   $00
         fcb   $00
         fcb   $35 5
         fcb   $11
         fcb   $13
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $9F
         fcb   $87
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
         fcb   $52 R
         fcb   $65 e
         fcb   $61 a
         fcb   $64 d
         fcb   $79 y
         fcb   $00
         fcb   $56 V
         fcb   $61 a
         fcb   $6C l
         fcb   $75 u
         fcb   $65 e
         fcb   $00
         fcb   $4C L
         fcb   $61 a
         fcb   $62 b
         fcb   $65 e
         fcb   $6C l
         fcb   $00
         fcb   $6C l
         fcb   $20
         fcb   $4D M
         fcb   $65 e
         fcb   $72 r
         fcb   $67 g
         fcb   $65 e
         fcb   $0F
         fcb   $32 2
         fcb   $2B +
         fcb   $20
         fcb   $53 S
         fcb   $70 p
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $20
         fcb   $43 C
         fcb   $68 h
         fcb   $65 e
         fcb   $63 c
         fcb   $6B k
         fcb   $12
         fcb   $32 2
         fcb   $2B +
         fcb   $20
         fcb   $53 S
         fcb   $74 t
         fcb   $79 y
         fcb   $6C l
         fcb   $6F o
         fcb   $2F /
         fcb   $4D M
         fcb   $4D M
         fcb   $2F /
         fcb   $53 S
         fcb   $70 p
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $0C
         fcb   $32 2
         fcb   $2B +
         fcb   $20
         fcb   $44 D
         fcb   $79 y
         fcb   $6E n
         fcb   $61 a
         fcb   $63 c
         fcb   $61 a
         fcb   $6C l
         fcb   $63 c
         fcb   $10
         fcb   $32 2
         fcb   $2A *
         fcb   $20
         fcb   $52 R
         fcb   $4D M
         fcb   $53 S
         fcb   $20
         fcb   $64 d
         fcb   $61 a
         fcb   $74 t
         fcb   $61 a
         fcb   $62 b
         fcb   $61 a
         fcb   $73 s
         fcb   $65 e
         fcb   $07
         fcb   $30 0
         fcb   $45 E
         fcb   $20
         fcb   $20
         fcb   $50 P
         fcb   $52 R

         fcb   $0A
         fcb   $A3 #
         fcb   $40 @
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $81

         fcb   $0A
         fcb   $A3 #
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $84

         fcb   $07
         fcb   $30 0
         fcb   $64 d
         fcb   $6F o
         fcb   $6C l
         fcb   $6C l
         fcb   $61 a

         fcb   $07
         fcb   $30 0
         fcb   $70 p
         fcb   $72 r
         fcb   $69 i
         fcb   $63 c
         fcb   $65 e

         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87

         fcb   $06
         fcb   $30 0
         fcb   $49 I
         fcb   $43 C
         fcb   $45 E
         fcb   $20

         fcb   $06
         fcb   $30 0
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20

         fcb   $03
         fcb   $30 0
         fcb   $25 %

         fcb   $04
         fcb   $30 0
         fcb   $72 r
         fcb   $20

         fcb   $03
         fcb   $30 0
         fcb   $20

         fcb   $03
         fcb   $37 7
         fcb   $2E .

         fcb   $06
         fcb   $30 0
         fcb   $20
         fcb   $4C L
         fcb   $49 I
         fcb   $53 S

         fcb   $06
         fcb   $30 0
         fcb   $20
         fcb   $65 e
         fcb   $6E n
         fcb   $64 d

         fcb   $06
         fcb   $30 0
         fcb   $20
         fcb   $75 u
         fcb   $73 s
         fcb   $65 e
         fcb   $49 I
         fcb   $20
         fcb   $16
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $0B
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $06
         fcb   $30 0
         fcb   $54 T
         fcb   $20
         fcb   $20
         fcb   $44 D
         fcb   $06
         fcb   $30 0
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $06
         fcb   $30 0
         fcb   $72 r
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $03
         fcb   $37 7
         fcb   $2E .

         fcb   $06
         fcb   $30 0
         fcb   $45 E
         fcb   $43 C
         fcb   $45 E
         fcb   $4D M

         fcb   $06
         fcb   $33 3
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $44 D

         fcb   $06
         fcb   $30 0
         fcb   $20
         fcb   $31 1
         fcb   $20
         fcb   $2D -
         fcb   $06
         fcb   $30 0
         fcb   $20
         fcb   $34 4
         fcb   $20
         fcb   $2D -
         fcb   $06
         fcb   $30 0
         fcb   $31 1
         fcb   $30 0
         fcb   $20
         fcb   $2D -
         fcb   $06
         fcb   $30 0
         fcb   $35 5
         fcb   $30 0
         fcb   $20
         fcb   $2D -
         fcb   $06
         fcb   $30 0
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $06
         fcb   $30 0
         fcb   $20
         fcb   $31 1
         fcb   $2D -
         fcb   $33 3
         fcb   $4C L
         fcb   $20
         fcb   $02
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $0B
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $07
         fcb   $03
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83

         fcb   $06
         fcb   $30 0
         fcc   "BER "

         fcb   $06
         fcb   $30 0
         fcb   $49 I
         fcb   $53 S
         fcb   $43 C
         fcb   $4F O

         fcb   $06
         fcb   $30
         fcc   '  3 '

         fcb   $05
         fcb   $30
         fcc   '  9'

         fcb   $05
         fcb   $30
         fcc   ' 49'

M0562    fcc   " December 13, 1983"
         fcb   $00

M0575    fcb   $08
         fcb   $00
         fcb   $30 0
         fcb   $20
         fcb   $31 1
         fcb   $39 9
         fcb   $38 8

         fcb   $06
         fcb   $30 0
         fcb   $55 U
         fcb   $4E N
         fcb   $54 T
         fcb   $20

         fcb   $0A,$A0,$20,$00,$00,$00,$00,$00,$00,$85
         fcb   $0A,$A0,$0C,$00,$00,$00,$00,$00,$00,$86

         fcb   $0A
         fcb   $A0
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $0A
         fcb   $A0
         fcb   $34 4
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $06
         fcb   $30 0
         fcb   $6C l
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $06
         fcb   $30 0
         fcb   $20
         fcb   $34 4
         fcb   $2D -
         fcb   $39 9
         fcb   $4C L
         fcb   $20
         fcb   $5C \
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $0B
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $07
         fcb   $04
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
M05FE    fcb   $01
M05FF    fcb   $00
M0600    fcb   $00
         fcb   $24 $
         fcb   $03
         fcb   $30 0
         fcb   $33 3
         fcb   $06
         fcb   $30 0
         fcb   $54 T

* Out of memory routine
M0608    ldy   #$004E
         leax  >M0629,pcr
         lda   #$02
         os9   I$Write
         clra
         leax  >M0629,pcr
         ldy   #$0001
         os9   I$Read
         ldu   >M0575,pcr
         jmp   >$3AD5,u

M0629    fcb   $0D
         fcb   $0A
         fcb   $0A
M062C    fcc   "OUT OF MEMORY- Worksheet not completely loaded."
         fcb   $0D
         fcb   $0A
M065D    fcc   "Press any key to continue."

M0677    fcb   $30 0
         fcb   $2D -
         fcb   $34 4
         fcb   $4C L
         fcb   $20
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
* Default printer name (60 bytes)
M0680    fcc   "/P "
         fcb   $00
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $0B
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $07
         fcb   $05
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00

M06C0    fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $06
         fcb   $30 0
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $06
         fcb   $30 0
         fcb   $39 9
         fcb   $20
M06D0    fcb   $20
         fcb   $20
         fcb   $03
         fcb   $37 7
         fcb   $2E .
         fcb   $06
         fcb   $30 0
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $06
         fcb   $30 0
         fcb   $35 5
         fcb   $30 0
         fcb   $2D -
         fcb   $39 9
         fcb   $4C L
         fcb   $20
         fcb   $34 4
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $0B
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $07
         fcb   $06
         fcb   $40 @
         fcb   $01
         fcb   $1B,$41,$06,$0F    Cyrsor XY
M0704    fcc   " (Press any key to continue)  "
         fcb   $FF
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $06
         fcb   $30 0
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $04
         fcb   $30 0
         fcb   $39 9
         fcb   $20
         fcb   $03
         fcb   $37 7
         fcb   $2E .
         fcb   $06
         fcb   $30 0
         fcb   $20
         fcb   $4F O
         fcb   $45 E
         fcb   $4D M

         fcb   $0A
         fcb   $A0
         fcb   $70 p
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86

         fcb   $4C L
         fcb   $20
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $0B
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $04
         fcb   $10
         fcb   $20
         fcb   $25 %

         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87

         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87

         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87

         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87

         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87

         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87

         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87

         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87

         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87

         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $0A
         fcb   $A0
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $49 I
         fcb   $20
         fcb   $16
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $0C
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $49 I
         fcb   $20
         fcb   $16
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $0D
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $49 I
         fcb   $20
         fcb   $16
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $0F
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $49 I
         fcb   $20
         fcb   $16
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $10
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $49 I
         fcb   $20
         fcb   $16
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $12
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $A0
         fcb   $00
         fcb   $01
         fcb   $59 Y
         fcb   $00
         fcb   $00
         fcb   $0F
         fcb   $FD
         fcb   $A0
         fcb   $A0
         fcb   $00
         fcb   $00
         fcb   $59 Y
         fcb   $59 Y
         fcb   $80
         fcb   $02
         fcb   $3F ?
         fcb   $59 Y
         fcb   $8D
         fcb   $D3 S
         fcb   $00
         fcb   $01
         fcb   $80
         fcb   $03
         fcb   $3F ?
         fcb   $59 Y
         fcb   $58 X
         fcb   $00
         fcb   $32 2
         fcb   $00
         fcb   $8D
         fcb   $3D =
         fcb   $8C
         fcb   $E5 e
         fcb   $64 d
         fcb   $5B [

M09F0    nop
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
M0A05    lbra  M0A27

* Entry point for start routine in dynacalc program
* X contains the program counter a few instructions before the jump.
M0A08    lbra  M0A21

         pshs  x,a
         tfr   pc,x
         leax  >-$5A0F,x
         stx   >M0575,pcr
         lda   #$FF
         sta   >$0143,u
         puls  x,a
         bra   M0A74

M0A21    cmpd  #$0473   version number test
         beq   M0A6A
M0A27    lda   #$02
         leax  >M0A38,pcr
         ldy   #$FFFF
         os9   I$WritLn
         clrb
         os9   F$Exit

M0A38    fcc   "DYNACALC and DYNACALC.TRM are different versions."
         fcb   $0D

M0A6A    leax  >PGBEGIN-PCSAVEPT,x   PGBEGIN-PCSAVEPT = $15
         stx   >M0575,pcr
         puls  u,y,x,b,a
M0A74    std   >$01C1,u
         tfr   dp,a
         inca
         tfr   a,dp
         stx   <PARAMS
         stu   <MEMPTR   beginning of data
         leax  >$0280,u
         stx   <$00E9
         ldx   #$0700
         stx   <$0044
         clr   <$00ED
         clr   <$00EE
         clr   <$0019
         clr   <$00A7
         clr   >M06C0,pcr
         ldu   <MEMPTR   beginning of data
         leax  >$09F0,u
         stx   <$0017
         tfr   x,s
         leax  >$0331,u
         stx   <$0030
         leax  <$2F,x
         clra
         clrb
         os9   I$GetStt
         bra   M0AB2
M0AB2
         leax  >M0680,pcr
         lda   #$02
         os9   I$Open
         bcc   M0AD0
         leax  >M0680,pcr
         lda   #$02
         ldb   #%00011011 File permissions for new file
         os9   I$Create
         bcc   M0AD0
         clr   >M0680,pcr
         bra   M0B05

M0AD0    sta   <$0012   data file path number
M0AD2    ldx   <$0030
         clrb
         os9   I$GetStt
         bcs   M0AFA
         ldx   <$0030
         clrb
         lda   ,x
M0ADF    beq   M0AF4
         deca
         bne   M0AFA
         lda   <$0012   data file path number
         ldb   #$02      Get file size
         os9   I$GetStt
         bcs   M0AFA
         os9   I$Seek
         bcs   M0AFA
         ldb   #$FF
M0AF4    stb   <$0013
         bne   M0B05
         bra   M0AFE
M0AFA    clr   >M0680,pcr
M0AFE    lda   <$0012   data file path number
M0B00    os9   I$Close
         clr   <$0012   data file path number
M0B05    ldx   <$0030
         os9   F$Time
         leay  >M0562,pcr
         lda   $01,x
         deca
         cmpa  #11
         bls   M0B16
         clra
M0B16    ldb   #$09
         mul
         leau  >MONTHS,pcr  Calendar months
         leau  d,u
M0B1F    ldb   #$09
M0B21    lda   ,u+
         sta   ,y+
         decb
         bne   M0B21
         lda   #$20
         sta   ,y+
         ldb   $02,x
         bsr   M0B44
         ldd   #$2C20
         std   ,y++
         ldd   #$3139   string '19'
         std   ,y++
         ldx   <$0030
         ldb   ,x
         bsr   M0B44
         clr   ,y
         bra   M0B60

M0B44    clra
         ldu   #$0700
         stu   <$0044
         ldu   >M0575,pcr
         jsr   L4795-PGBEGIN,u   >$4780,u  = L4795
         ldu   #$0700
         stu   <$0044
         ldd   <MEMPTR
         leau  d,u
         ldd   $03,u
         std   ,y++
         rts

M0B60    ldy   >M0575,pcr
         jsr   >L0E44-PGBEGIN,y     >$0E2F,y
         ldb   $01,x
         bne   M0B73
         ldb   >M00F8,pcr
         beq   M0B77
M0B73    stb   >M00FA,pcr
M0B77    clr   $0C,x
         tst   <$0043
         bne   M0B88
         clr   $0F,x
M0B7F    clr   <$10,x
         clr   <$11,x
         clr   <$16,x
M0B88    clr   $04,x
         jsr   >L0E4F-PGBEGIN,y     >$0E3A,y
         ldu   #$01F1
         stu   <$00EB
         clr   <$00E0
         clr   <$00E8
         clr   <$00C4
         tst   >M00B8,pcr    Cursor control sequences
         bpl   M0BA1
M0B9F    dec   <$000E
M0BA1    tst   >M00F7,pcr
         bne   M0BAD
         lda   #$04
         sta   >M00F7,pcr
M0BAD    lda   #$90
         ldy   >M0575,pcr
         jsr   >L0DC4-PGBEGIN,y   >$0DAF,y
         lda   #$FF
         sta   <$00F0
         jsr   >L0D36-PGBEGIN,y   >$0D21,y
M0BC0    ldd   <$000D
         subd  #$0A26
         lsra
         lsrb
         std   <$00BD
         ldb   #4   Number of segments to print
         leau  >M0D57,pcr    Write DYNACALC on startup
M0BCF    jsr   >L0D57-PGBEGIN,y   >$0D42,y
         jsr   >L1AB9-PGBEGIN,y
         inc   <$00BD
         inc   <$00BD
         decb
         bne   M0BCF
         jsr   >L0D57-PGBEGIN,y   >$0D42,y
M0BE2    ldd   <$00C1
         cmpd  #$0001
         bls   M0C35
         ldy   <PARAMS
         lda   ,y
         cmpa  #$2D
         beq   M0C25
         ldb   #$0C
         ldx   <$00E9

M0BF7    lda   ,y+
         cmpa  #$20
         beq   M0C1D
         cmpa  #$0D
         beq   M0C0A   Found end of parameters
         incb
         stb   <$00ED
         sta   b,x
         cmpb  #'/
         bne   M0BF7
M0C0A    tst   <$00ED
         beq   M0C35
         leau  >M0DC8,pcr     Write Loading
         ldy   >M0575,pcr
         jsr   >L1AB9-PGBEGIN,y    >$1AA4,y
         bra   M0C5B

M0C1D    lda   ,y+
         cmpa  #$20
         beq   M0C1D
         leay  -$01,y
M0C25    ldb   $01,y
         andb  #$5F
         cmpd  #$2D48
         bne   M0C0A
         sta   >M00FB,pcr
         bra   M0C0A

M0C35    ldy   >M0575,pcr
         jsr   >L1AB9-PGBEGIN,y    >$1AA4,y
         ldb   #$04
         stb   <$0025
         clr   >M05FF,pcr
         clr   >M05FE,pcr
M0C4A    jsr   >L1AC5-PGBEGIN,y    >$1AB0,y
         bne   M0C54
         dec   <$0025
         bne   M0C4A
M0C54    tst   <$0043
         beq   M0C5B
         lbsr  $3400  Dynacalc.trm is only $3200 bytes
M0C5B    ldb   #$08
         leax  >M0100,pcr
         leau  >M0CCB,pcr
         ldy   <MEMPTR
M0C68    lda   ,x+
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
         bne   M0C68
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
         ldx   <PARAMS
         leax  $01,x
         pshs  x
         ldx   <MEMPTR   beginning of data
         tst   >$00FB,x
         puls  x
         bne   M0CB6
         leax  -$02,x
         clr   <$001D
         ldy   >M0575,pcr
         jsr   >L3AFF-PGBEGIN,y   >$3AEA,y
M0CB6    nop
         tfr   x,d
         std   <$001E
         subd  <$0017
         lsra
         rorb
         addd  <$0017
         std   <$0023
         ldu   >M0575,pcr
         jmp   >L4EC7-PGBEGIN,u    >$4EB2,u


M0CCB    fdb   $0381
         fdb   $03A9
         fdb   $0382
         fdb   $03AA
         fdb   $0383
         fdb   $03AB
         fdb   $0384
         fdb   $03AC
         fdb   $03A7
         fdb   $03A7
         fdb   $03A4
         fdb   $03A4
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
M0D57    fcc   "      **** DYNACALC ****"
         fcb   0

         fcc   "                              "
         fcb   $00
M0D8F    fcb   $20
         fcb   $00
M0D91    fcc   "      for the Dragon 64"
         fcb   $00

M0DA9    fcc   " (Press any key to continue)  "
         fcb   $00
M0DC8    fcc   "      Loading "
         fcb   $00

         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $49 I
         fcb   $20
         fcb   $16
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $28 (
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $49 I
         fcb   $20
         fcb   $16
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $29 )
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $49 I
         fcb   $20
         fcb   $16
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $2A *
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $49 I
         fcb   $20
         fcb   $16
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $2C ,
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $16
         fcb   $00
         fcb   $76 v
         fcb   $16
         fcb   $00
         fcb   $07
         fcb   $1E
         fcb   $67 g
         fcb   $7D
         fcb   $67 g
         fcb   $16
         fcb   $01
         fcb   $39 9

M0F0D    ldu   <$001A
         ldy   >$0575,u
         leau  >M0F5C,pcr
         jsr   >$1AA4,y
         jsr   >$08EF,y
         cmpa  #$59
         beq   M0F28
         jmp   >$1A89,y
M0F28    ldu   <$001E
         ldx   <$0041
         leax  $01,x
         stx   <$001E
         pshs  u,x
         com   <$001D
         ldd   <$0041
         subd  <$0017
         lsra
         rorb
         addd  <$0017
         jsr   >$4EB5,y
         tfr   u,d
         subd  <$00C5
         std   <$006C
         ldd   <$001E
         subd  <$006C
         std   <$00C5
         ldd   <$006C
         clr   <$007D
         lsra  
         rorb  
         ror   <$007D
         std   <$006C
         puls  u,x
         jmp   >$3AE1,y

M0F5C    fcc   "Delete helps: Are you sure? "
         fcb   $00

M0F79    pshs  y
         ldy   <$001A
         ldy   >$0575,y
         ldb   ,x
         cmpb  #$88
         bne   M0F91
         tst   <$00E1
         beq   M0F91
         ldb   #$9A
         clr   <$00E1
M0F91    stb   <$0025
         ldu   <$00B1
         lda   <$00B3
         ldb   <$0075
         pshs  u,b,a
M0F9B    lbsr  M1042
         lda   #$0A

         jsr   >$0925,y
         leax  >M2CC3,pcr
         ldb   <$0025
         abx
         ldd   ,x
         leau  >M1071,pcr
         leau  d,u
M0FB3    lda   ,u+
         beq   M0FEA
         cmpa  #$11
         bne   M0FDE
         jsr   >$3ADE,y
         jsr   >$0901,y
         ldb   -$01,x
         incb
         lda   b,x
         pshs  a
         clr   b,x

         jsr   >$08EF,y
         puls  a
         cmpa  #$1B
         beq   M101D
         pshs  u
         bsr   M1042
         puls  u
         bra   M0FE6
M0FDE    jsr   >$0925,y
         cmpa  #$0D
         bne   M0FB3
M0FE6    lda   #$0A
         bra   M0FDE
M0FEA    jsr   >$3ADE,y
         jsr   >$0901,y
         lda   <$0025
         cmpa  #$80
         bne   M101D
         ldb   -$01,x
         incb
         lda   b,x
         cmpa  #$40
         bne   M1005
         ldb   #$9C
         bra   M100B
M1005    cmpa  #$3E
         bne   M1013
         ldb   #$9E
M100B    stb   <$0025
         jsr   >$08EF,y
         bra   M0F9B
M1013    anda  #$5F
         cmpa  #$47
         bne   M101D
         ldb   #$84
         bra   M100B

M101D    bsr   M1042
         clr   <$00AC
         jsr   >$1ABC,y
         ldy   <$001A
         ldy   >$0575,y
         ldx   #$0200
         jsr   >$08B9,y
         jsr   >$3ADE,y
         puls  u,b,a
         sta   <$00B3
         stu   <$00B1
         stb   <$0075
         puls  pc,y

M1042    jmp   >$091C,y
         ldu   <$001A
         ldy   >$0575,u
         ldd   #$2C20
         jsr   >$1A8C,y
         ldb   <$0025
         leax  >M2CD5,pcr
         subb  #$C8
         cmpb  #$35
         bls   M1062
         ldb   #$36
M1062    lslb
         abx
         ldd   ,x
         leau  >M28BF,pcr
         leau  d,u
         jsr   >$3FAE,y
         rts

M1071    fcc   "A  set Attributes"
         fcb   $0D
M1083    fcc   "B  Blank current cell"
         fcb   $0D
M1099    fcc   "C  Clear entire worksheet"
         fcb   $0D
M10B3    fcc   "D  Delete current column or row"
         fcb   $0D
M10D3    fcc   "E  Edit contents of current cell"
         fcb   $0D
M10F4    fcc   "F  set Format of current cell"
         fcb   $0D
M1112    fcc   "I  Insert new column or row at current position"
         fcb   $0D
M1142    fcc   "L  Locate specified label "
         fcb   $0D
M115D    fcc   /   (?="Wild card", @="Don't ignore case")/
         fcb   $0D
M1187    fcc   "M  Move column or row to new position"
         fcb   $0D
M11AD    fcc   "P  Print all or portion of worksheet to"
         fcb   $0D
         fcc   "   system printer or textfile"
         fcb   $0D
         fcc   "Q  Quit DYNACALC and go to Sleep or to OS-9"
         fcb   $0D
         fcc   "R  Replicate cell or group of cells"
         fcb   $0D
         fcc   "S  call System function"
         fcb   $0D
         fcc   "T  set column or row Titles"
         fcb   $0D
         fcc   "W  adjust display Window(s)"
         fcb   $0D
         fcc   "   Hit @ for help with FUNCTIONS"
         fcb   $0D
         fcc   "       > for help with ERRORS"
         fcb   $0D
         fcc   "       G for general helps"
         fcb   $0D
         fcb   $00

M12EE    fcc   "Set Attributes:"
         fcb   $0D
         fcb   $0A
         fcc   "B  toggles Bell on/off (default = on)"
         fcb   $0D
         fcc   "D  toggles Degree/radian mode (default = degrees)"
         fcb   $0D
         fcc   "G  allows changing Graph character (default = #)"
         fcb   $0D
         fcc   "H  deletes Help messages & increases user space"
         fcb   $0D
         fcc   "L  toggles Label entry mode flag (default = off)"
         fcb   $0D
         fcc   "M  re-write (Modify) screen"
         fcb   $0D
         fcc   "O  toggles Column/Row calc Order (default = C)"
         fcb   $0D
         fcc   "P  allows changing Printer/textfile parameters"
         fcb   $0D
         fcc   "R  toggles Auto/Manual Recalculate (default = A)"
         fcb   $0D
         fcc   "S  reports Size of worksheet"
         fcb   $0D
         fcc   "T  toggles Type protection (default = off)"
         fcb   $0D
         fcc   "W  allows changing column Width(s)"
         fcb   $0D
         fcb   $00
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcc   "Delete column/row:"
         fcb   $0D
         fcb   $0A
         fcc   "C  deletes current Column"
         fcb   $0D
         fcc   "R  deletes current Row"
         fcb   $0D
         fcb   $00
         fcc   "Set Format of current cell:"
         fcb   $0D
         fcb   $0A
         fcc   "C  Continuous - characters repeated"
         fcb   $0D
         fcc   "   throughout cell"
         fcb   $0D
         fcc   "D  Default - uses window format"
         fcb   $0D
         fcc   "G  General - labels left, numbers right"
         fcb   $0D
         fcc   "I  Integer - rounds DISPLAY to nearest integer"
         fcb   $0D
         fcc   "L  Left justify - forces number to left of cell"
         fcb   $0D
         fcc   "P  Plot - uses cell's integer value as number"
         fcb   $0D
         fcc   "   of graph characters to print"
         fcb   $0D
         fcc   "R  Right justify - forces label to right of cell"
         fcb   $0D
         fcc   "$  Money - rounds DISPLAY to nearest penny"
         fcb   $0D
         fcb   $00
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcc   "Insert new column or row:"
         fcb   $0D
         fcb   $0A
         fcc   "C  inserts new blank Column at current position"
         fcb   $0D
         fcc   "R  inserts new blank Row at current position"
         fcb   $0D
         fcb   $00
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcc   "Quit:"
         fcb   $0D
         fcb   $0A
         fcc   "O  leave DYNACALC and return to OS-9"
         fcb   $0D
         fcc   "S  puts computer to Sleep until any key is struck"
         fcb   $0D
         fcb   $00

         fcc   "System:"
         fcb   $0D
         fcb   $0A
         fcc   "C  Change the current directory"
         fcb   $0D
         fcc   "L  Load worksheet from disk - "
         fcb   $0D
         fcc   "   overlays current sheet"
         fcb   $0D
         fcc   "S  Save current worksheet to disk"
         fcb   $0D
         fcc   "   Save and Load both default to"
         fcb   $0D
         fcc   "   .cal in current directory"
         fcb   $0D
         fcb   $0A
         fcc   "X  eXecute OS-9 command"
         fcb   $0D
         fcb   $0A
         fcc   "#  data file save/load - for data exchange"
         fcb   $0D
         fcc   "   both default to the current directory"
         fcb   $0D
         fcb   $00
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcc   "Save data:"
         fcb   $0D
         fcb   $0A
         fcc   "L  Load labels and CALCULATED Values from disk"
         fcb   $0D
         fcb   $0A
         fcc   "S  Save labels and CALCULATED Values to disk"
         fcb   $0D
         fcb   $00
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcc   "Titles:"
         fcb   $0D
         fcb   $0A
         fcc   "B  set up Both horizontal and vertical titles"
         fcb   $0D
         fcc   "H  set up row(s) above cursor as"
         fcb   $0D
         fcc   "   Horizontal title area"
         fcb   $0D
         fcc   "N  No titles"
         fcb   $0D
         fcc   "V  set up column(s) to left of cursor as"
         fcb   $0D
         fcc   "   Vertical title area"
         fcb   $0D
         fcb   $00
         fcc   "Windows:"
         fcb   $0D
         fcb   $0A
         fcc   "D  toggle value/formula Display flag"
         fcb   $0D
         fcc   "   (defaults to value)"
         fcb   $0D
         fcc   "F  sets default Format of all cells in"
         fcb   $0D
         fcc   "   current window"
         fcb   $0D
         fcc   "H  divides screen Horizontally into two windows"
         fcb   $0D
         fcc   "   at current location"
         fcb   $0D
         fcc   "N  No division - returns display to single window"
         fcb   $0D
         fcc   "S  Synchronizes motion of two windows"
         fcb   $0D
         fcc   "U  Unsynchronizes motion of two windows (default)"
         fcb   $0D
         fcc   "V  divides screen Vertically into two windows"
         fcb   $0D
         fcc   "   at current location"
         fcb   $0D
         fcb   $00
M1BC7
         fcc   "Set default format of current window:"
         fcb   $0D
         fcb   $0A
         fcc   "C  Continuous - characters repeated"
         fcb   $0D
         fcc   "   throughout cell"
         fcb   $0D
         fcc   "D  Default - general format (see)"
         fcb   $0D
         fcc   "G  General - labels left, numbers right"
         fcb   $0D
         fcc   "I  Integer - rounds DISPLAY to nearest integer"
         fcb   $0D
         fcc   "L  Left justify - forces number to left of cell"
         fcb   $0D
         fcc   "P  Plot - uses cell's integer value as number"
         fcb   $0D
         fcc   "   of graph characters to print"
         fcb   $0D
         fcc   "R  Right justify - forces label to right of cell"
         fcb   $0D
         fcc   "$  Dollar - rounds DISPLAY to nearest cent"
         fcb   $0D
         fcb   $00
         fcc   "Printer attributes:"
         fcb   $0D
         fcb   $0A
         fcc   "B  toggles Border flag on/off (defaults to off)"
         fcb   $0D
         fcc   "C  Clears the printer file name"
         fcb   $0D
         fcc   "L  sets Length of page (defaults to 58 lines)"
         fcb   $0D
         fcc   "P  toggles Pagination flag on/off (defaults to on)"
         fcb   $0D
         fcc   "S  sets the Spaces between lines"
         fcb   $0D
         fcc   "W  sets Width of page (defaults to 80 characters)"
         fcb   $0D
         fcb   $0A
         fcc   "  All of these default values may be permanently"
         fcb   $0D
         fcc   '  modified by the user, using "Install.dc"'
         fcb   $0D
         fcb   $00
         fcb   $0A
         fcb   $0A

         fcc   "Width:"
         fcb   $0D
         fcb   $0A
         fcc   "C  allows changing width of current Column"
         fcb   $0D
         fcc   "   (defaults to Window value)"
         fcb   $0D
         fcb   $0A
         fcc   "W  allows changing default width of all columns"
         fcb   $0D
         fcc   "   in current Window"
         fcb   $0D
         fcc   "   (defaults to 9 characters)"
         fcb   $0D
         fcb   $00
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcc   "Move column/row:"
         fcb   $0D
         fcb   $0A
         fcc   "A  Sort columns/rows in the given range"
         fcb   $0D
         fcc   "   in Ascending order"
         fcb   $0D
         fcc   "D  Sort columns/rows in the given range"
         fcb   $0D
         fcc   "   in Descending order"
         fcb   $0D
         fcc   "M  Manually move column/row"
         fcb   $0D
         fcb   $00
         fcb   $0A
         fcb   $0A
         fcc   "C  loads/saves data by Column"
         fcb   $0D
         fcb   $0A
         fcc   "D  loads/saves data by Default order"
         fcb   $0D
         fcb   $0A
         fcc   "R  loads/saves data by Rows"
         fcb   $0D
         fcb   $00
M20BB    fcc   "Trigonometric:"
         fcb   $0D
         fcc   "  @SIN      @ASIN     @PI (3.14)"
         fcb   $0D
M20EB    fcc   "  @COS      @ACOS "
         fcb   $0D
         fcc   "  @TAN      @ATAN "
         fcb   $0D
         fcb   $0A
         fcc   "Logarithmic:"
         fcb   $0D
         fcc   "  @LOG(x)      logarithm of x to base 10"
         fcb   $0D
         fcc   "  @LN(x)       logarithm of x to base e (2.718...)"
         fcb   $0D
         fcc   "  @EXP(x)      e raised to x power"
         fcb   $0D
         fcc   "  @SQRT(x)     square root x"
         fcb   $0D
         fcb   $0A
         fcc   "General:"
         fcb   $0D
         fcc   "  @ABS(x)      absolute value of x"
         fcb   $0D
         fcc   "  @INT(x)      integer part of x"
         fcb   $0D
         fcc   "  @ROUND(d,x)  x rounded to nearest d"
         fcb   $0D
         fcc   "               (d must be even power of 10)"
         fcb   $0D
         fcb   $0A
         fcc   "               Hit any key to see page 2"
         fcb   $0D
         fcb   $11
         fcc   "Series:   (in range x...y)"
         fcb   $0D
         fcc   "   @COUNT(x...y)    number of cells"
         fcb   $0D
         fcc   "   @SUM(x...y)      sum of values of cells"
         fcb   $0D
         fcc   "   @AVERAGE(x...y)  average value of cells"
         fcb   $0D
         fcc   "   @STDDEV(m,x...y) standard deviation of cells,"
         fcb   $0D
         fcc   "   m sets method:  <0 = population;  >=0 = sample"
         fcb   $0D
         fcc   "   @MIN(x...y)      least value of cells"
         fcb   $0D
         fcc   "   @MAX(x...y)      greatest value of cells"
         fcb   $0D
         fcc   "   @NPV(r,x...y)    Net Present Value at rate r"
         fcb   $0D
         fcc   "Indexing:"
         fcb   $0D
         fcc   "   @CHOOSE(n,x...y) value of nth cell in range"
         fcb   $0D
         fcc   "   @LOOKUP(n,x...y,z) '>' search -"
         fcb   $0D
         fcc   "   z optional - see manual"
         fcb   $0D
         fcc   "   @INDEX(n,x...y,z)  '=' search -"
         fcb   $0D
         fcc   "   z optional - see manual"
         fcb   $0D
         fcc   "Error:"
         fcb   $0D
         fcc   "   @ERROR     causes >NA< message (not available)"
         fcb   $0D
         fcc   "   @NA        causes >NA< message (not available)"
         fcb   $0D
         fcb   $0A
         fcc   "   Hit ESCAPE key to exit Help"
         fcb   $0D
         fcb   $00
         fcc   "Arithmetic operators:"
         fcb   $0D
         fcc   "   x+y adds x and y"
         fcb   $0D
         fcc   "   x-y  subtracts y from x"
         fcb   $0D
         fcc   "   (use 0-x for monadic minus)"
         fcb   $0D
         fcc   "   x*y  multiplies x by y"
         fcb   $0D
         fcc   "   x/y  divides x by y"
         fcb   $0D
         fcc   "   x^y  raises x to y power"
         fcb   $0D
         fcb   $0A
         fcc   "Maximum number of terms is 11"
         fcb   $0D
         fcb   $0A
         fcc   "Parentheses in terms may be nested to any depth"
         fcb   $0D
         fcb   $0A
         fcc   "To enter expression, first character must"
         fcb   $0D
         fcc   "not be alphabetic"
         fcb   $0D
         fcc   "   For example, to enter A1+A2, type '+A1+A2'"
         fcb   $0D
         fcb   $0A
         fcc   "To enter numeric as a label, use leading"
         fcb   $0D
         fcc   "single-quote (')"
         fcb   $0D
         fcb   $0A
         fcc   "    Hit ESCAPE key to exit Help"
         fcb   $0D
         fcb   $00
M270D    fcc   "       DYNACALC Error Messages"
         fcb   $0D
         fcb   $0A
         fcc   "    >AE<  Bad argument error"
         fcb   $0D
         fcc   "    >D0<  Divide by zero attempted"
         fcb   $0D
         fcc   "    >ER<  General purpose error"
         fcb   $0D
         fcc   "    >EX<  Exponent too large"
         fcb   $0D
         fcc   "    >HO<  Holder overflow error"
         fcb   $0D
         fcc   "    >LN<  Negative or zero logarithm attempted"
         fcb   $0D
         fcc   "    >NA<  Not available"
         fcb   $0D
         fcc   "    >NR<  Negative root attempted"
         fcb   $0D
         fcc   "    >OV<  Arithmetic overflow error"
         fcb   $0D
         fcc   "    >RE<  Reference error"
         fcb   $0D
         fcc   "    >RN<  Range error"
         fcb   $0D
         fcc   "    >SN<  Syntax error"
         fcb   $0D
         fcb   $0A
         fcc   "      Hit any key to exit Help"
         fcb   $0D
         fcb   $00
M28BF    fcc   "Path table full."
         fcb   $00
         fcc   "Illegal path number."
         fcb   $00
         fcc   "Interrupt polling table full."
         fcb   $00
         fcc   "Illegal I/O mode."
         fcb   $00
         fcc   "Device table overflow."
         fcb   $00
         fcc   "Illegal module ID block."
         fcb   $00
         fcc   "Module directory full."
         fcb   $00
         fcc   "Memory full."
         fcb   $00
         fcc   "Unknown service request."
         fcb   $00
         fcc   "Module busy."
         fcb   $00
         fcc   "Bad boundary."
         fcb   $00
         fcc   "End of file."
         fcb   $00
         fcc   "Returning non-allocated memory."
         fcb   $00
         fcc   "Non-existing segment."
         fcb   $00
         fcc   "No permission- access denied."
         fcb   $00
         fcc   "Bad path name."
         fcb   $00
         fcc   "The file/device cannot be found."
         fcb   $00
         fcc   "Segment list filled."
         fcb   $00
         fcc   "Creating existing file."
         fcb   $00
         fcc   "Illegal block address."
         fcb   $00
         fcc   "Illegal block size."
         fcb   $00
         fcc   "Link to a non-existing module."
         fcb   $00
         fcc   "Sector number out of range."
         fcb   $00
         fcc   "Deallocating stack memory."
         fcb   $00
         fcc   "Illegal process ID."
         fcb   $00
         fcc   "Illegal signal code."
         fcb   $00
         fcc   "No children."
         fcb   $00
         fcc   "Illegal SWI code."
         fcb   $00
         fcc   "Keyboard abort."
         fcb   $00
         fcc   "Process table full."
         fcb   $00
         fcc   "Illegal fork parameter area."
         fcb   $00
         fcc   "Known module."
         fcb   $00
         fcc   "Bad module CRC."
         fcb   $00
         fcc   "Unprocessed signal pending."
         fcb   $00
         fcc   "Non-executable module."
         fcb   $00
         fcc   "Unit number out of range."
         fcb   $00
         fcc   "Sector number out of range."
         fcb   $00
         fcc   "Write protect."
         fcb   $00
         fcc   "Checksum error."
         fcb   $00
         fcc   "Read error."
         fcb   $00
         fcc   "Write error."
         fcb   $00
         fcc   "Device not ready."
         fcb   $00
         fcc   "Seek error."
         fcb   $00
         fcc   "Media full."
         fcb   $00
         fcc   "Device/media type mismatch."
         fcb   $00
         fcc   "Device busy."
         fcb   $00
         fcc   "Device/media ID changed."
         fcb   $00
         fcc   "Indirect file error."
         fcb   $00
         fcc   "Indirect file was accessed."
         fcb   $00
M2CC1    fcc   "Un"
M2CC3    fcc   "known error code."
         fcb   $00

M2CD5    fcb   $00
         fcb   $00
         fcb   $00
         fcb   $11
         fcb   $00
         fcb   $26 &
         fcb   $00
         fcb   $44 D
         fcb   $00
         fcb   $56 V
         fcb   $00
         fcb   $6D m
         fcb   $00
         fcb   $86
         fcb   $00
         fcb   $9D
         fcb   $00
         fcb   $AA *
         fcb   $00
         fcb   $C3 C
         fcb   $00
         fcb   $D0 P
         fcb   $00
         fcb   $DE ^
         fcb   $00
         fcb   $EB k
         fcb   $01
         fcb   $0B
         fcb   $01
         fcb   $21 !
         fcb   $01
         fcb   $3F ?
         fcb   $01
         fcb   $4E N
         fcb   $01
         fcb   $6F o
         fcb   $01
         fcb   $84
         fcb   $01
         fcb   $9C
         fcb   $01
         fcb   $B3 3
         fcb   $01
         fcb   $C7 G
         fcb   $01
         fcb   $E6 f
         fcb   $02
         fcb   $02
         fcb   $02
         fcb   $1D
         fcb   $02
         fcb   $31 1
         fcb   $02
         fcb   $46 F
         fcb   $02
         fcb   $53 S
         fcb   $02
         fcb   $65 e
         fcb   $02
         fcb   $75 u
         fcb   $02
         fcb   $89
         fcb   $02
         fcb   $A6 &
         fcb   $02
         fcb   $B4 4
         fcb   $02
         fcb   $C4 D
         fcb   $02
         fcb   $E0 `
         fcb   $04
         fcb   $02
         fcb   $04
         fcb   $02
         fcb   $04
         fcb   $02
         fcb   $04
         fcb   $02
         fcb   $04
         fcb   $02
         fcb   $02
         fcb   $F7 w
         fcb   $03
         fcb   $11
         fcb   $03
         fcb   $2D -
         fcb   $03
         fcb   $3C <
         fcb   $03
         fcb   $4C L
         fcb   $03
         fcb   $58 X
         fcb   $03
         fcb   $65 e
         fcb   $03
         fcb   $77 w
         fcb   $03
         fcb   $83
         fcb   $03
         fcb   $8F
         fcb   $03
         fcb   $AB +
         fcb   $03
         fcb   $B8 8
         fcb   $03
         fcb   $D1 Q
         fcb   $03
         fcb   $E6 f
         fcb   $04
         fcb   $02
         fcb   $00
         fcb   $00
         fcb   $02
         fcb   $7D
         fcb   $14
         fcb   $D3 S
         fcb   $08
         fcb   $90
         fcb   $04
         fcb   $D9 Y
         fcb   $09
         fcb   $C0 @
         fcb   $08
         fcb   $FE
         fcb   $07
         fcb   $5F _
         fcb   $0E
         fcb   $7F
         fcb   $06
         fcb   $FC
         fcb   $0D
         fcb   $08
         fcb   $04
         fcb   $8F
         fcb   $06
         fcb   $7F
         fcb   $0B
         fcb   $56 V
         fcb   $10
         fcb   $4A J
         fcb   $16
         fcb   $9C
         fcb   $0F
         fcb   $37 7
         fcb   $0F
         fcb   $E6 f
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $13
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $4C L
         fcb   $20
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $15
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $4C L
         fcb   $20
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $16
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $4C L
         fcb   $20
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $18
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $4C L
         fcb   $20
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $1A
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $4C L
         fcb   $20
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $1C
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $4C L
         fcb   $20
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $1D
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $4C L
         fcb   $20
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $1E
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $4C L
         fcb   $20
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $20
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $4C L
         fcb   $20
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $22 "
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $4C L
         fcb   $20
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $23 #
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $4C L
         fcb   $20
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $24 $
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $4C L
         fcb   $20
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $26 &
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $4C L
         fcb   $20
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $27 '
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $4C L
         fcb   $20
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $28 (
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
         fcb   $09
         fcb   $80
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $83
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $09
         fcb   $82
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $83
         fcb   $4C L
         fcb   $20
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
         fcb   $20
         fcb   $08
         fcb   $48 H
         fcb   $01
         fcb   $29 )
         fcb   $02
         fcb   $08
         fcb   $88
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $41 A
         fcb   $0D
         fcb   $09
         fcb   $40 @
         fcb   $01
         fcb   $04
         fcb   $09
         fcb   $83
         fcb   $48 H
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $87
         fcb   $09
         fcb   $43 C
         fcb   $01
         fcb   $02
