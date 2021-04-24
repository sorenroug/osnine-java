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
 ifeq DYNAVERS-$485
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

H.ATTRS    fcc   "Set attributes:"
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


H.DEL    fcc   "Delete column/row:"
 fcb   $0D
 fcb   $0A
 fcc   "C  deletes current Column"
 fcb   $0D
 fcc   "R  deletes current Row"
 fcb   $00

H.CFMT    fcc   "Set Format of current cell:"
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
 fcc   "I  Integer - rounds DISPLAY to"
 fcb   $0D
 fcc   "   nearest integer"
 fcb   $0D
 fcc   "L  Left justify - forces number"
 fcb   $0D
 fcc   "   to left of cell"
 fcb   $0D
 fcb   $0A
 fcc   "   Hit any key to see page 2"
 fcb   $11
 fcc   "P  Plot - uses cell's integer"
 fcb   $0D
 fcc   "   value as number of graph"
 fcb   $0D
 fcc   "   characters to print"
 fcb   $0D
 fcc   "R  Right justify - forces label"
 fcb   $0D
 fcc   "   to right of cell"
 fcb   $0D
 fcc   "$  Dollar - rounds DISPLAY to"
 fcb   $0D
 fcc   "   nearest cent"
 fcb   $00

H.INS    fcc   "Insert new column or row:"
 fcb   $0D
 fcb   $0A
 fcc   "C  insert new blank Column"
 fcb   $0D
 fcc   "   at current position"
 fcb   $0D
 fcc   "R  insert new blank Row"
 fcb   $0D
 fcc   "   at current position"
 fcb   $00

H.QUIT    fcc   "Quit:"
 fcb   $0D
 fcb   $0A
 fcc   "O  leave DYNACALC and return"
 fcb   $0D
 fcc   "   to OS-9"
 fcb   $0D
 fcb   $0A
 fcc   "S  puts computer to Sleep until"
 fcb   $0D
 fcc "   any key is struck"
 fcb   $00

H.SYSTM    fcc   "System:"
 fcb   $0D
 fcb   $0A
 fcc   "C  Change the current directory"
 fcb   $0D
 fcc   "L  Load worksheet from disk-"
 fcb   $0D
 fcc   "   overlays current sheet"
 fcb   $0D
 fcc   "S  Save current sheet to disk"
 fcb   $0D
 fcc   "     Save and Load both default"
 fcb   $0D
 fcc   "     to .cal in work directory"
 fcb   $0D
 fcc   "X  eXecute OS-9 command"
 fcb   $0D
 fcc   "#  data file save/load-"
 fcb   $0D
 fcc   "   for data exchange"
 fcb   $0D
 fcc   "     both default to the cur-"
 fcb   $0D
 fcc   "     rent working directory"
 fcb   $00

H.SAVE    fcc   "Save data:"
 fcb   $0D
 fcb   $0A
 fcc   "L  Load labels and CALCULATED"
 fcb   $0D
 fcc   "   Values from disk"
 fcb   $0D
 fcb   $0A
 fcc   "S  Save labels and CALCULATED"
 fcb   $0D
 fcc   "   Values to disk"
 fcb   $00

H.TITLE    fcc   "Titles:"
 fcb   $0D
 fcb   $0A
 fcc   "B  set up Both horizontal and"
 fcb   $0D
 fcc   "   vertical titles"
 fcb   $0D
 fcc   "H  set up row(s) above cursor"
 fcb   $0D
 fcc   "   as Horizontal title area"
 fcb   $0D
 fcc   "N  No titles"
 fcb   $0D
 fcc   "V  set up column(s) to left of"
 fcb   $0D
 fcc   "   cursor as Vertical title(s)"
 fcb   $00

