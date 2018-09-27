{
SUPER STARTREK - MAY 16,1978

****        **** STAR TREK ****        ****
**** SIMULATION OF A MISSION OF THE STARSHIP ENTERPRISE,
**** AS SEEN ON THE STAR TREK TV SHOW.
**** ORIGINAL PROGRAM BY MIKE MAYFIELD, MODIFIED VERSION
**** PUBLISHED IN DEC'S '101 BASIC GAMES', BY DAVE AHL.
**** MODIFICATIONS TO THE LATTER (PLUS DEBUGGING) BY BOB
*** LEEDOM - APRIL & DECEMBER 1974,
*** WITH A LITTLE HELP FROM HIS FRIENDS . . .
}

program startrek;

const
  ORGTORPS = 10;
  D_NAV = 1;
  D_SHE = 7;
type
  klingon_t = record
      sectx,secty:integer;
      energy:real
    end;
  feature = array [1..3] of char;
  qname = array [1..15] of char;
  roman = array [1..4] of char;

var
  randstate : integer;
  startdate,time : real;
  gameison : boolean;
  q : array[1..8,1..8] of feature;
  o1 : array[1..52] of char;
  g,z : array [1..8,1..8] of integer;
  c : array [1..9,1..2] of integer;
  n : array [1..3] of integer;
  k : array [1..3] of klingon_t;
  dmg : array[1..8] of real;
  as : array [1..3] of char;
  s, p, e, e0, eneed, duration,starbases : integer;
  z3 : boolean;
  orgklings, klingons : integer;
  k3,s3,b3,s1,s2, sb1,sb2,i,j,rd : integer;
  x, y, r1, r2: integer;
  s9 : real;
  d4 : real;
  q1,q2,q4,q5 : integer;
  d1,h8,docked : boolean;

{ Returns a random number between 0.0 and 1.0 }
function random(var block:integer) : real; external;
procedure randomize(var block:integer); external;

procedure newquadrant; forward;
procedure shortrange; forward;
procedure enemyfire; forward;
procedure exceedquadrant(x1,x2:real); forward;

{ Provide a random real 0 <= x < 1 }
function rnd1:real;
begin
  rnd1 := random(randstate);
end;

{ Provide a random integer 0 <= x < maxval }
function rnd(maxval:integer):integer;
begin
  rnd := trunc(random(randstate) * maxval);
end;

function rand8i:integer;
begin
  rand8i := rnd(8) + 1;
end;

{ Print X lines }
procedure lines(n: integer);
  var i: integer;
  begin
    For i:=1 to n do writeln
  end;

procedure tab(num:integer);
  var
    i:integer;
  begin
    for i := 1 to num do
      write(' ');
  end;

{ Insert in string array for quadrant }
procedure insertfeature(a: feature; z1,z2: integer);
  begin
    q[z1,z2] := a
  end;

function checkfeature(a: feature; z1, z2: integer) : boolean;
  begin
    checkfeature := false;
    if q[z1,z2] = a then
        checkfeature := true;
  end;

{ Find empty place in quadrant (for things) }
procedure findempty;
  var
    z3: boolean;
  begin
    repeat
      r1 := rand8i;
      r2 := rand8i;
      z3 := checkfeature('   ', r1, r2);
    until z3=true;
  end;

{ Read an integer }
function readint:integer;
  var
    i,r : integer;
  begin
    prompt;
    repeat
      ioabort(input, false);
      readln(i);
      r := ioresult(input);
      ioabort(input, true);
      if r <> 0 then
        begin
          writeln('** Input error - reenter **');
          readln(input)
        end;
    until r = 0;
    readint := i;
  end;

{ Find the last letter in the string }
function lastletter(st : qname) : integer;
  label 100;
  var
    i : integer;
  begin
    lastletter := 0;
    for I := 15 downto 1 do
      if st[i] <> ' ' then
        begin
          lastletter := i;
          goto 100
        end;
    100:
  end;

{ END OF GAME }
procedure resign;
begin
  gameison := false;
  if klingons > 0 then
    begin
      writeln('There were ',klingons:2,' Klingon battle cruisers left at');
      writeln('the end of your mission.');
    end;
  writeln;
  writeln;
end;

procedure outoftime;
begin
  writeln('It is stardate ',time,'.');
  resign;
end;

procedure destruction;
begin
  writeln;
  writeln('The Enterprise has been destroyed.  Then federation will be conquered.');
  outoftime;
end;

procedure wongame;
  begin
    gameison := false;
    writeln('Congratulation, captain!  The last Klingon battle cruiser');
    writeln('menacing the federation has been destroyed.');
    writeln;
    writeln('Your efficiency rating is ', 1000*sqr(orgklings/(time-startdate)));
    resign;
  end;

