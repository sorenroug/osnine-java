 nam Tee

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!
*

 use defsfile

**********
*
* Tee <pathlist> [<pathlist>]
*
*  Copies standard input to output paths specified in
* the command line.
*
* Author: S. Epstein
*
 mod Teeend,Teenam,Prgrm+Objct,Reent+1,Teeent,Teemem
Teenam fcs "Tee"

 fcb 2 edition 2
*****
* REVISION HISTORY
* edition 2: prehistoric
*****

Bufsiz set 256

**********
* Static Storage Offsets
*
 org 0
Ipath rmb 1 input path number
Opaths rmb 13 output path numbers
Outnum rmb 1 number of open output paths
Buffer rmb Bufsiz line buffer
 rmb 250 room for stack
 rmb 200 room for params
Teemem equ .

Teeent clrb open paths counter
 clr Outnum,u clear initial count
 cmpy #0 no parameters?
 lbeq Teeexit
 leay Opaths,u point to path table
Tee1 lda ,x+
 cmpa #C$Spac skip spaces.
 beq Tee1
 cmpa #C$Coma skip commas.
 beq Tee1
 cmpa #C$Cr Exit on cr
 lbeq Teego
 leax -1,x
 lda #Write. open for write
 ldb #Updat.+Pread.
 OS9 I$Create open the path
 bcs Teerror Error!
 ldb Outnum,u
 sta b,y save path number
 incb increment path count
 stb Outnum,u
 bra Tee1 do another
Teego stb Outnum,u save path count
Teeloop clra use standard input
 leax Buffer,u address buffer
 ldy #Bufsiz number of characters to get
 OS9 I$ReadLn get a line of characters
 bcc Tl1 O.k.
 cmpb #E$Eof
 beq Teeexit
 coma
 bra Teerror
Tl1 inca write to standard output
 OS9 I$WritLn write the line
 tst Outnum,u how many open?
 beq Teeloop none.
 clrb clear path counter
Outloop leay Opaths,u
 lda b,y get first path
 leax Buffer,u address buffer
 ldy #Bufsiz number of characters to write
 OS9 I$WritLn do the write
 bcs Teerror Error
 incb increment path count
 cmpb Outnum,u have we done all paths?
 bne Outloop no. do some more
 bra Teeloop
Teeexit clrb clear error
Teerror OS9 F$Exit and return
 emod

Teeend equ *
