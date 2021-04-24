 ifp1
 use defsfile
DYNAVERS equ $0484
 endc
 opt m
 org 0

MEMPTR equ $1A

M0000 fcb $F5,$A8,$E9,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcc "DYNACALC, Version 4.8:4              "
      fcc "Copyright (C) 1982,1984 by Scott Schaeferle."
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00

M0088 fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
      fcb $1B,'[,'?,'3,'h,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
      fcb $1B,'[,'?,'3,'l,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
      fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
M00B8 fcb $1B,'[,'K,$FF,$FF,$FF,$1B,'[
      fcb 'J,$FF,$FF,$FF,$1B,'[,'7,'m,$FF,$FF,$FF,$FF,$1B,'[,'0,';
      fcb '1,'m,$FF,$FF,$08,$20,$08,$FF,$FF,$FF,$08,$FF,$FF,$FF
M00DE fcc "Televideo 970   "
M00EE fcb $04,$FF
      fcb $FF,$FF,$00,$00,$00,$FF,$FF
M00F7 fcb $0E
M00F8 fcb $00,$00
M00FA fcb $00,$00,$FF,'Y,$00,'A
M0100 fcb $05,$18,$13,$04,$10,$03,$07,$19,$08,$7F,$00,$00,$00,$18,'~,$12
      fcb $02,$07,$00,$00,$00,$00,$00,'a,$F0,$00,'X,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb '[,'1,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$92,$FF,$00,$07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,'$,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$09,$02,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$14,$00
      fcb $00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $0D,'_,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,'#,$14,$00,$00,$00,'Z,$80,$01,$F1,$03,$00,$00
      fcb $FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
M0200 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$01,$00,$00,$01,$00,$01,$18,$7F,$08,$0D,$00,$04,$01,$00
      fcb $00,$00,$08,$07,$0B,$1E,$00,$00,$00,$00,$00,$00,$96,'2,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
M0300 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$01,$00,$00,$01,$00,$00,$18,$08,$18,$0D,$00,$04,$01
      fcb $00,$00,$00,$08,$07,$15,$00,$00,'*,$00,$00,$00,$B9,$9D,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$01,$00,$01,$01,$00,$01,$18,$08,$18,$0D,$1B,$04,$01,$17
      fcb $03,$11,$08,$07,$15,$00,$00,'*,$00,$00,$00,$B9,$9D,$00,$00,$00
      fcb $80,$80,$80,$80,$80,$0D,$FF,'+,'-,'.,$FF,'/,'*,'^,'<,'>
      fcb '=,',,$FF,'(,'),$FF,'#,'@,$FF,'!,$FF,$FF,'",$FF,'+,'-
      fcb '(,'.,'@,'#,$FF,'>,$FF,'X,'!,$0D,$80,$FF,$80,$80,$80,$80
      fcb $FF,'/,$FF,$FF,$20,$20,'(,'X,'),$20,$00,'R,'e,'a,'d,'y
      fcb $00,'V,'a,'l,'u,'e,$00,'L,'a,'b,'e,'l,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
M0400 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
M0500 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00

M0562 fcb ' ,' ,' ,' ,' ,' ,'M,'a,'y,' ,'2,'9,',,' ,'1,'9,'8,'4
      fcb $00

M0575 fcb $06,$00,'F,'-,$9E,$CA
M057B fcb $20,$02,'j,'b,'9
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $08,$C8,$CA,'a,$10,$A7,$C3,$82,$9A,$CD,$07,'u,$87,$CB,$EC,$83
      fcb '",$AA,'6,$DB,$AD,$01,$02,$82,$08,$C8,$CA,'a,$10,$A7,$C3,$83
      fcb $DA,$EB,$E9,$14,$85,$BD,'h,$84,'f,$0A,$FB,$F5,$8B,$01,$CE,$82
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF,$00,$00,$01,$00
M0600 fcb $00,'$,$00,$00,$00,$00,$00,$00,$10,$8E,$00,'P,'0,$8D,$00,$19
      fcb $86,$02,$10,'?,$8A,'O,'0,$8D,$00,$0F,$10,$8E,$00,$01,$10,'?
      fcb $89,$EE,$8D,$FF,'P,'n,$C9,'<,$95

      fcb $0D,$0A,$0A
      fcb 'O,'U,'T,' ,'O,'F,' ,'M,'E,'M,'O,'R,'Y,'-,' ,'W,'o,'r,'k,'s
      fcb 'h,'e,'e,'t,' ,'n,'o,'t,' ,'c,'o,'m,'p,'l,'e,'t
      fcb 'e,'l,'y,' ,'l,'o,'a,'d,'e,'d,'.
      fcb $0D,$0A
      fcb 'P,'r,'e,'s,'s,' ,'a,'n,'y,' ,'k,'e,'y,' ,'t,'o,' ,'c,'o
      fcb 'n,'t,'i,'n,'u,'e,'.
      fcb $0D,$0A
      fcb $00,$00,$00,$00,$00,$00,$00
