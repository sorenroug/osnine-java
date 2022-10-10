         nam   EXORctlr
         ttl   os9 device driver


 use defsfile

FD.DOR equ 0 Data Output Register (write only)
FD.DIR equ 0 Data Input Register (read only)
FD.CTAR equ 1 Current Track Address Register (read/write)
FD.CMR equ 2 Command Register (write only)
FD.ISR equ 2 Interrupt Status Register (read only)
FD.SUR equ 3 Setup Register (write only)
FD.STRA equ 3 Status Register A (read only)
FD.SAR equ 4 Sector Address Register (write only)
FD.STRB equ 4 Status Register B (read only)
FD.GCR equ 5 General Count Register (write only)
FD.CCR equ 6 CRC Control Register (write only)
FD.LTAR equ 7 Logical Track Address Register (write only)

* FD macro commands
CMD.STZ equ $2
CMD.SEK equ $3
CMD.SSR equ $4
CMD.SSW equ $5
CMD.RCR equ $6
CMD.SWD equ $7
CMD.FFR equ $A
CMD.FFW equ $B
CMD.MSR equ $C
CMD.MSW equ $D

DriveCnt equ 4

 org DRVBEG
 rmb Drvmem*DriveCnt

CURDRV    rmb   1  Current drive #
X.CURLSN    rmb   2
X.SIZE    rmb   2
X.BUFADR rmb 2
V.ERRCD rmb 1   $6E
u006F rmb 4 Unused here
u0073    rmb   1
u0074    rmb   1
X.ORGNMI rmb 2 $75 Address of original NMI intercept
X.STACK rmb 2 $77
X.TRAK rmb 1 $79 Current track number
u007A rmb 2
I.DELAY    rmb   1  $7C inner delay value
u007D    rmb   1
X.STAT rmb 1  $7E
CURTBL    rmb   2 $7F
X.DELAY rmb 2 $81

 mod   CTLREND,CTRLNAME,Drivr+Objct,ReEnt+3,CTLRENT,0

CTRLNAME fcs   /EXORctlr/

CTLRENT    equ   *
         lbra  INITCTLR ??
         lbra  READSK ??

* Third routine in jump table.
* Execute a read of a sector?
         andcc #^CARRY
         pshs  x,dp,b,a,cc
         clra
         tfr   a,dp
         lda   #$00
         sta   V.ERRCD,u
         sts   X.STACK,u
         ldx   D.NMI
         stx   X.ORGNMI,u
         leax  >L0126,pcr
         stx   D.NMI
         ldx   CURTBL,u
         lda   <$16,x   V.TRAK+1
         sta   X.TRAK,u
         lda   <$12,x  DD.SPT+1
         sta   $02,s
         lda   #$66
         ldb   CURDRV,u
         lsrb
         beq   L004E
         lda   #70
L004E    sta   FD.CTAR,y
         lda   #$02
         bcc   L0055
         lsra
L0055    sta   ,y
         lda   ,y
         lsla
         lsla
         sta   <$73,u
         bcs   NRDYERR
         ldb   <$10,x  DD.FMT
         bitb  #$01
         bne   L0069
         ora   #$80
L0069    ldb   X.STAT,u
         bitb  #$04
         lbne  L0365
         andb  #$08
         beq   L007A
         lda   #$0B
         bra   L00AE

* Calculate track from LSN
L007A    sta   <$73,u
L007D    ldx   CURTBL,u
         lda   #$FF
         pshs  a
         ldd   <X.CURLSN,u
L0087    inc   ,s
         subd  <$11,x DD.SPT
         bcc   L0087
         addd  <$11,x DD.SPT
         puls  a
         clr   <$74,u
         tst   <$73,u
         bmi   L00A1
         lsra
         bcc   L00A1
         inc   <$74,u
L00A1    decb
         stb   <$70,u
         ldx   <$6A,u
         stx   <$71,u
         ldb   X.TRAK,u
L00AE    sta   X.TRAK,u
         pshs  b
         suba  ,s+
         beq   L00EC
         ldb   ,y
         orb   #$08
         bcc   L00C0
         andb  #$F7
         nega
L00C0    andb  #$EF
         stb   ,y
         deca
         bmi   L00CE
         lbsr  L015B
         ldb   ,y
         bpl   L00C0
L00CE    bsr   L0112
         ldb   X.STAT,u
         tsta
         ble   L00F9
         bitb  #$08
         bne   L0131

SEEKERR    ldb   #E$SEEK
         bra   EXIT.ERR

NRDYERR    ldb   #E$NRDY
         bra   EXIT.ERR 

