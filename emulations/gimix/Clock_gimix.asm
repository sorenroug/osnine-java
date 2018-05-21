         nam   Clock
         ttl   os9 system module    

         ifp1
         use   /dd/defs/os9defs
         endc
tylg     set   Systm+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size

clockloc rmb   $E220

size     equ   .
name     equ   *
         fcs   /Clock/
         fcb   $02 

SysTbl   fcb   F$Time
         fdb   FTime-*-2
         fcb   $80

         fcb   $6E
         fcb   $9F
         fcb   $00
         fcb   $38

L001B    fcb   $AE
         fcb   $8D
         fcb   $FF
         fcb   $EC
         fcb   $A6
         fcb   $88
         fcb   $10
         fcb   $27
         fcb   $F3
         fcb   $4F
         fcb   $1F 
         fcb   $8B 
         fcb   $6E
         fcb   $9F 
         fcb   $FF 
         fcb   $E0

start    equ   *
         pshs  dp
         clra  
         tfr   a,dp
         pshs  cc
         lda   #$0A
         sta   D.TSec
         sta   D.Tick
         lda   #$01
         sta   D.TSlice
         sta   D.Slice
         orcc  #$50
         leax  >L001B,pcr
         stx   D.IRQ
         leas  -$05,s
         ldx   #$0054
         bsr   L0095
         stb   ,s
         bsr   L0095
         stb   $01,s
         bsr   L0095
         stb   $02,s
         bsr   L0095
         stb   $03,s
         bsr   L0095
         stb   $04,s
         ldx   >name-2,pcr
         ldd   #$FF02
         sta   <$13,x
         lda   <$10,x
         stb   <$11,x
         lda   ,s
         beq   L0088
         sta   $07,x
         lda   $01,s
         beq   L0088
         sta   $06,x
         lda   $02,s
         sta   $04,x
         ldd   $03,s
         sta   $03,x
         clr   <$15,x
         stb   $02,x
L0088    leas  $05,s
         puls  cc
         leay  >SysTbl,pcr
         os9   F$SSvc   
         puls  pc,dp

L0095    lda   ,x+
         ldb   #$FA
L0099    addb  #$10
         suba  #$0A
         bcc   L0099
L009F    decb  
         inca  
         bne   L009F
         rts   

FTime
         ldx   >name-2,pcr
         pshs  cc
         orcc  #$50
L00AC    lda   $02,x
         sta   D.Sec
         lda   $03,x
         sta   D.Min
         lda   $04,x
         sta   D.Hour
         lda   $06,x
         sta   D.Day
         lda   $07,x
         sta   D.Month
         lda   <$14,x
         rora  
         bcs   L00AC
         puls  cc
         ldx   #$0054

L00CB    lda   ,x
         anda  #$F0
         tfr   a,b
         eora  ,x
         sta   ,x
         lsrb  
         lsrb  
         lsrb  
         lsrb  
         lda   #$0A
         mul   
         addb  ,x
         stb   ,x+
         cmpx  #$0059
         bcs   L00CB

         ldx   4,u
         ldd   D.Year
         std   ,x
         ldd   D.Day
         std   $02,x
         ldd   D.Min
         std   $04,x
         clrb  
         rts   

         emod
eom      equ   *
