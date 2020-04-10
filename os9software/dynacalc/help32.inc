* Texts are shortened to max 32 characters per line
HELPS    fcc   "A  set Attributes"
         fcb   $0D
         fcc   "B  Blank current cell"
         fcb   $0D
         fcc   "C  Clear entire worksheet"
         fcb   $0D
         fcc   "D  Delete current column or row"
         fcb   $0D
         fcc   "E  Edit contents, current cell"
         fcb   $0D
         fcc   "F  set Format of current cell"
         fcb   $0D
         fcc   "I  Insert new column or row"
         fcb   $0D
 ifeq DYNAVERS-485
         fcc   "K  enter Keysaver mode"
         fcb   $0D
 endc
         fcc   "L  Locate specified label,"
         fcb   $0D
         fcc   /   ?="Wild card" character/
         fcb   $0D
         fcc   /   @="Don't ignore case" char./
         fcb   $0D
         fcb   $0A
         fcc   "   Hit any key to see page 2"
         fcb   $11
         fcc   "M  Move column or row"
         fcb   $0D
         fcc   "P  Print sheet: file or printer"
         fcb   $0D
         fcc   "Q  Quit and go to Sleep or OS-9"
         fcb   $0D
         fcc   "R  Replicate (copy) cell(s)"
         fcb   $0D
         fcc   "S  call System function"
         fcb   $0D
         fcc   "T  set column or row Titles"
         fcb   $0D
         fcc   "W  adjust display Window(s)"
         fcb   $0D
         fcb   $0A
         fcc   "Hit @ for help with FUNCTIONS"
         fcb   $0D
         fcc   "    > for help with ERRORS"
         fcb   $0D
         fcc   "    G for general help"
         fcb   $00

M12EE    fcc   "Set attributes:"
         fcb   $0D
         fcc   "B  toggle Bell on/off"
         fcb   $0D
         fcc   "D  toggle Degree/radian mode"
         fcb   $0D
         fcc   "G  change Graph character"
         fcb   $0D
         fcc   "H  delete Help messages"
         fcb   $0D
         fcc   "L  toggle Label entry mode flag"
         fcb   $0D
         fcc   "M  re-write (Modify) screen"
         fcb   $0D
         fcc   "O  toggle Col./Row calc. Order"
         fcb   $0D
         fcc   "P  changes Printer parameters"
         fcb   $0D
         fcc   "R  toggle Auto/Manual Recalc."
         fcb   $0D
         fcc   "S  reports Size of worksheet"
         fcb   $0D
         fcc   "T  toggle Type protection"
         fcb   $0D
         fcc   "W  changes column Width(s)"
         fcb   $00


M1500    fcc   "Delete column/row:"
         fcb   $0D
         fcb   $0A
         fcc   "C  deletes current Column"
         fcb   $0D
         fcc   "R  deletes current Row"
         fcb   $00

M154A    fcc   "Set Format of current cell:"
         fcb   $0D
         fcb   $0A
         fcc   "C  Continuous - characters"
         fcb   $0D
         fcc   "   repeated throughout cell"
         fcb   $0D
         fcc   "D  Default - use window format"
         fcb   $0D
         fcc   "G  General - free-format"
         fcb   $0D
         fcc   "   (labels left, numbers right)"
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
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $0A
         fcc   "   Hit any key to see page 2"
         fcb   $11
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
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $67 g
         fcb   $72 r
         fcb   $61 a
         fcb   $70 p
         fcb   $68 h
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcc   "R  Right justify - forces label"
         fcb   $0D
         fcc   "   to right of cell"
         fcb   $0D
         fcc   "$  Dollar - rounds DISPLAY to"
         fcb   $0D
         fcc   "   nearest cent"
         fcb   $00

M16F0    fcc   "Insert new column or row:"
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
         fcb   $70 p
         fcb   $6F o
         fcb   $73 s
         fcb   $69 i
         fcb   $74 t
         fcb   $69 i
         fcb   $6F o
         fcb   $6E n
         fcb   $00

M176D    fcc   "Quit:"
         fcb   $0D
         fcb   $0A
         fcc   "O  leave DYNACALC and return"
         fcb   $0D
         fcc   "   to OS-9"
         fcb   $0D
         fcb   $0A
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
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $00

