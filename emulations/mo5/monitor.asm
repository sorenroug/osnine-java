* Disassmbly of mo5.rom

*****************************************************
** Used Labels                                      *
*****************************************************

Z0000   EQU     $0000
M0001   EQU     $0001
M0002   EQU     $0002
M0004   EQU     $0004
M0008   EQU     $0008
M000C   EQU     $000C
M0010   EQU     $0010
M0012   EQU     $0012
M0014   EQU     $0014
M0018   EQU     $0018
M0019   EQU     $0019
M001A   EQU     $001A
M001B   EQU     $001B
M001C   EQU     $001C
M001D   EQU     $001D
M001E   EQU     $001E
M001F   EQU     $001F
M0020   EQU     $0020
M0021   EQU     $0021
M0022   EQU     $0022
M0023   EQU     $0023
M0024   EQU     $0024
M0025   EQU     $0025
M0027   EQU     $0027
M0028   EQU     $0028
M0029   EQU     $0029
M002A   EQU     $002A
COLOUR   EQU     $002B
M002C   EQU     $002C
M002D   EQU     $002D
M002E   EQU     $002E
M002F   EQU     $002F
M0030   EQU     $0030
ITCMPT   EQU     $0031 ; Counter for cursor blink
M0032   EQU     $0032
M0033   EQU     $0033
M0034   EQU     $0034
M0035   EQU     $0035
M0036   EQU     $0036
M0037   EQU     $0037
M0038   EQU     $0038
M003A   EQU     $003A
M003C   EQU     $003C
M003D   EQU     $003D
M003E   EQU     $003E
M003F   EQU     $003F
M0040   EQU     $0040
M0041   EQU     $0041
M0042   EQU     $0042
M0043   EQU     $0043
M0044   EQU     $0044
M0045   EQU     $0045
M0046   EQU     $0046
M0047   EQU     $0047
M0050   EQU     $0050
M0058   EQU     $0058
M0059   EQU     $0059
M005A   EQU     $005A
M005B   EQU     $005B
M005C   EQU     $005C
M005D   EQU     $005D
M0063   EQU     $0063
M0064   EQU     $0064
M0066   EQU     $0066
M0067   EQU     $0067
M006A   EQU     $006A
M006D   EQU     $006D
M0070   EQU     $0070
M0073   EQU     $0073
M0076   EQU     $0076
M0078   EQU     $0078
M007C   EQU     $007C
Z007E   EQU     $007E
M0080   EQU     $0080
M0082   EQU     $0082
M0089   EQU     $0089
M008E   EQU     $008E
M0092   EQU     $0092
M00A0   EQU     $00A0
M00A6   EQU     $00A6
M00A7   EQU     $00A7
M00AD   EQU     $00AD
M00BD   EQU     $00BD
M00D6   EQU     $00D6
M00D7   EQU     $00D7
M00DA   EQU     $00DA
M00E4   EQU     $00E4
M00E6   EQU     $00E6
M00E7   EQU     $00E7
M00F2   EQU     $00F2
M00F8   EQU     $00F8
M00FA   EQU     $00FA
M00FE   EQU     $00FE
M00FF   EQU     $00FF
M0101   EQU     $0101
M0110   EQU     $0110
M0117   EQU     $0117
M0118   EQU     $0118
M013F   EQU     $013F
M0140   EQU     $0140
M01BD   EQU     $01BD
M01DC   EQU     $01DC
M0278   EQU     $0278
M030D   EQU     $030D
M032C   EQU     $032C
M0370   EQU     $0370
M0386   EQU     $0386
M03F7   EQU     $03F7
M0402   EQU     $0402
M0404   EQU     $0404
M04E2   EQU     $04E2
M0649   EQU     $0649
M070C   EQU     $070C
M0801   EQU     $0801
M0F38   EQU     $0F38
M1010   EQU     $1010
M1012   EQU     $1012
M127C   EQU     $127C
M13A0   EQU     $13A0
M1550   EQU     $1550
M1850   EQU     $1850
M187B   EQU     $187B
M1B06   EQU     $1B06
M1F40   EQU     $1F40
M2000   EQU     $2000
M2019   EQU     $2019
M201A   EQU     $201A
M201C   EQU     $201C
M2021   EQU     $2021
M2025   EQU     $2025
M2044   EQU     $2044
SWIVEC  EQU     $205E
TIMEVEC   EQU     $2061
Z2064   EQU     $2064
Z2067   EQU     $2067
M2076   EQU     $2076
M20CC   EQU     $20CC
LPBUFF   EQU     $20CD
M20D0   EQU     $20D0
M20D3   EQU     $20D3
M20E4   EQU     $20E4
M2200   EQU     $2200
Z2222   EQU     $2222
M23FA   EQU     $23FA
Z2414   EQU     $2414
M3262   EQU     $3262
M3810   EQU     $3810
M3AFF   EQU     $3AFF
M3E3F   EQU     $3E3F
M3F40   EQU     $3F40
M4001   EQU     $4001
Z4040   EQU     $4040
M407E   EQU     $407E
Z4224   EQU     $4224
Z423C   EQU     $423C
Z4242   EQU     $4242
Z426E   EQU     $426E
M4844   EQU     $4844
M4940   EQU     $4940
M4B63   EQU     $4B63
M5454   EQU     $5454
M6108   EQU     $6108
M687C   EQU     $687C
M71F7   EQU     $71F7
M7A77   EQU     $7A77
M7C1B   EQU     $7C1B
M7FAD   EQU     $7FAD
M8000   EQU     $8000
M83F7   EQU     $83F7
M83F8   EQU     $83F8
M8680   EQU     $8680
M86BF   EQU     $86BF
M87F3   EQU     $87F3
M8C01   EQU     $8C01
M8D02   EQU     $8D02
M8D10   EQU     $8D10
M8D40   EQU     $8D40
M8DC5   EQU     $8DC5
M90F7   EQU     $90F7
M93FA   EQU     $93FA
M9570   EQU     $9570
M9620   EQU     $9620
M962B   EQU     $962B
M963D   EQU     $963D
M9A2A   EQU     $9A2A
M9B74   EQU     $9B74
M9BF0   EQU     $9BF0
M9EFC   EQU     $9EFC
MA000   EQU     $A000
MA484   EQU     $A484
MA55A   EQU     $A55A
MA59C   EQU     $A59C
PIAPORTA   EQU     $A7C0
PIAPORTB   EQU     $A7C1
PIA_CRB   EQU     $A7C3
MA7E0   EQU     $A7E0
MA802   EQU     $A802
MADF0   EQU     $ADF0
MB935   EQU     $B935
MCAF9   EQU     $CAF9
ZCB83   EQU     $CB83
ZCBED   EQU     $CBED
ZCBF9   EQU     $CBF9
MD5F5   EQU     $D5F5
MD976   EQU     $D976
MDC27   EQU     $DC27
ME075   EQU     $E075
ME665   EQU     $E665
ME801   EQU     $E801
ME960   EQU     $E960
MEE97   EQU     $EE97
ZEFFE   EQU     $EFFE

*****************************************************
** Program Code / Data Areas                        *
*****************************************************

        ORG     $F000

        CLR     M2200                    ;F000: 7F 22 00

hdlr_RST LDB     #$20                     ;F003: C6 20
        TFR     B,DP                     ;F005: 1F 9B
        LDS     #M20CC                   ;F007: 10 CE 20 CC
        LDX     #M2076                   ;F00B: 8E 20 76
        LDU     #MA55A                   ;F00E: CE A5 5A
        CMPU    M00FE                    ;F011: 11 93 FE
        BEQ     ZF01F                    ;F014: 27 09
        STU     M00FE                    ;F016: DF FE
        LDU     #M070C                   ;F018: CE 07 0C
        STU     ,X                       ;F01B: EF 84
        STU     $01,X                    ;F01D: EF 01
ZF01F   CLRA                             ;F01F: 4F
        LDU     #MF0B3                   ;F020: CE F0 B3
ZF023   PULU    Y                        ;F023: 37 20
        STA     ,-X                      ;F025: A7 82
        STY     ,--X                     ;F027: 10 AF 83
        CMPX    #SWIVEC                   ;F02A: 8C 20 5E
        BGT     ZF023                    ;F02D: 2E F4
ZF02F   STA     ,-X                      ;F02F: A7 82
        CMPX    #M2019                   ;F031: 8C 20 19
        BGT     ZF02F                    ;F034: 2E F9
        COMA                             ;F036: 43
ZF037   STA     ,-X                      ;F037: A7 82
        CMPX    #M2000                   ;F039: 8C 20 00
        BGT     ZF037                    ;F03C: 2E F9
        STB     M001A                    ;F03E: D7 1A
        STB     M001D                    ;F040: D7 1D
        STB     M001F                    ;F042: D7 1F
        CLR     M0080                    ;F044: 0F 80
        LDX     #MA000                   ;F046: 8E A0 00
        LDB     #$55                     ;F049: C6 55
        ADDB    ,X+                      ;F04B: EB 80
        ADDB    ,X+                      ;F04D: EB 80
        ADDB    ,X+                      ;F04F: EB 80
        CMPB    ,X                       ;F051: E1 84
        BNE     ZF057                    ;F053: 26 02
        STA     M0080                    ;F055: 97 80
ZF057   LDU     #PIAPORTA                   ;F057: CE A7 C0
        LSRA                             ;F05A: 44
        STA     $01,U                    ;F05B: A7 41
        LDA     #$5F                     ;F05D: 86 5F
        STA     ,U                       ;F05F: A7 C4
        LDX     #$3E3F                   ;F061: 8E 3E 3F
        STX     $02,U      ; Set PIA control lines
        LDX     #$0404                   ;F066: 8E 04 04
        STX     $0E,U                    ;F069: AF 4E
        JSR     ZF8A8                    ;F06B: BD F8 A8
        LDD     #M1F40                   ;F06E: CC 1F 40
        STD     M0025                    ;F071: DD 25
        LDA     #$18                     ;F073: 86 18
        STA     M0020                    ;F075: 97 20
        JMP     [ZEFFE]                  ;F077: 6E 9F EF FE

* Routine called from IRQ handler
ZF07B   LDA     ,S                       ;F07B: A6 E4
        ANDA    #$F0                     ;F07D: 84 F0
        STA     ,S                       ;F07F: A7 E4
        TFR     A,CC                     ;F081: 1F 8A
        LDA     #$20                     ;F083: 86 20
        TFR     A,DP                     ;F085: 1F 8B
        LDB     [$0A,S]                  ;F087: E6 F8 0A
        ANDB    #$7F                     ;F08A: C4 7F
        LDX     M006A                    ;F08C: 9E 6A
        LDD     B,X                      ;F08E: EC 85
        LDX     #MF09D                   ;F090: 8E F0 9D
        PSHS    X,D                      ;F093: 34 16
        LDU     #PIAPORTA                   ;F095: CE A7 C0
        LDD     $05,S                    ;F098: EC 65
        LDX     $08,S                    ;F09A: AE 68
        RTS                              ;F09C: 39

MF09D   TFR     CC,A                     ;F09D: 1F A8
        ANDA    #$8F                     ;F09F: 84 8F
        ORA     ,S                       ;F0A1: AA E4
        STA     ,S                       ;F0A3: A7 E4
        LDX     $0A,S                    ;F0A5: AE 6A
        LDB     ,X+                      ;F0A7: E6 80
        BMI     ZF0AE                    ;F0A9: 2B 03
        STX     $0A,S                    ;F0AB: AF 6A

* NMI handler
hdlr_NMI RTI                              ;F0AD: 3B

ZF0AE   PULS    U,Y,X,DP,D,CC            ;F0AE: 35 7F
        LEAS    $02,S                    ;F0B0: 32 62
MF0B2   RTS                              ;F0B2: 39

MF0B3   LDD     M9EFC                    ;F0B3: FC 9E FC
        LDX     M00F2                    ;F0B6: 9E F2
        SBCB    #$F0                     ;F0B8: C2 F0
        ADDD    #hdlr_NMI                ;F0BA: C3 F0 AD
        SUBB    MADF0                    ;F0BD: F0 AD F0
        JSR     MF0B2                      ;F0C0: AD F0
        FCB     $7B                      ;F0C2: 7B
        SUBB    M03F7                    ;F0C3: F0 03 F7
        COM     ZFB2C                    ;F0C6: 73 FB 2C
        ADDB    M23FA                    ;F0C9: FB 23 FA
        BITB    #$F1                     ;F0CC: C5 F1
        STD     MF1D2                    ;F0CE: FD F1 D2
        ANDB    M87F3                    ;F0D1: F4 87 F3
        SUBB    ZF3A2                    ;F0D4: F0 F3 A2
        ADDD    MD5F5                    ;F0D7: F3 D5 F5
        LEAY    [B,S]                    ;F0DA: 31 F5
        ASLA                             ;F0DC: 48
        SBCB    MFCF5                    ;F0DD: F2 FC F5
        FCB     $0B                      ;F0E0: 0B
        LDB     M9BF0                    ;F0E1: F6 9B F0
        STU     MF18B                    ;F0E4: FF F1 8B
        STB     M13A0                    ;F0E7: F7 13 A0
        LSR     M00A0                    ;F0EA: 04 A0
        ASR     M00A0                    ;F0EC: 07 A0
        DEC     M00A0                    ;F0EE: 0A A0
        ANDCC   #$A0                     ;F0F0: 1C A0
        DAA                              ;F0F2: 19
        SUBA    -$0A,X                   ;F0F3: A0 16
        SUBA    $02,Y                    ;F0F5: A0 22
        SUBA    $0D,X                    ;F0F7: A0 0D
        SUBA    -$01,X                   ;F0F9: A0 1F
        SUBA    -$10,X                   ;F0FB: A0 10
        SUBA    -$0D,X                   ;F0FD: A0 13
        ORCC    #$D0                     ;F0FF: 1A D0
        TST     $03,S                    ;F101: 6D 63
        BEQ     ZF142                    ;F103: 27 3D
ZF105   LDA     ,U                       ;F105: A6 C4
        LDB     #$FF                     ;F107: C6 FF
        STD     M0044                    ;F109: DD 44
ZF10B   BSR     ZF168                    ;F10B: 8D 5B
        TSTA                             ;F10D: 4D
        BNE     ZF10B                    ;F10E: 26 FB
ZF110   BSR     ZF168                    ;F110: 8D 56
        LDA     M0045                    ;F112: 96 45
        CMPA    #$01                     ;F114: 81 01
        BNE     ZF110                    ;F116: 26 F8
ZF118   BSR     ZF181                    ;F118: 8D 67
        CMPA    #$01                     ;F11A: 81 01
        BEQ     ZF118                    ;F11C: 27 FA
        CMPA    #$3C                     ;F11E: 81 3C
        BNE     ZF105                    ;F120: 26 E3
        BSR     ZF181                    ;F122: 8D 5D
        CMPA    #$5A                     ;F124: 81 5A
        BNE     ZF105                    ;F126: 26 DD
        BSR     ZF181                    ;F128: 8D 57
        STA     $04,S                    ;F12A: A7 64
        BSR     ZF181                    ;F12C: 8D 53
        STA     ,Y+                      ;F12E: A7 A0
        STA     M0041                    ;F130: 97 41
        CLR     $03,S                    ;F132: 6F 63
ZF134   DEC     M0041                    ;F134: 0A 41
        BEQ     ZF167                    ;F136: 27 2F
        BSR     ZF181                    ;F138: 8D 47
        STA     ,Y+                      ;F13A: A7 A0
        ADDA    $03,S                    ;F13C: AB 63
        STA     $03,S                    ;F13E: A7 63
        BRA     ZF134                    ;F140: 20 F2
ZF142   LDD     #M0110                   ;F142: CC 01 10
        STD     M0040                    ;F145: DD 40
