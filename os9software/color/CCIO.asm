         nam   CCIO
         ttl   os9 device driver

 use defsfile

p0ddra   equ   $FF00    ; Data direction register

tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   3
u0003    rmb   1
u0004    rmb   1
u0005    rmb   4
u0009    rmb   2
u000B    rmb   1
u000C    rmb   1
u000D    rmb   11
u0018    rmb   1
u0019    rmb   1
u001A    rmb   1
u001B    rmb   1
u001C    rmb   1
u001D    rmb   2
u001F    rmb   2
u0021    rmb   1
u0022    rmb   1
u0023    rmb   1
u0024    rmb   1
u0025    rmb   1
u0026    rmb   2
u0028    rmb   1
u0029    rmb   2
u002B    rmb   1
u002C    rmb   1
u002D    rmb   2
u002F    rmb   2
u0031    rmb   2
u0033    rmb   1
u0034    rmb   1
u0035    rmb   1
u0036    rmb   1
u0037    rmb   1
u0038    rmb   1
u0039    rmb   1
u003A    rmb   1
u003B    rmb   2
u003D    rmb   1
u003E    rmb   1
u003F    rmb   1
u0040    rmb   1
u0041    rmb   1
u0042    rmb   1
u0043    rmb   1
u0044    rmb   1
u0045    rmb   1
u0046    rmb   1
u0047    rmb   1
u0048    rmb   1
u0049    rmb   1
u004A    rmb   1
u004B    rmb   10
u0055    rmb   64
u0095    rmb   53
size     equ   .
         fcb   $07
name     equ   *
         fcs   /CCIO/
         fcb   $03

start    equ   *
         lbra  Init
         lbra  Read
         lbra  Write
         lbra  GetStat
         lbra  SetStat
         lbra  Term
* Init
*
* Entry:
*    Y  = address of device descriptor
*    U  = address of device memory area
*
* Exit:
*    CC = carry set on error
*    B  = error code
*
Init    lbsr  L02A3
         lbra  L002B
L002B    pshs  cc
         orcc  #$10
         stu   >D.KbdSta   Keyboard scanner static storage
         ldd   >D.IRQ
         std   >D.AltIRQ
         leax  >AltIRQ,pcr
         stx   >D.IRQ
         ldx   #p0ddra
         stx   <u003B,u
         clra
         clrb
         std   <u0048,u
         sta   $01,x
         sta   $00,x        Clear FF00
         sta   $03,x
         comb
         stb   <u003D,u
         stb   $02,x
         stb   <u003F,u
         stb   <u0040,u
         stb   <u0041,u
         lda   #$34
         sta   $01,x
         lda   #$3F
         sta   $03,x
         lda   $02,x
         puls  pc,cc
         ldb   #$F5
         orcc  #$01
         rts
GetStat    cmpa  #$01
         bne   L0080
         lda   <u0049,u
         suba  <u0048,u
         bne   EXIT1
         ldb   #$F6
         bra   L0092
L0080    cmpa  #$06
         beq   EXIT1
         cmpa  #$12
         lbeq  L04BA
         cmpa  #$13
         lbeq  L0835
SetStat    ldb   #$D0
L0092    orcc  #$01
         rts

* Term
*
* Entry:
*    U  = address of device memory area
*
* Exit:
*    CC = carry set on error
*    B  = error code
*
Term    pshs  cc
         orcc  #$10
         ldx   >$006B
         stx   >$0032
         puls  pc,cc

* Increment B and check it is under $7F
L00A1    incb
         cmpb  #$7F
         bls   L00A7
EXIT1    clrb
L00A7    rts

AltIRQ    ldu   >$006D
         ldx   <u003B,u
         lda   $03,x
         bmi   L00B6
         jmp   [>$0038]

L00B6    lda   $02,x
         lda   #$FF
         sta   $02,x
         lda   ,x
         coma
         anda  #$03
         bne   L00CC
         clr   $02,x
         lda   ,x
         coma
         anda  #$7F
         bne   L00E9
L00CC    clra
         coma
         sta   <u003F,u
         sta   <u0040,u
         sta   <u0041,u
