         nam   Clock
         ttl   HW clock module

         ifp1
         use   os9defs
         endc
tylg     set   Systm+Objct   
atrv     set   ReEnt+rev
rev      set   $01
edition  set   $02

clockctl set   $ffd0
TkPerSec set   50
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   0
size     equ   .
name     equ   *
         fcs   /Clock/
         fcb   edition

SysTbl   fcb   F$Time
         fdb   FTime-*-2
         fcb   $80 

* table of days of the month
MonthChk fcb   00
         fcb   31                      January
         fcb   28                      February
         fcb   31                      March
         fcb   30                      April
         fcb   31                      May
         fcb   30                      June
         fcb   31                      July
         fcb   31                      August
         fcb   30                      September
         fcb   31                      October
         fcb   30                      November
         fcb   31                      December

* Read the control register. If the clock didn't cause the
* interrupt then exit.
ClockIRQ lda   >clockctl   Read the control register.
         bne   UpdateCK    If there is no interrupt then check devices.
         jmp   [>D.SvcIRQ]
UpdateCK clra
         tfr   a,dp
         dec   <D.Tick                 decrement tick counter
         bne   EndIRQ
         ldd   <D.Min
* Seconds increment
         incb
         cmpb  #60                     full minute?
         bcs   UpMinute
* Minutes increment
         inca                          else increment minut
         cmpa  #60                     full hour?
         bcs   L0078                   nope...
         ldd   <D.Day                  else increment day
* Hour increment
         incb                          increment hour
         cmpb  #24                     past 23rd hour?
         bcs   L0075                   branch if not
* Day increment
         inca                          else increment day
         leax  >MonthChk,pcr
         ldb   <D.Month
         cmpb  #2                      is this February?
         bne   L006X                   if not, go on to year/month
         ldb   <D.Year                 else check for leap year cases $53
         beq   L006X                   branch if year 1900
         andb  #$03                    see if 2^4 bit set (leap year)
         bne   L006X
         deca
L006X    ldb   <D.Month    $54
         cmpa  b,x                     compare days to max days
         bls   L0074                   branch if ok
         ldd   <D.Year
         incb
         cmpb  #13                     past December?
         bcs   L0070
* Year increment
         inca                          else in year
         ldb   #1                      and start month in January
L0070    std   <D.Year                 update year/month
         lda   #1                      new month, first day
L0074    clrb
L0075    std   <D.Day                  update day/hour
         clra
L0078    clrb
UpMinute std   <D.Min
         lda   <D.TSec
         sta   <D.Tick
EndIRQ   jmp   [D.Clock]

start    equ   *
         pshs  dp,cc
         clra  
         tfr   a,dp
         lda   #TkPerSec
         sta   <D.TSec
         sta   <D.Tick
         lda   #TkPerSec/10
         sta   <D.TSlice
         sta   <D.Slice
         orcc  #IntMasks
         ldd   >D.IRQ
         std   >D.AltIRQ
         leax  >ClockIRQ,pcr
         stx   >D.IRQ
* install system calls
         leay  >SysTbl,pcr
         os9   F$SSvc   

* Start the heart beat every 20 milliseconds.
         lda   #20
         sta   >clockctl

         puls  pc,dp,cc

* F$Time system call code
* Copy 6 bytes into buffer pointed to by Reg X.
FTime    ldx   R$X,u
         ldd   <D.Year
         std   ,x
         ldd   <D.Day
         std   $02,x
         ldd   <D.Min
         std   $04,x
         clrb  
         rts   
         emod
eom      equ   *
