(* Random number generator between 0 and 32767.

The program given demonstrates the basic
idea by printing out 100 random integers. To use it in
an application, one would include the constant, type, and
variable declarations, the declared procedure randinitialize,
and the declared function rand. In the main program,
randinitialize would be called at the start. Subsequently,
any call to rand will produce a random integer in range
of 0 to 32,767. *)

PROGRAM demonstration;
type
  randlink = ^randentry;
  randentry = record
    next : randlink;
    case boolean of
      true : (randset : set of 0..15);
      false : (randinteger : integer);
    end;
var
  currentrand, offsetrand : randlink;
  i,r : integer;

procedure randinitialize;
  const
    n = 47;
    m = 5;
  var
    temp : randlink;
    index : integer;
    seed : array[1..n] of integer;

  begin
    seed[1]:=6936;seed[2]:=11137;seed[3]:=175;
    seed[4]:=28333;seed[5]:=8228;seed[6]:=23343;
    seed[7]:=16201;seed[8]:=525;seed[9]:=32646;
    seed[10]:=12998;seed[11]:=14044;seed[12]:=22459;
    seed[13]:=8155;seed[14]:=14560;seed[15]:=5428;
    seed[16]:=3057;seed[17]:=13500;seed[18]:=7489;
    seed[19]:=23956;seed[20]:=1631;seed[21]:=18724;
    seed[22]:=12979;seed[23]:=7543;seed[24]:=26891;
    seed[25]:=5076;seed[26]:=18818;seed[27]:=17248;
    seed[28]:=26679;seed[29]:=8706;seed[30]:=9342;
    seed[31]:=29575;seed[32]:=31530;seed[33]:=23069;
    seed[34]:=26123;seed[35]:=21236;seed[36]:=18077;
    seed[37]:=20080;seed[38]:=12260;seed[39]:=26133;
    seed[40]:=18581;seed[41]:=3331;seed[42]:=26261;
    seed[43]:=18650;seed[44]:=8271;seed[45]:=29635;
    seed[46]:=11322;seed[47]:=2239;
    index := 1;
    new(currentrand);
    temp := currentrand;
    currentrand^.randinteger := seed[index];
    index := 2;

    while index <= m do
    begin
      new(currentrand^.next);
      currentrand^.next^.randinteger := seed[index];
      currentrand := currentrand^.next;
      index := index + 1;
    end;
    offsetrand := currentrand;
    while index <= n do
      begin
        new(currentrand^.next);
        currentrand^.next^.randinteger := seed[index];
        currentrand := currentrand^.next;
        index := index + 1;
      end;
    currentrand^.next := temp;
  end;

function rand : integer;
  begin
    currentrand^.randset := (currentrand^.randset - offsetrand^.randset) +
      (offsetrand^.randset - currentrand^.randset);
    rand := currentrand^.randinteger;
    currentrand := currentrand^.next;
    offsetrand := offsetrand^.next;
  end;

begin
  randinitialize;
  for i := 1 to 100 do
  begin
    r := rand;
    writeln(r:6)
  end
end.
