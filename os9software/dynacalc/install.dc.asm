         nam   INSTALL
         ttl   program module

         ifp1
         use   /dd/defs/os9defs
         endc
tylg     set   Prgrm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   1
u0001    rmb   1
u0002    rmb   1
u0003    rmb   1
u0004    rmb   1
u0005    rmb   1
u0006    rmb   1
u0007    rmb   1
u0008    rmb   1
u0009    rmb   1
u000A    rmb   3
u000D    rmb   8
u0015    rmb   1
u0016    rmb   1
u0017    rmb   1
u0018    rmb   7
u001F    rmb   1
u0020    rmb   1
u0021    rmb   2
u0023    rmb   2
u0025    rmb   1   flag for asking terminal attributes
u0026    rmb   1
u0027    rmb   1
u0028    rmb   2
u002A    rmb   3
u002D    rmb   4    Upper case flag
u0031    rmb   3
u0034    rmb   1
u0035    rmb   1
u0036    rmb   3
u0039    rmb   11
u0044    rmb   1
u0045    rmb   4
u0049    rmb   3
u004C    rmb   2
u004E    rmb   1
u004F    rmb   1
u0050    rmb   4
u0054    rmb   1
u0055    rmb   2
u0057    rmb   2
u0059    rmb   8
u0061    rmb   1
u0062    rmb   1
u0063    rmb   1
u0064    rmb   1
u0065    rmb   8
u006D    rmb   2
u006F    rmb   1
u0070    rmb   3
u0073    rmb   1
u0074    rmb   5
u0079    rmb   111
u00E8    rmb   12
u00F4    rmb   5
u00F9    rmb   4
u00FD    rmb   1
u00FE    rmb   1
u00FF    rmb   213
u01D4    rmb   138
u025E    rmb   366
u03CC    rmb   1024
u07CC    rmb   11386
size     equ   .
name     equ   *
         fcs   /INSTALL/
         fcc   "     Install- a utility for DYNACALC  "
         fcb   $0D
         fcb   $0A
         fcc   "Version 4.7:3  "
         fcb   $0D
         fcb   $0A
         fcc   "Copyright (C) 1983, by Scott Schaeferle  "
         fcb   $0D
         fcb   $0A
         fcc   "All rights reserved     "

start    equ   *
         leay  -$01,y
         sty   <u002A
         stu   <u0028
         lda   #$28
L0099    clr   ,u+
         deca
         bne   L0099
         ldy   <u0028
         leax  <$2C,y
         clra
         clrb
         os9   I$GetStt
         lbcs  L06DD
         leax  >L08A1,pcr banner
         lbsr  L06D2
         tfr   s,x
         cmpx  <u002A
         beq   L0123
L00BA    ldd   ,x
         anda  #$5F
         cmpd  #$4920    I+space
         beq   L012A
         cmpd  #$490D    I+cr
         beq   L012A
         tst   <u0026
         bne   L0123   Instructions
         ldy   <u0028
         leau  >$014C,y
L00D5    lda   ,x+
         sta   ,u+
         cmpa  #$0D
         beq   L00E9
         cmpa  #$20
         bne   L00D5
L00E1    lda   ,x+
         cmpa  #$20
         beq   L00E1
         leax  -$01,x
L00E9    pshs  x
         ldx   -u0003,u
         cmpx  #$726D     rm
         beq   L00F7
         cmpx  #$524D     RM
         bne   L0103
L00F7    ldx   -u0005,u
         cmpx  #$2E74     .t
         beq   L010F
         cmpx  #$2E54     .T
         beq   L010F
L0103    leau  -u0001,u
         ldx   #$2E74     .t
         stx   ,u++
         ldx   #$72ED     rm
         stx   ,u++
L010F    leax  >$014C,y
         lda   #$01
         os9   I$Open
         puls  x
         lbcs  L01A9
         sta   <u0026
         lbra  L00BA

L0123    leax  >L08D0,pcr  Instructions
         lbsr  L06D2
