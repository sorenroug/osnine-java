 ifp1
 use defsfile
DYNAVERS equ $0483
 endc
 opt m
 org 0


M0000 fcb $1F,$F4,$DA,$5F,$62,$26,$F0,$4B,$00,$00,$00,$00,$00,$00,$01,$00
      fcc "DYNACALC, Version 4.8:3              "
      fcc "Copyright (C) 1982,1984 by Scott Schaeferle."
      fcb $02,$00,$02,$00,$01,$00,$01,$01,$11,'0,$8D,$00,',,$97,'m
      fcb $A7,$A0,$A6,$80,'&,$F8,$CE,$07,$00,$DF,'D,'4,$20,$10,'?,$0C
      fcb $1F,$20,'5,$20,$8D,$9D,$DF,$44

M0088 fcb $1B,'.,'1,$FF
      fcb $1B,'.,'0,$FF
      fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
      fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
      fcb $14,$99,$88,$FF,$FF,$FF,$FF,$FF,$05,$FF,$FF,$FF,$FF,$FF,$13,$FF
      fcb $FF,$FF,$FF,$FF,$06,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$06,$FF,$FF,$FF
      fcb $FF,$FF,$FF,$FF,$08,$20,$08,$FF,$FF,$FF,$08,$FF,$FF,$FF
M00DE fcc "Color Computer  "
M00EE fcb $04,$FF
      fcb $FF,$FF,$00,$00,$00,$FF,$FF
M00F7 fcb $13
M00F8 fcb $00,$00
M00FA fcb $00,$00,$FF,'O,$00,'9
M0100 fcb $0C,$0A,$08,$09,$1C,$19,$07,$11,'|,$05,$20,$20,$02,$19,'O,$12
      fcb $01,$1A,$00,$00,$00,$00,$00,'a,$F0,$00,'X,$00,$00,$00,'p,$1A
      fcb $09,$09,$00,'i,$05,$04,$00,$00,$00,$01,$00,$00,$00,'#,'l,$00
      fcb '[,'1,'V,$00,'a,$EE,$10,$DD,'l,$83,$00,$17,$00,'U,$DF,$84
      fcb $FF,$92,$FF,$00,$07,$00,'],$80,$F8,$DD,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,'[,$7F,$FF,$FF,$FF,$FE,$00,'$,$00
      fcb $00,$00,$00,$00,'/,$09,$00,$01,$00,$00,$01,$16,$09,$02,$01,$07
      fcb $01,$07,$02,'\,$11,$00,$00,$00,$00,'E,'e,$90,$FF,$00,'e,'u
      fcb $FF,'e,$90,$00,'e,'u,$00,$00,$0D,$00,$00,$00,'Z,$83,'',$D4
      fcb $00,$00,$04,$07,$08,$00,$00,$00,$00,$04,$04,$00,$00,'C,$00,$00
      fcb $00,$ED,'],$10,$04,$00,$00,$00,$00,$00,$00,$00,$FF,$FF,$00,'e
      fcb 'u,'],$82,$00,$92,$00,$00,$FF,$00,$00,$00,$FF,$00,$0F,$14,$01
      fcb $13,$00,$01,$00,$00,'o,$CA,$00,$00,$00,$00,$00,$FF,$80,'a,$E6
      fcb $0D,'_,$00,$00,$00,$FF,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,'#,$14,$00,$00,$00,'Z,$80,$01,$F1,$03,$00,'.
      fcb $FF,$00,$FF,$EF,'X,$20,$80,$81,$06,$14,'X,$00,$08,$FF,$FF,$1B
