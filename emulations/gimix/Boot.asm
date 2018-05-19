         nam   Boot
         ttl   os9 system module    

         ifp1
         use   /dd/defs/os9defs
         endc
tylg     set   Systm+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   2
u0002    rmb   2
u0004    rmb   2
u0006    rmb   2
u0008    rmb   2
u000A    rmb   2
u000C    rmb   2
u000E    rmb   1
u000F    rmb   4
u0013    rmb   1
u0014    rmb   1
u0015    rmb   1
u0016    rmb   2
u0018    rmb   1
u0019    rmb   1
size     equ   .
name     equ   *
         fcs   /Boot/
         fcb   $00 
         fcb   $28 (
         fcb   $43 C
         fcb   $29 )
         fcb   $31 1
         fcb   $39 9
         fcb   $38 8
         fcb   $31 1
         fcb   $4D M
         fcb   $69 i
         fcb   $63 c
         fcb   $72 r
         fcb   $6F o
         fcb   $77 w
         fcb   $61 a
         fcb   $72 r
         fcb   $65 e
L0022    fcb   $00 
L0023    fcb   $0A 
L0024    fcb   $10 
start    equ   *
         clra  
         ldb   #$1A
L0028    pshs  a
         decb  
         bne   L0028
         tfr   s,u
         ldx   #$E3B0
         stx   ,u
         leax  $01,x
         stx   u0002,u
         leax  $01,x
         stx   u0004,u
         leax  $02,x
         lda   #$D0
         sta   ,x
         stx   u0006,u
         leax  $01,x
         stx   u0008,u
         leax  $01,x
         stx   u000A,u
         leax  $01,x
         stx   u000C,u
         lda   #$FF
         sta   <u0018,u
         lda   [,u]
         anda  #$01
         sta   <u0013,u
         pshs  u,x,b,a
         clra  
         clrb  
         ldy   #$0001
         ldx   <u0020
         ldu   <u0022
         os9   F$SchBit 
         bcs   L00B1
         exg   a,b
         ldu   $04,s
         std   <u0016,u
         clrb  
         ldx   #$0000
         bsr   L00DF
         bcs   L00B1
         ldd   <$18,y
         std   ,s
         os9   F$SRqMem 
         bcs   L00B1
         stu   $02,s
         ldu   $04,s
         ldx   $02,s
         stx   <u0016,u
         ldx   <$16,y
         ldd   <$18,y
         beq   L00AA
L0097    pshs  x,b,a
         clrb  
         bsr   L00DF
         bcs   L00AF
         puls  x,b,a
         inc   <u0016,u
         leax  $01,x
         subd  #$0100
         bhi   L0097
L00AA    clra  
         puls  b,a
         bra   L00B3
L00AF    leas  $04,s
L00B1    leas  $02,s
L00B3    puls  u,x
         leas  <$1A,s
         rts   
L00B9    lda   #$01
         sta   <u0019,u
         clr   <u0018,u
         lda   #$05
L00C3    ldb   #$4B
         pshs  a
         eorb  >L0022,pcr
         clr   <u0014,u
         lbsr  L01BF
         puls  a
         deca  
         bne   L00C3
         ldb   #$0B
         eorb  >L0022,pcr
         lbra  L01BF
L00DF    lda   #$91
         cmpx  #$0000
         bne   L00F8
         bsr   L00F8
         bcs   L00EF
         ldy   <u0016,u
         clrb  
L00EF    rts   
L00F0    bcc   L00F8
         pshs  x,b,a
         bsr   L00B9
         puls  x,b,a
L00F8    pshs  x,b,a
         bsr   L0103
         puls  x,b,a
         bcc   L00EF
         lsra  
         bne   L00F0
L0103    bsr   L011B
         bcs   L00EF
         ldx   <u0016,u
         lda   #$10
         sta   <u0014,u
         ldb   #$88
         lbsr  L01BF
         lbra  L01FE
L0117    comb  
         ldb   #$F1
         rts   
L011B    lda   #$01
         sta   <u0019,u
         lda   #$20
         sta   u000F,u
         clr   u000E,u
         tstb  
         bne   L0117
         tfr   x,d
         cmpd  #$0000
         beq   L018B
         cmpd  $01,y
         bcc   L0117
         tst   <u0013,u
         bne   L014A
         subb  >L0023,pcr
         sbca  #$00
         bcc   L0159
         clra  
         addb  >L0023,pcr
         bra   L018B
L014A    subb  >L0024,pcr
         sbca  #$00
         bcc   L0159
         clra  
         addb  >L0024,pcr
         bra   L018B
L0159    stb   <u0014,u
         clrb  
         pshs  b
         ldb   <$10,y
         lsrb  
         ldb   <u0014,u
         bcc   L0176
L0168    com   u000E,u
         bne   L016E
         inc   ,s
L016E    subb  $03,y
         sbca  #$00
         bcc   L0168
         bra   L017E
L0176    inc   ,s
         subb  $03,y
         sbca  #$00
         bcc   L0176
L017E    lda   <$10,y
         bita  #$02
         beq   L0187
         clr   u000F,u
L0187    puls  a
         addb  $03,y
L018B    stb   [<u000A,u]
         ldb   u000F,u
         orb   <u0019,u
         stb   <u0019,u
         ldb   <u0018,u
         stb   [<u0008,u]
L019C    ldb   [,u]
         bitb  #$20
         bne   L019C
         cmpa  <u0018,u
         beq   L01BD
         sta   <u0018,u
         sta   [<u000C,u]
         ldb   #$1B
         eorb  >L0022,pcr
         clr   <u0014,u
         bsr   L01BF
         lda   #$04
         sta   <u0015,u
L01BD    clrb  
         rts   
L01BF    stx   [<u0004,u]
         lda   <u0019,u
         tst   <u0013,u
         beq   L01CC
         ora   #$C0
L01CC    sta   [,u]
         lda   <u0014,u
         tst   u000E,u
         beq   L01D7
         ora   #$40
L01D7    ora   #$80
         sta   [<u0002,u]
         tst   <u0014,u
         beq   L01ED
         orb   <u0015,u
         clr   <u0015,u
         tst   u000E,u
         beq   L01ED
         orb   #$02
L01ED    stb   [<u0006,u]
L01F0    lda   [,u]
         bita  #$40
         beq   L01F0
         lda   [<u0006,u]
         rts   
         bita  #$40
         bne   L022B
L01FE    bita  #$04
         bne   L0218
         bita  #$08
         bne   L0210
         bita  #$10
         bne   L0214
         bita  #$80
         bne   L0227
         clrb  
         rts   
L0210    comb  
         ldb   #$F3
         rts   
L0214    comb  
         ldb   #$F7
         rts   
L0218    ldb   <u0014,u
         bitb  #$20
         bne   L0223
         comb  
         ldb   #$F5
         rts   
L0223    comb  
         ldb   #$F4
         rts   
L0227    comb  
         ldb   #$F6
         rts   
L022B    comb  
         ldb   #$F2
         rts   
         emod
eom      equ   *
