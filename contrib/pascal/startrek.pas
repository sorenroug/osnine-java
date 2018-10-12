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

program startrek(input,syserr);

const
  ORGTORPS = 10;
  K_ENERGY = 200;
  E_ENERGY = 3000; { Enterprise initial energy }

  DMG_NAV = 1;
  DMG_SRS = 2;
  DMG_LRS = 3;
  DMG_PHA = 4;
  DMG_TOR = 5;
  DMG_DAM = 6;
  DMG_SHE = 7;
  DMG_COM = 8;

type
  klingon_t = record
      sectx,secty:integer;
      energy:real
    end;
  feature = array [1..3] of char;
  command = array [1..3] of char;
  qname = array [1..15] of char;
  roman = array [1..4] of char;

var
  randstate : integer;
  startdate,time : real;
  gameison : boolean;
  quadrant : array[1..8,1..8] of feature;
  galaxy,known : array [1..8,1..8] of integer;
  c : array [1..9,1..2] of integer;
  k : array [1..3] of klingon_t;
  dmg : array[1..8] of real;
  cmd : command;
  shield, torpedos, energy, eneed, duration,starbases : integer;
  orgklings, klingons : integer;
  k3,s3,b3,s1,s2,sb1,sb2 : integer;
  r1, r2: integer;
  d4 : real;  { Extra repair time }
  q1,q2: integer;
  docked : boolean;

{ Returns a random number between 0.0 and 1.0 }
function random(var block:integer) : real; external;
procedure randomize(var block:integer); external;

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

{ Return a random integer between 1 and 8 }
function rnd8i:integer;
  begin
    rnd8i := rnd(8) + 1;
  end;

{ Print N lines }
procedure lines(n: integer);
  var i: integer;
  begin
    For i:=1 to n do writeln
  end;

{ Print N spaces }
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
    if (z1 < 1) or (z1 >= 9) or (z2 < 1) or (z2 >= 9) then
      begin
        writeln(syserr, 'Out of bounds: Placing ',a,' at ',z1:1,',',z2:1);
      end;
    quadrant[z1,z2] := a
  end;

{ See if the sector contains this feature }
function checkfeature(a: feature; z1,z2: integer) : boolean;
  begin
    checkfeature := false;
    if quadrant[z1,z2] = a then
        checkfeature := true;
  end;

{ Find empty place in quadrant (for things) }
procedure findempty(var r1,r2:integer);
  begin
    repeat
      r1 := rnd8i;
      r2 := rnd8i;
    until checkfeature('   ', r1, r2);
  end;

{ Read up to three letters from the user followed by newline }
procedure readcommand(var cmd:command);
  begin
    cmd := '   ';
    prompt;  { flush output }
    readln(cmd[1], cmd[2], cmd[3]);
  end;

{ Read a floating point number }
procedure readreal(var value:real);
  var
    r : integer;
  begin
    prompt;  { flush output }
    repeat
      ioabort(input, false);
      readln(value);
      r := ioresult(input);
      ioabort(input, true);
      if r <> 0 then
        begin
          writeln('** Input error - reenter **');
          readln(input)
        end;
    until r = 0;
  end;

{ Read an integer }
procedure readint(var value:integer);
  var
    r : integer;
  begin
    prompt;  { flush output }
    repeat
      ioabort(input, false);
      readln(value);
      r := ioresult(input);
      ioabort(input, true);
      if r <> 0 then
        begin
          writeln('** Input error - reenter **');
          readln(input)
        end;
    until r = 0;
  end;

{ Find the last letter in the string }
function lastletter(st : qname) : integer;
  label 100;
  var
    i : integer;
  begin
    lastletter := 0;
    for i := 15 downto 1 do
      if st[i] <> ' ' then
        begin
          lastletter := i;
          goto 100
        end;
    100:
  end;

{ Write a quadrant name, but without final spaces }
procedure trimwrite(st: qname);
  var
    last,i : integer;
  begin
    last := lastletter(st);
    for i := 1 to last do
      write(st[i]);
  end;

{ End of game }
procedure resign;
  begin
    gameison := false;
    if klingons > 0 then
      begin
        writeln('There were ',klingons:1,' Klingon battle cruisers left at');
        writeln('the end of your mission.');
      end;
    writeln;
    writeln;
  end;

