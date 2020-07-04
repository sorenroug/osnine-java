         nam   Boot
         ttl   os9 system module

         use   defsfile

         mod   eom,name,Systm+Objct,ReEnt+3,start,size

u0000    rmb   1
u0001    rmb   6
u0007    rmb   96
u0067    rmb   1
u0068    rmb   2
u006A    rmb   2
u006C    rmb   18
u007E    rmb   1
u007F    rmb   2
u0081    rmb   2
u0083    rmb   4
u0087    rmb   2
u0089    rmb   2
size     equ   .
name     equ   *
         fcs   /Boot/
         fcb   $02

L0012    fcs "EXORctlr"

L001A    jmp   [>$FFFE]

start    equ   *
         pshs  u,y,x,b,a
         ldd   #$0100
         os9   F$SRQM
         bcs   L001A
         clra
         clrb
         sta   <u0067,u
         std   <u0068,u
         pshs  u,y
         lda   #$E0
         leax  <L0012,pcr
         os9   F$Link
         tfr   u,x
         puls  u,y
         bcs   L001A
         stx   >u0089,u
         ldd   $09,x
         leax  d,x
         stx   >u0083,u
         leax  $06,x
         stx   >u0087,u
         ldy   #$EC00
         sty   u0001,u
         leax  u0007,u
         stx   <u007F,u
         ldd   #$FFFF
         std   <$15,x
         ldd   #$0010
         stb   $03,x
         std   <$11,x
         lda   #$01
         sta   <$10,x
         ldd   #$00EA
         std   >u0081,u
         jsr   [>u0083,u]
         ldb   #$04
         stb   <u007E,u
         jsr   [>u0087,u]
         ldb   #$08
         stb   <u007E,u
         jsr   [>u0087,u]
         bcs   L00F0
         pshs  u
         ldd   #$0100
         os9   F$SRQM
         tfr   u,y
         puls  u
         bcs   L00F0
         ldd   #$0001
         ldx   #$0000
         pshs  y
         bsr   L00FB
         jsr   [>u0087,u]
         puls  y
         bcs   L00F0
         ldd   #$0100
         pshs  u,y
         tfr   y,u
         os9   F$SRTM
         puls  u,y
         bsr   L011F
         ldd   <$18,y
         std   ,s
         beq   L00EE
         pshs  u,y
         os9   F$SRQM
         tfr   u,x
         puls  u,y
         bcs   L00F0
         stx   $02,s
         exg   x,y
         ldd   <$18,x
         tstb
         beq   L00DB
         inca
L00DB    clrb
         exg   a,b
         ldx   <$16,x
         bsr   L00FB
         jsr   [>u0087,u]
         bcs   L00F0
         bsr   L010D
         clrb
         puls  pc,u,y,x,b,a

L00EE    ldb   #$F9
L00F0    pshs  b
         bsr   L010D
         comb
         puls  b
         leas  $02,s
         puls  pc,u,y,x

L00FB    sty   <u006C,u
         std   <u006A,u
         stx   <u0068,u
         clrb
         stb   <u007E,u
         ldy   u0001,u
         rts
L010D    pshs  u
         ldu   >u0089,u
         os9   F$UnLk
         puls  u
         ldd   #$0100
         os9   F$SRTM
         rts
L011F    ldx   <u007F,u
         ldb   #$14
L0124    lda   b,y
         sta   b,x
         decb
         bpl   L0124
         rts
         emod
eom      equ   *
