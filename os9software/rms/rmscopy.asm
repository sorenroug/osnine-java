         nam   rmscopy
         ttl   Record Management System - rmscopy

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
u0009    rmb   2
u000B    rmb   2
u000D    rmb   2
u000F    rmb   2
u0011    rmb   2
u0013    rmb   2
u0015    rmb   2
u0017    rmb   2
u0019    rmb   2
u001B    rmb   2
u001D    rmb   2
u001F    rmb   1
u0020    rmb   1
u0021    rmb   1
u0022    rmb   1
u0023    rmb   2
u0025    rmb   1
u0026    rmb   1
u0027    rmb   2
u0029    rmb   2
u002B    rmb   1
u002C    rmb   1
u002D    rmb   1
u002E    rmb   1
u002F    rmb   2
u0031    rmb   3
u0034    rmb   4
u0038    rmb   2
u003A    rmb   1
u003B    rmb   2
u003D    rmb   2
u003F    rmb   1
u0040    rmb   2
u0042    rmb   1
u0043    rmb   7
u004A    rmb   6
u0050    rmb   1
u0051    rmb   2
u0053    rmb   2
u0055    rmb   1
u0056    rmb   1
u0057    rmb   1
u0058    rmb   3
u005B    rmb   165
u0100    rmb   7744
size     equ   .
name     equ   *
         fcs   /rmscopy/
         fcb   $01

start    equ   *
         leau  >u0100,u
         stu   <u0000
         stx   <u0004
         tfr   x,d
         subd  #$0096
         std   <u0002
         clr   <u003F
         ldd   #$FFFF
         std   <u0038
         ldx   <u0000
         lbsr  L0143
         lbne  L061C
         stx   <u002B
         lda   #$2E
         ldb   #$52
         std   ,x
         lda   #$4D
         ldb   #$53
         std   $02,x
         clr   $04,x
         ldx   <u0000
         lda   #$01
         os9   I$Open
         lbcs  L0622
         sta   <u0007
         tfr   dp,a
         ldb   #$22
         tfr   d,x
         ldy   #$0005
         lda   <u0007
         os9   I$Read
         lbcs  L062E
         ldx   <u002B
         lda   #$2E
         ldb   #$44
         std   ,x
         lda   #$49
         ldb   #$43
         std   $02,x
         clr   $04,x
         ldx   <u0000
         lda   #$01
         os9   I$Open
         lbcs  L0628
         sta   <u0006
         ldx   <u0000
         stx   <u0051
         lbsr  L0143
         lbne  L0640
         stx   <u0053
         lda   #$2E
         ldb   #$52
         std   ,x
         lda   #$4D
         ldb   #$53
         std   $02,x
         clr   $04,x
         leax  $05,x
         stx   <u0000
         ldx   <u0051
         lda   #$03
         os9   I$Open
         lbcs  L0628
         sta   <u0008
         tfr   dp,a
         ldb   #$3F
         tfr   d,x
         ldy   #$0005
         lda   <u0008
         os9   I$Read
         lbcs  L062E
         lda   <u003F
         cmpa  #$55
         lbne  L0634
         ldy   <u0004
         clr   <u005B
         lda   ,y
         cmpa  #$2B
         bne   L00DF
         inc   <u005B
         ldd   #$0400
         std   <u0025
         ldd   #$7FFF
         std   <u0023
L00DF    ldd   <u0000
         std   <u0009
         addd  #$03E8
         std   <u000B
         addd  #$03E8
         std   <u000D
         addd  #$03E8
         std   <u000F
         addd  #$03E8
         std   <u0011
         addd  <u0025
         std   <u0013
         addd  <u0025
         std   <u0015
         addd  <u0042
         std   <u0017
         addd  <u0042
         std   <u0019
         addd  #$0401
         std   <u001B
         addd  #$0100
         std   <u001D
         addd  #$0100
         std   <u0000
         cmpd  <u0002
         lbcc  L066A
         ldx   <u0009
         lda   #$01
         sta   <u003F
         ldy   <u0025
         sty   <u004A
         clr   <u0050
         bsr   L017A
         tst   <u005B
         beq   L0134
         sty   <u0025