POLLDISK    lda   >$006F
         beq   L00E5
         deca
         sta   >$006F
         bne   L00E5
         sta   >$FF40
L00E5    jmp   [>$006B]
L00E9    bsr   L0137
         bmi   POLLDISK
         sta   <u0047,u
         cmpa  #$1F
         bne   L00F9
         com   <u003D,u
         bra   POLLDISK
L00F9    ldb   <u0048,u
         leax  <u004A,u
         abx
         bsr   L00A1
         cmpb  <u0049,u
         beq   L010A
         stb   <u0048,u
L010A    sta   ,x
         beq   L012A
         cmpa  u000D,u
         bne   L011A
         ldx   u0009,u
         beq   L012A
         sta   $08,x
         bra   L012A

* Send interrupt
* A holds the character
L011A    ldb   #$03
         cmpa  u000B,u
         beq   L0126
         ldb   #$02
         cmpa  u000C,u
         bne   L012A
L0126    lda   u0003,u
         bra   L012E
L012A    ldb   #$01
         lda   u0005,u
L012E    beq   L0133
         os9   F$Send
L0133    clr   u0005,u
         bra   POLLDISK

* X contains $FF00
L0137    clra
         sta   <u003E,u
         sta   <u0045,u
         sta   <u0046,u
         coma
         sta   <u0042,u
         sta   <u0043,u
         sta   <u0044,u
         deca
         sta   $02,x
L014E    lda   ,x
         coma
         anda  #$7F
         beq   L0161
         ldb   #$FF
L0157    incb
         lsra
         bcc   L015D
         bsr   L01A6
L015D    cmpb  #$06
         bcs   L0157
L0161    inc   <u003E,u
         orcc  #$01
         rol   $02,x
         bcs   L014E
         bsr   L01E1
         bmi   L01A5
         suba  #$1B
         bcc   L0188
         adda  #$1B
         ldb   <u0046,u
         bne   L0187
         adda  #$40
         ldb   <u0045,u
         eorb  <u003D,u
         andb  #$01
         bne   L0187
         adda  #$20
L0187    rts
L0188    ldb   #$03
         mul
         lda   <u0045,u
         beq   L0193
         incb
         bra   L019A
L0193    lda   <u0046,u
         beq   L019A
         addb  #$02
L019A    pshs  x
         leax  >KEYMAP,pcr
         clra
         lda   d,x
         puls  x
L01A5    rts
L01A6    pshs  b
         lslb
         lslb
         lslb
         addb  <u003E,u
         cmpb  #$31
         bne   L01B7
         inc   <u0046,u
         puls  pc,b
L01B7    cmpb  #$37
         bne   L01C0
         com   <u0045,u
         puls  pc,b
L01C0    pshs  x
         leax  <u0042,u
         bsr   L01CB
         puls  x
         puls  pc,b
L01CB    pshs  a
         lda   ,x
         bpl   L01D5
         stb   ,x
         puls  pc,a
L01D5    lda   $01,x
         bpl   L01DD
         stb   $01,x
         puls  pc,a
L01DD    stb   $02,x
         puls  pc,a
L01E1    pshs  y,x,b
         leax  <u003F,u
         ldb   #$03
         pshs  b
L01EA    leay  <u0042,u
         ldb   #$03
         lda   ,x
         bmi   L0206
L01F3    cmpa  ,y
         bne   L01FD
         clr   ,y
         com   ,y
         bra   L0206
L01FD    leay  $01,y
         decb
         bne   L01F3
         lda   #$FF
         sta   ,x
L0206    leax  $01,x
         dec   ,s
         bne   L01EA
         leas  $01,s
         leax  <u0042,u
         lda   #$03
L0213    ldb   ,x+
         bpl   L021E
         deca
         bne   L0213
         orcc  #$08
         puls  pc,y,x,b
L021E    leax  <u003F,u
         bsr   L01CB
         tfr   b,a
         puls  pc,y,x,b

* Keyboard mapping: See user manual appendix D
* letter keys are not mapped by index.
* First byte: normal
* Second byte: shift
* Third byte: ctrl (clear key)

