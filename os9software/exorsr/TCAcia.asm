 nam TCACIA
 ttl Device driver with Read timeout
 spc 2
**************************************************************************
*                                                                        *
*          ACIA - Interrupt Driven ACIA Device Driver                    *
*                 with the Inclusion of a Timeout upon                   *
*                 a Read request.                                        *
*                                                                        *
*          (C) 1982 Advanced Semiconductor Materials                     *
*                                                                        *
**************************************************************************
 spc 2
 ifp1
 use os9defs
 use scfdefs
 endc
 spc 1
INPSIZ set 128 Input Buffer Size
OUTSIZ set 128 Output Buffer Size
 spc 1
ININTR set %10000000 Control Bit to Allow Input Interrupts
OTINTR set %00100000 Control Bit to Allow Output Interrupts
 spc 1
PARITY set %01000000 Parity Error Status Bit
OVERUN set %00100000 Overrun Error Status Bit
FRAME set %00010000 Framing Error Status Bit
NOTCTS set %00001000 Not Clear-to-Send Status Bit
DCDLST set %00000100 Data Carrier Lost Status Bit
READY set %00000001 Input Register has Data Status Bit
 spc 1
RESET set 3 ACIA Master Reset Control Command
DEFAULT set $15 Default ACIA Control Value
 spc 1
WAIT set 0 Time out to wait for I/O
TIMEOUT set 6 Time out value = 3 seconds (500 msec clock)
 spc 1
INPERR set PARITY+OVERUN+FRAME+NOTCTS+DCDLST An Error Condition
 spc 2
*       Static Storage Requirements
 spc 1
 org V.SCF Space for SCF fixed variables
INXTI rmb 2 Input Buffer NEXT-IN Pointer
INXTO rmb 2 Input Buffer NEXT-OUT Pointer
INEND rmb 2 Input Buffer end
ONXTI rmb 2 Output Buffer NEXT-IN Pointer
ONXTO rmb 2 Output Buffer NEXT-OUT Pointer
ONEND rmb 2 Output Buffer End
 spc 1
INPBUF rmb INPSIZ Input Character Buffer
OUTBUF rmb OUTSIZ Output Character Buffer
 spc 1
ACIMEM equ . Total Static Memory Requirements
 page
*       Device Driver Module Header
 spc 1
ModType set DRIVR+OBJCT
Version set REENT+4
Capabil set UPDAT.
 spc 1
 mod ACIEND,ACINAM,ModType,Version,ACIENT,ACIMEM
 fcb Capabil
ACINAM fcs "Acia"
 spc 2
*         Entry Points
 spc 1
ACIENT equ *
 lbra INIT Initialization Entry Point
 lbra READ Read a Character Entry Point
 lbra WRITE Write a Character Entry Point
 lbra GETSTA Get Port Status Entry Point
 lbra PUTSTA Change Port Status Entry Point
 lbra TRMNAT Device Termination Entry Point
 spc 2
*        I/O Poll Record
 spc 1
ACMASK equ *
 fcb 0 No Inversion Bits in Status Register
 fcb $80 IRQ Polling Bit in Status Register
 fcb 5 I/O Polling Priority
 page
*      Device Driver Initialization
 spc 1
*   Upon Entry:
*               U  = Pointer to Static Storage Area
*               Y  = Pointer to Device Descriptor
 spc 1
*   Upon Exit:
*               CC = 0; No Initialization Errors
*      or       CC = 1; Error in Initialization,
*               B  = Error Code
 spc 2
INIT equ *
 ldb #RESET Set ACIA Master Reset
 stb [V.PORT,u] in ACIA Control Register
 lda M$OPT,y Get option count from Device Descriptor
 cmpa #PD.PAR-PD.OPT ACIA Control value present?
 blo INIT10 ..No; use default
 ldb PD.PAR-PD.OPT+M$DTYP,y Yes; Get value from Device Descriptor
 bne INIT20 No zero value
INIT10 equ *
 ldb #DEFAULT Get ACIA Default Control Value
INIT20 equ *
 stb V.TYPE,u Save Control Value
 ldd V.PORT,u Put port address into "d"
 leax <ACMASK,pcr Point to Polling Record
 leay ACIRQ,pcr Point to Interrupt Handler
 os9 F$IRQ Set this device into I/O Queue
 bcs INIT9 Error; Exit
 leax INPBUF,u Point to input buffer
 stx INXTI,u Initialize input buffer pointers
 stx INXTO,u
 leax INPSIZ-1,x and Buffer End
 stx INEND,u pointer
 leax OUTBUF,u Initialize output buffer pointers
 stx ONXTI,u
 stx ONXTO,u
 leax OUTSIZ-1,x and Buffer End
 stx ONEND,u pointer