procedure outoftime;
  begin
    writeln('It is stardate ',time:6:1,'.');
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
    writeln('Your efficiency rating is ', 1000*sqr(orgklings/(time-startdate)):3:2);
    resign;
  end;

procedure initquadrant;
  var
    i,j : integer;
  begin
    for i := 1 to 8 do
      for j := 1 to 8 do
        quadrant[i,j] := '   ';
  end;

function distance(dX,dY:integer):real;
  begin
    distance := sqrt(sqr(dY) + sqr(dX))
  end;

procedure direction(dX,dY:integer);
  label 30;
  var
    res : real;

  function horiz(h:real):real;
    begin
      if abs(dX)<=abs(dY) then
        horiz := h + (abs(dX)/abs(dY))
      else
        horiz := h + (((abs(dX)-abs(dY))+abs(dX)) / abs(dX));
    end;

  function verti(h:real):real;
    begin
      if abs(dX)>=abs(dY) then
        verti := h + (abs(dY)/abs(dX))
      else
        verti := h + (((abs(dY)-abs(dX))+abs(dY)) / abs(dY));
    end;

  begin
    dY := -dY;
    if dY<0 then
      begin
        if dX>0 then
          begin
            res := verti(3);
            goto 30
          end;
        if dY<>0 then
          begin
            res := horiz(5);
            goto 30
          end
        else
          begin
            res := verti(7);
            goto 30
          end
      end;

    if dX<0 then
      begin
        res := verti(7);
        goto 30
      end;

    if dY>0 then
      begin
        res := horiz(1);
        goto 30
      end
    else
      if dX=0 then
        begin
          res := horiz(5);
          goto 30
        end;
    { dY = 0 and dX >= 0 }
    res := horiz(1);

    30:
    writeln('Direction = ', res:6:5);
    writeln('Distance = ', distance(dX,dY):6:5)
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
  Call with NAMEONLY=TRUE to get region name only }
procedure namequadrant(q1,q2: integer; nameonly: boolean; var name: qname);
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
    if nameonly = false then
      case q2 of
        1,5: appendnum(tmp, ' I  ');
        2,6: appendnum(tmp, ' II ');
        3,7: appendnum(tmp, ' III');
        4,8: appendnum(tmp, ' IV ')
      end;
      name := tmp
  end;

{ Here any time new quadrant entered }
procedure newquadrant;
  var
    i,j : integer;
    g2: qname;
  begin
    k3 := 0;
    b3 := 0;
    s3 := 0;
    d4 := 0.5 * rnd1;
    known[q1,q2] := galaxy[q1,q2];
    namequadrant(q1,q2,false,g2);
    writeln;
    if startdate <> time then
      begin
        write('Now entering ');
        trimwrite(g2);
        writeln(' quadrant . . .')
      end
    else
      begin
        writeln('Your mission begins with your starship located');
        write('in the galactic quadrant, ');
        trimwrite(g2);
        writeln('.');
      end;
    writeln;
    k3 := galaxy[q1,q2] div 100;
    b3 := galaxy[q1,q2] div 10 - 10*k3;
    s3 := galaxy[q1,q2] - 100*k3 - 10*b3;
    if k3 > 0 then
      begin
        writeln('Combat area      Condition RED');
        if shield<=200 then
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
        quadrant[i,j] := '   ';

  { Position Enterprise in quadrant, then place 'K3' klingons, &
    'B3' starbases, & 'S3' stars elsewhere. }
    insertfeature('<*>', s1, s2);
    if k3>0 then
      for i := 1 to k3 do
        begin
          findempty(r1,r2);
          insertfeature('+K+', r1, r2);
          k[i].sectx := r1;
          k[i].secty := r2;
          k[i].energy := K_ENERGY * (0.5 + rnd1)
        end;

    if b3>0 then
      begin
        findempty(sb1,sb2);
        insertfeature('>!<', sb1, sb2)
      end;
    for i := 1 to s3 do
      begin
        findempty(r1,r2);
        insertfeature(' * ', r1, r2)
      end;
  end;