L012A    ldy   <u0028
         clra
         clrb
         leax  >$014C,y
         os9   I$GetStt
         lbcs  L06DD
         clr   $04,x
         clr   $0C,x
         clr   $0F,x
         clr   <$10,x
         clr   <$11,x
         clr   <$16,x
         os9   I$SetStt
         lbcs  L06DD
         leax  >L078E,pcr   Dynacalc.trm
         lda   #$05
         os9   I$Open
         bcc   L0163
         cmpb  #$D8
         lbne  L06DD
         bra   L016B
L0163    leax  >L083D,pcr
         clrb
         lbra  L06E1
L016B    leax  >L079A,pcr  dynacalc.cor
         lda   #$01
         os9   I$Open
         bcs   L018A
         ldx   <u0028
         leax  >$014C,x
         ldy   #$3200
         os9   I$Read
         bcs   L018A
         os9   I$Close
         bcc   L0191
L018A    leax  >L07CA,pcr
         lbra  L06E1
L0191    ldu   <u0028
         leax  >u01D4,u
         lda   <u0026
         beq   L01B0
         ldy   #$0200
         os9   I$Read
         bcs   L01A9
         os9   I$Close
         bcc   L01B6
L01A9    leax  >L07A6,pcr
         lbsr  L06E1
L01B0    leay  >L18AC,pcr
         bra   L01CB
L01B6    leay  >u025E,u
         leax  >u07CC,u
L01BE    lda   ,y
         clr   ,y+
         sta   ,x+
         bne   L01BE
         ldd   #$2000
         std   -$01,x
L01CB    tfr   u,y
         com   <u0003
         tst   <u0026
         beq   L01D5
         clr   <u0003
L01D5    clr   <u0025
         leax  >L0CDD,pcr   printer characteristics
         lbsr  L0280
         bcs   L01F5
         leax  >L12D5,pcr
         lbsr  L0304
         lda   >$0245,y
         cmpa  #$08
         bcs   L01F5
         lda   #$07
         sta   >$0245,y
L01F5    leax  >L0CCD,pcr printer strings
         lbsr  L0280
         bcs   L0205
         leax  >L0E82,pcr
         lbsr  L0304
L0205    leax  >L0CF5,pcr Do you wish to keep helps
         leau  >$0247,y
         inc   <u001F
         lbsr  L05B3
         bcs   L021A
         clr   >$0247,y
         bra   L0220
L021A    ldb   #$FF
         stb   >$0247,y
L0220    leax  >L0D34,pcr Do you want to change anything
         clr   <u0003
         lbsr  L05B3
         lbcc  L01D5
         tst   <u0025
         beq   L0248
         ldb   #12
         leau  >$0204,y
         leax  >L0273,pcr
L023B    lda   ,x+
         sta   ,u+
         decb
         bne   L023B
         lda   #$FF
         sta   >$01FC,y
L0248    leax  >L078E,pcr   Dynacalc.trm
         lda   #$06
         ldb   #$3F
         os9   I$Create
         bcs   L0262
         leax  >$014C,y
         ldy   #$3200
         os9   I$Write
         bcc   L0269
L0262    leax  >L07F3,pcr
         lbra  L06E1
L0269    leax  >L088A,pcr  Installation complete
         lbsr  L06D2
         lbra  L06ED

L0273    fcb   $1B,$5B,'K
         fcb   $FF,$FF,$FF
         fcb   $1B,$5B,'J
         fcb   $FF,$FF,$FF

L027F    rts
L0280    lbsr  L069F
         lbsr  L069F
         tst   <u0003
         bne   L0295
         pshs  x
         leax  >L0D10,pcr   Change
         lbsr  L06D6
         puls  x
L0295    lbsr  L06D6
         clra
         tst   <u0003
         bne   L027F
         leax  >L0D18,pcr
         stx   <u002A
         lbra  L05BA

L02A6    tst   <u0003
         bne   L027F
L02AA    pshs  x
         tst   ,u
         bpl   L02C0
         lda   ,u
         leax  >L0D8D,pcr    **col**
         cmpa  #$88
         beq   L02DD
         leax  >L0D85,pcr    ++row++
         bra   L02DD
L02C0    tfr   u,x
         tst   <u0008
         bne   L02CE
         lda   #$24
         lbsr  L06A1
         lbsr  L06FF
