         nam   index
         ttl   Record Management System - index

         ifp1
         use   defsfile
         endc
tylg     set   Prgrm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   2
u0002    rmb   2
u0004    rmb   2
u0006    rmb   1
u0007    rmb   1
u0008    rmb   1
u0009    rmb   1
u000A    rmb   1
u000B    rmb   4
u000F    rmb   3
u0012    rmb   3
u0015    rmb   2
u0017    rmb   2
u0019    rmb   2
u001B    rmb   1
u001C    rmb   1
u001D    rmb   1
u001E    rmb   10
u0028    rmb   1
u0029    rmb   5
u002E    rmb   1
u002F    rmb   2
u0031    rmb   2
u0033    rmb   2
u0035    rmb   2
u0037    rmb   1
u0038    rmb   1
u0039    rmb   2
u003B    rmb   2
u003D    rmb   2
u003F    rmb   4
u0043    rmb   4
u0047    rmb   1
u0048    rmb   1
u0049    rmb   2
u004B    rmb   2
u004D    rmb   2
u004F    rmb   2
u0051    rmb   2
u0053    rmb   2
u0055    rmb   2
u0057    rmb   1
u0058    rmb   2
u005A    rmb   2
u005C    rmb   1
u005D    rmb   163
u0100    rmb   7936
size     equ   .

name     equ   *
         fcs   /index/
         fcb   $01
start    equ   *
         leau  >u0100,u
         stu   <u0000
         stx   <u0004
         tfr   x,d
         subd  #$012C
         std   <u0002
         clr   <u002E
         clr   <u0028
         clr   <u0029
         lda   #$41
         sta   <u0047
         ldx   <u0000
         stx   <u001B
         lbsr  L0102
         lbne  L0621
         stx   <u001D
         lda   #$2E
         ldb   #$52
         std   ,x
         lda   #$4D
         ldb   #$53
         std   $02,x
         clr   $04,x
         ldx   <u001B
         lda   #$01
         os9   I$Open
         lbcs  L0627
         sta   <u0006
         tfr   dp,a
         ldb   #$12
         tfr   d,x
         ldy   #$0005
         lda   <u0006
         os9   I$Read
         lbcs  L0633
         lda   <u0012
         cmpa  #$55
         lbne  L0639
         ldd   <u0000
         std   <u000B
         addd  #$03E8
         std   <u000F
         addd  <u0015
         std   <u005D
         addd  #$0001
         std   <u0000
         ldx   <u001D
         lda   #$2E
         ldb   #$44
         std   ,x
         lda   #$49
         ldb   #$43
         std   $02,x
         clr   $04,x
         ldx   <u001B
         lda   #$01
         os9   I$Open
         lbcs  L062D
         sta   <u0007
         ldx   <u0000
         stx   <u0053
         lbsr  L0102
         lbne  L00C2
         lda   #$2E
         ldb   #$6E
         std   ,x
         lda   #$64
         ldb   #$78
         std   $02,x
         clr   $04,x
         leax  $05,x
         stx   <u0000
         ldx   <u0053
         os9   I$Delete
         bra   L00C9
L00C2    leax  >L0393,pcr
         lbra  L05CB
L00C9    ldx   <u0000
         stx   <u005A
         lbsr  L0102
         lbne  L067B
         ldd   #$0000
         std   ,x
         std   $02,x
         std   $04,x
         std   $06,x
         leax  $08,x
         stx   <u0000
         ldx   <u005A
L00E5    lda   ,x
         beq   L00F0
         lbsr  L0A00
         sta   ,x+
         bra   L00E5
L00F0    ldx   <u000B
         lda   #$01
         sta   <u002E
         clr   <u0057
         bsr   L0139
         lda   <u0007
         os9   I$Close
         lbra  L06BE
L0102    ldy   <u0004
L0105    lda   ,y
         cmpa  #$0D
         bne   L010E
         lda   #$01
         rts
L010E    cmpa  #$20
         beq   L0116
         cmpa  #$2C
         bne   L011A
L0116    leay  $01,y
         bra   L0105
