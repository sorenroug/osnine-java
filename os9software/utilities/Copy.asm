 nam COPY

* Copyright 1980, 1983 by Microware Systems Corp.

* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than 
* the licensee is strictly prohibited!

 use defsfile

 ttl OS9 File copy utility
 pag
***************
* Copy <Path1> <Path2> [-s]

* Copies data from Path1 to Path2.  If -s option is specified,
*   a "single drive" copy is performed, which prompts the user
*   to exchange disks at appropriate times.  If this is used,
*   Path2 must be a complete pathlist.

* Author: Robert Doggett, Kim Kempf

***************
* Edition History

*  #   date     Change made                                      by
* -- -------- ------------------------------------------------- ---
* 05 83/00/00 Modifications added for single drive copy.        KK
* 06 83/02/28 Fixed error #208 when input was not RBF device.   RFD
* 06 83/02/29 Does internal verify when output is RBF device,
*              disabling write verify.  Copies much faster now. RFD
* 07 83/03/07 Use SS.FD I$SetStt to preserve file statistics.   KKK

Edition equ 7 current edition

 mod CPYEND,CPYNAM,PRGRM+OBJCT,REENT+1,COPY,CPYMEM
CPYNAM fcs "Copy"
 fcb Edition

***************

C$CR set $0D
C$LF set $0A
C$Space set $20
C$Comma set ',
C$Single set 'S Single drive copy char
C$PDLM set '/ Path delimiter
C$Dest set 1 Destination indicator for RDYDRV
C$RdyGo set 'C Input continue character
C$Bell set $07

MAXBYT set 80

***************
* Static Storage Offsets

 org 0
InpPath rmb 1 Input path number
OutPath rmb 1 Output path number
InpDTP rmb 1 Input device type
Verify rmb 1 clear if internal verification
BuffSize rmb 2 Size of disk buffer
FileSize rmb 4 size of file
FilePtr rmb 4 current file position
Single rmb 1 0=Don't prompt for disk switch
OutAttr rmb 1 Attributes for output
FileOpts rmb PD.OPT Path options buffer
 rmb $200-. stack space
StackTop equ .
OutBuff rmb 256 output verification buffer
InpBuff rmb 4096 I/O buffer (May be increased)
CPYMEM equ .

 pag
SORMSG fcc "Ready SOURCE, hit "
 fcb C$RdyGo
 fcc " to continue: "
SORLEN set *-SORMSG

DSTMSG fcc "Ready DESTINATION, hit "
 fcb C$RdyGo
 fcc " to continue: "
DSTLEN set *-DSTMSG

CRMSG fcb C$CR
HLPMSG fcc "Use: Copy <Path1> <Path2> [-s]"
 fcb C$LF
 fcc "  -s = single drive copy (Path2 must be complete pathlist)"
 fcb C$CR
VFYMSG fcb C$Bell
 fcc "Error - write verification failed."
 fcb C$CR

 pag
***************
* Copy Utility - Main Entry

* Initialize stack and buffer space
COPY leas StackTop,U Move stack to safe place
 pshs U Bottom of memory
 leau FileOpts,U
COPY01 clr ,-U clear variables
 cmpu 0,S
 bhi COPY01
 tfr Y,D top of memory
 subd ,S++ (D)=memory size
 subd #InpBuff subtract variables before buffer
 clrb round down to nearest page
 std BuffSize Save input buffer size

* Parse options
 pshs X Save parameter pointer
COPY02 lda ,X+ Parse parameters
 cmpa #'- Start of parameter?
 beq COPY03 yes process it
 cmpa #C$CR End of line?
 bne COPY02 no, keep looking
 bra COPY10

* Process "-s" option
COPY03 ldd ,X+ get the option char
 eora #C$Single Print "Ready drive" prompt?
 anda #^('a-'A) UPPER or lower case
 bne COPY04 ..no, not this option
 cmpb #'0 followed by (loosly) a delim?
 bhs COPY04 ..No, not this option
 inc Single Print "Ready drive" prompts
 bra COPY02 Look for more parameters

