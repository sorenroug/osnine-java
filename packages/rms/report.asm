         nam   report
         ttl   Record Management System - report

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
u000A    rmb   2
u000C    rmb   2
u000E    rmb   2
u0010    rmb   2
u0012    rmb   2
u0014    rmb   1
u0015    rmb   1
u0016    rmb   2
u0018    rmb   1
u0019    rmb   1
u001A    rmb   2
u001C    rmb   2
u001E    rmb   1
u001F    rmb   1
u0020    rmb   1
u0021    rmb   1
u0022    rmb   1
u0023    rmb   1
u0024    rmb   10
u002E    rmb   1
u002F    rmb   4
u0033    rmb   2
u0035    rmb   1
u0036    rmb   16
u0046    rmb   2
u0048    rmb   1
u0049    rmb   1
u004A    rmb   2
u004C    rmb   1
u004D    rmb   1
u004E    rmb   2
u0050    rmb   2
u0052    rmb   2
u0054    rmb   8
u005C    rmb   2
u005E    rmb   2
u0060    rmb   2
u0062    rmb   2
u0064    rmb   2
u0066    rmb   2
u0068    rmb   2
u006A    rmb   2
u006C    rmb   2
u006E    rmb   2
u0070    rmb   2
u0072    rmb   2
u0074    rmb   2
u0076    rmb   1
u0077    rmb   1
u0078    rmb   2
u007A    rmb   2
u007C    rmb   2
u007E    rmb   2
u0080    rmb   8
u0088    rmb   2
u008A    rmb   2
u008C    rmb   2
u008E    rmb   2
u0090    rmb   2
u0092    rmb   2
u0094    rmb   2
u0096    rmb   1
u0097    rmb   2
u0099    rmb   2
u009B    rmb   1
u009C    rmb   2
u009E    rmb   2
u00A0    rmb   1
u00A1    rmb   1
u00A2    rmb   2
u00A4    rmb   2
u00A6    rmb   2
u00A8    rmb   2
u00AA    rmb   1
u00AB    rmb   1
u00AC    rmb   13
u00B9    rmb   1
u00BA    rmb   1
u00BB    rmb   69
u0100    rmb   9744
size     equ   .
name     equ   *
         fcs   /report/
         fcb   $01

start    equ   *
         leau  >u0100,u
         stu   <u0000
         stx   <u0004
         tfr   x,d
         subd  #$0096
         std   <u0002
         clr   <u0036
         clr   <u00B9
         clr   <u00BA
         clr   <u00BB
         ldd   #$0000
         std   <u0033
         std   <u004C
         std   <u004E
         std   <u005C
         std   <u005E
         std   <u0060
         std   <u0062
         std   <u0064
         std   <u0066
         std   <u0068
         std   <u0072
         std   <u0088
         std   <u008A
         std   <u008C
         std   <u0090
         ldd   #$0042
         std   <u0046
         ldd   #$003C
         std   <u0048
         ldd   #$0001
         std   <u004A
         ldd   #$2020
         std   <u0074
         std   <u0076
         std   <u0092
         std   <u0094
         std   <u0097
         std   <u0099
         std   <u009C
         std   <u009E
         std   <u0078
         std   <u007A
         std   <u007C
         std   <u007E
         lda   #$30
         sta   <u0096
         sta   <u009B
         sta   <u00A0
         inca
         sta   <u0077
         tfr   dp,a
         ldb   #$72
         std   <u00A4
         ldb   #$88
         std   <u00A6
         ldx   <u0000
         stx   <u001E
         lbsr  L01A7
         stx   <u0020
         lda   #$2E
         ldb   #$52
         std   ,x
         lda   #$4D
         ldb   #$53
         std   $02,x
         clr   $04,x
         ldx   <u001E
         lda   #$01
         os9   I$Open
         lbcs  L0642
         sta   <u0006
         tfr   dp,a
         ldb   #$15
         tfr   d,x
         ldy   #$0005
         lda   <u0006
         os9   I$Read
         lbcs  L0654
         lda   <u0015
         cmpa  #$55
         lbne  L0654
         lda   #$FF
         ldb   <u0016
         bmi   L00D8
         lda   #$7F
         bitb  #$40
         bne   L00D8
         lda   #$3F
L00D8    sta   <u00A1
         ldd   <u0000
         std   <u000A
         addd  #$03E8
         std   <u000C
         addd  #$03E8
         std   <u000E
         addd  <u0018
         std   <u0010
         addd  <u0018
         std   <u0012
         addd  <u0018
         std   <u00A2
         addd  #$0101
         std   <u00A8
         std   <u0000
         ldx   <u0020
         lda   #$2E
         ldb   #$44
         std   ,x
         lda   #$49
         ldb   #$43
         std   $02,x
         clr   $04,x
         ldx   <u001E
         lda   #$01
         os9   I$Open
         lbcs  L0648
         sta   <u0007
         ldx   <u0000
         lbsr  L01A7
         lbne  L0660
         lda   #$2E
         ldb   #$52
         std   ,x
         lda   #$45
         ldb   #$50
         std   $02,x
         clr   $04,x
         ldx   <u0000
         lda   #$01
         os9   I$Open
         lbcs  L0660
         sta   <u0009
         leas  -$06,s
         leax  ,s
         os9   F$Time
         bcs   L0175
         ldb   #$78
         tfr   dp,a
         tfr   d,y
         lda   #$2D
         sta   $02,y
         sta   $05,y
         lda   ,x
         bsr   L0167
         std   $06,y
         lda   $01,x
         bsr   L0167
         std   $03,y
         lda   $02,x
         bsr   L0167
         std   ,y
         leas  $06,s
         bra   L0190
L0167    ldb   #$30
L0169    suba  #$0A
         bcs   L0170
         incb
         bra   L0169
L0170    adda  #$3A
         exg   a,b
         rts
L0175    leas  $06,s
         ldb   #$78
         tfr   dp,a
         tfr   d,x
         ldy   <u0004
         ldb   #$08
L0182    lda   ,y+
         cmpa  #$20
         bls   L018D
         sta   ,x+
         decb
         bne   L0182
L018D    sty   <u0004
L0190    ldx   <u000A
         lda   #$01
         sta   <u0036
         bsr   L01DE
         ldx   <u000A
         lda   ,x
         lbeq  L065A
         ldx   <u000C
         bsr   L01DE
         lbra  L06A2