L011A    ldb   #$50
L011C    lda   ,y
         cmpa  #$0D
         beq   L0133
         cmpa  #$2C
         beq   L0131
         cmpa  #$20
         bls   L0131
         leay  $01,y
         sta   ,x+
         decb
         bne   L011C
L0131    leay  $01,y
L0133    sty   <u0004
         lda   #$00
         rts
L0139    stx   <u0019
         clr   ,x
         stx   <u0017
L013F    lbsr  L02F7
         lbne  L02D7
         cmpa  #$20
         beq   L013F
         cmpa  #$0D
         bne   L0152
         inc   <u002E
         bra   L013F
L0152    cmpa  #$22
         lbne  L0645
L0158    lbsr  L02F7
         lbne  L0645
         cmpa  #$22
         bne   L0158
         clr   <u001B
L0165    lda   <u001B
         cmpa  #$31
         lbgt  L064B
L016D    lbsr  L02F7
         lbne  L02D7
         cmpa  #$20
         beq   L016D
         cmpa  #$3B
         beq   L016D
         cmpa  #$0D
         bne   L0184
         inc   <u002E
         bra   L016D
L0184    cmpa  #$24
         lbeq  L02D7
         ldx   <u0017
         stx   <u001C
         clr   <u001E
         clr   $01,x
         clr   $02,x
         clr   $03,x
         clr   $04,x
         clr   $05,x
         clr   $06,x
         clr   $07,x
L019E    ldx   <u001C
         lbsr  L0A00
         sta   ,x+
         stx   <u001C
         inc   <u001E
         lda   <u001E
         cmpa  #$08
         beq   L01C6
         lbsr  L02F7
L01B2    lbne  L0651
         cmpa  #$20
         beq   L01D9
         cmpa  #$2C
         beq   L01D9
         cmpa  #$0D
         bne   L019E
         inc   <u002E
         bra   L01D9
L01C6    lbsr  L02F7
         bne   L01B2
         cmpa  #$20
         beq   L01D9
         cmpa  #$2C
         beq   L01D9
         cmpa  #$0D
         bne   L01C6
         inc   <u002E
L01D9    clr   <u001C
L01DB    lbsr  L02F7
         bne   L01B2
         cmpa  #$20
         beq   L01DB
         cmpa  #$3B
         beq   L01DB
         cmpa  #$0D
         bne   L01F0
         inc   <u002E
         bra   L01DB
L01F0    cmpa  #$30
         lblt  L0657
         cmpa  #$39
         lbgt  L0657
         anda  #$0F
         sta   <u001D
         lda   <u001C
         cmpa  #$19
         lbgt  L0657
         ldb   #$0A
         mul
         addb  <u001D
         stb   <u001C
         lbsr  L02F7
         lbne  L0657
         cmpa  #$2C
         beq   L0226
         cmpa  #$20
         beq   L0226
         cmpa  #$0D
         bne   L01F0
         inc   <u002E
         bra   L0226
L0226    lda   <u001C
         lbeq  L0657
         ldx   <u0017
         sta   $08,x
L0230    lbsr  L02F7
         lbne  L065D
         lbsr  L0A00
         cmpa  #$2C
         beq   L0230
         cmpa  #$20
         beq   L0230
         cmpa  #$0D
         bne   L024A
         inc   <u002E
         bra   L0230
L024A    cmpa  #$44
         beq   L025D
         cmpa  #$4D
         beq   L0269
         cmpa  #$41
         beq   L0278
         cmpa  #$4E
         beq   L0278
         lbra  L065D
L025D    ldx   <u0017
         ldb   $08,x
         cmpb  #$08
         lbne  L066F
         bra   L0278
L0269    ldx   <u0017
         ldb   $08,x
         cmpb  #$03
         bgt   L0278
         leax  >L04DF,pcr
         lbra  L05CB
L0278    ldx   <u0017
         sta   $09,x
         lbsr  L02F7
         lbne  L065D
L0283    lbsr  L02F7
         lbne  L0663
         cmpa  #$0D
         bne   L0292
         inc   <u002E
         bra   L0283
L0292    cmpa  #$20
         beq   L0283
         cmpa  #$2C
         beq   L0283
         cmpa  #$22
         lbne  L0663