INIT30 equ *
 ldb V.TYPE,u Get ACIA Control Value
 orb #ININTR and enable input interrupts
 stb [V.PORT,u] in the ACIA Control Register
 clrb Insure good exit
INIT9 equ *
 rts Exit
 page
*   READ - Return one byte of input from the ACIA Input Buffer
*
*   Upon Entry:
*               Y  = Pointer to Path Descriptor
*               U  = Pointer to Device's Static Storage
*
*   Upon Exit:
*               A  = Next Input Byte in ACIA Receive Buffer
*               CC = 0; No Error
*      or       B  = Error Code
*               CC = 1; Error
 spc 2
READ00 equ *
 bsr READSLEP Wait for input data, buffer is empty
READ equ *
 ldx INXTO,u Input Buffer's NEXT-OUT Pointer
 orcc #IRQM Calm interrupts
 cmpx INXTI,u any data available?
 beq READ00 No; go wait
 lda ,x+ Yes; get the next character and increment pointer
 cmpx INEND,u At the end of the buffer?
 bls READ10 No; skip
 leax INPBUF,u Yes; Reset pointer to top
READ10 equ *
 stx INXTO,u Save new NEXT-OUT Pointer
 clrb Assume no errors
 ldb V.ERR,u Any transmission errors?
 beq READ90 ..No; exit
 stb PD.ERR,y Yes; Save in Path Descriptor
 clr V.ERR,u and Reset error semiphore
 comb Return with carry set
 ldb #E$RD and the Read Error code
READ90 equ *
 andcc #$FF-IRQM Enable interrupts
 rts Exit
 page
*      Subroutine READSLEP - Sleep for Input Data with or without
*                            timeout.
*
*      Upon Entry:
*                  Interrupts are DISABLED
*                  U = Pointer to Static Storage
*                  V.BUSY,u = Current Process ID
*                  Y = Pointer to Path Descriptor
*                  PD.BAU,y = Semiphore for Type of Timeout
*                             0 = No timeout
*                            ^0 = Timeout
*
*    Upon Exit:
*                 On Error Destroys Program Counter
 spc 2
READSLEP equ *
 pshs d,x Save registers
 lda V.Busy,u Put Current Process ID into
 sta V.WAKE,u into V.WAKE for wake-up signal
 ldx #WAIT Assume no Timeout sleep
 tst PD.BAU,y Timeout Sleep?
 beq READSLE1 ..No; skip
 ldx #TIMEOUT ..Yes; set for finite sleep time
READSLE1 equ *
 andcc #$FF-IRQM Allow interrupts
 os9 F$SLEP Wait for input data or timeout
 pshs x Save time returned
 ldx D.PROC Get current Process Desc. Pointer
 ldb P$SIGN,x A signal present?
 puls x also recover time
 beq READSLE2 ..No; just return
 cmpb #S$INTR ..Yes; Deadly signal?
 bls ACSLER ..Yes; take error exit
READSLE2 equ *
 tst PD.BAU,y Should we check for timeout?
 beq ACSL90 ..No; take good exit
 clr V.WAKE,u ..Yes; reset wakeup
 leax ,x Time out occurred?
 bne ACSL90 ..No; take good exit
 leas 6,s Reset stack
 comb Indicate an Error
 ldb #E$RD Error-code is Read Error
 rts
 page
*       Subroutine ACSLEP -  Sleep for Input Data
*
*    Upon Entry:
*                Interrupts are DISABLED
*                U  = Pointer to Static Storage
*                V.BUSY,u = Current Process ID
*
*    Upon Exit:
*                On Error Destroys program counter
 spc 2
ACSLEP equ *
 pshs d,x Save Registers
 lda V.BUSY,u Put Current Process ID into
 sta V.WAKE,u wake for wake-up signal
 andcc #$FF-IRQM Allow interrupts
 ldx #WAIT Sleep forever
 os9 F$SLEP Wait for input data
 ldx D.PROC Get current Process Pointer
 ldb P$SIGN,x A signal present?
 beq ACSL90 ..No; just return
 cmpb #S$INTR ..Yes; Deadly signal?
 bls ACSLER ..Yes; take error exit