M0680 fcb '!,' ,'s,'p,'l,$20,'-,'n,'h,$20,'-,'n,'j,$20,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
M06C0 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
M0700 fcb $18,$FF,'/,'4

      fcb ' ,' ,' ,' ,' ,' ,' ,' ,'(,'P,'r,'e
      fcb 's,'s,' ,'a,'n,'y,' ,'k,'e,'y,' ,'t,'o,' ,'c,'o
      fcb 'n,'t,'i,'n,'u,'e,'),$FF,'t,$20,$20,$20,$FF,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
M0800 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
M0900 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,'",'a,'6
      fcb $FA,'p,'a,'6,$FA,'U,$01,'",'a,'@,$FA,'p,'a,'@,$FA,'U
      fcb $D4,$00,$00,$00,$01,'",'a,'N,$FA,'p,'a,'N,$FA,'U,$D4,$00
      fcb $00,$00,$DF,$C0,$00,'C,'a,'c,$F2,$B3,$03,$DF,$C0,$FA,'p,'a
      fcb 'c,$FA,'U,$94,$03,$01,$00,$E3,$00,$B9,':,$B7,'#,$CC,$FC,$BF
      fcb $1C,$0A,$B9,':,$F9,$A5,$84,$00,$00,$00,$00,$00,$01,'",'a,$88
      fcb $FA,$A0,$FA,'p,'a,$88,$FA,'U,$D0,'a,$E2,$00,$00,'c,$DF,$C0
      fcb 'a,$A6,$F3,'=,$D0,'a,$E2,$00,$00,'a,$DF,$C0,'a,$A6,$F3,'=
      fcb $FA,'p,'a,$A6,$FA,'U,$84,$03,'d,$00,$00,'c,$E3,$00,$B7,$EA
      fcb $CF,'*,$CE,$D7,$CD,'>,$CB,$DB,$B7,'#,$06,$00,$01,'",$B8,$80
      fcb 'a,$E2,$CB,$04,'a,$00,'a,$E2,$C3,$DA,$B3,$00,'),$00,$CA,$FF
      fcb $C4,$C5,$C4,'x,$BE,'b,$B8,$00,$B8,$80,'a,$E2,$FA,'p,'a,$E2
      fcb $FA,'3,$80,$03,'?,'Y,'X,$00,'2,$00,$8B,'=,$8A,$E6,'d,$80
M09F0 nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop

M0A05    lbra  M0A27

* Entry point for start routine in dynacalc program
* X contains the program counter a few instructions before the jump.
M0A08    lbra  M0A21

         pshs  x,a
         tfr   pc,x
         leax  >-$5C0F,x
         stx   >M0575,pcr
         lda   #$FF
         sta   >$0143,u
         puls  x,a
         bra   M0A74

M0A21    cmpd  #$0484
         beq   M0A6A
M0A27    lda   #$02
         leax  >M0A38,pcr
         ldy   #$FFFF
         os9   I$WritLn
         clrb
         os9   F$Exit

M0A38    fcc   "DYNACALC and DYNACALC.TRM are different versions."
         fcb   $0D

M0A6A    leax  >-$0B34,x
         stx   >M0575,pcr
         puls  u,y,x,b,a
M0A74    std   >$01C1,u
         tfr   dp,a
         inca
         tfr   a,dp
         stx   <$0041
         stu   <$001A
         leax  >$0280,u
         stx   <$00E9
         ldx   #$0700
         stx   <$0044
         clr   <$00ED
         clr   <$00EE
         clr   <$0019
         clr   <$00A7
         clr   >M06C0,pcr
         ldu   <$001A
         leax  >$09F0,u
         stx   <$0017
         tfr   x,s
         leax  >$0331,u
         stx   <$0030
         leax  <$2F,x
         clra
         clrb
         os9   I$GetStt
         leax  >M0600,pcr
         clra
         clrb
         std   -$02,x
         sta   -$04,x
         coma
         comb
         std   -$06,x
         leax  >M0680,pcr
         lda   #$02
         os9   I$Open
         bcc   M0ADC
         leax  >M0680,pcr
         lda   #$02
         ldb   #$1B
         os9   I$Create
         bcc   M0ADC
         clr   >M0680,pcr
         bra   M0B11
M0ADC    sta   <$0012
         ldx   <$0030
         clrb
         os9   I$GetStt

         bcs   M0B06
         ldx   <$0030
         clrb
         lda   ,x
         beq   M0B00
         deca
         bne   M0B06
         lda   <$0012
         ldb   #$02      Get file size
         os9   I$GetStt
         bcs   M0B06
         os9   I$Seek
         bcs   M0B06
         ldb   #$FF
M0B00    stb   <$0013
         bne   M0B11
         bra   M0B0A

M0B06    clr   >M0680,pcr
M0B0A    lda   <$0012   data file path number
         os9   I$Close
         clr   <$0012   data file path number