* Process any other options here
COPY04 lbra COPYErr Bad parameter, print help

***************
* Open input path

COPY10 puls X Restore parameter pointer
 lda #READ. Get mode for open
 OS9 I$Open Open input file
 bcc COPY11 ..no errors
 cmpb #E$BPNam Bad path name?
 lbeq COPYErr ..yes, print the help
 lbra COPY99 ..exit if error

COPY11 sta InpPath Save input path number
 tst Single Single drive copy?
 beq COPY12 ..no
 lda 0,X Get first char of output path
 ldb #E$BPNam bad pathname error
 cmpa #C$PDLM Full pathlist given?
 lbne COPY99 ..No; abort

COPY12 pshs X Save pathname pointer
 lda InpPath Get input path number
 leax FileOpts,U SS.OPT buffer location
 ldb #SS.OPT Get path descriptor options
 OS9 I$GetStt
 lbcs COPY99 ..abort if error
 lda PD.DTP-PD.OPT,X
 sta InpDTP Save source Device Type
 ldb #PREAD.+EXEC.+UPDAT. Default attributes
 cmpa #DT.RBF Rbf device?
 bne COPY14 ..No; use default attributes
 pshs X,U save regs
 lda InpPath
 ldb #SS.Size get size of input file
 OS9 I$GetStt Get the size of source file
 lbcs COPY99 ..abort if error
 stx FileSize store MS 16 bits
 stu FileSize+2 store LS 16 bits
 puls X,U restore regs
 ldb PD.ATT-PD.OPT,X copy input file attr
COPY14 stb OutAttr Save attributes for output

* Open output path
 puls X Restore pathname pointer
 lda #C$Dest (Destination)
 lbsr RDYDRV print "Ready destination"
 lda #UPDAT. try to open (disk) file for update
 ldb OutAttr get output attributes
 OS9 I$Create
 bcc COPY16 ..success
 inc Verify Internal verification is impossible
 lda #WRITE. try to open as write only
 ldb OutAttr Get attributes for output
 OS9 I$Create Open output path
 lbcs COPY99 ..abort if error
COPY16 sta OutPath Save output path number

* Check output file attributes
*  Pre-extend file if RBF device
 leax FileOpts,U
 ldb #SS.OPT Return pathlist options
 OS9 I$GetStt read file option bytes
 lbcs COPY99 ..abort if error
 ldb PD.DTP-PD.OPT,X Get device type
 cmpb #DT.RBF RBF device?
 beq COPY18 ..Yes; pre-extend file
 inc Verify else internal verification impossible
 bra COPY20

COPY18 tst Verify doing internal verification?
 bne COPY19 ..No; continue
 ldb #1
 stb PD.VFY-PD.OPT,X disable write verify
 ldb #SS.OPT
 OS9 I$SetStt reset path options
 lbcs COPY99 abort if error
COPY19 lda InpDTP source device type
 cmpa #DT.RBF too source RBF?
 bne COPY20 ..no, don't extend file
 pshs U Save data address
 lda OutPath Get output path again
 ldb #SS.Size ..to set size of output file
 ldx FileSize Get MS 16 bits of source size
 ldu FileSize+2 Get LS 16 bits of source size
 OS9 I$SetStt Set size of output file
 lbcs COPY99 ..abort if error
 puls U Restore data address

 leax FileOpts,u FD buffer area
 ldy #16 copy 16 bytes
 lda InpPath Input path
 ldb #SS.FD get FD code
 OS9 I$GetStt Get FD date bytes
 bcs COPY20 ..bra if error
 lda OutPath output path
 ldb #SS.FD set FD code
 OS9 I$SetStt write the date bytes

