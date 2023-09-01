         nam   OS9p1
         ttl   os9 system module

***************************************************
* This file is from the SuperPET
***************************************************

 use defsfile

tylg     set   Systm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   OS9End,OS9Nam,tylg,atrv,COLD,0

OS9Nam     equ   *
         fcs   /OS9p1/
         fcb   14

 fcc "SP9000"

CNFSTR fcs /Init/ Configuration module name
OS9STR fcs /OS9p2/ Kernal, part 2 name
 page
*****
*
* System Service Routine Table
*
SVCTBL equ *
 fcb F$LINK
 fdb LINK-*-2
 fcb F$FORK
 fdb FORK-*-2
 fcb F$Chain
 fdb USRCHN-*-2
 fcb F$Chain+$80
 fdb SYSCHN-*-2
 fcb F$PrsNam
 fdb PNAM-*-2
 fcb F$CmpNam
 fdb CNAM-*-2
 fcb F$SchBit
 fdb SBIT-*-2
 fcb F$AllBit
 fdb ABIT-*-2
 fcb F$DelBit
 fdb DBIT-*-2
 fcb F$CRC
 fdb CRCGen-*-2
 fcb F$SRqMem+$80
 fdb SRQMEM-*-2
 fcb F$SRtMem+$80
 fdb SRTMEM-*-2
 fcb F$AProc+$80
 fdb APRC-*-2
 fcb F$NProc+$80
 fdb NXTPRC-*-2
 fcb F$VModul+$80
 fdb VMOD-*-2
 fcb F$SSVC
 fdb SSVC-*-2
 fcb $80



 ttl COLD Start
 page
*
* Clear System Memory, Skipping First 32 Bytes
*
LORAM set $20
HIRAM set $300
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
         lds   #$0800
         ldx   #$0000
         stx   D.BTHI
         leax  ,u
         stx   D.BTLO
 stx D.MLIM Set memory limit
*
* Search Memory For Modules, Build Module Directory
*
COLD20 lbsr VALMOD Look for valid module
         bcs   COLD30
         ldd   $02,x
         leax  d,x
         bra   COLD35
COLD30    cmpb  #$E7
         beq   COLD40
         leax  $01,x
COLD35    bne   COLD20
COLD40    leay  >SYSVEC,pcr
         leax  >ROMEnd,pcr
         pshs  x
         ldx   #$002C
L00A6    ldd   ,y++
         addd  ,s
         std   ,x++
         cmpx  #$0036
         bls   L00A6
         leas  $02,s
         leax  >USRIRQ,pcr
         stx   D.UsrIRQ
         leax  >USRREQ,pcr
         stx   D.UsrSVC
         leax  >SYSIRQ,pcr
         stx   D.SysIRQ
         stx   D.SvcIRQ
         leax  >SYSREQ,pcr
         stx   D.SysSVC
         stx   D.SWI2
         leax  >IOPOLL,pcr
         stx   D.POLL
*
* Initialize Service Routine Dispatch Table
*
         leay  >SVCTBL,pcr
         lbsr  SETSVC
         lda   #$C0
         leax  >CNFSTR,pcr
         os9   F$Link
         lbcs  COLD
         stu   D.Init
         ldd   $0A,u
         clrb
         cmpd  D.MLIM
         bcc   COLD50
         std   D.MLIM
COLD50    ldx   D.FMBM
         ldb   #$FF
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

         ldd   [<$0A,s]
         cmpa  #$21
         bne   L0131
         tfr   b,a
         ldb   $02,s
         jsr   >$0600
         lda   ,s
         bcc   L012A
         ora   #$01
         bra   L012C
L012A    anda  #$FE
L012C    stb   $02,s
         sta   ,s
         rti

L0131    puls  b,a,cc
         pshs  b,a,cc
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
SWI2RQ jmp [D.SWI2] Go thru page zero vector



*****
*
*  Firq Interrupt Handler
*
FIRQ jmp [D.FIRQ] Go thru page zero vector

         lda   #$08
         jsr   >$0600
         bcc   L016D
         leau  $01,s
         pulu  y,x,dp,b,a
         ldu   ,u
IRQ jmp [D.IRQ] Go thru page zero vector



*****
*
*  Swi Interrupt Routine
*
SWIRQ jmp [D.SWI] Go thru page zero vector

         lda   #$0C
         jsr   >$0600
         bcc   L016D
         lda   #$10
         anda  ,s
         bne   L016D
         leau  $01,s
         pulu  y,x,dp,b,a
         ldu   ,u