ZF147   LDA     M0040                    ;F147: 96 40
        BSR     ZF1AF                    ;F149: 8D 64
        DEC     M0041                    ;F14B: 0A 41
        BNE     ZF147                    ;F14D: 26 F8
        LDA     #$3C                     ;F14F: 86 3C
        BSR     ZF1AF                    ;F151: 8D 5C
        LDA     #$5A                     ;F153: 86 5A
        BSR     ZF1AF                    ;F155: 8D 58
        LDA     $04,S                    ;F157: A6 64
        BSR     ZF1AF                    ;F159: 8D 54
        LDA     ,Y                       ;F15B: A6 A4
        STA     M0041                    ;F15D: 97 41
ZF15F   LDA     ,Y+                      ;F15F: A6 A0
        BSR     ZF1AF                    ;F161: 8D 4C
        DEC     M0041                    ;F163: 0A 41
        BNE     ZF15F                    ;F165: 26 F8
ZF167   RTS                              ;F167: 39

ZF168   LDA     ,U                       ;F168: A6 C4
        EORA    M0044                    ;F16A: 98 44
        BPL     ZF168                    ;F16C: 2A FA
        LDX     #$0041                   ;F16E: 8E 00 41
        BSR     WAITLOOP                    ;F171: 8D 2F
        LDA     ,U                       ;F173: A6 C4
        EORA    M0044                    ;F175: 98 44
        BPL     ZF17D                    ;F177: 2A 04
        COM     M0044                    ;F179: 03 44
        CLRA                             ;F17B: 4F
        BRN     ZF1C1                    ;F17C: 21 43
        ROL     M0045                    ;F17E: 09 45
        RTS                              ;F180: 39

ZF181   LDB     #$08                     ;F181: C6 08
ZF183   BSR     ZF168                    ;F183: 8D E3
        DECB                             ;F185: 5A
        BNE     ZF183                    ;F186: 26 FB
        LDA     M0045                    ;F188: 96 45
        RTS                              ;F18A: 39

MF18B   LDB     $02,U                    ;F18B: E6 42
        LSRA                             ;F18D: 44
        BCC     ZF1A8                    ;F18E: 24 18
        TST     ,U                       ;F190: 6D C4
        BMI     ZF196                    ;F192: 2B 02
        COMA                             ;F194: 43
        RTS                              ;F195: 39

ZF196   ANDB    #$F7                     ;F196: C4 F7
        STB     $02,U                    ;F198: E7 42
        LSRA                             ;F19A: 44
        BCC     ZF1A7                    ;F19B: 24 0A
        BSR     ZF19F                    ;F19D: 8D 00
ZF19F   LDX     #M963D                   ;F19F: 8E 96 3D

* Timing loop. Count down X
WAITLOOP   LEAX    -$01,X                   ;F1A2: 30 1F
        BNE     WAITLOOP                    ;F1A4: 26 FC
        CLRA                             ;F1A6: 4F
ZF1A7   RTS                              ;F1A7: 39

ZF1A8   ORB     #$08                     ;F1A8: CA 08
        BSR     ZF19F                    ;F1AA: 8D F3
        STB     $02,U                    ;F1AC: E7 42
        RTS                              ;F1AE: 39

ZF1AF   STA     M0045                    ;F1AF: 97 45
        LDB     #$08                     ;F1B1: C6 08
ZF1B3   BSR     ZF1CB                    ;F1B3: 8D 16
        LDX     #$002D                   ;F1B5: 8E 00 2D
        BSR     WAITLOOP                    ;F1B8: 8D E8
        LDX     #$0032                   ;F1BA: 8E 00 32
        ASL     M0045                    ;F1BD: 08 45
        BCC     ZF1C5                    ;F1BF: 24 04
ZF1C1   BSR     ZF1CB                    ;F1C1: 8D 08
        LEAX    -$03,X                   ;F1C3: 30 1D
ZF1C5   BSR     WAITLOOP                    ;F1C5: 8D DB
        DECB                             ;F1C7: 5A
        BNE     ZF1B3                    ;F1C8: 26 E9
        RTS                              ;F1CA: 39

ZF1CB   LDA     #$40                     ;F1CB: 86 40
        EORA    ,U                       ;F1CD: A8 C4
        STA     ,U                       ;F1CF: A7 C4
        RTS                              ;F1D1: 39

MF1D2   LDD     M0027                    ;F1D2: DC 27
        STD     M0044                    ;F1D4: DD 44
        LDB     #$72                     ;F1D6: C6 72
ZF1D8   STB     $01,U                    ;F1D8: E7 41
        LDA     $01,U                    ;F1DA: A6 41
        BMI     ZF1F0                    ;F1DC: 2B 12
        LDA     #$01                     ;F1DE: 86 01
        CMPB    #$72                     ;F1E0: C1 72
        BEQ     ZF1EE                    ;F1E2: 27 0A
        ASLA                             ;F1E4: 48
        CMPB    #$6A                     ;F1E5: C1 6A
        BEQ     ZF1EE                    ;F1E7: 27 05
        ASLA                             ;F1E9: 48
        CMPB    #$70                     ;F1EA: C1 70
        BNE     ZF1F6                    ;F1EC: 26 08
ZF1EE   STA     M0044                    ;F1EE: 97 44
ZF1F0   INC     M0045                    ;F1F0: 0C 45
        SUBB    #$02                     ;F1F2: C0 02
        BPL     ZF1D8                    ;F1F4: 2A E2
ZF1F6   LDD     M0044                    ;F1F6: DC 44
        STD     $03,S                    ;F1F8: ED 63
        CMPB    #$3A                     ;F1FA: C1 3A
        RTS                              ;F1FC: 39

        TST     M005D                    ;F1FD: 0D 5D
        BNE     ZF239                    ;F1FF: 26 38
        SWI                              ;F201: 3F
        INC     M0034                    ;F202: 0C 34
        ROR     M008E                    ;F204: 06 8E
        FCB     $02                      ;F206: 02
        FCB     $71                      ;F207: 71
ZF208   LEAX    -$01,X                   ;F208: 30 1F
        BNE     ZF208                    ;F20A: 26 FC
        SWI                              ;F20C: 3F
        INC     M0010                    ;F20D: 0C 10
        SUBD    ,S++                     ;F20F: A3 E1
        BNE     ZF203                    ;F211: 26 F0
        CMPB    #$3A                     ;F213: C1 3A
        BEQ     ZF23E                    ;F215: 27 27
        CMPB    M0037                    ;F217: D1 37
        BNE     ZF22B                    ;F219: 26 10
        LDA     M0038                    ;F21B: 96 38
        CMPA    M0076                    ;F21D: 91 76
        BCS     ZF240                    ;F21F: 25 1F
        LDA     #$02                     ;F221: 86 02
        BITA    M0019                    ;F223: 95 19
        BNE     ZF240                    ;F225: 26 19
        JSR     ZF89D                    ;F227: BD F8 9D
        CMPX    #M0F38                   ;F22A: 8C 0F 38
        STB     M0037                    ;F22D: D7 37
        SWI                              ;F22F: 3F
        ASL     M0004                    ;F230: 08 04
        LSRA                             ;F232: 44
        BCC     ZF243                    ;F233: 24 0E
        ORB     #$80                     ;F235: CA 80
        BRA     ZF297                    ;F237: 20 5E
ZF239   LDB     M005D                    ;F239: D6 5D
        CLRA                             ;F23B: 4F
        BRA     ZF295                    ;F23C: 20 57
ZF23E   CLR     M0037                    ;F23E: 0F 37
ZF240   CLRB                             ;F240: 5F
        BRA     ZF299                    ;F241: 20 56
ZF243   LDX     M006D                    ;F243: 9E 6D
        LDB     B,X                      ;F245: E6 85
        LSR     M0044                    ;F247: 04 44
        BCC     ZF24F                    ;F249: 24 04
        ANDB    #$BF                     ;F24B: C4 BF
        BRA     ZF29C                    ;F24D: 20 4D
ZF24F   LSR     M0044                    ;F24F: 04 44
        BCC     ZF27A                    ;F251: 24 27
        CMPB    #$20                     ;F253: C1 20
        BCS     ZF297                    ;F255: 25 40
        BNE     ZF262                    ;F257: 26 09
        LDA     #$80                     ;F259: 86 80
        EORA    M0019                    ;F25B: 98 19
        STA     M0019                    ;F25D: 97 19
        CLRB                             ;F25F: 5F
        BRA     ZF297                    ;F260: 20 35

ZF262   CMPB    #$2F                     ;F262: C1 2F
        BGT     ZF26A                    ;F264: 2E 04
        ORB     #$10                     ;F266: CA 10
        BRA     ZF297                    ;F268: 20 2D
ZF26A   CMPB    #$39                     ;F26A: C1 39
        BGT     ZF272                    ;F26C: 2E 04
        ANDB    #$EF                     ;F26E: C4 EF
        BRA     ZF284                    ;F270: 20 12
ZF272   CMPB    #$40                     ;F272: C1 40
        BNE     ZF297                    ;F274: 26 21
        LDB     #$5E                     ;F276: C6 5E
        BRA     ZF284                    ;F278: 20 0A
ZF27A   CMPB    #$41                     ;F27A: C1 41
        BCS     ZF284                    ;F27C: 25 06
        LDA     M0019                    ;F27E: 96 19
        BPL     ZF297                    ;F280: 2A 15
        ADDB    #$20                     ;F282: CB 20
ZF284   TST     M005C                    ;F284: 0D 5C
        BEQ     ZF29C                    ;F286: 27 14
        LDA     #$0B                     ;F288: 86 0B
ZF28A   DECA                             ;F28A: 4A
        BEQ     ZF297                    ;F28B: 27 0A
        LEAX    -$03,X                   ;F28D: 30 1D
        CMPB    ,X                       ;F28F: E1 84
        BNE     ZF28A                    ;F291: 26 F7
        LDD     $01,X                    ;F293: EC 01
ZF295   STA     M005D                    ;F295: 97 5D
ZF297   CLR     M005C                    ;F297: 0F 5C
ZF299   STB     $04,S                    ;F299: E7 64
        RTS                              ;F29B: 39

ZF29C   CMPB    #$16                     ;F29C: C1 16
        BNE     ZF297                    ;F29E: 26 F7
        INC     M005C                    ;F2A0: 0C 5C
        BRA     ZF299                    ;F2A2: 20 F5
        LEAX    $01,S                    ;F2A4: 30 61
        FCB     $41                      ;F2A6: 41
        PSHU    S,Y,B,CC                 ;F2A7: 36 65
        FCB     $42                      ;F2A9: 42
        PULU    S,Y,B,CC                 ;F2AA: 37 65
        FCB     $41                      ;F2AC: 41
        FCB     $38                      ;F2AD: 38
        FCB     $75                      ;F2AE: 75
        FCB     $41                      ;F2AF: 41
        RTS                              ;F2B0: 39

        COM     $0B,U                    ;F2B1: 63 4B
        COM     $00,X                    ;F2B3: 63 00
        FCB     $4B                      ;F2B5: 4B
        BRA     ZF2B8                    ;F2B6: 20 00
ZF2B8   FCB     $41                      ;F2B8: 41
        BEQ     ZF2BB                    ;F2B9: 27 00
ZF2BB   FCB     $42                      ;F2BB: 42
        FCB     $5E                      ;F2BC: 5E
        NEG     M0043                    ;F2BD: 00 43
        BHI     ZF2C1                    ;F2BF: 22 00
ZF2C1   ASLA                             ;F2C1: 48
        NEG     Z0000                    ;F2C2: 00 00
        FCB     $02                      ;F2C4: 02
        LBRA    ZF2D5                    ;F2C5: 16 00 0D
        INC     M0043                    ;F2C8: 0C 43
        FCB     $0B                      ;F2CA: 0B
        ASRB                             ;F2CB: 57
        LEAY    $0B,Y                    ;F2CC: 31 2B
        FCB     $41                      ;F2CE: 41
        BPL     ZF322                    ;F2CF: 2A 51
        RORB                             ;F2D1: 56
        ASL     M0058                    ;F2D2: 08 58
        LEAS    $0D,Y                    ;F2D4: 32 2D
        DECB                             ;F2D6: 5A
        BLE     ZF32C                    ;F2D7: 2F 53
        FCB     $42                      ;F2D9: 42
        DEC     M0020                    ;F2DA: 0A 20
        LEAU    -$10,Y                   ;F2DC: 33 30
        FCB     $45                      ;F2DE: 45
        NEGB                             ;F2DF: 50
        LSRA                             ;F2E0: 44
        TSTA                             ;F2E1: 4D
        ROL     M0040                    ;F2E2: 09 40
        PSHS    Y,X,DP,CC                ;F2E4: 34 39
        FCB     $52                      ;F2E6: 52
        CLRA                             ;F2E7: 4F
        RORA                             ;F2E8: 46
        INCA                             ;F2E9: 4C
        fcb   $1E
        fcb   $2E
        PULS    Y,X,DP                   ;F2EC: 35 38
        LSRB                             ;F2EE: 54
        ROLA                             ;F2EF: 49
        ASRA                             ;F2F0: 47
        FCB     $4B                      ;F2F1: 4B
        ANDCC   #$2C                     ;F2F2: 1C 2C
        PSHU    Y,X,D,CC                 ;F2F4: 36 37
        ROLB                             ;F2F6: 59
        FCB     $55                      ;F2F7: 55
        ASLA                             ;F2F8: 48
        DECA                             ;F2F9: 4A
        SEX                              ;F2FA: 1D
        FCB     $4E                      ;F2FB: 4E
        LDB     M0019                    ;F2FC: D6 19
        PSHS    B                        ;F2FE: 34 04
        LDB     #$14                     ;F300: C6 14
        SWI                              ;F302: 3F
        FCB     $02                      ;F303: 02
        TST     M005D                    ;F304: 0D 5D
        BGT     ZF365                    ;F306: 2E 5D
        BMI     ZF36D                    ;F308: 2B 63
        LDB     #$1F                     ;F30A: C6 1F
        STB     $05,S                    ;F30C: E7 65
        BSR     ZF37C                    ;F30E: 8D 6C
        ADDB    $08,S                    ;F310: EB 68
        TFR     D,U                      ;F312: 1F 03
        LDX     M0073                    ;F314: 9E 73
        LDD     #M6108                   ;F316: CC 61 08
        BSR     ZF385                    ;F319: 8D 6A
        BCS     ZF358                    ;F31B: 25 3B
        LEAX    $06,X                    ;F31D: 30 06
        LEAU    $FF10,U                  ;F31F: 33 C9 FF 10
        LSR     $05,S                    ;F323: 64 65
        LDD     #M0402                   ;F325: CC 04 02
        BSR     ZF385                    ;F328: 8D 5B
        BCC     ZF36F                    ;F32A: 24 43
ZF32C   LDB     $05,S                    ;F32C: E6 65
        CMPB    #$44                     ;F32E: C1 44
        BNE     ZF334                    ;F330: 26 02
        LDB     #$48                     ;F332: C6 48
ZF334   STB     M005D                    ;F334: D7 5D
        LDB     #$60                     ;F336: C6 60
        STB     $05,S                    ;F338: E7 65
        LDX     M0073                    ;F33A: 9E 73
        LEAX    $0208,X                  ;F33C: 30 89 02 08
        LEAU    $00F0,U                  ;F340: 33 C9 00 F0
        LDD     #M1B06                   ;F344: CC 1B 06
        BSR     ZF385                    ;F347: 8D 3C
        BCS     ZF34E                    ;F349: 25 03
        LDB     #$20                     ;F34B: C6 20
        CMPX    #ME665                   ;F34D: 8C E6 65
        STB     M005C                    ;F350: D7 5C
        LDB     #$16                     ;F352: C6 16
        STB     $05,S                    ;F354: E7 65
        BRA     ZF377                    ;F356: 20 1F
