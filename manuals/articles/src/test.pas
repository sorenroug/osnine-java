PROGRAM test(input, output);
VAR
    randstate : integer;
    res : real;
    i,s : integer;

FUNCTION rand(VAR i:integer; VAR block:integer) : real; EXTERNAL;

BEGIN
   randstate := 0;
   writeln('Enter seed value (1..32767)');
   readln(s);
   s := -s;
   FOR i := 1 TO 30 DO BEGIN
      res := rand(s, randstate);
      writeln(res:6:6);
   END   
END.