* Command #8 - seek to track
L00E2    lda   X.TRAK,u
         beq   SEEKERR can't seek to track 0
         clra
         ldb   #$56
         bra   L00AE

L00EC    lda   X.STAT,u
         bita  #$08
         bne   L00E2
         bita  #$10
         bne   L0131
         bra   L0105
L00F9    bitb  #$08
         bne   L00E2
         tfr   b,a
         bsr   L0112
         bita  #$10
         bne   L0131
L0105    ldb   #$6F
         rora
         bcc   L010C
         ldb   #$6A
L010C    stb   <$7A,u
         lbra  L01A4
L0112    ldx   #$0360
         bra   L0167
L0117    lda   X.STAT,u
         bpl   L0131
         anda  #$40
         sta   X.STAT,u
         beq   L0131
         lbra  L007D

* NMI Interrupt routine
*
L0126    lds   X.STACK,u
         ldb   #E$DIDC
EXIT.ERR stb   V.ERRCD,u
         inc   ,s
L0131    lda   #$3C
         sta   $02,y
         ldx   <X.ORGNMI,u
         stx   <D.NMI
         ldb   #$01
         bitb  ,s
         bne   L0147
         ldb   X.STAT,u
         cmpb  #$10
         beq   L014F
L0147    lda   $01,y
         anda  #$F0
         ora   #$03
         sta   $01,y
L014F    clra
         ldb   X.TRAK,u
         ldx   CURTBL,u
         std   V.TRAK,x Current track number
         puls  pc,x,dp,b,a,cc

L015B    ldb   #$34
         stb   $02,y
         ldb   #$3C
         stb   $02,y
* Create delay
         ldx   X.DELAY,u
L0167    ldb   <I.DELAY,u
L016A    decb
         bne   L016A
         leax  -$01,x
         bne   L0167
         rts

L0172    ldx   #$D0D8
         stx   $04,y
         lda   #$50
         sta   $04,y
         lda   $01,y
         ora   #$07
         sta   $01,y
         dec   $01,y
         lda   #$40
         bsr   L018D
         sta   $04,y
         lda   #$98
         sta   $05,y
L018D    rts

L018E    ldb   $04,y
         bpl   L018E
         ldb   $05,y
         rts

L0195    deca
         sta   <$70,u
         bsr   L015B
         lbsr  L0112
         inc   X.TRAK,u
         clr   <$74,u
L01A4    lda   ,s
         tfr   a,cc
         inc   <$70,u
         lda   <$70,u
         ldx   <$71,u
         lbeq  L0117
         ldb   $01,y
         orb   #$40
         tst   <$74,u
         beq   L01C0
         andb  #$22
L01C0    suba  $02,s
         bcs   L01D6
         tst   <$73,u
         bmi   L0195
         tst   <$74,u
         bne   L0195
         inc   <$74,u
         sta   <$70,u
         andb  #$22
L01D6    stb   $01,y
         lda   #$05
         sta   <$7B,u
         leax  -$01,x
L01DF    lda   ,s
         tfr   a,cc
         lda   #$80
         stx   <$71,u
         nega
         ldb   X.STAT,u
         lslb
         bpl   L01F0
         clra
L01F0    adda  #$80
         sta   <$6F,u
         lbsr  L0357
         lda   X.TRAK,u
         orb   #$0C
         cmpa  #$2B
         bls   L0203
         andb  #$EB
L0203    stb   ,y
         ldx   #$D270
         stx   $04,y
         ldx   #$D1F5
         stx   $04,y
         orcc  #$50
L0211    lbsr  L0172
         lbsr  L018E
         cmpb  #$7E
         bne   L0211
         lbsr  L018E
         lda   $05,y
         cmpb  X.TRAK,u
         bne   L0211
         lbsr  L018E
         lda   $05,y
         cmpb  <$70,u
         bne   L0211
         lbsr  L018E
         lda   <I.DELAY,u
L0235    suba  #$03
         bhi   L0235
         lda   $01,y
         bmi   L027A
         lda   $05,y
         lda   #$04
L0241    lbsr  L018E
         cmpa  $05,y
         deca
         bne   L0241
         ldb   X.STAT,u
         bmi   L02CB
         ldb   <I.DELAY,u
         lslb
L0252    cmpb  $04,y
         cmpb  $04,y
         decb
         bne   L0252
         ldb   #$04
L025B    lbsr  L0172
         ldx   X.BUFADR,u
L0261    lda   $04,y
         bpl   L0261
         lda   $05,y
         cmpa  #$6F
         beq   L0293
         cmpa  #$6A
         beq   L028E
         decb
         bne   L025B
         ldb   #$FC
         bra   L027C

L0276    ldb   #E$CRC
         bra   L027C

