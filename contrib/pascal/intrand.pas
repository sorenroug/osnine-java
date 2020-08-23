{ Simple random generator using 16 bit integers }
PROGRAM intrand;
VAR
   randstate : integer;
   i : integer;

function rand:integer;
CONST
  MAXVAL = 32767;
VAR
  r : real;
BEGIN
    mathabort(false);
    randstate := randstate * 11035 + 6971;
    randstate := randstate mod MAXVAL;
    rand := randstate;
    mathabort(true);
END;

PROCEDURE srand(seed:integer);
BEGIN
    randstate := seed;
END;

PROCEDURE randomize;
  VAR
    year, month, day, hour, minute, second : integer;
BEGIN
  systime(year, month, day, hour, minute, second);
  randstate := second * 391 + minute * 13 + 23;
END;


BEGIN { main }
    randstate := 1;
    for i := 0 to 100 do
        write(rand);
END.