L02A0    lbsr  L02F7
         lbne  L0663
         cmpa  #$0D
         bne   L02AF
         inc   <u002E
         bra   L02A0
L02AF    cmpa  #$22
         bne   L02A0
L02B3    lbsr  L02F7
         beq   L02BF
         leax  >L04A0,pcr
         lbra  L05CB
L02BF    cmpa  #$0D
         bne   L02C7
         inc   <u002E
         bra   L02B3
L02C7    cmpa  #$3B
         bne   L02B3
         ldx   <u0017
         leax  <$14,x
         stx   <u0017
         inc   <u001B
         lbra  L0165
L02D7    ldx   <u0017
         clr   ,x
         ldx   <u0019
         ldy   #$0000
L02E1    tst   ,x
         beq   L02F1
         lda   $08,x
         clrb
         exg   a,b
         leay  d,y
         leax  <$14,x
         bra   L02E1
L02F1    leay  $02,y
         cmpy  <u0015
         rts

L02F7    pshs  x
         tst   <u0057
         bne   L0311
         ldy   #$0001
         ldx   <u000F
         lda   <u0007
         os9   I$Read
         bcs   L0311
         ldx   <u000F
         lda   ,x
         clrb
         puls  pc,x

L0311    lda   #$01
         sta   <u0057
         puls  pc,x

L0317    fcc   "INVALID FILE NAME\"
L0329    fcc   "CAN'T OPEN .RMS FILE\"
L033E    fcc   "CAN'T OPEN .DIC FILE\"
L0353    fcc   "RMS FILE IO ERROR\"
L0365    fcc   "INVALID RMS FILE PREFIX\"
L037D    fcc   "NO PRIMARY DICTIONARY\"
L0393    fcc   "INVALID INDEX FILE NAME\"
L03AB    fcc   "INVALID TITLE IN DICTIONARY\"
L03C7    fcc   "TOO MANY FIELDS IN DICTIONARY\"
L03E5    fcc   "INVALID FIELD NAME IN DICTIONARY\"
L0406    fcc   "INVALID FIELD LENGTH IN DICTIONARY\"
L0429    fcc   "INVALID TYPE CODE IN DICTIONARY\"
L0449    fcc   "INVALID PROMPT IN DICTIONARY\"
L0466    fcc   "INSUFFICIENT MEMORY\"
L047A    fcc   "DATE FIELD NOT LENGTH 8 IN DICTIONARY\"
L04A0    fcc   "MISSING ; IN DICTIONARY\"
L04B8    fcc   "TOTAL FIELD LENGTHS OVER RECORD LENGTH\"
L04DF    fcc   "MONEY FIELD LESS THAN LENGTH 4 IN DICTIONARY\"
L050C    fcc   "INVALID SORT FIELD SPECIFIED\"
L0529    fcc   "WRITE ERROR ON .NDX FILE\"
L0542    fcc   ".NDX FILE CREATED OK\"
L0557    fcc   "ERROR WHILE WRITING TEMPFILE\"
L0574    fcc   "NO RECORDS IN THE FILE, NO NDX CREATED\"
L059B    fcc   "RAN OUT OF MEMORY IN MERGE\"
L05B6    fcc   "TEMP FILE READ ERROR\"

L05CB    lda   #$0A
L05CD    bsr   L061E
         lda   #$0D
         bsr   L061E
L05D3    lda   ,x+
         cmpa  #$5C
L05D7    beq   L05DD
         bsr   L061E
         bra   L05D3
L05DD    lda   <u002E
         beq   L0612
         leax  >L05ED,pcr
L05E5    lda   ,x+
         beq   L05F4
         bsr   L061E
         bra   L05E5

L05ED    fcc   " LINE "
         fcb   0

L05F4    lda   <u002E
         clrb
L05F7    cmpa  #$0A
         blt   L0600
         suba  #$0A
         incb
L05FE    bra   L05F7
L0600    sta   <u001B
L0602    stb   <u001C
         lda   <u001C
         beq   L060C
         ora   #$30
         bsr   L061E