M17D0    fcc   "System:"
         fcb   $0D
         fcb   $0A
         fcc   "C  Change the current directory"
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
         fcb   $2D -
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
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $2E .
         fcb   $63 c
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $69 i
         fcb   $6E n
         fcb   $20
         fcb   $77 w
         fcb   $6F o
         fcb   $72 r
         fcb   $6B k
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
         fcc   "X  eXecute OS-9 command"
         fcb   $0D
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
         fcb   $2D -
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $2D -
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $72 r
         fcb   $65 e
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $77 w
         fcb   $6F o
         fcb   $72 r
         fcb   $6B k
         fcb   $69 i
         fcb   $6E n
         fcb   $67 g
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
         fcb   $00

M1901    fcc   "Save data:"
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
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $00

M196F    fcc   "Titles:"
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
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $61 a
         fcb   $73 s
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
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $28 (
         fcb   $73 s
         fcb   $29 )
         fcb   $00

M1A31    fcc   "Windows:"
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
         fcb   $0D
         fcb   $46 F
         fcb   $20
         fcb   $20
         fcb   $73 s
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
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $73 s
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
         fcb   $2D -
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
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
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $00

M1BC7    fcc   "Set default format of window:"
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
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $72 r
         fcb   $65 e
         fcb   $70 p
         fcb   $65 e
         fcb   $61 a
         fcb   $74 t
         fcb   $65 e
         fcb   $64 d
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
         fcb   $66 f
         fcb   $72 r
         fcb   $65 e
         fcb   $65 e
         fcb   $2D -
         fcb   $66 f
         fcb   $6F o
         fcb   $72 r
         fcb   $6D m
         fcb   $61 a
         fcb   $74 t
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $28 (
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
         fcb   $29 )
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
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $0A
         fcc   "   Hit any key to see page 2"
         fcb   $11
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
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $67 g
         fcb   $72 r
         fcb   $61 a
         fcb   $70 p
         fcb   $68 h
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $00
         
M1D79    fcc   "Printer attributes:"
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
         fcb   $6F o
         fcb   $6E n
         fcb   $2F /
         fcb   $6F o
         fcb   $66 f
         fcb   $66 f
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
         fcb   $00

M1EF0    fcc   "Width:"
         fcb   $0D
         fcb   $0A
         fcb   $43 C
         fcb   $20
         fcb   $20
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $65 e
         fcb   $73 s
         fcb   $20
         fcb   $77 w
         fcb   $69 i
         fcb   $64 d
         fcb   $74 t
         fcb   $68 h
         fcb   $20
         fcb   $6F o
         fcb   $66 f
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
         fcb   $63 c
         fcb   $68 h
         fcb   $61 a
         fcb   $6E n
         fcb   $67 g
         fcb   $65 e
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
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $63 c
         fcb   $6F o
         fcb   $6C l
         fcb   $75 u
         fcb   $6D m
         fcb   $6E n
         fcb   $73 s
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
         fcb   $00

M1FA8    fcc   "Move column/row:"
         fcb   $0D
         fcb   $0A
         fcb   $41 A
         fcb   $20
         fcb   $20
         fcb   $73 s
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
         fcb   $73 s
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
         fcc   "M  Manually move column/row"
         fcb   $00

M2057    fcc   "Order:"
         fcb   $0D
         fcb   $0A
         fcc   "C  loads/saves data by Column"
         fcb   $0D
         fcc   "D  loads/saves data by Default"
         fcb   $0D
         fcc   "   order"
         fcb   $0D
         fcc   "R  loads/saves data by Rows"
         fcb   $00