procedure initquadrant;
  var
    i,j : integer;
  begin
    for i := 1 to 8 do
      for j := 1 to 8 do
        q[i,j] := '   ';
  end;

procedure direction(dX,dY : integer);
  label 10,20,30;
  var
    res : real;
    h : integer;
  begin
    dY := -dY;
    h := 1;
    if dY<0 then
      begin
        if dX>0 then
          begin
            h := 3;
            goto 20
          end;
        if dY<>0 then
          begin
            h := 5;
            goto 10
          end
        else
          begin
            h := 7;
            goto 20
          end
      end;
    if dX<0 then
      begin
        h := 7;
        goto 20
      end;

    if dY>0 then
      h := 1
    else
      if dX=0 then
        h := 5;

    10:
    if ABS(dX)<=ABS(dY) then
      res := h + (ABS(dX)/ABS(dY))
    else
      res := h + (((ABS(dX)-ABS(dY))+ABS(dX)) / ABS(dX));
    goto 30;

    20:
    if ABS(dX)>=ABS(dY) then
      res := h + (ABS(dY)/ABS(dX))
    else
      res := h + (((ABS(dY)-ABS(dX))+ABS(dY)) / ABS(dY));

    30:
    writeln('Direction = ',res:6:5);
    writeln('Distance = ',SQRT(SQR(dY) + SQR(dX)):6:5)
  end;

procedure initialize;
  var
    i,j : integer;
    t1 : real;
  begin
    lines(11);
    writeln('                                    ,------*------,');
    writeln('                    ,-------------   ''---  ------''');
    writeln('                     ''-------- --''      / /');
    writeln('                         ,---'' ''-------/ /--,');
    writeln('                          ''----------------''');
    writeln;
    writeln('                    THE USS ENTERPRISE --- NCC-1701');
    lines(5);

    time := 0.0 + (rnd(20)+20)*100;
    startdate := time;
    duration := 25 + rnd(10);
    docked := false;
    e := 3000;
    e0 := e;
    p := ORGTORPS;
    s9 := 200;
    s := 0;
    starbases := 0;
    klingons := 0;

    q1 := rnd(8)+1;
    q2 := rnd(8)+1;
    s1 := rnd(8)+1;
    s2 := rnd(8)+1;

    for i := 1 to 9 do
      begin
        c[i,1]:=0;  c[i,2]:=0
      end;
    c[3,1]:=-1;  c[2,1]:=-1;  c[4,1]:=-1;  c[4,2]:=-1;  c[5,2]:=-1;  c[6,2]:=-1;
    c[1,2]:=1;  c[2,2]:=1;  c[6,1]:=1;  c[7,1]:=1;  c[8,1]:=1;  c[8,2]:=1;  c[9,2]:=1;

    for i := 1 to 8 do dmg[i] := 0;
{
SETUP WHAT EXISTS IN GALAXY . . .
K3= # KLINGONS  B3= # STARBASES  S3 = # STARS
}
  for i := 1 to 8 do
    for j := 1 to 8 do
      begin
        k3 := 0;
        z[i,j] := 0;
        t1 := random(randstate);
        if t1 > 0.98 then
          begin
            k3 := k3 + 1;
            klingons := klingons+1
          end;

        if t1 > 0.95 then
          begin
            k3 := k3 + 1;
            klingons := klingons+1
          end;
        if t1 > 0.80 then
          begin
            k3 := k3 + 1;
            klingons := klingons+1
          end;
        
        b3 := 0;
        if random(randstate) > 0.96 then
          begin
            b3 := 1;
            starbases := starbases+1;
          end;
          s3 := rand8i;
          g[i,j] := k3*100 + b3*10 + s3
       end; { for j }

    if klingons > duration then
      duration := klingons+1;

    if starbases = 0 then
      begin
        { ADD A KLINGON TO THE SECTOR WITH THE ONLY STARBASE }
        if g[q1,q2]<200 then
          begin
            g[q1,q2] := g[q1,q2]+100;
            klingons := klingons+1
          end;
        starbases := 1;
        g[q1,q2] := g[q1,q2]+10;
        q1 := rand8i;
        q2 := rand8i
      end;

    orgklings := klingons;
    writeln('Your orders are as follows:');
    writeln('''Destroy the ',klingons:2,' Klingon warships which have invaded');
    writeln('the galaxy before they can attack federation');
    writeln('headquarters on stardate ',startdate+duration:4:0,'. This gives you ',duration:2);
    if starbases <> 1 then
      writeln('days. There are ',starbases:1,' starbases in the galaxy for')
    else
      writeln('days. There is ',starbases:1,' starbase in the galaxy for');
    writeln('resupplying your ship.''');
    writeln;
    newquadrant;
    shortrange;
  {

}
end;