L02CE    clr   <u0008
         lbsr  L02FF
         lda   ,x
         cmpa  #$20
         bne   L02E2
         leax  >L0D1A,pcr  (S)
L02DD    lbsr  L06D6
         bra   L02F8
L02E2    bhi   L02F1
         pshs  a
         dec   <u0006
         lda   #$5E
         lbsr  L06A1
         puls  a
         ora   #$40
L02F1    lbsr  L06A1
         inc   <u0006
         inc   <u0006
L02F8    lbsr  L02FD
         puls  pc,x
L02FD    bsr   L02FF
L02FF    lda   #$20
         lbra  L06A1
L0304    tst   <u0025
         beq   L0324
         leau  >L150C,pcr  Direct cursor addr
         pshs  u
         cmpx  ,s++
         bne   L0316
         leax  >L16B5,pcr
L0316    leau  >L122E,pcr
         pshs  u
         cmpx  ,s++
         bne   L0324
         leax  >L126A,pcr
L0324    stx   <u002A
         lbsr  L06D2
         ldd   ,x++
         addd  #$014C
         leau  d,y
         lda   ,x+
         anda  #$0F
         bne   L0397
L0336    lda   #$FF
         sta   >$0258,y
         sta   >$025C,y
         stu   <u0023
         stx   <u0021
         inc   <u0020
         lbsr  L0505
         clr   <u0020
         leau  >$01FC,y
         ldb   #$FF
L0351    incb
         lda   b,u
         bpl   L0351
         cmpa  #$88
         bne   L0366
         tst   >$0258,y
         bpl   L0391
         stb   >$0258,y
         bra   L0351
L0366    cmpa  #$99
         bne   L0376
         tst   >$025C,y
         bpl   L0391
         stb   >$025C,y
         bra   L0351
L0376    tst   >$025C,y
         bmi   L0384
         tst   >$0258,y
         lbpl  L03FF
L0384    leax  >L0DDB,pcr
L0388    lbsr  L06D2
         ldu   <u0023
         ldx   <u0021
         bra   L0336
L0391    leax  >L0D95,pcr
         bra   L0388
L0397    deca
         bne   L03B4
         lbsr  L02A6
         lbsr  L05FE
         tst   <u0007
         bne   L03AC
         cmpa  #$0D
         beq   L0405
         cmpa  #$20
         beq   L03AE
L03AC    sta   ,u
L03AE    lbsr  L02AA
         lbra  L03FF
L03B4    deca
         bne   L03C9
         clrb
         pshs  x
         inc   <u001F
         lbsr  L05BA
         bcc   L03C2
         comb
L03C2    stb   ,u
         puls  x
         lbra  L03FF
L03C9    deca
         bne   L03D6
         lda   ,u
         lbsr  L040E
         sta   ,u
         lbra  L03FF
L03D6    deca
         bne   L03DF
         lbsr  L0505
         lbra  L03FF
L03DF    deca
         bne   L03F0
         lda   ,u
         lbsr  L0406
         tst   <u0004
         beq   L0405
         sta   ,u
         lbra  L03FF
L03F0    deca
         bne   L03F8
         lbsr  L04AC
         bra   L03FF
L03F8    leax  >L0D1E,pcr
         lbsr  L06D2
L03FF    tst   ,x
         lbpl  L0304
L0405    rts
L0406    inca
         lbsr  L040E
         beq   L040D
         deca
L040D    rts
L040E    pshs  u,x
L0410    clr   <u0000
         sta   <u0001
         leax  ,y
         clrb
         lbsr  L0732
         lbsr  L02FD
         clr   <u0004
         clr   <u0005
L0421    lbsr  L05FE
         cmpa  #$0D
         bne   L0431
         tst   <u0004
         bne   L0479
         puls  u,x
         leas  $02,s
         rts
L0431    cmpa  #$20
         bne   L0441
         leax  ,y
         clrb
         lbsr  L0732
         lda   <u0001
         inc   <u0004
         puls  pc,u,x
L0441    cmpa  <u0035
         beq   L0465
         cmpa  <u0036
         beq   L0465
         sta   <u0002
         lbsr  L0727
         bcs   L0421
         tfr   a,b
         lda   <u0002
         lbsr  L06A1
         stb   <u0002
         ldb   <u0005
         lda   #$0A
         mul
         tsta
         bne   L0465
         addb  <u0002
         bcc   L046E