KEYMAP
* Up arrow key
         fcb   $0C
         fcb   $1C
         fcb   $13
* Down arrow key
         fcb   $0A
         fcb   $1A
         fcb   $12
* Left arrow key (backspace)
         fcb   $08
         fcb   $18
         fcb   $10
* Right arrow key
         fcb   $09
         fcb   $19
         fcb   $11
* Space key
         fcb   $20
         fcb   $20
         fcb   $20

         fcb   '0     $30
         fcb   '0     $30
         fcb   $1F

         fcb   '1     $31
         fcb   '!     $21
         fcb   '|     $7C

         fcb   '2     $32
         fcb   '"     $22
         fcb   $00

         fcb   '3     $33
         fcb   '#     $23
         fcb   $7E

         fcb   '4     $34
         fcb   '$     $24
         fcb   $00

         fcb   '5     $35
         fcb   '%     $25
         fcb   $00

         fcb   '6     $36
         fcb   '&     $26
         fcb   $00

         fcb   '7     $37
         fcb   ''     $27
         fcb   $5E

         fcb   '8     $38
         fcb   '(     $28
         fcb   $5B

         fcb   '9     $39
         fcb   ')     $29
         fcb   ']     $5D

         fcb   ':     $3A
         fcb   '*     $2A
         fcb   $00

         fcb   ';     $3B
         fcb   '+     $2B
         fcb   $00

         fcb   ',     $2C
         fcb   '<     $3C
         fcb   $7B

         fcb   '-     $2D
         fcb   '=     $3D
         fcb   $5F

         fcb   '.     $2E
         fcb   '>     $3E
         fcb   $7D

         fcb   '/     $2F
         fcb   '?     $3F
         fcb   $5C
* Enter key
         fcb   $0D
         fcb   $0D
         fcb   $0D
* Clear key (used for Ctrl)
         fcb   $00
         fcb   $00
         fcb   $00
* Break key
         fcb   $05
         fcb   $03
         fcb   $1B

* Read
*
* Entry:
*    Y  = address of path descriptor
*    U  = address of device memory area
*
* Exit:
*    A  = character read
*    CC = carry set on error
*    B  = error code
*
Read    leax  <u004A,u
         ldb   <u0049,u
         orcc  #$10
         cmpb  <u0048,u
         beq   L0288
         abx
         lda   ,x
         lbsr  L00A1
         stb   <u0049,u
         andcc #$EE
         rts
L0288    lda   u0004,u
         sta   u0005,u
         andcc #$EF
         ldx   #$0000
         os9   F$Sleep
         clr   u0005,u
         ldx   <u004B
L0298    ldb   <$36,x
         beq   Read
         cmpb  #$04
         bcc   Read
         coma
         rts
L02A3    pshs  y,x
         clr   <u0025,u
         clr   <u002C,u
         pshs  u
         ldd   #$0300
         os9   F$SRqMem
         tfr   u,d
         tfr   u,x
         bita  #$01
         beq   L02C1
         leax  >$0100,x
         bra   L02C5
L02C1    leau  >$0200,u
L02C5    ldd   #$0100
         os9   F$SRtMem
         puls  u
         stx   <u001D,u
         clra
         clrb
         bsr   L02EC
         stx   <u0021,u
         leax  >$0200,x
         stx   <u001F,u
         lbsr  L0442
         lda   #$60
         sta   <u0023,u
         sta   <u002B,u
         clrb
         puls  pc,y,x
L02EC    pshs  x,a
         lda   >$FF22
         anda  #$07
         ora   ,s+
         sta   >$FF22
         tstb
         bne   L0309
         stb   >$FFC0
         stb   >$FFC2
         stb   >$FFC4
         lda   <u001D,u
         bra   L0315
L0309    stb   >$FFC0
         stb   >$FFC3
         stb   >$FFC5
         lda   <u002D,u
L0315    ldb   #$07
         ldx   #$FFC6
         lsra
L031B    lsra
         bcs   L0324
         sta   ,x+
         leax  $01,x
         bra   L0328
