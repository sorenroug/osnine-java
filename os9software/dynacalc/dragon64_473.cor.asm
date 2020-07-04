*
* TRM file for the Dragon 64
* Uses the GO51 terminal and the help texts are shortened to fit.
*
* The original file seems to be a memory dump of a running program.
* It has several spreadsheet cells that are unused.
* The drg_junk file(s) retain that to ensure the exact file can be
* reconstructed.
 ifp1
 use defsfile
 use dynacalc_473.inc
 endc
 opt m
 org 0
ISSUE set CUSTOM
 use header_473.inc
 use go51.keys
 use rest_473.inc

 use drg_junk4.inc
 use helps_473.inc
LANG set LGENUK
 use help51.inc
 use drg_junk6.inc