L0465    ldx   <u002A
         lbsr  L06D2
         lda   <u0001
         bra   L0410
L046E    stb   <u0005
         ldb   <u0004
         incb
         stb   <u0004
         cmpb  #$03
         bne   L0421
L0479    lda   <u0005
         puls  pc,u,x
         leax  >L0C62,pcr
         lbsr  L06D2
         lbsr  L0654
         leau  >$022A,y
         ldb   #$10
         leax  <$4C,y
L0490    lda   ,x+
         cmpa  #$0D
         beq   L049D
         sta   ,u+
         decb
         bne   L0490
         bra   L04A5
L049D    lda   #$20
L049F    sta   ,u+
         subb  #$01
         bgt   L049F
L04A5    lda   #$04
         sta   >$023A,y
         rts
L04AC    pshs  x
         leau  >$07CC,y
         ldb   #$FF
L04B4    incb
         tst   b,u
         bne   L04B4
         tstb
         beq   L04D0
         leax  >L0B96,pcr
         lbsr  L06D2
         lda   #$04
         sta   b,u
         tfr   u,x
         lbsr  L06D6
         clr   b,u
         bra   L04D7
L04D0    leax  >L0BB1,pcr   No printer currently
         lbsr  L06D2
L04D7    leax  >L0BD3,pcr   Do you wish to change it?
         lbsr  L05B3
         bcs   L0503
         leax  >L0BEC,pcr  Printer pathname
         lbsr  L06D2
         lbsr  L0654
         leau  >$07CC,y
         leax  <$4C,y
         ldb   #$3C
L04F3    lda   ,x+
         cmpa  #$0D
         beq   L04FE
         sta   ,u+
         decb
         bne   L04F3
L04FE    ldd   #$2000
         std   ,u
L0503    puls  pc,x
L0505    pshs  x
         lda   -$01,x
         lsra
         lsra
         lsra
         lsra
         sta   <u0004
         clr   <u0000
         clr   <u0001
L0513    inc   <u0001
L0515    lbsr  L057F
         ldb   <u0001
         decb
L051B    lbsr  L05FE
         tst   <u0007
         bne   L055D
         tst   <u0020
         beq   L0536
         cmpa  #$2A
         bne   L052E
         lda   #$88
         bra   L055D
L052E    cmpa  #$2B
         bne   L0536
         lda   #$99
         bra   L055D
L0536    cmpa  #$20
         bne   L0544
         lda   b,u
         bpl   L055F
         cmpa  #$A0
         bhi   L057A
         bra   L055F
L0544    cmpa  #$2E
         beq   L056E
         cmpa  #$0D
         beq   L057A
         cmpa  <u0035
         bne   L055D
         dec   <u0001
         bne   L0558
         inc   <u0001
         bra   L051B
L0558    inc   <u0004
         decb
         bra   L0515
L055D    sta   b,u
L055F    pshs  u
         leau  b,u
         lbsr  L02AA
         puls  u
         dec   <u0004
         bne   L0513
         inc   <u0001
L056E    lda   #$FF
         ldb   <u0001
         decb
L0573    sta   b,u
         incb
         dec   <u0004
         bpl   L0573
L057A    lbsr  L069F
         puls  pc,x
L057F    pshs  u
         lbsr  L069F
         ldb   #$FF
         leax  ,y
         lbsr  L0732
         lda   #$3E
         lbsr  L06A1
         lda   #$20
         lbsr  L06A1
         ldb   <u0001
         decb
         clr   <u0006
         lda   b,u
         bpl   L05A2
         cmpa  #$A0
         bhi   L05A7
L05A2    leau  b,u
         lbsr  L02AA
L05A7    lda   #$20
         ldb   <u0006
L05AB    lbsr  L06A1
         decb
         bpl   L05AB
         puls  pc,u
L05B3    stx   <u002A
L05B5    ldx   <u002A
         lbsr  L06D2