M0B11    ldx   <$0030
         os9   F$Time

* Seed the random number generator
         leay  $06,x
         leau  >M057B,pcr
         ldb   #$04
         lda   -$01,y
         eora  #$5A
M0B22    rola
         eora  ,-y
         sta   ,-u
         decb
         bne   M0B22
         leay  >M0562,pcr
         lda   $01,x
         deca
         cmpa  #$0B
         bls   M0B36
         clra
M0B36    ldb   #$09
         mul
         leau  >MONTHS,pcr
         leau  d,u
         ldb   #$09
M0B41    lda   ,u+
         sta   ,y+
         decb
         bne   M0B41
         lda   #$20
         sta   ,y+
         ldb   $02,x
         bsr   M0B64
         ldd   #$2C20
         std   ,y++
         ldd   #$3139
         std   ,y++
         ldx   <$0030
         ldb   ,x
         bsr   M0B64
         clr   ,y
         bra   M0B80

M0B64    clra
         ldu   #$0700
         stu   <$0044
         ldu   >M0575,pcr
         jsr   >$4950,u
         ldu   #$0700
         stu   <$0044
         ldd   <$001A
         leau  d,u
         ldd   $03,u
         std   ,y++
         rts

M0B80         ldy   >M0575,pcr
         jsr   >$0FFF,y
         ldb   $01,x
         bne   M0B91       L0011
         ldb   >M00F8,pcr
M0B91         stb   >M00FA,pcr
         clr   $0C,x
         clr   $0F,x
         clr   <$10,x
         clr   <$11,x

         clr   <$16,x
         clr   $04,x
         clr   $07,x
         jsr   >$100A,y
         ldu   #$01F1
         stu   <$00EB
         clr   <$00E0
         clr   <$00E8
         clr   <$00C4
         tst   >M00B8,pcr
         bpl   M0BBD
         dec   <$000E
M0BBD    tst   >M00F7,pcr
         bne   M0BC9
         lda   #$04
         sta   >M00F7,pcr
M0BC9    lda   #$90
         ldy   >M0575,pcr
         jsr   >$0F86,y
         lda   #$FF
         sta   <$00F0
         jsr   >$0F00,y
* Copy terminal name
         lda   #$0F
         leau  >M00DE,pcr
         leax  >TRMBANNR,pcr
M0BE6    ldb   a,u
         stb   a,x
         deca
         bpl   M0BE6

         ldd   <$000D
         subd  #$0A26
         lsra
         lsrb
         std   <$00BD
         ldb   #$04
         leau  >BANNER,pcr
M0BFC jsr   >$0F1B,y
         jsr   >$1CA4,y
         inc   <$00BD     Add 1 to line
         inc   <$00BD     Add 1 to line
         decb
         bne   M0BFC
         jsr   >$0F1B,y
         ldd   <$00C1
         cmpd  #$0001
         bls   M0C62
         ldy   <$0041
         lda   ,y
         cmpa  #$2D    minus
         beq   M0C52

      fcb $C6,$11,$9E,$E9,$A6,$A0,$81,$20,'',$20,$81,$0D,'',$09,'\,$D7
      fcb $ED,$A7,$85,$C1,'/,'&,$ED,$0D,$ED,'','','3,$8D,$01,$ED,$10
      fcb $AE,$8D,$F9,'1,$AD,$A9,$1C,$A4,$20,'6,$A6,$A0,$81,$20,'',$FA
      fcb '1,'?
M0C52 fcb $E6,'!,$C4,'_,$10,$83,'-,'H,'&,$DB,$A7,$8D,$F4,$9B
      fcb $20,$D5
M0C62 fcb $10,$AE,$8D,$F9,$0E,$AD,$A9,$1C,$A4,$C6,$04,$D7,'%,$AD
      fcb $A9,$1C,$B0,'&,$04,$0A,'%,'&,$F6,$0D,'C,'',$03,$17,'%,$80
      fcb $C6,$08,'0,$8D,$F4,'z,'3,$8D,$00,'f,$10,$9E,$1A,$A6,$80,'4
      fcb $16,$EC,$C1,'0,$AB,$A6,$E4,$A7,$84,$EC,$C1,'0,$AB,'5,$02,$A7
      fcb $84,'5,$14,'Z,'&,$E7,$AE,$8D,$F8,$CB,'1,$A9,$0F,$00,$EC,'&
      fcb $97,$1D,$0F,'},'D,'V,$06,'},$DD,'l,$EC,'&,'3,$AB,$9E,'A
      fcb '0,$01,'4,$10,$9E,$1A,'m,$89,$00,$FB,'5,$10,'&,$0D,'0,$1E
      fcb $0F,$1D,$10,$AE,$8D,$F8,$9E,$AD,$A9,'<,$AA,$12,$1F,$10,$DD,$1E
      fcb $93,$17,'D,'V,$D3,$17,$DD,'#,$EE,$8D,$F8,$89,'n,$C9,'P,$BA

      fdb $0381
      fcb $03,$AC,$03,$82,$03,$AD,$03,$83,$03,$AE,$03,$84,$03,$AF