M0200 fcb $E2,$B7,$B6,$1D,$9E,'K,$85,$89,$15,'y,$EF,$89,$B0,'m,'q,$8A
      fcb 'D,'Y,'N,'A,'C,'A,'L,'C,',,$20,'V,'e,'r,'s,'i,'o
      fcb 'S,'S,'4,'.,'8,':,'2,$20,'2,'(,$0A,'2,$0A,'2,$0A,'2
      fcb $0A,'2,$0A,'(,$0A,'2,'2,$0A,'(,$0A,'2,$0A,'2,$0A,'2,$0A
      fcb 'C,'),$20,'1,'9,'8,'2,',,'1,'9,'8,'3,$20,'b,'y,$20
      fcb 'S,'c,'o,'t,'t,$20,'S,'c,'h,'a,'e,'f,'e,'r,'l,'e
      fcb $00,$00,$01,$00,$FF,$00,$01,$00,'','",'!,'(,'','",'!,$1E
      fcb $1B,$19,$16,$15,$13,$12,$11,$0E,$0D,$09,$08,$06,$03,$01,$01,$FF
      fcb $00,$00,$01,$00,$00,$01,$00,$01,$19,$08,$18,$0D,$00,$04,$01,$00
      fcb $00,$00,$08,$07,$00,$00,$00,'*,$00,$00,$00,$BF,'u,$00,$00,$00
      fcb '1,',,'@,'E,'R,'R,'O,'R,$20,'a,'t,'i,'o,'n,$20,'R
      fcb 'a,'n,'g,'e,'?,$20,'A,'4,'.,'.,'.,'A,'2,'0,$1B,'Y
      fcb $FF,$00,$00,$00,$1B,'),$FF,$00,$00,$00,$00,$00,$1B,'(,$FF,$00
      fcb $00,$00,$00,$00,$08,$20,$08,$FF,$00,$00,$08,$FF,$FF,$00,'A,'D
      fcb $00,$05,$09,$07,$09,$00,$05,$02,$D0,$05,$02,$03,$00,$00,$00,$00
      fcb $00,$00,$02,'-,$00,$00,$00,$04,$00,$00,$00,$00,$FF,'O,$00,'9
M0300 fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $02,$05,$00,$00,$00,$00,$00,'c,$F0,$00,'Z,$00,$00,$00,'r,$1E
      fcb '6,$00,'5,'3,'1,'1,'6,'7,'0,'6,'1,'1,'0,'0,'0,'0
      fcb $00,$00,$00,$01,$00,$00,$01,$00,$00,$18,$08,$18,$0D,$00,$04,$01
      fcb $00,$00,$00,$08,$07,$15,$00,$00,'*,$00,$00,$00,$B9,$9D,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,'],$7F,$FF,$FF,$FF,$FE,$00,'y,$00
      fcb $00,$00,$01,$00,$01,$01,$00,$01,$18,$08,$18,$0D,$1B,$04,$01,$17
      fcb $03,$11,$08,$07,$15,$00,$00,'*,$00,$00,$00,$B9,$9D,$00,$00,$00
      fcb $80,$80,$80,$80,$80,$0D,$FF,'+,'-,'.,$FF,'/,'*,'^,'<,'>
      fcb '=,',,$FF,'(,'),$FF,'#,'@,$FF,'!,$FF,$FF,'",$FF,'+,'-
      fcb '(,'.,'@,'#,$FF,'>,$FF,'X,'!,$0D,$80,$FF,$80,$80,$80,$80
      fcb $FF,'/,$FF,$FF,$20,$20,'(,'X,'),$20,$00,'R,'e,'a,'d,'y
      fcb $00,'V,'a,'l,'u,'e,$00,'L,'a,'b,'e,'l,$00,$00,'c,$E6
      fcb $0D,'a,$00,$00,$00,$FF,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,'\,$80,'[,$F1,$00,$00,$00
      fcb $FF,$01,$FF,$FE,$FF,$FF,$83,$80,$08,$14,'Z,$00,$0D,$FF,$FF,'@