L01A7    ldy   <u0004
L01AA    lda   ,y
         cmpa  #$0D
         bne   L01B3
         lda   #$01
         rts
L01B3    cmpa  #$20
         beq   L01BB
         cmpa  #$2C
         bne   L01BF
L01BB    leay  $01,y
         bra   L01AA
L01BF    ldb   #$50
L01C1    lda   ,y
         cmpa  #$0D
         beq   L01D8
         cmpa  #$2C
         beq   L01D6
         cmpa  #$20
         bls   L01D6
         leay  $01,y
         sta   ,x+
         decb
         bne   L01C1
L01D6    leay  $01,y
L01D8    sty   <u0004
         lda   #$00
         rts
L01DE    stx   <u001C
         clr   ,x
         stx   <u001A
L01E4    lbsr  L039F
         lbne  L0382
         cmpa  #$20
         beq   L01E4
         cmpa  #$0D
         bne   L01F7
         inc   <u0036
         bra   L01E4
L01F7    cmpa  #$22
         lbne  L0666
L01FD    lbsr  L039F
         lbne  L0666
         cmpa  #$22
         bne   L01FD
         clr   <u001E
L020A    lda   <u001E
         cmpa  #$31
         lbgt  L066C
L0212    lbsr  L039F
         lbne  L0382
         cmpa  #$20
         beq   L0212
         cmpa  #$3B
         beq   L0212
         cmpa  #$0D
         bne   L0229
         inc   <u0036
         bra   L0212
L0229    cmpa  #$24
         lbeq  L0382
         ldx   <u001A
         stx   <u001F
         clr   <u0021
         clr   $01,x
         clr   $02,x
         clr   $03,x
         clr   $04,x
         clr   $05,x
         clr   $06,x
         clr   $07,x
L0243    ldx   <u001F
         lbsr  L100B
         sta   ,x+
         stx   <u001F
         inc   <u0021
         lda   <u0021
         cmpa  #$08
         beq   L026B
         lbsr  L039F
L0257    lbne  L0672
         cmpa  #$20
         beq   L027E
         cmpa  #$2C
         beq   L027E
         cmpa  #$0D
         bne   L0243
         inc   <u0036
         bra   L027E
L026B    lbsr  L039F
         bne   L0257
         cmpa  #$20
         beq   L027E
         cmpa  #$2C
         beq   L027E
         cmpa  #$0D
         bne   L026B
         inc   <u0036
L027E    clr   <u001F
L0280    lbsr  L039F
         bne   L0257
         cmpa  #$20
         beq   L0280
         cmpa  #$3B
         beq   L0280
         cmpa  #$0D
         bne   L0295
         inc   <u0036
         bra   L0280
L0295    cmpa  #$30
         lblt  L0678
         cmpa  #$39
         lbgt  L0678
         anda  #$0F
         sta   <u0020
         lda   <u001F
         cmpa  #$19
         lbgt  L0678
         ldb   #$0A
         mul
         addb  <u0020
         stb   <u001F
         lbsr  L039F
         lbne  L0678
         cmpa  #$2C
         beq   L02CB
         cmpa  #$20
         beq   L02CB
         cmpa  #$0D
         bne   L0295
         inc   <u0036
         bra   L02CB
L02CB    lda   <u001F
         lbeq  L0678
         ldx   <u001A
         sta   $08,x
L02D5    lbsr  L039F
         bne   L02FD
         lbsr  L100B
         cmpa  #$2C
         beq   L02D5
         cmpa  #$20
         beq   L02D5
         cmpa  #$0D
         bne   L02ED
         inc   <u0036
         bra   L02D5
L02ED    cmpa  #$44
         beq   L0300
         cmpa  #$4D
         beq   L030C
         cmpa  #$41
         beq   L031B
         cmpa  #$4E
         beq   L031B
L02FD    lbra  L067E
L0300    ldx   <u001A
         ldb   $08,x
         cmpb  #$08
         lbne  L0690
         bra   L031B
L030C    ldx   <u001A
         ldb   $08,x
         cmpb  #$03
         bgt   L031B
         leax  >L05BD,pcr
         lbra  L05EA
L031B    ldx   <u001A
         sta   $09,x
         lbsr  L039F
         lbne  L067E
L0326    lbsr  L039F
         lbne  L0684
         cmpa  #$0D
         bne   L0335
         inc   <u0036
         bra   L0326
L0335    cmpa  #$20
         beq   L0326
         cmpa  #$2C
         beq   L0326
         cmpa  #$22
         lbne  L0684
L0343    lbsr  L039F
         lbne  L0684
         cmpa  #$0D
         bne   L0352
         inc   <u0036
         bra   L0343
L0352    cmpa  #$22
         bne   L0343
         ldx   <u0000
         cmpx  <u0002
         lbcc  L068A
L035E    lbsr  L039F
         beq   L036A
         leax  >L054C,pcr
         lbra  L05EA
L036A    cmpa  #$0D
         bne   L0372
         inc   <u0036
         bra   L035E
L0372    cmpa  #$3B
         bne   L035E
         ldx   <u001A
         leax  <$14,x
         stx   <u001A
         inc   <u001E
         lbra  L020A
L0382    ldx   <u001A
         clr   ,x
         ldx   <u001C
         ldy   #$0000
L038C    tst   ,x
         beq   L0399
         lda   $08,x
         leay  a,y
         leax  <$14,x
         bra   L038C
L0399    leay  $02,y
         cmpy  <u0018
         rts
L039F    pshs  x
         tst   <u00B9
         bne   L03B9
         ldy   #$0001
         ldx   <u0012
         lda   <u0007
         os9   I$Read
         bcs   L03B9
         ldx   <u0012
         lda   ,x
         clrb
         puls  pc,x
L03B9    lda   #$01
         sta   <u00B9
         puls  pc,x

