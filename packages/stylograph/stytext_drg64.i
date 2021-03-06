 TTL S-TEXT
 PAG

*ESCAPE CHARACTER CONSTANTS
ESCTBL EQU *
CURUC FCC 'I' CURSOR UP
 FCC 'L' CURSOR RIGHT
CURDC FCC ',' CURSOR DOWN
 FCC 'J' CURSOR LEFT
 FCC 'U' SCROLL UP
 FCC 'M' SCROLL DOWN
 FCC 'F' FIND CHARACTERS
 FCC 'R' REPLACE CHARACTERS
 FCC ';' ENTER TEXT
 FCC 'W' WITHDRAW RESERVED TEXT
 FCC 'Z' BLOCK DELETE
 FCC 'S' RESERVE BLOCK OF TEXT
 FCC '/' COMMAND MODE
 FCC 'D' DUPLICATE
 FCC 'O' MOVE SCREEN UP
 FCC '.' MOVE SCREEN DOWN
CURLRC FCC 'K' MOVE CURSOR LEFT-RIGHT
PAGC FCC 'P' MOVE TO PAGE #
 FCC '}' SET MARKER CHARACTER
 FCB $14 ^T TAB CHARACTER
 FCC '-' DUMMY
 FCC '7' SCROLL LEFT
 FCC '9' SCROLL RIGHT
 FCC '1' OVERWRITE 1
 FCC '^' INSERT 1

*CHARACTER MOD CHARACTERS (ALSO CONTROL)
ULMCHR FCB $15 ^U UNDERLINE
OLMCHR FCB $F ^O OVERLINE
BFMCHR FCB 2 ^B BOLDFACE
SPMCHR FCB 9 ^I SUPERSCRIPT
SBMCHR FCB $B ^K SUBSCRIPT
ENMODC FCB $1A END MOD
 FCB $20 CURSOR RIGHT
BSC FCB $08 BS CHR FROM KEYBOARD


*CONTROL CHARACTER CONSTANTS
CTRTBL EQU *
LNDELC FCB $18 ^X LINE DELETE
 FCB $04 ^D CHARACTER DELETE
 FCB $17 ^W WORD + SPACE DELETE
 FCB $6 ^F FORMAT DISPLAY TOGGLE
NMERC FCB $0E ^N NAME ERROR
 FCB $16 ^V VIEW MODS
PAGSTC FCB $10 ^P PAGE STATUS
 FCB $07 ^G SOFT HYPHEN (GHOST)
 FCB $12 ^R SET TAB
 FCB $19 ^Y CLEAR TAB
 FCB $1E ^^ TOGGLE UPPER CASE LOCK
 FCB $01 ^A HELP, ASSISTANCE
 PAG

*MISC. CHARACTER CONSTANTS
ESCC FCB $1B ESCAPE CHARACTER
TABC FCB $14 ^T TAB CHARACTER
FLDCHR FCB $15 ^U UPPER/LOWER CASE FOLD
INSFIL FCC '-' FILL CHR ON INSERT
CRCHR FCC '|' CR SCREEN CHARACTER
PRCCHR FCC ',' PROC COMMAND CHARACTER
MRKCHR FCC '}' MARKER CHARACTER
PNCHR FCC '#' PAGE NUMBER MARKER
STMODC FCC '|' START MOD
RARCHR FCC '>' RIGHT ARROW
LARCHR FCC '<' LEFT ARROW
YCHR FCC 'Y' YES
NCHR FCC 'N' NO
SCHR FCC 'S' STOP
ACHR FCC 'A' ALL, "REPLACE" RESPONSE
PSCHR FCC 'S' PRINTER STOP
PTCHR FCC 'T' PRINTER TAB
PBCHR FCC 'B' PRINTER BACKSPACE
CTMCHR FCC 'T' COMMAND LINE TERM OPTION
CPTCHR FCC 'P' COMMAND LINE PRINTER OPTION
CPGCHR FCC 'M' COMMAND LINE MAX PAGE
OPTCHR FCC '+' COMMAND LINE OPTION PREFIX
RBCHR FCC '}' FIND/REPLACE RIGHT BRACKET
LBCHR FCC '{' FIND/REPLACE LEFT BRACKET


