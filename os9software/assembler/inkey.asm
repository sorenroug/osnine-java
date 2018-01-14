***************
* INKEY - a subroutine for BASIC09
*    Author: Robert Doggett

* Calling syntax:
*    RUN InKey(StrVar)
*    RUN InKey(Path,StrVar)

*    Inkey determines if a key has been typed on the given path
* (Standard Input if not specified), and if so, returns the next
* character in the string variable.  If no key has been
* typed a null string is returned.  If a path is specified, it may
* be either type BYTE or INTEGER.  StrVar may be declared as a
* BYTE variable, if preferred. If this is done, a value of 255
* indicates that no data is ready.


         ifp1
         use   os9defs
         endc

E$Param  equ   56     Basic09's "Parameter Error"
TYPE     set   SBRTN+OBJCT
REVS     set   REENT+1
         mod   InKeyEnd,InKeyNam,TYPE,REVS,InKeyEnt,0
InKeyNam fcs   "Inkey"
         fcb   2          edition two

         org   0          Parameters
Return   rmb   2          Return addr of caller
PCount   rmb   2          Number of params
Param1   rmb   2          after 1st param addr
Length1  rmb   2          size
Param2   rmb   2          2nd param addr
Length2  rmb   2          size

InKeyEnt leax  Param1,S
         ldd   PCount,S   Get parameter count
         cmpd  #1         just one parameter?
         beq   InKey20    ..Yes; path (A)=0
         cmpd  #2         Two parameters?
         bne   ParamErr   No, abort
         ldd   [Param1,S] Get path number
         ldx   Length1,S
         leax  -1,X       byte available?
         beq   InKey10    ..Yes; (A)=Path number
         leax  -1,X       Integer?
         bne   ParamErr   ..No; abort
         tfr   B,A
InKey10  leax  Param2,S
InKey20  ldu   2,X        length of string
         ldx   0,X        addr of string
         ldb   #$FF
         stb   0,X        Init to null str
         cmpu  #2         Two-byte string?
         blo   InKey30    ..No
         stb   1,X       put terminator in 2nd b
InKey30  ldb   #SS.Ready
         OS9   I$GetStt   Is any data ready?
         bcs   InKey90    ..No; exit
         ldy   #1
         OS9   I$Read     Read one byte
         rts              return error status

InKey90  cmpb  #E$NotRdy
         bne   InKeyErr
         rts              (carry clear)

ParamErr ldb   #E$Param   Parameter Error
InKeyErr coma
         rts
  
         emod
InKeyEnd equ   *