M0D00 fcb $03,$AA,$03,$AA,$03,$A7,$03,$A7
         fdb   $0380
         fdb   $0380
         fdb   $0380
         fdb   $0380


MONTHS   fcc   "  January"
         fcc   " February"
         fcc   "    March"
         fcc   "    April"
         fcc   "      May"
         fcc   "     June"
         fcc   "     July"
         fcc   "   August"
         fcc   "September"
         fcc   "  October"
         fcc   " November"
         fcc   " December"
BANNER   fcc   "          **** DYNACALC ****"
         fcb   0

         fcc   "        Version Number - 4.8:4"
         fcb   0
         fcc   "Copyright (C) 1984 by Scott Schaeferle"
         fcb   0
         fcc   "    Customized for the "
TRMBANNR fcc   "ADDS Viewpoint   "
         fcb   0
      fcc "        (Press any key to continue)"
         fcb   0
      fcc "                    Loading "

      fcb $00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

M0F00    lbra  M0F79
M0F03    lbra  M0F0D
         fdb   ENDHELP-M0F00
         fdb   ENDHELP-M0F00+$6100
M0F0A    lbra  M1046

M0F0D fcb $DE,$1A,$10
      fcb $AE,$C9,$05,'u,'3,$8D,$00,'D,$AD,$A9,$1C,$A4,$AD,$A9,$0A,$BF
      fcb $81,'Y,'',$04,'n,$A9,$1C,$89,$DE,$1E,$9E,'A,'0,$01,$9F,$1E
      fcb '4,'P,$03,$1D,$DC,'A,$93,$17,'D,'V,$D3,$17,$AD,$A9,'P,$BD
      fcb $1F,'0,$93,$C5,$DD,'l,$DC,$1E,$93,'l,$DD,$C5,$DC,'l,$0F,'}
      fcb 'D,'V,$06,'},$DD,'l,'5,'P,'n,$A9,'<,$A1

      fcc "Delete helps: Are you sure? "
      fcb $00

* Handling of help texts
M0F79    pshs  y
         ldy   <MEMPTR
         ldy   >M0575,y location of program
         ldb   ,x
         cmpb  #$88
         bne   M0F91
         tst   <$00E1
         beq   M0F91
         ldb   #$9A
         clr   <$00E1
M0F91      fcb $D7,'%,$DE,$B1,$96,$B3,$D6,'u,'4,'F,$17,$00,$A4,$86,$0A
      fcb $AD,$A9,$0A,$F5,'0,$8D,'!,$95,$D6,'%,':,$EC,$84,'3,$8D,$00
      fcb $C0,'3,$CB,$A6,$C0,'','3,$81,$11,'&,'#,$AD,$A9,'<,$9E,$AD
      fcb $A9,$0A,$D1,$E6,$1F,'\,$A6,$85,'4,$02,'o,$85,$AD,$A9,$0A,$BF
      fcb '5,$02,$81,$1B,'','G,'4,'@,$8D,'h,'5,'@,$20,$08,$AD,$A9
      fcb $0A,$F5,$81,$0D,'&,$CD,$86,$0A,$20,$F4,$AD,$A9,'<,$9E,$AD,$A9
      fcb $0A,$D1,$96,'%,$81,$80,'&,'%,$E6,$1F,'\,$A6,$85,$81,'@,'&
M1000 fcb $04,$C6,$9C,$20,$06,$81,'>,'&,$0A,$C6,$9E,$D7,'%,$AD,$A9,$0A
      fcb $BF,$20,$88,$84,'_,$81,'G,'&,$04,$C6,$84,$20,$EE,$8D,'#,$0F
      fcb $AC,$AD,$A9,$1C,$BC,$10,$9E,$1A,$10,$AE,$A9,$05,'u,$8E,$02,$00
      fcb $AD,$A9,$0A,$89,$AD,$A9,'<,$9E,'5,'F,$97,$B3,$DF,$B1,$D7,'u
      fcb '5,$A0,'n,$A9,$0A,$EC
M1046    ldu   <MEMPTR
         ldy   >M0575,u location of program
         ldd   #$2C20
      fcb $AD,$A9,$1C,$8C,$D6,'%,'0,$8D,$20,$F5,$C0,$C8,$C1,'5,'#,$02
      fcb $C6,'6,'X,':,$EC,$84,'3,$8D,$1F,$04,'3,$CB,$AD,$A9,'A,'v
         rts

* Texts are set for an 80-column display

