
 nam OS-9 Level I V1.2 kernal, part 1
 ttl System Type definitions

 use defsfile

Type set SYSTM+OBJCT
Revs set REENT+1
 mod OS9End,OS9Nam,Type,Revs,COLD,0

OS9Nam fcs /OS9p1/
     fcb   13

RamLimit set $EC00

         fcc "FM7"

CNFSTR fcs /Init/ Configuration module name
OS9STR fcs /OS9p2/ Kernal, part 2 name


L001F    fcb   $FD
         fcb   $02
         fcb   $20
         fcb   $31

*****
*
* System Service Routine Table
*
SVCTBL equ *
 fcb F$LINK
 fdb LINK-*-2
         fcb   $03
         fcb   $04
         fcb   $54 T
         fcb   $05
         fcb   $04
         fcb   $B8 8
         fcb   $85
         fcb   $04
         fcb   $C7 G
         fcb   $10
         fcb   $06
         fcb   $DB [
         fcb   $11
         fcb   $07
         fcb   $3E >
         fcb   $12
         fcb   $06
         fcb   $74 t
         fcb   $13
         fcb   $05
         fcb   $E7 g
         fcb   $14
         fcb   $06
         fcb   $37 7
         fcb   $17
         fcb   $03
         fcb   $85
         fcb   $A8 (
         fcb   $05
         fcb   $73 s
         fcb   $A9 )
         fcb   $05
         fcb   $C0 @
         fcb   $AC ,
         fcb   $01
         fcb   $A3 #
         fcb   $AD -
         fcb   $02
         fcb   $42 B
         fcb   $AE .
         fcb   $02
         fcb   $C4 D
         fcb   $32 2
         fcb   $07
         fcb   $46 F
         fcb   $80

*
* Clear System Memory, Skipping First 32 Bytes
*
LORAM set $20
HIRAM set $300
RAMMSK set $F0 Initial bit map mask
COLD ldx #LORAM Set ptr
 ldy #HIRAM-LORAM Set byte count
 clra CLEAR D
 clrb
COLD05 std ,X++ Clear two bytes
 leay -2,Y Count down
 bne COLD05
 inca ONE Page for direct page
 std D.FMBM Set free memory bit map
 addb #BMAPSZ Add map size
 std D.FMBM+2
 addb #2 Reserve i/o routine entry
 std D.SysDis Set system service request table
 addb #SVCTSZ+2 Add table size
 std D.UsrDis Set user service request table
 clrb SET Module directory address
 inca
 std D.ModDir Set module directory address
 stx D.ModDir+2 Set end
 leas $100,X get initial stack
*
* Find End Of Ram
*
COLD10    leay  ,x
         ldd   ,y
         ldx   #$00FF
         stx   ,y
         cmpx  ,y
         bne   COLD15
         ldx   #$FF00
         stx   ,y
         cmpx  ,y
         bne   COLD15
         std   ,y
         leax  >$0100,y
         cmpx  #$EC00
         bcs   COLD10
         leay  ,x
COLD15    leax  ,y
         stx   D.MLIM
COLD20    lbsr  VALMOD
         bcs   COLD30
         ldd   $02,x
         leax  d,x
         bra   L00B4
COLD30    cmpb  #$E7
         beq   COLD40
         leax  $01,x
L00B4    cmpx  #$FC00      FM7 **********
         bcs   COLD20
COLD40    leay  >SYSVEC,pcr
         leax  >ROMEnd,pcr
         pshs  x
         ldx   #$002C
COLD45 ldd ,Y++ get vector
 addd 0,S add offset
 std ,X++ init dp vector
 cmpx #D.NMI end of dp vectors?
 bls COLD45 branch if not
 leas 2,S return scratch
 leax USRIRQ,PCR Get user interrupt routine
 stx D.UsrIRQ
 leax USRREQ,PCR Get user service routine
 stx D.UsrSVC
 leax SYSIRQ,PCR Get system interrupt routine
 stx D.SysIRQ
 stx D.SvcIRQ Set interrupts to system state
 leax SYSREQ,PCR Get system service routine
 stx D.SysSVC
 stx D.SWI2 Set service to system state
 leax IOPOLL,PCR Set irq polling routine
 stx D.POLL
*
* Initialize Service Routine Dispatch Table
*
 leay SVCTBL,PCR Get ptr to service routine table
 lbsr SETSVC Set service table entries
 lda #SYSTM Get system type module
 leax CNFSTR,PCR Get initial module name ptr
 OS9 F$LINK Link to configuration module
 lbcs COLD Retry if error
 stu D.Init Save ptr
         ldd   $0A,u
         clrb
         cmpd  D.MLIM
         bcc   L0115
         std   D.MLIM
L0115    ldx   D.FMBM
         ldb   #$F0
         stb   ,x
         clra
         ldb   D.MLIM
         negb
         tfr   d,y
         negb
         lbsr  ALOCAT
         leax  >OS9STR,pcr
         lda   #$C1
 OS9 F$LINK
 lbcs COLD
 jmp 0,Y Let os9 part two finish

 ttl INTERRUPT Service handlers
 page
*****
*
*  Swi3 Interrupt Routine
*
SWI3RQ jmp [D.SWI3] Go thru page zero vector



*****
*
*  Swi2 Interrupt Routine
*
         jmp   [>$002E]
         jmp   [>$0030]
         jmp   [>$0032]
         jmp   [>$0034]
*****
*
*  Nmi Interrupt Routine
*
NMI jmp [D.NMI] Go thru page zero vector
 page
*****
*
*  Swi3 Handler
*
SWI3HN pshs B,X,PC Save registers
         ldb   #$18
         bra   SWIH10

         pshs  pc,x,b
         ldb   #$16
         bra   SWIH10



*****
*
*  Firq Handler
*
FIRQHN rti

*****
*
*  Irq Handler
*
IRQHN jmp [D.SvcIRQ] Go to interrupt service

*****
*
*  Swi Handler
*
SWIHN pshs B,X,PC Save registers
         ldb   #$14
SWIH10    ldx   >$004B
         ldx   b,x
         stx   $03,s
         puls  pc,x,b




*****
*
*  Nmi Handler
*
NMIHN equ FIRQHN
 page
*****
*
*  Interrupt Service Routine Usrirq
*
* Handles Irq While In User State
*
USRIRQ leay <USRI10,PCR Get post-switch routine
SWITCH clra SET Direct page
 tfr A,DP
 ldx D.PROC Get process
 ldd D.SysSVC Get system request routine
 std D.SWI2
 ldd D.SysIRQ Get system irq routine
 std D.SvcIRQ
 leau 0,S Copy user stack ptr
 stu P$SP,X
 lda P$State,X Set system state
 ora #SysState
 sta P$State,X
 jmp 0,Y Go to post-switch routine
USRI10    jsr   [>D.Poll]
         bcc   L0192
         ldb   ,s
         orb   #$10
         stb   ,s
L0192    lbra  USRRET

SYSIRQ    clra
         tfr   a,dp
         jsr   [>D.Poll]
         bcc   L01A4
         ldb   ,s
         orb   #$10
         stb   ,s
L01A4    rti



*****
*
*  Interrupt Polling Default
*
IOPOLL comb set carry
 rts
 page
*****
*
*  Clock Tick Routine
*
* Wake Sleeping Processes
*
TICK ldx D.SProcQ Get sleeping queue ptr
 beq SLICE Branch if none
 lda P$State,X Get process status
         bita  #$40
         beq   SLICE
         ldu   $04,x
         ldd   $04,u
         subd  #$0001
         std   $04,u
         bne   SLICE
L01BC    ldu   $0E,x
         bsr   L01EF
         leax  ,u
         beq   TICK20
         lda   $0D,x
         bita  #$40
         beq   TICK20
         ldu   $04,x
         ldd   $04,u
         beq   L01BC
TICK20 stx D.SProcQ Update sleep queue ptr
*
* Update Time Slice counter
*
SLICE dec D.Slice Count tick
 bne SLIC10 Branch if slice not over
 lda D.TSlice Get ticks/time-slice
 sta D.Slice Reset slice tick count
         ldx   D.Proc
         beq   SLIC10
         lda   $0D,x
         ora   #$20
         sta   $0D,x
         bpl   SLIC20
SLIC10    rti

SLIC20    leay  >USRRET,pcr
         bra   SWITCH

APRC     ldx   $04,u
L01EF    pshs  u,y
         ldu   #$003F
         bra   L01FD
L01F6    ldb   $0C,u
         incb
         beq   L01FD
         stb   $0C,u
L01FD    ldu   $0E,u
         bne   L01F6
         ldu   #$003F
         lda   $0B,x
         sta   $0C,x
         orcc  #$50
L020A    leay  ,u
         ldu   $0E,u
         beq   L0214
         cmpa  $0C,u
         bls   L020A
L0214    stu   $0E,x
         stx   $0E,y
         clrb
         puls  pc,u,y

USRREQ    leay  <USRR10,pcr
         orcc  #$50
         lbra  SWITCH
USRR10 andcc #$FF-IRQMask-FIRQMask Clear interrupt masks
 ldy D.UsrDis Get user service routine table
         bsr   L024D
USRRET    ldx   D.Proc
         beq   NXTPRC
         orcc  #$50
         ldb   $0D,x
         andb  #$7F
         stb   $0D,x
         bitb  #$20
         beq   L02A6
         andb  #$DF
         stb   $0D,x
         bsr   L01EF
         bra   NXTPRC

SYSREQ    clra
         tfr   a,dp
         leau  ,s
 ldy D.SysDis Get system service routine table
         bsr   L024D
         rti
L024D    pshs  u
         ldx   $0A,u
         ldb   ,x+
         stx   $0A,u
         lslb
         bcc   L025D
         rorb
         ldx   -$02,y
         bra   L0265
L025D    cmpb  #$6E
         bcc   L027C
         ldx   b,y
         beq   L027C
L0265    jsr   ,x
L0267    puls  u
         tfr   cc,a
         bcc   L026F
         stb   $02,u
L026F    ldb   ,u
         andb  #$F0
         stb   ,u
         anda  #$0F
         ora   ,u
         sta   ,u
         rts
L027C    comb
         ldb   #$D0
         bra   L0267
L0281    ldb   $0D,x
         orb   #$80
         stb   $0D,x
         ldb   <$36,x
         andcc #$AF
         os9   F$Exit

NXTPRC    clra
         clrb
         std   D.Proc
         bra   NXTP06
NXTP04 cwai #$FF-IRQMask-FIRQMask Clear interrupt masks & wait
NXTP06 orcc #IRQMask+FIRQMask Set interrupt masks
 ldx D.AProcQ Get first process in active queue
 beq NXTP04 Branch if none
*
* Remove Process from Active Queue
*
 ldd P$Queue,X Get next process ptr
 std D.AProcQ Remove first from active queue
         stx   D.Proc
         lds   $04,x
L02A6    ldb   $0D,x
         bmi   NXTP30
         bitb  #$02
         bne   L0281
         ldb   <$36,x
         beq   L02D4
         decb
         beq   L02D1
         ldu   <$37,x
         beq   L0281
         ldy   <$39,x
         ldd   $06,s
         pshs  u,y,b,a
         ldu   $0A,s
         lda   <$36,x
         ldb   $09,s
         tfr   d,y
         ldd   $06,s
         pshs  u,y,b,a
         clrb
L02D1    stb   <$36,x
L02D4    ldd   <$16,x
 std D.SWI2
 ldd D.UsrIRQ Get user irq
 std D.SvcIRQ
NXTP30    rti

LINK     pshs  u
         ldd   $01,u
         ldx   $04,u
         lbsr  FMODUL
         bcc   LINK10
         ldb   #$DD
         bra   LINKXit
LINK10    ldy   ,u
         ldb   $07,y
         bitb  #$80
         bne   LINK20
         tst   $02,u
         beq   LINK20
         comb
         ldb   #$D1
         bra   LINKXit
LINK20    inc   $02,u
         ldu   ,s
         stx   $04,u
         sty   $08,u
         ldd   $06,y
         std   $01,u
         ldd   $09,y
         leax  d,y
         stx   $06,u
LINKXit    puls  pc,u


VMOD     pshs  u
         ldx   $04,u
         bsr   VALMOD
         puls  y
         stu   $08,y
         rts

VALMOD    bsr   IDCHK
         bcs   VALM40
         lda   $06,x
         pshs  x,a
         ldd   $04,x
         leax  d,x
         puls  a
         lbsr  FMODUL
         puls  x
         bcs   VALM10
         ldb   #$E7
         cmpx  ,u
         beq   L0376
         lda   $07,x
         anda  #$0F
         pshs  a
         ldy   ,u
         lda   $07,y
         anda  #$0F
         cmpa  ,s+
         bcc   L0376
         pshs  y,x
         ldb   $02,u
         bne   VALM15
         ldx   ,u
 cmpx D.BTLO Is it rom/system module?
 bcc VALM15 Branch if so
         ldd   $02,x
         addd  #$00FF
         tfr   a,b
         clra
         tfr   d,y
         ldb   ,u
         ldx   D.FMBM
         os9   F$DelBit
         clr   $02,u
VALM15    puls  y,x
L036C    stx   ,u
         clrb
VALM40    rts
VALM10    leay  ,u
         bne   L036C
         ldb   #$CE
L0376    coma
         rts


IDCHK    ldd   ,x
         cmpd  #$87CD
         bne   L0386
         leay  $08,x
         bsr   PARITY
         bcc   L038A
L0386    comb
         ldb   #$CD
         rts
L038A    pshs  x
         ldy   $02,x
         bsr   CRCCHK
         puls  pc,x
PARITY    pshs  y,x
         clra
L0396    eora  ,x+
         cmpx  $02,s
         bls   L0396
         cmpa  #$FF
         puls  pc,y,x
CRCCHK    ldd   #$FFFF
         pshs  b,a
         pshs  b,a
         leau  $01,s
L03A9    lda   ,x+
         bsr   CRCCAL
         leay  -$01,y
         bne   L03A9
         clr   -$01,u
         lda   ,u
         cmpa  #$80
         bne   L03C1
         ldd   $01,u
         cmpd  #$0FE3
         beq   L03C4
L03C1    comb
         ldb   #$E8
L03C4    puls  pc,y,x

CRCGen   ldx   $04,u
         ldy   $06,u
         beq   L03D7
         ldu   $08,u
CRCGen10    lda   ,x+
         bsr   CRCCAL
         leay  -$01,y
         bne   CRCGen10
L03D7    clrb
         rts

CRCCAL    eora  ,u
         pshs  a
         ldd   $01,u
         std   ,u
         clra
         ldb   ,s
         lslb
         rola
         eora  $01,u
         std   $01,u
         clrb
         lda   ,s
         lsra
         rorb
         lsra
         rorb
         eora  $01,u
         eorb  $02,u
         std   $01,u
         lda   ,s
         lsla
         eora  ,s
         sta   ,s
         lsla
         lsla
         eora  ,s
         sta   ,s
         lsla
         lsla
         lsla
         lsla
         eora  ,s+
         bpl   CRCC99
         ldd   #$8021
         eora  ,u
         sta   ,u
         eorb  $02,u
         stb   $02,u
CRCC99    rts

FMODUL    ldu   #$0000
         tfr   a,b
         anda  #$F0
         andb  #$0F
         pshs  u,y,x,b,a
         bsr   SKIPSP
         cmpa  #$2F
         beq   FMOD35
         lbsr  PRSNAM
         bcs   FMOD40
 ldu D.ModDir Get module directory ptr
FMOD10    pshs  u,y,b
         ldu   ,u
         beq   FMOD20
         ldd   $04,u
         leay  d,u
         ldb   ,s
         lbsr  CHKNAM
         bcs   FMOD30
         lda   $05,s
         beq   L044B
         eora  $06,u
         anda  #$F0
         bne   FMOD30
L044B    lda   $06,s
         beq   L0455
         eora  $06,u
         anda  #$0F
         bne   FMOD30
L0455    puls  u,x,b
         stu   $06,s
         bsr   SKIPSP
         stx   $02,s
         clra
         bra   FMOD40
FMOD20    ldd   $0B,s
         bne   FMOD30
         ldd   $03,s
         std   $0B,s
FMOD30 puls B,Y,U Retrieve registers
 leau 4,U Move to next entry
 cmpu D.ModDir+2 End of directory?
         bcs   FMOD10
FMOD35    comb
FMOD40    puls  pc,u,y,x,b,a

SKIPSP    lda   #$20
L0476    cmpa  ,x+
         beq   L0476
         lda   ,-x
         rts

FORK     ldx   D.PrcDBT
         os9   F$All64
         bcs   PRCFUL
         ldx   D.Proc
         pshs  x
         ldd   $09,x
         std   $09,y
         lda   $0B,x
         clrb
         std   $0B,y
         ldb   #$80
         stb   $0D,y
         sty   D.Proc
         leax  <$1A,x
         leay  <$1A,y
         ldb   #$0C
FORK10    lda   ,x+
         sta   ,y+
         decb
         bne   FORK10
         ldb   #$03
L04A9    lda   ,x+
         os9   I$Dup
         bcc   FORK25
         clra
FORK25    sta   ,y+
         decb
         bne   L04A9
         bsr   SETPRC
         bcs   FORK40
         puls  y
         sty   D.Proc
         lda   ,x
         sta   $01,u
         ldb   $03,y
         sta   $03,y
         lda   ,y
         std   $01,x
         ldb   $0D,x
         andb  #$7F
         stb   $0D,x
         os9   F$AProc
         rts
FORK40    pshs  b
         os9   F$Exit
         comb
         puls  x,b
         stx   D.Proc
         rts
PRCFUL    comb
         ldb   #$E5
         rts

USRCHN   bsr   CHAIN
         bcs   L04FA
         orcc  #$50
         ldb   $0D,x
         andb  #$7F
         stb   $0D,x
USRC10    os9   F$AProc
         os9   F$NProc

SYSCHN   bsr   CHAIN
         bcc   USRC10
L04FA    pshs  b
         stb   <$36,x
         ldb   $0D,x
         orb   #$02
         stb   $0D,x
         ldb   #$FF
         stb   $0B,x
         comb
         puls  pc,b


CHAIN    pshs  u
         ldx   D.Proc
         ldu   <$12,x
         os9   F$UnLink
         ldu   ,s
         bsr   SETPRC
         puls  pc,u

SETPRC ldx D.PROC Get process ptr
 pshs X,U Save process & register ptr
 ldd D.UsrSVC Get user service request
 std P$SWI,X Reset swi vector
 std P$SWI2,X Reset swi2 vector
 std P$SWI3,X Reset swi3 vector
 clra
 clrb
         sta   <$36,x
         std   <$37,x
         lda   $01,u
         ldx   $04,u
         os9   F$Link
         bcc   L0541
         os9   F$Load
         bcs   L05B5
L0541    ldy   D.Proc
         stu   <$12,y
         cmpa  #$11
         beq   L0554
         cmpa  #$C1
         beq   L0554
         comb
         ldb   #$EA
         bra   L05B5
L0554    leay  ,u
         ldu   $02,s
         stx   $04,u
         lda   $02,u
         clrb
         cmpd  $0B,y
         bcc   L0564
         ldd   $0B,y
L0564    addd  #$0000
         bne   L056E
         comb
         ldb   #$DF
         bra   L05B5
L056E    os9   F$Mem
         bcs   L05B5
         subd  #$000C
         subd  $06,u
         bcs   L05B3
         ldx   $08,u
         ldd   $06,u
         pshs  b,a
         beq   L058C
         leax  d,x
L0584    lda   ,-x
         sta   ,-y
         cmpx  $08,u
         bhi   L0584
L058C    ldx   D.Proc
         sty   -$08,y
         leay  -$0C,y
         sty   $04,x
         lda   $07,x
         clrb
         std   $08,y
         sta   $03,y
         adda  $08,x
         std   $06,y
         puls  b,a
         std   $01,y
         ldb   #$80
         stb   ,y
         ldu   <$12,x
         ldd   $09,u
         leau  d,u
         stu   $0A,y
         clrb
L05B3    ldb   #$E6
L05B5    puls  pc,u,x
         ldd   $01,u
         addd  #$00FF
         clrb
         std   $01,u
         ldx   D.FMBM+2
         ldd   #$01FF
         pshs  b,a
         bra   L05D2
L05C8    dec   $01,s
         ldb   $01,s
L05CC    lsl   ,s
         bcc   L05D8
         rol   ,s
L05D2    leax  -$01,x
         cmpx  D.FMBM
         bcs   L05EE
L05D8    lda   ,x
         anda  ,s
         bne   L05C8
         dec   $01,s
         subb  $01,s
         cmpb  $01,u
         rora
         addb  $01,s
         rola
         bcs   L05CC
         ldb   $01,s
         clra
         incb
L05EE    leas  $02,s
         bcs   MEMFUL
         ldx   D.FMBM
         tfr   d,y
         ldb   $01,u
         clra
         exg   d,y
         bsr   ALOCAT
         exg   a,b
         std   $08,u
L0601    clra
         rts
MEMFUL    comb
         ldb   #$CF
         rts


SRTMEM   ldd   $01,u
         addd  #$00FF
         tfr   a,b
         clra
         tfr   d,y
         ldd   $08,u
         beq   L0601
         tstb
         beq   SRTM10
         comb
         ldb   #$D2
         rts
SRTM10    exg   a,b
         ldx   D.FMBM
         bra   DEALOC

ABIT     ldd   $01,u
         leau  $04,u
         pulu  y,x
ALOCAT    pshs  y,x,b,a
         bsr   FNDBIT
         tsta
         pshs  a
         bmi   L063F
         lda   ,x
ALOC10    ora   ,s
         leay  -$01,y
         beq   L0657
         lsr   ,s
         bcc   ALOC10
         sta   ,x+
L063F    tfr   y,d
         sta   ,s
         lda   #$FF
         bra   L0649
L0647    sta   ,x+
L0649    subb  #$08
         bcc   L0647
         dec   ,s
         bpl   L0647
L0651    lsla
         incb
         bne   L0651
         ora   ,x
L0657    sta   ,x
         clra
         leas  $01,s
         puls  pc,y,x,b,a

FNDBIT    pshs  b
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         leax  d,x
         puls  b
         lda   #$80
         andb  #$07
         beq   FNDB20
L0670    lsra
         decb
         bne   L0670
FNDB20    rts

DBIT     ldd   $01,u
         leau  $04,u
         pulu  y,x
DEALOC    pshs  y,x,b,a
         bsr   FNDBIT
         coma
         pshs  a
         bpl   L0692
         lda   ,x
L0686    anda  ,s
         leay  -$01,y
         beq   L06A6
         asr   ,s
         bcs   L0686
         sta   ,x+
L0692    tfr   y,d
         bra   L0698
L0696    clr   ,x+
L0698    subd  #$0008
         bhi   L0696
         beq   L06A6
L069F    lsla
         incb
         bne   L069F
         coma
         anda  ,x
L06A6    sta   ,x
         clr   ,s+
         puls  pc,y,x,b,a

SBIT     pshs  u
         ldd   $01,u
         ldx   $04,u
         ldy   $06,u
         ldu   $08,u
         bsr   FLOBLK
         puls  u
         std   $01,u
         sty   $06,u
         rts

FLOBLK    pshs  u,y,x,b,a
         pshs  y,b,a
         clr   $08,s
         clr   $09,s
         tfr   d,y
         bsr   FNDBIT
         pshs  a
         bra   L06DE
L06D1    leay  $01,y
         sty   $05,s
L06D6    lsr   ,s
         bcc   L06E2
         ror   ,s
         leax  $01,x
L06DE    cmpx  $0B,s
         bcc   L0700
L06E2    lda   ,x
         anda  ,s
         bne   L06D1
         leay  $01,y
         tfr   y,d
         subd  $05,s
         cmpd  $03,s
         bcc   L0707
         cmpd  $09,s
         bls   L06D6
         std   $09,s
         ldd   $05,s
         std   $01,s
         bra   L06D6
L0700    ldd   $01,s
         std   $05,s
         coma
         bra   FLOB40
L0707    std   $09,s
FLOB40    leas  $05,s
         puls  pc,u,y,x,b,a

PNAM     ldx   $04,u
         bsr   PRSNAM
         std   $01,u
         bcs   L0717
         stx   $04,u
L0717    sty   $06,u
         rts

PRSNAM    lda   ,x
         cmpa  #$2F
         bne   PRSNA1
         leax  $01,x
PRSNA1    leay  ,x
         clrb
         lda   ,y+
         anda  #$7F
         bsr   ALPHA
         bcs   L0740
PRSNA2    incb
         lda   -$01,y
         bmi   L073D
         lda   ,y+
         anda  #$7F
         bsr   ALFNUM
         bcc   PRSNA2
         lda   ,-y
L073D    andcc #$FE
         rts
L0740    cmpa  #$2C
         bne   L0746
L0744    lda   ,y+
L0746    cmpa  #$20
         beq   L0744
         lda   ,-y
         comb
         ldb   #$EB
         rts

ALFNUM    cmpa  #$2E
         beq   RETCC
         cmpa  #$30
         bcs   RETCS
         cmpa  #$39
         bls   RETCC
         cmpa  #$5F
         beq   RETCC
ALPHA    cmpa  #$41
         bcs   RETCS
         cmpa  #$5A
         bls   RETCC
         cmpa  #$61
         bcs   RETCS
         cmpa  #$7A
         bls   RETCC
RETCS    orcc  #$01
         rts

CNAM     ldb   $02,u
         leau  $04,u
         pulu  y,x
CHKNAM    pshs  y,x,b,a
CHKN10    lda   ,y+
         bmi   CHKN20
         decb
         beq   RETCS1
         eora  ,x+
         anda  #$DF
         beq   CHKN10
RETCS1    comb
         puls  pc,y,x,b,a
CHKN20    decb
         bne   RETCS1
         eora  ,x
         anda  #$5F
         bne   RETCS1
         puls  y,x,b,a
RETCC    andcc #$FE
         rts

SSVC     ldy   $06,u
         bra   SETSVC
SETS10    tfr   b,a
         anda  #$7F
         cmpa  #$7F
         beq   SETS30
         cmpa  #$37
         bcs   SETS30
         comb
         ldb   #$E3
         rts

SETS30 aslb MAKE Table offset
 ldu D.SysDis Get system service table
 leau B,U Get entry ptr
         ldd   ,y++
         leax  d,y
         stx   ,u
         bcs   SETSVC
         stx   <$70,u

SETSVC    ldb   ,y+
         cmpb  #$80
         bne   SETS10
         rts

* Loads new interrupt vectors
DATINT   clra
         tfr   a,dp
         orcc  #$50
         leau  >L001F,pcr
         ldx   ,u++
         pshs  u,x
         clr   ,x
         stx   ,--s
         leax  >L07FF,pcr
         ldu   #$FFF2
         ldb   #$06
L07DF    ldy   ,x++
         sty   ,u++
         decb
         bne   L07DF
         puls  pc,u,x
         emod
OS9End      equ   *

        fcb     $F5,$9A
SYSVEC  fcb $F9,$3F,$F9,$45,$F9,$4B,$F9,$4C,$F9,$50,$F9,$4B,$00,$00
        fcb     $00,$00
L07FF   fcb  $F5,$27,$F5,$2B,$F5,$2F,$F5,$33,$F5,$37,$F5,$3B,$FB,$B8

ROMEnd equ *