M0400 fcb $1B,$80,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$84,'@,$00,$00,$00,$00,$00,$00,$83,$0B,'i,$00,$12,$87
      fcb $00,$00,$00,$00,$00,$00,$00,$82,'K,$00,$12,'D,$00,$00,$0B,'4
      fcb $00,$14,$00,$14,$00,$14,$00,$14,$00,$10,$00,$10,'2,$0A,'2,$00
      fcb $FF,$EB,$FF,$EB,$FF,$EB,$FF,$EB,$FF,$EB,$FF,$EB,$FF,$EB,$FF,$EB
      fcb $FF,$14,$FF,$14,$FF,$14,$FF,$14,$FF,$10,$FF,$10,$FF,$10,$FF,$10
      fcb $FF,$EB,$FF,$EB,$FF,$EB,$FF,$EB,$FF,$EB,$FF,$EB,$FF,$EB,$FF,$EB
      fcb $FF,$14,$FF,$14,$FF,$14,$FF,$14,$FF,$10,$FF,$10,$04,$03,$04,$FF
      fcb 'S,'a,'v,'e,$20,':,$20,'P,'a,'t,'h,$20,'n,'a,'m,'e
      fcb '-,$20,'h,'o,'l,'d,'.,'c,'a,'l,$20,$20,$00,'.,'.,'B
      fcb '1,$20,$20,'D,'e,'s,'t,'i,'n,'a,'t,'i,'o,'n,$20,'R
      fcb 'a,'n,'g,'e,'?,$20,'D,'4,'.,'.,'.,'D,'4,$00,$00,$0A
      fcb $FF,$EB,$FF,$EB,$FF,$EB,$FF,$EB,$FF,$FB,$FF,$FB,$FF,$FB,$FF,$FF
      fcb $FF,$04,$FF,$04,$FF,$04,$FF,$04,$FF,$00,$FF,$00,$FF,$C0,$81,$8D
      fcb $FF,$EB,$FF,$EB,$FF,$EB,$FF,$EB,$80,$87,$FF,$FB,$FF,$FB,$FF,$FB
      fcb $FF,$04,$FF,$04,$FF,$04,$FF,$04,$FF,$00,$FF,$00,$FF,$00,$FF,$00
M0500 fcb $00,$00,$00,$F0,'),$00,$0B,$1A,$09,$00,$04,$04,$0B,$1A,$06,$14
      fcb $00,$00,$01,$07,$00,$00,$00,$00,$09,$00,$00,$00,$00,$01,$07,'K
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
      fcb 'X,$F2,$01,$83,$00,$00,$02,'E,$00,$00,$02,$00,$00,$00,$09,'f
      fcb $00,$00,'[,$9D,$9C,$E6,$12,$CD,$00,$CE,$CE,'s,$00,$00,$E6,$00
      fcb $00,$00

M0562 fcb $20,$20,$20,$20,'A,'p,'r,'i,'l,$20,'2,'6,',,$20,'1,'9,'8,'4
      fcb $00

M0575 fcb $06,$00,'*,$98,'D,$B2,$20,$02,'j,'b,'9
      fcb $16,$00,$00,$01,$0A,$00,$00,'+,'-,'.,$FF,'/,'*,'^,'<,'>
      fcb '=,',,$FF,'(,'),$FF,'#,'@,$FF,'!,$FF,$FF,'",$FF,'+,'-
      fcb '(,'.,'@,'#,$FF,'>,$FF,'`,'!,$0D,$1E,$FF,$0B,$0A,$08,$0C
      fcb $FF,'/,$FF,$FF,$20,$20,'(,'L,'),$20,$00,'R,'e,'a,'d,'y
      fcb $DE,$1A,'3,$C9,$00,$BE,'m,$C4,$10,'*,$F3,$AB,$DE,$BD,'4,'@
      fcb '&,$1C,'_,$96,$0D,'J,$1F,$01,$1E,$89,$17,$F3,$1E,$86,$0A,$17
      fcb $F3,$A5,'Z,'*,$FA,$20,$10,$97,$BD,$0F,$BE,$17,$F3,$0F,$8D,$11
      fcb $96,$BD,'L,$91,$0D,'&,$F0,'5,'@,$DF,$FF,$FF,$00,$FF,$01,$00