L03BF    fcc   "INVALID FILE NAME\"
L03D1    fcc   "CAN'T OPEN .RMS FILE\"
L03E6    fcc   "CAN'T OPEN .DIC FILE\"
L03FB    fcc   "RMS FILE IO ERROR\"
L040D    fcc   "INVALID RMS FILE PREFIX\"
L0425    fcc   "NO PRIMARY DICTIONARY\"
L043B    fcc   "CAN'T OPEN REPORT SPEC FILE\"
L0457    fcc   "INVALID TITLE IN DICTIONARY\"
L0473    fcc   "TOO MANY FIELDS IN DICTIONARY\"
L0491    fcc   "INVALID FIELD NAME IN DICTIONARY\"
L04B2    fcc   "INVALID FIELD LENGTH IN DICTIONARY\"
L04D5    fcc   "INVALID TYPE CODE IN DICTIONARY\"
L04F5    fcc   "INVALID PROMPT IN DICTIONARY\"
L0512    fcc   "INSUFFICIENT MEMORY\"
L0526    fcc   "DATE FIELD NOT LENGTH 8 IN DICTIONARY\"
L054C    fcc   "MISSING ; IN DICTIONARY\"
L0564    fcc   "TOTAL FIELD LENGTHS OVER RECORD LENGTH\"
L058B    fcc   "KEY FIELD DIFFERENT IN PRIMARY AND SECONDARY DICT\"
L05BD    fcc   "MONEY FIELD LESS THAN LENGTH 4 IN DICTIONARY\"

L05EA    lda   #$0A
L05EC    bsr   L0639
L05EE    lda   ,x+
         cmpa  #$5C
         beq   L05F8
         bsr   L0639
         bra   L05EE
L05F8    lda   <u0036
         beq   L062D
         leax  >L0608,pcr
L0600    lda   ,x+
L0602    beq   L060F
         bsr   L0639
         bra   L0600

L0608    fcc   " LINE "
         fcb   0

L060F    lda   <u0036
         clrb
L0612    cmpa  #$0A
         blt   L061B
L0616    suba  #$0A
         incb
         bra   L0612
L061B    sta   <u001E
         stb   <u001F
         lda   <u001F
         beq   L0627
L0623    ora   #$30
         bsr   L0639
L0627    lda   <u001E
         ora   #$30
         bsr   L0639
L062D    lda   #$0A
         bsr   L0639
         lda   #$0D
         bsr   L0639
         clrb
         os9   F$Exit
L0639    lbra  L145C
         leax  >L03BF,pcr
         bra   L05EA
L0642    leax  >L03D1,pcr
         bra   L05EA
L0648    leax  >L03E6,pcr
         bra   L05EA
         leax  >L03FB,pcr
         bra   L05EA
L0654    leax  >L040D,pcr
         bra   L05EA
L065A    leax  >L0425,pcr
L065E    bra   L05EA
L0660    leax  >L043B,pcr
         bra   L065E
L0666    leax  >L0457,pcr
         bra   L065E
L066C    leax  >L0473,pcr
         bra   L065E
L0672    leax  >L0491,pcr
         bra   L065E
L0678    leax  >L04B2,pcr
         bra   L065E
L067E    leax  >L04D5,pcr
         bra   L065E
L0684    leax  >L04F5,pcr
         bra   L065E
L068A    leax  >L0512,pcr
         bra   L065E
L0690    leax  >L0526,pcr
         bra   L065E
         leax  >L0564,pcr
         bra   L065E
L069C    leax  >L058B,pcr
         bra   L065E
L06A2    ldx   <u000A
         ldy   <u000C
         lda   ,y
         beq   L06C4
         lda   #$0A
L06AD    ldb   ,x+
         exg   a,b
         lbsr  L100B
         pshs  a
         lda   ,y+
         lbsr  L100B
         exg   a,b
         cmpb  ,s+
         bne   L069C
         deca
         bne   L06AD
L06C4    ldx   <u000E
         leax  $01,x
         stx   <u001E
         ldx   <u000A
         bsr   L06D0
         bra   L06E6
L06D0    lda   ,x
         beq   L06E5
         ldd   <u001E
         std   <$12,x
         clra
         ldb   $08,x
         addd  <u001E
         std   <u001E
         leax  <$14,x
         bra   L06D0
L06E5    rts
L06E6    ldx   <u0010
         leax  $01,x
         stx   <u001E
         ldx   <u000C
         bsr   L06D0
         ldd   #$2020
         ldx   <u000E
L06F5    std   ,x++
         cmpx  <u0012
         bne   L06F5
         clr   <u0008
         lda   #$01
         sta   <u0036
L0701    lbsr  L0C0E
         lbne  L0EC8
         lbsr  L100B
         cmpa  #$20
         beq   L0701
         cmpa  #$3B
         beq   L0701
         cmpa  #$2C
         beq   L0701
         cmpa  #$0D
         bne   L071F
         inc   <u0036
         bra   L0701
L071F    cmpa  #$54
         lbeq  L09A6
         cmpa  #$57
         lbeq  L09AA
         cmpa  #$58
         lbeq  L0768
         cmpa  #$49
         lbeq  L084D
         cmpa  #$45
         lbeq  L084D
         cmpa  #$50
         lbeq  L09AE
         cmpa  #$53
         lbeq  L09B2
         cmpa  #$48
         lbeq  L09B6
         cmpa  #$47
         lbeq  L09BA
         cmpa  #$42
         lbeq  L07C6
         cmpa  #$4C
         lbeq  L07EA
         leax  >L0C5C,pcr
         lbra  L05EA
L0768    lbsr  L0C0E
         bne   L07BA
         cmpa  #$20
         beq   L0768
         sta   <u0021
         lda   <u0008
         beq   L077E
         leax  >L0C80,pcr
         lbra  L05EA
L077E    ldx   <u0000
         stx   <u001E
         lda   <u0021
         bra   L078B
L0786    lbsr  L0C0E
         bne   L07A1
L078B    ldx   <u001E
         cmpa  #$20
         beq   L07A1
         cmpa  #$0D
         beq   L079F
         cmpa  #$3B
         beq   L07A1
         sta   ,x+
         stx   <u001E
         bra   L0786
L079F    inc   <u0036
L07A1    ldx   <u001E
         lda   #$2E
         ldb   #$4E
         std   ,x
         lda   #$44
         ldb   #$58
         std   $02,x
         clr   $04,x
         ldx   <u0000
         lda   #$01
         os9   I$Open
         bcc   L07C1
L07BA    leax  >L0CA2,pcr
         lbra  L05EA
L07C1    sta   <u0008
         lbra  L0701
