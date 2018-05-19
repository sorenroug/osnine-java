         nam   Piper
         ttl   os9 device driver    

         ifp1
         use   os9defs
         endc
tylg     set   Drivr+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   6
size     equ   .
         fcb   $03 
name     equ   *
         fcs   /Piper/
         fcb   $02 
start    equ   *
         clrb  
         rts   
         nop   
         clrb  
         rts   
         nop   
         clrb  
         rts   
         nop   
         clrb  
         rts   
         nop   
         clrb  
         rts   
         nop   
         clrb  
         rts   
         emod
eom      equ   *
