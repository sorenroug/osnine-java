         nam   Clock
         ttl   os9 system module    


 use defsfile

CPORT equ $FD38

Type set SYSTM+OBJCT
Revs set REENT+1
 mod ClkEnd,ClkNam,Type,Revs,ClkEnt,CPORT


ClkNam fcs /Clock/
         fcb   11

 fcc "FM11l2(C)SEIKOU"

CLKPRT equ M$Mem Stack has clock port address

TIMSVC fcb F$Time
 fdb TIME-*-2
         fcb   $80 

MONTHS fcb 29 Uninitialized month
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

L0033    lda   >$FD03
         bita  #$40
         beq   L00A5
         ldd   >$FD00
         std   <$0094
         lsra  
         bcc   L009F
         cmpb  >$FC69
         bne   L009F
         tst   >$FC60
         bne   L00A5
L004C    lda   >$FD05
         bmi   L004C
         lda   #$80


         fcb   $B7 7
         fcb   $FD 
         fcb   $05 
         fcb   $B6 6
         fcb   $FD 
         fcb   $05 
         fcb   $2A *
         fcb   $FB 
         fcb   $86 
         fcb   $0A 
         fcb   $B7 7
         fcb   $FC 
         fcb   $82 
         fcb   $7F ÿ
         fcb   $FD 
         fcb   $05 
         fcb   $B6 6
         fcb   $FD 
         fcb   $05 
         fcb   $2B +
         fcb   $FB 
         fcb   $86 
         fcb   $80 
         fcb   $B7 7
         fcb   $FC 
         fcb   $60 `
         fcb   $B7 7
         fcb   $FD 
         fcb   $05 
         fcb   $B6 6
         fcb   $FD 
         fcb   $05 
         fcb   $2A *
         fcb   $FB 
         fcb   $10 
         fcb   $BE >
         fcb   $FC 
         fcb   $83 
         fcb   $B6 6
         fcb   $FC 
         fcb   $80 
         fcb   $8A 
         fcb   $80 
         fcb   $B7 7
         fcb   $FC 
         fcb   $80 
         fcb   $7F ÿ
         fcb   $FD 
         fcb   $05 
         fcb   $7F ÿ
         fcb   $FC 
         fcb   $60 `
         fcb   $9E 
         fcb   $92 
         fcb   $10 
         fcb   $AF /
         fcb   $88 
         fcb   $E0 `
         fcb   $30 0
         fcb   $02 
         fcb   $8C 
         fcb   $FC 
         fcb   $60 `
         fcb   $24 $
         fcb   $06 
         fcb   $6D m
         fcb   $84 
         fcb   $26 &
         fcb   $05 
         fcb   $20 
         fcb   $F3 s
         fcb   $8E 
         fcb   $FC 
         fcb   $40 @
         fcb   $9F 
         fcb   $92 
L009F    fcb   $9E 
         fcb   $92 
         fcb   $86 
         fcb   $40 @
         fcb   $A7 '
         fcb   $01 
L00A5    fcb   $DC \
         fcb   $26 &
         fcb   $16 
         fcb   $00 
         fcb   $A2 "

