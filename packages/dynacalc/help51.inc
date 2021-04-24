* Texts are shortened to max 51 characters per line
* Start at $1071
HELPS fcc   "A  set Attributes"
 fcb   $0D
 fcc   "B  Blank current cell"
 fcb   $0D
 fcc   "C  Clear entire worksheet"
 fcb   $0D
 fcc   "D  Delete current column or row"
 fcb   $0D
 fcc   "E  Edit contents of current cell"
 fcb   $0D
 fcc   "F  set Format of current cell"
 fcb   $0D
 fcc   "I  Insert new column or row at current position"
 fcb   $0D
 fcc   "L  Locate specified label "
 fcb   $0D
 fcc   /   (?="Wild card", @="Don't ignore case")/
 fcb   $0D
 fcc   "M  Move column or row to new position"
 fcb   $0D
 fcc   "P  Print all or portion of worksheet to"
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

H.ATTRS fcc   "Set Attributes:"
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

H.DEL fcb   $0A
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

H.CFMT fcc   "Set Format of current cell:"
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
 ifeq LANG-LGENUK
 fcc   "$  Money - rounds DISPLAY to nearest penny"
 else
 fcc   "$  Dollar - rounds DISPLAY to nearest cent"
 endc
 fcb   $0D
 fcb   $00

H.INS fcb   $0A
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

H.QUIT fcb   $0A
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

H.SYSTM fcc   "System:"
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

H.SAVE fcb   $0A
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

H.TITLE fcb   $0A
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

H.WINDOW fcc   "Windows:"
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

H.WFMT fcc   "Set default format of current window:"
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

H.PRINT fcc   "Printer attributes:"
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

H.WIDTH fcb   $0A
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

H.MOVE fcb   $0A
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

H.ORDER fcb   $0A
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

H.TRIG fcc   "Trigonometric:"
 fcb   $0D
 fcc   "  @SIN      @ASIN     @PI (3.14)"
 fcb   $0D
 fcc   "  @COS      @ACOS "
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

H.ARIT fcc   "Arithmetic operators:"
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

H.ERRMSG fcc   "       DYNACALC Error Messages"
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

* Error messages at $28BF
ERRMSGS equ *
ERROR01  fcc   "Path table full."
 fcb   $00
ERROR02  fcc   "Illegal path number."
 fcb   $00
ERROR03  fcc   "Interrupt polling table full."
 fcb   $00
ERROR04  fcc   "Illegal I/O mode."
 fcb   $00
ERROR05  fcc   "Device table overflow."
 fcb   $00
ERROR06  fcc   "Illegal module ID block."
 fcb   $00
ERROR07  fcc   "Module directory full."
 fcb   $00
ERROR08  fcc   "Memory full."
 fcb   $00
ERROR09  fcc   "Unknown service request."
 fcb   $00
ERROR10  fcc   "Module busy."
 fcb   $00
ERROR11  fcc   "Bad boundary."
 fcb   $00
ERROR12  fcc   "End of file."
 fcb   $00
ERROR13  fcc   "Returning non-allocated memory."
 fcb   $00
ERROR14  fcc   "Non-existing segment."
 fcb   $00
ERROR15  fcc   "No permission- access denied."
 fcb   $00
ERROR16  fcc   "Bad path name."
 fcb   $00
ERROR17  fcc   "The file/device cannot be found."
 fcb   $00
ERROR18  fcc   "Segment list filled."
 fcb   $00
ERROR19  fcc   "Creating existing file."
 fcb   $00
ERROR20  fcc   "Illegal block address."
 fcb   $00
ERROR21  fcc   "Illegal block size."
 fcb   $00
ERROR22  fcc   "Link to a non-existing module."
 fcb   $00
ERROR23  fcc   "Sector number out of range."
 fcb   $00
ERROR24  fcc   "Deallocating stack memory."
 fcb   $00
ERROR25  fcc   "Illegal process ID."
 fcb   $00
ERROR26  fcc   "Illegal signal code."
 fcb   $00
ERROR27  fcc   "No children."
 fcb   $00
ERROR28  fcc   "Illegal SWI code."
 fcb   $00
ERROR29  fcc   "Keyboard abort."
 fcb   $00
ERROR30  fcc   "Process table full."
 fcb   $00
ERROR31  fcc   "Illegal fork parameter area."
 fcb   $00
ERROR32  fcc   "Known module."
 fcb   $00
ERROR33  fcc   "Bad module CRC."
 fcb   $00
ERROR34  fcc   "Unprocessed signal pending."
 fcb   $00
ERROR35  fcc   "Non-executable module."
 fcb   $00
ERROR36  fcc   "Unit number out of range."
 fcb   $00
