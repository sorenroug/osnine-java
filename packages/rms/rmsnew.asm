         nam   rmsnew
         ttl   Record Management System - rmsnew

         ifp1
         use   defsfile
         endc
tylg     set   Prgrm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   1
u0001    rmb   2
u0003    rmb   2
u0005    rmb   1
u0006    rmb   1
u0007    rmb   1
u0008    rmb   1
u0009    rmb   2
u000B    rmb   2
u000D    rmb   2
u000F    rmb   2
u0011    rmb   2
u0013    rmb   33
u0034    rmb   15
u0043    rmb   1
u0044    rmb   2
u0046    rmb   3
u0049    rmb   183
u0100    rmb   1792
size     equ   .
name     equ   *
         fcs   /rmsnew/
         fcb   $01
start    equ   *
         leau  >u0100,u
         stu   <u0009
         stx   <u000D
         stx   <u000B
         ldx   <u0009
         stx   <u0013
         lda   #$55
         ldb   #$55
         ldy   #$0400
L002A    std   ,x++
         leay  -$02,y
         bne   L002A
         stx   <u0009
         ldx   <u0009
         stx   <u000F
         lbsr  L00F6
         lbne  L01A7
         lda   #$2E
         ldb   #$72
         std   ,x
         lda   #$6D
         ldb   #$73
         std   $02,x
         clr   $04,x
         ldx   <u000F
         lda   #$01
         os9   I$Open
         lbcc  L01AF
         ldb   #$5B
         lda   #$02
         ldx   <u000F
         os9   I$Create
         lbcs  L01B5
         sta   <u0011
L0065    leax  >L0214,pcr
         lbsr  L0189
         clr   <u0007
         clr   <u0008
L0070    lbsr  L02A9
         cmpa  #$0D
         beq   L0099
         cmpa  #$30
         blt   L007F
         cmpa  #$39
         ble   L0088
L007F    leax  >L0228,pcr
         lbsr  L0189
         bra   L0065
L0088    anda  #$0F
         sta   <u0006
         lbsr  L012D
         ldd   <u0007
         clr   <u0005
         addd  <u0005
         std   <u0007
         bra   L0070
L0099    lda   #$0A
         lbsr  L0297
         ldd   <u0007
         beq   L0065
         cmpd  #$03FE
         bls   L00B1
         leax  >L0228,pcr
         lbsr  L0189
         bra   L0065
L00B1    addd  #$0002
         std   <u0003
L00B6    leax  >L0258,pcr
         lbsr  L0189
         clr   <u0007
         clr   <u0008
L00C1    lbsr  L02A9
         cmpa  #$0D
         beq   L00E7
         cmpa  #$30
         blt   L00D0
         cmpa  #$39
         ble   L00D9
L00D0    leax  >L0228,pcr
         lbsr  L0189
         bra   L00B6
L00D9    anda  #$0F
         sta   <u0006
         bsr   L012D
         ldd   <u0007
         addd  <u0005
         std   <u0007
         bra   L00C1
L00E7    ldd   <u0007
         orb   #$01
         std   <u0001
         leax  >L0270,pcr
         lbsr  L0189
         bra   L013E
L00F6    ldy   <u000D
L00F9    lda   ,y
         cmpa  #$0D
         bne   L0102
         lda   #$01
         rts

L0102    cmpa  #$20
         beq   L010A
         cmpa  #$2C
         bne   L010E
L010A    leay  $01,y
         bra   L00F9
L010E    ldb   #$50
L0110    lda   ,y
         cmpa  #$20
         beq   L0125
         cmpa  #$2C
         beq   L0125
         cmpa  #$0D
         beq   L0127
         leay  $01,y
         sta   ,x+
         decb
         bne   L0110
L0125    leay  $01,y
L0127    sty   <u000D
         lda   #$00
         rts

L012D    ldd   <u0007
         addd  <u0007
         addd  <u0007
         addd  <u0007
         addd  <u0007
         std   <u0007
         addd  <u0007
         std   <u0007
         rts

L013E    ldd   <u0001
         ldx   <u0013
         std   $01,x
         ldd   <u0003
         std   $03,x
         leax  d,x
         leax  -$01,x
         lda   #$0D
         sta   ,x
         lda   <u0011
         ldy   <u0003
         ldx   <u0013
         os9   I$Write
         bcs   L01BB
         lda   #$55
         ldb   #$55
         ldx   <u0013
         std   $01,x
         std   $03,x
L0166    lda   <u0011
         ldy   <u0003
         ldx   <u0013
         os9   I$Write
         bcs   L01BB
         ldd   <u0001
         beq   L017D
         subd  #$0001
         std   <u0001
         bra   L0166
L017D    lda   <u0011
         leax  >L0286,pcr
         bsr   L0189
L0185    clrb
         os9   F$Exit
L0189    lda   #$0A
         lbsr  L0297
         lda   #$0D
         lbsr  L0297
L0193    lda   ,x+
         beq   L019C
         lbsr  L0297
         bra   L0193
L019C    lda   #$0A
         lbsr  L0297
         lda   #$0D
         lbsr  L0297
         rts
L01A7    leax  >L01C1,pcr
L01AB    bsr   L0189
         bra   L0185
L01AF    leax  >L01D3,pcr
         bra   L01AB
L01B5    leax  >L01E7,pcr
         bra   L01AB
L01BB    leax  >L01F9,pcr
         bra   L01AB

L01C1    fcc   "INVALID PATH NAME"
         fcb   0
L01D3    fcc   "FILE ALREADY EXISTS"
         fcb   0
L01E7    fcc   "CAN'T CREATE FILE"
         fcb   0
L01F9    fcc   "DISK IO ERROR WRITING FILE"
         fcb   0
L0214    fcc   "INPUT RECORD LENGTH"
         fcb   0
L0228    fcc   "INVALID ENTRY, RE-ENTER"
         fcb   0
L0240    fcc   "INVALID FILE SIZE RETRY"
         fcb   0
L0258    fcc   "INPUT NUMBER OF RECORDS"
         fcb   0
L0270    fcc   "FORMAT IN PROGRESS..."
         fcb   0
L0286    fcc   "FILE FORMATED OK"
         fcb   0

L0297    pshs  x
         ldx   <u0009
         sta   ,x
         ldy   #$0001
L02A1    lda   #$01
         os9   I$Write
         puls  x
         rts

L02A9    lda   #$01
         ldy   #$0001
         ldx   <u0009
         os9   I$Read
         ldx   <u0009
         lda   ,x
         anda  #$7F
         rts

         emod
eom      equ   *