NMI jmp [D.NMI] Go thru page zero vector

L016D    rti

SWI3HN         pshs  pc,x,b
 ldb #P$SWI3 Use swi3 vector
 bra SWIH10

SWI2HN         pshs  pc,x,b
         ldb   #P$SWI2
         bra   SWIH10

FIRQHN         rti

IRQHN         jmp [D.SvcIRQ] Go to interrupt service



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
USRIRQ    leay  <USRI10,pcr
SWITCH    clra
         tfr   a,dp
         ldx   D.Proc
         ldd   D.SysSVC
         std   D.SWI2
         ldd   D.SysIRQ
         std   D.SvcIRQ
         leau  ,s
         stu   $04,x
         lda   $0D,x
         ora   #$80
         sta   $0D,x
         jmp   ,y
USRI10    jsr   [>$003A]
         bcc   L01B4
         ldb   ,s
         orb   #$10
         stb   ,s
L01B4    lbra  USRRET



*****
*
*  Interrupt Routine Sysirq
*
* Handles Irq While In System State
*
SYSIRQ    clra
         tfr   a,dp
         jsr   [>$003A]
         bcc   L01C6
         ldb   ,s
         orb   #$10
         stb   ,s
L01C6    rti

IOPOLL    comb
         rts

TICK    ldx   D.SProcQ
         beq   SLICE
         lda   $0D,x
         bita  #$40
         beq   SLICE
         ldu   $04,x
         ldd   $04,u
         subd  #$0001
         std   $04,u
         bne   SLICE
L01DE    ldu   $0E,x
         bsr   ACTPRC
         leax  ,u
         beq   L01F2
         lda   $0D,x
         bita  #$40
         beq   L01F2
         ldu   $04,x
         ldd   $04,u
         beq   L01DE
L01F2    stx   D.SProcQ

SLICE    dec   D.Slice
         bne   SLIC10
         lda   D.TSlice
         sta   D.Slice
         ldx   D.Proc
         beq   SLIC10
         lda   $0D,x
         ora   #$20
         sta   $0D,x
         bpl   SLIC20
SLIC10    rti
SLIC20    leay  >USRRET,pcr
         bra   SWITCH

APRC         ldx   $04,u
ACTPRC    pshs  u,y
         ldu   #$003F
         bra   L021F
L0218    ldb   $0C,u
         incb
         beq   L021F
         stb   $0C,u
L021F    ldu   $0E,u
         bne   L0218
         ldu   #$003F
         lda   $0B,x
         sta   $0C,x
         orcc  #$50
L022C    leay  ,u
         ldu   $0E,u
         beq   L0236
         cmpa  $0C,u
         bls   L022C
L0236    stu   $0E,x
         stx   $0E,y
         clrb
         puls  pc,u,y

USRREQ    leay  <USRR10,pcr
         orcc  #$50
         lbra  SWITCH
USRR10    andcc #$AF
         ldy   D.UsrDis
         bsr   DISPCH
USRRET    ldx   D.Proc
         beq   NXTPRC
         orcc  #$50
         ldb   $0D,x
         andb  #$7F
         stb   $0D,x
         bitb  #$20
         beq   CURPRC
         andb  #$DF
         stb   $0D,x
         bsr   ACTPRC
         bra   NXTPRC

SYSREQ    clra
         tfr   a,dp
         leau  ,s
         ldy   D.SysDis
         bsr   DISPCH
         rti

DISPCH    pshs  u
         ldx   $0A,u
         ldb   ,x+
         stx   $0A,u
         lslb
         bcc   L027F
         rorb
         ldx   -$02,y
         bra   L0287
L027F    cmpb  #$6E
         bcc   BADSVC
         ldx   b,y
         beq   BADSVC
L0287    jsr   ,x
L0289    puls  u
         tfr   cc,a
         bcc   L0291
         stb   $02,u
L0291    ldb   ,u
         andb  #$F0
         stb   ,u
         anda  #$0F
         ora   ,u
         sta   ,u
         rts
BADSVC    comb
         ldb   #$D0
         bra   L0289
NXTOUT    ldb   $0D,x
         orb   #$80
         stb   $0D,x
         ldb   <$36,x
         andcc #$AF
         os9   F$Exit