ZF358   TST     $05,S                    ;F358: 6D 65
        BPL     ZF371                    ;F35A: 2A 15
        LDB     #$16                     ;F35C: C6 16
        STB     $05,S                    ;F35E: E7 65
        LDD     #M4B63                   ;F360: CC 4B 63
        BRA     ZF373                    ;F363: 20 0E
ZF365   LDB     M005D                    ;F365: D6 5D
        STB     $05,S                    ;F367: E7 65
        LDA     #$80                     ;F369: 86 80
        BRA     ZF375                    ;F36B: 20 08
ZF36D   LDA     M005C                    ;F36D: 96 5C
ZF36F   STA     $05,S                    ;F36F: A7 65
ZF371   LDD     M0027                    ;F371: DC 27
ZF373   STB     M005C                    ;F373: D7 5C
ZF375   STA     M005D                    ;F375: 97 5D
ZF377   PULS    A                        ;F377: 35 02
        STA     M0019                    ;F379: 97 19
        RTS                              ;F37B: 39

ZF37C   LDB     #$A0                     ;F37C: C6 A0
        MUL                              ;F37E: 3D
        ASLB                             ;F37F: 58
        ROLA                             ;F380: 49
        ADDD    #M0117                   ;F381: C3 01 17
        RTS                              ;F384: 39

ZF385   PSHS    U,X,D                    ;F385: 34 56
ZF387   LDA     ,X+                      ;F387: A6 80
        CMPA    ,U                       ;F389: A1 C4
        BNE     ZF395                    ;F38B: 26 08
        LEAU    -$28,U                   ;F38D: 33 C8 D8
        DECB                             ;F390: 5A
        BNE     ZF387                    ;F391: 26 F4
        COMA                             ;F393: 43
        BRN     ZF3E5                    ;F394: 21 4F
        PULS    U,X,D                    ;F396: 35 56
        INC     $07,S                    ;F398: 6C 67
        LEAX    $08,X                    ;F39A: 30 08
        BCS     ZF3A1                    ;F39C: 25 03
        DECA                             ;F39E: 4A
        BNE     ZF385                    ;F39F: 26 E4
ZF3A1   RTS                              ;F3A1: 39

ZF3A2   BSR     ZF3C5                    ;F3A2: 8D 21
        LDA     M002C                    ;F3A4: 96 2C
        PSHS    A                        ;F3A6: 34 02
        LDA     #$FF                     ;F3A8: 86 FF
        STA     M002C                    ;F3AA: 97 2C
        LDB     #$1F                     ;F3AC: C6 1F
        SWI                              ;F3AE: 3F
        FCB     $02                      ;F3AF: 02
        TFR     Y,D                      ;F3B0: 1F 20
        ADDB    #$40                     ;F3B2: CB 40
        SWI                              ;F3B4: 3F
        FCB     $02                      ;F3B5: 02
        TFR     X,D                      ;F3B6: 1F 10
        ADDB    #$40                     ;F3B8: CB 40
        SWI                              ;F3BA: 3F
        FCB     $02                      ;F3BB: 02
        LDB     M0036                    ;F3BC: D6 36
        SWI                              ;F3BE: 3F
        FCB     $02                      ;F3BF: 02
        PULS    A                        ;F3C0: 35 02
        STA     M002C                    ;F3C2: 97 2C
        RTS                              ;F3C4: 39

ZF3C5   STX     M0032                    ;F3C5: 9F 32
        STY     M0034                    ;F3C7: 10 9F 34
        RTS                              ;F3CA: 39

ZF3CB   LDB     M0033                    ;F3CB: D6 33
ZF3CD   LDU     #MF503                   ;F3CD: CE F5 03
ZF3D0   ANDB    #$07                     ;F3D0: C4 07
        LDA     B,U                      ;F3D2: A6 C5
        RTS                              ;F3D4: 39

        BSR     ZF432                    ;F3D5: 8D 5B
        JSR     ZFB2C                    ;F3D7: BD FB 2C
        LDB     $07,S                    ;F3DA: E6 67
        BSR     ZF3CD                    ;F3DC: 8D EF
        LDB     ,X                       ;F3DE: E6 84
        INC     PIAPORTA                    ;F3E0: 7C A7 C0
        ANDA    ,X                       ;F3E3: A4 84
ZF3E5   BNE     ZF3EB                    ;F3E5: 26 04
        ANDB    #$0F                     ;F3E7: C4 0F
        COMB                             ;F3E9: 53
        CMPX    #M8D40                   ;F3EA: 8C 8D 40
        STB     $04,S                    ;F3ED: E7 64
        RTS                              ;F3EF: 39

ZF3F0   TST     M0036                    ;F3F0: 0D 36
        BNE     ZF3A2                    ;F3F2: 26 AE
        BSR     ZF3C5                    ;F3F4: 8D CF
        BSR     ZF432                    ;F3F6: 8D 3A
        BSR     ZF3CB                    ;F3F8: 8D D1
ZF3FA   JSR     ZFB23                    ;F3FA: BD FB 23
        LDB     M0029                    ;F3FD: D6 29
        BMI     ZF40C                    ;F3FF: 2B 0B
        BSR     ZF41E                    ;F401: 8D 1B
        BNE     ZF41D                    ;F403: 26 18
        JSR     ZFB3A                    ;F405: BD FB 3A
        LDA     #$0F                     ;F408: 86 0F
        BRA     ZF414                    ;F40A: 20 08
ZF40C   COMA                             ;F40C: 43
        BSR     ZF421                    ;F40D: 8D 12
        BNE     ZF41D                    ;F40F: 26 0C
        COMB                             ;F411: 53
        LDA     #$F0                     ;F412: 86 F0
ZF414   JSR     ZFB2C                    ;F414: BD FB 2C
        BSR     ZF421                    ;F417: 8D 08
        ADDB    ,X                       ;F419: EB 84
        STB     ,X                       ;F41B: E7 84
ZF41D   RTS                              ;F41D: 39

ZF41E   ORA     ,X                       ;F41E: AA 84
        CMPX    #MA484                   ;F420: 8C A4 84
        STA     ,X                       ;F423: A7 84
        LDA     M0019                    ;F425: 96 19
        BITA    #$10                     ;F427: 85 10
        RTS                              ;F429: 39

ZF42A   LSRA                             ;F42A: 44
        RORB                             ;F42B: 56
        CMPX    #M5454                   ;F42C: 8C 54 54
        LSRB                             ;F42F: 54
        LSRB                             ;F430: 54
        RTS                              ;F431: 39

ZF432   TFR     Y,D                      ;F432: 1F 20
        LDA     #$28                     ;F434: 86 28
        MUL                              ;F436: 3D
        EXG     D,X                      ;F437: 1E 01
        BSR     ZF42A                    ;F439: 8D EF
        LEAX    D,X                      ;F43B: 30 8B
        RTS                              ;F43D: 39

ZF43E   CMPX    M0032                    ;F43E: 9C 32
        BCC     ZF448                    ;F440: 24 06
        LDU     M0032                    ;F442: DE 32
        EXG     X,U                      ;F444: 1E 13
        STU     M0032                    ;F446: DF 32
ZF448   PSHS    X                        ;F448: 34 10
        LDD     M0032                    ;F44A: DC 32
        BSR     ZF42A                    ;F44C: 8D DC
        PSHS    B                        ;F44E: 34 04
        LDX     M0032                    ;F450: 9E 32
        BSR     ZF432                    ;F452: 8D DE
        LDD     $01,S                    ;F454: EC 61
        BSR     ZF42A                    ;F456: 8D D2
        SUBB    ,S+                      ;F458: E0 E0
        BEQ     ZF46F                    ;F45A: 27 13
        STB     M0045                    ;F45C: D7 45
        JSR     ZF3CB                    ;F45E: BD F3 CB
        ASLA                             ;F461: 48
        DECA                             ;F462: 4A
ZF463   BSR     ZF3FA                    ;F463: 8D 95
        LEAX    $01,X                    ;F465: 30 01
        LDA     #$FF                     ;F467: 86 FF
        DEC     M0045                    ;F469: 0A 45
        BGT     ZF463                    ;F46B: 2E F6
        BRA     ZF474                    ;F46D: 20 05
ZF46F   JSR     ZF3CB                    ;F46F: BD F3 CB
        ASLA                             ;F472: 48
        DECA                             ;F473: 4A
ZF474   STA     M0045                    ;F474: 97 45
        LDD     ,S                       ;F476: EC E4
        JSR     ZF3D0                    ;F478: BD F3 D0
        NEGA                             ;F47B: 40
        ANDA    M0045                    ;F47C: 94 45
        JSR     ZF3FA                    ;F47E: BD F3 FA
        LDX     $0A,S                    ;F481: AE 6A
        STX     M0032                    ;F483: 9F 32
        PULS    PC,X,D                   ;F485: 35 96
        LDD     #M0101                   ;F487: CC 01 01
        PSHS    D                        ;F48A: 34 06
        CLRA                             ;F48C: 4F
        LDB     $0B,S                    ;F48D: E6 6B
        SUBB    M0035                    ;F48F: D0 35
        BHI     ZF49C                    ;F491: 22 09
        BNE     ZF499                    ;F493: 26 04
        TST     M0036                    ;F495: 0D 36
        BEQ     ZF43E                    ;F497: 27 A5
ZF499   NEG     $01,S                    ;F499: 60 61
        NEGB                             ;F49B: 50
ZF49C   STD     M0046                    ;F49C: DD 46
        LDD     $08,S                    ;F49E: EC 68
        SUBD    M0032                    ;F4A0: 93 32
        BCC     ZF4A8                    ;F4A2: 24 04
        NEG     ,S                       ;F4A4: 60 E4
        BSR     ZF4FC                    ;F4A6: 8D 54
ZF4A8   STD     M0040                    ;F4A8: DD 40
        LDX     M0032                    ;F4AA: 9E 32
        LDY     M0034                    ;F4AC: 10 9E 34
        CMPD    M0046                    ;F4AF: 10 93 46
        BHI     ZF4CF                    ;F4B2: 22 1B
        LDD     M0046                    ;F4B4: DC 46
        BEQ     ZF4E3                    ;F4B6: 27 2B
        BSR     ZF4FC                    ;F4B8: 8D 42
        ASRA                             ;F4BA: 47
        RORB                             ;F4BB: 56
ZF4BC   BSR     ZF4F4                    ;F4BC: 8D 36
        ADDD    M0040                    ;F4BE: D3 40
        BMI     ZF4C6                    ;F4C0: 2B 04
        BSR     ZF4EC                    ;F4C2: 8D 28
        SUBD    M0046                    ;F4C4: 93 46
ZF4C6   BSR     ZF4E5                    ;F4C6: 8D 1D
        CMPY    $0A,S                    ;F4C8: 10 AC 6A
        BNE     ZF4BC                    ;F4CB: 26 EF
        PULS    PC,D                     ;F4CD: 35 86
ZF4CF   BSR     ZF4FC                    ;F4CF: 8D 2B
        ASRA                             ;F4D1: 47
        RORB                             ;F4D2: 56
ZF4D3   BSR     ZF4EC                    ;F4D3: 8D 17
        ADDD    M0046                    ;F4D5: D3 46
        BMI     ZF4DD                    ;F4D7: 2B 04
        BSR     ZF4F4                    ;F4D9: 8D 19
        SUBD    M0040                    ;F4DB: 93 40
ZF4DD   BSR     ZF4E5                    ;F4DD: 8D 06
        CMPX    $08,S                    ;F4DF: AC 68
        BNE     ZF4D3                    ;F4E1: 26 F0
ZF4E3   PULS    PC,D                     ;F4E3: 35 86
ZF4E5   PSHS    U,Y,X,D                  ;F4E5: 34 76
        JSR     ZF3F0                    ;F4E7: BD F3 F0
        PULS    PC,U,Y,X,D               ;F4EA: 35 F6
ZF4EC   PSHS    A                        ;F4EC: 34 02
        LDA     $03,S                    ;F4EE: A6 63
        LEAX    A,X                      ;F4F0: 30 86
        PULS    PC,A                     ;F4F2: 35 82
ZF4F4   PSHS    A                        ;F4F4: 34 02
        LDA     $04,S                    ;F4F6: A6 64
        LEAY    A,Y                      ;F4F8: 31 A6
        PULS    PC,A                     ;F4FA: 35 82
ZF4FC   COMA                             ;F4FC: 43
        COMB                             ;F4FD: 53
        ADDD    #M0001                   ;F4FE: C3 00 01
        RTS                              ;F501: 39

        NEG     M0080                    ;F502: 00 80
        NEGA                             ;F504: 40
        BRA     ZF517                    ;F505: 20 10
        ASL     M0004                    ;F507: 08 04
        FCB     $02                      ;F509: 02
        FCB     $01                      ;F50A: 01
        LDB     $0C,U                    ;F50B: E6 4C
        TSTA                             ;F50D: 4D
        BEQ     ZF516                    ;F50E: 27 06
        LDA     #$40                     ;F510: 86 40
        LSRB                             ;F512: 54
        LSRB                             ;F513: 54
        LSRB                             ;F514: 54
        LSRB                             ;F515: 54
ZF516   ANDB    #$0F                     ;F516: C4 0F
        LDX     #MF521                   ;F518: 8E F5 21
        LDB     B,X                      ;F51B: E6 85
        STB     $04,S                    ;F51D: E7 64
        ADDA    #$40                     ;F51F: 8B 40
MF521   ANDA    $0D,U                    ;F521: A4 4D
        CMPA    #$01                     ;F523: 81 01
        RTS                              ;F525: 39

        LSR     M0002                    ;F526: 04 02
        COM     Z0000                    ;F528: 03 00
        ROR     M0008                    ;F52A: 06 08
        ASR     Z0000                    ;F52C: 07 00
        FCB     $05                      ;F52E: 05
        FCB     $01                      ;F52F: 01
        NEG     M00A6                    ;F530: 00 A6
        ANDB    #$84                     ;F532: C4 84
        BRA     ZF56A                    ;F534: 20 34
        FCB     $02                      ;F536: 02
        LDX     #$04E2                   ;F537: 8E 04 E2
        JSR     WAITLOOP                    ;F53A: BD F1 A2
        LDA     ,U                       ;F53D: A6 C4
        ANDA    #$20                     ;F53F: 84 20
        CMPA    ,S+                      ;F541: A1 E0
        BNE     ZF531                    ;F543: 26 EC
        ADDA    #$FF                     ;F545: 8B FF
        RTS                              ;F547: 39

        ORCC    #$50                     ;F548: 1A 50  Inhibit FIRQ and IRQ
        LDX     M0067                    ;F54A: 9E 67
        PSHS    X,DP                     ;F54C: 34 18  Keep the previous vector on stack
        LDX     #LPFIRQ                   ;F54E: 8E F6 46
        STX     M0067                    ;F551: 9F 67   Set a new address in FIRQ vector
        LDA     #$A7                     ;F553: 86 A7
        TFR     A,DP                     ;F555: 1F 8B
        LDY     #LPBUFF                   ;F557: 10 8E 20 CD
        LDX     #$0370                   ;F55B: 8E 03 70
        LDA     #$FF                     ;F55E: 86 FF

ZF560   LDB     M00E7                    ;F560: D6 E7  Wait for bit7 in A7E7 to turn on
        BPL     ZF560                    ;F562: 2A FC

ZF564   LDB     M00E7                    ;F564: D6 E7  Wait for bit7 in A7E7 to turn off
        BMI     ZF564                    ;F566: 2B FC
        STA     $02,U                    ;F568: A7 42  Activate FIRQ in PIA