L07C6    lbsr  L0C0E
         beq   L07D2
L07CB    leax  >L0CC7,pcr
         lbra  L05EA
L07D2    cmpa  #$20
         beq   L07C6
         lbsr  L100B
         cmpa  #$50
         beq   L07E5
         cmpa  #$53
         bne   L07CB
         sta   <u004D
         bra   L07E7
L07E5    sta   <u004C
L07E7    lbra  L0701
L07EA    bsr   L07F9
         ldx   <u001E
         stx   <u0046
         bsr   L07F9
         ldx   <u001E
         stx   <u0048
         lbra  L0701
L07F9    ldx   #$0000
         stx   <u001E
L07FE    lbsr  L0C0E
         beq   L080A
L0803    leax  >L0CE5,pcr
         lbra  L05EA
L080A    cmpa  #$20
         beq   L07FE
         cmpa  #$2C
         beq   L07FE
L0812    cmpa  #$30
         blt   L0803
         cmpa  #$39
         bgt   L0803
         anda  #$0F
         sta   <u0021
         clr   <u0020
         ldd   <u001E
         beq   L0830
         addd  <u001E
         addd  <u001E
         addd  <u001E
         addd  <u001E
         std   <u001E
         addd  <u001E
L0830    addd  <u0020
         std   <u001E
         lbsr  L0C0E
         bne   L0803
         cmpa  #$0D
         beq   L084A
         cmpa  #$2C
         beq   L0849
         cmpa  #$20
         beq   L0849
         cmpa  #$3B
         bne   L0812
L0849    rts
L084A    inc   <u0036
         rts
L084D    sta   <u0054
         lbsr  L08E4
         lbne  L0913
         lda   <u001E
L0858    cmpa  #$20
         beq   L0862
         cmpa  #$0D
         bne   L086E
         inc   <u0036
L0862    lbsr  L0C0E
         beq   L0858
L0867    leax  >L0D25,pcr
         lbra  L05EA
L086E    ldb   #$29
         cmpa  #$28
         beq   L087A
         ldb   #$5D
         cmpa  #$5B
         bne   L0867
L087A    sta   <u001E
         stb   <u0020
         tfr   dp,a
         ldb   #$4E
         tfr   d,x
L0884    ldd   ,x
         beq   L088C
         ldx   ,x
         bra   L0884
L088C    ldd   <u0000
         std   ,x
         ldx   <u0000
         clr   ,x
         clr   $01,x
         lda   <u0054
         sta   $02,x
         lda   <u001E
         sta   $03,x
         lda   <u006C
         sta   $06,x
         ldd   <u006A
         std   $04,x
         leax  $07,x
         stx   <u001E
L08AA    lbsr  L0C0E
         beq   L08B6
L08AF    leax  >L0D43,pcr
         lbra  L05EA
L08B6    ldx   <u001E
         cmpx  <u0002
         blt   L08C3
L08BC    leax  >L0D69,pcr
         lbra  L05EA
L08C3    cmpa  #$0D
         bne   L08CB
         inc   <u0036
         bra   L08D9
L08CB    sta   ,x
         cmpa  <u0020
         beq   L08DB
         leax  $01,x
         stx   <u001E
         cmpa  #$3B
         beq   L08AF
L08D9    bra   L08AA
L08DB    clr   ,x
         leax  $01,x
         stx   <u0000
         lbra  L0701
L08E4    ldx   #$0000
         stx   <u006A
         stx   <u006C
         stx   <u006E
         stx   <u0070
         tfr   dp,a
         ldb   #$6A
         tfr   d,x
         stx   <u001F
L08F7    lbsr  L0C0E
         bne   L095D
         sta   <u001E
         cmpa  #$20
         beq   L08F7
         cmpa  #$2C
         beq   L08F7
         cmpa  #$0D
         bne   L091A
         inc   <u0036
         bra   L08F7
L090E    lbsr  L0C0E
         beq   L091A
L0913    leax  >L0D03,pcr
         lbra  L05EA
L091A    lbsr  L100B
         sta   <u001E
         cmpa  #$20
         beq   L095D
         cmpa  #$0D
         beq   L095B
         cmpa  #$5B
         beq   L095D
         cmpa  #$22
         beq   L095D
         cmpa  #$24
         beq   L095D
         cmpa  #$23
         beq   L095D
         cmpa  #$25
         beq   L095D
         cmpa  #$28
         beq   L095D
         cmpa  #$40
         beq   L095D
         cmpa  #$3A
         beq   L095D
         cmpa  #$2C
         beq   L095D
         cmpa  #$3B
         beq   L095D
         ldx   <u001F
         cmpx  <u00A4
         beq   L0913
         sta   ,x+
         stx   <u001F
         bra   L090E
L095B    inc   <u0036
L095D    lda   <u006A
         bne   L0964
         lda   #$01
         rts
L0964    ldx   <u000A
         bsr   L097D
         bne   L0973
         lda   #$01
L096C    sta   <u006C
         stx   <u006A
         lda   #$00
         rts
L0973    ldx   <u000C
         bsr   L097D
         bne   L0913
         lda   #$02
         bra   L096C
L097D    lda   ,x
         bne   L0984
         lda   #$01
         rts
L0984    ldd   <u006A
         cmpd  ,x
         bne   L09A0
         ldd   $02,x
         cmpd  <u006C
         bne   L09A0
         ldd   $04,x
         cmpd  <u006E
         bne   L09A0
         ldd   $06,x
         cmpd  <u0070
         beq   L09A5
L09A0    leax  <$14,x
         bra   L097D
L09A5    rts
L09A6    ldb   #$5C
         bra   L09BC
L09AA    ldb   #$5E
         bra   L09BC
L09AE    ldb   #$60
         bra   L09BC
L09B2    ldb   #$62
         bra   L09BC
L09B6    ldb   #$64
         bra   L09BC
L09BA    ldb   #$66
L09BC    tfr   dp,a
         tfr   d,x
L09C0    ldd   ,x
         beq   L09C8
         ldx   ,x
         bra   L09C0
L09C8    ldd   <u0000
         std   ,x
         ldx   <u0000
         clr   ,x+
         clr   ,x+
         stx   <u0072
         clr   ,x
         clr   $01,x
         leax  $02,x
         cmpx  <u0002
         lbcc  L08BC
         stx   <u0000
