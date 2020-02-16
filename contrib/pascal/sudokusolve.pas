{$L1500 - Stack size in bytes }
{ Solve sudoku with recursive algoritm }
PROGRAM sudoko;

VAR
  grid : ARRAY [0..8,0..8] OF integer;

PROCEDURE fillgrid;
VAR
  i,j : integer;
BEGIN
  FOR j := 0 TO 8 DO
      FOR i := 0 TO 8 DO
         grid[j,i] := 0;

  grid[0,0] := 5; grid[0,1] := 3; grid[0,4] := 7;
  grid[1,0] := 6; grid[1,3] := 1; grid[1,4] := 9; grid[1,5] := 5;
  grid[2,1] := 9; grid[2,2] := 8; grid[2,7] := 6;
  grid[3,0] := 8; grid[3,4] := 6; grid[3,8] := 3;
  grid[4,0] := 4; grid[4,3] := 8; grid[4,5] := 3; grid[4,8] := 1;
  grid[5,0] := 7; grid[5,4] := 2; grid[5,8] := 6;
  grid[6,1] := 6; grid[6,6] := 2; grid[6,7] := 8;
  grid[7,3] := 4; grid[7,4] := 1; grid[7,5] := 9; grid[7,8] := 5;
  grid[8,4] := 8; grid[8,7] := 7; grid[8,8] := 9
END;

PROCEDURE printgrid;
VAR
  i,j : integer;

BEGIN
  FOR j := 0 TO 8 DO
    BEGIN
      FOR i := 0 TO 8 DO
         write(grid[j,i]:2);
      writeln
    END;
    writeln
END;

FUNCTION possible(y,x,n : integer):boolean;
LABEL
  100;
VAR
  i,j,x0,y0 : integer;
BEGIN
  possible := false;
  FOR i := 0 TO 8 DO
    IF grid[y,i] = n THEN
      GOTO 100;
  FOR i := 0 TO 8 DO
    IF grid[i,x] = n THEN
      GOTO 100;
  x0 := (x DIV 3) * 3;
  y0 := (y DIV 3) * 3;
  FOR i := 0 TO 2 DO
    FOR j := 0 TO 2 DO
      IF grid[y0+i,x0+j] = n THEN
        GOTO 100;
  possible := true;
100:
END;

PROCEDURE solve;
LABEL 200;
VAR
  n,x,y : integer;
BEGIN
   FOR y := 0 TO 8 DO
     FOR x := 0 TO 8 DO
       IF grid[y,x] = 0 THEN
         BEGIN
           FOR n := 1 TO 9 DO
             IF possible(y,x,n) THEN
               BEGIN
                 grid[y,x] := n;
                 solve;
                 grid[y,x] := 0
               END;
           GOTO 200
         END;
   printgrid;
200:
END;

BEGIN
  fillgrid;
  writeln('Initial grid:');
  printgrid;
  writeln('Solutions:');
  solve
END.