ZF56A   JSR     WAITLOOP                 ;F56A: BD F1 A2
        TST     ,U                       ;F56D: 6D C4    Read FIRQ flag in PIA
        LDX     #$0649                   ;F56F: 8E 06 49
        LDA     #$01                     ;F572: 86 01
        STA     M00E4                    ;F574: 97 E4  Store 1 in A7E4
        ANDCC   #$BF                     ;F576: 1C BF    Turn off FIRQ inhibit in CPU
        JSR     WAITLOOP                 ;F578: BD F1 A2  Wait loop
        ORCC    #$40                     ;F57B: 1A 40    Turn on FIRQ inhibit in CPU
        ANDCC   #$EF                     ;F57D: 1C EF    Allow plain IRQs in CPU
        LDA     #$FE                     ;F57F: 86 FE
        STA     $02,U                    ;F581: A7 42   Inhibit FIRQ in PIA
        CLR     M00E4                    ;F583: 0F E4   Clear A7E4
        PULS    DP                       ;F585: 35 08
        CMPY    #M20D3                   ;F587: 10 8C 20 D3   Has Y changed?
        BLS     LPERR                    ;F58B: 23 69   No... go to error

* Calculate the lightpen values
        PSHS    Y                        ;F58D: 34 20
        LDB     #$10                     ;F58F: C6 10
ZF591   LDX     -$03,Y                   ;F591: AE 3D
        LDA     #$80                     ;F593: 86 80
        BITA    ,-Y                      ;F595: A5 A2
        BEQ     ZF5AA                    ;F597: 27 11
        LSRA                             ;F599: 44
        BITA    ,Y                       ;F59A: A5 A4
        BNE     ZF5AA                    ;F59C: 26 0C
        LSRA                             ;F59E: 44
        BITA    -$01,Y                   ;F59F: A5 3F
        BEQ     ZF5AA                    ;F5A1: 27 07
        BITB    -$01,Y                   ;F5A3: E5 3F
        BEQ     ZF5AA                    ;F5A5: 27 03
        LEAX    -$40,X                   ;F5A7: 30 88 C0
ZF5AA   STX     ,--Y                     ;F5AA: AF A3
        CMPY    #LPBUFF                  ;F5AC: 10 8C 20 CD
        BHI     ZF591                    ;F5B0: 22 DF
        PULS    Y                        ;F5B2: 35 20
        CLRA                             ;F5B4: 4F
        LDB     M0078                    ;F5B5: D6 78
        STD     M0044                    ;F5B7: DD 44
        LDU     #M20D0                   ;F5B9: CE 20 D0
        LEAY    -$03,Y                   ;F5BC: 31 3D
        CLRB                             ;F5BE: 5F
ZF5BF   LDX     ,U++                     ;F5BF: AE C1
        LDA     ,U+                      ;F5C1: A6 C0
        LEAX    $0140,X                  ;F5C3: 30 89 01 40
        CMPX    ,U                       ;F5C7: AC C4
        BHI     ZF5FC                    ;F5C9: 22 31
        LEAX    $08,X                    ;F5CB: 30 08
        CMPX    ,U                       ;F5CD: AC C4
        BCS     ZF5FC                    ;F5CF: 25 2B
        LEAX    -$08,X                   ;F5D1: 30 18
        STX     ,U                       ;F5D3: AF C4
        STA     $02,U                    ;F5D5: A7 42
        INCB                             ;F5D7: 5C
        BRA     ZF5FF                    ;F5D8: 20 25

ZF5DA   DEC     $0B,S                    ;F5DA: 6A 6B
        LEAX    $0140,X                  ;F5DC: 30 89 01 40
ZF5E0   TFR     X,D                      ;F5E0: 1F 10
        SUBD    M0044                    ;F5E2: 93 44
        BMI     ZF5F0                    ;F5E4: 2B 0A
        CMPD    #M0140                   ;F5E6: 10 83 01 40
        BCS     ZF5F2                    ;F5EA: 25 06
        LDD     #M013F                   ;F5EC: CC 01 3F
        CMPX    #MDC27                   ;F5EF: 8C DC 27
ZF5F2   STD     $08,S                    ;F5F2: ED 68
        CLRA                             ;F5F4: 4F
        FCB   $21                   Branch never (bypasses COMA)
LPERR   COMA                             ;F5F6
        PULS    X                        ;F5F7: 35 10
        STX     M0067                    ;F5F9: 9F 67  Reset FIRQ vector
        RTS                              ;F5FB: 39

ZF5FC   TSTB                             ;F5FC: 5D
        BNE     ZF609                    ;F5FD: 26 0A
ZF5FF   PSHS    U                        ;F5FF: 34 40
        CMPY    ,S++                     ;F601: 10 AC E1
        BNE     ZF5BF                    ;F604: 26 B9
        TSTB                             ;F606: 5D
        BEQ     LPERR                    ;F607: 27 ED
ZF609   LDA     #$03                     ;F609: 86 03
        MUL                              ;F60B: 3D
        NEGB                             ;F60C: 50
        LEAU    B,U                      ;F60D: 33 C5
        LDD     ,U                       ;F60F: EC C4
        CMPD    #MFA00                   ;F611: 10 83 FA 00
        BCC     LPERR                    ;F615: 24 DF
        CLR     $0A,S                    ;F617: 6F 6A
        CLR     $0B,S                    ;F619: 6F 6B
ZF61B   CMPD    #M0140                   ;F61B: 10 83 01 40
        BCS     ZF628                    ;F61F: 25 07
        SUBD    #M0140                   ;F621: 83 01 40
        INC     $0B,S                    ;F624: 6C 6B
        BRA     ZF61B                    ;F626: 20 F3
ZF628   TFR     D,X                      ;F628: 1F 01
        LDB     $02,U                    ;F62A: E6 42
        BITB    #$80                     ;F62C: C5 80
        BEQ     ZF5E0                    ;F62E: 27 B0
        CMPX    #M003F                   ;F630: 8C 00 3F
        BCS     ZF5DA                    ;F633: 25 A5
        CMPX    #M00FF                   ;F635: 8C 00 FF
        BLS     ZF5E0                    ;F638: 23 A6
ZF63A   INC     $0B,S                    ;F63A: 6C 6B
        BRA     ZF5F0                    ;F63C: 20 B2

hdlr_SWI JMP     [SWIVEC]                  ;F63E: 6E 9F 20 5E

hdlr_FIRQ JMP     [Z2067]                  ;F642: 6E 9F 20 67

* FIRQ handler for lightpen.
* Y is initially $20CD, DP is initially A7
LPFIRQ  CMPY    #M20E4                   ;F646: 10 8C 20 E4
        BCC     LPSKIP                    ;F64A: 24 08
        LDD     M00E4                    ;F64C: DC E4
        STD     ,Y++                     ;F64E: ED A1
        LDA     M00E6                    ;F650: 96 E6
        STA     ,Y+                      ;F652: A7 A0
LPSKIP  LDA     ,U                       ;F654: A6 C4   Read the PIA to lower FIRQ
ZF656   RTI                              ;F656: 3B

* IRQ handler
hdlr_IRQ LDB     #$20                     ;F657: C6 20
        TFR     B,DP                     ;F659: 1F 9B
        LDU     #PIAPORTA                   ;F65B: CE A7 C0
        LDB     M0019                    ;F65E: D6 19
        LDA     $03,U             Read the control port B to check IRQ
        BMI     ZF668             PIA caused the IRQ
        JMP     [Z2064]                  ;F664: 6E 9F 20 64

ZF668   INC     ITCMPT                    ;F668: 0C 31
        LDA     ITCMPT                    ;F66A: 96 31
        ANDA    #$03                     ;F66C: 84 03
        BNE     ZF691                    ;F66E: 26 21
        BITB    #$04                     ;F670: C5 04
        BEQ     ZF681                    ;F672: 27 0D
        LDA     ,U                       ;F674: A6 C4
        PSHS    A                        ;F676: 34 02
        SWI                              ;F678: 3F
        ROR     M00BD                    ;F679: 06 BD
        EORB    MB935                    ;F67B: F8 B9 35
        FCB     $02                      ;F67E: 02
        STA     ,U                       ;F67F: A7 C4
ZF681   TST     M0037                    ;F681: 0D 37
        BEQ     ZF691                    ;F683: 27 0C
        LDA     M0038                    ;F685: 96 38
        CMPA    M0076                    ;F687: 91 76
        BEQ     ZF68D                    ;F689: 27 02
        INC     M0038                    ;F68B: 0C 38
ZF68D   ANDB    #$FD                     ;F68D: C4 FD
        STB     M0019                    ;F68F: D7 19
ZF691   LDA     $01,U                    ;F691: A6 41
        TST     M0063                    ;F693: 0D 63
        BEQ     ZF656                    ;F695: 27 BF
        JMP     [TIMEVEC]                  ;F697: 6E 9F 20 61
        ORCC    #$D0                     ;F69B: 1A D0
        LDA     M003C                    ;F69D: 96 3C
        LDB     M003A                    ;F69F: D6 3A
        PSHS    A                        ;F6A1: 34 02
        LSRA                             ;F6A3: 44
        LSRA                             ;F6A4: 44
        ADDA    ,S+                      ;F6A5: AB E0
        MUL                              ;F6A7: 3D
        TFR     D,Y                      ;F6A8: 1F 02
        LDB     $04,S                    ;F6AA: E6 64
        ANDB    #$0F                     ;F6AC: C4 0F
        BEQ     ZF6BC                    ;F6AE: 27 0C
        LDX     #MF705                   ;F6B0: 8E F7 05
        LDB     B,X                      ;F6B3: E6 85
        LDA     M003F                    ;F6B5: 96 3F
        DECA                             ;F6B7: 4A
        BNE     ZF6BC                    ;F6B8: 26 02
        SUBB    #$02                     ;F6BA: C0 02
ZF6BC   TFR     B,A                      ;F6BC: 1F 98
ZF6BE   STD     M0044                    ;F6BE: DD 44
        BEQ     ZF6D2                    ;F6C0: 27 10
        LDX     M003E                    ;F6C2: 9E 3E
ZF6C4   LDB     $01,U                    ;F6C4: E6 41
        ORB     #$01                     ;F6C6: CA 01
        STB     $01,U                    ;F6C8: E7 41
        LDB     M0045                    ;F6CA: D6 45
        BSR     ZF6EE                    ;F6CC: 8D 20
        LEAX    -$01,X                   ;F6CE: 30 1F
        BNE     ZF6C4                    ;F6D0: 26 F2
ZF6D2   LDX     M003E                    ;F6D2: 9E 3E
ZF6D4   LDB     $01,U                    ;F6D4: E6 41
        ANDB    #$FE                     ;F6D6: C4 FE
        STB     $01,U                    ;F6D8: E7 41
        LDB     M0044                    ;F6DA: D6 44
        BSR     ZF6EE                    ;F6DC: 8D 10
        LEAX    -$01,X                   ;F6DE: 30 1F
        BNE     ZF6D4                    ;F6E0: 26 F2
        LDD     M0044                    ;F6E2: DC 44
        ADDA    M003D                    ;F6E4: 9B 3D
        BCS     ZF6D2                    ;F6E6: 25 EA
        SUBB    M003D                    ;F6E8: D0 3D
        BHI     ZF6BE                    ;F6EA: 22 D2
        BRA     ZF6D2                    ;F6EC: 20 E4
ZF6EE   STB     M0046                    ;F6EE: D7 46
ZF6F0   DECB                             ;F6F0: 5A
        BNE     ZF6F0                    ;F6F1: 26 FD
        LDB     M0046                    ;F6F3: D6 46
        BEQ     ZF6FF                    ;F6F5: 27 08
        ADDB    M0047                    ;F6F7: DB 47
        CMPB    M0047                    ;F6F9: D1 47
        STB     M0047                    ;F6FB: D7 47
        BCC     ZF703                    ;F6FD: 24 04
ZF6FF   LEAY    -$01,Y                   ;F6FF: 31 3F
        BEQ     ZF704                    ;F701: 27 01
ZF703   RTS                              ;F703: 39

ZF704   PULS    PC,D                     ;F704: 35 86
        SUBA    MA59C                    ;F706: B0 A5 9C
        SBCA    M0089                    ;F709: 92 89
        CMPA    #$78                     ;F70B: 81 78
        FCB     $71                      ;F70D: 71
        DEC     $03,S                    ;F70E: 6A 63
        TSTB                             ;F710: 5D
        ASRB                             ;F711: 57
        FCB     $51                      ;F712: 51
        LDU     #MA7E0                   ;F713: CE A7 E0
        LDA     M0042                    ;F716: 96 42
        ORA     #$D0                     ;F718: 8A D0
        TFR     A,CC                     ;F71A: 1F 8A
        BCS     ZF741                    ;F71C: 25 23
        BVS     ZF741                    ;F71E: 29 21
        BEQ     ZF727                    ;F720: 27 05
ZF722   LDA     M0042                    ;F722: 96 42
        STA     M0043                    ;F724: 97 43
        RTS                              ;F726: 39

ZF727   BSR     ZF722                    ;F727: 8D F9
        LDD     #M3AFF                   ;F729: CC 3A FF
        STA     $03,U                    ;F72C: A7 43
        STB     $01,U                    ;F72E: E7 41
        LDA     #$3E                     ;F730: 86 3E
        STA     $03,U                    ;F732: A7 43
        LDA     $01,U                    ;F734: A6 41
        COMA                             ;F736: 43
        STA     $01,U                    ;F737: A7 41
        CMPA    $01,U                    ;F739: A1 41
        BNE     ZF73F                    ;F73B: 26 02
ZF73D   CLRA                             ;F73D: 4F
        BRN     ZF783                    ;F73E: 21 43
        RTS                              ;F740: 39

ZF741   LDA     #$04                     ;F741: 86 04
        BITA    M0043                    ;F743: 95 43
        BEQ     ZF73F                    ;F745: 27 F8
        LSRA                             ;F747: 44
        BITA    M0042                    ;F748: 95 42
        BEQ     ZF75E                    ;F74A: 27 12
        SWI                              ;F74C: 3F
        ROR     M00D6                    ;F74D: 06 D6
        ASR     M8D10                    ;F74F: 77 8D 10
        LDX     M0027                    ;F752: 9E 27
ZF754   LDB     ,X+                      ;F754: E6 80
        BSR     ZF762                    ;F756: 8D 0A
        CMPX    #M1F40                   ;F758: 8C 1F 40
        BCS     ZF754                    ;F75B: 25 F7
        CMPX    #M8D02                   ;F75D: 8C 8D 02
        BRA     ZF73D                    ;F760: 20 DB
ZF762   LDA     #$36                     ;F762: 86 36
        STB     $01,U                    ;F764: E7 41
        STA     $03,U                    ;F766: A7 43
        ORA     #$08                     ;F768: 8A 08
        STA     $03,U                    ;F76A: A7 43
        LDA     $01,U                    ;F76C: A6 41
ZF76E   LDA     $03,U                    ;F76E: A6 43
        BPL     ZF76E                    ;F770: 2A FC
        RTS                              ;F772: 39

        ORCC    #$D0                     ;F773: 1A D0
        JSR     ZFB23                    ;F775: BD FB 23
        LDX     #MFC54                   ;F778: 8E FC 54
        LDA     M0059                    ;F77B: 96 59
        JSR     [A,X]                    ;F77D: AD 96
        CLR     M002F                    ;F77F: 0F 2F
        CLR     M002E                    ;F781: 0F 2E
ZF783   RTS                              ;F783: 39

        CMPB    #$20                     ;F784: C1 20
        BCC     ZF7B5                    ;F786: 24 2D
        CMPB    #$07                     ;F788: C1 07
        BCS     ZF783                    ;F78A: 25 F7
        CLRA                             ;F78C: 4F
        ASLB                             ;F78D: 58
        LDX     #MFC4E                   ;F78E: 8E FC 4E
        JMP     [B,X]                    ;F791: 6E 95
        CLR     M0059                    ;F793: 0F 59
        CMPB    #$4B                     ;F795: C1 4B
        BEQ     ZF7AA                    ;F797: 27 11
        LDA     #$02                     ;F799: 86 02
        STA     M005B                    ;F79B: 97 5B
        ASLA                             ;F79D: 48
        LDX     M006D                    ;F79E: 9E 6D