M20BB    fcc   "Trigonometric:"
         fcb   $0D
         fcc   "@SIN    @ASIN     @PI (3.14...)"
         fcb   $0D
         fcc   "@COS    @ACOS "
         fcb   $0D
         fcc   "@TAN    @ATAN "
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
         fcb   $40 @
         fcb   $4C L
         fcb   $4E N
         fcb   $28 (
         fcb   $78 x
         fcb   $29 )
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
         fcb   $2C ,
         fcb   $20
         fcb   $62 b
         fcb   $61 a
         fcb   $73 s
         fcb   $65 e
         fcb   $20
         fcb   $65 e
         fcb   $0D
         fcb   $40 @
         fcb   $4C L
         fcb   $4F O
         fcb   $47 G
         fcb   $28 (
         fcb   $78 x
         fcb   $29 )
         fcb   $20
         fcb   $20
         fcb   $6C l
         fcb   $6F o
         fcb   $67 g
         fcb   $2E .
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $78 x
         fcb   $2C ,
         fcb   $20
         fcb   $62 b
         fcb   $61 a
         fcb   $73 s
         fcb   $65 e
         fcb   $20
         fcb   $31 1
         fcb   $30 0
         fcb   $0D
         fcb   $40 @
         fcb   $45 E
         fcb   $58 X
         fcb   $50 P
         fcb   $28 (
         fcb   $78 x
         fcb   $29 )
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
         fcb   $40 @
         fcb   $53 S
         fcb   $51 Q
         fcb   $52 R
         fcb   $54 T
         fcb   $28 (
         fcb   $78 x
         fcb   $29 )
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
         fcc   "   Hit any key to see page 2"
         fcb   $0D
         fcb   $11
         fcc   "General:"
         fcb   $0D
         fcc   "@ABS(x)     absolute value of x"
         fcb   $0D
         fcc   "@INT(x)     integer part of x"
         fcb   $0D
         fcc   "@ROUND(d,x) round x, nearest d"
         fcb   $0D
         fcc   "   (d must be even power of 10)"
         fcb   $0D
         fcb   $0A
         fcc   "Series:"
         fcb   $0D
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
         fcb   $63 c
         fcb   $6F o
         fcb   $75 u
         fcb   $6E n
         fcb   $74 t
         fcb   $20
         fcb   $74 t
         fcb   $68 h
         fcb   $65 e
         fcb   $20
         fcb   $23 #
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $73 s
         fcb   $20
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
         fcb   $0D
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
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $73 s
         fcb   $20
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
         fcb   $0D
         fcb   $0A
         fcc   "   Hit any key to see page 3"
         fcb   $11
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
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $73 s
         fcb   $20
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
         fcb   $0D
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
         fcb   $2E .
         fcb   $0D
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $73 s
         fcb   $20
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
         fcb   $2C ,
         fcb   $0D
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
         fcb   $0D
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
         fcb   $0A
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
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $73 s
         fcb   $20
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
         fcb   $0D
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
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $6F o
         fcb   $66 f
         fcb   $20
         fcb   $63 c
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $73 s
         fcb   $20
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
         fcb   $0D
         fcb   $0A
         fcc   "   Hit any key to see page 4"
         fcb   $11
         fcc   "@NPV(r,x...y)    Net Present"
         fcb   $0D
         fcc   "        Value of cells, rate r"
         fcb   $0D
         fcb   $0A
         fcc   "Indexing:"
         fcb   $0D
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
         fcb   $0D
         fcb   $20
         fcb   $20
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
         fcb   $20
         fcb   $78 x
         fcb   $2E .
         fcb   $2E .
         fcb   $2E .
         fcb   $79 y
         fcb   $0D
         fcc   "@LOOKUP(n,x...y,z) '>' search -"
         fcb   $0D
         fcc   "   z optional - see manual"
         fcb   $0D
         fcc   "@INDEX(n,x...y,z)  '=' search -"
         fcb   $0D
         fcc   "   z optional - see manual"
 ifeq DYNAVERS-485
         fcb   $0D
         fcb   $0A
         fcc   "   Hit any key to see page 5"
         fcb   $11
         fcc   "Logical:"
         fcb   $0D
         fcc   "@NOT(x)     complement of x"
         fcb   $0D
         fcc   "@AND(x...y) true if all true"
         fcb   $0D
         fcc   "@OR(x...y)  true if any true"
         fcb   $0D
         fcc   "@EOR(x,y)   true if x/y differ"
         fcb   $0D
         fcc   "@IF(c,t,f)  evaluate c,"
         fcb   $0D
         fcc   "   if true, return t; else f"
         fcb   $0D
         fcc   "@ISNA(X)  true if cell x = >NA<"
         fcb   $0D
         fcc   "@ISERROR(x) true if x has error"
         fcb   $0D
         fcc   "@TRUE     return logical true"
         fcb   $0D
         fcc   "@FALSE    return logical false"
 endc
         fcb   $0D
         fcb   $0A
         fcc   "   Hit any key to exit Help"
         fcb   $00