L05BA    lda   #$3F
         lbsr  L06A1
         lda   #$20
         lbsr  L06A1
         lbsr  L0682
         cmpa  #$11
         lbne  L05D5
         leax  >L080E,pcr
         clrb
         lbra  L06E1
L05D5    anda  #$5F
         cmpa  #$59
         beq   L05FD
         cmpa  #$4E
         beq   L05FC
         cmpa  #$0D
         beq   L05FC
         tsta
         bne   L05B5
         tst   <u001F
         beq   L05B5
         clr   <u001F
         lda   ,u
         bne   L05F7
         lda   #$59
         lbsr  L06A1
         clra
         rts
L05F7    lda   #$4E
         lbsr  L06A1
L05FC    coma
L05FD    rts
L05FE    pshs  x,b
         lbsr  L0687
         clr   <u0007
         clr   <u0008
         cmpa  #$26
         beq   L060F
         cmpa  #$24
         bne   L0652
L060F    sta   <u0007
L0611    lbsr  L0687
         cmpa  <u0007
         beq   L0652
         ldb   <u0007
         cmpb  #$24
         beq   L0626
         cmpa  #$40
         bcs   L0652
         anda  #$1F
         bra   L0652
L0626    lbsr  L0716
         bcs   L0611
         lsla
         lsla
         lsla
         lsla
         pshs  a
         lda   #$24
         lbsr  L06A1
         com   <u0008
         lda   <u0009
         lbsr  L06A1
L063D    lbsr  L0687
         lbsr  L0716
         bcs   L063D
         adda  ,s+
         pshs  a
         lda   <u0009
         lbsr  L06A1
         puls  a
         anda  #$7F
L0652    puls  pc,x,b
L0654    pshs  u,y
         clra
         clrb
         ldu   <u0028
         leax  >u03CC,u
         os9   I$GetStt
         inc   $04,x
         os9   I$SetStt
         clra
         leax  <u004C,u
         ldy   #$0100
         os9   I$ReadLn
         lbcs  L06DD
         leax  >u03CC,u
         clr   $04,x
         clra
         clrb
         os9   I$SetStt
         puls  pc,u,y
L0682    bsr   L0687
         lbra  L06A1
L0687    pshs  y,x,a
         tfr   s,x
         ldy   #$0001
         clra
         os9   I$Read
         lbcs  L06DD
         puls  a
         anda  #$7F
         sta   <u0009
         puls  pc,y,x

L069F    lda   #$0D
* Write a character
L06A1    pshs  y,x,a
         tst   <u002D  Upper case needed?
         beq   L06B1 ..no
         cmpa  #$61
         bcs   L06B1
         cmpa  #$7A
         bhi   L06B1
         anda  #$5F
L06B1    pshs  a
         tfr   s,x
         lda   #$01
         ldy   #$0001
         os9   I$Write
         lbcs  L06DD
         puls  a
         cmpa  #$0D
         bne   L06D0
         tst   <u0031
         beq   L06D0
         lda   #$0A
         bra   L06B1
L06D0    puls  pc,y,x,a

* Write a line starting with CR
L06D2    lda   #$0D
L06D4    bsr   L06A1
* Write line
L06D6    lda   ,x+
         cmpa  #$04
         bne   L06D4
         rts

L06DD    leax  >L07E7,pcr  Fatal error
L06E1    stb   <u0027
         lbsr  L06D2
         leax  >L0821,pcr
         lbsr  L06D6
L06ED    lbsr  L069F
         clra
         clrb
         ldx   <u0028
         leax  <$2C,x
         os9   I$SetStt
         ldb   <u0027
         os9   F$Exit
L06FF    lda   ,x
         lsra
         lsra
         lsra
         lsra
         bsr   L070B
         lda   ,x
         anda  #$0F
L070B    adda  #$30
         cmpa  #$3A
         bcs   L0713
         adda  #$07
L0713    lbra  L06A1
L0716    bsr   L0727
         bcc   L0726
         suba  #$11
         bcs   L0726
         pshs  a
         adda  #$0A
         ldb   #$05
         subb  ,s+
L0726    rts
L0727    suba  #$30
         bcs   L0731
         pshs  a
         ldb   #$09
         subb  ,s+