H.WINDOW    fcc   "Windows:"
 fcb   $0D
 fcb   $0A
 fcc   "D  toggle value/formula Display"
 fcb   $0D
 fcc   "F  set default Format of all"
 fcb   $0D
 fcc   "   cells in current window"
 fcb   $0D
 fcc   "H  divides screen Horizontally"
 fcb   $0D
 fcc   "N  No division - returns dis-"
 fcb   $0D
 fcc   "   play to single window"
 fcb   $0D
 fcc   "S  Synchronizes motion of"
 fcb   $0D
 fcc   "   two windows"
 fcb   $0D
 fcc   "U  Unsynchronizes motion of"
 fcb   $0D
 fcc   "   two windows (default)"
 fcb   $0D
 fcc   "V  divides screen Vertically"
 fcb   $00

H.WFMT    fcc   "Set default format of window:"
 fcb   $0D
 fcb   $0A
 fcc   "C  Continuous - characters"
 fcb   $0D
 fcc   "   repeated throughout cell"
 fcb   $0D
 fcc   "D  Default - use general format"
 fcb   $0D
 fcc   "G  General - free-format"
 fcb   $0D
 fcc   "   (labels left, numbers right)"
 fcb   $0D
 fcc   "I  Integer - rounds DISPLAY to"
 fcb   $0D
 fcc   "   nearest integer"
 fcb   $0D
 fcc   "L  Left justify - forces number"
 fcb   $0D
 fcc   "   to left of cell"
 fcb   $0D
 fcb   $0A
 fcc   "   Hit any key to see page 2"
 fcb   $11
 fcc "P  Plot - uses cell's integer"
 fcb   $0D
 fcc "   value as number of graph"
 fcb   $0D
 fcc "   characters to print"
 fcb   $0D
 fcc   "R  Right justify - forces label"
 fcb   $0D
 fcc   "   to right of cell"
 fcb   $0D
 fcc   "$  Dollar - rounds DISPLAY to"
 fcb   $0D
 fcc   "   nearest cent"
 fcb   $00
         
H.PRINT    fcc   "Printer attributes:"
 fcb   $0D
 fcb   $0A
 fcc   "B  toggle Border flag on/off"
 fcb   $0D
 fcc   "   (defaults to off)"
 fcb   $0D
 fcc   "C  Clears the printer file name"
 fcb   $0D
 fcc   "L  set Length of page"
 fcb   $0D
 fcc   "   (defaults to 58 lines)"
 fcb   $0D
 fcc   "P  toggle Pagination on/off"
 fcb   $0D
 fcc   "   (defaults to on)"
 fcb   $0D
 fcc   "S  set the Spaces between lines"
 fcb   $0D
 fcc   "W  set Width of page"
 fcb   $0D
 fcc   "   (defaults to 80 characters)"
 fcb   $00

H.WIDTH    fcc   "Width:"
 fcb   $0D
 fcb   $0A
 fcc   "C  changes width of"
 fcb   $0D
 fcc   "   current Column"
 fcb   $0D
 fcc   "   (defaults to Window value)"
 fcb   $0D
 fcb   $0A
 fcc "W  changes default width of all"
 fcb   $0D
 fcc "   columns in current Window"
 fcb   $0D
 fcc   "   (defaults to 9 characters)"
 fcb   $00

H.MOVE    fcc   "Move column/row:"
 fcb   $0D
 fcb   $0A
 fcc   "A  sort columns/rows in range"
 fcb   $0D
 fcc   "   in Ascending order"
 fcb   $0D
 fcc   "D  sort columns/rows in range"
 fcb   $0D
 fcc   "   in Descending order"
 fcb   $0D
 fcc   "M  Manually move column/row"
 fcb   $00

H.ORDER    fcc   "Order:"
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