ZF7A0   LEAX    -$03,X                   ;F7A0: 30 1D
        CMPB    $02,X                    ;F7A2: E1 02
        BEQ     ZF7AF                    ;F7A4: 27 09
        DECA                             ;F7A6: 4A
        BNE     ZF7A0                    ;F7A7: 26 F7
        CMPX    #M8680                   ;F7A9: 8C 86 80
        STA     M005B                    ;F7AC: 97 5B
        RTS                              ;F7AE: 39

ZF7AF   TFR     A,B                      ;F7AF: 1F 89
        ORB     #$80                     ;F7B1: CA 80
        BRA     ZF7D4                    ;F7B3: 20 1F
ZF7B5   CLR     M002F                    ;F7B5: 0F 2F
        TST     M005B                    ;F7B7: 0D 5B
        BMI     ZF7CC                    ;F7B9: 2B 11
        BEQ     ZF7C3                    ;F7BB: 27 06
        CMPB    #$61                     ;F7BD: C1 61
        BCC     ZF7D4                    ;F7BF: 24 13
ZF7C1   CLR     M005B                    ;F7C1: 0F 5B
ZF7C3   TSTB                             ;F7C3: 5D
        BPL     ZF7D4                    ;F7C4: 2A 0E
        LDU     M0070                    ;F7C6: DE 70
        SUBB    #$80                     ;F7C8: C0 80
        BRA     ZF7D8                    ;F7CA: 20 0C
ZF7CC   CMPB    #$63                     ;F7CC: C1 63
        BNE     ZF7C1                    ;F7CE: 26 F1
        LDB     M005B                    ;F7D0: D6 5B
        CLR     M005B                    ;F7D2: 0F 5B
ZF7D4   LDU     M0073                    ;F7D4: DE 73
        SUBB    #$20                     ;F7D6: C0 20
ZF7D8   LDA     #$08                     ;F7D8: 86 08
        MUL                              ;F7DA: 3D
        LEAU    D,U                      ;F7DB: 33 CB
        CLR     M0030                    ;F7DD: 0F 30
        LDY     M0021                    ;F7DF: 10 9E 21
        LDB     M002A                    ;F7E2: D6 2A
        ANDB    #$03                     ;F7E4: C4 03
        LSRB                             ;F7E6: 54
        BNE     ZF808                    ;F7E7: 26 1F
        BSR     ZF838                    ;F7E9: 8D 4D
ZF7EB   PULU    A                        ;F7EB: 37 02
        BSR     ZF802                    ;F7ED: 8D 13
        BCC     ZF7F3                    ;F7EF: 24 02
        BSR     ZF802                    ;F7F1: 8D 0F
ZF7F3   DECB                             ;F7F3: 5A
        BNE     ZF7EB                    ;F7F4: 26 F5
        BSR     ZF86C                    ;F7F6: 8D 74
ZF7F8   BSR     ZF802                    ;F7F8: 8D 08
        LEAX    -$01,X                   ;F7FA: 30 1F
        BNE     ZF7F8                    ;F7FC: 26 FA
        BRA     ZF833                    ;F7FE: 20 33
ZF800   STB     $01,Y                    ;F800: E7 21
ZF802   STA     ,Y                       ;F802: A7 A4
        LEAY    -$28,Y                   ;F804: 31 A8 D8
        RTS                              ;F807: 39

ZF808   BSR     ZF838                    ;F808: 8D 2E
ZF80A   PULU    A                        ;F80A: 37 02
        PSHS    B,CC                     ;F80C: 34 05
        STA     M0044                    ;F80E: 97 44
        LDD     #M8000                   ;F810: CC 80 00
ZF813   LSR     M0044                    ;F813: 04 44
        RORA                             ;F815: 46
        RORB                             ;F816: 56
        ASRA                             ;F817: 47
        RORB                             ;F818: 56
        BCC     ZF813                    ;F819: 24 F8
        PULS    CC                       ;F81B: 35 01
        BSR     ZF800                    ;F81D: 8D E1
        BCC     ZF823                    ;F81F: 24 02
        BSR     ZF800                    ;F821: 8D DD
ZF823   PULS    B                        ;F823: 35 04
        DECB                             ;F825: 5A
        BNE     ZF80A                    ;F826: 26 E2
        BSR     ZF86C                    ;F828: 8D 42
ZF82A   BSR     ZF800                    ;F82A: 8D D4
        LEAX    -$01,X                   ;F82C: 30 1F
        BNE     ZF82A                    ;F82E: 26 FA
        CMPX    #M3262                   ;F830: 8C 32 62
ZF833   TST     M005B                    ;F833: 0D 5B
        BEQ     ZF884                    ;F835: 27 4D
        RTS                              ;F837: 39

ZF838   LDB     #$08                     ;F838: C6 08
        TST     M005B                    ;F83A: 0D 5B
        BEQ     ZF844                    ;F83C: 27 06
        DEC     M005B                    ;F83E: 0A 5B
        BNE     ZF844                    ;F840: 26 02
        DECB                             ;F842: 5A
        DECB                             ;F843: 5A
ZF844   RTS                              ;F844: 39

        LDU     COLOUR                    ;F845: DE 2B
        LDX     M0021                    ;F847: 9E 21
        LDY     M001B                    ;F849: 10 9E 1B
        LDA     M002A                    ;F84C: 96 2A
        LDB     #$FF                     ;F84E: C6 FF
        STB     M002C                    ;F850: D7 2C
ZF852   LDB     #$20                     ;F852: C6 20
        SWI                              ;F854: 3F
        FCB     $02                      ;F855: 02
        LDB     M001C                    ;F856: D6 1C
        CMPB    #$01                     ;F858: C1 01
        BNE     ZF852                    ;F85A: 26 F6
        STU     COLOUR                    ;F85C: DF 2B
        STX     M0021                    ;F85E: 9F 21
        STY     M001B                    ;F860: 10 9F 1B
        STA     M002A                    ;F863: 97 2A
ZF865   LDA     #$FF                     ;F865: 86 FF
        STA     [M201A]                  ;F867: A7 9F 20 1A
        RTS                              ;F86B: 39

ZF86C   LDX     #M0008                   ;F86C: 8E 00 08
        BCC     ZF873                    ;F86F: 24 02
        LEAX    $08,X                    ;F871: 30 08
ZF873   LDA     #$40                     ;F873: 86 40
        ANDA    M0019                    ;F875: 94 19
        BNE     ZF831                    ;F877: 26 B8
        LDY     M0021                    ;F879: 10 9E 21
ZF87C   JSR     ZFB2C                    ;F87C: BD FB 2C
        LDA     COLOUR                    ;F87F: 96 2B
        LDB     COLOUR                    ;F881: D6 2B
        RTS                              ;F883: 39

ZF884   LDA     M002A                    ;F884: 96 2A
        BITA    #$02                     ;F886: 85 02
        BEQ     ZF88E                    ;F888: 27 04
        INC     M001C                    ;F88A: 0C 1C
        INC     M0022                    ;F88C: 0C 22
ZF88E   BRA     ZF8E5                    ;F88E: 20 55
        BSR     ZF8AC                    ;F890: 8D 1A
        LDA     #$FB                     ;F892: 86 FB
        CMPX    #M86BF                   ;F894: 8C 86 BF
        ANDA    M0019                    ;F897: 94 19
        BRA     ZF89F                    ;F899: 20 04
        LDA     #$40                     ;F89B: 86 40
ZF89D   ORA     M0019                    ;F89D: 9A 19
ZF89F   STA     M0019                    ;F89F: 97 19
        RTS                              ;F8A1: 39

        LDA     $04,S                    ;F8A2: A6 64
        ANDA    #$EF                     ;F8A4: 84 EF
        STA     $04,S                    ;F8A6: A7 64
ZF8A8   LDA     #$04                     ;F8A8: 86 04
        BRA     ZF89D                    ;F8AA: 20 F1
ZF8AC   LDA     M0019                    ;F8AC: 96 19
        BITA    #$04                     ;F8AE: 85 04
        BEQ     ZF8BF                    ;F8B0: 27 0D
        TST     M0030                    ;F8B2: 0D 30
        BEQ     ZF8BF                    ;F8B4: 27 09
        JSR     ZFB23                    ;F8B6: BD FB 23
        COM     [M2021]                  ;F8B9: 63 9F 20 21
        COM     M0030                    ;F8BD: 03 30
ZF8BF   RTS                              ;F8BF: 39

        BSR     ZF8AC                    ;F8C0: 8D EA
        CLR     M001C                    ;F8C2: 0F 1C
        INC     M001C                    ;F8C4: 0C 1C
        BSR     ZF93D                    ;F8C6: 8D 75
        BRA     ZF865                    ;F8C8: 20 9B
        BSR     ZF8AC                    ;F8CA: 8D E0
        INC     M001B                    ;F8CC: 0C 1B
        LDA     M001B                    ;F8CE: 96 1B
        CMPA    M0020                    ;F8D0: 91 20
        BLS     ZF93D                    ;F8D2: 23 69
        CLRB                             ;F8D4: 5F
        BRA     ZF922                    ;F8D5: 20 4B
MF8D7   BSR     ZF8AC                    ;F8D7: 8D D3
ZF8D9   CLR     M001C                    ;F8D9: 0F 1C
        INC     M001C                    ;F8DB: 0C 1C
        BRA     ZF939                    ;F8DD: 20 5A
MF8DF   BSR     ZF8FC                    ;F8DF: 8D 1B
        LDA     #$FF                     ;F8E1: 86 FF
        STA     M002E                    ;F8E3: 97 2E
ZF8E5   INC     M001C                    ;F8E5: 0C 1C
        LDA     M001C                    ;F8E7: 96 1C
        CMPA    #$29                     ;F8E9: 81 29
        BEQ     ZF905                    ;F8EB: 27 18
        CMPA    #$2A                     ;F8ED: 81 2A
        BEQ     ZF903                    ;F8EF: 27 12
        TST     M002F                    ;F8F1: 0D 2F
        BEQ     ZF8F9                    ;F8F3: 27 04
        LEAY    $01,X                    ;F8F5: 31 01
        BSR     ZF968                    ;F8F7: 8D 6F
ZF8F9   INC     M0022                    ;F8F9: 0C 22
        RTS                              ;F8FB: 39

ZF8FC   BSR     ZF8AC                    ;F8FC: 8D AE
        LDX     M0021                    ;F8FE: 9E 21
        LDB     #$08                     ;F900: C6 08
        RTS                              ;F902: 39

ZF903   DEC     M0022                    ;F903: 0A 22
ZF905   TST     M002F                    ;F905: 0D 2F
        BEQ     ZF90F                    ;F907: 27 06
        LEAY    $0119,X                  ;F909: 31 89 01 19
        BSR     ZF968                    ;F90D: 8D 59
ZF90F   LDD     #M0101                   ;F90F: CC 01 01
        STA     M001C                    ;F912: 97 1C
        TST     M002E                    ;F914: 0D 2E
        BMI     ZF922                    ;F916: 2B 0A
        LDX     M001A                    ;F918: 9E 1A
        BITB    M002A                    ;F91A: D5 2A
        BEQ     ZF920                    ;F91C: 27 02
        CLR     -$01,X                   ;F91E: 6F 1F
ZF920   CLR     ,X                       ;F920: 6F 84
ZF922   ANDB    M002A                    ;F922: D4 2A
        ASLB                             ;F924: 58
        ASLB                             ;F925: 58
        ASLB                             ;F926: 58
        LDX     #MFC8E                   ;F927: 8E FC 8E
        ABX                              ;F92A: 3A
        LDA     M001B                    ;F92B: 96 1B
        ADDA    ,X                       ;F92D: AB 84
        STA     M001B                    ;F92F: 97 1B
        CMPA    M0020                    ;F931: 91 20
        BLS     ZF93D                    ;F933: 23 08
        TST     M002C                    ;F935: 0D 2C
        BEQ     ZF940                    ;F937: 27 07
ZF939   LDA     M001E                    ;F939: 96 1E
ZF93B   STA     M001B                    ;F93B: 97 1B
ZF93D   JMP     ZFBDF                    ;F93D: 7E FB DF
ZF940   STX     M0044                    ;F940: 9F 44
        LDB     ,X                       ;F942: E6 84
ZF944   LDY     M001D                    ;F944: 10 9E 1D
ZF947   CMPY    M001F                    ;F947: 10 9C 1F
        BCC     ZF952                    ;F94A: 24 06
        LDA     $01,Y                    ;F94C: A6 21
        STA     ,Y+                      ;F94E: A7 A0
        BRA     ZF947                    ;F950: 20 F5
ZF952   LDA     #$FF                     ;F952: 86 FF
        STA     ,Y                       ;F954: A7 A4
        DECB                             ;F956: 5A
        BNE     ZF944                    ;F957: 26 EB
        LDA     ,X                       ;F959: A6 84
        ASLA                             ;F95B: 48
        ASLA                             ;F95C: 48
        ASLA                             ;F95D: 48
        LDX     #MFA46                   ;F95E: 8E FA 46
        LDU     #MFA69                   ;F961: CE FA 69
        BSR     ZF9D5                    ;F964: 8D 6F
        BRA     ZF9A4                    ;F966: 20 3C
ZF968   LDA     ,X                       ;F968: A6 84
        LEAX    -$28,X                   ;F96A: 30 88 D8
        JSR     ZF802                    ;F96D: BD F8 02
        DECB                             ;F970: 5A
        BNE     ZF968                    ;F971: 26 F5
        RTS                              ;F973: 39

        BSR     ZF8FC                    ;F974: 8D 86
        LDA     M001C                    ;F976: 96 1C
        CMPA    #$01                     ;F978: 81 01
        BGT     ZF98C                    ;F97A: 2E 10
        TST     M002F                    ;F97C: 0D 2F
        BEQ     ZF986                    ;F97E: 27 06
        LEAY    $FEE7,X                  ;F980: 31 89 FE E7
        BSR     ZF968                    ;F984: 8D E2
ZF986   LDB     #$28                     ;F986: C6 28
        STB     M001C                    ;F988: D7 1C
        BRA     ZF99C                    ;F98A: 20 10
ZF98C   TST     M002F                    ;F98C: 0D 2F
        BEQ     ZF994                    ;F98E: 27 04
ZF990   LEAY    -$01,X                   ;F990: 31 1F
        BSR     ZF968                    ;F992: 8D D4
ZF994   DEC     M0022                    ;F994: 0A 22
        DEC     M001C                    ;F996: 0A 1C
        RTS                              ;F998: 39

        JSR     ZF8AC                    ;F999: BD F8 AC
ZF99C   LDA     M001B                    ;F99C: 96 1B
        CMPA    M001E                    ;F99E: 91 1E
        BLE     ZF9A8                    ;F9A0: 2F 06
        DECA                             ;F9A2: 4A
        CMPX    #M9620                   ;F9A3: 8C 96 20
        BRA     ZF93B                    ;F9A6: 20 93
ZF9A8   TST     M002C                    ;F9A8: 0D 2C
        BNE     ZF9A4                    ;F9AA: 26 F8
        LDD     #M0801                   ;F9AC: CC 08 01
        ANDB    M002A                    ;F9AF: D4 2A
        BEQ     ZF9B4                    ;F9B1: 27 01
        ASLA                             ;F9B3: 48
ZF9B4   PSHS    A                        ;F9B4: 34 02
ZF9B6   LDY     M001F                    ;F9B6: 10 9E 1F
ZF9B9   CMPY    M001D                    ;F9B9: 10 9C 1D
        BLS     ZF9C4                    ;F9BC: 23 06
        LDB     ,-Y                      ;F9BE: E6 A2
        STB     $01,Y                    ;F9C0: E7 21
        BRA     ZF9B9                    ;F9C2: 20 F5