*START PARAMETERS
STLM FCB 0 START LEFT MARGIN
STLL FCB 0 LINE LENGTH, 0= DEFAULT TO NC
STMS FCB 0 SINGLE SPACE
STHFLL FCB 0 H/F LINE LENGTH, 0= DEFAULT TO NC
STJU FCB 0 JUSTIFICATION
STPL FCB 66 PAGE LENGTH
STCS FCB 10 CHARACTERS/INCH
STVS FCB 6 VERTICAL SPACING
STBFS FCB 4 BOLDFACE STRIKE COUNT
STPS FCB 0 NON-PROPORTIONAL SPACE
STPADC FCB 0 NON PADDABLE SPACE CHARACTER
STMMC FCB 0 MAIL-MERGE CHARACTER
STPC FCB 0 PRINTER CHARACTER

*VECTORS FOR THE STRINGS

FMTTBL FDB XFMTTBL
ERRTBL FDB XERRTBL
BELS1 FDB XBELS1
BAVM1 FDB XBAVM1
PAGS1 FDB XPAGS1

PGMS1 FDB XPGMS1
PGMS6 FDB XPGMS6
PGM50 FDB XPGM50
PGM51 FDB XPGM51
PGM52 FDB XPGM52
PGM53 FDB XPGM53
PGM54 FDB XPGM54
PGM55 FDB XPGM55

PGBS1 FDB XPGBS1

SAVM1 FDB XSAVM1
SAVMB FDB XSAVMB
SAVM2 FDB XSAVM2
SAVM3 FDB XSAVM3
SAVM4 FDB XSAVM4
SAVM5 FDB XSAVM5

SVMS1 FDB XSVMS1

DSTM1 FDB XDSTM1
DSTM2 FDB XDSTM2
DSTM3 FDB XDSTM3
DSTM5 FDB XDSTM5
DSTM6 FDB XDSTM6

TTYS1 FDB XTTYS1
SPCLS1 FDB XSPCLS1
OSPS1 FDB XOSPS1
OSPS2 FDB XOSPS2
EXTM1 FDB XEXTM1
EXTM2 FDB XEXTM2
ERMM1 FDB XERMM1

PSWS1 FDB XPSWS1
PSWS2 FDB XPSWS2
PSWS3 FDB XPSWS3
PSWS4 FDB XPSWS4
PSWS5 FDB XPSWS5

STYS1 FDB XSTYS1
PRNS1 FDB XPRNS1
PRNS2 FDB XPRNS2
PRNS3 FDB XPRNS3
PRNS4 FDB XPRNS4
OTXS1 FDB XOTXS1
OTXS2 FDB XOTXS2
OTXS3 FDB XOTXS3
OTXS4 FDB XOTXS4
SPLS1 FDB XSPLS1
PSQS1 FDB XPSQS1

NEWM1 FDB XNEWM1
NEWM3 FDB XNEWM3
NEWM4 FDB XNEWM4
NEWM5 FDB XNEWM5
NEWM6 FDB XNEWM6
NEWM7 FDB XNEWM7
NEWM8 FDB XNEWM8
NEWM9 FDB XNEWM9

FNDS1 FDB XFNDS1
FNDS2 FDB XFNDS2
FNDS3 FDB XFNDS3
RPLS1 FDB XRPLS1
RPLS2 FDB XRPLS2
RPLS3 FDB XRPLS3
BDLS1 FDB XBDLS1
BDLS2 FDB XBDLS2

SUPS1 FDB XSUPS1
BANNER FDB XBANNER
HLPS1 FDB XHLPS1
HLPS2 FDB XHLPS2
HLPS3 FDB XHLPS3
HLPS4 FDB XHLPS4
HLPS5 FDB XHLPS5
HLPS6 FDB XHLPS6
HLPS7 FDB XHLPS7

*FORMAT COMMAND TABLE
XFMTTBL EQU *
 FCC 'CE'
 FCB 0
 FCC 'LL'
 FCB 0
 FCC 'PL'
 FCB 0
 FCC 'JU'
 FCB 0
 FCC 'RJ'
 FCB 0
 FCC 'NJ'
 FCB 0
 FCC 'LM'
 FCB 0
 FCC 'SP'
 FCB 0
 FCC 'SS'
 FCB 0
 FCC 'HD'
 FCB 0
 FCC 'FT'
 FCB 0
 FCC '*'
 FCB 0
 FCC 'PN'
 FCB 0
 FCC 'PG'
 FCB 0
 FCC 'SI'
 FCB 0
 FCC 'IN'
 FCB 0
 FCC 'VT'
 FCB 0
 FCC 'CS'
 FCB 0
 FCC 'VS'
 FCB 0
 FCC 'PS'
 FCB 0
 FCC 'NPS'
 FCB 0
 FCC 'PC'
 FCB 0
 FCC 'MMC'
 FCB 0
 FCC 'PADC'
 FCB 0
 FCC 'NL'
 FCB 0
 FCC 'PP'
 FCB 0
 FCC 'PPSI'
 FCB 0
 FCC 'PPSP'
 FCB 0
 FCC 'PPNL'
 FCB 0
 FCC 'TF'
 FCB 0
 FCC 'BFS'
 FCB 0
 FCB 0 END OF TABLE