L09E2    lbsr  L08E4
         lbeq  L0AA9
         lda   <u001E
         cmpa  #$24
         lbeq  L0B9E
         cmpa  #$22
         beq   L0A03
         cmpa  #$3B
         bne   L09FC
         lbra  L0701
L09FC    leax  >L0D88,pcr
         lbra  L05EA
L0A03    ldx   <u0072
         ldd   <u0000
         std   ,x
         ldx   <u0000
         stx   <u0072
         clr   ,x
         clr   $01,x
         clr   $06,x
         addd  #$0007
         std   $02,x
         std   <u001E
         clr   <u0020
L0A1C    lbsr  L0C0E
         bne   L09FC
         cmpa  #$0D
         beq   L09FC
         cmpa  #$22
         beq   L0A38
         inc   <u0020
         ldx   <u001E
         sta   ,x+
         stx   <u001E
         cmpx  <u0002
         blt   L0A1C
         lbra  L08BC
L0A38    ldx   <u001E
         stx   <u0000
         ldx   <u0072
         lda   <u0020
         sta   $04,x
L0A42    lbsr  L0C0E
         beq   L0A4E
L0A47    leax  >L0DAA,pcr
         lbra  L05EA
L0A4E    cmpa  #$20
         beq   L0A42
         cmpa  #$40
         bne   L0A47
         clr   <u001E
L0A58    lbsr  L0C0E
         beq   L0A64
L0A5D    leax  >L0DC3,pcr
         lbra  L05EA
L0A64    cmpa  #$20
         beq   L0A98
         cmpa  #$0D
         beq   L0A96
         cmpa  #$2C
         beq   L0A98
         cmpa  #$3B
         beq   L0A98
         cmpa  #$30
         blt   L0A5D
         cmpa  #$39
         bgt   L0A5D
         anda  #$0F
         sta   <u001F
         lda   <u001E
         beq   L0A90
         adda  <u001E
         adda  <u001E
         adda  <u001E
         adda  <u001E
         sta   <u001E
         adda  <u001E
L0A90    adda  <u001F
         sta   <u001E
         bra   L0A58
L0A96    inc   <u0036
L0A98    ldx   <u0072
         ldb   <u001E
         beq   L0A5D
         stb   $05,x
         cmpa  #$3B
         lbeq  L0701
         lbra  L09E2
L0AA9    lda   <u001E
         cmpa  #$23
         beq   L0AE3
         cmpa  #$25
         beq   L0AE3
         ldx   <u0072
         ldd   <u0000
         std   ,x
         ldx   <u0000
         stx   <u0072
         clr   ,x
         clr   $01,x
         clr   $06,x
         leax  $07,x
         cmpx  <u0002
         lbgt  L08BC
         stx   <u0000
         ldx   <u006A
         lda   $08,x
         sta   <u001F
         ldd   <$12,x
         ldx   <u0072
         std   $02,x
         lda   <u001F
         sta   $04,x
         lda   <u001E
         lbra  L0A4E
L0AE3    tfr   dp,a
         ldb   #$68
         tfr   d,x
L0AE9    ldd   ,x
         beq   L0AF1
         ldx   ,x
         bra   L0AE9
L0AF1    ldd   <u0000
         std   ,x
         ldx   <u0000
         clr   ,x
         clr   $01,x
         lda   <u001E
         sta   <u0024
         sta   $02,x
         ldd   <u006A
         std   $03,x
         lda   <u006C
         sta   $05,x
         ldx   <u006A
         lda   $09,x
         cmpa  #$4E
         beq   L0B1C
         cmpa  #$4D
         beq   L0B1C
         leax  >L0DE8,pcr
         lbra  L05EA
L0B1C    clr   <u001F
L0B1E    lbsr  L0C0E
         beq   L0B2A
L0B23    leax  >L0E12,pcr
         lbra  L05EA
L0B2A    sta   <u001E
         cmpa  #$30
         blt   L0B4E
         cmpa  #$39
         bgt   L0B4E
         anda  #$0F
         sta   <u0020
         lda   <u001F
         beq   L0B48
         adda  <u001F
         adda  <u001F
         adda  <u001F
         adda  <u001F
         sta   <u001F
         adda  <u001F
L0B48    adda  <u0020
         sta   <u001F
         bra   L0B1E
L0B4E    lda   <u001F
         ldx   <u006A
         cmpa  $08,x
         blt   L0B23
         ldx   <u0000
         sta   $06,x
         leax  $07,x
         stx   <u0020
         ldb   #$20
L0B60    stb   ,x+
         deca
         bne   L0B60
         cmpx  <u0002
         lbcc  L08BC
         stx   <u0000
         ldx   <u0072
         ldd   <u0000
         std   ,x
         ldx   <u0000
         stx   <u0072
         clr   ,x
         clr   $01,x
         clr   $06,x
         lda   <u0024
         cmpa  #$25
         bne   L0B87
         lda   #$01
         sta   $06,x
L0B87    ldd   <u0020
         std   $02,x
         lda   <u001F
         sta   $04,x
         leax  $07,x
         stx   <u0000
         cmpx  <u0002
         lbcc  L08BC
         lda   <u001E
         lbra  L0A4E
L0B9E    lbsr  L0C0E
         beq   L0BAA
L0BA3    leax  >L0E3C,pcr
         lbra  L05EA
L0BAA    lbsr  L100B
         cmpa  #$50
         bne   L0BBB
         tfr   dp,a
         ldb   #$74
         tfr   d,x
         lda   #$04
         bra   L0BC7
L0BBB    cmpa  #$44
         bne   L0BF0
         tfr   dp,a
         ldb   #$78
         tfr   d,x
         lda   #$08
L0BC7    stx   <u001E
         sta   <u0020
         ldx   <u0072
         ldd   <u0000
         std   ,x
         ldx   <u0000
         stx   <u0072
         clr   ,x
         clr   $01,x
         clr   $06,x
         ldd   <u001E
         std   $02,x
         lda   <u0020
         sta   $04,x
         leax  $07,x
         stx   <u0000
         cmpx  <u0002
         lbgt  L08BC
         lbra  L0A42
L0BF0    cmpa  #$54
         bne   L0BF8
         ldb   #$97
         bra   L0C06
