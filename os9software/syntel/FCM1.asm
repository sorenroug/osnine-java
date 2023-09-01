         nam   FCM1
         ttl   os9 device driver

 use defsfile

tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   1
u0001    rmb   5
XV.NDRV    rmb   9
XDRVBEG    rmb   76
CURTBL    rmb   2
u005D    rmb   1
u005E    rmb   2
u0060    rmb   1
V.CMDR    rmb   2
u0063    rmb   2
u0065    rmb   2
u0067    rmb   2
u0069    rmb   2
u006B    rmb   2
u006D    rmb   2
u006F    rmb   2
u0071    rmb   2
u0073    rmb   2
V.SEL    rmb   3
u0078    rmb   1
u0079    rmb   1
u007A    rmb   2
V.FREZ    rmb   1
u007D    rmb   1
size     equ   .
         fcb   $FF
name     equ   *
         fcs   /FCM1/
         fcb   $01
start    equ   *
         lbra  INIDSK
         lbra  READSK
         lbra  WRTDSK
         lbra  GETSTA
         lbra  PUTSTA
         lbra  TERMNT

PUTSTA ldx PD.RGS,Y Point to parameters
 ldb R$B,X Get stat call
 cmpb #SS.Reset Restore call?
         lbeq  RESTOR
 cmpb #SS.WTrk Write track call?
         lbeq  WRTTRK
 cmpb #SS.FRZ Freeze dd. info?
         beq   SETFRZ
 cmpb #SS.SPT Set sect/trk?
         beq   SETSPT

GETSTA comb ...NO; Error
 ldb #E$UnkSvc Error code
 rts


SETFRZ ldb #$FF
 stb V.FREZ,u Set flag
 clrb
 rts


SETSPT lbsr SELECT Find drive table
 ldd R$X,x Get input sect/trk
 ldx CURTBL,u Point to drive table
 stb DD.TKS,x
 clrb
 rts
 pag
****************************************************************
*
* Initialize The I/O Port
*
*  Input: (U)= Pointer To Global Storage
*
*  On Exit: (A) Modified
*           (X) Modified
*           (Y) Unchanged
*           (U) Unchanged
*
INIDSK ldx V.PORT,U Point to i/o port
         stx   <V.SEL,u
         leax  >$0100,x
         stx   <u0069,u
         leax  $02,x
         stx   <u006B
         leax  $0E,x
         stx   <u006D,u
         leax  $04,x
         stx   <u006F,u
         leax  $03,x
         stx   <u0071,u
         leax  $01,x
         stx   <u005E,u
         leax  $01,x
         stx   <u0073,u
         leax  $07,x
         stx   <V.CMDR,u
         leax  $01,x
         stx   <u0063,u
         leax  $01,x
         stx   <u0065,u
         leax  $01,x
         stx   <u0067,u
 lda #$FF
 ldb #DriveCnt
 stb V.NDRV,U Inz number of drives
 leax DRVBEG,U Point to first drive table
INILUP sta DD.TOT+2,X Inz to non-zero
 sta V.TRAK,X Inz to high track count
 leax DRVMEM,X Point to next drive table
 decb DONE
 bne INILUP ...no; inz more.
         lda   #$80
         sta   [<u005E,u]
         lda   #$06
L00AB    ldx   #$FFFF
L00AE    leax  -$01,x
         bne   L00AE
         deca
         bne   L00AB
         clr   [<u006F,u]
         clrb
RETRN1    rts
 pag
*********************************************************
*
* Restore Drive To Track Zero
*
*  Input: (Y)= Pointer To Path Descriptor
*         (U)= Pointer To Global Storage
*
*  If Error: (B)= Error Code & Carry Is Set
*
* Note:  We Are Stepping In One Track Before
*        Issuing The Restore.  As Suggested In The
*        Application Notes.
*
RESTOR    lbsr  SELECT
         bcs   RETRN1
L00BF    ldx   <CURTBL,u
 clr V.TRAK,X Old track = 0
         ldb   #$0F
         lbsr  WCR0
         lda   [<V.CMDR,u]
         bita  #$10
         beq   L00EB
         lda   #$05
L00D3    ldb   #$4B
         pshs  a
         lbsr  WCR0
         puls  a
         deca
         bne   L00D3
         ldb   #$0F
         lbsr  WCR0
         lda   [<V.CMDR,u]
         bita  #$10
         bne   ERSEEK
L00EB    clrb
         rts

ERSEEK comb
 ldb #E$SEEK Error: seek error
 rts

