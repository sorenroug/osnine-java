*
* Terminal characteristics for an Lear-Siegler ADM-5 terminal
* For T/F values, $FF is False, $00 is True
* Sequences must always end with $FF
* $88 is placeholder for X (column) value
* $99 is placeholder for Y (row) value

 opt m

TRUE equ $00
FALSE equ $FF
CTRL equ $40

* Only use cursor on/off is the cursor doesn't blink
 fcb   $FF,$FF,$FF,$FF    Cursor on (3 bytes)
 fcb   $FF,$FF,$FF,$FF    Cursor off (3 bytes)

 fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   Terminal setup (15 bytes)
 fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   Terminal kiss-off (7 bytes)

* Used if printer is attached to terminal
 fcb   $FF,$FF,$FF,$FF    Sequence to turn on printer (3 bytes)
 fcb   $FF,$FF,$FF,$FF    Sequence to turn off printer (3 bytes)

 fcb   $1B,$3D,$99,$88,$FF,$FF,$FF,$FF    Cyrsor addressing (7 bytes)
 fcb   $1B,$54,$FF,$FF,$FF,$FF    Cursor clear to EOL (5 bytes)
 fcb   $1B,$59,$FF,$FF,$FF,$FF    Cursor clear to end of screen (5 bytes)
 fcb   $1B,$47,$FF,$FF,$FF,$FF,$FF,$FF    Hilite on (7 bytes)
 fcb   $1B,$47,$FF,$FF,$FF,$FF,$FF,$FF    Hilite off (7 bytes)
 fcb   $08,$20,$08,$FF,$FF,$FF  Destructive backspace (5 bytes)
 fcb   $08,$FF,$FF,$FF   non-destructive backspace (3 bytes)
 fcc   "ADM-5           "  Terminal name (16 chars)
 fcb   $04
 fcb   $00
 fcb   $00
 fcb   $00
 fcb   $00
 fcb   $00
 fcb   $00
 fcb   $00
 fcb   $00
 fcb   'D-CTRL  Log-off key (Ctrl-D)
 fcb   TRUE Upper case only T/F
 fcb   0  Number of line feeds after each line
 fcb   $00
 fcb   TRUE Keep helps  T/F
 fcb   FALSE print borders  T/F
 fcb   79   Printer page width
 fcb   TRUE Pagination  T/F
 fcb   57   Lines per printer page
 fcb   'K-CTRL  Up-arrow
 fcb   'J-CTRL  Down-arrow
 fcb   'H-CTRL  Left-arrow
 fcb   'L-CTRL  Right-arrow
 fcb   '^-CTRL  Home key    (Ctrl-^)
 fcb   '^  Jump window (^)
 fcb   'G-CTRL  Bell character
 fcb   'Z-CTRL  Get address (Ctrl-Z)
 fcb   'C-CTRL  Flush type-ahead buffer (Ctrl-C)
 fcb   $7F  Backspace key
 fcb   $20  Direct cursor addressing row offset
 fcb   $20  Direct cursor addressing columns offset
 fcb   $02
 fcb   24   Number of rows on screen
 fcb   79   Number of columns on screen
 fcb   'O-CTRL  Edit overlay (Ctrl-O)
 fcb   'C-CTRL  Flush type-ahead buffer (Ctrl-C)
 fcb   'E-CTRL  Edit from entry level (Ctrl-E)

 fcc "/P"
 fcb 0