H.TRIG    fcc   "Trigonometric:"
 fcb   $0D
 fcc   "@SIN    @ASIN     @PI (3.14...)"
 fcb   $0D
 fcc   "@COS    @ACOS "
 fcb   $0D
 fcc   "@TAN    @ATAN "
 fcb   $0D
 fcb   $0A
 fcc   "Logarithmic:"
 fcb   $0D
 fcc   "@LN(x)   logarithm of x, base e"
 fcb   $0D
 fcc   "@LOG(x)  log. of x, base 10"
 fcb   $0D
 fcc   "@EXP(x)  e raised to x power"
 fcb   $0D
 fcc   "@SQRT(x) square root x"
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
 fcc   "@COUNT(x...y)   count the #"
 fcb   $0D
 fcc   "      of cells in range x...y"
 fcb   $0D
 fcc   "@SUM(x...y)     sum of values"
 fcb   $0D
 fcc   "      of cells in range x...y"
 fcb   $0D
 fcb   $0A
 fcc   "   Hit any key to see page 3"
 fcb   $11
 fcc   "@AVERAGE(x...y)  average value"
 fcb   $0D
 fcc   "      of cells in range x...y"
 fcb   $0D
 fcc   "@STDDEV(m,x...y) standard dev."
 fcb   $0D
 fcc   "of cells in range x...y,"
 fcb   $0D
 fcc   "  m sets method:"
 fcb   $0D
 fcc   "  <0 = population; >=0 = sample"
 fcb   $0D
 fcb   $0A
 fcc   "@MIN(x...y)      least value"
 fcb   $0D
 fcc   "        of cells in range x...y"
 fcb   $0D
 fcc   "@MAX(x...y)      greatest value"
 fcb   $0D
 fcc   "        of cells in range x...y"
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
 fcc   "@CHOOSE(n,x...y) value of nth"
 fcb   $0D
 fcc   "   cell in range x...y"
 fcb   $0D
 fcc   "@LOOKUP(n,x...y,z) '>' search -"
 fcb   $0D
 fcc   "   z optional - see manual"
 fcb   $0D
 fcc   "@INDEX(n,x...y,z)  '=' search -"
 fcb   $0D
 fcc   "   z optional - see manual"
 ifeq DYNAVERS-$485
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

H.ARIT    fcc   "Arithmetic operators:"
 fcb   $0D
 fcc   "(Return numbers only)"
 fcb   $0D
 fcb   $0A
 fcc   "x+y  adds x and y"
 fcb   $0D
 fcc   "x-y  subtracts y from x"
 fcb   $0D
 fcc   "  (use 0-x for monadic minus)"
 fcb   $0D
 fcc   "x*y  multiplies x by y"
 fcb   $0D
 fcc   "x/y  divides x by y"
 fcb   $0D
 fcc   "x^y  raises x to y power"
 fcb   $0D
 fcb   $0A
 fcc   "   Hit any key to see page 2"
 ifeq DYNAVERS-$485
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
 fcc   "x>y  true if x greater than y"
 fcb   $0D
 fcc   "x>=y,x=>y true if x is greater"
 fcb   $0D
 fcc   "     than or equal to y"
 fcb   $0D
 fcc   "x<=y,x=<y true if x is less"
 fcb   $0D
 fcc   "     than or equal to y"
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

H.ERRMSG    fcc   " >AE<  Bad argument error"
 fcb   $0D
 fcc   " >D0<  Divide by zero attempted"
 fcb   $0D
 fcc   " >ER<  General purpose error"
 fcb   $0D
 fcc   " >EX<  Exponent too large"
 fcb   $0D
 fcc   " >HO<  Holder overflow error"
 fcb   $0D

 ifeq DYNAVERS-$485
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
ERROR05  fcc   "Device overflow"
 fcb   $00
ERROR06  fcc   "Illegal ID block"
 fcb   $00
ERROR07  fcc   "Module dir. full"
 fcb   $00
ERROR08  fcc   "Memory full"
 fcb   $00
ERROR09  fcc   "Unknown request"
 fcb   $00
ERROR10  fcc   "Module busy"
 fcb   $00
ERROR11  fcc   "Bad boundary"
 fcb   $00
