; Test program to write alphabet to address B0000
2000 LDA #$41
2002 STA #$B000
2005 INCA
2006 CMPA #$5B
2008 BNE $F8
200A RMB $38