{ Print device name and return length }
function writedevice(rd: integer):integer;
  begin
    case rd of
      1: begin write('Warp engines'); writedevice := 12 end;
      2: begin write('Short range sensors'); writedevice := 19 end;
      3: begin write('Long range sensors'); writedevice := 18 end;
      4: begin write('Phaser control'); writedevice := 14 end;
      5: begin write('Photon tubes'); writedevice := 12 end;
      6: begin write('Damage control'); writedevice := 14 end;
      7: begin write('Shield control'); writedevice := 14 end;
      8: begin write('Library-computer'); writedevice := 16 end;
    end
  end;

{ Maneuver energy s/r **}
procedure useenergy;
  begin
    energy := energy-eneed-10;
    if energy < 0 then
      begin
        writeln('Shield control supplies energy to complete the maneuver.');
        shield := shield+energy;
        energy := 0;
        if shield <= 0 then shield := 0;
      end;
  end;

{ Short range sensor scan & startup subroutine }
procedure shortrange;
  var
    cs : array[1..6] of char;
    i,j : integer;
    z3 : boolean;
  begin
    docked := false;
    if k3 > 0 then
      cs := '*RED* '
    else
      begin
        cs := 'GREEN ';
        if energy < E_ENERGY * 0.1 then
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
                energy := E_ENERGY;
                torpedos := ORGTORPS;
                writeln('Shields dropped for docking purposes');
                shield := 0
              end
          end;
    
    if dmg[DMG_SRS]<0 then
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
                write(' ', quadrant[i,j]);
            write(' ',i:1);
            case i of
              1: writeln('     Stardate           ',time:6:1);
              2: writeln('     Condition          ',cs);
              3: writeln('     Quadrant           ',q1:1,',',q2:1);
              4: writeln('     Sector             ',s1:1,',',s2:1);
              5: writeln('     Photon torpedoes   ',torpedos:1); 
              6: writeln('     Total energy       ',energy+shield:4);
              7: writeln('     Shields            ',shield:1);
              8: writeln('     Klingons remaining ',klingons:1);
            end
          end;
        writeln('---1---2---3---4---5---6---7---8---');
      end;
  end;


procedure placeship(w1:real);
  var
    t8:real; { Time of Travelling }
  begin
    insertfeature('<*>', s1, s2);
    useenergy;
    t8 := 1;
    if w1<1 then
      t8 := 0.1 * aint(10*w1);
    time := time+t8;
    if time > startdate + duration then outoftime;
    { See if docked, then get command }
    shortrange;
  end;

function phasereffect(energy:real; num:integer):real;
  var
    dx,dy : integer;
  begin
    dx := k[num].sectx - s1;
    dy := k[num].secty - s2;
    phasereffect := (energy / distance(dx, dy)) * (rnd1 + 2);
  end;

{ KLINGONS SHOOTING }
procedure enemyfire;
  label 4,5;
  var
    i,l,rd: integer;
    h: real;
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

        h := phasereffect(k[i].energy,i);
        shield := shield - round(h);
        k[i].energy := aint(k[i].energy/(3 + rnd1));
        writeln(h:3:0,' unit hit on Enterprise from sector ',k[i].sectx:1,',',k[i].secty:1);
        if shield<=0 then begin destruction; goto 5 end;
        writeln('      <SHIELDS DOWN TO ',shield:1,' UNITS>');
        if h<20 then goto 4;
        if (rnd1 > 0.6) or (h/shield <= 0.02) then goto 4;
        rd := rnd8i;
        dmg[rd] := dmg[rd]-h/shield - 0.5*rnd1;
        write('Damage control reports:    ''');
        l := writedevice(rd);
        writeln(' damaged by the hit''');
      4:
      end;
  5:
  end;

procedure repairs(d6:real);
  label 2880;
  var
    d1 : boolean;
    i,l : integer;
  begin
    d1 := false;
    if d6 >= 1 then d6 := 1;

    for i := 1 to 8 do
      begin
        if dmg[i]>=0 then goto 2880;
        dmg[i] := dmg[i]+d6;
        if (dmg[i] > -0.1) and (dmg[i] < 0) then
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
      l := writedevice(i);
      writeln(' repair completed.');
