 opt l
 nam GIMIX G68 controller boot source

 opt -c

 use   defsfile

 ttl Boot Module
 pag


tylg     set   Systm+Objct   
atrv     set   ReEnt+rev
rev      set   $02
         mod   eom,name,tylg,atrv,BTENT,BTSTA
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
u001A    rmb   2
u001C    rmb   1
u001D    rmb   1
BTSTA     equ   .
name     equ   *
         fcs   /Boot/
         fcb   $01 
         fcc   "(C) 1982 Microware"

L0024    fcb   $00 
P.T0S    fcb   $0A 
P.SCT    fcb   $10 

BTENT clra
 ldb #BTSTA Get size of needed static

L002A    pshs  a
         decb  
         bne   L002A
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
         ldd   #$0100
         os9   F$SRqMem 
         bcs   L00CB
         tfr   u,d
         ldu   $04,s
         std   <u0016,u
         clrb  
         ldx   #$0000
         lbsr  L00F9
         bcs   L00CB
         ldy   <u0016,u
         ldd   <$18,y
         std   ,s
         beq   L00C4
         ldx   <$16,y
         ldd   $01,y
         std   <u001A,u
         lda   <$10,y
         sta   <u001C,u
         lda   $03,y
         sta   <u001D,u
         ldd   #$0100
         ldu   <u0016,u
         os9   F$SRtMem 
         ldd   ,s
         os9   F$SRqMem 
         bcs   L00CB
         tfr   u,d
         ldu   $04,s
         std   $02,s
         std   <u0016,u
         ldd   ,s
L00B1    pshs  x,b,a
         clrb  
         bsr   L00F9
         bcs   L00C9
         puls  x,b,a
         inc   <u0016,u
         leax  $01,x
         subd  #$0100
         bhi   L00B1
L00C4    clra  
         puls  b,a
         bra   L00CD
L00C9    leas  $04,s
L00CB    leas  $02,s
L00CD    puls  u,x
         leas  <$1E,s
L00D2    rts   
L00D3    lda   #$01
         sta   <u0019,u
         clr   <u0018,u
         lda   #$05
L00DD    ldb   #$4B
         pshs  a
         eorb  >L0024,pcr
         clr   <u0014,u
         lbsr  L01D0
         puls  a
         deca  
         bne   L00DD
         ldb   #$0B
         eorb  >L0024,pcr
         lbra  L01D0
L00F9    lda   #$91
         bra   L0105
L00FD    bcc   L0105
         pshs  x,b,a
         bsr   L00D3
         puls  x,b,a
L0105    pshs  x,b,a
         bsr   L0110
         puls  x,b,a
         bcc   L00D2
         lsra  
         bne   L00FD
L0110    bsr   L0128
         bcs   L00D2
         ldx   <u0016,u
         lda   #$10
         sta   <u0014,u
         ldb   #$88
         lbsr  L01D0
         lbra  L020D
L0124    comb  
         ldb   #$F1
         rts   
L0128    lda   #$01
         sta   <u0019,u
         lda   #$20
         sta   u000F,u
         clr   u000E,u
         tstb  
         bne   L0124
         tfr   x,d
         cmpd  #$0000
         beq   L019C
         cmpd  <u001A,u
         bcc   L0124
         tst   <u0013,u
         bne   L0158
         subb  >P.T0S,pcr
         sbca  #$00
         bcc   L0167
         clra  
         addb  >P.T0S,pcr
         bra   L019C
L0158    subb  >P.SCT,pcr
         sbca  #$00
         bcc   L0167
         clra  
         addb  >P.SCT,pcr
         bra   L019C
L0167    stb   <u0014,u
         clrb  
         pshs  b
         ldb   <u001C,u
         lsrb  
         ldb   <u0014,u
         bcc   L0185
L0176    com   u000E,u
         bne   L017C
         inc   ,s
L017C    subb  <u001D,u
         sbca  #$00
         bcc   L0176
         bra   L018E
L0185    inc   ,s
         subb  <u001D,u
         sbca  #$00
         bcc   L0185
L018E    lda   <u001C,u
         bita  #$02
         beq   L0197
         clr   u000F,u
L0197    puls  a
         addb  <u001D,u
L019C    stb   [<u000A,u]
         ldb   u000F,u
         orb   <u0019,u
         stb   <u0019,u
         ldb   <u0018,u
         stb   [<u0008,u]
L01AD    ldb   [,u]
         bitb  #$20
         bne   L01AD
         cmpa  <u0018,u
         beq   L01CE
         sta   <u0018,u
         sta   [<u000C,u]
         ldb   #$1B
         eorb  >L0024,pcr
         clr   <u0014,u
         bsr   L01D0
         lda   #$04
         sta   <u0015,u
L01CE    clrb  
         rts   
L01D0    stx   [<u0004,u]
         lda   <u0019,u
         tst   <u0013,u
         beq   L01DD
         ora   #$C0
L01DD    sta   [,u]
         lda   <u0014,u
         tst   u000E,u
         beq   L01E8
         ora   #$40
L01E8    sta   [<u0002,u]
         tst   <u0014,u
         beq   L01FC
         orb   <u0015,u
         clr   <u0015,u
         tst   u000E,u
         beq   L01FC
         orb   #$02
L01FC    stb   [<u0006,u]
L01FF    lda   [,u]
         bita  #$40
         beq   L01FF
         lda   [<u0006,u]
         rts   
         bita  #$40
         bne   L023A
L020D    bita  #$04
         bne   L0227
         bita  #$08
         bne   L021F
         bita  #$10
         bne   L0223
         bita  #$80
         bne   L0236
         clrb  
         rts   
L021F    comb  
         ldb   #$F3
         rts   
L0223    comb  
         ldb   #$F7
         rts   
L0227    ldb   <u0014,u
         bitb  #$20
         bne   L0232
         comb  
         ldb   #$F5
         rts   
L0232    comb  
         ldb   #$F4
         rts   
L0236    comb  
         ldb   #$F6
         rts   
L023A    comb  
         ldb   #$F2
         rts   
         emod
eom      equ   *