HELPS fcc   "A  set Attributes        "
 fcc  "                 Hit @ for help with FUNCTIONS"
 fcb   $0D
 fcc   "B  Blank current cell    "
 fcc  "                     > for help with ERRORS"
 fcb   $0D
 fcc   "C  Clear entire worksheet"
 fcc  "                     G for general help"
 fcb   $0D
 fcc   "D  Delete current column or row"
 fcb   $0D
 fcc   "E  Edit contents of current cell"
 fcb   $0D
 fcc   "F  set Format of current cell"
 fcb   $0D
 fcc   "I  Insert new column or row at current position"
 fcb   $0D
 fcc   "K  enter Keysaver mode"
 fcb   $0D
 fcc   "L  Locate specified label "
 fcc   /(?="Wild card", @="Don't ignore case")/
 fcb   $0D
 fcc   "M  Move column or row to new position"
 fcb   $0D
 fcc   "P  Print all or portion of worksheet to"
 fcc   " system printer or textfile"
 fcb   $0D
 fcc   "Q  Quit DYNACALC and go to Sleep or to OS-9"
 fcb   $0D
 fcc   "R  Replicate cell or group of cells to new location"
 fcb   $0D
 fcc   "S  call System function"
 fcb   $0D
 fcc   "T  set column or row Titles"
 fcb   $0D
 fcc   "W  adjust display Window(s)"
 fcb   $0D
 fcb   $00

H.ATTRS fcc   "Set Attributes:"
 fcb   $0D
 fcb   $0A
 fcc   "B  toggles Bell on/off (default = on)"
 fcb   $0D
 fcc   "D  toggles Degree/radian mode (default = degrees)"
 fcb   $0D
 fcc   "G  allows changing Graph character (default = #)"
 fcb   $0D
 fcc   "H  deletes all Help messages & increases user space"
 fcb   $0D
 fcc   "L  toggles Label entry mode flag (default = off)"
 fcb   $0D
 fcc   "M  re-write (Modify) screen"
 fcb   $0D
 fcc   "O  toggles Column/Row calculation Order (default = C)"
 fcb   $0D
 fcc   "P  allows changing Printer/textfile parameters"
 fcb   $0D
 fcc   "R  toggles Auto/Manual Recalculate feature (default = A)"
 fcb   $0D
 fcc   "S  reports Size of worksheet"
 fcb   $0D
 fcc   "T  toggles the Type protection feature (default = off)"
 fcb   $0D

 fcc   "W  allows changing column Width(s)"
 fcb   $0D
 fcb   $00

H.DEL fcb   $0A
 fcb   $0A
 fcb   $0A
 fcb   $0A
 fcc   "Delete column/row:"
 fcb   $0D
 fcb   $0A
 fcc   "C  deletes current Column"
 fcb   $0D
 fcc   "R  deletes current Row"
 fcb   $0D
 fcb   $00

H.CFMT fcc   "Set Format of current cell:"
 fcb   $0D
 fcb   $0A
 fcc   "C  Continuous - characters repeated throughout cell"
 fcb   $0D
 fcc   "D  Default - uses window format"
 fcb   $0D
 fcc   "G  General - free-format (labels left, numbers right)"
 fcb   $0D
 fcc   "I  Integer - rounds DISPLAY to nearest integer"
 fcb   $0D
 fcc   "L  Left justify - forces number to left of cell"
 fcb   $0D
 fcc   "P  Plot - uses cell's integer value as number of"
 fcc   " graph chars. to print"
 fcb   $0D
 fcc   "R  Right justify - forces label to right of cell"
 fcb   $0D
 fcc   "$  Dollar - rounds DISPLAY to nearest cent"
 fcb   $0D
 fcb   $00

H.INS fcb   $0A
 fcb   $0A
 fcb   $0A
 fcb   $0A
 fcc   "Insert new column or row:"
 fcb   $0D
 fcb   $0A
 fcc   "C  inserts new blank Column at current position"
 fcb   $0D
 fcc   "R  inserts new blank Row at current position"
 fcb   $0D
 fcb   $00

H.QUIT fcb   $0A
 fcb   $0A
 fcb   $0A
 fcb   $0A
 fcc   "Quit:"
 fcb   $0D
 fcb   $0A
 fcc   "O  leave DYNACALC and return to OS-9"
 fcb   $0D
 fcc   "S  puts computer to Sleep until any key is struck"
 fcb   $0D
 fcb   $00

H.SYSTM fcc   "System:"
 fcb   $0D
 fcb   $0A
 fcc   "C  Change the current directory"
 fcb   $0D
 fcc   "L  Load worksheet from disk - overlays current sheet"
 fcb   $0D
 fcc   "S  Save current worksheet to disk"
 fcb   $0D
 fcc   "   Save and Load both default to .cal in current directory"
 fcb   $0D
 fcb   $0A
 fcc   "X  eXecute OS-9 command"
 fcb   $0D
 fcb   $0A
 fcc   "#  data file save/load - for data exchange"
 fcb   $0D
 fcc   "   both default to the current directory"
 fcb   $0D
 fcb   $00