ACSL90 equ *
 clrb Indicate no errors
 puls d,x,pc Restore and return
ACSLER equ *
 leas 6,s Reset stack
 coma Indicate an error (B = Error Code)
 rts and exit
 page
*    WRITE - Output one character via the Output Buffer
*
*    Upon Entry:
*                U  = Static Storage Pointer
*                Y  = Path Descriptor Pointer
*                A  = Byte to send
*
*    Upon Exit:
*                CC = 0; No errors
*       or       CC = 1; Error
*                B  = Error code
 spc 2
WRIT00 equ *
 bsr ACSLEP Sleep if queue full
WRITE equ *
 ldx ONXTI,u Get pointer for next location in the output buffer
 sta ,x+ Stor the byte to send and increment the pointer
 cmpx ONEND,u At the end of the buffer
 bls WRIT10 ..No; skip
 leax OUTBUF,u ..Yes; set pointer to the top of the buffer
WRIT10 equ *
 orcc #IRQM Disable interrupts
 cmpx ONXTO,u Output buffer full?
 beq WRIT00 ..Yes; sleep and retry
 stx ONXTI,u ..No; save update pointer
 andcc #$FF-IRQM Allow interrupts just in case
 ldb V.TYPE,u ACIA Control variable
 orb #ININTR+OTINTR Enable both input and output interrupts
 stb [V.PORT,u] in the ACIA Control Register
WRIT90 equ *
 clrb Indicate no errors
 rts
 page
*    GETSTA/PUTSTA -  Get or set Port Status, by checking for data available
*
*    Upon Entry:
*                U  = Static Storage Pointer
*                Y  = Path Descriptor Pointer
*                A  = Status Code
*
*    Upon Exit:
*                CC = 0; no error
*       or       CC = 1; No data error
*                B  = Not Ready Error Code
 spc 2
GETSTA equ *
 cmpa #SS.RDY Ready Status Code?
 bne GETS10 ..No; Check EOF
 ldd INXTI,u
 subd INXTO,u Any Data in Buffer?
 bne GETS20 ..Yes; Return carry clear and amount of data
 comb ..No; Indicate an error
 ldb #E$NRDY and not ready status
 rts
GETS20 equ *
 bpl GETS30 Amount of data is already valid
 addd #INPSIZ Adjust amount because of queue wrap around
GETS30 equ *
 ldx PD.RGS,y Point to register file
 std R$A,x Store count to be returned
 bra WRIT90 and take normal exit
GETS10 equ *
 cmpa #SS.EOF End of File Code?
 beq WRIT90 ..Yes; Return no error
 spc 1
PUTSTA equ *
 comb Indicate an Error
 ldb #E$USVC Error code - Unknown Service Call
 rts
 page
*     TRMNAT - Terminate Device Driver Processing
*
*     Upon Entry:
*                 U  = Static Storage Pointer
*                 Y  = Path Descriptor Pointer
*
*     Upon Exit:
*                 Nothing changed
 spc 2
TRMN00 equ *
 bsr ACSLEP Wait for I/O activity to cease
TRMNAT equ *
 ldx D.PROC Get Pointer to current process descriptor
 lda P$ID,x Get Process ID
 sta V.BUSY,u and set in static storage
 sta V.LPRC,u
 ldx ONXTI,u Check to see if all data transmitted
 orcc #IRQM Inhibit interrupts
 cmpx ONXTO,u Output complete
 bne TRMN00 ..No; wait a bit
 lda #RESET ..Yes; Reset ACIA
 sta [V.PORT,u]
 andcc #$FF-IRQM Allow interrupts
 ldx #WAIT
 os9 F$IRQ Remove this device from I/O Poll queue
 rts Exit
 page
*        ACIRQ - Interrupt Processor for Input and Output
*
*        Upon Entry:
*                    U  = Static Storage Pointer
*                    X  = Port Address
*                    A  = Contents of Status Register
*
*        Upon Exit:
*                    nothing changed except I/O processed
 spc 2
ACIRQ equ *
 ldx V.PORT,u Get Port pointer
 anda #INPERR Mask off any error bits
 ora V.ERR,u and update with saved error bits
 sta V.ERR,u
 lda ,x+ Restore ACIA status condition and update pointer
 bita #READY Input Ready?
 bne INACIA ..Yes; go process input
