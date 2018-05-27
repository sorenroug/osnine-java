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

*****
*
*  Clock Interrupt Service Routine
*
NOTCLK jmp [D.SvcIRQ] Go to interrupt service

CLKSRV ldx 11,PCR
 lda $10,x
 beq NOTCLK
 clra
 tfr a,dp
 jmp [$FFE0]    Go to Clock tick handler

start    equ   *
         pshs  dp
         clra  
         tfr   a,dp
         pshs  cc save interrupt masks
         lda #10 Set ticks / second
         sta   D.TSec
         sta   D.Tick
         lda #1 Set ticks / time-slice
         sta   D.TSlice
         sta   D.Slice
         orcc #IRQMask+FIRQMask Set intrpt masks
         leax  >CLKSRV,pcr
         stx   D.IRQ
         leas  -$05,s
         ldx   #$0054
         bsr   CNVBB
         stb   ,s
         bsr   CNVBB
         stb   $01,s
         bsr   CNVBB
         stb   $02,s
         bsr   CNVBB
         stb   $03,s
         bsr   CNVBB
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

CNVBB lda ,X+ Get binary byte
 ldb #$FA Init bcd byte
CNVB10 addb #$10 Count ten
 suba #10 Is there a ten?
 bcc CNVB10 Branch if so
CNVB20 decb Count Unit
 inca Is there a unit?
 bne CNVB20 Branch if so
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

TIME20    lda   ,x
         anda  #$F0
         tfr   a,b
         eora  ,x
         sta   ,x
         lsrb  
         lsrb  
         lsrb  
         lsrb  
 lda #10
 mul
 addb 0,X Add lsn
 stb ,X+ Save converted byte
 cmpx #D.SEC+1
 bcs TIME20

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
