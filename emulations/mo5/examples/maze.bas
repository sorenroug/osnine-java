3 SCREEN 4,2
5 CLS
10 PRINT TAB(12);"AMAZING PROGRAM"
20 PRINT TAB(10);"CREATIVE COMPUTING,"
30 PRINT TAB(9);"MORRISTOWN, NEW JERSEY"
40 PRINT:PRINT
50 PRINT "PRESS ANY KEY TO CONTINUE"
60 X=RND(1):IF INKEY$="" THEN 60
70 REM -- CONSTANTS
80 NOFLOOR% = 1
90 NORIGHTWALL% = 2

100 INPUT "WHAT ARE YOUR WIDTH AND LENGTH";COLS%,ROWS%
102 IF COLS% <= 1 OR ROWS% <= 1 THEN PRINT "MEANINGLESS DIMENISION. TRY AGAIN":GOTO 100
103 INPUT "TEXT OR GRAPHICAL OUTPUT (T/G)";TYPE$
104 IF TYPE$<>"T" AND TYPE$<>"G" THEN PRINT "ENTER 'T' OR 'G'":GOTO 103
105 IF TYPE$ = "T" THEN TT%=1 ELSE TT%=2

110 IF TT%=2 THEN 140
120 INPUT "OUTPUT TO SCREEN OR PRINTER (S/P)";DEVICE$
130 IF DEVICE$<>"S" AND DEVICE$<>"P" THEN PRINT "ENTER 'S' OR 'P'":GOTO 120
135 IF DEVICE$="S" THEN DEVICE$="SCRN:" ELSE DEVICE$="LPRT:(80)"
140 DIM VISITED%(COLS%,ROWS%),CELLS%(COLS%,ROWS%)
150 PRINT:PRINT:PRINT:PRINT
155 NUMCELLS% = COLS% * ROWS%
160 Q%=0:Z%=0:ENTRY%=INT(RND(1)*COLS%+1)
195 CELLINX%=1:VISITED%(ENTRY%,1)=CELLINX%:CELLINX% = CELLINX% + 1
200 C%=ENTRY%:R%=1:GOTO 260

210 IF C%<>COLS% THEN 240
215 IF R%<>ROWS% THEN 230
220 C%=1:R%=1:GOTO 250
230 C%=1:R%=R%+1:GOTO 250
240 C%=C%+1
250 IF VISITED%(C%,R%)=0 THEN 210
260 IF C%=1 THEN 530
265 IF VISITED%(C%-1,R%)<>0 THEN 530
270 IF R%-1=0 THEN 390
280 IF VISITED%(C%,R%-1)<>0 THEN 390
290 IF C%=COLS% THEN 330
300 IF VISITED%(C%+1,R%)<>0 THEN 330
310 X%=INT(RND(1)*3+1)
320 ON X% GOTO 790,820,860
330 IF R%<>ROWS% THEN 340
334 IF Z%=1 THEN 370
338 Q%=1:GOTO 350
340 IF VISITED%(C%,R%+1)<>0 THEN 370
350 X%=INT(RND(1)*3+1)
360 ON X% GOTO 790,820,910
370 X%=INT(RND(1)*2+1)
380 ON X% GOTO 790,820
390 IF C%=COLS% THEN 470
400 IF VISITED%(C%+1,R%)<>0 THEN 470
405 IF R%<>ROWS% THEN 420
410 IF Z%=1 THEN 450
415 Q%=1:GOTO 430
420 IF VISITED%(C%,R%+1)<>0 THEN 450
430 X%=INT(RND(1)*3+1)
440 ON X% GOTO 790,860,910
450 X%=INT(RND(1)*2+1)
460 ON X% GOTO 790,860
470 IF R%<>ROWS% THEN 490
480 IF Z%=1 THEN 520
485 Q%=1:GOTO 500
490 IF VISITED%(C%,R%+1)<>0 THEN 520
500 X%=INT(RND(1)*2+1)
510 ON X% GOTO 790,910
520 GOTO 790
530 IF R%-1=0 THEN 670
540 IF VISITED%(C%,R%-1)<>0 THEN 670
545 IF C%=COLS% THEN 610
547 IF VISITED%(C%+1,R%)<>0 THEN 610
550 IF R%<>ROWS% THEN 560
552 IF Z%=1 THEN 590
554 Q%=1:GOTO 570
560 IF VISITED%(C%,R%+1)<>0 THEN 590
570 X%=INT(RND(1)*3+1)
580 ON X% GOTO 820,860,910
590 X%=INT(RND(1)*2+1)
600 ON X% GOTO 820,860
610 IF R%<>ROWS% THEN 630
620 IF Z%=1 THEN 660
625 Q%=1:GOTO 640
630 IF VISITED%(C%,R%+1)<>0 THEN 660
640 X%=INT(RND(1)*2+1)
650 ON X% GOTO 820,910
660 GOTO 820
670 IF C%=COLS% THEN 740
680 IF VISITED%(C%+1,R%)<>0 THEN 740
685 IF R%<>ROWS% THEN 700
690 IF Z%=1 THEN 730
695 Q%=1:GOTO 830
700 IF VISITED%(C%,R%+1)<>0 THEN 730
710 X%=INT(RND(1)*2+1)
720 ON X% GOTO 860,910
730 GOTO 860
740 IF R%<>ROWS% THEN 760
750 IF Z%=1 THEN 780
755 Q%=1:GOTO 770
760 IF VISITED%(C%,R%+1)<>0 THEN 780
770 GOTO 910
780 GOTO 1000
790 VISITED%(C%-1,R%)=CELLINX%
800 CELLINX% = CELLINX% + 1:CELLS%(C%-1,R%) = NORIGHTWALL%:C%=C%-1
810 IF CELLINX% > NUMCELLS% THEN 1500
815 Q%=0:GOTO 260
820 VISITED%(C%,R%-1)=CELLINX%
830 CELLINX% = CELLINX% + 1
840 CELLS%(C%,R%-1) = NOFLOOR%:R%=R%-1:IF CELLINX% > NUMCELLS% THEN 1500
850 Q%=0:GOTO 260
860 VISITED%(C%+1,R%)=CELLINX%
870 CELLINX% = CELLINX% + 1
880 CELLS%(C%,R%) = CELLS%(C%,R%) OR NORIGHTWALL%
890 C%=C%+1
900 IF CELLINX% > NUMCELLS% THEN 1500
905 GOTO 530
910 IF Q%=1 THEN 960
920 VISITED%(C%,R%+1)=CELLINX%:CELLINX% = CELLINX% + 1
930 CELLS%(C%,R%) = CELLS%(C%,R%) OR NOFLOOR%
950 R%=R%+1:IF CELLINX% > NUMCELLS% THEN 1500
955 GOTO 260
960 Z%=1
970 Q%=0
980 CELLS%(C%,R%) = CELLS%(C%,R%) OR NOFLOOR%:Q%=0
990 IF (CELLS%(C%,R%) AND NORIGHTWALL%) = 0 THEN C%=1:R%=1:GOTO 250
1000 GOTO 210