M2544    fcc   "Arithmetic operators:"
         fcb   $0D
         fcb   $28 (
         fcb   $52 R
         fcb   $65 e
         fcb   $74 t
         fcb   $75 u
         fcb   $72 r
         fcb   $6E n
         fcb   $20
         fcb   $6E n
         fcb   $75 u
         fcb   $6D m
         fcb   $62 b
         fcb   $65 e
         fcb   $72 r
         fcb   $73 s
         fcb   $20
         fcb   $6F o
         fcb   $6E n
         fcb   $6C l
         fcb   $79 y
         fcb   $29 )
         fcb   $0D
         fcb   $0A
         fcb   $78 x
         fcb   $2B +
         fcb   $79 y
         fcb   $20
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
         fcc   "x^y  raises x to y power"
         fcb   $0D
         fcb   $0A
         fcc   "   Hit any key to see page 2"
 ifeq DYNAVERS-485
         fcb   $11
         fcc   "Logical operators:"
         fcb   $0D
         fcc   "(Return True/False only)"
         fcb   $0D
         fcb   $0A
         fcc   "x=y  true if x equals y"
         fcb   $0D
         fcc   "x<>y true if x doesn't equal y"
         fcb   $0D
         fcb   $78 x
         fcb   $3E >
         fcb   $79 y
         fcb   $20
         fcb   $20
         fcb   $74 t
         fcb   $72 r
         fcb   $75 u
         fcb   $65 e
         fcb   $20
         fcb   $69 i
         fcb   $66 f
         fcb   $20
         fcb   $78 x
         fcb   $20
         fcb   $67 g
         fcb   $72 r
         fcb   $65 e
         fcb   $61 a
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $20
         fcb   $74 t
         fcb   $68 h
         fcb   $61 a
         fcb   $6E n
         fcb   $20
         fcb   $79 y
         fcb   $0D
         fcb   $78 x
         fcb   $3E >
         fcb   $3D =
         fcb   $79 y
         fcb   $2C ,
         fcb   $78 x
         fcb   $3D =
         fcb   $3E >
         fcb   $79 y
         fcb   $20
         fcb   $74 t
         fcb   $72 r
         fcb   $75 u
         fcb   $65 e
         fcb   $20
         fcb   $69 i
         fcb   $66 f
         fcb   $20
         fcb   $78 x
         fcb   $20
         fcb   $69 i
         fcb   $73 s
         fcb   $20
         fcb   $67 g
         fcb   $72 r
         fcb   $65 e
         fcb   $61 a
         fcb   $74 t
         fcb   $65 e
         fcb   $72 r
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $74 t
         fcb   $68 h
         fcb   $61 a
         fcb   $6E n
         fcb   $20
         fcb   $6F o
         fcb   $72 r
         fcb   $20
         fcb   $65 e
         fcb   $71 q
         fcb   $75 u
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $79 y
         fcb   $0D
         fcb   $78 x
         fcb   $3C <
         fcb   $3D =
         fcb   $79 y
         fcb   $2C ,
         fcb   $78 x
         fcb   $3D =
         fcb   $3C <
         fcb   $79 y
         fcb   $20
         fcb   $74 t
         fcb   $72 r
         fcb   $75 u
         fcb   $65 e
         fcb   $20
         fcb   $69 i
         fcb   $66 f
         fcb   $20
         fcb   $78 x
         fcb   $20
         fcb   $69 i
         fcb   $73 s
         fcb   $20
         fcb   $6C l
         fcb   $65 e
         fcb   $73 s
         fcb   $73 s
         fcb   $0D
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $20
         fcb   $74 t
         fcb   $68 h
         fcb   $61 a
         fcb   $6E n
         fcb   $20
         fcb   $6F o
         fcb   $72 r
         fcb   $20
         fcb   $65 e
         fcb   $71 q
         fcb   $75 u
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $74 t
         fcb   $6F o
         fcb   $20
         fcb   $79 y
         fcb   $0D
         fcb   $0A
         fcc   "   Hit any key to see page 3"
 endc
         fcb   $11
         fcc   "  Maximum number of terms"
         fcb   $0D
         fcc   "(pending additions) is 11."
         fcb   $0D
         fcc   "  Parentheses within terms may"
         fcb   $0D
         fcc   "be nested to any depth."
         fcb   $0D
         fcc   "  To enter expression, first"
         fcb   $0D
         fcc   "character mustn't be alphabetic"
         fcb   $0D
         fcc   "For example, to enter A1+A2,"
         fcb   $0D
         fcc   "type '+A1+A2'."
         fcb   $0D
         fcc   "  To enter numeric as a label,"
         fcb   $0D
         fcc   "use leading single-quote (')."
         fcb   $0D
         fcb   $0A
         fcc   "   Hit any key to exit Help"
         fcb   $00