L0BF8    cmpa  #$53
         bne   L0C00
         ldb   #$9C
         bra   L0C06
L0C00    cmpa  #$47
         bne   L0BA3
         ldb   #$92
L0C06    tfr   dp,a
         tfr   d,x
         lda   #$05
         bra   L0BC7
L0C0E    pshs  x
         tst   <u00BA
         bne   L0C28
         ldy   #$0001
         ldx   <u0012
         lda   <u0009
         os9   I$Read
         bcs   L0C28
         ldx   <u0012
         lda   ,x
         clrb
         puls  pc,x
L0C28    lda   #$01
         sta   <u00BA
         puls  pc,x

L0C2E    fcc   "MISSING REPORT FILE NAME\"
L0C47    fcc   "CAN'T OPEN .REP FILE\"
L0C5C    fcc   "INVALID COMMAND CODE IN REPORT SPEC\"
L0C80    fcc   "MULTIPLE X COMMAND IN REPORT SPEC\"
L0CA2    fcc   "CAN'T OPEN INDEX FILE IN REPORT SPEC\"
L0CC7    fcc   "MISSING P OR S IN REPORT SPEC\"
L0CE5    fcc   "INVALID NUMBER IN REPORT SPEC\"
L0D03    fcc   "INVALID FIELD NAME IN REPORT SPEC\"
L0D25    fcc   "MISSING ] OR ) IN REPORT SPEC\"
L0D43    fcc   "INVALID LIST OR BOUNDS IN REPORT SPEC\"
L0D69    fcc   "MEMORY OVERFLOW IN REPORT SPEC\"
L0D88    fcc   "INVALID PRINT ITEM IN REPORT SPEC\"
L0DAA    fcc   "MISSING @ IN REPORT SPEC\"
L0DC3    fcc   "INVALID COLUMN NUMBER IN REPORT SPEC\"
L0DE8    fcc   "TOTAL OF NON NUMERIC FIELD IN REPORT SPEC\"
L0E12    fcc   "LENGTH TOO SHORT FOR TOTAL IN REPORT SPEC\"
L0E3C    fcc   "INVALID $ TYPE PRINT ELEMENT IN REPORT SPEC\"
L0E68    fcc   "LENGTH OF TOTAL FIELD TOO SHORT TO HOLD TOTAL\"
L0E96    fcc   "INDEX FILE CONTAINS A KEY THAT IS NOT IN THE FILE\"

L0EC8    clr   <u0036
         lbra  L10C2
L0ECD    lda   <u0008
         bne   L0F0C
         ldx   <u0033
L0ED3    stx   <u0014
L0ED5    ldx   <u0014
         leax  $01,x
         cmpx  <u0016
         bne   L0EDE
L0EDD    rts
L0EDE    clr   <u0035
         lbsr  L1016
L0EE3    ldx   <u0014
L0EE5    stx   <u0033
         lbsr  L105E
         ldy   <u0012
         lda   ,y
         cmpa  #$31
         bne   L0ED5
L0EF3    ldx   <u0012
         ldy   <u000E
L0EF8    ldd   <u0018
         std   <u001E
L0EFC    ldb   ,x+
         stb   ,y+
         ldd   <u001E
         subd  #$0001
L0F05    std   <u001E
L0F07    bne   L0EFC
         lda   #$01
         rts
L0F0C    ldy   <u000A
         lda   $08,y
         sta   <u001E
         ldx   <u000E
         leax  $01,x
         stx   <u001F
L0F19    bsr   L0F6C
         beq   L0F20
         lda   #$00
         rts
L0F20    cmpa  #$0D
         beq   L0F38
         ldx   <u001F
         sta   ,x+
         stx   <u001F
         dec   <u001E
         bne   L0F19
L0F2E    bsr   L0F6C
         bne   L0F42
         cmpa  #$0D
         bne   L0F2E
         bra   L0F42
L0F38    lda   #$20
         ldx   <u001F
L0F3C    sta   ,x+
         dec   <u001E
         bne   L0F3C
L0F42    clr   <u0035
         lda   #$01
         sta   <u002E
         lbsr  L0FC8
L0F4B    lbsr  L105E
         lbsr  L102D
         beq   L0F6A
         ldy   <u0012
         lda   ,y
         cmpa  #$55
         bne   L0F63
L0F5C    leax  >L0E96,pcr
         lbra  L05EA
L0F63    lbsr  L1016
         bne   L0F5C
         bra   L0F4B
L0F6A    bra   L0EF3
L0F6C    tst   <u00BB
         bne   L0F83
         lda   <u0008
         ldx   <u0002
         ldy   #$0001
         os9   I$Read
         bcs   L0F83
         ldx   <u0002
         lda   ,x
         clrb
         rts
L0F83    lda   #$01
         sta   <u00BB
         rts
L0F88    clr   <u0035
         lda   #$02
         sta   <u002E
L0F8E    lbsr  L1016
         lbne  L0FC5
         lbsr  L105E
         ldy   <u0012
         lda   ,y
         cmpa  #$55
         lbeq  L0FC5
         cmpa  #$32
         bne   L0F8E
         lbsr  L1038
         bne   L0F8E
         ldd   <u0018
         std   <u001E
         ldx   <u0012
         ldy   <u0010
L0FB5    ldb   ,x+
         stb   ,y+
         ldd   <u001E
         subd  #$0001
         std   <u001E
         bne   L0FB5
         lda   #$02
         rts
L0FC5    lda   #$00
         rts
L0FC8    ldx   <u000A
         ldb   $08,x
         ldx   #$0000
         stx   <u0014
         ldx   <u000E
         leax  $01,x
         bsr   L0FF0
         lda   <u0014
         anda  <u00A1
         sta   <u0014
         ldd   <u0014
         beq   L0FEA
L0FE1    std   <u0014
         subd  <u0016
         bhi   L0FE1
         beq   L0FEA
         rts
L0FEA    ldx   #$0001
         stx   <u0014
         rts
L0FF0    lda   ,x+
         bsr   L100B
         suba  #$20
         adda  <u0014
         sta   <u0014
         decb
         beq   L100A
         lda   ,x+
         bsr   L100B
         suba  #$20
         adda  <u0015
         sta   <u0015
         decb
         bne   L0FF0
