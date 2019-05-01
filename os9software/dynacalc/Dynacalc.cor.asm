 ifp1
 use dynacalc.asm
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
M00B0    fcb   $1B,$41,$06,$0F    Cyrsor XY
         fcb   $FF,$00,$00,$00
M00B8    fcb   $1B,$42,$FF,$00,$00,$00    Cursor clear to EOL
M00BE    fcb   $1B,$4A,$FF,$00,$00,$00    Cursor clear to end of screen
M00C4    fcb   $1B,$46,$FF,$00    Reverse on
         fcb   $00,$00,$00,$00
M00CC    fcb   $1B,$47,$FF,$00    Reverse off
M00D0    fcb   $00,$00,$00,$00
         fcb   $08,$20,$08,$FF,$00,$00  Destructive backspace
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
M0100    fcb   $0C     Up-arrow
         fcb   $0A     Down-arrow
         fcb   $18     Left-arrow
         fcb   $09     Right-arrow
         fcb   $1C     Home key
         fcb   $19     Jump window (Ctrl-Y)
M0106    fcb   $07   Bell character
         fcb   $1A   Get address (Ctrl-Z)
         fcb   $03   Flush type-ahead buffer (Ctrl-C)
         fcb   $08   Backspace key
         fcb   $00   direct cursor addressing row offset
         fcb   $00   direct cursor addressing columns offset
M010C    fcb   $02
         fcb   24   number of rows on screen
         fcb   50  number of columns on screen
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
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $64 d
         fcb   $6F o
         fcb   $6C l
         fcb   $6C l
         fcb   $61 a
         fcb   $72 r
         fcb   $20
         fcb   $72 r
         fcb   $61 a
         fcb   $74 t
         fcb   $65 e
         fcb   $20
         fcb   $3D =
         fcb   $18
         fcb   $30 0
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $64 d
         fcb   $75 u
         fcb   $74 t
         fcb   $79 y
         fcb   $20
         fcb   $3D =
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
         fcb   $32 2
         fcb   $77 w
         fcb   $69 i
         fcb   $74 t
         fcb   $68 h
         fcb   $20
         fcb   $73 s
         fcb   $6F o
         fcb   $75 u
         fcb   $72 r
         fcb   $63 c
         fcb   $65 e
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
         fcb   $32 2
         fcb   $2B +
         fcb   $20
         fcb   $5A Z
         fcb   $38 8
         fcb   $30 0
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
         fcb   $12
         fcb   $32 2
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
         fcb   $20
         fcb   $64 d
         fcb   $65 e
         fcb   $76 v
         fcb   $65 e
         fcb   $6C l
         fcb   $6F o
         fcb   $70 p
         fcb   $6D m
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $70 p
         fcb   $61 a
         fcb   $63 c
         fcb   $6B k
         fcb   $61 a
         fcb   $67 g
         fcb   $65 e
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
         fcb   $42 B
         fcb   $45 E
         fcb   $52 R
         fcb   $20
         fcb   $06
         fcb   $30 0
         fcb   $49 I
         fcb   $53 S
         fcb   $43 C
         fcb   $4F O
         fcb   $06
         fcb   $30 0
         fcb   $20
         fcb   $20
         fcb   $33 3
         fcb   $20
         fcb   $05
         fcb   $30 0
         fcb   $20
         fcb   $20
         fcb   $39 9
         fcb   $05
         fcb   $30 0
         fcb   $20
         fcb   $34 4
         fcb   $39 9

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
         fcb   $0A
         fcb   $A0
         fcb   $20
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $85
         fcb   $0A
         fcb   $A0
         fcb   $0C
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $86
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

M0608    ldy   #$004E
         leax  >M0629,pcr
         lda   #$02
         os9   I$Write
         fcb   $4F
         fcb   $30
         fcb   $8D
         fcb   $00
         fcb   $0F
         fcb   $10
         fcb   $8E
         fcb   $00
         fcb   $01
         fcb   $10
         fcb   $3F
         fcb   $89
         fcb   $EE
         fcb   $8D
         fcb   $FF
         fcb   $50
         fcb   $6E
         fcb   $C9
         fcb   $3A
         fcb   $D5

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
         leau  >M0CEB,pcr  Calendar months
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

