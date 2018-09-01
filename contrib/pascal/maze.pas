{ Generate a maze.
  The algoritm uses a two-dimensional matrix of cells, where the bottom
  or the right wall can be absent.
  Pascal does not have a 'continue' statement, therefore the goto 580.
}
PROGRAM maze(input);
label 580,750;

const
    MAXROWS = 25;
    MAXCOLS = 25;

    NO_FLOOR = 1;
    NO_RIGHT_WALL = 2;
    VISITED = 4;

type
  direction = (Left, Right, Up, Down);

var
  randstate: integer;
  rows,cols,c,r,dx,entry,x,cellinx,totcells: integer;
  bottom: boolean;
  d: array[1..10] of direction;
  cells: array[1..MAXROWS, 1..MAXCOLS] of integer;

function random(VAR block:integer) : real; EXTERNAL;
procedure randomize(VAR block:integer); EXTERNAL;

{ Provide a random integer }
function rnd(maxval:integer):integer;
begin
  rnd := trunc(random(randstate) * maxval);
end;

{ Ask for dimensions.
  Sets the global variables: cols and rows }
procedure AskDimensions;
  var
    goodsize : boolean;
  begin
    goodsize := false;
    repeat
      writeln('What are your length and width (e. g. 13 10)?');
      readln(rows, cols);
      if (rows > 1) or (rows <= MAXROWS) or (cols > 1) or (cols <= MAXCOLS) then
        goodsize := true
      else
        writeln('Meaningless dimensions.  Try again.');
    until goodsize = true;
  end;

procedure PrintMaze;
  var
    r, c : integer;
  begin
    { Print top of the maze with an opening. }
    writeln;
    for c := 1 to cols do
      if c = entry then
        write('.  ')
      else
        write('.--');
    writeln('.');

    for r := 1 to rows do
    begin
      write('|');
      for c := 1 to cols do
      begin
        if (cells[r, c] & NO_RIGHT_WALL) = 0 then
          write('  |')
        else
          write('   ');
      end;
      writeln;
      for c := 1 to cols do
      begin
        if (cells[r, c] & NO_FLOOR) = 0 then
          write(':--')
        else
          write(':  ');
      end;
      writeln(':');
    end
  end;

{ Find a cell that is already visited to continue from.
  Uses the global variables r, c, cols, rows and visited.
}
procedure FindVisited;
  begin
    repeat
      c := c + 1;
      if c > cols then
      begin
        r := r + 1;
        if r > rows then
          r := 1;
        c := 1
      end;
    until (cells[r, c] & VISITED) <> 0;
  end;

procedure InitMaze;
  var q,z : integer;
  begin
    for q := 1 to rows do
      for z := 1 to cols do
      begin
        cells[q,z] := 0;
      end;
  end;

procedure AddPossibility(go:direction);
  begin
    dx := dx + 1;
    d[dx] := go;
  end;

begin
  randstate := 0;
  randomize(randstate);
  AskDimensions;
  totcells := rows * cols;
  InitMaze;

  bottom := false;
  entry := rnd(cols) + 1;

  r := 1;
  c := entry;
  cellinx := 1;
  cells[r, c] := cells[r, c] ! VISITED;

  repeat
    dx := 0;
    if c <> 1 then
    begin
      if (cells[r, c - 1] & VISITED) = 0 then
      begin
        AddPossibility(Left)
      end;
    end;

    if c <> cols then
    begin
      if (cells[r, c + 1] & VISITED) = 0 then
      begin
        AddPossibility(Right)
      end
      else goto 750;
    end;

    if r > 1 then
    begin
      if (cells[r - 1, c] & VISITED) = 0 then
      begin
        AddPossibility(Up)
      end;
    end;

  750:
    if r < rows then
    begin
      if (cells[r + 1, c] & VISITED) = 0 then
        AddPossibility(Down);
    end
    else
    begin
      if bottom = false then
        AddPossibility(Down);
    end;

    if dx = 0 then
    begin
      FindVisited;
      goto 580;
    end;
    x := rnd(dx) + 1;
    case d[x] of
      Down:
        begin
          cells[r, c] := cells[r, c] ! NO_FLOOR;
          r := r + 1;
          if r > rows then
          begin
            bottom := true;
            r := 1;
            c := 0;
            FindVisited;
            goto 580;
          end
        end;
      Up:
        begin
          r := r - 1;
          cells[r, c] := NO_FLOOR
        end;
      Right:
        begin
          cells[r, c] := cells[r, c] ! NO_RIGHT_WALL;
          c := c + 1
        end;
      Left:
        begin
          c := c - 1;
          cells[r, c] := NO_RIGHT_WALL
        end;
    end;

    cellinx := cellinx + 1;
    cells[r, c] := cells[r, c] ! VISITED;
580:
  until cellinx >= totcells;

  PrintMaze;
end.
