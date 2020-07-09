         nam   Boot
         ttl   os9 system module

 use defsfile

tylg     set   Systm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   BootEnd,BTNAM,tylg,atrv,BTENT,0

         fcb   $FF
BTNAM     equ   *
         fcs   /Boot/
         fcb   $01

BOOTDEV fcs "bootdev"

BTENT    pshs  u,y
         lda   #Devic+Objct
         leax  >BOOTDEV,pcr
         os9   F$Link
         bcs   BOOTEX
         pshs  u
         ldd   M$PDev,u
         leax  d,u
         lda   #Drivr+Objct
         os9   F$Link
         leax  <$12,y   Boot vector in wd2797
         ldy   0,s
         bcs   L0047
         pshs  u
         jsr   0,x
         puls  u
         pshs  x,b,a,cc
         os9   F$UnLink
         puls  x,b,a,cc
L0047    puls  u
         pshs  x,b,a,cc
         os9   F$UnLink
         puls  x,b,a,cc
BOOTEX    puls  pc,u,y

 emod
BootEnd equ *