XERRTBL EQU *
 FCB 2
 FCC 'L/R SCROLL OUT OF BOUNDS'
 FCB 0
 FCB 3
 FCC 'INVALID ESCAPE COMMAND ENTERED'
 FCB 0
 FCB 7
 FCC 'TOP OF TEXT REACHED'
 FCB 0
 FCB 10
 FCC 'BOTTOM OF TEXT REACHED'
 FCB 0
 FCB 11
 FCC 'MAXIMUM PAGE LIMIT'
 FCB 0
 FCB 12
 FCC 'INVALID FORMAT COMMAND'
 FCB 0
 FCB 13
 FCC 'FORMAT VALUE OUT OF BOUNDS'
 FCB 0
 FCB 14
 FCC 'ILLEGAL HEADER OR FOOTER COMMAND'
 FCB 0
 FCB 15
 FCC "CURSOR ON FORMAT LINE - CAN'T BUNDLE"
 FCB 0
 FCB 16
 FCC "HEADER OR FOOTER TOO LONG FOR PAGE"
 FCB 0
 FCB 17
 FCC "CAN'T BACKSPACE TO BUNDLED FORMAT LINE"
 FCB 0
 FCB 18
 FCC "ILLEGAL DELETE"
 FCB 0
 FCB 20
 FCC "CAN'T DELETE - NOT BRACKETED BY RETURNS"
 FCB 0
 FCB 21
 FCC "CAN'T FIND MARKER"
 FCB 0
 FCB 22
 FCC "TEXT ALREADY SAVED"
 FCB 0
 FCB 23
 FCC "NOT ENOUGH MEMORY TO DO COMMAND"
 FCB 0
 FCB 24
 FCC "NO TEXT SAVED, CAN'T WITHDRAW OR DUPLICATE"
 FCB 0
 FCB 25
 FCC "WARNING - MEMORY NEARLY FULL"
 FCB 0
 FCB 26
 FCC "MEMORY FULL"
 FCB 0
 FCB 27
 FCC "TOO MANY TABS"
 FCB 0
 FCB 28
 FCC "NO MORE TABS SET"
 FCB 0
 FCB 29
 FCC "CAN'T TAB"
 FCB 0
 FCB 30
 FCC "WARNING - NONSTANDARD CHARACTER SPACING"
 FCB 0
 FCB 31
 FCC "STRING OVERFLOW"
 FCB 0
 FCB 32
 FCC "STRING NOT FOUND"
 FCB 0
 FCB 33
 FCC "ILLEGAL PAGE NUMBER"
 FCB 0
 FCB 34
 FCC 'WARNING - NO "PS-TABLE" SET'
 FCB 0
 FCB 0 END OF TABLE

XBELS1 FCC 'NO ERROR'
 FCB 0

XBAVM1 FCC "CANNOT MOVE TO LAST PAGE, TOO MANY PAGES"
 FCB 0

XPAGS1 FCC "*********** PAGE="
 FCB 0

*MESSAGES AND NUMBER AREAS
XPGMS1 FCC '- PAGE STATUS -'
 FCB 0
XPGM2A FCC 'READ FILE = '
 FCB 0
XPGMS2 FCC 'WRITE FILE = '
 FCB 0
XPGMS4 FCC '------ NONE --------'
 FCB 0