L0134    ldx   <u0009
         lda   ,x
         lbeq  L063A
         ldx   <u000B
         bsr   L017A
         lbra  L0682
L0143    ldy   <u0004
L0146    lda   ,y
         cmpa  #$0D
         bne   L014F
         lda   #$01
         rts
L014F    cmpa  #$20
         beq   L0157
         cmpa  #$2C
         bne   L015B
L0157    leay  $01,y
         bra   L0146
L015B    ldb   #$50
L015D    lda   ,y
         cmpa  #$0D
         beq   L0174
         cmpa  #$2C
         beq   L0172
         cmpa  #$20
         bls   L0172
         leay  $01,y
         sta   ,x+
         decb
         bne   L015D
L0172    leay  $01,y
L0174    sty   <u0004
         lda   #$00
         rts
L017A    stx   <u0029
         clr   ,x
         stx   <u0027
L0180    lbsr  L033E
         lbne  L031C
         cmpa  #$20
         beq   L0180
         cmpa  #$0D
         bne   L0193
         inc   <u003F
         bra   L0180
L0193    cmpa  #$22
         lbne  L0646
L0199    lbsr  L033E
         lbne  L0646
         cmpa  #$22
         bne   L0199
         clr   <u002B
L01A6    lda   <u002B
         cmpa  #$31
         lbgt  L064C
L01AE    lbsr  L033E
         lbne  L031C
         cmpa  #$20
         beq   L01AE
         cmpa  #$3B
         beq   L01AE
         cmpa  #$0D
         bne   L01C5
         inc   <u003F
         bra   L01AE
L01C5    cmpa  #$24
         lbeq  L031C
         ldx   <u0027
         stx   <u002C
         clr   <u002E
         clr   $01,x
         clr   $02,x
         clr   $03,x
         clr   $04,x
         clr   $05,x
         clr   $06,x
         clr   $07,x
L01DF    ldx   <u002C
         lbsr  L0BCD
         sta   ,x+
         stx   <u002C
         inc   <u002E
         lda   <u002E
         cmpa  #$08
         beq   L0207
         lbsr  L033E
         lbne  L0652
         cmpa  #$20
         beq   L021C
         cmpa  #$2C
         beq   L021C
         cmpa  #$0D
         bne   L01DF
         inc   <u003F
         bra   L021C
L0207    lbsr  L033E
         lbne  L0652
         cmpa  #$20
         beq   L021C
         cmpa  #$2C
         beq   L021C
         cmpa  #$0D
         bne   L0207
         inc   <u003F
L021C    clr   <u002C
L021E    lbsr  L033E
         lbne  L0652
         cmpa  #$20
         beq   L021E
         cmpa  #$3B
         beq   L021E
         cmpa  #$0D
         bne   L0235
         inc   <u003F
         bra   L021E
L0235    cmpa  #$30
         lblt  L0658
         cmpa  #$39
         lbgt  L0658
         anda  #$0F
         sta   <u002D
         lda   <u002C
         cmpa  #$19
         lbgt  L0658
         ldb   #$0A
         mul
         addb  <u002D
         stb   <u002C
         lbsr  L033E
         lbne  L0658
         cmpa  #$2C
         beq   L026B
         cmpa  #$20
         beq   L026B
         cmpa  #$0D
         bne   L0235
         inc   <u003F
         bra   L026B
L026B    lda   <u002C
         lbeq  L0658
         ldx   <u0027
         sta   $08,x
L0275    lbsr  L033E
         lbne  L065E
         lbsr  L0BCD
         cmpa  #$2C
         beq   L0275
         cmpa  #$20
         beq   L0275
         cmpa  #$0D
         bne   L028F
         inc   <u003F
         bra   L0275
L028F    cmpa  #$44
         beq   L02A2
         cmpa  #$4D
         beq   L02AE
         cmpa  #$41
         beq   L02BD
         cmpa  #$4E
         beq   L02BD
         lbra  L065E
L02A2    ldx   <u0027
         ldb   $08,x
         cmpb  #$08
         lbne  L0670
         bra   L02BD
L02AE    ldx   <u0027
         ldb   $08,x
         cmpb  #$03
         bhi   L02BD
         leax  >L057E,pcr
         lbra  L05C6
L02BD    ldx   <u0027
         sta   $09,x
         lbsr  L033E
         lbne  L065E