{ Append Roman numeral to string }
procedure appendnum(var name: qname; num: roman);
  var
    last,i : integer;
  begin
    last := lastletter(name);
    for i := 1 to 4 do
      name[last + i] := num[i];
  end;

{ Return quadrant name from Q1,Q2
  Call with NAMEONLY=1 to get region name only }
procedure quadrant(q1,q2,nameonly: integer; var name: qname);
  var
    tmp : qname;

  begin
    If q2 <= 4 then
      case q1 of
        1: tmp := 'ANTARES        ';
        2: tmp := 'RIGEL          ';
        3: tmp := 'PROCYON        ';
        4: tmp := 'VEGA           ';
        5: tmp := 'CANOPUS        ';
        6: tmp := 'ALTAIR         ';
        7: tmp := 'SAGITTARIUS    ';
        8: tmp := 'POLLUX         '
      end
    else
      case q1 of
        1: tmp := 'SIRIUS         ';
        2: tmp := 'DENEB          ';
        3: tmp := 'CAPELLA        ';
        4: tmp := 'BETELGEUSE     ';
        5: tmp := 'ALDEBARAN      ';
        6: tmp := 'REGULUS        ';
        7: tmp := 'ARCTURUS       ';
        8: tmp := 'SPICA          '
      end;
    if nameonly <> 1 then
      case q2 of
        1,5: appendnum(tmp, ' I  ');
        2,6: appendnum(tmp, ' II ');
        3,7: appendnum(tmp, ' III');
        4,8: appendnum(tmp, ' IV ')
      end;
      name := tmp
  end;

{ HERE ANY TIME NEW QUADRANT ENTERED }
procedure newquadrant;
var
  i,j : integer;
  g2: qname;
begin
  k3 := 0;
  b3 := 0;
  s3 := 0;
  d4 := 0.5 * rnd1;
  z[q1,q2] := g[q1,q2];
  {
  if Q1<1 OR Q1>8 OR Q2<1 OR Q2>8 then 2210 ; REM HUH?
  }
  quadrant(q1,q2,0,g2);
  writeln;
  if startdate<>time then
    writeln('Now entering ',g2,' quadrant . . .')
  else
    begin
      writeln('Your mission begins with your starship located');
      writeln('in the galactic quadrant, ',g2,'.');
    end;
  writeln;
  k3 := g[q1,q2] div 100;
  b3 := g[q1,q2] div 10 - 10*k3;
  s3 := g[q1,q2] - 100*k3 - 10*b3;
  if k3 > 0 then
    begin
      writeln('Combat area      Condition RED');
      if s<=200 then
        writeln('   Shields dangerously low');
    end;
  for i := 1 to 3 do
    begin
      k[i].sectx := 0;
      k[i].secty := 0;
      k[i].energy := 0
    end;

  for i := 1 to 8 do
    for j := 1 to 8 do
      q[i,j] := '   ';

{ Position Enterprise in quadrant, then place 'K3' klingons, &
  'B3' starbases, & 'S3' stars elsewhere. }
  insertfeature('<*>', s1, s2);
  if k3>0 then
    for i := 1 to k3 do
      begin
        findempty;
        insertfeature('+K+', r1, r2);
        k[i].sectx := r1;
        k[i].secty := r2;
        k[i].energy := s9*(0.5+rnd1)
      end;

  if b3>0 then
    begin
      findempty;
      sb1 := r1;
      sb2 := r2;
      insertfeature('>!<', r1, r2)
    end;
  for i := 1 to s3 do
    begin
      findempty;
      insertfeature(' * ', r1, r2)
    end;
end;

{ PRINT DEVICE NAME }
procedure devicename(rd: integer);
begin
  case rd of
    1: write('Warp engines');
    2: write('Short range sensors');
    3: write('Long range sensors');
    4: write('Phaser control');
    5: write('Photon tubes');
    6: write('Damage control');
    7: write('Shield control');
    8: write('Library-computer');
  end
end;

{ MANEUVER ENERGY S/R **}
procedure useenergy;
begin
  e := e-eneed-10;
  if e < 0 then
    begin
      writeln('Shield control supplies energy to complete the maneuver.');
      s := s+e;
      e := 0;
      if s <= 0 then s := 0;
    end;
end;

