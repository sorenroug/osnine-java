PROGRAM maze(input);
label 580,750,820,960;

const
    maxrows = 25;
    maxcols = 25;

type
  direction = (Left, Right, Up, Down);
  randlink = ^randentry;
  randentry = record
    next : randlink;
    case boolean of
      true : (randset : set of 0..15);
      false : (randinteger : integer);
    end;

var
  rows,cols,c,r,dx,entry,x,cellinx,totcells: integer;
  bottom: boolean;
  currrand, offsetrand : randlink;
  D: array[1..10] of direction;
  W: array[1..maxrows, 1..maxcols] of boolean;
  V: array[1..maxrows, 1..maxcols] of integer;

{ Initialisation of random number generator. }
procedure randinit;
  const
    n = 47;
    m = 5;
  var
    temp : randlink;
    index : integer;
    seed : array[1..n] of integer;

  begin
    seed[1] := 6936; seed[2] := 11137; seed[3] := 175;
    seed[4] := 28333; seed[5] := 8228; seed[6] := 23343;
    seed[7] := 16201; seed[8] := 525; seed[9] := 32646;
    seed[10] := 12998; seed[11] := 14044; seed[12] := 22459;
    seed[13] := 8155; seed[14] := 14560; seed[15] := 5428;
    seed[16] := 3057; seed[17] := 13500; seed[18] := 7489;
    seed[19] := 23956; seed[20] := 1631; seed[21] := 18724;
    seed[22] := 12979; seed[23] := 7543; seed[24] := 26891;
    seed[25] := 5076; seed[26] := 18818; seed[27] := 17248;
    seed[28] := 26679; seed[29] := 8706; seed[30] := 9342;
    seed[31] := 29575; seed[32] := 31530; seed[33] := 23069;
    seed[34] := 26123; seed[35] := 21236; seed[36] := 18077;
    seed[37] := 20080; seed[38] := 12260; seed[39] := 26133;
    seed[40] := 18581; seed[41] := 3331; seed[42] := 26261;
    seed[43] := 18650; seed[44] := 8271; seed[45] := 29635;
    seed[46] := 11322; seed[47] := 2239;
    index := 1;
    new(currrand);
    temp := currrand;
    currrand^.randinteger := seed[index];
    index := 2;

    while index <= m do
    begin
      new(currrand^.next);
      currrand^.next^.randinteger := seed[index];
      currrand := currrand^.next;
      index := index + 1;
    end;
    offsetrand := currrand;
    while index <= n do
      begin
        new(currrand^.next);
        currrand^.next^.randinteger := seed[index];
        currrand := currrand^.next;
        index := index + 1;
      end;
    currrand^.next := temp;
  end;

{ Random number generator between 0 and 32767. }
function rand : integer;
  begin
    currrand^.randset := (currrand^.randset - offsetrand^.randset) +
      (offsetrand^.randset - currrand^.randset);
    rand := currrand^.randinteger;
    currrand := currrand^.next;
    offsetrand := offsetrand^.next;
  end;

function random(maxval:integer):integer;
begin
    random := rand mod maxval;
end;

{ Ask for dimensions.
  Sets the global variables: cols and rows }
procedure dimensions;
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

{ Print top of the maze with an opening. }
procedure printtop;
  var
    col : integer;
  begin
    writeln;
    for col := 1 to cols do
      if col = entry then
        write('.  ')
      else
        write('.--');
    writeln('.');
  end;

{ Print maze }
procedure printmaze;
  var
    r, c : integer;
  begin
    for r := 1 to rows do
    begin
      write('|');
      for c := 1 to cols do
      begin
        if v[r, c] < 2 then
          write('  |')
        else
          write('   ');
      end;
      writeln;
      for c := 1 to cols do
      begin
        if (v[r, c] mod 2) = 0 then
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
        w[q,z] := false;
        v[q,z] := 0;
      end;
  end;

begin
  randinit;
  dimensions;
  totcells := rows * cols;
  initmaze;

  bottom := false;
  entry := random(cols) + 1;

  printtop;
  r := 1;
  c := entry;
  cellinx := 1;
  w[r, c] := true;

580:
  dx := 0;
  if c <> 1 then
  begin
    if w[r, c - 1] = false then
    begin
      dx := dx + 1;
      d[dx] := Left;
    end;
  end;
  if c <> cols then
  begin
    if w[r, c + 1] = false then
    begin
      dx := dx + 1;
      d[dx] := Right
    end
    else goto 750;
  end;
  if r > 1 then
  begin
    if w[r - 1, c] = false then
    begin
      dx := dx + 1;
      d[dx] := Up
    end;
  end;
750:
  if r < rows then
  begin
    if w[r + 1, c] = true then goto 820
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
      if w[r, c] = true then goto 580;
    end
  end;
  x := random(dx) + 1;
  case d[x] of
    Down:
      begin
        v[r, c] := v[r, c] + 1;
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
        v[r, c] := 1
      end;
    Right:
      begin
        v[r, c] := v[r, c] + 2;
        c := c + 1
      end;
    Left:
      begin
        c := c - 1;
        v[r, c] := 2
      end;
  end;

  cellinx := cellinx + 1;
  w[r, c] := true;
  if cellinx < totcells then goto 580;

  printmaze;
end.