XPGMS6 EQU *
 FCC 'SERIAL PAGE # ------'
 FCB 0
 FCC 'PRINTED PAGE # -----'
 FCB 0
 FCC 'LINE # -------------'
 FCB 0
 FCB 0 SKIP A LINE
 FCC 'PAGE LENGTH ---- ,PL'
 FCB 0
 FCC 'HEADER LINES -,HD ,,'
 FCB 0
 FCC 'FOOTER LINES -,FT ,,'
 FCB 0
 FCC 'SPACING -------- ,SS'
 FCB 0
 FCC 'LINES/INCH ----- ,VS'
 FCB 0
 FCB 0
 FCC 'LINE LENGTH ---- ,LL'
 FCB 0
 FCC 'H/F L-LENGTH --- ,LL'
 FCB 0
 FCC 'LEFT MARGIN ---- ,LM'
 FCB 0
 FCC 'INDENT --------- ,IN'
 FCB 0
 FCC "CHAR'S/INCH ---- ,CS"
 FCB 0

 FCC 'PARA INDENT -- ,PPSI'
 FCB 0
 FCC 'PARA SPACE --- ,PPSP'
 FCB 0
 FCC "PARA NEED L'S -,PPNL"
 FCB 0
 FCB 0
 FCC 'JUSTIFIED - ,JU/,NJU'
 FCB 0
 FCC 'PROP SP --- ,PS/,NPS'
 FCB 0
 FCB 0
 FCC 'PRINTER CHAR --- ,PC'
 FCB 0
 FCC 'SP PAD CHAR -- ,PADC'
 FCB 0
 FCC 'M-M CHARACTER - ,MMC'
 FCB 0
 FCB 0
 FCC 'ROOM LEFT'
 FCB 0
 FCB 0,0,0,0,0
XPGM50 FCC 'READ FILE:   '
 FCB 0
XPGM51 FCC 'WRITE FILE:  '
 FCB 0
XPGM52 FCC '---NONE---'
 FCB 0
XPGM53 FCC 'STATUS:     '
 FCB 0
XPGM54 FCC 'OPEN'
 FCB 0
XPGM55 FCC 'CLOSED'
 FCB 0

XPGBS1 FCC 'PAGE'
 FCB 0
XSAVM1 FCC 'Save as "'
 FCB 0
XSAVMB FCC '" (Y*/N)? '
 FCB 0
XSAVM2 FCC 'NO TEXT SAVED'
 FCB 0
XSAVM3 FCC 'PART OR ALL OF TEXT NOT SAVED'
 FCB 0
XSAVM4 FCC 'Delete backup file (Y*/N)? '
 FCB 0
XSAVM5 FCC 'File name? '
 FCB 0

XSVMS1 FCC 'Marker not found.'
 FCB 0
XDSTM1 FCC 'WARNING! FILE TOO LARGE - '
XDSTM2 FCC 'ENTIRE FILE MAY NOT BE NOT LOADED!!!'
 FCB 0
XDSTM3 FCC 'FILE NOT LOADED'
 FCB 0
XDSTM5 FCB $D,$A
 FCC 'ILLEGAL PRINTER, TERMINAL, OR FILE NAME'
 FCB 0
XDSTM6 FCC 'INPUT FILE NOT FOUND'
 FCB 0

XTTYS1 FCC 'Output set for "TTY" printer.'
 FCB 0
XSPCLS1 FCC 'Output set for "Specialty" printer.'
 FCB 0
XOSPS1 FCC 'OS-9 command:  '
 FCB 0
XOSPS2 FCB 7
 FCC 'Command not allowed with files open.'
 FCB 0
XPSQS1 FCC 'Hit any key to restart printer'
 FCB 0

XNEWM1 FCC 'No save.  Cursor on top page.'
 FCB 0
XNEWM3 FCC 'Save text (Y*/N)? '
 FCB 0
XNEWM4 FCC '  to file "'
 FCB 0
XNEWM5 FCC '" (Y*/N)? '
 FCB 0
XNEWM6 FCC 'Fill from input file (Y*/N)? '
 FCB 0
XNEWM7 FCC 'No room for fill.'
 FCB 0
XNEWM8 FCC 'DISK ERROR!!!'
 FCB 0
XNEWM9 FCC 'No fill.  Input file empty.'
 FCB 0

XEXTM1 FCC 'Is the text secure? '
 FCB 0
XEXTM2 FCC 'Are you sure? '
 FCB 0
XERMM1 FCC 'Erase entire file in memory? '
 FCB 0

XPSWS1 FCC 'STYPS'
 FCB 0,0,0,0,0,0,0,0,0,0,0,0,0
XPSWS2 FCC 'ERROR - PROPORTIONAL SPACING TABLE NOT LOADED'
 FCB 0
XPSWS3 FCC 'Set proportional spacing table "'
 FCB 0
XPSWS4 FCC '" (Y*,N)? '
 FCB 0
XPSWS5 FCC 'Table name? '
 FCB 0

XPRNS1 FCC 'Different printer (Y/N*)? '
 FCB 0
XPRNS2 FCC 'PRINT DRIVER NOT FOUND'
 FCB 0