M0CEB    fcc   "  January"
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

         fcb   $AD -
         fcb   $A9 )
         fcb   $1A
         fcb   $A4 $
         fcb   $AD -
         fcb   $A9 )
         fcb   $08
         fcb   $EF o
         fcb   $81
         fcb   $59 Y
         fcb   $27 '
         fcb   $04
         fcb   $6E n
         fcb   $A9 )
         fcb   $1A
         fcb   $89
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
         fcb   $4E N
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
         fcb   $7D
         fcb   $44 D
         fcb   $56 V
         fcb   $06
         fcb   $7D
         fcb   $DD ]
         fcb   $6C l
         fcb   $35 5
         fcb   $50 P
         fcb   $6E n
         fcb   $A9 )
         fcb   $3A :
         fcb   $E1 a

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
         lbsr  M1042
         lda   #$0A


         fcb   $AD -
         fcb   $A9 )
         fcb   $09
         fcb   $25 %
         fcb   $30 0
         fcb   $8D
         fcb   $1D
         fcb   $1B
         fcb   $D6 V
         fcb   $25 %
         fcb   $3A :
         fcb   $EC l
         fcb   $84
         fcb   $33 3
         fcb   $8D
         fcb   $00
         fcb   $C0 @
         fcb   $33 3
         fcb   $CB K
         fcb   $A6 &
         fcb   $C0 @
         fcb   $27 '
         fcb   $33 3
         fcb   $81
         fcb   $11
         fcb   $26 &
         fcb   $23 #
         fcb   $AD -
         fcb   $A9 )
         fcb   $3A :
         fcb   $DE ^
         fcb   $AD -
         fcb   $A9 )
         fcb   $09
         fcb   $01
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
         fcb   $08
         fcb   $EF o
         fcb   $35 5
         fcb   $02
         fcb   $81
         fcb   $1B
         fcb   $27 '
         fcb   $47 G
         fcb   $34 4
         fcb   $40 @
         fcb   $8D
         fcb   $68 h
         fcb   $35 5
         fcb   $40 @
         fcb   $20
         fcb   $08
         fcb   $AD -
         fcb   $A9 )
         fcb   $09
         fcb   $25 %
         fcb   $81
         fcb   $0D
         fcb   $26 &
         fcb   $CD M
         fcb   $86
         fcb   $0A
         fcb   $20
         fcb   $F4 t
         fcb   $AD -
         fcb   $A9 )
         fcb   $3A :
         fcb   $DE ^
         fcb   $AD -
         fcb   $A9 )
         fcb   $09
         fcb   $01
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
         fcb   $08
         fcb   $EF o
         fcb   $20
         fcb   $88
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
         fcb   $1A
         fcb   $BC <
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
         fcb   $08
         fcb   $B9 9
         fcb   $AD -
         fcb   $A9 )
         fcb   $3A :
         fcb   $DE ^
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
M1042    fcb   $6E n
         fcb   $A9 )
         fcb   $09
         fcb   $1C
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
         fcb   $1A
         fcb   $8C
         fcb   $D6 V
         fcb   $25 %
         fcb   $30 0
         fcb   $8D
         fcb   $1C
         fcb   $7B
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
         fcb   $18
         fcb   $55 U
         fcb   $33 3
         fcb   $CB K
         fcb   $AD -
         fcb   $A9 )
         fcb   $3F ?
         fcb   $AE .
         fcb   $39 9
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
         fcb   $44 D
         fcb   $20
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $67 g
         fcb   $67 g
         fcb   $6C l
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $44 D
         fcb   $65 e
         fcb   $67 g
         fcb   $72 r
         fcb   $65 e
         fcb   $65 e
         fcb   $2F /
         fcb   $72 r
         fcb   $61 a
         fcb   $64 d
         fcb   $69 i
         fcb   $61 a
         fcb   $6E n
         fcb   $20
         fcb   $6D m
         fcb   $6F o
         fcb   $64 d
         fcb   $65 e
         fcb   $20
         fcb   $28 (
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $20
         fcb   $3D =
         fcb   $20
         fcb   $64 d
         fcb   $65 e
         fcb   $67 g
         fcb   $72 r
         fcb   $65 e
         fcb   $65 e
         fcb   $73 s
         fcb   $29 )
         fcb   $0D
         fcb   $47 G
         fcb   $20
         fcb   $20
         fcb   $61 a
         fcb   $6C l
         fcb   $6C l
         fcb   $6F o
         fcb   $77 w
         fcb   $73 s
         fcb   $20
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $20
         fcb   $47 G
         fcb   $72 r
         fcb   $61 a
         fcb   $70 p
         fcb   $68 h
         fcb   $20
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $72 r
         fcb   $61 a
         fcb   $63 c
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $28 (
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $20
         fcb   $3D =
         fcb   $20
         fcb   $23 #
         fcb   $29 )
         fcb   $0D
         fcb   $48 H
         fcb   $20
         fcb   $20
         fcb   $64 d
         fcb   $65 e
         fcb   $6C l
         fcb   $65 e
         fcb   $74 t
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $48 H
         fcb   $65 e
         fcb   $6C l
         fcb   $70 p
         fcb   $20
         fcb   $6D m
         fcb   $65 e
         fcb   $73 s
         fcb   $73 s
         fcb   $61 a
         fcb   $67 g
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $26 &
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $63 c
         fcb   $72 r
         fcb   $65 e
         fcb   $61 a
         fcb   $73 s
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $75 u
         fcb   $73 s
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $73 s
         fcb   $70 p
         fcb   $61 a
         fcb   $63 c
         fcb   $65 e
         fcb   $0D
         fcb   $4C L
         fcb   $20
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $67 g
         fcb   $67 g
         fcb   $6C l
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $4C L
         fcb   $61 a
         fcb   $62 b
         fcb   $65 e
         fcb   $6C l
         fcb   $20
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $72 r
         fcb   $79 y
         fcb   $20
         fcb   $6D m
         fcb   $6F o
         fcb   $64 d
         fcb   $65 e
         fcb   $20
         fcb   $66 f
         fcb   $6C l
         fcb   $61 a
         fcb   $67 g
         fcb   $20
         fcb   $28 (
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $20
         fcb   $3D =
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $66 f
         fcb   $29 )
         fcb   $0D
         fcb   $4D M
         fcb   $20
         fcb   $20
         fcb   $72 r
         fcb   $65 e
         fcb   $2D -
         fcb   $77 w
         fcb   $72 r
         fcb   $69 i
         fcb   $74 t
         fcb   $65 e
         fcb   $20
         fcb   $28 (
         fcb   $4D M
         fcb   $6F o
         fcb   $64 d
         fcb   $69 i
         fcb   $66 f
         fcb   $79 y
         fcb   $29 )
         fcb   $20
         fcb   $73 s
         fcb   $63 c
         fcb   $72 r
         fcb   $65 e
         fcb   $65 e
         fcb   $6E n
         fcb   $0D
         fcb   $4F O
         fcb   $20
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $67 g
         fcb   $67 g
         fcb   $6C l
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $43 C
         fcb   $6F o
         fcb   $6C l
         fcb   $75 u
         fcb   $6D m
         fcb   $6E n
         fcb   $2F /
         fcb   $52 R
         fcb   $6F o
         fcb   $77 w
         fcb   $20
         fcb   $63 c
         fcb   $61 a
         fcb   $6C l
         fcb   $63 c
         fcb   $20
         fcb   $4F O
         fcb   $72 r
         fcb   $64 d
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $28 (
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $20
         fcb   $3D =
         fcb   $20
         fcb   $43 C
         fcb   $29 )
         fcb   $0D
         fcb   $50 P
         fcb   $20
         fcb   $20
         fcb   $61 a
         fcb   $6C l
         fcb   $6C l
         fcb   $6F o
         fcb   $77 w
         fcb   $73 s
         fcb   $20
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $20
         fcb   $50 P
         fcb   $72 r
         fcb   $69 i
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $2F /
         fcb   $74 t
         fcb   $65 e
         fcb   $78 x
         fcb   $74 t
         fcb   $66 f
         fcb   $69 i
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $70 p
         fcb   $61 a
         fcb   $72 r
         fcb   $61 a
         fcb   $6D m
         fcb   $65 e
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $73 s
         fcb   $0D
         fcb   $52 R
         fcb   $20
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $67 g
         fcb   $67 g
         fcb   $6C l
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $41 A
         fcb   $75 u
         fcb   $74 t
         fcb   $6F o
         fcb   $2F /
         fcb   $4D M
         fcb   $61 a
         fcb   $6E n
         fcb   $75 u
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $52 R
         fcb   $65 e
         fcb   $63 c
         fcb   $61 a
         fcb   $6C l
         fcb   $63 c
         fcb   $75 u
         fcb   $6C l
         fcb   $61 a
         fcb   $74 t
         fcb   $65 e
         fcb   $20
         fcb   $28 (
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $20
         fcb   $3D =
         fcb   $20
         fcb   $41 A
         fcb   $29 )
         fcb   $0D
         fcb   $53 S
         fcb   $20
         fcb   $20
         fcb   $72 r
         fcb   $65 e
         fcb   $70 p
         fcb   $6F o
         fcb   $72 r
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $53 S
         fcb   $69 i
         fcb   $7A z
         fcb   $65 e
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $77 w
         fcb   $6F o
         fcb   $72 r
         fcb   $6B k
         fcb   $73 s
         fcb   $68 h
         fcb   $65 e
         fcb   $65 e
         fcb   $74 t
         fcb   $0D
         fcb   $54 T
         fcb   $20
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $67 g
         fcb   $67 g
         fcb   $6C l
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $54 T
         fcb   $79 y
         fcb   $70 p
         fcb   $65 e
         fcb   $20
         fcb   $70 p
         fcb   $72 r
         fcb   $6F o
         fcb   $74 t
         fcb   $65 e
         fcb   $63 c
         fcb   $74 t
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $20
         fcb   $28 (
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $20
         fcb   $3D =
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $66 f
         fcb   $29 )
         fcb   $0D
         fcb   $57 W
         fcb   $20
         fcb   $20
         fcb   $61 a
         fcb   $6C l
         fcb   $6C l
         fcb   $6F o
         fcb   $77 w
         fcb   $73 s
         fcb   $20
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $20
         fcb   $63 c
         fcb   $6F o
         fcb   $6C l
         fcb   $75 u
         fcb   $6D m
         fcb   $6E n
         fcb   $20
         fcb   $57 W
         fcb   $69 i
         fcb   $64 d
         fcb   $74 t
         fcb   $68 h
         fcb   $28 (
         fcb   $73 s
         fcb   $29 )
         fcb   $0D
         fcb   $00
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcb   $44 D
         fcb   $65 e
         fcb   $6C l
         fcb   $65 e
         fcb   $74 t
         fcb   $65 e
         fcb   $20
         fcb   $63 c
         fcb   $6F o
         fcb   $6C l
         fcb   $75 u
         fcb   $6D m
         fcb   $6E n
         fcb   $2F /
         fcb   $72 r
         fcb   $6F o
         fcb   $77 w
         fcb   $3A :
         fcb   $0D
         fcb   $0A
         fcb   $43 C
         fcb   $20
         fcb   $20
         fcb   $64 d
         fcb   $65 e
         fcb   $6C l
         fcb   $65 e
         fcb   $74 t
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $43 C
         fcb   $6F o
         fcb   $6C l
         fcb   $75 u
         fcb   $6D m
         fcb   $6E n
         fcb   $0D
         fcb   $52 R
         fcb   $20
         fcb   $20
         fcb   $64 d
         fcb   $65 e
         fcb   $6C l
         fcb   $65 e
         fcb   $74 t
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $52 R
         fcb   $6F o
         fcb   $77 w
         fcb   $0D
         fcb   $00
         fcb   $53 S
         fcb   $65 e
         fcb   $74 t
         fcb   $20
         fcb   $46 F
         fcb   $6F o
         fcb   $72 r
         fcb   $6D m
         fcb   $61 a
         fcb   $74 t
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $3A :
         fcb   $0D
         fcb   $0A
         fcb   $43 C
         fcb   $20
         fcb   $20
         fcb   $43 C
         fcb   $6F o
         fcb   $6E n
         fcb   $74 t
         fcb   $69 i
         fcb   $6E n
         fcb   $75 u
         fcb   $6F o
         fcb   $75 u
         fcb   $73 s
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $72 r
         fcb   $61 a
         fcb   $63 c
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $73 s
         fcb   $20
         fcb   $72 r
         fcb   $65 e
         fcb   $70 p
         fcb   $65 e
         fcb   $61 a
         fcb   $74 t
         fcb   $65 e
         fcb   $64 d
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $74 t
         fcb   $68 h
         fcb   $72 r
         fcb   $6F o
         fcb   $75 u
         fcb   $67 g
         fcb   $68 h
         fcb   $6F o
         fcb   $75 u
         fcb   $74 t
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $0D
         fcb   $44 D
         fcb   $20
         fcb   $20
         fcb   $44 D
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $75 u
         fcb   $73 s
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $77 w
         fcb   $69 i
         fcb   $6E n
         fcb   $64 d
         fcb   $6F o
         fcb   $77 w
         fcb   $20
         fcb   $66 f
         fcb   $6F o
         fcb   $72 r
         fcb   $6D m
         fcb   $61 a
         fcb   $74 t
         fcb   $0D
         fcb   $47 G
         fcb   $20
         fcb   $20
         fcb   $47 G
         fcb   $65 e
         fcb   $6E n
         fcb   $65 e
         fcb   $72 r
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $6C l
         fcb   $61 a
         fcb   $62 b
         fcb   $65 e
         fcb   $6C l
         fcb   $73 s
         fcb   $20
         fcb   $6C l
         fcb   $65 e
         fcb   $66 f
         fcb   $74 t
         fcb   $2C ,
         fcb   $20
         fcb   $6E n
         fcb   $75 u
         fcb   $6D m
         fcb   $62 b
         fcb   $65 e
         fcb   $72 r
         fcb   $73 s
         fcb   $20
         fcb   $72 r
         fcb   $69 i
         fcb   $67 g
         fcb   $68 h
         fcb   $74 t
         fcb   $0D
         fcb   $49 I
         fcb   $20
         fcb   $20
         fcb   $49 I
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $67 g
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $72 r
         fcb   $6F o
         fcb   $75 u
         fcb   $6E n
         fcb   $64 d
         fcb   $73 s
         fcb   $20
         fcb   $44 D
         fcb   $49 I
         fcb   $53 S
         fcb   $50 P
         fcb   $4C L
         fcb   $41 A
         fcb   $59 Y
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $6E n
         fcb   $65 e
         fcb   $61 a
         fcb   $72 r
         fcb   $65 e
         fcb   $73 s
         fcb   $74 t
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $67 g
         fcb   $65 e
         fcb   $72 r
         fcb   $0D
         fcb   $4C L
         fcb   $20
         fcb   $20
         fcb   $4C L
         fcb   $65 e
         fcb   $66 f
         fcb   $74 t
         fcb   $20
         fcb   $6A j
         fcb   $75 u
         fcb   $73 s
         fcb   $74 t
         fcb   $69 i
         fcb   $66 f
         fcb   $79 y
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $66 f
         fcb   $6F o
         fcb   $72 r
         fcb   $63 c
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $6E n
         fcb   $75 u
         fcb   $6D m
         fcb   $62 b
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $6C l
         fcb   $65 e
         fcb   $66 f
         fcb   $74 t
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $0D
         fcb   $50 P
         fcb   $20
         fcb   $20
         fcb   $50 P
         fcb   $6C l
         fcb   $6F o
         fcb   $74 t
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $75 u
         fcb   $73 s
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $27 '
         fcb   $73 s
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $67 g
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $76 v
         fcb   $61 a
         fcb   $6C l
         fcb   $75 u
         fcb   $65 e
         fcb   $20
         fcb   $61 a
         fcb   $73 s
         fcb   $20
         fcb   $6E n
         fcb   $75 u
         fcb   $6D m
         fcb   $62 b
         fcb   $65 e
         fcb   $72 r
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $67 g
         fcb   $72 r
         fcb   $61 a
         fcb   $70 p
         fcb   $68 h
         fcb   $20
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $72 r
         fcb   $61 a
         fcb   $63 c
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $73 s
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $70 p
         fcb   $72 r
         fcb   $69 i
         fcb   $6E n
         fcb   $74 t
         fcb   $0D
         fcb   $52 R
         fcb   $20
         fcb   $20
         fcb   $52 R
         fcb   $69 i
         fcb   $67 g
         fcb   $68 h
         fcb   $74 t
         fcb   $20
         fcb   $6A j
         fcb   $75 u
         fcb   $73 s
         fcb   $74 t
         fcb   $69 i
         fcb   $66 f
         fcb   $79 y
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $66 f
         fcb   $6F o
         fcb   $72 r
         fcb   $63 c
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $6C l
         fcb   $61 a
         fcb   $62 b
         fcb   $65 e
         fcb   $6C l
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $72 r
         fcb   $69 i
         fcb   $67 g
         fcb   $68 h
         fcb   $74 t
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $0D
         fcb   $24 $
         fcb   $20
         fcb   $20
         fcb   $4D M
         fcb   $6F o
         fcb   $6E n
         fcb   $65 e
         fcb   $79 y
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $72 r
         fcb   $6F o
         fcb   $75 u
         fcb   $6E n
         fcb   $64 d
         fcb   $73 s
         fcb   $20
         fcb   $44 D
         fcb   $49 I
         fcb   $53 S
         fcb   $50 P
         fcb   $4C L
         fcb   $41 A
         fcb   $59 Y
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $6E n
         fcb   $65 e
         fcb   $61 a
         fcb   $72 r
         fcb   $65 e
         fcb   $73 s
         fcb   $74 t
         fcb   $20
         fcb   $70 p
         fcb   $65 e
         fcb   $6E n
         fcb   $6E n
         fcb   $79 y
         fcb   $0D
         fcb   $00
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcb   $49 I
         fcb   $6E n
         fcb   $73 s
         fcb   $65 e
         fcb   $72 r
         fcb   $74 t
         fcb   $20
         fcb   $6E n
         fcb   $65 e
         fcb   $77 w
         fcb   $20
         fcb   $63 c
         fcb   $6F o
         fcb   $6C l
         fcb   $75 u
         fcb   $6D m
         fcb   $6E n
         fcb   $20
         fcb   $6F o
         fcb   $72 r
         fcb   $20
         fcb   $72 r
         fcb   $6F o
         fcb   $77 w
         fcb   $3A :
         fcb   $0D
         fcb   $0A
         fcb   $43 C
         fcb   $20
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $73 s
         fcb   $65 e
         fcb   $72 r
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $6E n
         fcb   $65 e
         fcb   $77 w
         fcb   $20
         fcb   $62 b
         fcb   $6C l
         fcb   $61 a
         fcb   $6E n
         fcb   $6B k
         fcb   $20
         fcb   $43 C
         fcb   $6F o
         fcb   $6C l
         fcb   $75 u
         fcb   $6D m
         fcb   $6E n
         fcb   $20
         fcb   $61 a
         fcb   $74 t
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $70 p
         fcb   $6F o
         fcb   $73 s
         fcb   $69 i
         fcb   $74 t
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $0D
         fcb   $52 R
         fcb   $20
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $73 s
         fcb   $65 e
         fcb   $72 r
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $6E n
         fcb   $65 e
         fcb   $77 w
         fcb   $20
         fcb   $62 b
         fcb   $6C l
         fcb   $61 a
         fcb   $6E n
         fcb   $6B k
         fcb   $20
         fcb   $52 R
         fcb   $6F o
         fcb   $77 w
         fcb   $20
         fcb   $61 a
         fcb   $74 t
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $70 p
         fcb   $6F o
         fcb   $73 s
         fcb   $69 i
         fcb   $74 t
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $0D
         fcb   $00
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcb   $51 Q
         fcb   $75 u
         fcb   $69 i
         fcb   $74 t
         fcb   $3A :
         fcb   $0D
         fcb   $0A
         fcb   $4F O
         fcb   $20
         fcb   $20
         fcb   $6C l
         fcb   $65 e
         fcb   $61 a
         fcb   $76 v
         fcb   $65 e
         fcb   $20
         fcb   $44 D
         fcb   $59 Y
         fcb   $4E N
         fcb   $41 A
         fcb   $43 C
         fcb   $41 A
         fcb   $4C L
         fcb   $43 C
         fcb   $20
         fcb   $61 a
         fcb   $6E n
         fcb   $64 d
         fcb   $20
         fcb   $72 r
         fcb   $65 e
         fcb   $74 t
         fcb   $75 u
         fcb   $72 r
         fcb   $6E n
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $4F O
         fcb   $53 S
         fcb   $2D -
         fcb   $39 9
         fcb   $0D
         fcb   $53 S
         fcb   $20
         fcb   $20
         fcb   $70 p
         fcb   $75 u
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $63 c
         fcb   $6F o
         fcb   $6D m
         fcb   $70 p
         fcb   $75 u
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $53 S
         fcb   $6C l
         fcb   $65 e
         fcb   $65 e
         fcb   $70 p
         fcb   $20
         fcb   $75 u
         fcb   $6E n
         fcb   $74 t
         fcb   $69 i
         fcb   $6C l
         fcb   $20
         fcb   $61 a
         fcb   $6E n
         fcb   $79 y
         fcb   $20
         fcb   $6B k
         fcb   $65 e
         fcb   $79 y
         fcb   $20
         fcb   $69 i
         fcb   $73 s
         fcb   $20
         fcb   $73 s
         fcb   $74 t
         fcb   $72 r
         fcb   $75 u
         fcb   $63 c
         fcb   $6B k
         fcb   $0D
         fcb   $00
         fcb   $53 S
         fcb   $79 y
         fcb   $73 s
         fcb   $74 t
         fcb   $65 e
         fcb   $6D m
         fcb   $3A :
         fcb   $0D
         fcb   $0A
         fcb   $43 C
         fcb   $20
         fcb   $20
         fcb   $43 C
         fcb   $68 h
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $65 e
         fcb   $20
         fcb   $74 t
         fcb   $68 h
         fcb   $65 e
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $64 d
         fcb   $69 i
         fcb   $72 r
         fcb   $65 e
         fcb   $63 c
         fcb   $74 t
         fcb   $6F o
         fcb   $72 r
         fcb   $79 y
         fcb   $0D
         fcb   $4C L
         fcb   $20
         fcb   $20
         fcb   $4C L
         fcb   $6F o
         fcb   $61 a
         fcb   $64 d
         fcb   $20
         fcb   $77 w
         fcb   $6F o
         fcb   $72 r
         fcb   $6B k
         fcb   $73 s
         fcb   $68 h
         fcb   $65 e
         fcb   $65 e
         fcb   $74 t
         fcb   $20
         fcb   $66 f
         fcb   $72 r
         fcb   $6F o
         fcb   $6D m
         fcb   $20
         fcb   $64 d
         fcb   $69 i
         fcb   $73 s
         fcb   $6B k
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $6F o
         fcb   $76 v
         fcb   $65 e
         fcb   $72 r
         fcb   $6C l
         fcb   $61 a
         fcb   $79 y
         fcb   $73 s
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $73 s
         fcb   $68 h
         fcb   $65 e
         fcb   $65 e
         fcb   $74 t
         fcb   $0D
         fcb   $53 S
         fcb   $20
         fcb   $20
         fcb   $53 S
         fcb   $61 a
         fcb   $76 v
         fcb   $65 e
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $77 w
         fcb   $6F o
         fcb   $72 r
         fcb   $6B k
         fcb   $73 s
         fcb   $68 h
         fcb   $65 e
         fcb   $65 e
         fcb   $74 t
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $64 d
         fcb   $69 i
         fcb   $73 s
         fcb   $6B k
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $53 S
         fcb   $61 a
         fcb   $76 v
         fcb   $65 e
         fcb   $20
         fcb   $61 a
         fcb   $6E n
         fcb   $64 d
         fcb   $20
         fcb   $4C L
         fcb   $6F o
         fcb   $61 a
         fcb   $64 d
         fcb   $20
         fcb   $62 b
         fcb   $6F o
         fcb   $74 t
         fcb   $68 h
         fcb   $20
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $2E .
         fcb   $63 c
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $64 d
         fcb   $69 i
         fcb   $72 r
         fcb   $65 e
         fcb   $63 c
         fcb   $74 t
         fcb   $6F o
         fcb   $72 r
         fcb   $79 y
         fcb   $0D
         fcb   $0A
         fcb   $58 X
         fcb   $20
         fcb   $20
         fcb   $65 e
         fcb   $58 X
         fcb   $65 e
         fcb   $63 c
         fcb   $75 u
         fcb   $74 t
         fcb   $65 e
         fcb   $20
         fcb   $4F O
         fcb   $53 S
         fcb   $2D -
         fcb   $39 9
         fcb   $20
         fcb   $63 c
         fcb   $6F o
         fcb   $6D m
         fcb   $6D m
         fcb   $61 a
         fcb   $6E n
         fcb   $64 d
         fcb   $0D
         fcb   $0A
         fcb   $23 #
         fcb   $20
         fcb   $20
         fcb   $64 d
         fcb   $61 a
         fcb   $74 t
         fcb   $61 a
         fcb   $20
         fcb   $66 f
         fcb   $69 i
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $73 s
         fcb   $61 a
         fcb   $76 v
         fcb   $65 e
         fcb   $2F /
         fcb   $6C l
         fcb   $6F o
         fcb   $61 a
         fcb   $64 d
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $66 f
         fcb   $6F o
         fcb   $72 r
         fcb   $20
         fcb   $64 d
         fcb   $61 a
         fcb   $74 t
         fcb   $61 a
         fcb   $20
         fcb   $65 e
         fcb   $78 x
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $65 e
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $62 b
         fcb   $6F o
         fcb   $74 t
         fcb   $68 h
         fcb   $20
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $74 t
         fcb   $68 h
         fcb   $65 e
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $64 d
         fcb   $69 i
         fcb   $72 r
         fcb   $65 e
         fcb   $63 c
         fcb   $74 t
         fcb   $6F o
         fcb   $72 r
         fcb   $79 y
         fcb   $0D
         fcb   $00
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcb   $53 S
         fcb   $61 a
         fcb   $76 v
         fcb   $65 e
         fcb   $20
         fcb   $64 d
         fcb   $61 a
         fcb   $74 t
         fcb   $61 a
         fcb   $3A :
         fcb   $0D
         fcb   $0A
         fcb   $4C L
         fcb   $20
         fcb   $20
         fcb   $4C L
         fcb   $6F o
         fcb   $61 a
         fcb   $64 d
         fcb   $20
         fcb   $6C l
         fcb   $61 a
         fcb   $62 b
         fcb   $65 e
         fcb   $6C l
         fcb   $73 s
         fcb   $20
         fcb   $61 a
         fcb   $6E n
         fcb   $64 d
         fcb   $20
         fcb   $43 C
         fcb   $41 A
         fcb   $4C L
         fcb   $43 C
         fcb   $55 U
         fcb   $4C L
         fcb   $41 A
         fcb   $54 T
         fcb   $45 E
         fcb   $44 D
         fcb   $20
         fcb   $56 V
         fcb   $61 a
         fcb   $6C l
         fcb   $75 u
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $66 f
         fcb   $72 r
         fcb   $6F o
         fcb   $6D m
         fcb   $20
         fcb   $64 d
         fcb   $69 i
         fcb   $73 s
         fcb   $6B k
         fcb   $0D
         fcb   $0A
         fcb   $53 S
         fcb   $20
         fcb   $20
         fcb   $53 S
         fcb   $61 a
         fcb   $76 v
         fcb   $65 e
         fcb   $20
         fcb   $6C l
         fcb   $61 a
         fcb   $62 b
         fcb   $65 e
         fcb   $6C l
         fcb   $73 s
         fcb   $20
         fcb   $61 a
         fcb   $6E n
         fcb   $64 d
         fcb   $20
         fcb   $43 C
         fcb   $41 A
         fcb   $4C L
         fcb   $43 C
         fcb   $55 U
         fcb   $4C L
         fcb   $41 A
         fcb   $54 T
         fcb   $45 E
         fcb   $44 D
         fcb   $20
         fcb   $56 V
         fcb   $61 a
         fcb   $6C l
         fcb   $75 u
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $64 d
         fcb   $69 i
         fcb   $73 s
         fcb   $6B k
         fcb   $0D
         fcb   $00
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcb   $54 T
         fcb   $69 i
         fcb   $74 t
         fcb   $6C l
         fcb   $65 e
         fcb   $73 s
         fcb   $3A :
         fcb   $0D
         fcb   $0A
         fcb   $42 B
         fcb   $20
         fcb   $20
         fcb   $73 s
         fcb   $65 e
         fcb   $74 t
         fcb   $20
         fcb   $75 u
         fcb   $70 p
         fcb   $20
         fcb   $42 B
         fcb   $6F o
         fcb   $74 t
         fcb   $68 h
         fcb   $20
         fcb   $68 h
         fcb   $6F o
         fcb   $72 r
         fcb   $69 i
         fcb   $7A z
         fcb   $6F o
         fcb   $6E n
         fcb   $74 t
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $61 a
         fcb   $6E n
         fcb   $64 d
         fcb   $20
         fcb   $76 v
         fcb   $65 e
         fcb   $72 r
         fcb   $74 t
         fcb   $69 i
         fcb   $63 c
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $74 t
         fcb   $69 i
         fcb   $74 t
         fcb   $6C l
         fcb   $65 e
         fcb   $73 s
         fcb   $0D
         fcb   $48 H
         fcb   $20
         fcb   $20
         fcb   $73 s
         fcb   $65 e
         fcb   $74 t
         fcb   $20
         fcb   $75 u
         fcb   $70 p
         fcb   $20
         fcb   $72 r
         fcb   $6F o
         fcb   $77 w
         fcb   $28 (
         fcb   $73 s
         fcb   $29 )
         fcb   $20
         fcb   $61 a
         fcb   $62 b
         fcb   $6F o
         fcb   $76 v
         fcb   $65 e
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $73 s
         fcb   $6F o
         fcb   $72 r
         fcb   $20
         fcb   $61 a
         fcb   $73 s
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $48 H
         fcb   $6F o
         fcb   $72 r
         fcb   $69 i
         fcb   $7A z
         fcb   $6F o
         fcb   $6E n
         fcb   $74 t
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $74 t
         fcb   $69 i
         fcb   $74 t
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $61 a
         fcb   $72 r
         fcb   $65 e
         fcb   $61 a
         fcb   $0D
         fcb   $4E N
         fcb   $20
         fcb   $20
         fcb   $4E N
         fcb   $6F o
         fcb   $20
         fcb   $74 t
         fcb   $69 i
         fcb   $74 t
         fcb   $6C l
         fcb   $65 e
         fcb   $73 s
         fcb   $0D
         fcb   $56 V
         fcb   $20
         fcb   $20
         fcb   $73 s
         fcb   $65 e
         fcb   $74 t
         fcb   $20
         fcb   $75 u
         fcb   $70 p
         fcb   $20
         fcb   $63 c
         fcb   $6F o
         fcb   $6C l
         fcb   $75 u
         fcb   $6D m
         fcb   $6E n
         fcb   $28 (
         fcb   $73 s
         fcb   $29 )
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $6C l
         fcb   $65 e
         fcb   $66 f
         fcb   $74 t
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $73 s
         fcb   $6F o
         fcb   $72 r
         fcb   $20
         fcb   $61 a
         fcb   $73 s
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $56 V
         fcb   $65 e
         fcb   $72 r
         fcb   $74 t
         fcb   $69 i
         fcb   $63 c
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $74 t
         fcb   $69 i
         fcb   $74 t
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $61 a
         fcb   $72 r
         fcb   $65 e
         fcb   $61 a
         fcb   $0D
         fcb   $00
         fcb   $57 W
         fcb   $69 i
         fcb   $6E n
         fcb   $64 d
         fcb   $6F o
         fcb   $77 w
         fcb   $73 s
         fcb   $3A :
         fcb   $0D
         fcb   $0A
         fcb   $44 D
         fcb   $20
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $67 g
         fcb   $67 g
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $76 v
         fcb   $61 a
         fcb   $6C l
         fcb   $75 u
         fcb   $65 e
         fcb   $2F /
         fcb   $66 f
         fcb   $6F o
         fcb   $72 r
         fcb   $6D m
         fcb   $75 u
         fcb   $6C l
         fcb   $61 a
         fcb   $20
         fcb   $44 D
         fcb   $69 i
         fcb   $73 s
         fcb   $70 p
         fcb   $6C l
         fcb   $61 a
         fcb   $79 y
         fcb   $20
         fcb   $66 f
         fcb   $6C l
         fcb   $61 a
         fcb   $67 g
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $28 (
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $76 v
         fcb   $61 a
         fcb   $6C l
         fcb   $75 u
         fcb   $65 e
         fcb   $29 )
         fcb   $0D
         fcb   $46 F
         fcb   $20
         fcb   $20
         fcb   $73 s
         fcb   $65 e
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $20
         fcb   $46 F
         fcb   $6F o
         fcb   $72 r
         fcb   $6D m
         fcb   $61 a
         fcb   $74 t
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $61 a
         fcb   $6C l
         fcb   $6C l
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $73 s
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $77 w
         fcb   $69 i
         fcb   $6E n
         fcb   $64 d
         fcb   $6F o
         fcb   $77 w
         fcb   $0D
         fcb   $48 H
         fcb   $20
         fcb   $20
         fcb   $64 d
         fcb   $69 i
         fcb   $76 v
         fcb   $69 i
         fcb   $64 d
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $73 s
         fcb   $63 c
         fcb   $72 r
         fcb   $65 e
         fcb   $65 e
         fcb   $6E n
         fcb   $20
         fcb   $48 H
         fcb   $6F o
         fcb   $72 r
         fcb   $69 i
         fcb   $7A z
         fcb   $6F o
         fcb   $6E n
         fcb   $74 t
         fcb   $61 a
         fcb   $6C l
         fcb   $6C l
         fcb   $79 y
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $74 t
         fcb   $77 w
         fcb   $6F o
         fcb   $20
         fcb   $77 w
         fcb   $69 i
         fcb   $6E n
         fcb   $64 d
         fcb   $6F o
         fcb   $77 w
         fcb   $73 s
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $61 a
         fcb   $74 t
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $6C l
         fcb   $6F o
         fcb   $63 c
         fcb   $61 a
         fcb   $74 t
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $0D
         fcb   $4E N
         fcb   $20
         fcb   $20
         fcb   $4E N
         fcb   $6F o
         fcb   $20
         fcb   $64 d
         fcb   $69 i
         fcb   $76 v
         fcb   $69 i
         fcb   $73 s
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $72 r
         fcb   $65 e
         fcb   $74 t
         fcb   $75 u
         fcb   $72 r
         fcb   $6E n
         fcb   $73 s
         fcb   $20
         fcb   $64 d
         fcb   $69 i
         fcb   $73 s
         fcb   $70 p
         fcb   $6C l
         fcb   $61 a
         fcb   $79 y
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $73 s
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $77 w
         fcb   $69 i
         fcb   $6E n
         fcb   $64 d
         fcb   $6F o
         fcb   $77 w
         fcb   $0D
         fcb   $53 S
         fcb   $20
         fcb   $20
         fcb   $53 S
         fcb   $79 y
         fcb   $6E n
         fcb   $63 c
         fcb   $68 h
         fcb   $72 r
         fcb   $6F o
         fcb   $6E n
         fcb   $69 i
         fcb   $7A z
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $6D m
         fcb   $6F o
         fcb   $74 t
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $74 t
         fcb   $77 w
         fcb   $6F o
         fcb   $20
         fcb   $77 w
         fcb   $69 i
         fcb   $6E n
         fcb   $64 d
         fcb   $6F o
         fcb   $77 w
         fcb   $73 s
         fcb   $0D
         fcb   $55 U
         fcb   $20
         fcb   $20
         fcb   $55 U
         fcb   $6E n
         fcb   $73 s
         fcb   $79 y
         fcb   $6E n
         fcb   $63 c
         fcb   $68 h
         fcb   $72 r
         fcb   $6F o
         fcb   $6E n
         fcb   $69 i
         fcb   $7A z
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $6D m
         fcb   $6F o
         fcb   $74 t
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $74 t
         fcb   $77 w
         fcb   $6F o
         fcb   $20
         fcb   $77 w
         fcb   $69 i
         fcb   $6E n
         fcb   $64 d
         fcb   $6F o
         fcb   $77 w
         fcb   $73 s
         fcb   $20
         fcb   $28 (
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $29 )
         fcb   $0D
         fcb   $56 V
         fcb   $20
         fcb   $20
         fcb   $64 d
         fcb   $69 i
         fcb   $76 v
         fcb   $69 i
         fcb   $64 d
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $73 s
         fcb   $63 c
         fcb   $72 r
         fcb   $65 e
         fcb   $65 e
         fcb   $6E n
         fcb   $20
         fcb   $56 V
         fcb   $65 e
         fcb   $72 r
         fcb   $74 t
         fcb   $69 i
         fcb   $63 c
         fcb   $61 a
         fcb   $6C l
         fcb   $6C l
         fcb   $79 y
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $74 t
         fcb   $77 w
         fcb   $6F o
         fcb   $20
         fcb   $77 w
         fcb   $69 i
         fcb   $6E n
         fcb   $64 d
         fcb   $6F o
         fcb   $77 w
         fcb   $73 s
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $61 a
         fcb   $74 t
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $6C l
         fcb   $6F o
         fcb   $63 c
         fcb   $61 a
         fcb   $74 t
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $0D
         fcb   $00
         fcb   $53 S
         fcb   $65 e
         fcb   $74 t
         fcb   $20
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $20
         fcb   $66 f
         fcb   $6F o
         fcb   $72 r
         fcb   $6D m
         fcb   $61 a
         fcb   $74 t
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $77 w
         fcb   $69 i
         fcb   $6E n
         fcb   $64 d
         fcb   $6F o
         fcb   $77 w
         fcb   $3A :
         fcb   $0D
         fcb   $0A
         fcb   $43 C
         fcb   $20
         fcb   $20
         fcb   $43 C
         fcb   $6F o
         fcb   $6E n
         fcb   $74 t
         fcb   $69 i
         fcb   $6E n
         fcb   $75 u
         fcb   $6F o
         fcb   $75 u
         fcb   $73 s
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $72 r
         fcb   $61 a
         fcb   $63 c
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $73 s
         fcb   $20
         fcb   $72 r
         fcb   $65 e
         fcb   $70 p
         fcb   $65 e
         fcb   $61 a
         fcb   $74 t
         fcb   $65 e
         fcb   $64 d
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $74 t
         fcb   $68 h
         fcb   $72 r
         fcb   $6F o
         fcb   $75 u
         fcb   $67 g
         fcb   $68 h
         fcb   $6F o
         fcb   $75 u
         fcb   $74 t
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $0D
         fcb   $44 D
         fcb   $20
         fcb   $20
         fcb   $44 D
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $67 g
         fcb   $65 e
         fcb   $6E n
         fcb   $65 e
         fcb   $72 r
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $66 f
         fcb   $6F o
         fcb   $72 r
         fcb   $6D m
         fcb   $61 a
         fcb   $74 t
         fcb   $20
         fcb   $28 (
         fcb   $73 s
         fcb   $65 e
         fcb   $65 e
         fcb   $29 )
         fcb   $0D
         fcb   $47 G
         fcb   $20
         fcb   $20
         fcb   $47 G
         fcb   $65 e
         fcb   $6E n
         fcb   $65 e
         fcb   $72 r
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $6C l
         fcb   $61 a
         fcb   $62 b
         fcb   $65 e
         fcb   $6C l
         fcb   $73 s
         fcb   $20
         fcb   $6C l
         fcb   $65 e
         fcb   $66 f
         fcb   $74 t
         fcb   $2C ,
         fcb   $20
         fcb   $6E n
         fcb   $75 u
         fcb   $6D m
         fcb   $62 b
         fcb   $65 e
         fcb   $72 r
         fcb   $73 s
         fcb   $20
         fcb   $72 r
         fcb   $69 i
         fcb   $67 g
         fcb   $68 h
         fcb   $74 t
         fcb   $0D
         fcb   $49 I
         fcb   $20
         fcb   $20
         fcb   $49 I
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $67 g
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $72 r
         fcb   $6F o
         fcb   $75 u
         fcb   $6E n
         fcb   $64 d
         fcb   $73 s
         fcb   $20
         fcb   $44 D
         fcb   $49 I
         fcb   $53 S
         fcb   $50 P
         fcb   $4C L
         fcb   $41 A
         fcb   $59 Y
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $6E n
         fcb   $65 e
         fcb   $61 a
         fcb   $72 r
         fcb   $65 e
         fcb   $73 s
         fcb   $74 t
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $67 g
         fcb   $65 e
         fcb   $72 r
         fcb   $0D
         fcb   $4C L
         fcb   $20
         fcb   $20
         fcb   $4C L
         fcb   $65 e
         fcb   $66 f
         fcb   $74 t
         fcb   $20
         fcb   $6A j
         fcb   $75 u
         fcb   $73 s
         fcb   $74 t
         fcb   $69 i
         fcb   $66 f
         fcb   $79 y
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $66 f
         fcb   $6F o
         fcb   $72 r
         fcb   $63 c
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $6E n
         fcb   $75 u
         fcb   $6D m
         fcb   $62 b
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $6C l
         fcb   $65 e
         fcb   $66 f
         fcb   $74 t
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $0D
         fcb   $50 P
         fcb   $20
         fcb   $20
         fcb   $50 P
         fcb   $6C l
         fcb   $6F o
         fcb   $74 t
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $75 u
         fcb   $73 s
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $27 '
         fcb   $73 s
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $67 g
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $76 v
         fcb   $61 a
         fcb   $6C l
         fcb   $75 u
         fcb   $65 e
         fcb   $20
         fcb   $61 a
         fcb   $73 s
         fcb   $20
         fcb   $6E n
         fcb   $75 u
         fcb   $6D m
         fcb   $62 b
         fcb   $65 e
         fcb   $72 r
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $67 g
         fcb   $72 r
         fcb   $61 a
         fcb   $70 p
         fcb   $68 h
         fcb   $20
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $72 r
         fcb   $61 a
         fcb   $63 c
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $73 s
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $70 p
         fcb   $72 r
         fcb   $69 i
         fcb   $6E n
         fcb   $74 t
         fcb   $0D
         fcb   $52 R
         fcb   $20
         fcb   $20
         fcb   $52 R
         fcb   $69 i
         fcb   $67 g
         fcb   $68 h
         fcb   $74 t
         fcb   $20
         fcb   $6A j
         fcb   $75 u
         fcb   $73 s
         fcb   $74 t
         fcb   $69 i
         fcb   $66 f
         fcb   $79 y
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $66 f
         fcb   $6F o
         fcb   $72 r
         fcb   $63 c
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $6C l
         fcb   $61 a
         fcb   $62 b
         fcb   $65 e
         fcb   $6C l
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $72 r
         fcb   $69 i
         fcb   $67 g
         fcb   $68 h
         fcb   $74 t
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $0D
         fcb   $24 $
         fcb   $20
         fcb   $20
         fcb   $44 D
         fcb   $6F o
         fcb   $6C l
         fcb   $6C l
         fcb   $61 a
         fcb   $72 r
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $72 r
         fcb   $6F o
         fcb   $75 u
         fcb   $6E n
         fcb   $64 d
         fcb   $73 s
         fcb   $20
         fcb   $44 D
         fcb   $49 I
         fcb   $53 S
         fcb   $50 P
         fcb   $4C L
         fcb   $41 A
         fcb   $59 Y
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $6E n
         fcb   $65 e
         fcb   $61 a
         fcb   $72 r
         fcb   $65 e
         fcb   $73 s
         fcb   $74 t
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $0D
         fcb   $00
         fcb   $50 P
         fcb   $72 r
         fcb   $69 i
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $61 a
         fcb   $74 t
         fcb   $74 t
         fcb   $72 r
         fcb   $69 i
         fcb   $62 b
         fcb   $75 u
         fcb   $74 t
         fcb   $65 e
         fcb   $73 s
         fcb   $3A :
         fcb   $0D
         fcb   $0A
         fcb   $42 B
         fcb   $20
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $67 g
         fcb   $67 g
         fcb   $6C l
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $42 B
         fcb   $6F o
         fcb   $72 r
         fcb   $64 d
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $66 f
         fcb   $6C l
         fcb   $61 a
         fcb   $67 g
         fcb   $20
         fcb   $6F o
         fcb   $6E n
         fcb   $2F /
         fcb   $6F o
         fcb   $66 f
         fcb   $66 f
         fcb   $20
         fcb   $28 (
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $66 f
         fcb   $29 )
         fcb   $0D
         fcb   $43 C
         fcb   $20
         fcb   $20
         fcb   $43 C
         fcb   $6C l
         fcb   $65 e
         fcb   $61 a
         fcb   $72 r
         fcb   $73 s
         fcb   $20
         fcb   $74 t
         fcb   $68 h
         fcb   $65 e
         fcb   $20
         fcb   $70 p
         fcb   $72 r
         fcb   $69 i
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $66 f
         fcb   $69 i
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $6E n
         fcb   $61 a
         fcb   $6D m
         fcb   $65 e
         fcb   $0D
         fcb   $4C L
         fcb   $20
         fcb   $20
         fcb   $73 s
         fcb   $65 e
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $4C L
         fcb   $65 e
         fcb   $6E n
         fcb   $67 g
         fcb   $74 t
         fcb   $68 h
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $70 p
         fcb   $61 a
         fcb   $67 g
         fcb   $65 e
         fcb   $20
         fcb   $28 (
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $35 5
         fcb   $38 8
         fcb   $20
         fcb   $6C l
         fcb   $69 i
         fcb   $6E n
         fcb   $65 e
         fcb   $73 s
         fcb   $29 )
         fcb   $0D
         fcb   $50 P
         fcb   $20
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $67 g
         fcb   $67 g
         fcb   $6C l
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $50 P
         fcb   $61 a
         fcb   $67 g
         fcb   $69 i
         fcb   $6E n
         fcb   $61 a
         fcb   $74 t
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $20
         fcb   $66 f
         fcb   $6C l
         fcb   $61 a
         fcb   $67 g
         fcb   $20
         fcb   $6F o
         fcb   $6E n
         fcb   $2F /
         fcb   $6F o
         fcb   $66 f
         fcb   $66 f
         fcb   $20
         fcb   $28 (
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $6F o
         fcb   $6E n
         fcb   $29 )
         fcb   $0D
         fcb   $53 S
         fcb   $20
         fcb   $20
         fcb   $73 s
         fcb   $65 e
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $74 t
         fcb   $68 h
         fcb   $65 e
         fcb   $20
         fcb   $53 S
         fcb   $70 p
         fcb   $61 a
         fcb   $63 c
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $62 b
         fcb   $65 e
         fcb   $74 t
         fcb   $77 w
         fcb   $65 e
         fcb   $65 e
         fcb   $6E n
         fcb   $20
         fcb   $6C l
         fcb   $69 i
         fcb   $6E n
         fcb   $65 e
         fcb   $73 s
         fcb   $0D
         fcb   $57 W
         fcb   $20
         fcb   $20
         fcb   $73 s
         fcb   $65 e
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $57 W
         fcb   $69 i
         fcb   $64 d
         fcb   $74 t
         fcb   $68 h
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $70 p
         fcb   $61 a
         fcb   $67 g
         fcb   $65 e
         fcb   $20
         fcb   $28 (
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $38 8
         fcb   $30 0
         fcb   $20
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $72 r
         fcb   $61 a
         fcb   $63 c
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $73 s
         fcb   $29 )
         fcb   $0D
         fcb   $0A
         fcb   $20
         fcb   $20
         fcb   $41 A
         fcb   $6C l
         fcb   $6C l
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $74 t
         fcb   $68 h
         fcb   $65 e
         fcb   $73 s
         fcb   $65 e
         fcb   $20
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $20
         fcb   $76 v
         fcb   $61 a
         fcb   $6C l
         fcb   $75 u
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $6D m
         fcb   $61 a
         fcb   $79 y
         fcb   $20
         fcb   $62 b
         fcb   $65 e
         fcb   $20
         fcb   $70 p
         fcb   $65 e
         fcb   $72 r
         fcb   $6D m
         fcb   $61 a
         fcb   $6E n
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $6C l
         fcb   $79 y
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $6D m
         fcb   $6F o
         fcb   $64 d
         fcb   $69 i
         fcb   $66 f
         fcb   $69 i
         fcb   $65 e
         fcb   $64 d
         fcb   $20
         fcb   $62 b
         fcb   $79 y
         fcb   $20
         fcb   $74 t
         fcb   $68 h
         fcb   $65 e
         fcb   $20
         fcb   $75 u
         fcb   $73 s
         fcb   $65 e
         fcb   $72 r
         fcb   $2C ,
         fcb   $20
         fcb   $75 u
         fcb   $73 s
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $20
         fcb   $22 "
         fcb   $49 I
         fcb   $6E n
         fcb   $73 s
         fcb   $74 t
         fcb   $61 a
         fcb   $6C l
         fcb   $6C l
         fcb   $2E .
         fcb   $64 d
         fcb   $63 c
         fcb   $22 "
         fcb   $0D
         fcb   $00
         fcb   $0A
         fcb   $0A
         fcb   $57 W
         fcb   $69 i
         fcb   $64 d
         fcb   $74 t
         fcb   $68 h
         fcb   $3A :
         fcb   $0D
         fcb   $0A
         fcb   $43 C
         fcb   $20
         fcb   $20
         fcb   $61 a
         fcb   $6C l
         fcb   $6C l
         fcb   $6F o
         fcb   $77 w
         fcb   $73 s
         fcb   $20
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $20
         fcb   $77 w
         fcb   $69 i
         fcb   $64 d
         fcb   $74 t
         fcb   $68 h
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $43 C
         fcb   $6F o
         fcb   $6C l
         fcb   $75 u
         fcb   $6D m
         fcb   $6E n
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $28 (
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $57 W
         fcb   $69 i
         fcb   $6E n
         fcb   $64 d
         fcb   $6F o
         fcb   $77 w
         fcb   $20
         fcb   $76 v
         fcb   $61 a
         fcb   $6C l
         fcb   $75 u
         fcb   $65 e
         fcb   $29 )
         fcb   $0D
         fcb   $0A
         fcb   $57 W
         fcb   $20
         fcb   $20
         fcb   $61 a
         fcb   $6C l
         fcb   $6C l
         fcb   $6F o
         fcb   $77 w
         fcb   $73 s
         fcb   $20
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $20
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $20
         fcb   $77 w
         fcb   $69 i
         fcb   $64 d
         fcb   $74 t
         fcb   $68 h
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $61 a
         fcb   $6C l
         fcb   $6C l
         fcb   $20
         fcb   $63 c
         fcb   $6F o
         fcb   $6C l
         fcb   $75 u
         fcb   $6D m
         fcb   $6E n
         fcb   $73 s
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $20
         fcb   $63 c
         fcb   $75 u
         fcb   $72 r
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $57 W
         fcb   $69 i
         fcb   $6E n
         fcb   $64 d
         fcb   $6F o
         fcb   $77 w
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $28 (
         fcb   $64 d
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $39 9
         fcb   $20
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $72 r
         fcb   $61 a
         fcb   $63 c
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $73 s
         fcb   $29 )
         fcb   $0D
         fcb   $00
         fcb   $0A
         fcb   $0A
         fcb   $0A
         fcb   $4D M
         fcb   $6F o
         fcb   $76 v
         fcb   $65 e
         fcb   $20
         fcb   $63 c
         fcb   $6F o
         fcb   $6C l
         fcb   $75 u
         fcb   $6D m
         fcb   $6E n
         fcb   $2F /
         fcb   $72 r
         fcb   $6F o
         fcb   $77 w
         fcb   $3A :
         fcb   $0D
         fcb   $0A
         fcb   $41 A
         fcb   $20
         fcb   $20
         fcb   $53 S
         fcb   $6F o
         fcb   $72 r
         fcb   $74 t
         fcb   $20
         fcb   $63 c
         fcb   $6F o
         fcb   $6C l
         fcb   $75 u
         fcb   $6D m
         fcb   $6E n
         fcb   $73 s
         fcb   $2F /
         fcb   $72 r
         fcb   $6F o
         fcb   $77 w
         fcb   $73 s
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $20
         fcb   $74 t
         fcb   $68 h
         fcb   $65 e
         fcb   $20
         fcb   $67 g
         fcb   $69 i
         fcb   $76 v
         fcb   $65 e
         fcb   $6E n
         fcb   $20
         fcb   $72 r
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $65 e
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $20
         fcb   $41 A
         fcb   $73 s
         fcb   $63 c
         fcb   $65 e
         fcb   $6E n
         fcb   $64 d
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $20
         fcb   $6F o
         fcb   $72 r
         fcb   $64 d
         fcb   $65 e
         fcb   $72 r
         fcb   $0D
         fcb   $44 D
         fcb   $20
         fcb   $20
         fcb   $53 S
         fcb   $6F o
         fcb   $72 r
         fcb   $74 t
         fcb   $20
         fcb   $63 c
         fcb   $6F o
         fcb   $6C l
         fcb   $75 u
         fcb   $6D m
         fcb   $6E n
         fcb   $73 s
         fcb   $2F /
         fcb   $72 r
         fcb   $6F o
         fcb   $77 w
         fcb   $73 s
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $20
         fcb   $74 t
         fcb   $68 h
         fcb   $65 e
         fcb   $20
         fcb   $67 g
         fcb   $69 i
         fcb   $76 v
         fcb   $65 e
         fcb   $6E n
         fcb   $20
         fcb   $72 r
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $65 e
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $20
         fcb   $44 D
         fcb   $65 e
         fcb   $73 s
         fcb   $63 c
         fcb   $65 e
         fcb   $6E n
         fcb   $64 d
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $20
         fcb   $6F o
         fcb   $72 r
         fcb   $64 d
         fcb   $65 e
         fcb   $72 r
         fcb   $0D
         fcb   $4D M
         fcb   $20
         fcb   $20
         fcb   $4D M
         fcb   $61 a
         fcb   $6E n
         fcb   $75 u
         fcb   $61 a
         fcb   $6C l
         fcb   $6C l
         fcb   $79 y
         fcb   $20
         fcb   $6D m
         fcb   $6F o
         fcb   $76 v
         fcb   $65 e
         fcb   $20
         fcb   $63 c
         fcb   $6F o
         fcb   $6C l
         fcb   $75 u
         fcb   $6D m
         fcb   $6E n
         fcb   $2F /
         fcb   $72 r
         fcb   $6F o
         fcb   $77 w
         fcb   $0D
         fcb   $00
         fcb   $0A
         fcb   $0A
         fcb   $43 C
         fcb   $20
         fcb   $20
         fcb   $6C l
         fcb   $6F o
         fcb   $61 a
         fcb   $64 d
         fcb   $73 s
         fcb   $2F /
         fcb   $73 s
         fcb   $61 a
         fcb   $76 v
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $64 d
         fcb   $61 a
         fcb   $74 t
         fcb   $61 a
         fcb   $20
         fcb   $62 b
         fcb   $79 y
         fcb   $20
         fcb   $43 C
         fcb   $6F o
         fcb   $6C l
         fcb   $75 u
         fcb   $6D m
         fcb   $6E n
         fcb   $0D
         fcb   $0A
         fcb   $44 D
         fcb   $20
         fcb   $20
         fcb   $6C l
         fcb   $6F o
         fcb   $61 a
         fcb   $64 d
         fcb   $73 s
         fcb   $2F /
         fcb   $73 s
         fcb   $61 a
         fcb   $76 v
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $64 d
         fcb   $61 a
         fcb   $74 t
         fcb   $61 a
         fcb   $20
         fcb   $62 b
         fcb   $79 y
         fcb   $20
         fcb   $44 D
         fcb   $65 e
         fcb   $66 f
         fcb   $61 a
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $20
         fcb   $6F o
         fcb   $72 r
         fcb   $64 d
         fcb   $65 e
         fcb   $72 r
         fcb   $0D
         fcb   $0A
         fcb   $52 R
         fcb   $20
         fcb   $20
         fcb   $6C l
         fcb   $6F o
         fcb   $61 a
         fcb   $64 d
         fcb   $73 s
         fcb   $2F /
         fcb   $73 s
         fcb   $61 a
         fcb   $76 v
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $64 d
         fcb   $61 a
         fcb   $74 t
         fcb   $61 a
         fcb   $20
         fcb   $62 b
         fcb   $79 y
         fcb   $20
         fcb   $52 R
         fcb   $6F o
         fcb   $77 w
         fcb   $73 s
         fcb   $0D
         fcb   $00