L0324    leax  $01,x
         sta   ,x+
L0328    decb
         bne   L031B
         clrb
         puls  pc,x
Write    ldb   <u0025,u
         bne   L0370
         tsta
         bmi   L035A
         cmpa  #$1F
         bls   L03A5
         cmpa  #$7C
         bne   L0342
         lda   #$61
         bra   L035A
L0342    cmpa  #$7E
         bne   L034A
         lda   #$6D
         bra   L035A
L034A    cmpa  #$60
         bcs   L0354
         suba  #$20
         ora   #$40
         bra   L035A
L0354    cmpa  #$40
         bcs   L035A
         suba  #$40
L035A    ldx   <u0021,u
         eora  #$40
         sta   ,x+
         stx   <u0021,u
         cmpx  <u001F,u
         bcs   L036B
         bsr   L0385
L036B    lbsr  L03FE
         clrb
         rts
L0370    cmpb  #$01
         beq   L037D
         clr   <u0025,u
         sta   <u0029,u
         jmp   [<u0026,u]
L037D    sta   <u0028,u
         inc   <u0025,u
Exit0    clrb
         rts

L0385    ldx   <u001D,u
         leax  <$20,x
L038B    ldd   ,x++
         std   <-$22,x
         cmpx  <u001F,u
         bcs   L038B
         leax  <-$20,x
         stx   <u0021,u
         lda   #$20
         ldb   #$60
L039F    stb   ,x+
         deca
         bne   L039F
L03A4    rts
L03A5    cmpa  #$1B
         bcc   L03A4
         cmpa  #$10
         bcs   L03B7
         ldb   <u002C,u
         bne   L03B7
         ldb   #$F6
         orcc  #$01
         rts
L03B7    leax  <L03BF,pcr
         lsla
         ldd   a,x
         jmp   d,x

* Jump table
L03BF    fdb Exit0-L03BF   * 00
         fcb $00,$91
         fcb $00,$A5
         fcb $00,$D0
         fcb $FF,$C4
         fcb $FF,$C4
         fcb $00,$75
         fcb $FF,$C4
         fcb $00,$67
         fcb $00,$E2
         fcb $00,$4E
         fcb $FF,$C4
         fcb $00,$83
         fcb $00,$36
         fcb $00,$F2
         fcb $01,$37
         fcb $02,$1B
         fcb $01,$F6
         fcb $02,$0A
         fcb $02,$3B
         fcb $02,$46
         fcb $02,$5F
         fcb $02,$CC
         fcb $02,$C7
         fcb $02,$76
         fcb $02,$71
         fcb $03,$95

* Return cursor to leftmost column
L03F5    bsr   RstrChar
         tfr   x,d
         andb  #$E0
         stb   <u0022,u

L03FE    ldx   <u0021,u
         lda   ,x
         sta   <u0023,u
         lda   #$20
         sta   ,x
         andcc #$FE
         rts

         bsr   RstrChar
         leax  <$20,x
         cmpx  <u001F,u
         bcs   L0421
         leax  <-$20,x
         pshs  x
         lbsr  L0385
         puls  x
L0421    stx   <u0021,u
         bra   L03FE

         bsr   RstrChar
         cmpx  <u001D,u
         bls   L0432
         leax  -$01,x
         stx   <u0021,u
L0432    bra   L03FE
         bsr   RstrChar
         leax  $01,x
         cmpx  <u001F,u
         bcc   L0440
         stx   <u0021,u
L0440    bra   L03FE
L0442    bsr   L0450
         lda   #$60
L0446    sta   ,x+
         cmpx  <u001F,u
         bcs   L0446
         lbra  L03FE
L0450    bsr   RstrChar
         ldx   <u001D,u
         stx   <u0021,u
         lbra  L03FE
RstrChar    ldx   <u0021,u
         lda   <u0023,u
         sta   ,x
         rts
         leax  <L046A,pcr
         lbra  L0621
