Program NQUEENS (input, output);
          {this program finds one solution to the problem of placing N queens}
          {on an NxN chessboard so they are mutually non-attacking}
            {written by Ron Danielson based on an algorithm by Niklaus Wirth}
            {last modified January 15, 2000}
 
{  ============================================
   OUTPUT OF EXECUTION
   ============================================
   One successful queens placement is:
    1, 6;  2, 3;  3, 5;  4, 7;  5, 1;  6, 4;  7, 2;  8, 8;
}
    const N = 8;       {number of queens}
          N2 = 16;     {queens * 2}
          N2M1 = 15;   {queens * 2 - 1}

    type board = record
        row: array[1..N] of integer;    {row[i] = 0 if no queen on row i}
                                   {otherwise row[i] = column number}
                                   {in which queen is placed}
        d1: array[2..N2] of boolean;   {d1[i] = T if no queen on the ith}
                                    {upper-right to lower-left (backward) diagonal}
                                    {row i, column j corresponds to diagonal i+j}
        d2: array[1..N2M1] of boolean; {d2[i] = T if no queen on the ith}
                                     {upper-left to lower-right (forward) diagonal}
                                     {row i, column j corresponds to diagonal N+i-j}
        end;

    var solution: boolean;       {True when solution found}
          chessbd: board;

    procedure clearboard (var chessbd: board);
        var i: integer;
        begin
           for i := 1 to N do
               chessbd.row[i] := 0;
           for i := 2 to 2*N do
               chessbd.d1[i] := True;
           for i := 1 to 2*N-1 do
               chessbd.d2[i] := True;
        end;   {clearboard}

    procedure placequeen (currow, col: integer; var chessbd: board);
              {place queen at board square currow, col}
        begin
           chessbd.row[currow] := col;       {row[i] = column containing queen}
           chessbd.d1[currow+col] := False;  {mark backward diagonal occupied}
           chessbd.d2[N+currow-col] := False  {mark forward diagonal occupied}
        end;   {placequeen}

    procedure removequeen (currow, col: integer; var chessbd: board);
              {remove queen from board square currow,col}
        begin
           chessbd.row[currow] := 0;
           chessbd.d1[currow+col] := True;
           chessbd.d2[N+currow-col] := True
        end;   {removequeen}

    procedure printsoln (chessbd: board);
        var currow: integer;
        begin
             writeln ('One successful queens placement is:');
           for currow := 1 to N do
               write(currow:2, ',', chessbd.row[currow]:2, '; ');
           writeln
        end;   {printsoln}

    procedure trycol (col: integer; var solution: Boolean; var chessbd: board);
              {try to place a queen in any row in a given column}
              {start with row N, column N and move up and left}
        var currow: integer;
        begin
           currow := N;
           repeat
              if (chessbd.row[currow] = 0) and chessbd.d1[currow+col] and
                   chessbd.d2[N+currow-col]
                 then begin                  {square currow, col is legal}
                    placequeen(currow, col, chessbd);
                    if col > 1               {if not leftmost column}
                       then trycol(col-1, solution, chessbd)    {move left}
                       else begin
                          solution := True;  {solution found}
                          printsoln(chessbd)
                       end;
                    removequeen(currow, col, chessbd)  {backtrack – remove queen placed}
                                                       {on currow and try another row}
                                                       {in the same column}
                 end;
              currow := currow - 1           {try next row}
           until (currow = 0) or solution    {if 0, no good place in this column}
                                             {backtrack to next column right by}
                                             {returning from the recursive call}
        end;   {trycol}

    begin
       solution := False;
       clearboard (chessbd);
       trycol(N, solution, chessbd)
    end.
