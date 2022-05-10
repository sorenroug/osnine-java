         nam   cc1.dragon
         ttl   program module

         ifp1
         use   os9defs
         endc
tylg     set   Prgrm+Objct
atrv     set   ReEnt+rev
rev      set   $01
L0000    mod   eom,name,tylg,atrv,start,size

u0000    rmb   1
u0001    rmb   1
u0002    rmb   1
u0003    rmb   1
u0004    rmb   2
u0006    rmb   1
u0007    rmb   1
u0008    rmb   1
u0009    rmb   1
u000A    rmb   1
u000B    rmb   1
u000C    rmb   1
u000D    rmb   4
u0011    rmb   2
u0013    rmb   2
u0015    rmb   2
u0017    rmb   2
u0019    rmb   4
u001D    rmb   2
u001F    rmb   1
u0020    rmb   1
u0021    rmb   2
u0023    rmb   2
u0025    rmb   2
u0027    rmb   2
u0029    rmb   2
u002B    rmb   2
u002D    rmb   2
u002F    rmb   2
u0031    rmb   3
u0034    rmb   15
u0043    rmb   15
u0052    rmb   1
u0053    rmb   1
u0054    rmb   11
u005F    rmb   4
u0063    rmb   1
u0064    rmb   1
u0065    rmb   4
u0069    rmb   6
u006F    rmb   8
u0077    rmb   113
u00E8    rmb   215
u01BF    rmb   2
u01C1    rmb   58
u01FB    rmb   1
u01FC    rmb   3
u01FF    rmb   1890
size     equ   .
name     equ   *
         fcs   /cc1.dragon/
         fcb   $04

L0018    lda   ,y+
         sta   ,u+
         leax  -1,x
         bne   L0018
         rts   

start    equ   *
         pshs  y
         pshs  u
         clra
         clrb
L0027    sta   ,u+
         decb
         bne   L0027
         ldx   ,s
         leau  ,x
         leax  >$05E1,x
         pshs  x
         leay  >L1DB7,pcr
         ldx   ,y++
         beq   L0042
         bsr   L0018
         ldu   $02,s
L0042    leau  >u002D,u
         ldx   ,y++
         beq   L004D
         bsr   L0018
         clra
L004D    cmpu  ,s
         beq   L0056
         sta   ,u+
         bra   L004D
L0056    ldu   $02,s
         ldd   ,y++
         beq   L0063
         leax  >L0000,pcr
         lbsr  L0166
L0063    ldd   ,y++
         beq   L006C
         leax  ,u
         lbsr  L0166
L006C    leas  $04,s
         puls  x
         stx   >u01FF,u
         sty   >u01BF,u
         ldd   #$0001
         std   >u01FB,u
         leay  >u01C1,u
         leax  ,s
         lda   ,x+
L0088    ldb   >u01FC,u
         cmpb  #$1D
         beq   L00E4
L0090    cmpa  #$0D
         beq   L00E4
         cmpa  #$20
         beq   L009C
         cmpa  #$2C
         bne   L00A0
L009C    lda   ,x+
         bra   L0090
L00A0    cmpa  #$22
         beq   L00A8
         cmpa  #$27
         bne   L00C6
L00A8    stx   ,y++
         inc   >u01FC,u
         pshs  a
L00B0    lda   ,x+
         cmpa  #$0D
         beq   L00BA
         cmpa  ,s
         bne   L00B0
L00BA    puls  b
         clr   -$01,x
         cmpa  #$0D
         beq   L00E4
         lda   ,x+
         bra   L0088
L00C6    leax  -$01,x
         stx   ,y++
         leax  $01,x
         inc   >u01FC,u
L00D0    cmpa  #$0D
         beq   L00E0
         cmpa  #$20
         beq   L00E0
         cmpa  #$2C
         beq   L00E0
         lda   ,x+
         bra   L00D0
L00E0    clr   -$01,x
         bra   L0088
L00E4    leax  >u01BF,u
         pshs  x
         ldd   >u01FB,u
         pshs  b,a
         leay  ,u
         bsr   L00FE
         lbsr  L0180
         clr   ,-s
         clr   ,-s
         lbsr  L1DAB exit
L00FE    leax  >$05E1,y
         stx   >$0209,y
         sts   >$01FD,y
         sts   >$020B,y
         ldd   #$FF82
*
* Stack check
* L0113
stkcheck    leax  d,s
         cmpx  >$020B,y
         bcc   L0125
         cmpx  >$0209,y
         bcs   L013F
         stx   >$020B,y
L0125    rts

L0126    fcc "**** STACK OVERFLOW ****"
         fcb $0D

L013F    leax  <L0126,pcr
         ldb   #$CF
         pshs  b
         lda   #$02
         ldy   #$0064
L014C    os9   I$WritLn
         clr   ,-s
         lbsr  L1DB1
L0154    ldd   >$01FD,y
         subd  >$020B,y
         rts
         ldd   >$020B,y
         subd  >$0209,y
L0165    rts
L0166    pshs  x
         leax  d,y
         leax  d,x
         pshs  x
L016E    ldd   ,y++
         leax  d,u
         ldd   ,x
         addd  $02,s
         std   ,x
         cmpy  ,s
         bne   L016E
         leas  $04,s
L017F    rts

*
* main
*
L0180    pshs  u
         ldd   #$FFA1
         lbsr  stkcheck
         leas  -$0F,s
         leax  >L0D2D,pcr  "1.1"
         pshs  x
         ldd   >$005F,y "CC1 VERSION %s..."
         pshs  b,a
         leax  >$0088,y stderr
         pshs  x
         lbsr  L11A7 fprintf
         leas  $06,s
         clra
         clrb
         std   $08,s
         leax  >$002D,y "ctmp.XXXXXX"
         pshs  x
         lbsr  L1161
         leas  $02,s
         leax  >L0D31,pcr "w"
         pshs  x
         leax  >$0041,y  "c.com"?
         pshs  x
         lbsr  L110F   fopen?
         leas  $04,s
         std   <u002B ptr to c.com file descriptor
         lbne  L0445
         leax  >L0D33,pcr "can't open shell command file"
         pshs  x
         lbsr  L0C1E errexit
         leas  $02,s
         lbra  L0445

L01D5    ldx   <$15,s
         leax  $02,x
         stx   <$15,s
         ldd   ,x
         std   $0C,s
         tfr   d,x
         ldb   ,x
         cmpb  #$2D  '-
         lbne  L03D1
         lbra  L03BD

L01EE    ldb   [<$0C,s]
         clra
         andb  #$DF
         tfr   d,x
         lbra  L0360
L01F9    ldx   $0C,s   D option
         ldb   $01,x
         lbeq  L0348
         ldd   #$002D  '-
         ldx   $0C,s
         leax  -$01,x
         stx   $0C,s
         stb   ,x
         ldd   #$0044  'D
         ldx   $0C,s
         stb   $01,x
         ldd   <u0027
         addd  #$0001
         std   <u0027
         subd  #$0001
         lslb
         rola
         leax  >$0343,y
         lbra  L0342
L0226    ldd   #$002D  '-
         ldx   $0C,s
         leax  -$01,x
         stx   $0C,s
         stb   ,x
         ldd   $0C,s
         std   <u0023
         lbra  L0348
L0238    ldd   #$0001
         std   <u0019
         lbra  L03BD
L0240    ldd   #$0001
         std   <u0007
         lbra  L03BD
L0248    ldd   #$0001
         std   <u0001  cflag
         lbra  L03BD
L0250    ldd   #$0001
         std   <u0015 pflag
         lbra  L03BD
L0258    ldd   #$0001
         std   <u0011
         lbra  L03BD
L0260    ldd   #$0001
         std   <u000B
         lbra  L03BD
L0268    ldd   #$0001
         std   <u000D
         lbra  L03BD
L0270    leax  >$0021,y
         stx   $0A,s
         leax  $0F,s
         bra   L0282
L027A    leax  >$001F,y
         stx   $0A,s
         bra   L0284
L0282    leas  -$0F,x
L0284    ldb   [<$0C,s]
         clra
         andb  #$5F
         stb   [<$0C,s]
         ldx   $0C,s
         ldb   $01,x
         lbeq  L0348
         ldd   #$002D  '-
         ldx   $0C,s
         leax  -$01,x
         stx   $0C,s
         stb   ,x
         ldd   $0C,s
         std   [<$0A,s]
         lbra  L0348
L02A8    ldx   $0C,s
         leax  $01,x
         stx   $0C,s
         ldb   ,x
         cmpb  #$3D  '=
         lbne  L0348
         ldd   $0C,s
         addd  #$0001
         pshs  b,a
         leax  >$0537,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
         ldb   >$0537,y
         lbeq  L0348
         ldd   <u0003
         addd  #$0001
         std   <u0003
         leax  >$0537,y
         pshs  x
         lbsr  L0C79
         leas  $02,s
         stb   $0E,s
         cmpb  #$63 'c
         beq   L02FA
         ldb   $0E,s
         cmpb  #$72 'r
         beq   L02FA
         ldb   $0E,s
         cmpb  #$43 'C
         beq   L02FA
         ldb   $0E,s
         cmpb  #$52 'R
         bne   L0348
L02FA    ldb   $0E,s
         sex
         pshs  b,a
         leax  >L0D51,pcr "Suffix '.%c' not allowed for output"
         pshs  x
         lbsr  L0C1E errexit
         leas  $04,s
         bra   L0348