L100A    rts
L100B    cmpa  #$61
         bcs   L1015
         cmpa  #$7A
         bhi   L1015
         suba  #$20
L1015    rts
L1016    inc   <u0035
         beq   L102A
         ldx   <u0014
         leax  $01,x
         cmpx  <u0016
         bne   L1025
         ldx   #$0001
L1025    stx   <u0014
         lda   #$00
         rts
L102A    lda   #$01
         rts
L102D    lda   <u002E
         ora   #$30
         ldy   <u0012
         cmpa  ,y
         bne   L105D
L1038    ldx   <u0012
         leax  $01,x
         ldy   <u000A
         lda   $08,y
         ldy   <u000E
         leay  $01,y
L1046    ldb   ,x+
         exg   a,b
         lbsr  L100B
         pshs  a
         lda   ,y+
         lbsr  L100B
         exg   a,b
         cmpb  ,s+
         bne   L105D
         deca
         bne   L1046
L105D    rts
L105E    bsr   L108E
         lda   <u0006
         ldx   <u0012
         ldy   <u0018
         os9   I$Read
         bcs   L106D
         rts
L106D    leax  >L1074,pcr
         lbra  L05EA

L1074    fcc   "RMS FILE IO ERROR, FATAL./"

L108E    lda   <u0014
         ldb   <u0018
         mul
         std   <u00AA
         lda   <u0015
         ldb   <u0019
         mul
         std   <u00AC
         lda   <u0014
         ldb   <u0019
         mul
         addd  <u00AB
         std   <u00AB
         bcc   L10A9
L10A7    inc   <u00AA
L10A9    lda   <u0015
         ldb   <u0018
         mul
         addd  <u00AB
         std   <u00AB
         bcc   L10B6
         inc   <u00AA
L10B6    lda   <u0006
         ldx   <u00AA
         ldu   <u00AC
         os9   I$Seek
L10BF    bcs   L106D
         rts
L10C2    ldx   <u005C
         beq   L10E6
L10C6    lda   <u0049
         lsra
         lsra
         sta   <u0080
         beq   L10D7
L10CE    ldx   <u00A6
         lbsr  L129C
         dec   <u0080
         bne   L10CE
L10D7    tfr   dp,a
         ldb   #$5C
         tfr   d,x
         lbsr  L11DB
         lbsr  L1185
         lbsr  L11C3
L10E6    lbsr  L0ECD
         bne   L1104
         lbsr  L1185
         tfr   dp,a
         ldb   #$5E
         tfr   d,x
         ldd   ,x
         beq   L10FE
         lbsr  L11DB
         lbsr  L1185
L10FE    lda   <u0006
         clrb
         os9   F$Exit
L1104    lda   #$01
         lbsr  L1326
         bne   L10E6
         tfr   dp,a
         ldb   #$96
         tfr   d,x
         lbsr  L11A4
         tfr   dp,a
         ldb   #$9B
         tfr   d,x
         lbsr  L11A4
         ldd   #$2020
         std   <u009C
         std   <u009E
         lda   #$30
         sta   <u00A0
         tst   <u004C
         beq   L112F
         lbsr  L1185
L112F    lda   #$01
         lbsr  L11FD
         tfr   dp,a
         ldb   #$60
         tfr   d,x
         lbsr  L11DB
         ldy   <u000C
         lda   ,y
         beq   L1179
L1144    lbsr  L0F88
         beq   L1179
         lda   #$02
         lbsr  L1326
         bne   L1144
         tfr   dp,a
         ldb   #$A0
         tfr   d,x
         lbsr  L11A4
         tfr   dp,a
         ldb   #$9B
         tfr   d,x
         lbsr  L11A4
         tst   <u004D
         beq   L1169
         lbsr  L1185
L1169    lda   #$02
         lbsr  L11FD
         tfr   dp,a
         ldb   #$62
         tfr   d,x
         lbsr  L11DB
         bra   L1144
L1179    tfr   dp,a
         ldb   #$66
         tfr   d,x
         lbsr  L11DB
         lbra  L10E6
L1185    ldx   <u004A
         cmpx  #$0001
         beq   L11C2
L118C    ldx   <u004A
         cmpx  <u0046
         bgt   L1199
         ldx   <u00A6
         lbsr  L129C
         bra   L118C
L1199    ldx   #$0001
         stx   <u004A
         tfr   dp,a
         ldb   #$77
         tfr   d,x
L11A4    lda   #$01
L11A6    cmpa  #$00
         beq   L11C2
         ldb   ,x
         andb  #$0F
         sta   <u001E
         addb  <u001E
         clra
         cmpb  #$0A
         blt   L11BA
         subb  #$0A
         inca
L11BA    orb   #$30
         stb   ,x
         leax  -$01,x
         bra   L11A6
L11C2    rts
L11C3    tfr   dp,a
         ldb   #$64
         tfr   d,x
         stx   <u008A
L11CB    ldx   <u008A
         ldx   ,x
         beq   L11DA
         stx   <u008A
         leax  $02,x
         lbsr  L129C
         bra   L11CB
L11DA    rts
L11DB    stx   <u008C
L11DD    ldx   <u008C
         ldd   ,x
         beq   L11DA
         ldd   <u004A
         cmpd  <u0048
         ble   L11F0
         lbsr  L1185
         lbsr  L11C3
L11F0    ldx   <u008C
         ldx   ,x
         stx   <u008C
         leax  $02,x
         lbsr  L129C
         bra   L11DD
L11FD    sta   <u008E
         tfr   dp,a
         ldb   #$68
         tfr   d,x
         stx   <u0090
L1207    ldx   <u0090
         ldx   ,x
         bne   L120E
         rts
L120E    stx   <u0090
         lda   <u008E
         cmpa  $05,x
         bne   L1207
         ldd   $03,x
         std   <u001E
         lda   $06,x
         leax  $07,x
         stx   <u0020
         leax  a,x
         stx   <u0022
         ldx   <u001E
         lda   $08,x
         ldx   <$12,x
         stx   <u001E
         leax  a,x
         stx   <u0024
         clrb
L1232    ldx   <u0024
         cmpx  <u001E
         beq   L1272
         leax  -$01,x
         stx   <u0024
         lda   ,x
         cmpa  #$20
         beq   L1272
         cmpa  #$2E
         bne   L1250
         ldx   <u0022
         leax  -$01,x
         sta   ,x
         stx   <u0022
         bra   L1232