WRTDSK    lbsr  SELECT
         bcs   WRERR
         lbsr  PHYSIC
         bcs   WRERR
         lda   #$85
         sta   <u007D,u
L0100    lbsr  L020D
         bcs   L0111
         ldx   #$0000
         lbsr  L030B
         bcc   L0127
         cmpb  #E$WP
         beq   L013A
L0111    dec   <u007D,u
         lda   <u007D,u
         beq   WRERR
         cmpa  #$80
         bne   L0100
         lbsr  RESTOR
         lda   #$05
         sta   <u007D,u
         bra   L0100
L0127 tst PD.VFY,Y Verify desired?
         bne   RETRN2
         ldx   #$1F00
         lbsr  L033C
         bcs   L0100
RETRN2    clrb
         rts

WRERR comb
 ldb #E$Write
 rts

L013A    coma
         rts

WRTTRK    clrb
         rts

*************************************************************
*
* Read Sector Command
*
* Input: B = Msb Of Logical Sector Number
*        X = Lsb'S Of Logical Sector Number
*        Y = Ptr To Path Descriptor
*        U = Ptr To Global Storage
*
* Output: 256 Bytes Of Data Returned In Buffer
*
* Error: Cc=Set, B=Error Code
*
READSK    lbsr  SELECT
         bcs   L017F
 cmpx #0 Is this sector zero?
         lbeq  L0180
         lbsr  PHYSIC
         bcs   L017F
         lda   #$85
         sta   <u007D,u
L0154    lbsr  L020D
         bcs   L0166
         ldx   #$0000
         lbsr  L033C
         bcs   L0166
         lbsr  L0385
         clrb
         rts
L0166    dec   <u007D,u
         lda   <u007D,u
         beq   RDERR
         cmpa  #$80
         bne   L0154
         lbsr  L00BF
         lda   #$0A
         sta   <u007D,u
         bra   L0154

RDERR comb
 ldb #E$Read
L017F    rts

****************************************************************
*
* Read Logical Sector Zero
*
*
*
L0180    ldb   #$00
         stb   [<u0065,u]
         stb   <u007A,u
         clr   <u0079,u
         clr   <u0078,u
         lbsr  L00BF
         clrb
         ldx   #$0000
         lbsr  L033C
         bcs   RDERR2
         lbsr  L0385
         ldx   $08,y
         pshs  y,x
         tst   <V.FREZ,u
         bne   L01B3
         ldy   <CURTBL,u
         ldb   #$14
L01AC    lda   b,x
         sta   b,y
         decb
         bne   L01AC
L01B3    clrb
         puls  pc,y,x

RDERR2 comb
 ldb #E$Read
 rts

SELECT lda PD.DRV,Y Get drive number
 cmpa V.NDRV,U Drive num ok?
 bhs ERUNIT ..no; report error.
 pshs B,X Save regs
         cmpa  <u005D,u
         beq   L01D9
         sta   <u005D,u
         lbsr  L02D1
         ldb   [<u0063,u]
         stb   [<u0067,u]
         ldb   #$10
         lbsr  WCR0
L01D9    lda   PD.DRV,Y
         leax  DRVBEG,u
         ldb   #$26
         mul
         leax  d,x
 stx CURTBL,U Current table ptr
         clr   <u0078,u
         lda   #$D0
         ldb   <u005D,u
         beq   L01F2
         ora   #$01
L01F2    sta   [<u005E,u]
         sta   <u0060,u
         lbsr  L02D1
         lda   [<V.CMDR,u]
         bmi   ERNRDY
         puls  pc,x,b

ERNRDY    puls  b
 comb
 ldb #E$NotRdy Error: drive not ready
 puls  pc,x

ERUNIT comb
 ldb #E$UNIT Error: illegal unit (drive)
 rts

L020D    pshs  a
         lda   <u0079,u
         ldx   <CURTBL,u
         ldb   <$15,x
         stb   [<u0063,u]
         cmpa  <$15,x
         beq   L0238
         sta   [<u0067,u]
         ldb   #$1F
         lbsr  WCR0
         lda   [<V.CMDR,u]
         bita  #$10
         bne   ERSEEK2
         lda   <u0079,u
         sta   <$15,x
         sta   [<u0063,u]
L0238    clrb
         puls  pc,a

ERSEEK2    comb
         ldb   #E$Seek
         puls  pc,a

 pag
