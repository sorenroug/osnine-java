{ This program tests if the 'packed' keyword is supported.
  The 'packed' keyword can be placed in front of arrays, records, sets
  and file types.
  The procedures pack and unpack are not implemented.
}
PROGRAM packtest;

TYPE
  packarr = PACKED array[1..10] of char;
  unpackarr = array[1..10] of char;

  date = PACKED record mo : (jan,feb,mar,apr,may,jun,
                             july,aug,sept,oct,nov,dec);
                       day : 1..31;
                       year : integer;
                end;
VAR
  name : packarr;
  uname : unpackarr;
  birth : date;

BEGIN
  name := 'abcdefghij';
  birth.mo := aug;
  birth.day := 4;
  birth.year := 2018;
  writeln(name)
  {
  unpack(name, uname, 0);
  writeln(uname);
  }
END.