L027A    ldb   #$FD
L027C    dec   <$7B,u
         lbeq  EXIT.ERR
         ldx   <$71,u
         lbra  L01DF

WPERR    ldb   #E$WP
         lbra  EXIT.ERR

L028E    ldb   #E$BUSY
         lbra  EXIT.ERR

L0293    ldb   X.STAT,u
         lslb
         bmi   L02AA
         ldb   #$80
L029B    lda   $04,y
         bpl   L029B
         lda   $05,y
         sta   ,x+
         lda   $05,y
         sta   ,x+
         decb
         bne   L029B
L02AA    ldb   <$6F,u
L02AD    lda   $04,y
         bpl   L02AD
         decb
         bmi   L02BA
         lda   $05,y
         lda   $05,y
         bra   L02AD
L02BA    lda   <I.DELAY,u
L02BD    suba  #$03
         bhi   L02BD
         lda   $01,y
         bmi   L0276
         stx   X.BUFADR,u
         lbra  L01A4

L02CB    lda   <I.DELAY,u
         suba  #$03
         lsla
L02D1    deca
         bpl   L02D1
         inc   $01,y
         lda   $01,y
         ldx   #$C0DA
         stx   $04,y
         ldx   #$C1AA
         stx   $04,y
         ldx   #$8270
         stx   $04,y
         anda  #$F2
         sta   $01,y
         bita  #$10
         beq   WPERR
         anda  #$60
         sta   $01,y
         rorb
         bcs   L02F7
         rorb
L02F7    ldx   #$0005
         lbsr  L0167
         ldb   #$80
         lda   <$7A,u
         ldx   #$83F5
         stx   $04,y
         ldx   X.BUFADR,u
         sta   $05,y
         lda   <L0311,pcr
         bra   L031C

L0311    lda   #$40
L0313    bita  $04,y
         beq   L0313
         lda   <L0311,pcr
         bra   L031C
L031C    lda   ,x
         sta   $05,y
         lda   $01,x
         sta   $05,y
         bcs   L0328
         leax  $02,x
L0328    decb
         bne   L0311
         stx   X.BUFADR,u
         lda   #$40
L0330    bita  $04,y
         beq   L0330
         stb   $05,y
L0336    bita  $04,y
         beq   L0336
         ldb   $01,y
         orb   #$08
         stb   $01,y
         stb   $05,y
L0342    bita  $04,y
         beq   L0342
         ldb   #$FF
         stb   $05,y
         stb   $05,y
L034C    bita  $04,y
         beq   L034C
         dec   $01,y
         dec   $01,y
         lbra  L01A4

L0357    lda   #$36
         sta   $03,y
         lda   #$3E
         sta   $03,y
         ldb   ,y
         deca
         sta   $02,y
         rts

L0365    bsr   L0357
         ldb   $01,y
         clra
L036A    ldb   $03,y
         bpl   L036A
         ldb   $01,y
L0370    clrb
L0371    decb
         nop
         bne   L0371
         inca
         tst   $03,y
         bpl   L0370
         incb
         suba  #$45
L037D    incb
         suba  #$10
         bcc   L037D
         stb   <I.DELAY,u
         lsrb
         bcc   L038D
         cmpb  #$01
         bls   L038D
         incb
L038D    stb   <$7D,u
         lbra  L0131

* Y contains $EC00
INITCTLR   pshs  x,b,a
         clra
         clrb
         std   FD.CMR,y
         std   FD.DOR,y
         ldx   #$D0DA
         stx   $04,y
         ldx   #$0404
         stx   FD.CMR,y
         ldx   #$0B62
         stx   FD.DOR,y
         std   FD.CMR,y
         ldx   #$1F6F
         stx   FD.DOR,y
         ldx   #$3C3E
         stx   FD.CMR,y
         puls  pc,x,b,a

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
READSK   tstb
         bne   PHYERR
         sta   X.STAT,u
         lda   PD.DRV,y
         cmpa  V.NDRV,u
         bcc   L03EF
         sta   CURDRV,u
         ldb   #DRVMEM
         mul
         pshs  x
         leax  DRVBEG,u
         leax  d,x
         stx   CURTBL,u
         puls  D
         cmpd  DD.TOT+1,x
         bhi   PHYERR
         std   X.CURLSN,u
         ldd PD.BUF,y
         std   X.BUFADR,u
         ldd   #1   one block
         std   X.SIZE,u
         clrb
         rts

PHYERR    comb
         ldb   #E$Sect
         rts

L03EF    comb
         ldb   #E$Unit Error: illegal unit (drive)
         rts

         emod
CTLREND  equ   *
