* Texts are set to max 80 characters per line
* These texts come primarily from the FLEX edition of Dynacalc
*                       INCOMPLETE

HELPS    fcc   "A  set Attributes"
         fcb   $0D
M1083    fcc   "B  Blank current cell"
         fcb   $0D
M1099    fcc   "C  Clear entire work worksheet"
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
         fcc   "R  Replicate cell or group of cells to new location"
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
         fcc   "R  toggles Auto/Manual Recalculate feature (default = A)"
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
         fcc   "C  Continuous - characters repeated throughout cell"
         fcb   $0D
         fcc   "D  Default - uses window format"
         fcb   $0D
         fcc   "G  General - free format (labels left, numbers right)"
         fcb   $0D
         fcc   "I  Integer - rounds DISPLAY to nearest integer"
         fcb   $0D
         fcc   "L  Left justify - forces number to left of cell"
         fcb   $0D
         fcc   "P  Plot - uses cell's integer value as number of graph chars. to print"
         fcb   $0D
         fcc   "R  Right justify - forces label to right of cell"
         fcb   $0D
         fcc   "$  Dollar - rounds DISPLAY to nearest cent"
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
         fcc   "L  Load worksheet from disk - overlays current sheet"
         fcb   $0D
         fcc   "S  Save current worksheet to disk"
         fcb   $0D
         fcc   "   Save and Load both default to .cal in current directory"
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
         fcc   "H  set up row(s) above cursor as Horizontal title area"
         fcb   $0D
         fcc   "N  No titles"
         fcb   $0D
         fcc   "V  set up column(s) to left of cursor as Vertical title area"
         fcb   $0D
         fcb   $00
         fcc   "Windows:"
         fcb   $0D
         fcb   $0A
         fcc   "D  toggle value/formula Display flag (defaults to value)"
         fcb   $0D
         fcc   "F  sets default Format of all cells in current window"
         fcb   $0D
         fcc   "H  divides screen Horizontally into two windows at current location"
         fcb   $0D
         fcc   "N  No division - returns display to single window"
         fcb   $0D
         fcc   "S  Synchronizes motion of two windows"
         fcb   $0D
         fcc   "U  Unsynchronizes motion of two windows (default)"
         fcb   $0D
         fcc   "V  divides screen Vertically into two windows at current location"
         fcb   $0D
         fcb   $00
M1BC7
         fcc   "Set default format of current window:"
         fcb   $0D
         fcb   $0A
         fcc   "C  Continuous - characters repeated throughout cell"
         fcb   $0D
         fcc   "D  Default - general format (see)"
         fcb   $0D
         fcc   "G  General - free-format (labels left, numbers right)"
         fcb   $0D
         fcc   "I  Integer - rounds DISPLAY to nearest integer"
         fcb   $0D
         fcc   "L  Left justify - forces number to left of cell"
         fcb   $0D
         fcc   "P  Plot - uses cell's integer value as number of graph chars. to print"
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
         fcc   "W  allows changing default width of all columns in current Window"
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
         fcc   "A  Sort columns/rows in the given range in Ascending order"
         fcb   $0D
         fcc   "D  Sort columns/rows in the given range in Descending order"
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
M20BB    fcc   "Trigonometric:    @SIN      @ASIN       @PI (3.14...)"
         fcb   $0D
M20EB    fcc   "(All angles       @COS      @ACOS       radians = degrees/(180/PI)"
         fcb   $0D
         fcc   "   in radians)    @TAN      @ATAN       degrees = radians*(180/PI)"
         fcb   $0D
         fcb   $0A
         fcc   "Logarithmic:      @LOG(x)      logarithm of x to base 10"
         fcb   $0D
         fcc   "                  @LN(x)       logarithm of x to base e (2.718...)"
         fcb   $0D
         fcc   "                  @EXP(x)      e raised to x power"
         fcb   $0D
         fcc   "                  @SQRT(x)     square root x"
         fcb   $0D
         fcb   $0A
         fcc   "General:          @ABS(x)      absolute value of x"
         fcb   $0D
         fcc   "                  @INT(x)      integer part of x"
         fcb   $0D
         fcc   "                  @ROUND(d,x)  x rounded to nearest d"
         fcb   $0D
         fcc   "                               (d must be even power of 10)"
         fcb   $0D
         fcb   $0A
         fcc   "               Hit any key to see page 2"
         fcb   $0D
         fcb   $11
         fcc   "Series:   @COUNT(x...y)    number of cells in range x...y"
         fcb   $0D
         fcc   "          @SUM(x...y)      sum of values of cells in range x...y"
         fcb   $0D
         fcc   "          @AVERAGE(x...y)  average value of cells in range x...y"
         fcb   $0D
         fcc   "          @STDDEV(m,x...y) standard deviation of cells in range x...y,"
         fcb   $0D
         fcc   "                           m sets method:  <0 = population;  >=0 = sample"
         fcb   $0D
         fcc   "          @MIN(x...y)      least value of cells in range x...y"
         fcb   $0D
         fcc   "          @MAX(x...y)      greatest value of cells in range x...y"
         fcb   $0D
         fcc   "          @NPV(r,x...y)    Net Present Value of cells in range x...y at rate r"
         fcb   $0D
         fcc   "Indexing: @CHOOSE(n,x...y) value of nth cell in range x...y"
         fcb   $0D
         fcc   "          @LOOKUP(n,x...y,z) '>' search - z optional - see manual"
         fcb   $0D
         fcc   "          @INDEX(n,x...y,z)  '=' search - z optional - see manual"
         fcb   $0D
         fcc   "Error:    @ERROR           causes >ER< message (general use)"
         fcb   $0D
         fcc   "          @NA              causes >NA< message (not available)"
         fcb   $0D
         fcb   $0A
         fcc   "                   Hit ESCAPE key to exit Help"
         fcb   $0D
         fcb   $00
         fcc   "Arithmetic operators: x+y  adds x and y"
         fcb   $0D
         fcc   "                      x-y  subtracts y from x  (use 0-x for monadic minus)"
         fcb   $0D
         fcc   "                      x*y  multiplies x by y"
         fcb   $0D
         fcc   "                      x/y  divides x by y"
         fcb   $0D
         fcc   "                      x^y  raises x to y power"
         fcb   $0D
         fcb   $0A
         fcc   "Maximum number of terms (pending additions) is 11"
         fcb   $0D
         fcb   $0A
         fcc   "Parentheses in terms may be nested to any depth"
         fcb   $0D
         fcb   $0A
         fcc   "To enter expression, first character must not be alphabetic"
         fcb   $0D
         fcc   "   For example, to enter A1+A2, type '+A1+A2'"
         fcb   $0D
         fcb   $0A
         fcc   "To enter numeric as a label, use leading single-quote (')"
         fcb   $0D
         fcb   $0A
         fcc   "                  Hit ESCAPE key to exit Help"
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

M2CD5    fcb   $00       This label is used
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