L0731    rts
L0732    pshs  u,y,x,b,a
         stb   <u0015
         ldd   ,x
         leay  <$18,y
         bsr   L074B
         ldb   #$04
         stb   ,y
         ldx   <u0028
         leax  <$18,x
         lbsr  L06D6
         puls  pc,u,y,x,b,a
L074B    clr   <u0017
         leax  >L0786,pcr
L0751    bsr   L0769
         leau  >L078E,pcr   Dynacalc.trm
         pshs  u
         cmpx  ,s++
         bne   L0751
         tfr   b,a
         pshs  cc
L0761    inc   <u0017
L0763    adda  #$30
         sta   ,y+
L0767    puls  pc,a

L0769    clr   <u0016
L076B    inc   <u0016
         subd  ,x
         bcc   L076B
         addd  ,x++
         pshs  a
         lda   <u0016
         deca
         bne   L0761
         tst   <u0017
         bne   L0761
         tst   <u0015
         bne   L0767
         lda   #$F0
         bra   L0763

L0786    fcb   $27,$10,$03,$E8,$00,$64,$00,$0A

L078E    fcs   "Dynacalc.trm"
L079A    fcs   "Dynacalc.cor"
L07A6    fcb   $0D,$0A
         fcc   "Error loading specified .trm file"
         fcb   $04
L07CA    fcc   'Error loading "Dynacalc.cor"'
         fcb   $04
L07E7    fcc   "Fatal error"
         fcb   $04
L07F3    fcc   "Error writing Dynacalc.trm"
         fcb   $04
L080E    fcc   "Unconditional quit"
         fcb   $04
L0821    fcc   "- Installation aborted !!"
         fcb   $07
         fcb   $0d
         fcb   $04
L083D    fcc   "Output file (Dynacalc.trm) already exists in"
         fcb   $0d
         fcc   "the Working Execution Directory"
         fcb   $04
L088A    fcc   "Installation complete."
         fcb   $04
L08A1    fcc   "DYNACALC Customization program, Version 4.7:3"
         fcb   $0D
         fcb   $04
L08D0    fcc   "INSTRUCTIONS-"
         fcb   $0D
         fcc   "INSTALL.DC is a program for changing some of"
         fcb   $0D
         fcc   "characteristics of DYNACALC. To use it, you"
         fcb   $0D
         fcc   "must have the file DYNACALC.COR in your"
         fcb   $0D
         fcc   "execution directory, and you must delete your"
         fcb   $0D
         fcc   "old DYNACALC.TRM, eg:"
         fcb   $0D
         fcc   "   OS9: del /d0/cmds/dynacalc.trm"
         fcb   $0D
         fcc   "INSTALL will prompt you for various attributes"
         fcb   $0D
         fcc   "of your printer. Pressing ENTER will retain the"
         fcb   $0D
         fcc   "existing setting, otherwise enter the setting"
         fcb   $0D
         fcc   "you require. Pressing ENTER in response to a"
         fcb   $0D
         fcc   "YES/NO question will be taken as NO."
         fcb   $0D
         fcb   $0A
         fcc   "Don't worry if you make a mistake entering"
         fcb   $0D
         fcc   "anything. You will be given another chance"
         fcb   $0D
         fcc   "before INSTALL changes DYNACALC on the disk."
         fcb   $0D
         fcb   $04
L0B29    fcc   "Now set-up for :"
         fcb   $04
         fcb   $0A
L0B3B    fcc   "Does your terminal conform to the American National"
         fcb   $0D
         fcc   'Standards Institute, "ANSI", standards'
         fcb   $04
L0B96    fcc   "Printer device currently: "
         fcb   $04
L0BB1    fcc   "No printer device currently used."
         fcb   $04
L0BD3    fcc   "Do you wish to change it"
         fcb   $04
L0BEC    fcb   $0D
         fcc   "Enter your printer device pathname (Limit 60 char.):"
         fcb   $0D
         fcb   $04
L0C23    fcc   "Do you wish to change any screen/keyboard values"
         fcb   $04
L0C54    fcc   "Terminal name"
         fcb   $04
L0C62    fcb   $0D
         fcc   "Enter your terminal's name (Up to 16 characters):"
         fcb   $0D
         fcb   $04