*                                    or fall through for output
OACIA equ *
 ldy ONXTO,u Get NEXT-OUT Pointer
 cmpy ONXTI,u Buffer already empty?
 beq OACIA2 ..Yes; go disable output interrupts
 lda ,y+ Get next character to output and increment pointer
 cmpy ONEND,u At bottom of buffer
 bls OACIA1 ..No; skip
 leay OUTBUF,u ..Yes; Reset pointer to top of buffer
OACIA1 equ *
 sty ONXTO,u Save updated pointer
 sta ,x Write the character
 cmpy ONXTI,u Last character in buffer?
 bne WAKEUP ..No
OACIA2 equ *
 lbsr INIT30 ..Yes; turn off transmitter interrupts
WAKEUP equ *
 ldb #S$WAKE Send Wake-Up signal
 lda V.WAKE,u if owner waiting
WAKE10 equ *
 beq WAKE90 ..No owner
 os9 F$SEND
WAKE90 equ *
 clr V.WAKE,u Reset owner pending
 rts Return to I/O Poll Routine
 spc 2
INACIA equ *
 lda ,x Read a character from the ACIA
 ldx INXTI,u Pointer to NEXT-IN in input buffer
 sta ,x+ Save the new character and update the pointer
 cmpx INEND,u At the bottom of the buffer
 bls ACIA2 ..No; skip
 leax INPBUF,u ..Yes; reset pointer to the top of the buffer
ACIA2 equ *
 cmpx INXTO,u Input overrun?
 bne ACIA25 ..No; good
 ldb #OVERUN ..Yes; set error bit
 orb V.ERR,u
 stb V.ERR,u
 bra ACIA26 and discard character
ACIA25 equ *
 stx INXTI,u Save the new pointer
ACIA26 equ *
 beq WAKEUP ..pass nulls without editing checks
 cmpa V.PCHR,u PAUSE Character?
 bne ACIA3 ..No; skip
 ldx V.DEV2,u ..Yes; get pointer to pause device static storage
 beq WAKEUP ..None; exit
 sta V.PAUS,x ..Yes; request pause
 bra WAKEUP and exit
ACIA3 equ *
 ldb #S$INTR Interrupt signal
 cmpa V.INTR,u Keyboard interrupt?
 beq ACIA4 ..Yes; go interrupt process
 ldb #S$ABT Abort signal
 cmpa V.QUIT,u Keyboard abort?
 bne WAKEUP ..No; just exit
ACIA4 equ *
 lda V.LPRC,u Last process ID
 bra WAKE10 Send error signal
 spc 2
 emod
ACIEND equ *
 spc 2
 nam TC1
 ttl Device Descriptor for Tube Controller Port
 page
**************************************************************************
*                                                                        *
*          TC1 -- Device Descriptor Module for Tube Controller           *
*                 ACIA Ports.                                            *
*                                                                        *
*          (C) 1982  Advanced Semiconductor Materials                    *
*                                                                        *
**************************************************************************
 spc 2
ModType set DEVIC+OBJCT
 mod TC1END,TC1NAM,ModType,Version,TC1MGR,TC1DRV,0
 fcb Capabil
 fcb $FF
 fdb $ECB2 Port Address
 fcb TC1NAM-*-1 Option Byte Count
 fcb DT.SCF File Manager Device Type
 spc 1
*        Default Parameters
 spc 1
 fcb 0 Case = Upper and lower
 fcb 0 Backspace = not used
 fcb 0 Delete = not used
 fcb 0 Auto Echo = off
 fcb 0 Auto Line Feed = off
 fcb 0 Null Count = not used
 fcb 0 End-of-Page Pause = not used
 fcb 255 Lines per Page = Maximum
 fcb 0 Backspace Character = not used
 fcb 0 Delete Line Character = not used
 fcb C$CR End-of-Record Character = Carriage Return
 fcb 0 End-of-File Character = not used
 fcb 0 Reprint last line character = not used
 fcb 0 Duplicate last line character = not used
 fcb 0 Pause character = not used
 fcb 0 Keyboard Interrupt character = not used
 fcb 0 Keyboard Abort character = not used
 fcb 0 Backspace Echo character = not used
 fcb 0 Line overflow character = not used
 fcb $15 ACIA Control character = 8 bit not parity
 fcb C$CR Baud Rate field is EOM field = carriage return
 fdb TC1NAM Echo device name
TC1NAM fcs "TC1"
TC1MGR fcs "scf"
TC1DRV fcs "Acia"
 spc 1
 emod
 spc 1
TC1END equ *
 page
 end