ERROR37  fcc   "Sector number out of range."
 fcb   $00
ERROR38  fcc   "Write protect."
 fcb   $00
ERROR39  fcc   "Checksum error."
 fcb   $00
ERROR40  fcc   "Read error."
 fcb   $00
ERROR41  fcc   "Write error."
 fcb   $00
ERROR42  fcc   "Device not ready."
 fcb   $00
ERROR43  fcc   "Seek error."
 fcb   $00
ERROR44  fcc   "Media full."
 fcb   $00
ERROR45  fcc   "Device/media type mismatch."
 fcb   $00
ERROR46  fcc   "Device busy."
 fcb   $00
ERROR47  fcc   "Device/media ID changed."
 fcb   $00
ERROR48  fcc   "Indirect file error."
 fcb   $00
ERROR49  fcc   "Indirect file was accessed."
 fcb   $00
ERROR50  fcc   "Unknown error code."
 fcb   $00

* Offsets to error codes
ERRTBL fdb   ERROR01-ERRMSGS
 fdb   ERROR02-ERRMSGS
 fdb   ERROR03-ERRMSGS
 fdb   ERROR04-ERRMSGS
 fdb   ERROR05-ERRMSGS
 fdb   ERROR06-ERRMSGS
 fdb   ERROR07-ERRMSGS
 fdb   ERROR08-ERRMSGS
 fdb   ERROR09-ERRMSGS
 fdb   ERROR10-ERRMSGS
 fdb   ERROR11-ERRMSGS
 fdb   ERROR12-ERRMSGS
 fdb   ERROR13-ERRMSGS
 fdb   ERROR14-ERRMSGS
 fdb   ERROR15-ERRMSGS
 fdb   ERROR16-ERRMSGS
 fdb   ERROR17-ERRMSGS
 fdb   ERROR18-ERRMSGS
 fdb   ERROR19-ERRMSGS
 fdb   ERROR20-ERRMSGS
 fdb   ERROR21-ERRMSGS
 fdb   ERROR22-ERRMSGS
 fdb   ERROR23-ERRMSGS
 fdb   ERROR24-ERRMSGS
 fdb   ERROR25-ERRMSGS
 fdb   ERROR26-ERRMSGS
 fdb   ERROR27-ERRMSGS
 fdb   ERROR28-ERRMSGS
 fdb   ERROR29-ERRMSGS
 fdb   ERROR30-ERRMSGS
 fdb   ERROR31-ERRMSGS
 fdb   ERROR32-ERRMSGS
 fdb   ERROR33-ERRMSGS
 fdb   ERROR34-ERRMSGS
 fdb   ERROR35-ERRMSGS $02E0
 fdb   ERROR50-ERRMSGS $0402
 fdb   ERROR50-ERRMSGS $0402
 fdb   ERROR50-ERRMSGS $0402
 fdb   ERROR50-ERRMSGS $0402
 fdb   ERROR50-ERRMSGS $0402
 fdb   ERROR36-ERRMSGS $02F7
 fdb   ERROR37-ERRMSGS
 fdb   ERROR38-ERRMSGS
 fdb   ERROR39-ERRMSGS
 fdb   ERROR40-ERRMSGS
 fdb   ERROR41-ERRMSGS
 fdb   ERROR42-ERRMSGS
 fdb   ERROR43-ERRMSGS
 fdb   ERROR44-ERRMSGS
 fdb   ERROR45-ERRMSGS
 fdb   ERROR46-ERRMSGS
 fdb   ERROR47-ERRMSGS
 fdb   ERROR48-ERRMSGS
 fdb   ERROR49-ERRMSGS
 fdb   ERROR50-ERRMSGS $0402

HELPTBL  fdb   HELPS-HELPS
 fdb   H.ATTRS-HELPS $027D
 fdb   H.ARIT-HELPS $14D3
 fdb   H.SAVE-HELPS $0890
 fdb   H.CFMT-HELPS $04D9
 fdb   H.WINDOW-HELPS $09C0
 fdb   H.TITLE-HELPS $08FE
 fdb   H.SYSTM-HELPS $075F
 fdb   H.WIDTH-HELPS $0E7F
 fdb   H.QUIT-HELPS $06FC
 fdb   H.PRINT-HELPS $0D08
 fdb   H.DEL-HELPS $048F
 fdb   H.INS-HELPS $067F
 fdb   H.WFMT-HELPS $0B56
 fdb   H.TRIG-HELPS $104A
 fdb   H.ERRMSG-HELPS  $169C
 fdb   H.MOVE-HELPS $0F37
 fdb   H.ORDER-HELPS $0FE6
ENDHELP equ *    at 2D67