L046A    bsr   RstrChar
         ldb   <u0029,u
         subb  #$20
         lda   #$20
         mul
         addb  <u0028,u
         adca  #$00
         subd  #$0020
         addd  <u001D,u
         cmpd  <u001F,u
         bcc   L048C
         std   <u0021,u
         lbsr  L03FE
         clrb
L048C    lbra  L03FE
         lbsr  L03F5
         ldb   #$20
         lda   #$60
         ldx   <u0021,u
L0499    sta   ,x+
         decb
         bne   L0499
         lbra  L03FE
         bsr   RstrChar
         leax  <-$20,x
         cmpx  <u001D,u
         bcs   L04AE
         stx   <u0021,u
L04AE    lbra  L03FE
         clra
         clrb
         lbra  L02EC

* Color codes
L04B6    fcb %00000000,%01010101,%10101010,%11111111

L04BA    lda   <$2C,u
         bne   L04EE
         ldb   #$F6
         orcc  #Carry
         rts

L04EE    ldd   <u0034,u
         lbsr  L065A
         tfr   a,b
         andb  ,x
L04CE    bita  #$01
         bne   L04DD
         lsra
         lsrb
         tst   <u0024,u
         bmi   L04CE
         lsra
         lsrb
         bra   L04CE

L04DD    pshs  b
         ldb   <u003A,u
         andb  #$FC
L04E4    orb   ,s+
         ldx   $06,y
         stb   $01,x
         ldd   <u0034,u
         std   $06,x
         ldd   <u002D,u
         std   $04,x
         clrb
         rts

         leax  <L04FC,pcr
         lbra  L0621
L04FC    ldb   <u002C,u
         bne   L053C
         pshs  u
         ldd   #$1900
         os9   F$SRqMem
         tfr   u,d
         puls  u
         bcs   L055B
         tfr   a,b
         bita  #$01
         beq   L0519
         adda  #$01
         bra   L051B
L0519    addb  #$18
L051B    pshs  u,a
         tfr   b,a
         clrb
         tfr   d,u
         ldd   #$0100
         os9   F$SRtMem
         puls  u,a
         bcs   L055B
         clrb
         std   <u002D,u
         addd  #$1800
         std   <u002F,u
         inc   <u002C,u
         lbsr  L05FA
L053C    lda   <u0029,u
         sta   <u003A,u
         anda  #$03
         leax  >L04B6,pcr
         lda   a,x
         sta   <u0036,u
         sta   <u0037,u
         lda   <u0028,u
         cmpa  #$01
         bls   L055C
         ldb   #$CB
         orcc  #$01
L055B    rts
L055C    tsta
         beq   L057C
         ldd   #%1100000000000011
         std   <u0038,u
         lda   #$01
         sta   <u0024,u
         lda   #$E0
         ldb   <u0029,u
         andb  #$08
         beq   L0575
         lda   #$F0
L0575    ldb   #$03
         leax  <bitmask4,pcr
         bra   L0594

* Two color mode
L057C    ldd   #%1000000000000001
         std   <u0038,u
         lda   #$FF
         sta   <u0036,u
         sta   <u0037,u
         sta   <u0024,u
         lda   #$F0
         ldb   #$07
         leax  <bitmask2,pcr
L0594    stb   <u0033,u
         stx   <u0031,u
         ldb   <u0029,u
         andb  #$04
         lslb
         pshs  b
         ora   ,s+
         ldb   #$01
         lbra  L02EC

bitmask4 fcb %11000000,%00110000,%00001100,%00000011

bitmask2 fcb $80,$40,$20,$10,$08,$04,$02,$01

         leax  <L05BB,pcr
         lbra  NextArg

L05BB    clr   <u0028,u
         lda   <u0024,u
L05C1    bmi   L05C6
         inc   <u0028,u
L05C6    lbra  L053C

* Quit graphics
* Does not switch to alpha mode
QuitGFX  pshs  u
         ldu   <u002D,u
         ldd   #$1800
         os9   F$SRtMem
         puls  u
         clr   <u002C,u
         rts

         leax  <L05E0,pcr
         lbra  NextArg

L05E0    lda   <u0029,u
         tst   <u0024,u
         bpl   L05F0
         ldb   #$FF
         anda  #$01
         beq   L05FA
         bra   L05FB
