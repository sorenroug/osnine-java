{ *** HUNT THE WUMPUS *** }
program wumpus;
type
  features = (HUNTER, WUMPUS, PIT1, PIT2, BAT1, BAT2);

var
  randstate : integer;
  arrows,lt,k,o,duel: integer;
  j: features;
  answer: char;
  path: array[1..5] of integer;
  cave: array[1..20,1..3] of integer;
  feature, origsetup: array[HUNTER..BAT2] of integer;

{ Provide a random real 0 <= x < 1 }
function random:real;
  const
    MAXVAL = 32767;
  begin
    mathabort(false);
    randstate := randstate * 11035 + 6971;
    randstate := randstate mod MAXVAL;
    random := randstate / MAXVAL;
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


{ Provide a random integer 1 <= x <= maxval }
function rnd(maxval:integer):integer;
begin
  rnd := trunc(random * maxval) + 1;
end;

{ *** SET UP CAVE (DODECAHEDRAL NODE LIST) *** }
{ Pascal does not have initialization of arrays }
procedure initcave;
  var
    j,k: integer;
    cavefile: text;
  begin
     {
     reset(cavefile, '/d0/games/wumpuscave');
     for j := 1 to 20 do
       for k := 1 to 3 do
         read(cave[j,k]);
     close(cavefile);
     }

     cave[1,1]  := 2;  cave[1,2]  := 5;  cave[1,3]  := 8;
     cave[2,1]  := 1;  cave[2,2]  := 3;  cave[2,3]  := 10;
     cave[3,1]  := 2;  cave[3,2]  := 4;  cave[3,3]  := 12;
     cave[4,1]  := 3;  cave[4,2]  := 5;  cave[4,3]  := 14;
     cave[5,1]  := 1;  cave[5,2]  := 4;  cave[5,3]  := 6;
     cave[6,1]  := 5;  cave[6,2]  := 7;  cave[6,3]  := 15;
     cave[7,1]  := 6;  cave[7,2]  := 8;  cave[7,3]  := 17;
     cave[8,1]  := 1;  cave[8,2]  := 7;  cave[8,3]  := 9;
     cave[9,1]  := 8;  cave[9,2]  := 10; cave[9,3]  := 18;
     cave[10,1] := 2;  cave[10,2] := 9;  cave[10,3] := 11;
     cave[11,1] := 10; cave[11,2] := 12; cave[11,3] := 19;
     cave[12,1] := 3;  cave[12,2] := 11; cave[12,3] := 13;
     cave[13,1] := 12; cave[13,2] := 14; cave[13,3] := 20;
     cave[14,1] := 4;  cave[14,2] := 13; cave[14,3] := 15;
     cave[15,1] := 6;  cave[15,2] := 14; cave[15,3] := 16;
     cave[16,1] := 15; cave[16,2] := 17; cave[16,3] := 20;
     cave[17,1] := 7;  cave[17,2] := 16; cave[17,3] := 18;
     cave[18,1] := 9;  cave[18,2] := 17; cave[18,3] := 19;
     cave[19,1] := 11; cave[19,2] := 18; cave[19,3] := 20;
     cave[20,1] := 13; cave[20,2] := 16; cave[20,3] := 19;
  end;

{ *** LOCATE L ARRAY ITEMS *** }
{ *** 1-YOU, 2-WUMPUS, 3&4-PITS, 5&6-BATS *** }
procedure populate;
  var
    j,k: features;
    crossover: boolean;
  begin
    repeat
      for j := HUNTER to BAT2 do
        begin
         feature[j] := rnd(20);
         origsetup[j] := feature[j]
        end;

     { *** CHECK FOR CROSSOVERS (IE feature[HUNTER]=feature[WUMPUS], ETC) *** }
      crossover := false;
      for j := HUNTER to BAT2 do
        for k := HUNTER to BAT2 do
           if (j<>k) and (feature[j]=feature[k]) then
             crossover := true;
    until crossover = false;
  end;