L030C    ldx   $0C,s
         ldb   $01,x
         cmpb  #$3D
         bne   L0348
         ldd   <u0017
         cmpd  #$0004
         bne   L0327
         leax  >L0D75,pcr "Too many libraries"
         pshs  x
         lbsr  L0C1E errexit
         leas  $02,s
L0327    ldd   #$002D  '-
         ldx   $0C,s
         leax  -$01,x
         stx   $0C,s
         stb   ,x
         ldd   <u0017
         addd  #$0001
         std   <u0017
         subd  #$0001
         lslb
         rola
         leax  >$020F,y
L0342    leax  d,x
         ldd   $0C,s
         std   ,x
L0348    leax  $0F,s
         lbra  L03CC
L034D    ldb   [<$0C,s]
         sex
         pshs  b,a
         leax  >L0D88,pcr  "unknown flag : -%c\n"
         pshs  x
         lbsr  L0C1E errexit
         leas  $04,s
         bra   L03BD
L0360    cmpx  #$0044 'D
         lbeq  L01F9
         cmpx  #$004E 'N
         lbeq  L0226
         cmpx  #$0058 'X
         lbeq  L0238
         cmpx  #$0053 'S
         lbeq  L0240
         cmpx  #$0043 'C
         lbeq  L0248
         cmpx  #$0050 'P
         lbeq  L0250
         cmpx  #$004F 'O
         lbeq  L0258
         cmpx  #$0052 'R
         lbeq  L0260
         cmpx  #$0041 'A
         lbeq  L0268
         cmpx  #$0045 'E
         lbeq  L0270
         cmpx  #$004D 'M
         lbeq  L027A
         cmpx  #$0046 'F
         lbeq  L02A8
         cmpx  #$004C 'L
         lbeq  L030C
         bra   L034D     default case

L03BD    ldx   $0C,s
         leax  $01,x
         stx   $0C,s
         ldb   ,x
         lbne  L01EE
         lbra  L0445
L03CC    leas  -$0F,x   label: nomore
         lbra  L0445
L03D1    ldd   [<$15,s]
         pshs  b,a
         lbsr  L0C79
         leas  $02,s
         stb   $0E,s
         sex
         tfr   d,x
         bra   L041D
L03E2    ldd   #$0001
         std   <u0029
L03E7    ldd   <u0025
         leax  >$02DF,y
         leax  d,x
         ldb   $0E,s
         stb   ,x
         ldd   <u0025
         lslb
         rola
         leax  >$0217,y
         leax  d,x
         ldd   [<$15,s]
         std   ,x
         ldd   <u0025
         addd  #$0001
         std   <u0025
         bra   L0445
L040B    ldd   [<$15,s]
         pshs  b,a
         leax  >L0D9C,pcr "%s : no recognized suffix"
         pshs  x
         lbsr  L0C1E errexit
         leas  $04,s
         bra   L0445
L041D    cmpx  #$0052 'R
         beq   L03E2
         cmpx  #$0072 'r
         lbeq  L03E2
         cmpx  #$0041 'A
         beq   L03E7
         cmpx  #$0043 'C
         lbeq  L03E7
         cmpx  #$0061 'a
         lbeq  L03E7
         cmpx  #$0063 'c
         lbeq  L03E7
         bra   L040B  default case

