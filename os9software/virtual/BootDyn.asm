********************************************************************
* Boot - add modules from a known address
* Find out how much space is needed by reading the module sizes.

         nam   Boot
         ttl   OS-9 Level One Boot module

 use defsfile

tylg     set   Systm+Objct
atrv     set   ReEnt+rev
rev      set   $01
edition  set   1

         mod   eom,name,tylg,atrv,start,size

size     equ   .

name     fcs   /Boot/
         fcb   edition
startmem equ   $2600+$1200

* obtain bootfile size at known offset at $3800
start    pshs  u,y,x,a,b
         ldx   #startmem
         tfr   x,d
beginmod ldy   ,x                      get $87CD
         cmpy  #$87CD
         bne   calcdiff
         addd  M$Size,x
         tfr   d,x
         bra   beginmod

calcdiff subd  #startmem
* allocate memory from system. Input: d = size
* Output: u = location, d = allocated size
         os9   F$SRqMem
         bcs   Uhoh
* copy bootfile from low RAM to allocated area
         std   0,s                      place bootfile size in A/B on stack
         stu   2,s                     place address in X loc. on stack
         ldx   #startmem            X points to bootfile in RAM
*        ldd   ,s                      get bootfile size from A/B on stack
Loop     ldy   ,x++
         sty   ,u++
         subd  #2
         bgt   Loop

* Upon exit, we return to the kernel with:
*    X = address of bootfile
*    D = size of bootfile
Uhoh     puls  u,y,x,a,b,pc

         emod
eom      equ   *
         end