H.SAVE fcb   $0A
 fcb   $0A
 fcb   $0A
 fcb   $0A
 fcc   "Save data:"
 fcb   $0D
 fcb   $0A
 fcc   "L  Load labels and CALCULATED Values from disk"
 fcb   $0D
 fcb   $0A
 fcc   "S  Save labels and CALCULATED Values to disk"
 fcb   $0D
 fcb   $00

H.TITLE fcb   $0A
 fcb   $0A
 fcb   $0A
 fcc   "Titles:"
 fcb   $0D
 fcb   $0A
 fcc   "B  set up Both horizontal and vertical titles"
 fcb   $0D
 fcc   "H  set up row(s) above cursor as Horizontal title area"
 fcb   $0D
 fcc   "N  No titles"
 fcb   $0D
 fcc   "V  set up column(s) to left of cursor as Vertical title area"
 fcb   $0D
 fcb   $00

H.WINDOW fcc   "Windows:"
 fcb   $0D
 fcb   $0A
 fcc   "D  toggle value/formula Display flag (defaults to value)"
 fcb   $0D
 fcc   "F  sets default Format of all cells in current window"
 fcb   $0D
 fcc   "H  divides screen Horizontally into two windows at current location"
 fcb   $0D
 fcc   "N  No division - returns display to single window"
 fcb   $0D
 fcc   "S  Synchronizes motion of two windows"
 fcb   $0D
 fcc   "U  Unsynchronizes motion of two windows (default)"
 fcb   $0D
 fcc   "V  divides screen Vertically into two windows at current location"
 fcb   $0D
 fcb   $00

H.WFMT fcc   "Set default format of current window:"
 fcb   $0D
 fcb   $0A
 fcc   "C  Continuous - characters repeated throughout cell"
 fcb   $0D
 fcc   "D  Default - general format (see)"
 fcb   $0D
 fcc   "G  General - free-format (labels left, numbers right)"
 fcb   $0D
 fcc   "I  Integer - rounds DISPLAY to nearest integer"
 fcb   $0D
 fcc   "L  Left justify - forces number to left of cell"
 fcb   $0D
 fcc "P  Plot - uses cell's integer value as number of graph chars. to print"
 fcb   $0D
 fcc   "R  Right justify - forces label to right of cell"
 fcb   $0D
 fcc   "$  Dollar - rounds DISPLAY to nearest cent"
 fcb   $0D
 fcb   $00

H.PRINT fcc   "Printer attributes:"
 fcb   $0D
 fcb   $0A
 fcc   "B  toggles Border flag on/off (defaults to off)"
 fcb   $0D
 fcc   "C  Clears the printer file name"
 fcb   $0D
 fcc   "L  sets Length of page (defaults to 58 lines)"
 fcb   $0D
 fcc   "P  toggles Pagination flag on/off (defaults to on)"
 fcb   $0D
 fcc   "S  sets the Spaces between lines"
 fcb   $0D
 fcc   "W  sets Width of page (defaults to 80 characters)"
 fcb   $0D
 fcb   $0A
 fcc   "  All of these default values may be permanently"
 fcb   $0D
 fcc   '  modified by the user, using "Install.dc"'
 fcb   $0D
 fcb   $00

H.WIDTH fcb   $0A
 fcb   $0A
 fcc   "Width:"
 fcb   $0D
 fcb   $0A
 fcc   "C  allows changing width of current Column"
 fcb   $0D
 fcc   "   (defaults to Window value)"
 fcb   $0D
 fcb   $0A
 fcc "W  allows changing default width of all columns in current Window"
 fcb   $0D
 fcc   "   (defaults to 9 characters)"
 fcb   $0D
 fcb   $00

H.MOVE fcb   $0A
 fcb   $0A
 fcb   $0A
 fcc   "Move column/row:"
 fcb   $0D
 fcb   $0A
 fcc   "A  Sort columns/rows in the given range in Ascending order"
 fcb   $0D
 fcc   "D  Sort columns/rows in the given range in Descending order"
 fcb   $0D
 fcc   "M  Manually move column/row"
 fcb   $0D
 fcb   $00

H.ORDER fcb   $0A
 fcb   $0A
 fcc   "C  loads/saves data by Column"
 fcb   $0D
 fcb   $0A
 fcc   "D  loads/saves data by Default order"
 fcb   $0D
 fcb   $0A
 fcc   "R  loads/saves data by Rows"
 fcb   $0D
 fcb   $00