L060C    lda   <u001B
         ora   #$30
         bsr   L061E
L0612    lda   #$0A
         bsr   L061E
         lda   #$0D
         bsr   L061E
         clrb
         os9   F$Exit
L061E    lbra  L0A94
L0621    leax  >L0317,pcr
         bra   L05CB
L0627    leax  >L0329,pcr
         bra   L05CB
L062D    leax  >L033E,pcr
         bra   L05CB
L0633    leax  >L0353,pcr
         bra   L05CB
L0639    leax  >L0365,pcr
L063D    bra   L05CB
         leax  >L037D,pcr
         bra   L063D
L0645    leax  >L03AB,pcr
         bra   L063D
L064B    leax  >L03C7,pcr
         bra   L063D
L0651    leax  >L03E5,pcr
         bra   L063D
L0657    leax  >L0406,pcr
         bra   L063D
L065D    leax  >L0429,pcr
         bra   L063D
L0663    leax  >L0449,pcr
         bra   L063D
L0669    leax  >L0466,pcr
         bra   L063D
L066F    leax  >L047A,pcr
         bra   L063D
         leax  >L04B8,pcr
         bra   L063D
L067B    leax  >L050C,pcr
         bra   L063D
L0681    leax  >L0687,pcr
         bra   L063D

L0687    fcc   "TOO MANY MERGE PASSES REQUIRED"
         fcb   $0D,$0A
L06A7    fcc   "TRY GIVING MORE MEMORY\"

L06BE    ldx   <u000F
         leax  $01,x
         stx   <u001B
         ldx   <u000B
L06C6    lda   ,x
         beq   L06DB
         ldd   <u001B
         std   <$12,x
         clra
         ldb   $08,x
         addd  <u001B
         std   <u001B
         leax  <$14,x
L06D9    bra   L06C6
L06DB    clr   <u002E
         ldx   <u000B
L06DF    lda   ,x
         lbeq  L067B
         ldy   <u005A
         ldd   ,y
         cmpd  ,x
         bne   L0704
         ldd   $02,y
         cmpd  $02,x
         bne   L0704
         ldd   $04,y
         cmpd  $04,x
         bne   L0704
         ldd   $06,y
         cmpd  $06,x
         beq   L0709
L0704    leax  <$14,x
         bra   L06DF
L0709    ldd   <$12,x
         std   <u002F
         lda   $08,x
         sta   <u0031
         lda   $09,x
         sta   <u005C
         ldy   <u000B
         ldd   <$12,y
         std   <u0033
         lda   $08,y
         sta   <u0035
         clr   <u0037
         sta   <u0038
         cmpx  <u000B
         beq   L0733
         clrb
         adda  $08,x
         adcb  #$00
         sta   <u0038
         stb   <u0037
L0733    ldx   <u0000
         stx   <u0055
         lda   #$74
         ldb   #$65
         std   ,x
         lda   #$6D
         ldb   #$70
         std   $02,x
         lda   #$2E
         ldb   #$41
         std   $04,x
         clr   $06,x
         leax  $05,x
         stx   <u0058
         leax  $02,x
         stx   <u0000
         ldu   #$0000
         ldx   #$0000
         lda   <u0006
         os9   I$Seek
         clr   <u0043
         lbra  L077C
L0763    ldx   <u000F
         ldy   <u0015
         lda   <u0006
         os9   I$Read
         bcs   L077A
         ldx   <u000F
         lda   ,x
         cmpa  #$31
         bne   L0763
         lda   #$01
         rts
L077A    clra
         rts
L077C    ldx   <u0000
         stx   <u0039
         lda   #$0A
         lbsr  L0A94
         lda   #$0D
         lbsr  L0A94
         lda   #$53
         lbsr  L0A94
         lda   #$4F
         lbsr  L0A94
         lda   #$52
         lbsr  L0A94
         lda   #$54
         lbsr  L0A94
L079E    lda   <u0043
         bne   L07CF
         bsr   L0763
         bne   L07AA
         inc   <u0043
         bra   L07CF
L07AA    ldx   <u0039
         ldy   <u002F
         ldb   <u0031