2880:
    end;
  end;

procedure vector(course:real; var x1,x2:real);
  var
    j:integer;
  begin
    j := round(course - 0.5);
    x1 := c[j,1] + (c[j+1,1]-c[j,1]) * (course-j);
    x2 := c[j,2] + (c[j+1,2]-c[j,2]) * (course-j);
  end;

{ Course control begins here }
procedure coursecontrol;
  label 3360,3370;
  var
    i,l,rd: integer;
    sX: array [1..3] of char;
    c1,x,y,x1,x2, w1: real;
    z3 : boolean;
    q4,q5: integer;

  {Exceeded quadrant limits }
  procedure exceedquadrant(x1,x2,w1:real); 
    label 9;
    var
      x,y: real;
      x5: boolean;
    begin
      x := 8*q1 + s1 + eneed*x1;
      y := 8*q2 + s2 + eneed*x2;
      q1 := round(x/8 - 0.5);
      q2 := round(y/8 - 0.5);
      {
      s1 := round(x-q1*8 - 0.5);
      s2 := round(y-q2*8 - 0.5);
      }
      s1 := round(x-q1*8);
      s2 := round(y-q2*8);
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

      if 8*q1+q2 = 8*q4+q5 then
        placeship(w1)
      else
        begin
          time := time + 1;
          useenergy;
          newquadrant;
          shortrange;
        end;
    9:
    end;

  begin
    write('Course (1-9)? ');
    readreal(c1);
    If c1 = 9 then c1 := 1;

    if (c1 < 1) or (c1 > 9) then
      begin
        writeln('   Lt. Sulu reports, ''Incorrect course data, sir!''');
        goto 3370
      end;

    write('Warp factor (0-');
    if dmg[DMG_NAV] < 0 then write('0.2') else write('8');
    write('):? ');
    readreal(w1);
    if (dmg[DMG_NAV] < 0) and (w1 > 0.2) then
      begin
        writeln('Warp engines are damaged.  Maxium speed = warp 0.2');
        goto 3370
      end;
    if w1 = 0 then
      goto 3370;

    if (w1 < 0) or (w1 > 8) then
      begin
        writeln('   Chief engineer scott reports ''The engines won''t take warp ', w1:1:1,'!''');
        goto 3370
      end;
    eneed := round(w1 * 8);
    if energy-eneed < 0 then
      begin
        writeln('Engineering reports   ''Insufficient energy available');
        writeln('                       for maneuvering at warp ',w1:1,'!''');
        if (shield < eneed-energy) or (dmg[DMG_SHE] < 0) then
          goto 3370;
        writeln('Deflector control room acknowledges ',shield,' units of energy');
        writeln('                         presently deployed to shields.');
        goto 3370;
      end;

    { Klingons move/fire on moving starship . . . }
    for i := 1 to k3 do
      if k[i].energy <> 0 then
        begin
          insertfeature('   ', k[i].sectx, k[i].secty);
          findempty(r1,r2);
          k[i].sectx := r1;
          k[i].secty := r2;
          insertfeature('+K+', r1, r2);
        end;

    enemyfire;
    repairs(w1);

    if rnd1 < 0.2 then
      begin
        rd := rnd8i;
        write('Damage control report:  ');
        l := writedevice(rd);
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
    vector(c1, x1, x2);
    q4 := q1;
    q5 := q2;

    for i := 1 to eneed do
      begin
        x := x+x1;
        y := y+x2;
        if (x<1) or (x>=9) or (y<1) or (y>=9) then
          begin
            exceedquadrant(x1,x2,w1);
            goto 3370
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
    placeship(w1);
3370:
  end;
 
{ Print a value with prefixed zeros }
procedure zeroprint(val : integer);
  var
    d:integer;
  begin
    d := val div 100;
    val := val mod 100;
    write(d:1);
    d := val div 10;
    val := val mod 10;
    write(d:1,val:1);
  end;