ZF9C4   LDB     #$FF                     ;F9C4: C6 FF
        STB     ,Y                       ;F9C6: E7 A4
        LSRA                             ;F9C8: 44
        BITA    #$08                     ;F9C9: 85 08
        BNE     ZF9B6                    ;F9CB: 26 E9
        PULS    A                        ;F9CD: 35 02
        LDX     #MF9FC                   ;F9CF: 8E F9 FC
        LDU     #MFA27                   ;F9D2: CE FA 27
ZF9D5   PSHS    U,X,A                    ;F9D5: 34 52
        DEC     ,S                       ;F9D7: 6A E4
        BMI     ZF9FA                    ;F9D9: 2B 1F
        SWI                              ;F9DB: 3F
        ROR     M00AD                    ;F9DC: 06 AD
        EORB    M01DC                    ;F9DE: F8 01 DC
        BEQ     ZF990                    ;F9E1: 27 AD
        EORB    M0386                    ;F9E3: F8 03 86
        NEGA                             ;F9E6: 40
        ANDA    M0019                    ;F9E7: 94 19
        BNE     ZF9F6                    ;F9E9: 26 0B
        SWI                              ;F9EB: 3F
        LSR     M00AD                    ;F9EC: 04 AD
        EORB    M01BD                    ;F9EE: F8 01 BD
        EORB    M7FAD                    ;F9F1: F8 7F AD
        EORB    M030D                    ;F9F4: F8 03 0D
        BLT     ZFA1F                    ;F9F7: 2D 26
        STD     M0035                    ;F9F9: DD 35
        SBCB    M0010                    ;F9FB: D2 10
        STU     M0046                    ;F9FD: DF 46
        LDD     M0023                    ;F9FF: DC 23
        ADDD    #M0028                   ;FA01: C3 00 28
        STD     M0044                    ;FA04: DD 44
        LDU     M0025                    ;FA06: DE 25
        LEAS    -$2F,U                   ;FA08: 32 C8 D1
        TST     M002D                    ;FA0B: 0D 2D
        BNE     ZFA13                    ;FA0D: 26 04
        LEAS    $FEE8,S                  ;FA0F: 32 E9 FE E8
ZFA13   PULS    Y,X,DP,D                 ;FA13: 35 3E
        PSHU    Y,X,DP,D                 ;FA15: 36 3E
        LEAS    -$0E,S                   ;FA17: 32 72
        CMPU    M2044                    ;FA19: 11 B3 20 44
        BHI     ZFA13                    ;FA1D: 22 F4
ZFA1F   LDA     #$20                     ;FA1F: 86 20
        TFR     A,DP                     ;FA21: 1F 8B
ZFA23   LDS     M0046                    ;FA23: 10 DE 46
        RTS                              ;FA26: 39

MFA27   STS     M0046                    ;FA27: 10 DF 46
        TFR     D,X                      ;FA2A: 1F 01
        TFR     D,Y                      ;FA2C: 1F 02
        TFR     D,S                      ;FA2E: 1F 04
        LDU     M0023                    ;FA30: DE 23
        LEAU    $28,U                    ;FA32: 33 C8 28
        TST     M002D                    ;FA35: 0D 2D
        BNE     ZFA3D                    ;FA37: 26 04
        LEAU    $0118,U                  ;FA39: 33 C9 01 18
ZFA3D   PSHU    S,Y,X,D                  ;FA3D: 36 76
        CMPU    M0023                    ;FA3F: 11 93 23
        BHI     ZFA3D                    ;FA42: 22 F9
        BRA     ZFA23                    ;FA44: 20 DD
MFA46   STS     M0046                    ;FA46: 10 DF 46
        LDS     M0044                    ;FA49: 10 DE 44
        LDD     $05,S                    ;FA4C: EC 65
        LDU     M0023                    ;FA4E: DE 23
        LEAS    $28,U                    ;FA50: 32 C8 28
        LEAU    $07,U                    ;FA53: 33 47
        TST     M002D                    ;FA55: 0D 2D
        BNE     ZFA5B                    ;FA57: 26 02
        LEAS    D,S                      ;FA59: 32 EB
ZFA5B   PULS    Y,X,DP,D                 ;FA5B: 35 3E
        PSHU    Y,X,DP,D                 ;FA5D: 36 3E
        LEAU    $0E,U                    ;FA5F: 33 4E
        CMPS    M2025                    ;FA61: 11 BC 20 25
        BCS     ZFA5B                    ;FA65: 25 F4
        BRA     ZFA1F                    ;FA67: 20 B6
MFA69   STS     M0046                    ;FA69: 10 DF 46
        TFR     D,X                      ;FA6C: 1F 01
        TFR     D,Y                      ;FA6E: 1F 02
        LDS     M0044                    ;FA70: 10 DE 44
        LDD     $03,S                    ;FA73: EC 63
        LDU     M0025                    ;FA75: DE 25
        LEAU    -$20,U                   ;FA77: 33 C8 E0
        TST     M002D                    ;FA7A: 0D 2D
        BNE     ZFA80                    ;FA7C: 26 02
        LEAU    D,U                      ;FA7E: 33 CB
ZFA80   TFR     X,D                      ;FA80: 1F 10
        TFR     D,S                      ;FA82: 1F 04
ZFA84   PSHU    S,Y,X,D                  ;FA84: 36 76
        LEAU    $10,U                    ;FA86: 33 C8 10
        CMPU    M0025                    ;FA89: 11 93 25
        BLS     ZFA84                    ;FA8C: 23 F6
        BRA     ZFA23                    ;FA8E: 20 93
        CLR     M0030                    ;FA90: 0F 30
        LDD     M0027                    ;FA92: DC 27
ZFA94   TFR     D,X                      ;FA94: 1F 01
        TFR     D,Y                      ;FA96: 1F 02
        LDU     M0025                    ;FA98: DE 25
ZFA9A   PSHU    Y,X,D                    ;FA9A: 36 36
        PSHU    Y,X                      ;FA9C: 36 30
        CMPU    M0023                    ;FA9E: 11 93 23
        BGT     ZFA9A                    ;FAA1: 2E F7
        LDD     #M4001                   ;FAA3: CC 40 01
        ANDA    M0019                    ;FAA6: 94 19
        BNE     ZFAB4                    ;FAA8: 26 0A
        ANDB    PIAPORTA                    ;FAAA: F4 A7 C0
        BEQ     ZFAB4                    ;FAAD: 27 05
        JSR     ZF87C                    ;FAAF: BD F8 7C
        BRA     ZFA94                    ;FAB2: 20 E0
ZFAB4   LDX     M001D                    ;FAB4: 9E 1D
        LDA     #$FF                     ;FAB6: 86 FF
ZFAB8   STA     ,X+                      ;FAB8: A7 80
        CMPX    M001F                    ;FABA: 9C 1F
        BLS     ZFAB8                    ;FABC: 23 FA
        JMP     ZF8D9                    ;FABE: 7E F8 D9
        LDA     $04,S                    ;FAC1: A6 64
        TFR     A,CC                     ;FAC3: 1F 8A
        LDA     M0019                    ;FAC5: 96 19
        BITA    #$08                     ;FAC7: 85 08
        BNE     ZFAD8                    ;FAC9: 26 0D
        CLRA                             ;FACB: 4F
ZFACC   STA     PIAPORTB                    ;FACC: B7 A7 C1
        INCA                             ;FACF: 4C
        CLRB                             ;FAD0: 5F
ZFAD1   INCB                             ;FAD1: 5C
        BPL     ZFAD1                    ;FAD2: 2A FD
        CMPA    #$11                     ;FAD4: 81 11
        BNE     ZFACC                    ;FAD6: 26 F4
ZFAD8   RTS                              ;FAD8: 39

        LDA     PIA_CRB                    ;FAD9: B6 A7 C3
        ANDA    #$F7                     ;FADC: 84 F7
        BRA     ZFAE5                    ;FADE: 20 05
        LDA     PIA_CRB                    ;FAE0: B6 A7 C3
        ORA     #$08                     ;FAE3: 8A 08
ZFAE5   STA     PIA_CRB                    ;FAE5: B7 A7 C3
        RTS                              ;FAE8: 39

        ANDB    #$03                     ;FAE9: C4 03
        LDA     M002A                    ;FAEB: 96 2A
        ANDA    #$FC                     ;FAED: 84 FC
        BSR     ZFB10                    ;FAEF: 8D 1F
        STA     M002A                    ;FAF1: 97 2A
        RTS                              ;FAF3: 39

        LDX     M0023                    ;FAF4: 9E 23
        SWI                              ;FAF6: 3F
        LSR     M00A6                    ;FAF7: 04 A6
        ANDA    #$8D                     ;FAF9: 84 8D
        INC     M00A7                    ;FAFB: 0C A7
        SUBA    #$9C                     ;FAFD: 80 9C
        BCS     ZFB27                    ;FAFF: 25 26
        LDB     M962B                    ;FB01: F6 96 2B
        BSR     ZFB08                    ;FB04: 8D 02
        BRA     ZFB77                    ;FB06: 20 6F
ZFB08   TFR     A,B                      ;FB08: 1F 89
        LSRA                             ;FB0A: 44
        LSRA                             ;FB0B: 44
        LSRA                             ;FB0C: 44
        LSRA                             ;FB0D: 44
        BSR     ZFB3A                    ;FB0E: 8D 2A
ZFB10   PSHS    B                        ;FB10: 34 04
        ADDA    ,S+                      ;FB12: AB E0
        RTS                              ;FB14: 39

        ASLB                             ;FB15: 58
        ANDB    #$1E                     ;FB16: C4 1E
        LDA     PIAPORTA                    ;FB18: B6 A7 C0
        ANDA    #$E1                     ;FB1B: 84 E1
        BSR     ZFB10                    ;FB1D: 8D F1
        STA     PIAPORTA                    ;FB1F: B7 A7 C0
        RTS                              ;FB22: 39


ZFB23   PSHS    A                        ;FB23: 34 02
        LDA     #$01                     ;FB25: 86 01    ; Activate IRQ
ZFB27   ORA     PIAPORTA                    ;FB27: BA A7 C0
        BRA     ZFB33                    ;FB2A: 20 07

ZFB2C   PSHS    A                        ;FB2C: 34 02
        LDA     #$FE                     ;FB2E: 86 FE    ; Deactivate IRQ
        ANDA    PIAPORTA                    ;FB30: B4 A7 C0

ZFB33   STA     PIAPORTA                    ;FB33: B7 A7 C0
        PULS    PC,A                     ;FB36: 35 82

ZFB38   LDA     #$0F                     ;FB38: 86 0F
ZFB3A   ASLB                             ;FB3A: 58
        ASLB                             ;FB3B: 58
        ASLB                             ;FB3C: 58
        ASLB                             ;FB3D: 58
        RTS                              ;FB3E: 39

        ANDB    #$0F                     ;FB3F: C4 0F
        LDA     #$F0                     ;FB41: 86 F0
        PSHS    A                        ;FB43: 34 02
        BSR     ZFB4F                    ;FB45: 8D 08
        PULS    A                        ;FB47: 35 02
        ANDB    #$0F                     ;FB49: C4 0F
        LDA     #$F0                     ;FB4B: 86 F0
        BRA     ZFB73                    ;FB4D: 20 24
ZFB4F   SWI                              ;FB4F: 3F
        LSR     M00D7                    ;FB50: 04 D7
        LSRA                             ;FB52: 44
        STB     M0045                    ;FB53: D7 45
        LDX     M0023                    ;FB55: 9E 23
ZFB57   LDD     ,X                       ;FB57: EC 84
        ANDA    $02,S                    ;FB59: A4 62
        ANDB    $02,S                    ;FB5B: E4 62
        ADDD    M0044                    ;FB5D: D3 44
        STD     ,X++                     ;FB5F: ED 81
        CMPX    M0025                    ;FB61: 9C 25
        BNE     ZFB57                    ;FB63: 26 F2
        LDB     M0044                    ;FB65: D6 44
        RTS                              ;FB67: 39

        BSR     ZFB38                    ;FB68: 8D CE
        PSHS    A                        ;FB6A: 34 02
        BSR     ZFB4F                    ;FB6C: 8D E1
        PULS    A                        ;FB6E: 35 02
        CMPX    #M8DC5                   ;FB70: 8C 8D C5
ZFB73   ANDA    COLOUR                    ;FB73: 94 2B
        BSR     ZFB10                    ;FB75: 8D 99
ZFB77   STA     COLOUR                    ;FB77: 97 2B
        RTS                              ;FB79: 39

        CLR     M002C                    ;FB7A: 0F 2C
        CMPB    #$7A                     ;FB7C: C1 7A
        BEQ     ZFB88                    ;FB7E: 27 08
        CLR     M002D                    ;FB80: 0F 2D
        LSRB                             ;FB82: 54
        BCC     ZFB8A                    ;FB83: 24 05
        COM     M002D                    ;FB85: 03 2D
        CMPX    #M032C                   ;FB87: 8C 03 2C
ZFB8A   RTS                              ;FB8A: 39

MFB8B   INCA                             ;FB8B: 4C
        INCA                             ;FB8C: 4C
MFB8D   INCA                             ;FB8D: 4C
        ASLA                             ;FB8E: 48
        STA     M0059                    ;FB8F: 97 59
        RTS                              ;FB91: 39

MFB92   TST     M005A                    ;FB92: 0D 5A
        BNE     ZFB99                    ;FB94: 26 03
        STB     M005A                    ;FB96: D7 5A
        RTS                              ;FB98: 39

ZFB99   JSR     ZF8AC                    ;FB99: BD F8 AC
        CMPB    #$40                     ;FB9C: C1 40
        BLT     ZFBAE                    ;FB9E: 2D 0E
        ANDB    #$3F                     ;FBA0: C4 3F
        STB     M001C                    ;FBA2: D7 1C
        LDB     M005A                    ;FBA4: D6 5A
        ANDB    #$3F                     ;FBA6: C4 3F
        STB     M001B                    ;FBA8: D7 1B
        BSR     ZFBDF                    ;FBAA: 8D 33
        BRA     ZFBDA                    ;FBAC: 20 2C
ZFBAE   CMPB    #$30                     ;FBAE: C1 30
        BGE     ZFBDA                    ;FBB0: 2C 28
        LDU     M001B                    ;FBB2: DE 1B
        LDX     M0021                    ;FBB4: 9E 21
        PSHS    U,X                      ;FBB6: 34 50
        CMPB    #$20                     ;FBB8: C1 20
        BLT     ZFBC9                    ;FBBA: 2D 0D
        BSR     ZFBE9                    ;FBBC: 8D 2B
        STB     M001E                    ;FBBE: D7 1E
        BSR     ZFBDF                    ;FBC0: 8D 1D
        SUBD    #M0118                   ;FBC2: 83 01 18
        STD     M0023                    ;FBC5: DD 23
        BRA     ZFBD4                    ;FBC7: 20 0B
ZFBC9   BSR     ZFBE9                    ;FBC9: 8D 1E
        STB     M0020                    ;FBCB: D7 20
        BSR     ZFBDF                    ;FBCD: 8D 10
        ADDD    #M0028                   ;FBCF: C3 00 28
        STD     M0025                    ;FBD2: DD 25
ZFBD4   PULS    U,X                      ;FBD4: 35 50
        STU     M001B                    ;FBD6: DF 1B
        STX     M0021                    ;FBD8: 9F 21
ZFBDA   CLR     M005A                    ;FBDA: 0F 5A
        CLR     M0059                    ;FBDC: 0F 59
        RTS                              ;FBDE: 39

ZFBDF   LDA     M001B                    ;FBDF: 96 1B
        JSR     ZF37C                    ;FBE1: BD F3 7C
        ADDB    M001C                    ;FBE4: DB 1C
        STD     M0021                    ;FBE6: DD 21
        RTS                              ;FBE8: 39

