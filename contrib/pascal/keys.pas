{ Simple program to read the keyboard and print out the key codes. }
PROGRAM keys(input);
VAR
  res : char;
BEGIN
  WHILE TRUE DO
  BEGIN
    res := getchar(input);
    writeln(ord(res))
  END;
END.