M270D    fcc   " >AE<  Bad argument error"
         fcb   $0D
         fcc   " >D0<  Divide by zero attempted"
         fcb   $0D
         fcc   " >ER<  General purpose error"
         fcb   $0D
         fcc   " >EX<  Exponent too large"
         fcb   $0D
         fcc   " >HO<  Holder overflow error"
         fcb   $0D

 ifeq DYNAVERS-485
         fcc   " >LG<  Logical error"
         fcb   $0D
 endc
         fcc   " >LN<  Negative/zero logarithm"
         fcb   $0D
         fcc   " >NA<  Not available"
         fcb   $0D
         fcc   " >NR<  Negative root attempted"
         fcb   $0D
         fcc   " >OV<  Overflow error"
         fcb   $0D
         fcc   " >RE<  Reference error"
         fcb   $0D
         fcc   " >RN<  Range error"
         fcb   $0D
         fcc   " >SN<  Syntax error"
         fcb   $00

ERRMSGS equ *
ERROR01  fcc   "Path table full"
         fcb   $00
ERROR02  fcc   "Illegal path number"
         fcb   $00
ERROR03  fcc   "Int. table full"
         fcb   $00
ERROR04  fcc   "Illegal I/O mode."
         fcb   $00
ERROR05  fcb   $44 D
         fcb   $65 e
         fcb   $76 v
         fcb   $69 i
         fcb   $63 c
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
         fcb   $00
ERROR06  fcc   "Illegal ID block"
         fcb   $00
ERROR07  fcb   $4D M
         fcb   $6F o
         fcb   $64 d
         fcb   $75 u
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $64 d
         fcb   $69 i
         fcb   $72 r
         fcb   $2E .
         fcb   $20
         fcb   $66 f
         fcb   $75 u
         fcb   $6C l
         fcb   $6C l
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
         fcb   $00
         fcb   $55 U
         fcb   $6E n
         fcb   $6B k
         fcb   $6E n
         fcb   $6F o
         fcb   $77 w
         fcb   $6E n
         fcb   $20
         fcb   $72 r
         fcb   $65 e
         fcb   $71 q
         fcb   $75 u
         fcb   $65 e
         fcb   $73 s
         fcb   $74 t
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
         fcb   $00
         fcb   $4E N
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
         fcb   $00
         fcb   $46 F
         fcb   $69 i
         fcb   $6C l
         fcb   $65 e
         fcb   $2F /
         fcb   $64 d
         fcb   $65 e
         fcb   $76 v
         fcb   $2E .
         fcb   $20
         fcb   $6E n
         fcb   $6F o
         fcb   $74 t
         fcb   $20
         fcb   $66 f
         fcb   $6F o
         fcb   $75 u
         fcb   $6E n
         fcb   $64 d
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
         fcb   $00
         fcb   $46 F
         fcb   $69 i
         fcb   $6C l
         fcb   $65 e
         fcb   $20
         fcb   $61 a
         fcb   $6C l
         fcb   $72 r
         fcb   $65 e
         fcb   $61 a
         fcb   $64 d
         fcb   $79 y
         fcb   $20
         fcb   $65 e
         fcb   $78 x
         fcb   $69 i
         fcb   $73 s
         fcb   $74 t
         fcb   $73 s
         fcb   $00
         fcb   $49 I
         fcb   $6C l
         fcb   $6C l
         fcb   $65 e
         fcb   $67 g
         fcb   $61 a
         fcb   $6C l
         fcb   $20
         fcb   $61 a
         fcb   $64 d
         fcb   $64 d
         fcb   $72 r
         fcb   $65 e
         fcb   $73 s
         fcb   $73 s
         fcb   $00