L07B1    lda   ,y+
         sta   ,x+
         decb
         bne   L07B1
         ldy   <u0033
         cmpy  <u002F
         beq   L07C9
         ldb   <u0035
L07C2    lda   ,y+
         sta   ,x+
         decb
         bne   L07C2
L07C9    stx   <u0039
         cmpx  <u0002
         bcs   L079E
L07CF    ldx   <u0039
         cmpx  <u0000
         bne   L07D8
         lbra  L0914
L07D8    ldx   <u0000
         stx   <u003B
         ldd   <u0039
         subd  <u0037
         std   <u003F
L07E2    ldx   <u0000
         stx   <u003D
L07E6    ldx   <u003D
         cmpx  <u003F
         bcc   L0846
         ldd   <u0037
         leay  d,x
         lda   <u005C
         cmpa  #$44
         beq   L0813
         lda   <u0031
L07F8    ldb   ,y+
         exg   a,b
         lbsr  L0A00
         pshs  a
         lda   ,x+
         lbsr  L0A00
         exg   a,b
         cmpb  ,s+
         blt   L083C
         bgt   L0828
         deca
         bne   L07F8
         bra   L083C
L0813    ldd   $06,x
         cmpd  $06,y
         bne   L0826
         ldd   $03,x
         cmpd  $03,y
         bne   L0826
         ldd   ,x
         cmpd  ,y
L0826    bls   L083C
L0828    ldx   <u003D
         ldd   <u0037
         leay  d,x
         stb   <u001B
L0830    lda   ,x
         ldb   ,y
         sta   ,y+
         stb   ,x+
         dec   <u001B
         bne   L0830
L083C    ldx   <u003D
         ldd   <u0037
         leax  d,x
         stx   <u003D
         bra   L07E6
L0846    ldd   <u003F
         subd  <u0037
         std   <u003F
         lda   #$2E
         lbsr  L0A94
         ldd   <u003B
         addd  <u0037
         std   <u003B
         cmpd  <u0039
         bcs   L07E2
         lda   <u0043
         lbeq  L08D4
         lda   <u0047
         cmpa  #$41
         lbne  L08D4
         ldx   <u0053
         lda   #$02
         ldb   #$0B
         os9   I$Create
         bcc   L087C
L0875    leax  >L0529,pcr
         lbra  L05CB
L087C    sta   <u0008
         ldx   <u0000
         stx   <u003B
L0882    ldy   <u003B
         cmpy  <u0039
         beq   L08BE
         ldx   <u002F
         lda   <u0031
         cmpx  <u0033
         bne   L0893
         clra
L0893    leax  a,y
         ldb   <u0035
         stb   <u001C
         clr   <u001B
         ldy   <u001B
         lda   <u0008
         os9   I$Write
         bcs   L0875
         ldx   <u000F
         lda   #$0D
         sta   ,x
         ldy   #$0001
         lda   <u0008
         os9   I$Write
         bcs   L0875
         ldd   <u003B
         addd  <u0037
         std   <u003B
         bra   L0882
L08BE    lda   <u0008
         os9   I$Close
         bcs   L0875
         leax  >L0542,pcr
         lbra  L05CB
L08CC    ldy   <u0058
         lda   <u0047
         sta   ,y
         rts
L08D4    bsr   L08CC
         ldx   <u0055
         os9   I$Delete
         ldx   <u0055
         lda   #$02
         ldb   #$03
         os9   I$Create
         bcc   L08ED
L08E6    leax  >L0557,pcr
         lbra  L05CB
L08ED    sta   <u0009
         ldx   <u0000
         ldd   <u0039
         subd  <u0000
         tfr   d,y
         lda   <u0009
         os9   I$Write
         lbcs  L08E6
         lda   <u0009
         os9   I$Close
         bcs   L08E6
         inc   <u0047
         lda   <u0047
         cmpa  #$5A
         lbhi  L0681
         lbra  L077C
