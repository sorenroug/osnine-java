 nam Free
 ttl OS-9 free disk space reporting utility

* Copyright 1980 by Microware Systems Corp.,

* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than 
* the licensee is strictly prohibited!

* Edition History

*  #   date       comments
* -- -------- ------------------------------------------------------
*  4 ??/??/?? Buffered Bitmap sector I/O.
*  5 83/01/13 Added quotes around disk name
*  6 83/04/01 Increased Bitmap buffer from 256 to 4096 bytes

Edition equ 7 current edition number
 use defsfile

**********
* Free [/dev name]
*   Os-9 Utility to report available disk space
* Author: Robert Doggett

* Defaults to current data directory
* Also shows Volume name, create date, capacity.

 mod FREEND,FRENAM,PRGRM+OBJCT,REENT+1,FREE,FREMEM
FRENAM fcs "Free"
 fcb Edition
 pag

MAPOFF equ $100 Bitmap offset on disk

C$CR set $0D
C$LF set $0A
C$SPAC set $20
C$COMA set ',
C$SLSH set '/
C$COLN set ':
C$DISK set '@
BITBUFSZ equ 4096 bitmap buffer size

**********
* Static Storage Offsets

 org 0
ZERSUP rmb 1 0=zero suppression
LINPOS rmb 2 Current line ptr
DSKPTH rmb 1 Disk path number
AVAIL rmb 3 Available disk space (sectors)
LARGST rmb 3 Largest disk block (sectors)
SEGMNT rmb 3 Temp largest disk block
FRLBUF rmb 80 Output line buffer
DSKBUF rmb DD.NAM+32 Device descriptor buffer
NAMLIM rmb 1
BMAPEND rmb 2 end of bitmap ptr
BITBUFF rmb BITBUFSZ Bitmap Buffer
 rmb 250 stack room
 rmb 200 room for params
FREMEM equ . Total static storage requirement

USAGE fcb C$LF
 fcc "Use: Free [/diskname]"
 fcb C$LF
 fcc "  tells how many disk sectors are unused"
 fcb C$CR
USAGSZ equ *-USAGE
CREATE fcb '"
 fcs " created on:"
CAPCTY fcs "Capacity:"
SECTRS fcs " sectors ("
CLUSTR fcs "-sector clusters)"
SPACE fcs " Free sectors, largest block"
LONG fcs " sectors"

 pag
**********
* Free
*   Report Disk Free Space
*
FREE leay FRLBUF,U
 sty LINPOS Reset i/o buffer
 cmpd #0
 beq FREE30 ..no parameters, default
 lda ,X+
 cmpa #C$CR Empty parameter list?
 beq FREE30 ..yes; use default
 cmpa #C$SLSH Device name?
 beq FREE10 ..yes; good
FREE05 leax USAGE,PCR
 ldy #USAGSZ
 lda #2
 OS9 I$WritLn Print usage instructions
 lbra FREE80 Exit

FREE10 leax -1,X Back up to slash
 pshs X
 OS9 F$PrsNam Parse device name
 puls X
 bcs FREE05 ..error; print err msg
FREE20 lda ,X+
 lbsr FROCHR Copy parameter into i/o buffer
 subb #1
 bcc FREE20 Until end of first name found

FREE30 lda #C$DISK Add "open disk" character
 lbsr FROCHR
 lbsr FRSPAC
 leax FRLBUF,U
 stx LINPOS Reset i/o buffer
 lda #READ.
 OS9 I$OPEN Open disk as random i/o file
 sta DSKPTH Save disk path number
 bcs FREE35 ..error; exit
 leax DSKBUF,U
 ldy #DD.NAM+32
 OS9 I$READ Read disk device descriptor