ERROR21  fcc   "Illegal block size"
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
         fcb   $6D m
         fcb   $6F o
         fcb   $64 d
         fcb   $75 u
         fcb   $6C l
         fcb   $65 e
         fcb   $00
         fcb   $53 S
         fcb   $65 e
         fcb   $63 c
         fcb   $74 t
         fcb   $6F o
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
         fcb   $00
ERROR28  fcc   "Illegal SWI code"
         fcb   $00
ERROR29  fcc   "Keyboard abort"
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
         fcb   $61 a
         fcb   $72 r
         fcb   $65 e
         fcb   $61 a
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
         fcb   $2E .
         fcb   $00
         fcb   $4E N
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
         fcb   $00
         fcb   $53 S
         fcb   $65 e
         fcb   $63 c
         fcb   $74 t
         fcb   $6F o
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
         fcb   $00
ERROR40  fcc   "Read error"
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
         fcb   $00
ERROR44  fcc   "Media full"
         fcb   $00
         fcb   $44 D
         fcb   $65 e
         fcb   $76 v
         fcb   $69 i
         fcb   $63 c
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
         fcb   $00
         fcb   $44 D
         fcb   $65 e
         fcb   $76 v
         fcb   $69 i
         fcb   $63 c
         fcb   $65 e
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
ERROR48  fcc   "Indirect file error"
         fcb   $00
ERROR49  fcc   "Indirect file"
         fcb   $00
ERROR50  fcc   "Unknown error code"
         fcb   $00

* Offsets to error codes
ERRTBL   fdb   ERROR01-ERRMSGS
         fdb   $0010
         fdb   $0024
         fdb   $0034
         fdb   $0046
         fdb   $0056
         fdb   $0067
         fdb   $0078
         fdb   $0084
         fdb   $0094
         fdb   $00A0
         fdb   $00AD
         fdb   $00B9
         fdb   $00CC
         fdb   $00DE
         fdb   $00EC
         fdb   $00FA
         fdb   $010E
         fdb   $0122
         fdb   $0136
         fdb   $0146
         fdb   $0159
         fdb   $016D
         fdb   $0181
         fdb   $0194
         fdb   $01A7
         fdb   $01BB
         fdb   $01C7
         fdb   $01D8
         fdb   $01E7
         fdb   $01FA
         fdb   $020C
         fdb   $0219
         fdb   $0228
         fdb   $023B
         fdb   ERROR50-ERRMSGS $0324
         fdb   ERROR50-ERRMSGS $0324
         fdb   ERROR50-ERRMSGS $0324
         fdb   ERROR50-ERRMSGS $0324
         fdb   ERROR50-ERRMSGS $0324
         fdb   $024F
         fdb   $0263
         fdb   $0277
         fdb   $0285
         fdb   $0294
         fdb   $029F
         fdb   $02AB
         fdb   $02BC
         fdb   $02C7
         fdb   $02D2
         fdb   $02E3
         fdb   $02EF
         fdb   $0302
         fdb   $0316
         fdb   ERROR50-ERRMSGS $0324

HELPTBL  fdb   $0000
         fdb   M12EE-HELPS $0258
         fdb   $14B0
         fdb   $07FA
         fdb   $03FB
         fdb   $0928
         fdb   $0869
         fdb   $06BE
         fdb   $0D5B
         fdb   $0659
         fdb   $0C40
         fdb   $03B6
         fdb   $05DD
         fdb   $0A5B
         fdb   $0F04
         fdb   $17C1
         fdb   $0E03
         fdb   $0E9A