{ Course control begins here }
procedure coursecontrol;
  label 1,2880,3360,3370;
  var
    i, c1i: integer;
    c1: real;
    sX: array [1..3] of char;
    x,y,x1, x2, d6, w1, t8: real; { Time of Travelling }

  begin
    write('Course (1-9)? ');
    prompt;
    readln(c1);
    If c1=9 then c1 := 1;

    if (c1 < 1) OR (c1 > 9) then
      begin
        writeln('   Lt. Sulu reports, ''Incorrect course data, sir!''');
        goto 1;
      end;

    write('Warp factor (0-');
    if dmg[D_NAV] < 0 then write('0.2') else write('8');
    write('):? ');
    prompt;
    readln(w1);
    if (dmg[D_NAV] < 0) AND (w1 > 0.2) then
      begin
        writeln('Warp engines are damaged.  Maxium speed = warp 0.2');
        goto 1
      end;
    if w1 = 0 then
      goto 1;

    if (w1 < 0) or (w1 > 8) then
      begin
        writeln('   Chief engineer scott reports ''The engines won''t take warp ',w1:1,'!''');
        goto 1
      end;
    eneed := round(w1 * 8);
    if e-eneed < 0 then
      begin
        writeln('Engineering reports   ''Insufficient energy available');
        writeln('                       for maneuvering at warp ',w1:1,'!''');
        if (s < eneed-e) OR (dmg[D_SHE] < 0) then
          goto 1;
        writeln('Deflector control room acknowledges ',S,' units of energy');
        writeln('                         presently deployed to shields.');
        goto 1;
      end;


    { Klingons move/fire on moving starship . . . }
    for i := 1 to k3 do
      if k[i].energy <> 0 then
        begin
          insertfeature('   ', k[i].sectx, k[i].secty);
          findempty;
          k[i].sectx := r1;
          k[i].secty := r2;
          insertfeature('+K+', r1, r2);
        end;

    enemyfire;
    d1 := false;
    d6 := w1;
    if w1 >= 1 then d6 := 1;

    for i := 1 to 8 do
      begin
        if dmg[I]>=0 then goto 2880;
        dmg[I] := dmg[i]+d6;
        if (dmg[i] > -0.1) and (dmg[i]<0) then
          begin
            dmg[i] := -0.1;
            goto 2880
          end;
      if dmg[i]<0 then goto 2880;
      if d1=false then
        begin
          d1 := true;
          write('Damage control report:  ');
        end;
      tab(8);
      rd := i;
      devicename(i);
      writeln(' repair completed.');
2880:
    end;

    if rnd1 < 0.2 then
      begin
        rd := rand8i;
        write('Damage control report:  ');
        devicename(rd);
        if rnd1 >= 0.6 then
          begin
            dmg[rd] := dmg[rd]+rnd(3)+1;
            writeln(' state of repair improved')
          end
        else
          begin
            dmg[rd] := dmg[rd]-(rnd(5)+1);
            writeln(' damaged')
          end;
        writeln;
      end;

{ Begin moving starship }
    insertfeature('   ', s1, s2);
    x := s1;
    y := s2;
    c1i := round(c1 - 0.5);
    x1 := c[c1i,1] + (c[c1i+1,1]-c[c1i,1]) * (c1-c1i);
    x2 := c[c1i,2] + (c[c1i+1,2]-c[c1i,2]) * (c1-c1i);
    q4 := q1;
    q5 := q2;

    for i := 1 to eneed do
      begin
        x := x+x1;
        y := y+x2;
        if (x<1) or (x>=9) or (y<1) or (y>=9) then
          begin
            exceedquadrant(x1,x2);
            goto 1
          end;
        z3 := checkfeature('   ', round(x - 0.5), round(y - 0.5));
        if z3=false then
          begin
            x := round(x-x1 - 0.5);
            y := round(y-x2 - 0.5);
            write('Warp engines shut down at ');
            writeln('sector ',x:1:0,',',y:1:0,' due to bad navigation');
            goto 3360
          end;
      end;
3360:
    s1 := round(x - 0.5);
    s2 := round(y - 0.5);
3370:
    insertfeature('<*>', s1, s2);
    useenergy;
    t8 := 1;
    if w1<1 then
      t8 := 0.1 * aint(10*w1);
    time := time+t8;
    if time > startdate + duration then outoftime;
    { SEE IF DOCKED, then GET COMMAND }
    shortrange;
1:
  end;
 
{EXCEEDED QUADRANT LIMITS }
procedure exceedquadrant; 
label 9;
var
  x5: boolean;