FREE35 lbcs FREE90 ..error; exit

 lbsr FREOL Print blank line
 lda #'" get quote char
 lbsr FROCHR insert leading quote
 leay DSKBUF+DD.NAM,U
 lda #'?+$80
 sta NAMLIM,U insure good end of name mark
 lbsr FRNAME Put disk name in i/o buffer
 dec LINPOS+1 eliminate trailing space
 leay CREATE,PCR
 lbsr FRNAME Put "created" in i/o buffer
 lbsr FRDATE Put create date in buffer
 lbsr FREOL Print

 leay CAPCTY,PCR
 lbsr FRNAME Print "capacity:"
 leax DSKBUF+DD.TOT,U
 lbsr FRITOA Print total disk size
 leay SECTRS,PCR
 lbsr FRNAME Print "sectors ( "
 dec LINPOS+1 Remove trailing space
 ldd DSKBUF+DD.BIT
 pshs D
 clr ,-S
 leax 0,S
 lbsr FRITOA Print sectors per cluster
 leas 3,S
 leay CLUSTR,PCR
 lbsr FRNAME Print "-sector clusters"
 lbsr FREOL

 clra
 clrb
 sta AVAIL Clear available sector count
 std AVAIL+1
 sta SEGMNT Clear current segment size
 std SEGMNT+1
 sta LARGST Clear largest segment size
 std LARGST+1
 lda DSKPTH
 ldx #0
 pshs U
 ldu #MAPOFF
 OS9 I$SEEK Seek to bitmap
 puls U

FREE40 leax BITBUFF,U Bitmap Buffer ptr
 ldd #BITBUFSZ
 cmpd DSKBUF+DD.MAP
 bls FREE42
 ldd DSKBUF+DD.MAP
FREE42 leay D,X
 sty BMAPEND
 tfr D,Y
 lda DSKPTH
 OS9 I$READ Read one sector of bitmap
 bcs FREE90 ..error; exit
FREE45 lda ,X+
 bsr FRBITS Count bits
 stb ,-S Save bit count
 beq FREE70 While bitcount>0 do
FREE50 ldd AVAIL+1
 addd DSKBUF+DD.BIT Add sectors per bit amount
 std AVAIL+1
 bcc FREE60
 inc AVAIL
FREE60 dec 0,S Decrement bitcount
 bne FREE50
FREE70 leas 1,S Goodbye scratch
 cmpx BMAPEND End of this bitmap sector?
 blo FREE45 ..No; get next byte
 ldd DSKBUF+DD.MAP
 subd #BITBUFSZ Dec bitmap size; end of bitmap?
 std DSKBUF+DD.MAP
 bhi FREE40 ..no; go read next bitmap byte
 bsr FRBT60 Update largest

 leax AVAIL,U
 lbsr FRITOA Print free sector count
 leay SPACE,PCR
 bsr FRNAME Print "free sectors, largest block is"
 leax LARGST,U
 lbsr FRITOA Print largest contiguous block
 leay LONG,PCR
 bsr FRNAME Print "sectors long"
 bsr FREOL

 lda DSKPTH
 OS9 I$Close Close disk
 bcs FREE90 ..error; report it

FREE80 clrb RETURN No error
FREE90 OS9 F$EXIT Exit

**********
* Frbits
*   Count Free Bits, And Keep
*   Track Of Longest Segment
*
* Passed: (A)=Bitmap Byte
* Returns: (B)=Number Of Bits Set
* Destroys: A
*
FRBITS clrb
 cmpa #$FF none free?
 beq FRBT60 ..right; update current segment
 bsr FRBT10 (8)
FRBT10 bsr FRBT20 (4)
FRBT20 bsr FRBT30 (2)
FRBT30 asla PROCESS High order bit
 bcs FRBT60 ..bra if not free
 incb UPDATE Bit count
 pshs D
 ldd SEGMNT+1
 addd DSKBUF+DD.BIT Add in sectors per bit
 std SEGMNT+1
 bcc FRBT50
 inc SEGMNT
FRBT50 puls D,PC Return

FRBT60 pshs D
 ldd SEGMNT End of current segment
 cmpd LARGST Longer than largest?
 bhi FRBT70 ..yes
 bne FRBT80 ..no
 ldb SEGMNT+2
 cmpb LARGST+2
 bls FRBT80 ..no
FRBT70 sta LARGST Update largest size
 ldd SEGMNT+1
 std LARGST+1