NXTPRC    clra
         clrb
         std   D.Proc
         bra   L02B9

L02B7    cwai  #$AF
L02B9    orcc  #$50
         ldx   D.AProcQ
         beq   L02B7
         ldd   $0E,x
         std   D.AProcQ
         stx   D.Proc
         lds   $04,x
CURPRC    ldb   $0D,x
         bmi   NXTP30
         bitb  #$02
         bne   NXTOUT
         ldb   <$36,x
         beq   L02F6
         decb
         beq   L02F3
         ldu   <$37,x
         beq   NXTOUT
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
L02F3    stb   <$36,x
L02F6    ldd   <$16,x
         std   D.SWI2
         ldd   D.UsrIRQ
         std   D.SvcIRQ
NXTP30    rti

LINK         pshs  u
         ldd   $01,u
         ldx   $04,u
         lbsr  FMODUL
         bcc   L030F
         ldb   #$DD
         bra   LINKXit
L030F    ldy   ,u
         ldb   $07,y
         bitb  #$80
         bne   L0321
         tst   $02,u
         beq   L0321
         comb
         ldb   #$D1
         bra   LINKXit
L0321    inc   $02,u
         ldu   ,s
         stx   $04,u
         sty   $08,u
         ldd   $06,y
         std   $01,u
         ldd   $09,y
         leax  d,y
         stx   $06,u
LINKXit    puls  pc,u


VMOD         pshs  u
         ldx   $04,u
         bsr   VALMOD
         puls  y
         stu   $08,y
         rts
VALMOD    bsr   IDCHK
         bcs   L0391
         lda   $06,x
         pshs  x,a
         ldd   $04,x
         leax  d,x
         puls  a
         lbsr  FMODUL
         puls  x
         bcs   L0392
         ldb   #$E7
         cmpx  ,u
         beq   BADVAL
         lda   $07,x
         anda  #$0F
         pshs  a
         ldy   ,u
         lda   $07,y
         anda  #$0F
         cmpa  ,s+
         bcc   BADVAL
         pshs  y,x
         ldb   $02,u
         bne   L038C
         ldx   ,u
         cmpx  D.BTLO
         bcc   L038C
         ldd   $02,x
         addd  #$00FF
         tfr   a,b
         clra
         tfr   d,y
         ldb   ,u
         ldx   D.FMBM
         os9   F$DelBit
         clr   $02,u
L038C    puls  y,x
L038E    stx   ,u
         clrb
L0391    rts
L0392    leay  ,u
         bne   L038E
         ldb   #$CE
BADVAL    coma
         rts

IDCHK    ldd   ,x
         cmpd  #$87CD
         bne   L03A8
         leay  $08,x
         bsr   PARITY
         bcc   L03AC
L03A8    comb
         ldb   #$CD
         rts
L03AC    pshs  x
         ldy   $02,x
         bsr   CRCCHK
         puls  pc,x

PARITY    pshs  y,x
         clra
L03B8    eora  ,x+
         cmpx  $02,s
         bls   L03B8
         cmpa  #$FF
         puls  pc,y,x

CRCCHK    ldd   #$FFFF
         pshs  b,a
         pshs  b,a
         leau  $01,s
L03CB    lda   ,x+
         bsr   CRCCAL
         leay  -$01,y
         bne   L03CB
         clr   -$01,u
         lda   ,u
         cmpa  #$80
         bne   L03E3
         ldd   $01,u
         cmpd  #$0FE3
         beq   L03E6
L03E3    comb
         ldb   #$E8
L03E6    puls  pc,y,x

CRCGen         ldx   $04,u
         ldy   $06,u
         beq   L03F9
         ldu   $08,u
L03F1    lda   ,x+
         bsr   CRCCAL
         leay  -$01,y
         bne   L03F1
L03F9    clrb
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
         bpl   L0439
         ldd   #$8021
         eora  ,u
         sta   ,u
         eorb  $02,u
         stb   $02,u
L0439    rts

FMODUL    ldu   #$0000
         tfr   a,b
         anda  #$F0
         andb  #$0F
         pshs  u,y,x,b,a
         bsr   SKIPSP
         cmpa  #$2F
         beq   L0493
         lbsr  PRSNAM
         bcs   L0494
         ldu   D.ModDir
