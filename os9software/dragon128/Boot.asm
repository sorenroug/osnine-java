         nam   Boot
         ttl   os9 system module

 use defsfile

tylg     set   Systm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   BootEnd,name,tylg,atrv,start,0

         fcb   $FF
name     equ   *
         fcs   /Boot/
         fcb   $01

L0013 fcs "bootdev"

start    pshs  u,y
         lda   #Devic+Objct
         leax  >L0013,pcr
         os9   F$Link
         bcs   L0050
         pshs  u
         ldd   M$Mem,u
         leax  d,u
         lda   #Drivr+Objct
         os9   F$Link
         leax  <$12,y   Module address
         ldy   ,s
         bcs   L0047
         pshs  u
         jsr   ,x
         puls  u
         pshs  x,b,a,cc
         os9   F$UnLink
         puls  x,b,a,cc
L0047    puls  u
         pshs  x,b,a,cc
         os9   F$UnLink
         puls  x,b,a,cc
L0050    puls  pc,u,y

 emod
BootEnd equ *