{ *** INSTRUCTIONS *** }
procedure instructions;
  var
     cr: char;
  begin
     writeln('WELCOME TO ''HUNT THE WUMPUS''');
     writeln('  THE WUMPUS LIVES IN A CAVE OF 20 ROOMS. EACH ROOM');
     writeln('HAS 3 TUNNELS LEADING TO OTHER ROOMS. (LOOK AT A');
     writeln('DODECAHEDRON TO SEE HOW THIS WORKS-IF YOU DON''T KNOW');
     writeln('WHAT A DODECAHEDRON IS, ASK SOMEONE)');
     writeln;
     writeln('     HAZARDS:');
     writeln(' BOTTOMLESS PITS - TWO ROOMS HAVE BOTTOMLESS PITS IN THEM');
     writeln('     IF YOU GO THERE, YOU FALL INTO THE PIT (& LOSE!)');
     writeln(' SUPER BATS - TWO OTHER ROOMS HAVE SUPER BATS. IF YOU');
     writeln('     GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER');
     writeln('     ROOM AT RANDOM. (WHICH MAY BE TROUBLESOME)');
     write('HIT RETURN TO CONTINUE');
     prompt;
     readln(cr);
     writeln('     WUMPUS:');
     writeln(' THE WUMPUS IS NOT BOTHERED BY HAZARDS (HE HAS SUCKER');
     writeln(' FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY');
     writeln(' HE IS ASLEEP.  TWO THINGS WAKE HIM UP: YOU SHOOTING AN');
     writeln(' ARROW OR YOU ENTERING HIS ROOM.');
     writeln('     IF THE WUMPUS WAKES HE MOVES (P=.75) ONE ROOM');
     writeln(' OR STAYS STILL (P=.25).  AFTER THAT, IF HE IS WHERE YOU');
     writeln(' ARE, HE EATS YOU UP AND YOU LOSE!');
     writeln;
     writeln('     YOU:');
     writeln(' EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW');
     writeln('   MOVING:  YOU CAN MOVE ONE ROOM (THRU ONE TUNNEL)');
     writeln('   ARROWS:  YOU HAVE 5 ARROWS.  YOU LOSE WHEN YOU RUN OUT');
     writeln('   EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING');
     writeln('   THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.');
     writeln('   IF THE ARROW CAN''T GO THAT WAY (IF NO TUNNEL) IT MOVES');
     writeln('   AT RANDOM TO THE NEXT ROOM.');
     writeln('     IF THE ARROW HITS THE WUMPUS, YOU WIN.');
     writeln('     IF THE ARROW HITS YOU, YOU LOSE.');
     write('HIT RETURN TO CONTINUE');
     prompt;
     readln(cr);
     writeln('    WARNINGS:');
     writeln('     WHEN YOU ARE ONE ROOM AWAY FROM A WUMPUS OR HAZARD,');
     writeln('     THE COMPUTER SAYS:');
     writeln(' WUMPUS:  ''I SMELL A WUMPUS''');
     writeln(' BAT   :  ''BATS NEARBY''');
     writeln(' PIT   :  ''I FEEL A DRAFT''');
     writeln;
  end;

{ *** PRINT LOCATION & HAZARD WARNINGS *** }
procedure location;
  var
    j: features;
    k: integer;
  begin
    writeln;
    for j := WUMPUS to BAT2 do
        for k := 1 to 3 do
            if cave[feature[HUNTER],k]=feature[j] then
              case j of
                   WUMPUS: writeln('I SMELL A WUMPUS!');
                PIT1,PIT2: writeln('I FEEL A DRAFT');
                BAT1,BAT2: writeln('BATS NEARBY!');
              end;

    writeln('YOU ARE IN ROOM ', feature[HUNTER]);
    writeln('TUNNELS LEAD TO ', cave[lt,1], ' ', cave[lt,2], ' ', cave[lt,3]);
    writeln
  end;

{ *** CHOOSE OPTION *** }
function askaction:integer;
  var
    i: char;
    o: integer;
  begin
    o := 0;
    repeat
      write('SHOOT OR MOVE (S-M)? ');
      prompt;
      readln(i);
      if (i = 'S') or (i = 's') then
        o := 1;
      if (i = 'M') or (i = 'm') then
        o := 2;
    until o <> 0;
    askaction := o;
  end;

{ *** SEE IF ARROW IS AT feature[HUNTER] OR AT feature[WUMPUS] }
procedure hittest;
  begin
    if lt=feature[WUMPUS] then
      begin
        writeln('AHA! YOU GOT THE WUMPUS!');
        duel := 1
       end
     else if lt=feature[HUNTER] then
       begin
         writeln('OUCH! ARROW GOT YOU!');
         duel := -1
       end;
  end;