{ Long range sensor scan code }
procedure longrange;
  var
    i,j,l: integer;
    n : array [1..3] of integer; { Known quadrants }
  begin
    if dmg[DMG_LRS]<0 then
      writeln('Long range sensors are inoperable')
    else
      begin
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
                  n[j-q2+2] := galaxy[i,j];
                  known[i,j] := galaxy[i,j]
                end;
            for l := 1 to 3 do
              begin
                write(': ');
                if n[l] < 0 then
                  write('*** ')
                else
                  begin
                    zeroprint(n[l]);
                    write(' ')
                  end;
              end;
            writeln(':')
          end;
        writeln('-------------------')
      end;
  end;

procedure noklingons;
  begin
    writeln('Science officer Spock reports  ''Sensors show no enemy ships');
    writeln('                                in this quadrant''');
  end;

procedure updatequadrant;
  begin
    galaxy[q1,q2] := k3*100 + b3*10 + s3;
    known[q1,q2] := galaxy[q1,q2];
  end;

procedure killklingon(i:integer);
  begin
    writeln('*** KLINGON DESTROYED ***');
    k3 := k3-1;
    klingons := klingons-1;
    insertfeature('   ', k[i].sectx, k[i].secty);
    k[i].energy := 0;
    updatequadrant;
  end;

