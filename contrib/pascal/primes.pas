{ program 8.2 in Pascal User Manual and Report, second edition.
 generate the primes between 3..10000 using a
 sieve containing odd integers in this range.}

program primes(output);

const wdlength = 256; { OS-9 Pascal allows 256 elements }
      maxbit = 255;
      w = 19; {w = n div wdlength div 2}
var  sieve,primes : array[0..w] of set of 0..maxbit;
     next : record word,bit :integer
            end;
     j,k,t,c : integer;  empty : boolean;
begin {initialize}
   for t := 0 to w do
      begin sieve[t] := [0..maxbit]; primes[t] := [] end;
   sieve[0] := sieve[0] - [0];  next.word := 0;
   next.bit := 1;  empty := false;

   with next do
   repeat { find next prime }
      while not(bit in sieve[word]) do bit := succ(bit);
      primes[word] := primes[word] + [bit];
      c := 2*bit + 1;
      j := bit; k := word;
      while k<=w do {eliminate}
      begin sieve[k] := sieve[k] - [j];
         k := k + word*2;  j := j + c;
         while j>maxbit do
            begin  k := k+1; j := j - wdlength
            end
      end;
      if sieve[word]=[] then
         begin   empty := true; bit := 0
         end;
      while empty and (word<w) do
         begin  word := word+1; empty := sieve[word]=[]
         end
   until empty; {ends with}

{print primes}
   k := 0;
   for t := 0 to w do
      for j := 0 to maxbit do
         if j in primes[t] then
            begin write((t * wdlength + j) * 2 + 1);
               k := k + 1;
               if k mod 10 = 0 then writeln
            end;
end.