L0C96    fcc   "Special keys"
         fcb   $04
L0CA3    fcc   "Terminal characteristics"
         fcb   $04
L0CBC    fcc   "Terminal strings"
         fcb   $04
L0CCD    fcc   "Printer strings"
         fcb   $04

L0CDD    fcc   "Printer characteristics"
         fcb   $04
L0CF5    fcb   $0D
         fcc   "Do you wish to keep helps"
         fcb   $04
L0D10    fcc   "Change "
         fcb   $04
L0D18    fcc   "?"
         fcb   $04
L0D1A    fcc   "(S)"
         fcb   $04
L0D1E    fcc   "PROGRAM GOT TO XXXXXX"
         fcb   $04
L0D34    fcb   $0A
         fcc   "Do you want to change anything before the data"
         fcb   $0D
         fcc   "is saved (Type cntrl Q to abort)"
         fcb   $04
L0D85    fcc   "++Row++"
         fcb   $04
L0D8D    fcc   "**Col**"
         fcb   $04
L0D95    fcc   "**** You may only specify one column and one row position- Try again."
         fcb   $04
L0DDB    fcc   "**** You must specify both row and column position's- Try again."
         fcb   $04
L0E1C    fcc   "The current string will be printed, along with its"
         fcb   $0D
         fcc   "hex equivalent. Hit the keys you want to be entered"
L0E82    fcc   "Enter the character sequences needed for your"
         fcb   $0D
         fcc   "printer. When all characters in a sequence are"
         fcb   $0D
         fcc   "entered, hit period (.). If you need to enter"
         fcb   $0D
         fcc   "period as a character, type $2E. You should note"
         fcb   $0D
         fcc   "that most printers don't need these strings. If"
         fcb   $0D
         fcc   "this is your case, simply hit period for each"
         fcb   $0D
         fcc   "string."
         fcb   $0D
         fcc   "Sequence to turn on printer (3 Char.):"
         fcb   $04,$00,$A8,$34
L0FCE    fcc   "Sequence to turn off printer (3 Char.):"
         fcb   $04,$00,$AC,$34,$FF
L0FFA    fcc   "The function of the key will be displayed, along with"
         fcb   $0D
         fcc   "its current assignment (if it has one). To change, simply"
         fcb   $0D
         fcc   "press the appropriate key. If if's O.K., just press space"
         fcb   $0D
         fcc   "Up arrow- "
         fcb   $04,$01,$00,$01
L10B2    fcc   "Down arrow- "
         fcb   $04,$01,$01,$01
L10C2    fcc   "Left arrow- "
         fcb   $04,$01,$02,$01
L10D2    fcc   "Right arrow- "
         fcb   $04,$01,$03,$01
L10E3    fcc   "Home- "
         fcb   $04,$01,$04,$01
L10ED    fcc   "Jump window- "
         fcb   $04,$01,$05,$01
L10FE    fcc   "Get address- "
         fcb   $04,$01,$07,$01
L110F    fcc   "Flush type-ahead buffer- "
         fcb   $04,$01,$08,$01
L112C    fcc   "Log-off- "
         fcb   $04,$00,$F7,$01
L1139    fcc   "Backspace- "
         fcb   $04,$01,$09,$01
L1148    fcc   "Edit (From entry level)- "
         fcb   $04,$01,$11,$01
L1165    fcc   "Edit overlay- "
         fcb   $04,$01,$0F,$01,$FF
L1178    fcc   "The individual attributes will be displayed, along with"
         fcb   $0D
         fcc   "their current value (if present). To change, enter"
         fcb   $0D
         fcc   "the new value. Press space if it's O.K. the way it is."
         fcb   $0D
L121A    fcc   "Bell character- "
         fcb   $04,$01
         fcb   $06,$01
L122E    fcc   "Direct cursor addressing row offset- "
         fcb   $04,$01
         fcb   $0a,$01
         fcc   "Column offset- "
         fcb   $04,$01,$0B,$01
L126A    fcc   "Number of columns (Limit 127)- "
         fcb   $04,$01,$0E,$05
L128D    fcc   "Number of rows - "
         fcb   $04,$01,$0D,$03
