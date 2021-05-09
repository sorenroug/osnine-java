 nam Clock Module
 ttl Module Header
* opt -c

 use defsfile

tylg     set   Systm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   ClkEnd,ClkNam,tylg,atrv,ClkEnt,0

ClkNam fcs   /Clock/
         fcb 9

* L0013
TIMSVC fcb F$TIME
         fdb   L0194-*-2
         fcb   $27
         fdb   L0119-*-2
         fcb   $1E
         fdb   L015D-*-2
         fcb   $80

*
*  DAYS IN MONTHS TABLE
*
MONTHS fcb 0 Uninitialized month
 fcb 31 January
 fcb 28 February
 fcb 31 March
 fcb 30 April
 fcb 31 May
 fcb 30 June
 fcb 31 July
 fcb 31 August
 fcb 30 September
 fcb 31 October
 fcb 30 November
 fcb 31 December

L002A
         lda   >$FF92
         ora   D.IRQS
         sta   D.IRQS
         bita  #$08
 bne   L0039
         fcb   $DC \
         fcb   $26 &
         fcb   $20
         fcb   $4F O

L0039         fcb   $84
         fcb   $F7 w
         fcb   $97
         fcb   $AF /
         fcb   $0A
         fcb   $2E .
         fcb   $26 &
         fcb   $45 E
         fcb   $DC \
         fcb   $2C ,
         fcb   $5C \
         fcb   $C1 A
         fcb   $3C <
         fcb   $25 %
         fcb   $38 8
         fcb   $4C L
         fcb   $81
         fcb   $3C <
         fcb   $25 %
         fcb   $32 2
         fcb   $DC \
         fcb   $2A *
         fcb   $5C \
         fcb   $C1 A
         fcb   $18
         fcb   $25 %
         fcb   $28 (
         fcb   $4C L
         fcb   $30 0
         fcb   $8D
         fcb   $FF
         fcb   $C4 D
         fcb   $D6 V
         fcb   $29 )
         fcb   $A1 !
         fcb   $85
         fcb   $23 #
         fcb   $1C
         fcb   $C1 A
         fcb   $02
         fcb   $26 &
         fcb   $0A
         fcb   $D6 V
         fcb   $28 (
         fcb   $C4 D
         fcb   $03
         fcb   $10
         fcb   $83
         fcb   $1D
         fcb   $00
         fcb   $27 '
         fcb   $0E
         fcb   $DC \
         fcb   $28 (
         fcb   $5C \
         fcb   $C1 A
         fcb   $0D
         fcb   $25 %
         fcb   $03
         fcb   $4C L
         fcb   $C6 F
         fcb   $01
         fcb   $DD ]
         fcb   $28 (
         fcb   $86
         fcb   $01
         fcb   $5F _
         fcb   $DD ]
         fcb   $2A *
         fcb   $4F O
         fcb   $5F _
         fcb   $DD ]
         fcb   $2C ,
         fcb   $86
         fcb   $3C <
         fcb   $97
         fcb   $2E .
         fcb   $DC \
         fcb   $AD -
         fcb   $DD ]
         fcb   $CE N
         fcb   $6E n
         fcb   $9F
         fcb   $00
         fcb   $E8 h

L008E    clra  
         pshs  a
         lda   D.IRQS
         bita  #$37
         beq   L0099
         inc   ,s
L0099    ldy   D.CLTb
         bra   L00B7
L009E    ldd   ,x
         subd  #$0001
         bne   L00B5
         lda   #$01
         sta   ,s
         lda   $04,x
         bne   L00AF
         bsr   L010C

L00AF    ora   #$01
         sta   $04,x
         ldd   $02,x
L00B5    std   ,x
L00B7    ldx   ,y++
         bne   L009E
         lda   ,s+
         beq   L00C5
L00BF    jsr   [D.Poll]
         bcc   L00BF
L00C5    jsr   [D.AltIRQ]
         ldd   >$1015
         ble   L0108
         ldd   #$053C
         cmpb  D.Tick
         bne L0108
         ldy   #D.Time
         ldx   #$100F
L00DC    ldb   ,y+
         cmpb  ,x+
         bne L0108
         deca  
         bne   L00Dc
         ldd   >$1015
         cmpd  #$0001
         beq   L00F3
         os9   F$Send   
         bra   L00F9