**************************************************************
*
* Convert Logical Sector Number
* To Physical Track And Sector
*
*  Input:  B = Msb Of Logical Sector Number
*          X = Lsb'S Of Logical Sector Number
*  Output: A = Physical Track Number
*          Sector Reg = Physical Sector Number
*  Error:  Carry Set & B = Error Code
*
PHYSIC tstb CHECK Sector bounds
 bne PHYERR  msb must be zero
 tfr X,D Logical sector (os-9)
 cmpd #0 Logical sector zero?
 beq PHYSC7 ..yes; skip conversion.
 ldx CURTBL,U
 cmpd DD.TOT+1,X Too high sector number?
 bhs PHYERR ..yes; sorry
         clr   ,-s
         pshs  b,a
         ldb DD.TKS,X
         clra
         pshs  b,a
         ldd   $02,s
         dec   $04,s
L0260    inc   $04,s
         subd  ,s
         bge   L0260
         addd  ,s
         stb   <u007A,u
         clr   <u0078,u
         clrb
 lda DD.FMT,X
         lsra
         bcc   L027B
         lsr   $04,s
         bcc   L027B
         ldb   #$08
L027B    stb   <u0078,u
         orb   <u0060,u
         stb   <u0060,u
         stb   [<u005E,u]
         lda   $04,s
         sta   <u0079,u
         ldb   <u007A,u
         stb   [<u0065,u]
         lbsr  DELAY
         leas  $05,s
         clrb
         rts

PHYERR comb
 ldb #E$SECT Error: bad sector number
 rts

PHYSC7    clr   <u0079,u
         clr   [<u0065,u]
         lbsr  DELAY
         clr   <u0078,u
         clr   <u007A,u
         clrb
         rts
WCR0 eorb PD.STP,Y Add step rate to command

 bsr WCR Issue command & delay
WCR02 ldb [V.CMDR,U] Get status
 bitb #%00000001 Busy?
 bne WCR02 ..yes; wait for it.
 rts

WCR    bsr   L02D1
         lda   [<V.CMDR,u]
         bmi   L02CD
 stb [V.CMDR,U] Issue command


DELAY bsr DELAY1
DELAY1 bsr DELAY2
DELAY2 bsr DELAY4
DELAY4 nop
 rts

L02CD    comb
         ldb   #E$NotRdy
         rts

L02D1    pshs  a
         lda   #$D0
         sta   [<V.CMDR,u]
         bsr   DELAY
L02DA    lda   [<V.CMDR,u]
         asra
         bcs   L02DA
         puls  pc,a

L02E2    pshs  y,x,b,a
         ldb   $01,s
         lda   #$00
         sta   >$C114
L02EB    lda   >$C119
         bita  #$40
         bne   L02F7
         lbsr  L02D1
         bra   L02EB
L02F7    lda   >$C110
         stx   >$C100
         sty   >$C102
         stb   >$C110
         ldb   #$01
         stb   >$C114
         puls  pc,y,x,b,a

L030B    pshs  y
         ldb   [<V.CMDR,u]
 bitb #%01000000 Write protected?
 bne WPERR ..yes; return error
         ldb   #$01
         ldy   #$0100
         bsr   L02E2
         ldy   ,s
         bsr   L0370
         ldb   #$A0
         lbsr  WCR
         bsr   L035D
         ldb   [<V.CMDR,u]
         bitb  #$04
         bne   WRERR2
         clrb
         puls  pc,y

WRERR2    comb
 ldb #E$Write
 puls  pc,y

WPERR    comb
 ldb #E$WP
 puls  pc,y

L033C    pshs  y,x
         ldb   #$00
         ldy   #$0100
         lbsr  L02E2
         ldb   #$80
         lbsr  WCR
         bsr   L035D
         ldb   [<V.CMDR,u]
         bitb  #$1C
         bne   RDERR3
         clrb
         puls  pc,y,x

RDERR3    comb
         ldb   #E$Read
         puls  pc,y,x

L035D    pshs  x,a
L035F    lda   [<u0073,u]
         bita  #$20
         beq   L036E
         ldx   #1
         os9   F$Sleep
         bra   L035F
L036E    puls  pc,x,a

L0370    pshs  y,x,b,a
         clr   [<u0071,u]
         ldx   $08,y
         ldy   <V.SEL,u
L037B    clrb
L037C    lda   ,x+
         sta   ,y+
         decb
         bne   L037C
         puls  pc,y,x,b,a

L0385    pshs  y,x,b,a
         clr   [<u0071,u]
         ldx   <V.SEL,u
         ldy   $08,y
         bra   L037B

TERMNT    clr   [<u005E,u]
         clrb
         rts

         emod
eom      equ   *