M0600 fcb $7F,'$,'r,$0B,'),',,'2,$7F,$10,$8E,$00,'P,'0,$8D,$00,$19
      fcb $86,$02,$10,'?,$8A,'O,'0,$8D,$00,$0F,$10,$8E,$00,$01,$10,'?
      fcb $89,$EE,$8D,$FF,'P,'n,$C9,'<,$CD,$0D,$0A,$0A,'O,'U,'T,$20
      fcb 'O,'F,$20,'M,'E,'M,'O,'R,'Y,'-,$20,'W,'o,'r,'k,'s
      fcb 'h,'e,'e,'t,$20,'n,'o,'t,$20,'c,'o,'m,'p,'l,'e,'t
      fcb 'e,'l,'y,$20,'l,'o,'a,'d,'e,'d,'.,$0D,$0A,'P,'r,'e
      fcb 's,'s,$20,'a,'n,'y,$20,'k,'e,'y,$20,'t,'o,$20,'c,'o
      fcb 'n,'t,'i,'n,'u,'e,'.,$0D,$0A,'@,',,'@,'s,'r,'t,$7F
M0680 fcb '/,'P,$20,$00,$00,$EB,$00,$EB,$00,$FF,$00,$FB,$00,$EB,$00,$EB
      fcb $00,$04,$00,$00,$00,$04,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00
      fcb $00,$EB,$00,$EB,$00,$EB,$00,$EB,$00,$FF,$00,$FB,$00,$FB,$00,$FB
      fcb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0A
M06C0 fcb $00,'a,'b,'e,'l,'i,'f,'.,'c,'a,'l,$20,$00,$FB,$FF,$FB
      fcb $FF,$04,$FF,$04,$FF,$04,$FF,$04,$FF,$00,$FF,$00,$FF,$00,$FF,$C4
      fcb $80,$87,$FF,$EB,$FF,$EB,$FF,$EB,$FF,$FB,$81,$87,$FF,$FB,$FF,$EB
      fcb $FF,$04,$FF,$04,$FF,$04,$FF,$04,$FF,$00,$FF,$00,$FF,$00,$FF,$00