CLKSRV         ldx   >CLKPRT,pcr
         lda   $01,x
         bita  #$04

         fcb   $10 
         fcb   $27 '
         fcb   $FF 
         fcb   $7D ý
         fcb   $EC l
         fcb   $06 
         fcb   $0A 
         fcb   $2E .
         fcb   $10 
         fcb   $26 &
         fcb   $00 
         fcb   $8C 
         fcb   $96 
         fcb   $96 
         fcb   $27 '
         fcb   $0D 
         fcb   $4A J
         fcb   $97 
         fcb   $96 
         fcb   $26 &
         fcb   $19 
         fcb   $B6 6
         fcb   $FD 
         fcb   $1D 
         fcb   $8A 
         fcb   $C0 @
         fcb   $B7 7
         fcb   $FD 
         fcb   $1D 
         fcb   $96 
         fcb   $9A 
         fcb   $27 '
         fcb   $0D 
         fcb   $4A J
         fcb   $97 
         fcb   $9A 
         fcb   $26 &
         fcb   $08 
         fcb   $B6 6
         fcb   $FD 
         fcb   $1D 
         fcb   $84 
         fcb   $7F ÿ
         fcb   $B7 7
         fcb   $FD 
         fcb   $1D 
         fcb   $96 
         fcb   $97 
         fcb   $27 '
         fcb   $0D 
         fcb   $4A J
         fcb   $97 
         fcb   $97 
         fcb   $26 &
         fcb   $19 
         fcb   $B6 6
         fcb   $FD 
         fcb   $35 5
         fcb   $8A 
         fcb   $40 @
         fcb   $B7 7
         fcb   $FD 
         fcb   $35 5
         fcb   $96 
         fcb   $9B 
         fcb   $27 '
         fcb   $0D 
         fcb   $4A J
         fcb   $97 
         fcb   $9B 
         fcb   $26 &
         fcb   $08 
         fcb   $B6 6
         fcb   $FD 
         fcb   $35 5
         fcb   $8A 
         fcb   $C0 @
         fcb   $B7 7
         fcb   $FD 
         fcb   $35 5
         fcb   $DC \
         fcb   $2C ,
         fcb   $5C \
         fcb   $C1 A
         fcb   $3C <
         fcb   $25 %
         fcb   $3B ;
         fcb   $4C L
         fcb   $81 
         fcb   $3C <
         fcb   $25 %
         fcb   $35 5
         fcb   $DC \
         fcb   $2A *
         fcb   $5C \
         fcb   $C1 A
         fcb   $18 
         fcb   $25 %
         fcb   $2B +
         fcb   $4C L
         fcb   $30 0
         fcb   $8D 
         fcb   $FF 
         fcb   $0C 
         fcb   $D6 V
         fcb   $29 )
         fcb   $C1 A
         fcb   $02 
         fcb   $26 &
         fcb   $0B 
         fcb   $D6 V
         fcb   $28 (
         fcb   $27 '
         fcb   $07 
         fcb   $C4 D
         fcb   $03 
         fcb   $26 &
         fcb   $03 
         fcb   $5F _
         fcb   $20 
         fcb   $02 
         fcb   $D6 V
         fcb   $29 )
         fcb   $A1 !
         fcb   $85 
         fcb   $23 #
         fcb   $0E 
         fcb   $DC \
         fcb   $28 (
         fcb   $5C \
         fcb   $C1 A
         fcb   $0C 
         fcb   $23 #
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
         fcb   $64 d
         fcb   $97 
         fcb   $2E .
         fcb   $DC \
         fcb   $E0 `
         fcb   $DD ]
         fcb   $CE N
         fcb   $6E n
         fcb   $9F 
         fcb   $00 
         fcb   $E8 h

*****
*
*  Clock Initialization Entry
*
ClkEnt    equ   *
         pshs  dp
         clra  
         tfr   a,dp
         pshs  cc
         lda   >$FC61
         ora   #$10
         sta   >$FC61
         sta   >$FD02
         lda   #$64
         sta   D.Tick
         lda   #$02
         sta   D.TSlice
         sta   D.Slice
         orcc  #$50
         leax  >CLKSRV,pcr
         stx   D.IRQ
         ldx   >CLKPRT,pcr
         ldd   #$0009
         std   $02,x
         clra  
         clrb  
         std   $04,x
         ldd   #$00BF
         std   $06,x
         clr   $01,x
         lda   #$40
         sta   ,x
         lda   #$01
         sta   $01,x
         lda   #$80
         sta   ,x
         puls  cc
         leay  >TIMSVC,pcr
         os9   F$SSvc   
         puls  pc,dp

TIME     lda   D.SysTsk
         ldx   D.Proc
         ldb   P$Task,x
         ldx   #D.Year
         ldy   #6
         ldu   R$X,u
         os9   F$Move   
         rts   
         emod
ClkEnd      equ   *
