 opt m
*
* Terminal characteristics for WordPak
*
M0088    fcb   $1B,$2E,$31,$FF    Cursor on
M008C    fcb   $1B,$2E,$30,$FF    Cursor off
M0090    fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   Terminal setup
         fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
M00A0    fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   Terminal kiss-off
M00A8    fcb   $FF,$FF,$FF,$FF    Cursor right
         fcb   $FF,$FF,$FF,$FF    Cursor ??
CURSPOS  fcb   $14,$99,$88,$FF    Cyrsor XY
         fcb   $FF,$FF,$FF,$FF
M00B8    fcb   $05,$FF,$FF,$FF,$FF,$FF    Cursor clear to EOL
M00BE    fcb   $13,$FF,$FF,$FF,$FF,$FF    Cursor clear to end of screen
REVON    fcb   $06,$FF,$FF,$FF,$FF,$FF,$FF,$FF    Reverse on
REVOFF   fcb   $06,$FF,$FF,$FF,$FF,$FF,$FF,$FF    Reverse off
M00D4    fcb   $08,$20,$08,$FF,$FF,$FF  Destructive backspace
M00DA    fcb   $08,$FF,$FF,$FF   non-destructive backspace
M00DE    fcc   "Color Computer  "  Terminal name (16 chars)
M00EE    fcb   $04
         fcb   $FF
M00F0    fcb   $FF
         fcb   $FF
         fcb   $00
         fcb   $00
         fcb   $00
         fcb   $FF
         fcb   $FF
M00F7    fcb   $13  Log-off key
M00F8    fcb   $00  Upper case only
         fcb   $00  line feeds after each line
M00FA    fcb   $00
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
         fcb   $19     Jump window (Ctrl-Y)
M0106    fcb   $07   Bell character
GETADDR  fcb   $11   Get address
         fcb   $7C   Flush type-ahead buffer (|)
         fcb   $05   Backspace key
         fcb   $20   direct cursor addressing row offset
         fcb   $20   direct cursor addressing columns offset
M010C    fcb   $02
         fcb   25   number of rows on screen
         fcb   79   number of columns on screen
         fcb   $12  Edit overlay (Ctrl-R)
M0110    fcb   $01  Flush type-ahead buffer
         fcb   $1A  Edit from entry level (Ctrl-Z)

 fcc "/P"
 fcb 0
