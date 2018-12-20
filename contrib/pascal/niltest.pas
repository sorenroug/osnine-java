{ Investigate what 'nil' corresponds to when read as an integer. }
PROGRAM niltest;

VAR
  m : RECORD CASE boolean OF
      true : (asPtr : ^integer);
      false: (asInt : integer);
      END;

BEGIN
  m.asInt := 9999;
  writeln('Set to 9999 value:', m.asInt);
  m.asPtr := nil;
  writeln('Nil value as integer:', m.asInt);
END.