H.TRIG fcc   "Trigonometric:    @SIN      @ASIN       @PI (3.14...)"
 fcb   $0D
 fcc   "                  @COS      @ACOS "
 fcb   $0D
 fcc   "                  @TAN      @ATAN "
 fcb   $0D
 fcb   $0A
 fcc   "Logarithmic:      @LOG(x)      logarithm of x to base 10"
 fcb   $0D
 fcc "                  @LN(x)       logarithm of x to base e (2.718...)"
 fcb   $0D
 fcc   "                  @EXP(x)      e raised to x power"
 fcb   $0D
 fcc   "                  @SQRT(x)     square root x"
 fcb   $0D
 fcb   $0A
 fcc   "General:          @ABS(x)      absolute value of x"
 fcb   $0D
 fcc   "                  @INT(x)      integer part of x"
 fcb   $0D
 fcc   "                  @RND(x)      random number, 0 to x-1"
 fcb   $0D
 fcc   "                  @ROUND(d,x)  x rounded to nearest d"
 fcb   $0D
 fcc "                               (d must be even power of 10)"
 fcb $0D
 fcb $0A
 fcc "               Hit any key to see page 2"
 fcb $11
 fcc "Series:   @COUNT(x...y)    number of cells in range x...y"
 fcb $0D
 fcc "          @SUM(x...y)      sum of values of cells in range x...y"
 fcb $0D
 fcc "          @AVERAGE(x...y)  average value of cells in range x...y"
 fcb   $0D
 fcc "          @STDDEV(m,x...y) standard deviation of cells in range x...y,"
 fcb   $0D
 fcc   "                           m sets method:  <0 = population;"
 fcc   "  >=0 = sample"
 fcb   $0D
 fcc   "          @MIN(x...y)      least value of cells in range x...y"
 fcb   $0D
 fcc   "          @MAX(x...y)      greatest value of cells in range x...y"
 fcb   $0D
 fcc   "          @NPV(r,x...y)    Net Present Value of cells"
 fcc   " in range x...y at rate r"
 fcb   $0D
 fcc   "Indexing: @CHOOSE(n,x...y) value of nth cell in range x...y"
 fcb   $0D
 fcc   "          @LOOKUP(n,x...y,z) '>' search - z optional - see manual"
 fcb   $0D
 fcc   "          @INDEX(n,x...y,z)  '=' search - z optional - see manual"
 fcb   $0D
 fcc   "Error:    @ERROR           causes >ER< message (general use)"
 fcb   $0D
 fcc   "          @NA              causes >NA< message (not available)"
 fcb   $0D
 fcb   $0A
 fcc "               Hit any key to see page 3"
 fcb $11
 fcc "Logical:  @NOT(x)       complement of x"
 fcb   $0D
 fcc "          @AND(x...y)   true if all cells in range x...y true"
 fcb   $0D
 fcc "          @OR(x...y)    true if any cells in range x...y true"
 fcb   $0D
 fcc "          @EOR(x,y)     true if x & y are different"
 fcb   $0D
 fcb   $0A
 fcc "          @IF(c,t,f)    if c=true, return t; else f"
 fcb   $0D
 fcc "            @IF can return values,labels, or logical"
 fcb $0D,$0A
 fcc "          @ISNA(X)      true if cell x is >NA<"
 fcb   $0D
 fcc "          @ISERROR(x)   true if cell x has any error"
 fcb $0D,$0A
 fcc "          @TRUE         returns logical true"
 fcb   $0D
 fcc "          @FALSE        returns logical false"
 fcb $0D,$0A
 fcc   "                   Hit any key to exit Help"
 fcb $00

H.ARIT fcc   "Arithmetic operators: x+y  adds x and y"
 fcb   $0D
 fcc   "                      x-y  subtracts y from x"
 fcc   "  (use 0-x for monadic minus)"
 fcb   $0D
 fcc   "                      x*y  multiplies x by y"
 fcb   $0D
 fcc   "                      x/y  divides x by y"
 fcb   $0D
 fcc   "                      x^y  raises x to y power"
 fcb   $0D
 fcb   $0A
 fcc   "Logical operators:    x=y  true if x equals y"
 fcb $0D
 fcc   "                      x<>y true if x doesn't equal y"
 fcb $0D
 fcc   "                      x>y  true if x is greater than y"
 fcb $0D
* Incorrect in original
 fcc   "                      y<x  true if x is less than y"
 fcb $0D
 fcc   "                      x>=y,x=>y true if x is greater than or equal to y"
 fcb $0D
 fcc   "                      x<=y,x=<y true if x is less than or equal to y"
 fcb $0D,$0A
 fcc "               Hit any key to see page 2"

 fcb $11
 fcc "Arithmetic operators operate on and return numbers only."
 fcb $0D
 fcc "Logical operators operate on numbers or labels and return"
 fcb $0D
 fcc "logical (True/False) values only."
 fcb $0D,$0A
 fcc   "Maximum number of terms (pending additions) is 11"
 fcb   $0D
 fcb   $0A
 fcc   "Parentheses within terms may be nested to any depth"
 fcb   $0D
 fcb   $0A
 fcc   "To enter expression, first character must not be alphabetic"
 fcb   $0D
 fcc   "   For example, to enter A1+A2, type '+A1+A2'"
 fcb   $0D
 fcb   $0A
 fcc   "To enter numeric as a label, use leading single-quote (')"
 fcb   $0D
 fcb   $0A
 fcc   "                  Hit any key to exit Help"
 fcb   $00