1500 ON TT% GOSUB 2000,3000
1510 END

2000 REM -- PRINT MAZE
2010 OPEN "O",#1,DEVICE$
2020 FOR C%=1 TO COLS%
2030 IF C%=ENTRY% THEN PRINT #1, ".  "; ELSE PRINT #1, ".--";
2040 NEXT C%
2050 PRINT #1, "."
2060 FOR R%=1 TO ROWS%
2070 PRINT #1, "I";
2080 FOR C%=1 TO COLS%
2090 IF (CELLS%(C%,R%) AND NORIGHTWALL%) = 0 THEN PRINT #1, "  I"; ELSE PRINT #1, "   ";
2100 NEXT C%
2110 PRINT #1
2120 FOR C%=1 TO COLS%
2130 IF (CELLS%(C%,R%) AND NOFLOOR%) = 0 THEN PRINT #1, ":--"; ELSE PRINT #1, ":  ";
2140 NEXT C%
2150 PRINT #1, ":"
2160 NEXT R%
2170 CLOSE 1
2180 RETURN

3000 REM -- DRAW MAZE
3010 VO%=20
3020 SIZE%=10
3040 CLS
3050 FOR C%=1 TO COLS%
3060 IF C% <> ENTRY% THEN LINE (C%*SIZE%, VO%)-(C%*SIZE%+SIZE%, VO%),4
3070 NEXT C%
3080 FOR R%=1 TO ROWS%
3090 LINE (SIZE%, R%*SIZE%-SIZE%+VO%)-(SIZE%,R%*SIZE%+VO%),4
3100 FOR C%=1 TO COLS%
3110 IF (CELLS%(C%,R%) AND NORIGHTWALL%) = 0 THEN LINE (C%*SIZE%+SIZE%, R%*SIZE%-SIZE%+VO%)-(C%*SIZE%+SIZE%, R%*SIZE%+VO%),4
3120 IF (CELLS%(C%,R%) AND NOFLOOR%) = 0 THEN LINE (C%*SIZE%, R%*SIZE%+VO%)-(C%*SIZE%+SIZE%,R%*SIZE%+VO%),4
3130 NEXT C%
3140 NEXT R%
3150 RETURN