* Perform the copy
COPY20 leax InpBuff,U Get the buffer address
 clra (Source)
 lbsr RDYDRV print "Ready source"
 lda InpPath Get input path
 ldy BuffSize get buffer size
 OS9 I$Read Read input from disk
 bcs COPY70 ..abort if error
 lda #C$Dest (Destination)
 lbsr RDYDRV print "Ready destination"
 lda OutPath Get output path
 OS9 I$Write Write to disk
 lbcs COPY99 ..abort if error
 tst Verify internal write verify?
 bne COPY40 ..No; continue

* Do write verification
 pshs Y,U save bytecnt, global ptr
 ldx FilePtr
 ldu FilePtr+2
 lda OutPath
 OS9 I$Seek reset to beginning of write
 bcs COPY99 ..abort if error
 ldu 2,S
 leau InpBuff,U (U)=input buffer pointer
 ldd 0,S
 addd FilePtr+2
 std FilePtr+2 update current position
 ldd 0,S restore bytecount left
 bcc COPY30
 leax 1,X
 stx FilePtr

COPY30 ldy #256
 std 0,S
 tsta more than 256 bytes left?
 bne COPY32 ..Yes; continue
 tfr D,Y
COPY32 ldx 2,S global data ptr
 leax OutBuff,X
 lda OutPath
 OS9 I$Read reread bytes written
 bcs COPY99 ..abort if error
COPY35 lda ,U+ get char from original buffer
 cmpa ,X+ does it match the one read back?
 bne VFYError ..No; abort
 leay -1,Y decrement bytecount
 bne COPY35
 ldd 0,S restore bytecount remaining
 subd #256 subtract one sector
 bhi COPY30 repeat until all checked
 puls Y,U restore regs

COPY40 lda InpPath get input path
 ldb #SS.EOF test for EOF
 OS9 I$GetStt
 bcc COPY20 ..No; copy next segment

 cmpb #E$Eof End of file?
 beq COPY80 ..yes clean up
COPY70 cmpb #E$Eof End of file?
 bne COPY99 ..no, return error
 lda #C$Dest (Destination)
 bsr RDYDRV print "Ready destination"

COPY80 lda OutPath Get output path
 OS9 I$Close Close the output path
 bcc COPY90 exit
 bra COPY99 ..note any error

VFYError leax VFYMSG,PC
 bsr PRINT
 comb
 ldb #1
 bra COPY99 abort

COPYErr leax HLPMSG,PCR Point to help message
 bsr PRINT

COPY90 clrb Return no errors
COPY99 OS9 F$Exit Terminate

PRINT ldy #256
PRINT10 lda #1 Std output
 OS9 I$Writln Print the help
 rts

***************
* Print Ready source/destination message
*  If required
*
* Passed: (A) 0=Print "Ready source" message
*             1=Print "Ready dest" message

RDYDRV tst Single Single drive copy?
 beq RDYD99 ...no, return
 pshs X,Y Save registers
RDYD05 pshs A Save calling parameter
 tsta Print "ready source"?
 bne RDYD10 ..no
 leax SORMSG,PCR Get source message address
 ldy #SORLEN Source msg len
 bra RDYD20
RDYD10 leax DSTMSG,PCR Get destination message address
 ldy #DSTLEN Destination msg len
RDYD20 bsr PRINT10 print the message
 leax ,-S Point to a junk location
 ldy #1 One byte only
 clra ..from std input
 OS9 I$Read Read one byte
 lda ,S+ Get the input byte
 eora #C$RdyGo Continue character?
 anda #^('a-'A) UPPER or lower case
 beq RDYD30 Yes, continue
 bsr ECHOCR Print CR
 puls A ..no, get the calling parameter
 bne RDYD05 ..and reprompt
RDYD30 bsr ECHOCR Print CR
 puls A Restore
 puls X,Y ..regs and
RDYD99 rts ..return

ECHOCR pshs A,X,Y
 lda #1 Std output
 leax CRMSG,PCR
 ldy #MAXBYT
 OS9 I$Writln Print the CR
 puls A,Y,X,PC restore registers and return

 emod Module CRC

CPYEND equ *
 end