L02C8    lbsr  L033E
         lbne  L0664
         cmpa  #$0D
         bne   L02D7
         inc   <u003F
         bra   L02C8
L02D7    cmpa  #$20
         beq   L02C8
         cmpa  #$2C
         beq   L02C8
         cmpa  #$22
         lbne  L0664
L02E5    lbsr  L033E
         lbne  L0664
         cmpa  #$0D
         bne   L02F4
         inc   <u003F
         bra   L02E5
L02F4    cmpa  #$22
         bne   L02E5
L02F8    lbsr  L033E
         beq   L0304
         leax  >L04EB,pcr
         lbra  L05C6
L0304    cmpa  #$0D
         bne   L030C
         inc   <u003F
         bra   L02F8
L030C    cmpa  #$3B
         bne   L02F8
         ldx   <u0027
         leax  <$14,x
         stx   <u0027
         inc   <u002B
         lbra  L01A6
L031C    ldx   <u0027
         clr   ,x
         ldx   <u0029
         ldy   #$0000
L0326    tst   ,x
         beq   L0334
         ldb   $08,x
         clra
         leay  d,y
         leax  <$14,x
         bra   L0326
L0334    leay  $02,y
         cmpy  <u004A
         lbhi  L0676
         rts
L033E    pshs  x
         tst   <u0050
         bne   L0358
         ldy   #$0001
         ldx   <u0019
         lda   <u0006
         os9   I$Read
         bcs   L0358
         ldx   <u0019
         lda   ,x
         clrb
         puls  pc,x
L0358    lda   #$01
         sta   <u0050
         puls  pc,x

L035E    fcc   "INVALID FILE NAME\"
L0370    fcc   "CAN'T OPEN FROM .RMSFILE\"
L0389    fcc   "CAN'T OPEN .DIC FILE\"
L039E    fcc   "RMS FILE IO ERROR\"
L03B0    fcc   "INVALID RMS FILE PREFIX\"
L03C8    fcc   "NO PRIMARY DICTIONARY\"
L03DE    fcc   "CAN'T OPEN TO .RMS FILE\"
L03F6    fcc   "INVALID TITLE IN DICTIONARY\"
L0412    fcc   "TOO MANY FIELDS IN DICTIONARY\"
L0430    fcc   "INVALID FIELD NAME IN DICTIONARY\"
L0451    fcc   "INVALID FIELD LENGTH IN DICTIONARY\"
L0474    fcc   "INVALID TYPE CODE IN DICTIONARY\"
L0494    fcc   "INVALID PROMPT IN DICTIONARY\"
L04B1    fcc   "INSUFFICIENT MEMORY\"
L04C5    fcc   "DATE FIELD NOT LENGTH 8 IN DICTIONARY\"
L04EB    fcc   "MISSING ; IN DICTIONARY\"
L0503    fcc   "TOTAL FIELD LENGTHS OVER RECORD LENGTH\"
L052A    fcc   "KEY FIELD DIFFERENT IN PRIMARY AND SECONDARY DICT\"
L055C    fcc   "SECONDARY DICT HAS ONLY ONE FIELD\"
L057E    fcc   "MONEY FIELD LESS THAN LENGTH 4 IN DICTIONARY\"
L05AB    fcc   "I/O ERROR IN RMS MAIN FILE\"

L05C6    lda   #$0A
         bsr   L0619
         lda   #$0D
         bsr   L0619
L05CE    lda   ,x+
L05D0    cmpa  #$5C
         beq   L05D8
         bsr   L0619
         bra   L05CE
L05D8    lda   <u003F
         beq   L060D
         leax  >L05E8,pcr
L05E0    lda   ,x+
         beq   L05EF
L05E4    bsr   L0619
         bra   L05E0

L05E8    fcc   " LINE "
         fcb   0

L05EF    lda   <u003F
         clrb
L05F2    cmpa  #$0A
         blt   L05FB
         suba  #$0A
         incb
         bra   L05F2
L05FB    sta   <u002B
L05FD    stb   <u002C
L05FF    lda   <u002C
         beq   L0607
         ora   #$30
         bsr   L0619
L0607    lda   <u002B
         ora   #$30
