program startrekins(input);

var
  yn : char;


{ Print instructions }
procedure instructions;
  var
    helpfile: text;
    ch: char;
  begin
    reset(helpfile, '/d0/games/startrek.hlp');
    while not eof(helpfile) do
      begin
        while not eoln(helpfile) do
          begin
            read(helpfile, ch);
            write(ch)
          end;
        readln(helpfile);
        writeln
      end;
    prompt;
    close(helpfile);
  end;

{ MAIN }
begin

  write('Do you need instructions (y/n)? ');
  prompt;
  readln(yn);
  if yn<>'n' then instructions;

end.
