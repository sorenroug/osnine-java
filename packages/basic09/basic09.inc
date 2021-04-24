********************************************************************
* Basic09/RunB - Basic09 Runtime
*
*
*
* 06/07/14 - Minor change to Date$ to accommodate F$Time Y2K changes.
         nam   Basic09
         ttl   Basic09

         ifp1
         use   defsfile
         endc

C$CR set $0D
C$LF set $0A
C$SPAC set $20
C$COMA set ',
C$SLSH set '/
C$COLN set ':
C$EOS set $FF
C$FORM set $0C

BYTETYPE equ 0
INTGTYPE  equ 1
REALTYPE equ 2
BOOLTYPE equ 3
STRTYPE equ 4

B.FALSE equ $00
B.TRUE equ $FF

L0000    mod   B09END,B09NAME,Prgrm+Objct,ReEnt+1,start,dsize

         org 0
membase  rmb   2          Start of data memory / DP pointer
memsize  rmb   2
moddir   rmb   4
restop   rmb   2                        top of reserved space
u000A    rmb   2
FREEMEM  rmb   2
table1   rmb   2
table2   rmb   2
table3   rmb   2
u0014    rmb   2
u0016    rmb   1
u0017    rmb   2
u0019    rmb   2
u001B    rmb   1
u001C    rmb   2
u001E    rmb   1
u001F    rmb   2
u0021    rmb   1
u0022    rmb   2
u0024    rmb   2
u0026    rmb   1
u0027    rmb   3
u002A    rmb   3
u002D    rmb   1
errpath  rmb   1
pgmaddr  rmb   1                        starting address of program
u0030    rmb   1
u0031    rmb   1
u0032    rmb   1
u0033    rmb   1
u0034    rmb   1
u0035    rmb   1
errcode  rmb   1          Error code
u0037    rmb   2
DATAPtr  rmb   2     location of DATA values
u003B    rmb   1
u003C    rmb   2
u003E    rmb   1
u003F    rmb   1
u0040    rmb   2
u0042    rmb   2 BASE 0 or 1
u0044    rmb   2
u0046    rmb   2
u0048    rmb   2
u004A    rmb   1
u004B    rmb   1
u004C    rmb   1
u004D    rmb   1
u004E    rmb   2
u0050    rmb   1
u0051    rmb   1
u0052    rmb   1
u0053    rmb   1
u0054    rmb   1
u0055    rmb   1
u0056    rmb   1
u0057    rmb   1
u0058    rmb   1
u0059    rmb   1
u005A    rmb   2
u005C    rmb   2
u005E    rmb   1
u005F    rmb   1
u0060    rmb   2
u0062    rmb   2
u0064    rmb   2
u0066    rmb   1
u0067    rmb   1
u0068    rmb   2
u006A    rmb   1
u006B    rmb   1
u006C    rmb   1
u006D    rmb   1
u006E    rmb   2
u0070    rmb   2
u0072    rmb   2
u0074    rmb   1
u0075    rmb   1
u0076    rmb   1
u0077    rmb   1
u0078    rmb   1
u0079    rmb   1
u007A    rmb   1
u007B    rmb   1
u007C    rmb   1
u007D    rmb   1
u007E    rmb   1
u007F    rmb   1 path number
u0080    rmb   1
u0081    rmb   1
u0082    rmb   2 current position in temp buffer
u0084    rmb   1
u0085    rmb   1
u0086    rmb   1
u0087    rmb   1
u0088    rmb   1
u0089    rmb   1
u008A    rmb   1
u008B    rmb   1
u008C    rmb   2
u008E    rmb   2
u0090    rmb   1
u0091    rmb   1
u0092    rmb   2
u0094    rmb   1
u0095    rmb   1
u0096    rmb   1
u0097    rmb   2
u0099    rmb   1
u009A    rmb   1
u009B    rmb   1
u009C    rmb   1
u009D    rmb   1
u009E    rmb   2
u00A0    rmb   1
u00A1    rmb   2
u00A3    rmb   1
u00A4    rmb   1
u00A5    rmb   1
u00A6    rmb   1
u00A7    rmb   1
u00A8    rmb   1
u00A9    rmb   1
u00AA    rmb   1
u00AB    rmb   1
u00AC    rmb   1
u00AD    rmb   1
u00AE    rmb   1
u00AF    rmb   2
u00B1    rmb   2
u00B3    rmb   1
u00B4    rmb   1
u00B5    rmb   2
u00B7    rmb   2
u00B9    rmb   1
u00BA    rmb   1
u00BB    rmb   1
u00BC    rmb   1
u00BD    rmb   1
u00BE    rmb   1  Duplicate of path #2
u00BF    rmb   2
u00C1    rmb   2
u00C3    rmb   2
u00C5    rmb   1
u00C6    rmb   1
u00C7    rmb   1
u00C8    rmb   2
u00CA    rmb   1
u00CB    rmb   1
u00CC    rmb   1
u00CD    rmb   1
u00CE    rmb   1
u00CF    rmb   1
u00D0    rmb   1
u00D1    rmb   1
u00D2    rmb   1
u00D3    rmb   1
u00D4    rmb   2
u00D6    rmb   2
u00D8    rmb   1
u00D9    rmb   1
u00DA    rmb   2
u00DC    rmb   1
u00DD    rmb   1
u00DE    rmb   34
u0100    rmb   $100       256 byte temporary buffer for various things
u0200    rmb   $100       ??? ($200-$2ff) built backwards 2 bytes/time
u0300    rmb   $100       BASIC09 stack area ($300-$3ff)
u0400    rmb   $100       List of module ptrs (modules in BASIC09 workspace)
u0500    rmb   $100       I-Code buffer (for running)
u0600    rmb   $1000-.    Default buffer for BASIC09 programs & data
dsize    equ   .

* Jump tables installed at $1b in DP: in form of JMP to (address of BASIC09's
* header in memory + 2 byte in table). In other words, jump to LXXXX
L000D    fdb   L00DC      $1b jump vector
         fdb   L1CA5      $1e jump vector
         fdb   L255A      $21 jump vector
         fdb   L31E8      $24 jump vector
         fdb   L3C09      $27 jump vector
         fdb   L5084      $2A jump vector
         fdb   $0000      End of jump vector table marker

B09NAME
 ifeq B09EXEC-true
  fcs   /Basic09/
         fcb   Edition
         fcb   $07
 else
  fcs   /RunB/
         fcb   Edition
         fcb   $06
 endc B09EXEC

* Intro screen

INTRO
 ifeq RESELLER-OTHER
   ifle EDITION-20
     fcc   'Copyright 1980 by Motorola, Inc.'
   else
     fcc   'Copyright 1980 by Motorola and Microware.'
   endc
     fcb   C$LF
   ifeq (EDITION-21)
     fcs   'Reproduced Under License'
   else
     fcs   'Reproduced Under License '
   endc
 else
       ifeq (RESELLER-TANDY)*(RESELLER-DRAGON)
         fcb   C$FORM   Clear screen on 32x16 display
         fcc   '            BASIC09'
         fcb   C$LF
       endc
       ifeq RESELLER-TANDY
         fcc   '      RS VERSION 01.00.00'
         fcb   C$LF
       endc
         fcc   'COPYRIGHT 1980 BY MOTOROLA INC.'
       ifeq (RESELLER-TANDY)*(RESELLER-DRAGON)
         fcb   C$LF
         fcb   C$SPAC
       endc
         fcc   ' AND MICROWARE SYSTEMS CORP.'
         fcb   C$LF
       ifeq (RESELLER-TANDY)*(RESELLER-DRAGON)
         fcc   '   REPRODUCED UNDER LICENSE'
         fcb   C$LF
       endc
       ifeq RESELLER-TANDY
         fcc   '       TO TANDY CORP.'
         fcb   C$LF
       endc
       ifeq RESELLER-DRAGON
         fcc   '     TO DRAGON DATA LTD.'
         fcb   C$LF
       endc
         fcc   '    ALL RIGHTS RESERVED.'
         fcb   $80+C$LF   Line feed
 endc
* Jump vector @ $1B goes here
L00DC    pshs  x,d        Preserve regs
         ldb   [<$04,s]   Get function offset
         leax  <L00EC,pc  Point to vector table
         ldd   b,x        Get return offset
         leax  d,x        Point to return address
         stx   $4,s       Change RTS address to it
         puls  d,x,pc     restore regs and return to new address

* Vector offsets for above routine ($1B vector)

L00EC    fdb   L0F91-L00EC Function 0
         fdb   L1287-L00EC Function 2   Print error message (B=Error code)
         fdb   L0899-L00EC Function 4
         fdb   L088F-L00EC Function 6
         fdb   L18BE-L00EC Function 8
         fdb   L0E73-L00EC Function A
         fdb   S.BYE-L00EC Function C
         fdb   L0E8F-L00EC Function E
         fdb   L1BA2-L00EC Function 10
 ifeq B09EXEC-true
         fdb   L12F9-L00EC Function 12
         fdb   L19B1-L00EC Function 14
         fdb   L110C-L00EC Function 16
         fdb   L1026-L00EC Function 18
         fdb   L10AC-L00EC Function 1A (Pointed to by <u0019 & <u0017)
         fdb   L10B1-L00EC Function 1C
 endc B09EXEC

J010A    jsr   <u001E
         fcb   $04
J010D    jsr   <u001E
         fcb   $02
J0110    jsr   <u001E
         fcb   $00
J0113    jsr   <u0021
         fcb   $00
J0116    jsr   <u0024
         fcb   $00
J0119    jsr   <u0024
         fcb   $04
J011C    jsr   <u0024
         fcb   $02
J011F    jsr   <u002A
         fcb   $02
 ifeq B09EXEC-true
L0122    jsr   <u001E
         fcb   $0A
L0125    jsr   <u001E
         fcb   $06
L0128    jsr   <u0021
         fcb   $02
L012B    jsr   <u0021
         fcb   $06
L012E    jsr   <u0021
         fcb   $04
         jsr   <u0024
         fcb   $0A
L0134    jsr   <u0024
         fcb   $0C
L0137    jsr   <u0024
         fcb   $08
L013A    jsr   <u002A
         fcb   $00

* token/command type & command list?
         fdb   114        # entries in table
         fcb   2          # bytes to start text

L0140    fdb   $0101
L0142    fcs   'PARAM'
         fdb   $0201
L0149    fcs   'TYPE'
         fdb   $0301
L014F    fcs   'DIM'
         fdb   $0401
L0154    fcs   'DATA'
         fdb   $0501
L015A    fcs   'STOP'
         fdb   $0601
L0160    fcs   'BYE'
         fdb   $0701
L0165    fcs   'TRON'
         fdb   $0801
L016B    fcs   'TROFF'
         fdb   $0901
L0172    fcs   'PAUSE'
         fdb   $0A01
L0179    fcs   'DEG'
         fdb   $0B01
L017E    fcs   'RAD'
         fdb   $0C01
L0183    fcs   'RETURN'
         fdb   $0D01
L018B    fcs   'LET'
         fdb   $0F01
L0190    fcs   'POKE'
         fdb   $1001
L0196    fcs   'IF'
         fdb   $1101
L019A    fcs   'ELSE'
         fdb   $1201
L01A0    fcs   'ENDIF'
         fdb   $1301
L01A7    fcs   'FOR'
         fdb   $1401
L01AC    fcs   'NEXT'
         fdb   $1501
L01B2    fcs   'WHILE'
         fdb   $1601
L01B9    fcs   'ENDWHILE'
         fdb   $1701
L01C3    fcs   'REPEAT'
         fdb   $1801
L01CB    fcs   'UNTIL'
         fdb   $1901
L01D2    fcs   'LOOP'
         fdb   $1A01
L01D8    fcs   'ENDLOOP'
         fdb   $1B01
L01E1    fcs   'EXITIF'
         fdb   $1C01
L01E9    fcs   'ENDEXIT'
         fdb   $1D01
L01F2    fcs   'ON'
         fdb   $1E01
L01F6    fcs   'ERROR'
         fdb   $1F01
L01FD    fcs   'GOTO'
         fdb   $2101
L0203    fcs   'GOSUB'
         fdb   $2301
L020A    fcs   'RUN'
         fdb   $2401
L020F    fcs   'KILL'
         fdb   $2501
L0215    fcs   'INPUT'
         fdb   $2601
L021C    fcs   'PRINT'
         fdb   $2701
L0223    fcs   'CHD'
         fdb   $2801
L0228    fcs   'CHX'
         fdb   $2901
L022D    fcs   'CREATE'
         fdb   $2A01
L0235    fcs   'OPEN'
         fdb   $2B01
L023B    fcs   'SEEK'
         fdb   $2C01
L0241    fcs   'READ'
         fdb   $2D01
L0247    fcs   'WRITE'
         fdb   $2E01
L024E    fcs   'GET'
         fdb   $2F01
L0253    fcs   'PUT'
         fdb   $3001
L0258    fcs   'CLOSE'
         fdb   $3101
L025F    fcs   'RESTORE'
         fdb   $3201
L0268    fcs   'DELETE'
         fdb   $3301
L0270    fcs   'CHAIN'
         fdb   $3401
L0277    fcs   'SHELL'
         fdb   $3501
L027E    fcs   'BASE'
         fdb   $3701
L0284    fcs   'REM'
         fdb   $3901
L0289    fcs   'END'
         fdb   $4003
L028E    fcs   'BYTE'
         fdb   $4103
L0294    fcs   'INTEGER'
         fdb   $4203
L029D    fcs   'REAL'
         fdb   $4303
L02A3    fcs   'BOOLEAN'
         fdb   $4403
L02AC    fcs   'STRING'
         fdb   $4503
L02B4    fcs   'THEN'
         fdb   $4603
L02BA    fcs   'TO'
         fdb   $4703
L02BE    fcs   'STEP'
         fdb   $4803
L02C4    fcs   'DO'
         fdb   $4903
L02C8    fcs   'USING'
         fdb   $3D03
L02CF    fcs   'PROCEDURE'
         fdb   $9204
L02DA    fcs   'ADDR'
         fdb   $9404
L02E0    fcs   'SIZE'
         fdb   $9604
L02E6    fcs   'POS'
         fdb   $9704
L02EB    fcs   'ERR'
         fdb   $9804
L02F0    fcs   'MOD'
         fdb   $9A04
L02F5    fcs   'RND'
         fdb   $9C04
L02FA    fcs   'SUBSTR'
         fdb   $9B04
L0302    fcs   'PI'
         fdb   $9F04
L0306    fcs   'SIN'
         fdb   $A004
L030B    fcs   'COS'
         fdb   $A104
L0310    fcs   'TAN'
         fdb   $A204
L0315    fcs   'ASN'
         fdb   $A304
L031A    fcs   'ACS'
         fdb   $A404
L031F    fcs   'ATN'
         fdb   $A504
L0324    fcs   'EXP'
         fdb   $A804
L0329    fcs   'LOG'
         fdb   $A904
L032E    fcs   'LOG10'
         fdb   $9D04
L0335    fcs   'SGN'
         fdb   $A604
L033A    fcs   'ABS'
         fdb   $AA04
L033F    fcs   'SQRT'
         fdb   $AA04
L0345    fcs   'SQR'
         fdb   $AC04
L034A    fcs   'INT'
         fdb   $AE04
L034F    fcs   'FIX'
         fdb   $B004
L0354    fcs   'FLOAT'
         fdb   $B204
L035B    fcs   'SQ'
         fdb   $B404
L035F    fcs   'PEEK'
         fdb   $B504
L0365    fcs   'LNOT'
         fdb   $B604
L036B    fcs   'VAL'
         fdb   $B704
L0370    fcs   'LEN'
         fdb   $B804
L0375    fcs   'ASC'
         fdb   $B904
L037A    fcs   'LAND'
         fdb   $BA04
L0380    fcs   'LOR'
         fdb   $BB04
L0385    fcs   'LXOR'
         fdb   $BC04
L038B    fcs   'TRUE'
         fdb   $BD04
L0391    fcs   'FALSE'
         fdb   $BE04
L0398    fcs   'EOF'
         fdb   $BF04
L039D    fcs   'TRIM$'
         fdb   $C004
L03A4    fcs   'MID$'
         fdb   $C104
L03AA    fcs   'LEFT$'
         fdb   $C204
L03B1    fcs   'RIGHT$'
         fdb   $C304
L03B9    fcs   'CHR$'
         fdb   $C404
L03BF    fcs   'STR$'
         fdb   $C604
L03C5    fcs   'DATE$'
         fdb   $C704
L03CC    fcs   'TAB'
         fdb   $CD05
L03D1    fcs   'NOT'
         fdb   $D005
L03D6    fcs   'AND'
         fdb   $D105
L03DB    fcs   'OR'
         fdb   $D205
L03DF    fcs   'XOR'
         fdb   $F703
L03E4    fcs   'UPDATE'
         fdb   $F803
L03EC    fcs   'EXEC'
         fdb   $F903
L03F2    fcs   'DIR'

