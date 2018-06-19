PROGRAM random;
TYPE
    static = RECORD
             Ran3Inext, Ran3Extp : integer;
             Ran3Ma : ARRAY [1..55] OF real
    END;

FUNCTION rand(VAR idum:integer; VAR b:static):real;

(* CONST
 * mbig=1000000000;mseed=161803398;mz=0;fac=1.0e-9;
 * var
 * i,ii,k,mj,mk : longint;
 *)

CONST
   mbig = 4.0e6;
   mseed = 1618033.0;
   mz = 0.0;
   fac = 2.5e-7;  { 1/mbig }

VAR
   i,ii,k : integer;
   mj,mk : real;

BEGIN
   IF idum < 0 THEN BEGIN
      mj := mseed+idum;
      IF mj >= 0.0 THEN
         mj := mj-mbig*trunc(mj/mbig)
      ELSE
           mj := mbig-abs(mj)+mbig*trunc(abs(mj)/mbig);
(*         mj := mj mod mbig; *)
      b.Ran3Ma[55] := mj;
      mk := 1;
      FOR i := 1 TO 54 DO BEGIN
          ii := 21 * i mod 55;
          b.Ran3Ma[ii] := mk;
          mk := mj-mk;
          IF mk < mz THEN mk := mk+mbig;
          mj := b.Ran3Ma[ii]
      END;
      FOR k := 1 TO 4 DO BEGIN
         FOR i := 1 TO 55 DO BEGIN
            b.Ran3Ma[i] := b.Ran3Ma[i]-b.Ran3Ma[1+((i+30) mod 55)];
            IF b.Ran3Ma[i] < mz THEN b.Ran3Ma[i] := b.Ran3Ma[i]+mbig;
          END
      END;
      b.Ran3Inext := 0;
      b.Ran3Extp := 31;
      idum := 1
   END;

   b.Ran3Inext := b.ran3inext+1;
   IF b.Ran3Inext = 56 THEN
      b.Ran3Inext := 1;
   b.Ran3Extp := b.Ran3Extp+1;
   IF b.Ran3Extp = 56 THEN
      b.Ran3Extp := 1;
   mj := b.Ran3Ma[b.Ran3Inext]-b.Ran3Ma[b.Ran3Extp];
   IF mj < mz THEN mj := mj+mbig;
   b.Ran3Ma[b.Ran3Inext] := mj;
   rand := mj*fac;
END;

BEGIN {no main program, this is a standalone subroutine module}
END.