ZFBE9   CLR     M001C                    ;FBE9: 0F 1C
        INC     M001C                    ;FBEB: 0C 1C
        ANDB    #$0F                     ;FBED: C4 0F
        STB     M001B                    ;FBEF: D7 1B
        LDA     M005A                    ;FBF1: 96 5A
        ANDA    #$0F                     ;FBF3: 84 0F
        LDB     #$0A                     ;FBF5: C6 0A
        MUL                              ;FBF7: 3D
        ADDB    M001B                    ;FBF8: DB 1B
        STB     M001B                    ;FBFA: D7 1B
        RTS                              ;FBFC: 39

        LDA     #$80                     ;FBFD: 86 80
        CMPB    #$20                     ;FBFF: C1 20
        BEQ     ZFC1F                    ;FC01: 27 1C
        CMPB    #$40                     ;FC03: C1 40
        BLT     ZFC23                    ;FC05: 2D 1C
        LDU     #MFC24                   ;FC07: CE FC 24
        TST     M002A                    ;FC0A: 0D 2A
        BMI     ZFC10                    ;FC0C: 2B 02
        LEAU    $0F,U                    ;FC0E: 33 4F
ZFC10   CMPB    ,U                       ;FC10: E1 C4
        LEAU    $03,U                    ;FC12: 33 43
        BCS     ZFC10                    ;FC14: 25 FA
        JSR     [,--U]                   ;FC16: AD D3
MFC18   CLR     M0059                    ;FC18: 0F 59
        LDA     #$7F                     ;FC1A: 86 7F
        ANDA    M002A                    ;FC1C: 94 2A
        CMPX    #M9A2A                   ;FC1E: 8C 9A 2A
        STA     M002A                    ;FC21: 97 2A
ZFC23   RTS                              ;FC23: 39

* Jump table
MFC24   INC     MFC18                    ;FC24: 7C FC 18
        FCB     $7B                      ;FC27: 7B
        ORB     MF460                    ;FC28: FA F4 60
        LDD     M1850                    ;FC2B: FC 18 50
        ADDB    M3F40                    ;FC2E: FB 3F 40
        ADDB    M687C                    ;FC31: FB 68 7C
        LDD     M187B                    ;FC34: FC 18 7B
        ADDB    M0278                    ;FC37: FB 02 78
        ADDB    M7A77                    ;FC3A: FB 7A 77
        ORB     MD976                    ;FC3D: FA D9 76
        ORB     ME075                    ;FC40: FA E0 75
        EORB    M9B74                    ;FC43: F8 9B 74
        EORB    M9570                    ;FC46: F8 95 70
        ORB     ME960                    ;FC49: FA E9 60
        ADDB    M1550                    ;FC4C: FB 15 50
        ADDB    M4940                    ;FC4F: FB 49 40
        ADDB    M71F7                    ;FC52: FB 71 F7
        ANDA    #$FB                     ;FC55: 84 FB
        STD     MFB92                    ;FC57: FD FB 92
        STB     M93FA                    ;FC5A: F7 93 FA
        CMPB    #$F9                     ;FC5D: C1 F9
        LSR     MF8DF                    ;FC5F: 74 F8 DF
        EORB    MCAF9                    ;FC62: F8 CA F9
        ADCA    M00FA                    ;FC65: 99 FA
        SUBA    M00F8                    ;FC67: 90 F8
        SUBB    #$F7                     ;FC69: C0 F7
        SUBD    #ZF783                   ;FC6B: 83 F7 83
        STB     M83F8                    ;FC6E: F7 83 F8
        fcb     $A2
        fcb     $F7
        SUBD    #ZF783                   ;FC73: 83 F7 83
        EORB    M90F7                    ;FC76: F8 90 F7
        SUBD    #MFB8B                   ;FC79: 83 FB 8B
        STB     M83F8                    ;FC7C: F7 83 F8
        FCB     $45                      ;FC7F: 45
        STB     M83F7                    ;FC80: F7 83 F7
        SUBD    #MFB8D                   ;FC83: 83 FB 8D
        STB     M83F7                    ;FC86: F7 83 F7
        SUBD    #MF8D7                   ;FC89: 83 F8 D7
        ADDB    M8C01                    ;FC8C: FB 8C 01
        FCB     $01                      ;FC8F: 01
        DAA                              ;FC90: 19
        LDU     ME801                    ;FC91: FE E8 01
        FCB     $18                      ;FC94: 18
        NEG     M0002                    ;FC95: 00 02
        FCB     $02                      ;FC97: 02
        ROLB                             ;FC98: 59
        STD     MA802                    ;FC99: FD A8 02
        ASLB                             ;FC9C: 58
        FCB     $01                      ;FC9D: 01
        NEG     Z0000                    ;FC9E: 00 00
        NEG     Z0000                    ;FCA0: 00 00
        NEG     Z0000                    ;FCA2: 00 00
        NEG     Z0000                    ;FCA4: 00 00
        NEG     M0010                    ;FCA6: 00 10
        NEG     M0010                    ;FCA8: 00 10
        FCB     $10                      ;FCAA: 10
        FCB     $10                      ;FCAB: 10
        FCB     $10                      ;FCAC: 10
        NEG     Z0000                    ;FCAD: 00 00
        NEG     Z0000                    ;FCAF: 00 00
        NEG     M0050                    ;FCB1: 00 50
        BVC     ZFCC9                    ;FCB3: 28 14
        NEG     M0028                    ;FCB5: 00 28
ZFCB7   BVC     ZFCB7                    ;FCB7: 28 FE
ZFCB9   BVC     ZFCB9                    ;FCB9: 28 FE
        BVC     ZFCE5                    ;FCBB: 28 28
        NEG     M0010                    ;FCBD: 00 10
        LDD     M127C                    ;FCBF: FC 12 7C
        SUBA    M007C                    ;FCC2: 90 7C
        FCB     $10                      ;FCC4: 10
        NEG     Z0000                    ;FCC5: 00 00
        RORA                             ;FCC7: 46
        BNE     ZFCDA                    ;FCC8: 26 10
        ASL     M0064                    ;FCCA: 08 64
        FCB     $62                      ;FCCC: 62
        NEG     Z0000                    ;FCCD: 00 00
        ABX                              ;FCCF: 3A
        INCA                             ;FCD0: 4C
        DECA                             ;FCD1: 4A
        LEAX    $08,U                    ;FCD2: 30 48
        LEAX    $00,X                    ;FCD4: 30 00
        NEG     Z0000                    ;FCD6: 00 00
        NEG     Z0000                    ;FCD8: 00 00
ZFCDA   FCB     $18                      ;FCDA: 18
        INC     M000C                    ;FCDB: 0C 0C
        NEG     Z0000                    ;FCDD: 00 00
        ASL     M0010                    ;FCDF: 08 10
        FCB     $10                      ;FCE1: 10
        FCB     $10                      ;FCE2: 10
        FCB     $10                      ;FCE3: 10
        ASL     Z0000                    ;FCE4: 08 00
        NEG     M0010                    ;FCE6: 00 10
        ASL     M0008                    ;FCE8: 08 08
        ASL     M0008                    ;FCEA: 08 08
        FCB     $10                      ;FCEC: 10
        NEG     Z0000                    ;FCED: 00 00
        LSRB                             ;FCEF: 54
        FCB     $38                      ;FCF0: 38
        INC     -$08,Y                   ;FCF1: 6C 38
        LSRB                             ;FCF3: 54
        fcb     $00
MFCF5   fcb     $00
        fcb     $00
        fcb     $10
        fcb     $10                      ;FCF8: 10
        INC     M1010                    ;FCF9: 7C 10 10
        NEG     Z0000                    ;FCFC: 00 00
        NEG     M0010                    ;FCFE: 00 10
        INC     M000C                    ;FD00: 0C 0C
        NEG     Z0000                    ;FD02: 00 00
        NEG     Z0000                    ;FD04: 00 00
        NEG     Z0000                    ;FD06: 00 00
        NEG     M007C                    ;FD08: 00 7C
        NEG     Z0000                    ;FD0A: 00 00
        NEG     Z0000                    ;FD0C: 00 00
        NEG     M0018                    ;FD0E: 00 18
        FCB     $18                      ;FD10: 18
        NEG     Z0000                    ;FD11: 00 00
        NEG     Z0000                    ;FD13: 00 00
        NEG     M0080                    ;FD15: 00 80
        NEGA                             ;FD17: 40
        BRA     ZFD2A                    ;FD18: 20 10
        ASL     M0004                    ;FD1A: 08 04
        FCB     $02                      ;FD1C: 02
        FCB     $01                      ;FD1D: 01
        NEG     M003C                    ;FD1E: 00 3C
        FCB     $62                      ;FD20: 62
        FCB     $52                      ;FD21: 52
        DECA                             ;FD22: 4A
        RORA                             ;FD23: 46
        CWAI    #$00                     ;FD24: 3C 00
        NEG     M003C                    ;FD26: 00 3C
        ASL     M0008                    ;FD28: 08 08
ZFD2A   BVC     ZFD44                    ;FD2A: 28 18
        ASL     Z0000                    ;FD2C: 08 00
        NEG     Z007E                    ;FD2E: 00 7E
        NEGA                             ;FD30: 40
        CWAI    #$02                     ;FD31: 3C 02
        FCB     $42                      ;FD33: 42
        CWAI    #$00                     ;FD34: 3C 00
        NEG     M003C                    ;FD36: 00 3C
        FCB     $42                      ;FD38: 42
        FCB     $02                      ;FD39: 02
        ANDCC   #$42                     ;FD3A: 1C 42
        CWAI    #$00                     ;FD3C: 3C 00
        NEG     M0004                    ;FD3E: 00 04
        JMP     Z2414                    ;FD40: 7E 24 14
        INC     M0004                    ;FD43: 0C 04
        NEG     Z0000                    ;FD45: 00 00
        CWAI    #$42                     ;FD47: 3C 42
        FCB     $02                      ;FD49: 02
        INC     M407E                    ;FD4A: 7C 40 7E
        NEG     Z0000                    ;FD4D: 00 00
        CWAI    #$42                     ;FD4F: 3C 42
        FCB     $42                      ;FD51: 42
        INC     M201C                    ;FD52: 7C 20 1C
        NEG     Z0000                    ;FD55: 00 00
        NEGA                             ;FD57: 40
        BRA     ZFD6A                    ;FD58: 20 10
        ASL     M0004                    ;FD5A: 08 04
        JMP     >Z0000                   ;FD5C: 7E 00 00
        CWAI    #$42                     ;FD5F: 3C 42
        FCB     $42                      ;FD61: 42
        CWAI    #$42                     ;FD62: 3C 42
        CWAI    #$00                     ;FD64: 3C 00
        NEG     M0038                    ;FD66: 00 38
        LSR     M003E                    ;FD68: 04 3E
ZFD6A   FCB     $42                      ;FD6A: 42
        FCB     $42                      ;FD6B: 42
        CWAI    #$00                     ;FD6C: 3C 00
        NEG     M0018                    ;FD6E: 00 18
        FCB     $18                      ;FD70: 18
        NEG     M0018                    ;FD71: 00 18
        FCB     $18                      ;FD73: 18
        NEG     Z0000                    ;FD74: 00 00
        FCB     $10                      ;FD76: 10
        INC     Z0000                    ;FD77: 0C 00
        INC     M000C                    ;FD79: 0C 0C
        NEG     Z0000                    ;FD7B: 00 00
        NEG     Z0000                    ;FD7D: 00 00
        ASL     M0010                    ;FD7F: 08 10
        BRA     ZFDA3                    ;FD81: 20 20
        FCB     $10                      ;FD83: 10
        ASL     Z0000                    ;FD84: 08 00
        NEG     Z0000                    ;FD86: 00 00
        JMP     >Z007E                   ;FD88: 7E 00 7E
        NEG     Z0000                    ;FD8B: 00 00
        NEG     Z0000                    ;FD8D: 00 00
        FCB     $10                      ;FD8F: 10
        ASL     M0004                    ;FD90: 08 04
        LSR     M0008                    ;FD92: 04 08
        FCB     $10                      ;FD94: 10
        NEG     Z0000                    ;FD95: 00 00
        ASL     Z0000                    ;FD97: 08 00
        ASL     M0004                    ;FD99: 08 04
        BHI     ZFDB9                    ;FD9B: 22 1C
        NEG     Z0000                    ;FD9D: 00 00
        fcb     '>                       ;FD9F: 3E
        fcb     $5C                      ;FDA0: 5C
        FCB     $52                      ;FDA1: 52
        FCB     $5E                      ;FDA2: 5E
ZFDA3   FCB     $42                      ;FDA3: 42
        CWAI    #$00                     ;FDA4: 3C 00
        NEG     M0042                    ;FDA6: 00 42
        FCB     $42                      ;FDA8: 42
        JMP     Z4224                    ;FDA9: 7E 42 24
        FCB     $18                      ;FDAC: 18
        NEG     Z0000                    ;FDAD: 00 00
        JMP     Z2222                    ;FDAF: 7E 22 22
        CWAI    #$22                     ;FDB2: 3C 22
        INC     >Z0000                   ;FDB4: 7C 00 00
        CWAI    #$42                     ;FDB7: 3C 42
