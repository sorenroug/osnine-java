{$L5500 - Stack size in bytes }
{ Solve sudoku with recursive algoritm.
  But first sort the grid on number of guides to
  shorten the search.
}
PROGRAM sudoku;

TYPE
  valset = SET OF 1..9;
  state = RECORD
    row,col,numelm : integer;
    guides : valset
  END;
  statearr = ARRAY [0..80] OF state;

VAR
  grid : ARRAY [0..8,0..8] OF integer;
  scanorder : statearr;

{ Bubble sort of 81 values }
PROCEDURE sort(VAR list: statearr);
VAR
  i,j: integer;
  t: state;
BEGIN
  FOR i := 80 DOWNTO 2 DO
    FOR j := 0 TO i - 1 DO
      IF list[j].numelm < list[j + 1].numelm THEN
      BEGIN
        t := list[j];
        list[j] := list[j + 1];
        list[j + 1] := t;
      END;
END;

PROCEDURE fillgrid;
VAR
  i,j : integer;
  sudokufile : text;
BEGIN
  reset(sudokufile, 'sudoku.ini');
  FOR j := 0 TO 8 DO
    FOR i := 0 TO 8 DO
      read(sudokufile, grid[j,i]);
  close(sudokufile)
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

PROCEDURE scancell(y,x : integer; VAR n : valset);
VAR
  i,j,x0,y0 : integer;
BEGIN
  n := [];
  FOR i := 0 TO 8 DO
    IF grid[y,i] <> 0 THEN
      n := n + [grid[y,i]];
  FOR i := 0 TO 8 DO
    IF grid[i,x] <> 0 THEN
      n := n + [grid[i,x]];
  x0 := (x DIV 3) * 3;
  y0 := (y DIV 3) * 3;
  FOR i := 0 TO 2 DO
    FOR j := 0 TO 2 DO
      IF grid[y0+i,x0+j] <> 0 THEN
        n := n + [grid[y0+i,x0+j]];
END;

PROCEDURE scangrid;
VAR
  n,x,y,z : integer;
BEGIN
  FOR y := 0 TO 8 DO
    FOR x := 0 TO 8 DO
      BEGIN
        z := y*9 + x;
        scanorder[z].col := x;
        scanorder[z].row := y;
        scancell(y,x,scanorder[z].guides);
        scanorder[z].numelm := 0;
        FOR n := 1 TO 9 DO
          IF n IN scanorder[z].guides THEN
            scanorder[z].numelm := scanorder[z].numelm + 1;
      END;
  sort(scanorder);
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
  n,x,y,z : integer;
BEGIN
   FOR z := 0 TO 80 DO
     BEGIN
       x := scanorder[z].col;
       y := scanorder[z].row;
       IF grid[y,x] = 0 THEN
         BEGIN
           FOR n := 1 TO 9 DO
             IF NOT (n IN scanorder[z].guides) THEN
               IF possible(y,x,n) THEN
                 BEGIN
                   grid[y,x] := n;
                   solve;
                   grid[y,x] := 0
                 END;
           GOTO 200
         END
     END;
   printgrid;
200:
END;

BEGIN
  fillgrid;
  writeln('Initial grid:');
  printgrid;
  writeln('Solutions:');
  scangrid;
  solve
END.