L060B    bsr   L0619
L060D    lda   #$0A
         bsr   L0619
         lda   #$0D
         bsr   L0619
         clrb
         os9   F$Exit
L0619    lbra  L0C95
L061C    leax  >L035E,pcr
         bra   L05C6
L0622    leax  >L0370,pcr
         bra   L05C6
L0628    leax  >L0389,pcr
         bra   L05C6
L062E    leax  >L039E,pcr
         bra   L05C6
L0634    leax  >L03B0,pcr
         bra   L05C6
L063A    leax  >L03C8,pcr
L063E    bra   L05C6
L0640    leax  >L03DE,pcr
         bra   L063E
L0646    leax  >L03F6,pcr
         bra   L063E
L064C    leax  >L0412,pcr
         bra   L063E
L0652    leax  >L0430,pcr
         bra   L063E
L0658    leax  >L0451,pcr
         bra   L063E
L065E    leax  >L0474,pcr
         bra   L063E
L0664    leax  >L0494,pcr
         bra   L063E
L066A    leax  >L04B1,pcr
         bra   L063E
L0670    leax  >L04C5,pcr
         bra   L063E
L0676    leax  >L0503,pcr
         bra   L063E
L067C    leax  >L052A,pcr
         bra   L063E
L0682    ldx   <u0009
         ldy   <u000B
         lda   ,y
         beq   L06A4
         lda   #$0A
L068D    ldb   ,x+
         exg   a,b
         lbsr  L0BCD
         pshs  a
         lda   ,y+
         lbsr  L0BCD
         exg   a,b
         cmpb  ,s+
         bne   L067C
         deca
         bne   L068D
L06A4    ldx   <u0011
         leax  $01,x
         stx   <u002B
         ldx   <u0009
         bsr   L06B0
         bra   L06C6
L06B0    lda   ,x
         beq   L06C5
         ldd   <u002B
         std   <$12,x
         clra
         ldb   $08,x
         addd  <u002B
         std   <u002B
         leax  <$14,x
         bra   L06B0
L06C5    rts
L06C6    ldx   <u0013
         leax  $01,x
         stx   <u002B
         ldx   <u000B
         bsr   L06B0
         clr   <u003F
         ldd   #$2020
         ldx   <u0011
L06D7    std   ,x++
         cmpx  <u0019
         bne   L06D7
         lda   <u0006
         os9   I$Close
         ldx   <u0053
         lda   #$2E
         ldb   #$44
         std   ,x
         lda   #$49
         ldb   #$43
         std   $02,x
         clr   $04,x
         ldx   <u0051
         lda   #$01
         os9   I$Open
         lbcs  L0628
         sta   <u0006
         lda   #$FF
         ldb   <u0040
         bmi   L070D
         lda   #$7F
         bitb  #$40
         bne   L070D
         lda   #$3F
L070D    sta   <u0055
         ldx   <u000D
         lda   #$01
         sta   <u003F
         ldd   <u0042
         std   <u004A
         clr   <u0050
         lbsr  L017A
         ldy   <u000D
         lda   ,y
         lbeq  L063A
         ldx   <u000F
         lbsr  L017A
         lda   <u0006
         os9   I$Close
         ldy   <u000F
         lda   ,y
         beq   L0755
         ldx   <u000D
         lda   #$0A
L073C    ldb   ,x+
         exg   a,b
         lbsr  L0BCD
         pshs  a
         lda   ,y+
         lbsr  L0BCD
         exg   a,b
         cmpb  ,s+
         lbne  L067C
         deca
         bne   L073C
L0755    ldx   <u0015
         leax  $01,x
         stx   <u002B
         ldx   <u000D
         lbsr  L06B0
         ldx   <u0017
         leax  $01,x
         stx   <u002B
         ldx   <u000F
         lbsr  L06B0
         clr   <u003F
         ldx   <u000D
         stx   <u002B
         ldx   <u0009
         lbsr  L0A70
         beq   L077F
         leax  >L0975,pcr
         lbra  L05C6
L077F    ldx   <u001B
         stx   <u002D
         ldx   <u000D
         stx   <u002B
         ldx   <u0009
         stx   <u002F
         lbsr  L079F
         ldx   <u001D
         stx   <u002D
         ldx   <u000F
         stx   <u002B
         ldx   <u000B
         stx   <u002F
         bsr   L079F
         lbra  L0828