M20BB    fcc   "Trigonometric:"
         fcb   $0D
         fcc   "  @SIN      @ASIN     @PI (3.14)"
         fcb   $0D
M20EB    fcc   "  @COS      @ACOS "
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $54 T
         fcb   $41 A
         fcb   $4E N
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $41 A
         fcb   $54 T
         fcb   $41 A
         fcb   $4E N
         fcb   $20
         fcb   $0D
         fcb   $0A
         fcb   $4C L
         fcb   $6F o
         fcb   $67 g
         fcb   $61 a
         fcb   $72 r
         fcb   $69 i
         fcb   $74 t
         fcb   $68 h
         fcb   $6D m
         fcb   $69 i
         fcb   $63 c
         fcb   $3A :
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $4C L
         fcb   $4F O
         fcb   $47 G
         fcb   $28 (
         fcb   $78 x
         fcb   $29 )
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $6C l
         fcb   $6F o
         fcb   $67 g
         fcb   $61 a
         fcb   $72 r
         fcb   $69 i
         fcb   $74 t
         fcb   $68 h
         fcb   $6D m
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $78 x
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $62 b
         fcb   $61 a
         fcb   $73 s
         fcb   $65 e
         fcb   $20
         fcb   $31 1
         fcb   $30 0
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $4C L
         fcb   $4E N
         fcb   $28 (
         fcb   $78 x
         fcb   $29 )
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $6C l
         fcb   $6F o
         fcb   $67 g
         fcb   $61 a
         fcb   $72 r
         fcb   $69 i
         fcb   $74 t
         fcb   $68 h
         fcb   $6D m
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $78 x
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $62 b
         fcb   $61 a
         fcb   $73 s
         fcb   $65 e
         fcb   $20
         fcb   $65 e
         fcb   $20
         fcb   $28 (
         fcb   $32 2
         fcb   $2E .
         fcb   $37 7
         fcb   $31 1
         fcb   $38 8
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $29 )
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $45 E
         fcb   $58 X
         fcb   $50 P
         fcb   $28 (
         fcb   $78 x
         fcb   $29 )
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $65 e
         fcb   $20
         fcb   $72 r
         fcb   $61 a
         fcb   $69 i
         fcb   $73 s
         fcb   $65 e
         fcb   $64 d
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $78 x
         fcb   $20
         fcb   $70 p
         fcb   $6F o
         fcb   $77 w
         fcb   $65 e
         fcb   $72 r
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $53 S
         fcb   $51 Q
         fcb   $52 R
         fcb   $54 T
         fcb   $28 (
         fcb   $78 x
         fcb   $29 )
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $73 s
         fcb   $71 q
         fcb   $75 u
         fcb   $61 a
         fcb   $72 r
         fcb   $65 e
         fcb   $20
         fcb   $72 r
         fcb   $6F o
         fcb   $6F o
         fcb   $74 t
         fcb   $20
         fcb   $78 x
         fcb   $0D
         fcb   $0A
         fcb   $47 G
         fcb   $65 e
         fcb   $6E n
         fcb   $65 e
         fcb   $72 r
         fcb   $61 a
         fcb   $6C l
         fcb   $3A :
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $41 A
         fcb   $42 B
         fcb   $53 S
         fcb   $28 (
         fcb   $78 x
         fcb   $29 )
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $61 a
         fcb   $62 b
         fcb   $73 s
         fcb   $6F o
         fcb   $6C l
         fcb   $75 u
         fcb   $74 t
         fcb   $65 e
         fcb   $20
         fcb   $76 v
         fcb   $61 a
         fcb   $6C l
         fcb   $75 u
         fcb   $65 e
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $78 x
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $49 I
         fcb   $4E N
         fcb   $54 T
         fcb   $28 (
         fcb   $78 x
         fcb   $29 )
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $67 g
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $70 p
         fcb   $61 a
         fcb   $72 r
         fcb   $74 t
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $78 x
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $52 R
         fcb   $4F O
         fcb   $55 U
         fcb   $4E N
         fcb   $44 D
         fcb   $28 (
         fcb   $64 d
         fcb   $2C ,
         fcb   $78 x
         fcb   $29 )
         fcb   $20
         fcb   $20
         fcb   $78 x
         fcb   $20
         fcb   $72 r
         fcb   $6F o
         fcb   $75 u
         fcb   $6E n
         fcb   $64 d
         fcb   $65 e
         fcb   $64 d
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $6E n
         fcb   $65 e
         fcb   $61 a
         fcb   $72 r
         fcb   $65 e
         fcb   $73 s
         fcb   $74 t
         fcb   $20
         fcb   $64 d
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $28 (
         fcb   $64 d
         fcb   $20
         fcb   $6D m
         fcb   $75 u
         fcb   $73 s
         fcb   $74 t
         fcb   $20
         fcb   $62 b
         fcb   $65 e
         fcb   $20
         fcb   $65 e
         fcb   $76 v
         fcb   $65 e
         fcb   $6E n
         fcb   $20
         fcb   $70 p
         fcb   $6F o
         fcb   $77 w
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $31 1
         fcb   $30 0
         fcb   $29 )
         fcb   $0D
         fcb   $0A
         fcc   "               Hit any key to see page 2"
         fcb   $0D
         fcb   $11

         fcb   $53 S
         fcb   $65 e
         fcb   $72 r
         fcb   $69 i
         fcb   $65 e
         fcb   $73 s
         fcb   $3A :
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $28 (
         fcb   $69 i
         fcb   $6E n
         fcb   $20
         fcb   $72 r
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $65 e
         fcb   $20
         fcb   $78 x
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $79 y
         fcb   $29 )
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $43 C
         fcb   $4F O
         fcb   $55 U
         fcb   $4E N
         fcb   $54 T
         fcb   $28 (
         fcb   $78 x
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $79 y
         fcb   $29 )
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $6E n
         fcb   $75 u
         fcb   $6D m
         fcb   $62 b
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $73 s
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $53 S
         fcb   $55 U
         fcb   $4D M
         fcb   $28 (
         fcb   $78 x
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $79 y
         fcb   $29 )
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $73 s
         fcb   $75 u
         fcb   $6D m
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $76 v
         fcb   $61 a
         fcb   $6C l
         fcb   $75 u
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $73 s
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $41 A
         fcb   $56 V
         fcb   $45 E
         fcb   $52 R
         fcb   $41 A
         fcb   $47 G
         fcb   $45 E
         fcb   $28 (
         fcb   $78 x
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $79 y
         fcb   $29 )
         fcb   $20
         fcb   $20
         fcb   $61 a
         fcb   $76 v
         fcb   $65 e
         fcb   $72 r
         fcb   $61 a
         fcb   $67 g
         fcb   $65 e
         fcb   $20
         fcb   $76 v
         fcb   $61 a
         fcb   $6C l
         fcb   $75 u
         fcb   $65 e
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $73 s
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $53 S
         fcb   $54 T
         fcb   $44 D
         fcb   $44 D
         fcb   $45 E
         fcb   $56 V
         fcb   $28 (
         fcb   $6D m
         fcb   $2C ,
         fcb   $78 x
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $79 y
         fcb   $29 )
         fcb   $20
         fcb   $73 s
         fcb   $74 t
         fcb   $61 a
         fcb   $6E n
         fcb   $64 d
         fcb   $61 a
         fcb   $72 r
         fcb   $64 d
         fcb   $20
         fcb   $64 d
         fcb   $65 e
         fcb   $76 v
         fcb   $69 i
         fcb   $61 a
         fcb   $74 t
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $73 s
         fcb   $2C ,
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $6D m
         fcb   $20
         fcb   $73 s
         fcb   $65 e
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $6D m
         fcb   $65 e
         fcb   $74 t
         fcb   $68 h
         fcb   $6F o
         fcb   $64 d
         fcb   $3A :
         fcb   $20
         fcb   $20
         fcb   $3C <
         fcb   $30 0
         fcb   $20
         fcb   $3D =
         fcb   $20
         fcb   $70 p
         fcb   $6F o
         fcb   $70 p
         fcb   $75 u
         fcb   $6C l
         fcb   $61 a
         fcb   $74 t
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $3B ;
         fcb   $20
         fcb   $20
         fcb   $3E >
         fcb   $3D =
         fcb   $30 0
         fcb   $20
         fcb   $3D =
         fcb   $20
         fcb   $73 s
         fcb   $61 a
         fcb   $6D m
         fcb   $70 p
         fcb   $6C l
         fcb   $65 e
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $4D M
         fcb   $49 I
         fcb   $4E N
         fcb   $28 (
         fcb   $78 x
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $79 y
         fcb   $29 )
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $6C l
         fcb   $65 e
         fcb   $61 a
         fcb   $73 s
         fcb   $74 t
         fcb   $20
         fcb   $76 v
         fcb   $61 a
         fcb   $6C l
         fcb   $75 u
         fcb   $65 e
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $73 s
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $4D M
         fcb   $41 A
         fcb   $58 X
         fcb   $28 (
         fcb   $78 x
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $79 y
         fcb   $29 )
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $67 g
         fcb   $72 r
         fcb   $65 e
         fcb   $61 a
         fcb   $74 t
         fcb   $65 e
         fcb   $73 s
         fcb   $74 t
         fcb   $20
         fcb   $76 v
         fcb   $61 a
         fcb   $6C l
         fcb   $75 u
         fcb   $65 e
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $73 s
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $4E N
         fcb   $50 P
         fcb   $56 V
         fcb   $28 (
         fcb   $72 r
         fcb   $2C ,
         fcb   $78 x
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $79 y
         fcb   $29 )
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $4E N
         fcb   $65 e
         fcb   $74 t
         fcb   $20
         fcb   $50 P
         fcb   $72 r
         fcb   $65 e
         fcb   $73 s
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $56 V
         fcb   $61 a
         fcb   $6C l
         fcb   $75 u
         fcb   $65 e
         fcb   $20
         fcb   $61 a
         fcb   $74 t
         fcb   $20
         fcb   $72 r
         fcb   $61 a
         fcb   $74 t
         fcb   $65 e
         fcb   $20
         fcb   $72 r
         fcb   $0D
         fcb   $49 I
         fcb   $6E n
         fcb   $64 d
         fcb   $65 e
         fcb   $78 x
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $3A :
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $43 C
         fcb   $48 H
         fcb   $4F O
         fcb   $4F O
         fcb   $53 S
         fcb   $45 E
         fcb   $28 (
         fcb   $6E n
         fcb   $2C ,
         fcb   $78 x
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $79 y
         fcb   $29 )
         fcb   $20
         fcb   $76 v
         fcb   $61 a
         fcb   $6C l
         fcb   $75 u
         fcb   $65 e
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $6E n
         fcb   $74 t
         fcb   $68 h
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $20
         fcb   $72 r
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $65 e
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $4C L
         fcb   $4F O
         fcb   $4F O
         fcb   $4B K
         fcb   $55 U
         fcb   $50 P
         fcb   $28 (
         fcb   $6E n
         fcb   $2C ,
         fcb   $78 x
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $79 y
         fcb   $2C ,
         fcb   $7A z
         fcb   $29 )
         fcb   $20
         fcb   $27 '
         fcb   $3E >
         fcb   $27 '
         fcb   $20
         fcb   $73 s
         fcb   $65 e
         fcb   $61 a
         fcb   $72 r
         fcb   $63 c
         fcb   $68 h
         fcb   $20
         fcb   $2D -
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $7A z
         fcb   $20
         fcb   $6F o
         fcb   $70 p
         fcb   $74 t
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $73 s
         fcb   $65 e
         fcb   $65 e
         fcb   $20
         fcb   $6D m
         fcb   $61 a
         fcb   $6E n
         fcb   $75 u
         fcb   $61 a
         fcb   $6C l
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $49 I
         fcb   $4E N
         fcb   $44 D
         fcb   $45 E
         fcb   $58 X
         fcb   $28 (
         fcb   $6E n
         fcb   $2C ,
         fcb   $78 x
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $79 y
         fcb   $2C ,
         fcb   $7A z
         fcb   $29 )
         fcb   $20
         fcb   $20
         fcb   $27 '
         fcb   $3D =
         fcb   $27 '
         fcb   $20
         fcb   $73 s
         fcb   $65 e
         fcb   $61 a
         fcb   $72 r
         fcb   $63 c
         fcb   $68 h
         fcb   $20
         fcb   $2D -
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $7A z
         fcb   $20
         fcb   $6F o
         fcb   $70 p
         fcb   $74 t
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $2D -
         fcb   $20
         fcb   $73 s
         fcb   $65 e
         fcb   $65 e
         fcb   $20
         fcb   $6D m
         fcb   $61 a
         fcb   $6E n
         fcb   $75 u
         fcb   $61 a
         fcb   $6C l
         fcb   $0D
         fcb   $45 E
         fcb   $72 r
         fcb   $72 r
         fcb   $6F o
         fcb   $72 r
         fcb   $3A :
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $45 E
         fcb   $52 R
         fcb   $52 R
         fcb   $4F O
         fcb   $52 R
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $63 c
         fcb   $61 a
         fcb   $75 u
         fcb   $73 s
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $3E >
         fcb   $4E N
         fcb   $41 A
         fcb   $3C <
         fcb   $20
         fcb   $6D m
         fcb   $65 e
         fcb   $73 s
         fcb   $73 s
         fcb   $61 a
         fcb   $67 g
         fcb   $65 e
         fcb   $20
         fcb   $28 (
         fcb   $6E n
         fcb   $6F o
         fcb   $74 t
         fcb   $20
         fcb   $61 a
         fcb   $76 v
         fcb   $61 a
         fcb   $69 i
         fcb   $6C l
         fcb   $61 a
         fcb   $62 b
         fcb   $6C l
         fcb   $65 e
         fcb   $29 )
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $40 @
         fcb   $4E N
         fcb   $41 A
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $63 c
         fcb   $61 a
         fcb   $75 u
         fcb   $73 s
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $3E >
         fcb   $4E N
         fcb   $41 A
         fcb   $3C <
         fcb   $20
         fcb   $6D m
         fcb   $65 e
         fcb   $73 s
         fcb   $73 s
         fcb   $61 a
         fcb   $67 g
         fcb   $65 e
         fcb   $20
         fcb   $28 (
         fcb   $6E n
         fcb   $6F o
         fcb   $74 t
         fcb   $20
         fcb   $61 a
         fcb   $76 v
         fcb   $61 a
         fcb   $69 i
         fcb   $6C l
         fcb   $61 a
         fcb   $62 b
         fcb   $6C l
         fcb   $65 e
         fcb   $29 )
         fcb   $0D
         fcb   $0A
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $48 H
         fcb   $69 i
         fcb   $74 t
         fcb   $20
         fcb   $45 E
         fcb   $53 S
         fcb   $43 C
         fcb   $41 A
         fcb   $50 P
         fcb   $45 E
         fcb   $20
         fcb   $6B k
         fcb   $65 e
         fcb   $79 y
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $65 e
         fcb   $78 x
         fcb   $69 i
         fcb   $74 t
         fcb   $20
         fcb   $48 H
         fcb   $65 e
         fcb   $6C l
         fcb   $70 p
         fcb   $0D
         fcb   $00
         fcb   $41 A
         fcb   $72 r
         fcb   $69 i
         fcb   $74 t
         fcb   $68 h
         fcb   $6D m
         fcb   $65 e
         fcb   $74 t
         fcb   $69 i
         fcb   $63 c
         fcb   $20
         fcb   $6F o
         fcb   $70 p
         fcb   $65 e
         fcb   $72 r
         fcb   $61 a
         fcb   $74 t
         fcb   $6F o
         fcb   $72 r
         fcb   $73 s
         fcb   $3A :
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $78 x
         fcb   $2B +
         fcb   $79 y
         fcb   $20
         fcb   $61 a
         fcb   $64 d
         fcb   $64 d
         fcb   $73 s
         fcb   $20
         fcb   $78 x
         fcb   $20
         fcb   $61 a
         fcb   $6E n
         fcb   $64 d
         fcb   $20
         fcb   $79 y
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $78 x
         fcb   $2D -
         fcb   $79 y
         fcb   $20
         fcb   $20
         fcb   $73 s
         fcb   $75 u
         fcb   $62 b
         fcb   $74 t
         fcb   $72 r
         fcb   $61 a
         fcb   $63 c
         fcb   $74 t
         fcb   $73 s
         fcb   $20
         fcb   $79 y
         fcb   $20
         fcb   $66 f
         fcb   $72 r
         fcb   $6F o
         fcb   $6D m
         fcb   $20
         fcb   $78 x
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $28 (
         fcb   $75 u
         fcb   $73 s
         fcb   $65 e
         fcb   $20
         fcb   $30 0
         fcb   $2D -
         fcb   $78 x
         fcb   $20
         fcb   $66 f
         fcb   $6F o
         fcb   $72 r
         fcb   $20
         fcb   $6D m
         fcb   $6F o
         fcb   $6E n
         fcb   $61 a
         fcb   $64 d
         fcb   $69 i
         fcb   $63 c
         fcb   $20
         fcb   $6D m
         fcb   $69 i
         fcb   $6E n
         fcb   $75 u
         fcb   $73 s
         fcb   $29 )
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $78 x
         fcb   $2A *
         fcb   $79 y
         fcb   $20
         fcb   $20
         fcb   $6D m
         fcb   $75 u
         fcb   $6C l
         fcb   $74 t
         fcb   $69 i
         fcb   $70 p
         fcb   $6C l
         fcb   $69 i
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $78 x
         fcb   $20
         fcb   $62 b
         fcb   $79 y
         fcb   $20
         fcb   $79 y
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $78 x
         fcb   $2F /
         fcb   $79 y
         fcb   $20
         fcb   $20
         fcb   $64 d
         fcb   $69 i
         fcb   $76 v
         fcb   $69 i
         fcb   $64 d
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $78 x
         fcb   $20
         fcb   $62 b
         fcb   $79 y
         fcb   $20
         fcb   $79 y
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $78 x
         fcb   $5E ^
         fcb   $79 y
         fcb   $20
         fcb   $20
         fcb   $72 r
         fcb   $61 a
         fcb   $69 i
         fcb   $73 s
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $78 x
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $79 y
         fcb   $20
         fcb   $70 p
         fcb   $6F o
         fcb   $77 w
         fcb   $65 e
         fcb   $72 r
         fcb   $0D
         fcb   $0A
         fcb   $4D M
         fcb   $61 a
         fcb   $78 x
         fcb   $69 i
         fcb   $6D m
         fcb   $75 u
         fcb   $6D m
         fcb   $20
         fcb   $6E n
         fcb   $75 u
         fcb   $6D m
         fcb   $62 b
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $6D m
         fcb   $73 s
         fcb   $20
         fcb   $69 i
         fcb   $73 s
         fcb   $20
         fcb   $31 1
         fcb   $31 1
         fcb   $0D
         fcb   $0A
         fcb   $50 P
         fcb   $61 a
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $68 h
         fcb   $65 e
         fcb   $73 s
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $20
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $6D m
         fcb   $73 s
         fcb   $20
         fcb   $6D m
         fcb   $61 a
         fcb   $79 y
         fcb   $20
         fcb   $62 b
         fcb   $65 e
         fcb   $20
         fcb   $6E n
         fcb   $65 e
         fcb   $73 s
         fcb   $74 t
         fcb   $65 e
         fcb   $64 d
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $61 a
         fcb   $6E n
         fcb   $79 y
         fcb   $20
         fcb   $64 d
         fcb   $65 e
         fcb   $70 p
         fcb   $74 t
         fcb   $68 h
         fcb   $0D
         fcb   $0A
         fcb   $54 T
         fcb   $6F o
         fcb   $20
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $65 e
         fcb   $78 x
         fcb   $70 p
         fcb   $72 r
         fcb   $65 e
         fcb   $73 s
         fcb   $73 s
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $2C ,
         fcb   $20
         fcb   $66 f
         fcb   $69 i
         fcb   $72 r
         fcb   $73 s
         fcb   $74 t
         fcb   $20
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $72 r
         fcb   $61 a
         fcb   $63 c
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $6D m
         fcb   $75 u
         fcb   $73 s
         fcb   $74 t
         fcb   $0D
         fcb   $6E n
         fcb   $6F o
         fcb   $74 t
         fcb   $20
         fcb   $62 b
         fcb   $65 e
         fcb   $20
         fcb   $61 a
         fcb   $6C l
         fcb   $70 p
         fcb   $68 h
         fcb   $61 a
         fcb   $62 b
         fcb   $65 e
         fcb   $74 t
         fcb   $69 i
         fcb   $63 c
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $46 F
         fcb   $6F o
         fcb   $72 r
         fcb   $20
         fcb   $65 e
         fcb   $78 x
         fcb   $61 a
         fcb   $6D m
         fcb   $70 p
         fcb   $6C l
         fcb   $65 e
         fcb   $2C ,
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $41 A
         fcb   $31 1
         fcb   $2B +
         fcb   $41 A
         fcb   $32 2
         fcb   $2C ,
         fcb   $20
         fcb   $74 t
         fcb   $79 y
         fcb   $70 p
         fcb   $65 e
         fcb   $20
         fcb   $27 '
         fcb   $2B +
         fcb   $41 A
         fcb   $31 1
         fcb   $2B +
         fcb   $41 A
         fcb   $32 2
         fcb   $27 '
         fcb   $0D
         fcb   $0A
         fcb   $54 T
         fcb   $6F o
         fcb   $20
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $6E n
         fcb   $75 u
         fcb   $6D m
         fcb   $65 e
         fcb   $72 r
         fcb   $69 i
         fcb   $63 c
         fcb   $20
         fcb   $61 a
         fcb   $73 s
         fcb   $20
         fcb   $61 a
         fcb   $20
         fcb   $6C l
         fcb   $61 a
         fcb   $62 b
         fcb   $65 e
         fcb   $6C l
         fcb   $2C ,
         fcb   $20
         fcb   $75 u
         fcb   $73 s
         fcb   $65 e
         fcb   $20
         fcb   $6C l
         fcb   $65 e
         fcb   $61 a
         fcb   $64 d
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $0D
         fcb   $73 s
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $6C l
         fcb   $65 e
         fcb   $2D -
         fcb   $71 q
         fcb   $75 u
         fcb   $6F o
         fcb   $74 t
         fcb   $65 e
         fcb   $20
         fcb   $28 (
         fcb   $27 '
         fcb   $29 )
         fcb   $0D
         fcb   $0A
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $48 H
         fcb   $69 i
         fcb   $74 t
         fcb   $20
         fcb   $45 E
         fcb   $53 S
         fcb   $43 C
         fcb   $41 A
         fcb   $50 P
         fcb   $45 E
         fcb   $20
         fcb   $6B k
         fcb   $65 e
         fcb   $79 y
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $65 e
         fcb   $78 x
         fcb   $69 i
         fcb   $74 t
         fcb   $20
         fcb   $48 H
         fcb   $65 e
         fcb   $6C l
         fcb   $70 p
         fcb   $0D
         fcb   $00