L0452    pshs  u,y,b
         ldu   ,u
         beq   L0482
         ldd   $04,u
         leay  d,u
         ldb   ,s
         lbsr  CHKNAM
         bcs   L048A
         lda   $05,s
         beq   L046D
         eora  $06,u
         anda  #$F0
         bne   L048A
L046D    lda   $06,s
         beq   L0477
         eora  $06,u
         anda  #$0F
         bne   L048A
L0477    puls  u,x,b
         stu   $06,s
         bsr   SKIPSP
         stx   $02,s
         clra
         bra   L0494
L0482    ldd   $0B,s
         bne   L048A
         ldd   $03,s
         std   $0B,s
L048A    puls  u,y,b
         leau  $04,u
         cmpu  D.ModDir+2
         bcs   L0452
L0493    comb
L0494    puls  pc,u,y,x,b,a

SKIPSP    lda   #$20
L0498    cmpa  ,x+
         beq   L0498
         lda   ,-x
         rts

FORK         ldx   D.PrcDBT
         os9   F$All64
         bcs   L0502
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
L04C2    lda   ,x+
         sta   ,y+
         decb
         bne   L04C2
         ldb   #$03
L04CB    lda   ,x+
         os9   I$Dup
         bcc   L04D3
         clra
L04D3    sta   ,y+
         decb
         bne   L04CB
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

L0502    comb
         ldb   #$E5
         rts

USRCHN         bsr   CHAIN
         bcs   L051C
         orcc  #$50
         ldb   $0D,x
         andb  #$7F
         stb   $0D,x
L0512    os9   F$AProc
         os9   F$NProc

SYSCHN         bsr   CHAIN
         bcc   L0512
L051C    pshs  b
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
SETPRC    ldx   D.Proc
         pshs  u,x
         ldd   D.UsrSVC
         std   <$14,x
         std   <$16,x
         std   <$18,x
         clra
         clrb
         sta   <$36,x
         std   <$37,x
         lda   $01,u
         ldx   $04,u
         os9   F$Link
         bcc   L0563
         os9   F$Load
         bcs   SETP50
L0563    ldy   D.Proc
         stu   <$12,y
         cmpa  #$11
         beq   L0576
         cmpa  #$C1
         beq   L0576
         comb
         ldb   #$EA
         bra   SETP50
L0576    leay  ,u
         ldu   $02,s
         stx   $04,u
         lda   $02,u
         clrb
         cmpd  $0B,y
         bcc   SETP20
         ldd   $0B,y
SETP20    addd  #$0000
         bne   L0590
         comb
         ldb   #$DF
         bra   SETP50
L0590    os9   F$Mem
         bcs   SETP50
         subd  #$000C
         subd  $06,u
         bcs   L05D5
         ldx   $08,u
         ldd   $06,u
         pshs  b,a
         beq   L05AE
         leax  d,x
L05A6    lda   ,-x
         sta   ,-y
         cmpx  $08,u
         bhi   L05A6
L05AE    ldx   D.Proc
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
L05D5    ldb   #$E6
SETP50    puls  pc,u,x

SRQMEM        ldd   $01,u
         addd  #$00FF
         clrb
         std   $01,u
         ldx   D.FMBM+2
         ldd   #$01FF
         pshs  b,a
         bra   L05F4
L05EA    dec   $01,s
         ldb   $01,s
L05EE    lsl   ,s
         bcc   L05FA
         rol   ,s
L05F4    leax  -$01,x
         cmpx  D.FMBM
         bcs   L0610
L05FA    lda   ,x
         anda  ,s
         bne   L05EA
         dec   $01,s
         subb  $01,s
         cmpb  $01,u
         rora
         addb  $01,s
         rola
         bcs   L05EE
         ldb   $01,s
         clra
         incb
L0610    leas  $02,s
         bcs   MEMFUL
         ldx   D.FMBM
         tfr   d,y
         ldb   $01,u
         clra
         exg   d,y
         bsr   ALOCAT
         exg   a,b
         std   $08,u
L0623    clra
         rts
MEMFUL    comb
         ldb   #$CF
         rts

SRTMEM         ldd   $01,u
         addd  #$00FF
         tfr   a,b
         clra
         tfr   d,y
         ldd   $08,u
         beq   L0623
         tstb
         beq   L063E
         comb
         ldb   #$D2
         rts
L063E    exg   a,b
         ldx   D.FMBM
         bra   DEALOC