ZFDB9   NEGA                             ;FDB9: 40
        NEGA                             ;FDBA: 40
        FCB     $42                      ;FDBB: 42
        CWAI    #$00                     ;FDBC: 3C 00
        NEG     M007C                    ;FDBE: 00 7C
        BHI     ZFDE4                    ;FDC0: 22 22
        BHI     ZFDE6                    ;FDC2: 22 22
        INC     >Z0000                   ;FDC4: 7C 00 00
        JMP     Z4040                    ;FDC7: 7E 40 40
        ASL     M407E                    ;FDCA: 78 40 7E
        NEG     Z0000                    ;FDCD: 00 00
        NEGA                             ;FDCF: 40
        NEGA                             ;FDD0: 40
        NEGA                             ;FDD1: 40
        ASL     M407E                    ;FDD2: 78 40 7E
        NEG     Z0000                    ;FDD5: 00 00
        CWAI    #$42                     ;FDD7: 3C 42
        FCB     $4E                      ;FDD9: 4E
        NEGA                             ;FDDA: 40
        FCB     $42                      ;FDDB: 42
        CWAI    #$00                     ;FDDC: 3C 00
        NEG     M0042                    ;FDDE: 00 42
        FCB     $42                      ;FDE0: 42
        FCB     $42                      ;FDE1: 42
        JMP     Z4242                    ;FDE2: 7E 42 42
        NEG     Z0000                    ;FDE5: 00 00
        FCB     $38                      ;FDE7: 38
        FCB     $10                      ;FDE8: 10
        FCB     $10                      ;FDE9: 10
        FCB     $10                      ;FDEA: 10
        FCB     $10                      ;FDEB: 10
        FCB     $38                      ;FDEC: 38
        NEG     Z0000                    ;FDED: 00 00
        CWAI    #$42                     ;FDEF: 3C 42
        FCB     $02                      ;FDF1: 02
        FCB     $02                      ;FDF2: 02
        FCB     $02                      ;FDF3: 02
        FCB     $02                      ;FDF4: 02
        NEG     Z0000                    ;FDF5: 00 00
        LSRA                             ;FDF7: 44
        ASLA                             ;FDF8: 48
        NEGB                             ;FDF9: 50
        NEG     M4844                    ;FDFA: 70 48 44
        NEG     Z0000                    ;FDFD: 00 00
        JMP     Z4040                    ;FDFF: 7E 40 40
        NEGA                             ;FE02: 40
        NEGA                             ;FE03: 40
        NEGA                             ;FE04: 40
        NEG     Z0000                    ;FE05: 00 00
        FCB     $42                      ;FE07: 42
        FCB     $42                      ;FE08: 42
        FCB     $42                      ;FE09: 42
        DECB                             ;FE0A: 5A
        ROR     $02,U                    ;FE0B: 66 42
        NEG     Z0000                    ;FE0D: 00 00
        FCB     $42                      ;FE0F: 42
        RORA                             ;FE10: 46
        DECA                             ;FE11: 4A
        FCB     $52                      ;FE12: 52
        FCB     $62                      ;FE13: 62
        FCB     $42                      ;FE14: 42
        NEG     Z0000                    ;FE15: 00 00
        CWAI    #$42                     ;FE17: 3C 42
        FCB     $42                      ;FE19: 42
        FCB     $42                      ;FE1A: 42
        FCB     $42                      ;FE1B: 42
        CWAI    #$00                     ;FE1C: 3C 00
        NEG     M0040                    ;FE1E: 00 40
        NEGA                             ;FE20: 40
        INC     Z4242                    ;FE21: 7C 42 42
        INC     >Z0000                   ;FE24: 7C 00 00
        ABX                              ;FE27: 3A
        LSRA                             ;FE28: 44
        DECA                             ;FE29: 4A
        FCB     $42                      ;FE2A: 42
        FCB     $42                      ;FE2B: 42
        CWAI    #$00                     ;FE2C: 3C 00
        NEG     M0042                    ;FE2E: 00 42
        LSRA                             ;FE30: 44
        INC     Z4242                    ;FE31: 7C 42 42
        INC     >Z0000                   ;FE34: 7C 00 00
        CWAI    #$42                     ;FE37: 3C 42
        FCB     $02                      ;FE39: 02
        CWAI    #$40                     ;FE3A: 3C 40
        CWAI    #$00                     ;FE3C: 3C 00
        NEG     M0010                    ;FE3E: 00 10
        FCB     $10                      ;FE40: 10
        FCB     $10                      ;FE41: 10
        FCB     $10                      ;FE42: 10
        FCB     $10                      ;FE43: 10
        INC     >Z0000                   ;FE44: 7C 00 00
        CWAI    #$42                     ;FE47: 3C 42
        FCB     $42                      ;FE49: 42
        FCB     $42                      ;FE4A: 42
        FCB     $42                      ;FE4B: 42
        FCB     $42                      ;FE4C: 42
        NEG     Z0000                    ;FE4D: 00 00
        FCB     $18                      ;FE4F: 18
        BCC     ZFE76                    ;FE50: 24 24
        FCB     $42                      ;FE52: 42
        FCB     $42                      ;FE53: 42
        FCB     $42                      ;FE54: 42
        NEG     Z0000                    ;FE55: 00 00
        FCB     $42                      ;FE57: 42
        ROR     -$06,U                   ;FE58: 66 5A
        FCB     $42                      ;FE5A: 42
        FCB     $42                      ;FE5B: 42
        FCB     $42                      ;FE5C: 42
        NEG     Z0000                    ;FE5D: 00 00
        FCB     $42                      ;FE5F: 42
        BCC     ZFE7A                    ;FE60: 24 18
        FCB     $18                      ;FE62: 18
        BCC     ZFEA7                    ;FE63: 24 42
        NEG     Z0000                    ;FE65: 00 00
        FCB     $10                      ;FE67: 10
        FCB     $10                      ;FE68: 10
        FCB     $10                      ;FE69: 10
        LBVC    Z426E                    ;FE6A: 10 28 44 00
        NEG     Z007E                    ;FE6E: 00 7E
        BRA     ZFE82                    ;FE70: 20 10
        ASL     M0004                    ;FE72: 08 04
        JMP     >Z0000                   ;FE74: 7E 00 00
        FCB     $38                      ;FE77: 38
        BRA     ZFE9A                    ;FE78: 20 20
ZFE7A   BRA     ZFE9C                    ;FE7A: 20 20
        FCB     $38                      ;FE7C: 38
        NEG     M0001                    ;FE7D: 00 01
        FCB     $02                      ;FE7F: 02
        LSR     M0008                    ;FE80: 04 08
ZFE82   FCB     $10                      ;FE82: 10
        BRA     ZFEC5                    ;FE83: 20 40
        SUBA    #$00                     ;FE85: 80 00
        ANDCC   #$04                     ;FE87: 1C 04
        LSR     M0004                    ;FE89: 04 04
        LSR     M001C                    ;FE8B: 04 1C
        NEG     Z0000                    ;FE8D: 00 00
        FCB     $10                      ;FE8F: 10
        FCB     $10                      ;FE90: 10
        FCB     $10                      ;FE91: 10
        INC     M3810                    ;FE92: 7C 38 10
        NEG     M00FF                    ;FE95: 00 FF
        NEG     Z0000                    ;FE97: 00 00
        NEG     Z0000                    ;FE99: 00 00
        NEG     Z0000                    ;FE9B: 00 00
        NEG     Z0000                    ;FE9D: 00 00
        NEG     Z0000                    ;FE9F: 00 00
        NEG     M00FF                    ;FEA1: 00 FF
        NEG     Z0000                    ;FEA3: 00 00
        NEG     Z0000                    ;FEA5: 00 00
ZFEA7   ABX                              ;FEA7: 3A
        LSRA                             ;FEA8: 44
        FCB     $38                      ;FEA9: 38
        LSR     M0038                    ;FEAA: 04 38
        NEG     Z0000                    ;FEAC: 00 00
        NEG     M005C                    ;FEAE: 00 5C
        FCB     $62                      ;FEB0: 62
        FCB     $42                      ;FEB1: 42
        FCB     $62                      ;FEB2: 62
        INCB                             ;FEB3: 5C
        NEGA                             ;FEB4: 40
        NEG     Z0000                    ;FEB5: 00 00
        CWAI    #$42                     ;FEB7: 3C 42
        NEGA                             ;FEB9: 40
        FCB     $42                      ;FEBA: 42
        CWAI    #$00                     ;FEBB: 3C 00
        NEG     Z0000                    ;FEBD: 00 00
        ABX                              ;FEBF: 3A
        RORA                             ;FEC0: 46
        FCB     $42                      ;FEC1: 42
        RORA                             ;FEC2: 46
        ABX                              ;FEC3: 3A
        FCB     $02                      ;FEC4: 02
ZFEC5   NEG     Z0000                    ;FEC5: 00 00
        CWAI    #$40                     ;FEC7: 3C 40
        JMP     Z423C                    ;FEC9: 7E 42 3C
        NEG     Z0000                    ;FECC: 00 00
        NEG     M0010                    ;FECE: 00 10
        FCB     $10                      ;FED0: 10
        INC     M1012                    ;FED1: 7C 10 12
        INC     Z0000                    ;FED4: 0C 00
        CWAI    #$02                     ;FED6: 3C 02
        ABX                              ;FED8: 3A
        RORA                             ;FED9: 46
        RORA                             ;FEDA: 46
        CWAI    #$00                     ;FEDB: 3C 00
        NEG     Z0000                    ;FEDD: 00 00
        FCB     $42                      ;FEDF: 42
        FCB     $42                      ;FEE0: 42
        FCB     $42                      ;FEE1: 42
        FCB     $62                      ;FEE2: 62
        INCB                             ;FEE3: 5C
        NEGA                             ;FEE4: 40
        NEG     Z0000                    ;FEE5: 00 00
        ANDCC   #$08                     ;FEE7: 1C 08
        ASL     M0008                    ;FEE9: 08 08
        FCB     $18                      ;FEEB: 18
        NEG     M0008                    ;FEEC: 00 08
        FCB     $38                      ;FEEE: 38
        LSRA                             ;FEEF: 44
        LSR     M0004                    ;FEF0: 04 04
        LSR     M0004                    ;FEF2: 04 04
        NEG     M0004                    ;FEF4: 00 04
        NEG     M0022                    ;FEF6: 00 22
        PSHS    Y,DP                     ;FEF8: 34 28
        BCC     ZFF1E                    ;FEFA: 24 22
        BRA     ZFEFE                    ;FEFC: 20 00
ZFEFE   NEG     M001C                    ;FEFE: 00 1C
        ASL     M0008                    ;FF00: 08 08
        ASL     M0008                    ;FF02: 08 08
        FCB     $18                      ;FF04: 18
        NEG     Z0000                    ;FF05: 00 00
        SBCA    M0092                    ;FF07: 92 92
        SBCA    M00DA                    ;FF09: 92 DA
        ANDA    $00,X                    ;FF0B: A4 00
        NEG     Z0000                    ;FF0D: 00 00
        BHI     ZFF33                    ;FF0F: 22 22
        BHI     ZFF45                    ;FF11: 22 32
        INCA                             ;FF13: 4C
        NEG     Z0000                    ;FF14: 00 00
        NEG     M003C                    ;FF16: 00 3C
MFF18   FCB     $42                      ;FF18: 42
        FCB     $42                      ;FF19: 42
        FCB     $42                      ;FF1A: 42
        CWAI    #$00                     ;FF1B: 3C 00
        NEG     M0040                    ;FF1D: 00 40
        INCB                             ;FF1F: 5C
        FCB     $62                      ;FF20: 62
        FCB     $42                      ;FF21: 42
        FCB     $62                      ;FF22: 62
        INCB                             ;FF23: 5C
        NEG     Z0000                    ;FF24: 00 00
        FCB     $02                      ;FF26: 02
        ABX                              ;FF27: 3A
        RORA                             ;FF28: 46
        RORA                             ;FF29: 46
        RORA                             ;FF2A: 46
        ABX                              ;FF2B: 3A
        NEG     Z0000                    ;FF2C: 00 00
        NEG     M0040                    ;FF2E: 00 40
        NEGA                             ;FF30: 40
        NEGA                             ;FF31: 40
        FCB     $62                      ;FF32: 62
ZFF33   INCB                             ;FF33: 5C
        NEG     Z0000                    ;FF34: 00 00
        NEG     M007C                    ;FF36: 00 7C
        FCB     $02                      ;FF38: 02
        CWAI    #$40                     ;FF39: 3C 40
        CWAI    #$00                     ;FF3B: 3C 00
        NEG     Z0000                    ;FF3D: 00 00
        INC     M0012                    ;FF3F: 0C 12
        FCB     $10                      ;FF41: 10
        FCB     $10                      ;FF42: 10
        FCB     $38                      ;FF43: 38
        FCB     $10                      ;FF44: 10
ZFF45   NEG     Z0000                    ;FF45: 00 00
        ABX                              ;FF47: 3A
        RORA                             ;FF48: 46
        FCB     $42                      ;FF49: 42
        FCB     $42                      ;FF4A: 42
        FCB     $42                      ;FF4B: 42
        NEG     Z0000                    ;FF4C: 00 00
        NEG     M0018                    ;FF4E: 00 18
        BCC     ZFF94                    ;FF50: 24 42
        FCB     $42                      ;FF52: 42
        FCB     $42                      ;FF53: 42
        NEG     Z0000                    ;FF54: 00 00
        NEG     M0024                    ;FF56: 00 24
        DECB                             ;FF58: 5A
        FCB     $42                      ;FF59: 42
        FCB     $42                      ;FF5A: 42
        FCB     $42                      ;FF5B: 42
        NEG     Z0000                    ;FF5C: 00 00
        NEG     M0042                    ;FF5E: 00 42
        BCC     ZFF7A                    ;FF60: 24 18
        BCC     ZFFA6                    ;FF62: 24 42
        NEG     Z0000                    ;FF64: 00 00
        CWAI    #$42                     ;FF66: 3C 42
        ORCC    #$66                     ;FF68: 1A 66
        FCB     $42                      ;FF6A: 42
        FCB     $42                      ;FF6B: 42
        NEG     Z0000                    ;FF6C: 00 00
        NEG     Z007E                    ;FF6E: 00 7E
        BRA     ZFF8A                    ;FF70: 20 18
        LSR     Z007E                    ;FF72: 04 7E
        NEG     Z0000                    ;FF74: 00 00
        INC     M0008                    ;FF76: 0C 08
        ASL     M0010                    ;FF78: 08 10
ZFF7A   ASL     M0008                    ;FF7A: 08 08
        INC     Z0000                    ;FF7C: 0C 00
        FCB     $10                      ;FF7E: 10
        FCB     $10                      ;FF7F: 10
        FCB     $10                      ;FF80: 10
        FCB     $10                      ;FF81: 10
        FCB     $10                      ;FF82: 10
        FCB     $10                      ;FF83: 10
        FCB     $10                      ;FF84: 10
        FCB     $10                      ;FF85: 10
        LEAX    -$10,X                   ;FF86: 30 10
        FCB     $10                      ;FF88: 10
        ASL     M0010                    ;FF89: 08 10
        FCB     $10                      ;FF8B: 10
        LEAX    $00,X                    ;FF8C: 30 00
        NEG     Z0000                    ;FF8E: 00 00
        NEG     Z0000                    ;FF90: 00 00
        NEG     Z0000                    ;FF92: 00 00
ZFF94   NEG     M00FF                    ;FF94: 00 FF
        STU     MFFFF                    ;FF96: FF FF FF
        STU     MFFFF                    ;FF99: FF FF FF
        STU     MFF18                    ;FF9C: FF FF 18
        CWAI    #$42                     ;FF9F: 3C 42
        NEGA                             ;FFA1: 40
        FCB     $42                      ;FFA2: 42
        CWAI    #$00                     ;FFA3: 3C 00
        NEG     Z0000                    ;FFA5: 00 00
        NEG     Z0000                    ;FFA7: 00 00
        NEG     Z0000                    ;FFA9: 00 00
        NEG     M0018                    ;FFAB: 00 18
        LEAX    $00,X                    ;FFAD: 30 00
        NEG     Z0000                    ;FFAF: 00 00
        NEG     Z0000                    ;FFB1: 00 00
        NEG     M0018                    ;FFB3: 00 18
        INC     Z0000                    ;FFB5: 0C 00
        NEG     Z0000                    ;FFB7: 00 00
        NEG     Z0000                    ;FFB9: 00 00
        NEG     M0024                    ;FFBB: 00 24
        FCB     $18                      ;FFBD: 18
        NEG     Z0000                    ;FFBE: 00 00
        NEG     Z0000                    ;FFC0: 00 00
        NEG     Z0000                    ;FFC2: 00 00
        NEG     M0066                    ;FFC4: 00 66
        FCB     $1B                      ;FFC6: 1B
        NEG     -$10,S                   ;FFC7: 60 70
        INC     M0014                    ;FFC9: 0C 14
        fcb     $1F
        fcb     'L
        LSRB                             ;FFCD: 54
        FCB     $1B                      ;FFCE: 1B
        COM     M7C1B                    ;FFCF: 73 7C 1B
        NEG     >M001B                   ;FFD2: 70 00 1B
        ROR     $06,U                    ;FFD5: 66 46
        INC     M0035                    ;FFD7: 0C 35
        NEGA                             ;FFD9: 40
        STU     M0082                    ;FFDA: DF 82
        LDA     ,U                       ;FFDC: A6 C4
        STA     M0080                    ;FFDE: 97 80
        RTS                              ;FFE0: 39

        JSR     ZCBED                    ;FFE1: BD CB ED
        BSR     ZFFE9                    ;FFE4: 8D 03
        JSR     ZCB83                    ;FFE6: BD CB 83
ZFFE9   JMP     ZCBF9                    ;FFE9: 7E CB F9
        LDD     MEE97,PCR                ;FFEC: EC ED EE A7
        NEG     Z0000                    ;FFF0: 00 00

svec_SWI3 FDB     hdlr_NMI                 ;FFF2: F0 AD
svec_SWI2 FDB     hdlr_NMI                 ;FFF4: F0 AD
svec_FIRQ FDB     hdlr_FIRQ                ;FFF6: F6 42
svec_IRQ FDB     hdlr_IRQ                 ;FFF8: F6 57
svec_SWI FDB     hdlr_SWI                 ;FFFA: F6 3E
svec_NMI FDB     hdlr_NMI                 ;FFFC: F0 AD
svec_RST FDB     hdlr_RST                 ;FFFE: F0 03

        END