{ Phaser control code begins here }
procedure phaser;
  label 4670,4680;
  var
    i,h,tofire: integer;
    h1: real;
  begin
    if dmg[DMG_PHA]<0 then
      begin
        writeln('Phasers inoperative');
        goto 4680
      end;

    if k3<=0 then
      begin
        noklingons;
        goto 4680
      end;

    if dmg[DMG_COM]<0 then
      writeln('Computer failure hampers accuracy');
    write('Phasers locked on target;  ');

    repeat
      writeln('Energy available = ',energy:4,' units');
      write('Number of units to fire? ');
      readint(tofire);
      if tofire<=0 then
        begin
          writeln('Phaser fire cancelled');
          goto 4680;
        end;
    until energy >= tofire;
    energy := energy - tofire;
    if dmg[DMG_COM]<0 then tofire := round(tofire * rnd1);

    h1 := tofire / k3;
    for i := 1 to 3 do
      begin
        if k[i].energy <= 0 then goto 4670;
        h := round(phasereffect(h1, i));
        if h <= 0.15 * k[i].energy then
          writeln('Sensors show no damage to enemy at ',k[i].sectx:1,',',k[i].secty:1)
        else
          begin
            k[i].energy := k[i].energy - h;
            writeln(h:1,' Unit hit on klingon at sector ',k[i].sectx:1,',',k[i].secty:1);
            if k[i].energy <= 0 then
              begin
                killklingon(i);
                if klingons<=0 then wongame;
              end
            else
              writeln('   (Sensors show ',round(k[i].energy):1,' units remaining)');
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
    z3 : boolean;
  begin
    if torpedos<=0 then
      begin
        writeln('All photon torpedoes expended');
        goto 5500
      end;

    if dmg[DMG_TOR]<0 then
      begin
        writeln('Photon tubes are not operational');
        goto 5500
      end;
    4760:
    write('Photon torpedo course (1-9) ');
    readreal(c1);
    if c1 = 9 then c1 := 1;
    if (c1<1) or (c1>9) then
      begin
        writeln('Ensign Chekov reports,  ''Incorrect course data, sir!''');
        goto 5500
      end;
    energy := energy-2;
    torpedos := torpedos-1;
    vector(c1, x1, x2);
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
        for i := 1 to 3 do
          if (x3=k[i].sectx) and (y3=k[i].secty) then goto 5190;
        i := 3; { Couldn't find the klingon }
        5190:
        killklingon(i);
        if klingons<=0 then wongame;
        goto 5430
      end;
    z3 := checkfeature(' * ', x3, y3);
    if z3=true then
      begin
        writeln('Star at ',x3:1,',',y3:1,' absorbed torpedo energy.');
        goto 5430
      end;

    z3 := checkfeature('>!<', x3, y3);
    if z3=true then
    begin
      writeln('*** STARBASE DESTROYED ***');
      b3 := b3-1;
      starbases := starbases-1;
      insertfeature('   ', x3, y3);
      updatequadrant;
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
          goto 5500
        end;
    end;
    5430:
    enemyfire;
  5500:
  end;

{ Shield control }
procedure shieldcontrol;
  label 2;
  var
    newval : integer;
  begin
    if dmg[DMG_SHE]<0 then
      begin
        writeln('Shield control inoperable');
        goto 2
      end;
    write('Energy available = ',energy+shield:4);
    write(' Number of units to shields? ');
    readint(newval);
    if (newval<0) or (shield=newval) then
      begin
        writeln('<SHIELDS UNCHANGED>');
        goto 2
      end;

    if newval > energy+shield then
      begin
        writeln('Shield control reports  ''This is not the federation treasury.''');
        writeln('<SHIELDS UNCHANGED>');
      end
    else
      begin
        energy := energy+shield-newval;
        shield := newval;
        writeln('Deflector control room report:');
        writeln('  ''Shields now at ',shield:1,' units per your command.''');
      end;
  2:
  end;

{ DAMAGE CONTROL }
procedure damagecontrol;
  label 5720,5910,5980;
  var
    repairyn : char;
    l, i,rd : integer;
    estimate : real;
  begin
    if dmg[DMG_DAM]>=0 then goto 5910;
    writeln('Damage control report not available');
    if docked=false then goto 5980;

5720:
    estimate := 0;
    for i := 1 to 8 do
      if dmg[i]<0 then estimate := estimate + 0.1;

    if estimate=0 then
      goto 5980;

    writeln;
    estimate := estimate + d4; { Add random extra repair time }
    if estimate >= 1 then estimate := 0.9;

    writeln('Technicians standing by to effect repairs to your ship;');
    writeln('Estimated time to repair: ',estimate:1:2,' stardates.');
    write('Will you authorize the repair order (y/n)? ');
    prompt;
    readln(repairyn);
    if repairyn <>'y' then
      goto 5980;

    for i := 1 to 8 do
      if dmg[i]<0 then dmg[i] := 0;

    time := time + estimate + 0.1;
5910:
    writeln;
    writeln('Device             State of repair');
    for rd := 1 to 8 do
      begin
        l := writedevice(rd);
        tab(25-l);
        writeln(dmg[rd]:6:2)
      end;
    writeln;
    if docked=true then goto 5720;
5980:
  end;

procedure map(h8:boolean);
  var
    i,j,j0 : integer;
    g2: qname;
  begin
    writeln('     1     2     3     4     5     6     7     8');
    writeln('   ----- ----- ----- ----- ----- ----- ----- -----');
    for i := 1 to 8 do
      begin
        write(i:1);
        if h8 then
          for j := 1 to 8 do
            begin
              write('   ');
              if known[i,j] = 0 then
                write('***')
              else
                zeroprint(known[i,j]);
            end
        else
          begin
            namequadrant(i, 1, true, g2);
            j0 := 10 - (lastletter(g2) div 2);
            tab(j0);
            trimwrite(g2);
            tab(j0);
            write('     ');
            namequadrant(i, 5, true, g2);
            j0 := 10 - (lastletter(g2) div 2);
            tab(j0);
            trimwrite(g2);
            tab(j0)
          end;
        writeln;
        writeln('   ----- ----- ----- ----- ----- ----- ----- -----');
      end;
    writeln;
  end;

{ Show map of star systems }
procedure galaxymap;
  begin
    writeln('                        The galaxy');
    map(false);
  end;

{ Show visited quadrants }
procedure galacticrecord;
  begin
    writeln;
    writeln('     Computer record of galaxy for quadrant ',q1:1,',',q2:1);
    writeln;
    map(true);
  end;

{ Status report }
procedure statusreport;
  begin
    writeln('   Status report:');
    if klingons > 1 then
      writeln('Klingons left: ',klingons:1)
    else
      writeln('Klingon left: ',klingons:1);

    writeln('Mission must be completed in ',
       (startdate + duration - time):3:1,' stardates');
    if starbases < 1 then
      begin
        writeln('Your stupidity has left you on your own in');
        writeln('  the galaxy -- You have no starbases left!');
      end
    else
      if starbases < 2 then
        writeln('The federation is maintaining ',starbases:1,' starbase in the galaxy')
      else
        writeln('The federation is maintaining ',starbases:1,' starbases in the galaxy');
  end;

{ Torpedo, base nav, d/d calculator }
procedure torpedodata;
  var
    i:integer;
  begin
    if k3<=0 then
      noklingons
    else
      begin
        write('From enterprise to Klingon battle cruiser');
        if k3 > 1 then writeln('s')
        else writeln;

        for i := 1 to 3 do
          if k[i].energy > 0 then
            direction(s1-k[i].sectx, s2-k[i].secty);
      end
  end;

procedure dircalc;
  var
    ix,iy,fx,fy: integer;
    comma: char;
  begin
    writeln('Direction/distance calculator:');
    writeln('You are at quadrant ',q1:1,',',q2:1,' sector ',s1:1,',',s2:1);
    writeln('Please enter');
    write('  Initial coordinates (x,y) ');
    prompt;
    readln(ix,comma,iy);
    write('  Final coordinates (x,y) ');
    prompt;
    readln(fx,comma,fy);
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
    if dmg[DMG_COM]<0 then
      begin
        writeln('Computer disabled');
        goto 1
      end;
    repeat
      redo := false;
      write('Computer active and awaiting command? ');
      readint(a);
      if a < 0 then
        goto 1;

      writeln;
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
    energy := E_ENERGY;
    torpedos := ORGTORPS;
    shield := 0;
    starbases := 0;
    klingons := 0;

    { Position ship in the galaxy }
    q1 := rnd8i;
    q2 := rnd8i;
    s1 := rnd8i;
    s2 := rnd8i;

    for i := 1 to 9 do
      begin
        c[i,1]:=0;  c[i,2]:=0
      end;
    c[3,1]:=-1;  c[2,1]:=-1;  c[4,1]:=-1;  c[4,2]:=-1;  c[5,2]:=-1;  c[6,2]:=-1;
    c[1,2]:=1; c[2,2]:=1; c[6,1]:=1; c[7,1]:=1; c[8,1]:=1; c[8,2]:=1; c[9,2]:=1;

    for i := 1 to 8 do dmg[i] := 0;

    { Setup what exists in galaxy . . .
      K3= # Klingons  B3= # Starbases  S3 = # Stars }
    for i := 1 to 8 do
      for j := 1 to 8 do
        begin
          k3 := 0;
          known[i,j] := 0;
          t1 := rnd1;
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
          if rnd1 > 0.96 then
            begin
              b3 := 1;
              starbases := starbases+1;
            end;
          s3 := rnd8i;
          galaxy[i,j] := k3*100 + b3*10 + s3
        end; { for j,i }

    if klingons > duration then
      duration := klingons+1;

    if starbases = 0 then
      begin
        { Add a Klingon to the sector with the only starbase }
        if galaxy[q1,q2]<200 then
          begin
            galaxy[q1,q2] := galaxy[q1,q2]+100;
            klingons := klingons+1
          end;
        starbases := 1;
        galaxy[q1,q2] := galaxy[q1,q2]+10;
        q1 := rnd8i;
        q2 := rnd8i
      end;

    orgklings := klingons;
    writeln('Your orders are as follows:');
    writeln('''Destroy the ',klingons:1,' Klingon warships which have invaded');
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
      readcommand(cmd);
      if cmd = 'nav' then coursecontrol
      else if cmd = 'srs' then shortrange
      else if cmd = 'lrs' then longrange
      else if cmd = 'pha' then phaser
      else if cmd = 'tor' then firetorpedo
      else if cmd = 'she' then shieldcontrol
      else if cmd = 'dam' then damagecontrol
      else if cmd = 'com' then librarycomputer
      else if cmd = 'xxx' then resign
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
      if (shield+energy <= 10) or ((energy <= 10) and (dmg[DMG_SHE]<0)) then
        begin
          writeln;
          writeln('** FATAL ERROR **  You''ve just stranded your ship in space.');
          writeln('You have insufficient maneuvering energy, and shield control');
          writeln('is presently incapable of cross-circuiting to engine room!!');
          outoftime;
        end;
    until not gameison;
  
    if starbases > 0 then
      begin
        writeln('The federation is in need of a new starship commander');
        writeln('for a similar mission -- If there is a volunteer,');
        write('let him step forward and enter ''aye''? ');
        readcommand(cmd);
      end;
  until cmd <> 'aye'
end.