{ *** MOVE WUMPUS ROUTINE *** }
procedure movewumpus;
  var
    k: integer;
  begin
    k := rnd(4);
    if k<>4 then
      feature[WUMPUS] := cave[feature[WUMPUS],k];
    if feature[WUMPUS] = lt then
      begin
        writeln('TSK TSK TSK - WUMPUS GOT YOU!');
        duel := -1
      end;
  end;

{ *** ARROW ROUTINE *** }
procedure shootarrow;
  var
    j9,k,k1: integer;
    goodroom: boolean;
  begin
    duel := 0;
    { *** PATH OF ARROW *** }
    repeat
      write('NO. OF ROOMS (1-5)? ');
      prompt;
      readln(j9);
    until (j9 > 0) and (j9 < 6);
    for k := 1 to j9 do
      begin
        repeat
          goodroom := false;
          write('ROOM # ');
          prompt;
          readln(path[k]);
          if k > 2 then
            if path[k] <> path[k-2] then
              goodroom := true
            else
              writeln('ARROWS AREN''T THAT CROOKED - TRY ANOTHER ROOM')
          else
            goodroom := true;
        until goodroom = true;
      end;
      
      { *** SHOOT ARROW *** }
      lt := feature[HUNTER];
      for k := 1 to j9 do
        begin
          for k1 := 1 to 3 do
            if cave[lt,k1]=path[k] then
              lt := path[k]
            else
              lt := cave[lt, rnd(3)]; { *** NO TUNNEL FOR ARROW *** }
          hittest;
        end;

     writeln('MISSED');
     lt := feature[HUNTER];
     { *** MOVE WUMPUS *** }
     movewumpus;
     { *** AMMO CHECK *** }
     arrows := arrows - 1;
     if arrows = 0 then
       duel := -1;
  end;

{ *** MOVE ROUTINE *** }
procedure movehunter;
  label 1045,1145;
  var
    k: integer;
    legal: boolean;
  begin
    duel := 0;
    repeat
      repeat
        write('WHERE TO? ');
        prompt;
        readln(lt);
      until (lt >= 1) and (lt <= 20);
      legal := false;
      for k := 1 to 3 do { *** CHECK IF LEGAL MOVE *** }
        if cave[feature[HUNTER],k]=lt then
          legal := true;
      if lt = feature[HUNTER] then
        legal := true;
      if legal = false then
        write('NOT POSSIBLE -');
    until legal;

     { *** CHECK FOR HAZARDS *** }
1045:
    feature[HUNTER] := lt;
    { *** WUMPUS *** }
    if lt = feature[WUMPUS] then
      begin
        writeln('... OOPS! BUMPED A WUMPUS!');
        { *** MOVE WUMPUS *** }
        movewumpus;
        if duel<>0 then
          goto 1145;
      end;
      { *** PIT *** }
      if (lt=feature[PIT1]) or (lt=feature[PIT2]) then
        begin
          writeln('YYYYIIIIEEEE . . . FELL IN PIT');
          duel := -1;
          goto 1145
        end;

     { *** BATS *** }
     if (lt=feature[BAT1]) or (lt=feature[BAT2]) then
       begin
         writeln('ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!');
         lt := rnd(20);
         goto 1045 { See if you landed on something }
       end;
1145:
  end;

begin
  randomize;

  write('INSTRUCTIONS (Y-N)? ');
  prompt;
  readln(answer);
  if (answer = 'Y') or (answer = 'y') then
    instructions;
  initcave;
  populate;

  while true do
    begin
      { *** SET NO. OF ARROWS *** }
      arrows := 5;
      lt := feature[HUNTER];
      { *** RUN THE GAME *** }
      writeln('HUNT THE WUMPUS');
      repeat
        { *** HAZARD WARNING AND LOCATION *** }
        location;
        { *** MOVE OR SHOOT *** }
        o := askaction;
        if o = 1 then
          shootarrow
        else
          movehunter;
 
      until duel <> 0;
      if duel > 0 then
        writeln('HEE HEE HEE - THE WUMPUS''LL GET YOU NEXT TIME!!')
      else
        writeln('HA HA HA - YOU LOSE!');

      for j := HUNTER to BAT2 do
        feature[j] := origsetup[j];

      write('SAME SETUP (Y-N)? ');
      prompt;
      readln(answer);
      if (answer<>'Y') and (answer<>'y') then populate;
    end;

end.