L0914    lda   #$0A
         lbsr  L0A94
         lda   #$0D
         lbsr  L0A94
         lda   #$4D
         lbsr  L0A94
         lda   #$45
         lbsr  L0A94
         lda   #$52
         lbsr  L0A94
         lda   #$47
         lbsr  L0A94
         lda   #$45
         lbsr  L0A94
         ldd   #$0003
         addd  <u0037
         std   <u0051
         lda   <u0047
         cmpa  #$41
         bne   L094B
         leax  >L0574,pcr
         lbra  L05CB
L094B    ldx   <u0000
         stx   <u0049
         stx   <u004B
         lda   <u0047
         sta   <u0048
         lda   #$41
         sta   <u0047
         clr   <u004D
L095B    lbsr  L08CC
         lda   #$01
         ldx   <u0055
         os9   I$Open
         bcs   L097C
         ldx   <u004B
         sta   ,x
         lda   <u0047
         sta   $02,x
         ldd   <u004B
         addd  <u0051
         cmpd  <u0002
         lbcc  L0669
         bra   L0983
L097C    leax  >L05B6,pcr
         lbra  L05CB
L0983    inc   <u004D
         ldx   <u004B
         lbsr  L0A67
         inc   <u0047
         ldd   <u004B
         addd  <u0051
         std   <u004B
         lda   <u0047
         cmpa  <u0048
         bne   L095B
         ldx   <u0053
         lda   #$02
         ldb   #$5B
         os9   I$Create
         lbcs  L0875
         sta   <u0008
L09A7    tst   <u004D
         bne   L09AE
         lbra  L08BE
L09AE    ldx   <u0049
L09B0    ldd   ,x
         cmpd  #$0000
         bne   L09C3
         ldd   <u0051
         leax  d,x
         cmpx  <u004B
         bcs   L09B0
         lbra  L08BE
L09C3    stx   <u004F
         stx   <u003B
L09C7    ldd   <u003B
         addd  <u0051
         std   <u003B
         cmpd  <u004B
         beq   L0A26
         ldx   <u004F
         ldy   <u003B
         ldd   ,y
         cmpd  #$0000
         beq   L09C7
         ldb   <u0031
         leax  $03,x
         leay  $03,y
         lda   <u005C
         cmpa  #$44
         beq   L0A0B
L09EB    lda   ,y+
         bsr   L0A00
         pshs  a
         lda   ,x+
         bsr   L0A00
         cmpa  ,s+
         blt   L09C7
         bgt   L0A20
         decb
         bne   L09EB
         bra   L09C7
L0A00    cmpa  #$61
         bcs   L0A0A
         cmpa  #$7A
         bhi   L0A0A
         suba  #$20
L0A0A    rts

L0A0B    ldd   $06,x
         cmpd  $06,y
         bne   L0A1E
         ldd   $03,x
         cmpd  $03,y
         bne   L0A1E
         ldd   ,x
         cmpd  ,y
L0A1E    bls   L09C7
L0A20    ldx   <u003B
         stx   <u004F
         bra   L09C7
L0A26    ldy   <u004F
         ldx   <u002F
         lda   <u0031
         cmpx  <u0033
         bne   L0A32
         clra
L0A32    leax  a,y
         leax  $03,x
         ldb   <u0035
         stb   <u001C
         clr   <u001B
         ldy   <u001B
         lda   <u0008
         os9   I$Write
         lbcs  L0875
         lda   #$0D
         ldx   <u000F
         sta   ,x
         ldy   #$0001
         lda   <u0008
         os9   I$Write
         lbcs  L0875
         ldx   <u004F
         bsr   L0A67
         lda   #$2E
         lbsr  L0A94
         lbra  L09A7

L0A67    stx   <u0039
         ldy   <u0037
         lda   ,x
         leax  $03,x
         os9   I$Read
         bcs   L0A76
         rts

L0A76    ldx   <u0039
         lda   ,x
         ldy   #$0000
         sty   ,x
         os9   I$Close
         dec   <u004D
         ldx   <u0039
         lda   $02,x
         ldx   <u0058
         sta   ,x
         ldx   <u0055
         os9   I$Delete
         rts

L0A94    pshs  x,b,a
         leax  ,s
         ldy   #$0001
         lda   #$01
         os9   I$Write
         puls  pc,x,b,a

         emod
eom      equ   *