M0700 fcb $18,$FF,'/,'4,$20,$20,$20,$20,$20,$20,$20,$20,'(,'P,'r,'e
      fcb 's,'s,$20,'a,'n,'y,$20,'k,'e,'y,$20,'t,'o,$20,'c,'o
      fcb 'n,'t,'i,'n,'u,'e,'),$FF,'t,$20,$20,$20,$FF,'R,'R,'O
      fcb 'R,$FF,'R,'O,'R,$FF,$20,$20,$20,'D,$20,$20,$20,'],'[,$20
      fcb $20,$20,'E,$20,$20,$20,'],'[,$20,$20,$20,'F,$20,$20,$20,']
      fcb $20,$20,$20,$20,$20,$20,$20,$20,$1B,'(,$1B,'=,'$,$20,$1B,')
      fcb $20,$20,'1,'-,$1B,'(,$20,$FF,'),$20,$20,'2,'-,$1B,'(,$1B
      fcb '=,'&,$20,$1B,'),$20,$20,'3,'-,$1B,'(,$1B,'=,'',$20,$1B
      fcb '),$20,$20,'4,'-,$1B,'(,$1B,'=,'(,$20,$1B,'),$20,$20,'5
      fcb '-,$1B,'(,$1B,'=,'),$20,$1B,'),$20,$20,'6,'-,$1B,'(,$1B
      fcb '=,'*,$20,$1B,'),$20,$20,'7,'-,$1B,'(,$1B,'=,'+,$20,$1B
      fcb '),$20,$20,'8,'-,$1B,'(,$1B,'=,',,$20,$1B,'),$20,$20,'9
      fcb '-,$1B,'(,$1B,'=,'-,$20,$1B,'),$20,'1,'0,'-,$1B,'(,$1B
      fcb '=,'.,$20,$1B,'),$20,'1,'1,'-,$1B,'(,$1B,'=,'/,$20,$1B
      fcb '),$20,'1,'2,'-,$1B,'(,$1B,'=,'0,$20,$1B,'),$20,'1,'3
      fcb '-,$1B,'(,$1B,'=,'1,$20,$1B,'),$20,'1,'4,'-,$1B,'(,$1B
M0800 fcb '=,'2,$20,$1B,'),$20,'1,'5,'-,$1B,'(,$1B,'=,'3,$20,$1B
      fcb '),$20,'1,'6,'-,$1B,'(,$1B,'=,'4,$20,$1B,'),$20,'1,'7
      fcb '-,$1B,'(,$1B,'=,'5,$20,$1B,'),$20,'1,'8,'-,$1B,'(,$1B
      fcb '=,'6,$20,$1B,'),$20,'1,'9,'-,$1B,'(,$1B,'=,'7,$20,$1B
      fcb '),$20,'2,'0,'-,$1B,'(,$FF,$20,$20,$20,$20,$20,$20,$20,$20
      fcb $20,$20,$1B,'=,'6,'$,$20,$FF,$20,$20,$20,$20,$20,$20,$1B,'=
      fcb '1,'L,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
      fcb $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$1B,'=
      fcb '2,'S,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
      fcb $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$1B,'=
      fcb '3,'L,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
      fcb $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$1B,'=
      fcb '4,'L,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
      fcb $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$1B,'=
      fcb '7,'h,$20,$20,$20,$20,$20,'o,'k,$FF,$20,'o,'k,$FF,$FF,$00
      fcb $13,$00,$00,$00,$00,$88,'i,$03,$0A,'G,$08,$01,'K,$00,$0A,'K
M0900 fcb $18,$FF,'=,$20,$20,$1B,'Y,$FF,'u,$20,'s,'u,'r,'e,'?,$FF
      fcb 'K,$20,'L,$20,'M,$20,'P,$20,'Q,$20,'R,$20,'S,$20,'T,$20
      fcb 'W,$20,'?,$1B,'=,'",$20,$FF,$00,$00,$00,$00,$01,'",'a,'6
      fcb $FA,'p,'a,'6,$FA,'U,$01,'",'a,'@,$FA,'p,'a,'@,$FA,'U
      fcb $D4,$00,$00,$00,$01,'",'a,'N,$FA,'p,'a,'N,$FA,'U,$D4,$00
      fcb $00,$00,$DF,$C0,$00,'C,'a,'c,$F2,$B3,$03,$DF,$C0,$FA,'p,'a
      fcb 'c,$FA,'U,$94,$03,$01,$00,$E3,$00,$B9,':,$B7,'#,$CC,$FC,$BF
      fcb $1C,$0A,$B9,':,$F9,$A5,$84,$00,$00,$00,$00,$00,$01,'",'a,$88
      fcb $FA,$A0,$FA,'p,'a,$88,$FA,'U,$D0,'a,$E2,$00,$00,'c,$DF,$C0
      fcb 'a,$A6,$F3,'=,$D0,'a,$E2,$00,$00,'b,$DF,$C0,'a,$A6,$F3,'=
      fcb $FA,'p,'a,$A6,$FA,'U,$84,$03,'d,$00,$00,'c,$E3,$00,$B7,$EA
      fcb $CF,'*,$CE,$D7,$CD,'>,$CB,$DB,$B7,'#,$06,$00,$03,'W,$B8,$80
      fcb 'a,$E2,$CB,$04,'a,$00,'a,$E2,$C3,$DA,$B3,$00,'),$00,$CA,$FF
      fcb $C4,$C5,$C4,'x,$BE,'b,$B8,$00,$B8,$80,'a,$E2,$FA,'p,'a,$E2
      fcb $FA,'3,$80,$03,'?,'Y,'X,$00,'2,$00,$8B,'=,$8A,$E6,'d,$9B
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
 fcb '4,$12,$1F,'Q,'0
      fcb $89,$A3,$F1,$AF,$8D,$FB,'^,$86,$FF,$A7,$C9,$01,'C,'5,$12,$20
      fcb 'S
M0A21    cmpd  #$0483
      fcb '','C
M0A27    lda   #$02
         leax  >M0A38,pcr
         ldy   #$FFFF
         os9   I$WritLn
         clrb
         os9   F$Exit

M0A38    fcc   "DYNACALC and DYNACALC.TRM are different versions."
         fcb   $0D

M0A6A fcb '0,$89,$F4,$CC,$AF,$8D
      fcb $FB,$03,'5,'v,$ED,$C9,$01,$C1,$1F,$B8,'L,$1F,$8B,$9F,'A,$DF
      fcb $1A,'0,$C9,$02,$80,$9F,$E9,$8E,$07,$00,$9F,'D,$0F,$ED,$0F,$EE
      fcb $0F,$19,$0F,$A7,'o,$8D,$FC,'(,$DE,$1A,'0,$C9,$09,$F0,$9F,$17
      fcb $1F,$14,'0,$C9,$03,'1,$9F,'0,'0,$88,'/,'O,'_,$10,'?,$8D
      fcb 'm,$8D,$F5,$FC,'+,$15,$AE,$8D,$FA,$BB,'0,$89,$1B,$DE,'3,$8D
      fcb $FA,$FE,$C6,'>,$A6,$C0,$A7,$80,'Z,'&,$F9,'0,$8D,$FB,'1,'O
      fcb '_,$ED,$1E,$A7,$1C,'C,'S,$ED,$1A,'0,$8D,$FB,$A3,$86,$02,$10
      fcb '?,$84,'$,$13,'0,$8D,$FB,$98,$86,$02,$C6,$1B,$10,'?,$83,'$
      fcb $06,'o,$8D,$FB,$8B,$20,'5,$97,$12,$9E,'0,'_,$10,'?,$8D,'%
M0B00 fcb $20,$9E,'0,'_,$A6,$84,'',$13,'J,'&,$16,$96,$12,$C6,$02,$10
      fcb '?,$8D,'%,$0D,$10,'?,$88,'%,$08,$C6,$FF,$D7,$13,'&,$0D,$20
      fcb $04,'o,$8D,$FB,'[,$96,$12,$10,'?,$8F,$0F,$12,$9E,'0,$10,'?
      fcb $15,'1,$06,'3,$8D,$FA,'D,$C6,$04,$A6,'?,$88,'Z,'I,$A8,$A2
      fcb $A7,$C2,'Z,'&,$F8,'1,$8D,$FA,$19,$A6,$01,'J,$81,$0B,'#,$01
      fcb 'O,$C6,$09,'=,'3,$8D,$01,$D3,'3,$CB,$C6,$09,$A6,$C0,$A7,$A0
      fcb 'Z,'&,$F9,$86,$20,$A7,$A0,$E6,$02,$8D,$14,$CC,',,$20,$ED,$A1
      fcb $CC,'1,'9,$ED,$A1,$9E,'0,$E6,$84,$8D,$04,'o,$A4,$20,$1C,'O
      fcb $CE,$07,$00,$DF,'D,$EE,$8D,$F9,$EC,$AD,$C9,'I,$88,$CE,$07,$00
      fcb $DF,'D,$DC,$1A,'3,$CB,$EC,'C,$ED,$A1,'9,$10,$AE,$8D,$F9,$D5
      fcb $AD,$A9,$10,$06,$E6,$01,'&,$04,$E6,$8D,$F5,'L,$E7,$8D,$F5,'J
      fcb 'o,$0C,'o,$0F,'o,$88,$10,'o,$88,$11,'o,$88,$16,'o,$04,'o
      fcb $07,$AD,$A9,$10,$11,$CE,$01,$F1,$DF,$EB,$0F,$E0,$0F,$E8,$0F,$C4
      fcb 'm,$8D,$F4,$E4,'*,$02,$0A,$0E,'m,$8D,$F5,$1B,'&,$06,$86,$04
      fcb $A7,$8D,$F5,$13,$86,$90,$10,$AE,$8D,$F9,$8A,$AD,$A9,$0F,$86,$86
      fcb $FF,$97,$F0,$AD,$A9,$0F,$00,$86,$0F,'3,$8D,$F4,$E1,'0,$8D,$02
M0C00 fcb $10,$E6,$C6,$E7,$86,'J,'*,$F9,$DC,$0D,$83,$0A,'&,'D,'T,$DD
      fcb $BD,$C6,$04,'3,$8D,$01,$80,$AD,$A9,$0F,$1B,$AD,$A9,$1C,$84,$0C
      fcb $BD,$0C,$BD,'Z,'&,$F1,$AD,$A9,$0F,$1B,$DC,$C1,$10,$83,$00,$01
      fcb '#,'K,$10,$9E,'A,$A6,$A4,$81,'-,'','2,$C6,$11,$9E,$E9,$A6
      fcb $A0,$81,$20,'',$20,$81,$0D,'',$09,'\,$D7,$ED,$A7,$85,$C1,'/
      fcb '&,$ED,$0D,$ED,'','','3,$8D,$01,$ED,$10,$AE,$8D,$F9,$16,$AD
      fcb $A9,$1C,$84,$20,'6,$A6,$A0,$81,$20,'',$FA,'1,'?,$E6,'!,$C4
      fcb '_,$10,$83,'-,'H,'&,$DB,$A7,$8D,$F4,$80,$20,$D5,$10,$AE,$8D
      fcb $F8,$F3,$AD,$A9,$1C,$84,$C6,$04,$D7,'%,$AD,$A9,$1C,$90,'&,$04
      fcb $0A,'%,'&,$F6,$0D,'C,'',$03,$17,'%,'e,$C6,$08,'0,$8D,$F4
      fcb '_,'3,$8D,$00,'f,$10,$9E,$1A,$A6,$80,'4,$16,$EC,$C1,'0,$AB
      fcb $A6,$E4,$A7,$84,$EC,$C1,'0,$AB,'5,$02,$A7,$84,'5,$14,'Z,'&
      fcb $E7,$AE,$8D,$F8,$B0,'1,$A9,$0F,$00,$EC,'&,$97,$1D,$0F,'},'D
      fcb 'V,$06,'},$DD,'l,$EC,'&,'3,$AB,$9E,'A,'0,$01,'4,$10,$9E
      fcb $1A,'m,$89,$00,$FB,'5,$10,'&,$0D,'0,$1E,$0F,$1D,$10,$AE,$8D
      fcb $F8,$83,$AD,$A9,'<,$E2,$12,$1F,$10,$DD,$1E,$93,$17,'D,'V,$D3
M0D00 fcb $17,$DD,'#,$EE,$8D,$F8,'n,'n,$C9,'P,$BA,$03,$81,$03,$AC,$03
      fcb $82,$03,$AD,$03,$83,$03,$AE,$03,$84,$03,$AF,$03,$AA,$03,$AA,$03
      fcb $A7,$03,$A7,$03,$80,$03,$80,$03,$80,$03,$80
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

         fcc   "        Version Number - 4.8:3"
         fcb   0
         fcc   "Copyright (C) 1983 by Scott Schaeferle"
         fcb   0
         fcc   "    Customized for the ADDS Viewpoint   "

      fcb $00
      fcb $20,$20,$20,$20,$20,$20,$20,$20,'(,'P,'r,'e,'s
      fcb 's,$20,'a,'n,'y,$20,'k,'e,'y,$20,'t,'o,$20,'c,'o,'n
      fcb 't,'i,'n,'u,'e,'),$00,$20,$20,$20,$20,$20,$20,$20,$20,$20
      fcb $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,'L,'o,'a,'d,'i
      fcb 'n,'g,$20,$00,$13,$00,$00,$00,$00,$86,'i,$03,$0B,'G,$05,$01
      fcb 'K,$00,$0B,'K,$00,$13,$16,'(,$FF,$00,$13,$00,$00,$00,$00,$85
      fcb 'i,$03,$0C,'G,$05,$01,'K,$00,$0C,'K,$00,$13,$16,'(,$FF,$00
      fcb $13,$A3,$D7,$0A,'=,$88,'i,$03,$0D,'G,$05,$01,'K,$00,$0D,'K
      fcb $00,$13,$16,'(,$FF,$00,$13,$8F,'\,'(,$F6,$86,'i,$03,$0E,'G
      fcb $05,$01,'K,$00,$0E,'K,$00,$13,$16,'(,$FF,$00,$13,$00,$00,$00
      fcb $00,$86,'i,$03,$0F,'G,$05,$01,'K,$00,$0F,'K,$00,$13,$16,'(
      fcb $FF,$00,$13,$00,$00,$00,$00,$86,'i,$03,$10,'G,$05,$01,'K,$00
      fcb $10,'K,$00,$13,$03,'7,'-,$10,$20,'k,$19,$99,$99,$99,$99,$9A
      fcb $87,'P,$05,$02,'J,$05,$11,$09,'0,'f,$20,'l,'a,'b,'e,'l

M0F00 fcb $16,$00,'v,$16,$00,$07,'",$E0,$83,$E0,$16,$01,'9,$DE,$1A,$10
      fcb $AE,$C9,$05,'u,'3,$8D,$00,'D,$AD,$A9,$1C,$84,$AD,$A9,$0A,$BF
      fcb $81,'Y,'',$04,'n,$A9,$1C,'i,$DE,$1E,$9E,'A,'0,$01,$9F,$1E
      fcb '4,'P,$03,$1D,$DC,'A,$93,$17,'D,'V,$D3,$17,$AD,$A9,'P,$BD
      fcb $1F,'0,$93,$C5,$DD,'l,$DC,$1E,$93,'l,$DD,$C5,$DC,'l,$0F,'}
      fcb 'D,'V,$06,'},$DD,'l,'5,'P,'n,$A9,'<,$D9,'D,'e,'l,'e
      fcb 't,'e,$20,'h,'e,'l,'p,'s,':,$20,'A,'r,'e,$20,'y,'o
      fcb 'u,$20,'s,'u,'r,'e,'?,$20,$00,'4,$20,$10,$9E,$1A,$10,$AE
      fcb $A9,$05,'u,$E6,$84,$C1,$88,'&,$08,$0D,$E1,'',$04,$C6,$9A,$0F
      fcb $E1,$D7,'%,$DE,$B1,$96,$B3,$D6,'u,'4,'F,$17,$00,$A4,$86,$0A
      fcb $AD,$A9,$0A,$F5,'0,$8D,'!,$94,$D6,'%,':,$EC,$84,'3,$8D,$00
      fcb $C0,'3,$CB,$A6,$C0,'','3,$81,$11,'&,'#,$AD,$A9,'<,$D6,$AD
      fcb $A9,$0A,$D1,$E6,$1F,'\,$A6,$85,'4,$02,'o,$85,$AD,$A9,$0A,$BF
      fcb '5,$02,$81,$1B,'','G,'4,'@,$8D,'h,'5,'@,$20,$08,$AD,$A9
      fcb $0A,$F5,$81,$0D,'&,$CD,$86,$0A,$20,$F4,$AD,$A9,'<,$D6,$AD,$A9
      fcb $0A,$D1,$96,'%,$81,$80,'&,'%,$E6,$1F,'\,$A6,$85,$81,'@,'&
M1000 fcb $04,$C6,$9C,$20,$06,$81,'>,'&,$0A,$C6,$9E,$D7,'%,$AD,$A9,$0A
      fcb $BF,$20,$88,$84,'_,$81,'G,'&,$04,$C6,$84,$20,$EE,$8D,'#,$0F
      fcb $AC,$AD,$A9,$1C,$9C,$10,$9E,$1A,$10,$AE,$A9,$05,'u,$8E,$02,$00
      fcb $AD,$A9,$0A,$89,$AD,$A9,'<,$D6,'5,'F,$97,$B3,$DF,$B1,$D7,'u
      fcb '5,$A0,'n,$A9,$0A,$EC,$DE,$1A,$10,$AE,$C9,$05,'u,$CC,',,$20
      fcb $AD,$A9,$1C,'l,$D6,'%,'0,$8D,$20,$F4,$C0,$C8,$C1,'5,'#,$02
      fcb $C6,'6,'X,':,$EC,$84,'3,$8D,$1E,$CD,'3,$CB,$AD,$A9,'A,$AE
      fcb '9

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
* Removed in 4.8:4
ERROR36  fcc   "Unit number out of range."
 fcb   $00
* Removed in 4.8:4
ERROR37  fcc   "Sector number out of range."
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
 fdb   ERROR36-ERRMSGS
 fdb   ERROR37-ERRMSGS
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

 fcb $20,$20,$20,$20,$20,$20,$20,$20,'@,'F,'A,'L,'S,'E,$20,$20
 fcb $20,$20,$20,$20,$20,$20,'r,'e,'t,'u,'r,'n,'s,$20,'l,'o