begin
  x := round(8*q1 + s1 + eneed*x1);
  y := round(8*q2 + s2 + eneed*x2);
  q1 := round(x/8 - 0.5);
  q2 := round(y/8 - 0.5);
  s1 := round(x-q1*8 - 0.5);
  s2 := round(y-q2*8 - 0.5);
  if s1=0 then begin q1 := q1-1 ; s1 := 8 end;
  if s2=0 then begin q2 := q2-1 ; s2 := 8 end;

  x5 := false;
  if q1<1 then begin x5 := true ; q1 := 1 ; s1 := 1 end;
  if q1>8 then begin x5 := true ; q1 := 8 ; s1 := 8 end;
  if q2<1 then begin x5 := true ; q2 := 1 ; s2 := 1 end;
  if q2>8 then begin x5 := true ; q2 := 8 ; s2 := 8 end;
  if x5=true then
    begin
      writeln('Lt. Uhura reports message from starfleet command:');
      writeln('  ''Permission to attempt crossing of galactic perimeter');
      writeln('  is hereby *DENIED*.  Shut down your engines.''');
      writeln('Chief engineer Scott reports  ''Warp engines shut down');
      writeln('  at sector ',s1:1,',',s2:1,' of quadrant ',q1:1,',',q2:1,'.''');
      if time > startdate + duration then begin outoftime; goto 9 end;
    end;

{
if 8*q1+q2 = 8*q4+q5 then 3370
}
  time := time + 1;
  useenergy;
  newquadrant;
  shortrange;
9:
end;

{ Print a value with prefixed zeros }
procedure zeroprint(val : integer);
begin
   write(val:3,' ');
end;

{ Long range sensor scan code }
procedure longrange;
label 3;
var
  i,j,l: integer;
begin
  if dmg[3]<0 then
    begin
      writeln('Long range sensors are inoperable');
      goto 3
    end;
  writeln('Long range scan for quadrant ',q1:1,',',q2:1);
  writeln('-------------------');
  for i := q1-1 to q1+1 do
    begin
      n[1] := -1;
      n[2] := -2;
      n[3] := -3;
      for j := q2-1 to q2+1 do
        if (i>0) and (i<9) and (j>0) and (j<9) then
          begin
            n[j-q2+2] := g[i,j];
            z[i,j] := g[i,j]
          end;
      for l := 1 to 3 do
        begin
          write(': ');
          if n[l] < 0 then
            write('*** ')
          else
            zeroprint(n[l]);
        end;
      writeln(':')
    end;
    writeln('-------------------');
3:
end;

procedure noships;
begin
  writeln('Science officer Spock reports  ''Sensors show no enemy ships');
  writeln('                                in this quadrant''');
end;

{ Phaser control code begins here }
procedure phaser;
label 4670,4680;
var
  i,h:integer;
  h1,xsq,ysq:real;
begin
  if dmg[4]<0 then
    begin
      writeln('Phasers inoperative');
      goto 4680
    end;

  if k3<=0 then
    begin
      noships;
      goto 4680
    end;

  if dmg[8]<0 then
    writeln('Computer failure hampers accuracy');
  write('Phasers locked on target;  ');

  repeat
    writeln('Energy available = ',E:4,' units');
    write('Number of units to fire ');
    prompt;
    readln(x);
    if x<=0 then
      begin
        writeln('Phaser fire cancelled');
        goto 4680;
      end;
  until e >= x;
  e := e-x;
  if dmg[D_SHE]<0 then x := round(x * rnd1);

  h1 := x / k3;
  for i := 1 to 3 do
    begin
      if k[i].energy <= 0 then goto 4670;
      xsq := sqr(k[i].sectx - s1);
      ysq := sqr(k[i].secty - s2);
      h := round((h1 / sqrt(xsq + ysq))*(rnd1+2));
      if h <= 0.15 * k[i].energy then
        writeln('Sensors show no damage to enemy at ',k[i].sectx:1,',',k[i].secty:1)
      else
        begin
          k[i].energy := k[i].energy - h;
          writeln(h,' Unit hit on klingon at sector ',k[i].sectx:1,',',k[i].secty:1);
          if k[i].energy <= 0 then
            begin
              writeln('*** KLINGON DESTROYED ***');
              k3 := k3-1;
              klingons := klingons-1;
              insertfeature('   ', k[i].sectx, k[i].secty);
              k[i].energy := 0;
              g[q1,q2] := g[q1,q2]-100;
              z[q1,q2] := g[q1,q2];
              if klingons<=0 then wongame;
            end;
          writeln('   (Sensors show ',ROUND(k[i].energy),' units remaining)');
        end;
    4670:
    end;
    enemyfire;
  4680:
end;

{ Photon torpedo code begins here }
procedure firetorpedo;
label 4760,5190,5430,5500;
var
  i,x3,y3:integer;
  c1,x,y,x1,x2:real;