FRBT80 clr SEGMNT Clear out current segment
 clr SEGMNT+1
 clr SEGMNT+2
 puls D,PC

**********
* Frname
*   Print Name, High Bit Delimiter
*
* Passed: (Y)=Ptr To Name
* Destroys: A,CC
*
FRNAME lda 0,Y
 anda #$7F
 bsr FROCHR
 lda ,Y+
 bpl FRNAME

**********
* Frochr
*   Put One Char In Output Buffer
*
* Passed: (A)+Char
* Destroys: CC
*
FRSPAC lda #C$SPAC

FROCHR pshs X
 ldx LINPOS
 sta ,X+
 stx LINPOS
 puls X,PC

**********
* Freol
*   Print Buffer
*
* Destroys: CC
*
FREOL pshs A,X,Y
 lda #C$CR
 bsr FROCHR Put carriage return in buffer
 leax FRLBUF,U
 stx LINPOS Reset line ptr
 ldy #80
 lda #1
 OS9 I$WritLn
 puls A,X,Y,PC

 pag
**********
* Fritoa
*   Convert (Binary) Integer To Ascii
*
* Passed: (X)=Ptr To 3-Byte Integer
* Destroys: A,CC
*
POWTEN equ *
 fcb $98,$96,$80 10 10,000,000
 fcb $0F,$42,$40 9   1,000,000
 fcb $01,$86,$A0 7     100,000
 fcb $00,$27,$10 6      10,000
 fcb $00,$03,$E8 5       1,000
 fcb $00,$00,$64 3         100
 fcb $00,$00,$0A 2          10
 fcb $00,$00,$01 1           1

FRITOA lda #10 (table index)
 pshs D,X,Y Save regs
 leay <POWTEN,PCR Get power of ten table
 clr ZERSUP set zero suppression
 ldb 0,X
 ldx 1,X (b,x)=number
FRIT10 lda #-1
FRIT20 inca INCREMENT Digit being built
 exg D,X
 subd 1,Y Subtract power of ten
 exg D,X
 sbcb 0,Y
 bcc FRIT20 ..repeat until underflow
 bsr FRZSUP Print, with zero suppression
 exg D,X
 addd 1,Y Add back overflow
 exg D,X
 adcb 0,Y
 leay 3,Y Move to next lower power
 dec 0,S Done?
 beq FRIT40 ..yes; exit
 lda 0,S
 cmpa #1 Units entry?
 bne FRIT30 ..no
 sta ZERSUP Turn off zero suppression
FRIT30 bita #3 Comma field?
 bne FRIT10 ..no; continue
 dec 0,S
 tst ZERSUP Zero suppression?
 beq FRIT10 ..yes; continue
 lda #C$COMA
 bsr FROCHR Print comma
 bra FRIT10 Then continue

FRIT40 puls D,X,Y,PC Return

 pag
**********
* Frdate
*   Print "YY/MM/DD HH:MM:SS"
*
FRDATE leax DSKBUF+DD.DAT,U
 bsr FRPNUM Print yy
 bsr FRDT10 Print /mm
FRDT10 lda #C$SLSH
 lbsr FROCHR Print slash, then number

**********
* Frpnum
*   Print 8-Bit Decimal Number At (,X+)
*
FRPNUM clr ZERSUP set zero suppression
 ldb ,X+
 lda #0
FRPN10
 subb #100
 bcc FRPN10
 bsr FRZSUP
 lda #10
 sta ZERSUP Print at least two digits
FRPN20 deca FORM Tens digit
 addb #10
 bcc FRPN20
 bsr FRZSUP Print
 tfr B,A

**********
* Frzsup
*   Print Digit With Zero Suppression

* Passed: (A)=Digit
* Destroys: A,CC

FRZSUP tsta ZERO?
 beq FRZS10
 sta ZERSUP ..no; end zero suppression
FRZS10 tst ZERSUP Zero suppression?
 bne FRZS20 ..no; print digit
 rts

FRZS20 adda #'0
 lbra FROCHR

 emod Module Crc

FREEND equ *