L079F    ldx   <u002B
         tst   ,x
         bne   L07AC
         ldx   <u002D
         clr   ,x
         clr   $01,x
         rts
L07AC    ldx   <u002F
         lbsr  L0A70
         beq   L07BC
L07B3    ldx   <u002B
         leax  <$14,x
         stx   <u002B
         bra   L079F
L07BC    ldd   <$12,x
         std   <u0034
         lda   $08,x
         sta   <u0031
         ldx   <u002B
         ldb   $08,x
         lda   $09,x
         ldy   <$12,x
         ldx   <u002D
         cmpa  #$41
         bne   L07EE
         sty   $02,x
         ldy   <u0034
         sty   ,x
         stb   $04,x
         lda   <u0031
         cmpa  $04,x
         bhi   L07E8
         sta   $04,x
L07E8    leax  $05,x
         stx   <u002D
         bra   L07B3
L07EE    pshs  a
         clra
         leay  d,y
         puls  a
         ldx   <u0034
         lda   <u0031
         pshs  b
         tfr   a,b
         clra
         leax  d,x
         tfr   b,a
         puls  b
         stx   <u0034
         cmpb  <u0031
         bcs   L080C
         ldb   <u0031
L080C    ldx   <u002D
         stb   $04,x
         ldx   <u0034
L0812    leax  -$01,x
         leay  -$01,y
         decb
         bne   L0812
         stx   <u0034
         ldx   <u002D
         sty   $02,x
         ldy   <u0034
         sty   ,x
         bra   L07E8
L0828    ldx   #$0000
         ldu   #$0000
         lda   <u0007
         os9   I$Seek
         ldy   <u000B
         tst   ,y
         beq   L0848
         ldy   <u000F
         tst   ,y
         bne   L0848
         leax  >L09A3,pcr
         lbsr  L0A5A
L0848    lbsr  L0B09
         bne   L0862
         leax  >L0A41,pcr
         lbsr  L0A5A
         lda   #$0D
         lbsr  L0C95
         lda   #$0A
         lbsr  L0C95
         clrb
         os9   F$Exit
L0862    ldx   <u001B
         lbsr  L0AA0
         ldx   #$0000
         stx   <u003D
         lbsr  L0B89
         clr   <u003A
L0871    lbsr  L0C72
         ldy   <u0019
         lda   ,y
         cmpa  #$31
         bne   L08A5
         lbsr  L0C2C
         bne   L08A5
         leax  >L09C7,pcr
         bsr   L088A
         bra   L08E2
L088A    lbsr  L0A5A
         ldx   <u0011
         leax  $01,x
         ldy   <u0009
         ldb   $08,y
L0896    lda   ,x+
         lbsr  L0C95
         decb
         bne   L0896
         rts
L089F    lbsr  L088A
         lbra  L0848
L08A5    ldy   <u0019
         lda   ,y
         cmpa  #$55
         beq   L08C6
         cmpa  #$44
         bne   L08BA
         ldx   <u003D
         bne   L08BA
         ldx   <u001F
         stx   <u003D
L08BA    lbsr  L0BEF
         beq   L0871
         leax  >L09F0,pcr
         lbra  L089F
L08C6    ldx   <u003D
         beq   L08CC
         stx   <u001F
L08CC    ldx   <u0015
         lda   #$31
         sta   ,x
         stx   <u003B
         ldd   <u0042
         subd  #$0001
         leax  d,x
         lda   #$0D
         sta   ,x
         lbsr  L0C83
L08E2    ldy   <u000F
         lda   ,y
         lbeq  L0848
         lbsr  L0B45
         lbeq  L0848
         ldx   #$0000
         stx   <u003D
         clr   <u003A
L08F9    lbsr  L0BEF
         beq   L0905
L08FE    leax  >L0A19,pcr
         lbra  L089F
L0905    lbsr  L0C72
         ldy   <u0019
         lda   ,y
         cmpa  #$55
         beq   L092F
         cmpa  #$44
         bne   L091D
         ldx   <u003D
         bne   L091D
         ldx   <u001F
         stx   <u003D