ERROR12  fcc   "End of file"
 fcb   $00
ERROR13  fcc   "Non-allocated mem."
 fcb   $00
ERROR14  fcc   "Non-existing seg."
 fcb   $00
ERROR15  fcc   "No permission"
 fcb   $00
ERROR16  fcc   "Bad path name"
 fcb   $00
ERROR17  fcc   "File/dev. not found"
 fcb   $00
ERROR18  fcc   "Segment list filled"
 fcb   $00
ERROR19  fcc   "File already exists"
 fcb   $00
ERROR20  fcc   "Illegal address"
 fcb   $00
ERROR21  fcc   "Illegal block size"
 fcb   $00
ERROR22  fcc   "Non-existing module"
 fcb   $00
ERROR23  fcc   "Sector out of range"
 fcb   $00
ERROR24  fcc   "Deallocating stack"
 fcb   $00
ERROR25  fcc   "Illegal process ID"
 fcb   $00
ERROR26  fcc   "Illegal signal code"
 fcb   $00
ERROR27  fcc   "No children"
 fcb   $00
ERROR28  fcc   "Illegal SWI code"
 fcb   $00
ERROR29  fcc   "Keyboard abort"
 fcb   $00
ERROR30  fcc   "Process table full"
 fcb   $00
ERROR31  fcc   "Illegal fork area"
 fcb   $00
ERROR32  fcc   "Known module"
 fcb   $00
ERROR33  fcc   "Bad module CRC"
 fcb   $00
ERROR34  fcc   "Unprocessed signal"
 fcb   $00
ERROR35  fcc   "Non-executable mod."
 fcb   $00
ERROR36  fcc   "Number out of range"
 fcb   $00
ERROR37  fcc   "Sector out of range"
 fcb   $00
ERROR38  fcc   "Write protect"
 fcb   $00
ERROR39  fcc   "Checksum error"
 fcb   $00
ERROR40  fcc   "Read error"
 fcb   $00
ERROR41  fcc   "Write error"
 fcb   $00
ERROR42  fcc   "Device not ready"
 fcb   $00
ERROR43  fcc   "Seek error"
 fcb   $00
ERROR44  fcc   "Media full"
 fcb   $00
ERROR45  fcc   "Device mismatch."
 fcb   $00
ERROR46  fcc   "Device busy"
 fcb   $00
ERROR47  fcc   "Device ID changed."
 fcb   $00
ERROR48  fcc   "Indirect file error"
 fcb   $00
ERROR49  fcc   "Indirect file"
 fcb   $00
ERROR50  fcc   "Unknown error code"
 fcb   $00

* Offsets to error codes
ERRTBL   fdb   ERROR01-ERRMSGS
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
 fdb   ERROR35-ERRMSGS
 fdb   ERROR50-ERRMSGS
 fdb   ERROR50-ERRMSGS
 fdb   ERROR50-ERRMSGS
 fdb   ERROR50-ERRMSGS
 fdb   ERROR50-ERRMSGS
 fdb   ERROR36-ERRMSGS
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
 fdb   ERROR50-ERRMSGS $0324

HELPTBL fdb   $0000
 fdb   H.ATTRS-HELPS $0258
 fdb   H.ARIT-HELPS
 fdb   H.SAVE-HELPS
 fdb   H.CFMT-HELPS
 fdb   H.WINDOW-HELPS
 fdb   H.TITLE-HELPS
 fdb   H.SYSTM-HELPS
 fdb   H.WIDTH-HELPS
 fdb   H.QUIT-HELPS
 fdb   H.PRINT-HELPS
 fdb   H.DEL-HELPS
 fdb   H.INS-HELPS
 fdb   H.WFMT-HELPS
 fdb   H.TRIG-HELPS
 fdb   H.ERRMSG-HELPS
 fdb   H.MOVE-HELPS
 fdb   H.ORDER-HELPS
ENDHELP equ *