L05F0    anda  #$03
         leax  >L04B6,pcr
         ldb   a,x
         bra   L05FB

L05FA    clrb
L05FB    ldx   <u002D,u
L05FE    stb   ,x+
         cmpx  <u002F,u
         bcs   L05FE
         clra
         clrb
         std   <u0034,u
         rts
L060B    ldd   <u0028,u
         cmpb  #$C0
         bcs   L0614
         ldb   #$BF
L0614    tst   <u0024,u
         bmi   L061A
         lsra
L061A    std   <u0028,u
         rts
         leax  <L0629,pcr
L0621    stx   <u0026,u
         inc   <u0025,u
         clrb
         rts
L0629    bsr   L060B
         std   <u0034,u
         clrb
         rts
         clr   <u0036,u
         bra   L0635
L0635    leax  <L063A,pcr
         bra   L0621
L063A    bsr   L060B
         std   <u0034,u
         bsr   L0649
         lda   <u0037,u
         sta   <u0036,u
         clrb
         rts
L0649    bsr   L065A
         tfr   a,b
         comb
         andb  ,x
         stb   ,x
         anda  <u0036,u
         ora   ,x
         sta   ,x
         rts
L065A    pshs  y,b,a
         ldb   <u0024,u
         bpl   L0662
         lsra
L0662    lsra
         lsra
         pshs  a
         ldb   #$BF
         subb  $02,s
         lda   #$20
         mul
         addb  ,s+
         adca  #$00
         ldy   <u002D,u
         leay  d,y
         lda   ,s
         sty   ,s
         anda  <u0033,u
         ldx   <u0031,u
         lda   a,x
         puls  pc,y,x
         clr   <u0036,u
         bra   L068B
L068B    leax  <L0690,pcr
         bra   L0621
L0690    lbsr  L060B
         leas  -$0E,s
         std   $0C,s
         bsr   L065A
         stx   $02,s
         sta   $01,s
         ldd   <u0034,u
         bsr   L065A
         sta   ,s
         clra
         clrb
         std   $04,s
         lda   #$BF
         suba  <u0035,u
         sta   <u0035,u
         lda   #$BF
         suba  <u0029,u
         sta   <u0029,u
         lda   #$FF
         sta   $06,s
         clra
         ldb   <u0034,u
         subb  <u0028,u
         sbca  #$00
         bpl   L06CD
         nega
         negb
         sbca  #$00
         neg   $06,s
L06CD    std   $08,s
         bne   L06D6
         ldd   #$FFFF
         std   $04,s
L06D6    lda   #$E0
         sta   $07,s
         clra
         ldb   <u0035,u
         subb  <u0029,u
         sbca  #$00
         bpl   L06EB
         nega
         negb
         sbca  #$00
         neg   $07,s
L06EB    std   $0A,s
         bra   L06F7
L06EF    sta   ,s
         ldd   $04,s
         subd  $0A,s
         std   $04,s
L06F7    lda   ,s
         tfr   a,b
         anda  <u0036,u
         comb
         andb  ,x
         pshs  b
         ora   ,s+
         sta   ,x
         cmpx  $02,s
         bne   L0711
         lda   ,s
         cmpa  $01,s
         beq   L0745
L0711    ldd   $04,s
         bpl   L071F
         addd  $08,s
         std   $04,s
         lda   $07,s
         leax  a,x
         bra   L06F7
L071F    lda   ,s
         ldb   $06,s
         bpl   L0735
         lsla
         ldb   <u0024,u
         bmi   L072C
         lsla
L072C    bcc   L06EF
         lda   <u0039,u
         leax  -$01,x
         bra   L06EF
L0735    lsra
         ldb   <u0024,u
         bmi   L073C
         lsra
L073C    bcc   L06EF
         lda   <u0038,u
         leax  $01,x
         bra   L06EF
L0745    ldd   $0C,s
         std   <u0034,u
         leas  $0E,s
         lda   <u0037,u
         sta   <u0036,u
         clrb
         rts

         leax  <L075F,pcr