L12A2    fcc   "Use UPPER CASE only (regardless of TMODE flag)"
         fcb   $04,$00,$F8,$02,$FF
L12D5    fcc   "Enter the printer default characteristics. If"
         fcb   $0D
         fcc   "the displayed value is correct, simply hit space."
         fcb   $0D
         fcc   "Note that these are defaults only, and can be"
         fcb   $0D
         fcc   "changed while in DYNACALC using /AP."
         fcb   $0D
         fcb   $0A
L1389    fcc   "Printer device pathname-"
         fcb   $04,$00,$00,$06,$0D
L13A6    fcc   "Lines per page- "
         fcb   $04,$00,$FF,$05
L13BA    fcc   "Printer width- "
         fcb   $04,$00,$FD,$05
L13CD    fcc   "Line feeds after each line-"
         fcb   $0D
         fcc   "(Range 1 to 8)- "
         fcb   $04,$00,$F9,$05
L13FD    fcc   "Do you want pagination"
         fcb   $04,$00,$FE,$02
L1417    fcc   "Do you want to print borders"
         fcb   $04,$00,$FC,$02,$FF
L1438    fcc   "Enter the character strings needed for your terminal."
         fcb   $0D
         fcc   "When all are entered, hit period. If you want"
         fcb   $0D
         fcc   "to enter period as a character, simply type $2E"
         fcb   $0D
         fcc   "Terminal setup (15 CHAR.):"
         fcb   $04,$00,$90,$F4
L14EA    fcc   'Terminal "Kiss-Off" (7 CHAR.):'
         fcb   $04,$00,$A0,$74
L150C    fcc   "Direct cursor addr. Enter the correct sequence for your"
         fcb   $0D
         fcc   'terminal, typing a "*" where the column position goes and'
         fcb   $0D
         fcc   'a "+" where the row position goes. If you need to enter'
         fcb   $0D
         fcc   'the * or + as a character, preceed with "&". (7 CHAR.):'
         fcb   $04,$00,$B0,$70
L15F1    fcc   "Erase to end of line (Just type period if your terminal"
         fcb   $0D
         fcc   "does not have this feature) (5 CHAR.):"
         fcb   $04,$00,$B8,$54
L1653    fcc   "Erase to end of page (Just type period if your terminal"
         fcb   $0D
         fcc   "does not have this feature) (5 CHAR.):"
         fcb   $04,$00,$BE,$54
L16B5    fcc   "Hilite on (Period if not used) (7 CHAR.):"
         fcb   $04,$00,$C4,$74
L16E2    fcc   "Hilite off (Period if not used) (7 CHAR.):"
         fcb   $04,$00,$CC,$74
L1710    fcc   "Following are the terminal cursor on/off strings."
         fcb   $0D
         fcc   "If your terminal does not support this, type a period"
         fcb   $0D
         fcc   "for the next two prompts. If your terminal has only"
         fcb   $0D
         fcc   '"Toggle cursor on/off", enter that string for both'
         fcb   $0D
         fcc   '"Cursor on" and "Cursor off".'
         fcb   $0a,$0d
         fcc   "Cursor on (3 CHAR.):"
L1812    fcb   $04,$00,$88,$34
         fcc   "Cursor off (3 CHAR.):"
L182B    fcb   $04,$00,$8c,$34
         fcc   "Destructive backspace -"
         fcb   $0d
         fcc   "On most terminals, &H,&(space),&H (5 CHAR.):"
L1873    fcb   $04,$00,$d4,$54
         fcc   "Non-destructive backspace, usually &H (3 CHAR.):"
         fcb   $04,$00,$DA,$34
         fcb   $FF
L18AC    fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
         fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
         fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
         fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
         fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
         fcb   $FF,$FF,$FF,$FF,$FF,$FF
         fcb   $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
         fcb   $FF,$FF,$FF,$FF,$00,$00,$00,$FF,$FF
         fcb   $04,$00,$00,$00,$00,$FF,$4F,$00,$39,$00,$00,$00,$00,$00,$00,$00
         fcb   $00,$00,$00,$00,$00,$00,$18,$4F,$00,$02,$05,$2F,$50,$00
         emod
eom      equ   *