* 3 byte packets used by <u001B calls - Function $12
* 1st byte is used for bit tests, bytes 2-3 are offset from 2nd byte (can be
*   jump address, others seem to be ptrs to text)
L03F5    fcb   $40        ???
         fdb   $0000

         fcb   $00        ???
         fdb   L0142-*    PARAM ($fd49)

         fcb   $00
         fdb   L0149-*    TYPE  ($fd4d)

         fcb   $00
         fdb   L014F-*    DIM   ($fd50)

         fcb   $00
         fdb   L0154-*    DATA  ($fd52)


         fcb   $00
         fdb   L015A-*    STOP  ($fd55)

         fcb   $00
         fdb   L0160-*    BYE   ($fd58)

         fcb   $00
         fdb   L0165-*    TRON  ($fd5a)

         fcb   $00
         fdb   L016B-*    TROFF ($fd5d)

         fcb   $00
         fdb   L0172-*    PAUSE ($fd61)

         fcb   $00
         fdb   L0179-*    DEG   ($fd65)

         fcb   $00
         fdb   L017E-*    RAD   ($fd67)

         fcb   $00
         fdb   L0183-*    RETURN ($fd69)

         fcb   $00
         fdb   L018B-*    LET    ($fd6e)

         fcb   $40        ???
         fdb   $0000

         fcb   $00
         fdb   L0190-*    POKE   ($fd6d)

         fcb   $00
         fdb   L0196-*    IF     ($fd70)

         fcb   $63
         fdb   L019A-*    ELSE   ($fd71)

         fcb   $02
         fdb   L01A0-*    ENDIF  ($fd74)

         fcb   $01
         fdb   L01A7-*    FOR    ($fd78)

         fcb   $22
         fdb   L1419-*    (something with NEXT in it) ($0fe7)

         fcb   $01
         fdb   L01B2-*    WHILE ($fd7d)

         fcb   $62
         fdb   L01B9-*    ENDWHILE ($fd81)

         fcb   $01
         fdb   L01C3-*    REPEAT ($fd88)

         fcb   $02
         fdb   L01CB-*    UNTIL ($fd8d)

         fcb   $01
         fdb   L01D2-*    LOOP ($fd91)

         fcb   $62
         fdb   L01D8-*    ENDLOOP ($fd94)

         fcb   $02
         fdb   L01E1-*    EXITIF ($fd9a)

         fcb   $63
         fdb   L01E9-*    ENDEXIT ($fd9f)

         fcb   $00
         fdb   L01F2-*    ON ($fda5)

         fcb   $00
         fdb   L01F6-*    ERROR ($fda6)

         fcb   $20
         fdb   L13C9-*    Point to something with GOTO ($0f76)

         fcb   $20
         fdb   L13C9-*    Point to something with GOTO ($0f73)

         fcb   $20
         fdb   L13C3-*    Point to something with GOSUB ($0f6a)

         fcb   $20
         fdb   L13C3-*    Point to something with GOSUB ($0f67)

         fcb   $20
         fdb   L140F-*    Point to something with RUN ($0fb0)

         fcb   $00
         fdb   L020F-*    KILL ($fdad)

         fcb   $00
         fdb   L0215-*    INPUT ($fdb0)

         fcb   $00
         fdb   L021C-*    PRINT ($fdb4)

         fcb   $00
         fdb   L0223-*    CHD ($fdb8)

         fcb   $00
         fdb   L0228-*    CHX ($fdba)

         fcb   $00
         fdb   L022D-*    CREATE ($fdbc)

         fcb   $00
         fdb   L0235-*    OPEN ($fdc1)

         fcb   $00
         fdb   L023B-*    SEEK ($fdc4)

         fcb   $00
         fdb   L0241-*    READ ($fdc7)

         fcb   $00
         fdb   L0247-*    WRITE ($fdca)

         fcb   $00
         fdb   L024E-*    GET ($fdce)

         fcb   $00
         fdb   L0253-*    PUT ($fdd0)

         fcb   $00
         fdb   L0258-*    CLOSE ($fdd2)

         fcb   $00
         fdb   L025F-*    RESTORE ($fdd6)

         fcb   $00
         fdb   L0268-*    DELETE ($fddc)

         fcb   $00
         fdb   L0270-*    CHAIN ($fde1)

         fcb   $00
         fdb   L0277-*    SHELL ($fde5)

         fcb   $20
         fdb   L1402-*    Points to something with BASE ($0f6d)

         fcb   $20
         fdb   L1402-*    Points to something with BASE ($0f6a)

         fcb   $20
         fdb   L143C-*    Points to something with REM ($0fa1)

         fcb   $20
         fdb   L1436-*    Points to something with (* ($0f98)

         fcb   $00
         fdb   L0289-*    END ($fde8)

         fcb   $20
         fdb   L13CF-*    ??? end of goto/gosub routine ($0f2b)

         fcb   $20
         fdb   L13CF-*    ??? end of goto/gosub routine ($0f28)

         fcb   $40        ???
         fdb   $0000

         fcb   $20
         fdb   L1443-*    ??? end of REM routine ($0f96)

         fcb   $40
         fcc   ' \'       Command statement separator literal

         fcb   $20
         fdb   L12D4-*    ??? ($0e21)

         fcb   $10
         fdb   L028E-*    BYTE ($fdd8)

         fcb   $10
         fdb   L0294-*    INTEGER ($fddb)

         fcb   $10
         fdb   L029D-*    REAL ($fde1)

         fcb   $10
         fdb   L02A3-*    BOOLEAN ($fde4)

         fcb   $10
         fdb   L02AC-*    STRING ($fdea)

         fcb   $20
         fdb   L1424-*    ??? Something that points to 'THEN' ($0f5f)

         fcb   $60
         fdb   L02BA-*    TO ($fdf2)

         fcb   $60
         fdb   L02BE-*    STEP ($fdf3)

         fcb   $00
         fdb   L02C4-*    DO ($fdf6)

         fcb   $00
         fdb   L02C8-*    USING ($fdf7)

         fcb   $20
         fdb   L145E-*    ??? Something with file access modes ($0f8a)

         fcb   $40
         fcc   ','        comma
         fcb   $00

         fcb   $40
         fcc   ':'        colon
         fcb   $00

         fcb   $40
         fcc   '('        Left parenthesis
         fcb   $00

         fcb   $40
         fcc   ')'        Right parenthesis
         fcb   $00

         fcb   $40
         fcc   '['        Left bracket
         fcb   $00

         fcb   $40
         fcc   ']'        Right bracket
         fcb   $00

         fcb   $40
         fcc   '; '       semi-colon with space

         fcb   $40
         fcc   ':='       := (pascal like equals)

         fcb   $40
         fcc   '='        Equals sign
         fcb   $00

         fcb   $40
         fcc   '#'        number sign
         fcb   $00

         fcb   $20
         fdb   L1AE1-*    ??? Bump Y up by 2 & return ($15ec)

* Guess: These following have to do with printing numeric values???
         fcb   $20
         fdb   L138A-*    ??? ($0E92)

         fcb   $20
         fdb   L138A-*    ??? ($0E8F)

         fcb   $20
         fdb   L138A-*    ??? ($0E8c)

         fcb   $20
         fdb   L138A-*    ??? ($0E89)

         fcb   $20
         fdb   L138A-*    ??? ($0E86)

         fcb   $20
         fdb   L138A-*    ??? ($0E83)

         fcb   $21
         fdb   L138A-*    ??? ($0E80)

         fcb   $22
         fdb   L138A-*    ??? ($0E7D)

         fcb   $23
         fdb   L138A-*    ??? ($0E7A)

         fcb   $20
         fdb   L1386-*    ??? (Appends period, does 138A routine) ($0E73)

         fcb   $21
         fdb   L1386-*    ??? (Appends period, does 138A routine) ($0E70)

         fcb   $22
         fdb   L1386-*    ??? (Appends period, does 138A routine) ($0E6d)

         fcb   $23
         fdb   L1386-*    ??? (Appends period, does 138A routine) ($0E6a)

         fcb   $26
         fdb   L13BE-*    ??? (print single byte numeric?) ($0E9f)

         fcb   $27
         fdb   L13CF-*    ??? (print 2 byte integer numeric?) ($0Ead)

         fcb   $24
         fdb   L13A0-*    ??? (possibly something with reals?) ($0E7b)

         fcb   $24
         fdb   L13E1-*    ??? (string, puts " in) ($0Eb9)

         fcb   $27
         fdb   L13F6-*    ??? (string, puts $ in) ($0Ecb)

         fcb   $11
         fdb   L02DA-*    ADDR ($FDac)

         fcb   $80        ???
         fdb   $0000

         fcb   $11
         fdb   L02E0-*    SIZE ($FDAC)

         fcb   $80
         fdb   $0000      ???

         fcb   $10
         fdb   L02E6-*    POS ($FDAC)

         fcb   $10
         fdb   L02EB-*    ERR ($FDAE)

         fcb   $12
         fdb   L02F0-*    MOD ($FDB0)

         fcb   $12
         fdb   L02F0-*    MOD ($FDAD)

         fcb   $11
         fdb   L02F5-*    RND ($FDAF)

         fcb   $10
         fdb   L0302-*    PI ($FDB9)

         fcb   $12
         fdb   L02FA-*    SUBSTR ($FDAE)

         fcb   $11
         fdb   L0335-*    SGN ($FDE6)

         fcb   $11
         fdb   L0335-*    SGN ($FDE3)

         fcb   $11
         fdb   L0306-*    SIN ($FDB1)

         fcb   $11
         fdb   L030B-*    COS ($FDB3)

         fcb   $11
         fdb   L0310-*    TAN ($FDB5)

         fcb   $11
         fdb   L0315-*    ASN ($FDB7)

         fcb   $11
         fdb   L031A-*    ACS ($FDB9)

         fcb   $11
         fdb   L031F-*    ATN ($FDbb)

         fcb   $11
         fdb   L0324-*    EXP ($FDBD)

         fcb   $11
         fdb   L033A-*    ABS ($FDD0)

         fcb   $11
         fdb   L033A-*    ABS ($FDCD)

         fcb   $11
         fdb   L0329-*    LOG ($FDB9)

         fcb   $11
         fdb   L032E-*    LOG10 ($FDBB)

         fcb   $11
         fdb   L033F-*    SQRT ($FDC9)

         fcb   $11
         fdb   L033F-*    SQRT ($FDC6)

         fcb   $11
         fdb   L034A-*    INT ($FDCE)

         fcb   $11
         fdb   L034A-*    INT ($FDCB)

         fcb   $11
         fdb   L034F-*    FIX ($FDCD)

         fcb   $11
         fdb   L034F-*    FIX ($FDCA)

         fcb   $11
         fdb   L0354-*    FLOAT ($FDCC)

         fcb   $11
         fdb   L0354-*    FLOAT ($FDC9)

         fcb   $11
         fdb   L035B-*    SQ ($FDCD)

         fcb   $11
         fdb   L035B-*    SQ ($FDCA)

         fcb   $11
         fdb   L035F-*    PEEK ($FDCB)

         fcb   $11
         fdb   L0365-*    LNOT ($FDCE)

         fcb   $11
         fdb   L036B-*    VAL ($FDD1)

         fcb   $11
         fdb   L0370-*    LEN ($FDD3)

         fcb   $11
         fdb   L0375-*    ASC ($FDD5)

         fcb   $12
         fdb   L037A-*    LAND ($FDD7)

         fcb   $12
         fdb   L0380-*    LOR ($FDDA)

         fcb   $12
         fdb   L0385-*    LXOR ($FDDC)

         fcb   $10
         fdb   L038B-*    TRUE ($FDDF)

         fcb   $10
         fdb   L0391-*    FALSE ($FDE2)

         fcb   $11
         fdb   L0398-*    EOF ($FDE6)

         fcb   $11
         fdb   L039D-*    TRIM$ ($FDE8)

         fcb   $13
         fdb   L03A4-*    MID$ ($FDEC)

         fcb   $12
         fdb   L03AA-*    LEFT$ ($FDEF)

         fcb   $12
         fdb   L03B1-*    RIGHT$ ($FDF3)

         fcb   $11
         fdb   L03B9-*    CHR$ ($FDF8)

         fcb   $11
         fdb   L03BF-*    STR$ ($FDFB)

         fcb   $11
         fdb   L03BF-*    STR$ ($FDF8)

         fcb   $10
         fdb   L03C5-*    DATE$ ($FDFB)

         fcb   $11
         fdb   L03CC-*    TAB ($FDFF)

         fcb   $80
         fdb   $0000

         fcb   $80
         fdb   $0000

         fcb   $80
         fdb   $0000

         fcb   $80
         fdb   $0000

         fcb   $80
         fdb   $0000

         fcb   $11
         fdb   L03D1-*    NOT ($FDF2)

         fcb   $51
         fcc   '-'        ??? (Sign as opposed to subtract?)
         fcb   $00

         fcb   $51
         fcc   '-'        ??? (Sign as opposed to subtract?)
         fcb   $00

         fcb   $0A
         fdb   L03D6-*    AND ($FDEE)

         fcb   $09
         fdb   L03DB-*    OR ($FDF0)

         fcb   $09
         fdb   L03DF-*    XOR ($FDF1)

* Would presume that the different duplicates are for different data types
* It appears that BYTE & INTEGER use the same routines, REAL is different,
* STRING/TYPE use a third, and BOOLEAN would be a rarely used 4th
* Order appears to be : REAL/(INTEGER or BYTE)/STRING/BOOLEAN
* 3 - real/integer/string

         fcb   $4B
         fcc   '>'        greater than
         fcb   $00

         fcb   $4B
         fcc   '>'        greater than
         fcb   $00

         fcb   $4B
         fcc   '>'        greater than
         fcb   $00

* 3 - real/integer/string
         fcb   $4B
         fcc   '<'        less than
         fcb   $00

         fcb   $4B
         fcc   '<'        less than
         fcb   $00

         fcb   $4B
         fcc   '<'        less than
         fcb   $00

* 4 - real/integer/string/boolean
         fcb   $4B
         fcc   '<>'       not equal to

         fcb   $4B
         fcc   '<>'       not equal to

         fcb   $4B
         fcc   '<>'       not equal to

         fcb   $4B
         fcc   '<>'       not equal to

* 4 - real/integer/string/boolean
         fcb   $4B
         fcc   '='        equal to
         fcb   $00

         fcb   $4B
         fcc   '='        equal to
         fcb   $00

         fcb   $4B
         fcc   '='        equal to
         fcb   $00

         fcb   $4B
         fcc   '='        equal to
         fcb   $00

* 3 - real/integer/string
         fcb   $4B
         fcc   '>='       greater than or equal to

         fcb   $4B
         fcc   '>='       greater than or equal to

         fcb   $4B
         fcc   '>='       greater than or equal to

* 3 - real/integer/string
         fcb   $4B
         fcc   '<='       less than or equal to

         fcb   $4B
         fcc   '<='       less than or equal to

         fcb   $4B
         fcc   '<='       less than or equal to

* 3 - real/integer/string
         fcb   $4C
         fcc   '+'        plus
         fcb   $00

         fcb   $4C
         fcc   '+'        plus
         fcb   $00

         fcb   $4C
         fcc   '+'        plus
         fcb   $00

* 2 - real/integer
         fcb   $4C
         fcc   '-'        minus
         fcb   $00

         fcb   $4C
         fcc   '-'        minus
         fcb   $00

* 2 - real/integer
         fcb   $4D
         fcc   '*'        multiply
         fcb   $00

         fcb   $4D
         fcc   '*'        multiply
         fcb   $00

* 2 - real/integer
         fcb   $4D
         fcc   '/'        divide
         fcb   $00

         fcb   $4D
         fcc   '/'        divide
         fcb   $00

* 1 - real
         fcb   $4E
         fcc   '^'        exponent
         fcb   $00

* 1 - real
         fcb   $4E
         fcc   '**'       exponent (2nd version)

         fcb   $20
         fdb   L138A-*    ??? ($0D3c)

         fcb   $21
         fdb   L138A-*    ??? ($0D39)

         fcb   $22
         fdb   L138A-*    ??? ($0D36)

         fcb   $23
         fdb   L138A-*    ??? ($0D33)

         fcb   $20
         fdb   L1386-*    ??? (Adds period, does 138A) ($0D2C)

         fcb   $21
         fdb   L1386-*    ??? (Adds period, does 138A) ($0D29)

         fcb   $22
         fdb   L1386-*    ??? (Add period, does 138A) ($0D26)

         fcb   $23
         fdb   L1386-*    ??? (Add period, does 138A) ($0D23)

* System Mode commands
         fdb   2          # commands this table
         fcb   2          # bytes to first command string
L0668    fdb   L09F9-L0668
         fcs   '$'
L066B    fdb   L094F-L066B
         fcb   C$CR+$80   (Carriage return)

         fdb   14         # commands this table
         fcb   2          # bytes to first command string
L0671    fdb   S.BYE-L0671
         fcs   'BYE'
L0676    fdb   S.DIR-L0676
         fcs   'DIR'
L067B    fdb   S.EDIT-L067B
         fcs   'EDIT'
L0681    fdb   S.EDIT-L0681
         fcs   'E'
L0684    fdb   S.LIST-L0684
         fcs   'LIST'
L068A    fdb   S.RUN-L068A
         fcs   'RUN'
L068F    fdb   S.KILL-L068F
         fcs   'KILL'
L0695    fdb   S.SAVE-L0695
         fcs   'SAVE'
L069B    fdb   S.LOAD-L069B
         fcs   'LOAD'
L06A1    fdb   S.RENAME-L06A1
         fcs   'RENAME'
L06A9    fdb   S.PACK-L06A9
         fcs   'PACK'
L06AF    fdb   S.MEM-L06AF
         fcs   'MEM'
L06B4    fdb   S.CHD-L06B4
         fcs   'CHD'
L06B9    fdb   C.CHX-L06B9
         fcs   'CHX'

* Debug mode commands (offsets done by current base + offset)
         fdb   2          # of entries this table (-3,x)
         fcb   2          # of bytes to start of next entry (-1,x)
L06C1    fdb   L09F9-L06C1 base ptr goes here (0,x)
         fcs   '$'        base ptr+(-1,x) above points here
L06C4    fdb   L108B-L06C4
         fcb   C$CR+$80   (Carriage return)

L06C7    fdb   14         # of entries this table (but 13?)
         fcb   2          # bytes to next entry
* Debug set #2?
L06CA    fdb   L109A-L06CA
         fcs   'CONT'
L06D0    fdb   S.DIR-L06D0
         fcs   'DIR'
L06D5    fdb   L1068-L06D5
         fcs   'Q'
L06D8    fdb   L10E4-L06D8
         fcs   'LIST'
L06DE    fdb   L1195-L06DE
         fcs   'PRINT'
L06E5    fdb   L120A-L06E5
         fcs   'STATE'
L06EC    fdb   L1195-L06EC
         fcs   'TRON'
L06F2    fdb   L1195-L06F2
         fcs   'TROFF'
L06F9    fdb   L1195-L06F9
         fcs   'DEG'
L06FE    fdb   L1195-L06FE
         fcs   'RAD'
L0703    fdb   L1195-L0703
         fcs   'LET'
L0708    fdb   L107C-L0708
         fcs   'STEP'
L070E    fdb   L1226-L070E
         fcs   'BREAK'
* Some edit mode stuff?
         fdb   8          # entries this table
         fcb   2          # bytes to start entry
L0718    fdb   E.LIST-L0718
         fcs   'L'
L071B    fdb   E.LIST-L071B
         fcs   'l'
L071E    fdb   E.DELETE-L071E
         fcs   'D'
L0721    fdb   E.DELETE-L0721
         fcs   'd'
L0724    fdb   E.MOVE-L0724
         fcs   '+'
L0727    fdb   E.MOVE-L0727
         fcs   '-'
L072A    fdb   E.MOVE-L072A
         fcb   C$CR+$80
L072D    fdb   L1601-L072D
         fcb   C$SPAC+$80

         fdb   4          # entries
         fcb   2          # bytes to first entry
L0733    fdb   L175B-L0733
         fcs   'S'
L0736    fdb   L175E-L0736
         fcs   'C'
L0739    fdb   L18DF-L0739
         fcs   'R'
L073C    fdb   L1993-L073C
         fcs   'Q'

 endc B09EXEC
L073F
         ifeq (RESELLER-TANDY)*(RESELLER-DRAGON)
         fcb   $0E    Control code to display alpha
         endc
*        ifeq RESELLER-OTHER
*        fcb   C$CR
*        endc
         fcs   'Ready'
L0745    fcs   'What?'
L074A    fcs   ' free'
L074F    fcs   'Program'
   ifle EDITION-20
L0756    fcs   'Procedure'
   else
L0756    fcs   'PROCEDURE'
   endc
         fcb   C$CR
L0760    fcb   C$LF
         fcs   '  Name      Proc-Size  Data-Size'
L0781    fcc   'Rewrite?: '
L078B    fcc   "RANGE"
         fcb   $87
L0791
         ifeq (RESELLER-TANDY)*(RESELLER-DRAGON)
         fcb   $0E    Control code to display alpha
         endc
*        ifeq RESELLER-OTHER
*        fcb   C$CR
*        endc
         fcs   'BREAK: '
L0799    fcs   'called by'
L07A2    fcs   'ok'
L07A4    fcs   'D:'
L07A6    fcs   'E:'
L07A8    fcs   'B:'
L07AA    fcs   "can't find:"

* F$Icpt routine
L07B5    lda   R$DP,s     Get DP register from stack
         tfr   a,dp       Put into real DP
         stb   <u0035     Save signal code
         lsl   <u0034     Set high bit (flag signal was received)
         coma
         ror   <u0034
         rti              Return to normal BASIC09

* BASIC09 INIT
start    equ *
 ifle EDITION-20
         tfr   u,d

 else
         pshs  u                        save start of data mem into D
         leau  256,u                    point to end of DP
         clra                           clear all of DP to $00
         clrb
L07C9    std   ,--u
         cmpu  ,s
         bhi   L07C9
         puls  b,a                      get start of data mem into D
 endc
         leau  ,x                       point U to start of parameter area
         std   <membase                 preserve start of data memory ptr
         inca                           point to $100 in data area
         sta   <u00D9                   preserve it
         std   <u0080                   initialize ptr to start of temp buffer
         std   <u0082                   initialize current pos. in temp buffer
         adda  #$02
         std   <u0046
         std   <u0044
         inca
         tfr   d,s
         std   <moddir
         inca
         std   <restop
         std   <u004A
         tfr   u,d
         subd  <membase
         std   <memsize
         clra
 ifle EDITION-20
         clrb  
         std   <u000A
         std   <pgmaddr
         incb  
 else
         ldb   #$01             default err path
 endc
         std   <u002D
         sta   <u00BD
         lda   #$03             close paths 4-16
L07FC    os9   I$Close
         inca
         cmpa  #16       Do until 3-15 are closed
         bcs   L07FC
         lda   #$02
         os9   I$Dup
         sta   <u00BE     Preserve duplicate's path #
         clr   <u0035
         pshs  x
         leax  <L07B5,pcr
         os9   F$Icpt
         ldx   <restop
         clra
         clrb
L0819    std   ,--x
         cmpx  <moddir
         bhi   L0819
 ifle EDITION-20
         clr   <u00DD
 endc
         leax  >L0000,pc Point to beginning of module header
         pshs  x
         ldx   <membase
* Set up some JMP tables from the module header
         leax  <$1B,x     Point $1b bytes into it
         leay  >L000D,pc  Point to module header extensions
L082E    lda   #$7E
         sta   ,x+
         ldd   ,y++
         addd  ,s
         std   ,x++
         ldd   ,y
         bne   L082E
         leas  $02,s
         lbsr  J0116
         puls  y

 ifeq B09EXEC-true
         leax  >L0140,pcr
         stx   <u009E
         ldb   ,y
         cmpb  #$0D
         beq   L08A6
         leax  <L0860,pcr
         pshs  y
         bsr   L0870
         lbsr  L0F91
         bcc   L088F
         lbsr  S.LOAD
         bra   L088F
L0860    puls  y
 endc B09EXEC
         bsr   L086D
         ldx   <moddir
         ldd   ,x
         std   <pgmaddr
         lbsr  S.RUN
L086D    leax  <L08B2,pcr
L0870    puls  u
         bsr   L0899
         pshs  u
         clr   <u0034
         ldd   <membase
         addd  <memsize
         subd  <restop
         subd  <u000A
         std   <FREEMEM
         leau  $02,s
         stu   <u0046
         stu   <u0044
         leas  >-$00FE,s
         jmp   [<-2,u]
L088F    lds   <u00B7
         puls  b,a
         std   <u00B7
L0896    lbra  L0DBB
L0899    ldd   <u00B7
         pshs  b,a
         sts   <u00B7
         ldd   $02,s
         stx   $02,s
         tfr   d,pc
 ifeq B09EXEC-true
L08A6    leax  >INTRO,pcr
         bsr   L08D0
         leax  >B09NAME,pcr
         bsr   L08D0
 endc
L08B2    bsr   L086D
 ifeq B09EXEC-true
         leax  >L073F,pcr
         bsr   L08D0
         leax  >L07A8,pcr
         leay  >L0668,pcr
         clr   <u0084
         bsr   L08D3
         bcc   L088F
         bsr   L08CC
         bra   L088F
L08CC    leax  >L0745,pcr
L08D0    lbra  L125F
L08D3    pshs  y,x
         clr   <u0035
         lbsr  L126B
         bsr   L0896
         lda   <u00BD
         beq   L08E3
         os9   I$Close
L08E3    clr   <u00BD
         lbsr  L0B2D
         bcc   L08F8
         cmpb  #$D3
         bne   L0915
         ldd   #$6279
         std   ,y
         ldd   #$650D
         std   $02,y
L08F8    ldx   $02,s
         lda   #$80
         lbsr  J010A
         bne   L090F
         lbsr  J010D
         beq   L0915
         leax  $03,x
         lda   #$20
         lbsr  J010A
         beq   L0915
L090F    ldd   ,x
         leas  $04,s
         jmp   d,x
L0915    coma
         puls  pc,y,x

* MEM command
S.MEM    lbsr  L0A90  Get next non-space char
         bne   L093C
         leax  ,y
         ldd   <restop
         addd  <u000A
         inca
         subd  <membase
         pshs  b,a
         lbsr  L1748
         bcs   L0946
         cmpd  ,s++
         bcs   L0948
         os9   F$Mem
         bcs   L093C
         subd  #$0001
         std   <memsize
L093C    lbsr  L0DBB
         ldd   <memsize
         bsr   L09BA
L0943    lbra  L1264
L0946    leas  $02,s
L0948    coma
         rts

* Debug & System mode - DIR
S.DIR    leax  ,y
         lbsr  L0D5F
* System mode - <CR>
L094F    leax  >L0760,pc  Point to basic09 DIR header
         lbsr  L125F
         ldy   <moddir
         bra   L099B
L095B    pshs  y,x
         lda   #$20
         tst   $06,x
         beq   L0965
         lda   #$2D
L0965    lbsr  OUTCHAR
         lda   #$20
         cmpx  <pgmaddr
         bne   L0970
         lda   #$2A
L0970    lbsr  OUTCHAR
         ldd   $04,x
         leax  d,x
         lbsr  L135A
         ldd   #$1102
         bsr   L09AD
         ldd   #$1C0B
         bsr   L09AD
         ldd   $0B,x
         addd  #$0040
         cmpd  <FREEMEM
         bcs   L0993
         lda   #$3F
         lbsr  OUTCHAR
L0993    bsr   L0943
         puls  y,x
         tst   <u0035
         bne   L099F
L099B    ldx   ,y++
         bne   L095B
L099F    ldd   <FREEMEM
         bsr   L09BA
         leax  >L074A,pcr
         lbsr  L1261
         lbra  L0D51

L09AD    pshs  b
         ldb   #$10
         lbsr  J011F
         puls  b
         ldx   $02,s
         ldd   b,x
L09BA    pshs  y,x,b,a
         pshs  b,a
         leay  <L09ED,pcr
L09C1    ldx   #$2F00
L09C4    puls  b,a
L09C6    leax  >$0100,x
         subd  ,y
         bcc   L09C6
         addd  ,y++
         pshs  b,a
         ldd   ,y
         tfr   x,d
         beq   L09E6
         cmpd  #$3000
         beq   L09C1
         lbsr  OUTCHAR
         ldx   #$2F01
         bra   L09C4
L09E6    lbsr  OUTCHAR
         leas  $02,s
         puls  pc,y,x,b,a

* Table of decimal values
L09ED    fdb   $2710      10000
         fdb   $03E8      1000
         fdb   $0064      100
         fdb   $000A      10
         fdb   $0001      1
         fdb   $0000      0

* Debug/System '$' goes here
* Entry: Y=Ptr to line typed in by user?
L09F9    lbsr  L0A90      Go check char @ Y for space or comma
         leau  ,y         Point to start of parameter area
         clrb             Current size of parameter area=0
L09FF    incb
         lda   ,y+
         cmpa  #$0D
         bne   L09FF
         clra
         tfr   d,y
         leax  >L0277,pcr
         lda   #$01
         clrb
         os9   F$Fork
         bcs   L0A86
         pshs  a
L0A17    os9   F$Wait
         cmpa  ,s
         bne   L0A17
         leas  $01,s
         tstb
         bne   L0A86
         rts

* CHD command
S.CHD    lda   #DIR.+UPDAT.
         bra   L0A2A

* CHX command
C.CHX    lda   #DIR.+EXEC.
L0A2A    leax  ,y
         os9   I$ChgDir
         bcs   L0A86
         rts

S.RENAME    bsr   L0A9D
         lbsr  L0F6E
         bcs   L0A8C
         pshs  x
         ldx   ,x
         tst   $06,x
         bne   L0A8C
         bsr   L0A90  Get next non-space char
         beq   L0A48
L0A45    comb
         puls  pc,x
L0A48    lbsr  J010D
         beq   L0A45
         pshs  y
         lbsr  L0F6E
         bcs   L0A58
         cmpx  $02,s
         bne   L0A84
L0A58    ldx   $02,s
         lbsr  L1A2E
         puls  x
         ldy   <u004A
L0A62    lda   ,x+
         sta   ,y+
         bpl   L0A62
         sty   <u00AB
         ldx   [,s++]
         ldd   $04,x
         leay  d,x
         ldb   <$18,x
         lda   <u00A6
         sta   <$18,x
         clra
         lbsr  L19B1
         addd  <u005E
         std   <u005E
L0A81    lbra  L1995
 else
         lbra  S.BYE
 endc B09EXEC

L0A84    ldb   #$2C       Multiply-defined procedure error
* Error
L0A86    lbsr  L1287
L0A89    lbra  L088F

L0A8C    ldb   #$2B       Unknown procedure error
         bra   L0A86

* Entry: Y=Ptr to string of chars?
* Exit:  Y=Ptr to char (or up 1 char if space/comma found)
*        B=Char found
L0A90    ldb   ,y+        Get char
         cmpb  #',
         beq   L0A9C
         cmpb  #C$SPAC
         beq   L0A9C
         leay  -$01,y
L0A9C    rts

L0A9D    lbsr  J010D
         bne   L0AB0
L0AA2    ldy   <pgmaddr
         beq   L0AAC
         ldd   $04,y
         leay  d,y
         rts
L0AAC    leay  >L074F,pcr
L0AB0    rts

  ifeq B09EXEC-true
L0AB1    ldb   #$2B       Unknown procedure error
         bra   L0ABD
L0AB5    ldb   #$20       Memory full error
L0AB7    pshs  b
         bsr   L0A81
         puls  b
L0ABD    cmpb  #E$EOF     End of file error?
         beq   L0A89
         bra   L0A86
S.LOAD    leax  ,y
         lda   #$01
         os9   I$Open
         bcs   L0ABD
         sta   <u00BD
         bsr   L0B2D
         bsr   L0B3C
         bne   L0AB1
L0AD4    lbsr  J010D
         beq   L0AB1
         pshs  y
         lbsr  L0F6E
         bcs   L0AE8
         ldy   ,s
         leay  -$01,y
         lbsr  S.KILL
L0AE8    ldy   ,s
         lbsr  L0EFD
         lbsr  L1A2E
         puls  x
         lbsr  L125F
L0AF6    ldb   <u0035
         bne   L0AB7
         bsr   L0B2D
         bcs   L0AB7
         lda   <FREEMEM
         cmpa  #$02
         bcs   L0AB5
         bsr   L0B3C
         beq   L0B14
         ldy   <u0080
         ldd   <u0060
         std   <u005C
         lbsr  L1606
         bra   L0AF6
L0B14    ldx   <u0080
         pshs  y,x
L0B18    lda   ,x+
         cmpa  #$0D
         bne   L0B18
         stx   <u0080
         stx   <u0082
         lbsr  L0128
         puls  y,x
         stx   <u0080
         stx   <u0082
         bra   L0AD4
L0B2D    lda   <u00BD
         ldx   <u0080
         ldy   #$0100
         os9   I$ReadLn
         ldy   <u0080
         rts
L0B3C    lbsr  J010D
         leax  >L0756,pcr
L0B43    lda   ,x+
         eora  ,y+
         anda  #$DF
         bne   L0B50
         tst   -$01,x
         bpl   L0B43
         clra
L0B50    rts

* Pack command
S.PACK    lbsr  L0C83
         ldu   <u0046
         bra   L0B79
L0B58    ldy   ,y
         tst   6,y
         lbne  L0E68
         lda   <$17,y
         rora
         lbcs  L0E68
         ldd   $0D,y
         leay  d,y
         ldd   -$03,y
         lslb
         rola
         inca
         cmpd  <FREEMEM
         lbhi  L0F69
L0B79    ldy   ,--u
         bne   L0B58
         ldd   #$0607
         lbsr  L0D6B
         ldy   <u0046
         stu   <u0046
         lbra  L0C7A
L0B8C    pshs  y
         lbsr  L1A2E
         clr   <u00D9
         lbsr  L0128
         inc   <u00D9
         ldx   <u0062
         leay  ,x
         ldd   <membase
         addd  <memsize
         tfr   d,u
         ldd   -$03,x
         beq   L0C18
         pshs  u
L0BA8    pshs  b,a
         leax  $01,x
         ldd   ,x
         pshu  b,a
         clr   ,x+
         clr   ,x+
L0BB4    lda   ,x+
         bpl   L0BB4
         puls  b,a
         subd  #$0001
         bne   L0BA8
         ldy   <u005E
         bra   L0BD1
L0BC4    ldd   ,y
         ldx   <u0062
         leax  d,x
         ldd   $01,x
         sty   $01,x
         std   ,y++
L0BD1    lbsr  L1BC2
         bcc   L0BC4
         puls  u
         ldx   <u0062
         ldd   -$03,x
         leay  ,x
L0BDE    leau  -2,u
         pshs  u,b,a
         clra
         ldu   $01,x
         beq   L0C04
         pshs  x
         tfr   y,d
         subd  <u0062
         bra   L0BF3
L0BEF    std   ,u
         leau  ,x
L0BF3    ldx   ,u
         bne   L0BEF
         std   ,u
         puls  x
         lda   ,x
         sta   ,y+
         ldu   [<$02,s]
         stu   ,y++
L0C04    leax  $03,x
L0C06    ldb   ,x+
         cmpa  #$A0
         bne   L0C0E
         stb   ,y+
L0C0E    tstb
         bpl   L0C06
         puls  u,b,a
         subd  #$0001
         bne   L0BDE
L0C18    ldx   <pgmaddr
         ldd   $02,x
         pshs  b,a
         clr   ,y+
         clr   ,y+
         clr   ,y+
         tfr   y,d
         subd  <pgmaddr
         std   $02,x
         ldd   ,s
         subd  $02,x
         std   ,s
         addd  <FREEMEM
         std   <FREEMEM
         ldd   <u000A
         subd  ,s++
         std   <u000A
         addd  <restop
         std   <u004A
         ldb   #$22
         stb   $06,x
         ldb   #$80
         stb   <$17,x
         leau  ,y
         ldd   #$FFFF
         std   ,--u
         sta   ,-u
         ldb   #$07
L0C52    eora  b,x
         decb
         bpl   L0C52
         sta   $08,x
         ldy   $02,x
         leay  -$03,y
         os9   F$CRC
         com   ,u+
         com   ,u+
         com   ,u+
         ldy   $02,x
         lda   #$02
         os9   I$Write
         lda   #$C0
         sta   <$17,x
         lbcs  L0DB6
         puls  y
L0C7A    ldx   ,--y
         lbne  L0B8C
         lbra  L0D51
L0C83    bsr   L0C9D
         lda   ,y
         cmpa  #$0D
         bne   L0C9A
         ldx   <u0046
         ldx   [<-$02,x]
         ldd   $04,x
         leax  d,x
         lbsr  L135A
         lbsr  L12CF
L0C9A    leax  ,y
         rts
 endc

L0C9D    ldu   <u0046
         stu   <u0044
  ifeq B09EXEC-true
         lbsr  L0A90 Get next non-space char
         beq   L0CC6
         cmpb  #'*
         bne   L0CCB
  endc
         ldx   <moddir
L0CAC    ldd   ,x
         beq   L0CB4
         tfr   x,d
         leax  $02,x
L0CB4    std   ,--u
         bne   L0CAC
         stu   <u0044
         lda   ,y
         cmpa  #$0D
         beq   L0CC2
         leay  $01,y
L0CC2    sty   <u0082
         rts

  ifeq B09EXEC-true
L0CC6    lbsr  J010D
         bne   L0CD9
L0CCB    sty   <u0082
         lbsr  L0AA2
         lbsr  L0F6E
         bcc   L0CE1
L0CD6    lbra  L0A8C
L0CD9    lbsr  L0F6E
         bcs   L0CD6
         sty   <u0082
L0CE1    stx   ,--u
         ldy   <u0082
         lbsr  L0A90  Get next non-space char
         bne   L0CF0
         lbsr  J010D
         bne   L0CD9
L0CF0    clra
         clrb
         bra   L0CB4

* Save command
S.SAVE    tst   <FREEMEM
         lbeq  L0F69
         lda   #$80
         sta   <u0084
         bsr   L0C83
         bra   L0D06

S.LIST    bsr   L0C9D
         leax  ,y
L0D06    stx   <u005C
         bsr   L0D5F
         ldy   <u0046
         stu   <u0046
         bra   L0D49
L0D11    pshs  y
         ldy   [,y]
         sty   <pgmaddr
         ldd   $09,y
         addd  <pgmaddr
         std   <u005E
         ldd   $0F,y
         addd  <pgmaddr
         std   <u0060
         ldd   $0D,y
         addd  <pgmaddr
         std   <u0062
         tst   6,y
         bne   L0D47
         leax  <L0D3B,pcr
         lbsr  L0899
         lbsr  L10E4
L0D38    lbra  L088F
L0D3B    tst   <u0084
         bmi   L0D47
         ldx   [,s]
         lbsr  L1A2E
         lbsr  L0128
L0D47    puls  y
L0D49    ldx   ,--y
         bne   L0D11
L0D4D    bsr   L0D51
         bra   L0D38

L0D51    pshs  b
         lda   #$02
         os9   I$Close
         lda   <u00BE
         os9   I$Dup
         puls  pc,b
L0D5F    lbsr  L0A90  Get next non-space char
         cmpb  #$0D
         beq   L0DB5
         stx   <u0082
         ldd   #$020B
L0D6B    pshs  u,x,b,a
         lda   #$02
         os9   I$Close
         ldd   ,s
         os9   I$Create
         bcc   L0DB3
         cmpb  #$DA
         bne   L0DB6
         ldd   ,s
         ldx   $02,s
         os9   I$Open
         bcs   L0DB6
         leax  >L0781,pcr
         ldy   #$000A
         lda   <u00BE
         os9   I$WritLn
         clra
         leax  ,--s
         ldy   #$0002
         os9   I$ReadLn
         puls  b,a
         eora  #$59
         anda  #$DF
         bne   L0D4D
         lda   #$02
         ldb   #$02
         ldx   #$0000
         leau  ,x
         os9   I$SetStt
         bcs   L0DB6
L0DB3    puls  pc,u,y,b,a
L0DB5    rts
L0DB6    bsr   L0D51
         lbra  L0A86
 endc B09EXEC

L0DBB    clr   <u007D
         inc   <u007D
         pshs  x
         ldx   <u0080
         stx   <u0082
         puls  pc,x

S.RUN    lbsr  J010D
         bne   L0DDF
         pshs  y
         lbsr  L0A9D
         ldx   ,s
L0DD3    lda   ,y+
         sta   ,x+
         bpl   L0DD3
         lda   #$0D
         sta   ,x
         puls  y
L0DDF    lbsr  L0F91
         lbcs  L0A8C
         ldx   ,x
         stx   <pgmaddr
         lda   $06,x
         beq   L0DF6
         anda  #$0F
         cmpa  #$02             Basic09 program?
         bne   L0E68
         bra   L0DFC

L0DF6    lda   <$17,x           Basic09 program has no errors?
         rora
         bcs   L0E68            errors, report it
L0DFC    lbsr  J0110            check param list
         ldy   <u004A
         ldb   ,y
         cmpb  #$3D
         beq   L0E68
         sty   <u005E
         sty   <u005C
         ldx   <u00AB
         stx   <u0060
         stx   <u004A
         ldd   <FREEMEM
         pshs  y,b,a
         lbsr  J0113
         puls  y,b,a
         std   <FREEMEM
         sty   <u004A
         ldx   <pgmaddr
         lda   <$17,x
         rora
         bcs   L0E68
         leas  >$0102,s
         ldd   <membase
         addd  <memsize
         tfr   d,y
         std   <u0046
         std   <u0044
         ldu   #$0000
         stu   <u0031
         stu   <u00B3
         inc   <u00B4
         clr   <errcode
         ldd   <u004A
         ldx   <FREEMEM
         pshs  x,b,a
         leax  >L0E5F,pcr
         lbsr  L0899
         ldx   <u004A
         lbsr  J0119
         lbsr  L0DBB
         ldx   <pgmaddr
         lbsr  J011C
         bra   L0E65
L0E5F    puls  x,b,a
         std   <u004A
         stx   <FREEMEM
L0E65    lbra  L088F

L0E68    ldb   #E$LnComp  Line with compiler error
         lbra  L0A86      Go report it

* System mode - BYE
S.BYE    bsr   L0E8F
         clrb             Exit without error
         os9   F$Exit

L0E73    lbsr  J010D
         beq   L0E8B
         lbsr  L0F6E
         bcs   L0E8B
         ldu   <u0046
         clra
         clrb
         pshu  x,b,a
         inca
         sta   <u0035
         bsr   L0E9F
         clr   <u0035
         rts

L0E8B    comb
         ldb   #E$UnkPrc
         rts

L0E8F    ldy   <u0082
         lda   #$2A
         sta   ,y
         sta   <u0035
S.KILL   lbsr  L0C9D
         clr   <pgmaddr
         clr   <u0030
L0E9F    ldu   <u0046
         stu   <u0044
         bra   L0EE3
L0EA5    ldx   ,x
 ifeq B09EXEC-true
         ldb   $06,x
         beq   L0EC0
         cmpb  #$22
         bne   L0EB5
         ldb   <$17,x
         lslb
         bmi   L0EC0
  endc B09EXEC
L0EB5    pshs  u
         leau  ,x
         os9   F$UnLink
         puls  u
 ifeq B09EXEC-true
         bra   L0EDE
L0EC0    tst   <u0035
         bne   L0EE3
         ldx   ,u
         lbsr  L0FB6
         ldy   ,x
         ldd   <u000A
         subd  $02,y
         std   <u000A
         ldd   $02,y
         addd  <FREEMEM
         std   <FREEMEM
         ldd   <u004A
         subd  $02,y
         std   <u004A
 endc B09EXEC
L0EDE    ldd   #$FFFF
         std   [,u]
L0EE3    ldx   ,--u
         bne   L0EA5
         ldx   <moddir
         tfr   x,y
L0EEB    ldd   ,x++
         cmpd  #$FFFF
         beq   L0EEB
L0EF3    std   ,y++
         bne   L0EEB
         cmpd  ,y
         bne   L0EF3
         rts

 ifeq B09EXEC-true
L0EFD    bsr   L0F6E
         bcs   L0F02
         rts
L0F02    pshs  u,x
         tfr   x,d
         cmpb  #$FE
         beq   L0F69
         ldx   <FREEMEM
         cmpx  #$00FF
         bcs   L0F69
         leax  <-$1C,x
         ldu   <u004A
         ldb   #$FF
L0F18    incb
         clr   b,u
         cmpb  #$18
         bne   L0F18
L0F1F    incb
         leax  -$01,x
         beq   L0F69
         inc   <$18,u
         lda   ,y+
         sta   b,u
         bpl   L0F1F
         incb
         stx   <FREEMEM
         clra
         std   <$15,u
         std   9,u
         std   $F,u
         stu   [,s]
         pshs  b
         addd  #$0003
         std   M$Size,u
         std   $D,u
         addd  <u000A
         std   <u000A
         ldd   #M$ID12    Module header code
         std   M$ID,u
         ldd   #$0019
         std   M$Name,u
         ldd   #$0081
         std   M$Type,u
         ldd   #$0016
         std   M$Mem,u
         puls  b
         leax  d,u
         ldb   #$03
         sta   ,x+
         std   ,x++
         stx   <u004A
         puls  pc,u,x
 endc B09EXEC

L0F69    ldb   #E$MFull
         lbra  L0A86

L0F6E    pshs  u,y
         ldx   <moddir
L0F72    ldy   ,s
         ldu   ,x++
         beq   L0F8E
         ldd   4,u
         leau  d,u
L0F7D    lda   ,y+
         eora  ,u+
         anda  #$DF
         bne   L0F72
         clra
         tst   -1,u
         bpl   L0F7D
L0F8A    leax  -$02,x
         puls  pc,u,b,a
L0F8E    coma
         bra   L0F8A
L0F91    bsr   L0F6E
         bcs   L0F96
         rts
L0F96    pshs  u,y,x
         ldb   $01,s
         cmpb  #$FE
         beq   L0F69
         leax  ,y
         clra
         clrb
         os9   F$Link
         bcc   L0FB0
         ldx   $02,s
         clra
         clrb
         os9   F$Load
         bcs   L0FB4
L0FB0    stx   $02,s
         stu   [,s]
L0FB4    puls  pc,u,y,x

 ifeq B09EXEC-true
L0FB6    pshs  y,x
         ldd   <restop
         addd  <u000A
         tfr   d,y
         ldx   ,x
         sty   [,s]
         ldd   $02,x
         bsr   L0FE3
         pshs  y,x,b,a
         ldx   <moddir
         bra   L0FDB
L0FCD    cmpd  $02,s
         bcs   L0FDB
         cmpd  $04,s
         bhi   L0FDB
         subd  ,s
         std   -$02,x
L0FDB    ldd   ,x++
         bne   L0FCD
         leas  $06,s
         puls  pc,y,x
L0FE3    pshs  u,y,x,b,a
         ldu   #$0000
         tfr   x,d
         subd  $04,s
         pshs  x,b,a
         addd  $04,s
         beq   L1022
L0FF2    lda   ,x
         pshs  a
         bra   L1000
L0FF8    lda   ,y
         sta   ,x
         leau  1,u        Bump counter up
         tfr   y,x
L1000    tfr   x,d
         addd  $05,s
         cmpd  $09,s
         bcs   L100B
         addd  $01,s
L100B    tfr   d,y
         cmpd  $03,s
         bne   L0FF8
         puls  a
         sta   ,x
         leax  $01,y
         stx   $02,s
         leau  1,u
         tfr   u,d
         addd  ,s
         bne   L0FF2
L1022    leas  $04,s
         puls  pc,u,y,x,b,a

L1026    pshs  u,y,x,b,a
         lda   <errcode
         cmpa  #E$SysOvf
         beq   L1068
         tst   <u00A0
         bne   L10AA
         inc   <u00A0
         lda   <u0035
         bne   L1064
         ldd   <u00B3
         subd  #$0001
         bhi   L1089
         bmi   L104E
L1041    lbsr  L0DBB
         leax  >L0791,pcr
         lbsr  L135A
         lbsr  L124D
L104E    leax  >L07A4,pcr
         leay  >L06C1,pcr
         lbsr  L08D3
         bcc   L104E
         lda   <u0035
         bne   L1064
         lbsr  L08CC
         bra   L104E
L1064    cmpa  #$02
         bne   L1041
* Debug QUIT command
L1068    lbsr  L0134
         lda   #$03
L106D    cmpa  <u00BE
         beq   L1074
         os9   I$Close
L1074    inca
         cmpa  #$10
         bcs   L106D
         lbra  L088F

* Debug STEP command
* Entry: Y=Ptr to next char on line entered by user
L107C    lbsr  L0A90
         bne   L108E
         leax  ,y
         lbsr  L1748
         bcc   L1091
         rts
L1089    bsr   L1091
L108B    clrb
         bra   L1090

L108E    ldb   #$01
L1090    clra
L1091    std   <u00B3
         lsl   <u0034
         coma
         ror   <u0034
         bra   L10A6

* Debug CONT command
L109A    lbsr  L0DBB
         lsl   <u0034
         lsr   <u0034
         ldd   #$0001
         std   <u00B3
L10A6    leas  $02,s
         clr   <u00A0
L10AA    puls  pc,u,y,x,b,a

L10AC    ldy   <u0019
         jsr   ,y
L10B1    pshs  u,y,x,b,a
         cmpy  <u0046
         beq   L10E2
         ldb   <u007D
         ldx   <u0080
         ldu   <u0082
         pshs  u,x,b
         stu   <u0080
         lbsr  L0DBB
         lda   #$3D
         lbsr  OUTCHAR
         ldb   ,y
         addb  #$01
         cmpb  #$06
         bcc   L10D7
         leax  ,y
         lbsr  L13AA
L10D7    lbsr  L1264
         puls  u,x,b
         stb   <u007D
         stx   <u0080
         stu   <u0082
L10E2    puls  pc,u,y,x,b,a
L10E4    lbsr  L124B
         tst   <$17,x
         bmi   L110A
         ldx   <u005E
L10EE    clr   <u0074
L10F0    tst   <u0035
         bne   L110A
         leay  ,x
         lbsr  L1BC9
         bsr   L110C
         exg   x,y
         cmpx  <u0060
         bcs   L10F0
         cmpx  <u005C
         bne   L110A
         cmpy  <u0060
         bcs   L10F0
L110A    clra
         rts
L110C    pshs  u,y,x
         lbsr  L0DBB
         ldx   <pgmaddr
         tst   <$17,x
         bmi   L1193
         ldx   ,s
         tfr   y,d
         subd  ,s
         bmi   L1190
         pshs  x,b,a
         addd  #$0040
         cmpd  <FREEMEM
         lbcc  L0F69
         tst   <u0084
         bmi   L1158
         lda   #$20
         cmpx  <u005C
         bhi   L113F
         beq   L113D
         cmpy  <u005C
         bls   L113F
L113D    lda   #$2A
L113F    lbsr  OUTCHAR
         cmpx  <u0060
         bcc   L1158
         tfr   x,d
         subd  <u005E
         ldx   <u0082
         lbsr  L012B
         lda   #$20
         sta   ,x+
         stx   <u0082
         lbsr  L1270
L1158    puls  y,b,a
         cmpy  <u0060
         bcc   L1190
         ldu   <u004A
         lbsr  L19EF
         lbsr  L11F2
         stu   <u005C
         leax  d,u
         stx   <u0060
         stx   <u004A
         leay  ,u
         tst   <u0084
         bmi   L1183
         leax  ,y
         lbsr  L1677
         bne   L1183
         leax  >L02EB,pcr
         lbsr  L126B
L1183    lbsr  L0DBB
         lbsr  L1AC6
         lbsr  L128B
         bsr   L11D5
         dec   <u0082+1
L1190    lbsr  L1264
L1193    puls  pc,u,y,x

L1195    ldx   <pgmaddr
         tst   <$17,x
         bpl   L119E
         coma
         rts
L119E    ldy   <u0080
         lbsr  L0122
         bsr   L11F2
         ldx   <u004A
         lbsr  L1677
         beq   L11D5
         stx   <u005E
         stx   <u005C
         leay  ,x
         ldx   <u00AB
         stx   <u0060
         stx   <u004A
         lbsr  L012E
         ldx   <pgmaddr
         lda   <$17,x
         clr   <$17,x
         tsta
         bne   L11D5
         leax  <L11D5,pcr
         lbsr  L0899
         ldx   <u005E
         lbsr  L0137
         lbra  L088F
L11D5    pshs  u,y,x,b,a
         ldu   <u0046
         pulu  y,x,b,a
         sty   <u000A
         stx   <FREEMEM
         std   <u004A
         pulu  y,x,b,a
         sty   <u0060
         stx   <u005E
         std   <u005C
L11EB    stu   <u0046
         stu   <u0044
         clra
         puls  pc,u,y,x,b,a
L11F2    pshs  u,y,x,b,a
         ldu   <u0046
         ldd   <u005C
         ldx   <u005E
         ldy   <u0060
         pshu  y,x,b,a
         ldd   <u004A
         ldx   <FREEMEM
         ldy   <u000A
         pshu  y,x,b,a
         bra   L11EB
L120A    ldy   <u0031
         leax  >L0756,pcr
L1211    bsr   L1223
         lbsr  L135A
         ldx   $03,y
         bsr   L1256
         leax  >L0799,pcr
         ldy   $07,y
         bne   L1211
L1223    lbra  L0DBB

L1226    lbsr  J010D
         beq   L1249
         lbsr  L0F6E
         bcs   L1249
         ldx   ,x
         ldy   <u0031
L1235    ldy   $07,y
         beq   L1249
         cmpx  $03,y
         bne   L1235
         lsl   ,y
         coma
         ror   ,y
         leax  >L07A2,pcr
         bra   L125F
L1249    coma
         rts
L124B    bsr   L1223
L124D    leax  >L0756,pcr
         lbsr  L135A
         ldx   <pgmaddr
L1256    pshs  x
         leax  <$19,x
         bsr   L1261
         puls  pc,x

L125F    bsr   L1223
L1261    lbsr  L1392
L1264    lbsr  L1371
         bsr   L1270
         bra   L1223
L126B    bsr   L1223
         lbsr  L1392
L1270    pshs  y,x,b,a
         ldd   <u0082
         subd  <u0080
         bls   L1285
         tfr   d,y
         ldx   <u0080
         lda   #$02
         os9   I$WritLn
         bcc   L1285
         bsr   L1287
L1285    puls  pc,y,x,b,a
 endc B09EXEC

L1287    os9   F$PErr
         rts

 ifeq B09EXEC-true
L128B    ldy   <u005C
         cmpy  <u0060
         bcc   L12CF
         ldb   ,y
         cmpb  #$3A
         bne   L12A3
         leay  $01,y
         lbsr  L13CF
         lbsr  L135C
         ldb   ,y
L12A3    tst   <u0084
         bmi   L12B8
         bsr   L12F9
         ldb   <u0074
         pshs  b
         bsr   L12D8
         puls  a
         sta   <u0074
         tfr   b,a
         lbsr  L134E
L12B8    ldb   ,y+
         bmi   L12C4
         bsr   L12F9
         bsr   L12D8
         bsr   L130C
         bra   L12C7
L12C4    lbsr  L1489
L12C7    cmpy  <u0060
         bcs   L12B8
L12CC    sty   <u005C
L12CF    lda   #$0D
         lbra  OUTCHAR

L12D4    leas  $02,s
         bra   L12CC
L12D8    sta   ,-s
         bmi   L12F6
         anda  #$03
         beq   L12F6
         cmpa  #$01
         bne   L12E8
         inc   <u0074
         bra   L12F6
L12E8    decb
         bpl   L12EC
         clrb
L12EC    cmpa  #$03
         beq   L12F6
         dec   <u0074
         bpl   L12F6
         clr   <u0074
L12F6    lda   ,s+
         rts
L12F9    leax  >L03F5,pcr
         tstb
         bpl   L1302
         subb  #$2A
L1302    lda   #$03
         mul
         leax  d,x
         lda   ,x
         rts
L130A    bsr   L12F9
L130C    leax  $01,x
         anda  #$60
         beq   L1318
         cmpa  #$60
         bne   L132A
         leay  $02,y
L1318    lda   -$01,x
         pshs  a
         ldd   ,x
         leax  d,x
         puls  a
         anda  #$18
         cmpa  #$10
         beq   L1392
         bra   L1358
L132A    cmpa  #$20
         bne   L1332
         ldd   ,x
         jmp   d,x
L1332    bsr   L133A
         bsr   L1336
L1336    lda   ,x+
         bne   OUTCHAR
L133A    lda   <u007D
         cmpa  #$41
         bcs   L1357
         lda   #$0A
         bsr   OUTCHAR
         clr   <u007D
         tst   <u0084
         bmi   L1357
         lda   <u0074
         adda  #$03
L134E    lsla
         adda  #$06
         ldb   #$10
         lbsr  J011F
         clra
L1357    rts

L1358    bsr   L135C
L135A    bsr   L1392
L135C    pshs  u,b,a
         bsr   L133A
         bcc   L136F
         ldu   <u0082
         lda   #C$SPAC
         cmpa  -1,u
         beq   L136F
         cmpu  <u0080
         bne   L1377
L136F    puls  pc,u,b,a

L1371    lda   #C$CR
* Print character in A
OUTCHAR  pshs  u,b,a
         ldu   <u0082
L1377    sta   ,u+
         ldd   <u0082
         subd  <u0080
         tsta
         bne   L1384
         inc   <u007D
         stu   <u0082
L1384    puls  pc,u,b,a

L1386    lda   #'.
         bsr   OUTCHAR
L138A    ldx   ,y++
         ldd   <u0062
         leax  d,x
         leax  $03,x
L1392    pshs  x
L1394    lda   ,x
         anda  #$7F
         bsr   OUTCHAR
         tst   ,x+
         bpl   L1394
         puls  pc,x

L13A0    ldb   #$03
         ldx   <u0044
         pshs  y,b
         leay  -$01,y
         bra   L13AC
L13AA    pshs  y,b
L13AC    ldd   $04,y
         std   ,--x
         ldd   $02,y
         std   ,--x
         ldd   ,y
         std   ,--x
         leay  ,x
         puls  b
         bra   L13DC

L13BE    ldb   ,y
         clra
         bra   L13D1

L13C3    leax  >L0203,pcr
         bra   L13CD

L13C9    leax  >L01FD,pcr
L13CD    bsr   L1358
L13CF    ldd   ,y++
L13D1    pshs  y
         ldy   <u0044
         leay  -6,y
         std   $01,y
         ldb   #$02
L13DC    lbsr  J011F
         puls  pc,y
* Print string
L13E1    bsr   L13F1
L13E3    lda   ,y+
         cmpa  #C$EOS
         beq   L13F1
         bsr   OUTCHAR
         cmpa  #'"
         bne   L13E3
         bra   L13E1

L13F1    lda   #'"
L13F3    lbra  OUTCHAR

L13F6    lda   #'$
         bsr   L13F3
         ldb   #$14
         lbsr  J011F
         leay  $02,y
         rts

L1402    leax  >L027E,pcr
         lbsr  L135A
         lda   -$01,y
         adda  #$FB
         bra   L13F3

L140F    leax  >L020A,pcr
L1413    lbsr  L135A
         lbra  L138A

L1419    leax  >L01AC,pcr
         leay  $01,y
         bsr   L1413
         leay  6,y
         rts

L1424    leax  >L02B4,pcr
         lbsr  L1358
         lda   ,y
         cmpa  #$3A
         beq   L1433
         inc   <u0074
L1433    rts

L1434    fcs   '(*'

L1436    leax  >L1434,pc  Point to alternative REM statement
         bra   L1440

L143C    leax  >L0284,pcr
L1440    lbsr  L135A
L1443    ldb   ,y+
L1445    decb
         beq   L1433
         lda   ,y+
         bsr   L13F3
L144C    bra   L1445

* File opening mode table: 3 bytes per entry
* Byte 1   : Actual mode bit pattern
* Bytes 2&3: Offset (from itself) to keyword describing mode
*   NOTE: keywords are high bit terminated
L144E    fcb   UPDAT.
L144F    fdb   L03E4-*    Points to 'Update' string
L1451    fcb   READ.
L1452    fdb   L0241-*    Points to 'Read' string
L1454    fcb   WRITE.
L1455    fdb   L0247-*    Points to 'Write' string
L1457    fcb   EXEC.
L1458    fdb   L03EC-*    Points to 'Exec' string
L145A    fcb   DIR.
L145B    fdb   L03F2-*    Points to 'Dir' string
L145D    fcb   $00        End of table marker

L145E    lda   ,y+        Get requested file access mode
         pshs  a          Preserve on stack
         lda   #':        Separator that starts modes
L1464    bsr   L13F3
         leax  <L144C,pcr
L1469    leax  $02,x
         lda   ,s
         anda  ,x
         cmpa  ,x+
         bne   L1469
         tsta
         beq   L1487
         eora  ,s
         sta   ,s
         ldd   ,x
         leax  d,x
         lbsr  L1392
         lda   #$2B
         tst   ,s
         bne   L1464
L1487    puls  pc,a
L1489    pshs  u
         ldu   <u0044
         clr   ,-u
         clr   ,-u
         leay  -$01,y
L1493    ldb   ,y
         bpl   L14C4
         lbsr  L12F9
         tfr   a,b
         lda   ,y+
         bitb  #$80
         bne   L1493
         orb   #$80
         pshu  b,a
         bitb  #$18
         bne   L1493
         andb  #$7F
         pshu  b,a
         bitb  #$04
         bne   L14B8
         ldd   ,y++
         std   2,u
         bra   L1493
L14B8    leay  -$01,y
         sty   2,u
         ldb   ,y+
         lbsr  L1B68
         bra   L1493
L14C4    sty   <u005C
         leay  ,u
         clra
         clrb
         std   ,--y
         pshs  b,a
         sta   <u00BF
         sta   <u00B1
L14D3    ldd   ,u++
         bitb  #$08
         beq   L14FE
         andb  #$07
         cmpb  <u00BF
         bhi   L14F2
         bne   L14EF
         cmpb  #$06
         bne   L14EB
         tst   <u00B1
         beq   L14EF
         bra   L14F2
L14EB    tst   <u00B1
         beq   L14F2
L14EF    lbsr  L1581
L14F2    stb   <u00BF
         orb   #$80
         std   ,--y
         lda   #$01
         sta   <u00B1
         bra   L14D3
L14FE    clr   <u00B1
         bitb  #$03
         beq   L152D
         bitb  #$04
         bne   L152D
         bitb  #$10
         bne   L1510
         pulu  x
         stx   ,--y
L1510    std   ,--y
         andb  #$03
         bsr   L1581
         cmpa  #$BE
         bne   L151F
         ldx   #$54FF
         stx   ,--y
L151F    ldx   #$4B80
         bra   L1526
L1524    stx   ,--y
L1526    decb
         bne   L1524
         stb   <u00BF
L152B    bra   L14D3
L152D    bitb  #$10
         bne   L1535
         pulu  x
L1533    pshs  x
L1535    pshs  b,a
         cmpa  #$89
         bcs   L153F
         cmpa  #$8C
         bls   L14D3
L153F    ldd   ,y++
         tstb
         bmi   L154A
         beq   L1558
         ldx   ,y++
         bra   L1533
L154A    pshs  b,a
         clr   $01,s
         bitb  #$10
         bne   L153F
         andb  #$07
         stb   <u00BF
         bra   L152B
L1558    ldx   ,u++
         beq   L1569
         pshu  x
         std   ,--y
         bra   L152B
L1562    puls  y
         ldb   ,y+
         lbsr  L130A
L1569    ldd   ,s++
         beq   L157C
         bitb  #$04
         bne   L1562
         leay  ,s
         exg   a,b
         lbsr  L130A
         leas  ,y
         bra   L1569
L157C    ldy   <u005C
         puls  pc,u
L1581    ldx   ,s
         pshs  x
         ldx   #$4E00
         stx   $02,s
         ldx   #$4DFF
         stx   ,--y
         rts

S.EDIT   lbsr  L0A9D
         lbsr  L0EFD
         ldy   ,x
         tst   6,y
         bne   L15E5
         pshs  x
         lbsr  L1A2E
         lbsr  L124B
         ldy   <u005E
         bsr   L15F3
L15AA    lda   <u0035
         cmpa  #$02
         bne   L15B3
         lbsr  L1993
L15B3    leax  >L07A6,pcr
         leay  >L0718,pcr
         lbsr  L08D3
         bcc   L15AA
         tst   <u0035
         bne   L15AA
         leax  >L15AA,pcr
         pshs  x
         ldx   <u0080
         lsl   ,x
         lsr   ,x
         lbsr  L1748
         lbcs  L08CC
         lbsr  L1A0D
         lda   ,x
         cmpa  #$0D
         beq   L15F3
         ldy   <u0080
         bra   L1601
L15E5    coma
         rts

E.MOVE   leax  -$01,y
         lsl   ,x
         asr   ,x
         lbsr  L16F2
         lbsr  L16BD
L15F3    sty   <u005C
         lbsr  L1682
         leax  ,y
         lbsr  L1BC9
         lbra  L16AD
L1601    bsr   L1606
         bcc   L15F3
         rts
L1606    tst   <FREEMEM
         beq   L1670
         clr   <u00A0
         lbsr  L0122
         ldx   <u004A
         lda   ,x
         cmpa  #$3A
         bne   L165E
         clra
         clrb
         sta   ,-s
         ldy   <u005C
         lbsr  L1A10
         cmpy  <u0060
         bcc   L162F
         ldd   $01,x
         cmpd  $01,y
         bls   L162F
         inc   ,s
L162F    ldy   <u005E
         ldd   $01,x
         lbsr  L1A0D
         tst   ,s+
         bne   L1642
         bcc   L1642
         cmpy  <u005C
         bcc   L165E
L1642    sty   <u005C
         cmpy  <u0060
         bcc   L165E
         ldx   <u004A
         ldd   $01,x
         cmpd  $01,y
         bne   L165E
         pshs  y
         lbsr  L1BC9
         tfr   y,d
         subd  ,s++
         bra   L1660
L165E    clra
         clrb
L1660    ldy   <u005C
         lbsr  L19B1
         ldx   <u005C
         bsr   L1677
         bne   L166E
         leay  ,x
L166E    clra
         rts

L1670    ldb   #E$MFull
         lbsr  L1287
         coma
         rts

L1677    lda   ,x
         cmpa  #$3A
         bne   L167F
         lda   $03,x
L167F    cmpa  #$3D
         rts
L1682    ldx   #$0000
         ldy   <u005E
L1688    cmpy  <u005C
         bcc   L1697
         leax  $01,x
         lbsr  L1BC9
         cmpy  <u0060
         bcs   L1688
L1697    sty   <u005C
         stx   <u00B5
         clra
         rts

E.LIST    bsr   L16CE
         bsr   L16BD
         cmpx  <u005E
         bhi   L16AD
         pshs  y,x
         lbsr  L124B
         puls  y,x
L16AD    ldd   <u0060
         pshs  b,a
         sty   <u0060
         lbsr  L10EE
         puls  b,a
         std   <u0060
         clra
         rts
L16BD    pshs  x,b
         ldx   <u0082
         ldb   ,x
         cmpb  #$0D
         bne   L16C9
         puls  pc,x,b
L16C9    leas  $05,s
         lbra  L08CC
L16CE    lda   ,y+
         cmpa  #$20
         beq   L16CE
         cmpa  #$2A
         bne   L16E1
         sty   <u0082
         ldx   <u005E
         ldy   <u0060
         rts
L16E1    leax  -$01,y
         bsr   L16F2
         bcs   L16F1
         ldx   <u005C
         cmpy  <u005C
         bcc   L16F1
         exg   x,y
         clra
L16F1    rts

* How many lines to move
L16F2    clr   ,-s
         ldd   ,x
         cmpa  #'+
         bne   L1707
         ldy   <u0060
L16FD    cmpb  #'*
         bne   L1712
         leax  $02,x
         stx   <u0082
         puls  pc,a
L1707    cmpa  #'-
         bne   L1714
         inc   ,s
         ldy   <u005E
         bra   L16FD
L1712    leax  $01,x
L1714    lda   ,x
         cmpa  #'0
         bcs   L171E
         cmpa  #'9
         bls   L1723
L171E    ldd   #$0001
         bra   L1727
L1723    bsr   L1748
         bcs   L1742
L1727    stx   <u0082
         ldy   <u005C
         tst   ,s+
         beq   L173D
         ldy   <u005E
         pshs  b,a
         ldd   <u00B5
         subd  ,s++
         bcc   L173D
         clra
         clrb
L173D    lbsr  L1BCF
         clra
         rts
L1742    ldy   <u005C
         com   ,s+
         rts
L1748    ldy   <u0046
         lbsr  L013A
         lda   ,y+
         cmpa  #$02
         beq   L1759
         clra
         ldd   ,y
         bne   L175A
L1759    coma
L175A    rts

L175B    clrb
         bra   L1760

L175E    ldb   #$01
L1760    leas  -$0F,s
         stb   ,s
         lda   ,y
         clr   $01,s
         cmpa  #$2A
         bne   L1770
         sta   $01,s
         leay  $01,y
L1770    ldb   ,y+
         cmpb  #$20
         beq   L1770
         tfr   b,a
         sty   <u0082
         lbsr  L18AA
         stu   $02,s
         lbmi  L1985
         tst   ,s
         beq   L1791
         lbsr  L18AA
         stu   $04,s
         lbmi  L1985
L1791    cmpa  #$0D
         beq   L179D
         lda   ,y+
         cmpa  #$0D
         lbne  L1985
L179D    ldu   <u0046
         stu   $0D,s
L17A1    lda   ,-y
         sta   ,-u
         cmpy  <u0082
         bhi   L17A1
         stu   <u0046
         stu   <u0044
         ldd   $02,s
         leau  d,u
         leau  1,u
         stu   $06,s
         ldy   <u005C
         sty   $0B,s
         clr   $0A,s
         lbra  L1878
L17C1    lbsr  L0DBB
         sty   <u005C
         lbsr  L128B
         ldy   <u0080
         leay  $05,y
         lsl   $0A,s
         asr   $0A,s
L17D3    tst   <u0035
         bne   L183A
         ldd   <u0082
         subd  $02,s
         ldx   <u0046
         lbsr  L18BE
         bcs   L182F
         lda   #$81
         sta   $0A,s
         tst   ,s
         beq   L182F
         ldd   <u0082
         addd  $04,s
         subd  $02,s
         subd  <u0080
         cmpd  #$00E6
         bhi   L182F
         ldx   <u0082
         exg   x,y
         ldd   $02,s
         lbsr  L0FE3
         tfr   y,d
         subd  $02,s
         tfr   d,y
         ldu   $06,s
         pshs  x,b,a
L180B    lda   ,u+
         sta   ,y+
         cmpa  #C$EOS
         bne   L180B
         leay  -$01,y
         ldd   ,s++
         subd  ,s
         puls  x
         lbsr  L0FE3
         sty   <u0082
         ldd   $04,s
         leay  d,x
         ldd   $02,s
         bne   L182B
         leay  $01,y
L182B    tst   $01,s
         bne   L17D3
L182F    tst   $0A,s
         bpl   L1872
         ldy   $08,s
         ldd   ,s
         bne   L1845
L183A    ldx   $0D,s
         stx   <u0046
         stx   <u0044
         leas  $0F,s
         lbra  L15F3
L1845    lbsr  L1270
         sty   $0B,s
         tst   ,s
         beq   L1872
         leax  ,y
         lbsr  L1BC9
         lbsr  L19A5
         sty   <u005C
         ldy   <u0080
         lbsr  L1606
         sty   <u005C
         ldy   $08,s
         lbsr  L1BC9
         cmpy  <u005C
         bne   L1882
         tst   $01,s
         beq   L1882
L1872    ldy   $08,s
         lbsr  L1BC9
L1878    sty   $08,s
         cmpy  <u0060
         lbcs  L17C1
L1882    lbsr  L0DBB
         tst   $0A,s
         bne   L1899
         leax  >L07AA,pcr
         lbsr  L135A
         ldy   <u0046
         lbsr  L13E1
         lbsr  L1264
L1899    ldy   $0B,s
         sty   <u005C
         ldx   $0D,s
         stx   <u0046
         stx   <u0044
         leas  $0F,s
         lbra  L1682
L18AA    ldu   #$FFFF
L18AD    cmpa  #$0D
         beq   L18B9
         leau  1,u
         lda   ,y+
         cmpb  -$01,y
         bne   L18AD
L18B9    clr   -$01,y
         com   -$01,y
         rts
 endc

L18BE    pshs  b,a
         bra   L18D2

L18C2    pshs  y,x
L18C4    lda   ,x+
         cmpa  #C$EOS
         beq   L18DA
         cmpa  ,y+
         beq   L18C4
         puls  y,x
         leay  $01,y
L18D2    cmpy  ,s
         bls   L18C2
         coma
         puls  pc,b,a
L18DA    puls  y,x
         clra
         puls  pc,b,a

 ifeq B09EXEC-true
L18DF    ldd   #$0064
         ldx   #10
         pshs  x,b,a
         leax  ,y
         ldy   <u00B5
         lda   ,x
         cmpa  #$2A
         bne   L18FA
         ldy   #$0000
L18F6    leax  $01,x
         lda   ,x
L18FA    cmpa  #$20
         beq   L18F6
         pshs  y
         cmpa  #$0D
         beq   L191C
         lbsr  L1748
         bcs   L1981
         std   $02,s
         lda   ,x+
         cmpa  #$0D
         beq   L191C
         lbsr  L1748
         bcs   L1981
         std   $04,s
         bmi   L1981
         lda   ,x
L191C    cmpa  #$0D
         bne   L1981
         bsr   L1995
         ldd   ,s++
         ldy   <u005E
         lbsr  L1BCF
         sty   <u005C
         ldd   ,s
         lbsr  L1A0D
         clr   ,-s
         cmpy  <u005C
         bcs   L198A
         bsr   L1960
         cmpx  #$0000
         ble   L198A
         tst   <u0035
         bne   L194C
         tst   <u0035
         bne   L194C
         inc   ,s
         bsr   L1960
L194C    leas  $05,s
         ldx   $02,s
         lbsr  L1A2E
         ldy   <u005E
         ldd   <u00B5
         lbsr  L1BCF
         sty   <u005C
         clra
         rts
L1960    ldy   <u005C
         ldx   $03,s
L1965    clra
         clrb
         lbsr  L1A10
         cmpy  <u0060
         bcc   L1980
         tst   $02,s
         beq   L1975
         stx   $01,y
L1975    lbsr  L1BC9
         tfr   x,d
         addd  $05,s
         tfr   d,x
         bpl   L1965
L1980    rts
L1981    leas  $06,s
         bra   L1987
L1985    leas  $0F,s
L1987    lbra  L08CC
L198A    leax  >L078B,pcr
         lbsr  L125F
         bra   L194C
L1993    leas  $04,s
L1995    lbsr  L0128
         clra
         rts

E.DELETE    lbsr  L16CE
         lbsr  L16BD
         bsr   L19A5
         lbra  L15F3
L19A5    ldd   <u004A
         std   <u00AB
         tfr   y,d
         pshs  x
         subd  ,s++
         leay  ,x
L19B1    pshs  u,y,x,b,a
         leax  d,y
         pshs  x
         ldy   <u00AB
         ldd   <u004A
         subd  ,s
         beq   L19C3
         lbsr  L0FE3
L19C3    ldd   <u00AB
         ldu   ,s
         subd  ,s++
         bls   L19D1
         ldy   $04,s
         lbsr  L0125
L19D1    ldd   <u00AB
         subd  <u004A
         ldy   $04,s
         leay  d,y
         sty   $04,s
         subd  ,s++
         pshs  b,a
         addd  <u0060
         std   <u0060
         std   <u004A
         ldd   <FREEMEM
         subd  ,s
         std   <FREEMEM
         puls  pc,u,y,x,b,a
L19EF    pshs  y,x,b,a
         leay  d,y
         leau  d,u
         andb  #$03
L19F7    beq   L1A06
         lda   ,-y
         sta   ,-u
         decb
         bra   L19F7
L1A00    ldx   ,--y
         ldd   ,--y
         pshu  x,b,a
L1A06    cmpy  $04,s
         bne   L1A00
         puls  pc,y,x,b,a
L1A0D    ldy   <u005E
L1A10    pshs  b,a
         bra   L1A17
L1A14    lbsr  L1BC9
L1A17    cmpy  <u0060
         bcc   L1A2B
         lda   ,y
         cmpa  #$3A
         bne   L1A14
         ldd   ,s
         cmpd  $01,y
         bhi   L1A14
         puls  pc,b,a
L1A2B    coma
         puls  pc,b,a
L1A2E    pshs  u,y,x,b,a
         lbsr  L0FB6
         ldx   ,x
         stx   <pgmaddr
         ldd   $09,x
         addd  <pgmaddr
         std   <u005E
         ldd   $0F,x
         addd  <pgmaddr
         std   <u0060
         std   <u004A
         ldd   $02,x
         subd  $0F,x
         pshs  b,a
         ldd   <membase
         addd  <memsize
         subd  ,s
         tfr   d,u
         std   <u0066
         ldd   <pgmaddr
         addd  $0F,x
         tfr   d,y
         puls  b,a
         bsr   L19EF
         ldd   $0D,x
         subd  $0F,x
         subd  #$0003
         std   <u0068
         addd  <u0066
         addd  #$0003
         std   <u0062
         ldd   $02,x
         subd  $0D,x
         addd  #$0003
         std   <u0064
         ldy   <u005E
         bsr   L1AC6
         ldx   <u0062
         ldd   -$03,x
         beq   L1A9E
L1A83    pshs  b,a
         leau  ,x
         leax  $03,x
L1A89    ldb   ,x+
         bpl   L1A89
         lda   #$02
         cmpb  #$A4
         bne   L1A95
         lda   #$04
L1A95    sta   ,u
         puls  b,a
         subd  #$0001
         bgt   L1A83
L1A9E    ldx   <u0066
         ldd   <u0068
         leax  d,x
         stx   <u00DA
         stx   <u0066
         addd  <FREEMEM
         std   <FREEMEM
         clr   <u0068
         clr   <u0068+1
         puls  pc,u,y,x,b,a
L1AB2    ldb   ,y+
         bpl   L1AB8
         subb  #$2A
L1AB8    clra
         leax  >L1BD5,pcr
         ldb   d,x
         lsrb
         lsrb
         lsrb
         lsrb
         lbsr  L1B75
L1AC6    cmpy  <u0060
         bcs   L1AB2
         rts

* 8 bit offset jump table (base of JMP is L1ACC)
L1ACC    fcb   L1AE5-L1ACC
         fcb   L1AE3-L1ACC
         fcb   L1AE1-L1ACC
         fcb   L1B0F-L1ACC
         fcb   L1B00-L1ACC
         fcb   L1B12-L1ACC
         fcb   L1AFA-L1ACC
         fcb   L1B19-L1ACC
         fcb   L1B09-L1ACC
         fcb   L1AED-L1ACC
         fcb   L1B1F-L1ACC
         fcb   L1AEA-L1ACC
         fcb   L1AE8-L1ACC
         fcb   L1AE6-L1ACC
         fcb   L1ADB-L1ACC

* Routines called by above table follow here
L1ADB    lda   -1,y
         adda  #$93
         sta   -1,y
L1AE1    leay  1,y
L1AE3    leay  1,y
L1AE5    rts

L1AE6    dec   -1,y
L1AE8    dec   -1,y
L1AEA    dec   -1,y
         rts

L1AED    ldd   ,y
         addd  <u005E
         tfr   d,x
         ldd   -2,x
         std   ,y++
         dec   -3,y
         rts

L1AFA    lda   ,y+
         cmpa  #$85
         bne   L1B03
L1B00    leay  9,y
         rts

L1B03    clrb
         bsr   L1B23
         leay  $07,y
         rts

L1B09    lda   ,y
         cmpa  #$4F
         bne   L1AE3
L1B0F    leay  $05,y
         rts

L1B12    lda   ,y+
         cmpa  #C$EOS
         bne   L1B12
         rts

L1B19    ldb   ,y
         clra
         leay  d,y
         rts

L1B1F    ldb   -$01,y
L1B21    andb  #$04
L1B23    lda   #$60
         pshs  b,a
         lda   #$85
         sta   -$01,y
         ldx   <u0062
         ldd   -$03,x
         ldu   ,y
         bra   L1B40
L1B33    puls  b,a
L1B35    subd  #$0001
         beq   L1B65
         leax  $03,x
L1B3C    tst   ,x+
         bpl   L1B3C
L1B40    cmpu  $01,x
         bne   L1B35
         pshs  b,a
         lda   ,x
         anda  #$E0
         cmpa  $02,s
         bne   L1B33
         lda   ,x
         anda  #$18
         bne   L1B33
         lda   ,x
         anda  #$04
         eora  $03,s
         bne   L1B33
         tfr   x,d
         subd  <u0062
         std   ,y++
         leas  $02,s
L1B65    leas  $02,s
         rts
L1B68    tstb
         bpl   L1B6D
         subb  #$2A
L1B6D    leax  <L1BD5,pcr
         clra
         ldb   d,x
         andb  #$0F
L1B75    leax  >L1ACC,pcr
         ldb   b,x
         jmp   b,x
L1B7D    pshs  u
         ldb   ,y+
L1B81    cmpb  ,u+
         bhi   L1B81
         puls  u
         beq   L1B91
         bsr   L1B68
L1B8B    cmpy  <u0060
         bcs   L1B7D
         coma
L1B91    puls  pc,u,x,b,a
L1B93    tfr   y,x
         abx
         stu   >$3456
         leau  >L1B93,pcr
         bra   L1B8B

L1B9F    fcb   '>
L1BA0    fcb   '?
         fcb   C$EOS

L1BA2    pshs  u,x,d
         leau  <L1B9F,pcr
         bra   L1B8B
 else
L1BA2    pshs  x,b,a
L0435    leax  <L0442,pcr
         lda   ,y+
L043A    cmpa  ,x++
         bcs   L043A
         ldb   ,-x
         jmp   b,x

* embedded jumptable            second value
L0442    fcb   $f2
         fcb   L045A-*  *$17
L0444    fcb   $92
         fcb   L045E-*  *$19
L0446    fcb   $91
         fcb   L045A-*  *$13
L0448    fcb   $90
         fcb   L0460-*  *$17
L044A    fcb   $8f
         fcb   L0458-*  *$0D
L044C    fcb   $8e
         fcb   L045A-*  *$0D
L044E    fcb   $8d
         fcb   L045C-*  *$0D
L0450    fcb   $55
         fcb   L045A-*  *$09
L0452    fcb   $4b
         fcb   L045E-*  *$0B
L0454    fcb   $3e
         fcb   L0466-*  *$11
L0456    fcb   $00
         fcb   L045E-*  *$07

L0458    leay  $03,y
L045A    leay  $01,y
L045C    leay  $01,y
L045E    bra   L0435
L0460    tst   ,y+
         bpl   L0460
         bra   L0435
L0466    puls  pc,x,b,a
 endc

 ifeq B09EXEC-true
L1BA9    pshs  u,x,b,a
         leau  <L1BA0,pcr
         bra   L1B8B

* Table: 1 byte entries
L1BB0    fcb   $23,$85,$86,$87,$88,$89,$8A,$8B,$8C
         fcb   $f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$ff

L1BC2    pshs  u,x,d
         leau  <L1BB0,pcr
         bra   L1B8B
L1BC9    clra
         clrb
L1BCB    bsr   L1BA9
         bcs   L1BD4
L1BCF    subd  #$0001
         bcc   L1BCB
L1BD4    rts

* Table - single byte entries - one routine uses it to reference another
* table (1ACC), but divides it by 16 to determine which of that table to use
* Table goes from 1BD5 to 1CA4
L1BD5    fcb   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcb   $00,$22,$00,$00,$64,$00,$22,$00,$00,$00,$22,$00,$22,$00,$00,$22
         fcb   $92,$22,$92,$22,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         fcb   $00,$00,$00,$00,$00,$00,$00,$77,$77,$00,$22,$92,$77,$77,$00,$00
         fcb   $00,$00,$00,$00,$80,$00,$22,$22,$00,$00,$11,$00,$00,$00,$00,$00
         fcb   $00,$00,$00,$00,$00,$22,$a2,$a2,$a2,$a2,$a2,$22,$22,$22,$22,$22
         fcb   $22,$22,$22,$11,$22,$33,$55,$22,$00,$00,$00,$00,$00,$00,$00,$b0
         fcb   $00,$00,$00,$00,$b0,$00,$00,$00,$00,$00,$00,$00,$00,$b0,$00,$00
         fcb   $00,$b0,$00,$b0,$00,$b0,$00,$b0,$00,$b0,$00,$00,$00,$00,$00,$00
         fcb   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$b0,$00,$00,$00,$00
         fcb   $00,$00,$00,$00,$00,$b0,$00,$00,$00,$00,$b0,$c0,$00,$b0,$c0,$00
         fcb   $b0,$c0,$d0,$00,$b0,$c0,$d0,$00,$b0,$c0,$00,$b0,$c0,$00,$b0,$c0
         fcb   $00,$b0,$00,$b0,$00,$b0,$00,$00,$e2,$e2,$e2,$e2,$e2,$e2,$e2,$e2
 endc
L1CA5    pshs  x,d        Preserve regs
         ldb   [<4,s]     Get function code
         leax  <L1CB5,pc  Point to table
         ldd   b,x        Make offset vector
         leax  d,x
         stx   4,s        Modify RTS address
         puls  pc,x,d     restore X & D and RTS to new address

* 2 byte/entry vector table (JMP >$1E calls have there function byte after
*  the JMP containing the offset to which of these entries to uses)
L1CB5    fdb   LAX1-L1CB5 $00 function
         fdb   LAX2-L1CB5 $02 function
         fdb   L252A-L1CB5 $04 function
 ifgt EDITION-20
         fdb   L2508-L1CB5 $06 function
 endc
 ifeq B09EXEC-true
         fdb   L24BD-L1CB5 $08 function
         fdb   L1E29-L1CB5 $0A function
 endc

L1CC1    jsr   <u001B     Print error code to screen
         fcb   $02
L1CC4    jsr   <u001B     ??? Save SP @ <u00B7, muck around
         fcb   $04
L1CC7    jsr   <u001B     ??? Reset temp buff to defaults, SP restore from B7
         fcb   $06
L1CCA    jsr   <u002A
         fcb   $00
 ifeq B09EXEC-true
L1CCD    jsr   <u001B
         fcb   $12
 endc

* Data of some sort: Appears to be special symbols
         fdb   (SYMONE-L1CD3)/5+(SYMEND-SYMONE)/4
         fcb   $03        (# bytes to skip to start of next?)

L1CD3
 ifeq B09EXEC-true
         fcb   L2368-L239D
         fcb   $d9,$0a    (token & type of operator???)
         fcs   '<>'

         fcb   L2368-L239D
         fcb   $d9,$0a
         fcs   '><'

         fcb   L2368-L239D
         fcb   $e4,$0a
         fcs   '<='

         fcb   L2368-L239D
         fcb   $e4,$0a
         fcs   '=<'

         fcb   L2368-L239D
         fcb   $e1,$0a
         fcs   '>='

         fcb   L2368-L239D
         fcb   $e1,$0a
         fcs   '=>'

         fcb   L2368-L239D
         fcb   $52,$08
         fcs   ':='

         fcb   L2368-L239D
         fcb   $f1,$05
         fcs   '**'

         fcb   L2368-L239D
         fcb   $38,$01
         fcs   '(*'
 endc
SYMONE
 ifeq B09EXEC-true
         fcb   L2368-L239D
         fcb   $3e,$02
         fcs   '\'

         fcb   L2368-L239D
         fcb   $d3,$0a
         fcs   '>'

         fcb   L2368-L239D
         fcb   $d6,$0a
         fcs   '<'

         fcb   L2368-L239D
         fcb   $dd,$09
         fcs   '='

         fcb   L2368-L239D
         fcb   $e7,$05
         fcs   '+'

         fcb   L2368-L239D
         fcb   $ea,$05
         fcs   '-'

         fcb   L2368-L239D
         fcb   $ec,$05
         fcs   '*'

         fcb   L2368-L239D
         fcb   $ee,$05
         fcs   '/'

         fcb   L2368-L239D
         fcb   $f0,$05
         fcs   '^'

         fcb   L2368-L239D
         fcb   $4c,$0c
         fcs   ':'

         fcb   L2368-L239D
         fcb   $4f,$0c
         fcs   '['

         fcb   L2368-L239D
         fcb   $50,$0c
         fcs   ']'

         fcb   L2368-L239D
         fcb   $51,$0c
         fcs   ';'

         fcb   L2368-L239D
         fcb   $54,$0b
         fcs   '#'

         fcb   L2368-L239D
         fcb   $26,$01
         fcs   '?'

         fcb   L2368-L239D
         fcb   $37,$01
         fcs   '!'

         fcb   L233E-L239D Recurse to the search routine again (eat LF)
         fcb   $00,$0c
         fcb   $80+C$LF   Line feed
 endc
         fcb   L2368-L239D
         fcb   $4b,$0c
         fcs   ','

         fcb   L2368-L239D
         fcb   $4d,$0c
         fcs   '('

         fcb   L2368-L239D
         fcb   $4e,$0c
         fcs   ')'

         fcb   L2371-L239D
         fcb   $89,$0c
         fcs   '.'

         fcb   L23BE-L239D
         fcb   $90,$06
         fcs   '"'

         fcb   L239D-L239D
         fcb   $91,$06
         fcs   '$'

         fcb   L2368-L239D
         fcb   $3f,$02
         fcb   $80+C$CR   Carriage return
SYMEND   equ *

 ifeq B09EXEC-true
* Jump table for type 1 commands (see L0140)
*                           Command  Token
L1D60    fdb   L211B-L1D60 ???      0   Illegal statement construction error
         fdb   L1E82-L1D60 PARAM    1
         fdb   L1E72-L1D60 TYPE     2
         fdb   L1E82-L1D60 DIM      3
         fdb   L1ED3-L1D60 DATA     4
         fdb   L2029-L1D60 STOP     5
         fdb   L210B-L1D60 BYE      6
         fdb   L210B-L1D60 TRON     7
         fdb   L210B-L1D60 TROFF    8
         fdb   L2029-L1D60 PAUSE    9
         fdb   L210B-L1D60 DEG      A
         fdb   L210B-L1D60 RAD      B
         fdb   L210B-L1D60 RETURN   C
         fdb   L2123-L1D60 LET      D
         fdb   L211B-L1D60 ???      E   Illegal Statement Construction err
         fdb   L1EE1-L1D60 POKE     F
         fdb   L1EEA-L1D60 IF       10
         fdb   L1EFF-L1D60 ELSE     11
         fdb   L210B-L1D60 ENDIF    12
         fdb   L1F03-L1D60 FOR      13
         fdb   L1F24-L1D60 NEXT     14
         fdb   L1F2E-L1D60 WHILE    15
         fdb   L1F3D-L1D60 ENDWHILE 16
         fdb   L210B-L1D60 REPEAT   17
         fdb   L1F39-L1D60 UNTIL    18
         fdb   L210B-L1D60 LOOP     19
         fdb   L1F3D-L1D60 ENDLOOP  1A
         fdb   L1F41-L1D60 EXITIF   1B
         fdb   L1F3D-L1D60 ENDEXIT  1C
         fdb   L1F4C-L1D60 ON       1D
         fdb   L213C-L1D60 ERROR    1E
         fdb   L1F87-L1D60 GOTO     1F
         fdb   L211B-L1D60 ???      20  Illegal Statement Construction err
         fdb   L1F87-L1D60 GOSUB    21
         fdb   L211B-L1D60 ???      22  Illegal Statement Construction err
         fdb   L1FB4-L1D60 RUN      23
         fdb   L213C-L1D60 KILL     24
         fdb   L1FF6-L1D60 INPUT    25
         fdb   L2029-L1D60 PRINT    26 (Also '?')
         fdb   L213C-L1D60 CHD      27
         fdb   L213C-L1D60 CHX      28
         fdb   L2093-L1D60 CREATE   29
         fdb   L2093-L1D60 OPEN     2A
         fdb   L2083-L1D60 SEEK     2B
         fdb   L205A-L1D60 READ     2C
         fdb   L2067-L1D60 WRITE    2D
         fdb   L2071-L1D60 GET      2E
         fdb   L2071-L1D60 PUT      2F
         fdb   L20D2-L1D60 CLOSE    30
         fdb   L20DC-L1D60 RESTORE  31
         fdb   L213C-L1D60 DELETE   32
         fdb   L213C-L1D60 CHAIN    33
         fdb   L213C-L1D60 SHELL    34
         fdb   L20E0-L1D60 BASE     35
         fdb   L20E0-L1D60 ???      36
         fdb   L20F8-L1D60 REM      37 (Also '!')
         fdb   L20F8-L1D60 (*       38
         fdb   L2029-L1D60 END      39
 endc

L1DD4    lda   <u000A+1   Get LSB of # bytes used by all programs (not data)
L1DD6    pshs  a          Save it
         ldx   <u00A7
         lda   #C$CR      Byte to look for
L1DDC    lsl   ,x
         lsr   ,x
         cmpa  ,x+
         bne   L1DDC
         ldx   <u00A7
         bsr   PrintErr
         ldd   <u00B9
         subd  <u00A7
         pshs  b
         ldx   <u00AF
         stx   <u00AB
         ldy   <u00A7
         lda   #$3D
         lbsr  L2415
 ifeq B09EXEC-true
         lbsr  L20F8
 else
         lda   #$3F
 endc
         lbsr  L2415
         lda   #$20
         ldx   <u0080
L1E04    sta   ,x+
         dec   ,s
         bpl   L1E04
         ldd   #$5E0D
         std   -$01,x
         ldx   <u0080
         bsr   PrintErr
         puls  b,a
         lbsr  L1CC1
         ldx   <u0046
         stx   <u0044
L1E1C    lbra  L1CC7

PrintErr ldy   #$0100
         lda   <errpath
         os9   I$WritLn
         rts

 ifeq B09EXEC-true
L1E29    puls  x
         lbsr  L1CC4
         lbsr  L1F90
         lbsr  L214C
         sty   <u00A7
         ldx   <u00AB
         stx   <u00AF
L1E3B    bsr   L1E4C
         lda   <u00A3
         lbsr  L2415
         cmpa  #$3E
         beq   L1E3B
         cmpa  #$3F
         bne   L1DD4
         bra   L1E1C
L1E4C    lbsr  L233E
         lda   <u00A4
         cmpa  #$01
         bne   L1E62
         ldb   <u00A3
         clra
         lslb
         rola
         leax  >L1D60,pcr
         ldd   d,x
         jmp   d,x
L1E62    cmpa  #$02
         lbne  L2126
L1E68    pshs  x
         ldx   <u00AB
         leax  -$01,x
         stx   <u00AB
         puls  pc,x

L1E72    lbsr  L2167
         cmpa  #$DD
         lbne  L211F
         bsr   L1E68
         lda   #$53
         lbsr  L2415

L1E82    lbsr  L2167
         cmpa  #$4D
         bne   L1E9B
         lbsr  L216E
         bne   L1E96
         lbsr  L216E
         bne   L1E96
         lbsr  L216E
L1E96    lbsr  L22BF
         bsr   L1EC9
L1E9B    lbsr  L21A1
         beq   L1E82
         cmpa  #$4C
         bne   L1EC3
         bsr   L1EC9
         ldb   <u00A4
         cmpb  #$00
         beq   L1EC1
         cmpb  #$03
         bne   L1ECC
         cmpa  #$44
         bne   L1EC1
         bsr   L1EC9
         cmpa  #$4F
         bne   L1EC3
         lbsr  L216E
         cmpa  #$50
         bne   L1ECC
L1EC1    bsr   L1EC9
L1EC3    cmpa  #$51
         beq   L1E82
         bra   L1E68
L1EC9    lbra  L233E
L1ECC    lda   #$18
         bra   L1F36

L1ED0    lbsr  L2415
L1ED3    bsr   L1F1D
         lbsr  L21A1
         beq   L1ED0
L1EDA    lda   #$55
L1EDC    lbsr  L2415
         bra   L1F2B

L1EE1    lbsr  L213C
         lbsr  L21A6
         lbra  L2139

L1EEA    bsr   L1F39
         cmpa  #$45
         bne   L1EFB
         lbsr  L2415
         lbsr  L214C
         bcc   L1F3F
         lbra  L1E4C

L1EFB    lda   #$26
         bra   L1F36

L1EFF    bsr   L1F2B
         bra   L1F49

L1F03    lbsr  L2193
         lbsr  L212D
         lda   <u00A3
         cmpa  #$46
         bne   L1F20
         bsr   L1F1B
         lda   <u00A3
         cmpa  #$47
         bne   L1EDA
         bsr   L1F1B
         bra   L1EDA
L1F1B    bsr   L1EDC
L1F1D    lbra  L213C
L1F20    lda   #$27
         bra   L1F36

L1F24    lbsr  L2193
         bsr   L1F2B
         bsr   L1F2B
L1F2B    lbra  L2176

L1F2E    bsr   L1F39
         cmpa  #$48
         beq   L1F47
         lda   #$1F
L1F36    lbra  L1DD6

L1F39    bsr   L1F1D
         bra   L1EDA

L1F3D    bsr   L1F2B
L1F3F    bra   L1F8D

L1F41    bsr   L1F39
         cmpa  #$45
         bne   L1EFB
L1F47    bsr   L1FB1
L1F49    lbra  L1E4C

L1F4C    ldd   <u00AB
         pshs  y,b,a
         lbsr  L233E
         cmpa  #$1E
         bne   L1F60
         leas  $04,s
         bsr   L1F8D
         cmpa  #$1F
         beq   L1F8A
         rts
L1F60    puls  y,b,a
         std   <u00AB
         bsr   L1F39
         ldx   <u00AB
         leax  -$01,x
         pshs  x
         cmpa  #$1F
         beq   L1F7C
         cmpa  #$21
         beq   L1F7C
         lda   #$21
         bra   L1F36
L1F78    bsr   L1FB1
         lda   #$3A
L1F7C    inc   [,s]
         bsr   L1F8A
         lbsr  L21A1
         beq   L1F78
         puls  pc,x

L1F87    lbsr  L210E
L1F8A    lbsr  L2156
L1F8D    lbra  L210B
 endc
**** decode passed parameters ****
L1F90    sty   <u00A7
         ldx   <u004A
         stx   <u00AF
         stx   <u00AB
         clr   <u00BB
         clr   <u00BC
         rts

LAX1     bsr   L1F90
         inc   <u00A0
         lbsr  L210B
         bsr   L1FC0
         clr   <u00A0
         lda   <u00A3
         cmpa  #$3F
         lbne  L1DD4
L1FB1    lbra  L2415

 ifeq B09EXEC-true
L1FB4    lbsr  L210E
         pshs  x
         lbsr  L2193
         ldb   #$23
         stb   [,s++]
 endc
L1FC0    cmpa  #$4D
         bne   L1FF5
L1FC4    bsr   L1FB1
         ldd   <u00AB
 ifeq B09EXEC-true
         pshs  y,b,a
         lbsr  L233E
         ldd   #$0005
         cmpa  <u00A4
         beq   L1FD8
         stb   <u00A4
         bra   L1FDB
L1FD8    lbsr  L2182
L1FDB    puls  y,b,a
         std   <u00AB
         ldb   <u00A4
         cmpb  #$05
         beq   L1FE8
         lbsr  L225D
L1FE8    lbsr  L2314
 else
         lbsr  L233E
         ldb   <u00A4
         cmpb  #$06
         bne   L1FF5
         lbsr  L210B
 endc
         lbsr  L21A1
         beq   L1FC4
         pshs  a
         lbra  L22F7
L1FF5    rts

 ifeq B09EXEC-true
L1FF6    sty   <u00A9
         lbsr  L2186
         bne   L2007
         sty   <u00A9
         bsr   L2022
         bsr   L1FB1
         bsr   L1F8D
L2007    ldy   <u00A9
         cmpa  #$90
         bne   L201A
         lbsr  L233E
         lbsr  L1F8D
L2014    bsr   L2022
L2016    lda   #$4B
         bsr   L2080
L201A    bsr   L2073
         lbsr  L219B
         beq   L2016
L2021    rts
L2022    lbsr  L219B
         beq   L2021
         bra   L207D

L2029    sty   <u00A9
         lbsr  L2186
         beq   L203A
         cmpa  #$49
         beq   L203E
L2035    ldy   <u00A9
         bra   L2045
L203A    cmpa  #$49
         bne   L2054
L203E    lbsr  L2139
         bra   L2054
L2043    bsr   L2080
L2045    lbsr  SkipSpac
         cmpa  #$0D
L204A    lbeq  L210B
         cmpa  #$5C
         beq   L204A
         bsr   L2085
L2054    lbsr  L219B
         beq   L2043
         rts

L205A    sty   <u00A9
         lbsr  L2186
         beq   L2014
         ldy   <u00A9
         bra   L201A

L2067    sty   <u00A9
         lbsr  L2186
         beq   L2054
         bra   L2035

L2071    bsr   L2078
L2073    inc   <u00BC
         lbra  L2180

L2078    lbsr  L2186
         bne   L20D7
L207D    lbsr  L21A6
L2080    lbra  L2415

L2083    bsr   L2078
L2085    lbra  L213C

* Data table for file access modes?
L2088    fcb   $2c,%00000001 Read mode?
         fcb   $2d,%00000010 Write mode?
         fcb   $f7,%00000011 Update mode?
         fcb   $f8,%00000100 Execution dir mode?
         fcb   $f9,%10000000 Directory mode?
         fcb   $00        End of table marker

L2093    lbsr  L233E
         cmpa  #$54
         bne   L20D7
         bsr   L2073
         bsr   L207D
         bsr   L2085
         lda   <u00A3
         cmpa  #$4C
         bne   L2114
         lda   #$4A
         bsr   L2080
         clr   ,-s
L20AC    bsr   L210B
         leax  <L2088,pcr
L20B1    cmpa  ,x++
         bhi   L20B1
         bne   L20C7
         ldb   -$01,x
         orb   ,s
         stb   ,s
         bsr   L210B
         cmpa  #$E7
         beq   L20AC
         lda   ,s+
         bne   L2080
L20C7    lda   #$0F
         bra   L20D9

L20CB    lbsr  L21A1
         bne   L2114
         bsr   L2080
L20D2    lbsr  L2186
         beq   L20CB
L20D7    lda   #$1C
L20D9    lbra  L1DD6

L20DC    bsr   L214C
         bra   L210B

L20E0    lbsr  SkipSpac
         leay  $01,y
         suba  #$30
         beq   L210B
         cmpa  #$01
         lbne  L21C9
         bsr   L210E
         lda   #$36
         lbsr  L2415
         bra   L210B
L20F8    ldx   <u00AB
         lbsr  SkipSpac
         clra
L20FE    lbsr  L2415
         inc   ,x
         lda   ,y+
         cmpa  #$0D
         bne   L20FE
         leay  -$01,y
 endc

L210B    lbsr  L233E
L210E    ldx   <u00AD
         stx   <u00AB
         lda   <u00A3
L2114    rts

 ifeq B09EXEC-true
L2115    lda   <u00A4
         cmpa  #$00
         beq   L2114
L211B    lda   #E$IllStC
         bra   L20D9

L211F    lda   #E$NoAssg
L2121    bra   L20D9

L2123    lbsr  L233E

* Token types >2 go here
L2126    bsr   L2115
         inc   <u00BC
         lbsr  L21FC
L212D    lda   <u00A3
         cmpa  #$52
         beq   L2139
         cmpa  #$DD   Equals token
         bne   L211F
         lda   #$53
L2139    lbsr  L2415
L213C    lda   #$39
L213E    ldx   <u0044
         clrb
         lbsr  L22BA
L2144    bsr   L21B4
         lbsr  L2262
         bcc   L2144
L214B    rts
L214C    lbsr  SkipSpac
         lbsr  IsNum
         bcs   L214B
         lda   #$3A
L2156    bsr   L217D
         lbsr  L23A6
         beq   L2163
         ldd   ,x
         lbgt  L240C
L2163    lda   #E$IllNum
         bra   L2121
L2167    bsr   L216B
         bsr   L2115
L216B    lbra  L1EC9
L216E    lda   #$8E
         bsr   L2156
         bsr   L216B
         bra   L21A1
L2176    clra
         bsr   L217D
         bsr   L217D
         bra   L218E
L217D    lbra  L2415
L2180    bsr   L216B
L2182    bsr   L2115
         bra   L21FC
L2186    bsr   L210B
         cmpa  #$54
         bne   L2192
         bsr   L2139
L218E    lda   <u00A3
         cmpa  <u00A3
L2192    rts
L2193    bsr   L216B
         lbsr  L2115
L2198    lbra  L210B
L219B    lda   <u00A3
         cmpa  #$51
         beq   L21A5
 endc
L21A1    lda   <u00A3
         cmpa  #$4B
L21A5    rts

 ifeq B09EXEC-true
L21A6    bsr   L21A1
         beq   L21A5
         lda   #$1D
         bra   L21CB
L21AE    clrb
         bsr   L21F5
         lbsr  L210E
L21B4    bsr   L21EA
         bsr   L21CE
         cmpa  #$4D
         beq   L21AE
         ldb   <u00A4
         cmpb  #$06
         beq   L2198
         cmpb  #$04
         bne   L2182
         lbra  L22CA

L21C9    lda   #E$IllOpd
L21CB    lbra  L1DD6

L21CE    cmpa  #$CD
         beq   L21E3
         cmpa  #$EA
         bne   L21A5
         lda   ,y
         lbsr  IsNum
         bcc   L21ED
         cmpa  #'.
         beq   L21ED
         lda   #$CE
L21E3    ldb   #$07
         bsr   L21F5
         lbsr  L210E
L21EA    lbra  L233E
L21ED    leay  -$01,y
         lbsr  L1E68
         lbra  L237A
L21F5    ldx   <u0044
         std   ,--x
         stx   <u0044
         rts
L21FC    ldd   #$8500
L21FF    pshs  b,a
         ldd   <u00A1
         bsr   L21F5
         puls  b,a
         bsr   L21F5
         lbsr  L210E
         lbsr  L210B
         clrb
         cmpa  #$4D
         beq   L2226
L2214    cmpa  #$89
         bne   L2247
         bsr   L2257
         bsr   L2247
         bsr   L21EA
         lbsr  L2115
         ldd   #$8900
         bra   L21FF
L2226    bsr   L2257
         incb
         pshs  b
         lbsr  L2314
         lbsr  L21A1
         bne   L223E
         ldb   ,s+
         cmpb  #$03
         bcs   L2226
         lda   #$2A
         lbra  L1DD6
L223E    bsr   L22BF
         lbsr  L210B
         puls  b
         bra   L2214
L2247    clr   <u00BC
         ldx   <u0044
         addb  ,x++
         lbsr  L2413
         ldd   ,x++
         stx   <u0044
         lbra  L240C
L2257    tst   <u00BC
         beq   L228A
         clr   <u00BC
L225D    lda   #$0E
L225F    lbra  L2415
L2262    ldb   <u00A3
         clra
         cmpb  #$4E
         beq   L228B
         tstb
         bpl   L2273
         lbsr  L1CCD
         bita  #$08
         bne   L228B
L2273    ldx   <u0044
L2275    ldd   ,x++
         cmpa  #$4D
         beq   L22C5
         bsr   L225F
         tstb
         bne   L2275
         cmpa  #$39
         bne   L2287
         lbsr  L1E68
L2287    stx   <u0044
         coma
L228A    rts
L228B    anda  #$07
         tfr   a,b
         ldx   <u0044
         bra   L2297
L2293    lda   ,x++
         bsr   L230F
L2297    cmpb  $01,x
         bcs   L2293
         bhi   L22B8
         cmpb  #$06
         beq   L22B8
         tstb
         bne   L2293
         lda   ,x++
         cmpa  #$4D
         bne   L22B0
         stx   <u0044
         bsr   L22FE
         bra   L2262
L22B0    cmpa  #$39
         beq   L2307
         bsr   L230F
         bra   L2287
L22B8    lda   <u00A3
L22BA    std   ,--x
         stx   <u0044
 endc
L22BE    rts

L22BF    lda   <u00A3
         cmpa  #$4E
         beq   L22BE
L22C5    lda   #$25
L22C7    lbra  L1DD6

 ifeq B09EXEC-true
L22CA    lbsr  L1E68
         lda   <u00A3
         pshs  a
         bsr   L22FE
         ldb   ,s
         lbsr  L1CCD
         leax  <L22F7,pcr
         pshs  x
         anda  #$03
         beq   L230B
         cmpa  #$02
         beq   L231B
         bhi   L2322
         ldb   $02,s
         cmpb  #$92
         beq   L2331
         cmpb  #$94
         beq   L2331
         cmpb  #$BE
         beq   L2326
         bra   L2312
 endc

L22F7    bsr   L22BF
         puls  a
         lbsr  L2415
L22FE    lbra  L210B

 ifeq B09EXEC-true
L2301    lda   <u00A3
         cmpa  #$4D
         beq   L22BE
L2307    lda   #$22
         bra   L22C7
L230B    leas  $02,s
         puls  a
L230F    lbra  L2415
L2312    bsr   L2301
L2314    clra
         lbsr  L213E
         lbra  L1E68

L231B    bsr   L2312
L231D    lbsr  L21A6
         bra   L2314

L2322    bsr   L231B
         bra   L231D

L2326    bsr   L2301
         bsr   L22FE
         cmpa  #$54
         beq   L2314
         lbra  L20D7

L2331    bsr   L2301
         incb
         lbsr  L2413
         lbra  L2180
 endc

L233A    lda   #E$UnkSym
         bra   L22C7

L233E    ldd   <u00AB
         std   <u00AD
         lbsr  SkipSpac
         sty   <u00B9
 ifeq B09EXEC-true
         lbsr  LAX2
         lbne  L23E1
 endc
         lda   ,y
         lbsr  IsNum
         bcc   L237A
         leax  >L1CD3,pcr
         lda   #$80
         lbsr  L252A
         beq   L233A
         ldb   ,x
         leau  <L239D,pcr
         jmp   b,u
L2368    ldd   $01,x
L236A    stb   <u00A4
         sta   <u00A3
         lbra  L2415
* '.' goes here
L2371    lda   ,y         Get char from source
         lbsr  IsNum
         bcs   L2368
         leay  -$01,y
* Starts with numeric (0-9) value
L237A    bsr   L23A6
         bne   L238F
         ldd   #$8F05
L2381    sta   <u00A3
L2383    bsr   L23D6
         lda   ,x+
         decb
         bpl   L2383
         lda   #$06
         sta   <u00A4
         rts
L238F    ldd   #$8E02
         tst   ,x
         bne   L2381
         ldd   #$8D01
         leax  $01,x
         bra   L2381

L239D    leay  -$01,y
         bsr   L23A6
         ldd   #$9102
         bra   L2381
L23A6    lbsr  SkipSpac
         leax  ,y
         ldy   <u0044
         lbsr  L1CCA
         exg   x,y
         bcs   L23BA
         lda   ,x+
         cmpa  #$02
         rts

L23BA    lda   #E$IllLit
         bra   L23DA

* '"' goes here
L23BE    bsr   L2368
         bra   L23C4

L23C2    bsr   L2415
L23C4    lda   ,y+
         cmpa  #$0D
         beq   L23D8
         cmpa  #$22
         bne   L23C2
         cmpa  ,y+
         beq   L23C2
         leay  -$01,y
         lda   #$FF
L23D6    bra   L2415

L23D8    lda   #E$EndQou
L23DA    lbra  L1DD6

L23DD    lda   #E$UndVar
         bra   L23DA

 ifeq B09EXEC-true
L23E1    ldx   <u009E
         lbsr  L2528
         beq   L23EF
         stx   <u00A1
         ldd   ,x
L23EC    lbra  L236A
L23EF    tst   <u00A0
         bmi   L23DD
         ldx   <u0062
         lbsr  L2528
         bne   L2401
         tst   <u00A0
         bne   L23DD
         lbsr  L2494
L2401    ldd   #$8500
         bsr   L23EC
         tfr   x,d
         subd  <u0062
         std   <u00A1
L240C    bsr   L2415
         bsr   L2413
         lda   <u00A3
         rts

L2413    tfr   b,a
 endc
L2415    pshs  x,b,a
         ldx   <u00AB
         sta   ,x+
         stx   <u00AB
         ldd   <u00AB
         subd  <u004A
         cmpb  #$FF
         bcc   L2428
         clra
         puls  pc,x,b,a

L2428    lda   #E$ICOvf
         lbsr  L1CC1
         lbra  L1CC7

LAX2     bsr   SkipSpac
         pshs  y
         ldb   #$02
         stb   <u00A5
         clrb
         bsr   IsAlpha
         bcs   L2459
         leay  $01,y
L243F    incb
         lda   ,y+
         bsr   L246A is alpha or number?
         bcc   L243F .. yes
         cmpa  #'$   is dollar?
         bne   L2451 .. no
         incb
         leay  $01,y
         lda   #$04
         sta   <u00A5
L2451    leay  -$01,y
         lda   #$80
         ora   -$01,y
         sta   -$01,y
L2459    stb   <u00A6
         puls  pc,y

SkipSpac lda   ,y+
         cmpa  #C$SPAC
         beq   SkipSpac
         cmpa  #C$LF
         beq   SkipSpac
         leay  -$01,y
         rts

* Is alpha or numeric*
L246A    bsr   IsAlpha
         bcc   L2493

IsNum    cmpa  #'0
         bcs   L2493
         cmpa  #'9
         bls   L2491
         bra   L248E

IsAlpha  anda  #$7F  Strip high bit
         cmpa  #'A
         bcs   L2493
         cmpa  #'Z
         bls   L2491
         cmpa  #'_
         beq   L2493
         cmpa  #'a
         bcs   L2493
         cmpa  #'z
         bls   L2491
L248E    orcc  #Carry           no
         rts

L2491    andcc #^Carry          yes
L2493    rts

 ifeq B09EXEC-true
L2494    ldx   <u0062
         ldd   -$03,x
         addd  #$0001
         std   -$03,x
         ldb   <u00A6
         clra
         addd  #$0003
         sty   <u00A9
         bsr   L24EE
         pshs  y
         lda   <u00A5
         clrb
         std   ,y++
         clr   ,y+
         ldx   <u00A9
L24B3    lda   ,x+
         sta   ,y+
         bpl   L24B3
         leay  ,x
         puls  pc,x
L24BD    pshs  u,b,a
         ldd   <FREEMEM
         subd  ,s
         bcc   L24CA
         lda   #$20
         lbra  L1DD6
L24CA    std   <FREEMEM
         ldd   <u0066
         subd  ,s
         std   <u0066
         ldu   <u00DA
         ldd   <u00DA
         subd  ,s
         std   <u00DA
         tfr   d,y
         ldd   <u0066
         subd  <u00DA
         addd  <u0068
         bsr   L2508
         ldd   <u0068
         addd  ,s++
         std   <u0068
         leax  ,u
         puls  pc,u
L24EE    pshs  u,b,a
         bsr   L24BD
         subd  ,s
         std   <u0068
         leau  ,x
         leax  $03,y
         stx   <u0062
         ldd   <u0064
         bsr   L2508
         addd  ,s++
         std   <u0064
         leax  ,u
         puls  pc,u
 endc

L2508    pshs  x,b,a
         leax  d,u
         pshs  x
L250E    bitb  #$03
         beq   L251F
         lda   ,u+
         sta   ,y+
         decb
         bra   L250E
L2519    pulu  x,b,a
         std   ,y++
         stx   ,y++
L251F    cmpu  ,s
         bcs   L2519
         clr   ,s++
         puls  pc,x,b,a

* Entry point from L23E1
L2528    lda   #%00100000 Bit pattern to test for end of entry
* Entry: X=Table ptr (ex. command table)
*        Y=Source ptr
*        A=Mask to check for end of entry (%10000000)
*        U=??? (just preserved)
* Exit:  X=Ptr to 2 byte # before matching text string
*        Y=Ptr to byte after matching entry in source
*        Zero flag set if no matching entry found
L252A    pshs  u,y,x,a
         ldu   -$03,x
         ldb   -$01,x
L2530    stx   $01,s
         cmpu  #$0000
         beq   L2558
         leau  -1,u
         ldy   $03,s
         leax  b,x
L253F    lda   ,x+
         eora  ,y+
         beq   L2551
         cmpa  ,s
         beq   L2551
         leax  -$01,x
L254B    lda   ,x+
         bpl   L254B
         bra   L2530
L2551    tst   -$01,x
         bpl   L253F
         sty   $03,s
L2558    puls  pc,u,y,x,a

L255A    pshs  x,b,a
         ldb   [<$04,s]
         leax  <L256A,pcr
         ldd   b,x
         leax  d,x
         stx   $04,s
         puls  pc,x,b,a

* Jump table
L256A
 ifeq B09EXEC-true
         fdb   L2C50-L256A $06e6
         fdb   L30A0-L256A $0b36
         fdb   L2692-L256A $0128
         fdb   L26FD-L256A $0193
 else
         fdb   L256C-L256A  $0002
L256C    rts
 endc

 ifeq B09EXEC-true
L2572    jsr   <u001B     Print error code to screen
         fcb   $02

L2575    jsr   <u001B
         fcb   $06

L2578    jsr   <u001B
         fcb   $14

L257B    jsr   <u001E
         fcb   $08

L257E    jsr   <u001E
         fcb   $06


* Jump table
L2581    fdb   L2D07-L2581 $0786
         fdb   L277F-L2581 $01fe
         fdb   L2728-L2581 $01a7
         fdb   L2783-L2581 $0202
         fdb   L292A-L2581 $03a9
         fdb   L2C88-L2581 $0707
         fdb   L2D20-L2581 $079f
         fdb   L2D20-L2581 $079f
         fdb   L2D20-L2581 $079f
         fdb   L2C88-L2581 $0707
         fdb   L2D20-L2581 $079f
         fdb   L2D20-L2581 $079f
         fdb   L2D20-L2581 $079f
         fdb   L2954-L2581 $03D3
         fdb   L2952-L2581 $03D1
         fdb   L29A4-L2581 $0423
         fdb   L2A30-L2581 $04AF
         fdb   L2A4B-L2581 $04CA
         fdb   L2A62-L2581 $04E1
         fdb   L2A74-L2581 $04F3
         fdb   L2B0C-L2581 $058B
         fdb   L2B5B-L2581 $05DA
         fdb   L2B69-L2581 $05E8
         fdb   L2B81-L2581 $0600
         fdb   L2B88-L2581 $0607
         fdb   L2B9C-L2581 $061b
         fdb   L2BA0-L2581 $061f
         fdb   L2BA4-L2581 $0623
         fdb   L2BC1-L2581 $0640
         fdb   L29AB-L2581 $042a
         fdb   L2A1A-L2581 $0499
         fdb   L29CC-L2581 $044b
         fdb   L308D-L2581 $0b0c
         fdb   L29CC-L2581 $044b
         fdb   L308D-L2581 $0b0c
         fdb   L2C1F-L2581 $069e
         fdb   L2D07-L2581 $0786
         fdb   L2C65-L2581 $06e4
         fdb   L2C88-L2581 $0707
         fdb   L2D07-L2581 $0786
         fdb   L2D07-L2581 $0786
         fdb   L2CC6-L2581 $0745
         fdb   L2CC6-L2581 $0745
         fdb   L2CE2-L2581 $0761
         fdb   L2C65-L2581 $06e4
         fdb   L2C88-L2581 $0707
         fdb   L2CF0-L2581 $076f
         fdb   L2CF0-L2581 $076f
         fdb   L2CFA-L2581 $0779
         fdb   L2D18-L2581 $0797
         fdb   L2D07-L2581 $0786
         fdb   L2D07-L2581 $0786
         fdb   L2D07-L2581 $0786
         fdb   L2D20-L2581 $079f
         fdb   L2D20-L2581 $079f
         fdb   L26C8-L2581 $0147
         fdb   L26C8-L2581 $0147
         fdb   L2C88-L2581 $0707
         fdb   L265D-L2581 $00dc
         fdb   L308D-L2581 $0b0c
         fdb   L308D-L2581 $0b0c
         fdb   L26C1-L2581 $0140
         fdb   L2718-L2581 $0197
         fdb   L2718-L2581 $0197

* Table (called from L2D2C) - If 0, does something @ L308D, otherwise, AND's
*   with $1F, multiplies by 2, and uses result as offset to branch table @
*   L2DA2
L2601    fcb   $20,$20,$06,$00,$43,$40,$28,$25,$00,$43,$43,$43,$43,$43,$43,$43
         fcb   $05,$00,$43,$43,$43,$00,$45,$00,$25,$00,$45,$00,$05,$00,$21,$21
         fcb   $47,$27,$27,$22,$22,$22,$60,$60,$61,$87,$8a,$89,$89,$81,$85,$00
         fcb   $80,$81,$e0,$e0,$e0,$e0,$e0,$6b,$05,$00,$6c,$6c,$6c,$6d,$00,$00
         fcb   $6d,$00,$00,$6e,$00,$00,$00,$6e,$00,$00,$00,$6d,$00,$00,$6d,$00
         fcb   $00,$0d,$00,$00,$06,00,$06,$00,$06,$00,$44,$44

L265D    ldd   ,y
         tst   <u00D9
         bne   L2675
         pshs  d
         leay  -1,y
         ldd   <u0060
L2669    std   <u00AB
         ldd   #$0003
         lbsr  L2578
         puls  b,a
         bra   L2677
L2675    leay  $02,y
L2677    lbsr  L29DE
         bcc   L268E
         std   ,x
         tfr   y,d
         subd  <u005E
         leax  $02,x
L2684    ldu   ,x
         std   ,x
L2688    leax  ,u
         bne   L2684
         bra   L2692
L268E    lda   #$4B
         bsr   L26CE
L2692    leax  >L2581,pcr
         ldb   ,y+
         bpl   L269F
         ldd   #$03D1
         bra   L26A9
L269F    lslb
         clra
         ldd   d,x
         cmpd  #$03D1
         bcs   L26BF
L26A9    tst   <u00C7
         bne   L26BF
         inc   <u00C7
         pshs  b,a
         tfr   y,d
         subd  <u005E
         subd  #$0001
         ldu   <pgmaddr
         std   <$15,u
         puls  b,a
L26BF    jmp   d,x

L26C1    ldx   <pgmaddr
         lda   #$01
         sta   <$17,x
L26C8    ldb   ,y+
         clra
         leay  d,y
         rts

L26CE    pshs  y,x,b,a
         ldx   <pgmaddr
         lda   #$01
         sta   <$17,x
         lda   <u0084
         bmi   L26FB
         ldd   $04,s
         subd  <u005E
         leas  -$05,s
         leax  ,s
         bsr   L26FD
         lda   #$20
         sta   ,x+
         lda   #$02
         leax  ,s
         ldy   #$0005
         os9   I$Write
         leas  $05,s
         ldb   ,s
         lbsr  L2572
L26FB    puls  pc,y,x,b,a

L26FD    bsr   L2701
         tfr   b,a
L2701    pshs  a
         lsra
         lsra
         lsra
         lsra
         bsr   L270D
         puls  a
         anda  #$0F
L270D    adda  #$30
         cmpa  #$39
         bls   L2715
         adda  #$07
L2715    sta   ,x+
         rts
L2718    ldb   ,y
         bsr   L2721
         bne   L2720
L271E    leay  $01,y
L2720    rts

L2721    cmpb  #$3F
         beq   L2727
         cmpb  #$3E
L2727    rts

L2728    lbsr  L2F43
         ldb   <u00CF
         beq   L2733
         lda   #$4C
         bsr   L26CE
L2733    leay  $04,y
         lda   #$40
         sta   <u00CE
         ldd   <u00C1
         pshs  b,a
         clra
         clrb
         std   <u00C1
         bsr   L2787
         ldd   <u00CC
         subd  <u0060
         beq   L277A
         addd  #$0003
         cmpd  <FREEMEM
         lbcc  L2A0D
         pshs  y,x
         lbsr  L257B
         ldd   <u00C1
         leau  ,y
         std   ,y++
         clr   ,y+
         ldx   <u0060
L2762    ldd   ,x++
         subd  <u0062
         std   ,y++
         inc   2,u
         cmpx  <u00CC
         bcs   L2762
         tfr   u,d
         puls  y,x
         subd  <u0066
         std   $01,x
         lda   #$25
         sta   ,x
L277A    puls  b,a
         std   <u00C1
         rts

L277F    lda   #$80
         bra   L2785

L2783    lda   #$60
L2785    sta   <u00CE
L2787    ldd   <u0060
         pshs  x,b,a
         std   <u00CC
L278D    bsr   L27E0
         ldb   ,y+
         cmpb  #$4B
         beq   L278D
         cmpb  #$4C
         beq   L279F
         leay  -$01,y
         ldb   #$01
         bra   L27A3
L279F    lbsr  L283A
         clrb
L27A3    pshs  y,b
         ldx   $03,s
         ldd   <u00CC
         std   $03,s
         stx   <u00CC
         subd  <u00CC
         lslb
         rola
         addd  $03,s
         cmpd  <u00DA
         lbcc  L2A0D
         bra   L27CE
L27BC    ldu   ,x++
         tst   ,s
         beq   L27CB
         lda   ,u
         sta   <u00D1
         lbsr  L3083
         std   <u00D6
L27CB    lbsr  L2878
L27CE    cmpx  $03,s
         bcs   L27BC
         ldd   <u00CC
         std   $03,s
         puls  y,b
         ldb   ,y+
         cmpb  #$51
         beq   L278D
         puls  pc,x,b,a
L27E0    lbsr  L2F43
         ldb   <u00CF
         beq   L27FF
         lda   #$4C
         lbsr  L26CE
         leay  $03,y
         ldb   ,y
         cmpb  #$4D
         bne   L27FE
         leay  $01,y
L27F6    bsr   L282E
         ldb   ,y+
         cmpb  #$4B
         beq   L27F6
L27FE    rts
L27FF    ldd   <u00CC
         addd  #$000A
         cmpd  <u00DA
         lbcc  L2A0D
         ldx   <u00CC
         ldd   <u00D2
         std   ,x++
         leau  ,x
         clr   ,x+
         leay  $03,y
         ldb   ,y
         cmpb  #$4D
         bne   L282B
         leay  $01,y
L281F    bsr   L282E
         std   ,x++
         inc   ,u
         ldb   ,y+
         cmpb  #$4B
         beq   L281F
L282B    stx   <u00CC
         rts
L282E    ldb   ,y+
         clra
         cmpb  #$8D
         beq   L2837
         lda   ,y+
L2837    ldb   ,y+
         rts
L283A    lda   ,y+
         cmpa  #$85
         beq   L285B
         suba  #$40
         sta   <u00D1
         cmpa  #$04
         bne   L2856
         ldb   ,y
         cmpb  #$4F
         bne   L2856
         leay  $01,y
         bsr   L282E
         leay  $01,y
         bra   L2875
L2856    lbsr  L3083
         bra   L2875
L285B    leay  -$01,y
         lbsr  L2F43
         leay  $03,y
         ldb   <u00CF
         cmpb  #$20
         beq   L286D
         lda   #$18
         lbra  L26CE
L286D    ldd   $01,x
         std   <u00D2
         ldx   <u0066
         ldd   d,x
L2875    std   <u00D6
         rts
L2878    ldb   ,x+
         beq   L28D0
         pshs  b
         lslb
         lslb
         lslb
         stb   <u00D0
         lsrb
         lsrb
         leax  b,x
         addb  #$04
         pshs  u,x
         lda   <u00D1
         cmpa  #$04
         bcs   L2893
         addb  #$02
L2893    clra
         cmpd  <FREEMEM
         lbhi  L2A0D
         lbsr  L257B
         ldx   ,s
         leau  $02,y
         ldd   #$0001
         std   ,u++
L28A7    ldd   ,--x
         std   ,u++
         bsr   L28F7
         dec   $04,s
         bne   L28A7
         lda   <u00D1
         cmpa  #$04
         bls   L28BC
         ldd   <u00D2
         std   ,u
         coma
L28BC    ldd   <u00D6
         bcs   L28C2
         std   ,u
L28C2    bsr   L28F7
         tfr   y,d
         puls  u,x
         subd  <u0066
         std   1,u
         leas  $01,s
         bra   L28E0
L28D0    stb   <u00D0
         lda   <u00D1
         cmpa  #$04
         bhi   L28DC
         ldd   <u00D6
         bra   L28DE
L28DC    ldd   <u00D2
L28DE    std   1,u
L28E0    lda   <u00D1
         ora   <u00D0
         ora   <u00CE
         sta   ,u
         pshs  x
         leax  ,u
         lbsr  L2FEE
         ldx   <u00CC
         stu   ,x++
         stx   <u00CC
         puls  pc,x
L28F7    pshs  b,a
         ldb   $02,y
         mul
         bne   L2923
         lda   $01,s
         ldb   $02,y
         mul
         tsta
         bne   L2923
         stb   $02,y
         lda   ,s
         ldb   $03,y
         mul
         tsta
         bne   L2923
         addb  $02,y
         bcs   L2923
         stb   $02,y
         lda   $01,s
         ldb   $03,y
         mul
         adda  $02,y
         bcs   L2923
         std   $02,y
         puls  pc,b,a

L2923    lda   #$49
         lbsr  L26CE
         puls  pc,b,a

L292A    ldu   <u00CA
         bne   L2936
         tfr   y,d
         subd  <u005E
         std   <u00C8
         bra   L293C

L2936    tfr   y,d
         subd  <u005E
         std   ,u
L293C    lbsr  L2D65
         lbsr  L2E52
         ldb   ,y+
         cmpb  #$4B
         beq   L293C
         sty   <u00CA
         ldd   <u00C8
         std   ,y++
         lbra  L271E

L2952    leay  -$01,y
L2954    bsr   L2984
         leay  $01,y
         lbsr  L2D65
         lbsr  L2E52
         sta   <u00D1
         lbsr  L2E52
         cmpa  <u00D1
         beq   L2981
         cmpa  #$02
         bhi   L297E
         beq   L2971
         lda   #$C8
         bra   L2973

L2971    lda   #$CB
L2973    ldb   <u00D1
         cmpb  #$02
         bhi   L297E
         lbsr  L2FBE
         bra   L2981

L297E    lbsr  L2A26
L2981    lbra  L2718

L2984    lda   ,y
         cmpa  #$0E
         lbne  L2D65
         leay  $01,y
         lbsr  L2D65
L2991    lda   -$03,y
         cmpa  #$85
         bcc   L299F
         ldd   <u00D2
         subd  <u0062
         std   -$02,y
         lda   #$85
L299F    adda  #$6D
         sta   -$03,y
         rts

L29A4    bsr   L29A6
L29A6    bsr   L2A1A
         leay  $01,y
         rts

L29AB    ldb   ,y+
         cmpb  #$1E
         beq   L29C5
         leay  -$01,y
         bsr   L29A6
         ldd   ,y++
L29B7    pshs  b,a
         leay  $01,y
         bsr   L29CC
         puls  b,a
         subd  #$0001
         bne   L29B7
         rts

L29C5    ldb   ,y+
         lbsr  L2721
         beq   L29DD
L29CC    ldd   ,y
         bsr   L29DE
         ldd   $02,x
         bcc   L29D7
         sty   $02,x
L29D7    std   ,y
         inc   -$01,y
         leay  $03,y
L29DD    rts
L29DE    ldx   <u0066
         pshs  b,a
         bra   L29ED
L29E4    ldd   ,x
         anda  #$7F
         cmpd  ,s
         beq   L2A08
L29ED    leax  -$04,x
         cmpx  <u00DA
         bcc   L29E4
         ldd   <FREEMEM
         subd  #$0004
         bcs   L2A0D
         std   <FREEMEM
         ldd   ,s
         ora   #$80
         std   ,x
         clra
         clrb
         std   $02,x
         stx   <u00DA
L2A08    lda   ,x
         rola
         puls  pc,b,a
L2A0D    lda   #$20
         sta   <errcode
         lbsr  L26CE
         lbsr  L30EB
         lbra  L2575
L2A1A    lbsr  L2D65
         lbsr  L2E52
         cmpa  #$02
         beq   L2A2B
         bcs   L29DD
L2A26    lda   #$47
         lbra  L26CE

L2A2B    lda   #$C8
         lbra  L2FBE

L2A30    lbsr  L2BAF
         lda   $03,y
         cmpa  #$3A
         beq   L2A3E
         lda   #$10
         lbra  L2BA8

L2A3E    pshs  y
         leay  $04,y
         bsr   L29CC
         tfr   y,d
         subd  <u005E
         std   [,s++]
         rts

L2A4B    ldd   #$1002
         lbsr  L2BDD
         ldu   $01,x
         sty   $01,x
         leay  $02,y
         lbsr  L2718
         tfr   y,d
         subd  <u005E
         std   ,u
         rts

L2A62    ldd   #$1001
         lbsr  L2BDD
         leay  $01,y
L2A6A    tfr   y,d
         subd  <u005E
         std   [<$01,x]
         lbra  L2C01

L2A74    lbsr  L2F43
         lbsr  L2EE3
         cmpa  #$60
         bne   L2A88
         lda   <u00D1
         cmpa  #$01
         beq   L2A94
         cmpa  #$02
         beq   L2A94
L2A88    lda   #$46
         lbsr  L26CE
         ldd   #$FFFF
         std   <u00D2
         bra   L2AA0

L2A94    ldb   <u00D0
         bne   L2A88
         adda  #$80
         sta   ,y
         ldd   $01,x
         std   $01,y
L2AA0    ldx   <u0044
         leax  -$07,x
         stx   <u0044
         lda   <u00D1
         sta   ,x
         ldd   <u00D2
         subd  <u0062
         std   $01,x
         clra
         clrb
         std   $05,x
         leay  $04,y
         bsr   L2AF1
         bsr   L2AD4
         std   $03,x
         lda   ,y
         cmpa  #$47
         bne   L2AC6
         bsr   L2AD4
         std   $05,x
L2AC6    leay  $01,y
         sty   ,--x
         lda   #$13
         sta   ,-x
         stx   <u0044
         leay  $03,y
L2AD3    rts
L2AD4    ldd   <u00C1
         pshs  b,a
         std   $01,y
         ldx   <u0044
         lda   ,x
         leax  >L307E,pcr
         ldb   a,x
         clra
         addd  <u00C1
         std   <u00C1
         leay  $03,y
         bsr   L2AF1
         ldx   <u0044
         puls  pc,b,a
L2AF1    lbsr  L2D65
         lbsr  L2E52
         cmpa  ,u
         beq   L2AD3
         cmpa  #$02
         bcs   L2B07
         lbne  L2A26
         lda   #$C8
         bra   L2B09
L2B07    lda   #$CB
L2B09    lbra  L2FBE

L2B0C    leay  -$01,y
         ldd   #$130B
         lbsr  L2BDD
         ldd   $02,y
         cmpd  $04,x
         beq   L2B22
         lda   #$46
         lbsr  L26CE
         bra   L2B51
L2B22    addd  <u0062
         exg   d,x
         ldx   $01,x
         exg   d,x
         std   $02,y
         lda   $03,x
         anda  #$02
         sta   $01,y
         ldd   $06,x
         std   $04,y
         ldd   $08,x
         std   $06,y
         beq   L2B3E
         inc   $01,y
L2B3E    ldu   $01,x
         tfr   y,d
         subd  <u005E
         addd  #$0001
         std   ,u
         leau  3,u
         tfr   u,d
         subd  <u005E
         std   $08,y
L2B51    leay  $0B,y
         lbsr  L2C01
         leax  $07,x
         stx   <u0044
         rts

L2B5B    leau  -$01,y
         pshs  u
         bsr   L2BAF
         puls  b,a
         std   ,y
         lda   #$15
         bra   L2BA8

L2B69    ldd   #$1503
         bsr   L2BDD
         ldx   $01,x
         ldd   ,x
         subd  <u005E
         std   ,y
         leay  $03,y
         tfr   y,d
         subd  <u005E
         std   ,x
         lbra  L2C01

L2B81    lda   #$17
L2B83    lbsr  L271E
         bra   L2BD3

L2B88    bsr   L2BAF
         lda   #$17
L2B8C    leay  -$01,y
         ldb   #$03
         bsr   L2BDD
         ldd   $01,x
         subd  <u005E
         std   $01,y
         leay  $04,y
         bra   L2C01

L2B9C    lda   #$19
         bra   L2B83

L2BA0    lda   #$19
         bra   L2B8C

L2BA4    bsr   L2BAF
         lda   #$1B
L2BA8    bsr   L2BD3
         leay  $03,y
         lbra  L2718
L2BAF    lbsr  L2D65
         lbsr  L2E52
         cmpa  #$03
         beq   L2BBE
         lda   #$47
         lbsr  L26CE
L2BBE    leay  $01,y
         rts

L2BC1    ldd   #$1B03
         bsr   L2BDD
         leau  ,y
         leay  $03,y
         lbsr  L2A6A
         stu   ,--x
         lda   #$1C
         bra   L2BD8
L2BD3    ldx   <u0044
         sty   ,--x
L2BD8    sta   ,-x
         stx   <u0044
         rts
L2BDD    pshs  a
         ldx   <u0044
         bra   L2BE5
L2BE3    leax  $03,x
L2BE5    cmpx  <u0046
         bcc   L2BF3
         lda   ,x
         cmpa  #$1C
         beq   L2BE3
         cmpa  ,s
         beq   L2BFF
L2BF3    leas  $03,s
         lda   #$45
         lbsr  L26CE
         leay  b,y
         lbra  L2718
L2BFF    puls  pc,a
L2C01    ldx   <u0044
         bra   L2C14
L2C05    lda   ,x
         cmpa  #$1C
         bne   L2C1A
         tfr   y,d
         subd  <u005E
         std   [<$01,x]
         leax  $03,x
L2C14    cmpx  <u0046
         bcs   L2C05
         bra   L2C1C
L2C1A    leax  $03,x
L2C1C    stx   <u0044
         rts

L2C1F    leay  -$01,y
         lbsr  L2F43
         lda   <u00CF
         beq   L2C41
         cmpa  #$A0
         beq   L2C4E
         cmpa  #$60
         bcs   L2C3A
         lda   <u00D0
         bne   L2C3A
         lda   <u00D1
         cmpa  #$04
         beq   L2C4E
L2C3A    lda   #$4C
         lbsr  L26CE
         bra   L2C4E
L2C41    lda   #$A0
         sta   ,x
         ldd   <u00C5
         std   $01,x
         addd  #$0002
         std   <u00C5
L2C4E    leay  $03,y
L2C50    ldb   ,y+
         cmpb  #$4D
         bne   L2C64
L2C56    lbsr  L2984
         lbsr  L2E52
         ldb   ,y+
         cmpb  #$4B
         beq   L2C56
         leay  $01,y
L2C64    rts

L2C65    bsr   L2CB2
         leay  -$01,y
         cmpb  #$90
         bne   L2C72
         lbsr  L2D0B
         leay  $01,y
L2C72    lbsr  L2984
         lbsr  L2E52
         cmpa  #$05
         bcs   L2C81
         lda   #$4D
         lbsr  L26CE
L2C81    lda   ,y+
         cmpa  #$4B
         beq   L2C72
         rts

L2C88    bsr   L2CB2
         cmpb  #$49
         bne   L2C92
         bsr   L2D0B
L2C90    ldb   ,y+
L2C92    cmpb  #$4B
         beq   L2C90
         cmpb  #$51
         beq   L2C90
         lbsr  L2721
         beq   L2CC5
         leay  -$01,y
         lbsr  L2D65
         lbsr  L2E52
         cmpa  #$05
         bcs   L2C90
         lda   #$47
         lbsr  L26CE
         bra   L2C90

L2CB2    ldb   ,y+
         cmpb  #$54
         bne   L2CC5
         lbsr  L2A1A
L2CBB    ldb   ,y+
         cmpb  #$4B
         beq   L2CBB
         cmpb  #$51
         beq   L2CBB
L2CC5    rts

L2CC6    leay  $01,y
         lbsr  L2984
         lbsr  L2E52
         cmpa  #$01
         beq   L2CD5
         lbsr  L2A26
L2CD5    leay  $01,y
         bsr   L2D0B
         lda   ,y+
         cmpa  #$4A
         bne   L2CE1
         leay  $02,y
L2CE1    rts

L2CE2    bsr   L2D02
         bsr   L2D65
         lbsr  L2E52
         cmpa  #$42
         bls   L2D20
         lbra  L2A26

L2CF0    bsr   L2D02
         lbsr  L2984
         lbsr  L2E52
L2CF8    bra   L2D20

L2CFA    bsr   L2D02
         cmpb  #$4B
         beq   L2CFA
         bra   L2D20
L2D02    leay  $01,y
         lbra  L29A6

L2D07    bsr   L2D0B
         bra   L2D20

L2D0B    bsr   L2D65
         lbsr  L2E52
         cmpa  #$04
         beq   L2D17
         lbsr  L2A26
L2D17    rts

L2D18    ldb   ,y+
         cmpb  #$3A
         lbeq  L29CC
L2D20    lbra  L2718
L2D23    cmpb  #$96
         bcc   L2D2C
         lbsr  L2E5F
         bra   L2D65
L2D2C    cmpb  #$F2
         lbcc  L308D
         subb  #$96
         leax  >L2601,pcr
         leax  b,x
         ldb   ,x
         lbeq  L308D
         andb  #$1F
         beq   L2D4A
         leau  <L2DA2,pcr
         lslb
         jsr   b,u
L2D4A    ldb   ,x
         andb  #$E0
         beq   L2D60
         clra
         rolb
         rola
         rolb
         rola
         rolb
         rola
         cmpa  #$07
         bne   L2D60
         lbsr  L2FD4
         bra   L2D65
L2D60    lbsr  L2E3B
         leay  $01,y
L2D65    ldb   ,y
         bmi   L2D23
         rts
L2D6A    bsr   L2D6F
         incb
         bra   L2D71
L2D6F    ldb   #$C8
L2D71    lbsr  L2E52
         cmpa  #$02
         bcs   L2D85
         beq   L2D7E
         bsr   L2DC3
         bra   L2D83
L2D7E    tfr   b,a
         lbsr  L2FBE
L2D83    lda   #$01
L2D85    rts
L2D86    bsr   L2D8B
         incb
         bra   L2D8D
L2D8B    ldb   #$CB
L2D8D    lbsr  L2E52
         cmpa  #$02
         beq   L2DA1
         bcs   L2D9A
         bsr   L2DC3
         bra   L2D9F
L2D9A    tfr   b,a
         lbsr  L2FBE
L2D9F    lda   #$02
L2DA1    rts
L2DA2    bra   L2DC0
         bra   L2D6F
         bra   L2D6A
         bra   L2D8B
         bra   L2D86
         bra   L2DDE
         bra   L2DC8
         bra   L2DF4
         bra   L2DF2
         bra   L2DFF
         bra   L2E04
         bra   L2E30
         bra   L2E2E
         bra   L2E13
         bra   L2E09
L2DC0    lbra  L308D
L2DC3    lda   #$43
         lbra  L26CE
L2DC8    bsr   L2DE7
         pshs  a
         bsr   L2DE7
         cmpa  ,s+
         beq   L2DE0
         lda   #$CB
         bcc   L2DD7
         inca
L2DD7    lbsr  L2FBE
         lda   #$02
         bra   L2DE4
L2DDE    bsr   L2DE7
L2DE0    cmpa  #$02
         bne   L2DE6
L2DE4    inc   ,y
L2DE6    rts
L2DE7    bsr   L2E52
         cmpa  #$02
         bls   L2DF1
         bsr   L2DC3
         lda   #$02
L2DF1    rts
L2DF2    bsr   L2DF4
L2DF4    bsr   L2E52
         cmpa  #$04
         beq   L2DFE
         bsr   L2DC3
         lda   #$04
L2DFE    rts
L2DFF    lbsr  L2D6F
         bra   L2DF4
L2E04    lbsr  L2D6A
         bra   L2DF4
L2E09    lda   #$03
         bsr   L2E20
         bne   L2E13
         ldb   #$03
         bra   L2E1B
L2E13    lda   #$04
         bsr   L2E20
         bne   L2DC8
         ldb   #$02
L2E1B    addb  ,y
         stb   ,y
         rts
L2E20    ldu   <u0044
         cmpa  ,u+
         bne   L2E2D
         cmpa  ,u+
         bne   L2E2D
         stu   <u0044
         clrb
L2E2D    rts
L2E2E    bsr   L2E30
L2E30    bsr   L2E52
         cmpa  #$03
         beq   L2E3A
         bsr   L2DC3
         lda   #$03
L2E3A    rts
L2E3B    cmpa  #$00
         bne   L2E41
         lda   #$01
L2E41    ldu   <u0044
         cmpa  #$05
         bne   L2E4D
         ldd   <u00D4
         std   ,--u
         lda   #$05
L2E4D    sta   ,-u
         stu   <u0044
         rts
L2E52    ldu   <u0044
         lda   ,u+
         cmpa  #$05
         bne   L2E5C
         leau  2,u
L2E5C    stu   <u0044
         rts
L2E5F    cmpb  #$85
         lbcs  L308D
         cmpb  #$89
         bcs   L2EAB
         subb  #$8D
         lbcs  L2F07
         leau  <L2E75,pcr
         lslb
         jmp   b,u

L2E75    bra   L2E87
         bra   L2E89
         bra   L2E8F
         bra   L2E95
         bra   L2E89
         bra   L2E9F
         bra   L2EA8
         bra   L2E9F
         bra   L2EA8

L2E87    leay  -$01,y
L2E89    leay  $03,y
         lda   #$01
         bra   L2E3B
L2E8F    leay  $06,y
         lda   #$02
         bra   L2E3B
L2E95    ldb   ,y+
         cmpb  #C$EOS
         bne   L2E95
         lda   #$04
         bra   L2E3B
L2E9F    lbsr  L2991
         bsr   L2E52
         lda   #$01
         bsr   L2E3B
L2EA8    leay  $01,y
         rts
L2EAB    lbsr  L2F43
         bsr   L2EE3
         cmpa  #$60
         beq   L2EBF
         cmpa  #$80
         beq   L2EBF
         lda   #$12
         lbsr  L26CE
         bra   L2EDC
L2EBF    ldb   #$85
         lbsr  L2F5E
         ldb   ,y
         cmpb  #$85
         bne   L2EDC
         ldb   <u00CF
         cmpb  #$60
         bne   L2EDC
         cmpa  #$05
         bcc   L2EDC
         adda  #$80
         sta   ,y
         ldd   $01,x
         std   $01,y
L2EDC    lda   <u00D1
         leay  $03,y
         lbra  L2E3B
L2EE3    lda   <u00CF
         cmpa  #$00
         bne   L2F06
         ldd   #$0060
         sta   <u00D0
         stb   <u00CF
         lda   #$60
         ora   <u00D1
         sta   ,x
         anda  #$07
         cmpa  #$04
         bne   L2F01
         ldd   #$0020
         std   $01,x
L2F01    lbsr  L2FEE
         lda   <u00CF
L2F06    rts
L2F07    bsr   L2F43
         ldb   #$89
         bsr   L2F5E
         lbsr  L2E52
         cmpa  #$05
         beq   L2F19
         ldu   #$FFFF
         bra   L2F1B
L2F19    ldu   -2,u
L2F1B    pshs  u
         bsr   L2EDC
         puls  u
         cmpu  #$FFFF
         beq   L2F3E
         ldb   2,u
         stb   <u00D6
         ldd   <u00D2
         subd  <u0062
         leau  3,u
L2F31    cmpd  ,u++
         beq   L2F5D
         dec   <u00D6
         bne   L2F31
         lda   #$14
         bra   L2F40
L2F3E    lda   #$42
L2F40    lbra  L26CE
L2F43    ldd   $01,y
         addd  <u0062
         std   <u00D2
         ldx   <u00D2
L2F4B    lda   ,x
         anda  #$E0
         sta   <u00CF
         lda   ,x
         anda  #$18
         sta   <u00D0
         lda   ,x
         anda  #$07
         sta   <u00D1
L2F5D    rts
L2F5E    pshs  b
         ldb   ,y
         subb  ,s+
         bne   L2F73
         tst   <u00D0
         beq   L2F9D
         lda   #$05
         sta   <u00D1
         ldd   #$FFFF
         bra   L2FB9
L2F73    lslb
         lslb
         lslb
         cmpb  <u00D0
         beq   L2F7F
         lda   #$41
         lbsr  L26CE
L2F7F    lda   #$C8
         sta   <u00D8
L2F83    lbsr  L2E52
         cmpa  #$02
         bcs   L2F97
         beq   L2F93
         lda   #$47
         lbsr  L26CE
         bra   L2F97
L2F93    lda   <u00D8
         bsr   L2FBE
L2F97    inc   <u00D8
         subb  #$08
         bne   L2F83
L2F9D    lda   <u00D1
         cmpa  #$05
         bne   L2FBD
         ldd   $01,x
         addd  <u0066
         tfr   d,u
         ldb   <u00D0
         beq   L2FB5
         lsrb
         lsrb
         addb  #$04
         ldd   b,u
         bra   L2FB7
L2FB5    ldd   2,u
L2FB7    addd  <u0066
L2FB9    std   <u00D4
         lda   <u00D1
L2FBD    rts
L2FBE    pshs  x,b
         ldx   <FREEMEM
         cmpx  #$0010
         lbls  L2A0D
         ldx   <u0060
         sta   ,x+
         stx   <u00AB
         clrb
         bsr   L2FDA
         puls  pc,x,b
L2FD4    ldd   <u0060
         std   <u00AB
         ldb   #$01
L2FDA    clra
         lbra  L2578

* Jump tables
L2FDE    fdb   L3027-L2FDE $0049
         fdb   L303A-L2FDE $005c
         fdb   L303E-L2FDE $0060
         fdb   L3048-L2FDE $006a

L2FE6    fdb   L304C-L2FE6 $0066
         fdb   L3058-L2FE6 $0072
         fdb   L3058-L2FE6 $0072
         fdb   L305C-L2FE6 $0076

L2FEE    pshs  u,y,x
         leay  <L2FDE,pcr
         ldb   ,x
         andb  #$E0
         cmpb  #$60
         beq   L3005
         cmpb  #$40
         beq   L3005
         cmpb  #$80
         bne   L3025
         leay  $08,y
L3005    ldb   ,x
         andb  #$18
         beq   L300F
         ldd   $06,y
         bra   L3023
L300F    ldb   ,x
         andb  #$07
L3013    cmpb  #$04
         bcs   L3021
         bhi   L301D
         ldd   $02,y
         bra   L3023
L301D    ldd   $04,y
         bra   L3023
L3021    ldd   ,y
L3023    jsr   d,y
L3025    puls  pc,u,y,x

L3027    lda   ,x
         anda  #$07
         leay  $01,x
         bsr   L3083
L302F    pshs  b,a
         ldd   <u00C1
         std   ,y
         addd  ,s++
         std   <u00C1
         rts

L303A    bsr   L3069
         bra   L302F

L303E    bsr   L3069
         addd  <u0066
         tfr   d,x
         ldd   ,x
         bra   L302F

L3048    bsr   L3060
         bra   L302F

L304C    leay  $01,x
L304E    ldd   <u00C3
         std   ,y
         addd  #$0004
         std   <u00C3
         rts

L3058    bsr   L3069
         bra   L304E

L305C    bsr   L3060
         bra   L304E

L3060    ldd   $01,x
         addd  <u0066
         tfr   d,y
         ldd   $02,y
         rts
L3069    ldd   #$0004
         lbsr  L257B
         ldx   $04,s
         ldd   $01,x
         std   $02,y
         tfr   y,d
         subd  <u0066
         std   $01,x
         ldd   $02,y
         rts
* Table of # bytes/var type
L307E    fcb   1          1 byte =Byte
         fcb   2          2 bytes=Integer
         fcb   5          5 bytes=Real
         fcb   1          1 byte =Boolean
         fcb   $20        ??? Flag String value? (or default size=32 bytes)

* Entry: A=Variable type (0-4)
* Exit : B=# bytes to represent variable
L3083    pshs  x          Preserve X
         leax  <L307E,pc  Point to 5 1-byte entry table
         ldb   a,x        D=#
         clra
         puls  pc,x

L308D    ldy   <u0060
         lda   #$30
         lbra  L26CE

* Single byte entry table
L3095    fcb   $01,$02,$03,$07,$08,$09,$37,$38,$3e,$3f,$ff

L30A0    ldd   #$0016
         std   <u00C1
         clrb
         std   <u00C3
         std   <u00C5
         sta   <u00C7
         std   <u00C8
         std   <u00CA
         ldx   <pgmaddr
         sta   <$17,x
         std   <$15,x
L30B8    ldy   <u005E
         bra   L30E2

L30BD    pshs  y
         lbsr  L2692
         puls  x
         ldb   <u00D9
         bne   L30E2
         lda   ,x
         leau  <L3095,pcr
L30CD    cmpa  ,u+
         bcs   L30E2
         bne   L30CD
         pshs  x
         tfr   y,d
         subd  ,s++
         leay  ,x
         ldu   <u004A
         stu   <u00AB
         lbsr  L2578
L30E2    ldx   <u0060
         clr   ,x
         cmpy  <u0060
         bcs   L30BD
L30EB    ldx   <u0066
         bra   L310B
L30EF    lda   ,x
         bpl   L310B
         anda  #$7F
         sta   ,x
         ldy   $02,x
L30FA    ldu   ,y
         ldd   ,x
         std   ,y
         dec   -$01,y
         lda   #$4A
         lbsr  L26CE
         leay  ,u
         bne   L30FA
L310B    leax  -$04,x
         cmpx  <u00DA
         bcc   L30EF
         ldd   <u0066
         subd  <u00DA
         addd  <FREEMEM
         std   <FREEMEM
         ldx   <u0044
         bra   L3131
L311D    ldy   $01,x
         lda   #$45
         lbsr  L26CE
         lda   ,x
         cmpa  #$13
         bne   L312D
         leax  $07,x
L312D    leax  $03,x
         stx   <u0044
L3131    cmpx  <u0046
         bcs   L311D
         ldu   <u0066
         ldy   <u0060
         ldd   <u0064
         addd  <u0068
         lbsr  L257E
         ldx   <pgmaddr
         ldd   <u00C8
         std   <$13,x
         ldd   <u00C1
         std   <$11,x
         addd  <u00C5
         std   <u00C5
         std   $0B,x
         ldb   <$18,x
         clra
         addd  #$0019
         std   $09,x
         addd  <u0060
         subd  <u005E
         std   $0F,x
         addd  <u0068
         addd  #$0003
         std   $0D,x
         subd  #$0003
         addd  <u0064
         std   $02,x
         addd  <pgmaddr
         std   <u004A
         subd  <restop
         std   <u000A
         ldd   <pgmaddr
         addd  $0D,x
         std   <u0062
         ldd   <pgmaddr
         addd  $0F,x
         std   <u0066
         ldu   <u0062
         bra   L31E2
L3188    leax  ,u
         lbsr  L2F4B
         lda   <u00CF
         cmpa  #$60
         bcs   L31BD
         cmpa  #$A0
         bne   L319F
         ldd   $01,x
         addd  <u00C1
         std   $01,x
         bra   L31DC
L319F    cmpa  #$80
         bne   L31BD
         ldb   <u00D0
         bne   L31B1
         lda   <u00D1
         cmpa  #$04
         bcc   L31B1
         leax  1,u
         bra   L31B7
L31B1    ldd   1,u
         addd  <u0066
         tfr   d,x
L31B7    ldd   ,x
         addd  <u00C5
         std   ,x
L31BD    lda   <u00D1
         cmpa  #$05
         bne   L31DC
         ldb   <u00D0
         beq   L31CD
         lsrb
         lsrb
         addb  #$04
         bra   L31CF
L31CD    ldb   #$02
L31CF    clra
         addd  1,u
         ldx   <u0066
         leay  d,x
         ldd   ,y
         ldd   d,x
         std   ,y
L31DC    leau  3,u
L31DE    lda   ,u+
         bpl   L31DE
L31E2    cmpu  <u004A
         bcs   L3188
         rts
 endc

* Called by <$24 JMP vector
* Entry: X=byte after the last vector installed ($2D)
*        D=Last vector offset from start of BASIC09's module header
* Based on function code following the JMP that came here, this routine
*  modifies the return address to 1 of 7 routines
L31E8    pshs  x,d        Preserve ptr & offset
         ldb   [<$04,s]
         leax  <L31F8,pcr
         ldd   b,x
         leax  d,x
         stx   $04,s
         puls  pc,x,b,a

* Vector table for <$24 calls
L31F8    fdb   UNK5-L31F8 Function 0 call
         fdb   L32DD-L31F8 Function 1 call
         fdb   L3B5F-L31F8 Function 2 call
         fdb   L39FB-L31F8 Function 3 call  (error message)
         fdb   L33AE-L31F8 Function 4 call
         fdb   L3A69-L31F8 Function 5 call
         fdb   L3A73-L31F8 Function 6 call

L3206    jsr   <u001B
         fcb   $06
L3209    jsr   <u001B
         fcb   $0C
L320C    jsr   <u001B
         fcb   $0E
L320F    jsr   <u001B
         fcb   $02
L3212    jsr   <u001B
         fcb   $00
L3215    jsr   <u001B
         fcb   $0A
L3218    jsr   <u001B
         fcb   $10
L321B    jsr   <u001E
         fcb   $06
L321E    jsr   <u0027
         fcb   $04
L3221    jsr   <u0027
         fcb   $0A
L3224    jsr   <u0027
         fcb   $02
L3227    jsr   <u0027
         fcb   $0C
L322A    jsr   <u0027
         fcb   $0E
L322D    jsr   <u0027     Use module header jump vector #5
         fcb   $00        Function code
L3230    jsr   <u002A     Use module header jump vector #6
         fcb   $02        Function code
 ifeq B09EXEC-true
L3233    jsr   <u001B     Use module header jump vector #1
         fcb   $18
L3236    jsr   <u001B
         fcb   $16
L3239    jsr   <u001B
         fcb   $1A
L323C    jsr <u001B
         fcb   $1C
 endc

* Jump table (from L323F+offset)
L323F    fdb   L3A51-L323F
         fdb   L3A51-L323F              PARAM
         fdb   L3A51-L323F              TYPE
         fdb   L3A51-L323F              DIM
         fdb   L3A51-L323F              DATA
         fdb   STOP-L323F
         fdb   UNK1-L323F
         fdb   L3A69-L323F
         fdb   L3A73-L323F
         fdb   PAUSE-L323F
         fdb   DEG-L323F
         fdb   RAD-L323F
         fdb   RETURN-L323F
         fdb   L33AE-L323F
         fdb   LET-L323F
         fdb   POKE-L323F
         fdb   IF-L323F
         fdb   GOTO-L323F               ELSE
         fdb   ENDIF-L323F
         fdb   FOR-L323F
         fdb   NEXT-L323F
         fdb   UNTIL-L323F              WHILE
         fdb   GOTO-L323F               ENDWHILE
         fdb   L33AE-L323F
         fdb   UNTIL-L323F
         fdb   L33AE-L323F              LOOP
         fdb   GOTO-L323F               ENDLOOP
         fdb   UNTIL-L323F              EXITIF
         fdb   GOTO-L323F               ENDEXIT
         fdb   ON-L323F
         fdb   ERROR-L323F
         fdb   ERRS51-L323F
         fdb   GOTO-L323F
         fdb   ERRS51-L323F
         fdb   GOSUB-L323F
         fdb   RUN-L323F
         fdb   KILL-L323F
         fdb   INPUT-L323F
         fdb   PRINT-L323F
         fdb   CHD-L323F
         fdb   CHX-L323F
         fdb   CREATE-L323F
         fdb   OPEN-L323F
         fdb   SEEK-L323F
         fdb   READ-L323F
         fdb   WRITE-L323F
         fdb   GET-L323F
         fdb   PUT-L323F
         fdb   CLOSE-L323F
         fdb   RESTORE-L323F
         fdb   DELETE-L323F
         fdb   CHAIN-L323F
         fdb   SHELL-L323F
         fdb   BASE0-L323F
         fdb   BASE1-L323F
         fdb   L3A48-L323F               REM
         fdb   L3A48-L323F
         fdb   END-L323F
         fdb   L33AC-L323F
         fdb   L33AC-L323F
         fdb   L3A4E-L323F
         fdb   ERRS51-L323F
         fdb   L33AB-L323F              RTS
         fdb   L33AB-L323F
         fdb   CpMbyte-L323F
         fdb   CpMint-L323F
         fdb   CpMreal-L323F
         fdb   CpMbyte-L323F
         fdb   CpMstrin-L323F
         fdb   CpMarray-L323F

STOPMSG  fcc   "STOP Encountered"
         fcb   C$LF,C$EOS

* Vector #2 from table at L31F8 comes here

L32DD    lda   $17,x      Get something
         bita  #$01       check if 1st bit is set
         beq   L32E8      no, skip ahead
         ldb   #$33
         bra   L3304

L32E8    tfr   s,d
         subd  #$0100
         cmpd  <u0080
         bcc   L32F6
         ldb   #$39
         bra   L3304
L32F6    ldd   <FREEMEM
         subd  $0B,x
         bcs   L3302
         cmpd  #$0100
         bcc   L3307
L3302    ldb   #$20
L3304    lbra  L39FB
L3307    std   <FREEMEM
         tfr   y,d
         subd  $0B,x
         exg   d,u
         sts   5,u
         std   7,u
         stx   3,u
L3316    ldd   #$0001
         std   <u0042  Set base 1
         sta   1,u
         sta   <$13,u
         stu   <$14,u
         bsr   L3351
         ldd   <$13,x
         beq   L332C
         addd  <u005E
L332C    std   <DATAPtr
         ldd   $0B,x
         leay  d,u
         pshs  y
         ldd   <$11,x
         leay  d,u
         clra
         clrb
         bra   L333F
L333D    std   ,y++
L333F    cmpy  ,s
         bcs   L333D
         leas  $02,s
         ldx   <pgmaddr
         ldd   <u005E
         addd  <$15,x
         tfr   d,x
         bra   L3391
L3351    stx   <pgmaddr
         stu   <u0031
         ldd   $0D,x
         addd  <pgmaddr
         std   <u0062
         ldd   $0F,x
         addd  <pgmaddr
         std   <u0066
         std   <u0060
         ldd   $09,x
         addd  <pgmaddr
         std   <u005E
         ldd   <$14,u
         std   <u0046
         std   <u0044
         rts
L3371    stx   <u005C
         lda   <u0034           check if signal received
         beq   L338F            no, execute next instruction
 ifeq B09EXEC-true
         bpl   L3382
 else
         bpl   L338F            else flag signal received
 endc
         anda  #$7F
         sta   <u0034
 ifeq B09EXEC-true
         lbsr  L3233
         lda   <u0034
L3382    rora
         bcc   L338F
         leay  ,x
         lbsr  L3218
         clr   <u0074
         lbsr  L3236
 else
         ldb   <u0035
         bra   L3304            process it
 endc
L338F    bsr   L33AE
L3391    cmpx  <u0060
         bcs   L3371
         bra   L33A1

END      ldb   ,x
         lbsr  NextInst
         beq   L33A1
         lbsr  PRINT
L33A1    lbsr  L3A73
         ldu   <u0031
         lds   5,u
         ldu   7,u
L33AB    rts

L33AC    leax  $02,x
L33AE    ldb   ,x+
         bpl   L33B4
         addb  #$40
L33B4    lslb
         clra
         ldu   <table1
         ldd   d,u
         jmp   d,u              go to instruction

IF       jsr   <u0016           if...
         tst   $02,y
         beq   GOTO             = FALSE
         leax  $03,x            THEN
         ldb   ,x
         cmpb  #$3B
         bne   L33AB
         leax  $01,x            ELSE

GOTO     ldd   ,x
         addd  <u005E
         tfr   d,x
         rts

ENDIF    leax  $01,x
         rts

UNTIL    jsr   <u0016
         tst   $02,y
         beq   GOTO             = FALSE
         leax  $03,x
         rts

* NEXT table
L33DF    fdb   INTStp1P-L33DF
         fdb   INTStpXP-L33DF
         fdb   REALSt1P-L33DF
         fdb   REALStXP-L33DF

* NEXT routine
NEXT     leay  <L33DF,pc  Point to table
L33EA    ldb   ,x+
         lslb
         ldd   b,y
         ldu   <u0031
         jmp   d,y

INTStp1  ldd   ,x
         leay  d,u
         bra   L3410

INTStpX  ldd   ,x
         leay  d,u
         ldd   $04,x
         lda   d,u
         bpl   L3410
         bra   L3430

* FOR .. NEXT / INTEGER
INTStp1P
         ldd   ,x               offset counter
         leay  d,u              address counter
         ldd   ,y
         addd  #$0001           increment counter
         std   ,y
L3410    ldd   $02,x            offset target
         leax  $06,x
         ldd   d,u              target value
         cmpd  ,y
         bge   GOTO             loop again
         leax  $03,x
         rts

* FOR .. NEXT .. STEP / INTEGER
INTStpXP
         ldd   ,x         Y=ptr to current FOR/NEXT INTEGER value
         leay  d,u
         ldd   $04,x
         ldd   d,u
         pshs  a
         addd  ,y               update counter
         std   ,y
         tst   ,s+
         bpl   L3410            incrementing
L3430    ldd   $02,x
         leax  $06,x
         ldd   d,u
         cmpd  ,y
         ble   GOTO             loop again
         leax  $03,x
         rts

REALSt1  ldy   <u0046
         clrb
         bsr   L348E
         bra   L347E

REALStX  ldy   <u0046
         clrb
         bsr   L348E
         ldd   $04,x
         addd  #$0004
         ldu   <u0031
         lda   d,u
         lsra                   sign
         bcc   L347E
         bra   L34CC

* FOR .. NEXT / REAL
REALSt1P
         ldy   <u0046
         clrb
         bsr   L348E
         leay  -6,y
         ldd   #$0180           step 1 (save in temp var)
         std   $01,y
         clra
         clrb
         std   $03,y
         sta   $05,y
         lbsr  L321E
         bsr   L34DC
         ldd   $01,y
         std   ,u
         ldd   $03,y
         std   2,u
         lda   $05,y
         sta   4,u
L347E    ldb   #$02             incrementing
         bsr   L348E
         leax  $06,x
         lbsr  L3221
         lble  GOTO             loop again
         leax  $03,x
         rts

L348E    ldd   b,x              copy number
         addd  <u0031
         tfr   d,u
         leay  -6,y
         lda   #REALTYPE
         ldb   ,u
         std   ,y
         ldd   1,u
         std   $02,y
         ldd   3,u
         std   $04,y
         rts

* FOR .. NEXT .. STEP / REAL
REALStXP ldy   <u0046
         clrb
         bsr   L348E
         stu   <u00D2
         ldb   #$04
         bsr   L348E
         lda   4,u
         sta   <u00D1
         lbsr  L321E            increment counter
         bsr   L34DC
         ldu   <u00D2
         ldd   1,y
         std   0,u
         ldd   3,y
         std   2,u
         lda   5,y
         sta   4,u
         lsr   <u00D1           check sign
         bcc   L347E
L34CC    ldb   #$02             decrementing
         bsr   L348E
         leax  $06,x
         lbsr  L3221
         lbge  GOTO             loop again
         leax  $03,x
L34DB    rts

L34DC    ldb   <u0034
 ifeq B09EXEC-true
         bitb  #$01
         beq   L34DB
         lbra  L323C
 else
         rts
 endc

******** table for FOR ********
L34E5    fdb   INTStp1-L34E5
         fdb   INTStpX-L34E5
         fdb   REALSt1-L34E5
         fdb   REALStX-L34E5

FOR      ldb   ,x+
         cmpb  #$82
         beq   L3515
         bsr   CpMint
         bsr   L3508
         ldb   -1,x
         cmpb  #$47
         bne   L34FF
         bsr   L3508

L34FF    lbsr  GOTO
         leay  <L34E5,pcr
         lbra  L33EA
L3508    ldd   ,x++
         addd  <u0031
         pshs  b,a
         jsr   <u0016
         ldd   $01,y
         std   [,s++]
         rts

L3515    bsr   CpMreal
         bsr   L3523
         ldb   -$01,x
         cmpb  #$47
         bne   L34FF
         bsr   L3523
         bra   L34FF

L3523    ldd   ,x++
         addd  <u0031
         pshs  b,a
         jsr   <u0016
         bra   L3579

LET      jsr   <u0016
L352F    cmpa  #$04
         bcs   L3537
         pshs  u
         ldu   <u003E
L3537    pshs  u,a
         leax  $01,x
         jsr   <u0016
L353D    puls  a
         lsla
         leau  <L3545,pcr
         jmp   a,u

L3545    bra   L355B            byte
         bra   L356A            integer
         bra   L3579            real
         bra   L355B            boolean
         bra   L359C            string
         bra   L35C1            array

CpMbyte  ldd   ,x
         addd  <u0031
         pshs  b,a
         leax  $03,x
         jsr   <u0016
L355B    ldb   $02,y
         stb   [,s++]
         rts

CpMint   ldd   ,x
         addd  <u0031
         pshs  b,a
         leax  $03,x
         jsr   <u0016
L356A    ldd   $01,y
         std   [,s++]
         rts

CpMreal  ldd   ,x
         addd  <u0031
         pshs  b,a
         leax  $03,x
         jsr   <u0016
L3579    puls  u
         ldd   $01,y
         std   ,u
         ldd   $03,y
         std   2,u
         lda   $05,y
         sta   4,u
         rts

CpMstrin ldd   ,x
         addd  <u0066
         tfr   d,u
         ldd   ,u
         addd  <u0031
         pshs  b,a
         ldd   2,u
         pshs  b,a
         leax  $03,x
         jsr   <u0016
L359C    puls  u,b,a                    D = Max size of string to copy
         tstb
         bne   L35A2
         deca
L35A2    sta   <u003E
         ldy   $01,y
         sty   <u0048
L35AA    lda   ,y+
         sta   ,u+
         cmpa  #C$EOS
         beq   L35B9
         decb
         bne   L35AA
         dec   <u003E
         bpl   L35AA
L35B9    clra
         rts

CpMarray lbsr  L3224
         lbra  L352F

L35C1    puls  u,b,a
         cmpd  $03,y
         bls   L35CA
         ldd   $03,y
L35CA    ldy   $01,y
         exg   y,u
         lbra  L321B

POKE     jsr   <u0016
         ldd   $01,y
         pshs  b,a
         jsr   <u0016
         ldb   $02,y
         stb   [,s++]
         rts

STOP     lbsr  PRINT
         lda   <errpath
         sta   <u007F  set path number
         leax  >STOPMSG,pcr
         lbsr  SPRINT
         lbra  L3206                    exit

UNK1     lbra  L3209

PAUSE    lbsr  PRINT
 ifeq B09EXEC-true
         lbra  L3233
 else
         rts
 endc

GOSUB    ldd   ,x
         leax  $03,x
L35FD    ldy   <u0031
         ldu   <$14,y
         cmpu  <u004A
         bhi   L360D
         ldb   #E$SubOvf
         lbra  L39FB

L360D    stx   ,--u
         stu   <$14,y
         stu   <u0046
         addd  <u005E
         tfr   d,x
         rts

RETURN   ldy   <u0031
         cmpy  <$14,y
         bhi   L3627
         ldb   #$36
         lbra  L39FB

L3627    ldu   <$14,y
         ldx   ,u++
         stu   <$14,y
         stu   <u0046
         rts

ON       ldd   ,x
         cmpa  #$1E
         beq   L366D
         jsr   <u0016
         ldd   ,x
         lslb
         rola
         lslb
         rola
         addd  #$0002
         leau  d,x
         pshs  u
         ldd   $01,y
         ble   L366B
         cmpd  ,x++
         bhi   L366B
         subd  #$0001
         lslb
         rola
         lslb
         rola
         addd  #$0001
         ldd   d,x
         pshs  b,a
         ldb   ,x
         cmpb  #$22
         puls  x,b,a
         beq   L35FD
         addd  <u005E
         tfr   d,x
         rts

L366B    puls  pc,x

L366D    ldu   <u0031
         cmpb  #$20
         bne   L3682
         ldd   $02,x
         addd  <u005E
         std   <$11,u
         lda   #$01
         sta   <$13,u
         leax  $05,x
         rts
L3682    clr   <$13,u
         leax  $02,x
         rts

CREATE   bsr   L36A6
         ldb   #PREAD.+UPDAT.
         os9   I$Create
         bra   L3696

* Open file
OPEN     bsr   L36A6
         os9   I$Open
L3696    lbcs  L39FB
         puls  u,b
         cmpb  #$01
         bne   L36A2
         clr   ,u+
L36A2    sta   ,u
         puls  pc,x

L36A6    leax  $01,x
         lbsr  GETVAR
         leax  $01,x
         jsr   <u0016
         lda   #$03
         cmpb  #$4A
         bne   L36B7
         lda   ,x++
L36B7    ldu   $03,s
         stx   $03,s
         ldx   $01,y
         jmp   ,u

SEEK     lbsr  SETPATH
         jsr   <u0016
         ldb   #$0E
         lbsr  L3230
         lbcs  L39FD
         rts

INPUTPMT fcc   /? /
         fcb   C$EOS

* Illegal input error message
L36D1    fcc   "** Input error - reenter **"
         fcb   C$CR,C$EOS

INPUT    lda   <errpath
         lbsr  SETPATH
         lda   #$2C
         sta   <u00DD
         pshs  x

L36F9    ldx   ,s
         ldb   ,x
         cmpb  #$90
         bne   L3709
         jsr   <u0016
         pshs  x
         ldx   $01,y
         bra   L370E
L3709    pshs  x
         leax  <INPUTPMT,pcr
L370E    bsr   SPRINT
         puls  x
         lda   <u007F  get path number
         cmpa  <errpath
         bne   L371C
         lda   <u002D
         sta   <u007F
L371C    ldb   #$06
L371E    lbsr  L3230
         bcc   L3730
         cmpb  #$03
         lbne  L39FD
         lbsr  L3A23
         clr   <errcode
         bra   L36F9
L3730    bsr   L3743
         bcc   L373B
         leax  <L36D1,pcr
         bsr   SPRINT
         bra   L36F9
L373B    ldb   ,x+
         cmpb  #$4B
         beq   L3730
         puls  pc,b,a
L3743    bsr   GETVAR
         ldb   ,s
         addb  #$07
         ldy   <u0046
         lbsr  L3230
         lbcc  L353D
         lda   ,s
L3755    cmpa  #$04
         bcs   L375B
         leas  $02,s
L375B    leas  $03,s
         coma
         rts

* Entry: X = address of string to print
SPRINT   pshs  y
         leas  -$06,s
         leay  ,s
         stx   $01,y
         ldd   <u0080
         std   <u0082
         ldb   #$05
         lbsr  L3230
         ldb   #$00
         lbsr  L3230
         leas  $06,s
         puls  pc,y

GETVAR   lda   ,x+
         cmpa  #$0E
         bne   L3783
         jsr   <u0016
         bra   L37A8
L3783    suba  #$80
         cmpa  #$04
         bcs   L379E
         beq   L3790
         lbsr  L3224
         bra   L37A8
L3790    ldd   ,x++
         addd  <u0066
         tfr   d,u
         ldd   2,u
         std   <u003E
         ldd   ,u
         bra   L37A0
L379E    ldd   ,x++
L37A0    addd  <u0031
         tfr   d,u
         lda   -$03,x
         suba  #$80
L37A8    puls  y
         cmpa  #$04
         bcs   L37B2
         pshs  u
         ldu   <u003E
L37B2    pshs  u,a
         jmp   ,y

* set IO path
* called by #path statement
SETPATH  ldb   ,x
         cmpb  #$54
         bne   L37C8
         leax  $01,x
         jsr   <u0016
         cmpb  #$4B
         beq   L37C6
         leax  -$01,x
L37C6    lda   $02,y
L37C8    sta   <u007F  set path number
         rts

* READ statement
READ     ldb   ,x
         cmpb  #$54
         bne   L37F5
         bsr   SETPATH
         clr   <u00DD
         cmpb  #$4B
         bne   L37DB
         leax  -$01,x
L37DB    ldb   #$06
         lbsr  L3230
         bcc   L37EE
         cmpb  #$E4
         beq   L37DB
L37E6    lbra  L39FD
L37E9    lbsr  L3743
         bcs   L37E6
L37EE    ldb   ,x+
         cmpb  #$4B
         beq   L37E9
         rts
L37F5    bsr   NextInst
         beq   L3832
L37F9    bsr   L3802
         ldb   ,x+
         cmpb  #$4B
         beq   L37F9
         rts
L3802    lbsr  GETVAR
         bsr   L3834
         lda   ,s
         bne   L380C
         inca
L380C    cmpa  ,y
         lbeq  L353D
         cmpa  #$02
         bcs   L381C
         beq   L3828
L3818    ldb   #$47
         bra   L383C
L381C    lda   ,y
         cmpa  #$02
         bne   L3818
         lbsr  L3227
         lbra  L353D
L3828    cmpa  ,y
         bcs   L3818
         lbsr  L322A
         lbra  L353D
L3832    leax  $01,x
L3834    pshs  x
         ldx   <DATAPtr
         bne   L383F
         ldb   #E$NoData
L383C    lbra  L39FB

* Read next value from DATA declaration
L383F    jsr   <u0016
         cmpb  #$4B
         beq   L384B
         ldd   ,x
         addd  <u005E
         tfr   d,x
L384B    stx   <DATAPtr
         puls  pc,x

* instruction delimiters
NextInst cmpb  #$3F
         beq   L3855
         cmpb  #$3E
L3855    rts

PRINT    lda   <errpath
         lbsr  SETPATH
         ldd   <u0080
         std   <u0082
         ldb   ,x+
         cmpb  #$49             PRINT USING
         beq   L38A3
L3865    bsr   NextInst
         beq   L388B
L3869    cmpb  #$4B  Comma
         beq   L387F
         cmpb  #$51  Semi colon
         beq   L3883
         leax  -$01,x
         jsr   <u0016
         ldb   ,y
         addb  #$01
         bsr   L389B
         ldb   -$01,x
         bra   L3865
L387F    ldb   #$0D
         bsr   L389B
L3883    ldb   ,x+
         bsr   NextInst
         bne   L3869
         bra   L388F
L388B    ldb   #$0C
         bsr   L389B
L388F    ldb   #$00
         bsr   L389B
         lda   <u00DE
         clr   <u00DE
         tsta
         bne   L38A0
L389A    rts
L389B    lbsr  L3230
         bcc   L389A
L38A0    lbra  L39FD
L38A3    jsr   <u0016
         ldd   <u004A
         std   <u008E
         std   <u008C
         ldu   <u0046
         pshs  u,b,a
         clr   <u0094
         ldd   <u0048
         std   <u004A
L38B5    ldb   -$01,x
         bsr   NextInst
         beq   L38D7
         ldb   ,x+
         bsr   NextInst
         beq   L38D2
         leax  -$01,x
         ldb   #$11
         lbsr  L3230
         bcc   L38B5
         puls  u,b,a
         std   <u004A
         stu   <u0046
         bra   L38A0

L38D2    leay  <L388F,pcr
         bra   L38DA
L38D7    leay  <L388B,pcr
L38DA    puls  u,b,a
         std   <u004A
         stu   <u0046
         jmp   ,y

WRITE    lda   <errpath
         lbsr  SETPATH
         ldu   <u0080
         stu   <u0082
         ldb   ,x+
         lbsr  NextInst
         beq   L3914
         cmpb  #$4B             comma separator?
         beq   L3902
         leax  -$01,x
         bra   L3902

L38FA    clra
         ldb   #$12
         lbsr  L3230
         bcs   L38A0
L3902    jsr   <u0016
         ldb   ,y
         addb  #$01
         lbsr  L3230
         bcs   L38A0
         ldb   -$01,x
         lbsr  NextInst
         bne   L38FA
L3914    lbra  L388B

GET      bsr   L392A
         os9   I$Read
         bra   L3923

PUT      bsr   L392A
         os9   I$Write
L3923    leax  ,u
         bcc   L3949
L3927    lbra  L39FB

L392A    lbsr  SETPATH
         lbsr  GETVAR
         leau  ,x
         puls  a
         cmpa  #$04
         bcc   L3943
         leax  >L3B5B,pcr
         ldb   a,x
         clra
         tfr   d,y
         bra   L3945
L3943    puls  y
L3945    puls  x
         lda   <u007F  get path number
L3949    rts

CLOSE    lbsr  SETPATH
         os9   I$Close
         bcs   L3927
         cmpb  #$4B
         beq   CLOSE
         rts

RESTORE  ldb   ,x+
         cmpb  #$3B
         beq   L3967
         ldu   <pgmaddr
         ldd   <$13,u
L3962    addd  <u005E
         std   <DATAPtr
         rts
L3967    ldd   ,x
         addd  #$0001
         leax  $03,x
         bra   L3962

DELETE   jsr   <u0016
         pshs  x
         ldx   $01,y
         os9   I$Delete
L3979    bcs   L3927
         puls  pc,x

CHD      jsr   <u0016
         lda   #UPDAT.
L3981    pshs  x
         ldx   $01,y
         os9   I$ChgDir
         bra   L3979

CHX      jsr   <u0016
         lda   #EXEC.
         bra   L3981

         lbsr  GETVAR
         ldy   <u0046
         leay  -6,y
         ldb   <u007F  get path number
         clra
         std   $01,y
         lbra  L353D

CHAIN    jsr   <u0016
         ldy   $01,y
         pshs  u,y,x
         lbsr  L320C
         puls  u,y,x
         bsr   L39E0
         sts   <u00B1
         lds   <u0080
         os9   F$Chain
         lds   <u00B1
         bra   L39FB

SHELL    jsr   <u0016
         pshs  u,x
         ldy   $01,y
         bsr   L39E0
         os9   F$Fork
         bcs   L39FB
         pshs  a
L39CC    os9   F$Wait
         cmpa  ,s
         bne   L39CC
         leas  $01,s
         tstb
         bne   L39FB
         puls  pc,u,x

L39DA    fcc   "SHELL"
         fcb   C$CR

* Entry: Y=Ptr to parameter area
L39E0    ldx   <u0048
         lda   #C$CR
         sta   -1,x
         tfr   x,d
         leax  >L39DA,pcr
         leau  ,y
         pshs  y
         subd  ,s++
         tfr   d,y
         clra
         clrb
         rts

ERROR    jsr   <u0016
         ldb   2,y

L39FB    stb   <errcode
L39FD    ldu   <u0031
         beq   L3A1B            not running subroutine
         tst   <$13,u
         beq   L3A14            no error trap
         lds   5,u
         ldx   <$11,u
         ldd   <$14,u
         std   <u0046
         lbra  L3371            process error

L3A14    bsr   L3A23
         bsr   L3A73
         lbra  L3206            exit
L3A1B    lbsr  L320F
         lbra  L3206            exit

 ifeq (RESELLER-TANDY)*(RESELLER-DRAGON)
L3A21    fcb   14,255           Force text mode in VDGINT
 endc

L3A23 equ *

 ifeq (RESELLER-TANDY)*(RESELLER-DRAGON)
         leax  <L3A21,pcr
         lbsr  SPRINT
 endc
*============
 ifeq B09EXEC-true
         ldx   <u005C
         leay  ,x
         lbsr  L3218
         clr   <u0074
         lbsr  L3236
         ldb   <errcode
         lbsr  L320F
         lbra  L3233
 else
         lbsr  L320C
         ldb   <errcode
         os9   F$Exit
         rts
 endc

BASE0    clrb             Save 0 in <42, incx, return
         bra   L3A42

BASE1    ldb   #1         Save 1 in <42, incx, return
L3A42    clra
         std   <u0042
         leax  $01,x
         rts

* REM/TRON/TROFF/PAUSE/RTS
* Skip # bytes used up by REM text
L3A48    ldb   ,x+        Get # bytes to skip ahead
         clra
         leax  d,x
         rts

L3A4E    exg   x,pc
         rts

L3A51    leay  ,x
         lbsr  L3218
         leax  ,y
         rts

ERRS51   ldb   #$33       Line with compiler error
         bra   L39FB

DEG      lda   #$01
         bra   L3A62

RAD      clra
L3A62    ldu   <u0031
         sta   1,u
         leax  $01,x
         rts

L3A69    lda   <u0034
         bita  #$01
         bne   L3A89
         ora   #$01
         bra   L3A7B

L3A73    lda   <u0034
         bita  #$01
         beq   L3A89
         anda  #$FE
L3A7B    sta   <u0034
         ldd   <u0017
         pshs  b,a
         ldd   <u0019
         std   <u0017
         puls  b,a
         std   <u0019
L3A89    rts

RUN      lbsr  L3224
         pshs  x
         ldb   <u00CF
         cmpb  #$A0
         beq   L3AB6
         ldy   <u0048
         ldx   <u003E
L3A9A    lda   ,u+
         leax  -$01,x
         beq   L3AA8
         sta   ,y+
         cmpa  #C$EOS
         bne   L3A9A
         lda   ,--y
L3AA8    ora   #$80
         sta   ,y
         ldy   <u0048
         lbsr  L3212
         bcs   L3AF4
         leau  ,x
L3AB6    ldd   ,u
         bne   L3AC8
         ldy   <u00D2
         leay  $03,y
         lbsr  L3212
         bcs   L3AF4
         ldd   ,x
         std   ,u
L3AC8    ldx   ,s
         std   ,s
         ldu   <u0031
         lda   <u0034
         sta   ,u
         ldb   <u0042+1
         stb   2,u    Store BASE declaration
         ldd   <u004A
         std   $D,u
         ldd   <u0040
         std   $F,u
         ldd   <DATAPtr
         std   9,u     Reset to first location of DATA statement
         bsr   L3B5F
         stx   $B,u
         puls  x
         lda   $06,x
         beq   L3B23
         cmpa  #$22
         beq   L3B23
         cmpa  #$21
         beq   L3AF9
L3AF4    ldb   #$2B
L3AF6    lbra  L39FB
L3AF9    ldd   5,u
         pshs  b,a
         sts   5,u
         leas  ,y
         ldd   <u0040
         pshs  y
         subd  ,s++
         lsra
         rorb
         lsra
         rorb
         pshs  b,a
         ldd   $09,x
         leay  >L32DD,pcr
         jsr   d,x
         ldu   <u0031
         lds   5,u
         puls  x
         stx   5,u
         bcc   L3B3C
         bra   L3AF6
L3B23    lbsr  L3A73
         lda   <u0034
         anda  #$7F
         sta   <u0034
         lbsr  L32DD
         lda   ,u
         bita  #$01
         beq   L3B3C
         lbsr  L3A69
         lda   ,u
         sta   <u0034
L3B3C    ldd   $D,u
         std   <u004A
         ldd   $F,u
         std   <u0040
         ldd   9,u
         std   <DATAPtr
         ldb   2,u
         sex
         std   <u0042
         ldx   3,u
         lbsr  L3351
         ldx   $B,u
         ldd   <u0044
         subd  <u004A
         std   <FREEMEM
         rts

* Table of size of variables
L3B5B    fcb   1          Byte    (type 0)
         fcb   2          Integer (type 1)
         fcb   5          Real    (type 2)
         fcb   1          Boolean (type 3)

* Vector from $31E8
* Entry: U=
*        X=
L3B5F    pshs  u
         ldb   ,x+
         clra
         pshs  x,a
         cmpb  #$4D
         bne   L3BE1
         leay  ,s
L3B6C    pshs  y
         ldb   ,x
         cmpb  #$0E
         beq   L3BA3
         jsr   <u0016
         leax  -$01,x
         cmpa  #$02
         beq   L3B86
         cmpa  #$04
         beq   L3B93
         ldd   $01,y
         std   $04,y
         lda   ,y
L3B86    ldb   #$06
         leau  <L3B5B,pcr
         subb  a,u
         leau  b,y
         stu   <u0046
         bra   L3BA7
L3B93    ldu   $01,y
         ldd   <u0048
         subd  <u004A
         std   <u003E
         ldd   <u0048
         std   <u004A
         lda   #$04
         bra   L3BA7
L3BA3    leax  $01,x
         jsr   <u0016
L3BA7    puls  y
         inc   ,y
         cmpa  #$04
         bcs   L3BB3
         pshs  u
         ldu   <u003E
L3BB3    pshs  u,a
         ldb   ,x+
         cmpb  #$4B
         beq   L3B6C
         leax  $01,x
         stx   $01,y
         leax  <L3B5B,pcr
         ldu   <u0046
         stu   <u0040
L3BC6    puls  b
         cmpb  #$04
         bcs   L3BD0
         puls  b,a
         bra   L3BD3
L3BD0    ldb   b,x
         clra
L3BD3    std   ,--u
         puls  b,a
         std   ,--u
         dec   ,y
         bne   L3BC6
         leay  ,u
         bra   L3BE7

L3BE1    ldy   <u0046
         sty   <u0040
L3BE7    tfr   y,d
         subd  <u004A
         lbcs  L3302
         std   <FREEMEM
         puls  pc,u,x,a

KILL     jsr   <u0016
         ldy   $01,y
         pshs  x
         lbsr  L3215
         puls  pc,x

UNK5     lbsr  L322D
         leax  >L323F,pcr
         stx   <table1
         rts

L3C09    pshs  x,b,a
         ldb   [<$04,s]
         leax  <L3C19,pcr
         ldd   b,x
         leax  d,x
         stx   $04,s
         puls  pc,x,b,a

L3C19    fdb   UNK12-L3C19 0
         fdb   L3D80-L3C19 2 Copy DIM'd array to temp var pool
         fdb   RLADD-L3C19 4 Real # add
         fdb   L40D3-L3C19 6 Real # multiply
         fdb   L4234-L3C19 8 Real # divide
         fdb   RLCMP-L3C19 A Set flags for Real comparison
         fdb   FIX-L3C19 C FIX (Round & convert REAL to INTEGER)
         fdb   FLOAT-L3C19 E FLOAT (Convert INTEGER/BYTE to REAL)

L3C29    jsr   <u001B     Substr string search
         fcb   $08

L3C2C    jsr   <u0024     Report error
         fcb   $06

L3C2F    jsr   <u002A
         fcb   $02
 ifeq B09EXEC-true
L3C32    jsr   <u001B
         fcb   $1a
 endc

* Function routines
* Negative offsets from base of table @ L3CB5
         fdb   MID$-L3CB5 MID$
         fdb   LEFT$-L3CB5 LEFT$
         fdb   RIGHT$-L3CB5 RIGHT$
         fdb   CHR$-L3CB5 CHR$
         fdb   STR$int-L3CB5 STR$ (for INTEGER)
         fdb   STR$rl-L3CB5 STR$ (for REAL)
         fdb   DATE$-L3CB5 DATE$
         fdb   TAB-L3CB5 TAB
         fdb   FIX-L3CB5 FIX (round & convert REAL to INTEGER)
         fdb   fixN1-L3CB5 ??? (calls fix but eats 1 var 1st)
         fdb   fixN2-L3CB5 ??? (calls fix but eats 2 vars 1st)
         fdb   FLOAT-L3CB5 FLOAT (convert INTEGER to REAL)
         fdb   FLOAT2-L3CB5 ??? (calls float though)
         fdb   LNOTB-L3CB5 Byte - LNOT
         fdb   NEGint-L3CB5 Integer - Negate a number
         fdb   NEGrl-L3CB5 Real - Negate a number
         fdb   LANDB-L3CB5 Byte - LAND
         fdb   LORB-L3CB5 Byte - LOR
         fdb   LXORB-L3CB5 Byte - LXOR
         fdb   Igt-L3CB5 > : Integer/Byte relational
         fdb   Rgt-L3CB5 > : Real relational
         fdb   Sgt-L3CB5 > : String relational
         fdb   Ilo-L3CB5 < : Integer/Byte relational
         fdb   Rlo-L3CB5 < : Real relational
         fdb   Slo-L3CB5 < : String relational
         fdb   Ine-L3CB5 <> or >< : Integer/Byte relational
         fdb   Rne-L3CB5 <> or >< : Real relational
         fdb   Sne-L3CB5 <> or >< : String relational
         fdb   Bne-L3CB5 <> or >< : Boolean relational
         fdb   Ieq-L3CB5 = : Integer/Byte relational
         fdb   Req-L3CB5 = : Real relational
         fdb   Seq-L3CB5 = : String relational
         fdb   Beq-L3CB5 = : Boolean relational
         fdb   Ige-L3CB5 >= or => : Integer/Byte relational
         fdb   Rge-L3CB5 >= or => : Real relational
         fdb   Sge-L3CB5 >= or => : String Relational
         fdb   Ile-L3CB5 <= or =< : Integer/Byte relational
         fdb   Rle-L3CB5 <= or =< : Real relational
         fdb   Sle-L3CB5 <= or =< : String Relational
         fdb   INTADD-L3CB5 Integer - Add
         fdb   RLADD-L3CB5 Real - Add
         fdb   STRconc-L3CB5 String add
         fdb   INTSUB-L3CB5 Integer - Subtract
         fdb   RLSUB-L3CB5 Real - Subtract
         fdb   INTMUL-L3CB5 Integer - Multiply
         fdb   RLMUL-L3CB5 Real Multiply
         fdb   INTDIV-L3CB5 Integer - Divide
         fdb   RLDIV-L3CB5 Real Divide
         fdb   POWERS-L3CB5 Real Exponent\ Probably for both ^ & **
         fdb   POWERS-L3CB5 Real Exponent/ Hard coding for 0^x & x^1
         fdb   DIM-L3CB5 DIM
         fdb   DIM-L3CB5 DIM
         fdb   DIM-L3CB5 DIM
         fdb   DIM-L3CB5 DIM
         fdb   PARAM-L3CB5 PARAM
         fdb   PARAM-L3CB5 PARAM
         fdb   PARAM-L3CB5 PARAM
         fdb   PARAM-L3CB5 PARAM
         fdb   $0000      Unused function entries (maybe use for LONGINT?)
         fdb   $0000
         fdb   $0000
         fdb   $0000
         fdb   $0000
         fdb   $0000

* Jump table (base is L3CB5)
L3CB5    fdb   BCPVAR-L3CB5 Copy BYTE var to temp pool
         fdb   ICPVAR-L3CB5 Copy INTEGER var to temp pool
         fdb   L3F8D-L3CB5 Copy REAL var to temp pool
         fdb   BlCPVAR-L3CB5 Copy BOOLEAN var to temp pool
         fdb   SCPVAR-L3CB5 Copy STRING var to temp pool (max 256 chars)
         fdb   L3D59-L3CB5 Copy DIM array
         fdb   L3D59-L3CB5 Copy DIM array
         fdb   L3D59-L3CB5 Copy DIM array
         fdb   L3D59-L3CB5 Copy DIM array
         fdb   L3D68-L3CB5 Copy PARAM array
         fdb   L3D68-L3CB5 Copy PARAM array
         fdb   L3D68-L3CB5 Copy PARAM array
         fdb   L3D68-L3CB5 Copy PARAM array
         fdb   BCPCNST-L3CB5 Copy BYTE constant to temp pool - CHECK IF USED
         fdb   ICPCNST-L3CB5 Copy INTEGER constant to temp pool
         fdb   RCPCNST-L3CB5 Copy REAL constant to temp pool
         fdb   SCPCNST-L3CB5 Copy STRING constant to temp pool
         fdb   ICPCNST-L3CB5 Copy INTEGER constant to temp pool
         fdb   ADDR-L3CB5 ADDR
         fdb   ADDR-L3CB5 ADDR
         fdb   SIZE-L3CB5 SIZE
         fdb   SIZE-L3CB5 SIZE
         fdb   POS-L3CB5 POS
         fdb   ERR-L3CB5 ERR
         fdb   MODint-L3CB5 MOD for Integer #'s
         fdb   MODrl-L3CB5 MOD for Real #'s
         fdb   RND-L3CB5 RND
         fdb   PI-L3CB5 PI
         fdb   SUBSTR-L3CB5 SUBSTR
         fdb   SGNint-L3CB5 SGN for Integer
         fdb   SGNrl-L3CB5 SGN for Real
         fdb   L4A82-L3CB5 Transcendental ???
         fdb   L4AAF-L3CB5 Transcendental ???
         fdb   L4ABD-L3CB5 Transcendental ???
         fdb   L4927-L3CB5 Transcendental ???
         fdb   L4968-L3CB5 Transcendental ???
         fdb   L4A03-L3CB5 Transcendental ???
         fdb   EXPON-L3CB5 EXP
         fdb   ABSint-L3CB5 ABS for Integer #'s
         fdb   ABSrl-L3CB5 ABS for Real #'s
         fdb   LOG-L3CB5 LOG
         fdb   LOG10-L3CB5 LOG10
         fdb   SQRT-L3CB5 SQR \ Square root
         fdb   SQRT-L3CB5 SQRT/
         fdb   FLOAT-L3CB5 FLOAT
         fdb   INTrl-L3CB5 INT (of real #)
         fdb   L45F0-L3CB5 ??? RTS
         fdb   FIX-L3CB5 FIX
         fdb   FLOAT-L3CB5 FLOAT
         fdb   L45F0-L3CB5 ??? RTS
         fdb   SQint-L3CB5 SQuare of integer
         fdb   SQrl-L3CB5 SQuare of real
         fdb   PEEK-L3CB5 PEEK
         fdb   LNOTI-L3CB5 LNOT of Integer
         fdb   VAL-L3CB5 VAL
         fdb   LEN-L3CB5 LEN
         fdb   ASC-L3CB5 ASC
         fdb   LANDI-L3CB5 LAND of Integer
         fdb   LORI-L3CB5 LOR of Integer
         fdb   LXORI-L3CB5 LXOR of Integer
         fdb   equTRUE-L3CB5 Force Boolean to TRUE
         fdb   equFALSE-L3CB5 Force Boolean to FALSE
         fdb   EOF-L3CB5 EOF
         fdb   TRIM$-L3CB5 TRIM$

* Jump table, base is L3D35
L3D35    fdb   BtoI-L3D35 Convert Byte to Int (into temp var)
         fdb   INTCPY-L3D35 Copy Int var into temp var
         fdb   RCPVAR-L3D35 Copy Real var into temp var
         fdb   L4374-L3D35 ??? Copy Boolean into temp var
         fdb   L44D7-L3D35 ??? Copy string to expression stack
         fdb   L44F6-L3D35 ??? Copy D&U regs into temp var type 5

L3D41    ldy   <u0046           = table4
         ldd   <u004A
         std   <u0048           clear expression stack
         bra   L3D51

L3D4A    lslb
         ldu   <table2
         ldd   b,u
         jsr   d,u
L3D51    ldb   ,x+
         bmi   L3D4A            next part
         clra                   clear carry
         lda   ,y
         rts                    instruction done

* get size of DIM array
L3D59    bsr   L3D80

L3D5B    pshs  pc,u
         ldu   <table3
         lsla
         ldd   a,u
         leau  d,u
         stu   $02,s
         puls  pc,u

* Get size of PARAM array
L3D68    bsr   L3D78
         bra   L3D5B

DIM      leas  2,s
         lda   #$F2
         bra   L3D82

PARAM    leas  $02,s
         lda   #$F6
         bra   L3D7A

L3D78    lda   #$89
L3D7A    sta   <u00A3
         clr   <u003B
         bra   L3D86

L3D80    lda   #$85
L3D82    sta   <u00A3
         sta   <u003B
L3D86    ldd   ,x++
         addd  <u0062
         std   <u00D2
         ldu   <u00D2
         lda   ,u
         anda  #$E0
         sta   <u00CF
         eora  #$80
         sta   <u00CE
         lda   ,u
         anda  #$07
         ldb   -$03,x
         subb  <u00A3
         pshs  b,a
         lda   ,u
         anda  #$18
         lbeq  L3E3F
         ldd   1,u
         addd  <u0066
         tfr   d,u
         ldd   ,u
         std   <u003C
         lda   $01,s
         bne   L3DC4
         lda   #$05
         sta   ,s
         ldd   2,u
         std   <u003E
         clra
         clrb
         bra   L3E17
L3DC4    leay  -6,y
         clra
         clrb
         std   $01,y
         leau  4,u
         bra   L3DD5
L3DCE    ldd   ,u
         std   $01,y
         lbsr  INTMUL
L3DD5    ldd   $07,y
         subd  <u0042
         cmpd  ,u++
         bcs   L3DE3
         ldb   #$37
         lbra  L3C2C
L3DE3    addd  $01,y
         std   $07,y
         dec   $01,s
         bne   L3DCE
         lda   ,s
         beq   L3DFF
         cmpa  #$02
         bcs   L3E03
         beq   L3E0B
         cmpa  #$04
         bcs   L3DFF
         ldd   ,u
         std   <u003E
         bra   L3E0E
L3DFF    ldd   $07,y
         bra   L3E07
L3E03    ldd   $07,y
         lslb
         rola
L3E07    leay  12,y
         bra   L3E17
L3E0B    ldd   #$0005
L3E0E    std   $01,y
         lbsr  INTMUL
         ldd   $01,y
         leay  6,y
L3E17    tst   <u00CE
         bne   L3E33
         pshs  b,a
         ldd   <u003C
         addd  <u0031
         cmpd  <u0040
         bcc   ERR56
         tfr   d,u
         puls  b,a
         cmpd  2,u
         bhi   ERR56
         addd  ,u
         bra   L3E73
L3E33    addd  <u003C
         tst   <u003B
         bne   L3E71
L3E39    addd  $01,y
         leay  6,y
         bra   L3E73
L3E3F    lda   ,s
         cmpa  #$04
         ldd   1,u
         bcs   L3E51
         addd  <u0066
         tfr   d,u
         ldd   2,u
         std   <u003E
         ldd   ,u
L3E51    tst   <u003B
         beq   L3E39
         addd  <u0031
         tfr   d,u
         tst   <u00CE
         bne   L3E75
         cmpd  <u0040
         bcc   ERR56
         ldd   <u003E
         cmpd  2,u
         bcs   L3E6D
         ldd   2,u
         std   <u003E
L3E6D    ldu   ,u
         bra   L3E75
L3E71    addd  <u0031
L3E73    tfr   d,u
L3E75    clra
         puls  pc,b,a

ERR56    ldb   #$38
         lbra  L3C2C

BCPCNST  leau  ,x+
         bra   BtoI

BCPVAR   ldd   ,x++
         addd  <u0031
         tfr   d,u
BtoI     ldb   ,u
         clra
         leay  -6,y
         std   $01,y
         lda   #INTGTYPE
         sta   ,y
         rts

* Copy Integer constant to temp pool
ICPCNST  leau  ,x++
         bra   INTCPY

* Copy integer var into temp var
ICPVAR   ldd   ,x++       Get offset to var we want
         addd  <u0031
         tfr   d,u
INTCPY   ldd   ,u
         leay  -6,y
         std   $01,y
         lda   #INTGTYPE
         sta   ,y
         rts

* INTEGER NEGATE (- IN FRONT OF NUMBER)
NEGint   clra
         clrb
         subd  $01,y
         std   $01,y
         rts

* INTEGER ADD
INTADD   ldd   7,y        Get integer
         addd  $01,y
         leay  6,y
         std   $01,y
         rts

* INTEGER SUBTRACT
INTSUB   ldd   7,y        Get integer
         subd  $01,y
         leay  6,y
         std   $01,y
         rts

* INTEGER MULTIPLY
INTMUL   ldd   7,y        Get value that result will go into
         beq   L3EFA
         cmpd  #$0002  Multiplying by 2?
         bne   L3ECF .. no
         ldd   $01,y
         bra   L3EDB

L3ECF    ldd   $01,y
         beq   L3EDD
         cmpd  #$0002
         bne   L3EE1
         ldd   $07,y
L3EDB    lslb
         rola
L3EDD    std   $07,y
         bra   L3EFA

L3EE1    lda   $08,y
         mul
         sta   $03,y
         lda   $08,y
         stb   $08,y
         ldb   $01,y
         mul
         addb  $03,y
         lda   $07,y
         stb   $07,y
         ldb   $02,y
         mul
         addb  $07,y
         stb   $07,y
L3EFA    leay  $06,y
         rts
L3EFD    clr   ,y
         ldd   $07,y
         bpl   L3F0B
         nega
         negb
         sbca  #$00
         std   $07,y
         com   ,y
L3F0B    ldd   $01,y
         bpl   L3F17
         nega
         negb
         sbca  #$00
         std   $01,y
         com   ,y
L3F17    cmpd  #$0002
         rts

INTDIV   bsr   L3EFD
         bne   L3F2E
         ldd   $07,y
         beq   L3F3B
         asra
         rorb
         std   $07,y
         ldd   #$0000
         rolb
         bra   L3F65

L3F2E    ldd   $01,y
         bne   L3F37
         ldb   #E$DivZer
         lbra  L3C2C
L3F37    ldd   $07,y
         bne   L3F40
L3F3B    leay  $06,y
         std   $03,y
         rts

L3F40    tsta
         bne   L3F4B
         exg   a,b
         std   $07,y
         ldb   #$08
         bra   L3F4D
L3F4B    ldb   #$10
L3F4D    stb   $03,y
         clra
         clrb
L3F51    lsl   $08,y
         rol   $07,y
         rolb
         rola
         subd  $01,y
         bmi   L3F5F
         inc   $08,y
         bra   L3F61
L3F5F    addd  $01,y
L3F61    dec   $03,y
         bne   L3F51
L3F65    std   $09,y
         tst   ,y
         bpl   L3F79
         nega
         negb
         sbca  #$00
         std   $09,y
         ldd   $07,y
         nega
         negb
         sbca  #$00
         std   $07,y
L3F79    leay  $06,y
         rts

* Copy REAL # from X (moving X to after real number) to temp var
RCPCNST  leay  -6,y       Make room for temp var
         ldb   ,x+
         lda   #REALTYPE
         std   ,y
         ldd   ,x++
         std   $02,y
         ldd   ,x++
         std   $04,y
         rts

* Copy REAL # from variable pool (pointed to by X) into temp var
L3F8D    ldd   ,x++       Get offset into var space for REAL var
         addd  <u0031
         tfr   d,u
* Copy REAL # constant from within BASIC09 (pointed to by U) into temp var
RCPVAR   leay  -6,y       Make room for temp var
         lda   #REALTYPE
         ldb   ,u
         std   ,y
         ldd   1,u
         std   $02,y
         ldd   3,u
         std   $04,y
         rts

* invert sign of real number
NEGrl    lda   5,y        Get LSB of mantissa & sign bit
         eora  #$01
         sta   $05,y
         rts

RLSUB    ldb   $05,y
         eorb  #$01
         stb   $05,y

RLADD    pshs  x
         tst   $02,y
         beq   L3FC7
         tst   $08,y
         bne   L3FCB
L3FBB    ldd   $01,y
         std   $07,y
         ldd   $03,y
         std   $09,y
         lda   $05,y
         sta   $0B,y
L3FC7    leay  $06,y
         puls  pc,x

* compare exponents
L3FCB    lda   $07,y
         suba  $01,y
         bvc   L3FD5
         bpl   L3FBB
         bra   L3FC7
L3FD5    bmi   L3FDD
         cmpa  #$1F
         ble   L3FE5
         bra   L3FC7
L3FDD    cmpa  #$E1
         blt   L3FBB
         ldb   $01,y
         stb   $07,y
L3FE5    ldb   $0B,y
         andb  #$01
         stb   ,y
         eorb  $05,y
         andb  #$01
         stb   $01,y
         ldb   $0B,y
         andb  #$FE
         stb   $0B,y
         ldb   $05,y
         andb  #$FE
         stb   $05,y
         tsta
         beq   L4031
         bpl   L4029
         nega
         leax  $06,y
         bsr   L4082
         tst   $01,y
         beq   L4039
L400B    subd  $04,y
         exg   d,x
         sbcb  $03,y
         sbca  $02,y
         bcc   L404D
         coma
         comb
         exg   d,x
         coma
         comb
         addd  #$0001
         exg   d,x
         bcc   L4025
         addd  #$0001
L4025    dec   ,y
         bra   L404D
L4029    leax  ,y
         bsr   L4082
         stx   $02,y
         std   $04,y
L4031    ldx   $08,y
         ldd   $0A,y
         tst   $01,y
         bne   L400B
L4039    addd  $04,y
         exg   d,x
         adcb  $03,y
         adca  $02,y
         bcc   L404D
         rora
         rorb
         exg   d,x
         rora
         rorb
         inc   $07,y
         exg   d,x
L404D    tsta
         bmi   L4060
L4050    dec   $07,y
         lbvs  L40DD
         exg   d,x
         lslb
         rola
         exg   d,x
         rolb
         rola
         bpl   L4050
L4060    exg   d,x
         addd  #$0001
         exg   d,x
         bcc   L4071
         addd  #$0001
         bcc   L4071
         rora
         inc   $07,y
L4071    std   $08,y
         tfr   x,d
         andb  #$FE
         tst   ,y
         beq   L407C
         incb
L407C    std   $0A,y
         leay  $06,y
         puls  pc,x
L4082    suba  #$10
         bcs   L40A0
         suba  #$08
         bcs   L4091
         pshs  a
         clra
         ldb   $02,x
         bra   L4097
L4091    adda  #$08
         pshs  a
         ldd   $02,x
L4097    ldx   #$0000
         tst   ,s
         beq   L40C9
         bra   L40BD
L40A0    adda  #$08
         bcc   L40B3
         pshs  a
         clra
         ldb   $02,x
         ldx   $03,x
         tst   ,s
         bne   L40BF
         exg   d,x
         bra   L40C9
L40B3    adda  #$08
         pshs  a
         ldd   $02,x
         ldx   $04,x
         bra   L40BF
L40BD    exg   d,x
L40BF    lsra
         rorb
         exg   d,x
         rora
         rorb
         dec   ,s
         bne   L40BD
L40C9    leas  $01,s
         rts

RLMUL    bsr   L40D3
         lbcs  L3C2C
         rts
L40D3    pshs  x
         lda   $02,y
         bpl   L40DD
         lda   $08,y
         bmi   L40E9
L40DD    clra
         clrb
         std   $07,y
         std   $09,y
         sta   $0B,y
         leay  6,y
         puls  pc,x
L40E9    lda   $01,y
         adda  $07,y
         bvc   L40F6
L40EF    bpl   L40DD
         comb
         ldb   #$32
         puls  pc,x
L40F6    sta   $07,y
         ldb   $0B,y
         eorb  $05,y
         andb  #$01
         stb   ,y
         lda   $0B,y
         anda  #$FE
         sta   $0B,y
         ldb   $05,y
         andb  #$FE
         stb   $05,y
         mul
         sta   ,-s
         clr   ,-s
         clr   ,-s
         lda   $0B,y
         ldb   $04,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L4120
         inc   ,s
L4120    lda   $0A,y
         ldb   $05,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L412D
         inc   ,s
L412D    ldb   $02,s
         ldx   ,s
         stx   $01,s
         clr   ,s
         lda   $0B,y
         ldb   $03,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L4142
         inc   ,s
L4142    lda   $0A,y
         ldb   $04,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L414F
         inc   ,s
L414F    lda   $09,y
         ldb   $05,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L415C
         inc   ,s
L415C    ldb   $02,s
         ldx   ,s
         stx   $01,s
         clr   ,s
         lda   $0B,y
         ldb   $02,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L4171
         inc   ,s
L4171    lda   $0A,y
         ldb   $03,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L417E
         inc   ,s
L417E    lda   $09,y
         ldb   $04,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L418B
         inc   ,s
L418B    lda   $08,y
         ldb   $05,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L4198
         inc   ,s
L4198    ldb   $02,s
         ldx   ,s
         stx   $01,s
         clr   ,s
         stb   $0B,y
         lda   $0A,y
         ldb   $02,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L41AF
         inc   ,s
L41AF    lda   $09,y
         ldb   $03,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L41BC
         inc   ,s
L41BC    lda   $08,y
         ldb   $04,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L41C9
         inc   ,s
L41C9    ldb   $02,s
         ldx   ,s
         stx   $01,s
         clr   ,s
         stb   $0A,y
         lda   $09,y
         ldb   $02,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L41E0
         inc   ,s
L41E0    lda   $08,y
         ldb   $03,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L41ED
         inc   ,s
L41ED    lda   $08,y
         ldb   $02,y
         mul
         addd  ,s
         bmi   L4202
         lsl   $0B,y
         rol   $0A,y
         rol   $02,s
         rolb
         rola
         dec   $07,y
         bvs   L421B
L4202    std   $08,y
         lda   $02,s
         ldb   $0A,y
         addd  #$0001
         bcc   L4220
         inc   $09,y
         bne   L4222
         inc   $08,y
         bne   L4222
         ror   $08,y
         inc   $07,y
         bvc   L4222
L421B    leas  $03,s
         lbra  L40EF
L4220    andb  #$FE
L4222    orb   ,y
         std   $0A,y
         leay  $06,y
         leas  $03,s
         clrb
         puls  pc,x

RLDIV    bsr   L4234
         lbcs  L3C2C
L4233    rts
L4234    comb
         ldb   #$2D
         tst   $02,y
         beq   L4233
         pshs  x
         tst   $08,y
         lbeq  L40DD
         lda   $07,y
         suba  $01,y
         lbvs  L40EF
         sta   $07,y
         lda   #$21
         ldb   $05,y
         eorb  $0B,y
         andb  #$01
         std   ,y
         lsr   $02,y
         ror   $03,y
         ror   $04,y
         ror   $05,y
         ldd   $08,y
         ldx   $0A,y
         lsra
         rorb
         exg   d,x
         rora
         rorb
         clr   $0B,y
         bra   L426F
L426D    exg   d,x
L426F    subd  $04,y
         exg   d,x
         bcc   L4278
         subd  #$0001
L4278    subd  $02,y
         beq   L42AB
         bmi   L42A7
L427E    orcc  #Carry
L4280    dec   ,y
         beq   L42F8
         rol   $0B,y
         rol   $0A,y
         rol   $09,y
         rol   $08,y
         exg   d,x
         lslb
         rola
         exg   d,x
         rolb
         rola
         bcc   L426D
         exg   d,x
         addd  $04,y
         exg   d,x
         bcc   L42A1
         addd  #$0001
L42A1    addd  $02,y
         beq   L42AB
         bpl   L427E
L42A7    andcc #^Carry
         bra   L4280
L42AB    leax  ,x
         bne   L427E
         ldb   ,y
         decb
         subb  #$10
         blt   L42CD
         subb  #$08
         blt   L42C2
         stb   ,y
         lda   $0B,y
         ldb   #$80
         bra   L42EB
L42C2    addb  #$08
         stb   ,y
         ldd   #$8000
         ldx   $0A,y
         bra   L42ED
L42CD    addb  #$08
         blt   L42DB
         stb   ,y
         ldx   $09,y
         lda   $0B,y
         ldb   #$80
         bra   L42ED
L42DB    addb  #$07
         stb   ,y
         ldx   $08,y
         ldd   $0A,y
         orcc  #Carry
L42E5    rolb
         rola
         exg   d,x
         rolb
         rola
L42EB    exg   d,x
L42ED    andcc #^Carry
         dec   ,y
         bpl   L42E5
         exg   d,x
         tsta
         bra   L42FC
L42F8    ldx   $0A,y
         ldd   $08,y
L42FC    bmi   L430C
         exg   d,x
         rolb
         rola
         exg   d,x
         rolb
         rola
         dec   $07,y
         lbvs  L40DD
L430C    exg   d,x
         addd  #$0001
         exg   d,x
         bcc   L4321
         addd  #$0001
         bcc   L4321
         rora
         inc   $07,y
         lbvs  L40EF
L4321    std   $08,y
         tfr   x,d
         andb  #$FE
         orb   $01,y
         std   $0A,y
         inc   $07,y
         lbvs  L40EF
L4331    leay  6,y
         clrb
         puls  pc,x

POWERS   pshs  x
         ldd   $07,y
         beq   L4331
         ldx   $01,y
         bne   L434F
         leay  6,y
L4342    ldd   #$0180
         std   $01,y
         clr   $03,y
         clr   $04,y
         clr   $05,y
         puls  pc,x

L434F    std   $01,y
         stx   $07,y
         ldd   $09,y
         ldx   $03,y
         std   $03,y
         stx   $09,y
         lda   $0B,y
         ldb   $05,y
         sta   $05,y
         stb   $0B,y
         puls  x
         lbsr  LOG
         lbsr  RLMUL
         lbra  EXPON

BlCPVAR  ldd   ,x++
         addd  <u0031
         tfr   d,u
L4374    ldb   ,u
         clra
         leay  -6,y
         std   $01,y
         lda   #BOOLTYPE
         sta   ,y
         rts

LANDB    ldb   $08,y
         andb  $02,y
         bra   L4390

LORB     ldb   $08,y
         orb   $02,y
         bra   L4390

LXORB    ldb   $08,y
         eorb  $02,y
L4390    leay  6,y
         std   $01,y
         rts

LNOTB    com   $02,y
         rts

StrCMP   pshs  y,x
         ldx   $01,y
         ldy   $07,y
         sty   <u0048
L43A2    lda   ,y+
         cmpa  ,x+
         bne   L43AC
         cmpa  #C$EOS
         bne   L43A2
L43AC    inca             Inc last char checked
         inc   -$01,x
         cmpa  -$01,x
         puls  pc,y,x

* String compare: < (?)
Slo      bsr   StrCMP      Go do string compare
         bcs   L4405
         bra   L4409

* String compare: <= or =< (?)
Sle      bsr   StrCMP
         bls   L4405
         bra   L4409

* String compare: =
Seq      bsr   StrCMP
         beq   L4405
         bra   L4409

* String compare: <> or ><
Sne      bsr   StrCMP
         bne   L4405
         bra   L4409

* String compare: >= or => (?)
Sge      bsr   StrCMP
         bcc   L4405
         bra   L4409

* String compare: > (?)
Sgt      bsr   StrCMP
         bhi   L4405
         bra   L4409

* For Integer/Byte compares below: Works for signed Integer as well
*  as unsigned Byte
* Integer/Byte compare: <
Ilo      ldd   7,y
         subd  $01,y
         blt   L4405
         bra   L4409

* Integer/Byte compare: <= or =<
Ile      ldd   7,y
         subd  $01,y
         ble   L4405
         bra   L4409

* Integer/Byte compare: <> or ><
Ine      ldd   7,y
         subd  $01,y
         bne   L4405
         bra   L4409

* Integer/Byte compare: =
Ieq      ldd   7,y
         subd  $01,y
         beq   L4405
         bra   L4409

* Integer/Byte compare: >= or =>
Ige      ldd   7,y
         subd  $01,y
         bge   L4405
         bra   L4409

* Integer/Byte compare: >
Igt      ldd   7,y        Get original var
         subd  $01,y
         ble   L4409
L4405    ldb   #B.TRUE
         bra   L440B

L4409    ldb   #B.FALSE
L440B    clra
         leay  6,y
         std   $01,y
         lda   #BOOLTYPE
         sta   ,y
         rts

* BOOLEAN = compare
Beq      ldb   8,y        Get original BOOLEAN value
         cmpb  $02,y
         beq   L4405
         bra   L4409

* BOOLEAN <> or >< compare
Bne      ldb   8,y        Get original BOOLEAN value
         cmpb  $02,y
         bne   L4405
         bra   L4409

* Real < compare
Rlo      bsr   RLCMP      Go compute flags between real #'s
         blt   L4405
         bra   L4409

* Real <= or =< compare
Rle      bsr   RLCMP
         ble   L4405
         bra   L4409

* Real <> or >< compare
Rne      bsr   RLCMP
         bne   L4405
         bra   L4409

* Real = compare
Req      bsr   RLCMP
         beq   L4405
         bra   L4409

* Real >= or => compare
Rge      bsr   RLCMP
         bge   L4405
         bra   L4409

* Real > compare
Rgt      bsr   RLCMP
         bgt   L4405
         bra   L4409

* Set flags for Real comparison
RLCMP    pshs  y          Preserve Y
         andcc #Entire+FIRQMask+HalfCrry+IRQMask
         lda   $08,y
         bne   L4461
         lda   $02,y
         beq   L445F
L4455    lda   $05,y
L4457    anda  #$01
         bne   L445F
L445B    andcc #Entire+FIRQMask+HalfCrry+IRQMask
         orcc  #Negative
L445F    puls  pc,y
L4461    lda   $02,y
         bne   L446B
         lda   $0B,y
         eora  #$01
         bra   L4457
L446B    lda   $0B,y
         eora  $05,y
         anda  #$01
         bne   L4455
         leau  $06,y
         lda   $05,y
         anda  #$01
         beq   L447D
         exg   u,y
L447D    ldd   1,u
         cmpd  $01,y
         bne   L445F
         ldd   3,u
         cmpd  $03,y
         bne   L4491
         lda   5,u
         cmpa  $05,y
         beq   L445F
L4491    bcs   L445B
         andcc #Entire+FIRQMask+HalfCrry+IRQMask
         puls  pc,y

SCPCNST  clrb
         stb   <u003E
L449A    ldu   <u0048
         leay  -6,y
         stu   $01,y
         sty   <u0044
L44A3    cmpu  <u0044
         bcc   L44C2
         lda   ,x+
         sta   ,u+
         cmpa  #C$EOS
         beq   L44BB
         decb
         bne   L44A3
         dec   <u003E
         bpl   L44A3
         lda   #C$EOS
         sta   ,u+
L44BB    stu   <u0048
         lda   #$04
         sta   ,y
         rts
L44C2    ldb   #E$StrOvf
         lbra  L3C2C

SCPVAR   ldd   ,x++
         addd  <u0066
         tfr   d,u
L44CD    ldd   ,u
         addd  <u0031
         ldu   2,u
         stu   <u003E
         tfr   d,u
L44D7    pshs  x
         ldb   <u003F
         bne   L44DF
         dec   <u003E
L44DF    leax  ,u
         bsr   L449A
         puls  pc,x

STRconc  ldu   $01,y
         leay  6,y
L44E9    lda   ,u+
         sta   -2,u
         cmpa  #C$EOS
         bne   L44E9
         leau  -1,u
         stu   <u0048
         rts

L44F6    ldd   <u003E
         leay  -6,y
         std   $03,y
         stu   $01,y
         lda   #$05
         sta   ,y
         rts

FLOAT    clra
         clrb
         std   $04,y
         ldd   $01,y
         bne   L4512
         stb   $03,y
         lda   #REALTYPE
         sta   ,y
         rts
L4512    ldu   #$0210
         tsta
         bpl   L451E
         nega
         negb
         sbca  #$00
         inc   $05,y
L451E    tsta
         bne   L4526
         ldu   #$0208
         exg   a,b
L4526    tsta
         bmi   L452F
L4529    leau  -1,u
         lslb
         rola
         bpl   L4529
L452F    std   $02,y
         stu   ,y
         rts

FLOAT2   leay  6,y
         bsr   FLOAT
         leay  -6,y
         rts

FIX      ldb   $01,y
         bgt   L454E
         bmi   L454A
         lda   $02,y
         bpl   L454A
         ldd   #$0001
         bra   L4591

L454A    clra
         clrb
         bra   L4599

L454E    subb  #$10
         bhi   L458C
         bne   L4566
         ldd   $02,y
         ror   $05,y
         bcc   L4599
         cmpd  #$8000
         bne   L458C
         tst   $04,y
         bpl   L4599
         bra   L458C
L4566    cmpb  #$F8
         bhi   L4578
         pshs  b
         ldd   $02,y
         std   $03,y
         clr   $02,y
         puls  b
         addb  #$08
         beq   L4581
L4578    lsr   $02,y
         ror   $03,y
         ror   $04,y
         incb
         bne   L4578
L4581    ldd   $02,y
         tst   $04,y
         bpl   L4591
         addd  #$0001
         bvc   L4591
L458C    ldb   #E$ValRng
         lbra  L3C2C

L4591    ror   $05,y
         bcc   L4599
         nega
         negb
         sbca  #$00
L4599    std   $01,y
         lda   #INTGTYPE
         sta   ,y
         rts

fixN1    leay  6,y
         bsr   FIX
         leay  -6,y
         rts

fixN2    leay  12,y
         bsr   FIX
         leay  -12,y
         rts

ABSrl    lda   $05,y
         anda  #$FE
         sta   $05,y
         rts

ABSint   ldd   $01,y
         bpl   L45BF
         nega
         negb
         sbca  #$00
         std   $01,y
L45BF    rts

PEEK     clra
         ldb   [<$01,y]
         std   $01,y
         rts

SGNrl    lda   $02,y
         beq   L45DB
         lda   $05,y
         anda  #$01
         bne   L45DE
L45D1    ldb   #$01
         bra   L45E0

SGNint   ldd   $01,y
         bmi   L45DE
         bne   L45D1
L45DB    clrb
         bra   L45E0

L45DE    ldb   #$FF
L45E0    sex
         bra   L45EA

ERR      ldb   <errcode
         clr   <errcode
L45E7    clra
         leay  -6,y
L45EA    std   $01,y
         lda   #INTGTYPE
         sta   ,y
L45F0    rts

POS      ldb   <u007D
         bra   L45E7

SQRT     ldb   $05,y
         asrb
         lbcs  ERR67
         ldb   #$1F
         stb   <u006E
         ldd   $01,y
         beq   L45F0
         inca
         asra
         sta   $01,y
         ldd   $02,y
         bcs   L4616
         lsra
         rorb
         std   -$04,y
         ldd   $04,y
         rora
         rorb
         bra   L461A
L4616    std   -$04,y
         ldd   $04,y
L461A    std   -$02,y
         clra
         clrb
         std   $02,y
         std   $04,y
         std   -$06,y
         std   -$08,y
         bra   L4638
L4628    orcc  #Carry
         rol   $05,y
         rol   $04,y
         rol   $03,y
         rol   $02,y
         dec   <u006E
         beq   L467A
         bsr   L468F
L4638    ldb   -$04,y
         subb  #$40
         stb   -$04,y
         ldd   -$06,y
         sbcb  $05,y
         sbca  $04,y
         std   -$06,y
         ldd   -$08,y
         sbcb  $03,y
         sbca  $02,y
         std   -$08,y
         bpl   L4628
L4650    andcc #^Carry
         rol   $05,y
         rol   $04,y
         rol   $03,y
         rol   $02,y
         dec   <u006E
         beq   L467A
         bsr   L468F
         ldb   -$04,y
         addb  #$C0
         stb   -$04,y
         ldd   -$06,y
         adcb  $05,y
         adca  $04,y
         std   -$06,y
         ldd   -$08,y
         adcb  $03,y
         adca  $02,y
         std   -$08,y
         bmi   L4650
         bra   L4628
L467A    ldd   $02,y
         bra   L4684
L467E    dec   $01,y
         lbvs  L40DD
L4684    lsl   $05,y
         rol   $04,y
         rolb
         rola
         bpl   L467E
         std   $02,y
         rts

L468F    bsr   L4691
L4691    lsl   -$01,y
         rol   -$02,y
         rol   -$03,y
         rol   -$04,y
         rol   -$05,y
         rol   -$06,y
         rol   -$07,y
         rol   -$08,y
         rts

MODint   lbsr  INTDIV
         ldd   $03,y
         std   $01,y
         rts

MODrl    leau  -12,y
         pshs  y
L46AE    ldd   ,y++
         std   ,u++
         cmpu  ,s
         bne   L46AE
         leas  $02,s
         leay  -$C,u
         lbsr  RLDIV
         bsr   INTrl
         lbsr  RLMUL
         lbra  RLSUB

INTrl    lda   $01,y
         bgt   L46D3
         clra
         clrb
         std   $01,y
         std   $03,y
         stb   $05,y
L46D2    rts

L46D3    cmpa  #$1F
         bcc   L46D2
         leau  $06,y
         ldb   -1,u
         andb  #$01
         pshs  u,b
         leau  $01,y
L46E1    leau  1,u
         suba  #$08
         bcc   L46E1
         beq   L46F5
         ldb   #$FF
L46EB    lslb
         inca
         bne   L46EB
         andb  ,u
         stb   ,u+
         bra   L46F9
L46F5    leau  1,u
L46F7    sta   ,u+
L46F9    cmpu  $01,s
         bne   L46F7
         puls  u,b
         orb   $05,y
         stb   $05,y
         rts

SQint    leay  -6,y
         ldd   $07,y
         std   $01,y
         lbra  INTMUL

SQrl     leay  -6,y
         ldd   $0A,y
         std   $04,y
         ldd   $08,y
         std   $02,y
         ldd   6,y
         std   ,y
         lbra  RLMUL

VAL      ldd   <u0080
         ldu   <u0082
         pshs  u,b,a
         ldd   $01,y
         std   <u0080
         std   <u0082
         std   <u0048
         leay  6,y
         ldb   #$09
         lbsr  L3C2F
         puls  u,b,a
         std   <u0080
         stu   <u0082
         lbcs  ERR67
         rts

ADDR     lbsr  L3D51
         leay  -6,y
         stu   $01,y
L4746    lda   #INTGTYPE
         sta   ,y
         leax  $01,x
         rts

* Table of var type sizes
L474D    fcb   $01        Byte             (type=0)
         fcb   $02        Integer size     (type=1)
         fcb   $05        Real size        (type=2)
         fcb   $01        Boolean          (type=3)

SIZE     lbsr  L3D51
         leay  -6,y       ??? Size of variable packets?
         cmpa  #4         String/complex variable?
         bcc   L4763
         leau  >L474D,pcr
         ldb   a,u
         clra
         bra   L4765
L4763    ldd   <u003E
L4765    std   $01,y
         bra   L4746

* BOOLEAN - TRUE
equTRUE  ldd   #B.TRUE
         bra   L4771

equFALSE ldd   #B.FALSE
L4771    leay  -6,y
         std   $01,y
         lda   #BOOLTYPE
         sta   ,y
         rts

* Invert integer
LNOTI    com   1,y
         com   2,y
         rts

LANDI    ldd   1,y        Get value to AND with out of integer var.
         anda  7,y        ANDD (with value in variable)
         andb  8,y
         bra   L4795

LXORI    ldd   1,y
         eora  7,y
         eorb  8,y
         bra   L4795

LORI     ldd   1,y
         ora   7,y
         orb   8,y
L4795    std   7,y
         leay  6,y
         rts

L479A    fcb   $ff,$de,$5b,$d8,$aa ??? (.434294482)

LOG10    bsr   LOG
         leau  >L479A,pcr
         lbsr  RCPVAR
         lbra  RLMUL

LOG      pshs  x
         ldb   $05,y
         asrb
         lbcs  ERR67
         ldd   1,y
         lbeq  ERR67
         pshs  a
         ldb   #$01
         stb   $01,y
         leay  <-$1A,y
         leax  <$1B,y
         leau  ,y
         lbsr  L4BCC
         lbsr  L4CC7
         clra
         clrb
         std   <$14,y
         std   <$16,y
         sta   <$18,y
         leax  >L4C7F,pcr
         stx   <$19,y
         lbsr  L4909
         leax  <$14,y
         leau  <$1B,y
         lbsr  L4BCC
         lbsr  L4CE1
         leay  <$1A,y
         ldb   #REALTYPE
         stb   ,y
         ldb   $05,y
         orb   #$01
         stb   $05,y
         puls  b
         bsr   L480A
         puls  x
         lbra  RLADD

L4805    fcb   $00,$b1,$72,$17,$f8 (.693147181) LOG(2) in REAL format

L480A    sex              Convert to 16 bit number
         bpl   L480E      If positive, skip ahead
         negb             Invert sign on LSB
L480E    anda  #$01
         pshs  b,a
         leau  >L4805,pcr
         lbsr  RCPVAR
         ldb   $05,y
         lda   $01,s
         cmpa  #$01
         beq   L485C
         mul
         stb   $05,y
         ldb   $04,y
         sta   $04,y
         lda   $01,s
         mul
         addb  $04,y
         adca  #$00
         stb   $04,y
         ldb   $03,y
         sta   $03,y
         lda   $01,s
         mul
         addb  $03,y
         adca  #$00
         stb   $03,y
         ldb   $02,y
         sta   $02,y
         lda   $01,s
         mul
         addb  $02,y
         adca  #$00
         beq   L4858
L484B    inc   $01,y
         lsra
         rorb
         ror   $03,y
         ror   $04,y
         ror   $05,y
         tsta
         bne   L484B
L4858    stb   $02,y
         ldb   $05,y
L485C    andb  #$FE
         orb   ,s
         stb   $05,y
         puls  pc,b,a

EXPON    pshs  x
         ldb   $01,y
         beq   L4880
         cmpb  #$07
         ble   L4877
         ldb   $05,y
         rorb
         rorb
         eorb  #$80
         lbra  L491C
L4877    cmpb  #$E4
         lble  L4342
         tstb
         bpl   L488A
L4880    clr   ,-s
         ldb   $05,y
         andb  #$01
         beq   L48CD
         bra   L48BB
L488A    lda   #$71
         mul
         adda  $01,y
         ldb   $05,y
         andb  #$01
         pshs  b,a
         eorb  $05,y
         stb   $05,y
         ldb   ,s
L489B    lbsr  L480A
         lbsr  RLSUB
         ldb   $01,y
         ble   L48AD
         addb  ,s
         stb   ,s
         ldb   $01,y
         bra   L489B
L48AD    puls  b,a
         pshs  a
         tstb
         beq   L48CD
         nega
         sta   ,s
         orb   $05,y
         stb   $05,y
L48BB    leau  >L4805,pcr
         lbsr  RCPVAR
         lbsr  RLADD
         dec   ,s
         ldb   $05,y
         andb  #$01
         bne   L48BB
L48CD    leay  <-$1A,y
         leax  <$1B,y
         leau  <$14,y
         lbsr  L4BCC
         lbsr  L4CC7
         ldd   #$1000
         std   ,y
         clra
         std   $02,y
         sta   $04,y
         leax  >L4C61,pcr
         stx   <$19,y
         bsr   L4909
         leax  ,y
         leau  <$1B,y
         lbsr  L4BCC
         lbsr  L4CE1
         leay  <$1A,y
         puls  b
         addb  $01,y
         bvs   L491C
         lda   #REALTYPE
         std   ,y
         puls  pc,x
L4909    lda   #$01
         sta   <u009A
         leax  >L4D6F,pcr
         stx   <u0095
         leax  >$005F,x
         stx   <u0097
         lbra  L4B97
L491C    leay  -6,y
         lbpl  L40DD
         ldb   #E$FltOvf
         lbra  L3C2C

L4927    pshs  x
         bsr   L495D
         ldd   $01,y
         lbeq  L4A91
         cmpd  #$0180
         bgt   L4943
         bne   L4946
         ldd   $03,y
         bne   L4943
         lda   $05,y
         lbeq  L4A0E
L4943    lbra  ERR67

L4946    lbsr  L49CB
         leay  <-$14,y
         leax  <$15,y
         leau  ,y
         lbsr  L4BCC
         lbsr  L4CC7
         leax  <$1B,y
         lbra  L4A3E
L495D    ldb   $05,y
         andb  #$01
         stb   <u006D
         eorb  $05,y
         stb   $05,y
         rts

L4968    leau  <L49AB,pcr
         pshs  u,x
         bsr   L495D
         ldd   $01,y
         lbeq  L4A0E
         cmpd  #$0180
         bgt   L4943
         bne   L4995
         ldd   $03,y
         bne   L4943
         lda   $05,y
         bne   L4943
         lda   <u006D
         bne   L498E
         clrb
         std   $01,y
         puls  pc,u,x
L498E    leay  6,y
         puls  u,x
         lbra  PI
L4995    bsr   L49CB
         leay  <-$14,y
         leax  <$1B,y
         leau  ,y
         lbsr  L4BCC
         lbsr  L4CC7
         leax  <$15,y
         lbra  L4A3E
L49AB    lda   $05,y
         bita  #$01
         beq   L49C5
         ldu   <u0031
         tst   1,u
         beq   L49BF
         leau  <L49C6,pcr
         lbsr  RCPVAR
         bra   L49C2
L49BF    lbsr  PI
L49C2    lbra  RLADD
L49C5    rts

L49C6    fcb   $08,$b4,$00,$00,$00 180

L49CB    lda   <u006D
         pshs  a
         leay  <-$12,y
         ldd   #$0201
         std   12,y
         lda   #$80
         clrb
         std   $0E,y
         clra
         std   <$10,y
         ldd   <$12,y
         std   ,y
         std   $06,y
         ldd   <$14,y
         std   $02,y
         std   $08,y
         ldd   <$16,y
         std   $04,y
         std   $0A,y
         lbsr  RLMUL
         lbsr  RLSUB
         lbsr  SQRT
         puls  a
         sta   <u006D
         rts

L4A03    pshs  x
         lbsr  L495D
         ldb   $01,y
         cmpb  #$18
         blt   L4A17
L4A0E    leay  6,y
         lbsr  PI
         dec   $01,y
         bra   L4A6A
L4A17    leay  <-$1A,y
         ldd   #$1000
         std   ,y
         clra
         std   $02,y
         sta   $04,y
         ldb   <$1B,y
         bra   L4A34
L4A29    asr   ,y
         ror   $01,y
         ror   $02,y
         ror   $03,y
         ror   $04,y
         decb
L4A34    cmpb  #$02
         bgt   L4A29
         stb   <$1B,y
         leax  <$1B,y
L4A3E    leau  $0A,y
         lbsr  L4BCC
         lbsr  L4CC7
         clra
         clrb
         std   <$14,y
         std   <$16,y
         sta   <$18,y
         leax  >L4C2C,pcr
         stx   <$19,y
         lbsr  L4B89
         leax  <$14,y
         leau  <$1B,y
         lbsr  L4BCC
         lbsr  L4CE1
         leay  <$1A,y
L4A6A    lda   $05,y
         ora   <u006D
         sta   $05,y
         ldu   <u0031
         tst   1,u
         beq   L4A91
         leau  >L4AFE,pcr
         lbsr  RCPVAR
         lbsr  RLMUL
         bra   L4A91

L4A82    pshs  x
         lbsr  PIX
         leax  $0A,y
         bsr   L4A97
         lda   $05,y
L4A8D    eora  <u009C
L4A8F    sta   $05,y
L4A91    lda   #REALTYPE
         sta   ,y
         puls  pc,x

L4A97    leau  <$1B,y
         lbsr  L4BCC
         lbsr  L4CE1
         leay  <$14,y
         leax  >L4D6A,pcr
         leau  $01,y
         lbsr  L4BCC
         lbra  RLMUL

L4AAF    pshs  x
         bsr   PIX
         leax  ,y
         bsr   L4A97
         lda   $05,y
         eora  <u009B
         bra   L4A8F

L4ABD    pshs  x
         bsr   PIX
         leax  $0A,y
         leau  <$1B,y
         lbsr  L4BCC
         lbsr  L4CE1
         leax  ,y
         leay  <$14,y
         leau  $01,y
         lbsr  L4BCC
         lbsr  L4CE1
         ldd   $01,y
         bne   L4AEB
         leay  6,y
         ldd   #$7FFF
L4AE2    std   $01,y
         lda   #$FF
         std   $03,y
         deca
         bra   L4AF0
L4AEB    lbsr  RLDIV
         lda   $05,y
L4AF0    eora  <u009B
         bra   L4A8D

L4AF4    fcb   $02,$c9,$0f,$da,$a2 PI (3.14159265)

L4AF9    fcb   $fb,$8e,$fa,$35,$12 -1.74532925 E-02  (Degrees)

L4AFE    fcb   $06,$e5,$2e,$e0,$d4 57.2957795 (radians)

PI       leau  >L4AF4,pc  Point to PI in FP format
         lbra  RCPVAR

PIX      ldu   <u0031
         tst   1,u
         beq   L4B1A
         leau  >L4AF9,pcr
         lbsr  RCPVAR      Copy 5 bytes from u to 1,y (0,y=2)
         lbsr  RLMUL
L4B1A    clr   <u009B
         ldb   $05,y
         andb  #$01
         stb   <u009C
         eorb  $05,y
         stb   $05,y
         bsr   PI
         inc   $01,y
         lbsr  RLCMP
         blt   L4B36
         lbsr  MODrl
         bsr   PI
         bra   L4B38
L4B36    dec   $01,y
L4B38    lbsr  RLCMP
         blt   L4B4A
         inc   <u009B
         lda   <u009C
         eora  #$01
         sta   <u009C
         lbsr  RLSUB
         bsr   PI
L4B4A    dec   $01,y
         lbsr  RLCMP
         ble   L4B64
         lda   <u009B
         eora  #$01
         sta   <u009B
         inc   $01,y
         lda   $0B,y
         ora   #$01
         sta   $0B,y
         lbsr  RLADD
         leay  -6,y
L4B64    leay  <-$14,y
         leax  >L4C33,pcr
         stx   <$19,y
         leax  <$1B,y
         leau  <$14,y
         bsr   L4BCC
         lbsr  L4CC7
         ldd   #$1000
         std   ,y
         clra
         std   $02,y
         sta   $04,y
         std   $0A,y
         std   $0C,y
         sta   $0E,y
L4B89    leax  >L4D29,pcr
         stx   <u0095
         leax  >$0041,x
         stx   <u0097
         clr   <u009A
L4B97    ldb   #$25
         stb   <u0099
         clr   <u009D
L4B9D    leau  <$1B,y
         ldx   <u0095
         cmpx  <u0097
         bcc   L4BAE
         bsr   L4BCC
         leax  $05,x
         stx   <u0095
         bra   L4BB2
L4BAE    ldb   #$01
         bsr   L4C1E
L4BB2    leax  ,y
         leau  $05,y
         bsr   L4BDE
         tst   <u009A
         bne   L4BC2
         leax  $0A,y
         leau  $0F,y
         bsr   L4BDE
L4BC2    jsr   [<$19,y]
         inc   <u009D
         dec   <u0099
         bne   L4B9D
         rts

L4BCC    pshs  y,x
         lda   ,x
         ldy   $01,x
         ldx   $03,x
         sta   ,u
         sty   1,u
         stx   3,u
         puls  pc,y,x
L4BDE    ldb   ,x
         sex
         ldb   <u009D
         lsrb
         lsrb
         lsrb
         bcc   L4BE9
         incb
L4BE9    pshs  b
         beq   L4BF2
L4BED    sta   ,u+
         decb
         bne   L4BED
L4BF2    ldb   #$05
         subb  ,s+
         beq   L4BFF
L4BF8    lda   ,x+
         sta   ,u+
         decb
         bne   L4BF8
L4BFF    leau  -5,u
         ldb   <u009D
         andb  #$07
         beq   L4C2B
         cmpb  #$04
         bcs   L4C1E
         subb  #$08
         lda   ,x
L4C0F    lsla
         rol   4,u
         rol   3,u
         rol   2,u
         rol   1,u
         rol   ,u
         incb
         bne   L4C0F
         rts
L4C1E    asr   ,u
         ror   1,u
         ror   2,u
         ror   3,u
         ror   4,u
         decb
         bne   L4C1E
L4C2B    rts
L4C2C    lda   $0A,y
         eora  ,y
         coma
         bra   L4C36
L4C33    lda   <$14,y
L4C36    tsta
         bpl   L4C4D
         leax  ,y
         leau  $0F,y
         bsr   L4C8F
         leax  $0A,y
         leau  $05,y
         bsr   L4CAB
         leax  <$14,y
         leau  <$1B,y
         bra   L4C8F
L4C4D    leax  ,y
         leau  $0F,y
         bsr   L4CAB
         leax  $0A,y
         leau  $05,y
         bsr   L4C8F
         leax  <$14,y
         leau  <$1B,y
         bra   L4CAB
L4C61    leax  <$14,y
         leau  <$1B,y
         bsr   L4CAB
         bmi   L4C8F
         bne   L4C79
         ldd   $01,x
         bne   L4C79
         ldd   $03,x
         bne   L4C79
         ldb   #$01
         stb   <u0099
L4C79    leax  ,y
         leau  $05,y
         bra   L4C8F
L4C7F    leax  ,y
         leau  $05,y
         bsr   L4C8F
         cmpa  #$20
         bcc   L4CAB
         leax  <$14,y
         leau  <$1B,y
L4C8F    ldd   $03,x
         addd  3,u
         std   $03,x
         ldd   $01,x
         bcc   L4CA0
         addd  #$0001
         bcc   L4CA0
         inc   ,x
L4CA0    addd  1,u
         std   $01,x
         lda   ,x
         adca  ,u
         sta   ,x
         rts
L4CAB    ldd   $03,x
         subd  3,u
         std   $03,x
         ldd   $01,x
         bcc   L4CBC
         subd  #$0001
         bcc   L4CBC
         dec   ,x
L4CBC    subd  1,u
         std   $01,x
         lda   ,x
         sbca  ,u
         sta   ,x
         rts
L4CC7    ldb   ,u
         clr   ,u
         addb  #$04
         bge   L4CDE
         negb
         lbra  L4C1E
L4CD3    lsl   4,u
         rol   3,u
         rol   2,u
         rol   1,u
         rol   ,u
         decb
L4CDE    bne   L4CD3
         rts
L4CE1    lda   ,u
         bpl   L4CEE
         clra
         clrb
         std   ,u
         std   2,u
         sta   4,u
         rts
L4CEE    ldd   #$2004
L4CF1    decb
         lsl   4,u
         rol   3,u
         rol   2,u
         rol   1,u
         rol   ,u
         bmi   L4D05
         deca
         bne   L4CF1
         clrb
         std   ,u
         rts
L4D05    lda   ,u
         stb   ,u
         ldb   1,u
         sta   1,u
         lda   2,u
         stb   2,u
         ldb   3,u
         addd  #$0001
         andb  #$FE
         std   3,u
         bcc   L4D28
         inc   2,u
         bne   L4D28
         inc   1,u
         bne   L4D28
         ror   1,u
         inc   ,u
L4D28    rts

* Data (all 5 byte entries for real #'s???)
L4D29    fcb   $0c,$90,$fd,$aa,$22 2319.85404
         fcb   $07,$6b,$19,$c1,$58 53.5503032
         fcb   $03,$eb,$6e,$bf,$26 7.35726888
         fcb   $01,$fd,$5b,$a9,$ab -1.97935983
         fcb   $00,$ff,$aa,$dd,$b9
         fcb   $00,$7f,$f5,$56,$ef
         fcb   $00,$3f,$fe,$aa,$b7
         fcb   $00,$1f,$ff,$d5,$56
         fcb   $00,$0f,$ff,$fa,$ab
         fcb   $00,$07,$ff,$ff,$55
         fcb   $00,$03,$ff,$ff,$eb
         fcb   $00,$01,$ff,$ff,$fd
         fcb   $00,$01,$00,$00,$00

L4D6A    fcb   $00,$9b,$74,$ed,$a8 .607252935
L4D6F    fcb   $0b,$17,$21,$7f,$7e 0185.04681
         fcb   $06,$7c,$c8,$fb,$30
         fcb   $03,$91,$fe,$f8,$f3
         fcb   $01,$e2,$70,$76,$e3
         fcb   $00,$f8,$51,$86,$01
         fcb   $00,$7e,$0a,$6c,$3a
         fcb   $00,$3f,$81,$51,$62
         fcb   $00,$1f,$e0,$2a,$6b
         fcb   $00,$0f,$f8,$05,$51
         fcb   $00,$07,$fe,$00,$aa
         fcb   $00,$03,$ff,$80,$15
         fcb   $00,$01,$ff,$e0,$03
         fcb   $00,$00,$ff,$f8,$00
         fcb   $00,$00,$7f,$fe,$00
         fcb   $00,$00,$3f,$ff,$80
         fcb   $00,$00,$1f,$ff,$e0
         fcb   $00,$00,$0f,$ff,$f8
         fcb   $00,$00,$07,$ff,$fe
         fcb   $00,$00,$04,$00,$00

L4DCE    fdb   $0E12,$14A2,$BB40,$E62D,$3619,$62E9

RND      clra
         clrb
         std   <u004C
         std   <u004E
         pshs  a
         lda   $02,y
         beq   L4DFC
         ldb   $05,y
         bitb  #$01
         bne   L4DF0
         com   ,s
         bra   L4DFC

L4DF0    addb  #$FE
         addb  $01,y
         lda   $04,y
         std   <u0052
         ldd   $02,y
         std   <u0050
L4DFC    lda   <u0053
         ldb   <u0057
         mul
         std   <u004E
         lda   <u0052
         ldb   <u0057
         mul
         addd  <u004D
         bcc   L4E0E
         inc   <u004C
L4E0E    std   <u004D
         lda   <u0053
         ldb   <u0056
         mul
         addd  <u004D
         bcc   L4E1B
         inc   <u004C
L4E1B    std   <u004D
         lda   <u0051
         ldb   <u0057
         mul
         addd  <u004C
         std   <u004C
         lda   <u0052
         ldb   <u0056
         mul
         addd  <u004C
         std   <u004C
         lda   <u0053
         ldb   <u0055
         mul
         addd  <u004C
         std   <u004C
         lda   <u0050
         ldb   <u0057
         mul
         addb  <u004C
         stb   <u004C
         lda   <u0051
         ldb   <u0056
         mul
         addb  <u004C
         stb   <u004C
         lda   <u0052
         ldb   <u0055
         mul
         addb  <u004C
         stb   <u004C
         lda   <u0053
         ldb   <u0054
         mul
         addb  <u004C
         stb   <u004C
         ldd   <u004E
         addd  <u005A
         std   <u0052
         ldd   <u004C
         adcb  <u0059
         adca  <u0058
         std   <u0050
         tst   ,s+
         bne   L4E98
         ldd   <u0050
         std   $02,y
         ldd   <u0052
         std   $04,y
         clr   $01,y
L4E78    lda   #$1F
         pshs  a
         ldd   $02,y
         bmi   L4E8E
L4E80    dec   ,s
         beq   L4E8E
         dec   $01,y
         lsl   $05,y
         rol   $04,y
         rolb
         rola
         bpl   L4E80
L4E8E    std   $02,y
         ldb   $05,y
         andb  #$FE
         stb   $05,y
         puls  pc,b

L4E98    ldd   <u0052
         andb  #$FE
         std   ,--y
         ldd   <u0050
         std   ,--y
         clra
         clrb
         std   ,--y
         bsr   L4E78
         lbra  RLMUL

LEN      ldd   <u0048
         ldu   $01,y
         subd  $01,y
         subd  #$0001
         stu   <u0048
L4EB6    std   $01,y
         lda   #INTGTYPE
         sta   ,y
         rts

* Get ASCII code of character
ASC      ldd   $01,y
         std   <u0048
         ldb   [<$01,y]
         clra
         bra   L4EB6

* Create character from integer argument.
CHR$     ldd   $01,y  Get integer argument
         tsta         more than 255?
         lbne  ERR67  ..yes
         ldu   <u0048 get pointer to string buffer
         stu   $01,y
         stb   ,u+
         lbsr  L4FEA  Add end-of-string and set type
         sty   <u0044
         cmpu  <u0044
         lbcc  L44C2  String overflow
         rts

LEFT$    ldd   $01,y
         ble   IsNull
         addd  $07,y
         tfr   d,u
         cmpd  <u0048
         bcc   L4EF1
         bsr   L4F70
L4EF1    leay  6,y
         rts

IsNull   leay  6,y
         ldu   $01,y
         bra   L4F70

RIGHT$   ldd   $01,y
         ble   IsNull
         pshs  x
         ldd   <u0048
         subd  $01,y
         subd  #$0001
         cmpd  $07,y
         bls   L4F1A
         tfr   d,x
         ldu   $07,y
L4F10    lda   ,x+
         sta   ,u+
         cmpa  #C$EOS
         bne   L4F10
         stu   <u0048
L4F1A    leay  6,y
         puls  pc,x

MID$     ldd   $01,y                    size of piece
         ble   L4F26
         ldd   $07,y                    starting offset
         bgt   L4F2E
L4F26    ldd   $01,y                    = LEFT$
         leay  6,y
         std   $01,y
         bra   LEFT$

L4F2E    subd  #$0001
         beq   L4F26
         addd  $0D,y                    start address piece
         cmpd  <u0048
         bcs   L4F3E                    piece exists
         leay  6,y
         bra   IsNull

L4F3E    pshs  x
         tfr   d,x
         ldb   $02,y
         ldu   $0D,y
L4F46    lda   ,x+
         sta   ,u+
         cmpa  #C$EOS
         beq   L4F59
         decb
         bne   L4F46
         dec   $01,y
         bpl   L4F46
         lda   #C$EOS
         sta   ,u+
L4F59    stu   <u0048
         leay  12,y
         puls  pc,x

TRIM$    ldu   <u0048
         leau  -1,u
L4F63    cmpu  $01,y
         beq   L4F70
         lda   ,-u
         cmpa  #C$SPAC
         beq   L4F63
         leau  1,u
L4F70    lda   #C$EOS
         sta   ,u+
         stu   <u0048
         rts

SUBSTR   pshs  y,x
         ldd   <u0048
         subd  $01,y
         addd  $07,y
         addd  #$0001
         ldx   $07,y
         ldy   $01,y
         lbsr  L3C29
         bcc   L4F90
         clra
         clrb
         bra   L4F99
L4F90    tfr   y,d
         ldx   $02,s
         subd  $01,x
         addd  #$0001
L4F99    puls  y,x
         std   $07,y
         lda   #$01
         sta   6,y
         leay  6,y
         rts

STR$int  ldb   #$02
         bra   L4FAA

STR$rl   ldb   #$03
L4FAA    lda   <u007D
         ldu   <u0082
         pshs  u,x,a
         lbsr  L3C2F
         bcs   ERR67
         ldx   <u0082
         lda   #C$EOS
         sta   ,x
         ldx   $03,s
         lbsr  SCPCNST
         puls  u,x,a
         sta   <u007D
         stu   <u0082
         rts

ERR67    ldb   #$43
         lbra  L3C2C

TAB      pshs  x
         ldd   $01,y get function argument
         blt   ERR67
         sty   <u0044
         ldu   <u0048
         stu   $01,y
         lda   #C$SPAC
L4FDB    cmpb  <u007D
         bls   L4FEC
         sta   ,u+
         decb
         cmpu  <u0044
         bcs   L4FDB
         lbra  L44C2   String overflow

L4FEA    pshs  x
L4FEC    lda   #C$EOS
         sta   ,u+
         stu   <u0048
         lda   #STRTYPE
         sta   ,y
         puls  pc,x

DATE$    pshs  x
         leay  -6,y
         leax  -6,y
         ldu   <u0048
         stu   1,y
         os9   F$Time
         bcs   L4FEC
         bsr   PRTNUM
         lda   #'/
         bsr   L501F
         lda   #'/
         bsr   L501F
         lda   #C$SPAC
         bsr   L501F
         lda   #':
         bsr   L501F
         lda   #':
         bsr   L501F
         bra   L4FEC
L501F    sta   ,u+

*****
* Prtnum
*   Print 8-Bit Ascii Number In (,X+)
*
PRTNUM   lda   ,x+
         ldb   #'0-1
 ifeq Y2K-true     Correction for Y2000 changes.
PRTN100  suba  #100  Subtract 100 until below 0
         bhs   PRTN100
         adda  #100
 endc
PRTN10   incb  Form Tens digit
         suba  #10
         bcc   PRTN10
         stb   ,u+
         ldb   #'9+1
L502E    decb
         inca
         bne   L502E
         stb   ,u+
         rts

EOF      lda   $02,y  Get file path number
         ldb   #SS.EOF    Check if we are at end of file
         os9   I$GetStt
         bcc   L5046
         cmpb  #E$EOF
         bne   L5046
         ldb   #B.TRUE
         bra   L5048
L5046    ldb   #B.FALSE
L5048    clra
         std   $01,y
         lda   #BOOLTYPE
         sta   ,y
         rts

UNK12    ldb   #$06       6 2-byte entries to copy
         pshs  y,x,b
         tfr   dp,a
         ldb   #$50
         tfr   d,y
         leax  >L4DCE,pcr
L505E    ldd   ,x++
         std   ,y++
         dec   ,s
         bne   L505E
         leax  >L3CB5,pcr
         stx   <table2
         leax  >L3D35,pcr
         stx   <table3
         lda   #$7E
         sta   <u0016
         leax  >L3D41,pcr
         stx   <u0017
 ifeq B09EXEC-true
         leax  >L3C32,pcr
         stx   <u0019
 endc
         puls  pc,y,x,b

L5084    pshs  x,b,a
         ldb   [<$04,s]
         leax  <L5094,pcr
         ldd   b,x
         leax  d,x
         stx   $04,s
         puls  pc,x,b,a

L5094    fdb   AtoITR-L5094 Function 0
         fdb   L50A4-L5094 Function 2

L5098    jsr   <u0027
         fcb   $0C
Flote    jsr   <u0027
         fcb   $0E
L509E    jsr   <u0027
         fcb   $08
L50A1    jsr   <u0027
         fcb   $06

* <u002A function 2
* Entry: B=Sub-function #
L50A4    pshs  pc,x,d     Make room for new PC, preserve X & Y
         lslb
         leax  <L50B2,pcr
L50AA    ldd   b,x        Get offset
L50AC    leax  d,x
         stx   $04,s
         puls  pc,x,b,a

* Sub-function jump table (L50B2 is the base)
L50B2    fdb   WRITLN-L50B2 $045f  0
         fdb   PRintg-L50B2 $05c3  1
         fdb   PRintg-L50B2 $05c3  2
         fdb   PRreal-L50B2 $04b7  3
         fdb   PRbool-L50B2 $05b3  4
         fdb   PRstring-L50B2 $05aa  5
         fdb   READLN-L50B2 $044a  6
         fdb   L530A-L50B2 $0258  7
         fdb   L531D-L50B2 $026b  8
         fdb   L52E7-L50B2 $0235  9
         fdb   L5354-L50B2 $02a2  A
         fdb   L5331-L50B2 $027f  B
         fdb   Strterm-L50B2 $05f9  C
         fdb   L569B-L50B2 $05e9  D
         fdb   SETFP-L50B2 $0478  E
         fdb   ERR48-L50B2 $0a11  F    Exit with Unimplemented routine err
         fdb   L568C-L50B2 $05da  10
         fdb   PRNTUSIN-L50B2 $06ba  11
         fdb   L5614-L50B2 $0562  12
         fdb   L580B-L50B2 $0759  13
L50DA    fdb   L56B4-L50B2 $0602  14

* Table for Integer conversion
L50DC    fdb   10000
         fdb   1000
         fdb   100
         fdb   10

* Table for REAL conversion
L50E4    fcb   $04,$a0,$00,$00,$00 10
         fcb   $07,$c8,$00,$00,$00 100
         fcb   $0a,$fa,$00,$00,$00 1000
         fcb   $0e,$9c,$40,$00,$00 10 thousand
         fcb   $11,$c3,$50,$00,$00 100 thousand
         fcb   $14,$f4,$24,$00,$00 1 million
         fcb   $18,$98,$96,$80,$00 10 million
         fcb   $1b,$be,$bc,$20,$00 100 million
         fcb   $1e,$ee,$6b,$28,$00 1 billion
         fcb   $22,$95,$02,$f9,$00 10 billion
         fcb   $25,$ba,$43,$b7,$40 100 billion
         fcb   $28,$e8,$d4,$a5,$10 1 trillion
         fcb   $2c,$91,$84,$e7,$2a 10 trillion
         fcb   $2f,$b5,$e6,$20,$f4 100 trillion
         fcb   $32,$e3,$5f,$a9,$32 1 quadrillion
         fcb   $36,$8e,$1b,$c9,$c0 10 quadrillion
         fcb   $39,$b1,$a2,$bc,$2e 100 quadrillion
         fcb   $3c,$de,$0b,$6b,$3a 1 quintillion
L513E    fcb   $40,$8a,$c7,$23,$04 10 quintillion

TRUESTR  fcc   'True'
         fcb   C$EOS

FALSESTR fcc   'False'
         fcb   C$EOS

* <u0024 function 2
AtoITR   pshs  u
         leay  -6,y       Make room for temp var
         clra
         clrb
         sta   <u0075
         sta   <u0076
         sta   <u0077
         sta   <u0078
         sta   <u0079
         std   $04,y
         std   $02,y
         sta   $01,y
         lbsr  L5390
         bcc   L5172
         leax  -$01,x
         cmpa  #$2C
         bne   ERR59
         lbra  L51FB

L5172    cmpa  #$24  $
         lbeq  L52B2
         cmpa  #$2B  +
         beq   L5182
         cmpa  #$2D  -
         bne   L5184
         inc   <u0078
L5182    lda   ,x+
L5184    cmpa  #$2E  .
         bne   L5190
         tst   <u0077
         bne   ERR59
         inc   <u0077
         bra   L5182
L5190    lbsr  L57DE
         bcs   L51E5
         pshs  a
         inc   <u0076
         ldd   $04,y
         ldu   $02,y
         bsr   L51CB
         std   $04,y
         stu   $02,y
         bsr   L51CB
         bsr   L51CB
         addd  $04,y
         exg   d,u
         adcb  $03,y
         adca  $02,y
         bcs   L51D8
         exg   d,u
         addb  ,s+
         adca  #$00
         bcc   L51BF
         leau  1,u
         stu   $02,y
         beq   L51DA
L51BF    std   $04,y
         stu   $02,y
         tst   <u0077
         beq   L5182
         inc   <u0079
         bra   L5182
L51CB    lslb
         rola
         exg   d,u
         rolb
         rola
         exg   d,u
         bcs   L51D6
         rts
L51D6    leas  $02,s
L51D8    leas  $01,s
L51DA    ldb   #$3C
         bra   L51E0

ERR59    ldb   #E$IONum
L51E0    stb   <errcode
         coma
         puls  pc,u

L51E5    eora  #$45
         anda  #$DF
         beq   L520E
         leax  -$01,x
         tst   <u0076
         bne   L51F3
         bra   ERR59
L51F3    tst   <u0077
         bne   L523C
         ldd   $02,y
         bne   L523C
L51FB    ldd   $04,y
         bmi   L523C
         tst   <u0078
         beq   L5207
         nega
         negb
         sbca  #$00
L5207    std   $01,y
L5209    lda   #$01
         lbra  L5295
L520E    lda   ,x
         cmpa  #$2B  +
         beq   L521A
         cmpa  #$2D  -
         bne   L521C
         inc   <u0075
L521A    leax  $01,x
L521C    lbsr  L57DC
         bcs   ERR59
         tfr   a,b
         lbsr  L57DC
         bcc   L522C
         leax  -$01,x
         bra   L5233
L522C    pshs  a
         lda   #10
         mul
         addb  ,s+
L5233    tst   <u0075
         bne   L5238
         negb
L5238    addb  <u0079
         stb   <u0079
L523C    ldb   #$20
         stb   $01,y
         ldd   $02,y
         bne   L524D
         cmpd  $04,y
         bne   L524D
         clr   $01,y
         bra   L5293
L524D    tsta
         bmi   L525A
L5250    dec   $01,y
         lsl   $05,y
         rol   $04,y
         rolb
         rola
         bpl   L5250
L525A    std   $02,y
         clr   <u0075
         ldb   <u0079
         beq   L528B
         bpl   L5267
         negb
         inc   <u0075
L5267    cmpb  #$13
         bls   L527B
         subb  #$13
         pshs  b
         leau  >L513E,pcr
         bsr   L529B
         puls  b
         lbcs  L51DA
L527B    decb
         lda   #$05
         mul
         leau  >L50E4,pcr
         leau  b,u
         bsr   L529B
         lbcs  L51DA
L528B    lda   $05,y
         anda  #$FE
         ora   <u0078
         sta   $05,y
L5293    lda   #REALTYPE
L5295    sta   ,y
         andcc #^Carry
         puls  pc,u
L529B    leay  -6,y
         ldd   ,u
         std   $01,y
         ldd   2,u
         std   $03,y
         ldb   4,u
         stb   $05,y
         lda   <u0075
         lbeq  L509E
         lbra  L50A1

* Read hex digit
L52B2    lbsr  L57DC  Read number
         bcc   L52C7
         cmpa  #'a
         bcs   L52BD
         suba  #$20
L52BD    cmpa  #'A
         bcs   L52DC
         cmpa  #'F
         bhi   L52DC
         suba  #$37
L52C7    inc   <u0076
         ldb   #$04
L52CB    lsl   $02,y
         rol   $01,y
         lbcs  L51DA
         decb
         bne   L52CB
         adda  $02,y
         sta   $02,y
         bra   L52B2
L52DC    leax  -$01,x
         tst   <u0076
         lbeq  ERR59
         lbra  L5209

L52E7    pshs  x
         ldx   <u0082
         lbsr  AtoITR
         bcc   L52F2
L52F0    puls  pc,x
L52F2    cmpa  #$02
         beq   L52F9
         lbsr  Flote
L52F9    lbsr  L5384
         bcs   L5305
         ldb   #E$Illinp
         stb   <errcode
         coma
         puls  pc,x
L5305    stx   <u0082
         clra
         puls  pc,x

L530A    pshs  x
         ldx   <u0082
         lbsr  AtoITR
         bcs   L52F0
         cmpa  #$01
         bne   ERR58
         tst   $01,y
         beq   L52F9
         bra   ERR58

L531D    pshs  x
         ldx   <u0082
         lbsr  AtoITR
         bcs   L52F0
         cmpa  #$01
         beq   L52F9
ERR58    ldb   #E$IOMism
         stb   <errcode
         coma
         puls  pc,x

* verify string
L5331    pshs  u,x
         leay  -6,y
         ldu   <u004A
         stu   $01,y
         lda   #STRTYPE
         sta   ,y
         ldx   <u0082
L533F    lda   ,x+
         bsr   L5396
         bcs   L5349
         sta   ,u+
         bra   L533F

L5349    stx   <u0082
         lda   #$FF
         sta   ,u+
         stu   <u0048
         clra
         puls  pc,u,x

* Boolean -> internal repr.
L5354    pshs  x
         leay  -6,y
         lda   #BOOLTYPE
         sta   ,y
         clr   $02,y
         ldx   <u0082
         bsr   L5390
         bcs   L537F
         cmpa  #'T
         beq   L5379
         cmpa  #'t
         beq   L5379
         eora  #$46
         anda  #$DF
         beq   L537B
         ldb   #E$IOMism
         stb   <errcode
         coma
         puls  pc,x

L5379    com   $02,y
L537B    bsr   L5384
         bcc   L537B
L537F    stx   <u0082
         clra
         puls  pc,x

* validate characters
L5384    lda   ,x+
         cmpa  #C$SPAC                  space?
         bne   L5396
         bsr   L5390
         bcc   L53A5
         bra   L53A7
L5390    lda   ,x+
         cmpa  #C$SPAC                  space?
         beq   L5390                    skip them
L5396    cmpa  <u00DD
         beq   L53A7
         cmpa  #C$CR                    CR?
         beq   L53A5
         cmpa  #C$EOS                     end of string?
         beq   L53A5
         andcc #^Carry
         rts
L53A5    leax  -$01,x
L53A7    orcc  #Carry
         rts

* integer to ASCII
L53AA    pshs  u,x
         clra
         sta   $03,y
         sta   <u0076
         sta   <u0078
         lda   #$04
         sta   <u007E
         ldd   $01,y
         bpl   L53C1
         nega
         negb
         sbca  #$00
         inc   <u0078
L53C1    leau  >L50DA,pcr
L53C5    clr   <u007A
         leau  2,u
L53C9    subd  ,u
         bcs   L53D1
         inc   <u007A
         bra   L53C9
L53D1    addd  ,u
         tst   <u007A
         bne   L53DB
         tst   $03,y
         beq   L53E6
L53DB    inc   $03,y
         pshs  a
         lda   <u007A
         lbsr  L54EA
         puls  a
L53E6    dec   <u007E
         bne   L53C5
         tfr   b,a
         lbsr  L54EA
         leay  6,y
         puls  pc,u,x

* Real to ASCII
RtoA     pshs  u,x
         clr   <u0075
         clr   <u0078
         clr   <u007C
         clr   <u007B
         clr   <u0079
         clr   <u0076
         leau  ,x
         ldd   #$0A30
L5406    stb   ,u+
         deca
         bne   L5406
         ldd   $01,y
         bne   L5413
         inca
         lbra  L54E4
L5413    ldb   $05,y
         bitb  #$01
         beq   L541F
         stb   <u0078
         andb  #$FE
         stb   $05,y
L541F    ldd   $01,y
         bpl   L5426
         inc   <u0075
         nega
L5426    cmpa  #$03
         bls   L5457
         ldb   #$9A
         mul
         lsra
         nop
         nop
         tfr   a,b
         tst   <u0075
         beq   L5437
         negb
L5437    stb   <u0079
         cmpa  #$13
         bls   L544A
         pshs  a
         leau  >L513E,pcr
         lbsr  L529B
         puls  a
         suba  #$13
L544A    leau  >L50E4,pcr
         deca
         ldb   #$05
         mul
         leau  d,u
         lbsr  L529B
L5457    ldd   $02,y
         tst   $01,y
         beq   L5483
         bpl   L546F
L545F    lsra
         rorb
         ror   $04,y
         ror   $05,y
         ror   <u007C
         inc   $01,y
         bne   L545F
         std   $02,y
         bra   L5483
L546F    lsl   $05,y
         rol   $04,y
         rolb
         rola
         rol   <u007B
         dec   $01,y
         bne   L546F
         std   $02,y
         inc   <u0079
         lda   <u007B
         bsr   L54EA
L5483    ldd   $02,y
         ldu   $04,y
L5487    clr   <u007B
         bsr   L54F1
         std   $02,y
         stu   $04,y
         pshs  a
         lda   <u007B
         sta   <u007C
         puls  a
         bsr   L54F1
         bsr   L54F1
         exg   d,u
         addd  $04,y
         exg   d,u
         adcb  $03,y
         adca  $02,y
         pshs  a
         lda   <u007B
         adca  <u007C
         bsr   L54EA
         lda   <u0076
         cmpa  #$09
         puls  a
         beq   L54C1
         cmpd  #$0000
         bne   L5487
         cmpu  #$0000
         bne   L5487
L54C1    sta   ,y
         lda   <u0076
         cmpa  #$09
         bcs   L54E2
         ldb   ,y
         bpl   L54E2
L54CD    lda   ,-x
         inca
         sta   ,x
         cmpa  #$39
         bls   L54E2
         lda   #$30
         sta   ,x
         cmpx  ,s
         bne   L54CD
         inc   ,x
         inc   <u0079
L54E2    lda   #$09
L54E4    sta   <u0076
         leay  6,y
         puls  pc,u,x
L54EA    ora   #$30
         sta   ,x+
         inc   <u0076
         rts
L54F1    exg   d,u
         lslb
         rola
         exg   d,u
         rolb
         rola
         rol   <u007B
         rts

READLN   pshs  y,x
         ldx   <u0080
         stx   <u0082
         lda   #$01
         sta   <u007D
         ldy   #$0100
         lda   <u007F  get path number
         os9   I$ReadLn
         bra   L5524

WRITLN   pshs  y,x
         ldd   <u0082
         subd  <u0080
         beq   L5528
         tfr   d,y
         ldx   <u0080
         stx   <u0082
         lda   <u007F  get path number
         os9   I$WritLn
L5524    bcc   L5528
         stb   <errcode
L5528    puls  pc,y,x

SETFP    pshs  u,x
         lda   ,y               type of file pointer
         cmpa  #REALTYPE
         beq   L5536            real
         ldu   $01,y            else integer
         bra   L553D

* Seek with real argument
L5536    lda   $01,y            if exponent is <=0, Seek to 0
         bgt   L5542            positive value, go calculate logint for SEEK
         ldu   #$0000
L553D    ldx   #$0000
         bra   L555E

L5542    ldx   $02,y
         ldu   $04,y
         suba  #$20
         bcs   L554F
         ldb   #E$SeekRg  Seek out of range
         coma
         bra   L5565

L554F    exg   x,d
         lsra
         rorb
         exg   d,u
         rora
         rorb
         exg   d,x
         exg   x,u
         inca
         bne   L554F
L555E    lda   <u007F  get path number
         os9   I$Seek
         bcc   L5567
L5565    stb   <errcode
L5567    puls  pc,u,x

* print real numbers
PRreal   pshs  u,x
         leas  -$0A,s
         leax  ,s
         lbsr  RtoA
         pshs  x
         lda   #$09
         leax  $09,x
L5578    ldb   ,-x
         cmpb  #$30
         bne   L5583
         deca
         cmpa  #$01
         bne   L5578
L5583    sta   <u0076
         puls  x
         ldb   <u0079
         bgt   L55AC
         negb
         tfr   b,a
         cmpb  #$09
         bhi   L55C6
         addb  <u0076
         cmpb  #$09
         bhi   L55C6
         pshs  a
         lbsr  L5643
         clra
         bsr   L5612
         puls  b
         tstb
         beq   L55A8
         lbsr  L5634
L55A8    lda   <u0076
         bra   L55BF
L55AC    cmpb  #$09
         bhi   L55C6
         lbsr  L5643
         tfr   b,a
         bsr   L5601
         bsr   L5612
         lda   <u0076
         suba  <u0079
         bls   L55C1
L55BF    bsr   L5601
L55C1    leas  $0A,s
         clra
         puls  pc,u,x
L55C6    bsr   L5643
         lda   #$01
         bsr   L5601
         bsr   L5612
         lda   <u0076
         deca
         bne   L55D4
         inca
L55D4    bsr   L5601
         bsr   L55DA
         bra   L55C1
L55DA    lda   #$45
         bsr   L5614
         lda   <u0079
         deca
         pshs  a
         bpl   L55EB
         neg   ,s
         bsr   L5647
         bra   L55ED
L55EB    bsr   L564B
L55ED    puls  b
         clra
L55F0    subb  #$0A
         bcs   L55F7
         inca
         bra   L55F0
L55F7    addb  #$0A
         bsr   L55FD
         tfr   b,a
L55FD    adda  #$30
         bra   L5614
L5601    tfr   a,b
         tstb
         beq   L560D
L5606    lda   ,x+
         bsr   L5614
         decb
         bne   L5606
L560D    rts

L560E    lda   #$20
         bra   L5614
L5612    lda   #$2E
L5614    pshs  u,a
         leau  <-$40,s
         cmpu  <u0082
         bhi   L562A
         cmpa  #$0D
         beq   L562A
         lda   #$50
         sta   <errcode
         sta   <u00DE
         bra   L5632

L562A    ldu   <u0082
         sta   ,u+
         stu   <u0082
         inc   <u007D
L5632    puls  pc,u,a

L5634    lda   #$30
L5636    tstb                   0 chars?
         beq   L563E            yes, return
L5639    bsr   L5614
         decb
         bne   L5639
L563E    rts

L563F    tst   <u0078
         beq   L560E
L5643    tst   <u0078
         beq   L563E
L5647    lda   #$2D
         bra   L5614

L564B    lda   #$2B
         bra   L5614

Spacing  lda   #C$SPAC
         bra   L5636

L5653    bsr   L5614
L5655    lda   ,x+
         cmpa  #C$EOS
         bne   L5653
         rts

* print string
PRstring pshs  x
         ldx   $01,y
L5660    bsr   L5655
         clra
         puls  pc,x

* print boolean
PRbool   pshs  x
         leax  >TRUESTR,pcr
         lda   $02,y
         bne   L5660
         leax  >FALSESTR,pcr
         bra   L5660

* print integers
PRintg   pshs  u,x
         leas  -$05,s
         leax  ,s
         lbsr  L53AA
         bsr   L5643
         lda   <u0076
         leax  ,s
         lbsr  L5601
         leas  $05,s
         clra
         puls  pc,u,x

* <u002A Function 2, sub-function $10 - Add B spaces to temp buffer
* Entry: A=# spaces to append to temp buffer
L568C    tfr   a,b        Move byte we are working with to B
L568E    pshs  u          Preserve U
         ldu   <u0082
         subb  <u007D
         bls   L5698
         bsr   Spacing
L5698    clra
         puls  pc,u

L569B    lbsr  L560E
L569E    lda   <u007D
         anda  #$0F
         cmpa  #$01
         beq   L56B2
         lbsr  L560E
         bra   L569E

* terminate string
Strterm  lda   #C$CR
         clr   <u007D
         lbsr  L5614
L56B2    clra
         rts

L56B4    pshs  u
         lda   #$04
         leau  ,y
         tst   ,u
         bne   L56C1
         asra
         leau  1,u
L56C1    sta   <u0086
         tfr   a,b
         asrb
         lbsr  L585D
         puls  pc,u
L56CB    clrb
         stb   <u0087
         cmpa  #$3C
         beq   L56DE
         cmpa  #$3E
         bne   L56D9
         incb
         bra   L56DE
L56D9    cmpa  #$5E
         bne   L56E2
         decb
L56DE    stb   <u0087
         lda   ,x+
L56E2    cmpa  #$2C
         beq   L571E
         cmpa  #C$EOS
         bne   L56FC
         lda   <u0094
         beq   L56F2
         leax  -$01,x
         bra   L5707
L56F2    ldx   <u008E
         tst   <u00DC
         beq   L5700
         clr   <u00DC
         bra   L571E
L56FC    cmpa  #$29
         beq   L5703
L5700    orcc  #Carry
         rts

L5703    lda   <u0094
         beq   L5700
L5707    dec   <u0092
         bne   L571C
         ldu   <u0046
         pulu  y,a
         sta   <u0092
         sty   <u0090
         stu   <u0046
         lda   ,x+
         dec   <u0094
         bra   L56E2
L571C    ldx   <u0090
L571E    stx   <u008C
         andcc #^Carry
         rts

* Print USING format specifiers
L5723    fcc   'I'        Integer
         fdb   ARGUS1-L5723
L5726    fcc   'H'        Hexidecimal
         fdb   ARGUS1-L5726
L5729    fcc   'R'        Real
         fdb   ARGUS2-L5729
L572C    fcc   'E'        Exponential
         fdb   ARGUS2-L572C
L572F    fcc   'S'        String
         fdb   ARGUS1-L572F
L5732    fcc   'B'        Boolean
         fdb   ARGUS1-L5732
L5735    fcc   'T'        Tab
         fdb   ARGUS3-L5735
L5738    fcc   'X'        Spaces
         fdb   ARGUS4-L5738
L573B    fcc   "'"        Quoted text
         fdb   ARGUS5-L573B
         fcb   $00        End of table marker

* 'T' (tab)
ARGUS3   bsr   L56E2
         bcs   L57A7
         ldb   <u0086
         lbsr  L568E
         bra   L5772

* 'X' (spaces)
ARGUS4   bsr   L56E2
         bcs   L57A7
         ldb   <u0086
         lbsr  Spacing
         bra   L5772

* print literal string
ARGUS5   cmpa  #C$EOS                     end of string?
         beq   L57A7
         cmpa  #$27
         bne   L5765
         lda   ,x+
         bsr   L56E2
         bcs   L57A7
         bra   L5772

L5765    lbsr  L5614
         lda   ,x+
         bra   ARGUS5

PRNTUSIN pshs  y,x
         clr   <u00DC
         inc   <u00DC
L5772    ldx   <u008C
         bsr   L57C2
         bcs   L5791
         cmpa  #$28
         bne   L57AB
         lda   <u0092
         stb   <u0092
         beq   L57AB
         inc   <u0094
         ldu   <u0046
         ldy   <u0090
         pshu  y,a
         stu   <u0046
         stx   <u0090
         lda   ,x+
L5791    leay  >L5723,pcr
         clrb
L5796    pshs  a
         eora  ,y
         anda  #$DF
         puls  a
         beq   L57B2
         leay  $03,y
         incb
         tst   ,y
         bne   L5796
L57A7    ldb   #$3F
         bra   L57AD

L57AB    ldb   #E$IOFRpt
L57AD    stb   <errcode
         coma
         puls  pc,y,x

L57B2    stb   <u0085
         ldd   $01,y
         leay  d,y
         bsr   L57C2
         bcc   L57BE
         ldb   #$01
L57BE    stb   <u0086
         jmp   ,y

L57C2    bsr   L57DC
         bcs   L57EB
         tfr   a,b
         bsr   L57DC
         bcs   L57E8
         bsr   L57EE
         bsr   L57DC
         bcs   L57E8
         bsr   L57EE
         tsta
         beq   L57D8
         clrb
L57D8    lda   ,x+
         bra   L57E8

* Parse digit. Sets carry if it is not a digit.
L57DC    lda   ,x+
L57DE    cmpa  #'0
         bcs   L57EB
         cmpa  #'9
         bhi   L57EB
         suba  #'0
L57E8    andcc #^Carry
         rts
L57EB    orcc  #Carry
         rts

* Entry: A=LSB of ASCII 0-9 converted to binary, B=MSB
L57EE    pshs  a
         lda   #10
         mul
         addb  ,s+
         adca  #$00
         rts

ARGUS2   cmpa  #'.
         bne   L57A7
         bsr   L57C2
         bcs   L57A7
         stb   <u0089

ARGUS1   lbsr  L56CB                    Int, Hex, String, Boolean
         bcs   L57A7
         puls  y,x
         inc   <u00DC
L580B    ldb   <u0085
         lbeq  FMTint
         decb
         beq   L5826
         decb
         lbeq  L5969
         decb
         lbeq  FMTexp
         decb
         lbeq  FMTstr
         lbra  FMTbool

L5826    jsr   <u0016
         cmpa  #$04
         bcs   L583C
         ldu   $01,y
         clrb
L582F    lda   ,u+
         cmpa  #C$EOS
         beq   L5838
         incb
         bne   L582F
L5838    ldu   $01,y
         bra   L585D
L583C    leau  $01,y
         lda   ,y
         cmpa  #$02
         bne   L5848
         ldb   #$05
         bra   L585D
L5848    cmpa  #$01
         bne   L5852
         ldb   #$02
         cmpb  <u0086
         bcs   L5856
L5852    ldb   #$01
         leau  1,u
L5856    tfr   b,a
         lsla
         cmpa  <u0086
         bhi   L5893
L585D    tst   <u0087
         beq   L5889
         bmi   L5870
         pshs  b
         lslb
         pshs  b
         ldb   <u0086
         subb  ,s+
         bcs   L5887
         bra   L587C
L5870    pshs  b
         lslb
         pshs  b
         ldb   <u0086
         subb  ,s+
         bcs   L5887
         asrb
L587C    pshs  b
         lda   <u0086
         suba  ,s+
         sta   <u0086
         lbsr  Spacing
L5887    puls  b
L5889    lda   ,u
         lsra
         lsra
         lsra
         lsra
         bsr   L58A3
         beq   L58A1
L5893    lda   ,u+
         bsr   L58A3
         beq   L58A1
         decb
         bne   L5889
         ldb   <u0086
         lbsr  Spacing
L58A1    clra
         rts

L58A3    anda  #$0F
         cmpa  #$09
         bls   L58AB
         adda  #$07
L58AB    lbsr  L55FD
         dec   <u0086
         rts

L58B1    coma
         rts

FMTint   jsr   <u0016
         cmpa  #$02
         bcs   L58BE
         bne   L58B1                    wrong var type
         lbsr  L5098
L58BE    pshs  u,x
         leas  -$05,s
         leax  ,s
         lbsr  L53AA
         ldb   <u0086
         decb
         subb  <u0076
         bpl   L58D5
         leas  $05,s
         puls  u,x
         lbra  Overflow

L58D5    tst   <u0087
         beq   L58E3                    left justify
         bmi   L58F4                    leading zeros
         lbsr  Spacing                  right justify
         lbsr  L563F
         bra   L58FA

L58E3    lbsr  L563F
         pshs  b
         lda   <u0076
         lbsr  L5601
         puls  b
         lbsr  Spacing
         bra   L58FF

L58F4    lbsr  L563F
         lbsr  L5634
L58FA    lda   <u0076
         lbsr  L5601
L58FF    leas  $05,s
         clra
         puls  pc,u,x

FMTbool  jsr   <u0016
         cmpa  #BOOLTYPE
         bne   L58B1                    wrong type
         pshs  u,x
         leax  >TRUESTR,pcr
         ldb   #$04   length of 'true'
         lda   $02,y
         bne   L5932
         leax  >FALSESTR,pcr
         ldb   #$05   length of 'false'
         bra   L5932

FMTstr   jsr   <u0016
         cmpa  #STRTYPE
         bne   L58B1                    wrong type
         pshs  u,x
         ldx   $01,y
         ldd   <u0048
         subd  $01,y
         subd  #$0001
         tsta
         bne   L5936
L5932    cmpb  <u0086
         bls   L5938
L5936    ldb   <u0086
L5938    tfr   b,a
         negb
         addb  <u0086
         tst   <u0087
         beq   L594F                    left justify
         bmi   L5953                    center text
         pshs  a                        right justify
         lbsr  Spacing
         puls  a
         lbsr  L5601
         bra   L5966
L594F    pshs  b
         bra   L595E
L5953    lsrb
         bcc   L5957
         incb
L5957    pshs  b,a
         lbsr  Spacing
         puls  a
L595E    lbsr  L5601
         puls  b
         lbsr  Spacing
L5966    clra
         puls  pc,u,x

L5969    jsr   <u0016
         cmpa  #$02
         beq   L5976
         lbcc  L58B1
         lbsr  Flote
L5976    pshs  u,x
         leas  -$0A,s
         leax  ,s
         lbsr  RtoA
         lda   <u0079
         cmpa  #$09
         bgt   L5996
         lbsr  L5A6A
         lda   <u0086
         suba  #$02
         bmi   L5996
         suba  <u0089
         bmi   L5996
         suba  <u008A
         bpl   L599C
L5996    leas  $0A,s
         puls  u,x
         bra   Overflow

L599C    sta   <u0088
         leax  ,s
         ldb   <u0087
         beq   L59AC                    left justify
         bmi   L59B2                    fin. format
         bsr   L59E9                    right justify
         bsr   L59BE
         bra   L59B9
L59AC    bsr   L59BE
         bsr   L59E9
         bra   L59B9
L59B2    bsr   L59E9
         bsr   L59C1
         lbsr  L563F
L59B9    leas  $0A,s
         clra
         puls  pc,u,x
L59BE    lbsr  L563F
L59C1    lda   <u008A
         lbsr  L5601
         lbsr  L5612
         ldb   <u0079
         bpl   L59F9
         negb
         cmpb  <u0089
         bls   L59D4
         ldb   <u0089
L59D4    pshs  b
         lbsr  L5634
         ldb   <u0089
         subb  ,s+
         stb   <u0089
         lda   <u008B
         cmpa  <u0089
         bls   L59E7
         lda   <u0089
L59E7    bra   L59FB

L59E9    ldb   <u0088
         lbra  Spacing
L59EE    lbsr  L563F
         lda   <u008A
         lbsr  L5601
         lbsr  L5612
L59F9    lda   <u008B
L59FB    lbsr  L5601
         ldb   <u0089
         subb  <u008B
         ble   L5A0F
         lbra  L5634

Overflow ldb   <u0086
         lda   #'*
         lbsr  L5636
         clra
L5A0F    rts

FMTexp   jsr   <u0016
         cmpa  #$02
         beq   L5A1D
         lbcc  L58B1                    wrong type
         lbsr  Flote
L5A1D    pshs  u,x
         leas  -$0A,s
         leax  ,s
         lbsr  RtoA
         lda   <u0079
         pshs  a
         lda   #$01
         sta   <u0079
         bsr   L5A6A
         puls  a
         ldb   <u0079
         cmpb  #$01
         beq   L5A39
         inca
L5A39    ldb   #$01
         stb   <u008A
         sta   <u0079
         lda   <u0086
         suba  #$06
         bmi   L5A4D
         suba  <u0089
         bmi   L5A4D
         suba  <u008A
         bpl   L5A53
L5A4D    leas  $0A,s
         puls  u,x
         bra   Overflow
L5A53    sta   <u0088
         ldb   <u0087
         beq   L5A62
         bsr   L59E9
         bsr   L59EE
         lbsr  L55DA
         bra   L5A67
L5A62    bsr   L59EE
         lbsr  L55DA
L5A67    lbra  L59B9
L5A6A    pshs  x
         lda   <u0079
         adda  <u0089
         bne   L5A78
         lda   ,x
         cmpa  #$35
         bcc   L5A8F
L5A78    deca
         bmi   L5AAB
         cmpa  #$07
         bhi   L5AAB
         leax  a,x
         ldb   $01,x
         cmpb  #$35
         bcs   L5AAB
L5A87    inc   ,x
         ldb   ,x
         cmpb  #$39
         bls   L5AAB
L5A8F    ldb   #$30
         stb   ,x
         leax  -$01,x
         cmpx  ,s
         bcc   L5A87
         ldx   ,s
         leax  $08,x
L5A9D    lda   ,-x
         sta   $01,x
         cmpx  ,s
         bhi   L5A9D
         lda   #$31
         sta   ,x
         inc   <u0079
L5AAB    puls  x
         lda   <u0079
         bpl   L5AB2
         clra
L5AB2    sta   <u008A
         nega
         adda  #$09
         bpl   L5ABA
         clra
L5ABA    cmpa  <u0089
         bls   L5AC0
         lda   <u0089
L5AC0    sta   <u008B
         rts

ERR48    ldb   #E$NoRout        Unimplemented routine error
         stb   <errcode
         coma
         rts

         emod
B09END   equ   *
         end