begin
  if p<=0 then
    begin
      writeln('All photon torpedoes expended');
      goto 5500
    end;

  if dmg[5]<0 then
    begin
      writeln('Photon tubes are not operational');
      goto 5500
    end;
  4760:
  write('Photon torpedo course (1-9) ');
  prompt;
  readln(c1);
  if c1 = 9 then c1 := 1;
  if (c1<1) or (c1>9) then
    begin
      writeln('Ensign Chekov reports,  ''Incorrect course data, sir!''');
      goto 5500
    end;
  e := e-2;
  p := p-1;
  j := round(c1 - 0.5);
  x1 := c[j,1] + (c[j+1,1]-c[j,1]) * (c1-j);
  x2 := c[j,2] + (c[j+1,2]-c[j,2]) * (c1-j);
  x := s1;
  y := s2;
  writeln('Torpedo track:');

  repeat
    x := x + x1;
    y := y + x2;
    x3 := round(x);
    y3 := round(y);
    if (x3<1) or (x3>8) or (y3<1) or (y3>8) then
      begin
        writeln('Torpedo missed');
        enemyfire;
        goto 5500
      end;
    writeln('               ',x3:1,',',y3:1);
    z3 := checkfeature('   ', x3, y3);
  until z3=false;
{ We have now hit something }
  z3 := checkfeature('+K+', x3, y3);
  if z3=true then
    begin
      writeln('*** KLINGON DESTROYED ***');
      k3 := k3-1;
      klingons := klingons-1;
      if klingons<=0 then wongame;
      for i := 1 to 3 do
        if (x3=k[i].sectx) and (y3=k[i].secty) then goto 5190;

      i := 3;
      5190:
      k[i].energy := 0;
      goto 5430
    end;
  z3 := checkfeature(' * ', x3, y3);
  if z3=true then
    begin
      writeln('Star at ',x3:1,',',y3:1,' absorbed torpedo energy.');
      enemyfire;
      goto 5500
    end;

  z3 := checkfeature('>!<', x3, y3);
  if z3=false then goto 4760;
  writeln('*** STARBASE DESTROYED ***');
  b3 := b3-1;
  starbases := starbases-1;
  if (starbases > 0) or (klingons > time - startdate - duration) then
    begin
      writeln('Starfleet command reviewing your record to consider');
      writeln('court martial!');
      docked := false
    end
  else
    begin
      writeln('That does it, captain!!  You are hereby relieved of command');
      writeln('and sentenced to 99 stardates at hard labor on cygnus 12!!');
      resign;
    end;
  5430:
  insertfeature('   ', x3, y3);
  g[q1,q2] := k3*100+b3*10+s3;
  z[q1,q2] := g[q1,q2];
  enemyfire;
5500:
end;

{ Shield control }
procedure shieldcontrol;
label 2;
var
  newval : integer;
begin
  if dmg[D_SHE]<0 then
    begin
      writeln('Shield control inoperable');
      goto 2
    end;
  write('Energy available = ',e+s:4);
  write(' Number of units to shields? ');
  newval := readint;
  if (newval<0) or (s=newval) then
    begin
      writeln('<SHIELDS UNCHANGED>');
      goto 2
    end;

  if newval > e+s then
  begin
    writeln('Shield control reports  ''This is not the federation treasury.''');
    writeln('<SHIELDS UNCHANGED>');
    goto 2
  end;
  e := e+s-newval;
  s := newval;
  writeln('Deflector control room report:');
  writeln('  ''Shields now at ',s:4,' units per your command.''');
2:
end;

{ DAMAGE CONTROL }
procedure damagecontrol;
label 5720,5910,5980;
var
  repairyn : char;
  i,rd : integer;
  d3 : real;
begin
  if dmg[6]>=0 then goto 5910;
  writeln('Damage control report not available');
  if docked=false then goto 5980;

5720:
  d3 := 0;
  for i := 1 to 8 do
    if dmg[i]<0 then d3 := d3 + 0.1;

  if d3=0 then
    goto 5980;

  writeln;
  d3 := d3 + d4;
  if d3 >= 1 then d3 := 0.9;

  writeln('Technicians standing by to effect repairs to your ship;');
  writeln('Estimated time to repair: ',0.01*aint(100*d3):1:2,' stardates.');
  write('Will you authorize the repair order (y/n)? ');
  prompt;
  readln(repairyn);
  if repairyn <>'y' then
    goto 5980;

  for i := 1 to 8 do
    if dmg[i]<0 then dmg[i] := 0;

  time := time + d3 + 0.1;
5910:
  writeln;
  writeln('Device             State of repair');
  for rd := 1 to 8 do
    begin
      devicename(rd);
      writeln((aint(dmg[rd]*100) * 0.01):6:2)
    end;
  writeln;
  if docked=true then goto 5720;