XPRNS3 FCC ' Name? '
 FCB 0
XPRNS4 FCC 'Stop for new pages (Y/N*)? '
 FCB 0
XOTXS1 FCC 'Hit SPACE to stop/continue, RETURN to abort.  '
 FCB 0
XOTXS2 FCC 'Print all pages (Y*/N)? '
 FCB 0
XOTXS3 FCC ' First = '
 FCB 0
XOTXS4 FCC '  Last = '
 FCB 0
XSPLS1 FCC 'Spooled output file name? '
 FCB 0

XFNDS1 FCC '*** FIND    '
 FCB 0
XFNDS2 FCC '*** STOP (RET) OR CONTINUE (SP)?'
 FCB 0
XFNDS3 FCC ' UPPER/LOWER CASE'
 FCB 0
XRPLS1 FCC '*** REPLACE '
 FCB 0
XRPLS2 FCC '*** WITH    '
 FCB 0
XRPLS3 FCC '*** REPLACE (Y-N-A)?'
 FCB 0
XBDLS1 FCC '*** DELETE '
 FCB 0
XBDLS2 FCC '  CHARACTERS? '
 FCB 0

XSUPS1 equ *
 FCC 'EDIT ---------- go to ESCAPE mode to edit text'
 FCB 0
 FCC 'PRINT --------- print the text'
 FCB 0
 FCC 'SAVE & RETURN - save text and return to OS-9'
 FCB 0
 FCC 'SAVE ---------- save the text to disk'
 FCB 0
 FCC 'SAVE TO MARK -- save text from cursor to marker'
 FCB 0
 FCC 'RETURN -------- return to OS-9'
 FCB 0
 FCC 'LOAD ---------- insert file at cursor position'
 FCB 0
 FCC 'ERASE --------- erase text without saving'
 FCB 0
 FCC 'SPECIAL-------- use a "letter quality" printer'
 FCB 0
 FCC 'TTY ----------- use a TTY (matrix) printer'
 FCB 0
 FCC 'PASS ---------- pass a command to OS-9'
 FCB 0
 FCC 'SPOOL --------- send text to disk for printing'
 FCB 0
 FCC 'WHEEL --------- select proportional print wheel'
 FCB 0
 FCC 'NEW ----------- new text from input file'
 FCB 0

XBANNER FCC '     STYLOGRAPH for the Dragon 64'
 FCB 0

XHLPS1 FCC 'RETURN'
 FCB 0
 FCC 'ESCAPE Commands'
 FCB 0
 fcc 'CONTROL Commands'
 FCB 0
 FCC 'FORMAT Commands (vertical)'
 FCB 0
 fcc 'FORMAT Commands (horizontal)'
 FCB 0
 FCC 'FORMAT Commands (misc.)'
 FCB 0
 fcc 'Displayed character mods'
 FCB 0
XHLPS2 FCC "STYHLP1"
 FCB 0
XHLPS3 FCC "STYHLP2"
 FCB 0
XHLPS4 FCC "STYHLP3"
 FCB 0
XHLPS5 FCC "STYHLP4"
 FCB 0
XHLPS6 FCC "STYHLP5"
 FCB 0
XHLPS7 FCC "STYHLP6"
 FCB 0

XSTYS1 FCC '/p'
 FCB 0

* Remnants from binary patching
 FCC ' later printing'
 FCB 0
 FCC 'WHEEL ----------- specify a proportional spacing print wheel'
 FCB 0
 FCC 'NEW ------------- new text from input file'
 FCB 0
 FCC '    STYLOGRAPH WORD PROCESSING SYSTEM V2.1 (c) 1981'
 FCB 0
 FCC 'RETURN'
 FCB 0
 FCC 'ESCAPE Commands'
 FCB 0
 FCC 'CONTROL Commands'
 FCB 0
 FCC 'FORMAT Commands (vertical)'
 FCB 0
 FCC 'FORMAT Commands (horizontal)'
 FCB 0
 FCC 'FORMAT Commands (misc.)'
 FCB 0

* Redundant junk in original
*
 FCC 'Displayed character mods'
 FCB 0
 FCC 'STYHLP1'
 FCB 0
 FCC 'STYHLP2'
 FCB 0
 FCC 'STYHLP3'
 FCB 0
 FCC 'STYHLP4'
 FCB 0
 FCC 'STYHLP5'
 FCB 0
 FCC 'STYHLP6'
 FCB 0
 FCC   '/p1'
 FCB 0,0,0,0,0,0,0,0,0