ABIT         ldd   $01,u
         leau  $04,u
         pulu  y,x
ALOCAT    pshs  y,x,b,a
         bsr   FNDBIT
         tsta
         pshs  a
         bmi   L0661
         lda   ,x
L0655    ora   ,s
         leay  -$01,y
         beq   L0679
         lsr   ,s
         bcc   L0655
         sta   ,x+
L0661    tfr   y,d
         sta   ,s
         lda   #$FF
         bra   L066B
L0669    sta   ,x+
L066B    subb  #$08
         bcc   L0669
         dec   ,s
         bpl   L0669
L0673    lsla
         incb
         bne   L0673
         ora   ,x
L0679    sta   ,x
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
         beq   L0696
L0692    lsra
         decb
         bne   L0692
L0696    rts

DBIT         ldd   $01,u
         leau  $04,u
         pulu  y,x
DEALOC    pshs  y,x,b,a
         bsr   FNDBIT
         coma
         pshs  a
         bpl   L06B4
         lda   ,x
L06A8    anda  ,s
         leay  -$01,y
         beq   L06C8
         asr   ,s
         bcs   L06A8
         sta   ,x+
L06B4    tfr   y,d
         bra   L06BA
L06B8    clr   ,x+
L06BA    subd  #$0008
         bhi   L06B8
         beq   L06C8
DEAL25    lsla
         incb
         bne   DEAL25
         coma
         anda  ,x
L06C8    sta   ,x
         clr   ,s+
         puls  pc,y,x,b,a

SBIT         pshs  u
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
         bra   L0700
L06F3    leay  $01,y
         sty   $05,s
L06F8    lsr   ,s
         bcc   L0704
         ror   ,s
         leax  $01,x
L0700    cmpx  $0B,s
         bcc   L0722
L0704    lda   ,x
         anda  ,s
         bne   L06F3
         leay  $01,y
         tfr   y,d
         subd  $05,s
         cmpd  $03,s
         bcc   L0729
         cmpd  $09,s
         bls   L06F8
         std   $09,s
         ldd   $05,s
         std   $01,s
         bra   L06F8
L0722    ldd   $01,s
         std   $05,s
         coma
         bra   L072B
L0729    std   $09,s
L072B    leas  $05,s
         puls  pc,u,y,x,b,a

PNAM         ldx   $04,u
         bsr   PRSNAM
         std   $01,u
         bcs   L0739
         stx   $04,u
L0739    sty   $06,u
         rts

PRSNAM    lda   ,x
         cmpa  #$2F
         bne   L0745
         leax  $01,x
L0745    leay  ,x
         clrb
         lda   ,y+
         anda  #$7F
         bsr   ALPHA
         bcs   L0762
L0750    incb
         lda   -$01,y
         bmi   L075F
         lda   ,y+
         anda  #$7F
         bsr   ALFNUM
         bcc   L0750
         lda   ,-y
L075F    andcc #$FE
         rts

L0762    cmpa  #$2C
         bne   L0768
L0766    lda   ,y+
L0768    cmpa  #$20
         beq   L0766
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

CNAM         ldb   $02,u
         leau  $04,u
         pulu  y,x
CHKNAM    pshs  y,x,b,a
CHKN10    lda   ,y+
         bmi   L07AD
         decb
         beq   L07AA
         eora  ,x+
         anda  #$DF
         beq   CHKN10
L07AA    comb
         puls  pc,y,x,b,a
L07AD    decb
         bne   L07AA
         eora  ,x
         anda  #$5F
         bne   L07AA
         puls  y,x,b,a
RETCC    andcc #$FE
         rts

SSVC         ldy   $06,u
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

SETS30    lslb
         ldu   D.SysDis
         leau  b,u
         ldd   ,y++
         leax  d,y
         stx   ,u
         bcs   SETSVC
         stx   <$70,u
SETSVC    ldb   ,y+
         cmpb  #$80
         bne   SETS10
         rts

         emod
OS9End      equ   *

 fcc "9999999999999999999999999999999999999999999999999999"
 fcb $0D
 fcc "9999999999999999999999999999999999999999999999999999999999"
 fcc "9999999999999999999999999999999999999999999999999999999999"
 fcc "9999999999999999999999999999999999999999999999999999999999"
 fcc "999999999999999999999"
SYSVEC equ *
 fcc "999999999999999999999999999999"

ROMEnd equ *


 end