M270D    fcc   "       DYNACALC Error Messages"
         fcb   $0D
         fcb   $0A
         fcc   "    >AE<  Bad argument error"
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $3E >
         fcb   $44 D
         fcb   $30 0
         fcb   $3C <
         fcb   $20
         fcb   $20
         fcb   $44 D
         fcb   $69 i
         fcb   $76 v
         fcb   $69 i
         fcb   $64 d
         fcb   $65 e
         fcb   $20
         fcb   $62 b
         fcb   $79 y
         fcb   $20
         fcb   $7A z
         fcb   $65 e
         fcb   $72 r
         fcb   $6F o
         fcb   $20
         fcb   $61 a
         fcb   $74 t
         fcb   $74 t
         fcb   $65 e
         fcb   $6D m
         fcb   $70 p
         fcb   $74 t
         fcb   $65 e
         fcb   $64 d
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $3E >
         fcb   $45 E
         fcb   $52 R
         fcb   $3C <
         fcb   $20
         fcb   $20
         fcb   $47 G
         fcb   $65 e
         fcb   $6E n
         fcb   $65 e
         fcb   $72 r
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $70 p
         fcb   $75 u
         fcb   $72 r
         fcb   $70 p
         fcb   $6F o
         fcb   $73 s
         fcb   $65 e
         fcb   $20
         fcb   $65 e
         fcb   $72 r
         fcb   $72 r
         fcb   $6F o
         fcb   $72 r
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $3E >
         fcb   $45 E
         fcb   $58 X
         fcb   $3C <
         fcb   $20
         fcb   $20
         fcb   $45 E
         fcb   $78 x
         fcb   $70 p
         fcb   $6F o
         fcb   $6E n
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $6F o
         fcb   $20
         fcb   $6C l
         fcb   $61 a
         fcb   $72 r
         fcb   $67 g
         fcb   $65 e
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $3E >
         fcb   $48 H
         fcb   $4F O
         fcb   $3C <
         fcb   $20
         fcb   $20
         fcb   $48 H
         fcb   $6F o
         fcb   $6C l
         fcb   $64 d
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $6F o
         fcb   $76 v
         fcb   $65 e
         fcb   $72 r
         fcb   $66 f
         fcb   $6C l
         fcb   $6F o
         fcb   $77 w
         fcb   $20
         fcb   $65 e
         fcb   $72 r
         fcb   $72 r
         fcb   $6F o
         fcb   $72 r
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $3E >
         fcb   $4C L
         fcb   $4E N
         fcb   $3C <
         fcb   $20
         fcb   $20
         fcb   $4E N
         fcb   $65 e
         fcb   $67 g
         fcb   $61 a
         fcb   $74 t
         fcb   $69 i
         fcb   $76 v
         fcb   $65 e
         fcb   $20
         fcb   $6F o
         fcb   $72 r
         fcb   $20
         fcb   $7A z
         fcb   $65 e
         fcb   $72 r
         fcb   $6F o
         fcb   $20
         fcb   $6C l
         fcb   $6F o
         fcb   $67 g
         fcb   $61 a
         fcb   $72 r
         fcb   $69 i
         fcb   $74 t
         fcb   $68 h
         fcb   $6D m
         fcb   $20
         fcb   $61 a
         fcb   $74 t
         fcb   $74 t
         fcb   $65 e
         fcb   $6D m
         fcb   $70 p
         fcb   $74 t
         fcb   $65 e
         fcb   $64 d
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $3E >
         fcb   $4E N
         fcb   $41 A
         fcb   $3C <
         fcb   $20
         fcb   $20
         fcb   $4E N
         fcb   $6F o
         fcb   $74 t
         fcb   $20
         fcb   $61 a
         fcb   $76 v
         fcb   $61 a
         fcb   $69 i
         fcb   $6C l
         fcb   $61 a
         fcb   $62 b
         fcb   $6C l
         fcb   $65 e
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $3E >
         fcb   $4E N
         fcb   $52 R
         fcb   $3C <
         fcb   $20
         fcb   $20
         fcb   $4E N
         fcb   $65 e
         fcb   $67 g
         fcb   $61 a
         fcb   $74 t
         fcb   $69 i
         fcb   $76 v
         fcb   $65 e
         fcb   $20
         fcb   $72 r
         fcb   $6F o
         fcb   $6F o
         fcb   $74 t
         fcb   $20
         fcb   $61 a
         fcb   $74 t
         fcb   $74 t
         fcb   $65 e
         fcb   $6D m
         fcb   $70 p
         fcb   $74 t
         fcb   $65 e
         fcb   $64 d
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $3E >
         fcb   $4F O
         fcb   $56 V
         fcb   $3C <
         fcb   $20
         fcb   $20
         fcb   $41 A
         fcb   $72 r
         fcb   $69 i
         fcb   $74 t
         fcb   $68 h
         fcb   $6D m
         fcb   $65 e
         fcb   $74 t
         fcb   $69 i
         fcb   $63 c
         fcb   $20
         fcb   $6F o
         fcb   $76 v
         fcb   $65 e
         fcb   $72 r
         fcb   $66 f
         fcb   $6C l
         fcb   $6F o
         fcb   $77 w
         fcb   $20
         fcb   $65 e
         fcb   $72 r
         fcb   $72 r
         fcb   $6F o
         fcb   $72 r
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $3E >
         fcb   $52 R
         fcb   $45 E
         fcb   $3C <
         fcb   $20
         fcb   $20
         fcb   $52 R
         fcb   $65 e
         fcb   $66 f
         fcb   $65 e
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $63 c
         fcb   $65 e
         fcb   $20
         fcb   $65 e
         fcb   $72 r
         fcb   $72 r
         fcb   $6F o
         fcb   $72 r
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $3E >
         fcb   $52 R
         fcb   $4E N
         fcb   $3C <
         fcb   $20
         fcb   $20
         fcb   $52 R
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $65 e
         fcb   $20
         fcb   $65 e
         fcb   $72 r
         fcb   $72 r
         fcb   $6F o
         fcb   $72 r
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $3E >
         fcb   $53 S
         fcb   $4E N
         fcb   $3C <
         fcb   $20
         fcb   $20
         fcb   $53 S
         fcb   $79 y
         fcb   $6E n
         fcb   $74 t
         fcb   $61 a
         fcb   $78 x
         fcb   $20
         fcb   $65 e
         fcb   $72 r
         fcb   $72 r
         fcb   $6F o
         fcb   $72 r
         fcb   $0D
         fcb   $0A
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $48 H
         fcb   $69 i
         fcb   $74 t
         fcb   $20
         fcb   $61 a
         fcb   $6E n
         fcb   $79 y
         fcb   $20
         fcb   $6B k
         fcb   $65 e
         fcb   $79 y
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $65 e
         fcb   $78 x
         fcb   $69 i
         fcb   $74 t
         fcb   $20
         fcb   $48 H
         fcb   $65 e
         fcb   $6C l
         fcb   $70 p
         fcb   $0D
         fcb   $00
         fcb   $50 P
         fcb   $61 a
         fcb   $74 t
         fcb   $68 h
         fcb   $20
         fcb   $74 t
         fcb   $61 a
         fcb   $62 b
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $66 f
         fcb   $75 u
         fcb   $6C l
         fcb   $6C l
         fcb   $2E .
         fcb   $00
         fcb   $49 I
         fcb   $6C l
         fcb   $6C l
         fcb   $65 e
         fcb   $67 g
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $70 p
         fcb   $61 a
         fcb   $74 t
         fcb   $68 h
         fcb   $20
         fcb   $6E n
         fcb   $75 u
         fcb   $6D m
         fcb   $62 b
         fcb   $65 e
         fcb   $72 r
         fcb   $2E .
         fcb   $00
         fcb   $49 I
         fcb   $6E n
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $72 r
         fcb   $75 u
         fcb   $70 p
         fcb   $74 t
         fcb   $20
         fcb   $70 p
         fcb   $6F o
         fcb   $6C l
         fcb   $6C l
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $20
         fcb   $74 t
         fcb   $61 a
         fcb   $62 b
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $66 f
         fcb   $75 u
         fcb   $6C l
         fcb   $6C l
         fcb   $2E .
         fcb   $00
         fcb   $49 I
         fcb   $6C l
         fcb   $6C l
         fcb   $65 e
         fcb   $67 g
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $49 I
         fcb   $2F /
         fcb   $4F O
         fcb   $20
         fcb   $6D m
         fcb   $6F o
         fcb   $64 d
         fcb   $65 e
         fcb   $2E .
         fcb   $00
         fcb   $44 D
         fcb   $65 e
         fcb   $76 v
         fcb   $69 i
         fcb   $63 c
         fcb   $65 e
         fcb   $20
         fcb   $74 t
         fcb   $61 a
         fcb   $62 b
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $6F o
         fcb   $76 v
         fcb   $65 e
         fcb   $72 r
         fcb   $66 f
         fcb   $6C l
         fcb   $6F o
         fcb   $77 w
         fcb   $2E .
         fcb   $00
         fcb   $49 I
         fcb   $6C l
         fcb   $6C l
         fcb   $65 e
         fcb   $67 g
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $6D m
         fcb   $6F o
         fcb   $64 d
         fcb   $75 u
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $49 I
         fcb   $44 D
         fcb   $20
         fcb   $62 b
         fcb   $6C l
         fcb   $6F o
         fcb   $63 c
         fcb   $6B k
         fcb   $2E .
         fcb   $00
         fcb   $4D M
         fcb   $6F o
         fcb   $64 d
         fcb   $75 u
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $64 d
         fcb   $69 i
         fcb   $72 r
         fcb   $65 e
         fcb   $63 c
         fcb   $74 t
         fcb   $6F o
         fcb   $72 r
         fcb   $79 y
         fcb   $20
         fcb   $66 f
         fcb   $75 u
         fcb   $6C l
         fcb   $6C l
         fcb   $2E .
         fcb   $00
         fcb   $4D M
         fcb   $65 e
         fcb   $6D m
         fcb   $6F o
         fcb   $72 r
         fcb   $79 y
         fcb   $20
         fcb   $66 f
         fcb   $75 u
         fcb   $6C l
         fcb   $6C l
         fcb   $2E .
         fcb   $00
         fcb   $55 U
         fcb   $6E n
         fcb   $6B k
         fcb   $6E n
         fcb   $6F o
         fcb   $77 w
         fcb   $6E n
         fcb   $20
         fcb   $73 s
         fcb   $65 e
         fcb   $72 r
         fcb   $76 v
         fcb   $69 i
         fcb   $63 c
         fcb   $65 e
         fcb   $20
         fcb   $72 r
         fcb   $65 e
         fcb   $71 q
         fcb   $75 u
         fcb   $65 e
         fcb   $73 s
         fcb   $74 t
         fcb   $2E .
         fcb   $00
         fcb   $4D M
         fcb   $6F o
         fcb   $64 d
         fcb   $75 u
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $62 b
         fcb   $75 u
         fcb   $73 s
         fcb   $79 y
         fcb   $2E .
         fcb   $00
         fcb   $42 B
         fcb   $61 a
         fcb   $64 d
         fcb   $20
         fcb   $62 b
         fcb   $6F o
         fcb   $75 u
         fcb   $6E n
         fcb   $64 d
         fcb   $61 a
         fcb   $72 r
         fcb   $79 y
         fcb   $2E .
         fcb   $00
         fcb   $45 E
         fcb   $6E n
         fcb   $64 d
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $66 f
         fcb   $69 i
         fcb   $6C l
         fcb   $65 e
         fcb   $2E .
         fcb   $00
         fcb   $52 R
         fcb   $65 e
         fcb   $74 t
         fcb   $75 u
         fcb   $72 r
         fcb   $6E n
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $20
         fcb   $6E n
         fcb   $6F o
         fcb   $6E n
         fcb   $2D -
         fcb   $61 a
         fcb   $6C l
         fcb   $6C l
         fcb   $6F o
         fcb   $63 c
         fcb   $61 a
         fcb   $74 t
         fcb   $65 e
         fcb   $64 d
         fcb   $20
         fcb   $6D m
         fcb   $65 e
         fcb   $6D m
         fcb   $6F o
         fcb   $72 r
         fcb   $79 y
         fcb   $2E .
         fcb   $00
         fcb   $4E N
         fcb   $6F o
         fcb   $6E n
         fcb   $2D -
         fcb   $65 e
         fcb   $78 x
         fcb   $69 i
         fcb   $73 s
         fcb   $74 t
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $20
         fcb   $73 s
         fcb   $65 e
         fcb   $67 g
         fcb   $6D m
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $2E .
         fcb   $00
         fcb   $4E N
         fcb   $6F o
         fcb   $20
         fcb   $70 p
         fcb   $65 e
         fcb   $72 r
         fcb   $6D m
         fcb   $69 i
         fcb   $73 s
         fcb   $73 s
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $2D -
         fcb   $20
         fcb   $61 a
         fcb   $63 c
         fcb   $63 c
         fcb   $65 e
         fcb   $73 s
         fcb   $73 s
         fcb   $20
         fcb   $64 d
         fcb   $65 e
         fcb   $6E n
         fcb   $69 i
         fcb   $65 e
         fcb   $64 d
         fcb   $2E .
         fcb   $00
         fcb   $42 B
         fcb   $61 a
         fcb   $64 d
         fcb   $20
         fcb   $70 p
         fcb   $61 a
         fcb   $74 t
         fcb   $68 h
         fcb   $20
         fcb   $6E n
         fcb   $61 a
         fcb   $6D m
         fcb   $65 e
         fcb   $2E .
         fcb   $00
         fcb   $54 T
         fcb   $68 h
         fcb   $65 e
         fcb   $20
         fcb   $66 f
         fcb   $69 i
         fcb   $6C l
         fcb   $65 e
         fcb   $2F /
         fcb   $64 d
         fcb   $65 e
         fcb   $76 v
         fcb   $69 i
         fcb   $63 c
         fcb   $65 e
         fcb   $20
         fcb   $63 c
         fcb   $61 a
         fcb   $6E n
         fcb   $6E n
         fcb   $6F o
         fcb   $74 t
         fcb   $20
         fcb   $62 b
         fcb   $65 e
         fcb   $20
         fcb   $66 f
         fcb   $6F o
         fcb   $75 u
         fcb   $6E n
         fcb   $64 d
         fcb   $2E .
         fcb   $00
         fcb   $53 S
         fcb   $65 e
         fcb   $67 g
         fcb   $6D m
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $6C l
         fcb   $69 i
         fcb   $73 s
         fcb   $74 t
         fcb   $20
         fcb   $66 f
         fcb   $69 i
         fcb   $6C l
         fcb   $6C l
         fcb   $65 e
         fcb   $64 d
         fcb   $2E .
         fcb   $00
         fcb   $43 C
         fcb   $72 r
         fcb   $65 e
         fcb   $61 a
         fcb   $74 t
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $20
         fcb   $65 e
         fcb   $78 x
         fcb   $69 i
         fcb   $73 s
         fcb   $74 t
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $20
         fcb   $66 f
         fcb   $69 i
         fcb   $6C l
         fcb   $65 e
         fcb   $2E .
         fcb   $00
         fcb   $49 I
         fcb   $6C l
         fcb   $6C l
         fcb   $65 e
         fcb   $67 g
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $62 b
         fcb   $6C l
         fcb   $6F o
         fcb   $63 c
         fcb   $6B k
         fcb   $20
         fcb   $61 a
         fcb   $64 d
         fcb   $64 d
         fcb   $72 r
         fcb   $65 e
         fcb   $73 s
         fcb   $73 s
         fcb   $2E .
         fcb   $00
         fcb   $49 I
         fcb   $6C l
         fcb   $6C l
         fcb   $65 e
         fcb   $67 g
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $62 b
         fcb   $6C l
         fcb   $6F o
         fcb   $63 c
         fcb   $6B k
         fcb   $20
         fcb   $73 s
         fcb   $69 i
         fcb   $7A z
         fcb   $65 e
         fcb   $2E .
         fcb   $00
         fcb   $4C L
         fcb   $69 i
         fcb   $6E n
         fcb   $6B k
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $61 a
         fcb   $20
         fcb   $6E n
         fcb   $6F o
         fcb   $6E n
         fcb   $2D -
         fcb   $65 e
         fcb   $78 x
         fcb   $69 i
         fcb   $73 s
         fcb   $74 t
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $20
         fcb   $6D m
         fcb   $6F o
         fcb   $64 d
         fcb   $75 u
         fcb   $6C l
         fcb   $65 e
         fcb   $2E .
         fcb   $00
         fcb   $53 S
         fcb   $65 e
         fcb   $63 c
         fcb   $74 t
         fcb   $6F o
         fcb   $72 r
         fcb   $20
         fcb   $6E n
         fcb   $75 u
         fcb   $6D m
         fcb   $62 b
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $6F o
         fcb   $75 u
         fcb   $74 t
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $72 r
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $65 e
         fcb   $2E .
         fcb   $00
         fcb   $44 D
         fcb   $65 e
         fcb   $61 a
         fcb   $6C l
         fcb   $6C l
         fcb   $6F o
         fcb   $63 c
         fcb   $61 a
         fcb   $74 t
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $20
         fcb   $73 s
         fcb   $74 t
         fcb   $61 a
         fcb   $63 c
         fcb   $6B k
         fcb   $20
         fcb   $6D m
         fcb   $65 e
         fcb   $6D m
         fcb   $6F o
         fcb   $72 r
         fcb   $79 y
         fcb   $2E .
         fcb   $00
         fcb   $49 I
         fcb   $6C l
         fcb   $6C l
         fcb   $65 e
         fcb   $67 g
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $70 p
         fcb   $72 r
         fcb   $6F o
         fcb   $63 c
         fcb   $65 e
         fcb   $73 s
         fcb   $73 s
         fcb   $20
         fcb   $49 I
         fcb   $44 D
         fcb   $2E .
         fcb   $00
         fcb   $49 I
         fcb   $6C l
         fcb   $6C l
         fcb   $65 e
         fcb   $67 g
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $73 s
         fcb   $69 i
         fcb   $67 g
         fcb   $6E n
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $63 c
         fcb   $6F o
         fcb   $64 d
         fcb   $65 e
         fcb   $2E .
         fcb   $00
         fcb   $4E N
         fcb   $6F o
         fcb   $20
         fcb   $63 c
         fcb   $68 h
         fcb   $69 i
         fcb   $6C l
         fcb   $64 d
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $2E .
         fcb   $00
         fcb   $49 I
         fcb   $6C l
         fcb   $6C l
         fcb   $65 e
         fcb   $67 g
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $53 S
         fcb   $57 W
         fcb   $49 I
         fcb   $20
         fcb   $63 c
         fcb   $6F o
         fcb   $64 d
         fcb   $65 e
         fcb   $2E .
         fcb   $00
         fcb   $4B K
         fcb   $65 e
         fcb   $79 y
         fcb   $62 b
         fcb   $6F o
         fcb   $61 a
         fcb   $72 r
         fcb   $64 d
         fcb   $20
         fcb   $61 a
         fcb   $62 b
         fcb   $6F o
         fcb   $72 r
         fcb   $74 t
         fcb   $2E .
         fcb   $00
         fcb   $50 P
         fcb   $72 r
         fcb   $6F o
         fcb   $63 c
         fcb   $65 e
         fcb   $73 s
         fcb   $73 s
         fcb   $20
         fcb   $74 t
         fcb   $61 a
         fcb   $62 b
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $66 f
         fcb   $75 u
         fcb   $6C l
         fcb   $6C l
         fcb   $2E .
         fcb   $00
         fcb   $49 I
         fcb   $6C l
         fcb   $6C l
         fcb   $65 e
         fcb   $67 g
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $66 f
         fcb   $6F o
         fcb   $72 r
         fcb   $6B k
         fcb   $20
         fcb   $70 p
         fcb   $61 a
         fcb   $72 r
         fcb   $61 a
         fcb   $6D m
         fcb   $65 e
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $61 a
         fcb   $72 r
         fcb   $65 e
         fcb   $61 a
         fcb   $2E .
         fcb   $00
         fcb   $4B K
         fcb   $6E n
         fcb   $6F o
         fcb   $77 w
         fcb   $6E n
         fcb   $20
         fcb   $6D m
         fcb   $6F o
         fcb   $64 d
         fcb   $75 u
         fcb   $6C l
         fcb   $65 e
         fcb   $2E .
         fcb   $00
         fcb   $42 B
         fcb   $61 a
         fcb   $64 d
         fcb   $20
         fcb   $6D m
         fcb   $6F o
         fcb   $64 d
         fcb   $75 u
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $43 C
         fcb   $52 R
         fcb   $43 C
         fcb   $2E .
         fcb   $00
         fcb   $55 U
         fcb   $6E n
         fcb   $70 p
         fcb   $72 r
         fcb   $6F o
         fcb   $63 c
         fcb   $65 e
         fcb   $73 s
         fcb   $73 s
         fcb   $65 e
         fcb   $64 d
         fcb   $20
         fcb   $73 s
         fcb   $69 i
         fcb   $67 g
         fcb   $6E n
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $70 p
         fcb   $65 e
         fcb   $6E n
         fcb   $64 d
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
         fcb   $2E .
         fcb   $00
         fcb   $4E N
         fcb   $6F o
         fcb   $6E n
         fcb   $2D -
         fcb   $65 e
         fcb   $78 x
         fcb   $65 e
         fcb   $63 c
         fcb   $75 u
         fcb   $74 t
         fcb   $61 a
         fcb   $62 b
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $6D m
         fcb   $6F o
         fcb   $64 d
         fcb   $75 u
         fcb   $6C l
         fcb   $65 e
         fcb   $2E .
         fcb   $00
         fcb   $55 U
         fcb   $6E n
         fcb   $69 i
         fcb   $74 t
         fcb   $20
         fcb   $6E n
         fcb   $75 u
         fcb   $6D m
         fcb   $62 b
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $6F o
         fcb   $75 u
         fcb   $74 t
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $72 r
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $65 e
         fcb   $2E .
         fcb   $00
         fcb   $53 S
         fcb   $65 e
         fcb   $63 c
         fcb   $74 t
         fcb   $6F o
         fcb   $72 r
         fcb   $20
         fcb   $6E n
         fcb   $75 u
         fcb   $6D m
         fcb   $62 b
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $6F o
         fcb   $75 u
         fcb   $74 t
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $72 r
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $65 e
         fcb   $2E .
         fcb   $00
         fcb   $57 W
         fcb   $72 r
         fcb   $69 i
         fcb   $74 t
         fcb   $65 e
         fcb   $20
         fcb   $70 p
         fcb   $72 r
         fcb   $6F o
         fcb   $74 t
         fcb   $65 e
         fcb   $63 c
         fcb   $74 t
         fcb   $2E .
         fcb   $00
         fcb   $43 C
         fcb   $68 h
         fcb   $65 e
         fcb   $63 c
         fcb   $6B k
         fcb   $73 s
         fcb   $75 u
         fcb   $6D m
         fcb   $20
         fcb   $65 e
         fcb   $72 r
         fcb   $72 r
         fcb   $6F o
         fcb   $72 r
         fcb   $2E .
         fcb   $00
         fcb   $52 R
         fcb   $65 e
         fcb   $61 a
         fcb   $64 d
         fcb   $20
         fcb   $65 e
         fcb   $72 r
         fcb   $72 r
         fcb   $6F o
         fcb   $72 r
         fcb   $2E .
         fcb   $00
         fcb   $57 W
         fcb   $72 r
         fcb   $69 i
         fcb   $74 t
         fcb   $65 e
         fcb   $20
         fcb   $65 e
         fcb   $72 r
         fcb   $72 r
         fcb   $6F o
         fcb   $72 r
         fcb   $2E .
         fcb   $00
         fcb   $44 D
         fcb   $65 e
         fcb   $76 v
         fcb   $69 i
         fcb   $63 c
         fcb   $65 e
         fcb   $20
         fcb   $6E n
         fcb   $6F o
         fcb   $74 t
         fcb   $20
         fcb   $72 r
         fcb   $65 e
         fcb   $61 a
         fcb   $64 d
         fcb   $79 y
         fcb   $2E .
         fcb   $00
         fcb   $53 S
         fcb   $65 e
         fcb   $65 e
         fcb   $6B k
         fcb   $20
         fcb   $65 e
         fcb   $72 r
         fcb   $72 r
         fcb   $6F o
         fcb   $72 r
         fcb   $2E .
         fcb   $00
         fcb   $4D M
         fcb   $65 e
         fcb   $64 d
         fcb   $69 i
         fcb   $61 a
         fcb   $20
         fcb   $66 f
         fcb   $75 u
         fcb   $6C l
         fcb   $6C l
         fcb   $2E .
         fcb   $00
         fcb   $44 D
         fcb   $65 e
         fcb   $76 v
         fcb   $69 i
         fcb   $63 c
         fcb   $65 e
         fcb   $2F /
         fcb   $6D m
         fcb   $65 e
         fcb   $64 d
         fcb   $69 i
         fcb   $61 a
         fcb   $20
         fcb   $74 t
         fcb   $79 y
         fcb   $70 p
         fcb   $65 e
         fcb   $20
         fcb   $6D m
         fcb   $69 i
         fcb   $73 s
         fcb   $6D m
         fcb   $61 a
         fcb   $74 t
         fcb   $63 c
         fcb   $68 h
         fcb   $2E .
         fcb   $00
         fcb   $44 D
         fcb   $65 e
         fcb   $76 v
         fcb   $69 i
         fcb   $63 c
         fcb   $65 e
         fcb   $20
         fcb   $62 b
         fcb   $75 u
         fcb   $73 s
         fcb   $79 y
         fcb   $2E .
         fcb   $00
         fcb   $44 D
         fcb   $65 e
         fcb   $76 v
         fcb   $69 i
         fcb   $63 c
         fcb   $65 e
         fcb   $2F /
         fcb   $6D m
         fcb   $65 e
         fcb   $64 d
         fcb   $69 i
         fcb   $61 a
         fcb   $20
         fcb   $49 I
         fcb   $44 D
         fcb   $20
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $65 e
         fcb   $64 d
         fcb   $2E .
         fcb   $00
         fcb   $49 I
         fcb   $6E n
         fcb   $64 d
         fcb   $69 i
         fcb   $72 r
         fcb   $65 e
         fcb   $63 c
         fcb   $74 t
         fcb   $20
         fcb   $66 f
         fcb   $69 i
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $65 e
         fcb   $72 r
         fcb   $72 r
         fcb   $6F o
         fcb   $72 r
         fcb   $2E .
         fcb   $00
         fcb   $49 I
         fcb   $6E n
         fcb   $64 d
         fcb   $69 i
         fcb   $72 r
         fcb   $65 e
         fcb   $63 c
         fcb   $74 t
         fcb   $20
         fcb   $66 f
         fcb   $69 i
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $77 w
         fcb   $61 a
         fcb   $73 s
         fcb   $20
         fcb   $61 a
         fcb   $63 c
         fcb   $63 c
         fcb   $65 e
         fcb   $73 s
         fcb   $73 s
         fcb   $65 e
         fcb   $64 d
         fcb   $2E .
         fcb   $00
M2CC1    fcc   "Unknown error code."
         fcb   $00
         fcb   $00
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