L091D    cmpa  #$32
         bne   L08F9
         lbsr  L0C2C
         bne   L08F9
         ldx   #$0000
         stx   <u003D
         clr   <u003A
         bra   L08F9
L092F    ldx   <u003D
         beq   L0935
         stx   <u001F
L0935    ldx   <u001D
         lbsr  L0AA0
         ldx   <u0017
         lda   #$32
         sta   ,x
         stx   <u003B
         ldd   <u0042
         subd  #$0001
         leax  d,x
         lda   #$0D
         sta   ,x
         lbsr  L0C83
         lbsr  L0B45
         lbeq  L0848
         clr   <u003A
L0959    lbsr  L0BEF
         lbne  L08FE
         lbsr  L0C72
         ldy   <u0019
         lda   ,y
         cmpa  #$55
         beq   L0972
         cmpa  #$44
         beq   L0972
         bra   L0959
L0972    lbra  L0935

L0975    fcc   "DESTINATION KEY FIELD NOT FOUND IN SOURCE DIC\"
L09A3    fcc   "NO SECONDARY RECORDS WILL BE COPIED\"
L09C7    fcc   "PRIMARY NOT COPIED, KEY ALREADY EXISTS: \"
L09F0    fcc   "PRIMARY NOT COPIED,  NO  ROOM FOR IT  : \"
L0A19    fcc   "SECONDARY NOT COPIED, NO ROOM FOR IT : \"
L0A41    fcc   "COPY OPERATION COMPLETED\"

L0A5A    lda   #$0A
L0A5C    lbsr  L0C95
         lda   #$0D
         lbsr  L0C95
L0A64    lda   ,x+
         cmpa  #$5C
         beq   L0A6F
         lbsr  L0C95
         bra   L0A64
L0A6F    rts
L0A70    stx   <u0034
L0A72    ldx   <u0034
         lda   ,x
         bne   L0A7B
         lda   #$01
         rts
L0A7B    ldy   <u002B
L0A7E    ldb   #$08
L0A80    lda   ,x+
         lbsr  L0BCD
L0A85    pshs  a
         lda   ,y+
         lbsr  L0BCD
         cmpa  ,s+
         bne   L0A98
         decb
         bne   L0A80
         ldx   <u0034
         lda   #$00
         rts
L0A98    ldx   <u0034
         leax  <$14,x
L0A9D    bra   L0A70
         rts
L0AA0    stx   <u0034
         ldx   <u0034
         ldb   $04,x
         ldy   ,x
         bne   L0AAC
         rts
L0AAC    ldx   $02,x
L0AAE    lda   ,y+
         sta   ,x+
         decb
         bne   L0AAE
         ldx   <u0034
         leax  $05,x
         bra   L0AA0
L0ABB    lda   <u0021
         ldb   <u0025
         mul
         std   <u0056
         lda   <u0022
         ldb   <u0026
         mul
         std   <u0058
         lda   <u0021
         ldb   <u0026
         mul
         addd  <u0057
         std   <u0057
         bcc   L0AD6
         inc   <u0056
L0AD6    lda   <u0022
         ldb   <u0025
         mul
         addd  <u0057
         std   <u0057
         bcc   L0AE3
         inc   <u0056
L0AE3    lda   <u0007
         ldx   <u0056
         ldu   <u0058
         os9   I$Seek
         lbcs  L0B02
         lda   <u0007
         ldx   <u0019
         ldy   <u0025
         os9   I$Read
         bcs   L0AFF
         lda   #$01
         rts
L0AFF    lda   #$00
         rts
L0B02    leax  >L05AB,pcr
         lbra  L05C6
L0B09    ldx   <u0038
         stx   <u0021
L0B0D    ldx   <u0021
         leax  $01,x
         cmpx  <u0023
         bne   L0B16
L0B15    rts
L0B16    clr   <u003A
         lbsr  L0BD8
         ldx   <u0021
         stx   <u0038
         bsr   L0ABB
         beq   L0B15
         ldy   <u0019
         lda   ,y
         cmpa  #$31
         bne   L0B0D
         ldx   <u0019
         ldy   <u0011
         ldd   <u0025
         std   <u002B
