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

program startrek(input);

const
  ORGTORPS = 10;
  K_ENERGY = 200;
  E_ENERGY = 3000; { Enterprise initial energy }
  QUADMIN = 1;
  QUADMAX = 8;
  SECTMIN = 1;
  SECTMAX = 8;
  NUMSECT = 8; { Number of sectors i a quadrant }

  DMG_NAV = 1;
  DMG_SRS = 2;
  DMG_LRS = 3;
  DMG_PHA = 4;
  DMG_TOR = 5;
  DMG_DAM = 6;
  DMG_SHE = 7;
  DMG_COM = 8;

  SPACE = '   ';
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
  quadrant : array[SECTMIN..SECTMAX, SECTMIN..SECTMAX] of feature;
  galaxy,known : array [QUADMIN..QUADMAX, QUADMIN..QUADMAX] of integer;
  trig : array [1..9,1..2] of integer; { Course to vector }
  k : array [1..3] of klingon_t;
  dmg : array[DMG_NAV..DMG_COM] of real;
  cmd : command;
  shield, torpedos, energy, eneed, duration,starbases : integer;
  orgklings, klingons : integer;
  k3,s3,b3 : integer;
  quadx,quady: integer; {Ship's quadrant }
  sectorx,sectory : integer; {Ship location in quadrant }
  sb1,sb2 : integer; {Starbase location in quadrant }
  d4 : real;  { Extra repair time }
  docked : boolean;

{ Provide a random real 0 <= x < 1 }
function rand:real;
  const
    MAXVAL = 32767;
  begin
    mathabort(false);
    randstate := randstate * 11035 + 6971;
    randstate := randstate mod MAXVAL;
    rand := randstate / MAXVAL;
    mathabort(true);
  end;

{ Create random seed based on system clock }
procedure randomize;
  var
    year, month, day, hour, minute, second : integer;
  begin
    systime(year, month, day, hour, minute, second);
    randstate := second * 391 + minute * 13 + 23;
  end;


{ Provide a random integer 0 <= x < maxval }
function rnd(maxval:integer):integer;
  begin
    rnd := trunc(rand * maxval);
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
    For i := 1 to n do writeln
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
    quadrant[z1,z2] := a
  end;

{ See if the sector contains this feature }
function hasfeature(a: feature; z1,z2: integer) : boolean;
  begin
    if quadrant[z1,z2] = a then
      hasfeature := true
    else
      hasfeature := false;
  end;

{ Find empty place in quadrant (for things) }
procedure findempty(a: feature; var r1,r2:integer);
  begin
    repeat
      r1 := rnd8i;
      r2 := rnd8i;
    until hasfeature(SPACE, r1, r2);
    quadrant[r1,r2] := a
  end;

function inputerr(r: integer):integer;
  begin
    {sysreport(output, r); writeln;}  { print message for error code }
    writeln('** Input error - reenter **');
    readln(input)
  end;

{ Read up to three letters from the user followed by newline }
procedure readcommand(var cmd:command);
  label 999;
  var
    i: integer;
  begin
    cmd := '   ';
    prompt;  { flush output }
    i := 1;
    while (i <= 3) and not eoln do
      begin
        read(cmd[i]);
        if ord(cmd[i]) = 32 then goto 999;
        i := i + 1
      end;
    readln;
  999:
  end;

{ Read integer coordinate separated by a comma }
procedure readcoord(var x,y:integer);
  var
    r : integer;
    comma: char;
  begin
    prompt;  { flush output }
    repeat
      ioabort(input, false);
      readln(x, comma, y);
      r := ioresult(input);
      ioabort(input, true);
      if r <> 0 then
        r := inputerr(r);
      if comma <> ',' then
        r := inputerr(20);
    until r = 0;
  end;

{ Read a y/n answer. Returns lowercase }
procedure readyesno(var yesno:char);
  begin
    prompt;  { flush output }
    readln(yesno);
    if (yesno >= 'A') and (yesno <= 'Z') then
      yesno := chr(ord(yesno) - ord('A') + ord('a'));
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
        r := inputerr(r);
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
        r := inputerr(r);
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
        writeln('There were ',klingons:1, ' Klingon battle cruisers left at');
        writeln('the end of your mission.');
      end;
    writeln;
    writeln;
  end;

procedure outoftime;
  begin
    writeln('It is stardate ', time:6:1, '.');
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
    for i := SECTMIN to SECTMAX do
      for j := SECTMIN to SECTMAX do
        quadrant[i,j] := SPACE;
  end;

function distance(dX,dY:integer):real;
  begin
    distance := sqrt(sqr(dY) + sqr(dX))
  end;

function direction(dX,dY:integer):real;

  function horiz(h:real):real;
    begin
     if abs(dX) <= abs(dY) then
        horiz := h + (abs(dX)/abs(dY))
      else
        horiz := h + (((abs(dX)-abs(dY))+abs(dX)) / abs(dX));
    end;

  function verti(h:real):real;
    begin
      if abs(dX) >= abs(dY) then
        verti := h + (abs(dY)/abs(dX))
      else
        verti := h + (((abs(dY)-abs(dX))+abs(dY)) / abs(dY));
    end;

  begin
    dY := -dY;
    if dY < 0 then
      begin
        if dX > 0 then
          direction := verti(3)
        else if dY <> 0 then
          direction := horiz(5)
        else
          direction := verti(7)
      end
    else if dX < 0 then
      direction := verti(7)
    else if dY > 0 then
      direction := horiz(1)
    else if dX = 0 then
      direction := horiz(5)
    else { dY = 0 and dX >= 0 }
      direction := horiz(1);
  end;

procedure dirdist(dX,dY:integer);
  begin
    writeln('Direction = ', direction(dX,dY):6:5);
    writeln('Distance = ', distance(dX,dY):6:5)
  end;

{ Return quadrant name from Q1,Q2
  Call with NAMEONLY=TRUE to get region name only }
procedure namequadrant(qx,qy: integer; nameonly: boolean; var name: qname);
  var
    tmp : qname;

  { Append Roman numeral to string }
  procedure appendnum(var name: qname; num: roman);
    var
      last,i : integer;
    begin
      last := lastletter(name);
      for i := 1 to 4 do
        name[last + i] := num[i];
    end;

  begin
    If qy <= 4 then
      case qx of
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
      case qx of
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
      case qy of
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
    r1, r2: integer;
  begin
    k3 := 0;
    b3 := 0;
    s3 := 0;
    d4 := 0.5 * rand;
    known[quadx,quady] := galaxy[quadx,quady];
    namequadrant(quadx, quady, false, g2);
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
    k3 := galaxy[quadx,quady] div 100;
    b3 := galaxy[quadx,quady] div 10 - 10*k3;
    s3 := galaxy[quadx,quady] - 100*k3 - 10*b3;
    if k3 > 0 then
      begin
        writeln('Combat area      Condition RED');
        if shield <= 200 then
          writeln('   Shields dangerously low');
      end;
    for i := 1 to 3 do
      begin
        k[i].sectx := 0;
        k[i].secty := 0;
        k[i].energy := 0
      end;

    for i := SECTMIN to SECTMAX do
      for j := SECTMIN to SECTMAX do
        quadrant[i,j] := SPACE;

  { Position Enterprise in quadrant, then place 'K3' klingons, &
    'B3' starbases, & 'S3' stars elsewhere. }
    insertfeature('<*>', sectorx, sectory);
    if k3 > 0 then
      for i := 1 to k3 do
        begin
          findempty('+K+', k[i].sectx, k[i].secty);
          k[i].energy := K_ENERGY * (0.5 + rand)
        end;

    if b3 > 0 then
        findempty('>!<', sb1, sb2);
    for i := 1 to s3 do
        findempty(' * ', r1,r2);
  end;

{ Print device name and return length }
function writedevice(rd: integer):integer;
  begin
    case rd of
      DMG_NAV: begin write('Warp engines'); writedevice := 12 end;
      DMG_SRS: begin write('Short range sensors'); writedevice := 19 end;
      DMG_LRS: begin write('Long range sensors'); writedevice := 18 end;
      DMG_PHA: begin write('Phaser control'); writedevice := 14 end;
      DMG_TOR: begin write('Photon tubes'); writedevice := 12 end;
      DMG_DAM: begin write('Damage control'); writedevice := 14 end;
      DMG_SHE: begin write('Shield control'); writedevice := 14 end;
      DMG_COM: begin write('Library-computer'); writedevice := 16 end;
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
    for i := sectorx-1 to sectorx+1 do
      for j := sectory-1 to sectory+1 do
        if (i >= SECTMIN) and (i <= SECTMAX) and (j >= SECTMIN) and (j <= SECTMAX) then
          begin
            if hasfeature('>!<', i, j) then
              begin
                docked := true ;
                cs := 'DOCKED';
                energy := E_ENERGY;
                torpedos := ORGTORPS;
                writeln('Shields dropped for docking purposes');
                shield := 0
              end
          end;
    
    if dmg[DMG_SRS] < 0 then
      begin
        writeln;
        writeln('*** SHORT RANGE SENSORS ARE OUT ***');
        writeln;
      end
    else
      begin
        writeln('---1---2---3---4---5---6---7---8---');
        for i := SECTMIN to SECTMAX do
          begin
            write(i:1);
              for j := SECTMIN to SECTMAX do
                write(' ', quadrant[i,j]);
            write(' ',i:1);
            case i of
              1: writeln('     Stardate           ', time:6:1);
              2: writeln('     Condition          ', cs);
              3: writeln('     Quadrant           ', quadx:1, ',', quady:1);
              4: writeln('     Sector             ', sectorx:1, ',', sectory:1);
              5: writeln('     Photon torpedoes   ', torpedos:1); 
              6: writeln('     Total energy       ', energy+shield:4);
              7: writeln('     Shields            ', shield:1);
              8: writeln('     Klingons remaining ', klingons:1);
            end
          end;
        writeln('---1---2---3---4---5---6---7---8---');
      end;
  end;


procedure placeship(warpfact:real);
  var
    t8:real; { Time of Travelling }
  begin
    insertfeature('<*>', sectorx, sectory);
    useenergy;
    t8 := 1;
    if warpfact < 1 then
      t8 := 0.1 * round(10 * warpfact - 0.5);
    time := time + t8;
    if time > startdate + duration then outoftime;
    { See if docked, then get command }
    shortrange;
  end;

function phasereffect(available:real; num:integer):real;
  var
    dx,dy : integer;
  begin
    dx := k[num].sectx - sectorx;
    dy := k[num].secty - sectory;
    phasereffect := (available / distance(dx, dy)) * (rand + 2);
  end;

{ KLINGONS SHOOTING }
procedure enemyfire;
  label 4,5;
  var
    i,l,rd: integer;
    h: real;
  begin
    if k3 <= 0 then goto 5;

    if docked then
      begin
        writeln('Starbase shields protect the enterprise');
        goto 5;
      end;

    for i := 1 to 3 do
      begin
        if k[i].energy <= 0 then goto 4;

        h := phasereffect(k[i].energy,i);
        shield := shield - round(h);
        k[i].energy := k[i].energy/(3 + rand);
        writeln(h:3:0,' unit hit on Enterprise from sector ', k[i].sectx:1, ',', k[i].secty:1);
        if shield <= 0 then begin destruction; goto 5 end;
        writeln('      <SHIELDS DOWN TO ', shield:1, ' UNITS>');
        if h < 20 then goto 4;
        if (rand > 0.6) or (h/shield <= 0.02) then goto 4;
        rd := rnd8i;
        dmg[rd] := dmg[rd] - h/shield - 0.5*rand;
        write('Damage control reports:    ''');
        l := writedevice(rd);
        writeln(' damaged by the hit''');
      4:
      end;
  5:
  end;

{ Make repairs while travelling.}
procedure repairs(distance:real);
  var
    header : boolean;
    i,l : integer;
  begin
    header := false;
    if distance >= 1 then distance := 1;

    for i := DMG_NAV to DMG_COM do
      begin
        if dmg[i] < 0 then
          begin
            dmg[i] := dmg[i] + distance;
            if (dmg[i] > -0.1) and (dmg[i] < 0) then
              dmg[i] := -0.1;
            if dmg[i] >= 0 then
              begin
                if header = false then
                  begin
                    header := true;
                    write('Damage control report:  ')
                  end;
                tab(8);
                l := writedevice(i);
                writeln(' repair completed.')
              end
          end
      end
  end;

procedure inittrig;
  var
    i : integer;
  begin
    for i := 1 to 9 do
      begin
        trig[i,1] := 0;  trig[i,2] := 0
      end;
    trig[3,1]:=-1;  trig[2,1]:=-1;  trig[4,1]:=-1;
    trig[4,2]:=-1;  trig[5,2]:=-1;  trig[6,2]:=-1;
    trig[1,2]:=1;   trig[2,2]:=1;
    trig[6,1]:=1;   trig[7,1]:=1;   trig[8,1]:=1;
    trig[8,2]:=1;   trig[9,2]:=1;
  end;

procedure vector(course:real; var x1,x2:real);
  var
    j:integer;
  begin
    j := round(course - 0.5);
    x1 := trig[j,1] + (trig[j+1,1]-trig[j,1]) * (course-j);
    x2 := trig[j,2] + (trig[j+1,2]-trig[j,2]) * (course-j);
  end;

{ Course control begins here }
procedure coursecontrol;
  label 3360,3370;
  var
    i,l,rd: integer;
    sX: array [1..3] of char;
    course,x,y,x1,x2, w1: real;
    q4,q5: integer;

  {Exceeded quadrant limits }
  procedure exceedquadrant(x1,x2,w1:real); 
    label 9;
    var
      x,y: real;
      crossing: boolean;
    begin
      x := NUMSECT * quadx + sectorx + eneed*x1;
      y := NUMSECT * quady + sectory + eneed*x2;
      quadx := round(x/NUMSECT - 0.5);
      quady := round(y/NUMSECT - 0.5);
      sectorx := round(x-quadx*NUMSECT);
      sectory := round(y-quady*NUMSECT);
      if sectorx < SECTMIN then begin quadx := quadx-1 ; sectorx := SECTMAX end;
      if sectory < SECTMIN then begin quady := quady-1 ; sectory := SECTMAX end;

      crossing := false;
      if quadx < QUADMIN then begin crossing := true ; quadx := QUADMIN ; sectorx := SECTMIN end;
      if quadx > QUADMAX then begin crossing := true ; quadx := QUADMAX ; sectorx := SECTMAX end;
      if quady < QUADMIN then begin crossing := true ; quady := QUADMIN ; sectory := SECTMIN end;
      if quady > QUADMAX then begin crossing := true ; quady := QUADMAX ; sectory := SECTMAX end;
      if crossing = true then
        begin
          writeln('Lt. Uhura reports message from starfleet command:');
          writeln('  ''Permission to attempt crossing of galactic perimeter');
          writeln('  is hereby *DENIED*.  Shut down your engines.''');
          writeln('Chief engineer Scott reports  ''Warp engines shut down');
          writeln('  at sector ',sectorx:1,',',sectory:1,' of quadrant ',quadx:1,',',quady:1,'.''');
          if time > startdate + duration then begin outoftime; goto 9 end;
        end;

      if (quadx = q4) and (quady = q5) then
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

  procedure enemymove;
    var
      i : integer;
      r1, r2: integer;
    begin
      for i := 1 to k3 do
        if k[i].energy <> 0 then
          begin
            insertfeature(SPACE, k[i].sectx, k[i].secty);
            findempty('+K+', k[i].sectx, k[i].secty);
          end;
    end;

  begin
    write('Course (1-9)? ');
    readreal(course);
    If course = 9 then course := 1;

    if (course < 1) or (course > 9) then
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
    enemymove;
    enemyfire;
    repairs(w1);

    if rand < 0.2 then
      begin
        rd := rnd8i;
        write('Damage control report:  ');
        l := writedevice(rd);
        if rand >= 0.6 then
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
    insertfeature(SPACE, sectorx, sectory);
    x := sectorx;
    y := sectory;
    vector(course, x1, x2);
    q4 := quadx;
    q5 := quady;

    for i := 1 to eneed do
      begin
        x := x+x1;
        y := y+x2;
        if (x < SECTMIN) or (x >= 9) or (y < SECTMIN) or (y >= 9) then
          begin
            exceedquadrant(x1, x2, w1);
            goto 3370
          end;
        if not hasfeature(SPACE, round(x - 0.5), round(y - 0.5)) then
          begin
            x := round(x-x1 - 0.5);
            y := round(y-x2 - 0.5);
            write('Warp engines shut down at sector ');
            writeln(x:1:0, ',', y:1:0, ' due to bad navigation');
            goto 3360
          end;
      end;
3360:
    sectorx := round(x - 0.5);
    sectory := round(y - 0.5);
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
    i,j: integer;
  begin
    if dmg[DMG_LRS] < 0 then
      writeln('Long range sensors are inoperable')
    else
      begin
        writeln('Long range scan for quadrant ',quadx:1,',',quady:1);
        writeln('-------------------');
        for i := quadx-1 to quadx+1 do
          begin
            for j := quady-1 to quady+1 do
              begin
                write(': ');
                if (i >= QUADMIN) and (i <= QUADMAX) and (j >= QUADMIN) and (j <= QUADMAX) then
                  begin
                    known[i,j] := galaxy[i,j];
                    zeroprint(known[i,j])
                  end
                else
                  write('***');
                write(' ')
              end;
            writeln(':');
            writeln('-------------------')
          end;
      end;
  end;

procedure noklingons;
  begin
    writeln('Science officer Spock reports  ''Sensors show no enemy ships');
    writeln('                                in this quadrant''');
  end;

procedure updatequadrant;
  begin
    galaxy[quadx,quady] := k3*100 + b3*10 + s3;
    known[quadx,quady] := galaxy[quadx,quady];
  end;

procedure killklingon(i:integer);
  begin
    writeln('*** KLINGON DESTROYED ***');
    k3 := k3 - 1;
    klingons := klingons - 1;
    insertfeature(SPACE, k[i].sectx, k[i].secty);
    k[i].energy := 0;
    updatequadrant;
  end;

{ Phaser control code begins here }
procedure phaser;
  label 4680;
  var
    i,h,tofire: integer;
    h1: real;
  begin
    if dmg[DMG_PHA] < 0 then
      begin
        writeln('Phasers inoperative');
        goto 4680
      end;

    if k3 <= 0 then
      begin
        noklingons;
        goto 4680
      end;

    if dmg[DMG_COM] < 0 then
      writeln('Computer failure hampers accuracy');
    write('Phasers locked on target;  ');

    repeat
      writeln('Energy available = ',energy:4,' units');
      write('Number of units to fire? ');
      readint(tofire);
      if tofire <= 0 then
        begin
          writeln('Phaser fire cancelled');
          goto 4680;
        end;
    until energy >= tofire;
    energy := energy - tofire;
    if dmg[DMG_COM] < 0 then tofire := round(tofire * rand);

    h1 := tofire / k3;
    for i := 1 to 3 do
      begin
        if k[i].energy > 0 then
          begin
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
                    if klingons <= 0 then wongame;
                  end
                else
                  writeln('   (Sensors show ',round(k[i].energy):1,' units remaining)');
              end;
          end;
      end;
      enemyfire;
    4680:
  end;

{ Photon torpedo code begins here }
procedure firetorpedo;
  label 4760,5190,5500;
  var
    i,x3,y3 : integer;
    course,x,y,x1,x2 : real;
  begin
    if torpedos <= 0 then
      begin
        writeln('All photon torpedoes expended');
        goto 5500
      end;

    if dmg[DMG_TOR] < 0 then
      begin
        writeln('Photon tubes are not operational');
        goto 5500
      end;
    4760:
    write('Photon torpedo course (1-9) ');
    readreal(course);
    if course = 9 then course := 1;
    if (course < 1) or (course > 9) then
      begin
        writeln('Ensign Chekov reports,  ''Incorrect course data, sir!''');
        goto 5500
      end;
    energy := energy-2;
    torpedos := torpedos-1;
    vector(course, x1, x2);
    x := sectorx;
    y := sectory;
    writeln('Torpedo track:');

    repeat
      x := x + x1;
      y := y + x2;
      x3 := round(x);
      y3 := round(y);
      if (x3 < SECTMIN) or (x3 > SECTMAX) or (y3 < SECTMIN) or (y3 > SECTMAX) then
        begin
          writeln('Torpedo missed');
          enemyfire;
          goto 5500
        end;
      writeln('               ',x3:1,',',y3:1);
    until not hasfeature(SPACE, x3, y3);
  { We have now hit something }
    if hasfeature('+K+', x3, y3) then
      begin
        for i := 1 to 3 do
          if (x3 = k[i].sectx) and (y3 = k[i].secty) then goto 5190;
        i := 3; { Couldn't find the klingon }
        5190:
        killklingon(i);
        if klingons <= 0 then wongame;
        enemyfire;
        goto 5500
      end;
    if hasfeature(' * ', x3, y3) then
      begin
        writeln('Star at ',x3:1,',',y3:1,' absorbed torpedo energy.');
        enemyfire;
        goto 5500
      end;

    if hasfeature('>!<', x3, y3) then
    begin
      writeln('*** STARBASE DESTROYED ***');
      b3 := b3-1;
      starbases := starbases-1;
      insertfeature(SPACE, x3, y3);
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
    enemyfire;
  5500:
  end;

{ Shield control }
procedure shieldcontrol;
  label 2;
  var
    newval : integer;
  begin
    if dmg[DMG_SHE] < 0 then
      begin
        writeln('Shield control inoperable');
        goto 2
      end;
    write('Energy available = ',energy+shield:4);
    write(' Number of units to shields? ');
    readint(newval);
    if (newval < 0) or (shield=newval) then
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
  var
    i : integer;
    estimate : real;

  procedure showdmg;
    var
      rd,tlen : integer;
    begin
      writeln;
      writeln('Device             State of repair');
      for rd := DMG_NAV to DMG_COM do
        begin
          tlen := writedevice(rd);
          tab(25 - tlen);
          writeln(dmg[rd]:6:2)
        end;
      writeln;
    end;

  procedure offerrepair;
    var
      repairyn : char;
      i : integer;
    begin
      writeln;
      estimate := estimate + d4; { Add random extra repair time }
      if estimate >= 1 then estimate := 0.9;

      writeln('Technicians standing by to effect repairs to your ship;');
      writeln('Estimated time to repair: ',estimate:1:2,' stardates.');
      write('Will you authorize the repair order (y/n)? ');
      readyesno(repairyn);
      if repairyn = 'y' then
        begin
          for i := DMG_NAV to DMG_COM do
            if dmg[i] < 0 then dmg[i] := 0;

          time := time + estimate + 0.1;
          showdmg;
        end;
    end;

  begin
    if dmg[DMG_DAM] >= 0 then
      showdmg
    else
      writeln('Damage control report not available');

    if docked then
      begin
        estimate := 0;
        for i := DMG_NAV to DMG_COM do
          if dmg[i] < 0 then estimate := estimate + 0.1;

        if estimate > 0 then
          offerrepair;
      end;
  end;

procedure map(h8:boolean);
  var
    i,j,j0 : integer;
    g2: qname;
  begin
    writeln('     1     2     3     4     5     6     7     8');
    writeln('   ----- ----- ----- ----- ----- ----- ----- -----');
    for i := 1 to QUADMAX do
      begin
        write(i:1);
        if h8 then
          for j := 1 to QUADMAX do
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
    writeln('     Computer record of galaxy for quadrant ',quadx:1,',',quady:1);
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
    if k3 <= 0 then
      noklingons
    else
      begin
        write('From enterprise to Klingon battle cruiser');
        if k3 > 1 then writeln('s')
        else writeln;

        for i := 1 to 3 do
          if k[i].energy > 0 then
            dirdist(sectorx-k[i].sectx, sectory-k[i].secty);
      end
  end;

procedure dircalc;
  var
    ix,iy,fx,fy: integer;
  begin
    writeln('Direction/distance calculator:');
    writeln('You are at quadrant ',quadx:1,',',quady:1,' sector ',sectorx:1,',',sectory:1);
    writeln('Please enter');
    write('  Initial coordinates (x,y) ');
    readcoord(ix, iy);
    write('  Final coordinates (x,y) ');
    readcoord(fx, fy);
    dirdist(ix-fx, iy-fy)
  end;

procedure navdata;
  begin
    if b3 <> 0 then
      begin
        writeln('From enterprise to starbase:');
        dirdist(sectorx-sb1, sectory-sb2)
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
    if dmg[DMG_COM] < 0 then
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

    time := 0.0 + (rnd(20)+20) * 100;
    startdate := time;
    duration := 25 + rnd(10);
    docked := false;
    energy := E_ENERGY;
    torpedos := ORGTORPS;
    shield := 0;
    starbases := 0;
    klingons := 0;

    { Position ship in the galaxy }
    quadx := rnd8i;
    quady := rnd8i;
    sectorx := rnd8i;
    sectory := rnd8i;
    inittrig;

    for i := DMG_NAV to DMG_COM do dmg[i] := 0;

    { Setup what exists in galaxy . . .
      K3= # Klingons  B3= # Starbases  S3 = # Stars }
    for i := 1 to QUADMAX do
      for j := 1 to QUADMAX do
        begin
          k3 := 0;
          known[i,j] := 0;
          t1 := rand;
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
          if rand > 0.96 then
            begin
              b3 := 1;
              starbases := starbases+1;
            end;
          s3 := rnd8i;
          galaxy[i,j] := k3*100 + b3*10 + s3
        end; { for j,i }

    if klingons > duration then
      duration := klingons + 1;

    if starbases = 0 then
      begin
        { Add a Klingon to the sector with the only starbase }
        if galaxy[quadx,quady] < 200 then
          begin
            galaxy[quadx,quady] := galaxy[quadx,quady] + 100;
            klingons := klingons+1
          end;
        starbases := 1;
        galaxy[quadx,quady] := galaxy[quadx,quady] + 10;
        quadx := rnd8i;
        quady := rnd8i
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
  randomize;

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
      if (shield+energy <= 10) or ((energy <= 10) and (dmg[DMG_SHE] < 0)) then
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