L1250    anda  #$0F
         sta   <u0054
         ldx   <u0022
         leax  -$01,x
         stx   <u0022
         lda   ,x
         anda  #$0F
         adda  <u0054
         stb   <u0054
         clrb
         adda  <u0054
         cmpa  #$0A
         blt   L126C
         suba  #$0A
         incb
L126C    ora   #$30
         sta   ,x
         bra   L1232
L1272    tstb
         beq   L1299
         ldx   <u0022
         cmpx  <u0020
         beq   L1292
         leax  -$01,x
         stx   <u0022
         lda   ,x
         anda  #$0F
         clrb
         inca
         cmpa  #$0A
         blt   L128C
         suba  #$0A
         incb
L128C    ora   #$30
         sta   ,x
         bra   L1272
L1292    leax  >L0E68,pcr
         lbra  L05EA
L1299    lbra  L1207
L129C    stx   <u0072
         ldd   ,x
         lbeq  L1320
         ldb   #$20
         lda   #$00
         ldx   <u00A2
L12AA    stb   ,x+
         deca
         bne   L12AA
L12AF    ldx   <u0072
         ldx   ,x
         beq   L12F1
         stx   <u0072
         ldd   $04,x
         ldx   $02,x
         ldy   <u00A2
         leay  -$01,y
         pshs  a
         clra
         leay  d,y
         puls  a
         tsta
         beq   L12D6
L12CA    ldb   ,x+
         stb   ,y+
         cmpy  <u00A8
         beq   L12D6
         deca
         bne   L12CA
L12D6    ldx   <u0072
         lda   $06,x
         cmpa  #$01
         bne   L12AF
         ldb   $04,x
         ldx   $02,x
         lda   #$20
L12E4    sta   ,x+
         decb
         bne   L12E4
         leax  -$01,x
         lda   #$30
         sta   ,x
         bra   L12AF
L12F1    ldx   <u00A2
         leax  <$7F,x
         leax  <$7F,x
         lda   #$20
L12FB    cmpa  ,x
         bne   L1305
         leax  -$01,x
         cmpx  <u00A2
         bcc   L12FB
L1305    lda   #$0D
         sta   $01,x
         tfr   x,d
         addd  #$0002
         subd  <u00A2
         tfr   d,y
         ldx   <u00A2
         lda   #$01
         os9   I$WritLn
         ldx   <u004A
         leax  $01,x
         stx   <u004A
         rts
L1320    ldx   <u00A2
         leax  -$01,x
         bra   L1305
L1326    sta   <u0050
         tfr   dp,a
         ldb   #$4E
         tfr   d,x
         stx   <u0052
L1330    ldx   <u0052
         ldx   ,x
         bne   L1337
         rts
L1337    stx   <u0052
         lda   <u0050
         cmpa  $06,x
         bne   L1330
         leay  $07,x
         lda   $03,x
         ldx   $04,x
         stx   <u002F
         sty   <$10,x
         cmpa  #$28
         bne   L1354
         lbsr  L13B8
         bra   L1357
L1354    lbsr  L1371
L1357    beq   L1365
         ldx   <u0052
         lda   $02,x
         lbsr  L100B
         cmpa  #$45
         beq   L1330
         rts
L1365    ldx   <u0052
         lda   $02,x
         lbsr  L100B
         cmpa  #$49
         beq   L1330
         rts
L1371    ldx   <u002F
         lda   <$10,x
         sta   <u001E
         lda   <$11,x
         sta   <u001F
         ldx   <$12,x
         stx   <u0020
L1382    ldx   <u0020
         stx   <u0022
L1386    ldx   <u001E
         lda   ,x
         leax  $01,x
         stx   <u001E
         cmpa  #$2C
         beq   L13B5
         cmpa  #$00
         beq   L13B5
         ldx   <u0022
         cmpa  ,x
         bne   L13A2
         leax  $01,x
         stx   <u0022
         bra   L1386
L13A2    ldx   <u001E
L13A4    lda   ,x
         beq   L13B2
         leax  $01,x
         cmpa  #$2C
         bne   L13A4
         stx   <u001E
         bra   L1382
L13B2    lda   #$01
         rts
L13B5    lda   #$00
         rts
L13B8    ldx   <u002F
         lda   $08,x
         sta   <u001E
         lda   <$10,x
         sta   <u001F
         lda   <$11,x
         sta   <u0020
         lda   $09,x
         ldx   <$12,x
         stx   <u0021
         cmpa  #$44
         beq   L141A
         ldb   <u001E
         ldx   <u0021
         stx   <u0023
L13D9    ldx   <u0023
         lda   ,x
         leax  $01,x
         stx   <u0023
         ldx   <u001F
         cmpa  ,x
         blt   L13B2
         bne   L13F2
         leax  $01,x
         stx   <u001F
         decb
         bne   L13D9
         bra   L13F2
L13F2    ldx   <u001F
L13F4    lda   ,x+
         cmpa  #$2C
         bne   L13F4
         stx   <u001F
         ldb   <u001E
L13FE    ldx   <u0021
         lda   ,x
         leax  $01,x
         stx   <u0021
         ldx   <u001F
         cmpa  ,x
         bgt   L13B2
         lbne  L13B5
         leax  $01,x
         stx   <u001F
         decb
         bne   L13FE
         lbra  L13B5
L141A    ldx   <u0021
         ldy   <u001F
         ldd   $06,x
         cmpd  $06,y
         blt   L13B2
         bne   L143A
         ldd   $03,x
         cmpd  $03,y
         blt   L13B2
         bne   L143A
         ldd   ,x
         cmpd  ,y
         lblt  L13B2
L143A    ldd   $06,x
         cmpd  $0F,y
         lbgt  L13B2
         bne   L1459
         ldd   $03,x
         cmpd  $0C,y
         lbgt  L13B2
         bne   L1459
         ldd   ,x
         cmpd  $09,y
         lbgt  L13B2
L1459    lbra  L13B5

L145C    pshs  x,b,a
         leax  ,s
         ldy   #$0001
         lda   #$01
         os9   I$Write
         puls  pc,x,b,a

         emod
eom      equ   *