L0B35    ldb   ,x+
         stb   ,y+
         ldd   <u002B
         subd  #$0001
         std   <u002B
         bne   L0B35
         lda   #$01
         rts
L0B45    clr   <u003A
L0B47    lbsr  L0BD8
         lbne  L0B86
         lbsr  L0ABB
         beq   L0B86
         ldy   <u0019
         lda   ,y
         cmpa  #$55
         beq   L0B86
         tst   <u005B
         beq   L0B64
         cmpa  #$31
         beq   L0B86
L0B64    cmpa  #$32
         bne   L0B47
         lbsr  L0C06
         bne   L0B47
         ldd   <u0025
         std   <u002B
         ldx   <u0019
         ldy   <u0013
L0B76    ldb   ,x+
         stb   ,y+
         ldd   <u002B
         subd  #$0001
         std   <u002B
         bne   L0B76
         lda   #$02
         rts
L0B86    lda   #$00
         rts
L0B89    ldy   <u000D
         ldb   $08,y
         ldx   #$0000
         stx   <u001F
         ldx   <u0015
         leax  $01,x
         bsr   L0BB2
         lda   <u001F
         anda  <u0055
         sta   <u001F
         ldd   <u001F
         beq   L0BAC
L0BA3    std   <u001F
         subd  <u0040
         bhi   L0BA3
         beq   L0BAC
         rts
L0BAC    ldx   #$0001
         stx   <u001F
         rts
L0BB2    lda   ,x+
         bsr   L0BCD
         suba  #$20
         adda  <u001F
         sta   <u001F
         decb
         beq   L0BCC
         lda   ,x+
         bsr   L0BCD
         suba  #$20
         adda  <u0020
         sta   <u0020
         decb
         bne   L0BB2
L0BCC    rts
L0BCD    cmpa  #$61
         bcs   L0BD7
         cmpa  #$7A
         bhi   L0BD7
         suba  #$20
L0BD7    rts
L0BD8    inc   <u003A
         beq   L0BEC
         ldx   <u0021
         leax  $01,x
         cmpx  <u0023
         bne   L0BE7
         ldx   #$0001
L0BE7    stx   <u0021
         lda   #$00
         rts
L0BEC    lda   #$01
         rts
L0BEF    inc   <u003A
         beq   L0C03
         ldx   <u001F
         leax  $01,x
         cmpx  <u0040
         bne   L0BFE
         ldx   #$0001
L0BFE    stx   <u001F
         lda   #$00
         rts
L0C03    lda   #$01
         rts
L0C06    ldx   <u0019
         leax  $01,x
         ldy   <u0009
         lda   $08,y
         ldy   <u0011
         leay  $01,y
L0C14    ldb   ,x+
         exg   a,b
         lbsr  L0BCD
         pshs  a
         lda   ,y+
         lbsr  L0BCD
         exg   a,b
         cmpb  ,s+
         bne   L0C2B
         deca
         bne   L0C14
L0C2B    rts

L0C2C    ldx   <u0019
         leax  $01,x
         ldy   <u000D
         lda   $08,y
         ldy   <u0015
         leay  $01,y
         bra   L0C14
L0C3C    lda   <u001F
         ldb   <u0042
         mul
         std   <u0056
         lda   <u0020
         ldb   <u0043
         mul
         std   <u0058
         lda   <u001F
         ldb   <u0043
         mul
         addd  <u0057
         std   <u0057
         bcc   L0C57
         inc   <u0056
L0C57    lda   <u0020
         ldb   <u0042
         mul
         addd  <u0057
         std   <u0057
         bcc   L0C64
         inc   <u0056
L0C64    lda   <u0008
         ldx   <u0056
         ldu   <u0058
         os9   I$Seek
         lbcs  L0B02
         rts

L0C72    bsr   L0C3C
         ldy   <u0042
         ldx   <u0019
         lda   <u0008
         os9   I$Read
         lbcs  L0B02
         rts

L0C83    lbsr  L0C3C
         ldy   <u0042
         ldx   <u003B
         lda   <u0008
         os9   I$Write
         lbcs  L0B02
         rts

L0C95    pshs  x,b
         ldx   <u0002
         sta   ,x
         ldy   #$0001
         lda   #$01
         os9   I$Write
         puls  pc,x,b
         emod
eom      equ   *