5980:
end;

{ KLINGONS SHOOTING }
procedure enemyfire;
label 4,5;
var
  i: integer;
  h: real;
  xsq,ysq : real;
begin
  if k3<=0 then goto 5;

  if docked=true then
    begin
      writeln('Starbase shields protect the enterprise');
      goto 5;
    end;

  for i := 1 to 3 do
    begin
      if k[i].energy <= 0 then goto 4;

      xsq := sqr(k[i].sectx - s1);
      ysq := sqr(k[i].secty - s2);
      h := aint((k[i].energy/sqr(xsq + ysq))*(rnd1 + 2));
      s := s-round(h);
      k[i].energy := aint(k[i].energy/(3 + rnd1));
      writeln(h:3:0,' unit hit on Enterprise from sector ',k[i].sectx:1,',',k[i].secty:1);
      if s<=0 then begin destruction; goto 5 end;
      writeln('      <SHIELDS DOWN TO ',S:4,' UNITS>');
      if h<20 then goto 4;
      if (rnd1 > 0.6) or (h/s <= 0.02) then goto 4;
      rd := rand8i;
      dmg[rd] := dmg[rd]-h/s - 0.5*rnd1;
      write('Damage control reports:    ''');
      devicename(rd);
      writeln(' damaged by the hit''');
    4:
    end;
5:
end;

{ SHORT RANGE SENSOR SCAN & STARTUP SUBROUTINE }
procedure shortrange;
  var
    cs : array[1..6] of char;
    i,j : integer;
begin
  docked := false;
  if k3 > 0 then
    cs := '*RED* '
  else
    begin
      cs := 'GREEN ';
      if e < e0 * 0.1 then
        cs := 'YELLOW';
    end;
  for i := s1-1 to s1+1 do
    for j := s2-1 to s2+1 do
      if (i>0) and (i<=8) and (j>0) and (j<=8) then
        begin
          z3 := checkfeature('>!<', i, j);
          if z3 = true then
            begin
              docked := true ;
              cs := 'DOCKED';
              e := e0;
              p := ORGTORPS;
              writeln('Shields dropped for docking purposes');
              s := 0
            end
        end;
  
  if dmg[2]<0 then
    begin
      writeln;
      writeln('*** SHORT RANGE SENSORS ARE OUT ***');
      writeln;
    end
  else
    begin
      writeln('---1---2---3---4---5---6---7---8---');
      for i := 1 to 8 do
        begin
          write(i:1);
            for j := 1 to 8 do
              write(' ', q[i,j]);
          writeln(' ',i:1)
        end;
      writeln('---1---2---3---4---5---6---7---8---');
      for i := 1 to 8 do
        case i of
          1: writeln('     Stardate           ',time:6:1);
          2: writeln('     Condition          ',cs);
          3: writeln('     Quadrant           ',q1:1,',',q2:1);
          4: writeln('     Sector             ',s1:1,',',s2:1);
          5: writeln('     Photon torpedoes   ',p:2); 
          6: writeln('     Total energy       ',e+s:4);
          7: writeln('     Shields            ',s:4);
          8: writeln('     Klingons remaining ',klingons:2);
        end
    end;
end;

procedure map;
  var
    i,j,j0 : integer;
    g2: qname;
  begin
    writeln('     1     2     3     4     5     6     7     8');
    writeln('   ----- ----- ----- ----- ----- ----- ----- -----');
    for i := 1 to 8 do
      begin
        writeln(i:1);
        if h8 then
          for j := 1 to 8 do
            begin
              write('   ');
              if z[i,j] = 0 then
                write('***')
              else
                write(z[i,j]:3);
            end
        else
          begin
            quadrant(i, 1, 1, g2);
            j0 := round(15 - 0.5 * lastletter(g2));
            tab(j0);
            write('     ');
            write(g2);
            quadrant(i, 5, 1, g2);
            j0 := round(39 - 0.5 * lastletter(g2));
            tab(j0);
            write(g2);
          end;
        writeln;
        writeln('   ----- ----- ----- ----- ----- ----- ----- -----');
      end;
    writeln;
  end;

{ Show map of star systems }
procedure galaxymap;
begin
  h8 := false;
  writeln('                        The galaxy');
  map;
end;

{ Show visited quadrants }
procedure galacticrecord;
begin
  h8 := true;
  writeln;
  write('     ');
  writeln('Computer record of galaxy for quadrant ',q1:1,',',q2:1);
  writeln;
  map;
end;

