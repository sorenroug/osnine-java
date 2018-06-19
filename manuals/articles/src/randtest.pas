PROGRAM test(input, output);
VAR
    res : real;
    i, s : integer;

FUNCTION rand(VAR i:integer) : real; EXTERNAL;

BEGIN
   writeln('Enter seed value (1..32767)');
   readln(s);
   s := -s;
   FOR i := 1 TO 30 DO BEGIN
      res := rand(s);
      writeln(res);
   END
END.