L00F3    ldb   ,y
         andb  #$F0
         beq   L0101
L00F9    ldd   #$FFFF
         std   >$1015
         bra   L0108
L0101    ldx   >$1017
         beq   L0108
         jsr   ,x
L0108    jmp   [D.Clock]

L010C  pshs  y,x
L010E    ldx   ,y++
         stx   -$04,y
         bne   L010E
         puls  y,x
         leay  -$02,y
         rts

L0119    pshs  cc
         orcc  #$50
         ldy  D.CLTb
         ldx D.Init
         ldb   $0C,x
         ldx   $04,u
         beq L0147
         tst   ,y
         beq   L013B
         subb  #$02
         lslb  
         fcb   $31 1
         fcb   $A5 %
         fcb   $6D m
         fcb   $A4 $
         fcb   $26 &
         fcb   $22 "
         fcb   $6D m
         fcb   $A3 #
         fcb   $27 '
         fcb   $FC
         fcb   $31 1
         fcb   $22 "
L013B         fcb   $AE .
         fcb   $46 F
         fcb   $AF /
         fcb   $A4 $
         fcb   $10
         fcb   $AE .
         fcb   $41 A
         fcb   $10
         fcb   $AF /
         fcb   $84
         fcb   $20
         fcb   $0C
L0147     fcb   $AE .
         fcb   $46 F
         fcb   $6D m
         fcb   $A4 $
         fcb   $27 '
         fcb   $06
         fcb   $AC ,
         fcb   $A1 !
         fcb   $26 &
         fcb   $F8 x
         fcb   $8D
         fcb   $B9 9
         fcb   $35 5
         fcb   $01
         fcb   $5F _
         fcb   $39 9
         fcb   $35 5
         fcb   $01
         fcb   $53 S
         fcb   $C6 F
         fcb   $CA J
         fcb   $39 9

L015D    fcb   $8E
         fcb   $10
         fcb   $0F
         fcb   $EC l
         fcb   $41 A
         fcb   $26 &
         fcb   $03
         fcb   $ED m
         fcb   $06
         fcb   $39 9
         fcb   $4D M
         fcb   $26 &
         fcb   $06
         fcb   $10
         fcb   $83
         fcb   $00
         fcb   $01
         fcb   $26 &
         fcb   $14
         fcb   $ED m
         fcb   $06
         fcb   $10
         fcb   $9E
         fcb   $50 P
         fcb   $A6 &
         fcb   $26 &
         fcb   $D6 V
         fcb   $D0 P
         fcb   $AE .
         fcb   $44 D
         fcb   $CE N
         fcb   $10
         fcb   $0F
         fcb   $10
         fcb   $8E
         fcb   $00
         fcb   $05
         fcb   $20
         fcb   $20
         fcb   $10
         fcb   $83
         fcb   $00
         fcb   $02
         fcb   $26 &
         fcb   $06
         fcb   $EC l
         fcb   $06
         fcb   $ED m
         fcb   $41 A
         fcb   $20
         fcb   $07
         fcb   $53 S
         fcb   $D6 V
         fcb   $BB ;
         fcb   $39 9

L0194    ldx   #D.Time
         ldy  D.Proc
         ldb P$Task,y
 lda D.SysTsk get system task number
 ldu R$X,u get specified location
 ldy #6 get byte count
 os9 F$Move move time to user
 rts

ClkEnt    equ   *
 pshs  cc save interrupt masks
         lda   #60
         sta   D.Tick
         lda   #6
         sta   D.TSlice
         sta   D.Slice
 orcc #IntMasks set interrupt masks
         leax  >L002A,pcr
         stx   D.IRQ
         leax  >L008E,pcr
         stx   D.VIRQ
         leay  >TIMSVC,pcr
         os9   F$SSvc
         ldx   #$FF00
         clra
         sta   $01,x
         sta   ,x
         sta   $03,x
         coma
         sta   $02,x
         lda   #$34
         sta   $01,x
         lda   #$3C
         sta   $03,x
         lda   $02,x
         lda   D.IRQER
         ora   #$08
         sta   D.IRQER
         sta   >$FF92
         puls  pc,cc
         emod
ClkEnd      equ   *