NextArg    stx   <u0026,u
         com   <u0025,u
         clrb
         rts

* Takes radius from Argbuf2
L075F    leas  -$04,s
         ldb   <u0029,u
         stb   $01,s
         clra
         sta   ,s
         addb  $01,s
         adca  #$00
         nega
         negb
         sbca  #$00
         addd  #$0003
         std   $02,s
L0776    lda   ,s
         cmpa  $01,s
         bcc   L07A8
         ldb   $01,s
         bsr   L07B6
         clra
         ldb   $02,s
         bpl   L0790
         ldb   ,s
         lslb
         rola
         lslb
         rola
         addd  #$0006
         bra   L07A0
L0790    dec   $01,s
         clra
         ldb   ,s
         subb  $01,s
         sbca  #$00
         lslb
         rola
         lslb
         rola
         addd  #$000A
L07A0    addd  $02,s
         std   $02,s
         inc   ,s
         bra   L0776
L07A8    lda   ,s
         cmpa  $01,s
         bne   L07B2
         ldb   $01,s
         bsr   L07B6
L07B2    leas  $04,s
         clrb
         rts
L07B6    leas  -$08,s
         sta   ,s
         clra
         std   $02,s
         nega
         negb
         sbca  #$00
         std   $06,s
         ldb   ,s
         clra
         std   ,s
         nega
         negb
         sbca  #$00
         std   $04,s
         ldx   $06,s
         bsr   L07FF
         ldd   $04,s
         ldx   $02,s
         bsr   L07FF
         ldd   ,s
         ldx   $02,s
         bsr   L07FF
         ldd   ,s
         ldx   $06,s
         bsr   L07FF
         ldd   $02,s
         ldx   ,s
         bsr   L07FF
         ldd   $02,s
         ldx   $04,s
         bsr   L07FF
         ldd   $06,s
         ldx   $04,s
         bsr   L07FF
         ldd   $06,s
         ldx   ,s
         bsr   L07FF
         leas  $08,s
         rts
L07FF    pshs  b,a
         ldb   <u0035,u
         clra
         leax  d,x
         cmpx  #$0000
         bmi   L0811
         cmpx  #$00BF
         ble   L0813
L0811    puls  pc,b,a
L0813    ldb   <u0034,u
         clra
         tst   <u0024,u
         bmi   L081E
         lslb
         rola
L081E    addd  ,s++
         tsta
         beq   L0824
         rts
L0824    pshs  b
         tfr   x,d
         puls  a
         tst   <u0024,u
         lbmi  L0649
         lsra
         lbra  L0649
L0835    ldx   $06,y
         pshs  y,cc
         orcc  #$10
         lda   #$FF
         clr   >$FF02
         ldb   >$FF00
         ldy   $04,x
         bne   L084E
         andb  #$01
         bne   L0852
         bra   L0853

L084E    andb  #$02     Left joystick
         beq   L0853    If set then button not pressed
L0852    clra
L0853    sta   $01,x
         lda   >$FF03
         ora   #$08
         ldy   $04,x
         bne   L0861
         anda  #$F7
L0861    sta   >$FF03
         lda   >$FF01
         anda  #$F7
         bsr   L0880
         std   $04,x
         lda   >$FF01
         ora   #$08
         bsr   L0880
         pshs  b,a
         ldd   #$003F
         subd  ,s++
         std   $06,x
         clrb
         puls  pc,y,cc

L0880    sta   >$FF01
         clrb
         bsr   L0890
         bsr   L0890
         bsr   L0890
         bsr   L0890
         lsrb
         lsrb
         clra
         rts

L0890    pshs  b
         lda   #$7F
         tfr   a,b
L0896    lsrb
         cmpb  #$03
         bhi   L08A2
         lsra
         lsra
         tfr   a,b
         addb  ,s+
         rts

L08A2    addb  #$02
         andb  #$FC
         pshs  b
         sta   >$FF20
         tst   >$FF00
         bpl   L08B4
         adda  ,s+
         bra   L0896
L08B4    suba  ,s+
         bra   L0896
         emod
eom      equ   *