{ STATUS REPORT }
procedure statusreport;
begin
  writeln('   Status report:');
  if klingons > 1 then
    writeln('Klingons left: ',klingons:2)
  else
    writeln('Klingon left: ',klingons:2);
  writeln('Mission must be completed in ',
     aint(0.1*aint((startdate + duration - time)*10)):6.1,' stardates');
  if starbases<1 then
    begin
      writeln('Your stupidity has left you on your own in');
      writeln('  the galaxy -- You have no starbases left!');
    end
  else
    if starbases<2 then
      writeln('The federation is maintaining ',starbases:1,' starbase in the galaxy')
    else
      writeln('The federation is maintaining ',starbases:1,' starbases in the galaxy');
end;

{ TORPEDO, BASE NAV, D/D CALCULATOR }
procedure torpedodata;
var
  i:integer;
begin
  if k3<=0 then
    noships
  else
    begin
      write('From enterprise to Klingon battle cruiser');
      if k3 > 1 then writeln('s')
      else writeln;

      h8 := false;
      for i := 1 to 3 do
        if k[i].energy > 0 then
          direction(s1-k[i].sectx, s2-k[i].secty);
    end
end;

procedure dircalc;
var
  ix,iy,fx,fy: integer;
begin
  writeln('Direction/distance calculator:');
  writeln('You are at quadrant ',Q1,',',Q2,' sector ',S1,',',S2);
  writeln('Please enter');
  write('  Initial coordinates (x y) ');
  prompt;
  readln(ix,iy);
  write('  Final coordinates (x y) ');
  prompt;
  readln(fx,fy);
  direction(ix-fx, iy-fy)
end;

procedure navdata;
begin
  if b3<>0 then
    begin
      writeln('From enterprise to starbase:');
      direction(s1-sb1, s2-sb2)
    end
  else
    writeln('Mr. Spock reports,  ''Sensors show no starbases in this quadrant.''');
end;


procedure librarycomputer;
label 1;
var
  a : integer;
  redo : boolean;
begin
  if dmg[8]<0 then
    begin
      writeln('Computer disabled');
      goto 1
    end;
  repeat
    redo := false;
    write('Computer active and awaiting command? ');
    a := readint;
    if a < 0 then
      goto 1;

    writeln;
    h8 := true;
    case a of
      0: galacticrecord;
      1: statusreport;
      2: torpedodata;
      3: navdata;
      4: dircalc;
      5: galaxymap;
      otherwise:
        begin
          redo := true;
          writeln('Functions available from library-computer:');
          writeln('   0 = Cumulative galactic record');
          writeln('   1 = Status report');
          writeln('   2 = Photon torpedo data');
          writeln('   3 = Starbase nav data');
          writeln('   4 = Direction/distance calculator');
          writeln('   5 = Galaxy ''region name'' map');
          writeln
        end;
    end;
  until redo = false;
  1:
end;

{ MAIN }
begin
  randstate := 0;
  randomize(randstate);

  repeat
  gameison := true;
  initialize;

  repeat
    write('Command? ');
    prompt;
    readln(as[1], as[2], as[3]);
    if as = 'nav' then coursecontrol
    else if as = 'srs' then shortrange
    else if as = 'lrs' then longrange
    else if as = 'pha' then phaser
    else if as = 'tor' then firetorpedo
    else if as = 'she' then shieldcontrol
    else if as = 'dam' then damagecontrol
    else if as = 'com' then librarycomputer
    else if as = 'xxx' then resign
    else
      begin
        writeln('Enter one of the following:');
        writeln('  nav  (To set course)');
        writeln('  srs  (For short range sensor scan)');
        writeln('  lrs  (For long range sensor scan)');
        writeln('  pha  (To fire phasers)');
        writeln('  tor  (To fire photon torpedoes)');
        writeln('  she  (To raise or lower shields)');
        writeln('  dam  (For damage control reports)');
        writeln('  com  (To call on library-computer)');
        writeln('  xxx  (To resign your command)');
        writeln
      end;
    if (s+e <= 10) or ((e<=10) and (dmg[D_SHE]<0)) then
      begin
        writeln;
        writeln('** FATAL ERROR **  You''ve just stranded your ship in space.');
        writeln('You have insufficient maneuvering energy, and shield control');
        writeln('is presently incapable of cross-circuiting to engine room!!');
        outoftime;
      end;
  until not gameison;
  
  as := '   ';
  if starbases > 0 then
    begin
      writeln('The federation is in need of a new starship commander');
      writeln('for a similar mission -- If there is a volunteer,');
      write('let him step forward and enter ''aye''? ');
      prompt;
      readln(as[1], as[2], as[3])
    end;
  until as <> 'aye'
end.