H.ERRMSG fcc   "       DYNACALC Error Messages"
 fcb   $0D
 fcb   $0A
 fcc   "    >AE<  Bad argument error"
 fcb   $0D
 fcc   "    >D0<  Divide by zero attempted"
 fcb   $0D
 fcc   "    >ER<  General purpose error"
 fcb   $0D
 fcc   "    >EX<  Exponent too large"
 fcb   $0D
 fcc   "    >HO<  Holder overflow error"
 fcb   $0D
 fcc   "    >LG<  Logical error"
 fcb   $0D
 fcc   "    >LN<  Negative or zero logarithm attempted"
 fcb   $0D
 fcc   "    >NA<  Not available"
 fcb   $0D
 fcc   "    >NR<  Negative root attempted"
 fcb   $0D
 fcc   "    >OV<  Arithmetic overflow error"
 fcb   $0D
 fcc   "    >RE<  Reference error"
 fcb   $0D
 fcc   "    >RN<  Range error"
 fcb   $0D
 fcc   "    >SN<  Syntax error"
 fcb   $0D
 fcb   $0A
 fcc   "      Hit any key to exit Help"
 fcb   $0D
 fcb   $00


ERRMSGS equ *
ERROR01  fcc   "Path table full."
 fcb   $00
ERROR02  fcc   "Illegal path number."
 fcb   $00

ERRORXX equ *
  fcc "See description."
 fcb   $00

ERROR07  fcc   "Module directory full."
 fcb   $00
ERROR08  fcc   "Memory full."
 fcb   $00
ERROR10  fcc   "Module busy."
 fcb   $00
ERROR12  fcc   "End of file."
 fcb   $00
ERROR15  fcc   "No permission- access denied."
 fcb   $00
ERROR16  fcc   "Bad path name."
 fcb   $00
ERROR17  fcc   "The file/device cannot be found."
 fcb   $00
ERROR22  fcc   "Link to a non-existing module."
 fcb   $00
ERROR23  fcc   "Sector number out of range."
 fcb   $00
ERROR30  fcc   "Process table full."
 fcb   $00
ERROR35  fcc   "Non-executable module."
 fcb   $00
ERROR38  fcc   "Write protect."
 fcb   $00
ERROR39  fcc   "Checksum error."
 fcb   $00
ERROR40  fcc   "Read error."
 fcb   $00
ERROR41  fcc   "Write error."
 fcb   $00
ERROR42  fcc   "Device not ready."
 fcb   $00
ERROR43  fcc   "Seek error."
 fcb   $00
ERROR44  fcc   "Media full."
 fcb   $00
ERROR45  fcc   "Device/media type mismatch."
 fcb   $00
ERROR46  fcc   "Device busy."
 fcb   $00
ERROR47  fcc   "Device/media ID changed."
 fcb   $00
ERROR50  fcc   "Unknown error code."
 fcb   $00

* Offsets to error codes
ERRTBL   fdb   ERROR01-ERRMSGS
 fdb   ERROR02-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR07-ERRMSGS
 fdb   ERROR08-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR10-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR12-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR15-ERRMSGS
 fdb   ERROR16-ERRMSGS
 fdb   ERROR17-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR22-ERRMSGS
 fdb   ERROR23-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR30-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR35-ERRMSGS
 fdb   ERROR50-ERRMSGS
 fdb   ERROR50-ERRMSGS
 fdb   ERROR50-ERRMSGS
 fdb   ERROR50-ERRMSGS
 fdb   ERROR50-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR23-ERRMSGS
 fdb   ERROR38-ERRMSGS
 fdb   ERROR39-ERRMSGS
 fdb   ERROR40-ERRMSGS
 fdb   ERROR41-ERRMSGS
 fdb   ERROR42-ERRMSGS
 fdb   ERROR43-ERRMSGS
 fdb   ERROR44-ERRMSGS
 fdb   ERROR45-ERRMSGS
 fdb   ERROR46-ERRMSGS
 fdb   ERROR47-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERRORXX-ERRMSGS
 fdb   ERROR50-ERRMSGS

HELPTBL  fdb   $0000
 fdb   H.ATTRS-HELPS
 fdb   H.ARIT-HELPS
 fdb   H.SAVE-HELPS
 fdb   H.CFMT-HELPS
 fdb   H.WINDOW-HELPS
 fdb   H.TITLE-HELPS
 fdb   H.SYSTM-HELPS
 fdb   H.WIDTH-HELPS
 fdb   H.QUIT-HELPS
 fdb   H.PRINT-HELPS
 fdb   H.DEL-HELPS
 fdb   H.INS-HELPS
 fdb   H.WFMT-HELPS
 fdb   H.TRIG-HELPS
 fdb   H.ERRMSG-HELPS
 fdb   H.MOVE-HELPS
 fdb   H.ORDER-HELPS
ENDHELP equ *
 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
