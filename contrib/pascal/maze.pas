PROGRAM maze(input);
label 580,750,820,960;

const
    MAXROWS = 25;
    MAXCOLS = 25;

    NO_FLOOR = 1;
    NO_RIGHT_WALL = 2;

type
  direction = (Left, Right, Up, Down);

var
  randstate: integer;
  rows,cols,c,r,dx,entry,x,cellinx,totcells: integer;
  bottom: boolean;
  d: array[1..10] of direction;
  visited: array[1..MAXROWS, 1..MAXCOLS] of boolean;
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
procedure askdimensions;
  var
    goodsize : boolean;
  begin
    goodsize := false;
    repeat
      writeln('What are your length and width (e. g. 13 10)?');
      readln(rows, cols);
      if (rows > 1) or (rows <= 25) or (cols > 1) or (cols <= 25) then
        goodsize := true
      else
        writeln('Meaningless dimensions.  Try again.');
    until goodsize = true;
  end;

{ Print maze }
procedure printmaze;
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
        if cells[r, c] < 2 then
          write('  |')
        else
          write('   ');
      end;
      writeln;
      for c := 1 to cols do
      begin
        if (cells[r, c] mod 2) = 0 then
          write(':--')
        else
          write(':  ');
      end;
      writeln(':');
    end
  end;

procedure initmaze;
  var q,z : integer;
  begin
    for q := 1 to rows do
      for z := 1 to cols do
      begin
        visited[q,z] := false;
        cells[q,z] := 0;
      end;
  end;

begin
  randstate := 0;
  randomize(randstate);
  askdimensions;
  totcells := rows * cols;
  initmaze;

  bottom := false;
  entry := rnd(cols) + 1;

  r := 1;
  c := entry;
  cellinx := 1;
  visited[r, c] := true;

580:
  dx := 0;
  if c <> 1 then
  begin
    if visited[r, c - 1] = false then
    begin
      dx := dx + 1;
      d[dx] := Left;
    end;
  end;
  if c <> cols then
  begin
    if visited[r, c + 1] = false then
    begin
      dx := dx + 1;
      d[dx] := Right
    end
    else goto 750;
  end;
  if r > 1 then
  begin
    if visited[r - 1, c] = false then
    begin
      dx := dx + 1;
      d[dx] := Up
    end;
  end;
750:
  if r < rows then
  begin
    if visited[r + 1, c] = true then goto 820
  end
  else
  begin
    if bottom = true then goto 820
  end;
  dx := dx + 1;
  d[dx] := Down;
820:
  if dx = 0 then
  begin
    while true do
    begin
      c := c + 1;
      if c > cols then
      begin
        r := r + 1;
        if r > rows then
          r := 1;
        c := 1
      end;
960:
      if visited[r, c] = true then goto 580;
    end
  end;
  x := rnd(dx) + 1;
  case d[x] of
    Down:
      begin
        cells[r, c] := cells[r, c] + NO_FLOOR;
        r := r + 1;
        if r > rows then
        begin
          bottom := true;
          r := 1;
          c := 1;
          goto 960;
        end
      end;
    Up:
      begin
        r := r - 1;
        cells[r, c] := NO_FLOOR
      end;
    Right:
      begin
        cells[r, c] := cells[r, c] + NO_RIGHT_WALL;
        c := c + 1
      end;
    Left:
      begin
        c := c - 1;
        cells[r, c] := NO_RIGHT_WALL
      end;
  end;

  cellinx := cellinx + 1;
  visited[r, c] := true;
  if cellinx < totcells then goto 580;

  printmaze;
end.
