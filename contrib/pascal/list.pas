{ List a text file to standard output
  This uses a special array called 'SYSPARAM' to pass arguments from the
  calling shell. The array is predefined as:
  sysparam : ARRAY [0..79] OF char;
  This is a feature of OS-9 Pascal and is not a standard Pascal function.
}
program list(input);

var
  listfile: text;
  ch: char;
begin
  reset(listfile, sysparam);
  while not eof(listfile) do
    begin
      while not eoln(listfile) do
        begin
          read(listfile, ch);
          write(ch)
        end;
      readln(listfile);
      writeln
    end;
  close(listfile);
end.