L0445    ldd   <$13,s    while (--argc > 0 && (++s08 < 100)) {
         addd  #$FFFF
         std   <$13,s
         ble   L045F
         ldd   $08,s
         addd  #$0001
         std   $08,s
         cmpd  #$0064
         lblt  L01D5   end of loop
L045F    ldd   <u0025
         bne   L047D
         leax  >L0DB6,pcr "no files!"
         pshs  x
         leax  >$0088,y stderr
         pshs  x
         lbsr  L11A7 fprintf
         leas  $04,s
         clra
         clrb
         pshs  b,a
         lbsr  L1DAB exit(0)
         leas  $02,s
L047D    ldd   <u000D
         addd  <u000B
         cmpd  #$0001
         ble   L0496
         clra
         clrb
         pshs  b,a
         leax  >L0DC1,pcr "incompatible flags"
         pshs  x
         lbsr  L0C1E errexit
         leas  $04,s
L0496    ldd   <u0003
         beq   L04BB
         ldd   <u0025
         cmpd  #$0001
         ble   L04BB
         ldd   <u000D
         bne   L04AA
         ldd   <u000B
         beq   L04BB
L04AA    leax  >$0537,y
         pshs  x
         leax  >L0DD4,pcr "%s : output name not applicable"
         pshs  x
         lbsr  L0C1E errexit
         leas  $04,s
L04BB    ldd   <u0003
         bne   L04E0
         ldd   <u0025
         cmpd  #$0001
         bne   L04CF
         ldd   >$0217,y
         pshs  b,a
         bra   L04D5
L04CF    leax  >L0DF4,pcr "output"
         pshs  x
L04D5    leax  >$0537,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
L04E0    leax  >$002D,y
         pshs  x
         leax  >$0447,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
         leax  >L0DFB,pcr ".m"
         pshs  x
         leax  >$0447,y
         pshs  x
         lbsr  L19B6 strcat
         leas  $04,s
         leax  >$002D,y
         pshs  x
         leax  >$0483,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
         leax  >L0DFE,pcr ".r"
         pshs  x
         leax  >$0483,y
         pshs  x
         lbsr  L19B6 strcat
         leas  $04,s

         clra   Start of for loop
         clrb
         std   $08,s
         lbra  L09C5  jump to loop test
L052B    leax  >L0E01,pcr "echo '"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   $08,s
         lslb
         rola
         leax  >$0217,y
         leax  d,x
         ldd   ,x
         pshs  b,a
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0E08,pcr "'\n"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   $08,s
         leax  >$02DF,y
         leax  d,x
         ldb   ,x
         cmpb  #$43    'C
         beq   L0572
         ldd   $08,s
         leax  >$02DF,y
         leax  d,x
         ldb   ,x
         cmpb  #$63    'c
         lbne  L07FE
L0572    ldd   #$0001
         std   ,s
         leax  >$0447,y
         pshs  x
         leax  >$04BF,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
         ldd   #$006D
         pshs  b,a
         leax  >$04BF,y
         pshs  x
         lbsr  L0C53
         leas  $04,s
         leax  >L0E0B,pcr "-x\n"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0E1C,pcr "C.PREP "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   <u0001
         beq   L05BD
         leax  >L0E24,pcr "-l "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
L05BD    ldd   <u0021
         beq   L05D5
         ldd   <u0021
         pshs  b,a
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0E28,pcr " "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
L05D5    clra
         clrb
         std   $04,s
         bra   L0601
L05DB    ldd   $04,s
         addd  #$0001
         std   $04,s
         subd  #$0001
         lslb
         rola
         leax  >$0343,y
         leax  d,x
         ldd   ,x
         pshs  b,a
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0E2A,pcr " "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
L0601    ldd   $04,s
         cmpd  <u0027
         blt   L05DB
         ldd   $08,s
         lslb
         rola
         leax  >$0217,y
         leax  d,x
         ldd   ,x
         pshs  b,a
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0E2C,pcr " >"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$04BF,y
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$04BF,y
         pshs  x
         leax  >$04FB,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
         leax  >L0E2F,pcr "\n"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0E41,pcr  "C.PASS1 "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$04FB,y
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   <u0013
         beq   L0672
         leax  >L0E4A,pcr "-e "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
L0672    ldd   <u0007
         beq   L0681
         leax  >L0E4E,pcr " -s "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
L0681    ldd   <u0015 pflag
         beq   L0690
         leax  >L0E53,pcr " -p "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
L0690    leax  >$0447,y
         pshs  x
         leax  >$04BF,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
         ldd   #$0069 'i'
         pshs  b,a
         leax  >$04BF,y
         pshs  x
         lbsr  L0C53
         leas  $04,s
         leax  >L0E58,pcr " -o="
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$04BF,y
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   <u0013
         bne   L06EE
         leax  >L0E5D,pcr "\n del "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$04FB,y
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0E63,pcr "\n"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         bra   L06FF
L06EE    leax  >$04FB,y
         pshs  x
         leax  >$0573,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
L06FF    leax  >L0E65,pcr "echo c.pass2:\n"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0E74,pcr "C.PASS2 "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$04BF,y
         pshs  x
         leax  >$04FB,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
         leax  >$04FB,y
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   <u0007
         beq   L0740
         leax  >L0E7D,pcr " -s "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
L0740    ldd   <u0015 pflag
         beq   L074F
         leax  >L0E82,pcr " -p "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
L074F    ldd   <u0013
         beq   L0769
         leax  >L0E87,pcr " "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$0573,y
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
L0769    ldd   <u000D
         beq   L079B
         ldd   <u0003
         beq   L0782
         leax  >$0537,y
         pshs  x
         leax  >$04BF,y
         pshs  x
         lbsr  L199C strcpy
         bra   L07A9
L0782    ldd   $08,s
         lslb
         rola
         leax  >$0217,y
         leax  d,x
         ldd   ,x
         pshs  b,a
         leax  >$04BF,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
L079B    ldd   #$0061 'a
         pshs  b,a
         leax  >$04BF,y
         pshs  x
         lbsr  L0C53
L07A9    leas  $04,s
         leax  >L0E89,pcr " -o="
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$04BF,y
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0E8E,pcr "\n del "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$04FB,y
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   <u0013
         beq   L07F1
         leax  >L0E94,pcr " "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$0573,y
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
L07F1    leax  >L0E96,pcr "\n"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         bra   L0802
L07FE    clra
         clrb
         std   ,s
L0802    ldd   <u000D
         lbne  L09BE
         ldd   $08,s
         leax  >$02DF,y
         leax  d,x
         ldb   ,x
         cmpb  #$52  'R
         lbeq  L09BE
         ldd   $08,s
         leax  >$02DF,y
         leax  d,x
         ldb   ,x
         cmpb  #$72  'r
         lbeq  L09BE
         ldd   $08,s
         leax  >$02DF,y
         leax  d,x
         ldb   ,x
         cmpb  #$41  'A
         beq   L0844
         ldd   $08,s
         leax  >$02DF,y
         leax  d,x
         ldb   ,x
         cmpb  #$61  'a
         bne   L0854
L0844    ldd   $08,s
         lslb
         rola
         leax  >$0217,y
         leax  d,x
         ldd   ,x
         pshs  b,a
         bra   L085A
L0854    leax  >$04BF,y
         pshs  x
L085A    leax  >$04FB,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
         ldd   <u0011
         lbne  L0904
         leax  >L0E98,pcr "echo c.opt:\n"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0EA5,pcr "C.OPT "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$04FB,y
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$0447,y
         pshs  x
         leax  >$04BF,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
         ldd   #$006F 'o
         pshs  b,a
         leax  >$04BF,y
         pshs  x
         lbsr  L0C53
         leas  $04,s
         leax  >L0EAC,pcr " "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$04BF,y
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0EAE,pcr "\n"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   ,s
         beq   L08F3
         leax  >L0EB0,pcr "del "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$04FB,y
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0EB5,pcr "\n"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
L08F3    leax  >$04BF,y
         pshs  x
         leax  >$04FB,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
L0904    leax  >L0EB7,pcr "echo c.asm:\n"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0EC4,pcr "C.ASM "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$04FB,y
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   <u0025
         cmpd  #$0001
         bne   L0939
         ldd   <u000B
         bne   L0939
         leax  >$0483,y
L0935    pshs  x
         bra   L096D
L0939    ldd   <u0003
         beq   L0947
         ldd   <u000B
         beq   L0947
         leax  >$0537,y
         bra   L0935
L0947    ldd   #$0072 'r
         pshs  b,a
         ldd   $0A,s
         lslb
         rola
         leax  >$0217,y
         leax  d,x
         ldd   ,x
         pshs  b,a
         lbsr  L0C53
         leas  $04,s
         ldd   $08,s
         lslb
         rola
         leax  >$0217,y
         leax  d,x
         ldd   ,x
         pshs  b,a
L096D    leax  >$04BF,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
         leax  >L0ECB,pcr " -o="
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$04BF,y
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0ED0,pcr "\n"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   ,s
         beq   L09BE
         leax  >L0ED2,pcr "del "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$04FB,y
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0ED7,pcr "\n"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
L09BE    ldd   $08,s
         addd  #$0001
         std   $08,s
L09C5    ldd   $08,s
         cmpd  <u0025
         lblt  L052B

         ldd   <u000D
         lbne  L0B31              FORSKEL
         ldd   <u000B
         lbne  L0B31
         ldd   <u0003
         bne   L09ED
         clra
         clrb
         pshs  b,a
         leax  >$0537,y
         pshs  x
         lbsr  L0C53
         leas  $04,s
L09ED    leax  >L0ED9,pcr "echo c.link:\n"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0EE7,pcr "C.LINK "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0EEF,pcr  "/d0"
         stx   $0C,s
         ldd   $0C,s
         pshs  b,a
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0EF3,pcr "/lib/cstart.r"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   <u0025
         cmpd  #$0001
         bne   L0A4F
         ldb   >$02DF,y
         cmpb  #$52   'R
         beq   L0A4F
         ldb   >$02DF,y
         cmpb  #$72   'r
         beq   L0A4F
         leax  >L0F01,pcr " "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$04BF,y
         stx   <u001D
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         bra   L0A83
L0A4F    clra
         clrb
         bra   L0A76
L0A53    leax  >L0F03,pcr " "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   $08,s
         lslb
         rola
         leax  >$0217,y
         leax  d,x
         ldd   ,x
         pshs  b,a
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   $08,s
         addd  #$0001
L0A76    std   $08,s
         ldd   $08,s
         cmpd  <u0025
         blt   L0A53
         clra
         clrb
         std   <u001D
L0A83    leax  >L0F05,pcr " -o="
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >$0537,y
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         clra
         clrb
         bra   L0AC0
L0A9D    leax  >L0F0A,pcr " "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   $06,s
         lslb
         rola
         leax  >$020F,y
         leax  d,x
         ldd   ,x
         pshs  b,a
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   $06,s
         addd  #$0001
L0AC0    std   $06,s
         ldd   $06,s
         cmpd  <u0017
         blt   L0A9D
         leax  >L0F0C,pcr " -l="
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   $0C,s
         pshs  b,a
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0F11,pcr "/lib/clib.l "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   <u0023
         pshs  b,a
         lbsr  L0BFC zfunc1
         leas  $02,s
         ldd   <u0021
         pshs  b,a
         lbsr  L0BFC zfunc1
         leas  $02,s
         ldd   <u001F
         pshs  b,a
         lbsr  L0BFC zfunc1
         leas  $02,s
         leax  >L0F1E,pcr "\n"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   <u001D
         beq   L0B31
         leax  >L0F20,pcr "del "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
         ldd   <u001D
         pshs  b,a
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0F25,pcr "\n"
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
L0B31    ldd   <u002B ptr to c.com file descriptor
         pshs  b,a
         lbsr  L178B  fclose? fflush?
         leas  $02,s
         ldd   <u0019
         lbne  L0BA7
         leax  >L0F27,pcr "-t -p"
         pshs  x
         leax  >$040B,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
         leax  >$006E,y
         pshs  x
         leax  >L0F2E,pcr "r"
         pshs  x
         leax  >$0041,y "c.com"?
         pshs  x
         lbsr  L112E
         leas  $06,s
         std   -$02,s
         bne   L0B7D
         leax  >$0041,y "c.com"?
         pshs  x
         leax  >L0F30,pcr "can't reopen '%s'"
         pshs  x
         lbsr  L0C1E errexit
         leas  $04,s
L0B7D    clra
         clrb
         pshs  b,a
         ldd   #$0001
         pshs  b,a
         ldd   #$0001
         pshs  b,a
         leax  >$040B,y
         pshs  x
         leax  >$040B,y
         pshs  x
         lbsr  L198B strlen?
         std   ,s
         leax  >L0F42,pcr "shell"
         pshs  x
         lbsr  L1D1E
         leas  $0C,s
L0BA7    leas  $0F,s
         puls  pc,u

* getdev
*
L0BAB    pshs  u
         ldd   #$FFB4
         lbsr  stkcheck
         leas  -$02,s
         clra
         clrb
         pshs  b,a
         ldd   #$0004
         pshs  b,a
         leax  >L0F48,pcr  "ccdevice"
         pshs  x
         lbsr  modlink
         leas  $06,s
         tfr   d,u
         cmpu  #$FFFF
         bne   L0BD6
         lbsr  L0F53
         bra   L0BF8         FORSKEL
L0BD6    pshs  u
         ldd   $9,u
         addd  ,s++
         std   ,s
         pshs  b,a
         leax  >$05A5,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
         pshs  u
         lbsr  L1C65 unlink
         leas  $02,s
         leax  >$05A5,y
         tfr   x,d
L0BF8    puls  pc,u,x
         puls  pc,u,x

L0BFC    pshs  u
         ldd   #$FFBA
         lbsr  stkcheck
         ldd   $04,s
         beq   L0C1C
         ldd   $04,s
         pshs  b,a
         lbsr  L0CBF wrtcom
         leas  $02,s
         leax  >L0F51,pcr  " "
         pshs  x
         lbsr  L0CBF wrtcom
         leas  $02,s
L0C1C    puls  pc,u


* Error exit function
L0C1E    pshs  u
         ldd   #$FFB6
         lbsr  stkcheck
         ldd   $06,s
         pshs  b,a
         ldd   $06,s
         pshs  b,a
         leax  >$0088,y stderr
         pshs  x
         lbsr  L11A7 fprintf
         leas  $06,s
         leax  >$0088,y stderr
         pshs  x
         ldd   #$000D
         pshs  b,a
         lbsr  L169B putc
         leas  $04,s
         ldd   #$0001
         pshs  b,a
         lbsr  L1DAB exit(1)
         puls  pc,u,x


* Check for period?
L0C53    pshs  u
         ldd   #$FFC0
         lbsr  stkcheck
         ldu   $04,s
L0C5D    ldb   ,u+
         bne   L0C5D  Find end of string
         ldb   -3,u  Period at 3 from end?
         cmpb  #$2E '.
         beq   L0C69 ..yes
         puls  pc,u
L0C69    ldb   $07,s
         bne   L0C73 bra if '\0' given as argument
         clra
         clrb
         stb   -3,u  append '\0'
         bra   L0C77
L0C73    ldb   $07,s
         stb   -2,u
L0C77    puls  pc,u

L0C79    pshs  u
         ldd   #$FFBD
         lbsr  stkcheck
         ldu   $04,s
         leas  -$03,s
L0C85    clra
         clrb
         bra   L0C94
L0C89    ldb   ,s
         cmpb  #$2F  '/
         beq   L0C85
         ldd   $01,s
         addd  #$0001
L0C94    std   $01,s
         ldb   ,u+
         stb   ,s
         bne   L0C89
         ldd   $01,s
         cmpd  #$001D
         bgt   L0CB9
         ldd   $01,s
         cmpd  #$0002
         ble   L0CB9
         ldb   -3,u
         cmpb  #$2E  '.
         bne   L0CB9
         ldb   -2,u
         sex
         orb   #$40
         bra   L0CBB
L0CB9    clra
         clrb
L0CBB    leas  $03,s
         puls  pc,u

* Write to c.com
* wrtcom
L0CBF    pshs  u
         ldd   #$FFB8
         lbsr  stkcheck
         ldd   $04,s
         pshs  b,a
         ldd   <u002B ccomfd
         pshs  b,a
         lbsr  L11A7 fprintf
         leas  $04,s
         puls  pc,u

******************************************
* Text constants
*
L0CD6    fcc "CC1 VERSION %s"
         fcb  $0D
         fcc  "COPYRIGHT 1983 MICROWARE"
         fcb  $0D
         fcc  "REPRODUCED UNDER LICENSE"
         fcb  $0D
         fcc  "TO DRAGON DATA, LTD."
         fcb  $0D
         fcb  0

L0D2D    fcc  "1.1"
         fcb  0
L0D31    fcc  "w"
         fcb  0
L0D33    fcc  "can't open shell command file"
         fcb  0
L0D51    fcc  "Suffix '.%c' not allowed for output"
         fcb  0
L0D75    fcc  "Too many libraries"
         fcb  0
L0D88    fcc  "unknown flag : -%c"
         fcb  $0D
         fcb  0
L0D9C    fcc "%s : no recognized suffix"
         fcb  0
L0DB6    fcc  "no files!"
         fcb  $0D
         fcb  0
L0DC1    fcc  "incompatible flags"
         fcb  0
L0DD4    fcc  "%s : output name not applicable"
         fcb  0
L0DF4    fcc  "output"
         fcb  0
L0DFB    fcc  ".m"
         fcb  0

L0DFE    fcc ".r"
         fcb  0
L0E01    fcc "echo '"
         fcb  0
L0E08    fcc "'"
         fcb  $0D
         fcb  0
L0E0B    fcc "-x"
         fcb  $0D
L0E0E    fcc "echo c.prep:"
         fcb  $0D
         fcb  0
L0E1C    fcc  "C.PREP "
         fcb  0

L0E24    fcc "-l "
         fcb  0
L0E28    fcc " "
         fcb  0
L0E2A    fcc " "
         fcb  0
L0E2C    fcc " >"
         fcb  0

L0E2F    fcb  $0D
         fcb  'x
         fcb  $0D
L0E32    fcc  "echo c.pass1:"
         fcb  $0D
         fcb  0

L0E41    fcc  "C.PASS1 "
         fcb  0

L0E4A    fcc "-e "
         fcb  0
L0E4E    fcc " -s "
         fcb  0

L0E53    fcc  " -p "
         fcb  0
L0E58    fcc  " -o="
         fcb  0

L0E5D    fcb  $0D
         fcc  "del "
         fcb  0
L0E63    fcb  $0D
         fcb  0
L0E65    fcc  "echo c.pass2:"
         fcb  $0D
         fcb  0
L0E74    fcc  "C.PASS2 "
         fcb  0

L0E7D    fcc  " -s "
         fcb  0
L0E82    fcc  " -p "
         fcb  0
L0E87    fcb  $20,0
L0E89    fcc  " -o="
         fcb  0
L0E8E    fcb  $0D
         fcc  "del "
         fcb  0
L0E94    fcb  $20,0
L0E96    fcb  $0D,0
L0E98    fcc  "echo c.opt:"
         fcb  $0D,0

L0EA5    fcc  "C.OPT "
         fcb  0

L0EAC    fcb  $20,0
L0EAE    fcb  $0D,0
L0EB0    fcc  "del "
         fcb  0
L0EB5    fcb  $0D
         fcb  0
L0EB7    fcc  "echo c.asm:"
         fcb  $0D
         fcb  0
L0EC4    fcc  "C.ASM "
         fcb  0
L0ECB    fcc  " -o="
         fcb  0
L0ED0    fcb  $0D,0
L0ED2    fcc  "del "
         fcb  0
L0ED7    fcb  $0D,0

L0ED9    fcc  "echo c.link:"
         fcb  $0D
         fcb  0
L0EE7    fcc  "C.LINK "
         fcb  0
L0EEF    fcc  "/d0"
         fcb  0
L0EF3    fcc  "/lib/cstart.r"
         fcb  0
L0F01    fcb  $20,0
L0F03    fcb  $20,0
L0F05    fcc  " -o="
         fcb  0
L0F0A    fcb  $20,0
L0F0C    fcc  " -l="
         fcb  0
L0F11    fcc "/lib/clib.l "
         fcb 0
L0F1E    fcb $0D
         fcb 0
L0F20    fcc "del "
         fcb 0
L0F25    fcb $0D
         fcb 0
L0F27    fcc "-t -p"
         fcb $0D
         fcb 0
L0F2E    fcb   $72 r
         fcb $0
L0F30    fcc  "can't reopen '%s'"
         fcb $0
L0F42    fcc "shell"
         fcb $0

L0F48    fcc "ccdevice"
         fcb $0
L0F51    fcb $20
         fcb 0

*************************************
* C library
*

* defdrive?
L0F53    pshs  u
L0F55    leas  -$07,s
         clra
         clrb
         pshs  b,a
         ldd   #$000C
         pshs  b,a
         leax  >L0FB4,pcr "Init"
L0F64    pshs  x
         lbsr  modlink
         leas  $06,s
         std   ,s
         cmpd  #$FFFF
         beq   L0FAE
         ldd   ,s
         ldx   ,s
L0F77    addd  <$10,x
L0F7A    std   $05,s
         leau  >$05B9,y
         bra   L0F86
L0F82    ldb   $04,s
         stb   ,u+
L0F86    ldx   $05,s
L0F88    leax  $01,x
         stx   $05,s
         ldb   -$01,x
         stb   $04,s
         bgt   L0F82
         ldb   $04,s
         clra
         andb  #$7F
         stb   ,u+
         clra
         clrb
         stb   ,u
         ldd   ,s
         pshs  b,a
         lbsr  L1C65
         leas  $02,s
         leax  >$05B9,y
         tfr   x,d
         bra   L0FB0
L0FAE    clra
         clrb
L0FB0    leas  $07,s
         puls  pc,u

L0FB4     fcc "Init"
         fcb 0

* Unknown
L0FB9    pshs u
         leau  >$006E,y
L0FBF    ldd   6,u
         clra
         andb  #$03
         lbeq  L1030
         leau  u000D,u
         pshs  u
         leax  >$013E,y
         cmpx  ,s++
         bhi   L0FBF
         ldd   #$00C8
         std   >$020D,y
         lbra  L1034
         puls  pc,u
L0FE0    pshs  u
         ldu   $08,s
         bne   L0FEA
         bsr   L0FB9
         tfr   d,u
L0FEA    stu   -$02,s
         beq   L1034
         ldd   $04,s
         std   u0008,u
         ldx   $06,s
         ldb   $01,x
         cmpb  #$2B
         beq   L1002
         ldx   $06,s
         ldb   $02,x
         cmpb  #$2B
         bne   L1008
L1002    ldd   u0006,u
         orb   #$03
         bra   L1026
L1008    ldd   u0006,u
         pshs  b,a
         ldb   [<$08,s]
         cmpb  #$72
         beq   L101A
         ldb   [<$08,s]
         cmpb  #$64
         bne   L101F
L101A    ldd   #$0001
         bra   L1022
L101F    ldd   #$0002
L1022    ora   ,s+
         orb   ,s+
L1026    std   u0006,u
         ldd   u0002,u
         addd  u000B,u
         std   u0004,u
         std   ,u
L1030    tfr   u,d
         puls  pc,u
L1034    clra
         clrb
         puls  pc,u


L1038    pshs  u
         ldu   $04,s
         leas  -$04,s
         clra
         clrb
         std   ,s
         ldx   $0A,s
         ldb   $01,x
         sex
         tfr   d,x
         bra   L1069
L104B    ldx   $0A,s
         ldb   $02,x
         cmpb  #$2B
         bne   L1058
         ldd   #$0007
         bra   L1060
L1058    ldd   #$0004
         bra   L1060
L105D    ldd   #$0003
L1060    std   ,s
         bra   L1079
L1064    leax  $04,s
         lbra  L10D1
L1069    stx   -$02,s
         beq   L1079
         cmpx  #$0078
         beq   L104B
         cmpx  #$002B
         beq   L105D
         bra   L1064
L1079    ldb   [<$0A,s]
         sex
         tfr   d,x
         lbra  L10DE
L1082    ldd   ,s
         orb   #$01
         bra   L10C4
L1088    ldd   ,s
         orb   #$02
         pshs  b,a
         pshs  u
         lbsr  L1B03
         leas  $04,s
         std   $02,s
         cmpd  #$FFFF
         beq   L10B3
         ldd   #$0002
         pshs  b,a
         clra
         clrb
         pshs  b,a
         pshs  b,a
         ldd   $08,s
         pshs  b,a
         lbsr  L1BD5
         leas  $08,s
         bra   L10F8
L10B3    ldd   ,s
         orb   #$02
         pshs  b,a
         pshs  u
         lbsr  L1B24
         bra   L10CB
L10C0    ldd   ,s
         orb   #$81
L10C4    pshs  b,a
         pshs  u
         lbsr  L1B03
L10CB    leas  $04,s
         std   $02,s
         bra   L10F8
L10D1    leas  -$04,x
L10D3    ldd   #$00CB
         std   >$020D,y
         clra
         clrb
         bra   L10FA
L10DE    cmpx  #$0072
         lbeq  L1082
         cmpx  #$0061
         lbeq  L1088
         cmpx  #$0077
         beq   L10B3
         cmpx  #$0064
         beq   L10C0
         bra   L10D3
L10F8    ldd   $02,s
L10FA    leas  $04,s
         puls  pc,u
         pshs  u
         clra
         clrb
         pshs  b,a
         ldd   $08,s
         pshs  b,a
         ldd   $08,s
         pshs  b,a
         lbra  L115A

L110F    pshs  u
         ldd   $06,s
         pshs  b,a
         ldd   $06,s
         pshs  b,a
         lbsr  L1038
         leas  $04,s
         tfr   d,u
         cmpu  #$FFFF
         bne   L112A
         clra
         clrb
         bra   L115F
L112A    clra
         clrb
         bra   L1152
L112E    pshs  u
         ldd   $08,s
         pshs  b,a
         lbsr  L178B
         leas  $02,s
         ldd   $06,s
         pshs  b,a
         ldd   $06,s
         pshs  b,a
         lbsr  L1038
         leas  $04,s
         tfr   d,u
         stu   -$02,s
         bge   L1150
         clra
         clrb
         bra   L115F
L1150    ldd   $08,s
L1152    pshs  b,a
         ldd   $08,s
         pshs  b,a
         pshs  u
L115A    lbsr  L0FE0
         leas  $06,s
L115F    puls  pc,u

L1161    pshs  u,b,a
         ldu   $06,s
         bra   L1169
L1167    leau  1,u
L1169    ldb   ,u
         sex
         std   ,s
         beq   L1178
         ldd   ,s
         cmpd  #$0058 'X
         bne   L1167
L1178    ldd   ,s
         beq   L118E
         lbsr  L1D58
         pshs  b,a
         leax  >L1192,pcr  "%d"
         pshs  x
         pshs  u
         lbsr  L11C3
         leas  $06,s
L118E    ldd   $06,s
         puls  pc,u,x

L1192    fcb  '%,'d,0

L1195    pshs  u
         leax  >$007B,y
         stx   >$05C5,y
         leax  $06,s
         pshs  x
         ldd   $06,s
         bra   L11B5

* fprintf?
L11A7    pshs  u
         ldd   $04,s
         std   >$05C5,y
         leax  $08,s
         pshs  x
         ldd   $08,s
L11B5    pshs  b,a
         leax  >L166F,pcr
         pshs  x
         bsr   L11E7
         leas  $06,s
         puls  pc,u
L11C3    pshs  u
         ldd   $04,s
         std   >$05C5,y
         leax  $08,s
         pshs  x
         ldd   $08,s
         pshs  b,a
         leax  >L1682,pcr
         pshs  x
         bsr   L11E7
         leas  $06,s
         clra
         clrb
         stb   [>$05C5,y]
         ldd   $04,s
         puls  pc,u
L11E7    pshs  u
         ldu   $06,s
         leas  -$0B,s
         bra   L11FF
L11EF    ldb   $08,s
         lbeq  L1430
         ldb   $08,s
         sex
L11F8    pshs  b,a
         jsr   [<$11,s]
         leas  $02,s
L11FF    ldb   ,u+
         stb   $08,s
         cmpb  #$25
         bne   L11EF
         ldb   ,u+
         stb   $08,s
         clra
         clrb
         std   $02,s
         std   $06,s
         ldb   $08,s
         cmpb  #$2D
         bne   L1224
         ldd   #$0001
         std   >$05DB,y
         ldb   ,u+
         stb   $08,s
         bra   L122A
L1224    clra
         clrb
         std   >$05DB,y
L122A    ldb   $08,s
         cmpb  #$30
         bne   L1235
         ldd   #$0030
         bra   L1238
L1235    ldd   #$0020
L1238    std   >$05DD,y
         bra   L1258
L123E    ldd   $06,s
         pshs  b,a
         ldd   #$000A
         lbsr  L1A12
         pshs  b,a
         ldb   $0A,s
         sex
         addd  #$FFD0
         addd  ,s++
         std   $06,s
         ldb   ,u+
         stb   $08,s
L1258    ldb   $08,s
         sex
         leax  >$013F,y
         leax  d,x
         ldb   ,x
         clra
         andb  #$08
         bne   L123E
         ldb   $08,s
         cmpb  #$2E
         bne   L12A1
         ldd   #$0001
         std   $04,s
         bra   L128B
L1275    ldd   $02,s
         pshs  b,a
         ldd   #$000A
         lbsr  L1A12
         pshs  b,a
         ldb   $0A,s
         sex
         addd  #$FFD0
         addd  ,s++
         std   $02,s
L128B    ldb   ,u+
         stb   $08,s
         ldb   $08,s
         sex
         leax  >$013F,y
         leax  d,x
         ldb   ,x
         clra
         andb  #$08
         bne   L1275
         bra   L12A5
L12A1    clra
         clrb
         std   $04,s
L12A5    ldb   $08,s
         sex
         tfr   d,x
         lbra  L13D3
L12AD    ldd   $06,s
         pshs  b,a
         ldx   <$15,s
         leax  $02,x
         stx   <$15,s
         ldd   -$02,x
         pshs  b,a
         lbsr  L1434
         bra   L12D5
L12C2    ldd   $06,s
         pshs  b,a
         ldx   <$15,s
         leax  $02,x
         stx   <$15,s
         ldd   -$02,x
         pshs  b,a
         lbsr  L14F5
L12D5    std   ,s
         lbra  L13B9
L12DA    ldd   $06,s
         pshs  b,a
         ldb   $0A,s
         sex
         leax  >$013F,y
         leax  d,x
         ldb   ,x
         clra
         andb  #$02
         pshs  b,a
         ldx   <$17,s
         leax  $02,x
         stx   <$17,s
         ldd   -$02,x
         pshs  b,a
         lbsr  L153B
         lbra  L13B5
L1300    ldd   $06,s
         pshs  b,a
         ldx   <$15,s
         leax  $02,x
         stx   <$15,s
         ldd   -$02,x
         pshs  b,a
         leax  >$05C7,y
         pshs  x
         lbsr  L147C
         lbra  L13B5
L131C    ldd   $04,s
         bne   L1325
         ldd   #$0006
         std   $02,s
L1325    ldd   $06,s
         pshs  b,a
         leax  <$15,s
         pshs  x
         ldd   $06,s
         pshs  b,a
         ldb   $0E,s
         sex
         pshs  b,a
         lbsr  L1980
         leas  $06,s
         lbra  L13B7
L133F    ldx   <$13,s
         leax  $02,x
         stx   <$13,s
         ldd   -$02,x
         lbra  L13C9
L134C    ldx   <$13,s
         leax  $02,x
         stx   <$13,s
         ldd   -$02,x
         std   $09,s
         ldd   $04,s
         beq   L1394
         ldd   $09,s
         std   $04,s
         bra   L136E
L1362    ldb   [<$09,s]
         beq   L137A
         ldd   $09,s
         addd  #$0001
         std   $09,s
L136E    ldd   $02,s
         addd  #$FFFF
         std   $02,s
         subd  #$FFFF
         bne   L1362
L137A    ldd   $06,s
         pshs  b,a
         ldd   $0B,s
         subd  $06,s
         pshs  b,a
         ldd   $08,s
         pshs  b,a
         ldd   <$15,s
         pshs  b,a
         lbsr  L15A6
         leas  $08,s
         bra   L13C3
L1394    ldd   $06,s
         pshs  b,a
         ldd   $0B,s
         bra   L13B7
L139C    ldb   ,u+
         stb   $08,s
         bra   L13A4
         leas  -$0B,x
L13A4    ldd   $06,s
         pshs  b,a
         leax  <$15,s
         pshs  x
         ldb   $0C,s
         sex
         pshs  b,a
         lbsr  L1942
L13B5    leas  $04,s
L13B7    pshs  b,a
L13B9    ldd   <$13,s
         pshs  b,a
         lbsr  L1608
         leas  $06,s
L13C3    lbra  L11FF
L13C6    ldb   $08,s
         sex
L13C9    pshs  b,a
         jsr   [<$11,s]
         leas  $02,s
         lbra  L11FF
L13D3    cmpx  #$0064  'd
         lbeq  L12AD
         cmpx  #$006F
         lbeq  L12C2
         cmpx  #$0078
         lbeq  L12DA
         cmpx  #$0058
         lbeq  L12DA
         cmpx  #$0075
         lbeq  L1300
         cmpx  #$0066
         lbeq  L131C
         cmpx  #$0065
         lbeq  L131C
         cmpx  #$0067
         lbeq  L131C
         cmpx  #$0045
         lbeq  L131C
         cmpx  #$0047
         lbeq  L131C
         cmpx  #$0063
         lbeq  L133F
         cmpx  #$0073
         lbeq  L134C
         cmpx  #$006C
         lbeq  L139C
         bra   L13C6
L1430    leas  $0B,s
         puls  pc,u
L1434    pshs  u,b,a
         leax  >$05C7,y
         stx   ,s
         ldd   $06,s
         bge   L1468
         ldd   $06,s
         nega
         negb
         sbca  #$00
         std   $06,s
         bge   L145D
         leax  >L1694,pcr "-32768"
         pshs  x
         leax  >$05C7,y
         pshs  x
         lbsr  L199C strcpy
         leas  $04,s
         puls  pc,u,x
L145D    ldd   #$002D
         ldx   ,s
         leax  $01,x
         stx   ,s
         stb   -$01,x
L1468    ldd   $06,s
         pshs  b,a
         ldd   $02,s
         pshs  b,a
         bsr   L147C
         leas  $04,s
         leax  >$05C7,y
         tfr   x,d
         puls  pc,u,x
L147C    pshs  u,y,x,b,a
         ldu   $0A,s
         clra
         clrb
         std   $02,s
         clra
         clrb
         std   ,s
         bra   L1499
L148A    ldd   ,s
         addd  #$0001
         std   ,s
         ldd   $0C,s
         subd  >$0061,y
         std   $0C,s
L1499    ldd   $0C,s
         blt   L148A
         leax  >$0061,y
         stx   $04,s
         bra   L14DB
L14A5    ldd   ,s
         addd  #$0001
         std   ,s
L14AC    ldd   $0C,s
         subd  [<$04,s]
         std   $0C,s
         bge   L14A5
         ldd   $0C,s
         addd  [<$04,s]
         std   $0C,s
         ldd   ,s
         beq   L14C5
         ldd   #$0001
         std   $02,s
L14C5    ldd   $02,s
         beq   L14D0
         ldd   ,s
         addd  #$0030
         stb   ,u+
L14D0    clra
         clrb
         std   ,s
         ldd   $04,s
         addd  #$0002
         std   $04,s
L14DB    ldd   $04,s
         cmpd  >$0069,y
         bne   L14AC
         ldd   $0C,s
         addd  #$0030
         stb   ,u+
         clra
         clrb
         stb   ,u
         ldd   $0A,s
         leas  $06,s
         puls  pc,u
L14F5    pshs  u,b,a
         leax  >$05C7,y
         stx   ,s
         leau  >$05D1,y
L1501    ldd   $06,s
         clra
         andb  #$07
         addd  #$0030
         stb   ,u+
         ldd   $06,s
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         std   $06,s
         bne   L1501
         bra   L1523
L1519    ldb   ,u
         ldx   ,s
         leax  $01,x
         stx   ,s
         stb   -$01,x
L1523    leau  -1,u
         pshs  u
         leax  >$05D1,y
         cmpx  ,s++
         bls   L1519
         clra
         clrb
         stb   [,s]
         leax  >$05C7,y
         tfr   x,d
         puls  pc,u,x
L153B    pshs  u,x,b,a
         leax  >$05C7,y
         stx   $02,s
         leau  >$05D1,y
L1547    ldd   $08,s
         clra
         andb  #$0F
         std   ,s
         pshs  b,a
         ldd   $02,s
         cmpd  #$0009
         ble   L1569
         ldd   $0C,s
         beq   L1561
         ldd   #$0041
         bra   L1564
L1561    ldd   #$0061
L1564    addd  #$FFF6
         bra   L156C
L1569    ldd   #$0030
L156C    addd  ,s++
         stb   ,u+
         ldd   $08,s
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         anda  #$0F
         std   $08,s
         bne   L1547
         bra   L158C
L1582    ldb   ,u
         ldx   $02,s
         leax  $01,x
         stx   $02,s
         stb   -$01,x
L158C    leau  -1,u
         pshs  u
         leax  >$05D1,y
         cmpx  ,s++
         bls   L1582
         clra
         clrb
         stb   [<$02,s]
         leax  >$05C7,y
         tfr   x,d
         lbra  L167E
L15A6    pshs  u
         ldu   $06,s
         ldd   $0A,s
         subd  $08,s
         std   $0A,s
         ldd   >$05DB,y
         bne   L15DB
         bra   L15C3
L15B8    ldd   >$05DD,y
         pshs  b,a
         jsr   [<$06,s]
         leas  $02,s
L15C3    ldd   $0A,s
         addd  #$FFFF
         std   $0A,s
         subd  #$FFFF
         bgt   L15B8
         bra   L15DB
L15D1    ldb   ,u+
         sex
         pshs  b,a
         jsr   [<$06,s]
         leas  $02,s
L15DB    ldd   $08,s
         addd  #$FFFF
         std   $08,s
         subd  #$FFFF
         bne   L15D1
         ldd   >$05DB,y
         beq   L1606
         bra   L15FA
L15EF    ldd   >$05DD,y
         pshs  b,a
         jsr   [<$06,s]
         leas  $02,s
L15FA    ldd   $0A,s
         addd  #$FFFF
         std   $0A,s
         subd  #$FFFF
         bgt   L15EF
L1606    puls  pc,u
L1608    pshs  u
         ldu   $06,s
         ldd   $08,s
         pshs  b,a
         pshs  u
         lbsr  L198B
         leas  $02,s
         nega
         negb
         sbca  #$00
         addd  ,s++
         std   $08,s
         ldd   >$05DB,y
         bne   L164A
         bra   L1632
L1627    ldd   >$05DD,y
         pshs  b,a
         jsr   [<$06,s]
         leas  $02,s
L1632    ldd   $08,s
         addd  #$FFFF
         std   $08,s
         subd  #$FFFF
         bgt   L1627
         bra   L164A
L1640    ldb   ,u+
         sex
         pshs  b,a
         jsr   [<$06,s]
         leas  $02,s
L164A    ldb   ,u
         bne   L1640
         ldd   >$05DB,y
         beq   L166D
         bra   L1661
L1656    ldd   >$05DD,y
         pshs  b,a
         jsr   [<$06,s]
         leas  $02,s
L1661    ldd   $08,s
         addd  #$FFFF
         std   $08,s
         subd  #$FFFF
         bgt   L1656
L166D    puls  pc,u
L166F    pshs  u
         ldd   >$05C5,y
         pshs  b,a
         ldd   $06,s
         pshs  b,a
         lbsr  L169B putc
L167E    leas  $04,s
         puls  pc,u
L1682    pshs  u
         ldd   $04,s
         ldx   >$05C5,y
         leax  $01,x
         stx   >$05C5,y
         stb   -$01,x
         puls  pc,u

L1694    fcc  "-32768"
         fcb 0

L169B pshs u
         ldu   $06,s
         ldd   u0006,u
         anda  #$80
         andb  #$22
         cmpd  #$8002
         beq   L16BF
         ldd   u0006,u
         clra
         andb  #$22
         cmpd  #$0002
         lbne  L17D5
         pshs  u
         lbsr  L18B2
         leas  $02,s
L16BF    ldd   u0006,u
         clra
         andb  #$04
         beq   L16FB
         ldd   #$0001
L16C9    pshs  b,a
         leax  $07,s
         pshs  x
         ldd   u0008,u
         pshs  b,a
         ldd   u0006,u
         clra
         andb  #$40
         beq   L16E0
         leax  >L1BC5,pcr
         bra   L16E4
L16E0    leax  >L1BAC,pcr
L16E4    tfr   x,d
         tfr   d,x
         jsr   ,x
         leas  $06,s
         cmpd  #$FFFF
         bne   L173C
         ldd   u0006,u
         orb   #$20
         std   u0006,u
         lbra  L17D5
L16FB    ldd   u0006,u
         anda  #$01
         clrb
         std   -$02,s
         bne   L170B
         pshs  u
         lbsr  L17F0
         leas  $02,s
L170B    ldd   ,u
         addd  #$0001
         std   ,u
         subd  #$0001
         tfr   d,x
         ldd   $04,s
         stb   ,x
         ldd   ,u
         cmpd  u0004,u
         bcc   L1731
         ldd   u0006,u
         clra
         andb  #$40
         beq   L173C
         ldd   $04,s
         cmpd  #$000D
         bne   L173C
L1731    pshs  u
         lbsr  L17F0
         std   ,s++
         lbne  L17D5
L173C    ldd   $04,s
         puls  pc,u
         pshs  u
         ldu   $04,s
         ldd   $06,s
         pshs  b,a
         pshs  u
         ldd   #$0008
         lbsr  L1A71
         pshs  b,a
         lbsr  L169B putc
         leas  $04,s
         ldd   $06,s
         pshs  b,a
         pshs  u
         lbsr  L169B putc
         lbra  L18AA
L1763    pshs  u,b,a
         leau  >$006E,y
         clra
         clrb
         std   ,s
         bra   L1779
L176F    tfr   u,d
         leau  u000D,u
         pshs  b,a
         bsr   L178B
         leas  $02,s
L1779    ldd   ,s
         addd  #$0001
         std   ,s
         subd  #$0001
         cmpd  #$0010
         blt   L176F
         puls  pc,u,x

L178B    pshs  u
         ldu   $04,s
         leas  -$02,s
         cmpu  #$0000
         beq   L179B
         ldd   u0006,u
         bne   L17A0
L179B    ldd   #$FFFF
         puls  pc,u,x
L17A0    ldd   u0006,u
         clra
         andb  #$02
         beq   L17AF
         pshs  u
         bsr   L17C4
         leas  $02,s
         bra   L17B1
L17AF    clra
         clrb
L17B1    std   ,s
         ldd   u0008,u
         pshs  b,a
         lbsr  L1B12
         leas  $02,s
         clra
         clrb
         std   u0006,u
         ldd   ,s
         puls  pc,u,x
L17C4    pshs  u
         ldu   $04,s
         beq   L17D5
         ldd   u0006,u
         clra
         andb  #$22
         cmpd  #$0002
         beq   L17DA
L17D5    ldd   #$FFFF
         puls  pc,u
L17DA    ldd   u0006,u
         anda  #$80
         clrb
         std   -$02,s
         bne   L17EA
         pshs  u
         lbsr  L18B2
         leas  $02,s
L17EA    pshs  u
         bsr   L17F0
         puls  pc,u,x
L17F0    pshs  u
         ldu   $04,s
         leas  -$04,s
         ldd   u0006,u
         anda  #$01
         clrb
         std   -$02,s
         bne   L1822
         ldd   ,u
         cmpd  u0004,u
         beq   L1822
         clra
         clrb
         pshs  b,a
         pshs  u
         lbsr  L18AE
         leas  $02,s
         ldd   $02,x
         pshs  b,a
         ldd   ,x
         pshs  b,a
         ldd   u0008,u
         pshs  b,a
         lbsr  L1BD5
         leas  $08,s
L1822    ldd   ,u
         subd  u0002,u
         std   $02,s
         lbeq  L189A
         ldd   u0006,u
         anda  #$01
         clrb
         std   -$02,s
         lbeq  L189A
         ldd   u0006,u
         clra
         andb  #$40
         beq   L1871
         ldd   u0002,u
         bra   L1869
L1842    ldd   $02,s
         pshs  b,a
         ldd   ,u
         pshs  b,a
         ldd   u0008,u
         pshs  b,a
         lbsr  L1BC5
         leas  $06,s
         std   ,s
         cmpd  #$FFFF
         bne   L185F
         leax  $04,s
         bra   L1889
L185F    ldd   $02,s
         subd  ,s
         std   $02,s
         ldd   ,u
         addd  ,s
L1869    std   ,u
         ldd   $02,s
         bne   L1842
         bra   L189A
L1871    ldd   $02,s
         pshs  b,a
         ldd   u0002,u
         pshs  b,a
         ldd   u0008,u
         pshs  b,a
         lbsr  L1BAC
         leas  $06,s
         cmpd  $02,s
         beq   L189A
         bra   L188B
L1889    leas  -$04,x
L188B    ldd   u0006,u
         orb   #$20
         std   u0006,u
         ldd   u0004,u
         std   ,u
         ldd   #$FFFF
         bra   L18AA
L189A    ldd   u0006,u
         ora   #$01
         std   u0006,u
         ldd   u0002,u
         std   ,u
         addd  u000B,u
         std   u0004,u
         clra
         clrb
L18AA    leas  $04,s
         puls  pc,u
L18AE    pshs  u
         puls  pc,u
L18B2    pshs  u
         ldu   $04,s
         ldd   u0006,u
         clra
         andb  #$C0
         bne   L18EA
         leas  <-$20,s
         leax  ,s
         pshs  x
         ldd   u0008,u
         pshs  b,a
         clra
         clrb
         pshs  b,a
         lbsr  L1A94
         leas  $06,s
         ldd   u0006,u
         pshs  b,a
         ldb   $02,s
         bne   L18DE
         ldd   #$0040
         bra   L18E1
L18DE    ldd   #$0080
L18E1    ora   ,s+
         orb   ,s+
         std   u0006,u
         leas  <$20,s
L18EA    ldd   u0006,u
         ora   #$80
         std   u0006,u
         clra
         andb  #$0C
         beq   L18F7
         puls  pc,u
L18F7    ldd   u000B,u
         bne   L190C
         ldd   u0006,u
         clra
         andb  #$40
         beq   L1907
         ldd   #$0080
         bra   L190A
L1907    ldd   #$0100
L190A    std   u000B,u
L190C    ldd   u0002,u
         bne   L1921
         ldd   u000B,u
         pshs  b,a
         lbsr  L1CC8
         leas  $02,s
         std   u0002,u
         cmpd  #$FFFF
         beq   L1929
L1921    ldd   u0006,u
         orb   #$08
         std   u0006,u
         bra   L1938
L1929    ldd   u0006,u
         orb   #$04
         std   u0006,u
         leax  u000A,u
         stx   u0002,u
         ldd   #$0001
         std   u000B,u
L1938    ldd   u0002,u
         addd  u000B,u
         std   u0004,u
         std   ,u
         puls  pc,u
L1942    pshs  u
         ldb   $05,s
         sex
         tfr   d,x
         bra   L1968
L194B    ldd   [<$06,s]
         addd  #$0004
         std   [<$06,s]
         leax  >L197F,pcr
         bra   L1964
L195A    ldb   $05,s
         stb   >$006C,y
         leax  >$006B,y
L1964    tfr   x,d
         puls  pc,u
L1968    cmpx  #$0064
         beq   L194B
         cmpx  #$006F
         lbeq  L194B
         cmpx  #$0078
         lbeq  L194B
         bra   L195A
         puls  pc,u

L197F    fcb 0

L1980    pshs u
         leax  >L198A,pcr
         tfr   x,d
         puls  pc,u

L198A    fcb 0

L198B    pshs  u
         ldu   $04,s
L198F    ldb   ,u+
         bne   L198F
         tfr   u,d
         subd  $04,s
         addd  #$FFFF
         puls  pc,u

* strcpy?
L199C    pshs  u
         ldu   $06,s
         leas  -$02,s
         ldd   $06,s
         std   ,s
L19A6    ldb   ,u+
         ldx   ,s
         leax  $01,x
         stx   ,s
         stb   -$01,x
         bne   L19A6
         ldd   $06,s
         puls  pc,u,x

L19B6    pshs  u
         ldu   $06,s
         leas  -$02,s
         ldd   $06,s
         std   ,s
L19C0    ldx   ,s
         leax  $01,x
         stx   ,s
         ldb   -$01,x
         bne   L19C0
         ldd   ,s
         addd  #$FFFF
         std   ,s
L19D1    ldb   ,u+
         ldx   ,s
         leax  $01,x
         stx   ,s
         stb   -$01,x
         bne   L19D1
         ldd   $06,s
         puls  pc,u,x
         pshs  u
         ldu   $04,s
         bra   L19F7
L19E7    ldx   $06,s
         leax  $01,x
         stx   $06,s
         ldb   -$01,x
         bne   L19F5
         clra
         clrb
         puls  pc,u
L19F5    leau  1,u
L19F7    ldb   ,u
         sex
         pshs  b,a
         ldb   [<$08,s]
         sex
         cmpd  ,s++
         beq   L19E7
         ldb   [<$06,s]
         sex
         pshs  b,a
         ldb   ,u
         sex
         subd  ,s++
         puls  pc,u
L1A12    tsta
         bne   L1A27
         tst   $02,s
         bne   L1A27
         lda   $03,s
         mul
         ldx   ,s
         stx   $02,s
         ldx   #$0000
         std   ,s
         puls  pc,b,a
L1A27    pshs  b,a
         ldd   #$0000
         pshs  b,a
         pshs  b,a
         lda   $05,s
         ldb   $09,s
         mul
         std   $02,s
         lda   $05,s
         ldb   $08,s
         mul
         addd  $01,s
         std   $01,s
         bcc   L1A44
         inc   ,s
L1A44    lda   $04,s
         ldb   $09,s
         mul
         addd  $01,s
         std   $01,s
         bcc   L1A51
         inc   ,s
L1A51    lda   $04,s
         ldb   $08,s
         mul
         addd  ,s
         std   ,s
         ldx   $06,s
         stx   $08,s
         ldx   ,s
         ldd   $02,s
         leas  $08,s
         rts
         tstb
         beq   L1A7B
L1A68    asr   $02,s
         ror   $03,s
         decb
         bne   L1A68
         bra   L1A7B
L1A71    tstb
         beq   L1A7B
L1A74    lsr   $02,s
         ror   $03,s
         decb
         bne   L1A74
L1A7B    ldd   $02,s
         pshs  b,a
         ldd   $02,s
         std   $04,s
         ldd   ,s
         leas  $04,s
         rts
         tstb
         beq   L1A7B
L1A8B    lsl   $03,s
         rol   $02,s
         decb
         bne   L1A8B
         bra   L1A7B
L1A94    lda   $05,s
         ldb   $03,s
         beq   L1AC7
         cmpb  #$01
         beq   L1AC9
         cmpb  #$06
         beq   L1AC9
         cmpb  #$02
         beq   L1AAF
         cmpb  #$05
         beq   L1AAF
         ldb   #$D0
         lbra  L1D9D
L1AAF    pshs  u
         os9   I$GetStt
         bcc   L1ABB
         puls  u
         lbra  L1D9D
L1ABB    stx   [<$08,s]
         ldx   $08,s
         stu   $02,x
         puls  u
         clra
         clrb
         rts

L1AC7    ldx   $06,s
L1AC9    os9   I$GetStt
         lbra  L1DA6
         lda   $05,s
         ldb   $03,s
         beq   L1ADE
         cmpb  #$02
         beq   L1AE6
         ldb   #$D0
         lbra  L1D9D
L1ADE    ldx   $06,s
         os9   I$SetStt
         lbra  L1DA6
L1AE6    pshs  u
         ldx   $08,s
         ldu   $0A,s
         os9   I$SetStt
         puls  u
         lbra  L1DA6
         ldx   $02,s
         lda   $05,s
         os9   I$Open
         bcs   L1B00
         os9   I$Close
L1B00    lbra  L1DA6
L1B03    ldx   $02,s
         lda   $05,s
         os9   I$Open
         lbcs  L1D9D
         tfr   a,b
         clra
         rts

L1B12    lda   $03,s
         os9   I$Close
         lbra  L1DA6
         ldx   $02,s
         ldb   $05,s
         os9   I$MakDir
         lbra  L1DA6
L1B24    ldx   $02,s
         lda   $05,s
         ldb   #$0B
         os9   I$Create
         bcs   L1B33
L1B2F    tfr   a,b
         clra
         rts

L1B33    cmpb  #$DA
         lbne  L1D9D
         lda   $05,s
         bita  #$80
         lbne  L1D9D
         anda  #$07
         ldx   $02,s
         os9   I$Open
         lbcs  L1D9D
         pshs  u,a
         ldx   #$0000
         leau  ,x
         ldb   #$02
         os9   I$SetStt
         puls  u,a
         bcc   L1B2F
         pshs  b
         os9   I$Close
         puls  b
         lbra  L1D9D
         ldx   $02,s
         os9   I$Delete
         lbra  L1DA6
         lda   $03,s
         os9   I$Dup
         lbcs  L1D9D
         tfr   a,b
         clra
         rts
         pshs  y
         ldx   $06,s
         lda   $05,s
         ldy   $08,s
         pshs  y
         os9   I$Read
L1B89    bcc   L1B98
         cmpb  #$D3
         bne   L1B93
         clra
         clrb
         puls  pc,y,x
L1B93    puls  y,x
         lbra  L1D9D
L1B98    tfr   y,d
         puls  pc,y,x
         pshs  y
         lda   $05,s
         ldx   $06,s
         ldy   $08,s
         pshs  y
         os9   I$ReadLn
         bra   L1B89
L1BAC    pshs  y
         ldy   $08,s
         beq   L1BC1
         lda   $05,s
         ldx   $06,s
         os9   I$Write
L1BBA    bcc   L1BC1
         puls  y
         lbra  L1D9D
L1BC1    tfr   y,d
         puls  pc,y
L1BC5    pshs  y
         ldy   $08,s
         beq   L1BC1
         lda   $05,s
         ldx   $06,s
         os9   I$WritLn
         bra   L1BBA
L1BD5    pshs  u
         ldd   $0A,s
         bne   L1BE3
         ldu   #$0000
         ldx   #$0000
         bra   L1C17
L1BE3    cmpd  #$0001
         beq   L1C0E
         cmpd  #$0002
         beq   L1C03
         ldb   #$F7
L1BF1    clra
         std   >$020D,y
         ldd   #$FFFF
         leax  >$0201,y
         std   ,x
         std   $02,x
         puls  pc,u
L1C03    lda   $05,s
         ldb   #$02
         os9   I$GetStt
         bcs   L1BF1
         bra   L1C17
L1C0E    lda   $05,s
         ldb   #$05
         os9   I$GetStt
         bcs   L1BF1
L1C17    tfr   u,d
         addd  $08,s
         std   >$0203,y
         tfr   d,u
         tfr   x,d
         adcb  $07,s
         adca  $06,s
         bmi   L1BF1
         tfr   d,x
         std   >$0201,y
         lda   $05,s
         os9   I$Seek
         bcs   L1BF1
         leax  >$0201,y
         puls  pc,u

*
modlink    pshs  u,y
         ldx   $06,s
         lda   $09,s
         lsla
         lsla
         lsla
         lsla
         ora   $0B,s
         os9   F$Link
L1C4B    tfr   u,d
         puls  u,y
         lbcs  L1D9D
         rts

         pshs  u,y
         ldx   $06,s
         lda   $09,s
         lsla
         lsla
         lsla
         lsla
         ora   $0B,s
         os9   F$Load
         bra   L1C4B
L1C65    pshs  u
         ldu   $04,s
         os9   F$UnLink
         puls  u
         lbra  L1DA6
         ldd   >$01FF,y
         pshs  b,a
         ldd   $04,s
         cmpd  >$05DF,y
         bcs   L1CA5
         addd  >$01FF,y
         pshs  y
         subd  ,s
         os9   F$Mem
         tfr   y,d
         puls  y
         bcc   L1C97
         ldd   #$FFFF
         leas  $02,s
         rts
L1C97    std   >$01FF,y
         addd  >$05DF,y
         subd  ,s
         std   >$05DF,y
L1CA5    leas  $02,s
         ldd   >$05DF,y
         pshs  b,a
         subd  $04,s
         std   >$05DF,y
         ldd   >$01FF,y
         subd  ,s++
         pshs  b,a
         clra
         ldx   ,s
L1CBE    sta   ,x+
         cmpx  >$01FF,y
         bcs   L1CBE
         puls  pc,b,a
L1CC8    ldd   $02,s
         addd  >$0209,y
         bcs   L1CF1
         cmpd  >$020B,y
         bcc   L1CF1
         pshs  b,a
         ldx   >$0209,y
         clra
L1CDE    cmpx  ,s
         bcc   L1CE6
         sta   ,x+
         bra   L1CDE
L1CE6    ldd   >$0209,y
         puls  x
         stx   >$0209,y
         rts
L1CF1    ldd   #$FFFF
         rts
         lda   $03,s
         ldb   $05,s
         os9   F$Send
         lbra  L1DA6
         clra
         clrb
         os9   F$Wait
         lbcs  L1D9D
         ldx   $02,s
         beq   L1D10
         stb   $01,x
         clr   ,x
L1D10    tfr   a,b
         clra
         rts
         lda   $03,s
         ldb   $05,s
         os9   F$SPrior
         lbra  L1DA6

L1D1E    leau  ,s
         leas  >$00FF,y
         ldx   u0002,u
         ldy   u0004,u
         lda   u0009,u
         lsla
         lsla
         lsla
         lsla
         ora   u000B,u
         ldb   u000D,u
         ldu   u0006,u
         os9   F$Chain
         os9   F$Exit
         pshs  u,y
         ldx   $06,s
         ldy   $08,s
         ldu   $0A,s
         lda   $0D,s
         ora   $0F,s
         ldb   <$11,s
         os9   F$Fork
         puls  u,y
         lbcs  L1D9D
         tfr   a,b
         clra
         rts

L1D58    pshs  y
         os9   F$ID
         puls  y
         bcc   L1D65
         lbcs  L1D9D
L1D65    tfr   a,b
         clra
         rts
L1D69    pshs  y
         os9   F$ID
         bcc   L1D75
L1D70    puls  y
         lbra  L1D9D
L1D75    tfr   y,d
         puls  pc,y
         pshs  y
         bsr   L1D69
         std   -$02,s
         beq   L1D85
         ldb   #$D6
         bra   L1D70
L1D85    ldy   $04,s
         os9   F$SUser
         bcc   L1D99
         cmpb  #$D0
         bne   L1D70
         tfr   y,d
         ldy   >$004B
         std   $09,y
L1D99    clra
         clrb
         puls  pc,y
L1D9D    clra
         std   >$020D,y
         ldd   #$FFFF
         rts
L1DA6    bcs   L1D9D
         clra
         clrb
         rts
* exit
L1DAB    lbsr  L1DB6
         lbsr  L1763
L1DB1    ldd   $02,s
         os9   F$Exit
L1DB6    rts

* Initial values
L1DB7    fcb  $00,$01,$00,$01,$92
         fcc  "ctmp.XXXXXX"
         fcb  $00,$00,$00,$00,$00,$00,$00,$00,$00
L1DD0    fcc  "c.com"
         fcb  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcb  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

         fcb  $0C,$D6
         fcb  $27,$10,$03,$E8,$00,$64,$00,$0A,$00,$69,$6C,$78,$00,$00,$00,$00
         fcb  $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcb  $00,$02,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$42,$00
         fcb  $02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcb  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcb  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcb  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcb  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcb  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcb  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcb  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcb  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcb  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcb  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
         fcb  $01,$01,$01,$01,$01,$01,$01,$11,$11,$01,$11,$11,$01,$01,$01,$01
         fcb  $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$30,$20
         fcb  $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$48,$48
         fcb  $48,$48,$48,$48,$48,$48,$48,$48,$20,$20,$20,$20,$20,$20,$20,$42
         fcb  $42,$42,$42,$42,$42,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
         fcb  $02,$02,$02,$02,$02,$02,$02,$02,$02,$20,$20,$20,$20,$20,$20,$44
         fcb  $44,$44,$44,$44,$44,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04
         fcb  $04,$04,$04,$04,$04,$04,$04,$04,$04,$20,$20,$20,$20,$01,$00,$01
         fcb  $00,$5F,$00,$01,$00
         fcc   "icc1.dragon"
         fcb   0
         emod
eom      equ   *
